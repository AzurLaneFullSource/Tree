local var0_0 = class("RoomIKSystem", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.SET_IK_CONFIG = "RoomIKSystem.SET_IK_CONFIG"
var0_0.SET_IK_STATE = "RoomIKSystem.SET_IK_STATE"
var0_0.ON_BEGIN_DRAG_CHARACTER_BODY = "RoomIKSystem.ON_BEGIN_DRAG_CHARACTER_BODY"
var0_0.ON_DRAG_CHARACTER_BODY = "RoomIKSystem.ON_DRAG_CHARACTER_BODY"
var0_0.ON_RELEASE_CHARACTER_BODY = "RoomIKSystem.ON_RELEASE_CHARACTER_BODY"
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
var0_0.IK_STATUS_DELTA = 0.5
var0_0.IK_TIP_WAIT_TIME = 5
var0_0.IK_STATUS = {
	RELEASE = 3,
	BEGIN = 1,
	TRIGGER = 4,
	DRAG = 2
}

function var0_0.OnInit(arg0_1)
	arg0_1:RegisterIKFunc()
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.SET_IK_CONFIG, function(arg0_3, arg1_3, arg2_3)
		arg0_2:SwitchIKConfig(arg1_3, arg2_3)
	end)
	arg0_2:Bind(var0_0.SET_IK_STATE, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_2:SetIKState(arg1_4, arg2_4, arg3_4)
	end)
	arg0_2:Bind(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_2:OnBeginDragCharacterBody(arg1_5, arg2_5, arg3_5)
	end)
	arg0_2:Bind(var0_0.ON_DRAG_CHARACTER_BODY, function(arg0_6, arg1_6, arg2_6)
		arg0_2:OnDragCharacterBody(arg1_6, arg2_6)
	end)
	arg0_2:Bind(var0_0.ON_RELEASE_CHARACTER_BODY, function(arg0_7, arg1_7)
		arg0_2:OnReleaseCharacterBody(arg1_7)
	end)
	arg0_2:Bind(var0_0.SET_IK_TIMELINE_STATUS, function(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8)
		arg0_2:SetIKTimelineStatus(arg1_8, arg2_8, arg3_8, arg4_8, arg5_8)
	end)
	arg0_2:Bind(var0_0.EXIT_IK_TIMELINE_STATUS, function(arg0_9, arg1_9, arg2_9)
		arg0_2:ExitIKTimelineStatus(arg1_9, arg2_9)
	end)
	arg0_2:Bind(var0_0.CYCLE_IK_CAMERA_GROUP, function()
		arg0_2:CycleIKCameraGroup()
	end)
	arg0_2:Bind(var0_0.SET_IK_SPECIAL_CALL, function(arg0_11, arg1_11)
		arg0_2.ikSpecialCall = arg1_11
	end)
	arg0_2:Bind(var0_0.CONSUME_IK_SPECIAL_CALL, function(arg0_12, arg1_12)
		local var0_12 = arg0_2:ConsumeIKSpecialCall()

		if arg1_12 then
			arg1_12.consumed = var0_12
		end
	end)
	arg0_2:Bind(var0_0.GET_IK_BLOCK, function(arg0_13, arg1_13)
		if arg1_13 then
			arg1_13.blockIK = arg0_2.blockIK
		end
	end)
	arg0_2:Bind(var0_0.SET_IK_BLOCK, function(arg0_14, arg1_14)
		arg0_2.blockIK = arg1_14
	end)
	arg0_2:Bind(var0_0.RESET_IK_TIP_TIMER, function()
		arg0_2:ResetIKTipTimer()
	end)
	arg0_2:Bind(var0_0.SET_IK_SWITCH_SKIN_ID, function(arg0_16, arg1_16)
		arg0_2:SetIKSwitchSkinId(arg1_16)
	end)
	arg0_2:Bind(var0_0.SWITCH_IK_SKIN, function(arg0_17, arg1_17, arg2_17, arg3_17)
		arg0_2:SwitchIKSkin(arg1_17, arg2_17, arg3_17)
	end)
end

function var0_0.OnUpdate(arg0_18)
	arg0_18:UpdateIKTarget()
end

function var0_0.OnDispose(arg0_19)
	pg.IKMgr.GetInstance():ReleaseDrag()
	pg.IKMgr.GetInstance():UnregisterEnv()
