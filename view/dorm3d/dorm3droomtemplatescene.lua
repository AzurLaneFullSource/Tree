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
		if arg0_15.scene.blockIK then
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

		arg1_25.scene.blockIK = nil

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
			trans = var2_44,
			sceneHides = {}
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

			if arg0_49:CheckSceneItemActive(var2_49) then
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

			if arg0_111.scene.enableIKTip then
				local var0_111 = Time.time > arg0_111.nextTipIKTime
				local var1_111 = arg0_111:GetIKTipsRootTF()

				if var0_111 then
					local var2_111 = arg0_111
					local var3_111 = var2_111.ikConfig
					local var4_111 = #var2_111.readyIKLayers + #var3_111.touch_data

					UIItemList.StaticAlign(var1_111, var1_111:GetChild(0), var4_111, function(arg0_114, arg1_114, arg2_114)
						if arg0_114 ~= UIItemList.EventUpdate then
							return
						end

						arg1_114 = arg1_114 + 1

						local var0_114
						local var1_114 = Vector2.zero

						if arg1_114 > #var2_111.readyIKLayers then
							local var2_114 = arg1_114 - #var2_111.readyIKLayers
							local var3_114 = var3_111.touch_data[var2_114][1]
							local var4_114 = pg.dorm3d_ik_touch[var3_114]

							if #var4_114.scene_item > 0 then
								var0_114 = arg0_111:GetSceneItem(var4_114.scene_item)
							else
								var0_114 = arg0_111.ladyColliders[var4_114.body]
							end
						else
							local var5_114 = var2_111.readyIKLayers[arg1_114].ikData
							local var6_114 = var5_114:GetTriggerBoneName()

							var0_114 = var6_114 and arg0_111.ladyColliders[var6_114] or nil
							var1_114 = var5_114:GetIKTipOffset()
						end

						if var0_114 then
							local function var7_114()
								local var0_115 = arg0_111.raycastCamera:WorldToScreenPoint(var0_114.position)
								local var1_115 = CameraMgr.instance:Raycast(arg0_111.sceneRaycaster, var0_115)

								if var1_115.Length == 0 then
									return
								end

								return var0_114 == var1_115[0].gameObject.transform
							end
						end

						if var0_114 then
							setLocalPosition(arg2_114, arg0_111:GetLocalPosition(arg0_111:GetScreenPosition(var0_114.position), var1_111) + var1_114)
						end

						setActive(arg2_114, var0_114)
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
		arg0_123.slotDict[var0_124].furnitureId = var1_124 and var1_124:GetConfigID()

		local function var4_124(arg0_126)
			if var3_124 then
				setActive(var3_124, var2_124 == "")
			end

			table.Foreach(arg0_123.slotDict[var0_124].sceneHides or {}, function(arg0_127, arg1_127)
				setActive(arg1_127.trans, arg1_127.visible)
			end)

			arg0_123.slotDict[var0_124].sceneHides = {}

			if arg0_126 then
				local var0_126 = arg0_126:getConfig("scene_hides")

				if #var0_126 > 0 then
					table.Ipairs(var0_126, function(arg0_128, arg1_128)
						local var0_128 = arg0_123.modelRoot:Find(arg1_128)

						assert(var0_128, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_126:GetConfigID(), arg1_128))

						local var1_128 = isActive(var0_128)

						table.insert(arg0_123.slotDict[var0_124].sceneHides, {
							name = arg1_128,
							trans = var0_128,
							visible = var1_128
						})
						setActive(var0_128, false)
					end)
				end
			end
		end

		if var2_124 == false or var2_124 == "" then
			arg0_123.loader:ClearRequest("slot_" .. var0_124)
			var4_124()
			arg2_124()

			return
		end

		local var5_124 = arg0_123.slotDict[var0_124].trans

		if arg0_123.loader:GetLoadingRP("slot_" .. var0_124) then
			arg0_123:emit(var0_0.HIDE_BLOCK)
		end

		arg0_123.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_124, "", function(arg0_129)
			arg2_124()
			assert(arg0_129)
			setParent(arg0_129, var5_124)
			var4_124(var1_124)
		end, "slot_" .. var0_124)
	end, function()
		arg0_123:emit(var0_0.HIDE_BLOCK)
	end)
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

function var0_0.ChangeCharacterPosition(arg0_135)
	arg0_135:ResetCharPoint(arg0_135.ladyActiveZone)
	arg0_135:SyncInterestTransform(arg0_135)
end

function var0_0.SyncCurrentInterestTransform(arg0_136)
	local var0_136 = arg0_136.ladyDict[arg0_136.apartment:GetConfigID()]

	arg0_136:SyncInterestTransform(var0_136)
end

function var0_0.SyncInterestTransform(arg0_137, arg1_137)
	arg0_137.ladyInterest.position = arg1_137.ladyInterestRoot.position
	arg0_137.ladyInterest.rotation = arg1_137.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_138, arg1_138)
	arg1_138 = arg1_138 or arg0_138.contextData.inFurnitureName

	local var0_138 = arg0_138.furnitures:Find(arg1_138):Find("PlayerPoint").position

	arg0_138.player.position = var0_138
	arg0_138.cameras[var0_0.CAMERA.POV].transform.position = arg0_138.playerEye.position

	local var1_138 = arg0_138.ladyInterest.position - arg0_138.playerEye.position
	local var2_138 = Quaternion.LookRotation(var1_138).eulerAngles
	local var3_138 = var2_138.y
	local var4_138 = var2_138.x
	local var5_138 = arg0_138.compPovAim.m_HorizontalAxis

	var5_138.Value = arg0_138:GetNearestAngle(var3_138, var5_138.m_MinValue, var5_138.m_MaxValue)
	arg0_138.compPovAim.m_HorizontalAxis = var5_138

	local var6_138 = arg0_138.compPovAim.m_VerticalAxis

	var6_138.Value = var4_138
	arg0_138.compPovAim.m_VerticalAxis = var6_138
end

function var0_0.GetAttachedFurnitureName(arg0_139)
	return arg0_139.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_140, arg1_140)
	return underscore.detect(arg0_140.attachedPoints, function(arg0_141)
		return arg0_141.name == arg1_140
	end)
end

function var0_0.GetSlotByID(arg0_142, arg1_142)
	return arg0_142.displaySlots[arg1_142] and arg0_142.displaySlots[arg1_142].trans
end

function var0_0.GetScreenPosition(arg0_143, arg1_143)
	local var0_143 = arg0_143.raycastCamera:WorldToScreenPoint(arg1_143)

	if var0_143.z < 0 then
		var0_143.x = var0_143.x + (var0_143.x < 0 and -1 or 1) * Screen.width
		var0_143.y = var0_143.y + (var0_143.y < 0 and -1 or 1) * Screen.height
		var0_143.z = -var0_143.z
	end

	return var0_143
end

function var0_0.GetLocalPosition(arg0_144, arg1_144, arg2_144)
	return LuaHelper.ScreenToLocal(arg2_144, arg1_144, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_145)
	return arg0_145.modelRoot
end

function var0_0.ShiftZone(arg0_146, arg1_146, arg2_146)
	local var0_146 = arg0_146:GetFurnitureByName(arg1_146)

	if not var0_146 then
		errorMsg(arg1_146 .. " Not Find")
		existCall(arg2_146)

		return
	end

	seriesAsync({
		function(arg0_147)
			arg0_146:emit(var0_0.SHOW_BLOCK)
			arg0_146:ShowBlackScreen(true, arg0_147)
		end,
		function(arg0_148)
			if arg0_146.shiftLady or arg0_146.room:isPersonalRoom() then
				local var0_148 = arg0_146.shiftLady or arg0_146.apartment:GetConfigID()

				arg0_146.shiftLady = nil
				arg0_146.contextData.ladyZone[var0_148] = var0_146.name

				local var1_148 = arg0_146.ladyDict[var0_148]

				var1_148.ladyBaseZone = arg0_146.contextData.ladyZone[var0_148]
				var1_148.ladyActiveZone = arg0_146.contextData.ladyZone[var0_148]

				if var1_148:GetBlackboardValue("inPending") then
					var1_148:SetOutPending()
					var1_148:SwitchAnim(var0_0.ANIM.IDLE)
					onNextTick(function()
						var1_148:ChangeCharacterPosition()
						arg0_148()
					end)
				else
					var1_148:ChangeCharacterPosition()
					arg0_148()
				end
			else
				arg0_148()
			end
		end,
		function(arg0_150)
			arg0_146.contextData.inFurnitureName = var0_146.name

			arg0_146:ChangePlayerPosition()
			arg0_146:TriggerLadyDistance()
			arg0_146:CheckInSector()
			arg0_150()
		end,
		function(arg0_151)
			arg0_146:UpdateZoneList()
			arg0_146:ShowBlackScreen(false, arg0_151)
		end,
		function(arg0_152)
			arg0_146:emit(var0_0.HIDE_BLOCK)
			arg0_152()
		end
	}, arg2_146)
end

function var0_0.WalkByRootMotionLoop(arg0_153, arg1_153, arg2_153)
	if arg1_153.pathPending then
		arg2_153:SetFloat("Speed", 0)

		return
	end

	arg2_153:SetFloat("Speed", 1)

	local var0_153 = arg1_153.path.corners

	if var0_153.Length > 1 then
		local var1_153 = var0_153[1] - arg1_153.transform.position

		var1_153.y = 0

		local var2_153 = Quaternion.LookRotation(var1_153)
		local var3_153 = arg1_153.transform.rotation
		local var4_153 = 1
		local var5_153 = Damp(1, var4_153, Time.deltaTime)

		arg1_153.transform.rotation = Quaternion.Lerp(var3_153, var2_153, var5_153)
	end
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

