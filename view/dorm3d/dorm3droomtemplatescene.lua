local var0_0 = class("Dorm3dRoomTemplateScene", import("view.base.BaseUI"))

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
var0_0.MOVE_PLAYER_TO_FURNITURE = "Dorm3dRoomTemplateScene.MOVE_PLAYER_TO_FURNITURE"
var0_0.SHOW_BLOCK = "Dorm3dRoomTemplateScene.SHOW_BLOCK"
var0_0.HIDE_BLOCK = "Dorm3dRoomTemplateScene.HIDE_BLOCK"
var0_0.ON_TOUCH_CHARACTER = "Dorm3dRoomTemplateScene.ON_TOUCH_CHARACTER"
var0_0.ON_ROLEWATCH_CAMERA_MAX = "Dorm3dRoomTemplateScene.ON_ROLEWATCH_CAMERA_MAX"
var0_0.ON_STICK_MOVE = "Dorm3dRoomTemplateScene.ON_STICK_MOVE"
var0_0.ENABLE_SCENEBLOCK = "Dorm3dRoomTemplateScene.ENABLE_SCENEBLOCK"
var0_0.ON_BEGIN_DRAG_CHARACTER_BODY = "Dorm3dRoomTemplateScene.ON_BEGIN_DRAG_CHARACTER_BODY"
var0_0.ON_DRAG_CHARACTER_BODY = "Dorm3dRoomTemplateScene.ON_DRAG_CHARACTER_BODY"
var0_0.ON_RELEASE_CHARACTER_BODY = "Dorm3dRoomTemplateScene.ON_RELEASE_CHARACTER_BODY"
var0_0.ON_POV_STICK_MOVE_BEGIN = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE_BEGIN"
var0_0.ON_POV_STICK_MOVE = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE"
var0_0.ON_POV_STICK_MOVE_END = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE_END"
var0_0.ON_POV_STICK_VIEW = "Dorm3dRoomTemplateScene.ON_POV_STICK_VIEW"
var0_0.ON_ENTER_SECTOR = "Dorm3dRoomTemplateScene.ON_ENTER_SECTOR"
var0_0.ON_CHANGE_DISTANCE = "Dorm3dRoomTemplateScene.ON_CHANGE_DISTANCE"
var0_0.ON_IK_STATUS_CHANGED = "Dorm3dRoomTemplateScene.ON_IK_STATUS_CHANGED"
var0_0.CLICK_CHARACTER = "Dorm3dRoomTemplateScene.CLICK_CHARACTER"
var0_0.CLICK_CONTACT = "Dorm3dRoomTemplateScene.CLICK_CONTACT"
var0_0.DISTANCE_TRIGGER = "Dorm3dRoomTemplateScene.DISTANCE_TRIGGER"
var0_0.WALK_DISTANCE_TRIGGER = "Dorm3dRoomTemplateScene.WALK_DISTANCE_TRIGGER"
var0_0.CHANGE_WATCH = "Dorm3dRoomTemplateScene.CHANGE_WATCH"
var0_0.PHOTO_CALL = "Dorm3dRoomTemplateScene.PHOTO_CALL"
var0_0.SHIFT_ZONE_SAFE = "Dorm3dRoomTemplateScene.SHIFT_ZONE_SAFE"
var0_0.POV_CLOSE_DISTANCE = 1.5
var0_0.POV_PENDING_CLOSE_DISTANCE = 2
var0_0.IK_STATUS_DELTA = 0.5
var0_0.IK_TIP_WAIT_TIME = 5
var0_0.IK_STATUS = {
	RELEASE = 3,
	BEGIN = 1,
	TRIGGER = 4,
	DRAG = 2
}

function var0_0.getUIName(arg0_1)
	return nil
end

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.loadingQueue(arg0_3)
	return function(arg0_4)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_5)
			return arg0_4(arg0_5)
		end)
	end
end

function var0_0.getBGM(arg0_6)
	local var0_6 = pg.dorm3d_rooms[arg0_6.contextData.roomId].room_bgm

	if var0_6 and var0_6 ~= "" then
		return var0_6
	else
		return var0_0.super.getBGM(arg0_6)
	end
end

function var0_0.Ctor(arg0_7, ...)
	var0_0.super.Ctor(arg0_7, ...)

	arg0_7.loader = AutoLoader.New()
	arg0_7.scene = arg0_7
end

function var0_0.SetRoom(arg0_8, arg1_8)
	arg0_8.room = arg1_8
end

function var0_0.preload(arg0_9, arg1_9)
	tolua.loadassembly("MagicaClothV2")
	tolua.loadassembly("ParadoxNotion")
	tolua.loadassembly("Yongshi.BLRP.Runtime")

	for iter0_9, iter1_9 in pairs({
		_MonoManager = "ParadoxNotion.Services.MonoManager"
	}) do
		if not GameObject.Find(iter0_9) then
			local var0_9 = GameObject.New(iter0_9)

			GetOrAddComponent(var0_9, typeof(iter1_9))
		end
	end

	arg0_9.room = getProxy(ApartmentProxy):getRoom(arg0_9.contextData.roomId)

	local var1_9 = {}

	table.insert(var1_9, function(arg0_10)
		arg0_9.dormSceneMgr = Dorm3dSceneMgr.New(arg0_9.room:getConfig("scene_info"), arg0_10)
	end)
	table.insert(var1_9, function(arg0_11)
		arg0_9:LoadCharacter(arg0_9.contextData.groupIds, arg0_11)
	end)
	seriesAsync(var1_9, arg1_9)
end

function var0_0.init(arg0_12)
	arg0_12:BindEvent()
	arg0_12:InitData()
	arg0_12:initScene()
	arg0_12:initNodeCanvas()

	if arg0_12.room:isPersonalRoom() then
		local var0_12 = arg0_12.contextData.groupIds[1]
		local var1_12 = getProxy(ApartmentProxy):getApartment(var0_12)
		local var2_12 = var1_12:GetCurSkinId()
		local var3_12 = arg0_12.ladyDict[var0_12]

		setActive(var3_12.ladyGameObject, false)

		var3_12.skinId = var2_12
		var3_12.ladyGameObject = arg0_12.skinDict[var2_12].ladyGameObject

		setActive(var3_12.ladyGameObject, true)
		var3_12:HideCharacterPart(var2_12, var1_12:GetHiddenParts(var2_12))
	end

	for iter0_12, iter1_12 in pairs(arg0_12.ladyDict) do
		arg0_12:InitCharacter(iter1_12, iter0_12)
	end

	if not arg0_12.room:isPersonalRoom() then
		local var4_12 = underscore.detect(arg0_12.contextData.groupIds, function(arg0_13)
			return arg0_12.contextData.ladyZone[arg0_13] == arg0_12.contextData.inFurnitureName
		end) or arg0_12.contextData.groupIds[1]

		if var4_12 then
			arg0_12:SyncInterestTransform(arg0_12.ladyDict[var4_12])
		end

		if SlideExtraSystem.IsOpen(arg0_12.room) and arg0_12.contextData.inFurnitureName == SlideConst.SLIDE_ZONE then
			arg0_12:SyncInterestTransformByTf(arg0_12:GetFurnitureByName(arg0_12.contextData.inFurnitureName):Find("StayPoint"))
		end
	end

	arg0_12.retainCount = 0
	arg0_12.sceneBlockLayer = arg0_12._tf:Find("SceneBlock")

	setActive(arg0_12.sceneBlockLayer, false)

	arg0_12.blockLayer = arg0_12._tf:Find("Block")

	setActive(arg0_12.blockLayer, false)

	arg0_12.blackLayer = arg0_12._tf:Find("BlackScreen")

	setActive(arg0_12.blackLayer, false)

	arg0_12.holyLightRoot = arg0_12._tf:Find("HolyLightRoot")

	arg0_12:InitHolyLight()
	arg0_12:ChangePlayerPosition()

	arg0_12.cacheSceneDic = {}
	arg0_12.sceneGroupDic = {}
	arg0_12.lastSceneRootDict = {}

	pg.ClickEffectMgr.GetInstance():SetClickEffect("DORM3D")
end

function var0_0.BindEvent(arg0_14)
	arg0_14:bind(var0_0.PLAY_EXPRESSION, function(arg0_15, arg1_15)
		arg0_14:PlayExpression(arg1_15)
	end)
	arg0_14:bind(var0_0.SHOW_BLOCK, function()
		arg0_14.retainCount = arg0_14.retainCount + 1

		setActive(arg0_14.blockLayer, true)
	end)
	arg0_14:bind(var0_0.HIDE_BLOCK, function()
		arg0_14.retainCount = math.max(arg0_14.retainCount - 1, 0)

		if arg0_14.retainCount > 0 then
			return
		end

		setActive(arg0_14.blockLayer, false)
	end)
	arg0_14:bind(var0_0.ENABLE_SCENEBLOCK, function(arg0_18, arg1_18)
		setActive(arg0_14.sceneBlockLayer, arg1_18)
	end)
	arg0_14:bind(var0_0.ON_STICK_MOVE, function(arg0_19, arg1_19)
		arg0_14:OnStickMove(arg1_19)
	end)
	arg0_14:bind(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, function(arg0_20, arg1_20, arg2_20, arg3_20)
		if arg0_14.blockIK then
			return
		end

		if arg1_20.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():OnDragBegin(arg2_20, arg3_20)
	end)
	arg0_14:bind(var0_0.ON_DRAG_CHARACTER_BODY, function(arg0_21, arg1_21, arg2_21)
		if not arg1_21.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():HandleBodyDrag(arg2_21)
	end)
	arg0_14:bind(var0_0.ON_RELEASE_CHARACTER_BODY, function(arg0_22, arg1_22)
		pg.IKMgr.GetInstance():ReleaseDrag()
	end)
	arg0_14:bind(var0_0.ON_POV_STICK_MOVE_BEGIN, function(arg0_23, arg1_23)
		if arg0_14.pinchMode then
			return
		end

		arg0_14.moveStickOrigin = arg1_23.position
		arg0_14.moveStickPosition = arg0_14.moveStickOrigin
		arg0_14.moveStickDraging = true
	end)

	local function var0_14()
		arg0_14.moveStickOrigin = nil
		arg0_14.moveStickPosition = nil
		arg0_14.moveStickDraging = nil

		if isActive(arg0_14.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_14:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, Vector2.zero)
		end
	end

	arg0_14:bind(var0_0.ON_POV_STICK_MOVE_END, function(arg0_25, arg1_25)
		var0_14()
	end)
	arg0_14:bind(var0_0.ON_POV_STICK_MOVE, function(arg0_26, arg1_26)
		if arg0_14.pinchMode then
			var0_14()

			return
		end

		if not arg0_14.moveStickDraging then
			return
		end

		arg0_14.moveStickPosition = arg0_14.moveStickPosition + arg1_26

		if isActive(arg0_14.povLayer:Find("Guide")) then
			setActive(arg0_14.povLayer:Find("Guide"), false)
		end
	end)

	local var1_14 = 32.4 / Screen.height

	arg0_14:bind(var0_0.ON_POV_STICK_VIEW, function(arg0_27, arg1_27)
		if arg0_14.pinchMode then
			return
		end

		arg1_27 = arg1_27 * var1_14

		local var0_27 = arg1_27.x
		local var1_27 = arg1_27.y

		local function var2_27(arg0_28, arg1_28, arg2_28)
			local var0_28 = arg0_28[arg1_28]

			var0_28.m_InputAxisValue = arg2_28
			arg0_28[arg1_28] = var0_28
		end

		if isActive(arg0_14.cameras[var0_0.CAMERA.POV]) then
			var2_27(arg0_14.compPovAim, "m_HorizontalAxis", var0_27)
			var2_27(arg0_14.compPovAim, "m_VerticalAxis", var1_27)
		elseif isActive(arg0_14.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			local var3_27 = arg0_14.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

			var2_27(var3_27, "m_HorizontalAxis", var0_27)
			var2_27(var3_27, "m_VerticalAxis", var1_27)
		end
	end)

	local var2_14 = {
		HideSceneItem = true,
		SetExtraAnimSpeed = true,
		EnableHeadIK = true,
		PlayEnterExtraItem = true,
		ResetCharacterExtraItem = true,
		ResetTempHideSceneItems = true,
		HideCharacterBylayer = true,
		RevertCharacterBylayer = true
	}

	arg0_14:bind(var0_0.PHOTO_CALL, function(arg0_29, arg1_29, ...)
		if var2_14[arg1_29] then
			local var0_29 = arg0_14:GetCurrentLadyEnv()

			arg0_14[arg1_29](arg0_14, var0_29, ...)
		else
			arg0_14[arg1_29](arg0_14, ...)
		end
	end)
	arg0_14:bind(var0_0.SHIFT_ZONE_SAFE, function(arg0_30, arg1_30)
		arg0_14:ShiftZoneSafe(arg1_30)
	end)
end

function var0_0.RegisterIKFunc(arg0_31)
	pg.IKMgr.GetInstance():RegisterOnIKLayerActive(function(arg0_32)
		arg0_31.blockIK = true

		local var0_32 = arg0_31:GetCurrentLadyEnv()

		var0_32.ikHandler = arg0_32

		local var1_32 = _.detect(var0_32.readyIKLayers, function(arg0_33)
			return arg0_33:GetControllerPath() == arg0_32.ikData:GetControllerPath()
		end)

		arg0_31:EnableIKLayer(var1_32)

		arg0_31.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

		arg0_31:emit(var0_0.ON_IK_STATUS_CHANGED, var1_32:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDrag(function(arg0_34)
		arg0_31:GetCurrentLadyEnv().ikHandler = arg0_34

		arg0_31:ResetIKTipTimer()
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_35, arg1_35)
		local var0_35 = arg0_31:GetCurrentLadyEnv()
		local var1_35 = _.detect(var0_35.readyIKLayers, function(arg0_36)
			return arg0_36:GetControllerPath() == arg0_35.ikData:GetControllerPath()
		end)

		arg0_31:DeactiveIKLayer(var1_35)

		var0_35.ikHandler = nil
		arg0_31.blockIK = arg1_35

		arg0_31:emit(var0_0.ON_IK_STATUS_CHANGED, var1_35:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_37)
		local var0_37 = arg0_31:GetCurrentLadyEnv()

		arg0_31.blockIK = nil

		local var1_37 = _.detect(var0_37.readyIKLayers, function(arg0_38)
			return arg0_38:GetControllerPath() == arg0_37.ikData:GetControllerPath()
		end)

		arg0_31:OnTriggerIK(var1_37)
		arg0_31:emit(var0_0.ON_IK_STATUS_CHANGED, var1_37:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	end)
end

function var0_0.initScene(arg0_39)
	local var0_39, var1_39 = unpack(string.split(arg0_39.dormSceneMgr.sceneInfo, "|"))
	local var2_39 = SceneManager.GetSceneByName(var0_39 .. "_base")

	arg0_39:ResetSceneStructure(var2_39)

	arg0_39.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_39.camBrain = arg0_39.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_39.camBrainEvenetHandler = arg0_39.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_39.raycastCamera = arg0_39.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_39.sceneRaycaster = arg0_39.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_39.player = GameObject.Find("Player").transform
	arg0_39.playerEye = arg0_39.player:Find("Eye")
	arg0_39.playerFoot = arg0_39.player:Find("Foot")

	setActive(arg0_39.playerFoot, false)

	arg0_39.playerController = arg0_39.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_39.attachedPoints = {}

	eachChild(arg0_39.furnitures, function(arg0_40)
		table.insert(arg0_39.attachedPoints, 1, arg0_40)
	end)

	arg0_39.modelRoot = GameObject.Find("scene_root").transform
	arg0_39.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_39.slotRoot, true)
	arg0_39:InitSlots()
	tolua.loadassembly("Cinemachine")

	local var3_39 = GameObject.Find("CM Cameras").transform

	eachChild(var3_39, function(arg0_41)
		setActive(arg0_41, false)
	end)

	arg0_39.camBrain.enabled = false
	arg0_39.camBrain.enabled = true
	arg0_39.cameraAim = var3_39:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_39.cameraAim2 = var3_39:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_39.cameraFree = nil
	arg0_39.cameraFurnitureWatch = nil
	arg0_39.cameraRole = var3_39:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_39.cameraRole2 = var3_39:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	local var4_39 = var3_39:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	arg0_39.cameraGift = var3_39:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_39.cameras = {
		arg0_39.cameraAim,
		arg0_39.cameraAim2,
		arg0_39.cameraRole,
		[var0_0.CAMERA.TALK] = var4_39,
		[var0_0.CAMERA.GIFT] = arg0_39.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_39.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_39:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_39:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_39:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)),
		[var0_0.CAMERA.SKIN] = arg0_39.room:isPersonalRoom() and var3_39:Find("Skin Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)) or nil
	}

	setActive(arg0_39.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_39.compPovAim = arg0_39.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_39.cameraRoot = var3_39
	arg0_39.POVOriginalFOV = arg0_39:GetPOVFOV()
	arg0_39.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_39.restrictedBox, false)

	local var5_39 = arg0_39.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(CharacterController)).radius

	arg0_39.isMultiFloor = arg0_39.restrictedBox.childCount > 2

	local var6_39 = "Floor"
	local var7_39 = "Celling"

	if arg0_39.isMultiFloor then
		arg0_39.restrictedHeightRange = {}

		for iter0_39 = 0, math.floor(arg0_39.restrictedBox.childCount / 2) - 1 do
			local var8_39 = iter0_39 == 0 and var6_39 or var6_39 .. "_" .. iter0_39
			local var9_39 = iter0_39 == 0 and var7_39 or var7_39 .. "_" .. iter0_39

			table.insert(arg0_39.restrictedHeightRange, {
				arg0_39.restrictedBox:Find(var8_39).position.y + var5_39,
				arg0_39.restrictedBox:Find(var9_39).position.y - var5_39
			})
		end
	else
		arg0_39.restrictedHeightRange = {
			arg0_39.restrictedBox:Find(var6_39).position.y + var5_39,
			arg0_39.restrictedBox:Find(var7_39).position.y - var5_39
		}
	end

	arg0_39.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_39.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent("DayNightCtrl")

	arg0_39:SwitchDayNight(arg0_39.contextData.timeIndex)

	arg0_39.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_39 .. "_base")).CutIn

	if arg0_39.tfCutIn then
		arg0_39.modelCutIn = {
			lady = arg0_39.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_39.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_39.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_42, arg1_42, arg2_42)
	if arg2_42 and not IsNil(arg2_42) then
		arg2_42:SwitcherToIndex(arg1_42 - 1)
	elseif not IsNil(arg0_42.daynightCtrlComp) then
		arg0_42.daynightCtrlComp:SwitcherToIndex(arg1_42 - 1)
	end

	arg0_42:InitLightSettings()
