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

function var0_0.getResource(arg0_7)
	local var0_7 = {
		"ui/loginui2",
		"ui/opening",
		"ui/useragreementui"
	}
	local var1_7, var2_7 = getLoginConfig()
	local var3_7 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var2_7)

	table.insert(var0_7, var3_7)
	_.each(ResPathSupport.ConstPath.BG.LoadingBGList, function(arg0_8)
		local var0_8 = ResPathSupport.CombinePath(arg0_8, var2_7)

		table.insert(var0_7, var0_8)
	end)

	return table.insertto(var0_7, var0_0.super.getResource(arg0_7))
end

function var0_0.init(arg0_9)
	local var0_9 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES")

	arg0_9:setBg()

	arg0_9.adapt = arg0_9._tf:Find("adapt")
	arg0_9.version = arg0_9.adapt:Find("version")
	arg0_9.version:GetComponent("Text").text = "ver " .. var0_9.CurrentVersion:ToString()
	arg0_9.bgLay = arg0_9.adapt:Find("bg_lay")
	arg0_9.accountBtn = arg0_9.adapt:Find("bg_lay/buttons/account_button")
	arg0_9.repairBtn = arg0_9.adapt:Find("btns/repair_button")
	arg0_9.privateBtn = arg0_9.adapt:Find("btns/private_btn")
	arg0_9.licenceBtn = arg0_9.adapt:Find("btns/Licence_btn")
	arg0_9.chInfo = arg0_9._tf:Find("background/info")

	setActive(arg0_9.chInfo, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_9.urlClick = arg0_9.chInfo:Find("urlClick")

		onButton(arg0_9, arg0_9.urlClick, function()
			Application.OpenURL("https://beian.miit.gov.cn/#/home")
		end)
	end

	arg0_9.pressToLogin = GetOrAddComponent(arg0_9._tf:Find("background/press_to_login"), "CanvasGroup")

	LeanTween.alphaCanvas(arg0_9.pressToLogin, 0.25, var1_0):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0_9.currentServer = arg0_9.adapt:Find("current_server")
	arg0_9.serviceBtn = arg0_9.adapt:Find("bg_lay/buttons/service_button")
	arg0_9.filingBtn = arg0_9.adapt:Find("filingBtn")

	setActive(arg0_9.filingBtn, PLATFORM_CODE == PLATFORM_CH)

	arg0_9.serversPanel = arg0_9.adapt:Find("servers")
	arg0_9.servers = arg0_9.serversPanel:Find("panel/panel/servers/content/server_list")
	arg0_9.serverTpl = arg0_9:getTpl("server_tpl")
	arg0_9.recentTF = arg0_9.serversPanel:Find("panel/panel/servers/content/advice_panel/recent")
	arg0_9.adviceTF = arg0_9.serversPanel:Find("panel/panel/servers/content/advice_panel/advice")
	arg0_9.userAgreenTF = arg0_9.adapt:Find("UserAgreement")
	arg0_9.userAgreenMainTF = arg0_9.adapt:Find("UserAgreement/window")
	arg0_9.closeUserAgreenTF = arg0_9.userAgreenTF:Find("window/close_btn")
	arg0_9.userAgreenConfirmTF = arg0_9.adapt:Find("UserAgreement/window/accept_btn")
	arg0_9.userDisagreeConfirmTF = arg0_9.adapt:Find("UserAgreement/window/disagree_btn")
	arg0_9.switchGatewayBtn = SwitchGatewayBtn.New(arg0_9.adapt:Find("servers/panel/panel/switch_platform"))

	if PLATFORM == PLATFORM_OPENHARMONY then
		arg0_9.switchGatewayBtn4Oh = SwitchGatewayBtn4OpenHarmony.New(arg0_9.adapt:Find("servers/panel/panel/switch_platform"))
	end

	setActive(arg0_9.userAgreenTF, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.userAgreenTF, arg0_9._tf)

	arg0_9.opBtn = arg0_9.adapt:Find("bg_lay/buttons/opBtn")

	if arg0_9.opBtn then
		setActive(arg0_9.opBtn, arg0_9.isOpPlay)
	end

	arg0_9.airiUidTxt = arg0_9.adapt:Find("airi_uid")
	arg0_9.shareData = {}
	arg0_9.searchAccount = arg0_9.serversPanel:Find("panel/panel/searchAccount")

	setText(findTF(arg0_9.searchAccount, "text"), i18n("query_role_button"))

	arg0_9.serverPanelCanvas = GetComponent(arg0_9.adapt:Find("servers/panel/panel/servers"), typeof(CanvasGroup))

	onButton(arg0_9, arg0_9.searchAccount, function()
		if not arg0_9.serversDic or arg0_9.searching then
			return
		end

		arg0_9:searchAountState(true)

		arg0_9.serverPanelCanvas.interactable = false

		arg0_9.event:emit(LoginMediator.ON_SEARCH_ACCOUNT, {
			callback = function()
				arg0_9.serverPanelCanvas.interactable = true

				arg0_9:searchAountState(false)
			end,
			update = function(arg0_13)
				arg0_9:setServerAccountData(arg0_13)
			end
		})
	end, SFX_CONFIRM)

	arg0_9.subViewList = {}
	arg0_9.loginPanelView = LoginPanelView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	arg0_9.loginPanelView:SetShareData(arg0_9.shareData)

	arg0_9.registerPanelView = RegisterPanelView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	arg0_9.loginPanelView:SetShareData(arg0_9.shareData)

	arg0_9.tencentLoginPanelView = TencentLoginPanelView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	arg0_9.loginPanelView:SetShareData(arg0_9.shareData)

	arg0_9.airiLoginPanelView = AiriLoginPanelView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	arg0_9.loginPanelView:SetShareData(arg0_9.shareData)

	arg0_9.transcodeAlertView = TranscodeAlertView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	arg0_9.loginPanelView:SetShareData(arg0_9.shareData)

	arg0_9.yostarAlertView = YostarAlertView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	arg0_9.loginPanelView:SetShareData(arg0_9.shareData)

	arg0_9.subViewList[LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW] = arg0_9.loginPanelView
	arg0_9.subViewList[LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW] = arg0_9.registerPanelView
	arg0_9.subViewList[LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW] = arg0_9.tencentLoginPanelView
	arg0_9.subViewList[LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW] = arg0_9.airiLoginPanelView
	arg0_9.subViewList[LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW] = arg0_9.transcodeAlertView
	arg0_9.subViewList[LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW] = arg0_9.yostarAlertView
	arg0_9.subViewList[LoginSceneConst.DEFINE.PRESS_TO_LOGIN] = arg0_9.pressToLogin
	arg0_9.subViewList[LoginSceneConst.DEFINE.BG_LAY] = arg0_9.bgLay
	arg0_9.subViewList[LoginSceneConst.DEFINE.SERVER_PANEL] = arg0_9.serversPanel
	arg0_9.subViewList[LoginSceneConst.DEFINE.ACCOUNT_BTN] = arg0_9.accountBtn
	arg0_9.subViewList[LoginSceneConst.DEFINE.CURRENT_SERVER] = arg0_9.currentServer
	arg0_9.age = arg0_9.adapt:Find("age")

	if PLATFORM_CODE == PLATFORM_CH then
		onButton(arg0_9, arg0_9.age, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.cadpa_help.tip,
				title = pg.MsgboxMgr.TITLE_CADPA
			})
		end)
		SetActive(arg0_9.age, true)
	end

	SetActive(arg0_9.age, PLATFORM_CODE == PLATFORM_CH)
	setText(findTF(arg0_9.currentServer, "server_name"), "")
	arg0_9:switchToServer()
	arg0_9:initEvents()
