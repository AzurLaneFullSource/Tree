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
			local var3_66 = var1_66:LoadAssetSync(var2_66, typeof(Material), true, false)

			var0_65[arg0_66] = var3_66

			warning("Replace HX Material", arg0_64.hxMatDict[var0_66][2])
		end)

		if var1_65 then
			arg1_65.sharedMaterials = var0_65
		end
	end)
end

function var0_0.InitCharacter(arg0_67, arg1_67)
	arg0_67.lady = arg0_67.ladyGameobject.transform

	arg0_67.lady:SetParent(arg0_67.mainCameraTF)
	arg0_67.lady:SetParent(nil)

	arg0_67.ladyHeadIKComp = arg0_67.lady:GetComponent(typeof(HeadAimIK))
	arg0_67.ladyHeadIKComp.AimTarget = arg0_67.mainCameraTF:Find("AimTarget")
	arg0_67.ladyHeadIKData = {
		DampTime = arg0_67.ladyHeadIKComp.DampTime,
		blinkSpeed = arg0_67.ladyHeadIKComp.blinkSpeed,
		BodyWeight = arg0_67.ladyHeadIKComp.BodyWeight,
		HeadWeight = arg0_67.ladyHeadIKComp.HeadWeight
	}

	local var0_67 = {}

	table.Foreach(var1_0, function(arg0_68, arg1_68)
		var0_67[arg1_68] = arg0_68
	end)

	arg0_67.ladyAnimator = arg0_67.lady:GetComponent(typeof(Animator))
	arg0_67.ladyAnimBaseLayerIndex = arg0_67.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_67.ladyAnimFaceLayerIndex = arg0_67.ladyAnimator:GetLayerIndex("Face")
	arg0_67.ladyBoneMaps = {}

	local var1_67 = arg0_67.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var1_67, function(arg0_69, arg1_69)
		if arg1_69.name == "BodyCollider" then
			arg0_67.ladyCollider = arg1_69
		elseif arg1_69.name == "Interest" then
			arg0_67.ladyInterestRoot = arg1_69
		elseif arg1_69.name == "Head Center" then
			arg0_67.ladyHeadCenter = arg1_69
		end

		if var0_67[arg1_69.name] then
			arg0_67.ladyBoneMaps[var0_67[arg1_69.name]] = arg1_69
		end
	end)

	arg0_67.ladyColliders = {}
	arg0_67.ladyTouchColliders = {}

	table.IpairsCArray(arg0_67.lady:GetComponentsInChildren(typeof(UnityEngine.Collider), true), function(arg0_70, arg1_70)
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

		arg0_67.ladyColliders[var2_70] = child

		if var2_70 ~= "Body" then
			table.insert(arg0_67.ladyTouchColliders, child)
			setActive(child, false)
		end
	end)
	arg0_67:HXCharacter(arg0_67.lady)
	;(function()
		local var0_71 = "dorm3d/effect/prefab/function/vfx_function_aixin02"
		local var1_71 = "vfx_function_aixin02"

		arg0_67.loader:GetPrefab(var0_71, var1_71, function(arg0_72)
			arg0_67.effectHeart = arg0_72

			setActive(arg0_72, false)
			onNextTick(function()
				setParent(arg0_67.effectHeart, arg0_67.ladyHeadCenter)
			end)
		end)
	end)()

	arg0_67.clothComps = {}

	table.IpairsCArray(arg0_67.lady:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_74, arg1_74)
		table.insert(arg0_67.clothComps, arg1_74)
	end)

	arg0_67.clothColliderDict = {}

	table.IpairsCArray(arg0_67.lady:GetComponentsInChildren(typeof("MagicaCloth.MagicaCapsuleCollider"), true), function(arg0_75, arg1_75)
		arg0_67.clothColliderDict[arg1_75.name] = arg1_75
	end)
	arg0_67:EnableCloth(false)

	arg0_67.ladyIKRoot = arg0_67.lady:Find("IKLayers")

	eachChild(arg0_67.ladyIKRoot, function(arg0_76)
		setActive(arg0_76, false)
	end)
	GetComponent(arg0_67.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_77, arg1_77)
		if arg1_77.rawPointerPress.transform == arg0_67.ladyCollider then
			arg0_67:emit(var0_0.CLICK_CHARACTER, arg1_67)
		else
			local var0_77 = table.keyof(arg0_67.ladyColliders, arg1_77.rawPointerPress.transform)

			arg0_67:emit(var0_0.ON_TOUCH_CHARACTER, var0_0.BONE_TO_TOUCH[var0_77] or arg1_77.rawPointerPress.name)
		end
	end)
	arg0_67.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_78)
		if arg0_67.nowState and arg0_78.animatorStateInfo:IsName(arg0_67.nowState) then
			existCall(arg0_67.stateCallback)

			return
		end

		local var0_78 = arg0_78.animatorStateInfo

		for iter0_78, iter1_78 in pairs(arg0_67.animCallbacks) do
			if var0_78:IsName(iter0_78) then
				warning("Active", iter0_78)

				local var1_78 = table.removebykey(arg0_67.animCallbacks, iter0_78)

				existCall(var1_78)

				return
			end
		end

		if arg0_78.stringParameter ~= "" then
			arg0_67:OnAnimationEvent(arg0_78)
		end
	end)

	arg0_67.animEventCallbacks = {}
	arg0_67.animCallbacks = {}
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
	arg0_129:SyncInterestTransform()
end

function var0_0.SyncInterestTransform(arg0_130)
	arg0_130.ladyInterest.position = arg0_130.ladyInterestRoot.position
	arg0_130.ladyInterest.rotation = arg0_130.ladyInterestRoot.rotation
end

function var0_0.ChangePlayerPosition(arg0_131, arg1_131)
	arg1_131 = arg1_131 or arg0_131.contextData.inFurnitureName

	local var0_131 = arg0_131.furnitures:Find(arg1_131):Find("PlayerPoint").position

	arg0_131.player.position = var0_131
	arg0_131.cameras[var0_0.CAMERA.POV].transform.position = arg0_131.playerEye.position

	local var1_131 = arg0_131.ladyInterest.position - arg0_131.playerEye.position
	local var2_131 = Quaternion.LookRotation(var1_131).eulerAngles
	local var3_131 = var2_131.y
	local var4_131 = var2_131.x
	local var5_131 = arg0_131.compPov.m_HorizontalAxis

	var5_131.Value = arg0_131:GetNearestAngle(var3_131, var5_131.m_MinValue, var5_131.m_MaxValue)
	arg0_131.compPov.m_HorizontalAxis = var5_131

	local var6_131 = arg0_131.compPov.m_VerticalAxis

	var6_131.Value = var4_131
	arg0_131.compPov.m_VerticalAxis = var6_131
end

function var0_0.GetAttachedFurnitureName(arg0_132)
	return arg0_132.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_133, arg1_133)
	return underscore.detect(arg0_133.attachedPoints, function(arg0_134)
		return arg0_134.name == arg1_133
	end)
end

function var0_0.GetSlotByID(arg0_135, arg1_135)
	return arg0_135.displaySlots[arg1_135] and arg0_135.displaySlots[arg1_135].trans
end

function var0_0.GetScreenPosition(arg0_136, arg1_136)
	local var0_136 = arg0_136.raycastCamera:WorldToScreenPoint(arg1_136)

	if var0_136.z < 0 then
		var0_136.x = var0_136.x + (var0_136.x < 0 and -1 or 1) * Screen.width
		var0_136.y = var0_136.y + (var0_136.y < 0 and -1 or 1) * Screen.height
		var0_136.z = -var0_136.z
	end

	return var0_136
end

function var0_0.GetLocalPosition(arg0_137, arg1_137, arg2_137)
	return LuaHelper.ScreenToLocal(arg2_137, arg1_137, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_138)
	return arg0_138.modelRoot
end

function var0_0.ShiftZone(arg0_139, arg1_139, arg2_139)
	local var0_139 = arg0_139:GetFurnitureByName(arg1_139)

	if not var0_139 then
		errorMsg(arg1_139 .. " Not Find")
		existCall(arg2_139)

		return
	end

	seriesAsync({
		function(arg0_140)
			arg0_139:emit(var0_0.SHOW_BLOCK)
			arg0_139:ShowBlackScreen(true, arg0_140)
		end,
		function(arg0_141)
			if arg0_139.shiftLady or arg0_139.room:isPersonalRoom() then
				local var0_141 = arg0_139.shiftLady or arg0_139.apartment:GetConfigID()

				arg0_139.shiftLady = nil
				arg0_139.contextData.ladyZone[var0_141] = var0_139.name

				local var1_141 = arg0_139.ladyDict[var0_141]

				var1_141.ladyBaseZone = arg0_139.contextData.ladyZone[var0_141]
				var1_141.ladyActiveZone = arg0_139.contextData.ladyZone[var0_141]

				if var1_141:GetBlackboardValue("inPending") then
					var1_141:SetOutPending()
					var1_141:SwitchAnim(var0_0.ANIM.IDLE)
					onNextTick(function()
						var1_141:ChangeCharacterPosition()
						arg0_141()
					end)
				else
					var1_141:ChangeCharacterPosition()
					arg0_141()
				end
			else
				arg0_141()
			end
		end,
		function(arg0_143)
			arg0_139.contextData.inFurnitureName = var0_139.name

			arg0_139:ChangePlayerPosition()
			arg0_139:TriggerLadyDistance()
			arg0_139:CheckInSector()
			arg0_143()
		end,
		function(arg0_144)
			arg0_139:UpdateZoneList()
			arg0_139:ShowBlackScreen(false, arg0_144)
		end,
		function(arg0_145)
			arg0_139:emit(var0_0.HIDE_BLOCK)
			arg0_145()
		end
	}, arg2_139)
