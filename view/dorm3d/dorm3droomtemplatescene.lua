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

local var1_0 = {
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
		local var1_13 = getProxy(ApartmentProxy):getApartment(var0_13)
		local var2_13 = var1_13:GetCurSkinId()
		local var3_13 = arg0_13.ladyDict[var0_13]

		setActive(var3_13.ladyGameObject, false)

		var3_13.skinId = var2_13
		var3_13.ladyGameObject = arg0_13.skinDict[var2_13].ladyGameObject

		setActive(var3_13.ladyGameObject, true)
		var3_13:HideCharacterPart(var2_13, var1_13:GetHiddenParts(var2_13))
	end

	for iter0_13, iter1_13 in pairs(arg0_13.ladyDict) do
		arg0_13:InitCharacter(iter1_13, iter0_13)
	end

	if not arg0_13.room:isPersonalRoom() then
		local var4_13 = underscore.detect(arg0_13.contextData.groupIds, function(arg0_14)
			return arg0_13.contextData.ladyZone[arg0_14] == arg0_13.contextData.inFurnitureName
		end) or arg0_13.contextData.groupIds[1]

		if var4_13 then
			arg0_13:SyncInterestTransform(arg0_13.ladyDict[var4_13])
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
			arg0_15[arg1_30](arg0_15, ...)
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

			warning(var8_39, var9_39)
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

	arg0_45.sectorsDic = arg0_45.sectorsDic or {}

	if not arg0_45.sectorsDic[arg1_45.name] then
		arg0_45.sectorsDic[arg1_45.name] = table.shallowCopy(var1_0[arg1_45.name]) or {}

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
	local var1_49 = arg0_49.modelRoot:GetComponentsInChildren(typeof(Transform), true):ToTable()

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

		for iter0_50, iter1_50 in ipairs(var1_49) do
			if iter1_50.name == var0_50 then
				var5_50 = iter1_50

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
	arg0_52.transRangeDic = {
		list = {}
	}
	arg0_52.transformFilter = arg0_52.transformFilter or BLHX.Rendering.TransformFilter.New()

	for iter0_52, iter1_52 in pairs(arg0_52.contactStateDic) do
		arg0_52.hideContactStateDic[iter0_52] = math.min(iter1_52, ApartmentRoom.ITEM_UNLOCK)
		arg0_52.contactInRangeDic[iter0_52] = false

		local var0_52 = pg.dorm3d_collection_template[iter0_52].vfx_prefab

		arg0_52.transRangeDic[iter0_52] = {
			#arg0_52.transRangeDic.list + 1,
			#var0_52
		}

		table.insertto(arg0_52.transRangeDic.list, underscore.map(var0_52, function(arg0_53)
			return arg0_52.modelRoot:Find(arg0_53)
		end))
	end

	arg0_52.transformFilter:Init(arg0_52.mainCameraTF, arg0_52.transRangeDic.list, 2, 60)
	arg0_52:ActiveContact()
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
		arg0_58:UpdateFloatPosition()
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
		table.insert(var0_60, function(arg0_61)
			arg0_60:LoadSingleCharacter(iter1_60, arg0_61)
		end)
	end

	parallelAsync(var0_60, arg2_60)
end

function var0_0.LoadCharacterAdditionally(arg0_62, arg1_62, arg2_62)
	local var0_62 = {}

	for iter0_62, iter1_62 in ipairs(arg1_62) do
		table.insert(var0_62, function(arg0_63)
			arg0_62:LoadSingleCharacter(iter1_62, function()
				arg0_62:InitCharacter(arg0_62.ladyDict[iter1_62], iter1_62)
				arg0_63()
			end)
		end)
	end

	parallelAsync(var0_62, arg2_62)
end

function var0_0.LoadSingleCharacter(arg0_65, arg1_65, arg2_65)
	local var0_65 = {}
	local var1_65 = LadyEnv.New(arg0_65)

	arg0_65.ladyDict[arg1_65] = var1_65

	local var2_65 = getProxy(ApartmentProxy):getApartment(arg1_65)
	local var3_65 = var2_65:getConfig("asset_name")
	local var4_65 = var2_65:GetSkinModelID(arg0_65.room:getConfig("tag"))
	local var5_65 = pg.dorm3d_resource[var4_65].model_id

	assert(var5_65)

	for iter0_65, iter1_65 in ipairs({
		"common",
		var5_65
	}) do
		local var6_65 = string.format("dorm3d/character/%s/res/%s", var3_65, iter1_65)

		if checkABExist(var6_65) then
			table.insert(var0_65, function(arg0_66)
				arg0_65.loader:LoadBundle(var6_65, function(arg0_67)
					for iter0_67, iter1_67 in ipairs(arg0_67:GetAllAssetNames()) do
						local var0_67, var1_67, var2_67 = string.find(iter1_67, "material_hx[/\\](.*).mat")

						if var0_67 then
							arg0_65.hxMatDict[var2_67] = {
								arg0_67,
								iter1_67
							}
						end
					end

					arg0_66()
				end)
			end)
		end
	end

	var1_65.skinId = var4_65
	var1_65.skinIdList = {
		var4_65
	}

	table.insert(var0_65, function(arg0_68)
		local var0_68 = string.format("dorm3d/character/%s/prefabs/%s", var3_65, var5_65)

		arg0_65.loader:GetPrefab(var0_68, "", function(arg0_69)
			var1_65.ladyGameObject = arg0_69
			arg0_65.skinDict[var4_65] = {
				ladyGameObject = arg0_69
			}

			arg0_68()
		end)
	end)

	if arg0_65.room:isPersonalRoom() then
		for iter2_65, iter3_65 in ipairs(var2_65:GetAllModelIds()) do
			if not table.contains(var1_65.skinIdList, iter3_65) then
				local var7_65 = pg.dorm3d_resource[iter3_65].model_id
				local var8_65 = string.format("dorm3d/character/%s/prefabs/%s", var3_65, var7_65)

				if checkABExist(var8_65) then
					table.insert(var1_65.skinIdList, iter3_65)
					table.insert(var0_65, function(arg0_70)
						arg0_65.loader:GetPrefab(var8_65, "", function(arg0_71)
							arg0_65.skinDict[iter3_65] = {
								ladyGameObject = arg0_71
							}
							GetComponent(arg0_71, "GraphOwner").enabled = false

							setActive(arg0_71, false)
							arg0_70()
						end)
					end)
				end
			end
		end
	end

	if arg0_65.contextData.pendingDic[arg1_65] then
		local var9_65 = pg.dorm3d_welcome[arg0_65.contextData.pendingDic[arg1_65]]

		if var9_65.item_prefab ~= "" then
			table.insert(var0_65, function(arg0_72)
				local var0_72 = string.lower("dorm3d/furniture/item/" .. var9_65.item_prefab)

				arg0_65.loader:GetPrefab(var0_72, "", function(arg0_73)
					var1_65.tfPendintItem = arg0_73.transform

					setActive(arg0_73, false)
					arg0_72()
				end)
			end)
		end
	end

	parallelAsync(var0_65, arg2_65)
end

function var0_0.HXCharacter(arg0_74, arg1_74)
	if not HXSet.isHx() then
		return
	end

	local var0_74 = arg1_74:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_74, function(arg0_75, arg1_75)
		local var0_75 = arg1_75.sharedMaterials
		local var1_75 = false

		table.IpairsCArray(var0_75, function(arg0_76, arg1_76)
			if arg1_76 == nil then
				return
			end

			local var0_76 = arg1_76.name

			if not arg0_74.hxMatDict[var0_76] then
				return
			end

			var1_75 = true

			local var1_76, var2_76 = unpack(arg0_74.hxMatDict[var0_76])
			local var3_76 = var1_76:LoadAssetSync(var2_76, typeof(Material), false, false)

			var0_75[arg0_76] = var3_76

			warning("Replace HX Material", arg0_74.hxMatDict[var0_76][2])
		end)

		if var1_75 then
			arg1_75.sharedMaterials = var0_75
		end
	end)
end

