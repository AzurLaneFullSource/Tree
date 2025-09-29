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
			local var0_29 = arg0_14.ladyDict[arg0_14.apartment:GetConfigID()]

			arg0_14[arg1_29](arg0_14, var0_29, ...)
		else
			arg0_14[arg1_29](arg0_14, ...)
		end
	end)
end

function var0_0.RegisterIKFunc(arg0_30)
	pg.IKMgr.GetInstance():RegisterOnIKLayerActive(function(arg0_31)
		arg0_30.blockIK = true

		local var0_31 = arg0_30.ladyDict[arg0_30.apartment:GetConfigID()]

		var0_31.ikHandler = arg0_31

		local var1_31 = _.detect(var0_31.readyIKLayers, function(arg0_32)
			return arg0_32:GetControllerPath() == arg0_31.ikData:GetControllerPath()
		end)

		arg0_30:EnableIKLayer(var1_31)

		arg0_30.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

		arg0_30:emit(var0_0.ON_IK_STATUS_CHANGED, var1_31:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDrag(function(arg0_33)
		arg0_30.ladyDict[arg0_30.apartment:GetConfigID()].ikHandler = arg0_33

		arg0_30:ResetIKTipTimer()
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_34, arg1_34)
		local var0_34 = arg0_30.ladyDict[arg0_30.apartment:GetConfigID()]
		local var1_34 = _.detect(var0_34.readyIKLayers, function(arg0_35)
			return arg0_35:GetControllerPath() == arg0_34.ikData:GetControllerPath()
		end)

		arg0_30:DeactiveIKLayer(var1_34)

		var0_34.ikHandler = nil
		arg0_30.blockIK = arg1_34

		arg0_30:emit(var0_0.ON_IK_STATUS_CHANGED, var1_34:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_36)
		local var0_36 = arg0_30.ladyDict[arg0_30.apartment:GetConfigID()]

		arg0_30.blockIK = nil

		local var1_36 = _.detect(var0_36.readyIKLayers, function(arg0_37)
			return arg0_37:GetControllerPath() == arg0_36.ikData:GetControllerPath()
		end)

		arg0_30:OnTriggerIK(var1_36)
		arg0_30:emit(var0_0.ON_IK_STATUS_CHANGED, var1_36:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	end)
end

function var0_0.initScene(arg0_38)
	local var0_38, var1_38 = unpack(string.split(arg0_38.dormSceneMgr.sceneInfo, "|"))
	local var2_38 = SceneManager.GetSceneByName(var0_38 .. "_base")

	arg0_38:ResetSceneStructure(var2_38)

	arg0_38.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_38.camBrain = arg0_38.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_38.camBrainEvenetHandler = arg0_38.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_38.raycastCamera = arg0_38.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_38.sceneRaycaster = arg0_38.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_38.player = GameObject.Find("Player").transform
	arg0_38.playerEye = arg0_38.player:Find("Eye")
	arg0_38.playerFoot = arg0_38.player:Find("Foot")

	setActive(arg0_38.playerFoot, false)

	arg0_38.playerController = arg0_38.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_38.attachedPoints = {}

	eachChild(arg0_38.furnitures, function(arg0_39)
		table.insert(arg0_38.attachedPoints, 1, arg0_39)
	end)

	arg0_38.modelRoot = GameObject.Find("scene_root").transform
	arg0_38.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_38.slotRoot, true)
	arg0_38:InitSlots()
	tolua.loadassembly("Cinemachine")

	local var3_38 = GameObject.Find("CM Cameras").transform

	eachChild(var3_38, function(arg0_40)
		setActive(arg0_40, false)
	end)

	arg0_38.camBrain.enabled = false
	arg0_38.camBrain.enabled = true
	arg0_38.cameraAim = var3_38:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_38.cameraAim2 = var3_38:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_38.cameraFree = nil
	arg0_38.cameraFurnitureWatch = nil
	arg0_38.cameraRole = var3_38:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_38.cameraRole2 = var3_38:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	local var4_38 = var3_38:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	arg0_38.cameraGift = var3_38:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_38.cameras = {
		arg0_38.cameraAim,
		arg0_38.cameraAim2,
		arg0_38.cameraRole,
		[var0_0.CAMERA.TALK] = var4_38,
		[var0_0.CAMERA.GIFT] = arg0_38.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_38.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_38:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_38:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_38:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)),
		[var0_0.CAMERA.SKIN] = arg0_38.room:isPersonalRoom() and var3_38:Find("Skin Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)) or nil
	}

	setActive(arg0_38.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_38.compPovAim = arg0_38.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_38.cameraRoot = var3_38
	arg0_38.POVOriginalFOV = arg0_38:GetPOVFOV()
	arg0_38.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_38.restrictedBox, false)

	local var5_38 = arg0_38.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(CharacterController)).radius

	arg0_38.isMultiFloor = arg0_38.restrictedBox.childCount > 2

	local var6_38 = "Floor"
	local var7_38 = "Celling"

	if arg0_38.isMultiFloor then
		arg0_38.restrictedHeightRange = {}

		for iter0_38 = 0, math.floor(arg0_38.restrictedBox.childCount / 2) - 1 do
			local var8_38 = iter0_38 == 0 and var6_38 or var6_38 .. "_" .. iter0_38
			local var9_38 = iter0_38 == 0 and var7_38 or var7_38 .. "_" .. iter0_38

			table.insert(arg0_38.restrictedHeightRange, {
				arg0_38.restrictedBox:Find(var8_38).position.y + var5_38,
				arg0_38.restrictedBox:Find(var9_38).position.y - var5_38
			})
		end
	else
		arg0_38.restrictedHeightRange = {
			arg0_38.restrictedBox:Find(var6_38).position.y + var5_38,
			arg0_38.restrictedBox:Find(var7_38).position.y - var5_38
		}
	end

	arg0_38.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_38.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent("DayNightCtrl")

	arg0_38:SwitchDayNight(arg0_38.contextData.timeIndex)

	arg0_38.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_38 .. "_base")).CutIn

	if arg0_38.tfCutIn then
		arg0_38.modelCutIn = {
			lady = arg0_38.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_38.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_38.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_41, arg1_41, arg2_41)
	if arg2_41 and not IsNil(arg2_41) then
		arg2_41:SwitcherToIndex(arg1_41 - 1)
	elseif not IsNil(arg0_41.daynightCtrlComp) then
		arg0_41.daynightCtrlComp:SwitcherToIndex(arg1_41 - 1)
	end

	arg0_41:InitLightSettings()
end

function var0_0.InitLightSettings(arg0_42)
	arg0_42.globalVolume = GameObject.Find("GlobalVolume")

	arg0_42:RegisterGlobalVolume()

	arg0_42.characterLight = GameObject.Find("CharacterLight")

	arg0_42:RecordCharacterLight()

	local var0_42 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_42:GetComponentsInChildren(typeof(Light), true), function(arg0_43, arg1_43)
		arg1_43.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.ResetSceneStructure(arg0_44, arg1_44)
	table.IpairsCArray(arg1_44:GetRootGameObjects(), function(arg0_45, arg1_45)
		if arg1_45.name == "Furnitures" then
			arg0_44.furnitures = tf(arg1_45)

			eachChild(arg0_44.furnitures, function(arg0_46)
				if arg0_46:Find("FreeLook Camera") then
					setActive(arg0_46:Find("FreeLook Camera"), false)
				end

				if arg0_46:Find("FreeLook Camera") then
					setActive(arg0_46:Find("RoleWatch Camera"), false)
				end

				if arg0_46:Find("IKCamera") then
					setActive(arg0_46:Find("IKCamera"), false)
				end

				local var0_46 = arg0_46:GetComponent(typeof(UnityEngine.Collider))

				if not var0_46 then
					return
				end

				var0_46.enabled = false
			end)
		end
	end)
end

function var0_0.InitSlots(arg0_47)
	local var0_47 = arg0_47.room:GetSlots()
	local var1_47 = arg0_47.modelRoot:GetComponentsInChildren(typeof(Transform), true):ToTable()

	arg0_47.slotDict = {}

	_.each(var0_47, function(arg0_48)
		local var0_48 = arg0_48:GetFurnitureName()
		local var1_48 = arg0_48:GetConfigID()
		local var2_48 = arg0_47.slotRoot:Find(tostring(var1_48))

		if not var2_48 then
			errorMsg("Not Find Slot: " .. var1_48)

			return
		end

		local var3_48 = {
			trans = var2_48,
			sceneHides = {}
		}
		local var4_48 = var2_48:Find("Selector")

		if var4_48 then
			GetOrAddComponent(var4_48, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_49, arg1_49)
				arg0_47:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_48)
			end)
			setActive(var4_48, false)
		end

		local var5_48

		for iter0_48, iter1_48 in ipairs(var1_47) do
			if iter1_48.name == var0_48 then
				var5_48 = iter1_48

				break
			end
		end

		if var5_48 then
			var3_48.model = var5_48
		end

		arg0_47.slotDict[var1_48] = var3_48
	end)
end

function var0_0.SetContactStateDic(arg0_50, arg1_50)
	arg0_50.contactStateDic = arg1_50
	arg0_50.hideContactStateDic = {}
	arg0_50.contactInRangeDic = {}
	arg0_50.transRangeDic = {
		list = {}
	}
	arg0_50.transformFilter = arg0_50.transformFilter or BLHX.Rendering.TransformFilter.New()

	for iter0_50, iter1_50 in pairs(arg0_50.contactStateDic) do
		arg0_50.hideContactStateDic[iter0_50] = math.min(iter1_50, ApartmentRoom.ITEM_UNLOCK)
		arg0_50.contactInRangeDic[iter0_50] = false

		local var0_50 = pg.dorm3d_collection_template[iter0_50].vfx_prefab

		arg0_50.transRangeDic[iter0_50] = {
			#arg0_50.transRangeDic.list + 1,
			#var0_50
		}

		table.insertto(arg0_50.transRangeDic.list, underscore.map(var0_50, function(arg0_51)
			return arg0_50.modelRoot:Find(arg0_51)
		end))
	end

	arg0_50.transformFilter:Init(arg0_50.mainCameraTF, arg0_50.transRangeDic.list, 2, 60)
	arg0_50:ActiveContact()
end

function var0_0.TempHideContact(arg0_52, arg1_52)
	arg0_52.hideConcatFlag = arg1_52

	arg0_52:ActiveContact()
end

function var0_0.ActiveContact(arg0_53)
	for iter0_53, iter1_53 in pairs(arg0_53.contactInRangeDic) do
		arg0_53:UpdateContactDisplay(iter0_53, arg0_53.contactInRangeDic[iter0_53] and not arg0_53.hideConcatFlag and arg0_53.contactStateDic[iter0_53] or arg0_53.hideContactStateDic[iter0_53])
	end
end

