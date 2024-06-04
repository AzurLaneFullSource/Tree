local var0 = class("LoginScene", import("..base.BaseUI"))
local var1 = 1

function var0.getUIName(arg0)
	return "LoginUI2"
end

function var0.getBGM(arg0)
	if arg0.bgmName and arg0.bgmName ~= "" then
		return arg0.bgmName
	end

	return var0.super.getBGM(arg0)
end

function var0.preload(arg0, arg1)
	arg0.iconSpries = {}

	seriesAsync({
		function(arg0)
			buildTempAB("ui/LoginUI2_atlas", function(arg0)
				table.insert(arg0.iconSpries, arg0:LoadAssetSync("statu_green", typeof(Sprite), true, false))
				table.insert(arg0.iconSpries, arg0:LoadAssetSync("statu_gray", typeof(Sprite), true, false))
				table.insert(arg0.iconSpries, arg0:LoadAssetSync("statu_red", typeof(Sprite), true, false))
				table.insert(arg0.iconSpries, arg0:LoadAssetSync("statu_org", typeof(Sprite), true, false))
				arg0()
			end)
		end,
		function(arg0)
			arg0.isCriBg, arg0.bgPath, arg0.bgmName, arg0.isOpPlay, arg0.opVersion = getLoginConfig()

			if arg0.isCriBg then
				LoadAndInstantiateAsync("effect", arg0.bgPath, function(arg0)
					arg0.criBgGo = arg0

					arg0()
				end)
			else
				LoadSpriteAsync("loadingbg/" .. arg0.bgPath, function(arg0)
					arg0.staticBgSprite = arg0

					arg0()
				end)
			end
		end
	}, arg1)
end

