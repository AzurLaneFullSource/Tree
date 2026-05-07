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

	arg0_7.adapt = arg0_7._tf:Find("adapt")
	arg0_7.version = arg0_7.adapt:Find("version")
	arg0_7.version:GetComponent("Text").text = "ver " .. var0_7.CurrentVersion:ToString()
	arg0_7.bgLay = arg0_7.adapt:Find("bg_lay")
	arg0_7.accountBtn = arg0_7.adapt:Find("bg_lay/buttons/account_button")
	arg0_7.repairBtn = arg0_7.adapt:Find("btns/repair_button")
	arg0_7.privateBtn = arg0_7.adapt:Find("btns/private_btn")
	arg0_7.licenceBtn = arg0_7.adapt:Find("btns/Licence_btn")
	arg0_7.chInfo = arg0_7._tf:Find("background/info")

	setActive(arg0_7.chInfo, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_7.urlClick = arg0_7.chInfo:Find("urlClick")

		onButton(arg0_7, arg0_7.urlClick, function()
			Application.OpenURL("https://beian.miit.gov.cn/#/home")
		end)
	end

	arg0_7.pressToLogin = GetOrAddComponent(arg0_7._tf:Find("background/press_to_login"), "CanvasGroup")

	LeanTween.alphaCanvas(arg0_7.pressToLogin, 0.25, var1_0):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0_7.currentServer = arg0_7.adapt:Find("current_server")
	arg0_7.serviceBtn = arg0_7.adapt:Find("bg_lay/buttons/service_button")
	arg0_7.filingBtn = arg0_7.adapt:Find("filingBtn")

	setActive(arg0_7.filingBtn, PLATFORM_CODE == PLATFORM_CH)

	arg0_7.serversPanel = arg0_7.adapt:Find("servers")
	arg0_7.servers = arg0_7.serversPanel:Find("panel/panel/servers/content/server_list")
	arg0_7.serverTpl = arg0_7:getTpl("server_tpl")
	arg0_7.recentTF = arg0_7.serversPanel:Find("panel/panel/servers/content/advice_panel/recent")
	arg0_7.adviceTF = arg0_7.serversPanel:Find("panel/panel/servers/content/advice_panel/advice")
	arg0_7.userAgreenTF = arg0_7.adapt:Find("UserAgreement")
	arg0_7.userAgreenMainTF = arg0_7.adapt:Find("UserAgreement/window")
	arg0_7.closeUserAgreenTF = arg0_7.userAgreenTF:Find("window/close_btn")
	arg0_7.userAgreenConfirmTF = arg0_7.adapt:Find("UserAgreement/window/accept_btn")
	arg0_7.userDisagreeConfirmTF = arg0_7.adapt:Find("UserAgreement/window/disagree_btn")
	arg0_7.switchGatewayBtn = SwitchGatewayBtn.New(arg0_7.adapt:Find("servers/panel/panel/switch_platform"))

	if PLATFORM == PLATFORM_OPENHARMONY then
		arg0_7.switchGatewayBtn4Oh = SwitchGatewayBtn4OpenHarmony.New(arg0_7.adapt:Find("servers/panel/panel/switch_platform"))
	end

	setActive(arg0_7.userAgreenTF, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7.userAgreenTF, arg0_7._tf)

	arg0_7.opBtn = arg0_7.adapt:Find("bg_lay/buttons/opBtn")

	if arg0_7.opBtn then
		setActive(arg0_7.opBtn, arg0_7.isOpPlay)
	end

	arg0_7.airiUidTxt = arg0_7.adapt:Find("airi_uid")
	arg0_7.shareData = {}
	arg0_7.searchAccount = arg0_7.serversPanel:Find("panel/panel/searchAccount")

	setText(findTF(arg0_7.searchAccount, "text"), i18n("query_role_button"))

	arg0_7.serverPanelCanvas = GetComponent(arg0_7.adapt:Find("servers/panel/panel/servers"), typeof(CanvasGroup))

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

	arg0_7.airiLoginPanelView = AiriLoginPanelView.New(arg0_7._tf, arg0_7.event, arg0_7.contextData)

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
	arg0_7.age = arg0_7.adapt:Find("age")

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

function var0_0.FlushGateWaySwitchBtn(arg0_13)
	arg0_13.switchGatewayBtn:Flush()

	if PLATFORM == PLATFORM_OPENHARMONY then
		arg0_13.switchGatewayBtn4Oh:Flush()
	end
end

function var0_0.setServerAccountData(arg0_14, arg1_14)
	local var0_14 = arg1_14.id
	local var1_14

	for iter0_14 = 1, #arg0_14.serversDic do
		if arg0_14.serversDic[iter0_14].id == var0_14 then
			var1_14 = arg0_14.serversDic[iter0_14]

			break
		end
	end

	if not var1_14 then
		return
	end

	local var2_14 = var1_14.tf

	if arg1_14 and arg1_14.level then
		setActive(findTF(var2_14, "mark/charactor"), true)
		setActive(findTF(var2_14, "mark/level"), true)
		setActive(findTF(var2_14, "mark/searching"), false)
		setText(findTF(var2_14, "mark/level"), "lv." .. arg1_14.level)
		setText(findTF(var2_14, "mark/level"), setColorStr("lv." .. arg1_14.level, "#ffffffff"))

		var1_14.level = arg1_14.level
	elseif arg1_14 and arg1_14.isFail then
		setActive(findTF(var2_14, "mark/level"), true)
		setActive(findTF(var2_14, "mark/searching"), false)
		setActive(findTF(var2_14, "mark/charactor"), false)

		var1_14.level = 0

		setText(findTF(var2_14, "mark/level"), setColorStr(i18n("query_role_fail"), "#ff9c00ff"))
	else
		setActive(findTF(var2_14, "mark/level"), true)
		setActive(findTF(var2_14, "mark/searching"), false)
		setActive(findTF(var2_14, "mark/charactor"), false)

		var1_14.level = 0

		setText(findTF(var2_14, "mark/level"), setColorStr(i18n("query_role_none"), "#d0d0d0FF"))
	end
end

function var0_0.searchAountState(arg0_15, arg1_15)
	arg0_15.searching = arg1_15

	for iter0_15 = 1, #arg0_15.serversDic do
		local var0_15 = arg0_15.serversDic[iter0_15].tf
		local var1_15 = arg0_15.serversDic[iter0_15].level

		setActive(findTF(var0_15, "mark"), true)

		if arg1_15 then
			setActive(findTF(var0_15, "mark/charactor"), false)
			setActive(findTF(var0_15, "mark/level"), true)
			setText(findTF(var0_15, "mark/level"), setColorStr(i18n("query_role"), "#d0d0d0FF"))
			setActive(findTF(var0_15, "mark/searching"), true)
		else
			if not var1_15 then
				setText(findTF(var0_15, "mark/level"), setColorStr(i18n("query_role_fail"), "#d0d0d0FF"))
			end

			setActive(findTF(var0_15, "mark/searching"), false)
		end
	end
end

function var0_0.initEvents(arg0_16)
	arg0_16:bind(LoginSceneConst.SWITCH_SUB_VIEW, function(arg0_17, arg1_17)
		arg0_16:switchSubView(arg1_17)
	end)
	arg0_16:bind(LoginSceneConst.CLEAR_REGISTER_VIEW, function(arg0_18)
		arg0_16.registerPanelView:ActionInvoke("Clear")
	end)
end

function var0_0.switchSubView(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.subViewList) do
		if isa(iter1_19, BaseSubView) then
			if table.contains(arg1_19, iter0_19) then
				iter1_19:CallbackInvoke(function()
					arg0_19.repairBtn:SetAsLastSibling()
				end)
				iter1_19:Load()
				iter1_19:ActionInvoke("Show")
			else
				iter1_19:ActionInvoke("Hide")
			end
		else
			setActive(iter1_19, table.contains(arg1_19, iter0_19))
		end
	end

	if not table.contains(arg1_19, LoginSceneConst.DEFINE.SERVER_PANEL) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19.serversPanel, arg0_19._tf)
	end

	if table.contains(arg1_19, LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW) then
		setActive(arg0_19.airiUidTxt, false)
	end

	arg0_19.userAgreenTF:SetAsLastSibling()
	arg0_19.repairBtn:SetAsLastSibling()
