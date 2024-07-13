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
end

function var0_0.timeCall(arg0_4)
	return {
		[ProxyRegister.DayCall] = function(arg0_5)
			local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)

			if not var0_5 or var0_5:isEnd() then
				return
			end

			local var1_5, var2_5 = arg0_4:GetEventByActivityId(var0_5.id)

			if not var1_5 or var1_5 and not var1_5:IsStarting() then
				if var1_5 and var2_5 then
					table.remove(arg0_4.eventList, var2_5)
				end

				local var3_5 = var0_5:getConfig("config_data")
				local var4_5 = var0_5:getDayIndex()

				if var4_5 > 0 and var4_5 <= #var3_5 then
					arg0_4:AddActivityEvent(EventInfo.New({
						finish_time = 0,
						over_time = 0,
						id = var3_5[var4_5],
						ship_id_list = {},
						activity_id = var0_5.id
					}))
				end

				pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
				arg0_4:sendNotification(GAME.EVENT_LIST_UPDATE)
			end
		end,
		[ProxyRegister.SecondCall] = function(arg0_6)
			arg0_4:updateTime()
		end
	}
end

function var0_0.remove(arg0_7)
	return
end

function var0_0.updateInfo(arg0_8, arg1_8)
	arg0_8.eventList = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		table.insert(arg0_8.eventList, EventInfo.New(iter1_8))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_8.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.updateNightInfo(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg1_9) do
		table.insert(arg0_9.eventList, EventInfo.New(iter1_9))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_9.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.getActiveShipIds(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.eventList) do
		if iter1_10.state ~= EventInfo.StateNone then
			for iter2_10, iter3_10 in ipairs(iter1_10.shipIds) do
				table.insert(var0_10, iter3_10)
			end
		end
	end

	return var0_10
end

function var0_0.findInfoById(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.eventList) do
		if iter1_11.id == arg1_11 then
			return iter1_11, iter0_11
		end
	end

	return nil, -1
end

function var0_0.countByState(arg0_12, arg1_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in ipairs(arg0_12.eventList) do
		if iter1_12.state == arg1_12 then
			var0_12 = var0_12 + 1
		end
	end

	return var0_12
end

function var0_0.hasFinishState(arg0_13)
	if arg0_13:countByState(EventInfo.StateFinish) > 0 then
		return true
	end
end

function var0_0.countBusyFleetNums(arg0_14)
	local var0_14 = 0

	for iter0_14, iter1_14 in ipairs(arg0_14.eventList) do
		if not iter1_14:IsActivityType() and iter1_14.state ~= EventInfo.StateNone then
			var0_14 = var0_14 + 1
		end
	end

	return var0_14
end

function var0_0.updateTime(arg0_15)
	local var0_15 = false

	for iter0_15, iter1_15 in pairs(arg0_15.eventList) do
		if iter1_15:updateTime() then
			var0_15 = true
		end
	end

	if var0_15 then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		arg0_15:sendNotification(GAME.EVENT_LIST_UPDATE)
	end
end

function var0_0.getEventList(arg0_16)
	return Clone(arg0_16.eventList)
end

function var0_0.getActiveEvents(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.eventList) do
		if iter1_17.finishTime >= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0_17, iter1_17)
		end
	end

	return var0_17
end

function var0_0.fillRecommendShip(arg0_18, arg1_18)
	local var0_18 = getProxy(BayProxy):getDelegationRecommendShips(arg1_18)

	for iter0_18, iter1_18 in ipairs(var0_18) do
		table.insert(arg1_18.shipIds, iter1_18)
	end
end

function var0_0.fillRecommendShipLV1(arg0_19, arg1_19)
	local var0_19 = getProxy(BayProxy):getDelegationRecommendShipsLV1(arg1_19)

	for iter0_19, iter1_19 in ipairs(var0_19) do
		table.insert(arg1_19.shipIds, iter1_19)
	end
end

function var0_0.checkNightEvent(arg0_20)
	local var0_20 = pg.TimeMgr.GetInstance():GetServerHour()

	return (var0_20 >= pg.gameset.night_collection_begin.key_value and var0_20 < 24 or var0_20 >= 0 and var0_20 < pg.gameset.night_collection_end.key_value) and not _.any(arg0_20.eventList, function(arg0_21)
		local var0_21 = arg0_21:GetCountDownTime()

		return arg0_21.template.type == EventConst.EVENT_TYPE_NIGHT and (not var0_21 or var0_21 > 0)
	end)
