local var0_0 = class("RegisterPanelView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RegisterPanelView"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4.registerPanel = arg0_4._tf
	arg0_4.registerUsername = arg0_4:findTF("account/username", arg0_4.registerPanel)
	arg0_4.cancelButton = arg0_4:findTF("cancel_button", arg0_4.registerPanel)
	arg0_4.confirmButton = arg0_4:findTF("confirm_button", arg0_4.registerPanel)

	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.confirmButton, function()
		local var0_6 = getInputText(arg0_5.registerUsername)

		if var0_6 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_error_noUserName"))
			ActivateInputField(arg0_5.registerUsername)

			return
		end

		local var1_6 = User.New({
			arg3 = "",
			arg2 = "",
			type = 2,
			arg1 = var0_6
		})

		if var1_6 then
			arg0_5.event:emit(LoginMediator.ON_REGISTER, var1_6)
		end
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.cancelButton, function()
		arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
		})
	end, SFX_CANCEL)
end

function var0_0.Clear(arg0_8)
	return
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
