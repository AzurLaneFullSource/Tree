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

function var0_0.ChangePlayerPosition(arg0_146, arg1_146)
	arg1_146 = arg1_146 or arg0_146.contextData.inFurnitureName

	local var0_146 = arg0_146.furnitures:Find(arg1_146):Find("PlayerPoint").position

	arg0_146.player.position = var0_146
	arg0_146.cameras[var0_0.CAMERA.POV].transform.position = arg0_146.playerEye.position

	local var1_146 = arg0_146.ladyInterest.position - arg0_146.playerEye.position
	local var2_146 = Quaternion.LookRotation(var1_146).eulerAngles
	local var3_146 = var2_146.y
	local var4_146 = var2_146.x
	local var5_146 = arg0_146.compPovAim.m_HorizontalAxis

	var5_146.Value = arg0_146:GetNearestAngle(var3_146, var5_146.m_MinValue, var5_146.m_MaxValue)
	arg0_146.compPovAim.m_HorizontalAxis = var5_146

	local var6_146 = arg0_146.compPovAim.m_VerticalAxis

	var6_146.Value = var4_146
	arg0_146.compPovAim.m_VerticalAxis = var6_146
end

function var0_0.GetAttachedFurnitureName(arg0_147)
	return arg0_147.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_148, arg1_148)
	return underscore.detect(arg0_148.attachedPoints, function(arg0_149)
		return arg0_149.name == arg1_148
	end)
end

function var0_0.GetSlotByID(arg0_150, arg1_150)
	return arg0_150.displaySlots[arg1_150] and arg0_150.displaySlots[arg1_150].trans
end

function var0_0.GetScreenPosition(arg0_151, arg1_151, arg2_151)
	arg2_151 = arg2_151 or arg0_151.raycastCamera

	local var0_151 = arg2_151:WorldToScreenPoint(arg1_151)

	if var0_151.z < 0 then
		var0_151.x = var0_151.x + (var0_151.x < 0 and -1 or 1) * Screen.width
		var0_151.y = var0_151.y + (var0_151.y < 0 and -1 or 1) * Screen.height
		var0_151.z = -var0_151.z
	end

	return var0_151
end

function var0_0.GetLocalPosition(arg0_152, arg1_152, arg2_152)
	return LuaHelper.ScreenToLocal(arg2_152, arg1_152, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_153)
	return arg0_153.modelRoot
end

function var0_0.ShiftZone(arg0_154, arg1_154, arg2_154)
	local var0_154 = arg0_154:GetFurnitureByName(arg1_154)

	if not var0_154 then
		errorMsg(arg1_154 .. " Not Find")
		existCall(arg2_154)

		return
	end

	seriesAsync({
		function(arg0_155)
			arg0_154:emit(var0_0.SHOW_BLOCK)
			arg0_154:ShowBlackScreen(true, arg0_155)
		end,
		function(arg0_156)
			if arg0_154.shiftLady or arg0_154.room:isPersonalRoom() then
				local var0_156 = arg0_154.shiftLady or arg0_154.apartment:GetConfigID()

				arg0_154.shiftLady = nil
				arg0_154.contextData.ladyZone[var0_156] = var0_154.name

				local var1_156 = arg0_154.ladyDict[var0_156]

				var1_156.ladyBaseZone = arg0_154.contextData.ladyZone[var0_156]
				var1_156.ladyActiveZone = arg0_154.contextData.ladyZone[var0_156]

				if arg0_154:GetBlackboardValue(var1_156, "inPending") then
					arg0_154:SetOutPending(var1_156)
					arg0_154:SwitchAnim(var1_156, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_154:ChangeCharacterPosition(var1_156)
						arg0_156()
					end)
				else
					arg0_154:ChangeCharacterPosition(var1_156)
					arg0_156()
				end
			else
				arg0_156()
			end
		end,
		function(arg0_158)
			arg0_154.contextData.inFurnitureName = var0_154.name

			if not arg0_154.apartment then
				for iter0_158, iter1_158 in pairs(arg0_154.ladyDict) do
					if iter1_158.ladyBaseZone == arg0_154.contextData.inFurnitureName then
						arg0_154:SyncInterestTransform(iter1_158)

						break
					end
				end
			end

			arg0_154:ChangePlayerPosition()
			arg0_154:TriggerLadyDistance()
			arg0_154:CheckInSector()
			arg0_158()
		end,
		function(arg0_159)
			arg0_154:UpdateZoneList()
			arg0_154:ShowBlackScreen(false, arg0_159)
		end,
		function(arg0_160)
			arg0_154:emit(var0_0.HIDE_BLOCK)
			arg0_160()
		end
	}, arg2_154)
end

function var0_0.ActiveCamera(arg0_161, arg1_161)
	local var0_161 = isActive(arg1_161)

	table.Foreach(arg0_161.cameras, function(arg0_162, arg1_162)
		setActive(arg1_162, arg1_162 == arg1_161)
	end)

	if var0_161 then
		arg0_161:OnCameraBlendFinished(arg1_161)
	end
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
			arg0_169:SyncInterestTransform(arg0_169.ladyDict[arg0_169.apartment:GetConfigID()])
			arg0_169:SetCameraLady(arg0_169.ladyDict[arg0_169.apartment:GetConfigID()])
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
			arg0_169:SetCameraLady(arg0_169.ladyDict[arg0_169.apartment:GetConfigID()])
			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.GIFT], arg0_174)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_175)
			assert(arg0_169.apartment)
			arg0_169:SetCameraLady(arg0_169.ladyDict[arg0_169.apartment:GetConfigID()])

			arg0_169.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_169.cameraRole.transform.position

			arg0_169:RegisterCameraBlendFinished(arg0_169.cameras[var0_0.CAMERA.ROLE2], arg0_175)
			arg0_169:ActiveCamera(arg0_169.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_176)
			assert(arg0_169.apartment)
			arg0_169:SetCameraLady(arg0_169.ladyDict[arg0_169.apartment:GetConfigID()])
			arg0_169:SyncInterestTransform(arg0_169.ladyDict[arg0_169.apartment:GetConfigID()])
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

	if string.find(arg1_178, "fbx/") == 1 then
		var0_178 = arg0_178.modelRoot:Find(arg1_178)
	elseif string.find(arg1_178, "FurnitureSlots/") == 1 then
		arg1_178 = string.gsub(arg1_178, "^FurnitureSlots/", "", 1)
		var0_178 = arg0_178.slotRoot:Find(arg1_178)
	end

	if not var0_178 then
		warning(string.format("Missing scene item path: %s", arg1_178))
	end

	return var0_178
end