end

function var0_0.InitLightSettings(arg0_43)
	arg0_43.globalVolume = GameObject.Find("GlobalVolume")

	arg0_43:RegisterGlobalVolume()

	arg0_43.characterLight = GameObject.Find("CharacterLight")

	arg0_43:RecordCharacterLight()

	local var0_43 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_43:GetComponentsInChildren(typeof(Light), true), function(arg0_44, arg1_44)
		arg1_44.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.ResetSceneStructure(arg0_45, arg1_45)
	table.IpairsCArray(arg1_45:GetRootGameObjects(), function(arg0_46, arg1_46)
		if arg1_46.name == "Furnitures" then
			arg0_45.furnitures = tf(arg1_46)

			eachChild(arg0_45.furnitures, function(arg0_47)
				if arg0_47:Find("FreeLook Camera") then
					setActive(arg0_47:Find("FreeLook Camera"), false)
				end

				if arg0_47:Find("FreeLook Camera") then
					setActive(arg0_47:Find("RoleWatch Camera"), false)
				end

				if arg0_47:Find("IKCamera") then
					setActive(arg0_47:Find("IKCamera"), false)
				end

				local var0_47 = arg0_47:GetComponent(typeof(UnityEngine.Collider))

				if not var0_47 then
					return
				end

				var0_47.enabled = false
			end)
		end
	end)
end

function var0_0.InitSlots(arg0_48)
	local var0_48 = arg0_48.room:GetSlots()
	local var1_48 = arg0_48.modelRoot:GetComponentsInChildren(typeof(Transform), true):ToTable()

	arg0_48.slotDict = {}

	_.each(var0_48, function(arg0_49)
		local var0_49 = arg0_49:GetFurnitureName()
		local var1_49 = arg0_49:GetConfigID()
		local var2_49 = arg0_48.slotRoot:Find(tostring(var1_49))

		if not var2_49 then
			errorMsg("Not Find Slot: " .. var1_49)

			return
		end

		local var3_49 = {
			trans = var2_49,
			sceneHides = {}
		}
		local var4_49 = var2_49:Find("Selector")

		if var4_49 then
			GetOrAddComponent(var4_49, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_50, arg1_50)
				arg0_48:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_49)
			end)
			setActive(var4_49, false)
		end

		local var5_49

		for iter0_49, iter1_49 in ipairs(var1_48) do
			if iter1_49.name == var0_49 then
				var5_49 = iter1_49

				break
			end
		end

		if var5_49 then
			var3_49.model = var5_49
		end

		arg0_48.slotDict[var1_49] = var3_49
	end)
end

function var0_0.SetContactStateDic(arg0_51, arg1_51)
	arg0_51.contactStateDic = arg1_51
	arg0_51.hideContactStateDic = {}
	arg0_51.contactInRangeDic = {}
	arg0_51.transRangeDic = {
		list = {}
	}
	arg0_51.transformFilter = arg0_51.transformFilter or BLHX.Rendering.TransformFilter.New()

	for iter0_51, iter1_51 in pairs(arg0_51.contactStateDic) do
		arg0_51.hideContactStateDic[iter0_51] = math.min(iter1_51, ApartmentRoom.ITEM_UNLOCK)
		arg0_51.contactInRangeDic[iter0_51] = false

		local var0_51 = pg.dorm3d_collection_template[iter0_51].vfx_prefab

		arg0_51.transRangeDic[iter0_51] = {
			#arg0_51.transRangeDic.list + 1,
			#var0_51
		}

		table.insertto(arg0_51.transRangeDic.list, underscore.map(var0_51, function(arg0_52)
			return arg0_51.modelRoot:Find(arg0_52)
		end))
	end

	arg0_51.transformFilter:Init(arg0_51.mainCameraTF, arg0_51.transRangeDic.list, 2, 60)
	arg0_51:ActiveContact()
end

function var0_0.TempHideContact(arg0_53, arg1_53)
	arg0_53.hideConcatFlag = arg1_53

	arg0_53:ActiveContact()
end

function var0_0.ActiveContact(arg0_54)
	for iter0_54, iter1_54 in pairs(arg0_54.contactInRangeDic) do
		arg0_54:UpdateContactDisplay(iter0_54, arg0_54.contactInRangeDic[iter0_54] and not arg0_54.hideConcatFlag and arg0_54.contactStateDic[iter0_54] or arg0_54.hideContactStateDic[iter0_54])
	end
end

function var0_0.UpdateContactDisplay(arg0_55, arg1_55, arg2_55)
	local var0_55 = pg.dorm3d_collection_template[arg1_55]

	for iter0_55, iter1_55 in ipairs(var0_55.vfx_prefab) do
		local var1_55 = arg0_55.modelRoot:Find(iter1_55)

		if arg0_55:IsModeInHidePending(iter1_55) then
			-- block empty
		elseif not arg0_55.modelRoot:Find(iter1_55) then
			warning(arg1_55, iter1_55)
		else
			setActive(var1_55, arg2_55 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_55, iter3_55 in ipairs(var0_55.model) do
		if arg0_55:IsModeInHidePending(iter3_55) then
			-- block empty
		elseif not arg0_55.modelRoot:Find(iter3_55) then
			warning(arg1_55, iter3_55)
		else
			local var2_55 = arg0_55.modelRoot:Find(iter3_55)

			if arg0_55:CheckSceneItemActive(var2_55) then
				local var3_55 = GetComponent(var2_55, typeof(EventTriggerListener))

				if arg2_55 == ApartmentRoom.ITEM_FIRST then
					var3_55 = var3_55 or GetOrAddComponent(var2_55, typeof(EventTriggerListener))

					var3_55:AddPointClickFunc(function(arg0_56, arg1_56)
						arg0_55:emit(var0_0.CLICK_CONTACT, arg1_55)
					end)

					var3_55.enabled = true
				elseif var3_55 then
					var3_55.enabled = false
				end

				setActive(var2_55, arg2_55 > ApartmentRoom.ITEM_LOCK)
			end
		end
	end
end

function var0_0.SetFloatEnable(arg0_57, arg1_57)
	arg0_57.enableFloatUpdate = arg1_57

	if arg1_57 then
		arg0_57:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_58)
	local var0_58 = arg0_58:GetCurrentLadyEnv()
	local var1_58 = arg0_58:GetScreenPosition(var0_58.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var2_58 = arg0_58:GetLocalPosition(var1_58, arg0_58.rtFloatPage)

	setLocalPosition(arg0_58.rtFloatPage:Find("lady"), var2_58)
end

function var0_0.LoadCharacter(arg0_59, arg1_59, arg2_59)
	arg0_59.hxMatDict = {}
	arg0_59.ladyDict = {}
	arg0_59.skinDict = {}

	local var0_59 = {}

	for iter0_59, iter1_59 in ipairs(arg1_59) do
		table.insert(var0_59, function(arg0_60)
			arg0_59:LoadSingleCharacter(iter1_59, arg0_60)
		end)
	end

	parallelAsync(var0_59, arg2_59)
end

function var0_0.LoadCharacterAdditionally(arg0_61, arg1_61, arg2_61)
	local var0_61 = {}

	for iter0_61, iter1_61 in ipairs(arg1_61) do
		table.insert(var0_61, function(arg0_62)
			arg0_61:LoadSingleCharacter(iter1_61, function()
				arg0_61:InitCharacter(arg0_61.ladyDict[iter1_61], iter1_61)
				arg0_62()
			end)
		end)
	end

	parallelAsync(var0_61, arg2_61)
end

function var0_0.LoadSingleCharacter(arg0_64, arg1_64, arg2_64)
	local var0_64 = {}
	local var1_64 = LadyEnv.New(arg0_64)

	arg0_64.ladyDict[arg1_64] = var1_64

	local var2_64 = getProxy(ApartmentProxy):getApartment(arg1_64)
	local var3_64 = var2_64:getConfig("asset_name")
	local var4_64 = var2_64:GetSkinModelID(arg0_64.room:getConfig("tag"))
	local var5_64 = Dorm3dSkin.New({
		configId = var4_64
	}):GetModelName()

	assert(var5_64)

	for iter0_64, iter1_64 in ipairs({
		"common",
		var5_64
	}) do
		local var6_64 = string.format("dorm3d/character/%s/res/%s", var3_64, iter1_64)

		if checkABExist(var6_64) then
			table.insert(var0_64, function(arg0_65)
				arg0_64.loader:LoadBundle(var6_64, function(arg0_66)
					for iter0_66, iter1_66 in ipairs(arg0_66:GetAllAssetNames()) do
						local var0_66, var1_66, var2_66 = string.find(string.lower(iter1_66), "material_hx[/\\](.*).mat")

						if var0_66 then
							arg0_64.hxMatDict[var2_66 .. " (Instance)"] = {
								arg0_66,
								iter1_66
							}
							arg0_64.hxMatDict[var2_66] = {
								arg0_66,
								iter1_66
							}
						end
					end

					arg0_65()
				end)
			end)
		end
	end

	var1_64.skinId = var4_64
	var1_64.skinIdList = {
		var4_64
	}

	table.insert(var0_64, function(arg0_67)
		local var0_67 = string.format("dorm3d/character/%s/prefabs/%s", var3_64, var5_64)

		arg0_64.loader:GetPrefab(var0_67, "", function(arg0_68)
			var1_64.ladyGameObject = arg0_68
			arg0_64.skinDict[var4_64] = {
				ladyGameObject = arg0_68
			}

			arg0_67()
		end)
	end)

	if arg0_64.room:isPersonalRoom() then
		for iter2_64, iter3_64 in ipairs(var2_64:GetAllModelIds()) do
			if not table.contains(var1_64.skinIdList, iter3_64) then
				local var7_64 = Dorm3dSkin.New({
					configId = iter3_64
				}):GetModelName()
				local var8_64 = string.format("dorm3d/character/%s/prefabs/%s", var3_64, var7_64)

				if checkABExist(var8_64) then
					table.insert(var1_64.skinIdList, iter3_64)
					table.insert(var0_64, function(arg0_69)
						arg0_64.loader:GetPrefab(var8_64, "", function(arg0_70)
							arg0_64.skinDict[iter3_64] = {
								ladyGameObject = arg0_70
							}
							GetComponent(arg0_70, "GraphOwner").enabled = false

							setActive(arg0_70, false)
							arg0_69()
						end)
					end)
				end
			end
		end
	end

	if arg0_64.contextData.pendingDic[arg1_64] then
		local var9_64 = pg.dorm3d_welcome[arg0_64.contextData.pendingDic[arg1_64]]

		if var9_64.item_prefab ~= "" then
			table.insert(var0_64, function(arg0_71)
				local var0_71 = string.lower("dorm3d/furniture/item/" .. var9_64.item_prefab)

				arg0_64.loader:GetPrefab(var0_71, "", function(arg0_72)
					var1_64.tfPendintItem = arg0_72.transform

					setActive(arg0_72, false)
					arg0_71()
				end)
			end)
		end
	end

	parallelAsync(var0_64, arg2_64)
end

function var0_0.HXCharacter(arg0_73, arg1_73)
	if not HXSet.isHx() then
		return
	end

	if Dorm3dHxHelper.ReplaceCharacterParts(arg1_73) then
		return
	end

	local var0_73 = arg1_73:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_73, function(arg0_74, arg1_74)
		local var0_74 = arg1_74.sharedMaterials
		local var1_74 = false

		table.IpairsCArray(var0_74, function(arg0_75, arg1_75)
			if arg1_75 == nil then
				return
			end

			local var0_75 = arg1_75.name

			if not arg0_73.hxMatDict[var0_75] then
				return
			end

			var1_74 = true

			local var1_75, var2_75 = unpack(arg0_73.hxMatDict[var0_75])
			local var3_75 = var1_75:LoadAssetSync(var2_75, typeof(Material), false, false)

			var0_74[arg0_75] = var3_75

			warning("Replace HX Material", arg0_73.hxMatDict[var0_75][2])
		end)

		if var1_74 then
			arg1_74.sharedMaterials = var0_74

			GraphicsInterface.Instance:UpdateCharacterMaterialLst(go(arg1_73))
		end
	end)
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
	arg0_77:HXCharacter(arg1_77.lady)
	arg1_77:SetZone(arg0_77.contextData.ladyZone[arg2_77])
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
		arg0_88.doneFirstSlotFresh = true

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
	arg0_88:InitExtraSystem()
