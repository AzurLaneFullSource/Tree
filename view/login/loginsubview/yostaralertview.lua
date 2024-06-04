local var0 = class("YostarAlertView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "YostarAlertView"
end

function var0.OnLoaded(arg0)
	return
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.OnInit(arg0)
	arg0.yostarAlert = arg0._tf
	arg0.yostarEmailTxt = arg0:findTF("email_input_txt", arg0.yostarAlert)
	arg0.yostarCodeTxt = arg0:findTF("code_input_txt", arg0.yostarAlert)
	arg0.yostarGenCodeBtn = arg0:findTF("gen_code_btn", arg0.yostarAlert)
	arg0.yostarGenTxt = arg0:findTF("Text", arg0.yostarGenCodeBtn)
	arg0.yostarSureBtn = arg0:findTF("login_btn", arg0.yostarAlert)
	arg0.email_text = arg0:findTF("title1", arg0.yostarAlert)
	arg0.emailhold_text = arg0:findTF("Placeholder", arg0.yostarEmailTxt)
	arg0.code_text = arg0:findTF("title2", arg0.yostarAlert)
	arg0.codehold_text = arg0:findTF("Placeholder", arg0.yostarCodeTxt)
	arg0.genBtn_text = arg0:findTF("Text", arg0.yostarGenCodeBtn)
	arg0.desc_text = arg0:findTF("desc", arg0.yostarAlert)
	arg0.loginBtn_text = arg0:findTF("Image", arg0.yostarSureBtn)

	setText(arg0.email_text, i18n("email_text"))
	setText(arg0.emailhold_text, i18n("emailhold_text"))
	setText(arg0.code_text, i18n("code_text"))
	setText(arg0.codehold_text, i18n("codehold_text"))
	setText(arg0.genBtn_text, i18n("genBtn_text"))
	setText(arg0.desc_text, i18n("desc_text"))
	setText(arg0.loginBtn_text, arg0.contextData.isLinkMode == true and i18n("linkBtn_text") or i18n("loginBtn_text"))
	arg0:InitEvent()
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.yostarAlert, function()
		setActive(arg0.yostarAlert, false)

		if arg0.contextData.isDestroyOnClose == true then
			arg0:Destroy()
		end
	end)
	onButton(arg0, arg0.yostarGenCodeBtn, function()
		local var0 = getInputText(arg0.yostarEmailTxt)

		if var0 ~= "" then
			pg.SdkMgr.GetInstance():VerificationCodeReq(var0)
			arg0:CheckAiriGenCodeCounter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip1"))
		end
	end)
	onButton(arg0, arg0.yostarSureBtn, function()
		local var0 = getInputText(arg0.yostarEmailTxt)
		local var1 = getInputText(arg0.yostarCodeTxt)

		if var0 ~= "" and var1 ~= "" then
			if arg0.contextData.isLinkMode == true then
				pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_YOSTAR, var0, var1)
			else
				pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_YOSTAR, var0, var1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip3"))
		end
	end)
	arg0:CheckAiriGenCodeCounter()
end

function var0.CheckAiriGenCodeCounter(arg0)
	if GetAiriGenCodeTimeRemain() > 0 then
		setButtonEnabled(arg0.yostarGenCodeBtn, false)

		if arg0.genCodeTimer then
			arg0.genCodeTimer:Stop()
		end

		arg0.genCodeTimer = Timer.New(function()
			local var0 = GetAiriGenCodeTimeRemain()

			if var0 > 0 then
				setText(arg0.yostarGenTxt, "(" .. var0 .. ")")
			else
				setText(arg0.yostarGenTxt, i18n("genBtn_text"))
				arg0:ClearAiriGenCodeTimer()
			end
		end, 1, -1)

		arg0.genCodeTimer:Start()
	end
end

function var0.ClearAiriGenCodeTimer(arg0)
	setButtonEnabled(arg0.yostarGenCodeBtn, true)

	if arg0.genCodeTimer then
		arg0.genCodeTimer:Stop()

		arg0.genCodeTimer = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:ClearAiriGenCodeTimer()
end

return var0