function var0_0.SetIKStatus(arg0_179, arg1_179, arg2_179, arg3_179)
	warning("Set IKStatus " .. (arg2_179.id or "NIL"))

	arg0_179.enableIKTip = true

	arg0_179:ResetIKTipTimer()
	setActive(arg1_179.ladyCollider, false)
	_.each(arg1_179.ladyTouchColliders, function(arg0_180)
		setActive(arg0_180, true)
	end)

	arg0_179.blockIK = nil
	arg1_179.ikActionDict = {}
	arg1_179.readyIKLayers = {}
	arg1_179.iKTouchDatas = arg2_179.touch_data or {}
	arg1_179.IKSettings = {
		Colliders = arg1_179.ladyColliders,
		CameraRaycaster = arg0_179.sceneRaycaster
	}

	local var0_179 = table.shallowCopy(arg2_179.ik_id)
	local var1_179 = {}

	_.each(arg1_179.iKTouchDatas, function(arg0_181)
		local var0_181 = arg0_181[3]

		if var0_181[1] == 7 then
			local var1_181 = pg.dorm3d_ik_touch_move[var0_181[2]]
			local var2_181 = var1_181.target_ik

			if not _.detect(var0_179, function(arg0_182)
				return arg0_182[1] == var2_181
			end) then
				var1_179[var2_181] = {
					back_time = var1_181.back_time
				}

				local var3_181 = {
					var2_181,
					0,
					{}
				}

				if var1_181.trigger_dialogue > 0 then
					var3_181[3] = {
						4,
						0,
						var1_181.trigger_dialogue
					}
				end

				table.insert(var0_179, var3_181)
			end
		end
	end)

	local var2_179 = _.map(var0_179, function(arg0_183)
		local var0_183 = Dorm3dIK.New({
			configId = arg0_183[1]
		})
		local var1_183 = arg0_183[3]
		local var2_183 = var1_183[1]
		local var3_183 = switch(var2_183, {
			function(arg0_184, arg1_184)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_186, arg1_186)
				return arg0_186
			end,
			function(arg0_187, arg1_187)
				return arg0_187
			end,
			function(arg0_188, arg1_188, arg2_188, arg3_188)
				return arg0_188
			end,
			function(arg0_189)
				return 0
			end
		}, function(arg0_190)
			return type(arg0_190) == "number" and arg0_190 or 0
		end, unpack(var1_183, 2))

		table.insert(arg1_179.readyIKLayers, var0_183)

		arg1_179.ikActionDict[var0_183:GetControllerPath()] = var1_183

		local var4_183 = var0_183:GetRevertTime()
		local var5_183 = var1_179[var0_183:GetConfigID()]
		local var6_183 = tobool(var5_183)

		if var6_183 then
			var3_183 = var5_183.back_time
			var4_183 = var5_183.back_time
			var0_183.ignoreDrag = true
		end

		local var7_183 = var0_183:GetSubTargets()
		local var8_183 = var0_183:GetPlaneRotations()
		local var9_183 = var0_183:GetPlaneScales()
		local var10_183 = _.map(_.range(#var7_183), function(arg0_191)
			return {
				name = var7_183[arg0_191][1],
				planeRot = var8_183[arg0_191],
				planeScale = var9_183[arg0_191]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_183:getConfig("trigger_param")[2],
			controllerName = var0_183:GetControllerPath(),
			subTargets = var10_183,
			actionType = var0_183:GetActionTriggerParams()[1],
			controlRect = var0_183:GetRect(),
			actionRect = var0_183:GetTriggerRect(),
			backTime = var4_183,
			actionRevertTime = var3_183,
			ignoreDrag = var6_183
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_179.ladyIKRoot, arg1_179.ladyBoneMaps)
	arg0_179:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_179)

	local var3_179 = _.map(arg1_179.iKTouchDatas, function(arg0_192)
		return arg0_192[1]
	end)

	table.Foreach(var3_179, function(arg0_193, arg1_193)
		local var0_193 = pg.dorm3d_ik_touch[arg1_193]

		if #var0_193.scene_item == 0 then
			return
		end

		local var1_193 = arg0_179:GetSceneItem(var0_193.scene_item)

		if not var1_193 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_193, var0_193.scene_item))

			return
		end

		if IsNil(GetComponent(var1_193, typeof(UnityEngine.Collider))) then
			go(var1_193):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_193 = GetOrAddComponent(var1_193, typeof(EventTriggerListener))

		var2_193.enabled = true

		var2_193:AddPointClickFunc(function()
			arg0_179.blockIK = true

			local var0_194 = arg1_179.iKTouchDatas[arg0_193]
			local var1_194, var2_194, var3_194 = unpack(var0_194)

			arg0_179:TouchModeAction(arg1_179, var1_194, unpack(var3_194))(function()
				arg0_179.enableIKTip = true

				arg0_179:ResetIKTipTimer()

				arg0_179.blockIK = nil
			end)
		end)
	end)

	arg0_179.camBrain.enabled = false

	if arg0_179.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_179.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_179.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var4_179 = arg0_179.cameraRoot:Find(arg2_179.ik_camera)

	assert(var4_179, "Missing IKCamera")

	arg0_179.cameras[var0_0.CAMERA.IK_WATCH] = var4_179

	arg0_179:ActiveCamera(arg0_179.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_179.camBrain.enabled = true

	local var5_179 = var4_179:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_179 then
		arg0_179:RegisterOrbits(var5_179)
	else
		arg0_179:RevertCameraOrbit()
	end

	arg0_179:SwitchAnim(arg1_179, arg2_179.character_action)
	arg0_179:SettingHeadAimIK(arg1_179, arg2_179.head_track)
	arg0_179:EnableCloth(arg1_179, false)
	arg0_179:EnableCloth(arg1_179, arg2_179.use_cloth, arg2_179.cloth_colliders)
	;(function()
		local var0_196 = arg2_179.enter_scene_anim
		local var1_196 = {}

		if var0_196 and #var0_196 > 0 then
			table.Ipairs(var0_196, function(arg0_197, arg1_197)
				arg0_179:PlaySceneItemAnim(arg1_197[1], arg1_197[2])
				table.insert(var1_196, arg1_197[1])
			end)
		end

		arg0_179:ResetSceneItemAnimators(var1_196)
	end)()
	;(function()
		local var0_198 = arg2_179.enter_extra_item
		local var1_198 = {}

		if var0_198 and #var0_198 > 0 then
			table.Ipairs(var0_198, function(arg0_199, arg1_199)
				local var0_199 = arg1_199[3] and Vector3.New(unpack(arg1_199[3]))
				local var1_199 = arg1_199[4] and Quaternion.Euler(unpack(arg1_199[4]))

				arg0_179:LoadCharacterExtraItem(arg1_179, arg1_199[1], arg1_199[2], var0_199, var1_199)
				table.insert(var1_198, arg1_199[1])
			end)
		end

		arg0_179:ResetCharacterExtraItem(arg1_179, var1_198)
	end)()
	eachChild(arg0_179.ikTextTipsRoot, function(arg0_200)
		setActive(arg0_200, false)
	end)
	_.each(arg1_179.readyIKLayers, function(arg0_201)
		local var0_201 = arg0_201:getConfig("tip_text")

		if not var0_201 or #var0_201 == 0 then
			return
		end

		local var1_201 = arg0_179.ikTextTipsRoot:Find(var0_201)

		if not IsNil(var1_201) then
			setActive(var1_201, true)
		end
	end)
	onNextTick(function()
		local var0_202 = arg0_179.furnitures:Find(arg2_179.character_position)

		arg1_179.lady.position = var0_202:Find("StayPoint").position
		arg1_179.lady.rotation = var0_202:Find("StayPoint").rotation

		existCall(arg3_179)
	end)
end

function var0_0.ExitIKStatus(arg0_203, arg1_203, arg2_203, arg3_203)
	arg0_203.enableIKTip = false

	setActive(arg1_203.ladyCollider, true)
	_.each(arg1_203.ladyTouchColliders, function(arg0_204)
		setActive(arg0_204, false)
	end)

	arg0_203.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()
	setActive(arg0_203.ikTipsRoot, false)
	setActive(arg0_203.ikClickTipsRoot, false)

	local var0_203 = _.map(arg1_203.iKTouchDatas, function(arg0_205)
		return arg0_205[1]
	end)

	table.Foreach(var0_203, function(arg0_206, arg1_206)
		local var0_206 = pg.dorm3d_ik_touch[arg1_206]

		if #var0_206.scene_item == 0 then
			return
		end

		local var1_206 = arg0_203.modelRoot:Find(var0_206.scene_item)

		if not var1_206 then
			return
		end

		local var2_206 = GetOrAddComponent(var1_206, typeof(EventTriggerListener))

		var2_206:ClearEvents()

		var2_206.enabled = false
	end)

	arg1_203.ikActionDict = nil
	arg1_203.readyIKLayers = nil
	arg1_203.iKTouchDatas = nil

	arg0_203:RevertCameraOrbit()
	setActive(arg0_203.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_203.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_203:EnableCloth(arg1_203, false)
	arg0_203:ResetHeadAimIK(arg1_203)
	arg0_203:SwitchAnim(arg1_203, arg2_203.character_action)
	arg0_203:ResetSceneItemAnimators()
	arg0_203:ResetCharacterExtraItem(arg1_203)
	onNextTick(function()
		if arg2_203.character_position then
			arg1_203.ladyActiveZone = arg2_203.character_position
		else
			arg1_203.ladyActiveZone = arg1_203.ladyBaseZone
		end

		arg0_203:ChangeCharacterPosition(arg1_203)
		arg0_203:TriggerLadyDistance()
		arg0_203:CheckInSector()
		existCall(arg3_203)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_208, arg1_208, arg2_208, arg3_208, arg4_208, arg5_208)
	warning("Set IKStatus " .. (arg3_208 or "NIL"))

	arg0_208.enableIKTip = true

	setActive(arg0_208.ikControlUI, true)
	arg0_208:ResetIKTipTimer()

	arg0_208.blockIK = nil

	local var0_208 = pg.dorm3d_ik_timeline_status[arg3_208]

	arg1_208.readyIKLayers = {}
	arg1_208.iKTouchDatas = {}
	arg1_208.IKSettings = {
		CameraRaycaster = GetOrAddComponent(arg4_208, typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_208.IKSettings.CameraRaycaster)

	local var1_208 = {}

	table.IpairsCArray(arg2_208:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_209, arg1_209)
		if arg1_209.name == "SafeCollider" then
			setActive(arg1_209, false)

			return
		end

		if arg1_209:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_209)

		local var0_209 = child.name
		local var1_209 = var0_209 and string.find(var0_209, "Collider") or -1

		if var1_209 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_209)

			return
		end

		local var2_209 = string.sub(var0_209, 1, var1_209 - 1)

		if var2_209 == "Body" or var2_209 == "Safe" then
			setActive(child, false)

			return
		end

		if var0_0.BONE_TO_TOUCH[var2_209] == nil then
			return
		end

		var1_208[var2_209] = child

		setActive(child, true)
	end)

	arg1_208.IKSettings.Colliders = var1_208

	local var2_208 = GetOrAddComponent(arg2_208, typeof(EventTriggerListener))

	arg1_208.ikTimelineMode = true

	local var3_208 = _.map(var0_208.ik_id, function(arg0_210)
		local var0_210 = Dorm3dIK.New({
			configId = arg0_210
		})

		table.insert(arg1_208.readyIKLayers, var0_210)

		local var1_210 = var0_210:GetSubTargets()
		local var2_210 = var0_210:GetPlaneRotations()
		local var3_210 = var0_210:GetPlaneScales()
		local var4_210 = _.map(_.range(#var1_210), function(arg0_211)
			return {
				name = var1_210[arg0_211][1],
				planeRot = var2_210[arg0_211],
				planeScale = var3_210[arg0_211]
			}
		end)

		return Dorm3dIKController.New({
			ignoreDrag = false,
			triggerName = var0_210:getConfig("trigger_param")[2],
			controllerName = var0_210:GetControllerPath(),
			subTargets = var4_210,
			actionType = var0_210:GetActionTriggerParams()[1],
			controlRect = var0_210:GetRect(),
			actionRect = var0_210:GetTriggerRect(),
			backTime = var0_210:GetRevertTime(),
			actionRevertTime = var0_210:GetActionRevertTime(),
			timelineActionEvent = var0_210:GetTimelineAction()
		})
	end)
	local var4_208 = arg2_208.transform:Find("IKLayers")
	local var5_208 = {}
	local var6_208 = {}

	table.Foreach(var1_0, function(arg0_212, arg1_212)
		var6_208[arg1_212] = arg0_212
	end)

	local var7_208 = arg2_208.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var7_208, function(arg0_213, arg1_213)
		if var6_208[arg1_213.name] then
			var5_208[var6_208[arg1_213.name]] = arg1_213
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var4_208, var5_208)
	arg0_208:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var3_208)
	eachChild(arg0_208.ikTextTipsRoot, function(arg0_214)
		setActive(arg0_214, false)
	end)
	_.each(arg1_208.readyIKLayers, function(arg0_215)
		local var0_215 = arg0_215:getConfig("tip_text")

		if not var0_215 or #var0_215 == 0 then
			return
		end

		local var1_215 = arg0_208.ikTextTipsRoot:Find(var0_215)

		if not IsNil(var1_215) then
			setActive(var1_215, true)
		end
	end)
	existCall(arg5_208)
