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

		if arg0_14.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():OnDragBegin(arg2_20, arg3_20)
	end)
	arg0_14:bind(var0_0.ON_DRAG_CHARACTER_BODY, function(arg0_21, arg1_21, arg2_21)
		if not arg0_14.ikHandler then
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
		HideCharacterBylayer = true,
		EnableHeadIK = true,
		RevertCharacterBylayer = true
	}

	arg0_14:bind(var0_0.PHOTO_CALL, function(arg0_29, arg1_29, ...)
		if var2_14[arg1_29] then
			local var0_29 = arg0_14.ladyDict[arg0_14.apartment:GetConfigID()]

			arg0_14[arg1_29](arg0_14, var0_29, ...)
		else
			local var1_29 = arg0_14.ladyDict[arg0_14.apartment:GetConfigID()]

			arg0_14[arg1_29](var1_29, ...)
		end
	end)
end

function var0_0.RegisterIKFunc(arg0_30)
	pg.IKMgr.GetInstance():RegisterOnIKLayerActive(function(arg0_31)
		arg0_30.blockIK = true
		arg0_30.ikHandler = arg0_31

		local var0_31 = arg0_30.ladyDict[arg0_30.apartment:GetConfigID()]
		local var1_31 = _.detect(var0_31.readyIKLayers, function(arg0_32)
			return arg0_32:GetControllerPath() == arg0_31.ikData:GetControllerPath()
		end)

		arg0_30:EnableIKLayer(var1_31)

		arg0_30.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

		arg0_30:emit(var0_0.ON_IK_STATUS_CHANGED, var1_31:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDrag(function(arg0_33)
		arg0_30.ikHandler = arg0_33

		arg0_30:ResetIKTipTimer()
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_34, arg1_34)
		local var0_34 = arg0_30.ladyDict[arg0_30.apartment:GetConfigID()]
		local var1_34 = _.detect(var0_34.readyIKLayers, function(arg0_35)
			return arg0_35:GetControllerPath() == arg0_34.ikData:GetControllerPath()
		end)

		arg0_30:DeactiveIKLayer(var1_34)

		arg0_30.ikHandler = nil
		arg0_30.blockIK = arg1_34

		arg0_30:emit(var0_0.ON_IK_STATUS_CHANGED, var1_34:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_36)
		arg0_30.blockIK = nil

		local var0_36 = arg0_30.ladyDict[arg0_30.apartment:GetConfigID()]
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

	arg0_38.resTF = GameObject.Find("Res").transform

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
		[var0_0.CAMERA.POV] = var3_38:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	}

	setActive(arg0_38.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_38.compPovAim = arg0_38.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_38.cameraRoot = var3_38
	arg0_38.POVOriginalFOV = arg0_38:GetPOVFOV()
	arg0_38.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_38.restrictedBox, false)

	arg0_38.restrictedHeightRange = {
		arg0_38.restrictedBox:Find("Floor").position.y,
		arg0_38.restrictedBox:Find("Celling").position.y
	}
	arg0_38.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_38.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))

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

function var0_0.SwitchDayNight(arg0_41, arg1_41)
	if not IsNil(arg0_41.daynightCtrlComp) then
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

	arg0_44.sectorsDic = arg0_44.sectorsDic or {}

	if not arg0_44.sectorsDic[arg1_44.name] then
		arg0_44.sectorsDic[arg1_44.name] = table.shallowCopy(var2_0[arg1_44.name]) or {}

		setmetatable(arg0_44.sectorsDic[arg1_44.name], {
			__index = function(arg0_47, arg1_47)
				local var0_47 = arg0_44.furnitures:Find(arg1_47 .. "/StayPoint")

				if var0_47 then
					local var1_47 = var0_47.position
					local var2_47 = var0_47.eulerAngles

					arg0_47[arg1_47] = {
						Radius = 2,
						Angle = 120,
						Position = {
							var1_47.x,
							var1_47.y,
							var1_47.z
						},
						Rotation = {
							var2_47.x,
							var2_47.y,
							var2_47.z
						}
					}

					return arg0_47[arg1_47]
				else
					return nil
				end
			end
		})
	end

	arg0_44.activeSectors = arg0_44.sectorsDic[arg1_44.name]
end

function var0_0.InitSlots(arg0_48)
	local var0_48 = arg0_48.room:GetSlots()
	local var1_48 = arg0_48.modelRoot:GetComponentsInChildren(typeof(Transform), true)

	arg0_48.slotDict = {}

	_.each(var0_48, function(arg0_49)
		local var0_49 = arg0_49:GetFurnitureName()
		local var1_49 = arg0_49:GetConfigID()
		local var2_49 = arg0_48.slotRoot:Find(tostring(var1_49))

		assert(var2_49)

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

		for iter0_49 = 0, var1_48.Length - 1 do
			local var6_49 = var1_48[iter0_49]

			if var6_49.name == var0_49 then
				var5_49 = var6_49

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

	for iter0_51, iter1_51 in pairs(arg0_51.contactStateDic) do
		arg0_51.hideContactStateDic[iter0_51] = math.min(iter1_51, ApartmentRoom.ITEM_UNLOCK)
		arg0_51.contactInRangeDic[iter0_51] = false
	end

	arg0_51:ActiveContact()
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
		arg0_56.ladyDict[arg0_56.apartment:GetConfigID()]:UpdateFloatPosition()
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
		local var1_58 = setmetatable({}, {
			__index = arg0_58
		})

		arg0_58.ladyDict[iter1_58] = var1_58

		local var2_58 = getProxy(ApartmentProxy):getApartment(iter1_58)
		local var3_58 = var2_58:getConfig("asset_name")
		local var4_58 = var2_58:GetSkinModelID(arg0_58.room:getConfig("tag"))
		local var5_58 = pg.dorm3d_resource[var4_58].model_id

		assert(var5_58)

		for iter2_58, iter3_58 in ipairs({
			"common",
			var5_58
		}) do
			local var6_58 = string.format("dorm3d/character/%s/res/%s", var3_58, iter3_58)

			if checkABExist(var6_58) then
				table.insert(var0_58, function(arg0_59)
					arg0_58.loader:LoadBundle(var6_58, function(arg0_60)
						for iter0_60, iter1_60 in ipairs(arg0_60:GetAllAssetNames()) do
							local var0_60, var1_60, var2_60 = string.find(iter1_60, "material_hx[/\\](.*).mat")

							if var0_60 then
								arg0_58.hxMatDict[var2_60] = {
									arg0_60,
									iter1_60
								}
							end
						end

						arg0_59()
					end)
				end)
			end
		end

		var1_58.skinId = var4_58
		var1_58.skinIdList = {
			var4_58
		}

		table.insert(var0_58, function(arg0_61)
			local var0_61 = string.format("dorm3d/character/%s/prefabs/%s", var3_58, var5_58)

			arg0_58.loader:GetPrefab(var0_61, "", function(arg0_62)
				var1_58.ladyGameobject = arg0_62
				arg0_58.skinDict[var4_58] = {
					ladyGameobject = arg0_62
				}

				arg0_61()
			end)
		end)

		if arg0_58.room:isPersonalRoom() then
			local var7_58 = var2_58:GetSkinModelID("touch")

			if var7_58 then
				local var8_58 = pg.dorm3d_resource[var7_58].model_id

				if #var8_58 > 0 then
					table.insert(var1_58.skinIdList, var7_58)
					table.insert(var0_58, function(arg0_63)
						local var0_63 = string.format("dorm3d/character/%s/prefabs/%s", var3_58, var8_58)

						arg0_58.loader:GetPrefab(var0_63, "", function(arg0_64)
							arg0_58.skinDict[var7_58] = {
								ladyGameobject = arg0_64
							}
							GetComponent(arg0_64, "GraphOwner").enabled = false

							onNextTick(function()
								setActive(arg0_64, false)
							end)
							arg0_63()
						end)
					end)
				end
			end
		end

		if arg0_58.contextData.pendingDic[iter1_58] then
			local var9_58 = pg.dorm3d_welcome[arg0_58.contextData.pendingDic[iter1_58]]

			if var9_58.item_prefab ~= "" then
				table.insert(var0_58, function(arg0_66)
					local var0_66 = string.lower("dorm3d/furniture/item/" .. var9_58.item_prefab)

					arg0_58.loader:GetPrefab(var0_66, "", function(arg0_67)
						var1_58.tfPendintItem = arg0_67.transform

						onNextTick(function()
							setActive(arg0_67, false)
						end)
						arg0_66()
					end)
				end)
			end
		end
	end

	parallelAsync(var0_58, arg2_58)
end

function var0_0.HXCharacter(arg0_69, arg1_69)
	if not HXSet.isHx() then
		return
	end

	local var0_69 = arg1_69:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_69, function(arg0_70, arg1_70)
		local var0_70 = arg1_70.sharedMaterials
		local var1_70 = false

		table.IpairsCArray(var0_70, function(arg0_71, arg1_71)
			if arg1_71 == nil then
				return
			end

			local var0_71 = arg1_71.name

			if not arg0_69.hxMatDict[var0_71] then
				return
			end

			var1_70 = true

			local var1_71, var2_71 = unpack(arg0_69.hxMatDict[var0_71])
			local var3_71 = var1_71:LoadAssetSync(var2_71, typeof(Material), false, false)

			var0_70[arg0_71] = var3_71

			warning("Replace HX Material", arg0_69.hxMatDict[var0_71][2])
		end)

		if var1_70 then
			arg1_70.sharedMaterials = var0_70
		end
	end)
end

function var0_0.InitCharacter(arg0_72, arg1_72, arg2_72)
	arg1_72.lady = arg1_72.ladyGameobject.transform

	arg1_72.lady:SetParent(arg1_72.mainCameraTF)
	arg1_72.lady:SetParent(nil)

	arg1_72.ladyHeadIKComp = arg1_72.lady:GetComponent(typeof(HeadAimIK))
	arg1_72.ladyHeadIKComp.AimTarget = arg1_72.mainCameraTF:Find("AimTarget")
	arg1_72.ladyHeadIKData = {
		DampTime = arg1_72.ladyHeadIKComp.DampTime,
		blinkSpeed = arg1_72.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg1_72.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg1_72.ladyHeadIKComp.HeadWeight
	}

	local var0_72 = {}

	table.Foreach(var1_0, function(arg0_73, arg1_73)
		var0_72[arg1_73] = arg0_73
	end)

	arg1_72.ladyAnimator = arg1_72.lady:GetComponent(typeof(Animator))
	arg1_72.ladyAnimBaseLayerIndex = arg1_72.ladyAnimator:GetLayerIndex("Base Layer")
	arg1_72.ladyAnimFaceLayerIndex = arg1_72.ladyAnimator:GetLayerIndex("Face")
	arg1_72.ladyBoneMaps = {}

	local var1_72 = arg1_72.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_72, function(arg0_74, arg1_74)
		if arg1_74.name == "BodyCollider" then
			arg1_72.ladyCollider = arg1_74

			setActive(arg1_74, true)
		elseif arg1_74.name == "SafeCollider" then
			arg1_72.ladySafeCollider = arg1_74

			setActive(arg1_74, false)
		elseif arg1_74.name == "Interest" then
			arg1_72.ladyInterestRoot = arg1_74
		elseif arg1_74.name == "Head Center" then
			arg1_72.ladyHeadCenter = arg1_74
		end

		if var0_72[arg1_74.name] then
			arg1_72.ladyBoneMaps[var0_72[arg1_74.name]] = arg1_74
		end
	end)

	arg1_72.ladyColliders = {}
	arg1_72.ladyTouchColliders = {}

	table.IpairsCArray(arg1_72.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_75, arg1_75)
		if arg1_75:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_75)

		local var0_75 = child.name
		local var1_75 = var0_75 and string.find(var0_75, "Collider") or -1

		if var1_75 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_75)

			return
		end

		local var2_75 = string.sub(var0_75, 1, var1_75 - 1)

		if var0_0.BONE_TO_TOUCH[var2_75] == nil then
			return
		end

		arg1_72.ladyColliders[var2_75] = child

		table.insert(arg1_72.ladyTouchColliders, child)
		setActive(child, false)
	end)
	arg1_72:HXCharacter(arg1_72.lady)
	;(function()
		local var0_76 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_76 = "vfx_function_aixin02"

		arg1_72.loader:GetPrefab(var0_76, var1_76, function(arg0_77)
			arg1_72.effectHeart = arg0_77

			setActive(arg0_77, false)
			onNextTick(function()
				setParent(arg1_72.effectHeart, arg1_72.ladyHeadCenter)
			end)
		end)
	end)()

	arg1_72.clothComps = {}
	arg1_72.ladyClothCompSettings = {}

	table.IpairsCArray(arg1_72.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_79, arg1_79)
		table.insert(arg1_72.clothComps, arg1_79)

		arg1_72.ladyClothCompSettings[arg1_79] = {
			enabled = arg1_79.enabled
		}
	end)

	arg1_72.clothColliderDict = {}
	arg1_72.ladyClothColliderSettings = {}

	local var2_72 = typeof("MagicaCloth.MagicaCapsuleCollider")

	table.IpairsCArray(arg1_72.lady:GetComponentsInChildren(var2_72, true), function(arg0_80, arg1_80)
		arg1_72.clothColliderDict[arg1_80.name] = arg1_80
		arg1_72.ladyClothColliderSettings[arg1_80] = {
			enabled = arg1_80.enabled,
			StartRadius = ReflectionHelp.RefGetProperty(var2_72, "StartRadius", arg1_80),
			EndRadius = ReflectionHelp.RefGetProperty(var2_72, "EndRadius", arg1_80)
		}
	end)
	arg1_72:EnableCloth(arg1_72, false)

	arg1_72.ladyIKRoot = arg1_72.lady:Find("IKLayers")

	eachChild(arg1_72.ladyIKRoot, function(arg0_81)
		setActive(arg0_81, false)
	end)
	GetComponent(arg1_72.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_82, arg1_82)
		if arg1_82.rawPointerPress.transform == arg1_72.ladyCollider then
			arg1_72:emit(var0_0.CLICK_CHARACTER, arg2_72)
		else
			local var0_82 = table.keyof(arg1_72.IKSettings.Colliders, arg1_82.rawPointerPress.transform)

			arg1_72:emit(var0_0.ON_TOUCH_CHARACTER, var0_0.BONE_TO_TOUCH[var0_82] or arg1_82.rawPointerPress.name)
		end
	end)
	arg1_72.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_83)
		if arg1_72.nowState and arg0_83.animatorStateInfo:IsName(arg1_72.nowState) then
			existCall(arg1_72.stateCallback)

			return
		end

		local var0_83 = arg0_83.animatorStateInfo

		for iter0_83, iter1_83 in pairs(arg1_72.animCallbacks) do
			if var0_83:IsName(iter0_83) then
				warning("Active", iter0_83)

				local var1_83 = table.removebykey(arg1_72.animCallbacks, iter0_83)

				existCall(var1_83)

				return
			end
		end

		if arg0_83.stringParameter ~= "" then
			arg1_72:OnAnimationEvent(arg0_83)
		end
	end)

	arg1_72.animEventCallbacks = {}
	arg1_72.animCallbacks = {}
