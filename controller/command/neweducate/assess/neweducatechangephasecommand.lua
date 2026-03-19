local var0_0 = class("NewEducateChangePhaseCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29025, {
		id = var0_1
	}, 29026, function(arg0_2)
		if arg0_2.result == 0 then
			NewEducateHelper.TrackRoundEnd()

			local var0_2 = getProxy(NewEducateProxy):GetCurChar()

			var0_2:GetFSM():SetCurNode(arg0_2.first_node)
			var0_2:GetFSM():SetSystemNo(NewEducateFSM.SYSTEM.PHASE)
			getProxy(NewEducateProxy):NextRound()

			local var1_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_CHANGE_PHASE_DONE, {
				drops = var1_2,
				node = arg0_2.first_node
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_ChangePhase: " .. arg0_2.result)
		end
	end)
end

return var0_0