end

function var0_0.WalkByRootMotionLoop(arg0_146, arg1_146, arg2_146)
	if arg1_146.pathPending then
		arg2_146:SetFloat("Speed", 0)

		return
	end

	arg2_146:SetFloat("Speed", 1)

	local var0_146 = arg1_146.path.corners

	if var0_146.Length > 1 then
		local var1_146 = var0_146[1] - arg1_146.transform.position

		var1_146.y = 0

		local var2_146 = Quaternion.LookRotation(var1_146)
		local var3_146 = arg1_146.transform.rotation
		local var4_146 = 1
		local var5_146 = Damp(1, var4_146, Time.deltaTime)

		arg1_146.transform.rotation = Quaternion.Lerp(var3_146, var2_146, var5_146)
	end
end

function var0_0.ActiveCamera(arg0_147, arg1_147)
	local var0_147 = isActive(arg1_147)

	table.Foreach(arg0_147.cameras, function(arg0_148, arg1_148)
		setActive(arg1_148, arg1_148 == arg1_147)
	end)

	if var0_147 then
		arg0_147:OnCameraBlendFinished(arg1_147)
	end
end

function var0_0.ShowBlackScreen(arg0_149, arg1_149, arg2_149)
	local var0_149 = arg0_149.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_149 and 0 or 0.3
	}

	setImageColor(arg0_149.blackLayer, Color.NewHex(var0_149.color))
	setActive(arg0_149.blackLayer, true)
	setCanvasGroupAlpha(arg0_149.blackLayer, arg1_149 and 0 or 1)
	arg0_149:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_149 then
			setActive(arg0_149.blackLayer, false)
		end

		existCall(arg2_149)
	end, GetComponent(arg0_149.blackLayer, typeof(CanvasGroup)), arg1_149 and 1 or 0, var0_149.time):setDelay(var0_149.delay)
end

function var0_0.RegisterOrbits(arg0_151, arg1_151)
	arg0_151 = arg0_151.scene
	arg0_151.orbits = {
		original = arg1_151.m_Orbits
	}
	arg0_151.orbits.current = _.range(3):map(function(arg0_152)
		local var0_152 = arg0_151.orbits.original[arg0_152 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_152.m_Height, var0_152.m_Radius)
	end)
	arg0_151.surroudCamera = arg1_151
end

