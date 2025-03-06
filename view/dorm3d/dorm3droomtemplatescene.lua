local var0_0 = class("Dorm3dRoomTemplateScene", import("view.base.BaseUI"))

var0_0.CAMERA = {
	GIFT = 8,
	PHOTO_FREE = 11,
	TALK = 4,
	PHOTO = 10,
	POV = 12,
	IK_WATCH = 13,
	ROLE = 3,
	AIM = 1,
	ROLE2 = 9,
	FURNITURE_WATCH = 7,
	AIM2 = 2
}

local var1_0 = {
	Head = "Bip001 Head",
	LeftUpperArm = "Bip001 L UpperArm",
	RightThigh = "Bip001 R Thigh",
	LeftFoot = "Bip001 L Foot",
	RightFoot = "Bip001 R Foot",
	Spine1 = "Bip001 Spine1",
	RightCalf = "Bip001 R Calf",
	RightHand = "Bip001 R Hand",
	LeftThigh = "Bip001 L Thigh",
	Spine = "Bip001 Spine",
	RightUpperArm = "Bip001 R UpperArm",
	Spine2 = "Bip001 Spine2",
	LeftHand = "Bip001 L Hand",
	Pelvis = "Bip001 Pelvis",
	LeftForeArm = "Bip001 L Forearm",
	RightForeArm = "Bip001 R Forearm",
	LeftCalf = "Bip001 L Calf"
}

var0_0.BONE_TO_TOUCH = {
	Head = "head",
	LeftUpperArm = "hand",
	RightThigh = "leg",
	LeftFoot = "leg",
	RightUpperArm = "hand",
	RightLowerArm = "hand",
	Chest = "chest",
	Butt = "butt",
	RightHand = "hand",
	LeftLowerArm = "hand",
	LeftThigh = "leg",
	RightCalf = "leg",
	RightFoot = "leg",
	LeftHand = "hand",
	Back = "back",
	LeftCalf = "leg",
	Belly = "belly"
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

local var2_0 = {
	map_siriushostel_01_base = {},
	map_dormitorycorridor_01_base = {
		Default = {
			Radius = 2,
			Angle = 120,
			Position = {
				1.571,
				0,
				38.647
			},
			Rotation = {
				0,
				180,
				0
			}
		}
	},
	map_noshirohostel_01_base = {},
	map_beach_02_base = {}
}

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

function var0_0.lowerAdpter(arg0_7)
	return true
end

function var0_0.Ctor(arg0_8, ...)
	var0_0.super.Ctor(arg0_8, ...)

	arg0_8.loader = AutoLoader.New()
	arg0_8.scene = arg0_8
end

function var0_0.SetRoom(arg0_9, arg1_9)
	arg0_9.room = arg1_9
end

function var0_0.preload(arg0_10, arg1_10)
	tolua.loadassembly("MagicaCloth")
	tolua.loadassembly("ParadoxNotion")

	for iter0_10, iter1_10 in pairs({
		_MonoManager = "ParadoxNotion.Services.MonoManager",
		MagicaPhysicsManager = "MagicaCloth.MagicaPhysicsManager"
	}) do
		if not GameObject.Find(iter0_10) then
			local var0_10 = GameObject.New(iter0_10)

			GetOrAddComponent(var0_10, typeof(iter1_10))
		end
	end

	arg0_10.room = getProxy(ApartmentProxy):getRoom(arg0_10.contextData.roomId)

	local var1_10 = {}

	table.insert(var1_10, function(arg0_11)
		arg0_10.dormSceneMgr = Dorm3dSceneMgr.New(string.lower(arg0_10.room:getConfig("scene_info")), arg0_11)
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

	for iter0_13, iter1_13 in pairs(arg0_13.ladyDict) do
		arg0_13:InitCharacter(iter1_13, iter0_13)

		iter1_13.ladyBaseZone = arg0_13.contextData.ladyZone[iter0_13]
		iter1_13.ladyActiveZone = iter1_13.ladyBaseZone

		arg0_13:ChangeCharacterPosition(iter1_13)
	end

	if not arg0_13.apartment then
		local var0_13 = underscore.detect(arg0_13.contextData.groupIds, function(arg0_14)
			return arg0_13.contextData.ladyZone[arg0_14] == arg0_13.contextData.inFurnitureName
		end) or arg0_13.contextData.groupIds[1]

		if var0_13 then
			arg0_13:SyncInterestTransform(arg0_13.ladyDict[var0_13])
		end
	end

	arg0_13.retainCount = 0
	arg0_13.sceneBlockLayer = arg0_13._tf:Find("SceneBlock")

	setActive(arg0_13.sceneBlockLayer, false)

	arg0_13.blockLayer = arg0_13._tf:Find("Block")

	setActive(arg0_13.blockLayer, false)

	arg0_13.blackLayer = arg0_13._tf:Find("BlackScreen")

	setActive(arg0_13.blackLayer, false)
	arg0_13:ChangePlayerPosition()

	arg0_13.cacheSceneDic = {}
	arg0_13.sceneGroupDic = {}
	arg0_13.lastSceneRootDict = {}

	pg.ClickEffectMgr:GetInstance():SetClickEffect("DORM3D")
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
	arg0_15:bind(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, function(arg0_21, arg1_21, arg2_21, arg3_21)
		if arg0_15.blockIK then
			return
		end

		if arg1_21.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():OnDragBegin(arg2_21, arg3_21)
	end)
	arg0_15:bind(var0_0.ON_DRAG_CHARACTER_BODY, function(arg0_22, arg1_22, arg2_22)
		if not arg1_22.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():HandleBodyDrag(arg2_22)
	end)
	arg0_15:bind(var0_0.ON_RELEASE_CHARACTER_BODY, function(arg0_23, arg1_23)
		pg.IKMgr.GetInstance():ReleaseDrag()
	end)
	arg0_15:bind(var0_0.ON_POV_STICK_MOVE_BEGIN, function(arg0_24, arg1_24)
		if arg0_15.pinchMode then
			return
		end

		arg0_15.moveStickOrigin = arg1_24.position
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

	arg0_15:bind(var0_0.ON_POV_STICK_MOVE_END, function(arg0_26, arg1_26)
		var0_15()
	end)
	arg0_15:bind(var0_0.ON_POV_STICK_MOVE, function(arg0_27, arg1_27)
		if arg0_15.pinchMode then
			var0_15()

			return
		end

		if not arg0_15.moveStickDraging then
			return
		end

		arg0_15.moveStickPosition = arg0_15.moveStickPosition + arg1_27

		if isActive(arg0_15.povLayer:Find("Guide")) then
			setActive(arg0_15.povLayer:Find("Guide"), false)
		end
	end)

	local var1_15 = 32.4 / Screen.height

	arg0_15:bind(var0_0.ON_POV_STICK_VIEW, function(arg0_28, arg1_28)
		if arg0_15.pinchMode then
			return
		end

		arg1_28 = arg1_28 * var1_15

		local var0_28 = arg1_28.x
		local var1_28 = arg1_28.y

		local function var2_28(arg0_29, arg1_29, arg2_29)
			local var0_29 = arg0_29[arg1_29]

			var0_29.m_InputAxisValue = arg2_29
			arg0_29[arg1_29] = var0_29
		end

		if isActive(arg0_15.cameras[var0_0.CAMERA.POV]) then
			var2_28(arg0_15.compPovAim, "m_HorizontalAxis", var0_28)
			var2_28(arg0_15.compPovAim, "m_VerticalAxis", var1_28)
		elseif isActive(arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			local var3_28 = arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

			var2_28(var3_28, "m_HorizontalAxis", var0_28)
			var2_28(var3_28, "m_VerticalAxis", var1_28)
		end
	end)

	local var2_15 = {
		HideCharacterBylayer = true,
		EnableHeadIK = true,
		RevertCharacterBylayer = true
	}

	arg0_15:bind(var0_0.PHOTO_CALL, function(arg0_30, arg1_30, ...)
		if var2_15[arg1_30] then
			local var0_30 = arg0_15.ladyDict[arg0_15.apartment:GetConfigID()]

			arg0_15[arg1_30](arg0_15, var0_30, ...)
		else
			local var1_30 = arg0_15.ladyDict[arg0_15.apartment:GetConfigID()]

			arg0_15[arg1_30](var1_30, ...)
		end
	end)
end

function var0_0.RegisterIKFunc(arg0_31)
	pg.IKMgr.GetInstance():RegisterOnIKLayerActive(function(arg0_32)
		arg0_31.blockIK = true

		local var0_32 = arg0_31.ladyDict[arg0_31.apartment:GetConfigID()]

		var0_32.ikHandler = arg0_32

		local var1_32 = _.detect(var0_32.readyIKLayers, function(arg0_33)
			return arg0_33:GetControllerPath() == arg0_32.ikData:GetControllerPath()
		end)

		arg0_31:EnableIKLayer(var1_32)

		arg0_31.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

		arg0_31:emit(var0_0.ON_IK_STATUS_CHANGED, var1_32:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDrag(function(arg0_34)
		arg0_31.ladyDict[arg0_31.apartment:GetConfigID()].ikHandler = arg0_34

		arg0_31:ResetIKTipTimer()
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_35, arg1_35)
		local var0_35 = arg0_31.ladyDict[arg0_31.apartment:GetConfigID()]
		local var1_35 = _.detect(var0_35.readyIKLayers, function(arg0_36)
			return arg0_36:GetControllerPath() == arg0_35.ikData:GetControllerPath()
		end)

		arg0_31:DeactiveIKLayer(var1_35)

		var0_35.ikHandler = nil
		arg0_31.blockIK = arg1_35

		arg0_31:emit(var0_0.ON_IK_STATUS_CHANGED, var1_35:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_37)
		local var0_37 = arg0_31.ladyDict[arg0_31.apartment:GetConfigID()]

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

	arg0_39.resTF = GameObject.Find("Res").transform

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
		[var0_0.CAMERA.POV] = var3_39:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	}

	setActive(arg0_39.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_39.compPovAim = arg0_39.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_39.cameraRoot = var3_39
	arg0_39.POVOriginalFOV = arg0_39:GetPOVFOV()
	arg0_39.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_39.restrictedBox, false)

	arg0_39.restrictedHeightRange = {
		arg0_39.restrictedBox:Find("Floor").position.y,
		arg0_39.restrictedBox:Find("Celling").position.y
	}
	arg0_39.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_39.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))

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

function var0_0.SwitchDayNight(arg0_42, arg1_42)
	if not IsNil(arg0_42.daynightCtrlComp) then
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

	arg0_45.sectorsDic = arg0_45.sectorsDic or {}

	if not arg0_45.sectorsDic[arg1_45.name] then
		arg0_45.sectorsDic[arg1_45.name] = table.shallowCopy(var2_0[arg1_45.name]) or {}

		setmetatable(arg0_45.sectorsDic[arg1_45.name], {
			__index = function(arg0_48, arg1_48)
				local var0_48 = arg0_45.furnitures:Find(arg1_48 .. "/StayPoint")

				if var0_48 then
					local var1_48 = var0_48.position
					local var2_48 = var0_48.eulerAngles

					arg0_48[arg1_48] = {
						Radius = 2,
						Angle = 120,
						Position = {
							var1_48.x,
							var1_48.y,
							var1_48.z
						},
						Rotation = {
							var2_48.x,
							var2_48.y,
							var2_48.z
						}
					}

					return arg0_48[arg1_48]
				else
					return nil
				end
			end
		})
	end

	arg0_45.activeSectors = arg0_45.sectorsDic[arg1_45.name]
end

function var0_0.InitSlots(arg0_49)
	local var0_49 = arg0_49.room:GetSlots()
	local var1_49 = arg0_49.modelRoot:GetComponentsInChildren(typeof(Transform), true)

	arg0_49.slotDict = {}

	_.each(var0_49, function(arg0_50)
		local var0_50 = arg0_50:GetFurnitureName()
		local var1_50 = arg0_50:GetConfigID()
		local var2_50 = arg0_49.slotRoot:Find(tostring(var1_50))

		if not var2_50 then
			errorMsg("Not Find Slot: " .. var1_50)

			return
		end

		local var3_50 = {
			trans = var2_50,
			sceneHides = {}
		}
		local var4_50 = var2_50:Find("Selector")

		if var4_50 then
			GetOrAddComponent(var4_50, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_51, arg1_51)
				arg0_49:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_50)
			end)
			setActive(var4_50, false)
		end

		local var5_50

		for iter0_50 = 0, var1_49.Length - 1 do
			local var6_50 = var1_49[iter0_50]

			if var6_50.name == var0_50 then
				var5_50 = var6_50

				break
			end
		end

		if var5_50 then
			var3_50.model = var5_50
		end

		arg0_49.slotDict[var1_50] = var3_50
	end)
end

function var0_0.SetContactStateDic(arg0_52, arg1_52)
	arg0_52.contactStateDic = arg1_52
	arg0_52.hideContactStateDic = {}
	arg0_52.contactInRangeDic = {}

	for iter0_52, iter1_52 in pairs(arg0_52.contactStateDic) do
		arg0_52.hideContactStateDic[iter0_52] = math.min(iter1_52, ApartmentRoom.ITEM_UNLOCK)
		arg0_52.contactInRangeDic[iter0_52] = false
	end

	arg0_52:ActiveContact()
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
		arg0_57.ladyDict[arg0_57.apartment:GetConfigID()]:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_58)
	local var0_58 = arg0_58.ladyDict[arg0_58.apartment:GetConfigID()]
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
		local var1_59 = setmetatable({}, {
			__index = arg0_59
		})

		arg0_59.ladyDict[iter1_59] = var1_59

		local var2_59 = getProxy(ApartmentProxy):getApartment(iter1_59)
		local var3_59 = var2_59:getConfig("asset_name")
		local var4_59 = var2_59:GetSkinModelID(arg0_59.room:getConfig("tag"))
		local var5_59 = pg.dorm3d_resource[var4_59].model_id

		assert(var5_59)

		for iter2_59, iter3_59 in ipairs({
			"common",
			var5_59
		}) do
			local var6_59 = string.format("dorm3d/character/%s/res/%s", var3_59, iter3_59)

			if checkABExist(var6_59) then
				table.insert(var0_59, function(arg0_60)
					arg0_59.loader:LoadBundle(var6_59, function(arg0_61)
						for iter0_61, iter1_61 in ipairs(arg0_61:GetAllAssetNames()) do
							local var0_61, var1_61, var2_61 = string.find(iter1_61, "material_hx[/\\](.*).mat")

							if var0_61 then
								arg0_59.hxMatDict[var2_61] = {
									arg0_61,
									iter1_61
								}
							end
						end

						arg0_60()
					end)
				end)
			end
		end

		var1_59.skinId = var4_59
		var1_59.skinIdList = {
			var4_59
		}

		table.insert(var0_59, function(arg0_62)
			local var0_62 = string.format("dorm3d/character/%s/prefabs/%s", var3_59, var5_59)

			arg0_59.loader:GetPrefab(var0_62, "", function(arg0_63)
				var1_59.ladyGameobject = arg0_63
				arg0_59.skinDict[var4_59] = {
					ladyGameobject = arg0_63
				}

				arg0_62()
			end)
		end)

		if arg0_59.room:isPersonalRoom() then
			local var7_59 = var2_59:GetSkinModelID("touch")

			if var7_59 then
				local var8_59 = pg.dorm3d_resource[var7_59].model_id
				local var9_59 = string.format("dorm3d/character/%s/prefabs/%s", var3_59, var8_59)

				if #var8_59 > 0 and checkABExist(var9_59) then
					table.insert(var1_59.skinIdList, var7_59)
					table.insert(var0_59, function(arg0_64)
						arg0_59.loader:GetPrefab(var9_59, "", function(arg0_65)
							arg0_59.skinDict[var7_59] = {
								ladyGameobject = arg0_65
							}
							GetComponent(arg0_65, "GraphOwner").enabled = false

							onNextTick(function()
								setActive(arg0_65, false)
							end)
							arg0_64()
						end)
					end)
				end
			end
		end

		if arg0_59.contextData.pendingDic[iter1_59] then
			local var10_59 = pg.dorm3d_welcome[arg0_59.contextData.pendingDic[iter1_59]]

			if var10_59.item_prefab ~= "" then
				table.insert(var0_59, function(arg0_67)
					local var0_67 = string.lower("dorm3d/furniture/item/" .. var10_59.item_prefab)

					arg0_59.loader:GetPrefab(var0_67, "", function(arg0_68)
						var1_59.tfPendintItem = arg0_68.transform

						onNextTick(function()
							setActive(arg0_68, false)
						end)
						arg0_67()
					end)
				end)
			end
		end
	end

	parallelAsync(var0_59, arg2_59)
