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
var0_0.STOCKING_EVENT = "Dorm3dRoomTemplateScene.STOCKING_EVENT"
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
		PlayEnterExtraItem = true,
		SetExtraAnimSpeed = true,
		EnableHeadIK = true,
		ResetCharacterExtraItem = true,
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
	arg0_14:bind(var0_0.STOCKING_EVENT, function(arg0_30, arg1_30, ...)
		arg0_14.stockingMgr[arg1_30](arg0_14.stockingMgr, ...)
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

function var0_0.InitCharacter(arg0_76, arg1_76, arg2_76)
	arg1_76:InitCharacter(arg2_76)
	arg0_76:HXCharacter(arg1_76.lady)
	arg1_76:SetZone(arg0_76.contextData.ladyZone[arg2_76])
	arg0_76:ChangeCharacterPosition(arg1_76)
end

function var0_0.SetCameraLady(arg0_77, arg1_77)
	arg0_77.cameraAim2.LookAt = arg1_77.ladyInterestRoot
	arg0_77.cameras[var0_0.CAMERA.TALK].Follow = arg1_77.ladyInterestRoot
	arg0_77.cameras[var0_0.CAMERA.TALK].LookAt = arg1_77.ladyInterestRoot
	arg0_77.cameraGift.Follow = arg0_77.ladyInterest
	arg0_77.cameraGift.LookAt = arg0_77.ladyInterest
	arg0_77.cameraRole2.LookAt = arg1_77.ladyInterestRoot
	arg0_77.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_77.ladyInterest
	arg0_77.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_77.ladyInterest
end

function var0_0.initNodeCanvas(arg0_78)
	local var0_78 = pg.NodeCanvasMgr.GetInstance()

	var0_78:Active()
	var0_78:RegisterFunc("DistanceTrigger", function(arg0_79)
		arg0_78:emit(var0_0.DISTANCE_TRIGGER, arg0_79, arg0_78.ladyDict[arg0_79].dis)
	end)
	var0_78:RegisterFunc("ShortWaitAction", function(arg0_80)
		arg0_78:DoShortWait(arg0_80)
	end)
	var0_78:RegisterFunc("WatchShortWaitAction", function(arg0_81)
		arg0_78:DoShortWait(arg0_81)
	end)
	var0_78:RegisterFunc("WalkDistanceTrigger", function(arg0_82)
		arg0_78:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_82, arg0_78.ladyDict[arg0_82].dis)
	end)
	var0_78:RegisterFunc("ChangeWatch", function(arg0_83)
		arg0_78:emit(var0_0.CHANGE_WATCH, arg0_83)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_84, arg1_84, arg2_84)
	arg0_84[arg1_84] = arg2_84

	for iter0_84, iter1_84 in pairs(arg0_84.ladyDict) do
		arg0_84:SetBlackboardValue(iter1_84, arg1_84, arg2_84)
	end
end

function var0_0.SetBlackboardValue(arg0_85, arg1_85, arg2_85, arg3_85)
	arg1_85:SetBlackboardValue(arg2_85, arg3_85)
end

function var0_0.GetBlackboardValue(arg0_86, arg1_86, arg2_86)
	return arg1_86:GetBlackboardValue(arg2_86)
end

function var0_0.didEnter(arg0_87)
	local var0_87 = -21.6 / Screen.height

	arg0_87.joystickDelta = Vector2.zero
	arg0_87.joystickTimer = FrameTimer.New(function()
		local var0_88 = arg0_87.joystickDelta * var0_87
		local var1_88 = var0_88.x
		local var2_88 = var0_88.y

		local function var3_88(arg0_89, arg1_89, arg2_89)
			local var0_89 = arg0_89[arg1_89]

			var0_89.m_InputAxisValue = arg2_89
			arg0_89[arg1_89] = var0_89
		end

		if arg0_87.surroudCamera and not arg0_87.pinchMode then
			var3_88(arg0_87.surroudCamera, "m_XAxis", var1_88)
			var3_88(arg0_87.surroudCamera, "m_YAxis", var2_88)
		elseif arg0_87.furniturePOV and arg0_87.cameras[var0_0.CAMERA.FURNITURE_WATCH] and isActive(arg0_87.cameras[var0_0.CAMERA.FURNITURE_WATCH]) then
			var3_88(arg0_87.furniturePOV, "m_HorizontalAxis", var1_88)
			var3_88(arg0_87.furniturePOV, "m_VerticalAxis", var2_88)
		end

		arg0_87.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_87.joystickTimer:Start()

	local var1_87 = 1.75

	arg0_87.moveStickTimer = FrameTimer.New(function()
		if not arg0_87.moveStickDraging then
			return
		end

		local var0_90 = arg0_87.moveStickPosition
		local var1_90 = 200
		local var2_90 = (var0_90 - arg0_87.moveStickOrigin):ClampMagnitude(var1_90)
		local var3_90 = var2_90 / var1_90

		arg0_87.moveStickPosition = arg0_87.moveStickOrigin + var2_90

		local var4_90 = Vector3.New(var3_90.x, 0, var3_90.y)
		local var5_90 = arg0_87.mainCameraTF:TransformDirection(var4_90)

		var5_90.y = 0

		local var6_90 = var5_90:Normalize()

		var6_90:Mul(var1_87)

		if isActive(arg0_87.cameras[var0_0.CAMERA.POV]) then
			arg0_87.playerController:SimpleMove(var6_90)

			arg0_87.tweenFOV = true
		elseif isActive(arg0_87.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_87.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_90 * Time.deltaTime)
			arg0_87:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_90:Normalize())
			onNextTick(function()
				local var0_91 = arg0_87.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_91 = arg0_87:GetRestritedHeightRange()
				local var2_91 = math.InverseLerp(var1_91[1], var1_91[2], var0_91.position.y)

				arg0_87:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var2_91)
			end)
		end
	end, 1, -1)

	arg0_87.moveStickTimer:Start()

	arg0_87.pinchMode = false
	arg0_87.pinchSize = 0
	arg0_87.pinchValue = 1
	arg0_87.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_92, arg1_92)
		if arg0_87.surroudCamera and isActive(arg0_87.surroudCamera) then
			arg0_87.pinchMode = true
			arg0_87.pinchSize = (arg0_92 - arg1_92):Magnitude()
			arg0_87.pinchNodeOrder = arg1_92.x < arg0_92.x and -1 or 1

			return
		end

		if isActive(arg0_87.cameras[var0_0.CAMERA.POV]) then
			if (arg0_92 - arg1_92):Magnitude() < Screen.height * 0.5 then
				arg0_87.pinchMode = true
				arg0_87.pinchSize = (arg0_92 - arg1_92):Magnitude()
				arg0_87.pinchNodeOrder = arg1_92.x < arg0_92.x and -1 or 1
			end

			return
		end
	end)

	local var2_87 = 0.01

	if IsUnityEditor then
		var2_87 = 0.1
	end

	local var3_87 = var2_87 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_93, arg1_93)
		if not arg0_87.pinchMode then
			return
		end

		local var0_93 = (arg0_93 - arg1_93):Magnitude()
		local var1_93 = arg0_87.pinchSize - var0_93
		local var2_93 = arg0_87.pinchNodeOrder * (arg1_93.x < arg0_93.x and -1 or 1)
		local var3_93 = var1_93 * var3_87 * var2_93

		if isActive(arg0_87.cameras[var0_0.CAMERA.POV]) then
			local var4_93 = 0.5
			local var5_93 = 1

			arg0_87.pinchValue = math.clamp(arg0_87.pinchValue + var3_93, var4_93, var5_93)
			arg0_87.pinchSize = var0_93

			arg0_87:SetPOVFOV(arg0_87.POVOriginalFOV * arg0_87.pinchValue)

			arg0_87.tweenFOV = nil

			return
		end

		if isActive(arg0_87.surroudCamera) and arg0_87.surroudCamera == arg0_87.cameras[var0_0.CAMERA.PHOTO] then
			local var6_93 = 0.5
			local var7_93 = 1

			arg0_87:SetPinchValue(math.clamp(arg0_87.pinchValue + var3_93, var6_93, var7_93))

			arg0_87.pinchSize = var0_93

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_87.pinchMode = false
		arg0_87.pinchSize = 0
	end)

	arg0_87.cameraBlendCallbacks = {}
	arg0_87.activeCMCamera = nil

	function arg0_87.camBrainEvenetHandler.OnBlendStarted(arg0_95)
		if arg0_87.activeCMCamera then
			arg0_87:OnCameraBlendFinished(arg0_87.activeCMCamera)
		end

		local var0_95 = arg0_87.camBrain.ActiveVirtualCamera

		arg0_87.activeCMCamera = var0_95
	end

	function arg0_87.camBrainEvenetHandler.OnBlendFinished(arg0_96)
		arg0_87.activeCMCamera = nil

		arg0_87:OnCameraBlendFinished(arg0_96)
	end

	arg0_87.expressionDict = {}

	arg0_87:OverlayPanel(arg0_87.blockLayer)
	arg0_87:ActiveCamera(arg0_87.cameras[var0_0.CAMERA.POV])

	local var4_87
	local var5_87
	local var6_87 = arg0_87.resumeCallback

	function arg0_87.resumeCallback()
		var5_87 = true

		if var4_87 then
			existCall(var6_87)
		end
	end

	arg0_87:RefreshSlots(nil, function()
		var4_87 = true
		arg0_87.doneFirstSlotFresh = true

		if var5_87 then
			existCall(var6_87)
		end
	end)

	arg0_87.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_87:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_87.updateHandler)
	arg0_87:InitExtraSystem()
end

function var0_0.InitExtraSystem(arg0_102, arg1_102)
	arg0_102.systemList = arg0_102.systemList or {}
	arg1_102 = arg1_102 or DormConst.SYSTEM_LIST

	for iter0_102, iter1_102 in ipairs(arg1_102) do
		switch(iter1_102, {
			[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = function()
				if not SlideExtraSystem.IsOpen(arg0_102.room) then
					return
				end

				if arg0_102.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] then
					return
				end

				arg0_102.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = SlideExtraSystem.New(arg0_102.event, arg0_102)

				arg0_102.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide]:Init()
			end,
			[DormConst.EXTRA_SYSTEMS.StockingMgr] = function()
				arg0_102.systemList[DormConst.EXTRA_SYSTEMS.StockingMgr] = Dorm3dStockingMgr.New(arg0_102.event, arg0_102)

				arg0_102.systemList[DormConst.EXTRA_SYSTEMS.StockingMgr]:Init()

				arg0_102.stockingMgr = arg0_102.systemList[DormConst.EXTRA_SYSTEMS.StockingMgr]
			end
		})
	end
end

function var0_0.RemoveExtraSystem(arg0_105, arg1_105)
	arg1_105 = arg1_105 or DormConst.SYSTEM_LIST

	for iter0_105, iter1_105 in ipairs(arg1_105) do
		switch(iter1_105, {
			[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = function()
				if not arg0_105.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] then
					return
				end

				arg0_105.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide]:Dispose()

				arg0_105.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = nil
			end
		})
	end
end

function var0_0.InitData(arg0_107)
	if not arg0_107.contextData.ladyZone then
		arg0_107.contextData.ladyZone = {}

		local var0_107
		local var1_107 = arg0_107.room:getConfig("default_zone")

		for iter0_107, iter1_107 in ipairs(var1_107) do
			arg0_107.contextData.ladyZone[iter1_107[1]] = iter1_107[2]

			if table.contains(arg0_107.contextData.groupIds, iter1_107[1]) then
				var0_107 = var0_107 or arg0_107.contextData.ladyZone[iter1_107[1]]
			end
		end

		arg0_107.contextData.inFurnitureName = var0_107 or var1_107[1][2]
	end

	arg0_107.zoneDatas = _.select(arg0_107.room:GetZones(), function(arg0_108)
		return not arg0_108:IsGlobal()
	end)
	arg0_107.activeLady = {}
end

