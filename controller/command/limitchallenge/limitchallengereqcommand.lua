local var0 = class("LimitChallengeReqCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = {
		type = 1
	}

	pg.ConnectionMgr.GetInstance():Send(24020, var1, 24021, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(LimitChallengeProxy)

			var0:setTimeDataFromServer(arg0.times)
			var0:setAwardedDataFromServer(arg0.awards)
			var0:setCurMonthPassedIDList(arg0.pass_ids)
			arg0:sendNotification(LimitChallengeConst.REQ_CHALLENGE_INFO_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