function var0_0.ShowBlackScreen(arg0_156, arg1_156, arg2_156)
	local var0_156 = arg0_156.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_156 and 0 or 0.3
	}

	setImageColor(arg0_156.blackLayer, Color.NewHex(var0_156.color))
	setActive(arg0_156.blackLayer, true)
	setCanvasGroupAlpha(arg0_156.blackLayer, arg1_156 and 0 or 1)
	arg0_156:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_156 then
			setActive(arg0_156.blackLayer, false)
		end

		existCall(arg2_156)
	end, GetComponent(arg0_156.blackLayer, typeof(CanvasGroup)), arg1_156 and 1 or 0, var0_156.time):setDelay(var0_156.delay)
end

function var0_0.RegisterOrbits(arg0_158, arg1_158)
	arg0_158 = arg0_158.scene
	arg0_158.orbits = {
		original = arg1_158.m_Orbits
	}
	arg0_158.orbits.current = _.range(3):map(function(arg0_159)
		local var0_159 = arg0_158.orbits.original[arg0_159 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_159.m_Height, var0_159.m_Radius)
	end)
	arg0_158.surroudCamera = arg1_158
end

function var0_0.SetCameraObrits(arg0_160)
	local var0_160 = arg0_160.surroudCamera

	if not var0_160 then
		return
	end

	local var1_160 = arg0_160.orbits.original[1]

	for iter0_160 = 0, #arg0_160.orbits.current - 1 do
		local var2_160 = arg0_160.orbits.current[iter0_160 + 1]
		local var3_160 = arg0_160.orbits.original[iter0_160]

		var2_160.m_Height = math.lerp(var1_160.m_Height, var3_160.m_Height, arg0_160.pinchValue)
		var2_160.m_Radius = var3_160.m_Radius * arg0_160.pinchValue
	end

	var0_160.m_Orbits = arg0_160.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_161)
	arg0_161 = arg0_161.scene

	local var0_161 = arg0_161.surroudCamera

	if not var0_161 then
		return
	end

	for iter0_161 = 0, #arg0_161.orbits.current - 1 do
		local var1_161 = arg0_161.orbits.current[iter0_161 + 1]
		local var2_161 = arg0_161.orbits.original[iter0_161]

		var1_161.m_Height = var2_161.m_Height
		var1_161.m_Radius = var2_161.m_Radius
	end

	var0_161.m_Orbits = arg0_161.orbits.current
	arg0_161.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_162, arg1_162, arg2_162)
	local var0_162 = {
		base = function(arg0_163)
			arg0_162:RegisterCameraBlendFinished(arg0_162.cameras[var0_0.CAMERA.POV], arg0_163)
			arg0_162:ActiveCamera(arg0_162.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_164)
			assert(arg0_162.apartment)
			arg0_162.ladyDict[arg0_162.apartment:GetConfigID()]:SetCameraLady()
			arg0_162:RegisterCameraBlendFinished(arg0_162.cameras[var0_0.CAMERA.ROLE], arg0_164)
			arg0_162:ActiveCamera(arg0_162.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_165)
			arg0_162:RegisterCameraBlendFinished(arg0_162.cameras[var0_0.CAMERA.POV], arg0_165)
			arg0_162:ActiveCamera(arg0_162.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_166)
			arg0_166()
		end,
		gift = function(arg0_167)
			assert(arg0_162.apartment)
			arg0_162.ladyDict[arg0_162.apartment:GetConfigID()]:SetCameraLady()
			arg0_162:RegisterCameraBlendFinished(arg0_162.cameras[var0_0.CAMERA.GIFT], arg0_167)
			arg0_162:ActiveCamera(arg0_162.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_168)
			assert(arg0_162.apartment)
			arg0_162.ladyDict[arg0_162.apartment:GetConfigID()]:SetCameraLady()

			arg0_162.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_162.cameraRole.transform.position

			arg0_162:RegisterCameraBlendFinished(arg0_162.cameras[var0_0.CAMERA.ROLE2], arg0_168)
			arg0_162:ActiveCamera(arg0_162.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_169)
			assert(arg0_162.apartment)
			arg0_162.ladyDict[arg0_162.apartment:GetConfigID()]:SetCameraLady()
			arg0_162:RegisterCameraBlendFinished(arg0_162.cameras[var0_0.CAMERA.TALK], arg0_169)
			arg0_162:ActiveCamera(arg0_162.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_162 = {}

	table.insert(var1_162, function(arg0_170)
		switch(arg1_162, var0_162, arg0_170, arg0_170)
	end)
	seriesAsync(var1_162, arg2_162)
end

function var0_0.GetSceneItem(arg0_171, arg1_171)
	local var0_171

	if string.find(arg1_171, "fbx/") == 1 then
		var0_171 = arg0_171.modelRoot:Find(arg1_171)
	elseif string.find(arg1_171, "FurnitureSlots/") == 1 then
		arg1_171 = string.gsub(arg1_171, "^FurnitureSlots/", "", 1)
		var0_171 = arg0_171.slotRoot:Find(arg1_171)
	end

	if not var0_171 then
		warning(string.format("Missing scene item path: %s", arg1_171))
	end

	return var0_171
end

function var0_0.SetIKStatus(arg0_172, arg1_172, arg2_172)
	local var0_172 = arg0_172

	warning("Set IKStatus " .. (arg1_172.id or "NIL"))

	arg0_172.scene.enableIKTip = true

	setActive(arg0_172.ladyCollider, false)
	_.each(arg0_172.ladyTouchColliders, function(arg0_173)
		setActive(arg0_173, true)
	end)
	table.clear(arg0_172.readyIKLayers)

	arg0_172.scene.blockIK = nil

	local var1_172 = _.map(arg1_172.ik_id, function(arg0_174)
		return arg0_174[1]
	end)

	table.Foreach(var1_172, function(arg0_175, arg1_175)
		local var0_175 = Dorm3dIK.New({
			configId = arg1_175
		})

		table.insert(arg0_172.readyIKLayers, {
			ikData = var0_175
		})

		arg0_172.cacheIKInfos[var0_175] = {}

		local var1_175 = var0_175:GetControllerPath()
		local var2_175 = arg0_172.ladyIKRoot:Find(var1_175):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
		local var3_175 = {}

		table.IpairsCArray(var2_175.IKComponents, function(arg0_176, arg1_176)
			var3_175[arg0_176 + 1] = arg1_176:GetIKSolver()
		end)

		arg0_172.cacheIKInfos[var0_175].solvers = var3_175

		local var4_175 = _.map(var3_175, function(arg0_177)
			return arg0_177.IKPositionWeight
		end)

		arg0_172.cacheIKInfos[var0_175].weights = var4_175
	end)

	local var2_172 = _.map(arg1_172.touch_data, function(arg0_178)
		return arg0_178[1]
	end)

	table.Foreach(var2_172, function(arg0_179, arg1_179)
		local var0_179 = pg.dorm3d_ik_touch[arg1_179]

		if #var0_179.scene_item == 0 then
			return
		end

		local var1_179 = arg0_172:GetSceneItem(var0_179.scene_item)

		if not var1_179 then
			warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg1_179, var0_179.scene_item))

			return
		end

		if IsNil(GetComponent(var1_179, typeof(UnityEngine.Collider))) then
			go(var1_179):AddComponent(typeof(UnityEngine.BoxCollider))
		end

		local var2_179 = GetOrAddComponent(var1_179, typeof(EventTriggerListener))

		var2_179.enabled = true

		var2_179:AddPointClickFunc(function()
			arg0_172.scene.blockIK = true

			local var0_180 = arg1_172.touch_data[arg0_179]
			local var1_180, var2_180, var3_180 = unpack(var0_180)

			arg0_172:TouchModeAction(var0_172, unpack(var3_180))(function()
				arg0_172.scene.enableIKTip = true

				arg0_172:ResetIKTipTimer()

				arg0_172.scene.blockIK = nil
			end)
		end)
	end)

	arg0_172.camBrain.enabled = false

	if arg0_172.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_172.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_172.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var3_172 = arg0_172.cameraRoot:Find(arg1_172.ik_camera)

	assert(var3_172, "Missing IKCamera")

	arg0_172.cameras[var0_0.CAMERA.IK_WATCH] = var3_172

	arg0_172:ActiveCamera(arg0_172.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_172.camBrain.enabled = true

	local var4_172 = var3_172:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var4_172 then
		arg0_172:RegisterOrbits(var4_172)
	end

	arg0_172:SettingHeadAimIK(arg0_172, arg0_172.ikConfig.head_track)
	arg0_172:ResetIKTipTimer()
	arg0_172:SwitchAnim(arg1_172.character_action)

	local var5_172 = arg1_172.enter_scene_anim
	local var6_172 = {}

	if var5_172 and #var5_172 > 0 then
		table.Ipairs(var5_172, function(arg0_182, arg1_182)
			arg0_172.scene:PlaySceneItemAnim(arg1_182[1], arg1_182[2])
			table.insert(var6_172, arg1_182[1])
		end)
	end

	arg0_172.scene:ResetSceneItemAnimators(var6_172)
	onNextTick(function()
		local var0_183 = arg0_172.furnitures:Find(arg1_172.character_position)

		arg0_172.lady.position = var0_183:Find("StayPoint").position
		arg0_172.lady.rotation = var0_183:Find("StayPoint").rotation

		arg0_172:EnableCloth(false)
		arg0_172:EnableCloth(arg1_172.use_cloth, arg1_172.cloth_colliders)
		existCall(arg2_172)
	end)
end

function var0_0.ExitIKStatus(arg0_184, arg1_184, arg2_184)
	local var0_184 = arg0_184

	arg0_184.scene.enableIKTip = false

	setActive(arg0_184.ladyCollider, true)
	_.each(arg0_184.ladyTouchColliders, function(arg0_185)
		setActive(arg0_185, false)
	end)
	arg0_184:ResetActiveIKs(arg0_184)
	table.clear(arg0_184.readyIKLayers)
	table.clear(arg0_184.cacheIKInfos)
	table.clear(arg0_184.activeIKLayers)
	table.clear(arg0_184.holdingStatus)
	eachChild(arg0_184.ladyIKRoot, function(arg0_186)
		setActive(arg0_186, false)
	end)
	setActive(arg0_184:GetIKTipsRootTF(), false)

	local var1_184 = _.map(arg1_184.touch_data or {}, function(arg0_187)
		return arg0_187[1]
	end)

	table.Foreach(var1_184, function(arg0_188, arg1_188)
		local var0_188 = pg.dorm3d_ik_touch[arg1_188]

		if #var0_188.scene_item == 0 then
			return
		end

		local var1_188 = arg0_184.modelRoot:Find(var0_188.scene_item)

		if not var1_188 then
			return
		end

		local var2_188 = GetOrAddComponent(var1_188, typeof(EventTriggerListener))

		var2_188:ClearEvents()

		var2_188.enabled = false
	end)
	arg0_184:RevertCameraOrbit()
	setActive(arg0_184.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_184.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_184:EnableCloth(false)
	arg0_184:ResetHeadAimIK(arg0_184)
	arg0_184:SwitchAnim(arg1_184.character_action)
	arg0_184.scene:ResetSceneItemAnimators()
	onNextTick(function()
		if arg1_184.character_position then
			arg0_184.ladyActiveZone = arg1_184.character_position
		else
			arg0_184.ladyActiveZone = arg0_184.ladyBaseZone
		end

		arg0_184:ChangeCharacterPosition()
		arg0_184:TriggerLadyDistance()
		arg0_184:CheckInSector()
		existCall(arg2_184)
	end)
end

function var0_0.EnableIKLayer(arg0_190, arg1_190, arg2_190)
	warning("ENABLEIK", arg2_190:GetConfigID())

	local var0_190 = arg2_190:GetControllerPath()
	local var1_190 = arg1_190.ladyIKRoot:Find(var0_190):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
	local var2_190 = tf(var1_190):Find("Container")
	local var3_190 = {
		ikData = arg2_190,
		list = var1_190
	}

	if not arg1_190.holdingStatus[arg2_190] then
		var3_190.rect = arg2_190:GetRect()

		local var4_190 = arg2_190:GetActionTriggerParams()

		if var4_190[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET or var4_190[1] == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET then
			var3_190.triggerRect = arg2_190:GetTriggerRect()
		end

		local var5_190 = var2_190:Find("SubTargets")
		local var6_190 = {}

		assert(var5_190)

		local var7_190 = arg2_190:GetSubTargets()
		local var8_190 = arg2_190:GetPlaneRotations()
		local var9_190 = arg2_190:GetPlaneScales()

		table.Foreach(var7_190, function(arg0_191, arg1_191)
			local var0_191 = var5_190:Find(arg1_191[1])
			local var1_191 = var0_191:Find("Plane")

			if var8_190[arg0_191] then
				var1_191.localRotation = var8_190[arg0_191]
				var1_191.localScale = var9_190[arg0_191]
			end

			local var2_191 = var0_191:Find("Target")
			local var3_191 = var0_0.TransformMesh(var1_191:GetComponent(typeof(UnityEngine.MeshCollider)))
			local var4_191 = arg1_190.ladyBoneMaps[arg1_191[1]]

			var3_191.origin = var4_191.position

			local var5_191 = var3_190.rect
			local var6_191 = Vector2.New(var5_191.center.x / var5_191.width, var5_191.center.y / var5_191.height)

			var1_191.position = var0_0.GetPostionByRatio(var3_191, var6_191)
			var2_191.position = var4_191.position

			local var7_191 = {
				planeData = var3_191,
				target = var2_191,
				useOffset = tobool(arg1_191)
			}

			table.insert(var6_190, var7_191)
		end)

		var3_190.subPlanes = var6_190

		setActive(var1_190, true)
	else
		var3_190 = arg1_190.holdingStatus[arg2_190].ikHandler
	end

	if #arg2_190:GetHeadTrackPath() > 0 then
		arg0_190:SettingHeadAimIK(arg1_190, {
			2,
			arg2_190:GetHeadTrackPath()
		}, true)
	end

	local var10_190 = arg2_190:GetTriggerFaceAnim()

	if #var10_190 > 0 then
		arg0_190:PlayFaceAnim(var10_190)
	end

	setActive(arg0_190:GetIKHandTF(), true)
	eachChild(arg0_190:GetIKHandTF(), function(arg0_192)
		setActive(arg0_192, false)
	end)
	arg0_190:StopIKHandTimer()
	setActive(arg0_190:GetIKHandTF():Find("Begin"), true)

	arg1_190.ikHandTimer = Timer.New(function()
		setActive(arg0_190:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_190:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg1_190.ikHandTimer:Start()

	arg1_190.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_190:emit(var0_0.ON_IK_STATUS_CHANGED, arg2_190:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_190.apartment.configId, arg0_190.apartment.level, arg1_190.ikConfig.character_action, arg2_190:GetTriggerParams()[2], arg0_190.room:GetConfigID()))

	return var3_190
end

function var0_0.DeactiveIKLayer(arg0_194, arg1_194)
	if #arg1_194:GetHeadTrackPath() > 0 then
		arg0_194:SettingHeadAimIK(arg0_194, arg0_194.ikConfig.head_track)
	end

	arg0_194:StopIKHandTimer()
	setActive(arg0_194:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_194:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_194:GetIKHandTF():Find("End"), true)

	arg0_194.ikHandTimer = Timer.New(function()
		setActive(arg0_194:GetIKHandTF():Find("End"), false)
		setActive(arg0_194:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_194.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_196)
	if not arg0_196.ikHandTimer then
		return
	end

	arg0_196.ikHandTimer:Stop()

	arg0_196.ikHandTimer = nil
end

function var0_0.RevertIKLayer(arg0_197, arg1_197, arg2_197)
	seriesAsync({
		function(arg0_198)
			if arg1_197 >= 999 then
				return arg0_198()
			end

			arg0_197:PlayIKRevert(arg0_197, arg1_197, arg0_198)
		end,
		arg2_197
	})
end

function var0_0.RevertAllIKLayer(arg0_199, arg1_199, arg2_199)
	table.insertto(arg0_199.activeIKLayers, _.keys(arg0_199.holdingStatus))
	table.clear(arg0_199.holdingStatus)
	arg0_199.RevertIKLayer(arg0_199, arg1_199, arg2_199)
end

function var0_0.PlayIKRevert(arg0_200, arg1_200, arg2_200, arg3_200)
	local var0_200 = Time.time

	function arg0_200.ikRevertHandler()
		local var0_201 = Time.time - var0_200

		_.each(arg1_200.activeIKLayers, function(arg0_202)
			local var0_202 = 1

			if arg2_200 > 0 then
				var0_202 = var0_201 / arg2_200
			end

			local var1_202 = arg1_200.cacheIKInfos[arg0_202].solvers
			local var2_202 = arg1_200.cacheIKInfos[arg0_202].weights

			table.Foreach(var1_202, function(arg0_203, arg1_203)
				arg1_203.IKPositionWeight = math.lerp(var2_202[arg0_203], 0, var0_202)
			end)
		end)

		if var0_201 >= arg2_200 then
			arg0_200:ResetActiveIKs(arg1_200)

			arg0_200.ikRevertHandler = nil

			existCall(arg3_200)
		end
	end

	arg0_200.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_204, arg1_204)
	table.insertto(arg0_204.activeIKLayers, _.keys(arg0_204.holdingStatus))
	table.clear(arg0_204.holdingStatus)
	_.each(arg1_204.activeIKLayers, function(arg0_205)
		local var0_205 = arg0_205:GetControllerPath()
		local var1_205 = arg1_204.ladyIKRoot:Find(var0_205):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_205, false)

		local var2_205 = arg1_204.cacheIKInfos[arg0_205].solvers
		local var3_205 = arg1_204.cacheIKInfos[arg0_205].weights

		table.Foreach(var2_205, function(arg0_206, arg1_206)
			arg1_206.IKPositionWeight = var3_205[arg0_206]
		end)
	end)
	table.clear(arg1_204.activeIKLayers)
end

function var0_0.PlayIKAction(arg0_207, arg1_207)
	warning("Trigger IK", arg1_207:GetConfigID())
	arg0_207:OnTriggerIK(arg1_207:GetConfigID())
	arg0_207:emit(var0_0.ON_IK_STATUS_CHANGED, arg1_207:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
end

function var0_0.ResetIKTipTimer(arg0_208)
	if not arg0_208.scene.enableIKTip then
		return
	end

	arg0_208.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableHeadIK(arg0_209, arg1_209)
	arg0_209.ladyHeadIKComp.enableIk = arg1_209
end

function var0_0.SettingHeadAimIK(arg0_210, arg1_210, arg2_210, arg3_210)
	local var0_210

	if arg2_210[1] == 1 then
		var0_210 = arg0_210.mainCameraTF:Find("AimTarget")
	elseif arg2_210[1] == 2 then
		table.IpairsCArray(arg1_210.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_211, arg1_211)
			if arg1_211.name ~= arg2_210[2] then
				return
			end

			var0_210 = arg1_211
		end)
	end

	arg1_210.ladyHeadIKComp.AimTarget = var0_210

	if not arg3_210 and arg2_210[3] then
		arg1_210.ladyHeadIKComp.BodyWeight = arg2_210[3]
	end

	if not arg3_210 and arg2_210[4] then
		arg1_210.ladyHeadIKComp.HeadWeight = arg2_210[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_212, arg1_212)
	arg1_212.ladyHeadIKComp.AimTarget = arg0_212.mainCameraTF:Find("AimTarget")
	arg1_212.ladyHeadIKComp.HeadWeight = arg1_212.ladyHeadIKData.HeadWeight
	arg1_212.ladyHeadIKComp.BodyWeight = arg1_212.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_213, arg1_213)
	local function var0_213(arg0_214)
		arg0_214:HideCharacterBylayer()
	end

	for iter0_213, iter1_213 in pairs(arg0_213.ladyDict) do
		if iter0_213 ~= arg1_213 then
			var0_213(iter1_213)
		end
	end
end

function var0_0.RevertCharacter(arg0_215, arg1_215)
	local function var0_215(arg0_216)
		arg0_216:RevertCharacterBylayer()
	end

	for iter0_215, iter1_215 in pairs(arg0_215.ladyDict) do
		if iter0_215 ~= arg1_215 then
			var0_215(iter1_215)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_217)
	local var0_217 = "Bip001"
	local var1_217 = arg0_217.lady:Find("all")

	for iter0_217 = 0, var1_217.childCount - 1 do
		local var2_217 = var1_217:GetChild(iter0_217)

		if var2_217.name ~= var0_217 then
			pg.ViewUtils.SetLayer(var2_217, Layer.Environment3D)
		end
	end

	if arg0_217.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_217.tfPendintItem, Layer.Environment3D)
	end

	if arg0_217.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_217.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg0_217.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_218)
	local var0_218 = "Bip001"
	local var1_218 = arg0_218.lady:Find("all")

	for iter0_218 = 0, var1_218.childCount - 1 do
		local var2_218 = var1_218:GetChild(iter0_218)

		if var2_218.name ~= var0_218 then
			pg.ViewUtils.SetLayer(var2_218, Layer.Default)
		end
	end

	if arg0_218.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_218.tfPendintItem, Layer.Default)
	end

	if arg0_218.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_218.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg0_218.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_219)
	arg0_219:SetAllBlackbloardValue("inLockLayer", true)
	arg0_219:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_220)
	arg0_220:HideFurnitureSlots()

	local var0_220 = arg0_220.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_221)
			arg0_220:emit(var0_0.SHOW_BLOCK)
			arg0_220:ShowBlackScreen(true, arg0_221)
		end,
		function(arg0_222)
			arg0_220:RevertCharacter()
			arg0_220:SetAllBlackbloardValue("inLockLayer", false)
			arg0_220:RegisterCameraBlendFinished(var0_220, arg0_222)
			arg0_220:ActiveCamera(var0_220)
		end,
		function(arg0_223)
			arg0_220:ShowBlackScreen(false, arg0_223)
		end
	}, function()
		arg0_220:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_220:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_225, arg1_225)
	local var0_225 = arg0_225:GetFurnitureByName(arg1_225:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_225.cameraFurnitureWatch and arg0_225.cameraFurnitureWatch ~= var0_225 then
		arg0_225:UnRegisterCameraBlendFinished(arg0_225.cameraFurnitureWatch)
		setActive(arg0_225.cameraFurnitureWatch, false)
	end

	arg0_225.cameraFurnitureWatch = var0_225
	arg0_225.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_225.cameraFurnitureWatch

	arg0_225:RegisterCameraBlendFinished(arg0_225.cameraFurnitureWatch, function()
		arg0_225:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_225:emit(var0_0.SHOW_BLOCK)
	arg0_225:ActiveCamera(arg0_225.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_227)
	if arg0_227.displaySlots then
		arg0_227:UpdateDisplaySlots({})
		table.Foreach(arg0_227.displaySlots, function(arg0_228, arg1_228)
			local var0_228 = arg1_228.trans

			if IsNil(var0_228:Find("Selector")) then
				return
			end

			setActive(var0_228:Find("Selector"), false)
		end)

		arg0_227.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_229, arg1_229)
	arg0_229:HideFurnitureSlots()

	arg0_229.displaySlots = {}

	_.each(arg1_229, function(arg0_230)
		arg0_229.displaySlots[arg0_230] = arg0_229.slotDict[arg0_230]

		if not arg0_229.displaySlots[arg0_230] then
			errorMsg("Slot " .. arg0_230 .. " Not Binding Scene Object")

			return
		end

		local var0_230 = arg0_229.displaySlots[arg0_230].trans

		if var0_230:Find("Selector") then
			setActive(var0_230:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_231, arg1_231)
	table.Foreach(arg0_231.displaySlots, function(arg0_232, arg1_232)
		local var0_232 = arg1_232.trans

		if not IsNil(var0_232:Find("Selector")) then
			setActive(var0_232:Find("Selector/Normal"), arg1_231[arg0_232] == 0)
			setActive(var0_232:Find("Selector/Active"), arg1_231[arg0_232] == 1)
			setActive(var0_232:Find("Selector/Ban"), arg1_231[arg0_232] == 2)
		end

		local var1_232 = arg0_231.slotDict[arg0_232].model
		local var2_232 = arg0_231.slotDict[arg0_232].displayModelName

		if var2_232 and var2_232 ~= "" then
			var1_232 = var0_232:GetChild(var0_232.childCount - 1)
		end

		local function var3_232(arg0_233, arg1_233)
			local var0_233 = arg0_233:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_233, function(arg0_234, arg1_234)
				local var0_234 = arg1_234.material

				if var0_234 and var0_234:HasProperty("_FinalTint") then
					var0_234:SetColor("_FinalTint", arg1_233)
				end
			end)
		end

		if var1_232 then
			if arg1_231[arg0_232] == 1 then
				var3_232(var1_232, Color.NewHex("3F83AE73"))
			else
				var3_232(var1_232, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_235, arg1_235, arg2_235)
	arg0_235:SetAllBlackbloardValue("inLockLayer", true)
	arg0_235:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_236)
			arg0_235:TempHideUI(true, arg0_236)
		end,
		function(arg0_237)
			arg0_235:ShowBlackScreen(true, arg0_237)
		end,
		function(arg0_238)
			local var0_238 = arg0_235.ladyDict[arg0_235.apartment:GetConfigID()]

			arg0_235:SwitchAnim(arg2_235)
			var0_238.ladyAnimator:Update(0)
			var0_238:ResetCharPoint(arg1_235:GetWatchCameraName())
			arg0_235:SyncInterestTransform(var0_238)
			setActive(var0_238.ladySafeCollider, true)

			local var1_238 = arg0_235.cameras[var0_0.CAMERA.PHOTO]
			local var2_238 = var1_238.m_XAxis

			var2_238.Value = 180
			var1_238.m_XAxis = var2_238

			local var3_238 = var1_238.m_YAxis

			var3_238.Value = 0.7
			var1_238.m_YAxis = var3_238
			arg0_235.pinchValue = 1

			arg0_235:RegisterOrbits(arg0_235.cameras[var0_0.CAMERA.PHOTO])
			arg0_235:SetCameraObrits()
			arg0_235:RegisterCameraBlendFinished(var1_238, arg0_238)
			arg0_235:ActiveCamera(var1_238)
		end,
		function(arg0_239)
			arg0_235:ShowBlackScreen(false, arg0_239)
		end
	}, function()
		arg0_235:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_241)
	arg0_241:emit(var0_0.SHOW_BLOCK)
	arg0_241:EnableJoystick(false)
	seriesAsync({
		function(arg0_242)
			arg0_241:ShowBlackScreen(true, arg0_242)
		end,
		function(arg0_243)
			arg0_241:RevertCameraOrbit()

			local var0_243 = arg0_241.ladyDict[arg0_241.apartment:GetConfigID()]

			arg0_241:SwitchAnim(var0_0.ANIM.IDLE)
			setActive(var0_243.ladySafeCollider, false)
			onNextTick(function()
				arg0_241:ChangeCharacterPosition()
			end)

			if arg0_241.contextData.photoFreeMode then
				arg0_241:EnablePOVLayer(false)
				setActive(arg0_241.restrictedBox, false)

				arg0_241.contextData.photoFreeMode = nil
			end

			local var1_243 = arg0_241.cameras[var0_0.CAMERA.POV]

			arg0_241:RegisterCameraBlendFinished(var1_243, arg0_243)
			arg0_241:ActiveCamera(var1_243)
		end,
		function(arg0_245)
			arg0_241:ShowBlackScreen(false, arg0_245)
		end
	}, function()
		arg0_241:RefreshSlots()
		arg0_241:SetAllBlackbloardValue("inLockLayer", false)
		arg0_241:emit(var0_0.HIDE_BLOCK)
		arg0_241:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_241:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_247, arg1_247, arg2_247, arg3_247)
	arg0_247:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_248)
			arg0_247:ShowBlackScreen(true, arg0_248)
		end,
		function(arg0_249)
			arg0_247:SwitchAnim(arg2_247)
			onNextTick(function()
				arg0_247:ResetCharPoint(arg1_247:GetWatchCameraName())
				arg0_247:SyncInterestTransform(arg0_247)

				if arg0_247.contextData.photoFreeMode then
					arg0_247.camBrain.enabled = false

					arg0_247:SwitchPhotoCamera()

					arg0_247.camBrain.enabled = true

					onDelayTick(function()
						arg0_247.camBrain.enabled = false

						arg0_247:SwitchPhotoCamera()

						arg0_247.camBrain.enabled = true
					end, 0.1)
				end

				arg0_249()
			end)
		end,
		function(arg0_252)
			arg0_247:ShowBlackScreen(false, arg0_252)
		end
	}, function()
		arg0_247:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_247)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_254)
	if not arg0_254.contextData.photoFreeMode then
		arg0_254:EnableJoystick(false)
		arg0_254:EnablePOVLayer(true)
		setActive(arg0_254.restrictedBox, true)

		local var0_254 = arg0_254.cameras[var0_0.CAMERA.PHOTO_FREE]

		var0_254.transform.position = arg0_254.mainCameraTF.position

		local var1_254 = arg0_254.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_254 = arg0_254.mainCameraTF.rotation:ToEulerAngles()
		local var3_254 = var1_254.m_HorizontalAxis

		var3_254.Value = var2_254.y
		var1_254.m_HorizontalAxis = var3_254

		local var4_254 = var1_254.m_VerticalAxis

		var4_254.Value = arg0_254:GetNearestAngle(var2_254.x, var4_254.m_MinValue, var4_254.m_MaxValue)
		var1_254.m_VerticalAxis = var4_254

		local var5_254 = math.InverseLerp(arg0_254.restrictedHeightRange[1], arg0_254.restrictedHeightRange[2], var0_254.position.y)

		arg0_254:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var5_254)
		arg0_254:ActiveCamera(arg0_254.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_254:EnableJoystick(true)
		arg0_254:EnablePOVLayer(false)
		setActive(arg0_254.restrictedBox, false)
		arg0_254:ActiveCamera(arg0_254.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_254.contextData.photoFreeMode = not arg0_254.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_255, arg1_255)
	local var0_255 = math.lerp(arg0_255.restrictedHeightRange[1], arg0_255.restrictedHeightRange[2], arg1_255)
	local var1_255 = arg0_255.cameras[var0_0.CAMERA.PHOTO_FREE]

	var1_255:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var0_255 - var1_255.position.y, 0))
	onNextTick(function()
		local var0_256 = math.InverseLerp(arg0_255.restrictedHeightRange[1], arg0_255.restrictedHeightRange[2], var1_255.position.y)

		arg0_255:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var0_256)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_257)
	local var0_257 = arg0_257.cameras[var0_0.CAMERA.PHOTO]
	local var1_257 = var0_257.m_XAxis

	var1_257.Value = 180
	var0_257.m_XAxis = var1_257

	local var2_257 = var0_257.m_YAxis

	var2_257.Value = 0.7
	var0_257.m_YAxis = var2_257
