local var0 = class("RemasterAwardReceiveCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.chapterId
	local var2 = var0.pos
	local var3 = getProxy(ChapterProxy)
	local var4 = var3.remasterInfo[var1]

	if not var4 or var4.receive then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(13507, {
		chapter_id = var1,
		pos = var2
	}, 13508, function(arg0)
		if arg0.result == 0 then
			var3:markRemasterPassReceive(var1, var2)

			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			arg0:sendNotification(GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
