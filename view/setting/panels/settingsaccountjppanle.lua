local var0_0 = class("SettingsAccountJPPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAccountJP"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_LoginJP")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / ACCOUNT"
end

function var0_0.OnInit(arg0_4)
	arg0_4.userProxy = getProxy(UserProxy)

	local var0_4 = arg0_4._tf

	arg0_4.accountTwitterUI = findTF(var0_4, "page1")

	local var1_4 = findTF(arg0_4.accountTwitterUI, "btn_layout/account_con")

	arg0_4.goTranscodeUIBtn = findTF(var1_4, "bind_account")

	local var2_4 = findTF(arg0_4.accountTwitterUI, "btn_layout/twitter_con")

	arg0_4.twitterBtn = findTF(var2_4, "bind_twitter")
	arg0_4.twitterUnlinkBtn = findTF(var2_4, "unlink_twitter")
	arg0_4.twitterLinkSign = findTF(var2_4, "twitter_status")

	local var3_4 = findTF(arg0_4.accountTwitterUI, "btn_layout/apple_con")

	arg0_4.appleBtn = findTF(var3_4, "bind_apple")
	arg0_4.appleUnlinkBtn = findTF(var3_4, "unlink_apple")
	arg0_4.appleLinkSign = findTF(var3_4, "apple_status")

	setActive(var3_4, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")

	local var4_4 = findTF(arg0_4.accountTwitterUI, "btn_layout/amazon_con")

	arg0_4.amazonBtn = findTF(var4_4, "bind_amazon")
	arg0_4.amazonUnlinkBtn = findTF(var4_4, "unlink_amazon")
	arg0_4.amazonLinkSign = findTF(var4_4, "amazon_status")

	setButtonEnabled(arg0_4.amazonUnlinkBtn, false)
	setText(findTF(arg0_4.amazonUnlinkBtn, "Text"), i18n("amazon_unlink_btn_text"))
	setActive(var4_4, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	local var5_4 = findTF(arg0_4.accountTwitterUI, "btn_layout/yostar_con")

	arg0_4.yostarBtn = findTF(var5_4, "bind_yostar")
	arg0_4.yostarUnlinkBtn = findTF(var5_4, "unlink_yostar")
	arg0_4.yostarLinkSign = findTF(var5_4, "yostar_status")

	setButtonEnabled(arg0_4.yostarUnlinkBtn, false)
	setText(findTF(arg0_4.yostarUnlinkBtn, "Text"), i18n("yostar_unlink_btn_text"))

	arg0_4.pgsCon = findTF(arg0_4.accountTwitterUI, "btn_layout/pgs_con")
	arg0_4.pgsBtn = findTF(arg0_4.pgsCon, "bind")
	arg0_4.pgsUnlinkBtn = findTF(arg0_4.pgsCon, "unlink")
	arg0_4.pgsLinkSign = findTF(arg0_4.pgsCon, "status")

	setText(findTF(arg0_4.pgsUnlinkBtn, "Text"), i18n("pgs_unbind"))

	arg0_4.transcodeUI = findTF(var0_4, "page2")
	arg0_4.uidTxt = findTF(arg0_4.transcodeUI, "account_name/Text")
	arg0_4.transcodeTxt = findTF(arg0_4.transcodeUI, "password/Text")
	arg0_4.getCodeBtn = findTF(arg0_4.transcodeUI, "publish_transcode")
	arg0_4.codeDesc = findTF(arg0_4.transcodeUI, "title_desc")

	arg0_4:OnRegisterEvent()
end

function var0_0.OnRegisterEvent(arg0_5)
	onButton(arg0_5, arg0_5.getCodeBtn, function()
		if arg0_5.transcode == "" then
			local function var0_6()
				pg.SdkMgr.GetInstance():TranscodeRequest()
			end

			local var1_6 = pg.SecondaryPWDMgr

			var1_6:LimitedOperation(var1_6.CREATE_INHERIT, nil, var0_6)
		end
	end)
	onButton(arg0_5, arg0_5.twitterBtn, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0_5, arg0_5.twitterUnlinkBtn, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0_5, arg0_5.appleBtn, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0_5, arg0_5.appleUnlinkBtn, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0_5, arg0_5.goTranscodeUIBtn, function()
		setActive(arg0_5.accountTwitterUI, false)
		setActive(arg0_5.transcodeUI, true)
	end)
	onButton(arg0_5, arg0_5.amazonBtn, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0_5, arg0_5.yostarBtn, function()
		pg.m02:sendNotification(NewSettingsMediator.OPEN_YOSTAR_ALERT_VIEW)
	end)
	onButton(arg0_5, arg0_5.pgsUnlinkBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_unbind_tip1"),
			onYes = function()
				pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_GPS)
			end
		})
	end)