end

function var0_0.ResetCharPoint(arg0_258, arg1_258)
	local var0_258 = arg0_258.furnitures:Find(arg1_258 .. "/StayPoint")

	arg0_258.lady.position = var0_258.position
	arg0_258.lady.rotation = var0_258.rotation
end

function var0_0.GetNearestAngle(arg0_259, arg1_259, arg2_259, arg3_259)
	if arg3_259 < arg2_259 then
		arg3_259 = arg3_259 + 360
	end

	if arg2_259 <= arg1_259 and arg1_259 <= arg3_259 then
		return arg1_259
	end

	local var0_259 = (arg2_259 + arg3_259) / 2

	arg1_259 = var0_259 - Mathf.DeltaAngle(arg1_259, var0_259)
	arg1_259 = math.clamp(arg1_259, arg2_259, arg3_259)

	return arg1_259
end

function var0_0.PlayTimeline(arg0_260, arg1_260, arg2_260)
	local var0_260 = {}

	if arg0_260.waitForTimeline then
		table.insert(var0_260, function(arg0_261)
			local var0_261 = arg0_260.waitForTimeline

			arg0_260.waitForTimeline = nil

			var0_261()
			arg0_261()
		end)
	end

	table.insert(var0_260, function(arg0_262)
		arg0_260:LoadTimelineScene(arg1_260.name, false, arg0_262)
	end)

	if arg1_260.scene and arg1_260.sceneRoot then
		table.insert(var0_260, function(arg0_263)
			arg0_260:ChangeArtScene(arg1_260.scene .. "|" .. arg1_260.sceneRoot, arg0_263)
		end)
	end

	table.insert(var0_260, function(arg0_264)
		local var0_264 = GameObject.Find("[sequence]").transform
		local var1_264 = var0_264:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if GetComponent(var1_264, "TimelineSpeed") then
			setDirectorSpeed(var1_264, 1)
		else
			GetOrAddComponent(var0_264, "TimelineSpeed")
		end

		local var2_264 = GameObject.Find("[actor]").transform
		local var3_264 = var2_264:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var3_264, function(arg0_265, arg1_265)
			GetOrAddComponent(arg1_265.transform, typeof(DftAniEvent))
		end)
		table.IpairsCArray(var2_264:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_266, arg1_266)
			arg1_266.enabled, arg1_266.enabled = arg1_266.enabled, false
		end)
		var1_264:Stop()

		var1_264.extrapolationMode = ReflectionHelp.RefGetField(typeof("UnityEngine.Playables.DirectorWrapMode"), "Hold", nil)

		if arg1_260.time then
			var1_264.time = math.clamp(arg1_260.time, 0, var1_264.duration)
		end

		local var4_264 = {}

		local function var5_264(arg0_267)
			switch(arg0_267.stringParameter, {
				TimelinePause = function()
					setDirectorSpeed(var1_264, 0)
				end,
				TimelineResume = function()
					arg0_260.timelineSpeed = 1

					setDirectorSpeed(var1_264, 1)
				end,
				TimelinePlayOnTime = function()
					if arg0_267.intParameter == 0 or arg0_267.intParameter == var4_264.selectIndex then
						var1_264.time = arg0_267.floatParameter

						var1_264:RebuildGraph()
					end
				end,
				TimelineSelectStart = function()
					var4_264.selectIndex = nil

					if arg1_260.options then
						local var0_271 = arg1_260.options[arg0_267.intParameter]

						arg0_260:DoTimelineOption(var0_271, function(arg0_272)
							var4_264.selectIndex = arg0_272
							var4_264.optionIndex = var0_271[arg0_272].flag
						end)
					end
				end,
				TimelineTouchStart = function()
					var4_264.selectIndex = nil

					if arg1_260.touchs then
						local var0_273 = arg1_260.touchs[arg0_267.intParameter]

						arg0_260:DoTimelineTouch(arg1_260.touchs[arg0_267.intParameter], function(arg0_274)
							var4_264.selectIndex = arg0_274
							var4_264.optionIndex = var0_273[arg0_274].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not var4_264.selectIndex then
						var1_264.time = arg0_267.floatParameter

						var1_264:RebuildGraph()
					end
				end,
				TimelineAccompanyJump = function()
					if arg0_260.canTriggerAccompanyPerformance then
						arg0_260.canTriggerAccompanyPerformance = false

						local var0_276 = arg1_260.accompanys[arg0_267.intParameter]
						local var1_276 = var0_276[math.random(#var0_276)]

						var1_264.time = var1_276

						var1_264:RebuildGraph()
					end
				end,
				TimelineEnd = function()
					var4_264.finish = true

					setDirectorSpeed(var1_264, 0)
				end
			}, function()
				warning("other event trigger:" .. arg0_267.stringParameter)
			end)

			if var4_264.finish then
				arg0_260.timelineMark = var4_264
				arg0_260.timelineFinishCall = nil

				arg0_264()
			end
		end

		GetOrAddComponent(var0_264, "DftCommonSignalReceiver"):SetCommonEvent(var5_264)

		function arg0_260.timelineFinishCall()
			var5_264({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_260:HideCharacter()
		setActive(arg0_260.mainCameraTF, false)
		eachChild(arg0_260.rtTimelineScreen, function(arg0_280)
			setActive(arg0_280, false)
		end)
		setActive(arg0_260.rtTimelineScreen, true)
		setActive(arg0_260.rtTimelineScreen:Find("btn_skip"), arg0_260.inReplayTalk)
		var1_264:Play()
		var1_264:Evaluate()
	end)
	table.insert(var0_260, function(arg0_281)
		arg0_260:ShowBlackScreen(true, function()
			arg0_260:UnloadTimelineScene(arg1_260.name, false, arg0_281)
		end)
	end)

	local var1_260 = arg0_260.artSceneInfo

	table.insert(var0_260, function(arg0_283)
		arg0_260:ChangeArtScene(var1_260, arg0_283)
	end)
	seriesAsync(var0_260, function()
		setActive(arg0_260.rtTimelineScreen, false)
		arg0_260:RevertCharacter()
		setActive(arg0_260.mainCameraTF, true)

		local var0_284 = arg0_260.timelineMark

		arg0_260.timelineMark = nil

		existCall(arg2_260, var0_284, function(arg0_285)
			arg0_260:ShowBlackScreen(false, arg0_285)
		end)
	end)
end

function var0_0.PlaySingleAction(arg0_286, arg1_286, arg2_286)
	local var0_286 = arg0_286
	local var1_286 = string.find(arg1_286, "^Face_")

	if tobool(var1_286) then
		arg0_286:PlayFaceAnim(arg1_286, arg2_286)

		return
	end

	if var0_286.ladyAnimator:GetCurrentAnimatorStateInfo(var0_286.ladyAnimBaseLayerIndex):IsName(arg1_286) then
		return
	end

	existCall(var0_286.animExtraItemCallback)

	var0_286.animExtraItemCallback = nil
	var0_286.animNameMap = var0_286.animNameMap or {}
	var0_286.animNameMap[var0_286.ladyAnimator.StringToHash(arg1_286)] = arg1_286

	local var2_286 = var0_286:GetBlackboardValue("groupId")
	local var3_286 = _.detect(pg.dorm3d_anim_extraitem.get_id_list_by_ship_id[var2_286] or {}, function(arg0_287)
		return pg.dorm3d_anim_extraitem[arg0_287].anim == arg1_286
	end)
	local var4_286 = var3_286 and pg.dorm3d_anim_extraitem[var3_286]
	local var5_286

	seriesAsync({
		function(arg0_288)
			if not var4_286 or var4_286.item_prefab == "" then
				arg0_288()

				return
			end

			local var0_288 = string.lower("dorm3d/furniture/item/" .. var4_286.item_prefab)

			arg0_286.loader:GetPrefab(var0_288, "", function(arg0_289)
				setParent(arg0_289, var0_286.lady)

				if var4_286.item_shield ~= "" then
					var5_286 = {}

					for iter0_289, iter1_289 in ipairs(var4_286.item_shield) do
						local var0_289 = arg0_286.modelRoot:Find(iter1_289)

						if not var0_289 then
							warning(string.format("dorm3d_anim_extraitem:%d without hide item:%s", var4_286.id, iter1_289))
						else
							var5_286[iter1_289] = isActive(var0_289)

							setActive(var0_289, false)
						end
					end
				end

				function arg0_286.animExtraItemCallback()
					arg0_286.loader:ClearRequest("AnimExtraItem")

					if var5_286 then
						for iter0_290, iter1_290 in pairs(var5_286) do
							setActive(arg0_286.modelRoot:Find(iter0_290), iter1_290)
						end
					end
				end

				arg0_288()
			end, "AnimExtraItem")
		end,
		function(arg0_291)
			var0_286.nowState = arg1_286
			var0_286.stateCallback = arg0_291

			var0_286.ladyAnimator:CrossFadeInFixedTime(arg1_286, 0.25, var0_286.ladyAnimBaseLayerIndex)
		end,
		function(arg0_292)
			var0_286.nowState = nil
			var0_286.stateCallback = nil

			existCall(arg0_286.animExtraItemCallback)

			arg0_286.animExtraItemCallback = nil

			arg0_292()
		end,
		arg2_286
	})
end

function var0_0.SwitchAnim(arg0_293, arg1_293, arg2_293)
	local var0_293 = arg0_293
	local var1_293 = string.find(arg1_293, "^Face_")

	if tobool(var1_293) then
		arg0_293:PlayFaceAnim(arg1_293, arg2_293)

		return
	end

	existCall(var0_293.animExtraItemCallback)

	var0_293.animExtraItemCallback = nil
	arg0_293.animNameMap = arg0_293.animNameMap or {}
	arg0_293.animNameMap[arg0_293.ladyAnimator.StringToHash(arg1_293)] = arg1_293

	local var2_293 = {}

	table.insert(var2_293, function(arg0_294)
		arg0_293.nowState = arg1_293
		arg0_293.stateCallback = arg0_294

		arg0_293.ladyAnimator:PlayInFixedTime(arg1_293, arg0_293.ladyAnimBaseLayerIndex)
	end)
	table.insert(var2_293, function(arg0_295)
		arg0_293.nowState = nil
		arg0_293.stateCallback = nil

		arg0_295()
	end)
	seriesAsync(var2_293, arg2_293)
end

function var0_0.PlayFaceAnim(arg0_296, arg1_296, arg2_296)
	arg0_296.ladyAnimator:CrossFadeInFixedTime(arg1_296, 0.2, arg0_296.ladyAnimFaceLayerIndex)
	existCall(arg2_296)
end

function var0_0.GetCurrentAnim(arg0_297)
	local var0_297 = arg0_297.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_297.ladyAnimBaseLayerIndex).shortNameHash

	return arg0_297.animNameMap[var0_297]
end

function var0_0.RegisterAnimCallback(arg0_298, arg1_298, arg2_298)
	arg0_298.animCallbacks[arg1_298] = arg2_298
end

function var0_0.SetCharacterAnimSpeed(arg0_299, arg1_299)
	arg0_299.ladyAnimator.speed = arg1_299
	arg0_299.ladyHeadIKComp.blinkSpeed = arg0_299.ladyHeadIKData.blinkSpeed * arg1_299

	if arg1_299 > 0 then
		arg0_299.ladyHeadIKComp.DampTime = arg0_299.ladyHeadIKData.DampTime / arg1_299
	else
		arg0_299.ladyHeadIKComp.DampTime = arg0_299.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_300, arg1_300)
	if arg1_300.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_300 = arg1_300.stringParameter
	local var1_300 = table.removebykey(arg0_300.animEventCallbacks, var0_300)

	existCall(var1_300)
end

function var0_0.RegisterAnimEventCallback(arg0_301, arg1_301, arg2_301)
	arg0_301.animEventCallbacks[arg1_301] = arg2_301
end

function var0_0.PlaySceneItemAnim(arg0_302, arg1_302, arg2_302)
	arg0_302.sceneAnimatorDict = arg0_302.sceneAnimatorDict or {}

	if not arg0_302.sceneAnimatorDict[arg1_302] then
		local var0_302 = pg.dorm3d_scene_animator[arg1_302]
		local var1_302 = arg0_302:GetSceneItem(var0_302.item_name)

		assert(var1_302, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_302 .. " " .. var0_302.item_name)

		if not var1_302 then
			return
		end

		local var2_302 = var1_302:GetComponent(typeof(Animator))

		if not var2_302 then
			return
		end

		arg0_302.sceneAnimatorDict[arg1_302] = {
			trans = var1_302,
			animator = var2_302
		}
	end

	if arg0_302.sceneAnimatorDict[arg1_302].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_302) then
		return
	end

	arg0_302.sceneAnimatorDict[arg1_302].animator:PlayInFixedTime(arg2_302)
end

function var0_0.ResetSceneItemAnimators(arg0_303, arg1_303)
	if not arg0_303.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_303.sceneAnimatorDict, function(arg0_304, arg1_304)
		if arg1_303 and table.contains(arg1_303, arg0_304) then
			return
		end

		setActive(arg1_304.trans, false)
		setActive(arg1_304.trans, true)

		arg0_303.sceneAnimatorDict[arg0_304] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_305, arg1_305, arg2_305)
	arg0_305.cameraBlendCallbacks[arg1_305] = arg2_305
