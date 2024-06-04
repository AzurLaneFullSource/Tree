local var0 = class("Challenge2ResetRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().mode
	local var1 = arg1:getBody().isInfiniteSeasonClear
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	if not var2 or var2:isEnd() then
		return
	end

	local var3 = getProxy(ChallengeProxy)

	pg.ConnectionMgr.GetInstance():Send(24011, {
		activity_id = var2.id,
		mode = var0
	}, 24012, function(arg0)
		if arg0.result == 0 then
			var3:getUserChallengeInfoList()[var0] = nil

			if var1 == true then
				var3:setCurMode(ChallengeProxy.MODE_CASUAL)
			end

			arg0:sendNotification(GAME.CHALLENGE2_RESET_DONE)
		end
	end)
end

return var0
