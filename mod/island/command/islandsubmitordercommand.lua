local var0_0 = class("IslandSubmitOrderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().slotId
	local var1_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(var0_1)

	if not var1_1:CanSubmit() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if var1_1:GetOrder():IsUrgency() then
		arg0_1:HandleUrgencyOrder(var1_1)
	elseif var1_1:GetOrder():IsFirm() then
		arg0_1:HandleFirmOrder(var1_1)
	else
		arg0_1:HandleCommonOrder(var1_1)
	end
end

function var0_0.HandleUrgencyOrder(arg0_2, arg1_2)
	local var0_2 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	pg.ConnectionMgr.GetInstance():Send(21405, {
		slot_id = arg1_2.id
	}, 21406, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = arg0_2:HandleDrops(arg1_2)

			arg0_2:HandleConsume(arg1_2)
			var0_2:RemoveSlot(arg1_2.id)
			var0_2:IncUrgencyFinishCnt()
			var0_2:RecordNextCanSubmitTime()
			var0_2:AddExp(arg1_2:GetOrder():GetExpValue())
			arg0_2:sendNotification(GAME.ISLAND_SUBMIT_ORDER_DONE, {
				dropData = var0_3,
				slotId = arg1_2.id
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandSubmitOrder(IslandOrder.TYPE_URGENCY, arg1_2.id))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

function var0_0.HandleCommonOrder(arg0_4, arg1_4)
	local var0_4 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	pg.ConnectionMgr.GetInstance():Send(21401, {
		slot_id = arg1_4.id
	}, 21402, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5 = arg0_4:HandleDrops(arg1_4)

			arg0_4:HandleConsume(arg1_4)

			if arg0_5.slot then
				arg1_4:Flush(arg0_5.slot)
			else
				var0_4:RemoveSlot(arg1_4.id)
			end

			var0_4:IncFinishCnt()
			var0_4:RecordNextCanSubmitTime()
			var0_4:AddExp(arg1_4:GetOrder():GetExpValue())
			arg0_4:sendNotification(GAME.ISLAND_SUBMIT_ORDER_DONE, {
				dropData = var0_5,
				slotId = arg1_4.id
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandSubmitOrder(IslandOrder.TYPE_NORMAL, arg1_4.id))
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.ORDER_DAILY)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
		end
	end)
end

function var0_0.HandleFirmOrder(arg0_6, arg1_6)
	local var0_6 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	pg.ConnectionMgr.GetInstance():Send(21414, {
		order_id = arg1_6.id
	}, 21415, function(arg0_7)
		if arg0_7.result == 0 then
			local var0_7 = arg0_6:HandleDrops(arg1_6)

			arg0_6:HandleConsume(arg1_6)
			arg0_6:HandleFirmActivityOrder(arg1_6)
			var0_6:RemoveSlot(arg1_6.id)
			var0_6:RecordNextCanSubmitTime()

			local var1_7 = arg1_6:GetOrder()

			if not isa(var1_7, IslandFirmActivityOrder) then
				var0_6:AddExp(var1_7:GetExpValue())
			end

			arg0_6:sendNotification(GAME.ISLAND_SUBMIT_ORDER_DONE, {
				dropData = var0_7,
				slotId = arg1_6.id
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandSubmitOrder(IslandOrder.TYPE_FORM, arg1_6.id))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.result)
		end
	end)
end

function var0_0.HandleDrops(arg0_8, arg1_8)
	local var0_8, var1_8 = arg1_8:GetOrder():GetAwardItemAndExp()

	return (IslandDropHelper.AddItems({
		drop_list = var0_8
	}, var1_8))
end

function var0_0.HandleConsume(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetOrder():GetConsume()

	for iter0_9, iter1_9 in ipairs(var0_9) do
		arg0_9:sendNotification(GAME.CONSUME_ITEM, iter1_9)
	end
end

function var0_0.HandleFirmActivityOrder(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetOrder()

	if isa(var0_10, IslandFirmActivityOrder) then
		if var0_10:getConfig("next_order") == 0 then
			getProxy(IslandProxy):GetIsland():GetOrderAgency():AddFinishedActGroupId(var0_10:GetActivityId(), var0_10:GetGroupId())
		end

		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.ACTIVITY_ORDER)
	end
end

return var0_0
