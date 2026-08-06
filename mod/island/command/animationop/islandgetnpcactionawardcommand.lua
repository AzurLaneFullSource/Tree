local var0_0 = class("IslandGetNpcActionAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.npcId
	local var2_1 = var0_1.actionId
	local var3_1 = var0_1.shipId

	pg.ConnectionMgr.GetInstance():Send(21702, {
		npc_id = var1_1,
		ship_id = var3_1,
		action_feedback_id = var2_1
	}, 21703, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()

			if var1_1 ~= 0 then
				var0_2:GetNpcFeedbackAgency():AddNpc(var1_1)
			end

			local var1_2 = var0_2:GetCharacterAgency()
			local var2_2 = var1_2:GetShipById(var3_1)

			if var2_2 and var2_2:HasGreetingSkill() then
				local var3_2 = var2_2:GetSkill()

				if var3_2:CanUse4Ship(var2_2, {
					IslandBuffType.SHIP_POWER_RECOVER_BY_GREETING
				}) then
					local var4_2 = var2_2:GetCurrentEnergy()

					var2_2:ApplySkill(IslandBuffType.SHIP_POWER_RECOVER_BY_GREETING)

					local var5_2 = var2_2:GetCurrentEnergy()

					var0_2:DispatchEvent(IslandProxy.LINK_CORE, ISLAND_EVT.PLAY_EFFECT, var3_1, {
						value = var5_2 - var4_2
					}, IslandRecEnergyEffect.TYPE)
					var1_2:DispatchEvent(IslandCharacterAgency.SHIP_SKILL_STATE_CHANGE, var3_1, false)
				end

				if var3_2:CanUse4Ship(var2_2, {
					IslandBuffType.SHIP_AWARD_BY_GREETING
				}) then
					var2_2:ApplySkill(IslandBuffType.SHIP_AWARD_BY_GREETING)
					var1_2:DispatchEvent(IslandCharacterAgency.SHIP_SKILL_STATE_CHANGE, var3_1, false)
				end
			end

			local var6_2 = IslandDropHelper.AddItems(arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_GET_NPC_ACTION_AWARD_DONE, {
				dropData = var6_2
			})
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.ACTION_HELLO_DAILY)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
