local var0 = class("ActivityWorldInPictureCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)

	if not var1 or var1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1.id,
		cmd = var0.cmd,
		arg1 = var0.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW and var0.index or var0.arg1,
		arg2 = var0.arg2,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.award_list)

			if var0.cmd == ActivityConst.WORLDINPICTURE_OP_TURN then
				var1.data2 = var1.data2 - 1

				table.insert(var1.data1_list, var0.index)
			elseif var0.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW then
				var1.data3 = var1.data3 - 1

				table.insert(var1.data2_list, var0.index)
			end

			getProxy(ActivityProxy):updateActivity(var1)
			arg0:sendNotification(GAME.WORLDIN_PICTURE_OP_DONE, {
				activity = var1,
				cmd = var0.cmd,
				arg1 = var0.arg1,
				arg2 = var0.arg2,
				auto = var0.auto,
				awards = var0
			})
		else
			if arg0.result == 3 or arg0.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", arg0.result))
			end

			arg0:sendNotification(GAME.WORLDIN_PICTURE_OP_ERRO, {
				cmd = var0.cmd,
				auto = var0.auto
			})
		end
	end)
end

return var0
