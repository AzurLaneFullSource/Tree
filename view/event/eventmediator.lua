EventConst = require("view/event/EventConst")

local var0_0 = class("EventMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(EventConst.EVEN_USE_PREV_FORMATION, function(arg0_2, arg1_2, arg2_2)
		local var0_2 = getProxy(EventProxy)
		local var1_2 = getProxy(BayProxy)
		local var2_2 = var1_2:getData()
		local var3_2 = {}
		local var4_2 = false
		local var5_2 = false

		local function var6_2(arg0_3)
			for iter0_3, iter1_3 in ipairs(arg2_2) do
				local var0_3 = arg0_3[iter1_3]

				if var0_3 then
					local var1_3, var2_3 = ShipStatus.ShipStatusConflict("inEvent", var0_3)

					if var1_3 == ShipStatus.STATE_CHANGE_FAIL then
						var4_2 = true
					elseif var1_3 == ShipStatus.STATE_CHANGE_CHECK then
						var5_2 = true
					else
						table.insert(var3_2, iter1_3)
					end
				end
			end

			if var4_2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip"))
			end

			if var5_2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip2"))
			end

			var0_2.selectedEvent = arg1_2
			var0_2.selectedEvent.shipIds = var3_2

			arg0_1:updateEventList(true)

			var0_2.selectedEvent = nil
		end

		local var7_2 = var1_2:getRawData()

		var6_2(var7_2)
	end)
	arg0_1:bind(EventConst.EVENT_LIST_UPDATE, function(arg0_4)
		arg0_1:updateEventList(true)
	end)
	arg0_1:bind(EventConst.EVENT_OPEN_DOCK, function(arg0_5, arg1_5)
		local var0_5 = getProxy(BayProxy):getRawData()
		local var1_5 = {}

		for iter0_5, iter1_5 in pairs(var0_5) do
			if not table.contains(arg1_5.template.ship_type, iter1_5:getShipType()) or iter1_5:isActivityNpc() then
				table.insert(var1_5, iter0_5)
			end
		end

		local var2_5 = getProxy(EventProxy)

		var2_5.selectedEvent = arg1_5

		local var3_5, var4_5, var5_5 = arg0_1:getDockCallbackFuncs()

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 6,
			useBlackBlock = true,
			selectedMin = 1,
			ignoredIds = var1_5,
			selectedIds = var2_5.selectedEvent and var2_5.selectedEvent.shipIds or {},
			onShip = var3_5,
			confirmSelect = var4_5,
			onSelected = var5_5,
			leftTopInfo = i18n("word_operation"),
			hideTagFlags = ShipStatus.TAG_HIDE_EVENT,
			blockTagFlags = ShipStatus.TAG_BLOCK_EVENT
		})
	end)
	arg0_1:bind(EventConst.EVENT_FLUSH_NIGHT, function(arg0_6)
		arg0_1:sendNotification(GAME.EVENT_FLUSH_NIGHT)
	end)
	arg0_1:bind(EventConst.EVENT_START, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.EVENT_START, {
			id = arg1_7.id,
			shipIds = arg1_7.shipIds
		})
	end)
	arg0_1:bind(EventConst.EVENT_GIVEUP, function(arg0_8, arg1_8)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_confirm_giveup"),
			onYes = function()
				arg0_1:sendNotification(GAME.EVENT_GIVEUP, {
					id = arg1_8.id
				})
			end
		})
	end)
	arg0_1:bind(EventConst.EVENT_FINISH, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.EVENT_FINISH, {
			id = arg1_10.id
		})
	end)
	arg0_1:bind(EventConst.EVENT_RECOMMEND, function(arg0_11, arg1_11)
		local var0_11 = getProxy(EventProxy)

		var0_11.selectedEvent = arg1_11

		getProxy(EventProxy):fillRecommendShip(arg1_11)
		arg0_1:updateEventList(true, true)

		var0_11.selectedEvent = nil

		if not arg1_11:reachNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("event_recommend_fail"))
		end
	end)
	arg0_1:bind(EventConst.EVENT_RECOMMEND_LEVEL1, function(arg0_12, arg1_12)
		local var0_12 = getProxy(EventProxy)

		var0_12.selectedEvent = arg1_12

		getProxy(EventProxy):fillRecommendShipLV1(arg1_12)
		arg0_1:updateEventList(true, true)

		var0_12.selectedEvent = nil

		if not arg1_12:reachNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("event_recommend_fail"))
		end
	end)
	arg0_1:updateEventList(false)
