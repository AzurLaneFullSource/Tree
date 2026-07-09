local var0_0 = class("ActivityPermanentStartCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activity_id
	local var1_1 = getProxy(ActivityPermanentProxy)
	local var2_1 = var1_1:GetActivityTypeById(var0_1)
	local var3_1 = var2_1 and var1_1:getDoingActivityId(var2_1)

	local function var4_1()
		if var3_1 == var0_1 then
			arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_START_DONE, {
				id = var0_1
			})

			return
		end

		pg.ConnectionMgr.GetInstance():Send(11206, {
			activity_id = var0_1
		}, 11207, function(arg0_3)
			if arg0_3.result == 0 then
				var1_1:startSelectActivity(var0_1)
				arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_START_DONE, {
					id = var0_1
				})
			else
				warning("error permanent")
			end
		end)
	end

	local function var5_1(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_STOP, {
			activity_id = arg0_4,
			callback = arg1_4
		})
	end

	if var3_1 and var3_1 ~= var0_1 then
		var5_1(var3_1, var4_1)
	else
		var4_1()
	end
end

return var0_0