end

function var0_0.FlushGateWaySwitchBtn(arg0_15)
	arg0_15.switchGatewayBtn:Flush()

	if PLATFORM == PLATFORM_OPENHARMONY then
		arg0_15.switchGatewayBtn4Oh:Flush()
	end
end

function var0_0.setServerAccountData(arg0_16, arg1_16)
	local var0_16 = arg1_16.id
	local var1_16

	for iter0_16 = 1, #arg0_16.serversDic do
		if arg0_16.serversDic[iter0_16].id == var0_16 then
			var1_16 = arg0_16.serversDic[iter0_16]

			break
		end
	end

	if not var1_16 then
		return
	end

	local var2_16 = var1_16.tf

	if arg1_16 and arg1_16.level then
		setActive(findTF(var2_16, "mark/charactor"), true)
		setActive(findTF(var2_16, "mark/level"), true)
		setActive(findTF(var2_16, "mark/searching"), false)
		setText(findTF(var2_16, "mark/level"), "lv." .. arg1_16.level)
		setText(findTF(var2_16, "mark/level"), setColorStr("lv." .. arg1_16.level, "#ffffffff"))

		var1_16.level = arg1_16.level
	elseif arg1_16 and arg1_16.isFail then
		setActive(findTF(var2_16, "mark/level"), true)
		setActive(findTF(var2_16, "mark/searching"), false)
		setActive(findTF(var2_16, "mark/charactor"), false)

		var1_16.level = 0

		setText(findTF(var2_16, "mark/level"), setColorStr(i18n("query_role_fail"), "#ff9c00ff"))
	else
		setActive(findTF(var2_16, "mark/level"), true)
		setActive(findTF(var2_16, "mark/searching"), false)
		setActive(findTF(var2_16, "mark/charactor"), false)

		var1_16.level = 0

		setText(findTF(var2_16, "mark/level"), setColorStr(i18n("query_role_none"), "#d0d0d0FF"))
	end
