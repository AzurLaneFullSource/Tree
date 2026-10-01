local var0_0 = class("Dorm3dRoomTemplateScene", import("view.dorm3d.Core.Dorm3dBaseScene"))

var0_0.CAMERA = {
	GIFT = 8,
	PHOTO_FREE = 11,
	TALK = 4,
	PHOTO = 10,
	POV = 12,
	IK_WATCH = 13,
	CUSTOM = 15,
	ROLE = 3,
	AIM = 1,
	ROLE2 = 9,
	FURNITURE_WATCH = 7,
	SKIN = 14,
	AIM2 = 2
}
var0_0.CAMERA_MAX_OPERATION = {
	RIGHT = "right",
	DOWN = "donw",
	ZOOMIN = "zoom_in",
	ZOOMOUT = "zoom_out",
	UP = "up",
	LEFT = "left"
}
var0_0.ANIM = {
	IDLE = "Idle"
}
var0_0.PLAY_EXPRESSION = "Dorm3dRoomTemplateScene.PLAY_EXPRESSION"
var0_0.SHOW_BLOCK = "Dorm3dRoomTemplateScene.SHOW_BLOCK"
var0_0.HIDE_BLOCK = "Dorm3dRoomTemplateScene.HIDE_BLOCK"
var0_0.ON_ROLEWATCH_CAMERA_MAX = "Dorm3dRoomTemplateScene.ON_ROLEWATCH_CAMERA_MAX"
var0_0.ON_STICK_MOVE = "Dorm3dRoomTemplateScene.ON_STICK_MOVE"
var0_0.ENABLE_SCENEBLOCK = "Dorm3dRoomTemplateScene.ENABLE_SCENEBLOCK"
var0_0.ON_POV_STICK_MOVE_BEGIN = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE_BEGIN"
var0_0.ON_POV_STICK_MOVE = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE"
var0_0.ON_POV_STICK_MOVE_END = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE_END"
var0_0.ON_POV_STICK_VIEW = "Dorm3dRoomTemplateScene.ON_POV_STICK_VIEW"
var0_0.ON_ENTER_SECTOR = "Dorm3dRoomTemplateScene.ON_ENTER_SECTOR"
var0_0.ON_CHANGE_DISTANCE = "Dorm3dRoomTemplateScene.ON_CHANGE_DISTANCE"
var0_0.CLICK_CHARACTER = "Dorm3dRoomTemplateScene.CLICK_CHARACTER"
var0_0.DISTANCE_TRIGGER = "Dorm3dRoomTemplateScene.DISTANCE_TRIGGER"
var0_0.WALK_DISTANCE_TRIGGER = "Dorm3dRoomTemplateScene.WALK_DISTANCE_TRIGGER"
var0_0.CHANGE_WATCH = "Dorm3dRoomTemplateScene.CHANGE_WATCH"
var0_0.PHOTO_CALL = "Dorm3dRoomTemplateScene.PHOTO_CALL"
var0_0.SHIFT_ZONE_SAFE = "Dorm3dRoomTemplateScene.SHIFT_ZONE_SAFE"
var0_0.TIMELINE_END = "Dorm3dRoomTemplateScene.TIMELINE_END"
var0_0.TRIGGER_TIMELINE_PLAYER_EVENT = "Dorm3dRoomTemplateScene.TRIGGER_TIMELINE_PLAYER_EVENT"
var0_0.EXTRA_GET_SCREEN_POSITION = "Dorm3dRoomTemplateScene.EXTRA_GET_SCREEN_POSITION"
var0_0.EXTRA_CHANGE_PLAYER_POSITION = "Dorm3dRoomTemplateScene.EXTRA_CHANGE_PLAYER_POSITION"
var0_0.EXTRA_CHANGE_CHARACTER_POSITION = "Dorm3dRoomTemplateScene.EXTRA_CHANGE_CHARACTER_POSITION"
var0_0.EXTRA_ACTIVE_CAMERA = "Dorm3dRoomTemplateScene.EXTRA_ACTIVE_CAMERA"
var0_0.EXTRA_ACTIVE_CAMERA_BY_NAME = "Dorm3dRoomTemplateScene.EXTRA_ACTIVE_CAMERA_BY_NAME"
var0_0.EXTRA_REGISTER_ORBITS = "Dorm3dRoomTemplateScene.EXTRA_REGISTER_ORBITS"
var0_0.EXTRA_REVERT_CAMERA_ORBIT = "Dorm3dRoomTemplateScene.EXTRA_REVERT_CAMERA_ORBIT"
var0_0.EXTRA_PLAY_ENTER_SCENE_ANIM = "Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_SCENE_ANIM"
var0_0.EXTRA_PLAY_ENTER_EXTRA_ITEM = "Dorm3dRoomTemplateScene.EXTRA_PLAY_ENTER_EXTRA_ITEM"
var0_0.EXTRA_HIDE_SCENE_ITEM = "Dorm3dRoomTemplateScene.EXTRA_HIDE_SCENE_ITEM"
var0_0.EXTRA_RESET_SCENE_ITEM_ANIMATORS = "Dorm3dRoomTemplateScene.EXTRA_RESET_SCENE_ITEM_ANIMATORS"
var0_0.EXTRA_RESET_CHARACTER_EXTRA_ITEM = "Dorm3dRoomTemplateScene.EXTRA_RESET_CHARACTER_EXTRA_ITEM"
var0_0.EXTRA_RESET_TEMP_HIDE_SCENE_ITEMS = "Dorm3dRoomTemplateScene.EXTRA_RESET_TEMP_HIDE_SCENE_ITEMS"
var0_0.EXTRA_SET_BLACKBOARD_VALUE = "Dorm3dRoomTemplateScene.EXTRA_SET_BLACKBOARD_VALUE"
var0_0.EXTRA_SWITCH_ANIM = "Dorm3dRoomTemplateScene.EXTRA_SWITCH_ANIM"
var0_0.EXTRA_SET_HEAD_AIM_IK = "Dorm3dRoomTemplateScene.EXTRA_SET_HEAD_AIM_IK"
var0_0.EXTRA_RESET_HEAD_AIM_IK = "Dorm3dRoomTemplateScene.EXTRA_RESET_HEAD_AIM_IK"
var0_0.EXTRA_PLAY_SINGLE_ACTION = "Dorm3dRoomTemplateScene.EXTRA_PLAY_SINGLE_ACTION"
var0_0.EXTRA_PLAY_FACE_ANIM = "Dorm3dRoomTemplateScene.EXTRA_PLAY_FACE_ANIM"
var0_0.EXTRA_PLAY_SCENE_ITEM_ANIM = "Dorm3dRoomTemplateScene.EXTRA_PLAY_SCENE_ITEM_ANIM"
var0_0.EXTRA_SHOW_BLACK_SCREEN = "Dorm3dRoomTemplateScene.EXTRA_SHOW_BLACK_SCREEN"
var0_0.EXTRA_TRIGGER_LADY_DISTANCE = "Dorm3dRoomTemplateScene.EXTRA_TRIGGER_LADY_DISTANCE"
var0_0.EXTRA_CHECK_IN_SECTOR = "Dorm3dRoomTemplateScene.EXTRA_CHECK_IN_SECTOR"
var0_0.ART_SCENE_WILL_CHANGE = "Dorm3dRoomTemplateScene.ART_SCENE_WILL_CHANGE"
var0_0.ART_SCENE_CHANGED = "Dorm3dRoomTemplateScene.ART_SCENE_CHANGED"
var0_0.POV_CLOSE_DISTANCE = 1.5
var0_0.POV_PENDING_CLOSE_DISTANCE = 2

function var0_0.getUIName(arg0_1)
	return nil
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)
	local var1_2 = getProxy(ApartmentProxy):getRoom(arg0_2.contextData.roomId)
	local var2_2, var3_2 = Dorm3dSceneMgr.ParseInfo(var1_2:getConfig("scene_info"))

	table.insert(var0_2, string.lower("dorm3d/scenesres/scenes/" .. var3_2 .. "/" .. var2_2 .. "_scene"))
	table.insert(var0_2, string.lower("dorm3d/scenesres/scenes/" .. var3_2 .. "/" .. var2_2 .. "_base_scene"))

	for iter0_2, iter1_2 in ipairs(arg0_2.contextData.groupIds) do
		local var4_2 = getProxy(ApartmentProxy):getApartment(iter1_2)
		local var5_2 = var4_2:getConfig("asset_name")
		local var6_2 = var4_2:GetSkinModelID(var1_2:getConfig("tag"))
		local var7_2 = Dorm3dSkin.New({
			configId = var6_2
		}):GetModelName()

		assert(var7_2)

		for iter2_2, iter3_2 in ipairs(Dorm3dHxHelper.GetMaterialResources(iter1_2)) do
			table.insert(var0_2, iter3_2)
		end

		table.insert(var0_2, string.lower(string.format("dorm3d/character/%s/prefabs/%s", var5_2, var7_2)))

		if var1_2:isPersonalRoom() then
			for iter4_2, iter5_2 in ipairs(var4_2:GetAllModelIds()) do
				if iter5_2 ~= var6_2 then
					local var8_2 = Dorm3dSkin.New({
						configId = iter5_2
					}):GetModelName()
					local var9_2 = string.format("dorm3d/character/%s/prefabs/%s", var5_2, var8_2)

					if checkABExist(var9_2) then
						table.insert(var0_2, string.lower(var9_2))
					end
				end
			end
		end

		local var10_2 = arg0_2.contextData.pendingDic and arg0_2.contextData.pendingDic[iter1_2]

		if var10_2 then
			local var11_2 = pg.dorm3d_welcome[var10_2]

			if var11_2.item_prefab ~= "" then
				table.insert(var0_2, string.lower("dorm3d/furniture/item/" .. var11_2.item_prefab))
			end
		end
	end

	return var0_2
end

function var0_0.forceGC(arg0_3)
	return true
end

function var0_0.loadingQueue(arg0_4)
	return function(arg0_5)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_6)
			return arg0_5(arg0_6)
		end)
	end
end

function var0_0.getBGM(arg0_7)
	local var0_7 = pg.dorm3d_rooms[arg0_7.contextData.roomId].room_bgm

	if var0_7 and var0_7 ~= "" then
		return var0_7
	else
		return var0_0.super.getBGM(arg0_7)
	end
end

function var0_0.Ctor(arg0_8, ...)
	var0_0.super.Ctor(arg0_8, ...)

	arg0_8.loader = AutoLoader.New()
	arg0_8.hxHelper = Dorm3dHxHelper.New(arg0_8.loader)
	arg0_8.scene = arg0_8
end

function var0_0.SetRoom(arg0_9, arg1_9)
	arg0_9.room = arg1_9
end

function var0_0.preload(arg0_10, arg1_10)
	tolua.loadassembly("MagicaClothV2")
	tolua.loadassembly("ParadoxNotion")
	tolua.loadassembly("Yongshi.BLRP.Runtime")

	for iter0_10, iter1_10 in pairs({
		_MonoManager = "ParadoxNotion.Services.MonoManager"
	}) do
		if not GameObject.Find(iter0_10) then
			local var0_10 = GameObject.New(iter0_10)

			GetOrAddComponent(var0_10, typeof(iter1_10))
		end
	end

	arg0_10.room = getProxy(ApartmentProxy):getRoom(arg0_10.contextData.roomId)

	local var1_10 = {}

	table.insert(var1_10, function(arg0_11)
		arg0_10.dormSceneMgr = Dorm3dSceneMgr.New(arg0_10.room:getConfig("scene_info"), arg0_11)
	end)
	table.insert(var1_10, function(arg0_12)
		arg0_10:LoadCharacter(arg0_10.contextData.groupIds, arg0_12)
	end)
	seriesAsync(var1_10, arg1_10)
end

