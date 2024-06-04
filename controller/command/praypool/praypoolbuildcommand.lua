local var0 = class("PrayPoolBuildCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.pooltype
	local var2 = var0.shipIDList

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = ActivityConst.ACTIVITY_PRAY_POOL,
		arg1 = var1,
		arg2 = var2[1],
		arg3 = var2[2],
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			getProxy(PrayProxy):updatePageState(PrayProxy.STAGE_BUILD_SUCCESS)
			arg0:sendNotification(PrayPoolConst.BUILD_PRAY_POOL_SUCCESS, PrayProxy.STAGE_BUILD_SUCCESS)
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_pray_build_pool_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_pray_build_pool_fail"))
		end
	end)
end

return var0
