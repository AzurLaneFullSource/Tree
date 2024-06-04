ys = ys or {}

local var0 = ys
local var1 = class("AutoPilotMinionRelativeStay", var0.Battle.IPilot)

var0.Battle.AutoPilotMinionRelativeStay = var1
var1.__name = "AutoPilotMinionRelativeStay"

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)
end

function var1.SetParameter(arg0, arg1, arg2)
	var1.super.SetParameter(arg0, arg1, arg2)

	arg0._distX = arg1.x
	arg0._distZ = arg1.z
	arg0._nextBuffID = arg1.buffID
end

function var1.GetDirection(arg0, arg1)
	local var0 = arg0._pilot:GetTarget():GetMaster()

	if not var0:IsAlive() then
		if arg0._nextBuffID then
			local var1 = var0.Battle.BattleBuffUnit.New(arg0._nextBuffID)

			arg0._pilot:GetTarget():AddBuff(var1)
		end

		return Vector3.zero
	end

	local var2 = var0:GetPosition()
	local var3 = Vector3(var2.x + arg0._distX, arg1.y, var2.z + arg0._distZ) - arg1

	if arg0:IsExpired() then
		arg0:Finish()
	end

	if var3.magnitude < 0.4 then
		return Vector3.zero
	else
		var3.y = 0

		return var3:SetNormalize()
	end
end
