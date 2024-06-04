local var0 = class("CastleActivityCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityById(var1)

	if not var3 or var3:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var1,
		cmd = var0.cmd,
		arg1 = var0.arg1 or 0,
		arg2 = var0.arg2 or 0,
		arg3 = var0.arg3 or 0,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if var0.cmd == 1 then
				var3.data1 = arg0.number[2]

				if arg0.number[1] <= 50 then
					var3.data2 = var3.data2 - 1
				end

				var2:updateActivity(var3)
				arg0:sendNotification(GAME.CASTLE_DICE_OP_DONE, arg0)
			elseif var0.cmd == 2 then
				warning(#arg0.number)

				var3.data1 = arg0.number[1]

				var2:updateActivity(var3)
				arg0:sendNotification(GAME.CASTLE_STORY_OP_DONE, arg0)
			elseif var0.cmd == 3 then
				arg0:sendNotification(GAME.CASTLE_FIRST_STORY_OP_DONE)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
