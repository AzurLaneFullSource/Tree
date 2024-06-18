local var0_0 = class("YostarAlertView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "YostarAlertView"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4.yostarAlert = arg0_4._tf
	arg0_4.yostarEmailTxt = arg0_4:findTF("email_input_txt", arg0_4.yostarAlert)
	arg0_4.yostarCodeTxt = arg0_4:findTF("code_input_txt", arg0_4.yostarAlert)
	arg0_4.yostarGenCodeBtn = arg0_4:findTF("gen_code_btn", arg0_4.yostarAlert)
	arg0_4.yostarGenTxt = arg0_4:findTF("Text", arg0_4.yostarGenCodeBtn)
	arg0_4.yostarSureBtn = arg0_4:findTF("login_btn", arg0_4.yostarAlert)
	arg0_4.email_text = arg0_4:findTF("title1", arg0_4.yostarAlert)
	arg0_4.emailhold_text = arg0_4:findTF("Placeholder", arg0_4.yostarEmailTxt)
	arg0_4.code_text = arg0_4:findTF("title2", arg0_4.yostarAlert)
	arg0_4.codehold_text = arg0_4:findTF("Placeholder", arg0_4.yostarCodeTxt)
	arg0_4.genBtn_text = arg0_4:findTF("Text", arg0_4.yostarGenCodeBtn)
	arg0_4.desc_text = arg0_4:findTF("desc", arg0_4.yostarAlert)
	arg0_4.loginBtn_text = arg0_4:findTF("Image", arg0_4.yostarSureBtn)

	setText(arg0_4.email_text, i18n("email_text"))
	setText(arg0_4.emailhold_text, i18n("emailhold_text"))
	setText(arg0_4.code_text, i18n("code_text"))
	setText(arg0_4.codehold_text, i18n("codehold_text"))
	setText(arg0_4.genBtn_text, i18n("genBtn_text"))
	setText(arg0_4.desc_text, i18n("desc_text"))
	setText(arg0_4.loginBtn_text, arg0_4.contextData.isLinkMode == true and i18n("linkBtn_text") or i18n("loginBtn_text"))
	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.yostarAlert, function()
		setActive(arg0_5.yostarAlert, false)

		if arg0_5.contextData.isDestroyOnClose == true then
			arg0_5:Destroy()
		end
	end)
	onButton(arg0_5, arg0_5.yostarGenCodeBtn, function()
		local var0_7 = getInputText(arg0_5.yostarEmailTxt)

		if var0_7 ~= "" then
			pg.SdkMgr.GetInstance():VerificationCodeReq(var0_7)
			arg0_5:CheckAiriGenCodeCounter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip1"))
		end
	end)
	onButton(arg0_5, arg0_5.yostarSureBtn, function()
		local var0_8 = getInputText(arg0_5.yostarEmailTxt)
		local var1_8 = getInputText(arg0_5.yostarCodeTxt)

		if var0_8 ~= "" and var1_8 ~= "" then
			if arg0_5.contextData.isLinkMode == true then
				pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_YOSTAR, var0_8, var1_8)
			else
				pg.SdkMgr.GetInstance():LoginWithSocial(AIRI_PLATFORM_YOSTAR, var0_8, var1_8)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip3"))
		end
	end)
	arg0_5:CheckAiriGenCodeCounter()
end

function var0_0.CheckAiriGenCodeCounter(arg0_9)
	if GetAiriGenCodeTimeRemain() > 0 then
		setButtonEnabled(arg0_9.yostarGenCodeBtn, false)

		if arg0_9.genCodeTimer then
			arg0_9.genCodeTimer:Stop()
		end

		arg0_9.genCodeTimer = Timer.New(function()
			local var0_10 = GetAiriGenCodeTimeRemain()

			if var0_10 > 0 then
				setText(arg0_9.yostarGenTxt, "(" .. var0_10 .. ")")
			else
				setText(arg0_9.yostarGenTxt, i18n("genBtn_text"))
				arg0_9:ClearAiriGenCodeTimer()
			end
		end, 1, -1)

		arg0_9.genCodeTimer:Start()
	end
end

function var0_0.ClearAiriGenCodeTimer(arg0_11)
	setButtonEnabled(arg0_11.yostarGenCodeBtn, true)

	if arg0_11.genCodeTimer then
		arg0_11.genCodeTimer:Stop()

		arg0_11.genCodeTimer = nil
	end
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:ClearAiriGenCodeTimer()
end

return var0_0
