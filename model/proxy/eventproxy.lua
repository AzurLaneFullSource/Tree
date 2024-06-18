local var0_0 = class("EventProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.eventList = {}

	arg0_1:on(13002, function(arg0_2)
		arg0_1.maxFleetNums = arg0_2.max_team

		arg0_1:updateInfo(arg0_2.collection_list)
	end)
	arg0_1:on(13011, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.collection) do
			local var0_3 = EventInfo.New(iter1_3)
			local var1_3, var2_3 = arg0_1:findInfoById(iter1_3.id)

			if var2_3 == -1 then
				table.insert(arg0_1.eventList, var0_3)

				arg0_1.eventForMsg = var0_3
			else
				arg0_1.eventList[var2_3] = var0_3
			end
		end

		arg0_1.virgin = true

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		arg0_1.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
	end)

	arg0_1.timer = Timer.New(function()
		arg0_1:updateTime()
	end, 1, -1)

	arg0_1.timer:Start()
end

function var0_0.remove(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.updateInfo(arg0_6, arg1_6)
	arg0_6.eventList = {}

	for iter0_6, iter1_6 in ipairs(arg1_6) do
		table.insert(arg0_6.eventList, EventInfo.New(iter1_6))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_6.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.updateNightInfo(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg1_7) do
		table.insert(arg0_7.eventList, EventInfo.New(iter1_7))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_7.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.getActiveShipIds(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.eventList) do
		if iter1_8.state ~= EventInfo.StateNone then
			for iter2_8, iter3_8 in ipairs(iter1_8.shipIds) do
				table.insert(var0_8, iter3_8)
			end
		end
	end

	return var0_8
end

function var0_0.findInfoById(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.eventList) do
		if iter1_9.id == arg1_9 then
			return iter1_9, iter0_9
		end
	end

	return nil, -1
end

function var0_0.countByState(arg0_10, arg1_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in ipairs(arg0_10.eventList) do
		if iter1_10.state == arg1_10 then
			var0_10 = var0_10 + 1
		end
	end

	return var0_10
end

function var0_0.hasFinishState(arg0_11)
	if arg0_11:countByState(EventInfo.StateFinish) > 0 then
		return true
	end
end

function var0_0.countBusyFleetNums(arg0_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in ipairs(arg0_12.eventList) do
		if not iter1_12:IsActivityType() and iter1_12.state ~= EventInfo.StateNone then
			var0_12 = var0_12 + 1
		end
	end

	return var0_12
end

function var0_0.updateTime(arg0_13)
	local var0_13 = false

	for iter0_13, iter1_13 in pairs(arg0_13.eventList) do
		if iter1_13:updateTime() then
			var0_13 = true
		end
	end

	if var0_13 then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		arg0_13:sendNotification(GAME.EVENT_LIST_UPDATE)
	end
end

function var0_0.getEventList(arg0_14)
	return Clone(arg0_14.eventList)
end

function var0_0.getActiveEvents(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.eventList) do
		if iter1_15.finishTime >= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0_15, iter1_15)
		end
	end

	return var0_15
end

function var0_0.fillRecommendShip(arg0_16, arg1_16)
	local var0_16 = getProxy(BayProxy):getDelegationRecommendShips(arg1_16)

	for iter0_16, iter1_16 in ipairs(var0_16) do
		table.insert(arg1_16.shipIds, iter1_16)
	end
end

function var0_0.fillRecommendShipLV1(arg0_17, arg1_17)
	local var0_17 = getProxy(BayProxy):getDelegationRecommendShipsLV1(arg1_17)

	for iter0_17, iter1_17 in ipairs(var0_17) do
		table.insert(arg1_17.shipIds, iter1_17)
	end
end

function var0_0.checkNightEvent(arg0_18)
	local var0_18 = pg.TimeMgr.GetInstance():GetServerHour()

	return (var0_18 >= pg.gameset.night_collection_begin.key_value and var0_18 < 24 or var0_18 >= 0 and var0_18 < pg.gameset.night_collection_end.key_value) and not _.any(arg0_18.eventList, function(arg0_19)
		local var0_19 = arg0_19:GetCountDownTime()

		return arg0_19.template.type == EventConst.EVENT_TYPE_NIGHT and (not var0_19 or var0_19 > 0)
	end)
end

function var0_0.AddActivityEvents(arg0_20, arg1_20, arg2_20)
	for iter0_20 = #arg0_20.eventList, 1, -1 do
		local var0_20 = arg0_20.eventList[iter0_20]

		if var0_20:IsActivityType() and var0_20:BelongActivity(arg2_20) then
			table.remove(arg0_20.eventList, iter0_20)
		end
	end

	for iter1_20, iter2_20 in ipairs(arg1_20) do
		print("add collection-----------", iter2_20.id)
		table.insert(arg0_20.eventList, iter2_20)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
end

function var0_0.AddActivityEvent(arg0_21, arg1_21)
	print("zero add collection-----------", arg1_21.id)
	table.insert(arg0_21.eventList, arg1_21)
end

function var0_0.CanJoinEvent(arg0_22, arg1_22)
	if not arg1_22:reachNum() then
		return false, i18n("event_minimus_ship_numbers", arg1_22.template.ship_num)
	end

	if not arg1_22:reachLevel() then
		return false, i18n("event_level_unreached")
	end

	if not arg1_22:reachTypes() then
		return false, i18n("event_type_unreached")
	end

	if not arg1_22:IsActivityType() and arg0_22.busyFleetNums >= arg0_22.maxFleetNums then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var0_22 = arg1_22:GetCountDownTime()

	if var0_22 and var0_22 < 0 then
		return false, i18n("event_over_time_expired")
	end

	local var1_22 = getProxy(PlayerProxy):getData()

	if arg1_22:getOilConsume() > var1_22.oil then
		local var2_22

		if not ItemTipPanel.ShowOilBuyTip(arg1_22:getOilConsume()) then
			var2_22 = i18n("common_no_oil")
		end

		return false, var2_22
	end

	local var3_22 = pg.collection_template[arg1_22.id]

	if var3_22 then
		local var4_22 = var3_22.drop_oil_max or 0

		if var1_22:OilMax(var4_22) then
			return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end

		local var5_22 = var3_22.drop_gold_max or 0

		if var1_22:GoldMax(var5_22) then
			return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end
	end

	return true
end

function var0_0.CanFinishEvent(arg0_23, arg1_23)
	local var0_23 = arg1_23.template

	if not var0_23 then
		return false
	end

	local var1_23 = getProxy(PlayerProxy):getData()
	local var2_23 = var0_23.drop_oil_max or 0

	if var1_23:OilMax(var2_23) then
		return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_event")
	end

	local var3_23 = var0_23.drop_gold_max or 0

	if var1_23:GoldMax(var3_23) then
		return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_event")
	end

	return true
end

function var0_0.GetEventByActivityId(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.eventList) do
		if iter1_24:BelongActivity(arg1_24) then
			return iter1_24, iter0_24
		end
	end
end

function var0_0.GetEventListForCommossionInfo(arg0_25)
	local var0_25 = arg0_25:getEventList()
	local var1_25 = 0
	local var2_25 = 0
	local var3_25 = 0
	local var4_25 = 0
	local var5_25 = 0
	local var6_25 = 0
	local var7_25 = {}

	_.each(var0_25, function(arg0_26)
		if arg0_26:IsActivityType() then
			if arg0_26.state == EventInfo.StateNone then
				var6_25 = var6_25 + 1
			elseif arg0_26.state == EventInfo.StateActive then
				var5_25 = var5_25 + 1
			elseif arg0_26.state == EventInfo.StateFinish then
				var4_25 = var4_25 + 1
			end
		elseif arg0_26.state == EventInfo.StateNone then
			-- block empty
		elseif arg0_26.state == EventInfo.StateActive then
			var2_25 = var2_25 + 1

			table.insert(var7_25, arg0_26)
		elseif arg0_26.state == EventInfo.StateFinish then
			var1_25 = var1_25 + 1

			table.insert(var7_25, arg0_26)
		end
	end)

	local var8_25 = var1_25 + var4_25
	local var9_25 = var2_25 + var5_25
	local var10_25 = arg0_25.maxFleetNums - (var1_25 + var2_25) + var6_25

	return var7_25, var8_25, var9_25, var10_25
end

return var0_0
