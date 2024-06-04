local var0 = class("BackYardShipAddExpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(DormProxy):getBackYardShips()
	local var2 = getProxy(BayProxy)
	local var3 = {}
	local var4 = {}

	for iter0, iter1 in pairs(var1) do
		if iter1.state == Ship.STATE_TRAIN then
			local var5 = var2:getShipById(iter1.id)
			local var6 = Clone(var5)

			if var5.level ~= var5:getMaxLevel() then
				var5:addExp(var0)
				var2:updateShip(var5)
				arg0:sendNotification(GAME.BACKYARD_SHIP_EXP_ADDED, {
					id = var5.id,
					exp = var0
				})
			end

			var3[var5.id] = var5
			var4[var5.id] = var6
		end
	end

	arg0:sendNotification(DormProxy.SHIPS_EXP_ADDED, {
		oldShips = var4,
		newShips = var3
	})
end

return var0
