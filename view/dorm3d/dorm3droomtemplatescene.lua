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
var0_0.ON_IK_TRIGGER = "Dorm3dRoomTemplateScene.ON_IK_TRIGGER"
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
	map_siriushostel_01_base = {
		Chair = {
			Radius = 2,
			Angle = 120,
			Position = {
				0.3069999,
				0,
				-1.87
			},
			Rotation = {
				0,
				90,
				0
			}
		},
		Table = {
			Radius = 2,
			Angle = 120,
			Position = {
				2.054,
				0,
				1.889
			},
			Rotation = {
				0,
				-180,
				0
			}
		},
		Bed = {
			Radius = 2,
			Angle = 120,
			Position = {
				-1.694,
				0,
				2.485
			},
			Rotation = {
				0,
				180,
				0
			}
		}
	},
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

function var0_0.lowerAdpter(arg0_6)
	return true
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
	arg0_9.room = getProxy(ApartmentProxy):getRoom(arg0_9.contextData.roomId)
	arg0_9.sceneInfo = string.lower(arg0_9.room:getConfig("scene_info"))
	arg0_9.artSceneInfo = arg0_9.sceneInfo
	arg0_9.subSceneInfo = arg0_9.sceneInfo

	local var0_9, var1_9 = unpack(string.split(arg0_9.sceneInfo, "|"))
	local var2_9 = {
		function(arg0_10)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_9 .. "/" .. var0_9 .. "_scene"), var0_9, LoadSceneMode.Additive, function(arg0_11, arg1_11)
				SceneManager.SetActiveScene(arg0_11)

				local var0_11 = getSceneRootTFDic(arg0_11).MainCamera

				if var0_11 then
					setActive(var0_11, false)
				end

				arg0_10()
			end)
		end,
		function(arg0_12)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_9 .. "/" .. var0_9 .. "_base_scene"), var0_9 .. "_base", LoadSceneMode.Additive, arg0_12)
		end
	}

	table.insert(var2_9, function(arg0_13)
		arg0_9:LoadCharacter(arg0_9.contextData.groupIds, arg0_13)
	end)
	seriesAsync(var2_9, arg1_9)
end

function var0_0.init(arg0_14)
	arg0_14:BindEvent()
	arg0_14:InitData()
	arg0_14:initScene()
	arg0_14:initNodeCanvas()

	for iter0_14, iter1_14 in pairs(arg0_14.ladyDict) do
		iter1_14:InitCharacter(iter1_14, iter0_14)

		iter1_14.ladyBaseZone = arg0_14.contextData.ladyZone[iter0_14]
		iter1_14.ladyActiveZone = iter1_14.ladyBaseZone

		iter1_14:ChangeCharacterPosition()
	end

	arg0_14.retainCount = 0
	arg0_14.sceneBlockLayer = arg0_14._tf:Find("SceneBlock")

	setActive(arg0_14.sceneBlockLayer, false)

	arg0_14.blockLayer = arg0_14._tf:Find("Block")

	setActive(arg0_14.blockLayer, false)

	arg0_14.blackLayer = arg0_14._tf:Find("BlackScreen")

	setActive(arg0_14.blackLayer, false)
	arg0_14:ChangePlayerPosition()

	arg0_14.cacheSceneDic = {}
	arg0_14.sceneGroupDic = {}
	arg0_14.lastSceneRootDict = {}

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
		if arg1_21.blockIK then
			return
		end

		if arg1_21.ikHandler then
			return
		end

		local var0_21 = _.detect(arg1_21.readyIKLayers, function(arg0_22)
			return arg0_22.ikData:IsTrigger(Dorm3dIK.TRIGGER.TOUCH_BODY, arg2_21)
		end)

		if not var0_21 then
			return
		end

		arg1_21.ikHandler = arg0_15:EnableIKLayer(arg1_21, var0_21.ikData)

		local var1_21 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect

		arg3_21 = Vector2.New(arg3_21.x / Screen.width * var1_21.width, arg3_21.y / Screen.height * var1_21.height)

		if not arg1_21.holdingStatus[var0_21.ikData] then
			arg1_21.ikHandler.originScreenPosition = arg3_21
		else
			local var2_21 = arg3_21 - arg1_21.ikHandler.screenPosition

			arg1_21.ikHandler.originScreenPosition = arg1_21.ikHandler.originScreenPosition + var2_21
			arg1_21.holdingStatus[var0_21.ikData] = nil
		end
	end)
	arg0_15:bind(var0_0.ON_DRAG_CHARACTER_BODY, function(arg0_23, arg1_23, arg2_23)
		if not arg1_23.ikHandler then
			return
		end

		local var0_23 = arg1_23.ikHandler
		local var1_23 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect

		arg2_23 = Vector2.New(arg2_23.x / Screen.width * var1_23.width, arg2_23.y / Screen.height * var1_23.height)
		var0_23.screenPosition = arg2_23

		local var2_23 = arg2_23 - var0_23.originScreenPosition
		local var3_23 = var0_23.ikData
		local var4_23 = var0_23.rect
		local var5_23 = var4_23:Contains(var2_23)
		local var6_23 = var0_23.triggerRect and var0_23.triggerRect:Contains(var2_23)

		if not var5_23 and var3_23:GetActionTriggerParams()[1] == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET and var6_23 then
			arg1_23.ikHandler = nil
			arg1_23.ikNextCheckStamp = nil

			arg1_23:DeactiveIKLayer(var3_23)
			table.insert(arg1_23.activeIKLayers, var3_23)
			arg1_23:PlayIKAction(var3_23)

			return
		end

		local function var7_23()
			if var5_23 then
				return var2_23
			end

			local var0_24 = var2_23
			local var1_24 = var4_23.center
			local var2_24 = {
				{
					Vector2.New(var4_23.xMin, var4_23.yMin),
					Vector2.New(var4_23.xMin, var4_23.yMax)
				},
				{
					Vector2.New(var4_23.xMin, var4_23.yMax),
					Vector2.New(var4_23.xMax, var4_23.yMax)
				},
				{
					Vector2.New(var4_23.xMax, var4_23.yMax),
					Vector2.New(var4_23.xMax, var4_23.yMin)
				},
				{
					Vector2.New(var4_23.xMax, var4_23.yMin),
					Vector2.New(var4_23.xMin, var4_23.yMin)
				}
			}

			for iter0_24 = 1, 4 do
				local var3_24, var4_24 = SegmentUtil.GetCrossPoint(var1_24, var0_24, unpack(var2_24[iter0_24]))

				if var3_24 then
					return var4_24
				end
			end

			assert(false)

			return var0_24
		end

		arg1_23.ikHandler.targetScreenOffset = var7_23()

		local var8_23 = Vector2.New((arg2_23.x / var1_23.width - 0.5) * var1_23.width, (arg2_23.y / var1_23.height - 0.5) * var1_23.height)

		setAnchoredPosition(arg1_23:GetIKHandTF(), var8_23)
	end)
	arg0_15:bind(var0_0.ON_RELEASE_CHARACTER_BODY, function(arg0_25, arg1_25)
		if not arg1_25.ikHandler then
			return
		end

		local var0_25 = arg1_25.ikHandler
		local var1_25 = arg1_25.ikHandler.ikData

		arg1_25.ikHandler = nil
		arg1_25.ikNextCheckStamp = nil

		local var2_25
		local var3_25 = var1_25:GetActionTriggerParams()

		if var3_25[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE then
			var2_25 = true
		elseif var3_25[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET then
			local var4_25 = var0_25.screenPosition - var0_25.originScreenPosition

			if var0_25.triggerRect and var0_25.triggerRect:Contains(var4_25) then
				var2_25 = true
			end
		end

		arg1_25:DeactiveIKLayer(var1_25)

		if var2_25 then
			arg1_25:PlayIKAction(var1_25)
		else
			local var5_25 = var1_25:GetRevertTime()

			if var5_25 < 999 then
				table.insert(arg1_25.activeIKLayers, var1_25)
				arg1_25.RevertIKLayer(arg1_25, var5_25)
			else
				arg1_25.holdingStatus[var1_25] = {
					ikHandler = var0_25
				}
			end
		end

		arg1_25:emit(var0_0.ON_IK_STATUS_CHANGED, var1_25:GetConfigID(), var0_0.IK_STATUS.RELEASE)
	end)
	arg0_15:bind(var0_0.ON_POV_STICK_MOVE_BEGIN, function(arg0_26, arg1_26)
		if arg0_15.pinchMode then
			return
		end

		arg0_15.moveStickOrigin = arg1_26.position
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

	arg0_15:bind(var0_0.ON_POV_STICK_MOVE_END, function(arg0_28, arg1_28)
		var0_15()
	end)
	arg0_15:bind(var0_0.ON_POV_STICK_MOVE, function(arg0_29, arg1_29)
		if arg0_15.pinchMode then
			var0_15()

			return
		end

		if not arg0_15.moveStickDraging then
			return
		end

		arg0_15.moveStickPosition = arg0_15.moveStickPosition + arg1_29

		if isActive(arg0_15.povLayer:Find("Guide")) then
			setActive(arg0_15.povLayer:Find("Guide"), false)
		end
	end)

	local var1_15 = 32.4 / Screen.height

	arg0_15:bind(var0_0.ON_POV_STICK_VIEW, function(arg0_30, arg1_30)
		if arg0_15.pinchMode then
			return
		end

		arg1_30 = arg1_30 * var1_15

		local var0_30 = arg1_30.x
		local var1_30 = arg1_30.y

		local function var2_30(arg0_31, arg1_31, arg2_31)
			local var0_31 = arg0_31[arg1_31]

			var0_31.m_InputAxisValue = arg2_31
			arg0_31[arg1_31] = var0_31
		end

		if isActive(arg0_15.cameras[var0_0.CAMERA.POV]) then
			var2_30(arg0_15.compPovAim, "m_HorizontalAxis", var0_30)
			var2_30(arg0_15.compPovAim, "m_VerticalAxis", var1_30)
		elseif isActive(arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			local var3_30 = arg0_15.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

			var2_30(var3_30, "m_HorizontalAxis", var0_30)
			var2_30(var3_30, "m_VerticalAxis", var1_30)
		end
	end)
	arg0_15:bind(var0_0.PHOTO_CALL, function(arg0_32, arg1_32, ...)
		local var0_32 = arg0_15.ladyDict[arg0_15.apartment:GetConfigID()]

		arg0_15[arg1_32](var0_32, ...)
	end)
end

function var0_0.initScene(arg0_33)
	local var0_33, var1_33 = unpack(string.split(arg0_33.sceneInfo, "|"))
	local var2_33 = SceneManager.GetSceneByName(var0_33 .. "_base")

	arg0_33:ResetSceneStructure(var2_33)

	arg0_33.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_33.camBrain = arg0_33.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_33.camBrainEvenetHandler = arg0_33.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_33.raycastCamera = arg0_33.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_33.sceneRaycaster = arg0_33.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_33.player = GameObject.Find("Player").transform
	arg0_33.playerEye = arg0_33.player:Find("Eye")
	arg0_33.playerFoot = arg0_33.player:Find("Foot")

	setActive(arg0_33.playerFoot, false)

	arg0_33.playerController = arg0_33.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_33.attachedPoints = {}

	eachChild(arg0_33.furnitures, function(arg0_34)
		table.insert(arg0_33.attachedPoints, 1, arg0_34)
	end)

	arg0_33.dollyParent = GameObject.Find("Dollys").transform
	arg0_33.modelRoot = GameObject.Find("scene_root").transform
	arg0_33.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_33.slotRoot, true)
	arg0_33:InitSlots()

	arg0_33.resTF = GameObject.Find("Res").transform

	tolua.loadassembly("Cinemachine")
	tolua.loadassembly("MagicaCloth")

	local var3_33 = GameObject.Find("CM Cameras").transform

	eachChild(var3_33, function(arg0_35)
		setActive(arg0_35, false)
	end)

	arg0_33.camBrain.enabled = false
	arg0_33.camBrain.enabled = true
	arg0_33.cameraAim = var3_33:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraAim2 = var3_33:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraFree = nil
	arg0_33.cameraFurnitureWatch = nil
	arg0_33.cameraRole = var3_33:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraRole2 = var3_33:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraTalk = var3_33:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraGift = var3_33:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraRoleWatch = nil
	arg0_33.cameras = {
		arg0_33.cameraAim,
		arg0_33.cameraAim2,
		arg0_33.cameraRole,
		arg0_33.cameraTalk,
		arg0_33.cameraRoleWatch,
		[var0_0.CAMERA.GIFT] = arg0_33.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_33.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_33:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_33:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_33:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	}
	arg0_33.compDolly = arg0_33.cameraAim:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Body)
	arg0_33.compPovAim = arg0_33.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_33.cameraRoot = var3_33
	arg0_33.POVOriginalFOV = arg0_33:GetPOVFOV()
	arg0_33.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_33.restrictedBox, false)

	arg0_33.restrictedHeightRange = {
		arg0_33.restrictedBox:Find("Floor").position.y,
		arg0_33.restrictedBox:Find("Celling").position.y
	}
	arg0_33.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_33.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))

	arg0_33:SwitchDayNight(arg0_33.contextData.timeIndex)

	arg0_33.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_33 .. "_base")).CutIn

	if arg0_33.tfCutIn then
		arg0_33.modelCutIn = {
			lady = arg0_33.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_33.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_33.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_36, arg1_36)
	if not IsNil(arg0_36.daynightCtrlComp) then
		arg0_36.daynightCtrlComp:SwitcherToIndex(arg1_36 - 1)
	end

	arg0_36:InitLightSettings()
end

