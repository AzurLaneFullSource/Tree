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
	pg.IKMgr.GetInstance():RegisterOnIKLayerDeactive(function(arg0_36)
		local var0_36 = arg0_32.ladyDict[arg0_32.apartment:GetConfigID()]
		local var1_36 = _.detect(var0_36.readyIKLayers, function(arg0_37)
			return arg0_37:GetControllerPath() == arg0_36.ikData:GetControllerPath()
		end)

		arg0_32:DeactiveIKLayer(var1_36)

		arg0_32.ikHandler = nil
		arg0_32.blockIK = nil

		onNextTick(function()
			arg0_32:emit(var0_0.ON_IK_STATUS_CHANGED, var1_36:GetConfigID(), var0_0.IK_STATUS.RELEASE)
		end)
	end)
	pg.IKMgr.GetInstance():RegisterOnIKLayerAction(function(arg0_39)
		local var0_39 = arg0_32.ladyDict[arg0_32.apartment:GetConfigID()]
		local var1_39 = _.detect(var0_39.readyIKLayers, function(arg0_40)
			return arg0_40:GetControllerPath() == arg0_39.ikData:GetControllerPath()
		end)

		arg0_32:OnTriggerIK(var1_39)
		arg0_32:emit(var0_0.ON_IK_STATUS_CHANGED, var1_39:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	end)
end

function var0_0.initScene(arg0_41)
	local var0_41, var1_41 = unpack(string.split(arg0_41.sceneInfo, "|"))
	local var2_41 = SceneManager.GetSceneByName(var0_41 .. "_base")

	arg0_41:ResetSceneStructure(var2_41)

	arg0_41.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_41.camBrain = arg0_41.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_41.camBrainEvenetHandler = arg0_41.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_41.raycastCamera = arg0_41.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_41.sceneRaycaster = arg0_41.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_41.player = GameObject.Find("Player").transform
	arg0_41.playerEye = arg0_41.player:Find("Eye")
	arg0_41.playerFoot = arg0_41.player:Find("Foot")

	setActive(arg0_41.playerFoot, false)

	arg0_41.playerController = arg0_41.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_41.attachedPoints = {}

	eachChild(arg0_41.furnitures, function(arg0_42)
		table.insert(arg0_41.attachedPoints, 1, arg0_42)
	end)

	arg0_41.modelRoot = GameObject.Find("scene_root").transform
	arg0_41.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_41.slotRoot, true)
	arg0_41:InitSlots()

	arg0_41.resTF = GameObject.Find("Res").transform

	tolua.loadassembly("Cinemachine")
	tolua.loadassembly("MagicaCloth")

	local var3_41 = GameObject.Find("CM Cameras").transform

	eachChild(var3_41, function(arg0_43)
		setActive(arg0_43, false)
	end)

	arg0_41.camBrain.enabled = false
	arg0_41.camBrain.enabled = true
	arg0_41.cameraAim = var3_41:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_41.cameraAim2 = var3_41:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_41.cameraFree = nil
	arg0_41.cameraFurnitureWatch = nil
	arg0_41.cameraRole = var3_41:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_41.cameraRole2 = var3_41:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	local var4_41 = var3_41:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	arg0_41.cameraGift = var3_41:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_41.cameras = {
		arg0_41.cameraAim,
		arg0_41.cameraAim2,
		arg0_41.cameraRole,
		[var0_0.CAMERA.TALK] = var4_41,
		[var0_0.CAMERA.GIFT] = arg0_41.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_41.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_41:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_41:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_41:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	}
	arg0_41.compDolly = arg0_41.cameraAim:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Body)
	arg0_41.compPovAim = arg0_41.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_41.cameraRoot = var3_41
	arg0_41.POVOriginalFOV = arg0_41:GetPOVFOV()
	arg0_41.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_41.restrictedBox, false)

	arg0_41.restrictedHeightRange = {
		arg0_41.restrictedBox:Find("Floor").position.y,
		arg0_41.restrictedBox:Find("Celling").position.y
	}
	arg0_41.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_41.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))

	arg0_41:SwitchDayNight(arg0_41.contextData.timeIndex)

	arg0_41.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_41 .. "_base")).CutIn

	if arg0_41.tfCutIn then
		arg0_41.modelCutIn = {
			lady = arg0_41.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_41.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_41.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_44, arg1_44)
	if not IsNil(arg0_44.daynightCtrlComp) then
		arg0_44.daynightCtrlComp:SwitcherToIndex(arg1_44 - 1)
	end

	arg0_44:InitLightSettings()
end

function var0_0.InitLightSettings(arg0_45)
	arg0_45.globalVolume = GameObject.Find("GlobalVolume")

	arg0_45:RegisterGlobalVolume()

	arg0_45.characterLight = GameObject.Find("CharacterLight")

	arg0_45:RecordCharacterLight()

	local var0_45 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_45:GetComponentsInChildren(typeof(Light), true), function(arg0_46, arg1_46)
		arg1_46.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.ResetSceneStructure(arg0_47, arg1_47)
	table.IpairsCArray(arg1_47:GetRootGameObjects(), function(arg0_48, arg1_48)
		if arg1_48.name == "Furnitures" then
			arg0_47.furnitures = tf(arg1_48)

			eachChild(arg0_47.furnitures, function(arg0_49)
				if arg0_49:Find("FreeLook Camera") then
					setActive(arg0_49:Find("FreeLook Camera"), false)
				end

				if arg0_49:Find("FreeLook Camera") then
					setActive(arg0_49:Find("RoleWatch Camera"), false)
				end

				if arg0_49:Find("IKCamera") then
					setActive(arg0_49:Find("IKCamera"), false)
				end

				local var0_49 = arg0_49:GetComponent(typeof(UnityEngine.Collider))

				if not var0_49 then
					return
				end

				var0_49.enabled = false
			end)
		end
	end)

	arg0_47.sectorsDic = arg0_47.sectorsDic or {}

	if not arg0_47.sectorsDic[arg1_47.name] then
		arg0_47.sectorsDic[arg1_47.name] = table.shallowCopy(var2_0[arg1_47.name]) or {}

		setmetatable(arg0_47.sectorsDic[arg1_47.name], {
			__index = function(arg0_50, arg1_50)
				local var0_50 = arg0_47.furnitures:Find(arg1_50 .. "/StayPoint")

				if var0_50 then
					local var1_50 = var0_50.position
					local var2_50 = var0_50.eulerAngles

					arg0_50[arg1_50] = {
						Radius = 2,
						Angle = 120,
						Position = {
							var1_50.x,
							var1_50.y,
							var1_50.z
						},
						Rotation = {
							var2_50.x,
							var2_50.y,
							var2_50.z
						}
					}

					return arg0_50[arg1_50]
				else
					return nil
				end
			end
		})
	end

	arg0_47.activeSectors = arg0_47.sectorsDic[arg1_47.name]
end

function var0_0.InitSlots(arg0_51)
	local var0_51 = arg0_51.room:GetSlots()
	local var1_51 = arg0_51.modelRoot:GetComponentsInChildren(typeof(Transform), true)

	arg0_51.slotDict = {}

	_.each(var0_51, function(arg0_52)
		local var0_52 = arg0_52:GetFurnitureName()
		local var1_52 = arg0_52:GetConfigID()
		local var2_52 = arg0_51.slotRoot:Find(tostring(var1_52))

		assert(var2_52)

		local var3_52 = {
			trans = var2_52,
			sceneHides = {}
		}
		local var4_52 = var2_52:Find("Selector")

		if var4_52 then
			GetOrAddComponent(var4_52, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_53, arg1_53)
				arg0_51:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_52)
			end)
			setActive(var4_52, false)
		end

		local var5_52

		for iter0_52 = 0, var1_51.Length - 1 do
			local var6_52 = var1_51[iter0_52]

			if var6_52.name == var0_52 then
				var5_52 = var6_52

				break
			end
		end

		if var5_52 then
			var3_52.model = var5_52
		end

		arg0_51.slotDict[var1_52] = var3_52
	end)
end

function var0_0.SetContactStateDic(arg0_54, arg1_54)
	arg0_54.contactStateDic = arg1_54
	arg0_54.hideContactStateDic = {}
	arg0_54.contactInRangeDic = {}

	for iter0_54, iter1_54 in pairs(arg0_54.contactStateDic) do
		arg0_54.hideContactStateDic[iter0_54] = math.min(iter1_54, ApartmentRoom.ITEM_UNLOCK)
		arg0_54.contactInRangeDic[iter0_54] = false
	end

	arg0_54:ActiveContact()
end

function var0_0.TempHideContact(arg0_55, arg1_55)
	arg0_55.hideConcatFlag = arg1_55

	arg0_55:ActiveContact()
end

function var0_0.ActiveContact(arg0_56)
	for iter0_56, iter1_56 in pairs(arg0_56.contactInRangeDic) do
		arg0_56:UpdateContactDisplay(iter0_56, arg0_56.contactInRangeDic[iter0_56] and not arg0_56.hideConcatFlag and arg0_56.contactStateDic[iter0_56] or arg0_56.hideContactStateDic[iter0_56])
	end
end

function var0_0.UpdateContactDisplay(arg0_57, arg1_57, arg2_57)
	local var0_57 = pg.dorm3d_collection_template[arg1_57]

	for iter0_57, iter1_57 in ipairs(var0_57.vfx_prefab) do
		local var1_57 = arg0_57.modelRoot:Find(iter1_57)

		if arg0_57:IsModeInHidePending(iter1_57) then
			-- block empty
		elseif not arg0_57.modelRoot:Find(iter1_57) then
			warning(arg1_57, iter1_57)
		else
			setActive(var1_57, arg2_57 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_57, iter3_57 in ipairs(var0_57.model) do
		if arg0_57:IsModeInHidePending(iter3_57) then
			-- block empty
		elseif not arg0_57.modelRoot:Find(iter3_57) then
			warning(arg1_57, iter3_57)
		else
			local var2_57 = arg0_57.modelRoot:Find(iter3_57)

			if arg0_57:CheckSceneItemActive(var2_57) then
				local var3_57 = GetComponent(var2_57, typeof(EventTriggerListener))

				if arg2_57 == ApartmentRoom.ITEM_FIRST then
					var3_57 = var3_57 or GetOrAddComponent(var2_57, typeof(EventTriggerListener))

					var3_57:AddPointClickFunc(function(arg0_58, arg1_58)
						arg0_57:emit(var0_0.CLICK_CONTACT, arg1_57)
					end)

					var3_57.enabled = true
				elseif var3_57 then
					var3_57.enabled = false
				end

				setActive(var2_57, arg2_57 > ApartmentRoom.ITEM_LOCK)
			end
		end
	end
end

function var0_0.SetFloatEnable(arg0_59, arg1_59)
	arg0_59.enableFloatUpdate = arg1_59

	if arg1_59 then
		arg0_59.ladyDict[arg0_59.apartment:GetConfigID()]:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_60)
	local var0_60 = arg0_60.ladyDict[arg0_60.apartment:GetConfigID()]
	local var1_60 = arg0_60:GetScreenPosition(var0_60.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var2_60 = arg0_60:GetLocalPosition(var1_60, arg0_60.rtFloatPage)

	setLocalPosition(arg0_60.rtFloatPage:Find("lady"), var2_60)
end

function var0_0.LoadCharacter(arg0_61, arg1_61, arg2_61)
	arg0_61.hxMatDict = {}
	arg0_61.ladyDict = {}
	arg0_61.skinDict = {}

	local var0_61 = {}

	for iter0_61, iter1_61 in ipairs(arg1_61) do
		local var1_61 = setmetatable({}, {
			__index = arg0_61
		})

		arg0_61.ladyDict[iter1_61] = var1_61

		local var2_61 = getProxy(ApartmentProxy):getApartment(iter1_61)
		local var3_61 = var2_61:getConfig("asset_name")
		local var4_61 = var2_61:GetSkinModelID(arg0_61.room:getConfig("tag"))
		local var5_61 = pg.dorm3d_resource[var4_61].model_id

		assert(var5_61)

		for iter2_61, iter3_61 in ipairs({
			"common",
			var5_61
		}) do
			local var6_61 = string.format("dorm3d/character/%s/res/%s", var3_61, iter3_61)

			if checkABExist(var6_61) then
				table.insert(var0_61, function(arg0_62)
					arg0_61.loader:LoadBundle(var6_61, function(arg0_63)
						for iter0_63, iter1_63 in ipairs(arg0_63:GetAllAssetNames()) do
							local var0_63, var1_63, var2_63 = string.find(iter1_63, "material_hx[/\\](.*).mat")

							if var0_63 then
								arg0_61.hxMatDict[var2_63] = {
									arg0_63,
									iter1_63
								}
							end
						end

						arg0_62()
					end)
				end)
			end
		end

		var1_61.skinId = var4_61
		var1_61.skinIdList = {
			var4_61
		}

		table.insert(var0_61, function(arg0_64)
			local var0_64 = string.format("dorm3d/character/%s/prefabs/%s", var3_61, var5_61)

			arg0_61.loader:GetPrefab(var0_64, "", function(arg0_65)
				var1_61.ladyGameobject = arg0_65
				arg0_61.skinDict[var4_61] = {
					ladyGameobject = arg0_65
				}

				arg0_64()
			end)
		end)

		if arg0_61.room:isPersonalRoom() then
			local var7_61 = var2_61:GetSkinModelID("touch")

			if var7_61 then
				local var8_61 = pg.dorm3d_resource[var7_61].model_id

				if #var8_61 > 0 then
					table.insert(var1_61.skinIdList, var7_61)
					table.insert(var0_61, function(arg0_66)
						local var0_66 = string.format("dorm3d/character/%s/prefabs/%s", var3_61, var8_61)

						arg0_61.loader:GetPrefab(var0_66, "", function(arg0_67)
							arg0_61.skinDict[var7_61] = {
								ladyGameobject = arg0_67
							}
							GetComponent(arg0_67, "GraphOwner").enabled = false

							onNextTick(function()
								setActive(arg0_67, false)
							end)
							arg0_66()
						end)
					end)
				end
			end
		end

		if arg0_61.contextData.pendingDic[iter1_61] then
			local var9_61 = pg.dorm3d_welcome[arg0_61.contextData.pendingDic[iter1_61]]

			if var9_61.item_prefab ~= "" then
				table.insert(var0_61, function(arg0_69)
					local var0_69 = string.lower("dorm3d/furniture/item/" .. var9_61.item_prefab)

					arg0_61.loader:GetPrefab(var0_69, "", function(arg0_70)
						var1_61.tfPendintItem = arg0_70.transform

						onNextTick(function()
							setActive(arg0_70, false)
						end)
						arg0_69()
					end)
				end)
			end
		end
	end

	parallelAsync(var0_61, arg2_61)
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
		end
	end)
