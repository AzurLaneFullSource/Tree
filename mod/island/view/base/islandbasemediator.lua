local var0_0 = class("IslandBaseMediator", import("view.base.ContextMediator"))

var0_0.SET_UP = "IslandBaseScene:SET_UP"
var0_0.SWITCH_MAP = "IslandBaseMediator:SWITCH_MAP"
var0_0.RECORD_PLAYER_POS = "IslandBaseMediator:RECORD_PLAYER_POS"
var0_0.ANIMATION_OP = "IslandBaseMediator:ANIMATION_OP"
var0_0.SEND_CHAT = "IslandBaseMediator:SEND_CHAT"
var0_0.CHANGE_CHAT_ROOM = "IslandBaseMediator:CHANGE_CHAT_ROOM"
var0_0.OPEN_FRIEND_INFO = "IslandBaseMediator:OPEN_FRIEND_INFO"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_FRIEND_INFO, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1.friendInfoPosition = arg2_2
		arg0_1.friendInfoMsg = arg3_2

		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_2
		})
	end)
	arg0_1:bind(var0_0.CHANGE_CHAT_ROOM, function(arg0_3, arg1_3)
		if not arg1_3 then
			return
		end

		if arg1_3 <= 0 or arg1_3 == "" then
			return
		end

		arg0_1:sendNotification(GAME.CHANGE_CHAT_ROOM, arg1_3)
	end)
	arg0_1:bind(var0_0.SEND_CHAT, function(arg0_4, arg1_4, arg2_4)
		local var0_4 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_SEND_CHAT, {
			channel = arg1_4,
			islandId = var0_4.id,
			msg = arg2_4
		})
	end)
	arg0_1:bind(var0_0.ANIMATION_OP, function(arg0_5, arg1_5, arg2_5)
		local var0_5 = arg0_1.viewComponent:GetIsland()

		arg0_1:sendNotification(GAME.ISLAND_ANIMATION_OP, {
			islandId = var0_5.id,
			targetId = arg1_5,
			actionId = arg2_5
		})
	end)
	arg0_1:bind(var0_0.SET_UP, function(arg0_6)
		arg0_1:SetUp()
	end)
	arg0_1:bind(var0_0.SWITCH_MAP, function(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg0_1.viewComponent:GetIsland()

		if not var0_7:GetAblityAgency():IsUnlockMap(arg1_7) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_lock_map_tip"))

			return
		end

		arg0_1:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = var0_7.id,
			mapId = arg1_7,
			callback = function()
				local var0_8 = pg.island_world_objects[arg2_7]

				if var0_8 then
					local var1_8 = BuildVector3(var0_8.param.position)
					local var2_8 = BuildVector3(var0_8.param.rotation)

					arg0_1:RecordPlayerPosition(arg1_7, var1_8, var2_8)
				end

				arg0_1:SwitchScene(arg1_7, arg2_7)
			end
		})
	end)
	arg0_1:bind(var0_0.RECORD_PLAYER_POS, function(arg0_9)
		if not _IslandCore then
			return
		end

		local var0_9 = _IslandCore:GetController().mapId
		local var1_9 = _IslandCore:GetView().player

		if not var1_9 then
			return
		end

		local var2_9, var3_9 = var1_9:LastGroundedPosition()

		arg0_1:RecordPlayerPosition(var0_9, var2_9, var3_9)
	end)
	arg0_1:_register()
end

function var0_0.RecordPlayerPosition(arg0_10, arg1_10, arg2_10, arg3_10)
	if not _IslandCore then
		return
	end

	if not _IslandCore:GetController():IsSelfIsland() then
		return
	end

	arg0_10:sendNotification(GAME.ISLAND_RECORD_LAST_EXIT_POS, {
		islandId = arg0_10.viewComponent:GetIsland().id,
		mapId = arg1_10,
		position = arg2_10,
		rotation = arg3_10
	})
end

