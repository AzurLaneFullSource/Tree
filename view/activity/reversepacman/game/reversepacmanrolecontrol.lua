local var0_0 = class("ReversePacmanRoleControl")
local var1_0 = 0.12
local var2_0 = 0.05
local var3_0 = 1
local var4_0 = 0.15
local var5_0 = 1.4
local var6_0 = 0.9
local var7_0 = 0.2
local var8_0 = 0.04
local var9_0 = 1
local var10_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._tpls = arg0_1._tf:Find("tpls")
	arg0_1.container = arg0_1._tf:Find("map/roles")
end

function var0_0.SetUp(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.shipIds = arg1_2
	arg0_2.map = arg2_2
	arg0_2.gameEnded = false
	arg0_2.gameTime = 0
	arg0_2.graphVersion = 0
	arg0_2.monsterVersion = 0
	arg0_2.shipMoveVersion = 0
	arg0_2.monsterMoveVersion = 0
	arg0_2.nearestTargetCache = {}
	arg0_2.monsterThreatFieldCache = nil
	arg0_2.shipTriggerStates = {}
	arg0_2.aliveMonsterCacheVersion = -1
	arg0_2.aliveMonsterCache = nil
	arg0_2.lastShipPerformanceEmitTime = nil
	arg0_2.eduBuffCnt = arg3_2

	local var0_2 = pg.activity_chasing_skill[ReversePacmanConst.BUFF_EDU].param

	arg0_2.eduBuffMul = math.pow(tonumber(var0_2), arg0_2.eduBuffCnt)
	arg0_2.ships = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.map:GetDeployPoints()) do
		local var1_2 = arg0_2.shipIds[iter0_2]

		if var1_2 and var1_2 ~= 0 then
			local var2_2 = cloneTplTo(arg0_2._tpls:Find("ship"), arg0_2.container, "ship_" .. iter0_2 .. "_" .. var1_2)

			setLocalPosition(var2_2, arg0_2.map:GetLocalPosInMap(iter1_2.x, iter1_2.y))

			local var3_2 = ReversePacmanRole.New(arg0_2.binder, var2_2, {
				type = ReversePacmanConst.ROLE.SHIP,
				id = var1_2,
				nodeId = arg0_2.map:GetNodeIdByPos(iter1_2.x, iter1_2.y),
				eduBuffMul = arg0_2.eduBuffMul
			})

			table.insert(arg0_2.ships, var3_2)
		end
	end

	arg0_2.monsters = {}

	for iter2_2, iter3_2 in ipairs(arg0_2.map:GetSpawnPoints()) do
		local var4_2 = iter3_2.monsterConfigId
		local var5_2 = cloneTplTo(arg0_2._tpls:Find("monster"), arg0_2.container, "monister_" .. iter2_2 .. "_" .. var4_2)

		setLocalPosition(var5_2, arg0_2.map:GetLocalPosInMap(iter3_2.x, iter3_2.y))

		local var6_2 = ReversePacmanRole.New(arg0_2.binder, var5_2, {
			type = ReversePacmanConst.ROLE.MONSTER,
			id = var4_2,
			nodeId = arg0_2.map:GetNodeIdByPos(iter3_2.x, iter3_2.y)
		})

		table.insert(arg0_2.monsters, var6_2)
	end

	if not arg0_2._graphChangedListenerAdded then
		arg0_2._graphChangedListenerAdded = true

		arg0_2.binder:bind(ReversePacmanConst.EVENT.GRAPH_CHANGED, function()
			arg0_2.graphVersion = (arg0_2.graphVersion or 0) + 1
			arg0_2.aliveMonsterCacheVersion = -1
			arg0_2.aliveMonsterCache = nil
			arg0_2.monsterThreatFieldCache = nil

			for iter0_3, iter1_3 in ipairs(arg0_2.ships) do
				iter1_3:RequestReplan()
			end

			for iter2_3, iter3_3 in ipairs(arg0_2.monsters) do
				iter3_3:RequestReplan()
			end
		end)
	end
end

function var0_0.SetGameEnded(arg0_4, arg1_4)
	arg0_4.gameEnded = arg1_4 and true or false
end

function var0_0.GetShipTriggerState(arg0_5, arg1_5)
	arg0_5.shipTriggerStates = arg0_5.shipTriggerStates or {}
	arg0_5.shipTriggerStates[arg1_5] = arg0_5.shipTriggerStates[arg1_5] or {}

	return arg0_5.shipTriggerStates[arg1_5]
end

