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
	arg0_10.sceneInfo = string.lower(arg0_10.room:getConfig("scene_info"))
	arg0_10.artSceneInfo = arg0_10.sceneInfo
	arg0_10.subSceneInfo = arg0_10.sceneInfo

	local var1_10, var2_10 = unpack(string.split(arg0_10.sceneInfo, "|"))
	local var3_10 = {
		function(arg0_11)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var2_10 .. "/" .. var1_10 .. "_scene"), var1_10, LoadSceneMode.Additive, function(arg0_12, arg1_12)
				SceneManager.SetActiveScene(arg0_12)

				local var0_12 = getSceneRootTFDic(arg0_12).MainCamera

				if var0_12 then
					setActive(var0_12, false)
				end

				arg0_11()
			end)
		end,
		function(arg0_13)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var2_10 .. "/" .. var1_10 .. "_base_scene"), var1_10 .. "_base", LoadSceneMode.Additive, arg0_13)
		end
	}

	table.insert(var3_10, function(arg0_14)
		arg0_10:LoadCharacter(arg0_10.contextData.groupIds, arg0_14)
	end)
	seriesAsync(var3_10, arg1_10)
end

function var0_0.init(arg0_15)
	arg0_15:BindEvent()
	arg0_15:InitData()
	arg0_15:initScene()
	arg0_15:initNodeCanvas()

	for iter0_15, iter1_15 in pairs(arg0_15.ladyDict) do
		arg0_15:InitCharacter(iter1_15, iter0_15)

		iter1_15.ladyBaseZone = arg0_15.contextData.ladyZone[iter0_15]
		iter1_15.ladyActiveZone = iter1_15.ladyBaseZone

		arg0_15:ChangeCharacterPosition(iter1_15)
	end

	arg0_15.retainCount = 0
	arg0_15.sceneBlockLayer = arg0_15._tf:Find("SceneBlock")

	setActive(arg0_15.sceneBlockLayer, false)

	arg0_15.blockLayer = arg0_15._tf:Find("Block")

	setActive(arg0_15.blockLayer, false)

	arg0_15.blackLayer = arg0_15._tf:Find("BlackScreen")

	setActive(arg0_15.blackLayer, false)
	arg0_15:ChangePlayerPosition()

	arg0_15.cacheSceneDic = {}
	arg0_15.sceneGroupDic = {}
	arg0_15.lastSceneRootDict = {}

	pg.ClickEffectMgr:GetInstance():SetClickEffect("DORM3D")
end

function var0_0.BindEvent(arg0_16)
	arg0_16:bind(var0_0.PLAY_EXPRESSION, function(arg0_17, arg1_17)
		arg0_16:PlayExpression(arg1_17)
	end)
	arg0_16:bind(var0_0.SHOW_BLOCK, function()
		arg0_16.retainCount = arg0_16.retainCount + 1

		setActive(arg0_16.blockLayer, true)
	end)
	arg0_16:bind(var0_0.HIDE_BLOCK, function()
		arg0_16.retainCount = math.max(arg0_16.retainCount - 1, 0)

		if arg0_16.retainCount > 0 then
			return
		end

		setActive(arg0_16.blockLayer, false)
	end)
	arg0_16:bind(var0_0.ENABLE_SCENEBLOCK, function(arg0_20, arg1_20)
		setActive(arg0_16.sceneBlockLayer, arg1_20)
	end)
	arg0_16:bind(var0_0.ON_STICK_MOVE, function(arg0_21, arg1_21)
		arg0_16:OnStickMove(arg1_21)
	end)
	arg0_16:bind(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, function(arg0_22, arg1_22, arg2_22, arg3_22)
		if arg0_16.blockIK then
			return
		end

		if arg0_16.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():OnDragBegin(arg2_22, arg3_22)
	end)
	arg0_16:bind(var0_0.ON_DRAG_CHARACTER_BODY, function(arg0_23, arg1_23, arg2_23)
		if not arg0_16.ikHandler then
			return
		end

		pg.IKMgr.GetInstance():HandleBodyDrag(arg2_23)
	end)
	arg0_16:bind(var0_0.ON_RELEASE_CHARACTER_BODY, function(arg0_24, arg1_24)
		pg.IKMgr.GetInstance():ReleaseDrag()
	end)
	arg0_16:bind(var0_0.ON_POV_STICK_MOVE_BEGIN, function(arg0_25, arg1_25)
		if arg0_16.pinchMode then
			return
		end

		arg0_16.moveStickOrigin = arg1_25.position
		arg0_16.moveStickPosition = arg0_16.moveStickOrigin
		arg0_16.moveStickDraging = true
	end)

	local function var0_16()
		arg0_16.moveStickOrigin = nil
		arg0_16.moveStickPosition = nil
		arg0_16.moveStickDraging = nil

		if isActive(arg0_16.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_16:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, Vector2.zero)
		end
	end

	arg0_16:bind(var0_0.ON_POV_STICK_MOVE_END, function(arg0_27, arg1_27)
		var0_16()
	end)
	arg0_16:bind(var0_0.ON_POV_STICK_MOVE, function(arg0_28, arg1_28)
		if arg0_16.pinchMode then
			var0_16()

			return
		end

		if not arg0_16.moveStickDraging then
			return
		end

		arg0_16.moveStickPosition = arg0_16.moveStickPosition + arg1_28

		if isActive(arg0_16.povLayer:Find("Guide")) then
			setActive(arg0_16.povLayer:Find("Guide"), false)
		end
	end)

	local var1_16 = 32.4 / Screen.height

	arg0_16:bind(var0_0.ON_POV_STICK_VIEW, function(arg0_29, arg1_29)
		if arg0_16.pinchMode then
			return
		end

		arg1_29 = arg1_29 * var1_16

		local var0_29 = arg1_29.x
		local var1_29 = arg1_29.y

		local function var2_29(arg0_30, arg1_30, arg2_30)
			local var0_30 = arg0_30[arg1_30]

			var0_30.m_InputAxisValue = arg2_30
			arg0_30[arg1_30] = var0_30
		end

		if isActive(arg0_16.cameras[var0_0.CAMERA.POV]) then
			var2_29(arg0_16.compPovAim, "m_HorizontalAxis", var0_29)
			var2_29(arg0_16.compPovAim, "m_VerticalAxis", var1_29)
		elseif isActive(arg0_16.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			local var3_29 = arg0_16.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

			var2_29(var3_29, "m_HorizontalAxis", var0_29)
			var2_29(var3_29, "m_VerticalAxis", var1_29)
		end
	end)

	local var2_16 = {
		HideCharacterBylayer = true,
		EnableHeadIK = true,
		RevertCharacterBylayer = true
	}

	arg0_16:bind(var0_0.PHOTO_CALL, function(arg0_31, arg1_31, ...)
		if var2_16[arg1_31] then
			local var0_31 = arg0_16.ladyDict[arg0_16.apartment:GetConfigID()]

			arg0_16[arg1_31](arg0_16, var0_31, ...)
		else
			local var1_31 = arg0_16.ladyDict[arg0_16.apartment:GetConfigID()]

			arg0_16[arg1_31](var1_31, ...)
		end
	end)
end

function var0_0.RegisterIKFunc(arg0_32)
	pg.IKMgr.GetInstance():RegisterOnIKLayerActive(function(arg0_33)
		arg0_32.blockIK = true
		arg0_32.ikHandler = arg0_33

		local var0_33 = arg0_32.ladyDict[arg0_32.apartment:GetConfigID()]
		local var1_33 = _.detect(var0_33.readyIKLayers, function(arg0_34)
			return arg0_34:GetControllerPath() == arg0_33.ikData:GetControllerPath()
		end)

		arg0_32:EnableIKLayer(var1_33)

		arg0_32.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

		arg0_32:emit(var0_0.ON_IK_STATUS_CHANGED, var1_33:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDrag(function(arg0_35)
		arg0_32.ikHandler = arg0_35

		arg0_32:ResetIKTipTimer()
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_36, arg1_36)
		local var0_36 = arg0_32.ladyDict[arg0_32.apartment:GetConfigID()]
		local var1_36 = _.detect(var0_36.readyIKLayers, function(arg0_37)
			return arg0_37:GetControllerPath() == arg0_36.ikData:GetControllerPath()
		end)

		arg0_32:DeactiveIKLayer(var1_36)

		arg0_32.ikHandler = nil
		arg0_32.blockIK = arg1_36

		arg0_32:emit(var0_0.ON_IK_STATUS_CHANGED, var1_36:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_38)
		arg0_32.blockIK = nil

		local var0_38 = arg0_32.ladyDict[arg0_32.apartment:GetConfigID()]
		local var1_38 = _.detect(var0_38.readyIKLayers, function(arg0_39)
			return arg0_39:GetControllerPath() == arg0_38.ikData:GetControllerPath()
		end)

		arg0_32:OnTriggerIK(var1_38)
		arg0_32:emit(var0_0.ON_IK_STATUS_CHANGED, var1_38:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	end)
end

function var0_0.initScene(arg0_40)
	local var0_40, var1_40 = unpack(string.split(arg0_40.sceneInfo, "|"))
	local var2_40 = SceneManager.GetSceneByName(var0_40 .. "_base")

	arg0_40:ResetSceneStructure(var2_40)

	arg0_40.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_40.camBrain = arg0_40.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_40.camBrainEvenetHandler = arg0_40.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_40.raycastCamera = arg0_40.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_40.sceneRaycaster = arg0_40.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_40.player = GameObject.Find("Player").transform
	arg0_40.playerEye = arg0_40.player:Find("Eye")
	arg0_40.playerFoot = arg0_40.player:Find("Foot")

	setActive(arg0_40.playerFoot, false)

	arg0_40.playerController = arg0_40.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_40.attachedPoints = {}

	eachChild(arg0_40.furnitures, function(arg0_41)
		table.insert(arg0_40.attachedPoints, 1, arg0_41)
	end)

	arg0_40.modelRoot = GameObject.Find("scene_root").transform
	arg0_40.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_40.slotRoot, true)
	arg0_40:InitSlots()

	arg0_40.resTF = GameObject.Find("Res").transform

	tolua.loadassembly("Cinemachine")

	local var3_40 = GameObject.Find("CM Cameras").transform

	eachChild(var3_40, function(arg0_42)
		setActive(arg0_42, false)
	end)

	arg0_40.camBrain.enabled = false
	arg0_40.camBrain.enabled = true
	arg0_40.cameraAim = var3_40:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_40.cameraAim2 = var3_40:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_40.cameraFree = nil
	arg0_40.cameraFurnitureWatch = nil
	arg0_40.cameraRole = var3_40:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_40.cameraRole2 = var3_40:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	local var4_40 = var3_40:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	arg0_40.cameraGift = var3_40:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_40.cameras = {
		arg0_40.cameraAim,
		arg0_40.cameraAim2,
		arg0_40.cameraRole,
		[var0_0.CAMERA.TALK] = var4_40,
		[var0_0.CAMERA.GIFT] = arg0_40.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_40.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_40:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_40:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_40:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	}

	setActive(arg0_40.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_40.compPovAim = arg0_40.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_40.cameraRoot = var3_40
	arg0_40.POVOriginalFOV = arg0_40:GetPOVFOV()
	arg0_40.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_40.restrictedBox, false)

	arg0_40.restrictedHeightRange = {
		arg0_40.restrictedBox:Find("Floor").position.y,
		arg0_40.restrictedBox:Find("Celling").position.y
	}
	arg0_40.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_40.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))

	arg0_40:SwitchDayNight(arg0_40.contextData.timeIndex)

	arg0_40.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_40 .. "_base")).CutIn

	if arg0_40.tfCutIn then
		arg0_40.modelCutIn = {
			lady = arg0_40.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_40.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_40.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_43, arg1_43)
	if not IsNil(arg0_43.daynightCtrlComp) then
		arg0_43.daynightCtrlComp:SwitcherToIndex(arg1_43 - 1)
	end

	arg0_43:InitLightSettings()
end

function var0_0.InitLightSettings(arg0_44)
	arg0_44.globalVolume = GameObject.Find("GlobalVolume")

	arg0_44:RegisterGlobalVolume()

	arg0_44.characterLight = GameObject.Find("CharacterLight")

	arg0_44:RecordCharacterLight()

	local var0_44 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_44:GetComponentsInChildren(typeof(Light), true), function(arg0_45, arg1_45)
		arg1_45.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.ResetSceneStructure(arg0_46, arg1_46)
	table.IpairsCArray(arg1_46:GetRootGameObjects(), function(arg0_47, arg1_47)
		if arg1_47.name == "Furnitures" then
			arg0_46.furnitures = tf(arg1_47)

			eachChild(arg0_46.furnitures, function(arg0_48)
				if arg0_48:Find("FreeLook Camera") then
					setActive(arg0_48:Find("FreeLook Camera"), false)
				end

				if arg0_48:Find("FreeLook Camera") then
					setActive(arg0_48:Find("RoleWatch Camera"), false)
				end

				if arg0_48:Find("IKCamera") then
					setActive(arg0_48:Find("IKCamera"), false)
				end

				local var0_48 = arg0_48:GetComponent(typeof(UnityEngine.Collider))

				if not var0_48 then
					return
				end

				var0_48.enabled = false
			end)
		end
	end)

	arg0_46.sectorsDic = arg0_46.sectorsDic or {}

	if not arg0_46.sectorsDic[arg1_46.name] then
		arg0_46.sectorsDic[arg1_46.name] = table.shallowCopy(var2_0[arg1_46.name]) or {}

		setmetatable(arg0_46.sectorsDic[arg1_46.name], {
			__index = function(arg0_49, arg1_49)
				local var0_49 = arg0_46.furnitures:Find(arg1_49 .. "/StayPoint")

				if var0_49 then
					local var1_49 = var0_49.position
					local var2_49 = var0_49.eulerAngles

					arg0_49[arg1_49] = {
						Radius = 2,
						Angle = 120,
						Position = {
							var1_49.x,
							var1_49.y,
							var1_49.z
						},
						Rotation = {
							var2_49.x,
							var2_49.y,
							var2_49.z
						}
					}

					return arg0_49[arg1_49]
				else
					return nil
				end
			end
		})
	end

	arg0_46.activeSectors = arg0_46.sectorsDic[arg1_46.name]
end