end

function var0_0.searchAountState(arg0_17, arg1_17)
	arg0_17.searching = arg1_17

	for iter0_17 = 1, #arg0_17.serversDic do
		local var0_17 = arg0_17.serversDic[iter0_17].tf
		local var1_17 = arg0_17.serversDic[iter0_17].level

		setActive(findTF(var0_17, "mark"), true)

		if arg1_17 then
			setActive(findTF(var0_17, "mark/charactor"), false)
			setActive(findTF(var0_17, "mark/level"), true)
			setText(findTF(var0_17, "mark/level"), setColorStr(i18n("query_role"), "#d0d0d0FF"))
			setActive(findTF(var0_17, "mark/searching"), true)
		else
			if not var1_17 then
				setText(findTF(var0_17, "mark/level"), setColorStr(i18n("query_role_fail"), "#d0d0d0FF"))
			end

			setActive(findTF(var0_17, "mark/searching"), false)
		end
	end
end

function var0_0.initEvents(arg0_18)
	arg0_18:bind(LoginSceneConst.SWITCH_SUB_VIEW, function(arg0_19, arg1_19)
		arg0_18:switchSubView(arg1_19)
	end)
	arg0_18:bind(LoginSceneConst.CLEAR_REGISTER_VIEW, function(arg0_20)
		arg0_18.registerPanelView:ActionInvoke("Clear")
	end)
end

function var0_0.switchSubView(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.subViewList) do
		if isa(iter1_21, BaseSubView) then
			if table.contains(arg1_21, iter0_21) then
				iter1_21:CallbackInvoke(function()
					arg0_21.repairBtn:SetAsLastSibling()
				end)
				iter1_21:Load()
				iter1_21:ActionInvoke("Show")
			else
				iter1_21:ActionInvoke("Hide")
			end
		else
			setActive(iter1_21, table.contains(arg1_21, iter0_21))
		end
	end

	if not table.contains(arg1_21, LoginSceneConst.DEFINE.SERVER_PANEL) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.serversPanel, arg0_21._tf)
	end

	if table.contains(arg1_21, LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW) then
		setActive(arg0_21.airiUidTxt, false)
	end

	arg0_21.userAgreenTF:SetAsLastSibling()
	arg0_21.repairBtn:SetAsLastSibling()
end

function var0_0.onBackPressed(arg0_23)
	if arg0_23.searching then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_23.serversPanel) then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23.serversPanel, arg0_23._tf)
		setActive(arg0_23.serversPanel, false)

		return
	end

	if isActive(arg0_23.userAgreenTF) then
		setActive(arg0_23.userAgreenTF, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23.userAgreenTF, arg0_23._tf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0_0.setUserData(arg0_24, arg1_24)
	setActive(arg0_24.airiUidTxt, true)
	setText(arg0_24.airiUidTxt, "uid: " .. arg1_24.arg2)
end

function var0_0.showUserAgreement(arg0_25, arg1_25)
	local var0_25

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_25.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.501960784313725)
	else
		var0_25 = true
	end

	local var1_25 = require("ShareCfg.UserAgreement")

	setActive(arg0_25.userAgreenTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_25.userAgreenTF)
	setText(arg0_25.userAgreenTF:Find("window/container/scrollrect/content/Text"), var1_25.content)
	onButton(arg0_25, arg0_25.userAgreenConfirmTF, function()
		if var0_25 then
			setActive(arg0_25.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25.userAgreenTF, arg0_25._tf)

			if arg1_25 then
				arg1_25()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(arg0_25, arg0_25.userAgreenTF:Find("window/container/scrollrect"), function(arg0_27)
		if arg0_27.y <= 0.01 and not var0_25 then
			var0_25 = true

			if PLATFORM_CODE == PLATFORM_CH then
				arg0_25.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)
			end
		end
	end)
