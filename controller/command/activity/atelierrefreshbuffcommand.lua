local var0 = class("AtelierRefreshBuffCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

	assert(var1)

	local var2 = {}

	table.Foreach(var0, function(arg0, arg1)
		if arg1[1] == 0 then
			return
		end

		table.insert(var2, {
			pos = arg0,
			itemid = arg1[1],
			itemnum = arg1[2]
		})
	end)
	pg.ConnectionMgr.GetInstance():Send(26055, {
		act_id = var1.id,
		slots = var2
	}, 26056, function(arg0)
		if arg0.result == 0 then
			var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			var1:UpdateBuffSlots(var2)
			getProxy(ActivityProxy):updateActivity(var1)
			arg0:sendNotification(GAME.UPDATE_ATELIER_BUFF_DONE, var1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
