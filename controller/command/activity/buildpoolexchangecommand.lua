local var0 = class("BuildPoolExchangeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().activity_id
	local var1 = getProxy(ActivityProxy):getActivityById(var0)

	if not var1 or var1:isEnd() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg1 = 0,
		arg2 = 0,
		cmd = 2,
		activity_id = var0,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			var1.data2 = var1.data2 + 1

			getProxy(ActivityProxy):updateActivity(var1)

			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			arg0:sendNotification(GAME.ACTIVITY_BUILD_POOL_EXCHANGE_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