end

function var0_0.SwitchCharacterSkin(arg0_84, arg1_84, arg2_84, arg3_84, arg4_84)
	local var0_84 = arg1_84.skinIdList

	assert(table.contains(var0_84, arg3_84))

	local var1_84 = arg0_84:GetCurrentAnim()
	local var2_84 = arg1_84.skinId
	local var3_84 = arg1_84.skinDict[var2_84].ladyGameobject
	local var4_84 = var3_84.transform.position
	local var5_84 = var3_84.transform.rotation

	setActive(var3_84, false)

	arg1_84.skinId = arg3_84

	setActive(arg1_84.skinDict[arg3_84].ladyGameobject, true)

	arg1_84.ladyGameobject = arg1_84.skinDict[arg3_84].ladyGameobject
	arg1_84.ladyCollider = nil

	arg0_84:InitCharacter(arg1_84, arg2_84)
	arg1_84.ladyAnimator:Play(var1_84, arg1_84.ladyAnimBaseLayerIndex)
	arg1_84.ladyAnimator:Update(0)
	arg1_84.lady:SetPositionAndRotation(var4_84, var5_84)
	existCall(arg4_84)
end

function var0_0.SetCameraLady(arg0_85, arg1_85)
	arg0_85.cameraAim2.LookAt = arg1_85.ladyInterestRoot
	arg0_85.cameras[var0_0.CAMERA.TALK].Follow = arg0_85.ladyInterest
	arg0_85.cameras[var0_0.CAMERA.TALK].LookAt = arg0_85.ladyInterest
	arg0_85.cameraGift.Follow = arg0_85.ladyInterest
	arg0_85.cameraGift.LookAt = arg0_85.ladyInterest
	arg0_85.cameraRole2.LookAt = arg1_85.ladyInterestRoot
	arg0_85.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_85.ladyInterest
	arg0_85.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_85.ladyInterest
end

function var0_0.initNodeCanvas(arg0_86)
	local var0_86 = pg.NodeCanvasMgr.GetInstance()

	var0_86:Active()
	var0_86:RegisterFunc("DistanceTrigger", function(arg0_87)
		arg0_86:emit(var0_0.DISTANCE_TRIGGER, arg0_87, arg0_86.ladyDict[arg0_87].dis)
	end)
	var0_86:RegisterFunc("ShortWaitAction", function(arg0_88)
		arg0_86:DoShortWait(arg0_88)
	end)
	var0_86:RegisterFunc("WatchShortWaitAction", function(arg0_89)
		arg0_86:DoShortWait(arg0_89)
	end)
	var0_86:RegisterFunc("WalkDistanceTrigger", function(arg0_90)
		arg0_86:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_90, arg0_86.ladyDict[arg0_90].dis)
	end)
	var0_86:RegisterFunc("ChangeWatch", function(arg0_91)
		arg0_86:emit(var0_0.CHANGE_WATCH, arg0_91)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_92, arg1_92, arg2_92)
	arg0_92[arg1_92] = arg2_92

	for iter0_92, iter1_92 in pairs(arg0_92.ladyDict) do
		arg0_92:SetBlackboardValue(iter1_92, arg1_92, arg2_92)
	end
end

function var0_0.SetBlackboardValue(arg0_93, arg1_93, arg2_93, arg3_93)
	arg1_93.blackboard = arg1_93.blackboard or {}
	arg1_93.blackboard[arg2_93] = arg3_93

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg2_93, arg3_93, arg1_93.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_94, arg1_94, arg2_94)
	arg1_94.blackboard = arg1_94.blackboard or {}

	return arg1_94.blackboard[arg2_94]
end

function var0_0.didEnter(arg0_95)
	local var0_95 = -21.6 / Screen.height

	arg0_95.joystickDelta = Vector2.zero
	arg0_95.joystickTimer = FrameTimer.New(function()
		local var0_96 = arg0_95.joystickDelta * var0_95
		local var1_96 = var0_96.x
		local var2_96 = var0_96.y

		local function var3_96(arg0_97, arg1_97, arg2_97)
			local var0_97 = arg0_97[arg1_97]

			var0_97.m_InputAxisValue = arg2_97
			arg0_97[arg1_97] = var0_97
		end

		if arg0_95.surroudCamera and not arg0_95.pinchMode then
			var3_96(arg0_95.surroudCamera, "m_XAxis", var1_96)
			var3_96(arg0_95.surroudCamera, "m_YAxis", var2_96)
		elseif arg0_95.furniturePOV and arg0_95.cameras[var0_0.CAMERA.FURNITURE_WATCH] and isActive(arg0_95.cameras[var0_0.CAMERA.FURNITURE_WATCH]) then
			var3_96(arg0_95.furniturePOV, "m_HorizontalAxis", var1_96)
			var3_96(arg0_95.furniturePOV, "m_VerticalAxis", var2_96)
		end

		arg0_95.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_95.joystickTimer:Start()

	local var1_95 = 1.75

	arg0_95.moveStickTimer = FrameTimer.New(function()
		if not arg0_95.moveStickDraging then
			return
		end

		local var0_98 = arg0_95.moveStickPosition
		local var1_98 = 200
		local var2_98 = (var0_98 - arg0_95.moveStickOrigin):ClampMagnitude(var1_98)
		local var3_98 = var2_98 / var1_98

		arg0_95.moveStickPosition = arg0_95.moveStickOrigin + var2_98

		local var4_98 = Vector3.New(var3_98.x, 0, var3_98.y)
		local var5_98 = arg0_95.mainCameraTF:TransformDirection(var4_98)

		var5_98.y = 0

		local var6_98 = var5_98:Normalize()

		var6_98:Mul(var1_95)

		if isActive(arg0_95.cameras[var0_0.CAMERA.POV]) then
			arg0_95.playerController:SimpleMove(var6_98)

			arg0_95.tweenFOV = true
		elseif isActive(arg0_95.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_95.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_98 * Time.deltaTime)
			arg0_95:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_98:Normalize())
			onNextTick(function()
				local var0_99 = arg0_95.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_99 = math.InverseLerp(arg0_95.restrictedHeightRange[1], arg0_95.restrictedHeightRange[2], var0_99.position.y)

				arg0_95:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_99)
			end)
		end
	end, 1, -1)

	arg0_95.moveStickTimer:Start()

	arg0_95.pinchMode = false
	arg0_95.pinchSize = 0
	arg0_95.pinchValue = 1
	arg0_95.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_100, arg1_100)
		if arg0_95.surroudCamera and isActive(arg0_95.surroudCamera) then
			arg0_95.pinchMode = true
			arg0_95.pinchSize = (arg0_100 - arg1_100):Magnitude()
			arg0_95.pinchNodeOrder = arg1_100.x < arg0_100.x and -1 or 1

			return
		end

		if isActive(arg0_95.cameras[var0_0.CAMERA.POV]) then
			if (arg0_100 - arg1_100):Magnitude() < Screen.height * 0.5 then
				arg0_95.pinchMode = true
				arg0_95.pinchSize = (arg0_100 - arg1_100):Magnitude()
				arg0_95.pinchNodeOrder = arg1_100.x < arg0_100.x and -1 or 1
			end

			return
		end
	end)

	local var2_95 = 0.01

	if IsUnityEditor then
		var2_95 = 0.1
	end

	local var3_95 = var2_95 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_101, arg1_101)
		if not arg0_95.pinchMode then
			return
		end

		local var0_101 = (arg0_101 - arg1_101):Magnitude()
		local var1_101 = arg0_95.pinchSize - var0_101
		local var2_101 = arg0_95.pinchNodeOrder * (arg1_101.x < arg0_101.x and -1 or 1)
		local var3_101 = var1_101 * var3_95 * var2_101

		if isActive(arg0_95.cameras[var0_0.CAMERA.POV]) then
			local var4_101 = 0.5
			local var5_101 = 1

			arg0_95.pinchValue = math.clamp(arg0_95.pinchValue + var3_101, var4_101, var5_101)
			arg0_95.pinchSize = var0_101

			arg0_95:SetPOVFOV(arg0_95.POVOriginalFOV * arg0_95.pinchValue)

			arg0_95.tweenFOV = nil

			return
		end

		if isActive(arg0_95.surroudCamera) and arg0_95.surroudCamera == arg0_95.cameras[var0_0.CAMERA.PHOTO] then
			local var6_101 = 0.5
			local var7_101 = 1

			arg0_95:SetPinchValue(math.clamp(arg0_95.pinchValue + var3_101, var6_101, var7_101))

			arg0_95.pinchSize = var0_101

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_95.pinchMode = false
		arg0_95.pinchSize = 0
	end)

	arg0_95.cameraBlendCallbacks = {}
	arg0_95.activeCMCamera = nil

	function arg0_95.camBrainEvenetHandler.OnBlendStarted(arg0_103)
		if arg0_95.activeCMCamera then
			arg0_95:OnCameraBlendFinished(arg0_95.activeCMCamera)
		end

		local var0_103 = arg0_95.camBrain.ActiveVirtualCamera

		arg0_95.activeCMCamera = var0_103
	end

	function arg0_95.camBrainEvenetHandler.OnBlendFinished(arg0_104)
		arg0_95.activeCMCamera = nil

		arg0_95:OnCameraBlendFinished(arg0_104)
	end

	for iter0_95, iter1_95 in pairs(arg0_95.ladyDict) do
		if iter1_95.tfPendintItem then
			onNextTick(function()
				setParent(iter1_95.tfPendintItem, iter1_95.lady)
			end)
		end

		iter1_95.ladyOwner = GetComponent(iter1_95.lady, "GraphOwner")
		iter1_95.ladyBlackboard = GetComponent(iter1_95.lady, "Blackboard")

		arg0_95:SetBlackboardValue(iter1_95, "groupId", iter0_95)
		onNextTick(function()
			iter1_95.ladyOwner.enabled = true
		end)
	end

	arg0_95.expressionDict = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_95.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_95:ActiveCamera(arg0_95.cameras[var0_0.CAMERA.POV])

	local var4_95
	local var5_95
	local var6_95 = arg0_95.resumeCallback

	function arg0_95.resumeCallback()
		var5_95 = true

		if var4_95 then
			existCall(var6_95)
		end
	end

	arg0_95:RefreshSlots(nil, function()
		var4_95 = true

		if var5_95 then
			existCall(var6_95)
		end
	end)

	arg0_95.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_95:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_95.updateHandler)
end

function var0_0.InitData(arg0_112)
	if not arg0_112.contextData.ladyZone then
		arg0_112.contextData.ladyZone = {}

		local var0_112
		local var1_112 = arg0_112.room:getConfig("default_zone")

		for iter0_112, iter1_112 in ipairs(arg0_112.contextData.groupIds) do
			for iter2_112, iter3_112 in ipairs(var1_112) do
				if iter3_112[1] == iter1_112 then
					arg0_112.contextData.ladyZone[iter1_112] = iter3_112[2]

					break
				end
			end

			assert(arg0_112.contextData.ladyZone[iter1_112])

			var0_112 = var0_112 or arg0_112.contextData.ladyZone[iter1_112]
		end

		arg0_112.contextData.inFurnitureName = var0_112 or arg0_112.room:getConfig("default_zone")[1][2]
	end

	arg0_112.zoneDatas = _.select(arg0_112.room:GetZones(), function(arg0_113)
		return not arg0_113:IsGlobal()
	end)
	arg0_112.activeSectors = {}
	arg0_112.activeLady = {}