function var0_0.UpdateContactDisplay(arg0_54, arg1_54, arg2_54)
	local var0_54 = pg.dorm3d_collection_template[arg1_54]

	for iter0_54, iter1_54 in ipairs(var0_54.vfx_prefab) do
		local var1_54 = arg0_54.modelRoot:Find(iter1_54)

		if arg0_54:IsModeInHidePending(iter1_54) then
			-- block empty
		elseif not arg0_54.modelRoot:Find(iter1_54) then
			warning(arg1_54, iter1_54)
		else
			setActive(var1_54, arg2_54 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_54, iter3_54 in ipairs(var0_54.model) do
		if arg0_54:IsModeInHidePending(iter3_54) then
			-- block empty
		elseif not arg0_54.modelRoot:Find(iter3_54) then
			warning(arg1_54, iter3_54)
		else
			local var2_54 = arg0_54.modelRoot:Find(iter3_54)

			if arg0_54:CheckSceneItemActive(var2_54) then
				local var3_54 = GetComponent(var2_54, typeof(EventTriggerListener))

				if arg2_54 == ApartmentRoom.ITEM_FIRST then
					var3_54 = var3_54 or GetOrAddComponent(var2_54, typeof(EventTriggerListener))

					var3_54:AddPointClickFunc(function(arg0_55, arg1_55)
						arg0_54:emit(var0_0.CLICK_CONTACT, arg1_54)
					end)

					var3_54.enabled = true
				elseif var3_54 then
					var3_54.enabled = false
				end

				setActive(var2_54, arg2_54 > ApartmentRoom.ITEM_LOCK)
			end
		end
	end
end

function var0_0.SetFloatEnable(arg0_56, arg1_56)
	arg0_56.enableFloatUpdate = arg1_56

	if arg1_56 then
		arg0_56:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_57)
	local var0_57 = arg0_57.ladyDict[arg0_57.apartment:GetConfigID()]
	local var1_57 = arg0_57:GetScreenPosition(var0_57.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var2_57 = arg0_57:GetLocalPosition(var1_57, arg0_57.rtFloatPage)

	setLocalPosition(arg0_57.rtFloatPage:Find("lady"), var2_57)
end

function var0_0.LoadCharacter(arg0_58, arg1_58, arg2_58)
	arg0_58.hxMatDict = {}
	arg0_58.ladyDict = {}
	arg0_58.skinDict = {}

	local var0_58 = {}

	for iter0_58, iter1_58 in ipairs(arg1_58) do
		table.insert(var0_58, function(arg0_59)
			arg0_58:LoadSingleCharacter(iter1_58, arg0_59)
		end)
	end

	parallelAsync(var0_58, arg2_58)
end

function var0_0.LoadCharacterAdditionally(arg0_60, arg1_60, arg2_60)
	local var0_60 = {}

	for iter0_60, iter1_60 in ipairs(arg1_60) do
		table.insert(var0_60, function(arg0_61)
			arg0_60:LoadSingleCharacter(iter1_60, function()
				arg0_60:InitCharacter(arg0_60.ladyDict[iter1_60], iter1_60)
				arg0_61()
			end)
		end)
	end

	parallelAsync(var0_60, arg2_60)
end

function var0_0.LoadSingleCharacter(arg0_63, arg1_63, arg2_63)
	local var0_63 = {}
	local var1_63 = LadyEnv.New(arg0_63)

	arg0_63.ladyDict[arg1_63] = var1_63

	local var2_63 = getProxy(ApartmentProxy):getApartment(arg1_63)
	local var3_63 = var2_63:getConfig("asset_name")
	local var4_63 = var2_63:GetSkinModelID(arg0_63.room:getConfig("tag"))
	local var5_63 = Dorm3dSkin.New({
		configId = var4_63
	}):GetModelName()

	assert(var5_63)

	for iter0_63, iter1_63 in ipairs({
		"common",
		var5_63
	}) do
		local var6_63 = string.format("dorm3d/character/%s/res/%s", var3_63, iter1_63)

		if checkABExist(var6_63) then
			table.insert(var0_63, function(arg0_64)
				arg0_63.loader:LoadBundle(var6_63, function(arg0_65)
					for iter0_65, iter1_65 in ipairs(arg0_65:GetAllAssetNames()) do
						local var0_65, var1_65, var2_65 = string.find(string.lower(iter1_65), "material_hx[/\\](.*).mat")

						if var0_65 then
							arg0_63.hxMatDict[var2_65 .. " (Instance)"] = {
								arg0_65,
								iter1_65
							}
							arg0_63.hxMatDict[var2_65] = {
								arg0_65,
								iter1_65
							}
						end
					end

					arg0_64()
				end)
			end)
		end
	end

	var1_63.skinId = var4_63
	var1_63.skinIdList = {
		var4_63
	}

	table.insert(var0_63, function(arg0_66)
		local var0_66 = string.format("dorm3d/character/%s/prefabs/%s", var3_63, var5_63)

		arg0_63.loader:GetPrefab(var0_66, "", function(arg0_67)
			var1_63.ladyGameObject = arg0_67
			arg0_63.skinDict[var4_63] = {
				ladyGameObject = arg0_67
			}

			arg0_66()
		end)
	end)

	if arg0_63.room:isPersonalRoom() then
		for iter2_63, iter3_63 in ipairs(var2_63:GetAllModelIds()) do
			if not table.contains(var1_63.skinIdList, iter3_63) then
				local var7_63 = Dorm3dSkin.New({
					configId = iter3_63
				}):GetModelName()
				local var8_63 = string.format("dorm3d/character/%s/prefabs/%s", var3_63, var7_63)

				if checkABExist(var8_63) then
					table.insert(var1_63.skinIdList, iter3_63)
					table.insert(var0_63, function(arg0_68)
						arg0_63.loader:GetPrefab(var8_63, "", function(arg0_69)
							arg0_63.skinDict[iter3_63] = {
								ladyGameObject = arg0_69
							}
							GetComponent(arg0_69, "GraphOwner").enabled = false

							setActive(arg0_69, false)
							arg0_68()
						end)
					end)
				end
			end
		end
	end

	if arg0_63.contextData.pendingDic[arg1_63] then
		local var9_63 = pg.dorm3d_welcome[arg0_63.contextData.pendingDic[arg1_63]]

		if var9_63.item_prefab ~= "" then
			table.insert(var0_63, function(arg0_70)
				local var0_70 = string.lower("dorm3d/furniture/item/" .. var9_63.item_prefab)

				arg0_63.loader:GetPrefab(var0_70, "", function(arg0_71)
					var1_63.tfPendintItem = arg0_71.transform

					setActive(arg0_71, false)
					arg0_70()
				end)
			end)
		end
	end

	parallelAsync(var0_63, arg2_63)
end

function var0_0.HXCharacter(arg0_72, arg1_72)
	if not HXSet.isHx() then
		return
	end

	local var0_72 = arg1_72:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_72, function(arg0_73, arg1_73)
		local var0_73 = arg1_73.sharedMaterials
		local var1_73 = false

		table.IpairsCArray(var0_73, function(arg0_74, arg1_74)
			if arg1_74 == nil then
				return
			end

			local var0_74 = arg1_74.name

			if not arg0_72.hxMatDict[var0_74] then
				return
			end

			var1_73 = true

			local var1_74, var2_74 = unpack(arg0_72.hxMatDict[var0_74])
			local var3_74 = var1_74:LoadAssetSync(var2_74, typeof(Material), false, false)

			var0_73[arg0_74] = var3_74

			warning("Replace HX Material", arg0_72.hxMatDict[var0_74][2])
		end)

		if var1_73 then
			arg1_73.sharedMaterials = var0_73

			GraphicsInterface.Instance:UpdateCharacterMaterialLst(go(arg1_72))
		end
	end)
end

function var0_0.InitCharacter(arg0_75, arg1_75, arg2_75)
	arg1_75:InitCharacter(arg2_75)
	arg0_75:HXCharacter(arg1_75.lady)
	arg1_75:SetZone(arg0_75.contextData.ladyZone[arg2_75])
	arg0_75:ChangeCharacterPosition(arg1_75)
end

function var0_0.SetCameraLady(arg0_76, arg1_76)
	arg0_76.cameraAim2.LookAt = arg1_76.ladyInterestRoot
	arg0_76.cameras[var0_0.CAMERA.TALK].Follow = arg1_76.ladyInterestRoot
	arg0_76.cameras[var0_0.CAMERA.TALK].LookAt = arg1_76.ladyInterestRoot
	arg0_76.cameraGift.Follow = arg0_76.ladyInterest
	arg0_76.cameraGift.LookAt = arg0_76.ladyInterest
	arg0_76.cameraRole2.LookAt = arg1_76.ladyInterestRoot
	arg0_76.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_76.ladyInterest
	arg0_76.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_76.ladyInterest
end

function var0_0.initNodeCanvas(arg0_77)
	local var0_77 = pg.NodeCanvasMgr.GetInstance()

	var0_77:Active()
	var0_77:RegisterFunc("DistanceTrigger", function(arg0_78)
		arg0_77:emit(var0_0.DISTANCE_TRIGGER, arg0_78, arg0_77.ladyDict[arg0_78].dis)
	end)
	var0_77:RegisterFunc("ShortWaitAction", function(arg0_79)
		arg0_77:DoShortWait(arg0_79)
	end)
	var0_77:RegisterFunc("WatchShortWaitAction", function(arg0_80)
		arg0_77:DoShortWait(arg0_80)
	end)
	var0_77:RegisterFunc("WalkDistanceTrigger", function(arg0_81)
		arg0_77:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_81, arg0_77.ladyDict[arg0_81].dis)
	end)
	var0_77:RegisterFunc("ChangeWatch", function(arg0_82)
		arg0_77:emit(var0_0.CHANGE_WATCH, arg0_82)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_83, arg1_83, arg2_83)
	arg0_83[arg1_83] = arg2_83

	for iter0_83, iter1_83 in pairs(arg0_83.ladyDict) do
		arg0_83:SetBlackboardValue(iter1_83, arg1_83, arg2_83)
	end
end

function var0_0.SetBlackboardValue(arg0_84, arg1_84, arg2_84, arg3_84)
	arg1_84:SetBlackboardValue(arg2_84, arg3_84)
end

function var0_0.GetBlackboardValue(arg0_85, arg1_85, arg2_85)
	return arg1_85:GetBlackboardValue(arg2_85)
end

function var0_0.didEnter(arg0_86)
	local var0_86 = -21.6 / Screen.height

	arg0_86.joystickDelta = Vector2.zero
	arg0_86.joystickTimer = FrameTimer.New(function()
		local var0_87 = arg0_86.joystickDelta * var0_86
		local var1_87 = var0_87.x
		local var2_87 = var0_87.y

		local function var3_87(arg0_88, arg1_88, arg2_88)
			local var0_88 = arg0_88[arg1_88]

			var0_88.m_InputAxisValue = arg2_88
			arg0_88[arg1_88] = var0_88
		end

		if arg0_86.surroudCamera and not arg0_86.pinchMode then
			var3_87(arg0_86.surroudCamera, "m_XAxis", var1_87)
			var3_87(arg0_86.surroudCamera, "m_YAxis", var2_87)
		elseif arg0_86.furniturePOV and arg0_86.cameras[var0_0.CAMERA.FURNITURE_WATCH] and isActive(arg0_86.cameras[var0_0.CAMERA.FURNITURE_WATCH]) then
			var3_87(arg0_86.furniturePOV, "m_HorizontalAxis", var1_87)
			var3_87(arg0_86.furniturePOV, "m_VerticalAxis", var2_87)
		end

		arg0_86.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_86.joystickTimer:Start()

	local var1_86 = 1.75

	arg0_86.moveStickTimer = FrameTimer.New(function()
		if not arg0_86.moveStickDraging then
			return
		end

		local var0_89 = arg0_86.moveStickPosition
		local var1_89 = 200
		local var2_89 = (var0_89 - arg0_86.moveStickOrigin):ClampMagnitude(var1_89)
		local var3_89 = var2_89 / var1_89

		arg0_86.moveStickPosition = arg0_86.moveStickOrigin + var2_89

		local var4_89 = Vector3.New(var3_89.x, 0, var3_89.y)
		local var5_89 = arg0_86.mainCameraTF:TransformDirection(var4_89)

		var5_89.y = 0

		local var6_89 = var5_89:Normalize()

		var6_89:Mul(var1_86)

		if isActive(arg0_86.cameras[var0_0.CAMERA.POV]) then
			arg0_86.playerController:SimpleMove(var6_89)

			arg0_86.tweenFOV = true
		elseif isActive(arg0_86.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_86.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_89 * Time.deltaTime)
			arg0_86:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_89:Normalize())
			onNextTick(function()
				local var0_90 = arg0_86.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_90 = arg0_86:GetRestritedHeightRange()
				local var2_90 = math.InverseLerp(var1_90[1], var1_90[2], var0_90.position.y)

				arg0_86:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var2_90)
			end)
		end
	end, 1, -1)

	arg0_86.moveStickTimer:Start()

	arg0_86.pinchMode = false
	arg0_86.pinchSize = 0
	arg0_86.pinchValue = 1
	arg0_86.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_91, arg1_91)
		if arg0_86.surroudCamera and isActive(arg0_86.surroudCamera) then
			arg0_86.pinchMode = true
			arg0_86.pinchSize = (arg0_91 - arg1_91):Magnitude()
			arg0_86.pinchNodeOrder = arg1_91.x < arg0_91.x and -1 or 1

			return
		end

		if isActive(arg0_86.cameras[var0_0.CAMERA.POV]) then
			if (arg0_91 - arg1_91):Magnitude() < Screen.height * 0.5 then
				arg0_86.pinchMode = true
				arg0_86.pinchSize = (arg0_91 - arg1_91):Magnitude()
				arg0_86.pinchNodeOrder = arg1_91.x < arg0_91.x and -1 or 1
			end

			return
		end
	end)

	local var2_86 = 0.01

	if IsUnityEditor then
		var2_86 = 0.1
	end

	local var3_86 = var2_86 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_92, arg1_92)
		if not arg0_86.pinchMode then
			return
		end

		local var0_92 = (arg0_92 - arg1_92):Magnitude()
		local var1_92 = arg0_86.pinchSize - var0_92
		local var2_92 = arg0_86.pinchNodeOrder * (arg1_92.x < arg0_92.x and -1 or 1)
		local var3_92 = var1_92 * var3_86 * var2_92

		if isActive(arg0_86.cameras[var0_0.CAMERA.POV]) then
			local var4_92 = 0.5
			local var5_92 = 1

			arg0_86.pinchValue = math.clamp(arg0_86.pinchValue + var3_92, var4_92, var5_92)
			arg0_86.pinchSize = var0_92

			arg0_86:SetPOVFOV(arg0_86.POVOriginalFOV * arg0_86.pinchValue)

			arg0_86.tweenFOV = nil

			return
		end

		if isActive(arg0_86.surroudCamera) and arg0_86.surroudCamera == arg0_86.cameras[var0_0.CAMERA.PHOTO] then
			local var6_92 = 0.5
			local var7_92 = 1

			arg0_86:SetPinchValue(math.clamp(arg0_86.pinchValue + var3_92, var6_92, var7_92))

			arg0_86.pinchSize = var0_92

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_86.pinchMode = false
		arg0_86.pinchSize = 0
	end)

	arg0_86.cameraBlendCallbacks = {}
	arg0_86.activeCMCamera = nil

	function arg0_86.camBrainEvenetHandler.OnBlendStarted(arg0_94)
		if arg0_86.activeCMCamera then
			arg0_86:OnCameraBlendFinished(arg0_86.activeCMCamera)
		end

		local var0_94 = arg0_86.camBrain.ActiveVirtualCamera

		arg0_86.activeCMCamera = var0_94
	end

	function arg0_86.camBrainEvenetHandler.OnBlendFinished(arg0_95)
		arg0_86.activeCMCamera = nil

		arg0_86:OnCameraBlendFinished(arg0_95)
	end

	arg0_86.expressionDict = {}

	arg0_86:OverlayPanel(arg0_86.blockLayer)
	arg0_86:ActiveCamera(arg0_86.cameras[var0_0.CAMERA.POV])

	local var4_86
	local var5_86
	local var6_86 = arg0_86.resumeCallback

	function arg0_86.resumeCallback()
		var5_86 = true

		if var4_86 then
			existCall(var6_86)
		end
	end

	arg0_86:RefreshSlots(nil, function()
		var4_86 = true
		arg0_86.doneFirstSlotFresh = true

		if var5_86 then
			existCall(var6_86)
		end
	end)

	arg0_86.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_86:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_86.updateHandler)
	arg0_86:InitExtraSystem()
end

function var0_0.InitExtraSystem(arg0_101, arg1_101)
	arg0_101.systemList = arg0_101.systemList or {}
	arg1_101 = arg1_101 or DormConst.SYSTEM_LIST

	for iter0_101, iter1_101 in ipairs(arg1_101) do
		switch(iter1_101, {
			[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = function()
				if not SlideExtraSystem.IsOpen(arg0_101.room) then
					return
				end

				if arg0_101.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] then
					return
				end

				arg0_101.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = SlideExtraSystem.New(arg0_101.event, arg0_101)

				arg0_101.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide]:Init()
			end
		})
	end
end