function var0_0.InitSlots(arg0_50)
	local var0_50 = arg0_50.room:GetSlots()
	local var1_50 = arg0_50.modelRoot:GetComponentsInChildren(typeof(Transform), true)

	arg0_50.slotDict = {}

	_.each(var0_50, function(arg0_51)
		local var0_51 = arg0_51:GetFurnitureName()
		local var1_51 = arg0_51:GetConfigID()
		local var2_51 = arg0_50.slotRoot:Find(tostring(var1_51))

		assert(var2_51)

		local var3_51 = {
			trans = var2_51,
			sceneHides = {}
		}
		local var4_51 = var2_51:Find("Selector")

		if var4_51 then
			GetOrAddComponent(var4_51, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_52, arg1_52)
				arg0_50:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_51)
			end)
			setActive(var4_51, false)
		end

		local var5_51

		for iter0_51 = 0, var1_50.Length - 1 do
			local var6_51 = var1_50[iter0_51]

			if var6_51.name == var0_51 then
				var5_51 = var6_51

				break
			end
		end

		if var5_51 then
			var3_51.model = var5_51
		end

		arg0_50.slotDict[var1_51] = var3_51
	end)
end

function var0_0.SetContactStateDic(arg0_53, arg1_53)
	arg0_53.contactStateDic = arg1_53
	arg0_53.hideContactStateDic = {}
	arg0_53.contactInRangeDic = {}

	for iter0_53, iter1_53 in pairs(arg0_53.contactStateDic) do
		arg0_53.hideContactStateDic[iter0_53] = math.min(iter1_53, ApartmentRoom.ITEM_UNLOCK)
		arg0_53.contactInRangeDic[iter0_53] = false
	end

	arg0_53:ActiveContact()
end

function var0_0.TempHideContact(arg0_54, arg1_54)
	arg0_54.hideConcatFlag = arg1_54

	arg0_54:ActiveContact()
end

function var0_0.ActiveContact(arg0_55)
	for iter0_55, iter1_55 in pairs(arg0_55.contactInRangeDic) do
		arg0_55:UpdateContactDisplay(iter0_55, arg0_55.contactInRangeDic[iter0_55] and not arg0_55.hideConcatFlag and arg0_55.contactStateDic[iter0_55] or arg0_55.hideContactStateDic[iter0_55])
	end
end

function var0_0.UpdateContactDisplay(arg0_56, arg1_56, arg2_56)
	local var0_56 = pg.dorm3d_collection_template[arg1_56]

	for iter0_56, iter1_56 in ipairs(var0_56.vfx_prefab) do
		local var1_56 = arg0_56.modelRoot:Find(iter1_56)

		if arg0_56:IsModeInHidePending(iter1_56) then
			-- block empty
		elseif not arg0_56.modelRoot:Find(iter1_56) then
			warning(arg1_56, iter1_56)
		else
			setActive(var1_56, arg2_56 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_56, iter3_56 in ipairs(var0_56.model) do
		if arg0_56:IsModeInHidePending(iter3_56) then
			-- block empty
		elseif not arg0_56.modelRoot:Find(iter3_56) then
			warning(arg1_56, iter3_56)
		else
			local var2_56 = arg0_56.modelRoot:Find(iter3_56)

			if arg0_56:CheckSceneItemActive(var2_56) then
				local var3_56 = GetComponent(var2_56, typeof(EventTriggerListener))

				if arg2_56 == ApartmentRoom.ITEM_FIRST then
					var3_56 = var3_56 or GetOrAddComponent(var2_56, typeof(EventTriggerListener))

					var3_56:AddPointClickFunc(function(arg0_57, arg1_57)
						arg0_56:emit(var0_0.CLICK_CONTACT, arg1_56)
					end)

					var3_56.enabled = true
				elseif var3_56 then
					var3_56.enabled = false
				end

				setActive(var2_56, arg2_56 > ApartmentRoom.ITEM_LOCK)
			end
		end
	end
end

function var0_0.SetFloatEnable(arg0_58, arg1_58)
	arg0_58.enableFloatUpdate = arg1_58

	if arg1_58 then
		arg0_58.ladyDict[arg0_58.apartment:GetConfigID()]:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_59)
	local var0_59 = arg0_59.ladyDict[arg0_59.apartment:GetConfigID()]
	local var1_59 = arg0_59:GetScreenPosition(var0_59.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var2_59 = arg0_59:GetLocalPosition(var1_59, arg0_59.rtFloatPage)

	setLocalPosition(arg0_59.rtFloatPage:Find("lady"), var2_59)
end

function var0_0.LoadCharacter(arg0_60, arg1_60, arg2_60)
	arg0_60.hxMatDict = {}
	arg0_60.ladyDict = {}
	arg0_60.skinDict = {}

	local var0_60 = {}

	for iter0_60, iter1_60 in ipairs(arg1_60) do
		local var1_60 = setmetatable({}, {
			__index = arg0_60
		})

		arg0_60.ladyDict[iter1_60] = var1_60

		local var2_60 = getProxy(ApartmentProxy):getApartment(iter1_60)
		local var3_60 = var2_60:getConfig("asset_name")
		local var4_60 = var2_60:GetSkinModelID(arg0_60.room:getConfig("tag"))
		local var5_60 = pg.dorm3d_resource[var4_60].model_id

		assert(var5_60)

		for iter2_60, iter3_60 in ipairs({
			"common",
			var5_60
		}) do
			local var6_60 = string.format("dorm3d/character/%s/res/%s", var3_60, iter3_60)

			if checkABExist(var6_60) then
				table.insert(var0_60, function(arg0_61)
					arg0_60.loader:LoadBundle(var6_60, function(arg0_62)
						for iter0_62, iter1_62 in ipairs(arg0_62:GetAllAssetNames()) do
							local var0_62, var1_62, var2_62 = string.find(iter1_62, "material_hx[/\\](.*).mat")

							if var0_62 then
								arg0_60.hxMatDict[var2_62] = {
									arg0_62,
									iter1_62
								}
							end
						end

						arg0_61()
					end)
				end)
			end
		end

		var1_60.skinId = var4_60
		var1_60.skinIdList = {
			var4_60
		}

		table.insert(var0_60, function(arg0_63)
			local var0_63 = string.format("dorm3d/character/%s/prefabs/%s", var3_60, var5_60)

			arg0_60.loader:GetPrefab(var0_63, "", function(arg0_64)
				var1_60.ladyGameobject = arg0_64
				arg0_60.skinDict[var4_60] = {
					ladyGameobject = arg0_64
				}

				arg0_63()
			end)
		end)

		if arg0_60.room:isPersonalRoom() then
			local var7_60 = var2_60:GetSkinModelID("touch")

			if var7_60 then
				local var8_60 = pg.dorm3d_resource[var7_60].model_id

				if #var8_60 > 0 then
					table.insert(var1_60.skinIdList, var7_60)
					table.insert(var0_60, function(arg0_65)
						local var0_65 = string.format("dorm3d/character/%s/prefabs/%s", var3_60, var8_60)

						arg0_60.loader:GetPrefab(var0_65, "", function(arg0_66)
							arg0_60.skinDict[var7_60] = {
								ladyGameobject = arg0_66
							}
							GetComponent(arg0_66, "GraphOwner").enabled = false

							onNextTick(function()
								setActive(arg0_66, false)
							end)
							arg0_65()
						end)
					end)
				end
			end
		end

		if arg0_60.contextData.pendingDic[iter1_60] then
			local var9_60 = pg.dorm3d_welcome[arg0_60.contextData.pendingDic[iter1_60]]

			if var9_60.item_prefab ~= "" then
				table.insert(var0_60, function(arg0_68)
					local var0_68 = string.lower("dorm3d/furniture/item/" .. var9_60.item_prefab)

					arg0_60.loader:GetPrefab(var0_68, "", function(arg0_69)
						var1_60.tfPendintItem = arg0_69.transform

						onNextTick(function()
							setActive(arg0_69, false)
						end)
						arg0_68()
					end)
				end)
			end
		end
	end

	parallelAsync(var0_60, arg2_60)
end

function var0_0.HXCharacter(arg0_71, arg1_71)
	if not HXSet.isHx() then
		return
	end

	local var0_71 = arg1_71:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_71, function(arg0_72, arg1_72)
		local var0_72 = arg1_72.sharedMaterials
		local var1_72 = false

		table.IpairsCArray(var0_72, function(arg0_73, arg1_73)
			if arg1_73 == nil then
				return
			end

			local var0_73 = arg1_73.name

			if not arg0_71.hxMatDict[var0_73] then
				return
			end

			var1_72 = true

			local var1_73, var2_73 = unpack(arg0_71.hxMatDict[var0_73])
			local var3_73 = var1_73:LoadAssetSync(var2_73, typeof(Material), false, false)

			var0_72[arg0_73] = var3_73

			warning("Replace HX Material", arg0_71.hxMatDict[var0_73][2])
		end)

		if var1_72 then
			arg1_72.sharedMaterials = var0_72
		end
	end)
end

function var0_0.InitCharacter(arg0_74, arg1_74, arg2_74)
	arg1_74.lady = arg1_74.ladyGameobject.transform

	arg1_74.lady:SetParent(arg1_74.mainCameraTF)
	arg1_74.lady:SetParent(nil)

	arg1_74.ladyHeadIKComp = arg1_74.lady:GetComponent(typeof(HeadAimIK))
	arg1_74.ladyHeadIKComp.AimTarget = arg1_74.mainCameraTF:Find("AimTarget")
	arg1_74.ladyHeadIKData = {
		DampTime = arg1_74.ladyHeadIKComp.DampTime,
		blinkSpeed = arg1_74.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg1_74.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg1_74.ladyHeadIKComp.HeadWeight
	}

	local var0_74 = {}

	table.Foreach(var1_0, function(arg0_75, arg1_75)
		var0_74[arg1_75] = arg0_75
	end)

	arg1_74.ladyAnimator = arg1_74.lady:GetComponent(typeof(Animator))
	arg1_74.ladyAnimBaseLayerIndex = arg1_74.ladyAnimator:GetLayerIndex("Base Layer")
	arg1_74.ladyAnimFaceLayerIndex = arg1_74.ladyAnimator:GetLayerIndex("Face")
	arg1_74.ladyBoneMaps = {}

	local var1_74 = arg1_74.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_74, function(arg0_76, arg1_76)
		if arg1_76.name == "BodyCollider" then
			arg1_74.ladyCollider = arg1_76

			setActive(arg1_76, true)
		elseif arg1_76.name == "SafeCollider" then
			arg1_74.ladySafeCollider = arg1_76

			setActive(arg1_76, false)
		elseif arg1_76.name == "Interest" then
			arg1_74.ladyInterestRoot = arg1_76
		elseif arg1_76.name == "Head Center" then
			arg1_74.ladyHeadCenter = arg1_76
		end

		if var0_74[arg1_76.name] then
			arg1_74.ladyBoneMaps[var0_74[arg1_76.name]] = arg1_76
		end
	end)

	arg1_74.ladyColliders = {}
	arg1_74.ladyTouchColliders = {}

	table.IpairsCArray(arg1_74.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_77, arg1_77)
		if arg1_77:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_77)

		local var0_77 = child.name
		local var1_77 = var0_77 and string.find(var0_77, "Collider") or -1

		if var1_77 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_77)

			return
		end

		local var2_77 = string.sub(var0_77, 1, var1_77 - 1)

		if var0_0.BONE_TO_TOUCH[var2_77] == nil then
			return
		end

		arg1_74.ladyColliders[var2_77] = child

		table.insert(arg1_74.ladyTouchColliders, child)
		setActive(child, false)
	end)
	arg1_74:HXCharacter(arg1_74.lady)
	;(function()
		local var0_78 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_78 = "vfx_function_aixin02"

		arg1_74.loader:GetPrefab(var0_78, var1_78, function(arg0_79)
			arg1_74.effectHeart = arg0_79

			setActive(arg0_79, false)
			onNextTick(function()
				setParent(arg1_74.effectHeart, arg1_74.ladyHeadCenter)
			end)
		end)
	end)()

	arg1_74.clothComps = {}
	arg1_74.ladyClothCompSettings = {}

	table.IpairsCArray(arg1_74.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_81, arg1_81)
		table.insert(arg1_74.clothComps, arg1_81)

		arg1_74.ladyClothCompSettings[arg1_81] = {
			enabled = arg1_81.enabled
		}
	end)

	arg1_74.clothColliderDict = {}
	arg1_74.ladyClothColliderSettings = {}

	local var2_74 = typeof("MagicaCloth.MagicaCapsuleCollider")

	table.IpairsCArray(arg1_74.lady:GetComponentsInChildren(var2_74, true), function(arg0_82, arg1_82)
		arg1_74.clothColliderDict[arg1_82.name] = arg1_82
		arg1_74.ladyClothColliderSettings[arg1_82] = {
			enabled = arg1_82.enabled,
			StartRadius = ReflectionHelp.RefGetProperty(var2_74, "StartRadius", arg1_82),
			EndRadius = ReflectionHelp.RefGetProperty(var2_74, "EndRadius", arg1_82)
		}
	end)
	arg1_74:EnableCloth(arg1_74, false)

	arg1_74.ladyIKRoot = arg1_74.lady:Find("IKLayers")

	eachChild(arg1_74.ladyIKRoot, function(arg0_83)
		setActive(arg0_83, false)
	end)
	GetComponent(arg1_74.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_84, arg1_84)
		if arg1_84.rawPointerPress.transform == arg1_74.ladyCollider then
			arg1_74:emit(var0_0.CLICK_CHARACTER, arg2_74)
		else
			local var0_84 = table.keyof(arg1_74.IKSettings.Colliders, arg1_84.rawPointerPress.transform)

			arg1_74:emit(var0_0.ON_TOUCH_CHARACTER, var0_0.BONE_TO_TOUCH[var0_84] or arg1_84.rawPointerPress.name)
		end
	end)
	arg1_74.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_85)
		if arg1_74.nowState and arg0_85.animatorStateInfo:IsName(arg1_74.nowState) then
			existCall(arg1_74.stateCallback)

			return
		end

		local var0_85 = arg0_85.animatorStateInfo

		for iter0_85, iter1_85 in pairs(arg1_74.animCallbacks) do
			if var0_85:IsName(iter0_85) then
				warning("Active", iter0_85)

				local var1_85 = table.removebykey(arg1_74.animCallbacks, iter0_85)

				existCall(var1_85)

				return
			end
		end

		if arg0_85.stringParameter ~= "" then
			arg1_74:OnAnimationEvent(arg0_85)
		end
	end)

	arg1_74.animEventCallbacks = {}
	arg1_74.animCallbacks = {}
end

