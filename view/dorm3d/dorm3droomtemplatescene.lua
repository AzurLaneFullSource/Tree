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
	onNextTick(function()
		arg0_79.lady:SetPositionAndRotation(var4_79, var5_79)
		existCall(arg3_79)
	end)
end

function var0_0.SetCameraLady(arg0_81)
	arg0_81.cameraAim2.LookAt = arg0_81.ladyInterestRoot
	arg0_81.cameraTalk.Follow = arg0_81.ladyInterestRoot
	arg0_81.cameraTalk.LookAt = arg0_81.ladyInterestRoot
	arg0_81.cameraGift.Follow = arg0_81.ladyInterest
	arg0_81.cameraGift.LookAt = arg0_81.ladyInterest
	arg0_81.cameraRole2.LookAt = arg0_81.ladyInterestRoot
	arg0_81.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_81.ladyInterest
	arg0_81.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_81.ladyInterest
end

function var0_0.initNodeCanvas(arg0_82)
	local var0_82 = pg.NodeCanvasMgr.GetInstance()

	var0_82:Active()
	var0_82:RegisterFunc("DistanceTrigger", function(arg0_83)
		arg0_82:emit(var0_0.DISTANCE_TRIGGER, arg0_83, arg0_82.ladyDict[arg0_83].dis)
	end)
	var0_82:RegisterFunc("ShortWaitAction", function(arg0_84)
		arg0_82:DoShortWait(arg0_84)
	end)
	var0_82:RegisterFunc("WatchShortWaitAction", function(arg0_85)
		arg0_82:DoShortWait(arg0_85)
	end)
	var0_82:RegisterFunc("WalkDistanceTrigger", function(arg0_86)
		arg0_82:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_86, arg0_82.ladyDict[arg0_86].dis)
	end)
	var0_82:RegisterFunc("ChangeWatch", function(arg0_87)
		arg0_82:emit(var0_0.CHANGE_WATCH, arg0_87)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_88, arg1_88, arg2_88)
	arg0_88[arg1_88] = arg2_88

	for iter0_88, iter1_88 in pairs(arg0_88.ladyDict) do
		iter1_88:SetBlackboardValue(arg1_88, arg2_88)
	end
end

function var0_0.SetBlackboardValue(arg0_89, arg1_89, arg2_89)
	arg0_89.blackboard = arg0_89.blackboard or {}
	arg0_89.blackboard[arg1_89] = arg2_89

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_89, arg2_89, arg0_89.ladyBlackboard)
end

function var0_0.GetBlackboardValue(arg0_90, arg1_90)
	arg0_90.blackboard = arg0_90.blackboard or {}

	return arg0_90.blackboard[arg1_90]
end

function var0_0.didEnter(arg0_91)
	local var0_91 = -21.6 / Screen.height

	arg0_91.joystickDelta = Vector2.zero
	arg0_91.joystickTimer = FrameTimer.New(function()
		local var0_92 = arg0_91.joystickDelta * var0_91
		local var1_92 = var0_92.x
		local var2_92 = var0_92.y

		local function var3_92(arg0_93, arg1_93, arg2_93)
			local var0_93 = arg0_93[arg1_93]

			var0_93.m_InputAxisValue = arg2_93
			arg0_93[arg1_93] = var0_93
		end

		if arg0_91.surroudCamera and not arg0_91.pinchMode then
			var3_92(arg0_91.surroudCamera, "m_XAxis", var1_92)
			var3_92(arg0_91.surroudCamera, "m_YAxis", var2_92)

			if arg0_91.surroudCamera == arg0_91.cameraRoleWatch then
				if var1_92 ~= 0 then
					local var4_92 = arg0_91.cameraRoleWatch.m_XAxis

					if not var4_92.m_Wrap then
						local var5_92 = var1_92 * (var4_92.m_InvertInput and -1 or 1)

						if var5_92 < 0 and var4_92.Value - 0.01 < var4_92.m_MinValue then
							arg0_91:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.RIGHT)
						elseif var5_92 > 0 and var4_92.Value + 0.01 > var4_92.m_MaxValue then
							arg0_91:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.LEFT)
						end
					end
				end

				if var2_92 ~= 0 then
					local var6_92 = arg0_91.cameraRoleWatch.m_YAxis

					if not var6_92.m_Wrap then
						if var2_92 < 0 and var6_92.Value - 0.01 < var6_92.m_MinValue then
							arg0_91:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.DOWN)
						elseif var2_92 > 0 and var6_92.Value + 0.01 > var6_92.m_MaxValue then
							arg0_91:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.UP)
						end
					end
				end
			end
		end

		arg0_91.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_91.joystickTimer:Start()

	local var1_91 = 1.75

	arg0_91.moveStickTimer = FrameTimer.New(function()
		if not arg0_91.moveStickDraging then
			return
		end

		local var0_94 = arg0_91.moveStickPosition
		local var1_94 = 200
		local var2_94 = (var0_94 - arg0_91.moveStickOrigin):ClampMagnitude(var1_94)
		local var3_94 = var2_94 / var1_94

		arg0_91.moveStickPosition = arg0_91.moveStickOrigin + var2_94

		local var4_94 = Vector3.New(var3_94.x, 0, var3_94.y)
		local var5_94 = arg0_91.mainCameraTF:TransformDirection(var4_94)

		var5_94.y = 0

		local var6_94 = var5_94:Normalize()

		var6_94:Mul(var1_91)

		if isActive(arg0_91.cameras[var0_0.CAMERA.POV]) then
			arg0_91.playerController:SimpleMove(var6_94)

			arg0_91.tweenFOV = true
		elseif isActive(arg0_91.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_91.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_94 * Time.deltaTime)
			arg0_91:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_94:Normalize())
			onNextTick(function()
				local var0_95 = arg0_91.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_95 = math.InverseLerp(arg0_91.restrictedHeightRange[1], arg0_91.restrictedHeightRange[2], var0_95.position.y)

				arg0_91:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_95)
			end)
		end
	end, 1, -1)

	arg0_91.moveStickTimer:Start()

	arg0_91.pinchMode = false
	arg0_91.pinchSize = 0
	arg0_91.pinchValue = 1
	arg0_91.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_96, arg1_96)
		if arg0_91.surroudCamera and isActive(arg0_91.surroudCamera) then
			arg0_91.pinchMode = true
			arg0_91.pinchSize = (arg0_96 - arg1_96):Magnitude()
			arg0_91.pinchNodeOrder = arg1_96.x < arg0_96.x and -1 or 1

			return
		end

		if isActive(arg0_91.cameras[var0_0.CAMERA.POV]) then
			if (arg0_96 - arg1_96):Magnitude() < Screen.height * 0.5 then
				arg0_91.pinchMode = true
				arg0_91.pinchSize = (arg0_96 - arg1_96):Magnitude()
				arg0_91.pinchNodeOrder = arg1_96.x < arg0_96.x and -1 or 1
			end

			return
		end
	end)

	local var2_91 = 0.01

	if IsUnityEditor then
		var2_91 = 0.1
	end

	local var3_91 = var2_91 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_97, arg1_97)
		if not arg0_91.pinchMode then
			return
		end

		local var0_97 = (arg0_97 - arg1_97):Magnitude()
		local var1_97 = arg0_91.pinchSize - var0_97
		local var2_97 = arg0_91.pinchNodeOrder * (arg1_97.x < arg0_97.x and -1 or 1)
		local var3_97 = var1_97 * var3_91 * var2_97

		if isActive(arg0_91.cameras[var0_0.CAMERA.POV]) then
			local var4_97 = 0.5
			local var5_97 = 1

			arg0_91.pinchValue = math.clamp(arg0_91.pinchValue + var3_97, var4_97, var5_97)
			arg0_91.pinchSize = var0_97

			arg0_91:SetPOVFOV(arg0_91.POVOriginalFOV * arg0_91.pinchValue)

			arg0_91.tweenFOV = nil

			return
		end

		if isActive(arg0_91.surroudCamera) and arg0_91.surroudCamera == arg0_91.cameras[var0_0.CAMERA.PHOTO] then
			local var6_97 = 0.5
			local var7_97 = 1

			arg0_91:SetPinchValue(math.clamp(arg0_91.pinchValue + var3_97, var6_97, var7_97))

			arg0_91.pinchSize = var0_97

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_91.pinchMode = false
		arg0_91.pinchSize = 0
	end)

	arg0_91.cameraBlendCallbacks = {}
	arg0_91.activeCMCamera = nil

	function arg0_91.camBrainEvenetHandler.OnBlendStarted(arg0_99)
		if arg0_91.activeCMCamera then
			arg0_91:OnCameraBlendFinished(arg0_91.activeCMCamera)
		end

		local var0_99 = arg0_91.camBrain.ActiveVirtualCamera

		arg0_91.activeCMCamera = var0_99
	end

	function arg0_91.camBrainEvenetHandler.OnBlendFinished(arg0_100)
		arg0_91.activeCMCamera = nil

		arg0_91:OnCameraBlendFinished(arg0_100)
	end

	for iter0_91, iter1_91 in pairs(arg0_91.ladyDict) do
		(function(arg0_101, arg1_101)
			if arg0_101.tfPendintItem then
				onNextTick(function()
					setParent(arg0_101.tfPendintItem, arg0_101.lady)
				end)
			end

			arg0_101.ladyOwner = GetComponent(arg0_101.lady, "GraphOwner")
			arg0_101.ladyBlackboard = GetComponent(arg0_101.lady, "Blackboard")

			arg0_101:SetBlackboardValue("groupId", arg1_101)
			onNextTick(function()
				arg0_101.ladyOwner.enabled = true
			end)
		end)(iter1_91, iter0_91)
	end

	arg0_91.expressionDict = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_91.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_91:ActiveCamera(arg0_91.cameras[var0_0.CAMERA.POV])
	arg0_91:RefreshSlots()

	arg0_91.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_91:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_91.updateHandler)
end

