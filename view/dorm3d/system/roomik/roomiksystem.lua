local var0_0 = class("RoomIKSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.ENTER_IK = "RoomIKSystem.ENTER_IK"
var0_0.REPLACE_IK_STATUS = "RoomIKSystem.REPLACE_IK_STATUS"
var0_0.EXIT_IK_WITH_RETURN = "RoomIKSystem.EXIT_IK_WITH_RETURN"
var0_0.ENTER_STOCKING_IK_MODE = "RoomIKSystem.ENTER_STOCKING_IK_MODE"
var0_0.EXIT_STOCKING_IK_MODE = "RoomIKSystem.EXIT_STOCKING_IK_MODE"
var0_0.ENTER_AIMIK_IK_MODE = "RoomIKSystem.ENTER_AIMIK_IK_MODE"
var0_0.EXIT_AIMIK_IK_MODE = "RoomIKSystem.EXIT_AIMIK_IK_MODE"
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
	arg0_2:Bind(var0_0.ENTER_AIMIK_IK_MODE, function(arg0_8, arg1_8)
		arg0_2:EnterAimIKMode(arg1_8)
	end)
	arg0_2:Bind(var0_0.EXIT_AIMIK_IK_MODE, function(arg0_9, arg1_9)
		arg0_2:ExitAimIKMode(arg1_9)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_POINTER_DOWN, function(arg0_10, arg1_10)
		arg0_2.input:OnControlPointerDown(arg1_10)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_POINTER_UP, function(arg0_11, arg1_11)
		arg0_2.input:OnControlPointerUp(arg1_11)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_BEGIN_DRAG, function(arg0_12, arg1_12)
		arg0_2.input:OnControlBeginDrag(arg1_12)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_DRAG, function(arg0_13, arg1_13, arg2_13)
		arg0_2.input:OnControlDrag(arg1_13, arg2_13)
	end)
	arg0_2:Bind(var0_0.ON_CONTROL_END_DRAG, function(arg0_14, arg1_14)
		arg0_2.input:OnControlEndDrag(arg1_14)
	end)
	arg0_2:Bind(var0_0.SET_IK_TIMELINE_STATUS, function(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
		arg0_2:SetIKTimelineStatus(arg1_15, arg2_15, arg3_15, arg4_15)
	end)
	arg0_2:Bind(var0_0.EXIT_IK_TIMELINE_STATUS, function(arg0_16, arg1_16)
		arg0_2:ExitIKTimelineStatus(arg1_16)
	end)
	arg0_2:Bind(var0_0.CYCLE_IK_CAMERA_GROUP, function()
		arg0_2:CycleIKCameraGroup()
	end)
	arg0_2:Bind(var0_0.SET_IK_SPECIAL_CALL, function(arg0_18, arg1_18)
		arg0_2.session.ikSpecialCall = arg1_18
	end)
	arg0_2:Bind(var0_0.CONSUME_IK_SPECIAL_CALL, function(arg0_19, arg1_19)
		local var0_19 = arg0_2:ConsumeIKSpecialCall()

		if arg1_19 then
			arg1_19.consumed = var0_19
		end
	end)
	arg0_2:Bind(var0_0.GET_IK_BLOCK, function(arg0_20, arg1_20)
		if arg1_20 then
			arg1_20.blockIK = arg0_2.session:IsBlocked()
		end
	end)
	arg0_2:Bind(var0_0.SET_IK_BLOCK, function(arg0_21, arg1_21)
		arg0_2.session:SetLegacyBlock(arg1_21)
	end)
	arg0_2:Bind(var0_0.RESET_IK_TIP_TIMER, function()
		arg0_2:ResetIKTipTimer()
	end)
	arg0_2:Bind(var0_0.SET_IK_SWITCH_SKIN_ID, function(arg0_23, arg1_23)
		arg0_2:SetIKSwitchSkinId(arg1_23)
	end)
	arg0_2:Bind(var0_0.SWITCH_IK_SKIN, function(arg0_24, arg1_24, arg2_24, arg3_24)
		arg0_2:SwitchIKSkin(arg1_24, arg2_24, arg3_24)
	end)
	arg0_2:Bind(var0_0.PLAY_TOUCH_IK_MOVE, function(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
		arg0_2:PlayTouchIKMove(arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
	end)
end

function var0_0.OnUpdate(arg0_26)
	arg0_26:UpdateIKTarget()
end

function var0_0.OnDispose(arg0_27)
	arg0_27.transitionSerial = arg0_27.transitionSerial + 1

	local var0_27 = arg0_27:GetCurrentLadyEnv()

	if arg0_27:IsInIKTimelineMode() then
		arg0_27:ClearIKTimelineRuntime()
	elseif arg0_27.session.active and var0_27 then
		arg0_27:ClearIKStatusRuntime(var0_27)
	else
		arg0_27:RestoreIKTimelineColliders()
		arg0_27:CancelControlInput()
		arg0_27.driver:Detach()
	end

	arg0_27:ReleaseIKBlock()

	arg0_27.modeState = var0_0.MODE_STATE.IDLE

	if arg0_27.input then
		arg0_27.input:Dispose()

		arg0_27.input = nil
	end

	arg0_27.pendingExitCallbacks = {}

	arg0_27.session:Invalidate()
end

function var0_0.WrapCallbackOnce(arg0_28, arg1_28)
	if not arg1_28 then
		return nil
	end

	local var0_28 = false

	return function(...)
		if var0_28 then
			return
		end

		var0_28 = true

		existCall(arg1_28, ...)
	end
end

function var0_0.FlushExitCallbacks(arg0_30, arg1_30)
	existCall(arg1_30)

	local var0_30 = arg0_30.pendingExitCallbacks

	arg0_30.pendingExitCallbacks = {}

	for iter0_30, iter1_30 in ipairs(var0_30) do
		existCall(iter1_30)
	end
end

function var0_0.ResolveIKConfig(arg0_31, arg1_31, arg2_31)
	warning("switchIkstatus", arg2_31)

	local var0_31 = pg.dorm3d_ik_status[arg2_31]

	assert(var0_31, "Missing dorm3d_ik_status config: " .. tostring(arg2_31))

	local function var1_31()
		if var0_31.skin_id ~= arg1_31.skinId then
			local var0_32 = pg.dorm3d_ik_status.get_id_list_by_base[var0_31.base]
			local var1_32 = _.detect(var0_32, function(arg0_33)
				return pg.dorm3d_ik_status[arg0_33].skin_id == arg1_31.skinId
			end)

			assert(var1_32, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_31.skinId, arg2_31))

			var0_31 = pg.dorm3d_ik_status[var1_32]
		end
	end

	if type(var0_31.skin_id) == "table" then
		if not table.contains(var0_31.skin_id, arg1_31.skinId) then
			var1_31()
		end
	else
		var1_31()
	end

	return var0_31
end

function var0_0.BeginIKTransition(arg0_34, arg1_34)
	arg0_34.transitionSerial = arg0_34.transitionSerial + 1
	arg0_34.modeState = arg1_34

	return arg0_34.transitionSerial
end

function var0_0.IsIKTransitionActive(arg0_35, arg1_35, arg2_35)
	return arg0_35.transitionSerial == arg1_35 and arg0_35.modeState == arg2_35
end

function var0_0.AcquireIKBlock(arg0_36)
	if arg0_36.session.uiBlockHeld then
		return
	end

	arg0_36.session.uiBlockHeld = true

	arg0_36:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
end

function var0_0.ReleaseIKBlock(arg0_37)
	if not arg0_37.session.uiBlockHeld then
		return
	end

	arg0_37.session.uiBlockHeld = false

	arg0_37:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
end

function var0_0.RunIKStatusTransition(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38, arg5_38, arg6_38, arg7_38)
	arg6_38 = arg6_38 or {}
	arg5_38 = arg0_38:WrapCallbackOnce(arg5_38)

	local var0_38 = {}

	table.insert(var0_38, function(arg0_39)
		if not arg0_38:IsIKTransitionActive(arg4_38, arg3_38) then
			return
		end

		arg0_38:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, arg1_38, "inIK", true)
		arg0_38:AcquireIKBlock()

		local var0_39 = arg2_38.camera_group

		arg0_38:Emit(Dorm3dIKView.SET_CAMERA_BUTTON_ACTIVE, #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_39] > 1)
		arg0_38:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, true)
		arg0_39()
	end)

	if arg0_38:GetUIState() ~= "ik" then
		table.insert(var0_38, function(arg0_40)
			if not arg0_38:IsIKTransitionActive(arg4_38, arg3_38) then
				return
			end

			arg0_38:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_40, "ik")
		end)
	end

	table.insert(var0_38, function(arg0_41)
		if not arg0_38:IsIKTransitionActive(arg4_38, arg3_38) then
			return
		end

		if arg3_38 == var0_0.MODE_STATE.REPLACING then
			arg0_38:ClearIKStatusRuntime(arg1_38, arg6_38)

			arg0_38.session.currentIkConfig = arg2_38
		end

		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_38:SetIKStatus(arg1_38, arg2_38, arg0_41, arg6_38, arg4_38, arg3_38, arg7_38)
	end)
	table.insert(var0_38, function(arg0_42)
		if not arg0_38:IsIKTransitionActive(arg4_38, arg3_38) then
			return
		end

		arg0_38:ReleaseIKBlock()
		arg0_42()
	end)
	seriesAsync(var0_38, function()
		if not arg0_38:IsIKTransitionActive(arg4_38, arg3_38) then
			return
		end

		arg0_38.modeState = var0_0.MODE_STATE.ACTIVE

		existCall(arg5_38)
	end)
end

function var0_0.EnterIK(arg0_44, arg1_44, arg2_44, arg3_44)
	arg2_44 = arg0_44:WrapCallbackOnce(arg2_44)

	assert(arg0_44.modeState == var0_0.MODE_STATE.IDLE, string.format("Cannot enter IK from state: %s", tostring(arg0_44.modeState)))
	assert(not arg0_44:IsInIKTimelineMode(), "Cannot enter IK during timeline IK")

	local var0_44 = arg0_44:GetCurrentLadyEnv()

	assert(var0_44, "Missing LadyEnv when enter IK")

	local var1_44 = arg0_44:ResolveIKConfig(var0_44, arg1_44)
	local var2_44 = arg0_44.sessionBuilder:BuildNormal(var0_44, var1_44, function(arg0_45)
		arg0_44:OnNormalIKLayerAction(arg0_45)
	end)

	arg0_44:ValidateIKSpec(var2_44)

	local var3_44 = arg0_44:BeginIKTransition(var0_0.MODE_STATE.ENTERING)

	arg0_44.session.currentIkConfig = var1_44

	arg0_44:RunIKStatusTransition(var0_44, var1_44, var0_0.MODE_STATE.ENTERING, var3_44, arg2_44, arg3_44, var2_44)
end

function var0_0.ReplaceIKStatus(arg0_46, arg1_46, arg2_46, arg3_46)
	arg2_46 = arg0_46:WrapCallbackOnce(arg2_46)

	assert(arg0_46.modeState == var0_0.MODE_STATE.ACTIVE, string.format("Cannot replace IK status from state: %s", tostring(arg0_46.modeState)))

	local var0_46 = arg0_46:GetCurrentLadyEnv()

	assert(var0_46, "Missing LadyEnv when replace IK status")

	local var1_46 = arg0_46:ResolveIKConfig(var0_46, arg1_46)
	local var2_46 = arg0_46.sessionBuilder:BuildNormal(var0_46, var1_46, function(arg0_47)
		arg0_46:OnNormalIKLayerAction(arg0_47)
	end)

	arg0_46:ValidateIKSpec(var2_46)

	local var3_46 = arg0_46:BeginIKTransition(var0_0.MODE_STATE.REPLACING)

	arg0_46.session.currentIkConfig = var1_46

	arg0_46:RunIKStatusTransition(var0_46, var1_46, var0_0.MODE_STATE.REPLACING, var3_46, arg2_46, arg3_46, var2_46)
end

function var0_0.ExitIK(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg0_48.session.currentIkConfig

	assert(var0_48, "Missing current IK config")
	arg0_48:ExitIKWithReturn({
		character_position = var0_48.character_position,
		character_action = var0_48.character_action
	}, arg1_48, arg2_48)
end

function var0_0.ExitIKWithReturn(arg0_49, arg1_49, arg2_49, arg3_49)
	arg2_49 = arg0_49:WrapCallbackOnce(arg2_49)

	if arg0_49.modeState == var0_0.MODE_STATE.EXITING then
		if arg2_49 then
			table.insert(arg0_49.pendingExitCallbacks, arg2_49)
		end

		return
	end

	assert(arg0_49.modeState == var0_0.MODE_STATE.ACTIVE, string.format("Cannot exit IK from state: %s", tostring(arg0_49.modeState)))

	arg3_49 = arg3_49 or {}

	local var0_49 = arg0_49:GetCurrentLadyEnv()

	assert(var0_49, "Missing LadyEnv when exit IK")
	assert(arg0_49.session.currentIkConfig, "Missing current IK config when exit IK")
	assert(arg0_49:GetUIState() == "ik")

	arg1_49 = arg0_49:BuildIKReturnInfo(arg1_49)

	local var1_49 = arg0_49:BeginIKTransition(var0_0.MODE_STATE.EXITING)

	seriesAsync({
		function(arg0_50)
			if not arg0_49:IsIKTransitionActive(var1_49, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_49:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, false)
			arg0_49:AcquireIKBlock()
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_50()
		end,
		function(arg0_51)
			if not arg0_49:IsIKTransitionActive(var1_49, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_49:ClearIKRuntime(var0_49, arg3_49)
			arg0_49:ApplyIKReturn(var0_49, arg1_49, arg0_51, var1_49)
		end,
		function(arg0_52)
			if not arg0_49:IsIKTransitionActive(var1_49, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_49:Emit(Dorm3dRoomScene.EXTRA_SET_UI, arg0_52, "back")
		end,
		function(arg0_53)
			if not arg0_49:IsIKTransitionActive(var1_49, var0_0.MODE_STATE.EXITING) then
				return
			end

			arg0_49:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE, var0_49, "inIK", false)
			arg0_49:ReleaseIKBlock()
			arg0_53()
		end
	}, function()
		if not arg0_49:IsIKTransitionActive(var1_49, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_49.modeState = var0_0.MODE_STATE.IDLE

		arg0_49:FlushExitCallbacks(arg2_49)
	end)
end

function var0_0.EnterStockingIKMode(arg0_55, arg1_55)
	local var0_55 = arg0_55:GetCurrentLadyEnv()

	assert(var0_55, "Missing LadyEnv when enter stocking IK mode")
	assert(arg0_55.modeState == var0_0.MODE_STATE.ACTIVE, "Stocking mode requires active IK")
	assert(arg0_55.session.currentIkStatus, "Missing current IK status when enter stocking IK mode")

	arg0_55.session.stockingCachedIkStatus = arg0_55.session.currentIkStatus

	arg0_55:ExitIK(arg1_55, {
		ignoreResetExtraItem = true
	})
end

function var0_0.ExitStockingIKMode(arg0_56, arg1_56)
	local var0_56 = arg0_56:GetCurrentLadyEnv()

	assert(var0_56, "Missing LadyEnv when exit stocking IK mode")
	assert(arg0_56.modeState == var0_0.MODE_STATE.IDLE, "Exit stocking mode requires idle IK")

	local var1_56 = arg0_56.session.stockingCachedIkStatus

	assert(var1_56, "Missing cached IK status when exit stocking IK mode")

	arg0_56.session.stockingCachedIkStatus = nil

	arg0_56:EnterIK(var1_56, arg1_56)
end

function var0_0.EnterAimIKMode(arg0_57, arg1_57)
	assert(arg0_57.modeState == var0_0.MODE_STATE.ACTIVE, "Touch AimIK mode requires active IK")
	assert(arg0_57.session.currentIkStatus, "Missing current IK status when enter touch AimIK mode")
	assert(not arg0_57.session.aimIKCachedIkStatus, "Touch AimIK mode is already active")

	arg0_57.session.aimIKCachedIkStatus = arg0_57.session.currentIkStatus

	arg0_57:ExitIK(arg1_57, {
		ignoreResetExtraItem = true
	})
end

function var0_0.ExitAimIKMode(arg0_58, arg1_58)
	assert(arg0_58.modeState == var0_0.MODE_STATE.IDLE, "Exit touch AimIK mode requires idle IK")

	local var0_58 = arg0_58.session.aimIKCachedIkStatus

	assert(var0_58, "Missing cached IK status when exit touch AimIK mode")

	arg0_58.session.aimIKCachedIkStatus = nil

	arg0_58:EnterIK(var0_58, arg1_58)
end

function var0_0.GetSession(arg0_59)
	return arg0_59.session
end

function var0_0.CancelControlInput(arg0_60)
	if arg0_60.input then
		arg0_60.input:Cancel()
	end
end

function var0_0.BeginIKBodyDrag(arg0_61, arg1_61, arg2_61)
	if not arg0_61:CanHandleIKInput() then
		return
	end

	if arg0_61.session:IsBlocked() or arg0_61.session.ikHandler then
		return
	end

	arg0_61.driver:BeginDrag(arg1_61, arg2_61)
end

function var0_0.DragIKBody(arg0_62, arg1_62)
	if not arg0_62:CanHandleIKInput() then
		return
	end

	if not arg0_62.session.ikHandler then
		return
	end

	arg0_62.driver:Drag(arg1_62)
end

function var0_0.ReleaseIKBody(arg0_63)
	arg0_63.driver:Release()
end

function var0_0.OnControlPointerDown(arg0_64, arg1_64)
	arg0_64.input:OnControlPointerDown(arg1_64)
end

function var0_0.OnControlPointerUp(arg0_65, arg1_65)
	arg0_65.input:OnControlPointerUp(arg1_65)
end

function var0_0.OnControlBeginDrag(arg0_66, arg1_66)
	arg0_66.input:OnControlBeginDrag(arg1_66)
end

function var0_0.OnControlDrag(arg0_67, arg1_67, arg2_67)
	arg0_67.input:OnControlDrag(arg1_67, arg2_67)
end

function var0_0.OnControlEndDrag(arg0_68, arg1_68)
	arg0_68.input:OnControlEndDrag(arg1_68)
end

function var0_0.GetIKRaycastTargets(arg0_69, arg1_69)
	return arg0_69.input:GetIKRaycastTargets(arg1_69)
end

function var0_0.ResolveBodyTarget(arg0_70, arg1_70)
	return arg0_70.input:ResolveBodyTarget(arg1_70)
end

function var0_0.ResolveTouchTarget(arg0_71, arg1_71)
	return arg0_71.input:ResolveTouchTarget(arg1_71)
end

function var0_0.ResolveTouchSceneItem(arg0_72, arg1_72)
	return arg0_72.input:ResolveTouchSceneItem(arg1_72)
end

function var0_0.IsTransformInHierarchy(arg0_73, arg1_73)
	return RoomIKInput.IsTransformInHierarchy(arg0_73, arg1_73)
end

function var0_0.EmitTouchPress(arg0_74, arg1_74, arg2_74, arg3_74)
	arg0_74.input:EmitTouchPress(arg1_74, arg2_74, arg3_74)
end

function var0_0.OnIKLayerActive(arg0_75, arg1_75)
	arg0_75.session.ikHandler = arg1_75

	local var0_75 = _.detect(arg0_75.session.readyIKLayers or {}, function(arg0_76)
		return arg0_76:GetControllerPath() == arg1_75.ikData:GetControllerPath()
	end)

	if not var0_75 then
		return
	end

	arg0_75.session:AcquireBlock("drag")
	arg0_75:EnableIKLayer(var0_75)

	arg0_75.session.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_75:Emit(var0_0.ON_IK_STATUS_CHANGED, var0_75:GetConfigID(), var0_0.IK_STATUS.BEGIN)
end

function var0_0.OnIKLayerDrag(arg0_77, arg1_77)
	arg0_77.session.ikHandler = arg1_77

	arg0_77:ResetIKTipTimer()
end

function var0_0.OnIKLayerDeactive(arg0_78, arg1_78, arg2_78)
	local var0_78 = _.detect(arg0_78.session.readyIKLayers or {}, function(arg0_79)
		return arg0_79:GetControllerPath() == arg1_78.ikData:GetControllerPath()
	end)

	if not var0_78 then
		return
	end

	arg0_78:DeactiveIKLayer(var0_78)

	arg0_78.session.ikHandler = nil

	arg0_78.session:ReleaseBlock("drag")

	if arg2_78 then
		arg0_78.session:AcquireBlock("trigger")
	end

	arg0_78:Emit(var0_0.ON_IK_STATUS_CHANGED, var0_78:GetConfigID(), var0_0.IK_STATUS.RELEASE)
end

function var0_0.OnIKLayerAction(arg0_80, arg1_80)
	arg0_80.session:ReleaseBlock("trigger")

	local var0_80 = _.detect(arg0_80.session.readyIKLayers or {}, function(arg0_81)
		return arg0_81:GetControllerPath() == arg1_80.ikData:GetControllerPath()
	end)

	if not var0_80 then
		return
	end

	arg0_80:OnTriggerIK(var0_80)
	arg0_80:Emit(var0_0.ON_IK_STATUS_CHANGED, var0_80:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
end

function var0_0.GetDriverCallbacks(arg0_82)
	return {
		active = function(arg0_83)
			arg0_82:OnIKLayerActive(arg0_83)
		end,
		drag = function(arg0_84)
			arg0_82:OnIKLayerDrag(arg0_84)
		end,
		deactive = function(arg0_85, arg1_85)
			arg0_82:OnIKLayerDeactive(arg0_85, arg1_85)
		end,
		action = function(arg0_86)
			arg0_82:OnIKLayerAction(arg0_86)
		end
	}
end

function var0_0.ValidateIKSpec(arg0_87, arg1_87)
	return arg0_87.sessionBuilder:ValidateSpec(arg1_87)
end

function var0_0.ActivateIKSession(arg0_88, arg1_88, arg2_88)
	assert(arg1_88 and arg1_88.validated, "RoomIK session spec must be validated before activation")

	if not arg1_88.raycaster then
		arg1_88.raycaster = GetOrAddComponent(arg1_88.raycastCameraTF, typeof(UnityEngine.EventSystems.PhysicsRaycaster))

		assert(arg1_88.raycaster, "Missing RoomIK raycaster")
	end

	local var0_88 = arg0_88.session:Start(arg1_88.mode)

	arg0_88.session:ApplySpec(arg1_88)

	arg0_88.session.enableIKTip = true

	arg0_88:ResetIKTipTimer()
	arg0_88:CancelControlInput()
	existCall(arg2_88, arg1_88)
	arg0_88:Emit(RoomTouchSystem.CANCEL_TOUCH_PRESS)

	if arg1_88.mode == "normal" then
		arg0_88:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, arg0_88.session.ikTouchDatas, arg1_88.statusId)
	else
		arg0_88:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, nil)
	end

	arg0_88.driver:Attach(arg0_88.session, arg0_88:GetDriverCallbacks())
	arg0_88:Emit(Dorm3dIKView.UPDATE_TEXT_TIPS, RoomIKTipBuilder.BuildTextTips(arg0_88.session.readyIKLayers))

	return var0_88
end

function var0_0.SetIKStatus(arg0_89, arg1_89, arg2_89, arg3_89, arg4_89, arg5_89, arg6_89, arg7_89)
	warning("Set IKStatus " .. (arg2_89.id or "NIL"))

	if not arg7_89 then
		arg7_89 = arg0_89.sessionBuilder:BuildNormal(arg1_89, arg2_89, function(arg0_90)
			arg0_89:OnNormalIKLayerAction(arg0_90)
		end)

		arg0_89:ValidateIKSpec(arg7_89)
	end

	local var0_89 = arg0_89:GetCameras()
	local var1_89 = Dorm3dRoomTemplateScene.CAMERA.IK_WATCH
	local var2_89 = arg0_89:ActivateIKSession(arg7_89, function()
		setActive(arg1_89.ladyCollider, false)
		_.each(arg1_89.ladyTouchColliders, function(arg0_92)
			setActive(arg0_92, true)
		end)
		_.each(arg7_89.sceneItems, function(arg0_93)
			if IsNil(GetComponent(arg0_93.target, typeof(UnityEngine.Collider))) then
				go(arg0_93.target):AddComponent(typeof(UnityEngine.BoxCollider))
			end
		end)
	end)

	if var0_89[var1_89] then
		setActive(var0_89[var1_89], false)

		var0_89[var1_89] = nil
	end

	var0_89[var1_89] = arg7_89.ikCameraTF

	arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_ACTIVE_CAMERA, var0_89[var1_89])

	local var3_89 = arg7_89.ikCameraTF:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var3_89 then
		arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_REGISTER_ORBITS, var3_89)
	else
		arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_REVERT_CAMERA_ORBIT)
	end

	arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM, arg1_89, arg2_89.character_action, nil, true)
	arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK, arg1_89, arg2_89.head_track)
	arg1_89:EnableCloth(false)
	arg1_89:EnableCloth(arg2_89.use_cloth, arg2_89.cloth_colliders)
	arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_SCENE_ANIM, arg2_89.enter_scene_anim, true)
	arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_EXTRA_ITEM, arg1_89, arg2_89.enter_extra_item, true)
	arg0_89:Emit(Dorm3dRoomTemplateScene.EXTRA_HIDE_SCENE_ITEM, arg2_89.hide_scene_item)
	onNextTick(function()
		if not arg0_89.session:IsCurrent(var2_89) then
			return
		end

		if arg5_89 and not arg0_89:IsIKTransitionActive(arg5_89, arg6_89) then
			return
		end

		arg1_89.lady.position = arg7_89.stayPoint.position
		arg1_89.lady.rotation = arg7_89.stayPoint.rotation

		existCall(arg3_89)
	end)