end

function var0_0.InitCharacter(arg0_75, arg1_75, arg2_75)
	arg1_75.lady = arg1_75.ladyGameobject.transform

	arg1_75.lady:SetParent(arg1_75.mainCameraTF)
	arg1_75.lady:SetParent(nil)

	arg1_75.ladyHeadIKComp = arg1_75.lady:GetComponent(typeof(HeadAimIK))
	arg1_75.ladyHeadIKComp.AimTarget = arg1_75.mainCameraTF:Find("AimTarget")
	arg1_75.ladyHeadIKData = {
		DampTime = arg1_75.ladyHeadIKComp.DampTime,
		blinkSpeed = arg1_75.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg1_75.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg1_75.ladyHeadIKComp.HeadWeight
	}

	local var0_75 = {}

	table.Foreach(var1_0, function(arg0_76, arg1_76)
		var0_75[arg1_76] = arg0_76
	end)

	arg1_75.ladyAnimator = arg1_75.lady:GetComponent(typeof(Animator))
	arg1_75.ladyAnimBaseLayerIndex = arg1_75.ladyAnimator:GetLayerIndex("Base Layer")
	arg1_75.ladyAnimFaceLayerIndex = arg1_75.ladyAnimator:GetLayerIndex("Face")
	arg1_75.ladyBoneMaps = {}

	local var1_75 = arg1_75.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_75, function(arg0_77, arg1_77)
		if arg1_77.name == "BodyCollider" then
			arg1_75.ladyCollider = arg1_77

			setActive(arg1_77, true)
		elseif arg1_77.name == "SafeCollider" then
			arg1_75.ladySafeCollider = arg1_77

			setActive(arg1_77, false)
		elseif arg1_77.name == "Interest" then
			arg1_75.ladyInterestRoot = arg1_77
		elseif arg1_77.name == "Head Center" then
			arg1_75.ladyHeadCenter = arg1_77
		end

		if var0_75[arg1_77.name] then
			arg1_75.ladyBoneMaps[var0_75[arg1_77.name]] = arg1_77
		end
	end)

	arg1_75.ladyColliders = {}
	arg1_75.ladyTouchColliders = {}

	table.IpairsCArray(arg1_75.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_78, arg1_78)
		if arg1_78:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_78)

		local var0_78 = child.name
		local var1_78 = var0_78 and string.find(var0_78, "Collider") or -1

		if var1_78 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_78)

			return
		end

		local var2_78 = string.sub(var0_78, 1, var1_78 - 1)

		if var0_0.BONE_TO_TOUCH[var2_78] == nil then
			return
		end

		arg1_75.ladyColliders[var2_78] = child

		table.insert(arg1_75.ladyTouchColliders, child)
		setActive(child, false)
	end)
	arg1_75:HXCharacter(arg1_75.lady)
	;(function()
		local var0_79 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_79 = "vfx_function_aixin02"

		arg1_75.loader:GetPrefab(var0_79, var1_79, function(arg0_80)
			arg1_75.effectHeart = arg0_80

			setActive(arg0_80, false)
			onNextTick(function()
				setParent(arg1_75.effectHeart, arg1_75.ladyHeadCenter)
			end)
		end)
	end)()

	arg1_75.clothComps = {}
	arg1_75.ladyClothCompSettings = {}

	table.IpairsCArray(arg1_75.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_82, arg1_82)
		table.insert(arg1_75.clothComps, arg1_82)

		arg1_75.ladyClothCompSettings[arg1_82] = {
			enabled = arg1_82.enabled
		}
	end)

	arg1_75.clothColliderDict = {}
	arg1_75.ladyClothColliderSettings = {}

	local var2_75 = typeof("MagicaCloth.MagicaCapsuleCollider")

	table.IpairsCArray(arg1_75.lady:GetComponentsInChildren(var2_75, true), function(arg0_83, arg1_83)
		arg1_75.clothColliderDict[arg1_83.name] = arg1_83
		arg1_75.ladyClothColliderSettings[arg1_83] = {
			enabled = arg1_83.enabled,
			StartRadius = ReflectionHelp.RefGetProperty(var2_75, "StartRadius", arg1_83),
			EndRadius = ReflectionHelp.RefGetProperty(var2_75, "EndRadius", arg1_83)
		}
	end)
	arg1_75:EnableCloth(arg1_75, false)

	arg1_75.ladyIKRoot = arg1_75.lady:Find("IKLayers")

	eachChild(arg1_75.ladyIKRoot, function(arg0_84)
		setActive(arg0_84, false)
	end)
	GetComponent(arg1_75.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_85, arg1_85)
		if arg1_85.rawPointerPress.transform == arg1_75.ladyCollider then
			arg1_75:emit(var0_0.CLICK_CHARACTER, arg2_75)
		else
			local var0_85 = table.keyof(arg1_75.IKSettings.Colliders, arg1_85.rawPointerPress.transform)

			arg1_75:emit(var0_0.ON_TOUCH_CHARACTER, var0_0.BONE_TO_TOUCH[var0_85] or arg1_85.rawPointerPress.name)
		end
	end)
	arg1_75.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_86)
		if arg1_75.nowState and arg0_86.animatorStateInfo:IsName(arg1_75.nowState) then
			existCall(arg1_75.stateCallback)

			return
		end

		local var0_86 = arg0_86.animatorStateInfo

		for iter0_86, iter1_86 in pairs(arg1_75.animCallbacks) do
			if var0_86:IsName(iter0_86) then
				warning("Active", iter0_86)

				local var1_86 = table.removebykey(arg1_75.animCallbacks, iter0_86)

				existCall(var1_86)

				return
			end
		end

		if arg0_86.stringParameter ~= "" then
			arg1_75:OnAnimationEvent(arg0_86)
		end
	end)

	arg1_75.animEventCallbacks = {}
	arg1_75.animCallbacks = {}
end

function var0_0.SwitchCharacterSkin(arg0_87, arg1_87, arg2_87, arg3_87, arg4_87)
	local var0_87 = arg1_87.skinIdList

	assert(table.contains(var0_87, arg3_87))

	local var1_87 = arg0_87:GetCurrentAnim()
	local var2_87 = arg1_87.skinId
	local var3_87 = arg1_87.skinDict[var2_87].ladyGameobject
	local var4_87 = var3_87.transform.position
	local var5_87 = var3_87.transform.rotation

	setActive(var3_87, false)

	arg1_87.skinId = arg3_87

	setActive(arg1_87.skinDict[arg3_87].ladyGameobject, true)

	arg1_87.ladyGameobject = arg1_87.skinDict[arg3_87].ladyGameobject
	arg1_87.ladyCollider = nil

	arg0_87:InitCharacter(arg1_87, arg2_87)
	arg1_87.ladyAnimator:Play(var1_87, arg1_87.ladyAnimBaseLayerIndex)
	arg1_87.ladyAnimator:Update(0)
	arg1_87.lady:SetPositionAndRotation(var4_87, var5_87)
	existCall(arg4_87)
end

function var0_0.SetCameraLady(arg0_88, arg1_88)
	arg0_88.cameraAim2.LookAt = arg1_88.ladyInterestRoot
	arg0_88.cameras[var0_0.CAMERA.TALK].Follow = arg1_88.ladyInterest
	arg0_88.cameras[var0_0.CAMERA.TALK].LookAt = arg1_88.ladyInterest
	arg0_88.cameraGift.Follow = arg0_88.ladyInterest
	arg0_88.cameraGift.LookAt = arg0_88.ladyInterest
	arg0_88.cameraRole2.LookAt = arg1_88.ladyInterestRoot
	arg0_88.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_88.ladyInterest
	arg0_88.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_88.ladyInterest
end

function var0_0.initNodeCanvas(arg0_89)
	local var0_89 = pg.NodeCanvasMgr.GetInstance()

	var0_89:Active()
	var0_89:RegisterFunc("DistanceTrigger", function(arg0_90)
		arg0_89:emit(var0_0.DISTANCE_TRIGGER, arg0_90, arg0_89.ladyDict[arg0_90].dis)
	end)
	var0_89:RegisterFunc("ShortWaitAction", function(arg0_91)
		arg0_89:DoShortWait(arg0_91)
	end)
	var0_89:RegisterFunc("WatchShortWaitAction", function(arg0_92)
		arg0_89:DoShortWait(arg0_92)
	end)
	var0_89:RegisterFunc("WalkDistanceTrigger", function(arg0_93)
		arg0_89:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_93, arg0_89.ladyDict[arg0_93].dis)
	end)
	var0_89:RegisterFunc("ChangeWatch", function(arg0_94)
		arg0_89:emit(var0_0.CHANGE_WATCH, arg0_94)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_95, arg1_95, arg2_95)
	arg0_95[arg1_95] = arg2_95

	for iter0_95, iter1_95 in pairs(arg0_95.ladyDict) do
		arg0_95:SetBlackboardValue(iter1_95, arg1_95, arg2_95)
	end
end

function var0_0.SetBlackboardValue(arg0_96, arg1_96, arg2_96, arg3_96)
	arg1_96.blackboard = arg1_96.blackboard or {}
	arg1_96.blackboard[arg2_96] = arg3_96

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg2_96, arg3_96, arg1_96.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_97, arg1_97, arg2_97)
	arg1_97.blackboard = arg1_97.blackboard or {}

	return arg1_97.blackboard[arg2_97]
end

