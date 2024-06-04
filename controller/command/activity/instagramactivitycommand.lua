local var0 = class("InstagramActivityCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	print("cmd:", var0.cmd, "arg1:", var0.arg1, "arg2:", var0.arg2, "activity_id:", var0.activity_id)

	local var1 = getProxy(InstagramProxy)

	if ActivityConst.INSTAGRAM_OP_ACTIVE == var0.cmd then
		local var2 = getProxy(ActivityProxy)
		local var3 = var2:getActivityById(var0.activity_id)

		pg.ConnectionMgr.GetInstance():Send(11202, {
			cmd = 1,
			activity_id = var0.activity_id,
			arg1 = var0.arg1 or 0,
			arg2 = var0.arg2 or 0,
			arg3 = var0.arg3 or 0,
			arg_list = {}
		}, 11203, function(arg0)
			if arg0.result == 0 then
				local var0 = Instagram.New(arg0.ins_message)

				var1:UpdateMessage(var0)
				var3:UpdateActiveCnt()
				var2:updateActivity(var3)
				arg0:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
					activity = var3
				})
				arg0:sendNotification(GAME.ACT_INSTAGRAM_OP_DONE, {
					cmd = var0.cmd,
					id = var0.arg1
				})

				if var0.callback then
					var0.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	elseif ActivityConst.INSTAGRAM_OP_LIKE == var0.cmd or ActivityConst.INSTAGRAM_OP_MARK_READ == var0.cmd or ActivityConst.INSTAGRAM_OP_UPDATE == var0.cmd or ActivityConst.INSTAGRAM_OP_SHARE == var0.cmd then
		pg.ConnectionMgr.GetInstance():Send(11701, {
			id = var0.arg1,
			cmd = var0.cmd
		}, 11702, function(arg0)
			if arg0.result == 0 then
				if ActivityConst.INSTAGRAM_OP_MARK_READ == var0.cmd then
					local var0 = var1:GetMessageById(var0.arg1)

					var0.isRead = true

					var1:UpdateMessage(var0)
				elseif ActivityConst.INSTAGRAM_OP_SHARE ~= var0.cmd then
					local var1 = Instagram.New(arg0.data)

					var1:UpdateMessage(var1)
				end

				arg0:sendNotification(GAME.ACT_INSTAGRAM_OP_DONE, {
					cmd = var0.cmd,
					id = var0.arg1
				})

				if var0.callback then
					var0.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	elseif ActivityConst.INSTAGRAM_OP_COMMENT == var0.cmd then
		pg.ConnectionMgr.GetInstance():Send(11703, {
			id = var0.arg1,
			discuss = var0.arg2,
			index = var0.arg3
		}, 11704, function(arg0)
			if arg0.result == 0 then
				local var0 = Instagram.New(arg0.data)

				var1:UpdateMessage(var0)
				arg0:sendNotification(GAME.ACT_INSTAGRAM_OP_DONE, {
					cmd = var0.cmd,
					id = var0.arg1
				})

				if var0.callback then
					var0.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end
end

return var0
