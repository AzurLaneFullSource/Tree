local var0_0 = class("LoginScene", import("..base.BaseUI"))
local var1_0 = 1

function var0_0.getUIName(arg0_1)
	return "LoginUI2"
end

function var0_0.getBGM(arg0_2)
	if arg0_2.bgmName and arg0_2.bgmName ~= "" then
		return arg0_2.bgmName
	end

	return var0_0.super.getBGM(arg0_2)
end

function var0_0.preload(arg0_3, arg1_3)
	arg0_3.iconSpries = {
		"reources/statu_green",
		"reources/statu_gray",
		"reources/statu_red",
		"reources/statu_org"
	}

	local var0_3 = LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value

	seriesAsync({
		function(arg0_4)
			arg0_3.isCriBg, arg0_3.bgPath, arg0_3.bgmName, arg0_3.isOpPlay, arg0_3.opVersion = getLoginConfig()

			if arg0_3.isCriBg then
				LoadAndInstantiateAsync("effect", arg0_3.bgPath, function(arg0_5)
					arg0_3.criBgGo = arg0_5

					arg0_4()
				end)
			else
				local var0_4 = var0_3 and "loadingbg_hx/" or "loadingbg/"

				LoadSpriteAsync(var0_4 .. arg0_3.bgPath, function(arg0_6)
					arg0_3.staticBgSprite = arg0_6

					arg0_4()
				end)
			end
		end
	}, arg1_3)
end

