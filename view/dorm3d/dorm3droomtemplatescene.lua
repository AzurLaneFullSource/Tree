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
	arg0_10.room = getProxy(ApartmentProxy):getRoom(arg0_10.contextData.roomId)
	arg0_10.sceneInfo = string.lower(arg0_10.room:getConfig("scene_info"))
	arg0_10.artSceneInfo = arg0_10.sceneInfo
	arg0_10.subSceneInfo = arg0_10.sceneInfo

	local var0_10, var1_10 = unpack(string.split(arg0_10.sceneInfo, "|"))
	local var2_10 = {
		function(arg0_11)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_10 .. "/" .. var0_10 .. "_scene"), var0_10, LoadSceneMode.Additive, function(arg0_12, arg1_12)
				SceneManager.SetActiveScene(arg0_12)

				local var0_12 = getSceneRootTFDic(arg0_12).MainCamera

				if var0_12 then
					setActive(var0_12, false)
				end

				arg0_11()
			end)
		end,
		function(arg0_13)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_10 .. "/" .. var0_10 .. "_base_scene"), var0_10 .. "_base", LoadSceneMode.Additive, arg0_13)
		end
	}

	table.insert(var2_10, function(arg0_14)
		arg0_10:LoadCharacter(arg0_10.contextData.groupIds, arg0_14)
	end)
	seriesAsync(var2_10, arg1_10)
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
	tolua.loadassembly("MagicaCloth")

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
	arg0_40.compDolly = arg0_40.cameraAim:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Body)
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
	arg0_87.cameras[var0_0.CAMERA.TALK].Follow = arg1_87.ladyInterest
	arg0_87.cameras[var0_0.CAMERA.TALK].LookAt = arg1_87.ladyInterest
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

function var0_0.WalkByRootMotionLoop(arg0_158, arg1_158, arg2_158)
	if arg1_158.pathPending then
		arg2_158:SetFloat("Speed", 0)

		return
	end

	arg2_158:SetFloat("Speed", 1)

	local var0_158 = arg1_158.path.corners

	if var0_158.Length > 1 then
		local var1_158 = var0_158[1] - arg1_158.transform.position

		var1_158.y = 0

		local var2_158 = Quaternion.LookRotation(var1_158)
		local var3_158 = arg1_158.transform.rotation
		local var4_158 = 1
		local var5_158 = Damp(1, var4_158, Time.deltaTime)

		arg1_158.transform.rotation = Quaternion.Lerp(var3_158, var2_158, var5_158)
	end
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

	setActive(arg0_199:GetIKTipsRootTF(), false)

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

	setActive(arg0_210:GetIKTipsRootTF(), false)
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
	arg0_234:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_235)
	arg0_235:HideFurnitureSlots()

	local var0_235 = arg0_235.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_236)
			arg0_235:emit(var0_0.SHOW_BLOCK)
			arg0_235:ShowBlackScreen(true, arg0_236)
		end,
		function(arg0_237)
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
		arg0_276:LoadTimelineScene(arg1_276.name, false, arg0_278)
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

	local var1_276 = arg0_276.artSceneInfo

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

				function arg0_304.animExtraItemCallback()
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

			existCall(arg0_304.animExtraItemCallback)

			arg0_304.animExtraItemCallback = nil

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