end

function var0_0.ExitIKTimelineStatus(arg0_216, arg1_216, arg2_216)
	arg0_216.enableIKTip = false

	setActive(arg0_216.ikControlUI, false)

	arg0_216.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_216.readyIKLayers = nil
	arg1_216.iKTouchDatas = nil
	arg1_216.IKSettings = nil

	setActive(arg0_216.ikTipsRoot, false)
	setActive(arg0_216.ikClickTipsRoot, false)
	existCall(arg2_216)
end

function var0_0.EnableIKLayer(arg0_217, arg1_217)
	local var0_217 = arg0_217.ladyDict[arg0_217.apartment:GetConfigID()]

	if #arg1_217:GetHeadTrackPath() > 0 then
		arg0_217:SettingHeadAimIK(var0_217, {
			2,
			arg1_217:GetHeadTrackPath()
		}, true)
	end

	local var1_217 = arg1_217:GetTriggerFaceAnim()

	if #var1_217 > 0 then
		arg0_217:PlayFaceAnim(var0_217, var1_217)
	end

	if not arg1_217.ignoreDrag then
		setActive(arg0_217:GetIKHandTF(), true)
		eachChild(arg0_217:GetIKHandTF(), function(arg0_218)
			setActive(arg0_218, false)
		end)
		arg0_217:StopIKHandTimer()
		setActive(arg0_217:GetIKHandTF():Find("Begin"), true)

		arg0_217.ikHandTimer = Timer.New(function()
			setActive(arg0_217:GetIKHandTF():Find("Begin"), false)
			setActive(arg0_217:GetIKHandTF():Find("Normal"), true)
		end, 0.5, 1)

		arg0_217.ikHandTimer:Start()
	end

	if not var0_217.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_217.apartment.configId, arg0_217.apartment.level, var0_217.ikConfig.character_action, arg1_217:GetTriggerParams()[2], arg0_217.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_220, arg1_220)
	local var0_220 = arg0_220.ladyDict[arg0_220.apartment:GetConfigID()]

	if not var0_220.ikTimelineMode and #arg1_220:GetHeadTrackPath() > 0 then
		arg0_220:SettingHeadAimIK(var0_220, var0_220.ikConfig.head_track)
	end

	arg0_220:StopIKHandTimer()

	if not arg1_220.ignoreDrag then
		setActive(arg0_220:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_220:GetIKHandTF():Find("Normal"), false)
		setActive(arg0_220:GetIKHandTF():Find("End"), true)

		arg0_220.ikHandTimer = Timer.New(function()
			setActive(arg0_220:GetIKHandTF():Find("End"), false)
			setActive(arg0_220:GetIKHandTF(), false)
		end, 0.5, 1)

		arg0_220.ikHandTimer:Start()
	end
end

