ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleCameraFollowGesture = class("BattleCameraFollowGesture")
var0.Battle.BattleCameraFollowGesture.__name = "BattleCameraFollowGesture"

local var3 = var0.Battle.BattleCameraFollowGesture

function var3.Ctor(arg0)
	arg0._point = Vector3.zero
end

function var3.SetGestureComponent(arg0, arg1)
	arg0._slider = arg1
end

function var3.GetCameraPos(arg0, arg1)
	if arg0._slider:IsPress() then
		arg0._pressPoint = arg0._pressPoint or arg1

		local var0, var1 = arg0._slider:IsFirstPress()
		local var2 = arg0._pressPoint.x
		local var3 = arg0._pressPoint.y

		if var0 then
			arg0._pressPoint.x = arg1.x
		end

		if var1 then
			arg0._pressPoint.z = arg1.z
		end

		local var4, var5 = arg0._slider:GetDistance()

		arg0._point:Set(arg0._pressPoint.x, arg0._pressPoint.y, arg0._pressPoint.z)

		arg0._point.z = arg0._point.z + var5 * -80
		arg0._point.x = arg0._point.x + var4 * -80

		return arg0._point
	else
		return arg1
	end
end

function var3.Dispose(arg0)
	arg0._slider = nil
end