function var0_0.RemoveExtraSystem(arg0_103, arg1_103)
	arg1_103 = arg1_103 or DormConst.SYSTEM_LIST

	for iter0_103, iter1_103 in ipairs(arg1_103) do
		switch(iter1_103, {
			[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = function()
				if not arg0_103.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] then
					return
				end

				arg0_103.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide]:Dispose()

				arg0_103.systemList[DormConst.EXTRA_SYSTEMS.FurnitureSlide] = nil
			end
		})
	end
end

function var0_0.InitData(arg0_105)
	if not arg0_105.contextData.ladyZone then
		arg0_105.contextData.ladyZone = {}

		local var0_105
		local var1_105 = arg0_105.room:getConfig("default_zone")

		for iter0_105, iter1_105 in ipairs(var1_105) do
			arg0_105.contextData.ladyZone[iter1_105[1]] = iter1_105[2]

			if table.contains(arg0_105.contextData.groupIds, iter1_105[1]) then
				var0_105 = var0_105 or arg0_105.contextData.ladyZone[iter1_105[1]]
			end
		end

		arg0_105.contextData.inFurnitureName = var0_105 or var1_105[1][2]
	end

	arg0_105.zoneDatas = _.select(arg0_105.room:GetZones(), function(arg0_106)
		return not arg0_106:IsGlobal()
	end)
	arg0_105.activeLady = {}
end

function var0_0.Update(arg0_107)
	arg0_107.raycastCamera.fieldOfView = arg0_107.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_107.tweenFOV then
		local var0_107 = Damp(1, 1, Time.deltaTime)

		arg0_107.pinchValue = Mathf.Lerp(arg0_107.pinchValue, 1, var0_107)

		arg0_107:SetPOVFOV(arg0_107.POVOriginalFOV * arg0_107.pinchValue)

		if arg0_107.pinchValue > 0.99 then
			arg0_107.tweenFOV = nil
		end
	end

	if isActive(arg0_107.cameras[var0_0.CAMERA.POV]) then
		arg0_107:TriggerLadyDistance()
	end

	if arg0_107.contactInRangeDic then
		local var1_107 = arg0_107.transformFilter:Execute():ToTable()

		for iter0_107, iter1_107 in pairs(arg0_107.contactInRangeDic) do
			local var2_107 = pg.dorm3d_collection_template[iter0_107]
			local var3_107 = arg0_107.transRangeDic[iter0_107]
			local var4_107 = underscore(var1_107):chain():slice(unpack(var3_107)):any(function(arg0_108)
				return arg0_108
			end):value()

			if tobool(iter1_107) ~= var4_107 then
				arg0_107.contactInRangeDic[iter0_107] = var4_107

				arg0_107:UpdateContactDisplay(iter0_107, var4_107 and not arg0_107.hideConcatFlag and arg0_107.contactStateDic[iter0_107] or arg0_107.hideContactStateDic[iter0_107])
			end
		end
	end

	if arg0_107.enableFloatUpdate then
		arg0_107:UpdateFloatPosition()
	end

	arg0_107:CheckInSector()

	if arg0_107.apartment then
		(function(arg0_109)
			(function()
				if not arg0_109.ikHandler then
					return
				end

				local var0_110 = arg0_109.ikHandler.screenPosition
				local var1_110 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_110 = var0_110 - Vector2.New(var1_110.width, var1_110.height) * 0.5

				setAnchoredPosition(arg0_107:GetIKHandTF(), var2_110)

				if Time.time > arg0_107.ikNextCheckStamp then
					arg0_107.ikNextCheckStamp = arg0_107.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_110 = _.detect(arg0_109.readyIKLayers, function(arg0_111)
						return arg0_111:GetControllerPath() == arg0_109.ikHandler.ikData:GetControllerPath()
					end)

					arg0_107:emit(var0_0.ON_IK_STATUS_CHANGED, var3_110:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_107.enableIKTip then
				local var0_109 = not arg0_107.blockIK and Time.time > arg0_107.nextTipIKTime

				if var0_109 then
					local var1_109 = _.filter(arg0_109.readyIKLayers, function(arg0_112)
						return not arg0_112.ignoreDrag
					end)

					UIItemList.StaticAlign(arg0_107.ikTipsRoot, arg0_107.ikTipsRoot:GetChild(0), #var1_109, function(arg0_113, arg1_113, arg2_113)
						if arg0_113 ~= UIItemList.EventUpdate then
							return
						end

						arg1_113 = arg1_113 + 1

						local var0_113
						local var1_113 = Vector2.zero
						local var2_113 = var1_109[arg1_113]
						local var3_113 = var2_113:GetTriggerBoneName()
						local var4_113 = var3_113 and arg0_109.IKSettings.Colliders[var3_113] or nil
						local var5_113 = var2_113:GetIKTipOffset()

						if var4_113 then
							local function var6_113()
								local var0_114 = arg0_109.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var4_113.position)
								local var1_114 = CameraMgr.instance:Raycast(arg0_109.IKSettings.CameraRaycaster, var0_114)

								if var1_114.Length == 0 then
									return
								end

								return var4_113 == var1_114[0].gameObject.transform
							end
						end

						if var4_113 then
							local var7_113 = var4_113.position
							local var8_113 = var4_113:GetComponent(typeof(UnityEngine.Collider))

							if var8_113 then
								var7_113 = var8_113.bounds.center
							end

							local var9_113 = arg0_107:GetLocalPosition(arg0_107:GetScreenPosition(var7_113, arg0_109.IKSettings.CameraRaycaster.eventCamera), arg0_107.ikTipsRoot) + var5_113

							setLocalPosition(arg2_113, var9_113)

							local var10_113 = var2_113:GetTriggerRect()
							local var11_113 = var10_113:PointToNormalized(Vector2.zero)
							local var12_113 = Vector2.zero

							if var11_113.x < 0.5 and var11_113.y < 0.5 then
								var12_113 = var10_113.max
							elseif var11_113.x >= 0.5 and var11_113.y < 0.5 then
								var12_113 = Vector2.New(var10_113.xMin, var10_113.yMax)
							elseif var11_113.x < 0.5 and var11_113.y >= 0.5 then
								var12_113 = Vector2.New(var10_113.xMax, var10_113.yMin)
							elseif var11_113.x >= 0.5 and var11_113.y >= 0.5 then
								var12_113 = var10_113.min
							end

							if var11_113.x == 0.5 then
								if var9_113.x < 0 then
									var12_113.x = var10_113.xMax
								else
									var12_113.x = var10_113.xMin
								end
							end

							if var11_113.y == 0.5 then
								if var9_113.y < 0 then
									var12_113.y = var10_113.yMax
								else
									var12_113.y = var10_113.yMin
								end
							end

							local var13_113 = var12_113 - var10_113.center

							setLocalRotation(arg2_113, Quaternion.LookRotation(Vector3.forward, Vector3.New(var13_113.x, var13_113.y, 0)))
						end

						setActive(arg2_113, var4_113)
					end)
					UIItemList.StaticAlign(arg0_107.ikClickTipsRoot, arg0_107.ikClickTipsRoot:GetChild(0), #arg0_109.iKTouchDatas, function(arg0_115, arg1_115, arg2_115)
						if arg0_115 ~= UIItemList.EventUpdate then
							return
						end

						arg1_115 = arg1_115 + 1

						local var0_115
						local var1_115 = Vector2.zero
						local var2_115 = arg1_115
						local var3_115 = arg0_109.iKTouchDatas[var2_115][1]
						local var4_115 = pg.dorm3d_ik_touch[var3_115]

						if var4_115.tip_offset and var4_115.tip_offset ~= "" then
							var1_115 = Vector2.New(unpack(var4_115.tip_offset))
						end

						if #var4_115.scene_item > 0 then
							var0_115 = arg0_107:GetSceneItem(var4_115.scene_item)
						else
							var0_115 = arg0_109.IKSettings.Colliders[var4_115.body]
						end

						if var0_115 then
							local var5_115 = var0_115.position
							local var6_115 = var0_115:GetComponent(typeof(UnityEngine.Collider))

							if var6_115 then
								var5_115 = var6_115.bounds.center
							end

							setLocalPosition(arg2_115, arg0_107:GetLocalPosition(arg0_107:GetScreenPosition(var5_115, arg0_109.IKSettings.CameraRaycaster.eventCamera), arg0_107.ikClickTipsRoot) + var1_115)
						end

						setActive(arg2_115, var0_115)
					end)
				end

				setActive(arg0_107.ikTipsRoot, var0_109)
				setActive(arg0_107.ikClickTipsRoot, var0_109)
				setActive(arg0_107.ikTextTipsRoot, var0_109)
			end
		end)(arg0_107.ladyDict[arg0_107.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_116)
	if not isActive(arg0_116.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_116 = arg0_116.mainCameraTF.position

	for iter0_116, iter1_116 in pairs(arg0_116.ladyDict) do
		if iter1_116.lady then
			local var1_116 = tobool(arg0_116.activeLady[iter0_116])
			local var2_116 = {
				Radius = 2,
				Angle = 120,
				Position = iter1_116.lady.position,
				Rotation = iter1_116.lady.rotation
			}

			if var1_116 ~= tobool(var0_0.IsPointInSector(var2_116, var0_116)) then
				arg0_116.activeLady[iter0_116] = not var1_116

				arg0_116:emit(var0_0.ON_ENTER_SECTOR, iter0_116)
			end
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_117)
	for iter0_117, iter1_117 in pairs(arg0_117.ladyDict) do
		if iter1_117.lady then
			iter1_117.dis = (iter1_117.lady.position - arg0_117.player.position).magnitude

			if (arg0_117:GetBlackboardValue(iter1_117, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_117.dis ~= arg0_117:GetBlackboardValue(iter1_117, "inDistance") then
				arg0_117:SetBlackboardValue(iter1_117, "inDistance", iter1_117.dis < var0_0.POV_CLOSE_DISTANCE)
				arg0_117:emit(var0_0.ON_CHANGE_DISTANCE, iter0_117, iter1_117.dis < var0_0.POV_CLOSE_DISTANCE)
			end
		end
	end
end

function var0_0.OnStickMove(arg0_118, arg1_118)
	arg0_118.joystickDelta = arg1_118
end

function var0_0.SetPinchValue(arg0_119, arg1_119)
	arg0_119.pinchValue = arg1_119

	arg0_119:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_120)
	local var0_120 = arg0_120.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_120)
end

function var0_0.SetPOVFOV(arg0_121, arg1_121)
	local var0_121 = arg0_121.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_121, arg1_121)

	arg0_121.cameras[var0_0.CAMERA.POV].m_Lens = var0_121
end

function var0_0.RefreshSlots(arg0_122, arg1_122, arg2_122)
	arg1_122 = arg1_122 or arg0_122.room

	local var0_122 = arg1_122:GetSlots()
	local var1_122 = arg1_122:GetFurnitures()

	arg0_122:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_122, function(arg0_123, arg1_123, arg2_123)
		local var0_123 = arg1_123:GetConfigID()

		if not arg0_122.slotDict[var0_123] then
			return arg2_123()
		end

		local var1_123 = _.detect(var1_122, function(arg0_124)
			return arg0_124:GetSlotID() == var0_123
		end)
		local var2_123 = var1_123 and var1_123:GetModel() or false
		local var3_123 = arg0_122.slotDict[var0_123].model

		arg0_122.slotDict[var0_123].displayModelName = var2_123
		arg0_122.slotDict[var0_123].furnitureId = var1_123 and var1_123:GetConfigID()

		local function var4_123(arg0_125)
			if var3_123 then
				setActive(var3_123, var2_123 == "")
			end

			table.Foreach(arg0_122.slotDict[var0_123].sceneHides or {}, function(arg0_126, arg1_126)
				setActive(arg1_126.trans, arg1_126.visible)
			end)

			arg0_122.slotDict[var0_123].sceneHides = {}

			if arg0_125 then
				local var0_125 = arg0_125:getConfig("scene_hides")

				if #var0_125 > 0 then
					table.Ipairs(var0_125, function(arg0_127, arg1_127)
						local var0_127 = arg0_122.modelRoot:Find(arg1_127)

						assert(var0_127, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_125:GetConfigID(), arg1_127))

						local var1_127 = isActive(var0_127)

						table.insert(arg0_122.slotDict[var0_123].sceneHides, {
							name = arg1_127,
							trans = var0_127,
							visible = var1_127
						})
						setActive(var0_127, false)
					end)
				end
			end
		end

		if var2_123 == false or var2_123 == "" then
			arg0_122.loader:ClearRequest("slot_" .. var0_123)
			var4_123()
			arg2_123()

			return
		end

		local var5_123 = arg0_122.slotDict[var0_123].trans

		if arg0_122.loader:GetLoadingRP("slot_" .. var0_123) then
			arg0_122:emit(var0_0.HIDE_BLOCK)
		end

		arg0_122.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_123, "", function(arg0_128)
			assert(arg0_128)
			setParent(arg0_128, var5_123)
			var4_123(var1_123)
			arg2_123()
		end, "slot_" .. var0_123)
	end, function()
		arg0_122:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_122)
		warning("RefreshSlots", "Done")
		arg0_122:emit(Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE)
	end)
end

function var0_0.RefreshSlotsEmpty(arg0_130, arg1_130)
	local var0_130 = Clone(arg0_130.room)

	var0_130.furnitures = {}

	arg0_130:RefreshSlots(var0_130, arg1_130)
end

function var0_0.CheckSceneItemActiveByPath(arg0_131, arg1_131)
	local var0_131 = arg0_131:GetSceneItem(arg1_131)

	return arg0_131:CheckSceneItemActive(var0_131)
end

function var0_0.CheckSceneItemActive(arg0_132, arg1_132)
	local var0_132 = true
	local var1_132

	table.Checkout(arg0_132.slotDict, function(arg0_133, arg1_133)
		if underscore.detect(arg1_133.sceneHides, function(arg0_134)
			return arg0_134.trans == arg1_132
		end) then
			var0_132 = false
			var1_132 = arg1_133.furnitureId

			return false
		end
	end)

	return var0_132, var1_132
end

function var0_0.ChangeCharacterPosition(arg0_135, arg1_135)
	arg0_135:ResetCharPoint(arg1_135, arg1_135.ladyActiveZone)
	arg0_135:SyncInterestTransform(arg1_135)
end