end

function var0_0.InitExtraSystem(arg0_103, arg1_103)
	if not arg0_103.systemManager then
		arg0_103.systemManager = ExtraSystemManager.New(arg0_103.event, arg0_103)
	end

	arg1_103 = arg1_103 or DormConst.GetDefaultSystemClasses()

	for iter0_103, iter1_103 in ipairs(arg1_103) do
		arg0_103.systemManager:Register(iter1_103)
	end
end

function var0_0.RemoveExtraSystem(arg0_104, arg1_104)
	if not arg0_104.systemManager then
		return
	end

	arg1_104 = arg1_104 or DormConst.GetDefaultSystemClasses()

	for iter0_104, iter1_104 in ipairs(arg1_104) do
		arg0_104.systemManager:Remove(iter1_104)
	end
end

function var0_0.GetExtraSystem(arg0_105, arg1_105)
	if not arg0_105.systemManager then
		return nil
	end

	return arg0_105.systemManager:Get(arg1_105)
end

function var0_0.InitData(arg0_106)
	if not arg0_106.contextData.ladyZone then
		arg0_106.contextData.ladyZone = {}

		local var0_106
		local var1_106 = arg0_106.room:getConfig("default_zone")

		for iter0_106, iter1_106 in ipairs(var1_106) do
			arg0_106.contextData.ladyZone[iter1_106[1]] = iter1_106[2]

			if table.contains(arg0_106.contextData.groupIds, iter1_106[1]) then
				var0_106 = var0_106 or arg0_106.contextData.ladyZone[iter1_106[1]]
			end
		end

		arg0_106.contextData.inFurnitureName = var0_106 or var1_106[1][2]
	end

	arg0_106.zoneDatas = _.select(arg0_106.room:GetZones(), function(arg0_107)
		return not arg0_107:IsGlobal()
	end)
	arg0_106.activeLady = {}
end

function var0_0.Update(arg0_108)
	arg0_108.raycastCamera.fieldOfView = arg0_108.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_108.tweenFOV then
		local var0_108 = Damp(1, 1, Time.deltaTime)

		arg0_108.pinchValue = Mathf.Lerp(arg0_108.pinchValue, 1, var0_108)

		arg0_108:SetPOVFOV(arg0_108.POVOriginalFOV * arg0_108.pinchValue)

		if arg0_108.pinchValue > 0.99 then
			arg0_108.tweenFOV = nil
		end
	end

	if isActive(arg0_108.cameras[var0_0.CAMERA.POV]) then
		arg0_108:TriggerLadyDistance()
	end

	if arg0_108.contactInRangeDic then
		local var1_108 = arg0_108.transformFilter:Execute():ToTable()

		for iter0_108, iter1_108 in pairs(arg0_108.contactInRangeDic) do
			local var2_108 = pg.dorm3d_collection_template[iter0_108]
			local var3_108 = arg0_108.transRangeDic[iter0_108]
			local var4_108 = underscore(var1_108):chain():slice(unpack(var3_108)):any(function(arg0_109)
				return arg0_109
			end):value()

			if tobool(iter1_108) ~= var4_108 then
				arg0_108.contactInRangeDic[iter0_108] = var4_108

				arg0_108:UpdateContactDisplay(iter0_108, var4_108 and not arg0_108.hideConcatFlag and arg0_108.contactStateDic[iter0_108] or arg0_108.hideContactStateDic[iter0_108])
			end
		end
	end

	if arg0_108.enableFloatUpdate then
		arg0_108:UpdateFloatPosition()
	end

	arg0_108:CheckInSector()

	if arg0_108.apartment then
		(function(arg0_110)
			(function()
				if not arg0_110.ikHandler then
					return
				end

				local var0_111 = arg0_110.ikHandler.screenPosition
				local var1_111 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_111 = var0_111 - Vector2.New(var1_111.width, var1_111.height) * 0.5

				setAnchoredPosition(arg0_108:GetIKHandTF(), var2_111)

				if Time.time > arg0_108.ikNextCheckStamp then
					arg0_108.ikNextCheckStamp = arg0_108.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_111 = _.detect(arg0_110.readyIKLayers, function(arg0_112)
						return arg0_112:GetControllerPath() == arg0_110.ikHandler.ikData:GetControllerPath()
					end)

					arg0_108:emit(var0_0.ON_IK_STATUS_CHANGED, var3_111:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_108.enableIKTip then
				local var0_110 = not arg0_108.blockIK and Time.time > arg0_108.nextTipIKTime

				if var0_110 then
					local var1_110 = _.filter(arg0_110.readyIKLayers, function(arg0_113)
						return not arg0_113.ignoreDrag
					end)

					UIItemList.StaticAlign(arg0_108.ikTipsRoot, arg0_108.ikTipsRoot:GetChild(0), #var1_110, function(arg0_114, arg1_114, arg2_114)
						if arg0_114 ~= UIItemList.EventUpdate then
							return
						end

						arg1_114 = arg1_114 + 1

						local var0_114
						local var1_114 = Vector2.zero
						local var2_114 = var1_110[arg1_114]
						local var3_114 = var2_114:GetTriggerBoneName()
						local var4_114 = var3_114 and arg0_110.IKSettings.Colliders[var3_114] or nil
						local var5_114 = var2_114:GetIKTipOffset()

						if var4_114 then
							local function var6_114()
								local var0_115 = arg0_110.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var4_114.position)
								local var1_115 = CameraMgr.instance:Raycast(arg0_110.IKSettings.CameraRaycaster, var0_115)

								if var1_115.Length == 0 then
									return
								end

								return var4_114 == var1_115[0].gameObject.transform
							end
						end

						if var4_114 then
							local var7_114 = var4_114.position
							local var8_114 = var4_114:GetComponent(typeof(UnityEngine.Collider))

							if var8_114 then
								var7_114 = var8_114.bounds.center
							end

							local var9_114 = arg0_108:GetLocalPosition(arg0_108:GetScreenPosition(var7_114, arg0_110.IKSettings.CameraRaycaster.eventCamera), arg0_108.ikTipsRoot) + var5_114

							setLocalPosition(arg2_114, var9_114)

							local var10_114 = var2_114:GetTriggerRect()
							local var11_114 = var10_114:PointToNormalized(Vector2.zero)
							local var12_114 = Vector2.zero

							if var11_114.x < 0.5 and var11_114.y < 0.5 then
								var12_114 = var10_114.max
							elseif var11_114.x >= 0.5 and var11_114.y < 0.5 then
								var12_114 = Vector2.New(var10_114.xMin, var10_114.yMax)
							elseif var11_114.x < 0.5 and var11_114.y >= 0.5 then
								var12_114 = Vector2.New(var10_114.xMax, var10_114.yMin)
							elseif var11_114.x >= 0.5 and var11_114.y >= 0.5 then
								var12_114 = var10_114.min
							end

							if var11_114.x == 0.5 then
								if var9_114.x < 0 then
									var12_114.x = var10_114.xMax
								else
									var12_114.x = var10_114.xMin
								end
							end

							if var11_114.y == 0.5 then
								if var9_114.y < 0 then
									var12_114.y = var10_114.yMax
								else
									var12_114.y = var10_114.yMin
								end
							end

							local var13_114 = var12_114 - var10_114.center

							setLocalRotation(arg2_114, Quaternion.LookRotation(Vector3.forward, Vector3.New(var13_114.x, var13_114.y, 0)))
						end

						setActive(arg2_114, var4_114)
					end)
					UIItemList.StaticAlign(arg0_108.ikClickTipsRoot, arg0_108.ikClickTipsRoot:GetChild(0), #arg0_110.iKTouchDatas, function(arg0_116, arg1_116, arg2_116)
						if arg0_116 ~= UIItemList.EventUpdate then
							return
						end

						arg1_116 = arg1_116 + 1

						local var0_116
						local var1_116 = Vector2.zero
						local var2_116 = arg1_116
						local var3_116 = arg0_110.iKTouchDatas[var2_116][1]
						local var4_116 = pg.dorm3d_ik_touch[var3_116]

						if var4_116.tip_offset and var4_116.tip_offset ~= "" then
							var1_116 = Vector2.New(unpack(var4_116.tip_offset))
						end

						if #var4_116.scene_item > 0 then
							var0_116 = arg0_108:GetSceneItem(var4_116.scene_item)
						else
							var0_116 = arg0_110.IKSettings.Colliders[var4_116.body]
						end

						if var0_116 then
							local var5_116 = var0_116.position
							local var6_116 = var0_116:GetComponent(typeof(UnityEngine.Collider))

							if var6_116 then
								var5_116 = var6_116.bounds.center
							end

							setLocalPosition(arg2_116, arg0_108:GetLocalPosition(arg0_108:GetScreenPosition(var5_116, arg0_110.IKSettings.CameraRaycaster.eventCamera), arg0_108.ikClickTipsRoot) + var1_116)
						end

						setActive(arg2_116, var0_116)
					end)
				end

				setActive(arg0_108.ikTipsRoot, var0_110)
				setActive(arg0_108.ikClickTipsRoot, var0_110)
				setActive(arg0_108.ikTextTipsRoot, var0_110)
			end
		end)(arg0_108:GetCurrentLadyEnv())
	end

	if arg0_108.systemManager then
		arg0_108.systemManager:Update(Time.deltaTime)
	end
end

function var0_0.CheckInSector(arg0_117)
	if not isActive(arg0_117.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_117 = arg0_117.mainCameraTF.position

	for iter0_117, iter1_117 in pairs(arg0_117.ladyDict) do
		if iter1_117.lady then
			local var1_117 = tobool(arg0_117.activeLady[iter0_117])
			local var2_117 = {
				Radius = 2,
				Angle = 120,
				Position = iter1_117.lady.position,
				Rotation = iter1_117.lady.rotation
			}

			if var1_117 ~= tobool(var0_0.IsPointInSector(var2_117, var0_117)) then
				arg0_117.activeLady[iter0_117] = not var1_117

				arg0_117:emit(var0_0.ON_ENTER_SECTOR, iter0_117)
			end
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_118)
	for iter0_118, iter1_118 in pairs(arg0_118.ladyDict) do
		if iter1_118.lady then
			iter1_118.dis = (iter1_118.lady.position - arg0_118.player.position).magnitude

			if (arg0_118:GetBlackboardValue(iter1_118, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_118.dis ~= arg0_118:GetBlackboardValue(iter1_118, "inDistance") then
				arg0_118:SetBlackboardValue(iter1_118, "inDistance", iter1_118.dis < var0_0.POV_CLOSE_DISTANCE)
				arg0_118:emit(var0_0.ON_CHANGE_DISTANCE, iter0_118, iter1_118.dis < var0_0.POV_CLOSE_DISTANCE)
			end
		end
	end
end

function var0_0.OnStickMove(arg0_119, arg1_119)
	arg0_119.joystickDelta = arg1_119
end

function var0_0.SetPinchValue(arg0_120, arg1_120)
	arg0_120.pinchValue = arg1_120

	arg0_120:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_121)
	local var0_121 = arg0_121.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_121)
end

function var0_0.SetPOVFOV(arg0_122, arg1_122)
	local var0_122 = arg0_122.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_122, arg1_122)

	arg0_122.cameras[var0_0.CAMERA.POV].m_Lens = var0_122
end

function var0_0.RefreshSlots(arg0_123, arg1_123, arg2_123)
	arg1_123 = arg1_123 or arg0_123.room

	local var0_123 = arg1_123:GetSlots()
	local var1_123 = arg1_123:GetFurnitures()

	arg0_123:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_123, function(arg0_124, arg1_124, arg2_124)
		local var0_124 = arg1_124:GetConfigID()

		if not arg0_123.slotDict[var0_124] then
			return arg2_124()
		end

		local var1_124 = _.detect(var1_123, function(arg0_125)
			return arg0_125:GetSlotID() == var0_124
		end)
		local var2_124 = var1_124 and var1_124:GetModel() or false
		local var3_124 = arg0_123.slotDict[var0_124].model

		arg0_123.slotDict[var0_124].displayModelName = var2_124
		arg0_123.slotDict[var0_124].furnitureId = var1_124 and var1_124:GetConfigID()

		local function var4_124(arg0_126)
			if var3_124 then
				setActive(var3_124, var2_124 == "")
			end

			table.Foreach(arg0_123.slotDict[var0_124].sceneHides or {}, function(arg0_127, arg1_127)
				setActive(arg1_127.trans, arg1_127.visible)
			end)

			arg0_123.slotDict[var0_124].sceneHides = {}

			if arg0_126 then
				local var0_126 = arg0_126:getConfig("scene_hides")

				if #var0_126 > 0 then
					table.Ipairs(var0_126, function(arg0_128, arg1_128)
						local var0_128 = arg0_123.modelRoot:Find(arg1_128)

						assert(var0_128, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_126:GetConfigID(), arg1_128))

						local var1_128 = isActive(var0_128)

						table.insert(arg0_123.slotDict[var0_124].sceneHides, {
							name = arg1_128,
							trans = var0_128,
							visible = var1_128
						})
						setActive(var0_128, false)
					end)
				end
			end
		end

		if var2_124 == false or var2_124 == "" then
			arg0_123.loader:ClearRequest("slot_" .. var0_124)
			var4_124()
			arg2_124()

			return
		end

		local var5_124 = arg0_123.slotDict[var0_124].trans

		if arg0_123.loader:GetLoadingRP("slot_" .. var0_124) then
			arg0_123:emit(var0_0.HIDE_BLOCK)
		end

		arg0_123.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_124, "", function(arg0_129)
			assert(arg0_129)
			setParent(arg0_129, var5_124)
			var4_124(var1_124)
			arg2_124()
		end, "slot_" .. var0_124)
	end, function()
		arg0_123:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_123)
		warning("RefreshSlots", "Done")
		arg0_123:emit(Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE)
	end)
