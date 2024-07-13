local var0_0 = class("MangaLikeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.mangaID
	local var2_1 = var0_1.action
	local var3_1 = var0_1.mangaCB
	local var4_1 = getProxy(AppreciateProxy)

	print("17511 Send Manga ID", var1_1)
	pg.ConnectionMgr.GetInstance():Send(17511, {
		id = var1_1,
		action = var2_1
	}, 17512, function(arg0_2)
		if arg0_2.result == 0 then
			if var2_1 == MangaConst.SET_MANGA_LIKE then
				var4_1:addMangaIDToLikeList(var1_1)
			else
				var4_1:removeMangaIDFromLikeList(var1_1)
			end

			if var3_1 then
				var3_1()
			end

			arg0_1:sendNotification(GAME.APPRECIATE_MANGA_LIKE_DONE, {
				mangaID = var1_1,
				action = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("17512 Manga Like Fail:" .. tostring(arg0_2.result))
		end
	end)
end

return var0_0
