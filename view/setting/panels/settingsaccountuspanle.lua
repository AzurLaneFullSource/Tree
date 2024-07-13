local var0_0 = class("SettingsAccountUSPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAccountUS"
end

function var0_0.GetTitle(arg0_2)
	return "Account"
end

function var0_0.GetTitleEn(arg0_3)
	return "  / ACCOUNT"
end

function var0_0.OnInit(arg0_4)
	local var0_4 = arg0_4._tf
	local var1_4 = findTF(var0_4, "page1")
	local var2_4 = findTF(var1_4, "btn_layout/twitter_con")

	arg0_4.btnBindTwitter = findTF(var2_4, "bind_twitter")
	arg0_4.btnUnlinkTwitter = findTF(var2_4, "unlink_twitter")
	arg0_4.twitterStatus = findTF(var2_4, "twitter_status")

	local var3_4 = findTF(var1_4, "btn_layout/facebook_con")

	arg0_4.btnBindFacebook = findTF(var3_4, "bind_facebook")
	arg0_4.btnUnlinkFacebook = findTF(var3_4, "unlink_facebook")
	arg0_4.facebookStatus = findTF(var3_4, "facebook_status")

	setActive(var3_4, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3")

	local var4_4 = findTF(var1_4, "btn_layout/yostar_con")

	arg0_4.btnBindYostar = findTF(var4_4, "bind_yostar")
	arg0_4.btnUnlinkYostar = findTF(var4_4, "unlink_yostar")
	arg0_4.yostarStatus = findTF(var4_4, "yostar_status")

	local var5_4 = findTF(var1_4, "btn_layout/apple_con")

	arg0_4.btnBindApple = findTF(var5_4, "bind_apple")
	arg0_4.btnUnlinkApple = findTF(var5_4, "unlink_apple")
	arg0_4.appleStatus = findTF(var5_4, "apple_status")

	setActive(var5_4, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "1")

	local var6_4 = findTF(var1_4, "btn_layout/amazon_con")

	arg0_4.btnBindAmazon = findTF(var6_4, "bind_amazon")
	arg0_4.btnUnlinkAmazon = findTF(var6_4, "unlink_amazon")
	arg0_4.amazonStatus = findTF(var6_4, "amazon_status")

	setActive(var6_4, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	arg0_4.pgsCon = findTF(var1_4, "btn_layout/pgs_con")
	arg0_4.btnBindPGS = findTF(arg0_4.pgsCon, "bind")
	arg0_4.btnUnlinkPGS = findTF(arg0_4.pgsCon, "unlink")
	arg0_4.pgsStatus = findTF(arg0_4.pgsCon, "status")
	arg0_4.yostarAlert = findTF(var0_4, "page2")
	arg0_4.yostarEmailTxt = findTF(arg0_4.yostarAlert, "email_input_txt")
	arg0_4.yostarCodeTxt = findTF(arg0_4.yostarAlert, "code_input_txt")
	arg0_4.yostarGenCodeBtn = findTF(arg0_4.yostarAlert, "gen_code_btn")
	arg0_4.yostarGenTxt = findTF(arg0_4.yostarGenCodeBtn, "Text")
	arg0_4.yostarSureBtn = findTF(arg0_4.yostarAlert, "login_btn")

	arg0_4:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_5)
	onButton(arg0_5, arg0_5.btnBindTwitter, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0_5, arg0_5.btnUnlinkTwitter, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0_5, arg0_5.btnBindFacebook, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(arg0_5, arg0_5.btnUnlinkFacebook, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(arg0_5, arg0_5.btnBindApple, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0_5, arg0_5.btnUnlinkApple, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0_5, arg0_5.btnBindAmazon, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0_5, arg0_5.btnUnlinkAmazon, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0_5, arg0_5.btnBindYostar, function()
		pg.UIMgr.GetInstance():BlurPanel(arg0_5.yostarAlert, false)
		setActive(arg0_5.yostarAlert, true)
	end)
	onButton(arg0_5, arg0_5.yostarAlert, function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_5.yostarAlert, arg0_5.accountUS)
		setActive(arg0_5.yostarAlert, false)
	end)
	onButton(arg0_5, arg0_5.yostarGenCodeBtn, function()
		local var0_16 = getInputText(arg0_5.yostarEmailTxt)

		if var0_16 ~= "" then
			pg.SdkMgr.GetInstance():VerificationCodeReq(var0_16)
			arg0_5:checkAiriGenCodeCounter_US()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip1"))
		end
	end)
	onButton(arg0_5, arg0_5.yostarSureBtn, function()
		local var0_17 = getInputText(arg0_5.yostarEmailTxt)
		local var1_17 = getInputText(arg0_5.yostarCodeTxt)

		if var0_17 ~= "" and var1_17 ~= "" then
			pg.UIMgr.GetInstance():LoadingOn()
			pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_YOSTAR, var0_17, var1_17)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip3"))
		end

		triggerButton(arg0_5.yostarAlert)
	end)
	onButton(arg0_5, arg0_5.btnUnlinkPGS, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_unbind_tip1"),
			onYes = function()
				pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_GPS)
			end
		})
	end)