function var0.init(arg0)
	local var0 = BundleWizard.Inst:GetGroupMgr("DEFAULT_RES")

	arg0:setBg()

	arg0.version = arg0:findTF("version")
	arg0.version:GetComponent("Text").text = "ver " .. var0.CurrentVersion:ToString()
	arg0.bgLay = arg0:findTF("bg_lay")
	arg0.accountBtn = arg0:findTF("bg_lay/buttons/account_button")
	arg0.repairBtn = arg0:findTF("btns/repair_button")
	arg0.privateBtn = arg0:findTF("btns/private_btn")
	arg0.licenceBtn = arg0:findTF("btns/Licence_btn")
	arg0.chInfo = arg0:findTF("background/info")

	setActive(arg0.chInfo, PLATFORM_CODE == PLATFORM_CH)

	arg0.pressToLogin = GetOrAddComponent(arg0:findTF("background/press_to_login"), "CanvasGroup")

	LeanTween.alphaCanvas(arg0.pressToLogin, 0.25, var1):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0.currentServer = arg0:findTF("current_server")
	arg0.serviceBtn = arg0:findTF("bg_lay/buttons/service_button")
	arg0.filingBtn = arg0:findTF("filingBtn")

	setActive(arg0.filingBtn, PLATFORM_CODE == PLATFORM_CH)

	arg0.serversPanel = arg0:findTF("servers")
	arg0.servers = arg0:findTF("panel/servers/content/server_list", arg0.serversPanel)
	arg0.serverTpl = arg0:getTpl("server_tpl")
	arg0.recentTF = arg0:findTF("panel/servers/content/advice_panel/recent", arg0.serversPanel)
	arg0.adviceTF = arg0:findTF("panel/servers/content/advice_panel/advice", arg0.serversPanel)
	arg0.userAgreenTF = arg0:findTF("UserAgreement")
	arg0.userAgreenMainTF = arg0:findTF("UserAgreement/window")
	arg0.closeUserAgreenTF = arg0.userAgreenTF:Find("window/close_btn")
	arg0.userAgreenConfirmTF = arg0:findTF("UserAgreement/window/accept_btn")
	arg0.userDisagreeConfirmTF = arg0:findTF("UserAgreement/window/disagree_btn")
	arg0.switchGatewayBtn = SwitchGatewayBtn.New(arg0:findTF("servers/panel/switch_platform"))

	setActive(arg0.userAgreenTF, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.userAgreenTF, arg0._tf)

	arg0.opBtn = arg0:findTF("bg_lay/buttons/opBtn")

	if arg0.opBtn then
		setActive(arg0.opBtn, arg0.isOpPlay)
	end

	arg0.airiUidTxt = arg0:findTF("airi_uid")
	arg0.shareData = {}
	arg0.searchAccount = arg0:findTF("panel/searchAccount", arg0.serversPanel)

	setText(findTF(arg0.searchAccount, "text"), i18n("query_role_button"))

	arg0.serverPanelCanvas = GetComponent(arg0:findTF("servers/panel/servers"), typeof(CanvasGroup))

	onButton(arg0, arg0.searchAccount, function()
		if not arg0.serversDic or arg0.searching then
			return
		end

		arg0:searchAountState(true)

		arg0.serverPanelCanvas.interactable = false

		arg0.event:emit(LoginMediator.ON_SEARCH_ACCOUNT, {
			callback = function()
				arg0.serverPanelCanvas.interactable = true

				arg0:searchAountState(false)
			end,
			update = function(arg0)
				arg0:setServerAccountData(arg0)
			end
		})
	end, SFX_CONFIRM)

	arg0.subViewList = {}
	arg0.loginPanelView = LoginPanelView.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.loginPanelView:SetShareData(arg0.shareData)

	arg0.registerPanelView = RegisterPanelView.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.loginPanelView:SetShareData(arg0.shareData)

	arg0.tencentLoginPanelView = TencentLoginPanelView.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.loginPanelView:SetShareData(arg0.shareData)

	arg0.airiLoginPanelView = AiriLoginPanelView.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.loginPanelView:SetShareData(arg0.shareData)

	arg0.transcodeAlertView = TranscodeAlertView.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.loginPanelView:SetShareData(arg0.shareData)

	arg0.yostarAlertView = YostarAlertView.New(arg0._tf, arg0.event, arg0.contextData)

	arg0.loginPanelView:SetShareData(arg0.shareData)

	arg0.subViewList[LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW] = arg0.loginPanelView
	arg0.subViewList[LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW] = arg0.registerPanelView
	arg0.subViewList[LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW] = arg0.tencentLoginPanelView
	arg0.subViewList[LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW] = arg0.airiLoginPanelView
	arg0.subViewList[LoginSceneConst.DEFINE.TRANSCODE_ALERT_VIEW] = arg0.transcodeAlertView
	arg0.subViewList[LoginSceneConst.DEFINE.YOSTAR_ALERT_VIEW] = arg0.yostarAlertView
	arg0.subViewList[LoginSceneConst.DEFINE.PRESS_TO_LOGIN] = arg0.pressToLogin
	arg0.subViewList[LoginSceneConst.DEFINE.BG_LAY] = arg0.bgLay
	arg0.subViewList[LoginSceneConst.DEFINE.SERVER_PANEL] = arg0.serversPanel
	arg0.subViewList[LoginSceneConst.DEFINE.ACCOUNT_BTN] = arg0.accountBtn
	arg0.subViewList[LoginSceneConst.DEFINE.CURRENT_SERVER] = arg0.currentServer
	arg0.age = arg0:findTF("background/age")

	if PLATFORM_CODE == PLATFORM_CH then
		onButton(arg0, arg0.age, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.cadpa_help.tip,
				title = pg.MsgboxMgr.TITLE_CADPA
			})
		end)
		SetActive(arg0.age, true)
	end

	SetActive(arg0.age, PLATFORM_CODE == PLATFORM_CH)
	setText(findTF(arg0.currentServer, "server_name"), "")
	arg0:switchToServer()
	arg0:initEvents()
end

function var0.setServerAccountData(arg0, arg1)
	local var0 = arg1.id
	local var1

	for iter0 = 1, #arg0.serversDic do
		if arg0.serversDic[iter0].id == var0 then
			var1 = arg0.serversDic[iter0]

			break
		end
	end

	if not var1 then
		return
	end

	local var2 = var1.tf

	if arg1 and arg1.level then
		setActive(findTF(var2, "mark/charactor"), true)
		setActive(findTF(var2, "mark/level"), true)
		setActive(findTF(var2, "mark/searching"), false)
		setText(findTF(var2, "mark/level"), "lv." .. arg1.level)
		setText(findTF(var2, "mark/level"), setColorStr("lv." .. arg1.level, "#ffffffff"))

		var1.level = arg1.level
	else
		setActive(findTF(var2, "mark/level"), true)
		setActive(findTF(var2, "mark/searching"), false)
		setActive(findTF(var2, "mark/charactor"), false)

		var1.level = 0

		setText(findTF(var2, "mark/level"), setColorStr(i18n("query_role_none"), "#d0d0d0FF"))
	end
end

