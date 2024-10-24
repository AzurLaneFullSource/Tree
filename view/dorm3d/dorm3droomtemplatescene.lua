local var0_0 = class("Dorm3dRoomTemplateScene", import("view.base.BaseUI"))

var0_0.CAMERA = {
	GIFT = 8,
	PHOTO = 10,
	POV = 11,
	TALK = 4,
	IK_WATCH = 12,
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
		iter1_14:InitCharacter(iter0_14)

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

		if arg0_15.compPov and go(arg0_15.compPov).activeInHierarchy then
			var2_30(arg0_15.compPov, "m_HorizontalAxis", var0_30)
			var2_30(arg0_15.compPov, "m_VerticalAxis", var1_30)
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
	arg0_33.cameraPhoto = var3_33:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook))
	arg0_33.cameras = {
		arg0_33.cameraAim,
		arg0_33.cameraAim2,
		arg0_33.cameraRole,
		arg0_33.cameraTalk,
		arg0_33.cameraRoleWatch,
		[var0_0.CAMERA.GIFT] = arg0_33.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_33.cameraRole2,
		[var0_0.CAMERA.PHOTO] = arg0_33.cameraPhoto,
		[var0_0.CAMERA.POV] = var3_33:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	}
	arg0_33.compDolly = arg0_33.cameraAim:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Body)
	arg0_33.compPov = arg0_33.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_33.cameraRoot = var3_33
	arg0_33.POVOriginalFOV = arg0_33:GetPOVFOV()
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
						local var0_55 = arg0_55:GetAllAssetNames()

						table.IpairsCArray(var0_55, function(arg0_56, arg1_56)
							local var0_56, var1_56, var2_56 = string.find(arg1_56, "material_hx[/\\](.*).mat")

							if var0_56 then
								arg0_53.hxMatDict[var2_56] = {
									arg0_55,
									arg1_56
								}
							end
						end)
						arg0_54()
					end)
				end)
			end
		end

		var1_53.skinId = var4_53
		var1_53.skinIdList = {
			var4_53
		}

		table.insert(var0_53, function(arg0_57)
			local var0_57 = string.format("dorm3d/character/%s/prefabs/%s", var3_53, var5_53)

			arg0_53.loader:GetPrefab(var0_57, "", function(arg0_58)
				var1_53.ladyGameobject = arg0_58
				arg0_53.skinDict[var4_53] = {
					ladyGameobject = arg0_58
				}

				arg0_57()
			end)
		end)

		if arg0_53.room:isPersonalRoom() then
			local var7_53 = var2_53:GetSkinModelID("touch")

			if var7_53 then
				table.insert(var1_53.skinIdList, var7_53)

				local var8_53 = pg.dorm3d_resource[var7_53].model_id

				table.insert(var0_53, function(arg0_59)
					local var0_59 = string.format("dorm3d/character/%s/prefabs/%s", var3_53, var8_53)

					arg0_53.loader:GetPrefab(var0_59, "", function(arg0_60)
						arg0_53.skinDict[var7_53] = {
							ladyGameobject = arg0_60
						}
						GetComponent(arg0_60, "GraphOwner").enabled = false

						onNextTick(function()
							setActive(arg0_60, false)
						end)
						arg0_59()
					end)
				end)
			end
		end

		if arg0_53.contextData.pendingDic[iter1_53] then
			local var9_53 = pg.dorm3d_welcome[arg0_53.contextData.pendingDic[iter1_53]]

			if var9_53.item_prefab ~= "" then
				table.insert(var0_53, function(arg0_62)
					local var0_62 = string.lower("dorm3d/furniture/item/" .. var9_53.item_prefab)

					arg0_53.loader:GetPrefab(var0_62, "", function(arg0_63)
						var1_53.tfPendintItem = arg0_63.transform

						onNextTick(function()
							setActive(arg0_63, false)
						end)
						arg0_62()
					end)
				end)
			end
		end
	end

	parallelAsync(var0_53, arg2_53)
end

function var0_0.HXCharacter(arg0_65, arg1_65)
	if not HXSet.isHx() then
		return
	end

	local var0_65 = arg1_65:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_65, function(arg0_66, arg1_66)
		local var0_66 = arg1_66.sharedMaterials
		local var1_66 = false

		table.IpairsCArray(var0_66, function(arg0_67, arg1_67)
			local var0_67 = arg1_67.name

			if not arg0_65.hxMatDict[var0_67] then
				return
			end

			var1_66 = true

			local var1_67 = arg0_65.hxMatDict[var0_67][1]:LoadAssetSync(arg0_65.hxMatDict[var0_67][2], typeof(Material), true, false)

			var0_66[arg0_67] = var1_67

			warning("Replace HX Material", arg0_65.hxMatDict[var0_67][2])
		end)

		if var1_66 then
			arg1_66.sharedMaterials = var0_66
		end
	end)
end

