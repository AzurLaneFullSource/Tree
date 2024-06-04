local var0 = class("NewSettingsScene", import("..base.BaseUI"))

var0.PAGE_OTHER = 1
var0.PAGE_OPTION = 2
var0.PAGE_BATTLE = 3
var0.PAGE_RES = 4

function var0.getUIName(arg0)
	return "NewSettingsUI"
end

function var0.OnShowDescWindow(arg0, arg1)
	arg0.descWindow:ExecuteAction("Show", arg1.desc, arg1.alignment)
end

function var0.OnClearExchangeCode(arg0)
	if arg0.pages and arg0.pages[1] and arg0.pages[1]:GetLoaded() then
		arg0.pages[1]:OnClearExchangeCode()
	end
end

function var0.OnShowTranscode(arg0, arg1)
	if arg0.pages and arg0.pages[1] and arg0.pages[1]:GetLoaded() then
		arg0.pages[1]:OnShowTranscode(arg1)
	end
end

function var0.OnCheckAllAccountState(arg0)
	if arg0.pages and arg0.pages[1] and arg0.pages[1]:GetLoaded() then
		arg0.pages[1]:OnCheckAllAccountState()
	end
end

function var0.OnSecondPwdStateChange(arg0)
	if arg0.pages and arg0.pages[1] and arg0.pages[1]:GetLoaded() then
		arg0.pages[1]:OnSecondPwdStateChange()
	end
end

function var0.OnRandomFlagShipModeUpdate(arg0)
	arg0:emit(SettingsRandomFlagShipAndSkinPanel.EVT_UPDTAE)
end

function var0.GetPage(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.pages) do
		if isa(iter1, arg1) then
			return iter1
		end
	end
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")

	local var0 = arg0:findTF("pages")

	arg0.pages = {
		SettingsOtherPage.New(var0, arg0.event, arg0.contextData),
		SettingsOptionPage.New(var0, arg0.event, arg0.contextData),
		SettingsBattlePage.New(var0, arg0.event, arg0.contextData),
		SettingsResPage.New(var0, arg0.event, arg0.contextData)
	}
	arg0.toggles = {
		arg0:findTF("blur_panel/adapt/left_length/other"),
		arg0:findTF("blur_panel/adapt/left_length/options"),
		arg0:findTF("blur_panel/adapt/left_length/battle_ui"),
		arg0:findTF("blur_panel/adapt/left_length/resources")
	}
	arg0.otherTip = arg0.toggles[1]:Find("tip")
	arg0.logoutBtn = arg0:findTF("blur_panel/adapt/left_length/logout")
	arg0.helpBtn = arg0:findTF("blur_panel/adapt/left_length/help_us")
	arg0.descWindow = SettingsMsgBosPage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.logoutBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("main_settingsScene_quest_exist"),
			onYes = function()
				arg0:emit(NewSettingsMediator.ON_LOGOUT)
			end
		})
	end, SFX_PANEL)

	if PLATFORM_CODE == PLATFORM_US then
		setActive(arg0.helpBtn, true)
		onButton(arg0, arg0.helpBtn, function()
			pg.SdkMgr.GetInstance():OpenYostarHelp()
		end, SFX_PANEL)
	elseif PLATFORM_CODE == PLATFORM_KR then
		setActive(arg0.helpBtn, true)
		onButton(arg0, arg0.helpBtn, function()
			pg.SdkMgr.GetInstance():BugReport()
		end, SFX_CANCEL)
		arg0.helpBtn:SetAsFirstSibling()
	end

	for iter0, iter1 in ipairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:SwitchPage(iter0)
			end
		end, SFX_PANEL)
	end

	setActive(arg0.otherTip, PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0)
	arg0:EnterDefaultPage()
end

function var0.EnterDefaultPage(arg0)
	local var0
	local var1 = arg0.contextData.toggle

	if var1 and type(var1) == "string" then
		if var1 == "sound" or var1 == "res" then
			var0 = var0.PAGE_RES
		else
			var0 = table.indexof({
				"other",
				"options",
				"interface",
				"res"
			}, var1)
		end
	end

	local var2 = arg0.contextData.page or var0 or var0.PAGE_RES

	triggerToggle(arg0.toggles[var2], true)
end

function var0.SwitchPage(arg0, arg1)
	local var0 = arg0.pages[arg1]

	if arg0.page and arg0.page ~= var0 and arg0.page:GetLoaded() then
		arg0.page:Hide()
	end

	var0:ExecuteAction("Show")

	arg0.page = var0

	if isa(var0, SettingsOtherPage) and isActive(arg0.otherTip) then
		setActive(arg0.otherTip, false)
	end
end

function var0.OpenYostarAlertView(arg0)
	arg0.yostarAlertView = YostarAlertView.New(arg0._tf, arg0.event, {
		isDestroyOnClose = true,
		isLinkMode = true
	})

	arg0.yostarAlertView:Load()
	arg0.yostarAlertView:ActionInvoke("Show")
end

function var0.CloseYostarAlertView(arg0)
	if arg0.yostarAlertView and arg0.yostarAlertView:CheckState(BaseSubView.STATES.INITED) then
		arg0.yostarAlertView:Destroy()
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	local var0 = GameObject.Find("OverlayCamera/Overlay/UIMain/DialogPanel")

	if isActive(var0) then
		triggerButton(var0.transform:Find("dialog/title/back"))

		return
	end

	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()
	end

	if arg0.descWindow then
		arg0.descWindow:Destroy()

		arg0.descWindow = nil
	end

	arg0.page = nil
	arg0.pages = nil
end

return var0