function var0_0.InitLightSettings(arg0_37)
	arg0_37.globalVolume = GameObject.Find("GlobalVolume")

	arg0_37:RegisterGlobalVolume()

	arg0_37.characterLight = GameObject.Find("CharacterLight")

	arg0_37:RecordCharacterLight()

	local var0_37 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_37:GetComponentsInChildren(typeof(Light), true), function(arg0_38, arg1_38)
		arg1_38.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.ResetSceneStructure(arg0_39, arg1_39)
	table.IpairsCArray(arg1_39:GetRootGameObjects(), function(arg0_40, arg1_40)
		if arg1_40.name == "Furnitures" then
			arg0_39.furnitures = tf(arg1_40)

			eachChild(arg0_39.furnitures, function(arg0_41)
				if arg0_41:Find("FreeLook Camera") then
					setActive(arg0_41:Find("FreeLook Camera"), false)
				end

				if arg0_41:Find("FreeLook Camera") then
					setActive(arg0_41:Find("RoleWatch Camera"), false)
				end

				if arg0_41:Find("IKCamera") then
					setActive(arg0_41:Find("IKCamera"), false)
				end

				local var0_41 = arg0_41:GetComponent(typeof(UnityEngine.Collider))

				if not var0_41 then
					return
				end

				var0_41.enabled = false
			end)
		end
	end)

	arg0_39.sectorsDic = arg0_39.sectorsDic or {}

	if not arg0_39.sectorsDic[arg1_39.name] then
		arg0_39.sectorsDic[arg1_39.name] = table.shallowCopy(var2_0[arg1_39.name])

		setmetatable(arg0_39.sectorsDic[arg1_39.name], {
			__index = function(arg0_42, arg1_42)
				local var0_42 = arg0_39.furnitures:Find(arg1_42 .. "/StayPoint")

				if var0_42 then
					local var1_42 = var0_42.position
					local var2_42 = var0_42.eulerAngles

					arg0_42[arg1_42] = {
						Radius = 2,
						Angle = 120,
						Position = {
							var1_42.x,
							var1_42.y,
							var1_42.z
						},
						Rotation = {
							var2_42.x,
							var2_42.y,
							var2_42.z
						}
					}

					return arg0_42[arg1_42]
				else
					return nil
				end
			end
		})
	end

	arg0_39.activeSectors = arg0_39.sectorsDic[arg1_39.name]
end

function var0_0.InitSlots(arg0_43)
	local var0_43 = arg0_43.room:GetSlots()
	local var1_43 = arg0_43.modelRoot:GetComponentsInChildren(typeof(Transform), true)

	arg0_43.slotDict = {}

	_.each(var0_43, function(arg0_44)
		local var0_44 = arg0_44:GetFurnitureName()
		local var1_44 = arg0_44:GetConfigID()
		local var2_44 = arg0_43.slotRoot:Find(tostring(var1_44))

		assert(var2_44)

		local var3_44 = {
			trans = var2_44
		}
		local var4_44 = var2_44:Find("Selector")

		if var4_44 then
			GetOrAddComponent(var4_44, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_45, arg1_45)
				arg0_43:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_44)
			end)
			setActive(var4_44, false)
		end

		local var5_44

		for iter0_44 = 0, var1_43.Length - 1 do
			local var6_44 = var1_43[iter0_44]

			if var6_44.name == var0_44 then
				var5_44 = var6_44

				break
			end
		end

		if var5_44 then
			var3_44.model = var5_44
		end

		arg0_43.slotDict[var1_44] = var3_44
	end)
end

function var0_0.SetContactStateDic(arg0_46, arg1_46)
	arg0_46.contactStateDic = arg1_46
	arg0_46.hideContactStateDic = {}
	arg0_46.contactInRangeDic = {}

	for iter0_46, iter1_46 in pairs(arg0_46.contactStateDic) do
		arg0_46.hideContactStateDic[iter0_46] = math.min(iter1_46, ApartmentRoom.ITEM_UNLOCK)
		arg0_46.contactInRangeDic[iter0_46] = false
	end

	arg0_46:ActiveContact()
end

function var0_0.TempHideContact(arg0_47, arg1_47)
	arg0_47.hideConcatFlag = arg1_47

	arg0_47:ActiveContact()
end

function var0_0.ActiveContact(arg0_48)
	for iter0_48, iter1_48 in pairs(arg0_48.contactInRangeDic) do
		arg0_48:UpdateContactDisplay(iter0_48, arg0_48.contactInRangeDic[iter0_48] and not arg0_48.hideConcatFlag and arg0_48.contactStateDic[iter0_48] or arg0_48.hideContactStateDic[iter0_48])
	end
end

function var0_0.UpdateContactDisplay(arg0_49, arg1_49, arg2_49)
	local var0_49 = pg.dorm3d_collection_template[arg1_49]

	for iter0_49, iter1_49 in ipairs(var0_49.vfx_prefab) do
		local var1_49 = arg0_49.modelRoot:Find(iter1_49)

		if arg0_49:IsModeInHidePending(iter1_49) then
			-- block empty
		elseif not arg0_49.modelRoot:Find(iter1_49) then
			warning(arg1_49, iter1_49)
		else
			setActive(var1_49, arg2_49 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_49, iter3_49 in ipairs(var0_49.model) do
		if arg0_49:IsModeInHidePending(iter3_49) then
			-- block empty
		elseif not arg0_49.modelRoot:Find(iter3_49) then
			warning(arg1_49, iter3_49)
		else
			local var2_49 = arg0_49.modelRoot:Find(iter3_49)
			local var3_49 = GetComponent(var2_49, typeof(EventTriggerListener))

			if arg2_49 == ApartmentRoom.ITEM_FIRST then
				var3_49 = var3_49 or GetOrAddComponent(var2_49, typeof(EventTriggerListener))

				var3_49:AddPointClickFunc(function(arg0_50, arg1_50)
					arg0_49:emit(var0_0.CLICK_CONTACT, arg1_49)
				end)

				var3_49.enabled = true
			elseif var3_49 then
				var3_49.enabled = false
			end

			setActive(var2_49, arg2_49 > ApartmentRoom.ITEM_LOCK)
		end
	end
end

function var0_0.SetFloatEnable(arg0_51, arg1_51)
	arg0_51.enableFloatUpdate = arg1_51

	if arg1_51 then
		arg0_51.ladyDict[arg0_51.apartment:GetConfigID()]:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_52)
	local var0_52 = arg0_52:GetScreenPosition(arg0_52.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var1_52 = arg0_52:GetLocalPosition(var0_52, arg0_52.rtFloatPage)

	setLocalPosition(arg0_52.rtFloatPage:Find("lady"), var1_52)
end

function var0_0.LoadCharacter(arg0_53, arg1_53, arg2_53)
	arg0_53.hxMatDict = {}
	arg0_53.ladyDict = {}
	arg0_53.skinDict = {}

	local var0_53 = {}

	for iter0_53, iter1_53 in ipairs(arg1_53) do
		local var1_53 = setmetatable({}, {
			__index = arg0_53
		})

		arg0_53.ladyDict[iter1_53] = var1_53

		local var2_53 = getProxy(ApartmentProxy):getApartment(iter1_53)
		local var3_53 = var2_53:getConfig("asset_name")
		local var4_53 = var2_53:GetSkinModelID(arg0_53.room:getConfig("tag"))
		local var5_53 = pg.dorm3d_resource[var4_53].model_id

		assert(var5_53)

		for iter2_53, iter3_53 in ipairs({
			"common",
			var5_53
		}) do
			local var6_53 = string.format("dorm3d/character/%s/res/%s", var3_53, iter3_53)

			if checkABExist(var6_53) then
				table.insert(var0_53, function(arg0_54)
					arg0_53.loader:LoadBundle(var6_53, function(arg0_55)
						for iter0_55, iter1_55 in ipairs(arg0_55:GetAllAssetNames()) do
							local var0_55, var1_55, var2_55 = string.find(iter1_55, "material_hx[/\\](.*).mat")

							if var0_55 then
								arg0_53.hxMatDict[var2_55] = {
									arg0_55,
									iter1_55
								}
							end
						end

						arg0_54()
					end)
				end)
			end
		end

		var1_53.skinId = var4_53
		var1_53.skinIdList = {
			var4_53
		}

		table.insert(var0_53, function(arg0_56)
			local var0_56 = string.format("dorm3d/character/%s/prefabs/%s", var3_53, var5_53)

			arg0_53.loader:GetPrefab(var0_56, "", function(arg0_57)
				var1_53.ladyGameobject = arg0_57
				arg0_53.skinDict[var4_53] = {
					ladyGameobject = arg0_57
				}

				arg0_56()
			end)
		end)

		if arg0_53.room:isPersonalRoom() then
			local var7_53 = var2_53:GetSkinModelID("touch")

			if var7_53 then
				table.insert(var1_53.skinIdList, var7_53)

				local var8_53 = pg.dorm3d_resource[var7_53].model_id

				table.insert(var0_53, function(arg0_58)
					local var0_58 = string.format("dorm3d/character/%s/prefabs/%s", var3_53, var8_53)

					arg0_53.loader:GetPrefab(var0_58, "", function(arg0_59)
						arg0_53.skinDict[var7_53] = {
							ladyGameobject = arg0_59
						}
						GetComponent(arg0_59, "GraphOwner").enabled = false

						onNextTick(function()
							setActive(arg0_59, false)
						end)
						arg0_58()
					end)
				end)
			end
		end

		if arg0_53.contextData.pendingDic[iter1_53] then
			local var9_53 = pg.dorm3d_welcome[arg0_53.contextData.pendingDic[iter1_53]]

			if var9_53.item_prefab ~= "" then
				table.insert(var0_53, function(arg0_61)
					local var0_61 = string.lower("dorm3d/furniture/item/" .. var9_53.item_prefab)

					arg0_53.loader:GetPrefab(var0_61, "", function(arg0_62)
						var1_53.tfPendintItem = arg0_62.transform

						onNextTick(function()
							setActive(arg0_62, false)
						end)
						arg0_61()
					end)
				end)
			end
		end
	end

	parallelAsync(var0_53, arg2_53)
end

function var0_0.HXCharacter(arg0_64, arg1_64)
	if not HXSet.isHx() then
		return
	end

	local var0_64 = arg1_64:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_64, function(arg0_65, arg1_65)
		local var0_65 = arg1_65.sharedMaterials
		local var1_65 = false

		table.IpairsCArray(var0_65, function(arg0_66, arg1_66)
			local var0_66 = arg1_66.name

			if not arg0_64.hxMatDict[var0_66] then
				return
			end

			var1_65 = true

			local var1_66, var2_66 = unpack(arg0_64.hxMatDict[var0_66])
			local var3_66 = var1_66:LoadAssetSync(var2_66, typeof(Material), false, false)

			var0_65[arg0_66] = var3_66

			warning("Replace HX Material", arg0_64.hxMatDict[var0_66][2])
		end)

		if var1_65 then
			arg1_65.sharedMaterials = var0_65
		end
	end)
end

function var0_0.InitCharacter(arg0_67, arg1_67, arg2_67)
	arg1_67.lady = arg1_67.ladyGameobject.transform

	arg1_67.lady:SetParent(arg0_67.mainCameraTF)
	arg1_67.lady:SetParent(nil)

	arg1_67.ladyHeadIKComp = arg1_67.lady:GetComponent(typeof(HeadAimIK))
	arg1_67.ladyHeadIKComp.AimTarget = arg0_67.mainCameraTF:Find("AimTarget")
	arg1_67.ladyHeadIKData = {
		DampTime = arg1_67.ladyHeadIKComp.DampTime,
		blinkSpeed = arg1_67.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg1_67.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg1_67.ladyHeadIKComp.HeadWeight
	}

	local var0_67 = {}

	table.Foreach(var1_0, function(arg0_68, arg1_68)
		var0_67[arg1_68] = arg0_68
	end)

	arg1_67.ladyAnimator = arg1_67.lady:GetComponent(typeof(Animator))
	arg1_67.ladyAnimBaseLayerIndex = arg1_67.ladyAnimator:GetLayerIndex("Base Layer")
	arg1_67.ladyAnimFaceLayerIndex = arg1_67.ladyAnimator:GetLayerIndex("Face")
	arg1_67.ladyBoneMaps = {}

	local var1_67 = arg1_67.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_67, function(arg0_69, arg1_69)
		if arg1_69.name == "BodyCollider" then
			arg1_67.ladyCollider = arg1_69

			setActive(arg1_69, true)
		elseif arg1_69.name == "SafeCollider" then
			arg1_67.ladySafeCollider = arg1_69

			setActive(arg1_69, false)
		elseif arg1_69.name == "Interest" then
			arg1_67.ladyInterestRoot = arg1_69
		elseif arg1_69.name == "Head Center" then
			arg1_67.ladyHeadCenter = arg1_69
		end

		if var0_67[arg1_69.name] then
			arg1_67.ladyBoneMaps[var0_67[arg1_69.name]] = arg1_69
		end
	end)

	arg1_67.ladyColliders = {}
	arg1_67.ladyTouchColliders = {}

	table.IpairsCArray(arg1_67.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_70, arg1_70)
		if arg1_70:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_70)

		local var0_70 = child.name
		local var1_70 = var0_70 and string.find(var0_70, "Collider") or -1

		if var1_70 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_70)

			return
		end

		local var2_70 = string.sub(var0_70, 1, var1_70 - 1)

		if var0_0.BONE_TO_TOUCH[var2_70] == nil then
			return
		end

		arg1_67.ladyColliders[var2_70] = child

		table.insert(arg0_67.ladyTouchColliders, child)
		setActive(child, false)
	end)
	arg0_67:HXCharacter(arg1_67.lady)
	;(function()
		local var0_71 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_71 = "vfx_function_aixin02"

		arg0_67.loader:GetPrefab(var0_71, var1_71, function(arg0_72)
			arg1_67.effectHeart = arg0_72

			setActive(arg0_72, false)
			onNextTick(function()
				setParent(arg1_67.effectHeart, arg1_67.ladyHeadCenter)
			end)
		end)
	end)()

	arg1_67.clothComps = {}
	arg1_67.ladyClothCompSettings = {}

	table.IpairsCArray(arg1_67.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_74, arg1_74)
		table.insert(arg1_67.clothComps, arg1_74)

		arg1_67.ladyClothCompSettings[arg1_74] = {
			enabled = arg1_74.enabled
		}
	end)

	arg1_67.clothColliderDict = {}
	arg1_67.ladyClothColliderSettings = {}

	local var2_67 = typeof("MagicaCloth.MagicaCapsuleCollider")

	table.IpairsCArray(arg1_67.lady:GetComponentsInChildren(var2_67, true), function(arg0_75, arg1_75)
		arg1_67.clothColliderDict[arg1_75.name] = arg1_75
		arg1_67.ladyClothColliderSettings[arg1_75] = {
			enabled = arg1_75.enabled,
			StartRadius = ReflectionHelp.RefGetProperty(var2_67, "StartRadius", arg1_75),
			EndRadius = ReflectionHelp.RefGetProperty(var2_67, "EndRadius", arg1_75)
		}
	end)
	arg1_67:EnableCloth(arg1_67, false)

	arg1_67.ladyIKRoot = arg1_67.lady:Find("IKLayers")

	eachChild(arg1_67.ladyIKRoot, function(arg0_76)
		setActive(arg0_76, false)
	end)
	GetComponent(arg1_67.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_77, arg1_77)
		if arg1_77.rawPointerPress.transform == arg1_67.ladyCollider then
			arg1_67:emit(var0_0.CLICK_CHARACTER, arg2_67)
		else
			local var0_77 = table.keyof(arg1_67.ladyColliders, arg1_77.rawPointerPress.transform)

			arg1_67:emit(var0_0.ON_TOUCH_CHARACTER, var0_0.BONE_TO_TOUCH[var0_77] or arg1_77.rawPointerPress.name)
		end
	end)
	arg1_67.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_78)
		if arg1_67.nowState and arg0_78.animatorStateInfo:IsName(arg1_67.nowState) then
			existCall(arg1_67.stateCallback)

			return
		end

		local var0_78 = arg0_78.animatorStateInfo

		for iter0_78, iter1_78 in pairs(arg1_67.animCallbacks) do
			if var0_78:IsName(iter0_78) then
				warning("Active", iter0_78)

				local var1_78 = table.removebykey(arg1_67.animCallbacks, iter0_78)

				existCall(var1_78)

				return
			end
		end

		if arg0_78.stringParameter ~= "" then
			arg0_67:OnAnimationEvent(arg0_78)
		end
	end)

	arg1_67.animEventCallbacks = {}
	arg1_67.animCallbacks = {}
