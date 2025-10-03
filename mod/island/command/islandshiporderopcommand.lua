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
	elseif var1_1 == IslandShipOrder.OP_TYPE_LOADUP_ALL then
		arg0_1:HandleLoadUpAll(var4_1)
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

function var0_0.HandleLoadUpAll(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetOrder()
	local var1_6 = 0
	local var2_6 = {}
	local var3_6 = {}
	local var4_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6.consumeList) do
		local var5_6 = var0_6:GetComsume(iter0_6)
		local var6_6 = Drop.New(var5_6)
		local var7_6 = var0_6:GetConsumeAwards(iter0_6)

		if not var0_6:ItemIsSubmited(iter0_6) and var6_6:getOwnedCount() >= var6_6.count then
			var1_6 = var1_6 + var7_6[2].count

			table.insert(var2_6, var5_6.id)
			table.insert(var3_6, iter0_6)
			table.insert(var4_6, var6_6)
		end
	end

	if #var3_6 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21416, {
		ship_slot_id = arg1_6.id,
		item_id = var2_6
	}, 21417, function(arg0_7)
		if arg0_7.result == 0 then
			local var0_7 = IslandDropHelper.AddItems(arg0_7, var1_6)

			for iter0_7, iter1_7 in ipairs(var4_6) do
				arg0_6:sendNotification(GAME.CONSUME_ITEM, iter1_7)
			end

			for iter2_7, iter3_7 in ipairs(var3_6) do
				var0_6:MarkLoadUp(iter3_7)
			end

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

function var0_0.HandleLoadUp(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:GetOrder()
	local var1_8 = var0_8:GetComsume(arg2_8)
	local var2_8 = Drop.New(var1_8)
	local var3_8 = var0_8:GetConsumeAwards(arg2_8)

	if var2_8:getOwnedCount() < var2_8.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var4_8 = var3_8[2]

	pg.ConnectionMgr.GetInstance():Send(21416, {
		ship_slot_id = arg1_8.id,
		item_id = {
			var1_8.id
		}
	}, 21417, function(arg0_9)
		if arg0_9.result == 0 then
			local var0_9 = IslandDropHelper.AddItems(arg0_9, var4_8.count)

			arg0_8:sendNotification(GAME.CONSUME_ITEM, var2_8)
			var0_8:MarkLoadUp(arg2_8)

			local var1_9 = var0_8:IsLoadUpAll()

			if var1_9 and arg0_9.get_time then
				arg1_8:Submit(arg0_9.get_time)
			end

			arg0_8:sendNotification(GAME.ISLAND_SHIP_ORDER_OP_DONE, {
				isLoadUpAll = var1_9,
				op = IslandShipOrder.OP_TYPE_LOADUP,
				dropData = var0_9,
				id = arg1_8.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_9.result] .. arg0_9.result)
		end
	end)
end

return var0_0