function var0_0.EnableSceneDisplay(arg0_357, arg1_357, arg2_357)
	assert(tobool(arg0_357.lastSceneRootDict[arg1_357]) == arg2_357)

	if arg2_357 then
		table.Foreach(arg0_357.lastSceneRootDict[arg1_357], function(arg0_358, arg1_358)
			if IsNil(arg0_358) then
				return
			end

			setActive(arg0_358, arg1_358)
		end)

		arg0_357.lastSceneRootDict[arg1_357] = nil
	else
		arg0_357.lastSceneRootDict[arg1_357] = {}

		local var0_357 = SceneManager.GetSceneByName(arg1_357)

		table.IpairsCArray(var0_357:GetRootGameObjects(), function(arg0_359, arg1_359)
			if tostring(arg1_359.hideFlags) ~= "None" then
				return
			end

			arg0_357.lastSceneRootDict[arg1_357][arg1_359] = isActive(arg1_359)

			setActive(arg1_359, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_360, arg1_360, arg2_360)
	arg1_360 = string.lower(arg1_360)

	if arg1_360 == arg0_360.artSceneInfo then
		if arg1_360 == arg0_360.sceneInfo then
			arg0_360:SwitchDayNight(arg0_360.contextData.timeIndex)
			onNextTick(function()
				arg0_360:RefreshSlots()
				existCall(arg2_360)
			end)
		else
			existCall(arg2_360)
		end

		return
	end

	local var0_360 = {}
	local var1_360 = false
	local var2_360

	table.insert(var0_360, function(arg0_362)
		arg0_360.artSceneInfo = arg1_360

		if var1_360 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_363)
				var2_360 = arg0_363

				arg0_362()
			end)
		else
			arg0_362()
		end
	end)

	if arg1_360 == arg0_360.sceneInfo then
		table.insert(var0_360, function(arg0_364)
			setActive(arg0_360.slotRoot, true)

			local var0_364, var1_364 = unpack(string.split(arg0_360.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_364))
			arg0_360:EnableSceneDisplay(var0_364, true)
			arg0_360:SwitchDayNight(arg0_360.contextData.timeIndex)
			onNextTick(function()
				arg0_360:RefreshSlots()
			end)
			arg0_364()
		end)
	else
		var1_360 = true

		local var3_360, var4_360 = unpack(string.split(arg1_360, "|"))

		table.insert(var0_360, function(arg0_366)
			setActive(arg0_360.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_360 .. "/" .. var3_360 .. "_scene"), var3_360, LoadSceneMode.Additive, function(arg0_367, arg1_367)
				SceneManager.SetActiveScene(arg0_367)

				local var0_367 = getSceneRootTFDic(arg0_367).MainCamera

				if var0_367 then
					setActive(var0_367, false)
				end

				arg0_366()
			end)
		end)
	end

	if arg0_360.artSceneInfo == arg0_360.sceneInfo then
		table.insert(var0_360, function(arg0_368)
			local var0_368, var1_368 = unpack(string.split(arg0_360.sceneInfo, "|"))

			arg0_360:EnableSceneDisplay(var0_368, false)
			arg0_368()
		end)
	else
		local var5_360, var6_360 = unpack(string.split(arg0_360.artSceneInfo, "|"))

		table.insert(var0_360, function(arg0_369)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_360 .. "/" .. var5_360 .. "_scene"), var5_360, arg0_369)
		end)
	end

	table.insert(var0_360, function(arg0_370)
		arg0_370()

		if var1_360 then
			var2_360()
		end
	end)
	seriesAsync(var0_360, arg2_360)
end

function var0_0.LoadTimelineScene(arg0_371, arg1_371, arg2_371, arg3_371)
	arg1_371 = string.lower(arg1_371)

	if arg0_371.cacheSceneDic[arg1_371] then
		if not arg2_371 then
			arg0_371.timelineScene = arg1_371

			arg0_371:EnableSceneDisplay(arg1_371, true)
		end

		return existCall(arg3_371)
	end

	local var0_371 = {}
	local var1_371

	table.insert(var0_371, function(arg0_372)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_373)
			if arg0_371.waitForTimeline then
				arg0_371.waitForTimeline = arg0_373
				var1_371 = nil
			else
				var1_371 = arg0_373
			end

			arg0_372()
		end)
	end)
	table.insert(var0_371, function(arg0_374)
		local var0_374 = arg0_371.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_374 .. "/timeline/" .. arg1_371 .. "/" .. arg1_371 .. "_scene"), arg1_371, LoadSceneMode.Additive, function(arg0_375, arg1_375)
			local var0_375 = GameObject.Find("[actor]").transform

			arg0_371:HXCharacter(tf(var0_375))

			local var1_375 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_375:Stop()
			TimelineSupport.InitTimeline(var1_375)
			TimelineSupport.InitSubtitle(var1_375, arg0_371.apartment:GetCallName())

			arg0_371.unloadDirector = var1_375

			arg0_374()
		end)
	end)
	table.insert(var0_371, function(arg0_376)
		arg0_371.sceneGroupDic[arg1_371] = arg0_371.apartment:GetConfigID()

		if arg2_371 then
			arg0_371.cacheSceneDic[arg1_371] = true

			arg0_371:EnableSceneDisplay(arg1_371, false)
		else
			arg0_371.timelineScene = arg1_371
		end

		arg0_376()
		existCall(var1_371)
	end)
	seriesAsync(var0_371, arg3_371)
end