function var0_0.InitCharacter(arg0_77, arg1_77, arg2_77)
	arg1_77:InitCharacter(arg2_77)

	arg1_77.ladyBaseZone = arg0_77.contextData.ladyZone[arg2_77]
	arg1_77.ladyActiveZone = arg1_77.ladyBaseZone

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

	pg.UIMgr.GetInstance():OverlayPanel(arg0_88.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
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
end

function var0_0.InitData(arg0_103)
	if not arg0_103.contextData.ladyZone then
		arg0_103.contextData.ladyZone = {}

		local var0_103
		local var1_103 = arg0_103.room:getConfig("default_zone")

		for iter0_103, iter1_103 in ipairs(arg0_103.contextData.groupIds) do
			for iter2_103, iter3_103 in ipairs(var1_103) do
				if iter3_103[1] == iter1_103 then
					arg0_103.contextData.ladyZone[iter1_103] = iter3_103[2]

					break
				end
			end

			assert(arg0_103.contextData.ladyZone[iter1_103])

			var0_103 = var0_103 or arg0_103.contextData.ladyZone[iter1_103]
		end

		arg0_103.contextData.inFurnitureName = var0_103 or var1_103[1][2]
	end

	arg0_103.zoneDatas = _.select(arg0_103.room:GetZones(), function(arg0_104)
		return not arg0_104:IsGlobal()
	end)
	arg0_103.activeSectors = {}
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

	if arg0_105.contactInRangeDic then
		local var1_105 = arg0_105.transformFilter:Execute():ToTable()

		for iter0_105, iter1_105 in pairs(arg0_105.contactInRangeDic) do
			local var2_105 = pg.dorm3d_collection_template[iter0_105]
			local var3_105 = arg0_105.transRangeDic[iter0_105]
			local var4_105 = underscore(var1_105):chain():slice(unpack(var3_105)):any(function(arg0_106)
				return arg0_106
			end):value()

			if tobool(iter1_105) ~= var4_105 then
				arg0_105.contactInRangeDic[iter0_105] = var4_105

				arg0_105:UpdateContactDisplay(iter0_105, var4_105 and not arg0_105.hideConcatFlag and arg0_105.contactStateDic[iter0_105] or arg0_105.hideContactStateDic[iter0_105])
			end
		end
	end

	if arg0_105.enableFloatUpdate then
		arg0_105:UpdateFloatPosition()
	end

	arg0_105:CheckInSector()

	if arg0_105.apartment then
		(function(arg0_107)
			(function()
				if not arg0_107.ikHandler then
					return
				end

				local var0_108 = arg0_107.ikHandler.screenPosition
				local var1_108 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect
				local var2_108 = var0_108 - Vector2.New(var1_108.width, var1_108.height) * 0.5

				setAnchoredPosition(arg0_105:GetIKHandTF(), var2_108)

				if Time.time > arg0_105.ikNextCheckStamp then
					arg0_105.ikNextCheckStamp = arg0_105.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					local var3_108 = _.detect(arg0_107.readyIKLayers, function(arg0_109)
						return arg0_109:GetControllerPath() == arg0_107.ikHandler.ikData:GetControllerPath()
					end)

					arg0_105:emit(var0_0.ON_IK_STATUS_CHANGED, var3_108:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end
			end)()

			if arg0_105.enableIKTip then
				local var0_107 = not arg0_105.blockIK and Time.time > arg0_105.nextTipIKTime

				if var0_107 then
					local var1_107 = _.filter(arg0_107.readyIKLayers, function(arg0_110)
						return not arg0_110.ignoreDrag
					end)

					UIItemList.StaticAlign(arg0_105.ikTipsRoot, arg0_105.ikTipsRoot:GetChild(0), #var1_107, function(arg0_111, arg1_111, arg2_111)
						if arg0_111 ~= UIItemList.EventUpdate then
							return
						end

						arg1_111 = arg1_111 + 1

						local var0_111
						local var1_111 = Vector2.zero
						local var2_111 = var1_107[arg1_111]
						local var3_111 = var2_111:GetTriggerBoneName()
						local var4_111 = var3_111 and arg0_107.IKSettings.Colliders[var3_111] or nil
						local var5_111 = var2_111:GetIKTipOffset()

						if var4_111 then
							local function var6_111()
								local var0_112 = arg0_107.IKSettings.CameraRaycaster.eventCamera:WorldToScreenPoint(var4_111.position)
								local var1_112 = CameraMgr.instance:Raycast(arg0_107.IKSettings.CameraRaycaster, var0_112)

								if var1_112.Length == 0 then
									return
								end

								return var4_111 == var1_112[0].gameObject.transform
							end
						end

						if var4_111 then
							local var7_111 = var4_111.position
							local var8_111 = var4_111:GetComponent(typeof(UnityEngine.Collider))

							if var8_111 then
								var7_111 = var8_111.bounds.center
							end

							local var9_111 = arg0_105:GetLocalPosition(arg0_105:GetScreenPosition(var7_111, arg0_107.IKSettings.CameraRaycaster.eventCamera), arg0_105.ikTipsRoot) + var5_111

							setLocalPosition(arg2_111, var9_111)

							local var10_111 = var2_111:GetTriggerRect()
							local var11_111 = var10_111:PointToNormalized(Vector2.zero)
							local var12_111 = Vector2.zero

							if var11_111.x < 0.5 and var11_111.y < 0.5 then
								var12_111 = var10_111.max
							elseif var11_111.x >= 0.5 and var11_111.y < 0.5 then
								var12_111 = Vector2.New(var10_111.xMin, var10_111.yMax)
							elseif var11_111.x < 0.5 and var11_111.y >= 0.5 then
								var12_111 = Vector2.New(var10_111.xMax, var10_111.yMin)
							elseif var11_111.x >= 0.5 and var11_111.y >= 0.5 then
								var12_111 = var10_111.min
							end

							if var11_111.x == 0.5 then
								if var9_111.x < 0 then
									var12_111.x = var10_111.xMax
								else
									var12_111.x = var10_111.xMin
								end
							end

							if var11_111.y == 0.5 then
								if var9_111.y < 0 then
									var12_111.y = var10_111.yMax
								else
									var12_111.y = var10_111.yMin
								end
							end

							local var13_111 = var12_111 - var10_111.center

							setLocalRotation(arg2_111, Quaternion.LookRotation(Vector3.forward, Vector3.New(var13_111.x, var13_111.y, 0)))
						end

						setActive(arg2_111, var4_111)
					end)
					UIItemList.StaticAlign(arg0_105.ikClickTipsRoot, arg0_105.ikClickTipsRoot:GetChild(0), #arg0_107.iKTouchDatas, function(arg0_113, arg1_113, arg2_113)
						if arg0_113 ~= UIItemList.EventUpdate then
							return
						end

						arg1_113 = arg1_113 + 1

						local var0_113
						local var1_113 = Vector2.zero
						local var2_113 = arg1_113
						local var3_113 = arg0_107.iKTouchDatas[var2_113][1]
						local var4_113 = pg.dorm3d_ik_touch[var3_113]

						if #var4_113.scene_item > 0 then
							var0_113 = arg0_105:GetSceneItem(var4_113.scene_item)
						else
							var0_113 = arg0_107.IKSettings.Colliders[var4_113.body]
						end

						if var0_113 then
							local var5_113 = var0_113.position
							local var6_113 = var0_113:GetComponent(typeof(UnityEngine.Collider))

							if var6_113 then
								var5_113 = var6_113.bounds.center
							end

							setLocalPosition(arg2_113, arg0_105:GetLocalPosition(arg0_105:GetScreenPosition(var5_113, arg0_107.IKSettings.CameraRaycaster.eventCamera), arg0_105.ikClickTipsRoot) + var1_113)
						end

						setActive(arg2_113, var0_113)
					end)
				end

				setActive(arg0_105.ikTipsRoot, var0_107)
				setActive(arg0_105.ikClickTipsRoot, var0_107)
				setActive(arg0_105.ikTextTipsRoot, var0_107)
			end
		end)(arg0_105.ladyDict[arg0_105.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_114)
	if not isActive(arg0_114.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_114 = arg0_114.mainCameraTF.position

	for iter0_114, iter1_114 in pairs(arg0_114.ladyDict) do
		local var1_114 = tobool(arg0_114.activeLady[iter0_114])

		if var1_114 ~= tobool(var0_0.IsPointInSector(arg0_114.activeSectors[iter1_114.ladyActiveZone], var0_114)) then
			arg0_114.activeLady[iter0_114] = not var1_114

			arg0_114:emit(var0_0.ON_ENTER_SECTOR, iter0_114)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_115)
	for iter0_115, iter1_115 in pairs(arg0_115.ladyDict) do
		iter1_115.dis = (iter1_115.lady.position - arg0_115.player.position).magnitude

		if (arg0_115:GetBlackboardValue(iter1_115, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_115.dis ~= arg0_115:GetBlackboardValue(iter1_115, "inDistance") then
			arg0_115:SetBlackboardValue(iter1_115, "inDistance", iter1_115.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_115:emit(var0_0.ON_CHANGE_DISTANCE, iter0_115, iter1_115.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end
end

function var0_0.OnStickMove(arg0_116, arg1_116)
	arg0_116.joystickDelta = arg1_116
end

function var0_0.SetPinchValue(arg0_117, arg1_117)
	arg0_117.pinchValue = arg1_117

	arg0_117:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_118)
	local var0_118 = arg0_118.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_118)
end

function var0_0.SetPOVFOV(arg0_119, arg1_119)
	local var0_119 = arg0_119.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_119, arg1_119)

	arg0_119.cameras[var0_0.CAMERA.POV].m_Lens = var0_119
end

function var0_0.RefreshSlots(arg0_120, arg1_120, arg2_120)
	arg1_120 = arg1_120 or arg0_120.room

	local var0_120 = arg1_120:GetSlots()
	local var1_120 = arg1_120:GetFurnitures()

	arg0_120:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_120, function(arg0_121, arg1_121, arg2_121)
		local var0_121 = arg1_121:GetConfigID()

		if not arg0_120.slotDict[var0_121] then
			return arg2_121()
		end

		local var1_121 = _.detect(var1_120, function(arg0_122)
			return arg0_122:GetSlotID() == var0_121
		end)
		local var2_121 = var1_121 and var1_121:GetModel() or false
		local var3_121 = arg0_120.slotDict[var0_121].model

		arg0_120.slotDict[var0_121].displayModelName = var2_121
		arg0_120.slotDict[var0_121].furnitureId = var1_121 and var1_121:GetConfigID()

		local function var4_121(arg0_123)
			if var3_121 then
				setActive(var3_121, var2_121 == "")
			end

			table.Foreach(arg0_120.slotDict[var0_121].sceneHides or {}, function(arg0_124, arg1_124)
				setActive(arg1_124.trans, arg1_124.visible)
			end)

			arg0_120.slotDict[var0_121].sceneHides = {}

			if arg0_123 then
				local var0_123 = arg0_123:getConfig("scene_hides")

				if #var0_123 > 0 then
					table.Ipairs(var0_123, function(arg0_125, arg1_125)
						local var0_125 = arg0_120.modelRoot:Find(arg1_125)

						assert(var0_125, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_123:GetConfigID(), arg1_125))

						local var1_125 = isActive(var0_125)

						table.insert(arg0_120.slotDict[var0_121].sceneHides, {
							name = arg1_125,
							trans = var0_125,
							visible = var1_125
						})
						setActive(var0_125, false)
					end)
				end
			end
		end

		if var2_121 == false or var2_121 == "" then
			arg0_120.loader:ClearRequest("slot_" .. var0_121)
			var4_121()
			arg2_121()

			return
		end

		local var5_121 = arg0_120.slotDict[var0_121].trans

		if arg0_120.loader:GetLoadingRP("slot_" .. var0_121) then
			arg0_120:emit(var0_0.HIDE_BLOCK)
		end

		arg0_120.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_121, "", function(arg0_126)
			assert(arg0_126)
			setParent(arg0_126, var5_121)
			var4_121(var1_121)
			arg2_121()
		end, "slot_" .. var0_121)
	end, function()
		arg0_120:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_120)
		arg0_120:emit(Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE)
	end)