function var0_0.InitCharacter(arg0_68, arg1_68)
	arg0_68.lady = arg0_68.ladyGameobject.transform

	arg0_68.lady:SetParent(arg0_68.mainCameraTF)
	arg0_68.lady:SetParent(nil)

	arg0_68.ladyHeadIKComp = arg0_68.lady:GetComponent(typeof(HeadAimIK))
	arg0_68.ladyHeadIKComp.AimTarget = arg0_68.mainCameraTF:Find("AimTarget")
	arg0_68.ladyHeadIKData = {
		DampTime = arg0_68.ladyHeadIKComp.DampTime,
		blinkSpeed = arg0_68.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg0_68.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg0_68.ladyHeadIKComp.HeadWeight
	}

	local var0_68 = {}

	table.Foreach(var1_0, function(arg0_69, arg1_69)
		var0_68[arg1_69] = arg0_69
	end)

	arg0_68.ladyAnimator = arg0_68.lady:GetComponent(typeof(Animator))
	arg0_68.ladyAnimBaseLayerIndex = arg0_68.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_68.ladyAnimFaceLayerIndex = arg0_68.ladyAnimator:GetLayerIndex("Face")
	arg0_68.ladyBoneMaps = {}

	local var1_68 = arg0_68.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_68, function(arg0_70, arg1_70)
		if arg1_70.name == "BodyCollider" then
			arg0_68.ladyCollider = arg1_70
		elseif arg1_70.name == "Interest" then
			arg0_68.ladyInterestRoot = arg1_70
		elseif arg1_70.name == "Head Center" then
			arg0_68.ladyHeadCenter = arg1_70
		end

		if var0_68[arg1_70.name] then
			arg0_68.ladyBoneMaps[var0_68[arg1_70.name]] = arg1_70
		end
	end)

	arg0_68.ladyColliders = {}
	arg0_68.ladyTouchColliders = {}

	table.IpairsCArray(arg0_68.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_71, arg1_71)
		if arg1_71:GetType():Equals(typeof(UnityEngine.MeshCollider)) then
			return
		end

		child = tf(arg1_71)

		local var0_71 = child.name
		local var1_71 = var0_71 and string.find(var0_71, "Collider") or -1

		if var1_71 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_71)

			return
		end

		local var2_71 = string.sub(var0_71, 1, var1_71 - 1)

		arg0_68.ladyColliders[var2_71] = child

		if var2_71 ~= "Body" then
			table.insert(arg0_68.ladyTouchColliders, child)
			setActive(child, false)
		end
	end)
	arg0_68:HXCharacter(arg0_68.lady)
	;(function()
		local var0_72 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_72 = "vfx_function_aixin02"

		arg0_68.loader:GetPrefab(var0_72, var1_72, function(arg0_73)
			arg0_68.effectHeart = arg0_73

			setActive(arg0_73, false)
			setParent(arg0_68.effectHeart, arg0_68.ladyHeadCenter)
		end)
	end)()

	arg0_68.clothComps = {}

	table.IpairsCArray(arg0_68.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_74, arg1_74)
		table.insert(arg0_68.clothComps, arg1_74)
	end)

	arg0_68.clothColliderDict = {}

	table.IpairsCArray(arg0_68.lady:GetComponentsInChildren(typeof("MagicaCloth.MagicaCapsuleCollider"), true), function(arg0_75, arg1_75)
		arg0_68.clothColliderDict[arg1_75.name] = arg1_75
	end)
	arg0_68:EnableCloth(false)

	arg0_68.ladyIKRoot = arg0_68.lady:Find("IKLayers")

	eachChild(arg0_68.ladyIKRoot, function(arg0_76)
		setActive(arg0_76, false)
	end)
	GetComponent(arg0_68.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_77, arg1_77)
		if arg1_77.rawPointerPress.transform == arg0_68.ladyCollider then
			arg0_68:emit(var0_0.CLICK_CHARACTER, arg1_68)
		else
			local var0_77 = table.keyof(arg0_68.ladyColliders, arg1_77.rawPointerPress.transform)

			arg0_68:emit(var0_0.ON_TOUCH_CHARACTER, var0_0.BONE_TO_TOUCH[var0_77] or arg1_77.rawPointerPress.name)
		end
	end)
	arg0_68.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_78)
		if arg0_68.nowState and arg0_78.animatorStateInfo:IsName(arg0_68.nowState) then
			existCall(arg0_68.stateCallback)

			return
		end

		local var0_78 = arg0_78.animatorStateInfo

		for iter0_78, iter1_78 in pairs(arg0_68.animCallbacks) do
			if var0_78:IsName(iter0_78) then
				warning("Active", iter0_78)

				local var1_78 = table.removebykey(arg0_68.animCallbacks, iter0_78)

				existCall(var1_78)

				return
			end
		end

		if arg0_78.stringParameter ~= "" then
			arg0_68:OnAnimationEvent(arg0_78)
		end
	end)

	arg0_68.animEventCallbacks = {}
	arg0_68.animCallbacks = {}
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

	arg0_79:InitCharacter(arg1_79)
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
	arg0_81.cameraPhoto.Follow = arg0_81.ladyInterest
	arg0_81.cameraPhoto.LookAt = arg0_81.ladyInterest
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

		local var0_94 = (arg0_91.moveStickPosition - arg0_91.moveStickOrigin):ClampMagnitude(200)

		arg0_91.moveStickPosition = arg0_91.moveStickOrigin + var0_94

		local var1_94 = Vector3.New(var0_94.x, 0, var0_94.y)
		local var2_94 = arg0_91.mainCameraTF:TransformDirection(var1_94)

		var2_94.y = 0

		local var3_94 = var2_94:Normalize()

		var3_94:Mul(var1_91)
		arg0_91.playerController:SimpleMove(var3_94)

		arg0_91.tweenFOV = true
	end, 1, -1)

	arg0_91.moveStickTimer:Start()

	arg0_91.pinchMode = false
	arg0_91.pinchSize = 0
	arg0_91.pinchValue = 1
	arg0_91.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_95, arg1_95)
		if arg0_91.surroudCamera and isActive(arg0_91.surroudCamera) then
			arg0_91.pinchMode = true
			arg0_91.pinchSize = (arg0_95 - arg1_95):Magnitude()
			arg0_91.pinchNodeOrder = arg1_95.x < arg0_95.x and -1 or 1

			return
		end

		if isActive(arg0_91.cameras[var0_0.CAMERA.POV]) then
			if (arg0_95 - arg1_95):Magnitude() < Screen.height * 0.5 then
				arg0_91.pinchMode = true
				arg0_91.pinchSize = (arg0_95 - arg1_95):Magnitude()
				arg0_91.pinchNodeOrder = arg1_95.x < arg0_95.x and -1 or 1
			end

			return
		end
	end)

	local var2_91 = 0.01

	if IsUnityEditor then
		var2_91 = 0.1
	end

	local var3_91 = var2_91 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_96, arg1_96)
		if not arg0_91.pinchMode then
			return
		end

		local var0_96 = (arg0_96 - arg1_96):Magnitude()
		local var1_96 = arg0_91.pinchSize - var0_96
		local var2_96 = arg0_91.pinchNodeOrder * (arg1_96.x < arg0_96.x and -1 or 1)
		local var3_96 = var1_96 * var3_91 * var2_96

		if isActive(arg0_91.cameras[var0_0.CAMERA.POV]) then
			local var4_96 = 0.5
			local var5_96 = 1

			arg0_91.pinchValue = math.clamp(arg0_91.pinchValue + var3_96, var4_96, var5_96)
			arg0_91.pinchSize = var0_96

			arg0_91:SetPOVFOV(arg0_91.POVOriginalFOV * arg0_91.pinchValue)

			arg0_91.tweenFOV = nil

			return
		end

		if isActive(arg0_91.surroudCamera) and arg0_91.surroudCamera == arg0_91.cameraPhoto then
			local var6_96 = 0.5
			local var7_96 = 1

			arg0_91:SetPinchValue(math.clamp(arg0_91.pinchValue + var3_96, var6_96, var7_96))

			arg0_91.pinchSize = var0_96

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_91.pinchMode = false
		arg0_91.pinchSize = 0
	end)

	arg0_91.cameraBlendCallbacks = {}
	arg0_91.activeCMCamera = nil

	function arg0_91.camBrainEvenetHandler.OnBlendStarted(arg0_98)
		if arg0_91.activeCMCamera then
			arg0_91:OnCameraBlendFinished(arg0_91.activeCMCamera)
		end

		local var0_98 = arg0_91.camBrain.ActiveVirtualCamera

		arg0_91.activeCMCamera = var0_98
	end

	function arg0_91.camBrainEvenetHandler.OnBlendFinished(arg0_99)
		arg0_91.activeCMCamera = nil

		arg0_91:OnCameraBlendFinished(arg0_99)
	end

	for iter0_91, iter1_91 in pairs(arg0_91.ladyDict) do
		(function(arg0_100, arg1_100)
			if arg0_100.tfPendintItem then
				setParent(arg0_100.tfPendintItem, arg0_100.lady)
			end

			arg0_100.ladyOwner = GetComponent(arg0_100.lady, "GraphOwner")
			arg0_100.ladyBlackboard = GetComponent(arg0_100.lady, "Blackboard")

			arg0_100:SetBlackboardValue("groupId", arg1_100)
			onNextTick(function()
				arg0_100.ladyOwner.enabled = true
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

function var0_0.InitData(arg0_105)
	if not arg0_105.contextData.ladyZone then
		arg0_105.contextData.ladyZone = {}

		local var0_105
		local var1_105 = arg0_105.room:getConfig("default_zone")

		for iter0_105, iter1_105 in ipairs(arg0_105.contextData.groupIds) do
			for iter2_105, iter3_105 in ipairs(var1_105) do
				if iter3_105[1] == iter1_105 then
					arg0_105.contextData.ladyZone[iter1_105] = iter3_105[2]

					break
				end
			end

			assert(arg0_105.contextData.ladyZone[iter1_105])

			var0_105 = var0_105 or arg0_105.contextData.ladyZone[iter1_105]
		end

		arg0_105.contextData.inFurnitureName = var0_105 or arg0_105.room:getConfig("default_zone")[1][2]
	end

	arg0_105.zoneDatas = _.select(arg0_105.room:GetZones(), function(arg0_106)
		return not arg0_106:IsGlobal()
	end)
	arg0_105.readyIKLayers = {}
	arg0_105.activeIKLayers = {}
	arg0_105.holdingStatus = {}
	arg0_105.cacheIKInfos = {}
	arg0_105.activeSectors = {}
	arg0_105.activeLady = {}
end

function var0_0.Update(arg0_107)
	arg0_107.raycastCamera.fieldOfView = arg0_107.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_107.tweenFOV then
		local var0_107 = Damp(1, 1, Time.deltaTime)

		arg0_107.pinchValue = Mathf.Lerp(arg0_107.pinchValue, 1, var0_107)

		arg0_107:SetPOVFOV(arg0_107.POVOriginalFOV * arg0_107.pinchValue)

		if arg0_107.pinchValue > 0.99 then
			arg0_107.tweenFOV = nil
		end
	end

	if isActive(arg0_107.cameras[var0_0.CAMERA.POV]) then
		arg0_107:TriggerLadyDistance()
	end

	if arg0_107.contactInRangeDic then
		local var1_107 = arg0_107.mainCameraTF.forward
		local var2_107 = arg0_107.mainCameraTF.position
		local var3_107 = UnityEngine.Rect.New(0, 0, Screen.width, Screen.height)

		local function var4_107(arg0_108, arg1_108, arg2_108)
			local var0_108 = arg0_108.position - var2_107
			local var1_108 = Clone(var0_108)

			var1_108.y = 0

			if arg1_108 < var1_108.magnitude then
				return false
			end

			local var2_108 = var0_108:Normalize()
			local var3_108 = math.acos(Vector3.Dot(var2_108, var1_107)) * math.rad2Deg

			if arg2_108 < math.abs(var3_108) then
				return false
			end

			local var4_108 = arg0_107.raycastCamera:WorldToScreenPoint(arg0_108.position)

			if var4_108.z < 0 then
				return false
			end

			if not var3_107:Contains(var4_108) then
				return false
			end

			return true
		end

		for iter0_107, iter1_107 in pairs(arg0_107.contactInRangeDic) do
			local var5_107 = pg.dorm3d_collection_template[iter0_107]
			local var6_107 = underscore.any(var5_107.vfx_prefab, function(arg0_109)
				return arg0_107.modelRoot:Find(arg0_109) and var4_107(arg0_107.modelRoot:Find(arg0_109), 2, 60)
			end)

			if tobool(iter1_107) ~= var6_107 then
				arg0_107.contactInRangeDic[iter0_107] = var6_107

				arg0_107:UpdateContactDisplay(iter0_107, var6_107 and not arg0_107.hideConcatFlag and arg0_107.contactStateDic[iter0_107] or arg0_107.hideContactStateDic[iter0_107])
			end
		end
	end

	if arg0_107.enableFloatUpdate then
		arg0_107.ladyDict[arg0_107.apartment:GetConfigID()]:UpdateFloatPosition()
	end

	arg0_107:CheckInSector()

	if arg0_107.apartment then
		(function(arg0_110)
			(function()
				if not arg0_110.ikHandler then
					return
				end

				if not arg0_110.ikHandler.targetScreenOffset then
					return
				end

				local var0_111 = arg0_110.ikHandler.rect
				local var1_111 = var0_111:PointToNormalized(Vector2.zero)
				local var2_111 = var0_111:PointToNormalized(arg0_110.ikHandler.targetScreenOffset) - var1_111

				_.each(arg0_110.ikHandler.subPlanes, function(arg0_112)
					local var0_112 = arg0_112.target
					local var1_112 = arg0_112.planeData

					var0_112.position = var0_0.GetPostionByRatio(var1_112, var2_111)
				end)

				if Time.time > arg0_110.ikNextCheckStamp then
					arg0_110.ikNextCheckStamp = arg0_110.ikNextCheckStamp + var0_0.IK_STATUS_DELTA

					arg0_110:emit(var0_0.ON_IK_STATUS_CHANGED, arg0_110.ikHandler.ikData:GetConfigID(), var0_0.IK_STATUS.DRAG)
				end

				arg0_110:ResetIKTipTimer()
			end)()

			if arg0_110.enableIKTip then
				local var0_110 = Time.time > arg0_110.nextTipIKTime
				local var1_110 = arg0_110:GetIKTipsRootTF()

				if var0_110 then
					UIItemList.StaticAlign(var1_110, var1_110:GetChild(0), #arg0_110.readyIKLayers, function(arg0_113, arg1_113, arg2_113)
						if arg0_113 ~= UIItemList.EventUpdate then
							return
						end

						local var0_113 = arg0_110.readyIKLayers[arg1_113 + 1].ikData
						local var1_113 = var0_113:GetTriggerBoneName()
						local var2_113 = var1_113 and arg0_110.ladyColliders[var1_113] or nil

						if var2_113 and not (function()
							local var0_114 = arg0_110.raycastCamera:WorldToScreenPoint(var2_113.position)
							local var1_114 = CameraMgr.instance:Raycast(arg0_110.sceneRaycaster, var0_114)

							if var1_114.Length == 0 then
								return
							end

							return var2_113 == var1_114[0].gameObject.transform
						end)() then
							var2_113 = nil
						end

						if var2_113 then
							setLocalPosition(arg2_113, arg0_110:GetLocalPosition(arg0_110:GetScreenPosition(var2_113.position), var1_110) + var0_113:GetIKTipOffset())
						end

						setActive(arg2_113, var2_113)
					end)
				end

				setActive(var1_110, var0_110)
			end

			if arg0_110.ikRevertHandler then
				arg0_110.ikRevertHandler()
			end
		end)(arg0_107.ladyDict[arg0_107.apartment:GetConfigID()])
	end
end

function var0_0.CheckInSector(arg0_115)
	if not isActive(arg0_115.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_115 = arg0_115.mainCameraTF.position

	var0_115.y = 0

	for iter0_115, iter1_115 in pairs(arg0_115.ladyDict) do
		local var1_115 = tobool(arg0_115.activeLady[iter0_115])

		if var1_115 ~= tobool(var0_0.IsPointInSector(arg0_115.activeSectors[iter1_115.ladyActiveZone], var0_115)) then
			arg0_115.activeLady[iter0_115] = not var1_115

			arg0_115:emit(var0_0.ON_ENTER_SECTOR, iter0_115)
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_116)
	local function var0_116(arg0_117, arg1_117)
		arg0_117.dis = (arg0_117.lady.position - arg0_117.player.position).magnitude

		if (arg0_117:GetBlackboardValue("inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > arg0_117.dis ~= arg0_117:GetBlackboardValue("inDistance") then
			arg0_117:SetBlackboardValue("inDistance", arg0_117.dis < var0_0.POV_CLOSE_DISTANCE)
			arg0_117:emit(var0_0.ON_CHANGE_DISTANCE, arg1_117, arg0_117.dis < var0_0.POV_CLOSE_DISTANCE)
		end
	end

	for iter0_116, iter1_116 in pairs(arg0_116.ladyDict) do
		var0_116(iter1_116, iter0_116)
	end
end

function var0_0.OnStickMove(arg0_118, arg1_118)
	arg0_118.joystickDelta = arg1_118
end

function var0_0.SetPinchValue(arg0_119, arg1_119)
	arg0_119.pinchValue = arg1_119

	arg0_119:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_120)
	local var0_120 = arg0_120.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_120)
end

function var0_0.SetPOVFOV(arg0_121, arg1_121)
	local var0_121 = arg0_121.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_121, arg1_121)

	arg0_121.cameras[var0_0.CAMERA.POV].m_Lens = var0_121
end

function var0_0.RefreshSlots(arg0_122, arg1_122)
	arg1_122 = arg1_122 or arg0_122.room

	local var0_122 = arg1_122:GetSlots()
	local var1_122 = arg1_122:GetFurnitures()

	arg0_122:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_122, function(arg0_123, arg1_123, arg2_123)
		local var0_123 = arg1_123:GetConfigID()
		local var1_123 = _.detect(var1_122, function(arg0_124)
			return arg0_124:GetSlotID() == var0_123
		end)
		local var2_123 = var1_123 and var1_123:GetModel() or false
		local var3_123 = arg0_122.slotDict[var0_123].model

		arg0_122.slotDict[var0_123].displayModelName = var2_123

		if var2_123 == false or var2_123 == "" then
			arg0_122.loader:ClearRequest("slot_" .. var0_123)

			if var3_123 then
				setActive(var3_123, var2_123 == "")
			end

			arg2_123()

			return
		end

		local var4_123 = arg0_122.slotDict[var0_123].trans

		arg0_122.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_123, "", function(arg0_125)
			arg2_123()
			assert(arg0_125)
			setParent(arg0_125, var4_123)

			if var3_123 then
				local var0_125 = arg0_125:GetComponentsInChildren(typeof(Renderer), true)

				table.IpairsCArray(var0_125, function(arg0_126, arg1_126)
					LuaHelper.CopyLightMap(arg1_126.gameObject, arg0_125)
				end)
				setActive(var3_123, false)
			end
		end, "slot_" .. var0_123)
	end, function()
		arg0_122:emit(var0_0.HIDE_BLOCK)
	end)