function var0_0.SwitchCharacterSkin(arg0_86, arg1_86, arg2_86, arg3_86, arg4_86)
	local var0_86 = arg1_86.skinIdList

	assert(table.contains(var0_86, arg3_86))

	local var1_86 = arg0_86:GetCurrentAnim()
	local var2_86 = arg1_86.skinId
	local var3_86 = arg1_86.skinDict[var2_86].ladyGameobject
	local var4_86 = var3_86.transform.position
	local var5_86 = var3_86.transform.rotation

	setActive(var3_86, false)

	arg1_86.skinId = arg3_86

	setActive(arg1_86.skinDict[arg3_86].ladyGameobject, true)

	arg1_86.ladyGameobject = arg1_86.skinDict[arg3_86].ladyGameobject
	arg1_86.ladyCollider = nil

	arg0_86:InitCharacter(arg1_86, arg2_86)
	arg1_86.ladyAnimator:Play(var1_86, arg1_86.ladyAnimBaseLayerIndex)
	arg1_86.ladyAnimator:Update(0)
	arg1_86.lady:SetPositionAndRotation(var4_86, var5_86)
	existCall(arg4_86)
end

function var0_0.SetCameraLady(arg0_87, arg1_87)
	arg0_87.cameraAim2.LookAt = arg1_87.ladyInterestRoot
	arg0_87.cameras[var0_0.CAMERA.TALK].Follow = arg0_87.ladyInterest
	arg0_87.cameras[var0_0.CAMERA.TALK].LookAt = arg0_87.ladyInterest
	arg0_87.cameraGift.Follow = arg0_87.ladyInterest
	arg0_87.cameraGift.LookAt = arg0_87.ladyInterest
	arg0_87.cameraRole2.LookAt = arg1_87.ladyInterestRoot
	arg0_87.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_87.ladyInterest
	arg0_87.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_87.ladyInterest
end

function var0_0.initNodeCanvas(arg0_88)
	local var0_88 = pg.NodeCanvasMgr.GetInstance()

	var0_88:Active()
	var0_88:RegisterFunc("DistanceTrigger", function(arg0_89)
		arg0_88:emit(var0_0.DISTANCE_TRIGGER, arg0_89, arg0_88.ladyDict[arg0_89].dis)
	end)
	var0_88:RegisterFunc("ShortWaitAction", function(arg0_90)
		arg0_88:DoShortWait(arg0_90)
	end)
	var0_88:RegisterFunc("WatchShortWaitAction", function(arg0_91)
		arg0_88:DoShortWait(arg0_91)
	end)
	var0_88:RegisterFunc("WalkDistanceTrigger", function(arg0_92)
		arg0_88:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_92, arg0_88.ladyDict[arg0_92].dis)
	end)
	var0_88:RegisterFunc("ChangeWatch", function(arg0_93)
		arg0_88:emit(var0_0.CHANGE_WATCH, arg0_93)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_94, arg1_94, arg2_94)
	arg0_94[arg1_94] = arg2_94

	for iter0_94, iter1_94 in pairs(arg0_94.ladyDict) do
		arg0_94:SetBlackboardValue(iter1_94, arg1_94, arg2_94)
	end
end

function var0_0.SetBlackboardValue(arg0_95, arg1_95, arg2_95, arg3_95)
	arg1_95.blackboard = arg1_95.blackboard or {}
	arg1_95.blackboard[arg2_95] = arg3_95

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg2_95, arg3_95, arg1_95.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_96, arg1_96, arg2_96)
	arg1_96.blackboard = arg1_96.blackboard or {}

	return arg1_96.blackboard[arg2_96]
end

function var0_0.didEnter(arg0_97)
	local var0_97 = -21.6 / Screen.height

	arg0_97.joystickDelta = Vector2.zero
	arg0_97.joystickTimer = FrameTimer.New(function()
		local var0_98 = arg0_97.joystickDelta * var0_97
		local var1_98 = var0_98.x
		local var2_98 = var0_98.y

		local function var3_98(arg0_99, arg1_99, arg2_99)
			local var0_99 = arg0_99[arg1_99]

			var0_99.m_InputAxisValue = arg2_99
			arg0_99[arg1_99] = var0_99
		end

		if arg0_97.surroudCamera and not arg0_97.pinchMode then
			var3_98(arg0_97.surroudCamera, "m_XAxis", var1_98)
			var3_98(arg0_97.surroudCamera, "m_YAxis", var2_98)
		end

		arg0_97.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_97.joystickTimer:Start()

	local var1_97 = 1.75

	arg0_97.moveStickTimer = FrameTimer.New(function()
		if not arg0_97.moveStickDraging then
			return
		end

		local var0_100 = arg0_97.moveStickPosition
		local var1_100 = 200
		local var2_100 = (var0_100 - arg0_97.moveStickOrigin):ClampMagnitude(var1_100)
		local var3_100 = var2_100 / var1_100

		arg0_97.moveStickPosition = arg0_97.moveStickOrigin + var2_100

		local var4_100 = Vector3.New(var3_100.x, 0, var3_100.y)
		local var5_100 = arg0_97.mainCameraTF:TransformDirection(var4_100)

		var5_100.y = 0

		local var6_100 = var5_100:Normalize()

		var6_100:Mul(var1_97)

		if isActive(arg0_97.cameras[var0_0.CAMERA.POV]) then
			arg0_97.playerController:SimpleMove(var6_100)

			arg0_97.tweenFOV = true
		elseif isActive(arg0_97.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_97.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_100 * Time.deltaTime)
			arg0_97:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_100:Normalize())
			onNextTick(function()
				local var0_101 = arg0_97.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_101 = math.InverseLerp(arg0_97.restrictedHeightRange[1], arg0_97.restrictedHeightRange[2], var0_101.position.y)

				arg0_97:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_101)
			end)
		end
	end, 1, -1)

	arg0_97.moveStickTimer:Start()

	arg0_97.pinchMode = false
	arg0_97.pinchSize = 0
	arg0_97.pinchValue = 1
	arg0_97.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_102, arg1_102)
		if arg0_97.surroudCamera and isActive(arg0_97.surroudCamera) then
			arg0_97.pinchMode = true
			arg0_97.pinchSize = (arg0_102 - arg1_102):Magnitude()
			arg0_97.pinchNodeOrder = arg1_102.x < arg0_102.x and -1 or 1

			return
		end

		if isActive(arg0_97.cameras[var0_0.CAMERA.POV]) then
			if (arg0_102 - arg1_102):Magnitude() < Screen.height * 0.5 then
				arg0_97.pinchMode = true
				arg0_97.pinchSize = (arg0_102 - arg1_102):Magnitude()
				arg0_97.pinchNodeOrder = arg1_102.x < arg0_102.x and -1 or 1
			end

			return
		end
	end)

	local var2_97 = 0.01

	if IsUnityEditor then
		var2_97 = 0.1
	end

	local var3_97 = var2_97 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_103, arg1_103)
		if not arg0_97.pinchMode then
			return
		end

		local var0_103 = (arg0_103 - arg1_103):Magnitude()
		local var1_103 = arg0_97.pinchSize - var0_103
		local var2_103 = arg0_97.pinchNodeOrder * (arg1_103.x < arg0_103.x and -1 or 1)
		local var3_103 = var1_103 * var3_97 * var2_103

		if isActive(arg0_97.cameras[var0_0.CAMERA.POV]) then
			local var4_103 = 0.5
			local var5_103 = 1

			arg0_97.pinchValue = math.clamp(arg0_97.pinchValue + var3_103, var4_103, var5_103)
			arg0_97.pinchSize = var0_103

			arg0_97:SetPOVFOV(arg0_97.POVOriginalFOV * arg0_97.pinchValue)

			arg0_97.tweenFOV = nil

			return
		end

		if isActive(arg0_97.surroudCamera) and arg0_97.surroudCamera == arg0_97.cameras[var0_0.CAMERA.PHOTO] then
			local var6_103 = 0.5
			local var7_103 = 1

			arg0_97:SetPinchValue(math.clamp(arg0_97.pinchValue + var3_103, var6_103, var7_103))

			arg0_97.pinchSize = var0_103

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_97.pinchMode = false
		arg0_97.pinchSize = 0
	end)

	arg0_97.cameraBlendCallbacks = {}
	arg0_97.activeCMCamera = nil

	function arg0_97.camBrainEvenetHandler.OnBlendStarted(arg0_105)
		if arg0_97.activeCMCamera then
			arg0_97:OnCameraBlendFinished(arg0_97.activeCMCamera)
		end

		local var0_105 = arg0_97.camBrain.ActiveVirtualCamera

		arg0_97.activeCMCamera = var0_105
	end

	function arg0_97.camBrainEvenetHandler.OnBlendFinished(arg0_106)
		arg0_97.activeCMCamera = nil

		arg0_97:OnCameraBlendFinished(arg0_106)
	end

	for iter0_97, iter1_97 in pairs(arg0_97.ladyDict) do
		if iter1_97.tfPendintItem then
			onNextTick(function()
				setParent(iter1_97.tfPendintItem, iter1_97.lady)
			end)
		end

		iter1_97.ladyOwner = GetComponent(iter1_97.lady, "GraphOwner")
		iter1_97.ladyBlackboard = GetComponent(iter1_97.lady, "Blackboard")

		arg0_97:SetBlackboardValue(iter1_97, "groupId", iter0_97)
		onNextTick(function()
			iter1_97.ladyOwner.enabled = true
		end)
	end

	arg0_97.expressionDict = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_97.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_97:ActiveCamera(arg0_97.cameras[var0_0.CAMERA.POV])
	arg0_97:RefreshSlots()

	arg0_97.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_97:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_97.updateHandler)
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
				local var0_117 = Time.time > arg0_114.nextTipIKTime
				local var1_117 = arg0_114:GetIKTipsRootTF()

				if var0_117 then
					local var2_117 = arg0_117.ikConfig
					local var3_117 = #arg0_117.readyIKLayers + #var2_117.touch_data

					UIItemList.StaticAlign(var1_117, var1_117:GetChild(0), var3_117, function(arg0_120, arg1_120, arg2_120)
						if arg0_120 ~= UIItemList.EventUpdate then
							return
						end

						arg1_120 = arg1_120 + 1

						local var0_120
						local var1_120 = Vector2.zero

						if arg1_120 > #arg0_117.readyIKLayers then
							local var2_120 = arg1_120 - #arg0_117.readyIKLayers
							local var3_120 = var2_117.touch_data[var2_120][1]
							local var4_120 = pg.dorm3d_ik_touch[var3_120]

							if #var4_120.scene_item > 0 then
								var0_120 = arg0_114:GetSceneItem(var4_120.scene_item)
							else
								var0_120 = arg0_117.IKSettings.Colliders[var4_120.body]
							end
						else
							local var5_120 = arg0_117.readyIKLayers[arg1_120]
							local var6_120 = var5_120:GetTriggerBoneName()

							var0_120 = var6_120 and arg0_117.IKSettings.Colliders[var6_120] or nil
							var1_120 = var5_120:GetIKTipOffset()
						end

						if var0_120 then
							local function var7_120()
								local var0_121 = arg0_117.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var0_120.position)
								local var1_121 = CameraMgr.instance:Raycast(arg0_117.IKSettings.CameraRaycaster, var0_121)

								if var1_121.Length == 0 then
									return
								end

								return var0_120 == var1_121[0].gameObject.transform
							end
						end

						if var0_120 then
							setLocalPosition(arg2_120, arg0_114:GetLocalPosition(arg0_114:GetScreenPosition(var0_120.position, arg0_117.IKSettings.CameraRaycaster.eventCamera), var1_117) + var1_120)

							local var8_120 = var0_120.position
							local var9_120 = var0_120:GetComponent(typeof(UnityEngine.Collider))

							if var9_120 then
								var8_120 = var9_120.bounds.center
							end

							setLocalPosition(arg2_120, arg0_114:GetLocalPosition(arg0_114:GetScreenPosition(var8_120), var1_117) + var1_120)
						end

						setActive(arg2_120, var0_120)
					end)
				end

				setActive(var1_117, var0_117)
				setActive(arg0_114.ikTextTipsRoot, var0_117)
			end
		end)(arg0_114.ladyDict[arg0_114.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_122)
	if not isActive(arg0_122.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_122 = arg0_122.mainCameraTF.position

	var0_122.y = 0

	for iter0_122, iter1_122 in pairs(arg0_122.ladyDict) do
		local var1_122 = tobool(arg0_122.activeLady[iter0_122])

		if var1_122 ~= tobool(var0_0.IsPointInSector(arg0_122.activeSectors[iter1_122.ladyActiveZone], var0_122)) then
			arg0_122.activeLady[iter0_122] = not var1_122

			arg0_122:emit(var0_0.ON_ENTER_SECTOR, iter0_122)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_123)
	for iter0_123, iter1_123 in pairs(arg0_123.ladyDict) do
		iter1_123.dis = (iter1_123.lady.position - arg0_123.player.position).magnitude

		if (arg0_123:GetBlackboardValue(iter1_123, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_123.dis ~= arg0_123:GetBlackboardValue(iter1_123, "inDistance") then
			arg0_123:SetBlackboardValue(iter1_123, "inDistance", iter1_123.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_123:emit(var0_0.ON_CHANGE_DISTANCE, iter0_123, iter1_123.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end
end

function var0_0.OnStickMove(arg0_124, arg1_124)
	arg0_124.joystickDelta = arg1_124
end

function var0_0.SetPinchValue(arg0_125, arg1_125)
	arg0_125.pinchValue = arg1_125

	arg0_125:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_126)
	local var0_126 = arg0_126.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_126)
end

function var0_0.SetPOVFOV(arg0_127, arg1_127)
	local var0_127 = arg0_127.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_127, arg1_127)

	arg0_127.cameras[var0_0.CAMERA.POV].m_Lens = var0_127
end

function var0_0.RefreshSlots(arg0_128, arg1_128)
	arg1_128 = arg1_128 or arg0_128.room

	local var0_128 = arg1_128:GetSlots()
	local var1_128 = arg1_128:GetFurnitures()

	arg0_128:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_128, function(arg0_129, arg1_129, arg2_129)
		local var0_129 = arg1_129:GetConfigID()
		local var1_129 = _.detect(var1_128, function(arg0_130)
			return arg0_130:GetSlotID() == var0_129
		end)
		local var2_129 = var1_129 and var1_129:GetModel() or false
		local var3_129 = arg0_128.slotDict[var0_129].model

		arg0_128.slotDict[var0_129].displayModelName = var2_129
		arg0_128.slotDict[var0_129].furnitureId = var1_129 and var1_129:GetConfigID()

		local function var4_129(arg0_131)
			if var3_129 then
				setActive(var3_129, var2_129 == "")
			end

			table.Foreach(arg0_128.slotDict[var0_129].sceneHides or {}, function(arg0_132, arg1_132)
				setActive(arg1_132.trans, arg1_132.visible)
			end)

			arg0_128.slotDict[var0_129].sceneHides = {}

			if arg0_131 then
				local var0_131 = arg0_131:getConfig("scene_hides")

				if #var0_131 > 0 then
					table.Ipairs(var0_131, function(arg0_133, arg1_133)
						local var0_133 = arg0_128.modelRoot:Find(arg1_133)

						assert(var0_133, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_131:GetConfigID(), arg1_133))

						local var1_133 = isActive(var0_133)

						table.insert(arg0_128.slotDict[var0_129].sceneHides, {
							name = arg1_133,
							trans = var0_133,
							visible = var1_133
						})
						setActive(var0_133, false)
					end)
				end
			end
		end

		if var2_129 == false or var2_129 == "" then
			arg0_128.loader:ClearRequest("slot_" .. var0_129)
			var4_129()
			arg2_129()

			return
		end

		local var5_129 = arg0_128.slotDict[var0_129].trans

		if arg0_128.loader:GetLoadingRP("slot_" .. var0_129) then
			arg0_128:emit(var0_0.HIDE_BLOCK)
		end

		arg0_128.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_129, "", function(arg0_134)
			arg2_129()
			assert(arg0_134)
			setParent(arg0_134, var5_129)
			var4_129(var1_129)
		end, "slot_" .. var0_129)
	end, function()
		arg0_128:emit(var0_0.HIDE_BLOCK)
	end)
