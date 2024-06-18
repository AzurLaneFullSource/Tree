local var0_0 = class("Challenge2SettleRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(24009, {
		activity_id = var1_1.id
	}, 24010, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.CHALLENGE2_SETTLE_DONE)
		end
	end)
end

return var0_0
