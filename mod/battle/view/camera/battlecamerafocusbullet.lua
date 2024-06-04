ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleCameraFocusBulet = class("BattleCameraFocusBulet")
var0.Battle.BattleCameraFocusBulet.__name = "BattleCameraFocusBulet"

local var3 = var0.Battle.BattleCameraFocusBulet

function var3.Ctor(arg0)
	return
end

function var3.SetUnit(arg0, arg1)
	arg0._unit = arg1
end

function var3.GetCameraPos(arg0)
	local var0 = arg0._unit:GetPosition():Clone()

	var0.y = var0.y + var2.CameraFocusHeight
	var0.z = var0.z - var0.y / var2._camera_radian_x_tan

	return var0
end

function var3.Dispose(arg0)
	arg0._unit = nil
end