end

function var0_0.SwitchCharacterSkin(arg0_79, arg1_79, arg2_79, arg3_79)
	local var0_79 = arg0_79.skinIdList

	assert(table.contains(var0_79, arg2_79))

	local var1_79 = arg0_79:GetCurrentAnim()
	local var2_79 = arg0_79.skinId
	local var3_79 = arg0_79.skinDict[var2_79].ladyGameobject
	local var4_79 = var3_79.transform.position
	local var5_79 = var3_79.transform.rotation

	setActive(var3_79, false)

	arg0_79.skinId = arg2_79

	setActive(arg0_79.skinDict[arg2_79].ladyGameobject, true)

	arg0_79.ladyGameobject = arg0_79.skinDict[arg2_79].ladyGameobject
	arg0_79.ladyCollider = nil

	arg0_79:InitCharacter(arg0_79, arg1_79)
	arg0_79.ladyAnimator:Play(var1_79, arg0_79.ladyAnimBaseLayerIndex)
	arg0_79.ladyAnimator:Update(0)
	arg0_79.lady:SetPositionAndRotation(var4_79, var5_79)
	existCall(arg3_79)
end

function var0_0.SetCameraLady(arg0_80)
	arg0_80.cameraAim2.LookAt = arg0_80.ladyInterestRoot
	arg0_80.cameraTalk.Follow = arg0_80.ladyInterestRoot
	arg0_80.cameraTalk.LookAt = arg0_80.ladyInterestRoot
	arg0_80.cameraGift.Follow = arg0_80.ladyInterest
	arg0_80.cameraGift.LookAt = arg0_80.ladyInterest
	arg0_80.cameraRole2.LookAt = arg0_80.ladyInterestRoot
	arg0_80.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_80.ladyInterest
	arg0_80.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_80.ladyInterest
end

function var0_0.initNodeCanvas(arg0_81)
	local var0_81 = pg.NodeCanvasMgr.GetInstance()

	var0_81:Active()
	var0_81:RegisterFunc("DistanceTrigger", function(arg0_82)
		arg0_81:emit(var0_0.DISTANCE_TRIGGER, arg0_82, arg0_81.ladyDict[arg0_82].dis)
	end)
	var0_81:RegisterFunc("ShortWaitAction", function(arg0_83)
		arg0_81:DoShortWait(arg0_83)
	end)
	var0_81:RegisterFunc("WatchShortWaitAction", function(arg0_84)
		arg0_81:DoShortWait(arg0_84)
	end)
	var0_81:RegisterFunc("WalkDistanceTrigger", function(arg0_85)
		arg0_81:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_85, arg0_81.ladyDict[arg0_85].dis)
	end)
	var0_81:RegisterFunc("ChangeWatch", function(arg0_86)
		arg0_81:emit(var0_0.CHANGE_WATCH, arg0_86)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_87, arg1_87, arg2_87)
	arg0_87[arg1_87] = arg2_87

	for iter0_87, iter1_87 in pairs(arg0_87.ladyDict) do
		iter1_87:SetBlackboardValue(arg1_87, arg2_87)
	end
end

function var0_0.SetBlackboardValue(arg0_88, arg1_88, arg2_88)
	arg0_88.blackboard = arg0_88.blackboard or {}
	arg0_88.blackboard[arg1_88] = arg2_88

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_88, arg2_88, arg0_88.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_89, arg1_89)
	arg0_89.blackboard = arg0_89.blackboard or {}

	return arg0_89.blackboard[arg1_89]
end

function var0_0.didEnter(arg0_90)
	local var0_90 = -21.6 / Screen.height

	arg0_90.joystickDelta = Vector2.zero
	arg0_90.joystickTimer = FrameTimer.New(function()
		local var0_91 = arg0_90.joystickDelta * var0_90
		local var1_91 = var0_91.x
		local var2_91 = var0_91.y

		local function var3_91(arg0_92, arg1_92, arg2_92)
			local var0_92 = arg0_92[arg1_92]

			var0_92.m_InputAxisValue = arg2_92
			arg0_92[arg1_92] = var0_92
		end

		if arg0_90.surroudCamera and not arg0_90.pinchMode then
			var3_91(arg0_90.surroudCamera, "m_XAxis", var1_91)
			var3_91(arg0_90.surroudCamera, "m_YAxis", var2_91)

			if arg0_90.surroudCamera == arg0_90.cameraRoleWatch then
				if var1_91 ~= 0 then
					local var4_91 = arg0_90.cameraRoleWatch.m_XAxis

					if not var4_91.m_Wrap then
						local var5_91 = var1_91 * (var4_91.m_InvertInput and -1 or 1)

						if var5_91 < 0 and var4_91.Value - 0.01 < var4_91.m_MinValue then
							arg0_90:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.RIGHT)
						elseif var5_91 > 0 and var4_91.Value + 0.01 > var4_91.m_MaxValue then
							arg0_90:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.LEFT)
						end
					end
				end

				if var2_91 ~= 0 then
					local var6_91 = arg0_90.cameraRoleWatch.m_YAxis

					if not var6_91.m_Wrap then
						if var2_91 < 0 and var6_91.Value - 0.01 < var6_91.m_MinValue then
							arg0_90:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.DOWN)
						elseif var2_91 > 0 and var6_91.Value + 0.01 > var6_91.m_MaxValue then
							arg0_90:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.UP)
						end
					end
				end
			end
		end

		arg0_90.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_90.joystickTimer:Start()

	local var1_90 = 1.75

	arg0_90.moveStickTimer = FrameTimer.New(function()
		if not arg0_90.moveStickDraging then
			return
		end

		local var0_93 = arg0_90.moveStickPosition
		local var1_93 = 200
		local var2_93 = (var0_93 - arg0_90.moveStickOrigin):ClampMagnitude(var1_93)
		local var3_93 = var2_93 / var1_93

		arg0_90.moveStickPosition = arg0_90.moveStickOrigin + var2_93

		local var4_93 = Vector3.New(var3_93.x, 0, var3_93.y)
		local var5_93 = arg0_90.mainCameraTF:TransformDirection(var4_93)

		var5_93.y = 0

		local var6_93 = var5_93:Normalize()

		var6_93:Mul(var1_90)

		if isActive(arg0_90.cameras[var0_0.CAMERA.POV]) then
			arg0_90.playerController:SimpleMove(var6_93)

			arg0_90.tweenFOV = true
		elseif isActive(arg0_90.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_90.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_93 * Time.deltaTime)
			arg0_90:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_93:Normalize())
			onNextTick(function()
				local var0_94 = arg0_90.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_94 = math.InverseLerp(arg0_90.restrictedHeightRange[1], arg0_90.restrictedHeightRange[2], var0_94.position.y)

				arg0_90:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_94)
			end)
		end
	end, 1, -1)

	arg0_90.moveStickTimer:Start()

	arg0_90.pinchMode = false
	arg0_90.pinchSize = 0
	arg0_90.pinchValue = 1
	arg0_90.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_95, arg1_95)
		if arg0_90.surroudCamera and isActive(arg0_90.surroudCamera) then
			arg0_90.pinchMode = true
			arg0_90.pinchSize = (arg0_95 - arg1_95):Magnitude()
			arg0_90.pinchNodeOrder = arg1_95.x < arg0_95.x and -1 or 1

			return
		end

		if isActive(arg0_90.cameras[var0_0.CAMERA.POV]) then
			if (arg0_95 - arg1_95):Magnitude() < Screen.height * 0.5 then
				arg0_90.pinchMode = true
				arg0_90.pinchSize = (arg0_95 - arg1_95):Magnitude()
				arg0_90.pinchNodeOrder = arg1_95.x < arg0_95.x and -1 or 1
			end

			return
		end
	end)

	local var2_90 = 0.01

	if IsUnityEditor then
		var2_90 = 0.1
	end

	local var3_90 = var2_90 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_96, arg1_96)
		if not arg0_90.pinchMode then
			return
		end

		local var0_96 = (arg0_96 - arg1_96):Magnitude()
		local var1_96 = arg0_90.pinchSize - var0_96
		local var2_96 = arg0_90.pinchNodeOrder * (arg1_96.x < arg0_96.x and -1 or 1)
		local var3_96 = var1_96 * var3_90 * var2_96

		if isActive(arg0_90.cameras[var0_0.CAMERA.POV]) then
			local var4_96 = 0.5
			local var5_96 = 1

			arg0_90.pinchValue = math.clamp(arg0_90.pinchValue + var3_96, var4_96, var5_96)
			arg0_90.pinchSize = var0_96

			arg0_90:SetPOVFOV(arg0_90.POVOriginalFOV * arg0_90.pinchValue)

			arg0_90.tweenFOV = nil

			return
		end

		if isActive(arg0_90.surroudCamera) and arg0_90.surroudCamera == arg0_90.cameras[var0_0.CAMERA.PHOTO] then
			local var6_96 = 0.5
			local var7_96 = 1

			arg0_90:SetPinchValue(math.clamp(arg0_90.pinchValue + var3_96, var6_96, var7_96))

			arg0_90.pinchSize = var0_96

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_90.pinchMode = false
		arg0_90.pinchSize = 0
	end)

	arg0_90.cameraBlendCallbacks = {}
	arg0_90.activeCMCamera = nil

	function arg0_90.camBrainEvenetHandler.OnBlendStarted(arg0_98)
		if arg0_90.activeCMCamera then
			arg0_90:OnCameraBlendFinished(arg0_90.activeCMCamera)
		end

		local var0_98 = arg0_90.camBrain.ActiveVirtualCamera

		arg0_90.activeCMCamera = var0_98
	end

	function arg0_90.camBrainEvenetHandler.OnBlendFinished(arg0_99)
		arg0_90.activeCMCamera = nil

		arg0_90:OnCameraBlendFinished(arg0_99)
	end

	for iter0_90, iter1_90 in pairs(arg0_90.ladyDict) do
		(function(arg0_100, arg1_100)
			if arg0_100.tfPendintItem then
				onNextTick(function()
					setParent(arg0_100.tfPendintItem, arg0_100.lady)
				end)
			end

			arg0_100.ladyOwner = GetComponent(arg0_100.lady, "GraphOwner")
			arg0_100.ladyBlackboard = GetComponent(arg0_100.lady, "Blackboard")

			arg0_100:SetBlackboardValue("groupId", arg1_100)
			onNextTick(function()
				arg0_100.ladyOwner.enabled = true
			end)
		end)(iter1_90, iter0_90)
	end

	arg0_90.expressionDict = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_90.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_90:ActiveCamera(arg0_90.cameras[var0_0.CAMERA.POV])
	arg0_90:RefreshSlots()

	arg0_90.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_90:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_90.updateHandler)
end