function var0_0.didEnter(arg0_98)
	local var0_98 = -21.6 / Screen.height

	arg0_98.joystickDelta = Vector2.zero
	arg0_98.joystickTimer = FrameTimer.New(function()
		local var0_99 = arg0_98.joystickDelta * var0_98
		local var1_99 = var0_99.x
		local var2_99 = var0_99.y

		local function var3_99(arg0_100, arg1_100, arg2_100)
			local var0_100 = arg0_100[arg1_100]

			var0_100.m_InputAxisValue = arg2_100
			arg0_100[arg1_100] = var0_100
		end

		if arg0_98.surroudCamera and not arg0_98.pinchMode then
			var3_99(arg0_98.surroudCamera, "m_XAxis", var1_99)
			var3_99(arg0_98.surroudCamera, "m_YAxis", var2_99)
		end

		arg0_98.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_98.joystickTimer:Start()

	local var1_98 = 1.75

	arg0_98.moveStickTimer = FrameTimer.New(function()
		if not arg0_98.moveStickDraging then
			return
		end

		local var0_101 = arg0_98.moveStickPosition
		local var1_101 = 200
		local var2_101 = (var0_101 - arg0_98.moveStickOrigin):ClampMagnitude(var1_101)
		local var3_101 = var2_101 / var1_101

		arg0_98.moveStickPosition = arg0_98.moveStickOrigin + var2_101

		local var4_101 = Vector3.New(var3_101.x, 0, var3_101.y)
		local var5_101 = arg0_98.mainCameraTF:TransformDirection(var4_101)

		var5_101.y = 0

		local var6_101 = var5_101:Normalize()

		var6_101:Mul(var1_98)

		if isActive(arg0_98.cameras[var0_0.CAMERA.POV]) then
			arg0_98.playerController:SimpleMove(var6_101)

			arg0_98.tweenFOV = true
		elseif isActive(arg0_98.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_98.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_101 * Time.deltaTime)
			arg0_98:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_101:Normalize())
			onNextTick(function()
				local var0_102 = arg0_98.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_102 = math.InverseLerp(arg0_98.restrictedHeightRange[1], arg0_98.restrictedHeightRange[2], var0_102.position.y)

				arg0_98:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_102)
			end)
		end
	end, 1, -1)

	arg0_98.moveStickTimer:Start()

	arg0_98.pinchMode = false
	arg0_98.pinchSize = 0
	arg0_98.pinchValue = 1
	arg0_98.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_103, arg1_103)
		if arg0_98.surroudCamera and isActive(arg0_98.surroudCamera) then
			arg0_98.pinchMode = true
			arg0_98.pinchSize = (arg0_103 - arg1_103):Magnitude()
			arg0_98.pinchNodeOrder = arg1_103.x < arg0_103.x and -1 or 1

			return
		end

		if isActive(arg0_98.cameras[var0_0.CAMERA.POV]) then
			if (arg0_103 - arg1_103):Magnitude() < Screen.height * 0.5 then
				arg0_98.pinchMode = true
				arg0_98.pinchSize = (arg0_103 - arg1_103):Magnitude()
				arg0_98.pinchNodeOrder = arg1_103.x < arg0_103.x and -1 or 1
			end

			return
		end
	end)

	local var2_98 = 0.01

	if IsUnityEditor then
		var2_98 = 0.1
	end

	local var3_98 = var2_98 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_104, arg1_104)
		if not arg0_98.pinchMode then
			return
		end

		local var0_104 = (arg0_104 - arg1_104):Magnitude()
		local var1_104 = arg0_98.pinchSize - var0_104
		local var2_104 = arg0_98.pinchNodeOrder * (arg1_104.x < arg0_104.x and -1 or 1)
		local var3_104 = var1_104 * var3_98 * var2_104

		if isActive(arg0_98.cameras[var0_0.CAMERA.POV]) then
			local var4_104 = 0.5
			local var5_104 = 1

			arg0_98.pinchValue = math.clamp(arg0_98.pinchValue + var3_104, var4_104, var5_104)
			arg0_98.pinchSize = var0_104

			arg0_98:SetPOVFOV(arg0_98.POVOriginalFOV * arg0_98.pinchValue)

			arg0_98.tweenFOV = nil

			return
		end

		if isActive(arg0_98.surroudCamera) and arg0_98.surroudCamera == arg0_98.cameras[var0_0.CAMERA.PHOTO] then
			local var6_104 = 0.5
			local var7_104 = 1

			arg0_98:SetPinchValue(math.clamp(arg0_98.pinchValue + var3_104, var6_104, var7_104))

			arg0_98.pinchSize = var0_104

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_98.pinchMode = false
		arg0_98.pinchSize = 0
	end)

	arg0_98.cameraBlendCallbacks = {}
	arg0_98.activeCMCamera = nil

	function arg0_98.camBrainEvenetHandler.OnBlendStarted(arg0_106)
		if arg0_98.activeCMCamera then
			arg0_98:OnCameraBlendFinished(arg0_98.activeCMCamera)
		end

		local var0_106 = arg0_98.camBrain.ActiveVirtualCamera

		arg0_98.activeCMCamera = var0_106
	end

	function arg0_98.camBrainEvenetHandler.OnBlendFinished(arg0_107)
		arg0_98.activeCMCamera = nil

		arg0_98:OnCameraBlendFinished(arg0_107)
	end

	for iter0_98, iter1_98 in pairs(arg0_98.ladyDict) do
		if iter1_98.tfPendintItem then
			onNextTick(function()
				setParent(iter1_98.tfPendintItem, iter1_98.lady)
			end)
		end

		iter1_98.ladyOwner = GetComponent(iter1_98.lady, "GraphOwner")
		iter1_98.ladyBlackboard = GetComponent(iter1_98.lady, "Blackboard")

		arg0_98:SetBlackboardValue(iter1_98, "groupId", iter0_98)
		onNextTick(function()
			iter1_98.ladyOwner.enabled = true
		end)
	end

	arg0_98.expressionDict = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_98.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_98:ActiveCamera(arg0_98.cameras[var0_0.CAMERA.POV])
	arg0_98:RefreshSlots()

	arg0_98.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_98:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_98.updateHandler)
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

		arg0_113.contextData.inFurnitureName = var0_113 or arg0_113.room:getConfig("default_zone")[1][2]
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
				if not arg0_115.ikHandler then
					return
				end

				local var0_119 = arg0_115.ikHandler.screenPosition
				local var1_119 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_119 = var0_119 - Vector2.New(var1_119.width, var1_119.height) * 0.5

				setAnchoredPosition(arg0_115:GetIKHandTF(), var2_119)

				if Time.time > arg0_115.ikNextCheckStamp then
					arg0_115.ikNextCheckStamp = arg0_115.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_119 = _.detect(arg0_118.readyIKLayers, function(arg0_120)
						return arg0_120:GetControllerPath() == arg0_115.ikHandler.ikData:GetControllerPath()
					end)

					arg0_115:emit(var0_0.ON_IK_STATUS_CHANGED, var3_119:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_115.enableIKTip then
				local var0_118 = Time.time > arg0_115.nextTipIKTime
				local var1_118 = arg0_115:GetIKTipsRootTF()

				if var0_118 then
					local var2_118 = arg0_118.ikConfig
					local var3_118 = #arg0_118.readyIKLayers + #var2_118.touch_data

					UIItemList.StaticAlign(var1_118, var1_118:GetChild(0), var3_118, function(arg0_121, arg1_121, arg2_121)
						if arg0_121 ~= UIItemList.EventUpdate then
							return
						end

						arg1_121 = arg1_121 + 1

						local var0_121
						local var1_121 = Vector2.zero

						if arg1_121 > #arg0_118.readyIKLayers then
							local var2_121 = arg1_121 - #arg0_118.readyIKLayers
							local var3_121 = var2_118.touch_data[var2_121][1]
							local var4_121 = pg.dorm3d_ik_touch[var3_121]

							if #var4_121.scene_item > 0 then
								var0_121 = arg0_115:GetSceneItem(var4_121.scene_item)
							else
								var0_121 = arg0_118.IKSettings.Colliders[var4_121.body]
							end
						else
							local var5_121 = arg0_118.readyIKLayers[arg1_121]
							local var6_121 = var5_121:GetTriggerBoneName()

							var0_121 = var6_121 and arg0_118.IKSettings.Colliders[var6_121] or nil
							var1_121 = var5_121:GetIKTipOffset()
						end

						if var0_121 then
							local function var7_121()
								local var0_122 = arg0_118.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var0_121.position)
								local var1_122 = CameraMgr.instance:Raycast(arg0_118.IKSettings.CameraRaycaster, var0_122)

								if var1_122.Length == 0 then
									return
								end

								return var0_121 == var1_122[0].gameObject.transform
							end
						end

						if var0_121 then
							setLocalPosition(arg2_121, arg0_115:GetLocalPosition(arg0_115:GetScreenPosition(var0_121.position, arg0_118.IKSettings.CameraRaycaster.eventCamera), var1_118) + var1_121)

							local var8_121 = var0_121.position
							local var9_121 = var0_121:GetComponent(typeof(UnityEngine.Collider))

							if var9_121 then
								var8_121 = var9_121.bounds.center
							end

							setLocalPosition(arg2_121, arg0_115:GetLocalPosition(arg0_115:GetScreenPosition(var8_121), var1_118) + var1_121)
						end

						setActive(arg2_121, var0_121)
					end)
				end

				setActive(var1_118, var0_118)
				setActive(arg0_115.ikTextTipsRoot, var0_118)
			end
		end)(arg0_115.ladyDict[arg0_115.apartment:GetConfigID()])
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

function var0_0.RefreshSlots(arg0_129, arg1_129)
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

function var0_0.WalkByRootMotionLoop(arg0_159, arg1_159, arg2_159)
	if arg1_159.pathPending then
		arg2_159:SetFloat("Speed", 0)

		return
	end

	arg2_159:SetFloat("Speed", 1)

	local var0_159 = arg1_159.path.corners

	if var0_159.Length > 1 then
		local var1_159 = var0_159[1] - arg1_159.transform.position

		var1_159.y = 0

		local var2_159 = Quaternion.LookRotation(var1_159)
		local var3_159 = arg1_159.transform.rotation
		local var4_159 = 1
		local var5_159 = Damp(1, var4_159, Time.deltaTime)

		arg1_159.transform.rotation = Quaternion.Lerp(var3_159, var2_159, var5_159)
	end
end

function var0_0.ActiveCamera(arg0_160, arg1_160)
	local var0_160 = isActive(arg1_160)

	table.Foreach(arg0_160.cameras, function(arg0_161, arg1_161)
		setActive(arg1_161, arg1_161 == arg1_160)
	end)

	if var0_160 then
		arg0_160:OnCameraBlendFinished(arg1_160)
	end
end

function var0_0.ShowBlackScreen(arg0_162, arg1_162, arg2_162)
	local var0_162 = arg0_162.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_162 and 0 or 0.3
	}

	setImageColor(arg0_162.blackLayer, Color.NewHex(var0_162.color))
	setActive(arg0_162.blackLayer, true)
	setCanvasGroupAlpha(arg0_162.blackLayer, arg1_162 and 0 or 1)
	arg0_162:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_162 then
			setActive(arg0_162.blackLayer, false)
		end

		existCall(arg2_162)
	end, GetComponent(arg0_162.blackLayer, typeof(CanvasGroup)), arg1_162 and 1 or 0, var0_162.time):setDelay(var0_162.delay)
end

function var0_0.RegisterOrbits(arg0_164, arg1_164)
	arg0_164 = arg0_164.scene
	arg0_164.orbits = {
		original = arg1_164.m_Orbits
	}
	arg0_164.orbits.current = _.range(3):map(function(arg0_165)
		local var0_165 = arg0_164.orbits.original[arg0_165 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_165.m_Height, var0_165.m_Radius)
	end)
	arg0_164.surroudCamera = arg1_164
end

