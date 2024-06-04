local var0 = class("SettingsAccountUSPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAccountUS"
end

function var0.GetTitle(arg0)
	return "Account"
end

function var0.GetTitleEn(arg0)
	return "  / ACCOUNT"
end

function var0.OnInit(arg0)
	local var0 = arg0._tf
	local var1 = findTF(var0, "page1")
	local var2 = findTF(var1, "btn_layout/twitter_con")

	arg0.btnBindTwitter = findTF(var2, "bind_twitter")
	arg0.btnUnlinkTwitter = findTF(var2, "unlink_twitter")
	arg0.twitterStatus = findTF(var2, "twitter_status")

	local var3 = findTF(var1, "btn_layout/facebook_con")

	arg0.btnBindFacebook = findTF(var3, "bind_facebook")
	arg0.btnUnlinkFacebook = findTF(var3, "unlink_facebook")
	arg0.facebookStatus = findTF(var3, "facebook_status")

	setActive(var3, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3")

	local var4 = findTF(var1, "btn_layout/yostar_con")

	arg0.btnBindYostar = findTF(var4, "bind_yostar")
	arg0.btnUnlinkYostar = findTF(var4, "unlink_yostar")
	arg0.yostarStatus = findTF(var4, "yostar_status")

	local var5 = findTF(var1, "btn_layout/apple_con")

	arg0.btnBindApple = findTF(var5, "bind_apple")
	arg0.btnUnlinkApple = findTF(var5, "unlink_apple")
	arg0.appleStatus = findTF(var5, "apple_status")

	setActive(var5, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "1")

	local var6 = findTF(var1, "btn_layout/amazon_con")

	arg0.btnBindAmazon = findTF(var6, "bind_amazon")
	arg0.btnUnlinkAmazon = findTF(var6, "unlink_amazon")
	arg0.amazonStatus = findTF(var6, "amazon_status")

	setActive(var6, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	arg0.pgsCon = findTF(var1, "btn_layout/pgs_con")
	arg0.btnBindPGS = findTF(arg0.pgsCon, "bind")
	arg0.btnUnlinkPGS = findTF(arg0.pgsCon, "unlink")
	arg0.pgsStatus = findTF(arg0.pgsCon, "status")
	arg0.yostarAlert = findTF(var0, "page2")
	arg0.yostarEmailTxt = findTF(arg0.yostarAlert, "email_input_txt")
	arg0.yostarCodeTxt = findTF(arg0.yostarAlert, "code_input_txt")
	arg0.yostarGenCodeBtn = findTF(arg0.yostarAlert, "gen_code_btn")
	arg0.yostarGenTxt = findTF(arg0.yostarGenCodeBtn, "Text")
	arg0.yostarSureBtn = findTF(arg0.yostarAlert, "login_btn")

	arg0:RegisterEvent()
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.btnBindTwitter, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0, arg0.btnUnlinkTwitter, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0, arg0.btnBindFacebook, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(arg0, arg0.btnUnlinkFacebook, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(arg0, arg0.btnBindApple, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0, arg0.btnUnlinkApple, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0, arg0.btnBindAmazon, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0, arg0.btnUnlinkAmazon, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0, arg0.btnBindYostar, function()
		pg.UIMgr.GetInstance():BlurPanel(arg0.yostarAlert, false)
		setActive(arg0.yostarAlert, true)
	end)
	onButton(arg0, arg0.yostarAlert, function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.yostarAlert, arg0.accountUS)
		setActive(arg0.yostarAlert, false)
	end)
	onButton(arg0, arg0.yostarGenCodeBtn, function()
		local var0 = getInputText(arg0.yostarEmailTxt)

		if var0 ~= "" then
			pg.SdkMgr.GetInstance():VerificationCodeReq(var0)
			arg0:checkAiriGenCodeCounter_US()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip1"))
		end
	end)
	onButton(arg0, arg0.yostarSureBtn, function()
		local var0 = getInputText(arg0.yostarEmailTxt)
		local var1 = getInputText(arg0.yostarCodeTxt)

		if var0 ~= "" and var1 ~= "" then
			pg.UIMgr.GetInstance():LoadingOn()
			pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_YOSTAR, var0, var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip3"))
		end

		triggerButton(arg0.yostarAlert)
	end)
	onButton(arg0, arg0.btnUnlinkPGS, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_unbind_tip1"),
			onYes = function()
				pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_GPS)
			end
		})
	end)