end

function var0_0.ClearIKStatusRuntime(arg0_95, arg1_95, arg2_95)
	arg2_95 = arg2_95 or {}
	arg0_95.session.enableIKTip = false

	arg0_95:CancelControlInput()
	setActive(arg1_95.ladyCollider, true)
	_.each(arg1_95.ladyTouchColliders, function(arg0_96)
		setActive(arg0_96, false)
	end)
	arg0_95.session:ClearBlocks()
	arg0_95.driver:Detach()

	arg0_95.session.ikHandler = nil

	arg0_95:Emit(Dorm3dIKView.SET_TIPS_ACTIVE, false)
	arg0_95:Emit(RoomTouchSystem.CANCEL_TOUCH_PRESS)
	arg0_95:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, nil)
	arg0_95.session:ClearRuntime()
	arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_REVERT_CAMERA_ORBIT)

	local var0_95 = arg0_95:GetCameras()[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH]

	if var0_95 then
		setActive(var0_95, false)

		arg0_95:GetCameras()[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH] = nil
	end

	arg1_95:EnableCloth(false)
	arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_HEAD_AIM_IK, arg1_95)
	arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_SCENE_ITEM_ANIMATORS)

	if not arg2_95.ignoreResetExtraItem then
		arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_CHARACTER_EXTRA_ITEM)
		arg0_95:Emit(Dorm3dRoomTemplateScene.EXTRA_RESET_TEMP_HIDE_SCENE_ITEMS)
	end
