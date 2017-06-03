﻿#region

using System;
using System.Globalization;
using System.IO;
using System.Threading;
using db;
using log4net;
using log4net.Config;
using wServer.networking;
using wServer.realm;
using System.Net.Mail;
using System.Net;

#endregion

namespace wServer
{
    internal static class Program
    {
        public static bool WhiteList { get; private set; }
        public static bool Verify { get; private set; }
        internal static SimpleSettings Settings;
        public static readonly DateTime StartTime = DateTime.Now;

        private static readonly ILog log = LogManager.GetLogger("Server");
        private static RealmManager manager;

        public static DateTime WhiteListTurnOff { get; private set; }

        private static void Main(string[] args)
        {
            Console.Title = "wServer";
            try
            {
                XmlConfigurator.ConfigureAndWatch(new FileInfo("log4net_wServer.config"));

                Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
                Thread.CurrentThread.Name = "Entry";

                Settings = new SimpleSettings("wServer");
                new Database();

                manager = new RealmManager(
                    Settings.GetValue<int>("maxClients", "50"),
                    Settings.GetValue<int>("tps", "20"));

                WhiteList = Settings.GetValue<bool>("whiteList", "false");
                Verify = Settings.GetValue<bool>("verifyEmail", "false");
                WhiteListTurnOff = Settings.GetValue<DateTime>("whitelistTurnOff");

                manager.Initialize();
                manager.Run();

                Server server = new Server(manager);
                PolicyServer policy = new PolicyServer();

                Console.CancelKeyPress += (sender, e) => e.Cancel = true;
                
                policy.Start();
                server.Start();
                new Thread(AutoNotify).Start();
                if(Settings.GetValue<bool>("broadcastNews", "false") && File.Exists("news.txt"))
                    new Thread(autoBroadcastNews).Start();
                log.Info("Server initialized.");

                uint key = 0;
                while ((key = (uint)Console.ReadKey(true).Key) != (uint)ConsoleKey.Escape)
                {
                    if (key == (2 | 80))
                        Settings.Reload();
                }

                log.Info("Terminating...");
                server.Stop();
                policy.Stop();
                manager.Stop();
                log.Info("Server terminated.");
            }
            catch (Exception e)
            {
                log.Fatal(e);

                foreach (var c in manager.Clients)
                {
                    c.Value.Disconnect();
                }
                Console.ReadLine();
            }
        }

        

        private static void AutoNotify()
        {
            int uptime = 0;
            while (true)
            {
                ChatManager cm = new ChatManager(manager);
                if ((uptime < 55)  && (uptime >= 0))
                {
                    uptime += 1;
                    Thread.Sleep(1 * (60 * 1000));
                }
                else if ((uptime >= 55) && (uptime <= 59))
                {
                    cm.Announce("This server going to restart in 5 minutes.");
                    Thread.Sleep(1 * (60 * 1000));
                    uptime += 1;
                }
            }
        }

        public static void SendEmail(MailMessage message, bool enableSsl = true)
        {
            SmtpClient client = new SmtpClient
            {
                Host = Settings.GetValue<string>("smtpHost", "smtp.gmail.com"),
                Port = Settings.GetValue<int>("smtpPort", "587"),
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                EnableSsl = true,
                Credentials =
                    new NetworkCredential(Settings.GetValue<string>("serverEmail"),
                        Settings.GetValue<string>("serverEmailPassword"))
            };

            client.Send(message);
        }

        private static void autoBroadcastNews()
        {
                var news = File.ReadAllLines("news.txt");
                do
                {
                    ChatManager cm = new ChatManager(manager);
                    cm.News(news[new Random().Next(news.Length)]);
                    Thread.Sleep(300000);
                }
                while (true);
            }
    }
}