function var0_0.InitData(arg0_107)
	if not arg0_107.contextData.ladyZone then
		arg0_107.contextData.ladyZone = {}

		local var0_107
		local var1_107 = arg0_107.room:getConfig("default_zone")

		for iter0_107, iter1_107 in ipairs(arg0_107.contextData.groupIds) do
			for iter2_107, iter3_107 in ipairs(var1_107) do
				if iter3_107[1] == iter1_107 then
					arg0_107.contextData.ladyZone[iter1_107] = iter3_107[2]

					break
				end
			end

			assert(arg0_107.contextData.ladyZone[iter1_107])

			var0_107 = var0_107 or arg0_107.contextData.ladyZone[iter1_107]
		end

		arg0_107.contextData.inFurnitureName = var0_107 or arg0_107.room:getConfig("default_zone")[1][2]
	end

	arg0_107.zoneDatas = _.select(arg0_107.room:GetZones(), function(arg0_108)
		return not arg0_108:IsGlobal()
	end)
	arg0_107.readyIKLayers = {}
	arg0_107.activeIKLayers = {}
	arg0_107.holdingStatus = {}
	arg0_107.cacheIKInfos = {}
	arg0_107.activeSectors = {}
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
		local var1_109 = arg0_109.mainCameraTF.forward
		local var2_109 = arg0_109.mainCameraTF.position
		local var3_109 = UnityEngine.Rect.New(0, 0, Screen.width, Screen.height)

		local function var4_109(arg0_110, arg1_110, arg2_110)
			local var0_110 = arg0_110.position - var2_109
			local var1_110 = Clone(var0_110)

			var1_110.y = 0

			if arg1_110 < var1_110.magnitude then
				return false
			end

			local var2_110 = var0_110:Normalize()
			local var3_110 = math.acos(Vector3.Dot(var2_110, var1_109)) * math.rad2Deg

			if arg2_110 < math.abs(var3_110) then
				return false
			end

			local var4_110 = arg0_109.raycastCamera:WorldToScreenPoint(arg0_110.position)

			if var4_110.z < 0 then
				return false
			end

			if not var3_109:Contains(var4_110) then
				return false
			end

			return true
		end

		for iter0_109, iter1_109 in pairs(arg0_109.contactInRangeDic) do
			local var5_109 = pg.dorm3d_collection_template[iter0_109]
			local var6_109 = underscore.any(var5_109.vfx_prefab, function(arg0_111)
				return arg0_109.modelRoot:Find(arg0_111) and var4_109(arg0_109.modelRoot:Find(arg0_111), 2, 60)
			end)

			if tobool(iter1_109) ~= var6_109 then
				arg0_109.contactInRangeDic[iter0_109] = var6_109

				arg0_109:UpdateContactDisplay(iter0_109, var6_109 and not arg0_109.hideConcatFlag and arg0_109.contactStateDic[iter0_109] or arg0_109.hideContactStateDic[iter0_109])
			end
		end
	end

	if arg0_109.enableFloatUpdate then
		arg0_109.ladyDict[arg0_109.apartment:GetConfigID()]:UpdateFloatPosition()
	end

	arg0_109:CheckInSector()

	if arg0_109.apartment then
		(function(arg0_112)
			(function()
				if not arg0_112.ikHandler then
					return
				end

				if not arg0_112.ikHandler.targetScreenOffset then
					return
				end

				local var0_113 = arg0_112.ikHandler.rect
				local var1_113 = var0_113:PointToNormalized(Vector2.zero)
				local var2_113 = var0_113:PointToNormalized(arg0_112.ikHandler.targetScreenOffset) - var1_113

				_.each(arg0_112.ikHandler.subPlanes, function(arg0_114)
					local var0_114 = arg0_114.target
					local var1_114 = arg0_114.planeData

					var0_114.position = var0_0.GetPostionByRatio(var1_114, var2_113)
				end)

				if Time.time > arg0_112.ikNextCheckStamp then
					arg0_112.ikNextCheckStamp = arg0_112.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					arg0_112:emit(var0_0.ON_IK_STATUS_CHANGED, arg0_112.ikHandler.ikData:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end

				arg0_112:ResetIKTipTimer()
			end)()

			if arg0_112.enableIKTip then
				local var0_112 = Time.time > arg0_112.nextTipIKTime
				local var1_112 = arg0_112:GetIKTipsRootTF()

				if var0_112 then
					UIItemList.StaticAlign(var1_112, var1_112:GetChild(0), #arg0_112.readyIKLayers, function(arg0_115, arg1_115, arg2_115)
						if arg0_115 ~= UIItemList.EventUpdate then
							return
						end

						local var0_115 = arg0_112.readyIKLayers[arg1_115 + 1].ikData
						local var1_115 = var0_115:GetTriggerBoneName()
						local var2_115 = var1_115 and arg0_112.ladyColliders[var1_115] or nil

						if var2_115 and not (function()
							local var0_116 = arg0_112.raycastCamera:WorldToScreenPoint(var2_115.position)
							local var1_116 = CameraMgr.instance:Raycast(arg0_112.sceneRaycaster, var0_116)

							if var1_116.Length == 0 then
								return
							end

							return var2_115 == var1_116[0].gameObject.transform
						end)() then
							var2_115 = nil
						end

						if var2_115 then
							setLocalPosition(arg2_115, arg0_112:GetLocalPosition(arg0_112:GetScreenPosition(var2_115.position), var1_112) + var0_115:GetIKTipOffset())
						end

						setActive(arg2_115, var2_115)
					end)
				end

				setActive(var1_112, var0_112)
			end

			if arg0_112.ikRevertHandler then
				arg0_112.ikRevertHandler()
			end
		end)(arg0_109.ladyDict[arg0_109.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_117)
	if not isActive(arg0_117.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_117 = arg0_117.mainCameraTF.position

	var0_117.y = 0

	for iter0_117, iter1_117 in pairs(arg0_117.ladyDict) do
		local var1_117 = tobool(arg0_117.activeLady[iter0_117])

		if var1_117 ~= tobool(var0_0.IsPointInSector(arg0_117.activeSectors[iter1_117.ladyActiveZone], var0_117)) then
			arg0_117.activeLady[iter0_117] = not var1_117

			arg0_117:emit(var0_0.ON_ENTER_SECTOR, iter0_117)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_118)
	local function var0_118(arg0_119, arg1_119)
		arg0_119.dis = (arg0_119.lady.position - arg0_119.player.position).magnitude

		if (arg0_119:GetBlackboardValue("inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > arg0_119.dis ~= arg0_119:GetBlackboardValue("inDistance") then
			arg0_119:SetBlackboardValue("inDistance", arg0_119.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_119:emit(var0_0.ON_CHANGE_DISTANCE, arg1_119, arg0_119.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end

	for iter0_118, iter1_118 in pairs(arg0_118.ladyDict) do
		var0_118(iter1_118, iter0_118)
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

function var0_0.RefreshSlots(arg0_124, arg1_124)
	arg1_124 = arg1_124 or arg0_124.room

	local var0_124 = arg1_124:GetSlots()
	local var1_124 = arg1_124:GetFurnitures()

	arg0_124:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_124, function(arg0_125, arg1_125, arg2_125)
		local var0_125 = arg1_125:GetConfigID()
		local var1_125 = _.detect(var1_124, function(arg0_126)
			return arg0_126:GetSlotID() == var0_125
		end)
		local var2_125 = var1_125 and var1_125:GetModel() or false
		local var3_125 = arg0_124.slotDict[var0_125].model

		arg0_124.slotDict[var0_125].displayModelName = var2_125

		if var2_125 == false or var2_125 == "" then
			arg0_124.loader:ClearRequest("slot_" .. var0_125)

			if var3_125 then
				setActive(var3_125, var2_125 == "")
			end

			arg2_125()

			return
		end

		local var4_125 = arg0_124.slotDict[var0_125].trans

		if arg0_124.loader:GetLoadingRP("slot_" .. var0_125) then
			arg0_124:emit(var0_0.HIDE_BLOCK)
		end

		arg0_124.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_125, "", function(arg0_127)
			arg2_125()
			assert(arg0_127)
			setParent(arg0_127, var4_125)

			if var3_125 then
				local var0_127 = arg0_127:GetComponentsInChildren(typeof(Renderer), true)

				table.IpairsCArray(var0_127, function(arg0_128, arg1_128)
					LuaHelper.CopyLightMap(arg1_128.gameObject, arg0_127)
				end)
				setActive(var3_125, false)
			end
		end, "slot_" .. var0_125)
	end, function()
		arg0_124:emit(var0_0.HIDE_BLOCK)
	end)
end

function var0_0.ChangeCharacterPosition(arg0_130)
	arg0_130:ResetCharPoint(arg0_130.ladyActiveZone)
	arg0_130:SyncInterestTransform(arg0_130)
end

function var0_0.SyncCurrentInterestTransform(arg0_131)
	local var0_131 = arg0_131.ladyDict[arg0_131.apartment:GetConfigID()]

	arg0_131:SyncInterestTransform(var0_131)
end

function var0_0.SyncInterestTransform(arg0_132, arg1_132)
	arg0_132.ladyInterest.position = arg1_132.ladyInterestRoot.position
	arg0_132.ladyInterest.rotation = arg1_132.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_133, arg1_133)
	arg1_133 = arg1_133 or arg0_133.contextData.inFurnitureName

	local var0_133 = arg0_133.furnitures:Find(arg1_133):Find("PlayerPoint").position

	arg0_133.player.position = var0_133
	arg0_133.cameras[var0_0.CAMERA.POV].transform.position = arg0_133.playerEye.position

	local var1_133 = arg0_133.ladyInterest.position - arg0_133.playerEye.position
	local var2_133 = Quaternion.LookRotation(var1_133).eulerAngles
	local var3_133 = var2_133.y
	local var4_133 = var2_133.x
	local var5_133 = arg0_133.compPovAim.m_HorizontalAxis

	var5_133.Value = arg0_133:GetNearestAngle(var3_133, var5_133.m_MinValue, var5_133.m_MaxValue)
	arg0_133.compPovAim.m_HorizontalAxis = var5_133

	local var6_133 = arg0_133.compPovAim.m_VerticalAxis

	var6_133.Value = var4_133
	arg0_133.compPovAim.m_VerticalAxis = var6_133
end

function var0_0.GetAttachedFurnitureName(arg0_134)
	return arg0_134.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_135, arg1_135)
	return underscore.detect(arg0_135.attachedPoints, function(arg0_136)
		return arg0_136.name == arg1_135
	end)
end

function var0_0.GetSlotByID(arg0_137, arg1_137)
	return arg0_137.displaySlots[arg1_137] and arg0_137.displaySlots[arg1_137].trans
end

function var0_0.GetScreenPosition(arg0_138, arg1_138)
	local var0_138 = arg0_138.raycastCamera:WorldToScreenPoint(arg1_138)

	if var0_138.z < 0 then
		var0_138.x = var0_138.x + (var0_138.x < 0 and -1 or 1) * Screen.width
		var0_138.y = var0_138.y + (var0_138.y < 0 and -1 or 1) * Screen.height
		var0_138.z = -var0_138.z
	end

	return var0_138
end

function var0_0.GetLocalPosition(arg0_139, arg1_139, arg2_139)
	return LuaHelper.ScreenToLocal(arg2_139, arg1_139, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_140)
	return arg0_140.modelRoot
end

function var0_0.ShiftZone(arg0_141, arg1_141, arg2_141)
	local var0_141 = arg0_141:GetFurnitureByName(arg1_141)

	if not var0_141 then
		errorMsg(arg1_141 .. " Not Find")
		existCall(arg2_141)

		return
	end

	seriesAsync({
		function(arg0_142)
			arg0_141:emit(var0_0.SHOW_BLOCK)
			arg0_141:ShowBlackScreen(true, arg0_142)
		end,
		function(arg0_143)
			if arg0_141.shiftLady or arg0_141.room:isPersonalRoom() then
				local var0_143 = arg0_141.shiftLady or arg0_141.apartment:GetConfigID()

				arg0_141.shiftLady = nil
				arg0_141.contextData.ladyZone[var0_143] = var0_141.name

				local var1_143 = arg0_141.ladyDict[var0_143]

				var1_143.ladyBaseZone = arg0_141.contextData.ladyZone[var0_143]
				var1_143.ladyActiveZone = arg0_141.contextData.ladyZone[var0_143]

				if var1_143:GetBlackboardValue("inPending") then
					var1_143:SetOutPending()
					var1_143:SwitchAnim(var0_0.ANIM.IDLE)
					onNextTick(function()
						var1_143:ChangeCharacterPosition()
						arg0_143()
					end)
				else
					var1_143:ChangeCharacterPosition()
					arg0_143()
				end
			else
				arg0_143()
			end
		end,
		function(arg0_145)
			arg0_141.contextData.inFurnitureName = var0_141.name

			arg0_141:ChangePlayerPosition()
			arg0_141:TriggerLadyDistance()
			arg0_141:CheckInSector()
			arg0_145()
		end,
		function(arg0_146)
			arg0_141:UpdateZoneList()
			arg0_141:ShowBlackScreen(false, arg0_146)
		end,
		function(arg0_147)
			arg0_141:emit(var0_0.HIDE_BLOCK)
			arg0_147()
		end
	}, arg2_141)
end

function var0_0.WalkByRootMotionLoop(arg0_148, arg1_148, arg2_148)
	if arg1_148.pathPending then
		arg2_148:SetFloat("Speed", 0)

		return
	end

	arg2_148:SetFloat("Speed", 1)

	local var0_148 = arg1_148.path.corners

	if var0_148.Length > 1 then
		local var1_148 = var0_148[1] - arg1_148.transform.position

		var1_148.y = 0

		local var2_148 = Quaternion.LookRotation(var1_148)
		local var3_148 = arg1_148.transform.rotation
		local var4_148 = 1
		local var5_148 = Damp(1, var4_148, Time.deltaTime)

		arg1_148.transform.rotation = Quaternion.Lerp(var3_148, var2_148, var5_148)
	end
end

function var0_0.ActiveCamera(arg0_149, arg1_149)
	local var0_149 = isActive(arg1_149)

	table.Foreach(arg0_149.cameras, function(arg0_150, arg1_150)
		setActive(arg1_150, arg1_150 == arg1_149)
	end)

	if var0_149 then
		arg0_149:OnCameraBlendFinished(arg1_149)
	end
end

function var0_0.ShowBlackScreen(arg0_151, arg1_151, arg2_151)
	local var0_151 = arg0_151.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_151 and 0 or 0.3
	}

	setImageColor(arg0_151.blackLayer, Color.NewHex(var0_151.color))
	setActive(arg0_151.blackLayer, true)
	setCanvasGroupAlpha(arg0_151.blackLayer, arg1_151 and 0 or 1)
	arg0_151:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_151 then
			setActive(arg0_151.blackLayer, false)
		end

		existCall(arg2_151)
	end, GetComponent(arg0_151.blackLayer, typeof(CanvasGroup)), arg1_151 and 1 or 0, var0_151.time):setDelay(var0_151.delay)