end

function var0_0.ClearIKRuntime(arg0_97, arg1_97, arg2_97)
	arg2_97 = arg2_97 or {}

	if arg0_97.session.ikSwitchSkinId then
		local var0_97 = arg0_97:GetApartment():GetConfigID()

		arg1_97:SwitchCharacterSkin(var0_97, arg0_97.session.ikSwitchSkinId)

		arg0_97.session.ikSwitchSkinId = nil
	end

	arg0_97:ClearIKStatusRuntime(arg1_97, arg2_97)
end

function var0_0.BuildIKReturnInfo(arg0_98, arg1_98)
	assert(type(arg1_98) == "table", "Invalid IK return info")
	assert(type(arg1_98.character_action) == "string", "Invalid IK return character_action")
	assert(arg1_98.character_position == nil or type(arg1_98.character_position) == "string" and arg1_98.character_position ~= "", "Invalid IK return character_position")

	local var0_98 = arg1_98.character_position or arg0_98:GetLadyBaseZone(arg0_98:GetApartment():GetConfigID())

	assert(type(var0_98) == "string" and var0_98 ~= "", "Invalid IK return character_position")

	local var1_98 = arg0_98:GetIKPointByName(var0_98) or arg0_98:GetZoneByName(var0_98)

	assert(var1_98 and var1_98:Find("StayPoint"), "Missing IK return character position: " .. var0_98)

	return {
		character_position = var0_98,
		character_action = arg1_98.character_action
	}
