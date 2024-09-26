local var0_0 = class("NewSettingsScene", import("..base.BaseUI"))

var0_0.PAGE_OTHER = 1
var0_0.PAGE_OPTION = 2
var0_0.PAGE_BATTLE = 3
var0_0.PAGE_RES = 4
var0_0.PAGE_3D = 5

function var0_0.getUIName(arg0_1)
	return "NewSettingsUI"
end

function var0_0.OnShowDescWindow(arg0_2, arg1_2)
	arg0_2.descWindow:ExecuteAction("Show", arg1_2.desc, arg1_2.alignment)
end

function var0_0.OnClearExchangeCode(arg0_3)
	if arg0_3.pages and arg0_3.pages[1] and arg0_3.pages[1]:GetLoaded() then
		arg0_3.pages[1]:OnClearExchangeCode()
	end
end

function var0_0.OnShowTranscode(arg0_4, arg1_4)
	if arg0_4.pages and arg0_4.pages[1] and arg0_4.pages[1]:GetLoaded() then
		arg0_4.pages[1]:OnShowTranscode(arg1_4)
	end
end

function var0_0.OnCheckAllAccountState(arg0_5)
	if arg0_5.pages and arg0_5.pages[1] and arg0_5.pages[1]:GetLoaded() then
		arg0_5.pages[1]:OnCheckAllAccountState()
	end
end

function var0_0.OnSecondPwdStateChange(arg0_6)
	if arg0_6.pages and arg0_6.pages[1] and arg0_6.pages[1]:GetLoaded() then
		arg0_6.pages[1]:OnSecondPwdStateChange()
	end
end

function var0_0.OnRandomFlagShipModeUpdate(arg0_7)
	arg0_7:emit(SettingsRandomFlagShipAndSkinPanel.EVT_UPDTAE)
end

function var0_0.OnSelectGraphicSettingLevel(arg0_8)
	arg0_8:emit(SettingsOtherGraphicsPanle.EVT_UPDTAE)
end

function var0_0.OnSelectCustomGraphicSetting(arg0_9)
	arg0_9:emit(SettingsGraphicsPanle.EVT_UPDTAE)
end

function var0_0.GetPage(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.pages) do
		if isa(iter1_10, arg1_10) then
			return iter1_10
		end
	end
end

function var0_0.init(arg0_11)
	arg0_11.backBtn = arg0_11:findTF("blur_panel/adapt/top/back_btn")

	local var0_11 = arg0_11:findTF("pages")

	arg0_11.pages = {
		SettingsOtherPage.New(var0_11, arg0_11.event, arg0_11.contextData),
		SettingsOptionPage.New(var0_11, arg0_11.event, arg0_11.contextData),
		SettingsBattlePage.New(var0_11, arg0_11.event, arg0_11.contextData),
		SettingsResPage.New(var0_11, arg0_11.event, arg0_11.contextData),
		Settings3DPage.New(var0_11, arg0_11.event, arg0_11.contextData)
	}
	arg0_11.toggles = {
		arg0_11:findTF("blur_panel/adapt/left_length/other"),
		arg0_11:findTF("blur_panel/adapt/left_length/options"),
		arg0_11:findTF("blur_panel/adapt/left_length/battle_ui"),
		arg0_11:findTF("blur_panel/adapt/left_length/resources"),
		arg0_11:findTF("blur_panel/adapt/left_length/threeD")
	}
	arg0_11.otherTip = arg0_11.toggles[1]:Find("tip")
	arg0_11.logoutBtn = arg0_11:findTF("blur_panel/adapt/left_length/logout")
	arg0_11.helpBtn = arg0_11:findTF("blur_panel/adapt/left_length/help_us")
	arg0_11.descWindow = SettingsMsgBosPage.New(arg0_11._tf, arg0_11.event)
end

function var0_0.didEnter(arg0_12)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.logoutBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("main_settingsScene_quest_exist"),
			onYes = function()
				arg0_12:emit(NewSettingsMediator.ON_LOGOUT)
			end
		})
	end, SFX_PANEL)

	if PLATFORM_CODE == PLATFORM_US then
		setActive(arg0_12.helpBtn, true)
		onButton(arg0_12, arg0_12.helpBtn, function()
			pg.SdkMgr.GetInstance():OpenYostarHelp()
		end, SFX_PANEL)
	elseif PLATFORM_CODE == PLATFORM_KR then
		setActive(arg0_12.helpBtn, true)
		onButton(arg0_12, arg0_12.helpBtn, function()
			pg.SdkMgr.GetInstance():BugReport()
		end, SFX_CANCEL)
		arg0_12.helpBtn:SetAsFirstSibling()
	end

	for iter0_12, iter1_12 in ipairs(arg0_12.toggles) do
		onToggle(arg0_12, iter1_12, function(arg0_18)
			if arg0_18 then
				arg0_12:SwitchPage(iter0_12)
			end
		end, SFX_PANEL)
	end

	setActive(arg0_12.otherTip, PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0)
	arg0_12:EnterDefaultPage()
end

function var0_0.EnterDefaultPage(arg0_19)
	local var0_19
	local var1_19 = arg0_19.contextData.toggle

	if var1_19 and type(var1_19) == "string" then
		if var1_19 == "sound" or var1_19 == "res" then
			var0_19 = var0_0.PAGE_RES
		else
			var0_19 = table.indexof({
				"other",
				"options",
				"interface",
				"res"
			}, var1_19)
		end
	end

	local var2_19 = arg0_19.contextData.page or var0_19 or var0_0.PAGE_RES

	triggerToggle(arg0_19.toggles[var2_19], true)
end

function var0_0.SwitchPage(arg0_20, arg1_20)
	local var0_20 = arg0_20.pages[arg1_20]

	if arg0_20.page and arg0_20.page ~= var0_20 and arg0_20.page:GetLoaded() then
		arg0_20.page:Hide()
	end

	var0_20:ExecuteAction("Show")

	arg0_20.page = var0_20

	if isa(var0_20, SettingsOtherPage) and isActive(arg0_20.otherTip) then
		setActive(arg0_20.otherTip, false)
	end
end

function var0_0.OpenYostarAlertView(arg0_21)
	arg0_21.yostarAlertView = YostarAlertView.New(arg0_21._tf, arg0_21.event, {
		isDestroyOnClose = true,
		isLinkMode = true
	})

	arg0_21.yostarAlertView:Load()
	arg0_21.yostarAlertView:ActionInvoke("Show")
end

function var0_0.CloseYostarAlertView(arg0_22)
	if arg0_22.yostarAlertView and arg0_22.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_22.yostarAlertView:Destroy()
	end
end

function var0_0.onBackPressed(arg0_23)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0_23 = GameObject.Find("OverlayCamera/Overlay/UIMain/DialogPanel")

	if isActive(var0_23) then
		triggerButton(var0_23.transform:Find("dialog/title/back"))

		return
	end

	arg0_23:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_24)
	Dorm3dRoomTemplateScene.SettingQuality()

	for iter0_24, iter1_24 in pairs(arg0_24.pages) do
		iter1_24:Destroy()
	end

	if arg0_24.descWindow then
		arg0_24.descWindow:Destroy()

		arg0_24.descWindow = nil
	end

	arg0_24.page = nil
	arg0_24.pages = nil
end

return var0_0
