local var0_0 = class("AddShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.type
	local var3_1 = var0_1.callBack
	local var4_1 = getProxy(DormProxy)
	local var5_1 = getProxy(BayProxy):getShipById(var1_1)
	local var6_1 = var4_1:getData()

	if table.contains(var6_1.shipIds, var1_1) then
		if var3_1 then
			var3_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19002, {
		ship_id = var1_1,
		type = var2_1
	}, 19003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)

			if var2_1 == 1 then
				var5_1.state_info_1 = pg.TimeMgr.GetInstance():GetServerTime()
				var5_1.state_info_2 = var5_1:getTotalExp()

				var5_1:updateState(Ship.STATE_TRAIN)

				if var6_1.next_timestamp == 0 then
					var6_1:restNextTime()
					var4_1:updateDrom(var6_1, BackYardConst.DORM_UPDATE_TYPE_SHIP)
				end
			elseif var2_1 == 2 then
				var5_1:updateState(Ship.STATE_REST)
			end

			var0_2:updateShip(var5_1)
			var4_1:addShip(var5_1.id)
			arg0_1:sendNotification(GAME.ADD_SHIP_DONE, {
				id = var1_1,
				type = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_addShip", arg0_2.result))
		end

		if var3_1 then
			var3_1()
		end
	end)
end

return var0_0
