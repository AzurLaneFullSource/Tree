local var0 = class("ClickMingShiCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(PlayerProxy)
	local var2 = var1:getData()

	var2.mingshiCount = var2.mingshiCount + 1

	local var3 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if var3 and not var3:isEnd() and not LOCK_CLICK_MINGSHI and getProxy(TaskProxy):getmingshiTaskID(var2.mingshiCount) > 0 then
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = mingshiActivityId
		})
	end

	if var2.mingshiflag >= 2 then
		var1:updatePlayer(var2)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11506, {
		state = 0
	}, 11507, function(arg0)
		if arg0.result == 0 then
			var2.chargeExp = var2.chargeExp + 5
			var2.mingshiflag = var2.mingshiflag + 1

			arg0:sendNotification(GAME.CLICK_MING_SHI_SUCCESS)
		else
			var2.mingshiflag = 2
		end

		var1:updatePlayer(var2)
	end)
end

return var0
