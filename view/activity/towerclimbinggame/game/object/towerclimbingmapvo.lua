local var0 = class("TowerClimbingMapVO")

function var0.Ctor(arg0, arg1, arg2)
	arg0.view = arg2
	arg0.nextBlockIndex = 0
	arg0.level = 0
	arg0.higestLevel = 0
	arg0.id = arg1

	assert(arg0.id, arg1)
end

function var0.Init(arg0, arg1, arg2)
	arg0.mapWidth = arg1.screenWidth
	arg0.mapHeight = arg1.screenHeight
	arg0.awards = arg1.awards[arg0.id]

	seriesAsync({
		function(arg0)
			arg0:InitBlock(arg0)
		end,
		function(arg0)
			arg0:InitPlayer(arg1, arg0)
		end,
		function(arg0)
			arg0:InitGround(arg1, arg0)
		end,
		function(arg0)
			local var0 = arg0.blocks[1]

			assert(var0)
			arg0.player:SetPosition(var0.position)
			arg0:SendMapEvent("OnPlayerLifeUpdate", arg0.player.life)
			arg0()
		end
	}, arg2)
end

function var0.InitGround(arg0, arg1, arg2)
	local var0 = TowerClimbingGameSettings.MANJUU_START_POS

	arg0.ground = {
		sleepTime = 0,
		IsRuning = false,
		position = var0,
		name = arg1.npcName
	}

	arg0:SendMapEvent("OnCreateGround", arg0.ground, arg2)
end

function var0.InitBlock(arg0, arg1)
	arg0.blocks = {}

	local var0 = {}
	local var1 = TowerClimbingGameSettings.GetBlockInitCnt(arg0.mapHeight)

	for iter0 = 1, var1 do
		table.insert(var0, function(arg0)
			local var0 = arg0:CreateBlock()

			table.insert(arg0.blocks, var0)
			arg0:SendMapEvent("OnCreateBlock", var0, arg0)
		end)
	end

	parallelAsync(var0, arg1)
end

local function var1(arg0, arg1)
	if arg0 == 1 then
		return TowerClimbingGameSettings.HEAD_BLOCK_TYPE
	else
		local var0 = TowerClimbingGameSettings.MapId2BlockType[arg1]

		assert(var0, arg1)

		local var1 = math.random(1, 100)

		for iter0, iter1 in ipairs(var0) do
			if var1 <= iter1[2] then
				return iter1[1]
			end
		end

		assert(false)
	end
end

