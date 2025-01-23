local var0_0 = class("NewEducateTriggerNodeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.branch or 0
	local var3_1 = var0_1.costs or {}

	pg.ConnectionMgr.GetInstance():Send(29030, {
		id = var1_1,
		branch = var2_1
	}, 29031, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):Costs(var3_1)

			local var0_2 = NewEducateHelper.MergeDrops(arg0_2.drop)
			local var1_2 = NewEducateHelper.UpdateDropsData(var0_2)
			local var2_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var2_2:SetCurNode(arg0_2.next_node)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_NEXT_NODE, {
				node = arg0_2.next_node,
				drop = NewEducateHelper.FilterBenefit(var1_2),
				noNextCb = function()
					if arg0_2.next_node == 0 then
						if var2_2:GetStystemNo() == NewEducateFSM.STYSTEM.PLAN then
							local var0_3 = var2_2:GetState(NewEducateFSM.STYSTEM.PLAN)

							if var0_3:IsFinish() then
								arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_EXTRA_DROP, {
									id = var1_1,
									scheduleDrops = var0_3:GetDrops()
								})
							else
								arg0_1:sendNotification(GAME.NEW_EDUCATE_NEXT_PLAN, {
									id = var1_1
								})
							end
						else
							arg0_1:sendNotification(GAME.NEW_EDUCATE_CHECK_FSM)
						end
					end
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_TriggerNode: ", arg0_2.result))
		end
	end)
end

return var0_0