end

function var0_0.RegisterOrbits(arg0_153, arg1_153)
	arg0_153 = arg0_153.scene
	arg0_153.orbits = {
		original = arg1_153.m_Orbits
	}
	arg0_153.orbits.current = _.range(3):map(function(arg0_154)
		local var0_154 = arg0_153.orbits.original[arg0_154 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_154.m_Height, var0_154.m_Radius)
	end)
	arg0_153.surroudCamera = arg1_153
end

function var0_0.SetCameraObrits(arg0_155)
	local var0_155 = arg0_155.surroudCamera

	if not var0_155 then
		return
	end

	local var1_155 = arg0_155.orbits.original[1]

	for iter0_155 = 0, #arg0_155.orbits.current - 1 do
		local var2_155 = arg0_155.orbits.current[iter0_155 + 1]
		local var3_155 = arg0_155.orbits.original[iter0_155]

		var2_155.m_Height = math.lerp(var1_155.m_Height, var3_155.m_Height, arg0_155.pinchValue)
		var2_155.m_Radius = var3_155.m_Radius * arg0_155.pinchValue
	end

	var0_155.m_Orbits = arg0_155.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_156)
	arg0_156 = arg0_156.scene

	local var0_156 = arg0_156.surroudCamera

	if not var0_156 then
		return
	end

	for iter0_156 = 0, #arg0_156.orbits.current - 1 do
		local var1_156 = arg0_156.orbits.current[iter0_156 + 1]
		local var2_156 = arg0_156.orbits.original[iter0_156]

		var1_156.m_Height = var2_156.m_Height
		var1_156.m_Radius = var2_156.m_Radius
	end

	var0_156.m_Orbits = arg0_156.orbits.current
	arg0_156.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_157, arg1_157, arg2_157)
	local var0_157 = {
		base = function(arg0_158)
			arg0_157:RegisterCameraBlendFinished(arg0_157.cameras[var0_0.CAMERA.POV], arg0_158)
			arg0_157:ActiveCamera(arg0_157.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_159)
			assert(arg0_157.apartment)
			arg0_157.ladyDict[arg0_157.apartment:GetConfigID()]:SetCameraLady()
			arg0_157:RegisterCameraBlendFinished(arg0_157.cameras[var0_0.CAMERA.ROLE], arg0_159)
			arg0_157:ActiveCamera(arg0_157.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_160)
			arg0_157:RegisterCameraBlendFinished(arg0_157.cameras[var0_0.CAMERA.POV], arg0_160)
			arg0_157:ActiveCamera(arg0_157.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_161)
			arg0_161()
		end,
		gift = function(arg0_162)
			assert(arg0_157.apartment)
			arg0_157.ladyDict[arg0_157.apartment:GetConfigID()]:SetCameraLady()
			arg0_157:RegisterCameraBlendFinished(arg0_157.cameras[var0_0.CAMERA.GIFT], arg0_162)
			arg0_157:ActiveCamera(arg0_157.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_163)
			assert(arg0_157.apartment)
			arg0_157.ladyDict[arg0_157.apartment:GetConfigID()]:SetCameraLady()

			arg0_157.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_157.cameraRole.transform.position

			arg0_157:RegisterCameraBlendFinished(arg0_157.cameras[var0_0.CAMERA.ROLE2], arg0_163)
			arg0_157:ActiveCamera(arg0_157.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_164)
			assert(arg0_157.apartment)
			arg0_157.ladyDict[arg0_157.apartment:GetConfigID()]:SetCameraLady()
			arg0_157:RegisterCameraBlendFinished(arg0_157.cameras[var0_0.CAMERA.TALK], arg0_164)
			arg0_157:ActiveCamera(arg0_157.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_157 = {}

	table.insert(var1_157, function(arg0_165)
		switch(arg1_157, var0_157, arg0_165, arg0_165)
	end)
	seriesAsync(var1_157, arg2_157)
end

function var0_0.SetIKStatus(arg0_166, arg1_166, arg2_166)
	warning("Set IKStatus " .. (arg1_166.id or "NIL"))

	arg0_166.enableIKTip = true

	setActive(arg0_166.ladyCollider, false)
	_.each(arg0_166.ladyTouchColliders, function(arg0_167)
		setActive(arg0_167, true)
	end)
	table.clear(arg0_166.readyIKLayers)

	arg0_166.blockIK = nil

	local var0_166 = _.map(arg1_166.ik_id, function(arg0_168)
		return arg0_168[1]
	end)

	table.Foreach(var0_166, function(arg0_169, arg1_169)
		local var0_169 = Dorm3dIK.New({
			configId = arg1_169
		})

		table.insert(arg0_166.readyIKLayers, {
			ikData = var0_169
		})

		arg0_166.cacheIKInfos[var0_169] = {}

		local var1_169 = var0_169:GetControllerPath()
		local var2_169 = arg0_166.ladyIKRoot:Find(var1_169):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
		local var3_169 = {}

		table.IpairsCArray(var2_169.IKComponents, function(arg0_170, arg1_170)
			var3_169[arg0_170 + 1] = arg1_170:GetIKSolver()
		end)

		arg0_166.cacheIKInfos[var0_169].solvers = var3_169

		local var4_169 = _.map(var3_169, function(arg0_171)
			return arg0_171.IKPositionWeight
		end)

		arg0_166.cacheIKInfos[var0_169].weights = var4_169
	end)

	arg0_166.camBrain.enabled = false

	if arg0_166.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_166.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_166.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var1_166 = arg0_166.cameraRoot:Find(arg1_166.ik_camera)

	assert(var1_166, "Missing IKCamera")

	arg0_166.cameras[var0_0.CAMERA.IK_WATCH] = var1_166

	arg0_166:ActiveCamera(arg0_166.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_166.camBrain.enabled = true

	local var2_166 = var1_166:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var2_166 then
		arg0_166:RegisterOrbits(var2_166)
	end

	arg0_166:SettingHeadAimIK(arg0_166, arg0_166.ikConfig.head_track)
	arg0_166:ResetIKTipTimer()
	arg0_166:SwitchAnim(arg1_166.character_action)
	onNextTick(function()
		local var0_172 = arg0_166.furnitures:Find(arg1_166.character_position)

		arg0_166.lady.position = var0_172:Find("StayPoint").position
		arg0_166.lady.rotation = var0_172:Find("StayPoint").rotation

		arg0_166:EnableCloth(false)
		arg0_166:EnableCloth(arg1_166.use_cloth, arg1_166.cloth_colliders)
		existCall(arg2_166)
	end)
end

function var0_0.ExitIKStatus(arg0_173, arg1_173, arg2_173)
	arg0_173.enableIKTip = false

	setActive(arg0_173.ladyCollider, true)
	_.each(arg0_173.ladyTouchColliders, function(arg0_174)
		setActive(arg0_174, false)
	end)
	arg0_173:ResetActiveIKs(arg0_173)
	table.clear(arg0_173.readyIKLayers)
	table.clear(arg0_173.cacheIKInfos)
	table.clear(arg0_173.activeIKLayers)
	table.clear(arg0_173.holdingStatus)
	eachChild(arg0_173.ladyIKRoot, function(arg0_175)
		setActive(arg0_175, false)
	end)
	setActive(arg0_173:GetIKTipsRootTF(), false)
	arg0_173:RevertCameraOrbit()
	setActive(arg0_173.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_173.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_173:EnableCloth(false)
	arg0_173:ResetHeadAimIK(arg0_173)
	arg0_173:SwitchAnim(arg1_173.character_action)
	onNextTick(function()
		if arg1_173.character_position then
			arg0_173.ladyActiveZone = arg1_173.character_position
		else
			arg0_173.ladyActiveZone = arg0_173.ladyBaseZone
		end

		arg0_173:ChangeCharacterPosition()
		arg0_173:TriggerLadyDistance()
		arg0_173:CheckInSector()
		existCall(arg2_173)
	end)
end

function var0_0.EnableIKLayer(arg0_177, arg1_177, arg2_177)
	warning("ENABLEIK", arg2_177:GetConfigID())

	local var0_177 = arg2_177:GetControllerPath()
	local var1_177 = arg1_177.ladyIKRoot:Find(var0_177):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
	local var2_177 = tf(var1_177):Find("Container")
	local var3_177 = {
		ikData = arg2_177,
		list = var1_177
	}

	if not arg1_177.holdingStatus[arg2_177] then
		var3_177.rect = arg2_177:GetRect()

		local var4_177 = arg2_177:GetActionTriggerParams()

		if var4_177[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET or var4_177[1] == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET then
			var3_177.triggerRect = arg2_177:GetTriggerRect()
		end

		local var5_177 = var2_177:Find("SubTargets")
		local var6_177 = {}

		assert(var5_177)

		local var7_177 = arg2_177:GetSubTargets()
		local var8_177 = arg2_177:GetPlaneRotations()
		local var9_177 = arg2_177:GetPlaneScales()

		table.Foreach(var7_177, function(arg0_178, arg1_178)
			local var0_178 = var5_177:Find(arg1_178[1])
			local var1_178 = var0_178:Find("Plane")

			if var8_177[arg0_178] then
				var1_178.localRotation = var8_177[arg0_178]
				var1_178.localScale = var9_177[arg0_178]
			end

			local var2_178 = var0_178:Find("Target")
			local var3_178 = var0_0.TransformMesh(var1_178:GetComponent(typeof(UnityEngine.MeshCollider)))
			local var4_178 = arg1_177.ladyBoneMaps[arg1_178[1]]

			var3_178.origin = var4_178.position

			local var5_178 = var3_177.rect
			local var6_178 = Vector2.New(var5_178.center.x / var5_178.width, var5_178.center.y / var5_178.height)

			var1_178.position = var0_0.GetPostionByRatio(var3_178, var6_178)
			var2_178.position = var4_178.position

			local var7_178 = {
				planeData = var3_178,
				target = var2_178,
				useOffset = tobool(arg1_178)
			}

			table.insert(var6_177, var7_178)
		end)

		var3_177.subPlanes = var6_177

		setActive(var1_177, true)
	else
		var3_177 = arg1_177.holdingStatus[arg2_177].ikHandler
	end

	if #arg2_177:GetHeadTrackPath() > 0 then
		arg0_177:SettingHeadAimIK(arg1_177, {
			2,
			arg2_177:GetHeadTrackPath()
		}, true)
	end

	local var10_177 = arg2_177:GetTriggerFaceAnim()

	if #var10_177 > 0 then
		arg0_177:PlayFaceAnim(var10_177)
	end

	setActive(arg0_177:GetIKHandTF(), true)
	eachChild(arg0_177:GetIKHandTF(), function(arg0_179)
		setActive(arg0_179, false)
	end)
	arg0_177:StopIKHandTimer()
	setActive(arg0_177:GetIKHandTF():Find("Begin"), true)

	arg1_177.ikHandTimer = Timer.New(function()
		setActive(arg0_177:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_177:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg1_177.ikHandTimer:Start()

	arg1_177.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_177:emit(var0_0.ON_IK_STATUS_CHANGED, arg2_177:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_177.apartment.configId, arg0_177.apartment.level, arg1_177.ikConfig.character_action, arg2_177:GetTriggerParams()[2], arg0_177.room:GetConfigID()))

	return var3_177
end

function var0_0.DeactiveIKLayer(arg0_181, arg1_181)
	if #arg1_181:GetHeadTrackPath() > 0 then
		arg0_181:SettingHeadAimIK(arg0_181, arg0_181.ikConfig.head_track)
	end

	arg0_181:StopIKHandTimer()
	setActive(arg0_181:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_181:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_181:GetIKHandTF():Find("End"), true)

	arg0_181.ikHandTimer = Timer.New(function()
		setActive(arg0_181:GetIKHandTF():Find("End"), false)
		setActive(arg0_181:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_181.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_183)
	if not arg0_183.ikHandTimer then
		return
	end

	arg0_183.ikHandTimer:Stop()

	arg0_183.ikHandTimer = nil
end

function var0_0.RevertIKLayer(arg0_184, arg1_184, arg2_184)
	seriesAsync({
		function(arg0_185)
			if arg1_184 >= 999 then
				return arg0_185()
			end

			arg0_184:PlayIKRevert(arg0_184, arg1_184, arg0_185)
		end,
		arg2_184
	})
end

function var0_0.RevertAllIKLayer(arg0_186, arg1_186, arg2_186)
	table.insertto(arg0_186.activeIKLayers, _.keys(arg0_186.holdingStatus))
	table.clear(arg0_186.holdingStatus)
	arg0_186.RevertIKLayer(arg0_186, arg1_186, arg2_186)
end

function var0_0.PlayIKRevert(arg0_187, arg1_187, arg2_187, arg3_187)
	local var0_187 = Time.time

	function arg0_187.ikRevertHandler()
		local var0_188 = Time.time - var0_187

		_.each(arg1_187.activeIKLayers, function(arg0_189)
			local var0_189 = 1

			if arg2_187 > 0 then
				var0_189 = var0_188 / arg2_187
			end

			local var1_189 = arg1_187.cacheIKInfos[arg0_189].solvers
			local var2_189 = arg1_187.cacheIKInfos[arg0_189].weights

			table.Foreach(var1_189, function(arg0_190, arg1_190)
				arg1_190.IKPositionWeight = math.lerp(var2_189[arg0_190], 0, var0_189)
			end)
		end)

		if var0_188 >= arg2_187 then
			arg0_187:ResetActiveIKs(arg1_187)

			arg0_187.ikRevertHandler = nil

			existCall(arg3_187)
		end
	end

	arg0_187.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_191, arg1_191)
	table.insertto(arg0_191.activeIKLayers, _.keys(arg0_191.holdingStatus))
	table.clear(arg0_191.holdingStatus)
	_.each(arg1_191.activeIKLayers, function(arg0_192)
		local var0_192 = arg0_192:GetControllerPath()
		local var1_192 = arg1_191.ladyIKRoot:Find(var0_192):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_192, false)

		local var2_192 = arg1_191.cacheIKInfos[arg0_192].solvers
		local var3_192 = arg1_191.cacheIKInfos[arg0_192].weights

		table.Foreach(var2_192, function(arg0_193, arg1_193)
			arg1_193.IKPositionWeight = var3_192[arg0_193]
		end)
	end)
	table.clear(arg1_191.activeIKLayers)
end

function var0_0.PlayIKAction(arg0_194, arg1_194)
	warning("Trigger IK", arg1_194:GetConfigID())
	arg0_194:emit(var0_0.ON_IK_STATUS_CHANGED, arg1_194:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	arg0_194:OnTriggerIK(arg1_194:GetConfigID())
end

function var0_0.ResetIKTipTimer(arg0_195)
	if not arg0_195.enableIKTip then
		return
	end

	arg0_195.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableHeadIK(arg0_196, arg1_196)
	arg0_196.ladyHeadIKComp.enableIk = arg1_196
end

function var0_0.SettingHeadAimIK(arg0_197, arg1_197, arg2_197, arg3_197)
	local var0_197

	if arg2_197[1] == 1 then
		var0_197 = arg0_197.mainCameraTF:Find("AimTarget")
	elseif arg2_197[1] == 2 then
		table.IpairsCArray(arg1_197.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_198, arg1_198)
			if arg1_198.name ~= arg2_197[2] then
				return
			end

			var0_197 = arg1_198
		end)
	end

	arg1_197.ladyHeadIKComp.AimTarget = var0_197

	if not arg3_197 and arg2_197[3] then
		arg1_197.ladyHeadIKComp.BodyWeight = arg2_197[3]
	end

	if not arg3_197 and arg2_197[4] then
		arg1_197.ladyHeadIKComp.HeadWeight = arg2_197[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_199, arg1_199)
	arg1_199.ladyHeadIKComp.AimTarget = arg0_199.mainCameraTF:Find("AimTarget")
	arg1_199.ladyHeadIKComp.HeadWeight = arg1_199.ladyHeadIKData.HeadWeight
	arg1_199.ladyHeadIKComp.BodyWeight = arg1_199.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_200, arg1_200)
	local function var0_200(arg0_201)
		arg0_201:HideCharacterBylayer()
	end

	for iter0_200, iter1_200 in pairs(arg0_200.ladyDict) do
		if iter0_200 ~= arg1_200 then
			var0_200(iter1_200)
		end
	end
end

function var0_0.RevertCharacter(arg0_202, arg1_202)
	local function var0_202(arg0_203)
		arg0_203:RevertCharacterBylayer()
	end

	for iter0_202, iter1_202 in pairs(arg0_202.ladyDict) do
		if iter0_202 ~= arg1_202 then
			var0_202(iter1_202)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_204)
	local var0_204 = "Bip001"
	local var1_204 = arg0_204.lady:Find("all")

	for iter0_204 = 0, var1_204.childCount - 1 do
		local var2_204 = var1_204:GetChild(iter0_204)

		if var2_204.name ~= var0_204 then
			pg.ViewUtils.SetLayer(var2_204, Layer.Environment3D)
		end
	end

	if arg0_204.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_204.tfPendintItem, Layer.Environment3D)
	end

	if arg0_204.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_204.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg0_204.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_205)
	local var0_205 = "Bip001"
	local var1_205 = arg0_205.lady:Find("all")

	for iter0_205 = 0, var1_205.childCount - 1 do
		local var2_205 = var1_205:GetChild(iter0_205)

		if var2_205.name ~= var0_205 then
			pg.ViewUtils.SetLayer(var2_205, Layer.Default)
		end
	end

	if arg0_205.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_205.tfPendintItem, Layer.Default)
	end

	if arg0_205.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_205.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg0_205.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_206)
	arg0_206:SetAllBlackbloardValue("inLockLayer", true)
	arg0_206:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_207)
	arg0_207:HideFurnitureSlots()

	local var0_207 = arg0_207.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_208)
			arg0_207:emit(var0_0.SHOW_BLOCK)
			arg0_207:ShowBlackScreen(true, arg0_208)
		end,
		function(arg0_209)
			arg0_207:RevertCharacter()
			arg0_207:SetAllBlackbloardValue("inLockLayer", false)
			arg0_207:RegisterCameraBlendFinished(var0_207, arg0_209)
			arg0_207:ActiveCamera(var0_207)
		end,
		function(arg0_210)
			arg0_207:ShowBlackScreen(false, arg0_210)
		end
	}, function()
		arg0_207:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_207:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_212, arg1_212)
	local var0_212 = arg0_212:GetFurnitureByName(arg1_212:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_212.cameraFurnitureWatch and arg0_212.cameraFurnitureWatch ~= var0_212 then
		arg0_212:UnRegisterCameraBlendFinished(arg0_212.cameraFurnitureWatch)
		setActive(arg0_212.cameraFurnitureWatch, false)
	end

	arg0_212.cameraFurnitureWatch = var0_212
	arg0_212.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_212.cameraFurnitureWatch

	arg0_212:RegisterCameraBlendFinished(arg0_212.cameraFurnitureWatch, function()
		arg0_212:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_212:emit(var0_0.SHOW_BLOCK)
	arg0_212:ActiveCamera(arg0_212.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_214)
	if arg0_214.displaySlots then
		arg0_214:UpdateDisplaySlots({})
		table.Foreach(arg0_214.displaySlots, function(arg0_215, arg1_215)
			local var0_215 = arg1_215.trans

			if IsNil(var0_215:Find("Selector")) then
				return
			end

			setActive(var0_215:Find("Selector"), false)
		end)

		arg0_214.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_216, arg1_216)
	arg0_216:HideFurnitureSlots()

	arg0_216.displaySlots = {}

	_.each(arg1_216, function(arg0_217)
		arg0_216.displaySlots[arg0_217] = arg0_216.slotDict[arg0_217]

		if not arg0_216.displaySlots[arg0_217] then
			errorMsg("Slot " .. arg0_217 .. " Not Binding Scene Object")

			return
		end

		local var0_217 = arg0_216.displaySlots[arg0_217].trans

		if var0_217:Find("Selector") then
			setActive(var0_217:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_218, arg1_218)
	table.Foreach(arg0_218.displaySlots, function(arg0_219, arg1_219)
		local var0_219 = arg1_219.trans

		if not IsNil(var0_219:Find("Selector")) then
			setActive(var0_219:Find("Selector/Normal"), arg1_218[arg0_219] == 0)
			setActive(var0_219:Find("Selector/Active"), arg1_218[arg0_219] == 1)
			setActive(var0_219:Find("Selector/Ban"), arg1_218[arg0_219] == 2)
		end

		local var1_219 = arg0_218.slotDict[arg0_219].model
		local var2_219 = arg0_218.slotDict[arg0_219].displayModelName

		if var2_219 and var2_219 ~= "" then
			var1_219 = var0_219:GetChild(var0_219.childCount - 1)
		end

		local function var3_219(arg0_220, arg1_220)
			local var0_220 = arg0_220:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_220, function(arg0_221, arg1_221)
				local var0_221 = arg1_221.material

				if var0_221 and var0_221:HasProperty("_FinalTint") then
					var0_221:SetColor("_FinalTint", arg1_220)
				end
			end)
		end

		if var1_219 then
			if arg1_218[arg0_219] == 1 then
				var3_219(var1_219, Color.NewHex("3F83AE73"))
			else
				var3_219(var1_219, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_222, arg1_222, arg2_222)
	arg0_222:SetAllBlackbloardValue("inLockLayer", true)
	arg0_222:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_223)
			arg0_222:TempHideUI(true, arg0_223)
		end,
		function(arg0_224)
			arg0_222:ShowBlackScreen(true, arg0_224)
		end,
		function(arg0_225)
			local var0_225 = arg0_222.ladyDict[arg0_222.apartment:GetConfigID()]

			arg0_222:SwitchAnim(arg2_222)
			var0_225.ladyAnimator:Update(0)
			var0_225:ResetCharPoint(arg1_222:GetWatchCameraName())
			arg0_222:SyncInterestTransform(var0_225)

			local var1_225 = arg0_222.cameras[var0_0.CAMERA.PHOTO]
			local var2_225 = var1_225.m_XAxis

			var2_225.Value = 180
			var1_225.m_XAxis = var2_225

			local var3_225 = var1_225.m_YAxis

			var3_225.Value = 0.7
			var1_225.m_YAxis = var3_225
			arg0_222.pinchValue = 1

			arg0_222:RegisterOrbits(arg0_222.cameras[var0_0.CAMERA.PHOTO])
			arg0_222:SetCameraObrits()
			arg0_222:RegisterCameraBlendFinished(var1_225, arg0_225)
			arg0_222:ActiveCamera(var1_225)
		end,
		function(arg0_226)
			arg0_222:ShowBlackScreen(false, arg0_226)
		end
	}, function()
		arg0_222:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_228)
	arg0_228:emit(var0_0.SHOW_BLOCK)
	arg0_228:EnableJoystick(false)
	seriesAsync({
		function(arg0_229)
			arg0_228:ShowBlackScreen(true, arg0_229)
		end,
		function(arg0_230)
			arg0_228:RevertCameraOrbit()
			arg0_228:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_228:ChangeCharacterPosition()
			end)

			if arg0_228.contextData.photoFreeMode then
				arg0_228:EnablePOVLayer(false)
				setActive(arg0_228.restrictedBox, false)

				arg0_228.contextData.photoFreeMode = nil
			end

			local var0_230 = arg0_228.cameras[var0_0.CAMERA.POV]

			arg0_228:RegisterCameraBlendFinished(var0_230, arg0_230)
			arg0_228:ActiveCamera(var0_230)
		end,
		function(arg0_232)
			arg0_228:ShowBlackScreen(false, arg0_232)
		end
	}, function()
		arg0_228:RefreshSlots()
		arg0_228:SetAllBlackbloardValue("inLockLayer", false)
		arg0_228:emit(var0_0.HIDE_BLOCK)
		arg0_228:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_228:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_234, arg1_234, arg2_234, arg3_234)
	arg0_234:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_235)
			arg0_234:ShowBlackScreen(true, arg0_235)
		end,
		function(arg0_236)
			arg0_234:SwitchAnim(arg2_234)
			onNextTick(function()
				arg0_234:ResetCharPoint(arg1_234:GetWatchCameraName())
				arg0_234:SyncInterestTransform(arg0_234)
				arg0_236()
			end)
		end,
		function(arg0_238)
			arg0_234:ShowBlackScreen(false, arg0_238)
		end
	}, function()
		arg0_234:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_234)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_240)
	if not arg0_240.contextData.photoFreeMode then
		arg0_240:EnableJoystick(false)
		arg0_240:EnablePOVLayer(true)
		setActive(arg0_240.restrictedBox, true)

		local var0_240 = arg0_240.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_240.transform.position = arg0_240.mainCameraTF.position

		local var1_240 = arg0_240.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_240 = arg0_240.mainCameraTF.rotation:ToEulerAngles()
		local var3_240 = var1_240.m_HorizontalAxis

		var3_240.Value = var2_240.y
		var1_240.m_HorizontalAxis = var3_240

		local var4_240 = var1_240.m_VerticalAxis

		var4_240.Value = arg0_240:GetNearestAngle(var2_240.x, var4_240.m_MinValue, var4_240.m_MaxValue)
		var1_240.m_VerticalAxis = var4_240

		local var5_240 = math.InverseLerp(arg0_240.restrictedHeightRange[1], arg0_240.restrictedHeightRange[2], var0_240.position.y)

		arg0_240:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_240)
		arg0_240:ActiveCamera(arg0_240.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_240:EnableJoystick(true)
		arg0_240:EnablePOVLayer(false)
		setActive(arg0_240.restrictedBox, false)
		arg0_240:ActiveCamera(arg0_240.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_240.contextData.photoFreeMode = not arg0_240.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_241, arg1_241)
	local var0_241 = math.lerp(arg0_241.restrictedHeightRange[1], arg0_241.restrictedHeightRange[2], arg1_241)
	local var1_241 = arg0_241.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_241:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_241 - var1_241.position.y, 0))
	onNextTick(function()
		local var0_242 = math.InverseLerp(arg0_241.restrictedHeightRange[1], arg0_241.restrictedHeightRange[2], var1_241.position.y)

		arg0_241:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_242)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_243)
	local var0_243 = arg0_243.cameras[var0_0.CAMERA.PHOTO]
	local var1_243 = var0_243.m_XAxis

	var1_243.Value = 180
	var0_243.m_XAxis = var1_243

	local var2_243 = var0_243.m_YAxis

	var2_243.Value = 0.7
	var0_243.m_YAxis = var2_243