end

function var0_0.HXCharacter(arg0_70, arg1_70)
	if not HXSet.isHx() then
		return
	end

	local var0_70 = arg1_70:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_70, function(arg0_71, arg1_71)
		local var0_71 = arg1_71.sharedMaterials
		local var1_71 = false

		table.IpairsCArray(var0_71, function(arg0_72, arg1_72)
			if arg1_72 == nil then
				return
			end

			local var0_72 = arg1_72.name

			if not arg0_70.hxMatDict[var0_72] then
				return
			end

			var1_71 = true

			local var1_72, var2_72 = unpack(arg0_70.hxMatDict[var0_72])
			local var3_72 = var1_72:LoadAssetSync(var2_72, typeof(Material), false, false)

			var0_71[arg0_72] = var3_72

			warning("Replace HX Material", arg0_70.hxMatDict[var0_72][2])
		end)

		if var1_71 then
			arg1_71.sharedMaterials = var0_71
		end
	end)
end

function var0_0.InitCharacter(arg0_73, arg1_73, arg2_73)
	arg1_73.lady = arg1_73.ladyGameobject.transform

	arg1_73.lady:SetParent(arg1_73.mainCameraTF)
	arg1_73.lady:SetParent(nil)

	arg1_73.ladyHeadIKComp = arg1_73.lady:GetComponent(typeof(HeadAimIK))
	arg1_73.ladyHeadIKComp.AimTarget = arg1_73.mainCameraTF:Find("AimTarget")
	arg1_73.ladyHeadIKData = {
		DampTime = arg1_73.ladyHeadIKComp.DampTime,
		blinkSpeed = arg1_73.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg1_73.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg1_73.ladyHeadIKComp.HeadWeight
	}

	local var0_73 = {}

	table.Foreach(var1_0, function(arg0_74, arg1_74)
		var0_73[arg1_74] = arg0_74
	end)

	arg1_73.ladyAnimator = arg1_73.lady:GetComponent(typeof(Animator))
	arg1_73.ladyAnimBaseLayerIndex = arg1_73.ladyAnimator:GetLayerIndex("Base Layer")
	arg1_73.ladyAnimFaceLayerIndex = arg1_73.ladyAnimator:GetLayerIndex("Face")
	arg1_73.ladyBoneMaps = {}

	local var1_73 = arg1_73.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_73, function(arg0_75, arg1_75)
		if arg1_75.name == "BodyCollider" then
			arg1_73.ladyCollider = arg1_75

			setActive(arg1_75, true)
		elseif arg1_75.name == "SafeCollider" then
			arg1_73.ladySafeCollider = arg1_75

			setActive(arg1_75, false)
		elseif arg1_75.name == "Interest" then
			arg1_73.ladyInterestRoot = arg1_75
		elseif arg1_75.name == "Head Center" then
			arg1_73.ladyHeadCenter = arg1_75
		end

		if var0_73[arg1_75.name] then
			arg1_73.ladyBoneMaps[var0_73[arg1_75.name]] = arg1_75
		end
	end)

	arg1_73.ladyColliders = {}
	arg1_73.ladyTouchColliders = {}

	table.IpairsCArray(arg1_73.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_76, arg1_76)
		if arg1_76:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_76)

		local var0_76 = child.name
		local var1_76 = var0_76 and string.find(var0_76, "Collider") or -1

		if var1_76 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_76)

			return
		end

		local var2_76 = string.sub(var0_76, 1, var1_76 - 1)

		if var0_0.BONE_TO_TOUCH[var2_76] == nil then
			return
		end

		arg1_73.ladyColliders[var2_76] = child

		table.insert(arg1_73.ladyTouchColliders, child)
		setActive(child, false)
	end)
	arg1_73:HXCharacter(arg1_73.lady)
	;(function()
		local var0_77 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_77 = "vfx_function_aixin02"

		arg1_73.loader:GetPrefab(var0_77, var1_77, function(arg0_78)
			arg1_73.effectHeart = arg0_78

			setActive(arg0_78, false)
			onNextTick(function()
				setParent(arg1_73.effectHeart, arg1_73.ladyHeadCenter)
			end)
		end)
	end)()

	arg1_73.clothComps = {}
	arg1_73.ladyClothCompSettings = {}

	table.IpairsCArray(arg1_73.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_80, arg1_80)
		table.insert(arg1_73.clothComps, arg1_80)

		arg1_73.ladyClothCompSettings[arg1_80] = {
			enabled = arg1_80.enabled
		}
	end)

	arg1_73.clothColliderDict = {}
	arg1_73.ladyClothColliderSettings = {}

	local var2_73 = typeof("MagicaCloth.MagicaCapsuleCollider")

	table.IpairsCArray(arg1_73.lady:GetComponentsInChildren(var2_73, true), function(arg0_81, arg1_81)
		arg1_73.clothColliderDict[arg1_81.name] = arg1_81
		arg1_73.ladyClothColliderSettings[arg1_81] = {
			enabled = arg1_81.enabled,
			StartRadius = ReflectionHelp.RefGetProperty(var2_73, "StartRadius", arg1_81),
			EndRadius = ReflectionHelp.RefGetProperty(var2_73, "EndRadius", arg1_81)
		}
	end)
	arg1_73:EnableCloth(arg1_73, false)

	arg1_73.ladyIKRoot = arg1_73.lady:Find("IKLayers")

	eachChild(arg1_73.ladyIKRoot, function(arg0_82)
		setActive(arg0_82, false)
	end)
	GetComponent(arg1_73.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_83, arg1_83)
		if arg1_83.rawPointerPress.transform == arg1_73.ladyCollider then
			arg1_73:emit(var0_0.CLICK_CHARACTER, arg2_73)
		else
			local var0_83 = table.keyof(arg1_73.IKSettings.Colliders, arg1_83.rawPointerPress.transform)

			arg1_73:emit(var0_0.ON_TOUCH_CHARACTER, var0_83 or arg1_83.rawPointerPress.name)
		end
	end)
	arg1_73.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_84)
		if arg1_73.nowState and arg0_84.animatorStateInfo:IsName(arg1_73.nowState) then
			existCall(arg1_73.stateCallback)

			return
		end

		local var0_84 = arg0_84.animatorStateInfo

		for iter0_84, iter1_84 in pairs(arg1_73.animCallbacks) do
			if var0_84:IsName(iter0_84) then
				warning("Active", iter0_84)

				local var1_84 = table.removebykey(arg1_73.animCallbacks, iter0_84)

				existCall(var1_84)

				return
			end
		end

		if arg0_84.stringParameter ~= "" then
			arg1_73:OnAnimationEvent(arg0_84)
		end
	end)

	arg1_73.animEventCallbacks = {}
	arg1_73.animCallbacks = {}
end

function var0_0.SwitchCharacterSkin(arg0_85, arg1_85, arg2_85, arg3_85, arg4_85)
	local var0_85 = arg1_85.skinIdList

	assert(table.contains(var0_85, arg3_85))

	local var1_85 = arg0_85:GetCurrentAnim()
	local var2_85 = arg1_85.skinId
	local var3_85 = arg1_85.skinDict[var2_85].ladyGameobject
	local var4_85 = var3_85.transform.position
	local var5_85 = var3_85.transform.rotation

	setActive(var3_85, false)

	arg1_85.skinId = arg3_85

	setActive(arg1_85.skinDict[arg3_85].ladyGameobject, true)

	arg1_85.ladyGameobject = arg1_85.skinDict[arg3_85].ladyGameobject
	arg1_85.ladyCollider = nil

	arg0_85:InitCharacter(arg1_85, arg2_85)
	arg1_85.ladyAnimator:Play(var1_85, arg1_85.ladyAnimBaseLayerIndex)
	arg1_85.ladyAnimator:Update(0)
	arg1_85.lady:SetPositionAndRotation(var4_85, var5_85)
	existCall(arg4_85)
end

function var0_0.SetCameraLady(arg0_86, arg1_86)
	arg0_86.cameraAim2.LookAt = arg1_86.ladyInterestRoot
	arg0_86.cameras[var0_0.CAMERA.TALK].Follow = arg1_86.ladyInterestRoot
	arg0_86.cameras[var0_0.CAMERA.TALK].LookAt = arg1_86.ladyInterestRoot
	arg0_86.cameraGift.Follow = arg0_86.ladyInterest
	arg0_86.cameraGift.LookAt = arg0_86.ladyInterest
	arg0_86.cameraRole2.LookAt = arg1_86.ladyInterestRoot
	arg0_86.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_86.ladyInterest
	arg0_86.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_86.ladyInterest
end

function var0_0.initNodeCanvas(arg0_87)
	local var0_87 = pg.NodeCanvasMgr.GetInstance()

	var0_87:Active()
	var0_87:RegisterFunc("DistanceTrigger", function(arg0_88)
		arg0_87:emit(var0_0.DISTANCE_TRIGGER, arg0_88, arg0_87.ladyDict[arg0_88].dis)
	end)
	var0_87:RegisterFunc("ShortWaitAction", function(arg0_89)
		arg0_87:DoShortWait(arg0_89)
	end)
	var0_87:RegisterFunc("WatchShortWaitAction", function(arg0_90)
		arg0_87:DoShortWait(arg0_90)
	end)
	var0_87:RegisterFunc("WalkDistanceTrigger", function(arg0_91)
		arg0_87:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_91, arg0_87.ladyDict[arg0_91].dis)
	end)
	var0_87:RegisterFunc("ChangeWatch", function(arg0_92)
		arg0_87:emit(var0_0.CHANGE_WATCH, arg0_92)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_93, arg1_93, arg2_93)
	arg0_93[arg1_93] = arg2_93

	for iter0_93, iter1_93 in pairs(arg0_93.ladyDict) do
		arg0_93:SetBlackboardValue(iter1_93, arg1_93, arg2_93)
	end
end

function var0_0.SetBlackboardValue(arg0_94, arg1_94, arg2_94, arg3_94)
	arg1_94.blackboard = arg1_94.blackboard or {}
	arg1_94.blackboard[arg2_94] = arg3_94

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg2_94, arg3_94, arg1_94.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_95, arg1_95, arg2_95)
	arg1_95.blackboard = arg1_95.blackboard or {}

	return arg1_95.blackboard[arg2_95]
end