function var0_0.SetCameraObrits(arg0_153)
	local var0_153 = arg0_153.surroudCamera

	if not var0_153 then
		return
	end

	local var1_153 = arg0_153.orbits.original[1]

	for iter0_153 = 0, #arg0_153.orbits.current - 1 do
		local var2_153 = arg0_153.orbits.current[iter0_153 + 1]
		local var3_153 = arg0_153.orbits.original[iter0_153]

		var2_153.m_Height = math.lerp(var1_153.m_Height, var3_153.m_Height, arg0_153.pinchValue)
		var2_153.m_Radius = var3_153.m_Radius * arg0_153.pinchValue
	end

	var0_153.m_Orbits = arg0_153.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_154)
	arg0_154 = arg0_154.scene

	local var0_154 = arg0_154.surroudCamera

	if not var0_154 then
		return
	end

	for iter0_154 = 0, #arg0_154.orbits.current - 1 do
		local var1_154 = arg0_154.orbits.current[iter0_154 + 1]
		local var2_154 = arg0_154.orbits.original[iter0_154]

		var1_154.m_Height = var2_154.m_Height
		var1_154.m_Radius = var2_154.m_Radius
	end

	var0_154.m_Orbits = arg0_154.orbits.current
	arg0_154.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_155, arg1_155, arg2_155)
	local var0_155 = {
		base = function(arg0_156)
			arg0_155:RegisterCameraBlendFinished(arg0_155.cameras[var0_0.CAMERA.POV], arg0_156)
			arg0_155:ActiveCamera(arg0_155.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_157)
			assert(arg0_155.apartment)
			arg0_155.ladyDict[arg0_155.apartment:GetConfigID()]:SetCameraLady()
			arg0_155:RegisterCameraBlendFinished(arg0_155.cameras[var0_0.CAMERA.ROLE], arg0_157)
			arg0_155:ActiveCamera(arg0_155.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_158)
			arg0_155:RegisterCameraBlendFinished(arg0_155.cameras[var0_0.CAMERA.POV], arg0_158)
			arg0_155:ActiveCamera(arg0_155.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_159)
			arg0_159()
		end,
		gift = function(arg0_160)
			assert(arg0_155.apartment)
			arg0_155.ladyDict[arg0_155.apartment:GetConfigID()]:SetCameraLady()
			arg0_155:RegisterCameraBlendFinished(arg0_155.cameras[var0_0.CAMERA.GIFT], arg0_160)
			arg0_155:ActiveCamera(arg0_155.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_161)
			assert(arg0_155.apartment)
			arg0_155.ladyDict[arg0_155.apartment:GetConfigID()]:SetCameraLady()

			arg0_155.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_155.cameraRole.transform.position

			arg0_155:RegisterCameraBlendFinished(arg0_155.cameras[var0_0.CAMERA.ROLE2], arg0_161)
			arg0_155:ActiveCamera(arg0_155.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_162)
			assert(arg0_155.apartment)
			arg0_155.ladyDict[arg0_155.apartment:GetConfigID()]:SetCameraLady()
			arg0_155:RegisterCameraBlendFinished(arg0_155.cameras[var0_0.CAMERA.TALK], arg0_162)
			arg0_155:ActiveCamera(arg0_155.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_155 = {}

	table.insert(var1_155, function(arg0_163)
		switch(arg1_155, var0_155, arg0_163, arg0_163)
	end)
	seriesAsync(var1_155, arg2_155)
end

function var0_0.SetIKStatus(arg0_164, arg1_164, arg2_164)
	warning("Set IKStatus " .. (arg1_164.id or "NIL"))

	arg0_164.enableIKTip = true

	setActive(arg0_164.ladyCollider, false)
	_.each(arg0_164.ladyTouchColliders, function(arg0_165)
		setActive(arg0_165, true)
	end)
	table.clear(arg0_164.readyIKLayers)

	arg0_164.blockIK = nil

	local var0_164 = _.map(arg1_164.ik_id, function(arg0_166)
		return arg0_166[1]
	end)

	table.Foreach(var0_164, function(arg0_167, arg1_167)
		local var0_167 = Dorm3dIK.New({
			configId = arg1_167
		})

		table.insert(arg0_164.readyIKLayers, {
			ikData = var0_167
		})

		arg0_164.cacheIKInfos[var0_167] = {}

		local var1_167 = var0_167:GetControllerPath()
		local var2_167 = arg0_164.ladyIKRoot:Find(var1_167):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
		local var3_167 = {}

		table.IpairsCArray(var2_167.IKComponents, function(arg0_168, arg1_168)
			var3_167[arg0_168 + 1] = arg1_168:GetIKSolver()
		end)

		arg0_164.cacheIKInfos[var0_167].solvers = var3_167

		local var4_167 = _.map(var3_167, function(arg0_169)
			return arg0_169.IKPositionWeight
		end)

		arg0_164.cacheIKInfos[var0_167].weights = var4_167
	end)

	arg0_164.camBrain.enabled = false

	if arg0_164.cameras[var0_0.CAMERA.IK_WATCH] then
		setActive(arg0_164.cameras[var0_0.CAMERA.IK_WATCH], false)

		arg0_164.cameras[var0_0.CAMERA.IK_WATCH] = nil
	end

	local var1_164 = arg0_164.cameraRoot:Find(arg1_164.ik_camera)

	assert(var1_164, "Missing IKCamera")

	arg0_164.cameras[var0_0.CAMERA.IK_WATCH] = var1_164

	arg0_164:ActiveCamera(arg0_164.cameras[var0_0.CAMERA.IK_WATCH])

	arg0_164.camBrain.enabled = true

	local var2_164 = var1_164:GetComponent(typeof(Cinemachine.CinemachineFreeLook))

	if var2_164 then
		arg0_164:RegisterOrbits(var2_164)
	end

	arg0_164:SettingHeadAimIK(arg0_164, arg0_164.ikConfig.head_track)
	arg0_164:ResetIKTipTimer()
	arg0_164:SwitchAnim(arg1_164.character_action)
	onNextTick(function()
		local var0_170 = arg0_164.furnitures:Find(arg1_164.character_position)

		arg0_164.lady.position = var0_170:Find("StayPoint").position
		arg0_164.lady.rotation = var0_170:Find("StayPoint").rotation

		arg0_164:EnableCloth(false)
		arg0_164:EnableCloth(arg1_164.use_cloth, arg1_164.cloth_colliders)
		existCall(arg2_164)
	end)
end

function var0_0.ExitIKStatus(arg0_171, arg1_171, arg2_171)
	arg0_171.enableIKTip = false

	setActive(arg0_171.ladyCollider, true)
	_.each(arg0_171.ladyTouchColliders, function(arg0_172)
		setActive(arg0_172, false)
	end)
	arg0_171:ResetActiveIKs(arg0_171)
	table.clear(arg0_171.readyIKLayers)
	table.clear(arg0_171.cacheIKInfos)
	table.clear(arg0_171.activeIKLayers)
	table.clear(arg0_171.holdingStatus)
	eachChild(arg0_171.ladyIKRoot, function(arg0_173)
		setActive(arg0_173, false)
	end)
	setActive(arg0_171:GetIKTipsRootTF(), false)
	arg0_171:RevertCameraOrbit()
	setActive(arg0_171.cameras[var0_0.CAMERA.IK_WATCH], false)

	arg0_171.cameras[var0_0.CAMERA.IK_WATCH] = nil

	arg0_171:EnableCloth(false)
	arg0_171:ResetHeadAimIK(arg0_171)
	arg0_171:SwitchAnim(arg1_171.character_action)
	onNextTick(function()
		if arg1_171.character_position then
			arg0_171.ladyActiveZone = arg1_171.character_position
		else
			arg0_171.ladyActiveZone = arg0_171.ladyBaseZone
		end

		arg0_171:ChangeCharacterPosition()
		arg0_171:TriggerLadyDistance()
		arg0_171:CheckInSector()
		existCall(arg2_171)
	end)
end

function var0_0.EnableIKLayer(arg0_175, arg1_175, arg2_175)
	warning("ENABLEIK", arg2_175:GetConfigID())

	local var0_175 = arg2_175:GetControllerPath()
	local var1_175 = arg1_175.ladyIKRoot:Find(var0_175):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))
	local var2_175 = tf(var1_175):Find("Container")
	local var3_175 = {
		ikData = arg2_175,
		list = var1_175
	}

	if not arg1_175.holdingStatus[arg2_175] then
		var3_175.rect = arg2_175:GetRect()

		local var4_175 = arg2_175:GetActionTriggerParams()

		if var4_175[1] == Dorm3dIK.ACTION_TRIGGER.RELEASE_ON_TARGET or var4_175[1] == Dorm3dIK.ACTION_TRIGGER.TOUCH_TARGET then
			var3_175.triggerRect = arg2_175:GetTriggerRect()
		end

		local var5_175 = var2_175:Find("SubTargets")
		local var6_175 = {}

		assert(var5_175)

		local var7_175 = arg2_175:GetSubTargets()
		local var8_175 = arg2_175:GetPlaneRotations()
		local var9_175 = arg2_175:GetPlaneScales()

		table.Foreach(var7_175, function(arg0_176, arg1_176)
			local var0_176 = var5_175:Find(arg1_176[1])
			local var1_176 = var0_176:Find("Plane")

			if var8_175[arg0_176] then
				var1_176.localRotation = var8_175[arg0_176]
				var1_176.localScale = var9_175[arg0_176]
			end

			local var2_176 = var0_176:Find("Target")
			local var3_176 = var0_0.TransformMesh(var1_176:GetComponent(typeof(UnityEngine.MeshCollider)))
			local var4_176 = arg1_175.ladyBoneMaps[arg1_176[1]]

			var3_176.origin = var4_176.position

			local var5_176 = var3_175.rect
			local var6_176 = Vector2.New(var5_176.center.x / var5_176.width, var5_176.center.y / var5_176.height)

			var1_176.position = var0_0.GetPostionByRatio(var3_176, var6_176)
			var2_176.position = var4_176.position

			local var7_176 = {
				planeData = var3_176,
				target = var2_176,
				useOffset = tobool(arg1_176)
			}

			table.insert(var6_175, var7_176)
		end)

		var3_175.subPlanes = var6_175

		setActive(var1_175, true)
	else
		var3_175 = arg1_175.holdingStatus[arg2_175].ikHandler
	end

	if #arg2_175:GetHeadTrackPath() > 0 then
		arg0_175:SettingHeadAimIK(arg1_175, {
			2,
			arg2_175:GetHeadTrackPath()
		}, true)
	end

	local var10_175 = arg2_175:GetTriggerFaceAnim()

	if #var10_175 > 0 then
		arg0_175:PlayFaceAnim(var10_175)
	end

	setActive(arg0_175:GetIKHandTF(), true)
	eachChild(arg0_175:GetIKHandTF(), function(arg0_177)
		setActive(arg0_177, false)
	end)
	arg0_175:StopIKHandTimer()
	setActive(arg0_175:GetIKHandTF():Find("Begin"), true)

	arg1_175.ikHandTimer = Timer.New(function()
		setActive(arg0_175:GetIKHandTF():Find("Begin"), false)
		setActive(arg0_175:GetIKHandTF():Find("Normal"), true)
	end, 0.5, 1)

	arg1_175.ikHandTimer:Start()

	arg1_175.ikNextCheckStamp = Time.time + var0_0.IK_STATUS_DELTA

	arg0_175:emit(var0_0.ON_IK_STATUS_CHANGED, arg2_175:GetConfigID(), var0_0.IK_STATUS.BEGIN)
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataTouch(arg0_175.apartment.configId, arg0_175.apartment.level, arg1_175.ikConfig.character_action, arg2_175:GetTriggerParams()[2], arg0_175.room:GetConfigID()))

	return var3_175
end

function var0_0.DeactiveIKLayer(arg0_179, arg1_179)
	if #arg1_179:GetHeadTrackPath() > 0 then
		arg0_179:SettingHeadAimIK(arg0_179, arg0_179.ikConfig.head_track)
	end

	arg0_179:StopIKHandTimer()
	setActive(arg0_179:GetIKHandTF():Find("Begin"), false)
	setActive(arg0_179:GetIKHandTF():Find("Normal"), false)
	setActive(arg0_179:GetIKHandTF():Find("End"), true)

	arg0_179.ikHandTimer = Timer.New(function()
		setActive(arg0_179:GetIKHandTF():Find("End"), false)
		setActive(arg0_179:GetIKHandTF(), false)
	end, 0.5, 1)

	arg0_179.ikHandTimer:Start()
end

function var0_0.StopIKHandTimer(arg0_181)
	if not arg0_181.ikHandTimer then
		return
	end

	arg0_181.ikHandTimer:Stop()

	arg0_181.ikHandTimer = nil
end

function var0_0.RevertIKLayer(arg0_182, arg1_182, arg2_182)
	seriesAsync({
		function(arg0_183)
			if arg1_182 >= 999 then
				return arg0_183()
			end

			arg0_182:PlayIKRevert(arg0_182, arg1_182, arg0_183)
		end,
		arg2_182
	})
end

function var0_0.RevertAllIKLayer(arg0_184, arg1_184, arg2_184)
	table.insertto(arg0_184.activeIKLayers, _.keys(arg0_184.holdingStatus))
	table.clear(arg0_184.holdingStatus)
	arg0_184.RevertIKLayer(arg0_184, arg1_184, arg2_184)
end

function var0_0.PlayIKRevert(arg0_185, arg1_185, arg2_185, arg3_185)
	local var0_185 = Time.time

	function arg0_185.ikRevertHandler()
		local var0_186 = Time.time - var0_185

		_.each(arg1_185.activeIKLayers, function(arg0_187)
			local var0_187 = 1

			if arg2_185 > 0 then
				var0_187 = var0_186 / arg2_185
			end

			local var1_187 = arg1_185.cacheIKInfos[arg0_187].solvers
			local var2_187 = arg1_185.cacheIKInfos[arg0_187].weights

			table.Foreach(var1_187, function(arg0_188, arg1_188)
				arg1_188.IKPositionWeight = math.lerp(var2_187[arg0_188], 0, var0_187)
			end)
		end)

		if var0_186 >= arg2_185 then
			arg0_185:ResetActiveIKs(arg1_185)

			arg0_185.ikRevertHandler = nil

			existCall(arg3_185)
		end
	end

	arg0_185.ikRevertHandler()
end

