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
		getProxy(ChapterAutoProxy):RecordNewEventIds(underscore.map(arg0_3.collection, function(arg0_4)
			return arg0_4.id
		end))
		arg0_1:updateInfoList(underscore.map(arg0_3.collection, function(arg0_5)
			local var0_5 = EventInfo.New(arg0_5)

			if not arg0_1:existEvent(var0_5.id) then
				arg0_1.eventForMsg = var0_5
			end

			return var0_5
		end))

		arg0_1.virgin = true
	end)
end

function var0_0.timeCall(arg0_6)
	return {
		[ProxyRegister.SecondCall] = function(arg0_7)
			arg0_6:updateTime()
		end
	}
end

function var0_0.updateAll(arg0_8, arg1_8)
	arg0_8.eventDic = {}
	arg0_8.countDownList = {}
	arg0_8.lastFlushTime = pg.TimeMgr.GetInstance():GetServerTime()

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var0_8 = EventInfo.New(iter1_8)

		arg0_8.eventDic[var0_8.id] = var0_8

		if var0_8:GetState() == EventInfo.StateActive then
			table.insert(arg0_8.countDownList, var0_8.id)
		end
	end

	table.sort(arg0_8.countDownList, CompareFuncs({
		function(arg0_9)
			return arg0_8.eventDic[arg0_9].finishTime
		end
	}))
	arg0_8:CheckAddActivityEvent()
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_8.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.updateInfoList(arg0_10, arg1_10)
	if #arg1_10 == 0 then
		return
	end

	local var0_10 = false

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		if not instanceof(iter1_10, EventInfo) or iter1_10:GetState() == EventInfo.StateExpire then
			arg0_10.eventDic[iter1_10.id] = nil
		else
			arg0_10.eventDic[iter1_10.id] = iter1_10

			if iter1_10:GetState() == EventInfo.StateActive then
				var0_10 = true

				table.insert(arg0_10.countDownList, iter1_10.id)
			end
		end
	end

	if var0_10 then
		table.sort(arg0_10.countDownList, CompareFuncs({
			function(arg0_11)
				return arg0_10.eventDic[arg0_11].finishTime
			end
		}))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0_10.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0_0.getActiveShipIds(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.eventDic) do
		if iter1_12:GetState() ~= EventInfo.StateNone then
			for iter2_12, iter3_12 in ipairs(iter1_12.shipIds) do
				table.insert(var0_12, iter3_12)
			end
		end
	end

	return var0_12
end

function var0_0.existEvent(arg0_13, arg1_13)
	return arg0_13.eventDic[arg1_13] and arg0_13.eventDic[arg1_13]:GetState() ~= EventInfo.StateExpire
end

function var0_0.getEventInfo(arg0_14, arg1_14)
	return Clone(arg0_14.eventDic[arg1_14])
end

