local var0_0 = class("AgoraReloadingView", import("Mod.Island.Core.View.IslandASynLoadSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraReloadingUI"
end

function var0_0.FirstFlush(arg0_2)
	setText(arg0_2._tf:Find("label/Text"), i18n("island_agora_working"))
end

return var0_0
