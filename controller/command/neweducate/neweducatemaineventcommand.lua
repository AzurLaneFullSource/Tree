local var0_0 = class("NewEducateMainEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29011, {
		id = var0_1
	}, 29012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetCurNode(arg0_2.first_node)
			var0_2:SetStystemNo(NewEducateFSM.STYSTEM.EVENT)

			if arg0_2.first_node ~= 0 then
				arg0_1:sendNotification(GAME.NEW_EDUCATE_NODE_START, {
					node = arg0_2.first_node
				})
			else
				arg0_1:sendNotification(GAME.NEW_EDUCATE_CHECK_FSM)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_MainEvent: ", arg0_2.result))
		end
	end)
end

return var0_0