function var0_0.countByState(arg0_15, arg1_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in pairs(arg0_15.eventDic) do
		if iter1_15:GetState() == arg1_15 then
			var0_15 = var0_15 + 1
		end
	end

	return var0_15
end

function var0_0.hasFinishState(arg0_16)
	if arg0_16:countByState(EventInfo.StateFinish) > 0 then
		return true
	end
end

function var0_0.countBusyFleetNums(arg0_17)
	local var0_17 = 0

	for iter0_17, iter1_17 in pairs(arg0_17.eventDic) do
		if not iter1_17:IsActivityType() and iter1_17:GetState() > EventInfo.StateNone then
			var0_17 = var0_17 + 1
		end
	end

	return var0_17
end

function var0_0.updateTime(arg0_18)
	local var0_18 = false

	while #arg0_18.countDownList > 0 and arg0_18.eventDic[arg0_18.countDownList[1]]:GetState() == EventInfo.StateFinish do
		var0_18 = true

		table.remove(arg0_18.countDownList, 1)
	end

	if var0_18 then
		arg0_18:sendNotification(GAME.EVENT_FINISH_UPDATE)
	end
end

function var0_0.getEventList(arg0_19)
	return underscore(arg0_19.eventDic):chain():values():filter(function(arg0_20)
		return arg0_20:GetState() ~= EventInfo.StateExpire
	end):map(function(arg0_21)
		return Clone(arg0_21)
	end):value()
end

function var0_0.getActiveEvents(arg0_22)
	return underscore(arg0_22.eventDic):chain():values():filter(function(arg0_23)
		return arg0_23:GetState() == EventInfo.StateActive
	end):value()
end

function var0_0.fillRecommendShip(arg0_24, arg1_24)
	local var0_24 = getProxy(BayProxy):getDelegationRecommendShips(arg1_24)

	for iter0_24, iter1_24 in ipairs(var0_24) do
		table.insert(arg1_24.shipIds, iter1_24)
	end
end

function var0_0.fillRecommendShipLV1(arg0_25, arg1_25)
	local var0_25 = getProxy(BayProxy):getDelegationRecommendShipsLV1(arg1_25)

	for iter0_25, iter1_25 in ipairs(var0_25) do
		table.insert(arg1_25.shipIds, iter1_25)
	end
end

function var0_0.checkNightEvent(arg0_26)
	local var0_26 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1_26 = getGameset("night_collection_begin")[1]
	local var2_26 = getGameset("night_collection_end")[1]

	return (var0_26 == math.clamp(var0_26, var1_26, var2_26 + 24 - 1) or var0_26 + 24 == math.clamp(var0_26 + 24, var1_26, var2_26 + 24 - 1)) and not underscore.any(underscore.values(arg0_26.eventDic), function(arg0_27)
		local var0_27 = arg0_27:GetCountDownTime()

		return arg0_27.template.type == EventConst.EVENT_TYPE_NIGHT and (not var0_27 or var0_27 > 0)
	end)
end

function var0_0.checkZeroHourEvent(arg0_28)
	local var0_28 = pg.TimeMgr.GetInstance()

	return var0_28:GetTimeToNextTime(arg0_28.lastFlushTime) <= var0_28:GetServerTime()
end

function var0_0.CanJoinEvent(arg0_29, arg1_29)
	if not arg1_29:reachNum() then
		return false, i18n("event_minimus_ship_numbers", arg1_29.template.ship_num)
	end

	if not arg1_29:reachLevel() then
		return false, i18n("event_level_unreached")
	end

	if not arg1_29:reachTypes() then
		return false, i18n("event_type_unreached")
	end

	if not arg1_29:IsActivityType() and not arg0_29:CanStartEvent() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var0_29 = arg1_29:GetCountDownTime()

	if var0_29 and var0_29 < 0 then
		return false, i18n("event_over_time_expired")
	end

	local var1_29 = getProxy(PlayerProxy):getData()

	if arg1_29:getOilConsume() > var1_29.oil then
		local var2_29

		if not ItemTipPanel.ShowOilBuyTip(arg1_29:getOilConsume()) then
			var2_29 = i18n("common_no_oil")
		end

		return false, var2_29
	end

	local var3_29 = pg.collection_template[arg1_29.id]

	if var3_29 then
		local var4_29 = var3_29.drop_oil_max or 0

		if var1_29:OilMax(var4_29) then
			return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end

		local var5_29 = var3_29.drop_gold_max or 0

		if var1_29:GoldMax(var5_29) then
			return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end
	end

	return true
end

function var0_0.CanFinishEvent(arg0_30, arg1_30)
	local var0_30 = arg1_30.template

	if not var0_30 then
		return false
	end

	local var1_30 = getProxy(PlayerProxy):getData()
	local var2_30 = var0_30.drop_oil_max or 0

	if var1_30:OilMax(var2_30) then
		return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_event")
	end

	local var3_30 = var0_30.drop_gold_max or 0

	if var1_30:GoldMax(var3_30) then
		return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_event")
	end

	return true
end

function var0_0.GetEventByActivityId(arg0_31, arg1_31)
	for iter0_31, iter1_31 in pairs(arg0_31.eventDic) do
		if iter1_31:BelongActivity(arg1_31) then
			return iter1_31
		end
	end
end

function var0_0.GetEventListForCommossionInfo(arg0_32)
	local var0_32 = 0
	local var1_32 = 0
	local var2_32 = 0
	local var3_32 = 0
	local var4_32 = 0
	local var5_32 = 0
	local var6_32 = {}

	_.each(arg0_32:getEventList(), function(arg0_33)
		if arg0_33:IsActivityType() then
			switch(arg0_33:GetState(), {
				[EventInfo.StateNone] = function()
					var5_32 = var5_32 + 1
				end,
				[EventInfo.StateActive] = function()
					var4_32 = var4_32 + 1
				end,
				[EventInfo.StateFinish] = function()
					var3_32 = var3_32 + 1
				end
			})
		else
			switch(arg0_33:GetState(), {
				[EventInfo.StateNone] = function()
					return
				end,
				[EventInfo.StateActive] = function()
					var1_32 = var1_32 + 1

					table.insert(var6_32, arg0_33)
				end,
				[EventInfo.StateFinish] = function()
					var0_32 = var0_32 + 1

					table.insert(var6_32, arg0_33)
				end
			})
		end
	end)

	local var7_32 = var0_32 + var3_32
	local var8_32 = var1_32 + var4_32
	local var9_32 = arg0_32.maxFleetNums - (var0_32 + var1_32) + var5_32

	return var6_32, var7_32, var8_32, var9_32
end

function var0_0.CheckAddActivityEvent(arg0_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in pairs(arg0_40.eventDic) do
		if iter1_40:IsActivityType() then
			table.insert(var0_40, {
				id = iter1_40.id
			})
		end
	end

	for iter2_40, iter3_40 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT)) do
		if iter3_40 and not iter3_40:isEnd() then
			table.insertto(var0_40, iter3_40:GetCollectionList())
		end
	end

	arg0_40:updateInfoList(var0_40)

	return #var0_40 > 0
end

function var0_0.CanStartEvent(arg0_41)
	return arg0_41:countBusyFleetNums() < arg0_41.maxFleetNums
end

return var0_0