function var0_0.SetCameraObrits(arg0_166)
	local var0_166 = arg0_166.surroudCamera

	if not var0_166 then
		return
	end

	local var1_166 = arg0_166.orbits.original[1]

	for iter0_166 = 0, #arg0_166.orbits.current - 1 do
		local var2_166 = arg0_166.orbits.current[iter0_166 + 1]
		local var3_166 = arg0_166.orbits.original[iter0_166]

		var2_166.m_Height = math.lerp(var1_166.m_Height, var3_166.m_Height, arg0_166.pinchValue)
		var2_166.m_Radius = var3_166.m_Radius * arg0_166.pinchValue
	end

	var0_166.m_Orbits = arg0_166.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_167)
	arg0_167 = arg0_167.scene

	local var0_167 = arg0_167.surroudCamera

	if not var0_167 then
		return
	end

	for iter0_167 = 0, #arg0_167.orbits.current - 1 do
		local var1_167 = arg0_167.orbits.current[iter0_167 + 1]
		local var2_167 = arg0_167.orbits.original[iter0_167]

		var1_167.m_Height = var2_167.m_Height
		var1_167.m_Radius = var2_167.m_Radius
	end

	var0_167.m_Orbits = arg0_167.orbits.current
	arg0_167.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_168, arg1_168, arg2_168)
	local var0_168 = {
		base = function(arg0_169)
			arg0_168:RegisterCameraBlendFinished(arg0_168.cameras[var0_0.CAMERA.POV], arg0_169)
			arg0_168:ActiveCamera(arg0_168.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_170)
			assert(arg0_168.apartment)
			arg0_168:SyncInterestTransform(arg0_168.ladyDict[arg0_168.apartment:GetConfigID()])
			arg0_168:SetCameraLady(arg0_168.ladyDict[arg0_168.apartment:GetConfigID()])
			arg0_168:RegisterCameraBlendFinished(arg0_168.cameras[var0_0.CAMERA.ROLE], arg0_170)
			arg0_168:ActiveCamera(arg0_168.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_171)
			arg0_168:RegisterCameraBlendFinished(arg0_168.cameras[var0_0.CAMERA.POV], arg0_171)
			arg0_168:ActiveCamera(arg0_168.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_172)
			arg0_172()
		end,
		gift = function(arg0_173)
			assert(arg0_168.apartment)
			arg0_168:SetCameraLady(arg0_168.ladyDict[arg0_168.apartment:GetConfigID()])
			arg0_168:RegisterCameraBlendFinished(arg0_168.cameras[var0_0.CAMERA.GIFT], arg0_173)
			arg0_168:ActiveCamera(arg0_168.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_174)
			assert(arg0_168.apartment)
			arg0_168:SetCameraLady(arg0_168.ladyDict[arg0_168.apartment:GetConfigID()])

			arg0_168.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_168.cameraRole.transform.position

			arg0_168:RegisterCameraBlendFinished(arg0_168.cameras[var0_0.CAMERA.ROLE2], arg0_174)
			arg0_168:ActiveCamera(arg0_168.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_175)
			assert(arg0_168.apartment)
			arg0_168:SetCameraLady(arg0_168.ladyDict[arg0_168.apartment:GetConfigID()])
			arg0_168:SyncInterestTransform(arg0_168.ladyDict[arg0_168.apartment:GetConfigID()])
			arg0_168:RegisterCameraBlendFinished(arg0_168.cameras[var0_0.CAMERA.TALK], arg0_175)
			arg0_168:ActiveCamera(arg0_168.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_168 = {}

	table.insert(var1_168, function(arg0_176)
		switch(arg1_168, var0_168, arg0_176, arg0_176)
	end)
	seriesAsync(var1_168, arg2_168)
end

function var0_0.GetSceneItem(arg0_177, arg1_177)
	local var0_177

	if string.find(arg1_177, "fbx/") == 1 then
		var0_177 = arg0_177.modelRoot:Find(arg1_177)
	elseif string.find(arg1_177, "FurnitureSlots/") == 1 then
		arg1_177 = string.gsub(arg1_177, "^FurnitureSlots/", "", 1)
		var0_177 = arg0_177.slotRoot:Find(arg1_177)
	end

	if not var0_177 then
		warning(string.format("Missing scene item path: %s", arg1_177))
	end

	return var0_177
end

function var0_0.SetIKStatus(arg0_178, arg1_178, arg2_178, arg3_178)
	warning("Set IKStatus " .. (arg2_178.id or "NIL"))

	arg0_178.enableIKTip = true

	arg0_178:ResetIKTipTimer()
	setActive(arg1_178.ladyCollider, false)
	_.each(arg1_178.ladyTouchColliders, function(arg0_179)
		setActive(arg0_179, true)
	end)

	arg0_178.blockIK = nil
	arg1_178.ikActionDict = {}
	arg1_178.readyIKLayers = {}
	arg1_178.IKSettings = {
		Colliders = arg1_178.ladyColliders,
		CameraRaycaster = arg0_178.sceneRaycaster
	}

	local var0_178 = _.map(arg2_178.ik_id, function(arg0_180)
		local var0_180 = Dorm3dIK.New({
			configId = arg0_180[1]
		})
		local var1_180 = arg0_180[3]
		local var2_180 = var1_180[1]
		local var3_180 = switch(var2_180, {
			function(arg0_181, arg1_181)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_183, arg1_183)
				return arg0_183
			end,
			function(arg0_184, arg1_184)
				return arg0_184
			end,
			function(arg0_185, arg1_185, arg2_185, arg3_185)
				return arg0_185
			end,
			function(arg0_186)
				return 0
			end
		}, function(arg0_187)
			return var2_180(arg0_187) == "number" and arg0_187 or 0
		end, unpack(var1_180, 2))

		table.insert(arg1_178.readyIKLayers, var0_180)

		arg1_178.ikActionDict[var0_180:GetControllerPath()] = var1_180

		local var4_180 = var0_180:GetSubTargets()
		local var5_180 = var0_180:GetPlaneRotations()
		local var6_180 = var0_180:GetPlaneScales()
		local var7_180 = _.map(_.range(#var4_180), function(arg0_188)
			return {
				name = var4_180[arg0_188][1],
				planeRot = var5_180[arg0_188],
				planeScale = var6_180[arg0_188]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_180:getConfig("trigger_param")[2],
			controllerName = var0_180:GetControllerPath(),
			subTargets = var7_180,
			actionType = var0_180:GetActionTriggerParams()[1],
			controlRect = var0_180:GetRect(),
			actionRect = var0_180:GetTriggerRect(),
			backTime = var0_180:GetRevertTime(),
			actionRevertTime = var3_180
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_178.ladyIKRoot, arg1_178.ladyBoneMaps)
	arg0_178:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var0_178)

	local var1_178 = _.map(arg2_178.touch_data, function(arg0_189)
		return arg0_189[1]
	end)

	table.Foreach(var1_178, function(arg0_190, arg1_190)
		local var0_190 = pg.dorm3d_ik_touch[arg1_190]

		if #var0_190.scene_item == 0 then
			return
		end

		local var1_190 = arg0_178:GetSceneItem(var0_190.scene_item)

		if not var1_190 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_190, var0_190.scene_item))

			return
		end

		if IsNil(GetComponent(var1_190, typeof(UnityEngine.Collider))) then
			go(var1_190):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_190 = GetOrAddComponent(var1_190, typeof(EventTriggerListener))

		var2_190.enabled = true

		var2_190:AddPointClickFunc(function()
			arg0_178.blockIK = true

			local var0_191 = arg2_178.touch_data[arg0_190]
			local var1_191, var2_191, var3_191 = unpack(var0_191)

			arg0_178:TouchModePointAction(arg1_178, var1_191, unpack(var3_191))(function()
				arg0_178.enableIKTip = true

				arg0_178:ResetIKTipTimer()

				arg0_178.blockIK = nil
			end)
		end)
	end)

	arg0_178.camBrain.enabled = false

	if arg0_178.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_178.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_178.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var2_178 = arg0_178.cameraRoot:Find(arg2_178.ik_camera)

	assert(var2_178, "Missing IKCamera")

	arg0_178.cameras[var0_0.CAMERA.IK_WATCH] = var2_178

	arg0_178:ActiveCamera(arg0_178.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_178.camBrain.enabled = true

	local var3_178 = var2_178:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var3_178 then
		arg0_178:RegisterOrbits(var3_178)
	end

	arg0_178:SwitchAnim(arg1_178, arg2_178.character_action)
	arg0_178:SettingHeadAimIK(arg1_178, arg2_178.head_track)
	arg0_178:EnableCloth(arg1_178, false)
	arg0_178:EnableCloth(arg1_178, arg2_178.use_cloth, arg2_178.cloth_colliders)
	;(function()
		local var0_193 = arg2_178.enter_scene_anim
		local var1_193 = {}

		if var0_193 and #var0_193 > 0 then
			table.Ipairs(var0_193, function(arg0_194, arg1_194)
				arg0_178:PlaySceneItemAnim(arg1_194[1], arg1_194[2])
				table.insert(var1_193, arg1_194[1])
			end)
		end

		arg0_178:ResetSceneItemAnimators(var1_193)
	end)()
	;(function()
		local var0_195 = arg2_178.enter_extra_item
		local var1_195 = {}

		if var0_195 and #var0_195 > 0 then
			table.Ipairs(var0_195, function(arg0_196, arg1_196)
				local var0_196 = arg1_196[3] and Vector3.New(unpack(arg1_196[3]))
				local var1_196 = arg1_196[4] and Quaternion.Euler(unpack(arg1_196[4]))

				arg0_178:LoadCharacterExtraItem(arg1_178, arg1_196[1], arg1_196[2], var0_196, var1_196)
				table.insert(var1_195, arg1_196[1])
			end)
		end

		arg0_178:ResetCharacterExtraItem(arg1_178, var1_195)
	end)()
	eachChild(arg0_178.ikTextTipsRoot, function(arg0_197)
		setActive(arg0_197, false)
	end)
	_.each(arg1_178.readyIKLayers, function(arg0_198)
		local var0_198 = arg0_198:getConfig("tip_text")

		if not var0_198 or #var0_198 == 0 then
			return
		end

		local var1_198 = arg0_178.ikTextTipsRoot:Find(var0_198)

		if not IsNil(var1_198) then
			setActive(var1_198, true)
		end
	end)
	onNextTick(function()
		local var0_199 = arg0_178.furnitures:Find(arg2_178.character_position)

		arg1_178.lady.position = var0_199:Find("StayPoint").position
		arg1_178.lady.rotation = var0_199:Find("StayPoint").rotation

		existCall(arg3_178)
	end)
end

function var0_0.ExitIKStatus(arg0_200, arg1_200, arg2_200, arg3_200)
	arg0_200.enableIKTip = false

	setActive(arg1_200.ladyCollider, true)
	_.each(arg1_200.ladyTouchColliders, function(arg0_201)
		setActive(arg0_201, false)
	end)

	arg0_200.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_200.ikActionDict = nil
	arg1_200.readyIKLayers = nil

	setActive(arg0_200:GetIKTipsRootTF(), false)

	local var0_200 = _.map(arg2_200.touch_data or {}, function(arg0_202)
		return arg0_202[1]
	end)

	table.Foreach(var0_200, function(arg0_203, arg1_203)
		local var0_203 = pg.dorm3d_ik_touch[arg1_203]

		if #var0_203.scene_item == 0 then
			return
		end

		local var1_203 = arg0_200.modelRoot:Find(var0_203.scene_item)

		if not var1_203 then
			return
		end

		local var2_203 = GetOrAddComponent(var1_203, typeof(EventTriggerListener))

		var2_203:ClearEvents()

		var2_203.enabled = false
	end)
	arg0_200:RevertCameraOrbit()
	setActive(arg0_200.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_200.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_200:EnableCloth(arg1_200, false)
	arg0_200:ResetHeadAimIK(arg1_200)
	arg0_200:SwitchAnim(arg1_200, arg2_200.character_action)
	arg0_200:ResetSceneItemAnimators()
	arg0_200:ResetCharacterExtraItem(arg1_200)
	onNextTick(function()
		if arg2_200.character_position then
			arg1_200.ladyActiveZone = arg2_200.character_position
		else
			arg1_200.ladyActiveZone = arg1_200.ladyBaseZone
		end

		arg0_200:ChangeCharacterPosition(arg1_200)
		arg0_200:TriggerLadyDistance()
		arg0_200:CheckInSector()
		existCall(arg3_200)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_205, arg1_205, arg2_205, arg3_205, arg4_205, arg5_205)
	warning("Set IKStatus " .. (arg3_205 or "NIL"))

	arg0_205.enableIKTip = true

	arg0_205:ResetIKTipTimer()

	arg0_205.blockIK = nil

	local var0_205 = pg.dorm3d_ik_timeline_status[arg3_205]

	arg1_205.readyIKLayers = {}
	arg1_205.IKSettings = {
		CameraRaycaster = arg4_205:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_205.IKSettings.CameraRaycaster)

	local var1_205 = {}

	table.IpairsCArray(arg2_205:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_206, arg1_206)
		if arg1_206:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_206)

		local var0_206 = child.name
		local var1_206 = var0_206 and string.find(var0_206, "Collider") or -1

		if var1_206 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_206)

			return
		end

		local var2_206 = string.sub(var0_206, 1, var1_206 - 1)

		if var2_206 == "Body" then
			setActive(child, false)

			return
		end

		if var0_0.BONE_TO_TOUCH[var2_206] == nil then
			return
		end

		var1_205[var2_206] = child

		setActive(child, true)
	end)

	arg1_205.IKSettings.Colliders = var1_205
	arg1_205.ikTimelineMode = true

	local var2_205 = _.map(var0_205.ik_id, function(arg0_207)
		local var0_207 = Dorm3dIK.New({
			configId = arg0_207
		})

		table.insert(arg1_205.readyIKLayers, var0_207)

		local var1_207 = var0_207:GetSubTargets()
		local var2_207 = var0_207:GetPlaneRotations()
		local var3_207 = var0_207:GetPlaneScales()
		local var4_207 = _.map(_.range(#var1_207), function(arg0_208)
			return {
				name = var1_207[arg0_208][1],
				planeRot = var2_207[arg0_208],
				planeScale = var3_207[arg0_208]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_207:getConfig("trigger_param")[2],
			controllerName = var0_207:GetControllerPath(),
			subTargets = var4_207,
			actionType = var0_207:GetActionTriggerParams()[1],
			controlRect = var0_207:GetRect(),
			actionRect = var0_207:GetTriggerRect(),
			backTime = var0_207:GetRevertTime(),
			actionRevertTime = var0_207:GetActionRevertTime(),
			timelineActionEvent = var0_207:GetTimelineAction()
		})
	end)
	local var3_205 = arg2_205.transform:Find("IKLayers")
	local var4_205 = {}
	local var5_205 = {}

	table.Foreach(var1_0, function(arg0_209, arg1_209)
		var5_205[arg1_209] = arg0_209
	end)

	local var6_205 = arg2_205.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var6_205, function(arg0_210, arg1_210)
		if var5_205[arg1_210.name] then
			var4_205[var5_205[arg1_210.name]] = arg1_210
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var3_205, var4_205)
	arg0_205:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_205)
	existCall(arg5_205)
end

function var0_0.ExitIKTimelineStatus(arg0_211, arg1_211, arg2_211)
	arg0_211.enableIKTip = false
	arg0_211.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_211.readyIKLayers = nil
	arg1_211.IKSettings = nil

	setActive(arg0_211:GetIKTipsRootTF(), false)
	existCall(arg2_211)
end

function var0_0.EnableIKLayer(arg0_212, arg1_212)
	local var0_212 = arg0_212.ladyDict[arg0_212.apartment:GetConfigID()]

	if #arg1_212:GetHeadTrackPath() > 0 then
		arg0_212:SettingHeadAimIK(var0_212, {
			2,
			arg1_212:GetHeadTrackPath()
		}, true)
	end

	local var1_212 = arg1_212:GetTriggerFaceAnim()

	if #var1_212 > 0 then
		arg0_212:PlayFaceAnim(var0_212, var1_212)
	end

	setActive(arg0_212:GetIKHandTF(), true)
	eachChild(arg0_212:GetIKHandTF(), function(arg0_213)
		setActive(arg0_213, false)
	end)
	arg0_212:StopIKHandTimer()
	setActive(arg0_212:GetIKHandTF():Find("Begin"), true)

	arg0_212.ikHandTimer = Timer.New(function()
		setActive(arg0_212:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_212:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg0_212.ikHandTimer:Start()

	if not var0_212.ikTimelineMode then
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_212.apartment.configId, arg0_212.apartment.level, var0_212.ikConfig.character_action, arg1_212:GetTriggerParams()[2], arg0_212.room:GetConfigID()))
	end
