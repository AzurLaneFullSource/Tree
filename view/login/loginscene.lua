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
	arg0_3.iconSpries = {}

	seriesAsync({
		function(arg0_4)
			AssetBundleHelper.loadAssetBundleAsync("ui/LoginUI2_atlas", function(arg0_5)
				table.insert(arg0_3.iconSpries, arg0_5:LoadAssetSync("statu_green", typeof(Sprite), true, false))
				table.insert(arg0_3.iconSpries, arg0_5:LoadAssetSync("statu_gray", typeof(Sprite), true, false))
				table.insert(arg0_3.iconSpries, arg0_5:LoadAssetSync("statu_red", typeof(Sprite), true, false))
				table.insert(arg0_3.iconSpries, arg0_5:LoadAssetSync("statu_org", typeof(Sprite), true, false))
				arg0_4()
			end)
		end,
		function(arg0_6)
			arg0_3.isCriBg, arg0_3.bgPath, arg0_3.bgmName, arg0_3.isOpPlay, arg0_3.opVersion = getLoginConfig()

			if arg0_3.isCriBg then
				LoadAndInstantiateAsync("effect", arg0_3.bgPath, function(arg0_7)
					arg0_3.criBgGo = arg0_7

					arg0_6()
				end)
			else
				LoadSpriteAsync("loadingbg/" .. arg0_3.bgPath, function(arg0_8)
					arg0_3.staticBgSprite = arg0_8

					arg0_6()
				end)
			end
		end
	}, arg1_3)
end