end

function var0_0.ChangeCharacterPosition(arg0_128)
	arg0_128:ResetCharPoint(arg0_128.ladyActiveZone)
	arg0_128:SyncInterestTransform()
end

function var0_0.SyncInterestTransform(arg0_129)
	arg0_129.ladyInterest.position = arg0_129.ladyInterestRoot.position
	arg0_129.ladyInterest.rotation = arg0_129.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_130, arg1_130)
	arg1_130 = arg1_130 or arg0_130.contextData.inFurnitureName

	local var0_130 = arg0_130.furnitures:Find(arg1_130):Find("PlayerPoint").position

	arg0_130.player.position = var0_130
	arg0_130.cameras[var0_0.CAMERA.POV].transform.position = arg0_130.playerEye.position

	local var1_130 = arg0_130.ladyInterest.position - arg0_130.playerEye.position
	local var2_130 = Quaternion.LookRotation(var1_130).eulerAngles
	local var3_130 = var2_130.y
	local var4_130 = var2_130.x
	local var5_130 = arg0_130.compPov.m_HorizontalAxis

	var5_130.Value = arg0_130:GetNearestAngle(var3_130, var5_130.m_MinValue, var5_130.m_MaxValue)
	arg0_130.compPov.m_HorizontalAxis = var5_130

	local var6_130 = arg0_130.compPov.m_VerticalAxis

	var6_130.Value = var4_130
	arg0_130.compPov.m_VerticalAxis = var6_130
end

function var0_0.GetAttachedFurnitureName(arg0_131)
	return arg0_131.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_132, arg1_132)
	return underscore.detect(arg0_132.attachedPoints, function(arg0_133)
		return arg0_133.name == arg1_132
	end)
end

function var0_0.GetSlotByID(arg0_134, arg1_134)
	return arg0_134.displaySlots[arg1_134] and arg0_134.displaySlots[arg1_134].trans
end

function var0_0.GetScreenPosition(arg0_135, arg1_135)
	local var0_135 = arg0_135.raycastCamera:WorldToScreenPoint(arg1_135)

	if var0_135.z < 0 then
		var0_135.x = var0_135.x + (var0_135.x < 0 and -1 or 1) * Screen.width
		var0_135.y = var0_135.y + (var0_135.y < 0 and -1 or 1) * Screen.height
		var0_135.z = -var0_135.z
	end

	return var0_135
end

function var0_0.GetLocalPosition(arg0_136, arg1_136, arg2_136)
	return LuaHelper.ScreenToLocal(arg2_136, arg1_136, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_137)
	return arg0_137.modelRoot
end

function var0_0.ShiftZone(arg0_138, arg1_138, arg2_138)
	local var0_138 = arg0_138:GetFurnitureByName(arg1_138)

	if not var0_138 then
		errorMsg(arg1_138 .. " Not Find")
		existCall(arg2_138)

		return
	end

	seriesAsync({
		function(arg0_139)
			arg0_138:emit(var0_0.SHOW_BLOCK)
			arg0_138:ShowBlackScreen(true, arg0_139)
		end,
		function(arg0_140)
			if arg0_138.shiftLady or arg0_138.room:isPersonalRoom() then
				local var0_140 = arg0_138.shiftLady or arg0_138.apartment:GetConfigID()

				arg0_138.shiftLady = nil
				arg0_138.contextData.ladyZone[var0_140] = var0_138.name

				local var1_140 = arg0_138.ladyDict[var0_140]

				var1_140.ladyBaseZone = arg0_138.contextData.ladyZone[var0_140]
				var1_140.ladyActiveZone = arg0_138.contextData.ladyZone[var0_140]

				if var1_140:GetBlackboardValue("inPending") then
					var1_140:SetOutPending()
					var1_140:SwitchAnim(var0_0.ANIM.IDLE)
					onNextTick(function()
						var1_140:ChangeCharacterPosition()
						arg0_140()
					end)
				else
					var1_140:ChangeCharacterPosition()
					arg0_140()
				end
			else
				arg0_140()
			end
		end,
		function(arg0_142)
			arg0_138.contextData.inFurnitureName = var0_138.name

			arg0_138:ChangePlayerPosition()
			arg0_138:TriggerLadyDistance()
			arg0_138:CheckInSector()
			arg0_142()
		end,
		function(arg0_143)
			arg0_138:UpdateZoneList()
			arg0_138:ShowBlackScreen(false, arg0_143)
		end,
		function(arg0_144)
			arg0_138:emit(var0_0.HIDE_BLOCK)
			arg0_144()
		end
	}, arg2_138)
end

function var0_0.WalkByRootMotionLoop(arg0_145, arg1_145, arg2_145)
	if arg1_145.pathPending then
		arg2_145:SetFloat("Speed", 0)

		return
	end

	arg2_145:SetFloat("Speed", 1)

	local var0_145 = arg1_145.path.corners

	if var0_145.Length > 1 then
		local var1_145 = var0_145[1] - arg1_145.transform.position

		var1_145.y = 0

		local var2_145 = Quaternion.LookRotation(var1_145)
		local var3_145 = arg1_145.transform.rotation
		local var4_145 = 1
		local var5_145 = Damp(1, var4_145, Time.deltaTime)

		arg1_145.transform.rotation = Quaternion.Lerp(var3_145, var2_145, var5_145)
	end
end

function var0_0.ActiveCamera(arg0_146, arg1_146)
	if isActive(arg1_146) then
		arg0_146:OnCameraBlendFinished(arg1_146)
	end

	table.Foreach(arg0_146.cameras, function(arg0_147, arg1_147)
		setActive(arg1_147, arg1_147 == arg1_146)
	end)
end

function var0_0.ShowBlackScreen(arg0_148, arg1_148, arg2_148)
	local var0_148 = arg0_148.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_148 and 0 or 0.3
	}

	setImageColor(arg0_148.blackLayer, Color.NewHex(var0_148.color))
	setActive(arg0_148.blackLayer, true)
	setCanvasGroupAlpha(arg0_148.blackLayer, arg1_148 and 0 or 1)
	arg0_148:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_148 then
			setActive(arg0_148.blackLayer, false)
		end

		existCall(arg2_148)
	end, GetComponent(arg0_148.blackLayer, typeof(CanvasGroup)), arg1_148 and 1 or 0, var0_148.time):setDelay(var0_148.delay)
end

function var0_0.RegisterOrbits(arg0_150, arg1_150)
	arg0_150 = arg0_150.scene
	arg0_150.orbits = {
		original = arg1_150.m_Orbits
	}
	arg0_150.orbits.current = _.range(3):map(function(arg0_151)
		local var0_151 = arg0_150.orbits.original[arg0_151 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_151.m_Height, var0_151.m_Radius)
	end)
	arg0_150.surroudCamera = arg1_150
end