end

function var0_0.ApplyIKReturn(arg0_99, arg1_99, arg2_99, arg3_99, arg4_99)
	arg3_99 = arg0_99:WrapCallbackOnce(arg3_99)

	arg0_99:Emit(Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM, arg1_99, arg2_99.character_action)
	onNextTick(function()
		if arg4_99 and not arg0_99:IsIKTransitionActive(arg4_99, var0_0.MODE_STATE.EXITING) then
			return
		end

		arg0_99:Emit(Dorm3dRoomTemplateScene.EXTRA_CHANGE_CHARACTER_POSITION, arg1_99, arg2_99.character_position)
		arg0_99:Emit(Dorm3dRoomTemplateScene.EXTRA_TRIGGER_LADY_DISTANCE)
		arg0_99:Emit(Dorm3dRoomTemplateScene.EXTRA_CHECK_IN_SECTOR)
		existCall(arg3_99)
	end)
end

function var0_0.SaveIKTimelineColliderState(arg0_101, arg1_101)
	arg0_101.session.ikTimelineColliderStates = arg0_101.session.ikTimelineColliderStates or {}

	if arg0_101.session.ikTimelineColliderStates[arg1_101] == nil then
		arg0_101.session.ikTimelineColliderStates[arg1_101] = isActive(arg1_101)
	end