end

function var0_0.CheckSceneItemActiveByPath(arg0_136, arg1_136)
	local var0_136 = arg0_136:GetSceneItem(arg1_136)

	return arg0_136:CheckSceneItemActive(var0_136)
end

function var0_0.CheckSceneItemActive(arg0_137, arg1_137)
	local var0_137 = true
	local var1_137

	table.Checkout(arg0_137.slotDict, function(arg0_138, arg1_138)
		if underscore.detect(arg1_138.sceneHides, function(arg0_139)
			return arg0_139.trans == arg1_137
		end) then
			var0_137 = false
			var1_137 = arg1_138.furnitureId

			return false
		end
	end)

	return var0_137, var1_137
end

function var0_0.ChangeCharacterPosition(arg0_140, arg1_140)
	arg0_140:ResetCharPoint(arg1_140, arg1_140.ladyActiveZone)
	arg0_140:SyncInterestTransform(arg1_140)
end

function var0_0.SyncCurrentInterestTransform(arg0_141)
	local var0_141 = arg0_141.ladyDict[arg0_141.apartment:GetConfigID()]

	arg0_141:SyncInterestTransform(var0_141)
end

function var0_0.SyncInterestTransform(arg0_142, arg1_142)
	arg0_142.ladyInterest.position = arg1_142.ladyInterestRoot.position
	arg0_142.ladyInterest.rotation = arg1_142.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_143, arg1_143)
	arg1_143 = arg1_143 or arg0_143.contextData.inFurnitureName

	local var0_143 = arg0_143.furnitures:Find(arg1_143):Find("PlayerPoint").position

	arg0_143.player.position = var0_143
	arg0_143.cameras[var0_0.CAMERA.POV].transform.position = arg0_143.playerEye.position

	local var1_143 = arg0_143.ladyInterest.position - arg0_143.playerEye.position
	local var2_143 = Quaternion.LookRotation(var1_143).eulerAngles
	local var3_143 = var2_143.y
	local var4_143 = var2_143.x
	local var5_143 = arg0_143.compPovAim.m_HorizontalAxis

	var5_143.Value = arg0_143:GetNearestAngle(var3_143, var5_143.m_MinValue, var5_143.m_MaxValue)
	arg0_143.compPovAim.m_HorizontalAxis = var5_143

	local var6_143 = arg0_143.compPovAim.m_VerticalAxis

	var6_143.Value = var4_143
	arg0_143.compPovAim.m_VerticalAxis = var6_143
end

function var0_0.GetAttachedFurnitureName(arg0_144)
	return arg0_144.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_145, arg1_145)
	return underscore.detect(arg0_145.attachedPoints, function(arg0_146)
		return arg0_146.name == arg1_145
	end)
end

function var0_0.GetSlotByID(arg0_147, arg1_147)
	return arg0_147.displaySlots[arg1_147] and arg0_147.displaySlots[arg1_147].trans
end

function var0_0.GetScreenPosition(arg0_148, arg1_148, arg2_148)
	arg2_148 = arg2_148 or arg0_148.raycastCamera

	local var0_148 = arg2_148:WorldToScreenPoint(arg1_148)

	if var0_148.z < 0 then
		var0_148.x = var0_148.x + (var0_148.x < 0 and -1 or 1) * Screen.width
		var0_148.y = var0_148.y + (var0_148.y < 0 and -1 or 1) * Screen.height
		var0_148.z = -var0_148.z
	end

	return var0_148
end

function var0_0.GetLocalPosition(arg0_149, arg1_149, arg2_149)
	return LuaHelper.ScreenToLocal(arg2_149, arg1_149, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_150)
	return arg0_150.modelRoot
end

function var0_0.ShiftZone(arg0_151, arg1_151, arg2_151)
	local var0_151 = arg0_151:GetFurnitureByName(arg1_151)

	if not var0_151 then
		errorMsg(arg1_151 .. " Not Find")
		existCall(arg2_151)

		return
	end

	seriesAsync({
		function(arg0_152)
			arg0_151:emit(var0_0.SHOW_BLOCK)
			arg0_151:ShowBlackScreen(true, arg0_152)
		end,
		function(arg0_153)
			if arg0_151.shiftLady or arg0_151.room:isPersonalRoom() then
				local var0_153 = arg0_151.shiftLady or arg0_151.apartment:GetConfigID()

				arg0_151.shiftLady = nil
				arg0_151.contextData.ladyZone[var0_153] = var0_151.name

				local var1_153 = arg0_151.ladyDict[var0_153]

				var1_153.ladyBaseZone = arg0_151.contextData.ladyZone[var0_153]
				var1_153.ladyActiveZone = arg0_151.contextData.ladyZone[var0_153]

				if arg0_151:GetBlackboardValue(var1_153, "inPending") then
					arg0_151:SetOutPending(var1_153)
					arg0_151:SwitchAnim(var1_153, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_151:ChangeCharacterPosition(var1_153)
						arg0_153()
					end)
				else
					arg0_151:ChangeCharacterPosition(var1_153)
					arg0_153()
				end
			else
				arg0_153()
			end
		end,
		function(arg0_155)
			arg0_151.contextData.inFurnitureName = var0_151.name

			if not arg0_151.apartment then
				for iter0_155, iter1_155 in pairs(arg0_151.ladyDict) do
					if iter1_155.ladyBaseZone == arg0_151.contextData.inFurnitureName then
						arg0_151:SyncInterestTransform(iter1_155)

						break
					end
				end
			end

			arg0_151:ChangePlayerPosition()
			arg0_151:TriggerLadyDistance()
			arg0_151:CheckInSector()
			arg0_155()
		end,
		function(arg0_156)
			arg0_151:UpdateZoneList()
			arg0_151:ShowBlackScreen(false, arg0_156)
		end,
		function(arg0_157)
			arg0_151:emit(var0_0.HIDE_BLOCK)
			arg0_157()
		end
	}, arg2_151)
end

function var0_0.ActiveCamera(arg0_158, arg1_158)
	local var0_158 = isActive(arg1_158)

	table.Foreach(arg0_158.cameras, function(arg0_159, arg1_159)
		setActive(arg1_159, arg1_159 == arg1_158)
	end)

	if var0_158 then
		arg0_158:OnCameraBlendFinished(arg1_158)
	end
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
			arg0_166:SyncInterestTransform(arg0_166.ladyDict[arg0_166.apartment:GetConfigID()])
			arg0_166:SetCameraLady(arg0_166.ladyDict[arg0_166.apartment:GetConfigID()])
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
			arg0_166:SetCameraLady(arg0_166.ladyDict[arg0_166.apartment:GetConfigID()])
			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.GIFT], arg0_171)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_172)
			assert(arg0_166.apartment)
			arg0_166:SetCameraLady(arg0_166.ladyDict[arg0_166.apartment:GetConfigID()])

			arg0_166.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_166.cameraRole.transform.position

			arg0_166:RegisterCameraBlendFinished(arg0_166.cameras[var0_0.CAMERA.ROLE2], arg0_172)
			arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_173)
			assert(arg0_166.apartment)
			arg0_166:SetCameraLady(arg0_166.ladyDict[arg0_166.apartment:GetConfigID()])
			arg0_166:SyncInterestTransform(arg0_166.ladyDict[arg0_166.apartment:GetConfigID()])
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

	if string.find(arg1_175, "fbx/") == 1 then
		var0_175 = arg0_175.modelRoot:Find(arg1_175)
	elseif string.find(arg1_175, "FurnitureSlots/") == 1 then
		arg1_175 = string.gsub(arg1_175, "^FurnitureSlots/", "", 1)
		var0_175 = arg0_175.slotRoot:Find(arg1_175)
	end

	if not var0_175 then
		warning(string.format("Missing scene item path: %s", arg1_175))
	end

	return var0_175
end

function var0_0.SetIKStatus(arg0_176, arg1_176, arg2_176, arg3_176)
	warning("Set IKStatus " .. (arg2_176.id or "NIL"))

	arg0_176.enableIKTip = true

	arg0_176:ResetIKTipTimer()
	setActive(arg1_176.ladyCollider, false)
	_.each(arg1_176.ladyTouchColliders, function(arg0_177)
		setActive(arg0_177, true)
	end)

	arg0_176.blockIK = nil
	arg1_176.ikActionDict = {}
	arg1_176.readyIKLayers = {}
	arg1_176.IKSettings = {
		Colliders = arg1_176.ladyColliders,
		CameraRaycaster = arg0_176.sceneRaycaster
	}

	local var0_176 = _.map(arg2_176.ik_id, function(arg0_178)
		local var0_178 = Dorm3dIK.New({
			configId = arg0_178[1]
		})
		local var1_178 = arg0_178[3]
		local var2_178 = var1_178[1]
		local var3_178 = switch(var2_178, {
			function(arg0_179, arg1_179)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_181, arg1_181)
				return arg0_181
			end,
			function(arg0_182, arg1_182)
				return arg0_182
			end,
			function(arg0_183, arg1_183, arg2_183, arg3_183)
				return arg0_183
			end,
			function(arg0_184)
				return 0
			end
		}, function(arg0_185)
			return var2_178(arg0_185) == "number" and arg0_185 or 0
		end, unpack(var1_178, 2))

		table.insert(arg1_176.readyIKLayers, var0_178)

		arg1_176.ikActionDict[var0_178:GetControllerPath()] = var1_178

		local var4_178 = var0_178:GetSubTargets()
		local var5_178 = var0_178:GetPlaneRotations()
		local var6_178 = var0_178:GetPlaneScales()
		local var7_178 = _.map(_.range(#var4_178), function(arg0_186)
			return {
				name = var4_178[arg0_186][1],
				planeRot = var5_178[arg0_186],
				planeScale = var6_178[arg0_186]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_178:getConfig("trigger_param")[2],
			controllerName = var0_178:GetControllerPath(),
			subTargets = var7_178,
			actionType = var0_178:GetActionTriggerParams()[1],
			controlRect = var0_178:GetRect(),
			actionRect = var0_178:GetTriggerRect(),
			backTime = var0_178:GetRevertTime(),
			actionRevertTime = var3_178
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_176.ladyIKRoot, arg1_176.ladyBoneMaps)
	arg0_176:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var0_176)

	local var1_176 = _.map(arg2_176.touch_data, function(arg0_187)
		return arg0_187[1]
	end)

	table.Foreach(var1_176, function(arg0_188, arg1_188)
		local var0_188 = pg.dorm3d_ik_touch[arg1_188]

		if #var0_188.scene_item == 0 then
			return
		end

		local var1_188 = arg0_176:GetSceneItem(var0_188.scene_item)

		if not var1_188 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_188, var0_188.scene_item))

			return
		end

		if IsNil(GetComponent(var1_188, typeof(UnityEngine.Collider))) then
			go(var1_188):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_188 = GetOrAddComponent(var1_188, typeof(EventTriggerListener))

		var2_188.enabled = true

		var2_188:AddPointClickFunc(function()
			arg0_176.blockIK = true

			local var0_189 = arg2_176.touch_data[arg0_188]
			local var1_189, var2_189, var3_189 = unpack(var0_189)

			arg0_176:TouchModePointAction(arg1_176, var1_189, unpack(var3_189))(function()
				arg0_176.enableIKTip = true

				arg0_176:ResetIKTipTimer()

				arg0_176.blockIK = nil
			end)
		end)
	end)

	arg0_176.camBrain.enabled = false

	if arg0_176.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_176.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_176.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var2_176 = arg0_176.cameraRoot:Find(arg2_176.ik_camera)

	assert(var2_176, "Missing IKCamera")

	arg0_176.cameras[var0_0.CAMERA.IK_WATCH] = var2_176

	arg0_176:ActiveCamera(arg0_176.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_176.camBrain.enabled = true

	local var3_176 = var2_176:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var3_176 then
		arg0_176:RegisterOrbits(var3_176)
	end

	arg0_176:SwitchAnim(arg1_176, arg2_176.character_action)
	arg0_176:SettingHeadAimIK(arg1_176, arg2_176.head_track)
	arg0_176:EnableCloth(arg1_176, false)
	arg0_176:EnableCloth(arg1_176, arg2_176.use_cloth, arg2_176.cloth_colliders)
	;(function()
		local var0_191 = arg2_176.enter_scene_anim
		local var1_191 = {}

		if var0_191 and #var0_191 > 0 then
			table.Ipairs(var0_191, function(arg0_192, arg1_192)
				arg0_176:PlaySceneItemAnim(arg1_192[1], arg1_192[2])
				table.insert(var1_191, arg1_192[1])
			end)
		end

		arg0_176:ResetSceneItemAnimators(var1_191)
	end)()
	;(function()
		local var0_193 = arg2_176.enter_extra_item
		local var1_193 = {}

		if var0_193 and #var0_193 > 0 then
			table.Ipairs(var0_193, function(arg0_194, arg1_194)
				local var0_194 = arg1_194[3] and Vector3.New(unpack(arg1_194[3]))
				local var1_194 = arg1_194[4] and Quaternion.Euler(unpack(arg1_194[4]))

				arg0_176:LoadCharacterExtraItem(arg1_176, arg1_194[1], arg1_194[2], var0_194, var1_194)
				table.insert(var1_193, arg1_194[1])
			end)
		end

		arg0_176:ResetCharacterExtraItem(arg1_176, var1_193)
	end)()
	eachChild(arg0_176.ikTextTipsRoot, function(arg0_195)
		setActive(arg0_195, false)
	end)
	_.each(arg1_176.readyIKLayers, function(arg0_196)
		local var0_196 = arg0_196:getConfig("tip_text")

		if not var0_196 or #var0_196 == 0 then
			return
		end

		local var1_196 = arg0_176.ikTextTipsRoot:Find(var0_196)

		if not IsNil(var1_196) then
			setActive(var1_196, true)
		end
	end)
	onNextTick(function()
		local var0_197 = arg0_176.furnitures:Find(arg2_176.character_position)

		arg1_176.lady.position = var0_197:Find("StayPoint").position
		arg1_176.lady.rotation = var0_197:Find("StayPoint").rotation

		existCall(arg3_176)
	end)
end

function var0_0.ExitIKStatus(arg0_198, arg1_198, arg2_198, arg3_198)
	arg0_198.enableIKTip = false

	setActive(arg1_198.ladyCollider, true)
	_.each(arg1_198.ladyTouchColliders, function(arg0_199)
		setActive(arg0_199, false)
	end)

	arg0_198.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_198.ikActionDict = nil
	arg1_198.readyIKLayers = nil

	setActive(arg0_198:GetIKTipsRootTF(), false)

	local var0_198 = _.map(arg2_198.touch_data or {}, function(arg0_200)
		return arg0_200[1]
	end)

	table.Foreach(var0_198, function(arg0_201, arg1_201)
		local var0_201 = pg.dorm3d_ik_touch[arg1_201]

		if #var0_201.scene_item == 0 then
			return
		end

		local var1_201 = arg0_198.modelRoot:Find(var0_201.scene_item)

		if not var1_201 then
			return
		end

		local var2_201 = GetOrAddComponent(var1_201, typeof(EventTriggerListener))

		var2_201:ClearEvents()

		var2_201.enabled = false
	end)
	arg0_198:RevertCameraOrbit()
	setActive(arg0_198.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_198.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_198:EnableCloth(arg1_198, false)
	arg0_198:ResetHeadAimIK(arg1_198)
	arg0_198:SwitchAnim(arg1_198, arg2_198.character_action)
	arg0_198:ResetSceneItemAnimators()
	arg0_198:ResetCharacterExtraItem(arg1_198)
	onNextTick(function()
		if arg2_198.character_position then
			arg1_198.ladyActiveZone = arg2_198.character_position
		else
			arg1_198.ladyActiveZone = arg1_198.ladyBaseZone
		end

		arg0_198:ChangeCharacterPosition(arg1_198)
		arg0_198:TriggerLadyDistance()
		arg0_198:CheckInSector()
		existCall(arg3_198)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_203, arg1_203, arg2_203, arg3_203, arg4_203, arg5_203)
	warning("Set IKStatus " .. (arg3_203 or "NIL"))

	arg0_203.enableIKTip = true

	arg0_203:ResetIKTipTimer()

	arg0_203.blockIK = nil

	local var0_203 = pg.dorm3d_ik_timeline_status[arg3_203]

	arg1_203.readyIKLayers = {}
	arg1_203.IKSettings = {
		CameraRaycaster = arg4_203:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_203.IKSettings.CameraRaycaster)

	local var1_203 = {}

	table.IpairsCArray(arg2_203:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_204, arg1_204)
		if arg1_204:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_204)

		local var0_204 = child.name
		local var1_204 = var0_204 and string.find(var0_204, "Collider") or -1

		if var1_204 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_204)

			return
		end

		local var2_204 = string.sub(var0_204, 1, var1_204 - 1)

		if var2_204 == "Body" then
			setActive(child, false)

			return
		end

		if var0_0.BONE_TO_TOUCH[var2_204] == nil then
			return
		end

		var1_203[var2_204] = child

		setActive(child, true)
	end)

	arg1_203.IKSettings.Colliders = var1_203
	arg1_203.ikTimelineMode = true

	local var2_203 = _.map(var0_203.ik_id, function(arg0_205)
		local var0_205 = Dorm3dIK.New({
			configId = arg0_205
		})

		table.insert(arg1_203.readyIKLayers, var0_205)

		local var1_205 = var0_205:GetSubTargets()
		local var2_205 = var0_205:GetPlaneRotations()
		local var3_205 = var0_205:GetPlaneScales()
		local var4_205 = _.map(_.range(#var1_205), function(arg0_206)
			return {
				name = var1_205[arg0_206][1],
				planeRot = var2_205[arg0_206],
				planeScale = var3_205[arg0_206]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_205:getConfig("trigger_param")[2],
			controllerName = var0_205:GetControllerPath(),
			subTargets = var4_205,
			actionType = var0_205:GetActionTriggerParams()[1],
			controlRect = var0_205:GetRect(),
			actionRect = var0_205:GetTriggerRect(),
			backTime = var0_205:GetRevertTime(),
			actionRevertTime = var0_205:GetActionRevertTime(),
			timelineActionEvent = var0_205:GetTimelineAction()
		})
	end)
	local var3_203 = arg2_203.transform:Find("IKLayers")
	local var4_203 = {}
	local var5_203 = {}

	table.Foreach(var1_0, function(arg0_207, arg1_207)
		var5_203[arg1_207] = arg0_207
	end)

	local var6_203 = arg2_203.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var6_203, function(arg0_208, arg1_208)
		if var5_203[arg1_208.name] then
			var4_203[var5_203[arg1_208.name]] = arg1_208
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var3_203, var4_203)
	arg0_203:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_203)
	existCall(arg5_203)