end

function var0_0.SwitchIKConfig(arg0_20, arg1_20, arg2_20)
	warning("switchIkstatus", arg2_20)

	local var0_20 = pg.dorm3d_ik_status[arg2_20]

	local function var1_20()
		if var0_20.skin_id ~= arg1_20.skinId then
			local var0_21 = pg.dorm3d_ik_status.get_id_list_by_base[var0_20.base]
			local var1_21 = _.detect(var0_21, function(arg0_22)
				return pg.dorm3d_ik_status[arg0_22].skin_id == arg1_20.skinId
			end)

			assert(var1_21, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_20.skinId, arg2_20))

			var0_20 = pg.dorm3d_ik_status[var1_21]
		end
	end

	if type(var0_20.skin_id) == "table" then
		if not table.contains(var0_20.skin_id, arg1_20.skinId) then
			var1_20()
		end
	else
		var1_20()
	end

	arg1_20.ikConfig = var0_20
end

function var0_0.SetIKState(arg0_23, arg1_23, arg2_23, arg3_23)
	arg3_23 = arg3_23 or {}

	local var0_23 = arg0_23:GetCurrentLadyEnv()
	local var1_23 = {}

	if arg1_23 then
		table.insert(var1_23, function(arg0_24)
			arg0_23:Func("SetBlackboardValue", var0_23, "inIK", true)
			arg0_23:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)

			local var0_24 = var0_23.ikConfig.camera_group

			arg0_23:Emit(Dorm3dIKView.SET_CAMERA_BUTTON_ACTIVE, #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_24] > 1)
			arg0_23:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, true)
			arg0_24()
		end)

		if arg0_23:Get("uiState") ~= "ik" then
			table.insert(var1_23, function(arg0_25)
				arg0_23:Func("SetUI", arg0_25, "ik")
			end)
		end

		table.insert(var1_23, function(arg0_26)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_23:SetIKStatus(var0_23, var0_23.ikConfig, arg0_26, arg3_23)
		end)
		table.insert(var1_23, function(arg0_27)
			arg0_23:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
			arg0_27()
		end)
	else
		assert(arg0_23:Get("uiState") == "ik")
		table.insert(var1_23, function(arg0_28)
			arg0_23:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, false)
			arg0_23:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_28()
		end)
		table.insert(var1_23, function(arg0_29)
			arg0_23:ExitIKStatus(var0_23, var0_23.ikConfig, arg0_29, arg3_23)
			arg0_23:Func("ResetSceneItemAnimators")
		end)
		table.insert(var1_23, function(arg0_30)
			arg0_23:Func("SetUI", arg0_30, "back")
		end)
		table.insert(var1_23, function(arg0_31)
			arg0_23:Func("SetBlackboardValue", var0_23, "inIK", false)
			arg0_23:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
			arg0_31()
		end)
	end

	seriesAsync(var1_23, arg2_23)
end

function var0_0.OnBeginDragCharacterBody(arg0_32, arg1_32, arg2_32, arg3_32)
	if arg0_32.blockIK then
		return
	end

	if arg1_32.ikHandler then
		return
	end

	pg.IKMgr.GetInstance():OnDragBegin(arg2_32, arg3_32)
end

function var0_0.OnDragCharacterBody(arg0_33, arg1_33, arg2_33)
	if not arg1_33.ikHandler then
		return
	end

	pg.IKMgr.GetInstance():HandleBodyDrag(arg2_33)
end

function var0_0.OnReleaseCharacterBody(arg0_34, arg1_34)
	pg.IKMgr.GetInstance():ReleaseDrag()
end