end

function var0_0.SetIKTimelineColliderActive(arg0_102, arg1_102, arg2_102)
	arg0_102:SaveIKTimelineColliderState(arg1_102)
	setActive(arg1_102, arg2_102)
end

function var0_0.RestoreIKTimelineColliders(arg0_103)
	if not arg0_103.session.ikTimelineColliderStates then
		return
	end

	for iter0_103, iter1_103 in pairs(arg0_103.session.ikTimelineColliderStates) do
		if iter0_103 and not IsNil(iter0_103) then
			setActive(iter0_103, iter1_103)
		end
	end

	arg0_103.session.ikTimelineColliderStates = nil
end

function var0_0.ClearIKTimelineRuntime(arg0_104)
	if not arg0_104:IsInIKTimelineMode() and not arg0_104.session.ikTimelineColliderStates then
		return
	end

	arg0_104:SetCurrentIkTimelineStatus(nil)

	arg0_104.session.enableIKTip = false

	arg0_104:CancelControlInput()
	arg0_104:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, false)
	arg0_104.session:ClearBlocks()
	arg0_104.driver:Detach()
	arg0_104.session:ClearRuntime()
	arg0_104:RestoreIKTimelineColliders()
	arg0_104:Emit(RoomTouchSystem.SET_ACTIVE_IK_TOUCH_DATA, nil)
	arg0_104:Emit(Dorm3dIKView.SET_TIPS_ACTIVE, false)
