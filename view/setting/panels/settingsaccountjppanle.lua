local var0 = class("SettingsAccountJPPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAccountJP"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_LoginJP")
end

function var0.GetTitleEn(arg0)
	return "  / ACCOUNT"
end

function var0.OnInit(arg0)
	arg0.userProxy = getProxy(UserProxy)

	local var0 = arg0._tf

	arg0.accountTwitterUI = findTF(var0, "page1")

	local var1 = findTF(arg0.accountTwitterUI, "btn_layout/account_con")

	arg0.goTranscodeUIBtn = findTF(var1, "bind_account")

	local var2 = findTF(arg0.accountTwitterUI, "btn_layout/twitter_con")

	arg0.twitterBtn = findTF(var2, "bind_twitter")
	arg0.twitterUnlinkBtn = findTF(var2, "unlink_twitter")
	arg0.twitterLinkSign = findTF(var2, "twitter_status")

	local var3 = findTF(arg0.accountTwitterUI, "btn_layout/apple_con")

	arg0.appleBtn = findTF(var3, "bind_apple")
	arg0.appleUnlinkBtn = findTF(var3, "unlink_apple")
	arg0.appleLinkSign = findTF(var3, "apple_status")

	setActive(var3, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")

	local var4 = findTF(arg0.accountTwitterUI, "btn_layout/amazon_con")

	arg0.amazonBtn = findTF(var4, "bind_amazon")
	arg0.amazonUnlinkBtn = findTF(var4, "unlink_amazon")
	arg0.amazonLinkSign = findTF(var4, "amazon_status")

	setButtonEnabled(arg0.amazonUnlinkBtn, false)
	setText(findTF(arg0.amazonUnlinkBtn, "Text"), i18n("amazon_unlink_btn_text"))
	setActive(var4, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	local var5 = findTF(arg0.accountTwitterUI, "btn_layout/yostar_con")

	arg0.yostarBtn = findTF(var5, "bind_yostar")
	arg0.yostarUnlinkBtn = findTF(var5, "unlink_yostar")
	arg0.yostarLinkSign = findTF(var5, "yostar_status")

	setButtonEnabled(arg0.yostarUnlinkBtn, false)
	setText(findTF(arg0.yostarUnlinkBtn, "Text"), i18n("yostar_unlink_btn_text"))

	arg0.pgsCon = findTF(arg0.accountTwitterUI, "btn_layout/pgs_con")
	arg0.pgsBtn = findTF(arg0.pgsCon, "bind")
	arg0.pgsUnlinkBtn = findTF(arg0.pgsCon, "unlink")
	arg0.pgsLinkSign = findTF(arg0.pgsCon, "status")

	setText(findTF(arg0.pgsUnlinkBtn, "Text"), i18n("pgs_unbind"))

	arg0.transcodeUI = findTF(var0, "page2")
	arg0.uidTxt = findTF(arg0.transcodeUI, "account_name/Text")
	arg0.transcodeTxt = findTF(arg0.transcodeUI, "password/Text")
	arg0.getCodeBtn = findTF(arg0.transcodeUI, "publish_transcode")
	arg0.codeDesc = findTF(arg0.transcodeUI, "title_desc")

	arg0:OnRegisterEvent()
end

function var0.OnRegisterEvent(arg0)
	onButton(arg0, arg0.getCodeBtn, function()
		if arg0.transcode == "" then
			local function var0()
				pg.SdkMgr.GetInstance():TranscodeRequest()
			end

			local var1 = pg.SecondaryPWDMgr

			var1:LimitedOperation(var1.CREATE_INHERIT, nil, var0)
		end
	end)
	onButton(arg0, arg0.twitterBtn, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0, arg0.twitterUnlinkBtn, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(arg0, arg0.appleBtn, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0, arg0.appleUnlinkBtn, function()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(arg0, arg0.goTranscodeUIBtn, function()
		setActive(arg0.accountTwitterUI, false)
		setActive(arg0.transcodeUI, true)
	end)
	onButton(arg0, arg0.amazonBtn, function()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(arg0, arg0.yostarBtn, function()
		pg.m02:sendNotification(NewSettingsMediator.OPEN_YOSTAR_ALERT_VIEW)
	end)
	onButton(arg0, arg0.pgsUnlinkBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pgs_unbind_tip1"),
			onYes = function()
				pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_GPS)
			end
		})
	end)
end

function var0.OnUpdate(arg0)
	arg0:checkAllAccountState()
end

function var0.checkAllAccountState(arg0)
	arg0:checkTranscodeView()
	arg0:checkAccountTwitterView()
	arg0:checkAccountAppleView()
	arg0:checkAccountAmazonView()
	arg0:checkAccountYostarView()
	arg0:checkAccountGPSView()
end

function var0.showTranscode(arg0, arg1)
	arg0.userProxy:saveTranscode(arg1)
	arg0:checkTranscodeView()
end

function var0.checkTranscodeView(arg0)
	arg0.transcode = pg.SdkMgr.GetInstance():GetYostarTransCode() or ""

	if not arg0.transcode or arg0.transcode == "" or arg0.transcode == "NULL" then
		arg0.transcode = arg0.userProxy:getTranscode()
	end

	setActive(arg0.codeDesc, arg0.transcode ~= "")
	setActive(arg0.getCodeBtn, arg0.transcode == "")

	if arg0.transcode ~= "" then
		setText(arg0.uidTxt, pg.SdkMgr.GetInstance():GetYostarUid())
		setText(arg0.transcodeTxt, arg0.transcode)
	end
end

function var0.checkAccountTwitterView(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_TWITTER)

	setActive(arg0.twitterUnlinkBtn, var0)
	setActive(arg0.twitterLinkSign, var0)
	setActive(arg0.twitterBtn, not var0)

	if var0 then
		setText(arg0.twitterLinkSign, i18n("twitter_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_TWITTER)))
	end
end

function var0.checkAccountAppleView(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_APPLE)

	setActive(arg0.appleUnlinkBtn, var0)
	setActive(arg0.appleLinkSign, var0)
	setActive(arg0.appleBtn, not var0)

	if var0 then
		setText(arg0.appleLinkSign, i18n("apple_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_APPLE)))
	end
end

function var0.checkAccountAmazonView(arg0)
	if pg.SdkMgr.GetInstance():GetChannelUID() == "3" then
		local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_AMAZON)

		setActive(arg0.amazonUnlinkBtn, var0)
		setActive(arg0.amazonLinkSign, var0)
		setActive(arg0.amazonBtn, not var0)

		if var0 then
			setText(arg0.amazonLinkSign, i18n("amazon_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_AMAZON)))
		end
	end
end

function var0.checkAccountYostarView(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_YOSTAR)

	setActive(arg0.yostarUnlinkBtn, var0)
	setActive(arg0.yostarLinkSign, var0)
	setActive(arg0.yostarBtn, not var0)

	if var0 then
		setText(arg0.yostarLinkSign, i18n("yostar_link_title"))
	end
end

function var0.checkAccountGPSView(arg0)
	local var0 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_GPS)

	setActive(arg0.pgsCon, var0)
	setActive(arg0.pgsUnlinkBtn, var0)
	setActive(arg0.pgsLinkSign, var0)
	setActive(arg0.pgsBtn, false)

	if var0 then
		setText(arg0.pgsLinkSign, i18n("pgs_binding_account", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_GPS)))
	end
end

return var0
