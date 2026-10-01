local var0_0 = class("RoomIKSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.ENTER_IK = "RoomIKSystem.ENTER_IK"
var0_0.REPLACE_IK_STATUS = "RoomIKSystem.REPLACE_IK_STATUS"
var0_0.EXIT_IK_WITH_RETURN = "RoomIKSystem.EXIT_IK_WITH_RETURN"
var0_0.ENTER_STOCKING_IK_MODE = "RoomIKSystem.ENTER_STOCKING_IK_MODE"
var0_0.EXIT_STOCKING_IK_MODE = "RoomIKSystem.EXIT_STOCKING_IK_MODE"
var0_0.ON_CONTROL_POINTER_DOWN = "RoomIKSystem.ON_CONTROL_POINTER_DOWN"
var0_0.ON_CONTROL_POINTER_UP = "RoomIKSystem.ON_CONTROL_POINTER_UP"
var0_0.ON_CONTROL_BEGIN_DRAG = "RoomIKSystem.ON_CONTROL_BEGIN_DRAG"
var0_0.ON_CONTROL_DRAG = "RoomIKSystem.ON_CONTROL_DRAG"
var0_0.ON_CONTROL_END_DRAG = "RoomIKSystem.ON_CONTROL_END_DRAG"
var0_0.ON_IK_STATUS_CHANGED = "RoomIKSystem.ON_IK_STATUS_CHANGED"
var0_0.ON_IK_LAYER_ACTION = "RoomIKSystem.ON_IK_LAYER_ACTION"
var0_0.SET_IK_TIMELINE_STATUS = "RoomIKSystem.SET_IK_TIMELINE_STATUS"
var0_0.EXIT_IK_TIMELINE_STATUS = "RoomIKSystem.EXIT_IK_TIMELINE_STATUS"
var0_0.CYCLE_IK_CAMERA_GROUP = "RoomIKSystem.CYCLE_IK_CAMERA_GROUP"
var0_0.SET_IK_SPECIAL_CALL = "RoomIKSystem.SET_IK_SPECIAL_CALL"
var0_0.CONSUME_IK_SPECIAL_CALL = "RoomIKSystem.CONSUME_IK_SPECIAL_CALL"
var0_0.GET_IK_BLOCK = "RoomIKSystem.GET_IK_BLOCK"
var0_0.SET_IK_BLOCK = "RoomIKSystem.SET_IK_BLOCK"
var0_0.RESET_IK_TIP_TIMER = "RoomIKSystem.RESET_IK_TIP_TIMER"
var0_0.SET_IK_SWITCH_SKIN_ID = "RoomIKSystem.SET_IK_SWITCH_SKIN_ID"
var0_0.SWITCH_IK_SKIN = "RoomIKSystem.SWITCH_IK_SKIN"
var0_0.PLAY_TOUCH_IK_MOVE = "RoomIKSystem.PLAY_TOUCH_IK_MOVE"
var0_0.IK_STATUS_DELTA = 0.5
var0_0.IK_TIP_WAIT_TIME = 5
var0_0.IK_STATUS = {
	RELEASE = 3,
	BEGIN = 1,
	TRIGGER = 4,
	DRAG = 2
}
var0_0.MODE_STATE = {
	IDLE = "idle",
	REPLACING = "replacing",
	ENTERING = "entering",
	EXITING = "exiting",
	ACTIVE = "active"
}

function var0_0.OnInit(arg0_1)
	arg0_1.modeState = var0_0.MODE_STATE.IDLE
	arg0_1.transitionSerial = 0
	arg0_1.pendingExitCallbacks = {}
	arg0_1.session = RoomIKSession.New()
	arg0_1.sessionBuilder = RoomIKSessionBuilder.New(arg0_1)
	arg0_1.driver = RoomIKDriver.New()
	arg0_1.input = RoomIKInput.New(arg0_1)
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.ENTER_IK, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_2:EnterIK(arg1_3, arg2_3, arg3_3)
	end)
	arg0_2:Bind(var0_0.REPLACE_IK_STATUS, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_2:ReplaceIKStatus(arg1_4, arg2_4, arg3_4)
	end)
	arg0_2:Bind(var0_0.EXIT_IK_WITH_RETURN, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_2:ExitIKWithReturn(arg1_5, arg2_5, arg3_5)
	end)
	arg0_2:Bind(var0_0.ENTER_STOCKING_IK_MODE, function(arg0_6, arg1_6)
		arg0_2:EnterStockingIKMode(arg1_6)
	end)
	arg0_2:Bind(var0_0.EXIT_STOCKING_IK_MODE, function(arg0_7, arg1_7)
		arg0_2:ExitStockingIKMode(arg1_7)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_POINTER_DOWN, function(arg0_8, arg1_8)
		arg0_2.input:OnControlPointerDown(arg1_8)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_POINTER_UP, function(arg0_9, arg1_9)
		arg0_2.input:OnControlPointerUp(arg1_9)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_BEGIN_DRAG, function(arg0_10, arg1_10)
		arg0_2.input:OnControlBeginDrag(arg1_10)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_DRAG, function(arg0_11, arg1_11, arg2_11)
		arg0_2.input:OnControlDrag(arg1_11, arg2_11)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_END_DRAG, function(arg0_12, arg1_12)
		arg0_2.input:OnControlEndDrag(arg1_12)
	end)
	arg0_2:Bind(var0_0.SET_IK_TIMELINE_STATUS, function(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
		arg0_2:SetIKTimelineStatus(arg1_13, arg2_13, arg3_13, arg4_13)
	end)
	arg0_2:Bind(var0_0.EXIT_IK_TIMELINE_STATUS, function(arg0_14, arg1_14)
		arg0_2:ExitIKTimelineStatus(arg1_14)
	end)
	arg0_2:Bind(var0_0.CYCLE_IK_CAMERA_GROUP, function()
		arg0_2:CycleIKCameraGroup()
	end)
	arg0_2:Bind(var0_0.SET_IK_SPECIAL_CALL, function(arg0_16, arg1_16)
		arg0_2.session.ikSpecialCall = arg1_16
	end)
	arg0_2:Bind(var0_0.CONSUME_IK_SPECIAL_CALL, function(arg0_17, arg1_17)
		local var0_17 = arg0_2:ConsumeIKSpecialCall()

		if arg1_17 then
			arg1_17.consumed = var0_17
		end
	end)
	arg0_2:Bind(var0_0.GET_IK_BLOCK, function(arg0_18, arg1_18)
		if arg1_18 then
			arg1_18.blockIK = arg0_2.session:IsBlocked()
		end
	end)
	arg0_2:Bind(var0_0.SET_IK_BLOCK, function(arg0_19, arg1_19)
		arg0_2.session:SetLegacyBlock(arg1_19)
	end)
	arg0_2:Bind(var0_0.RESET_IK_TIP_TIMER, function()
		arg0_2:ResetIKTipTimer()
	end)
	arg0_2:Bind(var0_0.SET_IK_SWITCH_SKIN_ID, function(arg0_21, arg1_21)
		arg0_2:SetIKSwitchSkinId(arg1_21)
	end)
	arg0_2:Bind(var0_0.SWITCH_IK_SKIN, function(arg0_22, arg1_22, arg2_22, arg3_22)
		arg0_2:SwitchIKSkin(arg1_22, arg2_22, arg3_22)
	end)
	arg0_2:Bind(var0_0.PLAY_TOUCH_IK_MOVE, function(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23, arg5_23)
		arg0_2:PlayTouchIKMove(arg1_23, arg2_23, arg3_23, arg4_23, arg5_23)
	end)
end

function var0_0.OnUpdate(arg0_24)
	arg0_24:UpdateIKTarget()
end

function var0_0.OnDispose(arg0_25)
	arg0_25.transitionSerial = arg0_25.transitionSerial + 1

	local var0_25 = arg0_25:GetCurrentLadyEnv()

	if arg0_25:IsInIKTimelineMode() then
		arg0_25:ClearIKTimelineRuntime()
	elseif arg0_25.session.active and var0_25 then
		arg0_25:ClearIKStatusRuntime(var0_25)
	else
		arg0_25:RestoreIKTimelineColliders()
		arg0_25:CancelControlInput()
		arg0_25.driver:Detach()
	end

	arg0_25:ReleaseIKBlock()

	arg0_25.modeState = var0_0.MODE_STATE.IDLE

	if arg0_25.input then
		arg0_25.input:Dispose()

		arg0_25.input = nil
	end

	arg0_25.pendingExitCallbacks = {}

	arg0_25.session:Invalidate()
end

function var0_0.WrapCallbackOnce(arg0_26, arg1_26)
	if not arg1_26 then
		return nil
	end

	local var0_26 = false

	return function(...)
		if var0_26 then
			return
		end

		var0_26 = true

		existCall(arg1_26, ...)
	end
end

function var0_0.FlushExitCallbacks(arg0_28, arg1_28)
	existCall(arg1_28)

	local var0_28 = arg0_28.pendingExitCallbacks

	arg0_28.pendingExitCallbacks = {}

	for iter0_28, iter1_28 in ipairs(var0_28) do
		existCall(iter1_28)
	end
end

function var0_0.ResolveIKConfig(arg0_29, arg1_29, arg2_29)
	warning("switchIkstatus", arg2_29)

	local var0_29 = pg.dorm3d_ik_status[arg2_29]

	assert(var0_29, "Missing dorm3d_ik_status config: " .. tostring(arg2_29))

	local function var1_29()
		if var0_29.skin_id ~= arg1_29.skinId then
			local var0_30 = pg.dorm3d_ik_status.get_id_list_by_base[var0_29.base]
			local var1_30 = _.detect(var0_30, function(arg0_31)
				return pg.dorm3d_ik_status[arg0_31].skin_id == arg1_29.skinId
			end)

			assert(var1_30, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_29.skinId, arg2_29))

			var0_29 = pg.dorm3d_ik_status[var1_30]
		end
	end

	if type(var0_29.skin_id) == "table" then
		if not table.contains(var0_29.skin_id, arg1_29.skinId) then
			var1_29()
		end
	else
		var1_29()
	end

	return var0_29
