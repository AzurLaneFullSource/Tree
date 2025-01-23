local var0_0 = class("NewEducateGetMapCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29060, {
		id = var0_1
	}, 29061, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar()
			local var1_2 = NewEducateMapState.New(var0_1, arg0_2.fsm_site)

			var0_2:GetFSM():SetState(NewEducateFSM.STYSTEM.MAP, var1_2)
			var0_2:SetShipIds(arg0_2.characters or {})

			local var2_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var2_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_MAP_DONE, {
				drops = NewEducateHelper.FilterBenefit(var2_2)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_GetMap", arg0_2.result))
		end
	end)
end

return var0_0