end

function var0_0.CheckSceneItemActiveByPath(arg0_128, arg1_128)
	local var0_128 = arg0_128:GetSceneItem(arg1_128)

	return arg0_128:CheckSceneItemActive(var0_128)
end

function var0_0.CheckSceneItemActive(arg0_129, arg1_129)
	local var0_129 = true
	local var1_129

	table.Checkout(arg0_129.slotDict, function(arg0_130, arg1_130)
		if underscore.detect(arg1_130.sceneHides, function(arg0_131)
			return arg0_131.trans == arg1_129
		end) then
			var0_129 = false
			var1_129 = arg1_130.furnitureId

			return false
		end
	end)

	return var0_129, var1_129
end

function var0_0.ChangeCharacterPosition(arg0_132, arg1_132)
	arg0_132:ResetCharPoint(arg1_132, arg1_132.ladyActiveZone)
	arg0_132:SyncInterestTransform(arg1_132)
end

function var0_0.SyncCurrentInterestTransform(arg0_133)
	local var0_133 = arg0_133.ladyDict[arg0_133.apartment:GetConfigID()]

	arg0_133:SyncInterestTransform(var0_133)
end

function var0_0.SyncInterestTransform(arg0_134, arg1_134)
	arg0_134.ladyInterest.position = arg1_134.ladyInterestRoot.position
	arg0_134.ladyInterest.rotation = arg1_134.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_135, arg1_135)
	arg1_135 = arg1_135 or arg0_135.contextData.inFurnitureName

	local var0_135 = arg0_135.furnitures:Find(arg1_135):Find("PlayerPoint").position

	arg0_135.player.position = var0_135
	arg0_135.cameras[var0_0.CAMERA.POV].transform.position = arg0_135.playerEye.position

	local var1_135 = arg0_135.ladyInterest.position - arg0_135.playerEye.position
	local var2_135 = Quaternion.LookRotation(var1_135).eulerAngles
	local var3_135 = var2_135.y
	local var4_135 = var2_135.x
	local var5_135 = arg0_135.compPovAim.m_HorizontalAxis

	var5_135.Value = arg0_135:GetNearestAngle(var3_135, var5_135.m_MinValue, var5_135.m_MaxValue)
	arg0_135.compPovAim.m_HorizontalAxis = var5_135

	local var6_135 = arg0_135.compPovAim.m_VerticalAxis

	var6_135.Value = var4_135
	arg0_135.compPovAim.m_VerticalAxis = var6_135
end

function var0_0.GetAttachedFurnitureName(arg0_136)
	return arg0_136.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_137, arg1_137)
	return underscore.detect(arg0_137.attachedPoints, function(arg0_138)
		return arg0_138.name == arg1_137
	end)
end

function var0_0.GetSlotByID(arg0_139, arg1_139)
	return arg0_139.displaySlots[arg1_139] and arg0_139.displaySlots[arg1_139].trans
end

function var0_0.GetScreenPosition(arg0_140, arg1_140, arg2_140)
	arg2_140 = arg2_140 or arg0_140.raycastCamera

	local var0_140 = arg2_140:WorldToScreenPoint(arg1_140)

	if var0_140.z < 0 then
		var0_140.x = var0_140.x + (var0_140.x < 0 and -1 or 1) * Screen.width
		var0_140.y = var0_140.y + (var0_140.y < 0 and -1 or 1) * Screen.height
		var0_140.z = -var0_140.z
	end

	return var0_140
end

function var0_0.GetLocalPosition(arg0_141, arg1_141, arg2_141)
	return LuaHelper.ScreenToLocal(arg2_141, arg1_141, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_142)
	return arg0_142.modelRoot
end

function var0_0.ShiftZone(arg0_143, arg1_143, arg2_143)
	local var0_143 = arg0_143:GetFurnitureByName(arg1_143)

	if not var0_143 then
		errorMsg(arg1_143 .. " Not Find")
		existCall(arg2_143)

		return
	end

	seriesAsync({
		function(arg0_144)
			arg0_143:emit(var0_0.SHOW_BLOCK)
			arg0_143:ShowBlackScreen(true, arg0_144)
		end,
		function(arg0_145)
			if arg0_143.shiftLady or arg0_143.room:isPersonalRoom() then
				local var0_145 = arg0_143.shiftLady or arg0_143.apartment:GetConfigID()

				arg0_143.shiftLady = nil
				arg0_143.contextData.ladyZone[var0_145] = var0_143.name

				local var1_145 = arg0_143.ladyDict[var0_145]

				var1_145.ladyBaseZone = arg0_143.contextData.ladyZone[var0_145]
				var1_145.ladyActiveZone = arg0_143.contextData.ladyZone[var0_145]

				if arg0_143:GetBlackboardValue(var1_145, "inPending") then
					arg0_143:SetOutPending(var1_145)
					arg0_143:SwitchAnim(var1_145, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_143:ChangeCharacterPosition(var1_145)
						arg0_145()
					end)
				else
					arg0_143:ChangeCharacterPosition(var1_145)
					arg0_145()
				end
			else
				arg0_145()
			end
		end,
		function(arg0_147)
			arg0_143.contextData.inFurnitureName = var0_143.name

			if not arg0_143.apartment then
				for iter0_147, iter1_147 in pairs(arg0_143.ladyDict) do
					if iter1_147.ladyBaseZone == arg0_143.contextData.inFurnitureName then
						arg0_143:SyncInterestTransform(iter1_147)

						break
					end
				end
			end

			arg0_143:ChangePlayerPosition()
			arg0_143:TriggerLadyDistance()
			arg0_143:CheckInSector()
			arg0_147()
		end,
		function(arg0_148)
			arg0_143:UpdateZoneList()
			arg0_143:ShowBlackScreen(false, arg0_148)
		end,
		function(arg0_149)
			arg0_143:emit(var0_0.HIDE_BLOCK)
			arg0_149()
		end
	}, arg2_143)
end

function var0_0.ActiveCamera(arg0_150, arg1_150)
	local var0_150 = isActive(arg1_150)

	table.Foreach(arg0_150.cameras, function(arg0_151, arg1_151)
		setActive(arg1_151, arg1_151 == arg1_150)
	end)

	if var0_150 then
		arg0_150:OnCameraBlendFinished(arg1_150)
	end
end

function var0_0.ActiveCameraByName(arg0_152, arg1_152)
	local var0_152 = arg0_152.cameraRoot:Find(arg1_152)

	assert(var0_152, "ActiveCameraByName: " .. arg1_152 .. " not found")
	table.Foreach(arg0_152.cameras, function(arg0_153, arg1_153)
		setActive(arg1_153, false)
	end)
	setActive(var0_152, true)

	arg0_152.cameras[var0_0.CAMERA.CUSTOM] = var0_152:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
end