function var0_0.init(arg0_7)
	local var0_7 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES")

	arg0_7:setBg()

	arg0_7.version = arg0_7:findTF("version")
	arg0_7.version:GetComponent("Text").text = "ver " .. var0_7.CurrentVersion:ToString()
	arg0_7.bgLay = arg0_7:findTF("bg_lay")
	arg0_7.accountBtn = arg0_7:findTF("bg_lay/buttons/account_button")
	arg0_7.repairBtn = arg0_7:findTF("btns/repair_button")
	arg0_7.privateBtn = arg0_7:findTF("btns/private_btn")
	arg0_7.licenceBtn = arg0_7:findTF("btns/Licence_btn")
	arg0_7.chInfo = arg0_7:findTF("background/info")

	setActive(arg0_7.chInfo, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_7.urlClick = arg0_7:findTF("urlClick", arg0_7.chInfo)

		onButton(arg0_7, arg0_7.urlClick, function()
			Application.OpenURL("https://beian.miit.gov.cn/#/home")
		end)
	end

	arg0_7.pressToLogin = GetOrAddComponent(arg0_7:findTF("background/press_to_login"), "CanvasGroup")

	LeanTween.alphaCanvas(arg0_7.pressToLogin, 0.25, var1_0):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0_7.currentServer = arg0_7:findTF("current_server")
	arg0_7.serviceBtn = arg0_7:findTF("bg_lay/buttons/service_button")
	arg0_7.filingBtn = arg0_7:findTF("filingBtn")

	setActive(arg0_7.filingBtn, PLATFORM_CODE == PLATFORM_CH)

	arg0_7.serversPanel = arg0_7:findTF("servers")
	arg0_7.servers = arg0_7:findTF("panel/servers/content/server_list", arg0_7.serversPanel)
	arg0_7.serverTpl = arg0_7:getTpl("server_tpl")
	arg0_7.recentTF = arg0_7:findTF("panel/servers/content/advice_panel/recent", arg0_7.serversPanel)
	arg0_7.adviceTF = arg0_7:findTF("panel/servers/content/advice_panel/advice", arg0_7.serversPanel)
	arg0_7.userAgreenTF = arg0_7:findTF("UserAgreement")
	arg0_7.userAgreenMainTF = arg0_7:findTF("UserAgreement/window")
	arg0_7.closeUserAgreenTF = arg0_7.userAgreenTF:Find("window/close_btn")
	arg0_7.userAgreenConfirmTF = arg0_7:findTF("UserAgreement/window/accept_btn")
	arg0_7.userDisagreeConfirmTF = arg0_7:findTF("UserAgreement/window/disagree_btn")
	arg0_7.switchGatewayBtn = SwitchGatewayBtn.New(arg0_7:findTF("servers/panel/switch_platform"))

	setActive(arg0_7.userAgreenTF, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.userAgreenTF, arg0_7._tf)

	arg0_7.opBtn = arg0_7:findTF("bg_lay/buttons/opBtn")

	if arg0_7.opBtn then
		setActive(arg0_7.opBtn, arg0_7.isOpPlay)
	end

	arg0_7.airiUidTxt = arg0_7:findTF("airi_uid")
	arg0_7.shareData = {}
	arg0_7.searchAccount = arg0_7:findTF("panel/searchAccount", arg0_7.serversPanel)

	setText(findTF(arg0_7.searchAccount, "text"), i18n("query_role_button"))

	arg0_7.serverPanelCanvas = GetComponent(arg0_7:findTF("servers/panel/servers"), typeof(CanvasGroup))

	onButton(arg0_7, arg0_7.searchAccount, function()
		if not arg0_7.serversDic or arg0_7.searching then
			return
		end

		arg0_7:searchAountState(true)

		arg0_7.serverPanelCanvas.interactable = false

		arg0_7.event:emit(LoginMediator.ON_SEARCH_ACCOUNT, {
			callback = function()
				arg0_7.serverPanelCanvas.interactable = true

				arg0_7:searchAountState(false)
			end,
			update = function(arg0_11)
				arg0_7:setServerAccountData(arg0_11)
			end
		})
	end, SFX_CONFIRM)

	arg0_7.subViewList = {}
	arg0_7.loginPanelView = LoginPanelView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

	arg0_7.loginPanelView:SetShareData(arg0_7.shareData)

	arg0_7.registerPanelView = RegisterPanelView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

	arg0_7.loginPanelView:SetShareData(arg0_7.shareData)

	arg0_7.tencentLoginPanelView = TencentLoginPanelView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

	arg0_7.loginPanelView:SetShareData(arg0_7.shareData)

	arg0_7.airiLoginPanelView = nil

	if PLATFORM_CODE == PLATFORM_US then
		arg0_7.airiLoginPanelView = AiriUSLoginPanelView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)
	else
		arg0_7.airiLoginPanelView = AiriLoginPanelView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)
	end

	arg0_7.loginPanelView:SetShareData(arg0_7.shareData)

	arg0_7.transcodeAlertView = TranscodeAlertView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

	arg0_7.loginPanelView:SetShareData(arg0_7.shareData)

	arg0_7.yostarAlertView = YostarAlertView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

	arg0_7.loginPanelView:SetShareData(arg0_7.shareData)

	arg0_7.subViewList[LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW] = arg0_7.loginPanelView
	arg0_7.subViewList[LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW] = arg0_7.registerPanelView
	arg0_7.subViewList[LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW] = arg0_7.tencentLoginPanelView
	arg0_7.subViewList[LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW] = arg0_7.airiLoginPanelView
	arg0_7.subViewList[LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW] = arg0_7.transcodeAlertView
	arg0_7.subViewList[LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW] = arg0_7.yostarAlertView
	arg0_7.subViewList[LoginSceneConst.DEFINE.PRESS_TO_LOGIN] = arg0_7.pressToLogin
	arg0_7.subViewList[LoginSceneConst.DEFINE.BG_LAY] = arg0_7.bgLay
	arg0_7.subViewList[LoginSceneConst.DEFINE.SERVER_PANEL] = arg0_7.serversPanel
	arg0_7.subViewList[LoginSceneConst.DEFINE.ACCOUNT_BTN] = arg0_7.accountBtn
	arg0_7.subViewList[LoginSceneConst.DEFINE.CURRENT_SERVER] = arg0_7.currentServer
	arg0_7.age = arg0_7:findTF("background/age")

	if PLATFORM_CODE == PLATFORM_CH then
		onButton(arg0_7, arg0_7.age, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.cadpa_help.tip,
				title = pg.MsgboxMgr.TITLE_CADPA
			})
		end)
		SetActive(arg0_7.age, true)
	end

	SetActive(arg0_7.age, PLATFORM_CODE == PLATFORM_CH)
	setText(findTF(arg0_7.currentServer, "server_name"), "")
	arg0_7:switchToServer()
	arg0_7:initEvents()
end