end

function var0_0.RefreshSlotsEmpty(arg0_131, arg1_131)
	local var0_131 = Clone(arg0_131.room)

	var0_131.furnitures = {}

	arg0_131:RefreshSlots(var0_131, arg1_131)
end

function var0_0.CheckSceneItemActiveByPath(arg0_132, arg1_132)
	local var0_132 = arg0_132:GetSceneItem(arg1_132)

	return arg0_132:CheckSceneItemActive(var0_132)
end

function var0_0.CheckSceneItemActive(arg0_133, arg1_133)
	local var0_133 = true
	local var1_133

	table.Checkout(arg0_133.slotDict, function(arg0_134, arg1_134)
		if underscore.detect(arg1_134.sceneHides, function(arg0_135)
			return arg0_135.trans == arg1_133
		end) then
			var0_133 = false
			var1_133 = arg1_134.furnitureId

			return false
		end
	end)

	return var0_133, var1_133
end

function var0_0.ChangeCharacterPosition(arg0_136, arg1_136)
	arg0_136:ResetCharPoint(arg1_136, arg1_136.ladyActiveZone)
	arg0_136:SyncInterestTransform(arg1_136)
end

function var0_0.SyncCurrentInterestTransform(arg0_137)
	local var0_137 = arg0_137:GetCurrentLadyEnv()

	arg0_137:SyncInterestTransform(var0_137)
end

function var0_0.SyncInterestTransform(arg0_138, arg1_138)
	arg0_138.ladyInterest.position = arg1_138.ladyInterestRoot.position
	arg0_138.ladyInterest.rotation = arg1_138.ladyInterestRoot.rotation
end

function var0_0.SyncInterestTransformByTf(arg0_139, arg1_139)
	arg0_139.ladyInterest.position = arg1_139.position
	arg0_139.ladyInterest.rotation = arg1_139.rotation
end

function var0_0.ChangePlayerPosition(arg0_140, arg1_140)
	arg1_140 = arg1_140 or arg0_140.contextData.inFurnitureName

	local var0_140 = arg0_140.furnitures:Find(arg1_140):Find("PlayerPoint").position

	arg0_140.player.position = var0_140
	arg0_140.cameras[var0_0.CAMERA.POV].transform.position = arg0_140.playerEye.position

	local var1_140 = arg0_140.ladyInterest.position - arg0_140.playerEye.position
	local var2_140 = Quaternion.LookRotation(var1_140).eulerAngles
	local var3_140 = var2_140.y
	local var4_140 = var2_140.x
	local var5_140 = arg0_140.compPovAim.m_HorizontalAxis

	var5_140.Value = arg0_140:GetNearestAngle(var3_140, var5_140.m_MinValue, var5_140.m_MaxValue)
	arg0_140.compPovAim.m_HorizontalAxis = var5_140

	local var6_140 = arg0_140.compPovAim.m_VerticalAxis

	var6_140.Value = var4_140
	arg0_140.compPovAim.m_VerticalAxis = var6_140
end

function var0_0.GetAttachedFurnitureName(arg0_141)
	return arg0_141.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_142, arg1_142)
	return underscore.detect(arg0_142.attachedPoints, function(arg0_143)
		return arg0_143.name == arg1_142
	end)
end

function var0_0.GetSlotByID(arg0_144, arg1_144)
	return arg0_144.displaySlots[arg1_144] and arg0_144.displaySlots[arg1_144].trans
end

function var0_0.GetScreenPosition(arg0_145, arg1_145, arg2_145)
	arg2_145 = arg2_145 or arg0_145.raycastCamera

	local var0_145 = arg2_145:WorldToScreenPoint(arg1_145)

	if var0_145.z < 0 then
		var0_145.x = var0_145.x + (var0_145.x < 0 and -1 or 1) * Screen.width
		var0_145.y = var0_145.y + (var0_145.y < 0 and -1 or 1) * Screen.height
		var0_145.z = -var0_145.z
	end

	return var0_145
end

function var0_0.GetLocalPosition(arg0_146, arg1_146, arg2_146)
	return LuaHelper.ScreenToLocal(arg2_146, arg1_146, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_147)
	return arg0_147.modelRoot
end

function var0_0.ShiftZoneSafe(arg0_148, arg1_148)
	local var0_148 = {}

	if arg0_148.room:isPersonalRoom() and not arg0_148:GetBlackboardValue(arg0_148:GetCurrentLadyEnv(), "inPending") then
		table.insert(var0_148, function(arg0_149)
			arg0_148:OutOfLazy(arg0_148.apartment:GetConfigID(), arg0_149)
		end)
	end

	table.insert(var0_148, function(arg0_150)
		arg0_148:ShiftZone(arg1_148, arg0_150)
	end)
	seriesAsync(var0_148, function()
		arg0_148:CheckQueue()
	end)
end

function var0_0.ShiftZone(arg0_152, arg1_152, arg2_152)
	local var0_152 = arg0_152:GetFurnitureByName(arg1_152)

	if not var0_152 then
		errorMsg(arg1_152 .. " Not Find")
		existCall(arg2_152)

		return
	end

	seriesAsync({
		function(arg0_153)
			arg0_152:emit(var0_0.SHOW_BLOCK)
			arg0_152:ShowBlackScreen(true, arg0_153)
		end,
		function(arg0_154)
			if arg0_152.shiftLady or arg0_152.room:isPersonalRoom() then
				local var0_154 = arg0_152.shiftLady or arg0_152.apartment:GetConfigID()

				arg0_152.shiftLady = nil
				arg0_152.contextData.ladyZone[var0_154] = var0_152.name

				local var1_154 = arg0_152.ladyDict[var0_154]

				var1_154:SetZone(arg0_152.contextData.ladyZone[var0_154])

				if arg0_152:GetBlackboardValue(var1_154, "inPending") then
					arg0_152:SetOutPending(var1_154)
					arg0_152:SwitchAnim(var1_154, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_152:ChangeCharacterPosition(var1_154)
						arg0_154()
					end)
				else
					arg0_152:ChangeCharacterPosition(var1_154)
					arg0_154()
				end
			else
				arg0_154()
			end
		end,
		function(arg0_156)
			arg0_152.contextData.inFurnitureName = var0_152.name

			if SlideExtraSystem.IsOpen(arg0_152.room) and arg0_152.contextData.inFurnitureName == SlideConst.SLIDE_ZONE then
				arg0_152:SyncInterestTransformByTf(var0_152.transform:Find("StayPoint"))
			elseif not arg0_152.apartment then
				for iter0_156, iter1_156 in pairs(arg0_152.ladyDict) do
					if iter1_156.ladyBaseZone == arg0_152.contextData.inFurnitureName then
						arg0_152:SyncInterestTransform(iter1_156)

						break
					end
				end
			end

			arg0_152:ChangePlayerPosition()
			arg0_152:TriggerLadyDistance()
			arg0_152:CheckInSector()
			arg0_156()
		end,
		function(arg0_157)
			arg0_152:UpdateZoneList()
			arg0_152:ShowBlackScreen(false, arg0_157)
		end,
		function(arg0_158)
			arg0_152:emit(var0_0.HIDE_BLOCK)
			arg0_158()
		end
	}, arg2_152)
end

function var0_0.ActiveCamera(arg0_159, arg1_159)
	local var0_159 = isActive(arg1_159)

	table.Foreach(arg0_159.cameras, function(arg0_160, arg1_160)
		setActive(arg1_160, arg1_160 == arg1_159)
	end)

	if var0_159 then
		arg0_159:OnCameraBlendFinished(arg1_159)
	end
end

function var0_0.ActiveCameraByName(arg0_161, arg1_161)
	local var0_161 = arg0_161.cameraRoot:Find(arg1_161)

	assert(var0_161, "ActiveCameraByName: " .. arg1_161 .. " not found")
	table.Foreach(arg0_161.cameras, function(arg0_162, arg1_162)
		setActive(arg1_162, false)
	end)
	setActive(var0_161, true)

	arg0_161.cameras[var0_0.CAMERA.CUSTOM] = var0_161:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
end

function var0_0.ShowBlackScreen(arg0_163, arg1_163, arg2_163)
	local var0_163 = arg0_163.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_163 and 0 or 0.3
	}

	setImageColor(arg0_163.blackLayer, Color.NewHex(var0_163.color))
	setActive(arg0_163.blackLayer, true)
	setCanvasGroupAlpha(arg0_163.blackLayer, arg1_163 and 0 or 1)
	arg0_163:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_163 then
			setActive(arg0_163.blackLayer, false)
		end

		existCall(arg2_163)
	end, GetComponent(arg0_163.blackLayer, typeof(CanvasGroup)), arg1_163 and 1 or 0, var0_163.time):setDelay(var0_163.delay)
end

function var0_0.RegisterOrbits(arg0_165, arg1_165)
	arg0_165 = arg0_165.scene
	arg0_165.orbits = {
		original = arg1_165.m_Orbits
	}
	arg0_165.orbits.current = _.range(3):map(function(arg0_166)
		local var0_166 = arg0_165.orbits.original[arg0_166 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_166.m_Height, var0_166.m_Radius)
	end)
	arg0_165.surroudCamera = arg1_165
end

function var0_0.SetCameraObrits(arg0_167)
	arg0_167 = arg0_167.scene

	local var0_167 = arg0_167.surroudCamera

	if not var0_167 then
		return
	end

	local var1_167 = arg0_167.orbits.original[1]

	for iter0_167 = 0, #arg0_167.orbits.current - 1 do
		local var2_167 = arg0_167.orbits.current[iter0_167 + 1]
		local var3_167 = arg0_167.orbits.original[iter0_167]

		var2_167.m_Height = math.lerp(var1_167.m_Height, var3_167.m_Height, arg0_167.pinchValue)
		var2_167.m_Radius = var3_167.m_Radius * arg0_167.pinchValue
	end

	var0_167.m_Orbits = arg0_167.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_168)
	arg0_168 = arg0_168.scene

	local var0_168 = arg0_168.surroudCamera

	if not var0_168 then
		return
	end

	for iter0_168 = 0, #arg0_168.orbits.current - 1 do
		local var1_168 = arg0_168.orbits.current[iter0_168 + 1]
		local var2_168 = arg0_168.orbits.original[iter0_168]

		var1_168.m_Height = var2_168.m_Height
		var1_168.m_Radius = var2_168.m_Radius
	end

	var0_168.m_Orbits = arg0_168.orbits.current
	arg0_168.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_169, arg1_169, arg2_169)
	local var0_169 = {
		base = function(arg0_170)
			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.POV], arg0_170)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_171)
			assert(arg0_169.apartment)
			arg0_169:SyncInterestTransform(arg0_169:GetCurrentLadyEnv())
			arg0_169:SetCameraLady(arg0_169:GetCurrentLadyEnv())
			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.ROLE], arg0_171)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_172)
			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.POV], arg0_172)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_173)
			arg0_173()
		end,
		gift = function(arg0_174)
			assert(arg0_169.apartment)
			arg0_169:SetCameraLady(arg0_169:GetCurrentLadyEnv())
			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.GIFT], arg0_174)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_175)
			assert(arg0_169.apartment)
			arg0_169:SetCameraLady(arg0_169:GetCurrentLadyEnv())

			arg0_169.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_169.cameraRole.transform.position

			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.ROLE2], arg0_175)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_176)
			assert(arg0_169.apartment)
			arg0_169:SetCameraLady(arg0_169:GetCurrentLadyEnv())
			arg0_169:SyncInterestTransform(arg0_169:GetCurrentLadyEnv())
			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.TALK], arg0_176)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_169 = {}

	table.insert(var1_169, function(arg0_177)
		switch(arg1_169, var0_169, arg0_177, arg0_177)
	end)
	seriesAsync(var1_169, arg2_169)
end

function var0_0.GetSceneItem(arg0_178, arg1_178)
	local var0_178

	if string.find(arg1_178, "FurnitureSlots/") == 1 then
		arg1_178 = string.gsub(arg1_178, "^FurnitureSlots/", "", 1)
		var0_178 = arg0_178.slotRoot:Find(arg1_178)
	else
		var0_178 = arg0_178.modelRoot:Find(arg1_178)
	end

	if not var0_178 then
		warning(string.format("Missing scene item path: %s", arg1_178))
	end

	return var0_178
end

function var0_0.SetSceneAnimSpeed(arg0_179, arg1_179, arg2_179)
	table.Ipairs(arg1_179 or {}, function(arg0_180, arg1_180)
		if arg0_179.sceneAnimatorDict[arg1_180] then
			arg0_179.sceneAnimatorDict[arg1_180].animator.speed = arg2_179
		end
	end)
end

function var0_0.SetExtraAnimSpeed(arg0_181, arg1_181, arg2_181, arg3_181)
	table.Ipairs(arg2_181 or {}, function(arg0_182, arg1_182)
		local var0_182 = arg1_182[1]

		if arg1_181.extraItems[var0_182] then
			arg1_181.extraItems[var0_182].trans:GetComponent(typeof(Animator)).speed = arg3_181
		end
	end)
end

function var0_0.PlayEnterSceneAnim(arg0_183, arg1_183, arg2_183, arg3_183)
	arg3_183 = arg3_183 or 1

	local var0_183 = {}

	if arg1_183 and #arg1_183 > 0 then
		table.Ipairs(arg1_183, function(arg0_184, arg1_184)
			arg0_183:PlaySceneItemAnim(arg1_184[1], arg1_184[2], arg2_183)
			arg0_183:SetSceneAnimSpeed({
				arg1_184[1]
			}, arg3_183)
			table.insert(var0_183, arg1_184[1])
		end)
	end

	arg0_183:ResetSceneItemAnimators(var0_183)
end

