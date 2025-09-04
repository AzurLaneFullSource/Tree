local var0_0 = class("IslandTechAwardPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTechAwardUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTF = arg0_2._tf:Find("window/name_bg/Text")
	arg0_2.iconTF = arg0_2._tf:Find("window/icon_bg/Image")
	arg0_2.tipTF = arg0_2._tf:Find("window/tip")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5, arg1_5)
	local var0_5 = pg.island_technology_template[arg1_5]

	LoadImageSpriteAsync("island/IslandTechnology/" .. var0_5.tech_icon, arg0_5.iconTF, true)
	setText(arg0_5.nameTF, var0_5.tech_name)
	setText(arg0_5.tipTF, var0_5.complete_tips)
	arg0_5:BlurPanel()
end

function var0_0.OnHide(arg0_6)
	arg0_6:UnBlurPanel()
end

return var0_0
