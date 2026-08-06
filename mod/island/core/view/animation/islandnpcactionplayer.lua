local var0_0 = class("IslandNpcActionPlayer", import("..IslandBaseUnit"))

function var0_0.Resopon(arg0_1, arg1_1, arg2_1, arg3_1)
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
			local var0_3 = arg1_1.id

			if not arg1_1.data:ExistActionFeedback() then
				var0_3 = 0
			end

			arg0_1:NotifiyMeditor(IslandMediator.NPC_ACTION_AWARD, var0_3, arg1_1.data.shipId, var0_1)
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

function var0_0.ResoponByRandom(arg0_6, arg1_6, arg2_6)
	local var0_6 = pg.island_action[arg2_6]

	if not var0_6 then
		return
	end

	local var1_6 = var0_6.sigle_action_reply_type

	if not var1_6 then
		return
	end

	local var2_6 = arg0_6:GetResponActionName(var0_6.chara_sigle_action_reply or {})

	if not var2_6 then
		return
	end

	local var3_6 = arg0_6:CollectUnits(var1_6, arg1_6)

	if #var3_6 <= 0 then
		return
	end

	arg0_6:TurnToPlayer(var3_6, arg1_6)

	local var4_6 = {}

	table.insert(var4_6, function(arg0_7)
		onNextTick(arg0_7)
	end)

	for iter0_6, iter1_6 in ipairs(var3_6) do
		table.insert(var4_6, function(arg0_8)
			iter1_6:PlayAnimation(var2_6, 0.25, arg0_8)
		end)
	end

	table.insert(var4_6, function(arg0_9)
		onNextTick(arg0_9)
	end)
	parallelAsync(var4_6, function()
		arg0_6:ResetUnits(var3_6)
	end)
end

function var0_0.GetResponActionName(arg0_11, arg1_11)
	if #arg1_11 <= 0 then
		return
	end

	local var0_11 = _.map(arg1_11, function(arg0_12)
		return pg.island_action_feedback[arg0_12].state_name
	end)

	return var0_11[math.random(1, #var0_11)]
end

function var0_0.TurnToPlayer(arg0_13, arg1_13, arg2_13)
	local function var0_13(arg0_14, arg1_14)
		local var0_14 = arg1_14.position - arg0_14.position
		local var1_14 = Quaternion.LookRotation(var0_14)

		arg0_14.rotation = Quaternion.Euler(0, var1_14.eulerAngles.y, 0)
	end

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		if iter1_13 then
			iter1_13:StopMove()
			iter1_13:PauseBt()
			var0_13(iter1_13._go.transform, arg2_13._go.transform)
		end
	end
end

function var0_0.ResetUnits(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg1_15) do
		if iter1_15 then
			iter1_15:SetupBt()
		end
	end
end

function var0_0.CollectUnits(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}
	local var1_16 = pg.island_set.single_action_respon_check_range.key_value_int

	if arg1_16 == IslandConst.ACTION_REPOSON_TYPE_NEAREST_ONE then
		arg0_16:GetNearestUnit(var0_16, arg2_16, var1_16)
	elseif arg1_16 == IslandConst.ACTION_REPOSON_TYPE_NEAREST_FOLLOWER then
		arg0_16:GetNearestFollower(var0_16, arg2_16, var1_16)
	elseif arg1_16 == IslandConst.ACTION_REPOSON_TYPE_ALL_FOLLOWER then
		arg0_16:GetAllFollower(var0_16, arg2_16, var1_16)
	elseif arg1_16 == IslandConst.ACTION_REPOSON_TYPE_RANDOM_FOLLOWER then
		arg0_16:GetRandomFollower(var0_16, arg2_16, var1_16)
	end

	return var0_16
end

function var0_0.GetNearestUnit(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17:GetView():GetAllUnits()
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if isa(iter1_17, IslandNpcUnit) then
			table.insert(var1_17, iter1_17)
		end
	end

	if #var1_17 <= 0 then
		return
	end

	local var2_17
	local var3_17 = math.huge

	for iter2_17, iter3_17 in ipairs(var1_17) do
		local var4_17 = Vector3.Distance(iter3_17._go.transform.position, arg2_17._go.transform.position)

		if var4_17 <= arg3_17 and var4_17 < var3_17 then
			var3_17 = var4_17
			var2_17 = iter3_17
		end
	end

	if var2_17 then
		table.insert(arg1_17, var2_17)
	end
end

function var0_0.GetNearestFollower(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:GetView():GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_18
	local var2_18 = math.huge

	for iter0_18, iter1_18 in ipairs(var0_18) do
		local var3_18 = Vector3.Distance(iter1_18._go.transform.position, arg2_18._go.transform.position)

		if var3_18 <= arg3_18 and var3_18 < var2_18 then
			var2_18 = var3_18
			var1_18 = iter1_18
		end
	end

	if var1_18 then
		table.insert(arg1_18, var1_18)
	end
end

function var0_0.GetAllFollower(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:GetView():GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	for iter0_19, iter1_19 in ipairs(var0_19) do
		if arg3_19 >= Vector3.Distance(iter1_19._go.transform.position, arg2_19._go.transform.position) then
			table.insert(arg1_19, iter1_19)
		end
	end
end

function var0_0.GetRandomFollower(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg0_20:GetView():GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)
	local var1_20 = {}

	for iter0_20, iter1_20 in ipairs(var0_20) do
		if arg3_20 >= Vector3.Distance(iter1_20._go.transform.position, arg2_20._go.transform.position) then
			table.insert(var1_20, iter1_20)
		end
	end

	if #var1_20 <= 0 then
		return
	end

	local var2_20 = var1_20[math.random(1, #var1_20)]

	table.insert(arg1_20, var2_20)
end

return var0_0
