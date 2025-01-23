local var0_0 = class("NewEducateAssessCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id
	local var3_1 = var0_1.rank

	pg.ConnectionMgr.GetInstance():Send(29013, {
		id = var2_1,
		rank = var3_1
	}, 29014, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar()

			var0_2:GetFSM():SetCurNode(arg0_2.first_node)
			var0_2:GetFSM():SetStystemNo(NewEducateFSM.STYSTEM.ASSESS)
			var0_2:AddAssessRecord(var0_2:GetRoundData().round, var3_1)

			if arg0_2.first_node ~= 0 then
				arg0_1:sendNotification(GAME.NEW_EDUCATE_NODE_START, {
					node = arg0_2.first_node
				})
			else
				existCall(var1_1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_Assess: ", arg0_2.result))
		end
	end)
end

return var0_0
