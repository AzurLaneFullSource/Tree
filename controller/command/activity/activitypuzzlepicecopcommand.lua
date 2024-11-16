local var0_0 = class("ActivityPuzzlePicecOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id or 0
	local var2_1 = var0_1.cmd
	local var3_1 = var0_1.actId
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(ActivityProxy)
	local var6_1 = getProxy(ActivityProxy):getActivityById(var3_1)

	if not var6_1 or var6_1:isEnd() then
		return
	end

	local var7_1 = pg.activity_event_picturepuzzle[var3_1]

	if not var7_1 then
		return
	end

	if var2_1 == PuzzleActivity.CMD_COMPLETE then
		if #var6_1.data2_list > #var7_1.pickup_picturepuzzle + #var7_1.drop_picturepuzzle then
			return
		end

		if var6_1.data1 ~= 0 then
			return
		end

		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = var3_1,
			cmd = PuzzleActivity.CMD_COMPLETE
		})

		return
	elseif var2_1 == PuzzleActivity.CMD_ACTIVATE then
		if not table.contains(var6_1.data1_list, var1_1) and not table.contains(var7_1.pickup_picturepuzzle, var1_1) then
			return
		end

		if table.contains(var6_1.data2_list, var1_1) then
			return
		end
	elseif var2_1 == PuzzleActivity.CMD_UNLCOK_TIP then
		if table.contains(var6_1.data3_list, var1_1) then
			return
		end

		if pg.TimeMgr.GetInstance():GetServerTime() < var6_1.data2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

			return
		end
	elseif var2_1 == PuzzleActivity.CMD_EARN_EXTRA then
		if var6_1.data1 ~= 1 then
			return
		end

		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 4,
			activity_id = var3_1
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg2 = 0,
		activity_id = var3_1,
		cmd = var2_1,
		arg1 = var1_1,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			var6_1 = getProxy(ActivityProxy):getActivityById(var3_1)

			if var2_1 == PuzzleActivity.CMD_COMPLETE then
				var6_1.data1 = 1
			elseif var2_1 == PuzzleActivity.CMD_ACTIVATE then
				table.insert(var6_1.data2_list, var1_1)
			elseif var2_1 == PuzzleActivity.CMD_UNLCOK_TIP then
				table.insert(var6_1.data3_list, var1_1)

				var6_1.data2 = pg.TimeMgr.GetInstance():GetServerTime() + var7_1.cd
			elseif var2_1 == PuzzleActivity.CMD_EARN_EXTRA then
				var6_1.data1 = 2
			end

			var5_1:updateActivity(var6_1)

			if var4_1 then
				var4_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
