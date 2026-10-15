local var0_0 = class("AimIKSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.GET_TIP_SHOW_INFO = "AimIKSystem.GetTipShowInfo"
var0_0.ON_BEGIN_DRAG = "AimIKSystem.OnBeginDrag"
var0_0.ON_DRAG = "AimIKSystem.OnDrag"
var0_0.ON_END_DRAG = "AimIKSystem.OnEndDrag"
var0_0.ENTER_TIMELINE_AIMIK_STATUS = "AimIKSystem.EnterTimelineAimIKStatus"
var0_0.EXIT_TIMELINE_AIMIK_STATUS = "AimIKSystem.ExitTimelineAimIKStatus"
var0_0.ENTER_TOUCH_AIMIK_STATUS = "AimIKSystem.EnterTouchAimIKStatus"
var0_0.EXIT_TOUCH_AIMIK_STATUS = "AimIKSystem.ExitTouchAimIKStatus"
var0_0.ON_EXIT_TOUCH_MODE = "AimIKSystem.OnExitTouchMode"

function var0_0.OnInit(arg0_1)
	arg0_1.inStatus = false
	arg0_1.inExitProcessing = false
	arg0_1.exitProcessToken = 0
	arg0_1.touchProcessToken = 0
	arg0_1.inputEnabled = false
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.GET_TIP_SHOW_INFO, function(arg0_3, arg1_3)
		return arg0_2:GetTipShowInfo(arg1_3)
	end)
	arg0_2:Bind(var0_0.ON_BEGIN_DRAG, function(arg0_4, arg1_4, arg2_4)
		arg0_2:OnBeginDrag(arg1_4, arg2_4)
	end)
	arg0_2:Bind(var0_0.ON_DRAG, function(arg0_5, arg1_5, arg2_5)
		arg0_2:OnDrag(arg1_5, arg2_5)
	end)
	arg0_2:Bind(var0_0.ON_END_DRAG, function(arg0_6, arg1_6, arg2_6)
		arg0_2:OnEndDrag(arg1_6, arg2_6)
	end)
	arg0_2:Bind(var0_0.ENTER_TIMELINE_AIMIK_STATUS, function(arg0_7, arg1_7)
		arg0_2:EnterTimelineAimIKStatus(arg1_7)
	end)
	arg0_2:Bind(var0_0.EXIT_TIMELINE_AIMIK_STATUS, function()
		arg0_2:ExitTimelineAimIKStatus()
	end)
	arg0_2:Bind(var0_0.ENTER_TOUCH_AIMIK_STATUS, function(arg0_9, arg1_9)
		arg0_2:EnterTouchAimIKStatus(arg1_9)
	end)
	arg0_2:Bind(var0_0.EXIT_TOUCH_AIMIK_STATUS, function()
		arg0_2:ExitTouchAimIKStatus()
	end)
	arg0_2:Bind(var0_0.ON_EXIT_TOUCH_MODE, function(arg0_11, arg1_11)
		arg0_2:ExitTouchAimIKStatus(true, arg1_11)
	end)
end

function var0_0.OnHandleNotification(arg0_12, arg1_12, arg2_12)
	if arg1_12 == Dorm3dRoomTemplateScene.TIMELINE_END and arg0_12.statusMode == "timeline" then
		if not arg0_12.inStatus and not arg0_12.inExitProcessing then
			return
		end

		arg0_12:ForceExitTimelineAimIKStatus()
	end
end

function var0_0.GetInterests()
	return {
		Dorm3dRoomTemplateScene.TIMELINE_END
	}
end

function var0_0.OnDispose(arg0_14)
	arg0_14.touchProcessToken = arg0_14.touchProcessToken + 1

	arg0_14:InvalidateExitProcess()
	arg0_14:UnregisterTrigger()

	if arg0_14.statusMode == "touch" then
		arg0_14:ResetTouchItem()
	end

	arg0_14:FinishExitTimelineAimIKStatus()

	arg0_14.inputEnabled = false

	arg0_14:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, false)

	arg0_14.statusMode = nil
	arg0_14.touchExitCallbacks = nil