function var0_0.Update(arg0_109)
	arg0_109.raycastCamera.fieldOfView = arg0_109.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_109.tweenFOV then
		local var0_109 = Damp(1, 1, Time.deltaTime)

		arg0_109.pinchValue = Mathf.Lerp(arg0_109.pinchValue, 1, var0_109)

		arg0_109:SetPOVFOV(arg0_109.POVOriginalFOV * arg0_109.pinchValue)

		if arg0_109.pinchValue > 0.99 then
			arg0_109.tweenFOV = nil
		end
	end

	if isActive(arg0_109.cameras[var0_0.CAMERA.POV]) then
		arg0_109:TriggerLadyDistance()
	end

	if arg0_109.contactInRangeDic then
		local var1_109 = arg0_109.transformFilter:Execute():ToTable()

		for iter0_109, iter1_109 in pairs(arg0_109.contactInRangeDic) do
			local var2_109 = pg.dorm3d_collection_template[iter0_109]
			local var3_109 = arg0_109.transRangeDic[iter0_109]
			local var4_109 = underscore(var1_109):chain():slice(unpack(var3_109)):any(function(arg0_110)
				return arg0_110
			end):value()

			if tobool(iter1_109) ~= var4_109 then
				arg0_109.contactInRangeDic[iter0_109] = var4_109

				arg0_109:UpdateContactDisplay(iter0_109, var4_109 and not arg0_109.hideConcatFlag and arg0_109.contactStateDic[iter0_109] or arg0_109.hideContactStateDic[iter0_109])
			end
		end
	end

	if arg0_109.enableFloatUpdate then
		arg0_109:UpdateFloatPosition()
	end

	arg0_109:CheckInSector()

	if arg0_109.apartment then
		(function(arg0_111)
			(function()
				if not arg0_111.ikHandler then
					return
				end

				local var0_112 = arg0_111.ikHandler.screenPosition
				local var1_112 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_112 = var0_112 - Vector2.New(var1_112.width, var1_112.height) * 0.5

				setAnchoredPosition(arg0_109:GetIKHandTF(), var2_112)

				if Time.time > arg0_109.ikNextCheckStamp then
					arg0_109.ikNextCheckStamp = arg0_109.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_112 = _.detect(arg0_111.readyIKLayers, function(arg0_113)
						return arg0_113:GetControllerPath() == arg0_111.ikHandler.ikData:GetControllerPath()
					end)

					arg0_109:emit(var0_0.ON_IK_STATUS_CHANGED, var3_112:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_109.enableIKTip then
				local var0_111 = not arg0_109.blockIK and Time.time > arg0_109.nextTipIKTime

				if var0_111 then
					local var1_111 = _.filter(arg0_111.readyIKLayers, function(arg0_114)
						return not arg0_114.ignoreDrag
					end)

					UIItemList.StaticAlign(arg0_109.ikTipsRoot, arg0_109.ikTipsRoot:GetChild(0), #var1_111, function(arg0_115, arg1_115, arg2_115)
						if arg0_115 ~= UIItemList.EventUpdate then
							return
						end

						arg1_115 = arg1_115 + 1

						local var0_115
						local var1_115 = Vector2.zero
						local var2_115 = var1_111[arg1_115]
						local var3_115 = var2_115:GetTriggerBoneName()
						local var4_115 = var3_115 and arg0_111.IKSettings.Colliders[var3_115] or nil
						local var5_115 = var2_115:GetIKTipOffset()

						if var4_115 then
							local function var6_115()
								local var0_116 = arg0_111.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var4_115.position)
								local var1_116 = CameraMgr.instance:Raycast(arg0_111.IKSettings.CameraRaycaster, var0_116)

								if var1_116.Length == 0 then
									return
								end

								return var4_115 == var1_116[0].gameObject.transform
							end
						end

						if var4_115 then
							local var7_115 = var4_115.position
							local var8_115 = var4_115:GetComponent(typeof(UnityEngine.Collider))

							if var8_115 then
								var7_115 = var8_115.bounds.center
							end

							local var9_115 = arg0_109:GetLocalPosition(arg0_109:GetScreenPosition(var7_115, arg0_111.IKSettings.CameraRaycaster.eventCamera), arg0_109.ikTipsRoot) + var5_115

							setLocalPosition(arg2_115, var9_115)

							local var10_115 = var2_115:GetTriggerRect()
							local var11_115 = var10_115:PointToNormalized(Vector2.zero)
							local var12_115 = Vector2.zero

							if var11_115.x < 0.5 and var11_115.y < 0.5 then
								var12_115 = var10_115.max
							elseif var11_115.x >= 0.5 and var11_115.y < 0.5 then
								var12_115 = Vector2.New(var10_115.xMin, var10_115.yMax)
							elseif var11_115.x < 0.5 and var11_115.y >= 0.5 then
								var12_115 = Vector2.New(var10_115.xMax, var10_115.yMin)
							elseif var11_115.x >= 0.5 and var11_115.y >= 0.5 then
								var12_115 = var10_115.min
							end

							if var11_115.x == 0.5 then
								if var9_115.x < 0 then
									var12_115.x = var10_115.xMax
								else
									var12_115.x = var10_115.xMin
								end
							end

							if var11_115.y == 0.5 then
								if var9_115.y < 0 then
									var12_115.y = var10_115.yMax
								else
									var12_115.y = var10_115.yMin
								end
							end

							local var13_115 = var12_115 - var10_115.center

							setLocalRotation(arg2_115, Quaternion.LookRotation(Vector3.forward, Vector3.New(var13_115.x, var13_115.y, 0)))
						end

						setActive(arg2_115, var4_115)
					end)
					UIItemList.StaticAlign(arg0_109.ikClickTipsRoot, arg0_109.ikClickTipsRoot:GetChild(0), #arg0_111.iKTouchDatas, function(arg0_117, arg1_117, arg2_117)
						if arg0_117 ~= UIItemList.EventUpdate then
							return
						end

						arg1_117 = arg1_117 + 1

						local var0_117
						local var1_117 = Vector2.zero
						local var2_117 = arg1_117
						local var3_117 = arg0_111.iKTouchDatas[var2_117][1]
						local var4_117 = pg.dorm3d_ik_touch[var3_117]

						if var4_117.tip_offset and var4_117.tip_offset ~= "" then
							var1_117 = Vector2.New(unpack(var4_117.tip_offset))
						end

						if #var4_117.scene_item > 0 then
							var0_117 = arg0_109:GetSceneItem(var4_117.scene_item)
						else
							var0_117 = arg0_111.IKSettings.Colliders[var4_117.body]
						end

						if var0_117 then
							local var5_117 = var0_117.position
							local var6_117 = var0_117:GetComponent(typeof(UnityEngine.Collider))

							if var6_117 then
								var5_117 = var6_117.bounds.center
							end

							setLocalPosition(arg2_117, arg0_109:GetLocalPosition(arg0_109:GetScreenPosition(var5_117, arg0_111.IKSettings.CameraRaycaster.eventCamera), arg0_109.ikClickTipsRoot) + var1_117)
						end

						setActive(arg2_117, var0_117)
					end)
				end

				setActive(arg0_109.ikTipsRoot, var0_111)
				setActive(arg0_109.ikClickTipsRoot, var0_111)
				setActive(arg0_109.ikTextTipsRoot, var0_111)
			end
		end)(arg0_109:GetCurrentLadyEnv())
	end
end

function var0_0.CheckInSector(arg0_118)
	if not isActive(arg0_118.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_118 = arg0_118.mainCameraTF.position

	for iter0_118, iter1_118 in pairs(arg0_118.ladyDict) do
		if iter1_118.lady then
			local var1_118 = tobool(arg0_118.activeLady[iter0_118])
			local var2_118 = {
				Radius = 2,
				Angle = 120,
				Position = iter1_118.lady.position,
				Rotation = iter1_118.lady.rotation
			}

			if var1_118 ~= tobool(var0_0.IsPointInSector(var2_118, var0_118)) then
				arg0_118.activeLady[iter0_118] = not var1_118

				arg0_118:emit(var0_0.ON_ENTER_SECTOR, iter0_118)
			end
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_119)
	for iter0_119, iter1_119 in pairs(arg0_119.ladyDict) do
		if iter1_119.lady then
			iter1_119.dis = (iter1_119.lady.position - arg0_119.player.position).magnitude

			if (arg0_119:GetBlackboardValue(iter1_119, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_119.dis ~= arg0_119:GetBlackboardValue(iter1_119, "inDistance") then
				arg0_119:SetBlackboardValue(iter1_119, "inDistance", iter1_119.dis < var0_0.POV_CLOSE_DISTANCE)
				arg0_119:emit(var0_0.ON_CHANGE_DISTANCE, iter0_119, iter1_119.dis < var0_0.POV_CLOSE_DISTANCE)
			end
		end
	end
end

function var0_0.OnStickMove(arg0_120, arg1_120)
	arg0_120.joystickDelta = arg1_120
end

function var0_0.SetPinchValue(arg0_121, arg1_121)
	arg0_121.pinchValue = arg1_121

	arg0_121:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_122)
	local var0_122 = arg0_122.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_122)
end

function var0_0.SetPOVFOV(arg0_123, arg1_123)
	local var0_123 = arg0_123.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_123, arg1_123)

	arg0_123.cameras[var0_0.CAMERA.POV].m_Lens = var0_123
end

function var0_0.RefreshSlots(arg0_124, arg1_124, arg2_124)
	arg1_124 = arg1_124 or arg0_124.room

	local var0_124 = arg1_124:GetSlots()
	local var1_124 = arg1_124:GetFurnitures()

	arg0_124:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_124, function(arg0_125, arg1_125, arg2_125)
		local var0_125 = arg1_125:GetConfigID()

		if not arg0_124.slotDict[var0_125] then
			return arg2_125()
		end

		local var1_125 = _.detect(var1_124, function(arg0_126)
			return arg0_126:GetSlotID() == var0_125
		end)
		local var2_125 = var1_125 and var1_125:GetModel() or false
		local var3_125 = arg0_124.slotDict[var0_125].model

		arg0_124.slotDict[var0_125].displayModelName = var2_125
		arg0_124.slotDict[var0_125].furnitureId = var1_125 and var1_125:GetConfigID()

		local function var4_125(arg0_127)
			if var3_125 then
				setActive(var3_125, var2_125 == "")
			end

			table.Foreach(arg0_124.slotDict[var0_125].sceneHides or {}, function(arg0_128, arg1_128)
				setActive(arg1_128.trans, arg1_128.visible)
			end)

			arg0_124.slotDict[var0_125].sceneHides = {}

			if arg0_127 then
				local var0_127 = arg0_127:getConfig("scene_hides")

				if #var0_127 > 0 then
					table.Ipairs(var0_127, function(arg0_129, arg1_129)
						local var0_129 = arg0_124.modelRoot:Find(arg1_129)

						assert(var0_129, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_127:GetConfigID(), arg1_129))

						local var1_129 = isActive(var0_129)

						table.insert(arg0_124.slotDict[var0_125].sceneHides, {
							name = arg1_129,
							trans = var0_129,
							visible = var1_129
						})
						setActive(var0_129, false)
					end)
				end
			end
		end

		if var2_125 == false or var2_125 == "" then
			arg0_124.loader:ClearRequest("slot_" .. var0_125)
			var4_125()
			arg2_125()

			return
		end

		local var5_125 = arg0_124.slotDict[var0_125].trans

		if arg0_124.loader:GetLoadingRP("slot_" .. var0_125) then
			arg0_124:emit(var0_0.HIDE_BLOCK)
		end

		arg0_124.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_125, "", function(arg0_130)
			assert(arg0_130)
			setParent(arg0_130, var5_125)
			var4_125(var1_125)
			arg2_125()
		end, "slot_" .. var0_125)
	end, function()
		arg0_124:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_124)
		warning("RefreshSlots", "Done")
		arg0_124:emit(Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE)
	end)
end

function var0_0.RefreshSlotsEmpty(arg0_132, arg1_132)
	local var0_132 = Clone(arg0_132.room)

	var0_132.furnitures = {}

	arg0_132:RefreshSlots(var0_132, arg1_132)