function var0_0.ResetActiveIKs(arg0_189, arg1_189)
	table.insertto(arg0_189.activeIKLayers, _.keys(arg0_189.holdingStatus))
	table.clear(arg0_189.holdingStatus)
	_.each(arg1_189.activeIKLayers, function(arg0_190)
		local var0_190 = arg0_190:GetControllerPath()
		local var1_190 = arg1_189.ladyIKRoot:Find(var0_190):GetComponent(typeof(RootMotion.FinalIK.IKExecutionOrder))

		setActive(var1_190, false)

		local var2_190 = arg1_189.cacheIKInfos[arg0_190].solvers
		local var3_190 = arg1_189.cacheIKInfos[arg0_190].weights

		table.Foreach(var2_190, function(arg0_191, arg1_191)
			arg1_191.IKPositionWeight = var3_190[arg0_191]
		end)
	end)
	table.clear(arg1_189.activeIKLayers)
end

function var0_0.PlayIKAction(arg0_192, arg1_192)
	warning("Trigger IK", arg1_192:GetConfigID())
	arg0_192:emit(var0_0.ON_IK_STATUS_CHANGED, arg1_192:GetConfigID(), var0_0.IK_STATUS.TRIGGER)
	arg0_192:OnTriggerIK(arg1_192:GetConfigID())
end

function var0_0.ResetIKTipTimer(arg0_193)
	if not arg0_193.enableIKTip then
		return
	end

	arg0_193.nextTipIKTime = Time.time + var0_0.IK_TIP_WAIT_TIME
end

function var0_0.EnableHeadIK(arg0_194, arg1_194)
	arg0_194.ladyHeadIKComp.enableIk = arg1_194
end

function var0_0.SettingHeadAimIK(arg0_195, arg1_195, arg2_195, arg3_195)
	local var0_195

	if arg2_195[1] == 1 then
		var0_195 = arg0_195.mainCameraTF:Find("AimTarget")
	elseif arg2_195[1] == 2 then
		table.IpairsCArray(arg1_195.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_196, arg1_196)
			if arg1_196.name ~= arg2_195[2] then
				return
			end

			var0_195 = arg1_196
		end)
	end

	arg1_195.ladyHeadIKComp.AimTarget = var0_195

	if not arg3_195 and arg2_195[3] then
		arg1_195.ladyHeadIKComp.BodyWeight = arg2_195[3]
	end

	if not arg3_195 and arg2_195[4] then
		arg1_195.ladyHeadIKComp.HeadWeight = arg2_195[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_197, arg1_197)
	arg1_197.ladyHeadIKComp.AimTarget = arg0_197.mainCameraTF:Find("AimTarget")
	arg1_197.ladyHeadIKComp.HeadWeight = arg1_197.ladyHeadIKData.HeadWeight
	arg1_197.ladyHeadIKComp.BodyWeight = arg1_197.ladyHeadIKData.BodyWeight
end

function var0_0.HideCharacter(arg0_198, arg1_198)
	local function var0_198(arg0_199)
		arg0_199:HideCharacterBylayer()
	end

	for iter0_198, iter1_198 in pairs(arg0_198.ladyDict) do
		if iter0_198 ~= arg1_198 then
			var0_198(iter1_198)
		end
	end
end

function var0_0.RevertCharacter(arg0_200, arg1_200)
	local function var0_200(arg0_201)
		arg0_201:RevertCharacterBylayer()
	end

	for iter0_200, iter1_200 in pairs(arg0_200.ladyDict) do
		if iter0_200 ~= arg1_200 then
			var0_200(iter1_200)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_202)
	local var0_202 = "Bip001"
	local var1_202 = arg0_202.lady:Find("all")

	for iter0_202 = 0, var1_202.childCount - 1 do
		local var2_202 = var1_202:GetChild(iter0_202)

		if var2_202.name ~= var0_202 then
			pg.ViewUtils.SetLayer(var2_202, Layer.Environment3D)
		end
	end

	if arg0_202.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_202.tfPendintItem, Layer.Environment3D)
	end

	if arg0_202.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_202.ladyWatchFloat, Layer.Environment3D)
	end

	GetComponent(arg0_202.lady, "BLHXCharacterPropertiesController").enabled = false
end

function var0_0.RevertCharacterBylayer(arg0_203)
	local var0_203 = "Bip001"
	local var1_203 = arg0_203.lady:Find("all")

	for iter0_203 = 0, var1_203.childCount - 1 do
		local var2_203 = var1_203:GetChild(iter0_203)

		if var2_203.name ~= var0_203 then
			pg.ViewUtils.SetLayer(var2_203, Layer.Default)
		end
	end

	if arg0_203.tfPendintItem then
		pg.ViewUtils.SetLayer(arg0_203.tfPendintItem, Layer.Default)
	end

	if arg0_203.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg0_203.ladyWatchFloat, Layer.Default)
	end

	GetComponent(arg0_203.lady, "BLHXCharacterPropertiesController").enabled = true
end

function var0_0.EnterFurnitureWatchMode(arg0_204)
	arg0_204:SetAllBlackbloardValue("inLockLayer", true)
	arg0_204:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_205)
	arg0_205:HideFurnitureSlots()

	local var0_205 = arg0_205.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_206)
			arg0_205:emit(var0_0.SHOW_BLOCK)
			arg0_205:ShowBlackScreen(true, arg0_206)
		end,
		function(arg0_207)
			arg0_205:RevertCharacter()
			arg0_205:SetAllBlackbloardValue("inLockLayer", false)
			arg0_205:RegisterCameraBlendFinished(var0_205, arg0_207)
			arg0_205:ActiveCamera(var0_205)
		end,
		function(arg0_208)
			arg0_205:ShowBlackScreen(false, arg0_208)
		end
	}, function()
		arg0_205:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_205:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_210, arg1_210)
	local var0_210 = arg0_210:GetFurnitureByName(arg1_210:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_210.cameraFurnitureWatch and arg0_210.cameraFurnitureWatch ~= var0_210 then
		arg0_210:UnRegisterCameraBlendFinished(arg0_210.cameraFurnitureWatch)
		setActive(arg0_210.cameraFurnitureWatch, false)
	end

	arg0_210.cameraFurnitureWatch = var0_210
	arg0_210.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_210.cameraFurnitureWatch

	arg0_210:RegisterCameraBlendFinished(arg0_210.cameraFurnitureWatch, function()
		arg0_210:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_210:emit(var0_0.SHOW_BLOCK)
	arg0_210:ActiveCamera(arg0_210.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_212)
	if arg0_212.displaySlots then
		arg0_212:UpdateDisplaySlots({})
		table.Foreach(arg0_212.displaySlots, function(arg0_213, arg1_213)
			local var0_213 = arg1_213.trans

			if IsNil(var0_213:Find("Selector")) then
				return
			end

			setActive(var0_213:Find("Selector"), false)
		end)

		arg0_212.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_214, arg1_214)
	arg0_214:HideFurnitureSlots()

	arg0_214.displaySlots = {}

	_.each(arg1_214, function(arg0_215)
		arg0_214.displaySlots[arg0_215] = arg0_214.slotDict[arg0_215]

		if not arg0_214.displaySlots[arg0_215] then
			errorMsg("Slot " .. arg0_215 .. " Not Binding Scene Object")

			return
		end

		local var0_215 = arg0_214.displaySlots[arg0_215].trans

		if var0_215:Find("Selector") then
			setActive(var0_215:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_216, arg1_216)
	table.Foreach(arg0_216.displaySlots, function(arg0_217, arg1_217)
		local var0_217 = arg1_217.trans

		if not IsNil(var0_217:Find("Selector")) then
			setActive(var0_217:Find("Selector/Normal"), arg1_216[arg0_217] == 0)
			setActive(var0_217:Find("Selector/Active"), arg1_216[arg0_217] == 1)
			setActive(var0_217:Find("Selector/Ban"), arg1_216[arg0_217] == 2)
		end

		local var1_217 = arg0_216.slotDict[arg0_217].model
		local var2_217 = arg0_216.slotDict[arg0_217].displayModelName

		if var2_217 and var2_217 ~= "" then
			var1_217 = var0_217:GetChild(var0_217.childCount - 1)
		end

		local function var3_217(arg0_218, arg1_218)
			local var0_218 = arg0_218:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_218, function(arg0_219, arg1_219)
				local var0_219 = arg1_219.material

				if var0_219 and var0_219:HasProperty("_FinalTint") then
					var0_219:SetColor("_FinalTint", arg1_218)
				end
			end)
		end

		if var1_217 then
			if arg1_216[arg0_217] == 1 then
				var3_217(var1_217, Color.NewHex("3F83AE73"))
			else
				var3_217(var1_217, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_220, arg1_220, arg2_220)
	arg0_220:SetAllBlackbloardValue("inLockLayer", true)
	arg0_220:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_221)
			arg0_220:TempHideUI(true, arg0_221)
		end,
		function(arg0_222)
			arg0_220:ShowBlackScreen(true, arg0_222)
		end,
		function(arg0_223)
			arg0_220:SwitchAnim(arg2_220)
			onNextTick(function()
				arg0_220:ResetCharPoint(arg1_220:GetWatchCameraName())
				arg0_220:SyncInterestTransform()
			end)

			local var0_223 = arg0_220.cameraPhoto
			local var1_223 = var0_223.m_XAxis

			var1_223.Value = 180
			var0_223.m_XAxis = var1_223

			local var2_223 = var0_223.m_YAxis

			var2_223.Value = 0.7
			var0_223.m_YAxis = var2_223

			arg0_220:RegisterOrbits(arg0_220.cameraPhoto)

			arg0_220.pinchValue = 1

			arg0_220:SetCameraObrits()
			arg0_220:RegisterCameraBlendFinished(var0_223, arg0_223)
			arg0_220:ActiveCamera(var0_223)
		end,
		function(arg0_225)
			arg0_220:ShowBlackScreen(false, arg0_225)
		end
	}, function()
		arg0_220:EnableJoystick(true)
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
			arg0_227:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_227:ChangeCharacterPosition()
			end)

			local var0_229 = arg0_227.cameras[var0_0.CAMERA.POV]

			arg0_227:RegisterCameraBlendFinished(var0_229, arg0_229)
			arg0_227:ActiveCamera(var0_229)
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
				arg0_233:SyncInterestTransform()
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
	arg0_239.ladyInterest.position = arg0_239.ladyInterestRoot.position