function var0_0.init(arg0_9)
	local var0_9 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES")

	arg0_9:setBg()

	arg0_9.version = arg0_9:findTF("version")
	arg0_9.version:GetComponent("Text").text = "ver " .. var0_9.CurrentVersion:ToString()
	arg0_9.bgLay = arg0_9:findTF("bg_lay")
	arg0_9.accountBtn = arg0_9:findTF("bg_lay/buttons/account_button")
	arg0_9.repairBtn = arg0_9:findTF("btns/repair_button")
	arg0_9.privateBtn = arg0_9:findTF("btns/private_btn")
	arg0_9.licenceBtn = arg0_9:findTF("btns/Licence_btn")
	arg0_9.chInfo = arg0_9:findTF("background/info")

	setActive(arg0_9.chInfo, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_9.urlClick = arg0_9:findTF("urlClick", arg0_9.chInfo)

		onButton(arg0_9, arg0_9.urlClick, function()
			Application.OpenURL("https://beian.miit.gov.cn/#/home")
		end)
	end

	arg0_9.pressToLogin = GetOrAddComponent(arg0_9:findTF("background/press_to_login"), "CanvasGroup")

	LeanTween.alphaCanvas(arg0_9.pressToLogin, 0.25, var1_0):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0_9.currentServer = arg0_9:findTF("current_server")
	arg0_9.serviceBtn = arg0_9:findTF("bg_lay/buttons/service_button")
	arg0_9.filingBtn = arg0_9:findTF("filingBtn")

	setActive(arg0_9.filingBtn, PLATFORM_CODE == PLATFORM_CH)

	arg0_9.serversPanel = arg0_9:findTF("servers")
	arg0_9.servers = arg0_9:findTF("panel/servers/content/server_list", arg0_9.serversPanel)
	arg0_9.serverTpl = arg0_9:getTpl("server_tpl")
	arg0_9.recentTF = arg0_9:findTF("panel/servers/content/advice_panel/recent", arg0_9.serversPanel)
	arg0_9.adviceTF = arg0_9:findTF("panel/servers/content/advice_panel/advice", arg0_9.serversPanel)
	arg0_9.userAgreenTF = arg0_9:findTF("UserAgreement")
	arg0_9.userAgreenMainTF = arg0_9:findTF("UserAgreement/window")
	arg0_9.closeUserAgreenTF = arg0_9.userAgreenTF:Find("window/close_btn")
	arg0_9.userAgreenConfirmTF = arg0_9:findTF("UserAgreement/window/accept_btn")
	arg0_9.userDisagreeConfirmTF = arg0_9:findTF("UserAgreement/window/disagree_btn")
	arg0_9.switchGatewayBtn = SwitchGatewayBtn.New(arg0_9:findTF("servers/panel/switch_platform"))

	setActive(arg0_9.userAgreenTF, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9.userAgreenTF, arg0_9._tf)

	arg0_9.opBtn = arg0_9:findTF("bg_lay/buttons/opBtn")

	if arg0_9.opBtn then
		setActive(arg0_9.opBtn, arg0_9.isOpPlay)
	end

	arg0_9.airiUidTxt = arg0_9:findTF("airi_uid")
	arg0_9.shareData = {}
	arg0_9.searchAccount = arg0_9:findTF("panel/searchAccount", arg0_9.serversPanel)

	setText(findTF(arg0_9.searchAccount, "text"), i18n("query_role_button"))

	arg0_9.serverPanelCanvas = GetComponent(arg0_9:findTF("servers/panel/servers"), typeof(CanvasGroup))

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
	arg0_9.age = arg0_9:findTF("background/age")

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

function var0_0.setServerAccountData(arg0_15, arg1_15)
	local var0_15 = arg1_15.id
	local var1_15

	for iter0_15 = 1, #arg0_15.serversDic do
		if arg0_15.serversDic[iter0_15].id == var0_15 then
			var1_15 = arg0_15.serversDic[iter0_15]

			break
		end
	end

	if not var1_15 then
		return
	end

	local var2_15 = var1_15.tf

	if arg1_15 and arg1_15.level then
		setActive(findTF(var2_15, "mark/charactor"), true)
		setActive(findTF(var2_15, "mark/level"), true)
		setActive(findTF(var2_15, "mark/searching"), false)
		setText(findTF(var2_15, "mark/level"), "lv." .. arg1_15.level)
		setText(findTF(var2_15, "mark/level"), setColorStr("lv." .. arg1_15.level, "#ffffffff"))

		var1_15.level = arg1_15.level
	else
		setActive(findTF(var2_15, "mark/level"), true)
		setActive(findTF(var2_15, "mark/searching"), false)
		setActive(findTF(var2_15, "mark/charactor"), false)

		var1_15.level = 0

		setText(findTF(var2_15, "mark/level"), setColorStr(i18n("query_role_none"), "#d0d0d0FF"))
	end
end

function var0_0.searchAountState(arg0_16, arg1_16)
	arg0_16.searching = arg1_16

	for iter0_16 = 1, #arg0_16.serversDic do
		local var0_16 = arg0_16.serversDic[iter0_16].tf
		local var1_16 = arg0_16.serversDic[iter0_16].level

		setActive(findTF(var0_16, "mark"), true)

		if arg1_16 then
			setActive(findTF(var0_16, "mark/charactor"), false)
			setActive(findTF(var0_16, "mark/level"), true)
			setText(findTF(var0_16, "mark/level"), setColorStr(i18n("query_role"), "#d0d0d0FF"))
			setActive(findTF(var0_16, "mark/searching"), true)
		else
			if not var1_16 then
				setText(findTF(var0_16, "mark/level"), setColorStr(i18n("query_role_fail"), "#d0d0d0FF"))
			end

			setActive(findTF(var0_16, "mark/searching"), false)
		end
	end
end

function var0_0.initEvents(arg0_17)
	arg0_17:bind(LoginSceneConst.SWITCH_SUB_VIEW, function(arg0_18, arg1_18)
		arg0_17:switchSubView(arg1_18)
	end)
	arg0_17:bind(LoginSceneConst.CLEAR_REGISTER_VIEW, function(arg0_19)
		arg0_17.registerPanelView:ActionInvoke("Clear")
	end)
end

function var0_0.switchSubView(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.subViewList) do
		if isa(iter1_20, BaseSubView) then
			if table.contains(arg1_20, iter0_20) then
				iter1_20:CallbackInvoke(function()
					arg0_20.repairBtn:SetAsLastSibling()
				end)
				iter1_20:Load()
				iter1_20:ActionInvoke("Show")
			else
				iter1_20:ActionInvoke("Hide")
			end
		else
			setActive(iter1_20, table.contains(arg1_20, iter0_20))
		end
	end

	if not table.contains(arg1_20, LoginSceneConst.DEFINE.SERVER_PANEL) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_20.serversPanel, arg0_20._tf)
	end

	if table.contains(arg1_20, LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW) then
		setActive(arg0_20.airiUidTxt, false)
	end

	arg0_20.userAgreenTF:SetAsLastSibling()
	arg0_20.repairBtn:SetAsLastSibling()
end

