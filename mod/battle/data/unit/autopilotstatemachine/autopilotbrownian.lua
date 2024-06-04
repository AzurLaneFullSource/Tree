ys = ys or {}

local var0 = ys
local var1 = class("AutoPilotBrownian", var0.Battle.IPilot)

var0.Battle.AutoPilotBrownian = var1
var1.__name = "AutoPilotBrownian"

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)
end

function var1.SetParameter(arg0, arg1, arg2)
	var1.super.SetParameter(arg0, arg1, arg2)

	arg0._randomPoint = {
		X1 = arg1.X1,
		X2 = arg1.X2,
		Z1 = arg1.Z1,
		Z2 = arg1.Z2
	}
	arg0._stop = arg1.stopCount
	arg0._move = arg1.moveCount
	arg0._random = arg1.randomCount or 30
end

function var1.Active(arg0, arg1)
	arg0._stopCount = arg0._stop
	arg0._moveCount = 0
	arg0._randomCount = 0
	arg0._referencePoint = var0.Battle.BattleFormulas.RandomPos(arg0._randomPoint)

	var1.super.Active(arg0, arg1)
end

function var1.GetDirection(arg0, arg1)
	if arg0:IsExpired() then
		arg0:Finish()

		return Vector3.zero
	end

	arg0._moveCount = arg0._moveCount or 0

	if arg0._stop > arg0._stopCount then
		arg0._stopCount = arg0._stopCount + 1

		return Vector3.zero
	end

	local var0 = arg0._referencePoint - arg1

	if var0.magnitude < 0.4 or arg0._randomCount > arg0._random then
		if arg0._move < arg0._moveCount then
			arg0._stopCount = 0
			arg0._moveCount = 0
		else
			arg0._randomCount = 0

			local var1 = var0.Battle.BattleFormulas.RandomPos(arg0._randomPoint)
			local var2 = 0

			while Vector3.SqrDistance(var1, arg1) < 5 do
				var1 = var0.Battle.BattleFormulas.RandomPos(arg0._randomPoint)
				var2 = var2 + 1
			end

			arg0._referencePoint = var1
		end

		return Vector3.zero
	else
		arg0._randomCount = arg0._randomCount + 1
		arg0._moveCount = arg0._moveCount + 1

		return var0:SetNormalize()
	end
end