function var0_0.GetAliveMonsters(arg0_6)
	if arg0_6.aliveMonsterCacheVersion == arg0_6.monsterVersion and arg0_6.aliveMonsterCache then
		return arg0_6.aliveMonsterCache
	end

	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.monsters) do
		if iter1_6:IsAlive() then
			var0_6[#var0_6 + 1] = iter1_6
		end
	end

	arg0_6.aliveMonsterCacheVersion = arg0_6.monsterVersion
	arg0_6.aliveMonsterCache = var0_6

	return var0_6
end

function var0_0.FindNearestTarget(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7)
	local var0_7 = arg0_7.nearestTargetCache[arg1_7]

	if var0_7 and var0_7.nodeId == arg1_7.nodeId and var0_7.graphVersion == (arg3_7 or 0) and var0_7.targetMoveVersion == (arg4_7 or 0) and var0_7.targetDeathVersion == (arg5_7 or 0) and var0_7.target and var0_7.target:IsAlive() and var0_7.target.nodeId then
		return var0_7.target
	end

	local var1_7 = arg0_7.map and arg0_7.map:GetRouteGraph()

	if not var1_7 then
		return nil
	end

	local var2_7 = arg1_7.nodeId
	local var3_7 = var1_7:GetDistanceField(var2_7)
	local var4_7
	local var5_7

	for iter0_7, iter1_7 in ipairs(arg2_7) do
		if iter1_7:IsAlive() then
			local var6_7 = iter1_7.nodeId

			if var6_7 then
				local var7_7 = var3_7[var6_7]

				if var7_7 and (not var5_7 or var7_7 < var5_7) then
					var5_7 = var7_7
					var4_7 = iter1_7
				end
			end
		end
	end

	arg0_7.nearestTargetCache[arg1_7] = {
		nodeId = arg1_7.nodeId,
		graphVersion = arg3_7 or 0,
		targetMoveVersion = arg4_7 or 0,
		targetDeathVersion = arg5_7 or 0,
		target = var4_7
	}

	return var4_7
end

function var0_0.Update(arg0_8, arg1_8)
	if not arg0_8.map or arg0_8.gameEnded then
		return
	end

	arg0_8.gameTime = (arg0_8.gameTime or 0) + arg1_8

	local var0_8 = arg0_8:GetAliveMonsters()
	local var1_8 = arg0_8.map:GetCanPickBuffs()

	for iter0_8, iter1_8 in ipairs(arg0_8.monsters) do
		if arg0_8.gameEnded then
			return
		end

		if iter1_8:IsAlive() then
			iter1_8:Update(arg1_8)

			local var2_8 = iter1_8.nodeId

			if iter1_8:NeedResetPath() or arg0_8:IsMonsterNextStepClaimed(iter1_8) then
				local var3_8 = arg0_8:GetScoreMaxPath(iter1_8)

				iter1_8:SetPath(var3_8)
			end

			iter1_8:MoveAlongPath(arg1_8, arg0_8.map)

			if iter1_8.nodeId ~= var2_8 then
				arg0_8.monsterMoveVersion = (arg0_8.monsterMoveVersion or 0) + 1
			end
		end
	end

	for iter2_8, iter3_8 in ipairs(arg0_8.ships) do
		if arg0_8.gameEnded then
			return
		end

		if iter3_8:IsAlive() then
			iter3_8:Update(arg1_8)

			local var4_8 = iter3_8.nodeId

			if iter3_8:NeedResetPath() then
				local var5_8 = arg0_8:FindNearestTarget(iter3_8, var0_8, arg0_8.graphVersion, arg0_8.monsterMoveVersion, arg0_8.monsterVersion)

				if var5_8 then
					local var6_8 = arg0_8:GetScoreMaxPath(iter3_8, var5_8)

					iter3_8:SetPath(var6_8)
				end
			end

			iter3_8:MoveAlongPath(arg1_8, arg0_8.map)

			if iter3_8.nodeId ~= var4_8 then
				arg0_8.shipMoveVersion = (arg0_8.shipMoveVersion or 0) + 1
			end

			if arg0_8.gameEnded then
				return
			end

			arg0_8:UpdateShipPerformanceTriggers(iter3_8, var0_8)

			if arg0_8.gameEnded then
				return
			end

			for iter4_8, iter5_8 in ipairs(var0_8) do
				if arg0_8.gameEnded then
					return
				end

				if iter5_8:IsAlive() and arg0_8:IsCatchable(iter3_8, iter5_8) then
					iter5_8:Kill()

					arg0_8.monsterVersion = (arg0_8.monsterVersion or 0) + 1
					arg0_8.aliveMonsterCacheVersion = -1
					arg0_8.aliveMonsterCache = nil

					arg0_8:EmitShipPerformance(iter3_8, iter5_8, ReversePacmanConst.SHIP_PERFORMANCE_TYPE.CAPTURE)
					arg0_8.binder:emit(ReversePacmanConst.EVENT.CAPTURE, {
						ship = iter3_8,
						monster = iter5_8
					})

					if arg0_8.gameEnded then
						return
					end
				end
			end

			for iter6_8, iter7_8 in ipairs(var1_8) do
				if arg0_8.gameEnded then
					return
				end

				if arg0_8:IsPickBuff(iter3_8, iter7_8) then
					iter3_8:AddBuff(iter7_8.id)
					arg0_8.binder:emit(ReversePacmanConst.EVENT.PICK, {
						ship = iter3_8,
						buff = iter7_8
					})

					if arg0_8.gameEnded then
						return
					end
				end
			end
		end
	end
end

function var0_0.UpdateShipPerformanceTriggers(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetShipTriggerState(arg1_9)
	local var1_9 = var0_9.cachedPerformanceTarget
	local var2_9
	local var3_9

	if var1_9 and var1_9.nodeId == arg1_9.nodeId and var1_9.pathIndex == arg1_9.pathIndex and var1_9.graphVersion == arg0_9.graphVersion and var1_9.monsterMoveVersion == arg0_9.monsterMoveVersion and var1_9.monsterDeathVersion == arg0_9.monsterVersion and var1_9.target and var1_9.target:IsAlive() then
		var2_9 = var1_9.target
		var3_9 = var1_9.dist
	else
		var2_9, var3_9 = arg0_9:FindNearestAliveMonsterByDistance(arg1_9, arg2_9)
	end

	if not var2_9 then
		var0_9.nearMonster = nil
		var0_9.farMonster = nil

		return
	end

	if var3_9 <= arg1_9:GetPerformanceRange(ReversePacmanConst.SHIP_PERFORMANCE_TYPE.NEAR) then
		if var0_9.nearMonster ~= var2_9 then
			var0_9.nearMonster = var2_9

			if arg0_9:CanEmitShipPerformance(var0_9, ReversePacmanConst.SHIP_PERFORMANCE_TYPE.NEAR) then
				var0_9.lastEmitTime = var0_9.lastEmitTime or {}
				var0_9.lastEmitTime[ReversePacmanConst.SHIP_PERFORMANCE_TYPE.NEAR] = arg0_9.gameTime

				arg0_9:EmitShipPerformance(arg1_9, var2_9, ReversePacmanConst.SHIP_PERFORMANCE_TYPE.NEAR)
			end
		end
	else
		var0_9.nearMonster = nil
	end

	if var3_9 >= arg1_9:GetPerformanceRange(ReversePacmanConst.SHIP_PERFORMANCE_TYPE.FAR) then
		if var0_9.farMonster ~= var2_9 then
			var0_9.farMonster = var2_9

			if arg0_9:CanEmitShipPerformance(var0_9, ReversePacmanConst.SHIP_PERFORMANCE_TYPE.FAR) then
				var0_9.lastEmitTime = var0_9.lastEmitTime or {}
				var0_9.lastEmitTime[ReversePacmanConst.SHIP_PERFORMANCE_TYPE.FAR] = arg0_9.gameTime

				arg0_9:EmitShipPerformance(arg1_9, var2_9, ReversePacmanConst.SHIP_PERFORMANCE_TYPE.FAR)
			end
		end
	else
		var0_9.farMonster = nil
	end

	var0_9.cachedPerformanceTarget = {
		nodeId = arg1_9.nodeId,
		pathIndex = arg1_9.pathIndex,
		graphVersion = arg0_9.graphVersion,
		monsterMoveVersion = arg0_9.monsterMoveVersion,
		monsterDeathVersion = arg0_9.monsterVersion,
		target = var2_9,
		dist = var3_9
	}
end

function var0_0.CanEmitShipPerformance(arg0_10, arg1_10, arg2_10)
	arg1_10.lastEmitTime = arg1_10.lastEmitTime or {}

	local var0_10 = arg1_10.lastEmitTime[arg2_10]
	local var1_10 = arg0_10.lastShipPerformanceEmitTime

	if not var0_10 then
		return not var1_10 or arg0_10.gameTime - var1_10 >= ReversePacmanConst.SHIP_PERFORMANCE_GLOBAL_COOLDOWN
	end

	if arg0_10.gameTime - var0_10 < ReversePacmanConst.SHIP_PERFORMANCE_COOLDOWN then
		return false
	end

	return not var1_10 or arg0_10.gameTime - var1_10 >= ReversePacmanConst.SHIP_PERFORMANCE_GLOBAL_COOLDOWN
end

function var0_0.FindNearestAliveMonsterByDistance(arg0_11, arg1_11, arg2_11)
	local var0_11
	local var1_11
	local var2_11 = arg2_11 or arg0_11.monsters

	for iter0_11, iter1_11 in ipairs(var2_11) do
		if iter1_11:IsAlive() then
			local var3_11 = arg0_11:GetDistance(arg1_11, iter1_11)

			if not var1_11 or var3_11 < var1_11 then
				var1_11 = var3_11
				var0_11 = iter1_11
			end
		end
	end

	return var0_11, var1_11
end

function var0_0.EmitShipPerformance(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12.lastShipPerformanceEmitTime = arg0_12.gameTime

	arg0_12.binder:emit(ReversePacmanConst.EVENT.SHIP_PERFORMANCE, {
		type = arg3_12,
		ship = arg1_12,
		monster = arg2_12,
		shipId = arg1_12.id,
		monsterId = arg2_12 and arg2_12.id or nil,
		distance = arg2_12 and arg0_12:GetDistance(arg1_12, arg2_12) or nil
	})
end

function var0_0.CheckGameEnd(arg0_13)
	local var0_13 = arg0_13.map and arg0_13.map:GetRouteGraph()

	return underscore.all(arg0_13.monsters, function(arg0_14)
		return not arg0_14:IsAlive() or arg0_13:IsMonsterTrapped(arg0_14, var0_13)
	end)
end

function var0_0.GetAliveMonsterCnt(arg0_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in ipairs(arg0_15.monsters) do
		if iter1_15:IsAlive() then
			var0_15 = var0_15 + 1
		end
	end

	return var0_15
end

function var0_0.GetCapturedMonsterCnt(arg0_16)
	return #arg0_16.monsters - arg0_16:GetAliveMonsterCnt()
end

function var0_0.GetMonsterCnt(arg0_17)
	return #arg0_17.monsters
end

function var0_0.GetShipCnt(arg0_18)
	return #arg0_18.ships
end

function var0_0.GetAliveShipCnt(arg0_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in ipairs(arg0_19.ships) do
		if iter1_19:IsAlive() then
			var0_19 = var0_19 + 1
		end
	end

	return var0_19
end

function var0_0.IsCellOccupied(arg0_20, arg1_20)
	local var0_20 = arg0_20.map:GetNodeIdByPos(arg1_20.x, arg1_20.y)

	if not var0_20 then
		return false
	end

	return arg0_20:IsNodeOccupied(var0_20)
end

function var0_0.IsNodeOccupied(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.ships) do
		if iter1_21:IsAlive() and iter1_21:IsOccupyingNode(arg1_21) then
			return true
		end
	end

	for iter2_21, iter3_21 in ipairs(arg0_21.monsters) do
		if iter3_21:IsAlive() and iter3_21:IsOccupyingNode(arg1_21) then
			return true
		end
	end

	return false
end

function var0_0.CheckAllMonstersTrapped(arg0_22)
	local var0_22 = arg0_22.map and arg0_22.map:GetRouteGraph()

	if not var0_22 or arg0_22:GetAliveMonsterCnt() <= 0 or arg0_22:GetAliveShipCnt() <= 0 then
		return false
	end

	for iter0_22, iter1_22 in ipairs(arg0_22.monsters) do
		if iter1_22:IsAlive() and not arg0_22:IsMonsterTrapped(iter1_22, var0_22) then
			return false
		end
	end

	return true
end

function var0_0.IsMonsterTrapped(arg0_23, arg1_23, arg2_23)
	if not arg1_23 or not arg1_23.nodeId or not arg2_23 then
		return false
	end

	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(arg0_23.ships) do
		if iter1_23:IsAlive() and iter1_23.nodeId then
			var0_23[iter1_23.nodeId] = true
		end
	end

	local var1_23 = {}
	local var2_23 = {
		arg1_23.nodeId
	}
	local var3_23 = 1

	var1_23[arg1_23.nodeId] = true

	local var4_23 = 0

	while var2_23[var3_23] do
		local var5_23 = var2_23[var3_23]

		var3_23 = var3_23 + 1
		var4_23 = var4_23 + 1

		if var0_23[var5_23] then
			return false
		end

		for iter2_23, iter3_23 in ipairs(arg2_23:GetNeighbors(var5_23)) do
			if not var1_23[iter3_23] then
				var1_23[iter3_23] = true
				var2_23[#var2_23 + 1] = iter3_23
			end
		end
	end

	local var6_23 = #(arg2_23.nodes or {})

	return var4_23 <= math.max(ReversePacmanConst.MONSTER_TRAP_MIN_COMPONENT_NODES, math.ceil(var6_23 * ReversePacmanConst.MONSTER_TRAP_COMPONENT_RATIO))
end

function var0_0.GetScoreMaxPath(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.map:GetRouteGraph()

	if not var0_24 or not arg1_24 or not arg1_24.nodeId then
		return {
			arg1_24 and arg1_24.nodeId
		}
	end

	local var1_24 = var0_24:GetNodeById(arg1_24.nodeId)

	if not var1_24 then
		return {
			arg1_24.nodeId
		}
	end

	if arg0_24:IsEscapeMode(arg1_24) then
		return arg0_24:BuildEscapePath(var0_24, arg1_24.nodeId, arg1_24) or {
			arg1_24.nodeId
		}
	end

	if not arg2_24 or not arg2_24.nodeId then
		return {
			arg1_24.nodeId
		}
	end

	local var2_24 = var0_24:GetNodeById(arg2_24.nodeId)

	if not var2_24 then
		return {
			arg1_24.nodeId
		}
	end

	local var3_24 = arg1_24._prevNodeId
	local var4_24 = {}

	for iter0_24, iter1_24 in ipairs(var1_24.neighbors) do
		if iter1_24 ~= var3_24 then
			var4_24[#var4_24 + 1] = iter1_24
		end
	end

	if #var4_24 == 0 then
		var4_24 = var1_24.neighbors
	end

	local var5_24
	local var6_24 = -math.huge

	for iter2_24, iter3_24 in ipairs(var4_24) do
		local var7_24, var8_24 = arg0_24:GetScore(iter3_24, arg1_24, arg2_24, var0_24)
		local var9_24 = var7_24 - var8_24

		if var6_24 < var9_24 then
			var6_24 = var9_24
			var5_24 = iter3_24
		end
	end

	if not var5_24 then
		return {
			arg1_24.nodeId
		}
	end

	return var0_24:FindPath(var5_24, var2_24.id) or {
		arg1_24.nodeId
	}
end

function var0_0.IsEscapeMode(arg0_25, arg1_25)
	return (arg1_25:GetConfig("ai_target_weight") or 0) < 0
end

local function var11_0(arg0_26, arg1_26, arg2_26, arg3_26)
	if not arg2_26 or arg1_26[arg2_26] or not arg3_26:GetNodeById(arg2_26) or arg3_26:IsBuffBlockById(arg2_26) then
		return
	end

	arg1_26[arg2_26] = true
	arg0_26[#arg0_26 + 1] = arg2_26
end

function var0_0.GetMonsterThreatDistanceField(arg0_27, arg1_27)
	local var0_27 = {}
	local var1_27 = {}

	for iter0_27, iter1_27 in ipairs(arg0_27.ships) do
		if iter1_27:IsAlive() then
			var11_0(var0_27, var1_27, iter1_27.nodeId, arg1_27)

			local var2_27 = iter1_27.path and iter1_27.path[iter1_27.pathIndex]

			var11_0(var0_27, var1_27, var2_27, arg1_27)
		end
	end

	local var3_27 = (arg0_27.graphVersion or 0) .. ":" .. table.concat(var0_27, ",")
	local var4_27 = arg0_27.monsterThreatFieldCache

	if var4_27 and var4_27.signature == var3_27 then
		return var4_27.dist
	end

	local var5_27 = {}
	local var6_27 = {}

	for iter2_27, iter3_27 in ipairs(var0_27) do
		var5_27[iter3_27] = 0
		var6_27[#var6_27 + 1] = iter3_27
	end

	local var7_27 = 1

	while var6_27[var7_27] do
		local var8_27 = var6_27[var7_27]

		var7_27 = var7_27 + 1

		local var9_27 = var5_27[var8_27] + 1

		for iter4_27, iter5_27 in ipairs(arg1_27:GetNeighbors(var8_27)) do
			if var5_27[iter5_27] == nil then
				var5_27[iter5_27] = var9_27
				var6_27[#var6_27 + 1] = iter5_27
			end
		end
	end

	arg0_27.monsterThreatFieldCache = {
		signature = var3_27,
		dist = var5_27
	}

	return var5_27
end

function var0_0.IsMonsterNextStepClaimed(arg0_28, arg1_28)
	if not arg1_28 or not arg1_28.path then
		return false
	end

	local var0_28 = arg1_28.path[arg1_28.pathIndex]

	if not var0_28 or var0_28 == arg1_28.nodeId then
		return false
	end

	local var1_28 = arg0_28.map and arg0_28.map:GetRouteGraph()

	if not var1_28 then
		return false
	end

	return arg0_28:GetMonsterThreatDistanceField(var1_28)[var0_28] == 0
end

function var0_0.AnalyzeMonsterEscapeBranch(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = {
		[arg2_29] = true,
		[arg3_29] = true
	}
	local var1_29 = {
		[arg3_29] = arg2_29
	}
	local var2_29 = {
		arg3_29
	}
	local var3_29 = 1
	local var4_29 = 0
	local var5_29 = false

	while var2_29[var3_29] do
		local var6_29 = var2_29[var3_29]

		var3_29 = var3_29 + 1
		var4_29 = var4_29 + 1

		for iter0_29, iter1_29 in ipairs(arg1_29:GetNeighbors(var6_29)) do
			if iter1_29 == arg2_29 then
				if var6_29 ~= arg3_29 then
					var5_29 = true
				end
			elseif not var0_29[iter1_29] then
				var0_29[iter1_29] = true
				var1_29[iter1_29] = var6_29
				var2_29[#var2_29 + 1] = iter1_29
			elseif var1_29[var6_29] ~= iter1_29 then
				var5_29 = true
			end
		end
	end

	return var4_29, var5_29
end

function var0_0.GetMonsterTerrainScore(arg0_30, arg1_30, arg2_30)
	if not arg2_30 then
		return 0
	end

	local var0_30 = 0

	if arg2_30.tag == ReversePacmanConst.TAG.CORRIDOR then
		var0_30 = arg1_30:GetConfig("ai_terrain2_weight") or 0
	elseif arg2_30.tag == ReversePacmanConst.TAG.CORNER then
		var0_30 = arg1_30:GetConfig("ai_terrain3_weight") or 0
	elseif arg2_30.tag == ReversePacmanConst.TAG.JUNCTION then
		var0_30 = arg1_30:GetConfig("ai_terrain1_weight") or 0
	end

	return var0_30 * var1_0
end

function var0_0.GetMonsterRandomScore(arg0_31, arg1_31)
	local var0_31 = arg1_31:GetConfig("ai_random_weight")

	if not var0_31 or var0_31[1] == nil or var0_31[2] == nil or var0_31[1] > var0_31[2] then
		return 0
	end

	local var1_31 = math.ceil(var0_31[1])
	local var2_31 = math.floor(var0_31[2])

	if var2_31 < var1_31 then
		return 0
	end

	return math.random(var1_31, var2_31) * var2_0
end

local function var12_0(arg0_32, arg1_32)
	arg0_32[#arg0_32 + 1] = arg1_32

	local var0_32 = #arg0_32

	while var0_32 > 1 do
		local var1_32 = math.floor(var0_32 / 2)
		local var2_32 = arg0_32[var1_32]

		if not (arg1_32.bottleneck > var2_32.bottleneck or arg1_32.bottleneck == var2_32.bottleneck and arg1_32.length < var2_32.length) then
			break
		end

		arg0_32[var0_32] = var2_32
		var0_32 = var1_32
	end

	arg0_32[var0_32] = arg1_32
end

local function var13_0(arg0_33)
	local var0_33 = arg0_33[1]
	local var1_33 = table.remove(arg0_33)

	if #arg0_33 == 0 then
		return var0_33
	end

	local var2_33 = 1

	while true do
		local var3_33 = var2_33 * 2

		if var3_33 > #arg0_33 then
			break
		end

		local var4_33 = var3_33 + 1
		local var5_33 = var3_33

		if var4_33 <= #arg0_33 then
			local var6_33 = arg0_33[var3_33]
			local var7_33 = arg0_33[var4_33]

			if var7_33.bottleneck > var6_33.bottleneck or var7_33.bottleneck == var6_33.bottleneck and var7_33.length < var6_33.length then
				var5_33 = var4_33
			end
		end

		local var8_33 = arg0_33[var5_33]

		if var1_33.bottleneck > var8_33.bottleneck or var1_33.bottleneck == var8_33.bottleneck and var1_33.length <= var8_33.length then
			break
		end

		arg0_33[var2_33] = var8_33
		var2_33 = var5_33
	end

	arg0_33[var2_33] = var1_33

	return var0_33
end

function var0_0.GetMonsterFirstStepScore(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = (arg4_34:GetConfig("ai_deadend_weight") or 0) * var4_0
	local var1_34, var2_34 = arg0_34:AnalyzeMonsterEscapeBranch(arg1_34, arg2_34, arg3_34)
	local var3_34 = math.min(var1_34, 32) / 32 * var9_0

	if not var2_34 then
		var3_34 = var3_34 - var0_34 * (1 + 8 / math.max(3, var1_34 + 2))
	end

	local var4_34 = var3_34 + arg0_34:GetMonsterTerrainScore(arg4_34, arg1_34:GetNodeById(arg3_34)) + arg0_34:GetMonsterRandomScore(arg4_34)

	if arg3_34 == arg4_34._prevNodeId then
		var4_34 = var4_34 - var3_0
	end

	return var4_34
end

function var0_0.BuildEscapePath(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = arg1_35:GetNeighbors(arg2_35)

	if #var0_35 == 0 then
		return {
			arg2_35
		}
	end

	local var1_35 = math.max(1, arg1_35.height * arg1_35.width)
	local var2_35 = arg0_35:GetMonsterThreatDistanceField(arg1_35)

	local function var3_35(arg0_36)
		return var2_35[arg0_36] or var1_35
	end

	local var4_35 = {}

	for iter0_35, iter1_35 in ipairs(var0_35) do
		var4_35[iter1_35] = arg0_35:GetMonsterFirstStepScore(arg1_35, arg2_35, iter1_35, arg3_35)
	end

	local var5_35 = {
		[arg2_35] = var3_35(arg2_35)
	}
	local var6_35 = {
		[arg2_35] = 0
	}
	local var7_35 = {}
	local var8_35 = {}
	local var9_35 = {}

	var12_0(var9_35, {
		length = 0,
		nodeId = arg2_35,
		bottleneck = var5_35[arg2_35]
	})

	while #var9_35 > 0 do
		local var10_35 = var13_0(var9_35)
		local var11_35 = var10_35.nodeId

		if var10_35.bottleneck == var5_35[var11_35] and var10_35.length == var6_35[var11_35] then
			for iter2_35, iter3_35 in ipairs(arg1_35:GetNeighbors(var11_35)) do
				local var12_35 = var3_35(iter3_35)

				if var12_35 > 0 then
					local var13_35 = math.min(var10_35.bottleneck, var12_35)
					local var14_35 = var10_35.length + 1
					local var15_35 = var5_35[iter3_35]
					local var16_35 = var6_35[iter3_35]

					if var15_35 == nil or var15_35 < var13_35 or var13_35 == var15_35 and var14_35 < var16_35 then
						var5_35[iter3_35] = var13_35
						var6_35[iter3_35] = var14_35
						var7_35[iter3_35] = var11_35
						var8_35[iter3_35] = var11_35 == arg2_35 and iter3_35 or var8_35[var11_35]

						var12_0(var9_35, {
							nodeId = iter3_35,
							bottleneck = var13_35,
							length = var14_35
						})
					end
				end
			end
		end
	end

	local var17_35 = math.abs(arg3_35:GetConfig("ai_target_weight") or 0)
	local var18_35 = 1 + math.min(1, var17_35 / 10)
	local var19_35 = (arg3_35:GetConfig("ai_deadend_weight") or 0) * var4_0
	local var20_35
	local var21_35

	for iter4_35, iter5_35 in pairs(var5_35) do
		if iter4_35 ~= arg2_35 then
			local var22_35 = arg1_35:GetNodeById(iter4_35)
			local var23_35 = var8_35[iter4_35]
			local var24_35 = iter5_35 * var18_35 * var5_0 + var3_35(iter4_35) * var6_0 + (var22_35 and var22_35.degree or 0) * var7_0 + (var4_35[var23_35] or 0) - var6_35[iter4_35] * var8_0

			if var22_35 and var22_35.degree <= 1 then
				var24_35 = var24_35 - var19_35
			end

			if iter4_35 == arg3_35._escapeDestinationNodeId then
				var24_35 = var24_35 + var10_0
			end

			if not var21_35 or var21_35 < var24_35 then
				var21_35 = var24_35
				var20_35 = iter4_35
			end
		end
	end

	if not var20_35 then
		local var25_35
		local var26_35

		for iter6_35, iter7_35 in ipairs(var0_35) do
			local var27_35 = var3_35(iter7_35) * 100 + (var4_35[iter7_35] or 0)

			if not var26_35 or var26_35 < var27_35 then
				var26_35 = var27_35
				var25_35 = iter7_35
			end
		end

		return var25_35 and {
			arg2_35,
			var25_35
		} or {
			arg2_35
		}
	end

	local var28_35 = {}
	local var29_35 = var20_35

	while var29_35 do
		table.insert(var28_35, 1, var29_35)

		if var29_35 == arg2_35 then
			break
		end

		var29_35 = var7_35[var29_35]
	end

	if var28_35[1] ~= arg2_35 or #var28_35 < 2 then
		return {
			arg2_35,
			var0_35[1]
		}
	end

	arg3_35._escapeDestinationNodeId = var20_35

	return var28_35
end

function var0_0.GetProximityValue(arg0_37, arg1_37, arg2_37, arg3_37)
	if not arg3_37 then
		return 0
	end

	local var0_37 = arg1_37.height * arg1_37.width
	local var1_37 = arg1_37:GetDistanceById(arg2_37, arg3_37)

	if not var1_37 then
		return 0
	end

	return 1 - (var1_37 + 1) / var0_37
end

function var0_0.GetProximityScore(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	if not arg4_38 or arg4_38 == 0 then
		return 0
	end

	return arg0_38:GetProximityValue(arg1_38, arg2_38, arg3_38) * arg4_38
end

function var0_0.GetScore(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	local var0_39 = 0
	local var1_39 = 0

	local function var2_39(arg0_40, arg1_40)
		if not arg1_40 or arg1_40 == 0 then
			return
		end

		local var0_40 = arg0_39:GetProximityValue(arg4_39, arg1_39, arg0_40)

		if arg1_40 >= 0 then
			var0_39 = var0_39 + var0_40 * arg1_40
		else
			var1_39 = var1_39 + var0_40 * -arg1_40
		end
	end

	local function var3_39(arg0_41, arg1_41)
		if not arg1_41 or arg1_41 == 0 then
			return
		end

		if arg1_41 >= 0 then
			if arg0_41 then
				var0_39 = var0_39 + arg1_41
			end
		elseif arg0_41 then
			var1_39 = var1_39 + -arg1_41
		end
	end

	var2_39(arg3_39.nodeId, arg2_39:GetConfig("ai_target_weight"))

	local var4_39 = arg2_39:GetConfig("predict_offset") or 0

	var2_39(arg3_39:GetPredictNodeId(var4_39), arg2_39:GetConfig("ai_predict_weight"))
	var2_39(arg3_39:GetInterceptNodeId(var4_39), arg2_39:GetConfig("ai_intercept_weight"))

	local var5_39 = arg4_39:IsReachable(arg1_39, arg3_39.nodeId)

	var3_39(var5_39, arg2_39:GetConfig("ai_deadend_weight"))
	var2_39(arg0_39:FindNearestBuff(arg1_39), arg2_39:GetConfig("ai_pickup_weight"))

	local var6_39 = arg4_39:GetNodeById(arg1_39).tag

	var3_39(var6_39 == ReversePacmanConst.TAG.CORRIDOR, arg2_39:GetConfig("ai_terrain2_weight"))
	var3_39(var6_39 == ReversePacmanConst.TAG.CORNER, arg2_39:GetConfig("ai_terrain3_weight"))
	var3_39(var6_39 == ReversePacmanConst.TAG.JUNCTION, arg2_39:GetConfig("ai_terrain1_weight"))

	local var7_39 = arg2_39:GetConfig("ai_random_weight")
	local var8_39 = 0

	if var7_39 and var7_39[1] and var7_39[2] and var7_39[1] <= var7_39[2] then
		var8_39 = math.random(var7_39[1], var7_39[2]) * 0.1
	end

	return var0_39 + var8_39, var1_39
end

function var0_0.FindNearestBuff(arg0_42, arg1_42)
	local var0_42 = arg0_42.map and arg0_42.map:GetRouteGraph()

	if not var0_42 then
		return nil
	end

	local var1_42 = var0_42:GetDistanceField(arg1_42)
	local var2_42
	local var3_42

	for iter0_42, iter1_42 in ipairs(arg0_42.map:GetCanPickBuffs()) do
		local var4_42 = var0_42:GetNodeByPos(iter1_42.cell.x, iter1_42.cell.y)

		if var4_42 then
			local var5_42 = var1_42[var4_42.id]

			if var5_42 and (not var3_42 or var5_42 < var3_42) then
				var3_42 = var5_42
				var2_42 = var4_42.id
			end
		end
	end

	return var2_42
end

function var0_0.IsCatchable(arg0_43, arg1_43, arg2_43)
	return arg0_43:GetDistance(arg1_43, arg2_43) <= arg1_43:GetCaptureRadius() + arg2_43:GetCaptureRadius()
end

function var0_0.GetDistance(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg1_44.x - arg2_44.x
	local var1_44 = arg1_44.y - arg2_44.y

	return math.sqrt(var0_44 * var0_44 + var1_44 * var1_44)
end

function var0_0.IsPickBuff(arg0_45, arg1_45, arg2_45)
	return arg0_45:GetDistance(arg1_45, arg2_45) <= arg1_45:GetCaptureRadius() + ReversePacmanConst.GRID_SIZE.x / 2
end

function var0_0.Hide(arg0_46)
	for iter0_46, iter1_46 in ipairs(arg0_46.ships) do
		iter1_46:Hide()
	end

	for iter2_46, iter3_46 in ipairs(arg0_46.monsters) do
		iter3_46:Hide()
	end
end

function var0_0.Dispose(arg0_47)
	for iter0_47, iter1_47 in ipairs(arg0_47.ships) do
		iter1_47:Dispose()
	end

	for iter2_47, iter3_47 in ipairs(arg0_47.monsters) do
		iter3_47:Dispose()
	end

	arg0_47.nearestTargetCache = nil
	arg0_47.shipTriggerStates = nil
	arg0_47.aliveMonsterCache = nil
	arg0_47.aliveMonsterCacheVersion = nil
end

return var0_0
