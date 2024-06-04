local var0 = class("MangaFullScreenMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.APPRECIATE_MANGA_READ_DONE,
		GAME.APPRECIATE_MANGA_LIKE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.APPRECIATE_MANGA_READ_DONE then
		local var2 = var1.mangaID

		if arg0.contextData.mangaContext then
			arg0.contextData.mangaContext:updateLineAfterRead(var2)
		end
	elseif var0 == GAME.APPRECIATE_MANGA_LIKE_DONE then
		arg0.viewComponent:updateLikeBtn()
	end
end

return var0
