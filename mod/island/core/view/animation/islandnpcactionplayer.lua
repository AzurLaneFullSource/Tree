local var0_0 = class("IslandNpcActionPlayer", import("..IslandBaseUnit"))

function var0_0.Play(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1, var1_1 = arg1_1.data:GetResponeAction(arg3_1)

	if not var0_1 then
		return
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg3_1, 2, arg1_1.modelId, var0_1, 1))
	seriesAsync({
		function(arg0_2)
			local var0_2 = pg.island_action_feedback[var0_1].state_name

			arg1_1:PlayAnimation(var0_2, 0.25, arg0_2)
		end
	}, function()
		if var1_1 then
			arg0_1:NotifiyMeditor(IslandMediator.NPC_ACTION_AWARD, arg1_1.id, var0_1)
		end
	end)
end

return var0_0
