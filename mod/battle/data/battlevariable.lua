ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleVariable = var0_0.Battle.BattleVariable or {}

local var1_0 = var0_0.Battle.BattleVariable
local var2_0 = var0_0.Battle.BattleConfig

function var1_0.Init()
	var1_0.speedRatioByIFF = {
		[0] = 1,
		1,
		[-1] = 1
	}
	var1_0.focusExemptList = {}
	var1_0.MapSpeedRatio = 1
	var1_0.MapSpeedFacotrList = {}
	var1_0.IFFFactorList = {}

	for iter0_1, iter1_1 in pairs(var1_0.speedRatioByIFF) do
		var1_0.IFFFactorList[iter0_1] = {}
	end

	var1_0._lastCameraPos = nil

	local var0_1 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var0_1, true)

	var1_0._camera = var0_1:GetComponent(typeof(Camera))
	var1_0._cameraTF = var1_0._camera.transform
	var1_0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))

	local var1_1 = math.deg2Rad * var1_0._cameraTF.localEulerAngles.x

	var1_0._camera_radian_x_sin = math.sin(var1_1)
	var1_0._camera_radian_x_cos = math.cos(var1_1)
	var1_0._camera_radian_x_tan = var1_0._camera_radian_x_sin / var1_0._camera_radian_x_cos
	var1_0.CameraNormalHeight = var1_0._camera_radian_x_cos * var2_0.CAMERA_SIZE + var2_0.CAMERA_BASE_HEIGH
	var1_0.CameraFocusHeight = var1_0._camera_radian_x_cos * var2_0.CAST_CAM_ZOOM_SIZE + var2_0.CAMERA_BASE_HEIGH
end

function var1_0.Clear()
	var1_0.speedRatioByIFF = nil
	var1_0.focusExemptList = nil
	var1_0.MapSpeedRatio = nil
	var1_0.MapSpeedFacotrList = nil
	var1_0.IFFFactorList = nil
	var1_0._lastCameraPos = nil
	var1_0._camera = nil
	var1_0._cameraTF = nil
	var1_0._uiCamera = nil
	var1_0._camera_radian_x_sin = nil
	var1_0._camera_radian_x_cos = nil
	var1_0._camera_radian_x_tan = nil
	var1_0.CameraNormalHeight = nil
	var1_0.CameraFocusHeight = nil
end

local var3_0 = 0
local var4_0 = 0
local var5_0 = 0
local var6_0 = 0
local var7_0 = 0
local var8_0 = 0

function var1_0.UpdateCameraPositionArgs()
	local var0_3 = var1_0._cameraTF.position
	local var1_3 = var1_0._camera.orthographicSize

	if var1_0._lastCameraPos == var0_3 and var1_0._lastCameraSize == var1_3 then
		return
	else
		var1_0._lastCameraPos = var0_3
		var1_0._lastCameraSize = var1_3
	end

	local var2_3 = pg.CameraFixMgr.GetInstance()
	local var3_3 = var1_0._camera:ScreenToWorldPoint(var2_3.leftBottomVector)
	local var4_3 = var1_0._camera:ScreenToWorldPoint(var2_3.rightTopVector)
	local var5_3 = var1_0._uiCamera:ScreenToWorldPoint(var2_3.leftBottomVector)
	local var6_3 = var1_0._uiCamera:ScreenToWorldPoint(var2_3.rightTopVector)

	var3_0 = var3_3.x
	var4_0 = var5_3.x
	var5_0 = (var6_3.x - var5_3.x) / (var4_3.x - var3_3.x)

	local var7_3 = var3_3.y * 0.866 + var3_3.z * 0.5
	local var8_3 = var4_3.y * 0.866 + var4_3.z * 0.5

	var6_0 = var7_3
	var7_0 = var5_3.y
	var8_0 = (var6_3.y - var5_3.y) / (var8_3 - var7_3)
end

function var1_0.CameraPosToUICamera(arg0_4)
	var1_0.CameraPosToUICameraByRef(arg0_4)

	return arg0_4
end

function var1_0.CameraPosToUICameraByRef(arg0_5)
	local var0_5 = (arg0_5.x - var3_0) * var5_0 + var4_0

	arg0_5.y, arg0_5.x = (arg0_5.y * 0.866 + arg0_5.z * 0.5 - var6_0) * var8_0 + var7_0, var0_5
	arg0_5.z = 0
end

function var1_0.UIPosToScenePos(arg0_6, arg1_6)
	local var0_6 = pg.CameraFixMgr.GetInstance()
	local var1_6 = var0_6:GetCurrentWidth()
	local var2_6 = var0_6:GetCurrentHeight()
	local var3_6 = var1_6 / 1920
	local var4_6 = var2_6 / 1080

	arg0_6 = Vector2(var3_6 * arg0_6.x, var4_6 * arg0_6.y)

	local var5_6 = var1_0._uiCamera:ScreenToWorldPoint(arg0_6)
	local var6_6 = (var5_6.x - var4_0) / var5_0 + var3_0
	local var7_6 = (var5_6.y - var7_0) / var8_0 + var6_0
	local var8_6 = math.tan(30 * Mathf.Deg2Rad)
	local var9_6 = var7_6 / var8_6 + var7_6 * var8_6 * 0.5

	arg1_6:Set(var6_6, 0, var9_6)
end

function var1_0.AppendMapFactor(arg0_7, arg1_7)
	if var1_0.MapSpeedFacotrList[arg0_7] ~= nil then
		var1_0.RemoveMapFactor(arg0_7)
	end

	var1_0.MapSpeedRatio = var1_0.MapSpeedRatio * arg1_7
	var1_0.MapSpeedFacotrList[arg0_7] = arg1_7
end

function var1_0.RemoveMapFactor(arg0_8)
	local var0_8 = var1_0.MapSpeedFacotrList[arg0_8]

	if var0_8 ~= nil then
		var1_0.MapSpeedRatio = var1_0.MapSpeedRatio / var0_8
		var1_0.MapSpeedFacotrList[arg0_8] = nil
	end
end

function var1_0.AppendIFFFactor(arg0_9, arg1_9, arg2_9)
	local var0_9 = var1_0.IFFFactorList[arg0_9]

	if var0_9[arg1_9] ~= nil then
		var1_0.RemoveIFFFactor(arg0_9, arg1_9)
	end

	var1_0.speedRatioByIFF[arg0_9] = var1_0.speedRatioByIFF[arg0_9] * arg2_9
	var0_9[arg1_9] = arg2_9
	var1_0.focusExemptList = {}
end

function var1_0.RemoveIFFFactor(arg0_10, arg1_10)
	local var0_10 = var1_0.IFFFactorList[arg0_10]
	local var1_10 = var0_10[arg1_10]

	if var1_10 ~= nil then
		var1_0.speedRatioByIFF[arg0_10] = var1_0.speedRatioByIFF[arg0_10] / var1_10
		var0_10[arg1_10] = nil
		var1_0.focusExemptList = {}
	end
end

function var1_0.GetSpeedRatio(arg0_11, arg1_11)
	return var1_0.focusExemptList[arg0_11] or var1_0.speedRatioByIFF[arg1_11]
end

function var1_0.AddExempt(arg0_12, arg1_12, arg2_12)
	local var0_12 = var1_0.IFFFactorList[arg1_12][arg2_12]

	if var0_12 ~= nil then
		var1_0.focusExemptList[arg0_12] = var1_0.speedRatioByIFF[arg1_12] / var0_12
	end
end