end

function var0_0.BeginIKTransition(arg0_32, arg1_32)
	arg0_32.transitionSerial = arg0_32.transitionSerial + 1
	arg0_32.modeState = arg1_32

	return arg0_32.transitionSerial
end

function var0_0.IsIKTransitionActive(arg0_33, arg1_33, arg2_33)
	return arg0_33.transitionSerial == arg1_33 and arg0_33.modeState == arg2_33
end

function var0_0.AcquireIKBlock(arg0_34)
	if arg0_34.session.uiBlockHeld then
		return
	end

	arg0_34.session.uiBlockHeld = true

	arg0_34:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
end

function var0_0.ReleaseIKBlock(arg0_35)
	if not arg0_35.session.uiBlockHeld then
		return
	end

	arg0_35.session.uiBlockHeld = false

	arg0_35:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
end

function var0_0.RunIKStatusTransition(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36)
	arg6_36 = arg6_36 or {}
	arg5_36 = arg0_36:WrapCallbackOnce(arg5_36)

	local var0_36 = {}

	table.insert(var0_36, function(arg0_37)
		if not arg0_36:IsIKTransitionActive(arg4_36, arg3_36) then
			return
		end

		arg0_36:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, arg1_36, "inIK", true)
		arg0_36:AcquireIKBlock()

		local var0_37 = arg2_36.camera_group

		arg0_36:Emit(Dorm3dIKView.SET_CAMERA_BUTTON_ACTIVE, #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_37] > 1)
		arg0_36:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, true)
		arg0_37()
	end)

	if arg0_36:GetUIState() ~= "ik" then
		table.insert(var0_36, function(arg0_38)
			if not arg0_36:IsIKTransitionActive(arg4_36, arg3_36) then
				return
			end

			arg0_36:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_38, "ik")
		end)
	end

	table.insert(var0_36, function(arg0_39)
		if not arg0_36:IsIKTransitionActive(arg4_36, arg3_36) then
			return
		end

		if arg3_36 == var0_0.MODE_STATE.REPLACING then
			arg0_36:ClearIKStatusRuntime(arg1_36, arg6_36)

			arg0_36.session.currentIkConfig = arg2_36
		end

		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_36:SetIKStatus(arg1_36, arg2_36, arg0_39, arg6_36, arg4_36, arg3_36, arg7_36)
	end)
	table.insert(var0_36, function(arg0_40)
		if not arg0_36:IsIKTransitionActive(arg4_36, arg3_36) then
			return
		end

		arg0_36:ReleaseIKBlock()
		arg0_40()
	end)
	seriesAsync(var0_36, function()
		if not arg0_36:IsIKTransitionActive(arg4_36, arg3_36) then
			return
		end

		arg0_36.modeState = var0_0.MODE_STATE.ACTIVE

		existCall(arg5_36)
	end)
