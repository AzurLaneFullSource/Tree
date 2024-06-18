ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourForce", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourForce = var3_0
var3_0.__name = "BattleEnvironmentBehaviourForce"

function var3_0.Ctor(arg0_1)
	arg0_1._moveEndTime = nil
	arg0_1._lastSpeed = nil
	arg0_1._speed = Vector3.zero
	arg0_1._targetIndex = 0

	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._route = arg1_2.route or {}
	arg0_2._moveEndTime = pg.TimeMgr.GetInstance():GetCombatTime()

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
		var0_0.Battle.BattleDataProxy.GetInstance():GetTotalBounds()
	}

	var3_2[3] = var3_2[3] + var1_2
	var3_2[4] = var3_2[4] - var1_2
	var3_2[2] = var3_2[2] + var2_2
	var3_2[1] = var3_2[1] - var2_2
	arg0_2._bounds = var3_2
end

function var3_0.doBehaviour(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0_3._moveEndTime and var0_3 >= arg0_3._moveEndTime then
		arg0_3._targetIndex = arg0_3._targetIndex + 1
		arg0_3._moveEndTime = nil

		if arg0_3._lastSpeed then
			arg0_3._speed:Add(arg0_3._lastSpeed)

			arg0_3._lastSpeed = nil
		end

		local var1_3 = arg0_3._route[arg0_3._targetIndex]

		if var1_3 then
			arg0_3._lastSpeed = Vector3(unpack(var1_3)):Normalize() * var1_3[4]
			arg0_3._moveEndTime = var0_3 + var1_3[5]
		end
	end

	local var2_3 = arg0_3._unit._aoeData:GetPosition()
	local var3_3 = arg0_3:UpdateAndRestrictPosition(var2_3)

	arg0_3._unit._aoeData:SetPosition(var3_3)
	var3_0.super.doBehaviour(arg0_3)
end

function var3_0.UpdateAndRestrictPosition(arg0_4, arg1_4)
	if arg0_4._speed:SqrMagnitude() < 0.01 then
		return arg1_4
	end

	local var0_4 = arg0_4._bounds
	local var1_4 = arg1_4 + arg0_4._speed

	if var1_4.x < var0_4[3] then
		arg0_4._speed.x = math.abs(arg0_4._speed.x)
		var1_4.x = var0_4[3] + math.abs(var1_4.x - var0_4[3])
	elseif var0_4[4] < var1_4.x then
		arg0_4._speed.x = -math.abs(arg0_4._speed.x)
		var1_4.x = var0_4[4] - math.abs(var1_4.x - var0_4[4])
	end

	if var1_4.z < var0_4[2] then
		arg0_4._speed.z = math.abs(arg0_4._speed.z)
		var1_4.z = var0_4[2] + math.abs(var1_4.z - var0_4[2])
	elseif var0_4[1] < var1_4.z then
		arg0_4._speed.z = -math.abs(arg0_4._speed.z)
		var1_4.z = var0_4[1] - math.abs(var1_4.z - var0_4[1])
	end

	return var1_4
end

function var3_0.Dispose(arg0_5)
	var3_0.super.Dispose(arg0_5)
	table.clear(arg0_5)
end
