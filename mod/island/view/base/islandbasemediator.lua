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
	arg0_1:bind(var0_0.OPEN_FRIEND_INFO, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_1.friendInfoPosition = arg2_5
		arg0_1.friendInfoMsg = arg3_5

		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_5
		})
	end)
	arg0_1:bind(var0_0.CHANGE_CHAT_ROOM, function(arg0_6, arg1_6)
		if not arg1_6 then
			return
		end

		if arg1_6 <= 0 or arg1_6 == "" then
			return
		end

		arg0_1:sendNotification(GAME.CHANGE_CHAT_ROOM, arg1_6)
	end)
	arg0_1:bind(var0_0.SEND_CHAT, function(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_SEND_CHAT, {
			channel = arg1_7,
			islandId = var0_7.id,
			msg = arg2_7
		})
	end)
	arg0_1:bind(var0_0.ANIMATION_OP, function(arg0_8, arg1_8, arg2_8)
		local var0_8 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_ANIMATION_OP, {
			islandId = var0_8.id,
			targetId = arg1_8,
			actionId = arg2_8
		})
	end)
	arg0_1:bind(var0_0.SET_UP, function(arg0_9)
		arg0_1:SetUp()
	end)
	arg0_1:bind(var0_0.SWITCH_MAP, function(arg0_10, arg1_10, arg2_10)
		local var0_10 = arg0_1.viewComponent:GetIsland()

		if not var0_10:GetAblityAgency():IsUnlockMap(arg1_10) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_lock_map_tip"))

			return
		end

		arg0_1:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = var0_10.id,
			mapId = arg1_10,
			callback = function()
				local var0_11 = pg.island_world_objects[arg2_10]

				if var0_11 then
					local var1_11 = BuildVector3(var0_11.param.position)
					local var2_11 = BuildVector3(var0_11.param.rotation)

					arg0_1:RecordPlayerPosition(arg1_10, var1_11, var2_11)
				end

				arg0_1:SwitchScene(arg1_10, arg2_10)
			end
		})
	end)
	arg0_1:bind(var0_0.RECORD_PLAYER_POS, function(arg0_12)
		if not _IslandCore then
			return
		end

		local var0_12 = _IslandCore:GetController().mapId
		local var1_12 = _IslandCore:GetView().player

		if not var1_12 or not var1_12._tf then
			return
		end

		local var2_12, var3_12 = var1_12:LastGroundedPosition()

		arg0_1:RecordPlayerPosition(var0_12, var2_12, var3_12)
	end)
	arg0_1:_register()
end

function var0_0.RecordPlayerPosition(arg0_13, arg1_13, arg2_13, arg3_13)
	if not _IslandCore then
		return
	end

	if not _IslandCore:GetController():IsSelfIsland() then
		return
	end

	arg0_13:sendNotification(GAME.ISLAND_RECORD_LAST_EXIT_POS, {
		islandId = arg0_13.viewComponent:GetIsland().id,
		mapId = arg1_13,
		position = arg2_13,
		rotation = arg3_13
	})
end

function var0_0.listNotificationInterests(arg0_14)
	local var0_14 = {
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
		GAME.ISLAND_CORE_STATE_CHANGED
	}
	local var1_14 = arg0_14:_listNotificationInterests()

	for iter0_14, iter1_14 in ipairs(var1_14) do
		if not table.contains(var0_14, iter1_14) then
			table.insert(var0_14, iter1_14)
		end
	end

	return var0_14
end