function var0_0.ShowBlackScreen(arg0_154, arg1_154, arg2_154)
	local var0_154 = arg0_154.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_154 and 0 or 0.3
	}

	setImageColor(arg0_154.blackLayer, Color.NewHex(var0_154.color))
	setActive(arg0_154.blackLayer, true)
	setCanvasGroupAlpha(arg0_154.blackLayer, arg1_154 and 0 or 1)
	arg0_154:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_154 then
			setActive(arg0_154.blackLayer, false)
		end

		existCall(arg2_154)
	end, GetComponent(arg0_154.blackLayer, typeof(CanvasGroup)), arg1_154 and 1 or 0, var0_154.time):setDelay(var0_154.delay)
end

function var0_0.RegisterOrbits(arg0_156, arg1_156)
	arg0_156 = arg0_156.scene
	arg0_156.orbits = {
		original = arg1_156.m_Orbits
	}
	arg0_156.orbits.current = _.range(3):map(function(arg0_157)
		local var0_157 = arg0_156.orbits.original[arg0_157 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_157.m_Height, var0_157.m_Radius)
	end)
	arg0_156.surroudCamera = arg1_156
end

function var0_0.SetCameraObrits(arg0_158)
	arg0_158 = arg0_158.scene

	local var0_158 = arg0_158.surroudCamera

	if not var0_158 then
		return
	end

	local var1_158 = arg0_158.orbits.original[1]

	for iter0_158 = 0, #arg0_158.orbits.current - 1 do
		local var2_158 = arg0_158.orbits.current[iter0_158 + 1]
		local var3_158 = arg0_158.orbits.original[iter0_158]

		var2_158.m_Height = math.lerp(var1_158.m_Height, var3_158.m_Height, arg0_158.pinchValue)
		var2_158.m_Radius = var3_158.m_Radius * arg0_158.pinchValue
	end

	var0_158.m_Orbits = arg0_158.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_159)
	arg0_159 = arg0_159.scene

	local var0_159 = arg0_159.surroudCamera

	if not var0_159 then
		return
	end

	for iter0_159 = 0, #arg0_159.orbits.current - 1 do
		local var1_159 = arg0_159.orbits.current[iter0_159 + 1]
		local var2_159 = arg0_159.orbits.original[iter0_159]

		var1_159.m_Height = var2_159.m_Height
		var1_159.m_Radius = var2_159.m_Radius
	end

	var0_159.m_Orbits = arg0_159.orbits.current
	arg0_159.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_160, arg1_160, arg2_160)
	local var0_160 = {
		base = function(arg0_161)
			arg0_160:RegisterCameraBlendFinished(arg0_160.cameras[var0_0.CAMERA.POV], arg0_161)
			arg0_160:ActiveCamera(arg0_160.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_162)
			assert(arg0_160.apartment)
			arg0_160:SyncInterestTransform(arg0_160.ladyDict[arg0_160.apartment:GetConfigID()])
			arg0_160:SetCameraLady(arg0_160.ladyDict[arg0_160.apartment:GetConfigID()])
			arg0_160:RegisterCameraBlendFinished(arg0_160.cameras[var0_0.CAMERA.ROLE], arg0_162)
			arg0_160:ActiveCamera(arg0_160.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_163)
			arg0_160:RegisterCameraBlendFinished(arg0_160.cameras[var0_0.CAMERA.POV], arg0_163)
			arg0_160:ActiveCamera(arg0_160.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_164)
			arg0_164()
		end,
		gift = function(arg0_165)
			assert(arg0_160.apartment)
			arg0_160:SetCameraLady(arg0_160.ladyDict[arg0_160.apartment:GetConfigID()])
			arg0_160:RegisterCameraBlendFinished(arg0_160.cameras[var0_0.CAMERA.GIFT], arg0_165)
			arg0_160:ActiveCamera(arg0_160.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_166)
			assert(arg0_160.apartment)
			arg0_160:SetCameraLady(arg0_160.ladyDict[arg0_160.apartment:GetConfigID()])

			arg0_160.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_160.cameraRole.transform.position

			arg0_160:RegisterCameraBlendFinished(arg0_160.cameras[var0_0.CAMERA.ROLE2], arg0_166)
			arg0_160:ActiveCamera(arg0_160.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_167)
			assert(arg0_160.apartment)
			arg0_160:SetCameraLady(arg0_160.ladyDict[arg0_160.apartment:GetConfigID()])
			arg0_160:SyncInterestTransform(arg0_160.ladyDict[arg0_160.apartment:GetConfigID()])
			arg0_160:RegisterCameraBlendFinished(arg0_160.cameras[var0_0.CAMERA.TALK], arg0_167)
			arg0_160:ActiveCamera(arg0_160.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_160 = {}

	table.insert(var1_160, function(arg0_168)
		switch(arg1_160, var0_160, arg0_168, arg0_168)
	end)
	seriesAsync(var1_160, arg2_160)
end

function var0_0.GetSceneItem(arg0_169, arg1_169)
	local var0_169

	if string.find(arg1_169, "FurnitureSlots/") == 1 then
		arg1_169 = string.gsub(arg1_169, "^FurnitureSlots/", "", 1)
		var0_169 = arg0_169.slotRoot:Find(arg1_169)
	else
		var0_169 = arg0_169.modelRoot:Find(arg1_169)
	end

	if not var0_169 then
		warning(string.format("Missing scene item path: %s", arg1_169))
	end

	return var0_169
end

function var0_0.SetIKStatus(arg0_170, arg1_170, arg2_170, arg3_170)
	warning("Set IKStatus " .. (arg2_170.id or "NIL"))

	arg0_170.enableIKTip = true

	arg0_170:ResetIKTipTimer()
	setActive(arg1_170.ladyCollider, false)
	_.each(arg1_170.ladyTouchColliders, function(arg0_171)
		setActive(arg0_171, true)
	end)

	arg0_170.blockIK = nil
	arg1_170.ikActionDict = {}
	arg1_170.readyIKLayers = {}
	arg1_170.iKTouchDatas = arg2_170.touch_data or {}
	arg1_170.IKSettings = {
		Colliders = arg1_170.ladyColliders,
		CameraRaycaster = arg0_170.sceneRaycaster
	}

	local var0_170 = table.shallowCopy(arg2_170.ik_id)
	local var1_170 = {}

	_.each(arg1_170.iKTouchDatas, function(arg0_172)
		local var0_172 = arg0_172[3]

		if var0_172[1] == 7 then
			local var1_172 = pg.dorm3d_ik_touch_move[var0_172[2]]
			local var2_172 = var1_172.target_ik

			if not _.detect(var0_170, function(arg0_173)
				return arg0_173[1] == var2_172
			end) then
				var1_170[var2_172] = {
					back_time = var1_172.back_time
				}

				local var3_172 = {
					var2_172,
					0,
					{}
				}

				if var1_172.trigger_dialogue > 0 then
					var3_172[3] = {
						4,
						0,
						var1_172.trigger_dialogue
					}
				end

				table.insert(var0_170, var3_172)
			end
		end
	end)

	local var2_170 = _.map(var0_170, function(arg0_174)
		local var0_174 = Dorm3dIK.New({
			configId = arg0_174[1]
		})
		local var1_174 = arg0_174[3]
		local var2_174 = var1_174[1]
		local var3_174 = switch(var2_174, {
			function(arg0_175, arg1_175)
				return 0
			end,
			function()
				return 0
			end,
			function(arg0_177, arg1_177)
				return arg0_177
			end,
			function(arg0_178, arg1_178)
				return arg0_178
			end,
			function(arg0_179, arg1_179, arg2_179, arg3_179)
				return arg0_179
			end,
			function(arg0_180)
				return 0
			end
		}, function(arg0_181)
			return type(arg0_181) == "number" and arg0_181 or 0
		end, unpack(var1_174, 2))

		table.insert(arg1_170.readyIKLayers, var0_174)

		arg1_170.ikActionDict[var0_174:GetControllerPath()] = var1_174

		local var4_174 = var0_174:GetRevertTime()
		local var5_174 = var1_170[var0_174:GetConfigID()]
		local var6_174 = tobool(var5_174)

		if var6_174 then
			var3_174 = var5_174.back_time
			var4_174 = var5_174.back_time
			var0_174.ignoreDrag = true
		end

		local var7_174 = var0_174:GetSubTargets()
		local var8_174 = var0_174:GetPlaneRotations()
		local var9_174 = var0_174:GetPlaneScales()
		local var10_174 = _.map(_.range(#var7_174), function(arg0_182)
			return {
				name = var7_174[arg0_182][1],
				planeRot = var8_174[arg0_182],
				planeScale = var9_174[arg0_182]
			}
		end)

		return Dorm3dIKController.New({
			triggerName = var0_174:getConfig("trigger_param")[2],
			controllerName = var0_174:GetControllerPath(),
			subTargets = var10_174,
			actionType = var0_174:GetActionTriggerParams()[1],
			controlRect = var0_174:GetRect(),
			actionRect = var0_174:GetTriggerRect(),
			backTime = var4_174,
			actionRevertTime = var3_174,
			ignoreDrag = var6_174
		})
	end)

	pg.IKMgr.GetInstance():RegisterEnv(arg1_170.ladyIKRoot, arg1_170.ladyBoneMaps)
	arg0_170:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var2_170)

	local var3_170 = _.map(arg1_170.iKTouchDatas, function(arg0_183)
		return arg0_183[1]
	end)

	table.Foreach(var3_170, function(arg0_184, arg1_184)
		local var0_184 = pg.dorm3d_ik_touch[arg1_184]

		if #var0_184.scene_item == 0 then
			return
		end

		local var1_184 = arg0_170:GetSceneItem(var0_184.scene_item)

		if not var1_184 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_184, var0_184.scene_item))

			return
		end

		if IsNil(GetComponent(var1_184, typeof(UnityEngine.Collider))) then
			go(var1_184):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_184 = GetOrAddComponent(var1_184, typeof(EventTriggerListener))

		var2_184.enabled = true

		var2_184:AddPointClickFunc(function()
			arg0_170.blockIK = true

			local var0_185 = arg1_170.iKTouchDatas[arg0_184]
			local var1_185, var2_185, var3_185 = unpack(var0_185)

			arg0_170:TouchModeAction(arg1_170, var1_185, unpack(var3_185))(function()
				arg0_170.enableIKTip = true

				arg0_170:ResetIKTipTimer()

				arg0_170.blockIK = nil
			end)
		end)
	end)

	arg0_170.camBrain.enabled = false

	if arg0_170.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_170.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_170.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var4_170 = arg0_170.cameraRoot:Find(arg2_170.ik_camera)

	assert(var4_170, "Missing IKCamera")

	arg0_170.cameras[var0_0.CAMERA.IK_WATCH] = var4_170

	arg0_170:ActiveCamera(arg0_170.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_170.camBrain.enabled = true

	local var5_170 = var4_170:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var5_170 then
		arg0_170:RegisterOrbits(var5_170)
	else
		arg0_170:RevertCameraOrbit()
	end

	arg0_170:SwitchAnim(arg1_170, arg2_170.character_action)
	arg0_170:SettingHeadAimIK(arg1_170, arg2_170.head_track)
	arg1_170:EnableCloth(false)
	arg1_170:EnableCloth(arg2_170.use_cloth, arg2_170.cloth_colliders)
	;(function()
		local var0_187 = arg2_170.enter_scene_anim
		local var1_187 = {}

		if var0_187 and #var0_187 > 0 then
			table.Ipairs(var0_187, function(arg0_188, arg1_188)
				arg0_170:PlaySceneItemAnim(arg1_188[1], arg1_188[2])
				table.insert(var1_187, arg1_188[1])
			end)
		end

		arg0_170:ResetSceneItemAnimators(var1_187)
	end)()
	;(function()
		local var0_189 = arg2_170.enter_extra_item
		local var1_189 = {}

		if var0_189 and #var0_189 > 0 then
			table.Ipairs(var0_189, function(arg0_190, arg1_190)
				local var0_190 = arg1_190[3] and Vector3.New(unpack(arg1_190[3]))
				local var1_190 = arg1_190[4] and Quaternion.Euler(unpack(arg1_190[4]))
				local var2_190 = #arg1_190 > 4 and arg1_190[5] or nil

				arg0_170:LoadCharacterExtraItem(arg1_170, arg1_190[1], arg1_190[2], var0_190, var1_190, var2_190)
				table.insert(var1_189, arg1_190[1])
			end)
		end

		arg0_170:ResetCharacterExtraItem(arg1_170, var1_189)
	end)()
	;(function()
		local var0_191 = arg2_170.hide_scene_item

		if var0_191 and #var0_191 > 0 then
			arg1_170.tempHideSceneItems = {}

			table.Ipairs(var0_191, function(arg0_192, arg1_192)
				local var0_192 = arg0_170:GetSceneItem(arg1_192)

				setActive(var0_192, false)
				table.insert(arg1_170.tempHideSceneItems, arg1_192)
			end)
		end
	end)()
	eachChild(arg0_170.ikTextTipsRoot, function(arg0_193)
		setActive(arg0_193, false)
	end)
	_.each(arg1_170.readyIKLayers, function(arg0_194)
		local var0_194 = arg0_194:getConfig("tip_text")

		if not var0_194 or #var0_194 == 0 then
			return
		end

		local var1_194 = arg0_170.ikTextTipsRoot:Find(var0_194)

		if not IsNil(var1_194) then
			setActive(var1_194, true)
		end
	end)
	onNextTick(function()
		local var0_195 = arg0_170.furnitures:Find(arg2_170.character_position)

		arg1_170.lady.position = var0_195:Find("StayPoint").position
		arg1_170.lady.rotation = var0_195:Find("StayPoint").rotation

		existCall(arg3_170)
	end)
end

function var0_0.ExitIKStatus(arg0_196, arg1_196, arg2_196, arg3_196)
	arg0_196.enableIKTip = false

	setActive(arg1_196.ladyCollider, true)
	_.each(arg1_196.ladyTouchColliders, function(arg0_197)
		setActive(arg0_197, false)
	end)

	arg0_196.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()
	setActive(arg0_196.ikTipsRoot, false)
	setActive(arg0_196.ikClickTipsRoot, false)

	local var0_196 = _.map(arg1_196.iKTouchDatas, function(arg0_198)
		return arg0_198[1]
	end)

	table.Foreach(var0_196, function(arg0_199, arg1_199)
		local var0_199 = pg.dorm3d_ik_touch[arg1_199]

		if #var0_199.scene_item == 0 then
			return
		end

		local var1_199 = arg0_196.modelRoot:Find(var0_199.scene_item)

		if not var1_199 then
			return
		end

		local var2_199 = GetOrAddComponent(var1_199, typeof(EventTriggerListener))

		var2_199:ClearEvents()

		var2_199.enabled = false
	end)

	arg1_196.ikActionDict = nil
	arg1_196.readyIKLayers = nil
	arg1_196.iKTouchDatas = nil

	arg0_196:RevertCameraOrbit()
	setActive(arg0_196.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_196.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg1_196:EnableCloth(false)
	arg0_196:ResetHeadAimIK(arg1_196)
	arg0_196:SwitchAnim(arg1_196, arg2_196.character_action)
	arg0_196:ResetSceneItemAnimators()
	arg0_196:ResetCharacterExtraItem(arg1_196)
	;(function()
		if arg1_196.tempHideSceneItems and #arg1_196.tempHideSceneItems > 0 then
			table.Ipairs(arg1_196.tempHideSceneItems, function(arg0_201, arg1_201)
				local var0_201 = arg0_196:GetSceneItem(arg1_201)

				setActive(var0_201, true)
			end)

			arg1_196.tempHideSceneItems = nil
		end
	end)()
	onNextTick(function()
		if arg2_196.character_position then
			arg1_196.ladyActiveZone = arg2_196.character_position
		else
			arg1_196.ladyActiveZone = arg1_196.ladyBaseZone
		end

		arg0_196:ChangeCharacterPosition(arg1_196)
		arg0_196:TriggerLadyDistance()
		arg0_196:CheckInSector()
		existCall(arg3_196)
	end)
end

function var0_0.SetIKTimelineStatus(arg0_203, arg1_203, arg2_203, arg3_203, arg4_203, arg5_203)
	warning("Set IKStatus " .. (arg3_203 or "NIL"))
	arg1_203:SetCurrentIkTimelineStatus(arg3_203)

	arg0_203.enableIKTip = true

	setActive(arg0_203.ikControlUI, true)
	arg0_203:ResetIKTipTimer()

	arg0_203.blockIK = nil

	local var0_203 = pg.dorm3d_ik_timeline_status[arg3_203]

	arg1_203.readyIKLayers = {}
	arg1_203.iKTouchDatas = {}
	arg1_203.IKSettings = {
		CameraRaycaster = GetOrAddComponent(arg4_203, typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	}

	assert(arg1_203.IKSettings.CameraRaycaster)

	local var1_203 = {}

	table.IpairsCArray(arg2_203:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_204, arg1_204)
		if arg1_204.name == "SafeCollider" then
			setActive(arg1_204, false)

			return
		end

		if arg1_204:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		local var0_204 = tf(arg1_204)
		local var1_204 = var0_204.name
		local var2_204 = var1_204 and string.find(var1_204, "Collider") or -1

		if var2_204 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var1_204)

			return
		end

		local var3_204 = string.sub(var1_204, 1, var2_204 - 1)

		if var3_204 == "Body" or var3_204 == "Safe" then
			setActive(var0_204, false)

			return
		end

		if DormConst.BONE_TO_TOUCH[var3_204] == nil then
			return
		end

		var1_203[var3_204] = var0_204

		setActive(var0_204, true)
	end)

	arg1_203.IKSettings.Colliders = var1_203

	local var2_203 = GetOrAddComponent(arg2_203, typeof(EventTriggerListener))

	arg1_203.ikTimelineMode = true

	local var3_203 = _.map(var0_203.ik_id, function(arg0_205)
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
			ignoreDrag = false,
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
	local var4_203 = arg2_203.transform:Find("IKLayers")
	local var5_203 = {}
	local var6_203 = {}

	table.Foreach(DormConst.boneMap, function(arg0_207, arg1_207)
		var6_203[arg1_207] = arg0_207
	end)

	local var7_203 = arg2_203.transform:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var7_203, function(arg0_208, arg1_208)
		if var6_203[arg1_208.name] then
			var5_203[var6_203[arg1_208.name]] = arg1_208
		end
	end)
	pg.IKMgr.GetInstance():RegisterEnv(var4_203, var5_203)
	arg0_203:RegisterIKFunc()
	pg.IKMgr.GetInstance():SetIKStatus(var3_203)
	eachChild(arg0_203.ikTextTipsRoot, function(arg0_209)
		setActive(arg0_209, false)
	end)
	_.each(arg1_203.readyIKLayers, function(arg0_210)
		local var0_210 = arg0_210:getConfig("tip_text")

		if not var0_210 or #var0_210 == 0 then
			return
		end

		local var1_210 = arg0_203.ikTextTipsRoot:Find(var0_210)

		if not IsNil(var1_210) then
			setActive(var1_210, true)
		end
	end)
	existCall(arg5_203)
end

function var0_0.ExitIKTimelineStatus(arg0_211, arg1_211, arg2_211)
	arg1_211:SetCurrentIkTimelineStatus(nil)

	arg0_211.enableIKTip = false

	setActive(arg0_211.ikControlUI, false)

	arg0_211.blockIK = nil

	pg.IKMgr.GetInstance():UnregisterEnv()

	arg1_211.readyIKLayers = nil
	arg1_211.iKTouchDatas = nil
	arg1_211.IKSettings = nil

	setActive(arg0_211.ikTipsRoot, false)
	setActive(arg0_211.ikClickTipsRoot, false)
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

	if not arg1_212.ignoreDrag then
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
	end

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

	if not arg1_215.ignoreDrag then
		setActive(arg0_215:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_215:GetIKHandTF():Find("Normal"), false)
		setActive(arg0_215:GetIKHandTF():Find("End"), true)

		arg0_215.ikHandTimer = Timer.New(function()
			setActive(arg0_215:GetIKHandTF():Find("End"), false)
			setActive(arg0_215:GetIKHandTF(), false)
		end, 0.5, 1)

		arg0_215.ikHandTimer:Start()
	end
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
	arg0_235:EnableJoystick(true)
	arg0_235:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_236, arg1_236)
	arg0_236:HideFurnitureSlots()

	local var0_236 = arg0_236.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_237)
			arg0_236.furniturePOV = nil

			arg0_236:EnableJoystick(false)
			arg0_236:emit(var0_0.SHOW_BLOCK)
			arg0_236:ShowBlackScreen(true, arg0_237)
		end,
		function(arg0_238)
			existCall(arg1_236)
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
	arg0_241.furniturePOV = arg0_241.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

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
			arg0_251:ResetCharPoint(var1_254, arg1_251:GetWatchCameraName())
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
			setActive(arg0_251.restrictedBox, true)
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

				arg0_257.contextData.photoFreeMode = nil
			end

			setActive(arg0_257.restrictedBox, false)

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

		local var0_270 = arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE]
		local var1_270 = arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_270 = arg0_270.mainCameraTF.rotation:ToEulerAngles()
		local var3_270 = var1_270.m_HorizontalAxis

		var3_270.Value = var2_270.y
		var1_270.m_HorizontalAxis = var3_270

		local var4_270 = var1_270.m_VerticalAxis

		var4_270.Value = arg0_270:GetNearestAngle(var2_270.x, var4_270.m_MinValue, var4_270.m_MaxValue)
		var1_270.m_VerticalAxis = var4_270

		local var5_270 = arg0_270.mainCameraTF.position
		local var6_270 = arg0_270:GetRestritedHeightRange()
		local var7_270 = math.InverseLerp(var6_270[1], var6_270[2], var5_270.y)

		var5_270.y = math.clamp(var5_270.y, var6_270[1], var6_270[2])
		var0_270.transform.position = var5_270

		arg0_270:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var7_270)
		arg0_270:ActiveCamera(arg0_270.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_270:EnableJoystick(true)
		arg0_270:EnablePOVLayer(false)
		arg0_270:ActiveCamera(arg0_270.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_270.contextData.photoFreeMode = not arg0_270.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_271, arg1_271)
	local var0_271 = arg0_271.cameras[var0_0.CAMERA.PHOTO_FREE]
	local var1_271 = arg0_271:GetRestritedHeightRange()
	local var2_271 = math.lerp(var1_271[1], var1_271[2], arg1_271)

	var0_271:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var2_271 - var0_271.position.y, 0))
	onNextTick(function()
		local var0_272 = arg0_271:GetRestritedHeightRange()
		local var1_272 = math.InverseLerp(var0_272[1], var0_272[2], var0_271.position.y)

		arg0_271:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_272)
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
		arg0_277:LoadTimelineScene(arg1_277.name, false, nil, arg0_279)
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
		local var3_281

		eachChild(GameObject.Find("[camera]").transform, function(arg0_283)
			if arg0_283.tag == "MainCamera" then
				var3_281 = arg0_283
			end
		end)
		assert(var3_281, "Missing MainCamera")

		local var4_281 = GameObject.Find("[sequence]").transform

		arg0_277.nowTimelinePlayer = TimelinePlayer.New(var4_281)

		arg0_277.nowTimelinePlayer:Register(arg1_277.time, function(arg0_284, arg1_284, arg2_284)
			switch(arg1_284.stringParameter, {
				TimelinePause = function()
					arg0_284:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_284:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_284.intParameter == 0 or arg1_284.intParameter == arg2_284.selectIndex then
						arg0_284:SetTime(arg1_284.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_284.selectIndex = nil

					if arg1_277.options then
						local var0_288 = arg1_277.options[arg1_284.intParameter]

						arg0_277:DoTimelineOption(var0_288, function(arg0_289)
							arg2_284.selectIndex = arg0_289
							arg2_284.optionIndex = var0_288[arg0_289].flag

							arg0_284:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_284.selectIndex = nil

					if arg1_277.touchs then
						local var0_290 = arg1_277.touchs[arg1_284.intParameter]

						arg0_277:DoTimelineTouch(arg1_277.touchs[arg1_284.intParameter], function(arg0_291)
							arg2_284.selectIndex = arg0_291
							arg2_284.optionIndex = var0_290[arg0_291].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_284.selectIndex then
						arg0_284:RawSetTime(arg1_284.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_284.selectIndex = arg1_284.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_277.canTriggerAccompanyPerformance then
						arg0_277.canTriggerAccompanyPerformance = false

						local var0_294 = arg1_277.accompanys[arg1_284.intParameter]
						local var1_294 = var0_294[math.random(#var0_294)]

						arg0_284:SetTime(var1_294)
					end
				end,
				TimelineIKStart = function()
					arg2_284.selectIndex = nil

					local var0_295 = arg1_284.intParameter
					local var1_295 = arg0_277.ladyDict[arg0_277.apartment:GetConfigID()]

					if var1_295:CheckIkTimelineStatus(var0_295) then
						arg0_277:SetIKTimelineStatus(var1_295, var2_281.gameObject, var0_295, var3_281)
					end
				end,
				TimelineEnd = function()
					arg2_284.finish = true

					arg0_284:SetSpeed(0)
				end
			}, function()
				warning("other event trigger:" .. arg1_284.stringParameter)
			end)

			if arg2_284.finish then
				arg0_277.timelineMark = arg2_284
				arg0_277.timelineFinishCall = nil

				local var0_284 = arg0_277.ladyDict[arg0_277.apartment:GetConfigID()]

				if var0_284.ikTimelineMode then
					arg0_277:ExitIKTimelineStatus(var0_284)
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
		setActive(var3_281, true)
		eachChild(arg0_277.rtTimelineScreen, function(arg0_299)
			setActive(arg0_299, false)
		end)
		setActive(arg0_277.rtTimelineScreen, true)
		setActive(arg0_277.rtTimelineScreen:Find("btn_skip"), arg0_277.inReplayTalk)
		arg0_277.nowTimelinePlayer:Start()
	end)
	table.insert(var0_277, function(arg0_300)
		arg0_277:ShowBlackScreen(true, function()
			arg0_277.nowTimelinePlayer:Stop()
			arg0_277.nowTimelinePlayer:Dispose()

			arg0_277.nowTimelinePlayer = nil

			arg0_277:UnloadTimelineScene(arg1_277.name, false, arg0_300)
		end)
	end)

	local var1_277 = arg0_277.dormSceneMgr.artSceneInfo

	table.insert(var0_277, function(arg0_302)
		arg0_277:ChangeArtScene(var1_277, arg0_302)
	end)
	seriesAsync(var0_277, function()
		setActive(arg0_277.rtTimelineScreen, false)
		arg0_277:RevertCharacter()
		setActive(arg0_277.mainCameraTF, true)

		local var0_303 = arg0_277.timelineMark

		arg0_277.timelineMark = nil

		existCall(arg2_277, var0_303, function(arg0_304)
			arg0_277:ShowBlackScreen(false, arg0_304)
		end)
	end)
end

function var0_0.PlayCurrentSingleAction(arg0_305, ...)
	local var0_305 = arg0_305.ladyDict[arg0_305.apartment:GetConfigID()]

	return arg0_305:PlaySingleAction(var0_305, ...)
end

function var0_0.PlaySingleAction(arg0_306, arg1_306, arg2_306, arg3_306)
	arg1_306:PlaySingleAction(arg2_306, arg3_306)
end

function var0_0.SwitchCurrentAnim(arg0_307, ...)
	local var0_307 = arg0_307.ladyDict[arg0_307.apartment:GetConfigID()]

	return arg0_307:SwitchAnim(var0_307, ...)
end

function var0_0.SwitchAnim(arg0_308, arg1_308, arg2_308, arg3_308)
	arg1_308:SwitchAnim(arg2_308, arg3_308)
end

function var0_0.PlayFaceAnim(arg0_309, arg1_309, arg2_309, arg3_309)
	arg1_309:PlayFaceAnim(arg2_309, arg3_309)
end

function var0_0.GetCurrentAnim(arg0_310)
	return arg0_310.ladyDict[arg0_310.apartment:GetConfigID()]:GetCurrentAnim()
end

function var0_0.RegisterAnimCallback(arg0_311, arg1_311, arg2_311)
	arg0_311.ladyDict[arg0_311.apartment:GetConfigID()].animCallbacks[arg1_311] = arg2_311
end

function var0_0.SetCharacterAnimSpeed(arg0_312, arg1_312)
	local var0_312 = arg0_312.ladyDict[arg0_312.apartment:GetConfigID()]

	var0_312.ladyAnimator.speed = arg1_312
	var0_312.ladyHeadIKComp.blinkSpeed = var0_312.ladyHeadIKData.blinkSpeed * arg1_312

	if arg1_312 > 0 then
		var0_312.ladyHeadIKComp.DampTime = var0_312.ladyHeadIKData.DampTime / arg1_312
	else
		var0_312.ladyHeadIKComp.DampTime = var0_312.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_313, arg1_313)
	if arg1_313.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_313 = arg1_313.stringParameter
	local var1_313 = table.removebykey(arg0_313.animEventCallbacks, var0_313)

	existCall(var1_313)
end

function var0_0.RegisterAnimEventCallback(arg0_314, arg1_314, arg2_314)
	arg0_314.animEventCallbacks[arg1_314] = arg2_314
end

function var0_0.PlaySceneItemAnim(arg0_315, arg1_315, arg2_315)
	arg0_315.sceneAnimatorDict = arg0_315.sceneAnimatorDict or {}

	if not arg0_315.sceneAnimatorDict[arg1_315] then
		local var0_315 = pg.dorm3d_scene_animator[arg1_315]
		local var1_315 = arg0_315:GetSceneItem(var0_315.item_name)

		assert(var1_315, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_315 .. " " .. var0_315.item_name)

		if not var1_315 then
			return
		end

		local var2_315 = var1_315:GetComponent(typeof(Animator))

		if not var2_315 then
			return
		end

		arg0_315.sceneAnimatorDict[arg1_315] = {
			trans = var1_315,
			animator = var2_315
		}
	end

	if arg0_315.sceneAnimatorDict[arg1_315].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_315) then
		return
	end

	arg0_315.sceneAnimatorDict[arg1_315].animator:PlayInFixedTime(arg2_315)
end

function var0_0.ResetSceneItemAnimators(arg0_316, arg1_316)
	if not arg0_316.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_316.sceneAnimatorDict, function(arg0_317, arg1_317)
		if arg1_316 and table.contains(arg1_316, arg0_317) then
			return
		end

		setActive(arg1_317.trans, false)
		setActive(arg1_317.trans, true)

		arg0_316.sceneAnimatorDict[arg0_317] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_318, arg1_318, arg2_318, arg3_318, arg4_318, arg5_318, arg6_318)
	local function var0_318(arg0_319)
		if arg6_318 then
			local var0_319 = arg0_319:GetComponent(typeof(Animator))

			if var0_319 then
				var0_319:Play(arg6_318)
			end
		end
	end

	arg1_318.extraItems = arg1_318.extraItems or {}

	if arg1_318.extraItems[arg2_318] then
		var0_318(arg1_318.extraItems[arg2_318].trans)

		return
	end

	local var1_318

	if arg3_318 == "" then
		var1_318 = arg1_318.lady
	elseif arg3_318 == "scene_root" then
		var1_318 = arg0_318.modelRoot
	else
		table.IpairsCArray(arg1_318.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_320, arg1_320)
			if arg1_320.name == arg3_318 then
				var1_318 = arg1_320
			end
		end)
	end

	if not var1_318 then
		return
	end

	arg0_318.loader:GetPrefab(string.lower("dorm3d/" .. arg2_318), "", function(arg0_321)
		setParent(arg0_321, var1_318)

		if arg4_318 then
			setLocalPosition(arg0_321, arg4_318)
		end

		if arg5_318 then
			setLocalRotation(arg0_321, arg5_318)
		end

		var0_318(arg0_321)

		arg1_318.extraItems[arg2_318] = {
			trans = arg0_321.transform,
			handler = var1_318
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_322, arg1_322, arg2_322)
	if not arg1_322.extraItems then
		return
	end

	table.Foreach(arg1_322.extraItems, function(arg0_323, arg1_323)
		if arg2_322 and table.contains(arg2_322, arg0_323) then
			return
		end

		arg0_322.loader:ReturnPrefab(arg1_323.trans.gameObject)

		arg1_322.extraItems[arg0_323] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_324, arg1_324, arg2_324)
	arg0_324.cameraBlendCallbacks[arg1_324] = arg2_324
end

function var0_0.UnRegisterCameraBlendFinished(arg0_325, arg1_325)
	arg0_325.cameraBlendCallbacks[arg1_325] = nil
end

function var0_0.OnCameraBlendFinished(arg0_326, arg1_326)
	if not arg1_326 then
		return
	end

	local var0_326 = table.removebykey(arg0_326.cameraBlendCallbacks, arg1_326)

	existCall(var0_326)
end

function var0_0.PlayHeartFX(arg0_327, arg1_327)
	local var0_327 = arg0_327.ladyDict[arg1_327]

	setActive(var0_327.effectHeart, false)
	setActive(var0_327.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_328, arg1_328)
	local var0_328 = arg1_328.name
	local var1_328 = arg0_328.expressionDict[var0_328]
	local var2_328 = 5

	if var1_328 then
		local var3_328 = var1_328.timer

		var3_328:Reset(nil, var2_328)
		var3_328:Start()

		if var1_328.instance then
			setActive(var1_328.instance, false)
			setActive(var1_328.instance, true)
		end

		return
	end

	local var4_328 = {
		name = var0_328,
		timer = Timer.New(function()
			arg0_328:RemoveExpression(var0_328)
		end, var2_328, 1, true)
	}

	arg0_328.expressionDict[var0_328] = var4_328

	arg0_328.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_328, var0_328, function(arg0_330)
		var4_328.instance = arg0_330

		onNextTick(function()
			local var0_331 = arg0_328.ladyDict[arg0_328.apartment:GetConfigID()]

			setParent(arg0_330, var0_331.ladyHeadCenter)
		end)
		setLocalPosition(arg0_330, Vector3(0, 0, -0.2))
		setActive(arg0_330, false)
		setActive(arg0_330, true)
	end, var4_328)
end

function var0_0.RemoveExpression(arg0_332, arg1_332)
	local var0_332 = arg0_332.expressionDict[arg1_332]

	if not var0_332 then
		return
	end

	arg0_332.loader:ClearRequest(var0_332)

	if var0_332.instance then
		arg0_332.loader:ReturnPrefab(var0_332.instance)
	end

	arg0_332.expressionDict[arg1_332] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_333, arg1_333, arg2_333)
	setActive(arg1_333.ladyWatchFloat, arg2_333)
end

function var0_0.RegisterGlobalVolume(arg0_334)
	local var0_334 = arg0_334.globalVolume
	local var1_334 = LuaHelper.GetOrAddVolumeComponent(var0_334, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_334 = LuaHelper.GetOrAddVolumeComponent(var0_334, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	arg0_334.originalCameraSettings = {
		depthOfField = {
			enabled = var1_334.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_334.gaussianStart.min,
				value = var1_334.gaussianStart.value
			},
			blurRadius = {
				min = var1_334.blurRadius.min,
				max = var1_334.blurRadius.max,
				value = var1_334.blurRadius.value
			}
		},
		postExposure = {
			value = var2_334.postExposure.value
		},
		contrast = {
			min = var2_334.contrast.min,
			max = var2_334.contrast.max,
			value = var2_334.contrast.value
		},
		saturate = {
			min = var2_334.saturation.min,
			max = var2_334.saturation.max,
			value = var2_334.saturation.value
		}
	}
	arg0_334.originalCameraSettings.depthOfField.enabled = true

	local var3_334 = var0_334:GetComponent(typeof(UnityEngine.Rendering.Volume))

	arg0_334.originalVolume = {
		profile = var3_334.sharedProfile,
		weight = var3_334.weight
	}
end

function var0_0.SettingCamera(arg0_335, arg1_335)
	arg0_335.activeCameraSettings = arg1_335

	local var0_335 = arg0_335.globalVolume
	local var1_335 = LuaHelper.GetOrAddVolumeComponent(var0_335, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_335 = LuaHelper.GetOrAddVolumeComponent(var0_335, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	var1_335.enabled:Override(arg1_335.depthOfField.enabled)
	var1_335.gaussianStart:Override(arg1_335.depthOfField.focusDistance.value)
	var1_335.gaussianEnd:Override(arg1_335.depthOfField.focusDistance.value + arg1_335.depthOfField.focusDistance.length)
	var1_335.blurRadius:Override(arg1_335.depthOfField.blurRadius.value)
	var2_335.postExposure:Override(arg1_335.postExposure.value)
	var2_335.contrast:Override(arg1_335.contrast.value)
	var2_335.saturation:Override(arg1_335.saturate.value)
end

function var0_0.GetCameraSettings(arg0_336)
	return arg0_336.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_337)
	arg0_337:SettingCamera(arg0_337.originalCameraSettings)

	arg0_337.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_338, arg1_338, arg2_338)
	if arg0_338.cameraVolume then
		arg0_338:RevertVolumeProfile()
	end

	arg0_338.loader:GetPrefab("dorm3d/effect/volume/" .. arg1_338, "", function(arg0_339)
		arg0_338.cameraVolume = arg0_339
	end)
end

function var0_0.RevertVolumeProfile(arg0_340)
	if arg0_340.cameraVolume then
		arg0_340.loader:ReturnPrefab(arg0_340.cameraVolume)

		arg0_340.cameraVolume = nil
	end
end

function var0_0.RecordCharacterLight(arg0_341)
	local var0_341 = arg0_341.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	arg0_341.originalCharacterColor = {
		color = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var0_341),
		intensity = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var0_341)
	}
