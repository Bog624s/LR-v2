package kabam.rotmg.maploading.commands {
import com.company.assembleegameclient.LOEBUILD_1f4c42c309fe6bc45253d598cfdf9b99.LOEBUILD_7ebef6bdf3535c86294f666e62e89578;

import kabam.rotmg.assets.model.Animation;
import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;

public class CharacterAnimationFactory {

      [Inject]
      public var playerModel:PlayerModel;

      [Inject]
      public var factory:CharacterFactory;

      [Inject]
      public var classesModel:ClassesModel;

      private var currentChar:LOEBUILD_7ebef6bdf3535c86294f666e62e89578;

      private var characterClass:CharacterClass;

      private var skin:CharacterSkin;

      private var tex2:int;

      private var tex1:int;

      public function CharacterAnimationFactory() {
         super();
      }

      public function make() : Animation {
         this.currentChar = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         this.characterClass = !!this.currentChar?this.getCurrentCharacterClass():this.getDefaultCharacterClass();
         this.skin = this.characterClass.skins.getSelectedSkin();
         this.tex1 = !!this.currentChar?int(this.currentChar.tex1()):0;
         this.tex2 = !!this.currentChar?int(this.currentChar.tex2()):0;
         return this.factory.makeWalkingIcon(this.skin.template,100,this.tex1,this.tex2);
      }

      private function getDefaultCharacterClass() : CharacterClass {
         return this.classesModel.getSelected();
      }

      private function getCurrentCharacterClass() : CharacterClass {
         return this.classesModel.getCharacterClass(this.currentChar.objectType());
      }
   }
}
