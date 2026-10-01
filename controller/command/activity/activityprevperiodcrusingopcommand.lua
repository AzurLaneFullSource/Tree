local var0_0 = class("ActivityPrevPeriodCrusingOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var2_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if not var3_1 or var3_1:isEnd() then
		if var1_1 then
			var1_1()
		end

		return
	end

	local var4_1 = var3_1:GetPreviousPeriodAct()

	if not var4_1 or var4_1.id ~= var0_1.activity_id then
		if var1_1 then
			var1_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var3_1.id,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			if var0_1.cmd == 1 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

				var4_1:SyncAwardRecords(pg.black_friday_battlepass_event_pt[var4_1.id])
			elseif var0_1.cmd == 2 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

				var4_1:AddAwardRecord(var0_1.arg1)
			elseif var0_1.cmd == 3 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

				var4_1:AddPayAwardRecord(var0_1.arg1)
			elseif var0_1.cmd == 4 or var0_1.cmd == 5 then
				var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

				var4_1:SyncAwardRecords()
			end

			var3_1:UpdatePreviousPeriodAct()
			var2_1:updateActivity(var3_1)
			arg0_1:sendNotification(GAME.CRUSING_CMD_DONE, {
				awards = var0_2,
				callback = var1_1
			})
		else
			if var1_1 then
				var1_1()
			end

			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