function var0_0.didEnter(arg0_96)
	local var0_96 = -21.6 / Screen.height

	arg0_96.joystickDelta = Vector2.zero
	arg0_96.joystickTimer = FrameTimer.New(function()
		local var0_97 = arg0_96.joystickDelta * var0_96
		local var1_97 = var0_97.x
		local var2_97 = var0_97.y

		local function var3_97(arg0_98, arg1_98, arg2_98)
			local var0_98 = arg0_98[arg1_98]

			var0_98.m_InputAxisValue = arg2_98
			arg0_98[arg1_98] = var0_98
		end

		if arg0_96.surroudCamera and not arg0_96.pinchMode then
			var3_97(arg0_96.surroudCamera, "m_XAxis", var1_97)
			var3_97(arg0_96.surroudCamera, "m_YAxis", var2_97)
		elseif arg0_96.furniturePOV and arg0_96.cameras[var0_0.CAMERA.FURNITURE_WATCH] and isActive(arg0_96.cameras[var0_0.CAMERA.FURNITURE_WATCH]) then
			var3_97(arg0_96.furniturePOV, "m_HorizontalAxis", var1_97)
			var3_97(arg0_96.furniturePOV, "m_VerticalAxis", var2_97)
		end

		arg0_96.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_96.joystickTimer:Start()

	local var1_96 = 1.75

	arg0_96.moveStickTimer = FrameTimer.New(function()
		if not arg0_96.moveStickDraging then
			return
		end

		local var0_99 = arg0_96.moveStickPosition
		local var1_99 = 200
		local var2_99 = (var0_99 - arg0_96.moveStickOrigin):ClampMagnitude(var1_99)
		local var3_99 = var2_99 / var1_99

		arg0_96.moveStickPosition = arg0_96.moveStickOrigin + var2_99

		local var4_99 = Vector3.New(var3_99.x, 0, var3_99.y)
		local var5_99 = arg0_96.mainCameraTF:TransformDirection(var4_99)

		var5_99.y = 0

		local var6_99 = var5_99:Normalize()

		var6_99:Mul(var1_96)

		if isActive(arg0_96.cameras[var0_0.CAMERA.POV]) then
			arg0_96.playerController:SimpleMove(var6_99)

			arg0_96.tweenFOV = true
		elseif isActive(arg0_96.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_96.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_99 * Time.deltaTime)
			arg0_96:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_99:Normalize())
			onNextTick(function()
				local var0_100 = arg0_96.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_100 = math.InverseLerp(arg0_96.restrictedHeightRange[1], arg0_96.restrictedHeightRange[2], var0_100.position.y)

				arg0_96:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_100)
			end)
		end
	end, 1, -1)

	arg0_96.moveStickTimer:Start()

	arg0_96.pinchMode = false
	arg0_96.pinchSize = 0
	arg0_96.pinchValue = 1
	arg0_96.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_101, arg1_101)
		if arg0_96.surroudCamera and isActive(arg0_96.surroudCamera) then
			arg0_96.pinchMode = true
			arg0_96.pinchSize = (arg0_101 - arg1_101):Magnitude()
			arg0_96.pinchNodeOrder = arg1_101.x < arg0_101.x and -1 or 1

			return
		end

		if isActive(arg0_96.cameras[var0_0.CAMERA.POV]) then
			if (arg0_101 - arg1_101):Magnitude() < Screen.height * 0.5 then
				arg0_96.pinchMode = true
				arg0_96.pinchSize = (arg0_101 - arg1_101):Magnitude()
				arg0_96.pinchNodeOrder = arg1_101.x < arg0_101.x and -1 or 1
			end

			return
		end
	end)

	local var2_96 = 0.01

	if IsUnityEditor then
		var2_96 = 0.1
	end

	local var3_96 = var2_96 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_102, arg1_102)
		if not arg0_96.pinchMode then
			return
		end

		local var0_102 = (arg0_102 - arg1_102):Magnitude()
		local var1_102 = arg0_96.pinchSize - var0_102
		local var2_102 = arg0_96.pinchNodeOrder * (arg1_102.x < arg0_102.x and -1 or 1)
		local var3_102 = var1_102 * var3_96 * var2_102

		if isActive(arg0_96.cameras[var0_0.CAMERA.POV]) then
			local var4_102 = 0.5
			local var5_102 = 1

			arg0_96.pinchValue = math.clamp(arg0_96.pinchValue + var3_102, var4_102, var5_102)
			arg0_96.pinchSize = var0_102

			arg0_96:SetPOVFOV(arg0_96.POVOriginalFOV * arg0_96.pinchValue)

			arg0_96.tweenFOV = nil

			return
		end

		if isActive(arg0_96.surroudCamera) and arg0_96.surroudCamera == arg0_96.cameras[var0_0.CAMERA.PHOTO] then
			local var6_102 = 0.5
			local var7_102 = 1

			arg0_96:SetPinchValue(math.clamp(arg0_96.pinchValue + var3_102, var6_102, var7_102))

			arg0_96.pinchSize = var0_102

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_96.pinchMode = false
		arg0_96.pinchSize = 0
	end)

	arg0_96.cameraBlendCallbacks = {}
	arg0_96.activeCMCamera = nil

	function arg0_96.camBrainEvenetHandler.OnBlendStarted(arg0_104)
		if arg0_96.activeCMCamera then
			arg0_96:OnCameraBlendFinished(arg0_96.activeCMCamera)
		end

		local var0_104 = arg0_96.camBrain.ActiveVirtualCamera

		arg0_96.activeCMCamera = var0_104
	end

	function arg0_96.camBrainEvenetHandler.OnBlendFinished(arg0_105)
		arg0_96.activeCMCamera = nil

		arg0_96:OnCameraBlendFinished(arg0_105)
	end

	for iter0_96, iter1_96 in pairs(arg0_96.ladyDict) do
		if iter1_96.tfPendintItem then
			onNextTick(function()
				setParent(iter1_96.tfPendintItem, iter1_96.lady)
			end)
		end

		iter1_96.ladyOwner = GetComponent(iter1_96.lady, "GraphOwner")
		iter1_96.ladyBlackboard = GetComponent(iter1_96.lady, "Blackboard")

		arg0_96:SetBlackboardValue(iter1_96, "groupId", iter0_96)
		onNextTick(function()
			iter1_96.ladyOwner.enabled = true
		end)
	end

	arg0_96.expressionDict = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_96.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_96:ActiveCamera(arg0_96.cameras[var0_0.CAMERA.POV])

	local var4_96
	local var5_96
	local var6_96 = arg0_96.resumeCallback

	function arg0_96.resumeCallback()
		var5_96 = true

		if var4_96 then
			existCall(var6_96)
		end
	end

	arg0_96:RefreshSlots(nil, function()
		var4_96 = true

		if var5_96 then
			existCall(var6_96)
		end
	end)

	arg0_96.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_96:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_96.updateHandler)
end

function var0_0.InitData(arg0_113)
	if not arg0_113.contextData.ladyZone then
		arg0_113.contextData.ladyZone = {}

		local var0_113
		local var1_113 = arg0_113.room:getConfig("default_zone")

		for iter0_113, iter1_113 in ipairs(arg0_113.contextData.groupIds) do
			for iter2_113, iter3_113 in ipairs(var1_113) do
				if iter3_113[1] == iter1_113 then
					arg0_113.contextData.ladyZone[iter1_113] = iter3_113[2]

					break
				end
			end

			assert(arg0_113.contextData.ladyZone[iter1_113])

			var0_113 = var0_113 or arg0_113.contextData.ladyZone[iter1_113]
		end

		arg0_113.contextData.inFurnitureName = var0_113 or var1_113[1][2]
	end

	arg0_113.zoneDatas = _.select(arg0_113.room:GetZones(), function(arg0_114)
		return not arg0_114:IsGlobal()
	end)
	arg0_113.activeSectors = {}
	arg0_113.activeLady = {}
end

function var0_0.Update(arg0_115)
	arg0_115.raycastCamera.fieldOfView = arg0_115.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_115.tweenFOV then
		local var0_115 = Damp(1, 1, Time.deltaTime)

		arg0_115.pinchValue = Mathf.Lerp(arg0_115.pinchValue, 1, var0_115)

		arg0_115:SetPOVFOV(arg0_115.POVOriginalFOV * arg0_115.pinchValue)

		if arg0_115.pinchValue > 0.99 then
			arg0_115.tweenFOV = nil
		end
	end

	if isActive(arg0_115.cameras[var0_0.CAMERA.POV]) then
		arg0_115:TriggerLadyDistance()
	end

	if arg0_115.contactInRangeDic then
		local var1_115 = arg0_115.mainCameraTF.forward
		local var2_115 = arg0_115.mainCameraTF.position
		local var3_115 = UnityEngine.Rect.New(0, 0, Screen.width, Screen.height)

		local function var4_115(arg0_116, arg1_116, arg2_116)
			local var0_116 = arg0_116.position - var2_115
			local var1_116 = Clone(var0_116)

			var1_116.y = 0

			if arg1_116 < var1_116.magnitude then
				return false
			end

			local var2_116 = var0_116:Normalize()
			local var3_116 = math.acos(Vector3.Dot(var2_116, var1_115)) * math.rad2Deg

			if arg2_116 < math.abs(var3_116) then
				return false
			end

			local var4_116 = arg0_115.raycastCamera:WorldToScreenPoint(arg0_116.position)

			if var4_116.z < 0 then
				return false
			end

			if not var3_115:Contains(var4_116) then
				return false
			end

			return true
		end

		for iter0_115, iter1_115 in pairs(arg0_115.contactInRangeDic) do
			local var5_115 = pg.dorm3d_collection_template[iter0_115]
			local var6_115 = underscore.any(var5_115.vfx_prefab, function(arg0_117)
				return arg0_115.modelRoot:Find(arg0_117) and var4_115(arg0_115.modelRoot:Find(arg0_117), 2, 60)
			end)

			if tobool(iter1_115) ~= var6_115 then
				arg0_115.contactInRangeDic[iter0_115] = var6_115

				arg0_115:UpdateContactDisplay(iter0_115, var6_115 and not arg0_115.hideConcatFlag and arg0_115.contactStateDic[iter0_115] or arg0_115.hideContactStateDic[iter0_115])
			end
		end
	end

	if arg0_115.enableFloatUpdate then
		arg0_115.ladyDict[arg0_115.apartment:GetConfigID()]:UpdateFloatPosition()
	end

	arg0_115:CheckInSector()

	if arg0_115.apartment then
		(function(arg0_118)
			(function()
				if not arg0_118.ikHandler then
					return
				end

				local var0_119 = arg0_118.ikHandler.screenPosition
				local var1_119 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_119 = var0_119 - Vector2.New(var1_119.width, var1_119.height) * 0.5

				setAnchoredPosition(arg0_115:GetIKHandTF(), var2_119)

				if Time.time > arg0_115.ikNextCheckStamp then
					arg0_115.ikNextCheckStamp = arg0_115.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_119 = _.detect(arg0_118.readyIKLayers, function(arg0_120)
						return arg0_120:GetControllerPath() == arg0_118.ikHandler.ikData:GetControllerPath()
					end)

					arg0_115:emit(var0_0.ON_IK_STATUS_CHANGED, var3_119:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_115.enableIKTip then
				local var0_118 = not arg0_115.blockIK and Time.time > arg0_115.nextTipIKTime

				if var0_118 then
					local var1_118 = _.filter(arg0_118.readyIKLayers, function(arg0_121)
						return not arg0_121.ignoreDrag
					end)

					UIItemList.StaticAlign(arg0_115.ikTipsRoot, arg0_115.ikTipsRoot:GetChild(0), #var1_118, function(arg0_122, arg1_122, arg2_122)
						if arg0_122 ~= UIItemList.EventUpdate then
							return
						end

						arg1_122 = arg1_122 + 1

						local var0_122
						local var1_122 = Vector2.zero
						local var2_122 = var1_118[arg1_122]
						local var3_122 = var2_122:GetTriggerBoneName()
						local var4_122 = var3_122 and arg0_118.IKSettings.Colliders[var3_122] or nil
						local var5_122 = var2_122:GetIKTipOffset()

						if var4_122 then
							local function var6_122()
								local var0_123 = arg0_118.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var4_122.position)
								local var1_123 = CameraMgr.instance:Raycast(arg0_118.IKSettings.CameraRaycaster, var0_123)

								if var1_123.Length == 0 then
									return
								end

								return var4_122 == var1_123[0].gameObject.transform
							end
						end

						if var4_122 then
							local var7_122 = var4_122.position
							local var8_122 = var4_122:GetComponent(typeof(UnityEngine.Collider))

							if var8_122 then
								var7_122 = var8_122.bounds.center
							end

							local var9_122 = arg0_115:GetLocalPosition(arg0_115:GetScreenPosition(var7_122, arg0_118.IKSettings.CameraRaycaster.eventCamera), arg0_115.ikTipsRoot) + var5_122

							setLocalPosition(arg2_122, var9_122)

							local var10_122 = var2_122:GetTriggerRect()
							local var11_122 = var10_122:PointToNormalized(Vector2.zero)
							local var12_122 = Vector2.zero

							if var11_122.x < 0.5 and var11_122.y < 0.5 then
								var12_122 = var10_122.max
							elseif var11_122.x >= 0.5 and var11_122.y < 0.5 then
								var12_122 = Vector2.New(var10_122.xMin, var10_122.yMax)
							elseif var11_122.x < 0.5 and var11_122.y >= 0.5 then
								var12_122 = Vector2.New(var10_122.xMax, var10_122.yMin)
							elseif var11_122.x >= 0.5 and var11_122.y >= 0.5 then
								var12_122 = var10_122.min
							end

							if var11_122.x == 0.5 then
								if var9_122.x < 0 then
									var12_122.x = var10_122.xMax
								else
									var12_122.x = var10_122.xMin
								end
							end

							if var11_122.y == 0.5 then
								if var9_122.y < 0 then
									var12_122.y = var10_122.yMax
								else
									var12_122.y = var10_122.yMin
								end
							end

							local var13_122 = var12_122 - var10_122.center

							setLocalRotation(arg2_122, Quaternion.LookRotation(Vector3.forward, Vector3.New(var13_122.x, var13_122.y, 0)))
						end

						setActive(arg2_122, var4_122)
					end)
					UIItemList.StaticAlign(arg0_115.ikClickTipsRoot, arg0_115.ikClickTipsRoot:GetChild(0), #arg0_118.iKTouchDatas, function(arg0_124, arg1_124, arg2_124)
						if arg0_124 ~= UIItemList.EventUpdate then
							return
						end

						arg1_124 = arg1_124 + 1

						local var0_124
						local var1_124 = Vector2.zero
						local var2_124 = arg1_124
						local var3_124 = arg0_118.iKTouchDatas[var2_124][1]
						local var4_124 = pg.dorm3d_ik_touch[var3_124]

						if #var4_124.scene_item > 0 then
							var0_124 = arg0_115:GetSceneItem(var4_124.scene_item)
						else
							var0_124 = arg0_118.IKSettings.Colliders[var4_124.body]
						end

						if var0_124 then
							local var5_124 = var0_124.position
							local var6_124 = var0_124:GetComponent(typeof(UnityEngine.Collider))

							if var6_124 then
								var5_124 = var6_124.bounds.center
							end

							setLocalPosition(arg2_124, arg0_115:GetLocalPosition(arg0_115:GetScreenPosition(var5_124, arg0_118.IKSettings.CameraRaycaster.eventCamera), arg0_115.ikClickTipsRoot) + var1_124)
						end

						setActive(arg2_124, var0_124)
					end)
				end

				setActive(arg0_115.ikTipsRoot, var0_118)
				setActive(arg0_115.ikClickTipsRoot, var0_118)
				setActive(arg0_115.ikTextTipsRoot, var0_118)
			end
		end)(arg0_115.ladyDict[arg0_115.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_125)
	if not isActive(arg0_125.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_125 = arg0_125.mainCameraTF.position

	var0_125.y = 0

	for iter0_125, iter1_125 in pairs(arg0_125.ladyDict) do
		local var1_125 = tobool(arg0_125.activeLady[iter0_125])

		if var1_125 ~= tobool(var0_0.IsPointInSector(arg0_125.activeSectors[iter1_125.ladyActiveZone], var0_125)) then
			arg0_125.activeLady[iter0_125] = not var1_125

			arg0_125:emit(var0_0.ON_ENTER_SECTOR, iter0_125)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_126)
	for iter0_126, iter1_126 in pairs(arg0_126.ladyDict) do
		iter1_126.dis = (iter1_126.lady.position - arg0_126.player.position).magnitude

		if (arg0_126:GetBlackboardValue(iter1_126, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_126.dis ~= arg0_126:GetBlackboardValue(iter1_126, "inDistance") then
			arg0_126:SetBlackboardValue(iter1_126, "inDistance", iter1_126.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_126:emit(var0_0.ON_CHANGE_DISTANCE, iter0_126, iter1_126.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end
end

function var0_0.OnStickMove(arg0_127, arg1_127)
	arg0_127.joystickDelta = arg1_127
end

function var0_0.SetPinchValue(arg0_128, arg1_128)
	arg0_128.pinchValue = arg1_128

	arg0_128:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_129)
	local var0_129 = arg0_129.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_129)
end

function var0_0.SetPOVFOV(arg0_130, arg1_130)
	local var0_130 = arg0_130.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_130, arg1_130)

	arg0_130.cameras[var0_0.CAMERA.POV].m_Lens = var0_130
end

function var0_0.RefreshSlots(arg0_131, arg1_131, arg2_131)
	arg1_131 = arg1_131 or arg0_131.room

	local var0_131 = arg1_131:GetSlots()
	local var1_131 = arg1_131:GetFurnitures()

	arg0_131:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_131, function(arg0_132, arg1_132, arg2_132)
		local var0_132 = arg1_132:GetConfigID()

		if not arg0_131.slotDict[var0_132] then
			return arg2_132()
		end

		local var1_132 = _.detect(var1_131, function(arg0_133)
			return arg0_133:GetSlotID() == var0_132
		end)
		local var2_132 = var1_132 and var1_132:GetModel() or false
		local var3_132 = arg0_131.slotDict[var0_132].model

		arg0_131.slotDict[var0_132].displayModelName = var2_132
		arg0_131.slotDict[var0_132].furnitureId = var1_132 and var1_132:GetConfigID()

		local function var4_132(arg0_134)
			if var3_132 then
				setActive(var3_132, var2_132 == "")
			end

			table.Foreach(arg0_131.slotDict[var0_132].sceneHides or {}, function(arg0_135, arg1_135)
				setActive(arg1_135.trans, arg1_135.visible)
			end)

			arg0_131.slotDict[var0_132].sceneHides = {}

			if arg0_134 then
				local var0_134 = arg0_134:getConfig("scene_hides")

				if #var0_134 > 0 then
					table.Ipairs(var0_134, function(arg0_136, arg1_136)
						local var0_136 = arg0_131.modelRoot:Find(arg1_136)

						assert(var0_136, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_134:GetConfigID(), arg1_136))

						local var1_136 = isActive(var0_136)

						table.insert(arg0_131.slotDict[var0_132].sceneHides, {
							name = arg1_136,
							trans = var0_136,
							visible = var1_136
						})
						setActive(var0_136, false)
					end)
				end
			end
		end

		if var2_132 == false or var2_132 == "" then
			arg0_131.loader:ClearRequest("slot_" .. var0_132)
			var4_132()
			arg2_132()

			return
		end

		local var5_132 = arg0_131.slotDict[var0_132].trans

		if arg0_131.loader:GetLoadingRP("slot_" .. var0_132) then
			arg0_131:emit(var0_0.HIDE_BLOCK)
		end

		arg0_131.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_132, "", function(arg0_137)
			arg2_132()
			assert(arg0_137)
			setParent(arg0_137, var5_132)
			var4_132(var1_132)
		end, "slot_" .. var0_132)
	end, function()
		arg0_131:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_131)
	end)
