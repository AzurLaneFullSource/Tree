ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleCameraFollowPilot = class("BattleCameraFollowPilot")
var0_0.Battle.BattleCameraFollowPilot.__name = "BattleCameraFollowPilot"

local var3_0 = var0_0.Battle.BattleCameraFollowPilot

function var3_0.Ctor(arg0_1)
	arg0_1.point = Vector3.zero
end

function var3_0.SetFleetVO(arg0_2, arg1_2)
	arg0_2._fleetMotion = arg1_2:GetMotion()
end

function var3_0.SetGoldenRation(arg0_3, arg1_3)
	arg0_3._cameraGoldenOffset = arg1_3
end

function var3_0.GetCameraPos(arg0_4)
	local var0_4 = arg0_4.point:Copy(arg0_4._fleetMotion:GetPos())

	var0_4.x = var0_4.x + arg0_4._cameraGoldenOffset
	var0_4.y = var0_4.y + var2_0.CameraNormalHeight
	var0_4.z = var0_4.z - var0_4.y / var2_0._camera_radian_x_tan

	return var0_4
end

function var3_0.Dispose(arg0_5)
	arg0_5._fleetMotion = nil
end
