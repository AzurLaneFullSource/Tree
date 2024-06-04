local var0 = class("EventProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.eventList = {}

	arg0:on(13002, function(arg0)
		arg0.maxFleetNums = arg0.max_team

		arg0:updateInfo(arg0.collection_list)
	end)
	arg0:on(13011, function(arg0)
		for iter0, iter1 in ipairs(arg0.collection) do
			local var0 = EventInfo.New(iter1)
			local var1, var2 = arg0:findInfoById(iter1.id)

			if var2 == -1 then
				table.insert(arg0.eventList, var0)

				arg0.eventForMsg = var0
			else
				arg0.eventList[var2] = var0
			end
		end

		arg0.virgin = true

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		arg0.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
	end)

	arg0.timer = Timer.New(function()
		arg0:updateTime()
	end, 1, -1)

	arg0.timer:Start()
end

function var0.remove(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.updateInfo(arg0, arg1)
	arg0.eventList = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.eventList, EventInfo.New(iter1))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0.updateNightInfo(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.eventList, EventInfo.New(iter1))
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	arg0.facade:sendNotification(GAME.EVENT_LIST_UPDATE)
end

function var0.getActiveShipIds(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.eventList) do
		if iter1.state ~= EventInfo.StateNone then
			for iter2, iter3 in ipairs(iter1.shipIds) do
				table.insert(var0, iter3)
			end
		end
	end

	return var0
end

function var0.findInfoById(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.eventList) do
		if iter1.id == arg1 then
			return iter1, iter0
		end
	end

	return nil, -1
end

function var0.countByState(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.eventList) do
		if iter1.state == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.hasFinishState(arg0)
	if arg0:countByState(EventInfo.StateFinish) > 0 then
		return true
	end
end

function var0.countBusyFleetNums(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.eventList) do
		if not iter1:IsActivityType() and iter1.state ~= EventInfo.StateNone then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.updateTime(arg0)
	local var0 = false

	for iter0, iter1 in pairs(arg0.eventList) do
		if iter1:updateTime() then
			var0 = true
		end
	end

	if var0 then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
		arg0:sendNotification(GAME.EVENT_LIST_UPDATE)
	end
end

function var0.getEventList(arg0)
	return Clone(arg0.eventList)
end

function var0.getActiveEvents(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.eventList) do
		if iter1.finishTime >= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.fillRecommendShip(arg0, arg1)
	local var0 = getProxy(BayProxy):getDelegationRecommendShips(arg1)

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg1.shipIds, iter1)
	end
end

function var0.fillRecommendShipLV1(arg0, arg1)
	local var0 = getProxy(BayProxy):getDelegationRecommendShipsLV1(arg1)

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg1.shipIds, iter1)
	end
end

function var0.checkNightEvent(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerHour()

	return (var0 >= pg.gameset.night_collection_begin.key_value and var0 < 24 or var0 >= 0 and var0 < pg.gameset.night_collection_end.key_value) and not _.any(arg0.eventList, function(arg0)
		local var0 = arg0:GetCountDownTime()

		return arg0.template.type == EventConst.EVENT_TYPE_NIGHT and (not var0 or var0 > 0)
	end)
end

function var0.AddActivityEvents(arg0, arg1, arg2)
	for iter0 = #arg0.eventList, 1, -1 do
		local var0 = arg0.eventList[iter0]

		if var0:IsActivityType() and var0:BelongActivity(arg2) then
			table.remove(arg0.eventList, iter0)
		end
	end

	for iter1, iter2 in ipairs(arg1) do
		print("add collection-----------", iter2.id)
		table.insert(arg0.eventList, iter2)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
end

function var0.AddActivityEvent(arg0, arg1)
	print("zero add collection-----------", arg1.id)
	table.insert(arg0.eventList, arg1)
end

function var0.CanJoinEvent(arg0, arg1)
	if not arg1:reachNum() then
		return false, i18n("event_minimus_ship_numbers", arg1.template.ship_num)
	end

	if not arg1:reachLevel() then
		return false, i18n("event_level_unreached")
	end

	if not arg1:reachTypes() then
		return false, i18n("event_type_unreached")
	end

	if not arg1:IsActivityType() and arg0.busyFleetNums >= arg0.maxFleetNums then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	local var0 = arg1:GetCountDownTime()

	if var0 and var0 < 0 then
		return false, i18n("event_over_time_expired")
	end

	local var1 = getProxy(PlayerProxy):getData()

	if arg1:getOilConsume() > var1.oil then
		local var2

		if not ItemTipPanel.ShowOilBuyTip(arg1:getOilConsume()) then
			var2 = i18n("common_no_oil")
		end

		return false, var2
	end

	local var3 = pg.collection_template[arg1.id]

	if var3 then
		local var4 = var3.drop_oil_max or 0

		if var1:OilMax(var4) then
			return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end

		local var5 = var3.drop_gold_max or 0

		if var1:GoldMax(var5) then
			return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_eventstart")
		end
	end

	return true
end

function var0.CanFinishEvent(arg0, arg1)
	local var0 = arg1.template

	if not var0 then
		return false
	end

	local var1 = getProxy(PlayerProxy):getData()
	local var2 = var0.drop_oil_max or 0

	if var1:OilMax(var2) then
		return false, i18n("oil_max_tip_title") .. i18n("resource_max_tip_event")
	end

	local var3 = var0.drop_gold_max or 0

	if var1:GoldMax(var3) then
		return false, i18n("gold_max_tip_title") .. i18n("resource_max_tip_event")
	end

	return true
end

function var0.GetEventByActivityId(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.eventList) do
		if iter1:BelongActivity(arg1) then
			return iter1, iter0
		end
	end
end

function var0.GetEventListForCommossionInfo(arg0)
	local var0 = arg0:getEventList()
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4 = 0
	local var5 = 0
	local var6 = 0
	local var7 = {}

	_.each(var0, function(arg0)
		if arg0:IsActivityType() then
			if arg0.state == EventInfo.StateNone then
				var6 = var6 + 1
			elseif arg0.state == EventInfo.StateActive then
				var5 = var5 + 1
			elseif arg0.state == EventInfo.StateFinish then
				var4 = var4 + 1
			end
		elseif arg0.state == EventInfo.StateNone then
			-- block empty
		elseif arg0.state == EventInfo.StateActive then
			var2 = var2 + 1

			table.insert(var7, arg0)
		elseif arg0.state == EventInfo.StateFinish then
			var1 = var1 + 1

			table.insert(var7, arg0)
		end
	end)

	local var8 = var1 + var4
	local var9 = var2 + var5
	local var10 = arg0.maxFleetNums - (var1 + var2) + var6

	return var7, var8, var9, var10
end

return var0