end

function var0_0.onBackPressed(arg0_21)
	if arg0_21.searching then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_21.serversPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.serversPanel, arg0_21._tf)
		setActive(arg0_21.serversPanel, false)

		return
	end

	if isActive(arg0_21.userAgreenTF) then
		setActive(arg0_21.userAgreenTF, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.userAgreenTF, arg0_21._tf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0_0.setUserData(arg0_22, arg1_22)
	setActive(arg0_22.airiUidTxt, true)
	setText(arg0_22.airiUidTxt, "uid: " .. arg1_22.arg2)
end

function var0_0.showUserAgreement(arg0_23, arg1_23)
	local var0_23

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_23.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.501960784313725)
	else
		var0_23 = true
	end

	local var1_23 = require("ShareCfg.UserAgreement")

	setActive(arg0_23.userAgreenTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_23.userAgreenTF)
	setText(arg0_23.userAgreenTF:Find("window/container/scrollrect/content/Text"), var1_23.content)
	onButton(arg0_23, arg0_23.userAgreenConfirmTF, function()
		if var0_23 then
			setActive(arg0_23.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23.userAgreenTF, arg0_23._tf)

			if arg1_23 then
				arg1_23()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(arg0_23, arg0_23.userAgreenTF:Find("window/container/scrollrect"), function(arg0_25)
		if arg0_25.y <= 0.01 and not var0_23 then
			var0_23 = true

			if PLATFORM_CODE == PLATFORM_CH then
				arg0_23.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)
			end
		end
	end)
