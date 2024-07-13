local var0_0 = class("RemasterInfoRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	pg.ConnectionMgr.GetInstance():Send(13505, {
		type = 0
	}, 13506, function(arg0_2)
		local var0_2 = getProxy(ChapterProxy).remasterInfo

		for iter0_2, iter1_2 in ipairs(arg0_2.remap_count_list) do
			if var0_2[iter1_2.chapter_id][iter1_2.pos] then
				var0_2[iter1_2.chapter_id][iter1_2.pos].count = iter1_2.count
				var0_2[iter1_2.chapter_id][iter1_2.pos].receive = iter1_2.flag > 0
			end
		end

		arg0_1:sendNotification(GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE)
	end)
end

return var0_0
