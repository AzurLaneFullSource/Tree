local var0_0 = class("IslandNpcActionPlayer", import("..IslandBaseUnit"))

function var0_0.Play(arg0_1, arg1_1, arg2_1, arg3_1)
	if not arg1_1 or not arg2_1 then
		return
	end

	local var0_1, var1_1 = arg1_1.data:GetResponeAction(arg3_1)

	if not var0_1 then
		return
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildActionOp(1, arg3_1, 2, arg1_1.modelId, var0_1, 1))
	seriesAsync({
		function(arg0_2)
			arg0_1:PlayBubble(arg1_1, var0_1)

			local var0_2 = pg.island_action_feedback[var0_1].state_name

			if not var0_2 then
				arg0_2()

				return
			end

			arg1_1:PlayAnimation(var0_2, 0.25, arg0_2)
		end
	}, function()
		if var1_1 then
			arg0_1:NotifiyMeditor(IslandMediator.NPC_ACTION_AWARD, arg1_1.id, var0_1)
		end
	end)
end

function var0_0.PlayBubble(arg0_4, arg1_4, arg2_4)
	local var0_4 = pg.island_action_feedback[arg2_4]

	if not var0_4.emoji or var0_4.emoji == "" then
		return
	end

	local var1_4 = 0

	if type(var0_4.emoji) == "table" then
		local var2_4 = var0_4.emoji

		var1_4 = var2_4[math.random(1, #var2_4)]
	else
		var1_4 = var0_4.emoji
	end

	require("nodecanvas.Task.NcPlayChatExpression").New(nil, {}):DoAction(var1_4, arg1_4.id, arg1_4.unitType, function()
		return
	end)
end

return var0_0
