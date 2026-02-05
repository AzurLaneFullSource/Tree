local var0_0 = class("IslandBaseMediator", import("view.base.ContextMediator"))

var0_0.SET_UP = "IslandBaseScene:SET_UP"
var0_0.SWITCH_MAP = "IslandBaseMediator:SWITCH_MAP"
var0_0.RECORD_PLAYER_POS = "IslandBaseMediator:RECORD_PLAYER_POS"
var0_0.ANIMATION_OP = "IslandBaseMediator:ANIMATION_OP"
var0_0.SEND_CHAT = "IslandBaseMediator:SEND_CHAT"
var0_0.CHANGE_CHAT_ROOM = "IslandBaseMediator:CHANGE_CHAT_ROOM"
var0_0.OPEN_FRIEND_INFO = "IslandBaseMediator:OPEN_FRIEND_INFO"
var0_0.GO_FISHING = "IslandBaseMediator:GO_FISHING"
var0_0.FISHING_RESULT = "IslandBaseMediator:FISHING_RESULT"
var0_0.EXCHANGE_LURE = "IslandBaseMediator:EXCHANGE_LURE"
var0_0.TRADE_OP = "IslandBaseMediator:TRADE_OP"
var0_0.REQ_TRADE_RANK = "IslandBaseMediator:REQ_TRADE_RANK"
var0_0.TRADE_INVITATION = "IslandBaseMediator:TRADE_INVITATION"
var0_0.ENTER_ISLAND = "IslandBaseMediator:ENTER_ISLAND"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EXCHANGE_LURE, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.ISLAND_EXCHANGE_LURE, {
			lureId = arg1_2,
			fishPointId = arg2_2,
			callback = arg3_2
		})
	end)
	arg0_1:bind(var0_0.FISHING_RESULT, function(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3)
		local var0_3 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_FISHING_REUSLT, {
			fishId = arg3_3,
			fishPointId = arg2_3,
			weight = arg4_3,
			cupType = arg5_3,
			islandId = var0_3.id,
			op = arg1_3,
			callback = arg6_3
		})
	end)
	arg0_1:bind(var0_0.GO_FISHING, function(arg0_4, arg1_4, arg2_4, arg3_4)
		local var0_4 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_GO_FISHING, {
			poolId = arg1_4,
			baitId = arg2_4,
			islandId = var0_4.id,
			callback = arg3_4
		})
	end)
	arg0_1:bind(var0_0.ENTER_ISLAND, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.ISLAND_ENTER, {
			id = arg1_5
		})
	end)
	arg0_1:bind(var0_0.TRADE_INVITATION, function(arg0_6, arg1_6, arg2_6, arg3_6)
		arg0_1:sendNotification(GAME.ISLAND_INVITE_TRADE, {
			list = arg1_6,
			mapId = arg2_6,
			price = arg3_6
		})
	end)
	arg0_1:bind(var0_0.REQ_TRADE_RANK, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.ISLAND_GET_FRIEND_TRADE_RANK, {
			callback = arg1_7
		})
	end)
	arg0_1:bind(var0_0.TRADE_OP, function(arg0_8, arg1_8, arg2_8, arg3_8)
		local var0_8 = arg0_1.viewComponent:GetIsland()

		if not var0_8:GetTradeAgency():CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_price_unrefresh"))

			return
		end

		arg0_1:sendNotification(GAME.ISLAND_TRADE, {
			islandId = var0_8.id,
			op = arg1_8,
			num = arg2_8,
			price = arg3_8
		})
	end)
	arg0_1:bind(var0_0.OPEN_FRIEND_INFO, function(arg0_9, arg1_9, arg2_9, arg3_9)
		arg0_1.friendInfoPosition = arg2_9
		arg0_1.friendInfoMsg = arg3_9

		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_9
		})
	end)
	arg0_1:bind(var0_0.CHANGE_CHAT_ROOM, function(arg0_10, arg1_10)
		if not arg1_10 then
			return
		end

		if arg1_10 <= 0 or arg1_10 == "" then
			return
		end

		arg0_1:sendNotification(GAME.CHANGE_CHAT_ROOM, arg1_10)
	end)
	arg0_1:bind(var0_0.SEND_CHAT, function(arg0_11, arg1_11, arg2_11)
		local var0_11 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_SEND_CHAT, {
			channel = arg1_11,
			islandId = var0_11.id,
			msg = arg2_11
		})
	end)
	arg0_1:bind(var0_0.ANIMATION_OP, function(arg0_12, arg1_12, arg2_12)
		local var0_12 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_ANIMATION_OP, {
			islandId = var0_12.id,
			targetId = arg1_12,
			actionId = arg2_12
		})
	end)
	arg0_1:bind(var0_0.SET_UP, function(arg0_13)
		arg0_1:SetUp()
	end)
	arg0_1:bind(var0_0.SWITCH_MAP, function(arg0_14, arg1_14, arg2_14)
		local var0_14 = arg0_1.viewComponent:GetIsland()

		if not var0_14:GetAblityAgency():IsUnlockMap(arg1_14) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_lock_map_tip"))

			return
		end

		arg0_1:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = var0_14.id,
			mapId = arg1_14,
			callback = function()
				local var0_15 = pg.island_world_objects[arg2_14]

				if var0_15 then
					local var1_15 = BuildVector3(var0_15.param.position)
					local var2_15 = BuildVector3(var0_15.param.rotation)

					arg0_1:RecordPlayerPosition(arg1_14, var1_15, var2_15)
				end

				arg0_1:SwitchScene(arg1_14, arg2_14)
			end
		})
	end)
	arg0_1:bind(var0_0.RECORD_PLAYER_POS, function(arg0_16)
		if not _IslandCore then
			return
		end

		local var0_16 = _IslandCore:GetController().mapId
		local var1_16 = _IslandCore:GetView().player

		if not var1_16 or not var1_16._tf then
			return
		end

		local var2_16, var3_16 = var1_16:LastGroundedPosition()

		arg0_1:RecordPlayerPosition(var0_16, var2_16, var3_16)
	end)
	arg0_1:_register()
