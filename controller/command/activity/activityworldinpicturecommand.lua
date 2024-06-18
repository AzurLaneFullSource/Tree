local var0_0 = class("ActivityWorldInPictureCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

	if not var1_1 or var1_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1_1.id,
		cmd = var0_1.cmd,
		arg1 = var0_1.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW and var0_1.index or var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			if var0_1.cmd == ActivityConst.WORLDINPICTURE_OP_TURN then
				var1_1.data2 = var1_1.data2 - 1

				table.insert(var1_1.data1_list, var0_1.index)
			elseif var0_1.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW then
				var1_1.data3 = var1_1.data3 - 1

				table.insert(var1_1.data2_list, var0_1.index)
			end

			getProxy(ActivityProxy):updateActivity(var1_1)
			arg0_1:sendNotification(GAME.WORLDIN_PICTURE_OP_DONE, {
				activity = var1_1,
				cmd = var0_1.cmd,
				arg1 = var0_1.arg1,
				arg2 = var0_1.arg2,
				auto = var0_1.auto,
				awards = var0_2
			})
		else
			if arg0_2.result == 3 or arg0_2.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0_2.result))
			end

			arg0_1:sendNotification(GAME.WORLDIN_PICTURE_OP_ERRO, {
				cmd = var0_1.cmd,
				auto = var0_1.auto
			})
		end
	end)
end

return var0_0