function var0.searchAountState(arg0, arg1)
	arg0.searching = arg1

	for iter0 = 1, #arg0.serversDic do
		local var0 = arg0.serversDic[iter0].tf
		local var1 = arg0.serversDic[iter0].level

		setActive(findTF(var0, "mark"), true)

		if arg1 then
			setActive(findTF(var0, "mark/charactor"), false)
			setActive(findTF(var0, "mark/level"), true)
			setText(findTF(var0, "mark/level"), setColorStr(i18n("query_role"), "#d0d0d0FF"))
			setActive(findTF(var0, "mark/searching"), true)
		else
			if not var1 then
				setText(findTF(var0, "mark/level"), setColorStr(i18n("query_role_fail"), "#d0d0d0FF"))
			end

			setActive(findTF(var0, "mark/searching"), false)
		end
	end
end

function var0.initEvents(arg0)
	arg0:bind(LoginSceneConst.SWITCH_SUB_VIEW, function(arg0, arg1)
		arg0:switchSubView(arg1)
	end)
	arg0:bind(LoginSceneConst.CLEAR_REGISTER_VIEW, function(arg0)
		arg0.registerPanelView:ActionInvoke("Clear")
	end)
end

function var0.switchSubView(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.subViewList) do
		if isa(iter1, BaseSubView) then
			if table.contains(arg1, iter0) then
				iter1:CallbackInvoke(function()
					arg0.repairBtn:SetAsLastSibling()
				end)
				iter1:Load()
				iter1:ActionInvoke("Show")
			else
				iter1:ActionInvoke("Hide")
			end
		else
			setActive(iter1, table.contains(arg1, iter0))
		end
	end

	if not table.contains(arg1, LoginSceneConst.DEFINE.SERVER_PANEL) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.serversPanel, arg0._tf)
	end

	if table.contains(arg1, LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW) then
		setActive(arg0.airiUidTxt, false)
	end

	arg0.userAgreenTF:SetAsLastSibling()
	arg0.repairBtn:SetAsLastSibling()
end

