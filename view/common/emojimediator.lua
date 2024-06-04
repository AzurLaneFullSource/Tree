local var0 = class("EmojiMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	if not getProxy(EmojiProxy):getInitedTag() then
		arg0:sendNotification(GAME.REQUEST_EMOJI_INFO_FROM_SERVER)
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.REQUEST_EMOJI_INFO_FROM_SERVER_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	return
end

return var0
