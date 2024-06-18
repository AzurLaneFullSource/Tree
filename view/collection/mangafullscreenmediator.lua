local var0_0 = class("MangaFullScreenMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.APPRECIATE_MANGA_READ_DONE,
		GAME.APPRECIATE_MANGA_LIKE_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.APPRECIATE_MANGA_READ_DONE then
		local var2_3 = var1_3.mangaID

		if arg0_3.contextData.mangaContext then
			arg0_3.contextData.mangaContext:updateLineAfterRead(var2_3)
		end
	elseif var0_3 == GAME.APPRECIATE_MANGA_LIKE_DONE then
		arg0_3.viewComponent:updateLikeBtn()
	end
end

return var0_0