function var0.onBackPressed(arg0)
	if arg0.searching then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.serversPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.serversPanel, arg0._tf)
		setActive(arg0.serversPanel, false)

		return
	end

	if isActive(arg0.userAgreenTF) then
		setActive(arg0.userAgreenTF, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.userAgreenTF, arg0._tf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0.setUserData(arg0, arg1)
	setActive(arg0.airiUidTxt, true)
	setText(arg0.airiUidTxt, "uid: " .. arg1.arg2)
end

function var0.showUserAgreement(arg0, arg1)
	local var0

	if PLATFORM_CODE == PLATFORM_CH then
		arg0.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(0.784313725490196, 0.784313725490196, 0.784313725490196, 0.501960784313725)
	else
		var0 = true
	end

	local var1 = require("ShareCfg.UserAgreement")

	setActive(arg0.userAgreenTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.userAgreenTF, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	setText(arg0.userAgreenTF:Find("window/container/scrollrect/content/Text"), var1.content)
	onButton(arg0, arg0.userAgreenConfirmTF, function()
		if var0 then
			setActive(arg0.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.userAgreenTF, arg0._tf)

			if arg1 then
				arg1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(arg0, arg0.userAgreenTF:Find("window/container/scrollrect"), function(arg0)
		if arg0.y <= 0.01 and not var0 then
			var0 = true

			if PLATFORM_CODE == PLATFORM_CH then
				arg0.userAgreenConfirmTF:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)
			end
		end
	end)
end

function var0.setBg(arg0)
	arg0.bgImg = arg0:findTF("background/bg"):GetComponent(typeof(Image))

	if not arg0.isCriBg then
		setImageSprite(arg0.bgImg, arg0.staticBgSprite)
	else
		arg0.bgImg.enabled = false

		local var0 = arg0.criBgGo.transform

		var0:SetParent(arg0.bgImg.transform, false)
		var0:SetAsFirstSibling()
	end
end

function var0.setLastLogin(arg0, arg1)
	arg0.shareData.lastLoginUser = arg1
end

function var0.setAutoLogin(arg0)
	arg0.shareData.autoLoginEnabled = true
end

function var0.setLastLoginServer(arg0, arg1)
	if not arg1 then
		setText(findTF(arg0.currentServer, "server_name"), "")

		arg0.shareData.lastLoginServer = nil

		arg0:updateAdviceServer()

		return
	end

	setText(findTF(arg0.currentServer, "server_name"), arg1.name)

	arg0.shareData.lastLoginServer = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.closeUserAgreenTF, function()
		if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
			setActive(arg0.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.userAgreenTF, arg0._tf)
		else
			setActive(arg0.userAgreenMainTF, false)
			onNextTick(function()
				setActive(arg0.userAgreenMainTF, true)
			end)
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.privateBtn, function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0, arg0.licenceBtn, function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
	setActive(arg0.privateBtn, PLATFORM_CODE == PLATFORM_CH)
	setActive(arg0.licenceBtn, PLATFORM_CODE == PLATFORM_CH)

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		onButton(arg0, arg0.userDisagreeConfirmTF, function()
			setActive(arg0.userAgreenTF, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.userAgreenTF, arg0._tf)
		end)
	end

	setActive(arg0.serviceBtn, PLATFORM_CODE == PLATFORM_KR)
	onButton(arg0, arg0.serviceBtn, function()
		if PLATFORM_CODE == PLATFORM_KR then
			pg.SdkMgr.GetInstance():UserCenter()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
		end
	end, SFX_MAIN)
	onButton(arg0, arg0.accountBtn, function()
		local var0 = pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER

		if not var0 then
			arg0:switchToLogin()
		elseif var0 and PLATFORM_KR == PLATFORM_CODE then
			pg.SdkMgr.GetInstance():SwitchAccount()
		end
	end, SFX_MAIN)
	onButton(arg0, arg0.repairBtn, function()
		pg.RepairResMgr.GetInstance():Repair()
	end)

	local function var0()
		local var0 = pg.SdkMgr.GetInstance():GetLoginType()

		if var0 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif var0 == LoginType.PLATFORM_TENCENT then
			arg0:switchToTencentLogin()
		elseif var0 == LoginType.PLATFORM_INNER then
			arg0:switchToLogin()
		end
	end

	onButton(arg0, arg0.filingBtn, function()
		Application.OpenURL("http://sq.ccm.gov.cn:80/ccnt/sczr/service/business/emark/gameNetTag/4028c08b58bd467b0158bd8bd80d062a")
	end, SFX_PANEL)
	onButton(arg0, arg0.currentServer, function()
		if table.getCount(arg0.serverList or {}) == 0 then
			var0()
		else
			pg.UIMgr.GetInstance():BlurPanel(arg0.serversPanel)
			setActive(arg0.serversPanel, true)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.serversPanel, function()
		pg.UIMgr.GetInstance():UnblurPanel(arg0.serversPanel, arg0._tf)
		setActive(arg0.serversPanel, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("background"), function()
		if pg.CpkPlayMgr.GetInstance():OnPlaying() then
			return
		end

		if not arg0.initFinished then
			return
		end

		if arg0.isNeedResCheck then
			arg0.event:emit(LoginMediator.CHECK_RES)

			return
		end

		if getProxy(SettingsProxy):CheckNeedUserAgreement() then
			arg0.event:emit(LoginMediator.ON_LOGIN_PROCESS)

			return
		end

		if go(arg0.pressToLogin).activeSelf then
			if table.getCount(arg0.serverList or {}) == 0 then
				var0()

				return
			end

			if not arg0.shareData.lastLoginServer then
				pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_choiseServer"))

				return
			end

			if arg0.shareData.lastLoginServer.status == Server.STATUS.VINDICATE or arg0.shareData.lastLoginServer.status == Server.STATUS.FULL then
				ServerStateChecker.New():Execute(function(arg0)
					if arg0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_disabled"))
					else
						arg0.event:emit(LoginMediator.ON_SERVER, arg0.shareData.lastLoginServer)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
					end
				end)

				return
			end

			arg0.event:emit(LoginMediator.ON_SERVER, arg0.shareData.lastLoginServer)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CONFIRM)
		end
	end)

	if arg0.isOpPlay then
		onButton(arg0, arg0.opBtn, function()
			if arg0.initFinished and not pg.CpkPlayMgr.GetInstance():OnPlaying() then
				arg0:playOpening()
			end
		end)

		if PLATFORM_CODE ~= PLATFORM_JP and PlayerPrefs.GetString("op_ver", "") ~= arg0.opVersion then
			arg0:playOpening(function()
				PlayerPrefs.SetString("op_ver", arg0.opVersion)
				arg0:playExtraVoice()

				arg0.initFinished = true

				arg0.event:emit(LoginMediator.ON_LOGIN_PROCESS)
			end)

			return
		end

		arg0.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	else
		arg0.event:emit(LoginMediator.ON_LOGIN_PROCESS)
	end

	arg0:playExtraVoice()

	arg0.initFinished = true

	arg0:InitPrivateAndLicence()
end

function var0.InitPrivateAndLicence(arg0)
	local var0 = PLATFORM_CODE == PLATFORM_CH or IsUnityEditor

	setActive(arg0.privateBtn, var0)
	setActive(arg0.licenceBtn, var0)

	if var0 then
		onButton(arg0, arg0.privateBtn, function()
			pg.SdkMgr.GetInstance():ShowPrivate()
		end, SFX_PANEL)
		onButton(arg0, arg0.licenceBtn, function()
			pg.SdkMgr.GetInstance():ShowLicence()
		end, SFX_PANEL)
	end
end

function var0.playExtraVoice(arg0)
	local var0 = pg.gameset.login_extra_voice.description

	if var0 and #var0 > 0 then
		local var1 = var0[math.clamp(math.floor(math.random() * #var0) + 1, 1, #var0)]
		local var2 = "cv-" .. var1
		local var3 = pg.CriMgr.GetInstance()

		arg0.loginCueSheet = var2

		var3:PlayCV_V3(var2, "extra")
	end
end

function var0.unloadExtraVoice(arg0)
	if arg0.loginCueSheet then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0.loginCueSheet)

		arg0.loginCueSheet = nil
	end
end

function var0.autoLogin(arg0)
	if arg0.shareData.lastLoginUser then
		if arg0.shareData.autoLoginEnabled then
			arg0.event:emit(LoginMediator.ON_LOGIN, arg0.shareData.lastLoginUser)
		end

		if arg0.loginPanelView:GetLoaded() then
			if arg0.shareData.lastLoginUser.type == 1 then
				arg0.loginPanelView:SetContent(arg0.shareData.lastLoginUser.arg2, arg0.shareData.lastLoginUser.arg3)
			elseif arg0.shareData.lastLoginUser.type == 2 then
				arg0.loginPanelView:SetContent(arg0.shareData.lastLoginUser.arg1, arg0.shareData.lastLoginUser.arg2)
			end
		end
	end
end

local var2 = {
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

function var0.updateServerTF(arg0, arg1, arg2)
	setText(findTF(arg1, "name"), "-  " .. arg2.name .. "  -")
	setImageSprite(findTF(arg1, "statu"), arg0.iconSpries[arg2.status + 1], true)

	findTF(arg1, "statu_1"):GetComponent("Image").color = Color.New(var2[arg2.status + 1][1], var2[arg2.status + 1][2], var2[arg2.status + 1][3], var2[arg2.status + 1][4])

	setActive(findTF(arg1, "mark"), arg2.isLogined)
	setActive(arg0:findTF("tag_new", arg1), arg2.isNew)
	setActive(arg0:findTF("tag_hot", arg1), arg2.isHot)
	onButton(arg0, arg1, function()
		if arg2.status == Server.STATUS.VINDICATE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_vindicate"))

			return
		end

		if arg2.status == Server.STATUS.FULL then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_server_full"))

			return
		end

		arg0:setLastLoginServer(arg2)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.serversPanel, arg0._tf)
		setActive(arg0.serversPanel, false)
	end, SFX_CONFIRM)
end

function var0.updateAdviceServer(arg0)
	if not arg0.recentTF or not arg0.adviceTF then
		return
	end

	setActive(arg0.recentTF, arg0.shareData.lastLoginServer)

	if arg0.shareData.lastLoginServer then
		local var0 = findTF(arg0.recentTF, "server")

		arg0:updateServerTF(var0, arg0.shareData.lastLoginServer)
	end

	local var1 = getProxy(ServerProxy).firstServer

	setActive(arg0.adviceTF, var1)

	if var1 then
		local var2 = findTF(arg0.adviceTF, "server")

		arg0:updateServerTF(var2, var1)
	end
end

function var0.updateServerList(arg0, arg1)
	arg0.serverList = arg1

	local var0 = _.sort(_.values(arg1), function(arg0, arg1)
		return arg0.sortIndex < arg1.sortIndex
	end)

	removeAllChildren(arg0.servers)

	if IsUnityEditor then
		table.sort(var0, function(arg0, arg1)
			local var0 = string.lower(arg0.name)
			local var1 = string.lower(arg1.name)

			return string.byte(var0, 1) > string.byte(var1, 1)
		end)
	end

	arg0.serversDic = {}

	for iter0, iter1 in pairs(var0) do
		local var1 = cloneTplTo(arg0.serverTpl, arg0.servers)

		arg0:updateServerTF(var1, iter1)
		table.insert(arg0.serversDic, {
			server = iter1,
			tf = var1,
			id = iter1.id
		})
	end
end

function var0.fillterRefundServer(arg0)
	local var0 = getProxy(UserProxy)
	local var1 = {}

	if var0.data.limitServerIds and #var0.data.limitServerIds > 0 and arg0.serverList and #arg0.serverList > 0 then
		local var2 = var0.data.limitServerIds
		local var3

		for iter0, iter1 in pairs(arg0.serverList) do
			local var4 = iter1.id
			local var5 = false

			for iter2, iter3 in pairs(var2) do
				if var2[iter2] == var4 and not var5 then
					if not var3 then
						var3 = "\n" .. iter1.name
					else
						var3 = var3 .. "," .. iter1.name
					end

					table.insert(var1, iter1)

					var5 = true
				end
			end
		end

		arg0:updateServerList(var1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("login_arrears_tips", var3),
			onYes = function()
				return
			end
		})
	end
end

function var0.switchToTencentLogin(arg0)
	arg0:switchSubView({
		LoginSceneConst.DEFINE.TENCENT_LOGIN_VIEW
	})
end

function var0.switchToAiriLogin(arg0)
	arg0:switchSubView({
		LoginSceneConst.DEFINE.AIRI_LOGIN_PANEL_VIEW,
		LoginSceneConst.DEFINE.PRESS_TO_LOGIN
	})
end

function var0.switchToLogin(arg0)
	arg0:switchSubView({
		LoginSceneConst.DEFINE.LOGIN_PANEL_VIEW
	})
end

function var0.switchToRegister(arg0)
	arg0:switchSubView({
		LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
	})
end

function var0.switchToServer(arg0)
	arg0:updateAdviceServer()

	if pg.SdkMgr.GetInstance():GetLoginType() ~= LoginType.PLATFORM_INNER and PLATFORM_CODE ~= PLATFORM_KR then
		arg0:switchSubView({
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	else
		arg0:switchSubView({
			LoginSceneConst.DEFINE.ACCOUNT_BTN,
			LoginSceneConst.DEFINE.PRESS_TO_LOGIN,
			LoginSceneConst.DEFINE.CURRENT_SERVER,
			LoginSceneConst.DEFINE.BG_LAY
		})
	end
end

function var0.SwitchToWaitPanel(arg0, arg1)
	local var0 = arg0:findTF("Msgbox")
	local var1 = arg0:findTF("window/content", var0)

	arg0.waitTimer = nil

	local var2 = 0
	local var3 = arg1

	arg0.waitTimer = Timer.New(function()
		setText(var1, i18n("login_wait_tip", var3))

		arg1 = arg1 - 1

		if math.random(0, 1) == 1 then
			var3 = arg1
		end

		if arg1 <= 0 then
			triggerButton(arg0:findTF("background"))
			arg0.waitTimer:Stop()

			arg0.waitTimer = nil
		end
	end, 1, -1)

	arg0.waitTimer:Start()
	arg0.waitTimer.func()
	setActive(var0, true)
end

function var0.willExit(arg0)
	if arg0.waitTimer then
		arg0.waitTimer:Stop()

		arg0.waitTimer = nil
	end

	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0.loginPanelView:Destroy()
	arg0.registerPanelView:Destroy()
	arg0.tencentLoginPanelView:Destroy()
	arg0.airiLoginPanelView:Destroy()
	arg0.transcodeAlertView:Destroy()
	arg0.yostarAlertView:Destroy()
	arg0.switchGatewayBtn:Dispose()
end

function var0.playOpening(arg0, arg1)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		if not arg0.cg then
			arg0.cg = GetOrAddComponent(arg0._tf, "CanvasGroup")
		end

		arg0.cg.alpha = 0
	end, function()
		arg0.cg.alpha = 1

		if arg1 then
			arg1()
		end
	end, "ui", "opening", true, false, nil)

	arg0.onPlayingOP = true
end

function var0.closeYostarAlertView(arg0)
	if arg0.yostarAlertView and arg0.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0.yostarAlertView:Destroy()
	end
end

function var0.onLoadDataDone(arg0)
	arg0:unloadExtraVoice()

	if getProxy(PlayerProxy) then
		getProxy(PlayerProxy):setFlag("login", true)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	end
end

return var0
