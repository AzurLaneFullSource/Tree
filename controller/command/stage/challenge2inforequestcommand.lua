local var0_0 = class("Challenge2InfoRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
	local var2_1 = getProxy(ChallengeProxy)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(24004, {
		activity_id = var1_1.id
	}, 24005, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:updateSeasonChallenge(arg0_2.current_challenge)

			for iter0_2, iter1_2 in ipairs(arg0_2.user_challenge) do
				var2_1:updateCurrentChallenge(iter1_2)
			end

			if var0_1 then
				var0_1()
			end

			arg0_1:sendNotification(GAME.CHALLENGE2_INFO_DONE)
		else
			originalPrint("reqquest challenge info fail, data.result: " .. arg0_2.result)
		end
	end)
end

return var0_0
