local var0_0 = class("NewEducateClearNodeChainCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	warning("Clear Node Chain, id: ", var0_1)
	pg.ConnectionMgr.GetInstance():Send(29032, {
		id = var0_1
	}, 29033, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():InitFSM(arg0_2.fsm)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_CHECK_FSM)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_ClearNodeChain", arg0_2.result))
		end
	end)
end

return var0_0
