local var0 = class("Challenge2InfoRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)
	local var2 = getProxy(ChallengeProxy)

	if not var1 or var1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(24004, {
		activity_id = var1.id
	}, 24005, function(arg0)
		if arg0.result == 0 then
			var2:updateSeasonChallenge(arg0.current_challenge)

			for iter0, iter1 in ipairs(arg0.user_challenge) do
				var2:updateCurrentChallenge(iter1)
			end

			if var0 then
				var0()
			end

			arg0:sendNotification(GAME.CHALLENGE2_INFO_DONE)
		else
			originalPrint("reqquest challenge info fail, data.result: " .. arg0.result)
		end
	end)
end

return var0
