local var0_0 = class("LimitChallengeGetAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = {
		challengeids = var0_1.challengeIDList
	}

	pg.ConnectionMgr.GetInstance():Send(24022, var1_1, 24023, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(LimitChallengeProxy)

			for iter0_2, iter1_2 in ipairs(var0_1.challengeIDList) do
				var0_2:setAwarded(iter1_2)
			end

			local var1_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			pg.m02:sendNotification(LimitChallengeConst.GET_CHALLENGE_AWARD_DONE, {
				awards = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