end

function var0_0.RecordPlayerPosition(arg0_17, arg1_17, arg2_17, arg3_17)
	if not _IslandCore then
		return
	end

	if not _IslandCore:GetController():IsSelfIsland() then
		return
	end

	arg0_17:sendNotification(GAME.ISLAND_RECORD_LAST_EXIT_POS, {
		islandId = arg0_17.viewComponent:GetIsland().id,
		mapId = arg1_17,
		position = arg2_17,
		rotation = arg3_17
	})
end

function var0_0.listNotificationInterests(arg0_18)
	local var0_18 = {
		ChatProxy.NEW_MSG,
		FriendProxy.FRIEND_NEW_MSG,
		GuildProxy.NEW_MSG_ADDED,
		IslandProxy.CHAT_MSG_UPDATE,
		GAME.CHANGE_CHAT_ROOM_DONE,
		GAME.FRIEND_SEARCH_DONE,
		GAME.ON_APPLICATION_PAUSE,
		GAME.ISLAND_ON_HOME,
		GAME.ISLAND_ON_RECONNECT,
		GAME.ISLAND_SELECT_GIFT_DONE,
		GAME.ISLAND_CORE_STATE_CHANGED,
		GAME.ISLAND_TRADE_DONE,
		GAME.ISLAND_SELECT_GIFT_DONE,
		IslandTradegency.WEEK_NUM_UPDATE,
		IslandTradegency.INVITE_LIST_UPDATE
	}
	local var1_18 = arg0_18:_listNotificationInterests()

	for iter0_18, iter1_18 in ipairs(var1_18) do
		if not table.contains(var0_18, iter1_18) then
			table.insert(var0_18, iter1_18)
		end
	end

	return var0_18
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()

	if var0_19 == ChatProxy.NEW_MSG or var0_19 == FriendProxy.FRIEND_NEW_MSG or var0_19 == GuildProxy.NEW_MSG_ADDED or var0_19 == IslandProxy.CHAT_MSG_UPDATE then
		arg0_19.viewComponent:emitCore(ISLAND_EVT.CHAT_MSG_UPDATE)

		if var0_19 == IslandProxy.CHAT_MSG_UPDATE and var1_19.islandId == arg0_19.viewComponent:GetIsland().id then
			arg0_19.viewComponent:emitCore(ISLAND_EVT.SHOW_CHAT_MSG, var1_19.msg)
		end
	elseif var0_19 == GAME.CHANGE_CHAT_ROOM_DONE then
		arg0_19.viewComponent:emitCore(ISLAND_EVT.CHAT_ROOM_UPDATE)
	elseif var0_19 == GAME.FRIEND_SEARCH_DONE and var1_19.list[1] and var1_19.type == SearchFriendCommand.SEARCH_TYPE_RESUME then
		arg0_19:addSubLayers(Context.New({
			viewComponent = IslandFriendInfoLayer,
			mediator = FriendInfoMediator,
			data = {
				friend = var1_19.list[1],
				msg = arg0_19.friendInfoMsg,
				pos = arg0_19.friendInfoPosition
			}
		}))

		arg0_19.friendInfoPosition = nil
		arg0_19.friendInfoMsg = nil
	elseif var0_19 == GAME.ON_APPLICATION_PAUSE then
		if not var1_19 and _IslandCore and not arg0_19.exitProcessing then
			arg0_19:sendNotification(GAME.ISLAND_RECONNECT, {
				islandId = _IslandCore:GetController():GetIsland().id
			})
		end
	elseif var0_19 == GAME.ISLAND_ON_HOME then
		arg0_19.viewComponent:emit(BaseUI.ON_HOME)
	elseif var0_19 == GAME.ISLAND_ON_RECONNECT then
		if arg0_19.exitProcessing then
			return
		end

		local function var2_19()
			arg0_19.exitProcessing = true

			arg0_19.viewComponent:ExitProcess(BaseUI.ON_HOME, function()
				arg0_19.exitProcessing = false

				pg.m02:sendNotification(GAME.ISLAND_ENTER, var1_19)
			end)
		end

		if _IslandCore and _IslandCore.state == IslandCore.STATE_INIT_FINISH then
			var2_19()
		else
			arg0_19.coreInitCallback = var2_19
		end
	elseif var0_19 == GAME.ISLAND_SELECT_GIFT_DONE then
		arg0_19.viewComponent:HandleAwardDisplay(var1_19.dropData, var1_19.callback, IslandAwardDisplayPage.TYPE_SIGN_GIFT)
	elseif var0_19 == GAME.ISLAND_CORE_STATE_CHANGED then
		if var1_19 == IslandCore.STATE_INIT_FINISH and arg0_19.coreInitCallback then
			arg0_19.coreInitCallback()

			arg0_19.coreInitCallback = nil
		end
	elseif var0_19 == GAME.ISLAND_TRADE_DONE then
		arg0_19.viewComponent:HandleAwardDisplay(var1_19.dropData, var1_19.callback)
	end

	arg0_19:_handleNotification(arg1_19)
	arg0_19.viewComponent:emit(var0_19, var1_19)