function var0_0.init(arg0_13)
	arg0_13:BindEvent()
	arg0_13:InitData()
	arg0_13:initScene()
	arg0_13:initNodeCanvas()

	if arg0_13.room:isPersonalRoom() then
		local var0_13 = arg0_13.contextData.groupIds[1]
		local var1_13 = getProxy(ApartmentProxy):getApartment(var0_13):GetCurSkinId()
		local var2_13 = arg0_13.ladyDict[var0_13]

		setActive(var2_13.ladyGameObject, false)

		var2_13.skinId = var1_13
		var2_13.ladyGameObject = arg0_13.skinDict[var1_13].ladyGameObject

		setActive(var2_13.ladyGameObject, true)
	end

	for iter0_13, iter1_13 in pairs(arg0_13.ladyDict) do
		arg0_13:InitCharacter(iter1_13, iter0_13)
	end

	if not arg0_13.room:isPersonalRoom() then
		local var3_13 = underscore.detect(arg0_13.contextData.groupIds, function(arg0_14)
			return arg0_13.contextData.ladyZone[arg0_14] == arg0_13.contextData.currentZoneNodeName
		end) or arg0_13.contextData.groupIds[1]

		if var3_13 then
			arg0_13:SyncInterestTransform(arg0_13.ladyDict[var3_13])
		end

		if SlideExtraSystem.IsOpen(arg0_13.room) and arg0_13.contextData.currentZoneNodeName == SlideConst.SLIDE_ZONE then
			arg0_13:SyncInterestTransformByTf(arg0_13:GetZoneByName(arg0_13.contextData.currentZoneNodeName):Find("StayPoint"))
		end
	end

	arg0_13.retainCount = 0
	arg0_13.sceneBlockLayer = arg0_13._tf:Find("SceneBlock")

	setActive(arg0_13.sceneBlockLayer, false)

	arg0_13.blockLayer = arg0_13._tf:Find("Block")

	setActive(arg0_13.blockLayer, false)

	arg0_13.blackLayer = arg0_13._tf:Find("BlackScreen")

	setActive(arg0_13.blackLayer, false)

	arg0_13.holyLightRoot = arg0_13._tf:Find("HolyLightRoot")

	arg0_13:InitHolyLight()
	arg0_13:ChangePlayerPosition()

	arg0_13.cacheSceneDic = {}
	arg0_13.sceneGroupDic = {}
	arg0_13.lastSceneRootDict = {}

	pg.ClickEffectMgr.GetInstance():SetClickEffect("DORM3D")
end

function var0_0.BindEvent(arg0_15)
	arg0_15:bind(var0_0.PLAY_EXPRESSION, function(arg0_16, arg1_16)
		arg0_15:PlayExpression(arg1_16)
	end)
	arg0_15:bind(var0_0.SHOW_BLOCK, function()
		arg0_15.retainCount = arg0_15.retainCount + 1

		setActive(arg0_15.blockLayer, true)
	end)
	arg0_15:bind(var0_0.HIDE_BLOCK, function()
		arg0_15.retainCount = math.max(arg0_15.retainCount - 1, 0)

		if arg0_15.retainCount > 0 then
			return
		end

		setActive(arg0_15.blockLayer, false)
	end)
	arg0_15:bind(var0_0.ENABLE_SCENEBLOCK, function(arg0_19, arg1_19)
		setActive(arg0_15.sceneBlockLayer, arg1_19)
	end)
	arg0_15:bind(var0_0.ON_STICK_MOVE, function(arg0_20, arg1_20)
		arg0_15:OnStickMove(arg1_20)
	end)
	arg0_15:bind(var0_0.ON_POV_STICK_MOVE_BEGIN, function(arg0_21, arg1_21)
		if arg0_15.pinchMode then
			return
		end

		arg0_15.moveStickOrigin = arg1_21.position
		arg0_15.moveStickPosition = arg0_15.moveStickOrigin
		arg0_15.moveStickDraging = true
	end)

	local function var0_15()
		arg0_15.moveStickOrigin = nil
		arg0_15.moveStickPosition = nil
		arg0_15.moveStickDraging = nil

		if isActive(arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_15:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, Vector2.zero)
		end
	end

	arg0_15:bind(var0_0.ON_POV_STICK_MOVE_END, function(arg0_23, arg1_23)
		var0_15()
	end)
	arg0_15:bind(var0_0.ON_POV_STICK_MOVE, function(arg0_24, arg1_24)
		if arg0_15.pinchMode then
			var0_15()

			return
		end

		if not arg0_15.moveStickDraging then
			return
		end

		arg0_15.moveStickPosition = arg0_15.moveStickPosition + arg1_24

		if isActive(arg0_15.povLayer:Find("Guide")) then
			setActive(arg0_15.povLayer:Find("Guide"), false)
		end
	end)

	local var1_15 = 32.4 / Screen.height

	arg0_15:bind(var0_0.ON_POV_STICK_VIEW, function(arg0_25, arg1_25)
		if arg0_15.pinchMode then
			return
		end

		arg1_25 = arg1_25 * var1_15

		local var0_25 = arg1_25.x
		local var1_25 = arg1_25.y

		local function var2_25(arg0_26, arg1_26, arg2_26)
			local var0_26 = arg0_26[arg1_26]

			var0_26.m_InputAxisValue = arg2_26
			arg0_26[arg1_26] = var0_26
		end

		if isActive(arg0_15.cameras[var0_0.CAMERA.POV]) then
			var2_25(arg0_15.compPovAim, "m_HorizontalAxis", var0_25)
			var2_25(arg0_15.compPovAim, "m_VerticalAxis", var1_25)
		elseif isActive(arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			local var3_25 = arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

			var2_25(var3_25, "m_HorizontalAxis", var0_25)
			var2_25(var3_25, "m_VerticalAxis", var1_25)
		end
	end)

	local var2_15 = {
		PlayEnterExtraItem = true,
		HideCharacterBylayer = true,
		EnableHeadIK = true,
		RevertCharacterBylayer = true
	}

	arg0_15:bind(var0_0.PHOTO_CALL, function(arg0_27, arg1_27, ...)
		if var2_15[arg1_27] then
			local var0_27 = arg0_15:GetCurrentLadyEnv()

			arg0_15[arg1_27](arg0_15, var0_27, ...)
		else
			arg0_15[arg1_27](arg0_15, ...)
		end
	end)
	arg0_15:bind(var0_0.SHIFT_ZONE_SAFE, function(arg0_28, arg1_28)
		arg0_15:ShiftZoneSafe(arg1_28)
	end)
	arg0_15:bind(var0_0.TRIGGER_TIMELINE_PLAYER_EVENT, function(arg0_29, arg1_29)
		if not arg0_15.nowTimelinePlayer then
			warning("nowTimelinePlayer is nil, can't trigger event", arg1_29)

			return
		end

		arg0_15.nowTimelinePlayer:TriggerEvent(arg1_29)
	end)
	arg0_15:bind(var0_0.EXTRA_GET_SCREEN_POSITION, function(arg0_30, arg1_30, arg2_30, arg3_30)
		arg1_30.value = arg0_15:GetScreenPosition(arg2_30, arg3_30)
	end)
	arg0_15:bind(var0_0.EXTRA_CHANGE_PLAYER_POSITION, function(arg0_31, arg1_31)
		arg0_15:ChangePlayerPosition(arg1_31)
	end)
	arg0_15:bind(var0_0.EXTRA_CHANGE_CHARACTER_POSITION, function(arg0_32, arg1_32, arg2_32)
		if arg2_32 then
			local var0_32 = arg0_15:GetBlackboardValue(arg1_32, "groupId")

			arg0_15:SetLadyActiveZone(var0_32, arg2_32)
		end

		arg0_15:ChangeCharacterPosition(arg1_32)
	end)
	arg0_15:bind(var0_0.EXTRA_ACTIVE_CAMERA, function(arg0_33, arg1_33)
		arg0_15:ActiveCamera(arg1_33)
	end)
	arg0_15:bind(var0_0.EXTRA_ACTIVE_CAMERA_BY_NAME, function(arg0_34, arg1_34)
		arg0_15:ActiveCameraByName(arg1_34)
	end)
	arg0_15:bind(var0_0.EXTRA_REGISTER_ORBITS, function(arg0_35, arg1_35)
		arg0_15:RegisterOrbits(arg1_35)
	end)
	arg0_15:bind(var0_0.EXTRA_REVERT_CAMERA_ORBIT, function()
		arg0_15:RevertCameraOrbit()
	end)
	arg0_15:bind(var0_0.EXTRA_PLAY_ENTER_SCENE_ANIM, function(arg0_37, arg1_37, arg2_37)
		arg0_15:PlayEnterSceneAnim(arg1_37, arg2_37)
	end)
	arg0_15:bind(var0_0.EXTRA_PLAY_ENTER_EXTRA_ITEM, function(arg0_38, arg1_38, arg2_38, arg3_38)
		arg0_15:PlayEnterExtraItem(arg1_38, arg2_38, nil, arg3_38)
	end)
	arg0_15:bind(var0_0.EXTRA_HIDE_SCENE_ITEM, function(arg0_39, arg1_39)
		arg0_15:HideSceneItem(arg1_39)
	end)
	arg0_15:bind(var0_0.EXTRA_RESET_SCENE_ITEM_ANIMATORS, function(arg0_40, arg1_40)
		arg0_15:ResetSceneItemAnimators(arg1_40)
	end)
	arg0_15:bind(var0_0.EXTRA_RESET_CHARACTER_EXTRA_ITEM, function(arg0_41, arg1_41)
		arg0_15:ResetCharacterExtraItem(arg1_41)
	end)
	arg0_15:bind(var0_0.EXTRA_RESET_TEMP_HIDE_SCENE_ITEMS, function(arg0_42, arg1_42)
		arg0_15:ResetTempHideSceneItems(arg1_42)
	end)
	arg0_15:bind(var0_0.EXTRA_SET_BLACKBOARD_VALUE, function(arg0_43, arg1_43, arg2_43, arg3_43)
		arg0_15:SetBlackboardValue(arg1_43, arg2_43, arg3_43)
	end)
	arg0_15:bind(var0_0.EXTRA_SET_HEAD_AIM_IK, function(arg0_44, arg1_44, arg2_44, arg3_44)
		arg0_15:SettingHeadAimIK(arg1_44, arg2_44, arg3_44)
	end)
	arg0_15:bind(var0_0.EXTRA_RESET_HEAD_AIM_IK, function(arg0_45, arg1_45)
		arg0_15:ResetHeadAimIK(arg1_45)
	end)
	arg0_15:bind(var0_0.EXTRA_SWITCH_ANIM, function(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
		arg0_15:SwitchAnim(arg1_46, arg2_46, arg3_46, arg4_46)
	end)
	arg0_15:bind(var0_0.EXTRA_PLAY_SINGLE_ACTION, function(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
		arg0_15:PlaySingleAction(arg1_47, arg2_47, arg3_47, arg4_47)
	end)
	arg0_15:bind(var0_0.EXTRA_PLAY_FACE_ANIM, function(arg0_48, arg1_48, arg2_48, arg3_48)
		arg0_15:PlayFaceAnim(arg1_48, arg2_48, arg3_48)
	end)
	arg0_15:bind(var0_0.EXTRA_PLAY_SCENE_ITEM_ANIM, function(arg0_49, arg1_49, arg2_49, arg3_49)
		arg0_15:PlaySceneItemAnim(arg1_49, arg2_49, arg3_49)
	end)
	arg0_15:bind(var0_0.EXTRA_SHOW_BLACK_SCREEN, function(arg0_50, arg1_50, arg2_50)
		arg0_15:ShowBlackScreen(arg1_50, arg2_50)
	end)
	arg0_15:bind(var0_0.EXTRA_TRIGGER_LADY_DISTANCE, function()
		arg0_15:TriggerLadyDistance()
	end)
	arg0_15:bind(var0_0.EXTRA_CHECK_IN_SECTOR, function()
		arg0_15:CheckInSector()
	end)
end

function var0_0.initScene(arg0_53)
	local var0_53, var1_53 = unpack(string.split(arg0_53.dormSceneMgr.sceneInfo, "|"))
	local var2_53 = SceneManager.GetSceneByName(var0_53 .. "_base")

	arg0_53:ResetSceneStructure(var2_53)

	arg0_53.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_53.camBrain = arg0_53.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_53.camBrainEvenetHandler = arg0_53.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_53.raycastCamera = arg0_53.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_53.sceneRaycaster = arg0_53.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_53.player = GameObject.Find("Player").transform
	arg0_53.playerEye = arg0_53.player:Find("Eye")
	arg0_53.playerFoot = arg0_53.player:Find("Foot")

	setActive(arg0_53.playerFoot, false)

	arg0_53.playerController = arg0_53.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_53.modelRoot = GameObject.Find("scene_root").transform
	arg0_53.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_53.slotRoot, true)
	tolua.loadassembly("Cinemachine")

	local var3_53 = GameObject.Find("CM Cameras").transform

	eachChild(var3_53, function(arg0_54)
		setActive(arg0_54, false)
	end)

	arg0_53.camBrain.enabled = false
	arg0_53.camBrain.enabled = true
	arg0_53.cameraAim = var3_53:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_53.cameraAim2 = var3_53:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_53.cameraFree = nil
	arg0_53.cameraFurnitureWatch = nil
	arg0_53.cameraRole = var3_53:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_53.cameraRole2 = var3_53:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	local var4_53 = var3_53:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	arg0_53.cameraGift = var3_53:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_53.cameras = {
		arg0_53.cameraAim,
		arg0_53.cameraAim2,
		arg0_53.cameraRole,
		[var0_0.CAMERA.TALK] = var4_53,
		[var0_0.CAMERA.GIFT] = arg0_53.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_53.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_53:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_53:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_53:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)),
		[var0_0.CAMERA.SKIN] = arg0_53.room:isPersonalRoom() and var3_53:Find("Skin Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)) or nil
	}

	setActive(arg0_53.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_53.compPovAim = arg0_53.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_53.cameraRoot = var3_53
	arg0_53.POVOriginalFOV = arg0_53:GetPOVFOV()
	arg0_53.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_53.restrictedBox, false)

	local var5_53 = arg0_53.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(CharacterController)).radius

	arg0_53.isMultiFloor = arg0_53.restrictedBox.childCount > 2

	local var6_53 = "Floor"
	local var7_53 = "Celling"

	if arg0_53.isMultiFloor then
		arg0_53.restrictedHeightRange = {}

		for iter0_53 = 0, math.floor(arg0_53.restrictedBox.childCount / 2) - 1 do
			local var8_53 = iter0_53 == 0 and var6_53 or var6_53 .. "_" .. iter0_53
			local var9_53 = iter0_53 == 0 and var7_53 or var7_53 .. "_" .. iter0_53

			table.insert(arg0_53.restrictedHeightRange, {
				arg0_53.restrictedBox:Find(var8_53).position.y + var5_53,
				arg0_53.restrictedBox:Find(var9_53).position.y - var5_53
			})
		end
	else
		arg0_53.restrictedHeightRange = {
			arg0_53.restrictedBox:Find(var6_53).position.y + var5_53,
			arg0_53.restrictedBox:Find(var7_53).position.y - var5_53
		}
	end

	arg0_53.ladyInterest = GameObject.Find("InterestProxy").transform

	arg0_53:InitExtraSystem({
		Dorm3dLightingSystem
	})
	arg0_53:SwitchDayNight(arg0_53.contextData.timeIndex)

	arg0_53.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_53 .. "_base")).CutIn

	if arg0_53.tfCutIn then
		arg0_53.modelCutIn = {
			lady = arg0_53.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_53.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_53.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_55, arg1_55)
	arg0_55:emit(Dorm3dLightingSystem.APPLY_DAY_NIGHT, arg1_55)