end

function var0_0.Update(arg0_114)
	arg0_114.raycastCamera.fieldOfView = arg0_114.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_114.tweenFOV then
		local var0_114 = Damp(1, 1, Time.deltaTime)

		arg0_114.pinchValue = Mathf.Lerp(arg0_114.pinchValue, 1, var0_114)

		arg0_114:SetPOVFOV(arg0_114.POVOriginalFOV * arg0_114.pinchValue)

		if arg0_114.pinchValue > 0.99 then
			arg0_114.tweenFOV = nil
		end
	end

	if isActive(arg0_114.cameras[var0_0.CAMERA.POV]) then
		arg0_114:TriggerLadyDistance()
	end

	if arg0_114.contactInRangeDic then
		local var1_114 = arg0_114.mainCameraTF.forward
		local var2_114 = arg0_114.mainCameraTF.position
		local var3_114 = UnityEngine.Rect.New(0, 0, Screen.width, Screen.height)

		local function var4_114(arg0_115, arg1_115, arg2_115)
			local var0_115 = arg0_115.position - var2_114
			local var1_115 = Clone(var0_115)

			var1_115.y = 0

			if arg1_115 < var1_115.magnitude then
				return false
			end

			local var2_115 = var0_115:Normalize()
			local var3_115 = math.acos(Vector3.Dot(var2_115, var1_114)) * math.rad2Deg

			if arg2_115 < math.abs(var3_115) then
				return false
			end

			local var4_115 = arg0_114.raycastCamera:WorldToScreenPoint(arg0_115.position)

			if var4_115.z < 0 then
				return false
			end

			if not var3_114:Contains(var4_115) then
				return false
			end

			return true
		end

		for iter0_114, iter1_114 in pairs(arg0_114.contactInRangeDic) do
			local var5_114 = pg.dorm3d_collection_template[iter0_114]
			local var6_114 = underscore.any(var5_114.vfx_prefab, function(arg0_116)
				return arg0_114.modelRoot:Find(arg0_116) and var4_114(arg0_114.modelRoot:Find(arg0_116), 2, 60)
			end)

			if tobool(iter1_114) ~= var6_114 then
				arg0_114.contactInRangeDic[iter0_114] = var6_114

				arg0_114:UpdateContactDisplay(iter0_114, var6_114 and not arg0_114.hideConcatFlag and arg0_114.contactStateDic[iter0_114] or arg0_114.hideContactStateDic[iter0_114])
			end
		end
	end

	if arg0_114.enableFloatUpdate then
		arg0_114.ladyDict[arg0_114.apartment:GetConfigID()]:UpdateFloatPosition()
	end

	arg0_114:CheckInSector()

	if arg0_114.apartment then
		(function(arg0_117)
			(function()
				if not arg0_114.ikHandler then
					return
				end

				local var0_118 = arg0_114.ikHandler.screenPosition
				local var1_118 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_118 = var0_118 - Vector2.New(var1_118.width, var1_118.height) * 0.5

				setAnchoredPosition(arg0_114:GetIKHandTF(), var2_118)

				if Time.time > arg0_114.ikNextCheckStamp then
					arg0_114.ikNextCheckStamp = arg0_114.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_118 = _.detect(arg0_117.readyIKLayers, function(arg0_119)
						return arg0_119:GetControllerPath() == arg0_114.ikHandler.ikData:GetControllerPath()
					end)

					arg0_114:emit(var0_0.ON_IK_STATUS_CHANGED, var3_118:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_114.enableIKTip then
				local var0_117 = not arg0_114.blockIK and Time.time > arg0_114.nextTipIKTime

				if var0_117 then
					local var1_117 = arg0_117.ikConfig

					UIItemList.StaticAlign(arg0_114.ikTipsRoot, arg0_114.ikTipsRoot:GetChild(0), #arg0_117.readyIKLayers, function(arg0_120, arg1_120, arg2_120)
						if arg0_120 ~= UIItemList.EventUpdate then
							return
						end

						arg1_120 = arg1_120 + 1

						local var0_120
						local var1_120 = Vector2.zero
						local var2_120 = arg0_117.readyIKLayers[arg1_120]
						local var3_120 = var2_120:GetTriggerBoneName()
						local var4_120 = var3_120 and arg0_117.IKSettings.Colliders[var3_120] or nil
						local var5_120 = var2_120:GetIKTipOffset()

						if var4_120 then
							local function var6_120()
								local var0_121 = arg0_117.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var4_120.position)
								local var1_121 = CameraMgr.instance:Raycast(arg0_117.IKSettings.CameraRaycaster, var0_121)

								if var1_121.Length == 0 then
									return
								end

								return var4_120 == var1_121[0].gameObject.transform
							end
						end

						if var4_120 then
							local var7_120 = var4_120.position
							local var8_120 = var4_120:GetComponent(typeof(UnityEngine.Collider))

							if var8_120 then
								var7_120 = var8_120.bounds.center
							end

							local var9_120 = arg0_114:GetLocalPosition(arg0_114:GetScreenPosition(var7_120, arg0_117.IKSettings.CameraRaycaster.eventCamera), arg0_114.ikTipsRoot) + var5_120

							setLocalPosition(arg2_120, var9_120)

							local var10_120 = var2_120:GetTriggerRect()
							local var11_120 = var10_120:PointToNormalized(Vector2.zero)
							local var12_120 = Vector2.zero

							if var11_120.x < 0.5 and var11_120.y < 0.5 then
								var12_120 = var10_120.max
							elseif var11_120.x >= 0.5 and var11_120.y < 0.5 then
								var12_120 = Vector2.New(var10_120.xMin, var10_120.yMax)
							elseif var11_120.x < 0.5 and var11_120.y >= 0.5 then
								var12_120 = Vector2.New(var10_120.xMax, var10_120.yMin)
							elseif var11_120.x >= 0.5 and var11_120.y >= 0.5 then
								var12_120 = var10_120.min
							end

							if var11_120.x == 0.5 then
								if var9_120.x < 0 then
									var12_120.x = var10_120.xMax
								else
									var12_120.x = var10_120.xMin
								end
							end

							if var11_120.y == 0.5 then
								if var9_120.y < 0 then
									var12_120.y = var10_120.yMax
								else
									var12_120.y = var10_120.yMin
								end
							end

							local var13_120 = var12_120 - var10_120.center

							setLocalRotation(arg2_120, Quaternion.LookRotation(Vector3.forward, Vector3.New(var13_120.x, var13_120.y, 0)))
						end

						setActive(arg2_120, var4_120)
					end)
					UIItemList.StaticAlign(arg0_114.ikClickTipsRoot, arg0_114.ikClickTipsRoot:GetChild(0), #var1_117.touch_data, function(arg0_122, arg1_122, arg2_122)
						if arg0_122 ~= UIItemList.EventUpdate then
							return
						end

						arg1_122 = arg1_122 + 1

						local var0_122
						local var1_122 = Vector2.zero
						local var2_122 = arg1_122
						local var3_122 = var1_117.touch_data[var2_122][1]
						local var4_122 = pg.dorm3d_ik_touch[var3_122]

						if #var4_122.scene_item > 0 then
							var0_122 = arg0_114:GetSceneItem(var4_122.scene_item)
						else
							var0_122 = arg0_117.IKSettings.Colliders[var4_122.body]
						end

						if var0_122 then
							local var5_122 = var0_122.position
							local var6_122 = var0_122:GetComponent(typeof(UnityEngine.Collider))

							if var6_122 then
								var5_122 = var6_122.bounds.center
							end

							setLocalPosition(arg2_122, arg0_114:GetLocalPosition(arg0_114:GetScreenPosition(var5_122, arg0_117.IKSettings.CameraRaycaster.eventCamera), arg0_114.ikClickTipsRoot) + var1_122)
						end

						setActive(arg2_122, var0_122)
					end)
				end

				setActive(arg0_114.ikTipsRoot, var0_117)
				setActive(arg0_114.ikClickTipsRoot, var0_117)
				setActive(arg0_114.ikTextTipsRoot, var0_117)
			end
		end)(arg0_114.ladyDict[arg0_114.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_123)
	if not isActive(arg0_123.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_123 = arg0_123.mainCameraTF.position

	var0_123.y = 0

	for iter0_123, iter1_123 in pairs(arg0_123.ladyDict) do
		local var1_123 = tobool(arg0_123.activeLady[iter0_123])

		if var1_123 ~= tobool(var0_0.IsPointInSector(arg0_123.activeSectors[iter1_123.ladyActiveZone], var0_123)) then
			arg0_123.activeLady[iter0_123] = not var1_123

			arg0_123:emit(var0_0.ON_ENTER_SECTOR, iter0_123)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_124)
	for iter0_124, iter1_124 in pairs(arg0_124.ladyDict) do
		iter1_124.dis = (iter1_124.lady.position - arg0_124.player.position).magnitude

		if (arg0_124:GetBlackboardValue(iter1_124, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_124.dis ~= arg0_124:GetBlackboardValue(iter1_124, "inDistance") then
			arg0_124:SetBlackboardValue(iter1_124, "inDistance", iter1_124.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_124:emit(var0_0.ON_CHANGE_DISTANCE, iter0_124, iter1_124.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end
end

function var0_0.OnStickMove(arg0_125, arg1_125)
	arg0_125.joystickDelta = arg1_125
end

function var0_0.SetPinchValue(arg0_126, arg1_126)
	arg0_126.pinchValue = arg1_126

	arg0_126:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_127)
	local var0_127 = arg0_127.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_127)
end

function var0_0.SetPOVFOV(arg0_128, arg1_128)
	local var0_128 = arg0_128.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_128, arg1_128)

	arg0_128.cameras[var0_0.CAMERA.POV].m_Lens = var0_128
end

function var0_0.RefreshSlots(arg0_129, arg1_129, arg2_129)
	arg1_129 = arg1_129 or arg0_129.room

	local var0_129 = arg1_129:GetSlots()
	local var1_129 = arg1_129:GetFurnitures()

	arg0_129:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_129, function(arg0_130, arg1_130, arg2_130)
		local var0_130 = arg1_130:GetConfigID()
		local var1_130 = _.detect(var1_129, function(arg0_131)
			return arg0_131:GetSlotID() == var0_130
		end)
		local var2_130 = var1_130 and var1_130:GetModel() or false
		local var3_130 = arg0_129.slotDict[var0_130].model

		arg0_129.slotDict[var0_130].displayModelName = var2_130
		arg0_129.slotDict[var0_130].furnitureId = var1_130 and var1_130:GetConfigID()

		local function var4_130(arg0_132)
			if var3_130 then
				setActive(var3_130, var2_130 == "")
			end

			table.Foreach(arg0_129.slotDict[var0_130].sceneHides or {}, function(arg0_133, arg1_133)
				setActive(arg1_133.trans, arg1_133.visible)
			end)

			arg0_129.slotDict[var0_130].sceneHides = {}

			if arg0_132 then
				local var0_132 = arg0_132:getConfig("scene_hides")

				if #var0_132 > 0 then
					table.Ipairs(var0_132, function(arg0_134, arg1_134)
						local var0_134 = arg0_129.modelRoot:Find(arg1_134)

						assert(var0_134, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_132:GetConfigID(), arg1_134))

						local var1_134 = isActive(var0_134)

						table.insert(arg0_129.slotDict[var0_130].sceneHides, {
							name = arg1_134,
							trans = var0_134,
							visible = var1_134
						})
						setActive(var0_134, false)
					end)
				end
			end
		end

		if var2_130 == false or var2_130 == "" then
			arg0_129.loader:ClearRequest("slot_" .. var0_130)
			var4_130()
			arg2_130()

			return
		end

		local var5_130 = arg0_129.slotDict[var0_130].trans

		if arg0_129.loader:GetLoadingRP("slot_" .. var0_130) then
			arg0_129:emit(var0_0.HIDE_BLOCK)
		end

		arg0_129.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_130, "", function(arg0_135)
			arg2_130()
			assert(arg0_135)
			setParent(arg0_135, var5_130)
			var4_130(var1_130)
		end, "slot_" .. var0_130)
	end, function()
		arg0_129:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_129)
	end)
end

function var0_0.CheckSceneItemActiveByPath(arg0_137, arg1_137)
	local var0_137 = arg0_137:GetSceneItem(arg1_137)

	return arg0_137:CheckSceneItemActive(var0_137)
end

function var0_0.CheckSceneItemActive(arg0_138, arg1_138)
	local var0_138 = true
	local var1_138

	table.Checkout(arg0_138.slotDict, function(arg0_139, arg1_139)
		if underscore.detect(arg1_139.sceneHides, function(arg0_140)
			return arg0_140.trans == arg1_138
		end) then
			var0_138 = false
			var1_138 = arg1_139.furnitureId

			return false
		end
	end)

	return var0_138, var1_138
end

function var0_0.ChangeCharacterPosition(arg0_141, arg1_141)
	arg0_141:ResetCharPoint(arg1_141, arg1_141.ladyActiveZone)
	arg0_141:SyncInterestTransform(arg1_141)