end

function var0_0.EnterIK(arg0_42, arg1_42, arg2_42, arg3_42)
	arg2_42 = arg0_42:WrapCallbackOnce(arg2_42)

	assert(arg0_42.modeState == var0_0.MODE_STATE.IDLE, string.format("Cannot enter IK from state: %s", tostring(arg0_42.modeState)))
	assert(not arg0_42:IsInIKTimelineMode(), "Cannot enter IK during timeline IK")

	local var0_42 = arg0_42:GetCurrentLadyEnv()

	assert(var0_42, "Missing LadyEnv when enter IK")

	local var1_42 = arg0_42:ResolveIKConfig(var0_42, arg1_42)
	local var2_42 = arg0_42.sessionBuilder:BuildNormal(var0_42, var1_42, function(arg0_43)
		arg0_42:OnNormalIKLayerAction(arg0_43)
	end)

	arg0_42:ValidateIKSpec(var2_42)

	local var3_42 = arg0_42:BeginIKTransition(var0_0.MODE_STATE.ENTERING)

	arg0_42.session.currentIkConfig = var1_42

	arg0_42:RunIKStatusTransition(var0_42, var1_42, var0_0.MODE_STATE.ENTERING, var3_42, arg2_42, arg3_42, var2_42)
end

function var0_0.ReplaceIKStatus(arg0_44, arg1_44, arg2_44, arg3_44)
	arg2_44 = arg0_44:WrapCallbackOnce(arg2_44)

	assert(arg0_44.modeState == var0_0.MODE_STATE.ACTIVE, string.format("Cannot replace IK status from state: %s", tostring(arg0_44.modeState)))

	local var0_44 = arg0_44:GetCurrentLadyEnv()

	assert(var0_44, "Missing LadyEnv when replace IK status")

	local var1_44 = arg0_44:ResolveIKConfig(var0_44, arg1_44)
	local var2_44 = arg0_44.sessionBuilder:BuildNormal(var0_44, var1_44, function(arg0_45)
		arg0_44:OnNormalIKLayerAction(arg0_45)
	end)

	arg0_44:ValidateIKSpec(var2_44)

	local var3_44 = arg0_44:BeginIKTransition(var0_0.MODE_STATE.REPLACING)

	arg0_44.session.currentIkConfig = var1_44

	arg0_44:RunIKStatusTransition(var0_44, var1_44, var0_0.MODE_STATE.REPLACING, var3_44, arg2_44, arg3_44, var2_44)
end

