local var0_0 = class("ActivityBossPageUpdateCommond", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(26031, {
		act_id = var1_1.id
	}, 26032, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

			if not var1_1 or var1_1:isEnd() then
				return
			end

			var1_1:UpdatePublicData(arg0_2)
			getProxy(ActivityProxy):updateActivity(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