function var0_0.SetCameraObrits(arg0_152)
	local var0_152 = arg0_152.surroudCamera

	if not var0_152 then
		return
	end

	local var1_152 = arg0_152.orbits.original[1]

	for iter0_152 = 0, #arg0_152.orbits.current - 1 do
		local var2_152 = arg0_152.orbits.current[iter0_152 + 1]
		local var3_152 = arg0_152.orbits.original[iter0_152]

		var2_152.m_Height = math.lerp(var1_152.m_Height, var3_152.m_Height, arg0_152.pinchValue)
		var2_152.m_Radius = var3_152.m_Radius * arg0_152.pinchValue
	end

	var0_152.m_Orbits = arg0_152.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_153)
	arg0_153 = arg0_153.scene

	local var0_153 = arg0_153.surroudCamera

	if not var0_153 then
		return
	end

	for iter0_153 = 0, #arg0_153.orbits.current - 1 do
		local var1_153 = arg0_153.orbits.current[iter0_153 + 1]
		local var2_153 = arg0_153.orbits.original[iter0_153]

		var1_153.m_Height = var2_153.m_Height
		var1_153.m_Radius = var2_153.m_Radius
	end

	var0_153.m_Orbits = arg0_153.orbits.current
	arg0_153.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_154, arg1_154, arg2_154)
	local var0_154 = {
		base = function(arg0_155)
			arg0_154:RegisterCameraBlendFinished(arg0_154.cameras[var0_0.CAMERA.POV], arg0_155)
			arg0_154:ActiveCamera(arg0_154.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_156)
			assert(arg0_154.apartment)
			arg0_154.ladyDict[arg0_154.apartment:GetConfigID()]:SetCameraLady()
			arg0_154:RegisterCameraBlendFinished(arg0_154.cameras[var0_0.CAMERA.ROLE], arg0_156)
			arg0_154:ActiveCamera(arg0_154.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_157)
			arg0_154:RegisterCameraBlendFinished(arg0_154.cameras[var0_0.CAMERA.POV], arg0_157)
			arg0_154:ActiveCamera(arg0_154.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_158)
			arg0_158()
		end,
		gift = function(arg0_159)
			assert(arg0_154.apartment)
			arg0_154.ladyDict[arg0_154.apartment:GetConfigID()]:SetCameraLady()
			arg0_154:RegisterCameraBlendFinished(arg0_154.cameras[var0_0.CAMERA.GIFT], arg0_159)
			arg0_154:ActiveCamera(arg0_154.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_160)
			assert(arg0_154.apartment)
			arg0_154.ladyDict[arg0_154.apartment:GetConfigID()]:SetCameraLady()

			arg0_154.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_154.cameraRole.transform.position

			arg0_154:RegisterCameraBlendFinished(arg0_154.cameras[var0_0.CAMERA.ROLE2], arg0_160)
			arg0_154:ActiveCamera(arg0_154.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_161)
			assert(arg0_154.apartment)
			arg0_154.ladyDict[arg0_154.apartment:GetConfigID()]:SetCameraLady()
			arg0_154:RegisterCameraBlendFinished(arg0_154.cameras[var0_0.CAMERA.TALK], arg0_161)
			arg0_154:ActiveCamera(arg0_154.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_154 = {}

	table.insert(var1_154, function(arg0_162)
		switch(arg1_154, var0_154, arg0_162, arg0_162)
	end)
	seriesAsync(var1_154, arg2_154)
end

function var0_0.SetIKStatus(arg0_163, arg1_163, arg2_163)
	warning("Set IKStatus " .. (arg1_163.id or "NIL"))

	arg0_163.enableIKTip = true

	setActive(arg0_163.ladyCollider, false)
	_.each(arg0_163.ladyTouchColliders, function(arg0_164)
		setActive(arg0_164, true)
	end)
	table.clear(arg0_163.readyIKLayers)

	arg0_163.blockIK = nil

	local var0_163 = _.map(arg1_163.ik_id, function(arg0_165)
		return arg0_165[1]
	end)

	table.Foreach(var0_163, function(arg0_166, arg1_166)
		local var0_166 = Dorm3dIK.New({
			configId = arg1_166
		})

		table.insert(arg0_163.readyIKLayers, {
			ikData = var0_166
		})

		arg0_163.cacheIKInfos[var0_166] = {}

		local var1_166 = var0_166:GetControllerPath()
		local var2_166 = arg0_163.ladyIKRoot:Find(var1_166):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
		local var3_166 = {}

		table.IpairsCArray(var2_166.IKComponents, function(arg0_167, arg1_167)
			var3_166[arg0_167 + 1] = arg1_167:GetIKSolver()
		end)

		arg0_163.cacheIKInfos[var0_166].solvers = var3_166

		local var4_166 = _.map(var3_166, function(arg0_168)
			return arg0_168.IKPositionWeight
		end)

		arg0_163.cacheIKInfos[var0_166].weights = var4_166
	end)

	arg0_163.camBrain.enabled = false

	if arg0_163.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_163.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_163.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var1_163 = arg0_163.cameraRoot:Find(arg1_163.ik_camera)

	assert(var1_163, "Missing IKCamera")

	arg0_163.cameras[var0_0.CAMERA.IK_WATCH] = var1_163

	arg0_163:ActiveCamera(arg0_163.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_163.camBrain.enabled = true

	local var2_163 = var1_163:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var2_163 then
		arg0_163:RegisterOrbits(var2_163)
	end

	arg0_163:SettingHeadAimIK(arg0_163, arg0_163.ikConfig.head_track)
	arg0_163:ResetIKTipTimer()
	arg0_163:SwitchAnim(arg1_163.character_action)
	onNextTick(function()
		local var0_169 = arg0_163.furnitures:Find(arg1_163.character_position)

		arg0_163.lady.position = var0_169:Find("StayPoint").position
		arg0_163.lady.rotation = var0_169:Find("StayPoint").rotation

		arg0_163:EnableCloth(false)
		arg0_163:EnableCloth(arg1_163.use_cloth, arg1_163.cloth_colliders)
		existCall(arg2_163)
	end)
end

function var0_0.ExitIKStatus(arg0_170, arg1_170, arg2_170)
	arg0_170.enableIKTip = false

	setActive(arg0_170.ladyCollider, true)
	_.each(arg0_170.ladyTouchColliders, function(arg0_171)
		setActive(arg0_171, false)
	end)
	arg0_170:ResetActiveIKs(arg0_170)
	table.clear(arg0_170.readyIKLayers)
	table.clear(arg0_170.cacheIKInfos)
	table.clear(arg0_170.activeIKLayers)
	table.clear(arg0_170.holdingStatus)
	eachChild(arg0_170.ladyIKRoot, function(arg0_172)
		setActive(arg0_172, false)
	end)
	setActive(arg0_170:GetIKTipsRootTF(), false)
	arg0_170:RevertCameraOrbit()
	setActive(arg0_170.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_170.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_170:EnableCloth(false)
	arg0_170:ResetHeadAimIK(arg0_170)
	arg0_170:SwitchAnim(arg1_170.character_action)
	onNextTick(function()
		if arg1_170.character_position then
			arg0_170.ladyActiveZone = arg1_170.character_position
		else
			arg0_170.ladyActiveZone = arg0_170.ladyBaseZone
		end

		arg0_170:ChangeCharacterPosition()
		arg0_170:TriggerLadyDistance()
		arg0_170:CheckInSector()
		existCall(arg2_170)
	end)
end

function var0_0.EnableIKLayer(arg0_174, arg1_174, arg2_174)
	warning("ENABLEIK", arg2_174:GetConfigID())

	local var0_174 = arg2_174:GetControllerPath()
	local var1_174 = arg1_174.ladyIKRoot:Find(var0_174):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
	local var2_174 = tf(var1_174):Find("Container")
	local var3_174 = {
		ikData = arg2_174,
		list = var1_174
	}

	if not arg1_174.holdingStatus[arg2_174] then
		var3_174.rect = arg2_174:GetRect()

		local var4_174 = arg2_174:GetActionTriggerParams()

		if var4_174[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET or var4_174[1] == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET then
			var3_174.triggerRect = arg2_174:GetTriggerRect()
		end

		local var5_174 = var2_174:Find("SubTargets")
		local var6_174 = {}

		assert(var5_174)

		local var7_174 = arg2_174:GetSubTargets()
		local var8_174 = arg2_174:GetPlaneRotations()
		local var9_174 = arg2_174:GetPlaneScales()

		table.Foreach(var7_174, function(arg0_175, arg1_175)
			local var0_175 = var5_174:Find(arg1_175[1])
			local var1_175 = var0_175:Find("Plane")

			if var8_174[arg0_175] then
				var1_175.localRotation = var8_174[arg0_175]
				var1_175.localScale = var9_174[arg0_175]
			end

			local var2_175 = var0_175:Find("Target")
			local var3_175 = var0_0.TransformMesh(var1_175:GetComponent(typeof(UnityEngine.MeshCollider)))
			local var4_175 = arg1_174.ladyBoneMaps[arg1_175[1]]

			var3_175.origin = var4_175.position

			local var5_175 = var3_174.rect
			local var6_175 = Vector2.New(var5_175.center.x / var5_175.width, var5_175.center.y / var5_175.height)

			var1_175.position = var0_0.GetPostionByRatio(var3_175, var6_175)
			var2_175.position = var4_175.position

			local var7_175 = {
				planeData = var3_175,
				target = var2_175,
				useOffset = tobool(arg1_175)
			}

			table.insert(var6_174, var7_175)
		end)

		var3_174.subPlanes = var6_174

		setActive(var1_174, true)
	else
		var3_174 = arg1_174.holdingStatus[arg2_174].ikHandler
	end

	if #arg2_174:GetHeadTrackPath() > 0 then
		arg0_174:SettingHeadAimIK(arg1_174, {
			2,
			arg2_174:GetHeadTrackPath()
		}, true)
	end

	local var10_174 = arg2_174:GetTriggerFaceAnim()

	if #var10_174 > 0 then
		arg0_174:PlayFaceAnim(var10_174)
	end

	setActive(arg0_174:GetIKHandTF(), true)
	eachChild(arg0_174:GetIKHandTF(), function(arg0_176)
		setActive(arg0_176, false)
	end)
	arg0_174:StopIKHandTimer()
	setActive(arg0_174:GetIKHandTF():Find("Begin"), true)

	arg1_174.ikHandTimer = Timer.New(function()
		setActive(arg0_174:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_174:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg1_174.ikHandTimer:Start()

	arg1_174.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_174:emit(var0_0.ON_IK_STATUS_CHANGED, arg2_174:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_174.apartment.configId, arg0_174.apartment.level, arg1_174.ikConfig.character_action, arg2_174:GetTriggerParams()[2], arg0_174.room:GetConfigID()))

	return var3_174
end

function var0_0.DeactiveIKLayer(arg0_178, arg1_178)
	if #arg1_178:GetHeadTrackPath() > 0 then
		arg0_178:SettingHeadAimIK(arg0_178, arg0_178.ikConfig.head_track)
	end

	arg0_178:StopIKHandTimer()
	setActive(arg0_178:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_178:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_178:GetIKHandTF():Find("End"), true)

	arg0_178.ikHandTimer = Timer.New(function()
		setActive(arg0_178:GetIKHandTF():Find("End"), false)
		setActive(arg0_178:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_178.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_180)
	if not arg0_180.ikHandTimer then
		return
	end

	arg0_180.ikHandTimer:Stop()

	arg0_180.ikHandTimer = nil
end

function var0_0.RevertIKLayer(arg0_181, arg1_181, arg2_181)
	seriesAsync({
		function(arg0_182)
			if arg1_181 >= 999 then
				return arg0_182()
			end

			arg0_181:PlayIKRevert(arg0_181, arg1_181, arg0_182)
		end,
		arg2_181
	})
end

function var0_0.RevertAllIKLayer(arg0_183, arg1_183, arg2_183)
	table.insertto(arg0_183.activeIKLayers, _.keys(arg0_183.holdingStatus))
	table.clear(arg0_183.holdingStatus)
	arg0_183.RevertIKLayer(arg0_183, arg1_183, arg2_183)
end

function var0_0.PlayIKRevert(arg0_184, arg1_184, arg2_184, arg3_184)
	local var0_184 = Time.time

	function arg0_184.ikRevertHandler()
		local var0_185 = Time.time - var0_184

		_.each(arg1_184.activeIKLayers, function(arg0_186)
			local var0_186 = 1

			if arg2_184 > 0 then
				var0_186 = var0_185 / arg2_184
			end

			local var1_186 = arg1_184.cacheIKInfos[arg0_186].solvers
			local var2_186 = arg1_184.cacheIKInfos[arg0_186].weights

			table.Foreach(var1_186, function(arg0_187, arg1_187)
				arg1_187.IKPositionWeight = math.lerp(var2_186[arg0_187], 0, var0_186)
			end)
		end)

		if var0_185 >= arg2_184 then
			arg0_184:ResetActiveIKs(arg1_184)

			arg0_184.ikRevertHandler = nil

			existCall(arg3_184)
		end
	end

	arg0_184.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_188, arg1_188)
	table.insertto(arg0_188.activeIKLayers, _.keys(arg0_188.holdingStatus))
	table.clear(arg0_188.holdingStatus)
	_.each(arg1_188.activeIKLayers, function(arg0_189)
		local var0_189 = arg0_189:GetControllerPath()
		local var1_189 = arg1_188.ladyIKRoot:Find(var0_189):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_189, false)

		local var2_189 = arg1_188.cacheIKInfos[arg0_189].solvers
		local var3_189 = arg1_188.cacheIKInfos[arg0_189].weights

		table.Foreach(var2_189, function(arg0_190, arg1_190)
			arg1_190.IKPositionWeight = var3_189[arg0_190]
		end)
	end)
	table.clear(arg1_188.activeIKLayers)
end

function var0_0.PlayIKAction(arg0_191, arg1_191)
	warning("Trigger IK", arg1_191:GetConfigID())
	arg0_191:emit(var0_0.ON_IK_STATUS_CHANGED, arg1_191:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	arg0_191:OnTriggerIK(arg1_191:GetConfigID())
end

function var0_0.ResetIKTipTimer(arg0_192)
	if not arg0_192.enableIKTip then
		return
	end

	arg0_192.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableHeadIK(arg0_193, arg1_193)
	arg0_193.ladyHeadIKComp.enableIk = arg1_193
end

function var0_0.SettingHeadAimIK(arg0_194, arg1_194, arg2_194, arg3_194)
	local var0_194

	if arg2_194[1] == 1 then
		var0_194 = arg0_194.mainCameraTF:Find("AimTarget")
	elseif arg2_194[1] == 2 then
		table.IpairsCArray(arg1_194.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_195, arg1_195)
			if arg1_195.name ~= arg2_194[2] then
				return
			end

			var0_194 = arg1_195
		end)
	end

	arg1_194.ladyHeadIKComp.AimTarget = var0_194

	if not arg3_194 and arg2_194[3] then
		arg1_194.ladyHeadIKComp.BodyWeight = arg2_194[3]
	end

	if not arg3_194 and arg2_194[4] then
		arg1_194.ladyHeadIKComp.HeadWeight = arg2_194[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_196, arg1_196)
	arg1_196.ladyHeadIKComp.AimTarget = arg0_196.mainCameraTF:Find("AimTarget")
	arg1_196.ladyHeadIKComp.HeadWeight = arg1_196.ladyHeadIKData.HeadWeight
	arg1_196.ladyHeadIKComp.BodyWeight = arg1_196.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_197, arg1_197)
	local function var0_197(arg0_198)
		arg0_198:HideCharacterBylayer()
	end

	for iter0_197, iter1_197 in pairs(arg0_197.ladyDict) do
		if iter0_197 ~= arg1_197 then
			var0_197(iter1_197)
		end
	end
end

function var0_0.RevertCharacter(arg0_199, arg1_199)
	local function var0_199(arg0_200)
		arg0_200:RevertCharacterBylayer()
	end

	for iter0_199, iter1_199 in pairs(arg0_199.ladyDict) do
		if iter0_199 ~= arg1_199 then
			var0_199(iter1_199)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_201)
	local var0_201 = "Bip001"
	local var1_201 = arg0_201.lady:Find("all")

	for iter0_201 = 0, var1_201.childCount - 1 do
		local var2_201 = var1_201:GetChild(iter0_201)

		if var2_201.name ~= var0_201 then
			pg.ViewUtils.SetLayer(var2_201, Layer.Environment3D)
		end
	end

	if arg0_201.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_201.tfPendintItem, Layer.Environment3D)
	end

	if arg0_201.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_201.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg0_201.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_202)
	local var0_202 = "Bip001"
	local var1_202 = arg0_202.lady:Find("all")

	for iter0_202 = 0, var1_202.childCount - 1 do
		local var2_202 = var1_202:GetChild(iter0_202)

		if var2_202.name ~= var0_202 then
			pg.ViewUtils.SetLayer(var2_202, Layer.Default)
		end
	end

	if arg0_202.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_202.tfPendintItem, Layer.Default)
	end

	if arg0_202.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_202.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg0_202.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_203)
	arg0_203:SetAllBlackbloardValue("inLockLayer", true)
	arg0_203:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_204)
	arg0_204:HideFurnitureSlots()

	local var0_204 = arg0_204.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_205)
			arg0_204:emit(var0_0.SHOW_BLOCK)
			arg0_204:ShowBlackScreen(true, arg0_205)
		end,
		function(arg0_206)
			arg0_204:RevertCharacter()
			arg0_204:SetAllBlackbloardValue("inLockLayer", false)
			arg0_204:RegisterCameraBlendFinished(var0_204, arg0_206)
			arg0_204:ActiveCamera(var0_204)
		end,
		function(arg0_207)
			arg0_204:ShowBlackScreen(false, arg0_207)
		end
	}, function()
		arg0_204:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_204:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_209, arg1_209)
	local var0_209 = arg0_209:GetFurnitureByName(arg1_209:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_209.cameraFurnitureWatch and arg0_209.cameraFurnitureWatch ~= var0_209 then
		arg0_209:UnRegisterCameraBlendFinished(arg0_209.cameraFurnitureWatch)
		setActive(arg0_209.cameraFurnitureWatch, false)
	end

	arg0_209.cameraFurnitureWatch = var0_209
	arg0_209.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_209.cameraFurnitureWatch

	arg0_209:RegisterCameraBlendFinished(arg0_209.cameraFurnitureWatch, function()
		arg0_209:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_209:emit(var0_0.SHOW_BLOCK)
	arg0_209:ActiveCamera(arg0_209.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_211)
	if arg0_211.displaySlots then
		arg0_211:UpdateDisplaySlots({})
		table.Foreach(arg0_211.displaySlots, function(arg0_212, arg1_212)
			local var0_212 = arg1_212.trans

			if IsNil(var0_212:Find("Selector")) then
				return
			end

			setActive(var0_212:Find("Selector"), false)
		end)

		arg0_211.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_213, arg1_213)
	arg0_213:HideFurnitureSlots()

	arg0_213.displaySlots = {}

	_.each(arg1_213, function(arg0_214)
		arg0_213.displaySlots[arg0_214] = arg0_213.slotDict[arg0_214]

		if not arg0_213.displaySlots[arg0_214] then
			errorMsg("Slot " .. arg0_214 .. " Not Binding Scene Object")

			return
		end

		local var0_214 = arg0_213.displaySlots[arg0_214].trans

		if var0_214:Find("Selector") then
			setActive(var0_214:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_215, arg1_215)
	table.Foreach(arg0_215.displaySlots, function(arg0_216, arg1_216)
		local var0_216 = arg1_216.trans

		if not IsNil(var0_216:Find("Selector")) then
			setActive(var0_216:Find("Selector/Normal"), arg1_215[arg0_216] == 0)
			setActive(var0_216:Find("Selector/Active"), arg1_215[arg0_216] == 1)
			setActive(var0_216:Find("Selector/Ban"), arg1_215[arg0_216] == 2)
		end

		local var1_216 = arg0_215.slotDict[arg0_216].model
		local var2_216 = arg0_215.slotDict[arg0_216].displayModelName

		if var2_216 and var2_216 ~= "" then
			var1_216 = var0_216:GetChild(var0_216.childCount - 1)
		end

		local function var3_216(arg0_217, arg1_217)
			local var0_217 = arg0_217:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_217, function(arg0_218, arg1_218)
				local var0_218 = arg1_218.material

				if var0_218 and var0_218:HasProperty("_FinalTint") then
					var0_218:SetColor("_FinalTint", arg1_217)
				end
			end)
		end

		if var1_216 then
			if arg1_215[arg0_216] == 1 then
				var3_216(var1_216, Color.NewHex("3F83AE73"))
			else
				var3_216(var1_216, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_219, arg1_219, arg2_219)
	arg0_219:SetAllBlackbloardValue("inLockLayer", true)
	arg0_219:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_220)
			arg0_219:TempHideUI(true, arg0_220)
		end,
		function(arg0_221)
			arg0_219:ShowBlackScreen(true, arg0_221)
		end,
		function(arg0_222)
			arg0_219:SwitchAnim(arg2_219)
			onNextTick(function()
				arg0_219:ResetCharPoint(arg1_219:GetWatchCameraName())
				arg0_219:SyncInterestTransform()
			end)

			local var0_222 = arg0_219.cameraPhoto
			local var1_222 = var0_222.m_XAxis

			var1_222.Value = 180
			var0_222.m_XAxis = var1_222

			local var2_222 = var0_222.m_YAxis

			var2_222.Value = 0.7
			var0_222.m_YAxis = var2_222

			arg0_219:RegisterOrbits(arg0_219.cameraPhoto)

			arg0_219.pinchValue = 1

			arg0_219:SetCameraObrits()
			arg0_219:RegisterCameraBlendFinished(var0_222, arg0_222)
			arg0_219:ActiveCamera(var0_222)
		end,
		function(arg0_224)
			arg0_219:ShowBlackScreen(false, arg0_224)
		end
	}, function()
		arg0_219:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_226)
	arg0_226:emit(var0_0.SHOW_BLOCK)
	arg0_226:EnableJoystick(false)
	seriesAsync({
		function(arg0_227)
			arg0_226:ShowBlackScreen(true, arg0_227)
		end,
		function(arg0_228)
			arg0_226:RevertCameraOrbit()
			arg0_226:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_226:ChangeCharacterPosition()
			end)

			local var0_228 = arg0_226.cameras[var0_0.CAMERA.POV]

			arg0_226:RegisterCameraBlendFinished(var0_228, arg0_228)
			arg0_226:ActiveCamera(var0_228)
		end,
		function(arg0_230)
			arg0_226:ShowBlackScreen(false, arg0_230)
		end
	}, function()
		arg0_226:RefreshSlots()
		arg0_226:SetAllBlackbloardValue("inLockLayer", false)
		arg0_226:emit(var0_0.HIDE_BLOCK)
		arg0_226:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_226:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_232, arg1_232, arg2_232, arg3_232)
	arg0_232:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_233)
			arg0_232:ShowBlackScreen(true, arg0_233)
		end,
		function(arg0_234)
			arg0_232:SwitchAnim(arg2_232)
			onNextTick(function()
				arg0_232:ResetCharPoint(arg1_232:GetWatchCameraName())
				arg0_232:SyncInterestTransform()
				arg0_234()
			end)
		end,
		function(arg0_236)
			arg0_232:ShowBlackScreen(false, arg0_236)
		end
	}, function()
		arg0_232:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_232)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_238)
	arg0_238.ladyInterest.position = arg0_238.ladyInterestRoot.position