end

function var0_0.EnterTimelineAimIKStatus(arg0_15, arg1_15)
	warning("enteraimikstatus")

	if arg0_15.statusMode or arg0_15.inExitProcessing then
		warning("重复进入TimelineAimIK状态")

		return
	end

	arg0_15.inStatus = true
	arg0_15.statusMode = "timeline"

	local var0_15 = pg.dorm3d_aim_ik[arg1_15]

	assert(var0_15, "AimIK config is nil for id: " .. tostring(arg1_15))

	local var1_15 = GameObject.Find(var0_15.item_path)

	assert(not IsNil(var1_15), "Timeline AimIK item not found: " .. var0_15.item_path)
	arg0_15:InitAimIKComponents(var0_15, Dorm3dHxHelper.GetTimelineMainCharacter(), var1_15.transform)

	arg0_15.mainCamera = Camera.main
	arg0_15.headAimIKComp.weight = 0
	arg0_15.stickAimComp.weight = 0

	setActive(arg0_15.configRoot, true)
	arg0_15:LerpAimWeight(0, 1, arg0_15.config.fade_in, function()
		arg0_15:Emit(Dorm3dAimIKView.BIND_DRAG_AREA, arg0_15.dragComp)
		arg0_15:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, true)

		arg0_15.inputEnabled = true
		arg0_15.triggerAction = System.Action(function()
			arg0_15:Emit(Dorm3dRoomTemplateScene.TRIGGER_TIMELINE_PLAYER_EVENT, {
				intParameter = 1919810,
				stringParameter = "TimelineSelect",
				floatParameter = 0
			})
			arg0_15:ExitTimelineAimIKStatus()
		end)

		arg0_15.dragComp:RegisterOnTargetReachBoundary(arg0_15.triggerAction)
	end)
end

function var0_0.ExitTimelineAimIKStatus(arg0_18, arg1_18)
	if arg0_18.statusMode ~= "timeline" then
		return
	end

	warning("exitaimikstatus")

	arg0_18.inStatus = false
	arg0_18.inputEnabled = false

	arg0_18:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, false)
	arg0_18:UnregisterTrigger()
	arg0_18:FadeOutAimIK(function()
		arg0_18:FinishExitTimelineAimIKStatus()

		arg0_18.statusMode = nil
	end, arg1_18)
end

function var0_0.FadeOutAimIK(arg0_20, arg1_20, arg2_20)
	if arg2_20 then
		arg0_20:InvalidateExitProcess()
		arg0_20:StopWeightLerp()

		arg0_20.headAimIKComp.weight = 0
		arg0_20.stickAimComp.weight = 0

		existCall(arg1_20)
	else
		if not arg0_20.cachedDampTime then
			arg0_20.cachedDampTime = {
				arg0_20.headAimIKComp.DampTime,
				arg0_20.stickAimComp.rotateDampTime,
				arg0_20.stickAimComp.followDampTime
			}
		end

		local var0_20 = arg0_20.headAimIKComp.weight

		arg0_20:InvalidateExitProcess()

		arg0_20.inExitProcessing = true

		local var1_20 = arg0_20.exitProcessToken

		arg0_20:SetDampTime({
			0,
			0,
			0
		})
		arg0_20:LerpAimWeight(var0_20, 0, arg0_20.config.fade_out, function()
			if not arg0_20:IsExitProcessValid(var1_20) then
				return
			end

			arg0_20.inExitProcessing = false

			existCall(arg1_20)
		end)
	end
end

function var0_0.ForceExitTimelineAimIKStatus(arg0_22)
	if arg0_22.statusMode ~= "timeline" or not arg0_22.inStatus and not arg0_22.inExitProcessing then
		return
	end

	arg0_22:ExitTimelineAimIKStatus(true)
end