function var0_0.RegisterIKFunc(arg0_35)
	pg.IKMgr.GetInstance():RegisterOnIKLayerActive(function(arg0_36)
		arg0_35.blockIK = true

		local var0_36 = arg0_35:GetCurrentLadyEnv()

		var0_36.ikHandler = arg0_36

		local var1_36 = _.detect(var0_36.readyIKLayers, function(arg0_37)
			return arg0_37:GetControllerPath() == arg0_36.ikData:GetControllerPath()
		end)

		arg0_35:EnableIKLayer(var1_36)

		arg0_35.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

		arg0_35:Emit(var0_0.ON_IK_STATUS_CHANGED, var1_36:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDrag(function(arg0_38)
		arg0_35:GetCurrentLadyEnv().ikHandler = arg0_38

		arg0_35:ResetIKTipTimer()
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_39, arg1_39)
		local var0_39 = arg0_35:GetCurrentLadyEnv()
		local var1_39 = _.detect(var0_39.readyIKLayers, function(arg0_40)
			return arg0_40:GetControllerPath() == arg0_39.ikData:GetControllerPath()
		end)

		arg0_35:DeactiveIKLayer(var1_39)

		var0_39.ikHandler = nil
		arg0_35.blockIK = arg1_39

		arg0_35:Emit(var0_0.ON_IK_STATUS_CHANGED, var1_39:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_41)
		local var0_41 = arg0_35:GetCurrentLadyEnv()

		arg0_35.blockIK = nil

		local var1_41 = _.detect(var0_41.readyIKLayers, function(arg0_42)
			return arg0_42:GetControllerPath() == arg0_41.ikData:GetControllerPath()
		end)

		arg0_35:OnTriggerIK(var1_41)
		arg0_35:Emit(var0_0.ON_IK_STATUS_CHANGED, var1_41:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	end)
end

function var0_0.SetIKStatus(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	warning("Set IKStatus " .. (arg2_43.id or "NIL"))

	arg0_43.enableIKTip = true

	arg0_43:ResetIKTipTimer()
	setActive(arg1_43.ladyCollider, false)
	_.each(arg1_43.ladyTouchColliders, function(arg0_44)
		setActive(arg0_44, true)
	end)

	arg0_43.blockIK = nil

	arg0_43:Emit(RoomTouchSystem.CANCEL_TOUCH_PRESS)

	arg1_43.currentIkStatus = arg2_43.id
	arg1_43.ikActionDict = {}
	arg1_43.readyIKLayers = {}
	arg1_43.iKTouchDatas = arg2_43.touch_data

	arg0_43:Emit(RoomTouchSystem.VALIDATE_TOUCH_CONFIGS, arg1_43.iKTouchDatas, arg2_43.id)

	arg1_43.IKSettings = {
		Colliders = arg1_43.ladyColliders,
		CameraRaycaster = arg0_43:Get("sceneRaycaster")
	}

	local var0_43 = table.shallowCopy(arg2_43.ik_id)
	local var1_43 = {}

	_.each(arg1_43.iKTouchDatas, function(arg0_45)
		local var0_45 = arg0_45[3]

		if var0_45[1] == 7 then
			local var1_45 = pg.dorm3d_ik_touch_move[var0_45[2]]
			local var2_45 = var1_45.target_ik

			if not _.detect(var0_43, function(arg0_46)
				return arg0_46[1] == var2_45
			end) then
				var1_43[var2_45] = {
					back_time = var1_45.back_time
				}

				local var3_45 = {
					var2_45,
					0,
					{}
				}

				if var1_45.trigger_dialogue > 0 then
					var3_45[3] = {
						4,
						0,
						var1_45.trigger_dialogue
					}
				end

				table.insert(var0_43, var3_45)
			end
		end
	end)

	local var2_43 = _.map(var0_43, function(arg0_47)
		local var0_47 = Dorm3dIK.New({
			configId = arg0_47[1]
		})
		local var1_47 = arg0_47[3]
		local var2_47 = var1_47[1]
		local var3_47 = switch(var2_47, {
			function(arg0_48, arg1_48)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_50, arg1_50)
				return arg0_50
			end,
			function(arg0_51, arg1_51)
				return arg0_51
			end,
			function(arg0_52, arg1_52, arg2_52, arg3_52)
				return arg0_52
			end,
			function(arg0_53)
				return 0
			end
		}, function(arg0_54)
			return type(arg0_54) == "number" and arg0_54 or 0
		end, unpack(var1_47, 2))

		table.insert(arg1_43.readyIKLayers, var0_47)

		arg1_43.ikActionDict[var0_47:GetControllerPath()] = var1_47

		local var4_47 = var0_47:GetRevertTime()
		local var5_47 = var1_43[var0_47:GetConfigID()]
		local var6_47 = tobool(var5_47)

		if var6_47 then
			var3_47 = var5_47.back_time
			var4_47 = var5_47.back_time
			var0_47.ignoreDrag = true
		end

		local var7_47 = var0_47:GetSubTargets()
		local var8_47 = var0_47:GetPlaneRotations()
		local var9_47 = var0_47:GetPlaneScales()
		local var10_47 = _.map(_.range(#var7_47), function(arg0_55)
			return {
				name = var7_47[arg0_55][1],
				planeRot = var8_47[arg0_55],
				planeScale = var9_47[arg0_55]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_47:getConfig("trigger_param")[2],
			controllerName = var0_47:GetControllerPath(),
			subTargets = var10_47,
			actionType = var0_47:GetActionTriggerParams()[1],
			controlRect = var0_47:GetRect(),
			actionRect = var0_47:GetTriggerRect(),
			backTime = var4_47,
			actionRevertTime = var3_47,
			ignoreDrag = var6_47
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_43.ladyIKRoot, arg1_43.ladyBoneMaps)
	arg0_43:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_43)

	local var3_43 = {}

	_.each(arg1_43.iKTouchDatas, function(arg0_56)
		local var0_56 = arg0_56[1]
		local var1_56 = pg.dorm3d_ik_touch[var0_56]

		if #var1_56.scene_item == 0 then
			return
		end

		if var3_43[var1_56.scene_item] then
			return
		end

		var3_43[var1_56.scene_item] = true

		local var2_56 = arg0_43:GetSceneItem(var1_56.scene_item)

		if not var2_56 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", var0_56, var1_56.scene_item))

			return
		end

		if IsNil(GetComponent(var2_56, typeof(UnityEngine.Collider))) then
			go(var2_56):AddComponent(typeof(UnityEngine.BoxCollider))
		end
	end)

	arg0_43:Get("camBrain").enabled = false

	if arg0_43:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH] then
		setActive(arg0_43:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH], false)

		arg0_43:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH] = nil
	end

	local var4_43 = arg0_43:Get("cameraRoot"):Find(arg2_43.ik_camera)

	assert(var4_43, "Missing IKCamera")

	arg0_43:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH] = var4_43

	arg0_43:Func("ActiveCamera", arg0_43:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH])

	arg0_43:Get("camBrain").enabled = true

	local var5_43 = var4_43:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_43 then
		arg0_43:Func("RegisterOrbits", var5_43)
	else
		arg0_43:Func("RevertCameraOrbit")
	end

	arg0_43:Func("SwitchAnim", arg1_43, arg2_43.character_action)
	arg0_43:SettingHeadAimIK(arg1_43, arg2_43.head_track)
	arg1_43:EnableCloth(false)
	arg1_43:EnableCloth(arg2_43.use_cloth, arg2_43.cloth_colliders)
	arg0_43:Func("PlayEnterSceneAnim", arg2_43.enter_scene_anim)
	arg0_43:Func("PlayEnterExtraItem", arg1_43, arg2_43.enter_extra_item)
	arg0_43:Func("HideSceneItem", arg1_43, arg2_43.hide_scene_item)
	arg0_43:Emit(Dorm3dIKView.UPDATE_TEXT_TIPS, arg1_43.readyIKLayers)
	onNextTick(function()
		local var0_57 = arg0_43:Get("furnitures"):Find(arg2_43.character_position)

		arg1_43.lady.position = var0_57:Find("StayPoint").position
		arg1_43.lady.rotation = var0_57:Find("StayPoint").rotation

		existCall(arg3_43)
	end)
