local var0 = class("Challenge2SettleRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE)

	if not var1 or var1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(24009, {
		activity_id = var1.id
	}, 24010, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.CHALLENGE2_SETTLE_DONE)
		end
	end)
end

return var0
