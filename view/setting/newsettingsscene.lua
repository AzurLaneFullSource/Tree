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

function var0_0.OnApplicationPause(arg0_10)
	arg0_10:emit(SettingsNotificationPanel.UPDATE_ALARM_PANEL)
end

function var0_0.GetPage(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.pages) do
		if isa(iter1_11, arg1_11) then
			return iter1_11
		end
	end
end

function var0_0.init(arg0_12)
	arg0_12.backBtn = arg0_12._tf:Find("blur_panel/adapt/top/back_btn")

	local var0_12 = arg0_12._tf:Find("pages")

	arg0_12.pages = {
		SettingsOtherPage.New(var0_12, arg0_12.event, arg0_12.contextData),
		SettingsOptionPage.New(var0_12, arg0_12.event, arg0_12.contextData),
		SettingsBattlePage.New(var0_12, arg0_12.event, arg0_12.contextData),
		SettingsResPage.New(var0_12, arg0_12.event, arg0_12.contextData)
	}
	arg0_12.toggles = {
		arg0_12._tf:Find("blur_panel/adapt/left_length/other"),
		arg0_12._tf:Find("blur_panel/adapt/left_length/options"),
		arg0_12._tf:Find("blur_panel/adapt/left_length/battle_ui"),
		arg0_12._tf:Find("blur_panel/adapt/left_length/resources")
	}

	setActive(arg0_12.toggles[5], false)

	arg0_12.otherTip = arg0_12.toggles[1]:Find("tip")
	arg0_12.logoutBtn = arg0_12._tf:Find("blur_panel/adapt/left_length/logout")
	arg0_12.helpBtn = arg0_12._tf:Find("blur_panel/adapt/left_length/help_us")
	arg0_12.descWindow = SettingsMsgBosPage.New(arg0_12._tf, arg0_12.event)

	setActive(arg0_12._tf:Find("blur_panel/adapt/left_length/threeD"), false)
end

function var0_0.didEnter(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.logoutBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("main_settingsScene_quest_exist"),
			onYes = function()
				arg0_13:emit(NewSettingsMediator.ON_LOGOUT)
			end
		})
	end, SFX_PANEL)

	if PLATFORM_CODE == PLATFORM_KR then
		setActive(arg0_13.helpBtn, true)
		onButton(arg0_13, arg0_13.helpBtn, function()
			pg.SdkMgr.GetInstance():BugReport()
		end, SFX_CANCEL)
		arg0_13.helpBtn:SetAsFirstSibling()
	end

	for iter0_13, iter1_13 in ipairs(arg0_13.toggles) do
		onToggle(arg0_13, iter1_13, function(arg0_18)
			if arg0_18 then
				arg0_13:SwitchPage(iter0_13)
			end
		end, SFX_PANEL)
	end

	setActive(arg0_13.otherTip, PlayerPrefs.GetInt("firstIntoOtherPanel", 0) == 0)
	arg0_13:EnterDefaultPage()
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

	if isa(var0_20, Settings3DPage) then
		arg0_20.hasShow3d = true
	end

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
	if arg0_24.hasShow3d then
		GraphicSettingConst.SettingQuality()
	end

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