function var0_0.setServerAccountData(arg0_13, arg1_13)
	local var0_13 = arg1_13.id
	local var1_13

	for iter0_13 = 1, #arg0_13.serversDic do
		if arg0_13.serversDic[iter0_13].id == var0_13 then
			var1_13 = arg0_13.serversDic[iter0_13]

			break
		end
	end

	if not var1_13 then
		return
	end

	local var2_13 = var1_13.tf

	if arg1_13 and arg1_13.level then
		setActive(findTF(var2_13, "mark/charactor"), true)
		setActive(findTF(var2_13, "mark/level"), true)
		setActive(findTF(var2_13, "mark/searching"), false)
		setText(findTF(var2_13, "mark/level"), "lv." .. arg1_13.level)
		setText(findTF(var2_13, "mark/level"), setColorStr("lv." .. arg1_13.level, "#ffffffff"))

		var1_13.level = arg1_13.level
	else
		setActive(findTF(var2_13, "mark/level"), true)
		setActive(findTF(var2_13, "mark/searching"), false)
		setActive(findTF(var2_13, "mark/charactor"), false)

		var1_13.level = 0

		setText(findTF(var2_13, "mark/level"), setColorStr(i18n("query_role_none"), "#d0d0d0FF"))
	end
end

function var0_0.searchAountState(arg0_14, arg1_14)
	arg0_14.searching = arg1_14

	for iter0_14 = 1, #arg0_14.serversDic do
		local var0_14 = arg0_14.serversDic[iter0_14].tf
		local var1_14 = arg0_14.serversDic[iter0_14].level

		setActive(findTF(var0_14, "mark"), true)

		if arg1_14 then
			setActive(findTF(var0_14, "mark/charactor"), false)
			setActive(findTF(var0_14, "mark/level"), true)
			setText(findTF(var0_14, "mark/level"), setColorStr(i18n("query_role"), "#d0d0d0FF"))
			setActive(findTF(var0_14, "mark/searching"), true)
		else
			if not var1_14 then
				setText(findTF(var0_14, "mark/level"), setColorStr(i18n("query_role_fail"), "#d0d0d0FF"))
			end

			setActive(findTF(var0_14, "mark/searching"), false)
		end
	end
end

function var0_0.initEvents(arg0_15)
	arg0_15:bind(LoginSceneConst.SWITCH_SUB_VIEW, function(arg0_16, arg1_16)
		arg0_15:switchSubView(arg1_16)
	end)
	arg0_15:bind(LoginSceneConst.CLEAR_REGISTER_VIEW, function(arg0_17)
		arg0_15.registerPanelView:ActionInvoke("Clear")
	end)
end

function var0_0.switchSubView(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.subViewList) do
		if isa(iter1_18, BaseSubView) then
			if table.contains(arg1_18, iter0_18) then
				iter1_18:CallbackInvoke(function()
					arg0_18.repairBtn:SetAsLastSibling()
				end)
				iter1_18:Load()
				iter1_18:ActionInvoke("Show")
			else
				iter1_18:ActionInvoke("Hide")
			end
		else
			setActive(iter1_18, table.contains(arg1_18, iter0_18))
		end
	end

	if not table.contains(arg1_18, LoginSceneConst.DEFINE.SERVER_PANEL) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18.serversPanel, arg0_18._tf)
	end

	if table.contains(arg1_18, LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW) then
		setActive(arg0_18.airiUidTxt, false)
	end

	arg0_18.userAgreenTF:SetAsLastSibling()
	arg0_18.repairBtn:SetAsLastSibling()
end

function var0_0.onBackPressed(arg0_20)
	if arg0_20.searching then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_20.serversPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20.serversPanel, arg0_20._tf)
		setActive(arg0_20.serversPanel, false)

		return
	end

	if isActive(arg0_20.userAgreenTF) then
		setActive(arg0_20.userAgreenTF, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20.userAgreenTF, arg0_20._tf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0_0.setUserData(arg0_21, arg1_21)
	setActive(arg0_21.airiUidTxt, true)
	setText(arg0_21.airiUidTxt, "uid: " .. arg1_21.arg2)
end

function var0_0.showUserAgreement(arg0_22, arg1_22)
	local var0_22

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_22.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.501960784313725)
	else
		var0_22 = true
	end

	local var1_22 = require("ShareCfg.UserAgreement")

	setActive(arg0_22.userAgreenTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_22.userAgreenTF)
	setText(arg0_22.userAgreenTF:Find("window/container/scrollrect/content/Text"), var1_22.content)
	onButton(arg0_22, arg0_22.userAgreenConfirmTF, function()
		if var0_22 then
			setActive(arg0_22.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_22.userAgreenTF, arg0_22._tf)

			if arg1_22 then
				arg1_22()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(arg0_22, arg0_22.userAgreenTF:Find("window/container/scrollrect"), function(arg0_24)
		if arg0_24.y <= 0.01 and not var0_22 then
			var0_22 = true

			if PLATFORM_CODE == PLATFORM_CH then
				arg0_22.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)
			end
		end
	end)
