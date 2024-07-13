local var0_0 = class("BackYardShipAddExpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(DormProxy):getBackYardShips()
	local var2_1 = getProxy(BayProxy)
	local var3_1 = {}
	local var4_1 = {}

	for iter0_1, iter1_1 in pairs(var1_1) do
		if iter1_1.state == Ship.STATE_TRAIN then
			local var5_1 = var2_1:getShipById(iter1_1.id)
			local var6_1 = Clone(var5_1)

			if var5_1.level ~= var5_1:getMaxLevel() then
				var5_1:addExp(var0_1)
				var2_1:updateShip(var5_1)
				arg0_1:sendNotification(GAME.BACKYARD_SHIP_EXP_ADDED, {
					id = var5_1.id,
					exp = var0_1
				})
			end

			var3_1[var5_1.id] = var5_1
			var4_1[var5_1.id] = var6_1
		end
	end

	arg0_1:sendNotification(DormProxy.SHIPS_EXP_ADDED, {
		oldShips = var4_1,
		newShips = var3_1
	})
end

return var0_0
