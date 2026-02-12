local var0_0 = class("GetLoveLetterLevelRewardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().list

	if not getProxy(LoveLetterProxy):CanGetReward(var0_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12402, {
		id_list = var0_1
	}, 12403, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(LoveLetterProxy):MarkReward(var0_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			pg.m02:sendNotification(GAME.GET_LOVE_LETTER_REWARD_DONE, {
				list = var0_1,
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