end

function var0_0.CheckSceneItemActiveByPath(arg0_139, arg1_139)
	local var0_139 = arg0_139:GetSceneItem(arg1_139)

	return arg0_139:CheckSceneItemActive(var0_139)
end

function var0_0.CheckSceneItemActive(arg0_140, arg1_140)
	local var0_140 = true
	local var1_140

	table.Checkout(arg0_140.slotDict, function(arg0_141, arg1_141)
		if underscore.detect(arg1_141.sceneHides, function(arg0_142)
			return arg0_142.trans == arg1_140
		end) then
			var0_140 = false
			var1_140 = arg1_141.furnitureId

			return false
		end
	end)

	return var0_140, var1_140
end

function var0_0.ChangeCharacterPosition(arg0_143, arg1_143)
	arg0_143:ResetCharPoint(arg1_143, arg1_143.ladyActiveZone)
	arg0_143:SyncInterestTransform(arg1_143)
end

function var0_0.SyncCurrentInterestTransform(arg0_144)
	local var0_144 = arg0_144.ladyDict[arg0_144.apartment:GetConfigID()]

	arg0_144:SyncInterestTransform(var0_144)
end

function var0_0.SyncInterestTransform(arg0_145, arg1_145)
	arg0_145.ladyInterest.position = arg1_145.ladyInterestRoot.position
	arg0_145.ladyInterest.rotation = arg1_145.ladyInterestRoot.rotation
end

function var0_0.SyncCurrentInterestSmooth(arg0_146, arg1_146)
	local var0_146 = arg0_146.ladyDict[arg0_146.apartment:GetConfigID()]

	arg1_146 = arg1_146 or 0.5

	arg0_146:managedTween(LeanTween.move, nil, arg0_146.ladyInterest.gameObject, var0_146.ladyInterestRoot.position, arg1_146)
	arg0_146:managedTween(LeanTween.rotate, nil, arg0_146.ladyInterest.gameObject, var0_146.ladyInterestRoot.rotation:ToEulerAngles(), arg1_146)
end

function var0_0.ChangePlayerPosition(arg0_147, arg1_147)
	arg1_147 = arg1_147 or arg0_147.contextData.inFurnitureName

	local var0_147 = arg0_147.furnitures:Find(arg1_147):Find("PlayerPoint").position

	arg0_147.player.position = var0_147
	arg0_147.cameras[var0_0.CAMERA.POV].transform.position = arg0_147.playerEye.position

	local var1_147 = arg0_147.ladyInterest.position - arg0_147.playerEye.position
	local var2_147 = Quaternion.LookRotation(var1_147).eulerAngles
	local var3_147 = var2_147.y
	local var4_147 = var2_147.x
	local var5_147 = arg0_147.compPovAim.m_HorizontalAxis

	var5_147.Value = arg0_147:GetNearestAngle(var3_147, var5_147.m_MinValue, var5_147.m_MaxValue)
	arg0_147.compPovAim.m_HorizontalAxis = var5_147

	local var6_147 = arg0_147.compPovAim.m_VerticalAxis

	var6_147.Value = var4_147
	arg0_147.compPovAim.m_VerticalAxis = var6_147
end

function var0_0.GetAttachedFurnitureName(arg0_148)
	return arg0_148.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_149, arg1_149)
	return underscore.detect(arg0_149.attachedPoints, function(arg0_150)
		return arg0_150.name == arg1_149
	end)
end

function var0_0.GetSlotByID(arg0_151, arg1_151)
	return arg0_151.displaySlots[arg1_151] and arg0_151.displaySlots[arg1_151].trans
end

function var0_0.GetScreenPosition(arg0_152, arg1_152, arg2_152)
	arg2_152 = arg2_152 or arg0_152.raycastCamera

	local var0_152 = arg2_152:WorldToScreenPoint(arg1_152)

	if var0_152.z < 0 then
		var0_152.x = var0_152.x + (var0_152.x < 0 and -1 or 1) * Screen.width
		var0_152.y = var0_152.y + (var0_152.y < 0 and -1 or 1) * Screen.height
		var0_152.z = -var0_152.z
	end

	return var0_152
end

function var0_0.GetLocalPosition(arg0_153, arg1_153, arg2_153)
	return LuaHelper.ScreenToLocal(arg2_153, arg1_153, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_154)
	return arg0_154.modelRoot
end

function var0_0.ShiftZone(arg0_155, arg1_155, arg2_155)
	local var0_155 = arg0_155:GetFurnitureByName(arg1_155)

	if not var0_155 then
		errorMsg(arg1_155 .. " Not Find")
		existCall(arg2_155)

		return
	end

	seriesAsync({
		function(arg0_156)
			arg0_155:emit(var0_0.SHOW_BLOCK)
			arg0_155:ShowBlackScreen(true, arg0_156)
		end,
		function(arg0_157)
			if arg0_155.shiftLady or arg0_155.room:isPersonalRoom() then
				local var0_157 = arg0_155.shiftLady or arg0_155.apartment:GetConfigID()

				arg0_155.shiftLady = nil
				arg0_155.contextData.ladyZone[var0_157] = var0_155.name

				local var1_157 = arg0_155.ladyDict[var0_157]

				var1_157.ladyBaseZone = arg0_155.contextData.ladyZone[var0_157]
				var1_157.ladyActiveZone = arg0_155.contextData.ladyZone[var0_157]

				if arg0_155:GetBlackboardValue(var1_157, "inPending") then
					arg0_155:SetOutPending(var1_157)
					arg0_155:SwitchAnim(var1_157, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_155:ChangeCharacterPosition(var1_157)
						arg0_157()
					end)
				else
					arg0_155:ChangeCharacterPosition(var1_157)
					arg0_157()
				end
			else
				arg0_157()
			end
		end,
		function(arg0_159)
			arg0_155.contextData.inFurnitureName = var0_155.name

			if not arg0_155.apartment then
				for iter0_159, iter1_159 in pairs(arg0_155.ladyDict) do
					if iter1_159.ladyBaseZone == arg0_155.contextData.inFurnitureName then
						arg0_155:SyncInterestTransform(iter1_159)

						break
					end
				end
			end

			arg0_155:ChangePlayerPosition()
			arg0_155:TriggerLadyDistance()
			arg0_155:CheckInSector()
			arg0_159()
		end,
		function(arg0_160)
			arg0_155:UpdateZoneList()
			arg0_155:ShowBlackScreen(false, arg0_160)
		end,
		function(arg0_161)
			arg0_155:emit(var0_0.HIDE_BLOCK)
			arg0_161()
		end
	}, arg2_155)
end

function var0_0.ActiveCamera(arg0_162, arg1_162)
	local var0_162 = isActive(arg1_162)

	table.Foreach(arg0_162.cameras, function(arg0_163, arg1_163)
		setActive(arg1_163, arg1_163 == arg1_162)
	end)

	if var0_162 then
		arg0_162:OnCameraBlendFinished(arg1_162)
	end
end

function var0_0.ShowBlackScreen(arg0_164, arg1_164, arg2_164)
	local var0_164 = arg0_164.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_164 and 0 or 0.3
	}

	setImageColor(arg0_164.blackLayer, Color.NewHex(var0_164.color))
	setActive(arg0_164.blackLayer, true)
	setCanvasGroupAlpha(arg0_164.blackLayer, arg1_164 and 0 or 1)
	arg0_164:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_164 then
			setActive(arg0_164.blackLayer, false)
		end

		existCall(arg2_164)
	end, GetComponent(arg0_164.blackLayer, typeof(CanvasGroup)), arg1_164 and 1 or 0, var0_164.time):setDelay(var0_164.delay)
end

function var0_0.RegisterOrbits(arg0_166, arg1_166)
	arg0_166 = arg0_166.scene
	arg0_166.orbits = {
		original = arg1_166.m_Orbits
	}
	arg0_166.orbits.current = _.range(3):map(function(arg0_167)
		local var0_167 = arg0_166.orbits.original[arg0_167 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_167.m_Height, var0_167.m_Radius)
	end)
	arg0_166.surroudCamera = arg1_166
end

function var0_0.SetCameraObrits(arg0_168)
	arg0_168 = arg0_168.scene

	local var0_168 = arg0_168.surroudCamera

	if not var0_168 then
		return
	end

	local var1_168 = arg0_168.orbits.original[1]

	for iter0_168 = 0, #arg0_168.orbits.current - 1 do
		local var2_168 = arg0_168.orbits.current[iter0_168 + 1]
		local var3_168 = arg0_168.orbits.original[iter0_168]

		var2_168.m_Height = math.lerp(var1_168.m_Height, var3_168.m_Height, arg0_168.pinchValue)
		var2_168.m_Radius = var3_168.m_Radius * arg0_168.pinchValue
	end

	var0_168.m_Orbits = arg0_168.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_169)
	arg0_169 = arg0_169.scene

	local var0_169 = arg0_169.surroudCamera

	if not var0_169 then
		return
	end

	for iter0_169 = 0, #arg0_169.orbits.current - 1 do
		local var1_169 = arg0_169.orbits.current[iter0_169 + 1]
		local var2_169 = arg0_169.orbits.original[iter0_169]

		var1_169.m_Height = var2_169.m_Height
		var1_169.m_Radius = var2_169.m_Radius
	end

	var0_169.m_Orbits = arg0_169.orbits.current
	arg0_169.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_170, arg1_170, arg2_170)
	local var0_170 = {
		base = function(arg0_171)
			arg0_170:RegisterCameraBlendFinished(arg0_170.cameras[var0_0.CAMERA.POV], arg0_171)
			arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_172)
			assert(arg0_170.apartment)
			arg0_170:SyncInterestTransform(arg0_170.ladyDict[arg0_170.apartment:GetConfigID()])
			arg0_170:SetCameraLady(arg0_170.ladyDict[arg0_170.apartment:GetConfigID()])
			arg0_170:RegisterCameraBlendFinished(arg0_170.cameras[var0_0.CAMERA.ROLE], arg0_172)
			arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_173)
			arg0_170:RegisterCameraBlendFinished(arg0_170.cameras[var0_0.CAMERA.POV], arg0_173)
			arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_174)
			arg0_174()
		end,
		gift = function(arg0_175)
			assert(arg0_170.apartment)
			arg0_170:SetCameraLady(arg0_170.ladyDict[arg0_170.apartment:GetConfigID()])
			arg0_170:RegisterCameraBlendFinished(arg0_170.cameras[var0_0.CAMERA.GIFT], arg0_175)
			arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_176)
			assert(arg0_170.apartment)
			arg0_170:SetCameraLady(arg0_170.ladyDict[arg0_170.apartment:GetConfigID()])

			arg0_170.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_170.cameraRole.transform.position

			arg0_170:RegisterCameraBlendFinished(arg0_170.cameras[var0_0.CAMERA.ROLE2], arg0_176)
			arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_177)
			assert(arg0_170.apartment)
			arg0_170:SetCameraLady(arg0_170.ladyDict[arg0_170.apartment:GetConfigID()])
			arg0_170:SyncInterestTransform(arg0_170.ladyDict[arg0_170.apartment:GetConfigID()])
			arg0_170:RegisterCameraBlendFinished(arg0_170.cameras[var0_0.CAMERA.TALK], arg0_177)
			arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_170 = {}

	table.insert(var1_170, function(arg0_178)
		switch(arg1_170, var0_170, arg0_178, arg0_178)
	end)
	seriesAsync(var1_170, arg2_170)