function var0_0.PlayEnterExtraItem(arg0_185, arg1_185, arg2_185, arg3_185)
	arg3_185 = arg3_185 or 1

	local var0_185 = {}

	if arg2_185 and #arg2_185 > 0 then
		table.Ipairs(arg2_185, function(arg0_186, arg1_186)
			local var0_186 = arg1_186[3] and Vector3.New(unpack(arg1_186[3]))
			local var1_186 = arg1_186[4] and Quaternion.Euler(unpack(arg1_186[4]))
			local var2_186 = #arg1_186 > 4 and arg1_186[5] or nil

			arg0_185:LoadCharacterExtraItem(arg1_185, arg1_186[1], arg1_186[2], var0_186, var1_186, var2_186, arg3_185)
			table.insert(var0_185, arg1_186[1])
		end)
	end

	arg0_185:ResetCharacterExtraItem(arg1_185, var0_185)
end

function var0_0.HideSceneItem(arg0_187, arg1_187, arg2_187)
	if arg2_187 and #arg2_187 > 0 then
		if arg1_187.tempHideSceneItems and #arg1_187.tempHideSceneItems > 0 then
			arg0_187:ResetTempHideSceneItems(arg1_187, arg2_187)
		end

		arg1_187.tempHideSceneItems = {}

		table.Ipairs(arg2_187, function(arg0_188, arg1_188)
			local var0_188 = arg0_187:GetSceneItem(arg1_188)

			setActive(var0_188, false)
			table.insert(arg1_187.tempHideSceneItems, arg1_188)
		end)
	end
end

function var0_0.ResetTempHideSceneItems(arg0_189, arg1_189, arg2_189)
	arg2_189 = arg2_189 or {}

	if arg1_189.tempHideSceneItems and #arg1_189.tempHideSceneItems > 0 then
		table.Ipairs(arg1_189.tempHideSceneItems, function(arg0_190, arg1_190)
			if table.contains(arg2_189, arg1_190) then
				return
			end

			local var0_190 = arg0_189:GetSceneItem(arg1_190)

			setActive(var0_190, true)
		end)

		arg1_189.tempHideSceneItems = nil
	end
end

function var0_0.SetIKStatus(arg0_191, arg1_191, arg2_191, arg3_191, arg4_191)
	warning("Set IKStatus " .. (arg2_191.id or "NIL"))

	arg0_191.enableIKTip = true

	arg0_191:ResetIKTipTimer()
	setActive(arg1_191.ladyCollider, false)
	_.each(arg1_191.ladyTouchColliders, function(arg0_192)
		setActive(arg0_192, true)
	end)

	arg0_191.blockIK = nil

	arg0_191:ClearIkTouchEvents(arg1_191)

	arg1_191.currentIkStatus = arg2_191.id
	arg1_191.ikActionDict = {}
	arg1_191.readyIKLayers = {}
	arg1_191.iKTouchDatas = arg2_191.touch_data or {}
	arg1_191.IKSettings = {
		Colliders = arg1_191.ladyColliders,
		CameraRaycaster = arg0_191.sceneRaycaster
	}

	local var0_191 = table.shallowCopy(arg2_191.ik_id)
	local var1_191 = {}

	_.each(arg1_191.iKTouchDatas, function(arg0_193)
		local var0_193 = arg0_193[3]

		if var0_193[1] == 7 then
			local var1_193 = pg.dorm3d_ik_touch_move[var0_193[2]]
			local var2_193 = var1_193.target_ik

			if not _.detect(var0_191, function(arg0_194)
				return arg0_194[1] == var2_193
			end) then
				var1_191[var2_193] = {
					back_time = var1_193.back_time
				}

				local var3_193 = {
					var2_193,
					0,
					{}
				}

				if var1_193.trigger_dialogue > 0 then
					var3_193[3] = {
						4,
						0,
						var1_193.trigger_dialogue
					}
				end

				table.insert(var0_191, var3_193)
			end
		end
	end)

	local var2_191 = _.map(var0_191, function(arg0_195)
		local var0_195 = Dorm3dIK.New({
			configId = arg0_195[1]
		})
		local var1_195 = arg0_195[3]
		local var2_195 = var1_195[1]
		local var3_195 = switch(var2_195, {
			function(arg0_196, arg1_196)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_198, arg1_198)
				return arg0_198
			end,
			function(arg0_199, arg1_199)
				return arg0_199
			end,
			function(arg0_200, arg1_200, arg2_200, arg3_200)
				return arg0_200
			end,
			function(arg0_201)
				return 0
			end
		}, function(arg0_202)
			return type(arg0_202) == "number" and arg0_202 or 0
		end, unpack(var1_195, 2))

		table.insert(arg1_191.readyIKLayers, var0_195)

		arg1_191.ikActionDict[var0_195:GetControllerPath()] = var1_195

		local var4_195 = var0_195:GetRevertTime()
		local var5_195 = var1_191[var0_195:GetConfigID()]
		local var6_195 = tobool(var5_195)

		if var6_195 then
			var3_195 = var5_195.back_time
			var4_195 = var5_195.back_time
			var0_195.ignoreDrag = true
		end

		local var7_195 = var0_195:GetSubTargets()
		local var8_195 = var0_195:GetPlaneRotations()
		local var9_195 = var0_195:GetPlaneScales()
		local var10_195 = _.map(_.range(#var7_195), function(arg0_203)
			return {
				name = var7_195[arg0_203][1],
				planeRot = var8_195[arg0_203],
				planeScale = var9_195[arg0_203]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_195:getConfig("trigger_param")[2],
			controllerName = var0_195:GetControllerPath(),
			subTargets = var10_195,
			actionType = var0_195:GetActionTriggerParams()[1],
			controlRect = var0_195:GetRect(),
			actionRect = var0_195:GetTriggerRect(),
			backTime = var4_195,
			actionRevertTime = var3_195,
			ignoreDrag = var6_195
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_191.ladyIKRoot, arg1_191.ladyBoneMaps)
	arg0_191:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_191)

	local var3_191 = _.map(arg1_191.iKTouchDatas, function(arg0_204)
		return arg0_204[1]
	end)

	table.Foreach(var3_191, function(arg0_205, arg1_205)
		local var0_205 = pg.dorm3d_ik_touch[arg1_205]

		if #var0_205.scene_item == 0 then
			return
		end

		local var1_205 = arg0_191:GetSceneItem(var0_205.scene_item)

		if not var1_205 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_205, var0_205.scene_item))

			return
		end

		if IsNil(GetComponent(var1_205, typeof(UnityEngine.Collider))) then
			go(var1_205):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_205 = GetOrAddComponent(var1_205, typeof(EventTriggerListener))

		var2_205.enabled = true

		var2_205:AddPointClickFunc(function()
			arg0_191.blockIK = true

			local var0_206 = arg1_191.iKTouchDatas[arg0_205]
			local var1_206, var2_206, var3_206 = unpack(var0_206)

			arg0_191:TouchModeAction(arg1_191, var1_206, unpack(var3_206))(function()
				arg0_191.enableIKTip = true

				arg0_191:ResetIKTipTimer()

				arg0_191.blockIK = nil
			end)
		end)
	end)

	arg0_191.camBrain.enabled = false

	if arg0_191.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_191.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_191.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var4_191 = arg0_191.cameraRoot:Find(arg2_191.ik_camera)

	assert(var4_191, "Missing IKCamera")

	arg0_191.cameras[var0_0.CAMERA.IK_WATCH] = var4_191

	arg0_191:ActiveCamera(arg0_191.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_191.camBrain.enabled = true

	local var5_191 = var4_191:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_191 then
		arg0_191:RegisterOrbits(var5_191)
	else
		arg0_191:RevertCameraOrbit()
	end

	arg0_191:SwitchAnim(arg1_191, arg2_191.character_action)
	arg0_191:SettingHeadAimIK(arg1_191, arg2_191.head_track)
	arg1_191:EnableCloth(false)
	arg1_191:EnableCloth(arg2_191.use_cloth, arg2_191.cloth_colliders)
	arg0_191:PlayEnterSceneAnim(arg2_191.enter_scene_anim)
	arg0_191:PlayEnterExtraItem(arg1_191, arg2_191.enter_extra_item)
	arg0_191:HideSceneItem(arg1_191, arg2_191.hide_scene_item)
	eachChild(arg0_191.ikTextTipsRoot, function(arg0_208)
		setActive(arg0_208, false)
	end)
	_.each(arg1_191.readyIKLayers, function(arg0_209)
		local var0_209 = arg0_209:getConfig("tip_text")

		if not var0_209 or #var0_209 == 0 then
			return
		end

		local var1_209 = arg0_191.ikTextTipsRoot:Find(var0_209)

		if not IsNil(var1_209) then
			setActive(var1_209, true)
		end
	end)
	onNextTick(function()
		local var0_210 = arg0_191.furnitures:Find(arg2_191.character_position)

		arg1_191.lady.position = var0_210:Find("StayPoint").position
		arg1_191.lady.rotation = var0_210:Find("StayPoint").rotation

		existCall(arg3_191)
	end)
end

function var0_0.ExitIKStatus(arg0_211, arg1_211, arg2_211, arg3_211, arg4_211)
	arg0_211.enableIKTip = false

	setActive(arg1_211.ladyCollider, true)
	_.each(arg1_211.ladyTouchColliders, function(arg0_212)
		setActive(arg0_212, false)
	end)

	arg0_211.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()
	setActive(arg0_211.ikTipsRoot, false)
	setActive(arg0_211.ikClickTipsRoot, false)
	arg0_211:ClearIkTouchEvents(arg1_211)

	arg1_211.currentIkStatus = nil
	arg1_211.ikActionDict = nil
	arg1_211.readyIKLayers = nil
	arg1_211.iKTouchDatas = nil

	arg0_211:RevertCameraOrbit()
	setActive(arg0_211.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_211.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg1_211:EnableCloth(false)
	arg0_211:ResetHeadAimIK(arg1_211)
	arg0_211:SwitchAnim(arg1_211, arg2_211.character_action)
	arg0_211:ResetSceneItemAnimators()

	if not arg4_211.ignoreResetExtraItem then
		arg0_211:ResetCharacterExtraItem(arg1_211)
		arg0_211:ResetTempHideSceneItems(arg1_211)
	end

	onNextTick(function()
		if arg2_211.character_position then
			arg1_211.ladyActiveZone = arg2_211.character_position
		else
			arg1_211.ladyActiveZone = arg1_211.ladyBaseZone
		end

		arg0_211:ChangeCharacterPosition(arg1_211)
		arg0_211:TriggerLadyDistance()
		arg0_211:CheckInSector()
		existCall(arg3_211)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_214, arg1_214, arg2_214, arg3_214, arg4_214, arg5_214)
	warning("Set IKStatus " .. (arg3_214 or "NIL"))
	arg1_214:SetCurrentIkTimelineStatus(arg3_214)

	arg0_214.enableIKTip = true

	setActive(arg0_214.ikControlUI, true)
	arg0_214:ResetIKTipTimer()

	arg0_214.blockIK = nil

	local var0_214 = pg.dorm3d_ik_timeline_status[arg3_214]

	arg1_214.readyIKLayers = {}
	arg1_214.iKTouchDatas = {}
	arg1_214.IKSettings = {
		CameraRaycaster = GetOrAddComponent(arg4_214, typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_214.IKSettings.CameraRaycaster)

	local var1_214 = {}

	table.IpairsCArray(arg2_214:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_215, arg1_215)
		if arg1_215.name == "SafeCollider" then
			setActive(arg1_215, false)

			return
		end

		if arg1_215:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_215 = tf(arg1_215)
		local var1_215 = var0_215.name
		local var2_215 = var1_215 and string.find(var1_215, "Collider") or -1

		if var2_215 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var1_215)

			return
		end

		local var3_215 = string.sub(var1_215, 1, var2_215 - 1)

		if var3_215 == "Body" or var3_215 == "Safe" then
			setActive(var0_215, false)

			return
		end

		if DormConst.BONE_TO_TOUCH[var3_215] == nil then
			return
		end

		var1_214[var3_215] = var0_215

		setActive(var0_215, true)
	end)

	arg1_214.IKSettings.Colliders = var1_214

	local var2_214 = GetOrAddComponent(arg2_214, typeof(EventTriggerListener))

	arg1_214.ikTimelineMode = true

	local var3_214 = _.map(var0_214.ik_id, function(arg0_216)
		local var0_216 = Dorm3dIK.New({
			configId = arg0_216
		})

		table.insert(arg1_214.readyIKLayers, var0_216)

		local var1_216 = var0_216:GetSubTargets()
		local var2_216 = var0_216:GetPlaneRotations()
		local var3_216 = var0_216:GetPlaneScales()
		local var4_216 = _.map(_.range(#var1_216), function(arg0_217)
			return {
				name = var1_216[arg0_217][1],
				planeRot = var2_216[arg0_217],
				planeScale = var3_216[arg0_217]
			}
		end)

		return Dorm3dIKController.New({
			ignoreDrag = false,
			triggerName = var0_216:getConfig("trigger_param")[2],
			controllerName = var0_216:GetControllerPath(),
			subTargets = var4_216,
			actionType = var0_216:GetActionTriggerParams()[1],
			controlRect = var0_216:GetRect(),
			actionRect = var0_216:GetTriggerRect(),
			backTime = var0_216:GetRevertTime(),
			actionRevertTime = var0_216:GetActionRevertTime(),
			timelineActionEvent = var0_216:GetTimelineAction()
		})
	end)
	local var4_214 = arg2_214.transform:Find("IKLayers")
	local var5_214 = {}
	local var6_214 = {}

	table.Foreach(DormConst.boneMap, function(arg0_218, arg1_218)
		var6_214[arg1_218] = arg0_218
	end)

	local var7_214 = arg2_214.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var7_214, function(arg0_219, arg1_219)
		if var6_214[arg1_219.name] then
			var5_214[var6_214[arg1_219.name]] = arg1_219
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var4_214, var5_214)
	arg0_214:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var3_214)
	eachChild(arg0_214.ikTextTipsRoot, function(arg0_220)
		setActive(arg0_220, false)
	end)
	_.each(arg1_214.readyIKLayers, function(arg0_221)
		local var0_221 = arg0_221:getConfig("tip_text")

		if not var0_221 or #var0_221 == 0 then
			return
		end

		local var1_221 = arg0_214.ikTextTipsRoot:Find(var0_221)

		if not IsNil(var1_221) then
			setActive(var1_221, true)
		end
	end)
	existCall(arg5_214)
end

function var0_0.ExitIKTimelineStatus(arg0_222, arg1_222, arg2_222)
	arg1_222:SetCurrentIkTimelineStatus(nil)

	arg0_222.enableIKTip = false

	setActive(arg0_222.ikControlUI, false)

	arg0_222.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_222.readyIKLayers = nil
	arg1_222.iKTouchDatas = nil
	arg1_222.IKSettings = nil

	setActive(arg0_222.ikTipsRoot, false)
	setActive(arg0_222.ikClickTipsRoot, false)
	existCall(arg2_222)
