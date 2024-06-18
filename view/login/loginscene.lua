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
			buildTempAB("ui/LoginUI2_atlas", function(arg0_5)
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
			update = function(arg0_12)
				arg0_9:setServerAccountData(arg0_12)
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
		pg.UIMgr.GetInstance():UnblurPanel(arg0_19.serversPanel, arg0_19._tf)
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
		pg.UIMgr.GetInstance():UnblurPanel(arg0_21.serversPanel, arg0_21._tf)
		setActive(arg0_21.serversPanel, false)

		return
	end

	if isActive(arg0_21.userAgreenTF) then
		setActive(arg0_21.userAgreenTF, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_21.userAgreenTF, arg0_21._tf)

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
	pg.UIMgr.GetInstance():BlurPanel(arg0_23.userAgreenTF, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	setText(arg0_23.userAgreenTF:Find("window/container/scrollrect/content/Text"), var1_23.content)
	onButton(arg0_23, arg0_23.userAgreenConfirmTF, function()
		if var0_23 then
			setActive(arg0_23.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_23.userAgreenTF, arg0_23._tf)

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
	arg0_26.bgImg = arg0_26:findTF("background/bg"):GetComponent(typeof(Image))

	if not arg0_26.isCriBg then
		setImageSprite(arg0_26.bgImg, arg0_26.staticBgSprite)
	else
		arg0_26.bgImg.enabled = false

		local var0_26 = arg0_26.criBgGo.transform

		var0_26:SetParent(arg0_26.bgImg.transform, false)
		var0_26:SetAsFirstSibling()
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
			pg.UIMgr.GetInstance():UnblurPanel(arg0_30.userAgreenTF, arg0_30._tf)
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
			pg.UIMgr.GetInstance():UnblurPanel(arg0_30.userAgreenTF, arg0_30._tf)
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
		pg.UIMgr.GetInstance():UnblurPanel(arg0_30.serversPanel, arg0_30._tf)
		setActive(arg0_30.serversPanel, false)
	end, SFX_CANCEL)
	onButton(arg0_30, arg0_30:findTF("background"), function()
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

function var0_0.playExtraVoice(arg0_50)
	local var0_50 = pg.gameset.login_extra_voice.description

	if var0_50 and #var0_50 > 0 then
		local var1_50 = var0_50[math.clamp(math.floor(math.random() * #var0_50) + 1, 1, #var0_50)]
		local var2_50 = "cv-" .. var1_50
		local var3_50 = pg.CriMgr.GetInstance()

		arg0_50.loginCueSheet = var2_50

		var3_50:PlayCV_V3(var2_50, "extra")
	end
end

function var0_0.unloadExtraVoice(arg0_51)
	if arg0_51.loginCueSheet then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_51.loginCueSheet)

		arg0_51.loginCueSheet = nil
	end
end

function var0_0.autoLogin(arg0_52)
	if arg0_52.shareData.lastLoginUser then
		if arg0_52.shareData.autoLoginEnabled then
			arg0_52.event:emit(LoginMediator.ON_LOGIN, arg0_52.shareData.lastLoginUser)
		end

		if arg0_52.loginPanelView:GetLoaded() then
			if arg0_52.shareData.lastLoginUser.type == 1 then
				arg0_52.loginPanelView:SetContent(arg0_52.shareData.lastLoginUser.arg2, arg0_52.shareData.lastLoginUser.arg3)
			elseif arg0_52.shareData.lastLoginUser.type == 2 then
				arg0_52.loginPanelView:SetContent(arg0_52.shareData.lastLoginUser.arg1, arg0_52.shareData.lastLoginUser.arg2)
			end
		end
	end
end

local var2_0 = {
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

function var0_0.updateServerTF(arg0_53, arg1_53, arg2_53)
	setText(findTF(arg1_53, "name"), "-  " .. arg2_53.name .. "  -")
	setImageSprite(findTF(arg1_53, "statu"), arg0_53.iconSpries[arg2_53.status + 1], true)

	findTF(arg1_53, "statu_1"):GetComponent("Image").color = Color.New(var2_0[arg2_53.status + 1][1], var2_0[arg2_53.status + 1][2], var2_0[arg2_53.status + 1][3], var2_0[arg2_53.status + 1][4])

	setActive(findTF(arg1_53, "mark"), arg2_53.isLogined)
	setActive(arg0_53:findTF("tag_new", arg1_53), arg2_53.isNew)
	setActive(arg0_53:findTF("tag_hot", arg1_53), arg2_53.isHot)
	onButton(arg0_53, arg1_53, function()
		if arg2_53.status == Server.STATUS.VINDICATE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_vindicate"))

			return
		end

		if arg2_53.status == Server.STATUS.FULL then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_full"))

			return
		end

		arg0_53:setLastLoginServer(arg2_53)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_53.serversPanel, arg0_53._tf)
		setActive(arg0_53.serversPanel, false)
	end, SFX_CONFIRM)
end

function var0_0.updateAdviceServer(arg0_55)
	if not arg0_55.recentTF or not arg0_55.adviceTF then
		return
	end

	setActive(arg0_55.recentTF, arg0_55.shareData.lastLoginServer)

	if arg0_55.shareData.lastLoginServer then
		local var0_55 = findTF(arg0_55.recentTF, "server")

		arg0_55:updateServerTF(var0_55, arg0_55.shareData.lastLoginServer)
	end

	local var1_55 = getProxy(ServerProxy).firstServer

	setActive(arg0_55.adviceTF, var1_55)

	if var1_55 then
		local var2_55 = findTF(arg0_55.adviceTF, "server")

		arg0_55:updateServerTF(var2_55, var1_55)
	end
end

function var0_0.updateServerList(arg0_56, arg1_56)
	arg0_56.serverList = arg1_56

	local var0_56 = _.sort(_.values(arg1_56), function(arg0_57, arg1_57)
		return arg0_57.sortIndex < arg1_57.sortIndex
	end)

	removeAllChildren(arg0_56.servers)

	if IsUnityEditor then
		table.sort(var0_56, function(arg0_58, arg1_58)
			local var0_58 = string.lower(arg0_58.name)
			local var1_58 = string.lower(arg1_58.name)

			return string.byte(var0_58, 1) > string.byte(var1_58, 1)
		end)
	end

	arg0_56.serversDic = {}

	for iter0_56, iter1_56 in pairs(var0_56) do
		local var1_56 = cloneTplTo(arg0_56.serverTpl, arg0_56.servers)

		arg0_56:updateServerTF(var1_56, iter1_56)
		table.insert(arg0_56.serversDic, {
			server = iter1_56,
			tf = var1_56,
			id = iter1_56.id
		})
	end
end

function var0_0.fillterRefundServer(arg0_59)
	local var0_59 = getProxy(UserProxy)
	local var1_59 = {}

	if var0_59.data.limitServerIds and #var0_59.data.limitServerIds > 0 and arg0_59.serverList and #arg0_59.serverList > 0 then
		local var2_59 = var0_59.data.limitServerIds
		local var3_59

		for iter0_59, iter1_59 in pairs(arg0_59.serverList) do
			local var4_59 = iter1_59.id
			local var5_59 = false

			for iter2_59, iter3_59 in pairs(var2_59) do
				if var2_59[iter2_59] == var4_59 and not var5_59 then
					if not var3_59 then
						var3_59 = "\n" .. iter1_59.name
					else
						var3_59 = var3_59 .. "," .. iter1_59.name
					end

					table.insert(var1_59, iter1_59)

					var5_59 = true
				end
			end
		end

		arg0_59:updateServerList(var1_59)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("login_arrears_tips", var3_59),
			onYes = function()
				return
			end
		})
	end
end

function var0_0.switchToTencentLogin(arg0_61)
	arg0_61:switchSubView({
		LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW
	})
end

function var0_0.switchToAiriLogin(arg0_62)
	arg0_62:switchSubView({
		LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
		LoginSceneConst.DEFINE.PRESS_TO_LOGIN
	})
end

function var0_0.switchToLogin(arg0_63)
	arg0_63:switchSubView({
		LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
	})
end

function var0_0.switchToRegister(arg0_64)
	arg0_64:switchSubView({
		LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
	})
end

function var0_0.switchToServer(arg0_65)
	arg0_65:updateAdviceServer()

	if pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER and PLATFORM_CODE ~= PLATFORM_KR then
		arg0_65:switchSubView({
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	else
		arg0_65:switchSubView({
			LoginSceneConst.DEFINE.ACCOUNT_BTN,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	end
end

function var0_0.SwitchToWaitPanel(arg0_66, arg1_66)
	local var0_66 = arg0_66:findTF("Msgbox")
	local var1_66 = arg0_66:findTF("window/content", var0_66)

	arg0_66.waitTimer = nil

	local var2_66 = 0
	local var3_66 = arg1_66

	arg0_66.waitTimer = Timer.New(function()
		setText(var1_66, i18n("login_wait_tip", var3_66))

		arg1_66 = arg1_66 - 1

		if math.random(0, 1) == 1 then
			var3_66 = arg1_66
		end

		if arg1_66 <= 0 then
			triggerButton(arg0_66:findTF("background"))
			arg0_66.waitTimer:Stop()

			arg0_66.waitTimer = nil
		end
	end, 1, -1)

	arg0_66.waitTimer:Start()
	arg0_66.waitTimer.func()
	setActive(var0_66, true)
end

function var0_0.willExit(arg0_68)
	if arg0_68.waitTimer then
		arg0_68.waitTimer:Stop()

		arg0_68.waitTimer = nil
	end

	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_68.loginPanelView:Destroy()
	arg0_68.registerPanelView:Destroy()
	arg0_68.tencentLoginPanelView:Destroy()
	arg0_68.airiLoginPanelView:Destroy()
	arg0_68.transcodeAlertView:Destroy()
	arg0_68.yostarAlertView:Destroy()
	arg0_68.switchGatewayBtn:Dispose()
end

function var0_0.playOpening(arg0_69, arg1_69)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		if not arg0_69.cg then
			arg0_69.cg = GetOrAddComponent(arg0_69._tf, "CanvasGroup")
		end

		arg0_69.cg.alpha = 0
	end, function()
		arg0_69.cg.alpha = 1

		if arg1_69 then
			arg1_69()
		end
	end, "ui", "opening", true, false, nil)

	arg0_69.onPlayingOP = true
end

function var0_0.closeYostarAlertView(arg0_72)
	if arg0_72.yostarAlertView and arg0_72.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_72.yostarAlertView:Destroy()
	end
end

function var0_0.onLoadDataDone(arg0_73)
	arg0_73:unloadExtraVoice()

	if getProxy(PlayerProxy) then
		getProxy(PlayerProxy):setFlag("login", true)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	end
end

return var0_0