local function var2(arg0, arg1)
	if not arg1 then
		return TowerClimbingGameSettings.BLOCK_START_POSITION
	else
		local var0 = arg1.position
		local var1 = arg1.width
		local var2 = TowerClimbingGameSettings.BLOCK_INTERVAL_HEIGHT
		local var3 = TowerClimbingGameSettings.BLOCK_MAX_INTERVAL_WIDTH[1]
		local var4 = TowerClimbingGameSettings.BLOCK_MAX_INTERVAL_WIDTH[2]
		local var5 = TowerClimbingGameSettings.BOUNDS[1]
		local var6 = TowerClimbingGameSettings.BOUNDS[2]
		local var7 = {}
		local var8 = var0.x + var1 / 2
		local var9 = var6 - var8 - arg0

		if var3 < var9 then
			local var10 = math.min(var4, var9)
			local var11 = var3

			if var9 >= 0 then
				var11 = 0
			end

			local var12 = math.random(var11, var10)

			table.insert(var7, var8 + var12 + arg0 / 2)
		end

		local var13 = var0.x - var1 / 2
		local var14 = math.abs(var5 - var13) - arg0

		if var3 < var14 then
			local var15 = math.min(var4, var14)
			local var16 = var3

			if var14 >= 0 then
				var16 = 0
			end

			local var17 = math.random(var16, var15)

			table.insert(var7, var13 - var17 - arg0 / 2)
		end

		assert(#var7 > 0, var9 .. " & " .. var14 .. " - " .. arg0 .. " - " .. var0.x .. "-" .. var1)

		local var18 = math.random(1, #var7)

		return Vector2(var7[var18], var0.y + var2)
	end
end

function var0.CreateBlock(arg0)
	arg0.nextBlockIndex = arg0.nextBlockIndex + 1

	local var0 = arg0.blocks[#arg0.blocks]
	local var1 = var1(arg0.nextBlockIndex, arg0.id)
	local var2 = var2(var1[2], var0)

	return {
		id = arg0.nextBlockIndex,
		type = var1[1],
		width = var1[2],
		position = var2,
		isActive = not var0,
		level = arg0.nextBlockIndex
	}
end

function var0.ActicveNextBlock(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.blocks) do
		if iter1.level == arg1 then
			iter1.isActive = true

			arg0:SendMapEvent("OnActiveBlock", iter1)

			if arg0.player:IsInvincible() then
				arg0:SendMapEvent("OnEnableStab", iter1, false)
			end

			break
		end
	end
end

function var0.DeactiveAboveBlocks(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.blocks) do
		if arg1 < iter1.level and iter1.isActive == true then
			iter1.isActive = false

			arg0:SendMapEvent("OnActiveBlock", iter1)
		end
	end
end

function var0.AddNewBlock(arg0, arg1)
	local var0 = arg0:CreateBlock()

	table.insert(arg0.blocks, var0)
	arg0:SendMapEvent("OnCreateBlock", var0, arg1)
end

function var0.DoSink(arg0, arg1, arg2, arg3)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:SendMapEvent("SinkHandler", TowerClimbingGameSettings.SINK_DISTANCE * arg2)
	end)
	table.insert(var0, 1, function(arg0)
		if not arg0.ground.IsRuning then
			arg0()

			return
		end

		local var0 = arg0.ground.position
		local var1 = var0.y - TowerClimbingGameSettings.SINK_DISTANCE * arg2

		arg0.ground.position = Vector2(var0.x, var1)

		arg0:SendMapEvent("OnGroundPositionChange", arg0.ground.position)
		arg0()
	end)
	parallelAsync(var0, arg3)
end

function var0.CheckCorssBoundBlocks(arg0, arg1)
	local var0 = 0

	for iter0 = #arg0.blocks, 1, -1 do
		local var1 = arg0.blocks[iter0]

		if var0 >= var1.position.y then
			local var2 = var1.level

			table.remove(arg0.blocks, iter0)
			arg0:SendMapEvent("OnBlockDestory", var2)
		elseif TowerClimbingGameSettings.MANJUU_HEIGHT + arg0.ground.position.y >= var1.position.y then
			var1.isActive = false

			arg0:SendMapEvent("OnActiveBlock", var1)
		end
	end

	arg1()
end

function var0.InitPlayer(arg0, arg1, arg2)
	local var0 = arg1.life
	local var1 = arg1.score
	local var2 = arg1.shipId
	local var3 = arg1.higestscore
	local var4 = arg1.pageIndex
	local var5 = arg1.mapScores[arg0.id]

	arg0.player = TowerClimbingPlayerVO.New(arg0.view, {
		id = var2,
		life = var0,
		score = var1,
		higestscore = var3,
		pageIndex = var4,
		mapScore = var5
	})

	arg0:SendMapEvent("OnCreatePlayer", arg0.player, arg2)
end

function var0.GetPlayer(arg0)
	return arg0.player
end

function var0.GetBlocks(arg0)
	return arg0.blocks
end

function var0.SetCurrentLevel(arg0, arg1)
	if arg1 > arg0.level then
		arg0:ActicveNextBlock(arg1 + 1)
	elseif arg1 < arg0.level then
		arg0:DeactiveAboveBlocks(arg1 + 1)
	end

	arg0.level = arg1

	if arg1 > arg0.higestLevel then
		local var0 = arg1 - arg0.higestLevel

		arg0.higestLevel = arg1

		arg0.player:AddScore()
		arg0:DoCheck(var0)
		arg0:OverHigestScore()
	end
end

function var0.OverHigestScore(arg0)
	local function var0(arg0)
		for iter0, iter1 in ipairs(arg0.awards) do
			if arg0 == iter1 then
				return true
			end
		end

		return false
	end

	if arg0.player:IsOverHigestScore() and var0(arg0.player.score) then
		arg0:SendMapEvent("OnReachAwardScore")
	end
end

function var0.DoCheck(arg0, arg1)
	if arg0.higestLevel <= 1 then
		return
	end

	seriesAsync({
		function(arg0)
			arg0:AddNewBlock(arg0)
		end,
		function(arg0)
			parallelAsync({
				function(arg0)
					arg0:DoSink(arg0.higestLevel, arg1, arg0)
				end,
				function(arg0)
					local var0 = TowerClimbingGameSettings.SINK_DISTANCE * arg1

					arg0:SendMapEvent("OnSink", var0, arg0)
				end
			}, arg0)
		end,
		function(arg0)
			arg0:CheckCorssBoundBlocks(arg0)
		end,
		function(arg0)
			arg0:CheckGroundState()
			arg0()
		end
	})
end

function var0.CheckGroundState(arg0)
	if not arg0.ground.IsRuning and arg0.higestLevel >= TowerClimbingGameSettings.GROUND_RISE_UP_LEVEL then
		arg0.ground.IsRuning = true

		arg0:SendMapEvent("OnGroundRuning")
	end
end

function var0.ReBornPlayer(arg0)
	local var0 = {}
	local var1

	for iter0, iter1 in ipairs(arg0.blocks) do
		if iter1.isActive then
			table.insert(var0, iter1)
		end
	end

	assert(#var0 > 0)

	local var2 = _.detect(var0, function(arg0)
		return arg0.level == arg0.higestLevel
	end)

	if not var2 then
		table.sort(var0, function(arg0, arg1)
			return arg0.position.y > arg1.position.y
		end)

		var2 = var0[1]
	end

	arg0.player:SetPosition(var2.position + Vector2(0, 10))
end

function var0.AddPlayerInvincibleEffect(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.blocks) do
		if iter1.isActive then
			arg0:SendMapEvent("OnEnableStab", iter1, not arg1)
		end
	end

	if arg0.ground.IsRuning then
		arg0:SendMapEvent("OnEnableGround", not arg1)
	end
end

local function var3(arg0)
	local var0 = TowerClimbingGameSettings.GROUND_RISE_UP_SPEED
	local var1 = var0[#var0][2]

	for iter0, iter1 in ipairs(var0) do
		if arg0 < iter1[1] then
			var1 = iter1[2]

			break
		end
	end

	return var1
end

function var0.Update(arg0)
	if arg0.ground.sleepTime > 0 then
		arg0.ground.sleepTime = arg0.ground.sleepTime - Time.deltaTime

		arg0:SendMapEvent("OnGroundSleepTimeChange", arg0.ground.sleepTime)
	end

	if arg0.ground.IsRuning and arg0.ground.sleepTime <= 0 then
		local var0 = arg0.ground.position
		local var1 = var3(arg0.higestLevel)

		arg0.ground.position = Vector2(var0.x, var0.y + var1 * Time.deltaTime)

		arg0:SendMapEvent("OnGroundPositionChange", arg0.ground.position)
	end

	if arg0.player:IsInvincible() then
		local var2 = arg0.player:GetInvincibleTime()

		if var2 == TowerClimbingGameSettings.INVINCEIBLE_TIME then
			arg0:AddPlayerInvincibleEffect(true)
		end

		local var3 = var2 - Time.deltaTime

		arg0.player:SetInvincibleTime(var3)

		if not arg0.player:IsInvincible() then
			arg0:AddPlayerInvincibleEffect(false)
		end
	end
end

function var0.SetGroundSleep(arg0, arg1)
	if arg0.ground.IsRuning then
		arg0.ground.position = Vector2(arg0.ground.position.x, arg0.ground.position.y - TowerClimbingGameSettings.GROUND_SLIDE_DOWNWARD_DISTANCE)

		arg0:SendMapEvent("OnGroundPositionChange", arg0.ground.position)

		arg0.ground.sleepTime = arg1
	end
end

function var0.SendMapEvent(arg0, arg1, ...)
	local var0 = arg0.view.map

	var0[arg1](var0, unpack({
		...
	}))
end

function var0.Dispose(arg0)
	if arg0.player then
		arg0.player:Dispose()

		arg0.player = nil
	end

	if arg0.ground then
		arg0.ground = nil
	end

	if arg0.blocks then
		arg0.blocks = nil
	end
end

return var0