end

function var0_0.UnRegisterCameraBlendFinished(arg0_306, arg1_306)
	arg0_306.cameraBlendCallbacks[arg1_306] = nil
end

function var0_0.OnCameraBlendFinished(arg0_307, arg1_307)
	if not arg1_307 then
		return
	end

	local var0_307 = table.removebykey(arg0_307.cameraBlendCallbacks, arg1_307)

	existCall(var0_307)
end

function var0_0.PlayHeartFX(arg0_308, arg1_308)
	local var0_308 = arg0_308.ladyDict[arg1_308]

	setActive(var0_308.effectHeart, false)
	setActive(var0_308.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_309, arg1_309)
	local var0_309 = arg1_309.name
	local var1_309 = arg0_309.expressionDict[var0_309]
	local var2_309 = 5

	if var1_309 then
		local var3_309 = var1_309.timer

		var3_309:Reset(nil, var2_309)
		var3_309:Start()

		if var1_309.instance then
			setActive(var1_309.instance, false)
			setActive(var1_309.instance, true)
		end

		return
	end

	local var4_309 = {
		name = var0_309,
		timer = Timer.New(function()
			arg0_309:RemoveExpression(var0_309)
		end, var2_309, 1, true)
	}

	arg0_309.expressionDict[var0_309] = var4_309

	arg0_309.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_309, var0_309, function(arg0_311)
		var4_309.instance = arg0_311

		onNextTick(function()
			setParent(arg0_311, arg0_309.ladyHeadCenter)
		end)
		setLocalPosition(arg0_311, Vector3(0, 0, -0.2))
		setActive(arg0_311, false)
		setActive(arg0_311, true)
	end, var4_309)
