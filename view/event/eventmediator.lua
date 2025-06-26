EventConst = require("view/event/EventConst")

local var0_0 = class("EventMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(EventConst.EVENT_LIST_UPDATE, function(arg0_2)
		arg0_1:updateEventList(true)
	end)
	arg0_1:bind(EventConst.EVENT_OPEN_DOCK, function(arg0_3, arg1_3)
		if not arg0_1.contextData.selectedEventId then
			return
		end

		local var0_3 = getProxy(BayProxy):getRawData()
		local var1_3 = {}

		for iter0_3, iter1_3 in pairs(var0_3) do
			if not table.contains(arg1_3.template.ship_type, iter1_3:getShipType()) or iter1_3:isActivityNpc() then
				table.insert(var1_3, iter0_3)
			end
		end

		local var2_3, var3_3, var4_3 = arg0_1:getDockCallbackFuncs(arg1_3)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 6,
			useBlackBlock = true,
			selectedMin = 1,
			ignoredIds = var1_3,
			selectedIds = arg1_3 and arg1_3.shipIds or {},
			onShip = var2_3,
			confirmSelect = var3_3,
			onSelected = var4_3,
			leftTopInfo = i18n("word_operation"),
			hideTagFlags = ShipStatus.TAG_HIDE_EVENT,
			blockTagFlags = ShipStatus.TAG_BLOCK_EVENT
		})
	end)
	arg0_1:bind(EventConst.EVENT_FLUSH_ALL, function(arg0_4)
		arg0_1:sendNotification(GAME.EVENT_FLUSH_ALL)
	end)
	arg0_1:bind(EventConst.EVENT_START, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.EVENT_START, {
			event = arg1_5
		})
	end)
	arg0_1:bind(EventConst.EVENT_GIVEUP, function(arg0_6, arg1_6)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_confirm_giveup"),
			onYes = function()
				arg0_1:sendNotification(GAME.EVENT_GIVEUP, {
					id = arg1_6.id
				})
			end
		})
	end)
	arg0_1:bind(EventConst.EVENT_FINISH, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.EVENT_FINISH, {
			id = arg1_8.id
		})
	end)
	arg0_1:updateEventList(false, arg0_1.contextData.eventList)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_FINISH_UPDATE,
		GAME.EVENT_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == GAME.EVENT_LIST_UPDATE then
		arg0_10:updateEventList(true)
	elseif var0_10 == GAME.EVENT_FINISH_UPDATE then
		arg0_10:updateEventList(true)
	elseif var0_10 == GAME.EVENT_SHOW_AWARDS then
		local var2_10

		var2_10 = coroutine.wrap(function()
			if #var1_10.oldShips > 0 then
				arg0_10.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1_10.eventId].title,
					oldShips = var1_10.oldShips,
					newShips = var1_10.newShips,
					isCri = var1_10.isCri
				}, var2_10)
				coroutine.yield()
			end

			arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_10.awards)
		end)

		var2_10()
	end
end

function var0_0.updateEventList(arg0_12, arg1_12, arg2_12)
	local var0_12 = getProxy(BayProxy)
	local var1_12 = getProxy(EventProxy)

	var1_12.virgin = false
	arg0_12.contextData.eventList = arg2_12 or var1_12:getEventList()

	arg0_12.viewComponent:setEventList(arg0_12.contextData.eventList)

	if arg1_12 then
		arg0_12.viewComponent:updateAll(arg1_12)
	end

	if getProxy(SettingsProxy):ShouldShowEventActHelp() and _.any(arg0_12.contextData.eventList, function(arg0_13)
		return arg0_13:IsActivityType()
	end) then
		getProxy(SettingsProxy):MarkEventActHelpFlag()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_act_event.tip
		})
	end
end

function var0_0.getDockCallbackFuncs(arg0_14, arg1_14)
	local function var0_14(arg0_15, arg1_15, arg2_15)
		local var0_15, var1_15 = ShipStatus.ShipStatusCheck("inEvent", arg0_15, arg1_15)

		if not var0_15 then
			return var0_15, var1_15
		end

		local var2_15 = getProxy(BayProxy)

		for iter0_15, iter1_15 in ipairs(arg2_15) do
			local var3_15 = var2_15:getShipById(iter1_15)

			if arg0_15:isSameKind(var3_15) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	local function var1_14(arg0_16, arg1_16, arg2_16)
		arg1_16()
	end

	local function var2_14(arg0_17)
		arg1_14:setShipIds(arg0_17)
	end

	return var0_14, var1_14, var2_14
end

return var0_0