function var0_0.SyncCurrentInterestTransform(arg0_136)
	local var0_136 = arg0_136.ladyDict[arg0_136.apartment:GetConfigID()]

	arg0_136:SyncInterestTransform(var0_136)
end

function var0_0.SyncInterestTransform(arg0_137, arg1_137)
	arg0_137.ladyInterest.position = arg1_137.ladyInterestRoot.position
	arg0_137.ladyInterest.rotation = arg1_137.ladyInterestRoot.rotation
end

function var0_0.SyncInterestTransformByTf(arg0_138, arg1_138)
	arg0_138.ladyInterest.position = arg1_138.position
	arg0_138.ladyInterest.rotation = arg1_138.rotation
end

function var0_0.ChangePlayerPosition(arg0_139, arg1_139)
	arg1_139 = arg1_139 or arg0_139.contextData.inFurnitureName

	local var0_139 = arg0_139.furnitures:Find(arg1_139):Find("PlayerPoint").position

	arg0_139.player.position = var0_139
	arg0_139.cameras[var0_0.CAMERA.POV].transform.position = arg0_139.playerEye.position

	local var1_139 = arg0_139.ladyInterest.position - arg0_139.playerEye.position
	local var2_139 = Quaternion.LookRotation(var1_139).eulerAngles
	local var3_139 = var2_139.y
	local var4_139 = var2_139.x
	local var5_139 = arg0_139.compPovAim.m_HorizontalAxis

	var5_139.Value = arg0_139:GetNearestAngle(var3_139, var5_139.m_MinValue, var5_139.m_MaxValue)
	arg0_139.compPovAim.m_HorizontalAxis = var5_139

	local var6_139 = arg0_139.compPovAim.m_VerticalAxis

	var6_139.Value = var4_139
	arg0_139.compPovAim.m_VerticalAxis = var6_139
end

function var0_0.GetAttachedFurnitureName(arg0_140)
	return arg0_140.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_141, arg1_141)
	return underscore.detect(arg0_141.attachedPoints, function(arg0_142)
		return arg0_142.name == arg1_141
	end)
end

function var0_0.GetSlotByID(arg0_143, arg1_143)
	return arg0_143.displaySlots[arg1_143] and arg0_143.displaySlots[arg1_143].trans
end

function var0_0.GetScreenPosition(arg0_144, arg1_144, arg2_144)
	arg2_144 = arg2_144 or arg0_144.raycastCamera

	local var0_144 = arg2_144:WorldToScreenPoint(arg1_144)

	if var0_144.z < 0 then
		var0_144.x = var0_144.x + (var0_144.x < 0 and -1 or 1) * Screen.width
		var0_144.y = var0_144.y + (var0_144.y < 0 and -1 or 1) * Screen.height
		var0_144.z = -var0_144.z
	end

	return var0_144
end

function var0_0.GetLocalPosition(arg0_145, arg1_145, arg2_145)
	return LuaHelper.ScreenToLocal(arg2_145, arg1_145, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_146)
	return arg0_146.modelRoot
end

function var0_0.ShiftZone(arg0_147, arg1_147, arg2_147)
	local var0_147 = arg0_147:GetFurnitureByName(arg1_147)

	if not var0_147 then
		errorMsg(arg1_147 .. " Not Find")
		existCall(arg2_147)

		return
	end

	seriesAsync({
		function(arg0_148)
			arg0_147:emit(var0_0.SHOW_BLOCK)
			arg0_147:ShowBlackScreen(true, arg0_148)
		end,
		function(arg0_149)
			if arg0_147.shiftLady or arg0_147.room:isPersonalRoom() then
				local var0_149 = arg0_147.shiftLady or arg0_147.apartment:GetConfigID()

				arg0_147.shiftLady = nil
				arg0_147.contextData.ladyZone[var0_149] = var0_147.name

				local var1_149 = arg0_147.ladyDict[var0_149]

				var1_149:SetZone(arg0_147.contextData.ladyZone[var0_149])

				if arg0_147:GetBlackboardValue(var1_149, "inPending") then
					arg0_147:SetOutPending(var1_149)
					arg0_147:SwitchAnim(var1_149, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_147:ChangeCharacterPosition(var1_149)
						arg0_149()
					end)
				else
					arg0_147:ChangeCharacterPosition(var1_149)
					arg0_149()
				end
			else
				arg0_149()
			end
		end,
		function(arg0_151)
			arg0_147.contextData.inFurnitureName = var0_147.name

			if SlideExtraSystem.IsOpen(arg0_147.room) and arg0_147.contextData.inFurnitureName == SlideConst.SLIDE_ZONE then
				arg0_147:SyncInterestTransformByTf(var0_147.transform:Find("StayPoint"))
			elseif not arg0_147.apartment then
				for iter0_151, iter1_151 in pairs(arg0_147.ladyDict) do
					if iter1_151.ladyBaseZone == arg0_147.contextData.inFurnitureName then
						arg0_147:SyncInterestTransform(iter1_151)

						break
					end
				end
			end

			arg0_147:ChangePlayerPosition()
			arg0_147:TriggerLadyDistance()
			arg0_147:CheckInSector()
			arg0_151()
		end,
		function(arg0_152)
			arg0_147:UpdateZoneList()
			arg0_147:ShowBlackScreen(false, arg0_152)
		end,
		function(arg0_153)
			arg0_147:emit(var0_0.HIDE_BLOCK)
			arg0_153()
		end
	}, arg2_147)
end

function var0_0.ActiveCamera(arg0_154, arg1_154)
	local var0_154 = isActive(arg1_154)

	table.Foreach(arg0_154.cameras, function(arg0_155, arg1_155)
		setActive(arg1_155, arg1_155 == arg1_154)
	end)

	if var0_154 then
		arg0_154:OnCameraBlendFinished(arg1_154)
	end
end

function var0_0.ActiveCameraByName(arg0_156, arg1_156)
	local var0_156 = arg0_156.cameraRoot:Find(arg1_156)

	assert(var0_156, "ActiveCameraByName: " .. arg1_156 .. " not found")
	table.Foreach(arg0_156.cameras, function(arg0_157, arg1_157)
		setActive(arg1_157, false)
	end)
	setActive(var0_156, true)

	arg0_156.cameras[var0_0.CAMERA.CUSTOM] = var0_156:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
end

function var0_0.ShowBlackScreen(arg0_158, arg1_158, arg2_158)
	local var0_158 = arg0_158.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_158 and 0 or 0.3
	}

	setImageColor(arg0_158.blackLayer, Color.NewHex(var0_158.color))
	setActive(arg0_158.blackLayer, true)
	setCanvasGroupAlpha(arg0_158.blackLayer, arg1_158 and 0 or 1)
	arg0_158:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_158 then
			setActive(arg0_158.blackLayer, false)
		end

		existCall(arg2_158)
	end, GetComponent(arg0_158.blackLayer, typeof(CanvasGroup)), arg1_158 and 1 or 0, var0_158.time):setDelay(var0_158.delay)
end

function var0_0.RegisterOrbits(arg0_160, arg1_160)
	arg0_160 = arg0_160.scene
	arg0_160.orbits = {
		original = arg1_160.m_Orbits
	}
	arg0_160.orbits.current = _.range(3):map(function(arg0_161)
		local var0_161 = arg0_160.orbits.original[arg0_161 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_161.m_Height, var0_161.m_Radius)
	end)
	arg0_160.surroudCamera = arg1_160
end

function var0_0.SetCameraObrits(arg0_162)
	arg0_162 = arg0_162.scene

	local var0_162 = arg0_162.surroudCamera

	if not var0_162 then
		return
	end

	local var1_162 = arg0_162.orbits.original[1]

	for iter0_162 = 0, #arg0_162.orbits.current - 1 do
		local var2_162 = arg0_162.orbits.current[iter0_162 + 1]
		local var3_162 = arg0_162.orbits.original[iter0_162]

		var2_162.m_Height = math.lerp(var1_162.m_Height, var3_162.m_Height, arg0_162.pinchValue)
		var2_162.m_Radius = var3_162.m_Radius * arg0_162.pinchValue
	end

	var0_162.m_Orbits = arg0_162.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_163)
	arg0_163 = arg0_163.scene

	local var0_163 = arg0_163.surroudCamera

	if not var0_163 then
		return
	end

	for iter0_163 = 0, #arg0_163.orbits.current - 1 do
		local var1_163 = arg0_163.orbits.current[iter0_163 + 1]
		local var2_163 = arg0_163.orbits.original[iter0_163]

		var1_163.m_Height = var2_163.m_Height
		var1_163.m_Radius = var2_163.m_Radius
	end

	var0_163.m_Orbits = arg0_163.orbits.current
	arg0_163.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_164, arg1_164, arg2_164)
	local var0_164 = {
		base = function(arg0_165)
			arg0_164:RegisterCameraBlendFinished(arg0_164.cameras[var0_0.CAMERA.POV], arg0_165)
			arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_166)
			assert(arg0_164.apartment)
			arg0_164:SyncInterestTransform(arg0_164.ladyDict[arg0_164.apartment:GetConfigID()])
			arg0_164:SetCameraLady(arg0_164.ladyDict[arg0_164.apartment:GetConfigID()])
			arg0_164:RegisterCameraBlendFinished(arg0_164.cameras[var0_0.CAMERA.ROLE], arg0_166)
			arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_167)
			arg0_164:RegisterCameraBlendFinished(arg0_164.cameras[var0_0.CAMERA.POV], arg0_167)
			arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_168)
			arg0_168()
		end,
		gift = function(arg0_169)
			assert(arg0_164.apartment)
			arg0_164:SetCameraLady(arg0_164.ladyDict[arg0_164.apartment:GetConfigID()])
			arg0_164:RegisterCameraBlendFinished(arg0_164.cameras[var0_0.CAMERA.GIFT], arg0_169)
			arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_170)
			assert(arg0_164.apartment)
			arg0_164:SetCameraLady(arg0_164.ladyDict[arg0_164.apartment:GetConfigID()])

			arg0_164.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_164.cameraRole.transform.position

			arg0_164:RegisterCameraBlendFinished(arg0_164.cameras[var0_0.CAMERA.ROLE2], arg0_170)
			arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_171)
			assert(arg0_164.apartment)
			arg0_164:SetCameraLady(arg0_164.ladyDict[arg0_164.apartment:GetConfigID()])
			arg0_164:SyncInterestTransform(arg0_164.ladyDict[arg0_164.apartment:GetConfigID()])
			arg0_164:RegisterCameraBlendFinished(arg0_164.cameras[var0_0.CAMERA.TALK], arg0_171)
			arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_164 = {}

	table.insert(var1_164, function(arg0_172)
		switch(arg1_164, var0_164, arg0_172, arg0_172)
	end)
	seriesAsync(var1_164, arg2_164)
end

function var0_0.GetSceneItem(arg0_173, arg1_173)
	local var0_173

	if string.find(arg1_173, "FurnitureSlots/") == 1 then
		arg1_173 = string.gsub(arg1_173, "^FurnitureSlots/", "", 1)
		var0_173 = arg0_173.slotRoot:Find(arg1_173)
	else
		var0_173 = arg0_173.modelRoot:Find(arg1_173)
	end

	if not var0_173 then
		warning(string.format("Missing scene item path: %s", arg1_173))
	end

	return var0_173
end

function var0_0.SetSceneAnimSpeed(arg0_174, arg1_174, arg2_174)
	table.Ipairs(arg1_174 or {}, function(arg0_175, arg1_175)
		if arg0_174.sceneAnimatorDict[arg1_175] then
			arg0_174.sceneAnimatorDict[arg1_175].animator.speed = arg2_174
		end
	end)
end

function var0_0.SetExtraAnimSpeed(arg0_176, arg1_176, arg2_176, arg3_176)
	table.Ipairs(arg2_176 or {}, function(arg0_177, arg1_177)
		local var0_177 = arg1_177[1]

		if arg1_176.extraItems[var0_177] then
			arg1_176.extraItems[var0_177].trans:GetComponent(typeof(Animator)).speed = arg3_176
		end
	end)
end

function var0_0.PlayEnterSceneAnim(arg0_178, arg1_178, arg2_178, arg3_178)
	arg3_178 = arg3_178 or 1

	local var0_178 = {}

	if arg1_178 and #arg1_178 > 0 then
		table.Ipairs(arg1_178, function(arg0_179, arg1_179)
			arg0_178:PlaySceneItemAnim(arg1_179[1], arg1_179[2], arg2_178)
			arg0_178:SetSceneAnimSpeed({
				arg1_179[1]
			}, arg3_178)
			table.insert(var0_178, arg1_179[1])
		end)
	end

	arg0_178:ResetSceneItemAnimators(var0_178)
end

function var0_0.PlayEnterExtraItem(arg0_180, arg1_180, arg2_180, arg3_180)
	arg3_180 = arg3_180 or 1

	local var0_180 = {}

	if arg2_180 and #arg2_180 > 0 then
		table.Ipairs(arg2_180, function(arg0_181, arg1_181)
			local var0_181 = arg1_181[3] and Vector3.New(unpack(arg1_181[3]))
			local var1_181 = arg1_181[4] and Quaternion.Euler(unpack(arg1_181[4]))
			local var2_181 = #arg1_181 > 4 and arg1_181[5] or nil

			arg0_180:LoadCharacterExtraItem(arg1_180, arg1_181[1], arg1_181[2], var0_181, var1_181, var2_181, arg3_180)
			table.insert(var0_180, arg1_181[1])
		end)
	end

	arg0_180:ResetCharacterExtraItem(arg1_180, var0_180)
end

