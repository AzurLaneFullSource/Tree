local var0_0 = class("NewEducateMapEventCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.eventId

	pg.ConnectionMgr.GetInstance():Send(29064, {
		id = var1_1,
		event = var2_1
	}, 29065, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)
			local var1_2 = pg.child2_site_event_group[var2_1].event_cost

			var0_2:Cost(NewEducateHelper.Config2Drop(var1_2))

			local var2_2 = var0_2:GetCurChar()

			var2_2:AddEventRecord(var2_1)

			local var3_2 = var2_2:GetFSM()

			var3_2:SetCurNode(arg0_2.first_node)
			var3_2:SetStystemNo(NewEducateFSM.STYSTEM.MAP)

			local var4_2 = var3_2:GetState(NewEducateFSM.STYSTEM.MAP)

			var4_2:SetSiteState({
				key = NewEducateConst.SITE_STATE_TYPE.EVENT,
				value = var2_1
			})
			var4_2:FinishEvent(var2_1)

			local var5_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var5_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_MAP_EVENT_DONE, {
				drops = NewEducateHelper.FilterBenefit(var5_2),
				node = arg0_2.first_node
			})
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataSite(var2_2.id, var2_2:GetGameCnt(), var2_2:GetRoundData().round, 2, var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_MapEvent: ", arg0_2.result))
		end
	end)
end

return var0_0
