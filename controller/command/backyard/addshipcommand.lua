local var0 = class("AddShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.type
	local var3 = var0.callBack
	local var4 = getProxy(DormProxy)
	local var5 = getProxy(BayProxy):getShipById(var1)
	local var6 = var4:getData()

	if table.contains(var6.shipIds, var1) then
		if var3 then
			var3()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19002, {
		ship_id = var1,
		type = var2
	}, 19003, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)

			if var2 == 1 then
				var5.state_info_1 = pg.TimeMgr.GetInstance():GetServerTime()
				var5.state_info_2 = var5:getTotalExp()

				var5:updateState(Ship.STATE_TRAIN)

				if var6.next_timestamp == 0 then
					var6:restNextTime()
					var4:updateDrom(var6, BackYardConst.DORM_UPDATE_TYPE_SHIP)
				end
			elseif var2 == 2 then
				var5:updateState(Ship.STATE_REST)
			end

			var0:updateShip(var5)
			var4:addShip(var5.id)
			arg0:sendNotification(GAME.ADD_SHIP_DONE, {
				id = var1,
				type = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_addShip", arg0.result))
		end

		if var3 then
			var3()
		end
	end)
end

return var0
