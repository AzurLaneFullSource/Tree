local var0_0 = class("NewEducateNextPlanCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.rePlay

	pg.ConnectionMgr.GetInstance():Send(29042, {
		id = var1_1
	}, 29043, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetCurNode(arg0_2.first_node)

			local var1_2 = var0_2:GetState(NewEducateFSM.STYSTEM.PLAN)

			var1_2:SetNextPlanIdx()

			local var2_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var2_2)

			local var3_2 = var1_2:GetCurIdx() == var1_2:GetIdxList()[1]

			arg0_1:sendNotification(GAME.NEW_EDUCATE_NEXT_PLAN_DONE, {
				drops = NewEducateHelper.FilterBenefit(var2_2),
				node = arg0_2.first_node,
				isFristNode = var3_2 or var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_NextPlan: ", arg0_2.result))
		end
	end)
end

return var0_0
