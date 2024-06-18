local var0_0 = class("NewSettingsScene", import("..base.BaseUI"))

var0_0.PAGE_OTHER = 1
var0_0.PAGE_OPTION = 2
var0_0.PAGE_BATTLE = 3
var0_0.PAGE_RES = 4

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

function var0_0.GetPage(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.pages) do
		if isa(iter1_8, arg1_8) then
			return iter1_8
		end
	end
end

function var0_0.init(arg0_9)
	arg0_9.backBtn = arg0_9:findTF("blur_panel/adapt/top/back_btn")

	local var0_9 = arg0_9:findTF("pages")

	arg0_9.pages = {
		SettingsOtherPage.New(var0_9, arg0_9.event, arg0_9.contextData),
		SettingsOptionPage.New(var0_9, arg0_9.event, arg0_9.contextData),
		SettingsBattlePage.New(var0_9, arg0_9.event, arg0_9.contextData),
		SettingsResPage.New(var0_9, arg0_9.event, arg0_9.contextData)
	}
	arg0_9.toggles = {
		arg0_9:findTF("blur_panel/adapt/left_length/other"),
		arg0_9:findTF("blur_panel/adapt/left_length/options"),
		arg0_9:findTF("blur_panel/adapt/left_length/battle_ui"),
		arg0_9:findTF("blur_panel/adapt/left_length/resources")
	}
	arg0_9.otherTip = arg0_9.toggles[1]:Find("tip")
	arg0_9.logoutBtn = arg0_9:findTF("blur_panel/adapt/left_length/logout")
	arg0_9.helpBtn = arg0_9:findTF("blur_panel/adapt/left_length/help_us")
	arg0_9.descWindow = SettingsMsgBosPage.New(arg0_9._tf, arg0_9.event)
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.logoutBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("main_settingsScene_quest_exist"),
			onYes = function()
				arg0_10:emit(NewSettingsMediator.ON_LOGOUT)
			end
		})
	end, SFX_PANEL)

	if PLATFORM_CODE == PLATFORM_US then
		setActive(arg0_10.helpBtn, true)
		onButton(arg0_10, arg0_10.helpBtn, function()
			pg.SdkMgr.GetInstance():OpenYostarHelp()
		end, SFX_PANEL)
	elseif PLATFORM_CODE == PLATFORM_KR then
		setActive(arg0_10.helpBtn, true)
		onButton(arg0_10, arg0_10.helpBtn, function()
			pg.SdkMgr.GetInstance():BugReport()
		end, SFX_CANCEL)
		arg0_10.helpBtn:SetAsFirstSibling()
	end

	for iter0_10, iter1_10 in ipairs(arg0_10.toggles) do
		onToggle(arg0_10, iter1_10, function(arg0_16)
			if arg0_16 then
				arg0_10:SwitchPage(iter0_10)
			end
		end, SFX_PANEL)
	end

	setActive(arg0_10.otherTip, PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0)
	arg0_10:EnterDefaultPage()
end

function var0_0.EnterDefaultPage(arg0_17)
	local var0_17
	local var1_17 = arg0_17.contextData.toggle

	if var1_17 and type(var1_17) == "string" then
		if var1_17 == "sound" or var1_17 == "res" then
			var0_17 = var0_0.PAGE_RES
		else
			var0_17 = table.indexof({
				"other",
				"options",
				"interface",
				"res"
			}, var1_17)
		end
	end

	local var2_17 = arg0_17.contextData.page or var0_17 or var0_0.PAGE_RES

	triggerToggle(arg0_17.toggles[var2_17], true)
end

function var0_0.SwitchPage(arg0_18, arg1_18)
	local var0_18 = arg0_18.pages[arg1_18]

	if arg0_18.page and arg0_18.page ~= var0_18 and arg0_18.page:GetLoaded() then
		arg0_18.page:Hide()
	end

	var0_18:ExecuteAction("Show")

	arg0_18.page = var0_18

	if isa(var0_18, SettingsOtherPage) and isActive(arg0_18.otherTip) then
		setActive(arg0_18.otherTip, false)
	end
end

function var0_0.OpenYostarAlertView(arg0_19)
	arg0_19.yostarAlertView = YostarAlertView.New(arg0_19._tf, arg0_19.event, {
		isDestroyOnClose = true,
		isLinkMode = true
	})

	arg0_19.yostarAlertView:Load()
	arg0_19.yostarAlertView:ActionInvoke("Show")
end

function var0_0.CloseYostarAlertView(arg0_20)
	if arg0_20.yostarAlertView and arg0_20.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0_20.yostarAlertView:Destroy()
	end
end

function var0_0.onBackPressed(arg0_21)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0_21 = GameObject.Find("OverlayCamera/Overlay/UIMain/DialogPanel")

	if isActive(var0_21) then
		triggerButton(var0_21.transform:Find("dialog/title/back"))

		return
	end

	arg0_21:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.pages) do
		iter1_22:Destroy()
	end

	if arg0_22.descWindow then
		arg0_22.descWindow:Destroy()

		arg0_22.descWindow = nil
	end

	arg0_22.page = nil
	arg0_22.pages = nil
end

return var0_0
