local var0_0 = class("ActivityUnlockStoryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	assert(var1_1)

	local var2_1 = var1_1:getConfig("type")

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

			var0_2.data1 = var0_2.data1 - 1

			getProxy(ActivityProxy):updateActivity(var0_2)
			arg0_1:sendNotification(TownSkinMediator.UnlockStoryDone, {
				storyId = var0_1.arg1
			})
		end
	end)
end

return var0_0