function var0_0.FinishExitTimelineAimIKStatus(arg0_23)
	arg0_23:StopWeightLerp()

	if arg0_23.cachedDampTime then
		arg0_23:SetDampTime(arg0_23.cachedDampTime)
	end

	if arg0_23.headAimIKComp then
		arg0_23.headAimIKComp.weight = 0
	end

	if arg0_23.stickAimComp then
		arg0_23.stickAimComp.weight = 0

		if arg0_23.hasAimIKBinding then
			arg0_23.stickAimComp.bindTransform = arg0_23.cachedBindTransform
		end
	end

	if not IsNil(arg0_23.configRoot) then
		setActive(arg0_23.configRoot, false)
	end

	arg0_23.cachedDampTime = nil
	arg0_23.cachedBindTransform = nil
	arg0_23.hasAimIKBinding = false
end

function var0_0.InitAimIKComponents(arg0_24, arg1_24, arg2_24, arg3_24)
	assert(not IsNil(arg2_24), "AimIK character not found")
	assert(not IsNil(arg3_24), "AimIK item not found: " .. tostring(arg1_24.item_path))
	assert(type(arg1_24.fade_in) == "number" and arg1_24.fade_in >= 0, "Invalid AimIK fade_in")
	assert(type(arg1_24.fade_out) == "number" and arg1_24.fade_out >= 0, "Invalid AimIK fade_out")

	local var0_24 = arg2_24:Find("AimIKLayers/" .. arg1_24.layer_config)

	assert(not IsNil(var0_24), "AimIK config root not found: " .. arg1_24.layer_config)

	local var1_24 = var0_24:Find("plane")
	local var2_24 = var0_24:Find("headAim")
	local var3_24 = var0_24:Find("stickAim")

	assert(not IsNil(var1_24) and not IsNil(var2_24) and not IsNil(var3_24), "AimIK layer nodes missing")

	local var4_24 = var1_24:GetComponent(typeof(CanvasRectDragTarget))
	local var5_24 = var2_24:GetComponent(typeof(HeadAimIKHotfix))
	local var6_24 = var3_24:GetComponent(typeof(StickAim))

	assert(not IsNil(var4_24) and not IsNil(var5_24) and not IsNil(var6_24), "AimIK layer components missing")
	assert(not IsNil(var4_24.target), "AimIK drag target missing")

	arg0_24.config, arg0_24.character, arg0_24.configRoot = arg1_24, arg2_24, var0_24
	arg0_24.dragGo, arg0_24.dragComp = var1_24, var4_24
	arg0_24.headAimIKGo, arg0_24.headAimIKComp = var2_24, var5_24
	arg0_24.stickAimGo, arg0_24.stickAimComp = var3_24, var6_24
	arg0_24.stickSceneGo = arg3_24.gameObject
	arg0_24.cachedBindTransform = var6_24.bindTransform
	arg0_24.hasAimIKBinding = true
	var6_24.bindTransform = arg3_24
end

function var0_0.UnregisterTrigger(arg0_25)
	if not arg0_25.triggerAction or not arg0_25.dragComp then
		return
	end

	if arg0_25.statusMode == "touch" then
		arg0_25.dragComp:UnregisterOnDragOutOfUI(arg0_25.triggerAction)
	else
		arg0_25.dragComp:UnregisterOnTargetReachBoundary(arg0_25.triggerAction)
	end

	arg0_25.triggerAction = nil
end

function var0_0.IsTouchProcessValid(arg0_26, arg1_26)
	return arg0_26.statusMode == "touch" and arg0_26.touchProcessToken == arg1_26
end

