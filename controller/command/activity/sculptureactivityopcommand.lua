local var0 = class("SculptureActivityOpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.state
	local var3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

	if not var3 or var3:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	if not var4 or var4:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not var3:CanEnterState(var1, var2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	if var2 == SculptureActivity.STATE_UNLOCK then
		local var5, var6 = var3:_GetComsume(var1)

		if var6 > var4:getVitemNumber(var5) then
			local var7 = pg.activity_workbench_item[var5].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("gift_act_tips", var7))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var3.id,
		arg1 = var1,
		arg2 = var2,
		arg_list = {},
		arg_list2 = {},
		kvargs1 = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			if var2 == SculptureActivity.STATE_UNLOCK then
				local var1, var2 = var3:_GetComsume(var1)
				local var3 = var4:getVitemNumber(var1)

				var4:addVitemNumber(var1, 0 - var2)
				getProxy(ActivityProxy):updateActivity(var4)
			end

			var3:UpdateState(var1, var2)
			getProxy(ActivityProxy):updateActivity(var3)
			arg0:sendNotification(GAME.SCULPTURE_ACT_OP_DONE, {
				state = var2,
				activity = var3,
				id = var1,
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