function var0_0.listNotificationInterests(arg0_11)
	local var0_11 = {
		ChatProxy.NEW_MSG,
		FriendProxy.FRIEND_NEW_MSG,
		GuildProxy.NEW_MSG_ADDED,
		IslandProxy.CHAT_MSG_UPDATE,
		GAME.CHANGE_CHAT_ROOM_DONE,
		GAME.FRIEND_SEARCH_DONE,
		GAME.ON_APPLICATION_PAUSE,
		GAME.ISLAND_ON_HOME,
		GAME.ISLAND_ON_RECONNECT,
		GAME.ISLAND_SELECT_GIFT_DONE
	}
	local var1_11 = arg0_11:_listNotificationInterests()

	for iter0_11, iter1_11 in ipairs(var1_11) do
		if not table.contains(var0_11, iter1_11) then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == ChatProxy.NEW_MSG or var0_12 == FriendProxy.FRIEND_NEW_MSG or var0_12 == GuildProxy.NEW_MSG_ADDED or var0_12 == IslandProxy.CHAT_MSG_UPDATE then
		arg0_12.viewComponent:emitCore(ISLAND_EVT.CHAT_MSG_UPDATE)

		if var0_12 == IslandProxy.CHAT_MSG_UPDATE and var1_12.islandId == arg0_12.viewComponent:GetIsland().id then
			arg0_12.viewComponent:emitCore(ISLAND_EVT.SHOW_CHAT_MSG, var1_12.msg)
		end
	elseif var0_12 == GAME.CHANGE_CHAT_ROOM_DONE then
		arg0_12.viewComponent:emitCore(ISLAND_EVT.CHAT_ROOM_UPDATE)
	elseif var0_12 == GAME.FRIEND_SEARCH_DONE and var1_12.list[1] and var1_12.type == SearchFriendCommand.SEARCH_TYPE_RESUME then
		arg0_12:addSubLayers(Context.New({
			viewComponent = IslandFriendInfoLayer,
			mediator = FriendInfoMediator,
			data = {
				friend = var1_12.list[1],
				msg = arg0_12.friendInfoMsg,
				pos = arg0_12.friendInfoPosition
			}
		}))

		arg0_12.friendInfoPosition = nil
		arg0_12.friendInfoMsg = nil
	elseif var0_12 == GAME.ON_APPLICATION_PAUSE then
		if not var1_12 and _IslandCore then
			arg0_12:sendNotification(GAME.ISLAND_RECONNECT, {
				islandId = _IslandCore:GetController():GetIsland().id
			})
		end
	elseif var0_12 == GAME.ISLAND_ON_HOME then
		arg0_12.viewComponent:emit(BaseUI.ON_HOME)
	elseif var0_12 == GAME.ISLAND_ON_RECONNECT then
		arg0_12.viewComponent:ExitProcess(BaseUI.ON_HOME, function()
			pg.m02:sendNotification(GAME.ISLAND_ENTER, var1_12)
		end)
	elseif var0_12 == GAME.ISLAND_SELECT_GIFT_DONE then
		arg0_12.viewComponent:HandleAwardDisplay(var1_12.dropData, var1_12.callback, IslandAwardDisplayPage.TYPE_SIGN_GIFT)
	end

	arg0_12:_handleNotification(arg1_12)
	arg0_12.viewComponent:emit(var0_12, var1_12)
end

function var0_0.SetUp(arg0_14)
	local var0_14 = arg0_14.viewComponent:GetIsland()
	local var1_14 = var0_14.mapID
	local var2_14 = var0_14.spawnPointId

	_IslandCore = IslandCore.New(arg0_14.viewComponent:GetPoolMgr(), var0_14, arg0_14.viewComponent._container)

	arg0_14.viewComponent:OnSetUpCore(var1_14, var2_14)
end

function var0_0.SwitchScene(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.viewComponent:GetIsland()

	var0_15:SetMapId(arg1_15)

	if arg2_15 then
		var0_15:SetSpawnPointId(arg2_15)
	end

	arg0_15:UnloadScene()
	arg0_15:SetUp()
end

function var0_0.UnloadScene(arg0_16, arg1_16)
	arg0_16.viewComponent:OnUnloadScene()

	if _IslandCore then
		_IslandCore:Dispose(arg1_16)

		_IslandCore = nil
	end
end

function var0_0.remove(arg0_17)
	arg0_17:UnloadScene(true)
	arg0_17:_remove()
end

function var0_0._register(arg0_18)
	return
end

function var0_0._listNotificationInterests(arg0_19)
	return {}
end

function var0_0._handleNotification(arg0_20, arg1_20)
	return
end

function var0_0._remove(arg0_21)
	return
end

return var0_0