end

function var0_0.RemoveExpression(arg0_313, arg1_313)
	local var0_313 = arg0_313.expressionDict[arg1_313]

	if not var0_313 then
		return
	end

	arg0_313.loader:ClearRequest(var0_313)

	if var0_313.instance then
		arg0_313.loader:ReturnPrefab(var0_313.instance)
	end

	arg0_313.expressionDict[arg1_313] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_314, arg1_314)
	arg0_314.ladyWatchFloat = arg0_314.ladyWatchFloat or cloneTplTo(arg0_314.resTF:Find("vfx_talk_mark"), arg0_314.ladyHeadCenter)

	setActive(arg0_314.ladyWatchFloat, arg1_314)
end

function var0_0.RegisterGlobalVolume(arg0_315)
	local var0_315 = arg0_315.globalVolume
	local var1_315 = LuaHelper.GetOrAddVolumeComponent(var0_315, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_315 = LuaHelper.GetOrAddVolumeComponent(var0_315, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_315.originalCameraSettings = {
		depthOfField = {
			enabled = var1_315.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_315.gaussianStart.min,
				value = var1_315.gaussianStart.value
			},
			blurRadius = {
				min = var1_315.blurRadius.min,
				max = var1_315.blurRadius.max,
				value = var1_315.blurRadius.value
			}
		},
		postExposure = {
			value = var2_315.postExposure.value
		},
		contrast = {
			min = var2_315.contrast.min,
			max = var2_315.contrast.max,
			value = var2_315.contrast.value
		},
		saturate = {
			min = var2_315.saturation.min,
			max = var2_315.saturation.max,
			value = var2_315.saturation.value
		}
	}
	arg0_315.originalCameraSettings.depthOfField.enabled = true

	local var3_315 = var0_315:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_315.originalVolume = {
		profile = var3_315.sharedProfile,
		weight = var3_315.weight
	}
end

function var0_0.SettingCamera(arg0_316, arg1_316)
	arg0_316.activeCameraSettings = arg1_316

	local var0_316 = arg0_316.globalVolume
	local var1_316 = LuaHelper.GetOrAddVolumeComponent(var0_316, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_316 = LuaHelper.GetOrAddVolumeComponent(var0_316, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_316.enabled:Override(arg1_316.depthOfField.enabled)
	var1_316.gaussianStart:Override(arg1_316.depthOfField.focusDistance.value)
	var1_316.gaussianEnd:Override(arg1_316.depthOfField.focusDistance.value + arg1_316.depthOfField.focusDistance.length)
	var1_316.blurRadius:Override(arg1_316.depthOfField.blurRadius.value)
	var2_316.postExposure:Override(arg1_316.postExposure.value)
	var2_316.contrast:Override(arg1_316.contrast.value)
	var2_316.saturation:Override(arg1_316.saturate.value)
end

function var0_0.GetCameraSettings(arg0_317)
	return arg0_317.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_318)
	arg0_318:SettingCamera(arg0_318.originalCameraSettings)

	arg0_318.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_319, arg1_319, arg2_319)
	local var0_319 = arg0_319.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_319.activeProfileWeight = arg2_319

	if arg0_319.activeProfileName ~= arg1_319 then
		arg0_319.activeProfileName = arg1_319

		arg0_319.loader:LoadReference("dorm3d/scenesres/res/common", arg1_319, nil, function(arg0_320)
			var0_319.profile = arg0_320
			var0_319.weight = arg0_319.activeProfileWeight

			if arg0_319.activeCameraSettings then
				arg0_319:SettingCamera(arg0_319.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_319.weight = arg0_319.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_321)
	local var0_321 = arg0_321.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_321.profile = arg0_321.originalVolume.profile
	var0_321.weight = arg0_321.originalVolume.weight

	if arg0_321.activeCameraSettings then
		arg0_321:SettingCamera(arg0_321.activeCameraSettings)
	end

	arg0_321.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_322)
	local var0_322 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_322.originalCharacterColor = {
		color = var0_322.color,
		intensity = var0_322.intensity
	}
end

function var0_0.SetCharacterLight(arg0_323, arg1_323, arg2_323, arg3_323)
	local var0_323 = arg0_323.characterLight:GetComponent(typeof(Light))
	local var1_323 = Color.Lerp(arg0_323.originalCharacterColor.color, arg1_323, arg3_323)
	local var2_323 = math.lerp(arg0_323.originalCharacterColor.intensity, arg2_323, arg3_323)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_323, var2_323)