function var0_0.SetIKStatus(arg0_182, arg1_182, arg2_182, arg3_182)
	warning("Set IKStatus " .. (arg2_182.id or "NIL"))

	arg0_182.enableIKTip = true

	arg0_182:ResetIKTipTimer()
	setActive(arg1_182.ladyCollider, false)
	_.each(arg1_182.ladyTouchColliders, function(arg0_183)
		setActive(arg0_183, true)
	end)

	arg0_182.blockIK = nil

	arg0_182:ClearIkTouchEvents(arg1_182)

	arg1_182.ikActionDict = {}
	arg1_182.readyIKLayers = {}
	arg1_182.iKTouchDatas = arg2_182.touch_data or {}
	arg1_182.IKSettings = {
		Colliders = arg1_182.ladyColliders,
		CameraRaycaster = arg0_182.sceneRaycaster
	}

	local var0_182 = table.shallowCopy(arg2_182.ik_id)
	local var1_182 = {}

	_.each(arg1_182.iKTouchDatas, function(arg0_184)
		local var0_184 = arg0_184[3]

		if var0_184[1] == 7 then
			local var1_184 = pg.dorm3d_ik_touch_move[var0_184[2]]
			local var2_184 = var1_184.target_ik

			if not _.detect(var0_182, function(arg0_185)
				return arg0_185[1] == var2_184
			end) then
				var1_182[var2_184] = {
					back_time = var1_184.back_time
				}

				local var3_184 = {
					var2_184,
					0,
					{}
				}

				if var1_184.trigger_dialogue > 0 then
					var3_184[3] = {
						4,
						0,
						var1_184.trigger_dialogue
					}
				end

				table.insert(var0_182, var3_184)
			end
		end
	end)

	local var2_182 = _.map(var0_182, function(arg0_186)
		local var0_186 = Dorm3dIK.New({
			configId = arg0_186[1]
		})
		local var1_186 = arg0_186[3]
		local var2_186 = var1_186[1]
		local var3_186 = switch(var2_186, {
			function(arg0_187, arg1_187)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_189, arg1_189)
				return arg0_189
			end,
			function(arg0_190, arg1_190)
				return arg0_190
			end,
			function(arg0_191, arg1_191, arg2_191, arg3_191)
				return arg0_191
			end,
			function(arg0_192)
				return 0
			end
		}, function(arg0_193)
			return type(arg0_193) == "number" and arg0_193 or 0
		end, unpack(var1_186, 2))

		table.insert(arg1_182.readyIKLayers, var0_186)

		arg1_182.ikActionDict[var0_186:GetControllerPath()] = var1_186

		local var4_186 = var0_186:GetRevertTime()
		local var5_186 = var1_182[var0_186:GetConfigID()]
		local var6_186 = tobool(var5_186)

		if var6_186 then
			var3_186 = var5_186.back_time
			var4_186 = var5_186.back_time
			var0_186.ignoreDrag = true
		end

		local var7_186 = var0_186:GetSubTargets()
		local var8_186 = var0_186:GetPlaneRotations()
		local var9_186 = var0_186:GetPlaneScales()
		local var10_186 = _.map(_.range(#var7_186), function(arg0_194)
			return {
				name = var7_186[arg0_194][1],
				planeRot = var8_186[arg0_194],
				planeScale = var9_186[arg0_194]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_186:getConfig("trigger_param")[2],
			controllerName = var0_186:GetControllerPath(),
			subTargets = var10_186,
			actionType = var0_186:GetActionTriggerParams()[1],
			controlRect = var0_186:GetRect(),
			actionRect = var0_186:GetTriggerRect(),
			backTime = var4_186,
			actionRevertTime = var3_186,
			ignoreDrag = var6_186
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_182.ladyIKRoot, arg1_182.ladyBoneMaps)
	arg0_182:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_182)

	local var3_182 = _.map(arg1_182.iKTouchDatas, function(arg0_195)
		return arg0_195[1]
	end)

	table.Foreach(var3_182, function(arg0_196, arg1_196)
		local var0_196 = pg.dorm3d_ik_touch[arg1_196]

		if #var0_196.scene_item == 0 then
			return
		end

		local var1_196 = arg0_182:GetSceneItem(var0_196.scene_item)

		if not var1_196 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_196, var0_196.scene_item))

			return
		end

		if IsNil(GetComponent(var1_196, typeof(UnityEngine.Collider))) then
			go(var1_196):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_196 = GetOrAddComponent(var1_196, typeof(EventTriggerListener))

		var2_196.enabled = true

		var2_196:AddPointClickFunc(function()
			arg0_182.blockIK = true

			local var0_197 = arg1_182.iKTouchDatas[arg0_196]
			local var1_197, var2_197, var3_197 = unpack(var0_197)

			arg0_182:TouchModeAction(arg1_182, var1_197, unpack(var3_197))(function()
				arg0_182.enableIKTip = true

				arg0_182:ResetIKTipTimer()

				arg0_182.blockIK = nil
			end)
		end)
	end)

	arg0_182.camBrain.enabled = false

	if arg0_182.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_182.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_182.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var4_182 = arg0_182.cameraRoot:Find(arg2_182.ik_camera)

	assert(var4_182, "Missing IKCamera")

	arg0_182.cameras[var0_0.CAMERA.IK_WATCH] = var4_182

	arg0_182:ActiveCamera(arg0_182.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_182.camBrain.enabled = true

	local var5_182 = var4_182:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_182 then
		arg0_182:RegisterOrbits(var5_182)
	else
		arg0_182:RevertCameraOrbit()
	end

	arg0_182:SwitchAnim(arg1_182, arg2_182.character_action)
	arg0_182:SettingHeadAimIK(arg1_182, arg2_182.head_track)
	arg1_182:EnableCloth(false)
	arg1_182:EnableCloth(arg2_182.use_cloth, arg2_182.cloth_colliders)
	arg0_182:PlayEnterSceneAnim(arg2_182.enter_scene_anim)
	arg0_182:PlayEnterExtraItem(arg1_182, arg2_182.enter_extra_item)
	;(function()
		local var0_199 = arg2_182.hide_scene_item

		if var0_199 and #var0_199 > 0 then
			arg1_182.tempHideSceneItems = {}

			table.Ipairs(var0_199, function(arg0_200, arg1_200)
				local var0_200 = arg0_182:GetSceneItem(arg1_200)

				setActive(var0_200, false)
				table.insert(arg1_182.tempHideSceneItems, arg1_200)
			end)
		end
	end)()
	eachChild(arg0_182.ikTextTipsRoot, function(arg0_201)
		setActive(arg0_201, false)
	end)
	_.each(arg1_182.readyIKLayers, function(arg0_202)
		local var0_202 = arg0_202:getConfig("tip_text")

		if not var0_202 or #var0_202 == 0 then
			return
		end

		local var1_202 = arg0_182.ikTextTipsRoot:Find(var0_202)

		if not IsNil(var1_202) then
			setActive(var1_202, true)
		end
	end)
	onNextTick(function()
		local var0_203 = arg0_182.furnitures:Find(arg2_182.character_position)

		arg1_182.lady.position = var0_203:Find("StayPoint").position
		arg1_182.lady.rotation = var0_203:Find("StayPoint").rotation

		existCall(arg3_182)
	end)
end

function var0_0.ExitIKStatus(arg0_204, arg1_204, arg2_204, arg3_204)
	arg0_204.enableIKTip = false

	setActive(arg1_204.ladyCollider, true)
	_.each(arg1_204.ladyTouchColliders, function(arg0_205)
		setActive(arg0_205, false)
	end)

	arg0_204.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()
	setActive(arg0_204.ikTipsRoot, false)
	setActive(arg0_204.ikClickTipsRoot, false)
	arg0_204:ClearIkTouchEvents(arg1_204)

	arg1_204.ikActionDict = nil
	arg1_204.readyIKLayers = nil
	arg1_204.iKTouchDatas = nil

	arg0_204:RevertCameraOrbit()
	setActive(arg0_204.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_204.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg1_204:EnableCloth(false)
	arg0_204:ResetHeadAimIK(arg1_204)
	arg0_204:SwitchAnim(arg1_204, arg2_204.character_action)
	arg0_204:ResetSceneItemAnimators()
	arg0_204:ResetCharacterExtraItem(arg1_204)
	;(function()
		if arg1_204.tempHideSceneItems and #arg1_204.tempHideSceneItems > 0 then
			table.Ipairs(arg1_204.tempHideSceneItems, function(arg0_207, arg1_207)
				local var0_207 = arg0_204:GetSceneItem(arg1_207)

				setActive(var0_207, true)
			end)

			arg1_204.tempHideSceneItems = nil
		end
	end)()
	onNextTick(function()
		if arg2_204.character_position then
			arg1_204.ladyActiveZone = arg2_204.character_position
		else
			arg1_204.ladyActiveZone = arg1_204.ladyBaseZone
		end

		arg0_204:ChangeCharacterPosition(arg1_204)
		arg0_204:TriggerLadyDistance()
		arg0_204:CheckInSector()
		existCall(arg3_204)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_209, arg1_209, arg2_209, arg3_209, arg4_209, arg5_209)
	warning("Set IKStatus " .. (arg3_209 or "NIL"))
	arg1_209:SetCurrentIkTimelineStatus(arg3_209)

	arg0_209.enableIKTip = true

	setActive(arg0_209.ikControlUI, true)
	arg0_209:ResetIKTipTimer()

	arg0_209.blockIK = nil

	local var0_209 = pg.dorm3d_ik_timeline_status[arg3_209]

	arg1_209.readyIKLayers = {}
	arg1_209.iKTouchDatas = {}
	arg1_209.IKSettings = {
		CameraRaycaster = GetOrAddComponent(arg4_209, typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_209.IKSettings.CameraRaycaster)

	local var1_209 = {}

	table.IpairsCArray(arg2_209:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_210, arg1_210)
		if arg1_210.name == "SafeCollider" then
			setActive(arg1_210, false)

			return
		end

		if arg1_210:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_210 = tf(arg1_210)
		local var1_210 = var0_210.name
		local var2_210 = var1_210 and string.find(var1_210, "Collider") or -1

		if var2_210 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var1_210)

			return
		end

		local var3_210 = string.sub(var1_210, 1, var2_210 - 1)

		if var3_210 == "Body" or var3_210 == "Safe" then
			setActive(var0_210, false)

			return
		end

		if DormConst.BONE_TO_TOUCH[var3_210] == nil then
			return
		end

		var1_209[var3_210] = var0_210

		setActive(var0_210, true)
	end)

	arg1_209.IKSettings.Colliders = var1_209

	local var2_209 = GetOrAddComponent(arg2_209, typeof(EventTriggerListener))

	arg1_209.ikTimelineMode = true

	local var3_209 = _.map(var0_209.ik_id, function(arg0_211)
		local var0_211 = Dorm3dIK.New({
			configId = arg0_211
		})

		table.insert(arg1_209.readyIKLayers, var0_211)

		local var1_211 = var0_211:GetSubTargets()
		local var2_211 = var0_211:GetPlaneRotations()
		local var3_211 = var0_211:GetPlaneScales()
		local var4_211 = _.map(_.range(#var1_211), function(arg0_212)
			return {
				name = var1_211[arg0_212][1],
				planeRot = var2_211[arg0_212],
				planeScale = var3_211[arg0_212]
			}
		end)

		return Dorm3dIKController.New({
			ignoreDrag = false,
			triggerName = var0_211:getConfig("trigger_param")[2],
			controllerName = var0_211:GetControllerPath(),
			subTargets = var4_211,
			actionType = var0_211:GetActionTriggerParams()[1],
			controlRect = var0_211:GetRect(),
			actionRect = var0_211:GetTriggerRect(),
			backTime = var0_211:GetRevertTime(),
			actionRevertTime = var0_211:GetActionRevertTime(),
			timelineActionEvent = var0_211:GetTimelineAction()
		})
	end)
	local var4_209 = arg2_209.transform:Find("IKLayers")
	local var5_209 = {}
	local var6_209 = {}

	table.Foreach(DormConst.boneMap, function(arg0_213, arg1_213)
		var6_209[arg1_213] = arg0_213
	end)

	local var7_209 = arg2_209.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var7_209, function(arg0_214, arg1_214)
		if var6_209[arg1_214.name] then
			var5_209[var6_209[arg1_214.name]] = arg1_214
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var4_209, var5_209)
	arg0_209:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var3_209)
	eachChild(arg0_209.ikTextTipsRoot, function(arg0_215)
		setActive(arg0_215, false)
	end)
	_.each(arg1_209.readyIKLayers, function(arg0_216)
		local var0_216 = arg0_216:getConfig("tip_text")

		if not var0_216 or #var0_216 == 0 then
			return
		end

		local var1_216 = arg0_209.ikTextTipsRoot:Find(var0_216)

		if not IsNil(var1_216) then
			setActive(var1_216, true)
		end
	end)
	existCall(arg5_209)
end

function var0_0.ExitIKTimelineStatus(arg0_217, arg1_217, arg2_217)
	arg1_217:SetCurrentIkTimelineStatus(nil)

	arg0_217.enableIKTip = false

	setActive(arg0_217.ikControlUI, false)

	arg0_217.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_217.readyIKLayers = nil
	arg1_217.iKTouchDatas = nil
	arg1_217.IKSettings = nil

	setActive(arg0_217.ikTipsRoot, false)
	setActive(arg0_217.ikClickTipsRoot, false)
	existCall(arg2_217)
end

function var0_0.ClearIkTouchEvents(arg0_218, arg1_218)
	local var0_218 = _.map(arg1_218.iKTouchDatas or {}, function(arg0_219)
		return arg0_219[1]
	end)

	table.Foreach(var0_218, function(arg0_220, arg1_220)
		local var0_220 = pg.dorm3d_ik_touch[arg1_220]

		if #var0_220.scene_item == 0 then
			return
		end

		local var1_220 = arg0_218:GetSceneItem(var0_220.scene_item)

		if not var1_220 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_220, var0_220.scene_item))

			return
		end

		local var2_220 = GetOrAddComponent(var1_220, typeof(EventTriggerListener))

		var2_220:ClearEvents()

		var2_220.enabled = false
	end)
end