function var0_0.handleNotification(arg0_15, arg1_15)
	local var0_15 = arg1_15:getName()
	local var1_15 = arg1_15:getBody()

	if var0_15 == ChatProxy.NEW_MSG or var0_15 == FriendProxy.FRIEND_NEW_MSG or var0_15 == GuildProxy.NEW_MSG_ADDED or var0_15 == IslandProxy.CHAT_MSG_UPDATE then
		arg0_15.viewComponent:emitCore(ISLAND_EVT.CHAT_MSG_UPDATE)

		if var0_15 == IslandProxy.CHAT_MSG_UPDATE and var1_15.islandId == arg0_15.viewComponent:GetIsland().id then
			arg0_15.viewComponent:emitCore(ISLAND_EVT.SHOW_CHAT_MSG, var1_15.msg)
		end
	elseif var0_15 == GAME.CHANGE_CHAT_ROOM_DONE then
		arg0_15.viewComponent:emitCore(ISLAND_EVT.CHAT_ROOM_UPDATE)
	elseif var0_15 == GAME.FRIEND_SEARCH_DONE and var1_15.list[1] and var1_15.type == SearchFriendCommand.SEARCH_TYPE_RESUME then
		arg0_15:addSubLayers(Context.New({
			viewComponent = IslandFriendInfoLayer,
			mediator = FriendInfoMediator,
			data = {
				friend = var1_15.list[1],
				msg = arg0_15.friendInfoMsg,
				pos = arg0_15.friendInfoPosition
			}
		}))

		arg0_15.friendInfoPosition = nil
		arg0_15.friendInfoMsg = nil
	elseif var0_15 == GAME.ON_APPLICATION_PAUSE then
		if not var1_15 and _IslandCore and not arg0_15.exitProcessing then
			arg0_15:sendNotification(GAME.ISLAND_RECONNECT, {
				islandId = _IslandCore:GetController():GetIsland().id
			})
		end
	elseif var0_15 == GAME.ISLAND_ON_HOME then
		arg0_15.viewComponent:emit(BaseUI.ON_HOME)
	elseif var0_15 == GAME.ISLAND_ON_RECONNECT then
		if arg0_15.exitProcessing then
			return
		end

		local function var2_15()
			arg0_15.exitProcessing = true

			arg0_15.viewComponent:ExitProcess(BaseUI.ON_HOME, function()
				arg0_15.exitProcessing = false

				pg.m02:sendNotification(GAME.ISLAND_ENTER, var1_15)
			end)
		end

		if _IslandCore and _IslandCore.state == IslandCore.STATE_INIT_FINISH then
			var2_15()
		else
			arg0_15.coreInitCallback = var2_15
		end
	elseif var0_15 == GAME.ISLAND_SELECT_GIFT_DONE then
		arg0_15.viewComponent:HandleAwardDisplay(var1_15.dropData, var1_15.callback, IslandAwardDisplayPage.TYPE_SIGN_GIFT)
	elseif var0_15 == GAME.ISLAND_CORE_STATE_CHANGED and var1_15 == IslandCore.STATE_INIT_FINISH and arg0_15.coreInitCallback then
		arg0_15.coreInitCallback()

		arg0_15.coreInitCallback = nil
	end

	arg0_15:_handleNotification(arg1_15)
	arg0_15.viewComponent:emit(var0_15, var1_15)
end

function var0_0.SetUp(arg0_18, arg1_18)
	local var0_18 = arg0_18.viewComponent:GetIsland()
	local var1_18 = var0_18.mapID
	local var2_18 = var0_18.spawnPointId

	_IslandCore = IslandCore.New(arg0_18.viewComponent:GetPoolMgr(), var0_18, arg1_18)

	arg0_18.viewComponent:OnSetUpCore(var1_18, var2_18)
end

function var0_0.SwitchScene(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.viewComponent:GetIsland()

	var0_19:SetMapId(arg1_19)

	if arg2_19 then
		var0_19:SetSpawnPointId(arg2_19)
	end

	local var1_19 = arg0_19:UnloadScene()

	arg0_19:SetUp(var1_19)
end

function var0_0.UnloadScene(arg0_20, arg1_20)
	arg0_20.viewComponent:OnUnloadScene()

	if _IslandCore then
		local var0_20 = _IslandCore:GetView():GetSubView(IslandOpView)
		local var1_20 = var0_20 and var0_20.showBalance or 1

		_IslandCore:Dispose(arg1_20)

		_IslandCore = nil

		return var1_20
	end

	return 1
end

function var0_0.remove(arg0_21)
	arg0_21:UnloadScene(true)
	arg0_21:_remove()
	IslandHelper.RunGC(true)
end

function var0_0._register(arg0_22)
	return
end

function var0_0._listNotificationInterests(arg0_23)
	return {}
end

function var0_0._handleNotification(arg0_24, arg1_24)
	return
end

function var0_0._remove(arg0_25)
	return
end

return var0_0