end

function var0_0.ResetPhotoCameraPosition(arg0_240)
	local var0_240 = arg0_240.cameraPhoto
	local var1_240 = var0_240.m_XAxis

	var1_240.Value = 180
	var0_240.m_XAxis = var1_240

	local var2_240 = var0_240.m_YAxis

	var2_240.Value = 0.7
	var0_240.m_YAxis = var2_240
end

function var0_0.ResetCharPoint(arg0_241, arg1_241)
	local var0_241 = arg0_241.furnitures:Find(arg1_241 .. "/StayPoint")

	arg0_241.lady.position = var0_241.position
	arg0_241.lady.rotation = var0_241.rotation
end

function var0_0.GetNearestAngle(arg0_242, arg1_242, arg2_242, arg3_242)
	if arg3_242 < arg2_242 then
		arg3_242 = arg3_242 + 360
	end

	if arg2_242 <= arg1_242 and arg1_242 <= arg3_242 then
		return arg1_242
	end

	local var0_242 = (arg2_242 + arg3_242) / 2

	arg1_242 = var0_242 - Mathf.DeltaAngle(arg1_242, var0_242)
	arg1_242 = math.clamp(arg1_242, arg2_242, arg3_242)

	return arg1_242
end

function var0_0.PlayTimeline(arg0_243, arg1_243, arg2_243)
	local var0_243 = {}

	if arg0_243.waitForTimeline then
		table.insert(var0_243, function(arg0_244)
			local var0_244 = arg0_243.waitForTimeline

			arg0_243.waitForTimeline = nil

			var0_244()
			arg0_244()
		end)
	end

	table.insert(var0_243, function(arg0_245)
		arg0_243:LoadTimelineScene(arg1_243.name, false, arg0_245)
	end)

	if arg1_243.scene and arg1_243.sceneRoot then
		table.insert(var0_243, function(arg0_246)
			arg0_243:ChangeArtScene(arg1_243.scene .. "|" .. arg1_243.sceneRoot, arg0_246)
		end)
	end

	table.insert(var0_243, function(arg0_247)
		local var0_247 = GameObject.Find("[sequence]").transform
		local var1_247 = var0_247:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if GetComponent(var1_247, "TimelineSpeed") then
			setDirectorSpeed(var1_247, 1)
		else
			GetOrAddComponent(var0_247, "TimelineSpeed")
		end

		local var2_247 = GameObject.Find("[actor]").transform
		local var3_247 = var2_247:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var3_247, function(arg0_248, arg1_248)
			GetOrAddComponent(arg1_248.transform, typeof(DftAniEvent))
		end)
		table.IpairsCArray(var2_247:GetComponentsInChildren(typeof("MagicaCloth.BaseCloth"), true), function(arg0_249, arg1_249)
			arg1_249.enabled, arg1_249.enabled = arg1_249.enabled, false
		end)
		var1_247:Stop()

		var1_247.extrapolationMode = ReflectionHelp.RefGetField(typeof("UnityEngine.Playables.DirectorWrapMode"), "Hold", nil)

		if arg1_243.time then
			var1_247.time = math.clamp(arg1_243.time, 0, var1_247.duration)
		end

		local var4_247 = {}

		local function var5_247(arg0_250)
			switch(arg0_250.stringParameter, {
				TimelinePause = function()
					setDirectorSpeed(var1_247, 0)
				end,
				TimelineResume = function()
					arg0_243.timelineSpeed = 1

					setDirectorSpeed(var1_247, 1)
				end,
				TimelinePlayOnTime = function()
					if arg0_250.intParameter == 0 or arg0_250.intParameter == var4_247.selectIndex then
						var1_247.time = arg0_250.floatParameter

						var1_247:RebuildGraph()
					end
				end,
				TimelineSelectStart = function()
					var4_247.selectIndex = nil

					if arg1_243.options then
						local var0_254 = arg1_243.options[arg0_250.intParameter]

						arg0_243:DoTimelineOption(var0_254, function(arg0_255)
							var4_247.selectIndex = arg0_255
							var4_247.optionIndex = var0_254[arg0_255].flag
						end)
					end
				end,
				TimelineTouchStart = function()
					var4_247.selectIndex = nil

					if arg1_243.touchs then
						local var0_256 = arg1_243.touchs[arg0_250.intParameter]

						arg0_243:DoTimelineTouch(arg1_243.touchs[arg0_250.intParameter], function(arg0_257)
							var4_247.selectIndex = arg0_257
							var4_247.optionIndex = var0_256[arg0_257].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not var4_247.selectIndex then
						var1_247.time = arg0_250.floatParameter

						var1_247:RebuildGraph()
					end
				end,
				TimelineAccompanyJump = function()
					if arg0_243.canTriggerAccompanyPerformance then
						arg0_243.canTriggerAccompanyPerformance = false

						local var0_259 = arg1_243.accompanys[arg0_250.intParameter]
						local var1_259 = var0_259[math.random(#var0_259)]

						var1_247.time = var1_259

						var1_247:RebuildGraph()
					end
				end,
				TimelineEnd = function()
					var4_247.finish = true

					setDirectorSpeed(var1_247, 0)
				end
			}, function()
				warning("other event trigger:" .. arg0_250.stringParameter)
			end)

			if var4_247.finish then
				arg0_243.timelineMark = var4_247
				arg0_243.timelineFinishCall = nil

				arg0_247()
			end
		end

		GetOrAddComponent(var0_247, "DftCommonSignalReceiver"):SetCommonEvent(var5_247)

		function arg0_243.timelineFinishCall()
			var5_247({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_243:HideCharacter()
		setActive(arg0_243.mainCameraTF, false)
		eachChild(arg0_243.rtTimelineScreen, function(arg0_263)
			setActive(arg0_263, false)
		end)
		setActive(arg0_243.rtTimelineScreen, true)
		setActive(arg0_243.rtTimelineScreen:Find("btn_skip"), arg0_243.inReplayTalk)
		var1_247:Play()
		var1_247:Evaluate()
	end)
	table.insert(var0_243, function(arg0_264)
		arg0_243:ShowBlackScreen(true, function()
			arg0_243:UnloadTimelineScene(arg1_243.name, false, arg0_264)
		end)
	end)

	local var1_243 = arg0_243.artSceneInfo

	table.insert(var0_243, function(arg0_266)
		arg0_243:ChangeArtScene(var1_243, arg0_266)
	end)
	seriesAsync(var0_243, function()
		setActive(arg0_243.rtTimelineScreen, false)
		arg0_243:RevertCharacter()
		setActive(arg0_243.mainCameraTF, true)

		local var0_267 = arg0_243.timelineMark

		arg0_243.timelineMark = nil

		existCall(arg2_243, var0_267, function(arg0_268)
			arg0_243:ShowBlackScreen(false, arg0_268)
		end)
	end)
end

function var0_0.PlaySingleAction(arg0_269, arg1_269, arg2_269)
	local var0_269 = string.find(arg1_269, "^Face_")

	if tobool(var0_269) then
		arg0_269:PlayFaceAnim(arg1_269, arg2_269)

		return
	end

	arg0_269.animNameMap = arg0_269.animNameMap or {}
	arg0_269.animNameMap[arg0_269.ladyAnimator.StringToHash(arg1_269)] = arg1_269

	local var1_269 = {}

	if not arg0_269.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_269.ladyAnimBaseLayerIndex):IsName(arg1_269) then
		table.insert(var1_269, function(arg0_270)
			arg0_269.nowState = arg1_269
			arg0_269.stateCallback = arg0_270

			arg0_269.ladyAnimator:CrossFadeInFixedTime(arg1_269, 0.25, arg0_269.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_269, function(arg0_271)
			arg0_269.nowState = nil
			arg0_269.stateCallback = nil

			arg0_271()
		end)
	end

	seriesAsync(var1_269, arg2_269)
end

function var0_0.SwitchAnim(arg0_272, arg1_272, arg2_272)
	local var0_272 = string.find(arg1_272, "^Face_")

	if tobool(var0_272) then
		arg0_272:PlayFaceAnim(arg1_272, arg2_272)

		return
	end

	arg0_272.animNameMap = arg0_272.animNameMap or {}
	arg0_272.animNameMap[arg0_272.ladyAnimator.StringToHash(arg1_272)] = arg1_272

	local var1_272 = {}

	table.insert(var1_272, function(arg0_273)
		arg0_272.nowState = arg1_272
		arg0_272.stateCallback = arg0_273

		arg0_272.ladyAnimator:PlayInFixedTime(arg1_272, arg0_272.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_272, function(arg0_274)
		arg0_272.nowState = nil
		arg0_272.stateCallback = nil

		arg0_274()
	end)
	seriesAsync(var1_272, arg2_272)
end

function var0_0.PlayFaceAnim(arg0_275, arg1_275, arg2_275)
	arg0_275.ladyAnimator:CrossFadeInFixedTime(arg1_275, 0.2, arg0_275.ladyAnimFaceLayerIndex)
	existCall(arg2_275)
end

function var0_0.GetCurrentAnim(arg0_276)
	local var0_276 = arg0_276.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_276.ladyAnimBaseLayerIndex).shortNameHash

	return arg0_276.animNameMap[var0_276]
end

function var0_0.RegisterAnimCallback(arg0_277, arg1_277, arg2_277)
	arg0_277.animCallbacks[arg1_277] = arg2_277
end

function var0_0.SetCharacterAnimSpeed(arg0_278, arg1_278)
	arg0_278.ladyAnimator.speed = arg1_278
	arg0_278.ladyHeadIKComp.blinkSpeed = arg0_278.ladyHeadIKData.blinkSpeed * arg1_278

	if arg1_278 > 0 then
		arg0_278.ladyHeadIKComp.DampTime = arg0_278.ladyHeadIKData.DampTime / arg1_278
	else
		arg0_278.ladyHeadIKComp.DampTime = arg0_278.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_279, arg1_279)
	if arg1_279.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_279 = arg1_279.stringParameter
	local var1_279 = table.removebykey(arg0_279.animEventCallbacks, var0_279)

	existCall(var1_279)
end

function var0_0.RegisterAnimEventCallback(arg0_280, arg1_280, arg2_280)
	arg0_280.animEventCallbacks[arg1_280] = arg2_280
end

function var0_0.RegisterCameraBlendFinished(arg0_281, arg1_281, arg2_281)
	arg0_281.cameraBlendCallbacks[arg1_281] = arg2_281
end

function var0_0.UnRegisterCameraBlendFinished(arg0_282, arg1_282)
	arg0_282.cameraBlendCallbacks[arg1_282] = nil
end

function var0_0.OnCameraBlendFinished(arg0_283, arg1_283)
	if not arg1_283 then
		return
	end

	local var0_283 = table.removebykey(arg0_283.cameraBlendCallbacks, arg1_283)

	existCall(var0_283)
end

function var0_0.PlayHeartFX(arg0_284, arg1_284)
	local var0_284 = arg0_284.ladyDict[arg1_284]

	setActive(var0_284.effectHeart, false)
	setActive(var0_284.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_285, arg1_285)
	local var0_285 = arg1_285.name
	local var1_285 = arg0_285.expressionDict[var0_285]
	local var2_285 = 5

	if var1_285 then
		local var3_285 = var1_285.timer

		var3_285:Reset(nil, var2_285)
		var3_285:Start()

		if var1_285.instance then
			setActive(var1_285.instance, false)
			setActive(var1_285.instance, true)
		end

		return
	end

	local var4_285 = {
		name = var0_285,
		timer = Timer.New(function()
			arg0_285:RemoveExpression(var0_285)
		end, var2_285, 1, true)
	}

	arg0_285.expressionDict[var0_285] = var4_285

	arg0_285.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_285, var0_285, function(arg0_287)
		var4_285.instance = arg0_287

		onNextTick(function()
			setParent(arg0_287, arg0_285.ladyHeadCenter)
		end)
		setLocalPosition(arg0_287, Vector3(0, 0, -0.2))
		setActive(arg0_287, false)
		setActive(arg0_287, true)
	end, var4_285)
end

function var0_0.RemoveExpression(arg0_289, arg1_289)
	local var0_289 = arg0_289.expressionDict[arg1_289]

	if not var0_289 then
		return
	end

	arg0_289.loader:ClearRequest(var0_289)

	if var0_289.instance then
		arg0_289.loader:ReturnPrefab(var0_289.instance)
	end

	arg0_289.expressionDict[arg1_289] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_290, arg1_290)
	arg0_290.ladyWatchFloat = arg0_290.ladyWatchFloat or cloneTplTo(arg0_290.resTF:Find("vfx_talk_mark"), arg0_290.ladyHeadCenter)

	setActive(arg0_290.ladyWatchFloat, arg1_290)
end

function var0_0.RegisterGlobalVolume(arg0_291)
	local var0_291 = arg0_291.globalVolume
	local var1_291 = LuaHelper.GetOrAddVolumeComponent(var0_291, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_291 = LuaHelper.GetOrAddVolumeComponent(var0_291, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_291.originalCameraSettings = {
		depthOfField = {
			enabled = var1_291.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_291.gaussianStart.min,
				value = var1_291.gaussianStart.value
			},
			blurRadius = {
				min = var1_291.blurRadius.min,
				max = var1_291.blurRadius.max,
				value = var1_291.blurRadius.value
			}
		},
		postExposure = {
			value = var2_291.postExposure.value
		},
		contrast = {
			min = var2_291.contrast.min,
			max = var2_291.contrast.max,
			value = var2_291.contrast.value
		},
		saturate = {
			min = var2_291.saturation.min,
			max = var2_291.saturation.max,
			value = var2_291.saturation.value
		}
	}
	arg0_291.originalCameraSettings.depthOfField.enabled = true

	local var3_291 = var0_291:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_291.originalVolume = {
		profile = var3_291.sharedProfile,
		weight = var3_291.weight
	}
end

function var0_0.SettingCamera(arg0_292, arg1_292)
	arg0_292.activeCameraSettings = arg1_292

	local var0_292 = arg0_292.globalVolume
	local var1_292 = LuaHelper.GetOrAddVolumeComponent(var0_292, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_292 = LuaHelper.GetOrAddVolumeComponent(var0_292, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_292.enabled:Override(arg1_292.depthOfField.enabled)
	var1_292.gaussianStart:Override(arg1_292.depthOfField.focusDistance.value)
	var1_292.gaussianEnd:Override(arg1_292.depthOfField.focusDistance.value + arg1_292.depthOfField.focusDistance.length)
	var1_292.blurRadius:Override(arg1_292.depthOfField.blurRadius.value)
	var2_292.postExposure:Override(arg1_292.postExposure.value)
	var2_292.contrast:Override(arg1_292.contrast.value)
	var2_292.saturation:Override(arg1_292.saturate.value)
end

function var0_0.GetCameraSettings(arg0_293)
	return arg0_293.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_294)
	arg0_294:SettingCamera(arg0_294.originalCameraSettings)

	arg0_294.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_295, arg1_295, arg2_295)
	local var0_295 = arg0_295.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_295.activeProfileWeight = arg2_295

	if arg0_295.activeProfileName ~= arg1_295 then
		arg0_295.activeProfileName = arg1_295

		arg0_295.loader:LoadReference("dorm3d/scenesres/res/common", arg1_295, nil, function(arg0_296)
			var0_295.profile = arg0_296
			var0_295.weight = arg0_295.activeProfileWeight

			if arg0_295.activeCameraSettings then
				arg0_295:SettingCamera(arg0_295.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_295.weight = arg0_295.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_297)
	local var0_297 = arg0_297.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_297.profile = arg0_297.originalVolume.profile
	var0_297.weight = arg0_297.originalVolume.weight

	if arg0_297.activeCameraSettings then
		arg0_297:SettingCamera(arg0_297.activeCameraSettings)
	end

	arg0_297.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_298)
	local var0_298 = BLHX.Rendering.PipelineInterface.GetCharacterLightColor()

	arg0_298.originalCharacterColor = {
		color = var0_298.color,
		intensity = var0_298.intensity
	}
end

function var0_0.SetCharacterLight(arg0_299, arg1_299, arg2_299, arg3_299)
	local var0_299 = arg0_299.characterLight:GetComponent(typeof(Light))
	local var1_299 = Color.Lerp(arg0_299.originalCharacterColor.color, arg1_299, arg3_299)
	local var2_299 = math.lerp(arg0_299.originalCharacterColor.intensity, arg2_299, arg3_299)

	BLHX.Rendering.PipelineInterface.SetCharacterLight(var1_299, var2_299)
end

function var0_0.RevertCharacterLight(arg0_300)
	arg0_300:SetCharacterLight(arg0_300.originalCharacterColor.color, arg0_300.originalCharacterColor.intensity, 1)
end

function var0_0.EnableCloth(arg0_301, arg1_301, arg2_301)
	arg1_301 = arg1_301 or {}

	table.Foreach(arg0_301.clothComps, function(arg0_302, arg1_302)
		if arg1_302 == nil then
			return
		end

		setActive(arg1_302, arg1_301[arg0_302] == 1)
	end)
	table.Foreach(arg0_301.clothColliderDict, function(arg0_303, arg1_303)
		if arg1_303 == nil then
			return
		end

		setActive(arg1_303, false)
	end)

	if arg2_301 then
		table.Foreach(arg2_301, function(arg0_304, arg1_304)
			local var0_304 = arg0_301.clothColliderDict[arg1_304[1]]

			if var0_304 == nil then
				return
			end

			setActive(var0_304, arg1_304[2] == 1)

			if arg1_304[2] ~= 1 then
				return
			end

			var0_0.SetMagicaCollider(var0_304, arg1_304[3], arg1_304[4])
		end)
	end
end

function var0_0.onBackPressed(arg0_305)
	if arg0_305.exited or arg0_305.retainCount > 0 then
		-- block empty
	else
		arg0_305:closeView()
	end
end

function var0_0.EnableSceneDisplay(arg0_306, arg1_306, arg2_306)
	assert(tobool(arg0_306.lastSceneRootDict[arg1_306]) == arg2_306)

	if arg2_306 then
		table.Foreach(arg0_306.lastSceneRootDict[arg1_306], function(arg0_307, arg1_307)
			if IsNil(arg0_307) then
				return
			end

			setActive(arg0_307, arg1_307)
		end)

		arg0_306.lastSceneRootDict[arg1_306] = nil
	else
		arg0_306.lastSceneRootDict[arg1_306] = {}

		local var0_306 = SceneManager.GetSceneByName(arg1_306)

		table.IpairsCArray(var0_306:GetRootGameObjects(), function(arg0_308, arg1_308)
			if tostring(arg1_308.hideFlags) ~= "None" then
				return
			end

			arg0_306.lastSceneRootDict[arg1_306][arg1_308] = isActive(arg1_308)

			setActive(arg1_308, false)
		end)
	end
end

function var0_0.ChangeArtScene(arg0_309, arg1_309, arg2_309)
	arg1_309 = string.lower(arg1_309)

	if arg1_309 == arg0_309.artSceneInfo then
		if arg1_309 == arg0_309.sceneInfo then
			arg0_309:SwitchDayNight(arg0_309.contextData.timeIndex)
			onNextTick(function()
				arg0_309:RefreshSlots()
				existCall(arg2_309)
			end)
		else
			existCall(arg2_309)
		end

		return
	end

	local var0_309 = {}
	local var1_309 = false
	local var2_309

	table.insert(var0_309, function(arg0_311)
		arg0_309.artSceneInfo = arg1_309

		if var1_309 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_312)
				var2_309 = arg0_312

				arg0_311()
			end)
		else
			arg0_311()
		end
	end)

	if arg1_309 == arg0_309.sceneInfo then
		table.insert(var0_309, function(arg0_313)
			setActive(arg0_309.slotRoot, true)

			local var0_313, var1_313 = unpack(string.split(arg0_309.sceneInfo, "|"))

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_313))
			arg0_309:EnableSceneDisplay(var0_313, true)
			arg0_309:SwitchDayNight(arg0_309.contextData.timeIndex)
			onNextTick(function()
				arg0_309:RefreshSlots()
			end)
			arg0_313()
		end)
	else
		var1_309 = true

		local var3_309, var4_309 = unpack(string.split(arg1_309, "|"))

		table.insert(var0_309, function(arg0_315)
			setActive(arg0_309.slotRoot, false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_309 .. "/" .. var3_309 .. "_scene"), var3_309, LoadSceneMode.Additive, function(arg0_316, arg1_316)
				SceneManager.SetActiveScene(arg0_316)

				local var0_316 = getSceneRootTFDic(arg0_316).MainCamera

				if var0_316 then
					setActive(var0_316, false)
				end

				arg0_315()
			end)
		end)
	end

	if arg0_309.artSceneInfo == arg0_309.sceneInfo then
		table.insert(var0_309, function(arg0_317)
			local var0_317, var1_317 = unpack(string.split(arg0_309.sceneInfo, "|"))

			arg0_309:EnableSceneDisplay(var0_317, false)
			arg0_317()
		end)
	else
		local var5_309, var6_309 = unpack(string.split(arg0_309.artSceneInfo, "|"))

		table.insert(var0_309, function(arg0_318)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_309 .. "/" .. var5_309 .. "_scene"), var5_309, arg0_318)
		end)
	end

	table.insert(var0_309, function(arg0_319)
		arg0_319()

		if var1_309 then
			var2_309()
		end
	end)
	seriesAsync(var0_309, arg2_309)
