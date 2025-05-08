local var0_0 = class("IslandShipOrderOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.op
	local var2_1 = var0_1.slotId
	local var3_1 = var0_1.index
	local var4_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipOrderSlot(var2_1)

	if not var4_1 then
		return
	end

	if var1_1 == IslandShipOrder.OP_TYPE_UNLOCK then
		arg0_1:HandleUnlock(var4_1)
	elseif var1_1 == IslandShipOrder.OP_TYPE_GET_AWARD then
		arg0_1:HandleGetAward(var4_1)
	elseif var1_1 == IslandShipOrder.OP_TYPE_LOADUP then
		arg0_1:HandleLoadUp(var4_1, var3_1)
	end
end

function var0_0.HandleUnlock(arg0_2, arg1_2)
	if not arg1_2:IsLock() then
		return
	end

	if not arg1_2:CanUnlock() then
		return
	end

	local var0_2 = arg1_2:GetUnlockGold()
	local var1_2 = Drop.New(var0_2)

	if var1_2:getOwnedCount() < var1_2.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21408, {
		type = IslandShipOrder.OP_TYPE_UNLOCK,
		ship_slot_id = arg1_2.id
	}, 21409, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = IslandDropHelper.AddItems(arg0_3)

			arg0_2:sendNotification(GAME.CONSUME_ITEM, var1_2)
			arg1_2:Init(arg0_3.slot, true)
			arg0_2:sendNotification(GAME.ISLAND_SHIP_ORDER_OP_DONE, {
				op = IslandShipOrder.OP_TYPE_UNLOCK,
				dropData = var0_3,
				id = arg1_2.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

function var0_0.HandleGetAward(arg0_4, arg1_4)
	if not arg1_4:IsFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21408, {
		type = IslandShipOrder.OP_TYPE_GET_AWARD,
		ship_slot_id = arg1_4.id
	}, 21409, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5 = IslandDropHelper.AddItems(arg0_5)

			arg1_4:Init(arg0_5.slot)
			arg0_4:sendNotification(GAME.ISLAND_SHIP_ORDER_OP_DONE, {
				op = IslandShipOrder.OP_TYPE_GET_AWARD,
				dropData = var0_5,
				id = arg1_4.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
		end
	end)
end

function var0_0.HandleLoadUp(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetOrder()
	local var1_6 = var0_6:GetComsume(arg2_6)
	local var2_6 = Drop.New(var1_6)
	local var3_6 = var0_6:GetConsumeAwards(arg2_6)

	if var2_6:getOwnedCount() < var2_6.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var4_6 = var3_6[2]

	pg.ConnectionMgr.GetInstance():Send(21416, {
		ship_slot_id = arg1_6.id,
		item_id = var1_6.id
	}, 21417, function(arg0_7)
		if arg0_7.result == 0 then
			local var0_7 = IslandDropHelper.AddItems(arg0_7)

			table.insert(var0_7.awards, Drop.New(var4_6))
			getProxy(IslandProxy):GetIsland():AddExp(var4_6.count)
			arg0_6:sendNotification(GAME.CONSUME_ITEM, var2_6)
			var0_6:MarkLoadUp(arg2_6)

			local var1_7 = var0_6:IsLoadUpAll()

			if var1_7 and arg0_7.get_time then
				arg1_6:Submit(arg0_7.get_time)
			end

			arg0_6:sendNotification(GAME.ISLAND_SHIP_ORDER_OP_DONE, {
				isLoadUpAll = var1_7,
				op = IslandShipOrder.OP_TYPE_LOADUP,
				dropData = var0_7,
				id = arg1_6.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.result)
		end
	end)
end

return var0_0