end

function var0_0.RevertCharacterLight(arg0_324)
	arg0_324:SetCharacterLight(arg0_324.originalCharacterColor.color, arg0_324.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_325, arg1_325, arg2_325)
	arg1_325 = arg1_325 or {}

	table.Foreach(arg0_325.clothComps, function(arg0_326, arg1_326)
		if arg1_326 == nil then
			return
		end

		setActive(arg1_326, arg1_325[arg0_326] == 1)
	end)
	table.Foreach(arg0_325.clothColliderDict, function(arg0_327, arg1_327)
		if arg1_327 == nil then
			return
		end

		setActive(arg1_327, false)
	end)

	if arg2_325 then
		table.Foreach(arg2_325, function(arg0_328, arg1_328)
			local var0_328 = arg0_325.clothColliderDict[arg1_328[1]]

			if var0_328 == nil then
				return
			end

			setActive(var0_328, arg1_328[2] == 1)

			if arg1_328[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_328, arg1_328[3], arg1_328[4])
		end)
	end
end

function var0_0.RevertClothComps(arg0_329, arg1_329)
	table.Foreach(arg1_329.ladyClothCompSettings, function(arg0_330, arg1_330)
		arg0_330.enabled = arg1_330.enabled
	end)
	table.Foreach(arg1_329.ladyClothColliderSettings, function(arg0_331, arg1_331)
		arg0_331.enabled = arg1_331.enabled

		var0_0.SetMagicaCollider(arg0_331, arg1_331.StartRadius, arg1_331.EndRadius)
	end)