end

function var0_0.setBg(arg0_28)
	arg0_28.bgImg = arg0_28._tf:Find("background/bg"):GetComponent(typeof(Image))

	if not arg0_28.isCriBg then
		setImageSprite(arg0_28.bgImg, arg0_28.staticBgSprite)
	else
		arg0_28.bgImg.enabled = false

		local var0_28 = arg0_28.criBgGo.transform

		var0_28:SetParent(arg0_28.bgImg.transform, false)
		var0_28:SetAsFirstSibling()

		local var1_28 = arg0_28.criBgGo:GetComponent("AspectRatioFitter")

		if var1_28 then
			var1_28.enabled = true
		end
	end
end

function var0_0.setLastLogin(arg0_29, arg1_29)
	arg0_29.shareData.lastLoginUser = arg1_29
end

function var0_0.setAutoLogin(arg0_30)
	arg0_30.shareData.autoLoginEnabled = true
end

function var0_0.setLastLoginServer(arg0_31, arg1_31)
	if not arg1_31 then
		setText(findTF(arg0_31.currentServer, "server_name"), "")

		arg0_31.shareData.lastLoginServer = nil

		arg0_31:updateAdviceServer()

		return
	end

	setText(findTF(arg0_31.currentServer, "server_name"), arg1_31.name)

	arg0_31.shareData.lastLoginServer = arg1_31
end

