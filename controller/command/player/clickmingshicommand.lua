local var0_0 = class("ClickMingShiCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = var1_1:getData()

	var2_1.mingshiCount = var2_1.mingshiCount + 1

	local var3_1 = getProxy(ActivityProxy):getActivityById(mingshiActivityId)

	if var3_1 and not var3_1:isEnd() and not LOCK_CLICK_MINGSHI and getProxy(TaskProxy):getmingshiTaskID(var2_1.mingshiCount) > 0 then
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = mingshiActivityId
		})
	end

	if var2_1.mingshiflag >= 2 then
		var1_1:updatePlayer(var2_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11506, {
		state = 0
	}, 11507, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1.chargeExp = var2_1.chargeExp + 5
			var2_1.mingshiflag = var2_1.mingshiflag + 1

			arg0_1:sendNotification(GAME.CLICK_MING_SHI_SUCCESS)
		else
			var2_1.mingshiflag = 2
		end

		var1_1:updatePlayer(var2_1)
	end)
end

return var0_0