end

function var0_0.SetIKTimelineStatus(arg0_105, arg1_105, arg2_105, arg3_105, arg4_105)
	arg4_105 = arg0_105:WrapCallbackOnce(arg4_105)

	if not arg0_105:CheckIkTimelineStatus(arg2_105) then
		existCall(arg4_105)

		return
	end

	local var0_105 = arg0_105.sessionBuilder:BuildTimeline(arg1_105, arg2_105, arg3_105, function(arg0_106)
		arg0_105:OnTimelineIKLayerAction(arg0_106)
	end)

	arg0_105:ValidateIKSpec(var0_105)

	if arg0_105:IsInIKTimelineMode() then
		arg0_105:ClearIKTimelineRuntime()
	else
		assert(arg0_105.modeState == var0_0.MODE_STATE.IDLE, string.format("Cannot enter timeline IK from state: %s", tostring(arg0_105.modeState)))
	end

	warning("Set IKStatus " .. (arg2_105 or "NIL"))
	arg0_105:ActivateIKSession(var0_105, function()
		_.each(var0_105.colliderChanges, function(arg0_108)
			arg0_105:SetIKTimelineColliderActive(arg0_108.target, arg0_108.active)
		end)
	end)
	arg0_105:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, true)
	existCall(arg4_105)
end