end

function var0_0.CheckSceneItemActiveByPath(arg0_133, arg1_133)
	local var0_133 = arg0_133:GetSceneItem(arg1_133)

	return arg0_133:CheckSceneItemActive(var0_133)
end

function var0_0.CheckSceneItemActive(arg0_134, arg1_134)
	local var0_134 = true
	local var1_134

	table.Checkout(arg0_134.slotDict, function(arg0_135, arg1_135)
		if underscore.detect(arg1_135.sceneHides, function(arg0_136)
			return arg0_136.trans == arg1_134
		end) then
			var0_134 = false
			var1_134 = arg1_135.furnitureId

			return false
		end
	end)

	return var0_134, var1_134
end

function var0_0.ChangeCharacterPosition(arg0_137, arg1_137)
	arg0_137:ResetCharPoint(arg1_137, arg1_137.ladyActiveZone)
	arg0_137:SyncInterestTransform(arg1_137)
end

function var0_0.SyncCurrentInterestTransform(arg0_138)
	local var0_138 = arg0_138:GetCurrentLadyEnv()

	arg0_138:SyncInterestTransform(var0_138)
end

function var0_0.SyncInterestTransform(arg0_139, arg1_139)
	arg0_139.ladyInterest.position = arg1_139.ladyInterestRoot.position
	arg0_139.ladyInterest.rotation = arg1_139.ladyInterestRoot.rotation
end

function var0_0.SyncInterestTransformByTf(arg0_140, arg1_140)
	arg0_140.ladyInterest.position = arg1_140.position
	arg0_140.ladyInterest.rotation = arg1_140.rotation
end

function var0_0.ChangePlayerPosition(arg0_141, arg1_141)
	arg1_141 = arg1_141 or arg0_141.contextData.inFurnitureName

	local var0_141 = arg0_141.furnitures:Find(arg1_141):Find("PlayerPoint").position

	arg0_141.player.position = var0_141
	arg0_141.cameras[var0_0.CAMERA.POV].transform.position = arg0_141.playerEye.position

	local var1_141 = arg0_141.ladyInterest.position - arg0_141.playerEye.position
	local var2_141 = Quaternion.LookRotation(var1_141).eulerAngles
	local var3_141 = var2_141.y
	local var4_141 = var2_141.x
	local var5_141 = arg0_141.compPovAim.m_HorizontalAxis

	var5_141.Value = arg0_141:GetNearestAngle(var3_141, var5_141.m_MinValue, var5_141.m_MaxValue)
	arg0_141.compPovAim.m_HorizontalAxis = var5_141

	local var6_141 = arg0_141.compPovAim.m_VerticalAxis

	var6_141.Value = var4_141
	arg0_141.compPovAim.m_VerticalAxis = var6_141
end

function var0_0.GetAttachedFurnitureName(arg0_142)
	return arg0_142.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_143, arg1_143)
	return underscore.detect(arg0_143.attachedPoints, function(arg0_144)
		return arg0_144.name == arg1_143
	end)
end

function var0_0.GetSlotByID(arg0_145, arg1_145)
	return arg0_145.displaySlots[arg1_145] and arg0_145.displaySlots[arg1_145].trans
end

function var0_0.GetScreenPosition(arg0_146, arg1_146, arg2_146)
	arg2_146 = arg2_146 or arg0_146.raycastCamera

	local var0_146 = arg2_146:WorldToScreenPoint(arg1_146)

	if var0_146.z < 0 then
		var0_146.x = var0_146.x + (var0_146.x < 0 and -1 or 1) * Screen.width
		var0_146.y = var0_146.y + (var0_146.y < 0 and -1 or 1) * Screen.height
		var0_146.z = -var0_146.z
	end

	return var0_146
end

function var0_0.GetLocalPosition(arg0_147, arg1_147, arg2_147)
	return LuaHelper.ScreenToLocal(arg2_147, arg1_147, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_148)
	return arg0_148.modelRoot
end

function var0_0.ShiftZone(arg0_149, arg1_149, arg2_149)
	local var0_149 = arg0_149:GetFurnitureByName(arg1_149)

	if not var0_149 then
		errorMsg(arg1_149 .. " Not Find")
		existCall(arg2_149)

		return
	end

	seriesAsync({
		function(arg0_150)
			arg0_149:emit(var0_0.SHOW_BLOCK)
			arg0_149:ShowBlackScreen(true, arg0_150)
		end,
		function(arg0_151)
			if arg0_149.shiftLady or arg0_149.room:isPersonalRoom() then
				local var0_151 = arg0_149.shiftLady or arg0_149.apartment:GetConfigID()

				arg0_149.shiftLady = nil
				arg0_149.contextData.ladyZone[var0_151] = var0_149.name

				local var1_151 = arg0_149.ladyDict[var0_151]

				var1_151:SetZone(arg0_149.contextData.ladyZone[var0_151])

				if arg0_149:GetBlackboardValue(var1_151, "inPending") then
					arg0_149:SetOutPending(var1_151)
					arg0_149:SwitchAnim(var1_151, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_149:ChangeCharacterPosition(var1_151)
						arg0_151()
					end)
				else
					arg0_149:ChangeCharacterPosition(var1_151)
					arg0_151()
				end
			else
				arg0_151()
			end
		end,
		function(arg0_153)
			arg0_149.contextData.inFurnitureName = var0_149.name

			if SlideExtraSystem.IsOpen(arg0_149.room) and arg0_149.contextData.inFurnitureName == SlideConst.SLIDE_ZONE then
				arg0_149:SyncInterestTransformByTf(var0_149.transform:Find("StayPoint"))
			elseif not arg0_149.apartment then
				for iter0_153, iter1_153 in pairs(arg0_149.ladyDict) do
					if iter1_153.ladyBaseZone == arg0_149.contextData.inFurnitureName then
						arg0_149:SyncInterestTransform(iter1_153)

						break
					end
				end
			end

			arg0_149:ChangePlayerPosition()
			arg0_149:TriggerLadyDistance()
			arg0_149:CheckInSector()
			arg0_153()
		end,
		function(arg0_154)
			arg0_149:UpdateZoneList()
			arg0_149:ShowBlackScreen(false, arg0_154)
		end,
		function(arg0_155)
			arg0_149:emit(var0_0.HIDE_BLOCK)
			arg0_155()
		end
	}, arg2_149)
end

function var0_0.ActiveCamera(arg0_156, arg1_156)
	local var0_156 = isActive(arg1_156)

	table.Foreach(arg0_156.cameras, function(arg0_157, arg1_157)
		setActive(arg1_157, arg1_157 == arg1_156)
	end)

	if var0_156 then
		arg0_156:OnCameraBlendFinished(arg1_156)
	end
end

function var0_0.ActiveCameraByName(arg0_158, arg1_158)
	local var0_158 = arg0_158.cameraRoot:Find(arg1_158)

	assert(var0_158, "ActiveCameraByName: " .. arg1_158 .. " not found")
	table.Foreach(arg0_158.cameras, function(arg0_159, arg1_159)
		setActive(arg1_159, false)
	end)
	setActive(var0_158, true)

	arg0_158.cameras[var0_0.CAMERA.CUSTOM] = var0_158
end

function var0_0.ShowBlackScreen(arg0_160, arg1_160, arg2_160)
	local var0_160 = arg0_160.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_160 and 0 or 0.3
	}

	setImageColor(arg0_160.blackLayer, Color.NewHex(var0_160.color))
	setActive(arg0_160.blackLayer, true)
	setCanvasGroupAlpha(arg0_160.blackLayer, arg1_160 and 0 or 1)
	arg0_160:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_160 then
			setActive(arg0_160.blackLayer, false)
		end

		existCall(arg2_160)
	end, GetComponent(arg0_160.blackLayer, typeof(CanvasGroup)), arg1_160 and 1 or 0, var0_160.time):setDelay(var0_160.delay)
end

function var0_0.RegisterOrbits(arg0_162, arg1_162)
	arg0_162 = arg0_162.scene
	arg0_162.orbits = {
		original = arg1_162.m_Orbits
	}
	arg0_162.orbits.current = _.range(3):map(function(arg0_163)
		local var0_163 = arg0_162.orbits.original[arg0_163 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_163.m_Height, var0_163.m_Radius)
	end)
	arg0_162.surroudCamera = arg1_162
end

function var0_0.SetCameraObrits(arg0_164)
	arg0_164 = arg0_164.scene

	local var0_164 = arg0_164.surroudCamera

	if not var0_164 then
		return
	end

	local var1_164 = arg0_164.orbits.original[1]

	for iter0_164 = 0, #arg0_164.orbits.current - 1 do
		local var2_164 = arg0_164.orbits.current[iter0_164 + 1]
		local var3_164 = arg0_164.orbits.original[iter0_164]

		var2_164.m_Height = math.lerp(var1_164.m_Height, var3_164.m_Height, arg0_164.pinchValue)
		var2_164.m_Radius = var3_164.m_Radius * arg0_164.pinchValue
	end

	var0_164.m_Orbits = arg0_164.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_165)
	arg0_165 = arg0_165.scene

	local var0_165 = arg0_165.surroudCamera

	if not var0_165 then
		return
	end

	for iter0_165 = 0, #arg0_165.orbits.current - 1 do
		local var1_165 = arg0_165.orbits.current[iter0_165 + 1]
		local var2_165 = arg0_165.orbits.original[iter0_165]

		var1_165.m_Height = var2_165.m_Height
		var1_165.m_Radius = var2_165.m_Radius
	end

	var0_165.m_Orbits = arg0_165.orbits.current
	arg0_165.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_166, arg1_166, arg2_166)
	local var0_166 = {
		base = function(arg0_167)
			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.POV], arg0_167)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_168)
			assert(arg0_166.apartment)
			arg0_166:SyncInterestTransform(arg0_166:GetCurrentLadyEnv())
			arg0_166:SetCameraLady(arg0_166:GetCurrentLadyEnv())
			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.ROLE], arg0_168)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_169)
			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.POV], arg0_169)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_170)
			arg0_170()
		end,
		gift = function(arg0_171)
			assert(arg0_166.apartment)
			arg0_166:SetCameraLady(arg0_166:GetCurrentLadyEnv())
			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.GIFT], arg0_171)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_172)
			assert(arg0_166.apartment)
			arg0_166:SetCameraLady(arg0_166:GetCurrentLadyEnv())

			arg0_166.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_166.cameraRole.transform.position

			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.ROLE2], arg0_172)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_173)
			assert(arg0_166.apartment)
			arg0_166:SetCameraLady(arg0_166:GetCurrentLadyEnv())
			arg0_166:SyncInterestTransform(arg0_166:GetCurrentLadyEnv())
			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.TALK], arg0_173)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_166 = {}

	table.insert(var1_166, function(arg0_174)
		switch(arg1_166, var0_166, arg0_174, arg0_174)
	end)
	seriesAsync(var1_166, arg2_166)
end

function var0_0.GetSceneItem(arg0_175, arg1_175)
	local var0_175

	if string.find(arg1_175, "FurnitureSlots/") == 1 then
		arg1_175 = string.gsub(arg1_175, "^FurnitureSlots/", "", 1)
		var0_175 = arg0_175.slotRoot:Find(arg1_175)
	else
		var0_175 = arg0_175.modelRoot:Find(arg1_175)
	end

	if not var0_175 then
		warning(string.format("Missing scene item path: %s", arg1_175))
	end

	return var0_175
end

function var0_0.SetSceneAnimSpeed(arg0_176, arg1_176, arg2_176)
	table.Ipairs(arg1_176 or {}, function(arg0_177, arg1_177)
		if arg0_176.sceneAnimatorDict[arg1_177] then
			arg0_176.sceneAnimatorDict[arg1_177].animator.speed = arg2_176
		end
	end)
end