end

function var0_0.DeactiveIKLayer(arg0_215, arg1_215)
	local var0_215 = arg0_215.ladyDict[arg0_215.apartment:GetConfigID()]

	if not var0_215.ikTimelineMode and #arg1_215:GetHeadTrackPath() > 0 then
		arg0_215:SettingHeadAimIK(var0_215, var0_215.ikConfig.head_track)
	end

	arg0_215:StopIKHandTimer()
	setActive(arg0_215:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_215:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_215:GetIKHandTF():Find("End"), true)

	arg0_215.ikHandTimer = Timer.New(function()
		setActive(arg0_215:GetIKHandTF():Find("End"), false)
		setActive(arg0_215:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_215.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_217)
	if not arg0_217.ikHandTimer then
		return
	end

	arg0_217.ikHandTimer:Stop()

	arg0_217.ikHandTimer = nil
end

function var0_0.PlayIKRevert(arg0_218, arg1_218, arg2_218, arg3_218)
	local var0_218 = Time.time

	function arg0_218.ikRevertHandler()
		local var0_219 = Time.time - var0_218

		_.each(arg1_218.activeIKLayers, function(arg0_220)
			local var0_220 = 1

			if arg2_218 > 0 then
				var0_220 = var0_219 / arg2_218
			end

			local var1_220 = arg1_218.cacheIKInfos[arg0_220].solvers
			local var2_220 = arg1_218.cacheIKInfos[arg0_220].weights

			table.Foreach(var1_220, function(arg0_221, arg1_221)
				arg1_221.IKPositionWeight = math.lerp(var2_220[arg0_221], 0, var0_220)
			end)
		end)

		if var0_219 >= arg2_218 then
			arg0_218:ResetActiveIKs(arg1_218)

			arg0_218.ikRevertHandler = nil

			existCall(arg3_218)
		end
	end

	arg0_218.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_222, arg1_222)
	table.insertto(arg0_222.activeIKLayers, _.keys(arg0_222.holdingStatus))
	table.clear(arg0_222.holdingStatus)
	_.each(arg1_222.activeIKLayers, function(arg0_223)
		local var0_223 = arg0_223:GetControllerPath()
		local var1_223 = arg1_222.ladyIKRoot:Find(var0_223):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_223, false)

		local var2_223 = arg1_222.cacheIKInfos[arg0_223].solvers
		local var3_223 = arg1_222.cacheIKInfos[arg0_223].weights

		table.Foreach(var2_223, function(arg0_224, arg1_224)
			arg1_224.IKPositionWeight = var3_223[arg0_224]
		end)
	end)
	table.clear(arg1_222.activeIKLayers)
end

function var0_0.ResetIKTipTimer(arg0_225)
	if not arg0_225.enableIKTip then
		return
	end

	arg0_225.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableCurrentHeadIK(arg0_226, arg1_226)
	local var0_226 = arg0_226.ladyDict[arg0_226.apartment:GetConfigID()]

	arg0_226:EnableHeadIK(var0_226, arg1_226)
end

function var0_0.EnableHeadIK(arg0_227, arg1_227, arg2_227)
	arg1_227.ladyHeadIKComp.enableIk = arg2_227
end

function var0_0.SettingHeadAimIK(arg0_228, arg1_228, arg2_228, arg3_228)
	local var0_228

	if arg2_228[1] == 1 then
		var0_228 = arg0_228.mainCameraTF:Find("AimTarget")
	elseif arg2_228[1] == 2 then
		table.IpairsCArray(arg1_228.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_229, arg1_229)
			if arg1_229.name ~= arg2_228[2] then
				return
			end

			var0_228 = arg1_229
		end)
	end

	arg1_228.ladyHeadIKComp.AimTarget = var0_228

	if not arg3_228 and arg2_228[3] then
		arg1_228.ladyHeadIKComp.BodyWeight = arg2_228[3]
	end

	if not arg3_228 and arg2_228[4] then
		arg1_228.ladyHeadIKComp.HeadWeight = arg2_228[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_230, arg1_230)
	arg1_230.ladyHeadIKComp.AimTarget = arg0_230.mainCameraTF:Find("AimTarget")
	arg1_230.ladyHeadIKComp.HeadWeight = arg1_230.ladyHeadIKData.HeadWeight
	arg1_230.ladyHeadIKComp.BodyWeight = arg1_230.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_231, arg1_231)
	for iter0_231, iter1_231 in pairs(arg0_231.ladyDict) do
		if iter0_231 ~= arg1_231 then
			arg0_231:HideCharacterBylayer(iter1_231)
		end
	end
end

function var0_0.RevertCharacter(arg0_232, arg1_232)
	for iter0_232, iter1_232 in pairs(arg0_232.ladyDict) do
		if iter0_232 ~= arg1_232 then
			arg0_232:RevertCharacterBylayer(iter1_232)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_233, arg1_233)
	local var0_233 = "Bip001"
	local var1_233 = arg1_233.lady:Find("all")

	for iter0_233 = 0, var1_233.childCount - 1 do
		local var2_233 = var1_233:GetChild(iter0_233)

		if var2_233.name ~= var0_233 then
			pg.ViewUtils.SetLayer(var2_233, Layer.Environment3D)
		end
	end

	if arg1_233.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_233.tfPendintItem, Layer.Environment3D)
	end

	if arg1_233.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_233.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg1_233.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_234, arg1_234)
	local var0_234 = "Bip001"
	local var1_234 = arg1_234.lady:Find("all")

	for iter0_234 = 0, var1_234.childCount - 1 do
		local var2_234 = var1_234:GetChild(iter0_234)

		if var2_234.name ~= var0_234 then
			pg.ViewUtils.SetLayer(var2_234, Layer.Default)
		end
	end

	if arg1_234.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_234.tfPendintItem, Layer.Default)
	end

	if arg1_234.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_234.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg1_234.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_235)
	arg0_235:SetAllBlackbloardValue("inLockLayer", true)
	arg0_235:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_236)
	arg0_236:HideFurnitureSlots()

	local var0_236 = arg0_236.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_237)
			arg0_236:emit(var0_0.SHOW_BLOCK)
			arg0_236:ShowBlackScreen(true, arg0_237)
		end,
		function(arg0_238)
			arg0_236:RevertCharacter()
			arg0_236:SetAllBlackbloardValue("inLockLayer", false)
			arg0_236:RegisterCameraBlendFinished(var0_236, arg0_238)
			arg0_236:ActiveCamera(var0_236)
		end,
		function(arg0_239)
			arg0_236:ShowBlackScreen(false, arg0_239)
		end
	}, function()
		arg0_236:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_236:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_241, arg1_241)
	local var0_241 = arg0_241:GetFurnitureByName(arg1_241:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_241.cameraFurnitureWatch and arg0_241.cameraFurnitureWatch ~= var0_241 then
		arg0_241:UnRegisterCameraBlendFinished(arg0_241.cameraFurnitureWatch)
		setActive(arg0_241.cameraFurnitureWatch, false)
	end

	arg0_241.cameraFurnitureWatch = var0_241
	arg0_241.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_241.cameraFurnitureWatch

	arg0_241:RegisterCameraBlendFinished(arg0_241.cameraFurnitureWatch, function()
		arg0_241:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_241:emit(var0_0.SHOW_BLOCK)
	arg0_241:ActiveCamera(arg0_241.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_243)
	if arg0_243.displaySlots then
		arg0_243:UpdateDisplaySlots({})
		table.Foreach(arg0_243.displaySlots, function(arg0_244, arg1_244)
			local var0_244 = arg1_244.trans

			if IsNil(var0_244:Find("Selector")) then
				return
			end

			setActive(var0_244:Find("Selector"), false)
		end)

		arg0_243.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_245, arg1_245)
	arg0_245:HideFurnitureSlots()

	arg0_245.displaySlots = {}

	_.each(arg1_245, function(arg0_246)
		arg0_245.displaySlots[arg0_246] = arg0_245.slotDict[arg0_246]

		if not arg0_245.displaySlots[arg0_246] then
			errorMsg("Slot " .. arg0_246 .. " Not Binding Scene Object")

			return
		end

		local var0_246 = arg0_245.displaySlots[arg0_246].trans

		if var0_246:Find("Selector") then
			setActive(var0_246:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_247, arg1_247)
	table.Foreach(arg0_247.displaySlots, function(arg0_248, arg1_248)
		local var0_248 = arg1_248.trans

		if not IsNil(var0_248:Find("Selector")) then
			setActive(var0_248:Find("Selector/Normal"), arg1_247[arg0_248] == 0)
			setActive(var0_248:Find("Selector/Active"), arg1_247[arg0_248] == 1)
			setActive(var0_248:Find("Selector/Ban"), arg1_247[arg0_248] == 2)
		end

		local var1_248 = arg0_247.slotDict[arg0_248].model
		local var2_248 = arg0_247.slotDict[arg0_248].displayModelName

		if var2_248 and var2_248 ~= "" then
			var1_248 = var0_248:GetChild(var0_248.childCount - 1)
		end

		local function var3_248(arg0_249, arg1_249)
			local var0_249 = arg0_249:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_249, function(arg0_250, arg1_250)
				local var0_250 = arg1_250.material

				if var0_250 and var0_250:HasProperty("_FinalTint") then
					var0_250:SetColor("_FinalTint", arg1_249)
				end
			end)
		end

		if var1_248 then
			if arg1_247[arg0_248] == 1 then
				var3_248(var1_248, Color.NewHex("3F83AE73"))
			else
				var3_248(var1_248, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_251, arg1_251, arg2_251)
	arg0_251:SetAllBlackbloardValue("inLockLayer", true)
	arg0_251:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_252)
			arg0_251:TempHideUI(true, arg0_252)
		end,
		function(arg0_253)
			arg0_251:ShowBlackScreen(true, arg0_253)
		end,
		function(arg0_254)
			local var0_254 = arg0_251.apartment:GetConfigID()
			local var1_254 = arg0_251.ladyDict[var0_254]

			arg0_251:SwitchAnim(var1_254, arg2_251)
			var1_254.ladyAnimator:Update(0)
			var1_254:ResetCharPoint(var1_254, arg1_251:GetWatchCameraName())
			arg0_251:SyncInterestTransform(var1_254)
			setActive(var1_254.ladySafeCollider, true)
			arg0_251:HideCharacter(var0_254)

			local var2_254 = arg0_251.cameras[var0_0.CAMERA.PHOTO]
			local var3_254 = var2_254.m_XAxis

			var3_254.Value = 180
			var2_254.m_XAxis = var3_254

			local var4_254 = var2_254.m_YAxis

			var4_254.Value = 0.7
			var2_254.m_YAxis = var4_254
			arg0_251.pinchValue = 1

			arg0_251:RegisterOrbits(arg0_251.cameras[var0_0.CAMERA.PHOTO])
			arg0_251:SetCameraObrits()
			arg0_251:RegisterCameraBlendFinished(var2_254, arg0_254)
			arg0_251:ActiveCamera(var2_254)
		end,
		function(arg0_255)
			arg0_251:ShowBlackScreen(false, arg0_255)
		end
	}, function()
		arg0_251:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_257)
	arg0_257:emit(var0_0.SHOW_BLOCK)
	arg0_257:EnableJoystick(false)
	seriesAsync({
		function(arg0_258)
			arg0_257:ShowBlackScreen(true, arg0_258)
		end,
		function(arg0_259)
			arg0_257:RevertCameraOrbit()

			local var0_259 = arg0_257.ladyDict[arg0_257.apartment:GetConfigID()]

			arg0_257:SwitchAnim(var0_259, var0_0.ANIM.IDLE)
			setActive(var0_259.ladySafeCollider, false)
			onNextTick(function()
				arg0_257:ChangeCharacterPosition(var0_259)
			end)

			if arg0_257.contextData.photoFreeMode then
				arg0_257:EnablePOVLayer(false)
				setActive(arg0_257.restrictedBox, false)

				arg0_257.contextData.photoFreeMode = nil
			end

			local var1_259 = arg0_257.cameras[var0_0.CAMERA.POV]

			arg0_257:RegisterCameraBlendFinished(var1_259, arg0_259)
			arg0_257:ActiveCamera(var1_259)
		end,
		function(arg0_261)
			arg0_257:RevertCharacter(arg0_257.apartment:GetConfigID())
			arg0_257:ShowBlackScreen(false, arg0_261)
		end
	}, function()
		arg0_257:RefreshSlots()
		arg0_257:SetAllBlackbloardValue("inLockLayer", false)
		arg0_257:emit(var0_0.HIDE_BLOCK)
		arg0_257:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_257:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_263, arg1_263, arg2_263, arg3_263)
	arg0_263:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_264)
			arg0_263:ShowBlackScreen(true, arg0_264)
		end,
		function(arg0_265)
			local var0_265 = arg0_263.ladyDict[arg0_263.apartment:GetConfigID()]

			arg0_263:SwitchAnim(var0_265, arg2_263)
			onNextTick(function()
				arg0_263:ResetCharPoint(var0_265, arg1_263:GetWatchCameraName())
				arg0_263:SyncInterestTransform(var0_265)

				if arg0_263.contextData.photoFreeMode then
					arg0_263.camBrain.enabled = false

					arg0_263:SwitchPhotoCamera()

					arg0_263.camBrain.enabled = true

					onDelayTick(function()
						arg0_263.camBrain.enabled = false

						arg0_263:SwitchPhotoCamera()

						arg0_263.camBrain.enabled = true
					end, 0.1)
				end

				arg0_265()
			end)
		end,
		function(arg0_268)
			arg0_263:ShowBlackScreen(false, arg0_268)
		end
	}, function()
		arg0_263:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_263)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_270)
	if not arg0_270.contextData.photoFreeMode then
		arg0_270:EnableJoystick(false)
		arg0_270:EnablePOVLayer(true)
		setActive(arg0_270.restrictedBox, true)

		local var0_270 = arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_270.transform.position = arg0_270.mainCameraTF.position

		local var1_270 = arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_270 = arg0_270.mainCameraTF.rotation:ToEulerAngles()
		local var3_270 = var1_270.m_HorizontalAxis

		var3_270.Value = var2_270.y
		var1_270.m_HorizontalAxis = var3_270

		local var4_270 = var1_270.m_VerticalAxis

		var4_270.Value = arg0_270:GetNearestAngle(var2_270.x, var4_270.m_MinValue, var4_270.m_MaxValue)
		var1_270.m_VerticalAxis = var4_270

		local var5_270 = math.InverseLerp(arg0_270.restrictedHeightRange[1], arg0_270.restrictedHeightRange[2], var0_270.position.y)

		arg0_270:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_270)
		arg0_270:ActiveCamera(arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_270:EnableJoystick(true)
		arg0_270:EnablePOVLayer(false)
		setActive(arg0_270.restrictedBox, false)
		arg0_270:ActiveCamera(arg0_270.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_270.contextData.photoFreeMode = not arg0_270.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_271, arg1_271)
	local var0_271 = math.lerp(arg0_271.restrictedHeightRange[1], arg0_271.restrictedHeightRange[2], arg1_271)
	local var1_271 = arg0_271.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_271:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_271 - var1_271.position.y, 0))
	onNextTick(function()
		local var0_272 = math.InverseLerp(arg0_271.restrictedHeightRange[1], arg0_271.restrictedHeightRange[2], var1_271.position.y)

		arg0_271:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_272)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_273)
	local var0_273 = arg0_273.cameras[var0_0.CAMERA.PHOTO]
	local var1_273 = var0_273.m_XAxis

	var1_273.Value = 180
	var0_273.m_XAxis = var1_273

	local var2_273 = var0_273.m_YAxis

	var2_273.Value = 0.7
	var0_273.m_YAxis = var2_273
