local var0_0 = class("PrayPoolBuildCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.pooltype
	local var2_1 = var0_1.shipIDList

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = ActivityConst.ACTIVITY_PRAY_POOL,
		arg1 = var1_1,
		arg2 = var2_1[1],
		arg3 = var2_1[2],
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(PrayProxy):updatePageState(PrayProxy.STAGE_BUILD_SUCCESS)
			arg0_1:sendNotification(PrayPoolConst.BUILD_PRAY_POOL_SUCCESS, PrayProxy.STAGE_BUILD_SUCCESS)
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_pray_build_pool_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_pray_build_pool_fail"))
		end
	end)
end

return var0_0
