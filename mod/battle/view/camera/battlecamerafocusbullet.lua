ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleCameraFocusBulet = class("BattleCameraFocusBulet")
var0_0.Battle.BattleCameraFocusBulet.__name = "BattleCameraFocusBulet"

local var3_0 = var0_0.Battle.BattleCameraFocusBulet

function var3_0.Ctor(arg0_1)
	return
end

function var3_0.SetUnit(arg0_2, arg1_2)
	arg0_2._unit = arg1_2
end

function var3_0.GetCameraPos(arg0_3)
	local var0_3 = arg0_3._unit:GetPosition():Clone()

	var0_3.y = var0_3.y + var2_0.CameraFocusHeight
	var0_3.z = var0_3.z - var0_3.y / var2_0._camera_radian_x_tan

	return var0_3
end

function var3_0.Dispose(arg0_4)
	arg0_4._unit = nil
end