end

function var0_0.ExitIKTimelineStatus(arg0_209, arg1_209, arg2_209)
	arg0_209.enableIKTip = false
	arg0_209.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_209.readyIKLayers = nil
	arg1_209.IKSettings = nil

	setActive(arg0_209:GetIKTipsRootTF(), false)
	existCall(arg2_209)
end

function var0_0.EnableIKLayer(arg0_210, arg1_210)
	local var0_210 = arg0_210.ladyDict[arg0_210.apartment:GetConfigID()]

	if #arg1_210:GetHeadTrackPath() > 0 then
		arg0_210:SettingHeadAimIK(var0_210, {
			2,
			arg1_210:GetHeadTrackPath()
		}, true)
	end

	local var1_210 = arg1_210:GetTriggerFaceAnim()

	if #var1_210 > 0 then
		arg0_210:PlayFaceAnim(var0_210, var1_210)
	end

	setActive(arg0_210:GetIKHandTF(), true)
	eachChild(arg0_210:GetIKHandTF(), function(arg0_211)
		setActive(arg0_211, false)
	end)
	arg0_210:StopIKHandTimer()
	setActive(arg0_210:GetIKHandTF():Find("Begin"), true)

	arg0_210.ikHandTimer = Timer.New(function()
		setActive(arg0_210:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_210:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg0_210.ikHandTimer:Start()

	if not var0_210.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_210.apartment.configId, arg0_210.apartment.level, var0_210.ikConfig.character_action, arg1_210:GetTriggerParams()[2], arg0_210.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_213, arg1_213)
	local var0_213 = arg0_213.ladyDict[arg0_213.apartment:GetConfigID()]

	if not var0_213.ikTimelineMode and #arg1_213:GetHeadTrackPath() > 0 then
		arg0_213:SettingHeadAimIK(var0_213, var0_213.ikConfig.head_track)
	end

	arg0_213:StopIKHandTimer()
	setActive(arg0_213:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_213:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_213:GetIKHandTF():Find("End"), true)

	arg0_213.ikHandTimer = Timer.New(function()
		setActive(arg0_213:GetIKHandTF():Find("End"), false)
		setActive(arg0_213:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_213.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_215)
	if not arg0_215.ikHandTimer then
		return
	end

	arg0_215.ikHandTimer:Stop()

	arg0_215.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_216, arg1_216, arg2_216, arg3_216)
	local var0_216 = Time.time

	function arg0_216.ikRevertHandler()
		local var0_217 = Time.time - var0_216

		_.each(arg1_216.activeIKLayers, function(arg0_218)
			local var0_218 = 1

			if arg2_216 > 0 then
				var0_218 = var0_217 / arg2_216
			end

			local var1_218 = arg1_216.cacheIKInfos[arg0_218].solvers
			local var2_218 = arg1_216.cacheIKInfos[arg0_218].weights

			table.Foreach(var1_218, function(arg0_219, arg1_219)
				arg1_219.IKPositionWeight = math.lerp(var2_218[arg0_219], 0, var0_218)
			end)
		end)

		if var0_217 >= arg2_216 then
			arg0_216:ResetActiveIKs(arg1_216)

			arg0_216.ikRevertHandler = nil

			existCall(arg3_216)
		end
	end

	arg0_216.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_220, arg1_220)
	table.insertto(arg0_220.activeIKLayers, _.keys(arg0_220.holdingStatus))
	table.clear(arg0_220.holdingStatus)
	_.each(arg1_220.activeIKLayers, function(arg0_221)
		local var0_221 = arg0_221:GetControllerPath()
		local var1_221 = arg1_220.ladyIKRoot:Find(var0_221):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_221, false)

		local var2_221 = arg1_220.cacheIKInfos[arg0_221].solvers
		local var3_221 = arg1_220.cacheIKInfos[arg0_221].weights

		table.Foreach(var2_221, function(arg0_222, arg1_222)
			arg1_222.IKPositionWeight = var3_221[arg0_222]
		end)
	end)
	table.clear(arg1_220.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_223)
	if not arg0_223.enableIKTip then
		return
	end

	arg0_223.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_224, arg1_224)
	local var0_224 = arg0_224.ladyDict[arg0_224.apartment:GetConfigID()]

	arg0_224:EnableHeadIK(var0_224, arg1_224)
end

function var0_0.EnableHeadIK(arg0_225, arg1_225, arg2_225)
	arg1_225.ladyHeadIKComp.enableIk = arg2_225
end

function var0_0.SettingHeadAimIK(arg0_226, arg1_226, arg2_226, arg3_226)
	local var0_226

	if arg2_226[1] == 1 then
		var0_226 = arg0_226.mainCameraTF:Find("AimTarget")
	elseif arg2_226[1] == 2 then
		table.IpairsCArray(arg1_226.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_227, arg1_227)
			if arg1_227.name ~= arg2_226[2] then
				return
			end

			var0_226 = arg1_227
		end)
	end

	arg1_226.ladyHeadIKComp.AimTarget = var0_226

	if not arg3_226 and arg2_226[3] then
		arg1_226.ladyHeadIKComp.BodyWeight = arg2_226[3]
	end

	if not arg3_226 and arg2_226[4] then
		arg1_226.ladyHeadIKComp.HeadWeight = arg2_226[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_228, arg1_228)
	arg1_228.ladyHeadIKComp.AimTarget = arg0_228.mainCameraTF:Find("AimTarget")
	arg1_228.ladyHeadIKComp.HeadWeight = arg1_228.ladyHeadIKData.HeadWeight
	arg1_228.ladyHeadIKComp.BodyWeight = arg1_228.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_229, arg1_229)
	for iter0_229, iter1_229 in pairs(arg0_229.ladyDict) do
		if iter0_229 ~= arg1_229 then
			arg0_229:HideCharacterBylayer(iter1_229)
		end
	end
end

