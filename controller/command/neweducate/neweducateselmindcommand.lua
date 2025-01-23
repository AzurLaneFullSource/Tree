local var0_0 = class("NewEducateSelMindCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29090, {
		id = var0_1
	}, 29091, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetStystemNo(NewEducateFSM.STYSTEM.MIND)

			local var1_2 = NewEducateStateBase.New()

			var0_2:SetState(NewEducateFSM.STYSTEM.MIND, var1_2)

			local var2_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var2_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_MIND_DONE, {
				drops = NewEducateHelper.FilterBenefit(var2_2),
				node = arg0_2.first_node
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_SelMind", arg0_2.result))
		end
	end)
end

return var0_0
