local var0 = class("MangaLikeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.mangaID
	local var2 = var0.action
	local var3 = var0.mangaCB
	local var4 = getProxy(AppreciateProxy)

	print("17511 Send Manga ID", var1)
	pg.ConnectionMgr.GetInstance():Send(17511, {
		id = var1,
		action = var2
	}, 17512, function(arg0)
		if arg0.result == 0 then
			if var2 == MangaConst.SET_MANGA_LIKE then
				var4:addMangaIDToLikeList(var1)
			else
				var4:removeMangaIDFromLikeList(var1)
			end

			if var3 then
				var3()
			end

			arg0:sendNotification(GAME.APPRECIATE_MANGA_LIKE_DONE, {
				mangaID = var1,
				action = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("17512 Manga Like Fail:" .. tostring(arg0.result))
		end
	end)
end

return var0
