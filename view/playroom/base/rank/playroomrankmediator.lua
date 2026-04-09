local var0_0 = class("PlayRoomRankMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:sendNotification(GAME.PLAY_ROOM_REFRESH_RANK, {
		gameType = arg0_1.contextData.gameType
	})
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.PLAY_ROOM_REFRESH_RANK_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	switch(var0_3, {
		[GAME.PLAY_ROOM_REFRESH_RANK_DONE] = function(arg0_4)
			arg0_3.viewComponent:RefreshUI()
		end
	})
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