end

function var0_0.SetCharacterLight(arg0_342, arg1_342, arg2_342, arg3_342)
	local var0_342 = arg0_342.characterLight:GetComponent(typeof(Light))
	local var1_342 = Color.Lerp(arg0_342.originalCharacterColor.color, arg1_342, arg3_342)
	local var2_342 = math.lerp(arg0_342.originalCharacterColor.intensity, arg2_342, arg3_342)
	local var3_342 = arg0_342.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var3_342, var1_342)
	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var3_342, var2_342)
end

function var0_0.RevertCharacterLight(arg0_343)
	arg0_343:SetCharacterLight(arg0_343.originalCharacterColor.color, arg0_343.originalCharacterColor.intensity, 1)
end

function var0_0.onBackPressed(arg0_344)
	if arg0_344.exited or arg0_344.retainCount > 0 then
		-- block empty
	else
		arg0_344:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_345, arg1_345, arg2_345, arg3_345, arg4_345)
	arg0_345.dormSceneMgr:LoadTimelineScene({
		name = arg1_345,
		assetRootName = arg0_345.apartment:getConfig("asset_name"),
		isCache = arg2_345,
		waitForTimeline = arg3_345,
		callName = arg0_345.apartment:GetCallName(),
		loadSceneFunc = function(arg0_346, arg1_346)
			local var0_346 = GameObject.Find("[actor]").transform

			arg0_345:HXCharacter(tf(var0_346))
		end
	}, arg4_345)
