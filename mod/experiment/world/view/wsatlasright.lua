local var0_0 = class("WSAtlasRight", import("...BaseEntity"))

var0_0.Fields = {
	btnSettings = "userdata",
	btnSwitch = "userdata",
	rtDisplayIcon = "userdata",
	transform = "userdata",
	rtNameBg = "userdata",
	rtDisplayPanel = "userdata",
	isDisplay = "boolean",
	world = "table",
	rtMapInfo = "userdata",
	rtWorldInfo = "userdata",
	rtBg = "userdata",
	wsWorldInfo = "table"
}

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	arg0_2.wsWorldInfo:Dispose()
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.transform

	arg0_3.rtBg = var0_3:Find("bg")
	arg0_3.rtNameBg = var0_3:Find("name_bg")
	arg0_3.rtDisplayIcon = var0_3:Find("line/display_icon")
	arg0_3.rtDisplayPanel = var0_3:Find("line/display_panel")
	arg0_3.rtWorldInfo = arg0_3.rtDisplayPanel:Find("world_info")
	arg0_3.btnSettings = arg0_3.rtDisplayPanel:Find("btns/settings_btn")
	arg0_3.btnSwitch = arg0_3.rtDisplayPanel:Find("btns/switch_btn")

	setText(arg0_3.rtWorldInfo:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0_3.rtWorldInfo:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0_3.rtWorldInfo:Find("explore/pressing/Text"), i18n("world_pressing"))

	arg0_3.wsWorldInfo = WSWorldInfo.New()
	arg0_3.wsWorldInfo.transform = arg0_3.rtWorldInfo

	arg0_3.wsWorldInfo:Setup()
	setActive(arg0_3.rtWorldInfo, nowWorld():IsSystemOpen(WorldConst.SystemWorldInfo))
	setText(arg0_3.rtDisplayIcon:Find("name"), i18n("world_map_title_tips"))
	onButton(arg0_3, arg0_3.rtDisplayIcon, function()
		arg0_3.isDisplay = not arg0_3.isDisplay

		arg0_3:Collapse()
	end, SFX_PANEL)

	arg0_3.isDisplay = true

	arg0_3:Collapse()
end

function var0_0.Collapse(arg0_5)
	arg0_5.rtDisplayIcon:Find("icon").localScale = arg0_5.isDisplay and Vector3.one or Vector3(-1, 1, 1)

	setActive(arg0_5.rtDisplayPanel, arg0_5.isDisplay)
	setActive(arg0_5.rtBg, arg0_5.isDisplay)
	setActive(arg0_5.rtNameBg, not arg0_5.isDisplay)
end

function var0_0.SetOverSize(arg0_6, arg1_6)
	arg0_6.rtBg.offsetMax = Vector2(-arg1_6, arg0_6.rtBg.offsetMax.y)
	arg0_6.rtNameBg.offsetMax = Vector2(-arg1_6, arg0_6.rtNameBg.offsetMax.y)
end

return var0_0
