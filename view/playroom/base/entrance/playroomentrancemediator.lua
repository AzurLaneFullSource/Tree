local var0_0 = class("PlayRoomEntranceMediator", import("view.base.ContextMediator"))

var0_0.ON_CLICK_MATCH = "PlayRoomEntranceMediator:ON_CLICK_MATCH"
var0_0.REFRESH_ROOM_INFO = "PlayRoomEntranceMediator:REFRESH_ROOM_INFO"
var0_0.ON_CLICK_CHANGE_CHARACTER = "PlayRoomEntranceMediator:ON_CLICK_CHANGE_CHARACTER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLICK_MATCH, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.PLAY_ROOM_CREATE_ROOM, arg1_2)
	end)
	arg0_1:bind(var0_0.REFRESH_ROOM_INFO, function()
		arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_ROOM_INFO)
	end)
	arg0_1:bind(var0_0.ON_CLICK_CHANGE_CHARACTER, function()
		arg0_1:sendNotification(CheaterTavernEvent.OPEN_SELECT_SHIP, IslandCheaterTavernConst.ChangeDressType.OutRoom)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.PLAY_ROOM_CREATE_ROOM_DONE,
		GAME.PLAY_ROOM_START_GAME_DONE,
		GAME.PLAY_ROOM_EXIT_MATCH_READY_ROOM,
		GAME.PLAY_ROOM_REFRESH_ROOM_INFO_DONE,
		GAME.PLAY_ROOM_EXIT_ROOM_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	switch(var0_6, {
		[GAME.PLAY_ROOM_CREATE_ROOM_DONE] = function()
			if getProxy(PlayRoomProxy):GetRoomData().roomType == PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
				arg0_6:sendNotification(GAME.PLAY_ROOM_START_GAME)
				arg0_6.viewComponent:OnStartMatch()
			end
		end,
		[GAME.PLAY_ROOM_START_GAME_DONE] = function()
			return
		end,
		[GAME.PLAY_ROOM_EXIT_MATCH_READY_ROOM] = function()
			return
		end,
		[GAME.PLAY_ROOM_REFRESH_ROOM_INFO_DONE] = function()
			local var0_10 = getProxy(PlayRoomProxy):GetRoomData()

			if var0_10 then
				if var0_10.roomState == PlayRoomConst.PLAY_ROOM_STATE.PLAYING then
					IslandCheaterTavernRecordTools.StartGame()
					arg0_6:sendNotification(GAME.PLAY_ROOM_LOAD_MINIGAME_SCENE, {
						isReconecting = true,
						mapId = IslandConst.CheaterTavernMapId
					})
				elseif var0_10.roomType ~= PlayRoomConst.PLAY_ROOM_TYPE.MATCH then
					arg0_6:sendNotification(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
				end
			end
		end,
		[GAME.PLAY_ROOM_EXIT_ROOM_DONE] = function()
			arg0_6.viewComponent:OnStopMatch()
		end
	})
end

function var0_0.remove(arg0_12)
	return
end

return var0_0
