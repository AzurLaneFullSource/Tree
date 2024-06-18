ys = ys or {}

local var0_0 = ys
local var1_0 = class("AutoPilotBrownian", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotBrownian = var1_0
var1_0.__name = "AutoPilotBrownian"

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)
end

function var1_0.SetParameter(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetParameter(arg0_2, arg1_2, arg2_2)

	arg0_2._randomPoint = {
		X1 = arg1_2.X1,
		X2 = arg1_2.X2,
		Z1 = arg1_2.Z1,
		Z2 = arg1_2.Z2
	}
	arg0_2._stop = arg1_2.stopCount
	arg0_2._move = arg1_2.moveCount
	arg0_2._random = arg1_2.randomCount or 30
end

function var1_0.Active(arg0_3, arg1_3)
	arg0_3._stopCount = arg0_3._stop
	arg0_3._moveCount = 0
	arg0_3._randomCount = 0
	arg0_3._referencePoint = var0_0.Battle.BattleFormulas.RandomPos(arg0_3._randomPoint)

	var1_0.super.Active(arg0_3, arg1_3)
end

function var1_0.GetDirection(arg0_4, arg1_4)
	if arg0_4:IsExpired() then
		arg0_4:Finish()

		return Vector3.zero
	end

	arg0_4._moveCount = arg0_4._moveCount or 0

	if arg0_4._stop > arg0_4._stopCount then
		arg0_4._stopCount = arg0_4._stopCount + 1

		return Vector3.zero
	end

	local var0_4 = arg0_4._referencePoint - arg1_4

	if var0_4.magnitude < 0.4 or arg0_4._randomCount > arg0_4._random then
		if arg0_4._move < arg0_4._moveCount then
			arg0_4._stopCount = 0
			arg0_4._moveCount = 0
		else
			arg0_4._randomCount = 0

			local var1_4 = var0_0.Battle.BattleFormulas.RandomPos(arg0_4._randomPoint)
			local var2_4 = 0

			while Vector3.SqrDistance(var1_4, arg1_4) < 5 do
				var1_4 = var0_0.Battle.BattleFormulas.RandomPos(arg0_4._randomPoint)
				var2_4 = var2_4 + 1
			end

			arg0_4._referencePoint = var1_4
		end

		return Vector3.zero
	else
		arg0_4._randomCount = arg0_4._randomCount + 1
		arg0_4._moveCount = arg0_4._moveCount + 1

		return var0_4:SetNormalize()
	end
end
