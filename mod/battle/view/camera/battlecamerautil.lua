ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleVariable
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleConfig
local var4 = singletonClass("BattleCameraUtil")

var0.Battle.BattleCameraUtil = var4
var4.__name = "BattleCameraUtil"
var4.FOCUS_PILOT = "FOCUS_PILOT"
var4.TWEEN_TO_CHARACTER = "TWEEN_TO_CHARACTER"
var4.FOLLOW_GESTURE = "FOLLOW_GESTURE"

function var4.Ctor(arg0)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	arg0._cameraTF = arg0._camera.transform
	arg0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0._cameraFixMgr = pg.CameraFixMgr.GetInstance()
end

function var4.ActiveMainCemera(arg0)
	CameraMgr.instance:SetActiveMainCamera(arg0)
end

function var4.Initialize(arg0)
	arg0._cameraTF.localPosition = var3.CAMERA_INIT_POS

	var1.UpdateCameraPositionArgs()
	arg0:setArrowPoint()

	arg0._boundFix = var0.Battle.BattleCameraBoundFixDecorate.New()
	arg0._followPilot = var0.Battle.BattleCameraFollowPilot.New()
	arg0._focusCharacter = var0.Battle.BattleCameraFocusChar.New()
	arg0._fromTo = var0.Battle.BattleCameraTween.New()
	arg0._gesture = var0.Battle.BattleCameraFollowGesture.New()

	arg0:active()
	arg0:SwitchCameraPos()

	arg0._shakeEnabled = true
	arg0._uiMediator = var0.Battle.BattleState.GetInstance():GetMediatorByName(var0.Battle.BattleUIMediator.__name)
end

function var4.Clear(arg0)
	arg0.ActiveMainCemera(false)
	LeanTween.cancel(go(arg0._camera))
	arg0:Deactive()
	arg0:StopShake()
	arg0._boundFix:Dispose()
	arg0._followPilot:Dispose()
	arg0._focusCharacter:Dispose()
	arg0._fromTo:Dispose()
	arg0._gesture:Dispose()

	arg0._cameraTF.localPosition = Vector3(0, 62, -10)
	arg0._camera.orthographicSize = 20
	arg0._uiMediator = nil
end

function var4.SetMapData(arg0, arg1, arg2, arg3, arg4)
	local var0, var1, var2, var3 = arg0._boundFix:SetMapData(arg1, arg2, arg3, arg4)
	local var4 = pg.CameraFixMgr.GetInstance().actualWidth

	arg0._followPilot:SetGoldenRation(arg0._camera:ScreenToWorldPoint(Vector3(var4 * var3.CAMERA_GOLDEN_RATE, 0, 0)).x - arg0._cameraTF.position.x)

	return var0, var1, var2, var3
end

function var4.SetFocusFleet(arg0, arg1)
	arg0._followPilot:SetFleetVO(arg1)

	arg0._cameraTF.position = arg0._boundFix:GetCameraPos(arg0._followPilot:GetCameraPos())

	var1.UpdateCameraPositionArgs()
end

function var4.SetCameraSilder(arg0, arg1)
	arg0._gesture:SetGestureComponent(arg1)
end

function var4.SwitchCameraPos(arg0, arg1)
	if arg1 == "TWEEN_TO_CHARACTER" then
		function arg0._currentCameraPos()
			return arg0._fromTo:GetCameraPos()
		end
	elseif arg1 == "FOLLOW_GESTURE" then
		function arg0._currentCameraPos()
			return arg0._boundFix:GetCameraPos(arg0._gesture:GetCameraPos(arg0._cameraTF.position))
		end
	else
		function arg0._currentCameraPos()
			return arg0._boundFix:GetCameraPos(arg0._followPilot:GetCameraPos())
		end
	end
end

function var4.GetS2WPoint(arg0, arg1)
	return arg0._camera:ScreenToWorldPoint(arg1)
end

function var4.setArrowPoint(arg0)
	local var0 = 1
	local var1 = arg0._uiCamera:ScreenToWorldPoint(arg0._cameraFixMgr.leftBottomVector) + Vector3(var0, var0, 0)
	local var2 = arg0._uiCamera:ScreenToWorldPoint(arg0._cameraFixMgr.rightTopVector) - Vector3(var0, var0, 0)

	arg0._arrowCenterPos = (var1 + var2) * 0.5
	arg0._arrowRightHorizon = var2.x + 4
	arg0._arrowTopHorizon = var2.y + 4
	arg0._arrowBottomHorizon = var1.y - 4
	arg0._arrowLeftHorizon = var1.x - 3.75
	arg0._arrowLeftBottomPos_notch = arg0._uiCamera:ScreenToWorldPoint(arg0._cameraFixMgr.notchAdaptLBVector) + Vector3(var0, var0, 0)
	arg0._arrowRightTopPos_notch = arg0._uiCamera:ScreenToWorldPoint(arg0._cameraFixMgr.notchAdaptRTVector) - Vector3(var0, var0, 0)
	arg0._arrowFieldHalfWidth_notch = arg0._arrowRightTopPos_notch.x - arg0._arrowCenterPos.x
