package kabam.rotmg.ui.commands
{
import kabam.rotmg.account.core.Account;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import flash.display.Sprite;
import com.company.assembleegameclient.account.ui.NewChooseNameFrame;
import kabam.rotmg.ui.view.ChooseNameRegisterDialog;

public class ChooseNameCommand
{

    [Inject]
    public var account:Account;

    [Inject]
    public var openDialog:OpenDialogSignal;

    public function ChooseNameCommand()
    {
        super();
    }

    public function execute() : void
    {
        var _local1:Sprite = null;
        if(this.account.isRegistered())
        {
            _local1 = new NewChooseNameFrame();
        }
        else
        {
            _local1 = new ChooseNameRegisterDialog();
        }
        this.openDialog.dispatch(_local1);
    }
}
}
