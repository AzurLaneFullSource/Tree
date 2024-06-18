local var0_0 = class("GetChapterDropShipListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.chapterId
	local var2_1 = var0_1.callback

	assert(var1_1)

	local var3_1 = getProxy(ChapterProxy)

	if not var3_1.FectchDropShipListFlags then
		var3_1.FectchDropShipListFlags = {}
	end

	if not var3_1.FectchDropShipListFlags[var1_1] then
		pg.ConnectionMgr.GetInstance():Send(13109, {
			id = var1_1
		}, 13110, function(arg0_2)
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.drop_ship_list) do
				table.insert(var0_2, iter1_2)
			end

			local var1_2 = var3_1:getChapterById(var1_1)

			var1_2:UpdateDropShipList(var0_2)

			var3_1.FectchDropShipListFlags[var1_1] = true

			var3_1:updateChapter(var1_2)

			local var2_2 = var1_2:GetDropShipList()

			if var2_1 then
				var2_1(var2_2)
			end

			arg0_1:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST_DONE, {
				shipIds = var2_2
			})
		end)
	else
		local var4_1 = var3_1:getChapterById(var1_1):GetDropShipList()

		if var2_1 then
			var2_1(var4_1)
		end

		arg0_1:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST_DONE, {
			shipIds = var4_1
		})
	end
end

return var0_0
