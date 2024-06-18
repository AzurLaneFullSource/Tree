local var0_0 = class("EmojiMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	if not getProxy(EmojiProxy):getInitedTag() then
		arg0_1:sendNotification(GAME.REQUEST_EMOJI_INFO_FROM_SERVER)
	end
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.REQUEST_EMOJI_INFO_FROM_SERVER_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	return
end

return var0_0
