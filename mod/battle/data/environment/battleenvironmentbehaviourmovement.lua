ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourMovement", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourMovement = var3_0
var3_0.__name = "BattleEnvironmentBehaviourMovement"

function var3_0.Ctor(arg0_1)
	arg0_1._movebeginTime = nil
	arg0_1._moveEndTime = nil
	arg0_1._lastPosition = nil
	arg0_1._destPosition = nil
	arg0_1._targetIndex = 1

	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._route = arg1_2.route or {}
	arg0_2._random_duration = arg1_2.random_duration or {
		1,
		5
	}
	arg0_2._random_speed = arg1_2.random_speed or 1

	local var0_2 = arg0_2._unit:GetTemplate()
	local var1_2
	local var2_2

	if #var0_2.cld_data == 1 then
		var1_2 = var0_2.cld_data[1]
		var2_2 = var1_2
	elseif #var0_2.cld_data == 2 then
		var1_2, var2_2 = unpack(var0_2.cld_data)
	end

	local var3_2 = {
		var0_0.Battle.BattleDataProxy.GetInstance():GetFleetBoundByIFF(var2_0.FRIENDLY_CODE)
	}

	var3_2[3] = var3_2[3] + var1_2
	var3_2[4] = var3_2[4] - var1_2
	var3_2[2] = var3_2[2] + var2_2
	var3_2[1] = var3_2[1] - var2_2
	arg0_2._bounds = var3_2
	arg0_2._lastPosition = Vector3(unpack(var0_2.coordinate))

	if arg1_2.random_range then
		arg0_2._randomRangeX = arg1_2.random_range[1]
		arg0_2._randomRangeZ = arg1_2.random_range[2]
		arg0_2._resetRandomRange = true
	end
end

function var3_0.doBehaviour(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetCombatTime()

	if not arg0_3._moveEndTime then
		local var1_3 = arg0_3._route[arg0_3._targetIndex]

		arg0_3._movebeginTime = var0_3

		if var1_3 then
			arg0_3._destPosition = Vector3(unpack(var1_3))
			arg0_3._moveEndTime = var0_3 + var1_3[4]
			arg0_3._targetIndex = arg0_3._targetIndex + 1
		else
			local var2_3 = arg0_3:GenerateRandomPlayerAreaPoint()
			local var3_3 = math.random(unpack(arg0_3._random_duration))
			local var4_3 = var3_3 * arg0_3._random_speed
			local var5_3 = (var2_3 - arg0_3._lastPosition):Magnitude()

			if var5_3 < var4_3 then
				var3_3 = var5_3 / arg0_3._random_speed
			else
				var2_3 = Vector3.Lerp(arg0_3._lastPosition, var2_3, var4_3 / var5_3)
			end

			arg0_3._moveEndTime = var0_3 + var3_3
			arg0_3._destPosition = var2_3
		end
	end

	if var0_3 < arg0_3._moveEndTime then
		local var6_3 = Vector3.Lerp(arg0_3._lastPosition, arg0_3._destPosition, (var0_3 - arg0_3._movebeginTime) / (arg0_3._moveEndTime - arg0_3._movebeginTime))

		arg0_3._unit._aoeData:SetPosition(var6_3)
	else
		arg0_3._unit._aoeData:SetPosition(arg0_3._destPosition)

		arg0_3._lastPosition = arg0_3._destPosition
		arg0_3._moveEndTime = nil
	end

	var3_0.super.doBehaviour(arg0_3)
end

function var3_0.GenerateRandomPlayerAreaPoint(arg0_4)
	local var0_4 = arg0_4._bounds
	local var1_4 = math.random(var0_4[3], var0_4[4])
	local var2_4 = math.random(var0_4[2], var0_4[1])

	if arg0_4._resetRandomRange then
		arg0_4:resetRandomBound(var1_4, var2_4)
	end

	return Vector3(var1_4, 0, var2_4)
end

function var3_0.resetRandomBound(arg0_5, arg1_5, arg2_5)
	arg0_5._bounds[3] = arg1_5 - arg0_5._randomRangeX
	arg0_5._bounds[4] = arg1_5 + arg0_5._randomRangeX
	arg0_5._bounds[2] = arg2_5 - arg0_5._randomRangeZ
	arg0_5._bounds[1] = arg2_5 + arg0_5._randomRangeZ
	arg0_5._resetRandomRange = false
end

function var3_0.Dispose(arg0_6)
	var3_0.super.Dispose(arg0_6)
	table.clear(arg0_6)
end