function var0_0.SetExtraAnimSpeed(arg0_178, arg1_178, arg2_178, arg3_178)
	table.Ipairs(arg2_178 or {}, function(arg0_179, arg1_179)
		local var0_179 = arg1_179[1]

		if arg1_178.extraItems[var0_179] then
			arg1_178.extraItems[var0_179].trans:GetComponent(typeof(Animator)).speed = arg3_178
		end
	end)
end

function var0_0.PlayEnterSceneAnim(arg0_180, arg1_180, arg2_180, arg3_180)
	arg3_180 = arg3_180 or 1

	local var0_180 = {}

	if arg1_180 and #arg1_180 > 0 then
		table.Ipairs(arg1_180, function(arg0_181, arg1_181)
			arg0_180:PlaySceneItemAnim(arg1_181[1], arg1_181[2], arg2_180)
			arg0_180:SetSceneAnimSpeed({
				arg1_181[1]
			}, arg3_180)
			table.insert(var0_180, arg1_181[1])
		end)
	end

	arg0_180:ResetSceneItemAnimators(var0_180)
end

function var0_0.PlayEnterExtraItem(arg0_182, arg1_182, arg2_182, arg3_182)
	arg3_182 = arg3_182 or 1

	local var0_182 = {}

	if arg2_182 and #arg2_182 > 0 then
		table.Ipairs(arg2_182, function(arg0_183, arg1_183)
			local var0_183 = arg1_183[3] and Vector3.New(unpack(arg1_183[3]))
			local var1_183 = arg1_183[4] and Quaternion.Euler(unpack(arg1_183[4]))
			local var2_183 = #arg1_183 > 4 and arg1_183[5] or nil

			arg0_182:LoadCharacterExtraItem(arg1_182, arg1_183[1], arg1_183[2], var0_183, var1_183, var2_183, arg3_182)
			table.insert(var0_182, arg1_183[1])
		end)
	end

	arg0_182:ResetCharacterExtraItem(arg1_182, var0_182)
end

function var0_0.HideSceneItem(arg0_184, arg1_184, arg2_184)
	if arg2_184 and #arg2_184 > 0 then
		if arg1_184.tempHideSceneItems and #arg1_184.tempHideSceneItems > 0 then
			arg0_184:ResetTempHideSceneItems(arg1_184, arg2_184)
		end

		arg1_184.tempHideSceneItems = {}

		table.Ipairs(arg2_184, function(arg0_185, arg1_185)
			local var0_185 = arg0_184:GetSceneItem(arg1_185)

			setActive(var0_185, false)
			table.insert(arg1_184.tempHideSceneItems, arg1_185)
		end)
	end
end

function var0_0.ResetTempHideSceneItems(arg0_186, arg1_186, arg2_186)
	arg2_186 = arg2_186 or {}

	if arg1_186.tempHideSceneItems and #arg1_186.tempHideSceneItems > 0 then
		table.Ipairs(arg1_186.tempHideSceneItems, function(arg0_187, arg1_187)
			if table.contains(arg2_186, arg1_187) then
				return
			end

			local var0_187 = arg0_186:GetSceneItem(arg1_187)

			setActive(var0_187, true)
		end)

		arg1_186.tempHideSceneItems = nil
	end
end

function var0_0.SetIKStatus(arg0_188, arg1_188, arg2_188, arg3_188, arg4_188)
	warning("Set IKStatus " .. (arg2_188.id or "NIL"))

	arg0_188.enableIKTip = true

	arg0_188:ResetIKTipTimer()
	setActive(arg1_188.ladyCollider, false)
	_.each(arg1_188.ladyTouchColliders, function(arg0_189)
		setActive(arg0_189, true)
	end)

	arg0_188.blockIK = nil

	arg0_188:ClearIkTouchEvents(arg1_188)

	arg1_188.currentIkStatus = arg2_188.id
	arg1_188.ikActionDict = {}
	arg1_188.readyIKLayers = {}
	arg1_188.iKTouchDatas = arg2_188.touch_data or {}
	arg1_188.IKSettings = {
		Colliders = arg1_188.ladyColliders,
		CameraRaycaster = arg0_188.sceneRaycaster
	}

	local var0_188 = table.shallowCopy(arg2_188.ik_id)
	local var1_188 = {}

	_.each(arg1_188.iKTouchDatas, function(arg0_190)
		local var0_190 = arg0_190[3]

		if var0_190[1] == 7 then
			local var1_190 = pg.dorm3d_ik_touch_move[var0_190[2]]
			local var2_190 = var1_190.target_ik

			if not _.detect(var0_188, function(arg0_191)
				return arg0_191[1] == var2_190
			end) then
				var1_188[var2_190] = {
					back_time = var1_190.back_time
				}

				local var3_190 = {
					var2_190,
					0,
					{}
				}

				if var1_190.trigger_dialogue > 0 then
					var3_190[3] = {
						4,
						0,
						var1_190.trigger_dialogue
					}
				end

				table.insert(var0_188, var3_190)
			end
		end
	end)

	local var2_188 = _.map(var0_188, function(arg0_192)
		local var0_192 = Dorm3dIK.New({
			configId = arg0_192[1]
		})
		local var1_192 = arg0_192[3]
		local var2_192 = var1_192[1]
		local var3_192 = switch(var2_192, {
			function(arg0_193, arg1_193)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_195, arg1_195)
				return arg0_195
			end,
			function(arg0_196, arg1_196)
				return arg0_196
			end,
			function(arg0_197, arg1_197, arg2_197, arg3_197)
				return arg0_197
			end,
			function(arg0_198)
				return 0
			end
		}, function(arg0_199)
			return type(arg0_199) == "number" and arg0_199 or 0
		end, unpack(var1_192, 2))

		table.insert(arg1_188.readyIKLayers, var0_192)

		arg1_188.ikActionDict[var0_192:GetControllerPath()] = var1_192

		local var4_192 = var0_192:GetRevertTime()
		local var5_192 = var1_188[var0_192:GetConfigID()]
		local var6_192 = tobool(var5_192)

		if var6_192 then
			var3_192 = var5_192.back_time
			var4_192 = var5_192.back_time
			var0_192.ignoreDrag = true
		end

		local var7_192 = var0_192:GetSubTargets()
		local var8_192 = var0_192:GetPlaneRotations()
		local var9_192 = var0_192:GetPlaneScales()
		local var10_192 = _.map(_.range(#var7_192), function(arg0_200)
			return {
				name = var7_192[arg0_200][1],
				planeRot = var8_192[arg0_200],
				planeScale = var9_192[arg0_200]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_192:getConfig("trigger_param")[2],
			controllerName = var0_192:GetControllerPath(),
			subTargets = var10_192,
			actionType = var0_192:GetActionTriggerParams()[1],
			controlRect = var0_192:GetRect(),
			actionRect = var0_192:GetTriggerRect(),
			backTime = var4_192,
			actionRevertTime = var3_192,
			ignoreDrag = var6_192
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_188.ladyIKRoot, arg1_188.ladyBoneMaps)
	arg0_188:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_188)

	local var3_188 = _.map(arg1_188.iKTouchDatas, function(arg0_201)
		return arg0_201[1]
	end)

	table.Foreach(var3_188, function(arg0_202, arg1_202)
		local var0_202 = pg.dorm3d_ik_touch[arg1_202]

		if #var0_202.scene_item == 0 then
			return
		end

		local var1_202 = arg0_188:GetSceneItem(var0_202.scene_item)

		if not var1_202 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_202, var0_202.scene_item))

			return
		end

		if IsNil(GetComponent(var1_202, typeof(UnityEngine.Collider))) then
			go(var1_202):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_202 = GetOrAddComponent(var1_202, typeof(EventTriggerListener))

		var2_202.enabled = true

		var2_202:AddPointClickFunc(function()
			arg0_188.blockIK = true

			local var0_203 = arg1_188.iKTouchDatas[arg0_202]
			local var1_203, var2_203, var3_203 = unpack(var0_203)

			arg0_188:TouchModeAction(arg1_188, var1_203, unpack(var3_203))(function()
				arg0_188.enableIKTip = true

				arg0_188:ResetIKTipTimer()

				arg0_188.blockIK = nil
			end)
		end)
	end)

	arg0_188.camBrain.enabled = false

	if arg0_188.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_188.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_188.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var4_188 = arg0_188.cameraRoot:Find(arg2_188.ik_camera)

	assert(var4_188, "Missing IKCamera")

	arg0_188.cameras[var0_0.CAMERA.IK_WATCH] = var4_188

	arg0_188:ActiveCamera(arg0_188.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_188.camBrain.enabled = true

	local var5_188 = var4_188:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_188 then
		arg0_188:RegisterOrbits(var5_188)
	else
		arg0_188:RevertCameraOrbit()
	end

	arg0_188:SwitchAnim(arg1_188, arg2_188.character_action)
	arg0_188:SettingHeadAimIK(arg1_188, arg2_188.head_track)
	arg1_188:EnableCloth(false)
	arg1_188:EnableCloth(arg2_188.use_cloth, arg2_188.cloth_colliders)
	arg0_188:PlayEnterSceneAnim(arg2_188.enter_scene_anim)
	arg0_188:PlayEnterExtraItem(arg1_188, arg2_188.enter_extra_item)
	arg0_188:HideSceneItem(arg1_188, arg2_188.hide_scene_item)
	eachChild(arg0_188.ikTextTipsRoot, function(arg0_205)
		setActive(arg0_205, false)
	end)
	_.each(arg1_188.readyIKLayers, function(arg0_206)
		local var0_206 = arg0_206:getConfig("tip_text")

		if not var0_206 or #var0_206 == 0 then
			return
		end

		local var1_206 = arg0_188.ikTextTipsRoot:Find(var0_206)

		if not IsNil(var1_206) then
			setActive(var1_206, true)
		end
	end)
	onNextTick(function()
		local var0_207 = arg0_188.furnitures:Find(arg2_188.character_position)

		arg1_188.lady.position = var0_207:Find("StayPoint").position
		arg1_188.lady.rotation = var0_207:Find("StayPoint").rotation

		existCall(arg3_188)
	end)
end

function var0_0.ExitIKStatus(arg0_208, arg1_208, arg2_208, arg3_208, arg4_208)
	arg0_208.enableIKTip = false

	setActive(arg1_208.ladyCollider, true)
	_.each(arg1_208.ladyTouchColliders, function(arg0_209)
		setActive(arg0_209, false)
	end)

	arg0_208.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()
	setActive(arg0_208.ikTipsRoot, false)
	setActive(arg0_208.ikClickTipsRoot, false)
	arg0_208:ClearIkTouchEvents(arg1_208)

	arg1_208.currentIkStatus = nil
	arg1_208.ikActionDict = nil
	arg1_208.readyIKLayers = nil
	arg1_208.iKTouchDatas = nil

	arg0_208:RevertCameraOrbit()
	setActive(arg0_208.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_208.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg1_208:EnableCloth(false)
	arg0_208:ResetHeadAimIK(arg1_208)
	arg0_208:SwitchAnim(arg1_208, arg2_208.character_action)
	arg0_208:ResetSceneItemAnimators()

	if not arg4_208.ignoreResetExtraItem then
		arg0_208:ResetCharacterExtraItem(arg1_208)
		arg0_208:ResetTempHideSceneItems(arg1_208)
	end

	onNextTick(function()
		if arg2_208.character_position then
			arg1_208.ladyActiveZone = arg2_208.character_position
		else
			arg1_208.ladyActiveZone = arg1_208.ladyBaseZone
		end

		arg0_208:ChangeCharacterPosition(arg1_208)
		arg0_208:TriggerLadyDistance()
		arg0_208:CheckInSector()
		existCall(arg3_208)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_211, arg1_211, arg2_211, arg3_211, arg4_211, arg5_211)
	warning("Set IKStatus " .. (arg3_211 or "NIL"))
	arg1_211:SetCurrentIkTimelineStatus(arg3_211)

	arg0_211.enableIKTip = true

	setActive(arg0_211.ikControlUI, true)
	arg0_211:ResetIKTipTimer()

	arg0_211.blockIK = nil

	local var0_211 = pg.dorm3d_ik_timeline_status[arg3_211]

	arg1_211.readyIKLayers = {}
	arg1_211.iKTouchDatas = {}
	arg1_211.IKSettings = {
		CameraRaycaster = GetOrAddComponent(arg4_211, typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_211.IKSettings.CameraRaycaster)

	local var1_211 = {}

	table.IpairsCArray(arg2_211:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_212, arg1_212)
		if arg1_212.name == "SafeCollider" then
			setActive(arg1_212, false)

			return
		end

		if arg1_212:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_212 = tf(arg1_212)
		local var1_212 = var0_212.name
		local var2_212 = var1_212 and string.find(var1_212, "Collider") or -1

		if var2_212 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var1_212)

			return
		end

		local var3_212 = string.sub(var1_212, 1, var2_212 - 1)

		if var3_212 == "Body" or var3_212 == "Safe" then
			setActive(var0_212, false)

			return
		end

		if DormConst.BONE_TO_TOUCH[var3_212] == nil then
			return
		end

		var1_211[var3_212] = var0_212

		setActive(var0_212, true)
	end)

	arg1_211.IKSettings.Colliders = var1_211

	local var2_211 = GetOrAddComponent(arg2_211, typeof(EventTriggerListener))

	arg1_211.ikTimelineMode = true

	local var3_211 = _.map(var0_211.ik_id, function(arg0_213)
		local var0_213 = Dorm3dIK.New({
			configId = arg0_213
		})

		table.insert(arg1_211.readyIKLayers, var0_213)

		local var1_213 = var0_213:GetSubTargets()
		local var2_213 = var0_213:GetPlaneRotations()
		local var3_213 = var0_213:GetPlaneScales()
		local var4_213 = _.map(_.range(#var1_213), function(arg0_214)
			return {
				name = var1_213[arg0_214][1],
				planeRot = var2_213[arg0_214],
				planeScale = var3_213[arg0_214]
			}
		end)

		return Dorm3dIKController.New({
			ignoreDrag = false,
			triggerName = var0_213:getConfig("trigger_param")[2],
			controllerName = var0_213:GetControllerPath(),
			subTargets = var4_213,
			actionType = var0_213:GetActionTriggerParams()[1],
			controlRect = var0_213:GetRect(),
			actionRect = var0_213:GetTriggerRect(),
			backTime = var0_213:GetRevertTime(),
			actionRevertTime = var0_213:GetActionRevertTime(),
			timelineActionEvent = var0_213:GetTimelineAction()
		})
	end)
	local var4_211 = arg2_211.transform:Find("IKLayers")
	local var5_211 = {}
	local var6_211 = {}

	table.Foreach(DormConst.boneMap, function(arg0_215, arg1_215)
		var6_211[arg1_215] = arg0_215
	end)

	local var7_211 = arg2_211.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var7_211, function(arg0_216, arg1_216)
		if var6_211[arg1_216.name] then
			var5_211[var6_211[arg1_216.name]] = arg1_216
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var4_211, var5_211)
	arg0_211:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var3_211)
	eachChild(arg0_211.ikTextTipsRoot, function(arg0_217)
		setActive(arg0_217, false)
	end)
	_.each(arg1_211.readyIKLayers, function(arg0_218)
		local var0_218 = arg0_218:getConfig("tip_text")

		if not var0_218 or #var0_218 == 0 then
			return
		end

		local var1_218 = arg0_211.ikTextTipsRoot:Find(var0_218)

		if not IsNil(var1_218) then
			setActive(var1_218, true)
		end
	end)
	existCall(arg5_211)