function var0_0.EnableIKLayer(arg0_221, arg1_221)
	local var0_221 = arg0_221.ladyDict[arg0_221.apartment:GetConfigID()]

	if #arg1_221:GetHeadTrackPath() > 0 then
		arg0_221:SettingHeadAimIK(var0_221, {
			2,
			arg1_221:GetHeadTrackPath()
		}, true)
	end

	local var1_221 = arg1_221:GetTriggerFaceAnim()

	if #var1_221 > 0 then
		arg0_221:PlayFaceAnim(var0_221, var1_221)
	end

	if not arg1_221.ignoreDrag then
		setActive(arg0_221:GetIKHandTF(), true)
		eachChild(arg0_221:GetIKHandTF(), function(arg0_222)
			setActive(arg0_222, false)
		end)
		arg0_221:StopIKHandTimer()
		setActive(arg0_221:GetIKHandTF():Find("Begin"), true)

		arg0_221.ikHandTimer = Timer.New(function()
			setActive(arg0_221:GetIKHandTF():Find("Begin"), false)
			setActive(arg0_221:GetIKHandTF():Find("Normal"), true)
		end, 0.5, 1)

		arg0_221.ikHandTimer:Start()
	end

	if not var0_221.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_221.apartment.configId, arg0_221.apartment.level, var0_221.ikConfig.character_action, arg1_221:GetTriggerParams()[2], arg0_221.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_224, arg1_224)
	local var0_224 = arg0_224.ladyDict[arg0_224.apartment:GetConfigID()]

	if not var0_224.ikTimelineMode and #arg1_224:GetHeadTrackPath() > 0 then
		arg0_224:SettingHeadAimIK(var0_224, var0_224.ikConfig.head_track)
	end

	arg0_224:StopIKHandTimer()

	if not arg1_224.ignoreDrag then
		setActive(arg0_224:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_224:GetIKHandTF():Find("Normal"), false)
		setActive(arg0_224:GetIKHandTF():Find("End"), true)

		arg0_224.ikHandTimer = Timer.New(function()
			setActive(arg0_224:GetIKHandTF():Find("End"), false)
			setActive(arg0_224:GetIKHandTF(), false)
		end, 0.5, 1)

		arg0_224.ikHandTimer:Start()
	end
end

function var0_0.StopIKHandTimer(arg0_226)
	if not arg0_226.ikHandTimer then
		return
	end

	arg0_226.ikHandTimer:Stop()

	arg0_226.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_227, arg1_227, arg2_227, arg3_227)
	local var0_227 = Time.time

	function arg0_227.ikRevertHandler()
		local var0_228 = Time.time - var0_227

		_.each(arg1_227.activeIKLayers, function(arg0_229)
			local var0_229 = 1

			if arg2_227 > 0 then
				var0_229 = var0_228 / arg2_227
			end

			local var1_229 = arg1_227.cacheIKInfos[arg0_229].solvers
			local var2_229 = arg1_227.cacheIKInfos[arg0_229].weights

			table.Foreach(var1_229, function(arg0_230, arg1_230)
				arg1_230.IKPositionWeight = math.lerp(var2_229[arg0_230], 0, var0_229)
			end)
		end)

		if var0_228 >= arg2_227 then
			arg0_227:ResetActiveIKs(arg1_227)

			arg0_227.ikRevertHandler = nil

			existCall(arg3_227)
		end
	end

	arg0_227.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_231, arg1_231)
	table.insertto(arg0_231.activeIKLayers, _.keys(arg0_231.holdingStatus))
	table.clear(arg0_231.holdingStatus)
	_.each(arg1_231.activeIKLayers, function(arg0_232)
		local var0_232 = arg0_232:GetControllerPath()
		local var1_232 = arg1_231.ladyIKRoot:Find(var0_232):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_232, false)

		local var2_232 = arg1_231.cacheIKInfos[arg0_232].solvers
		local var3_232 = arg1_231.cacheIKInfos[arg0_232].weights

		table.Foreach(var2_232, function(arg0_233, arg1_233)
			arg1_233.IKPositionWeight = var3_232[arg0_233]
		end)
	end)
	table.clear(arg1_231.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_234)
	if not arg0_234.enableIKTip then
		return
	end

	arg0_234.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_235, arg1_235)
	local var0_235 = arg0_235.ladyDict[arg0_235.apartment:GetConfigID()]

	arg0_235:EnableHeadIK(var0_235, arg1_235)
end

function var0_0.EnableHeadIK(arg0_236, arg1_236, arg2_236)
	arg1_236.ladyHeadIKComp.enableIk = arg2_236
end

function var0_0.SettingHeadAimIK(arg0_237, arg1_237, arg2_237, arg3_237)
	local var0_237

	if arg2_237[1] == 0 then
		arg0_237:EnableHeadIK(arg1_237, false)

		return
	elseif arg2_237[1] == 1 then
		arg0_237:EnableHeadIK(arg1_237, true)

		var0_237 = arg0_237.mainCameraTF:Find("AimTarget")
	elseif arg2_237[1] == 2 then
		arg0_237:EnableHeadIK(arg1_237, true)
		table.IpairsCArray(arg1_237.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_238, arg1_238)
			if arg1_238.name ~= arg2_237[2] then
				return
			end

			var0_237 = arg1_238
		end)
	end

	arg1_237.ladyHeadIKComp.AimTarget = var0_237

	if not arg3_237 and arg2_237[3] then
		arg1_237.ladyHeadIKComp.BodyWeight = arg2_237[3]
	end

	if not arg3_237 and arg2_237[4] then
		arg1_237.ladyHeadIKComp.HeadWeight = arg2_237[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_239, arg1_239)
	arg0_239:EnableHeadIK(arg1_239, true)

	arg1_239.ladyHeadIKComp.AimTarget = arg0_239.mainCameraTF:Find("AimTarget")
	arg1_239.ladyHeadIKComp.HeadWeight = arg1_239.ladyHeadIKData.HeadWeight
	arg1_239.ladyHeadIKComp.BodyWeight = arg1_239.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_240, arg1_240)
	for iter0_240, iter1_240 in pairs(arg0_240.ladyDict) do
		if iter0_240 ~= arg1_240 then
			arg0_240:HideCharacterBylayer(iter1_240)
		end
	end
end

function var0_0.RevertCharacter(arg0_241, arg1_241)
	for iter0_241, iter1_241 in pairs(arg0_241.ladyDict) do
		if iter0_241 ~= arg1_241 then
			arg0_241:RevertCharacterBylayer(iter1_241)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_242, arg1_242)
	local var0_242 = "Bip001"
	local var1_242 = arg1_242.lady:Find("all")

	for iter0_242 = 0, var1_242.childCount - 1 do
		local var2_242 = var1_242:GetChild(iter0_242)

		if var2_242.name ~= var0_242 then
			pg.ViewUtils.SetLayer(var2_242, Layer.Environment3D)
		end
	end

	if arg1_242.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_242.tfPendintItem, Layer.Environment3D)
	end

	if arg1_242.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_242.ladyWatchFloat, Layer.Environment3D)
	end
end

function var0_0.RevertCharacterBylayer(arg0_243, arg1_243)
	local var0_243 = "Bip001"
	local var1_243 = arg1_243.lady:Find("all")

	for iter0_243 = 0, var1_243.childCount - 1 do
		local var2_243 = var1_243:GetChild(iter0_243)

		if var2_243.name ~= var0_243 then
			pg.ViewUtils.SetLayer(var2_243, Layer.Character3D)
		end
	end

	if arg1_243.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_243.tfPendintItem, Layer.Default)
	end

	if arg1_243.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_243.ladyWatchFloat, Layer.Default)
	end
end

function var0_0.EnterFurnitureWatchMode(arg0_244)
	arg0_244:SetAllBlackbloardValue("inLockLayer", true)
	arg0_244:EnableJoystick(true)
	arg0_244:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_245, arg1_245)
	arg0_245:HideFurnitureSlots()

	local var0_245 = arg0_245.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_246)
			arg0_245.furniturePOV = nil

			arg0_245:EnableJoystick(false)
			arg0_245:emit(var0_0.SHOW_BLOCK)
			arg0_245:ShowBlackScreen(true, arg0_246)
		end,
		function(arg0_247)
			existCall(arg1_245)
			arg0_245:RevertCharacter()
			arg0_245:SetAllBlackbloardValue("inLockLayer", false)
			arg0_245:RegisterCameraBlendFinished(var0_245, arg0_247)
			arg0_245:ActiveCamera(var0_245)
		end,
		function(arg0_248)
			arg0_245:ShowBlackScreen(false, arg0_248)
		end
	}, function()
		arg0_245:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_245:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_250, arg1_250)
	local var0_250 = arg0_250:GetFurnitureByName(arg1_250:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_250.cameraFurnitureWatch and arg0_250.cameraFurnitureWatch ~= var0_250 then
		arg0_250:UnRegisterCameraBlendFinished(arg0_250.cameraFurnitureWatch)
		setActive(arg0_250.cameraFurnitureWatch, false)
	end

	arg0_250.cameraFurnitureWatch = var0_250
	arg0_250.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_250.cameraFurnitureWatch
	arg0_250.furniturePOV = arg0_250.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_250:RegisterCameraBlendFinished(arg0_250.cameraFurnitureWatch, function()
		arg0_250:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_250:emit(var0_0.SHOW_BLOCK)
	arg0_250:ActiveCamera(arg0_250.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_252)
	if arg0_252.displaySlots then
		arg0_252:UpdateDisplaySlots({})
		table.Foreach(arg0_252.displaySlots, function(arg0_253, arg1_253)
			local var0_253 = arg1_253.trans

			if IsNil(var0_253:Find("Selector")) then
				return
			end

			setActive(var0_253:Find("Selector"), false)
		end)

		arg0_252.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_254, arg1_254)
	arg0_254:HideFurnitureSlots()

	arg0_254.displaySlots = {}

	_.each(arg1_254, function(arg0_255)
		arg0_254.displaySlots[arg0_255] = arg0_254.slotDict[arg0_255]

		if not arg0_254.displaySlots[arg0_255] then
			errorMsg("Slot " .. arg0_255 .. " Not Binding Scene Object")

			return
		end

		local var0_255 = arg0_254.displaySlots[arg0_255].trans

		if var0_255:Find("Selector") then
			setActive(var0_255:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_256, arg1_256)
	table.Foreach(arg0_256.displaySlots, function(arg0_257, arg1_257)
		local var0_257 = arg1_257.trans

		if not IsNil(var0_257:Find("Selector")) then
			setActive(var0_257:Find("Selector/Normal"), arg1_256[arg0_257] == 0)
			setActive(var0_257:Find("Selector/Active"), arg1_256[arg0_257] == 1)
			setActive(var0_257:Find("Selector/Ban"), arg1_256[arg0_257] == 2)
		end

		local var1_257 = arg0_256.slotDict[arg0_257].model
		local var2_257 = arg0_256.slotDict[arg0_257].displayModelName

		if var2_257 and var2_257 ~= "" then
			var1_257 = var0_257:GetChild(var0_257.childCount - 1)
		end

		local function var3_257(arg0_258, arg1_258)
			local var0_258 = arg0_258:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_258, function(arg0_259, arg1_259)
				local var0_259 = arg1_259.material

				if var0_259 and var0_259:HasProperty("_FinalTint") then
					var0_259:SetColor("_FinalTint", arg1_258)
				end
			end)
		end

		if var1_257 then
			if arg1_256[arg0_257] == 1 then
				var3_257(var1_257, Color.NewHex("3F83AE73"))
			else
				var3_257(var1_257, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_260, arg1_260, arg2_260)
	arg0_260:SetAllBlackbloardValue("inLockLayer", true)
	arg0_260:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_261)
			arg0_260:TempHideUI(true, arg0_261)
		end,
		function(arg0_262)
			arg0_260:ShowBlackScreen(true, arg0_262)
		end,
		function(arg0_263)
			local var0_263 = arg0_260.apartment:GetConfigID()
			local var1_263 = arg0_260.ladyDict[var0_263]

			arg0_260:SwitchAnim(var1_263, arg2_260)
			var1_263.ladyAnimator:Update(0)
			arg0_260:ResetCharPoint(var1_263, arg1_260:GetWatchCameraName())
			arg0_260:SyncInterestTransform(var1_263)
			setActive(var1_263.ladySafeCollider, true)
			arg0_260:HideCharacter(var0_263)

			local var2_263 = arg0_260.cameras[var0_0.CAMERA.PHOTO]
			local var3_263 = var2_263.m_XAxis

			var3_263.Value = 180
			var2_263.m_XAxis = var3_263

			local var4_263 = var2_263.m_YAxis

			var4_263.Value = 0.7
			var2_263.m_YAxis = var4_263
			arg0_260.pinchValue = 1

			arg0_260:RegisterOrbits(arg0_260.cameras[var0_0.CAMERA.PHOTO])
			arg0_260:SetCameraObrits()
			setActive(arg0_260.restrictedBox, true)
			arg0_260:RegisterCameraBlendFinished(var2_263, arg0_263)
			arg0_260:ActiveCamera(var2_263)
		end,
		function(arg0_264)
			arg0_260:ShowBlackScreen(false, arg0_264)
		end
	}, function()
		arg0_260:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_266)
	arg0_266:emit(var0_0.SHOW_BLOCK)
	arg0_266:EnableJoystick(false)
	seriesAsync({
		function(arg0_267)
			arg0_266:ShowBlackScreen(true, arg0_267)
		end,
		function(arg0_268)
			arg0_266:RevertCameraOrbit()

			local var0_268 = arg0_266.ladyDict[arg0_266.apartment:GetConfigID()]

			arg0_266:SwitchAnim(var0_268, var0_0.ANIM.IDLE)
			setActive(var0_268.ladySafeCollider, false)
			onNextTick(function()
				arg0_266:ChangeCharacterPosition(var0_268)
			end)

			if arg0_266.contextData.photoFreeMode then
				arg0_266:EnablePOVLayer(false)

				arg0_266.contextData.photoFreeMode = nil
			end

			setActive(arg0_266.restrictedBox, false)

			local var1_268 = arg0_266.cameras[var0_0.CAMERA.POV]

			arg0_266:RegisterCameraBlendFinished(var1_268, arg0_268)
			arg0_266:ActiveCamera(var1_268)
		end,
		function(arg0_270)
			arg0_266:RevertCharacter(arg0_266.apartment:GetConfigID())
			arg0_266:ShowBlackScreen(false, arg0_270)
		end
	}, function()
		arg0_266:RefreshSlots()
		arg0_266:SetAllBlackbloardValue("inLockLayer", false)
		arg0_266:emit(var0_0.HIDE_BLOCK)
		arg0_266:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_266:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_272, arg1_272, arg2_272, arg3_272)
	arg0_272:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_273)
			arg0_272:ShowBlackScreen(true, arg0_273)
		end,
		function(arg0_274)
			local var0_274 = arg0_272.ladyDict[arg0_272.apartment:GetConfigID()]

			arg0_272:SwitchAnim(var0_274, arg2_272)
			onNextTick(function()
				arg0_272:ResetCharPoint(var0_274, arg1_272:GetWatchCameraName())
				arg0_272:SyncInterestTransform(var0_274)

				if arg0_272.contextData.photoFreeMode then
					arg0_272.camBrain.enabled = false

					arg0_272:SwitchPhotoCamera()

					arg0_272.camBrain.enabled = true

					onDelayTick(function()
						arg0_272.camBrain.enabled = false

						arg0_272:SwitchPhotoCamera()

						arg0_272.camBrain.enabled = true
					end, 0.1)
				end

				arg0_274()
			end)
		end,
		function(arg0_277)
			arg0_272:ShowBlackScreen(false, arg0_277)
		end
	}, function()
		arg0_272:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_272)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_279)
	if not arg0_279.contextData.photoFreeMode then
		arg0_279:EnableJoystick(false)
		arg0_279:EnablePOVLayer(true)

		local var0_279 = arg0_279.cameras[var0_0.CAMERA.PHOTO_FREE]
		local var1_279 = arg0_279.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_279 = arg0_279.mainCameraTF.rotation:ToEulerAngles()
		local var3_279 = var1_279.m_HorizontalAxis

		var3_279.Value = var2_279.y
		var1_279.m_HorizontalAxis = var3_279

		local var4_279 = var1_279.m_VerticalAxis

		var4_279.Value = arg0_279:GetNearestAngle(var2_279.x, var4_279.m_MinValue, var4_279.m_MaxValue)
		var1_279.m_VerticalAxis = var4_279

		local var5_279 = arg0_279.mainCameraTF.position
		local var6_279 = arg0_279:GetRestritedHeightRange()
		local var7_279 = math.InverseLerp(var6_279[1], var6_279[2], var5_279.y)

		var5_279.y = math.clamp(var5_279.y, var6_279[1], var6_279[2])
		var0_279.transform.position = var5_279

		arg0_279:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var7_279)
		arg0_279:ActiveCamera(arg0_279.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_279:EnableJoystick(true)
		arg0_279:EnablePOVLayer(false)
		arg0_279:ActiveCamera(arg0_279.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_279.contextData.photoFreeMode = not arg0_279.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_280, arg1_280)
	local var0_280 = arg0_280.cameras[var0_0.CAMERA.PHOTO_FREE]
	local var1_280 = arg0_280:GetRestritedHeightRange()
	local var2_280 = math.lerp(var1_280[1], var1_280[2], arg1_280)

	var0_280:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var2_280 - var0_280.position.y, 0))
	onNextTick(function()
		local var0_281 = arg0_280:GetRestritedHeightRange()
		local var1_281 = math.InverseLerp(var0_281[1], var0_281[2], var0_280.position.y)

		arg0_280:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_281)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_282)
	local var0_282 = arg0_282.cameras[var0_0.CAMERA.PHOTO]
	local var1_282 = var0_282.m_XAxis

	var1_282.Value = 180
	var0_282.m_XAxis = var1_282

	local var2_282 = var0_282.m_YAxis

	var2_282.Value = 0.7
	var0_282.m_YAxis = var2_282