end

function var0_0.SyncCurrentInterestTransform(arg0_142)
	local var0_142 = arg0_142.ladyDict[arg0_142.apartment:GetConfigID()]

	arg0_142:SyncInterestTransform(var0_142)
end

function var0_0.SyncInterestTransform(arg0_143, arg1_143)
	arg0_143.ladyInterest.position = arg1_143.ladyInterestRoot.position
	arg0_143.ladyInterest.rotation = arg1_143.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_144, arg1_144)
	arg1_144 = arg1_144 or arg0_144.contextData.inFurnitureName

	local var0_144 = arg0_144.furnitures:Find(arg1_144):Find("PlayerPoint").position

	arg0_144.player.position = var0_144
	arg0_144.cameras[var0_0.CAMERA.POV].transform.position = arg0_144.playerEye.position

	local var1_144 = arg0_144.ladyInterest.position - arg0_144.playerEye.position
	local var2_144 = Quaternion.LookRotation(var1_144).eulerAngles
	local var3_144 = var2_144.y
	local var4_144 = var2_144.x
	local var5_144 = arg0_144.compPovAim.m_HorizontalAxis

	var5_144.Value = arg0_144:GetNearestAngle(var3_144, var5_144.m_MinValue, var5_144.m_MaxValue)
	arg0_144.compPovAim.m_HorizontalAxis = var5_144

	local var6_144 = arg0_144.compPovAim.m_VerticalAxis

	var6_144.Value = var4_144
	arg0_144.compPovAim.m_VerticalAxis = var6_144
end

function var0_0.GetAttachedFurnitureName(arg0_145)
	return arg0_145.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_146, arg1_146)
	return underscore.detect(arg0_146.attachedPoints, function(arg0_147)
		return arg0_147.name == arg1_146
	end)
end

function var0_0.GetSlotByID(arg0_148, arg1_148)
	return arg0_148.displaySlots[arg1_148] and arg0_148.displaySlots[arg1_148].trans
end

function var0_0.GetScreenPosition(arg0_149, arg1_149, arg2_149)
	arg2_149 = arg2_149 or arg0_149.raycastCamera

	local var0_149 = arg2_149:WorldToScreenPoint(arg1_149)

	if var0_149.z < 0 then
		var0_149.x = var0_149.x + (var0_149.x < 0 and -1 or 1) * Screen.width
		var0_149.y = var0_149.y + (var0_149.y < 0 and -1 or 1) * Screen.height
		var0_149.z = -var0_149.z
	end

	return var0_149
end

function var0_0.GetLocalPosition(arg0_150, arg1_150, arg2_150)
	return LuaHelper.ScreenToLocal(arg2_150, arg1_150, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_151)
	return arg0_151.modelRoot
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

				var1_154.ladyBaseZone = arg0_152.contextData.ladyZone[var0_154]
				var1_154.ladyActiveZone = arg0_152.contextData.ladyZone[var0_154]

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

			if not arg0_152.apartment then
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

function var0_0.ShowBlackScreen(arg0_161, arg1_161, arg2_161)
	local var0_161 = arg0_161.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_161 and 0 or 0.3
	}

	setImageColor(arg0_161.blackLayer, Color.NewHex(var0_161.color))
	setActive(arg0_161.blackLayer, true)
	setCanvasGroupAlpha(arg0_161.blackLayer, arg1_161 and 0 or 1)
	arg0_161:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_161 then
			setActive(arg0_161.blackLayer, false)
		end

		existCall(arg2_161)
	end, GetComponent(arg0_161.blackLayer, typeof(CanvasGroup)), arg1_161 and 1 or 0, var0_161.time):setDelay(var0_161.delay)
end

function var0_0.RegisterOrbits(arg0_163, arg1_163)
	arg0_163 = arg0_163.scene
	arg0_163.orbits = {
		original = arg1_163.m_Orbits
	}
	arg0_163.orbits.current = _.range(3):map(function(arg0_164)
		local var0_164 = arg0_163.orbits.original[arg0_164 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_164.m_Height, var0_164.m_Radius)
	end)
	arg0_163.surroudCamera = arg1_163
end

function var0_0.SetCameraObrits(arg0_165)
	arg0_165 = arg0_165.scene

	local var0_165 = arg0_165.surroudCamera

	if not var0_165 then
		return
	end

	local var1_165 = arg0_165.orbits.original[1]

	for iter0_165 = 0, #arg0_165.orbits.current - 1 do
		local var2_165 = arg0_165.orbits.current[iter0_165 + 1]
		local var3_165 = arg0_165.orbits.original[iter0_165]

		var2_165.m_Height = math.lerp(var1_165.m_Height, var3_165.m_Height, arg0_165.pinchValue)
		var2_165.m_Radius = var3_165.m_Radius * arg0_165.pinchValue
	end

	var0_165.m_Orbits = arg0_165.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_166)
	arg0_166 = arg0_166.scene

	local var0_166 = arg0_166.surroudCamera

	if not var0_166 then
		return
	end

	for iter0_166 = 0, #arg0_166.orbits.current - 1 do
		local var1_166 = arg0_166.orbits.current[iter0_166 + 1]
		local var2_166 = arg0_166.orbits.original[iter0_166]

		var1_166.m_Height = var2_166.m_Height
		var1_166.m_Radius = var2_166.m_Radius
	end

	var0_166.m_Orbits = arg0_166.orbits.current
	arg0_166.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_167, arg1_167, arg2_167)
	local var0_167 = {
		base = function(arg0_168)
			arg0_167:RegisterCameraBlendFinished(arg0_167.cameras[var0_0.CAMERA.POV], arg0_168)
			arg0_167:ActiveCamera(arg0_167.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_169)
			assert(arg0_167.apartment)
			arg0_167:SyncInterestTransform(arg0_167.ladyDict[arg0_167.apartment:GetConfigID()])
			arg0_167:SetCameraLady(arg0_167.ladyDict[arg0_167.apartment:GetConfigID()])
			arg0_167:RegisterCameraBlendFinished(arg0_167.cameras[var0_0.CAMERA.ROLE], arg0_169)
			arg0_167:ActiveCamera(arg0_167.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_170)
			arg0_167:RegisterCameraBlendFinished(arg0_167.cameras[var0_0.CAMERA.POV], arg0_170)
			arg0_167:ActiveCamera(arg0_167.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_171)
			arg0_171()
		end,
		gift = function(arg0_172)
			assert(arg0_167.apartment)
			arg0_167:SetCameraLady(arg0_167.ladyDict[arg0_167.apartment:GetConfigID()])
			arg0_167:RegisterCameraBlendFinished(arg0_167.cameras[var0_0.CAMERA.GIFT], arg0_172)
			arg0_167:ActiveCamera(arg0_167.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_173)
			assert(arg0_167.apartment)
			arg0_167:SetCameraLady(arg0_167.ladyDict[arg0_167.apartment:GetConfigID()])

			arg0_167.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_167.cameraRole.transform.position

			arg0_167:RegisterCameraBlendFinished(arg0_167.cameras[var0_0.CAMERA.ROLE2], arg0_173)
			arg0_167:ActiveCamera(arg0_167.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_174)
			assert(arg0_167.apartment)
			arg0_167:SetCameraLady(arg0_167.ladyDict[arg0_167.apartment:GetConfigID()])
			arg0_167:SyncInterestTransform(arg0_167.ladyDict[arg0_167.apartment:GetConfigID()])
			arg0_167:RegisterCameraBlendFinished(arg0_167.cameras[var0_0.CAMERA.TALK], arg0_174)
			arg0_167:ActiveCamera(arg0_167.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_167 = {}

	table.insert(var1_167, function(arg0_175)
		switch(arg1_167, var0_167, arg0_175, arg0_175)
	end)
	seriesAsync(var1_167, arg2_167)
end

function var0_0.GetSceneItem(arg0_176, arg1_176)
	local var0_176

	if string.find(arg1_176, "fbx/") == 1 then
		var0_176 = arg0_176.modelRoot:Find(arg1_176)
	elseif string.find(arg1_176, "FurnitureSlots/") == 1 then
		arg1_176 = string.gsub(arg1_176, "^FurnitureSlots/", "", 1)
		var0_176 = arg0_176.slotRoot:Find(arg1_176)
	end

	if not var0_176 then
		warning(string.format("Missing scene item path: %s", arg1_176))
	end

	return var0_176
end

function var0_0.SetIKStatus(arg0_177, arg1_177, arg2_177, arg3_177)
	warning("Set IKStatus " .. (arg2_177.id or "NIL"))

	arg0_177.enableIKTip = true

	arg0_177:ResetIKTipTimer()
	setActive(arg1_177.ladyCollider, false)
	_.each(arg1_177.ladyTouchColliders, function(arg0_178)
		setActive(arg0_178, true)
	end)

	arg0_177.blockIK = nil
	arg1_177.ikActionDict = {}
	arg1_177.readyIKLayers = {}
	arg1_177.IKSettings = {
		Colliders = arg1_177.ladyColliders,
		CameraRaycaster = arg0_177.sceneRaycaster
	}

	local var0_177 = _.map(arg2_177.ik_id, function(arg0_179)
		local var0_179 = Dorm3dIK.New({
			configId = arg0_179[1]
		})
		local var1_179 = arg0_179[3]
		local var2_179 = var1_179[1]
		local var3_179 = switch(var2_179, {
			function(arg0_180, arg1_180)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_182, arg1_182)
				return arg0_182
			end,
			function(arg0_183, arg1_183)
				return arg0_183
			end,
			function(arg0_184, arg1_184, arg2_184, arg3_184)
				return arg0_184
			end,
			function(arg0_185)
				return 0
			end
		}, function(arg0_186)
			return var2_179(arg0_186) == "number" and arg0_186 or 0
		end, unpack(var1_179, 2))

		table.insert(arg1_177.readyIKLayers, var0_179)

		arg1_177.ikActionDict[var0_179:GetControllerPath()] = var1_179

		local var4_179 = var0_179:GetSubTargets()
		local var5_179 = var0_179:GetPlaneRotations()
		local var6_179 = var0_179:GetPlaneScales()
		local var7_179 = _.map(_.range(#var4_179), function(arg0_187)
			return {
				name = var4_179[arg0_187][1],
				planeRot = var5_179[arg0_187],
				planeScale = var6_179[arg0_187]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_179:getConfig("trigger_param")[2],
			controllerName = var0_179:GetControllerPath(),
			subTargets = var7_179,
			actionType = var0_179:GetActionTriggerParams()[1],
			controlRect = var0_179:GetRect(),
			actionRect = var0_179:GetTriggerRect(),
			backTime = var0_179:GetRevertTime(),
			actionRevertTime = var3_179
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_177.ladyIKRoot, arg1_177.ladyBoneMaps)
	arg0_177:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var0_177)

	local var1_177 = _.map(arg2_177.touch_data, function(arg0_188)
		return arg0_188[1]
	end)

	table.Foreach(var1_177, function(arg0_189, arg1_189)
		local var0_189 = pg.dorm3d_ik_touch[arg1_189]

		if #var0_189.scene_item == 0 then
			return
		end

		local var1_189 = arg0_177:GetSceneItem(var0_189.scene_item)

		if not var1_189 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_189, var0_189.scene_item))

			return
		end

		if IsNil(GetComponent(var1_189, typeof(UnityEngine.Collider))) then
			go(var1_189):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_189 = GetOrAddComponent(var1_189, typeof(EventTriggerListener))

		var2_189.enabled = true

		var2_189:AddPointClickFunc(function()
			arg0_177.blockIK = true

			local var0_190 = arg2_177.touch_data[arg0_189]
			local var1_190, var2_190, var3_190 = unpack(var0_190)

			arg0_177:TouchModePointAction(arg1_177, var1_190, unpack(var3_190))(function()
				arg0_177.enableIKTip = true

				arg0_177:ResetIKTipTimer()

				arg0_177.blockIK = nil
			end)
		end)
	end)

	arg0_177.camBrain.enabled = false

	if arg0_177.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_177.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_177.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var2_177 = arg0_177.cameraRoot:Find(arg2_177.ik_camera)

	assert(var2_177, "Missing IKCamera")

	arg0_177.cameras[var0_0.CAMERA.IK_WATCH] = var2_177

	arg0_177:ActiveCamera(arg0_177.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_177.camBrain.enabled = true

	local var3_177 = var2_177:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var3_177 then
		arg0_177:RegisterOrbits(var3_177)
	else
		arg0_177:RevertCameraOrbit()
	end

	arg0_177:SwitchAnim(arg1_177, arg2_177.character_action)
	arg0_177:SettingHeadAimIK(arg1_177, arg2_177.head_track)
	arg0_177:EnableCloth(arg1_177, false)
	arg0_177:EnableCloth(arg1_177, arg2_177.use_cloth, arg2_177.cloth_colliders)
	;(function()
		local var0_192 = arg2_177.enter_scene_anim
		local var1_192 = {}

		if var0_192 and #var0_192 > 0 then
			table.Ipairs(var0_192, function(arg0_193, arg1_193)
				arg0_177:PlaySceneItemAnim(arg1_193[1], arg1_193[2])
				table.insert(var1_192, arg1_193[1])
			end)
		end

		arg0_177:ResetSceneItemAnimators(var1_192)
	end)()
	;(function()
		local var0_194 = arg2_177.enter_extra_item
		local var1_194 = {}

		if var0_194 and #var0_194 > 0 then
			table.Ipairs(var0_194, function(arg0_195, arg1_195)
				local var0_195 = arg1_195[3] and Vector3.New(unpack(arg1_195[3]))
				local var1_195 = arg1_195[4] and Quaternion.Euler(unpack(arg1_195[4]))

				arg0_177:LoadCharacterExtraItem(arg1_177, arg1_195[1], arg1_195[2], var0_195, var1_195)
				table.insert(var1_194, arg1_195[1])
			end)
		end

		arg0_177:ResetCharacterExtraItem(arg1_177, var1_194)
	end)()
	eachChild(arg0_177.ikTextTipsRoot, function(arg0_196)
		setActive(arg0_196, false)
	end)
	_.each(arg1_177.readyIKLayers, function(arg0_197)
		local var0_197 = arg0_197:getConfig("tip_text")

		if not var0_197 or #var0_197 == 0 then
			return
		end

		local var1_197 = arg0_177.ikTextTipsRoot:Find(var0_197)

		if not IsNil(var1_197) then
			setActive(var1_197, true)
		end
	end)
	onNextTick(function()
		local var0_198 = arg0_177.furnitures:Find(arg2_177.character_position)

		arg1_177.lady.position = var0_198:Find("StayPoint").position
		arg1_177.lady.rotation = var0_198:Find("StayPoint").rotation

		existCall(arg3_177)
	end)
end

function var0_0.ExitIKStatus(arg0_199, arg1_199, arg2_199, arg3_199)
	arg0_199.enableIKTip = false

	setActive(arg1_199.ladyCollider, true)
	_.each(arg1_199.ladyTouchColliders, function(arg0_200)
		setActive(arg0_200, false)
	end)

	arg0_199.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_199.ikActionDict = nil
	arg1_199.readyIKLayers = nil

	setActive(arg0_199.ikTipsRoot, false)
	setActive(arg0_199.ikClickTipsRoot, false)

	local var0_199 = _.map(arg2_199.touch_data or {}, function(arg0_201)
		return arg0_201[1]
	end)

	table.Foreach(var0_199, function(arg0_202, arg1_202)
		local var0_202 = pg.dorm3d_ik_touch[arg1_202]

		if #var0_202.scene_item == 0 then
			return
		end

		local var1_202 = arg0_199.modelRoot:Find(var0_202.scene_item)

		if not var1_202 then
			return
		end

		local var2_202 = GetOrAddComponent(var1_202, typeof(EventTriggerListener))

		var2_202:ClearEvents()

		var2_202.enabled = false
	end)
	arg0_199:RevertCameraOrbit()
	setActive(arg0_199.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_199.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_199:EnableCloth(arg1_199, false)
	arg0_199:ResetHeadAimIK(arg1_199)
	arg0_199:SwitchAnim(arg1_199, arg2_199.character_action)
	arg0_199:ResetSceneItemAnimators()
	arg0_199:ResetCharacterExtraItem(arg1_199)
	onNextTick(function()
		if arg2_199.character_position then
			arg1_199.ladyActiveZone = arg2_199.character_position
		else
			arg1_199.ladyActiveZone = arg1_199.ladyBaseZone
		end

		arg0_199:ChangeCharacterPosition(arg1_199)
		arg0_199:TriggerLadyDistance()
		arg0_199:CheckInSector()
		existCall(arg3_199)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_204, arg1_204, arg2_204, arg3_204, arg4_204, arg5_204)
	warning("Set IKStatus " .. (arg3_204 or "NIL"))

	arg0_204.enableIKTip = true

	arg0_204:ResetIKTipTimer()

	arg0_204.blockIK = nil

	local var0_204 = pg.dorm3d_ik_timeline_status[arg3_204]

	arg1_204.readyIKLayers = {}
	arg1_204.IKSettings = {
		CameraRaycaster = arg4_204:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_204.IKSettings.CameraRaycaster)

	local var1_204 = {}

	table.IpairsCArray(arg2_204:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_205, arg1_205)
		if arg1_205:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_205)

		local var0_205 = child.name
		local var1_205 = var0_205 and string.find(var0_205, "Collider") or -1

		if var1_205 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_205)

			return
		end

		local var2_205 = string.sub(var0_205, 1, var1_205 - 1)

		if var2_205 == "Body" then
			setActive(child, false)

			return
		end

		if var0_0.BONE_TO_TOUCH[var2_205] == nil then
			return
		end

		var1_204[var2_205] = child

		setActive(child, true)
	end)

	arg1_204.IKSettings.Colliders = var1_204
	arg1_204.ikTimelineMode = true

	local var2_204 = _.map(var0_204.ik_id, function(arg0_206)
		local var0_206 = Dorm3dIK.New({
			configId = arg0_206
		})

		table.insert(arg1_204.readyIKLayers, var0_206)

		local var1_206 = var0_206:GetSubTargets()
		local var2_206 = var0_206:GetPlaneRotations()
		local var3_206 = var0_206:GetPlaneScales()
		local var4_206 = _.map(_.range(#var1_206), function(arg0_207)
			return {
				name = var1_206[arg0_207][1],
				planeRot = var2_206[arg0_207],
				planeScale = var3_206[arg0_207]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_206:getConfig("trigger_param")[2],
			controllerName = var0_206:GetControllerPath(),
			subTargets = var4_206,
			actionType = var0_206:GetActionTriggerParams()[1],
			controlRect = var0_206:GetRect(),
			actionRect = var0_206:GetTriggerRect(),
			backTime = var0_206:GetRevertTime(),
			actionRevertTime = var0_206:GetActionRevertTime(),
			timelineActionEvent = var0_206:GetTimelineAction()
		})
	end)
	local var3_204 = arg2_204.transform:Find("IKLayers")
	local var4_204 = {}
	local var5_204 = {}

	table.Foreach(var1_0, function(arg0_208, arg1_208)
		var5_204[arg1_208] = arg0_208
	end)

	local var6_204 = arg2_204.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var6_204, function(arg0_209, arg1_209)
		if var5_204[arg1_209.name] then
			var4_204[var5_204[arg1_209.name]] = arg1_209
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var3_204, var4_204)
	arg0_204:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_204)
	existCall(arg5_204)