end

function var0_0.ResetCurrentCharPoint(arg0_274, arg1_274)
	local var0_274 = arg0_274.ladyDict[arg0_274.apartment:GetConfigID()]

	arg0_274:ResetCharPoint(var0_274, arg1_274)
end

function var0_0.ResetCharPoint(arg0_275, arg1_275, arg2_275)
	local var0_275 = arg0_275.furnitures:Find(arg2_275 .. "/StayPoint")

	arg1_275.lady.position = var0_275.position
	arg1_275.lady.rotation = var0_275.rotation
end

function var0_0.GetNearestAngle(arg0_276, arg1_276, arg2_276, arg3_276)
	if arg3_276 < arg2_276 then
		arg3_276 = arg3_276 + 360
	end

	if arg2_276 <= arg1_276 and arg1_276 <= arg3_276 then
		return arg1_276
	end

	local var0_276 = (arg2_276 + arg3_276) / 2

	arg1_276 = var0_276 - Mathf.DeltaAngle(arg1_276, var0_276)
	arg1_276 = math.clamp(arg1_276, arg2_276, arg3_276)

	return arg1_276
end

function var0_0.PlayTimeline(arg0_277, arg1_277, arg2_277)
	local var0_277 = {}

	if arg0_277.waitForTimeline then
		table.insert(var0_277, function(arg0_278)
			local var0_278 = arg0_277.waitForTimeline

			arg0_277.waitForTimeline = nil

			var0_278()
			arg0_278()
		end)
	end

	table.insert(var0_277, function(arg0_279)
		arg0_277:LoadTimelineScene(arg1_277.name, false, arg0_279)
	end)

	if arg1_277.scene and arg1_277.sceneRoot then
		table.insert(var0_277, function(arg0_280)
			arg0_277:ChangeArtScene(arg1_277.scene .. "|" .. arg1_277.sceneRoot, arg0_280)
		end)
	end

	table.insert(var0_277, function(arg0_281)
		local var0_281 = GameObject.Find("[actor]").transform
		local var1_281 = var0_281:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var1_281, function(arg0_282, arg1_282)
			GetOrAddComponent(arg1_282.transform, typeof(DftAniEvent))
		end)

		local var2_281 = var0_281:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform
		local var3_281 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera)).transform
		local var4_281 = GameObject.Find("[sequence]").transform

		arg0_277.nowTimelinePlayer = TimelinePlayer.New(var4_281)

		arg0_277.nowTimelinePlayer:Register(arg1_277.time, function(arg0_283, arg1_283, arg2_283)
			switch(arg1_283.stringParameter, {
				TimelinePause = function()
					arg0_283:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_283:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_283.intParameter == 0 or arg1_283.intParameter == arg2_283.selectIndex then
						arg0_283:SetTime(arg1_283.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_283.selectIndex = nil

					if arg1_277.options then
						local var0_287 = arg1_277.options[arg1_283.intParameter]

						arg0_277:DoTimelineOption(var0_287, function(arg0_288)
							arg2_283.selectIndex = arg0_288
							arg2_283.optionIndex = var0_287[arg0_288].flag

							arg0_283:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_283.selectIndex = nil

					if arg1_277.touchs then
						local var0_289 = arg1_277.touchs[arg1_283.intParameter]

						arg0_277:DoTimelineTouch(arg1_277.touchs[arg1_283.intParameter], function(arg0_290)
							arg2_283.selectIndex = arg0_290
							arg2_283.optionIndex = var0_289[arg0_290].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_283.selectIndex then
						arg0_283:RawSetTime(arg1_283.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_283.selectIndex = arg1_283.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_277.canTriggerAccompanyPerformance then
						arg0_277.canTriggerAccompanyPerformance = false

						local var0_293 = arg1_277.accompanys[arg1_283.intParameter]
						local var1_293 = var0_293[math.random(#var0_293)]

						arg0_283:SetTime(var1_293)
					end
				end,
				TimelineIKStart = function()
					local var0_294 = arg1_283.intParameter
					local var1_294 = arg0_277.ladyDict[arg0_277.apartment:GetConfigID()]

					arg0_277:SetIKTimelineStatus(var1_294, var2_281.gameObject, var0_294, var3_281)
				end,
				TimelineEnd = function()
					arg2_283.finish = true

					arg0_283:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_283.stringParameter)
			end)

			if arg2_283.finish then
				arg0_277.timelineMark = arg2_283
				arg0_277.timelineFinishCall = nil

				local var0_283 = arg0_277.ladyDict[arg0_277.apartment:GetConfigID()]

				if var0_283.ikTimelineMode then
					arg0_277:ExitIKTimelineStatus(var0_283)
				end

				arg0_281()
			end
		end)

		function arg0_277.timelineFinishCall()
			arg0_277.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_277:HideCharacter()
		setActive(arg0_277.mainCameraTF, false)
		eachChild(arg0_277.rtTimelineScreen, function(arg0_298)
			setActive(arg0_298, false)
		end)
		setActive(arg0_277.rtTimelineScreen, true)
		setActive(arg0_277.rtTimelineScreen:Find("btn_skip"), arg0_277.inReplayTalk)
		arg0_277.nowTimelinePlayer:Start()
	end)
	table.insert(var0_277, function(arg0_299)
		arg0_277:ShowBlackScreen(true, function()
			arg0_277.nowTimelinePlayer:Stop()
			arg0_277.nowTimelinePlayer:Dispose()

			arg0_277.nowTimelinePlayer = nil

			arg0_277:UnloadTimelineScene(arg1_277.name, false, arg0_299)
		end)
	end)

	local var1_277 = arg0_277.artSceneInfo

	table.insert(var0_277, function(arg0_301)
		arg0_277:ChangeArtScene(var1_277, arg0_301)
	end)
	seriesAsync(var0_277, function()
		setActive(arg0_277.rtTimelineScreen, false)
		arg0_277:RevertCharacter()
		setActive(arg0_277.mainCameraTF, true)

		local var0_302 = arg0_277.timelineMark

		arg0_277.timelineMark = nil

		existCall(arg2_277, var0_302, function(arg0_303)
			arg0_277:ShowBlackScreen(false, arg0_303)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_304, ...)
	local var0_304 = arg0_304.ladyDict[arg0_304.apartment:GetConfigID()]

	return arg0_304:PlaySingleAction(var0_304, ...)
end

function var0_0.PlaySingleAction(arg0_305, arg1_305, arg2_305, arg3_305)
	local var0_305 = string.find(arg2_305, "^Face_")

	if tobool(var0_305) then
		arg0_305:PlayFaceAnim(arg1_305, arg2_305, arg3_305)

		return
	end

	if arg1_305.ladyAnimator:GetCurrentAnimatorStateInfo(arg1_305.ladyAnimBaseLayerIndex):IsName(arg2_305) then
		return
	end

	existCall(arg1_305.animExtraItemCallback)

	arg1_305.animExtraItemCallback = nil
	arg1_305.animNameMap = arg1_305.animNameMap or {}
	arg1_305.animNameMap[arg1_305.ladyAnimator.StringToHash(arg2_305)] = arg2_305

	local var1_305 = arg0_305:GetBlackboardValue(arg1_305, "groupId")
	local var2_305 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var1_305] or {}, function(arg0_306)
		return pg.dorm3d_anim_extraitem[arg0_306].anim == arg2_305
	end)
	local var3_305 = var2_305 and pg.dorm3d_anim_extraitem[var2_305]
	local var4_305

	seriesAsync({
		function(arg0_307)
			if not var3_305 or var3_305.item_prefab == "" then
				arg0_307()

				return
			end

			local var0_307 = string.lower("dorm3d/furniture/item/" .. var3_305.item_prefab)

			arg0_305.loader:GetPrefab(var0_307, "", function(arg0_308)
				setParent(arg0_308, arg1_305.lady)

				if var3_305.item_shield ~= "" then
					var4_305 = {}

					for iter0_308, iter1_308 in ipairs(var3_305.item_shield) do
						local var0_308 = arg0_305.modelRoot:Find(iter1_308)

						if not var0_308 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var3_305.id, iter1_308))
						else
							var4_305[iter1_308] = isActive(var0_308)

							setActive(var0_308, false)
						end
					end
				end

				function arg0_305.animExtraItemCallback()
					arg0_305.loader:ClearRequest("AnimExtraItem")

					if var4_305 then
						for iter0_309, iter1_309 in pairs(var4_305) do
							setActive(arg0_305.modelRoot:Find(iter0_309), iter1_309)
						end
					end
				end

				arg0_307()
			end, "AnimExtraItem")
		end,
		function(arg0_310)
			arg1_305.nowState = arg2_305
			arg1_305.stateCallback = arg0_310

			arg1_305.ladyAnimator:CrossFadeInFixedTime(arg2_305, 0.25, arg1_305.ladyAnimBaseLayerIndex)
		end,
		function(arg0_311)
			arg1_305.nowState = nil
			arg1_305.stateCallback = nil

			existCall(arg0_305.animExtraItemCallback)

			arg0_305.animExtraItemCallback = nil

			arg0_311()
		end,
		arg3_305
	})
end

function var0_0.SwitchCurrentAnim(arg0_312, ...)
	local var0_312 = arg0_312.ladyDict[arg0_312.apartment:GetConfigID()]

	return arg0_312:SwitchAnim(var0_312, ...)
end

function var0_0.SwitchAnim(arg0_313, arg1_313, arg2_313, arg3_313)
	local var0_313 = string.find(arg2_313, "^Face_")

	if tobool(var0_313) then
		arg0_313:PlayFaceAnim(arg1_313, arg2_313, arg3_313)

		return
	end

	existCall(arg1_313.animExtraItemCallback)

	arg1_313.animExtraItemCallback = nil
	arg1_313.animNameMap = arg1_313.animNameMap or {}
	arg1_313.animNameMap[arg1_313.ladyAnimator.StringToHash(arg2_313)] = arg2_313

	local var1_313 = {}

	table.insert(var1_313, function(arg0_314)
		arg1_313.nowState = arg2_313
		arg1_313.stateCallback = arg0_314

		arg1_313.ladyAnimator:PlayInFixedTime(arg2_313, arg1_313.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_313, function(arg0_315)
		arg1_313.nowState = nil
		arg1_313.stateCallback = nil

		arg0_315()
	end)
	seriesAsync(var1_313, arg3_313)
end

function var0_0.PlayFaceAnim(arg0_316, arg1_316, arg2_316, arg3_316)
	arg1_316.ladyAnimator:CrossFadeInFixedTime(arg2_316, 0.2, arg1_316.ladyAnimFaceLayerIndex)
	existCall(arg3_316)
end

function var0_0.GetCurrentAnim(arg0_317)
	local var0_317 = arg0_317.ladyDict[arg0_317.apartment:GetConfigID()]
	local var1_317 = var0_317.ladyAnimator:GetCurrentAnimatorStateInfo(var0_317.ladyAnimBaseLayerIndex).shortNameHash

	return var0_317.animNameMap[var1_317]
end

function var0_0.RegisterAnimCallback(arg0_318, arg1_318, arg2_318)
	arg0_318.ladyDict[arg0_318.apartment:GetConfigID()].animCallbacks[arg1_318] = arg2_318
end

function var0_0.SetCharacterAnimSpeed(arg0_319, arg1_319)
	local var0_319 = arg0_319.ladyDict[arg0_319.apartment:GetConfigID()]

	var0_319.ladyAnimator.speed = arg1_319
	var0_319.ladyHeadIKComp.blinkSpeed = var0_319.ladyHeadIKData.blinkSpeed * arg1_319

	if arg1_319 > 0 then
		var0_319.ladyHeadIKComp.DampTime = var0_319.ladyHeadIKData.DampTime / arg1_319
	else
		var0_319.ladyHeadIKComp.DampTime = var0_319.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_320, arg1_320)
	if arg1_320.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_320 = arg1_320.stringParameter
	local var1_320 = table.removebykey(arg0_320.animEventCallbacks, var0_320)

	existCall(var1_320)
end

function var0_0.RegisterAnimEventCallback(arg0_321, arg1_321, arg2_321)
	arg0_321.animEventCallbacks[arg1_321] = arg2_321
end

function var0_0.PlaySceneItemAnim(arg0_322, arg1_322, arg2_322)
	arg0_322.sceneAnimatorDict = arg0_322.sceneAnimatorDict or {}

	if not arg0_322.sceneAnimatorDict[arg1_322] then
		local var0_322 = pg.dorm3d_scene_animator[arg1_322]
		local var1_322 = arg0_322:GetSceneItem(var0_322.item_name)

		assert(var1_322, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_322 .. " " .. var0_322.item_name)

		if not var1_322 then
			return
		end

		local var2_322 = var1_322:GetComponent(typeof(Animator))

		if not var2_322 then
			return
		end

		arg0_322.sceneAnimatorDict[arg1_322] = {
			trans = var1_322,
			animator = var2_322
		}
	end

	if arg0_322.sceneAnimatorDict[arg1_322].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_322) then
		return
	end

	arg0_322.sceneAnimatorDict[arg1_322].animator:PlayInFixedTime(arg2_322)
end

function var0_0.ResetSceneItemAnimators(arg0_323, arg1_323)
	if not arg0_323.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_323.sceneAnimatorDict, function(arg0_324, arg1_324)
		if arg1_323 and table.contains(arg1_323, arg0_324) then
			return
		end

		setActive(arg1_324.trans, false)
		setActive(arg1_324.trans, true)

		arg0_323.sceneAnimatorDict[arg0_324] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_325, arg1_325, arg2_325, arg3_325, arg4_325, arg5_325)
	arg1_325.extraItems = arg1_325.extraItems or {}

	if arg1_325.extraItems[arg2_325] then
		return
	end

	local var0_325

	if arg3_325 == "" then
		var0_325 = arg1_325.lady
	else
		table.IpairsCArray(arg1_325.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_326, arg1_326)
			if arg1_326.name == arg3_325 then
				var0_325 = arg1_326
			end
		end)
	end

	if not var0_325 then
		return
	end

	arg0_325.loader:GetPrefab(string.lower("dorm3d/" .. arg2_325), "", function(arg0_327)
		setParent(arg0_327, var0_325)

		if arg4_325 then
			setLocalPosition(arg0_327, arg4_325)
		end

		if arg5_325 then
			setLocalRotation(arg0_327, arg5_325)
		end

		arg1_325.extraItems[arg2_325] = {
			trans = arg0_327.transform,
			handler = var0_325
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_328, arg1_328, arg2_328)
	if not arg1_328.extraItems then
		return
	end

	table.Foreach(arg1_328.extraItems, function(arg0_329, arg1_329)
		if arg2_328 and table.contains(arg2_328, arg0_329) then
			return
		end

		arg0_328.loader:ReturnPrefab(arg1_329.trans.gameObject)

		arg1_328.extraItems[arg0_329] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_330, arg1_330, arg2_330)
	arg0_330.cameraBlendCallbacks[arg1_330] = arg2_330
end

function var0_0.UnRegisterCameraBlendFinished(arg0_331, arg1_331)
	arg0_331.cameraBlendCallbacks[arg1_331] = nil
end

function var0_0.OnCameraBlendFinished(arg0_332, arg1_332)
	if not arg1_332 then
		return
	end

	local var0_332 = table.removebykey(arg0_332.cameraBlendCallbacks, arg1_332)

	existCall(var0_332)
end

function var0_0.PlayHeartFX(arg0_333, arg1_333)
	local var0_333 = arg0_333.ladyDict[arg1_333]

	setActive(var0_333.effectHeart, false)
	setActive(var0_333.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_334, arg1_334)
	local var0_334 = arg1_334.name
	local var1_334 = arg0_334.expressionDict[var0_334]
	local var2_334 = 5

	if var1_334 then
		local var3_334 = var1_334.timer

		var3_334:Reset(nil, var2_334)
		var3_334:Start()

		if var1_334.instance then
			setActive(var1_334.instance, false)
			setActive(var1_334.instance, true)
		end

		return
	end

	local var4_334 = {
		name = var0_334,
		timer = Timer.New(function()
			arg0_334:RemoveExpression(var0_334)
		end, var2_334, 1, true)
	}

	arg0_334.expressionDict[var0_334] = var4_334

	arg0_334.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_334, var0_334, function(arg0_336)
		var4_334.instance = arg0_336

		onNextTick(function()
			local var0_337 = arg0_334.ladyDict[arg0_334.apartment:GetConfigID()]

			setParent(arg0_336, var0_337.ladyHeadCenter)
		end)
		setLocalPosition(arg0_336, Vector3(0, 0, -0.2))
		setActive(arg0_336, false)
		setActive(arg0_336, true)
	end, var4_334)