function var0_0.RevertCharacter(arg0_230, arg1_230)
	for iter0_230, iter1_230 in pairs(arg0_230.ladyDict) do
		if iter0_230 ~= arg1_230 then
			arg0_230:RevertCharacterBylayer(iter1_230)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_231, arg1_231)
	local var0_231 = "Bip001"
	local var1_231 = arg1_231.lady:Find("all")

	for iter0_231 = 0, var1_231.childCount - 1 do
		local var2_231 = var1_231:GetChild(iter0_231)

		if var2_231.name ~= var0_231 then
			pg.ViewUtils.SetLayer(var2_231, Layer.Environment3D)
		end
	end

	if arg1_231.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_231.tfPendintItem, Layer.Environment3D)
	end

	if arg1_231.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_231.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg1_231.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_232, arg1_232)
	local var0_232 = "Bip001"
	local var1_232 = arg1_232.lady:Find("all")

	for iter0_232 = 0, var1_232.childCount - 1 do
		local var2_232 = var1_232:GetChild(iter0_232)

		if var2_232.name ~= var0_232 then
			pg.ViewUtils.SetLayer(var2_232, Layer.Default)
		end
	end

	if arg1_232.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_232.tfPendintItem, Layer.Default)
	end

	if arg1_232.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_232.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg1_232.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_233)
	arg0_233:SetAllBlackbloardValue("inLockLayer", true)
	arg0_233:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_234)
	arg0_234:HideFurnitureSlots()

	local var0_234 = arg0_234.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_235)
			arg0_234:emit(var0_0.SHOW_BLOCK)
			arg0_234:ShowBlackScreen(true, arg0_235)
		end,
		function(arg0_236)
			arg0_234:RevertCharacter()
			arg0_234:SetAllBlackbloardValue("inLockLayer", false)
			arg0_234:RegisterCameraBlendFinished(var0_234, arg0_236)
			arg0_234:ActiveCamera(var0_234)
		end,
		function(arg0_237)
			arg0_234:ShowBlackScreen(false, arg0_237)
		end
	}, function()
		arg0_234:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_234:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_239, arg1_239)
	local var0_239 = arg0_239:GetFurnitureByName(arg1_239:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_239.cameraFurnitureWatch and arg0_239.cameraFurnitureWatch ~= var0_239 then
		arg0_239:UnRegisterCameraBlendFinished(arg0_239.cameraFurnitureWatch)
		setActive(arg0_239.cameraFurnitureWatch, false)
	end

	arg0_239.cameraFurnitureWatch = var0_239
	arg0_239.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_239.cameraFurnitureWatch

	arg0_239:RegisterCameraBlendFinished(arg0_239.cameraFurnitureWatch, function()
		arg0_239:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_239:emit(var0_0.SHOW_BLOCK)
	arg0_239:ActiveCamera(arg0_239.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_241)
	if arg0_241.displaySlots then
		arg0_241:UpdateDisplaySlots({})
		table.Foreach(arg0_241.displaySlots, function(arg0_242, arg1_242)
			local var0_242 = arg1_242.trans

			if IsNil(var0_242:Find("Selector")) then
				return
			end

			setActive(var0_242:Find("Selector"), false)
		end)

		arg0_241.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_243, arg1_243)
	arg0_243:HideFurnitureSlots()

	arg0_243.displaySlots = {}

	_.each(arg1_243, function(arg0_244)
		arg0_243.displaySlots[arg0_244] = arg0_243.slotDict[arg0_244]

		if not arg0_243.displaySlots[arg0_244] then
			errorMsg("Slot " .. arg0_244 .. " Not Binding Scene Object")

			return
		end

		local var0_244 = arg0_243.displaySlots[arg0_244].trans

		if var0_244:Find("Selector") then
			setActive(var0_244:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_245, arg1_245)
	table.Foreach(arg0_245.displaySlots, function(arg0_246, arg1_246)
		local var0_246 = arg1_246.trans

		if not IsNil(var0_246:Find("Selector")) then
			setActive(var0_246:Find("Selector/Normal"), arg1_245[arg0_246] == 0)
			setActive(var0_246:Find("Selector/Active"), arg1_245[arg0_246] == 1)
			setActive(var0_246:Find("Selector/Ban"), arg1_245[arg0_246] == 2)
		end

		local var1_246 = arg0_245.slotDict[arg0_246].model
		local var2_246 = arg0_245.slotDict[arg0_246].displayModelName

		if var2_246 and var2_246 ~= "" then
			var1_246 = var0_246:GetChild(var0_246.childCount - 1)
		end

		local function var3_246(arg0_247, arg1_247)
			local var0_247 = arg0_247:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_247, function(arg0_248, arg1_248)
				local var0_248 = arg1_248.material

				if var0_248 and var0_248:HasProperty("_FinalTint") then
					var0_248:SetColor("_FinalTint", arg1_247)
				end
			end)
		end

		if var1_246 then
			if arg1_245[arg0_246] == 1 then
				var3_246(var1_246, Color.NewHex("3F83AE73"))
			else
				var3_246(var1_246, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_249, arg1_249, arg2_249)
	arg0_249:SetAllBlackbloardValue("inLockLayer", true)
	arg0_249:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_250)
			arg0_249:TempHideUI(true, arg0_250)
		end,
		function(arg0_251)
			arg0_249:ShowBlackScreen(true, arg0_251)
		end,
		function(arg0_252)
			local var0_252 = arg0_249.apartment:GetConfigID()
			local var1_252 = arg0_249.ladyDict[var0_252]

			arg0_249:SwitchAnim(var1_252, arg2_249)
			var1_252.ladyAnimator:Update(0)
			var1_252:ResetCharPoint(var1_252, arg1_249:GetWatchCameraName())
			arg0_249:SyncInterestTransform(var1_252)
			setActive(var1_252.ladySafeCollider, true)
			arg0_249:HideCharacter(var0_252)

			local var2_252 = arg0_249.cameras[var0_0.CAMERA.PHOTO]
			local var3_252 = var2_252.m_XAxis

			var3_252.Value = 180
			var2_252.m_XAxis = var3_252

			local var4_252 = var2_252.m_YAxis

			var4_252.Value = 0.7
			var2_252.m_YAxis = var4_252
			arg0_249.pinchValue = 1

			arg0_249:RegisterOrbits(arg0_249.cameras[var0_0.CAMERA.PHOTO])
			arg0_249:SetCameraObrits()
			arg0_249:RegisterCameraBlendFinished(var2_252, arg0_252)
			arg0_249:ActiveCamera(var2_252)
		end,
		function(arg0_253)
			arg0_249:ShowBlackScreen(false, arg0_253)
		end
	}, function()
		arg0_249:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_255)
	arg0_255:emit(var0_0.SHOW_BLOCK)
	arg0_255:EnableJoystick(false)
	seriesAsync({
		function(arg0_256)
			arg0_255:ShowBlackScreen(true, arg0_256)
		end,
		function(arg0_257)
			arg0_255:RevertCameraOrbit()

			local var0_257 = arg0_255.ladyDict[arg0_255.apartment:GetConfigID()]

			arg0_255:SwitchAnim(var0_257, var0_0.ANIM.IDLE)
			setActive(var0_257.ladySafeCollider, false)
			onNextTick(function()
				arg0_255:ChangeCharacterPosition(var0_257)
			end)

			if arg0_255.contextData.photoFreeMode then
				arg0_255:EnablePOVLayer(false)
				setActive(arg0_255.restrictedBox, false)

				arg0_255.contextData.photoFreeMode = nil
			end

			local var1_257 = arg0_255.cameras[var0_0.CAMERA.POV]

			arg0_255:RegisterCameraBlendFinished(var1_257, arg0_257)
			arg0_255:ActiveCamera(var1_257)
		end,
		function(arg0_259)
			arg0_255:RevertCharacter(arg0_255.apartment:GetConfigID())
			arg0_255:ShowBlackScreen(false, arg0_259)
		end
	}, function()
		arg0_255:RefreshSlots()
		arg0_255:SetAllBlackbloardValue("inLockLayer", false)
		arg0_255:emit(var0_0.HIDE_BLOCK)
		arg0_255:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_255:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_261, arg1_261, arg2_261, arg3_261)
	arg0_261:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_262)
			arg0_261:ShowBlackScreen(true, arg0_262)
		end,
		function(arg0_263)
			local var0_263 = arg0_261.ladyDict[arg0_261.apartment:GetConfigID()]

			arg0_261:SwitchAnim(var0_263, arg2_261)
			onNextTick(function()
				arg0_261:ResetCharPoint(var0_263, arg1_261:GetWatchCameraName())
				arg0_261:SyncInterestTransform(var0_263)

				if arg0_261.contextData.photoFreeMode then
					arg0_261.camBrain.enabled = false

					arg0_261:SwitchPhotoCamera()

					arg0_261.camBrain.enabled = true

					onDelayTick(function()
						arg0_261.camBrain.enabled = false

						arg0_261:SwitchPhotoCamera()

						arg0_261.camBrain.enabled = true
					end, 0.1)
				end

				arg0_263()
			end)
		end,
		function(arg0_266)
			arg0_261:ShowBlackScreen(false, arg0_266)
		end
	}, function()
		arg0_261:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_261)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_268)
	if not arg0_268.contextData.photoFreeMode then
		arg0_268:EnableJoystick(false)
		arg0_268:EnablePOVLayer(true)
		setActive(arg0_268.restrictedBox, true)

		local var0_268 = arg0_268.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_268.transform.position = arg0_268.mainCameraTF.position

		local var1_268 = arg0_268.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_268 = arg0_268.mainCameraTF.rotation:ToEulerAngles()
		local var3_268 = var1_268.m_HorizontalAxis

		var3_268.Value = var2_268.y
		var1_268.m_HorizontalAxis = var3_268

		local var4_268 = var1_268.m_VerticalAxis

		var4_268.Value = arg0_268:GetNearestAngle(var2_268.x, var4_268.m_MinValue, var4_268.m_MaxValue)
		var1_268.m_VerticalAxis = var4_268

		local var5_268 = math.InverseLerp(arg0_268.restrictedHeightRange[1], arg0_268.restrictedHeightRange[2], var0_268.position.y)

		arg0_268:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_268)
		arg0_268:ActiveCamera(arg0_268.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_268:EnableJoystick(true)
		arg0_268:EnablePOVLayer(false)
		setActive(arg0_268.restrictedBox, false)
		arg0_268:ActiveCamera(arg0_268.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_268.contextData.photoFreeMode = not arg0_268.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_269, arg1_269)
	local var0_269 = math.lerp(arg0_269.restrictedHeightRange[1], arg0_269.restrictedHeightRange[2], arg1_269)
	local var1_269 = arg0_269.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_269:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_269 - var1_269.position.y, 0))
	onNextTick(function()
		local var0_270 = math.InverseLerp(arg0_269.restrictedHeightRange[1], arg0_269.restrictedHeightRange[2], var1_269.position.y)

		arg0_269:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_270)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_271)
	local var0_271 = arg0_271.cameras[var0_0.CAMERA.PHOTO]
	local var1_271 = var0_271.m_XAxis

	var1_271.Value = 180
	var0_271.m_XAxis = var1_271

	local var2_271 = var0_271.m_YAxis

	var2_271.Value = 0.7
	var0_271.m_YAxis = var2_271
end

function var0_0.ResetCurrentCharPoint(arg0_272, arg1_272)
	local var0_272 = arg0_272.ladyDict[arg0_272.apartment:GetConfigID()]

	arg0_272:ResetCharPoint(var0_272, arg1_272)
end

function var0_0.ResetCharPoint(arg0_273, arg1_273, arg2_273)
	local var0_273 = arg0_273.furnitures:Find(arg2_273 .. "/StayPoint")

	arg1_273.lady.position = var0_273.position
	arg1_273.lady.rotation = var0_273.rotation
end

function var0_0.GetNearestAngle(arg0_274, arg1_274, arg2_274, arg3_274)
	if arg3_274 < arg2_274 then
		arg3_274 = arg3_274 + 360
	end

	if arg2_274 <= arg1_274 and arg1_274 <= arg3_274 then
		return arg1_274
	end

	local var0_274 = (arg2_274 + arg3_274) / 2

	arg1_274 = var0_274 - Mathf.DeltaAngle(arg1_274, var0_274)
	arg1_274 = math.clamp(arg1_274, arg2_274, arg3_274)

	return arg1_274
end