end

function var0_0.listNotificationInterests(arg0_13)
	return {
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_14, arg1_14)
	local var0_14 = arg1_14:getName()
	local var1_14 = arg1_14:getBody()

	if var0_14 == GAME.EVENT_LIST_UPDATE then
		arg0_14:updateEventList(true)
	elseif var0_14 == GAME.EVENT_SHOW_AWARDS then
		local var2_14

		var2_14 = coroutine.wrap(function()
			if #var1_14.oldShips > 0 then
				arg0_14.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1_14.eventId].title,
					oldShips = var1_14.oldShips,
					newShips = var1_14.newShips,
					isCri = var1_14.isCri
				}, var2_14)
				coroutine.yield()
			end

			arg0_14.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_14.awards)
		end)

		var2_14()
	end
end

function var0_0.updateEventList(arg0_16, arg1_16, arg2_16)
	local var0_16 = getProxy(BayProxy)
	local var1_16 = getProxy(EventProxy)

	var1_16.virgin = false

	local var2_16 = var1_16.eventList

	table.sort(var2_16, function(arg0_17, arg1_17)
		if arg0_17.state ~= arg1_17.state then
			return arg0_17.state > arg1_17.state
		elseif arg0_17.template.type ~= arg1_17.template.type then
			return arg0_17.template.type > arg1_17.template.type
		elseif arg0_17.template.lv ~= arg1_17.template.lv then
			return arg0_17.template.lv > arg1_17.template.lv
		else
			return arg0_17.id > arg1_17.id
		end
	end)

	for iter0_16, iter1_16 in ipairs(var2_16) do
		iter1_16.ships = {}

		if iter1_16.state == EventInfo.StateNone and iter1_16 ~= var1_16.selectedEvent then
			iter1_16.shipIds = {}
		else
			for iter2_16 = #iter1_16.shipIds, 1, -1 do
				local var3_16 = var0_16:getShipById(iter1_16.shipIds[iter2_16])

				if var3_16 then
					table.insert(iter1_16.ships, 1, var3_16)
				else
					table.remove(iter1_16.shipIds, iter2_16)
				end
			end
		end
	end

	var1_16.busyFleetNums = var1_16:countBusyFleetNums()

	arg0_16.viewComponent:updateAll(var1_16, arg1_16, arg2_16)

	if getProxy(SettingsProxy):ShouldShowEventActHelp() and _.any(var2_16, function(arg0_18)
		return arg0_18:IsActivityType()
	end) then
		getProxy(SettingsProxy):MarkEventActHelpFlag()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_act_event.tip
		})
	end
end

function var0_0.getDockCallbackFuncs(arg0_19)
	local function var0_19(arg0_20, arg1_20, arg2_20)
		local var0_20, var1_20 = ShipStatus.ShipStatusCheck("inEvent", arg0_20, arg1_20)

		if not var0_20 then
			return var0_20, var1_20
		end

		local var2_20 = getProxy(BayProxy)

		for iter0_20, iter1_20 in ipairs(arg2_20) do
			local var3_20 = var2_20:getShipById(iter1_20)

			if arg0_20:isSameKind(var3_20) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var1_19(arg0_21, arg1_21, arg2_21)
		arg1_21()
	end

	local function var2_19(arg0_22)
		getProxy(EventProxy).selectedEvent.shipIds = arg0_22
	end

	return var0_19, var1_19, var2_19
end

return var0_0