end

function var0_0.ExitIKTimelineStatus(arg0_219, arg1_219, arg2_219)
	arg1_219:SetCurrentIkTimelineStatus(nil)

	arg0_219.enableIKTip = false

	setActive(arg0_219.ikControlUI, false)

	arg0_219.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_219.readyIKLayers = nil
	arg1_219.iKTouchDatas = nil
	arg1_219.IKSettings = nil

	setActive(arg0_219.ikTipsRoot, false)
	setActive(arg0_219.ikClickTipsRoot, false)
	existCall(arg2_219)
end

function var0_0.ClearIkTouchEvents(arg0_220, arg1_220)
	local var0_220 = _.map(arg1_220.iKTouchDatas or {}, function(arg0_221)
		return arg0_221[1]
	end)

	table.Foreach(var0_220, function(arg0_222, arg1_222)
		local var0_222 = pg.dorm3d_ik_touch[arg1_222]

		if #var0_222.scene_item == 0 then
			return
		end

		local var1_222 = arg0_220:GetSceneItem(var0_222.scene_item)

		if not var1_222 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_222, var0_222.scene_item))

			return
		end

		local var2_222 = GetOrAddComponent(var1_222, typeof(EventTriggerListener))

		var2_222:ClearEvents()

		var2_222.enabled = false
	end)
end

function var0_0.EnableIKLayer(arg0_223, arg1_223)
	local var0_223 = arg0_223:GetCurrentLadyEnv()

	if #arg1_223:GetHeadTrackPath() > 0 then
		arg0_223:SettingHeadAimIK(var0_223, {
			2,
			arg1_223:GetHeadTrackPath()
		}, true)
	end

	local var1_223 = arg1_223:GetTriggerFaceAnim()

	if #var1_223 > 0 then
		arg0_223:PlayFaceAnim(var0_223, var1_223)
	end

	if not arg1_223.ignoreDrag then
		setActive(arg0_223:GetIKHandTF(), true)
		eachChild(arg0_223:GetIKHandTF(), function(arg0_224)
			setActive(arg0_224, false)
		end)
		arg0_223:StopIKHandTimer()
		setActive(arg0_223:GetIKHandTF():Find("Begin"), true)

		arg0_223.ikHandTimer = Timer.New(function()
			setActive(arg0_223:GetIKHandTF():Find("Begin"), false)
			setActive(arg0_223:GetIKHandTF():Find("Normal"), true)
		end, 0.5, 1)

		arg0_223.ikHandTimer:Start()
	end

	if not var0_223.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_223.apartment.configId, arg0_223.apartment.level, var0_223.ikConfig.character_action, arg1_223:GetTriggerParams()[2], arg0_223.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_226, arg1_226)
	local var0_226 = arg0_226:GetCurrentLadyEnv()

	if not var0_226.ikTimelineMode and #arg1_226:GetHeadTrackPath() > 0 then
		arg0_226:SettingHeadAimIK(var0_226, var0_226.ikConfig.head_track)
	end

	arg0_226:StopIKHandTimer()

	if not arg1_226.ignoreDrag then
		setActive(arg0_226:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_226:GetIKHandTF():Find("Normal"), false)
		setActive(arg0_226:GetIKHandTF():Find("End"), true)

		arg0_226.ikHandTimer = Timer.New(function()
			setActive(arg0_226:GetIKHandTF():Find("End"), false)
			setActive(arg0_226:GetIKHandTF(), false)
		end, 0.5, 1)

		arg0_226.ikHandTimer:Start()
	end
end

function var0_0.StopIKHandTimer(arg0_228)
	if not arg0_228.ikHandTimer then
		return
	end

	arg0_228.ikHandTimer:Stop()

	arg0_228.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_229, arg1_229, arg2_229, arg3_229)
	local var0_229 = Time.time

	function arg0_229.ikRevertHandler()
		local var0_230 = Time.time - var0_229

		_.each(arg1_229.activeIKLayers, function(arg0_231)
			local var0_231 = 1

			if arg2_229 > 0 then
				var0_231 = var0_230 / arg2_229
			end

			local var1_231 = arg1_229.cacheIKInfos[arg0_231].solvers
			local var2_231 = arg1_229.cacheIKInfos[arg0_231].weights

			table.Foreach(var1_231, function(arg0_232, arg1_232)
				arg1_232.IKPositionWeight = math.lerp(var2_231[arg0_232], 0, var0_231)
			end)
		end)

		if var0_230 >= arg2_229 then
			arg0_229:ResetActiveIKs(arg1_229)

			arg0_229.ikRevertHandler = nil

			existCall(arg3_229)
		end
	end

	arg0_229.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_233, arg1_233)
	table.insertto(arg0_233.activeIKLayers, _.keys(arg0_233.holdingStatus))
	table.clear(arg0_233.holdingStatus)
	_.each(arg1_233.activeIKLayers, function(arg0_234)
		local var0_234 = arg0_234:GetControllerPath()
		local var1_234 = arg1_233.ladyIKRoot:Find(var0_234):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_234, false)

		local var2_234 = arg1_233.cacheIKInfos[arg0_234].solvers
		local var3_234 = arg1_233.cacheIKInfos[arg0_234].weights

		table.Foreach(var2_234, function(arg0_235, arg1_235)
			arg1_235.IKPositionWeight = var3_234[arg0_235]
		end)
	end)
	table.clear(arg1_233.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_236)
	if not arg0_236.enableIKTip then
		return
	end

	arg0_236.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_237, arg1_237)
	local var0_237 = arg0_237:GetCurrentLadyEnv()

	arg0_237:EnableHeadIK(var0_237, arg1_237)
end

function var0_0.EnableHeadIK(arg0_238, arg1_238, arg2_238)
	arg1_238.ladyHeadIKComp.enableIk = arg2_238
end

function var0_0.SettingHeadAimIK(arg0_239, arg1_239, arg2_239, arg3_239)
	local var0_239

	if arg2_239[1] == 0 then
		arg0_239:EnableHeadIK(arg1_239, false)

		return
	elseif arg2_239[1] == 1 then
		arg0_239:EnableHeadIK(arg1_239, true)

		var0_239 = arg0_239.mainCameraTF:Find("AimTarget")
	elseif arg2_239[1] == 2 then
		arg0_239:EnableHeadIK(arg1_239, true)
		table.IpairsCArray(arg1_239.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_240, arg1_240)
			if arg1_240.name ~= arg2_239[2] then
				return
			end

			var0_239 = arg1_240
		end)
	end

	arg1_239.ladyHeadIKComp.AimTarget = var0_239

	if not arg3_239 and arg2_239[3] then
		arg1_239.ladyHeadIKComp.BodyWeight = arg2_239[3]
	end

	if not arg3_239 and arg2_239[4] then
		arg1_239.ladyHeadIKComp.HeadWeight = arg2_239[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_241, arg1_241)
	arg0_241:EnableHeadIK(arg1_241, true)

	arg1_241.ladyHeadIKComp.AimTarget = arg0_241.mainCameraTF:Find("AimTarget")
	arg1_241.ladyHeadIKComp.HeadWeight = arg1_241.ladyHeadIKData.HeadWeight
	arg1_241.ladyHeadIKComp.BodyWeight = arg1_241.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_242, arg1_242)
	for iter0_242, iter1_242 in pairs(arg0_242.ladyDict) do
		if iter0_242 ~= arg1_242 then
			arg0_242:HideCharacterBylayer(iter1_242)
		end
	end
end

function var0_0.RevertCharacter(arg0_243, arg1_243)
	for iter0_243, iter1_243 in pairs(arg0_243.ladyDict) do
		if iter0_243 ~= arg1_243 then
			arg0_243:RevertCharacterBylayer(iter1_243)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_244, arg1_244)
	local var0_244 = "Bip001"
	local var1_244 = arg1_244.lady:Find("all")

	for iter0_244 = 0, var1_244.childCount - 1 do
		local var2_244 = var1_244:GetChild(iter0_244)

		if var2_244.name ~= var0_244 then
			pg.ViewUtils.SetLayer(var2_244, Layer.Environment3D)
		end
	end

	if arg1_244.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_244.tfPendintItem, Layer.Environment3D)
	end

	if arg1_244.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_244.ladyWatchFloat, Layer.Environment3D)
	end
end