end

function var0_0.ExitIKTimelineStatus(arg0_210, arg1_210, arg2_210)
	arg0_210.enableIKTip = false
	arg0_210.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_210.readyIKLayers = nil
	arg1_210.IKSettings = nil

	setActive(arg0_210.ikTipsRoot, false)
	setActive(arg0_210.ikClickTipsRoot, false)
	existCall(arg2_210)
end

function var0_0.EnableIKLayer(arg0_211, arg1_211)
	local var0_211 = arg0_211.ladyDict[arg0_211.apartment:GetConfigID()]

	if #arg1_211:GetHeadTrackPath() > 0 then
		arg0_211:SettingHeadAimIK(var0_211, {
			2,
			arg1_211:GetHeadTrackPath()
		}, true)
	end

	local var1_211 = arg1_211:GetTriggerFaceAnim()

	if #var1_211 > 0 then
		arg0_211:PlayFaceAnim(var0_211, var1_211)
	end

	setActive(arg0_211:GetIKHandTF(), true)
	eachChild(arg0_211:GetIKHandTF(), function(arg0_212)
		setActive(arg0_212, false)
	end)
	arg0_211:StopIKHandTimer()
	setActive(arg0_211:GetIKHandTF():Find("Begin"), true)

	arg0_211.ikHandTimer = Timer.New(function()
		setActive(arg0_211:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_211:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg0_211.ikHandTimer:Start()

	if not var0_211.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_211.apartment.configId, arg0_211.apartment.level, var0_211.ikConfig.character_action, arg1_211:GetTriggerParams()[2], arg0_211.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_214, arg1_214)
	local var0_214 = arg0_214.ladyDict[arg0_214.apartment:GetConfigID()]

	if not var0_214.ikTimelineMode and #arg1_214:GetHeadTrackPath() > 0 then
		arg0_214:SettingHeadAimIK(var0_214, var0_214.ikConfig.head_track)
	end

	arg0_214:StopIKHandTimer()
	setActive(arg0_214:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_214:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_214:GetIKHandTF():Find("End"), true)

	arg0_214.ikHandTimer = Timer.New(function()
		setActive(arg0_214:GetIKHandTF():Find("End"), false)
		setActive(arg0_214:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_214.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_216)
	if not arg0_216.ikHandTimer then
		return
	end

	arg0_216.ikHandTimer:Stop()

	arg0_216.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_217, arg1_217, arg2_217, arg3_217)
	local var0_217 = Time.time

	function arg0_217.ikRevertHandler()
		local var0_218 = Time.time - var0_217

		_.each(arg1_217.activeIKLayers, function(arg0_219)
			local var0_219 = 1

			if arg2_217 > 0 then
				var0_219 = var0_218 / arg2_217
			end

			local var1_219 = arg1_217.cacheIKInfos[arg0_219].solvers
			local var2_219 = arg1_217.cacheIKInfos[arg0_219].weights

			table.Foreach(var1_219, function(arg0_220, arg1_220)
				arg1_220.IKPositionWeight = math.lerp(var2_219[arg0_220], 0, var0_219)
			end)
		end)

		if var0_218 >= arg2_217 then
			arg0_217:ResetActiveIKs(arg1_217)

			arg0_217.ikRevertHandler = nil

			existCall(arg3_217)
		end
	end

	arg0_217.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_221, arg1_221)
	table.insertto(arg0_221.activeIKLayers, _.keys(arg0_221.holdingStatus))
	table.clear(arg0_221.holdingStatus)
	_.each(arg1_221.activeIKLayers, function(arg0_222)
		local var0_222 = arg0_222:GetControllerPath()
		local var1_222 = arg1_221.ladyIKRoot:Find(var0_222):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_222, false)

		local var2_222 = arg1_221.cacheIKInfos[arg0_222].solvers
		local var3_222 = arg1_221.cacheIKInfos[arg0_222].weights

		table.Foreach(var2_222, function(arg0_223, arg1_223)
			arg1_223.IKPositionWeight = var3_222[arg0_223]
		end)
	end)
	table.clear(arg1_221.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_224)
	if not arg0_224.enableIKTip then
		return
	end

	arg0_224.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_225, arg1_225)
	local var0_225 = arg0_225.ladyDict[arg0_225.apartment:GetConfigID()]

	arg0_225:EnableHeadIK(var0_225, arg1_225)
end

function var0_0.EnableHeadIK(arg0_226, arg1_226, arg2_226)
	arg1_226.ladyHeadIKComp.enableIk = arg2_226
end

function var0_0.SettingHeadAimIK(arg0_227, arg1_227, arg2_227, arg3_227)
	local var0_227

	if arg2_227[1] == 1 then
		var0_227 = arg0_227.mainCameraTF:Find("AimTarget")
	elseif arg2_227[1] == 2 then
		table.IpairsCArray(arg1_227.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_228, arg1_228)
			if arg1_228.name ~= arg2_227[2] then
				return
			end

			var0_227 = arg1_228
		end)
	end

	arg1_227.ladyHeadIKComp.AimTarget = var0_227

	if not arg3_227 and arg2_227[3] then
		arg1_227.ladyHeadIKComp.BodyWeight = arg2_227[3]
	end

	if not arg3_227 and arg2_227[4] then
		arg1_227.ladyHeadIKComp.HeadWeight = arg2_227[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_229, arg1_229)
	arg1_229.ladyHeadIKComp.AimTarget = arg0_229.mainCameraTF:Find("AimTarget")
	arg1_229.ladyHeadIKComp.HeadWeight = arg1_229.ladyHeadIKData.HeadWeight
	arg1_229.ladyHeadIKComp.BodyWeight = arg1_229.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_230, arg1_230)
	for iter0_230, iter1_230 in pairs(arg0_230.ladyDict) do
		if iter0_230 ~= arg1_230 then
			arg0_230:HideCharacterBylayer(iter1_230)
		end
	end
end

