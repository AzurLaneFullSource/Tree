local var0_0 = class("AddShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.type
	local var3_1 = var0_1.callBack
	local var4_1 = getProxy(DormProxy)
	local var5_1 = getProxy(BayProxy):getShipById(var1_1)
	local var6_1 = var4_1:getRawData()

	pg.ConnectionMgr.GetInstance():Send(19002, {
		ship_id = var1_1,
		type = var2_1
	}, 19003, function(arg0_2)
		if arg0_2.result == 0 then
			var6_1:AddShip(var5_1.id, var2_1)
			var4_1:updateDrom(var6_1, BackYardConst.DORM_UPDATE_TYPE_SHIP)
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
