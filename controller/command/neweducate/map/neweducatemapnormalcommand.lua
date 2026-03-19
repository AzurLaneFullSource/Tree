local var0_0 = class("NewEducateMapNormalCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.normalId

	if getProxy(NewEducateProxy):GetCurChar():GetFSM():CheckPriorityStystem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(29062, {
		id = var1_1,
		work_id = var2_1
	}, 29063, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)
			local var1_2 = pg.child2_site_normal[var2_1].cost

			var0_2:Cost(NewEducateHelper.Config2Drop(var1_2))

			local var2_2 = var0_2:GetCurChar()

			var2_2:AddNormalRecord(var2_1)

			local var3_2 = var2_2:GetFSM()

			var3_2:SetCurNode(arg0_2.first_node)
			var3_2:SetSystemNo(NewEducateFSM.SYSTEM.MAP)
			var3_2:GetState(NewEducateFSM.SYSTEM.MAP):SetSiteState({
				key = NewEducateConst.SITE_STATE_TYPE.NORMAL,
				value = var2_1
			})

			local var4_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_MAP_NORMAL_DONE, {
				drops = var4_2,
				node = arg0_2.first_node
			})
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataSite(var2_2.id, var2_2:GetGameCnt(), var2_2:GetRoundData().round, 1, var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_MapNormal: " .. arg0_2.result)
		end
	end)
end

return var0_0