function var0_0.RevertCharacter(arg0_231, arg1_231)
	for iter0_231, iter1_231 in pairs(arg0_231.ladyDict) do
		if iter0_231 ~= arg1_231 then
			arg0_231:RevertCharacterBylayer(iter1_231)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_232, arg1_232)
	local var0_232 = "Bip001"
	local var1_232 = arg1_232.lady:Find("all")

	for iter0_232 = 0, var1_232.childCount - 1 do
		local var2_232 = var1_232:GetChild(iter0_232)

		if var2_232.name ~= var0_232 then
			pg.ViewUtils.SetLayer(var2_232, Layer.Environment3D)
		end
	end

	if arg1_232.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_232.tfPendintItem, Layer.Environment3D)
	end

	if arg1_232.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_232.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg1_232.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_233, arg1_233)
	local var0_233 = "Bip001"
	local var1_233 = arg1_233.lady:Find("all")

	for iter0_233 = 0, var1_233.childCount - 1 do
		local var2_233 = var1_233:GetChild(iter0_233)

		if var2_233.name ~= var0_233 then
			pg.ViewUtils.SetLayer(var2_233, Layer.Default)
		end
	end

	if arg1_233.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_233.tfPendintItem, Layer.Default)
	end

	if arg1_233.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_233.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg1_233.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_234)
	arg0_234:SetAllBlackbloardValue("inLockLayer", true)
	arg0_234:EnableJoystick(true)
	arg0_234:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_235, arg1_235)
	arg0_235:HideFurnitureSlots()

	local var0_235 = arg0_235.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_236)
			arg0_235.furniturePOV = nil

			arg0_235:EnableJoystick(false)
			arg0_235:emit(var0_0.SHOW_BLOCK)
			arg0_235:ShowBlackScreen(true, arg0_236)
		end,
		function(arg0_237)
			existCall(arg1_235)
			arg0_235:RevertCharacter()
			arg0_235:SetAllBlackbloardValue("inLockLayer", false)
			arg0_235:RegisterCameraBlendFinished(var0_235, arg0_237)
			arg0_235:ActiveCamera(var0_235)
		end,
		function(arg0_238)
			arg0_235:ShowBlackScreen(false, arg0_238)
		end
	}, function()
		arg0_235:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_235:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_240, arg1_240)
	local var0_240 = arg0_240:GetFurnitureByName(arg1_240:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_240.cameraFurnitureWatch and arg0_240.cameraFurnitureWatch ~= var0_240 then
		arg0_240:UnRegisterCameraBlendFinished(arg0_240.cameraFurnitureWatch)
		setActive(arg0_240.cameraFurnitureWatch, false)
	end

	arg0_240.cameraFurnitureWatch = var0_240
	arg0_240.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_240.cameraFurnitureWatch
	arg0_240.furniturePOV = arg0_240.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_240:RegisterCameraBlendFinished(arg0_240.cameraFurnitureWatch, function()
		arg0_240:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_240:emit(var0_0.SHOW_BLOCK)
	arg0_240:ActiveCamera(arg0_240.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_242)
	if arg0_242.displaySlots then
		arg0_242:UpdateDisplaySlots({})
		table.Foreach(arg0_242.displaySlots, function(arg0_243, arg1_243)
			local var0_243 = arg1_243.trans

			if IsNil(var0_243:Find("Selector")) then
				return
			end

			setActive(var0_243:Find("Selector"), false)
		end)

		arg0_242.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_244, arg1_244)
	arg0_244:HideFurnitureSlots()

	arg0_244.displaySlots = {}

	_.each(arg1_244, function(arg0_245)
		arg0_244.displaySlots[arg0_245] = arg0_244.slotDict[arg0_245]

		if not arg0_244.displaySlots[arg0_245] then
			errorMsg("Slot " .. arg0_245 .. " Not Binding Scene Object")

			return
		end

		local var0_245 = arg0_244.displaySlots[arg0_245].trans

		if var0_245:Find("Selector") then
			setActive(var0_245:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_246, arg1_246)
	table.Foreach(arg0_246.displaySlots, function(arg0_247, arg1_247)
		local var0_247 = arg1_247.trans

		if not IsNil(var0_247:Find("Selector")) then
			setActive(var0_247:Find("Selector/Normal"), arg1_246[arg0_247] == 0)
			setActive(var0_247:Find("Selector/Active"), arg1_246[arg0_247] == 1)
			setActive(var0_247:Find("Selector/Ban"), arg1_246[arg0_247] == 2)
		end

		local var1_247 = arg0_246.slotDict[arg0_247].model
		local var2_247 = arg0_246.slotDict[arg0_247].displayModelName

		if var2_247 and var2_247 ~= "" then
			var1_247 = var0_247:GetChild(var0_247.childCount - 1)
		end

		local function var3_247(arg0_248, arg1_248)
			local var0_248 = arg0_248:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_248, function(arg0_249, arg1_249)
				local var0_249 = arg1_249.material

				if var0_249 and var0_249:HasProperty("_FinalTint") then
					var0_249:SetColor("_FinalTint", arg1_248)
				end
			end)
		end

		if var1_247 then
			if arg1_246[arg0_247] == 1 then
				var3_247(var1_247, Color.NewHex("3F83AE73"))
			else
				var3_247(var1_247, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_250, arg1_250, arg2_250)
	arg0_250:SetAllBlackbloardValue("inLockLayer", true)
	arg0_250:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_251)
			arg0_250:TempHideUI(true, arg0_251)
		end,
		function(arg0_252)
			arg0_250:ShowBlackScreen(true, arg0_252)
		end,
		function(arg0_253)
			local var0_253 = arg0_250.apartment:GetConfigID()
			local var1_253 = arg0_250.ladyDict[var0_253]

			arg0_250:SwitchAnim(var1_253, arg2_250)
			var1_253.ladyAnimator:Update(0)
			var1_253:ResetCharPoint(var1_253, arg1_250:GetWatchCameraName())
			arg0_250:SyncInterestTransform(var1_253)
			setActive(var1_253.ladySafeCollider, true)
			arg0_250:HideCharacter(var0_253)

			local var2_253 = arg0_250.cameras[var0_0.CAMERA.PHOTO]
			local var3_253 = var2_253.m_XAxis

			var3_253.Value = 180
			var2_253.m_XAxis = var3_253

			local var4_253 = var2_253.m_YAxis

			var4_253.Value = 0.7
			var2_253.m_YAxis = var4_253
			arg0_250.pinchValue = 1

			arg0_250:RegisterOrbits(arg0_250.cameras[var0_0.CAMERA.PHOTO])
			arg0_250:SetCameraObrits()
			arg0_250:RegisterCameraBlendFinished(var2_253, arg0_253)
			arg0_250:ActiveCamera(var2_253)
		end,
		function(arg0_254)
			arg0_250:ShowBlackScreen(false, arg0_254)
		end
	}, function()
		arg0_250:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_256)
	arg0_256:emit(var0_0.SHOW_BLOCK)
	arg0_256:EnableJoystick(false)
	seriesAsync({
		function(arg0_257)
			arg0_256:ShowBlackScreen(true, arg0_257)
		end,
		function(arg0_258)
			arg0_256:RevertCameraOrbit()

			local var0_258 = arg0_256.ladyDict[arg0_256.apartment:GetConfigID()]

			arg0_256:SwitchAnim(var0_258, var0_0.ANIM.IDLE)
			setActive(var0_258.ladySafeCollider, false)
			onNextTick(function()
				arg0_256:ChangeCharacterPosition(var0_258)
			end)

			if arg0_256.contextData.photoFreeMode then
				arg0_256:EnablePOVLayer(false)
				setActive(arg0_256.restrictedBox, false)

				arg0_256.contextData.photoFreeMode = nil
			end

			local var1_258 = arg0_256.cameras[var0_0.CAMERA.POV]

			arg0_256:RegisterCameraBlendFinished(var1_258, arg0_258)
			arg0_256:ActiveCamera(var1_258)
		end,
		function(arg0_260)
			arg0_256:RevertCharacter(arg0_256.apartment:GetConfigID())
			arg0_256:ShowBlackScreen(false, arg0_260)
		end
	}, function()
		arg0_256:RefreshSlots()
		arg0_256:SetAllBlackbloardValue("inLockLayer", false)
		arg0_256:emit(var0_0.HIDE_BLOCK)
		arg0_256:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_256:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_262, arg1_262, arg2_262, arg3_262)
	arg0_262:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_263)
			arg0_262:ShowBlackScreen(true, arg0_263)
		end,
		function(arg0_264)
			local var0_264 = arg0_262.ladyDict[arg0_262.apartment:GetConfigID()]

			arg0_262:SwitchAnim(var0_264, arg2_262)
			onNextTick(function()
				arg0_262:ResetCharPoint(var0_264, arg1_262:GetWatchCameraName())
				arg0_262:SyncInterestTransform(var0_264)

				if arg0_262.contextData.photoFreeMode then
					arg0_262.camBrain.enabled = false

					arg0_262:SwitchPhotoCamera()

					arg0_262.camBrain.enabled = true

					onDelayTick(function()
						arg0_262.camBrain.enabled = false

						arg0_262:SwitchPhotoCamera()

						arg0_262.camBrain.enabled = true
					end, 0.1)
				end

				arg0_264()
			end)
		end,
		function(arg0_267)
			arg0_262:ShowBlackScreen(false, arg0_267)
		end
	}, function()
		arg0_262:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_262)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_269)
	if not arg0_269.contextData.photoFreeMode then
		arg0_269:EnableJoystick(false)
		arg0_269:EnablePOVLayer(true)
		setActive(arg0_269.restrictedBox, true)

		local var0_269 = arg0_269.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_269.transform.position = arg0_269.mainCameraTF.position

		local var1_269 = arg0_269.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_269 = arg0_269.mainCameraTF.rotation:ToEulerAngles()
		local var3_269 = var1_269.m_HorizontalAxis

		var3_269.Value = var2_269.y
		var1_269.m_HorizontalAxis = var3_269

		local var4_269 = var1_269.m_VerticalAxis

		var4_269.Value = arg0_269:GetNearestAngle(var2_269.x, var4_269.m_MinValue, var4_269.m_MaxValue)
		var1_269.m_VerticalAxis = var4_269

		local var5_269 = math.InverseLerp(arg0_269.restrictedHeightRange[1], arg0_269.restrictedHeightRange[2], var0_269.position.y)

		arg0_269:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_269)
		arg0_269:ActiveCamera(arg0_269.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_269:EnableJoystick(true)
		arg0_269:EnablePOVLayer(false)
		setActive(arg0_269.restrictedBox, false)
		arg0_269:ActiveCamera(arg0_269.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_269.contextData.photoFreeMode = not arg0_269.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_270, arg1_270)
	local var0_270 = math.lerp(arg0_270.restrictedHeightRange[1], arg0_270.restrictedHeightRange[2], arg1_270)
	local var1_270 = arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_270:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_270 - var1_270.position.y, 0))
	onNextTick(function()
		local var0_271 = math.InverseLerp(arg0_270.restrictedHeightRange[1], arg0_270.restrictedHeightRange[2], var1_270.position.y)

		arg0_270:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_271)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_272)
	local var0_272 = arg0_272.cameras[var0_0.CAMERA.PHOTO]
	local var1_272 = var0_272.m_XAxis

	var1_272.Value = 180
	var0_272.m_XAxis = var1_272

	local var2_272 = var0_272.m_YAxis

	var2_272.Value = 0.7
	var0_272.m_YAxis = var2_272
end

function var0_0.ResetCurrentCharPoint(arg0_273, arg1_273)
	local var0_273 = arg0_273.ladyDict[arg0_273.apartment:GetConfigID()]

	arg0_273:ResetCharPoint(var0_273, arg1_273)
end

function var0_0.ResetCharPoint(arg0_274, arg1_274, arg2_274)
	local var0_274 = arg0_274.furnitures:Find(arg2_274 .. "/StayPoint")

	arg1_274.lady.position = var0_274.position
	arg1_274.lady.rotation = var0_274.rotation
end

function var0_0.GetNearestAngle(arg0_275, arg1_275, arg2_275, arg3_275)
	if arg3_275 < arg2_275 then
		arg3_275 = arg3_275 + 360
	end

	if arg2_275 <= arg1_275 and arg1_275 <= arg3_275 then
		return arg1_275
	end

	local var0_275 = (arg2_275 + arg3_275) / 2

	arg1_275 = var0_275 - Mathf.DeltaAngle(arg1_275, var0_275)
	arg1_275 = math.clamp(arg1_275, arg2_275, arg3_275)

	return arg1_275
end

