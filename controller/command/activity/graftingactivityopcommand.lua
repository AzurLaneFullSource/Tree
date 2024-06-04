local var0 = class("GraftingActivityOpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityById(var1)

	if not var3 or var3:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var4 = var3:getConfig("config_id")
	local var5 = var2:getActivityById(var4)

	if var5 and not var5:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

		return
	end

	local var6 = pg.activity_template[var4].type

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1,
		cmd = var0.cmd or 0,
		arg1 = var0.arg1 or 0,
		arg2 = var0.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if arg0:IsBuildShipType(var6) then
				arg0:UpdateActivityForBuildShip(var1)
			end

			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			arg0:sendNotification(GAME.GRAFTING_ACT_OP_DONE, {
				linkActType = var6,
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

function var0.IsBuildShipType(arg0, arg1)
	return arg1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or arg1 == ActivityConst.ACTIVITY_TYPE_BUILD or arg1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

function var0.UpdateActivityForBuildShip(arg0, arg1)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityById(arg1)

	var1.data2 = var1.data2 + 1

	var0:updateActivity(var1)
end

return var0
