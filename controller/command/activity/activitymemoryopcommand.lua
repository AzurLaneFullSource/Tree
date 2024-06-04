local var0 = class("ActivityMemoryOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.actId
	local var3 = getProxy(ActivityProxy)
	local var4 = getProxy(ActivityProxy):getActivityById(var2)
	local var5 = var0.awardCallback

	if not var4 or var4:isEnd() then
		return
	end

	if not table.contains(var4.data1_list, var1) then
		return
	end

	if table.contains(var4.data2_list, var1) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		arg2 = 0,
		activity_id = var2,
		arg1 = var1,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			table.insert(var4.data2_list, var1)
			var3:updateActivity(var4)
			arg0:sendNotification(GAME.MEMORYBOOK_UNLOCK_DONE, var1)

			if arg0.award_list then
				if var5 then
					var5(PlayerConst.addTranDrop(arg0.award_list))
				else
					arg0:sendNotification(GAME.MEMORYBOOK_UNLOCK_AWARD_DONE, {
						awards = PlayerConst.addTranDrop(arg0.award_list)
					})
				end
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