end

function var0_0.LoadTimelineScene(arg0_320, arg1_320, arg2_320, arg3_320)
	arg1_320 = string.lower(arg1_320)

	if arg0_320.cacheSceneDic[arg1_320] then
		if not arg2_320 then
			arg0_320.timelineScene = arg1_320

			arg0_320:EnableSceneDisplay(arg1_320, true)
		end

		return existCall(arg3_320)
	end

	local var0_320 = {}
	local var1_320

	table.insert(var0_320, function(arg0_321)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_322)
			if arg0_320.waitForTimeline then
				arg0_320.waitForTimeline = arg0_322
				var1_320 = nil
			else
				var1_320 = arg0_322
			end

			arg0_321()
		end)
	end)
	table.insert(var0_320, function(arg0_323)
		local var0_323 = arg0_320.apartment:getConfig("asset_name")

		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_323 .. "/timeline/" .. arg1_320 .. "/" .. arg1_320 .. "_scene"), arg1_320, LoadSceneMode.Additive, function(arg0_324, arg1_324)
			local var0_324 = GameObject.Find("[actor]").transform

			arg0_320:HXCharacter(tf(var0_324))

			local var1_324 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			var1_324:Stop()
			TimelineSupport.InitTimeline(var1_324)
			TimelineSupport.InitSubtitle(var1_324, arg0_320.apartment:GetCallName())

			arg0_320.unloadDirector = var1_324

			arg0_323()
		end)
	end)
	table.insert(var0_320, function(arg0_325)
		arg0_320.sceneGroupDic[arg1_320] = arg0_320.apartment:GetConfigID()

		if arg2_320 then
			arg0_320.cacheSceneDic[arg1_320] = true

			arg0_320:EnableSceneDisplay(arg1_320, false)
		else
			arg0_320.timelineScene = arg1_320
		end

		arg0_325()
		existCall(var1_320)
	end)
	seriesAsync(var0_320, arg3_320)