function var0_0.ExitIK(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.session.currentIkConfig

	assert(var0_46, "Missing current IK config")
	arg0_46:ExitIKWithReturn({
		character_position = var0_46.character_position,
		character_action = var0_46.character_action
	}, arg1_46, arg2_46)
end

function var0_0.ExitIKWithReturn(arg0_47, arg1_47, arg2_47, arg3_47)
	arg2_47 = arg0_47:WrapCallbackOnce(arg2_47)

	if arg0_47.modeState == var0_0.MODE_STATE.EXITING then
		if arg2_47 then
			table.insert(arg0_47.pendingExitCallbacks, arg2_47)
		end

		return
	end

	assert(arg0_47.modeState == var0_0.MODE_STATE.ACTIVE, string.format("Cannot exit IK from state: %s", tostring(arg0_47.modeState)))

	arg3_47 = arg3_47 or {}

	local var0_47 = arg0_47:GetCurrentLadyEnv()

	assert(var0_47, "Missing LadyEnv when exit IK")
	assert(arg0_47.session.currentIkConfig, "Missing current IK config when exit IK")
	assert(arg0_47:GetUIState() == "ik")

	arg1_47 = arg0_47:BuildIKReturnInfo(arg1_47)

	local var1_47 = arg0_47:BeginIKTransition(var0_0.MODE_STATE.EXITING)

	seriesAsync({
		function(arg0_48)
			if not arg0_47:IsIKTransitionActive(var1_47, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_47:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, false)
			arg0_47:AcquireIKBlock()
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_48()
		end,
		function(arg0_49)
			if not arg0_47:IsIKTransitionActive(var1_47, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_47:ClearIKRuntime(var0_47, arg3_47)
			arg0_47:ApplyIKReturn(var0_47, arg1_47, arg0_49, var1_47)
		end,
		function(arg0_50)
			if not arg0_47:IsIKTransitionActive(var1_47, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_47:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_50, "back")
		end,
		function(arg0_51)
			if not arg0_47:IsIKTransitionActive(var1_47, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_47:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, var0_47, "inIK", false)
			arg0_47:ReleaseIKBlock()
			arg0_51()
		end
	}, function()
		if not arg0_47:IsIKTransitionActive(var1_47, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_47.modeState = var0_0.MODE_STATE.IDLE

		arg0_47:FlushExitCallbacks(arg2_47)
	end)
end

function var0_0.EnterStockingIKMode(arg0_53, arg1_53)
	local var0_53 = arg0_53:GetCurrentLadyEnv()

	assert(var0_53, "Missing LadyEnv when enter stocking IK mode")
	assert(arg0_53.modeState == var0_0.MODE_STATE.ACTIVE, "Stocking mode requires active IK")
	assert(arg0_53.session.currentIkStatus, "Missing current IK status when enter stocking IK mode")

	arg0_53.session.stockingCachedIkStatus = arg0_53.session.currentIkStatus

	arg0_53:ExitIK(arg1_53, {
		ignoreResetExtraItem = true
	})
end

function var0_0.ExitStockingIKMode(arg0_54, arg1_54)
	local var0_54 = arg0_54:GetCurrentLadyEnv()

	assert(var0_54, "Missing LadyEnv when exit stocking IK mode")
	assert(arg0_54.modeState == var0_0.MODE_STATE.IDLE, "Exit stocking mode requires idle IK")

	local var1_54 = arg0_54.session.stockingCachedIkStatus

	assert(var1_54, "Missing cached IK status when exit stocking IK mode")

	arg0_54.session.stockingCachedIkStatus = nil

	arg0_54:EnterIK(var1_54, arg1_54)
end

function var0_0.GetSession(arg0_55)
	return arg0_55.session
end

function var0_0.CancelControlInput(arg0_56)
	if arg0_56.input then
		arg0_56.input:Cancel()
	end
end

function var0_0.BeginIKBodyDrag(arg0_57, arg1_57, arg2_57)
	if not arg0_57:CanHandleIKInput() then
		return
	end

	if arg0_57.session:IsBlocked() or arg0_57.session.ikHandler then
		return
	end

	arg0_57.driver:BeginDrag(arg1_57, arg2_57)
end

function var0_0.DragIKBody(arg0_58, arg1_58)
	if not arg0_58:CanHandleIKInput() then
		return
	end

	if not arg0_58.session.ikHandler then
		return
	end

	arg0_58.driver:Drag(arg1_58)
end

function var0_0.ReleaseIKBody(arg0_59)
	arg0_59.driver:Release()
end

function var0_0.OnControlPointerDown(arg0_60, arg1_60)
	arg0_60.input:OnControlPointerDown(arg1_60)
end

function var0_0.OnControlPointerUp(arg0_61, arg1_61)
	arg0_61.input:OnControlPointerUp(arg1_61)
end

function var0_0.OnControlBeginDrag(arg0_62, arg1_62)
	arg0_62.input:OnControlBeginDrag(arg1_62)
end

function var0_0.OnControlDrag(arg0_63, arg1_63, arg2_63)
	arg0_63.input:OnControlDrag(arg1_63, arg2_63)
end

function var0_0.OnControlEndDrag(arg0_64, arg1_64)
	arg0_64.input:OnControlEndDrag(arg1_64)
end

function var0_0.GetIKRaycastTargets(arg0_65, arg1_65)
	return arg0_65.input:GetIKRaycastTargets(arg1_65)
end

function var0_0.ResolveBodyTarget(arg0_66, arg1_66)
	return arg0_66.input:ResolveBodyTarget(arg1_66)
end

function var0_0.ResolveTouchTarget(arg0_67, arg1_67)
	return arg0_67.input:ResolveTouchTarget(arg1_67)
end

function var0_0.ResolveTouchSceneItem(arg0_68, arg1_68)
	return arg0_68.input:ResolveTouchSceneItem(arg1_68)
end

function var0_0.IsTransformInHierarchy(arg0_69, arg1_69)
	return RoomIKInput.IsTransformInHierarchy(arg0_69, arg1_69)
end

function var0_0.EmitTouchPress(arg0_70, arg1_70, arg2_70, arg3_70)
	arg0_70.input:EmitTouchPress(arg1_70, arg2_70, arg3_70)
end

function var0_0.OnIKLayerActive(arg0_71, arg1_71)
	arg0_71.session.ikHandler = arg1_71

	local var0_71 = _.detect(arg0_71.session.readyIKLayers or {}, function(arg0_72)
		return arg0_72:GetControllerPath() == arg1_71.ikData:GetControllerPath()
	end)

	if not var0_71 then
		return
	end

	arg0_71.session:AcquireBlock("drag")
	arg0_71:EnableIKLayer(var0_71)

	arg0_71.session.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_71:Emit(var0_0.ON_IK_STATUS_CHANGED, var0_71:GetConfigID(), var0_0.IK_STATUS.BEGIN)
end

function var0_0.OnIKLayerDrag(arg0_73, arg1_73)
	arg0_73.session.ikHandler = arg1_73

	arg0_73:ResetIKTipTimer()
end

function var0_0.OnIKLayerDeactive(arg0_74, arg1_74, arg2_74)
	local var0_74 = _.detect(arg0_74.session.readyIKLayers or {}, function(arg0_75)
		return arg0_75:GetControllerPath() == arg1_74.ikData:GetControllerPath()
	end)

	if not var0_74 then
		return
	end

	arg0_74:DeactiveIKLayer(var0_74)

	arg0_74.session.ikHandler = nil

	arg0_74.session:ReleaseBlock("drag")

	if arg2_74 then
		arg0_74.session:AcquireBlock("trigger")
	end

	arg0_74:Emit(var0_0.ON_IK_STATUS_CHANGED, var0_74:GetConfigID(), var0_0.IK_STATUS.RELEASE)
end

function var0_0.OnIKLayerAction(arg0_76, arg1_76)
	arg0_76.session:ReleaseBlock("trigger")

	local var0_76 = _.detect(arg0_76.session.readyIKLayers or {}, function(arg0_77)
		return arg0_77:GetControllerPath() == arg1_76.ikData:GetControllerPath()
	end)

	if not var0_76 then
		return
	end

	arg0_76:OnTriggerIK(var0_76)
	arg0_76:Emit(var0_0.ON_IK_STATUS_CHANGED, var0_76:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
end

function var0_0.GetDriverCallbacks(arg0_78)
	return {
		active = function(arg0_79)
			arg0_78:OnIKLayerActive(arg0_79)
		end,
		drag = function(arg0_80)
			arg0_78:OnIKLayerDrag(arg0_80)
		end,
		deactive = function(arg0_81, arg1_81)
			arg0_78:OnIKLayerDeactive(arg0_81, arg1_81)
		end,
		action = function(arg0_82)
			arg0_78:OnIKLayerAction(arg0_82)
		end
	}
end

function var0_0.ValidateIKSpec(arg0_83, arg1_83)
	return arg0_83.sessionBuilder:ValidateSpec(arg1_83)
end

function var0_0.ActivateIKSession(arg0_84, arg1_84, arg2_84)
	assert(arg1_84 and arg1_84.validated, "RoomIK session spec must be validated before activation")

	if not arg1_84.raycaster then
		arg1_84.raycaster = GetOrAddComponent(arg1_84.raycastCameraTF, typeof(UnityEngine.EventSystems.PhysicsRaycaster))

		assert(arg1_84.raycaster, "Missing RoomIK raycaster")
	end

	local var0_84 = arg0_84.session:Start(arg1_84.mode)

	arg0_84.session:ApplySpec(arg1_84)

	arg0_84.session.enableIKTip = true

	arg0_84:ResetIKTipTimer()
	arg0_84:CancelControlInput()
	existCall(arg2_84, arg1_84)
	arg0_84:Emit(RoomTouchSystem.CANCEL_TOUCH_PRESS)

	if arg1_84.mode == "normal" then
		arg0_84:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, arg0_84.session.ikTouchDatas, arg1_84.statusId)
	else
		arg0_84:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, nil)
	end

	arg0_84.driver:Attach(arg0_84.session, arg0_84:GetDriverCallbacks())
	arg0_84:Emit(Dorm3dIKView.UPDATE_TEXT_TIPS, RoomIKTipBuilder.BuildTextTips(arg0_84.session.readyIKLayers))

	return var0_84
end

function var0_0.SetIKStatus(arg0_85, arg1_85, arg2_85, arg3_85, arg4_85, arg5_85, arg6_85, arg7_85)
	warning("Set IKStatus " .. (arg2_85.id or "NIL"))

	if not arg7_85 then
		arg7_85 = arg0_85.sessionBuilder:BuildNormal(arg1_85, arg2_85, function(arg0_86)
			arg0_85:OnNormalIKLayerAction(arg0_86)
		end)

		arg0_85:ValidateIKSpec(arg7_85)
	end

	local var0_85 = arg0_85:GetCameras()
	local var1_85 = Dorm3dRoomTemplateScene.CAMERA.IK_WATCH
	local var2_85 = arg0_85:ActivateIKSession(arg7_85, function()
		setActive(arg1_85.ladyCollider, false)
		_.each(arg1_85.ladyTouchColliders, function(arg0_88)
			setActive(arg0_88, true)
		end)
		_.each(arg7_85.sceneItems, function(arg0_89)
			if IsNil(GetComponent(arg0_89.target, typeof(UnityEngine.Collider))) then
				go(arg0_89.target):AddComponent(typeof(UnityEngine.BoxCollider))
			end
		end)
	end)

	if var0_85[var1_85] then
		setActive(var0_85[var1_85], false)

		var0_85[var1_85] = nil
	end

	var0_85[var1_85] = arg7_85.ikCameraTF

	arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_ACTIVE_CAMERA, var0_85[var1_85])

	local var3_85 = arg7_85.ikCameraTF:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var3_85 then
		arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_REGISTER_ORBITS, var3_85)
	else
		arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_REVERT_CAMERA_ORBIT)
	end

	arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM, arg1_85, arg2_85.character_action, nil, true)
	arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK, arg1_85, arg2_85.head_track)
	arg1_85:EnableCloth(false)
	arg1_85:EnableCloth(arg2_85.use_cloth, arg2_85.cloth_colliders)
	arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_SCENE_ANIM, arg2_85.enter_scene_anim, true)
	arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_EXTRA_ITEM, arg1_85, arg2_85.enter_extra_item, true)
	arg0_85:Emit(Dorm3dRoomTemplateScene.EXTRA_HIDE_SCENE_ITEM, arg2_85.hide_scene_item)
	onNextTick(function()
		if not arg0_85.session:IsCurrent(var2_85) then
			return
		end

		if arg5_85 and not arg0_85:IsIKTransitionActive(arg5_85, arg6_85) then
			return
		end

		arg1_85.lady.position = arg7_85.stayPoint.position
		arg1_85.lady.rotation = arg7_85.stayPoint.rotation

		existCall(arg3_85)
	end)
