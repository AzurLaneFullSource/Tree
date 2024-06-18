local var0_0 = class("Challenge2ResetRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().mode
	local var1_1 = arg1_1:getBody().isInfiniteSeasonClear
	local var2_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	local var3_1 = getProxy(ChallengeProxy)

	pg.ConnectionMgr.GetInstance():Send(24011, {
		activity_id = var2_1.id,
		mode = var0_1
	}, 24012, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:getUserChallengeInfoList()[var0_1] = nil

			if var1_1 == true then
				var3_1:setCurMode(ChallengeProxy.MODE_CASUAL)
			end

			arg0_1:sendNotification(GAME.CHALLENGE2_RESET_DONE)
		end
	end)
end

return var0_0