end

function var0_0.ResetCharPoint(arg0_244, arg1_244)
	local var0_244 = arg0_244.furnitures:Find(arg1_244 .. "/StayPoint")

	arg0_244.lady.position = var0_244.position
	arg0_244.lady.rotation = var0_244.rotation
end

function var0_0.GetNearestAngle(arg0_245, arg1_245, arg2_245, arg3_245)
	if arg3_245 < arg2_245 then
		arg3_245 = arg3_245 + 360
	end

	if arg2_245 <= arg1_245 and arg1_245 <= arg3_245 then
		return arg1_245
	end

	local var0_245 = (arg2_245 + arg3_245) / 2

	arg1_245 = var0_245 - Mathf.DeltaAngle(arg1_245, var0_245)
	arg1_245 = math.clamp(arg1_245, arg2_245, arg3_245)

	return arg1_245
end

function var0_0.PlayTimeline(arg0_246, arg1_246, arg2_246)
	local var0_246 = {}

	if arg0_246.waitForTimeline then
		table.insert(var0_246, function(arg0_247)
			local var0_247 = arg0_246.waitForTimeline

			arg0_246.waitForTimeline = nil

			var0_247()
			arg0_247()
		end)
	end

	table.insert(var0_246, function(arg0_248)
		arg0_246:LoadTimelineScene(arg1_246.name, false, arg0_248)
	end)

	if arg1_246.scene and arg1_246.sceneRoot then
		table.insert(var0_246, function(arg0_249)
			arg0_246:ChangeArtScene(arg1_246.scene .. "|" .. arg1_246.sceneRoot, arg0_249)
		end)
	end

	table.insert(var0_246, function(arg0_250)
		local var0_250 = GameObject.Find("[sequence]").transform
		local var1_250 = var0_250:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if GetComponent(var1_250, "TimelineSpeed") then
			setDirectorSpeed(var1_250, 1)
		else
			GetOrAddComponent(var0_250, "TimelineSpeed")
		end

		local var2_250 = GameObject.Find("[actor]").transform
		local var3_250 = var2_250:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var3_250, function(arg0_251, arg1_251)
			GetOrAddComponent(arg1_251.transform, typeof(DftAniEvent))
		end)
		table.IpairsCArray(var2_250:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_252, arg1_252)
			arg1_252.enabled, arg1_252.enabled = arg1_252.enabled, false
		end)
		var1_250:Stop()

		var1_250.extrapolationMode = ReflectionHelp.RefGetField(typeof("UnityEngine.Playables.DirectorWrapMode"), "Hold", nil)

		if arg1_246.time then
			var1_250.time = math.clamp(arg1_246.time, 0, var1_250.duration)
		end

		local var4_250 = {}

		local function var5_250(arg0_253)
			switch(arg0_253.stringParameter, {
				TimelinePause = function()
					setDirectorSpeed(var1_250, 0)
				end,
				TimelineResume = function()
					arg0_246.timelineSpeed = 1

					setDirectorSpeed(var1_250, 1)
				end,
				TimelinePlayOnTime = function()
					if arg0_253.intParameter == 0 or arg0_253.intParameter == var4_250.selectIndex then
						var1_250.time = arg0_253.floatParameter

						var1_250:RebuildGraph()
					end
				end,
				TimelineSelectStart = function()
					var4_250.selectIndex = nil

					if arg1_246.options then
						local var0_257 = arg1_246.options[arg0_253.intParameter]

						arg0_246:DoTimelineOption(var0_257, function(arg0_258)
							var4_250.selectIndex = arg0_258
							var4_250.optionIndex = var0_257[arg0_258].flag
						end)
					end
				end,
				TimelineTouchStart = function()
					var4_250.selectIndex = nil

					if arg1_246.touchs then
						local var0_259 = arg1_246.touchs[arg0_253.intParameter]

						arg0_246:DoTimelineTouch(arg1_246.touchs[arg0_253.intParameter], function(arg0_260)
							var4_250.selectIndex = arg0_260
							var4_250.optionIndex = var0_259[arg0_260].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not var4_250.selectIndex then
						var1_250.time = arg0_253.floatParameter

						var1_250:RebuildGraph()
					end
				end,
				TimelineAccompanyJump = function()
					if arg0_246.canTriggerAccompanyPerformance then
						arg0_246.canTriggerAccompanyPerformance = false

						local var0_262 = arg1_246.accompanys[arg0_253.intParameter]
						local var1_262 = var0_262[math.random(#var0_262)]

						var1_250.time = var1_262

						var1_250:RebuildGraph()
					end
				end,
				TimelineEnd = function()
					var4_250.finish = true

					setDirectorSpeed(var1_250, 0)
				end
			}, function()
				warning("other event trigger:" .. arg0_253.stringParameter)
			end)

			if var4_250.finish then
				arg0_246.timelineMark = var4_250
				arg0_246.timelineFinishCall = nil

				arg0_250()
			end
		end

		GetOrAddComponent(var0_250, "DftCommonSignalReceiver"):SetCommonEvent(var5_250)

		function arg0_246.timelineFinishCall()
			var5_250({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_246:HideCharacter()
		setActive(arg0_246.mainCameraTF, false)
		eachChild(arg0_246.rtTimelineScreen, function(arg0_266)
			setActive(arg0_266, false)
		end)
		setActive(arg0_246.rtTimelineScreen, true)
		setActive(arg0_246.rtTimelineScreen:Find("btn_skip"), arg0_246.inReplayTalk)
		var1_250:Play()
		var1_250:Evaluate()
	end)
	table.insert(var0_246, function(arg0_267)
		arg0_246:ShowBlackScreen(true, function()
			arg0_246:UnloadTimelineScene(arg1_246.name, false, arg0_267)
		end)
	end)

	local var1_246 = arg0_246.artSceneInfo

	table.insert(var0_246, function(arg0_269)
		arg0_246:ChangeArtScene(var1_246, arg0_269)
	end)
	seriesAsync(var0_246, function()
		setActive(arg0_246.rtTimelineScreen, false)
		arg0_246:RevertCharacter()
		setActive(arg0_246.mainCameraTF, true)

		local var0_270 = arg0_246.timelineMark

		arg0_246.timelineMark = nil

		existCall(arg2_246, var0_270, function(arg0_271)
			arg0_246:ShowBlackScreen(false, arg0_271)
		end)
	end)
end

function var0_0.PlaySingleAction(arg0_272, arg1_272, arg2_272)
	local var0_272 = string.find(arg1_272, "^Face_")

	if tobool(var0_272) then
		arg0_272:PlayFaceAnim(arg1_272, arg2_272)

		return
	end

	arg0_272.animNameMap = arg0_272.animNameMap or {}
	arg0_272.animNameMap[arg0_272.ladyAnimator.StringToHash(arg1_272)] = arg1_272

	local var1_272 = {}

	if not arg0_272.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_272.ladyAnimBaseLayerIndex):IsName(arg1_272) then
		table.insert(var1_272, function(arg0_273)
			arg0_272.nowState = arg1_272
			arg0_272.stateCallback = arg0_273

			arg0_272.ladyAnimator:CrossFadeInFixedTime(arg1_272, 0.25, arg0_272.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_272, function(arg0_274)
			arg0_272.nowState = nil
			arg0_272.stateCallback = nil

			arg0_274()
		end)
	end

	seriesAsync(var1_272, arg2_272)
end

function var0_0.SwitchAnim(arg0_275, arg1_275, arg2_275)
	local var0_275 = string.find(arg1_275, "^Face_")

	if tobool(var0_275) then
		arg0_275:PlayFaceAnim(arg1_275, arg2_275)

		return
	end

	arg0_275.animNameMap = arg0_275.animNameMap or {}
	arg0_275.animNameMap[arg0_275.ladyAnimator.StringToHash(arg1_275)] = arg1_275

	local var1_275 = {}

	table.insert(var1_275, function(arg0_276)
		arg0_275.nowState = arg1_275
		arg0_275.stateCallback = arg0_276

		arg0_275.ladyAnimator:PlayInFixedTime(arg1_275, arg0_275.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_275, function(arg0_277)
		arg0_275.nowState = nil
		arg0_275.stateCallback = nil

		arg0_277()
	end)
	seriesAsync(var1_275, arg2_275)
end

function var0_0.PlayFaceAnim(arg0_278, arg1_278, arg2_278)
	arg0_278.ladyAnimator:CrossFadeInFixedTime(arg1_278, 0.2, arg0_278.ladyAnimFaceLayerIndex)
	existCall(arg2_278)
end

function var0_0.GetCurrentAnim(arg0_279)
	local var0_279 = arg0_279.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_279.ladyAnimBaseLayerIndex).shortNameHash

	return arg0_279.animNameMap[var0_279]
end

function var0_0.RegisterAnimCallback(arg0_280, arg1_280, arg2_280)
	arg0_280.animCallbacks[arg1_280] = arg2_280
end

function var0_0.SetCharacterAnimSpeed(arg0_281, arg1_281)
	arg0_281.ladyAnimator.speed = arg1_281
	arg0_281.ladyHeadIKComp.blinkSpeed = arg0_281.ladyHeadIKData.blinkSpeed * arg1_281

	if arg1_281 > 0 then
		arg0_281.ladyHeadIKComp.DampTime = arg0_281.ladyHeadIKData.DampTime / arg1_281
	else
		arg0_281.ladyHeadIKComp.DampTime = arg0_281.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_282, arg1_282)
	if arg1_282.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_282 = arg1_282.stringParameter
	local var1_282 = table.removebykey(arg0_282.animEventCallbacks, var0_282)

	existCall(var1_282)
end

function var0_0.RegisterAnimEventCallback(arg0_283, arg1_283, arg2_283)
	arg0_283.animEventCallbacks[arg1_283] = arg2_283
end

function var0_0.RegisterCameraBlendFinished(arg0_284, arg1_284, arg2_284)
	arg0_284.cameraBlendCallbacks[arg1_284] = arg2_284
end

function var0_0.UnRegisterCameraBlendFinished(arg0_285, arg1_285)
	arg0_285.cameraBlendCallbacks[arg1_285] = nil
end

function var0_0.OnCameraBlendFinished(arg0_286, arg1_286)
	if not arg1_286 then
		return
	end

	local var0_286 = table.removebykey(arg0_286.cameraBlendCallbacks, arg1_286)

	existCall(var0_286)
end

function var0_0.PlayHeartFX(arg0_287, arg1_287)
	local var0_287 = arg0_287.ladyDict[arg1_287]

	setActive(var0_287.effectHeart, false)
	setActive(var0_287.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_288, arg1_288)
	local var0_288 = arg1_288.name
	local var1_288 = arg0_288.expressionDict[var0_288]
	local var2_288 = 5

	if var1_288 then
		local var3_288 = var1_288.timer

		var3_288:Reset(nil, var2_288)
		var3_288:Start()

		if var1_288.instance then
			setActive(var1_288.instance, false)
			setActive(var1_288.instance, true)
		end

		return
	end

	local var4_288 = {
		name = var0_288,
		timer = Timer.New(function()
			arg0_288:RemoveExpression(var0_288)
		end, var2_288, 1, true)
	}

	arg0_288.expressionDict[var0_288] = var4_288

	arg0_288.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_288, var0_288, function(arg0_290)
		var4_288.instance = arg0_290

		onNextTick(function()
			setParent(arg0_290, arg0_288.ladyHeadCenter)
		end)
		setLocalPosition(arg0_290, Vector3(0, 0, -0.2))
		setActive(arg0_290, false)
		setActive(arg0_290, true)
	end, var4_288)
end

function var0_0.RemoveExpression(arg0_292, arg1_292)
	local var0_292 = arg0_292.expressionDict[arg1_292]

	if not var0_292 then
		return
	end

	arg0_292.loader:ClearRequest(var0_292)

	if var0_292.instance then
		arg0_292.loader:ReturnPrefab(var0_292.instance)
	end

	arg0_292.expressionDict[arg1_292] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_293, arg1_293)
	arg0_293.ladyWatchFloat = arg0_293.ladyWatchFloat or cloneTplTo(arg0_293.resTF:Find("vfx_talk_mark"), arg0_293.ladyHeadCenter)

	setActive(arg0_293.ladyWatchFloat, arg1_293)
end

function var0_0.RegisterGlobalVolume(arg0_294)
	local var0_294 = arg0_294.globalVolume
	local var1_294 = LuaHelper.GetOrAddVolumeComponent(var0_294, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_294 = LuaHelper.GetOrAddVolumeComponent(var0_294, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_294.originalCameraSettings = {
		depthOfField = {
			enabled = var1_294.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_294.gaussianStart.min,
				value = var1_294.gaussianStart.value
			},
			blurRadius = {
				min = var1_294.blurRadius.min,
				max = var1_294.blurRadius.max,
				value = var1_294.blurRadius.value
			}
		},
		postExposure = {
			value = var2_294.postExposure.value
		},
		contrast = {
			min = var2_294.contrast.min,
			max = var2_294.contrast.max,
			value = var2_294.contrast.value
		},
		saturate = {
			min = var2_294.saturation.min,
			max = var2_294.saturation.max,
			value = var2_294.saturation.value
		}
	}
	arg0_294.originalCameraSettings.depthOfField.enabled = true

	local var3_294 = var0_294:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_294.originalVolume = {
		profile = var3_294.sharedProfile,
		weight = var3_294.weight
	}
end

function var0_0.SettingCamera(arg0_295, arg1_295)
	arg0_295.activeCameraSettings = arg1_295

	local var0_295 = arg0_295.globalVolume
	local var1_295 = LuaHelper.GetOrAddVolumeComponent(var0_295, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_295 = LuaHelper.GetOrAddVolumeComponent(var0_295, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_295.enabled:Override(arg1_295.depthOfField.enabled)
	var1_295.gaussianStart:Override(arg1_295.depthOfField.focusDistance.value)
	var1_295.gaussianEnd:Override(arg1_295.depthOfField.focusDistance.value + arg1_295.depthOfField.focusDistance.length)
	var1_295.blurRadius:Override(arg1_295.depthOfField.blurRadius.value)
	var2_295.postExposure:Override(arg1_295.postExposure.value)
	var2_295.contrast:Override(arg1_295.contrast.value)
	var2_295.saturation:Override(arg1_295.saturate.value)
end

function var0_0.GetCameraSettings(arg0_296)
	return arg0_296.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_297)
	arg0_297:SettingCamera(arg0_297.originalCameraSettings)

	arg0_297.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_298, arg1_298, arg2_298)
	local var0_298 = arg0_298.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_298.activeProfileWeight = arg2_298

	if arg0_298.activeProfileName ~= arg1_298 then
		arg0_298.activeProfileName = arg1_298

		arg0_298.loader:LoadReference("dorm3d/scenesres/res/common", arg1_298, nil, function(arg0_299)
			var0_298.profile = arg0_299
			var0_298.weight = arg0_298.activeProfileWeight

			if arg0_298.activeCameraSettings then
				arg0_298:SettingCamera(arg0_298.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_298.weight = arg0_298.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_300)
	local var0_300 = arg0_300.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_300.profile = arg0_300.originalVolume.profile
	var0_300.weight = arg0_300.originalVolume.weight

	if arg0_300.activeCameraSettings then
		arg0_300:SettingCamera(arg0_300.activeCameraSettings)
	end

	arg0_300.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_301)
	local var0_301 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_301.originalCharacterColor = {
		color = var0_301.color,
		intensity = var0_301.intensity
	}
end

function var0_0.SetCharacterLight(arg0_302, arg1_302, arg2_302, arg3_302)
	local var0_302 = arg0_302.characterLight:GetComponent(typeof(Light))
	local var1_302 = Color.Lerp(arg0_302.originalCharacterColor.color, arg1_302, arg3_302)
	local var2_302 = math.lerp(arg0_302.originalCharacterColor.intensity, arg2_302, arg3_302)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_302, var2_302)
end

function var0_0.RevertCharacterLight(arg0_303)
	arg0_303:SetCharacterLight(arg0_303.originalCharacterColor.color, arg0_303.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_304, arg1_304, arg2_304)
	arg1_304 = arg1_304 or {}

	table.Foreach(arg0_304.clothComps, function(arg0_305, arg1_305)
		if arg1_305 == nil then
			return
		end

		setActive(arg1_305, arg1_304[arg0_305] == 1)
	end)
	table.Foreach(arg0_304.clothColliderDict, function(arg0_306, arg1_306)
		if arg1_306 == nil then
			return
		end

		setActive(arg1_306, false)
	end)

	if arg2_304 then
		table.Foreach(arg2_304, function(arg0_307, arg1_307)
			local var0_307 = arg0_304.clothColliderDict[arg1_307[1]]

			if var0_307 == nil then
				return
			end

			setActive(var0_307, arg1_307[2] == 1)

			if arg1_307[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_307, arg1_307[3], arg1_307[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_308, arg1_308)
	table.Foreach(arg1_308.ladyClothCompSettings, function(arg0_309, arg1_309)
		arg0_309.enabled = arg1_309.enabled
	end)
	table.Foreach(arg1_308.ladyClothColliderSettings, function(arg0_310, arg1_310)
		arg0_310.enabled = arg1_310.enabled

		var0_0.SetMagicaCollider(arg0_310, arg1_310.StartRadius, arg1_310.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_311)
	if arg0_311.exited or arg0_311.retainCount > 0 then
		-- block empty
	else
		arg0_311:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_312, arg1_312, arg2_312)
	assert(tobool(arg0_312.lastSceneRootDict[arg1_312]) == arg2_312)

	if arg2_312 then
		table.Foreach(arg0_312.lastSceneRootDict[arg1_312], function(arg0_313, arg1_313)
			if IsNil(arg0_313) then
				return
			end

			setActive(arg0_313, arg1_313)
		end)

		arg0_312.lastSceneRootDict[arg1_312] = nil
	else
		arg0_312.lastSceneRootDict[arg1_312] = {}

		local var0_312 = SceneManager.GetSceneByName(arg1_312)

		table.IpairsCArray(var0_312:GetRootGameObjects(), function(arg0_314, arg1_314)
			if tostring(arg1_314.hideFlags) ~= "None" then
				return
			end

			arg0_312.lastSceneRootDict[arg1_312][arg1_314] = isActive(arg1_314)

			setActive(arg1_314, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_315, arg1_315, arg2_315)
	arg1_315 = string.lower(arg1_315)

	if arg1_315 == arg0_315.artSceneInfo then
		if arg1_315 == arg0_315.sceneInfo then
			arg0_315:SwitchDayNight(arg0_315.contextData.timeIndex)
			onNextTick(function()
				arg0_315:RefreshSlots()
				existCall(arg2_315)
			end)
		else
			existCall(arg2_315)
		end

		return
	end

	local var0_315 = {}
	local var1_315 = false
	local var2_315

	table.insert(var0_315, function(arg0_317)
		arg0_315.artSceneInfo = arg1_315

		if var1_315 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_318)
				var2_315 = arg0_318

				arg0_317()
			end)
		else
			arg0_317()
		end
	end)

	if arg1_315 == arg0_315.sceneInfo then
		table.insert(var0_315, function(arg0_319)
			setActive(arg0_315.slotRoot, true)

			local var0_319, var1_319 = unpack(string.split(arg0_315.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_319))
			arg0_315:EnableSceneDisplay(var0_319, true)
			arg0_315:SwitchDayNight(arg0_315.contextData.timeIndex)
			onNextTick(function()
				arg0_315:RefreshSlots()
			end)
			arg0_319()
		end)
	else
		var1_315 = true

		local var3_315, var4_315 = unpack(string.split(arg1_315, "|"))

		table.insert(var0_315, function(arg0_321)
			setActive(arg0_315.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_315 .. "/" .. var3_315 .. "_scene"), var3_315, LoadSceneMode.Additive, function(arg0_322, arg1_322)
				SceneManager.SetActiveScene(arg0_322)

				local var0_322 = getSceneRootTFDic(arg0_322).MainCamera

				if var0_322 then
					setActive(var0_322, false)
				end

				arg0_321()
			end)
		end)
	end

	if arg0_315.artSceneInfo == arg0_315.sceneInfo then
		table.insert(var0_315, function(arg0_323)
			local var0_323, var1_323 = unpack(string.split(arg0_315.sceneInfo, "|"))

			arg0_315:EnableSceneDisplay(var0_323, false)
			arg0_323()
		end)
	else
		local var5_315, var6_315 = unpack(string.split(arg0_315.artSceneInfo, "|"))

		table.insert(var0_315, function(arg0_324)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_315 .. "/" .. var5_315 .. "_scene"), var5_315, arg0_324)
		end)
	end

	table.insert(var0_315, function(arg0_325)
		arg0_325()

		if var1_315 then
			var2_315()
		end
	end)
	seriesAsync(var0_315, arg2_315)