end

function var0_0.OnUpdate(arg0_20)
	arg0_20:checkAllAccountState_US()
	arg0_20:checkAiriGenCodeCounter_US()
end

function var0_0.checkAllAccountState_US(arg0_21)
	arg0_21:checkAccountTwitterView_US()
	arg0_21:checkAccountFacebookView_US()
	arg0_21:checkAccountAppleView_US()
	arg0_21:checkAccountYostarView_US()
	arg0_21:checkAccountAmazonView_US()
	arg0_21:checkAccountPGSView_US()
end

function var0_0.checkAccountTwitterView_US(arg0_22)
	local var0_22 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_TWITTER)

	setActive(arg0_22.btnUnlinkTwitter, var0_22)
	setActive(arg0_22.twitterStatus, var0_22)
	setActive(arg0_22.btnBindTwitter, not var0_22)

	if var0_22 then
		setText(arg0_22.twitterStatus, i18n("twitter_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_TWITTER)))
	end
end

function var0_0.checkAccountFacebookView_US(arg0_23)
	if PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3" then
		local var0_23 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_FACEBOOK)

		setActive(arg0_23.btnUnlinkFacebook, var0_23)
		setActive(arg0_23.facebookStatus, var0_23)
		setActive(arg0_23.btnBindFacebook, not var0_23)

		if var0_23 then
			setText(arg0_23.facebookStatus, i18n("facebook_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_FACEBOOK)))
		end
	end
end

function var0_0.checkAccountAppleView_US(arg0_24)
	local var0_24 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_APPLE)

	setActive(arg0_24.btnUnlinkApple, var0_24)
	setActive(arg0_24.appleStatus, var0_24)
	setActive(arg0_24.btnBindApple, not var0_24)

	if var0_24 then
		setText(arg0_24.appleStatus, i18n("apple_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_APPLE)))
	end
end

function var0_0.checkAccountAmazonView_US(arg0_25)
	if pg.SdkMgr.GetInstance():GetChannelUID() == "3" then
		local var0_25 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_AMAZON)

		setActive(arg0_25.btnUnlinkAmazon, var0_25)
		setActive(arg0_25.amazonStatus, var0_25)
		setActive(arg0_25.btnBindAmazon, not var0_25)

		if var0_25 then
			setText(arg0_25.amazonStatus, i18n("amazon_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_AMAZON)))
		end
	end
end

function var0_0.checkAccountYostarView_US(arg0_26)
	local var0_26 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_YOSTAR)

	setActive(arg0_26.btnUnlinkYostar, var0_26)
	setActive(arg0_26.yostarStatus, var0_26)
	setActive(arg0_26.btnBindYostar, not var0_26)

	if var0_26 then
		setText(arg0_26.yostarStatus, i18n("yostar_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_YOSTAR)))
	end
end

function var0_0.checkAccountPGSView_US(arg0_27)
	local var0_27 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_GPS)

	setActive(arg0_27.pgsCon, var0_27)
	setActive(arg0_27.btnUnlinkPGS, var0_27)
	setActive(arg0_27.pgsStatus, var0_27)
	setActive(arg0_27.btnBindPGS, false)

	if var0_27 then
		setText(arg0_27.pgsStatus, i18n("pgs_binding_account", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_GPS)))
	end
end

function var0_0.checkAiriGenCodeCounter_US(arg0_28)
	if GetAiriGenCodeTimeRemain() > 0 then
		setButtonEnabled(arg0_28.yostarGenCodeBtn, false)

		arg0_28.genCodeTimer = Timer.New(function()
			local var0_29 = GetAiriGenCodeTimeRemain()

			if var0_29 > 0 then
				setText(arg0_28.yostarGenTxt, "(" .. var0_29 .. ")")
			else
				setText(arg0_28.yostarGenTxt, "Generate")
				arg0_28:clearAiriGenCodeTimer_US()
			end
		end, 1, -1)

		arg0_28.genCodeTimer:Start()
	end
end

function var0_0.clearAiriGenCodeTimer_US(arg0_30)
	setButtonEnabled(arg0_30.yostarGenCodeBtn, true)

	if arg0_30.genCodeTimer then
		arg0_30.genCodeTimer:Stop()

		arg0_30.genCodeTimer = nil
	end
end

function var0_0.Dispose(arg0_31)
	var0_0.super.Dispose(arg0_31)

	if arg0_31.genCodeTimer then
		arg0_31.genCodeTimer:Stop()

		arg0_31.genCodeTimer = nil
	end
end

return var0_0
