local var0_0 = class("SculptureActivityOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.state
	local var3_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

	if not var3_1 or var3_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var4_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if not var4_1 or var4_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not var3_1:CanEnterState(var1_1, var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	if var2_1 == SculptureActivity.STATE_UNLOCK then
		local var5_1, var6_1 = var3_1:_GetComsume(var1_1)

		if var6_1 > var4_1:getVitemNumber(var5_1) then
			local var7_1 = pg.activity_workbench_item[var5_1].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("gift_act_tips", var7_1))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var3_1.id,
		arg1 = var1_1,
		arg2 = var2_1,
		arg_list = {},
		arg_list2 = {},
		kvargs1 = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			if var2_1 == SculptureActivity.STATE_UNLOCK then
				local var1_2, var2_2 = var3_1:_GetComsume(var1_1)
				local var3_2 = var4_1:getVitemNumber(var1_2)

				var4_1:addVitemNumber(var1_2, 0 - var2_2)
				getProxy(ActivityProxy):updateActivity(var4_1)
			end

			var3_1:UpdateState(var1_1, var2_1)
			getProxy(ActivityProxy):updateActivity(var3_1)
			arg0_1:sendNotification(GAME.SCULPTURE_ACT_OP_DONE, {
				state = var2_1,
				activity = var3_1,
				id = var1_1,
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