end

function var0_0.ResetSceneStructure(arg0_56, arg1_56)
	local var0_56

	table.IpairsCArray(arg1_56:GetRootGameObjects(), function(arg0_57, arg1_57)
		if arg1_57.name == "Furnitures" then
			var0_56 = tf(arg1_57)

			eachChild(var0_56, function(arg0_58)
				local var0_58 = arg0_58:Find("FreeLook Camera")

				if var0_58 then
					setActive(var0_58, false)
				end

				local var1_58 = arg0_58:Find("RoleWatch Camera")

				if var1_58 then
					setActive(var1_58, false)
				end

				local var2_58 = arg0_58:Find("IKCamera")

				if var2_58 then
					setActive(var2_58, false)
				end

				local var3_58 = arg0_58:GetComponent(typeof(UnityEngine.Collider))

				if not var3_58 then
					return
				end

				var3_58.enabled = false
			end)
		end
	end)
	assert(var0_56, "Missing Furnitures root in Dorm3D base scene")

	arg0_56.posConfigRoot = var0_56
	arg0_56.zoneByName = {}
	arg0_56.ikPointByName = {}

	eachChild(arg0_56.posConfigRoot, function(arg0_59)
		local var0_59 = arg0_59.name

		;(string.match(var0_59, "^Pos%d+$") and arg0_56.ikPointByName or arg0_56.zoneByName)[var0_59] = arg0_59
	end)
end

function var0_0.SetFloatEnable(arg0_60, arg1_60)
	arg0_60.enableFloatUpdate = arg1_60

	if arg1_60 then
		arg0_60:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_61)
	local var0_61 = arg0_61:GetCurrentLadyEnv()
	local var1_61 = arg0_61:GetScreenPosition(var0_61.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var2_61 = arg0_61:GetLocalPosition(var1_61, arg0_61.rtFloatPage)

	setLocalPosition(arg0_61.rtFloatPage:Find("lady"), var2_61)
end

function var0_0.LoadCharacter(arg0_62, arg1_62, arg2_62)
	arg0_62.ladyDict = {}
	arg0_62.skinDict = {}

	local var0_62 = {}

	for iter0_62, iter1_62 in ipairs(arg1_62) do
		table.insert(var0_62, function(arg0_63)
			arg0_62:LoadSingleCharacter(iter1_62, arg0_63)
		end)
	end

	parallelAsync(var0_62, arg2_62)
end

function var0_0.LoadCharacterAdditionally(arg0_64, arg1_64, arg2_64)
	local var0_64 = {}

	for iter0_64, iter1_64 in ipairs(arg1_64) do
		table.insert(var0_64, function(arg0_65)
			arg0_64:LoadSingleCharacter(iter1_64, function()
				arg0_64:InitCharacter(arg0_64.ladyDict[iter1_64], iter1_64)
				arg0_65()
			end)
		end)
	end

	parallelAsync(var0_64, arg2_64)
end

function var0_0.LoadSingleCharacter(arg0_67, arg1_67, arg2_67)
	local var0_67 = {}
	local var1_67 = LadyEnv.New(arg0_67)

	arg0_67.ladyDict[arg1_67] = var1_67

	local var2_67 = getProxy(ApartmentProxy):getApartment(arg1_67)
	local var3_67 = var2_67:getConfig("asset_name")
	local var4_67 = var2_67:GetSkinModelID(arg0_67.room:getConfig("tag"))
	local var5_67 = Dorm3dSkin.New({
		configId = var4_67
	}):GetModelName()

	assert(var5_67)
	table.insert(var0_67, function(arg0_68)
		arg0_67.hxHelper:LoadMaterials(arg1_67, arg0_68)
	end)

	var1_67.skinId = var4_67
	var1_67.skinIdList = {
		var4_67
	}

	table.insert(var0_67, function(arg0_69)
		local var0_69 = string.format("dorm3d/character/%s/prefabs/%s", var3_67, var5_67)

		arg0_67.loader:GetPrefab(var0_69, "", function(arg0_70)
			arg0_67:MoveObjectToBaseScene(arg0_70)

			var1_67.ladyGameObject = arg0_70
			arg0_67.skinDict[var4_67] = {
				ladyGameObject = arg0_70
			}

			arg0_69()
		end)
	end)

	if arg0_67.room:isPersonalRoom() then
		for iter0_67, iter1_67 in ipairs(var2_67:GetAllModelIds()) do
			if not table.contains(var1_67.skinIdList, iter1_67) then
				local var6_67 = Dorm3dSkin.New({
					configId = iter1_67
				})

				if var6_67:IsShow() or iter1_67 == 199033 then
					local var7_67 = var6_67:GetModelName()
					local var8_67 = string.format("dorm3d/character/%s/prefabs/%s", var3_67, var7_67)

					if checkABExist(var8_67) then
						table.insert(var1_67.skinIdList, iter1_67)
						table.insert(var0_67, function(arg0_71)
							arg0_67.loader:GetPrefab(var8_67, "", function(arg0_72)
								arg0_67:MoveObjectToBaseScene(arg0_72)

								arg0_67.skinDict[iter1_67] = {
									ladyGameObject = arg0_72
								}
								GetComponent(arg0_72, "GraphOwner").enabled = false

								setActive(arg0_72, false)
								arg0_71()
							end)
						end)
					end
				end
			end
		end
	end

	if arg0_67.contextData.pendingDic[arg1_67] then
		local var9_67 = pg.dorm3d_welcome[arg0_67.contextData.pendingDic[arg1_67]]

		if var9_67.item_prefab ~= "" then
			table.insert(var0_67, function(arg0_73)
				local var0_73 = string.lower("dorm3d/furniture/item/" .. var9_67.item_prefab)

				arg0_67.loader:GetPrefab(var0_73, "", function(arg0_74)
					arg0_67:MoveObjectToBaseScene(arg0_74)

					var1_67.tfPendintItem = arg0_74.transform

					setActive(arg0_74, false)
					arg0_73()
				end)
			end)
		end
	end

	parallelAsync(var0_67, arg2_67)
end

function var0_0.HXCharacter(arg0_75, arg1_75, arg2_75)
	arg0_75.hxHelper:Apply(arg1_75, arg2_75)
end

function var0_0.InitHolyLight(arg0_76)
	local var0_76 = {}

	for iter0_76, iter1_76 in pairs(arg0_76.ladyDict) do
		table.insert(var0_76, iter1_76.lady)
	end

	Dorm3dHxHelper.ShowHolyLight(var0_76, arg0_76.holyLightRoot, true)
end

function var0_0.InitCharacter(arg0_77, arg1_77, arg2_77)
	arg1_77:InitCharacter(arg2_77)
	Dorm3dHxHelper.HideCharacterPart(arg1_77.lady)
	arg0_77:HXCharacter(arg1_77.lady, arg1_77.skinId)
	arg0_77:SetLadyActiveZone(arg2_77, arg0_77:GetLadyBaseZone(arg2_77))
	arg0_77:ChangeCharacterPosition(arg1_77)
end

function var0_0.SetCameraLady(arg0_78, arg1_78)
	arg0_78.cameraAim2.LookAt = arg1_78.ladyInterestRoot
	arg0_78.cameras[var0_0.CAMERA.TALK].Follow = arg1_78.ladyInterestRoot
	arg0_78.cameras[var0_0.CAMERA.TALK].LookAt = arg1_78.ladyInterestRoot
	arg0_78.cameraGift.Follow = arg0_78.ladyInterest
	arg0_78.cameraGift.LookAt = arg0_78.ladyInterest
	arg0_78.cameraRole2.LookAt = arg1_78.ladyInterestRoot
	arg0_78.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_78.ladyInterest
	arg0_78.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_78.ladyInterest
end

function var0_0.initNodeCanvas(arg0_79)
	local var0_79 = pg.NodeCanvasMgr.GetInstance()

	var0_79:Active()
	var0_79:RegisterFunc("DistanceTrigger", function(arg0_80)
		arg0_79:emit(var0_0.DISTANCE_TRIGGER, arg0_80, arg0_79.ladyDict[arg0_80].dis)
	end)
	var0_79:RegisterFunc("ShortWaitAction", function(arg0_81)
		arg0_79:DoShortWait(arg0_81)
	end)
	var0_79:RegisterFunc("WatchShortWaitAction", function(arg0_82)
		arg0_79:DoShortWait(arg0_82)
	end)
	var0_79:RegisterFunc("WalkDistanceTrigger", function(arg0_83)
		arg0_79:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_83, arg0_79.ladyDict[arg0_83].dis)
	end)
	var0_79:RegisterFunc("ChangeWatch", function(arg0_84)
		arg0_79:emit(var0_0.CHANGE_WATCH, arg0_84)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_85, arg1_85, arg2_85)
	arg0_85[arg1_85] = arg2_85

	for iter0_85, iter1_85 in pairs(arg0_85.ladyDict) do
		arg0_85:SetBlackboardValue(iter1_85, arg1_85, arg2_85)
	end
end

function var0_0.SetBlackboardValue(arg0_86, arg1_86, arg2_86, arg3_86)
	arg1_86:SetBlackboardValue(arg2_86, arg3_86)
end

function var0_0.GetBlackboardValue(arg0_87, arg1_87, arg2_87)
	return arg1_87:GetBlackboardValue(arg2_87)
end

