local var0_0 = class("AimIKSystem", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.GET_TIP_SHOW_INFO = "AimIKSystem.GetTipShowInfo"
var0_0.ON_BEGIN_DRAG = "AimIKSystem.OnBeginDrag"
var0_0.ON_DRAG = "AimIKSystem.OnDrag"
var0_0.ON_END_DRAG = "AimIKSystem.OnEndDrag"
var0_0.ENTER_TIMELINE_AIMIK_STATUS = "AimIKSystem.EnterTimelineAimIKStatus"
var0_0.EXIT_TIMELINE_AIMIK_STATUS = "AimIKSystem.ExitTimelineAimIKStatus"

function var0_0.OnInit(arg0_1)
	arg0_1.inStatus = false
	arg0_1.inExitProcessing = false
	arg0_1.exitProcessToken = 0
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
end

function var0_0.OnHandleNotification(arg0_9, arg1_9, arg2_9)
	if arg1_9 == Dorm3dRoomTemplateScene.TIMELINE_END then
		if not arg0_9.inStatus and not arg0_9.inExitProcessing then
			return
		end

		arg0_9:ForceExitTimelineAimIKStatus()
	end
end

function var0_0.GetInterests()
	return {
		Dorm3dRoomTemplateScene.TIMELINE_END
	}
end

function var0_0.OnDispose(arg0_11)
	arg0_11:InvalidateExitProcess()
	arg0_11:StopWeightLerp()

	if arg0_11.triggerAction and arg0_11.dragComp then
		arg0_11.dragComp:UnregisterOnTargetReachBoundary(arg0_11.triggerAction)

		arg0_11.triggerAction = nil
	end
end

function var0_0.EnterTimelineAimIKStatus(arg0_12, arg1_12)
	warning("enteraimikstatus")

	if arg0_12.inStatus then
		warning("重复进入TimelineAimIK状态")

		return
	end

	arg0_12.inStatus = true
	arg0_12.config = pg.dorm3d_aim_ik[arg1_12]

	assert(arg0_12.config, "AimIK config is nil for id: " .. tostring(arg1_12))

	arg0_12.character = Dorm3dHxHelper.GetTimelineMainCharacter()

	assert(arg0_12.character, "Timeline main character not found")

	arg0_12.configRoot = arg0_12.character:Find("AimIKLayers/" .. arg0_12.config.layer_config)

	assert(arg0_12.configRoot, "AimIK config root not found in character")

	arg0_12.dragGo = arg0_12.configRoot:Find("plane")
	arg0_12.dragComp = arg0_12.dragGo:GetComponent(typeof(CanvasRectDragTarget))
	arg0_12.headAimIKGo = arg0_12.configRoot:Find("headAim")
	arg0_12.headAimIKComp = arg0_12.headAimIKGo:GetComponent(typeof(HeadAimIKHotfix))
	arg0_12.stickAimGo = arg0_12.configRoot:Find("stickAim")
	arg0_12.stickAimComp = arg0_12.stickAimGo:GetComponent(typeof(StickAim))
	arg0_12.stickSceneGo = GameObject.Find(arg0_12.config.item_path)
	arg0_12.stickAimComp.bindTransform = arg0_12.stickSceneGo.transform
	arg0_12.mainCamera = Camera.main
	arg0_12.headAimIKComp.weight = 0
	arg0_12.stickAimComp.weight = 0

	setActive(arg0_12.configRoot, true)
	arg0_12:LerpAimWeight(0, 1, arg0_12.config.fade_in, function()
		arg0_12:Emit(Dorm3dAimIKView.BIND_DRAG_AREA, arg0_12.dragComp)
		arg0_12:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, true)

		arg0_12.triggerAction = System.Action(function()
			arg0_12:Emit(Dorm3dRoomTemplateScene.TRIGGER_TIMELINE_PLAYER_EVENT, {
				intParameter = 1919810,
				stringParameter = "TimelineSelect",
				floatParameter = 0
			})
			arg0_12:ExitTimelineAimIKStatus()
		end)

		arg0_12.dragComp:RegisterOnTargetReachBoundary(arg0_12.triggerAction)
	end)
end