function var0_0.InitData(arg0_106)
	if not arg0_106.contextData.ladyZone then
		arg0_106.contextData.ladyZone = {}

		local var0_106
		local var1_106 = arg0_106.room:getConfig("default_zone")

		for iter0_106, iter1_106 in ipairs(arg0_106.contextData.groupIds) do
			for iter2_106, iter3_106 in ipairs(var1_106) do
				if iter3_106[1] == iter1_106 then
					arg0_106.contextData.ladyZone[iter1_106] = iter3_106[2]

					break
				end
			end

			assert(arg0_106.contextData.ladyZone[iter1_106])

			var0_106 = var0_106 or arg0_106.contextData.ladyZone[iter1_106]
		end

		arg0_106.contextData.inFurnitureName = var0_106 or arg0_106.room:getConfig("default_zone")[1][2]
	end

	arg0_106.zoneDatas = _.select(arg0_106.room:GetZones(), function(arg0_107)
		return not arg0_107:IsGlobal()
	end)
	arg0_106.readyIKLayers = {}
	arg0_106.activeIKLayers = {}
	arg0_106.holdingStatus = {}
	arg0_106.cacheIKInfos = {}
	arg0_106.activeSectors = {}
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
		local var1_108 = arg0_108.mainCameraTF.forward
		local var2_108 = arg0_108.mainCameraTF.position
		local var3_108 = UnityEngine.Rect.New(0, 0, Screen.width, Screen.height)

		local function var4_108(arg0_109, arg1_109, arg2_109)
			local var0_109 = arg0_109.position - var2_108
			local var1_109 = Clone(var0_109)

			var1_109.y = 0

			if arg1_109 < var1_109.magnitude then
				return false
			end

			local var2_109 = var0_109:Normalize()
			local var3_109 = math.acos(Vector3.Dot(var2_109, var1_108)) * math.rad2Deg

			if arg2_109 < math.abs(var3_109) then
				return false
			end

			local var4_109 = arg0_108.raycastCamera:WorldToScreenPoint(arg0_109.position)

			if var4_109.z < 0 then
				return false
			end

			if not var3_108:Contains(var4_109) then
				return false
			end

			return true
		end

		for iter0_108, iter1_108 in pairs(arg0_108.contactInRangeDic) do
			local var5_108 = pg.dorm3d_collection_template[iter0_108]
			local var6_108 = underscore.any(var5_108.vfx_prefab, function(arg0_110)
				return arg0_108.modelRoot:Find(arg0_110) and var4_108(arg0_108.modelRoot:Find(arg0_110), 2, 60)
			end)

			if tobool(iter1_108) ~= var6_108 then
				arg0_108.contactInRangeDic[iter0_108] = var6_108

				arg0_108:UpdateContactDisplay(iter0_108, var6_108 and not arg0_108.hideConcatFlag and arg0_108.contactStateDic[iter0_108] or arg0_108.hideContactStateDic[iter0_108])
			end
		end
	end

	if arg0_108.enableFloatUpdate then
		arg0_108.ladyDict[arg0_108.apartment:GetConfigID()]:UpdateFloatPosition()
	end

	arg0_108:CheckInSector()

	if arg0_108.apartment then
		(function(arg0_111)
			(function()
				if not arg0_111.ikHandler then
					return
				end

				if not arg0_111.ikHandler.targetScreenOffset then
					return
				end

				local var0_112 = arg0_111.ikHandler.rect
				local var1_112 = var0_112:PointToNormalized(Vector2.zero)
				local var2_112 = var0_112:PointToNormalized(arg0_111.ikHandler.targetScreenOffset) - var1_112

				_.each(arg0_111.ikHandler.subPlanes, function(arg0_113)
					local var0_113 = arg0_113.target
					local var1_113 = arg0_113.planeData

					var0_113.position = var0_0.GetPostionByRatio(var1_113, var2_112)
				end)

				if Time.time > arg0_111.ikNextCheckStamp then
					arg0_111.ikNextCheckStamp = arg0_111.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					arg0_111:emit(var0_0.ON_IK_STATUS_CHANGED, arg0_111.ikHandler.ikData:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end

				arg0_111:ResetIKTipTimer()
			end)()

			if arg0_111.enableIKTip then
				local var0_111 = Time.time > arg0_111.nextTipIKTime
				local var1_111 = arg0_111:GetIKTipsRootTF()

				if var0_111 then
					UIItemList.StaticAlign(var1_111, var1_111:GetChild(0), #arg0_111.readyIKLayers, function(arg0_114, arg1_114, arg2_114)
						if arg0_114 ~= UIItemList.EventUpdate then
							return
						end

						local var0_114 = arg0_111.readyIKLayers[arg1_114 + 1].ikData
						local var1_114 = var0_114:GetTriggerBoneName()
						local var2_114 = var1_114 and arg0_111.ladyColliders[var1_114] or nil

						if var2_114 and not (function()
							local var0_115 = arg0_111.raycastCamera:WorldToScreenPoint(var2_114.position)
							local var1_115 = CameraMgr.instance:Raycast(arg0_111.sceneRaycaster, var0_115)

							if var1_115.Length == 0 then
								return
							end

							return var2_114 == var1_115[0].gameObject.transform
						end)() then
							var2_114 = nil
						end

						if var2_114 then
							setLocalPosition(arg2_114, arg0_111:GetLocalPosition(arg0_111:GetScreenPosition(var2_114.position), var1_111) + var0_114:GetIKTipOffset())
						end

						setActive(arg2_114, var2_114)
					end)
				end

				setActive(var1_111, var0_111)
			end

			if arg0_111.ikRevertHandler then
				arg0_111.ikRevertHandler()
			end
		end)(arg0_108.ladyDict[arg0_108.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_116)
	if not isActive(arg0_116.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_116 = arg0_116.mainCameraTF.position

	var0_116.y = 0

	for iter0_116, iter1_116 in pairs(arg0_116.ladyDict) do
		local var1_116 = tobool(arg0_116.activeLady[iter0_116])

		if var1_116 ~= tobool(var0_0.IsPointInSector(arg0_116.activeSectors[iter1_116.ladyActiveZone], var0_116)) then
			arg0_116.activeLady[iter0_116] = not var1_116

			arg0_116:emit(var0_0.ON_ENTER_SECTOR, iter0_116)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_117)
	local function var0_117(arg0_118, arg1_118)
		arg0_118.dis = (arg0_118.lady.position - arg0_118.player.position).magnitude

		if (arg0_118:GetBlackboardValue("inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > arg0_118.dis ~= arg0_118:GetBlackboardValue("inDistance") then
			arg0_118:SetBlackboardValue("inDistance", arg0_118.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_118:emit(var0_0.ON_CHANGE_DISTANCE, arg1_118, arg0_118.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end

	for iter0_117, iter1_117 in pairs(arg0_117.ladyDict) do
		var0_117(iter1_117, iter0_117)
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

function var0_0.RefreshSlots(arg0_123, arg1_123)
	arg1_123 = arg1_123 or arg0_123.room

	local var0_123 = arg1_123:GetSlots()
	local var1_123 = arg1_123:GetFurnitures()

	arg0_123:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_123, function(arg0_124, arg1_124, arg2_124)
		local var0_124 = arg1_124:GetConfigID()
		local var1_124 = _.detect(var1_123, function(arg0_125)
			return arg0_125:GetSlotID() == var0_124
		end)
		local var2_124 = var1_124 and var1_124:GetModel() or false
		local var3_124 = arg0_123.slotDict[var0_124].model

		arg0_123.slotDict[var0_124].displayModelName = var2_124

		if var2_124 == false or var2_124 == "" then
			arg0_123.loader:ClearRequest("slot_" .. var0_124)

			if var3_124 then
				setActive(var3_124, var2_124 == "")
			end

			arg2_124()

			return
		end

		local var4_124 = arg0_123.slotDict[var0_124].trans

		if arg0_123.loader:GetLoadingRP("slot_" .. var0_124) then
			arg0_123:emit(var0_0.HIDE_BLOCK)
		end

		arg0_123.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_124, "", function(arg0_126)
			arg2_124()
			assert(arg0_126)
			setParent(arg0_126, var4_124)

			if var3_124 then
				local var0_126 = arg0_126:GetComponentsInChildren(typeof(Renderer), true)

				table.IpairsCArray(var0_126, function(arg0_127, arg1_127)
					LuaHelper.CopyLightMap(arg1_127.gameObject, arg0_126)
				end)
				setActive(var3_124, false)
			end
		end, "slot_" .. var0_124)
	end, function()
		arg0_123:emit(var0_0.HIDE_BLOCK)
	end)
end

function var0_0.ChangeCharacterPosition(arg0_129)
	arg0_129:ResetCharPoint(arg0_129.ladyActiveZone)
	arg0_129:SyncInterestTransform(arg0_129)
end

function var0_0.SyncCurrentInterestTransform(arg0_130)
	local var0_130 = arg0_130.ladyDict[arg0_130.apartment:GetConfigID()]

	arg0_130:SyncInterestTransform(var0_130)
end

function var0_0.SyncInterestTransform(arg0_131, arg1_131)
	arg0_131.ladyInterest.position = arg1_131.ladyInterestRoot.position
	arg0_131.ladyInterest.rotation = arg1_131.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_132, arg1_132)
	arg1_132 = arg1_132 or arg0_132.contextData.inFurnitureName

	local var0_132 = arg0_132.furnitures:Find(arg1_132):Find("PlayerPoint").position

	arg0_132.player.position = var0_132
	arg0_132.cameras[var0_0.CAMERA.POV].transform.position = arg0_132.playerEye.position

	local var1_132 = arg0_132.ladyInterest.position - arg0_132.playerEye.position
	local var2_132 = Quaternion.LookRotation(var1_132).eulerAngles
	local var3_132 = var2_132.y
	local var4_132 = var2_132.x
	local var5_132 = arg0_132.compPovAim.m_HorizontalAxis

	var5_132.Value = arg0_132:GetNearestAngle(var3_132, var5_132.m_MinValue, var5_132.m_MaxValue)
	arg0_132.compPovAim.m_HorizontalAxis = var5_132

	local var6_132 = arg0_132.compPovAim.m_VerticalAxis

	var6_132.Value = var4_132
	arg0_132.compPovAim.m_VerticalAxis = var6_132
end

function var0_0.GetAttachedFurnitureName(arg0_133)
	return arg0_133.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_134, arg1_134)
	return underscore.detect(arg0_134.attachedPoints, function(arg0_135)
		return arg0_135.name == arg1_134
	end)
end

function var0_0.GetSlotByID(arg0_136, arg1_136)
	return arg0_136.displaySlots[arg1_136] and arg0_136.displaySlots[arg1_136].trans
end

function var0_0.GetScreenPosition(arg0_137, arg1_137)
	local var0_137 = arg0_137.raycastCamera:WorldToScreenPoint(arg1_137)

	if var0_137.z < 0 then
		var0_137.x = var0_137.x + (var0_137.x < 0 and -1 or 1) * Screen.width
		var0_137.y = var0_137.y + (var0_137.y < 0 and -1 or 1) * Screen.height
		var0_137.z = -var0_137.z
	end

	return var0_137
end

function var0_0.GetLocalPosition(arg0_138, arg1_138, arg2_138)
	return LuaHelper.ScreenToLocal(arg2_138, arg1_138, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_139)
	return arg0_139.modelRoot
end

function var0_0.ShiftZone(arg0_140, arg1_140, arg2_140)
	local var0_140 = arg0_140:GetFurnitureByName(arg1_140)

	if not var0_140 then
		errorMsg(arg1_140 .. " Not Find")
		existCall(arg2_140)

		return
	end

	seriesAsync({
		function(arg0_141)
			arg0_140:emit(var0_0.SHOW_BLOCK)
			arg0_140:ShowBlackScreen(true, arg0_141)
		end,
		function(arg0_142)
			if arg0_140.shiftLady or arg0_140.room:isPersonalRoom() then
				local var0_142 = arg0_140.shiftLady or arg0_140.apartment:GetConfigID()

				arg0_140.shiftLady = nil
				arg0_140.contextData.ladyZone[var0_142] = var0_140.name

				local var1_142 = arg0_140.ladyDict[var0_142]

				var1_142.ladyBaseZone = arg0_140.contextData.ladyZone[var0_142]
				var1_142.ladyActiveZone = arg0_140.contextData.ladyZone[var0_142]

				if var1_142:GetBlackboardValue("inPending") then
					var1_142:SetOutPending()
					var1_142:SwitchAnim(var0_0.ANIM.IDLE)
					onNextTick(function()
						var1_142:ChangeCharacterPosition()
						arg0_142()
					end)
				else
					var1_142:ChangeCharacterPosition()
					arg0_142()
				end
			else
				arg0_142()
			end
		end,
		function(arg0_144)
			arg0_140.contextData.inFurnitureName = var0_140.name

			arg0_140:ChangePlayerPosition()
			arg0_140:TriggerLadyDistance()
			arg0_140:CheckInSector()
			arg0_144()
		end,
		function(arg0_145)
			arg0_140:UpdateZoneList()
			arg0_140:ShowBlackScreen(false, arg0_145)
		end,
		function(arg0_146)
			arg0_140:emit(var0_0.HIDE_BLOCK)
			arg0_146()
		end
	}, arg2_140)
end

function var0_0.WalkByRootMotionLoop(arg0_147, arg1_147, arg2_147)
	if arg1_147.pathPending then
		arg2_147:SetFloat("Speed", 0)

		return
	end

	arg2_147:SetFloat("Speed", 1)

	local var0_147 = arg1_147.path.corners

	if var0_147.Length > 1 then
		local var1_147 = var0_147[1] - arg1_147.transform.position

		var1_147.y = 0

		local var2_147 = Quaternion.LookRotation(var1_147)
		local var3_147 = arg1_147.transform.rotation
		local var4_147 = 1
		local var5_147 = Damp(1, var4_147, Time.deltaTime)

		arg1_147.transform.rotation = Quaternion.Lerp(var3_147, var2_147, var5_147)
	end
end

function var0_0.ActiveCamera(arg0_148, arg1_148)
	local var0_148 = isActive(arg1_148)

	table.Foreach(arg0_148.cameras, function(arg0_149, arg1_149)
		setActive(arg1_149, arg1_149 == arg1_148)
	end)

	if var0_148 then
		arg0_148:OnCameraBlendFinished(arg1_148)
	end
end

function var0_0.ShowBlackScreen(arg0_150, arg1_150, arg2_150)
	local var0_150 = arg0_150.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_150 and 0 or 0.3
	}

	setImageColor(arg0_150.blackLayer, Color.NewHex(var0_150.color))
	setActive(arg0_150.blackLayer, true)
	setCanvasGroupAlpha(arg0_150.blackLayer, arg1_150 and 0 or 1)
	arg0_150:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_150 then
			setActive(arg0_150.blackLayer, false)
		end

		existCall(arg2_150)
	end, GetComponent(arg0_150.blackLayer, typeof(CanvasGroup)), arg1_150 and 1 or 0, var0_150.time):setDelay(var0_150.delay)
end

function var0_0.RegisterOrbits(arg0_152, arg1_152)
	arg0_152 = arg0_152.scene
	arg0_152.orbits = {
		original = arg1_152.m_Orbits
	}
	arg0_152.orbits.current = _.range(3):map(function(arg0_153)
		local var0_153 = arg0_152.orbits.original[arg0_153 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_153.m_Height, var0_153.m_Radius)
	end)
	arg0_152.surroudCamera = arg1_152
end

