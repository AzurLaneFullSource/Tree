ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleCameraBoundFixDecorate = class("BattleCameraBoundFixDecorate")
var0_0.Battle.BattleCameraBoundFixDecorate.__name = "BattleCameraBoundFixDecorate"

local var3_0 = var0_0.Battle.BattleCameraBoundFixDecorate

function var3_0.Ctor(arg0_1)
	return
end

function var3_0.SetMapData(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2._cameraUpperBound = arg1_2 + 30
	arg0_2._cameraLowerBound = arg2_2 - 5
	arg0_2._cameraLeftBound = arg3_2 - 3
	arg0_2._cameraRightBound = arg4_2 + 3
	arg0_2._cameraHalfWidth = var1_0.CAMERA_SIZE * pg.CameraFixMgr.GetInstance().targetRatio
	arg0_2._cameraLeftBoundPoint = arg0_2._cameraLeftBound + arg0_2._cameraHalfWidth
	arg0_2._cameraRightBoundPoint = arg0_2._cameraRightBound - arg0_2._cameraHalfWidth
	arg0_2._projectionConst = var1_0.CAMERA_SIZE / var2_0._camera_radian_x_sin

	return arg0_2._cameraUpperBound, arg0_2._cameraLowerBound, arg0_2._cameraLeftBound, arg0_2._cameraRightBound
end

function var3_0.GetCameraPos(arg0_3, arg1_3)
	local var0_3 = arg1_3.y / var2_0._camera_radian_x_tan + arg0_3._projectionConst

	if arg1_3.z < arg0_3._cameraLowerBound then
		arg1_3.z = arg0_3._cameraLowerBound
	elseif arg1_3.z > arg0_3._cameraUpperBound - var0_3 then
		arg1_3.z = arg0_3._cameraUpperBound - var0_3
	end

	if arg1_3.x < arg0_3._cameraLeftBoundPoint then
		arg1_3.x = arg0_3._cameraLeftBoundPoint
	elseif arg1_3.x > arg0_3._cameraRightBoundPoint then
		arg1_3.x = arg0_3._cameraRightBoundPoint
	end

	return arg1_3
end

function var3_0.Dispose(arg0_4)
	arg0_4._cameraUpperBound = nil
	arg0_4._cameraLowerBound = nil
	arg0_4._cameraLeftBound = nil
	arg0_4._cameraRightBound = nil
	arg0_4._cameraHalfWidth = nil
	arg0_4._cameraLeftBoundPoint = nil
	arg0_4._cameraRightBoundPoint = nil
	arg0_4._projectionConst = nil
end