function var0_0.StopIKHandTimer(arg0_222)
	if not arg0_222.ikHandTimer then
		return
	end

	arg0_222.ikHandTimer:Stop()

	arg0_222.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_223, arg1_223, arg2_223, arg3_223)
	local var0_223 = Time.time

	function arg0_223.ikRevertHandler()
		local var0_224 = Time.time - var0_223

		_.each(arg1_223.activeIKLayers, function(arg0_225)
			local var0_225 = 1

			if arg2_223 > 0 then
				var0_225 = var0_224 / arg2_223
			end

			local var1_225 = arg1_223.cacheIKInfos[arg0_225].solvers
			local var2_225 = arg1_223.cacheIKInfos[arg0_225].weights

			table.Foreach(var1_225, function(arg0_226, arg1_226)
				arg1_226.IKPositionWeight = math.lerp(var2_225[arg0_226], 0, var0_225)
			end)
		end)

		if var0_224 >= arg2_223 then
			arg0_223:ResetActiveIKs(arg1_223)

			arg0_223.ikRevertHandler = nil

			existCall(arg3_223)
		end
	end

	arg0_223.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_227, arg1_227)
	table.insertto(arg0_227.activeIKLayers, _.keys(arg0_227.holdingStatus))
	table.clear(arg0_227.holdingStatus)
	_.each(arg1_227.activeIKLayers, function(arg0_228)
		local var0_228 = arg0_228:GetControllerPath()
		local var1_228 = arg1_227.ladyIKRoot:Find(var0_228):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_228, false)

		local var2_228 = arg1_227.cacheIKInfos[arg0_228].solvers
		local var3_228 = arg1_227.cacheIKInfos[arg0_228].weights

		table.Foreach(var2_228, function(arg0_229, arg1_229)
			arg1_229.IKPositionWeight = var3_228[arg0_229]
		end)
	end)
	table.clear(arg1_227.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_230)
	if not arg0_230.enableIKTip then
		return
	end

	arg0_230.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_231, arg1_231)
	local var0_231 = arg0_231.ladyDict[arg0_231.apartment:GetConfigID()]

	arg0_231:EnableHeadIK(var0_231, arg1_231)
end

function var0_0.EnableHeadIK(arg0_232, arg1_232, arg2_232)
	arg1_232.ladyHeadIKComp.enableIk = arg2_232
end

function var0_0.SettingHeadAimIK(arg0_233, arg1_233, arg2_233, arg3_233)
	local var0_233

	if arg2_233[1] == 1 then
		var0_233 = arg0_233.mainCameraTF:Find("AimTarget")
	elseif arg2_233[1] == 2 then
		table.IpairsCArray(arg1_233.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_234, arg1_234)
			if arg1_234.name ~= arg2_233[2] then
				return
			end

			var0_233 = arg1_234
		end)
	end

	arg1_233.ladyHeadIKComp.AimTarget = var0_233

	if not arg3_233 and arg2_233[3] then
		arg1_233.ladyHeadIKComp.BodyWeight = arg2_233[3]
	end

	if not arg3_233 and arg2_233[4] then
		arg1_233.ladyHeadIKComp.HeadWeight = arg2_233[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_235, arg1_235)
	arg1_235.ladyHeadIKComp.AimTarget = arg0_235.mainCameraTF:Find("AimTarget")
	arg1_235.ladyHeadIKComp.HeadWeight = arg1_235.ladyHeadIKData.HeadWeight
	arg1_235.ladyHeadIKComp.BodyWeight = arg1_235.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_236, arg1_236)
	for iter0_236, iter1_236 in pairs(arg0_236.ladyDict) do
		if iter0_236 ~= arg1_236 then
			arg0_236:HideCharacterBylayer(iter1_236)
		end
	end
end