end

function var0_0.ResetCurrentCharPoint(arg0_283, arg1_283)
	local var0_283 = arg0_283.ladyDict[arg0_283.apartment:GetConfigID()]

	arg0_283:ResetCharPoint(var0_283, arg1_283)
end

function var0_0.ResetCharPoint(arg0_284, arg1_284, arg2_284)
	local var0_284 = arg0_284.furnitures:Find(arg2_284 .. "/StayPoint")

	arg1_284.lady.position = var0_284.position
	arg1_284.lady.rotation = var0_284.rotation
end

function var0_0.GetNearestAngle(arg0_285, arg1_285, arg2_285, arg3_285)
	if arg3_285 < arg2_285 then
		arg3_285 = arg3_285 + 360
	end

	if arg2_285 <= arg1_285 and arg1_285 <= arg3_285 then
		return arg1_285
	end

	local var0_285 = (arg2_285 + arg3_285) / 2

	arg1_285 = var0_285 - Mathf.DeltaAngle(arg1_285, var0_285)
	arg1_285 = math.clamp(arg1_285, arg2_285, arg3_285)

	return arg1_285
end

function var0_0.PlayTimeline(arg0_286, arg1_286, arg2_286)
	local var0_286 = {}

	if arg0_286.waitForTimeline then
		table.insert(var0_286, function(arg0_287)
			local var0_287 = arg0_286.waitForTimeline

			arg0_286.waitForTimeline = nil

			var0_287()
			arg0_287()
		end)
	end

	table.insert(var0_286, function(arg0_288)
		arg0_286:LoadTimelineScene(arg1_286.name, false, nil, arg0_288)
	end)

	if arg1_286.scene and arg1_286.sceneRoot then
		table.insert(var0_286, function(arg0_289)
			arg0_286:ChangeArtScene(arg1_286.scene .. "|" .. arg1_286.sceneRoot, arg0_289)
		end)
	end

	table.insert(var0_286, function(arg0_290)
		local var0_290 = GameObject.Find("[actor]").transform
		local var1_290 = var0_290:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_290, function(arg0_291, arg1_291)
			GetOrAddComponent(arg1_291.transform, typeof(DftAniEvent))
		end)

		local var2_290 = var0_290:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_290

		eachChild(GameObject.Find("[camera]").transform, function(arg0_292)
			if arg0_292.tag == "MainCamera" then
				var3_290 = arg0_292
			end
		end)
		assert(var3_290, "Missing MainCamera")

		local var4_290 = GameObject.Find("[sequence]").transform

		arg0_286.nowTimelinePlayer = TimelinePlayer.New(var4_290)

		TimelineSupport.InitSubtitle(arg0_286.nowTimelinePlayer.comDirector, arg0_286.apartment:GetCallName())
		arg0_286.nowTimelinePlayer:Register(arg1_286.time, function(arg0_293, arg1_293, arg2_293)
			switch(arg1_293.stringParameter, {
				TimelinePause = function()
					arg0_293:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_293:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_293.intParameter == 0 or arg1_293.intParameter == arg2_293.selectIndex then
						arg0_293:SetTime(arg1_293.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_293.selectIndex = nil

					if arg1_286.options then
						local var0_297 = arg1_286.options[arg1_293.intParameter]

						arg0_286:DoTimelineOption(var0_297, function(arg0_298)
							arg2_293.selectIndex = arg0_298
							arg2_293.optionIndex = var0_297[arg0_298].flag

							arg0_293:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_293.selectIndex = nil

					if arg1_286.touchs then
						local var0_299 = arg1_286.touchs[arg1_293.intParameter]

						arg0_286:DoTimelineTouch(arg1_286.touchs[arg1_293.intParameter], function(arg0_300)
							arg2_293.selectIndex = arg0_300
							arg2_293.optionIndex = var0_299[arg0_300].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_293.selectIndex then
						arg0_293:RawSetTime(arg1_293.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_293.selectIndex = arg1_293.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_286.canTriggerAccompanyPerformance then
						arg0_286.canTriggerAccompanyPerformance = false

						local var0_303 = arg1_286.accompanys[arg1_293.intParameter]
						local var1_303 = var0_303[math.random(#var0_303)]

						arg0_293:SetTime(var1_303)
					end
				end,
				TimelineIKStart = function()
					arg2_293.selectIndex = nil

					local var0_304 = arg1_293.intParameter
					local var1_304 = arg0_286.ladyDict[arg0_286.apartment:GetConfigID()]

					if var1_304:CheckIkTimelineStatus(var0_304) then
						arg0_286:SetIKTimelineStatus(var1_304, var2_290.gameObject, var0_304, var3_290)
					end
				end,
				TimelineEnd = function()
					arg2_293.finish = true

					arg0_293:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_293.stringParameter)
			end)

			if arg2_293.finish then
				arg0_286.timelineMark = arg2_293
				arg0_286.timelineFinishCall = nil

				local var0_293 = arg0_286.ladyDict[arg0_286.apartment:GetConfigID()]

				if var0_293.ikTimelineMode then
					arg0_286:ExitIKTimelineStatus(var0_293)
				end

				arg0_290()
			end
		end)

		function arg0_286.timelineFinishCall()
			arg0_286.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_286:HideCharacter()
		setActive(arg0_286.mainCameraTF, false)
		setActive(var3_290, true)
		eachChild(arg0_286.rtTimelineScreen, function(arg0_308)
			setActive(arg0_308, false)
		end)
		setActive(arg0_286.rtTimelineScreen, true)
		setActive(arg0_286.rtTimelineScreen:Find("btn_skip"), arg0_286.inReplayTalk)
		arg0_286.nowTimelinePlayer:Start()
	end)
	table.insert(var0_286, function(arg0_309)
		arg0_286:ShowBlackScreen(true, function()
			arg0_286.nowTimelinePlayer:Stop()
			arg0_286.nowTimelinePlayer:Dispose()

			arg0_286.nowTimelinePlayer = nil

			arg0_286:UnloadTimelineScene(arg1_286.name, false, arg0_309)
		end)
	end)

	local var1_286 = arg0_286.dormSceneMgr.artSceneInfo

	table.insert(var0_286, function(arg0_311)
		arg0_286:RevertArtScene(var1_286, arg0_311)
	end)
	seriesAsync(var0_286, function()
		setActive(arg0_286.rtTimelineScreen, false)
		arg0_286:RevertCharacter()
		setActive(arg0_286.mainCameraTF, true)

		local var0_312 = arg0_286.timelineMark

		arg0_286.timelineMark = nil

		existCall(arg2_286, var0_312, function(arg0_313)
			arg0_286:ShowBlackScreen(false, arg0_313)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_314, ...)
	local var0_314 = arg0_314.ladyDict[arg0_314.apartment:GetConfigID()]

	return arg0_314:PlaySingleAction(var0_314, ...)
end

function var0_0.PlaySingleAction(arg0_315, arg1_315, arg2_315, arg3_315, arg4_315)
	arg1_315:PlaySingleAction(arg2_315, arg3_315, arg4_315)
end

function var0_0.SwitchCurrentAnim(arg0_316, ...)
	local var0_316 = arg0_316.ladyDict[arg0_316.apartment:GetConfigID()]

	return arg0_316:SwitchAnim(var0_316, ...)
end

function var0_0.SwitchAnim(arg0_317, arg1_317, arg2_317, arg3_317)
	arg1_317:SwitchAnim(arg2_317, arg3_317)
end

function var0_0.PlayFaceAnim(arg0_318, arg1_318, arg2_318, arg3_318)
	arg1_318:PlayFaceAnim(arg2_318, arg3_318)
end

function var0_0.RegisterAnimCallback(arg0_319, arg1_319, arg2_319)
	arg0_319.ladyDict[arg0_319.apartment:GetConfigID()].animCallbacks[arg1_319] = arg2_319
end

function var0_0.SetCharacterAnimSpeed(arg0_320, arg1_320)
	local var0_320 = arg0_320.ladyDict[arg0_320.apartment:GetConfigID()]

	var0_320.ladyAnimator.speed = arg1_320
	var0_320.ladyHeadIKComp.blinkSpeed = var0_320.ladyHeadIKData.blinkSpeed * arg1_320

	if arg1_320 > 0 then
		var0_320.ladyHeadIKComp.DampTime = var0_320.ladyHeadIKData.DampTime / arg1_320
	else
		var0_320.ladyHeadIKComp.DampTime = var0_320.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_321, arg1_321)
	if arg1_321.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_321 = arg1_321.stringParameter
	local var1_321 = table.removebykey(arg0_321.animEventCallbacks, var0_321)

	existCall(var1_321)
end

function var0_0.RegisterAnimEventCallback(arg0_322, arg1_322, arg2_322)
	arg0_322.animEventCallbacks[arg1_322] = arg2_322
end

function var0_0.PlaySceneItemAnim(arg0_323, arg1_323, arg2_323, arg3_323)
	arg0_323.sceneAnimatorDict = arg0_323.sceneAnimatorDict or {}

	if not arg0_323.sceneAnimatorDict[arg1_323] then
		local var0_323 = pg.dorm3d_scene_animator[arg1_323]
		local var1_323 = arg0_323:GetSceneItem(var0_323.item_name)

		assert(var1_323, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_323 .. " " .. var0_323.item_name)

		if not var1_323 then
			return
		end

		local var2_323 = var1_323:GetComponent(typeof(Animator))

		if not var2_323 then
			return
		end

		arg0_323.sceneAnimatorDict[arg1_323] = {
			trans = var1_323,
			animator = var2_323
		}
	end

	if not arg3_323 and arg0_323.sceneAnimatorDict[arg1_323].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_323) then
		return
	end

	arg0_323.sceneAnimatorDict[arg1_323].animator:PlayInFixedTime(arg2_323)
end

function var0_0.ResetSceneItemAnimators(arg0_324, arg1_324)
	if not arg0_324.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_324.sceneAnimatorDict, function(arg0_325, arg1_325)
		if arg1_324 and table.contains(arg1_324, arg0_325) then
			return
		end

		setActive(arg1_325.trans, false)
		setActive(arg1_325.trans, true)

		arg0_324.sceneAnimatorDict[arg0_325] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_326, arg1_326, arg2_326, arg3_326, arg4_326, arg5_326, arg6_326, arg7_326)
	local function var0_326(arg0_327)
		if arg6_326 then
			local var0_327 = arg0_327:GetComponent(typeof(Animator))

			if var0_327 then
				var0_327:Play(arg6_326)

				var0_327.speed = arg7_326
			end
		end
	end

	arg1_326.extraItems = arg1_326.extraItems or {}

	if arg1_326.extraItems[arg2_326] then
		var0_326(arg1_326.extraItems[arg2_326].trans)

		return
	end

	local var1_326

	if arg3_326 == "" then
		var1_326 = arg1_326.lady
	elseif arg3_326 == "scene_root" then
		var1_326 = arg0_326.modelRoot
	else
		table.IpairsCArray(arg1_326.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_328, arg1_328)
			if arg1_328.name == arg3_326 then
				var1_326 = arg1_328
			end
		end)
	end

	if not var1_326 then
		return
	end

	arg0_326.loader:GetPrefab(string.lower("dorm3d/" .. arg2_326), "", function(arg0_329)
		setParent(arg0_329, var1_326)

		if arg4_326 then
			setLocalPosition(arg0_329, arg4_326)
		end

		if arg5_326 then
			setLocalRotation(arg0_329, arg5_326)
		end

		var0_326(arg0_329)

		arg1_326.extraItems[arg2_326] = {
			trans = arg0_329.transform,
			handler = var1_326
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_330, arg1_330, arg2_330)
	if not arg1_330.extraItems then
		return
	end

	table.Foreach(arg1_330.extraItems, function(arg0_331, arg1_331)
		if arg2_330 and table.contains(arg2_330, arg0_331) then
			return
		end

		arg0_330.loader:ReturnPrefab(arg1_331.trans.gameObject)

		arg1_330.extraItems[arg0_331] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_332, arg1_332, arg2_332)
	arg0_332.cameraBlendCallbacks[arg1_332] = arg2_332
end

function var0_0.UnRegisterCameraBlendFinished(arg0_333, arg1_333)
	arg0_333.cameraBlendCallbacks[arg1_333] = nil
end

function var0_0.OnCameraBlendFinished(arg0_334, arg1_334)
	if not arg1_334 then
		return
	end

	local var0_334 = table.removebykey(arg0_334.cameraBlendCallbacks, arg1_334)

	existCall(var0_334)
end

function var0_0.PlayHeartFX(arg0_335, arg1_335)
	local var0_335 = arg0_335.ladyDict[arg1_335]

	setActive(var0_335.effectHeart, false)
	setActive(var0_335.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_336, arg1_336)
	local var0_336 = arg1_336.name
	local var1_336 = arg0_336.expressionDict[var0_336]
	local var2_336 = 5

	if var1_336 then
		local var3_336 = var1_336.timer

		var3_336:Reset(nil, var2_336)
		var3_336:Start()

		if var1_336.instance then
			setActive(var1_336.instance, false)
			setActive(var1_336.instance, true)
		end

		return
	end

	local var4_336 = {
		name = var0_336,
		timer = Timer.New(function()
			arg0_336:RemoveExpression(var0_336)
		end, var2_336, 1, true)
	}

	arg0_336.expressionDict[var0_336] = var4_336

	arg0_336.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_336, var0_336, function(arg0_338)
		var4_336.instance = arg0_338

		onNextTick(function()
			local var0_339 = arg0_336.ladyDict[arg0_336.apartment:GetConfigID()]

			setParent(arg0_338, var0_339.ladyHeadCenter)
		end)
		setLocalPosition(arg0_338, Vector3(0, 0, -0.2))
		setActive(arg0_338, false)
		setActive(arg0_338, true)
	end, var4_336)
end

function var0_0.RemoveExpression(arg0_340, arg1_340)
	local var0_340 = arg0_340.expressionDict[arg1_340]

	if not var0_340 then
		return
	end

	arg0_340.loader:ClearRequest(var0_340)

	if var0_340.instance then
		arg0_340.loader:ReturnPrefab(var0_340.instance)
	end

	arg0_340.expressionDict[arg1_340] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_341, arg1_341, arg2_341)
	setActive(arg1_341.ladyWatchFloat, arg2_341)
end

function var0_0.RegisterGlobalVolume(arg0_342)
	local var0_342 = arg0_342.globalVolume
	local var1_342 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_342, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_342 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_342, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	arg0_342.originalCameraSettings = {
		depthOfField = {
			enabled = var1_342.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_342.gaussianStart.min,
				value = var1_342.gaussianStart.value
			},
			blurRadius = {
				min = var1_342.blurRadius.min,
				max = var1_342.blurRadius.max,
				value = var1_342.blurRadius.value
			}
		},
		postExposure = {
			value = var2_342.postExposure.value
		},
		contrast = {
			min = var2_342.contrast.min,
			max = var2_342.contrast.max,
			value = var2_342.contrast.value
		},
		saturate = {
			min = var2_342.saturation.min,
			max = var2_342.saturation.max,
			value = var2_342.saturation.value
		}
	}
	arg0_342.originalCameraSettings.depthOfField.enabled = true

	local var3_342 = var0_342:GetComponent(typeof(UnityEngine.Rendering.Volume))

	arg0_342.originalVolume = {
		profile = var3_342.sharedProfile,
		weight = var3_342.weight
	}