function var0_0.RevertCharacterBylayer(arg0_245, arg1_245)
	local var0_245 = "Bip001"
	local var1_245 = arg1_245.lady:Find("all")

	for iter0_245 = 0, var1_245.childCount - 1 do
		local var2_245 = var1_245:GetChild(iter0_245)

		if var2_245.name ~= var0_245 then
			pg.ViewUtils.SetLayer(var2_245, Layer.Character3D)
		end
	end

	if arg1_245.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_245.tfPendintItem, Layer.Default)
	end

	if arg1_245.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_245.ladyWatchFloat, Layer.Default)
	end
end

function var0_0.EnterFurnitureWatchMode(arg0_246)
	arg0_246:SetAllBlackbloardValue("inLockLayer", true)
	arg0_246:EnableJoystick(true)
	arg0_246:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_247, arg1_247)
	arg0_247:HideFurnitureSlots()

	local var0_247 = arg0_247.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_248)
			arg0_247.furniturePOV = nil

			arg0_247:EnableJoystick(false)
			arg0_247:emit(var0_0.SHOW_BLOCK)
			arg0_247:ShowBlackScreen(true, arg0_248)
		end,
		function(arg0_249)
			existCall(arg1_247)
			arg0_247:RevertCharacter()
			arg0_247:SetAllBlackbloardValue("inLockLayer", false)
			arg0_247:RegisterCameraBlendFinished(var0_247, arg0_249)
			arg0_247:ActiveCamera(var0_247)
		end,
		function(arg0_250)
			arg0_247:ShowBlackScreen(false, arg0_250)
		end
	}, function()
		arg0_247:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_247:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_252, arg1_252)
	local var0_252 = arg0_252:GetFurnitureByName(arg1_252:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_252.cameraFurnitureWatch and arg0_252.cameraFurnitureWatch ~= var0_252 then
		arg0_252:UnRegisterCameraBlendFinished(arg0_252.cameraFurnitureWatch)
		setActive(arg0_252.cameraFurnitureWatch, false)
	end

	arg0_252.cameraFurnitureWatch = var0_252
	arg0_252.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_252.cameraFurnitureWatch
	arg0_252.furniturePOV = arg0_252.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_252:RegisterCameraBlendFinished(arg0_252.cameraFurnitureWatch, function()
		arg0_252:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_252:emit(var0_0.SHOW_BLOCK)
	arg0_252:ActiveCamera(arg0_252.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_254)
	if arg0_254.displaySlots then
		arg0_254:UpdateDisplaySlots({})
		table.Foreach(arg0_254.displaySlots, function(arg0_255, arg1_255)
			local var0_255 = arg1_255.trans

			if IsNil(var0_255:Find("Selector")) then
				return
			end

			setActive(var0_255:Find("Selector"), false)
		end)

		arg0_254.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_256, arg1_256)
	arg0_256:HideFurnitureSlots()

	arg0_256.displaySlots = {}

	_.each(arg1_256, function(arg0_257)
		arg0_256.displaySlots[arg0_257] = arg0_256.slotDict[arg0_257]

		if not arg0_256.displaySlots[arg0_257] then
			errorMsg("Slot " .. arg0_257 .. " Not Binding Scene Object")

			return
		end

		local var0_257 = arg0_256.displaySlots[arg0_257].trans

		if var0_257:Find("Selector") then
			setActive(var0_257:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_258, arg1_258)
	table.Foreach(arg0_258.displaySlots, function(arg0_259, arg1_259)
		local var0_259 = arg1_259.trans

		if not IsNil(var0_259:Find("Selector")) then
			setActive(var0_259:Find("Selector/Normal"), arg1_258[arg0_259] == 0)
			setActive(var0_259:Find("Selector/Active"), arg1_258[arg0_259] == 1)
			setActive(var0_259:Find("Selector/Ban"), arg1_258[arg0_259] == 2)
		end

		local var1_259 = arg0_258.slotDict[arg0_259].model
		local var2_259 = arg0_258.slotDict[arg0_259].displayModelName

		if var2_259 and var2_259 ~= "" then
			var1_259 = var0_259:GetChild(var0_259.childCount - 1)
		end

		local function var3_259(arg0_260, arg1_260)
			local var0_260 = arg0_260:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_260, function(arg0_261, arg1_261)
				local var0_261 = arg1_261.material

				if var0_261 and var0_261:HasProperty("_FinalTint") then
					var0_261:SetColor("_FinalTint", arg1_260)
				end
			end)
		end

		if var1_259 then
			if arg1_258[arg0_259] == 1 then
				var3_259(var1_259, Color.NewHex("3F83AE73"))
			else
				var3_259(var1_259, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_262, arg1_262, arg2_262)
	arg0_262:SetAllBlackbloardValue("inLockLayer", true)
	arg0_262:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_263)
			arg0_262:TempHideUI(true, arg0_263)
		end,
		function(arg0_264)
			arg0_262:ShowBlackScreen(true, arg0_264)
		end,
		function(arg0_265)
			local var0_265 = arg0_262.apartment:GetConfigID()
			local var1_265 = arg0_262.ladyDict[var0_265]

			arg0_262:SwitchAnim(var1_265, arg2_262)
			var1_265.ladyAnimator:Update(0)
			arg0_262:ResetCharPoint(var1_265, arg1_262:GetWatchCameraName())
			arg0_262:SyncInterestTransform(var1_265)
			setActive(var1_265.ladySafeCollider, true)
			arg0_262:HideCharacter(var0_265)

			local var2_265 = arg0_262.cameras[var0_0.CAMERA.PHOTO]
			local var3_265 = var2_265.m_XAxis

			var3_265.Value = 180
			var2_265.m_XAxis = var3_265

			local var4_265 = var2_265.m_YAxis

			var4_265.Value = 0.7
			var2_265.m_YAxis = var4_265
			arg0_262.pinchValue = 1

			arg0_262:RegisterOrbits(arg0_262.cameras[var0_0.CAMERA.PHOTO])
			arg0_262:SetCameraObrits()
			setActive(arg0_262.restrictedBox, true)
			arg0_262:RegisterCameraBlendFinished(var2_265, arg0_265)
			arg0_262:ActiveCamera(var2_265)
		end,
		function(arg0_266)
			arg0_262:ShowBlackScreen(false, arg0_266)
		end
	}, function()
		arg0_262:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_268)
	arg0_268:emit(var0_0.SHOW_BLOCK)
	arg0_268:EnableJoystick(false)
	seriesAsync({
		function(arg0_269)
			arg0_268:ShowBlackScreen(true, arg0_269)
		end,
		function(arg0_270)
			arg0_268:RevertCameraOrbit()

			local var0_270 = arg0_268:GetCurrentLadyEnv()

			arg0_268:SwitchAnim(var0_270, var0_0.ANIM.IDLE)
			setActive(var0_270.ladySafeCollider, false)
			onNextTick(function()
				arg0_268:ChangeCharacterPosition(var0_270)
			end)

			if arg0_268.contextData.photoFreeMode then
				arg0_268:EnablePOVLayer(false)

				arg0_268.contextData.photoFreeMode = nil
			end

			setActive(arg0_268.restrictedBox, false)

			local var1_270 = arg0_268.cameras[var0_0.CAMERA.POV]

			arg0_268:RegisterCameraBlendFinished(var1_270, arg0_270)
			arg0_268:ActiveCamera(var1_270)
		end,
		function(arg0_272)
			arg0_268:RevertCharacter(arg0_268.apartment:GetConfigID())
			arg0_268:ShowBlackScreen(false, arg0_272)
		end
	}, function()
		arg0_268:RefreshSlots()
		arg0_268:SetAllBlackbloardValue("inLockLayer", false)
		arg0_268:emit(var0_0.HIDE_BLOCK)
		arg0_268:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_268:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_274, arg1_274, arg2_274, arg3_274)
	arg0_274:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_275)
			arg0_274:ShowBlackScreen(true, arg0_275)
		end,
		function(arg0_276)
			local var0_276 = arg0_274:GetCurrentLadyEnv()

			arg0_274:SwitchAnim(var0_276, arg2_274)
			onNextTick(function()
				arg0_274:ResetCharPoint(var0_276, arg1_274:GetWatchCameraName())
				arg0_274:SyncInterestTransform(var0_276)

				if arg0_274.contextData.photoFreeMode then
					arg0_274.camBrain.enabled = false

					arg0_274:SwitchPhotoCamera()

					arg0_274.camBrain.enabled = true

					onDelayTick(function()
						arg0_274.camBrain.enabled = false

						arg0_274:SwitchPhotoCamera()

						arg0_274.camBrain.enabled = true
					end, 0.1)
				end

				arg0_276()
			end)
		end,
		function(arg0_279)
			arg0_274:ShowBlackScreen(false, arg0_279)
		end
	}, function()
		arg0_274:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_274)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_281)
	if not arg0_281.contextData.photoFreeMode then
		arg0_281:EnableJoystick(false)
		arg0_281:EnablePOVLayer(true)

		local var0_281 = arg0_281.cameras[var0_0.CAMERA.PHOTO_FREE]
		local var1_281 = arg0_281.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_281 = arg0_281.mainCameraTF.rotation:ToEulerAngles()
		local var3_281 = var1_281.m_HorizontalAxis

		var3_281.Value = var2_281.y
		var1_281.m_HorizontalAxis = var3_281

		local var4_281 = var1_281.m_VerticalAxis

		var4_281.Value = arg0_281:GetNearestAngle(var2_281.x, var4_281.m_MinValue, var4_281.m_MaxValue)
		var1_281.m_VerticalAxis = var4_281

		local var5_281 = arg0_281.mainCameraTF.position
		local var6_281 = arg0_281:GetRestritedHeightRange()
		local var7_281 = math.InverseLerp(var6_281[1], var6_281[2], var5_281.y)

		var5_281.y = math.clamp(var5_281.y, var6_281[1], var6_281[2])
		var0_281.transform.position = var5_281

		arg0_281:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var7_281)
		arg0_281:ActiveCamera(arg0_281.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_281:EnableJoystick(true)
		arg0_281:EnablePOVLayer(false)
		arg0_281:ActiveCamera(arg0_281.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_281.contextData.photoFreeMode = not arg0_281.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_282, arg1_282)
	local var0_282 = arg0_282.cameras[var0_0.CAMERA.PHOTO_FREE]
	local var1_282 = arg0_282:GetRestritedHeightRange()
	local var2_282 = math.lerp(var1_282[1], var1_282[2], arg1_282)

	var0_282:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var2_282 - var0_282.position.y, 0))
	onNextTick(function()
		local var0_283 = arg0_282:GetRestritedHeightRange()
		local var1_283 = math.InverseLerp(var0_283[1], var0_283[2], var0_282.position.y)

		arg0_282:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_283)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_284)
	local var0_284 = arg0_284.cameras[var0_0.CAMERA.PHOTO]
	local var1_284 = var0_284.m_XAxis

	var1_284.Value = 180
	var0_284.m_XAxis = var1_284

	local var2_284 = var0_284.m_YAxis

	var2_284.Value = 0.7
	var0_284.m_YAxis = var2_284
end

function var0_0.ResetCurrentCharPoint(arg0_285, arg1_285)
	local var0_285 = arg0_285:GetCurrentLadyEnv()

	arg0_285:ResetCharPoint(var0_285, arg1_285)
end

function var0_0.ResetCharPoint(arg0_286, arg1_286, arg2_286)
	local var0_286 = arg0_286.furnitures:Find(arg2_286 .. "/StayPoint")

	arg1_286.lady.position = var0_286.position
	arg1_286.lady.rotation = var0_286.rotation
end

function var0_0.GetNearestAngle(arg0_287, arg1_287, arg2_287, arg3_287)
	if arg3_287 < arg2_287 then
		arg3_287 = arg3_287 + 360
	end

	if arg2_287 <= arg1_287 and arg1_287 <= arg3_287 then
		return arg1_287
	end

	local var0_287 = (arg2_287 + arg3_287) / 2

	arg1_287 = var0_287 - Mathf.DeltaAngle(arg1_287, var0_287)
	arg1_287 = math.clamp(arg1_287, arg2_287, arg3_287)

	return arg1_287
end

