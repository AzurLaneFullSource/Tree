ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleCameraFollowGesture = class("BattleCameraFollowGesture")
var0_0.Battle.BattleCameraFollowGesture.__name = "BattleCameraFollowGesture"

local var3_0 = var0_0.Battle.BattleCameraFollowGesture

function var3_0.Ctor(arg0_1)
	arg0_1._point = Vector3.zero
end

function var3_0.SetGestureComponent(arg0_2, arg1_2)
	arg0_2._slider = arg1_2
end

function var3_0.GetCameraPos(arg0_3, arg1_3)
	if arg0_3._slider:IsPress() then
		arg0_3._pressPoint = arg0_3._pressPoint or arg1_3

		local var0_3, var1_3 = arg0_3._slider:IsFirstPress()
		local var2_3 = arg0_3._pressPoint.x
		local var3_3 = arg0_3._pressPoint.y

		if var0_3 then
			arg0_3._pressPoint.x = arg1_3.x
		end

		if var1_3 then
			arg0_3._pressPoint.z = arg1_3.z
		end

		local var4_3, var5_3 = arg0_3._slider:GetDistance()

		arg0_3._point:Set(arg0_3._pressPoint.x, arg0_3._pressPoint.y, arg0_3._pressPoint.z)

		arg0_3._point.z = arg0_3._point.z + var5_3 * -80
		arg0_3._point.x = arg0_3._point.x + var4_3 * -80

		return arg0_3._point
	else
		return arg1_3
	end
end

function var3_0.Dispose(arg0_4)
	arg0_4._slider = nil
end
