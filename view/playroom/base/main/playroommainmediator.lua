local var0_0 = class("PlayRoomMainMediator", import("view.base.ContextMediator"))

var0_0.REFRESH_ROOM_LIST = "PlayRoomMainMediator:REFRESH_ROOM_LIST"
var0_0.CREATE_ROOM = "PlayRoomMainMediator:CREATE_ROOM"
var0_0.JOIN_ROOM = "PlayRoomMainMediator:JOIN_ROOM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.REFRESH_ROOM_LIST, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM)
	end)
	arg0_1:bind(var0_0.CREATE_ROOM, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.PLAY_ROOM_CREATE_ROOM, arg1_3)
	end)
	arg0_1:bind(var0_0.JOIN_ROOM, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.PLAY_ROOM_JOIN_ROOM, arg1_4)
	end)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {
		[GAME.PLAY_ROOM_REFRESH_ROOM_DONE] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getName()
			local var1_6 = arg1_6:getBody()

			arg0_6.viewComponent:RefreshUI()
		end,
		[GAME.PLAY_ROOM_CREATE_ROOM_DONE] = function(arg0_7, arg1_7)
			arg0_7.viewComponent:OnCreateRoomOver()
			arg0_7:sendNotification(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
		end,
		[GAME.PLAY_ROOM_JOIN_ROOM_DONE] = function(arg0_8, arg1_8)
			arg0_8:sendNotification(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
		end,
		[GAME.PLAY_ROOM_JOIN_ROOM_QUICK_FAIL] = function(arg0_9, arg1_9)
			arg0_9.viewComponent:OnQuickRoomFail()
		end,
		[GAME.PLAY_ROOM_ALL_LOAD_OVER] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:closeView()
		end
	}
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
