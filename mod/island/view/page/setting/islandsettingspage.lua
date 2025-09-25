local var0_0 = class("IslandSettingsPage", import("...base.IslandBasePage"))

var0_0.SELECTCUSTOMGRAPHICSETTING = "IslandSettingsPage:SelectCustomGraphicSetting"
var0_0.SELECTGRAPHICSETTINGLEVEL = "IslandSettingsPage:SelectGraphicSettinglevel"

function var0_0.getUIName(arg0_1)
	return "IslandNewSettingsUI"
end

function var0_0.AddListeners(arg0_2)
	arg0_2:AddListener(var0_0.SELECTCUSTOMGRAPHICSETTING, arg0_2.OnSelectCustomGraphicSetting)
	arg0_2:AddListener(var0_0.SELECTGRAPHICSETTINGLEVEL, arg0_2.OnSelectGraphicSettingLevel)
	arg0_2:AddListener(GAME.ISLAND_SETTING_FLAG_DONE, arg0_2.OnSettingFlagDone)
end

function var0_0.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(var0_0.SELECTCUSTOMGRAPHICSETTING, arg0_3.OnSelectCustomGraphicSetting)
	arg0_3:RemoveListener(var0_0.SELECTGRAPHICSETTINGLEVEL, arg0_3.OnSelectGraphicSettingLevel)
	arg0_3:RemoveListener(GAME.ISLAND_SETTING_FLAG_DONE, arg0_3.OnSettingFlagDone)
end

function var0_0.OnSelectGraphicSettingLevel(arg0_4)
	arg0_4:emit(IslandSettingsOtherGraphicsPanle.EVT_UPDTAE)
end

function var0_0.OnSelectCustomGraphicSetting(arg0_5)
	arg0_5:emit(IslandSettingsGraphicsPanle.EVT_UPDTAE)
end

function var0_0.OnSettingFlagDone(arg0_6)
	local var0_6 = arg0_6:GetPage(IslandSettingsCommonPage)

	if var0_6 and var0_6:GetLoaded() then
		var0_6:Update()
	end
end

function var0_0.GetPage(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.pages) do
		if isa(iter1_7, arg1_7) then
			return iter1_7
		end
	end
end

function var0_0.OnLoaded(arg0_8)
	arg0_8.backBtn = arg0_8:findTF("top/closeBtn")

	local var0_8 = arg0_8:findTF("pages")

	arg0_8.pages = {
		IslandSettings3DPage.New(var0_8, arg0_8.event, {}),
		IslandSettingsOperationPage.New(var0_8, arg0_8.event),
		IslandSettingsCommonPage.New(var0_8, arg0_8.event, arg0_8.contextData)
	}
	arg0_8.toggles = {
		arg0_8:findTF("adapt/left_length/imageQuality"),
		arg0_8:findTF("adapt/left_length/operation"),
		arg0_8:findTF("adapt/left_length/common")
	}

	local function var1_8(arg0_9, arg1_9)
		setText(arg0_9:Find("selected/name"), arg1_9)
		setText(arg0_9:Find("name"), arg1_9)
	end

	var1_8(arg0_8:findTF("adapt/left_length/imageQuality"), i18n("grapihcs3d_setting_3Dquality"))
	var1_8(arg0_8:findTF("adapt/left_length/operation"), i18n("grapihcs3d_setting_control"))
	var1_8(arg0_8:findTF("adapt/left_length/common"), i18n("grapihcs3d_setting_general"))
	setText(arg0_8:findTF("top/title/Text"), i18n("island_settings"))
	setText(arg0_8:findTF("top/title/Text/en"), i18n("island_settings_en"))
end

function var0_0.OnShow(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:Hide()
	end, SFX_CANCEL)

	for iter0_10, iter1_10 in ipairs(arg0_10.toggles) do
		onToggle(arg0_10, iter1_10, function(arg0_12)
			if arg0_12 then
				arg0_10:SwitchPage(iter0_10)
			end
		end, SFX_PANEL)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
	arg0_10:EnterDefaultPage()
end

function var0_0.EnterDefaultPage(arg0_13)
	triggerToggle(arg0_13.toggles[1], true)
end

function var0_0.SwitchPage(arg0_14, arg1_14)
	local var0_14 = arg0_14.pages[arg1_14]

	if arg0_14.page and arg0_14.page ~= var0_14 and arg0_14.page:GetLoaded() then
		arg0_14.page:Hide()
	end

	var0_14:ExecuteAction("Show")

	arg0_14.page = var0_14

	if isa(var0_14, IslandSettings3DPage) then
		arg0_14.hasShow3d = true
	end

	if isa(var0_14, IslandSettingsOperationPage) then
		arg0_14.hasShowOP = true
	end
end

function var0_0.GetPage(arg0_15, arg1_15)
	if not arg0_15.pages then
		return nil
	end

	return _.detect(arg0_15.pages, function(arg0_16)
		return isa(arg0_16, arg1_15)
	end)
end

function var0_0.OnHide(arg0_17)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17._tf)

	if arg0_17.hasShow3d then
		GraphicSettingConst.SettingQuality(true)
	end

	if arg0_17.hasShowOP then
		arg0_17:emitCore(ISLAND_EVT.UPDATE_CUSTOM_OP_POSITON)
	end

	local var0_17 = arg0_17:GetPage(IslandSettingsCommonPage)

	if var0_17 and var0_17:GetLoaded() then
		var0_17:Save()
	end
end

function var0_0.OnDestroy(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.pages) do
		iter1_18:Destroy()
	end

	arg0_18.page = nil
	arg0_18.pages = nil
end

return var0_0