function var0_0.RevertCharacter(arg0_237, arg1_237)
	for iter0_237, iter1_237 in pairs(arg0_237.ladyDict) do
		if iter0_237 ~= arg1_237 then
			arg0_237:RevertCharacterBylayer(iter1_237)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_238, arg1_238)
	local var0_238 = "Bip001"
	local var1_238 = arg1_238.lady:Find("all")

	for iter0_238 = 0, var1_238.childCount - 1 do
		local var2_238 = var1_238:GetChild(iter0_238)

		if var2_238.name ~= var0_238 then
			pg.ViewUtils.SetLayer(var2_238, Layer.Environment3D)
		end
	end

	if arg1_238.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_238.tfPendintItem, Layer.Environment3D)
	end

	if arg1_238.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_238.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg1_238.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_239, arg1_239)
	local var0_239 = "Bip001"
	local var1_239 = arg1_239.lady:Find("all")

	for iter0_239 = 0, var1_239.childCount - 1 do
		local var2_239 = var1_239:GetChild(iter0_239)

		if var2_239.name ~= var0_239 then
			pg.ViewUtils.SetLayer(var2_239, Layer.Default)
		end
	end

	if arg1_239.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_239.tfPendintItem, Layer.Default)
	end

	if arg1_239.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_239.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg1_239.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_240)
	arg0_240:SetAllBlackbloardValue("inLockLayer", true)
	arg0_240:EnableJoystick(true)
	arg0_240:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_241, arg1_241)
	arg0_241:HideFurnitureSlots()

	local var0_241 = arg0_241.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_242)
			arg0_241.furniturePOV = nil

			arg0_241:EnableJoystick(false)
			arg0_241:emit(var0_0.SHOW_BLOCK)
			arg0_241:ShowBlackScreen(true, arg0_242)
		end,
		function(arg0_243)
			existCall(arg1_241)
			arg0_241:RevertCharacter()
			arg0_241:SetAllBlackbloardValue("inLockLayer", false)
			arg0_241:RegisterCameraBlendFinished(var0_241, arg0_243)
			arg0_241:ActiveCamera(var0_241)
		end,
		function(arg0_244)
			arg0_241:ShowBlackScreen(false, arg0_244)
		end
	}, function()
		arg0_241:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_241:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_246, arg1_246)
	local var0_246 = arg0_246:GetFurnitureByName(arg1_246:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_246.cameraFurnitureWatch and arg0_246.cameraFurnitureWatch ~= var0_246 then
		arg0_246:UnRegisterCameraBlendFinished(arg0_246.cameraFurnitureWatch)
		setActive(arg0_246.cameraFurnitureWatch, false)
	end

	arg0_246.cameraFurnitureWatch = var0_246
	arg0_246.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_246.cameraFurnitureWatch
	arg0_246.furniturePOV = arg0_246.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_246:RegisterCameraBlendFinished(arg0_246.cameraFurnitureWatch, function()
		arg0_246:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_246:emit(var0_0.SHOW_BLOCK)
	arg0_246:ActiveCamera(arg0_246.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_248)
	if arg0_248.displaySlots then
		arg0_248:UpdateDisplaySlots({})
		table.Foreach(arg0_248.displaySlots, function(arg0_249, arg1_249)
			local var0_249 = arg1_249.trans

			if IsNil(var0_249:Find("Selector")) then
				return
			end

			setActive(var0_249:Find("Selector"), false)
		end)

		arg0_248.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_250, arg1_250)
	arg0_250:HideFurnitureSlots()

	arg0_250.displaySlots = {}

	_.each(arg1_250, function(arg0_251)
		arg0_250.displaySlots[arg0_251] = arg0_250.slotDict[arg0_251]

		if not arg0_250.displaySlots[arg0_251] then
			errorMsg("Slot " .. arg0_251 .. " Not Binding Scene Object")

			return
		end

		local var0_251 = arg0_250.displaySlots[arg0_251].trans

		if var0_251:Find("Selector") then
			setActive(var0_251:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_252, arg1_252)
	table.Foreach(arg0_252.displaySlots, function(arg0_253, arg1_253)
		local var0_253 = arg1_253.trans

		if not IsNil(var0_253:Find("Selector")) then
			setActive(var0_253:Find("Selector/Normal"), arg1_252[arg0_253] == 0)
			setActive(var0_253:Find("Selector/Active"), arg1_252[arg0_253] == 1)
			setActive(var0_253:Find("Selector/Ban"), arg1_252[arg0_253] == 2)
		end

		local var1_253 = arg0_252.slotDict[arg0_253].model
		local var2_253 = arg0_252.slotDict[arg0_253].displayModelName

		if var2_253 and var2_253 ~= "" then
			var1_253 = var0_253:GetChild(var0_253.childCount - 1)
		end

		local function var3_253(arg0_254, arg1_254)
			local var0_254 = arg0_254:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_254, function(arg0_255, arg1_255)
				local var0_255 = arg1_255.material

				if var0_255 and var0_255:HasProperty("_FinalTint") then
					var0_255:SetColor("_FinalTint", arg1_254)
				end
			end)
		end

		if var1_253 then
			if arg1_252[arg0_253] == 1 then
				var3_253(var1_253, Color.NewHex("3F83AE73"))
			else
				var3_253(var1_253, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_256, arg1_256, arg2_256)
	arg0_256:SetAllBlackbloardValue("inLockLayer", true)
	arg0_256:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_257)
			arg0_256:TempHideUI(true, arg0_257)
		end,
		function(arg0_258)
			arg0_256:ShowBlackScreen(true, arg0_258)
		end,
		function(arg0_259)
			local var0_259 = arg0_256.apartment:GetConfigID()
			local var1_259 = arg0_256.ladyDict[var0_259]

			arg0_256:SwitchAnim(var1_259, arg2_256)
			var1_259.ladyAnimator:Update(0)
			var1_259:ResetCharPoint(var1_259, arg1_256:GetWatchCameraName())
			arg0_256:SyncInterestTransform(var1_259)
			setActive(var1_259.ladySafeCollider, true)
			arg0_256:HideCharacter(var0_259)

			local var2_259 = arg0_256.cameras[var0_0.CAMERA.PHOTO]
			local var3_259 = var2_259.m_XAxis

			var3_259.Value = 180
			var2_259.m_XAxis = var3_259

			local var4_259 = var2_259.m_YAxis

			var4_259.Value = 0.7
			var2_259.m_YAxis = var4_259
			arg0_256.pinchValue = 1

			arg0_256:RegisterOrbits(arg0_256.cameras[var0_0.CAMERA.PHOTO])
			arg0_256:SetCameraObrits()
			arg0_256:RegisterCameraBlendFinished(var2_259, arg0_259)
			arg0_256:ActiveCamera(var2_259)
		end,
		function(arg0_260)
			arg0_256:ShowBlackScreen(false, arg0_260)
		end
	}, function()
		arg0_256:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_262)
	arg0_262:emit(var0_0.SHOW_BLOCK)
	arg0_262:EnableJoystick(false)
	seriesAsync({
		function(arg0_263)
			arg0_262:ShowBlackScreen(true, arg0_263)
		end,
		function(arg0_264)
			arg0_262:RevertCameraOrbit()

			local var0_264 = arg0_262.ladyDict[arg0_262.apartment:GetConfigID()]

			arg0_262:SwitchAnim(var0_264, var0_0.ANIM.IDLE)
			setActive(var0_264.ladySafeCollider, false)
			onNextTick(function()
				arg0_262:ChangeCharacterPosition(var0_264)
			end)

			if arg0_262.contextData.photoFreeMode then
				arg0_262:EnablePOVLayer(false)
				setActive(arg0_262.restrictedBox, false)

				arg0_262.contextData.photoFreeMode = nil
			end

			local var1_264 = arg0_262.cameras[var0_0.CAMERA.POV]

			arg0_262:RegisterCameraBlendFinished(var1_264, arg0_264)
			arg0_262:ActiveCamera(var1_264)
		end,
		function(arg0_266)
			arg0_262:RevertCharacter(arg0_262.apartment:GetConfigID())
			arg0_262:ShowBlackScreen(false, arg0_266)
		end
	}, function()
		arg0_262:RefreshSlots()
		arg0_262:SetAllBlackbloardValue("inLockLayer", false)
		arg0_262:emit(var0_0.HIDE_BLOCK)
		arg0_262:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_262:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_268, arg1_268, arg2_268, arg3_268)
	arg0_268:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_269)
			arg0_268:ShowBlackScreen(true, arg0_269)
		end,
		function(arg0_270)
			local var0_270 = arg0_268.ladyDict[arg0_268.apartment:GetConfigID()]

			arg0_268:SwitchAnim(var0_270, arg2_268)
			onNextTick(function()
				arg0_268:ResetCharPoint(var0_270, arg1_268:GetWatchCameraName())
				arg0_268:SyncInterestTransform(var0_270)

				if arg0_268.contextData.photoFreeMode then
					arg0_268.camBrain.enabled = false

					arg0_268:SwitchPhotoCamera()

					arg0_268.camBrain.enabled = true

					onDelayTick(function()
						arg0_268.camBrain.enabled = false

						arg0_268:SwitchPhotoCamera()

						arg0_268.camBrain.enabled = true
					end, 0.1)
				end

				arg0_270()
			end)
		end,
		function(arg0_273)
			arg0_268:ShowBlackScreen(false, arg0_273)
		end
	}, function()
		arg0_268:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_268)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_275)
	if not arg0_275.contextData.photoFreeMode then
		arg0_275:EnableJoystick(false)
		arg0_275:EnablePOVLayer(true)
		setActive(arg0_275.restrictedBox, true)

		local var0_275 = arg0_275.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_275.transform.position = arg0_275.mainCameraTF.position

		local var1_275 = arg0_275.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_275 = arg0_275.mainCameraTF.rotation:ToEulerAngles()
		local var3_275 = var1_275.m_HorizontalAxis

		var3_275.Value = var2_275.y
		var1_275.m_HorizontalAxis = var3_275

		local var4_275 = var1_275.m_VerticalAxis

		var4_275.Value = arg0_275:GetNearestAngle(var2_275.x, var4_275.m_MinValue, var4_275.m_MaxValue)
		var1_275.m_VerticalAxis = var4_275

		local var5_275 = math.InverseLerp(arg0_275.restrictedHeightRange[1], arg0_275.restrictedHeightRange[2], var0_275.position.y)

		arg0_275:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_275)
		arg0_275:ActiveCamera(arg0_275.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_275:EnableJoystick(true)
		arg0_275:EnablePOVLayer(false)
		setActive(arg0_275.restrictedBox, false)
		arg0_275:ActiveCamera(arg0_275.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_275.contextData.photoFreeMode = not arg0_275.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_276, arg1_276)
	local var0_276 = math.lerp(arg0_276.restrictedHeightRange[1], arg0_276.restrictedHeightRange[2], arg1_276)
	local var1_276 = arg0_276.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_276:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_276 - var1_276.position.y, 0))
	onNextTick(function()
		local var0_277 = math.InverseLerp(arg0_276.restrictedHeightRange[1], arg0_276.restrictedHeightRange[2], var1_276.position.y)

		arg0_276:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_277)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_278)
	local var0_278 = arg0_278.cameras[var0_0.CAMERA.PHOTO]
	local var1_278 = var0_278.m_XAxis

	var1_278.Value = 180
	var0_278.m_XAxis = var1_278

	local var2_278 = var0_278.m_YAxis

	var2_278.Value = 0.7
	var0_278.m_YAxis = var2_278
end

function var0_0.ResetCurrentCharPoint(arg0_279, arg1_279)
	local var0_279 = arg0_279.ladyDict[arg0_279.apartment:GetConfigID()]

	arg0_279:ResetCharPoint(var0_279, arg1_279)
end

function var0_0.ResetCharPoint(arg0_280, arg1_280, arg2_280)
	local var0_280 = arg0_280.furnitures:Find(arg2_280 .. "/StayPoint")

	arg1_280.lady.position = var0_280.position
	arg1_280.lady.rotation = var0_280.rotation
end

function var0_0.GetNearestAngle(arg0_281, arg1_281, arg2_281, arg3_281)
	if arg3_281 < arg2_281 then
		arg3_281 = arg3_281 + 360
	end

	if arg2_281 <= arg1_281 and arg1_281 <= arg3_281 then
		return arg1_281
	end

	local var0_281 = (arg2_281 + arg3_281) / 2

	arg1_281 = var0_281 - Mathf.DeltaAngle(arg1_281, var0_281)
	arg1_281 = math.clamp(arg1_281, arg2_281, arg3_281)

	return arg1_281
end