function var0_0.EnterTouchAimIKStatus(arg0_27, arg1_27)
	if arg0_27.statusMode or arg0_27.inExitProcessing then
		return
	end

	local var0_27 = pg.dorm3d_aim_ik_touch[arg1_27]

	assert(var0_27, "Missing dorm3d_aim_ik_touch config: " .. tostring(arg1_27))

	local var1_27 = arg0_27:GetCurrentLadyEnv()

	assert(var1_27, "Touch AimIK character not found")
	assert(arg0_27:GetApartment():GetConfigID() == var0_27.character_id, "Touch AimIK character mismatch")
	assert(var1_27.skinId == var0_27.skin_id, "Touch AimIK skin mismatch")
	assert(type(var0_27.item_path) == "string" and var0_27.item_path ~= "", "Touch AimIK item_path is empty")
	assert(pg.dorm3d_dialogue_group[var0_27.trigger_talk], "Touch AimIK feedback dialogue missing")

	local var2_27 = arg0_27:GetSceneItem(var0_27.item_path)

	arg0_27:InitAimIKComponents(var0_27, var1_27.lady, var2_27)

	local var3_27 = arg0_27:GetIKPointByName(var0_27.character_position)

	assert(not IsNil(var3_27) and not IsNil(var3_27:Find("StayPoint")), "Touch AimIK StayPoint missing")

	local var4_27 = arg0_27:GetCameraRoot():Find(var0_27.camera)

	assert(not IsNil(var4_27), "Touch AimIK camera missing: " .. var0_27.camera)

	arg0_27.statusMode, arg0_27.touchState, arg0_27.inStatus = "touch", "entering", true
	arg0_27.touchProcessToken = arg0_27.touchProcessToken + 1

	local var5_27 = arg0_27.touchProcessToken

	arg0_27.ladyEnv = var1_27
	arg0_27.mainCamera = arg0_27:GetMainCameraTF():GetComponent(typeof(Camera))
	arg0_27.touchExitRequested = false
	arg0_27.touchExitCallbacks = {}

	arg0_27:Emit(RoomIKSystem.ENTER_AIMIK_IK_MODE, function()
		if not arg0_27:IsTouchProcessValid(var5_27) then
			return
		end

		arg0_27:Emit(Dorm3dRoomScene.EXTRA_SET_UI, function()
			if not arg0_27:IsTouchProcessValid(var5_27) then
				return
			end

			arg0_27:ResetTouchLady()
			arg0_27:Emit(Dorm3dRoomTemplateScene.EXTRA_ACTIVE_CAMERA_BY_NAME, var0_27.camera)

			local var0_29 = var4_27:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

			if var0_29 then
				arg0_27:Emit(Dorm3dRoomTemplateScene.EXTRA_REGISTER_ORBITS, var0_29)
			end

			arg0_27:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_SCENE_ANIM, var0_27.enter_scene_anim)
			arg0_27:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_EXTRA_ITEM, var1_27, var0_27.enter_extra_item)
			arg0_27:Emit(Dorm3dRoomTemplateScene.EXTRA_HIDE_SCENE_ITEM, var0_27.hide_scene_item)

			arg0_27.touchItemPosition, arg0_27.touchItemRotation = var2_27.localPosition, var2_27.localRotation

			setActive(var1_27.ladyCollider, false)
			_.each(var1_27.ladyTouchColliders, function(arg0_30)
				setActive(arg0_30, false)
			end)

			arg0_27.touchState = "recovering"

			if arg0_27.touchExitRequested then
				arg0_27:ExitTouchAimIKStatus(true)
			else
				arg0_27:EnableTouchAimIK(var5_27)
			end
		end, "aimik")
	end)
end

function var0_0.ResetTouchLady(arg0_31)
	local var0_31 = arg0_31:GetIKPointByName(arg0_31.config.character_position):Find("StayPoint")

	arg0_31.ladyEnv:SetPosition(var0_31.position)
	arg0_31.ladyEnv:SetRotation(var0_31.rotation)
	arg0_31.ladyEnv:PlaySingleAction(arg0_31.config.character_action)
end

function var0_0.ResetTouchItem(arg0_32)
	if arg0_32.touchItemPosition and not IsNil(arg0_32.stickSceneGo) then
		arg0_32.stickSceneGo.transform.localPosition = arg0_32.touchItemPosition
		arg0_32.stickSceneGo.transform.localRotation = arg0_32.touchItemRotation
	end
end

