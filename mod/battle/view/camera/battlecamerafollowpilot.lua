ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleCameraFollowPilot = class("BattleCameraFollowPilot")
var0.Battle.BattleCameraFollowPilot.__name = "BattleCameraFollowPilot"

local var3 = var0.Battle.BattleCameraFollowPilot

function var3.Ctor(arg0)
	arg0.point = Vector3.zero
end

function var3.SetFleetVO(arg0, arg1)
	arg0._fleetMotion = arg1:GetMotion()
end

function var3.SetGoldenRation(arg0, arg1)
	arg0._cameraGoldenOffset = arg1
end

function var3.GetCameraPos(arg0)
	local var0 = arg0.point:Copy(arg0._fleetMotion:GetPos())

	var0.x = var0.x + arg0._cameraGoldenOffset
	var0.y = var0.y + var2.CameraNormalHeight
	var0.z = var0.z - var0.y / var2._camera_radian_x_tan

	return var0
end

function var3.Dispose(arg0)
	arg0._fleetMotion = nil
end