end

function var4.Update(arg0)
	local var0 = arg0:GetCameraPoint()
	local var1 = arg0._cameraTF.position

	if var1.x ~= var0.x or var1.z ~= var0 then
		arg0._cameraTF.position = var0

		var1.UpdateCameraPositionArgs()
	end

	if arg0._shakeInfo and arg0._shakeEnabled then
		arg0:DoShake()
	end
end

function var4.StartShake(arg0, arg1)
	if arg0._shakeInfo and (arg0._shakeInfo._priority > arg1.priority or arg1.priority == 0) then
		return
	end

	arg0._shakeInfo = {}
	arg0._shakeInfo._elapsed = 0
	arg0._shakeInfo._duration = arg1.time or 0
	arg0._shakeInfo._count = 0
	arg0._shakeInfo._loop = arg1.loop or 1
	arg0._shakeInfo._direction = 1
	arg0._shakeInfo._vibrationH = arg1.vibration_H or 0
	arg0._shakeInfo._fricConstH = arg1.friction_const_H or 0
	arg0._shakeInfo._fricCoefH = arg1.friction_coefficient_H or 1
	arg0._shakeInfo._vibrationV = arg1.vibration_V or 0
	arg0._shakeInfo._fricConstV = arg1.friction_const_V or 0
	arg0._shakeInfo._fricCoefV = arg1.friction_coefficient_V or 1
	arg0._shakeInfo._diff = Vector3.zero
	arg0._shakeInfo._bounce = arg1.bounce

	if arg0._shakeInfo._bounce then
		arg0._shakeInfo._duration = arg0._shakeInfo._duration * 0.5
	end

	arg0._shakeInfo._priority = arg1.priority
end

function var4.StopShake(arg0)
	arg0._shakeInfo = nil
end

function var4.DoShake(arg0)
	arg0._shakeInfo._count = arg0._shakeInfo._count + 1
	arg0._shakeInfo._elapsed = arg0._shakeInfo._elapsed + Time.deltaTime

	local var0 = arg0._shakeInfo._vibrationH * (math.random() * 0.5 + 0.5) * arg0._shakeInfo._count
	local var1 = arg0._shakeInfo._vibrationV * (math.random() * 0.5 + 0.5) * arg0._shakeInfo._count
	local var2 = Vector3(var0, var1, 0):Mul(arg0._shakeInfo._direction)

	LuaHelper.UpdateTFLocalPos(arg0._cameraTF, var2 - arg0._shakeInfo._diff)

	if arg0._shakeInfo._count >= arg0._shakeInfo._loop then
		arg0._shakeInfo._vibrationH = arg0._shakeInfo._vibrationH * arg0._shakeInfo._fricCoefH + arg0._shakeInfo._fricConstH
		arg0._shakeInfo._vibrationV = arg0._shakeInfo._vibrationV * arg0._shakeInfo._fricCoefV + arg0._shakeInfo._fricConstV
		arg0._shakeInfo._direction = -arg0._shakeInfo._direction
		arg0._shakeInfo._count = 0
	end

	if arg0._shakeInfo._elapsed > arg0._shakeInfo._duration then
		if arg0._shakeInfo._bounce then
			var4.bounceReverse(arg0._shakeInfo)

			arg0._shakeInfo._elapsed = 0
			arg0._shakeInfo._bounce = false
		else
			arg0:StopShake()
		end
	else
		arg0._shakeInfo._diff = var2
	end
end

function var4.bounceReverse(arg0)
	if arg0._fricCoefH ~= 0 then
		arg0._fricCoefH = 1 / arg0._fricCoefH
	end

	if arg0._fricCoefV ~= 0 then
		arg0._fricCoefV = 1 / arg0._fricCoefV
	end

	arg0._fricConstH = arg0._fricConstH * -1
	arg0._fricConstV = arg0._fricConstV * -1
end

function var4.PauseShake(arg0)
	arg0._shakeEnabled = false
end

function var4.ResumeShake(arg0)
	arg0._shakeEnabled = true
end

function var4.active(arg0)
	UpdateBeat:Add(arg0.Update, arg0)
end

function var4.Deactive(arg0)
	UpdateBeat:Remove(arg0.Update, arg0)
end

function var4.CutInPainting(arg0, arg1, arg2)
	arg0:DispatchEvent(var0.Event.New(var2.SHOW_PAINTING, {
		caster = arg1,
		speed = arg2
	}))
end