end

function var0_0.setBg(arg0_25)
	arg0_25.bgImg = arg0_25:findTF("background/bg"):GetComponent(typeof(Image))

	local var0_25 = arg0_25:findTF("background/bg"):GetComponent("AspectRatioFitter")

	if var0_25 then
		var0_25.aspectMode = AspectMode.FitInParent
	end

	if not arg0_25.isCriBg then
		setImageSprite(arg0_25.bgImg, arg0_25.staticBgSprite)
	else
		arg0_25.bgImg.enabled = false

		local var1_25 = arg0_25.criBgGo.transform

		var1_25:SetParent(arg0_25.bgImg.transform, false)
		var1_25:SetAsFirstSibling()

		local var2_25 = arg0_25.criBgGo:GetComponent("AspectRatioFitter")

		if var2_25 then
			var2_25.enabled = true
		end
	end
end

function var0_0.setLastLogin(arg0_26, arg1_26)
	arg0_26.shareData.lastLoginUser = arg1_26
end

function var0_0.setAutoLogin(arg0_27)
	arg0_27.shareData.autoLoginEnabled = true
end

function var0_0.setLastLoginServer(arg0_28, arg1_28)
	if not arg1_28 then
		setText(findTF(arg0_28.currentServer, "server_name"), "")

		arg0_28.shareData.lastLoginServer = nil

		arg0_28:updateAdviceServer()

		return
	end

	setText(findTF(arg0_28.currentServer, "server_name"), arg1_28.name)

	arg0_28.shareData.lastLoginServer = arg1_28
end

