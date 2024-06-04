local var0 = class("RegisterPanelView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "RegisterPanelView"
end

function var0.OnLoaded(arg0)
	return
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.OnInit(arg0)
	arg0.registerPanel = arg0._tf
	arg0.registerUsername = arg0:findTF("account/username", arg0.registerPanel)
	arg0.cancelButton = arg0:findTF("cancel_button", arg0.registerPanel)
	arg0.confirmButton = arg0:findTF("confirm_button", arg0.registerPanel)

	arg0:InitEvent()
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.confirmButton, function()
		local var0 = getInputText(arg0.registerUsername)

		if var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_error_noUserName"))
			ActivateInputField(arg0.registerUsername)

			return
		end

		local var1 = User.New({
			arg3 = "",
			arg2 = "",
			type = 2,
			arg1 = var0
		})

		if var1 then
			arg0.event:emit(LoginMediator.ON_REGISTER, var1)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.cancelButton, function()
		arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
		})
	end, SFX_CANCEL)
end

function var0.Clear(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0
