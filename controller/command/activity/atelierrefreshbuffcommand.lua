local var0_0 = class("AtelierRefreshBuffCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var1_1)

	local var2_1 = {}

	table.Foreach(var0_1, function(arg0_2, arg1_2)
		if arg1_2[1] == 0 then
			return
		end

		table.insert(var2_1, {
			pos = arg0_2,
			itemid = arg1_2[1],
			itemnum = arg1_2[2]
		})
	end)
	pg.ConnectionMgr.GetInstance():Send(26055, {
		act_id = var1_1.id,
		slots = var2_1
	}, 26056, function(arg0_3)
		if arg0_3.result == 0 then
			var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			var1_1:UpdateBuffSlots(var2_1)
			getProxy(ActivityProxy):updateActivity(var1_1)
			arg0_1:sendNotification(GAME.UPDATE_ATELIER_BUFF_DONE, var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_3.result))
		end
	end)
end

return var0_0
