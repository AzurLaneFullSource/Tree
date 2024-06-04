EventConst = require("view/event/EventConst")

local var0 = class("EventMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(EventConst.EVEN_USE_PREV_FORMATION, function(arg0, arg1, arg2)
		local var0 = getProxy(EventProxy)
		local var1 = getProxy(BayProxy)
		local var2 = var1:getData()
		local var3 = {}
		local var4 = false
		local var5 = false

		local function var6(arg0)
			for iter0, iter1 in ipairs(arg2) do
				local var0 = arg0[iter1]

				if var0 then
					local var1, var2 = ShipStatus.ShipStatusConflict("inEvent", var0)

					if var1 == ShipStatus.STATE_CHANGE_FAIL then
						var4 = true
					elseif var1 == ShipStatus.STATE_CHANGE_CHECK then
						var5 = true
					else
						table.insert(var3, iter1)
					end
				end
			end

			if var4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip"))
			end

			if var5 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip2"))
			end

			var0.selectedEvent = arg1
			var0.selectedEvent.shipIds = var3

			arg0:updateEventList(true)

			var0.selectedEvent = nil
		end

		local var7 = var1:getRawData()

		var6(var7)
	end)
	arg0:bind(EventConst.EVENT_LIST_UPDATE, function(arg0)
		arg0:updateEventList(true)
	end)
	arg0:bind(EventConst.EVENT_OPEN_DOCK, function(arg0, arg1)
		local var0 = getProxy(BayProxy):getRawData()
		local var1 = {}

		for iter0, iter1 in pairs(var0) do
			if not table.contains(arg1.template.ship_type, iter1:getShipType()) or iter1:isActivityNpc() then
				table.insert(var1, iter0)
			end
		end

		local var2 = getProxy(EventProxy)

		var2.selectedEvent = arg1

		local var3, var4, var5 = arg0:getDockCallbackFuncs()

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 6,
			useBlackBlock = true,
			selectedMin = 1,
			ignoredIds = var1,
			selectedIds = var2.selectedEvent and var2.selectedEvent.shipIds or {},
			onShip = var3,
			confirmSelect = var4,
			onSelected = var5,
			leftTopInfo = i18n("word_operation"),
			hideTagFlags = ShipStatus.TAG_HIDE_EVENT,
			blockTagFlags = ShipStatus.TAG_BLOCK_EVENT
		})
	end)
	arg0:bind(EventConst.EVENT_FLUSH_NIGHT, function(arg0)
		arg0:sendNotification(GAME.EVENT_FLUSH_NIGHT)
	end)
	arg0:bind(EventConst.EVENT_START, function(arg0, arg1)
		arg0:sendNotification(GAME.EVENT_START, {
			id = arg1.id,
			shipIds = arg1.shipIds
		})
	end)
	arg0:bind(EventConst.EVENT_GIVEUP, function(arg0, arg1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_confirm_giveup"),
			onYes = function()
				arg0:sendNotification(GAME.EVENT_GIVEUP, {
					id = arg1.id
				})
			end
		})
	end)
	arg0:bind(EventConst.EVENT_FINISH, function(arg0, arg1)
		arg0:sendNotification(GAME.EVENT_FINISH, {
			id = arg1.id
		})
	end)
	arg0:bind(EventConst.EVENT_RECOMMEND, function(arg0, arg1)
		local var0 = getProxy(EventProxy)

		var0.selectedEvent = arg1

		getProxy(EventProxy):fillRecommendShip(arg1)
		arg0:updateEventList(true, true)

		var0.selectedEvent = nil

		if not arg1:reachNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("event_recommend_fail"))
		end
	end)
	arg0:bind(EventConst.EVENT_RECOMMEND_LEVEL1, function(arg0, arg1)
		local var0 = getProxy(EventProxy)

		var0.selectedEvent = arg1

		getProxy(EventProxy):fillRecommendShipLV1(arg1)
		arg0:updateEventList(true, true)

		var0.selectedEvent = nil

		if not arg1:reachNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("event_recommend_fail"))
		end
	end)
	arg0:updateEventList(false)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_SHOW_AWARDS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EVENT_LIST_UPDATE then
		arg0:updateEventList(true)
	elseif var0 == GAME.EVENT_SHOW_AWARDS then
		local var2

		var2 = coroutine.wrap(function()
			if #var1.oldShips > 0 then
				arg0.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1.eventId].title,
					oldShips = var1.oldShips,
					newShips = var1.newShips,
					isCri = var1.isCri
				}, var2)
				coroutine.yield()
			end

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end)

		var2()
	end
end

function var0.updateEventList(arg0, arg1, arg2)
	local var0 = getProxy(BayProxy)
	local var1 = getProxy(EventProxy)

	var1.virgin = false

	local var2 = var1.eventList

	table.sort(var2, function(arg0, arg1)
		if arg0.state ~= arg1.state then
			return arg0.state > arg1.state
		elseif arg0.template.type ~= arg1.template.type then
			return arg0.template.type > arg1.template.type
		elseif arg0.template.lv ~= arg1.template.lv then
			return arg0.template.lv > arg1.template.lv
		else
			return arg0.id > arg1.id
		end
	end)

	for iter0, iter1 in ipairs(var2) do
		iter1.ships = {}

		if iter1.state == EventInfo.StateNone and iter1 ~= var1.selectedEvent then
			iter1.shipIds = {}
		else
			for iter2 = #iter1.shipIds, 1, -1 do
				local var3 = var0:getShipById(iter1.shipIds[iter2])

				if var3 then
					table.insert(iter1.ships, 1, var3)
				else
					table.remove(iter1.shipIds, iter2)
				end
			end
		end
	end

	var1.busyFleetNums = var1:countBusyFleetNums()

	arg0.viewComponent:updateAll(var1, arg1, arg2)

	if getProxy(SettingsProxy):ShouldShowEventActHelp() and _.any(var2, function(arg0)
		return arg0:IsActivityType()
	end) then
		getProxy(SettingsProxy):MarkEventActHelpFlag()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_act_event.tip
		})
	end
end

function var0.getDockCallbackFuncs(arg0)
	local function var0(arg0, arg1, arg2)
		local var0, var1 = ShipStatus.ShipStatusCheck("inEvent", arg0, arg1)

		if not var0 then
			return var0, var1
		end

		local var2 = getProxy(BayProxy)

		for iter0, iter1 in ipairs(arg2) do
			local var3 = var2:getShipById(iter1)

			if arg0:isSameKind(var3) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var1(arg0, arg1, arg2)
		arg1()
	end

	local function var2(arg0)
		getProxy(EventProxy).selectedEvent.shipIds = arg0
	end

	return var0, var1, var2
end

return var0
