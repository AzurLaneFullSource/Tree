ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleCameraFocusChar = class("BattleCameraFocusChar")
var0.Battle.BattleCameraFocusChar.__name = "BattleCameraFocusChar"

local var3 = var0.Battle.BattleCameraFocusChar

function var3.Ctor(arg0)
	arg0._point = Vector3.zero
end

function var3.SetUnit(arg0, arg1)
	arg0._unit = arg1
end

function var3.GetCameraPos(arg0)
	local var0 = arg0._unit:GetPosition()

	arg0._point:Set(var0.x, var0.y, var0.z)

	arg0._point.y = arg0._point.y + var2.CameraFocusHeight
	arg0._point.z = arg0._point.z - arg0._point.y / var2._camera_radian_x_tan

	if arg0._unit:GetIFF() == var1.FOE_CODE then
		arg0._point.x = arg0._point.x + 7
	else
		arg0._point.x = arg0._point.x - 7
	end

	return arg0._point
end

function var3.Dispose(arg0)
	arg0._unit = nil
end
