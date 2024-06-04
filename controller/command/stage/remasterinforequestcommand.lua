local var0 = class("RemasterInfoRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(13505, {
		type = 0
	}, 13506, function(arg0)
		local var0 = getProxy(ChapterProxy).remasterInfo

		for iter0, iter1 in ipairs(arg0.remap_count_list) do
			if var0[iter1.chapter_id][iter1.pos] then
				var0[iter1.chapter_id][iter1.pos].count = iter1.count
				var0[iter1.chapter_id][iter1.pos].receive = iter1.flag > 0
			end
		end

		arg0:sendNotification(GAME.CHAPTER_REMASTER_INFO_REQUEST_DONE)
	end)
end

return var0