function var0_0.SetCameraObrits(arg0_154)
	local var0_154 = arg0_154.surroudCamera

	if not var0_154 then
		return
	end

	local var1_154 = arg0_154.orbits.original[1]

	for iter0_154 = 0, #arg0_154.orbits.current - 1 do
		local var2_154 = arg0_154.orbits.current[iter0_154 + 1]
		local var3_154 = arg0_154.orbits.original[iter0_154]

		var2_154.m_Height = math.lerp(var1_154.m_Height, var3_154.m_Height, arg0_154.pinchValue)
		var2_154.m_Radius = var3_154.m_Radius * arg0_154.pinchValue
	end

	var0_154.m_Orbits = arg0_154.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_155)
	arg0_155 = arg0_155.scene

	local var0_155 = arg0_155.surroudCamera

	if not var0_155 then
		return
	end

	for iter0_155 = 0, #arg0_155.orbits.current - 1 do
		local var1_155 = arg0_155.orbits.current[iter0_155 + 1]
		local var2_155 = arg0_155.orbits.original[iter0_155]

		var1_155.m_Height = var2_155.m_Height
		var1_155.m_Radius = var2_155.m_Radius
	end

	var0_155.m_Orbits = arg0_155.orbits.current
	arg0_155.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_156, arg1_156, arg2_156)
	local var0_156 = {
		base = function(arg0_157)
			arg0_156:RegisterCameraBlendFinished(arg0_156.cameras[var0_0.CAMERA.POV], arg0_157)
			arg0_156:ActiveCamera(arg0_156.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_158)
			assert(arg0_156.apartment)
			arg0_156.ladyDict[arg0_156.apartment:GetConfigID()]:SetCameraLady()
			arg0_156:RegisterCameraBlendFinished(arg0_156.cameras[var0_0.CAMERA.ROLE], arg0_158)
			arg0_156:ActiveCamera(arg0_156.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_159)
			arg0_156:RegisterCameraBlendFinished(arg0_156.cameras[var0_0.CAMERA.POV], arg0_159)
			arg0_156:ActiveCamera(arg0_156.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_160)
			arg0_160()
		end,
		gift = function(arg0_161)
			assert(arg0_156.apartment)
			arg0_156.ladyDict[arg0_156.apartment:GetConfigID()]:SetCameraLady()
			arg0_156:RegisterCameraBlendFinished(arg0_156.cameras[var0_0.CAMERA.GIFT], arg0_161)
			arg0_156:ActiveCamera(arg0_156.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_162)
			assert(arg0_156.apartment)
			arg0_156.ladyDict[arg0_156.apartment:GetConfigID()]:SetCameraLady()

			arg0_156.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_156.cameraRole.transform.position

			arg0_156:RegisterCameraBlendFinished(arg0_156.cameras[var0_0.CAMERA.ROLE2], arg0_162)
			arg0_156:ActiveCamera(arg0_156.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_163)
			assert(arg0_156.apartment)
			arg0_156.ladyDict[arg0_156.apartment:GetConfigID()]:SetCameraLady()
			arg0_156:RegisterCameraBlendFinished(arg0_156.cameras[var0_0.CAMERA.TALK], arg0_163)
			arg0_156:ActiveCamera(arg0_156.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_156 = {}

	table.insert(var1_156, function(arg0_164)
		switch(arg1_156, var0_156, arg0_164, arg0_164)
	end)
	seriesAsync(var1_156, arg2_156)
end

function var0_0.SetIKStatus(arg0_165, arg1_165, arg2_165)
	warning("Set IKStatus " .. (arg1_165.id or "NIL"))

	arg0_165.enableIKTip = true

	setActive(arg0_165.ladyCollider, false)
	_.each(arg0_165.ladyTouchColliders, function(arg0_166)
		setActive(arg0_166, true)
	end)
	table.clear(arg0_165.readyIKLayers)

	arg0_165.blockIK = nil

	local var0_165 = _.map(arg1_165.ik_id, function(arg0_167)
		return arg0_167[1]
	end)

	table.Foreach(var0_165, function(arg0_168, arg1_168)
		local var0_168 = Dorm3dIK.New({
			configId = arg1_168
		})

		table.insert(arg0_165.readyIKLayers, {
			ikData = var0_168
		})

		arg0_165.cacheIKInfos[var0_168] = {}

		local var1_168 = var0_168:GetControllerPath()
		local var2_168 = arg0_165.ladyIKRoot:Find(var1_168):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
		local var3_168 = {}

		table.IpairsCArray(var2_168.IKComponents, function(arg0_169, arg1_169)
			var3_168[arg0_169 + 1] = arg1_169:GetIKSolver()
		end)

		arg0_165.cacheIKInfos[var0_168].solvers = var3_168

		local var4_168 = _.map(var3_168, function(arg0_170)
			return arg0_170.IKPositionWeight
		end)

		arg0_165.cacheIKInfos[var0_168].weights = var4_168
	end)

	arg0_165.camBrain.enabled = false

	if arg0_165.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_165.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_165.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var1_165 = arg0_165.cameraRoot:Find(arg1_165.ik_camera)

	assert(var1_165, "Missing IKCamera")

	arg0_165.cameras[var0_0.CAMERA.IK_WATCH] = var1_165

	arg0_165:ActiveCamera(arg0_165.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_165.camBrain.enabled = true

	local var2_165 = var1_165:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var2_165 then
		arg0_165:RegisterOrbits(var2_165)
	end

	arg0_165:SettingHeadAimIK(arg0_165, arg0_165.ikConfig.head_track)
	arg0_165:ResetIKTipTimer()
	arg0_165:SwitchAnim(arg1_165.character_action)
	onNextTick(function()
		local var0_171 = arg0_165.furnitures:Find(arg1_165.character_position)

		arg0_165.lady.position = var0_171:Find("StayPoint").position
		arg0_165.lady.rotation = var0_171:Find("StayPoint").rotation

		arg0_165:EnableCloth(false)
		arg0_165:EnableCloth(arg1_165.use_cloth, arg1_165.cloth_colliders)
		existCall(arg2_165)
	end)
end

function var0_0.ExitIKStatus(arg0_172, arg1_172, arg2_172)
	arg0_172.enableIKTip = false

	setActive(arg0_172.ladyCollider, true)
	_.each(arg0_172.ladyTouchColliders, function(arg0_173)
		setActive(arg0_173, false)
	end)
	arg0_172:ResetActiveIKs(arg0_172)
	table.clear(arg0_172.readyIKLayers)
	table.clear(arg0_172.cacheIKInfos)
	table.clear(arg0_172.activeIKLayers)
	table.clear(arg0_172.holdingStatus)
	eachChild(arg0_172.ladyIKRoot, function(arg0_174)
		setActive(arg0_174, false)
	end)
	setActive(arg0_172:GetIKTipsRootTF(), false)
	arg0_172:RevertCameraOrbit()
	setActive(arg0_172.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_172.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_172:EnableCloth(false)
	arg0_172:ResetHeadAimIK(arg0_172)
	arg0_172:SwitchAnim(arg1_172.character_action)
	onNextTick(function()
		if arg1_172.character_position then
			arg0_172.ladyActiveZone = arg1_172.character_position
		else
			arg0_172.ladyActiveZone = arg0_172.ladyBaseZone
		end

		arg0_172:ChangeCharacterPosition()
		arg0_172:TriggerLadyDistance()
		arg0_172:CheckInSector()
		existCall(arg2_172)
	end)
end

function var0_0.EnableIKLayer(arg0_176, arg1_176, arg2_176)
	warning("ENABLEIK", arg2_176:GetConfigID())

	local var0_176 = arg2_176:GetControllerPath()
	local var1_176 = arg1_176.ladyIKRoot:Find(var0_176):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
	local var2_176 = tf(var1_176):Find("Container")
	local var3_176 = {
		ikData = arg2_176,
		list = var1_176
	}

	if not arg1_176.holdingStatus[arg2_176] then
		var3_176.rect = arg2_176:GetRect()

		local var4_176 = arg2_176:GetActionTriggerParams()

		if var4_176[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET or var4_176[1] == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET then
			var3_176.triggerRect = arg2_176:GetTriggerRect()
		end

		local var5_176 = var2_176:Find("SubTargets")
		local var6_176 = {}

		assert(var5_176)

		local var7_176 = arg2_176:GetSubTargets()
		local var8_176 = arg2_176:GetPlaneRotations()
		local var9_176 = arg2_176:GetPlaneScales()

		table.Foreach(var7_176, function(arg0_177, arg1_177)
			local var0_177 = var5_176:Find(arg1_177[1])
			local var1_177 = var0_177:Find("Plane")

			if var8_176[arg0_177] then
				var1_177.localRotation = var8_176[arg0_177]
				var1_177.localScale = var9_176[arg0_177]
			end

			local var2_177 = var0_177:Find("Target")
			local var3_177 = var0_0.TransformMesh(var1_177:GetComponent(typeof(UnityEngine.MeshCollider)))
			local var4_177 = arg1_176.ladyBoneMaps[arg1_177[1]]

			var3_177.origin = var4_177.position

			local var5_177 = var3_176.rect
			local var6_177 = Vector2.New(var5_177.center.x / var5_177.width, var5_177.center.y / var5_177.height)

			var1_177.position = var0_0.GetPostionByRatio(var3_177, var6_177)
			var2_177.position = var4_177.position

			local var7_177 = {
				planeData = var3_177,
				target = var2_177,
				useOffset = tobool(arg1_177)
			}

			table.insert(var6_176, var7_177)
		end)

		var3_176.subPlanes = var6_176

		setActive(var1_176, true)
	else
		var3_176 = arg1_176.holdingStatus[arg2_176].ikHandler
	end

	if #arg2_176:GetHeadTrackPath() > 0 then
		arg0_176:SettingHeadAimIK(arg1_176, {
			2,
			arg2_176:GetHeadTrackPath()
		}, true)
	end

	local var10_176 = arg2_176:GetTriggerFaceAnim()

	if #var10_176 > 0 then
		arg0_176:PlayFaceAnim(var10_176)
	end

	setActive(arg0_176:GetIKHandTF(), true)
	eachChild(arg0_176:GetIKHandTF(), function(arg0_178)
		setActive(arg0_178, false)
	end)
	arg0_176:StopIKHandTimer()
	setActive(arg0_176:GetIKHandTF():Find("Begin"), true)

	arg1_176.ikHandTimer = Timer.New(function()
		setActive(arg0_176:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_176:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg1_176.ikHandTimer:Start()

	arg1_176.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_176:emit(var0_0.ON_IK_STATUS_CHANGED, arg2_176:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_176.apartment.configId, arg0_176.apartment.level, arg1_176.ikConfig.character_action, arg2_176:GetTriggerParams()[2], arg0_176.room:GetConfigID()))

	return var3_176
end

function var0_0.DeactiveIKLayer(arg0_180, arg1_180)
	if #arg1_180:GetHeadTrackPath() > 0 then
		arg0_180:SettingHeadAimIK(arg0_180, arg0_180.ikConfig.head_track)
	end

	arg0_180:StopIKHandTimer()
	setActive(arg0_180:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_180:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_180:GetIKHandTF():Find("End"), true)

	arg0_180.ikHandTimer = Timer.New(function()
		setActive(arg0_180:GetIKHandTF():Find("End"), false)
		setActive(arg0_180:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_180.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_182)
	if not arg0_182.ikHandTimer then
		return
	end

	arg0_182.ikHandTimer:Stop()

	arg0_182.ikHandTimer = nil
end

function var0_0.RevertIKLayer(arg0_183, arg1_183, arg2_183)
	seriesAsync({
		function(arg0_184)
			if arg1_183 >= 999 then
				return arg0_184()
			end

			arg0_183:PlayIKRevert(arg0_183, arg1_183, arg0_184)
		end,
		arg2_183
	})
end

function var0_0.RevertAllIKLayer(arg0_185, arg1_185, arg2_185)
	table.insertto(arg0_185.activeIKLayers, _.keys(arg0_185.holdingStatus))
	table.clear(arg0_185.holdingStatus)
	arg0_185.RevertIKLayer(arg0_185, arg1_185, arg2_185)
end

function var0_0.PlayIKRevert(arg0_186, arg1_186, arg2_186, arg3_186)
	local var0_186 = Time.time

	function arg0_186.ikRevertHandler()
		local var0_187 = Time.time - var0_186

		_.each(arg1_186.activeIKLayers, function(arg0_188)
			local var0_188 = 1

			if arg2_186 > 0 then
				var0_188 = var0_187 / arg2_186
			end

			local var1_188 = arg1_186.cacheIKInfos[arg0_188].solvers
			local var2_188 = arg1_186.cacheIKInfos[arg0_188].weights

			table.Foreach(var1_188, function(arg0_189, arg1_189)
				arg1_189.IKPositionWeight = math.lerp(var2_188[arg0_189], 0, var0_188)
			end)
		end)

		if var0_187 >= arg2_186 then
			arg0_186:ResetActiveIKs(arg1_186)

			arg0_186.ikRevertHandler = nil

			existCall(arg3_186)
		end
	end

	arg0_186.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_190, arg1_190)
	table.insertto(arg0_190.activeIKLayers, _.keys(arg0_190.holdingStatus))
	table.clear(arg0_190.holdingStatus)
	_.each(arg1_190.activeIKLayers, function(arg0_191)
		local var0_191 = arg0_191:GetControllerPath()
		local var1_191 = arg1_190.ladyIKRoot:Find(var0_191):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_191, false)

		local var2_191 = arg1_190.cacheIKInfos[arg0_191].solvers
		local var3_191 = arg1_190.cacheIKInfos[arg0_191].weights

		table.Foreach(var2_191, function(arg0_192, arg1_192)
			arg1_192.IKPositionWeight = var3_191[arg0_192]
		end)
	end)
	table.clear(arg1_190.activeIKLayers)
end

function var0_0.PlayIKAction(arg0_193, arg1_193)
	warning("Trigger IK", arg1_193:GetConfigID())
	arg0_193:emit(var0_0.ON_IK_STATUS_CHANGED, arg1_193:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	arg0_193:OnTriggerIK(arg1_193:GetConfigID())
end

function var0_0.ResetIKTipTimer(arg0_194)
	if not arg0_194.enableIKTip then
		return
	end

	arg0_194.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableHeadIK(arg0_195, arg1_195)
	arg0_195.ladyHeadIKComp.enableIk = arg1_195
end

function var0_0.SettingHeadAimIK(arg0_196, arg1_196, arg2_196, arg3_196)
	local var0_196

	if arg2_196[1] == 1 then
		var0_196 = arg0_196.mainCameraTF:Find("AimTarget")
	elseif arg2_196[1] == 2 then
		table.IpairsCArray(arg1_196.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_197, arg1_197)
			if arg1_197.name ~= arg2_196[2] then
				return
			end

			var0_196 = arg1_197
		end)
	end

	arg1_196.ladyHeadIKComp.AimTarget = var0_196

	if not arg3_196 and arg2_196[3] then
		arg1_196.ladyHeadIKComp.BodyWeight = arg2_196[3]
	end

	if not arg3_196 and arg2_196[4] then
		arg1_196.ladyHeadIKComp.HeadWeight = arg2_196[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_198, arg1_198)
	arg1_198.ladyHeadIKComp.AimTarget = arg0_198.mainCameraTF:Find("AimTarget")
	arg1_198.ladyHeadIKComp.HeadWeight = arg1_198.ladyHeadIKData.HeadWeight
	arg1_198.ladyHeadIKComp.BodyWeight = arg1_198.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_199, arg1_199)
	local function var0_199(arg0_200)
		arg0_200:HideCharacterBylayer()
	end

	for iter0_199, iter1_199 in pairs(arg0_199.ladyDict) do
		if iter0_199 ~= arg1_199 then
			var0_199(iter1_199)
		end
	end
end

function var0_0.RevertCharacter(arg0_201, arg1_201)
	local function var0_201(arg0_202)
		arg0_202:RevertCharacterBylayer()
	end

	for iter0_201, iter1_201 in pairs(arg0_201.ladyDict) do
		if iter0_201 ~= arg1_201 then
			var0_201(iter1_201)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_203)
	local var0_203 = "Bip001"
	local var1_203 = arg0_203.lady:Find("all")

	for iter0_203 = 0, var1_203.childCount - 1 do
		local var2_203 = var1_203:GetChild(iter0_203)

		if var2_203.name ~= var0_203 then
			pg.ViewUtils.SetLayer(var2_203, Layer.Environment3D)
		end
	end

	if arg0_203.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_203.tfPendintItem, Layer.Environment3D)
	end

	if arg0_203.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_203.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg0_203.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_204)
	local var0_204 = "Bip001"
	local var1_204 = arg0_204.lady:Find("all")

	for iter0_204 = 0, var1_204.childCount - 1 do
		local var2_204 = var1_204:GetChild(iter0_204)

		if var2_204.name ~= var0_204 then
			pg.ViewUtils.SetLayer(var2_204, Layer.Default)
		end
	end

	if arg0_204.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_204.tfPendintItem, Layer.Default)
	end

	if arg0_204.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_204.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg0_204.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_205)
	arg0_205:SetAllBlackbloardValue("inLockLayer", true)
	arg0_205:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_206)
	arg0_206:HideFurnitureSlots()

	local var0_206 = arg0_206.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_207)
			arg0_206:emit(var0_0.SHOW_BLOCK)
			arg0_206:ShowBlackScreen(true, arg0_207)
		end,
		function(arg0_208)
			arg0_206:RevertCharacter()
			arg0_206:SetAllBlackbloardValue("inLockLayer", false)
			arg0_206:RegisterCameraBlendFinished(var0_206, arg0_208)
			arg0_206:ActiveCamera(var0_206)
		end,
		function(arg0_209)
			arg0_206:ShowBlackScreen(false, arg0_209)
		end
	}, function()
		arg0_206:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_206:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_211, arg1_211)
	local var0_211 = arg0_211:GetFurnitureByName(arg1_211:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_211.cameraFurnitureWatch and arg0_211.cameraFurnitureWatch ~= var0_211 then
		arg0_211:UnRegisterCameraBlendFinished(arg0_211.cameraFurnitureWatch)
		setActive(arg0_211.cameraFurnitureWatch, false)
	end

	arg0_211.cameraFurnitureWatch = var0_211
	arg0_211.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_211.cameraFurnitureWatch

	arg0_211:RegisterCameraBlendFinished(arg0_211.cameraFurnitureWatch, function()
		arg0_211:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_211:emit(var0_0.SHOW_BLOCK)
	arg0_211:ActiveCamera(arg0_211.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_213)
	if arg0_213.displaySlots then
		arg0_213:UpdateDisplaySlots({})
		table.Foreach(arg0_213.displaySlots, function(arg0_214, arg1_214)
			local var0_214 = arg1_214.trans

			if IsNil(var0_214:Find("Selector")) then
				return
			end

			setActive(var0_214:Find("Selector"), false)
		end)

		arg0_213.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_215, arg1_215)
	arg0_215:HideFurnitureSlots()

	arg0_215.displaySlots = {}

	_.each(arg1_215, function(arg0_216)
		arg0_215.displaySlots[arg0_216] = arg0_215.slotDict[arg0_216]

		if not arg0_215.displaySlots[arg0_216] then
			errorMsg("Slot " .. arg0_216 .. " Not Binding Scene Object")

			return
		end

		local var0_216 = arg0_215.displaySlots[arg0_216].trans

		if var0_216:Find("Selector") then
			setActive(var0_216:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_217, arg1_217)
	table.Foreach(arg0_217.displaySlots, function(arg0_218, arg1_218)
		local var0_218 = arg1_218.trans

		if not IsNil(var0_218:Find("Selector")) then
			setActive(var0_218:Find("Selector/Normal"), arg1_217[arg0_218] == 0)
			setActive(var0_218:Find("Selector/Active"), arg1_217[arg0_218] == 1)
			setActive(var0_218:Find("Selector/Ban"), arg1_217[arg0_218] == 2)
		end

		local var1_218 = arg0_217.slotDict[arg0_218].model
		local var2_218 = arg0_217.slotDict[arg0_218].displayModelName

		if var2_218 and var2_218 ~= "" then
			var1_218 = var0_218:GetChild(var0_218.childCount - 1)
		end

		local function var3_218(arg0_219, arg1_219)
			local var0_219 = arg0_219:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_219, function(arg0_220, arg1_220)
				local var0_220 = arg1_220.material

				if var0_220 and var0_220:HasProperty("_FinalTint") then
					var0_220:SetColor("_FinalTint", arg1_219)
				end
			end)
		end

		if var1_218 then
			if arg1_217[arg0_218] == 1 then
				var3_218(var1_218, Color.NewHex("3F83AE73"))
			else
				var3_218(var1_218, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_221, arg1_221, arg2_221)
	arg0_221:SetAllBlackbloardValue("inLockLayer", true)
	arg0_221:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_222)
			arg0_221:TempHideUI(true, arg0_222)
		end,
		function(arg0_223)
			arg0_221:ShowBlackScreen(true, arg0_223)
		end,
		function(arg0_224)
			local var0_224 = arg0_221.ladyDict[arg0_221.apartment:GetConfigID()]

			arg0_221:SwitchAnim(arg2_221)
			var0_224.ladyAnimator:Update(0)
			var0_224:ResetCharPoint(arg1_221:GetWatchCameraName())
			arg0_221:SyncInterestTransform(var0_224)
			setActive(var0_224.ladySafeCollider, true)

			local var1_224 = arg0_221.cameras[var0_0.CAMERA.PHOTO]
			local var2_224 = var1_224.m_XAxis

			var2_224.Value = 180
			var1_224.m_XAxis = var2_224

			local var3_224 = var1_224.m_YAxis

			var3_224.Value = 0.7
			var1_224.m_YAxis = var3_224
			arg0_221.pinchValue = 1

			arg0_221:RegisterOrbits(arg0_221.cameras[var0_0.CAMERA.PHOTO])
			arg0_221:SetCameraObrits()
			arg0_221:RegisterCameraBlendFinished(var1_224, arg0_224)
			arg0_221:ActiveCamera(var1_224)
		end,
		function(arg0_225)
			arg0_221:ShowBlackScreen(false, arg0_225)
		end
	}, function()
		arg0_221:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_227)
	arg0_227:emit(var0_0.SHOW_BLOCK)
	arg0_227:EnableJoystick(false)
	seriesAsync({
		function(arg0_228)
			arg0_227:ShowBlackScreen(true, arg0_228)
		end,
		function(arg0_229)
			arg0_227:RevertCameraOrbit()

			local var0_229 = arg0_227.ladyDict[arg0_227.apartment:GetConfigID()]

			arg0_227:SwitchAnim(var0_0.ANIM.IDLE)
			setActive(var0_229.ladySafeCollider, false)
			onNextTick(function()
				arg0_227:ChangeCharacterPosition()
			end)

			if arg0_227.contextData.photoFreeMode then
				arg0_227:EnablePOVLayer(false)
				setActive(arg0_227.restrictedBox, false)

				arg0_227.contextData.photoFreeMode = nil
			end

			local var1_229 = arg0_227.cameras[var0_0.CAMERA.POV]

			arg0_227:RegisterCameraBlendFinished(var1_229, arg0_229)
			arg0_227:ActiveCamera(var1_229)
		end,
		function(arg0_231)
			arg0_227:ShowBlackScreen(false, arg0_231)
		end
	}, function()
		arg0_227:RefreshSlots()
		arg0_227:SetAllBlackbloardValue("inLockLayer", false)
		arg0_227:emit(var0_0.HIDE_BLOCK)
		arg0_227:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_227:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_233, arg1_233, arg2_233, arg3_233)
	arg0_233:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_234)
			arg0_233:ShowBlackScreen(true, arg0_234)
		end,
		function(arg0_235)
			arg0_233:SwitchAnim(arg2_233)
			onNextTick(function()
				arg0_233:ResetCharPoint(arg1_233:GetWatchCameraName())
				arg0_233:SyncInterestTransform(arg0_233)
				arg0_235()
			end)
		end,
		function(arg0_237)
			arg0_233:ShowBlackScreen(false, arg0_237)
		end
	}, function()
		arg0_233:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_233)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_239)
	if not arg0_239.contextData.photoFreeMode then
		arg0_239:EnableJoystick(false)
		arg0_239:EnablePOVLayer(true)
		setActive(arg0_239.restrictedBox, true)

		local var0_239 = arg0_239.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_239.transform.position = arg0_239.mainCameraTF.position

		local var1_239 = arg0_239.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_239 = arg0_239.mainCameraTF.rotation:ToEulerAngles()
		local var3_239 = var1_239.m_HorizontalAxis

		var3_239.Value = var2_239.y
		var1_239.m_HorizontalAxis = var3_239

		local var4_239 = var1_239.m_VerticalAxis

		var4_239.Value = arg0_239:GetNearestAngle(var2_239.x, var4_239.m_MinValue, var4_239.m_MaxValue)
		var1_239.m_VerticalAxis = var4_239

		local var5_239 = math.InverseLerp(arg0_239.restrictedHeightRange[1], arg0_239.restrictedHeightRange[2], var0_239.position.y)

		arg0_239:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_239)
		arg0_239:ActiveCamera(arg0_239.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_239:EnableJoystick(true)
		arg0_239:EnablePOVLayer(false)
		setActive(arg0_239.restrictedBox, false)
		arg0_239:ActiveCamera(arg0_239.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_239.contextData.photoFreeMode = not arg0_239.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_240, arg1_240)
	local var0_240 = math.lerp(arg0_240.restrictedHeightRange[1], arg0_240.restrictedHeightRange[2], arg1_240)
	local var1_240 = arg0_240.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_240:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_240 - var1_240.position.y, 0))
	onNextTick(function()
		local var0_241 = math.InverseLerp(arg0_240.restrictedHeightRange[1], arg0_240.restrictedHeightRange[2], var1_240.position.y)

		arg0_240:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_241)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_242)
	local var0_242 = arg0_242.cameras[var0_0.CAMERA.PHOTO]
	local var1_242 = var0_242.m_XAxis

	var1_242.Value = 180
	var0_242.m_XAxis = var1_242

	local var2_242 = var0_242.m_YAxis

	var2_242.Value = 0.7
	var0_242.m_YAxis = var2_242