function var0_0.PlayTimeline(arg0_276, arg1_276, arg2_276)
	local var0_276 = {}

	if arg0_276.waitForTimeline then
		table.insert(var0_276, function(arg0_277)
			local var0_277 = arg0_276.waitForTimeline

			arg0_276.waitForTimeline = nil

			var0_277()
			arg0_277()
		end)
	end

	table.insert(var0_276, function(arg0_278)
		arg0_276:LoadTimelineScene(arg1_276.name, false, nil, arg0_278)
	end)

	if arg1_276.scene and arg1_276.sceneRoot then
		table.insert(var0_276, function(arg0_279)
			arg0_276:ChangeArtScene(arg1_276.scene .. "|" .. arg1_276.sceneRoot, arg0_279)
		end)
	end

	table.insert(var0_276, function(arg0_280)
		local var0_280 = GameObject.Find("[actor]").transform
		local var1_280 = var0_280:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_280, function(arg0_281, arg1_281)
			GetOrAddComponent(arg1_281.transform, typeof(DftAniEvent))
		end)

		local var2_280 = var0_280:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_280 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera)).transform
		local var4_280 = GameObject.Find("[sequence]").transform

		arg0_276.nowTimelinePlayer = TimelinePlayer.New(var4_280)

		arg0_276.nowTimelinePlayer:Register(arg1_276.time, function(arg0_282, arg1_282, arg2_282)
			switch(arg1_282.stringParameter, {
				TimelinePause = function()
					arg0_282:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_282:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_282.intParameter == 0 or arg1_282.intParameter == arg2_282.selectIndex then
						arg0_282:SetTime(arg1_282.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_282.selectIndex = nil

					if arg1_276.options then
						local var0_286 = arg1_276.options[arg1_282.intParameter]

						arg0_276:DoTimelineOption(var0_286, function(arg0_287)
							arg2_282.selectIndex = arg0_287
							arg2_282.optionIndex = var0_286[arg0_287].flag

							arg0_282:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_282.selectIndex = nil

					if arg1_276.touchs then
						local var0_288 = arg1_276.touchs[arg1_282.intParameter]

						arg0_276:DoTimelineTouch(arg1_276.touchs[arg1_282.intParameter], function(arg0_289)
							arg2_282.selectIndex = arg0_289
							arg2_282.optionIndex = var0_288[arg0_289].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_282.selectIndex then
						arg0_282:RawSetTime(arg1_282.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_282.selectIndex = arg1_282.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_276.canTriggerAccompanyPerformance then
						arg0_276.canTriggerAccompanyPerformance = false

						local var0_292 = arg1_276.accompanys[arg1_282.intParameter]
						local var1_292 = var0_292[math.random(#var0_292)]

						arg0_282:SetTime(var1_292)
					end
				end,
				TimelineIKStart = function()
					local var0_293 = arg1_282.intParameter
					local var1_293 = arg0_276.ladyDict[arg0_276.apartment:GetConfigID()]

					arg0_276:SetIKTimelineStatus(var1_293, var2_280.gameObject, var0_293, var3_280)
				end,
				TimelineEnd = function()
					arg2_282.finish = true

					arg0_282:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_282.stringParameter)
			end)

			if arg2_282.finish then
				arg0_276.timelineMark = arg2_282
				arg0_276.timelineFinishCall = nil

				local var0_282 = arg0_276.ladyDict[arg0_276.apartment:GetConfigID()]

				if var0_282.ikTimelineMode then
					arg0_276:ExitIKTimelineStatus(var0_282)
				end

				arg0_280()
			end
		end)

		function arg0_276.timelineFinishCall()
			arg0_276.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_276:HideCharacter()
		setActive(arg0_276.mainCameraTF, false)
		eachChild(arg0_276.rtTimelineScreen, function(arg0_297)
			setActive(arg0_297, false)
		end)
		setActive(arg0_276.rtTimelineScreen, true)
		setActive(arg0_276.rtTimelineScreen:Find("btn_skip"), arg0_276.inReplayTalk)
		arg0_276.nowTimelinePlayer:Start()
	end)
	table.insert(var0_276, function(arg0_298)
		arg0_276:ShowBlackScreen(true, function()
			arg0_276.nowTimelinePlayer:Stop()
			arg0_276.nowTimelinePlayer:Dispose()

			arg0_276.nowTimelinePlayer = nil

			arg0_276:UnloadTimelineScene(arg1_276.name, false, arg0_298)
		end)
	end)

	local var1_276 = arg0_276.dormSceneMgr.artSceneInfo

	table.insert(var0_276, function(arg0_300)
		arg0_276:ChangeArtScene(var1_276, arg0_300)
	end)
	seriesAsync(var0_276, function()
		setActive(arg0_276.rtTimelineScreen, false)
		arg0_276:RevertCharacter()
		setActive(arg0_276.mainCameraTF, true)

		local var0_301 = arg0_276.timelineMark

		arg0_276.timelineMark = nil

		existCall(arg2_276, var0_301, function(arg0_302)
			arg0_276:ShowBlackScreen(false, arg0_302)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_303, ...)
	local var0_303 = arg0_303.ladyDict[arg0_303.apartment:GetConfigID()]

	return arg0_303:PlaySingleAction(var0_303, ...)
end

function var0_0.PlaySingleAction(arg0_304, arg1_304, arg2_304, arg3_304)
	local var0_304 = string.find(arg2_304, "^Face_")

	if tobool(var0_304) then
		arg0_304:PlayFaceAnim(arg1_304, arg2_304, arg3_304)

		return
	end

	if arg1_304.ladyAnimator:GetCurrentAnimatorStateInfo(arg1_304.ladyAnimBaseLayerIndex):IsName(arg2_304) then
		return
	end

	existCall(arg1_304.animExtraItemCallback)

	arg1_304.animExtraItemCallback = nil
	arg1_304.animNameMap = arg1_304.animNameMap or {}
	arg1_304.animNameMap[arg1_304.ladyAnimator.StringToHash(arg2_304)] = arg2_304

	local var1_304 = arg0_304:GetBlackboardValue(arg1_304, "groupId")
	local var2_304 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var1_304] or {}, function(arg0_305)
		return pg.dorm3d_anim_extraitem[arg0_305].anim == arg2_304
	end)
	local var3_304 = var2_304 and pg.dorm3d_anim_extraitem[var2_304]
	local var4_304

	seriesAsync({
		function(arg0_306)
			if not var3_304 or var3_304.item_prefab == "" then
				arg0_306()

				return
			end

			local var0_306 = string.lower("dorm3d/furniture/item/" .. var3_304.item_prefab)

			arg0_304.loader:GetPrefab(var0_306, "", function(arg0_307)
				setParent(arg0_307, arg1_304.lady)

				if var3_304.item_shield ~= "" then
					var4_304 = {}

					for iter0_307, iter1_307 in ipairs(var3_304.item_shield) do
						local var0_307 = arg0_304.modelRoot:Find(iter1_307)

						if not var0_307 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var3_304.id, iter1_307))
						else
							var4_304[iter1_307] = isActive(var0_307)

							setActive(var0_307, false)
						end
					end
				end

				function arg1_304.animExtraItemCallback()
					arg0_304.loader:ClearRequest("AnimExtraItem")

					if var4_304 then
						for iter0_308, iter1_308 in pairs(var4_304) do
							setActive(arg0_304.modelRoot:Find(iter0_308), iter1_308)
						end
					end
				end

				arg0_306()
			end, "AnimExtraItem")
		end,
		function(arg0_309)
			arg1_304.nowState = arg2_304
			arg1_304.stateCallback = arg0_309

			arg1_304.ladyAnimator:CrossFadeInFixedTime(arg2_304, 0.25, arg1_304.ladyAnimBaseLayerIndex)
		end,
		function(arg0_310)
			arg1_304.nowState = nil
			arg1_304.stateCallback = nil

			existCall(arg1_304.animExtraItemCallback)

			arg1_304.animExtraItemCallback = nil

			arg0_310()
		end,
		arg3_304
	})
end

function var0_0.SwitchCurrentAnim(arg0_311, ...)
	local var0_311 = arg0_311.ladyDict[arg0_311.apartment:GetConfigID()]

	return arg0_311:SwitchAnim(var0_311, ...)
end

function var0_0.SwitchAnim(arg0_312, arg1_312, arg2_312, arg3_312)
	local var0_312 = string.find(arg2_312, "^Face_")

	if tobool(var0_312) then
		arg0_312:PlayFaceAnim(arg1_312, arg2_312, arg3_312)

		return
	end

	existCall(arg1_312.animExtraItemCallback)

	arg1_312.animExtraItemCallback = nil
	arg1_312.animNameMap = arg1_312.animNameMap or {}
	arg1_312.animNameMap[arg1_312.ladyAnimator.StringToHash(arg2_312)] = arg2_312

	local var1_312 = {}

	table.insert(var1_312, function(arg0_313)
		arg1_312.nowState = arg2_312
		arg1_312.stateCallback = arg0_313

		arg1_312.ladyAnimator:PlayInFixedTime(arg2_312, arg1_312.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_312, function(arg0_314)
		arg1_312.nowState = nil
		arg1_312.stateCallback = nil

		arg0_314()
	end)
	seriesAsync(var1_312, arg3_312)
end

function var0_0.PlayFaceAnim(arg0_315, arg1_315, arg2_315, arg3_315)
	arg1_315.ladyAnimator:CrossFadeInFixedTime(arg2_315, 0.2, arg1_315.ladyAnimFaceLayerIndex)
	existCall(arg3_315)
end

function var0_0.GetCurrentAnim(arg0_316)
	local var0_316 = arg0_316.ladyDict[arg0_316.apartment:GetConfigID()]
	local var1_316 = var0_316.ladyAnimator:GetCurrentAnimatorStateInfo(var0_316.ladyAnimBaseLayerIndex).shortNameHash

	return var0_316.animNameMap[var1_316]
end

function var0_0.RegisterAnimCallback(arg0_317, arg1_317, arg2_317)
	arg0_317.ladyDict[arg0_317.apartment:GetConfigID()].animCallbacks[arg1_317] = arg2_317
end

function var0_0.SetCharacterAnimSpeed(arg0_318, arg1_318)
	local var0_318 = arg0_318.ladyDict[arg0_318.apartment:GetConfigID()]

	var0_318.ladyAnimator.speed = arg1_318
	var0_318.ladyHeadIKComp.blinkSpeed = var0_318.ladyHeadIKData.blinkSpeed * arg1_318

	if arg1_318 > 0 then
		var0_318.ladyHeadIKComp.DampTime = var0_318.ladyHeadIKData.DampTime / arg1_318
	else
		var0_318.ladyHeadIKComp.DampTime = var0_318.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_319, arg1_319)
	if arg1_319.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_319 = arg1_319.stringParameter
	local var1_319 = table.removebykey(arg0_319.animEventCallbacks, var0_319)

	existCall(var1_319)
end

function var0_0.RegisterAnimEventCallback(arg0_320, arg1_320, arg2_320)
	arg0_320.animEventCallbacks[arg1_320] = arg2_320
end

function var0_0.PlaySceneItemAnim(arg0_321, arg1_321, arg2_321)
	arg0_321.sceneAnimatorDict = arg0_321.sceneAnimatorDict or {}

	if not arg0_321.sceneAnimatorDict[arg1_321] then
		local var0_321 = pg.dorm3d_scene_animator[arg1_321]
		local var1_321 = arg0_321:GetSceneItem(var0_321.item_name)

		assert(var1_321, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_321 .. " " .. var0_321.item_name)

		if not var1_321 then
			return
		end

		local var2_321 = var1_321:GetComponent(typeof(Animator))

		if not var2_321 then
			return
		end

		arg0_321.sceneAnimatorDict[arg1_321] = {
			trans = var1_321,
			animator = var2_321
		}
	end

	if arg0_321.sceneAnimatorDict[arg1_321].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_321) then
		return
	end

	arg0_321.sceneAnimatorDict[arg1_321].animator:PlayInFixedTime(arg2_321)
end

function var0_0.ResetSceneItemAnimators(arg0_322, arg1_322)
	if not arg0_322.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_322.sceneAnimatorDict, function(arg0_323, arg1_323)
		if arg1_322 and table.contains(arg1_322, arg0_323) then
			return
		end

		setActive(arg1_323.trans, false)
		setActive(arg1_323.trans, true)

		arg0_322.sceneAnimatorDict[arg0_323] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_324, arg1_324, arg2_324, arg3_324, arg4_324, arg5_324)
	arg1_324.extraItems = arg1_324.extraItems or {}

	if arg1_324.extraItems[arg2_324] then
		return
	end

	local var0_324

	if arg3_324 == "" then
		var0_324 = arg1_324.lady
	else
		table.IpairsCArray(arg1_324.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_325, arg1_325)
			if arg1_325.name == arg3_324 then
				var0_324 = arg1_325
			end
		end)
	end

	if not var0_324 then
		return
	end

	arg0_324.loader:GetPrefab(string.lower("dorm3d/" .. arg2_324), "", function(arg0_326)
		setParent(arg0_326, var0_324)

		if arg4_324 then
			setLocalPosition(arg0_326, arg4_324)
		end

		if arg5_324 then
			setLocalRotation(arg0_326, arg5_324)
		end

		arg1_324.extraItems[arg2_324] = {
			trans = arg0_326.transform,
			handler = var0_324
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_327, arg1_327, arg2_327)
	if not arg1_327.extraItems then
		return
	end

	table.Foreach(arg1_327.extraItems, function(arg0_328, arg1_328)
		if arg2_327 and table.contains(arg2_327, arg0_328) then
			return
		end

		arg0_327.loader:ReturnPrefab(arg1_328.trans.gameObject)

		arg1_327.extraItems[arg0_328] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_329, arg1_329, arg2_329)
	arg0_329.cameraBlendCallbacks[arg1_329] = arg2_329
end

function var0_0.UnRegisterCameraBlendFinished(arg0_330, arg1_330)
	arg0_330.cameraBlendCallbacks[arg1_330] = nil
end

function var0_0.OnCameraBlendFinished(arg0_331, arg1_331)
	if not arg1_331 then
		return
	end

	local var0_331 = table.removebykey(arg0_331.cameraBlendCallbacks, arg1_331)

	existCall(var0_331)
end

function var0_0.PlayHeartFX(arg0_332, arg1_332)
	local var0_332 = arg0_332.ladyDict[arg1_332]

	setActive(var0_332.effectHeart, false)
	setActive(var0_332.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_333, arg1_333)
	local var0_333 = arg1_333.name
	local var1_333 = arg0_333.expressionDict[var0_333]
	local var2_333 = 5

	if var1_333 then
		local var3_333 = var1_333.timer

		var3_333:Reset(nil, var2_333)
		var3_333:Start()

		if var1_333.instance then
			setActive(var1_333.instance, false)
			setActive(var1_333.instance, true)
		end

		return
	end

	local var4_333 = {
		name = var0_333,
		timer = Timer.New(function()
			arg0_333:RemoveExpression(var0_333)
		end, var2_333, 1, true)
	}

	arg0_333.expressionDict[var0_333] = var4_333

	arg0_333.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_333, var0_333, function(arg0_335)
		var4_333.instance = arg0_335

		onNextTick(function()
			local var0_336 = arg0_333.ladyDict[arg0_333.apartment:GetConfigID()]

			setParent(arg0_335, var0_336.ladyHeadCenter)
		end)
		setLocalPosition(arg0_335, Vector3(0, 0, -0.2))
		setActive(arg0_335, false)
		setActive(arg0_335, true)
	end, var4_333)
