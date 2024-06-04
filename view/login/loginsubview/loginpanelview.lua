local var0 = class("LoginPanelView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "LoginPanelView"
end

function var0.OnLoaded(arg0)
	return
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.OnInit(arg0)
	arg0.loginPanel = arg0._tf
	arg0.loginUsername = arg0:findTF("account/username", arg0.loginPanel)
	arg0.loginPassword = arg0:findTF("password/password", arg0.loginPanel)
	arg0.loginButton = arg0:findTF("login_button", arg0.loginPanel)
	arg0.registerButton = arg0:findTF("register_button", arg0.loginPanel)

	arg0:InitEvent()
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.loginButton, function()
		if arg0.shareData.autoLoginEnabled and arg0.shareData.lastLoginUser then
			arg0.event:emit(LoginMediator.ON_LOGIN, arg0.shareData.lastLoginUser)

			return
		end

		local var0 = getInputText(arg0.loginUsername)

		if var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_error_noUserName"))
			ActivateInputField(arg0.loginUsername)

			return
		end

		local var1 = getInputText(arg0.loginPassword) or ""
		local var2 = User.New({
			type = 2,
			arg1 = var0,
			arg2 = var1
		})

		if var2 then
			arg0.event:emit(LoginMediator.ON_LOGIN, var2)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.registerButton, function()
		arg0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
		})
		arg0:emit(LoginSceneConst.CLEAR_REGISTER_VIEW)
	end, SFX_MAIN)
	onInputChanged(arg0, arg0.loginUsername, function()
		arg0.shareData.autoLoginEnabled = false
	end)
	onInputChanged(arg0, arg0.loginPassword, function()
		arg0.shareData.autoLoginEnabled = false
	end)
end

function var0.SetContent(arg0, arg1, arg2)
	setInputText(arg0.loginUsername, arg1)
	setInputText(arg0.loginPassword, arg2)
end

function var0.OnDestroy(arg0)
	return
end

return var0