function var0_0.didEnter(arg0_88)
	local var0_88 = -21.6 / Screen.height

	arg0_88.joystickDelta = Vector2.zero
	arg0_88.joystickTimer = FrameTimer.New(function()
		local var0_89 = arg0_88.joystickDelta * var0_88
		local var1_89 = var0_89.x
		local var2_89 = var0_89.y

		local function var3_89(arg0_90, arg1_90, arg2_90)
			local var0_90 = arg0_90[arg1_90]

			var0_90.m_InputAxisValue = arg2_90
			arg0_90[arg1_90] = var0_90
		end

		if arg0_88.surroudCamera and not arg0_88.pinchMode then
			var3_89(arg0_88.surroudCamera, "m_XAxis", var1_89)
			var3_89(arg0_88.surroudCamera, "m_YAxis", var2_89)
		elseif arg0_88.furniturePOV and arg0_88.cameras[var0_0.CAMERA.FURNITURE_WATCH] and isActive(arg0_88.cameras[var0_0.CAMERA.FURNITURE_WATCH]) then
			var3_89(arg0_88.furniturePOV, "m_HorizontalAxis", var1_89)
			var3_89(arg0_88.furniturePOV, "m_VerticalAxis", var2_89)
		end

		arg0_88.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_88.joystickTimer:Start()

	local var1_88 = 1.75

	arg0_88.moveStickTimer = FrameTimer.New(function()
		if not arg0_88.moveStickDraging then
			return
		end

		local var0_91 = arg0_88.moveStickPosition
		local var1_91 = 200
		local var2_91 = (var0_91 - arg0_88.moveStickOrigin):ClampMagnitude(var1_91)
		local var3_91 = var2_91 / var1_91

		arg0_88.moveStickPosition = arg0_88.moveStickOrigin + var2_91

		local var4_91 = Vector3.New(var3_91.x, 0, var3_91.y)
		local var5_91 = arg0_88.mainCameraTF:TransformDirection(var4_91)

		var5_91.y = 0

		local var6_91 = var5_91:Normalize()

		var6_91:Mul(var1_88)

		if isActive(arg0_88.cameras[var0_0.CAMERA.POV]) then
			arg0_88.playerController:SimpleMove(var6_91)

			arg0_88.tweenFOV = true
		elseif isActive(arg0_88.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_88.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_91 * Time.deltaTime)
			arg0_88:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_91:Normalize())
			onNextTick(function()
				local var0_92 = arg0_88.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_92 = arg0_88:GetRestritedHeightRange()
				local var2_92 = math.InverseLerp(var1_92[1], var1_92[2], var0_92.position.y)

				arg0_88:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var2_92)
			end)
		end
	end, 1, -1)

	arg0_88.moveStickTimer:Start()

	arg0_88.pinchMode = false
	arg0_88.pinchSize = 0
	arg0_88.pinchValue = 1
	arg0_88.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_93, arg1_93)
		if arg0_88.surroudCamera and isActive(arg0_88.surroudCamera) then
			arg0_88.pinchMode = true
			arg0_88.pinchSize = (arg0_93 - arg1_93):Magnitude()
			arg0_88.pinchNodeOrder = arg1_93.x < arg0_93.x and -1 or 1

			return
		end

		if isActive(arg0_88.cameras[var0_0.CAMERA.POV]) then
			if (arg0_93 - arg1_93):Magnitude() < Screen.height * 0.5 then
				arg0_88.pinchMode = true
				arg0_88.pinchSize = (arg0_93 - arg1_93):Magnitude()
				arg0_88.pinchNodeOrder = arg1_93.x < arg0_93.x and -1 or 1
			end

			return
		end
	end)

	local var2_88 = 0.01

	if IsUnityEditor then
		var2_88 = 0.1
	end

	local var3_88 = var2_88 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_94, arg1_94)
		if not arg0_88.pinchMode then
			return
		end

		local var0_94 = (arg0_94 - arg1_94):Magnitude()
		local var1_94 = arg0_88.pinchSize - var0_94
		local var2_94 = arg0_88.pinchNodeOrder * (arg1_94.x < arg0_94.x and -1 or 1)
		local var3_94 = var1_94 * var3_88 * var2_94

		if isActive(arg0_88.cameras[var0_0.CAMERA.POV]) then
			local var4_94 = 0.5
			local var5_94 = 1

			arg0_88.pinchValue = math.clamp(arg0_88.pinchValue + var3_94, var4_94, var5_94)
			arg0_88.pinchSize = var0_94

			arg0_88:SetPOVFOV(arg0_88.POVOriginalFOV * arg0_88.pinchValue)

			arg0_88.tweenFOV = nil

			return
		end

		if isActive(arg0_88.surroudCamera) and arg0_88.surroudCamera == arg0_88.cameras[var0_0.CAMERA.PHOTO] then
			local var6_94 = 0.5
			local var7_94 = 1

			arg0_88:SetPinchValue(math.clamp(arg0_88.pinchValue + var3_94, var6_94, var7_94))

			arg0_88.pinchSize = var0_94

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_88.pinchMode = false
		arg0_88.pinchSize = 0
	end)

	arg0_88.cameraBlendCallbacks = {}
	arg0_88.activeCMCamera = nil

	function arg0_88.camBrainEvenetHandler.OnBlendStarted(arg0_96)
		if arg0_88.activeCMCamera then
			arg0_88:OnCameraBlendFinished(arg0_88.activeCMCamera)
		end

		local var0_96 = arg0_88.camBrain.ActiveVirtualCamera

		arg0_88.activeCMCamera = var0_96
	end

	function arg0_88.camBrainEvenetHandler.OnBlendFinished(arg0_97)
		arg0_88.activeCMCamera = nil

		arg0_88:OnCameraBlendFinished(arg0_97)
	end

	arg0_88.expressionDict = {}

	arg0_88:OverlayPanel(arg0_88.blockLayer)
	arg0_88:ActiveCamera(arg0_88.cameras[var0_0.CAMERA.POV])
	arg0_88:InitExtraSystem()

	local var4_88
	local var5_88
	local var6_88 = arg0_88.resumeCallback

	function arg0_88.resumeCallback()
		var5_88 = true

		if var4_88 then
			existCall(var6_88)
		end
	end

	arg0_88:RefreshSlots(nil, function()
		var4_88 = true

		if var5_88 then
			existCall(var6_88)
		end
	end)

	arg0_88.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_88:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_88.updateHandler)
end

function var0_0.InitData(arg0_103)
	if not arg0_103.contextData.ladyZone then
		arg0_103.contextData.ladyZone = {}

		local var0_103
		local var1_103 = arg0_103.room:getConfig("default_zone")

		for iter0_103, iter1_103 in ipairs(var1_103) do
			arg0_103.contextData.ladyZone[iter1_103[1]] = iter1_103[2]

			if table.contains(arg0_103.contextData.groupIds, iter1_103[1]) then
				var0_103 = var0_103 or arg0_103.contextData.ladyZone[iter1_103[1]]
			end
		end

		arg0_103.contextData.currentZoneNodeName = var0_103 or var1_103[1][2]
	end

	arg0_103.zoneDatas = _.select(arg0_103.room:GetZones(), function(arg0_104)
		return not arg0_104:IsGlobal()
	end)
	arg0_103.ladyActiveZone = {}
	arg0_103.activeLady = {}
end

function var0_0.Update(arg0_105)
	arg0_105.raycastCamera.fieldOfView = arg0_105.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_105.tweenFOV then
		local var0_105 = Damp(1, 1, Time.deltaTime)

		arg0_105.pinchValue = Mathf.Lerp(arg0_105.pinchValue, 1, var0_105)

		arg0_105:SetPOVFOV(arg0_105.POVOriginalFOV * arg0_105.pinchValue)

		if arg0_105.pinchValue > 0.99 then
			arg0_105.tweenFOV = nil
		end
	end

	if isActive(arg0_105.cameras[var0_0.CAMERA.POV]) then
		arg0_105:TriggerLadyDistance()
	end

	if arg0_105.enableFloatUpdate then
		arg0_105:UpdateFloatPosition()
	end

	arg0_105:CheckInSector()

	if arg0_105.systemManager then
		arg0_105.systemManager:Update(Time.deltaTime)
	end
end

function var0_0.CheckInSector(arg0_106)
	if not isActive(arg0_106.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_106 = arg0_106.mainCameraTF.position

	for iter0_106, iter1_106 in pairs(arg0_106.ladyDict) do
		if iter1_106.lady then
			local var1_106 = tobool(arg0_106.activeLady[iter0_106])
			local var2_106 = {
				Radius = 2,
				Angle = 120,
				Position = iter1_106.lady.position,
				Rotation = iter1_106.lady.rotation
			}

			if var1_106 ~= tobool(var0_0.IsPointInSector(var2_106, var0_106)) then
				arg0_106.activeLady[iter0_106] = not var1_106

				arg0_106:emit(var0_0.ON_ENTER_SECTOR, iter0_106)
			end
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_107)
	for iter0_107, iter1_107 in pairs(arg0_107.ladyDict) do
		if iter1_107.lady then
			iter1_107.dis = (iter1_107.lady.position - arg0_107.player.position).magnitude

			if (arg0_107:GetBlackboardValue(iter1_107, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_107.dis ~= arg0_107:GetBlackboardValue(iter1_107, "inDistance") then
				arg0_107:SetBlackboardValue(iter1_107, "inDistance", iter1_107.dis < var0_0.POV_CLOSE_DISTANCE)
				arg0_107:emit(var0_0.ON_CHANGE_DISTANCE, iter0_107, iter1_107.dis < var0_0.POV_CLOSE_DISTANCE)
			end
		end
	end
end

function var0_0.OnStickMove(arg0_108, arg1_108)
	arg0_108.joystickDelta = arg1_108
end

function var0_0.SetPinchValue(arg0_109, arg1_109)
	arg0_109.pinchValue = arg1_109

	arg0_109:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_110)
	local var0_110 = arg0_110.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_110)
end

function var0_0.SetPOVFOV(arg0_111, arg1_111)
	local var0_111 = arg0_111.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_111, arg1_111)

	arg0_111.cameras[var0_0.CAMERA.POV].m_Lens = var0_111
end

function var0_0.RefreshSlots(arg0_112, arg1_112, arg2_112)
	arg0_112:emit(FurnitureSystem.REFRESH_SLOTS, arg1_112, arg2_112)
end

function var0_0.RefreshSlotsEmpty(arg0_113, arg1_113)
	arg0_113:emit(FurnitureSystem.REFRESH_SLOTS_EMPTY, arg1_113)
end

function var0_0.CheckSceneItemActiveByPath(arg0_114, arg1_114)
	local var0_114 = arg0_114:GetSceneItem(arg1_114)

	return arg0_114:CheckSceneItemActive(var0_114)
end

function var0_0.CheckSceneItemActive(arg0_115, arg1_115)
	local var0_115 = arg0_115:GetExtraSystem(FurnitureSystem)

	assert(var0_115, "FurnitureSystem is not initialized")

	return var0_115:CheckSceneItemActive(arg1_115)
end

function var0_0.ChangeCharacterPosition(arg0_116, arg1_116)
	local var0_116 = arg0_116:GetBlackboardValue(arg1_116, "groupId")

	arg0_116:ResetCharPoint(arg1_116, arg0_116:GetLadyActiveZone(var0_116))
	arg0_116:SyncInterestTransform(arg1_116)
end

function var0_0.SyncCurrentInterestTransform(arg0_117)
	local var0_117 = arg0_117:GetCurrentLadyEnv()

	arg0_117:SyncInterestTransform(var0_117)
end

function var0_0.SyncInterestTransform(arg0_118, arg1_118)
	arg0_118.ladyInterest.position = arg1_118.ladyInterestRoot.position
	arg0_118.ladyInterest.rotation = arg1_118.ladyInterestRoot.rotation
end

function var0_0.SyncInterestTransformByTf(arg0_119, arg1_119)
	arg0_119.ladyInterest.position = arg1_119.position
	arg0_119.ladyInterest.rotation = arg1_119.rotation
end

function var0_0.ChangePlayerPosition(arg0_120, arg1_120)
	arg1_120 = arg1_120 or arg0_120.contextData.currentZoneNodeName

	local var0_120 = (arg0_120.zoneByName[arg1_120] or arg0_120.ikPointByName[arg1_120]):Find("PlayerPoint").position

	arg0_120.player.position = var0_120
	arg0_120.cameras[var0_0.CAMERA.POV].transform.position = arg0_120.playerEye.position

	local var1_120 = arg0_120.ladyInterest.position - arg0_120.playerEye.position
	local var2_120 = Quaternion.LookRotation(var1_120).eulerAngles
	local var3_120 = var2_120.y
	local var4_120 = var2_120.x
	local var5_120 = arg0_120.compPovAim.m_HorizontalAxis

	var5_120.Value = arg0_120:GetNearestAngle(var3_120, var5_120.m_MinValue, var5_120.m_MaxValue)
	arg0_120.compPovAim.m_HorizontalAxis = var5_120

	local var6_120 = arg0_120.compPovAim.m_VerticalAxis

	var6_120.Value = var4_120
	arg0_120.compPovAim.m_VerticalAxis = var6_120
end

function var0_0.GetCurrentZoneNodeName(arg0_121)
	return arg0_121.contextData.currentZoneNodeName
end

function var0_0.GetLadyBaseZone(arg0_122, arg1_122)
	return arg0_122.contextData.ladyZone[arg1_122]
end

function var0_0.GetLadyActiveZone(arg0_123, arg1_123)
	return arg0_123.ladyActiveZone[arg1_123] or arg0_123:GetLadyBaseZone(arg1_123)
end

function var0_0.SetLadyActiveZone(arg0_124, arg1_124, arg2_124)
	arg0_124.ladyActiveZone[arg1_124] = arg2_124 or arg0_124:GetLadyBaseZone(arg1_124)