function var0_0.UnloadTimelineScene(arg0_377, arg1_377, arg2_377, arg3_377)
	arg1_377 = string.lower(arg1_377)

	if arg0_377.timelineScene == arg1_377 then
		arg0_377.timelineScene = nil
	end

	if tobool(arg2_377) == tobool(arg0_377.cacheSceneDic[arg1_377]) then
		local var0_377 = getProxy(ApartmentProxy):getApartment(arg0_377.sceneGroupDic[arg1_377]):getConfig("asset_name")

		if arg0_377.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_377.unloadDirector)

			arg0_377.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_377 .. "/timeline/" .. arg1_377 .. "/" .. arg1_377 .. "_scene"), arg1_377, function()
			arg0_377.cacheSceneDic[arg1_377] = nil
			arg0_377.sceneGroupDic[arg1_377] = nil
			arg0_377.lastSceneRootDict[arg1_377] = nil

			existCall(arg3_377)
		end)
	else
		arg0_377:EnableSceneDisplay(arg1_377, false)
		existCall(arg3_377)
	end
end

function var0_0.ChangeSubScene(arg0_379, arg1_379, arg2_379)
	arg1_379 = string.lower(arg1_379)

	warning(arg0_379.subSceneInfo, "->", arg1_379, arg1_379 == arg0_379.subSceneInfo)

	local var0_379 = arg0_379.ladyDict[arg0_379.apartment:GetConfigID()]

	if arg1_379 == arg0_379.subSceneInfo then
		var0_379.ladyActiveZone = var0_379.walkBornPoint or var0_379.ladyBaseZone

		arg0_379:ChangeCharacterPosition(var0_379)
		arg0_379:ChangePlayerPosition(var0_379.ladyActiveZone)
		arg0_379:TriggerLadyDistance()
		arg0_379:CheckInSector()
		existCall(arg2_379)

		return
	end

	local var1_379 = {}
	local var2_379 = false
	local var3_379

	table.insert(var1_379, function(arg0_380)
		arg0_379.subSceneInfo = arg1_379

		if var2_379 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_381)
				var3_379 = arg0_381

				arg0_380()
			end)
		else
			arg0_380()
		end
	end)

	if arg1_379 == arg0_379.sceneInfo then
		table.insert(var1_379, function(arg0_382)
			local var0_382, var1_382 = unpack(string.split(arg0_379.sceneInfo, "|"))

			arg0_379:ResetSceneStructure(SceneManager.GetSceneByName(var0_382 .. "_base"))
			arg0_379:RefreshSlots()

			var0_379.ladyActiveZone = var0_379.walkBornPoint or var0_379.ladyBaseZone

			arg0_379:ChangeCharacterPosition(var0_379)
			arg0_379:ChangePlayerPosition(var0_379.ladyActiveZone)
			arg0_379:TriggerLadyDistance()
			arg0_379:CheckInSector()
			arg0_382()
		end)
	else
		var2_379 = true

		local var4_379, var5_379 = unpack(string.split(arg1_379, "|"))
		local var6_379 = var4_379 .. "_base"

		table.insert(var1_379, function(arg0_383)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_379 .. "/" .. var6_379 .. "_scene"), var6_379, LoadSceneMode.Additive, arg0_383)
		end)
		table.insert(var1_379, function(arg0_384)
			arg0_379:ResetSceneStructure(SceneManager.GetSceneByName(var6_379))

			var0_379.ladyActiveZone = var0_379.walkBornPoint or "Default"

			arg0_379:SwitchAnim(var0_379, var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_379:ChangeCharacterPosition(var0_379)
				arg0_379:ChangePlayerPosition(var0_379.ladyActiveZone)
				arg0_379:TriggerLadyDistance()
				arg0_379:CheckInSector()
				arg0_384()
			end)
		end)
	end

	if arg0_379.subSceneInfo == arg0_379.sceneInfo then
		table.insert(var1_379, function(arg0_386)
			local var0_386 = Clone(arg0_379.room)

			var0_386.furnitures = {}

			arg0_379:RefreshSlots(var0_386)
			arg0_386()
		end)
	else
		local var7_379, var8_379 = unpack(string.split(arg0_379.subSceneInfo, "|"))
		local var9_379 = var7_379 .. "_base"

		table.insert(var1_379, function(arg0_387)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_379 .. "/" .. var9_379 .. "_scene"), var9_379, arg0_387)
		end)
	end

	table.insert(var1_379, function(arg0_388)
		arg0_388()

		if var2_379 then
			var3_379()
		end
	end)
	seriesAsync(var1_379, arg2_379)
end