end

function var0_0.ClearIKStatusRuntime(arg0_91, arg1_91, arg2_91)
	arg2_91 = arg2_91 or {}
	arg0_91.session.enableIKTip = false

	arg0_91:CancelControlInput()
	setActive(arg1_91.ladyCollider, true)
	_.each(arg1_91.ladyTouchColliders, function(arg0_92)
		setActive(arg0_92, false)
	end)
	arg0_91.session:ClearBlocks()
	arg0_91.driver:Detach()

	arg0_91.session.ikHandler = nil

	arg0_91:Emit(Dorm3dIKView.SET_TIPS_ACTIVE, false)
	arg0_91:Emit(RoomTouchSystem.CANCEL_TOUCH_PRESS)
	arg0_91:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, nil)
	arg0_91.session:ClearRuntime()
	arg0_91:Emit(Dorm3dRoomTemplateScene.EXTRA_REVERT_CAMERA_ORBIT)

	local var0_91 = arg0_91:GetCameras()[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH]

	if var0_91 then
		setActive(var0_91, false)

		arg0_91:GetCameras()[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH] = nil
	end

	arg1_91:EnableCloth(false)
	arg0_91:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_HEAD_AIM_IK, arg1_91)
	arg0_91:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_SCENE_ITEM_ANIMATORS)

	if not arg2_91.ignoreResetExtraItem then
		arg0_91:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_CHARACTER_EXTRA_ITEM)
		arg0_91:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_TEMP_HIDE_SCENE_ITEMS)
	end
