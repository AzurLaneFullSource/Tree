ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleCameraFocusChar = class("BattleCameraFocusChar")
var0_0.Battle.BattleCameraFocusChar.__name = "BattleCameraFocusChar"

local var3_0 = var0_0.Battle.BattleCameraFocusChar

function var3_0.Ctor(arg0_1)
	arg0_1._point = Vector3.zero
end

function var3_0.SetUnit(arg0_2, arg1_2)
	arg0_2._unit = arg1_2
end

function var3_0.GetCameraPos(arg0_3)
	local var0_3 = arg0_3._unit:GetPosition()

	arg0_3._point:Set(var0_3.x, var0_3.y, var0_3.z)

	arg0_3._point.y = arg0_3._point.y + var2_0.CameraFocusHeight
	arg0_3._point.z = arg0_3._point.z - arg0_3._point.y / var2_0._camera_radian_x_tan

	if arg0_3._unit:GetIFF() == var1_0.FOE_CODE then
		arg0_3._point.x = arg0_3._point.x + 7
	else
		arg0_3._point.x = arg0_3._point.x - 7
	end

	return arg0_3._point
end

function var3_0.Dispose(arg0_4)
	arg0_4._unit = nil
end
