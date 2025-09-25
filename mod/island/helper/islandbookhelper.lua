local var0_0 = class("IslandBookHelper")

function var0_0.OnAddNewShip(arg0_1)
	getProxy(IslandProxy):GetIsland():GetBookAgency():OnAddNewShip(arg0_1)
end

function var0_0.OnShipUpgradeOrBreakOut(arg0_2)
	getProxy(IslandProxy):GetIsland():GetBookAgency():OnShipUpgradeOrBreakOut(arg0_2)
end

function var0_0.OnNpcInteract(arg0_3)
	if not pg.island_unit_character[arg0_3] then
		return
	end

	local var0_3 = IslandIllustration.TYPES.NPC
	local var1_3 = getProxy(IslandProxy):GetIsland():GetBookAgency():GetIllustration(var0_3, arg0_3)

	if not var1_3 or var1_3:GetStatus() ~= IslandIllustration.STATUS.LOCK then
		return
	end

	pg.m02:sendNotification(GAME.ISLAND_UPDATE_ILLUSTRATION, {
		type = var0_3,
		linkId = arg0_3
	})
end

return var0_0