end

function var0_0.ClearIKRuntime(arg0_93, arg1_93, arg2_93)
	arg2_93 = arg2_93 or {}

	if arg0_93.session.ikSwitchSkinId then
		local var0_93 = arg0_93:GetApartment():GetConfigID()

		arg1_93:SwitchCharacterSkin(var0_93, arg0_93.session.ikSwitchSkinId)

		arg0_93.session.ikSwitchSkinId = nil
	end

	arg0_93:ClearIKStatusRuntime(arg1_93, arg2_93)
end

function var0_0.BuildIKReturnInfo(arg0_94, arg1_94)
	assert(type(arg1_94) == "table", "Invalid IK return info")
	assert(type(arg1_94.character_action) == "string", "Invalid IK return character_action")
	assert(arg1_94.character_position == nil or type(arg1_94.character_position) == "string" and arg1_94.character_position ~= "", "Invalid IK return character_position")

	local var0_94 = arg1_94.character_position or arg0_94:GetLadyBaseZone(arg0_94:GetApartment():GetConfigID())

	assert(type(var0_94) == "string" and var0_94 ~= "", "Invalid IK return character_position")

	local var1_94 = arg0_94:GetIKPointByName(var0_94) or arg0_94:GetZoneByName(var0_94)

	assert(var1_94 and var1_94:Find("StayPoint"), "Missing IK return character position: " .. var0_94)

	return {
		character_position = var0_94,
		character_action = arg1_94.character_action
	}
end

function var0_0.ApplyIKReturn(arg0_95, arg1_95, arg2_95, arg3_95, arg4_95)
	arg3_95 = arg0_95:WrapCallbackOnce(arg3_95)

	arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM, arg1_95, arg2_95.character_action)
	onNextTick(function()
		if arg4_95 and not arg0_95:IsIKTransitionActive(arg4_95, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_CHANGE_CHARACTER_POSITION, arg1_95, arg2_95.character_position)
		arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_TRIGGER_LADY_DISTANCE)
		arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_CHECK_IN_SECTOR)
		existCall(arg3_95)
	end)
end

function var0_0.SaveIKTimelineColliderState(arg0_97, arg1_97)
	arg0_97.session.ikTimelineColliderStates = arg0_97.session.ikTimelineColliderStates or {}

	if arg0_97.session.ikTimelineColliderStates[arg1_97] == nil then
		arg0_97.session.ikTimelineColliderStates[arg1_97] = isActive(arg1_97)
	end
end

function var0_0.SetIKTimelineColliderActive(arg0_98, arg1_98, arg2_98)
	arg0_98:SaveIKTimelineColliderState(arg1_98)
	setActive(arg1_98, arg2_98)
end

function var0_0.RestoreIKTimelineColliders(arg0_99)
	if not arg0_99.session.ikTimelineColliderStates then
		return
	end

	for iter0_99, iter1_99 in pairs(arg0_99.session.ikTimelineColliderStates) do
		if iter0_99 and not IsNil(iter0_99) then
			setActive(iter0_99, iter1_99)
		end
	end

	arg0_99.session.ikTimelineColliderStates = nil
end

function var0_0.ClearIKTimelineRuntime(arg0_100)
	if not arg0_100:IsInIKTimelineMode() and not arg0_100.session.ikTimelineColliderStates then
		return
	end

	arg0_100:SetCurrentIkTimelineStatus(nil)

	arg0_100.session.enableIKTip = false

	arg0_100:CancelControlInput()
	arg0_100:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, false)
	arg0_100.session:ClearBlocks()
	arg0_100.driver:Detach()
	arg0_100.session:ClearRuntime()
	arg0_100:RestoreIKTimelineColliders()
	arg0_100:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, nil)
	arg0_100:Emit(Dorm3dIKView.SET_TIPS_ACTIVE, false)
end