end

function var0_0.GetZoneByName(arg0_125, arg1_125)
	return arg0_125.zoneByName[arg1_125]
end

function var0_0.GetIKPointByName(arg0_126, arg1_126)
	return arg0_126.ikPointByName[arg1_126]
end

function var0_0.GetSlotByID(arg0_127, arg1_127)
	local var0_127 = arg0_127:GetExtraSystem(FurnitureSystem)

	assert(var0_127, "FurnitureSystem is not initialized")

	return var0_127:GetSlotByID(arg1_127)
end

function var0_0.GetScreenPosition(arg0_128, arg1_128, arg2_128)
	arg2_128 = arg2_128 or arg0_128.raycastCamera

	local var0_128 = arg2_128:WorldToScreenPoint(arg1_128)

	if var0_128.z < 0 then
		var0_128.x = var0_128.x + (var0_128.x < 0 and -1 or 1) * Screen.width
		var0_128.y = var0_128.y + (var0_128.y < 0 and -1 or 1) * Screen.height
		var0_128.z = -var0_128.z
	end

	return var0_128
end

function var0_0.GetLocalPosition(arg0_129, arg1_129, arg2_129)
	return LuaHelper.ScreenToLocal(arg2_129, arg1_129, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_130)
	return arg0_130.modelRoot
end

function var0_0.ShiftZoneSafe(arg0_131, arg1_131)
	local var0_131 = {}

	if arg0_131.room:isPersonalRoom() and not arg0_131:GetBlackboardValue(arg0_131:GetCurrentLadyEnv(), "inPending") then
		table.insert(var0_131, function(arg0_132)
			arg0_131:OutOfLazy(arg0_131.apartment:GetConfigID(), arg0_132)
		end)
	end

	table.insert(var0_131, function(arg0_133)
		arg0_131:ShiftZone(arg1_131, arg0_133)
	end)
	seriesAsync(var0_131, function()
		arg0_131:CheckQueue()
	end)
end

function var0_0.ShiftZone(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg0_135:GetZoneByName(arg1_135)

	if not var0_135 then
		errorMsg(arg1_135 .. " Not Find")
		existCall(arg2_135)

		return
	end

	seriesAsync({
		function(arg0_136)
			arg0_135:emit(var0_0.SHOW_BLOCK)
			arg0_135:ShowBlackScreen(true, arg0_136)
		end,
		function(arg0_137)
			if arg0_135.shiftLady or arg0_135.room:isPersonalRoom() then
				local var0_137 = arg0_135.shiftLady or arg0_135.apartment:GetConfigID()

				arg0_135.shiftLady = nil
				arg0_135.contextData.ladyZone[var0_137] = var0_135.name

				local var1_137 = arg0_135.ladyDict[var0_137]

				arg0_135:SetLadyActiveZone(var0_137, arg0_135:GetLadyBaseZone(var0_137))

				if arg0_135:GetBlackboardValue(var1_137, "inPending") then
					arg0_135:SetOutPending(var1_137)
					arg0_135:SwitchAnim(var1_137, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_135:ChangeCharacterPosition(var1_137)
						arg0_137()
					end)
				else
					arg0_135:ChangeCharacterPosition(var1_137)
					arg0_137()
				end
			else
				arg0_137()
			end
		end,
		function(arg0_139)
			arg0_135.contextData.currentZoneNodeName = var0_135.name

			if SlideExtraSystem.IsOpen(arg0_135.room) and arg0_135.contextData.currentZoneNodeName == SlideConst.SLIDE_ZONE then
				arg0_135:SyncInterestTransformByTf(var0_135.transform:Find("StayPoint"))
			elseif not arg0_135.apartment then
				for iter0_139, iter1_139 in pairs(arg0_135.ladyDict) do
					if arg0_135:GetLadyBaseZone(iter0_139) == arg0_135.contextData.currentZoneNodeName then
						arg0_135:SyncInterestTransform(iter1_139)

						break
					end
				end
			end

			arg0_135:ChangePlayerPosition()
			arg0_135:TriggerLadyDistance()
			arg0_135:CheckInSector()
			arg0_139()
		end,
		function(arg0_140)
			arg0_135:UpdateZoneList()
			arg0_135:ShowBlackScreen(false, arg0_140)
		end,
		function(arg0_141)
			arg0_135:emit(var0_0.HIDE_BLOCK)
			arg0_141()
		end
	}, arg2_135)
end

function var0_0.ActiveCamera(arg0_142, arg1_142)
	local var0_142 = isActive(arg1_142)

	table.Foreach(arg0_142.cameras, function(arg0_143, arg1_143)
		setActive(arg1_143, arg1_143 == arg1_142)
	end)

	if var0_142 then
		arg0_142:OnCameraBlendFinished(arg1_142)
	end
end

function var0_0.ActiveCameraByName(arg0_144, arg1_144)
	local var0_144 = arg0_144.cameraRoot:Find(arg1_144)

	assert(var0_144, "ActiveCameraByName: " .. arg1_144 .. " not found")
	table.Foreach(arg0_144.cameras, function(arg0_145, arg1_145)
		setActive(arg1_145, false)
	end)
	setActive(var0_144, true)

	arg0_144.cameras[var0_0.CAMERA.CUSTOM] = var0_144:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
end

function var0_0.ShowBlackScreen(arg0_146, arg1_146, arg2_146)
	local var0_146 = arg0_146.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_146 and 0 or 0.3
	}

	setImageColor(arg0_146.blackLayer, Color.NewHex(var0_146.color))
	setActive(arg0_146.blackLayer, true)
	setCanvasGroupAlpha(arg0_146.blackLayer, arg1_146 and 0 or 1)
	arg0_146:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_146 then
			setActive(arg0_146.blackLayer, false)
		end

		existCall(arg2_146)
	end, GetComponent(arg0_146.blackLayer, typeof(CanvasGroup)), arg1_146 and 1 or 0, var0_146.time):setDelay(var0_146.delay)
end

function var0_0.RegisterOrbits(arg0_148, arg1_148)
	arg0_148 = arg0_148.scene
	arg0_148.orbits = {
		original = arg1_148.m_Orbits
	}
	arg0_148.orbits.current = _.range(3):map(function(arg0_149)
		local var0_149 = arg0_148.orbits.original[arg0_149 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_149.m_Height, var0_149.m_Radius)
	end)
	arg0_148.surroudCamera = arg1_148
end

function var0_0.SetCameraObrits(arg0_150)
	arg0_150 = arg0_150.scene

	local var0_150 = arg0_150.surroudCamera

	if not var0_150 then
		return
	end

	local var1_150 = arg0_150.orbits.original[1]

	for iter0_150 = 0, #arg0_150.orbits.current - 1 do
		local var2_150 = arg0_150.orbits.current[iter0_150 + 1]
		local var3_150 = arg0_150.orbits.original[iter0_150]

		var2_150.m_Height = math.lerp(var1_150.m_Height, var3_150.m_Height, arg0_150.pinchValue)
		var2_150.m_Radius = var3_150.m_Radius * arg0_150.pinchValue
	end

	var0_150.m_Orbits = arg0_150.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_151)
	arg0_151 = arg0_151.scene

	local var0_151 = arg0_151.surroudCamera

	if not var0_151 then
		return
	end

	for iter0_151 = 0, #arg0_151.orbits.current - 1 do
		local var1_151 = arg0_151.orbits.current[iter0_151 + 1]
		local var2_151 = arg0_151.orbits.original[iter0_151]

		var1_151.m_Height = var2_151.m_Height
		var1_151.m_Radius = var2_151.m_Radius
	end

	var0_151.m_Orbits = arg0_151.orbits.current
	arg0_151.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_152, arg1_152, arg2_152)
	local var0_152 = {
		base = function(arg0_153)
			arg0_152:RegisterCameraBlendFinished(arg0_152.cameras[var0_0.CAMERA.POV], arg0_153)
			arg0_152:ActiveCamera(arg0_152.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_154)
			assert(arg0_152.apartment)
			arg0_152:SyncInterestTransform(arg0_152:GetCurrentLadyEnv())
			arg0_152:SetCameraLady(arg0_152:GetCurrentLadyEnv())
			arg0_152:RegisterCameraBlendFinished(arg0_152.cameras[var0_0.CAMERA.ROLE], arg0_154)
			arg0_152:ActiveCamera(arg0_152.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_155)
			arg0_152:RegisterCameraBlendFinished(arg0_152.cameras[var0_0.CAMERA.POV], arg0_155)
			arg0_152:ActiveCamera(arg0_152.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_156)
			arg0_156()
		end,
		gift = function(arg0_157)
			assert(arg0_152.apartment)
			arg0_152:SetCameraLady(arg0_152:GetCurrentLadyEnv())
			arg0_152:RegisterCameraBlendFinished(arg0_152.cameras[var0_0.CAMERA.GIFT], arg0_157)
			arg0_152:ActiveCamera(arg0_152.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_158)
			assert(arg0_152.apartment)
			arg0_152:SetCameraLady(arg0_152:GetCurrentLadyEnv())

			arg0_152.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_152.cameraRole.transform.position

			arg0_152:RegisterCameraBlendFinished(arg0_152.cameras[var0_0.CAMERA.ROLE2], arg0_158)
			arg0_152:ActiveCamera(arg0_152.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_159)
			assert(arg0_152.apartment)
			arg0_152:SetCameraLady(arg0_152:GetCurrentLadyEnv())
			arg0_152:SyncInterestTransform(arg0_152:GetCurrentLadyEnv())
			arg0_152:RegisterCameraBlendFinished(arg0_152.cameras[var0_0.CAMERA.TALK], arg0_159)
			arg0_152:ActiveCamera(arg0_152.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_152 = {}

	table.insert(var1_152, function(arg0_160)
		switch(arg1_152, var0_152, arg0_160, arg0_160)
	end)
	seriesAsync(var1_152, arg2_152)
end

function var0_0.GetSceneItem(arg0_161, arg1_161)
	local var0_161

	if string.find(arg1_161, "FurnitureSlots/") == 1 then
		arg1_161 = string.gsub(arg1_161, "^FurnitureSlots/", "", 1)
		var0_161 = arg0_161.slotRoot:Find(arg1_161)
	else
		var0_161 = arg0_161.modelRoot:Find(arg1_161)
	end

	if not var0_161 then
		warning(string.format("Missing scene item path: %s", arg1_161))
	end

	return var0_161
end

function var0_0.SetSceneAnimSpeed(arg0_162, arg1_162, arg2_162)
	table.Ipairs(arg1_162 or {}, function(arg0_163, arg1_163)
		if arg0_162.sceneAnimatorDict[arg1_163] then
			arg0_162.sceneAnimatorDict[arg1_163].animator.speed = arg2_162
		end
	end)
end

function var0_0.SetExtraAnimSpeed(arg0_164, arg1_164, arg2_164)
	table.Ipairs(arg1_164 or {}, function(arg0_165, arg1_165)
		local var0_165 = arg1_165[1]

		if arg0_164.extraItems and arg0_164.extraItems[var0_165] then
			arg0_164.extraItems[var0_165].trans:GetComponent(typeof(Animator)).speed = arg2_164
		end
	end)
end

function var0_0.PlayEnterSceneAnim(arg0_166, arg1_166, arg2_166, arg3_166)
	arg3_166 = arg3_166 or 1

	local var0_166 = {}

	if arg1_166 and #arg1_166 > 0 then
		table.Ipairs(arg1_166, function(arg0_167, arg1_167)
			arg0_166:PlaySceneItemAnim(arg1_167[1], arg1_167[2], arg2_166)
			arg0_166:SetSceneAnimSpeed({
				arg1_167[1]
			}, arg3_166)
			table.insert(var0_166, arg1_167[1])
		end)
	end

	arg0_166:ResetSceneItemAnimators(var0_166)
end

function var0_0.PlayEnterExtraItem(arg0_168, arg1_168, arg2_168, arg3_168, arg4_168)
	arg3_168 = arg3_168 or 1

	local var0_168 = {}

	if arg2_168 and #arg2_168 > 0 then
		table.Ipairs(arg2_168, function(arg0_169, arg1_169)
			local var0_169 = arg1_169[3] and Vector3.New(unpack(arg1_169[3]))
			local var1_169 = arg1_169[4] and Quaternion.Euler(unpack(arg1_169[4]))
			local var2_169 = #arg1_169 > 4 and arg1_169[5] or nil

			arg0_168:LoadCharacterExtraItem(arg1_168, arg1_169[1], arg1_169[2], var0_169, var1_169, var2_169, arg3_168, arg4_168)
			table.insert(var0_168, arg1_169[1])
		end)
	end

	arg0_168:ResetCharacterExtraItem(var0_168)
end

function var0_0.HideSceneItem(arg0_170, arg1_170)
	if arg1_170 and #arg1_170 > 0 then
		if arg0_170.tempHideSceneItems and #arg0_170.tempHideSceneItems > 0 then
			arg0_170:ResetTempHideSceneItems(arg1_170)
		end

		arg0_170.tempHideSceneItems = {}

		table.Ipairs(arg1_170, function(arg0_171, arg1_171)
			local var0_171 = arg0_170:GetSceneItem(arg1_171)

			setActive(var0_171, false)
			table.insert(arg0_170.tempHideSceneItems, arg1_171)
		end)
	end
end

function var0_0.ResetTempHideSceneItems(arg0_172, arg1_172)
	arg1_172 = arg1_172 or {}

	if arg0_172.tempHideSceneItems and #arg0_172.tempHideSceneItems > 0 then
		table.Ipairs(arg0_172.tempHideSceneItems, function(arg0_173, arg1_173)
			if table.contains(arg1_172, arg1_173) then
				return
			end

			local var0_173 = arg0_172:GetSceneItem(arg1_173)

			setActive(var0_173, true)
		end)

		arg0_172.tempHideSceneItems = nil
	end
end

function var0_0.EnableCurrentHeadIK(arg0_174, arg1_174)
	local var0_174 = arg0_174:GetCurrentLadyEnv()

	arg0_174:EnableHeadIK(var0_174, arg1_174)
end

function var0_0.EnableHeadIK(arg0_175, arg1_175, arg2_175)
	arg1_175.ladyHeadIKComp.enableIk = arg2_175
end

function var0_0.SettingHeadAimIK(arg0_176, arg1_176, arg2_176, arg3_176)
	local var0_176

	if arg2_176[1] == 0 then
		arg0_176:EnableHeadIK(arg1_176, false)

		return
	elseif arg2_176[1] == 1 then
		arg0_176:EnableHeadIK(arg1_176, true)

		var0_176 = arg0_176.mainCameraTF:Find("AimTarget")
	elseif arg2_176[1] == 2 then
		arg0_176:EnableHeadIK(arg1_176, true)
		table.IpairsCArray(arg1_176.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_177, arg1_177)
			if arg1_177.name ~= arg2_176[2] then
				return
			end

			var0_176 = arg1_177
		end)
	end

	arg1_176.ladyHeadIKComp.AimTarget = var0_176

	if not arg3_176 and arg2_176[3] then
		arg1_176.ladyHeadIKComp.BodyWeight = arg2_176[3]
	end

	if not arg3_176 and arg2_176[4] then
		arg1_176.ladyHeadIKComp.HeadWeight = arg2_176[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_178, arg1_178)
	arg0_178:EnableHeadIK(arg1_178, true)

	arg1_178.ladyHeadIKComp.AimTarget = arg0_178.mainCameraTF:Find("AimTarget")
	arg1_178.ladyHeadIKComp.HeadWeight = arg1_178.ladyHeadIKData.HeadWeight
	arg1_178.ladyHeadIKComp.BodyWeight = arg1_178.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_179, arg1_179)
	for iter0_179, iter1_179 in pairs(arg0_179.ladyDict) do
		if iter0_179 ~= arg1_179 then
			arg0_179:HideCharacterBylayer(iter1_179)
		end
	end
