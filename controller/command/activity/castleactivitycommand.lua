local var0_0 = class("CastleActivityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var2_1:getActivityById(var1_1)

	if not var3_1 or var3_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1_1,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg3 = var0_1.arg3 or 0,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if var0_1.cmd == 1 then
				var3_1.data1 = arg0_2.number[2]

				if arg0_2.number[1] <= 50 then
					var3_1.data2 = var3_1.data2 - 1
				end

				var2_1:updateActivity(var3_1)
				arg0_1:sendNotification(GAME.CASTLE_DICE_OP_DONE, arg0_2)
			elseif var0_1.cmd == 2 then
				warning(#arg0_2.number)

				var3_1.data1 = arg0_2.number[1]

				var2_1:updateActivity(var3_1)
				arg0_1:sendNotification(GAME.CASTLE_STORY_OP_DONE, arg0_2)
			elseif var0_1.cmd == 3 then
				arg0_1:sendNotification(GAME.CASTLE_FIRST_STORY_OP_DONE)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
