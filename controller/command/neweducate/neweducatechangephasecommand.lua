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
			var0_2:GetFSM():SetStystemNo(NewEducateFSM.STYSTEM.PHASE)

			local var1_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var1_2)

			if not var0_2:GetRoundData():IsEndRound() then
				getProxy(NewEducateProxy):NextRound()
			end

			var0_2:GetFSM():SetCurNode(arg0_2.first_node)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_CHANGE_PHASE_DONE, {
				drops = NewEducateHelper.FilterBenefit(var1_2),
				node = arg0_2.first_node
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_ChangePhase: ", arg0_2.result))
		end
	end)
end

return var0_0
