local var0_0 = class("EventProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.eventDic = {}
	arg0_1.countDownList = {}
	arg0_1.lastFlushTime = 0

	arg0_1:on(13002, function(arg0_2)
		arg0_1.maxFleetNums = arg0_2.max_team

		arg0_1:updateAll(arg0_2.collection_list)
	end)
	arg0_1:on(13011, function(arg0_3)
		arg0_1:updateInfoList(underscore.map(arg0_3.collection, function(arg0_4)
			local var0_4 = EventInfo.New(arg0_4)

			if not arg0_1:existEvent(var0_4.id) then
				arg0_1.eventForMsg = var0_4
			end

			return var0_4
		end))

		arg0_1.virgin = true
	end)
end

function var0_0.timeCall(arg0_5)
	return {
		[ProxyRegister.SecondCall] = function(arg0_6)
			arg0_5:updateTime()
		end
	}
end

function var0_0.updateAll(arg0_7, arg1_7)
	arg0_7.eventDic = {}
	arg0_7.countDownList = {}
	arg0_7.lastFlushTime = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		local var0_7 = EventInfo.New(iter1_7)

		arg0_7.eventDic[var0_7.id] = var0_7

		if var0_7:GetState() == EventInfo.StateActive then
			table.insert(arg0_7.countDownList, var0_7.id)
		end
	end

	table.sort(arg0_7.countDownList, CompareFuncs({
		function(arg0_8)
			return arg0_7.eventDic[arg0_8].finishTime
		end
	}))
	arg0_7:CheckAddActivityEvent()
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_7.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.updateInfoList(arg0_9, arg1_9)
	if #arg1_9 == 0 then
		return
	end

	local var0_9 = false

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		if not instanceof(iter1_9, EventInfo) or iter1_9:GetState() == EventInfo.StateExpire then
			arg0_9.eventDic[iter1_9.id] = nil
		else
			arg0_9.eventDic[iter1_9.id] = iter1_9

			if iter1_9:GetState() == EventInfo.StateActive then
				var0_9 = true

				table.insert(arg0_9.countDownList, iter1_9.id)
			end
		end
	end

	if var0_9 then
		table.sort(arg0_9.countDownList, CompareFuncs({
			function(arg0_10)
				return arg0_9.eventDic[arg0_10].finishTime
			end
		}))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_9.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.getActiveShipIds(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.eventDic) do
		if iter1_11:GetState() ~= EventInfo.StateNone then
			for iter2_11, iter3_11 in ipairs(iter1_11.shipIds) do
				table.insert(var0_11, iter3_11)
			end
		end
	end

	return var0_11
end

function var0_0.existEvent(arg0_12, arg1_12)
	return arg0_12.eventDic[arg1_12] and arg0_12.eventDic[arg1_12]:GetState() ~= EventInfo.StateExpire
end

function var0_0.getEventInfo(arg0_13, arg1_13)
	return Clone(arg0_13.eventDic[arg1_13])
end

function var0_0.countByState(arg0_14, arg1_14)
	local var0_14 = 0

	for iter0_14, iter1_14 in pairs(arg0_14.eventDic) do
		if iter1_14:GetState() == arg1_14 then
			var0_14 = var0_14 + 1
		end
	end

	return var0_14
end

function var0_0.hasFinishState(arg0_15)
	if arg0_15:countByState(EventInfo.StateFinish) > 0 then
		return true
	end
end

function var0_0.countBusyFleetNums(arg0_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in pairs(arg0_16.eventDic) do
		if not iter1_16:IsActivityType() and iter1_16:GetState() > EventInfo.StateNone then
			var0_16 = var0_16 + 1
		end
	end

	return var0_16
end

function var0_0.updateTime(arg0_17)
	local var0_17 = false

	while #arg0_17.countDownList > 0 and arg0_17.eventDic[arg0_17.countDownList[1]]:GetState() == EventInfo.StateFinish do
		var0_17 = true

		table.remove(arg0_17.countDownList, 1)
	end

	if var0_17 then
		arg0_17:sendNotification(GAME.EVENT_FINISH_UPDATE)
	end
end

function var0_0.getEventList(arg0_18)
	return underscore(arg0_18.eventDic):chain():values():filter(function(arg0_19)
		return arg0_19:GetState() ~= EventInfo.StateExpire
	end):map(function(arg0_20)
		return Clone(arg0_20)
	end):value()
end

function var0_0.getActiveEvents(arg0_21)
	return underscore(arg0_21.eventDic):chain():values():filter(function(arg0_22)
		return arg0_22:GetState() == EventInfo.StateActive
	end):value()
end

function var0_0.fillRecommendShip(arg0_23, arg1_23)
	local var0_23 = getProxy(BayProxy):getDelegationRecommendShips(arg1_23)

	for iter0_23, iter1_23 in ipairs(var0_23) do
		table.insert(arg1_23.shipIds, iter1_23)
	end
end

function var0_0.fillRecommendShipLV1(arg0_24, arg1_24)
	local var0_24 = getProxy(BayProxy):getDelegationRecommendShipsLV1(arg1_24)

	for iter0_24, iter1_24 in ipairs(var0_24) do
		table.insert(arg1_24.shipIds, iter1_24)
	end
end

function var0_0.checkNightEvent(arg0_25)
	local var0_25 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1_25 = getGameset("night_collection_begin")[1]
	local var2_25 = getGameset("night_collection_end")[1]

	return (var0_25 == math.clamp(var0_25, var1_25, var2_25 + 24 - 1) or var0_25 + 24 == math.clamp(var0_25 + 24, var1_25, var2_25 + 24 - 1)) and not underscore.any(underscore.values(arg0_25.eventDic), function(arg0_26)
		local var0_26 = arg0_26:GetCountDownTime()

		return arg0_26.template.type == EventConst.EVENT_TYPE_NIGHT and (not var0_26 or var0_26 > 0)
	end)
end

function var0_0.checkZeroHourEvent(arg0_27)
	local var0_27 = pg.TimeMgr.GetInstance()

	return var0_27:GetTimeToNextTime(arg0_27.lastFlushTime) <= var0_27:GetServerTime()
end

function var0_0.CanJoinEvent(arg0_28, arg1_28)
	if not arg1_28:reachNum() then
		return false, i18n("event_minimus_ship_numbers", arg1_28.template.ship_num)
	end

	if not arg1_28:reachLevel() then
		return false, i18n("event_level_unreached")
	end

	if not arg1_28:reachTypes() then
		return false, i18n("event_type_unreached")
	end

	if not arg1_28:IsActivityType() and not arg0_28:CanStartEvent() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var0_28 = arg1_28:GetCountDownTime()

	if var0_28 and var0_28 < 0 then
		return false, i18n("event_over_time_expired")
	end

	local var1_28 = getProxy(PlayerProxy):getData()

	if arg1_28:getOilConsume() > var1_28.oil then
		local var2_28

		if not ItemTipPanel.ShowOilBuyTip(arg1_28:getOilConsume()) then
			var2_28 = i18n("common_no_oil")
		end

		return false, var2_28
	end

	local var3_28 = pg.collection_template[arg1_28.id]

	if var3_28 then
		local var4_28 = var3_28.drop_oil_max or 0

		if var1_28:OilMax(var4_28) then
			return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end

		local var5_28 = var3_28.drop_gold_max or 0

		if var1_28:GoldMax(var5_28) then
			return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end
	end

	return true
end

function var0_0.CanFinishEvent(arg0_29, arg1_29)
	local var0_29 = arg1_29.template

	if not var0_29 then
		return false
	end

	local var1_29 = getProxy(PlayerProxy):getData()
	local var2_29 = var0_29.drop_oil_max or 0

	if var1_29:OilMax(var2_29) then
		return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_event")
	end

	local var3_29 = var0_29.drop_gold_max or 0

	if var1_29:GoldMax(var3_29) then
		return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_event")
	end

	return true
end

function var0_0.GetEventByActivityId(arg0_30, arg1_30)
	for iter0_30, iter1_30 in pairs(arg0_30.eventDic) do
		if iter1_30:BelongActivity(arg1_30) then
			return iter1_30
		end
	end
end

function var0_0.GetEventListForCommossionInfo(arg0_31)
	local var0_31 = 0
	local var1_31 = 0
	local var2_31 = 0
	local var3_31 = 0
	local var4_31 = 0
	local var5_31 = 0
	local var6_31 = {}

	_.each(arg0_31:getEventList(), function(arg0_32)
		if arg0_32:IsActivityType() then
			switch(arg0_32:GetState(), {
				[EventInfo.StateNone] = function()
					var5_31 = var5_31 + 1
				end,
				[EventInfo.StateActive] = function()
					var4_31 = var4_31 + 1
				end,
				[EventInfo.StateFinish] = function()
					var3_31 = var3_31 + 1
				end
			})
		else
			switch(arg0_32:GetState(), {
				[EventInfo.StateNone] = function()
					return
				end,
				[EventInfo.StateActive] = function()
					var1_31 = var1_31 + 1

					table.insert(var6_31, arg0_32)
				end,
				[EventInfo.StateFinish] = function()
					var0_31 = var0_31 + 1

					table.insert(var6_31, arg0_32)
				end
			})
		end
	end)

	local var7_31 = var0_31 + var3_31
	local var8_31 = var1_31 + var4_31
	local var9_31 = arg0_31.maxFleetNums - (var0_31 + var1_31) + var5_31

	return var6_31, var7_31, var8_31, var9_31
end

function var0_0.CheckAddActivityEvent(arg0_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in pairs(arg0_39.eventDic) do
		if iter1_39:IsActivityType() then
			table.insert(var0_39, {
				id = iter1_39.id
			})
		end
	end

	for iter2_39, iter3_39 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)) do
		if iter3_39 and not iter3_39:isEnd() then
			table.insertto(var0_39, iter3_39:GetCollectionList())
		end
	end

	arg0_39:updateInfoList(var0_39)

	return #var0_39 > 0
end

function var0_0.CanStartEvent(arg0_40)
	return arg0_40:countBusyFleetNums() < arg0_40.maxFleetNums
end

return var0_0