end

function var0.OnUpdate(arg0)
	arg0:checkAllAccountState_US()
	arg0:checkAiriGenCodeCounter_US()
end

function var0.checkAllAccountState_US(arg0)
	arg0:checkAccountTwitterView_US()
	arg0:checkAccountFacebookView_US()
	arg0:checkAccountAppleView_US()
	arg0:checkAccountYostarView_US()
	arg0:checkAccountAmazonView_US()
	arg0:checkAccountPGSView_US()
end

function var0.checkAccountTwitterView_US(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_TWITTER)

	setActive(arg0.btnUnlinkTwitter, var0)
	setActive(arg0.twitterStatus, var0)
	setActive(arg0.btnBindTwitter, not var0)

	if var0 then
		setText(arg0.twitterStatus, i18n("twitter_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_TWITTER)))
	end
end

function var0.checkAccountFacebookView_US(arg0)
	if PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3" then
		local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_FACEBOOK)

		setActive(arg0.btnUnlinkFacebook, var0)
		setActive(arg0.facebookStatus, var0)
		setActive(arg0.btnBindFacebook, not var0)

		if var0 then
			setText(arg0.facebookStatus, i18n("facebook_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_FACEBOOK)))
		end
	end
end

function var0.checkAccountAppleView_US(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_APPLE)

	setActive(arg0.btnUnlinkApple, var0)
	setActive(arg0.appleStatus, var0)
	setActive(arg0.btnBindApple, not var0)

	if var0 then
		setText(arg0.appleStatus, i18n("apple_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_APPLE)))
	end
end

function var0.checkAccountAmazonView_US(arg0)
	if pg.SdkMgr.GetInstance():GetChannelUID() == "3" then
		local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_AMAZON)

		setActive(arg0.btnUnlinkAmazon, var0)
		setActive(arg0.amazonStatus, var0)
		setActive(arg0.btnBindAmazon, not var0)

		if var0 then
			setText(arg0.amazonStatus, i18n("amazon_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_AMAZON)))
		end
	end
end

function var0.checkAccountYostarView_US(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_YOSTAR)

	setActive(arg0.btnUnlinkYostar, var0)
	setActive(arg0.yostarStatus, var0)
	setActive(arg0.btnBindYostar, not var0)

	if var0 then
		setText(arg0.yostarStatus, i18n("yostar_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_YOSTAR)))
	end
end

function var0.checkAccountPGSView_US(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_GPS)

	setActive(arg0.pgsCon, var0)
	setActive(arg0.btnUnlinkPGS, var0)
	setActive(arg0.pgsStatus, var0)
	setActive(arg0.btnBindPGS, false)

	if var0 then
		setText(arg0.pgsStatus, i18n("pgs_binding_account", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_GPS)))
	end
end

function var0.checkAiriGenCodeCounter_US(arg0)
	if GetAiriGenCodeTimeRemain() > 0 then
		setButtonEnabled(arg0.yostarGenCodeBtn, false)

		arg0.genCodeTimer = Timer.New(function()
			local var0 = GetAiriGenCodeTimeRemain()

			if var0 > 0 then
				setText(arg0.yostarGenTxt, "(" .. var0 .. ")")
			else
				setText(arg0.yostarGenTxt, "Generate")
				arg0:clearAiriGenCodeTimer_US()
			end
		end, 1, -1)

		arg0.genCodeTimer:Start()
	end
end

function var0.clearAiriGenCodeTimer_US(arg0)
	setButtonEnabled(arg0.yostarGenCodeBtn, true)

	if arg0.genCodeTimer then
		arg0.genCodeTimer:Stop()

		arg0.genCodeTimer = nil
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	if arg0.genCodeTimer then
		arg0.genCodeTimer:Stop()

		arg0.genCodeTimer = nil
	end
end

return var0