end

function var0_0.LoadTimelineScene(arg0_326, arg1_326, arg2_326, arg3_326)
	arg1_326 = string.lower(arg1_326)

	if arg0_326.cacheSceneDic[arg1_326] then
		if not arg2_326 then
			arg0_326.timelineScene = arg1_326

			arg0_326:EnableSceneDisplay(arg1_326, true)
		end

		return existCall(arg3_326)
	end

	local var0_326 = {}
	local var1_326

	table.insert(var0_326, function(arg0_327)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_328)
			if arg0_326.waitForTimeline then
				arg0_326.waitForTimeline = arg0_328
				var1_326 = nil
			else
				var1_326 = arg0_328
			end

			arg0_327()
		end)
	end)
	table.insert(var0_326, function(arg0_329)
		local var0_329 = arg0_326.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_329 .. "/timeline/" .. arg1_326 .. "/" .. arg1_326 .. "_scene"), arg1_326, LoadSceneMode.Additive, function(arg0_330, arg1_330)
			local var0_330 = GameObject.Find("[actor]").transform

			arg0_326:HXCharacter(tf(var0_330))

			local var1_330 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_330:Stop()
			TimelineSupport.InitTimeline(var1_330)
			TimelineSupport.InitSubtitle(var1_330, arg0_326.apartment:GetCallName())

			arg0_326.unloadDirector = var1_330

			arg0_329()
		end)
	end)
	table.insert(var0_326, function(arg0_331)
		arg0_326.sceneGroupDic[arg1_326] = arg0_326.apartment:GetConfigID()

		if arg2_326 then
			arg0_326.cacheSceneDic[arg1_326] = true

			arg0_326:EnableSceneDisplay(arg1_326, false)
		else
			arg0_326.timelineScene = arg1_326
		end

		arg0_331()
		existCall(var1_326)
	end)
	seriesAsync(var0_326, arg3_326)