function var0_0.didEnter(arg0_29)
	onButton(arg0_29, arg0_29.closeUserAgreenTF, function()
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			setActive(arg0_29.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_29.userAgreenTF, arg0_29._tf)
		else
			setActive(arg0_29.userAgreenMainTF, false)
			onNextTick(function()
				setActive(arg0_29.userAgreenMainTF, true)
			end)
		end
	end, SFX_CANCEL)
	onButton(arg0_29, arg0_29.privateBtn, function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.licenceBtn, function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
	setActive(arg0_29.privateBtn, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0_29.licenceBtn, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		onButton(arg0_29, arg0_29.userDisagreeConfirmTF, function()
			setActive(arg0_29.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_29.userAgreenTF, arg0_29._tf)
		end)
	end

	setActive(arg0_29.serviceBtn, PLATFORM_CODE == PLATFORM_KR)
	onButton(arg0_29, arg0_29.serviceBtn, function()
		if PLATFORM_CODE == PLATFORM_KR then
			pg.SdkMgr.GetInstance():UserCenter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
		end
	end, SFX_MAIN)
	onButton(arg0_29, arg0_29.accountBtn, function()
		local var0_36 = pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER

		if not var0_36 then
			arg0_29:switchToLogin()
		elseif var0_36 and PLATFORM_KR == PLATFORM_CODE then
			pg.SdkMgr.GetInstance():SwitchAccount()
		end
	end, SFX_MAIN)
	onButton(arg0_29, arg0_29.repairBtn, function()
		pg.RepairResMgr.GetInstance():Repair()
	end)

	local function var0_29()
		local var0_38 = pg.SdkMgr.GetInstance():GetLoginType()

		if var0_38 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var0_38 == LoginType.PLATFORM_TENCENT then
			arg0_29:switchToTencentLogin()
		elseif var0_38 == LoginType.PLATFORM_INNER then
			arg0_29:switchToLogin()
		end
	end

	onButton(arg0_29, arg0_29.filingBtn, function()
		Application.OpenURL("http://sq.ccm.gov.cn:80/ccnt/sczr/service/business/emark/gameNetTag/4028c08b58bd467b0158bd8bd80d062a")
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.currentServer, function()
		if table.getCount(arg0_29.serverList or {}) == 0 then
			var0_29()
		else
			pg.UIMgr.GetInstance():BlurPanel(arg0_29.serversPanel)
			setActive(arg0_29.serversPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.serversPanel, function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_29.serversPanel, arg0_29._tf)
		setActive(arg0_29.serversPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_29, arg0_29:findTF("background"), function()
		if pg.CpkPlayMgr.GetInstance():OnPlaying() then
			return
		end

		if not arg0_29.initFinished then
			return
		end

		if arg0_29.isNeedResCheck then
			arg0_29.event:emit(LoginMediator.CHECK_RES)

			return
		end

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0_29.event:emit(LoginMediator.ON_LOGIN_PROCESS)

			return
		end

		if go(arg0_29.pressToLogin).activeSelf then
			if table.getCount(arg0_29.serverList or {}) == 0 then
				var0_29()

				return
			end

			if not arg0_29.shareData.lastLoginServer then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_choiseServer"))

				return
			end

			if arg0_29.shareData.lastLoginServer.status == Server.STATUS.VINDICATE or arg0_29.shareData.lastLoginServer.status == Server.STATUS.FULL then
				ServerStateChecker.New():Execute(function(arg0_43)
					if arg0_43 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_disabled"))
					else
						arg0_29.event:emit(LoginMediator.ON_SERVER, arg0_29.shareData.lastLoginServer)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
					end
				end)

				return
			end

			arg0_29.event:emit(LoginMediator.ON_SERVER, arg0_29.shareData.lastLoginServer)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		end
	end)

	if arg0_29.isOpPlay then
		onButton(arg0_29, arg0_29.opBtn, function()
			if arg0_29.initFinished and not pg.CpkPlayMgr.GetInstance():OnPlaying() then
				arg0_29:playOpening()
			end
		end)

		if PLATFORM_CODE ~= PLATFORM_JP and PlayerPrefs.GetString("op_ver", "") ~= arg0_29.opVersion then
			arg0_29:playOpening(function()
				PlayerPrefs.SetString("op_ver", arg0_29.opVersion)
				arg0_29:playExtraVoice()

				arg0_29.initFinished = true

				arg0_29.event:emit(LoginMediator.ON_LOGIN_PROCESS)
			end)

			return
		end

		arg0_29.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	else
		arg0_29.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	end

	arg0_29:playExtraVoice()

	arg0_29.initFinished = true

	arg0_29:InitPrivateAndLicence()
end

function var0_0.InitPrivateAndLicence(arg0_46)
	local var0_46 = PLATFORM_CODE == PLATFORM_CH or IsUnityEditor

	setActive(arg0_46.privateBtn, var0_46)
	setActive(arg0_46.licenceBtn, var0_46)

	if var0_46 then
		onButton(arg0_46, arg0_46.privateBtn, function()
			pg.SdkMgr.GetInstance():ShowPrivate()
		end, SFX_PANEL)
		onButton(arg0_46, arg0_46.licenceBtn, function()
			pg.SdkMgr.GetInstance():ShowLicence()
		end, SFX_PANEL)
	end
end

local function var2_0()
	local var0_49 = pg.gameset.login_extra_voice.description

	if var0_49 and #var0_49 > 0 then
		local var1_49 = var0_49[math.clamp(math.floor(math.random() * #var0_49) + 1, 1, #var0_49)]

		return "cv-" .. var1_49, "extra"
	end

	return nil, nil
end

local function var3_0(arg0_50)
	local var0_50 = arg0_50.description[1]
	local var1_50 = arg0_50.description[2]
	local var2_50 = arg0_50.description[3]

	if pg.TimeMgr.GetInstance():inTime(var1_50) then
		local var3_50 = math.random(1, var2_50)

		return var0_50, "extra" .. var3_50
	end

	return nil, nil
end

function var0_0.GetExtraVoiceSheetAndCue(arg0_51)
	local var0_51
	local var1_51
	local var2_51 = pg.gameset.new_login_extra_voice

	if var2_51 then
		var0_51, var1_51 = var3_0(var2_51)
	end

	if not var0_51 or not var1_51 then
		var0_51, var1_51 = var2_0()
	end

	return var0_51, var1_51
end

function var0_0.playExtraVoice(arg0_52)
	local var0_52, var1_52 = arg0_52:GetExtraVoiceSheetAndCue()

	if var0_52 and var1_52 then
		arg0_52.loginCueSheet = var0_52

		pg.CriMgr.GetInstance():PlayCV_V3(var0_52, var1_52)
	end
end

function var0_0.unloadExtraVoice(arg0_53)
	if arg0_53.loginCueSheet then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_53.loginCueSheet)

		arg0_53.loginCueSheet = nil
	end
end

function var0_0.autoLogin(arg0_54)
	if arg0_54.shareData.lastLoginUser then
		if arg0_54.shareData.autoLoginEnabled then
			arg0_54.event:emit(LoginMediator.ON_LOGIN, arg0_54.shareData.lastLoginUser)
		end

		if arg0_54.loginPanelView:GetLoaded() then
			if arg0_54.shareData.lastLoginUser.type == 1 then
				arg0_54.loginPanelView:SetContent(arg0_54.shareData.lastLoginUser.arg2, arg0_54.shareData.lastLoginUser.arg3)
			elseif arg0_54.shareData.lastLoginUser.type == 2 then
				arg0_54.loginPanelView:SetContent(arg0_54.shareData.lastLoginUser.arg1, arg0_54.shareData.lastLoginUser.arg2)
			end
		end
	end
end

local var4_0 = {
	{
		0.403921568627451,
		1,
		0.219607843137255,
		0.627450980392157
	},
	{
		0.607843137254902,
		0.607843137254902,
		0.607843137254902,
		0.627450980392157
	},
	{
		1,
		0.36078431372549,
		0.219607843137255,
		0.627450980392157
	},
	{
		1,
		0.658823529411765,
		0.219607843137255,
		0.627450980392157
	}
}

function var0_0.updateServerTF(arg0_55, arg1_55, arg2_55)
	setText(findTF(arg1_55, "name"), "-  " .. arg2_55.name .. "  -")
	arg0_55:setSpriteTo(arg0_55.iconSpries[arg2_55.status + 1], findTF(arg1_55, "statu"), true)

	findTF(arg1_55, "statu_1"):GetComponent("Image").color = Color.New(var4_0[arg2_55.status + 1][1], var4_0[arg2_55.status + 1][2], var4_0[arg2_55.status + 1][3], var4_0[arg2_55.status + 1][4])

	setActive(findTF(arg1_55, "mark"), arg2_55.isLogined)
	setActive(arg0_55:findTF("tag_new", arg1_55), arg2_55.isNew)
	setActive(arg0_55:findTF("tag_hot", arg1_55), arg2_55.isHot)
	onButton(arg0_55, arg1_55, function()
		if arg2_55.status == Server.STATUS.VINDICATE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_vindicate"))

			return
		end

		if arg2_55.status == Server.STATUS.FULL then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_full"))

			return
		end

		arg0_55:setLastLoginServer(arg2_55)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_55.serversPanel, arg0_55._tf)
		setActive(arg0_55.serversPanel, false)
	end, SFX_CONFIRM)
end

function var0_0.updateAdviceServer(arg0_57)
	if not arg0_57.recentTF or not arg0_57.adviceTF then
		return
	end

	setActive(arg0_57.recentTF, arg0_57.shareData.lastLoginServer)

	if arg0_57.shareData.lastLoginServer then
		local var0_57 = findTF(arg0_57.recentTF, "server")

		arg0_57:updateServerTF(var0_57, arg0_57.shareData.lastLoginServer)
	end

	local var1_57 = getProxy(ServerProxy).firstServer

	setActive(arg0_57.adviceTF, var1_57)

	if var1_57 then
		local var2_57 = findTF(arg0_57.adviceTF, "server")

		arg0_57:updateServerTF(var2_57, var1_57)
	end
end

function var0_0.updateServerList(arg0_58, arg1_58)
	arg0_58.serverList = arg1_58

	local var0_58 = _.sort(_.values(arg1_58), function(arg0_59, arg1_59)
		return arg0_59.sortIndex < arg1_59.sortIndex
	end)

	removeAllChildren(arg0_58.servers)

	if IsUnityEditor then
		table.sort(var0_58, function(arg0_60, arg1_60)
			local var0_60 = string.lower(arg0_60.name)
			local var1_60 = string.lower(arg1_60.name)

			return string.byte(var0_60, 1) > string.byte(var1_60, 1)
		end)
	end

	arg0_58.serversDic = {}

	for iter0_58, iter1_58 in pairs(var0_58) do
		local var1_58 = cloneTplTo(arg0_58.serverTpl, arg0_58.servers)

		arg0_58:updateServerTF(var1_58, iter1_58)
		table.insert(arg0_58.serversDic, {
			server = iter1_58,
			tf = var1_58,
			id = iter1_58.id
		})
	end
end

function var0_0.fillterRefundServer(arg0_61)
	local var0_61 = getProxy(UserProxy)
	local var1_61 = {}

	if var0_61.data.limitServerIds and #var0_61.data.limitServerIds > 0 and arg0_61.serverList and #arg0_61.serverList > 0 then
		local var2_61 = var0_61.data.limitServerIds
		local var3_61

		for iter0_61, iter1_61 in pairs(arg0_61.serverList) do
			local var4_61 = iter1_61.id
			local var5_61 = false

			for iter2_61, iter3_61 in pairs(var2_61) do
				if var2_61[iter2_61] == var4_61 and not var5_61 then
					if not var3_61 then
						var3_61 = "\n" .. iter1_61.name
					else
						var3_61 = var3_61 .. "," .. iter1_61.name
					end

					table.insert(var1_61, iter1_61)

					var5_61 = true
				end
			end
		end

		arg0_61:updateServerList(var1_61)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("login_arrears_tips", var3_61),
			onYes = function()
				return
			end
		})
	end
end

function var0_0.switchToTencentLogin(arg0_63)
	arg0_63:switchSubView({
		LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW
	})
end

function var0_0.switchToAiriLogin(arg0_64)
	arg0_64:switchSubView({
		LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
		LoginSceneConst.DEFINE.PRESS_TO_LOGIN
	})
end

function var0_0.switchToLogin(arg0_65)
	arg0_65:switchSubView({
		LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
	})
end

function var0_0.switchToRegister(arg0_66)
	arg0_66:switchSubView({
		LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
	})
end

function var0_0.switchToServer(arg0_67)
	arg0_67:updateAdviceServer()

	if pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER and PLATFORM_CODE ~= PLATFORM_KR then
		arg0_67:switchSubView({
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	else
		arg0_67:switchSubView({
			LoginSceneConst.DEFINE.ACCOUNT_BTN,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	end
end

function var0_0.SwitchToWaitPanel(arg0_68, arg1_68)
	local var0_68 = arg0_68:findTF("Msgbox")
	local var1_68 = arg0_68:findTF("window/content", var0_68)

	arg0_68.waitTimer = nil

	local var2_68 = 0
	local var3_68 = arg1_68

	arg0_68.waitTimer = Timer.New(function()
		setText(var1_68, i18n("login_wait_tip", var3_68))

		arg1_68 = arg1_68 - 1

		if math.random(0, 1) == 1 then
			var3_68 = arg1_68
		end

		if arg1_68 <= 0 then
			triggerButton(arg0_68:findTF("background"))
			arg0_68.waitTimer:Stop()

			arg0_68.waitTimer = nil
		end
	end, 1, -1)

	arg0_68.waitTimer:Start()
	arg0_68.waitTimer.func()
	setActive(var0_68, true)
end

function var0_0.willExit(arg0_70)
	if arg0_70.waitTimer then
		arg0_70.waitTimer:Stop()

		arg0_70.waitTimer = nil
	end

	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_70.loginPanelView:Destroy()
	arg0_70.registerPanelView:Destroy()
	arg0_70.tencentLoginPanelView:Destroy()
	arg0_70.airiLoginPanelView:Destroy()
	arg0_70.transcodeAlertView:Destroy()
	arg0_70.yostarAlertView:Destroy()
	arg0_70.switchGatewayBtn:Dispose()

	arg0_70.iconSpries = nil
end

function var0_0.playOpening(arg0_71, arg1_71)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		if not arg0_71.cg then
			arg0_71.cg = GetOrAddComponent(arg0_71._tf, "CanvasGroup")
		end

		arg0_71.cg.alpha = 0
	end, function()
		arg0_71.cg.alpha = 1

		if arg1_71 then
			arg1_71()
		end
	end, "ui", "opening", true, false)

	arg0_71.onPlayingOP = true
end

function var0_0.closeYostarAlertView(arg0_74)
	if arg0_74.yostarAlertView and arg0_74.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_74.yostarAlertView:Destroy()
	end
end

function var0_0.onLoadDataDone(arg0_75)
	arg0_75:unloadExtraVoice()

	if getProxy(PlayerProxy) then
		getProxy(PlayerProxy):setFlag("login", true)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	end
end

return var0_0
