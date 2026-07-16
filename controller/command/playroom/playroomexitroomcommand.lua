local var0_0 = class("PlayRoomExitRoomCommand", pm.SimpleCommand)

var0_0.PLAY_ROOM_EXIT_ROOM_DONE = "PlayRoomExitRoomCommand:PLAY_ROOM_EXIT_ROOM_DONE"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(IslandProxy):GetIsland()

	pg.ConnectionMgr.GetInstance():Send(23011, {
		arg = 1
	}, 23012, function(arg0_2)
		local var0_2 = getProxy(PlayRoomProxy)

		var0_2:ExitRoom()
		var0_2:SetMatchCD(arg0_2.time)
		existCall(arg1_1:getBody().callback)
		arg0_1:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM_DONE)

		if var0_1 then
			var0_1:DispatchEvent(var0_0.PLAY_ROOM_EXIT_ROOM_DONE)
		end
	end)
end

return var0_0
