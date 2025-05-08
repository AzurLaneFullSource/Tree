local var0_0 = class("IslandSeekGameResultView", import("Mod.Island.Core.View.IslandBaseSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandSeekGameUI"
end

function var0_0.FirstFlush(arg0_2)
	arg0_2:Hide()
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:GetView():RestartGame()
		arg0_2:Hide()
	end, SFX_PANEL)
end

return var0_0