function var0_0.PlayTimeline(arg0_288, arg1_288, arg2_288)
	local var0_288 = {}

	if arg0_288.waitForTimeline then
		table.insert(var0_288, function(arg0_289)
			local var0_289 = arg0_288.waitForTimeline

			arg0_288.waitForTimeline = nil

			var0_289()
			arg0_289()
		end)
	end

	table.insert(var0_288, function(arg0_290)
		arg0_288:LoadTimelineScene(arg1_288.name, false, nil, arg0_290)
	end)

	if arg1_288.scene and arg1_288.sceneRoot then
		table.insert(var0_288, function(arg0_291)
			arg0_288:ChangeArtScene(arg1_288.scene .. "|" .. arg1_288.sceneRoot, arg0_291)
		end)
	end

	table.insert(var0_288, function(arg0_292)
		local var0_292 = GameObject.Find("[actor]").transform
		local var1_292 = var0_292:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_292, function(arg0_293, arg1_293)
			GetOrAddComponent(arg1_293.transform, typeof(DftAniEvent))
		end)

		local var2_292 = var0_292:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_292

		eachChild(GameObject.Find("[camera]").transform, function(arg0_294)
			if arg0_294.tag == "MainCamera" then
				var3_292 = arg0_294
			end
		end)
		assert(var3_292, "Missing MainCamera")

		local var4_292 = GameObject.Find("[sequence]").transform

		arg0_288.nowTimelinePlayer = TimelinePlayer.New(var4_292)

		TimelineSupport.InitSubtitle(arg0_288.nowTimelinePlayer.comDirector, arg0_288.apartment:GetCallName())
		arg0_288.nowTimelinePlayer:Register(arg1_288.time, function(arg0_295, arg1_295, arg2_295)
			switch(arg1_295.stringParameter, {
				TimelinePause = function()
					arg0_295:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_295:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_295.intParameter == 0 or arg1_295.intParameter == arg2_295.selectIndex then
						arg0_295:SetTime(arg1_295.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_295.selectIndex = nil

					if arg1_288.options then
						local var0_299 = arg1_288.options[arg1_295.intParameter]

						arg0_288:DoTimelineOption(var0_299, function(arg0_300)
							arg2_295.selectIndex = arg0_300
							arg2_295.optionIndex = var0_299[arg0_300].flag

							arg0_295:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_295.selectIndex = nil

					if arg1_288.touchs then
						local var0_301 = arg1_288.touchs[arg1_295.intParameter]

						arg0_288:DoTimelineTouch(arg1_288.touchs[arg1_295.intParameter], function(arg0_302)
							arg2_295.selectIndex = arg0_302
							arg2_295.optionIndex = var0_301[arg0_302].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_295.selectIndex then
						arg0_295:RawSetTime(arg1_295.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_295.selectIndex = arg1_295.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_288.canTriggerAccompanyPerformance then
						arg0_288.canTriggerAccompanyPerformance = false

						local var0_305 = arg1_288.accompanys[arg1_295.intParameter]
						local var1_305 = var0_305[math.random(#var0_305)]

						arg0_295:SetTime(var1_305)
					end
				end,
				TimelineIKStart = function()
					arg2_295.selectIndex = nil

					local var0_306 = arg1_295.intParameter
					local var1_306 = arg0_288:GetCurrentLadyEnv()

					if var1_306:CheckIkTimelineStatus(var0_306) then
						arg0_288:SetIKTimelineStatus(var1_306, var2_292.gameObject, var0_306, var3_292)
					end
				end,
				TimelineEnd = function()
					arg2_295.finish = true

					arg0_295:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_295.stringParameter)
			end)

			if arg2_295.finish then
				arg0_288.timelineMark = arg2_295
				arg0_288.timelineFinishCall = nil

				local var0_295 = arg0_288:GetCurrentLadyEnv()

				if var0_295.ikTimelineMode then
					arg0_288:ExitIKTimelineStatus(var0_295)
				end

				arg0_292()
			end
		end)

		function arg0_288.timelineFinishCall()
			arg0_288.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_288:HideCharacter()
		setActive(arg0_288.mainCameraTF, false)
		setActive(var3_292, true)
		eachChild(arg0_288.rtTimelineScreen, function(arg0_310)
			setActive(arg0_310, false)
		end)
		setActive(arg0_288.rtTimelineScreen, true)
		setActive(arg0_288.rtTimelineScreen:Find("btn_skip"), arg0_288.inReplayTalk)
		arg0_288.nowTimelinePlayer:Start()
	end)
	table.insert(var0_288, function(arg0_311)
		arg0_288:ShowBlackScreen(true, function()
			arg0_288.nowTimelinePlayer:Stop()
			arg0_288.nowTimelinePlayer:Dispose()

			arg0_288.nowTimelinePlayer = nil

			arg0_288:UnloadTimelineScene(arg1_288.name, false, arg0_311)
		end)
	end)

	local var1_288 = arg0_288.dormSceneMgr.artSceneInfo

	table.insert(var0_288, function(arg0_313)
		arg0_288:RevertArtScene(var1_288, arg0_313)
	end)
	seriesAsync(var0_288, function()
		setActive(arg0_288.rtTimelineScreen, false)
		arg0_288:RevertCharacter()
		setActive(arg0_288.mainCameraTF, true)

		local var0_314 = arg0_288.timelineMark

		arg0_288.timelineMark = nil

		existCall(arg2_288, var0_314, function(arg0_315)
			arg0_288:ShowBlackScreen(false, arg0_315)
		end)
	end)
end

function var0_0.GetCurrentLadyEnv(arg0_316)
	if not arg0_316.apartment then
		return nil
	end

	return arg0_316.ladyDict[arg0_316.apartment:GetConfigID()]
end

function var0_0.PlayCurrentSingleAction(arg0_317, ...)
	local var0_317 = arg0_317:GetCurrentLadyEnv()

	return arg0_317:PlaySingleAction(var0_317, ...)
end

function var0_0.PlaySingleAction(arg0_318, arg1_318, arg2_318, arg3_318, arg4_318)
	arg1_318:PlaySingleAction(arg2_318, arg3_318, arg4_318)
end

function var0_0.SwitchCurrentAnim(arg0_319, ...)
	local var0_319 = arg0_319:GetCurrentLadyEnv()

	return arg0_319:SwitchAnim(var0_319, ...)
end

function var0_0.SwitchAnim(arg0_320, arg1_320, arg2_320, arg3_320)
	arg1_320:SwitchAnim(arg2_320, arg3_320)
end

function var0_0.PlayFaceAnim(arg0_321, arg1_321, arg2_321, arg3_321)
	arg1_321:PlayFaceAnim(arg2_321, arg3_321)
end

function var0_0.RegisterAnimCallback(arg0_322, arg1_322, arg2_322)
	arg0_322:GetCurrentLadyEnv().animCallbacks[arg1_322] = arg2_322
end

function var0_0.SetCharacterAnimSpeed(arg0_323, arg1_323)
	local var0_323 = arg0_323:GetCurrentLadyEnv()

	var0_323.ladyAnimator.speed = arg1_323
	var0_323.ladyHeadIKComp.blinkSpeed = var0_323.ladyHeadIKData.blinkSpeed * arg1_323

	if arg1_323 > 0 then
		var0_323.ladyHeadIKComp.DampTime = var0_323.ladyHeadIKData.DampTime / arg1_323
	else
		var0_323.ladyHeadIKComp.DampTime = var0_323.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_324, arg1_324)
	if arg1_324.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_324 = arg1_324.stringParameter
	local var1_324 = table.removebykey(arg0_324.animEventCallbacks, var0_324)

	existCall(var1_324)
end

function var0_0.RegisterAnimEventCallback(arg0_325, arg1_325, arg2_325)
	arg0_325.animEventCallbacks[arg1_325] = arg2_325
end

function var0_0.PlaySceneItemAnim(arg0_326, arg1_326, arg2_326, arg3_326)
	arg0_326.sceneAnimatorDict = arg0_326.sceneAnimatorDict or {}

	if not arg0_326.sceneAnimatorDict[arg1_326] then
		local var0_326 = pg.dorm3d_scene_animator[arg1_326]
		local var1_326 = arg0_326:GetSceneItem(var0_326.item_name)

		assert(var1_326, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_326 .. " " .. var0_326.item_name)

		if not var1_326 then
			return
		end

		local var2_326 = var1_326:GetComponent(typeof(Animator))

		if not var2_326 then
			return
		end

		arg0_326.sceneAnimatorDict[arg1_326] = {
			trans = var1_326,
			animator = var2_326
		}
	end

	if not arg3_326 and arg0_326.sceneAnimatorDict[arg1_326].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_326) then
		return
	end

	arg0_326.sceneAnimatorDict[arg1_326].animator:PlayInFixedTime(arg2_326)
end

function var0_0.ResetSceneItemAnimators(arg0_327, arg1_327)
	if not arg0_327.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_327.sceneAnimatorDict, function(arg0_328, arg1_328)
		if arg1_327 and table.contains(arg1_327, arg0_328) then
			return
		end

		setActive(arg1_328.trans, false)
		setActive(arg1_328.trans, true)

		arg0_327.sceneAnimatorDict[arg0_328] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_329, arg1_329, arg2_329, arg3_329, arg4_329, arg5_329, arg6_329, arg7_329)
	local function var0_329(arg0_330)
		if arg6_329 then
			local var0_330 = arg0_330:GetComponent(typeof(Animator))

			if var0_330 then
				var0_330:Play(arg6_329)

				var0_330.speed = arg7_329
			end
		end
	end

	arg1_329.extraItems = arg1_329.extraItems or {}

	if arg1_329.extraItems[arg2_329] then
		var0_329(arg1_329.extraItems[arg2_329].trans)

		return
	end

	local var1_329

	if arg3_329 == "" then
		var1_329 = arg1_329.lady
	elseif arg3_329 == "scene_root" then
		var1_329 = arg0_329.modelRoot
	else
		table.IpairsCArray(arg1_329.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_331, arg1_331)
			if arg1_331.name == arg3_329 then
				var1_329 = arg1_331
			end
		end)
	end

	if not var1_329 then
		return
	end

	arg0_329.loader:GetPrefab(string.lower("dorm3d/" .. arg2_329), "", function(arg0_332)
		setParent(arg0_332, var1_329)

		if arg4_329 then
			setLocalPosition(arg0_332, arg4_329)
		end

		if arg5_329 then
			setLocalRotation(arg0_332, arg5_329)
		end

		var0_329(arg0_332)

		arg1_329.extraItems[arg2_329] = {
			trans = arg0_332.transform,
			handler = var1_329
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_333, arg1_333, arg2_333)
	if not arg1_333.extraItems then
		return
	end

	table.Foreach(arg1_333.extraItems, function(arg0_334, arg1_334)
		if arg2_333 and table.contains(arg2_333, arg0_334) then
			return
		end

		arg0_333.loader:ReturnPrefab(arg1_334.trans.gameObject)

		arg1_333.extraItems[arg0_334] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_335, arg1_335, arg2_335)
	arg0_335.cameraBlendCallbacks[arg1_335] = arg2_335
end

function var0_0.UnRegisterCameraBlendFinished(arg0_336, arg1_336)
	arg0_336.cameraBlendCallbacks[arg1_336] = nil
end

function var0_0.OnCameraBlendFinished(arg0_337, arg1_337)
	if not arg1_337 then
		return
	end

	local var0_337 = table.removebykey(arg0_337.cameraBlendCallbacks, arg1_337)

	existCall(var0_337)
end

function var0_0.PlayHeartFX(arg0_338, arg1_338)
	local var0_338 = arg0_338.ladyDict[arg1_338]

	setActive(var0_338.effectHeart, false)
	setActive(var0_338.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_339, arg1_339)
	local var0_339 = arg1_339.name
	local var1_339 = arg0_339.expressionDict[var0_339]
	local var2_339 = 5

	if var1_339 then
		local var3_339 = var1_339.timer

		var3_339:Reset(nil, var2_339)
		var3_339:Start()

		if var1_339.instance then
			setActive(var1_339.instance, false)
			setActive(var1_339.instance, true)
		end

		return
	end

	local var4_339 = {
		name = var0_339,
		timer = Timer.New(function()
			arg0_339:RemoveExpression(var0_339)
		end, var2_339, 1, true)
	}

	arg0_339.expressionDict[var0_339] = var4_339

	arg0_339.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_339, var0_339, function(arg0_341)
		var4_339.instance = arg0_341

		onNextTick(function()
			local var0_342 = arg0_339:GetCurrentLadyEnv()

			setParent(arg0_341, var0_342.ladyHeadCenter)
		end)
		setLocalPosition(arg0_341, Vector3(0, 0, -0.2))
		setActive(arg0_341, false)
		setActive(arg0_341, true)
	end, var4_339)
end

function var0_0.RemoveExpression(arg0_343, arg1_343)
	local var0_343 = arg0_343.expressionDict[arg1_343]

	if not var0_343 then
		return
	end

	arg0_343.loader:ClearRequest(var0_343)

	if var0_343.instance then
		arg0_343.loader:ReturnPrefab(var0_343.instance)
	end

	arg0_343.expressionDict[arg1_343] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_344, arg1_344, arg2_344)
	setActive(arg1_344.ladyWatchFloat, arg2_344)
