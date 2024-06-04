local var0 = class("WSAtlasRight", import("...BaseEntity"))

var0.Fields = {
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

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.wsWorldInfo:Dispose()
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtBg = var0:Find("bg")
	arg0.rtNameBg = var0:Find("name_bg")
	arg0.rtDisplayIcon = var0:Find("line/display_icon")
	arg0.rtDisplayPanel = var0:Find("line/display_panel")
	arg0.rtWorldInfo = arg0.rtDisplayPanel:Find("world_info")
	arg0.btnSettings = arg0.rtDisplayPanel:Find("btns/settings_btn")
	arg0.btnSwitch = arg0.rtDisplayPanel:Find("btns/switch_btn")

	setText(arg0.rtWorldInfo:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0.rtWorldInfo:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0.rtWorldInfo:Find("explore/pressing/Text"), i18n("world_pressing"))

	arg0.wsWorldInfo = WSWorldInfo.New()
	arg0.wsWorldInfo.transform = arg0.rtWorldInfo

	arg0.wsWorldInfo:Setup()
	setActive(arg0.rtWorldInfo, nowWorld():IsSystemOpen(WorldConst.SystemWorldInfo))
	setText(arg0.rtDisplayIcon:Find("name"), i18n("world_map_title_tips"))
	onButton(arg0, arg0.rtDisplayIcon, function()
		arg0.isDisplay = not arg0.isDisplay

		arg0:Collapse()
	end, SFX_PANEL)

	arg0.isDisplay = true

	arg0:Collapse()
end

function var0.Collapse(arg0)
	arg0.rtDisplayIcon:Find("icon").localScale = arg0.isDisplay and Vector3.one or Vector3(-1, 1, 1)

	setActive(arg0.rtDisplayPanel, arg0.isDisplay)
	setActive(arg0.rtBg, arg0.isDisplay)
	setActive(arg0.rtNameBg, not arg0.isDisplay)
end

function var0.SetOverSize(arg0, arg1)
	arg0.rtBg.offsetMax = Vector2(-arg1, arg0.rtBg.offsetMax.y)
	arg0.rtNameBg.offsetMax = Vector2(-arg1, arg0.rtNameBg.offsetMax.y)
end

return var0