function var0_0.EnableTouchAimIK(arg0_33, arg1_33)
	if not arg0_33:IsTouchProcessValid(arg1_33) then
		return
	end

	if arg0_33.cachedDampTime then
		arg0_33:SetDampTime(arg0_33.cachedDampTime)

		arg0_33.cachedDampTime = nil
	end

	arg0_33.headAimIKComp.weight, arg0_33.stickAimComp.weight = 0, 0

	setActive(arg0_33.configRoot, false)
	setActive(arg0_33.configRoot, true)
	arg0_33:Emit(Dorm3dAimIKView.BIND_DRAG_AREA, arg0_33.dragComp)
	arg0_33:LerpAimWeight(0, 1, arg0_33.config.fade_in, function()
		if not arg0_33:IsTouchProcessValid(arg1_33) then
			return
		end

		arg0_33.touchState, arg0_33.inputEnabled = "active", true
		arg0_33.triggerAction = System.Action(function()
			arg0_33:TriggerTouchFeedback()
		end)

		arg0_33.dragComp:RegisterOnDragOutOfUI(arg0_33.triggerAction)
		arg0_33:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, true, true)
	end)
end

function var0_0.TriggerTouchFeedback(arg0_36)
	if arg0_36.touchState ~= "active" or not arg0_36.inputEnabled then
		return
	end

	local var0_36 = arg0_36.touchProcessToken

	arg0_36.touchState, arg0_36.inputEnabled = "feedback", false

	arg0_36.dragComp:OnPointerUp(nil)
	arg0_36:UnregisterTrigger()
	arg0_36:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, false)
	arg0_36:FadeOutAimIK(function()
		if not arg0_36:IsTouchProcessValid(var0_36) then
			return
		end

		setActive(arg0_36.configRoot, false)
		arg0_36:ResetTouchItem()
		arg0_36:ResetTouchLady()

		arg0_36.touchState = "story"

		arg0_36:Emit(Dorm3dRoomScene.EXTRA_DO_TALK, arg0_36.config.trigger_talk, function()
			if not arg0_36:IsTouchProcessValid(var0_36) then
				return
			end

			arg0_36.touchState = "recovering"

			if arg0_36.touchExitRequested then
				arg0_36:ExitTouchAimIKStatus(true)
			else
				arg0_36:ResetTouchLady()
				arg0_36:ResetTouchItem()
				arg0_36:Emit(Dorm3dRoomTemplateScene.EXTRA_ACTIVE_CAMERA_BY_NAME, arg0_36.config.camera)
				arg0_36:EnableTouchAimIK(var0_36)
			end
		end)
	end)
end

function var0_0.ExitTouchAimIKStatus(arg0_39, arg1_39, arg2_39)
	if arg0_39.statusMode ~= "touch" then
		existCall(arg2_39)

		return
	end

	if arg2_39 then
		table.insert(arg0_39.touchExitCallbacks, arg2_39)
	end

	arg0_39.touchExitRequested = true

	if arg0_39.touchState == "entering" or arg0_39.touchState == "story" or arg0_39.touchState == "exiting" then
		return
	end

	arg0_39.touchState, arg0_39.inputEnabled, arg0_39.inStatus = "exiting", false, false

	local var0_39 = arg0_39.touchProcessToken

	arg0_39.dragComp:OnPointerUp(nil)
	arg0_39:UnregisterTrigger()
	arg0_39:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, false)
	arg0_39:FadeOutAimIK(function()
		if not arg0_39:IsTouchProcessValid(var0_39) then
			return
		end

		arg0_39:ResetTouchItem()
		arg0_39:FinishExitTimelineAimIKStatus()
		arg0_39:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_SCENE_ITEM_ANIMATORS)
		arg0_39:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_CHARACTER_EXTRA_ITEM)
		arg0_39:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_TEMP_HIDE_SCENE_ITEMS)
		arg0_39:Emit(Dorm3dRoomTemplateScene.EXTRA_REVERT_CAMERA_ORBIT)
		arg0_39:Emit(Dorm3dRoomScene.EXTRA_SET_UI, function()
			if not arg0_39:IsTouchProcessValid(var0_39) then
				return
			end

			arg0_39:Emit(RoomIKSystem.EXIT_AIMIK_IK_MODE, function()
				if not arg0_39:IsTouchProcessValid(var0_39) then
					return
				end

				local var0_42 = arg0_39.touchExitCallbacks

				arg0_39.statusMode, arg0_39.touchState = nil
				arg0_39.touchItemPosition, arg0_39.touchItemRotation = nil
				arg0_39.touchExitCallbacks, arg0_39.touchExitRequested = nil

				for iter0_42, iter1_42 in ipairs(var0_42) do
					iter1_42()
				end
			end)
		end, "back")
	end, arg1_39)
