local var0_0 = class("PlayRoomInfoViewerMediator", import("view.base.ContextMediator"))

var0_0.ON_CLICK_SWITCH = "PlayRoomInfoViewerMediator::ON_CLICK_SWITCH"
var0_0.ON_CLICK_KICK = "PlayRoomInfoViewerMediator::ON_CLICK_KICK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLICK_SWITCH, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.PLAY_ROOM_SWITCH_VIEWER, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_CLICK_KICK, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.PLAY_ROOM_KICK, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.PLAY_ROOM_SWITCH_VIEWER_DONE,
		GAME.PLAY_ROOM_KICK_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	switch(var0_5, {
		[GAME.PLAY_ROOM_SWITCH_VIEWER_DONE] = function()
			arg0_5.viewComponent:RefreshUI()
		end,
		[GAME.PLAY_ROOM_KICK_DONE] = function()
			arg0_5.viewComponent:RefreshUI()
		end
	})
end

function var0_0.remove(arg0_8)
	return
end

return var0_0