function var0_0.PlayTimeline(arg0_275, arg1_275, arg2_275)
	local var0_275 = {}

	if arg0_275.waitForTimeline then
		table.insert(var0_275, function(arg0_276)
			local var0_276 = arg0_275.waitForTimeline

			arg0_275.waitForTimeline = nil

			var0_276()
			arg0_276()
		end)
	end

	table.insert(var0_275, function(arg0_277)
		arg0_275:LoadTimelineScene(arg1_275.name, false, arg0_277)
	end)

	if arg1_275.scene and arg1_275.sceneRoot then
		table.insert(var0_275, function(arg0_278)
			arg0_275:ChangeArtScene(arg1_275.scene .. "|" .. arg1_275.sceneRoot, arg0_278)
		end)
	end

	table.insert(var0_275, function(arg0_279)
		local var0_279 = GameObject.Find("[actor]").transform
		local var1_279 = var0_279:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_279, function(arg0_280, arg1_280)
			GetOrAddComponent(arg1_280.transform, typeof(DftAniEvent))
		end)

		local var2_279 = var0_279:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_279 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera)).transform
		local var4_279 = GameObject.Find("[sequence]").transform

		arg0_275.nowTimelinePlayer = TimelinePlayer.New(var4_279)

		arg0_275.nowTimelinePlayer:Register(arg1_275.time, function(arg0_281, arg1_281, arg2_281)
			switch(arg1_281.stringParameter, {
				TimelinePause = function()
					arg0_281:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_281:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_281.intParameter == 0 or arg1_281.intParameter == arg2_281.selectIndex then
						arg0_281:SetTime(arg1_281.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_281.selectIndex = nil

					if arg1_275.options then
						local var0_285 = arg1_275.options[arg1_281.intParameter]

						arg0_275:DoTimelineOption(var0_285, function(arg0_286)
							arg2_281.selectIndex = arg0_286
							arg2_281.optionIndex = var0_285[arg0_286].flag

							arg0_281:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_281.selectIndex = nil

					if arg1_275.touchs then
						local var0_287 = arg1_275.touchs[arg1_281.intParameter]

						arg0_275:DoTimelineTouch(arg1_275.touchs[arg1_281.intParameter], function(arg0_288)
							arg2_281.selectIndex = arg0_288
							arg2_281.optionIndex = var0_287[arg0_288].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_281.selectIndex then
						arg0_281:RawSetTime(arg1_281.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_281.selectIndex = arg1_281.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_275.canTriggerAccompanyPerformance then
						arg0_275.canTriggerAccompanyPerformance = false

						local var0_291 = arg1_275.accompanys[arg1_281.intParameter]
						local var1_291 = var0_291[math.random(#var0_291)]

						arg0_281:SetTime(var1_291)
					end
				end,
				TimelineIKStart = function()
					local var0_292 = arg1_281.intParameter
					local var1_292 = arg0_275.ladyDict[arg0_275.apartment:GetConfigID()]

					arg0_275:SetIKTimelineStatus(var1_292, var2_279.gameObject, var0_292, var3_279)
				end,
				TimelineEnd = function()
					arg2_281.finish = true

					arg0_281:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_281.stringParameter)
			end)

			if arg2_281.finish then
				arg0_275.timelineMark = arg2_281
				arg0_275.timelineFinishCall = nil

				local var0_281 = arg0_275.ladyDict[arg0_275.apartment:GetConfigID()]

				if var0_281.ikTimelineMode then
					arg0_275:ExitIKTimelineStatus(var0_281)
				end

				arg0_279()
			end
		end)

		function arg0_275.timelineFinishCall()
			arg0_275.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_275:HideCharacter()
		setActive(arg0_275.mainCameraTF, false)
		eachChild(arg0_275.rtTimelineScreen, function(arg0_296)
			setActive(arg0_296, false)
		end)
		setActive(arg0_275.rtTimelineScreen, true)
		setActive(arg0_275.rtTimelineScreen:Find("btn_skip"), arg0_275.inReplayTalk)
		arg0_275.nowTimelinePlayer:Start()
	end)
	table.insert(var0_275, function(arg0_297)
		arg0_275:ShowBlackScreen(true, function()
			arg0_275.nowTimelinePlayer:Stop()
			arg0_275.nowTimelinePlayer:Dispose()

			arg0_275.nowTimelinePlayer = nil

			arg0_275:UnloadTimelineScene(arg1_275.name, false, arg0_297)
		end)
	end)

	local var1_275 = arg0_275.artSceneInfo

	table.insert(var0_275, function(arg0_299)
		arg0_275:ChangeArtScene(var1_275, arg0_299)
	end)
	seriesAsync(var0_275, function()
		setActive(arg0_275.rtTimelineScreen, false)
		arg0_275:RevertCharacter()
		setActive(arg0_275.mainCameraTF, true)

		local var0_300 = arg0_275.timelineMark

		arg0_275.timelineMark = nil

		existCall(arg2_275, var0_300, function(arg0_301)
			arg0_275:ShowBlackScreen(false, arg0_301)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_302, ...)
	local var0_302 = arg0_302.ladyDict[arg0_302.apartment:GetConfigID()]

	return arg0_302:PlaySingleAction(var0_302, ...)
end

function var0_0.PlaySingleAction(arg0_303, arg1_303, arg2_303, arg3_303)
	local var0_303 = string.find(arg2_303, "^Face_")

	if tobool(var0_303) then
		arg0_303:PlayFaceAnim(arg1_303, arg2_303, arg3_303)

		return
	end

	if arg1_303.ladyAnimator:GetCurrentAnimatorStateInfo(arg1_303.ladyAnimBaseLayerIndex):IsName(arg2_303) then
		return
	end

	existCall(arg1_303.animExtraItemCallback)

	arg1_303.animExtraItemCallback = nil
	arg1_303.animNameMap = arg1_303.animNameMap or {}
	arg1_303.animNameMap[arg1_303.ladyAnimator.StringToHash(arg2_303)] = arg2_303

	local var1_303 = arg0_303:GetBlackboardValue(arg1_303, "groupId")
	local var2_303 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var1_303] or {}, function(arg0_304)
		return pg.dorm3d_anim_extraitem[arg0_304].anim == arg2_303
	end)
	local var3_303 = var2_303 and pg.dorm3d_anim_extraitem[var2_303]
	local var4_303

	seriesAsync({
		function(arg0_305)
			if not var3_303 or var3_303.item_prefab == "" then
				arg0_305()

				return
			end

			local var0_305 = string.lower("dorm3d/furniture/item/" .. var3_303.item_prefab)

			arg0_303.loader:GetPrefab(var0_305, "", function(arg0_306)
				setParent(arg0_306, arg1_303.lady)

				if var3_303.item_shield ~= "" then
					var4_303 = {}

					for iter0_306, iter1_306 in ipairs(var3_303.item_shield) do
						local var0_306 = arg0_303.modelRoot:Find(iter1_306)

						if not var0_306 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var3_303.id, iter1_306))
						else
							var4_303[iter1_306] = isActive(var0_306)

							setActive(var0_306, false)
						end
					end
				end

				function arg1_303.animExtraItemCallback()
					arg0_303.loader:ClearRequest("AnimExtraItem")

					if var4_303 then
						for iter0_307, iter1_307 in pairs(var4_303) do
							setActive(arg0_303.modelRoot:Find(iter0_307), iter1_307)
						end
					end
				end

				arg0_305()
			end, "AnimExtraItem")
		end,
		function(arg0_308)
			arg1_303.nowState = arg2_303
			arg1_303.stateCallback = arg0_308

			arg1_303.ladyAnimator:CrossFadeInFixedTime(arg2_303, 0.25, arg1_303.ladyAnimBaseLayerIndex)
		end,
		function(arg0_309)
			arg1_303.nowState = nil
			arg1_303.stateCallback = nil

			existCall(arg1_303.animExtraItemCallback)

			arg1_303.animExtraItemCallback = nil

			arg0_309()
		end,
		arg3_303
	})
end

function var0_0.SwitchCurrentAnim(arg0_310, ...)
	local var0_310 = arg0_310.ladyDict[arg0_310.apartment:GetConfigID()]

	return arg0_310:SwitchAnim(var0_310, ...)
end

function var0_0.SwitchAnim(arg0_311, arg1_311, arg2_311, arg3_311)
	local var0_311 = string.find(arg2_311, "^Face_")

	if tobool(var0_311) then
		arg0_311:PlayFaceAnim(arg1_311, arg2_311, arg3_311)

		return
	end

	existCall(arg1_311.animExtraItemCallback)

	arg1_311.animExtraItemCallback = nil
	arg1_311.animNameMap = arg1_311.animNameMap or {}
	arg1_311.animNameMap[arg1_311.ladyAnimator.StringToHash(arg2_311)] = arg2_311

	local var1_311 = {}

	table.insert(var1_311, function(arg0_312)
		arg1_311.nowState = arg2_311
		arg1_311.stateCallback = arg0_312

		arg1_311.ladyAnimator:PlayInFixedTime(arg2_311, arg1_311.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_311, function(arg0_313)
		arg1_311.nowState = nil
		arg1_311.stateCallback = nil

		arg0_313()
	end)
	seriesAsync(var1_311, arg3_311)
end

function var0_0.PlayFaceAnim(arg0_314, arg1_314, arg2_314, arg3_314)
	arg1_314.ladyAnimator:CrossFadeInFixedTime(arg2_314, 0.2, arg1_314.ladyAnimFaceLayerIndex)
	existCall(arg3_314)
end

function var0_0.GetCurrentAnim(arg0_315)
	local var0_315 = arg0_315.ladyDict[arg0_315.apartment:GetConfigID()]
	local var1_315 = var0_315.ladyAnimator:GetCurrentAnimatorStateInfo(var0_315.ladyAnimBaseLayerIndex).shortNameHash

	return var0_315.animNameMap[var1_315]
end

function var0_0.RegisterAnimCallback(arg0_316, arg1_316, arg2_316)
	arg0_316.ladyDict[arg0_316.apartment:GetConfigID()].animCallbacks[arg1_316] = arg2_316
end

function var0_0.SetCharacterAnimSpeed(arg0_317, arg1_317)
	local var0_317 = arg0_317.ladyDict[arg0_317.apartment:GetConfigID()]

	var0_317.ladyAnimator.speed = arg1_317
	var0_317.ladyHeadIKComp.blinkSpeed = var0_317.ladyHeadIKData.blinkSpeed * arg1_317

	if arg1_317 > 0 then
		var0_317.ladyHeadIKComp.DampTime = var0_317.ladyHeadIKData.DampTime / arg1_317
	else
		var0_317.ladyHeadIKComp.DampTime = var0_317.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_318, arg1_318)
	if arg1_318.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_318 = arg1_318.stringParameter
	local var1_318 = table.removebykey(arg0_318.animEventCallbacks, var0_318)

	existCall(var1_318)
end

function var0_0.RegisterAnimEventCallback(arg0_319, arg1_319, arg2_319)
	arg0_319.animEventCallbacks[arg1_319] = arg2_319
end

function var0_0.PlaySceneItemAnim(arg0_320, arg1_320, arg2_320)
	arg0_320.sceneAnimatorDict = arg0_320.sceneAnimatorDict or {}

	if not arg0_320.sceneAnimatorDict[arg1_320] then
		local var0_320 = pg.dorm3d_scene_animator[arg1_320]
		local var1_320 = arg0_320:GetSceneItem(var0_320.item_name)

		assert(var1_320, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_320 .. " " .. var0_320.item_name)

		if not var1_320 then
			return
		end

		local var2_320 = var1_320:GetComponent(typeof(Animator))

		if not var2_320 then
			return
		end

		arg0_320.sceneAnimatorDict[arg1_320] = {
			trans = var1_320,
			animator = var2_320
		}
	end

	if arg0_320.sceneAnimatorDict[arg1_320].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_320) then
		return
	end

	arg0_320.sceneAnimatorDict[arg1_320].animator:PlayInFixedTime(arg2_320)
end

function var0_0.ResetSceneItemAnimators(arg0_321, arg1_321)
	if not arg0_321.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_321.sceneAnimatorDict, function(arg0_322, arg1_322)
		if arg1_321 and table.contains(arg1_321, arg0_322) then
			return
		end

		setActive(arg1_322.trans, false)
		setActive(arg1_322.trans, true)

		arg0_321.sceneAnimatorDict[arg0_322] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_323, arg1_323, arg2_323, arg3_323, arg4_323, arg5_323)
	arg1_323.extraItems = arg1_323.extraItems or {}

	if arg1_323.extraItems[arg2_323] then
		return
	end

	local var0_323

	if arg3_323 == "" then
		var0_323 = arg1_323.lady
	else
		table.IpairsCArray(arg1_323.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_324, arg1_324)
			if arg1_324.name == arg3_323 then
				var0_323 = arg1_324
			end
		end)
	end

	if not var0_323 then
		return
	end

	arg0_323.loader:GetPrefab(string.lower("dorm3d/" .. arg2_323), "", function(arg0_325)
		setParent(arg0_325, var0_323)

		if arg4_323 then
			setLocalPosition(arg0_325, arg4_323)
		end

		if arg5_323 then
			setLocalRotation(arg0_325, arg5_323)
		end

		arg1_323.extraItems[arg2_323] = {
			trans = arg0_325.transform,
			handler = var0_323
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_326, arg1_326, arg2_326)
	if not arg1_326.extraItems then
		return
	end

	table.Foreach(arg1_326.extraItems, function(arg0_327, arg1_327)
		if arg2_326 and table.contains(arg2_326, arg0_327) then
			return
		end

		arg0_326.loader:ReturnPrefab(arg1_327.trans.gameObject)

		arg1_326.extraItems[arg0_327] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_328, arg1_328, arg2_328)
	arg0_328.cameraBlendCallbacks[arg1_328] = arg2_328
end

function var0_0.UnRegisterCameraBlendFinished(arg0_329, arg1_329)
	arg0_329.cameraBlendCallbacks[arg1_329] = nil
end

function var0_0.OnCameraBlendFinished(arg0_330, arg1_330)
	if not arg1_330 then
		return
	end

	local var0_330 = table.removebykey(arg0_330.cameraBlendCallbacks, arg1_330)

	existCall(var0_330)
end

function var0_0.PlayHeartFX(arg0_331, arg1_331)
	local var0_331 = arg0_331.ladyDict[arg1_331]

	setActive(var0_331.effectHeart, false)
	setActive(var0_331.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_332, arg1_332)
	local var0_332 = arg1_332.name
	local var1_332 = arg0_332.expressionDict[var0_332]
	local var2_332 = 5

	if var1_332 then
		local var3_332 = var1_332.timer

		var3_332:Reset(nil, var2_332)
		var3_332:Start()

		if var1_332.instance then
			setActive(var1_332.instance, false)
			setActive(var1_332.instance, true)
		end

		return
	end

	local var4_332 = {
		name = var0_332,
		timer = Timer.New(function()
			arg0_332:RemoveExpression(var0_332)
		end, var2_332, 1, true)
	}

	arg0_332.expressionDict[var0_332] = var4_332

	arg0_332.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_332, var0_332, function(arg0_334)
		var4_332.instance = arg0_334

		onNextTick(function()
			local var0_335 = arg0_332.ladyDict[arg0_332.apartment:GetConfigID()]

			setParent(arg0_334, var0_335.ladyHeadCenter)
		end)
		setLocalPosition(arg0_334, Vector3(0, 0, -0.2))
		setActive(arg0_334, false)
		setActive(arg0_334, true)
	end, var4_332)
end

function var0_0.RemoveExpression(arg0_336, arg1_336)
	local var0_336 = arg0_336.expressionDict[arg1_336]

	if not var0_336 then
		return
	end

	arg0_336.loader:ClearRequest(var0_336)

	if var0_336.instance then
		arg0_336.loader:ReturnPrefab(var0_336.instance)
	end

	arg0_336.expressionDict[arg1_336] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_337, arg1_337, arg2_337)
	arg1_337.ladyWatchFloat = arg1_337.ladyWatchFloat or cloneTplTo(arg0_337.resTF:Find("vfx_talk_mark"), arg1_337.ladyHeadCenter)

	setActive(arg1_337.ladyWatchFloat, arg2_337)
end

function var0_0.RegisterGlobalVolume(arg0_338)
	local var0_338 = arg0_338.globalVolume
	local var1_338 = LuaHelper.GetOrAddVolumeComponent(var0_338, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_338 = LuaHelper.GetOrAddVolumeComponent(var0_338, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_338.originalCameraSettings = {
		depthOfField = {
			enabled = var1_338.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_338.gaussianStart.min,
				value = var1_338.gaussianStart.value
			},
			blurRadius = {
				min = var1_338.blurRadius.min,
				max = var1_338.blurRadius.max,
				value = var1_338.blurRadius.value
			}
		},
		postExposure = {
			value = var2_338.postExposure.value
		},
		contrast = {
			min = var2_338.contrast.min,
			max = var2_338.contrast.max,
			value = var2_338.contrast.value
		},
		saturate = {
			min = var2_338.saturation.min,
			max = var2_338.saturation.max,
			value = var2_338.saturation.value
		}
	}
	arg0_338.originalCameraSettings.depthOfField.enabled = true

	local var3_338 = var0_338:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_338.originalVolume = {
		profile = var3_338.sharedProfile,
		weight = var3_338.weight
	}
end

function var0_0.SettingCamera(arg0_339, arg1_339)
	arg0_339.activeCameraSettings = arg1_339

	local var0_339 = arg0_339.globalVolume
	local var1_339 = LuaHelper.GetOrAddVolumeComponent(var0_339, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_339 = LuaHelper.GetOrAddVolumeComponent(var0_339, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_339.enabled:Override(arg1_339.depthOfField.enabled)
	var1_339.gaussianStart:Override(arg1_339.depthOfField.focusDistance.value)
	var1_339.gaussianEnd:Override(arg1_339.depthOfField.focusDistance.value + arg1_339.depthOfField.focusDistance.length)
	var1_339.blurRadius:Override(arg1_339.depthOfField.blurRadius.value)
	var2_339.postExposure:Override(arg1_339.postExposure.value)
	var2_339.contrast:Override(arg1_339.contrast.value)
	var2_339.saturation:Override(arg1_339.saturate.value)
end

function var0_0.GetCameraSettings(arg0_340)
	return arg0_340.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_341)
	arg0_341:SettingCamera(arg0_341.originalCameraSettings)

	arg0_341.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_342, arg1_342, arg2_342)
	local var0_342 = arg0_342.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_342.activeProfileWeight = arg2_342

	if arg0_342.activeProfileName ~= arg1_342 then
		arg0_342.activeProfileName = arg1_342

		arg0_342.loader:LoadReference("dorm3d/scenesres/res/common", arg1_342, nil, function(arg0_343)
			var0_342.profile = arg0_343
			var0_342.weight = arg0_342.activeProfileWeight

			if arg0_342.activeCameraSettings then
				arg0_342:SettingCamera(arg0_342.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_342.weight = arg0_342.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_344)
	local var0_344 = arg0_344.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_344.profile = arg0_344.originalVolume.profile
	var0_344.weight = arg0_344.originalVolume.weight

	if arg0_344.activeCameraSettings then
		arg0_344:SettingCamera(arg0_344.activeCameraSettings)
	end

	arg0_344.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_345)
	local var0_345 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_345.originalCharacterColor = {
		color = var0_345.color,
		intensity = var0_345.intensity
	}
end

function var0_0.SetCharacterLight(arg0_346, arg1_346, arg2_346, arg3_346)
	local var0_346 = arg0_346.characterLight:GetComponent(typeof(Light))
	local var1_346 = Color.Lerp(arg0_346.originalCharacterColor.color, arg1_346, arg3_346)
	local var2_346 = math.lerp(arg0_346.originalCharacterColor.intensity, arg2_346, arg3_346)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_346, var2_346)
end