end

function var0_0.RemoveExpression(arg0_337, arg1_337)
	local var0_337 = arg0_337.expressionDict[arg1_337]

	if not var0_337 then
		return
	end

	arg0_337.loader:ClearRequest(var0_337)

	if var0_337.instance then
		arg0_337.loader:ReturnPrefab(var0_337.instance)
	end

	arg0_337.expressionDict[arg1_337] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_338, arg1_338, arg2_338)
	arg1_338.ladyWatchFloat = arg1_338.ladyWatchFloat or cloneTplTo(arg0_338.resTF:Find("vfx_talk_mark"), arg1_338.ladyHeadCenter)

	setActive(arg1_338.ladyWatchFloat, arg2_338)
end

function var0_0.RegisterGlobalVolume(arg0_339)
	local var0_339 = arg0_339.globalVolume
	local var1_339 = LuaHelper.GetOrAddVolumeComponent(var0_339, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_339 = LuaHelper.GetOrAddVolumeComponent(var0_339, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_339.originalCameraSettings = {
		depthOfField = {
			enabled = var1_339.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_339.gaussianStart.min,
				value = var1_339.gaussianStart.value
			},
			blurRadius = {
				min = var1_339.blurRadius.min,
				max = var1_339.blurRadius.max,
				value = var1_339.blurRadius.value
			}
		},
		postExposure = {
			value = var2_339.postExposure.value
		},
		contrast = {
			min = var2_339.contrast.min,
			max = var2_339.contrast.max,
			value = var2_339.contrast.value
		},
		saturate = {
			min = var2_339.saturation.min,
			max = var2_339.saturation.max,
			value = var2_339.saturation.value
		}
	}
	arg0_339.originalCameraSettings.depthOfField.enabled = true

	local var3_339 = var0_339:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_339.originalVolume = {
		profile = var3_339.sharedProfile,
		weight = var3_339.weight
	}
end

function var0_0.SettingCamera(arg0_340, arg1_340)
	arg0_340.activeCameraSettings = arg1_340

	local var0_340 = arg0_340.globalVolume
	local var1_340 = LuaHelper.GetOrAddVolumeComponent(var0_340, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_340 = LuaHelper.GetOrAddVolumeComponent(var0_340, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_340.enabled:Override(arg1_340.depthOfField.enabled)
	var1_340.gaussianStart:Override(arg1_340.depthOfField.focusDistance.value)
	var1_340.gaussianEnd:Override(arg1_340.depthOfField.focusDistance.value + arg1_340.depthOfField.focusDistance.length)
	var1_340.blurRadius:Override(arg1_340.depthOfField.blurRadius.value)
	var2_340.postExposure:Override(arg1_340.postExposure.value)
	var2_340.contrast:Override(arg1_340.contrast.value)
	var2_340.saturation:Override(arg1_340.saturate.value)
end

function var0_0.GetCameraSettings(arg0_341)
	return arg0_341.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_342)
	arg0_342:SettingCamera(arg0_342.originalCameraSettings)

	arg0_342.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_343, arg1_343, arg2_343)
	local var0_343 = arg0_343.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_343.activeProfileWeight = arg2_343

	if arg0_343.activeProfileName ~= arg1_343 then
		arg0_343.activeProfileName = arg1_343

		arg0_343.loader:LoadReference("dorm3d/scenesres/res/common", arg1_343, nil, function(arg0_344)
			var0_343.profile = arg0_344
			var0_343.weight = arg0_343.activeProfileWeight

			if arg0_343.activeCameraSettings then
				arg0_343:SettingCamera(arg0_343.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_343.weight = arg0_343.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_345)
	local var0_345 = arg0_345.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_345.profile = arg0_345.originalVolume.profile
	var0_345.weight = arg0_345.originalVolume.weight

	if arg0_345.activeCameraSettings then
		arg0_345:SettingCamera(arg0_345.activeCameraSettings)
	end

	arg0_345.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_346)
	local var0_346 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_346.originalCharacterColor = {
		color = var0_346.color,
		intensity = var0_346.intensity
	}
end

function var0_0.SetCharacterLight(arg0_347, arg1_347, arg2_347, arg3_347)
	local var0_347 = arg0_347.characterLight:GetComponent(typeof(Light))
	local var1_347 = Color.Lerp(arg0_347.originalCharacterColor.color, arg1_347, arg3_347)
	local var2_347 = math.lerp(arg0_347.originalCharacterColor.intensity, arg2_347, arg3_347)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_347, var2_347)
end

function var0_0.RevertCharacterLight(arg0_348)
	arg0_348:SetCharacterLight(arg0_348.originalCharacterColor.color, arg0_348.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_349, arg1_349, arg2_349, arg3_349)
	arg2_349 = arg2_349 or {}

	table.Foreach(arg1_349.clothComps, function(arg0_350, arg1_350)
		if arg1_350 == nil then
			return
		end

		setActive(arg1_350, arg2_349[arg0_350] == 1)
	end)
	table.Foreach(arg1_349.clothColliderDict, function(arg0_351, arg1_351)
		if arg1_351 == nil then
			return
		end

		setActive(arg1_351, false)
	end)

	if arg3_349 then
		table.Foreach(arg3_349, function(arg0_352, arg1_352)
			local var0_352 = arg1_349.clothColliderDict[arg1_352[1]]

			if var0_352 == nil then
				return
			end

			setActive(var0_352, arg1_352[2] == 1)

			if arg1_352[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_352, arg1_352[3], arg1_352[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_353, arg1_353)
	table.Foreach(arg1_353.ladyClothCompSettings, function(arg0_354, arg1_354)
		arg0_354.enabled = arg1_354.enabled
	end)
	table.Foreach(arg1_353.ladyClothColliderSettings, function(arg0_355, arg1_355)
		arg0_355.enabled = arg1_355.enabled

		var0_0.SetMagicaCollider(arg0_355, arg1_355.StartRadius, arg1_355.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_356)
	if arg0_356.exited or arg0_356.retainCount > 0 then
		-- block empty
	else
		arg0_356:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_357, arg1_357, arg2_357, arg3_357, arg4_357)
	arg0_357.dormSceneMgr:LoadTimelineScene({
		name = string.lower(arg1_357),
		assetRootName = arg0_357.apartment:getConfig("asset_name"),
		isCache = arg2_357,
		waitForTimeline = arg3_357,
		callName = arg0_357.apartment:GetCallName(),
		loadSceneFunc = function(arg0_358, arg1_358)
			local var0_358 = GameObject.Find("[actor]").transform

			arg0_357:HXCharacter(tf(var0_358))
		end
	}, arg4_357)
end

function var0_0.UnloadTimelineScene(arg0_359, arg1_359, arg2_359, arg3_359)
	arg0_359.dormSceneMgr:UnloadTimelineScene(string.lower(arg1_359), arg2_359, arg3_359)
end

function var0_0.ChangeArtScene(arg0_360, arg1_360, arg2_360)
	arg1_360 = string.lower(arg1_360)

	warning(arg0_360.dormSceneMgr.artSceneInfo, "->", arg1_360, arg1_360 == arg0_360.dormSceneMgr.sceneInfo)

	local var0_360 = {}

	table.insert(var0_360, function(arg0_361)
		arg0_360.dormSceneMgr:ChangeArtScene(string.lower(arg1_360), arg0_361)
	end)

	if arg1_360 == arg0_360.dormSceneMgr.sceneInfo or arg0_360.dormSceneMgr.artSceneInfo == arg0_360.dormSceneMgr.sceneInfo then
		table.insert(var0_360, function(arg0_362)
			setActive(arg0_360.slotRoot, arg1_360 == arg0_360.dormSceneMgr.sceneInfo)
			arg0_362()
		end)
	end

	if arg1_360 == arg0_360.dormSceneMgr.sceneInfo then
		table.insert(var0_360, function(arg0_363)
			arg0_360:SwitchDayNight(arg0_360.contextData.timeIndex)
			onNextTick(function()
				arg0_360:RefreshSlots()
				arg0_363()
			end)
		end)
	end

	seriesAsync(var0_360, arg2_360)
end

function var0_0.ChangeSubScene(arg0_365, arg1_365, arg2_365)
	arg1_365 = string.lower(arg1_365)

	warning(arg0_365.dormSceneMgr.subSceneInfo, "->", arg1_365, arg1_365 == arg0_365.dormSceneMgr.subSceneInfo)

	local var0_365 = {}

	table.insert(var0_365, function(arg0_366)
		arg0_365.dormSceneMgr:ChangeSubScene(arg1_365, arg0_366)
	end)

	local var1_365 = arg0_365.ladyDict[arg0_365.apartment:GetConfigID()]

	table.insert(var0_365, function(arg0_367)
		if arg1_365 == arg0_365.dormSceneMgr.sceneInfo then
			var1_365.ladyActiveZone = var1_365.walkBornPoint or var1_365.ladyBaseZone
		else
			var1_365.ladyActiveZone = var1_365.walkBornPoint or "Default"
		end

		arg0_367()
	end)

	if arg1_365 ~= arg0_365.dormSceneMgr.subSceneInfo then
		table.insert(var0_365, function(arg0_368)
			local var0_368, var1_368 = Dorm3dSceneMgr.ParseInfo(arg1_365)
			local var2_368 = var0_368 .. "_base"

			arg0_365:ResetSceneStructure(SceneManager.GetSceneByName(var2_368))

			if arg1_365 == arg0_365.dormSceneMgr.sceneInfo then
				arg0_365:RefreshSlots()
			else
				arg0_365:SwitchAnim(var1_365, var0_0.ANIM.IDLE)
			end

			if arg0_365.dormSceneMgr.subSceneInfo == arg0_365.dormSceneMgr.sceneInfo then
				local var3_368 = Clone(arg0_365.room)

				var3_368.furnitures = {}

				arg0_365:RefreshSlots(var3_368)
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
	local var0_371 = arg1_371 - Vector3.New(unpack(arg0_371.Position))

	if var0_371.magnitude > arg0_371.Radius then
		return false
	end

	local var1_371 = Quaternion.Euler(unpack(arg0_371.Rotation))

	return Vector3.Angle(var1_371 * Vector3.forward, var0_371) <= arg0_371.Angle / 2
end

function var0_0.willExit(arg0_372)
	arg0_372.joystickTimer:Stop()
	arg0_372.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_372.updateHandler)
	arg0_372:StopIKHandTimer()

	if arg0_372.moveTimer then
		arg0_372.moveTimer:Stop()

		arg0_372.moveTimer = nil
	end

	if arg0_372.moveWaitTimer then
		arg0_372.moveWaitTimer:Stop()

		arg0_372.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_372.furnitures) then
		eachChild(arg0_372.furnitures, function(arg0_373)
			local var0_373 = GetComponent(arg0_373, typeof(EventTriggerListener))

			if not var0_373 then
				return
			end

			var0_373:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_372, iter1_372 in pairs(arg0_372.ladyDict) do
		GetComponent(iter1_372.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_372.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_372.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_372.blockLayer, arg0_372._tf)
	table.Foreach(arg0_372.expressionDict, function(arg0_374)
		arg0_372:RemoveExpression(arg0_374)
	end)
	arg0_372.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_372.dormSceneMgr:Dispose()

	arg0_372.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_375 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_375 = SystemInfo.deviceModel or ""

			local function var2_375(arg0_376)
				local var0_376 = string.match(arg0_376, "iPad(%d+)")
				local var1_376 = tonumber(var0_376)

				if var1_376 and var1_376 >= 8 then
					return true
				end

				return false
			end

			local function var3_375(arg0_377)
				local var0_377 = string.match(arg0_377, "iPhone(%d+)")
				local var1_377 = tonumber(var0_377)

				if var1_377 and var1_377 >= 13 then
					return true
				end

				return false
			end

			if var2_375(var1_375) or var3_375(var1_375) then
				var0_375 = DevicePerformanceLevel.High
			end
		end

		local var4_375 = var0_375 == DevicePerformanceLevel.High and 3 or var0_375 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_375)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_375
	end
end

function var0_0.SettingQuality()
	local var0_378 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_378)
end

function var0_0.SetMagicaCollider(arg0_379, arg1_379, arg2_379)
	local var0_379 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_379, "StartRadius", arg0_379, arg1_379)
	ReflectionHelp.RefSetProperty(var0_379, "EndRadius", arg0_379, arg2_379)
end

return var0_0
