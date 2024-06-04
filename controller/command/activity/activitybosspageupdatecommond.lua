local var0 = class("ActivityBossPageUpdateCommond", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var1 or var1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(26031, {
		act_id = var1.id
	}, 26032, function(arg0)
		if arg0.result == 0 then
			var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

			if not var1 or var1:isEnd() then
				return
			end

			var1:UpdatePublicData(arg0)
			getProxy(ActivityProxy):updateActivity(var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