function var0_0.IsPointInSector(arg0_389, arg1_389)
	local var0_389 = arg1_389 - Vector3.New(unpack(arg0_389.Position))

	if var0_389.magnitude > arg0_389.Radius then
		return false
	end

	local var1_389 = Quaternion.Euler(unpack(arg0_389.Rotation))

	return Vector3.Angle(var1_389 * Vector3.forward, var0_389) <= arg0_389.Angle / 2
end

function var0_0.willExit(arg0_390)
	arg0_390.joystickTimer:Stop()
	arg0_390.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_390.updateHandler)
	arg0_390:StopIKHandTimer()

	if arg0_390.moveTimer then
		arg0_390.moveTimer:Stop()

		arg0_390.moveTimer = nil
	end

	if arg0_390.moveWaitTimer then
		arg0_390.moveWaitTimer:Stop()

		arg0_390.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_390.furnitures) then
		eachChild(arg0_390.furnitures, function(arg0_391)
			local var0_391 = GetComponent(arg0_391, typeof(EventTriggerListener))

			if not var0_391 then
				return
			end

			var0_391:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_390, iter1_390 in pairs(arg0_390.ladyDict) do
		GetComponent(iter1_390.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_390.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_390.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_390.blockLayer, arg0_390._tf)
	table.Foreach(arg0_390.expressionDict, function(arg0_392)
		arg0_390:RemoveExpression(arg0_392)
	end)
	arg0_390.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_390 = {}

	if arg0_390.timelineScene and not arg0_390.cacheSceneDic[arg0_390.timelineScene] then
		local var1_390 = arg0_390.timelineScene

		arg0_390.timelineScene = nil

		local var2_390 = getProxy(ApartmentProxy):getApartment(arg0_390.sceneGroupDic[var1_390]):getConfig("asset_name")

		table.insert(var0_390, function(arg0_393)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_390 .. "/timeline/" .. var1_390 .. "/" .. var1_390 .. "_scene"), var1_390, arg0_393)
		end)
	end

	for iter2_390, iter3_390 in pairs(arg0_390.cacheSceneDic) do
		if iter3_390 then
			local var3_390 = getProxy(ApartmentProxy):getApartment(arg0_390.sceneGroupDic[iter2_390]):getConfig("asset_name")

			table.insert(var0_390, function(arg0_394)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_390 .. "/timeline/" .. iter2_390 .. "/" .. iter2_390 .. "_scene"), iter2_390, arg0_394)
			end)
		end
	end

	for iter4_390, iter5_390 in ipairs({
		arg0_390.sceneInfo,
		arg0_390.subSceneInfo ~= arg0_390.sceneInfo and arg0_390.subSceneInfo or nil
	}) do
		local var4_390, var5_390 = unpack(string.split(iter5_390, "|"))
		local var6_390 = var4_390 .. "_base"

		table.insert(var0_390, function(arg0_395)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_390 .. "/" .. var6_390 .. "_scene"), var6_390, arg0_395)
		end)
	end

	for iter6_390, iter7_390 in ipairs({
		arg0_390.sceneInfo,
		arg0_390.artSceneInfo ~= arg0_390.sceneInfo and arg0_390.artSceneInfo or nil
	}) do
		local var7_390, var8_390 = unpack(string.split(iter7_390, "|"))

		table.insert(var0_390, function(arg0_396)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_390 .. "/" .. var7_390 .. "_scene"), var7_390, arg0_396)
		end)
	end

	seriesAsync(var0_390, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_398 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_398 = SystemInfo.deviceModel or ""

			local function var2_398(arg0_399)
				local var0_399 = string.match(arg0_399, "iPad(%d+)")
				local var1_399 = tonumber(var0_399)

				if var1_399 and var1_399 >= 8 then
					return true
				end

				return false
			end

			local function var3_398(arg0_400)
				local var0_400 = string.match(arg0_400, "iPhone(%d+)")
				local var1_400 = tonumber(var0_400)

				if var1_400 and var1_400 >= 13 then
					return true
				end

				return false
			end

			if var2_398(var1_398) or var3_398(var1_398) then
				var0_398 = DevicePerformanceLevel.High
			end
		end

		local var4_398 = var0_398 == DevicePerformanceLevel.High and 3 or var0_398 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_398)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_398
	end
end

function var0_0.SettingQuality()
	local var0_401 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_401)
end

function var0_0.SetMagicaCollider(arg0_402, arg1_402, arg2_402)
	local var0_402 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_402, "StartRadius", arg0_402, arg1_402)
	ReflectionHelp.RefSetProperty(var0_402, "EndRadius", arg0_402, arg2_402)
end

return var0_0