end

function var0_0.RevertCharacter(arg0_180, arg1_180)
	for iter0_180, iter1_180 in pairs(arg0_180.ladyDict) do
		if iter0_180 ~= arg1_180 then
			arg0_180:RevertCharacterBylayer(iter1_180)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_181, arg1_181)
	local var0_181 = "Bip001"
	local var1_181 = arg1_181.lady:Find("all")

	for iter0_181 = 0, var1_181.childCount - 1 do
		local var2_181 = var1_181:GetChild(iter0_181)

		if var2_181.name ~= var0_181 then
			pg.ViewUtils.SetLayer(var2_181, Layer.UIHidden)
		end
	end

	if arg1_181.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_181.tfPendintItem, Layer.UIHidden)
	end

	if arg1_181.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_181.ladyWatchFloat, Layer.UIHidden)
	end

	Dorm3dHxHelper.SetModelHolyLightActive(arg1_181.lady, arg0_181.holyLightRoot, false)
end

function var0_0.RevertCharacterBylayer(arg0_182, arg1_182)
	local var0_182 = "Bip001"
	local var1_182 = arg1_182.lady:Find("all")

	for iter0_182 = 0, var1_182.childCount - 1 do
		local var2_182 = var1_182:GetChild(iter0_182)

		if var2_182.name ~= var0_182 then
			pg.ViewUtils.SetLayer(var2_182, Layer.Character3D)
		end
	end

	if arg1_182.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_182.tfPendintItem, Layer.Default)
	end

	if arg1_182.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_182.ladyWatchFloat, Layer.Default)
	end

	Dorm3dHxHelper.SetModelHolyLightActive(arg1_182.lady, arg0_182.holyLightRoot, true)
end

function var0_0.EnterFurnitureWatchMode(arg0_183)
	arg0_183:SetAllBlackbloardValue("inLockLayer", true)
	arg0_183:EnableJoystick(true)
	arg0_183:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_184, arg1_184)
	arg0_184:HideFurnitureSlots()

	local var0_184 = arg0_184.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_185)
			arg0_184.furniturePOV = nil

			arg0_184:EnableJoystick(false)
			arg0_184:emit(var0_0.SHOW_BLOCK)
			arg0_184:ShowBlackScreen(true, arg0_185)
		end,
		function(arg0_186)
			existCall(arg1_184)
			arg0_184:RevertCharacter()
			arg0_184:SetAllBlackbloardValue("inLockLayer", false)
			arg0_184:RegisterCameraBlendFinished(var0_184, arg0_186)
			arg0_184:ActiveCamera(var0_184)
		end,
		function(arg0_187)
			arg0_184:ShowBlackScreen(false, arg0_187)
		end
	}, function()
		arg0_184:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_184:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_189, arg1_189)
	local var0_189 = "FurnitureWatch" .. arg1_189:GetWatchCameraName()
	local var1_189 = arg0_189.cameraRoot:Find(var0_189)

	if not var1_189 then
		errorMsg(var0_189 .. " Not Find Under CM Cameras")

		return
	end

	local var2_189 = var1_189:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_189.cameraFurnitureWatch and arg0_189.cameraFurnitureWatch ~= var2_189 then
		arg0_189:UnRegisterCameraBlendFinished(arg0_189.cameraFurnitureWatch)
		setActive(arg0_189.cameraFurnitureWatch, false)
	end

	arg0_189.cameraFurnitureWatch = var2_189
	arg0_189.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_189.cameraFurnitureWatch
	arg0_189.furniturePOV = arg0_189.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_189:RegisterCameraBlendFinished(arg0_189.cameraFurnitureWatch, function()
		arg0_189:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_189:emit(var0_0.SHOW_BLOCK)
	arg0_189:ActiveCamera(arg0_189.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_191)
	arg0_191:emit(FurnitureSystem.HIDE_SLOTS)
end

function var0_0.DisplayFurnitureSlots(arg0_192, arg1_192)
	arg0_192:emit(FurnitureSystem.DISPLAY_SLOTS, arg1_192)
end

function var0_0.UpdateDisplaySlots(arg0_193, arg1_193)
	arg0_193:emit(FurnitureSystem.UPDATE_DISPLAY_SLOTS, arg1_193)
end

function var0_0.EnterPhotoMode(arg0_194, arg1_194, arg2_194)
	arg0_194:SetAllBlackbloardValue("inLockLayer", true)
	arg0_194:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_195)
			arg0_194:TempHideUI(true, arg0_195)
		end,
		function(arg0_196)
			arg0_194:ShowBlackScreen(true, arg0_196)
		end,
		function(arg0_197)
			local var0_197 = arg0_194.apartment:GetConfigID()
			local var1_197 = arg0_194.ladyDict[var0_197]

			arg0_194:SwitchAnim(var1_197, arg2_194)
			var1_197.ladyAnimator:Update(0)
			arg0_194:ResetCharPoint(var1_197, arg1_194:GetWatchCameraName())
			arg0_194:SyncInterestTransform(var1_197)
			setActive(var1_197.ladySafeCollider, true)
			arg0_194:HideCharacter(var0_197)

			local var2_197 = arg0_194.cameras[var0_0.CAMERA.PHOTO]
			local var3_197 = var2_197.m_XAxis

			var3_197.Value = 180
			var2_197.m_XAxis = var3_197

			local var4_197 = var2_197.m_YAxis

			var4_197.Value = 0.7
			var2_197.m_YAxis = var4_197
			arg0_194.pinchValue = 1

			arg0_194:RegisterOrbits(arg0_194.cameras[var0_0.CAMERA.PHOTO])
			arg0_194:SetCameraObrits()
			setActive(arg0_194.restrictedBox, true)
			arg0_194:RegisterCameraBlendFinished(var2_197, arg0_197)
			arg0_194:ActiveCamera(var2_197)
		end,
		function(arg0_198)
			arg0_194:ShowBlackScreen(false, arg0_198)
		end
	}, function()
		arg0_194:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_200)
	arg0_200:emit(var0_0.SHOW_BLOCK)
	arg0_200:EnableJoystick(false)
	seriesAsync({
		function(arg0_201)
			arg0_200:ShowBlackScreen(true, arg0_201)
		end,
		function(arg0_202)
			arg0_200:RevertCameraOrbit()

			local var0_202 = arg0_200:GetCurrentLadyEnv()

			arg0_200:SwitchAnim(var0_202, var0_0.ANIM.IDLE)
			setActive(var0_202.ladySafeCollider, false)
			onNextTick(function()
				arg0_200:ChangeCharacterPosition(var0_202)
			end)

			if arg0_200.contextData.photoFreeMode then
				arg0_200:EnablePOVLayer(false)

				arg0_200.contextData.photoFreeMode = nil
			end

			setActive(arg0_200.restrictedBox, false)

			local var1_202 = arg0_200.cameras[var0_0.CAMERA.POV]

			arg0_200:RegisterCameraBlendFinished(var1_202, arg0_202)
			arg0_200:ActiveCamera(var1_202)
		end,
		function(arg0_204)
			arg0_200:RevertCharacter(arg0_200.apartment:GetConfigID())
			arg0_200:ShowBlackScreen(false, arg0_204)
		end
	}, function()
		arg0_200:RefreshSlots()
		arg0_200:SetAllBlackbloardValue("inLockLayer", false)
		arg0_200:emit(var0_0.HIDE_BLOCK)
		arg0_200:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_200:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_206, arg1_206, arg2_206, arg3_206)
	arg0_206:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_207)
			arg0_206:ShowBlackScreen(true, arg0_207)
		end,
		function(arg0_208)
			local var0_208 = arg0_206:GetCurrentLadyEnv()

			arg0_206:SwitchAnim(var0_208, arg2_206)
			onNextTick(function()
				arg0_206:ResetCharPoint(var0_208, arg1_206:GetWatchCameraName())
				arg0_206:SyncInterestTransform(var0_208)

				if arg0_206.contextData.photoFreeMode then
					arg0_206.camBrain.enabled = false

					arg0_206:SwitchPhotoCamera()

					arg0_206.camBrain.enabled = true

					onDelayTick(function()
						arg0_206.camBrain.enabled = false

						arg0_206:SwitchPhotoCamera()

						arg0_206.camBrain.enabled = true
					end, 0.1)
				end

				arg0_208()
			end)
		end,
		function(arg0_211)
			arg0_206:ShowBlackScreen(false, arg0_211)
		end
	}, function()
		arg0_206:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_206)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_213)
	if not arg0_213.contextData.photoFreeMode then
		arg0_213:EnableJoystick(false)
		arg0_213:EnablePOVLayer(true)

		local var0_213 = arg0_213.cameras[var0_0.CAMERA.PHOTO_FREE]
		local var1_213 = arg0_213.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_213 = arg0_213.mainCameraTF.rotation:ToEulerAngles()
		local var3_213 = var1_213.m_HorizontalAxis

		var3_213.Value = var2_213.y
		var1_213.m_HorizontalAxis = var3_213

		local var4_213 = var1_213.m_VerticalAxis

		var4_213.Value = arg0_213:GetNearestAngle(var2_213.x, var4_213.m_MinValue, var4_213.m_MaxValue)
		var1_213.m_VerticalAxis = var4_213

		local var5_213 = arg0_213.mainCameraTF.position
		local var6_213 = arg0_213:GetRestritedHeightRange()
		local var7_213 = math.InverseLerp(var6_213[1], var6_213[2], var5_213.y)

		var5_213.y = math.clamp(var5_213.y, var6_213[1], var6_213[2])
		var0_213.transform.position = var5_213

		arg0_213:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var7_213)
		arg0_213:ActiveCamera(arg0_213.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_213:EnableJoystick(true)
		arg0_213:EnablePOVLayer(false)
		arg0_213:ActiveCamera(arg0_213.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_213.contextData.photoFreeMode = not arg0_213.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_214, arg1_214)
	local var0_214 = arg0_214.cameras[var0_0.CAMERA.PHOTO_FREE]
	local var1_214 = arg0_214:GetRestritedHeightRange()
	local var2_214 = math.lerp(var1_214[1], var1_214[2], arg1_214)

	var0_214:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var2_214 - var0_214.position.y, 0))
	onNextTick(function()
		local var0_215 = arg0_214:GetRestritedHeightRange()
		local var1_215 = math.InverseLerp(var0_215[1], var0_215[2], var0_214.position.y)

		arg0_214:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_215)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_216)
	local var0_216 = arg0_216.cameras[var0_0.CAMERA.PHOTO]
	local var1_216 = var0_216.m_XAxis

	var1_216.Value = 180
	var0_216.m_XAxis = var1_216

	local var2_216 = var0_216.m_YAxis

	var2_216.Value = 0.7
	var0_216.m_YAxis = var2_216
