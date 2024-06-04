ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleCameraBoundFixDecorate = class("BattleCameraBoundFixDecorate")
var0.Battle.BattleCameraBoundFixDecorate.__name = "BattleCameraBoundFixDecorate"

local var3 = var0.Battle.BattleCameraBoundFixDecorate

function var3.Ctor(arg0)
	return
end

function var3.SetMapData(arg0, arg1, arg2, arg3, arg4)
	arg0._cameraUpperBound = arg1 + 30
	arg0._cameraLowerBound = arg2 - 5
	arg0._cameraLeftBound = arg3 - 3
	arg0._cameraRightBound = arg4 + 3
	arg0._cameraHalfWidth = var1.CAMERA_SIZE * pg.CameraFixMgr.GetInstance().targetRatio
	arg0._cameraLeftBoundPoint = arg0._cameraLeftBound + arg0._cameraHalfWidth
	arg0._cameraRightBoundPoint = arg0._cameraRightBound - arg0._cameraHalfWidth
	arg0._projectionConst = var1.CAMERA_SIZE / var2._camera_radian_x_sin

	return arg0._cameraUpperBound, arg0._cameraLowerBound, arg0._cameraLeftBound, arg0._cameraRightBound
end

function var3.GetCameraPos(arg0, arg1)
	local var0 = arg1.y / var2._camera_radian_x_tan + arg0._projectionConst

	if arg1.z < arg0._cameraLowerBound then
		arg1.z = arg0._cameraLowerBound
	elseif arg1.z > arg0._cameraUpperBound - var0 then
		arg1.z = arg0._cameraUpperBound - var0
	end

	if arg1.x < arg0._cameraLeftBoundPoint then
		arg1.x = arg0._cameraLeftBoundPoint
	elseif arg1.x > arg0._cameraRightBoundPoint then
		arg1.x = arg0._cameraRightBoundPoint
	end

	return arg1
end

function var3.Dispose(arg0)
	arg0._cameraUpperBound = nil
	arg0._cameraLowerBound = nil
	arg0._cameraLeftBound = nil
	arg0._cameraRightBound = nil
	arg0._cameraHalfWidth = nil
	arg0._cameraLeftBoundPoint = nil
	arg0._cameraRightBoundPoint = nil
	arg0._projectionConst = nil
end