end

function var0_0.ExitIKStatus(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58)
	arg0_58.enableIKTip = false

	if arg0_58.ikSwitchSkinId then
		local var0_58 = arg0_58:Get("apartment"):GetConfigID()

		arg1_58:SwitchCharacterSkin(var0_58, arg0_58.ikSwitchSkinId)

		arg0_58.ikSwitchSkinId = nil
	end

	setActive(arg1_58.ladyCollider, true)
	_.each(arg1_58.ladyTouchColliders, function(arg0_59)
		setActive(arg0_59, false)
	end)

	arg0_58.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_58.ikHandler = nil

	arg0_58:Emit(Dorm3dIKView.SET_TIPS_ACTIVE, false)
	arg0_58:Emit(RoomTouchSystem.CANCEL_TOUCH_PRESS)

	arg1_58.currentIkStatus = nil
	arg1_58.ikActionDict = nil
	arg1_58.readyIKLayers = nil
	arg1_58.iKTouchDatas = nil

	arg0_58:Func("RevertCameraOrbit")
	setActive(arg0_58:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH], false)

	arg0_58:Get("cameras")[Dorm3dRoomTemplateScene.CAMERA.IK_WATCH] = nil

	arg1_58:EnableCloth(false)
	arg0_58:ResetHeadAimIK(arg1_58)
	arg0_58:Func("SwitchAnim", arg1_58, arg2_58.character_action)
	arg0_58:Func("ResetSceneItemAnimators")

	if not arg4_58.ignoreResetExtraItem then
		arg0_58:Func("ResetCharacterExtraItem", arg1_58)
		arg0_58:Func("ResetTempHideSceneItems", arg1_58)
	end

	onNextTick(function()
		if arg2_58.character_position then
			arg1_58.ladyActiveZone = arg2_58.character_position
		else
			arg1_58.ladyActiveZone = arg1_58.ladyBaseZone
		end

		arg0_58:Func("ChangeCharacterPosition", arg1_58)
		arg0_58:Func("TriggerLadyDistance")
		arg0_58:Func("CheckInSector")
		existCall(arg3_58)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_61, arg1_61, arg2_61, arg3_61, arg4_61, arg5_61)
	warning("Set IKStatus " .. (arg3_61 or "NIL"))
	arg1_61:SetCurrentIkTimelineStatus(arg3_61)

	arg0_61.enableIKTip = true

	arg0_61:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, true)
	arg0_61:ResetIKTipTimer()

	arg0_61.blockIK = nil

	local var0_61 = pg.dorm3d_ik_timeline_status[arg3_61]

	arg1_61.readyIKLayers = {}
	arg1_61.iKTouchDatas = {}
	arg1_61.IKSettings = {
		CameraRaycaster = GetOrAddComponent(arg4_61, typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_61.IKSettings.CameraRaycaster)

	local var1_61 = {}

	table.IpairsCArray(arg2_61:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_62, arg1_62)
		if arg1_62.name == "SafeCollider" then
			setActive(arg1_62, false)

			return
		end

		if arg1_62:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_62 = tf(arg1_62)
		local var1_62 = var0_62.name
		local var2_62 = var1_62 and string.find(var1_62, "Collider") or -1

		if var2_62 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var1_62)

			return
		end

		local var3_62 = string.sub(var1_62, 1, var2_62 - 1)

		if var3_62 == "Body" or var3_62 == "Safe" then
			setActive(var0_62, false)

			return
		end

		if DormConst.BONE_TO_TOUCH[var3_62] == nil then
			return
		end

		var1_61[var3_62] = var0_62

		setActive(var0_62, true)
	end)

	arg1_61.IKSettings.Colliders = var1_61
	arg1_61.ikTimelineMode = true

	local var2_61 = _.map(var0_61.ik_id, function(arg0_63)
		local var0_63 = Dorm3dIK.New({
			configId = arg0_63
		})

		table.insert(arg1_61.readyIKLayers, var0_63)

		local var1_63 = var0_63:GetSubTargets()
		local var2_63 = var0_63:GetPlaneRotations()
		local var3_63 = var0_63:GetPlaneScales()
		local var4_63 = _.map(_.range(#var1_63), function(arg0_64)
			return {
				name = var1_63[arg0_64][1],
				planeRot = var2_63[arg0_64],
				planeScale = var3_63[arg0_64]
			}
		end)

		return Dorm3dIKController.New({
			ignoreDrag = false,
			triggerName = var0_63:getConfig("trigger_param")[2],
			controllerName = var0_63:GetControllerPath(),
			subTargets = var4_63,
			actionType = var0_63:GetActionTriggerParams()[1],
			controlRect = var0_63:GetRect(),
			actionRect = var0_63:GetTriggerRect(),
			backTime = var0_63:GetRevertTime(),
			actionRevertTime = var0_63:GetActionRevertTime(),
			timelineActionEvent = var0_63:GetTimelineAction()
		})
	end)
	local var3_61 = arg2_61.transform:Find("IKLayers")
	local var4_61 = {}
	local var5_61 = {}

	table.Foreach(DormConst.boneMap, function(arg0_65, arg1_65)
		var5_61[arg1_65] = arg0_65
	end)

	local var6_61 = arg2_61.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var6_61, function(arg0_66, arg1_66)
		if var5_61[arg1_66.name] then
			var4_61[var5_61[arg1_66.name]] = arg1_66
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var3_61, var4_61)
	arg0_61:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_61)
	arg0_61:Emit(Dorm3dIKView.UPDATE_TEXT_TIPS, arg1_61.readyIKLayers)
	existCall(arg5_61)