end

function var0_0.SetUp(arg0_22, arg1_22)
	local var0_22 = arg0_22.viewComponent:GetIsland()
	local var1_22 = var0_22.mapID
	local var2_22 = var0_22.spawnPointId

	_IslandCore = IslandCore.New(arg0_22.viewComponent:GetPoolMgr(), var0_22, arg1_22)

	arg0_22.viewComponent:OnSetUpCore(var1_22, var2_22)
end

function var0_0.SwitchScene(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.viewComponent:GetIsland()

	var0_23:SetMapId(arg1_23)

	if arg2_23 then
		var0_23:SetSpawnPointId(arg2_23)
	end

	local var1_23 = arg0_23:UnloadScene()

	arg0_23:SetUp(var1_23)
end

function var0_0.UnloadScene(arg0_24, arg1_24)
	arg0_24.viewComponent:OnUnloadScene()

	if _IslandCore then
		local var0_24 = _IslandCore:GetView():GetSubView(IslandOpView)
		local var1_24 = var0_24 and var0_24.showBalance or 1

		_IslandCore:Dispose(arg1_24)

		_IslandCore = nil

		return var1_24
	end

	return 1
end

function var0_0.remove(arg0_25)
	arg0_25:UnloadScene(true)
	arg0_25:_remove()
	IslandHelper.RunGC(true)
end

function var0_0._register(arg0_26)
	return
end

function var0_0._listNotificationInterests(arg0_27)
	return {}
end

function var0_0._handleNotification(arg0_28, arg1_28)
	return
end

function var0_0._remove(arg0_29)
	return
end

return var0_0