function var0_0.didEnter(arg0_32)
	onButton(arg0_32, arg0_32.closeUserAgreenTF, function()
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			setActive(arg0_32.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32.userAgreenTF, arg0_32._tf)
		else
			setActive(arg0_32.userAgreenMainTF, false)
			onNextTick(function()
				setActive(arg0_32.userAgreenMainTF, true)
			end)
		end
	end, SFX_CANCEL)
	onButton(arg0_32, arg0_32.privateBtn, function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.licenceBtn, function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
	setActive(arg0_32.privateBtn, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0_32.licenceBtn, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		onButton(arg0_32, arg0_32.userDisagreeConfirmTF, function()
			setActive(arg0_32.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32.userAgreenTF, arg0_32._tf)
		end)
	end

	setActive(arg0_32.serviceBtn, PLATFORM_CODE == PLATFORM_KR)
	onButton(arg0_32, arg0_32.serviceBtn, function()
		if PLATFORM_CODE == PLATFORM_KR then
			pg.SdkMgr.GetInstance():UserCenter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
		end
	end, SFX_MAIN)
	onButton(arg0_32, arg0_32.accountBtn, function()
		local var0_39 = pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER

		if not var0_39 then
			arg0_32:switchToLogin()
		elseif var0_39 and PLATFORM_KR == PLATFORM_CODE then
			pg.SdkMgr.GetInstance():SwitchAccount()
		end
	end, SFX_MAIN)
	onButton(arg0_32, arg0_32.repairBtn, function()
		pg.RepairResMgr.GetInstance():Repair()
	end)

	local function var0_32()
		local var0_41 = pg.SdkMgr.GetInstance():GetLoginType()

		if var0_41 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var0_41 == LoginType.PLATFORM_TENCENT then
			arg0_32:switchToTencentLogin()
		elseif var0_41 == LoginType.PLATFORM_INNER then
			arg0_32:switchToLogin()
		end
	end

	onButton(arg0_32, arg0_32.filingBtn, function()
		Application.OpenURL("http://sq.ccm.gov.cn:80/ccnt/sczr/service/business/emark/gameNetTag/4028c08b58bd467b0158bd8bd80d062a")
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.currentServer, function()
		if table.getCount(arg0_32.serverList or {}) == 0 then
			var0_32()
		else
			pg.UIMgr.GetInstance():BlurPanel(arg0_32.serversPanel)
			setActive(arg0_32.serversPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.serversPanel, function()
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32.serversPanel, arg0_32._tf)
		setActive(arg0_32.serversPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_32, arg0_32._tf:Find("background"), function()
		if pg.CpkPlayMgr.GetInstance():OnPlaying() then
			return
		end

		if not arg0_32.initFinished then
			return
		end

		if arg0_32.isNeedResCheck then
			arg0_32.event:emit(LoginMediator.CHECK_RES)

			return
		end

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0_32.event:emit(LoginMediator.ON_LOGIN_PROCESS)

			return
		end

		if go(arg0_32.pressToLogin).activeSelf then
			if table.getCount(arg0_32.serverList or {}) == 0 then
				var0_32()

				return
			end

			if not arg0_32.shareData.lastLoginServer then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_choiseServer"))

				return
			end

			if arg0_32.shareData.lastLoginServer.status == Server.STATUS.VINDICATE or arg0_32.shareData.lastLoginServer.status == Server.STATUS.FULL then
				ServerStateChecker.New():Execute(function(arg0_46)
					if arg0_46 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_disabled"))
					else
						arg0_32.event:emit(LoginMediator.ON_SERVER, arg0_32.shareData.lastLoginServer)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
					end
				end)

				return
			end

			arg0_32.event:emit(LoginMediator.ON_SERVER, arg0_32.shareData.lastLoginServer)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		end
	end)

	if arg0_32.isOpPlay then
		onButton(arg0_32, arg0_32.opBtn, function()
			if arg0_32.initFinished and not pg.CpkPlayMgr.GetInstance():OnPlaying() then
				arg0_32:playOpening()
			end
		end)

		if PLATFORM_CODE ~= PLATFORM_JP and PlayerPrefs.GetString("op_ver", "") ~= arg0_32.opVersion then
			arg0_32:playOpening(function()
				PlayerPrefs.SetString("op_ver", arg0_32.opVersion)
				arg0_32:playExtraVoice()

				arg0_32.initFinished = true

				arg0_32.event:emit(LoginMediator.ON_LOGIN_PROCESS)
			end)

			return
		end

		arg0_32.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	else
		arg0_32.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	end

	arg0_32:playExtraVoice()

	arg0_32.initFinished = true

	arg0_32:InitPrivateAndLicence()
end

function var0_0.InitPrivateAndLicence(arg0_49)
	local var0_49 = PLATFORM_CODE == PLATFORM_CH or IsUnityEditor

	setActive(arg0_49.privateBtn, var0_49)
	setActive(arg0_49.licenceBtn, var0_49)

	if var0_49 then
		onButton(arg0_49, arg0_49.privateBtn, function()
			pg.SdkMgr.GetInstance():ShowPrivate()
		end, SFX_PANEL)
		onButton(arg0_49, arg0_49.licenceBtn, function()
			pg.SdkMgr.GetInstance():ShowLicence()
		end, SFX_PANEL)
	end
end

local function var2_0()
	local var0_52 = pg.gameset.login_extra_voice.description

	if var0_52 and #var0_52 > 0 then
		local var1_52 = var0_52[math.clamp(math.floor(math.random() * #var0_52) + 1, 1, #var0_52)]

		return "cv-" .. var1_52, "extra"
	end

	return nil, nil
end

local function var3_0(arg0_53)
	local var0_53 = arg0_53.description[1]
	local var1_53 = arg0_53.description[2]
	local var2_53 = arg0_53.description[3]

	if pg.TimeMgr.GetInstance():inTime(var1_53) then
		local var3_53 = math.random(1, var2_53)

		return var0_53, "extra" .. var3_53
	end

	return nil, nil
end

function var0_0.GetExtraVoiceSheetAndCue(arg0_54)
	local var0_54
	local var1_54
	local var2_54 = pg.gameset.new_login_extra_voice

	if var2_54 then
		var0_54, var1_54 = var3_0(var2_54)
	end

	if not var0_54 or not var1_54 then
		var0_54, var1_54 = var2_0()
	end

	return var0_54, var1_54
end

function var0_0.playExtraVoice(arg0_55)
	local var0_55, var1_55 = arg0_55:GetExtraVoiceSheetAndCue()

	if var0_55 and var1_55 then
		arg0_55.loginCueSheet = var0_55

		pg.CriMgr.GetInstance():PlayCV_V3(var0_55, var1_55)
	end
end

function var0_0.unloadExtraVoice(arg0_56)
	if arg0_56.loginCueSheet then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_56.loginCueSheet)

		arg0_56.loginCueSheet = nil
	end
end

function var0_0.autoLogin(arg0_57)
	if arg0_57.shareData.lastLoginUser then
		if arg0_57.shareData.autoLoginEnabled then
			arg0_57.event:emit(LoginMediator.ON_LOGIN, arg0_57.shareData.lastLoginUser)
		end

		if arg0_57.loginPanelView:GetLoaded() then
			if arg0_57.shareData.lastLoginUser.type == 1 then
				arg0_57.loginPanelView:ActionInvoke("SetContent", arg0_57.shareData.lastLoginUser.arg2, arg0_57.shareData.lastLoginUser.arg3)
			elseif arg0_57.shareData.lastLoginUser.type == 2 then
				arg0_57.loginPanelView:ActionInvoke("SetContent", arg0_57.shareData.lastLoginUser.arg1, arg0_57.shareData.lastLoginUser.arg2)
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

function var0_0.updateServerTF(arg0_58, arg1_58, arg2_58)
	setText(findTF(arg1_58, "name"), "-  " .. arg2_58.name .. "  -")
	arg0_58:setSpriteTo(arg0_58.iconSpries[arg2_58.status + 1], findTF(arg1_58, "statu"), true)

	findTF(arg1_58, "statu_1"):GetComponent("Image").color = Color.New(var4_0[arg2_58.status + 1][1], var4_0[arg2_58.status + 1][2], var4_0[arg2_58.status + 1][3], var4_0[arg2_58.status + 1][4])

	setActive(findTF(arg1_58, "mark"), arg2_58.isLogined)
	setActive(arg1_58:Find("tag_new"), arg2_58.isNew)
	setActive(arg1_58:Find("tag_hot"), arg2_58.isHot)
	onButton(arg0_58, arg1_58, function()
		if arg2_58.status == Server.STATUS.VINDICATE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_vindicate"))

			return
		end

		if arg2_58.status == Server.STATUS.FULL then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_full"))

			return
		end

		arg0_58:setLastLoginServer(arg2_58)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_58.serversPanel, arg0_58._tf)
		setActive(arg0_58.serversPanel, false)
	end, SFX_CONFIRM)
end

function var0_0.updateAdviceServer(arg0_60)
	if not arg0_60.recentTF or not arg0_60.adviceTF then
		return
	end

	setActive(arg0_60.recentTF, arg0_60.shareData.lastLoginServer)

	if arg0_60.shareData.lastLoginServer then
		local var0_60 = findTF(arg0_60.recentTF, "server")

		arg0_60:updateServerTF(var0_60, arg0_60.shareData.lastLoginServer)
	end

	local var1_60 = getProxy(ServerProxy).firstServer

	setActive(arg0_60.adviceTF, var1_60)

	if var1_60 then
		local var2_60 = findTF(arg0_60.adviceTF, "server")

		arg0_60:updateServerTF(var2_60, var1_60)
	end
end

function var0_0.updateServerList(arg0_61, arg1_61)
	arg0_61.serverList = arg1_61

	local var0_61 = _.sort(_.values(arg1_61), function(arg0_62, arg1_62)
		return arg0_62.sortIndex < arg1_62.sortIndex
	end)

	removeAllChildren(arg0_61.servers)

	if IsUnityEditor then
		table.sort(var0_61, function(arg0_63, arg1_63)
			local var0_63 = string.lower(arg0_63.name)
			local var1_63 = string.lower(arg1_63.name)

			return string.byte(var0_63, 1) > string.byte(var1_63, 1)
		end)
	end

	arg0_61.serversDic = {}

	for iter0_61, iter1_61 in pairs(var0_61) do
		local var1_61 = cloneTplTo(arg0_61.serverTpl, arg0_61.servers)

		arg0_61:updateServerTF(var1_61, iter1_61)
		table.insert(arg0_61.serversDic, {
			server = iter1_61,
			tf = var1_61,
			id = iter1_61.id
		})
	end
end

function var0_0.fillterRefundServer(arg0_64)
	local var0_64 = getProxy(UserProxy)
	local var1_64 = {}

	if var0_64.data.limitServerIds and #var0_64.data.limitServerIds > 0 and arg0_64.serverList and #arg0_64.serverList > 0 then
		local var2_64 = var0_64.data.limitServerIds
		local var3_64

		for iter0_64, iter1_64 in pairs(arg0_64.serverList) do
			local var4_64 = iter1_64.id
			local var5_64 = false

			for iter2_64, iter3_64 in pairs(var2_64) do
				if var2_64[iter2_64] == var4_64 and not var5_64 then
					if not var3_64 then
						var3_64 = "\n" .. iter1_64.name
					else
						var3_64 = var3_64 .. "," .. iter1_64.name
					end

					table.insert(var1_64, iter1_64)

					var5_64 = true
				end
			end
		end

		arg0_64:updateServerList(var1_64)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("login_arrears_tips", var3_64),
			onYes = function()
				return
			end
		})
	end
end

function var0_0.switchToTencentLogin(arg0_66)
	arg0_66:switchSubView({
		LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW
	})
end

function var0_0.switchToAiriLogin(arg0_67)
	arg0_67:switchSubView({
		LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
		LoginSceneConst.DEFINE.PRESS_TO_LOGIN
	})
end

function var0_0.switchToLogin(arg0_68)
	arg0_68:switchSubView({
		LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
	})
end

function var0_0.switchToRegister(arg0_69)
	arg0_69:switchSubView({
		LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
	})
end

function var0_0.switchToServer(arg0_70)
	arg0_70:updateAdviceServer()

	if pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER and PLATFORM_CODE ~= PLATFORM_KR then
		arg0_70:switchSubView({
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	else
		arg0_70:switchSubView({
			LoginSceneConst.DEFINE.ACCOUNT_BTN,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	end
end

function var0_0.SwitchToWaitPanel(arg0_71, arg1_71)
	local var0_71 = arg0_71.adapt:Find("Msgbox")
	local var1_71 = var0_71:Find("window/content")

	arg0_71.waitTimer = nil

	local var2_71 = 0
	local var3_71 = arg1_71

	arg0_71.waitTimer = Timer.New(function()
		setText(var1_71, i18n("login_wait_tip", var3_71))

		arg1_71 = arg1_71 - 1

		if math.random(0, 1) == 1 then
			var3_71 = arg1_71
		end

		if arg1_71 <= 0 then
			triggerButton(arg0_71._tf:Find("background"))
			arg0_71.waitTimer:Stop()

			arg0_71.waitTimer = nil
		end
	end, 1, -1)

	arg0_71.waitTimer:Start()
	arg0_71.waitTimer.func()
	setActive(var0_71, true)
end

function var0_0.willExit(arg0_73)
	if arg0_73.waitTimer then
		arg0_73.waitTimer:Stop()

		arg0_73.waitTimer = nil
	end

	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_73.loginPanelView:Destroy()
	arg0_73.registerPanelView:Destroy()
	arg0_73.tencentLoginPanelView:Destroy()
	arg0_73.airiLoginPanelView:Destroy()
	arg0_73.transcodeAlertView:Destroy()
	arg0_73.yostarAlertView:Destroy()
	arg0_73.switchGatewayBtn:Dispose()

	if PLATFORM == PLATFORM_OPENHARMONY then
		arg0_73.switchGatewayBtn4Oh:Dispose()
	end

	arg0_73.iconSpries = nil
end

function var0_0.playOpening(arg0_74, arg1_74)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		if not arg0_74.cg then
			arg0_74.cg = GetOrAddComponent(arg0_74._tf, "CanvasGroup")
		end

		arg0_74.cg.alpha = 0
	end, function()
		arg0_74.cg.alpha = 1

		if arg1_74 then
			arg1_74()
		end
	end, "ui", "opening", true, false)

	arg0_74.onPlayingOP = true
end

function var0_0.closeYostarAlertView(arg0_77)
	if arg0_77.yostarAlertView and arg0_77.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_77.yostarAlertView:Destroy()
	end
end

function var0_0.onLoadDataDone(arg0_78)
	arg0_78:unloadExtraVoice()

	if getProxy(PlayerProxy) then
		getProxy(PlayerProxy):setFlag("login", true)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	end
end

function var0_0.onLoginWait(arg0_79, arg1_79)
	arg0_79.subViewList[LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW]:RefreshUI(arg1_79)
end

return var0_0