end

function var0_0.UnloadTimelineScene(arg0_326, arg1_326, arg2_326, arg3_326)
	arg1_326 = string.lower(arg1_326)

	if arg0_326.timelineScene == arg1_326 then
		arg0_326.timelineScene = nil
	end

	if tobool(arg2_326) == tobool(arg0_326.cacheSceneDic[arg1_326]) then
		local var0_326 = getProxy(ApartmentProxy):getApartment(arg0_326.sceneGroupDic[arg1_326]):getConfig("asset_name")

		if arg0_326.unloadDirector then
			TimelineSupport.UnloadPlayable(arg0_326.unloadDirector)

			arg0_326.unloadDirector = nil
		end

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var0_326 .. "/timeline/" .. arg1_326 .. "/" .. arg1_326 .. "_scene"), arg1_326, function()
			arg0_326.cacheSceneDic[arg1_326] = nil
			arg0_326.sceneGroupDic[arg1_326] = nil
			arg0_326.lastSceneRootDict[arg1_326] = nil

			existCall(arg3_326)
		end)
	else
		arg0_326:EnableSceneDisplay(arg1_326, false)
		existCall(arg3_326)
	end
end

function var0_0.ChangeSubScene(arg0_328, arg1_328, arg2_328)
	arg1_328 = string.lower(arg1_328)

	warning(arg0_328.subSceneInfo, "->", arg1_328, arg1_328 == arg0_328.subSceneInfo)

	if arg1_328 == arg0_328.subSceneInfo then
		arg0_328.ladyActiveZone = arg0_328.walkBornPoint or arg0_328.ladyBaseZone

		arg0_328:ChangeCharacterPosition()
		arg0_328:ChangePlayerPosition(arg0_328.ladyActiveZone)
		arg0_328:TriggerLadyDistance()
		arg0_328:CheckInSector()
		existCall(arg2_328)

		return
	end

	local var0_328 = {}
	local var1_328 = false
	local var2_328

	table.insert(var0_328, function(arg0_329)
		arg0_328.subSceneInfo = arg1_328

		if var1_328 then
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_330)
				var2_328 = arg0_330

				arg0_329()
			end)
		else
			arg0_329()
		end
	end)

	if arg1_328 == arg0_328.sceneInfo then
		table.insert(var0_328, function(arg0_331)
			local var0_331, var1_331 = unpack(string.split(arg0_328.sceneInfo, "|"))

			arg0_328:ResetSceneStructure(SceneManager.GetSceneByName(var0_331 .. "_base"))
			arg0_328:RefreshSlots()

			arg0_328.ladyActiveZone = arg0_328.walkBornPoint or arg0_328.ladyBaseZone

			arg0_328:ChangeCharacterPosition()
			arg0_328:ChangePlayerPosition(arg0_328.ladyActiveZone)
			arg0_328:TriggerLadyDistance()
			arg0_328:CheckInSector()
			arg0_331()
		end)
	else
		var1_328 = true

		local var3_328, var4_328 = unpack(string.split(arg1_328, "|"))
		local var5_328 = var3_328 .. "_base"

		table.insert(var0_328, function(arg0_332)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_328 .. "/" .. var5_328 .. "_scene"), var5_328, LoadSceneMode.Additive, arg0_332)
		end)
		table.insert(var0_328, function(arg0_333)
			arg0_328:ResetSceneStructure(SceneManager.GetSceneByName(var5_328))

			arg0_328.ladyActiveZone = arg0_328.walkBornPoint or "Default"

			arg0_328:SwitchAnim(var0_0.ANIM.IDLE)
			onNextTick(function()
				arg0_328:ChangeCharacterPosition()
				arg0_328:ChangePlayerPosition(arg0_328.ladyActiveZone)
				arg0_328:TriggerLadyDistance()
				arg0_328:CheckInSector()
				arg0_333()
			end)
		end)
	end

	if arg0_328.subSceneInfo == arg0_328.sceneInfo then
		table.insert(var0_328, function(arg0_335)
			local var0_335 = Clone(arg0_328.room)

			var0_335.furnitures = {}

			arg0_328:RefreshSlots(var0_335)
			arg0_335()
		end)
	else
		local var6_328, var7_328 = unpack(string.split(arg0_328.subSceneInfo, "|"))
		local var8_328 = var6_328 .. "_base"

		table.insert(var0_328, function(arg0_336)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_328 .. "/" .. var8_328 .. "_scene"), var8_328, arg0_336)
		end)
	end

	table.insert(var0_328, function(arg0_337)
		arg0_337()

		if var1_328 then
			var2_328()
		end
	end)
	seriesAsync(var0_328, arg2_328)