function var0_0.PlayTimeline(arg0_282, arg1_282, arg2_282)
	local var0_282 = {}

	if arg0_282.waitForTimeline then
		table.insert(var0_282, function(arg0_283)
			local var0_283 = arg0_282.waitForTimeline

			arg0_282.waitForTimeline = nil

			var0_283()
			arg0_283()
		end)
	end

	table.insert(var0_282, function(arg0_284)
		arg0_282:LoadTimelineScene(arg1_282.name, false, nil, arg0_284)
	end)

	if arg1_282.scene and arg1_282.sceneRoot then
		table.insert(var0_282, function(arg0_285)
			arg0_282:ChangeArtScene(arg1_282.scene .. "|" .. arg1_282.sceneRoot, arg0_285)
		end)
	end

	table.insert(var0_282, function(arg0_286)
		local var0_286 = GameObject.Find("[actor]").transform
		local var1_286 = var0_286:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_286, function(arg0_287, arg1_287)
			GetOrAddComponent(arg1_287.transform, typeof(DftAniEvent))
		end)

		local var2_286 = var0_286:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_286 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera)).transform
		local var4_286 = GameObject.Find("[sequence]").transform

		arg0_282.nowTimelinePlayer = TimelinePlayer.New(var4_286)

		arg0_282.nowTimelinePlayer:Register(arg1_282.time, function(arg0_288, arg1_288, arg2_288)
			switch(arg1_288.stringParameter, {
				TimelinePause = function()
					arg0_288:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_288:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_288.intParameter == 0 or arg1_288.intParameter == arg2_288.selectIndex then
						arg0_288:SetTime(arg1_288.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_288.selectIndex = nil

					if arg1_282.options then
						local var0_292 = arg1_282.options[arg1_288.intParameter]

						arg0_282:DoTimelineOption(var0_292, function(arg0_293)
							arg2_288.selectIndex = arg0_293
							arg2_288.optionIndex = var0_292[arg0_293].flag

							arg0_288:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_288.selectIndex = nil

					if arg1_282.touchs then
						local var0_294 = arg1_282.touchs[arg1_288.intParameter]

						arg0_282:DoTimelineTouch(arg1_282.touchs[arg1_288.intParameter], function(arg0_295)
							arg2_288.selectIndex = arg0_295
							arg2_288.optionIndex = var0_294[arg0_295].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_288.selectIndex then
						arg0_288:RawSetTime(arg1_288.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_288.selectIndex = arg1_288.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_282.canTriggerAccompanyPerformance then
						arg0_282.canTriggerAccompanyPerformance = false

						local var0_298 = arg1_282.accompanys[arg1_288.intParameter]
						local var1_298 = var0_298[math.random(#var0_298)]

						arg0_288:SetTime(var1_298)
					end
				end,
				TimelineIKStart = function()
					arg2_288.selectIndex = nil

					local var0_299 = arg1_288.intParameter
					local var1_299 = arg0_282.ladyDict[arg0_282.apartment:GetConfigID()]

					arg0_282:SetIKTimelineStatus(var1_299, var2_286.gameObject, var0_299, var3_286)
				end,
				TimelineEnd = function()
					arg2_288.finish = true

					arg0_288:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_288.stringParameter)
			end)

			if arg2_288.finish then
				arg0_282.timelineMark = arg2_288
				arg0_282.timelineFinishCall = nil

				local var0_288 = arg0_282.ladyDict[arg0_282.apartment:GetConfigID()]

				if var0_288.ikTimelineMode then
					arg0_282:ExitIKTimelineStatus(var0_288)
				end

				arg0_286()
			end
		end)

		function arg0_282.timelineFinishCall()
			arg0_282.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_282:HideCharacter()
		setActive(arg0_282.mainCameraTF, false)
		eachChild(arg0_282.rtTimelineScreen, function(arg0_303)
			setActive(arg0_303, false)
		end)
		setActive(arg0_282.rtTimelineScreen, true)
		setActive(arg0_282.rtTimelineScreen:Find("btn_skip"), arg0_282.inReplayTalk)
		arg0_282.nowTimelinePlayer:Start()
	end)
	table.insert(var0_282, function(arg0_304)
		arg0_282:ShowBlackScreen(true, function()
			arg0_282.nowTimelinePlayer:Stop()
			arg0_282.nowTimelinePlayer:Dispose()

			arg0_282.nowTimelinePlayer = nil

			arg0_282:UnloadTimelineScene(arg1_282.name, false, arg0_304)
		end)
	end)

	local var1_282 = arg0_282.dormSceneMgr.artSceneInfo

	table.insert(var0_282, function(arg0_306)
		arg0_282:ChangeArtScene(var1_282, arg0_306)
	end)
	seriesAsync(var0_282, function()
		setActive(arg0_282.rtTimelineScreen, false)
		arg0_282:RevertCharacter()
		setActive(arg0_282.mainCameraTF, true)

		local var0_307 = arg0_282.timelineMark

		arg0_282.timelineMark = nil

		existCall(arg2_282, var0_307, function(arg0_308)
			arg0_282:ShowBlackScreen(false, arg0_308)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_309, ...)
	local var0_309 = arg0_309.ladyDict[arg0_309.apartment:GetConfigID()]

	return arg0_309:PlaySingleAction(var0_309, ...)
end

function var0_0.PlaySingleAction(arg0_310, arg1_310, arg2_310, arg3_310)
	local var0_310 = string.find(arg2_310, "^Face_")

	if tobool(var0_310) then
		arg0_310:PlayFaceAnim(arg1_310, arg2_310, arg3_310)

		return
	end

	if arg1_310.ladyAnimator:GetCurrentAnimatorStateInfo(arg1_310.ladyAnimBaseLayerIndex):IsName(arg2_310) then
		return
	end

	existCall(arg1_310.animExtraItemCallback)

	arg1_310.animExtraItemCallback = nil
	arg1_310.animNameMap = arg1_310.animNameMap or {}
	arg1_310.animNameMap[arg1_310.ladyAnimator.StringToHash(arg2_310)] = arg2_310

	local var1_310 = arg0_310:GetBlackboardValue(arg1_310, "groupId")
	local var2_310 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var1_310] or {}, function(arg0_311)
		return pg.dorm3d_anim_extraitem[arg0_311].anim == arg2_310
	end)
	local var3_310 = var2_310 and pg.dorm3d_anim_extraitem[var2_310]
	local var4_310

	seriesAsync({
		function(arg0_312)
			if not var3_310 or var3_310.item_prefab == "" then
				arg0_312()

				return
			end

			local var0_312 = string.lower("dorm3d/furniture/item/" .. var3_310.item_prefab)

			arg0_310.loader:GetPrefab(var0_312, "", function(arg0_313)
				setParent(arg0_313, arg1_310.lady)

				if var3_310.item_shield ~= "" then
					var4_310 = {}

					for iter0_313, iter1_313 in ipairs(var3_310.item_shield) do
						local var0_313 = arg0_310.modelRoot:Find(iter1_313)

						if not var0_313 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var3_310.id, iter1_313))
						else
							var4_310[iter1_313] = isActive(var0_313)

							setActive(var0_313, false)
						end
					end
				end

				function arg1_310.animExtraItemCallback()
					arg0_310.loader:ClearRequest("AnimExtraItem")

					if var4_310 then
						for iter0_314, iter1_314 in pairs(var4_310) do
							setActive(arg0_310.modelRoot:Find(iter0_314), iter1_314)
						end
					end
				end

				arg0_312()
			end, "AnimExtraItem")
		end,
		function(arg0_315)
			arg1_310.nowState = arg2_310
			arg1_310.stateCallback = arg0_315

			arg1_310.ladyAnimator:CrossFadeInFixedTime(arg2_310, 0.25, arg1_310.ladyAnimBaseLayerIndex)
		end,
		function(arg0_316)
			arg1_310.nowState = nil
			arg1_310.stateCallback = nil

			existCall(arg1_310.animExtraItemCallback)

			arg1_310.animExtraItemCallback = nil

			arg0_316()
		end,
		arg3_310
	})
end

function var0_0.SwitchCurrentAnim(arg0_317, ...)
	local var0_317 = arg0_317.ladyDict[arg0_317.apartment:GetConfigID()]

	return arg0_317:SwitchAnim(var0_317, ...)
end

function var0_0.SwitchAnim(arg0_318, arg1_318, arg2_318, arg3_318)
	local var0_318 = string.find(arg2_318, "^Face_")

	if tobool(var0_318) then
		arg0_318:PlayFaceAnim(arg1_318, arg2_318, arg3_318)

		return
	end

	existCall(arg1_318.animExtraItemCallback)

	arg1_318.animExtraItemCallback = nil
	arg1_318.animNameMap = arg1_318.animNameMap or {}
	arg1_318.animNameMap[arg1_318.ladyAnimator.StringToHash(arg2_318)] = arg2_318

	local var1_318 = {}

	table.insert(var1_318, function(arg0_319)
		arg1_318.nowState = arg2_318
		arg1_318.stateCallback = arg0_319

		arg1_318.ladyAnimator:PlayInFixedTime(arg2_318, arg1_318.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_318, function(arg0_320)
		arg1_318.nowState = nil
		arg1_318.stateCallback = nil

		arg0_320()
	end)
	seriesAsync(var1_318, arg3_318)
end

function var0_0.PlayFaceAnim(arg0_321, arg1_321, arg2_321, arg3_321)
	arg1_321.ladyAnimator:CrossFadeInFixedTime(arg2_321, 0.2, arg1_321.ladyAnimFaceLayerIndex)
	existCall(arg3_321)
end

function var0_0.GetCurrentAnim(arg0_322)
	local var0_322 = arg0_322.ladyDict[arg0_322.apartment:GetConfigID()]
	local var1_322 = var0_322.ladyAnimator:GetCurrentAnimatorStateInfo(var0_322.ladyAnimBaseLayerIndex).shortNameHash

	return var0_322.animNameMap[var1_322]
end

function var0_0.RegisterAnimCallback(arg0_323, arg1_323, arg2_323)
	arg0_323.ladyDict[arg0_323.apartment:GetConfigID()].animCallbacks[arg1_323] = arg2_323
end

function var0_0.SetCharacterAnimSpeed(arg0_324, arg1_324)
	local var0_324 = arg0_324.ladyDict[arg0_324.apartment:GetConfigID()]

	var0_324.ladyAnimator.speed = arg1_324
	var0_324.ladyHeadIKComp.blinkSpeed = var0_324.ladyHeadIKData.blinkSpeed * arg1_324

	if arg1_324 > 0 then
		var0_324.ladyHeadIKComp.DampTime = var0_324.ladyHeadIKData.DampTime / arg1_324
	else
		var0_324.ladyHeadIKComp.DampTime = var0_324.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_325, arg1_325)
	if arg1_325.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_325 = arg1_325.stringParameter
	local var1_325 = table.removebykey(arg0_325.animEventCallbacks, var0_325)

	existCall(var1_325)
end

function var0_0.RegisterAnimEventCallback(arg0_326, arg1_326, arg2_326)
	arg0_326.animEventCallbacks[arg1_326] = arg2_326
end

function var0_0.PlaySceneItemAnim(arg0_327, arg1_327, arg2_327)
	arg0_327.sceneAnimatorDict = arg0_327.sceneAnimatorDict or {}

	if not arg0_327.sceneAnimatorDict[arg1_327] then
		local var0_327 = pg.dorm3d_scene_animator[arg1_327]
		local var1_327 = arg0_327:GetSceneItem(var0_327.item_name)

		assert(var1_327, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_327 .. " " .. var0_327.item_name)

		if not var1_327 then
			return
		end

		local var2_327 = var1_327:GetComponent(typeof(Animator))

		if not var2_327 then
			return
		end

		arg0_327.sceneAnimatorDict[arg1_327] = {
			trans = var1_327,
			animator = var2_327
		}
	end

	if arg0_327.sceneAnimatorDict[arg1_327].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_327) then
		return
	end

	arg0_327.sceneAnimatorDict[arg1_327].animator:PlayInFixedTime(arg2_327)
end

function var0_0.ResetSceneItemAnimators(arg0_328, arg1_328)
	if not arg0_328.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_328.sceneAnimatorDict, function(arg0_329, arg1_329)
		if arg1_328 and table.contains(arg1_328, arg0_329) then
			return
		end

		setActive(arg1_329.trans, false)
		setActive(arg1_329.trans, true)

		arg0_328.sceneAnimatorDict[arg0_329] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_330, arg1_330, arg2_330, arg3_330, arg4_330, arg5_330)
	arg1_330.extraItems = arg1_330.extraItems or {}

	if arg1_330.extraItems[arg2_330] then
		return
	end

	local var0_330

	if arg3_330 == "" then
		var0_330 = arg1_330.lady
	else
		table.IpairsCArray(arg1_330.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_331, arg1_331)
			if arg1_331.name == arg3_330 then
				var0_330 = arg1_331
			end
		end)
	end

	if not var0_330 then
		return
	end

	arg0_330.loader:GetPrefab(string.lower("dorm3d/" .. arg2_330), "", function(arg0_332)
		setParent(arg0_332, var0_330)

		if arg4_330 then
			setLocalPosition(arg0_332, arg4_330)
		end

		if arg5_330 then
			setLocalRotation(arg0_332, arg5_330)
		end

		arg1_330.extraItems[arg2_330] = {
			trans = arg0_332.transform,
			handler = var0_330
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
			local var0_342 = arg0_339.ladyDict[arg0_339.apartment:GetConfigID()]

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
	arg1_344.ladyWatchFloat = arg1_344.ladyWatchFloat or cloneTplTo(arg0_344.resTF:Find("vfx_talk_mark"), arg1_344.ladyHeadCenter)

	setActive(arg1_344.ladyWatchFloat, arg2_344)
end

function var0_0.RegisterGlobalVolume(arg0_345)
	local var0_345 = arg0_345.globalVolume
	local var1_345 = LuaHelper.GetOrAddVolumeComponent(var0_345, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_345 = LuaHelper.GetOrAddVolumeComponent(var0_345, typeof(BLHX.PostEffect.Overrides.ColorGrading))

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

	local var3_345 = var0_345:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_345.originalVolume = {
		profile = var3_345.sharedProfile,
		weight = var3_345.weight
	}
end

function var0_0.SettingCamera(arg0_346, arg1_346)
	arg0_346.activeCameraSettings = arg1_346

	local var0_346 = arg0_346.globalVolume
	local var1_346 = LuaHelper.GetOrAddVolumeComponent(var0_346, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_346 = LuaHelper.GetOrAddVolumeComponent(var0_346, typeof(BLHX.PostEffect.Overrides.ColorGrading))

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
	local var0_349 = arg0_349.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_349.activeProfileWeight = arg2_349

	if arg0_349.activeProfileName ~= arg1_349 then
		arg0_349.activeProfileName = arg1_349

		arg0_349.loader:LoadReference("dorm3d/scenesres/res/common", arg1_349, nil, function(arg0_350)
			var0_349.profile = arg0_350
			var0_349.weight = arg0_349.activeProfileWeight

			if arg0_349.activeCameraSettings then
				arg0_349:SettingCamera(arg0_349.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_349.weight = arg0_349.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_351)
	local var0_351 = arg0_351.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_351.profile = arg0_351.originalVolume.profile
	var0_351.weight = arg0_351.originalVolume.weight

	if arg0_351.activeCameraSettings then
		arg0_351:SettingCamera(arg0_351.activeCameraSettings)
	end

	arg0_351.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_352)
	local var0_352 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_352.originalCharacterColor = {
		color = var0_352.color,
		intensity = var0_352.intensity
	}
end

function var0_0.SetCharacterLight(arg0_353, arg1_353, arg2_353, arg3_353)
	local var0_353 = arg0_353.characterLight:GetComponent(typeof(Light))
	local var1_353 = Color.Lerp(arg0_353.originalCharacterColor.color, arg1_353, arg3_353)
	local var2_353 = math.lerp(arg0_353.originalCharacterColor.intensity, arg2_353, arg3_353)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_353, var2_353)
end

function var0_0.RevertCharacterLight(arg0_354)
	arg0_354:SetCharacterLight(arg0_354.originalCharacterColor.color, arg0_354.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_355, arg1_355, arg2_355, arg3_355)
	arg2_355 = arg2_355 or {}

	table.Foreach(arg1_355.clothComps, function(arg0_356, arg1_356)
		if arg1_356 == nil then
			return
		end

		setActive(arg1_356, arg2_355[arg0_356] == 1)
	end)
	table.Foreach(arg1_355.clothColliderDict, function(arg0_357, arg1_357)
		if arg1_357 == nil then
			return
		end

		setActive(arg1_357, false)
	end)

	if arg3_355 then
		table.Foreach(arg3_355, function(arg0_358, arg1_358)
			local var0_358 = arg1_355.clothColliderDict[arg1_358[1]]

			if var0_358 == nil then
				return
			end

			setActive(var0_358, arg1_358[2] == 1)

			if arg1_358[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_358, arg1_358[3], arg1_358[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_359, arg1_359)
	table.Foreach(arg1_359.ladyClothCompSettings, function(arg0_360, arg1_360)
		arg0_360.enabled = arg1_360.enabled
	end)
	table.Foreach(arg1_359.ladyClothColliderSettings, function(arg0_361, arg1_361)
		arg0_361.enabled = arg1_361.enabled

		var0_0.SetMagicaCollider(arg0_361, arg1_361.StartRadius, arg1_361.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_362)
	if arg0_362.exited or arg0_362.retainCount > 0 then
		-- block empty
	else
		arg0_362:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_363, arg1_363, arg2_363, arg3_363, arg4_363)
	arg0_363.dormSceneMgr:LoadTimelineScene({
		name = string.lower(arg1_363),
		assetRootName = arg0_363.apartment:getConfig("asset_name"),
		isCache = arg2_363,
		waitForTimeline = arg3_363,
		callName = arg0_363.apartment:GetCallName(),
		loadSceneFunc = function(arg0_364, arg1_364)
			local var0_364 = GameObject.Find("[actor]").transform

			arg0_363:HXCharacter(tf(var0_364))
		end
	}, arg4_363)
end

function var0_0.UnloadTimelineScene(arg0_365, arg1_365, arg2_365, arg3_365)
	arg0_365.dormSceneMgr:UnloadTimelineScene(string.lower(arg1_365), arg2_365, arg3_365)
end

function var0_0.ChangeArtScene(arg0_366, arg1_366, arg2_366)
	arg1_366 = string.lower(arg1_366)

	warning(arg0_366.dormSceneMgr.artSceneInfo, "->", arg1_366, arg1_366 == arg0_366.dormSceneMgr.sceneInfo)

	local var0_366 = {}

	table.insert(var0_366, function(arg0_367)
		arg0_366.dormSceneMgr:ChangeArtScene(string.lower(arg1_366), arg0_367)
	end)

	if arg1_366 == arg0_366.dormSceneMgr.sceneInfo or arg0_366.dormSceneMgr.artSceneInfo == arg0_366.dormSceneMgr.sceneInfo then
		table.insert(var0_366, function(arg0_368)
			setActive(arg0_366.slotRoot, arg1_366 == arg0_366.dormSceneMgr.sceneInfo)
			arg0_368()
		end)
	end

	if arg1_366 == arg0_366.dormSceneMgr.sceneInfo then
		table.insert(var0_366, function(arg0_369)
			arg0_366:SwitchDayNight(arg0_366.contextData.timeIndex)
			onNextTick(function()
				arg0_366:RefreshSlots()
				arg0_369()
			end)
		end)
	end

	seriesAsync(var0_366, arg2_366)
end

function var0_0.ChangeSubScene(arg0_371, arg1_371, arg2_371)
	arg1_371 = string.lower(arg1_371)

	warning(arg0_371.dormSceneMgr.subSceneInfo, "->", arg1_371, arg1_371 == arg0_371.dormSceneMgr.subSceneInfo)

	local var0_371 = {}

	table.insert(var0_371, function(arg0_372)
		arg0_371.dormSceneMgr:ChangeSubScene(arg1_371, arg0_372)
	end)

	local var1_371 = arg0_371.ladyDict[arg0_371.apartment:GetConfigID()]

	table.insert(var0_371, function(arg0_373)
		if arg1_371 == arg0_371.dormSceneMgr.sceneInfo then
			var1_371.ladyActiveZone = var1_371.walkBornPoint or var1_371.ladyBaseZone
		else
			var1_371.ladyActiveZone = var1_371.walkBornPoint or "Default"
		end

		arg0_373()
	end)

	if arg1_371 ~= arg0_371.dormSceneMgr.subSceneInfo then
		table.insert(var0_371, function(arg0_374)
			local var0_374, var1_374 = Dorm3dSceneMgr.ParseInfo(arg1_371)
			local var2_374 = var0_374 .. "_base"

			arg0_371:ResetSceneStructure(SceneManager.GetSceneByName(var2_374))

			if arg1_371 == arg0_371.dormSceneMgr.sceneInfo then
				arg0_371:RefreshSlots()
			else
				arg0_371:SwitchAnim(var1_371, var0_0.ANIM.IDLE)
			end

			if arg0_371.dormSceneMgr.subSceneInfo == arg0_371.dormSceneMgr.sceneInfo then
				local var3_374 = Clone(arg0_371.room)

				var3_374.furnitures = {}

				arg0_371:RefreshSlots(var3_374)
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
	local var0_377 = arg1_377 - Vector3.New(unpack(arg0_377.Position))

	if var0_377.magnitude > arg0_377.Radius then
		return false
	end

	local var1_377 = Quaternion.Euler(unpack(arg0_377.Rotation))

	return Vector3.Angle(var1_377 * Vector3.forward, var0_377) <= arg0_377.Angle / 2
end

function var0_0.willExit(arg0_378)
	arg0_378.joystickTimer:Stop()
	arg0_378.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_378.updateHandler)
	arg0_378:StopIKHandTimer()

	if arg0_378.moveTimer then
		arg0_378.moveTimer:Stop()

		arg0_378.moveTimer = nil
	end

	if arg0_378.moveWaitTimer then
		arg0_378.moveWaitTimer:Stop()

		arg0_378.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_378.furnitures) then
		eachChild(arg0_378.furnitures, function(arg0_379)
			local var0_379 = GetComponent(arg0_379, typeof(EventTriggerListener))

			if not var0_379 then
				return
			end

			var0_379:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_378, iter1_378 in pairs(arg0_378.ladyDict) do
		GetComponent(iter1_378.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_378.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_378.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_378.blockLayer, arg0_378._tf)
	table.Foreach(arg0_378.expressionDict, function(arg0_380)
		arg0_378:RemoveExpression(arg0_380)
	end)
	arg0_378.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_378.dormSceneMgr:Dispose()

	arg0_378.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_381 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_381 = SystemInfo.deviceModel or ""

			local function var2_381(arg0_382)
				local var0_382 = string.match(arg0_382, "iPad(%d+)")
				local var1_382 = tonumber(var0_382)

				if var1_382 and var1_382 >= 8 then
					return true
				end

				return false
			end

			local function var3_381(arg0_383)
				local var0_383 = string.match(arg0_383, "iPhone(%d+)")
				local var1_383 = tonumber(var0_383)

				if var1_383 and var1_383 >= 13 then
					return true
				end

				return false
			end

			if var2_381(var1_381) or var3_381(var1_381) then
				var0_381 = DevicePerformanceLevel.High
			end
		end

		local var4_381 = var0_381 == DevicePerformanceLevel.High and 3 or var0_381 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_381)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_381
	end
end

function var0_0.SettingQuality()
	local var0_384 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_384)
end

function var0_0.SetMagicaCollider(arg0_385, arg1_385, arg2_385)
	local var0_385 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_385, "StartRadius", arg0_385, arg1_385)
	ReflectionHelp.RefSetProperty(var0_385, "EndRadius", arg0_385, arg2_385)
end

return var0_0
