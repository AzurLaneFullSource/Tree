local var0_0 = class("PlayRoomInfoInviteMediator", import("view.base.ContextMediator"))

var0_0.ON_CLICK_INVITE = "PlayRoomInfoInviteMediator::ON_CLICK_INVITE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLICK_INVITE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.PLAY_ROOM_INVITE, arg1_2)
	end)
	getProxy(PlayRoomProxy):GetInviteRecordList()
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.PLAY_ROOM_INVITE_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	switch(var0_4, {
		[GAME.PLAY_ROOM_INVITE_DONE] = function(arg0_5)
			arg0_4.viewComponent:RefreshItem()
		end
	})
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
