local var0_0 = class("CommanderManualCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if var0_1.operation == CommanderManualProxy.GET_TASK then
		pg.ConnectionMgr.GetInstance():Send(22302, {
			id = var0_1.pageId,
			index = var0_1.index
		}, 22303, function(arg0_2)
			if arg0_2.result == 0 then
				getProxy(CommanderManualProxy):GetPageById(var0_1.pageId):RemoveDoingGetTaskIndex(var0_1.index)

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
			end
		end)
	elseif var0_1.operation == CommanderManualProxy.GET_PT_AWARD then
		pg.ConnectionMgr.GetInstance():Send(22304, {
			id = var0_1.pageId
		}, 22305, function(arg0_3)
			if arg0_3.result == 0 then
				getProxy(CommanderManualProxy):AddPageAward(var0_1.pageId)

				local var0_3 = PlayerConst.addTranDrop(arg0_3.drop_list)

				arg0_1:sendNotification(GAME.COMMANDER_MANUAL_OP_DONE, {
					operation = var0_1.operation,
					awards = var0_3,
					pageId = var0_1.pageId
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	end
end

return var0_0
