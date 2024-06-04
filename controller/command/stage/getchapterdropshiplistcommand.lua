local var0 = class("GetChapterDropShipListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.chapterId
	local var2 = var0.callback

	assert(var1)

	local var3 = getProxy(ChapterProxy)

	if not var3.FectchDropShipListFlags then
		var3.FectchDropShipListFlags = {}
	end

	if not var3.FectchDropShipListFlags[var1] then
		pg.ConnectionMgr.GetInstance():Send(13109, {
			id = var1
		}, 13110, function(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.drop_ship_list) do
				table.insert(var0, iter1)
			end

			local var1 = var3:getChapterById(var1)

			var1:UpdateDropShipList(var0)

			var3.FectchDropShipListFlags[var1] = true

			var3:updateChapter(var1)

			local var2 = var1:GetDropShipList()

			if var2 then
				var2(var2)
			end

			arg0:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST_DONE, {
				shipIds = var2
			})
		end)
	else
		local var4 = var3:getChapterById(var1):GetDropShipList()

		if var2 then
			var2(var4)
		end

		arg0:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST_DONE, {
			shipIds = var4
		})
	end
end

return var0
