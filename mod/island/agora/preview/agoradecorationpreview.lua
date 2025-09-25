local var0_0 = class("AgoraDecorationPreview", import("Mod.Island.Core.View.IslandASynLoadSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraPreviewDecorationUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2.backBtn = arg0_2._tf:Find("top/back")

	onButton(arg0_2, arg0_2.backBtn, function()
		arg0_2:Op("GoBackLastExitPoint")
	end, SFX_CANCEL)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_agora_furniure_preview"))
end

function var0_0.Execute(arg0_4, arg1_4, ...)
	if not arg0_4[arg1_4] then
		return
	end

	var0_0.super.Execute(arg0_4, arg1_4, ...)
end

return var0_0