function var0_0.ExitIKTimelineStatus(arg0_109, arg1_109)
	arg1_109 = arg0_109:WrapCallbackOnce(arg1_109)

	if not arg0_109:IsInIKTimelineMode() then
		existCall(arg1_109)

		return
	end

	arg0_109:ClearIKTimelineRuntime()
	existCall(arg1_109)
end

function var0_0.SetCurrentIkTimelineStatus(arg0_110, arg1_110)
	arg0_110.session.currentIkTimelineStatus = arg1_110
end

function var0_0.CheckIkTimelineStatus(arg0_111, arg1_111)
	if not arg0_111.session.currentIkTimelineStatus then
		return true
	end

	return arg0_111.session.currentIkTimelineStatus ~= arg1_111
end

function var0_0.IsInIKTimelineMode(arg0_112)
	return arg0_112.session.mode == "timeline"
end

function var0_0.IsIKModeActive(arg0_113)
	return arg0_113.modeState == var0_0.MODE_STATE.ACTIVE
end

function var0_0.CanHandleIKInput(arg0_114)
	return arg0_114:IsIKModeActive() or arg0_114:IsInIKTimelineMode()
end

function var0_0.EnableIKLayer(arg0_115, arg1_115)
	local var0_115 = arg0_115:GetCurrentLadyEnv()

	if #arg1_115:GetHeadTrackPath() > 0 then
		arg0_115:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK, var0_115, {
			2,
			arg1_115:GetHeadTrackPath()
		}, true)
	end

	local var1_115 = arg1_115:GetTriggerFaceAnim()

	if #var1_115 > 0 then
		arg0_115:Emit(Dorm3dRoomTemplateScene.EXTRA_PLAY_FACE_ANIM, var0_115, var1_115)
	end

	if not arg1_115.ignoreDrag then
		arg0_115:Emit(Dorm3dIKView.PLAY_HAND_BEGIN)
	end

	if not arg0_115:IsInIKTimelineMode() then
		local var2_115 = arg0_115.session.currentIkConfig

		assert(var2_115, "Missing current IK config")
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_115:GetApartment().configId, arg0_115:GetApartment().level, var2_115.character_action, arg1_115:GetTriggerParams()[2], arg0_115:GetRoom():GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_116, arg1_116)
	local var0_116 = arg0_116:GetCurrentLadyEnv()

	if not arg0_116:IsInIKTimelineMode() and #arg1_116:GetHeadTrackPath() > 0 then
		local var1_116 = arg0_116.session.currentIkConfig

		assert(var1_116, "Missing current IK config")
		arg0_116:Emit(Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK, var0_116, var1_116.head_track)
	end

	if not arg1_116.ignoreDrag then
		arg0_116:Emit(Dorm3dIKView.PLAY_HAND_END)
	end
end