end

function var0_0.TransformMesh(arg0_338)
	local var0_338 = arg0_338.sharedMesh
	local var1_338 = {}
	local var2_338 = arg0_338.transform:TransformPoint(var0_338.vertices[0])
	local var3_338 = arg0_338.transform:TransformPoint(var0_338.vertices[1])
	local var4_338 = arg0_338.transform:TransformPoint(var0_338.vertices[2])

	var1_338.horizontal = var3_338 - var2_338
	var1_338.verticle = var4_338 - var2_338
	var1_338.origin = var2_338

	return var1_338
end

function var0_0.GetRatio(arg0_339, arg1_339)
	local var0_339 = Vector2.zero

	var0_339.x = Vector3.Dot(arg0_339.horizontal, arg1_339) / arg0_339.horizontal.sqrMagnitude
	var0_339.y = Vector3.Dot(arg0_339.verticle, arg1_339) / arg0_339.verticle.sqrMagnitude

	return var0_339
end

function var0_0.GetPostionByRatio(arg0_340, arg1_340)
	return arg0_340.horizontal * arg1_340.x + arg0_340.verticle * arg1_340.y + arg0_340.origin
end

function var0_0.IsPointInSector(arg0_341, arg1_341)
	local var0_341 = arg1_341 - Vector3.New(unpack(arg0_341.Position))

	if var0_341.magnitude > arg0_341.Radius then
		return false
	end

	local var1_341 = Quaternion.Euler(unpack(arg0_341.Rotation))

	return Vector3.Angle(var1_341 * Vector3.forward, var0_341) <= arg0_341.Angle / 2
end

function var0_0.willExit(arg0_342)
	arg0_342.joystickTimer:Stop()
	arg0_342.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_342.updateHandler)
	arg0_342:StopIKHandTimer()

	if arg0_342.moveTimer then
		arg0_342.moveTimer:Stop()

		arg0_342.moveTimer = nil
	end

	if arg0_342.moveWaitTimer then
		arg0_342.moveWaitTimer:Stop()

		arg0_342.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_342.furnitures) then
		eachChild(arg0_342.furnitures, function(arg0_343)
			local var0_343 = GetComponent(arg0_343, typeof(EventTriggerListener))

			if not var0_343 then
				return
			end

			var0_343:ClearEvents()
		end)
	end

	for iter0_342, iter1_342 in pairs(arg0_342.ladyDict) do
		arg0_342:ResetActiveIKs(iter1_342)
		GetComponent(iter1_342.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_342.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_342.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_342.blockLayer, arg0_342._tf)
	table.Foreach(arg0_342.expressionDict, function(arg0_344)
		arg0_342:RemoveExpression(arg0_344)
	end)
	arg0_342.loader:Clear()
	pg.ClickEffectMgr:GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()

	local var0_342 = {}

	if arg0_342.timelineScene and not arg0_342.cacheSceneDic[arg0_342.timelineScene] then
		local var1_342 = arg0_342.timelineScene

		arg0_342.timelineScene = nil

		local var2_342 = getProxy(ApartmentProxy):getApartment(arg0_342.sceneGroupDic[var1_342]):getConfig("asset_name")

		table.insert(var0_342, function(arg0_345)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var2_342 .. "/timeline/" .. var1_342 .. "/" .. var1_342 .. "_scene"), var1_342, arg0_345)
		end)
	end

	for iter2_342, iter3_342 in pairs(arg0_342.cacheSceneDic) do
		if iter3_342 then
			local var3_342 = getProxy(ApartmentProxy):getApartment(arg0_342.sceneGroupDic[iter2_342]):getConfig("asset_name")

			table.insert(var0_342, function(arg0_346)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var3_342 .. "/timeline/" .. iter2_342 .. "/" .. iter2_342 .. "_scene"), iter2_342, arg0_346)
			end)
		end
	end

	for iter4_342, iter5_342 in ipairs({
		arg0_342.sceneInfo,
		arg0_342.subSceneInfo ~= arg0_342.sceneInfo and arg0_342.subSceneInfo or nil
	}) do
		local var4_342, var5_342 = unpack(string.split(iter5_342, "|"))
		local var6_342 = var4_342 .. "_base"

		table.insert(var0_342, function(arg0_347)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var5_342 .. "/" .. var6_342 .. "_scene"), var6_342, arg0_347)
		end)
	end

	for iter6_342, iter7_342 in ipairs({
		arg0_342.sceneInfo,
		arg0_342.artSceneInfo ~= arg0_342.sceneInfo and arg0_342.artSceneInfo or nil
	}) do
		local var7_342, var8_342 = unpack(string.split(iter7_342, "|"))

		table.insert(var0_342, function(arg0_348)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_342 .. "/" .. var7_342 .. "_scene"), var7_342, arg0_348)
		end)
	end

	seriesAsync(var0_342, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

function var0_0.InitDefautQuality()
	if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) == 0 then
		local var0_350 = DevicePerformanceUtil.GetDevicePerformanceLevel()

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			local var1_350 = SystemInfo.deviceModel or ""

			local function var2_350(arg0_351)
				local var0_351 = string.match(arg0_351, "iPad(%d+)")
				local var1_351 = tonumber(var0_351)

				if var1_351 and var1_351 >= 8 then
					return true
				end

				return false
			end

			local function var3_350(arg0_352)
				local var0_352 = string.match(arg0_352, "iPhone(%d+)")
				local var1_352 = tonumber(var0_352)

				if var1_352 and var1_352 >= 13 then
					return true
				end

				return false
			end

			if var2_350(var1_350) or var3_350(var1_350) then
				var0_350 = DevicePerformanceLevel.High
			end
		end

		local var4_350 = var0_350 == DevicePerformanceLevel.High and 3 or var0_350 == DevicePerformanceLevel.Mid and 2 or 1

		PlayerPrefs.SetInt("dorm3d_graphics_settings", var4_350)

		Dorm3dRoomTemplateScene.FirstDefaultSetting = var4_350
	end
end

function var0_0.SettingQuality()
	local var0_353 = GraphicSettingConst.HandleCustomSetting()

	BLHX.Rendering.EngineCore.SetOverrideQualitySettings(var0_353)
end

function var0_0.SetMagicaCollider(arg0_354, arg1_354, arg2_354)
	local var0_354 = typeof("MagicaCloth.MagicaCapsuleCollider")

	ReflectionHelp.RefSetProperty(var0_354, "StartRadius", arg0_354, arg1_354)
	ReflectionHelp.RefSetProperty(var0_354, "EndRadius", arg0_354, arg2_354)
end

return var0_0
