local var0_0 = class("MangaReadCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.mangaID
	local var2_1 = var0_1.mangaCB
	local var3_1 = getProxy(AppreciateProxy)

	print("17509 Send Manga ID", var1_1)
	pg.ConnectionMgr.GetInstance():Send(17509, {
		id = var1_1
	}, 17510, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:addMangaIDToReadList(var1_1)

			if var2_1 then
				var2_1()
			end

			arg0_1:sendNotification(GAME.APPRECIATE_MANGA_READ_DONE, {
				mangaID = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("17510 Manga Read Fail" .. tostring(arg0_2.result))
		end
	end)
end

return var0_0
