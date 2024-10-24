ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleVariable
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = singletonClass("BattleCameraUtil")

var0_0.Battle.BattleCameraUtil = var4_0
var4_0.__name = "BattleCameraUtil"
var4_0.FOCUS_PILOT = "FOCUS_PILOT"
var4_0.TWEEN_TO_CHARACTER = "TWEEN_TO_CHARACTER"
var4_0.FOLLOW_GESTURE = "FOLLOW_GESTURE"

function var4_0.Ctor(arg0_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	arg0_1._cameraTF = arg0_1._camera.transform
	arg0_1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_1._cameraFixMgr = pg.CameraFixMgr.GetInstance()
end

function var4_0.ActiveMainCemera(arg0_2)
	CameraMgr.instance:SetActiveMainCamera(arg0_2)
end

function var4_0.Initialize(arg0_3)
	arg0_3._cameraTF.localPosition = var3_0.CAMERA_INIT_POS

	var1_0.UpdateCameraPositionArgs()
	arg0_3:setArrowPoint()

	arg0_3._boundFix = var0_0.Battle.BattleCameraBoundFixDecorate.New()
	arg0_3._followPilot = var0_0.Battle.BattleCameraFollowPilot.New()
	arg0_3._focusCharacter = var0_0.Battle.BattleCameraFocusChar.New()
	arg0_3._fromTo = var0_0.Battle.BattleCameraTween.New()
	arg0_3._gesture = var0_0.Battle.BattleCameraFollowGesture.New()

	arg0_3:active()
	arg0_3:SwitchCameraPos()

	arg0_3._shakeEnabled = true
	arg0_3._uiMediator = var0_0.Battle.BattleState.GetInstance():GetMediatorByName(var0_0.Battle.BattleUIMediator.__name)
end

function var4_0.Clear(arg0_4)
	arg0_4.ActiveMainCemera(false)
	LeanTween.cancel(go(arg0_4._camera))
	arg0_4:Deactive()
	arg0_4:StopShake()
	arg0_4._boundFix:Dispose()
	arg0_4._followPilot:Dispose()
	arg0_4._focusCharacter:Dispose()
	arg0_4._fromTo:Dispose()
	arg0_4._gesture:Dispose()

	arg0_4._cameraTF.localPosition = Vector3(0, 62, -10)
	arg0_4._camera.orthographicSize = 20
	arg0_4._uiMediator = nil
end

function var4_0.SetMapData(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5, var1_5, var2_5, var3_5 = arg0_5._boundFix:SetMapData(arg1_5, arg2_5, arg3_5, arg4_5)
	local var4_5 = pg.CameraFixMgr.GetInstance().actualWidth

	arg0_5._followPilot:SetGoldenRation(arg0_5._camera:ScreenToWorldPoint(Vector3(var4_5 * var3_0.CAMERA_GOLDEN_RATE, 0, 0)).x - arg0_5._cameraTF.position.x)

	return var0_5, var1_5, var2_5, var3_5
end

function var4_0.SetFocusFleet(arg0_6, arg1_6)
	arg0_6._followPilot:SetFleetVO(arg1_6)

	arg0_6._cameraTF.position = arg0_6._boundFix:GetCameraPos(arg0_6._followPilot:GetCameraPos())

	var1_0.UpdateCameraPositionArgs()
end

function var4_0.SetCameraSilder(arg0_7, arg1_7)
	arg0_7._gesture:SetGestureComponent(arg1_7)
end

function var4_0.SwitchCameraPos(arg0_8, arg1_8)
	if arg1_8 == "TWEEN_TO_CHARACTER" then
		function arg0_8._currentCameraPos()
			return arg0_8._fromTo:GetCameraPos()
		end
	elseif arg1_8 == "FOLLOW_GESTURE" then
		function arg0_8._currentCameraPos()
			return arg0_8._boundFix:GetCameraPos(arg0_8._gesture:GetCameraPos(arg0_8._cameraTF.position))
		end
	else
		function arg0_8._currentCameraPos()
			return arg0_8._boundFix:GetCameraPos(arg0_8._followPilot:GetCameraPos())
		end
	end
end

function var4_0.GetS2WPoint(arg0_12, arg1_12)
	return arg0_12._camera:ScreenToWorldPoint(arg1_12)
end

function var4_0.setArrowPoint(arg0_13)
	local var0_13 = 1
	local var1_13 = arg0_13._uiCamera:ScreenToWorldPoint(arg0_13._cameraFixMgr.leftBottomVector) + Vector3(var0_13, var0_13, 0)
	local var2_13 = arg0_13._uiCamera:ScreenToWorldPoint(arg0_13._cameraFixMgr.rightTopVector) - Vector3(var0_13, var0_13, 0)

	arg0_13._arrowCenterPos = (var1_13 + var2_13) * 0.5
	arg0_13._arrowRightHorizon = var2_13.x + 4
	arg0_13._arrowTopHorizon = var2_13.y + 4
	arg0_13._arrowBottomHorizon = var1_13.y - 4
	arg0_13._arrowLeftHorizon = var1_13.x - 3.75
	arg0_13._arrowLeftBottomPos_notch = arg0_13._uiCamera:ScreenToWorldPoint(arg0_13._cameraFixMgr.notchAdaptLBVector) + Vector3(var0_13, var0_13, 0)
	arg0_13._arrowRightTopPos_notch = arg0_13._uiCamera:ScreenToWorldPoint(arg0_13._cameraFixMgr.notchAdaptRTVector) - Vector3(var0_13, var0_13, 0)
	arg0_13._arrowFieldHalfWidth_notch = arg0_13._arrowRightTopPos_notch.x - arg0_13._arrowCenterPos.x
end

function var4_0.Update(arg0_14)
	local var0_14 = arg0_14:GetCameraPoint()
	local var1_14 = arg0_14._cameraTF.position

	if var1_14.x ~= var0_14.x or var1_14.z ~= var0_14 then
		arg0_14._cameraTF.position = var0_14

		var1_0.UpdateCameraPositionArgs()
	end

	if arg0_14._shakeInfo and arg0_14._shakeEnabled then
		arg0_14:DoShake()
	end
end

function var4_0.StartShake(arg0_15, arg1_15)
	if arg0_15._shakeInfo and (arg0_15._shakeInfo._priority > arg1_15.priority or arg1_15.priority == 0) then
		return
	end

	arg0_15._shakeInfo = {}
	arg0_15._shakeInfo._elapsed = 0
	arg0_15._shakeInfo._duration = arg1_15.time or 0
	arg0_15._shakeInfo._count = 0
	arg0_15._shakeInfo._loop = arg1_15.loop or 1
	arg0_15._shakeInfo._direction = 1
	arg0_15._shakeInfo._vibrationH = arg1_15.vibration_H or 0
	arg0_15._shakeInfo._fricConstH = arg1_15.friction_const_H or 0
	arg0_15._shakeInfo._fricCoefH = arg1_15.friction_coefficient_H or 1
	arg0_15._shakeInfo._vibrationV = arg1_15.vibration_V or 0
	arg0_15._shakeInfo._fricConstV = arg1_15.friction_const_V or 0
	arg0_15._shakeInfo._fricCoefV = arg1_15.friction_coefficient_V or 1
	arg0_15._shakeInfo._diff = Vector3.zero
	arg0_15._shakeInfo._bounce = arg1_15.bounce

	if arg0_15._shakeInfo._bounce then
		arg0_15._shakeInfo._duration = arg0_15._shakeInfo._duration * 0.5
	end

	arg0_15._shakeInfo._priority = arg1_15.priority
end

function var4_0.StopShake(arg0_16)
	arg0_16._shakeInfo = nil
end

function var4_0.DoShake(arg0_17)
	arg0_17._shakeInfo._count = arg0_17._shakeInfo._count + 1
	arg0_17._shakeInfo._elapsed = arg0_17._shakeInfo._elapsed + Time.deltaTime

	local var0_17 = arg0_17._shakeInfo._vibrationH * (math.random() * 0.5 + 0.5) * arg0_17._shakeInfo._count
	local var1_17 = arg0_17._shakeInfo._vibrationV * (math.random() * 0.5 + 0.5) * arg0_17._shakeInfo._count
	local var2_17 = Vector3(var0_17, var1_17, 0):Mul(arg0_17._shakeInfo._direction)

	LuaHelper.UpdateTFLocalPos(arg0_17._cameraTF, var2_17 - arg0_17._shakeInfo._diff)

	if arg0_17._shakeInfo._count >= arg0_17._shakeInfo._loop then
		arg0_17._shakeInfo._vibrationH = arg0_17._shakeInfo._vibrationH * arg0_17._shakeInfo._fricCoefH + arg0_17._shakeInfo._fricConstH
		arg0_17._shakeInfo._vibrationV = arg0_17._shakeInfo._vibrationV * arg0_17._shakeInfo._fricCoefV + arg0_17._shakeInfo._fricConstV
		arg0_17._shakeInfo._direction = -arg0_17._shakeInfo._direction
		arg0_17._shakeInfo._count = 0
	end

	if arg0_17._shakeInfo._elapsed > arg0_17._shakeInfo._duration then
		if arg0_17._shakeInfo._bounce then
			var4_0.bounceReverse(arg0_17._shakeInfo)

			arg0_17._shakeInfo._elapsed = 0
			arg0_17._shakeInfo._bounce = false
		else
			arg0_17:StopShake()
		end
	else
		arg0_17._shakeInfo._diff = var2_17
	end
end

function var4_0.bounceReverse(arg0_18)
	if arg0_18._fricCoefH ~= 0 then
		arg0_18._fricCoefH = 1 / arg0_18._fricCoefH
	end

	if arg0_18._fricCoefV ~= 0 then
		arg0_18._fricCoefV = 1 / arg0_18._fricCoefV
	end

	arg0_18._fricConstH = arg0_18._fricConstH * -1
	arg0_18._fricConstV = arg0_18._fricConstV * -1
end

function var4_0.PauseShake(arg0_19)
	arg0_19._shakeEnabled = false
end

function var4_0.ResumeShake(arg0_20)
	arg0_20._shakeEnabled = true
end

function var4_0.active(arg0_21)
	UpdateBeat:Add(arg0_21.Update, arg0_21)
end

function var4_0.Deactive(arg0_22)
	UpdateBeat:Remove(arg0_22.Update, arg0_22)
end

function var4_0.CutInPainting(arg0_23, arg1_23, arg2_23)
	arg0_23:DispatchEvent(var0_0.Event.New(var2_0.SHOW_PAINTING, {
		caster = arg1_23,
		speed = arg2_23
	}))
end

function var4_0.BulletTime(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = {
		key = arg1_24,
		speed = arg2_24,
		exemptUnit = arg3_24
	}

	arg0_24:DispatchEvent(var0_0.Event.New(var2_0.BULLET_TIME, var0_24))
	var0_0.Battle.BattleState.GetInstance():ScaleTimer(arg2_24)

	if arg0_24._uiMediator then
		local var1_24 = 1 / (arg2_24 or 1)

		arg0_24._uiMediator:ScaleUISpeed(var1_24)

		if arg0_24._uiMediator:GetAppearFX() ~= nil then
			arg0_24._uiMediator:GetAppearFX():GetComponent(typeof(Animator)).speed = var1_24
		end
	end
end

function var4_0.ZoomCamara(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	arg3_25 = arg3_25 or 1.6
	arg2_25 = arg2_25 or var3_0.CAMERA_SIZE
	arg1_25 = arg1_25 or arg0_25._camera.orthographicSize

	local var0_25 = LeanTween.value(go(arg0_25._camera), arg1_25, arg2_25, arg3_25):setOnUpdate(System.Action_float(function(arg0_26)
		arg0_25._camera.orthographicSize = arg0_26
	end))

	if arg4_25 then
		var0_25:setEase(LeanTweenType.easeOutExpo)
	end
end

function var4_0.FocusCharacter(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27)
	arg0_27:StopShake()

	delay = delay or 0

	local var0_27 = {
		unit = arg1_27,
		duration = arg2_27,
		extraBulletTime = arg3_27,
		skill = arg4_27 or false
	}

	LeanTween.cancel(go(arg0_27._camera))

	local var1_27 = arg0_27._cameraTF.position

	if arg1_27 ~= nil then
		arg0_27._focusCharacter:SetUnit(arg1_27)

		local var2_27 = arg0_27._focusCharacter:GetCameraPos()

		if arg5_27 == nil then
			arg5_27 = true
		end

		arg0_27._fromTo:SetFromTo(arg0_27._camera, var1_27, var2_27, arg2_27, delay, arg5_27)
		arg0_27:SwitchCameraPos(var4_0.TWEEN_TO_CHARACTER)
	else
		local var3_27 = arg0_27._boundFix:GetCameraPos(arg0_27._followPilot:GetCameraPos())

		local function var4_27()
			arg0_27:SwitchCameraPos()
		end

		if arg5_27 == nil then
			arg5_27 = false
		end

		arg0_27._fromTo:SetFromTo(arg0_27._camera, var1_27, var3_27, arg2_27, delay, arg5_27, var4_27)
		arg0_27:SwitchCameraPos(var4_0.TWEEN_TO_CHARACTER)
	end

	arg0_27:DispatchEvent(var0_0.Event.New(var2_0.CAMERA_FOCUS, var0_27))
end

function var4_0.ResetFocus(arg0_29)
	arg0_29:StopShake()
	LeanTween.cancel(go(arg0_29._camera))
	LeanTween.cancel(go(arg0_29._uiCamera))

	local var0_29 = arg0_29._boundFix:GetCameraPos(arg0_29._followPilot:GetCameraPos())

	LeanTween.move(go(arg0_29._camera), var0_29, var3_0.CAM_RESET_DURATION):setOnUpdate(System.Action_float(function(arg0_30)
		var1_0.UpdateCameraPositionArgs()
	end))
	arg0_29:DispatchEvent(var0_0.Event.New(var2_0.CAMERA_FOCUS_RESET, {}))
end

function var4_0.GetCharacterArrowBarPosition(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31._arrowLeftBottomPos_notch
	local var1_31 = arg0_31._arrowRightTopPos_notch
	local var2_31 = arg0_31._arrowCenterPos

	if arg1_31.x >= arg0_31._arrowLeftHorizon and arg1_31.x < arg0_31._arrowRightHorizon and arg1_31.y >= arg0_31._arrowBottomHorizon and arg1_31.y <= arg0_31._arrowTopHorizon then
		return nil
	else
		local var3_31 = arg1_31.y - var2_31.y
		local var4_31
		local var5_31
		local var6_31
		local var7_31

		if arg1_31.x > var2_31.x then
			var6_31 = var1_31.x
			var7_31 = arg1_31.x - var2_31.x
		else
			var6_31 = var0_31.x
			var7_31 = var2_31.x - arg1_31.x
		end

		local var8_31 = var3_31 / var7_31 * arg0_31._arrowFieldHalfWidth_notch

		if var8_31 > var1_31.y then
			var8_31 = var1_31.y
			var6_31 = var7_31 / var3_31 * (var8_31 - var2_31.y)
		elseif var8_31 < var0_31.y then
			var8_31 = var0_31.y
			var6_31 = var7_31 / var3_31 * (var8_31 - var2_31.y)
		end

		if arg2_31 then
			arg2_31:Set(var6_31, var8_31, 10)

			return arg2_31
		else
			return Vector3(var6_31, var8_31, 10)
		end
	end
end

function var4_0.GetCameraPoint(arg0_32)
	return arg0_32._currentCameraPos()
end

function var4_0.GetArrowCenterPos(arg0_33)
	return arg0_33._arrowCenterPos
end

function var4_0.GetCamera(arg0_34)
	return arg0_34._camera
end

function var4_0.Add2Camera(arg0_35, arg1_35, arg2_35)
	arg2_35 = arg2_35 or 0
	arg1_35 = tf(arg1_35)

	arg1_35:SetParent(arg0_35._cameraTF)
	pg.ViewUtils.SetSortingOrder(arg1_35, arg2_35)

	return arg0_35._cameraTF.localScale
end

function var4_0.PauseCameraTween(arg0_36)
	LeanTween.pause(go(arg0_36._camera))
	LeanTween.pause(go(arg0_36._uiCamera))
end

function var4_0.ResumeCameraTween(arg0_37)
	LeanTween.resume(go(arg0_37._camera))
	LeanTween.resume(go(arg0_37._uiCamera))
end
