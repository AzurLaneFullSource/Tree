local var0 = class("RevertEquipmentCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(14010, {
		equip_id = var0
	}, 14011, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EquipmentProxy)
			local var1 = var0:getEquipmentById(var0)

			var0:removeEquipmentById(var1.id, 1)

			local var2 = var1:GetRootEquipment()

			var0:addEquipmentById(var2.id, var2.count)
			getProxy(BagProxy):removeItemById(Item.REVERT_EQUIPMENT_ID, 1)

			local var3 = var1:getRevertAwards()

			for iter0, iter1 in pairs(var3) do
				arg0:sendNotification(GAME.ADD_ITEM, iter1)
			end

			arg0:sendNotification(GAME.REVERT_EQUIPMENT_DONE, {
				awards = var3
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_destroyEquipments", arg0.result))
		end
	end)
end

return var0