function var0_0.onBackPressed(arg0_22)
	if arg0_22.searching then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_22.serversPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_22.serversPanel, arg0_22._tf)
		setActive(arg0_22.serversPanel, false)

		return
	end

	if isActive(arg0_22.userAgreenTF) then
		setActive(arg0_22.userAgreenTF, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_22.userAgreenTF, arg0_22._tf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0_0.setUserData(arg0_23, arg1_23)
	setActive(arg0_23.airiUidTxt, true)
	setText(arg0_23.airiUidTxt, "uid: " .. arg1_23.arg2)
end

function var0_0.showUserAgreement(arg0_24, arg1_24)
	local var0_24

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_24.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.501960784313725)
	else
		var0_24 = true
	end

	local var1_24 = require("ShareCfg.UserAgreement")

	setActive(arg0_24.userAgreenTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_24.userAgreenTF, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	setText(arg0_24.userAgreenTF:Find("window/container/scrollrect/content/Text"), var1_24.content)
	onButton(arg0_24, arg0_24.userAgreenConfirmTF, function()
		if var0_24 then
			setActive(arg0_24.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_24.userAgreenTF, arg0_24._tf)

			if arg1_24 then
				arg1_24()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(arg0_24, arg0_24.userAgreenTF:Find("window/container/scrollrect"), function(arg0_26)
		if arg0_26.y <= 0.01 and not var0_24 then
			var0_24 = true

			if PLATFORM_CODE == PLATFORM_CH then
				arg0_24.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)
			end
		end
	end)
end

function var0_0.setBg(arg0_27)
	arg0_27.bgImg = arg0_27:findTF("background/bg"):GetComponent(typeof(Image))

	if not arg0_27.isCriBg then
		setImageSprite(arg0_27.bgImg, arg0_27.staticBgSprite)
	else
		arg0_27.bgImg.enabled = false

		local var0_27 = arg0_27.criBgGo.transform

		var0_27:SetParent(arg0_27.bgImg.transform, false)
		var0_27:SetAsFirstSibling()

		local var1_27 = arg0_27.criBgGo:GetComponent("AspectRatioFitter")

		if var1_27 then
			var1_27.enabled = true
		end
	end
end

function var0_0.setLastLogin(arg0_28, arg1_28)
	arg0_28.shareData.lastLoginUser = arg1_28
end

function var0_0.setAutoLogin(arg0_29)
	arg0_29.shareData.autoLoginEnabled = true
end

function var0_0.setLastLoginServer(arg0_30, arg1_30)
	if not arg1_30 then
		setText(findTF(arg0_30.currentServer, "server_name"), "")

		arg0_30.shareData.lastLoginServer = nil

		arg0_30:updateAdviceServer()

		return
	end

	setText(findTF(arg0_30.currentServer, "server_name"), arg1_30.name)

	arg0_30.shareData.lastLoginServer = arg1_30
end

function var0_0.didEnter(arg0_31)
	onButton(arg0_31, arg0_31.closeUserAgreenTF, function()
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			setActive(arg0_31.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_31.userAgreenTF, arg0_31._tf)
		else
			setActive(arg0_31.userAgreenMainTF, false)
			onNextTick(function()
				setActive(arg0_31.userAgreenMainTF, true)
			end)
		end
	end, SFX_CANCEL)
	onButton(arg0_31, arg0_31.privateBtn, function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.licenceBtn, function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
	setActive(arg0_31.privateBtn, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0_31.licenceBtn, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		onButton(arg0_31, arg0_31.userDisagreeConfirmTF, function()
			setActive(arg0_31.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_31.userAgreenTF, arg0_31._tf)
		end)
	end

	setActive(arg0_31.serviceBtn, PLATFORM_CODE == PLATFORM_KR)
	onButton(arg0_31, arg0_31.serviceBtn, function()
		if PLATFORM_CODE == PLATFORM_KR then
			pg.SdkMgr.GetInstance():UserCenter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
		end
	end, SFX_MAIN)
	onButton(arg0_31, arg0_31.accountBtn, function()
		local var0_38 = pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER

		if not var0_38 then
			arg0_31:switchToLogin()
		elseif var0_38 and PLATFORM_KR == PLATFORM_CODE then
			pg.SdkMgr.GetInstance():SwitchAccount()
		end
	end, SFX_MAIN)
	onButton(arg0_31, arg0_31.repairBtn, function()
		pg.RepairResMgr.GetInstance():Repair()
	end)

	local function var0_31()
		local var0_40 = pg.SdkMgr.GetInstance():GetLoginType()

		if var0_40 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var0_40 == LoginType.PLATFORM_TENCENT then
			arg0_31:switchToTencentLogin()
		elseif var0_40 == LoginType.PLATFORM_INNER then
			arg0_31:switchToLogin()
		end
	end

	onButton(arg0_31, arg0_31.filingBtn, function()
		Application.OpenURL("http://sq.ccm.gov.cn:80/ccnt/sczr/service/business/emark/gameNetTag/4028c08b58bd467b0158bd8bd80d062a")
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.currentServer, function()
		if table.getCount(arg0_31.serverList or {}) == 0 then
			var0_31()
		else
			pg.UIMgr.GetInstance():BlurPanel(arg0_31.serversPanel)
			setActive(arg0_31.serversPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.serversPanel, function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0_31.serversPanel, arg0_31._tf)
		setActive(arg0_31.serversPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_31, arg0_31:findTF("background"), function()
		if pg.CpkPlayMgr.GetInstance():OnPlaying() then
			return
		end

		if not arg0_31.initFinished then
			return
		end

		if arg0_31.isNeedResCheck then
			arg0_31.event:emit(LoginMediator.CHECK_RES)

			return
		end

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0_31.event:emit(LoginMediator.ON_LOGIN_PROCESS)

			return
		end

		if go(arg0_31.pressToLogin).activeSelf then
			if table.getCount(arg0_31.serverList or {}) == 0 then
				var0_31()

				return
			end

			if not arg0_31.shareData.lastLoginServer then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_choiseServer"))

				return
			end

			if arg0_31.shareData.lastLoginServer.status == Server.STATUS.VINDICATE or arg0_31.shareData.lastLoginServer.status == Server.STATUS.FULL then
				ServerStateChecker.New():Execute(function(arg0_45)
					if arg0_45 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_disabled"))
					else
						arg0_31.event:emit(LoginMediator.ON_SERVER, arg0_31.shareData.lastLoginServer)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
					end
				end)

				return
			end

			arg0_31.event:emit(LoginMediator.ON_SERVER, arg0_31.shareData.lastLoginServer)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		end
	end)

	if arg0_31.isOpPlay then
		onButton(arg0_31, arg0_31.opBtn, function()
			if arg0_31.initFinished and not pg.CpkPlayMgr.GetInstance():OnPlaying() then
				arg0_31:playOpening()
			end
		end)

		if PLATFORM_CODE ~= PLATFORM_JP and PlayerPrefs.GetString("op_ver", "") ~= arg0_31.opVersion then
			arg0_31:playOpening(function()
				PlayerPrefs.SetString("op_ver", arg0_31.opVersion)
				arg0_31:playExtraVoice()

				arg0_31.initFinished = true

				arg0_31.event:emit(LoginMediator.ON_LOGIN_PROCESS)
			end)

			return
		end

		arg0_31.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	else
		arg0_31.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	end

	arg0_31:playExtraVoice()

	arg0_31.initFinished = true

	arg0_31:InitPrivateAndLicence()
end

function var0_0.InitPrivateAndLicence(arg0_48)
	local var0_48 = PLATFORM_CODE == PLATFORM_CH or IsUnityEditor

	setActive(arg0_48.privateBtn, var0_48)
	setActive(arg0_48.licenceBtn, var0_48)

	if var0_48 then
		onButton(arg0_48, arg0_48.privateBtn, function()
			pg.SdkMgr.GetInstance():ShowPrivate()
		end, SFX_PANEL)
		onButton(arg0_48, arg0_48.licenceBtn, function()
			pg.SdkMgr.GetInstance():ShowLicence()
		end, SFX_PANEL)
	end
end

local function var2_0()
	local var0_51 = pg.gameset.login_extra_voice.description

	if var0_51 and #var0_51 > 0 then
		local var1_51 = var0_51[math.clamp(math.floor(math.random() * #var0_51) + 1, 1, #var0_51)]

		return "cv-" .. var1_51, "extra"
	end

	return nil, nil
end

local function var3_0(arg0_52)
	local var0_52 = arg0_52.description[1]
	local var1_52 = arg0_52.description[2]
	local var2_52 = arg0_52.description[3]

	if pg.TimeMgr.GetInstance():inTime(var1_52) then
		local var3_52 = math.random(1, var2_52)

		return var0_52, "extra" .. var3_52
	end

	return nil, nil
end

function var0_0.GetExtraVoiceSheetAndCue(arg0_53)
	local var0_53
	local var1_53
	local var2_53 = pg.gameset.new_login_extra_voice

	if var2_53 then
		var0_53, var1_53 = var3_0(var2_53)
	end

	if not var0_53 or not var1_53 then
		var0_53, var1_53 = var2_0()
	end

	return var0_53, var1_53
end

function var0_0.playExtraVoice(arg0_54)
	local var0_54, var1_54 = arg0_54:GetExtraVoiceSheetAndCue()

	if var0_54 and var1_54 then
		arg0_54.loginCueSheet = var0_54

		pg.CriMgr.GetInstance():PlayCV_V3(var0_54, var1_54)
	end
end

function var0_0.unloadExtraVoice(arg0_55)
	if arg0_55.loginCueSheet then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_55.loginCueSheet)

		arg0_55.loginCueSheet = nil
	end
end

function var0_0.autoLogin(arg0_56)
	if arg0_56.shareData.lastLoginUser then
		if arg0_56.shareData.autoLoginEnabled then
			arg0_56.event:emit(LoginMediator.ON_LOGIN, arg0_56.shareData.lastLoginUser)
		end

		if arg0_56.loginPanelView:GetLoaded() then
			if arg0_56.shareData.lastLoginUser.type == 1 then
				arg0_56.loginPanelView:SetContent(arg0_56.shareData.lastLoginUser.arg2, arg0_56.shareData.lastLoginUser.arg3)
			elseif arg0_56.shareData.lastLoginUser.type == 2 then
				arg0_56.loginPanelView:SetContent(arg0_56.shareData.lastLoginUser.arg1, arg0_56.shareData.lastLoginUser.arg2)
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

function var0_0.updateServerTF(arg0_57, arg1_57, arg2_57)
	setText(findTF(arg1_57, "name"), "-  " .. arg2_57.name .. "  -")
	setImageSprite(findTF(arg1_57, "statu"), arg0_57.iconSpries[arg2_57.status + 1], true)

	findTF(arg1_57, "statu_1"):GetComponent("Image").color = Color.New(var4_0[arg2_57.status + 1][1], var4_0[arg2_57.status + 1][2], var4_0[arg2_57.status + 1][3], var4_0[arg2_57.status + 1][4])

	setActive(findTF(arg1_57, "mark"), arg2_57.isLogined)
	setActive(arg0_57:findTF("tag_new", arg1_57), arg2_57.isNew)
	setActive(arg0_57:findTF("tag_hot", arg1_57), arg2_57.isHot)
	onButton(arg0_57, arg1_57, function()
		if arg2_57.status == Server.STATUS.VINDICATE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_vindicate"))

			return
		end

		if arg2_57.status == Server.STATUS.FULL then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_full"))

			return
		end

		arg0_57:setLastLoginServer(arg2_57)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_57.serversPanel, arg0_57._tf)
		setActive(arg0_57.serversPanel, false)
	end, SFX_CONFIRM)
end

function var0_0.updateAdviceServer(arg0_59)
	if not arg0_59.recentTF or not arg0_59.adviceTF then
		return
	end

	setActive(arg0_59.recentTF, arg0_59.shareData.lastLoginServer)

	if arg0_59.shareData.lastLoginServer then
		local var0_59 = findTF(arg0_59.recentTF, "server")

		arg0_59:updateServerTF(var0_59, arg0_59.shareData.lastLoginServer)
	end

	local var1_59 = getProxy(ServerProxy).firstServer

	setActive(arg0_59.adviceTF, var1_59)

	if var1_59 then
		local var2_59 = findTF(arg0_59.adviceTF, "server")

		arg0_59:updateServerTF(var2_59, var1_59)
	end
end

function var0_0.updateServerList(arg0_60, arg1_60)
	arg0_60.serverList = arg1_60

	local var0_60 = _.sort(_.values(arg1_60), function(arg0_61, arg1_61)
		return arg0_61.sortIndex < arg1_61.sortIndex
	end)

	removeAllChildren(arg0_60.servers)

	if IsUnityEditor then
		table.sort(var0_60, function(arg0_62, arg1_62)
			local var0_62 = string.lower(arg0_62.name)
			local var1_62 = string.lower(arg1_62.name)

			return string.byte(var0_62, 1) > string.byte(var1_62, 1)
		end)
	end

	arg0_60.serversDic = {}

	for iter0_60, iter1_60 in pairs(var0_60) do
		local var1_60 = cloneTplTo(arg0_60.serverTpl, arg0_60.servers)

		arg0_60:updateServerTF(var1_60, iter1_60)
		table.insert(arg0_60.serversDic, {
			server = iter1_60,
			tf = var1_60,
			id = iter1_60.id
		})
	end
end

function var0_0.fillterRefundServer(arg0_63)
	local var0_63 = getProxy(UserProxy)
	local var1_63 = {}

	if var0_63.data.limitServerIds and #var0_63.data.limitServerIds > 0 and arg0_63.serverList and #arg0_63.serverList > 0 then
		local var2_63 = var0_63.data.limitServerIds
		local var3_63

		for iter0_63, iter1_63 in pairs(arg0_63.serverList) do
			local var4_63 = iter1_63.id
			local var5_63 = false

			for iter2_63, iter3_63 in pairs(var2_63) do
				if var2_63[iter2_63] == var4_63 and not var5_63 then
					if not var3_63 then
						var3_63 = "\n" .. iter1_63.name
					else
						var3_63 = var3_63 .. "," .. iter1_63.name
					end

					table.insert(var1_63, iter1_63)

					var5_63 = true
				end
			end
		end

		arg0_63:updateServerList(var1_63)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("login_arrears_tips", var3_63),
			onYes = function()
				return
			end
		})
	end
end

function var0_0.switchToTencentLogin(arg0_65)
	arg0_65:switchSubView({
		LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW
	})
end

function var0_0.switchToAiriLogin(arg0_66)
	arg0_66:switchSubView({
		LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
		LoginSceneConst.DEFINE.PRESS_TO_LOGIN
	})
end

function var0_0.switchToLogin(arg0_67)
	arg0_67:switchSubView({
		LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
	})
end

function var0_0.switchToRegister(arg0_68)
	arg0_68:switchSubView({
		LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
	})
end

function var0_0.switchToServer(arg0_69)
	arg0_69:updateAdviceServer()

	if pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER and PLATFORM_CODE ~= PLATFORM_KR then
		arg0_69:switchSubView({
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	else
		arg0_69:switchSubView({
			LoginSceneConst.DEFINE.ACCOUNT_BTN,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	end
end

function var0_0.SwitchToWaitPanel(arg0_70, arg1_70)
	local var0_70 = arg0_70:findTF("Msgbox")
	local var1_70 = arg0_70:findTF("window/content", var0_70)

	arg0_70.waitTimer = nil

	local var2_70 = 0
	local var3_70 = arg1_70

	arg0_70.waitTimer = Timer.New(function()
		setText(var1_70, i18n("login_wait_tip", var3_70))

		arg1_70 = arg1_70 - 1

		if math.random(0, 1) == 1 then
			var3_70 = arg1_70
		end

		if arg1_70 <= 0 then
			triggerButton(arg0_70:findTF("background"))
			arg0_70.waitTimer:Stop()

			arg0_70.waitTimer = nil
		end
	end, 1, -1)

	arg0_70.waitTimer:Start()
	arg0_70.waitTimer.func()
	setActive(var0_70, true)
end

function var0_0.willExit(arg0_72)
	if arg0_72.waitTimer then
		arg0_72.waitTimer:Stop()

		arg0_72.waitTimer = nil
	end

	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_72.loginPanelView:Destroy()
	arg0_72.registerPanelView:Destroy()
	arg0_72.tencentLoginPanelView:Destroy()
	arg0_72.airiLoginPanelView:Destroy()
	arg0_72.transcodeAlertView:Destroy()
	arg0_72.yostarAlertView:Destroy()
	arg0_72.switchGatewayBtn:Dispose()
end

function var0_0.playOpening(arg0_73, arg1_73)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		if not arg0_73.cg then
			arg0_73.cg = GetOrAddComponent(arg0_73._tf, "CanvasGroup")
		end

		arg0_73.cg.alpha = 0
	end, function()
		arg0_73.cg.alpha = 1

		if arg1_73 then
			arg1_73()
		end
	end, "ui", "opening", true, false, nil)

	arg0_73.onPlayingOP = true
end

function var0_0.closeYostarAlertView(arg0_76)
	if arg0_76.yostarAlertView and arg0_76.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_76.yostarAlertView:Destroy()
	end
end

function var0_0.onLoadDataDone(arg0_77)
	arg0_77:unloadExtraVoice()

	if getProxy(PlayerProxy) then
		getProxy(PlayerProxy):setFlag("login", true)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	end
end

return var0_0