end

function var0_0.ClearIkTouchEvents(arg0_223, arg1_223)
	local var0_223 = _.map(arg1_223.iKTouchDatas or {}, function(arg0_224)
		return arg0_224[1]
	end)

	table.Foreach(var0_223, function(arg0_225, arg1_225)
		local var0_225 = pg.dorm3d_ik_touch[arg1_225]

		if #var0_225.scene_item == 0 then
			return
		end

		local var1_225 = arg0_223:GetSceneItem(var0_225.scene_item)

		if not var1_225 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_225, var0_225.scene_item))

			return
		end

		local var2_225 = GetOrAddComponent(var1_225, typeof(EventTriggerListener))

		var2_225:ClearEvents()

		var2_225.enabled = false
	end)
end

function var0_0.EnableIKLayer(arg0_226, arg1_226)
	local var0_226 = arg0_226:GetCurrentLadyEnv()

	if #arg1_226:GetHeadTrackPath() > 0 then
		arg0_226:SettingHeadAimIK(var0_226, {
			2,
			arg1_226:GetHeadTrackPath()
		}, true)
	end

	local var1_226 = arg1_226:GetTriggerFaceAnim()

	if #var1_226 > 0 then
		arg0_226:PlayFaceAnim(var0_226, var1_226)
	end

	if not arg1_226.ignoreDrag then
		setActive(arg0_226:GetIKHandTF(), true)
		eachChild(arg0_226:GetIKHandTF(), function(arg0_227)
			setActive(arg0_227, false)
		end)
		arg0_226:StopIKHandTimer()
		setActive(arg0_226:GetIKHandTF():Find("Begin"), true)

		arg0_226.ikHandTimer = Timer.New(function()
			setActive(arg0_226:GetIKHandTF():Find("Begin"), false)
			setActive(arg0_226:GetIKHandTF():Find("Normal"), true)
		end, 0.5, 1)

		arg0_226.ikHandTimer:Start()
	end

	if not var0_226.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_226.apartment.configId, arg0_226.apartment.level, var0_226.ikConfig.character_action, arg1_226:GetTriggerParams()[2], arg0_226.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_229, arg1_229)
	local var0_229 = arg0_229:GetCurrentLadyEnv()

	if not var0_229.ikTimelineMode and #arg1_229:GetHeadTrackPath() > 0 then
		arg0_229:SettingHeadAimIK(var0_229, var0_229.ikConfig.head_track)
	end

	arg0_229:StopIKHandTimer()

	if not arg1_229.ignoreDrag then
		setActive(arg0_229:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_229:GetIKHandTF():Find("Normal"), false)
		setActive(arg0_229:GetIKHandTF():Find("End"), true)

		arg0_229.ikHandTimer = Timer.New(function()
			setActive(arg0_229:GetIKHandTF():Find("End"), false)
			setActive(arg0_229:GetIKHandTF(), false)
		end, 0.5, 1)

		arg0_229.ikHandTimer:Start()
	end
end

function var0_0.StopIKHandTimer(arg0_231)
	if not arg0_231.ikHandTimer then
		return
	end

	arg0_231.ikHandTimer:Stop()

	arg0_231.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_232, arg1_232, arg2_232, arg3_232)
	local var0_232 = Time.time

	function arg0_232.ikRevertHandler()
		local var0_233 = Time.time - var0_232

		_.each(arg1_232.activeIKLayers, function(arg0_234)
			local var0_234 = 1

			if arg2_232 > 0 then
				var0_234 = var0_233 / arg2_232
			end

			local var1_234 = arg1_232.cacheIKInfos[arg0_234].solvers
			local var2_234 = arg1_232.cacheIKInfos[arg0_234].weights

			table.Foreach(var1_234, function(arg0_235, arg1_235)
				arg1_235.IKPositionWeight = math.lerp(var2_234[arg0_235], 0, var0_234)
			end)
		end)

		if var0_233 >= arg2_232 then
			arg0_232:ResetActiveIKs(arg1_232)

			arg0_232.ikRevertHandler = nil

			existCall(arg3_232)
		end
	end

	arg0_232.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_236, arg1_236)
	table.insertto(arg0_236.activeIKLayers, _.keys(arg0_236.holdingStatus))
	table.clear(arg0_236.holdingStatus)
	_.each(arg1_236.activeIKLayers, function(arg0_237)
		local var0_237 = arg0_237:GetControllerPath()
		local var1_237 = arg1_236.ladyIKRoot:Find(var0_237):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_237, false)

		local var2_237 = arg1_236.cacheIKInfos[arg0_237].solvers
		local var3_237 = arg1_236.cacheIKInfos[arg0_237].weights

		table.Foreach(var2_237, function(arg0_238, arg1_238)
			arg1_238.IKPositionWeight = var3_237[arg0_238]
		end)
	end)
	table.clear(arg1_236.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_239)
	if not arg0_239.enableIKTip then
		return
	end

	arg0_239.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_240, arg1_240)
	local var0_240 = arg0_240:GetCurrentLadyEnv()

	arg0_240:EnableHeadIK(var0_240, arg1_240)
end

function var0_0.EnableHeadIK(arg0_241, arg1_241, arg2_241)
	arg1_241.ladyHeadIKComp.enableIk = arg2_241
end

function var0_0.SettingHeadAimIK(arg0_242, arg1_242, arg2_242, arg3_242)
	local var0_242

	if arg2_242[1] == 0 then
		arg0_242:EnableHeadIK(arg1_242, false)

		return
	elseif arg2_242[1] == 1 then
		arg0_242:EnableHeadIK(arg1_242, true)

		var0_242 = arg0_242.mainCameraTF:Find("AimTarget")
	elseif arg2_242[1] == 2 then
		arg0_242:EnableHeadIK(arg1_242, true)
		table.IpairsCArray(arg1_242.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_243, arg1_243)
			if arg1_243.name ~= arg2_242[2] then
				return
			end

			var0_242 = arg1_243
		end)
	end

	arg1_242.ladyHeadIKComp.AimTarget = var0_242

	if not arg3_242 and arg2_242[3] then
		arg1_242.ladyHeadIKComp.BodyWeight = arg2_242[3]
	end

	if not arg3_242 and arg2_242[4] then
		arg1_242.ladyHeadIKComp.HeadWeight = arg2_242[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_244, arg1_244)
	arg0_244:EnableHeadIK(arg1_244, true)

	arg1_244.ladyHeadIKComp.AimTarget = arg0_244.mainCameraTF:Find("AimTarget")
	arg1_244.ladyHeadIKComp.HeadWeight = arg1_244.ladyHeadIKData.HeadWeight
	arg1_244.ladyHeadIKComp.BodyWeight = arg1_244.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_245, arg1_245)
	for iter0_245, iter1_245 in pairs(arg0_245.ladyDict) do
		if iter0_245 ~= arg1_245 then
			arg0_245:HideCharacterBylayer(iter1_245)
		end
	end
end

function var0_0.RevertCharacter(arg0_246, arg1_246)
	for iter0_246, iter1_246 in pairs(arg0_246.ladyDict) do
		if iter0_246 ~= arg1_246 then
			arg0_246:RevertCharacterBylayer(iter1_246)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_247, arg1_247)
	local var0_247 = "Bip001"
	local var1_247 = arg1_247.lady:Find("all")

	for iter0_247 = 0, var1_247.childCount - 1 do
		local var2_247 = var1_247:GetChild(iter0_247)

		if var2_247.name ~= var0_247 then
			pg.ViewUtils.SetLayer(var2_247, Layer.Environment3D)
		end
	end

	if arg1_247.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_247.tfPendintItem, Layer.Environment3D)
	end

	if arg1_247.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_247.ladyWatchFloat, Layer.Environment3D)
	end
end

function var0_0.RevertCharacterBylayer(arg0_248, arg1_248)
	local var0_248 = "Bip001"
	local var1_248 = arg1_248.lady:Find("all")

	for iter0_248 = 0, var1_248.childCount - 1 do
		local var2_248 = var1_248:GetChild(iter0_248)

		if var2_248.name ~= var0_248 then
			pg.ViewUtils.SetLayer(var2_248, Layer.Character3D)
		end
	end

	if arg1_248.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_248.tfPendintItem, Layer.Default)
	end

	if arg1_248.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_248.ladyWatchFloat, Layer.Default)
	end
end

function var0_0.EnterFurnitureWatchMode(arg0_249)
	arg0_249:SetAllBlackbloardValue("inLockLayer", true)
	arg0_249:EnableJoystick(true)
	arg0_249:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_250, arg1_250)
	arg0_250:HideFurnitureSlots()

	local var0_250 = arg0_250.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_251)
			arg0_250.furniturePOV = nil

			arg0_250:EnableJoystick(false)
			arg0_250:emit(var0_0.SHOW_BLOCK)
			arg0_250:ShowBlackScreen(true, arg0_251)
		end,
		function(arg0_252)
			existCall(arg1_250)
			arg0_250:RevertCharacter()
			arg0_250:SetAllBlackbloardValue("inLockLayer", false)
			arg0_250:RegisterCameraBlendFinished(var0_250, arg0_252)
			arg0_250:ActiveCamera(var0_250)
		end,
		function(arg0_253)
			arg0_250:ShowBlackScreen(false, arg0_253)
		end
	}, function()
		arg0_250:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_250:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_255, arg1_255)
	local var0_255 = arg0_255:GetFurnitureByName(arg1_255:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_255.cameraFurnitureWatch and arg0_255.cameraFurnitureWatch ~= var0_255 then
		arg0_255:UnRegisterCameraBlendFinished(arg0_255.cameraFurnitureWatch)
		setActive(arg0_255.cameraFurnitureWatch, false)
	end

	arg0_255.cameraFurnitureWatch = var0_255
	arg0_255.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_255.cameraFurnitureWatch
	arg0_255.furniturePOV = arg0_255.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_255:RegisterCameraBlendFinished(arg0_255.cameraFurnitureWatch, function()
		arg0_255:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_255:emit(var0_0.SHOW_BLOCK)
	arg0_255:ActiveCamera(arg0_255.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_257)
	if arg0_257.displaySlots then
		arg0_257:UpdateDisplaySlots({})
		table.Foreach(arg0_257.displaySlots, function(arg0_258, arg1_258)
			local var0_258 = arg1_258.trans

			if IsNil(var0_258:Find("Selector")) then
				return
			end

			setActive(var0_258:Find("Selector"), false)
		end)

		arg0_257.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_259, arg1_259)
	arg0_259:HideFurnitureSlots()

	arg0_259.displaySlots = {}

	_.each(arg1_259, function(arg0_260)
		arg0_259.displaySlots[arg0_260] = arg0_259.slotDict[arg0_260]

		if not arg0_259.displaySlots[arg0_260] then
			errorMsg("Slot " .. arg0_260 .. " Not Binding Scene Object")

			return
		end

		local var0_260 = arg0_259.displaySlots[arg0_260].trans

		if var0_260:Find("Selector") then
			setActive(var0_260:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_261, arg1_261)
	table.Foreach(arg0_261.displaySlots, function(arg0_262, arg1_262)
		local var0_262 = arg1_262.trans

		if not IsNil(var0_262:Find("Selector")) then
			setActive(var0_262:Find("Selector/Normal"), arg1_261[arg0_262] == 0)
			setActive(var0_262:Find("Selector/Active"), arg1_261[arg0_262] == 1)
			setActive(var0_262:Find("Selector/Ban"), arg1_261[arg0_262] == 2)
		end

		local var1_262 = arg0_261.slotDict[arg0_262].model
		local var2_262 = arg0_261.slotDict[arg0_262].displayModelName

		if var2_262 and var2_262 ~= "" then
			var1_262 = var0_262:GetChild(var0_262.childCount - 1)
		end

		local function var3_262(arg0_263, arg1_263)
			local var0_263 = arg0_263:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_263, function(arg0_264, arg1_264)
				local var0_264 = arg1_264.material

				if var0_264 and var0_264:HasProperty("_FinalTint") then
					var0_264:SetColor("_FinalTint", arg1_263)
				end
			end)
		end

		if var1_262 then
			if arg1_261[arg0_262] == 1 then
				var3_262(var1_262, Color.NewHex("3F83AE73"))
			else
				var3_262(var1_262, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_265, arg1_265, arg2_265)
	arg0_265:SetAllBlackbloardValue("inLockLayer", true)
	arg0_265:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_266)
			arg0_265:TempHideUI(true, arg0_266)
		end,
		function(arg0_267)
			arg0_265:ShowBlackScreen(true, arg0_267)
		end,
		function(arg0_268)
			local var0_268 = arg0_265.apartment:GetConfigID()
			local var1_268 = arg0_265.ladyDict[var0_268]

			arg0_265:SwitchAnim(var1_268, arg2_265)
			var1_268.ladyAnimator:Update(0)
			arg0_265:ResetCharPoint(var1_268, arg1_265:GetWatchCameraName())
			arg0_265:SyncInterestTransform(var1_268)
			setActive(var1_268.ladySafeCollider, true)
			arg0_265:HideCharacter(var0_268)

			local var2_268 = arg0_265.cameras[var0_0.CAMERA.PHOTO]
			local var3_268 = var2_268.m_XAxis

			var3_268.Value = 180
			var2_268.m_XAxis = var3_268

			local var4_268 = var2_268.m_YAxis

			var4_268.Value = 0.7
			var2_268.m_YAxis = var4_268
			arg0_265.pinchValue = 1

			arg0_265:RegisterOrbits(arg0_265.cameras[var0_0.CAMERA.PHOTO])
			arg0_265:SetCameraObrits()
			setActive(arg0_265.restrictedBox, true)
			arg0_265:RegisterCameraBlendFinished(var2_268, arg0_268)
			arg0_265:ActiveCamera(var2_268)
		end,
		function(arg0_269)
			arg0_265:ShowBlackScreen(false, arg0_269)
		end
	}, function()
		arg0_265:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_271)
	arg0_271:emit(var0_0.SHOW_BLOCK)
	arg0_271:EnableJoystick(false)
	seriesAsync({
		function(arg0_272)
			arg0_271:ShowBlackScreen(true, arg0_272)
		end,
		function(arg0_273)
			arg0_271:RevertCameraOrbit()

			local var0_273 = arg0_271:GetCurrentLadyEnv()

			arg0_271:SwitchAnim(var0_273, var0_0.ANIM.IDLE)
			setActive(var0_273.ladySafeCollider, false)
			onNextTick(function()
				arg0_271:ChangeCharacterPosition(var0_273)
			end)

			if arg0_271.contextData.photoFreeMode then
				arg0_271:EnablePOVLayer(false)

				arg0_271.contextData.photoFreeMode = nil
			end

			setActive(arg0_271.restrictedBox, false)

			local var1_273 = arg0_271.cameras[var0_0.CAMERA.POV]

			arg0_271:RegisterCameraBlendFinished(var1_273, arg0_273)
			arg0_271:ActiveCamera(var1_273)
		end,
		function(arg0_275)
			arg0_271:RevertCharacter(arg0_271.apartment:GetConfigID())
			arg0_271:ShowBlackScreen(false, arg0_275)
		end
	}, function()
		arg0_271:RefreshSlots()
		arg0_271:SetAllBlackbloardValue("inLockLayer", false)
		arg0_271:emit(var0_0.HIDE_BLOCK)
		arg0_271:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_271:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_277, arg1_277, arg2_277, arg3_277)
	arg0_277:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_278)
			arg0_277:ShowBlackScreen(true, arg0_278)
		end,
		function(arg0_279)
			local var0_279 = arg0_277:GetCurrentLadyEnv()

			arg0_277:SwitchAnim(var0_279, arg2_277)
			onNextTick(function()
				arg0_277:ResetCharPoint(var0_279, arg1_277:GetWatchCameraName())
				arg0_277:SyncInterestTransform(var0_279)

				if arg0_277.contextData.photoFreeMode then
					arg0_277.camBrain.enabled = false

					arg0_277:SwitchPhotoCamera()

					arg0_277.camBrain.enabled = true

					onDelayTick(function()
						arg0_277.camBrain.enabled = false

						arg0_277:SwitchPhotoCamera()

						arg0_277.camBrain.enabled = true
					end, 0.1)
				end

				arg0_279()
			end)
		end,
		function(arg0_282)
			arg0_277:ShowBlackScreen(false, arg0_282)
		end
	}, function()
		arg0_277:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_277)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_284)
	if not arg0_284.contextData.photoFreeMode then
		arg0_284:EnableJoystick(false)
		arg0_284:EnablePOVLayer(true)

		local var0_284 = arg0_284.cameras[var0_0.CAMERA.PHOTO_FREE]
		local var1_284 = arg0_284.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_284 = arg0_284.mainCameraTF.rotation:ToEulerAngles()
		local var3_284 = var1_284.m_HorizontalAxis

		var3_284.Value = var2_284.y
		var1_284.m_HorizontalAxis = var3_284

		local var4_284 = var1_284.m_VerticalAxis

		var4_284.Value = arg0_284:GetNearestAngle(var2_284.x, var4_284.m_MinValue, var4_284.m_MaxValue)
		var1_284.m_VerticalAxis = var4_284

		local var5_284 = arg0_284.mainCameraTF.position
		local var6_284 = arg0_284:GetRestritedHeightRange()
		local var7_284 = math.InverseLerp(var6_284[1], var6_284[2], var5_284.y)

		var5_284.y = math.clamp(var5_284.y, var6_284[1], var6_284[2])
		var0_284.transform.position = var5_284

		arg0_284:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var7_284)
		arg0_284:ActiveCamera(arg0_284.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_284:EnableJoystick(true)
		arg0_284:EnablePOVLayer(false)
		arg0_284:ActiveCamera(arg0_284.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_284.contextData.photoFreeMode = not arg0_284.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_285, arg1_285)
	local var0_285 = arg0_285.cameras[var0_0.CAMERA.PHOTO_FREE]
	local var1_285 = arg0_285:GetRestritedHeightRange()
	local var2_285 = math.lerp(var1_285[1], var1_285[2], arg1_285)

	var0_285:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var2_285 - var0_285.position.y, 0))
	onNextTick(function()
		local var0_286 = arg0_285:GetRestritedHeightRange()
		local var1_286 = math.InverseLerp(var0_286[1], var0_286[2], var0_285.position.y)

		arg0_285:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_286)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_287)
	local var0_287 = arg0_287.cameras[var0_0.CAMERA.PHOTO]
	local var1_287 = var0_287.m_XAxis

	var1_287.Value = 180
	var0_287.m_XAxis = var1_287

	local var2_287 = var0_287.m_YAxis

	var2_287.Value = 0.7
	var0_287.m_YAxis = var2_287
