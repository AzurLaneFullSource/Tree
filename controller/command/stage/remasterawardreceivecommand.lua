local var0_0 = class("RemasterAwardReceiveCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.chapterId
	local var2_1 = var0_1.pos
	local var3_1 = var0_1.actId or 0
	local var4_1 = getProxy(ChapterProxy)
	local var5_1 = var4_1:getRemasterInfo(var3_1, var1_1, var2_1)

	if not var5_1 or var5_1.receive then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(13507, {
		chapter_id = var1_1,
		pos = var2_1,
		act_id = var3_1
	}, 13508, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:markRemasterPassReceive(var1_1, var2_1, var3_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.CHAPTER_REMASTER_AWARD_RECEIVE_DONE, var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
