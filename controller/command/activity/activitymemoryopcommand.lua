local var0_0 = class("ActivityMemoryOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.actId
	local var3_1 = getProxy(ActivityProxy)
	local var4_1 = getProxy(ActivityProxy):getActivityById(var2_1)
	local var5_1 = var0_1.awardCallback

	if not var4_1 or var4_1:isEnd() then
		return
	end

	if not table.contains(var4_1.data1_list, var1_1) then
		return
	end

	if table.contains(var4_1.data2_list, var1_1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		arg2 = 0,
		activity_id = var2_1,
		arg1 = var1_1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			table.insert(var4_1.data2_list, var1_1)
			var3_1:updateActivity(var4_1)
			arg0_1:sendNotification(GAME.MEMORYBOOK_UNLOCK_DONE, var1_1)

			if arg0_2.award_list then
				if var5_1 then
					var5_1(PlayerConst.addTranDrop(arg0_2.award_list))
				else
					arg0_1:sendNotification(GAME.MEMORYBOOK_UNLOCK_AWARD_DONE, {
						awards = PlayerConst.addTranDrop(arg0_2.award_list)
					})
				end
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
