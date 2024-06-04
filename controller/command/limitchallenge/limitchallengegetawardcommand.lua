local var0 = class("LimitChallengeGetAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = {
		challengeids = var0.challengeIDList
	}

	pg.ConnectionMgr.GetInstance():Send(24022, var1, 24023, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(LimitChallengeProxy)

			for iter0, iter1 in ipairs(var0.challengeIDList) do
				var0:setAwarded(iter1)
			end

			local var1 = PlayerConst.addTranDrop(arg0.drop_list)

			pg.m02:sendNotification(LimitChallengeConst.GET_CHALLENGE_AWARD_DONE, {
				awards = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
