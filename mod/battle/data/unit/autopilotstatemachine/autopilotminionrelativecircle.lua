ys = ys or {}

local var0_0 = ys
local var1_0 = Vector3.up
local var2_0 = class("AutoPilotMinionRelativeCircle", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotMinionRelativeCircle = var2_0
var2_0.__name = "AutoPilotMinionRelativeCircle"

function var2_0.Ctor(arg0_1, ...)
	var2_0.super.Ctor(arg0_1, ...)
end

function var2_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var2_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._radius = arg1_2.radius

	if arg1_2.antiClockWise == true then
		arg0_2.GetDirection = var2_0._antiClockWise
	else
		arg0_2.GetDirection = var2_0._clockWise
	end

	arg0_2._nextBuffID = arg1_2.buffID
end

function var2_0._clockWise(arg0_3, arg1_3)
	if arg0_3:IsExpired() then
		arg0_3:Finish()

		return Vector3.zero
	end

	local var0_3 = arg0_3._pilot:GetTarget():GetMaster()

	if not var0_3:IsAlive() then
		if arg0_3._nextBuffID then
			local var1_3 = var0_0.Battle.BattleBuffUnit.New(arg0_3._nextBuffID)

			arg0_3._pilot:GetTarget():AddBuff(var1_3)
		end

		return Vector3.zero
	end

	local var2_3 = var0_3:GetPosition()

	if (arg1_3 - var2_3).magnitude > arg0_3._radius then
		return (var2_3 - arg1_3).normalized
	else
		local var3_3 = (var2_3 - arg1_3).normalized
		local var4_3 = -var3_3.z
		local var5_3 = var3_3.x

		return Vector3(var4_3, 0, var5_3)
	end
end

function var2_0._antiClockWise(arg0_4, arg1_4)
	if arg0_4._duration > 0 and pg.TimeMgr.GetInstance():GetCombatTime() - arg0_4._startTime > arg0_4._duration then
		arg0_4:Finish()

		return Vector3.zero
	end

	local var0_4 = arg0_4._pilot:GetTarget():GetMaster()

	if not var0_4:IsAlive() then
		if arg0_4._nextBuffID then
			local var1_4 = var0_0.Battle.BattleBuffUnit.New(arg0_4._nextBuffID)

			arg0_4._pilot:GetTarget():AddBuff(var1_4)
		end

		return Vector3.zero
	end

	local var2_4 = var0_4:GetPosition()

	if (arg1_4 - var2_4).magnitude > arg0_4._radius then
		return (var2_4 - arg1_4).normalized
	else
		local var3_4 = (var2_4 - arg1_4).normalized
		local var4_4 = var3_4.z
		local var5_4 = -var3_4.x

		return Vector3(var4_4, 0, var5_4)
	end
end