end

function var0_0.ExitIKTimelineStatus(arg0_67, arg1_67, arg2_67)
	arg1_67:SetCurrentIkTimelineStatus(nil)

	arg0_67.enableIKTip = false

	arg0_67:Emit(Dorm3dIKView.SET_CONTROL_ACTIVE, false)

	arg0_67.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_67.ikHandler = nil
	arg1_67.ikTimelineMode = nil
	arg1_67.readyIKLayers = nil
	arg1_67.iKTouchDatas = nil
	arg1_67.IKSettings = nil

	arg0_67:Emit(Dorm3dIKView.SET_TIPS_ACTIVE, false)
	existCall(arg2_67)
end

function var0_0.EnableIKLayer(arg0_68, arg1_68)
	local var0_68 = arg0_68:GetCurrentLadyEnv()

	if #arg1_68:GetHeadTrackPath() > 0 then
		arg0_68:SettingHeadAimIK(var0_68, {
			2,
			arg1_68:GetHeadTrackPath()
		}, true)
	end

	local var1_68 = arg1_68:GetTriggerFaceAnim()

	if #var1_68 > 0 then
		arg0_68:Func("PlayFaceAnim", var0_68, var1_68)
	end

	if not arg1_68.ignoreDrag then
		arg0_68:Emit(Dorm3dIKView.PLAY_HAND_BEGIN)
	end

	if not var0_68.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_68:Get("apartment").configId, arg0_68:Get("apartment").level, var0_68.ikConfig.character_action, arg1_68:GetTriggerParams()[2], arg0_68:GetRoom():GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_69, arg1_69)
	local var0_69 = arg0_69:GetCurrentLadyEnv()

	if not var0_69.ikTimelineMode and #arg1_69:GetHeadTrackPath() > 0 then
		arg0_69:SettingHeadAimIK(var0_69, var0_69.ikConfig.head_track)
	end

	if not arg1_69.ignoreDrag then
		arg0_69:Emit(Dorm3dIKView.PLAY_HAND_END)
	end