end

function var0_0.OnUpdate(arg0_17)
	arg0_17:checkAllAccountState()
end

function var0_0.checkAllAccountState(arg0_18)
	arg0_18:checkTranscodeView()
	arg0_18:checkAccountTwitterView()
	arg0_18:checkAccountAppleView()
	arg0_18:checkAccountAmazonView()
	arg0_18:checkAccountYostarView()
	arg0_18:checkAccountGPSView()
end

function var0_0.showTranscode(arg0_19, arg1_19)
	arg0_19.userProxy:saveTranscode(arg1_19)
	arg0_19:checkTranscodeView()
end

function var0_0.checkTranscodeView(arg0_20)
	arg0_20.transcode = pg.SdkMgr.GetInstance():GetYostarTransCode() or ""

	if not arg0_20.transcode or arg0_20.transcode == "" or arg0_20.transcode == "NULL" then
		arg0_20.transcode = arg0_20.userProxy:getTranscode()
	end

	setActive(arg0_20.codeDesc, arg0_20.transcode ~= "")
	setActive(arg0_20.getCodeBtn, arg0_20.transcode == "")

	if arg0_20.transcode ~= "" then
		setText(arg0_20.uidTxt, pg.SdkMgr.GetInstance():GetYostarUid())
		setText(arg0_20.transcodeTxt, arg0_20.transcode)
	end
end

function var0_0.checkAccountTwitterView(arg0_21)
	local var0_21 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_TWITTER)

	setActive(arg0_21.twitterUnlinkBtn, var0_21)
	setActive(arg0_21.twitterLinkSign, var0_21)
	setActive(arg0_21.twitterBtn, not var0_21)

	if var0_21 then
		setText(arg0_21.twitterLinkSign, i18n("twitter_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_TWITTER)))
	end
end

function var0_0.checkAccountAppleView(arg0_22)
	local var0_22 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_APPLE)

	setActive(arg0_22.appleUnlinkBtn, var0_22)
	setActive(arg0_22.appleLinkSign, var0_22)
	setActive(arg0_22.appleBtn, not var0_22)

	if var0_22 then
		setText(arg0_22.appleLinkSign, i18n("apple_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_APPLE)))
	end
end

function var0_0.checkAccountAmazonView(arg0_23)
	if pg.SdkMgr.GetInstance():GetChannelUID() == "3" then
		local var0_23 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_AMAZON)

		setActive(arg0_23.amazonUnlinkBtn, var0_23)
		setActive(arg0_23.amazonLinkSign, var0_23)
		setActive(arg0_23.amazonBtn, not var0_23)

		if var0_23 then
			setText(arg0_23.amazonLinkSign, i18n("amazon_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_AMAZON)))
		end
	end
end

function var0_0.checkAccountYostarView(arg0_24)
	local var0_24 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_YOSTAR)

	setActive(arg0_24.yostarUnlinkBtn, var0_24)
	setActive(arg0_24.yostarLinkSign, var0_24)
	setActive(arg0_24.yostarBtn, not var0_24)

	if var0_24 then
		setText(arg0_24.yostarLinkSign, i18n("yostar_link_title"))
	end
end

function var0_0.checkAccountGPSView(arg0_25)
	local var0_25 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_GPS)

	setActive(arg0_25.pgsCon, var0_25)
	setActive(arg0_25.pgsUnlinkBtn, var0_25)
	setActive(arg0_25.pgsLinkSign, var0_25)
	setActive(arg0_25.pgsBtn, false)

	if var0_25 then
		setText(arg0_25.pgsLinkSign, i18n("pgs_binding_account", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_GPS)))
	end
end

return var0_0
