local var0 = class("MangaReadCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.mangaID
	local var2 = var0.mangaCB
	local var3 = getProxy(AppreciateProxy)

	print("17509 Send Manga ID", var1)
	pg.ConnectionMgr.GetInstance():Send(17509, {
		id = var1
	}, 17510, function(arg0)
		if arg0.result == 0 then
			var3:addMangaIDToReadList(var1)

			if var2 then
				var2()
			end

			arg0:sendNotification(GAME.APPRECIATE_MANGA_READ_DONE, {
				mangaID = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("17510 Manga Read Fail" .. tostring(arg0.result))
		end
	end)
end

return var0