function var0_0.SetIKTimelineStatus(arg0_101, arg1_101, arg2_101, arg3_101, arg4_101)
	arg4_101 = arg0_101:WrapCallbackOnce(arg4_101)

	if not arg0_101:CheckIkTimelineStatus(arg2_101) then
		existCall(arg4_101)

		return
	end

	local var0_101 = arg0_101.sessionBuilder:BuildTimeline(arg1_101, arg2_101, arg3_101, function(arg0_102)
		arg0_101:OnTimelineIKLayerAction(arg0_102)
	end)

	arg0_101:ValidateIKSpec(var0_101)

	if arg0_101:IsInIKTimelineMode() then
		arg0_101:ClearIKTimelineRuntime()
	else
		assert(arg0_101.modeState == var0_0.MODE_STATE.IDLE, string.format("Cannot enter timeline IK from state: %s", tostring(arg0_101.modeState)))
	end

	warning("Set IKStatus " .. (arg2_101 or "NIL"))
	arg0_101:ActivateIKSession(var0_101, function()
		_.each(var0_101.colliderChanges, function(arg0_104)
			arg0_101:SetIKTimelineColliderActive(arg0_104.target, arg0_104.active)
		end)
	end)
	arg0_101:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, true)
	existCall(arg4_101)
end

function var0_0.ExitIKTimelineStatus(arg0_105, arg1_105)
	arg1_105 = arg0_105:WrapCallbackOnce(arg1_105)

	if not arg0_105:IsInIKTimelineMode() then
		existCall(arg1_105)

		return
	end

	arg0_105:ClearIKTimelineRuntime()
	existCall(arg1_105)
end

function var0_0.SetCurrentIkTimelineStatus(arg0_106, arg1_106)
	arg0_106.session.currentIkTimelineStatus = arg1_106
end

function var0_0.CheckIkTimelineStatus(arg0_107, arg1_107)
	if not arg0_107.session.currentIkTimelineStatus then
		return true
	end

	return arg0_107.session.currentIkTimelineStatus ~= arg1_107
end

function var0_0.IsInIKTimelineMode(arg0_108)
	return arg0_108.session.mode == "timeline"
end

function var0_0.IsIKModeActive(arg0_109)
	return arg0_109.modeState == var0_0.MODE_STATE.ACTIVE
end

function var0_0.CanHandleIKInput(arg0_110)
	return arg0_110:IsIKModeActive() or arg0_110:IsInIKTimelineMode()
end

function var0_0.EnableIKLayer(arg0_111, arg1_111)
	local var0_111 = arg0_111:GetCurrentLadyEnv()

	if #arg1_111:GetHeadTrackPath() > 0 then
		arg0_111:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK, var0_111, {
			2,
			arg1_111:GetHeadTrackPath()
		}, true)
	end

	local var1_111 = arg1_111:GetTriggerFaceAnim()

	if #var1_111 > 0 then
		arg0_111:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_FACE_ANIM, var0_111, var1_111)
	end

	if not arg1_111.ignoreDrag then
		arg0_111:Emit(Dorm3dIKView.PLAY_HAND_BEGIN)
	end

	if not arg0_111:IsInIKTimelineMode() then
		local var2_111 = arg0_111.session.currentIkConfig

		assert(var2_111, "Missing current IK config")
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_111:GetApartment().configId, arg0_111:GetApartment().level, var2_111.character_action, arg1_111:GetTriggerParams()[2], arg0_111:GetRoom():GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_112, arg1_112)
	local var0_112 = arg0_112:GetCurrentLadyEnv()

	if not arg0_112:IsInIKTimelineMode() and #arg1_112:GetHeadTrackPath() > 0 then
		local var1_112 = arg0_112.session.currentIkConfig

		assert(var1_112, "Missing current IK config")
		arg0_112:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK, var0_112, var1_112.head_track)
	end

	if not arg1_112.ignoreDrag then
		arg0_112:Emit(Dorm3dIKView.PLAY_HAND_END)
	end
end