function var0_0.ResetIKTipTimer(arg0_117)
	if not arg0_117.session.enableIKTip then
		return
	end

	arg0_117.session.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.PlayTouchIKMove(arg0_118, arg1_118, arg2_118, arg3_118, arg4_118, arg5_118)
	arg5_118 = arg0_118:WrapCallbackOnce(arg5_118)

	assert(arg0_118:IsIKModeActive(), "Touch IK move requires active IK")
	assert(type(arg2_118) == "table" and #arg2_118 == 2, "Invalid touch IK move point: " .. tostring(arg1_118))
	assert(type(arg3_118) == "number", "Invalid touch IK move step: " .. tostring(arg1_118))
	assert(type(arg4_118) == "number", "Invalid touch IK move time: " .. tostring(arg1_118))

	local var0_118 = arg0_118.session.ikSettings

	assert(var0_118, "Missing IK settings when play touch IK move")

	local var1_118 = var0_118.Colliders

	assert(var1_118, "Missing IK colliders when play touch IK move")

	local var2_118 = Dorm3dIK.New({
		configId = arg1_118
	}):GetTriggerBoneName()
	local var3_118 = var1_118[var2_118]

	assert(var3_118, "Missing IK collider: " .. tostring(var2_118))

	local var4_118 = arg0_118:GetRaycastCamera():WorldToScreenPoint(var3_118.position)

	arg0_118.driver:Reset(var2_118)
	arg0_118.driver:PlayMove(var4_118, var2_118, Vector2.New(unpack(arg2_118)), arg3_118, arg4_118, arg5_118)
end

function var0_0.OnNormalIKLayerAction(arg0_119, arg1_119)
	if not arg0_119:IsIKModeActive() then
		return
	end

	if not arg0_119.session.currentIkConfig then
		return
	end

	local var0_119 = arg0_119:GetCurrentLadyEnv()
	local var1_119 = arg1_119:GetControllerPath()
	local var2_119 = arg0_119.session.ikActionDict[var1_119]

	if not var2_119 then
		return
	end

	arg0_119.session:AcquireBlock("layer_action")

	local var3_119 = arg0_119:WrapCallbackOnce(function()
		arg0_119:ResetIKTipTimer()
		arg0_119.session:ReleaseBlock("layer_action")
	end)

	arg0_119:Emit(var0_0.ON_IK_LAYER_ACTION, var0_119, arg1_119:GetConfigID(), var2_119, var3_119)
end

function var0_0.OnTimelineIKLayerAction(arg0_121, arg1_121)
	if not arg0_121:IsInIKTimelineMode() then
		return
	end

	arg0_121:ExitIKTimelineStatus()

	local var0_121 = arg1_121:GetTimelineAction()

	if var0_121 then
		arg0_121:GetNowTimelinePlayer():TriggerEvent(var0_121)
	end
end

function var0_0.OnTriggerIK(arg0_122, arg1_122)
	if not arg0_122:CanHandleIKInput() then
		return
	end

	local var0_122 = arg0_122.session.spec

	if not var0_122 or not var0_122.onLayerAction then
		return
	end

	var0_122.onLayerAction(arg1_122)
end

function var0_0.UpdateIKTarget(arg0_123)
	if not arg0_123:CanHandleIKInput() then
		return
	end

	if not arg0_123:GetApartment() then
		return
	end

	if not arg0_123:GetCurrentLadyEnv() then
		return
	end

	if arg0_123.session.ikHandler then
		if not arg0_123.session.readyIKLayers then
			return
		end

		local var0_123 = arg0_123.session.ikHandler.screenPosition
		local var1_123 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
		local var2_123 = var0_123 - Vector2.New(var1_123.width, var1_123.height) * 0.5

		arg0_123:Emit(Dorm3dIKView.SET_HAND_POSITION, var2_123)

		if Time.time > arg0_123.session.ikNextCheckStamp then
			arg0_123.session.ikNextCheckStamp = arg0_123.session.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

			local var3_123 = _.detect(arg0_123.session.readyIKLayers, function(arg0_124)
				return arg0_124:GetControllerPath() == arg0_123.session.ikHandler.ikData:GetControllerPath()
			end)

			arg0_123:Emit(var0_0.ON_IK_STATUS_CHANGED, var3_123:GetConfigID(), var0_0.IK_STATUS.DRAG)
		end
	end

	if arg0_123.session.enableIKTip then
		if not arg0_123.session.readyIKLayers or not arg0_123.session.ikSettings then
			return
		end

		arg0_123:UpdateIKTips()
	end
end

function var0_0.UpdateIKTips(arg0_125)
	if not arg0_125.session.nextTipIKTime then
		return
	end

	local var0_125 = not arg0_125.session:IsBlocked() and Time.time > arg0_125.session.nextTipIKTime

	local function var1_125(arg0_126)
		local var0_126 = {}

		arg0_125:Emit(Dorm3dRoomTemplateScene.EXTRA_GET_SCREEN_POSITION, var0_126, arg0_126, arg0_125.session.ikSettings.CameraRaycaster.eventCamera)

		return var0_126.value
	end

	local function var2_125(arg0_127)
		return arg0_125:GetSceneItem(arg0_127)
	end

	arg0_125:Emit(Dorm3dIKView.UPDATE_TIPS, var0_125, RoomIKTipBuilder.BuildIKTips(arg0_125.session.readyIKLayers, arg0_125.session.ikSettings, var1_125), RoomIKTipBuilder.BuildTouchTips(arg0_125.session.ikTouchDatas, pg.dorm3d_ik_touch, arg0_125.session.ikSettings, var2_125, var1_125))
end

function var0_0.CycleIKCameraGroup(arg0_128)
	local var0_128 = arg0_128:GetCurrentLadyEnv()

	assert(var0_128, "Missing LadyEnv when cycle IK camera group")
	assert(arg0_128:IsIKModeActive(), "Cycle IK camera group requires active IK")
	arg0_128.driver:ResetActiveLayers()

	local var1_128 = arg0_128.session.currentIkConfig

	assert(var1_128, "Missing current IK config")

	local var2_128 = var1_128.camera_group
	local var3_128 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var2_128]
	local var4_128 = var3_128[table.indexof(var3_128, var1_128.id) % #var3_128 + 1]

	arg0_128:ReplaceIKStatus(var4_128)
end

function var0_0.SetIKSwitchSkinId(arg0_129, arg1_129)
	arg0_129.session.ikSwitchSkinId = arg1_129
end

function var0_0.SwitchIKSkin(arg0_130, arg1_130, arg2_130, arg3_130)
	assert(arg0_130:IsIKModeActive(), "Switch IK skin requires active IK")

	local var0_130 = arg0_130.session.currentIkConfig

	assert(var0_130, "Missing current IK config")

	local var1_130 = var0_130.id

	seriesAsync({
		function(arg0_131)
			arg0_130:ExitIK(arg0_131)
		end,
		function(arg0_132)
			arg1_130:SwitchCharacterSkin(arg2_130, arg3_130)
			arg0_130:EnterIK(var1_130, arg0_132)
		end
	})
end

function var0_0.ConsumeIKSpecialCall(arg0_133)
	if not arg0_133.session.ikSpecialCall then
		return false
	end

	local var0_133 = arg0_133.session.ikSpecialCall

	arg0_133.session.ikSpecialCall = nil

	existCall(var0_133)

	return true
end

return var0_0