function var0_0.RevertCharacterLight(arg0_347)
	arg0_347:SetCharacterLight(arg0_347.originalCharacterColor.color, arg0_347.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_348, arg1_348, arg2_348, arg3_348)
	arg2_348 = arg2_348 or {}

	table.Foreach(arg1_348.clothComps, function(arg0_349, arg1_349)
		if arg1_349 == nil then
			return
		end

		setActive(arg1_349, arg2_348[arg0_349] == 1)
	end)
	table.Foreach(arg1_348.clothColliderDict, function(arg0_350, arg1_350)
		if arg1_350 == nil then
			return
		end

		setActive(arg1_350, false)
	end)

	if arg3_348 then
		table.Foreach(arg3_348, function(arg0_351, arg1_351)
			local var0_351 = arg1_348.clothColliderDict[arg1_351[1]]

			if var0_351 == nil then
				return
			end

			setActive(var0_351, arg1_351[2] == 1)

			if arg1_351[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_351, arg1_351[3], arg1_351[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_352, arg1_352)
	table.Foreach(arg1_352.ladyClothCompSettings, function(arg0_353, arg1_353)
		arg0_353.enabled = arg1_353.enabled
	end)
	table.Foreach(arg1_352.ladyClothColliderSettings, function(arg0_354, arg1_354)
		arg0_354.enabled = arg1_354.enabled

		var0_0.SetMagicaCollider(arg0_354, arg1_354.StartRadius, arg1_354.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_355)
	if arg0_355.exited or arg0_355.retainCount > 0 then
		-- block empty
	else
		arg0_355:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_356, arg1_356, arg2_356)
	assert(tobool(arg0_356.lastSceneRootDict[arg1_356]) == arg2_356)

	if arg2_356 then
		table.Foreach(arg0_356.lastSceneRootDict[arg1_356], function(arg0_357, arg1_357)
			if IsNil(arg0_357) then
				return
			end

			setActive(arg0_357, arg1_357)
		end)

		arg0_356.lastSceneRootDict[arg1_356] = nil
	else
		arg0_356.lastSceneRootDict[arg1_356] = {}

		local var0_356 = SceneManager.GetSceneByName(arg1_356)

		table.IpairsCArray(var0_356:GetRootGameObjects(), function(arg0_358, arg1_358)
			if tostring(arg1_358.hideFlags) ~= "None" then
				return
			end

			arg0_356.lastSceneRootDict[arg1_356][arg1_358] = isActive(arg1_358)

			setActive(arg1_358, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_359, arg1_359, arg2_359)
	arg1_359 = string.lower(arg1_359)

	if arg1_359 == arg0_359.artSceneInfo then
		if arg1_359 == arg0_359.sceneInfo then
			arg0_359:SwitchDayNight(arg0_359.contextData.timeIndex)
			onNextTick(function()
				arg0_359:RefreshSlots()
				existCall(arg2_359)
			end)
		else
			existCall(arg2_359)
		end

		return
	end

	local var0_359 = {}
	local var1_359 = false
	local var2_359

	table.insert(var0_359, function(arg0_361)
		arg0_359.artSceneInfo = arg1_359

		if var1_359 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_362)
				var2_359 = arg0_362

				arg0_361()
			end)
		else
			arg0_361()
		end
	end)

	if arg1_359 == arg0_359.sceneInfo then
		table.insert(var0_359, function(arg0_363)
			setActive(arg0_359.slotRoot, true)

			local var0_363, var1_363 = unpack(string.split(arg0_359.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_363))
			arg0_359:EnableSceneDisplay(var0_363, true)
			arg0_359:SwitchDayNight(arg0_359.contextData.timeIndex)
			onNextTick(function()
				arg0_359:RefreshSlots()
			end)
			arg0_363()
		end)
	else
		var1_359 = true

		local var3_359, var4_359 = unpack(string.split(arg1_359, "|"))

		table.insert(var0_359, function(arg0_365)
			setActive(arg0_359.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_359 .. "/" .. var3_359 .. "_scene"), var3_359, LoadSceneMode.Additive, function(arg0_366, arg1_366)
				SceneManager.SetActiveScene(arg0_366)

				local var0_366 = getSceneRootTFDic(arg0_366).MainCamera

				if var0_366 then
					setActive(var0_366, false)
				end

				arg0_365()
			end)
		end)
	end

	if arg0_359.artSceneInfo == arg0_359.sceneInfo then
		table.insert(var0_359, function(arg0_367)
			local var0_367, var1_367 = unpack(string.split(arg0_359.sceneInfo, "|"))

			arg0_359:EnableSceneDisplay(var0_367, false)
			arg0_367()
		end)
	else
		local var5_359, var6_359 = unpack(string.split(arg0_359.artSceneInfo, "|"))

		table.insert(var0_359, function(arg0_368)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_359 .. "/" .. var5_359 .. "_scene"), var5_359, arg0_368)
		end)
	end

	table.insert(var0_359, function(arg0_369)
		arg0_369()

		if var1_359 then
			var2_359()
		end
	end)
	seriesAsync(var0_359, arg2_359)
end

function var0_0.LoadTimelineScene(arg0_370, arg1_370, arg2_370, arg3_370)
	arg1_370 = string.lower(arg1_370)

	if arg0_370.cacheSceneDic[arg1_370] then
		if not arg2_370 then
			arg0_370.timelineScene = arg1_370

			arg0_370:EnableSceneDisplay(arg1_370, true)
		end

		return existCall(arg3_370)
	end

	local var0_370 = {}
	local var1_370

	table.insert(var0_370, function(arg0_371)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_372)
			if arg0_370.waitForTimeline then
				arg0_370.waitForTimeline = arg0_372
				var1_370 = nil
			else
				var1_370 = arg0_372
			end

			arg0_371()
		end)
	end)
	table.insert(var0_370, function(arg0_373)
		local var0_373 = arg0_370.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_373 .. "/timeline/" .. arg1_370 .. "/" .. arg1_370 .. "_scene"), arg1_370, LoadSceneMode.Additive, function(arg0_374, arg1_374)
			local var0_374 = GameObject.Find("[actor]").transform

			arg0_370:HXCharacter(tf(var0_374))

			local var1_374 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_374:Stop()
			TimelineSupport.InitTimeline(var1_374)
			TimelineSupport.InitSubtitle(var1_374, arg0_370.apartment:GetCallName())

			arg0_370.unloadDirector = var1_374

			arg0_373()
		end)
	end)
	table.insert(var0_370, function(arg0_375)
		arg0_370.sceneGroupDic[arg1_370] = arg0_370.apartment:GetConfigID()

		if arg2_370 then
			arg0_370.cacheSceneDic[arg1_370] = true

			arg0_370:EnableSceneDisplay(arg1_370, false)
		else
			arg0_370.timelineScene = arg1_370
		end

		arg0_375()
		existCall(var1_370)
	end)
	seriesAsync(var0_370, arg3_370)
end

function var0_0.UnloadTimelineScene(arg0_376, arg1_376, arg2_376, arg3_376)
	arg1_376 = string.lower(arg1_376)

	if arg0_376.timelineScene == arg1_376 then
		arg0_376.timelineScene = nil
	end

	if tobool(arg2_376) == tobool(arg0_376.cacheSceneDic[arg1_376]) then
		local var0_376 = getProxy(ApartmentProxy):getApartment(arg0_376.sceneGroupDic[arg1_376]):getConfig("asset_name")

		if arg0_376.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_376.unloadDirector)

			arg0_376.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_376 .. "/timeline/" .. arg1_376 .. "/" .. arg1_376 .. "_scene"), arg1_376, function()
			arg0_376.cacheSceneDic[arg1_376] = nil
			arg0_376.sceneGroupDic[arg1_376] = nil
			arg0_376.lastSceneRootDict[arg1_376] = nil

			existCall(arg3_376)
		end)
	else
		arg0_376:EnableSceneDisplay(arg1_376, false)
		existCall(arg3_376)
	end
end

function var0_0.ChangeSubScene(arg0_378, arg1_378, arg2_378)
	arg1_378 = string.lower(arg1_378)

	warning(arg0_378.subSceneInfo, "->", arg1_378, arg1_378 == arg0_378.subSceneInfo)

	local var0_378 = arg0_378.ladyDict[arg0_378.apartment:GetConfigID()]

	if arg1_378 == arg0_378.subSceneInfo then
		var0_378.ladyActiveZone = var0_378.walkBornPoint or var0_378.ladyBaseZone

		arg0_378:ChangeCharacterPosition(var0_378)
		arg0_378:ChangePlayerPosition(var0_378.ladyActiveZone)
		arg0_378:TriggerLadyDistance()
		arg0_378:CheckInSector()
		existCall(arg2_378)

		return
	end

	local var1_378 = {}
	local var2_378 = false
	local var3_378

	table.insert(var1_378, function(arg0_379)
		arg0_378.subSceneInfo = arg1_378

		if var2_378 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_380)
				var3_378 = arg0_380

				arg0_379()
			end)
		else
			arg0_379()
		end
	end)

	if arg1_378 == arg0_378.sceneInfo then
		table.insert(var1_378, function(arg0_381)
			local var0_381, var1_381 = unpack(string.split(arg0_378.sceneInfo, "|"))

			arg0_378:ResetSceneStructure(SceneManager.GetSceneByName(var0_381 .. "_base"))
			arg0_378:RefreshSlots()

			var0_378.ladyActiveZone = var0_378.walkBornPoint or var0_378.ladyBaseZone

			arg0_378:ChangeCharacterPosition(var0_378)
			arg0_378:ChangePlayerPosition(var0_378.ladyActiveZone)
			arg0_378:TriggerLadyDistance()
			arg0_378:CheckInSector()
			arg0_381()
		end)
	else
		var2_378 = true

		local var4_378, var5_378 = unpack(string.split(arg1_378, "|"))
		local var6_378 = var4_378 .. "_base"

		table.insert(var1_378, function(arg0_382)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_378 .. "/" .. var6_378 .. "_scene"), var6_378, LoadSceneMode.Additive, arg0_382)
		end)
		table.insert(var1_378, function(arg0_383)
			arg0_378:ResetSceneStructure(SceneManager.GetSceneByName(var6_378))

			var0_378.ladyActiveZone = var0_378.walkBornPoint or "Default"

			arg0_378:SwitchAnim(var0_378, var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_378:ChangeCharacterPosition(var0_378)
				arg0_378:ChangePlayerPosition(var0_378.ladyActiveZone)
				arg0_378:TriggerLadyDistance()
				arg0_378:CheckInSector()
				arg0_383()
			end)
		end)
	end

	if arg0_378.subSceneInfo == arg0_378.sceneInfo then
		table.insert(var1_378, function(arg0_385)
			local var0_385 = Clone(arg0_378.room)

			var0_385.furnitures = {}

			arg0_378:RefreshSlots(var0_385)
			arg0_385()
		end)
	else
		local var7_378, var8_378 = unpack(string.split(arg0_378.subSceneInfo, "|"))
		local var9_378 = var7_378 .. "_base"

		table.insert(var1_378, function(arg0_386)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_378 .. "/" .. var9_378 .. "_scene"), var9_378, arg0_386)
		end)
	end

	table.insert(var1_378, function(arg0_387)
		arg0_387()

		if var2_378 then
			var3_378()
		end
	end)
	seriesAsync(var1_378, arg2_378)
end

function var0_0.IsPointInSector(arg0_388, arg1_388)
	local var0_388 = arg1_388 - Vector3.New(unpack(arg0_388.Position))

	if var0_388.magnitude > arg0_388.Radius then
		return false
	end

	local var1_388 = Quaternion.Euler(unpack(arg0_388.Rotation))

	return Vector3.Angle(var1_388 * Vector3.forward, var0_388) <= arg0_388.Angle / 2
end

function var0_0.willExit(arg0_389)
	arg0_389.joystickTimer:Stop()
	arg0_389.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_389.updateHandler)
	arg0_389:StopIKHandTimer()

	if arg0_389.moveTimer then
		arg0_389.moveTimer:Stop()

		arg0_389.moveTimer = nil
	end

	if arg0_389.moveWaitTimer then
		arg0_389.moveWaitTimer:Stop()

		arg0_389.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_389.furnitures) then
		eachChild(arg0_389.furnitures, function(arg0_390)
			local var0_390 = GetComponent(arg0_390, typeof(EventTriggerListener))

			if not var0_390 then
				return
			end

			var0_390:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_389, iter1_389 in pairs(arg0_389.ladyDict) do
		GetComponent(iter1_389.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_389.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_389.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_389.blockLayer, arg0_389._tf)
	table.Foreach(arg0_389.expressionDict, function(arg0_391)
		arg0_389:RemoveExpression(arg0_391)
	end)
	arg0_389.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_389 = {}

	if arg0_389.timelineScene and not arg0_389.cacheSceneDic[arg0_389.timelineScene] then
		local var1_389 = arg0_389.timelineScene

		arg0_389.timelineScene = nil

		local var2_389 = getProxy(ApartmentProxy):getApartment(arg0_389.sceneGroupDic[var1_389]):getConfig("asset_name")

		table.insert(var0_389, function(arg0_392)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_389 .. "/timeline/" .. var1_389 .. "/" .. var1_389 .. "_scene"), var1_389, arg0_392)
		end)
	end

	for iter2_389, iter3_389 in pairs(arg0_389.cacheSceneDic) do
		if iter3_389 then
			local var3_389 = getProxy(ApartmentProxy):getApartment(arg0_389.sceneGroupDic[iter2_389]):getConfig("asset_name")

			table.insert(var0_389, function(arg0_393)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_389 .. "/timeline/" .. iter2_389 .. "/" .. iter2_389 .. "_scene"), iter2_389, arg0_393)
			end)
		end
	end

	for iter4_389, iter5_389 in ipairs({
		arg0_389.sceneInfo,
		arg0_389.subSceneInfo ~= arg0_389.sceneInfo and arg0_389.subSceneInfo or nil
	}) do
		local var4_389, var5_389 = unpack(string.split(iter5_389, "|"))
		local var6_389 = var4_389 .. "_base"

		table.insert(var0_389, function(arg0_394)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_389 .. "/" .. var6_389 .. "_scene"), var6_389, arg0_394)
		end)
	end

	for iter6_389, iter7_389 in ipairs({
		arg0_389.sceneInfo,
		arg0_389.artSceneInfo ~= arg0_389.sceneInfo and arg0_389.artSceneInfo or nil
	}) do
		local var7_389, var8_389 = unpack(string.split(iter7_389, "|"))

		table.insert(var0_389, function(arg0_395)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_389 .. "/" .. var7_389 .. "_scene"), var7_389, arg0_395)
		end)
	end

	seriesAsync(var0_389, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_397 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_397 = SystemInfo.deviceModel or ""

			local function var2_397(arg0_398)
				local var0_398 = string.match(arg0_398, "iPad(%d+)")
				local var1_398 = tonumber(var0_398)

				if var1_398 and var1_398 >= 8 then
					return true
				end

				return false
			end

			local function var3_397(arg0_399)
				local var0_399 = string.match(arg0_399, "iPhone(%d+)")
				local var1_399 = tonumber(var0_399)

				if var1_399 and var1_399 >= 13 then
					return true
				end

				return false
			end

			if var2_397(var1_397) or var3_397(var1_397) then
				var0_397 = DevicePerformanceLevel.High
			end
		end

		local var4_397 = var0_397 == DevicePerformanceLevel.High and 3 or var0_397 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_397)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_397
	end
end

function var0_0.SettingQuality()
	local var0_400 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_400)
end

function var0_0.SetMagicaCollider(arg0_401, arg1_401, arg2_401)
	local var0_401 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_401, "StartRadius", arg0_401, arg1_401)
	ReflectionHelp.RefSetProperty(var0_401, "EndRadius", arg0_401, arg2_401)
end

return var0_0