end

function var0_0.ResetPhotoCameraPosition(arg0_239)
	local var0_239 = arg0_239.cameraPhoto
	local var1_239 = var0_239.m_XAxis

	var1_239.Value = 180
	var0_239.m_XAxis = var1_239

	local var2_239 = var0_239.m_YAxis

	var2_239.Value = 0.7
	var0_239.m_YAxis = var2_239
end

function var0_0.ResetCharPoint(arg0_240, arg1_240)
	local var0_240 = arg0_240.furnitures:Find(arg1_240 .. "/StayPoint")

	arg0_240.lady.position = var0_240.position
	arg0_240.lady.rotation = var0_240.rotation
end

function var0_0.GetNearestAngle(arg0_241, arg1_241, arg2_241, arg3_241)
	if arg3_241 < arg2_241 then
		arg3_241 = arg3_241 + 360
	end

	if arg2_241 <= arg1_241 and arg1_241 <= arg3_241 then
		return arg1_241
	end

	local var0_241 = (arg2_241 + arg3_241) / 2

	arg1_241 = var0_241 - Mathf.DeltaAngle(arg1_241, var0_241)
	arg1_241 = math.clamp(arg1_241, arg2_241, arg3_241)

	return arg1_241
end

function var0_0.PlayTimeline(arg0_242, arg1_242, arg2_242)
	local var0_242 = {}

	if arg0_242.waitForTimeline then
		table.insert(var0_242, function(arg0_243)
			local var0_243 = arg0_242.waitForTimeline

			arg0_242.waitForTimeline = nil

			var0_243()
			arg0_243()
		end)
	end

	table.insert(var0_242, function(arg0_244)
		arg0_242:LoadTimelineScene(arg1_242.name, false, arg0_244)
	end)

	if arg1_242.scene and arg1_242.sceneRoot then
		table.insert(var0_242, function(arg0_245)
			arg0_242:ChangeArtScene(arg1_242.scene .. "|" .. arg1_242.sceneRoot, arg0_245)
		end)
	end

	table.insert(var0_242, function(arg0_246)
		local var0_246 = GameObject.Find("[sequence]").transform
		local var1_246 = var0_246:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if GetComponent(var1_246, "TimelineSpeed") then
			setDirectorSpeed(var1_246, 1)
		else
			GetOrAddComponent(var0_246, "TimelineSpeed")
		end

		local var2_246 = GameObject.Find("[actor]").transform:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var2_246, function(arg0_247, arg1_247)
			GetOrAddComponent(arg1_247.transform, typeof(DftAniEvent))
		end)
		var1_246:Stop()

		var1_246.extrapolationMode = ReflectionHelp.RefGetField(typeof("UnityEngine.Playables.DirectorWrapMode"), "Hold", nil)

		if arg1_242.time then
			var1_246.time = math.clamp(arg1_242.time, 0, var1_246.duration)
		end

		local var3_246 = {}

		local function var4_246(arg0_248)
			switch(arg0_248.stringParameter, {
				TimelinePause = function()
					setDirectorSpeed(var1_246, 0)
				end,
				TimelineResume = function()
					arg0_242.timelineSpeed = 1

					setDirectorSpeed(var1_246, 1)
				end,
				TimelinePlayOnTime = function()
					if arg0_248.intParameter == 0 or arg0_248.intParameter == var3_246.selectIndex then
						var1_246.time = arg0_248.floatParameter

						var1_246:RebuildGraph()
					end
				end,
				TimelineSelectStart = function()
					var3_246.selectIndex = nil

					if arg1_242.options then
						local var0_252 = arg1_242.options[arg0_248.intParameter]

						arg0_242:DoTimelineOption(var0_252, function(arg0_253)
							var3_246.selectIndex = arg0_253
							var3_246.optionIndex = var0_252[arg0_253].flag
						end)
					end
				end,
				TimelineTouchStart = function()
					var3_246.selectIndex = nil

					if arg1_242.touchs then
						local var0_254 = arg1_242.touchs[arg0_248.intParameter]

						arg0_242:DoTimelineTouch(arg1_242.touchs[arg0_248.intParameter], function(arg0_255)
							var3_246.selectIndex = arg0_255
							var3_246.optionIndex = var0_254[arg0_255].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not var3_246.selectIndex then
						var1_246.time = arg0_248.floatParameter

						var1_246:RebuildGraph()
					end
				end,
				TimelineAccompanyJump = function()
					if arg0_242.canTriggerAccompanyPerformance then
						arg0_242.canTriggerAccompanyPerformance = false

						local var0_257 = arg1_242.accompanys[arg0_248.intParameter]
						local var1_257 = var0_257[math.random(#var0_257)]

						var1_246.time = var1_257

						var1_246:RebuildGraph()
					end
				end,
				TimelineEnd = function()
					var3_246.finish = true

					setDirectorSpeed(var1_246, 0)
				end
			}, function()
				warning("other event trigger:" .. arg0_248.stringParameter)
			end)

			if var3_246.finish then
				arg0_242.timelineMark = var3_246
				arg0_242.timelineFinishCall = nil

				arg0_246()
			end
		end

		GetOrAddComponent(var0_246, "DftCommonSignalReceiver"):SetCommonEvent(var4_246)

		function arg0_242.timelineFinishCall()
			var4_246({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_242:HideCharacter()
		setActive(arg0_242.mainCameraTF, false)
		eachChild(arg0_242.rtTimelineScreen, function(arg0_261)
			setActive(arg0_261, false)
		end)
		setActive(arg0_242.rtTimelineScreen, true)
		setActive(arg0_242.rtTimelineScreen:Find("btn_skip"), arg0_242.inReplayTalk)
		TimelineSupport.InitTimeline(var1_246)
		TimelineSupport.InitSubtitle(var1_246, arg0_242.apartment:GetCallName())
		var1_246:Play()
		var1_246:Evaluate()
	end)
	table.insert(var0_242, function(arg0_262)
		arg0_242:ShowBlackScreen(true, function()
			arg0_242:UnloadTimelineScene(arg1_242.name, false, arg0_262)
		end)
	end)

	local var1_242 = arg0_242.artSceneInfo

	table.insert(var0_242, function(arg0_264)
		arg0_242:ChangeArtScene(var1_242, arg0_264)
	end)
	seriesAsync(var0_242, function()
		setActive(arg0_242.rtTimelineScreen, false)
		arg0_242:RevertCharacter()
		setActive(arg0_242.mainCameraTF, true)

		local var0_265 = arg0_242.timelineMark

		arg0_242.timelineMark = nil

		existCall(arg2_242, var0_265, function(arg0_266)
			arg0_242:ShowBlackScreen(false, arg0_266)
		end)
	end)
end

function var0_0.PlaySingleAction(arg0_267, arg1_267, arg2_267)
	local var0_267 = string.find(arg1_267, "^Face_")

	if tobool(var0_267) then
		arg0_267:PlayFaceAnim(arg1_267, arg2_267)

		return
	end

	arg0_267.animNameMap = arg0_267.animNameMap or {}
	arg0_267.animNameMap[arg0_267.ladyAnimator.StringToHash(arg1_267)] = arg1_267

	local var1_267 = {}

	if not arg0_267.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_267.ladyAnimBaseLayerIndex):IsName(arg1_267) then
		table.insert(var1_267, function(arg0_268)
			arg0_267.nowState = arg1_267
			arg0_267.stateCallback = arg0_268

			arg0_267.ladyAnimator:CrossFadeInFixedTime(arg1_267, 0.25, arg0_267.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_267, function(arg0_269)
			arg0_267.nowState = nil
			arg0_267.stateCallback = nil

			arg0_269()
		end)
	end

	seriesAsync(var1_267, arg2_267)
end

function var0_0.SwitchAnim(arg0_270, arg1_270, arg2_270)
	local var0_270 = string.find(arg1_270, "^Face_")

	if tobool(var0_270) then
		arg0_270:PlayFaceAnim(arg1_270, arg2_270)

		return
	end

	arg0_270.animNameMap = arg0_270.animNameMap or {}
	arg0_270.animNameMap[arg0_270.ladyAnimator.StringToHash(arg1_270)] = arg1_270

	local var1_270 = {}

	table.insert(var1_270, function(arg0_271)
		arg0_270.nowState = arg1_270
		arg0_270.stateCallback = arg0_271

		arg0_270.ladyAnimator:PlayInFixedTime(arg1_270, arg0_270.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_270, function(arg0_272)
		arg0_270.nowState = nil
		arg0_270.stateCallback = nil

		arg0_272()
	end)
	seriesAsync(var1_270, arg2_270)
end

function var0_0.PlayFaceAnim(arg0_273, arg1_273, arg2_273)
	arg0_273.ladyAnimator:CrossFadeInFixedTime(arg1_273, 0.2, arg0_273.ladyAnimFaceLayerIndex)
	existCall(arg2_273)
end

function var0_0.GetCurrentAnim(arg0_274)
	local var0_274 = arg0_274.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_274.ladyAnimBaseLayerIndex).shortNameHash

	return arg0_274.animNameMap[var0_274]
end

function var0_0.RegisterAnimCallback(arg0_275, arg1_275, arg2_275)
	arg0_275.animCallbacks[arg1_275] = arg2_275
end

function var0_0.SetCharacterAnimSpeed(arg0_276, arg1_276)
	arg0_276.ladyAnimator.speed = arg1_276
	arg0_276.ladyHeadIKComp.blinkSpeed = arg0_276.ladyHeadIKData.blinkSpeed * arg1_276

	if arg1_276 > 0 then
		arg0_276.ladyHeadIKComp.DampTime = arg0_276.ladyHeadIKData.DampTime / arg1_276
	else
		arg0_276.ladyHeadIKComp.DampTime = arg0_276.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_277, arg1_277)
	if arg1_277.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_277 = arg1_277.stringParameter
	local var1_277 = table.removebykey(arg0_277.animEventCallbacks, var0_277)

	existCall(var1_277)
end

function var0_0.RegisterAnimEventCallback(arg0_278, arg1_278, arg2_278)
	arg0_278.animEventCallbacks[arg1_278] = arg2_278
end

function var0_0.RegisterCameraBlendFinished(arg0_279, arg1_279, arg2_279)
	arg0_279.cameraBlendCallbacks[arg1_279] = arg2_279
end

function var0_0.UnRegisterCameraBlendFinished(arg0_280, arg1_280)
	arg0_280.cameraBlendCallbacks[arg1_280] = nil
end

function var0_0.OnCameraBlendFinished(arg0_281, arg1_281)
	if not arg1_281 then
		return
	end

	local var0_281 = table.removebykey(arg0_281.cameraBlendCallbacks, arg1_281)

	existCall(var0_281)
end

function var0_0.PlayHeartFX(arg0_282, arg1_282)
	local var0_282 = arg0_282.ladyDict[arg1_282]

	setActive(var0_282.effectHeart, false)
	setActive(var0_282.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_283, arg1_283)
	local var0_283 = arg1_283.name
	local var1_283 = arg0_283.expressionDict[var0_283]
	local var2_283 = 5

	if var1_283 then
		local var3_283 = var1_283.timer

		var3_283:Reset(nil, var2_283)
		var3_283:Start()

		if var1_283.instance then
			setActive(var1_283.instance, false)
			setActive(var1_283.instance, true)
		end

		return
	end

	local var4_283 = {
		name = var0_283,
		timer = Timer.New(function()
			arg0_283:RemoveExpression(var0_283)
		end, var2_283, 1, true)
	}

	arg0_283.expressionDict[var0_283] = var4_283

	arg0_283.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_283, var0_283, function(arg0_285)
		var4_283.instance = arg0_285

		setParent(arg0_285, arg0_283.ladyHeadCenter)
		setLocalPosition(arg0_285, Vector3(0, 0, -0.2))
		setActive(arg0_285, false)
		setActive(arg0_285, true)
	end, var4_283)
end

function var0_0.RemoveExpression(arg0_286, arg1_286)
	local var0_286 = arg0_286.expressionDict[arg1_286]

	if not var0_286 then
		return
	end

	arg0_286.loader:ClearRequest(var0_286)

	if var0_286.instance then
		arg0_286.loader:ReturnPrefab(var0_286.instance)
	end

	arg0_286.expressionDict[arg1_286] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_287, arg1_287)
	arg0_287.ladyWatchFloat = arg0_287.ladyWatchFloat or cloneTplTo(arg0_287.resTF:Find("vfx_talk_mark"), arg0_287.ladyHeadCenter)

	setActive(arg0_287.ladyWatchFloat, arg1_287)
end

function var0_0.RegisterGlobalVolume(arg0_288)
	local var0_288 = arg0_288.globalVolume
	local var1_288 = LuaHelper.GetOrAddVolumeComponent(var0_288, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_288 = LuaHelper.GetOrAddVolumeComponent(var0_288, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_288.originalCameraSettings = {
		depthOfField = {
			enabled = var1_288.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_288.gaussianStart.min,
				value = var1_288.gaussianStart.value
			},
			blurRadius = {
				min = var1_288.blurRadius.min,
				max = var1_288.blurRadius.max,
				value = var1_288.blurRadius.value
			}
		},
		postExposure = {
			value = var2_288.postExposure.value
		},
		contrast = {
			min = var2_288.contrast.min,
			max = var2_288.contrast.max,
			value = var2_288.contrast.value
		},
		saturate = {
			min = var2_288.saturation.min,
			max = var2_288.saturation.max,
			value = var2_288.saturation.value
		}
	}
	arg0_288.originalCameraSettings.depthOfField.enabled = true

	local var3_288 = var0_288:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_288.originalVolume = {
		profile = var3_288.sharedProfile,
		weight = var3_288.weight
	}
end

function var0_0.SettingCamera(arg0_289, arg1_289)
	arg0_289.activeCameraSettings = arg1_289

	local var0_289 = arg0_289.globalVolume
	local var1_289 = LuaHelper.GetOrAddVolumeComponent(var0_289, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_289 = LuaHelper.GetOrAddVolumeComponent(var0_289, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_289.enabled:Override(arg1_289.depthOfField.enabled)
	var1_289.gaussianStart:Override(arg1_289.depthOfField.focusDistance.value)
	var1_289.gaussianEnd:Override(arg1_289.depthOfField.focusDistance.value + arg1_289.depthOfField.focusDistance.length)
	var1_289.blurRadius:Override(arg1_289.depthOfField.blurRadius.value)
	var2_289.postExposure:Override(arg1_289.postExposure.value)
	var2_289.contrast:Override(arg1_289.contrast.value)
	var2_289.saturation:Override(arg1_289.saturate.value)
end

function var0_0.GetCameraSettings(arg0_290)
	return arg0_290.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_291)
	arg0_291:SettingCamera(arg0_291.originalCameraSettings)

	arg0_291.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_292, arg1_292, arg2_292)
	local var0_292 = arg0_292.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_292.activeProfileWeight = arg2_292

	if arg0_292.activeProfileName ~= arg1_292 then
		arg0_292.activeProfileName = arg1_292

		arg0_292.loader:LoadReference("dorm3d/scenesres/res/common", arg1_292, nil, function(arg0_293)
			var0_292.profile = arg0_293
			var0_292.weight = arg0_292.activeProfileWeight

			if arg0_292.activeCameraSettings then
				arg0_292:SettingCamera(arg0_292.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_292.weight = arg0_292.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_294)
	local var0_294 = arg0_294.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_294.profile = arg0_294.originalVolume.profile
	var0_294.weight = arg0_294.originalVolume.weight

	if arg0_294.activeCameraSettings then
		arg0_294:SettingCamera(arg0_294.activeCameraSettings)
	end

	arg0_294.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_295)
	local var0_295 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_295.originalCharacterColor = {
		color = var0_295.color,
		intensity = var0_295.intensity
	}
end

function var0_0.SetCharacterLight(arg0_296, arg1_296, arg2_296, arg3_296)
	local var0_296 = arg0_296.characterLight:GetComponent(typeof(Light))
	local var1_296 = Color.Lerp(arg0_296.originalCharacterColor.color, arg1_296, arg3_296)
	local var2_296 = math.lerp(arg0_296.originalCharacterColor.intensity, arg2_296, arg3_296)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_296, var2_296)
end

function var0_0.RevertCharacterLight(arg0_297)
	arg0_297:SetCharacterLight(arg0_297.originalCharacterColor.color, arg0_297.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_298, arg1_298, arg2_298)
	arg1_298 = arg1_298 or {}

	table.Foreach(arg0_298.clothComps, function(arg0_299, arg1_299)
		if arg1_299 == nil then
			return
		end

		setActive(arg1_299, arg1_298[arg0_299] == 1)
	end)
	table.Foreach(arg0_298.clothColliderDict, function(arg0_300, arg1_300)
		if arg1_300 == nil then
			return
		end

		setActive(arg1_300, false)
	end)

	if arg2_298 then
		table.Foreach(arg2_298, function(arg0_301, arg1_301)
			local var0_301 = arg0_298.clothColliderDict[arg1_301[1]]

			if var0_301 == nil then
				return
			end

			setActive(var0_301, arg1_301[2] == 1)

			if arg1_301[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_301, arg1_301[3], arg1_301[4])
		end)
	end
end

function var0_0.onBackPressed(arg0_302)
	if arg0_302.exited or arg0_302.retainCount > 0 then
		-- block empty
	else
		arg0_302:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_303, arg1_303, arg2_303)
	assert(tobool(arg0_303.lastSceneRootDict[arg1_303]) == arg2_303)

	if arg2_303 then
		table.Foreach(arg0_303.lastSceneRootDict[arg1_303], function(arg0_304, arg1_304)
			if IsNil(arg0_304) then
				return
			end

			setActive(arg0_304, arg1_304)
		end)

		arg0_303.lastSceneRootDict[arg1_303] = nil
	else
		arg0_303.lastSceneRootDict[arg1_303] = {}

		local var0_303 = SceneManager.GetSceneByName(arg1_303)

		table.IpairsCArray(var0_303:GetRootGameObjects(), function(arg0_305, arg1_305)
			if tostring(arg1_305.hideFlags) ~= "None" then
				return
			end

			arg0_303.lastSceneRootDict[arg1_303][arg1_305] = isActive(arg1_305)

			setActive(arg1_305, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_306, arg1_306, arg2_306)
	arg1_306 = string.lower(arg1_306)

	if arg1_306 == arg0_306.artSceneInfo then
		if arg1_306 == arg0_306.sceneInfo then
			arg0_306:SwitchDayNight(arg0_306.contextData.timeIndex)
			onNextTick(function()
				arg0_306:RefreshSlots()
				existCall(arg2_306)
			end)
		else
			existCall(arg2_306)
		end

		return
	end

	local var0_306 = {}
	local var1_306 = false
	local var2_306

	table.insert(var0_306, function(arg0_308)
		arg0_306.artSceneInfo = arg1_306

		if var1_306 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_309)
				var2_306 = arg0_309

				arg0_308()
			end)
		else
			arg0_308()
		end
	end)

	if arg1_306 == arg0_306.sceneInfo then
		table.insert(var0_306, function(arg0_310)
			setActive(arg0_306.slotRoot, true)

			local var0_310, var1_310 = unpack(string.split(arg0_306.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_310))
			arg0_306:EnableSceneDisplay(var0_310, true)
			arg0_306:SwitchDayNight(arg0_306.contextData.timeIndex)
			onNextTick(function()
				arg0_306:RefreshSlots()
			end)
			arg0_310()
		end)
	else
		var1_306 = true

		local var3_306, var4_306 = unpack(string.split(arg1_306, "|"))

		table.insert(var0_306, function(arg0_312)
			setActive(arg0_306.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_306 .. "/" .. var3_306 .. "_scene"), var3_306, LoadSceneMode.Additive, function(arg0_313, arg1_313)
				SceneManager.SetActiveScene(arg0_313)

				local var0_313 = getSceneRootTFDic(arg0_313).MainCamera

				if var0_313 then
					setActive(var0_313, false)
				end

				arg0_312()
			end)
		end)
	end

	if arg0_306.artSceneInfo == arg0_306.sceneInfo then
		table.insert(var0_306, function(arg0_314)
			local var0_314, var1_314 = unpack(string.split(arg0_306.sceneInfo, "|"))

			arg0_306:EnableSceneDisplay(var0_314, false)
			arg0_314()
		end)
	else
		local var5_306, var6_306 = unpack(string.split(arg0_306.artSceneInfo, "|"))

		table.insert(var0_306, function(arg0_315)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_306 .. "/" .. var5_306 .. "_scene"), var5_306, arg0_315)
		end)
	end

	table.insert(var0_306, function(arg0_316)
		arg0_316()

		if var1_306 then
			var2_306()
		end
	end)
	seriesAsync(var0_306, arg2_306)