end

function var0_0.setBg(arg0_26)
	arg0_26.bgImg = arg0_26._tf:Find("background/bg"):GetComponent(typeof(Image))

	if not arg0_26.isCriBg then
		setImageSprite(arg0_26.bgImg, arg0_26.staticBgSprite)
	else
		arg0_26.bgImg.enabled = false

		local var0_26 = arg0_26.criBgGo.transform

		var0_26:SetParent(arg0_26.bgImg.transform, false)
		var0_26:SetAsFirstSibling()

		local var1_26 = arg0_26.criBgGo:GetComponent("AspectRatioFitter")

		if var1_26 then
			var1_26.enabled = true
		end
	end
end

function var0_0.setLastLogin(arg0_27, arg1_27)
	arg0_27.shareData.lastLoginUser = arg1_27
end

function var0_0.setAutoLogin(arg0_28)
	arg0_28.shareData.autoLoginEnabled = true
end

function var0_0.setLastLoginServer(arg0_29, arg1_29)
	if not arg1_29 then
		setText(findTF(arg0_29.currentServer, "server_name"), "")

		arg0_29.shareData.lastLoginServer = nil

		arg0_29:updateAdviceServer()

		return
	end

	setText(findTF(arg0_29.currentServer, "server_name"), arg1_29.name)

	arg0_29.shareData.lastLoginServer = arg1_29
end