end

function var0_0.UnloadTimelineScene(arg0_332, arg1_332, arg2_332, arg3_332)
	arg1_332 = string.lower(arg1_332)

	if arg0_332.timelineScene == arg1_332 then
		arg0_332.timelineScene = nil
	end

	if tobool(arg2_332) == tobool(arg0_332.cacheSceneDic[arg1_332]) then
		local var0_332 = getProxy(ApartmentProxy):getApartment(arg0_332.sceneGroupDic[arg1_332]):getConfig("asset_name")

		if arg0_332.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_332.unloadDirector)

			arg0_332.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_332 .. "/timeline/" .. arg1_332 .. "/" .. arg1_332 .. "_scene"), arg1_332, function()
			arg0_332.cacheSceneDic[arg1_332] = nil
			arg0_332.sceneGroupDic[arg1_332] = nil
			arg0_332.lastSceneRootDict[arg1_332] = nil

			existCall(arg3_332)
		end)
	else
		arg0_332:EnableSceneDisplay(arg1_332, false)
		existCall(arg3_332)
	end
end

function var0_0.ChangeSubScene(arg0_334, arg1_334, arg2_334)
	arg1_334 = string.lower(arg1_334)

	warning(arg0_334.subSceneInfo, "->", arg1_334, arg1_334 == arg0_334.subSceneInfo)

	if arg1_334 == arg0_334.subSceneInfo then
		arg0_334.ladyActiveZone = arg0_334.walkBornPoint or arg0_334.ladyBaseZone

		arg0_334:ChangeCharacterPosition()
		arg0_334:ChangePlayerPosition(arg0_334.ladyActiveZone)
		arg0_334:TriggerLadyDistance()
		arg0_334:CheckInSector()
		existCall(arg2_334)

		return
	end

	local var0_334 = {}
	local var1_334 = false
	local var2_334

	table.insert(var0_334, function(arg0_335)
		arg0_334.subSceneInfo = arg1_334

		if var1_334 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_336)
				var2_334 = arg0_336

				arg0_335()
			end)
		else
			arg0_335()
		end
	end)

	if arg1_334 == arg0_334.sceneInfo then
		table.insert(var0_334, function(arg0_337)
			local var0_337, var1_337 = unpack(string.split(arg0_334.sceneInfo, "|"))

			arg0_334:ResetSceneStructure(SceneManager.GetSceneByName(var0_337 .. "_base"))
			arg0_334:RefreshSlots()

			arg0_334.ladyActiveZone = arg0_334.walkBornPoint or arg0_334.ladyBaseZone

			arg0_334:ChangeCharacterPosition()
			arg0_334:ChangePlayerPosition(arg0_334.ladyActiveZone)
			arg0_334:TriggerLadyDistance()
			arg0_334:CheckInSector()
			arg0_337()
		end)
	else
		var1_334 = true

		local var3_334, var4_334 = unpack(string.split(arg1_334, "|"))
		local var5_334 = var3_334 .. "_base"

		table.insert(var0_334, function(arg0_338)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_334 .. "/" .. var5_334 .. "_scene"), var5_334, LoadSceneMode.Additive, arg0_338)
		end)
		table.insert(var0_334, function(arg0_339)
			arg0_334:ResetSceneStructure(SceneManager.GetSceneByName(var5_334))

			arg0_334.ladyActiveZone = arg0_334.walkBornPoint or "Default"

			arg0_334:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_334:ChangeCharacterPosition()
				arg0_334:ChangePlayerPosition(arg0_334.ladyActiveZone)
				arg0_334:TriggerLadyDistance()
				arg0_334:CheckInSector()
				arg0_339()
			end)
		end)
	end

	if arg0_334.subSceneInfo == arg0_334.sceneInfo then
		table.insert(var0_334, function(arg0_341)
			local var0_341 = Clone(arg0_334.room)

			var0_341.furnitures = {}

			arg0_334:RefreshSlots(var0_341)
			arg0_341()
		end)
	else
		local var6_334, var7_334 = unpack(string.split(arg0_334.subSceneInfo, "|"))
		local var8_334 = var6_334 .. "_base"

		table.insert(var0_334, function(arg0_342)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_334 .. "/" .. var8_334 .. "_scene"), var8_334, arg0_342)
		end)
	end

	table.insert(var0_334, function(arg0_343)
		arg0_343()

		if var1_334 then
			var2_334()
		end
	end)
	seriesAsync(var0_334, arg2_334)