end

function var0_0.ResetCharPoint(arg0_243, arg1_243)
	local var0_243 = arg0_243.furnitures:Find(arg1_243 .. "/StayPoint")

	arg0_243.lady.position = var0_243.position
	arg0_243.lady.rotation = var0_243.rotation
end

function var0_0.GetNearestAngle(arg0_244, arg1_244, arg2_244, arg3_244)
	if arg3_244 < arg2_244 then
		arg3_244 = arg3_244 + 360
	end

	if arg2_244 <= arg1_244 and arg1_244 <= arg3_244 then
		return arg1_244
	end

	local var0_244 = (arg2_244 + arg3_244) / 2

	arg1_244 = var0_244 - Mathf.DeltaAngle(arg1_244, var0_244)
	arg1_244 = math.clamp(arg1_244, arg2_244, arg3_244)

	return arg1_244
end

function var0_0.PlayTimeline(arg0_245, arg1_245, arg2_245)
	local var0_245 = {}

	if arg0_245.waitForTimeline then
		table.insert(var0_245, function(arg0_246)
			local var0_246 = arg0_245.waitForTimeline

			arg0_245.waitForTimeline = nil

			var0_246()
			arg0_246()
		end)
	end

	table.insert(var0_245, function(arg0_247)
		arg0_245:LoadTimelineScene(arg1_245.name, false, arg0_247)
	end)

	if arg1_245.scene and arg1_245.sceneRoot then
		table.insert(var0_245, function(arg0_248)
			arg0_245:ChangeArtScene(arg1_245.scene .. "|" .. arg1_245.sceneRoot, arg0_248)
		end)
	end

	table.insert(var0_245, function(arg0_249)
		local var0_249 = GameObject.Find("[sequence]").transform
		local var1_249 = var0_249:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if GetComponent(var1_249, "TimelineSpeed") then
			setDirectorSpeed(var1_249, 1)
		else
			GetOrAddComponent(var0_249, "TimelineSpeed")
		end

		local var2_249 = GameObject.Find("[actor]").transform
		local var3_249 = var2_249:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var3_249, function(arg0_250, arg1_250)
			GetOrAddComponent(arg1_250.transform, typeof(DftAniEvent))
		end)
		table.IpairsCArray(var2_249:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_251, arg1_251)
			arg1_251.enabled, arg1_251.enabled = arg1_251.enabled, false
		end)
		var1_249:Stop()

		var1_249.extrapolationMode = ReflectionHelp.RefGetField(typeof("UnityEngine.Playables.DirectorWrapMode"), "Hold", nil)

		if arg1_245.time then
			var1_249.time = math.clamp(arg1_245.time, 0, var1_249.duration)
		end

		local var4_249 = {}

		local function var5_249(arg0_252)
			switch(arg0_252.stringParameter, {
				TimelinePause = function()
					setDirectorSpeed(var1_249, 0)
				end,
				TimelineResume = function()
					arg0_245.timelineSpeed = 1

					setDirectorSpeed(var1_249, 1)
				end,
				TimelinePlayOnTime = function()
					if arg0_252.intParameter == 0 or arg0_252.intParameter == var4_249.selectIndex then
						var1_249.time = arg0_252.floatParameter

						var1_249:RebuildGraph()
					end
				end,
				TimelineSelectStart = function()
					var4_249.selectIndex = nil

					if arg1_245.options then
						local var0_256 = arg1_245.options[arg0_252.intParameter]

						arg0_245:DoTimelineOption(var0_256, function(arg0_257)
							var4_249.selectIndex = arg0_257
							var4_249.optionIndex = var0_256[arg0_257].flag
						end)
					end
				end,
				TimelineTouchStart = function()
					var4_249.selectIndex = nil

					if arg1_245.touchs then
						local var0_258 = arg1_245.touchs[arg0_252.intParameter]

						arg0_245:DoTimelineTouch(arg1_245.touchs[arg0_252.intParameter], function(arg0_259)
							var4_249.selectIndex = arg0_259
							var4_249.optionIndex = var0_258[arg0_259].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not var4_249.selectIndex then
						var1_249.time = arg0_252.floatParameter

						var1_249:RebuildGraph()
					end
				end,
				TimelineAccompanyJump = function()
					if arg0_245.canTriggerAccompanyPerformance then
						arg0_245.canTriggerAccompanyPerformance = false

						local var0_261 = arg1_245.accompanys[arg0_252.intParameter]
						local var1_261 = var0_261[math.random(#var0_261)]

						var1_249.time = var1_261

						var1_249:RebuildGraph()
					end
				end,
				TimelineEnd = function()
					var4_249.finish = true

					setDirectorSpeed(var1_249, 0)
				end
			}, function()
				warning("other event trigger:" .. arg0_252.stringParameter)
			end)

			if var4_249.finish then
				arg0_245.timelineMark = var4_249
				arg0_245.timelineFinishCall = nil

				arg0_249()
			end
		end

		GetOrAddComponent(var0_249, "DftCommonSignalReceiver"):SetCommonEvent(var5_249)

		function arg0_245.timelineFinishCall()
			var5_249({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_245:HideCharacter()
		setActive(arg0_245.mainCameraTF, false)
		eachChild(arg0_245.rtTimelineScreen, function(arg0_265)
			setActive(arg0_265, false)
		end)
		setActive(arg0_245.rtTimelineScreen, true)
		setActive(arg0_245.rtTimelineScreen:Find("btn_skip"), arg0_245.inReplayTalk)
		var1_249:Play()
		var1_249:Evaluate()
	end)
	table.insert(var0_245, function(arg0_266)
		arg0_245:ShowBlackScreen(true, function()
			arg0_245:UnloadTimelineScene(arg1_245.name, false, arg0_266)
		end)
	end)

	local var1_245 = arg0_245.artSceneInfo

	table.insert(var0_245, function(arg0_268)
		arg0_245:ChangeArtScene(var1_245, arg0_268)
	end)
	seriesAsync(var0_245, function()
		setActive(arg0_245.rtTimelineScreen, false)
		arg0_245:RevertCharacter()
		setActive(arg0_245.mainCameraTF, true)

		local var0_269 = arg0_245.timelineMark

		arg0_245.timelineMark = nil

		existCall(arg2_245, var0_269, function(arg0_270)
			arg0_245:ShowBlackScreen(false, arg0_270)
		end)
	end)
end

function var0_0.PlaySingleAction(arg0_271, arg1_271, arg2_271)
	local var0_271 = string.find(arg1_271, "^Face_")

	if tobool(var0_271) then
		arg0_271:PlayFaceAnim(arg1_271, arg2_271)

		return
	end

	arg0_271.animNameMap = arg0_271.animNameMap or {}
	arg0_271.animNameMap[arg0_271.ladyAnimator.StringToHash(arg1_271)] = arg1_271

	local var1_271 = {}

	if not arg0_271.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_271.ladyAnimBaseLayerIndex):IsName(arg1_271) then
		table.insert(var1_271, function(arg0_272)
			arg0_271.nowState = arg1_271
			arg0_271.stateCallback = arg0_272

			arg0_271.ladyAnimator:CrossFadeInFixedTime(arg1_271, 0.25, arg0_271.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_271, function(arg0_273)
			arg0_271.nowState = nil
			arg0_271.stateCallback = nil

			arg0_273()
		end)
	end

	seriesAsync(var1_271, arg2_271)
end

function var0_0.SwitchAnim(arg0_274, arg1_274, arg2_274)
	local var0_274 = string.find(arg1_274, "^Face_")

	if tobool(var0_274) then
		arg0_274:PlayFaceAnim(arg1_274, arg2_274)

		return
	end

	arg0_274.animNameMap = arg0_274.animNameMap or {}
	arg0_274.animNameMap[arg0_274.ladyAnimator.StringToHash(arg1_274)] = arg1_274

	local var1_274 = {}

	table.insert(var1_274, function(arg0_275)
		arg0_274.nowState = arg1_274
		arg0_274.stateCallback = arg0_275

		arg0_274.ladyAnimator:PlayInFixedTime(arg1_274, arg0_274.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_274, function(arg0_276)
		arg0_274.nowState = nil
		arg0_274.stateCallback = nil

		arg0_276()
	end)
	seriesAsync(var1_274, arg2_274)
end

function var0_0.PlayFaceAnim(arg0_277, arg1_277, arg2_277)
	arg0_277.ladyAnimator:CrossFadeInFixedTime(arg1_277, 0.2, arg0_277.ladyAnimFaceLayerIndex)
	existCall(arg2_277)
end

function var0_0.GetCurrentAnim(arg0_278)
	local var0_278 = arg0_278.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_278.ladyAnimBaseLayerIndex).shortNameHash

	return arg0_278.animNameMap[var0_278]
end

function var0_0.RegisterAnimCallback(arg0_279, arg1_279, arg2_279)
	arg0_279.animCallbacks[arg1_279] = arg2_279
end

function var0_0.SetCharacterAnimSpeed(arg0_280, arg1_280)
	arg0_280.ladyAnimator.speed = arg1_280
	arg0_280.ladyHeadIKComp.blinkSpeed = arg0_280.ladyHeadIKData.blinkSpeed * arg1_280

	if arg1_280 > 0 then
		arg0_280.ladyHeadIKComp.DampTime = arg0_280.ladyHeadIKData.DampTime / arg1_280
	else
		arg0_280.ladyHeadIKComp.DampTime = arg0_280.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_281, arg1_281)
	if arg1_281.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_281 = arg1_281.stringParameter
	local var1_281 = table.removebykey(arg0_281.animEventCallbacks, var0_281)

	existCall(var1_281)
end

function var0_0.RegisterAnimEventCallback(arg0_282, arg1_282, arg2_282)
	arg0_282.animEventCallbacks[arg1_282] = arg2_282
end

function var0_0.RegisterCameraBlendFinished(arg0_283, arg1_283, arg2_283)
	arg0_283.cameraBlendCallbacks[arg1_283] = arg2_283
end

function var0_0.UnRegisterCameraBlendFinished(arg0_284, arg1_284)
	arg0_284.cameraBlendCallbacks[arg1_284] = nil
end

function var0_0.OnCameraBlendFinished(arg0_285, arg1_285)
	if not arg1_285 then
		return
	end

	local var0_285 = table.removebykey(arg0_285.cameraBlendCallbacks, arg1_285)

	existCall(var0_285)
end

function var0_0.PlayHeartFX(arg0_286, arg1_286)
	local var0_286 = arg0_286.ladyDict[arg1_286]

	setActive(var0_286.effectHeart, false)
	setActive(var0_286.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_287, arg1_287)
	local var0_287 = arg1_287.name
	local var1_287 = arg0_287.expressionDict[var0_287]
	local var2_287 = 5

	if var1_287 then
		local var3_287 = var1_287.timer

		var3_287:Reset(nil, var2_287)
		var3_287:Start()

		if var1_287.instance then
			setActive(var1_287.instance, false)
			setActive(var1_287.instance, true)
		end

		return
	end

	local var4_287 = {
		name = var0_287,
		timer = Timer.New(function()
			arg0_287:RemoveExpression(var0_287)
		end, var2_287, 1, true)
	}

	arg0_287.expressionDict[var0_287] = var4_287

	arg0_287.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_287, var0_287, function(arg0_289)
		var4_287.instance = arg0_289

		onNextTick(function()
			setParent(arg0_289, arg0_287.ladyHeadCenter)
		end)
		setLocalPosition(arg0_289, Vector3(0, 0, -0.2))
		setActive(arg0_289, false)
		setActive(arg0_289, true)
	end, var4_287)
end

function var0_0.RemoveExpression(arg0_291, arg1_291)
	local var0_291 = arg0_291.expressionDict[arg1_291]

	if not var0_291 then
		return
	end

	arg0_291.loader:ClearRequest(var0_291)

	if var0_291.instance then
		arg0_291.loader:ReturnPrefab(var0_291.instance)
	end

	arg0_291.expressionDict[arg1_291] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_292, arg1_292)
	arg0_292.ladyWatchFloat = arg0_292.ladyWatchFloat or cloneTplTo(arg0_292.resTF:Find("vfx_talk_mark"), arg0_292.ladyHeadCenter)

	setActive(arg0_292.ladyWatchFloat, arg1_292)
end

function var0_0.RegisterGlobalVolume(arg0_293)
	local var0_293 = arg0_293.globalVolume
	local var1_293 = LuaHelper.GetOrAddVolumeComponent(var0_293, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_293 = LuaHelper.GetOrAddVolumeComponent(var0_293, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_293.originalCameraSettings = {
		depthOfField = {
			enabled = var1_293.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_293.gaussianStart.min,
				value = var1_293.gaussianStart.value
			},
			blurRadius = {
				min = var1_293.blurRadius.min,
				max = var1_293.blurRadius.max,
				value = var1_293.blurRadius.value
			}
		},
		postExposure = {
			value = var2_293.postExposure.value
		},
		contrast = {
			min = var2_293.contrast.min,
			max = var2_293.contrast.max,
			value = var2_293.contrast.value
		},
		saturate = {
			min = var2_293.saturation.min,
			max = var2_293.saturation.max,
			value = var2_293.saturation.value
		}
	}
	arg0_293.originalCameraSettings.depthOfField.enabled = true

	local var3_293 = var0_293:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_293.originalVolume = {
		profile = var3_293.sharedProfile,
		weight = var3_293.weight
	}
end

function var0_0.SettingCamera(arg0_294, arg1_294)
	arg0_294.activeCameraSettings = arg1_294

	local var0_294 = arg0_294.globalVolume
	local var1_294 = LuaHelper.GetOrAddVolumeComponent(var0_294, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_294 = LuaHelper.GetOrAddVolumeComponent(var0_294, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_294.enabled:Override(arg1_294.depthOfField.enabled)
	var1_294.gaussianStart:Override(arg1_294.depthOfField.focusDistance.value)
	var1_294.gaussianEnd:Override(arg1_294.depthOfField.focusDistance.value + arg1_294.depthOfField.focusDistance.length)
	var1_294.blurRadius:Override(arg1_294.depthOfField.blurRadius.value)
	var2_294.postExposure:Override(arg1_294.postExposure.value)
	var2_294.contrast:Override(arg1_294.contrast.value)
	var2_294.saturation:Override(arg1_294.saturate.value)
end

function var0_0.GetCameraSettings(arg0_295)
	return arg0_295.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_296)
	arg0_296:SettingCamera(arg0_296.originalCameraSettings)

	arg0_296.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_297, arg1_297, arg2_297)
	local var0_297 = arg0_297.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_297.activeProfileWeight = arg2_297

	if arg0_297.activeProfileName ~= arg1_297 then
		arg0_297.activeProfileName = arg1_297

		arg0_297.loader:LoadReference("dorm3d/scenesres/res/common", arg1_297, nil, function(arg0_298)
			var0_297.profile = arg0_298
			var0_297.weight = arg0_297.activeProfileWeight

			if arg0_297.activeCameraSettings then
				arg0_297:SettingCamera(arg0_297.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_297.weight = arg0_297.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_299)
	local var0_299 = arg0_299.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_299.profile = arg0_299.originalVolume.profile
	var0_299.weight = arg0_299.originalVolume.weight

	if arg0_299.activeCameraSettings then
		arg0_299:SettingCamera(arg0_299.activeCameraSettings)
	end

	arg0_299.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_300)
	local var0_300 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_300.originalCharacterColor = {
		color = var0_300.color,
		intensity = var0_300.intensity
	}
end

function var0_0.SetCharacterLight(arg0_301, arg1_301, arg2_301, arg3_301)
	local var0_301 = arg0_301.characterLight:GetComponent(typeof(Light))
	local var1_301 = Color.Lerp(arg0_301.originalCharacterColor.color, arg1_301, arg3_301)
	local var2_301 = math.lerp(arg0_301.originalCharacterColor.intensity, arg2_301, arg3_301)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_301, var2_301)
end

function var0_0.RevertCharacterLight(arg0_302)
	arg0_302:SetCharacterLight(arg0_302.originalCharacterColor.color, arg0_302.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_303, arg1_303, arg2_303)
	arg1_303 = arg1_303 or {}

	table.Foreach(arg0_303.clothComps, function(arg0_304, arg1_304)
		if arg1_304 == nil then
			return
		end

		setActive(arg1_304, arg1_303[arg0_304] == 1)
	end)
	table.Foreach(arg0_303.clothColliderDict, function(arg0_305, arg1_305)
		if arg1_305 == nil then
			return
		end

		setActive(arg1_305, false)
	end)

	if arg2_303 then
		table.Foreach(arg2_303, function(arg0_306, arg1_306)
			local var0_306 = arg0_303.clothColliderDict[arg1_306[1]]

			if var0_306 == nil then
				return
			end

			setActive(var0_306, arg1_306[2] == 1)

			if arg1_306[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_306, arg1_306[3], arg1_306[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_307, arg1_307)
	table.Foreach(arg1_307.ladyClothCompSettings, function(arg0_308, arg1_308)
		arg0_308.enabled = arg1_308.enabled
	end)
	table.Foreach(arg1_307.ladyClothColliderSettings, function(arg0_309, arg1_309)
		arg0_309.enabled = arg1_309.enabled

		var0_0.SetMagicaCollider(arg0_309, arg1_309.StartRadius, arg1_309.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_310)
	if arg0_310.exited or arg0_310.retainCount > 0 then
		-- block empty
	else
		arg0_310:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_311, arg1_311, arg2_311)
	assert(tobool(arg0_311.lastSceneRootDict[arg1_311]) == arg2_311)

	if arg2_311 then
		table.Foreach(arg0_311.lastSceneRootDict[arg1_311], function(arg0_312, arg1_312)
			if IsNil(arg0_312) then
				return
			end

			setActive(arg0_312, arg1_312)
		end)

		arg0_311.lastSceneRootDict[arg1_311] = nil
	else
		arg0_311.lastSceneRootDict[arg1_311] = {}

		local var0_311 = SceneManager.GetSceneByName(arg1_311)

		table.IpairsCArray(var0_311:GetRootGameObjects(), function(arg0_313, arg1_313)
			if tostring(arg1_313.hideFlags) ~= "None" then
				return
			end

			arg0_311.lastSceneRootDict[arg1_311][arg1_313] = isActive(arg1_313)

			setActive(arg1_313, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_314, arg1_314, arg2_314)
	arg1_314 = string.lower(arg1_314)

	if arg1_314 == arg0_314.artSceneInfo then
		if arg1_314 == arg0_314.sceneInfo then
			arg0_314:SwitchDayNight(arg0_314.contextData.timeIndex)
			onNextTick(function()
				arg0_314:RefreshSlots()
				existCall(arg2_314)
			end)
		else
			existCall(arg2_314)
		end

		return
	end

	local var0_314 = {}
	local var1_314 = false
	local var2_314

	table.insert(var0_314, function(arg0_316)
		arg0_314.artSceneInfo = arg1_314

		if var1_314 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_317)
				var2_314 = arg0_317

				arg0_316()
			end)
		else
			arg0_316()
		end
	end)

	if arg1_314 == arg0_314.sceneInfo then
		table.insert(var0_314, function(arg0_318)
			setActive(arg0_314.slotRoot, true)

			local var0_318, var1_318 = unpack(string.split(arg0_314.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_318))
			arg0_314:EnableSceneDisplay(var0_318, true)
			arg0_314:SwitchDayNight(arg0_314.contextData.timeIndex)
			onNextTick(function()
				arg0_314:RefreshSlots()
			end)
			arg0_318()
		end)
	else
		var1_314 = true

		local var3_314, var4_314 = unpack(string.split(arg1_314, "|"))

		table.insert(var0_314, function(arg0_320)
			setActive(arg0_314.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_314 .. "/" .. var3_314 .. "_scene"), var3_314, LoadSceneMode.Additive, function(arg0_321, arg1_321)
				SceneManager.SetActiveScene(arg0_321)

				local var0_321 = getSceneRootTFDic(arg0_321).MainCamera

				if var0_321 then
					setActive(var0_321, false)
				end

				arg0_320()
			end)
		end)
	end

	if arg0_314.artSceneInfo == arg0_314.sceneInfo then
		table.insert(var0_314, function(arg0_322)
			local var0_322, var1_322 = unpack(string.split(arg0_314.sceneInfo, "|"))

			arg0_314:EnableSceneDisplay(var0_322, false)
			arg0_322()
		end)
	else
		local var5_314, var6_314 = unpack(string.split(arg0_314.artSceneInfo, "|"))

		table.insert(var0_314, function(arg0_323)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_314 .. "/" .. var5_314 .. "_scene"), var5_314, arg0_323)
		end)
	end

	table.insert(var0_314, function(arg0_324)
		arg0_324()

		if var1_314 then
			var2_314()
		end
	end)
	seriesAsync(var0_314, arg2_314)
