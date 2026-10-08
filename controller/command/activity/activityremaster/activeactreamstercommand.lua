local var0_0 = class("ActiveActReamsterCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1, var2_1 = getProxy(ActivityRemasterProxy):InActTime()

	if not var1_1 then
		return
	end

	if getProxy(ActivityRemasterProxy):IsActivating() then
		return
	end

	if not getProxy(ActivityRemasterProxy):CanActiveRemaster(var0_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("act_remaster_active_erro"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11214, {
		activity_re_id = var0_1
	}, 11215, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(ActivityRemasterProxy):ActiveActivity(var0_1, var2_1)
			arg0_1:sendNotification(GAME.ACT_REMASTER_ACTIVE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