end

function var0_0.ResetCurrentCharPoint(arg0_217, arg1_217)
	local var0_217 = arg0_217:GetCurrentLadyEnv()

	arg0_217:ResetCharPoint(var0_217, arg1_217)
end

function var0_0.ResetCharPoint(arg0_218, arg1_218, arg2_218)
	local var0_218 = (arg0_218.zoneByName[arg2_218] or arg0_218.ikPointByName[arg2_218]):Find("StayPoint")

	arg1_218.lady.position = var0_218.position
	arg1_218.lady.rotation = var0_218.rotation
end

function var0_0.GetNearestAngle(arg0_219, arg1_219, arg2_219, arg3_219)
	if arg3_219 < arg2_219 then
		arg3_219 = arg3_219 + 360
	end

	if arg2_219 <= arg1_219 and arg1_219 <= arg3_219 then
		return arg1_219
	end

	local var0_219 = (arg2_219 + arg3_219) / 2

	arg1_219 = var0_219 - Mathf.DeltaAngle(arg1_219, var0_219)
	arg1_219 = math.clamp(arg1_219, arg2_219, arg3_219)

	return arg1_219
end

function var0_0.PlayTimeline(arg0_220, arg1_220, arg2_220)
	local var0_220 = {}

	if arg0_220.waitForTimeline then
		table.insert(var0_220, function(arg0_221)
			local var0_221 = arg0_220.waitForTimeline

			arg0_220.waitForTimeline = nil

			var0_221()
			arg0_221()
		end)
	end

	table.insert(var0_220, function(arg0_222)
		arg0_220:LoadTimelineScene(arg1_220.name, false, nil, arg0_222)
	end)

	if arg1_220.scene and arg1_220.sceneRoot then
		table.insert(var0_220, function(arg0_223)
			arg0_220:ChangeArtScene(arg1_220.scene .. "|" .. arg1_220.sceneRoot, arg0_223)
		end)
	end

	table.insert(var0_220, function(arg0_224)
		local var0_224 = Dorm3dHxHelper.GetTimelineMainCharacter()

		Dorm3dHxHelper.ShowHolyLight({
			var0_224
		}, arg0_220.holyLightRoot)

		local var1_224 = GameObject.Find("[actor]").transform
		local var2_224 = var1_224:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var2_224, function(arg0_225, arg1_225)
			GetOrAddComponent(arg1_225.transform, typeof(DftAniEvent))
		end)

		var0_224 = var0_224 or var1_224:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform

		local var3_224

		eachChild(GameObject.Find("[camera]").transform, function(arg0_226)
			if arg0_226.tag == "MainCamera" then
				var3_224 = arg0_226
			end
		end)
		assert(var3_224, "Missing MainCamera")

		local var4_224 = GameObject.Find("[sequence]").transform

		arg0_220.nowTimelinePlayer = TimelinePlayer.New(var4_224)

		TimelineSupport.InitSubtitle(arg0_220.nowTimelinePlayer.comDirector, arg0_220.apartment:GetCallName())
		arg0_220.nowTimelinePlayer:Register(arg1_220.time, function(arg0_227, arg1_227, arg2_227)
			switch(arg1_227.stringParameter, {
				TimelinePause = function()
					arg0_227:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_227:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_227.intParameter == 0 or arg1_227.intParameter == arg2_227.selectIndex then
						arg0_227:SetTime(arg1_227.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_227.selectIndex = nil

					if arg1_220.options then
						local var0_231 = arg1_220.options[arg1_227.intParameter]

						arg0_220:DoTimelineOption(var0_231, function(arg0_232)
							arg2_227.selectIndex = arg0_232
							arg2_227.optionIndex = var0_231[arg0_232].flag

							arg0_227:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_227.selectIndex = nil

					if arg1_220.touchs then
						local var0_233 = arg1_220.touchs[arg1_227.intParameter]

						arg0_220:DoTimelineTouch(arg1_220.touchs[arg1_227.intParameter], function(arg0_234)
							arg2_227.selectIndex = arg0_234
							arg2_227.optionIndex = var0_233[arg0_234].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_227.selectIndex then
						arg0_227:RawSetTime(arg1_227.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_227.selectIndex = arg1_227.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_220.canTriggerAccompanyPerformance then
						arg0_220.canTriggerAccompanyPerformance = false

						local var0_237 = arg1_220.accompanys[arg1_227.intParameter]
						local var1_237 = var0_237[math.random(#var0_237)]

						arg0_227:SetTime(var1_237)
					end
				end,
				TimelineIKStart = function()
					arg2_227.selectIndex = nil

					local var0_238 = arg1_227.intParameter

					arg0_220:emit(RoomIKSystem.SET_IK_TIMELINE_STATUS, var0_224.gameObject, var0_238, var3_224)
				end,
				TimelineEnd = function()
					arg2_227.finish = true

					arg0_227:SetSpeed(0)
				end,
				TimelineAimIKStart = function()
					arg2_227.selectIndex = nil

					local var0_240 = arg1_227.intParameter

					arg0_220:emit(AimIKSystem.ENTER_TIMELINE_AIMIK_STATUS, var0_240)
				end
			}, function()
				warning("other event trigger:" .. arg1_227.stringParameter)
			end)

			if arg2_227.finish then
				arg0_220.timelineMark = arg2_227
				arg0_220.timelineFinishCall = nil

				pg.m02:sendNotification(var0_0.TIMELINE_END)
				arg0_220:emit(RoomIKSystem.EXIT_IK_TIMELINE_STATUS)
				arg0_224()
			end
		end)

		function arg0_220.timelineFinishCall()
			arg0_220.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_220:HideCharacter()
		setActive(arg0_220.mainCameraTF, false)
		setActive(var3_224, true)
		eachChild(arg0_220.rtTimelineScreen, function(arg0_243)
			setActive(arg0_243, false)
		end)
		setActive(arg0_220.rtTimelineScreen, true)
		setActive(arg0_220.rtTimelineScreen:Find("btn_skip"), arg0_220.inReplayTalk)
		arg0_220.nowTimelinePlayer:Start()
	end)
	table.insert(var0_220, function(arg0_244)
		arg0_220:ShowBlackScreen(true, function()
			arg0_220.nowTimelinePlayer:Stop()
			arg0_220.nowTimelinePlayer:Dispose()

			arg0_220.nowTimelinePlayer = nil

			arg0_220:UnloadTimelineScene(arg1_220.name, false, arg0_244)
		end)
	end)

	local var1_220 = arg0_220.dormSceneMgr.artSceneInfo

	table.insert(var0_220, function(arg0_246)
		arg0_220:RevertArtScene(var1_220, arg0_246)
	end)
	seriesAsync(var0_220, function()
		setActive(arg0_220.rtTimelineScreen, false)
		arg0_220:RevertCharacter()
		setActive(arg0_220.mainCameraTF, true)
		arg0_220:InitHolyLight()

		local var0_247 = arg0_220.timelineMark

		arg0_220.timelineMark = nil

		existCall(arg2_220, var0_247, function(arg0_248)
			arg0_220:ShowBlackScreen(false, arg0_248)
		end)
	end)
end

function var0_0.GetCurrentLadyEnv(arg0_249)
	if not arg0_249.apartment then
		return nil
	end

	return arg0_249.ladyDict[arg0_249.apartment:GetConfigID()]
end

function var0_0.PlayCurrentSingleAction(arg0_250, ...)
	local var0_250 = arg0_250:GetCurrentLadyEnv()

	return arg0_250:PlaySingleAction(var0_250, ...)
end

function var0_0.PlaySingleAction(arg0_251, arg1_251, arg2_251, arg3_251, arg4_251)
	arg1_251:PlaySingleAction(arg2_251, arg3_251, arg4_251)
end

function var0_0.SwitchCurrentAnim(arg0_252, ...)
	local var0_252 = arg0_252:GetCurrentLadyEnv()

	return arg0_252:SwitchAnim(var0_252, ...)
end

function var0_0.SwitchAnim(arg0_253, arg1_253, arg2_253, arg3_253, arg4_253)
	arg1_253:SwitchAnim(arg2_253, arg3_253, arg4_253)
end

function var0_0.PlayFaceAnim(arg0_254, arg1_254, arg2_254, arg3_254)
	arg1_254:PlayFaceAnim(arg2_254, arg3_254)
end

function var0_0.RegisterAnimCallback(arg0_255, arg1_255, arg2_255)
	arg0_255:GetCurrentLadyEnv().animCallbacks[arg1_255] = arg2_255
end

function var0_0.SetCharacterAnimSpeed(arg0_256, arg1_256)
	local var0_256 = arg0_256:GetCurrentLadyEnv()

	var0_256.ladyAnimator.speed = arg1_256
	var0_256.ladyHeadIKComp.blinkSpeed = var0_256.ladyHeadIKData.blinkSpeed * arg1_256

	if arg1_256 > 0 then
		var0_256.ladyHeadIKComp.DampTime = var0_256.ladyHeadIKData.DampTime / arg1_256
	else
		var0_256.ladyHeadIKComp.DampTime = var0_256.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_257, arg1_257)
	if arg1_257.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_257 = arg1_257.stringParameter
	local var1_257 = table.removebykey(arg0_257.animEventCallbacks, var0_257)

	existCall(var1_257)
end

function var0_0.RegisterAnimEventCallback(arg0_258, arg1_258, arg2_258)
	arg0_258.animEventCallbacks[arg1_258] = arg2_258
end

function var0_0.PlaySceneItemAnim(arg0_259, arg1_259, arg2_259, arg3_259)
	arg0_259.sceneAnimatorDict = arg0_259.sceneAnimatorDict or {}

	if not arg0_259.sceneAnimatorDict[arg1_259] then
		local var0_259 = pg.dorm3d_scene_animator[arg1_259]
		local var1_259 = arg0_259:GetSceneItem(var0_259.item_name)

		assert(var1_259, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_259 .. " " .. var0_259.item_name)

		if not var1_259 then
			return
		end

		local var2_259 = var1_259:GetComponent(typeof(Animator))

		if not var2_259 then
			return
		end

		arg0_259.sceneAnimatorDict[arg1_259] = {
			trans = var1_259,
			animator = var2_259
		}
	end

	if not arg3_259 and arg0_259.sceneAnimatorDict[arg1_259].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_259) then
		return
	end

	arg0_259.sceneAnimatorDict[arg1_259].animator:PlayInFixedTime(arg2_259, -1, arg3_259 and 0 or -math.huge)
end

function var0_0.ResetSceneItemAnimators(arg0_260, arg1_260)
	if not arg0_260.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_260.sceneAnimatorDict, function(arg0_261, arg1_261)
		if arg1_260 and table.contains(arg1_260, arg0_261) then
			return
		end

		setActive(arg1_261.trans, false)
		setActive(arg1_261.trans, true)

		arg0_260.sceneAnimatorDict[arg0_261] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_262, arg1_262, arg2_262, arg3_262, arg4_262, arg5_262, arg6_262, arg7_262, arg8_262)
	local function var0_262(arg0_263)
		if arg6_262 then
			local var0_263 = arg0_263:GetComponent(typeof(Animator))

			if var0_263 then
				var0_263:Play(arg6_262, -1, arg8_262 and 0 or -math.huge)

				var0_263.speed = arg7_262
			end
		end
	end

	arg0_262.extraItems = arg0_262.extraItems or {}

	local var1_262

	if arg3_262 == "" then
		var1_262 = arg1_262.lady
	elseif arg3_262 == "scene_root" then
		var1_262 = arg0_262.modelRoot
	else
		table.IpairsCArray(arg1_262.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_264, arg1_264)
			if arg1_264.name == arg3_262 then
				var1_262 = arg1_264
			end
		end)
	end

	if not var1_262 then
		return
	end

	local var2_262 = arg0_262.extraItems[arg2_262]

	if var2_262 then
		if var2_262.handler == var1_262 then
			var0_262(var2_262.trans)

			return
		end

		arg0_262.loader:ReturnPrefab(var2_262.trans.gameObject)

		arg0_262.extraItems[arg2_262] = nil
	end

	arg0_262.loader:GetPrefab(string.lower("dorm3d/" .. arg2_262), "", function(arg0_265)
		setParent(arg0_265, var1_262)

		if arg4_262 then
			setLocalPosition(arg0_265, arg4_262)
		end

		if arg5_262 then
			setLocalRotation(arg0_265, arg5_262)
		end

		var0_262(arg0_265)

		arg0_262.extraItems[arg2_262] = {
			trans = arg0_265.transform,
			handler = var1_262
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_266, arg1_266)
	if not arg0_266.extraItems then
		return
	end

	table.Foreach(arg0_266.extraItems, function(arg0_267, arg1_267)
		if arg1_266 and table.contains(arg1_266, arg0_267) then
			return
		end

		arg0_266.loader:ReturnPrefab(arg1_267.trans.gameObject)

		arg0_266.extraItems[arg0_267] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_268, arg1_268, arg2_268)
	arg0_268.cameraBlendCallbacks[arg1_268] = arg2_268
end

function var0_0.UnRegisterCameraBlendFinished(arg0_269, arg1_269)
	arg0_269.cameraBlendCallbacks[arg1_269] = nil
end

function var0_0.OnCameraBlendFinished(arg0_270, arg1_270)
	if not arg1_270 then
		return
	end

	local var0_270 = table.removebykey(arg0_270.cameraBlendCallbacks, arg1_270)

	existCall(var0_270)
end

function var0_0.PlayHeartFX(arg0_271, arg1_271)
	local var0_271 = arg0_271.ladyDict[arg1_271]

	setActive(var0_271.effectHeart, false)
	setActive(var0_271.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_272, arg1_272)
	local var0_272 = arg1_272.name
	local var1_272 = arg0_272.expressionDict[var0_272]
	local var2_272 = 5

	if var1_272 then
		local var3_272 = var1_272.timer

		var3_272:Reset(nil, var2_272)
		var3_272:Start()

		if var1_272.instance then
			setActive(var1_272.instance, false)
			setActive(var1_272.instance, true)
		end

		return
	end

	local var4_272 = {
		name = var0_272,
		timer = Timer.New(function()
			arg0_272:RemoveExpression(var0_272)
		end, var2_272, 1, true)
	}

	arg0_272.expressionDict[var0_272] = var4_272

	arg0_272.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_272, var0_272, function(arg0_274)
		var4_272.instance = arg0_274

		onNextTick(function()
			local var0_275 = arg0_272:GetCurrentLadyEnv()

			setParent(arg0_274, var0_275.ladyHeadCenter)
		end)
		setLocalPosition(arg0_274, Vector3(0, 0, -0.2))
		setActive(arg0_274, false)
		setActive(arg0_274, true)
	end, var4_272)
end

function var0_0.RemoveExpression(arg0_276, arg1_276)
	local var0_276 = arg0_276.expressionDict[arg1_276]

	if not var0_276 then
		return
	end

	arg0_276.loader:ClearRequest(var0_276)

	if var0_276.instance then
		arg0_276.loader:ReturnPrefab(var0_276.instance)
	end

	arg0_276.expressionDict[arg1_276] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_277, arg1_277, arg2_277)
	setActive(arg1_277.ladyWatchFloat, arg2_277)
