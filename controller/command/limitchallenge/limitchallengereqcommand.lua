local var0_0 = class("LimitChallengeReqCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = {
		type = 1
	}

	pg.ConnectionMgr.GetInstance():Send(24020, var1_1, 24021, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(LimitChallengeProxy)

			var0_2:setTimeDataFromServer(arg0_2.times)
			var0_2:setAwardedDataFromServer(arg0_2.awards)
			var0_2:setCurMonthPassedIDList(arg0_2.pass_ids)
			arg0_1:sendNotification(LimitChallengeConst.REQ_CHALLENGE_INFO_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
