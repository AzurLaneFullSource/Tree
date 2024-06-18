local var0_0 = class("RevertEquipmentCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(14010, {
		equip_id = var0_1
	}, 14011, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(EquipmentProxy)
			local var1_2 = var0_2:getEquipmentById(var0_1)

			var0_2:removeEquipmentById(var1_2.id, 1)

			local var2_2 = var1_2:GetRootEquipment()

			var0_2:addEquipmentById(var2_2.id, var2_2.count)
			getProxy(BagProxy):removeItemById(Item.REVERT_EQUIPMENT_ID, 1)

			local var3_2 = var1_2:getRevertAwards()

			for iter0_2, iter1_2 in pairs(var3_2) do
				arg0_1:sendNotification(GAME.ADD_ITEM, iter1_2)
			end

			arg0_1:sendNotification(GAME.REVERT_EQUIPMENT_DONE, {
				awards = var3_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_destroyEquipments", arg0_2.result))
		end
	end)
end

return var0_0