end

function var0_0.ResetIKTipTimer(arg0_70)
	if not arg0_70.enableIKTip then
		return
	end

	arg0_70.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_71, arg1_71)
	local var0_71 = arg0_71:GetCurrentLadyEnv()

	arg0_71:EnableHeadIK(var0_71, arg1_71)
end

function var0_0.EnableHeadIK(arg0_72, arg1_72, arg2_72)
	arg1_72.ladyHeadIKComp.enableIk = arg2_72
end

function var0_0.SettingHeadAimIK(arg0_73, arg1_73, arg2_73, arg3_73)
	local var0_73

	if arg2_73[1] == 0 then
		arg0_73:EnableHeadIK(arg1_73, false)

		return
	elseif arg2_73[1] == 1 then
		arg0_73:EnableHeadIK(arg1_73, true)

		var0_73 = arg0_73:Get("mainCameraTF"):Find("AimTarget")
	elseif arg2_73[1] == 2 then
		arg0_73:EnableHeadIK(arg1_73, true)
		table.IpairsCArray(arg1_73.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_74, arg1_74)
			if arg1_74.name ~= arg2_73[2] then
				return
			end

			var0_73 = arg1_74
		end)
	end

	arg1_73.ladyHeadIKComp.AimTarget = var0_73

	if not arg3_73 and arg2_73[3] then
		arg1_73.ladyHeadIKComp.BodyWeight = arg2_73[3]
	end

	if not arg3_73 and arg2_73[4] then
		arg1_73.ladyHeadIKComp.HeadWeight = arg2_73[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_75, arg1_75)
	arg0_75:EnableHeadIK(arg1_75, true)

	arg1_75.ladyHeadIKComp.AimTarget = arg0_75:Get("mainCameraTF"):Find("AimTarget")
	arg1_75.ladyHeadIKComp.HeadWeight = arg1_75.ladyHeadIKData.HeadWeight
	arg1_75.ladyHeadIKComp.BodyWeight = arg1_75.ladyHeadIKData.BodyWeight