end

function var0_0.RegisterGlobalVolume(arg0_345)
	local var0_345 = arg0_345.globalVolume
	local var1_345 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_345, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_345 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_345, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	arg0_345.originalCameraSettings = {
		depthOfField = {
			enabled = var1_345.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_345.gaussianStart.min,
				value = var1_345.gaussianStart.value
			},
			blurRadius = {
				min = var1_345.blurRadius.min,
				max = var1_345.blurRadius.max,
				value = var1_345.blurRadius.value
			}
		},
		postExposure = {
			value = var2_345.postExposure.value
		},
		contrast = {
			min = var2_345.contrast.min,
			max = var2_345.contrast.max,
			value = var2_345.contrast.value
		},
		saturate = {
			min = var2_345.saturation.min,
			max = var2_345.saturation.max,
			value = var2_345.saturation.value
		}
	}
	arg0_345.originalCameraSettings.depthOfField.enabled = true

	local var3_345 = var0_345:GetComponent(typeof(UnityEngine.Rendering.Volume))

	arg0_345.originalVolume = {
		profile = var3_345.sharedProfile,
		weight = var3_345.weight
	}
end

function var0_0.SettingCamera(arg0_346, arg1_346)
	arg0_346.activeCameraSettings = arg1_346

	local var0_346 = arg0_346.globalVolume
	local var1_346 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_346, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_346 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_346, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	var1_346.enabled:Override(arg1_346.depthOfField.enabled)
	var1_346.gaussianStart:Override(arg1_346.depthOfField.focusDistance.value)
	var1_346.gaussianEnd:Override(arg1_346.depthOfField.focusDistance.value + arg1_346.depthOfField.focusDistance.length)
	var1_346.blurRadius:Override(arg1_346.depthOfField.blurRadius.value)
	var2_346.postExposure:Override(arg1_346.postExposure.value)
	var2_346.contrast:Override(arg1_346.contrast.value)
	var2_346.saturation:Override(arg1_346.saturate.value)
end

function var0_0.GetCameraSettings(arg0_347)
	return arg0_347.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_348)
	arg0_348:SettingCamera(arg0_348.originalCameraSettings)

	arg0_348.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_349, arg1_349, arg2_349)
	if arg0_349.cameraVolume then
		arg0_349:RevertVolumeProfile()
	end

	arg0_349.loader:GetPrefab("dorm3d/effect/volume/" .. arg1_349, "", function(arg0_350)
		arg0_349.cameraVolume = arg0_350
	end)
end

function var0_0.RevertVolumeProfile(arg0_351)
	if arg0_351.cameraVolume then
		arg0_351.loader:ReturnPrefab(arg0_351.cameraVolume)

		arg0_351.cameraVolume = nil
	end
end

function var0_0.RecordCharacterLight(arg0_352)
	tolua.loadassembly("Yongshi.BLRP.Runtime.AOT")

	local var0_352 = arg0_352.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	arg0_352.originalCharacterColor = {
		color = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var0_352),
		intensity = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var0_352)
	}
end

function var0_0.SetCharacterLight(arg0_353, arg1_353, arg2_353, arg3_353)
	local var0_353 = arg0_353.characterLight:GetComponent(typeof(Light))
	local var1_353 = Color.Lerp(arg0_353.originalCharacterColor.color, arg1_353, arg3_353)
	local var2_353 = math.lerp(arg0_353.originalCharacterColor.intensity, arg2_353, arg3_353)
	local var3_353 = arg0_353.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var3_353, var1_353)
	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var3_353, var2_353)
end

function var0_0.RevertCharacterLight(arg0_354)
	arg0_354:SetCharacterLight(arg0_354.originalCharacterColor.color, arg0_354.originalCharacterColor.intensity, 1)
end

function var0_0.onBackPressed(arg0_355)
	if arg0_355.exited or arg0_355.retainCount > 0 then
		-- block empty
	else
		arg0_355:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_356, arg1_356, arg2_356, arg3_356, arg4_356)
	arg0_356.dormSceneMgr:LoadTimelineScene({
		name = arg1_356,
		assetRootName = arg0_356.apartment:getConfig("asset_name"),
		isCache = arg2_356,
		waitForTimeline = arg3_356,
		loadSceneFunc = function(arg0_357, arg1_357)
			local var0_357 = GameObject.Find("[actor]").transform

			arg0_356:HXCharacter(tf(var0_357))
		end
	}, arg4_356)
end

function var0_0.UnloadTimelineScene(arg0_358, arg1_358, arg2_358, arg3_358)
	arg0_358.dormSceneMgr:UnloadTimelineScene(arg1_358, arg2_358, arg3_358)
end

function var0_0.ChangeArtScene(arg0_359, arg1_359, arg2_359)
	local var0_359 = {}

	table.insert(var0_359, function(arg0_360)
		arg0_359.dormSceneMgr:ChangeArtScene(arg1_359, arg0_360)
	end)
	table.insert(var0_359, function(arg0_361)
		setActive(arg0_359.slotRoot, false)
		arg0_361()
	end)
	warning(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", arg1_359, arg0_359.dormSceneMgr.sceneInfo, Dorm3dSceneMgr.IsSameSceneInfo(arg1_359, arg0_359.dormSceneMgr.sceneInfo))

	if Dorm3dSceneMgr.IsSameSceneInfo(arg1_359, arg0_359.dormSceneMgr.sceneInfo) then
		table.insert(var0_359, function(arg0_362)
			arg0_359:SwitchDayNight(1)
			arg0_359:TempHideContact(true)
			arg0_362()
		end)
	end

	seriesAsync(var0_359, arg2_359)
end

function var0_0.RevertArtScene(arg0_363, arg1_363, arg2_363)
	local var0_363 = {}

	table.insert(var0_363, function(arg0_364)
		arg0_363.dormSceneMgr:ChangeArtScene(arg1_363, arg0_364)
	end)
	table.insert(var0_363, function(arg0_365)
		setActive(arg0_363.slotRoot, true)
		arg0_365()
	end)
	table.insert(var0_363, function(arg0_366)
		arg0_363:SwitchDayNight(arg0_363.contextData.timeIndex)
		onNextTick(function()
			arg0_363:RefreshSlots()
			arg0_363:TempHideContact(false)
			arg0_366()
		end)
	end)
	seriesAsync(var0_363, arg2_363)
end

function var0_0.ChangeSubScene(arg0_368, arg1_368, arg2_368)
	local var0_368 = {}

	table.insert(var0_368, function(arg0_369)
		arg0_368.dormSceneMgr:ChangeSubScene(arg1_368, arg0_369)
	end)

	local var1_368 = arg0_368:GetCurrentLadyEnv()

	table.insert(var0_368, function(arg0_370)
		if Dorm3dSceneMgr.IsSameSceneInfo(arg1_368, arg0_368.dormSceneMgr.sceneInfo) then
			var1_368.ladyActiveZone = var1_368.walkBornPoint or var1_368.ladyBaseZone
		else
			var1_368.ladyActiveZone = var1_368.walkBornPoint or "Default"
		end

		arg0_370()
	end)

	if not Dorm3dSceneMgr.IsSameSceneInfo(arg1_368, arg0_368.dormSceneMgr.subSceneInfo) then
		table.insert(var0_368, function(arg0_371)
			local var0_371, var1_371 = Dorm3dSceneMgr.ParseInfo(arg1_368)
			local var2_371 = var0_371 .. "_base"

			arg0_368:ResetSceneStructure(SceneManager.GetSceneByName(var2_371))

			if Dorm3dSceneMgr.IsSameSceneInfo(arg1_368, arg0_368.dormSceneMgr.sceneInfo) then
				arg0_368:RefreshSlots()
			else
				arg0_368:SwitchAnim(var1_368, var0_0.ANIM.IDLE)
			end

			if not Dorm3dSceneMgr.IsSameSceneInfo(arg0_368.dormSceneMgr.subSceneInfo, arg0_368.dormSceneMgr.sceneInfo) then
				arg0_368:RefreshSlotsEmpty()
			end

			arg0_371()
		end)
	end

	table.insert(var0_368, function(arg0_372)
		onNextTick(function()
			arg0_368:ChangeCharacterPosition(var1_368)
			arg0_368:ChangePlayerPosition(var1_368.ladyActiveZone)
			arg0_368:TriggerLadyDistance()
			arg0_368:CheckInSector()
			arg0_372()
		end)
	end)
	seriesAsync(var0_368, arg2_368)
end

function var0_0.IsPointInSector(arg0_374, arg1_374)
	local var0_374 = arg1_374 - arg0_374.Position

	if var0_374.y > arg0_374.Radius then
		return false
	end

	var0_374.y = 0

	if var0_374.magnitude > arg0_374.Radius then
		return false
	end

	local var1_374 = arg0_374.Rotation

	return Vector3.Angle(var1_374 * Vector3.forward, var0_374) <= arg0_374.Angle / 2
end

function var0_0.GetRestritedHeightRange(arg0_375)
	if not arg0_375.isMultiFloor then
		return arg0_375.restrictedHeightRange
	else
		for iter0_375 = #arg0_375.restrictedHeightRange, 1, -1 do
			local var0_375 = arg0_375.restrictedHeightRange[iter0_375]

			if arg0_375.mainCameraTF.position.y >= var0_375[1] then
				return var0_375
			end
		end

		return arg0_375.restrictedHeightRange[1]
	end
end

function var0_0.willExit(arg0_376)
	arg0_376:RemoveExtraSystem()
	arg0_376.joystickTimer:Stop()
	arg0_376.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_376.updateHandler)
	arg0_376:StopIKHandTimer()

	if arg0_376.moveTimer then
		arg0_376.moveTimer:Stop()

		arg0_376.moveTimer = nil
	end

	if arg0_376.moveWaitTimer then
		arg0_376.moveWaitTimer:Stop()

		arg0_376.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_376.furnitures) then
		eachChild(arg0_376.furnitures, function(arg0_377)
			local var0_377 = GetComponent(arg0_377, typeof(EventTriggerListener))

			if not var0_377 then
				return
			end

			var0_377:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_376, iter1_376 in pairs(arg0_376.ladyDict) do
		GetComponent(iter1_376.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_376.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_376.camBrainEvenetHandler.OnBlendFinished = nil

	arg0_376:UnOverlayPanel(arg0_376.blockLayer, arg0_376._tf)
	table.Foreach(arg0_376.expressionDict, function(arg0_378)
		arg0_376:RemoveExpression(arg0_378)
	end)
	arg0_376.loader:Clear()
	pg.ClickEffectMgr.GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_376.dormSceneMgr:Dispose()

	arg0_376.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)

	if arg0_376.transformFilter then
		arg0_376.transformFilter:Dispose()
	end
end

return var0_0
