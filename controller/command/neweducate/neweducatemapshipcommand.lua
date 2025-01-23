local var0_0 = class("NewEducateMapShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.shipId

	pg.ConnectionMgr.GetInstance():Send(29068, {
		id = var1_1,
		character = var2_1
	}, 29069, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)
			local var1_2 = pg.child2_site_character[var2_1]

			var0_2:Cost(NewEducateHelper.Config2Drop(var1_2.cost))

			local var2_2 = pg.child2_site_character.get_id_list_by_group[var1_2.group]
			local var3_2 = underscore.detect(var2_2, function(arg0_3)
				return pg.child2_site_character[arg0_3].level == var1_2.level + 1
			end)

			if var3_2 then
				var0_2:GetCurChar():UpdateShipId(var2_1, var3_2)
			end

			local var4_2 = var0_2:GetCurChar()
			local var5_2 = var4_2:GetFSM()

			var5_2:SetCurNode(arg0_2.first_node)
			var5_2:SetStystemNo(NewEducateFSM.STYSTEM.MAP)

			local var6_2 = var5_2:GetState(NewEducateFSM.STYSTEM.MAP)

			var6_2:SetSiteState({
				key = NewEducateConst.SITE_STATE_TYPE.SHIP,
				value = var2_1
			})

			if var3_2 then
				var6_2:AddSelectedShip(var3_2)
			end

			local var7_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var7_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_MAP_SHIP_DONE, {
				drops = NewEducateHelper.FilterBenefit(var7_2),
				node = arg0_2.first_node
			})
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataSite(var4_2.id, var4_2:GetGameCnt(), var4_2:GetRoundData().round, 3, var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_MapShip: ", arg0_2.result))
		end
	end)
end

return var0_0