end

function var0_0.OnTriggerIK(arg0_76, arg1_76)
	local var0_76 = arg0_76:GetCurrentLadyEnv()

	if var0_76.ikTimelineMode then
		arg0_76:ExitIKTimelineStatus(var0_76)

		local var1_76 = arg1_76:GetTimelineAction()

		if var1_76 then
			arg0_76:Get("nowTimelinePlayer"):TriggerEvent(var1_76)
		end

		return
	end

	if not var0_76.ikConfig then
		return
	end

	local var2_76 = arg1_76:GetControllerPath()
	local var3_76 = var0_76.ikActionDict[var2_76]

	if not var3_76 then
		return
	end

	arg0_76.blockIK = true

	arg0_76:Emit(var0_0.ON_IK_LAYER_ACTION, var0_76, arg1_76:GetConfigID(), var3_76, function()
		arg0_76:ResetIKTipTimer()

		arg0_76.blockIK = nil
	end)
end

function var0_0.UpdateIKTarget(arg0_78)
	if not arg0_78:Get("apartment") then
		return
	end

	local var0_78 = arg0_78:GetCurrentLadyEnv()

	if not var0_78 then
		return
	end

	if var0_78.ikHandler then
		if not var0_78.readyIKLayers then
			return
		end

		local var1_78 = var0_78.ikHandler.screenPosition
		local var2_78 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
		local var3_78 = var1_78 - Vector2.New(var2_78.width, var2_78.height) * 0.5

		arg0_78:Emit(Dorm3dIKView.SET_HAND_POSITION, var3_78)

		if Time.time > arg0_78.ikNextCheckStamp then
			arg0_78.ikNextCheckStamp = arg0_78.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

			local var4_78 = _.detect(var0_78.readyIKLayers, function(arg0_79)
				return arg0_79:GetControllerPath() == var0_78.ikHandler.ikData:GetControllerPath()
			end)

			arg0_78:Emit(var0_0.ON_IK_STATUS_CHANGED, var4_78:GetConfigID(), var0_0.IK_STATUS.DRAG)
		end
	end

	if arg0_78.enableIKTip then
		if not var0_78.readyIKLayers or not var0_78.IKSettings then
			return
		end

		arg0_78:UpdateIKTips(var0_78)
	end
end

function var0_0.UpdateIKTips(arg0_80, arg1_80)
	if not arg0_80.nextTipIKTime then
		return
	end

	local var0_80 = not arg0_80.blockIK and Time.time > arg0_80.nextTipIKTime

	arg0_80:Emit(Dorm3dIKView.UPDATE_TIPS, var0_80, arg1_80)
end

function var0_0.CycleIKCameraGroup(arg0_81)
	local var0_81 = arg0_81:GetCurrentLadyEnv()

	assert(arg0_81:Func("GetBlackboardValue", var0_81, "inIK"))
	seriesAsync({
		function(arg0_82)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_82 = var0_81.ikConfig
			local var1_82 = var0_82.camera_group
			local var2_82 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_82]
			local var3_82 = var2_82[table.indexof(var2_82, var0_82.id) % #var2_82 + 1]

			arg0_81:SwitchIKConfig(var0_81, var3_82)
			arg0_81:SetIKState(true)
		end
	})
end

function var0_0.SetIKSwitchSkinId(arg0_83, arg1_83)
	arg0_83.ikSwitchSkinId = arg1_83
end

function var0_0.SwitchIKSkin(arg0_84, arg1_84, arg2_84, arg3_84)
	seriesAsync({
		function(arg0_85)
			arg0_84:SetIKState(false, arg0_85)
		end,
		function(arg0_86)
			arg1_84:SwitchCharacterSkin(arg2_84, arg3_84)
			arg0_84:SwitchIKConfig(arg1_84, arg1_84.ikConfig.id)
			arg0_84:SetIKState(true, arg0_86)
		end
	})
end

function var0_0.ConsumeIKSpecialCall(arg0_87)
	if not arg0_87.ikSpecialCall then
		return false
	end

	local var0_87 = arg0_87.ikSpecialCall

	arg0_87.ikSpecialCall = nil

	existCall(var0_87)

	return true
end

return var0_0
