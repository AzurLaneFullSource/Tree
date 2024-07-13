local var0_0 = class("BuildPoolExchangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activity_id
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)

	if not var1_1 or var1_1:isEnd() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg1 = 0,
		arg2 = 0,
		cmd = 2,
		activity_id = var0_1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1.data2 = var1_1.data2 + 1

			getProxy(ActivityProxy):updateActivity(var1_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			arg0_1:sendNotification(GAME.ACTIVITY_BUILD_POOL_EXCHANGE_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