end

function var0_0.GetSceneItem(arg0_179, arg1_179)
	local var0_179

	if string.find(arg1_179, "fbx/") == 1 then
		var0_179 = arg0_179.modelRoot:Find(arg1_179)
	elseif string.find(arg1_179, "FurnitureSlots/") == 1 then
		arg1_179 = string.gsub(arg1_179, "^FurnitureSlots/", "", 1)
		var0_179 = arg0_179.slotRoot:Find(arg1_179)
	end

	if not var0_179 then
		warning(string.format("Missing scene item path: %s", arg1_179))
	end

	return var0_179
end

function var0_0.SetIKStatus(arg0_180, arg1_180, arg2_180, arg3_180)
	warning("Set IKStatus " .. (arg2_180.id or "NIL"))

	arg0_180.enableIKTip = true

	arg0_180:ResetIKTipTimer()
	setActive(arg1_180.ladyCollider, false)
	_.each(arg1_180.ladyTouchColliders, function(arg0_181)
		setActive(arg0_181, true)
	end)

	arg0_180.blockIK = nil
	arg1_180.ikActionDict = {}
	arg1_180.readyIKLayers = {}
	arg1_180.iKTouchDatas = arg2_180.touch_data or {}
	arg1_180.IKSettings = {
		Colliders = arg1_180.ladyColliders,
		CameraRaycaster = arg0_180.sceneRaycaster
	}

	local var0_180 = table.shallowCopy(arg2_180.ik_id)
	local var1_180 = {}

	_.each(arg1_180.iKTouchDatas, function(arg0_182)
		local var0_182 = arg0_182[3]

		if var0_182[1] == 7 then
			local var1_182 = pg.dorm3d_ik_touch_move[var0_182[2]]
			local var2_182 = var1_182.target_ik

			if not _.detect(var0_180, function(arg0_183)
				return arg0_183[1] == var2_182
			end) then
				var1_180[var2_182] = {
					back_time = var1_182.back_time
				}

				local var3_182 = {
					var2_182,
					0,
					{}
				}

				if var1_182.trigger_dialogue > 0 then
					var3_182[3] = {
						4,
						0,
						var1_182.trigger_dialogue
					}
				end

				table.insert(var0_180, var3_182)
			end
		end
	end)

	local var2_180 = _.map(var0_180, function(arg0_184)
		local var0_184 = Dorm3dIK.New({
			configId = arg0_184[1]
		})
		local var1_184 = arg0_184[3]
		local var2_184 = var1_184[1]
		local var3_184 = switch(var2_184, {
			function(arg0_185, arg1_185)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_187, arg1_187)
				return arg0_187
			end,
			function(arg0_188, arg1_188)
				return arg0_188
			end,
			function(arg0_189, arg1_189, arg2_189, arg3_189)
				return arg0_189
			end,
			function(arg0_190)
				return 0
			end
		}, function(arg0_191)
			return type(arg0_191) == "number" and arg0_191 or 0
		end, unpack(var1_184, 2))

		table.insert(arg1_180.readyIKLayers, var0_184)

		arg1_180.ikActionDict[var0_184:GetControllerPath()] = var1_184

		local var4_184 = var0_184:GetRevertTime()
		local var5_184 = var1_180[var0_184:GetConfigID()]
		local var6_184 = tobool(var5_184)

		if var6_184 then
			var3_184 = var5_184.back_time
			var4_184 = var5_184.back_time
			var0_184.ignoreDrag = true
		end

		local var7_184 = var0_184:GetSubTargets()
		local var8_184 = var0_184:GetPlaneRotations()
		local var9_184 = var0_184:GetPlaneScales()
		local var10_184 = _.map(_.range(#var7_184), function(arg0_192)
			return {
				name = var7_184[arg0_192][1],
				planeRot = var8_184[arg0_192],
				planeScale = var9_184[arg0_192]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_184:getConfig("trigger_param")[2],
			controllerName = var0_184:GetControllerPath(),
			subTargets = var10_184,
			actionType = var0_184:GetActionTriggerParams()[1],
			controlRect = var0_184:GetRect(),
			actionRect = var0_184:GetTriggerRect(),
			backTime = var4_184,
			actionRevertTime = var3_184,
			ignoreDrag = var6_184
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_180.ladyIKRoot, arg1_180.ladyBoneMaps)
	arg0_180:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_180)

	local var3_180 = _.map(arg1_180.iKTouchDatas, function(arg0_193)
		return arg0_193[1]
	end)

	table.Foreach(var3_180, function(arg0_194, arg1_194)
		local var0_194 = pg.dorm3d_ik_touch[arg1_194]

		if #var0_194.scene_item == 0 then
			return
		end

		local var1_194 = arg0_180:GetSceneItem(var0_194.scene_item)

		if not var1_194 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_194, var0_194.scene_item))

			return
		end

		if IsNil(GetComponent(var1_194, typeof(UnityEngine.Collider))) then
			go(var1_194):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_194 = GetOrAddComponent(var1_194, typeof(EventTriggerListener))

		var2_194.enabled = true

		var2_194:AddPointClickFunc(function()
			arg0_180.blockIK = true

			local var0_195 = arg1_180.iKTouchDatas[arg0_194]
			local var1_195, var2_195, var3_195 = unpack(var0_195)

			arg0_180:TouchModeAction(arg1_180, var1_195, unpack(var3_195))(function()
				arg0_180.enableIKTip = true

				arg0_180:ResetIKTipTimer()

				arg0_180.blockIK = nil
			end)
		end)
	end)

	arg0_180.camBrain.enabled = false

	if arg0_180.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_180.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_180.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var4_180 = arg0_180.cameraRoot:Find(arg2_180.ik_camera)

	assert(var4_180, "Missing IKCamera")

	arg0_180.cameras[var0_0.CAMERA.IK_WATCH] = var4_180

	arg0_180:ActiveCamera(arg0_180.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_180.camBrain.enabled = true

	local var5_180 = var4_180:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_180 then
		arg0_180:RegisterOrbits(var5_180)
	else
		arg0_180:RevertCameraOrbit()
	end

	arg0_180:SwitchAnim(arg1_180, arg2_180.character_action)
	arg0_180:SettingHeadAimIK(arg1_180, arg2_180.head_track)
	arg0_180:EnableCloth(arg1_180, false)
	arg0_180:EnableCloth(arg1_180, arg2_180.use_cloth, arg2_180.cloth_colliders)
	;(function()
		local var0_197 = arg2_180.enter_scene_anim
		local var1_197 = {}

		if var0_197 and #var0_197 > 0 then
			table.Ipairs(var0_197, function(arg0_198, arg1_198)
				arg0_180:PlaySceneItemAnim(arg1_198[1], arg1_198[2])
				table.insert(var1_197, arg1_198[1])
			end)
		end

		arg0_180:ResetSceneItemAnimators(var1_197)
	end)()
	;(function()
		local var0_199 = arg2_180.enter_extra_item
		local var1_199 = {}

		if var0_199 and #var0_199 > 0 then
			table.Ipairs(var0_199, function(arg0_200, arg1_200)
				local var0_200 = arg1_200[3] and Vector3.New(unpack(arg1_200[3]))
				local var1_200 = arg1_200[4] and Quaternion.Euler(unpack(arg1_200[4]))

				arg0_180:LoadCharacterExtraItem(arg1_180, arg1_200[1], arg1_200[2], var0_200, var1_200)
				table.insert(var1_199, arg1_200[1])
			end)
		end

		arg0_180:ResetCharacterExtraItem(arg1_180, var1_199)
	end)()
	eachChild(arg0_180.ikTextTipsRoot, function(arg0_201)
		setActive(arg0_201, false)
	end)
	_.each(arg1_180.readyIKLayers, function(arg0_202)
		local var0_202 = arg0_202:getConfig("tip_text")

		if not var0_202 or #var0_202 == 0 then
			return
		end

		local var1_202 = arg0_180.ikTextTipsRoot:Find(var0_202)

		if not IsNil(var1_202) then
			setActive(var1_202, true)
		end
	end)
	onNextTick(function()
		local var0_203 = arg0_180.furnitures:Find(arg2_180.character_position)

		arg1_180.lady.position = var0_203:Find("StayPoint").position
		arg1_180.lady.rotation = var0_203:Find("StayPoint").rotation

		existCall(arg3_180)
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

	local var0_204 = _.map(arg1_204.iKTouchDatas, function(arg0_206)
		return arg0_206[1]
	end)

	table.Foreach(var0_204, function(arg0_207, arg1_207)
		local var0_207 = pg.dorm3d_ik_touch[arg1_207]

		if #var0_207.scene_item == 0 then
			return
		end

		local var1_207 = arg0_204.modelRoot:Find(var0_207.scene_item)

		if not var1_207 then
			return
		end

		local var2_207 = GetOrAddComponent(var1_207, typeof(EventTriggerListener))

		var2_207:ClearEvents()

		var2_207.enabled = false
	end)

	arg1_204.ikActionDict = nil
	arg1_204.readyIKLayers = nil
	arg1_204.iKTouchDatas = nil

	arg0_204:RevertCameraOrbit()
	setActive(arg0_204.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_204.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_204:EnableCloth(arg1_204, false)
	arg0_204:ResetHeadAimIK(arg1_204)
	arg0_204:SwitchAnim(arg1_204, arg2_204.character_action)
	arg0_204:ResetSceneItemAnimators()
	arg0_204:ResetCharacterExtraItem(arg1_204)
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

		child = tf(arg1_210)

		local var0_210 = child.name
		local var1_210 = var0_210 and string.find(var0_210, "Collider") or -1

		if var1_210 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_210)

			return
		end

		local var2_210 = string.sub(var0_210, 1, var1_210 - 1)

		if var2_210 == "Body" or var2_210 == "Safe" then
			setActive(child, false)

			return
		end

		if var0_0.BONE_TO_TOUCH[var2_210] == nil then
			return
		end

		var1_209[var2_210] = child

		setActive(child, true)
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

	table.Foreach(var1_0, function(arg0_213, arg1_213)
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

function var0_0.EnableIKLayer(arg0_218, arg1_218)
	local var0_218 = arg0_218.ladyDict[arg0_218.apartment:GetConfigID()]

	if #arg1_218:GetHeadTrackPath() > 0 then
		arg0_218:SettingHeadAimIK(var0_218, {
			2,
			arg1_218:GetHeadTrackPath()
		}, true)
	end

	local var1_218 = arg1_218:GetTriggerFaceAnim()

	if #var1_218 > 0 then
		arg0_218:PlayFaceAnim(var0_218, var1_218)
	end

	if not arg1_218.ignoreDrag then
		setActive(arg0_218:GetIKHandTF(), true)
		eachChild(arg0_218:GetIKHandTF(), function(arg0_219)
			setActive(arg0_219, false)
		end)
		arg0_218:StopIKHandTimer()
		setActive(arg0_218:GetIKHandTF():Find("Begin"), true)

		arg0_218.ikHandTimer = Timer.New(function()
			setActive(arg0_218:GetIKHandTF():Find("Begin"), false)
			setActive(arg0_218:GetIKHandTF():Find("Normal"), true)
		end, 0.5, 1)

		arg0_218.ikHandTimer:Start()
	end

	if not var0_218.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_218.apartment.configId, arg0_218.apartment.level, var0_218.ikConfig.character_action, arg1_218:GetTriggerParams()[2], arg0_218.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_221, arg1_221)
	local var0_221 = arg0_221.ladyDict[arg0_221.apartment:GetConfigID()]

	if not var0_221.ikTimelineMode and #arg1_221:GetHeadTrackPath() > 0 then
		arg0_221:SettingHeadAimIK(var0_221, var0_221.ikConfig.head_track)
	end

	arg0_221:StopIKHandTimer()

	if not arg1_221.ignoreDrag then
		setActive(arg0_221:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_221:GetIKHandTF():Find("Normal"), false)
		setActive(arg0_221:GetIKHandTF():Find("End"), true)

		arg0_221.ikHandTimer = Timer.New(function()
			setActive(arg0_221:GetIKHandTF():Find("End"), false)
			setActive(arg0_221:GetIKHandTF(), false)
		end, 0.5, 1)

		arg0_221.ikHandTimer:Start()
	end
end

function var0_0.StopIKHandTimer(arg0_223)
	if not arg0_223.ikHandTimer then
		return
	end

	arg0_223.ikHandTimer:Stop()

	arg0_223.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_224, arg1_224, arg2_224, arg3_224)
	local var0_224 = Time.time

	function arg0_224.ikRevertHandler()
		local var0_225 = Time.time - var0_224

		_.each(arg1_224.activeIKLayers, function(arg0_226)
			local var0_226 = 1

			if arg2_224 > 0 then
				var0_226 = var0_225 / arg2_224
			end

			local var1_226 = arg1_224.cacheIKInfos[arg0_226].solvers
			local var2_226 = arg1_224.cacheIKInfos[arg0_226].weights

			table.Foreach(var1_226, function(arg0_227, arg1_227)
				arg1_227.IKPositionWeight = math.lerp(var2_226[arg0_227], 0, var0_226)
			end)
		end)

		if var0_225 >= arg2_224 then
			arg0_224:ResetActiveIKs(arg1_224)

			arg0_224.ikRevertHandler = nil

			existCall(arg3_224)
		end
	end

	arg0_224.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_228, arg1_228)
	table.insertto(arg0_228.activeIKLayers, _.keys(arg0_228.holdingStatus))
	table.clear(arg0_228.holdingStatus)
	_.each(arg1_228.activeIKLayers, function(arg0_229)
		local var0_229 = arg0_229:GetControllerPath()
		local var1_229 = arg1_228.ladyIKRoot:Find(var0_229):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_229, false)

		local var2_229 = arg1_228.cacheIKInfos[arg0_229].solvers
		local var3_229 = arg1_228.cacheIKInfos[arg0_229].weights

		table.Foreach(var2_229, function(arg0_230, arg1_230)
			arg1_230.IKPositionWeight = var3_229[arg0_230]
		end)
	end)
	table.clear(arg1_228.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_231)
	if not arg0_231.enableIKTip then
		return
	end

	arg0_231.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_232, arg1_232)
	local var0_232 = arg0_232.ladyDict[arg0_232.apartment:GetConfigID()]

	arg0_232:EnableHeadIK(var0_232, arg1_232)