end

function var0_0.LoadTimelineScene(arg0_317, arg1_317, arg2_317, arg3_317)
	arg1_317 = string.lower(arg1_317)

	if arg0_317.cacheSceneDic[arg1_317] then
		if not arg2_317 then
			arg0_317.timelineScene = arg1_317

			arg0_317:EnableSceneDisplay(arg1_317, true)
		end

		return existCall(arg3_317)
	end

	local var0_317 = {}
	local var1_317

	table.insert(var0_317, function(arg0_318)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_319)
			if arg0_317.waitForTimeline then
				arg0_317.waitForTimeline = arg0_319
				var1_317 = nil
			else
				var1_317 = arg0_319
			end

			arg0_318()
		end)
	end)
	table.insert(var0_317, function(arg0_320)
		local var0_320 = arg0_317.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_320 .. "/timeline/" .. arg1_317 .. "/" .. arg1_317 .. "_scene"), arg1_317, LoadSceneMode.Additive, function(arg0_321, arg1_321)
			local var0_321 = GameObject.Find("[actor]").transform

			arg0_317:HXCharacter(tf(var0_321))
			GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector)):Stop()
			arg0_320()
		end)
	end)
	table.insert(var0_317, function(arg0_322)
		arg0_317.sceneGroupDic[arg1_317] = arg0_317.apartment:GetConfigID()

		if arg2_317 then
			arg0_317.cacheSceneDic[arg1_317] = true

			arg0_317:EnableSceneDisplay(arg1_317, false)
		else
			arg0_317.timelineScene = arg1_317
		end

		arg0_322()
		existCall(var1_317)
	end)
	seriesAsync(var0_317, arg3_317)