end

function var0_0.GetCameraSettings(arg0_278)
	local var0_278 = arg0_278:GetExtraSystem(Dorm3dLightingSystem)

	assert(var0_278, "Dorm3dLightingSystem is not initialized")

	return var0_278:GetCameraSettings()
end

function var0_0.onBackPressed(arg0_279)
	if arg0_279.exited or arg0_279.retainCount > 0 then
		-- block empty
	else
		arg0_279:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_280, arg1_280, arg2_280, arg3_280, arg4_280)
	arg0_280.dormSceneMgr:LoadTimelineScene({
		name = arg1_280,
		assetRootName = arg0_280.apartment:getConfig("asset_name"),
		isCache = arg2_280,
		waitForTimeline = arg3_280,
		loadSceneFunc = function(arg0_281, arg1_281)
			local var0_281 = Dorm3dHxHelper.GetTimelineMainCharacter()

			Dorm3dHxHelper.HideCharacterPart(var0_281, nil, true)
			arg0_280:HXCharacter(var0_281)
		end
	}, arg4_280)
end

function var0_0.UnloadTimelineScene(arg0_282, arg1_282, arg2_282, arg3_282)
	arg0_282.dormSceneMgr:UnloadTimelineScene(arg1_282, arg2_282, arg3_282)
end

function var0_0.ChangeArtScene(arg0_283, arg1_283, arg2_283)
	if Dorm3dSceneMgr.IsSameSceneInfo(arg1_283, arg0_283.dormSceneMgr.artSceneInfo) then
		existCall(arg2_283)

		return
	end

	local var0_283 = Dorm3dSceneMgr.IsSameSceneInfo(arg1_283, arg0_283.dormSceneMgr.sceneInfo)
	local var1_283 = {}

	table.insert(var1_283, function(arg0_284)
		arg0_283:emit(var0_0.ART_SCENE_WILL_CHANGE, arg1_283, var0_283)
		arg0_284()
	end)
	table.insert(var1_283, function(arg0_285)
		arg0_283.dormSceneMgr:ChangeArtScene(arg1_283, arg0_285)
	end)
	table.insert(var1_283, function(arg0_286)
		arg0_283:RefreshArtSceneRefs()
		arg0_283:emit(var0_0.ART_SCENE_CHANGED, arg1_283, var0_283)
		arg0_286()
	end)
	table.insert(var1_283, function(arg0_287)
		setActive(arg0_283.slotRoot, false)
		arg0_287()
	end)
	warning(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", arg1_283, arg0_283.dormSceneMgr.sceneInfo, Dorm3dSceneMgr.IsSameSceneInfo(arg1_283, arg0_283.dormSceneMgr.sceneInfo))

	if Dorm3dSceneMgr.IsSameSceneInfo(arg1_283, arg0_283.dormSceneMgr.sceneInfo) then
		table.insert(var1_283, function(arg0_288)
			arg0_283:SwitchDayNight(1)
			arg0_283:emit(CollectionSystem.TEMP_HIDE, true)
			arg0_288()
		end)
	end

	seriesAsync(var1_283, arg2_283)
end

function var0_0.RefreshArtSceneRefs(arg0_289)
	local var0_289 = GameObject.Find("scene_root")

	assert(var0_289, "Missing scene_root after art scene change")

	arg0_289.modelRoot = var0_289.transform
end

function var0_0.MoveObjectToBaseScene(arg0_290, arg1_290)
	local var0_290 = Dorm3dSceneMgr.ParseInfo(arg0_290.dormSceneMgr.sceneInfo)
	local var1_290 = SceneManager.GetSceneByName(var0_290 .. "_base")

	arg1_290.transform:SetParent(nil)
	SceneManager.MoveGameObjectToScene(arg1_290, var1_290)
end

function var0_0.RevertArtScene(arg0_291, arg1_291, arg2_291)
	local var0_291 = {}

	table.insert(var0_291, function(arg0_292)
		arg0_291:ChangeArtScene(arg1_291, arg0_292)
	end)
	table.insert(var0_291, function(arg0_293)
		setActive(arg0_291.slotRoot, true)
		arg0_293()
	end)
	table.insert(var0_291, function(arg0_294)
		arg0_291:SwitchDayNight(arg0_291.contextData.timeIndex)
		onNextTick(function()
			arg0_291:RefreshSlots()
			arg0_291:emit(CollectionSystem.TEMP_HIDE, false)
			arg0_294()
		end)
	end)
	seriesAsync(var0_291, arg2_291)
end

function var0_0.ChangeSubScene(arg0_296, arg1_296, arg2_296)
	local var0_296 = {}

	table.insert(var0_296, function(arg0_297)
		arg0_296.dormSceneMgr:ChangeSubScene(arg1_296, arg0_297)
	end)

	local var1_296 = arg0_296:GetCurrentLadyEnv()
	local var2_296 = arg0_296:GetBlackboardValue(var1_296, "groupId")

	table.insert(var0_296, function(arg0_298)
		if Dorm3dSceneMgr.IsSameSceneInfo(arg1_296, arg0_296.dormSceneMgr.sceneInfo) then
			arg0_296:SetLadyActiveZone(var2_296, var1_296.walkBornPoint or arg0_296:GetLadyBaseZone(var2_296))
		else
			arg0_296:SetLadyActiveZone(var2_296, var1_296.walkBornPoint or "Default")
		end

		arg0_298()
	end)

	if not Dorm3dSceneMgr.IsSameSceneInfo(arg1_296, arg0_296.dormSceneMgr.subSceneInfo) then
		table.insert(var0_296, function(arg0_299)
			local var0_299, var1_299 = Dorm3dSceneMgr.ParseInfo(arg1_296)
			local var2_299 = var0_299 .. "_base"

			arg0_296:ResetSceneStructure(SceneManager.GetSceneByName(var2_299))

			if Dorm3dSceneMgr.IsSameSceneInfo(arg1_296, arg0_296.dormSceneMgr.sceneInfo) then
				arg0_296:RefreshSlots()
			else
				arg0_296:SwitchAnim(var1_296, var0_0.ANIM.IDLE)
			end

			if not Dorm3dSceneMgr.IsSameSceneInfo(arg0_296.dormSceneMgr.subSceneInfo, arg0_296.dormSceneMgr.sceneInfo) then
				arg0_296:RefreshSlotsEmpty()
			end

			arg0_299()
		end)
	end

	table.insert(var0_296, function(arg0_300)
		onNextTick(function()
			arg0_296:ChangeCharacterPosition(var1_296)
			arg0_296:ChangePlayerPosition(arg0_296:GetLadyActiveZone(var2_296))
			arg0_296:TriggerLadyDistance()
			arg0_296:CheckInSector()
			arg0_300()
		end)
	end)
	seriesAsync(var0_296, arg2_296)
end

function var0_0.IsPointInSector(arg0_302, arg1_302)
	local var0_302 = arg1_302 - arg0_302.Position

	if var0_302.y > arg0_302.Radius then
		return false
	end

	var0_302.y = 0

	if var0_302.magnitude > arg0_302.Radius then
		return false
	end

	local var1_302 = arg0_302.Rotation

	return Vector3.Angle(var1_302 * Vector3.forward, var0_302) <= arg0_302.Angle / 2
end

function var0_0.GetRestritedHeightRange(arg0_303)
	if not arg0_303.isMultiFloor then
		return arg0_303.restrictedHeightRange
	else
		for iter0_303 = #arg0_303.restrictedHeightRange, 1, -1 do
			local var0_303 = arg0_303.restrictedHeightRange[iter0_303]

			if arg0_303.mainCameraTF.position.y >= var0_303[1] then
				return var0_303
			end
		end

		return arg0_303.restrictedHeightRange[1]
	end
end

function var0_0.willExit(arg0_304)
	var0_0.super.willExit(arg0_304)
	arg0_304.joystickTimer:Stop()
	arg0_304.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_304.updateHandler)

	if arg0_304.moveTimer then
		arg0_304.moveTimer:Stop()

		arg0_304.moveTimer = nil
	end

	if arg0_304.moveWaitTimer then
		arg0_304.moveWaitTimer:Stop()

		arg0_304.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()
	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_304, iter1_304 in pairs(arg0_304.ladyDict) do
		GetComponent(iter1_304.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_304.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_304.camBrainEvenetHandler.OnBlendFinished = nil

	arg0_304:UnOverlayPanel(arg0_304.blockLayer, arg0_304._tf)
	table.Foreach(arg0_304.expressionDict, function(arg0_305)
		arg0_304:RemoveExpression(arg0_305)
	end)
	arg0_304.loader:Clear()

	arg0_304.hxHelper = nil

	pg.ClickEffectMgr.GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_304.dormSceneMgr:Dispose()

	arg0_304.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)

	if arg0_304.transformFilter then
		arg0_304.transformFilter:Dispose()
	end
end

return var0_0