end

function var0_0.EnableHeadIK(arg0_233, arg1_233, arg2_233)
	arg1_233.ladyHeadIKComp.enableIk = arg2_233
end

function var0_0.SettingHeadAimIK(arg0_234, arg1_234, arg2_234, arg3_234)
	local var0_234

	if arg2_234[1] == 1 then
		var0_234 = arg0_234.mainCameraTF:Find("AimTarget")
	elseif arg2_234[1] == 2 then
		table.IpairsCArray(arg1_234.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_235, arg1_235)
			if arg1_235.name ~= arg2_234[2] then
				return
			end

			var0_234 = arg1_235
		end)
	end

	arg1_234.ladyHeadIKComp.AimTarget = var0_234

	if not arg3_234 and arg2_234[3] then
		arg1_234.ladyHeadIKComp.BodyWeight = arg2_234[3]
	end

	if not arg3_234 and arg2_234[4] then
		arg1_234.ladyHeadIKComp.HeadWeight = arg2_234[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_236, arg1_236)
	arg1_236.ladyHeadIKComp.AimTarget = arg0_236.mainCameraTF:Find("AimTarget")
	arg1_236.ladyHeadIKComp.HeadWeight = arg1_236.ladyHeadIKData.HeadWeight
	arg1_236.ladyHeadIKComp.BodyWeight = arg1_236.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_237, arg1_237)
	for iter0_237, iter1_237 in pairs(arg0_237.ladyDict) do
		if iter0_237 ~= arg1_237 then
			arg0_237:HideCharacterBylayer(iter1_237)
		end
	end
end

function var0_0.RevertCharacter(arg0_238, arg1_238)
	for iter0_238, iter1_238 in pairs(arg0_238.ladyDict) do
		if iter0_238 ~= arg1_238 then
			arg0_238:RevertCharacterBylayer(iter1_238)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_239, arg1_239)
	local var0_239 = "Bip001"
	local var1_239 = arg1_239.lady:Find("all")

	for iter0_239 = 0, var1_239.childCount - 1 do
		local var2_239 = var1_239:GetChild(iter0_239)

		if var2_239.name ~= var0_239 then
			pg.ViewUtils.SetLayer(var2_239, Layer.Environment3D)
		end
	end

	if arg1_239.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_239.tfPendintItem, Layer.Environment3D)
	end

	if arg1_239.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_239.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg1_239.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_240, arg1_240)
	local var0_240 = "Bip001"
	local var1_240 = arg1_240.lady:Find("all")

	for iter0_240 = 0, var1_240.childCount - 1 do
		local var2_240 = var1_240:GetChild(iter0_240)

		if var2_240.name ~= var0_240 then
			pg.ViewUtils.SetLayer(var2_240, Layer.Default)
		end
	end

	if arg1_240.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_240.tfPendintItem, Layer.Default)
	end

	if arg1_240.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_240.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg1_240.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_241)
	arg0_241:SetAllBlackbloardValue("inLockLayer", true)
	arg0_241:EnableJoystick(true)
	arg0_241:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_242, arg1_242)
	arg0_242:HideFurnitureSlots()

	local var0_242 = arg0_242.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_243)
			arg0_242.furniturePOV = nil

			arg0_242:EnableJoystick(false)
			arg0_242:emit(var0_0.SHOW_BLOCK)
			arg0_242:ShowBlackScreen(true, arg0_243)
		end,
		function(arg0_244)
			existCall(arg1_242)
			arg0_242:RevertCharacter()
			arg0_242:SetAllBlackbloardValue("inLockLayer", false)
			arg0_242:RegisterCameraBlendFinished(var0_242, arg0_244)
			arg0_242:ActiveCamera(var0_242)
		end,
		function(arg0_245)
			arg0_242:ShowBlackScreen(false, arg0_245)
		end
	}, function()
		arg0_242:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_242:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_247, arg1_247)
	local var0_247 = arg0_247:GetFurnitureByName(arg1_247:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_247.cameraFurnitureWatch and arg0_247.cameraFurnitureWatch ~= var0_247 then
		arg0_247:UnRegisterCameraBlendFinished(arg0_247.cameraFurnitureWatch)
		setActive(arg0_247.cameraFurnitureWatch, false)
	end

	arg0_247.cameraFurnitureWatch = var0_247
	arg0_247.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_247.cameraFurnitureWatch
	arg0_247.furniturePOV = arg0_247.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_247:RegisterCameraBlendFinished(arg0_247.cameraFurnitureWatch, function()
		arg0_247:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_247:emit(var0_0.SHOW_BLOCK)
	arg0_247:ActiveCamera(arg0_247.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_249)
	if arg0_249.displaySlots then
		arg0_249:UpdateDisplaySlots({})
		table.Foreach(arg0_249.displaySlots, function(arg0_250, arg1_250)
			local var0_250 = arg1_250.trans

			if IsNil(var0_250:Find("Selector")) then
				return
			end

			setActive(var0_250:Find("Selector"), false)
		end)

		arg0_249.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_251, arg1_251)
	arg0_251:HideFurnitureSlots()

	arg0_251.displaySlots = {}

	_.each(arg1_251, function(arg0_252)
		arg0_251.displaySlots[arg0_252] = arg0_251.slotDict[arg0_252]

		if not arg0_251.displaySlots[arg0_252] then
			errorMsg("Slot " .. arg0_252 .. " Not Binding Scene Object")

			return
		end

		local var0_252 = arg0_251.displaySlots[arg0_252].trans

		if var0_252:Find("Selector") then
			setActive(var0_252:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_253, arg1_253)
	table.Foreach(arg0_253.displaySlots, function(arg0_254, arg1_254)
		local var0_254 = arg1_254.trans

		if not IsNil(var0_254:Find("Selector")) then
			setActive(var0_254:Find("Selector/Normal"), arg1_253[arg0_254] == 0)
			setActive(var0_254:Find("Selector/Active"), arg1_253[arg0_254] == 1)
			setActive(var0_254:Find("Selector/Ban"), arg1_253[arg0_254] == 2)
		end

		local var1_254 = arg0_253.slotDict[arg0_254].model
		local var2_254 = arg0_253.slotDict[arg0_254].displayModelName

		if var2_254 and var2_254 ~= "" then
			var1_254 = var0_254:GetChild(var0_254.childCount - 1)
		end

		local function var3_254(arg0_255, arg1_255)
			local var0_255 = arg0_255:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_255, function(arg0_256, arg1_256)
				local var0_256 = arg1_256.material

				if var0_256 and var0_256:HasProperty("_FinalTint") then
					var0_256:SetColor("_FinalTint", arg1_255)
				end
			end)
		end

		if var1_254 then
			if arg1_253[arg0_254] == 1 then
				var3_254(var1_254, Color.NewHex("3F83AE73"))
			else
				var3_254(var1_254, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_257, arg1_257, arg2_257)
	arg0_257:SetAllBlackbloardValue("inLockLayer", true)
	arg0_257:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_258)
			arg0_257:TempHideUI(true, arg0_258)
		end,
		function(arg0_259)
			arg0_257:ShowBlackScreen(true, arg0_259)
		end,
		function(arg0_260)
			local var0_260 = arg0_257.apartment:GetConfigID()
			local var1_260 = arg0_257.ladyDict[var0_260]

			arg0_257:SwitchAnim(var1_260, arg2_257)
			var1_260.ladyAnimator:Update(0)
			var1_260:ResetCharPoint(var1_260, arg1_257:GetWatchCameraName())
			arg0_257:SyncInterestTransform(var1_260)
			setActive(var1_260.ladySafeCollider, true)
			arg0_257:HideCharacter(var0_260)

			local var2_260 = arg0_257.cameras[var0_0.CAMERA.PHOTO]
			local var3_260 = var2_260.m_XAxis

			var3_260.Value = 180
			var2_260.m_XAxis = var3_260

			local var4_260 = var2_260.m_YAxis

			var4_260.Value = 0.7
			var2_260.m_YAxis = var4_260
			arg0_257.pinchValue = 1

			arg0_257:RegisterOrbits(arg0_257.cameras[var0_0.CAMERA.PHOTO])
			arg0_257:SetCameraObrits()
			arg0_257:RegisterCameraBlendFinished(var2_260, arg0_260)
			arg0_257:ActiveCamera(var2_260)
		end,
		function(arg0_261)
			arg0_257:ShowBlackScreen(false, arg0_261)
		end
	}, function()
		arg0_257:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_263)
	arg0_263:emit(var0_0.SHOW_BLOCK)
	arg0_263:EnableJoystick(false)
	seriesAsync({
		function(arg0_264)
			arg0_263:ShowBlackScreen(true, arg0_264)
		end,
		function(arg0_265)
			arg0_263:RevertCameraOrbit()

			local var0_265 = arg0_263.ladyDict[arg0_263.apartment:GetConfigID()]

			arg0_263:SwitchAnim(var0_265, var0_0.ANIM.IDLE)
			setActive(var0_265.ladySafeCollider, false)
			onNextTick(function()
				arg0_263:ChangeCharacterPosition(var0_265)
			end)

			if arg0_263.contextData.photoFreeMode then
				arg0_263:EnablePOVLayer(false)
				setActive(arg0_263.restrictedBox, false)

				arg0_263.contextData.photoFreeMode = nil
			end

			local var1_265 = arg0_263.cameras[var0_0.CAMERA.POV]

			arg0_263:RegisterCameraBlendFinished(var1_265, arg0_265)
			arg0_263:ActiveCamera(var1_265)
		end,
		function(arg0_267)
			arg0_263:RevertCharacter(arg0_263.apartment:GetConfigID())
			arg0_263:ShowBlackScreen(false, arg0_267)
		end
	}, function()
		arg0_263:RefreshSlots()
		arg0_263:SetAllBlackbloardValue("inLockLayer", false)
		arg0_263:emit(var0_0.HIDE_BLOCK)
		arg0_263:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_263:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_269, arg1_269, arg2_269, arg3_269)
	arg0_269:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_270)
			arg0_269:ShowBlackScreen(true, arg0_270)
		end,
		function(arg0_271)
			local var0_271 = arg0_269.ladyDict[arg0_269.apartment:GetConfigID()]

			arg0_269:SwitchAnim(var0_271, arg2_269)
			onNextTick(function()
				arg0_269:ResetCharPoint(var0_271, arg1_269:GetWatchCameraName())
				arg0_269:SyncInterestTransform(var0_271)

				if arg0_269.contextData.photoFreeMode then
					arg0_269.camBrain.enabled = false

					arg0_269:SwitchPhotoCamera()

					arg0_269.camBrain.enabled = true

					onDelayTick(function()
						arg0_269.camBrain.enabled = false

						arg0_269:SwitchPhotoCamera()

						arg0_269.camBrain.enabled = true
					end, 0.1)
				end

				arg0_271()
			end)
		end,
		function(arg0_274)
			arg0_269:ShowBlackScreen(false, arg0_274)
		end
	}, function()
		arg0_269:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_269)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_276)
	if not arg0_276.contextData.photoFreeMode then
		arg0_276:EnableJoystick(false)
		arg0_276:EnablePOVLayer(true)
		setActive(arg0_276.restrictedBox, true)

		local var0_276 = arg0_276.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_276.transform.position = arg0_276.mainCameraTF.position

		local var1_276 = arg0_276.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_276 = arg0_276.mainCameraTF.rotation:ToEulerAngles()
		local var3_276 = var1_276.m_HorizontalAxis

		var3_276.Value = var2_276.y
		var1_276.m_HorizontalAxis = var3_276

		local var4_276 = var1_276.m_VerticalAxis

		var4_276.Value = arg0_276:GetNearestAngle(var2_276.x, var4_276.m_MinValue, var4_276.m_MaxValue)
		var1_276.m_VerticalAxis = var4_276

		local var5_276 = math.InverseLerp(arg0_276.restrictedHeightRange[1], arg0_276.restrictedHeightRange[2], var0_276.position.y)

		arg0_276:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_276)
		arg0_276:ActiveCamera(arg0_276.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_276:EnableJoystick(true)
		arg0_276:EnablePOVLayer(false)
		setActive(arg0_276.restrictedBox, false)
		arg0_276:ActiveCamera(arg0_276.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_276.contextData.photoFreeMode = not arg0_276.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_277, arg1_277)
	local var0_277 = math.lerp(arg0_277.restrictedHeightRange[1], arg0_277.restrictedHeightRange[2], arg1_277)
	local var1_277 = arg0_277.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_277:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_277 - var1_277.position.y, 0))
	onNextTick(function()
		local var0_278 = math.InverseLerp(arg0_277.restrictedHeightRange[1], arg0_277.restrictedHeightRange[2], var1_277.position.y)

		arg0_277:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_278)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_279)
	local var0_279 = arg0_279.cameras[var0_0.CAMERA.PHOTO]
	local var1_279 = var0_279.m_XAxis

	var1_279.Value = 180
	var0_279.m_XAxis = var1_279

	local var2_279 = var0_279.m_YAxis

	var2_279.Value = 0.7
	var0_279.m_YAxis = var2_279
end

function var0_0.ResetCurrentCharPoint(arg0_280, arg1_280)
	local var0_280 = arg0_280.ladyDict[arg0_280.apartment:GetConfigID()]

	arg0_280:ResetCharPoint(var0_280, arg1_280)