end

function var0_0.UnloadTimelineScene(arg0_323, arg1_323, arg2_323, arg3_323)
	arg1_323 = string.lower(arg1_323)

	if arg0_323.timelineScene == arg1_323 then
		arg0_323.timelineScene = nil
	end

	if tobool(arg2_323) == tobool(arg0_323.cacheSceneDic[arg1_323]) then
		local var0_323 = getProxy(ApartmentProxy):getApartment(arg0_323.sceneGroupDic[arg1_323]):getConfig("asset_name")

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_323 .. "/timeline/" .. arg1_323 .. "/" .. arg1_323 .. "_scene"), arg1_323, function()
			arg0_323.cacheSceneDic[arg1_323] = nil
			arg0_323.sceneGroupDic[arg1_323] = nil
			arg0_323.lastSceneRootDict[arg1_323] = nil

			existCall(arg3_323)
		end)
	else
		arg0_323:EnableSceneDisplay(arg1_323, false)
		existCall(arg3_323)
	end
end

function var0_0.ChangeSubScene(arg0_325, arg1_325, arg2_325)
	arg1_325 = string.lower(arg1_325)

	warning(arg0_325.subSceneInfo, "->", arg1_325, arg1_325 == arg0_325.subSceneInfo)

	if arg1_325 == arg0_325.subSceneInfo then
		arg0_325.ladyActiveZone = arg0_325.walkBornPoint or arg0_325.ladyBaseZone

		arg0_325:ChangeCharacterPosition()
		arg0_325:ChangePlayerPosition(arg0_325.ladyActiveZone)
		arg0_325:TriggerLadyDistance()
		arg0_325:CheckInSector()
		existCall(arg2_325)

		return
	end

	local var0_325 = {}
	local var1_325 = false
	local var2_325

	table.insert(var0_325, function(arg0_326)
		arg0_325.subSceneInfo = arg1_325

		if var1_325 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_327)
				var2_325 = arg0_327

				arg0_326()
			end)
		else
			arg0_326()
		end
	end)

	if arg1_325 == arg0_325.sceneInfo then
		table.insert(var0_325, function(arg0_328)
			local var0_328, var1_328 = unpack(string.split(arg0_325.sceneInfo, "|"))

			arg0_325:ResetSceneStructure(SceneManager.GetSceneByName(var0_328 .. "_base"))
			arg0_325:RefreshSlots()

			arg0_325.ladyActiveZone = arg0_325.walkBornPoint or arg0_325.ladyBaseZone

			arg0_325:ChangeCharacterPosition()
			arg0_325:ChangePlayerPosition(arg0_325.ladyActiveZone)
			arg0_325:TriggerLadyDistance()
			arg0_325:CheckInSector()
			arg0_328()
		end)
	else
		var1_325 = true

		local var3_325, var4_325 = unpack(string.split(arg1_325, "|"))
		local var5_325 = var3_325 .. "_base"

		table.insert(var0_325, function(arg0_329)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_325 .. "/" .. var5_325 .. "_scene"), var5_325, LoadSceneMode.Additive, arg0_329)
		end)
		table.insert(var0_325, function(arg0_330)
			arg0_325:ResetSceneStructure(SceneManager.GetSceneByName(var5_325))

			arg0_325.ladyActiveZone = arg0_325.walkBornPoint or "Default"

			arg0_325:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_325:ChangeCharacterPosition()
				arg0_325:ChangePlayerPosition(arg0_325.ladyActiveZone)
				arg0_325:TriggerLadyDistance()
				arg0_325:CheckInSector()
				arg0_330()
			end)
		end)
	end

	if arg0_325.subSceneInfo == arg0_325.sceneInfo then
		table.insert(var0_325, function(arg0_332)
			local var0_332 = Clone(arg0_325.room)

			var0_332.furnitures = {}

			arg0_325:RefreshSlots(var0_332)
			arg0_332()
		end)
	else
		local var6_325, var7_325 = unpack(string.split(arg0_325.subSceneInfo, "|"))
		local var8_325 = var6_325 .. "_base"

		table.insert(var0_325, function(arg0_333)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_325 .. "/" .. var8_325 .. "_scene"), var8_325, arg0_333)
		end)
	end

	table.insert(var0_325, function(arg0_334)
		arg0_334()

		if var1_325 then
			var2_325()
		end
	end)
	seriesAsync(var0_325, arg2_325)