end

function var0_0.LoadTimelineScene(arg0_325, arg1_325, arg2_325, arg3_325)
	arg1_325 = string.lower(arg1_325)

	if arg0_325.cacheSceneDic[arg1_325] then
		if not arg2_325 then
			arg0_325.timelineScene = arg1_325

			arg0_325:EnableSceneDisplay(arg1_325, true)
		end

		return existCall(arg3_325)
	end

	local var0_325 = {}
	local var1_325

	table.insert(var0_325, function(arg0_326)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_327)
			if arg0_325.waitForTimeline then
				arg0_325.waitForTimeline = arg0_327
				var1_325 = nil
			else
				var1_325 = arg0_327
			end

			arg0_326()
		end)
	end)
	table.insert(var0_325, function(arg0_328)
		local var0_328 = arg0_325.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_328 .. "/timeline/" .. arg1_325 .. "/" .. arg1_325 .. "_scene"), arg1_325, LoadSceneMode.Additive, function(arg0_329, arg1_329)
			local var0_329 = GameObject.Find("[actor]").transform

			arg0_325:HXCharacter(tf(var0_329))

			local var1_329 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_329:Stop()
			TimelineSupport.InitTimeline(var1_329)
			TimelineSupport.InitSubtitle(var1_329, arg0_325.apartment:GetCallName())

			arg0_325.unloadDirector = var1_329

			arg0_328()
		end)
	end)
	table.insert(var0_325, function(arg0_330)
		arg0_325.sceneGroupDic[arg1_325] = arg0_325.apartment:GetConfigID()

		if arg2_325 then
			arg0_325.cacheSceneDic[arg1_325] = true

			arg0_325:EnableSceneDisplay(arg1_325, false)
		else
			arg0_325.timelineScene = arg1_325
		end

		arg0_330()
		existCall(var1_325)
	end)
	seriesAsync(var0_325, arg3_325)