end

function var0_0.TransformMesh(arg0_344)
	local var0_344 = arg0_344.sharedMesh
	local var1_344 = {}
	local var2_344 = arg0_344.transform:TransformPoint(var0_344.vertices[0])
	local var3_344 = arg0_344.transform:TransformPoint(var0_344.vertices[1])
	local var4_344 = arg0_344.transform:TransformPoint(var0_344.vertices[2])

	var1_344.horizontal = var3_344 - var2_344
	var1_344.verticle = var4_344 - var2_344
	var1_344.origin = var2_344

	return var1_344
end

function var0_0.GetRatio(arg0_345, arg1_345)
	local var0_345 = Vector2.zero

	var0_345.x = Vector3.Dot(arg0_345.horizontal, arg1_345) / arg0_345.horizontal.sqrMagnitude
	var0_345.y = Vector3.Dot(arg0_345.verticle, arg1_345) / arg0_345.verticle.sqrMagnitude

	return var0_345
end

function var0_0.GetPostionByRatio(arg0_346, arg1_346)
	return arg0_346.horizontal * arg1_346.x + arg0_346.verticle * arg1_346.y + arg0_346.origin
end

function var0_0.IsPointInSector(arg0_347, arg1_347)
	local var0_347 = arg1_347 - Vector3.New(unpack(arg0_347.Position))

	if var0_347.magnitude > arg0_347.Radius then
		return false
	end

	local var1_347 = Quaternion.Euler(unpack(arg0_347.Rotation))

	return Vector3.Angle(var1_347 * Vector3.forward, var0_347) <= arg0_347.Angle / 2