end

function var0_0.onBackPressed(arg0_332)
	if arg0_332.exited or arg0_332.retainCount > 0 then
		-- block empty
	else
		arg0_332:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_333, arg1_333, arg2_333)
	assert(tobool(arg0_333.lastSceneRootDict[arg1_333]) == arg2_333)

	if arg2_333 then
		table.Foreach(arg0_333.lastSceneRootDict[arg1_333], function(arg0_334, arg1_334)
			if IsNil(arg0_334) then
				return
			end

			setActive(arg0_334, arg1_334)
		end)

		arg0_333.lastSceneRootDict[arg1_333] = nil
	else
		arg0_333.lastSceneRootDict[arg1_333] = {}

		local var0_333 = SceneManager.GetSceneByName(arg1_333)

		table.IpairsCArray(var0_333:GetRootGameObjects(), function(arg0_335, arg1_335)
			if tostring(arg1_335.hideFlags) ~= "None" then
				return
			end

			arg0_333.lastSceneRootDict[arg1_333][arg1_335] = isActive(arg1_335)

			setActive(arg1_335, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_336, arg1_336, arg2_336)
	arg1_336 = string.lower(arg1_336)

	if arg1_336 == arg0_336.artSceneInfo then
		if arg1_336 == arg0_336.sceneInfo then
			arg0_336:SwitchDayNight(arg0_336.contextData.timeIndex)
			onNextTick(function()
				arg0_336:RefreshSlots()
				existCall(arg2_336)
			end)
		else
			existCall(arg2_336)
		end

		return
	end

	local var0_336 = {}
	local var1_336 = false
	local var2_336

	table.insert(var0_336, function(arg0_338)
		arg0_336.artSceneInfo = arg1_336

		if var1_336 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_339)
				var2_336 = arg0_339

				arg0_338()
			end)
		else
			arg0_338()
		end
	end)

	if arg1_336 == arg0_336.sceneInfo then
		table.insert(var0_336, function(arg0_340)
			setActive(arg0_336.slotRoot, true)

			local var0_340, var1_340 = unpack(string.split(arg0_336.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_340))
			arg0_336:EnableSceneDisplay(var0_340, true)
			arg0_336:SwitchDayNight(arg0_336.contextData.timeIndex)
			onNextTick(function()
				arg0_336:RefreshSlots()
			end)
			arg0_340()
		end)
	else
		var1_336 = true

		local var3_336, var4_336 = unpack(string.split(arg1_336, "|"))

		table.insert(var0_336, function(arg0_342)
			setActive(arg0_336.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_336 .. "/" .. var3_336 .. "_scene"), var3_336, LoadSceneMode.Additive, function(arg0_343, arg1_343)
				SceneManager.SetActiveScene(arg0_343)

				local var0_343 = getSceneRootTFDic(arg0_343).MainCamera

				if var0_343 then
					setActive(var0_343, false)
				end

				arg0_342()
			end)
		end)
	end

	if arg0_336.artSceneInfo == arg0_336.sceneInfo then
		table.insert(var0_336, function(arg0_344)
			local var0_344, var1_344 = unpack(string.split(arg0_336.sceneInfo, "|"))

			arg0_336:EnableSceneDisplay(var0_344, false)
			arg0_344()
		end)
	else
		local var5_336, var6_336 = unpack(string.split(arg0_336.artSceneInfo, "|"))

		table.insert(var0_336, function(arg0_345)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_336 .. "/" .. var5_336 .. "_scene"), var5_336, arg0_345)
		end)
	end

	table.insert(var0_336, function(arg0_346)
		arg0_346()

		if var1_336 then
			var2_336()
		end
	end)
	seriesAsync(var0_336, arg2_336)
end

function var0_0.LoadTimelineScene(arg0_347, arg1_347, arg2_347, arg3_347)
	arg1_347 = string.lower(arg1_347)

	if arg0_347.cacheSceneDic[arg1_347] then
		if not arg2_347 then
			arg0_347.timelineScene = arg1_347

			arg0_347:EnableSceneDisplay(arg1_347, true)
		end

		return existCall(arg3_347)
	end

	local var0_347 = {}
	local var1_347

	table.insert(var0_347, function(arg0_348)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_349)
			if arg0_347.waitForTimeline then
				arg0_347.waitForTimeline = arg0_349
				var1_347 = nil
			else
				var1_347 = arg0_349
			end

			arg0_348()
		end)
	end)
	table.insert(var0_347, function(arg0_350)
		local var0_350 = arg0_347.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_350 .. "/timeline/" .. arg1_347 .. "/" .. arg1_347 .. "_scene"), arg1_347, LoadSceneMode.Additive, function(arg0_351, arg1_351)
			local var0_351 = GameObject.Find("[actor]").transform

			arg0_347:HXCharacter(tf(var0_351))

			local var1_351 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_351:Stop()
			TimelineSupport.InitTimeline(var1_351)
			TimelineSupport.InitSubtitle(var1_351, arg0_347.apartment:GetCallName())

			arg0_347.unloadDirector = var1_351

			arg0_350()
		end)
	end)
	table.insert(var0_347, function(arg0_352)
		arg0_347.sceneGroupDic[arg1_347] = arg0_347.apartment:GetConfigID()

		if arg2_347 then
			arg0_347.cacheSceneDic[arg1_347] = true

			arg0_347:EnableSceneDisplay(arg1_347, false)
		else
			arg0_347.timelineScene = arg1_347
		end

		arg0_352()
		existCall(var1_347)
	end)
	seriesAsync(var0_347, arg3_347)
end

