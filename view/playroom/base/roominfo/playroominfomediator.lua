local var0_0 = class("PlayRoomInfoMediator", import("view.base.ContextMediator"))

var0_0.ON_CLICK_VIEWER = "PlayRoomInfoMediator::ON_CLICK_VIEWER"
var0_0.ON_CLICK_READY = "PlayRoomInfoMediator::ON_CLICK_READY"
var0_0.ON_CLICK_KICK = "PlayRoomInfoMediator::ON_CLICK_KICK"
var0_0.ON_CLICK_INVITE = "PlayRoomInfoMediator::ON_CLICK_INVITE"
var0_0.ON_CLICK_CLOSE = "PlayRoomInfoMediator::ON_CLICK_CLOSE"
var0_0.ON_CLICK_START_GAME = "PlayRoomInfoMediaotr::ON_CLICK_START_GAME"
var0_0.ON_CLICK_CHANGE_CHARACTER = "PlayRoomInfoMediaotr::ON_CLICK_CHANGE_CHARACTER"
var0_0.ON_SWITCH_ROOM_TYPE = "PlayRoomInfoMediator.ON_SWITCH_ROOM_TYPE"
var0_0.ON_MATCH_CLICK_READY = "PlayRoomInfoMediaotr:ON_MATCH_CLICK_READY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLICK_VIEWER, function()
		arg0_1:addSubLayers(Context.New({
			mediator = PlayRoomInfoViewerMediator,
			viewComponent = PlayRoomInfoViewerScene
		}))
	end)
	arg0_1:bind(var0_0.ON_CLICK_INVITE, function()
		arg0_1:addSubLayers(Context.New({
			mediator = PlayRoomInfoInviteMediator,
			viewComponent = PlayRoomInfoInviteScene
		}))
	end)
	arg0_1:bind(var0_0.ON_CLICK_READY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.PLAY_ROOM_READY, arg1_4)
	end)
	arg0_1:bind(var0_0.ON_CLICK_KICK, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.PLAY_ROOM_KICK, arg1_5)
	end)
	arg0_1:bind(var0_0.ON_CLICK_CLOSE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM)
	end)
	arg0_1:bind(var0_0.ON_CLICK_START_GAME, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.PLAY_ROOM_START_GAME)
	end)
	arg0_1:bind(var0_0.ON_CLICK_CHANGE_CHARACTER, function(arg0_8, arg1_8)
		arg0_1:sendNotification(CheaterTavernEvent.OPEN_SELECT_SHIP, IslandCheaterTavernConst.ChangeDressType.InRoom)
	end)
	arg0_1:bind(var0_0.ON_SWITCH_ROOM_TYPE, function(arg0_9)
		arg0_1:sendNotification(GAME.PLAY_ROOM_SWITCH_ROOM_TYPE)
	end)
	arg0_1:bind(var0_0.ON_MATCH_CLICK_READY, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.PLAY_ROOM_MATCH_READY, arg1_10)
	end)
end

function var0_0.initNotificationHandleDic(arg0_11)
	arg0_11.handleDic = {
		[GAME.PLAY_ROOM_READY_DONE] = function(arg0_12, arg1_12)
			arg0_12.viewComponent:RefreshUI()
		end,
		[GAME.PLAY_ROOM_SWITCH_VIEWER_DONE] = function(arg0_13, arg1_13)
			arg0_13.viewComponent:RefreshUI()
		end,
		[GAME.PLAY_ROOM_KICK_DONE] = function(arg0_14, arg1_14)
			arg0_14.viewComponent:RefreshUI()
		end,
		[GAME.PLAY_ROOM_EXIT_ROOM_DONE] = function(arg0_15, arg1_15)
			arg0_15.viewComponent:closeView()
		end,
		[GAME.PLAY_ROOM_START_GAME_DONE] = function(arg0_16, arg1_16)
			return
		end,
		[GAME.PLAY_ROOM_REDAY_ROOM_REFRESH] = function(arg0_17, arg1_17)
			arg0_17.viewComponent:RefreshUI()
		end,
		[GAME.PLAY_ROOM_MATCH_READY_DONE] = function(arg0_18, arg1_18)
			return
		end,
		[GAME.PLAY_ROOM_MATCH_REDAY_ROOM_REFRESH] = function(arg0_19, arg1_19)
			arg0_19.viewComponent:RefreshMatchInfoUI()
		end,
		[GAME.PLAY_ROOM_EXIT_MATCH_READY_ROOM] = function(arg0_20, arg1_20)
			arg0_20:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM)
		end,
		[GAME.PLAY_ROOM_CLOSE_MATCH_READY] = function(arg0_21, arg1_21)
			arg0_21:sendNotification(GAME.PLAY_ROOM_LOAD_MINIGAME_SCENE, {
				mapId = IslandConst.CheaterTavernMapId
			})
			arg0_21.viewComponent:EnterLoadInfoUI()
		end,
		[GAME.PLAY_ROOM_ALL_LOAD_OVER] = function(arg0_22, arg1_22)
			return
		end,
		[GAME.PLAY_ROOM_SWITCH_ROOM_TYPE_DONE] = function(arg0_23, arg1_23)
			arg0_23.viewComponent:RefreshUI()
		end,
		[ChatProxy.NEW_MSG] = function(arg0_24, arg1_24)
			arg0_24.viewComponent:RefreshMessage()
		end,
		[FriendProxy.FRIEND_NEW_MSG] = function(arg0_25, arg1_25)
			arg0_25.viewComponent:RefreshMessage()
		end,
		[GuildProxy.NEW_MSG_ADDED] = function(arg0_26, arg1_26)
			arg0_26.viewComponent:RefreshMessage()
		end,
		[PlayRoomProxy.CHAT_MSG_UPDATE] = function(arg0_27, arg1_27)
			arg0_27.viewComponent:RefreshMessage()
		end,
		[GAME.CHANGE_CHAT_ROOM_DONE] = function(arg0_28, arg1_28)
			arg0_28.viewComponent:RefreshMessage()
		end
	}
end

function var0_0.remove(arg0_29)
	return
end

return var0_0
