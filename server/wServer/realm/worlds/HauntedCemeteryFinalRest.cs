﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wServer.realm.worlds
{
    public class HauntedCemeteryFinalBattle : World
    {
        public HauntedCemeteryFinalBattle()
        {
            Name = "Haunted Cemetery Final Battle";
            ClientWorldName = "Haunted Cemetery Final Battle";
            Background = 0;
            Difficulty = 4;
            AllowTeleport = true;
            SetMusic("hauntedcemetery");
        }

        public override bool NeedsPortalKey => true;

        protected override void Init()
        {
            LoadMap("wServer.realm.worlds.maps.1HauntedCemeteryFinalBattle.jm", MapType.Json);
        }
    }
}
