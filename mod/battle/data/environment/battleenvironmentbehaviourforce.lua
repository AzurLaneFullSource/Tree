ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourForce", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourForce = var3
var3.__name = "BattleEnvironmentBehaviourForce"

function var3.Ctor(arg0)
	arg0._moveEndTime = nil
	arg0._lastSpeed = nil
	arg0._speed = Vector3.zero
	arg0._targetIndex = 0

	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._route = arg1.route or {}
	arg0._moveEndTime = pg.TimeMgr.GetInstance():GetCombatTime()

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
		var0.Battle.BattleDataProxy.GetInstance():GetTotalBounds()
	}

	var3[3] = var3[3] + var1
	var3[4] = var3[4] - var1
	var3[2] = var3[2] + var2
	var3[1] = var3[1] - var2
	arg0._bounds = var3
end

function var3.doBehaviour(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0._moveEndTime and var0 >= arg0._moveEndTime then
		arg0._targetIndex = arg0._targetIndex + 1
		arg0._moveEndTime = nil

		if arg0._lastSpeed then
			arg0._speed:Add(arg0._lastSpeed)

			arg0._lastSpeed = nil
		end

		local var1 = arg0._route[arg0._targetIndex]

		if var1 then
			arg0._lastSpeed = Vector3(unpack(var1)):Normalize() * var1[4]
			arg0._moveEndTime = var0 + var1[5]
		end
	end

	local var2 = arg0._unit._aoeData:GetPosition()
	local var3 = arg0:UpdateAndRestrictPosition(var2)

	arg0._unit._aoeData:SetPosition(var3)
	var3.super.doBehaviour(arg0)
end

function var3.UpdateAndRestrictPosition(arg0, arg1)
	if arg0._speed:SqrMagnitude() < 0.01 then
		return arg1
	end

	local var0 = arg0._bounds
	local var1 = arg1 + arg0._speed

	if var1.x < var0[3] then
		arg0._speed.x = math.abs(arg0._speed.x)
		var1.x = var0[3] + math.abs(var1.x - var0[3])
	elseif var0[4] < var1.x then
		arg0._speed.x = -math.abs(arg0._speed.x)
		var1.x = var0[4] - math.abs(var1.x - var0[4])
	end

	if var1.z < var0[2] then
		arg0._speed.z = math.abs(arg0._speed.z)
		var1.z = var0[2] + math.abs(var1.z - var0[2])
	elseif var0[1] < var1.z then
		arg0._speed.z = -math.abs(arg0._speed.z)
		var1.z = var0[1] - math.abs(var1.z - var0[1])
	end

	return var1
end

function var3.Dispose(arg0)
	var3.super.Dispose(arg0)
	table.clear(arg0)
end