end

function var0_0.UnloadTimelineScene(arg0_331, arg1_331, arg2_331, arg3_331)
	arg1_331 = string.lower(arg1_331)

	if arg0_331.timelineScene == arg1_331 then
		arg0_331.timelineScene = nil
	end

	if tobool(arg2_331) == tobool(arg0_331.cacheSceneDic[arg1_331]) then
		local var0_331 = getProxy(ApartmentProxy):getApartment(arg0_331.sceneGroupDic[arg1_331]):getConfig("asset_name")

		if arg0_331.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_331.unloadDirector)

			arg0_331.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_331 .. "/timeline/" .. arg1_331 .. "/" .. arg1_331 .. "_scene"), arg1_331, function()
			arg0_331.cacheSceneDic[arg1_331] = nil
			arg0_331.sceneGroupDic[arg1_331] = nil
			arg0_331.lastSceneRootDict[arg1_331] = nil

			existCall(arg3_331)
		end)
	else
		arg0_331:EnableSceneDisplay(arg1_331, false)
		existCall(arg3_331)
	end
end

function var0_0.ChangeSubScene(arg0_333, arg1_333, arg2_333)
	arg1_333 = string.lower(arg1_333)

	warning(arg0_333.subSceneInfo, "->", arg1_333, arg1_333 == arg0_333.subSceneInfo)

	if arg1_333 == arg0_333.subSceneInfo then
		arg0_333.ladyActiveZone = arg0_333.walkBornPoint or arg0_333.ladyBaseZone

		arg0_333:ChangeCharacterPosition()
		arg0_333:ChangePlayerPosition(arg0_333.ladyActiveZone)
		arg0_333:TriggerLadyDistance()
		arg0_333:CheckInSector()
		existCall(arg2_333)

		return
	end

	local var0_333 = {}
	local var1_333 = false
	local var2_333

	table.insert(var0_333, function(arg0_334)
		arg0_333.subSceneInfo = arg1_333

		if var1_333 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_335)
				var2_333 = arg0_335

				arg0_334()
			end)
		else
			arg0_334()
		end
	end)

	if arg1_333 == arg0_333.sceneInfo then
		table.insert(var0_333, function(arg0_336)
			local var0_336, var1_336 = unpack(string.split(arg0_333.sceneInfo, "|"))

			arg0_333:ResetSceneStructure(SceneManager.GetSceneByName(var0_336 .. "_base"))
			arg0_333:RefreshSlots()

			arg0_333.ladyActiveZone = arg0_333.walkBornPoint or arg0_333.ladyBaseZone

			arg0_333:ChangeCharacterPosition()
			arg0_333:ChangePlayerPosition(arg0_333.ladyActiveZone)
			arg0_333:TriggerLadyDistance()
			arg0_333:CheckInSector()
			arg0_336()
		end)
	else
		var1_333 = true

		local var3_333, var4_333 = unpack(string.split(arg1_333, "|"))
		local var5_333 = var3_333 .. "_base"

		table.insert(var0_333, function(arg0_337)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_333 .. "/" .. var5_333 .. "_scene"), var5_333, LoadSceneMode.Additive, arg0_337)
		end)
		table.insert(var0_333, function(arg0_338)
			arg0_333:ResetSceneStructure(SceneManager.GetSceneByName(var5_333))

			arg0_333.ladyActiveZone = arg0_333.walkBornPoint or "Default"

			arg0_333:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_333:ChangeCharacterPosition()
				arg0_333:ChangePlayerPosition(arg0_333.ladyActiveZone)
				arg0_333:TriggerLadyDistance()
				arg0_333:CheckInSector()
				arg0_338()
			end)
		end)
	end

	if arg0_333.subSceneInfo == arg0_333.sceneInfo then
		table.insert(var0_333, function(arg0_340)
			local var0_340 = Clone(arg0_333.room)

			var0_340.furnitures = {}

			arg0_333:RefreshSlots(var0_340)
			arg0_340()
		end)
	else
		local var6_333, var7_333 = unpack(string.split(arg0_333.subSceneInfo, "|"))
		local var8_333 = var6_333 .. "_base"

		table.insert(var0_333, function(arg0_341)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_333 .. "/" .. var8_333 .. "_scene"), var8_333, arg0_341)
		end)
	end

	table.insert(var0_333, function(arg0_342)
		arg0_342()

		if var1_333 then
			var2_333()
		end
	end)
	seriesAsync(var0_333, arg2_333)
end

function var0_0.TransformMesh(arg0_343)
	local var0_343 = arg0_343.sharedMesh
	local var1_343 = {}
	local var2_343 = arg0_343.transform:TransformPoint(var0_343.vertices[0])
	local var3_343 = arg0_343.transform:TransformPoint(var0_343.vertices[1])
	local var4_343 = arg0_343.transform:TransformPoint(var0_343.vertices[2])

	var1_343.horizontal = var3_343 - var2_343
	var1_343.verticle = var4_343 - var2_343
	var1_343.origin = var2_343

	return var1_343
end

function var0_0.GetRatio(arg0_344, arg1_344)
	local var0_344 = Vector2.zero

	var0_344.x = Vector3.Dot(arg0_344.horizontal, arg1_344) / arg0_344.horizontal.sqrMagnitude
	var0_344.y = Vector3.Dot(arg0_344.verticle, arg1_344) / arg0_344.verticle.sqrMagnitude

	return var0_344
end

function var0_0.GetPostionByRatio(arg0_345, arg1_345)
	return arg0_345.horizontal * arg1_345.x + arg0_345.verticle * arg1_345.y + arg0_345.origin
end

function var0_0.IsPointInSector(arg0_346, arg1_346)
	local var0_346 = arg1_346 - Vector3.New(unpack(arg0_346.Position))

	if var0_346.magnitude > arg0_346.Radius then
		return false
	end

	local var1_346 = Quaternion.Euler(unpack(arg0_346.Rotation))

	return Vector3.Angle(var1_346 * Vector3.forward, var0_346) <= arg0_346.Angle / 2
end

function var0_0.willExit(arg0_347)
	arg0_347.joystickTimer:Stop()
	arg0_347.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_347.updateHandler)
	arg0_347:StopIKHandTimer()

	if arg0_347.moveTimer then
		arg0_347.moveTimer:Stop()

		arg0_347.moveTimer = nil
	end

	if arg0_347.moveWaitTimer then
		arg0_347.moveWaitTimer:Stop()

		arg0_347.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_347.furnitures) then
		eachChild(arg0_347.furnitures, function(arg0_348)
			local var0_348 = GetComponent(arg0_348, typeof(EventTriggerListener))

			if not var0_348 then
				return
			end

			var0_348:ClearEvents()
		end)
	end

	for iter0_347, iter1_347 in pairs(arg0_347.ladyDict) do
		arg0_347:ResetActiveIKs(iter1_347)
		GetComponent(iter1_347.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_347.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_347.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_347.blockLayer, arg0_347._tf)
	table.Foreach(arg0_347.expressionDict, function(arg0_349)
		arg0_347:RemoveExpression(arg0_349)
	end)
	arg0_347.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_347 = {}

	if arg0_347.timelineScene and not arg0_347.cacheSceneDic[arg0_347.timelineScene] then
		local var1_347 = arg0_347.timelineScene

		arg0_347.timelineScene = nil

		local var2_347 = getProxy(ApartmentProxy):getApartment(arg0_347.sceneGroupDic[var1_347]):getConfig("asset_name")

		table.insert(var0_347, function(arg0_350)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_347 .. "/timeline/" .. var1_347 .. "/" .. var1_347 .. "_scene"), var1_347, arg0_350)
		end)
	end

	for iter2_347, iter3_347 in pairs(arg0_347.cacheSceneDic) do
		if iter3_347 then
			local var3_347 = getProxy(ApartmentProxy):getApartment(arg0_347.sceneGroupDic[iter2_347]):getConfig("asset_name")

			table.insert(var0_347, function(arg0_351)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_347 .. "/timeline/" .. iter2_347 .. "/" .. iter2_347 .. "_scene"), iter2_347, arg0_351)
			end)
		end
	end

	for iter4_347, iter5_347 in ipairs({
		arg0_347.sceneInfo,
		arg0_347.subSceneInfo ~= arg0_347.sceneInfo and arg0_347.subSceneInfo or nil
	}) do
		local var4_347, var5_347 = unpack(string.split(iter5_347, "|"))
		local var6_347 = var4_347 .. "_base"

		table.insert(var0_347, function(arg0_352)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_347 .. "/" .. var6_347 .. "_scene"), var6_347, arg0_352)
		end)
	end

	for iter6_347, iter7_347 in ipairs({
		arg0_347.sceneInfo,
		arg0_347.artSceneInfo ~= arg0_347.sceneInfo and arg0_347.artSceneInfo or nil
	}) do
		local var7_347, var8_347 = unpack(string.split(iter7_347, "|"))

		table.insert(var0_347, function(arg0_353)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_347 .. "/" .. var7_347 .. "_scene"), var7_347, arg0_353)
		end)
	end

	seriesAsync(var0_347, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_355 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_355 = SystemInfo.deviceModel or ""

			local function var2_355(arg0_356)
				local var0_356 = string.match(arg0_356, "iPad(%d+)")
				local var1_356 = tonumber(var0_356)

				if var1_356 and var1_356 >= 8 then
					return true
				end

				return false
			end

			local function var3_355(arg0_357)
				local var0_357 = string.match(arg0_357, "iPhone(%d+)")
				local var1_357 = tonumber(var0_357)

				if var1_357 and var1_357 >= 13 then
					return true
				end

				return false
			end

			if var2_355(var1_355) or var3_355(var1_355) then
				var0_355 = DevicePerformanceLevel.High
			end
		end

		local var4_355 = var0_355 == DevicePerformanceLevel.High and 3 or var0_355 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_355)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_355
	end
end

function var0_0.SettingQuality()
	local var0_358 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_358)
end

function var0_0.SetMagicaCollider(arg0_359, arg1_359, arg2_359)
	local var0_359 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_359, "StartRadius", arg0_359, arg1_359)
	ReflectionHelp.RefSetProperty(var0_359, "EndRadius", arg0_359, arg2_359)
end

return var0_0