end

function var0_0.SettingCamera(arg0_343, arg1_343)
	arg0_343.activeCameraSettings = arg1_343

	local var0_343 = arg0_343.globalVolume
	local var1_343 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_343, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_343 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_343, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	var1_343.enabled:Override(arg1_343.depthOfField.enabled)
	var1_343.gaussianStart:Override(arg1_343.depthOfField.focusDistance.value)
	var1_343.gaussianEnd:Override(arg1_343.depthOfField.focusDistance.value + arg1_343.depthOfField.focusDistance.length)
	var1_343.blurRadius:Override(arg1_343.depthOfField.blurRadius.value)
	var2_343.postExposure:Override(arg1_343.postExposure.value)
	var2_343.contrast:Override(arg1_343.contrast.value)
	var2_343.saturation:Override(arg1_343.saturate.value)
end

function var0_0.GetCameraSettings(arg0_344)
	return arg0_344.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_345)
	arg0_345:SettingCamera(arg0_345.originalCameraSettings)

	arg0_345.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_346, arg1_346, arg2_346)
	if arg0_346.cameraVolume then
		arg0_346:RevertVolumeProfile()
	end

	arg0_346.loader:GetPrefab("dorm3d/effect/volume/" .. arg1_346, "", function(arg0_347)
		arg0_346.cameraVolume = arg0_347
	end)
end

function var0_0.RevertVolumeProfile(arg0_348)
	if arg0_348.cameraVolume then
		arg0_348.loader:ReturnPrefab(arg0_348.cameraVolume)

		arg0_348.cameraVolume = nil
	end
end

function var0_0.RecordCharacterLight(arg0_349)
	tolua.loadassembly("Yongshi.BLRP.Runtime.AOT")

	local var0_349 = arg0_349.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	arg0_349.originalCharacterColor = {
		color = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var0_349),
		intensity = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var0_349)
	}
end

function var0_0.SetCharacterLight(arg0_350, arg1_350, arg2_350, arg3_350)
	local var0_350 = arg0_350.characterLight:GetComponent(typeof(Light))
	local var1_350 = Color.Lerp(arg0_350.originalCharacterColor.color, arg1_350, arg3_350)
	local var2_350 = math.lerp(arg0_350.originalCharacterColor.intensity, arg2_350, arg3_350)
	local var3_350 = arg0_350.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var3_350, var1_350)
	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var3_350, var2_350)
end

function var0_0.RevertCharacterLight(arg0_351)
	arg0_351:SetCharacterLight(arg0_351.originalCharacterColor.color, arg0_351.originalCharacterColor.intensity, 1)
end

function var0_0.onBackPressed(arg0_352)
	if arg0_352.exited or arg0_352.retainCount > 0 then
		-- block empty
	else
		arg0_352:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_353, arg1_353, arg2_353, arg3_353, arg4_353)
	arg0_353.dormSceneMgr:LoadTimelineScene({
		name = arg1_353,
		assetRootName = arg0_353.apartment:getConfig("asset_name"),
		isCache = arg2_353,
		waitForTimeline = arg3_353,
		loadSceneFunc = function(arg0_354, arg1_354)
			local var0_354 = GameObject.Find("[actor]").transform

			arg0_353:HXCharacter(tf(var0_354))
		end
	}, arg4_353)
end

function var0_0.UnloadTimelineScene(arg0_355, arg1_355, arg2_355, arg3_355)
	arg0_355.dormSceneMgr:UnloadTimelineScene(arg1_355, arg2_355, arg3_355)
end

function var0_0.ChangeArtScene(arg0_356, arg1_356, arg2_356)
	local var0_356 = {}

	table.insert(var0_356, function(arg0_357)
		arg0_356.dormSceneMgr:ChangeArtScene(arg1_356, arg0_357)
	end)
	table.insert(var0_356, function(arg0_358)
		setActive(arg0_356.slotRoot, false)
		arg0_358()
	end)
	warning(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", arg1_356, arg0_356.dormSceneMgr.sceneInfo, Dorm3dSceneMgr.IsSameSceneInfo(arg1_356, arg0_356.dormSceneMgr.sceneInfo))

	if Dorm3dSceneMgr.IsSameSceneInfo(arg1_356, arg0_356.dormSceneMgr.sceneInfo) then
		table.insert(var0_356, function(arg0_359)
			arg0_356:SwitchDayNight(1)
			arg0_356:TempHideContact(true)
			arg0_359()
		end)
	end

	seriesAsync(var0_356, arg2_356)
end

function var0_0.RevertArtScene(arg0_360, arg1_360, arg2_360)
	local var0_360 = {}

	table.insert(var0_360, function(arg0_361)
		arg0_360.dormSceneMgr:ChangeArtScene(arg1_360, arg0_361)
	end)
	table.insert(var0_360, function(arg0_362)
		setActive(arg0_360.slotRoot, true)
		arg0_362()
	end)
	table.insert(var0_360, function(arg0_363)
		arg0_360:SwitchDayNight(arg0_360.contextData.timeIndex)
		onNextTick(function()
			arg0_360:RefreshSlots()
			arg0_360:TempHideContact(false)
			arg0_363()
		end)
	end)
	seriesAsync(var0_360, arg2_360)
end

function var0_0.ChangeSubScene(arg0_365, arg1_365, arg2_365)
	local var0_365 = {}

	table.insert(var0_365, function(arg0_366)
		arg0_365.dormSceneMgr:ChangeSubScene(arg1_365, arg0_366)
	end)

	local var1_365 = arg0_365.ladyDict[arg0_365.apartment:GetConfigID()]

	table.insert(var0_365, function(arg0_367)
		if Dorm3dSceneMgr.IsSameSceneInfo(arg1_365, arg0_365.dormSceneMgr.sceneInfo) then
			var1_365.ladyActiveZone = var1_365.walkBornPoint or var1_365.ladyBaseZone
		else
			var1_365.ladyActiveZone = var1_365.walkBornPoint or "Default"
		end

		arg0_367()
	end)

	if not Dorm3dSceneMgr.IsSameSceneInfo(arg1_365, arg0_365.dormSceneMgr.subSceneInfo) then
		table.insert(var0_365, function(arg0_368)
			local var0_368, var1_368 = Dorm3dSceneMgr.ParseInfo(arg1_365)
			local var2_368 = var0_368 .. "_base"

			arg0_365:ResetSceneStructure(SceneManager.GetSceneByName(var2_368))

			if Dorm3dSceneMgr.IsSameSceneInfo(arg1_365, arg0_365.dormSceneMgr.sceneInfo) then
				arg0_365:RefreshSlots()
			else
				arg0_365:SwitchAnim(var1_365, var0_0.ANIM.IDLE)
			end

			if not Dorm3dSceneMgr.IsSameSceneInfo(arg0_365.dormSceneMgr.subSceneInfo, arg0_365.dormSceneMgr.sceneInfo) then
				arg0_365:RefreshSlotsEmpty()
			end

			arg0_368()
		end)
	end

	table.insert(var0_365, function(arg0_369)
		onNextTick(function()
			arg0_365:ChangeCharacterPosition(var1_365)
			arg0_365:ChangePlayerPosition(var1_365.ladyActiveZone)
			arg0_365:TriggerLadyDistance()
			arg0_365:CheckInSector()
			arg0_369()
		end)
	end)
	seriesAsync(var0_365, arg2_365)
end

function var0_0.IsPointInSector(arg0_371, arg1_371)
	local var0_371 = arg1_371 - arg0_371.Position

	if var0_371.y > arg0_371.Radius then
		return false
	end

	var0_371.y = 0

	if var0_371.magnitude > arg0_371.Radius then
		return false
	end

	local var1_371 = arg0_371.Rotation

	return Vector3.Angle(var1_371 * Vector3.forward, var0_371) <= arg0_371.Angle / 2
end

function var0_0.GetRestritedHeightRange(arg0_372)
	if not arg0_372.isMultiFloor then
		return arg0_372.restrictedHeightRange
	else
		for iter0_372 = #arg0_372.restrictedHeightRange, 1, -1 do
			local var0_372 = arg0_372.restrictedHeightRange[iter0_372]

			if arg0_372.mainCameraTF.position.y >= var0_372[1] then
				return var0_372
			end
		end

		return arg0_372.restrictedHeightRange[1]
	end
end

function var0_0.willExit(arg0_373)
	arg0_373:RemoveExtraSystem()
	arg0_373.joystickTimer:Stop()
	arg0_373.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_373.updateHandler)
	arg0_373:StopIKHandTimer()

	if arg0_373.moveTimer then
		arg0_373.moveTimer:Stop()

		arg0_373.moveTimer = nil
	end

	if arg0_373.moveWaitTimer then
		arg0_373.moveWaitTimer:Stop()

		arg0_373.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_373.furnitures) then
		eachChild(arg0_373.furnitures, function(arg0_374)
			local var0_374 = GetComponent(arg0_374, typeof(EventTriggerListener))

			if not var0_374 then
				return
			end

			var0_374:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_373, iter1_373 in pairs(arg0_373.ladyDict) do
		GetComponent(iter1_373.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_373.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_373.camBrainEvenetHandler.OnBlendFinished = nil

	arg0_373:UnOverlayPanel(arg0_373.blockLayer, arg0_373._tf)
	table.Foreach(arg0_373.expressionDict, function(arg0_375)
		arg0_373:RemoveExpression(arg0_375)
	end)
	arg0_373.loader:Clear()
	pg.ClickEffectMgr.GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_373.dormSceneMgr:Dispose()

	arg0_373.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)

	if arg0_373.transformFilter then
		arg0_373.transformFilter:Dispose()
	end
end

return var0_0