end

function var0_0.TransformMesh(arg0_335)
	local var0_335 = arg0_335.sharedMesh
	local var1_335 = {}
	local var2_335 = arg0_335.transform:TransformPoint(var0_335.vertices[0])
	local var3_335 = arg0_335.transform:TransformPoint(var0_335.vertices[1])
	local var4_335 = arg0_335.transform:TransformPoint(var0_335.vertices[2])

	var1_335.horizontal = var3_335 - var2_335
	var1_335.verticle = var4_335 - var2_335
	var1_335.origin = var2_335

	return var1_335
end

function var0_0.GetRatio(arg0_336, arg1_336)
	local var0_336 = Vector2.zero

	var0_336.x = Vector3.Dot(arg0_336.horizontal, arg1_336) / arg0_336.horizontal.sqrMagnitude
	var0_336.y = Vector3.Dot(arg0_336.verticle, arg1_336) / arg0_336.verticle.sqrMagnitude

	return var0_336
end

function var0_0.GetPostionByRatio(arg0_337, arg1_337)
	return arg0_337.horizontal * arg1_337.x + arg0_337.verticle * arg1_337.y + arg0_337.origin
end

function var0_0.IsPointInSector(arg0_338, arg1_338)
	local var0_338 = arg1_338 - Vector3.New(unpack(arg0_338.Position))

	if var0_338.magnitude > arg0_338.Radius then
		return false
	end

	local var1_338 = Quaternion.Euler(unpack(arg0_338.Rotation))

	return Vector3.Angle(var1_338 * Vector3.forward, var0_338) <= arg0_338.Angle / 2
end

function var0_0.willExit(arg0_339)
	arg0_339.joystickTimer:Stop()
	arg0_339.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_339.updateHandler)
	arg0_339:StopIKHandTimer()

	if arg0_339.moveTimer then
		arg0_339.moveTimer:Stop()

		arg0_339.moveTimer = nil
	end

	if arg0_339.moveWaitTimer then
		arg0_339.moveWaitTimer:Stop()

		arg0_339.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_339.furnitures) then
		eachChild(arg0_339.furnitures, function(arg0_340)
			local var0_340 = GetComponent(arg0_340, typeof(EventTriggerListener))

			if not var0_340 then
				return
			end

			var0_340:ClearEvents()
		end)
	end

	for iter0_339, iter1_339 in pairs(arg0_339.ladyDict) do
		arg0_339:ResetActiveIKs(iter1_339)
		GetComponent(iter1_339.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_339.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_339.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_339.blockLayer, arg0_339._tf)
	table.Foreach(arg0_339.expressionDict, function(arg0_341)
		arg0_339:RemoveExpression(arg0_341)
	end)
	arg0_339.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_339 = {}

	if arg0_339.timelineScene and not arg0_339.cacheSceneDic[arg0_339.timelineScene] then
		local var1_339 = arg0_339.timelineScene

		arg0_339.timelineScene = nil

		local var2_339 = getProxy(ApartmentProxy):getApartment(arg0_339.sceneGroupDic[var1_339]):getConfig("asset_name")

		table.insert(var0_339, function(arg0_342)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_339 .. "/timeline/" .. var1_339 .. "/" .. var1_339 .. "_scene"), var1_339, arg0_342)
		end)
	end

	for iter2_339, iter3_339 in pairs(arg0_339.cacheSceneDic) do
		if iter3_339 then
			local var3_339 = getProxy(ApartmentProxy):getApartment(arg0_339.sceneGroupDic[iter2_339]):getConfig("asset_name")

			table.insert(var0_339, function(arg0_343)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_339 .. "/timeline/" .. iter2_339 .. "/" .. iter2_339 .. "_scene"), iter2_339, arg0_343)
			end)
		end
	end

	for iter4_339, iter5_339 in ipairs({
		arg0_339.sceneInfo,
		arg0_339.subSceneInfo ~= arg0_339.sceneInfo and arg0_339.subSceneInfo or nil
	}) do
		local var4_339, var5_339 = unpack(string.split(iter5_339, "|"))
		local var6_339 = var4_339 .. "_base"

		table.insert(var0_339, function(arg0_344)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_339 .. "/" .. var6_339 .. "_scene"), var6_339, arg0_344)
		end)
	end

	for iter6_339, iter7_339 in ipairs({
		arg0_339.sceneInfo,
		arg0_339.artSceneInfo ~= arg0_339.sceneInfo and arg0_339.artSceneInfo or nil
	}) do
		local var7_339, var8_339 = unpack(string.split(iter7_339, "|"))

		table.insert(var0_339, function(arg0_345)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_339 .. "/" .. var7_339 .. "_scene"), var7_339, arg0_345)
		end)
	end

	seriesAsync(var0_339, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_347 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_347 = SystemInfo.deviceModel or ""

			local function var2_347(arg0_348)
				local var0_348 = string.match(arg0_348, "iPad(%d+)")
				local var1_348 = tonumber(var0_348)

				if var1_348 and var1_348 >= 8 then
					return true
				end

				return false
			end

			local function var3_347(arg0_349)
				local var0_349 = string.match(arg0_349, "iPhone(%d+)")
				local var1_349 = tonumber(var0_349)

				if var1_349 and var1_349 >= 13 then
					return true
				end

				return false
			end

			if var2_347(var1_347) or var3_347(var1_347) then
				var0_347 = DevicePerformanceLevel.High
			end
		end

		local var4_347 = var0_347 == DevicePerformanceLevel.High and 3 or var0_347 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_347)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_347
	end
end

function var0_0.SettingQuality()
	local var0_350 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_350)
end

function var0_0.SetMagicaCollider(arg0_351, arg1_351, arg2_351)
	local var0_351 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_351, "StartRadius", arg0_351, arg1_351)
	ReflectionHelp.RefSetProperty(var0_351, "EndRadius", arg0_351, arg2_351)
end

return var0_0
