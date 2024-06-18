local var0_0 = class("GraftingActivityOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var2_1:getActivityById(var1_1)

	if not var3_1 or var3_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var4_1 = var3_1:getConfig("config_id")
	local var5_1 = var2_1:getActivityById(var4_1)

	if var5_1 and not var5_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

		return
	end

	local var6_1 = pg.activity_template[var4_1].type

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1_1,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if arg0_1:IsBuildShipType(var6_1) then
				arg0_1:UpdateActivityForBuildShip(var1_1)
			end

			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			arg0_1:sendNotification(GAME.GRAFTING_ACT_OP_DONE, {
				linkActType = var6_1,
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.IsBuildShipType(arg0_3, arg1_3)
	return arg1_3 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or arg1_3 == ActivityConst.ACTIVITY_TYPE_BUILD or arg1_3 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

function var0_0.UpdateActivityForBuildShip(arg0_4, arg1_4)
	local var0_4 = getProxy(ActivityProxy)
	local var1_4 = var0_4:getActivityById(arg1_4)

	var1_4.data2 = var1_4.data2 + 1

	var0_4:updateActivity(var1_4)
end

return var0_0