end

function var0_0.UnloadTimelineScene(arg0_347, arg1_347, arg2_347, arg3_347)
	arg0_347.dormSceneMgr:UnloadTimelineScene(arg1_347, arg2_347, arg3_347)
end

function var0_0.ChangeArtScene(arg0_348, arg1_348, arg2_348)
	warning(arg0_348.dormSceneMgr.artSceneInfo, "->", arg1_348, arg1_348 == arg0_348.dormSceneMgr.sceneInfo)

	local var0_348 = {}

	table.insert(var0_348, function(arg0_349)
		arg0_348.dormSceneMgr:ChangeArtScene(arg1_348, arg0_349)
	end)

	if arg1_348 == arg0_348.dormSceneMgr.sceneInfo or arg0_348.dormSceneMgr.artSceneInfo == arg0_348.dormSceneMgr.sceneInfo then
		table.insert(var0_348, function(arg0_350)
			setActive(arg0_348.slotRoot, arg1_348 == arg0_348.dormSceneMgr.sceneInfo)
			arg0_350()
		end)
	end

	if arg1_348 == arg0_348.dormSceneMgr.sceneInfo then
		table.insert(var0_348, function(arg0_351)
			arg0_348:SwitchDayNight(arg0_348.contextData.timeIndex)
			onNextTick(function()
				arg0_348:RefreshSlots()
				arg0_351()
			end)
		end)
	end

	seriesAsync(var0_348, arg2_348)
