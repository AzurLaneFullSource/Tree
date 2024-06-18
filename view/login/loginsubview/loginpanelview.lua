local var0_0 = class("LoginPanelView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LoginPanelView"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4.loginPanel = arg0_4._tf
	arg0_4.loginUsername = arg0_4:findTF("account/username", arg0_4.loginPanel)
	arg0_4.loginPassword = arg0_4:findTF("password/password", arg0_4.loginPanel)
	arg0_4.loginButton = arg0_4:findTF("login_button", arg0_4.loginPanel)
	arg0_4.registerButton = arg0_4:findTF("register_button", arg0_4.loginPanel)

	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.loginButton, function()
		if arg0_5.shareData.autoLoginEnabled and arg0_5.shareData.lastLoginUser then
			arg0_5.event:emit(LoginMediator.ON_LOGIN, arg0_5.shareData.lastLoginUser)

			return
		end

		local var0_6 = getInputText(arg0_5.loginUsername)

		if var0_6 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_error_noUserName"))
			ActivateInputField(arg0_5.loginUsername)

			return
		end

		local var1_6 = getInputText(arg0_5.loginPassword) or ""
		local var2_6 = User.New({
			type = 2,
			arg1 = var0_6,
			arg2 = var1_6
		})

		if var2_6 then
			arg0_5.event:emit(LoginMediator.ON_LOGIN, var2_6)
		end
	end, SFX_CONFIRM)
	onButton(arg0_5, arg0_5.registerButton, function()
		arg0_5:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
		})
		arg0_5:emit(LoginSceneConst.CLEAR_REGISTER_VIEW)
	end, SFX_MAIN)
	onInputChanged(arg0_5, arg0_5.loginUsername, function()
		arg0_5.shareData.autoLoginEnabled = false
	end)
	onInputChanged(arg0_5, arg0_5.loginPassword, function()
		arg0_5.shareData.autoLoginEnabled = false
	end)
end

function var0_0.SetContent(arg0_10, arg1_10, arg2_10)
	setInputText(arg0_10.loginUsername, arg1_10)
	setInputText(arg0_10.loginPassword, arg2_10)
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