end

function var0_0.RemoveExpression(arg0_338, arg1_338)
	local var0_338 = arg0_338.expressionDict[arg1_338]

	if not var0_338 then
		return
	end

	arg0_338.loader:ClearRequest(var0_338)

	if var0_338.instance then
		arg0_338.loader:ReturnPrefab(var0_338.instance)
	end

	arg0_338.expressionDict[arg1_338] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_339, arg1_339, arg2_339)
	arg1_339.ladyWatchFloat = arg1_339.ladyWatchFloat or cloneTplTo(arg0_339.resTF:Find("vfx_talk_mark"), arg1_339.ladyHeadCenter)

	setActive(arg1_339.ladyWatchFloat, arg2_339)
end

function var0_0.RegisterGlobalVolume(arg0_340)
	local var0_340 = arg0_340.globalVolume
	local var1_340 = LuaHelper.GetOrAddVolumeComponent(var0_340, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_340 = LuaHelper.GetOrAddVolumeComponent(var0_340, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_340.originalCameraSettings = {
		depthOfField = {
			enabled = var1_340.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_340.gaussianStart.min,
				value = var1_340.gaussianStart.value
			},
			blurRadius = {
				min = var1_340.blurRadius.min,
				max = var1_340.blurRadius.max,
				value = var1_340.blurRadius.value
			}
		},
		postExposure = {
			value = var2_340.postExposure.value
		},
		contrast = {
			min = var2_340.contrast.min,
			max = var2_340.contrast.max,
			value = var2_340.contrast.value
		},
		saturate = {
			min = var2_340.saturation.min,
			max = var2_340.saturation.max,
			value = var2_340.saturation.value
		}
	}
	arg0_340.originalCameraSettings.depthOfField.enabled = true

	local var3_340 = var0_340:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_340.originalVolume = {
		profile = var3_340.sharedProfile,
		weight = var3_340.weight
	}
end

function var0_0.SettingCamera(arg0_341, arg1_341)
	arg0_341.activeCameraSettings = arg1_341

	local var0_341 = arg0_341.globalVolume
	local var1_341 = LuaHelper.GetOrAddVolumeComponent(var0_341, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_341 = LuaHelper.GetOrAddVolumeComponent(var0_341, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_341.enabled:Override(arg1_341.depthOfField.enabled)
	var1_341.gaussianStart:Override(arg1_341.depthOfField.focusDistance.value)
	var1_341.gaussianEnd:Override(arg1_341.depthOfField.focusDistance.value + arg1_341.depthOfField.focusDistance.length)
	var1_341.blurRadius:Override(arg1_341.depthOfField.blurRadius.value)
	var2_341.postExposure:Override(arg1_341.postExposure.value)
	var2_341.contrast:Override(arg1_341.contrast.value)
	var2_341.saturation:Override(arg1_341.saturate.value)
end

function var0_0.GetCameraSettings(arg0_342)
	return arg0_342.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_343)
	arg0_343:SettingCamera(arg0_343.originalCameraSettings)

	arg0_343.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_344, arg1_344, arg2_344)
	local var0_344 = arg0_344.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_344.activeProfileWeight = arg2_344

	if arg0_344.activeProfileName ~= arg1_344 then
		arg0_344.activeProfileName = arg1_344

		arg0_344.loader:LoadReference("dorm3d/scenesres/res/common", arg1_344, nil, function(arg0_345)
			var0_344.profile = arg0_345
			var0_344.weight = arg0_344.activeProfileWeight

			if arg0_344.activeCameraSettings then
				arg0_344:SettingCamera(arg0_344.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_344.weight = arg0_344.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_346)
	local var0_346 = arg0_346.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_346.profile = arg0_346.originalVolume.profile
	var0_346.weight = arg0_346.originalVolume.weight

	if arg0_346.activeCameraSettings then
		arg0_346:SettingCamera(arg0_346.activeCameraSettings)
	end

	arg0_346.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_347)
	local var0_347 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_347.originalCharacterColor = {
		color = var0_347.color,
		intensity = var0_347.intensity
	}
end

function var0_0.SetCharacterLight(arg0_348, arg1_348, arg2_348, arg3_348)
	local var0_348 = arg0_348.characterLight:GetComponent(typeof(Light))
	local var1_348 = Color.Lerp(arg0_348.originalCharacterColor.color, arg1_348, arg3_348)
	local var2_348 = math.lerp(arg0_348.originalCharacterColor.intensity, arg2_348, arg3_348)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_348, var2_348)
end

function var0_0.RevertCharacterLight(arg0_349)
	arg0_349:SetCharacterLight(arg0_349.originalCharacterColor.color, arg0_349.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_350, arg1_350, arg2_350, arg3_350)
	arg2_350 = arg2_350 or {}

	table.Foreach(arg1_350.clothComps, function(arg0_351, arg1_351)
		if arg1_351 == nil then
			return
		end

		setActive(arg1_351, arg2_350[arg0_351] == 1)
	end)
	table.Foreach(arg1_350.clothColliderDict, function(arg0_352, arg1_352)
		if arg1_352 == nil then
			return
		end

		setActive(arg1_352, false)
	end)

	if arg3_350 then
		table.Foreach(arg3_350, function(arg0_353, arg1_353)
			local var0_353 = arg1_350.clothColliderDict[arg1_353[1]]

			if var0_353 == nil then
				return
			end

			setActive(var0_353, arg1_353[2] == 1)

			if arg1_353[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_353, arg1_353[3], arg1_353[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_354, arg1_354)
	table.Foreach(arg1_354.ladyClothCompSettings, function(arg0_355, arg1_355)
		arg0_355.enabled = arg1_355.enabled
	end)
	table.Foreach(arg1_354.ladyClothColliderSettings, function(arg0_356, arg1_356)
		arg0_356.enabled = arg1_356.enabled

		var0_0.SetMagicaCollider(arg0_356, arg1_356.StartRadius, arg1_356.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_357)
	if arg0_357.exited or arg0_357.retainCount > 0 then
		-- block empty
	else
		arg0_357:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_358, arg1_358, arg2_358)
	assert(tobool(arg0_358.lastSceneRootDict[arg1_358]) == arg2_358)

	if arg2_358 then
		table.Foreach(arg0_358.lastSceneRootDict[arg1_358], function(arg0_359, arg1_359)
			if IsNil(arg0_359) then
				return
			end

			setActive(arg0_359, arg1_359)
		end)

		arg0_358.lastSceneRootDict[arg1_358] = nil
	else
		arg0_358.lastSceneRootDict[arg1_358] = {}

		local var0_358 = SceneManager.GetSceneByName(arg1_358)

		table.IpairsCArray(var0_358:GetRootGameObjects(), function(arg0_360, arg1_360)
			if tostring(arg1_360.hideFlags) ~= "None" then
				return
			end

			arg0_358.lastSceneRootDict[arg1_358][arg1_360] = isActive(arg1_360)

			setActive(arg1_360, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_361, arg1_361, arg2_361)
	arg1_361 = string.lower(arg1_361)

	if arg1_361 == arg0_361.artSceneInfo then
		if arg1_361 == arg0_361.sceneInfo then
			arg0_361:SwitchDayNight(arg0_361.contextData.timeIndex)
			onNextTick(function()
				arg0_361:RefreshSlots()
				existCall(arg2_361)
			end)
		else
			existCall(arg2_361)
		end

		return
	end

	local var0_361 = {}
	local var1_361 = false
	local var2_361

	table.insert(var0_361, function(arg0_363)
		arg0_361.artSceneInfo = arg1_361

		if var1_361 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_364)
				var2_361 = arg0_364

				arg0_363()
			end)
		else
			arg0_363()
		end
	end)

	if arg1_361 == arg0_361.sceneInfo then
		table.insert(var0_361, function(arg0_365)
			setActive(arg0_361.slotRoot, true)

			local var0_365, var1_365 = unpack(string.split(arg0_361.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_365))
			arg0_361:EnableSceneDisplay(var0_365, true)
			arg0_361:SwitchDayNight(arg0_361.contextData.timeIndex)
			onNextTick(function()
				arg0_361:RefreshSlots()
			end)
			arg0_365()
		end)
	else
		var1_361 = true

		local var3_361, var4_361 = unpack(string.split(arg1_361, "|"))

		table.insert(var0_361, function(arg0_367)
			setActive(arg0_361.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_361 .. "/" .. var3_361 .. "_scene"), var3_361, LoadSceneMode.Additive, function(arg0_368, arg1_368)
				SceneManager.SetActiveScene(arg0_368)

				local var0_368 = getSceneRootTFDic(arg0_368).MainCamera

				if var0_368 then
					setActive(var0_368, false)
				end

				arg0_367()
			end)
		end)
	end

	if arg0_361.artSceneInfo == arg0_361.sceneInfo then
		table.insert(var0_361, function(arg0_369)
			local var0_369, var1_369 = unpack(string.split(arg0_361.sceneInfo, "|"))

			arg0_361:EnableSceneDisplay(var0_369, false)
			arg0_369()
		end)
	else
		local var5_361, var6_361 = unpack(string.split(arg0_361.artSceneInfo, "|"))

		table.insert(var0_361, function(arg0_370)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_361 .. "/" .. var5_361 .. "_scene"), var5_361, arg0_370)
		end)
	end

	table.insert(var0_361, function(arg0_371)
		arg0_371()

		if var1_361 then
			var2_361()
		end
	end)
	seriesAsync(var0_361, arg2_361)
