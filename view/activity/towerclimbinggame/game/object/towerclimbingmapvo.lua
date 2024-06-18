local var0_0 = class("TowerClimbingMapVO")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg2_1
	arg0_1.nextBlockIndex = 0
	arg0_1.level = 0
	arg0_1.higestLevel = 0
	arg0_1.id = arg1_1

	assert(arg0_1.id, arg1_1)
end

function var0_0.Init(arg0_2, arg1_2, arg2_2)
	arg0_2.mapWidth = arg1_2.screenWidth
	arg0_2.mapHeight = arg1_2.screenHeight
	arg0_2.awards = arg1_2.awards[arg0_2.id]

	seriesAsync({
		function(arg0_3)
			arg0_2:InitBlock(arg0_3)
		end,
		function(arg0_4)
			arg0_2:InitPlayer(arg1_2, arg0_4)
		end,
		function(arg0_5)
			arg0_2:InitGround(arg1_2, arg0_5)
		end,
		function(arg0_6)
			local var0_6 = arg0_2.blocks[1]

			assert(var0_6)
			arg0_2.player:SetPosition(var0_6.position)
			arg0_2:SendMapEvent("OnPlayerLifeUpdate", arg0_2.player.life)
			arg0_6()
		end
	}, arg2_2)
end

function var0_0.InitGround(arg0_7, arg1_7, arg2_7)
	local var0_7 = TowerClimbingGameSettings.MANJUU_START_POS

	arg0_7.ground = {
		sleepTime = 0,
		IsRuning = false,
		position = var0_7,
		name = arg1_7.npcName
	}

	arg0_7:SendMapEvent("OnCreateGround", arg0_7.ground, arg2_7)
end

function var0_0.InitBlock(arg0_8, arg1_8)
	arg0_8.blocks = {}

	local var0_8 = {}
	local var1_8 = TowerClimbingGameSettings.GetBlockInitCnt(arg0_8.mapHeight)

	for iter0_8 = 1, var1_8 do
		table.insert(var0_8, function(arg0_9)
			local var0_9 = arg0_8:CreateBlock()

			table.insert(arg0_8.blocks, var0_9)
			arg0_8:SendMapEvent("OnCreateBlock", var0_9, arg0_9)
		end)
	end

	parallelAsync(var0_8, arg1_8)
end

local function var1_0(arg0_10, arg1_10)
	if arg0_10 == 1 then
		return TowerClimbingGameSettings.HEAD_BLOCK_TYPE
	else
		local var0_10 = TowerClimbingGameSettings.MapId2BlockType[arg1_10]

		assert(var0_10, arg1_10)

		local var1_10 = math.random(1, 100)

		for iter0_10, iter1_10 in ipairs(var0_10) do
			if var1_10 <= iter1_10[2] then
				return iter1_10[1]
			end
		end

		assert(false)
	end
end

