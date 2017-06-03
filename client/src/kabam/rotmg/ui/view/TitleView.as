package kabam.rotmg.ui.view {
import com.company.assembleegameclient.screens.AccountScreen;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.SoundIcon;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;
import com.company.assembleegameclient.LOEBUILD_166e64f6c3677d0c513901242a3e702d.LOEBUILD_3225a10b07f1580f10dee4abc3779e6c;

import kabam.rotmg.errors.control.LOEBUILD_5c3fafb478917eee32f80d979a87cb36;

import kabam.rotmg.account.transfer.view.KabamLoginView;
import kabam.rotmg.application.model.PlatformModel;
import kabam.rotmg.application.model.PlatformType;
import kabam.rotmg.core.StaticInjectorContext;
import com.google.analytics.v4.LOEBUILD_9e66824be5912020ae4304d695ae300a;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.model.EnvironmentData;
import kabam.rotmg.ui.view.components.DarkLayer;
import kabam.rotmg.ui.view.components.MapBackground;
import kabam.rotmg.ui.view.components.MenuOptionsBar;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class TitleView extends Sprite {

      static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;

      public static const MIDDLE_OF_BOTTOM_BAND:Number = 589.45;

      public static var queueEmailConfirmation:Boolean = false;

      public static var queuePasswordPrompt:Boolean = false;

      public static var queuePasswordPromptFull:Boolean = false;

      public static var queueRegistrationPrompt:Boolean = false;

      public static var kabammigrateOpened:Boolean = false;

      private var versionText:TextFieldDisplayConcrete;

      private var copyrightText:TextFieldDisplayConcrete;

      private var menuOptionsBar:MenuOptionsBar;

      private var data:EnvironmentData;

      public var playClicked:Signal;

      public var serversClicked:Signal;

      public var accountClicked:Signal;

      public var legendsClicked:Signal;

      public var languagesClicked:Signal;

      public var supportClicked:Signal;

      public var kabamTransferClicked:Signal;

      public var editorClicked:Signal;

      public var quitClicked:Signal;

      public var optionalButtonsAdded:Signal;

      private var migrateButton:TitleMenuOption;

      public function TitleView() {
         var _local2:String = null;
         this.menuOptionsBar = this.makeMenuOptionsBar();
         this.optionalButtonsAdded = new Signal();
         super();
         //addChild(new MapBackground());
         addChild(new DarkLayer());
         addChild(new TitleScreenGraphic());
         addChild(this.menuOptionsBar);
         addChild(new AccountScreen());
         this.makeChildren();
         addChild(new SoundIcon());
         var _local1:PlatformModel = StaticInjectorContext.getInjector().getInstance(PlatformModel);
         if(_local1.getPlatform() == PlatformType.WEB) {
            this.makeMigrateButton();
            addChild(this.migrateButton);
            _local2 = "";
            try {
               _local2 = ExternalInterface.call("window.location.search.substring",1);
            }
            catch(err:Error) {
            }
            if(Boolean(!kabammigrateOpened) && Boolean(_local2) && _local2 == "kabammigrate") {
               kabammigrateOpened = true;
               //this.openKabamTransferView();
            }
         } else if(_local1.getPlatform() == PlatformType.KABAM) {
            this.makeMigrateButton();
            addChild(this.migrateButton);
         }
      }

      public function openKabamTransferView() : void {
         var _local1:OpenDialogSignal = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
         _local1.dispatch(new KabamLoginView());
      }

      private function makeMenuOptionsBar() : MenuOptionsBar {
         var _local1:TitleMenuOption = ButtonFactory.getPlayButton();
         var _local2:TitleMenuOption = ButtonFactory.getServersButton();
         var _local3:TitleMenuOption = ButtonFactory.getAccountButton();
         // update 7.32.451X
          // var _local4:TitleMenuOption = ButtonFactory.getLegendsButton();
         var _local5:TitleMenuOption = ButtonFactory.getSupportButton();
         this.playClicked = _local1.clicked;
         this.serversClicked = _local2.clicked;
         this.accountClicked = _local3.clicked;
         //this.legendsClicked = _local4.clicked;
         this.supportClicked = _local5.clicked;
         var _local6:MenuOptionsBar = new MenuOptionsBar();
         _local6.addButton(_local1,MenuOptionsBar.CENTER);
         _local6.addButton(_local2,MenuOptionsBar.LEFT);
         _local6.addButton(_local5,MenuOptionsBar.LEFT);
         _local6.addButton(_local3,MenuOptionsBar.RIGHT);
         //_local6.addButton(_local4,MenuOptionsBar.RIGHT);
         return _local6;
      }

      private function makeChildren() : void {
         this.versionText = makeText().setHTML(true).setAutoSize(TextFieldAutoSize.LEFT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         this.versionText.y = MIDDLE_OF_BOTTOM_BAND;
         addChild(this.versionText);
      }

      public static function makeText() : TextFieldDisplayConcrete {
         var _local1:TextFieldDisplayConcrete = null;
         _local1 = new TextFieldDisplayConcrete().setSize(12).setColor(8355711);
         _local1.filters = [new DropShadowFilter(0,0,0)];
         return _local1;
      }

      public function initialize(param1:EnvironmentData) : void {
         this.data = param1;
         this.updateVersionText();
         this.handleOptionalButtons();
      }

      private function updateVersionText() : void {
         this.versionText.setStringBuilder(new StaticStringBuilder(this.data.buildLabel));
      }

      private function handleOptionalButtons() : void {
         //this.data.isAdmin &&
         this.createEditorButton();
         this.data.isDesktop && this.createQuitButton();
         this.optionalButtonsAdded.dispatch();
      }

      private function createQuitButton() : void {
         var _local1:TitleMenuOption = ButtonFactory.getQuitButton();
         this.menuOptionsBar.addButton(_local1,MenuOptionsBar.RIGHT);
         this.quitClicked = _local1.clicked;
      }

      private function createEditorButton() : void {
         var _local1:TitleMenuOption = ButtonFactory.getEditorButton();
         this.menuOptionsBar.addButton(_local1,MenuOptionsBar.RIGHT);
         this.editorClicked = _local1.clicked;
      }

      private function makeMigrateButton() : void {
         this.migrateButton = new TitleMenuOption("Welcome to LoE Realm! You are playing on build " + LOEBUILD_9e66824be5912020ae4304d695ae300a.LOEBUILD_f80f1ecc62a94ff993708804db5bbdbd + "." + LOEBUILD_9e66824be5912020ae4304d695ae300a.LOEBUILD_bcd70d36f5cceaccaf0481d68e756080 + "." ,16,false);
         this.migrateButton.setAutoSize(TextFieldAutoSize.CENTER);
         this.kabamTransferClicked = new NativeMappedSignal(this.migrateButton,MouseEvent.CLICK);
         this.migrateButton.setTextKey("Welcome to LoE Realm! You are playing on build " + LOEBUILD_9e66824be5912020ae4304d695ae300a.LOEBUILD_f80f1ecc62a94ff993708804db5bbdbd + "." + LOEBUILD_9e66824be5912020ae4304d695ae300a.LOEBUILD_bcd70d36f5cceaccaf0481d68e756080 + ".");
         this.migrateButton.x = 400;
         this.migrateButton.y = 475;//500
      }
   }
}
