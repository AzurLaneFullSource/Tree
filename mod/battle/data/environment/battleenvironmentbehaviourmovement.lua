ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourMovement", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourMovement = var3
var3.__name = "BattleEnvironmentBehaviourMovement"

function var3.Ctor(arg0)
	arg0._movebeginTime = nil
	arg0._moveEndTime = nil
	arg0._lastPosition = nil
	arg0._destPosition = nil
	arg0._targetIndex = 1

	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._route = arg1.route or {}
	arg0._random_duration = arg1.random_duration or {
		1,
		5
	}
	arg0._random_speed = arg1.random_speed or 1

	local var0 = arg0._unit:GetTemplate()
	local var1
	local var2

	if #var0.cld_data == 1 then
		var1 = var0.cld_data[1]
		var2 = var1
	elseif #var0.cld_data == 2 then
		var1, var2 = unpack(var0.cld_data)
	end

	local var3 = {
		var0.Battle.BattleDataProxy.GetInstance():GetFleetBoundByIFF(var2.FRIENDLY_CODE)
	}

	var3[3] = var3[3] + var1
	var3[4] = var3[4] - var1
	var3[2] = var3[2] + var2
	var3[1] = var3[1] - var2
	arg0._bounds = var3
	arg0._lastPosition = Vector3(unpack(var0.coordinate))

	if arg1.random_range then
		arg0._randomRangeX = arg1.random_range[1]
		arg0._randomRangeZ = arg1.random_range[2]
		arg0._resetRandomRange = true
	end
end

function var3.doBehaviour(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if not arg0._moveEndTime then
		local var1 = arg0._route[arg0._targetIndex]

		arg0._movebeginTime = var0

		if var1 then
			arg0._destPosition = Vector3(unpack(var1))
			arg0._moveEndTime = var0 + var1[4]
			arg0._targetIndex = arg0._targetIndex + 1
		else
			local var2 = arg0:GenerateRandomPlayerAreaPoint()
			local var3 = math.random(unpack(arg0._random_duration))
			local var4 = var3 * arg0._random_speed
			local var5 = (var2 - arg0._lastPosition):Magnitude()

			if var5 < var4 then
				var3 = var5 / arg0._random_speed
			else
				var2 = Vector3.Lerp(arg0._lastPosition, var2, var4 / var5)
			end

			arg0._moveEndTime = var0 + var3
			arg0._destPosition = var2
		end
	end

	if var0 < arg0._moveEndTime then
		local var6 = Vector3.Lerp(arg0._lastPosition, arg0._destPosition, (var0 - arg0._movebeginTime) / (arg0._moveEndTime - arg0._movebeginTime))

		arg0._unit._aoeData:SetPosition(var6)
	else
		arg0._unit._aoeData:SetPosition(arg0._destPosition)

		arg0._lastPosition = arg0._destPosition
		arg0._moveEndTime = nil
	end

	var3.super.doBehaviour(arg0)
end

function var3.GenerateRandomPlayerAreaPoint(arg0)
	local var0 = arg0._bounds
	local var1 = math.random(var0[3], var0[4])
	local var2 = math.random(var0[2], var0[1])

	if arg0._resetRandomRange then
		arg0:resetRandomBound(var1, var2)
	end

	return Vector3(var1, 0, var2)
end

function var3.resetRandomBound(arg0, arg1, arg2)
	arg0._bounds[3] = arg1 - arg0._randomRangeX
	arg0._bounds[4] = arg1 + arg0._randomRangeX
	arg0._bounds[2] = arg2 - arg0._randomRangeZ
	arg0._bounds[1] = arg2 + arg0._randomRangeZ
	arg0._resetRandomRange = false
end

function var3.Dispose(arg0)
	var3.super.Dispose(arg0)
	table.clear(arg0)
end