end

function var0_0.InvalidateExitProcess(arg0_43)
	arg0_43.exitProcessToken = (arg0_43.exitProcessToken or 0) + 1
	arg0_43.inExitProcessing = false
end

function var0_0.IsExitProcessValid(arg0_44, arg1_44)
	return arg0_44.inExitProcessing and arg0_44.exitProcessToken == arg1_44
end

function var0_0.OnBeginDrag(arg0_45, arg1_45, arg2_45)
	if not arg0_45.inputEnabled or not arg2_45 then
		return
	end

	arg0_45.dragComp:OnPointerDown(arg2_45)
end

function var0_0.OnDrag(arg0_46, arg1_46, arg2_46)
	if not arg0_46.inputEnabled or not arg2_46 then
		return
	end

	arg0_46.dragComp:OnDrag(arg2_46)
end

function var0_0.OnEndDrag(arg0_47, arg1_47, arg2_47)
	if not arg0_47.inputEnabled then
		return
	end

	arg0_47.dragComp:OnPointerUp(arg2_47)
end

function var0_0.GetTipShowInfo(arg0_48, arg1_48)
	local var0_48 = {}

	if not arg0_48.inputEnabled or IsNil(arg0_48.stickSceneGo) then
		if arg1_48 then
			table.insert(arg1_48, var0_48)
		end

		return var0_48
	end

	local var1_48 = {}

	arg0_48:Emit(Dorm3dRoomTemplateScene.EXTRA_GET_SCREEN_POSITION, var1_48, arg0_48.stickSceneGo.transform.position, arg0_48.mainCamera)
	table.insert(var0_48, {
		pos = var1_48.value
	})

	if arg1_48 then
		table.insert(arg1_48, var0_48)
	end

	return var0_48
end

function var0_0.StopWeightLerp(arg0_49)
	if not arg0_49.weightLerpTweenId then
		return
	end

	if LeanTween.isTweening(arg0_49.weightLerpTweenId) then
		LeanTween.cancel(arg0_49.weightLerpTweenId)
	end

	arg0_49.weightLerpTweenId = nil
end

function var0_0.LerpAimWeight(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	arg0_50:StopWeightLerp()

	local function var0_50(arg0_51)
		arg0_50.headAimIKComp.weight = arg0_51
		arg0_50.stickAimComp.weight = arg0_51
	end

	var0_50(arg1_50)

	if arg3_50 <= 0 then
		var0_50(arg2_50)
		existCall(arg4_50)

		return
	end

	arg0_50.weightLerpTweenId = LeanTween.value(go(arg0_50.configRoot), arg1_50, arg2_50, arg3_50):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_52)
		var0_50(arg0_52)
	end)):setOnComplete(System.Action(function()
		arg0_50.weightLerpTweenId = nil

		var0_50(arg2_50)

		if arg4_50 then
			arg4_50()
		end
	end)).uniqueId
end

function var0_0.SetDampTime(arg0_54, arg1_54)
	arg0_54.headAimIKComp.DampTime = arg1_54[1]
	arg0_54.stickAimComp.rotateDampTime = arg1_54[2]
	arg0_54.stickAimComp.followDampTime = arg1_54[3]
end

return var0_0