end

function var0_0.ResetCharPoint(arg0_281, arg1_281, arg2_281)
	local var0_281 = arg0_281.furnitures:Find(arg2_281 .. "/StayPoint")

	arg1_281.lady.position = var0_281.position
	arg1_281.lady.rotation = var0_281.rotation
end

function var0_0.GetNearestAngle(arg0_282, arg1_282, arg2_282, arg3_282)
	if arg3_282 < arg2_282 then
		arg3_282 = arg3_282 + 360
	end

	if arg2_282 <= arg1_282 and arg1_282 <= arg3_282 then
		return arg1_282
	end

	local var0_282 = (arg2_282 + arg3_282) / 2

	arg1_282 = var0_282 - Mathf.DeltaAngle(arg1_282, var0_282)
	arg1_282 = math.clamp(arg1_282, arg2_282, arg3_282)

	return arg1_282
end

function var0_0.PlayTimeline(arg0_283, arg1_283, arg2_283)
	local var0_283 = {}

	if arg0_283.waitForTimeline then
		table.insert(var0_283, function(arg0_284)
			local var0_284 = arg0_283.waitForTimeline

			arg0_283.waitForTimeline = nil

			var0_284()
			arg0_284()
		end)
	end

	table.insert(var0_283, function(arg0_285)
		arg0_283:LoadTimelineScene(arg1_283.name, false, nil, arg0_285)
	end)

	if arg1_283.scene and arg1_283.sceneRoot then
		table.insert(var0_283, function(arg0_286)
			arg0_283:ChangeArtScene(arg1_283.scene .. "|" .. arg1_283.sceneRoot, arg0_286)
		end)
	end

	table.insert(var0_283, function(arg0_287)
		local var0_287 = GameObject.Find("[actor]").transform
		local var1_287 = var0_287:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_287, function(arg0_288, arg1_288)
			GetOrAddComponent(arg1_288.transform, typeof(DftAniEvent))
		end)

		local var2_287 = var0_287:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_287 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera)).transform
		local var4_287 = GameObject.Find("[sequence]").transform

		arg0_283.nowTimelinePlayer = TimelinePlayer.New(var4_287)

		arg0_283.nowTimelinePlayer:Register(arg1_283.time, function(arg0_289, arg1_289, arg2_289)
			switch(arg1_289.stringParameter, {
				TimelinePause = function()
					arg0_289:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_289:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_289.intParameter == 0 or arg1_289.intParameter == arg2_289.selectIndex then
						arg0_289:SetTime(arg1_289.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_289.selectIndex = nil

					if arg1_283.options then
						local var0_293 = arg1_283.options[arg1_289.intParameter]

						arg0_283:DoTimelineOption(var0_293, function(arg0_294)
							arg2_289.selectIndex = arg0_294
							arg2_289.optionIndex = var0_293[arg0_294].flag

							arg0_289:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_289.selectIndex = nil

					if arg1_283.touchs then
						local var0_295 = arg1_283.touchs[arg1_289.intParameter]

						arg0_283:DoTimelineTouch(arg1_283.touchs[arg1_289.intParameter], function(arg0_296)
							arg2_289.selectIndex = arg0_296
							arg2_289.optionIndex = var0_295[arg0_296].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_289.selectIndex then
						arg0_289:RawSetTime(arg1_289.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_289.selectIndex = arg1_289.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_283.canTriggerAccompanyPerformance then
						arg0_283.canTriggerAccompanyPerformance = false

						local var0_299 = arg1_283.accompanys[arg1_289.intParameter]
						local var1_299 = var0_299[math.random(#var0_299)]

						arg0_289:SetTime(var1_299)
					end
				end,
				TimelineIKStart = function()
					arg2_289.selectIndex = nil

					local var0_300 = arg1_289.intParameter
					local var1_300 = arg0_283.ladyDict[arg0_283.apartment:GetConfigID()]

					arg0_283:SetIKTimelineStatus(var1_300, var2_287.gameObject, var0_300, var3_287)
				end,
				TimelineEnd = function()
					arg2_289.finish = true

					arg0_289:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_289.stringParameter)
			end)

			if arg2_289.finish then
				arg0_283.timelineMark = arg2_289
				arg0_283.timelineFinishCall = nil

				local var0_289 = arg0_283.ladyDict[arg0_283.apartment:GetConfigID()]

				if var0_289.ikTimelineMode then
					arg0_283:ExitIKTimelineStatus(var0_289)
				end

				arg0_287()
			end
		end)

		function arg0_283.timelineFinishCall()
			arg0_283.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_283:HideCharacter()
		setActive(arg0_283.mainCameraTF, false)
		eachChild(arg0_283.rtTimelineScreen, function(arg0_304)
			setActive(arg0_304, false)
		end)
		setActive(arg0_283.rtTimelineScreen, true)
		setActive(arg0_283.rtTimelineScreen:Find("btn_skip"), arg0_283.inReplayTalk)
		arg0_283.nowTimelinePlayer:Start()
	end)
	table.insert(var0_283, function(arg0_305)
		arg0_283:ShowBlackScreen(true, function()
			arg0_283.nowTimelinePlayer:Stop()
			arg0_283.nowTimelinePlayer:Dispose()

			arg0_283.nowTimelinePlayer = nil

			arg0_283:UnloadTimelineScene(arg1_283.name, false, arg0_305)
		end)
	end)

	local var1_283 = arg0_283.dormSceneMgr.artSceneInfo

	table.insert(var0_283, function(arg0_307)
		arg0_283:ChangeArtScene(var1_283, arg0_307)
	end)
	seriesAsync(var0_283, function()
		setActive(arg0_283.rtTimelineScreen, false)
		arg0_283:RevertCharacter()
		setActive(arg0_283.mainCameraTF, true)

		local var0_308 = arg0_283.timelineMark

		arg0_283.timelineMark = nil

		existCall(arg2_283, var0_308, function(arg0_309)
			arg0_283:ShowBlackScreen(false, arg0_309)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_310, ...)
	local var0_310 = arg0_310.ladyDict[arg0_310.apartment:GetConfigID()]

	return arg0_310:PlaySingleAction(var0_310, ...)
end

function var0_0.PlaySingleAction(arg0_311, arg1_311, arg2_311, arg3_311)
	local var0_311 = string.find(arg2_311, "^Face_")

	if tobool(var0_311) then
		arg0_311:PlayFaceAnim(arg1_311, arg2_311, arg3_311)

		return
	end

	if arg1_311.ladyAnimator:GetCurrentAnimatorStateInfo(arg1_311.ladyAnimBaseLayerIndex):IsName(arg2_311) then
		return
	end

	existCall(arg1_311.animExtraItemCallback)

	arg1_311.animExtraItemCallback = nil
	arg1_311.animNameMap = arg1_311.animNameMap or {}
	arg1_311.animNameMap[arg1_311.ladyAnimator.StringToHash(arg2_311)] = arg2_311

	local var1_311 = arg0_311:GetBlackboardValue(arg1_311, "groupId")
	local var2_311 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var1_311] or {}, function(arg0_312)
		return pg.dorm3d_anim_extraitem[arg0_312].anim == arg2_311
	end)
	local var3_311 = var2_311 and pg.dorm3d_anim_extraitem[var2_311]
	local var4_311

	seriesAsync({
		function(arg0_313)
			if not var3_311 or var3_311.item_prefab == "" then
				arg0_313()

				return
			end

			local var0_313 = string.lower("dorm3d/furniture/item/" .. var3_311.item_prefab)

			arg0_311.loader:GetPrefab(var0_313, "", function(arg0_314)
				setParent(arg0_314, arg1_311.lady)

				if var3_311.item_shield ~= "" then
					var4_311 = {}

					for iter0_314, iter1_314 in ipairs(var3_311.item_shield) do
						local var0_314 = arg0_311.modelRoot:Find(iter1_314)

						if not var0_314 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var3_311.id, iter1_314))
						else
							var4_311[iter1_314] = isActive(var0_314)

							setActive(var0_314, false)
						end
					end
				end

				function arg1_311.animExtraItemCallback()
					arg0_311.loader:ClearRequest("AnimExtraItem")

					if var4_311 then
						for iter0_315, iter1_315 in pairs(var4_311) do
							setActive(arg0_311.modelRoot:Find(iter0_315), iter1_315)
						end
					end
				end

				arg0_313()
			end, "AnimExtraItem")
		end,
		function(arg0_316)
			arg1_311.nowState = arg2_311
			arg1_311.stateCallback = arg0_316

			arg1_311.ladyAnimator:CrossFadeInFixedTime(arg2_311, 0.25, arg1_311.ladyAnimBaseLayerIndex)
		end,
		function(arg0_317)
			arg1_311.nowState = nil
			arg1_311.stateCallback = nil

			existCall(arg1_311.animExtraItemCallback)

			arg1_311.animExtraItemCallback = nil

			arg0_317()
		end,
		arg3_311
	})
end

function var0_0.SwitchCurrentAnim(arg0_318, ...)
	local var0_318 = arg0_318.ladyDict[arg0_318.apartment:GetConfigID()]

	return arg0_318:SwitchAnim(var0_318, ...)
end

function var0_0.SwitchAnim(arg0_319, arg1_319, arg2_319, arg3_319)
	local var0_319 = string.find(arg2_319, "^Face_")

	if tobool(var0_319) then
		arg0_319:PlayFaceAnim(arg1_319, arg2_319, arg3_319)

		return
	end

	existCall(arg1_319.animExtraItemCallback)

	arg1_319.animExtraItemCallback = nil
	arg1_319.animNameMap = arg1_319.animNameMap or {}
	arg1_319.animNameMap[arg1_319.ladyAnimator.StringToHash(arg2_319)] = arg2_319

	local var1_319 = {}

	table.insert(var1_319, function(arg0_320)
		arg1_319.nowState = arg2_319
		arg1_319.stateCallback = arg0_320

		arg1_319.ladyAnimator:PlayInFixedTime(arg2_319, arg1_319.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_319, function(arg0_321)
		arg1_319.nowState = nil
		arg1_319.stateCallback = nil

		arg0_321()
	end)
	seriesAsync(var1_319, arg3_319)
end

function var0_0.PlayFaceAnim(arg0_322, arg1_322, arg2_322, arg3_322)
	arg1_322.ladyAnimator:CrossFadeInFixedTime(arg2_322, 0.2, arg1_322.ladyAnimFaceLayerIndex)
	existCall(arg3_322)
end

function var0_0.GetCurrentAnim(arg0_323)
	local var0_323 = arg0_323.ladyDict[arg0_323.apartment:GetConfigID()]
	local var1_323 = var0_323.ladyAnimator:GetCurrentAnimatorStateInfo(var0_323.ladyAnimBaseLayerIndex).shortNameHash

	return var0_323.animNameMap[var1_323]
end

function var0_0.RegisterAnimCallback(arg0_324, arg1_324, arg2_324)
	arg0_324.ladyDict[arg0_324.apartment:GetConfigID()].animCallbacks[arg1_324] = arg2_324
end

function var0_0.SetCharacterAnimSpeed(arg0_325, arg1_325)
	local var0_325 = arg0_325.ladyDict[arg0_325.apartment:GetConfigID()]

	var0_325.ladyAnimator.speed = arg1_325
	var0_325.ladyHeadIKComp.blinkSpeed = var0_325.ladyHeadIKData.blinkSpeed * arg1_325

	if arg1_325 > 0 then
		var0_325.ladyHeadIKComp.DampTime = var0_325.ladyHeadIKData.DampTime / arg1_325
	else
		var0_325.ladyHeadIKComp.DampTime = var0_325.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_326, arg1_326)
	if arg1_326.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_326 = arg1_326.stringParameter
	local var1_326 = table.removebykey(arg0_326.animEventCallbacks, var0_326)

	existCall(var1_326)
end

function var0_0.RegisterAnimEventCallback(arg0_327, arg1_327, arg2_327)
	arg0_327.animEventCallbacks[arg1_327] = arg2_327
end

function var0_0.PlaySceneItemAnim(arg0_328, arg1_328, arg2_328)
	arg0_328.sceneAnimatorDict = arg0_328.sceneAnimatorDict or {}

	if not arg0_328.sceneAnimatorDict[arg1_328] then
		local var0_328 = pg.dorm3d_scene_animator[arg1_328]
		local var1_328 = arg0_328:GetSceneItem(var0_328.item_name)

		assert(var1_328, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_328 .. " " .. var0_328.item_name)

		if not var1_328 then
			return
		end

		local var2_328 = var1_328:GetComponent(typeof(Animator))

		if not var2_328 then
			return
		end

		arg0_328.sceneAnimatorDict[arg1_328] = {
			trans = var1_328,
			animator = var2_328
		}
	end

	if arg0_328.sceneAnimatorDict[arg1_328].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_328) then
		return
	end

	arg0_328.sceneAnimatorDict[arg1_328].animator:PlayInFixedTime(arg2_328)
end

function var0_0.ResetSceneItemAnimators(arg0_329, arg1_329)
	if not arg0_329.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_329.sceneAnimatorDict, function(arg0_330, arg1_330)
		if arg1_329 and table.contains(arg1_329, arg0_330) then
			return
		end

		setActive(arg1_330.trans, false)
		setActive(arg1_330.trans, true)

		arg0_329.sceneAnimatorDict[arg0_330] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_331, arg1_331, arg2_331, arg3_331, arg4_331, arg5_331)
	arg1_331.extraItems = arg1_331.extraItems or {}

	if arg1_331.extraItems[arg2_331] then
		return
	end

	local var0_331

	if arg3_331 == "" then
		var0_331 = arg1_331.lady
	else
		table.IpairsCArray(arg1_331.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_332, arg1_332)
			if arg1_332.name == arg3_331 then
				var0_331 = arg1_332
			end
		end)
	end

	if not var0_331 then
		return
	end

	arg0_331.loader:GetPrefab(string.lower("dorm3d/" .. arg2_331), "", function(arg0_333)
		setParent(arg0_333, var0_331)

		if arg4_331 then
			setLocalPosition(arg0_333, arg4_331)
		end

		if arg5_331 then
			setLocalRotation(arg0_333, arg5_331)
		end

		arg1_331.extraItems[arg2_331] = {
			trans = arg0_333.transform,
			handler = var0_331
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_334, arg1_334, arg2_334)
	if not arg1_334.extraItems then
		return
	end

	table.Foreach(arg1_334.extraItems, function(arg0_335, arg1_335)
		if arg2_334 and table.contains(arg2_334, arg0_335) then
			return
		end

		arg0_334.loader:ReturnPrefab(arg1_335.trans.gameObject)

		arg1_334.extraItems[arg0_335] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_336, arg1_336, arg2_336)
	arg0_336.cameraBlendCallbacks[arg1_336] = arg2_336
end

function var0_0.UnRegisterCameraBlendFinished(arg0_337, arg1_337)
	arg0_337.cameraBlendCallbacks[arg1_337] = nil
end

function var0_0.OnCameraBlendFinished(arg0_338, arg1_338)
	if not arg1_338 then
		return
	end

	local var0_338 = table.removebykey(arg0_338.cameraBlendCallbacks, arg1_338)

	existCall(var0_338)
end

function var0_0.PlayHeartFX(arg0_339, arg1_339)
	local var0_339 = arg0_339.ladyDict[arg1_339]

	setActive(var0_339.effectHeart, false)
	setActive(var0_339.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_340, arg1_340)
	local var0_340 = arg1_340.name
	local var1_340 = arg0_340.expressionDict[var0_340]
	local var2_340 = 5

	if var1_340 then
		local var3_340 = var1_340.timer

		var3_340:Reset(nil, var2_340)
		var3_340:Start()

		if var1_340.instance then
			setActive(var1_340.instance, false)
			setActive(var1_340.instance, true)
		end

		return
	end

	local var4_340 = {
		name = var0_340,
		timer = Timer.New(function()
			arg0_340:RemoveExpression(var0_340)
		end, var2_340, 1, true)
	}

	arg0_340.expressionDict[var0_340] = var4_340

	arg0_340.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_340, var0_340, function(arg0_342)
		var4_340.instance = arg0_342

		onNextTick(function()
			local var0_343 = arg0_340.ladyDict[arg0_340.apartment:GetConfigID()]

			setParent(arg0_342, var0_343.ladyHeadCenter)
		end)
		setLocalPosition(arg0_342, Vector3(0, 0, -0.2))
		setActive(arg0_342, false)
		setActive(arg0_342, true)
	end, var4_340)
