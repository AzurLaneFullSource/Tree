local var0_0 = class("FetchNpcShipActivityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if var2_1.data1 > 0 then
		existCall(var1_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg1 = 0,
		arg2 = 0,
		cmd = 1,
		activity_id = var0_1.activity_id,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.GetTranAwards(var0_1, arg0_2)
			local var1_2 = getProxy(BayProxy):getActivityNPCShipByActId(var2_1.id)

			var2_1.data1 = 1
			var2_1.data2 = var1_2

			getProxy(ActivityProxy):updateActivity(var2_1)
			arg0_1:sendNotification(GAME.FETCH_NPC_SHIP_ACTIVITY_DONE, {
				items = var0_2,
				callback = var1_1
			})
		else
			originalPrint(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