function var4.BulletTime(arg0, arg1, arg2, arg3)
	local var0 = {
		key = arg1,
		speed = arg2,
		exemptUnit = arg3
	}

	arg0:DispatchEvent(var0.Event.New(var2.BULLET_TIME, var0))
	var0.Battle.BattleState.GetInstance():ScaleTimer(arg2)

	if arg0._uiMediator and arg0._uiMediator:GetAppearFX() ~= nil then
		arg0._uiMediator:GetAppearFX():GetComponent(typeof(Animator)).speed = 1 / (arg2 or 1)
	end
end

function var4.ZoomCamara(arg0, arg1, arg2, arg3, arg4)
	arg3 = arg3 or 1.6
	arg2 = arg2 or var3.CAMERA_SIZE
	arg1 = arg1 or arg0._camera.orthographicSize

	local var0 = LeanTween.value(go(arg0._camera), arg1, arg2, arg3):setOnUpdate(System.Action_float(function(arg0)
		arg0._camera.orthographicSize = arg0
	end))

	if arg4 then
		var0:setEase(LeanTweenType.easeOutExpo)
	end
end

function var4.FocusCharacter(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:StopShake()

	delay = delay or 0

	local var0 = {
		unit = arg1,
		duration = arg2,
		extraBulletTime = arg3,
		skill = arg4 or false
	}

	LeanTween.cancel(go(arg0._camera))

	local var1 = arg0._cameraTF.position

	if arg1 ~= nil then
		arg0._focusCharacter:SetUnit(arg1)

		local var2 = arg0._focusCharacter:GetCameraPos()

		if arg5 == nil then
			arg5 = true
		end

		arg0._fromTo:SetFromTo(arg0._camera, var1, var2, arg2, delay, arg5)
		arg0:SwitchCameraPos(var4.TWEEN_TO_CHARACTER)
	else
		local var3 = arg0._boundFix:GetCameraPos(arg0._followPilot:GetCameraPos())

		local function var4()
			arg0:SwitchCameraPos()
		end

		if arg5 == nil then
			arg5 = false
		end

		arg0._fromTo:SetFromTo(arg0._camera, var1, var3, arg2, delay, arg5, var4)
		arg0:SwitchCameraPos(var4.TWEEN_TO_CHARACTER)
	end

	arg0:DispatchEvent(var0.Event.New(var2.CAMERA_FOCUS, var0))
end

function var4.ResetFocus(arg0)
	arg0:StopShake()
	LeanTween.cancel(go(arg0._camera))
	LeanTween.cancel(go(arg0._uiCamera))

	local var0 = arg0._boundFix:GetCameraPos(arg0._followPilot:GetCameraPos())

	LeanTween.move(go(arg0._camera), var0, var3.CAM_RESET_DURATION):setOnUpdate(System.Action_float(function(arg0)
		var1.UpdateCameraPositionArgs()
	end))
	arg0:DispatchEvent(var0.Event.New(var2.CAMERA_FOCUS_RESET, {}))
end

function var4.GetCharacterArrowBarPosition(arg0, arg1, arg2)
	local var0 = arg0._arrowLeftBottomPos_notch
	local var1 = arg0._arrowRightTopPos_notch
	local var2 = arg0._arrowCenterPos

	if arg1.x >= arg0._arrowLeftHorizon and arg1.x < arg0._arrowRightHorizon and arg1.y >= arg0._arrowBottomHorizon and arg1.y <= arg0._arrowTopHorizon then
		return nil
	else
		local var3 = arg1.y - var2.y
		local var4
		local var5
		local var6
		local var7

		if arg1.x > var2.x then
			var6 = var1.x
			var7 = arg1.x - var2.x
		else
			var6 = var0.x
			var7 = var2.x - arg1.x
		end

		local var8 = var3 / var7 * arg0._arrowFieldHalfWidth_notch

		if var8 > var1.y then
			var8 = var1.y
			var6 = var7 / var3 * (var8 - var2.y)
		elseif var8 < var0.y then
			var8 = var0.y
			var6 = var7 / var3 * (var8 - var2.y)
		end

		if arg2 then
			arg2:Set(var6, var8, 10)

			return arg2
		else
			return Vector3(var6, var8, 10)
		end
	end
end

function var4.GetCameraPoint(arg0)
	return arg0._currentCameraPos()
end

function var4.GetArrowCenterPos(arg0)
	return arg0._arrowCenterPos
end

function var4.GetCamera(arg0)
	return arg0._camera
end

function var4.Add2Camera(arg0, arg1, arg2)
	arg2 = arg2 or 0
	arg1 = tf(arg1)

	arg1:SetParent(arg0._cameraTF)
	pg.ViewUtils.SetSortingOrder(arg1, arg2)

	return arg0._cameraTF.localScale
end

function var4.PauseCameraTween(arg0)
	LeanTween.pause(go(arg0._camera))
	LeanTween.pause(go(arg0._uiCamera))
end

function var4.ResumeCameraTween(arg0)
	LeanTween.resume(go(arg0._camera))
	LeanTween.resume(go(arg0._uiCamera))
end
