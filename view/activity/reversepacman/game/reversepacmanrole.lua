local var0_0 = class("ReversePacmanRole")

var0_0.MAX_SPEED = 400
var0_0.MOVE_TYPE = {
	INTERVAL = 4,
	TURN = 2,
	STATIC = 3,
	STRAIGHT = 1
}
var0_0.SPEED_STATE = {
	SLOW_DOWN = "slowDown",
	STATIC = "static",
	NORMAL = "normal",
	SPEED_UP = "speedUp"
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.type = arg3_1.type
	arg0_1.id = arg3_1.id
	arg0_1.nodeId = arg3_1.nodeId
	arg0_1.iconTF = arg0_1._tf:Find("Image")
	arg0_1.speedUpTF = arg0_1._tf:Find("speedUp")
	arg0_1.slowDownTF = arg0_1._tf:Find("slowDown")
	arg0_1.staticTF = arg0_1._tf:Find("static")

	if arg0_1.type == ReversePacmanConst.ROLE.SHIP then
		LoadImageSpriteAsync(arg0_1:GetConfig("sd_avatar"), arg0_1.iconTF)
	end

	setText(arg0_1._tf:Find("Text"), arg0_1.id)
	setActive(arg0_1._tf:Find("Text"), false)

	arg0_1.x = arg0_1._tf.localPosition.x
	arg0_1.y = arg0_1._tf.localPosition.y
	arg0_1.alive = true
	arg0_1.isNeedResetPath = true

	arg0_1:ClearPath()

	arg0_1.baseSpeed = arg0_1:GetConfig("base_speed")
	arg0_1.buffMul = 1
	arg0_1.eduMul = arg3_1.eduBuffMul or 1
	arg0_1.moveType = arg0_1:GetConfig("movement_trait_type")
	arg0_1.moveAgr1 = arg0_1:GetConfig("movement_trait_param_1")
	arg0_1.moveAgr2 = tonumber(arg0_1:GetConfig("movement_trait_param_2"))
	arg0_1.moveMul = 1
	arg0_1._lastSegDir = nil
	arg0_1._straightCount = 0
	arg0_1._intervalTimer = 0
	arg0_1._intervalMoving = true
	arg0_1._intervalMul = 1

	if arg0_1.moveType == var0_0.MOVE_TYPE.STATIC then
		arg0_1.moveMul = 0
	end

	arg0_1.baseRadius = ReversePacmanConst.ROLE_RADIUS[arg0_1.type]
	arg0_1.buffRadiusMul = 1

	arg0_1:InitWords()
	arg0_1:RefreshSpeedState()
end

function var0_0.NeedResetPath(arg0_2)
	return arg0_2.isNeedResetPath
end

function var0_0.RequestReplan(arg0_3)
	arg0_3._pendingReplan = true
end

function var0_0.GetConfig(arg0_4, arg1_4)
	return pg.activity_chasing_character[arg0_4.id][arg1_4]
end

function var0_0.SetPath(arg0_5, arg1_5)
	arg0_5.path = arg1_5 or {}
	arg0_5.pathIndex = 1
	arg0_5.isNeedResetPath = false
end

function var0_0.ClearPath(arg0_6)
	arg0_6.path = {}
	arg0_6.pathIndex = 1
end

function var0_0.GetCurrentNodeId(arg0_7, arg1_7)
	return arg1_7:GetNodeIdByLocalPos({
		x = arg0_7.x,
		y = arg0_7.y
	})
end

function var0_0.GetCurrentDir(arg0_8, arg1_8)
	local var0_8 = arg0_8.path[arg0_8.pathIndex]

	if not var0_8 then
		return {
			x = 0,
			y = 0
		}
	end

	local var1_8 = arg1_8:GetNodeById(var0_8)

	if not var1_8 then
		return {
			x = 0,
			y = 0
		}
	end

	local var2_8 = var1_8.pos.x - arg0_8.x
	local var3_8 = var1_8.pos.y - arg0_8.y
	local var4_8 = math.sqrt(var2_8 * var2_8 + var3_8 * var3_8)

	if var4_8 == 0 then
		return {
			x = 0,
			y = 0
		}
	end

	return {
		x = var2_8 / var4_8,
		y = var3_8 / var4_8
	}
end

function var0_0.GetSpeedLimit(arg0_9)
	local var0_9 = tonumber(arg0_9:GetConfig("max_speed"))

	if var0_9 and var0_9 > 0 then
		return var0_9
	end

	return var0_0.MAX_SPEED
end

function var0_0.GetSpeed(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetNodeById(arg0_10.nodeId).tag
	local var1_10 = ReversePacmanConst.TAG_SPEED_FACTOR[var0_10]
	local var2_10 = arg0_10.baseSpeed * var1_10 * arg0_10.buffMul * arg0_10.eduMul * arg0_10.moveMul * arg0_10._intervalMul

	return math.min(arg0_10:GetSpeedLimit(), var2_10)
end

function var0_0.GetSpeedState(arg0_11, arg1_11)
	local var0_11 = arg1_11 and arg0_11.nodeId and arg0_11:GetSpeed(arg1_11) or math.min(arg0_11:GetSpeedLimit(), arg0_11.baseSpeed * arg0_11.buffMul * arg0_11.eduMul * arg0_11.moveMul * arg0_11._intervalMul)

	if var0_11 <= 0.01 or arg0_11.moveMul <= 0 or arg0_11._intervalMul <= 0 then
		return var0_0.SPEED_STATE.STATIC
	end

	if var0_11 > arg0_11.baseSpeed + 0.01 then
		return var0_0.SPEED_STATE.SPEED_UP
	end

	if var0_11 < arg0_11.baseSpeed - 0.01 then
		return var0_0.SPEED_STATE.SLOW_DOWN
	end

	return var0_0.SPEED_STATE.NORMAL
end

function var0_0.ApplySpeedState(arg0_12, arg1_12)
	if arg0_12.speedState == arg1_12 then
		return
	end

	arg0_12.speedState = arg1_12

	setActive(arg0_12.speedUpTF, arg1_12 == var0_0.SPEED_STATE.SPEED_UP)
	setActive(arg0_12.slowDownTF, arg1_12 == var0_0.SPEED_STATE.SLOW_DOWN)
	setActive(arg0_12.staticTF, arg1_12 == var0_0.SPEED_STATE.STATIC)
end

function var0_0.RefreshSpeedState(arg0_13, arg1_13)
	arg0_13:ApplySpeedState(arg0_13:GetSpeedState(arg1_13 or arg0_13._lastGraph))
end

function var0_0.GetCaptureRadius(arg0_14)
	return arg0_14.baseRadius * arg0_14.buffRadiusMul
end

function var0_0.GetPerformanceRange(arg0_15, arg1_15)
	return tonumber(arg0_15:GetConfig("performance_range_" .. arg1_15)) or ReversePacmanConst.SHIP_PERFORMANCE_RANGE[arg1_15] or 0
end

function var0_0.IsOccupyingNode(arg0_16, arg1_16)
	if arg0_16.nodeId == arg1_16 then
		return true
	end

	return arg0_16.path and arg0_16.path[arg0_16.pathIndex] == arg1_16
end

function var0_0.MoveAlongPath(arg0_17, arg1_17, arg2_17)
	if not arg0_17.alive or not arg2_17 then
		return
	end

	if not arg0_17.path or arg0_17.pathIndex > #arg0_17.path then
		arg0_17.isNeedResetPath = true

		return
	end

	local var0_17 = arg0_17.path[arg0_17.pathIndex]
	local var1_17 = arg2_17:GetRouteGraph()

	arg0_17._lastGraph = var1_17

	if var1_17:IsBuffBlockById(var0_17) then
		local var2_17 = var1_17:GetNodeById(arg0_17.nodeId)

		arg0_17.x = var2_17.pos.x
		arg0_17.y = var2_17.pos.y
		arg0_17.path = {
			arg0_17.nodeId
		}
		arg0_17.pathIndex = 1
		arg0_17.isNeedResetPath = true
		arg0_17._prevNodeId = nil

		setLocalPosition(arg0_17._tf, {
			x = arg0_17.x,
			y = arg0_17.y
		})
		arg0_17:RefreshSpeedState(var1_17)

		return
	end

	local var3_17 = var1_17:GetNodeById(var0_17)
	local var4_17 = arg0_17:GetCurrentDir(var1_17)
	local var5_17 = var3_17.pos.x
	local var6_17 = var3_17.pos.y
	local var7_17 = var5_17 - arg0_17.x
	local var8_17 = var6_17 - arg0_17.y
	local var9_17 = math.sqrt(var7_17 * var7_17 + var8_17 * var8_17)
	local var10_17 = arg0_17:GetSpeed(var1_17) * arg1_17
	local var11_17
	local var12_17

	if var9_17 <= var10_17 then
		arg0_17.x = var5_17
		arg0_17.y = var6_17
		arg0_17.pathIndex = arg0_17.pathIndex + 1

		if arg0_17.nodeId ~= var0_17 then
			var11_17 = var0_17
			var12_17 = var3_17
		end
	else
		arg0_17.x = arg0_17.x + var4_17.x * var10_17
		arg0_17.y = arg0_17.y + var4_17.y * var10_17
	end

	if var11_17 and var12_17 then
		arg0_17._prevNodeId = arg0_17.nodeId
		arg0_17.nodeId = var11_17

		arg0_17:_OnArriveNewCell(var4_17)

		local var13_17

		if arg0_17.type == ReversePacmanConst.ROLE.MONSTER then
			var13_17 = var12_17.tag == ReversePacmanConst.TAG.JUNCTION
		else
			var13_17 = var12_17.tag ~= ReversePacmanConst.TAG.CORRIDOR
		end

		if arg0_17._pendingReplan or var13_17 or arg0_17:HasBlockedInRemainingPath(var1_17) then
			arg0_17.path = {
				arg0_17.nodeId
			}
			arg0_17.pathIndex = 1
			arg0_17.isNeedResetPath = true
		elseif arg0_17.pathIndex > #arg0_17.path then
			arg0_17.isNeedResetPath = true
		end

		arg0_17._pendingReplan = false
	end

	setLocalPosition(arg0_17._tf, {
		x = arg0_17.x,
		y = arg0_17.y
	})
	arg0_17:RefreshSpeedState(var1_17)
end

function var0_0._OnArriveNewCell(arg0_18, arg1_18)
	if arg0_18.moveType == var0_0.MOVE_TYPE.STRAIGHT then
		if arg0_18._lastSegDir and arg0_18._lastSegDir.x == arg1_18.x and arg0_18._lastSegDir.y == arg1_18.y then
			arg0_18._straightCount = arg0_18._straightCount + 1
		else
			arg0_18._straightCount = 1
		end

		if arg0_18._straightCount >= (arg0_18.moveAgr1 or math.huge) then
			arg0_18.moveMul = arg0_18.moveMul * (arg0_18.moveAgr2 or 1)
			arg0_18._straightCount = 0
		end
	elseif arg0_18.moveType == var0_0.MOVE_TYPE.TURN and arg0_18._lastSegDir then
		local var0_18 = arg0_18._lastSegDir.x * arg1_18.x + arg0_18._lastSegDir.y * arg1_18.y

		if (var0_18 == 1 and 0 or var0_18 == -1 and 180 or 90) == arg0_18.moveAgr1 then
			arg0_18.moveMul = arg0_18.moveMul * (arg0_18.moveAgr2 or 1)
		end
	end

	arg0_18._lastSegDir = arg1_18
end

function var0_0.HasBlockedInRemainingPath(arg0_19, arg1_19)
	for iter0_19 = arg0_19.pathIndex, #arg0_19.path do
		if arg1_19:IsBuffBlockById(arg0_19.path[iter0_19]) then
			return true
		end
	end

	return false
end

function var0_0.GetPredictNodeId(arg0_20, arg1_20)
	return arg0_20.path[arg0_20.pathIndex + arg1_20]
end

function var0_0.GetInterceptNodeId(arg0_21, arg1_21)
	return arg0_21.path[arg0_21.pathIndex + arg1_21]
end

function var0_0.InitWords(arg0_22)
	arg0_22.words = {}

	for iter0_22, iter1_22 in ipairs(arg0_22:GetConfig("operation_word")) do
		local var0_22 = iter1_22[1]

		if not arg0_22.words[var0_22] then
			arg0_22.words[var0_22] = {}
		end

		for iter2_22 = 2, #iter1_22 do
			table.insert(arg0_22.words[var0_22], i18n(iter1_22[iter2_22]))
		end
	end
end

function var0_0.GetWordByType(arg0_23, arg1_23)
	local var0_23 = arg0_23.words[arg1_23] or {}

	if #var0_23 == 0 then
		return string.format("no word config, id:%s type:%s", arg0_23.id, arg1_23)
	end

	return var0_23[math.random(1, #var0_23)]
end

function var0_0.IsAlive(arg0_24)
	return arg0_24.alive
end

function var0_0.Kill(arg0_25)
	arg0_25.alive = false
	arg0_25.nodeId = nil
	arg0_25.path = {}
	arg0_25.pathIndex = 1
	arg0_25.speedState = nil

	setActive(arg0_25._tf, false)
end

function var0_0.AddBuff(arg0_26, arg1_26)
	setImageAlpha(arg0_26.iconTF, 1)
	blinkAni(go(arg0_26.iconTF), 0.2, 1)

	local var0_26 = pg.activity_chasing_skill[arg1_26].param
	local var1_26 = tonumber(var0_26) or 1

	if arg1_26 == ReversePacmanConst.BUFF.SPEED then
		arg0_26.buffMul = arg0_26.buffMul * var1_26
	elseif arg1_26 == ReversePacmanConst.BUFF.GIANT then
		arg0_26.buffRadiusMul = arg0_26.buffRadiusMul * var1_26

		setLocalScale(arg0_26._tf, Vector3(arg0_26.buffRadiusMul, arg0_26.buffRadiusMul, arg0_26.buffRadiusMul))
	end

	arg0_26:RefreshSpeedState()
end

function var0_0.SetEffectsScale(arg0_27, arg1_27)
	local var0_27 = {
		arg0_27.speedUpTF,
		arg0_27.slowDownTF,
		arg0_27.staticTF
	}

	for iter0_27, iter1_27 in ipairs(var0_27) do
		eachChild(iter1_27, function(arg0_28)
			local var0_28 = arg0_28:GetComponent(typeof(ParticleSystem))

			if not IsNil(var0_28) then
				setLocalScale(arg0_28, Vector3(arg1_27, arg1_27, arg1_27))
			end
		end)
	end
end

function var0_0.ShowEffects(arg0_29)
	setActive(arg0_29.speedUpTF, true)
	setActive(arg0_29.slowDownTF, true)
	setActive(arg0_29.staticTF, true)
end

function var0_0.HideEffects(arg0_30)
	setActive(arg0_30.speedUpTF, false)
	setActive(arg0_30.slowDownTF, false)
	setActive(arg0_30.staticTF, false)
end

function var0_0.Hide(arg0_31)
	setActive(arg0_31._tf, false)
end

function var0_0.Update(arg0_32, arg1_32)
	if not arg0_32.alive then
		return
	end

	if arg0_32.moveType == var0_0.MOVE_TYPE.INTERVAL then
		arg0_32._intervalTimer = arg0_32._intervalTimer + arg1_32

		if arg0_32._intervalMoving then
			if arg0_32._intervalTimer >= (arg0_32.moveAgr1 or 0) then
				arg0_32._intervalTimer = 0
				arg0_32._intervalMoving = false
				arg0_32._intervalMul = 0
			end
		elseif arg0_32._intervalTimer >= (arg0_32.moveAgr2 or 0) then
			arg0_32._intervalTimer = 0
			arg0_32._intervalMoving = true
			arg0_32._intervalMul = 1
		end
	end

	arg0_32:RefreshSpeedState()
end

function var0_0.Dispose(arg0_33)
	return
end

return var0_0