function var0_0.didEnter(arg0_30)
	onButton(arg0_30, arg0_30.closeUserAgreenTF, function()
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			setActive(arg0_30.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30.userAgreenTF, arg0_30._tf)
		else
			setActive(arg0_30.userAgreenMainTF, false)
			onNextTick(function()
				setActive(arg0_30.userAgreenMainTF, true)
			end)
		end
	end, SFX_CANCEL)
	onButton(arg0_30, arg0_30.privateBtn, function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0_30, arg0_30.licenceBtn, function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
	setActive(arg0_30.privateBtn, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0_30.licenceBtn, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		onButton(arg0_30, arg0_30.userDisagreeConfirmTF, function()
			setActive(arg0_30.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30.userAgreenTF, arg0_30._tf)
		end)
	end

	setActive(arg0_30.serviceBtn, PLATFORM_CODE == PLATFORM_KR)
	onButton(arg0_30, arg0_30.serviceBtn, function()
		if PLATFORM_CODE == PLATFORM_KR then
			pg.SdkMgr.GetInstance():UserCenter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
		end
	end, SFX_MAIN)
	onButton(arg0_30, arg0_30.accountBtn, function()
		local var0_37 = pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER

		if not var0_37 then
			arg0_30:switchToLogin()
		elseif var0_37 and PLATFORM_KR == PLATFORM_CODE then
			pg.SdkMgr.GetInstance():SwitchAccount()
		end
	end, SFX_MAIN)
	onButton(arg0_30, arg0_30.repairBtn, function()
		pg.RepairResMgr.GetInstance():Repair()
	end)

	local function var0_30()
		local var0_39 = pg.SdkMgr.GetInstance():GetLoginType()

		if var0_39 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var0_39 == LoginType.PLATFORM_TENCENT then
			arg0_30:switchToTencentLogin()
		elseif var0_39 == LoginType.PLATFORM_INNER then
			arg0_30:switchToLogin()
		end
	end

	onButton(arg0_30, arg0_30.filingBtn, function()
		Application.OpenURL("http://sq.ccm.gov.cn:80/ccnt/sczr/service/business/emark/gameNetTag/4028c08b58bd467b0158bd8bd80d062a")
	end, SFX_PANEL)
	onButton(arg0_30, arg0_30.currentServer, function()
		if table.getCount(arg0_30.serverList or {}) == 0 then
			var0_30()
		else
			pg.UIMgr.GetInstance():BlurPanel(arg0_30.serversPanel)
			setActive(arg0_30.serversPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_30, arg0_30.serversPanel, function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30.serversPanel, arg0_30._tf)
		setActive(arg0_30.serversPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_30, arg0_30._tf:Find("background"), function()
		if pg.CpkPlayMgr.GetInstance():OnPlaying() then
			return
		end

		if not arg0_30.initFinished then
			return
		end

		if arg0_30.isNeedResCheck then
			arg0_30.event:emit(LoginMediator.CHECK_RES)

			return
		end

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0_30.event:emit(LoginMediator.ON_LOGIN_PROCESS)

			return
		end

		if go(arg0_30.pressToLogin).activeSelf then
			if table.getCount(arg0_30.serverList or {}) == 0 then
				var0_30()

				return
			end

			if not arg0_30.shareData.lastLoginServer then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_choiseServer"))

				return
			end

			if arg0_30.shareData.lastLoginServer.status == Server.STATUS.VINDICATE or arg0_30.shareData.lastLoginServer.status == Server.STATUS.FULL then
				ServerStateChecker.New():Execute(function(arg0_44)
					if arg0_44 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_disabled"))
					else
						arg0_30.event:emit(LoginMediator.ON_SERVER, arg0_30.shareData.lastLoginServer)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
					end
				end)

				return
			end

			arg0_30.event:emit(LoginMediator.ON_SERVER, arg0_30.shareData.lastLoginServer)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		end
	end)

	if arg0_30.isOpPlay then
		onButton(arg0_30, arg0_30.opBtn, function()
			if arg0_30.initFinished and not pg.CpkPlayMgr.GetInstance():OnPlaying() then
				arg0_30:playOpening()
			end
		end)

		if PLATFORM_CODE ~= PLATFORM_JP and PlayerPrefs.GetString("op_ver", "") ~= arg0_30.opVersion then
			arg0_30:playOpening(function()
				PlayerPrefs.SetString("op_ver", arg0_30.opVersion)
				arg0_30:playExtraVoice()

				arg0_30.initFinished = true

				arg0_30.event:emit(LoginMediator.ON_LOGIN_PROCESS)
			end)

			return
		end

		arg0_30.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	else
		arg0_30.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	end

	arg0_30:playExtraVoice()

	arg0_30.initFinished = true

	arg0_30:InitPrivateAndLicence()
end

function var0_0.InitPrivateAndLicence(arg0_47)
	local var0_47 = PLATFORM_CODE == PLATFORM_CH or IsUnityEditor

	setActive(arg0_47.privateBtn, var0_47)
	setActive(arg0_47.licenceBtn, var0_47)

	if var0_47 then
		onButton(arg0_47, arg0_47.privateBtn, function()
			pg.SdkMgr.GetInstance():ShowPrivate()
		end, SFX_PANEL)
		onButton(arg0_47, arg0_47.licenceBtn, function()
			pg.SdkMgr.GetInstance():ShowLicence()
		end, SFX_PANEL)
	end
end

local function var2_0()
	local var0_50 = pg.gameset.login_extra_voice.description

	if var0_50 and #var0_50 > 0 then
		local var1_50 = var0_50[math.clamp(math.floor(math.random() * #var0_50) + 1, 1, #var0_50)]

		return "cv-" .. var1_50, "extra"
	end

	return nil, nil
end

local function var3_0(arg0_51)
	local var0_51 = arg0_51.description[1]
	local var1_51 = arg0_51.description[2]
	local var2_51 = arg0_51.description[3]

	if pg.TimeMgr.GetInstance():inTime(var1_51) then
		local var3_51 = math.random(1, var2_51)

		return var0_51, "extra" .. var3_51
	end

	return nil, nil
end

function var0_0.GetExtraVoiceSheetAndCue(arg0_52)
	local var0_52
	local var1_52
	local var2_52 = pg.gameset.new_login_extra_voice

	if var2_52 then
		var0_52, var1_52 = var3_0(var2_52)
	end

	if not var0_52 or not var1_52 then
		var0_52, var1_52 = var2_0()
	end

	return var0_52, var1_52
end

function var0_0.playExtraVoice(arg0_53)
	local var0_53, var1_53 = arg0_53:GetExtraVoiceSheetAndCue()

	if var0_53 and var1_53 then
		arg0_53.loginCueSheet = var0_53

		pg.CriMgr.GetInstance():PlayCV_V3(var0_53, var1_53)
	end
end

function var0_0.unloadExtraVoice(arg0_54)
	if arg0_54.loginCueSheet then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_54.loginCueSheet)

		arg0_54.loginCueSheet = nil
	end
end

function var0_0.autoLogin(arg0_55)
	if arg0_55.shareData.lastLoginUser then
		if arg0_55.shareData.autoLoginEnabled then
			arg0_55.event:emit(LoginMediator.ON_LOGIN, arg0_55.shareData.lastLoginUser)
		end

		if arg0_55.loginPanelView:GetLoaded() then
			if arg0_55.shareData.lastLoginUser.type == 1 then
				arg0_55.loginPanelView:ActionInvoke("SetContent", arg0_55.shareData.lastLoginUser.arg2, arg0_55.shareData.lastLoginUser.arg3)
			elseif arg0_55.shareData.lastLoginUser.type == 2 then
				arg0_55.loginPanelView:ActionInvoke("SetContent", arg0_55.shareData.lastLoginUser.arg1, arg0_55.shareData.lastLoginUser.arg2)
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

function var0_0.updateServerTF(arg0_56, arg1_56, arg2_56)
	setText(findTF(arg1_56, "name"), "-  " .. arg2_56.name .. "  -")
	arg0_56:setSpriteTo(arg0_56.iconSpries[arg2_56.status + 1], findTF(arg1_56, "statu"), true)

	findTF(arg1_56, "statu_1"):GetComponent("Image").color = Color.New(var4_0[arg2_56.status + 1][1], var4_0[arg2_56.status + 1][2], var4_0[arg2_56.status + 1][3], var4_0[arg2_56.status + 1][4])

	setActive(findTF(arg1_56, "mark"), arg2_56.isLogined)
	setActive(arg1_56:Find("tag_new"), arg2_56.isNew)
	setActive(arg1_56:Find("tag_hot"), arg2_56.isHot)
	onButton(arg0_56, arg1_56, function()
		if arg2_56.status == Server.STATUS.VINDICATE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_vindicate"))

			return
		end

		if arg2_56.status == Server.STATUS.FULL then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_full"))

			return
		end

		arg0_56:setLastLoginServer(arg2_56)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_56.serversPanel, arg0_56._tf)
		setActive(arg0_56.serversPanel, false)
	end, SFX_CONFIRM)
end

function var0_0.updateAdviceServer(arg0_58)
	if not arg0_58.recentTF or not arg0_58.adviceTF then
		return
	end

	setActive(arg0_58.recentTF, arg0_58.shareData.lastLoginServer)

	if arg0_58.shareData.lastLoginServer then
		local var0_58 = findTF(arg0_58.recentTF, "server")

		arg0_58:updateServerTF(var0_58, arg0_58.shareData.lastLoginServer)
	end

	local var1_58 = getProxy(ServerProxy).firstServer

	setActive(arg0_58.adviceTF, var1_58)

	if var1_58 then
		local var2_58 = findTF(arg0_58.adviceTF, "server")

		arg0_58:updateServerTF(var2_58, var1_58)
	end
end

function var0_0.updateServerList(arg0_59, arg1_59)
	arg0_59.serverList = arg1_59

	local var0_59 = _.sort(_.values(arg1_59), function(arg0_60, arg1_60)
		return arg0_60.sortIndex < arg1_60.sortIndex
	end)

	removeAllChildren(arg0_59.servers)

	if IsUnityEditor then
		table.sort(var0_59, function(arg0_61, arg1_61)
			local var0_61 = string.lower(arg0_61.name)
			local var1_61 = string.lower(arg1_61.name)

			return string.byte(var0_61, 1) > string.byte(var1_61, 1)
		end)
	end

	arg0_59.serversDic = {}

	for iter0_59, iter1_59 in pairs(var0_59) do
		local var1_59 = cloneTplTo(arg0_59.serverTpl, arg0_59.servers)

		arg0_59:updateServerTF(var1_59, iter1_59)
		table.insert(arg0_59.serversDic, {
			server = iter1_59,
			tf = var1_59,
			id = iter1_59.id
		})
	end
end

function var0_0.fillterRefundServer(arg0_62)
	local var0_62 = getProxy(UserProxy)
	local var1_62 = {}

	if var0_62.data.limitServerIds and #var0_62.data.limitServerIds > 0 and arg0_62.serverList and #arg0_62.serverList > 0 then
		local var2_62 = var0_62.data.limitServerIds
		local var3_62

		for iter0_62, iter1_62 in pairs(arg0_62.serverList) do
			local var4_62 = iter1_62.id
			local var5_62 = false

			for iter2_62, iter3_62 in pairs(var2_62) do
				if var2_62[iter2_62] == var4_62 and not var5_62 then
					if not var3_62 then
						var3_62 = "\n" .. iter1_62.name
					else
						var3_62 = var3_62 .. "," .. iter1_62.name
					end

					table.insert(var1_62, iter1_62)

					var5_62 = true
				end
			end
		end

		arg0_62:updateServerList(var1_62)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("login_arrears_tips", var3_62),
			onYes = function()
				return
			end
		})
	end
end

function var0_0.switchToTencentLogin(arg0_64)
	arg0_64:switchSubView({
		LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW
	})
end

function var0_0.switchToAiriLogin(arg0_65)
	arg0_65:switchSubView({
		LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
		LoginSceneConst.DEFINE.PRESS_TO_LOGIN
	})
end

function var0_0.switchToLogin(arg0_66)
	arg0_66:switchSubView({
		LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
	})
end

function var0_0.switchToRegister(arg0_67)
	arg0_67:switchSubView({
		LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
	})
end

function var0_0.switchToServer(arg0_68)
	arg0_68:updateAdviceServer()

	if pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER and PLATFORM_CODE ~= PLATFORM_KR then
		arg0_68:switchSubView({
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	else
		arg0_68:switchSubView({
			LoginSceneConst.DEFINE.ACCOUNT_BTN,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	end
end

function var0_0.SwitchToWaitPanel(arg0_69, arg1_69)
	local var0_69 = arg0_69.adapt:Find("Msgbox")
	local var1_69 = var0_69:Find("window/content")

	arg0_69.waitTimer = nil

	local var2_69 = 0
	local var3_69 = arg1_69

	arg0_69.waitTimer = Timer.New(function()
		setText(var1_69, i18n("login_wait_tip", var3_69))

		arg1_69 = arg1_69 - 1

		if math.random(0, 1) == 1 then
			var3_69 = arg1_69
		end

		if arg1_69 <= 0 then
			triggerButton(arg0_69._tf:Find("background"))
			arg0_69.waitTimer:Stop()

			arg0_69.waitTimer = nil
		end
	end, 1, -1)

	arg0_69.waitTimer:Start()
	arg0_69.waitTimer.func()
	setActive(var0_69, true)
end

function var0_0.willExit(arg0_71)
	if arg0_71.waitTimer then
		arg0_71.waitTimer:Stop()

		arg0_71.waitTimer = nil
	end

	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_71.loginPanelView:Destroy()
	arg0_71.registerPanelView:Destroy()
	arg0_71.tencentLoginPanelView:Destroy()
	arg0_71.airiLoginPanelView:Destroy()
	arg0_71.transcodeAlertView:Destroy()
	arg0_71.yostarAlertView:Destroy()
	arg0_71.switchGatewayBtn:Dispose()

	if PLATFORM == PLATFORM_OPENHARMONY then
		arg0_71.switchGatewayBtn4Oh:Dispose()
	end

	arg0_71.iconSpries = nil
end

function var0_0.playOpening(arg0_72, arg1_72)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		if not arg0_72.cg then
			arg0_72.cg = GetOrAddComponent(arg0_72._tf, "CanvasGroup")
		end

		arg0_72.cg.alpha = 0
	end, function()
		arg0_72.cg.alpha = 1

		if arg1_72 then
			arg1_72()
		end
	end, "ui", "opening", true, false)

	arg0_72.onPlayingOP = true
end

function var0_0.closeYostarAlertView(arg0_75)
	if arg0_75.yostarAlertView and arg0_75.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_75.yostarAlertView:Destroy()
	end
end

function var0_0.onLoadDataDone(arg0_76)
	arg0_76:unloadExtraVoice()

	if getProxy(PlayerProxy) then
		getProxy(PlayerProxy):setFlag("login", true)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	end
end

function var0_0.onLoginWait(arg0_77, arg1_77)
	arg0_77.subViewList[LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW]:RefreshUI(arg1_77)
end

return var0_0
