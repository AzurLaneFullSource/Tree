local var0_0 = class("IslandVisitorHudPanel", import("Mod.Island.Core.View.IslandBaseHudPanel"))

function var0_0.GetUIName(arg0_1)
	return "IslandVisitorHud"
end

function var0_0.OnInit(arg0_2)
	arg0_2.nameTF = arg0_2._tf:Find("name")
	arg0_2.playerId = tonumber(arg0_2.param1)

	if not arg0_2.playerId then
		return
	end

	local var0_2 = getProxy(IslandProxy):GetIsland()
	local var1_2 = getProxy(IslandProxy):GetSharedIsland()

	arg0_2.name = (var0_2:GetVisitorAgency():GetPlayer(arg0_2.playerId) or var1_2:GetVisitorAgency():GetPlayer(arg0_2.playerId)):GetName()

	setText(arg0_2.nameTF, arg0_2.name)
end

return var0_0
