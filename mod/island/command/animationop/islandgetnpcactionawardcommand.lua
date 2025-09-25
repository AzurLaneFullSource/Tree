local var0_0 = class("IslandGetNpcActionAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.npcId
	local var2_1 = var0_1.actionId

	pg.ConnectionMgr.GetInstance():Send(21702, {
		npc_id = var1_1,
		action_feedback_id = var2_1
	}, 21703, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetNpcFeedbackAgency():AddNpc(var1_1)

			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_GET_NPC_ACTION_AWARD_DONE, {
				dropData = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