end

function var0_0.ResetCurrentCharPoint(arg0_288, arg1_288)
	local var0_288 = arg0_288:GetCurrentLadyEnv()

	arg0_288:ResetCharPoint(var0_288, arg1_288)
end

function var0_0.ResetCharPoint(arg0_289, arg1_289, arg2_289)
	local var0_289 = arg0_289.furnitures:Find(arg2_289 .. "/StayPoint")

	arg1_289.lady.position = var0_289.position
	arg1_289.lady.rotation = var0_289.rotation
end

function var0_0.GetNearestAngle(arg0_290, arg1_290, arg2_290, arg3_290)
	if arg3_290 < arg2_290 then
		arg3_290 = arg3_290 + 360
	end

	if arg2_290 <= arg1_290 and arg1_290 <= arg3_290 then
		return arg1_290
	end

	local var0_290 = (arg2_290 + arg3_290) / 2

	arg1_290 = var0_290 - Mathf.DeltaAngle(arg1_290, var0_290)
	arg1_290 = math.clamp(arg1_290, arg2_290, arg3_290)

	return arg1_290
end

function var0_0.PlayTimeline(arg0_291, arg1_291, arg2_291)
	local var0_291 = {}

	if arg0_291.waitForTimeline then
		table.insert(var0_291, function(arg0_292)
			local var0_292 = arg0_291.waitForTimeline

			arg0_291.waitForTimeline = nil

			var0_292()
			arg0_292()
		end)
	end

	table.insert(var0_291, function(arg0_293)
		arg0_291:LoadTimelineScene(arg1_291.name, false, nil, arg0_293)
	end)

	if arg1_291.scene and arg1_291.sceneRoot then
		table.insert(var0_291, function(arg0_294)
			arg0_291:ChangeArtScene(arg1_291.scene .. "|" .. arg1_291.sceneRoot, arg0_294)
		end)
	end

	table.insert(var0_291, function(arg0_295)
		local var0_295 = Dorm3dHxHelper.GetTimelineMainCharacter()

		Dorm3dHxHelper.ShowHolyLight({
			var0_295
		}, arg0_291.holyLightRoot)

		local var1_295 = GameObject.Find("[actor]").transform
		local var2_295 = var1_295:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var2_295, function(arg0_296, arg1_296)
			GetOrAddComponent(arg1_296.transform, typeof(DftAniEvent))
		end)

		var0_295 = var0_295 or var1_295:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform

		local var3_295

		eachChild(GameObject.Find("[camera]").transform, function(arg0_297)
			if arg0_297.tag == "MainCamera" then
				var3_295 = arg0_297
			end
		end)
		assert(var3_295, "Missing MainCamera")

		local var4_295 = GameObject.Find("[sequence]").transform

		arg0_291.nowTimelinePlayer = TimelinePlayer.New(var4_295)

		TimelineSupport.InitSubtitle(arg0_291.nowTimelinePlayer.comDirector, arg0_291.apartment:GetCallName())
		arg0_291.nowTimelinePlayer:Register(arg1_291.time, function(arg0_298, arg1_298, arg2_298)
			switch(arg1_298.stringParameter, {
				TimelinePause = function()
					arg0_298:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_298:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_298.intParameter == 0 or arg1_298.intParameter == arg2_298.selectIndex then
						arg0_298:SetTime(arg1_298.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_298.selectIndex = nil

					if arg1_291.options then
						local var0_302 = arg1_291.options[arg1_298.intParameter]

						arg0_291:DoTimelineOption(var0_302, function(arg0_303)
							arg2_298.selectIndex = arg0_303
							arg2_298.optionIndex = var0_302[arg0_303].flag

							arg0_298:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_298.selectIndex = nil

					if arg1_291.touchs then
						local var0_304 = arg1_291.touchs[arg1_298.intParameter]

						arg0_291:DoTimelineTouch(arg1_291.touchs[arg1_298.intParameter], function(arg0_305)
							arg2_298.selectIndex = arg0_305
							arg2_298.optionIndex = var0_304[arg0_305].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_298.selectIndex then
						arg0_298:RawSetTime(arg1_298.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_298.selectIndex = arg1_298.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_291.canTriggerAccompanyPerformance then
						arg0_291.canTriggerAccompanyPerformance = false

						local var0_308 = arg1_291.accompanys[arg1_298.intParameter]
						local var1_308 = var0_308[math.random(#var0_308)]

						arg0_298:SetTime(var1_308)
					end
				end,
				TimelineIKStart = function()
					arg2_298.selectIndex = nil

					local var0_309 = arg1_298.intParameter
					local var1_309 = arg0_291:GetCurrentLadyEnv()

					if var1_309:CheckIkTimelineStatus(var0_309) then
						arg0_291:SetIKTimelineStatus(var1_309, var0_295.gameObject, var0_309, var3_295)
					end
				end,
				TimelineEnd = function()
					arg2_298.finish = true

					arg0_298:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_298.stringParameter)
			end)

			if arg2_298.finish then
				arg0_291.timelineMark = arg2_298
				arg0_291.timelineFinishCall = nil

				local var0_298 = arg0_291:GetCurrentLadyEnv()

				if var0_298.ikTimelineMode then
					arg0_291:ExitIKTimelineStatus(var0_298)
				end

				arg0_295()
			end
		end)

		function arg0_291.timelineFinishCall()
			arg0_291.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_291:HideCharacter()
		setActive(arg0_291.mainCameraTF, false)
		setActive(var3_295, true)
		eachChild(arg0_291.rtTimelineScreen, function(arg0_313)
			setActive(arg0_313, false)
		end)
		setActive(arg0_291.rtTimelineScreen, true)
		setActive(arg0_291.rtTimelineScreen:Find("btn_skip"), arg0_291.inReplayTalk)
		arg0_291.nowTimelinePlayer:Start()
	end)
	table.insert(var0_291, function(arg0_314)
		arg0_291:ShowBlackScreen(true, function()
			arg0_291.nowTimelinePlayer:Stop()
			arg0_291.nowTimelinePlayer:Dispose()

			arg0_291.nowTimelinePlayer = nil

			arg0_291:UnloadTimelineScene(arg1_291.name, false, arg0_314)
		end)
	end)

	local var1_291 = arg0_291.dormSceneMgr.artSceneInfo

	table.insert(var0_291, function(arg0_316)
		arg0_291:RevertArtScene(var1_291, arg0_316)
	end)
	seriesAsync(var0_291, function()
		setActive(arg0_291.rtTimelineScreen, false)
		arg0_291:RevertCharacter()
		setActive(arg0_291.mainCameraTF, true)
		arg0_291:InitHolyLight()

		local var0_317 = arg0_291.timelineMark

		arg0_291.timelineMark = nil

		existCall(arg2_291, var0_317, function(arg0_318)
			arg0_291:ShowBlackScreen(false, arg0_318)
		end)
	end)
end

function var0_0.GetCurrentLadyEnv(arg0_319)
	if not arg0_319.apartment then
		return nil
	end

	return arg0_319.ladyDict[arg0_319.apartment:GetConfigID()]
end

function var0_0.PlayCurrentSingleAction(arg0_320, ...)
	local var0_320 = arg0_320:GetCurrentLadyEnv()

	return arg0_320:PlaySingleAction(var0_320, ...)
end

function var0_0.PlaySingleAction(arg0_321, arg1_321, arg2_321, arg3_321, arg4_321)
	arg1_321:PlaySingleAction(arg2_321, arg3_321, arg4_321)
end

function var0_0.SwitchCurrentAnim(arg0_322, ...)
	local var0_322 = arg0_322:GetCurrentLadyEnv()

	return arg0_322:SwitchAnim(var0_322, ...)
end

function var0_0.SwitchAnim(arg0_323, arg1_323, arg2_323, arg3_323)
	arg1_323:SwitchAnim(arg2_323, arg3_323)
end

function var0_0.PlayFaceAnim(arg0_324, arg1_324, arg2_324, arg3_324)
	arg1_324:PlayFaceAnim(arg2_324, arg3_324)
end

function var0_0.RegisterAnimCallback(arg0_325, arg1_325, arg2_325)
	arg0_325:GetCurrentLadyEnv().animCallbacks[arg1_325] = arg2_325
end

function var0_0.SetCharacterAnimSpeed(arg0_326, arg1_326)
	local var0_326 = arg0_326:GetCurrentLadyEnv()

	var0_326.ladyAnimator.speed = arg1_326
	var0_326.ladyHeadIKComp.blinkSpeed = var0_326.ladyHeadIKData.blinkSpeed * arg1_326

	if arg1_326 > 0 then
		var0_326.ladyHeadIKComp.DampTime = var0_326.ladyHeadIKData.DampTime / arg1_326
	else
		var0_326.ladyHeadIKComp.DampTime = var0_326.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_327, arg1_327)
	if arg1_327.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_327 = arg1_327.stringParameter
	local var1_327 = table.removebykey(arg0_327.animEventCallbacks, var0_327)

	existCall(var1_327)
end

function var0_0.RegisterAnimEventCallback(arg0_328, arg1_328, arg2_328)
	arg0_328.animEventCallbacks[arg1_328] = arg2_328
end

function var0_0.PlaySceneItemAnim(arg0_329, arg1_329, arg2_329, arg3_329)
	arg0_329.sceneAnimatorDict = arg0_329.sceneAnimatorDict or {}

	if not arg0_329.sceneAnimatorDict[arg1_329] then
		local var0_329 = pg.dorm3d_scene_animator[arg1_329]
		local var1_329 = arg0_329:GetSceneItem(var0_329.item_name)

		assert(var1_329, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_329 .. " " .. var0_329.item_name)

		if not var1_329 then
			return
		end

		local var2_329 = var1_329:GetComponent(typeof(Animator))

		if not var2_329 then
			return
		end

		arg0_329.sceneAnimatorDict[arg1_329] = {
			trans = var1_329,
			animator = var2_329
		}
	end

	if not arg3_329 and arg0_329.sceneAnimatorDict[arg1_329].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_329) then
		return
	end

	arg0_329.sceneAnimatorDict[arg1_329].animator:PlayInFixedTime(arg2_329)
end

function var0_0.ResetSceneItemAnimators(arg0_330, arg1_330)
	if not arg0_330.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_330.sceneAnimatorDict, function(arg0_331, arg1_331)
		if arg1_330 and table.contains(arg1_330, arg0_331) then
			return
		end

		setActive(arg1_331.trans, false)
		setActive(arg1_331.trans, true)

		arg0_330.sceneAnimatorDict[arg0_331] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_332, arg1_332, arg2_332, arg3_332, arg4_332, arg5_332, arg6_332, arg7_332)
	local function var0_332(arg0_333)
		if arg6_332 then
			local var0_333 = arg0_333:GetComponent(typeof(Animator))

			if var0_333 then
				var0_333:Play(arg6_332)

				var0_333.speed = arg7_332
			end
		end
	end

	arg1_332.extraItems = arg1_332.extraItems or {}

	if arg1_332.extraItems[arg2_332] then
		var0_332(arg1_332.extraItems[arg2_332].trans)

		return
	end

	local var1_332

	if arg3_332 == "" then
		var1_332 = arg1_332.lady
	elseif arg3_332 == "scene_root" then
		var1_332 = arg0_332.modelRoot
	else
		table.IpairsCArray(arg1_332.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_334, arg1_334)
			if arg1_334.name == arg3_332 then
				var1_332 = arg1_334
			end
		end)
	end

	if not var1_332 then
		return
	end

	arg0_332.loader:GetPrefab(string.lower("dorm3d/" .. arg2_332), "", function(arg0_335)
		setParent(arg0_335, var1_332)

		if arg4_332 then
			setLocalPosition(arg0_335, arg4_332)
		end

		if arg5_332 then
			setLocalRotation(arg0_335, arg5_332)
		end

		var0_332(arg0_335)

		arg1_332.extraItems[arg2_332] = {
			trans = arg0_335.transform,
			handler = var1_332
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_336, arg1_336, arg2_336)
	if not arg1_336.extraItems then
		return
	end

	table.Foreach(arg1_336.extraItems, function(arg0_337, arg1_337)
		if arg2_336 and table.contains(arg2_336, arg0_337) then
			return
		end

		arg0_336.loader:ReturnPrefab(arg1_337.trans.gameObject)

		arg1_336.extraItems[arg0_337] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_338, arg1_338, arg2_338)
	arg0_338.cameraBlendCallbacks[arg1_338] = arg2_338
end

function var0_0.UnRegisterCameraBlendFinished(arg0_339, arg1_339)
	arg0_339.cameraBlendCallbacks[arg1_339] = nil
end

function var0_0.OnCameraBlendFinished(arg0_340, arg1_340)
	if not arg1_340 then
		return
	end

	local var0_340 = table.removebykey(arg0_340.cameraBlendCallbacks, arg1_340)

	existCall(var0_340)
end

function var0_0.PlayHeartFX(arg0_341, arg1_341)
	local var0_341 = arg0_341.ladyDict[arg1_341]

	setActive(var0_341.effectHeart, false)
	setActive(var0_341.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_342, arg1_342)
	local var0_342 = arg1_342.name
	local var1_342 = arg0_342.expressionDict[var0_342]
	local var2_342 = 5

	if var1_342 then
		local var3_342 = var1_342.timer

		var3_342:Reset(nil, var2_342)
		var3_342:Start()

		if var1_342.instance then
			setActive(var1_342.instance, false)
			setActive(var1_342.instance, true)
		end

		return
	end

	local var4_342 = {
		name = var0_342,
		timer = Timer.New(function()
			arg0_342:RemoveExpression(var0_342)
		end, var2_342, 1, true)
	}

	arg0_342.expressionDict[var0_342] = var4_342

	arg0_342.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_342, var0_342, function(arg0_344)
		var4_342.instance = arg0_344

		onNextTick(function()
			local var0_345 = arg0_342:GetCurrentLadyEnv()

			setParent(arg0_344, var0_345.ladyHeadCenter)
		end)
		setLocalPosition(arg0_344, Vector3(0, 0, -0.2))
		setActive(arg0_344, false)
		setActive(arg0_344, true)
	end, var4_342)
end

function var0_0.RemoveExpression(arg0_346, arg1_346)
	local var0_346 = arg0_346.expressionDict[arg1_346]

	if not var0_346 then
		return
	end

	arg0_346.loader:ClearRequest(var0_346)

	if var0_346.instance then
		arg0_346.loader:ReturnPrefab(var0_346.instance)
	end

	arg0_346.expressionDict[arg1_346] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_347, arg1_347, arg2_347)
	setActive(arg1_347.ladyWatchFloat, arg2_347)
