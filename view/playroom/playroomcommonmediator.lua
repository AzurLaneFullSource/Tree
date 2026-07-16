local var0_0 = class("PlayRoomCommonMediator", import("view.base.ContextMediator"))

var0_0.ON_CLICK_MATCH = "PlayRoomCommonMediator::ON_CLICK_MATCH"
var0_0.REFRESH_ROOM_INFO = "PlayRoomCommonMediator::REFRESH_ROOM_INFO"
var0_0.PLAY_ROOM_MATCH_STOP = "PlayRoomCommonMediator::PLAY_ROOM_MATCH_STOP"
var0_0.ON_CLICK_READY = "PlayRoomCommonMediator::ON_CLICK_READY"
var0_0.ON_MATCH_CLICK_READY = "PlayRoomCommonMediator::ON_MATCH_CLICK_READY"
var0_0.ON_CLICK_QUICK_MATCH = "PlayRoomCommonMediator::ON_CLICK_QUICK_MATCH"

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)
	arg0_1:AppendPlayRoomNotificationHandleDic()
end

function var0_0.onRegister(arg0_2)
	var0_0.super.onRegister(arg0_2)
	arg0_2:registerPlayRoom()
end

function var0_0.AppendPlayRoomNotificationHandleDic(arg0_3)
	local var0_3 = arg0_3:initNotificationHandleDicPlayRoom()

	if arg0_3.handleDic == nil then
		return
	end

	for iter0_3, iter1_3 in pairs(var0_3) do
		if arg0_3.handleDic[iter0_3] == nil then
			arg0_3.handleDic[iter0_3] = iter1_3
		end
	end
end

function var0_0.registerPlayRoom(arg0_4)
	arg0_4:bind(var0_0.ON_CLICK_MATCH, function(arg0_5, arg1_5)
		arg0_4:sendNotification(GAME.PLAY_ROOM_CREATE_ROOM, arg1_5)
	end)
	arg0_4:bind(var0_0.REFRESH_ROOM_INFO, function(arg0_6)
		arg0_4:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM_INFO)
	end)
	arg0_4:bind(var0_0.PLAY_ROOM_MATCH_STOP, function(arg0_7)
		arg0_4:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM, {
			arg = 0
		})
	end)
	arg0_4:bind(var0_0.ON_CLICK_READY, function(arg0_8, arg1_8)
		arg0_4:sendNotification(GAME.PLAY_ROOM_READY, arg1_8)
	end)
	arg0_4:bind(var0_0.ON_MATCH_CLICK_READY, function(arg0_9, arg1_9)
		arg0_4:sendNotification(GAME.PLAY_ROOM_MATCH_READY, arg1_9)
	end)
	arg0_4:bind(var0_0.ON_CLICK_QUICK_MATCH, function(arg0_10, arg1_10)
		arg0_4:sendNotification(GAME.PLAY_ROOM_QUICK_MATCH, arg1_10)
	end)
end

function var0_0.initNotificationHandleDicPlayRoom(arg0_11)
	return {
		[GAME.PLAY_ROOM_CREATE_ROOM_DONE] = function()
			if getProxy(PlayRoomProxy):GetRoomData().roomType == PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
				arg0_11:sendNotification(GAME.PLAY_ROOM_START_GAME)
				existCall(arg0_11.viewComponent.OnStartMatch, arg0_11.viewComponent)
			end
		end,
		[GAME.PLAY_ROOM_START_GAME_DONE] = function()
			return
		end,
		[GAME.PLAY_ROOM_EXIT_MATCH_READY_ROOM] = function()
			return
		end,
		[GAME.PLAY_ROOM_READY_DONE] = function(arg0_15, arg1_15)
			existCall(arg0_15.viewComponent.RefreshUI, arg0_15.viewComponent)
		end,
		[GAME.PLAY_ROOM_MATCH_READY_DONE] = function(arg0_16, arg1_16)
			return
		end,
		[GAME.PLAY_ROOM_KICK_DONE] = function(arg0_17, arg1_17)
			existCall(arg0_17.viewComponent.RefreshUI, arg0_17.viewComponent)
		end,
		[GAME.PLAY_ROOM_EXIT_MATCH_READY_ROOM] = function(arg0_18, arg1_18)
			arg0_18:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM)
		end,
		[GAME.PLAY_ROOM_REFRESH_ROOM_INFO_DONE] = function()
			local var0_19 = getProxy(PlayRoomProxy):GetRoomData()

			if var0_19 then
				if var0_19.roomState == PlayRoomConst.PLAY_ROOM_STATE.PLAYING then
					IslandCheaterTavernRecordTools.StartGame()
					arg0_11:sendNotification(GAME.PLAY_ROOM_LOAD_MINIGAME_SCENE, {
						isReconecting = true,
						mapId = IslandConst.CheaterTavernMapId
					})
				elseif var0_19.roomType ~= PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
					arg0_11:sendNotification(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
				end
			end
		end,
		[GAME.PLAY_ROOM_EXIT_ROOM_DONE] = function()
			existCall(arg0_11.viewComponent.OnStopMatch, arg0_11.viewComponent)
		end,
		[GAME.PLAY_ROOM_QUICK_MATCH_DONE] = function()
			existCall(arg0_11.viewComponent.OnQuickMatch, arg0_11.viewComponent)
		end,
		[GAME.PLAY_ROOM_QUICK_MATCH_SUCCESS] = function()
			existCall(arg0_11.viewComponent.OnQuickMatchSuccess, arg0_11.viewComponent)
		end
	}
end

return var0_0