end

function var0_0.RemoveExpression(arg0_344, arg1_344)
	local var0_344 = arg0_344.expressionDict[arg1_344]

	if not var0_344 then
		return
	end

	arg0_344.loader:ClearRequest(var0_344)

	if var0_344.instance then
		arg0_344.loader:ReturnPrefab(var0_344.instance)
	end

	arg0_344.expressionDict[arg1_344] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_345, arg1_345, arg2_345)
	arg1_345.ladyWatchFloat = arg1_345.ladyWatchFloat or cloneTplTo(arg0_345.resTF:Find("vfx_talk_mark"), arg1_345.ladyHeadCenter)

	setActive(arg1_345.ladyWatchFloat, arg2_345)
end

function var0_0.RegisterGlobalVolume(arg0_346)
	local var0_346 = arg0_346.globalVolume
	local var1_346 = LuaHelper.GetOrAddVolumeComponent(var0_346, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_346 = LuaHelper.GetOrAddVolumeComponent(var0_346, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_346.originalCameraSettings = {
		depthOfField = {
			enabled = var1_346.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_346.gaussianStart.min,
				value = var1_346.gaussianStart.value
			},
			blurRadius = {
				min = var1_346.blurRadius.min,
				max = var1_346.blurRadius.max,
				value = var1_346.blurRadius.value
			}
		},
		postExposure = {
			value = var2_346.postExposure.value
		},
		contrast = {
			min = var2_346.contrast.min,
			max = var2_346.contrast.max,
			value = var2_346.contrast.value
		},
		saturate = {
			min = var2_346.saturation.min,
			max = var2_346.saturation.max,
			value = var2_346.saturation.value
		}
	}
	arg0_346.originalCameraSettings.depthOfField.enabled = true

	local var3_346 = var0_346:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_346.originalVolume = {
		profile = var3_346.sharedProfile,
		weight = var3_346.weight
	}
end

function var0_0.SettingCamera(arg0_347, arg1_347)
	arg0_347.activeCameraSettings = arg1_347

	local var0_347 = arg0_347.globalVolume
	local var1_347 = LuaHelper.GetOrAddVolumeComponent(var0_347, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_347 = LuaHelper.GetOrAddVolumeComponent(var0_347, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_347.enabled:Override(arg1_347.depthOfField.enabled)
	var1_347.gaussianStart:Override(arg1_347.depthOfField.focusDistance.value)
	var1_347.gaussianEnd:Override(arg1_347.depthOfField.focusDistance.value + arg1_347.depthOfField.focusDistance.length)
	var1_347.blurRadius:Override(arg1_347.depthOfField.blurRadius.value)
	var2_347.postExposure:Override(arg1_347.postExposure.value)
	var2_347.contrast:Override(arg1_347.contrast.value)
	var2_347.saturation:Override(arg1_347.saturate.value)
end

function var0_0.GetCameraSettings(arg0_348)
	return arg0_348.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_349)
	arg0_349:SettingCamera(arg0_349.originalCameraSettings)

	arg0_349.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_350, arg1_350, arg2_350)
	local var0_350 = arg0_350.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_350.activeProfileWeight = arg2_350

	if arg0_350.activeProfileName ~= arg1_350 then
		arg0_350.activeProfileName = arg1_350

		arg0_350.loader:LoadReference("dorm3d/scenesres/res/common", arg1_350, nil, function(arg0_351)
			var0_350.profile = arg0_351
			var0_350.weight = arg0_350.activeProfileWeight

			if arg0_350.activeCameraSettings then
				arg0_350:SettingCamera(arg0_350.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_350.weight = arg0_350.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_352)
	local var0_352 = arg0_352.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_352.profile = arg0_352.originalVolume.profile
	var0_352.weight = arg0_352.originalVolume.weight

	if arg0_352.activeCameraSettings then
		arg0_352:SettingCamera(arg0_352.activeCameraSettings)
	end

	arg0_352.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_353)
	local var0_353 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_353.originalCharacterColor = {
		color = var0_353.color,
		intensity = var0_353.intensity
	}
end

function var0_0.SetCharacterLight(arg0_354, arg1_354, arg2_354, arg3_354)
	local var0_354 = arg0_354.characterLight:GetComponent(typeof(Light))
	local var1_354 = Color.Lerp(arg0_354.originalCharacterColor.color, arg1_354, arg3_354)
	local var2_354 = math.lerp(arg0_354.originalCharacterColor.intensity, arg2_354, arg3_354)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_354, var2_354)
end

function var0_0.RevertCharacterLight(arg0_355)
	arg0_355:SetCharacterLight(arg0_355.originalCharacterColor.color, arg0_355.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_356, arg1_356, arg2_356, arg3_356)
	arg2_356 = arg2_356 or {}

	table.Foreach(arg1_356.clothComps, function(arg0_357, arg1_357)
		if arg1_357 == nil then
			return
		end

		setActive(arg1_357, arg2_356[arg0_357] == 1)
	end)
	table.Foreach(arg1_356.clothColliderDict, function(arg0_358, arg1_358)
		if arg1_358 == nil then
			return
		end

		setActive(arg1_358, false)
	end)

	if arg3_356 then
		table.Foreach(arg3_356, function(arg0_359, arg1_359)
			local var0_359 = arg1_356.clothColliderDict[arg1_359[1]]

			if var0_359 == nil then
				return
			end

			setActive(var0_359, arg1_359[2] == 1)

			if arg1_359[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_359, arg1_359[3], arg1_359[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_360, arg1_360)
	table.Foreach(arg1_360.ladyClothCompSettings, function(arg0_361, arg1_361)
		arg0_361.enabled = arg1_361.enabled
	end)
	table.Foreach(arg1_360.ladyClothColliderSettings, function(arg0_362, arg1_362)
		arg0_362.enabled = arg1_362.enabled

		var0_0.SetMagicaCollider(arg0_362, arg1_362.StartRadius, arg1_362.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_363)
	if arg0_363.exited or arg0_363.retainCount > 0 then
		-- block empty
	else
		arg0_363:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_364, arg1_364, arg2_364, arg3_364, arg4_364)
	arg0_364.dormSceneMgr:LoadTimelineScene({
		name = string.lower(arg1_364),
		assetRootName = arg0_364.apartment:getConfig("asset_name"),
		isCache = arg2_364,
		waitForTimeline = arg3_364,
		callName = arg0_364.apartment:GetCallName(),
		loadSceneFunc = function(arg0_365, arg1_365)
			local var0_365 = GameObject.Find("[actor]").transform

			arg0_364:HXCharacter(tf(var0_365))
		end
	}, arg4_364)
end

function var0_0.UnloadTimelineScene(arg0_366, arg1_366, arg2_366, arg3_366)
	arg0_366.dormSceneMgr:UnloadTimelineScene(string.lower(arg1_366), arg2_366, arg3_366)
end

function var0_0.ChangeArtScene(arg0_367, arg1_367, arg2_367)
	arg1_367 = string.lower(arg1_367)

	warning(arg0_367.dormSceneMgr.artSceneInfo, "->", arg1_367, arg1_367 == arg0_367.dormSceneMgr.sceneInfo)

	local var0_367 = {}

	table.insert(var0_367, function(arg0_368)
		arg0_367.dormSceneMgr:ChangeArtScene(string.lower(arg1_367), arg0_368)
	end)

	if arg1_367 == arg0_367.dormSceneMgr.sceneInfo or arg0_367.dormSceneMgr.artSceneInfo == arg0_367.dormSceneMgr.sceneInfo then
		table.insert(var0_367, function(arg0_369)
			setActive(arg0_367.slotRoot, arg1_367 == arg0_367.dormSceneMgr.sceneInfo)
			arg0_369()
		end)
	end

	if arg1_367 == arg0_367.dormSceneMgr.sceneInfo then
		table.insert(var0_367, function(arg0_370)
			arg0_367:SwitchDayNight(arg0_367.contextData.timeIndex)
			onNextTick(function()
				arg0_367:RefreshSlots()
				arg0_370()
			end)
		end)
	end

	seriesAsync(var0_367, arg2_367)
end

function var0_0.ChangeSubScene(arg0_372, arg1_372, arg2_372)
	arg1_372 = string.lower(arg1_372)

	warning(arg0_372.dormSceneMgr.subSceneInfo, "->", arg1_372, arg1_372 == arg0_372.dormSceneMgr.subSceneInfo)

	local var0_372 = {}

	table.insert(var0_372, function(arg0_373)
		arg0_372.dormSceneMgr:ChangeSubScene(arg1_372, arg0_373)
	end)

	local var1_372 = arg0_372.ladyDict[arg0_372.apartment:GetConfigID()]

	table.insert(var0_372, function(arg0_374)
		if arg1_372 == arg0_372.dormSceneMgr.sceneInfo then
			var1_372.ladyActiveZone = var1_372.walkBornPoint or var1_372.ladyBaseZone
		else
			var1_372.ladyActiveZone = var1_372.walkBornPoint or "Default"
		end

		arg0_374()
	end)

	if arg1_372 ~= arg0_372.dormSceneMgr.subSceneInfo then
		table.insert(var0_372, function(arg0_375)
			local var0_375, var1_375 = Dorm3dSceneMgr.ParseInfo(arg1_372)
			local var2_375 = var0_375 .. "_base"

			arg0_372:ResetSceneStructure(SceneManager.GetSceneByName(var2_375))

			if arg1_372 == arg0_372.dormSceneMgr.sceneInfo then
				arg0_372:RefreshSlots()
			else
				arg0_372:SwitchAnim(var1_372, var0_0.ANIM.IDLE)
			end

			if arg0_372.dormSceneMgr.subSceneInfo == arg0_372.dormSceneMgr.sceneInfo then
				local var3_375 = Clone(arg0_372.room)

				var3_375.furnitures = {}

				arg0_372:RefreshSlots(var3_375)
			end

			arg0_375()
		end)
	end

	table.insert(var0_372, function(arg0_376)
		onNextTick(function()
			arg0_372:ChangeCharacterPosition(var1_372)
			arg0_372:ChangePlayerPosition(var1_372.ladyActiveZone)
			arg0_372:TriggerLadyDistance()
			arg0_372:CheckInSector()
			arg0_376()
		end)
	end)
	seriesAsync(var0_372, arg2_372)
end

function var0_0.IsPointInSector(arg0_378, arg1_378)
	local var0_378 = arg1_378 - Vector3.New(unpack(arg0_378.Position))

	if var0_378.magnitude > arg0_378.Radius then
		return false
	end

	local var1_378 = Quaternion.Euler(unpack(arg0_378.Rotation))

	return Vector3.Angle(var1_378 * Vector3.forward, var0_378) <= arg0_378.Angle / 2
end

function var0_0.willExit(arg0_379)
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

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_379.blockLayer, arg0_379._tf)
	table.Foreach(arg0_379.expressionDict, function(arg0_381)
		arg0_379:RemoveExpression(arg0_381)
	end)
	arg0_379.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_379.dormSceneMgr:Dispose()

	arg0_379.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_382 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_382 = SystemInfo.deviceModel or ""

			local function var2_382(arg0_383)
				local var0_383 = string.match(arg0_383, "iPad(%d+)")
				local var1_383 = tonumber(var0_383)

				if var1_383 and var1_383 >= 8 then
					return true
				end

				return false
			end

			local function var3_382(arg0_384)
				local var0_384 = string.match(arg0_384, "iPhone(%d+)")
				local var1_384 = tonumber(var0_384)

				if var1_384 and var1_384 >= 13 then
					return true
				end

				return false
			end

			if var2_382(var1_382) or var3_382(var1_382) then
				var0_382 = DevicePerformanceLevel.High
			end
		end

		local var4_382 = var0_382 == DevicePerformanceLevel.High and 3 or var0_382 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_382)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_382
	end
end

function var0_0.SettingQuality()
	local var0_385 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_385)
end

function var0_0.SetMagicaCollider(arg0_386, arg1_386, arg2_386)
	local var0_386 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_386, "StartRadius", arg0_386, arg1_386)
	ReflectionHelp.RefSetProperty(var0_386, "EndRadius", arg0_386, arg2_386)
end

return var0_0