local function var2_0(arg0_11, arg1_11)
	if not arg1_11 then
		return TowerClimbingGameSettings.BLOCK_START_POSITION
	else
		local var0_11 = arg1_11.position
		local var1_11 = arg1_11.width
		local var2_11 = TowerClimbingGameSettings.BLOCK_INTERVAL_HEIGHT
		local var3_11 = TowerClimbingGameSettings.BLOCK_MAX_INTERVAL_WIDTH[1]
		local var4_11 = TowerClimbingGameSettings.BLOCK_MAX_INTERVAL_WIDTH[2]
		local var5_11 = TowerClimbingGameSettings.BOUNDS[1]
		local var6_11 = TowerClimbingGameSettings.BOUNDS[2]
		local var7_11 = {}
		local var8_11 = var0_11.x + var1_11 / 2
		local var9_11 = var6_11 - var8_11 - arg0_11

		if var3_11 < var9_11 then
			local var10_11 = math.min(var4_11, var9_11)
			local var11_11 = var3_11

			if var9_11 >= 0 then
				var11_11 = 0
			end

			local var12_11 = math.random(var11_11, var10_11)

			table.insert(var7_11, var8_11 + var12_11 + arg0_11 / 2)
		end

		local var13_11 = var0_11.x - var1_11 / 2
		local var14_11 = math.abs(var5_11 - var13_11) - arg0_11

		if var3_11 < var14_11 then
			local var15_11 = math.min(var4_11, var14_11)
			local var16_11 = var3_11

			if var14_11 >= 0 then
				var16_11 = 0
			end

			local var17_11 = math.random(var16_11, var15_11)

			table.insert(var7_11, var13_11 - var17_11 - arg0_11 / 2)
		end

		assert(#var7_11 > 0, var9_11 .. " & " .. var14_11 .. " - " .. arg0_11 .. " - " .. var0_11.x .. "-" .. var1_11)

		local var18_11 = math.random(1, #var7_11)

		return Vector2(var7_11[var18_11], var0_11.y + var2_11)
	end
end

function var0_0.CreateBlock(arg0_12)
	arg0_12.nextBlockIndex = arg0_12.nextBlockIndex + 1

	local var0_12 = arg0_12.blocks[#arg0_12.blocks]
	local var1_12 = var1_0(arg0_12.nextBlockIndex, arg0_12.id)
	local var2_12 = var2_0(var1_12[2], var0_12)

	return {
		id = arg0_12.nextBlockIndex,
		type = var1_12[1],
		width = var1_12[2],
		position = var2_12,
		isActive = not var0_12,
		level = arg0_12.nextBlockIndex
	}
end

function var0_0.ActicveNextBlock(arg0_13, arg1_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.blocks) do
		if iter1_13.level == arg1_13 then
			iter1_13.isActive = true

			arg0_13:SendMapEvent("OnActiveBlock", iter1_13)

			if arg0_13.player:IsInvincible() then
				arg0_13:SendMapEvent("OnEnableStab", iter1_13, false)
			end

			break
		end
	end
end

function var0_0.DeactiveAboveBlocks(arg0_14, arg1_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.blocks) do
		if arg1_14 < iter1_14.level and iter1_14.isActive == true then
			iter1_14.isActive = false

			arg0_14:SendMapEvent("OnActiveBlock", iter1_14)
		end
	end
end

function var0_0.AddNewBlock(arg0_15, arg1_15)
	local var0_15 = arg0_15:CreateBlock()

	table.insert(arg0_15.blocks, var0_15)
	arg0_15:SendMapEvent("OnCreateBlock", var0_15, arg1_15)
end

function var0_0.DoSink(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = {}

	table.insert(var0_16, function(arg0_17)
		arg0_16:SendMapEvent("SinkHandler", TowerClimbingGameSettings.SINK_DISTANCE * arg2_16)
	end)
	table.insert(var0_16, 1, function(arg0_18)
		if not arg0_16.ground.IsRuning then
			arg0_18()

			return
		end

		local var0_18 = arg0_16.ground.position
		local var1_18 = var0_18.y - TowerClimbingGameSettings.SINK_DISTANCE * arg2_16

		arg0_16.ground.position = Vector2(var0_18.x, var1_18)

		arg0_16:SendMapEvent("OnGroundPositionChange", arg0_16.ground.position)
		arg0_18()
	end)
	parallelAsync(var0_16, arg3_16)
end

function var0_0.CheckCorssBoundBlocks(arg0_19, arg1_19)
	local var0_19 = 0

	for iter0_19 = #arg0_19.blocks, 1, -1 do
		local var1_19 = arg0_19.blocks[iter0_19]

		if var0_19 >= var1_19.position.y then
			local var2_19 = var1_19.level

			table.remove(arg0_19.blocks, iter0_19)
			arg0_19:SendMapEvent("OnBlockDestory", var2_19)
		elseif TowerClimbingGameSettings.MANJUU_HEIGHT + arg0_19.ground.position.y >= var1_19.position.y then
			var1_19.isActive = false

			arg0_19:SendMapEvent("OnActiveBlock", var1_19)
		end
	end

	arg1_19()
end

function var0_0.InitPlayer(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20.life
	local var1_20 = arg1_20.score
	local var2_20 = arg1_20.shipId
	local var3_20 = arg1_20.higestscore
	local var4_20 = arg1_20.pageIndex
	local var5_20 = arg1_20.mapScores[arg0_20.id]

	arg0_20.player = TowerClimbingPlayerVO.New(arg0_20.view, {
		id = var2_20,
		life = var0_20,
		score = var1_20,
		higestscore = var3_20,
		pageIndex = var4_20,
		mapScore = var5_20
	})

	arg0_20:SendMapEvent("OnCreatePlayer", arg0_20.player, arg2_20)
end

function var0_0.GetPlayer(arg0_21)
	return arg0_21.player
end

function var0_0.GetBlocks(arg0_22)
	return arg0_22.blocks
end

function var0_0.SetCurrentLevel(arg0_23, arg1_23)
	if arg1_23 > arg0_23.level then
		arg0_23:ActicveNextBlock(arg1_23 + 1)
	elseif arg1_23 < arg0_23.level then
		arg0_23:DeactiveAboveBlocks(arg1_23 + 1)
	end

	arg0_23.level = arg1_23

	if arg1_23 > arg0_23.higestLevel then
		local var0_23 = arg1_23 - arg0_23.higestLevel

		arg0_23.higestLevel = arg1_23

		arg0_23.player:AddScore()
		arg0_23:DoCheck(var0_23)
		arg0_23:OverHigestScore()
	end
end

function var0_0.OverHigestScore(arg0_24)
	local function var0_24(arg0_25)
		for iter0_25, iter1_25 in ipairs(arg0_24.awards) do
			if arg0_25 == iter1_25 then
				return true
			end
		end

		return false
	end

	if arg0_24.player:IsOverHigestScore() and var0_24(arg0_24.player.score) then
		arg0_24:SendMapEvent("OnReachAwardScore")
	end
end

function var0_0.DoCheck(arg0_26, arg1_26)
	if arg0_26.higestLevel <= 1 then
		return
	end

	seriesAsync({
		function(arg0_27)
			arg0_26:AddNewBlock(arg0_27)
		end,
		function(arg0_28)
			parallelAsync({
				function(arg0_29)
					arg0_26:DoSink(arg0_26.higestLevel, arg1_26, arg0_29)
				end,
				function(arg0_30)
					local var0_30 = TowerClimbingGameSettings.SINK_DISTANCE * arg1_26

					arg0_26:SendMapEvent("OnSink", var0_30, arg0_30)
				end
			}, arg0_28)
		end,
		function(arg0_31)
			arg0_26:CheckCorssBoundBlocks(arg0_31)
		end,
		function(arg0_32)
			arg0_26:CheckGroundState()
			arg0_32()
		end
	})
end

function var0_0.CheckGroundState(arg0_33)
	if not arg0_33.ground.IsRuning and arg0_33.higestLevel >= TowerClimbingGameSettings.GROUND_RISE_UP_LEVEL then
		arg0_33.ground.IsRuning = true

		arg0_33:SendMapEvent("OnGroundRuning")
	end
end

function var0_0.ReBornPlayer(arg0_34)
	local var0_34 = {}
	local var1_34

	for iter0_34, iter1_34 in ipairs(arg0_34.blocks) do
		if iter1_34.isActive then
			table.insert(var0_34, iter1_34)
		end
	end

	assert(#var0_34 > 0)

	local var2_34 = _.detect(var0_34, function(arg0_35)
		return arg0_35.level == arg0_34.higestLevel
	end)

	if not var2_34 then
		table.sort(var0_34, function(arg0_36, arg1_36)
			return arg0_36.position.y > arg1_36.position.y
		end)

		var2_34 = var0_34[1]
	end

	arg0_34.player:SetPosition(var2_34.position + Vector2(0, 10))
end

function var0_0.AddPlayerInvincibleEffect(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.blocks) do
		if iter1_37.isActive then
			arg0_37:SendMapEvent("OnEnableStab", iter1_37, not arg1_37)
		end
	end

	if arg0_37.ground.IsRuning then
		arg0_37:SendMapEvent("OnEnableGround", not arg1_37)
	end
end

local function var3_0(arg0_38)
	local var0_38 = TowerClimbingGameSettings.GROUND_RISE_UP_SPEED
	local var1_38 = var0_38[#var0_38][2]

	for iter0_38, iter1_38 in ipairs(var0_38) do
		if arg0_38 < iter1_38[1] then
			var1_38 = iter1_38[2]

			break
		end
	end

	return var1_38
end

function var0_0.Update(arg0_39)
	if arg0_39.ground.sleepTime > 0 then
		arg0_39.ground.sleepTime = arg0_39.ground.sleepTime - Time.deltaTime

		arg0_39:SendMapEvent("OnGroundSleepTimeChange", arg0_39.ground.sleepTime)
	end

	if arg0_39.ground.IsRuning and arg0_39.ground.sleepTime <= 0 then
		local var0_39 = arg0_39.ground.position
		local var1_39 = var3_0(arg0_39.higestLevel)

		arg0_39.ground.position = Vector2(var0_39.x, var0_39.y + var1_39 * Time.deltaTime)

		arg0_39:SendMapEvent("OnGroundPositionChange", arg0_39.ground.position)
	end

	if arg0_39.player:IsInvincible() then
		local var2_39 = arg0_39.player:GetInvincibleTime()

		if var2_39 == TowerClimbingGameSettings.INVINCEIBLE_TIME then
			arg0_39:AddPlayerInvincibleEffect(true)
		end

		local var3_39 = var2_39 - Time.deltaTime

		arg0_39.player:SetInvincibleTime(var3_39)

		if not arg0_39.player:IsInvincible() then
			arg0_39:AddPlayerInvincibleEffect(false)
		end
	end
end

function var0_0.SetGroundSleep(arg0_40, arg1_40)
	if arg0_40.ground.IsRuning then
		arg0_40.ground.position = Vector2(arg0_40.ground.position.x, arg0_40.ground.position.y - TowerClimbingGameSettings.GROUND_SLIDE_DOWNWARD_DISTANCE)

		arg0_40:SendMapEvent("OnGroundPositionChange", arg0_40.ground.position)

		arg0_40.ground.sleepTime = arg1_40
	end
end

function var0_0.SendMapEvent(arg0_41, arg1_41, ...)
	local var0_41 = arg0_41.view.map

	var0_41[arg1_41](var0_41, unpack({
		...
	}))
end

function var0_0.Dispose(arg0_42)
	if arg0_42.player then
		arg0_42.player:Dispose()

		arg0_42.player = nil
	end

	if arg0_42.ground then
		arg0_42.ground = nil
	end

	if arg0_42.blocks then
		arg0_42.blocks = nil
	end
end

return var0_0