end

function var0_0.AddActivityEvents(arg0_22, arg1_22, arg2_22)
	for iter0_22 = #arg0_22.eventList, 1, -1 do
		local var0_22 = arg0_22.eventList[iter0_22]

		if var0_22:IsActivityType() and var0_22:BelongActivity(arg2_22) then
			table.remove(arg0_22.eventList, iter0_22)
		end
	end

	for iter1_22, iter2_22 in ipairs(arg1_22) do
		print("add collection-----------", iter2_22.id)
		table.insert(arg0_22.eventList, iter2_22)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
end

function var0_0.AddActivityEvent(arg0_23, arg1_23)
	print("zero add collection-----------", arg1_23.id)
	table.insert(arg0_23.eventList, arg1_23)
end

function var0_0.CanJoinEvent(arg0_24, arg1_24)
	if not arg1_24:reachNum() then
		return false, i18n("event_minimus_ship_numbers", arg1_24.template.ship_num)
	end

	if not arg1_24:reachLevel() then
		return false, i18n("event_level_unreached")
	end

	if not arg1_24:reachTypes() then
		return false, i18n("event_type_unreached")
	end

	if not arg1_24:IsActivityType() and arg0_24.busyFleetNums >= arg0_24.maxFleetNums then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var0_24 = arg1_24:GetCountDownTime()

	if var0_24 and var0_24 < 0 then
		return false, i18n("event_over_time_expired")
	end

	local var1_24 = getProxy(PlayerProxy):getData()

	if arg1_24:getOilConsume() > var1_24.oil then
		local var2_24

		if not ItemTipPanel.ShowOilBuyTip(arg1_24:getOilConsume()) then
			var2_24 = i18n("common_no_oil")
		end

		return false, var2_24
	end

	local var3_24 = pg.collection_template[arg1_24.id]

	if var3_24 then
		local var4_24 = var3_24.drop_oil_max or 0

		if var1_24:OilMax(var4_24) then
			return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end

		local var5_24 = var3_24.drop_gold_max or 0

		if var1_24:GoldMax(var5_24) then
			return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end
	end

	return true
end

function var0_0.CanFinishEvent(arg0_25, arg1_25)
	local var0_25 = arg1_25.template

	if not var0_25 then
		return false
	end

	local var1_25 = getProxy(PlayerProxy):getData()
	local var2_25 = var0_25.drop_oil_max or 0

	if var1_25:OilMax(var2_25) then
		return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_event")
	end

	local var3_25 = var0_25.drop_gold_max or 0

	if var1_25:GoldMax(var3_25) then
		return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_event")
	end

	return true
end

function var0_0.GetEventByActivityId(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.eventList) do
		if iter1_26:BelongActivity(arg1_26) then
			return iter1_26, iter0_26
		end
	end
end

function var0_0.GetEventListForCommossionInfo(arg0_27)
	local var0_27 = arg0_27:getEventList()
	local var1_27 = 0
	local var2_27 = 0
	local var3_27 = 0
	local var4_27 = 0
	local var5_27 = 0
	local var6_27 = 0
	local var7_27 = {}

	_.each(var0_27, function(arg0_28)
		if arg0_28:IsActivityType() then
			if arg0_28.state == EventInfo.StateNone then
				var6_27 = var6_27 + 1
			elseif arg0_28.state == EventInfo.StateActive then
				var5_27 = var5_27 + 1
			elseif arg0_28.state == EventInfo.StateFinish then
				var4_27 = var4_27 + 1
			end
		elseif arg0_28.state == EventInfo.StateNone then
			-- block empty
		elseif arg0_28.state == EventInfo.StateActive then
			var2_27 = var2_27 + 1

			table.insert(var7_27, arg0_28)
		elseif arg0_28.state == EventInfo.StateFinish then
			var1_27 = var1_27 + 1

			table.insert(var7_27, arg0_28)
		end
	end)

	local var8_27 = var1_27 + var4_27
	local var9_27 = var2_27 + var5_27
	local var10_27 = arg0_27.maxFleetNums - (var1_27 + var2_27) + var6_27

	return var7_27, var8_27, var9_27, var10_27
end

return var0_0