end

function var0_0.LoadTimelineScene(arg0_372, arg1_372, arg2_372, arg3_372)
	arg1_372 = string.lower(arg1_372)

	if arg0_372.cacheSceneDic[arg1_372] then
		if not arg2_372 then
			arg0_372.timelineScene = arg1_372

			arg0_372:EnableSceneDisplay(arg1_372, true)
		end

		return existCall(arg3_372)
	end

	local var0_372 = {}
	local var1_372

	table.insert(var0_372, function(arg0_373)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_374)
			if arg0_372.waitForTimeline then
				arg0_372.waitForTimeline = arg0_374
				var1_372 = nil
			else
				var1_372 = arg0_374
			end

			arg0_373()
		end)
	end)
	table.insert(var0_372, function(arg0_375)
		local var0_375 = arg0_372.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_375 .. "/timeline/" .. arg1_372 .. "/" .. arg1_372 .. "_scene"), arg1_372, LoadSceneMode.Additive, function(arg0_376, arg1_376)
			local var0_376 = GameObject.Find("[actor]").transform

			arg0_372:HXCharacter(tf(var0_376))

			local var1_376 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_376:Stop()
			TimelineSupport.InitTimeline(var1_376)
			TimelineSupport.InitSubtitle(var1_376, arg0_372.apartment:GetCallName())

			arg0_372.unloadDirector = var1_376

			arg0_375()
		end)
	end)
	table.insert(var0_372, function(arg0_377)
		arg0_372.sceneGroupDic[arg1_372] = arg0_372.apartment:GetConfigID()

		if arg2_372 then
			arg0_372.cacheSceneDic[arg1_372] = true

			arg0_372:EnableSceneDisplay(arg1_372, false)
		else
			arg0_372.timelineScene = arg1_372
		end

		arg0_377()
		existCall(var1_372)
	end)
	seriesAsync(var0_372, arg3_372)
end

function var0_0.UnloadTimelineScene(arg0_378, arg1_378, arg2_378, arg3_378)
	arg1_378 = string.lower(arg1_378)

	if arg0_378.timelineScene == arg1_378 then
		arg0_378.timelineScene = nil
	end

	if tobool(arg2_378) == tobool(arg0_378.cacheSceneDic[arg1_378]) then
		local var0_378 = getProxy(ApartmentProxy):getApartment(arg0_378.sceneGroupDic[arg1_378]):getConfig("asset_name")

		if arg0_378.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_378.unloadDirector)

			arg0_378.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_378 .. "/timeline/" .. arg1_378 .. "/" .. arg1_378 .. "_scene"), arg1_378, function()
			arg0_378.cacheSceneDic[arg1_378] = nil
			arg0_378.sceneGroupDic[arg1_378] = nil
			arg0_378.lastSceneRootDict[arg1_378] = nil

			existCall(arg3_378)
		end)
	else
		arg0_378:EnableSceneDisplay(arg1_378, false)
		existCall(arg3_378)
	end
end

function var0_0.ChangeSubScene(arg0_380, arg1_380, arg2_380)
	arg1_380 = string.lower(arg1_380)

	warning(arg0_380.subSceneInfo, "->", arg1_380, arg1_380 == arg0_380.subSceneInfo)

	local var0_380 = arg0_380.ladyDict[arg0_380.apartment:GetConfigID()]

	if arg1_380 == arg0_380.subSceneInfo then
		var0_380.ladyActiveZone = var0_380.walkBornPoint or var0_380.ladyBaseZone

		arg0_380:ChangeCharacterPosition(var0_380)
		arg0_380:ChangePlayerPosition(var0_380.ladyActiveZone)
		arg0_380:TriggerLadyDistance()
		arg0_380:CheckInSector()
		existCall(arg2_380)

		return
	end

	local var1_380 = {}
	local var2_380 = false
	local var3_380

	table.insert(var1_380, function(arg0_381)
		arg0_380.subSceneInfo = arg1_380

		if var2_380 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_382)
				var3_380 = arg0_382

				arg0_381()
			end)
		else
			arg0_381()
		end
	end)

	if arg1_380 == arg0_380.sceneInfo then
		table.insert(var1_380, function(arg0_383)
			local var0_383, var1_383 = unpack(string.split(arg0_380.sceneInfo, "|"))

			arg0_380:ResetSceneStructure(SceneManager.GetSceneByName(var0_383 .. "_base"))
			arg0_380:RefreshSlots()

			var0_380.ladyActiveZone = var0_380.walkBornPoint or var0_380.ladyBaseZone

			arg0_380:ChangeCharacterPosition(var0_380)
			arg0_380:ChangePlayerPosition(var0_380.ladyActiveZone)
			arg0_380:TriggerLadyDistance()
			arg0_380:CheckInSector()
			arg0_383()
		end)
	else
		var2_380 = true

		local var4_380, var5_380 = unpack(string.split(arg1_380, "|"))
		local var6_380 = var4_380 .. "_base"

		table.insert(var1_380, function(arg0_384)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_380 .. "/" .. var6_380 .. "_scene"), var6_380, LoadSceneMode.Additive, arg0_384)
		end)
		table.insert(var1_380, function(arg0_385)
			arg0_380:ResetSceneStructure(SceneManager.GetSceneByName(var6_380))

			var0_380.ladyActiveZone = var0_380.walkBornPoint or "Default"

			arg0_380:SwitchAnim(var0_380, var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_380:ChangeCharacterPosition(var0_380)
				arg0_380:ChangePlayerPosition(var0_380.ladyActiveZone)
				arg0_380:TriggerLadyDistance()
				arg0_380:CheckInSector()
				arg0_385()
			end)
		end)
	end

	if arg0_380.subSceneInfo == arg0_380.sceneInfo then
		table.insert(var1_380, function(arg0_387)
			local var0_387 = Clone(arg0_380.room)

			var0_387.furnitures = {}

			arg0_380:RefreshSlots(var0_387)
			arg0_387()
		end)
	else
		local var7_380, var8_380 = unpack(string.split(arg0_380.subSceneInfo, "|"))
		local var9_380 = var7_380 .. "_base"

		table.insert(var1_380, function(arg0_388)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_380 .. "/" .. var9_380 .. "_scene"), var9_380, arg0_388)
		end)
	end

	table.insert(var1_380, function(arg0_389)
		arg0_389()

		if var2_380 then
			var3_380()
		end
	end)
	seriesAsync(var1_380, arg2_380)
end

function var0_0.IsPointInSector(arg0_390, arg1_390)
	local var0_390 = arg1_390 - Vector3.New(unpack(arg0_390.Position))

	if var0_390.magnitude > arg0_390.Radius then
		return false
	end

	local var1_390 = Quaternion.Euler(unpack(arg0_390.Rotation))

	return Vector3.Angle(var1_390 * Vector3.forward, var0_390) <= arg0_390.Angle / 2
end

function var0_0.willExit(arg0_391)
	arg0_391.joystickTimer:Stop()
	arg0_391.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_391.updateHandler)
	arg0_391:StopIKHandTimer()

	if arg0_391.moveTimer then
		arg0_391.moveTimer:Stop()

		arg0_391.moveTimer = nil
	end

	if arg0_391.moveWaitTimer then
		arg0_391.moveWaitTimer:Stop()

		arg0_391.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_391.furnitures) then
		eachChild(arg0_391.furnitures, function(arg0_392)
			local var0_392 = GetComponent(arg0_392, typeof(EventTriggerListener))

			if not var0_392 then
				return
			end

			var0_392:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_391, iter1_391 in pairs(arg0_391.ladyDict) do
		GetComponent(iter1_391.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_391.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_391.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_391.blockLayer, arg0_391._tf)
	table.Foreach(arg0_391.expressionDict, function(arg0_393)
		arg0_391:RemoveExpression(arg0_393)
	end)
	arg0_391.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_391 = {}

	if arg0_391.timelineScene and not arg0_391.cacheSceneDic[arg0_391.timelineScene] then
		local var1_391 = arg0_391.timelineScene

		arg0_391.timelineScene = nil

		local var2_391 = getProxy(ApartmentProxy):getApartment(arg0_391.sceneGroupDic[var1_391]):getConfig("asset_name")

		table.insert(var0_391, function(arg0_394)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_391 .. "/timeline/" .. var1_391 .. "/" .. var1_391 .. "_scene"), var1_391, arg0_394)
		end)
	end

	for iter2_391, iter3_391 in pairs(arg0_391.cacheSceneDic) do
		if iter3_391 then
			local var3_391 = getProxy(ApartmentProxy):getApartment(arg0_391.sceneGroupDic[iter2_391]):getConfig("asset_name")

			table.insert(var0_391, function(arg0_395)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_391 .. "/timeline/" .. iter2_391 .. "/" .. iter2_391 .. "_scene"), iter2_391, arg0_395)
			end)
		end
	end

	for iter4_391, iter5_391 in ipairs({
		arg0_391.sceneInfo,
		arg0_391.subSceneInfo ~= arg0_391.sceneInfo and arg0_391.subSceneInfo or nil
	}) do
		local var4_391, var5_391 = unpack(string.split(iter5_391, "|"))
		local var6_391 = var4_391 .. "_base"

		table.insert(var0_391, function(arg0_396)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_391 .. "/" .. var6_391 .. "_scene"), var6_391, arg0_396)
		end)
	end

	for iter6_391, iter7_391 in ipairs({
		arg0_391.sceneInfo,
		arg0_391.artSceneInfo ~= arg0_391.sceneInfo and arg0_391.artSceneInfo or nil
	}) do
		local var7_391, var8_391 = unpack(string.split(iter7_391, "|"))

		table.insert(var0_391, function(arg0_397)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_391 .. "/" .. var7_391 .. "_scene"), var7_391, arg0_397)
		end)
	end

	seriesAsync(var0_391, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_399 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_399 = SystemInfo.deviceModel or ""

			local function var2_399(arg0_400)
				local var0_400 = string.match(arg0_400, "iPad(%d+)")
				local var1_400 = tonumber(var0_400)

				if var1_400 and var1_400 >= 8 then
					return true
				end

				return false
			end

			local function var3_399(arg0_401)
				local var0_401 = string.match(arg0_401, "iPhone(%d+)")
				local var1_401 = tonumber(var0_401)

				if var1_401 and var1_401 >= 13 then
					return true
				end

				return false
			end

			if var2_399(var1_399) or var3_399(var1_399) then
				var0_399 = DevicePerformanceLevel.High
			end
		end

		local var4_399 = var0_399 == DevicePerformanceLevel.High and 3 or var0_399 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_399)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_399
	end
end

function var0_0.SettingQuality()
	local var0_402 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_402)
end

function var0_0.SetMagicaCollider(arg0_403, arg1_403, arg2_403)
	local var0_403 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_403, "StartRadius", arg0_403, arg1_403)
	ReflectionHelp.RefSetProperty(var0_403, "EndRadius", arg0_403, arg2_403)
end

return var0_0