end

function var0_0.RegisterGlobalVolume(arg0_348)
	local var0_348 = arg0_348.globalVolume
	local var1_348 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_348, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_348 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_348, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	arg0_348.originalCameraSettings = {
		depthOfField = {
			enabled = var1_348.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_348.gaussianStart.min,
				value = var1_348.gaussianStart.value
			},
			blurRadius = {
				min = var1_348.blurRadius.min,
				max = var1_348.blurRadius.max,
				value = var1_348.blurRadius.value
			}
		},
		postExposure = {
			value = var2_348.postExposure.value
		},
		contrast = {
			min = var2_348.contrast.min,
			max = var2_348.contrast.max,
			value = var2_348.contrast.value
		},
		saturate = {
			min = var2_348.saturation.min,
			max = var2_348.saturation.max,
			value = var2_348.saturation.value
		}
	}
	arg0_348.originalCameraSettings.depthOfField.enabled = true

	local var3_348 = var0_348:GetComponent(typeof(UnityEngine.Rendering.Volume))

	arg0_348.originalVolume = {
		profile = var3_348.sharedProfile,
		weight = var3_348.weight
	}
end

function var0_0.SettingCamera(arg0_349, arg1_349)
	arg0_349.activeCameraSettings = arg1_349

	local var0_349 = arg0_349.globalVolume
	local var1_349 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_349, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_349 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_349, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	var1_349.enabled:Override(arg1_349.depthOfField.enabled)
	var1_349.gaussianStart:Override(arg1_349.depthOfField.focusDistance.value)
	var1_349.gaussianEnd:Override(arg1_349.depthOfField.focusDistance.value + arg1_349.depthOfField.focusDistance.length)
	var1_349.blurRadius:Override(arg1_349.depthOfField.blurRadius.value)
	var2_349.postExposure:Override(arg1_349.postExposure.value)
	var2_349.contrast:Override(arg1_349.contrast.value)
	var2_349.saturation:Override(arg1_349.saturate.value)
end

function var0_0.GetCameraSettings(arg0_350)
	return arg0_350.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_351)
	arg0_351:SettingCamera(arg0_351.originalCameraSettings)

	arg0_351.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_352, arg1_352, arg2_352)
	if arg0_352.cameraVolume then
		arg0_352:RevertVolumeProfile()
	end

	arg0_352.loader:GetPrefab("dorm3d/effect/volume/" .. arg1_352, "", function(arg0_353)
		arg0_352.cameraVolume = arg0_353
	end)
end

function var0_0.RevertVolumeProfile(arg0_354)
	if arg0_354.cameraVolume then
		arg0_354.loader:ReturnPrefab(arg0_354.cameraVolume)

		arg0_354.cameraVolume = nil
	end
end

function var0_0.RecordCharacterLight(arg0_355)
	tolua.loadassembly("Yongshi.BLRP.Runtime.AOT")

	local var0_355 = arg0_355.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	arg0_355.originalCharacterColor = {
		color = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var0_355),
		intensity = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var0_355)
	}
end

function var0_0.SetCharacterLight(arg0_356, arg1_356, arg2_356, arg3_356)
	local var0_356 = arg0_356.characterLight:GetComponent(typeof(Light))
	local var1_356 = Color.Lerp(arg0_356.originalCharacterColor.color, arg1_356, arg3_356)
	local var2_356 = math.lerp(arg0_356.originalCharacterColor.intensity, arg2_356, arg3_356)
	local var3_356 = arg0_356.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var3_356, var1_356)
	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var3_356, var2_356)
end

function var0_0.RevertCharacterLight(arg0_357)
	arg0_357:SetCharacterLight(arg0_357.originalCharacterColor.color, arg0_357.originalCharacterColor.intensity, 1)
end

function var0_0.onBackPressed(arg0_358)
	if arg0_358.exited or arg0_358.retainCount > 0 then
		-- block empty
	else
		arg0_358:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_359, arg1_359, arg2_359, arg3_359, arg4_359)
	arg0_359.dormSceneMgr:LoadTimelineScene({
		name = arg1_359,
		assetRootName = arg0_359.apartment:getConfig("asset_name"),
		isCache = arg2_359,
		waitForTimeline = arg3_359,
		loadSceneFunc = function(arg0_360, arg1_360)
			local var0_360 = Dorm3dHxHelper.GetTimelineMainCharacter()

			arg0_359:HXCharacter(var0_360)
		end
	}, arg4_359)
end

function var0_0.UnloadTimelineScene(arg0_361, arg1_361, arg2_361, arg3_361)
	arg0_361.dormSceneMgr:UnloadTimelineScene(arg1_361, arg2_361, arg3_361)
end

function var0_0.ChangeArtScene(arg0_362, arg1_362, arg2_362)
	local var0_362 = {}

	table.insert(var0_362, function(arg0_363)
		arg0_362.dormSceneMgr:ChangeArtScene(arg1_362, arg0_363)
	end)
	table.insert(var0_362, function(arg0_364)
		setActive(arg0_362.slotRoot, false)
		arg0_364()
	end)
	warning(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", arg1_362, arg0_362.dormSceneMgr.sceneInfo, Dorm3dSceneMgr.IsSameSceneInfo(arg1_362, arg0_362.dormSceneMgr.sceneInfo))

	if Dorm3dSceneMgr.IsSameSceneInfo(arg1_362, arg0_362.dormSceneMgr.sceneInfo) then
		table.insert(var0_362, function(arg0_365)
			arg0_362:SwitchDayNight(1)
			arg0_362:TempHideContact(true)
			arg0_365()
		end)
	end

	seriesAsync(var0_362, arg2_362)
end

function var0_0.RevertArtScene(arg0_366, arg1_366, arg2_366)
	local var0_366 = {}

	table.insert(var0_366, function(arg0_367)
		arg0_366.dormSceneMgr:ChangeArtScene(arg1_366, arg0_367)
	end)
	table.insert(var0_366, function(arg0_368)
		setActive(arg0_366.slotRoot, true)
		arg0_368()
	end)
	table.insert(var0_366, function(arg0_369)
		arg0_366:SwitchDayNight(arg0_366.contextData.timeIndex)
		onNextTick(function()
			arg0_366:RefreshSlots()
			arg0_366:TempHideContact(false)
			arg0_369()
		end)
	end)
	seriesAsync(var0_366, arg2_366)
end

function var0_0.ChangeSubScene(arg0_371, arg1_371, arg2_371)
	local var0_371 = {}

	table.insert(var0_371, function(arg0_372)
		arg0_371.dormSceneMgr:ChangeSubScene(arg1_371, arg0_372)
	end)

	local var1_371 = arg0_371:GetCurrentLadyEnv()

	table.insert(var0_371, function(arg0_373)
		if Dorm3dSceneMgr.IsSameSceneInfo(arg1_371, arg0_371.dormSceneMgr.sceneInfo) then
			var1_371.ladyActiveZone = var1_371.walkBornPoint or var1_371.ladyBaseZone
		else
			var1_371.ladyActiveZone = var1_371.walkBornPoint or "Default"
		end

		arg0_373()
	end)

	if not Dorm3dSceneMgr.IsSameSceneInfo(arg1_371, arg0_371.dormSceneMgr.subSceneInfo) then
		table.insert(var0_371, function(arg0_374)
			local var0_374, var1_374 = Dorm3dSceneMgr.ParseInfo(arg1_371)
			local var2_374 = var0_374 .. "_base"

			arg0_371:ResetSceneStructure(SceneManager.GetSceneByName(var2_374))

			if Dorm3dSceneMgr.IsSameSceneInfo(arg1_371, arg0_371.dormSceneMgr.sceneInfo) then
				arg0_371:RefreshSlots()
			else
				arg0_371:SwitchAnim(var1_371, var0_0.ANIM.IDLE)
			end

			if not Dorm3dSceneMgr.IsSameSceneInfo(arg0_371.dormSceneMgr.subSceneInfo, arg0_371.dormSceneMgr.sceneInfo) then
				arg0_371:RefreshSlotsEmpty()
			end

			arg0_374()
		end)
	end

	table.insert(var0_371, function(arg0_375)
		onNextTick(function()
			arg0_371:ChangeCharacterPosition(var1_371)
			arg0_371:ChangePlayerPosition(var1_371.ladyActiveZone)
			arg0_371:TriggerLadyDistance()
			arg0_371:CheckInSector()
			arg0_375()
		end)
	end)
	seriesAsync(var0_371, arg2_371)
end

function var0_0.IsPointInSector(arg0_377, arg1_377)
	local var0_377 = arg1_377 - arg0_377.Position

	if var0_377.y > arg0_377.Radius then
		return false
	end

	var0_377.y = 0

	if var0_377.magnitude > arg0_377.Radius then
		return false
	end

	local var1_377 = arg0_377.Rotation

	return Vector3.Angle(var1_377 * Vector3.forward, var0_377) <= arg0_377.Angle / 2
end

function var0_0.GetRestritedHeightRange(arg0_378)
	if not arg0_378.isMultiFloor then
		return arg0_378.restrictedHeightRange
	else
		for iter0_378 = #arg0_378.restrictedHeightRange, 1, -1 do
			local var0_378 = arg0_378.restrictedHeightRange[iter0_378]

			if arg0_378.mainCameraTF.position.y >= var0_378[1] then
				return var0_378
			end
		end

		return arg0_378.restrictedHeightRange[1]
	end
end

function var0_0.willExit(arg0_379)
	arg0_379:RemoveExtraSystem()

	if arg0_379.systemManager then
		arg0_379.systemManager:Dispose()

		arg0_379.systemManager = nil
	end

	arg0_379.joystickTimer:Stop()
	arg0_379.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_379.updateHandler)
	arg0_379:StopIKHandTimer()

	if arg0_379.moveTimer then
		arg0_379.moveTimer:Stop()

		arg0_379.moveTimer = nil
	end

	if arg0_379.moveWaitTimer then
		arg0_379.moveWaitTimer:Stop()

		arg0_379.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_379.furnitures) then
		eachChild(arg0_379.furnitures, function(arg0_380)
			local var0_380 = GetComponent(arg0_380, typeof(EventTriggerListener))

			if not var0_380 then
				return
			end

			var0_380:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_379, iter1_379 in pairs(arg0_379.ladyDict) do
		GetComponent(iter1_379.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_379.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_379.camBrainEvenetHandler.OnBlendFinished = nil

	arg0_379:UnOverlayPanel(arg0_379.blockLayer, arg0_379._tf)
	table.Foreach(arg0_379.expressionDict, function(arg0_381)
		arg0_379:RemoveExpression(arg0_381)
	end)
	arg0_379.loader:Clear()
	pg.ClickEffectMgr.GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_379.dormSceneMgr:Dispose()

	arg0_379.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)

	if arg0_379.transformFilter then
		arg0_379.transformFilter:Dispose()
	end
end

return var0_0