end

function var0_0.ChangeSubScene(arg0_353, arg1_353, arg2_353)
	warning(arg0_353.dormSceneMgr.subSceneInfo, "->", arg1_353, arg1_353 == arg0_353.dormSceneMgr.subSceneInfo)

	local var0_353 = {}

	table.insert(var0_353, function(arg0_354)
		arg0_353.dormSceneMgr:ChangeSubScene(arg1_353, arg0_354)
	end)

	local var1_353 = arg0_353.ladyDict[arg0_353.apartment:GetConfigID()]

	table.insert(var0_353, function(arg0_355)
		if arg1_353 == arg0_353.dormSceneMgr.sceneInfo then
			var1_353.ladyActiveZone = var1_353.walkBornPoint or var1_353.ladyBaseZone
		else
			var1_353.ladyActiveZone = var1_353.walkBornPoint or "Default"
		end

		arg0_355()
	end)

	if arg1_353 ~= arg0_353.dormSceneMgr.subSceneInfo then
		table.insert(var0_353, function(arg0_356)
			local var0_356, var1_356 = Dorm3dSceneMgr.ParseInfo(arg1_353)
			local var2_356 = var0_356 .. "_base"

			arg0_353:ResetSceneStructure(SceneManager.GetSceneByName(var2_356))

			if arg1_353 == arg0_353.dormSceneMgr.sceneInfo then
				arg0_353:RefreshSlots()
			else
				arg0_353:SwitchAnim(var1_353, var0_0.ANIM.IDLE)
			end

			if arg0_353.dormSceneMgr.subSceneInfo == arg0_353.dormSceneMgr.sceneInfo then
				local var3_356 = Clone(arg0_353.room)

				var3_356.furnitures = {}

				arg0_353:RefreshSlots(var3_356)
			end

			arg0_356()
		end)
	end

	table.insert(var0_353, function(arg0_357)
		onNextTick(function()
			arg0_353:ChangeCharacterPosition(var1_353)
			arg0_353:ChangePlayerPosition(var1_353.ladyActiveZone)
			arg0_353:TriggerLadyDistance()
			arg0_353:CheckInSector()
			arg0_357()
		end)
	end)
	seriesAsync(var0_353, arg2_353)