function var0_0.UnloadTimelineScene(arg0_353, arg1_353, arg2_353, arg3_353)
	arg1_353 = string.lower(arg1_353)

	if arg0_353.timelineScene == arg1_353 then
		arg0_353.timelineScene = nil
	end

	if tobool(arg2_353) == tobool(arg0_353.cacheSceneDic[arg1_353]) then
		local var0_353 = getProxy(ApartmentProxy):getApartment(arg0_353.sceneGroupDic[arg1_353]):getConfig("asset_name")

		if arg0_353.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_353.unloadDirector)

			arg0_353.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_353 .. "/timeline/" .. arg1_353 .. "/" .. arg1_353 .. "_scene"), arg1_353, function()
			arg0_353.cacheSceneDic[arg1_353] = nil
			arg0_353.sceneGroupDic[arg1_353] = nil
			arg0_353.lastSceneRootDict[arg1_353] = nil

			existCall(arg3_353)
		end)
	else
		arg0_353:EnableSceneDisplay(arg1_353, false)
		existCall(arg3_353)
	end
end

function var0_0.ChangeSubScene(arg0_355, arg1_355, arg2_355)
	arg1_355 = string.lower(arg1_355)

	warning(arg0_355.subSceneInfo, "->", arg1_355, arg1_355 == arg0_355.subSceneInfo)

	if arg1_355 == arg0_355.subSceneInfo then
		arg0_355.ladyActiveZone = arg0_355.walkBornPoint or arg0_355.ladyBaseZone

		arg0_355:ChangeCharacterPosition()
		arg0_355:ChangePlayerPosition(arg0_355.ladyActiveZone)
		arg0_355:TriggerLadyDistance()
		arg0_355:CheckInSector()
		existCall(arg2_355)

		return
	end

	local var0_355 = {}
	local var1_355 = false
	local var2_355

	table.insert(var0_355, function(arg0_356)
		arg0_355.subSceneInfo = arg1_355

		if var1_355 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_357)
				var2_355 = arg0_357

				arg0_356()
			end)
		else
			arg0_356()
		end
	end)

	if arg1_355 == arg0_355.sceneInfo then
		table.insert(var0_355, function(arg0_358)
			local var0_358, var1_358 = unpack(string.split(arg0_355.sceneInfo, "|"))

			arg0_355:ResetSceneStructure(SceneManager.GetSceneByName(var0_358 .. "_base"))
			arg0_355:RefreshSlots()

			arg0_355.ladyActiveZone = arg0_355.walkBornPoint or arg0_355.ladyBaseZone

			arg0_355:ChangeCharacterPosition()
			arg0_355:ChangePlayerPosition(arg0_355.ladyActiveZone)
			arg0_355:TriggerLadyDistance()
			arg0_355:CheckInSector()
			arg0_358()
		end)
	else
		var1_355 = true

		local var3_355, var4_355 = unpack(string.split(arg1_355, "|"))
		local var5_355 = var3_355 .. "_base"

		table.insert(var0_355, function(arg0_359)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_355 .. "/" .. var5_355 .. "_scene"), var5_355, LoadSceneMode.Additive, arg0_359)
		end)
		table.insert(var0_355, function(arg0_360)
			arg0_355:ResetSceneStructure(SceneManager.GetSceneByName(var5_355))

			arg0_355.ladyActiveZone = arg0_355.walkBornPoint or "Default"

			arg0_355:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_355:ChangeCharacterPosition()
				arg0_355:ChangePlayerPosition(arg0_355.ladyActiveZone)
				arg0_355:TriggerLadyDistance()
				arg0_355:CheckInSector()
				arg0_360()
			end)
		end)
	end

	if arg0_355.subSceneInfo == arg0_355.sceneInfo then
		table.insert(var0_355, function(arg0_362)
			local var0_362 = Clone(arg0_355.room)

			var0_362.furnitures = {}

			arg0_355:RefreshSlots(var0_362)
			arg0_362()
		end)
	else
		local var6_355, var7_355 = unpack(string.split(arg0_355.subSceneInfo, "|"))
		local var8_355 = var6_355 .. "_base"

		table.insert(var0_355, function(arg0_363)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_355 .. "/" .. var8_355 .. "_scene"), var8_355, arg0_363)
		end)
	end

	table.insert(var0_355, function(arg0_364)
		arg0_364()

		if var1_355 then
			var2_355()
		end
	end)
	seriesAsync(var0_355, arg2_355)
end

function var0_0.TransformMesh(arg0_365)
	local var0_365 = arg0_365.sharedMesh
	local var1_365 = {}
	local var2_365 = arg0_365.transform:TransformPoint(var0_365.vertices[0])
	local var3_365 = arg0_365.transform:TransformPoint(var0_365.vertices[1])
	local var4_365 = arg0_365.transform:TransformPoint(var0_365.vertices[2])

	var1_365.horizontal = var3_365 - var2_365
	var1_365.verticle = var4_365 - var2_365
	var1_365.origin = var2_365

	return var1_365
end

function var0_0.GetRatio(arg0_366, arg1_366)
	local var0_366 = Vector2.zero

	var0_366.x = Vector3.Dot(arg0_366.horizontal, arg1_366) / arg0_366.horizontal.sqrMagnitude
	var0_366.y = Vector3.Dot(arg0_366.verticle, arg1_366) / arg0_366.verticle.sqrMagnitude

	return var0_366
end

function var0_0.GetPostionByRatio(arg0_367, arg1_367)
	return arg0_367.horizontal * arg1_367.x + arg0_367.verticle * arg1_367.y + arg0_367.origin
end

function var0_0.IsPointInSector(arg0_368, arg1_368)
	local var0_368 = arg1_368 - Vector3.New(unpack(arg0_368.Position))

	if var0_368.magnitude > arg0_368.Radius then
		return false
	end

	local var1_368 = Quaternion.Euler(unpack(arg0_368.Rotation))

	return Vector3.Angle(var1_368 * Vector3.forward, var0_368) <= arg0_368.Angle / 2
end

function var0_0.willExit(arg0_369)
	arg0_369.joystickTimer:Stop()
	arg0_369.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_369.updateHandler)
	arg0_369:StopIKHandTimer()

	if arg0_369.moveTimer then
		arg0_369.moveTimer:Stop()

		arg0_369.moveTimer = nil
	end

	if arg0_369.moveWaitTimer then
		arg0_369.moveWaitTimer:Stop()

		arg0_369.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_369.furnitures) then
		eachChild(arg0_369.furnitures, function(arg0_370)
			local var0_370 = GetComponent(arg0_370, typeof(EventTriggerListener))

			if not var0_370 then
				return
			end

			var0_370:ClearEvents()
		end)
	end

	for iter0_369, iter1_369 in pairs(arg0_369.ladyDict) do
		arg0_369:ResetActiveIKs(iter1_369)
		GetComponent(iter1_369.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_369.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_369.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_369.blockLayer, arg0_369._tf)
	table.Foreach(arg0_369.expressionDict, function(arg0_371)
		arg0_369:RemoveExpression(arg0_371)
	end)
	arg0_369.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_369 = {}

	if arg0_369.timelineScene and not arg0_369.cacheSceneDic[arg0_369.timelineScene] then
		local var1_369 = arg0_369.timelineScene

		arg0_369.timelineScene = nil

		local var2_369 = getProxy(ApartmentProxy):getApartment(arg0_369.sceneGroupDic[var1_369]):getConfig("asset_name")

		table.insert(var0_369, function(arg0_372)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_369 .. "/timeline/" .. var1_369 .. "/" .. var1_369 .. "_scene"), var1_369, arg0_372)
		end)
	end

	for iter2_369, iter3_369 in pairs(arg0_369.cacheSceneDic) do
		if iter3_369 then
			local var3_369 = getProxy(ApartmentProxy):getApartment(arg0_369.sceneGroupDic[iter2_369]):getConfig("asset_name")

			table.insert(var0_369, function(arg0_373)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_369 .. "/timeline/" .. iter2_369 .. "/" .. iter2_369 .. "_scene"), iter2_369, arg0_373)
			end)
		end
	end

	for iter4_369, iter5_369 in ipairs({
		arg0_369.sceneInfo,
		arg0_369.subSceneInfo ~= arg0_369.sceneInfo and arg0_369.subSceneInfo or nil
	}) do
		local var4_369, var5_369 = unpack(string.split(iter5_369, "|"))
		local var6_369 = var4_369 .. "_base"

		table.insert(var0_369, function(arg0_374)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_369 .. "/" .. var6_369 .. "_scene"), var6_369, arg0_374)
		end)
	end

	for iter6_369, iter7_369 in ipairs({
		arg0_369.sceneInfo,
		arg0_369.artSceneInfo ~= arg0_369.sceneInfo and arg0_369.artSceneInfo or nil
	}) do
		local var7_369, var8_369 = unpack(string.split(iter7_369, "|"))

		table.insert(var0_369, function(arg0_375)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_369 .. "/" .. var7_369 .. "_scene"), var7_369, arg0_375)
		end)
	end

	seriesAsync(var0_369, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_377 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_377 = SystemInfo.deviceModel or ""

			local function var2_377(arg0_378)
				local var0_378 = string.match(arg0_378, "iPad(%d+)")
				local var1_378 = tonumber(var0_378)

				if var1_378 and var1_378 >= 8 then
					return true
				end

				return false
			end

			local function var3_377(arg0_379)
				local var0_379 = string.match(arg0_379, "iPhone(%d+)")
				local var1_379 = tonumber(var0_379)

				if var1_379 and var1_379 >= 13 then
					return true
				end

				return false
			end

			if var2_377(var1_377) or var3_377(var1_377) then
				var0_377 = DevicePerformanceLevel.High
			end
		end

		local var4_377 = var0_377 == DevicePerformanceLevel.High and 3 or var0_377 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_377)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_377
	end
end

function var0_0.SettingQuality()
	local var0_380 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_380)
end

function var0_0.SetMagicaCollider(arg0_381, arg1_381, arg2_381)
	local var0_381 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_381, "StartRadius", arg0_381, arg1_381)
	ReflectionHelp.RefSetProperty(var0_381, "EndRadius", arg0_381, arg2_381)
end

return var0_0
