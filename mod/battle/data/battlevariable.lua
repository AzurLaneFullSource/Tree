ys = ys or {}

local var0 = ys

var0.Battle.BattleVariable = var0.Battle.BattleVariable or {}

local var1 = var0.Battle.BattleVariable
local var2 = var0.Battle.BattleConfig

function var1.Init()
	var1.speedRatioByIFF = {
		[0] = 1,
		1,
		[-1] = 1
	}
	var1.focusExemptList = {}
	var1.MapSpeedRatio = 1
	var1.MapSpeedFacotrList = {}
	var1.IFFFactorList = {}

	for iter0, iter1 in pairs(var1.speedRatioByIFF) do
		var1.IFFFactorList[iter0] = {}
	end

	var1._lastCameraPos = nil

	local var0 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var0, true)

	var1._camera = var0:GetComponent(typeof(Camera))
	var1._cameraTF = var1._camera.transform
	var1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))

	local var1 = math.deg2Rad * var1._cameraTF.localEulerAngles.x

	var1._camera_radian_x_sin = math.sin(var1)
	var1._camera_radian_x_cos = math.cos(var1)
	var1._camera_radian_x_tan = var1._camera_radian_x_sin / var1._camera_radian_x_cos
	var1.CameraNormalHeight = var1._camera_radian_x_cos * var2.CAMERA_SIZE + var2.CAMERA_BASE_HEIGH
	var1.CameraFocusHeight = var1._camera_radian_x_cos * var2.CAST_CAM_ZOOM_SIZE + var2.CAMERA_BASE_HEIGH
end

function var1.Clear()
	var1.speedRatioByIFF = nil
	var1.focusExemptList = nil
	var1.MapSpeedRatio = nil
	var1.MapSpeedFacotrList = nil
	var1.IFFFactorList = nil
	var1._lastCameraPos = nil
	var1._camera = nil
	var1._cameraTF = nil
	var1._uiCamera = nil
	var1._camera_radian_x_sin = nil
	var1._camera_radian_x_cos = nil
	var1._camera_radian_x_tan = nil
	var1.CameraNormalHeight = nil
	var1.CameraFocusHeight = nil
end

local var3 = 0
local var4 = 0
local var5 = 0
local var6 = 0
local var7 = 0
local var8 = 0

function var1.UpdateCameraPositionArgs()
	local var0 = var1._cameraTF.position
	local var1 = var1._camera.orthographicSize

	if var1._lastCameraPos == var0 and var1._lastCameraSize == var1 then
		return
	else
		var1._lastCameraPos = var0
		var1._lastCameraSize = var1
	end

	local var2 = pg.CameraFixMgr.GetInstance()
	local var3 = var1._camera:ScreenToWorldPoint(var2.leftBottomVector)
	local var4 = var1._camera:ScreenToWorldPoint(var2.rightTopVector)
	local var5 = var1._uiCamera:ScreenToWorldPoint(var2.leftBottomVector)
	local var6 = var1._uiCamera:ScreenToWorldPoint(var2.rightTopVector)

	var3 = var3.x
	var4 = var5.x
	var5 = (var6.x - var5.x) / (var4.x - var3.x)

	local var7 = var3.y * 0.866 + var3.z * 0.5
	local var8 = var4.y * 0.866 + var4.z * 0.5

	var6 = var7
	var7 = var5.y
	var8 = (var6.y - var5.y) / (var8 - var7)
end

function var1.CameraPosToUICamera(arg0)
	var1.CameraPosToUICameraByRef(arg0)

	return arg0
end

function var1.CameraPosToUICameraByRef(arg0)
	local var0 = (arg0.x - var3) * var5 + var4

	arg0.y, arg0.x = (arg0.y * 0.866 + arg0.z * 0.5 - var6) * var8 + var7, var0
	arg0.z = 0
end

function var1.UIPosToScenePos(arg0, arg1)
	local var0 = pg.CameraFixMgr.GetInstance()
	local var1 = var0:GetCurrentWidth()
	local var2 = var0:GetCurrentHeight()
	local var3 = var1 / 1920
	local var4 = var2 / 1080

	arg0 = Vector2(var3 * arg0.x, var4 * arg0.y)

	local var5 = var1._uiCamera:ScreenToWorldPoint(arg0)
	local var6 = (var5.x - var4) / var5 + var3
	local var7 = (var5.y - var7) / var8 + var6
	local var8 = math.tan(30 * Mathf.Deg2Rad)
	local var9 = var7 / var8 + var7 * var8 * 0.5

	arg1:Set(var6, 0, var9)
end

function var1.AppendMapFactor(arg0, arg1)
	if var1.MapSpeedFacotrList[arg0] ~= nil then
		var1.RemoveMapFactor(arg0)
	end

	var1.MapSpeedRatio = var1.MapSpeedRatio * arg1
	var1.MapSpeedFacotrList[arg0] = arg1
end

function var1.RemoveMapFactor(arg0)
	local var0 = var1.MapSpeedFacotrList[arg0]

	if var0 ~= nil then
		var1.MapSpeedRatio = var1.MapSpeedRatio / var0
		var1.MapSpeedFacotrList[arg0] = nil
	end
end

function var1.AppendIFFFactor(arg0, arg1, arg2)
	local var0 = var1.IFFFactorList[arg0]

	if var0[arg1] ~= nil then
		var1.RemoveIFFFactor(arg0, arg1)
	end

	var1.speedRatioByIFF[arg0] = var1.speedRatioByIFF[arg0] * arg2
	var0[arg1] = arg2
	var1.focusExemptList = {}
end

function var1.RemoveIFFFactor(arg0, arg1)
	local var0 = var1.IFFFactorList[arg0]
	local var1 = var0[arg1]

	if var1 ~= nil then
		var1.speedRatioByIFF[arg0] = var1.speedRatioByIFF[arg0] / var1
		var0[arg1] = nil
		var1.focusExemptList = {}
	end
end

function var1.GetSpeedRatio(arg0, arg1)
	return var1.focusExemptList[arg0] or var1.speedRatioByIFF[arg1]
end

function var1.AddExempt(arg0, arg1, arg2)
	local var0 = var1.IFFFactorList[arg1][arg2]

	if var0 ~= nil then
		var1.focusExemptList[arg0] = var1.speedRatioByIFF[arg1] / var0
	end
end