end

function var0_0.willExit(arg0_348)
	arg0_348.joystickTimer:Stop()
	arg0_348.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_348.updateHandler)
	arg0_348:StopIKHandTimer()

	if arg0_348.moveTimer then
		arg0_348.moveTimer:Stop()

		arg0_348.moveTimer = nil
	end

	if arg0_348.moveWaitTimer then
		arg0_348.moveWaitTimer:Stop()

		arg0_348.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_348.furnitures) then
		eachChild(arg0_348.furnitures, function(arg0_349)
			local var0_349 = GetComponent(arg0_349, typeof(EventTriggerListener))

			if not var0_349 then
				return
			end

			var0_349:ClearEvents()
		end)
	end

	for iter0_348, iter1_348 in pairs(arg0_348.ladyDict) do
		arg0_348:ResetActiveIKs(iter1_348)
		GetComponent(iter1_348.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_348.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_348.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_348.blockLayer, arg0_348._tf)
	table.Foreach(arg0_348.expressionDict, function(arg0_350)
		arg0_348:RemoveExpression(arg0_350)
	end)
	arg0_348.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_348 = {}

	if arg0_348.timelineScene and not arg0_348.cacheSceneDic[arg0_348.timelineScene] then
		local var1_348 = arg0_348.timelineScene

		arg0_348.timelineScene = nil

		local var2_348 = getProxy(ApartmentProxy):getApartment(arg0_348.sceneGroupDic[var1_348]):getConfig("asset_name")

		table.insert(var0_348, function(arg0_351)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_348 .. "/timeline/" .. var1_348 .. "/" .. var1_348 .. "_scene"), var1_348, arg0_351)
		end)
	end

	for iter2_348, iter3_348 in pairs(arg0_348.cacheSceneDic) do
		if iter3_348 then
			local var3_348 = getProxy(ApartmentProxy):getApartment(arg0_348.sceneGroupDic[iter2_348]):getConfig("asset_name")

			table.insert(var0_348, function(arg0_352)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_348 .. "/timeline/" .. iter2_348 .. "/" .. iter2_348 .. "_scene"), iter2_348, arg0_352)
			end)
		end
	end

	for iter4_348, iter5_348 in ipairs({
		arg0_348.sceneInfo,
		arg0_348.subSceneInfo ~= arg0_348.sceneInfo and arg0_348.subSceneInfo or nil
	}) do
		local var4_348, var5_348 = unpack(string.split(iter5_348, "|"))
		local var6_348 = var4_348 .. "_base"

		table.insert(var0_348, function(arg0_353)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_348 .. "/" .. var6_348 .. "_scene"), var6_348, arg0_353)
		end)
	end

	for iter6_348, iter7_348 in ipairs({
		arg0_348.sceneInfo,
		arg0_348.artSceneInfo ~= arg0_348.sceneInfo and arg0_348.artSceneInfo or nil
	}) do
		local var7_348, var8_348 = unpack(string.split(iter7_348, "|"))

		table.insert(var0_348, function(arg0_354)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_348 .. "/" .. var7_348 .. "_scene"), var7_348, arg0_354)
		end)
	end

	seriesAsync(var0_348, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_356 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_356 = SystemInfo.deviceModel or ""

			local function var2_356(arg0_357)
				local var0_357 = string.match(arg0_357, "iPad(%d+)")
				local var1_357 = tonumber(var0_357)

				if var1_357 and var1_357 >= 8 then
					return true
				end

				return false
			end

			local function var3_356(arg0_358)
				local var0_358 = string.match(arg0_358, "iPhone(%d+)")
				local var1_358 = tonumber(var0_358)

				if var1_358 and var1_358 >= 13 then
					return true
				end

				return false
			end

			if var2_356(var1_356) or var3_356(var1_356) then
				var0_356 = DevicePerformanceLevel.High
			end
		end

		local var4_356 = var0_356 == DevicePerformanceLevel.High and 3 or var0_356 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_356)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_356
	end
end

function var0_0.SettingQuality()
	local var0_359 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_359)
end

function var0_0.SetMagicaCollider(arg0_360, arg1_360, arg2_360)
	local var0_360 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_360, "StartRadius", arg0_360, arg1_360)
	ReflectionHelp.RefSetProperty(var0_360, "EndRadius", arg0_360, arg2_360)
end

return var0_0
