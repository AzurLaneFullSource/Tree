local var0_0 = class("CollabrateBossRushRequestDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body.actId

	pg.ConnectionMgr.GetInstance():Send(26081, {
		act_id = var0_1
	}, 26082, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1)
			local var1_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.boss_list) do
				var1_2[iter1_2.id] = {
					hpRate = iter1_2.boss_hp,
					deathTimeStamp = iter1_2.death,
					trafficPerHour = iter1_2.hour_traffic,
					damagePerHour = iter1_2.hour_off
				}
			end

			var0_2:UpdateCollabrateBossData(var1_2)
			getProxy(ActivityProxy):updateActivity(var0_2)
			arg0_1:sendNotification(GAME.COLLABRATE_BOSS_RUSH_REQUEST_DATA_DONE, arg0_2.result)
		end
	end)
end

return var0_0