function var0_0.ExitTimelineAimIKStatus(arg0_15, arg1_15)
	warning("exitaimikstatus")

	arg0_15.inStatus = false

	arg0_15:Emit(Dorm3dAimIKView.SHOW_OR_HIDE, false)

	if arg0_15.triggerAction and arg0_15.dragComp then
		arg0_15.dragComp:UnregisterOnTargetReachBoundary(arg0_15.triggerAction)

		arg0_15.triggerAction = nil
	end

	if arg1_15 then
		arg0_15:InvalidateExitProcess()
		arg0_15:FinishExitTimelineAimIKStatus()
	else
		arg0_15.cachedDampTime = {
			arg0_15.headAimIKComp.DampTime,
			arg0_15.stickAimComp.rotateDampTime,
			arg0_15.stickAimComp.followDampTime
		}
		arg0_15.maxDampTime = math.max(arg0_15.cachedDampTime[1], arg0_15.cachedDampTime[2], arg0_15.cachedDampTime[3])

		local var0_15 = arg0_15.headAimIKComp.weight

		arg0_15:InvalidateExitProcess()

		arg0_15.inExitProcessing = true

		local var1_15 = arg0_15.exitProcessToken

		seriesAsync({
			function(arg0_16)
				if not arg0_15:IsExitProcessValid(var1_15) then
					return
				end

				arg0_15:LerpAimWeight(var0_15, var0_15, arg0_15.maxDampTime, function()
					if not arg0_15:IsExitProcessValid(var1_15) then
						return
					end

					arg0_16()
				end)
			end,
			function(arg0_18)
				if not arg0_15:IsExitProcessValid(var1_15) then
					return
				end

				arg0_15:SetDampTime({
					0,
					0,
					0
				})

				local var0_18 = arg0_15.headAimIKComp and arg0_15.headAimIKComp.weight or 1

				arg0_15:LerpAimWeight(var0_18, 0, arg0_15.config.fade_out, function()
					if not arg0_15:IsExitProcessValid(var1_15) then
						return
					end

					arg0_18()
				end)
			end,
			function(arg0_20)
				if not arg0_15:IsExitProcessValid(var1_15) then
					return
				end

				arg0_15:FinishExitTimelineAimIKStatus()
				arg0_20()
			end
		}, function()
			if arg0_15.exitProcessToken ~= var1_15 then
				return
			end

			arg0_15.inExitProcessing = false
		end)
	end
end

function var0_0.ForceExitTimelineAimIKStatus(arg0_22)
	if not arg0_22.inStatus and not arg0_22.inExitProcessing then
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
	end

	if arg0_23.configRoot then
		setActive(arg0_23.configRoot, false)
	end

	arg0_23.cachedDampTime = nil
	arg0_23.maxDampTime = nil
end

function var0_0.InvalidateExitProcess(arg0_24)
	arg0_24.exitProcessToken = (arg0_24.exitProcessToken or 0) + 1
	arg0_24.inExitProcessing = false
end

function var0_0.IsExitProcessValid(arg0_25, arg1_25)
	return arg0_25.inExitProcessing and arg0_25.exitProcessToken == arg1_25
end

function var0_0.OnBeginDrag(arg0_26, arg1_26, arg2_26)
	arg0_26.dragComp:OnPointerDown(arg2_26)
end

function var0_0.OnDrag(arg0_27, arg1_27, arg2_27)
	arg0_27.dragComp:OnDrag(arg2_27)
end

function var0_0.OnEndDrag(arg0_28, arg1_28, arg2_28)
	arg0_28.dragComp:OnPointerUp(arg2_28)
end

function var0_0.GetTipShowInfo(arg0_29, arg1_29)
	local var0_29 = {}

	table.insert(var0_29, {
		pos = arg0_29:Func("GetScreenPosition", arg0_29.stickSceneGo.transform.position, arg0_29.mainCamera)
	})

	if arg1_29 then
		table.insert(arg1_29, var0_29)
	end

	return var0_29
end

function var0_0.StopWeightLerp(arg0_30)
	if not arg0_30.weightLerpTweenId then
		return
	end

	if LeanTween.isTweening(arg0_30.weightLerpTweenId) then
		LeanTween.cancel(arg0_30.weightLerpTweenId)
	end

	arg0_30.weightLerpTweenId = nil
end

function var0_0.LerpAimWeight(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	arg0_31:StopWeightLerp()

	local function var0_31(arg0_32)
		arg0_31.headAimIKComp.weight = arg0_32
		arg0_31.stickAimComp.weight = arg0_32
	end

	var0_31(arg1_31)

	arg0_31.weightLerpTweenId = LeanTween.value(go(arg0_31.configRoot), arg1_31, arg2_31, arg3_31):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_33)
		var0_31(arg0_33)
	end)):setOnComplete(System.Action(function()
		arg0_31.weightLerpTweenId = nil

		var0_31(arg2_31)

		if arg4_31 then
			arg4_31()
		end
	end)).uniqueId
end

function var0_0.SetDampTime(arg0_35, arg1_35)
	arg0_35.headAimIKComp.DampTime = arg1_35[1]
	arg0_35.stickAimComp.rotateDampTime = arg1_35[2]
	arg0_35.stickAimComp.followDampTime = arg1_35[3]
end

return var0_0