function var0_0.ResetIKTipTimer(arg0_113)
	if not arg0_113.session.enableIKTip then
		return
	end

	arg0_113.session.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.PlayTouchIKMove(arg0_114, arg1_114, arg2_114, arg3_114, arg4_114, arg5_114)
	arg5_114 = arg0_114:WrapCallbackOnce(arg5_114)

	assert(arg0_114:IsIKModeActive(), "Touch IK move requires active IK")
	assert(type(arg2_114) == "table" and #arg2_114 == 2, "Invalid touch IK move point: " .. tostring(arg1_114))
	assert(type(arg3_114) == "number", "Invalid touch IK move step: " .. tostring(arg1_114))
	assert(type(arg4_114) == "number", "Invalid touch IK move time: " .. tostring(arg1_114))

	local var0_114 = arg0_114.session.ikSettings

	assert(var0_114, "Missing IK settings when play touch IK move")

	local var1_114 = var0_114.Colliders

	assert(var1_114, "Missing IK colliders when play touch IK move")

	local var2_114 = Dorm3dIK.New({
		configId = arg1_114
	}):GetTriggerBoneName()
	local var3_114 = var1_114[var2_114]

	assert(var3_114, "Missing IK collider: " .. tostring(var2_114))

	local var4_114 = arg0_114:GetRaycastCamera():WorldToScreenPoint(var3_114.position)

	arg0_114.driver:Reset(var2_114)
	arg0_114.driver:PlayMove(var4_114, var2_114, Vector2.New(unpack(arg2_114)), arg3_114, arg4_114, arg5_114)
end

function var0_0.OnNormalIKLayerAction(arg0_115, arg1_115)
	if not arg0_115:IsIKModeActive() then
		return
	end

	if not arg0_115.session.currentIkConfig then
		return
	end

	local var0_115 = arg0_115:GetCurrentLadyEnv()
	local var1_115 = arg1_115:GetControllerPath()
	local var2_115 = arg0_115.session.ikActionDict[var1_115]

	if not var2_115 then
		return
	end

	arg0_115.session:AcquireBlock("layer_action")

	local var3_115 = arg0_115:WrapCallbackOnce(function()
		arg0_115:ResetIKTipTimer()
		arg0_115.session:ReleaseBlock("layer_action")
	end)

	arg0_115:Emit(var0_0.ON_IK_LAYER_ACTION, var0_115, arg1_115:GetConfigID(), var2_115, var3_115)
end

function var0_0.OnTimelineIKLayerAction(arg0_117, arg1_117)
	if not arg0_117:IsInIKTimelineMode() then
		return
	end

	arg0_117:ExitIKTimelineStatus()

	local var0_117 = arg1_117:GetTimelineAction()

	if var0_117 then
		arg0_117:GetNowTimelinePlayer():TriggerEvent(var0_117)
	end
end

function var0_0.OnTriggerIK(arg0_118, arg1_118)
	if not arg0_118:CanHandleIKInput() then
		return
	end

	local var0_118 = arg0_118.session.spec

	if not var0_118 or not var0_118.onLayerAction then
		return
	end

	var0_118.onLayerAction(arg1_118)
end

function var0_0.UpdateIKTarget(arg0_119)
	if not arg0_119:CanHandleIKInput() then
		return
	end

	if not arg0_119:GetApartment() then
		return
	end

	if not arg0_119:GetCurrentLadyEnv() then
		return
	end

	if arg0_119.session.ikHandler then
		if not arg0_119.session.readyIKLayers then
			return
		end

		local var0_119 = arg0_119.session.ikHandler.screenPosition
		local var1_119 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
		local var2_119 = var0_119 - Vector2.New(var1_119.width, var1_119.height) * 0.5

		arg0_119:Emit(Dorm3dIKView.SET_HAND_POSITION, var2_119)

		if Time.time > arg0_119.session.ikNextCheckStamp then
			arg0_119.session.ikNextCheckStamp = arg0_119.session.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

			local var3_119 = _.detect(arg0_119.session.readyIKLayers, function(arg0_120)
				return arg0_120:GetControllerPath() == arg0_119.session.ikHandler.ikData:GetControllerPath()
			end)

			arg0_119:Emit(var0_0.ON_IK_STATUS_CHANGED, var3_119:GetConfigID(), var0_0.IK_STATUS.DRAG)
		end
	end

	if arg0_119.session.enableIKTip then
		if not arg0_119.session.readyIKLayers or not arg0_119.session.ikSettings then
			return
		end

		arg0_119:UpdateIKTips()
	end
end

function var0_0.UpdateIKTips(arg0_121)
	if not arg0_121.session.nextTipIKTime then
		return
	end

	local var0_121 = not arg0_121.session:IsBlocked() and Time.time > arg0_121.session.nextTipIKTime

	local function var1_121(arg0_122)
		local var0_122 = {}

		arg0_121:Emit(Dorm3dRoomTemplateScene.EXTRA_GET_SCREEN_POSITION, var0_122, arg0_122, arg0_121.session.ikSettings.CameraRaycaster.eventCamera)

		return var0_122.value
	end

	local function var2_121(arg0_123)
		return arg0_121:GetSceneItem(arg0_123)
	end

	arg0_121:Emit(Dorm3dIKView.UPDATE_TIPS, var0_121, RoomIKTipBuilder.BuildIKTips(arg0_121.session.readyIKLayers, arg0_121.session.ikSettings, var1_121), RoomIKTipBuilder.BuildTouchTips(arg0_121.session.ikTouchDatas, pg.dorm3d_ik_touch, arg0_121.session.ikSettings, var2_121, var1_121))
end

function var0_0.CycleIKCameraGroup(arg0_124)
	local var0_124 = arg0_124:GetCurrentLadyEnv()

	assert(var0_124, "Missing LadyEnv when cycle IK camera group")
	assert(arg0_124:IsIKModeActive(), "Cycle IK camera group requires active IK")
	arg0_124.driver:ResetActiveLayers()

	local var1_124 = arg0_124.session.currentIkConfig

	assert(var1_124, "Missing current IK config")

	local var2_124 = var1_124.camera_group
	local var3_124 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var2_124]
	local var4_124 = var3_124[table.indexof(var3_124, var1_124.id) % #var3_124 + 1]

	arg0_124:ReplaceIKStatus(var4_124)
end

function var0_0.SetIKSwitchSkinId(arg0_125, arg1_125)
	arg0_125.session.ikSwitchSkinId = arg1_125
end

function var0_0.SwitchIKSkin(arg0_126, arg1_126, arg2_126, arg3_126)
	assert(arg0_126:IsIKModeActive(), "Switch IK skin requires active IK")

	local var0_126 = arg0_126.session.currentIkConfig

	assert(var0_126, "Missing current IK config")

	local var1_126 = var0_126.id

	seriesAsync({
		function(arg0_127)
			arg0_126:ExitIK(arg0_127)
		end,
		function(arg0_128)
			arg1_126:SwitchCharacterSkin(arg2_126, arg3_126)
			arg0_126:EnterIK(var1_126, arg0_128)
		end
	})
end

function var0_0.ConsumeIKSpecialCall(arg0_129)
	if not arg0_129.session.ikSpecialCall then
		return false
	end

	local var0_129 = arg0_129.session.ikSpecialCall

	arg0_129.session.ikSpecialCall = nil

	existCall(var0_129)

	return true
end

return var0_0