end

function var0_0.IsPointInSector(arg0_359, arg1_359)
	local var0_359 = arg1_359 - Vector3.New(unpack(arg0_359.Position))

	if var0_359.y > arg0_359.Radius then
		return false
	end

	var0_359.y = 0

	if var0_359.magnitude > arg0_359.Radius then
		return false
	end

	local var1_359 = Quaternion.Euler(unpack(arg0_359.Rotation))

	return Vector3.Angle(var1_359 * Vector3.forward, var0_359) <= arg0_359.Angle / 2
end

function var0_0.GetRestritedHeightRange(arg0_360)
	if not arg0_360.isMultiFloor then
		return arg0_360.restrictedHeightRange
	else
		for iter0_360 = #arg0_360.restrictedHeightRange, 1, -1 do
			local var0_360 = arg0_360.restrictedHeightRange[iter0_360]

			if arg0_360.mainCameraTF.position.y >= var0_360[1] then
				return var0_360
			end
		end

		return arg0_360.restrictedHeightRange[1]
	end
end

function var0_0.willExit(arg0_361)
	arg0_361.joystickTimer:Stop()
	arg0_361.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_361.updateHandler)
	arg0_361:StopIKHandTimer()

	if arg0_361.moveTimer then
		arg0_361.moveTimer:Stop()

		arg0_361.moveTimer = nil
	end

	if arg0_361.moveWaitTimer then
		arg0_361.moveWaitTimer:Stop()

		arg0_361.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_361.furnitures) then
		eachChild(arg0_361.furnitures, function(arg0_362)
			local var0_362 = GetComponent(arg0_362, typeof(EventTriggerListener))

			if not var0_362 then
				return
			end

			var0_362:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_361, iter1_361 in pairs(arg0_361.ladyDict) do
		GetComponent(iter1_361.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_361.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_361.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_361.blockLayer, arg0_361._tf)
	table.Foreach(arg0_361.expressionDict, function(arg0_363)
		arg0_361:RemoveExpression(arg0_363)
	end)
	arg0_361.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_361.dormSceneMgr:Dispose()

	arg0_361.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)

	if arg0_361.transformFilter then
		arg0_361.transformFilter:Dispose()
	end
end

return var0_0
