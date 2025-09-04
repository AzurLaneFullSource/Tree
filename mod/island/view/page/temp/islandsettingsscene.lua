local var0_0 = class("IslandSettingsScene", import("view.Setting.NewSettingsScene"))

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
	arg0_12.backBtn = arg0_12:findTF("blur_panel/adapt/top/back_btn")

	local var0_12 = arg0_12:findTF("pages")

	arg0_12.pages = {
		Settings3DPage.New(var0_12, arg0_12.event, arg0_12.contextData)
	}
	arg0_12.toggles = {
		arg0_12:findTF("blur_panel/adapt/left_length/other")
	}

	setActive(arg0_12:findTF("blur_panel/adapt/left_length/other"), false)
	setActive(arg0_12:findTF("blur_panel/adapt/left_length/options"), false)
	setActive(arg0_12:findTF("blur_panel/adapt/left_length/battle_ui"), false)
	setActive(arg0_12:findTF("blur_panel/adapt/left_length/resources"), false)
	setActive(arg0_12:findTF("blur_panel/adapt/left_length/threeD"), false)

	arg0_12.logoutBtn = arg0_12:findTF("blur_panel/adapt/left_length/logout")

	setActive(arg0_12.logoutBtn, false)

	arg0_12.helpBtn = arg0_12:findTF("blur_panel/adapt/left_length/help_us")
	arg0_12.descWindow = SettingsMsgBosPage.New(arg0_12._tf, arg0_12.event)
end

function var0_0.didEnter(arg0_13)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:closeView()
	end, SFX_CANCEL)

	if PLATFORM_CODE == PLATFORM_US then
		setActive(arg0_13.helpBtn, true)
		onButton(arg0_13, arg0_13.helpBtn, function()
			pg.SdkMgr.GetInstance():OpenYostarHelp()
		end, SFX_PANEL)
	elseif PLATFORM_CODE == PLATFORM_KR then
		setActive(arg0_13.helpBtn, true)
		onButton(arg0_13, arg0_13.helpBtn, function()
			pg.SdkMgr.GetInstance():BugReport()
		end, SFX_CANCEL)
		arg0_13.helpBtn:SetAsFirstSibling()
	end

	for iter0_13, iter1_13 in ipairs(arg0_13.toggles) do
		onToggle(arg0_13, iter1_13, function(arg0_17)
			if arg0_17 then
				arg0_13:SwitchPage(iter0_13)
			end
		end, SFX_PANEL)
	end

	arg0_13:EnterDefaultPage()
	arg0_13:ExtraHandle()
end

function var0_0.ExtraHandle(arg0_18)
	setParent(arg0_18._tf, arg0_18.contextData.container)
	setActive(arg0_18._tf:Find("blur_panel/adapt/top/option"), false)
end

function var0_0.EnterDefaultPage(arg0_19)
	triggerToggle(arg0_19.toggles[1], true)
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

	arg0_23:closeView()
end

function var0_0.closeView(arg0_24)
	arg0_24.contextData.onClose()
	GraphicSettingConst.SettingQuality()
end

function var0_0.willExit(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.pages) do
		iter1_25:Destroy()
	end

	if arg0_25.descWindow then
		arg0_25.descWindow:Destroy()

		arg0_25.descWindow = nil
	end

	arg0_25.page = nil
	arg0_25.pages = nil
end

return var0_0
