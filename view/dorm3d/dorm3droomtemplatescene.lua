local var0_0 = class("Dorm3dRoomTemplateScene", import("view.dorm3d.Core.Dorm3dBaseScene"))

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
var0_0.ON_ROLEWATCH_CAMERA_MAX = "Dorm3dRoomTemplateScene.ON_ROLEWATCH_CAMERA_MAX"
var0_0.ON_STICK_MOVE = "Dorm3dRoomTemplateScene.ON_STICK_MOVE"
var0_0.ENABLE_SCENEBLOCK = "Dorm3dRoomTemplateScene.ENABLE_SCENEBLOCK"
var0_0.ON_POV_STICK_MOVE_BEGIN = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE_BEGIN"
var0_0.ON_POV_STICK_MOVE = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE"
var0_0.ON_POV_STICK_MOVE_END = "Dorm3dRoomTemplateScene.ON_POV_STICK_MOVE_END"
var0_0.ON_POV_STICK_VIEW = "Dorm3dRoomTemplateScene.ON_POV_STICK_VIEW"
var0_0.ON_ENTER_SECTOR = "Dorm3dRoomTemplateScene.ON_ENTER_SECTOR"
var0_0.ON_CHANGE_DISTANCE = "Dorm3dRoomTemplateScene.ON_CHANGE_DISTANCE"
var0_0.CLICK_CHARACTER = "Dorm3dRoomTemplateScene.CLICK_CHARACTER"
var0_0.CLICK_CONTACT = "Dorm3dRoomTemplateScene.CLICK_CONTACT"
var0_0.DISTANCE_TRIGGER = "Dorm3dRoomTemplateScene.DISTANCE_TRIGGER"
var0_0.WALK_DISTANCE_TRIGGER = "Dorm3dRoomTemplateScene.WALK_DISTANCE_TRIGGER"
var0_0.CHANGE_WATCH = "Dorm3dRoomTemplateScene.CHANGE_WATCH"
var0_0.PHOTO_CALL = "Dorm3dRoomTemplateScene.PHOTO_CALL"
var0_0.SHIFT_ZONE_SAFE = "Dorm3dRoomTemplateScene.SHIFT_ZONE_SAFE"
var0_0.TIMELINE_END = "Dorm3dRoomTemplateScene.TIMELINE_END"
var0_0.TRIGGER_TIMELINE_PLAYER_EVENT = "Dorm3dRoomTemplateScene.TRIGGER_TIMELINE_PLAYER_EVENT"
var0_0.POV_CLOSE_DISTANCE = 1.5
var0_0.POV_PENDING_CLOSE_DISTANCE = 2

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

function var0_0.Ctor(arg0_7, ...)
	var0_0.super.Ctor(arg0_7, ...)

	arg0_7.loader = AutoLoader.New()
	arg0_7.scene = arg0_7
end

function var0_0.SetRoom(arg0_8, arg1_8)
	arg0_8.room = arg1_8
end

function var0_0.preload(arg0_9, arg1_9)
	tolua.loadassembly("MagicaClothV2")
	tolua.loadassembly("ParadoxNotion")
	tolua.loadassembly("Yongshi.BLRP.Runtime")

	for iter0_9, iter1_9 in pairs({
		_MonoManager = "ParadoxNotion.Services.MonoManager"
	}) do
		if not GameObject.Find(iter0_9) then
			local var0_9 = GameObject.New(iter0_9)

			GetOrAddComponent(var0_9, typeof(iter1_9))
		end
	end

	arg0_9.room = getProxy(ApartmentProxy):getRoom(arg0_9.contextData.roomId)

	local var1_9 = {}

	table.insert(var1_9, function(arg0_10)
		arg0_9.dormSceneMgr = Dorm3dSceneMgr.New(arg0_9.room:getConfig("scene_info"), arg0_10)
	end)
	table.insert(var1_9, function(arg0_11)
		arg0_9:LoadCharacter(arg0_9.contextData.groupIds, arg0_11)
	end)
	seriesAsync(var1_9, arg1_9)
end

function var0_0.init(arg0_12)
	arg0_12:BindEvent()
	arg0_12:InitData()
	arg0_12:initScene()
	arg0_12:initNodeCanvas()

	if arg0_12.room:isPersonalRoom() then
		local var0_12 = arg0_12.contextData.groupIds[1]
		local var1_12 = getProxy(ApartmentProxy):getApartment(var0_12):GetCurSkinId()
		local var2_12 = arg0_12.ladyDict[var0_12]

		setActive(var2_12.ladyGameObject, false)

		var2_12.skinId = var1_12
		var2_12.ladyGameObject = arg0_12.skinDict[var1_12].ladyGameObject

		setActive(var2_12.ladyGameObject, true)
	end

	for iter0_12, iter1_12 in pairs(arg0_12.ladyDict) do
		arg0_12:InitCharacter(iter1_12, iter0_12)
	end

	if not arg0_12.room:isPersonalRoom() then
		local var3_12 = underscore.detect(arg0_12.contextData.groupIds, function(arg0_13)
			return arg0_12.contextData.ladyZone[arg0_13] == arg0_12.contextData.inFurnitureName
		end) or arg0_12.contextData.groupIds[1]

		if var3_12 then
			arg0_12:SyncInterestTransform(arg0_12.ladyDict[var3_12])
		end

		if SlideExtraSystem.IsOpen(arg0_12.room) and arg0_12.contextData.inFurnitureName == SlideConst.SLIDE_ZONE then
			arg0_12:SyncInterestTransformByTf(arg0_12:GetFurnitureByName(arg0_12.contextData.inFurnitureName):Find("StayPoint"))
		end
	end

	arg0_12.retainCount = 0
	arg0_12.sceneBlockLayer = arg0_12._tf:Find("SceneBlock")

	setActive(arg0_12.sceneBlockLayer, false)

	arg0_12.blockLayer = arg0_12._tf:Find("Block")

	setActive(arg0_12.blockLayer, false)

	arg0_12.blackLayer = arg0_12._tf:Find("BlackScreen")

	setActive(arg0_12.blackLayer, false)

	arg0_12.holyLightRoot = arg0_12._tf:Find("HolyLightRoot")

	arg0_12:InitHolyLight()
	arg0_12:ChangePlayerPosition()

	arg0_12.cacheSceneDic = {}
	arg0_12.sceneGroupDic = {}
	arg0_12.lastSceneRootDict = {}

	pg.ClickEffectMgr.GetInstance():SetClickEffect("DORM3D")
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
	arg0_14:bind(var0_0.ON_POV_STICK_MOVE_BEGIN, function(arg0_20, arg1_20)
		if arg0_14.pinchMode then
			return
		end

		arg0_14.moveStickOrigin = arg1_20.position
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

	arg0_14:bind(var0_0.ON_POV_STICK_MOVE_END, function(arg0_22, arg1_22)
		var0_14()
	end)
	arg0_14:bind(var0_0.ON_POV_STICK_MOVE, function(arg0_23, arg1_23)
		if arg0_14.pinchMode then
			var0_14()

			return
		end

		if not arg0_14.moveStickDraging then
			return
		end

		arg0_14.moveStickPosition = arg0_14.moveStickPosition + arg1_23

		if isActive(arg0_14.povLayer:Find("Guide")) then
			setActive(arg0_14.povLayer:Find("Guide"), false)
		end
	end)

	local var1_14 = 32.4 / Screen.height

	arg0_14:bind(var0_0.ON_POV_STICK_VIEW, function(arg0_24, arg1_24)
		if arg0_14.pinchMode then
			return
		end

		arg1_24 = arg1_24 * var1_14

		local var0_24 = arg1_24.x
		local var1_24 = arg1_24.y

		local function var2_24(arg0_25, arg1_25, arg2_25)
			local var0_25 = arg0_25[arg1_25]

			var0_25.m_InputAxisValue = arg2_25
			arg0_25[arg1_25] = var0_25
		end

		if isActive(arg0_14.cameras[var0_0.CAMERA.POV]) then
			var2_24(arg0_14.compPovAim, "m_HorizontalAxis", var0_24)
			var2_24(arg0_14.compPovAim, "m_VerticalAxis", var1_24)
		elseif isActive(arg0_14.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			local var3_24 = arg0_14.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

			var2_24(var3_24, "m_HorizontalAxis", var0_24)
			var2_24(var3_24, "m_VerticalAxis", var1_24)
		end
	end)

	local var2_14 = {
		HideSceneItem = true,
		SetExtraAnimSpeed = true,
		EnableHeadIK = true,
		PlayEnterExtraItem = true,
		ResetCharacterExtraItem = true,
		ResetTempHideSceneItems = true,
		HideCharacterBylayer = true,
		RevertCharacterBylayer = true
	}

	arg0_14:bind(var0_0.PHOTO_CALL, function(arg0_26, arg1_26, ...)
		if var2_14[arg1_26] then
			local var0_26 = arg0_14:GetCurrentLadyEnv()

			arg0_14[arg1_26](arg0_14, var0_26, ...)
		else
			arg0_14[arg1_26](arg0_14, ...)
		end
	end)
	arg0_14:bind(var0_0.SHIFT_ZONE_SAFE, function(arg0_27, arg1_27)
		arg0_14:ShiftZoneSafe(arg1_27)
	end)
	arg0_14:bind(var0_0.TRIGGER_TIMELINE_PLAYER_EVENT, function(arg0_28, arg1_28)
		if not arg0_14.nowTimelinePlayer then
			warning("nowTimelinePlayer is nil, can't trigger event", arg1_28)

			return
		end

		arg0_14.nowTimelinePlayer:TriggerEvent(arg1_28)
	end)
end

function var0_0.initScene(arg0_29)
	local var0_29, var1_29 = unpack(string.split(arg0_29.dormSceneMgr.sceneInfo, "|"))
	local var2_29 = SceneManager.GetSceneByName(var0_29 .. "_base")

	arg0_29:ResetSceneStructure(var2_29)

	arg0_29.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_29.camBrain = arg0_29.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_29.camBrainEvenetHandler = arg0_29.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_29.raycastCamera = arg0_29.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_29.sceneRaycaster = arg0_29.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
	arg0_29.player = GameObject.Find("Player").transform
	arg0_29.playerEye = arg0_29.player:Find("Eye")
	arg0_29.playerFoot = arg0_29.player:Find("Foot")

	setActive(arg0_29.playerFoot, false)

	arg0_29.playerController = arg0_29.player:GetComponent(typeof(UnityEngine.CharacterController))
	arg0_29.attachedPoints = {}

	eachChild(arg0_29.furnitures, function(arg0_30)
		table.insert(arg0_29.attachedPoints, 1, arg0_30)
	end)

	arg0_29.modelRoot = GameObject.Find("scene_root").transform
	arg0_29.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_29.slotRoot, true)
	arg0_29:InitSlots()
	tolua.loadassembly("Cinemachine")

	local var3_29 = GameObject.Find("CM Cameras").transform

	eachChild(var3_29, function(arg0_31)
		setActive(arg0_31, false)
	end)

	arg0_29.camBrain.enabled = false
	arg0_29.camBrain.enabled = true
	arg0_29.cameraAim = var3_29:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_29.cameraAim2 = var3_29:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_29.cameraFree = nil
	arg0_29.cameraFurnitureWatch = nil
	arg0_29.cameraRole = var3_29:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_29.cameraRole2 = var3_29:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	local var4_29 = var3_29:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	arg0_29.cameraGift = var3_29:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_29.cameras = {
		arg0_29.cameraAim,
		arg0_29.cameraAim2,
		arg0_29.cameraRole,
		[var0_0.CAMERA.TALK] = var4_29,
		[var0_0.CAMERA.GIFT] = arg0_29.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_29.cameraRole2,
		[var0_0.CAMERA.PHOTO] = var3_29:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook)),
		[var0_0.CAMERA.PHOTO_FREE] = var3_29:Find("PhotoFree Controller"),
		[var0_0.CAMERA.POV] = var3_29:Find("FP Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)),
		[var0_0.CAMERA.SKIN] = arg0_29.room:isPersonalRoom() and var3_29:Find("Skin Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)) or nil
	}

	setActive(arg0_29.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"), true)

	arg0_29.compPovAim = arg0_29.cameras[var0_0.CAMERA.POV]:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_29.cameraRoot = var3_29
	arg0_29.POVOriginalFOV = arg0_29:GetPOVFOV()
	arg0_29.restrictedBox = GameObject.Find("RestrictedArea").transform

	setActive(arg0_29.restrictedBox, false)

	local var5_29 = arg0_29.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(CharacterController)).radius

	arg0_29.isMultiFloor = arg0_29.restrictedBox.childCount > 2

	local var6_29 = "Floor"
	local var7_29 = "Celling"

	if arg0_29.isMultiFloor then
		arg0_29.restrictedHeightRange = {}

		for iter0_29 = 0, math.floor(arg0_29.restrictedBox.childCount / 2) - 1 do
			local var8_29 = iter0_29 == 0 and var6_29 or var6_29 .. "_" .. iter0_29
			local var9_29 = iter0_29 == 0 and var7_29 or var7_29 .. "_" .. iter0_29

			table.insert(arg0_29.restrictedHeightRange, {
				arg0_29.restrictedBox:Find(var8_29).position.y + var5_29,
				arg0_29.restrictedBox:Find(var9_29).position.y - var5_29
			})
		end
	else
		arg0_29.restrictedHeightRange = {
			arg0_29.restrictedBox:Find(var6_29).position.y + var5_29,
			arg0_29.restrictedBox:Find(var7_29).position.y - var5_29
		}
	end

	arg0_29.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_29.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent("DayNightCtrl")

	arg0_29:SwitchDayNight(arg0_29.contextData.timeIndex)

	arg0_29.tfCutIn = getSceneRootTFDic(SceneManager.GetSceneByName(var0_29 .. "_base")).CutIn

	if arg0_29.tfCutIn then
		arg0_29.modelCutIn = {
			lady = arg0_29.tfCutIn:Find("lady"):GetChild(0),
			player = arg0_29.tfCutIn:Find("player"):GetChild(0)
		}

		setActive(arg0_29.tfCutIn, false)
	end
end

function var0_0.SwitchDayNight(arg0_32, arg1_32, arg2_32)
	if arg2_32 and not IsNil(arg2_32) then
		arg2_32:SwitcherToIndex(arg1_32 - 1)
	elseif not IsNil(arg0_32.daynightCtrlComp) then
		arg0_32.daynightCtrlComp:SwitcherToIndex(arg1_32 - 1)
	end

	arg0_32:InitLightSettings()
end

function var0_0.InitLightSettings(arg0_33)
	arg0_33.globalVolume = GameObject.Find("GlobalVolume")

	arg0_33:RegisterGlobalVolume()

	arg0_33.characterLight = GameObject.Find("CharacterLight")

	arg0_33:RecordCharacterLight()

	local var0_33 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_33:GetComponentsInChildren(typeof(Light), true), function(arg0_34, arg1_34)
		arg1_34.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.ResetSceneStructure(arg0_35, arg1_35)
	table.IpairsCArray(arg1_35:GetRootGameObjects(), function(arg0_36, arg1_36)
		if arg1_36.name == "Furnitures" then
			arg0_35.furnitures = tf(arg1_36)

			eachChild(arg0_35.furnitures, function(arg0_37)
				if arg0_37:Find("FreeLook Camera") then
					setActive(arg0_37:Find("FreeLook Camera"), false)
				end

				if arg0_37:Find("FreeLook Camera") then
					setActive(arg0_37:Find("RoleWatch Camera"), false)
				end

				if arg0_37:Find("IKCamera") then
					setActive(arg0_37:Find("IKCamera"), false)
				end

				local var0_37 = arg0_37:GetComponent(typeof(UnityEngine.Collider))

				if not var0_37 then
					return
				end

				var0_37.enabled = false
			end)
		end
	end)
end

function var0_0.InitSlots(arg0_38)
	local var0_38 = arg0_38.room:GetSlots()
	local var1_38 = arg0_38.modelRoot:GetComponentsInChildren(typeof(Transform), true):ToTable()

	arg0_38.slotDict = {}

	_.each(var0_38, function(arg0_39)
		local var0_39 = arg0_39:GetFurnitureName()
		local var1_39 = arg0_39:GetConfigID()
		local var2_39 = arg0_38.slotRoot:Find(tostring(var1_39))

		if not var2_39 then
			errorMsg("Not Find Slot: " .. var1_39)

			return
		end

		local var3_39 = {
			trans = var2_39,
			sceneHides = {}
		}
		local var4_39 = var2_39:Find("Selector")

		if var4_39 then
			GetOrAddComponent(var4_39, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_40, arg1_40)
				arg0_38:emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_39)
			end)
			setActive(var4_39, false)
		end

		local var5_39

		for iter0_39, iter1_39 in ipairs(var1_38) do
			if iter1_39.name == var0_39 then
				var5_39 = iter1_39

				break
			end
		end

		if var5_39 then
			var3_39.model = var5_39
		end

		arg0_38.slotDict[var1_39] = var3_39
	end)
end

function var0_0.SetContactStateDic(arg0_41, arg1_41)
	arg0_41.contactStateDic = arg1_41
	arg0_41.hideContactStateDic = {}
	arg0_41.contactInRangeDic = {}
	arg0_41.transRangeDic = {
		list = {}
	}
	arg0_41.transformFilter = arg0_41.transformFilter or BLHX.Rendering.TransformFilter.New()

	for iter0_41, iter1_41 in pairs(arg0_41.contactStateDic) do
		arg0_41.hideContactStateDic[iter0_41] = math.min(iter1_41, ApartmentRoom.ITEM_UNLOCK)
		arg0_41.contactInRangeDic[iter0_41] = false

		local var0_41 = pg.dorm3d_collection_template[iter0_41].vfx_prefab

		arg0_41.transRangeDic[iter0_41] = {
			#arg0_41.transRangeDic.list + 1,
			#var0_41
		}

		table.insertto(arg0_41.transRangeDic.list, underscore.map(var0_41, function(arg0_42)
			return arg0_41.modelRoot:Find(arg0_42)
		end))
	end

	arg0_41.transformFilter:Init(arg0_41.mainCameraTF, arg0_41.transRangeDic.list, 2, 60)
	arg0_41:ActiveContact()
end

function var0_0.TempHideContact(arg0_43, arg1_43)
	arg0_43.hideConcatFlag = arg1_43

	arg0_43:ActiveContact()
end

function var0_0.ActiveContact(arg0_44)
	for iter0_44, iter1_44 in pairs(arg0_44.contactInRangeDic) do
		arg0_44:UpdateContactDisplay(iter0_44, arg0_44.contactInRangeDic[iter0_44] and not arg0_44.hideConcatFlag and arg0_44.contactStateDic[iter0_44] or arg0_44.hideContactStateDic[iter0_44])
	end
end

function var0_0.UpdateContactDisplay(arg0_45, arg1_45, arg2_45)
	local var0_45 = pg.dorm3d_collection_template[arg1_45]

	for iter0_45, iter1_45 in ipairs(var0_45.vfx_prefab) do
		local var1_45 = arg0_45.modelRoot:Find(iter1_45)

		if arg0_45:IsModeInHidePending(iter1_45) then
			-- block empty
		elseif not arg0_45.modelRoot:Find(iter1_45) then
			warning(arg1_45, iter1_45)
		else
			setActive(var1_45, arg2_45 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_45, iter3_45 in ipairs(var0_45.model) do
		if arg0_45:IsModeInHidePending(iter3_45) then
			-- block empty
		elseif not arg0_45.modelRoot:Find(iter3_45) then
			warning(arg1_45, iter3_45)
		else
			local var2_45 = arg0_45.modelRoot:Find(iter3_45)

			if arg0_45:CheckSceneItemActive(var2_45) then
				local var3_45 = GetComponent(var2_45, typeof(EventTriggerListener))

				if arg2_45 == ApartmentRoom.ITEM_FIRST then
					var3_45 = var3_45 or GetOrAddComponent(var2_45, typeof(EventTriggerListener))

					var3_45:AddPointClickFunc(function(arg0_46, arg1_46)
						arg0_45:emit(var0_0.CLICK_CONTACT, arg1_45)
					end)

					var3_45.enabled = true
				elseif var3_45 then
					var3_45.enabled = false
				end

				setActive(var2_45, arg2_45 > ApartmentRoom.ITEM_LOCK)
			end
		end
	end
end

function var0_0.SetFloatEnable(arg0_47, arg1_47)
	arg0_47.enableFloatUpdate = arg1_47

	if arg1_47 then
		arg0_47:UpdateFloatPosition()
	end
end

function var0_0.UpdateFloatPosition(arg0_48)
	local var0_48 = arg0_48:GetCurrentLadyEnv()
	local var1_48 = arg0_48:GetScreenPosition(var0_48.ladyHeadCenter.position + Vector3(0, 0.2, 0))
	local var2_48 = arg0_48:GetLocalPosition(var1_48, arg0_48.rtFloatPage)

	setLocalPosition(arg0_48.rtFloatPage:Find("lady"), var2_48)
end

function var0_0.LoadCharacter(arg0_49, arg1_49, arg2_49)
	arg0_49.hxMatDict = {}
	arg0_49.ladyDict = {}
	arg0_49.skinDict = {}

	local var0_49 = {}

	for iter0_49, iter1_49 in ipairs(arg1_49) do
		table.insert(var0_49, function(arg0_50)
			arg0_49:LoadSingleCharacter(iter1_49, arg0_50)
		end)
	end

	parallelAsync(var0_49, arg2_49)
end

function var0_0.LoadCharacterAdditionally(arg0_51, arg1_51, arg2_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in ipairs(arg1_51) do
		table.insert(var0_51, function(arg0_52)
			arg0_51:LoadSingleCharacter(iter1_51, function()
				arg0_51:InitCharacter(arg0_51.ladyDict[iter1_51], iter1_51)
				arg0_52()
			end)
		end)
	end

	parallelAsync(var0_51, arg2_51)
end

function var0_0.LoadSingleCharacter(arg0_54, arg1_54, arg2_54)
	local var0_54 = {}
	local var1_54 = LadyEnv.New(arg0_54)

	arg0_54.ladyDict[arg1_54] = var1_54

	local var2_54 = getProxy(ApartmentProxy):getApartment(arg1_54)
	local var3_54 = var2_54:getConfig("asset_name")
	local var4_54 = var2_54:GetSkinModelID(arg0_54.room:getConfig("tag"))
	local var5_54 = Dorm3dSkin.New({
		configId = var4_54
	}):GetModelName()

	assert(var5_54)

	for iter0_54, iter1_54 in ipairs({
		"common",
		var5_54
	}) do
		local var6_54 = string.format("dorm3d/character/%s/res/%s", var3_54, iter1_54)

		if checkABExist(var6_54) then
			table.insert(var0_54, function(arg0_55)
				arg0_54.loader:LoadBundle(var6_54, function(arg0_56)
					for iter0_56, iter1_56 in ipairs(arg0_56:GetAllAssetNames()) do
						local var0_56, var1_56, var2_56 = string.find(string.lower(iter1_56), "material_hx[/\\](.*).mat")

						if var0_56 then
							arg0_54.hxMatDict[var2_56 .. " (Instance)"] = {
								arg0_56,
								iter1_56
							}
							arg0_54.hxMatDict[var2_56] = {
								arg0_56,
								iter1_56
							}
						end
					end

					arg0_55()
				end)
			end)
		end
	end

	var1_54.skinId = var4_54
	var1_54.skinIdList = {
		var4_54
	}

	table.insert(var0_54, function(arg0_57)
		local var0_57 = string.format("dorm3d/character/%s/prefabs/%s", var3_54, var5_54)

		arg0_54.loader:GetPrefab(var0_57, "", function(arg0_58)
			var1_54.ladyGameObject = arg0_58
			arg0_54.skinDict[var4_54] = {
				ladyGameObject = arg0_58
			}

			arg0_57()
		end)
	end)

	if arg0_54.room:isPersonalRoom() then
		for iter2_54, iter3_54 in ipairs(var2_54:GetAllModelIds()) do
			if not table.contains(var1_54.skinIdList, iter3_54) then
				local var7_54 = Dorm3dSkin.New({
					configId = iter3_54
				})

				if var7_54:IsShow() then
					local var8_54 = var7_54:GetModelName()
					local var9_54 = string.format("dorm3d/character/%s/prefabs/%s", var3_54, var8_54)

					if checkABExist(var9_54) then
						table.insert(var1_54.skinIdList, iter3_54)
						table.insert(var0_54, function(arg0_59)
							arg0_54.loader:GetPrefab(var9_54, "", function(arg0_60)
								arg0_54.skinDict[iter3_54] = {
									ladyGameObject = arg0_60
								}
								GetComponent(arg0_60, "GraphOwner").enabled = false

								setActive(arg0_60, false)
								arg0_59()
							end)
						end)
					end
				end
			end
		end
	end

	if arg0_54.contextData.pendingDic[arg1_54] then
		local var10_54 = pg.dorm3d_welcome[arg0_54.contextData.pendingDic[arg1_54]]

		if var10_54.item_prefab ~= "" then
			table.insert(var0_54, function(arg0_61)
				local var0_61 = string.lower("dorm3d/furniture/item/" .. var10_54.item_prefab)

				arg0_54.loader:GetPrefab(var0_61, "", function(arg0_62)
					var1_54.tfPendintItem = arg0_62.transform

					setActive(arg0_62, false)
					arg0_61()
				end)
			end)
		end
	end

	parallelAsync(var0_54, arg2_54)
end

function var0_0.HXCharacter(arg0_63, arg1_63)
	if not HXSet.isHx() then
		return
	end

	if Dorm3dHxHelper.ReplaceCharacterParts(arg1_63) then
		return
	end

	local var0_63 = arg1_63:GetComponentsInChildren(typeof(SkinnedMeshRenderer), true)

	table.IpairsCArray(var0_63, function(arg0_64, arg1_64)
		local var0_64 = arg1_64.sharedMaterials
		local var1_64 = false

		table.IpairsCArray(var0_64, function(arg0_65, arg1_65)
			if arg1_65 == nil then
				return
			end

			local var0_65 = arg1_65.name

			if not arg0_63.hxMatDict[var0_65] then
				return
			end

			var1_64 = true

			local var1_65, var2_65 = unpack(arg0_63.hxMatDict[var0_65])
			local var3_65 = var1_65:LoadAssetSync(var2_65, typeof(Material), false, false)

			var0_64[arg0_65] = var3_65

			warning("Replace HX Material", arg0_63.hxMatDict[var0_65][2])
		end)

		if var1_64 then
			arg1_64.sharedMaterials = var0_64

			GraphicsInterface.Instance:UpdateCharacterMaterialLst(go(arg1_63))
		end
	end)
end

function var0_0.InitHolyLight(arg0_66)
	local var0_66 = {}

	for iter0_66, iter1_66 in pairs(arg0_66.ladyDict) do
		table.insert(var0_66, iter1_66.lady)
	end

	Dorm3dHxHelper.ShowHolyLight(var0_66, arg0_66.holyLightRoot, true)
end

function var0_0.InitCharacter(arg0_67, arg1_67, arg2_67)
	arg1_67:InitCharacter(arg2_67)
	Dorm3dHxHelper.HideCharacterPart(arg1_67.lady)
	arg0_67:HXCharacter(arg1_67.lady)
	arg1_67:SetZone(arg0_67.contextData.ladyZone[arg2_67])
	arg0_67:ChangeCharacterPosition(arg1_67)
end

function var0_0.SetCameraLady(arg0_68, arg1_68)
	arg0_68.cameraAim2.LookAt = arg1_68.ladyInterestRoot
	arg0_68.cameras[var0_0.CAMERA.TALK].Follow = arg1_68.ladyInterestRoot
	arg0_68.cameras[var0_0.CAMERA.TALK].LookAt = arg1_68.ladyInterestRoot
	arg0_68.cameraGift.Follow = arg0_68.ladyInterest
	arg0_68.cameraGift.LookAt = arg0_68.ladyInterest
	arg0_68.cameraRole2.LookAt = arg1_68.ladyInterestRoot
	arg0_68.cameras[var0_0.CAMERA.PHOTO].Follow = arg0_68.ladyInterest
	arg0_68.cameras[var0_0.CAMERA.PHOTO].LookAt = arg0_68.ladyInterest
end

function var0_0.initNodeCanvas(arg0_69)
	local var0_69 = pg.NodeCanvasMgr.GetInstance()

	var0_69:Active()
	var0_69:RegisterFunc("DistanceTrigger", function(arg0_70)
		arg0_69:emit(var0_0.DISTANCE_TRIGGER, arg0_70, arg0_69.ladyDict[arg0_70].dis)
	end)
	var0_69:RegisterFunc("ShortWaitAction", function(arg0_71)
		arg0_69:DoShortWait(arg0_71)
	end)
	var0_69:RegisterFunc("WatchShortWaitAction", function(arg0_72)
		arg0_69:DoShortWait(arg0_72)
	end)
	var0_69:RegisterFunc("WalkDistanceTrigger", function(arg0_73)
		arg0_69:emit(var0_0.WALK_DISTANCE_TRIGGER, arg0_73, arg0_69.ladyDict[arg0_73].dis)
	end)
	var0_69:RegisterFunc("ChangeWatch", function(arg0_74)
		arg0_69:emit(var0_0.CHANGE_WATCH, arg0_74)
	end)
end

function var0_0.SetAllBlackbloardValue(arg0_75, arg1_75, arg2_75)
	arg0_75[arg1_75] = arg2_75

	for iter0_75, iter1_75 in pairs(arg0_75.ladyDict) do
		arg0_75:SetBlackboardValue(iter1_75, arg1_75, arg2_75)
	end
end

function var0_0.SetBlackboardValue(arg0_76, arg1_76, arg2_76, arg3_76)
	arg1_76:SetBlackboardValue(arg2_76, arg3_76)
end

function var0_0.GetBlackboardValue(arg0_77, arg1_77, arg2_77)
	return arg1_77:GetBlackboardValue(arg2_77)
end

function var0_0.didEnter(arg0_78)
	local var0_78 = -21.6 / Screen.height

	arg0_78.joystickDelta = Vector2.zero
	arg0_78.joystickTimer = FrameTimer.New(function()
		local var0_79 = arg0_78.joystickDelta * var0_78
		local var1_79 = var0_79.x
		local var2_79 = var0_79.y

		local function var3_79(arg0_80, arg1_80, arg2_80)
			local var0_80 = arg0_80[arg1_80]

			var0_80.m_InputAxisValue = arg2_80
			arg0_80[arg1_80] = var0_80
		end

		if arg0_78.surroudCamera and not arg0_78.pinchMode then
			var3_79(arg0_78.surroudCamera, "m_XAxis", var1_79)
			var3_79(arg0_78.surroudCamera, "m_YAxis", var2_79)
		elseif arg0_78.furniturePOV and arg0_78.cameras[var0_0.CAMERA.FURNITURE_WATCH] and isActive(arg0_78.cameras[var0_0.CAMERA.FURNITURE_WATCH]) then
			var3_79(arg0_78.furniturePOV, "m_HorizontalAxis", var1_79)
			var3_79(arg0_78.furniturePOV, "m_VerticalAxis", var2_79)
		end

		arg0_78.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_78.joystickTimer:Start()

	local var1_78 = 1.75

	arg0_78.moveStickTimer = FrameTimer.New(function()
		if not arg0_78.moveStickDraging then
			return
		end

		local var0_81 = arg0_78.moveStickPosition
		local var1_81 = 200
		local var2_81 = (var0_81 - arg0_78.moveStickOrigin):ClampMagnitude(var1_81)
		local var3_81 = var2_81 / var1_81

		arg0_78.moveStickPosition = arg0_78.moveStickOrigin + var2_81

		local var4_81 = Vector3.New(var3_81.x, 0, var3_81.y)
		local var5_81 = arg0_78.mainCameraTF:TransformDirection(var4_81)

		var5_81.y = 0

		local var6_81 = var5_81:Normalize()

		var6_81:Mul(var1_78)

		if isActive(arg0_78.cameras[var0_0.CAMERA.POV]) then
			arg0_78.playerController:SimpleMove(var6_81)

			arg0_78.tweenFOV = true
		elseif isActive(arg0_78.cameras[var0_0.CAMERA.PHOTO_FREE]) then
			arg0_78.cameras[var0_0.CAMERA.PHOTO_FREE]:GetComponent(typeof(UnityEngine.CharacterController)):Move(var6_81 * Time.deltaTime)
			arg0_78:emit(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, var3_81:Normalize())
			onNextTick(function()
				local var0_82 = arg0_78.cameras[var0_0.CAMERA.PHOTO_FREE]
				local var1_82 = arg0_78:GetRestritedHeightRange()
				local var2_82 = math.InverseLerp(var1_82[1], var1_82[2], var0_82.position.y)

				arg0_78:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var2_82)
			end)
		end
	end, 1, -1)

	arg0_78.moveStickTimer:Start()

	arg0_78.pinchMode = false
	arg0_78.pinchSize = 0
	arg0_78.pinchValue = 1
	arg0_78.pinchNodeOrder = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_83, arg1_83)
		if arg0_78.surroudCamera and isActive(arg0_78.surroudCamera) then
			arg0_78.pinchMode = true
			arg0_78.pinchSize = (arg0_83 - arg1_83):Magnitude()
			arg0_78.pinchNodeOrder = arg1_83.x < arg0_83.x and -1 or 1

			return
		end

		if isActive(arg0_78.cameras[var0_0.CAMERA.POV]) then
			if (arg0_83 - arg1_83):Magnitude() < Screen.height * 0.5 then
				arg0_78.pinchMode = true
				arg0_78.pinchSize = (arg0_83 - arg1_83):Magnitude()
				arg0_78.pinchNodeOrder = arg1_83.x < arg0_83.x and -1 or 1
			end

			return
		end
	end)

	local var2_78 = 0.01

	if IsUnityEditor then
		var2_78 = 0.1
	end

	local var3_78 = var2_78 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_84, arg1_84)
		if not arg0_78.pinchMode then
			return
		end

		local var0_84 = (arg0_84 - arg1_84):Magnitude()
		local var1_84 = arg0_78.pinchSize - var0_84
		local var2_84 = arg0_78.pinchNodeOrder * (arg1_84.x < arg0_84.x and -1 or 1)
		local var3_84 = var1_84 * var3_78 * var2_84

		if isActive(arg0_78.cameras[var0_0.CAMERA.POV]) then
			local var4_84 = 0.5
			local var5_84 = 1

			arg0_78.pinchValue = math.clamp(arg0_78.pinchValue + var3_84, var4_84, var5_84)
			arg0_78.pinchSize = var0_84

			arg0_78:SetPOVFOV(arg0_78.POVOriginalFOV * arg0_78.pinchValue)

			arg0_78.tweenFOV = nil

			return
		end

		if isActive(arg0_78.surroudCamera) and arg0_78.surroudCamera == arg0_78.cameras[var0_0.CAMERA.PHOTO] then
			local var6_84 = 0.5
			local var7_84 = 1

			arg0_78:SetPinchValue(math.clamp(arg0_78.pinchValue + var3_84, var6_84, var7_84))

			arg0_78.pinchSize = var0_84

			return
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_78.pinchMode = false
		arg0_78.pinchSize = 0
	end)

	arg0_78.cameraBlendCallbacks = {}
	arg0_78.activeCMCamera = nil

	function arg0_78.camBrainEvenetHandler.OnBlendStarted(arg0_86)
		if arg0_78.activeCMCamera then
			arg0_78:OnCameraBlendFinished(arg0_78.activeCMCamera)
		end

		local var0_86 = arg0_78.camBrain.ActiveVirtualCamera

		arg0_78.activeCMCamera = var0_86
	end

	function arg0_78.camBrainEvenetHandler.OnBlendFinished(arg0_87)
		arg0_78.activeCMCamera = nil

		arg0_78:OnCameraBlendFinished(arg0_87)
	end

	arg0_78.expressionDict = {}

	arg0_78:OverlayPanel(arg0_78.blockLayer)
	arg0_78:ActiveCamera(arg0_78.cameras[var0_0.CAMERA.POV])

	local var4_78
	local var5_78
	local var6_78 = arg0_78.resumeCallback

	function arg0_78.resumeCallback()
		var5_78 = true

		if var4_78 then
			existCall(var6_78)
		end
	end

	arg0_78:RefreshSlots(nil, function()
		var4_78 = true
		arg0_78.doneFirstSlotFresh = true

		if var5_78 then
			existCall(var6_78)
		end
	end)

	arg0_78.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_78:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_78.updateHandler)
	arg0_78:InitExtraSystem()
end

function var0_0.InitData(arg0_93)
	if not arg0_93.contextData.ladyZone then
		arg0_93.contextData.ladyZone = {}

		local var0_93
		local var1_93 = arg0_93.room:getConfig("default_zone")

		for iter0_93, iter1_93 in ipairs(var1_93) do
			arg0_93.contextData.ladyZone[iter1_93[1]] = iter1_93[2]

			if table.contains(arg0_93.contextData.groupIds, iter1_93[1]) then
				var0_93 = var0_93 or arg0_93.contextData.ladyZone[iter1_93[1]]
			end
		end

		arg0_93.contextData.inFurnitureName = var0_93 or var1_93[1][2]
	end

	arg0_93.zoneDatas = _.select(arg0_93.room:GetZones(), function(arg0_94)
		return not arg0_94:IsGlobal()
	end)
	arg0_93.activeLady = {}
end

function var0_0.Update(arg0_95)
	arg0_95.raycastCamera.fieldOfView = arg0_95.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	if arg0_95.tweenFOV then
		local var0_95 = Damp(1, 1, Time.deltaTime)

		arg0_95.pinchValue = Mathf.Lerp(arg0_95.pinchValue, 1, var0_95)

		arg0_95:SetPOVFOV(arg0_95.POVOriginalFOV * arg0_95.pinchValue)

		if arg0_95.pinchValue > 0.99 then
			arg0_95.tweenFOV = nil
		end
	end

	if isActive(arg0_95.cameras[var0_0.CAMERA.POV]) then
		arg0_95:TriggerLadyDistance()
	end

	if arg0_95.contactInRangeDic then
		local var1_95 = arg0_95.transformFilter:Execute():ToTable()

		for iter0_95, iter1_95 in pairs(arg0_95.contactInRangeDic) do
			local var2_95 = pg.dorm3d_collection_template[iter0_95]
			local var3_95 = arg0_95.transRangeDic[iter0_95]
			local var4_95 = underscore(var1_95):chain():slice(unpack(var3_95)):any(function(arg0_96)
				return arg0_96
			end):value()

			if tobool(iter1_95) ~= var4_95 then
				arg0_95.contactInRangeDic[iter0_95] = var4_95

				arg0_95:UpdateContactDisplay(iter0_95, var4_95 and not arg0_95.hideConcatFlag and arg0_95.contactStateDic[iter0_95] or arg0_95.hideContactStateDic[iter0_95])
			end
		end
	end

	if arg0_95.enableFloatUpdate then
		arg0_95:UpdateFloatPosition()
	end

	arg0_95:CheckInSector()

	if arg0_95.systemManager then
		arg0_95.systemManager:Update(Time.deltaTime)
	end
end

function var0_0.CheckInSector(arg0_97)
	if not isActive(arg0_97.cameras[var0_0.CAMERA.POV]) then
		return
	end

	local var0_97 = arg0_97.mainCameraTF.position

	for iter0_97, iter1_97 in pairs(arg0_97.ladyDict) do
		if iter1_97.lady then
			local var1_97 = tobool(arg0_97.activeLady[iter0_97])
			local var2_97 = {
				Radius = 2,
				Angle = 120,
				Position = iter1_97.lady.position,
				Rotation = iter1_97.lady.rotation
			}

			if var1_97 ~= tobool(var0_0.IsPointInSector(var2_97, var0_97)) then
				arg0_97.activeLady[iter0_97] = not var1_97

				arg0_97:emit(var0_0.ON_ENTER_SECTOR, iter0_97)
			end
		end
	end
end

function var0_0.TriggerLadyDistance(arg0_98)
	for iter0_98, iter1_98 in pairs(arg0_98.ladyDict) do
		if iter1_98.lady then
			iter1_98.dis = (iter1_98.lady.position - arg0_98.player.position).magnitude

			if (arg0_98:GetBlackboardValue(iter1_98, "inPending") and var0_0.POV_PENDING_CLOSE_DISTANCE or var0_0.POV_CLOSE_DISTANCE) > iter1_98.dis ~= arg0_98:GetBlackboardValue(iter1_98, "inDistance") then
				arg0_98:SetBlackboardValue(iter1_98, "inDistance", iter1_98.dis < var0_0.POV_CLOSE_DISTANCE)
				arg0_98:emit(var0_0.ON_CHANGE_DISTANCE, iter0_98, iter1_98.dis < var0_0.POV_CLOSE_DISTANCE)
			end
		end
	end
end

function var0_0.OnStickMove(arg0_99, arg1_99)
	arg0_99.joystickDelta = arg1_99
end

function var0_0.SetPinchValue(arg0_100, arg1_100)
	arg0_100.pinchValue = arg1_100

	arg0_100:SetCameraObrits()
end

function var0_0.GetPOVFOV(arg0_101)
	local var0_101 = arg0_101.cameras[var0_0.CAMERA.POV].m_Lens

	return ReflectionHelp.RefGetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_101)
end

function var0_0.SetPOVFOV(arg0_102, arg1_102)
	local var0_102 = arg0_102.cameras[var0_0.CAMERA.POV].m_Lens

	ReflectionHelp.RefSetField(typeof("Cinemachine.LensSettings"), "FieldOfView", var0_102, arg1_102)

	arg0_102.cameras[var0_0.CAMERA.POV].m_Lens = var0_102
end

function var0_0.RefreshSlots(arg0_103, arg1_103, arg2_103)
	arg1_103 = arg1_103 or arg0_103.room

	local var0_103 = arg1_103:GetSlots()
	local var1_103 = arg1_103:GetFurnitures()

	arg0_103:emit(var0_0.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_103, function(arg0_104, arg1_104, arg2_104)
		local var0_104 = arg1_104:GetConfigID()

		if not arg0_103.slotDict[var0_104] then
			return arg2_104()
		end

		local var1_104 = _.detect(var1_103, function(arg0_105)
			return arg0_105:GetSlotID() == var0_104
		end)
		local var2_104 = var1_104 and var1_104:GetModel() or false
		local var3_104 = arg0_103.slotDict[var0_104].model

		arg0_103.slotDict[var0_104].displayModelName = var2_104
		arg0_103.slotDict[var0_104].furnitureId = var1_104 and var1_104:GetConfigID()

		local function var4_104(arg0_106)
			table.Foreach(arg0_103.slotDict[var0_104].sceneHides or {}, function(arg0_107, arg1_107)
				setActive(arg1_107.trans, arg1_107.visible)
			end)

			arg0_103.slotDict[var0_104].sceneHides = {}

			if var3_104 then
				setActive(var3_104, var2_104 == "")
			end

			if arg0_106 then
				local var0_106 = arg0_106:getConfig("scene_hides")

				if #var0_106 > 0 then
					table.Ipairs(var0_106, function(arg0_108, arg1_108)
						local var0_108 = arg0_103.modelRoot:Find(arg1_108)

						assert(var0_108, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_106:GetConfigID(), arg1_108))

						local var1_108 = isActive(var0_108)

						table.insert(arg0_103.slotDict[var0_104].sceneHides, {
							name = arg1_108,
							trans = var0_108,
							visible = var1_108
						})
						setActive(var0_108, false)
					end)
				end
			end
		end

		if var2_104 == false or var2_104 == "" then
			arg0_103.loader:ClearRequest("slot_" .. var0_104)
			var4_104()
			arg2_104()

			return
		end

		local var5_104 = arg0_103.slotDict[var0_104].trans

		if arg0_103.loader:GetLoadingRP("slot_" .. var0_104) then
			arg0_103:emit(var0_0.HIDE_BLOCK)
		end

		arg0_103.loader:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var2_104, "", function(arg0_109)
			assert(arg0_109)
			setParent(arg0_109, var5_104)
			var4_104(var1_104)
			arg2_104()
		end, "slot_" .. var0_104)
	end, function()
		arg0_103:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_103)
		warning("RefreshSlots", "Done")
		arg0_103:emit(Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE)
	end)
end

function var0_0.RefreshSlotsEmpty(arg0_111, arg1_111)
	local var0_111 = Clone(arg0_111.room)

	var0_111.furnitures = {}

	arg0_111:RefreshSlots(var0_111, arg1_111)
end

function var0_0.CheckSceneItemActiveByPath(arg0_112, arg1_112)
	local var0_112 = arg0_112:GetSceneItem(arg1_112)

	return arg0_112:CheckSceneItemActive(var0_112)
end

function var0_0.CheckSceneItemActive(arg0_113, arg1_113)
	local var0_113 = true
	local var1_113

	table.Checkout(arg0_113.slotDict, function(arg0_114, arg1_114)
		if underscore.detect(arg1_114.sceneHides, function(arg0_115)
			return arg0_115.trans == arg1_113
		end) then
			var0_113 = false
			var1_113 = arg1_114.furnitureId

			return false
		end
	end)

	return var0_113, var1_113
end

function var0_0.ChangeCharacterPosition(arg0_116, arg1_116)
	arg0_116:ResetCharPoint(arg1_116, arg1_116.ladyActiveZone)
	arg0_116:SyncInterestTransform(arg1_116)
end

function var0_0.SyncCurrentInterestTransform(arg0_117)
	local var0_117 = arg0_117:GetCurrentLadyEnv()

	arg0_117:SyncInterestTransform(var0_117)
end

function var0_0.SyncInterestTransform(arg0_118, arg1_118)
	arg0_118.ladyInterest.position = arg1_118.ladyInterestRoot.position
	arg0_118.ladyInterest.rotation = arg1_118.ladyInterestRoot.rotation
end

function var0_0.SyncInterestTransformByTf(arg0_119, arg1_119)
	arg0_119.ladyInterest.position = arg1_119.position
	arg0_119.ladyInterest.rotation = arg1_119.rotation
end

function var0_0.ChangePlayerPosition(arg0_120, arg1_120)
	arg1_120 = arg1_120 or arg0_120.contextData.inFurnitureName

	local var0_120 = arg0_120.furnitures:Find(arg1_120):Find("PlayerPoint").position

	arg0_120.player.position = var0_120
	arg0_120.cameras[var0_0.CAMERA.POV].transform.position = arg0_120.playerEye.position

	local var1_120 = arg0_120.ladyInterest.position - arg0_120.playerEye.position
	local var2_120 = Quaternion.LookRotation(var1_120).eulerAngles
	local var3_120 = var2_120.y
	local var4_120 = var2_120.x
	local var5_120 = arg0_120.compPovAim.m_HorizontalAxis

	var5_120.Value = arg0_120:GetNearestAngle(var3_120, var5_120.m_MinValue, var5_120.m_MaxValue)
	arg0_120.compPovAim.m_HorizontalAxis = var5_120

	local var6_120 = arg0_120.compPovAim.m_VerticalAxis

	var6_120.Value = var4_120
	arg0_120.compPovAim.m_VerticalAxis = var6_120
end

function var0_0.GetAttachedFurnitureName(arg0_121)
	return arg0_121.contextData.inFurnitureName
end

function var0_0.GetFurnitureByName(arg0_122, arg1_122)
	return underscore.detect(arg0_122.attachedPoints, function(arg0_123)
		return arg0_123.name == arg1_122
	end)
end

function var0_0.GetSlotByID(arg0_124, arg1_124)
	return arg0_124.displaySlots[arg1_124] and arg0_124.displaySlots[arg1_124].trans
end

function var0_0.GetScreenPosition(arg0_125, arg1_125, arg2_125)
	arg2_125 = arg2_125 or arg0_125.raycastCamera

	local var0_125 = arg2_125:WorldToScreenPoint(arg1_125)

	if var0_125.z < 0 then
		var0_125.x = var0_125.x + (var0_125.x < 0 and -1 or 1) * Screen.width
		var0_125.y = var0_125.y + (var0_125.y < 0 and -1 or 1) * Screen.height
		var0_125.z = -var0_125.z
	end

	return var0_125
end

function var0_0.GetLocalPosition(arg0_126, arg1_126, arg2_126)
	return LuaHelper.ScreenToLocal(arg2_126, arg1_126, pg.UIMgr.GetInstance().uiCameraComp)
end

function var0_0.GetModelRoot(arg0_127)
	return arg0_127.modelRoot
end

function var0_0.ShiftZoneSafe(arg0_128, arg1_128)
	local var0_128 = {}

	if arg0_128.room:isPersonalRoom() and not arg0_128:GetBlackboardValue(arg0_128:GetCurrentLadyEnv(), "inPending") then
		table.insert(var0_128, function(arg0_129)
			arg0_128:OutOfLazy(arg0_128.apartment:GetConfigID(), arg0_129)
		end)
	end

	table.insert(var0_128, function(arg0_130)
		arg0_128:ShiftZone(arg1_128, arg0_130)
	end)
	seriesAsync(var0_128, function()
		arg0_128:CheckQueue()
	end)
end

function var0_0.ShiftZone(arg0_132, arg1_132, arg2_132)
	local var0_132 = arg0_132:GetFurnitureByName(arg1_132)

	if not var0_132 then
		errorMsg(arg1_132 .. " Not Find")
		existCall(arg2_132)

		return
	end

	seriesAsync({
		function(arg0_133)
			arg0_132:emit(var0_0.SHOW_BLOCK)
			arg0_132:ShowBlackScreen(true, arg0_133)
		end,
		function(arg0_134)
			if arg0_132.shiftLady or arg0_132.room:isPersonalRoom() then
				local var0_134 = arg0_132.shiftLady or arg0_132.apartment:GetConfigID()

				arg0_132.shiftLady = nil
				arg0_132.contextData.ladyZone[var0_134] = var0_132.name

				local var1_134 = arg0_132.ladyDict[var0_134]

				var1_134:SetZone(arg0_132.contextData.ladyZone[var0_134])

				if arg0_132:GetBlackboardValue(var1_134, "inPending") then
					arg0_132:SetOutPending(var1_134)
					arg0_132:SwitchAnim(var1_134, var0_0.ANIM.IDLE)
					onNextTick(function()
						arg0_132:ChangeCharacterPosition(var1_134)
						arg0_134()
					end)
				else
					arg0_132:ChangeCharacterPosition(var1_134)
					arg0_134()
				end
			else
				arg0_134()
			end
		end,
		function(arg0_136)
			arg0_132.contextData.inFurnitureName = var0_132.name

			if SlideExtraSystem.IsOpen(arg0_132.room) and arg0_132.contextData.inFurnitureName == SlideConst.SLIDE_ZONE then
				arg0_132:SyncInterestTransformByTf(var0_132.transform:Find("StayPoint"))
			elseif not arg0_132.apartment then
				for iter0_136, iter1_136 in pairs(arg0_132.ladyDict) do
					if iter1_136.ladyBaseZone == arg0_132.contextData.inFurnitureName then
						arg0_132:SyncInterestTransform(iter1_136)

						break
					end
				end
			end

			arg0_132:ChangePlayerPosition()
			arg0_132:TriggerLadyDistance()
			arg0_132:CheckInSector()
			arg0_136()
		end,
		function(arg0_137)
			arg0_132:UpdateZoneList()
			arg0_132:ShowBlackScreen(false, arg0_137)
		end,
		function(arg0_138)
			arg0_132:emit(var0_0.HIDE_BLOCK)
			arg0_138()
		end
	}, arg2_132)
end

function var0_0.ActiveCamera(arg0_139, arg1_139)
	local var0_139 = isActive(arg1_139)

	table.Foreach(arg0_139.cameras, function(arg0_140, arg1_140)
		setActive(arg1_140, arg1_140 == arg1_139)
	end)

	if var0_139 then
		arg0_139:OnCameraBlendFinished(arg1_139)
	end
end

function var0_0.ActiveCameraByName(arg0_141, arg1_141)
	local var0_141 = arg0_141.cameraRoot:Find(arg1_141)

	assert(var0_141, "ActiveCameraByName: " .. arg1_141 .. " not found")
	table.Foreach(arg0_141.cameras, function(arg0_142, arg1_142)
		setActive(arg1_142, false)
	end)
	setActive(var0_141, true)

	arg0_141.cameras[var0_0.CAMERA.CUSTOM] = var0_141:GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
end

function var0_0.ShowBlackScreen(arg0_143, arg1_143, arg2_143)
	local var0_143 = arg0_143.blackSceneInfo or {
		color = "#000000",
		time = 0.3,
		delay = arg1_143 and 0 or 0.3
	}

	setImageColor(arg0_143.blackLayer, Color.NewHex(var0_143.color))
	setActive(arg0_143.blackLayer, true)
	setCanvasGroupAlpha(arg0_143.blackLayer, arg1_143 and 0 or 1)
	arg0_143:managedTween(LeanTween.alphaCanvas, function()
		if not arg1_143 then
			setActive(arg0_143.blackLayer, false)
		end

		existCall(arg2_143)
	end, GetComponent(arg0_143.blackLayer, typeof(CanvasGroup)), arg1_143 and 1 or 0, var0_143.time):setDelay(var0_143.delay)
end

function var0_0.RegisterOrbits(arg0_145, arg1_145)
	arg0_145 = arg0_145.scene
	arg0_145.orbits = {
		original = arg1_145.m_Orbits
	}
	arg0_145.orbits.current = _.range(3):map(function(arg0_146)
		local var0_146 = arg0_145.orbits.original[arg0_146 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_146.m_Height, var0_146.m_Radius)
	end)
	arg0_145.surroudCamera = arg1_145
end

function var0_0.SetCameraObrits(arg0_147)
	arg0_147 = arg0_147.scene

	local var0_147 = arg0_147.surroudCamera

	if not var0_147 then
		return
	end

	local var1_147 = arg0_147.orbits.original[1]

	for iter0_147 = 0, #arg0_147.orbits.current - 1 do
		local var2_147 = arg0_147.orbits.current[iter0_147 + 1]
		local var3_147 = arg0_147.orbits.original[iter0_147]

		var2_147.m_Height = math.lerp(var1_147.m_Height, var3_147.m_Height, arg0_147.pinchValue)
		var2_147.m_Radius = var3_147.m_Radius * arg0_147.pinchValue
	end

	var0_147.m_Orbits = arg0_147.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_148)
	arg0_148 = arg0_148.scene

	local var0_148 = arg0_148.surroudCamera

	if not var0_148 then
		return
	end

	for iter0_148 = 0, #arg0_148.orbits.current - 1 do
		local var1_148 = arg0_148.orbits.current[iter0_148 + 1]
		local var2_148 = arg0_148.orbits.original[iter0_148]

		var1_148.m_Height = var2_148.m_Height
		var1_148.m_Radius = var2_148.m_Radius
	end

	var0_148.m_Orbits = arg0_148.orbits.current
	arg0_148.surroudCamera = nil
end

function var0_0.ActiveStateCamera(arg0_149, arg1_149, arg2_149)
	local var0_149 = {
		base = function(arg0_150)
			arg0_149:RegisterCameraBlendFinished(arg0_149.cameras[var0_0.CAMERA.POV], arg0_150)
			arg0_149:ActiveCamera(arg0_149.cameras[var0_0.CAMERA.POV])
		end,
		watch = function(arg0_151)
			assert(arg0_149.apartment)
			arg0_149:SyncInterestTransform(arg0_149:GetCurrentLadyEnv())
			arg0_149:SetCameraLady(arg0_149:GetCurrentLadyEnv())
			arg0_149:RegisterCameraBlendFinished(arg0_149.cameras[var0_0.CAMERA.ROLE], arg0_151)
			arg0_149:ActiveCamera(arg0_149.cameras[var0_0.CAMERA.ROLE])
		end,
		walk = function(arg0_152)
			arg0_149:RegisterCameraBlendFinished(arg0_149.cameras[var0_0.CAMERA.POV], arg0_152)
			arg0_149:ActiveCamera(arg0_149.cameras[var0_0.CAMERA.POV])
		end,
		ik = function(arg0_153)
			arg0_153()
		end,
		gift = function(arg0_154)
			assert(arg0_149.apartment)
			arg0_149:SetCameraLady(arg0_149:GetCurrentLadyEnv())
			arg0_149:RegisterCameraBlendFinished(arg0_149.cameras[var0_0.CAMERA.GIFT], arg0_154)
			arg0_149:ActiveCamera(arg0_149.cameras[var0_0.CAMERA.GIFT])
		end,
		standby = function(arg0_155)
			assert(arg0_149.apartment)
			arg0_149:SetCameraLady(arg0_149:GetCurrentLadyEnv())

			arg0_149.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_149.cameraRole.transform.position

			arg0_149:RegisterCameraBlendFinished(arg0_149.cameras[var0_0.CAMERA.ROLE2], arg0_155)
			arg0_149:ActiveCamera(arg0_149.cameras[var0_0.CAMERA.ROLE2])
		end,
		talk = function(arg0_156)
			assert(arg0_149.apartment)
			arg0_149:SetCameraLady(arg0_149:GetCurrentLadyEnv())
			arg0_149:SyncInterestTransform(arg0_149:GetCurrentLadyEnv())
			arg0_149:RegisterCameraBlendFinished(arg0_149.cameras[var0_0.CAMERA.TALK], arg0_156)
			arg0_149:ActiveCamera(arg0_149.cameras[var0_0.CAMERA.TALK])
		end
	}
	local var1_149 = {}

	table.insert(var1_149, function(arg0_157)
		switch(arg1_149, var0_149, arg0_157, arg0_157)
	end)
	seriesAsync(var1_149, arg2_149)
end

function var0_0.GetSceneItem(arg0_158, arg1_158)
	local var0_158

	if string.find(arg1_158, "FurnitureSlots/") == 1 then
		arg1_158 = string.gsub(arg1_158, "^FurnitureSlots/", "", 1)
		var0_158 = arg0_158.slotRoot:Find(arg1_158)
	else
		var0_158 = arg0_158.modelRoot:Find(arg1_158)
	end

	if not var0_158 then
		warning(string.format("Missing scene item path: %s", arg1_158))
	end

	return var0_158
end

function var0_0.SetSceneAnimSpeed(arg0_159, arg1_159, arg2_159)
	table.Ipairs(arg1_159 or {}, function(arg0_160, arg1_160)
		if arg0_159.sceneAnimatorDict[arg1_160] then
			arg0_159.sceneAnimatorDict[arg1_160].animator.speed = arg2_159
		end
	end)
end

function var0_0.SetExtraAnimSpeed(arg0_161, arg1_161, arg2_161, arg3_161)
	table.Ipairs(arg2_161 or {}, function(arg0_162, arg1_162)
		local var0_162 = arg1_162[1]

		if arg1_161.extraItems[var0_162] then
			arg1_161.extraItems[var0_162].trans:GetComponent(typeof(Animator)).speed = arg3_161
		end
	end)
end

function var0_0.PlayEnterSceneAnim(arg0_163, arg1_163, arg2_163, arg3_163)
	arg3_163 = arg3_163 or 1

	local var0_163 = {}

	if arg1_163 and #arg1_163 > 0 then
		table.Ipairs(arg1_163, function(arg0_164, arg1_164)
			arg0_163:PlaySceneItemAnim(arg1_164[1], arg1_164[2], arg2_163)
			arg0_163:SetSceneAnimSpeed({
				arg1_164[1]
			}, arg3_163)
			table.insert(var0_163, arg1_164[1])
		end)
	end

	arg0_163:ResetSceneItemAnimators(var0_163)
end

function var0_0.PlayEnterExtraItem(arg0_165, arg1_165, arg2_165, arg3_165)
	arg3_165 = arg3_165 or 1

	local var0_165 = {}

	if arg2_165 and #arg2_165 > 0 then
		table.Ipairs(arg2_165, function(arg0_166, arg1_166)
			local var0_166 = arg1_166[3] and Vector3.New(unpack(arg1_166[3]))
			local var1_166 = arg1_166[4] and Quaternion.Euler(unpack(arg1_166[4]))
			local var2_166 = #arg1_166 > 4 and arg1_166[5] or nil

			arg0_165:LoadCharacterExtraItem(arg1_165, arg1_166[1], arg1_166[2], var0_166, var1_166, var2_166, arg3_165)
			table.insert(var0_165, arg1_166[1])
		end)
	end

	arg0_165:ResetCharacterExtraItem(arg1_165, var0_165)
end

function var0_0.HideSceneItem(arg0_167, arg1_167, arg2_167)
	if arg2_167 and #arg2_167 > 0 then
		if arg1_167.tempHideSceneItems and #arg1_167.tempHideSceneItems > 0 then
			arg0_167:ResetTempHideSceneItems(arg1_167, arg2_167)
		end

		arg1_167.tempHideSceneItems = {}

		table.Ipairs(arg2_167, function(arg0_168, arg1_168)
			local var0_168 = arg0_167:GetSceneItem(arg1_168)

			setActive(var0_168, false)
			table.insert(arg1_167.tempHideSceneItems, arg1_168)
		end)
	end
end

function var0_0.ResetTempHideSceneItems(arg0_169, arg1_169, arg2_169)
	arg2_169 = arg2_169 or {}

	if arg1_169.tempHideSceneItems and #arg1_169.tempHideSceneItems > 0 then
		table.Ipairs(arg1_169.tempHideSceneItems, function(arg0_170, arg1_170)
			if table.contains(arg2_169, arg1_170) then
				return
			end

			local var0_170 = arg0_169:GetSceneItem(arg1_170)

			setActive(var0_170, true)
		end)

		arg1_169.tempHideSceneItems = nil
	end
end

function var0_0.EnableCurrentHeadIK(arg0_171, arg1_171)
	local var0_171 = arg0_171:GetCurrentLadyEnv()

	arg0_171:EnableHeadIK(var0_171, arg1_171)
end

function var0_0.EnableHeadIK(arg0_172, arg1_172, arg2_172)
	arg1_172.ladyHeadIKComp.enableIk = arg2_172
end

function var0_0.SettingHeadAimIK(arg0_173, arg1_173, arg2_173, arg3_173)
	local var0_173

	if arg2_173[1] == 0 then
		arg0_173:EnableHeadIK(arg1_173, false)

		return
	elseif arg2_173[1] == 1 then
		arg0_173:EnableHeadIK(arg1_173, true)

		var0_173 = arg0_173.mainCameraTF:Find("AimTarget")
	elseif arg2_173[1] == 2 then
		arg0_173:EnableHeadIK(arg1_173, true)
		table.IpairsCArray(arg1_173.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_174, arg1_174)
			if arg1_174.name ~= arg2_173[2] then
				return
			end

			var0_173 = arg1_174
		end)
	end

	arg1_173.ladyHeadIKComp.AimTarget = var0_173

	if not arg3_173 and arg2_173[3] then
		arg1_173.ladyHeadIKComp.BodyWeight = arg2_173[3]
	end

	if not arg3_173 and arg2_173[4] then
		arg1_173.ladyHeadIKComp.HeadWeight = arg2_173[4]
	end
end

function var0_0.ResetHeadAimIK(arg0_175, arg1_175)
	arg0_175:EnableHeadIK(arg1_175, true)

	arg1_175.ladyHeadIKComp.AimTarget = arg0_175.mainCameraTF:Find("AimTarget")
	arg1_175.ladyHeadIKComp.HeadWeight = arg1_175.ladyHeadIKData.HeadWeight
	arg1_175.ladyHeadIKComp.BodyWeight = arg1_175.ladyHeadIKData.BodyWeight
end

function var0_0.SetIKTimelineStatus(arg0_176, arg1_176, arg2_176, arg3_176, arg4_176, arg5_176)
	arg0_176:emit(RoomIKSystem.SET_IK_TIMELINE_STATUS, arg1_176, arg2_176, arg3_176, arg4_176, arg5_176)
end

function var0_0.ExitIKTimelineStatus(arg0_177, arg1_177, arg2_177)
	arg0_177:emit(RoomIKSystem.EXIT_IK_TIMELINE_STATUS, arg1_177, arg2_177)
end

function var0_0.HideCharacter(arg0_178, arg1_178)
	for iter0_178, iter1_178 in pairs(arg0_178.ladyDict) do
		if iter0_178 ~= arg1_178 then
			arg0_178:HideCharacterBylayer(iter1_178)
		end
	end
end

function var0_0.RevertCharacter(arg0_179, arg1_179)
	for iter0_179, iter1_179 in pairs(arg0_179.ladyDict) do
		if iter0_179 ~= arg1_179 then
			arg0_179:RevertCharacterBylayer(iter1_179)
		end
	end
end

function var0_0.HideCharacterBylayer(arg0_180, arg1_180)
	local var0_180 = "Bip001"
	local var1_180 = arg1_180.lady:Find("all")

	for iter0_180 = 0, var1_180.childCount - 1 do
		local var2_180 = var1_180:GetChild(iter0_180)

		if var2_180.name ~= var0_180 then
			pg.ViewUtils.SetLayer(var2_180, Layer.Environment3D)
		end
	end

	if arg1_180.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_180.tfPendintItem, Layer.Environment3D)
	end

	if arg1_180.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_180.ladyWatchFloat, Layer.Environment3D)
	end
end

function var0_0.RevertCharacterBylayer(arg0_181, arg1_181)
	local var0_181 = "Bip001"
	local var1_181 = arg1_181.lady:Find("all")

	for iter0_181 = 0, var1_181.childCount - 1 do
		local var2_181 = var1_181:GetChild(iter0_181)

		if var2_181.name ~= var0_181 then
			pg.ViewUtils.SetLayer(var2_181, Layer.Character3D)
		end
	end

	if arg1_181.tfPendintItem then
		pg.ViewUtils.SetLayer(arg1_181.tfPendintItem, Layer.Default)
	end

	if arg1_181.ladyWatchFloat then
		pg.ViewUtils.SetLayer(arg1_181.ladyWatchFloat, Layer.Default)
	end
end

function var0_0.EnterFurnitureWatchMode(arg0_182)
	arg0_182:SetAllBlackbloardValue("inLockLayer", true)
	arg0_182:EnableJoystick(true)
	arg0_182:HideCharacter()
end

function var0_0.ExitFurnitureWatchMode(arg0_183, arg1_183)
	arg0_183:HideFurnitureSlots()

	local var0_183 = arg0_183.cameras[var0_0.CAMERA.POV]

	seriesAsync({
		function(arg0_184)
			arg0_183.furniturePOV = nil

			arg0_183:EnableJoystick(false)
			arg0_183:emit(var0_0.SHOW_BLOCK)
			arg0_183:ShowBlackScreen(true, arg0_184)
		end,
		function(arg0_185)
			existCall(arg1_183)
			arg0_183:RevertCharacter()
			arg0_183:SetAllBlackbloardValue("inLockLayer", false)
			arg0_183:RegisterCameraBlendFinished(var0_183, arg0_185)
			arg0_183:ActiveCamera(var0_183)
		end,
		function(arg0_186)
			arg0_183:ShowBlackScreen(false, arg0_186)
		end
	}, function()
		arg0_183:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_183:RefreshSlots()
end

function var0_0.SwitchFurnitureZone(arg0_188, arg1_188)
	local var0_188 = arg0_188:GetFurnitureByName(arg1_188:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_188.cameraFurnitureWatch and arg0_188.cameraFurnitureWatch ~= var0_188 then
		arg0_188:UnRegisterCameraBlendFinished(arg0_188.cameraFurnitureWatch)
		setActive(arg0_188.cameraFurnitureWatch, false)
	end

	arg0_188.cameraFurnitureWatch = var0_188
	arg0_188.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_188.cameraFurnitureWatch
	arg0_188.furniturePOV = arg0_188.cameraFurnitureWatch:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)

	arg0_188:RegisterCameraBlendFinished(arg0_188.cameraFurnitureWatch, function()
		arg0_188:emit(var0_0.HIDE_BLOCK)
	end)
	arg0_188:emit(var0_0.SHOW_BLOCK)
	arg0_188:ActiveCamera(arg0_188.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_190)
	if arg0_190.displaySlots then
		arg0_190:UpdateDisplaySlots({})
		table.Foreach(arg0_190.displaySlots, function(arg0_191, arg1_191)
			local var0_191 = arg1_191.trans

			if IsNil(var0_191:Find("Selector")) then
				return
			end

			setActive(var0_191:Find("Selector"), false)
		end)

		arg0_190.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_192, arg1_192)
	arg0_192:HideFurnitureSlots()

	arg0_192.displaySlots = {}

	_.each(arg1_192, function(arg0_193)
		arg0_192.displaySlots[arg0_193] = arg0_192.slotDict[arg0_193]

		if not arg0_192.displaySlots[arg0_193] then
			errorMsg("Slot " .. arg0_193 .. " Not Binding Scene Object")

			return
		end

		local var0_193 = arg0_192.displaySlots[arg0_193].trans

		if var0_193:Find("Selector") then
			setActive(var0_193:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_194, arg1_194)
	table.Foreach(arg0_194.displaySlots, function(arg0_195, arg1_195)
		local var0_195 = arg1_195.trans

		if not IsNil(var0_195:Find("Selector")) then
			setActive(var0_195:Find("Selector/Normal"), arg1_194[arg0_195] == 0)
			setActive(var0_195:Find("Selector/Active"), arg1_194[arg0_195] == 1)
			setActive(var0_195:Find("Selector/Ban"), arg1_194[arg0_195] == 2)
		end

		local var1_195 = arg0_194.slotDict[arg0_195].model
		local var2_195 = arg0_194.slotDict[arg0_195].displayModelName

		if var2_195 and var2_195 ~= "" then
			var1_195 = var0_195:GetChild(var0_195.childCount - 1)
		end

		local function var3_195(arg0_196, arg1_196)
			local var0_196 = arg0_196:GetComponentsInChildren(typeof(Renderer), true)

			table.IpairsCArray(var0_196, function(arg0_197, arg1_197)
				local var0_197 = arg1_197.material

				if var0_197 and var0_197:HasProperty("_FinalTint") then
					var0_197:SetColor("_FinalTint", arg1_196)
				end
			end)
		end

		if var1_195 then
			if arg1_194[arg0_195] == 1 then
				var3_195(var1_195, Color.NewHex("3F83AE73"))
			else
				var3_195(var1_195, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_198, arg1_198, arg2_198)
	arg0_198:SetAllBlackbloardValue("inLockLayer", true)
	arg0_198:emit(var0_0.ENABLE_SCENEBLOCK, true)
	seriesAsync({
		function(arg0_199)
			arg0_198:TempHideUI(true, arg0_199)
		end,
		function(arg0_200)
			arg0_198:ShowBlackScreen(true, arg0_200)
		end,
		function(arg0_201)
			local var0_201 = arg0_198.apartment:GetConfigID()
			local var1_201 = arg0_198.ladyDict[var0_201]

			arg0_198:SwitchAnim(var1_201, arg2_198)
			var1_201.ladyAnimator:Update(0)
			arg0_198:ResetCharPoint(var1_201, arg1_198:GetWatchCameraName())
			arg0_198:SyncInterestTransform(var1_201)
			setActive(var1_201.ladySafeCollider, true)
			arg0_198:HideCharacter(var0_201)

			local var2_201 = arg0_198.cameras[var0_0.CAMERA.PHOTO]
			local var3_201 = var2_201.m_XAxis

			var3_201.Value = 180
			var2_201.m_XAxis = var3_201

			local var4_201 = var2_201.m_YAxis

			var4_201.Value = 0.7
			var2_201.m_YAxis = var4_201
			arg0_198.pinchValue = 1

			arg0_198:RegisterOrbits(arg0_198.cameras[var0_0.CAMERA.PHOTO])
			arg0_198:SetCameraObrits()
			setActive(arg0_198.restrictedBox, true)
			arg0_198:RegisterCameraBlendFinished(var2_201, arg0_201)
			arg0_198:ActiveCamera(var2_201)
		end,
		function(arg0_202)
			arg0_198:ShowBlackScreen(false, arg0_202)
		end
	}, function()
		arg0_198:EnableJoystick(true)
	end)
end

function var0_0.ExitPhotoMode(arg0_204)
	arg0_204:emit(var0_0.SHOW_BLOCK)
	arg0_204:EnableJoystick(false)
	seriesAsync({
		function(arg0_205)
			arg0_204:ShowBlackScreen(true, arg0_205)
		end,
		function(arg0_206)
			arg0_204:RevertCameraOrbit()

			local var0_206 = arg0_204:GetCurrentLadyEnv()

			arg0_204:SwitchAnim(var0_206, var0_0.ANIM.IDLE)
			setActive(var0_206.ladySafeCollider, false)
			onNextTick(function()
				arg0_204:ChangeCharacterPosition(var0_206)
			end)

			if arg0_204.contextData.photoFreeMode then
				arg0_204:EnablePOVLayer(false)

				arg0_204.contextData.photoFreeMode = nil
			end

			setActive(arg0_204.restrictedBox, false)

			local var1_206 = arg0_204.cameras[var0_0.CAMERA.POV]

			arg0_204:RegisterCameraBlendFinished(var1_206, arg0_206)
			arg0_204:ActiveCamera(var1_206)
		end,
		function(arg0_208)
			arg0_204:RevertCharacter(arg0_204.apartment:GetConfigID())
			arg0_204:ShowBlackScreen(false, arg0_208)
		end
	}, function()
		arg0_204:RefreshSlots()
		arg0_204:SetAllBlackbloardValue("inLockLayer", false)
		arg0_204:emit(var0_0.HIDE_BLOCK)
		arg0_204:emit(var0_0.ENABLE_SCENEBLOCK, false)
		arg0_204:TempHideUI(false)
	end)
end

function var0_0.SwitchCameraZone(arg0_210, arg1_210, arg2_210, arg3_210)
	arg0_210:emit(var0_0.SHOW_BLOCK)
	seriesAsync({
		function(arg0_211)
			arg0_210:ShowBlackScreen(true, arg0_211)
		end,
		function(arg0_212)
			local var0_212 = arg0_210:GetCurrentLadyEnv()

			arg0_210:SwitchAnim(var0_212, arg2_210)
			onNextTick(function()
				arg0_210:ResetCharPoint(var0_212, arg1_210:GetWatchCameraName())
				arg0_210:SyncInterestTransform(var0_212)

				if arg0_210.contextData.photoFreeMode then
					arg0_210.camBrain.enabled = false

					arg0_210:SwitchPhotoCamera()

					arg0_210.camBrain.enabled = true

					onDelayTick(function()
						arg0_210.camBrain.enabled = false

						arg0_210:SwitchPhotoCamera()

						arg0_210.camBrain.enabled = true
					end, 0.1)
				end

				arg0_212()
			end)
		end,
		function(arg0_215)
			arg0_210:ShowBlackScreen(false, arg0_215)
		end
	}, function()
		arg0_210:emit(var0_0.HIDE_BLOCK)
		existCall(arg3_210)
	end)
end

function var0_0.SwitchPhotoCamera(arg0_217)
	if not arg0_217.contextData.photoFreeMode then
		arg0_217:EnableJoystick(false)
		arg0_217:EnablePOVLayer(true)

		local var0_217 = arg0_217.cameras[var0_0.CAMERA.PHOTO_FREE]
		local var1_217 = arg0_217.cameras[var0_0.CAMERA.PHOTO_FREE]:Find("PhotoFree Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera)):GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
		local var2_217 = arg0_217.mainCameraTF.rotation:ToEulerAngles()
		local var3_217 = var1_217.m_HorizontalAxis

		var3_217.Value = var2_217.y
		var1_217.m_HorizontalAxis = var3_217

		local var4_217 = var1_217.m_VerticalAxis

		var4_217.Value = arg0_217:GetNearestAngle(var2_217.x, var4_217.m_MinValue, var4_217.m_MaxValue)
		var1_217.m_VerticalAxis = var4_217

		local var5_217 = arg0_217.mainCameraTF.position
		local var6_217 = arg0_217:GetRestritedHeightRange()
		local var7_217 = math.InverseLerp(var6_217[1], var6_217[2], var5_217.y)

		var5_217.y = math.clamp(var5_217.y, var6_217[1], var6_217[2])
		var0_217.transform.position = var5_217

		arg0_217:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var7_217)
		arg0_217:ActiveCamera(arg0_217.cameras[var0_0.CAMERA.PHOTO_FREE])
	else
		arg0_217:EnableJoystick(true)
		arg0_217:EnablePOVLayer(false)
		arg0_217:ActiveCamera(arg0_217.cameras[var0_0.CAMERA.PHOTO])
	end

	arg0_217.contextData.photoFreeMode = not arg0_217.contextData.photoFreeMode
end

function var0_0.SetPhotoCameraHeight(arg0_218, arg1_218)
	local var0_218 = arg0_218.cameras[var0_0.CAMERA.PHOTO_FREE]
	local var1_218 = arg0_218:GetRestritedHeightRange()
	local var2_218 = math.lerp(var1_218[1], var1_218[2], arg1_218)

	var0_218:GetComponent(typeof(UnityEngine.CharacterController)):Move(Vector3.New(0, var2_218 - var0_218.position.y, 0))
	onNextTick(function()
		local var0_219 = arg0_218:GetRestritedHeightRange()
		local var1_219 = math.InverseLerp(var0_219[1], var0_219[2], var0_218.position.y)

		arg0_218:emit(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, var1_219)
	end)
end

function var0_0.ResetPhotoCameraPosition(arg0_220)
	local var0_220 = arg0_220.cameras[var0_0.CAMERA.PHOTO]
	local var1_220 = var0_220.m_XAxis

	var1_220.Value = 180
	var0_220.m_XAxis = var1_220

	local var2_220 = var0_220.m_YAxis

	var2_220.Value = 0.7
	var0_220.m_YAxis = var2_220
end

function var0_0.ResetCurrentCharPoint(arg0_221, arg1_221)
	local var0_221 = arg0_221:GetCurrentLadyEnv()

	arg0_221:ResetCharPoint(var0_221, arg1_221)
end

function var0_0.ResetCharPoint(arg0_222, arg1_222, arg2_222)
	local var0_222 = arg0_222.furnitures:Find(arg2_222 .. "/StayPoint")

	arg1_222.lady.position = var0_222.position
	arg1_222.lady.rotation = var0_222.rotation
end

function var0_0.GetNearestAngle(arg0_223, arg1_223, arg2_223, arg3_223)
	if arg3_223 < arg2_223 then
		arg3_223 = arg3_223 + 360
	end

	if arg2_223 <= arg1_223 and arg1_223 <= arg3_223 then
		return arg1_223
	end

	local var0_223 = (arg2_223 + arg3_223) / 2

	arg1_223 = var0_223 - Mathf.DeltaAngle(arg1_223, var0_223)
	arg1_223 = math.clamp(arg1_223, arg2_223, arg3_223)

	return arg1_223
end

function var0_0.PlayTimeline(arg0_224, arg1_224, arg2_224)
	local var0_224 = {}

	if arg0_224.waitForTimeline then
		table.insert(var0_224, function(arg0_225)
			local var0_225 = arg0_224.waitForTimeline

			arg0_224.waitForTimeline = nil

			var0_225()
			arg0_225()
		end)
	end

	table.insert(var0_224, function(arg0_226)
		arg0_224:LoadTimelineScene(arg1_224.name, false, nil, arg0_226)
	end)

	if arg1_224.scene and arg1_224.sceneRoot then
		table.insert(var0_224, function(arg0_227)
			arg0_224:ChangeArtScene(arg1_224.scene .. "|" .. arg1_224.sceneRoot, arg0_227)
		end)
	end

	table.insert(var0_224, function(arg0_228)
		local var0_228 = Dorm3dHxHelper.GetTimelineMainCharacter()

		Dorm3dHxHelper.ShowHolyLight({
			var0_228
		}, arg0_224.holyLightRoot)

		local var1_228 = GameObject.Find("[actor]").transform
		local var2_228 = var1_228:GetComponentsInChildren(typeof(Animator), true)

		table.IpairsCArray(var2_228, function(arg0_229, arg1_229)
			GetOrAddComponent(arg1_229.transform, typeof(DftAniEvent))
		end)

		var0_228 = var0_228 or var1_228:GetComponentInChildren(typeof("BLHXCharacterPropertiesController")).transform

		local var3_228

		eachChild(GameObject.Find("[camera]").transform, function(arg0_230)
			if arg0_230.tag == "MainCamera" then
				var3_228 = arg0_230
			end
		end)
		assert(var3_228, "Missing MainCamera")

		local var4_228 = GameObject.Find("[sequence]").transform

		arg0_224.nowTimelinePlayer = TimelinePlayer.New(var4_228)

		TimelineSupport.InitSubtitle(arg0_224.nowTimelinePlayer.comDirector, arg0_224.apartment:GetCallName())
		arg0_224.nowTimelinePlayer:Register(arg1_224.time, function(arg0_231, arg1_231, arg2_231)
			switch(arg1_231.stringParameter, {
				TimelinePause = function()
					arg0_231:SetSpeed(0)
				end,
				TimelineResume = function()
					arg0_231:SetSpeed(1)
				end,
				TimelinePlayOnTime = function()
					if arg1_231.intParameter == 0 or arg1_231.intParameter == arg2_231.selectIndex then
						arg0_231:SetTime(arg1_231.floatParameter)
					end
				end,
				TimelineSelectStart = function()
					arg2_231.selectIndex = nil

					if arg1_224.options then
						local var0_235 = arg1_224.options[arg1_231.intParameter]

						arg0_224:DoTimelineOption(var0_235, function(arg0_236)
							arg2_231.selectIndex = arg0_236
							arg2_231.optionIndex = var0_235[arg0_236].flag

							arg0_231:Play()
						end)
					end
				end,
				TimelineTouchStart = function()
					arg2_231.selectIndex = nil

					if arg1_224.touchs then
						local var0_237 = arg1_224.touchs[arg1_231.intParameter]

						arg0_224:DoTimelineTouch(arg1_224.touchs[arg1_231.intParameter], function(arg0_238)
							arg2_231.selectIndex = arg0_238
							arg2_231.optionIndex = var0_237[arg0_238].flag
						end)
					end
				end,
				TimelineSelectLoop = function()
					if not arg2_231.selectIndex then
						arg0_231:RawSetTime(arg1_231.floatParameter)
					end
				end,
				TimelineSelect = function()
					arg2_231.selectIndex = arg1_231.intParameter
				end,
				TimelineAccompanyJump = function()
					if arg0_224.canTriggerAccompanyPerformance then
						arg0_224.canTriggerAccompanyPerformance = false

						local var0_241 = arg1_224.accompanys[arg1_231.intParameter]
						local var1_241 = var0_241[math.random(#var0_241)]

						arg0_231:SetTime(var1_241)
					end
				end,
				TimelineIKStart = function()
					arg2_231.selectIndex = nil

					local var0_242 = arg1_231.intParameter
					local var1_242 = arg0_224:GetCurrentLadyEnv()

					if var1_242:CheckIkTimelineStatus(var0_242) then
						arg0_224:emit(RoomIKSystem.SET_IK_TIMELINE_STATUS, var1_242, var0_228.gameObject, var0_242, var3_228)
					end
				end,
				TimelineEnd = function()
					arg2_231.finish = true

					arg0_231:SetSpeed(0)
				end,
				TimelineAimIKStart = function()
					arg2_231.selectIndex = nil

					local var0_244 = arg1_231.intParameter

					arg0_224:emit(AimIKSystem.ENTER_TIMELINE_AIMIK_STATUS, var0_244)
				end
			}, function()
				warning("other event trigger:" .. arg1_231.stringParameter)
			end)

			if arg2_231.finish then
				arg0_224.timelineMark = arg2_231
				arg0_224.timelineFinishCall = nil

				pg.m02:sendNotification(var0_0.TIMELINE_END)

				local var0_231 = arg0_224:GetCurrentLadyEnv()

				if var0_231.ikTimelineMode then
					arg0_224:emit(RoomIKSystem.EXIT_IK_TIMELINE_STATUS, var0_231)
				end

				arg0_228()
			end
		end)

		function arg0_224.timelineFinishCall()
			arg0_224.nowTimelinePlayer:TriggerEvent({
				stringParameter = "TimelineEnd"
			})
		end

		arg0_224:HideCharacter()
		setActive(arg0_224.mainCameraTF, false)
		setActive(var3_228, true)
		eachChild(arg0_224.rtTimelineScreen, function(arg0_247)
			setActive(arg0_247, false)
		end)
		setActive(arg0_224.rtTimelineScreen, true)
		setActive(arg0_224.rtTimelineScreen:Find("btn_skip"), arg0_224.inReplayTalk)
		arg0_224.nowTimelinePlayer:Start()
	end)
	table.insert(var0_224, function(arg0_248)
		arg0_224:ShowBlackScreen(true, function()
			arg0_224.nowTimelinePlayer:Stop()
			arg0_224.nowTimelinePlayer:Dispose()

			arg0_224.nowTimelinePlayer = nil

			arg0_224:UnloadTimelineScene(arg1_224.name, false, arg0_248)
		end)
	end)

	local var1_224 = arg0_224.dormSceneMgr.artSceneInfo

	table.insert(var0_224, function(arg0_250)
		arg0_224:RevertArtScene(var1_224, arg0_250)
	end)
	seriesAsync(var0_224, function()
		setActive(arg0_224.rtTimelineScreen, false)
		arg0_224:RevertCharacter()
		setActive(arg0_224.mainCameraTF, true)
		arg0_224:InitHolyLight()

		local var0_251 = arg0_224.timelineMark

		arg0_224.timelineMark = nil

		existCall(arg2_224, var0_251, function(arg0_252)
			arg0_224:ShowBlackScreen(false, arg0_252)
		end)
	end)
end

function var0_0.GetCurrentLadyEnv(arg0_253)
	if not arg0_253.apartment then
		return nil
	end

	return arg0_253.ladyDict[arg0_253.apartment:GetConfigID()]
end

function var0_0.PlayCurrentSingleAction(arg0_254, ...)
	local var0_254 = arg0_254:GetCurrentLadyEnv()

	return arg0_254:PlaySingleAction(var0_254, ...)
end

function var0_0.PlaySingleAction(arg0_255, arg1_255, arg2_255, arg3_255, arg4_255)
	arg1_255:PlaySingleAction(arg2_255, arg3_255, arg4_255)
end

function var0_0.SwitchCurrentAnim(arg0_256, ...)
	local var0_256 = arg0_256:GetCurrentLadyEnv()

	return arg0_256:SwitchAnim(var0_256, ...)
end

function var0_0.SwitchAnim(arg0_257, arg1_257, arg2_257, arg3_257)
	arg1_257:SwitchAnim(arg2_257, arg3_257)
end

function var0_0.PlayFaceAnim(arg0_258, arg1_258, arg2_258, arg3_258)
	arg1_258:PlayFaceAnim(arg2_258, arg3_258)
end

function var0_0.RegisterAnimCallback(arg0_259, arg1_259, arg2_259)
	arg0_259:GetCurrentLadyEnv().animCallbacks[arg1_259] = arg2_259
end

function var0_0.SetCharacterAnimSpeed(arg0_260, arg1_260)
	local var0_260 = arg0_260:GetCurrentLadyEnv()

	var0_260.ladyAnimator.speed = arg1_260
	var0_260.ladyHeadIKComp.blinkSpeed = var0_260.ladyHeadIKData.blinkSpeed * arg1_260

	if arg1_260 > 0 then
		var0_260.ladyHeadIKComp.DampTime = var0_260.ladyHeadIKData.DampTime / arg1_260
	else
		var0_260.ladyHeadIKComp.DampTime = var0_260.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEvent(arg0_261, arg1_261)
	if arg1_261.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_261 = arg1_261.stringParameter
	local var1_261 = table.removebykey(arg0_261.animEventCallbacks, var0_261)

	existCall(var1_261)
end

function var0_0.RegisterAnimEventCallback(arg0_262, arg1_262, arg2_262)
	arg0_262.animEventCallbacks[arg1_262] = arg2_262
end

function var0_0.PlaySceneItemAnim(arg0_263, arg1_263, arg2_263, arg3_263)
	arg0_263.sceneAnimatorDict = arg0_263.sceneAnimatorDict or {}

	if not arg0_263.sceneAnimatorDict[arg1_263] then
		local var0_263 = pg.dorm3d_scene_animator[arg1_263]
		local var1_263 = arg0_263:GetSceneItem(var0_263.item_name)

		assert(var1_263, "Missing Scene Animator in pg.dorm3d_scene_animator: " .. arg1_263 .. " " .. var0_263.item_name)

		if not var1_263 then
			return
		end

		local var2_263 = var1_263:GetComponent(typeof(Animator))

		if not var2_263 then
			return
		end

		arg0_263.sceneAnimatorDict[arg1_263] = {
			trans = var1_263,
			animator = var2_263
		}
	end

	if not arg3_263 and arg0_263.sceneAnimatorDict[arg1_263].animator:GetCurrentAnimatorStateInfo(0):IsName(arg2_263) then
		return
	end

	arg0_263.sceneAnimatorDict[arg1_263].animator:PlayInFixedTime(arg2_263)
end

function var0_0.ResetSceneItemAnimators(arg0_264, arg1_264)
	if not arg0_264.sceneAnimatorDict then
		return
	end

	table.Foreach(arg0_264.sceneAnimatorDict, function(arg0_265, arg1_265)
		if arg1_264 and table.contains(arg1_264, arg0_265) then
			return
		end

		setActive(arg1_265.trans, false)
		setActive(arg1_265.trans, true)

		arg0_264.sceneAnimatorDict[arg0_265] = nil
	end)
end

function var0_0.LoadCharacterExtraItem(arg0_266, arg1_266, arg2_266, arg3_266, arg4_266, arg5_266, arg6_266, arg7_266)
	local function var0_266(arg0_267)
		if arg6_266 then
			local var0_267 = arg0_267:GetComponent(typeof(Animator))

			if var0_267 then
				var0_267:Play(arg6_266)

				var0_267.speed = arg7_266
			end
		end
	end

	arg1_266.extraItems = arg1_266.extraItems or {}

	if arg1_266.extraItems[arg2_266] then
		var0_266(arg1_266.extraItems[arg2_266].trans)

		return
	end

	local var1_266

	if arg3_266 == "" then
		var1_266 = arg1_266.lady
	elseif arg3_266 == "scene_root" then
		var1_266 = arg0_266.modelRoot
	else
		table.IpairsCArray(arg1_266.lady:GetComponentsInChildren(typeof(Transform), true), function(arg0_268, arg1_268)
			if arg1_268.name == arg3_266 then
				var1_266 = arg1_268
			end
		end)
	end

	if not var1_266 then
		return
	end

	arg0_266.loader:GetPrefab(string.lower("dorm3d/" .. arg2_266), "", function(arg0_269)
		setParent(arg0_269, var1_266)

		if arg4_266 then
			setLocalPosition(arg0_269, arg4_266)
		end

		if arg5_266 then
			setLocalRotation(arg0_269, arg5_266)
		end

		var0_266(arg0_269)

		arg1_266.extraItems[arg2_266] = {
			trans = arg0_269.transform,
			handler = var1_266
		}
	end)
end

function var0_0.ResetCharacterExtraItem(arg0_270, arg1_270, arg2_270)
	if not arg1_270.extraItems then
		return
	end

	table.Foreach(arg1_270.extraItems, function(arg0_271, arg1_271)
		if arg2_270 and table.contains(arg2_270, arg0_271) then
			return
		end

		arg0_270.loader:ReturnPrefab(arg1_271.trans.gameObject)

		arg1_270.extraItems[arg0_271] = nil
	end)
end

function var0_0.RegisterCameraBlendFinished(arg0_272, arg1_272, arg2_272)
	arg0_272.cameraBlendCallbacks[arg1_272] = arg2_272
end

function var0_0.UnRegisterCameraBlendFinished(arg0_273, arg1_273)
	arg0_273.cameraBlendCallbacks[arg1_273] = nil
end

function var0_0.OnCameraBlendFinished(arg0_274, arg1_274)
	if not arg1_274 then
		return
	end

	local var0_274 = table.removebykey(arg0_274.cameraBlendCallbacks, arg1_274)

	existCall(var0_274)
end

function var0_0.PlayHeartFX(arg0_275, arg1_275)
	local var0_275 = arg0_275.ladyDict[arg1_275]

	setActive(var0_275.effectHeart, false)
	setActive(var0_275.effectHeart, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_joyful")
end

function var0_0.PlayExpression(arg0_276, arg1_276)
	local var0_276 = arg1_276.name
	local var1_276 = arg0_276.expressionDict[var0_276]
	local var2_276 = 5

	if var1_276 then
		local var3_276 = var1_276.timer

		var3_276:Reset(nil, var2_276)
		var3_276:Start()

		if var1_276.instance then
			setActive(var1_276.instance, false)
			setActive(var1_276.instance, true)
		end

		return
	end

	local var4_276 = {
		name = var0_276,
		timer = Timer.New(function()
			arg0_276:RemoveExpression(var0_276)
		end, var2_276, 1, true)
	}

	arg0_276.expressionDict[var0_276] = var4_276

	arg0_276.loader:GetPrefab("dorm3D/effect/prefab/expression/" .. var0_276, var0_276, function(arg0_278)
		var4_276.instance = arg0_278

		onNextTick(function()
			local var0_279 = arg0_276:GetCurrentLadyEnv()

			setParent(arg0_278, var0_279.ladyHeadCenter)
		end)
		setLocalPosition(arg0_278, Vector3(0, 0, -0.2))
		setActive(arg0_278, false)
		setActive(arg0_278, true)
	end, var4_276)
end

function var0_0.RemoveExpression(arg0_280, arg1_280)
	local var0_280 = arg0_280.expressionDict[arg1_280]

	if not var0_280 then
		return
	end

	arg0_280.loader:ClearRequest(var0_280)

	if var0_280.instance then
		arg0_280.loader:ReturnPrefab(var0_280.instance)
	end

	arg0_280.expressionDict[arg1_280] = nil
end

function var0_0.ShowOrHideCanWatchMark(arg0_281, arg1_281, arg2_281)
	setActive(arg1_281.ladyWatchFloat, arg2_281)
end

function var0_0.RegisterGlobalVolume(arg0_282)
	local var0_282 = arg0_282.globalVolume
	local var1_282 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_282, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_282 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_282, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	arg0_282.originalCameraSettings = {
		depthOfField = {
			enabled = var1_282.enabled.value,
			focusDistance = {
				length = 2,
				min = var1_282.gaussianStart.min,
				value = var1_282.gaussianStart.value
			},
			blurRadius = {
				min = var1_282.blurRadius.min,
				max = var1_282.blurRadius.max,
				value = var1_282.blurRadius.value
			}
		},
		postExposure = {
			value = var2_282.postExposure.value
		},
		contrast = {
			min = var2_282.contrast.min,
			max = var2_282.contrast.max,
			value = var2_282.contrast.value
		},
		saturate = {
			min = var2_282.saturation.min,
			max = var2_282.saturation.max,
			value = var2_282.saturation.value
		}
	}
	arg0_282.originalCameraSettings.depthOfField.enabled = true

	local var3_282 = var0_282:GetComponent(typeof(UnityEngine.Rendering.Volume))

	arg0_282.originalVolume = {
		profile = var3_282.sharedProfile,
		weight = var3_282.weight
	}
end

function var0_0.SettingCamera(arg0_283, arg1_283)
	arg0_283.activeCameraSettings = arg1_283

	local var0_283 = arg0_283.globalVolume
	local var1_283 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_283, typeof(BLHX.Rendering.CustomDepthOfField))
	local var2_283 = GraphicsInterface.Instance.GetOrAddVolumeComponent(var0_283, typeof(UnityEngine.Rendering.Universal.ColorAdjustments))

	var1_283.enabled:Override(arg1_283.depthOfField.enabled)
	var1_283.gaussianStart:Override(arg1_283.depthOfField.focusDistance.value)
	var1_283.gaussianEnd:Override(arg1_283.depthOfField.focusDistance.value + arg1_283.depthOfField.focusDistance.length)
	var1_283.blurRadius:Override(arg1_283.depthOfField.blurRadius.value)
	var2_283.postExposure:Override(arg1_283.postExposure.value)
	var2_283.contrast:Override(arg1_283.contrast.value)
	var2_283.saturation:Override(arg1_283.saturate.value)
end

function var0_0.GetCameraSettings(arg0_284)
	return arg0_284.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_285)
	arg0_285:SettingCamera(arg0_285.originalCameraSettings)

	arg0_285.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_286, arg1_286, arg2_286)
	if arg0_286.cameraVolume then
		arg0_286:RevertVolumeProfile()
	end

	arg0_286.loader:GetPrefab("dorm3d/effect/volume/" .. arg1_286, "", function(arg0_287)
		arg0_286.cameraVolume = arg0_287
	end)
end

function var0_0.RevertVolumeProfile(arg0_288)
	if arg0_288.cameraVolume then
		arg0_288.loader:ReturnPrefab(arg0_288.cameraVolume)

		arg0_288.cameraVolume = nil
	end
end

function var0_0.RecordCharacterLight(arg0_289)
	tolua.loadassembly("Yongshi.BLRP.Runtime.AOT")

	local var0_289 = arg0_289.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	arg0_289.originalCharacterColor = {
		color = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var0_289),
		intensity = ReflectionHelp.RefGetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var0_289)
	}
end

function var0_0.SetCharacterLight(arg0_290, arg1_290, arg2_290, arg3_290)
	local var0_290 = arg0_290.characterLight:GetComponent(typeof(Light))
	local var1_290 = Color.Lerp(arg0_290.originalCharacterColor.color, arg1_290, arg3_290)
	local var2_290 = math.lerp(arg0_290.originalCharacterColor.intensity, arg2_290, arg3_290)
	local var3_290 = arg0_290.characterLight:GetComponent(typeof("BLHX.Rendering.CharacterLight"))

	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightColor", var3_290, var1_290)
	ReflectionHelp.RefSetProperty(typeof("BLHX.Rendering.CharacterLight"), "characterLightIntensity", var3_290, var2_290)
end

function var0_0.RevertCharacterLight(arg0_291)
	arg0_291:SetCharacterLight(arg0_291.originalCharacterColor.color, arg0_291.originalCharacterColor.intensity, 1)
end

function var0_0.onBackPressed(arg0_292)
	if arg0_292.exited or arg0_292.retainCount > 0 then
		-- block empty
	else
		arg0_292:closeView()
	end
end

function var0_0.LoadTimelineScene(arg0_293, arg1_293, arg2_293, arg3_293, arg4_293)
	arg0_293.dormSceneMgr:LoadTimelineScene({
		name = arg1_293,
		assetRootName = arg0_293.apartment:getConfig("asset_name"),
		isCache = arg2_293,
		waitForTimeline = arg3_293,
		loadSceneFunc = function(arg0_294, arg1_294)
			local var0_294 = Dorm3dHxHelper.GetTimelineMainCharacter()

			Dorm3dHxHelper.HideCharacterPart(var0_294, nil, true)
			arg0_293:HXCharacter(var0_294)
		end
	}, arg4_293)
end

function var0_0.UnloadTimelineScene(arg0_295, arg1_295, arg2_295, arg3_295)
	arg0_295.dormSceneMgr:UnloadTimelineScene(arg1_295, arg2_295, arg3_295)
end

function var0_0.ChangeArtScene(arg0_296, arg1_296, arg2_296)
	local var0_296 = {}

	table.insert(var0_296, function(arg0_297)
		arg0_296.dormSceneMgr:ChangeArtScene(arg1_296, arg0_297)
	end)
	table.insert(var0_296, function(arg0_298)
		setActive(arg0_296.slotRoot, false)
		arg0_298()
	end)
	warning(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", arg1_296, arg0_296.dormSceneMgr.sceneInfo, Dorm3dSceneMgr.IsSameSceneInfo(arg1_296, arg0_296.dormSceneMgr.sceneInfo))

	if Dorm3dSceneMgr.IsSameSceneInfo(arg1_296, arg0_296.dormSceneMgr.sceneInfo) then
		table.insert(var0_296, function(arg0_299)
			arg0_296:SwitchDayNight(1)
			arg0_296:TempHideContact(true)
			arg0_299()
		end)
	end

	seriesAsync(var0_296, arg2_296)
end

function var0_0.RevertArtScene(arg0_300, arg1_300, arg2_300)
	local var0_300 = {}

	table.insert(var0_300, function(arg0_301)
		arg0_300.dormSceneMgr:ChangeArtScene(arg1_300, arg0_301)
	end)
	table.insert(var0_300, function(arg0_302)
		setActive(arg0_300.slotRoot, true)
		arg0_302()
	end)
	table.insert(var0_300, function(arg0_303)
		arg0_300:SwitchDayNight(arg0_300.contextData.timeIndex)
		onNextTick(function()
			arg0_300:RefreshSlots()
			arg0_300:TempHideContact(false)
			arg0_303()
		end)
	end)
	seriesAsync(var0_300, arg2_300)
end

function var0_0.ChangeSubScene(arg0_305, arg1_305, arg2_305)
	local var0_305 = {}

	table.insert(var0_305, function(arg0_306)
		arg0_305.dormSceneMgr:ChangeSubScene(arg1_305, arg0_306)
	end)

	local var1_305 = arg0_305:GetCurrentLadyEnv()

	table.insert(var0_305, function(arg0_307)
		if Dorm3dSceneMgr.IsSameSceneInfo(arg1_305, arg0_305.dormSceneMgr.sceneInfo) then
			var1_305.ladyActiveZone = var1_305.walkBornPoint or var1_305.ladyBaseZone
		else
			var1_305.ladyActiveZone = var1_305.walkBornPoint or "Default"
		end

		arg0_307()
	end)

	if not Dorm3dSceneMgr.IsSameSceneInfo(arg1_305, arg0_305.dormSceneMgr.subSceneInfo) then
		table.insert(var0_305, function(arg0_308)
			local var0_308, var1_308 = Dorm3dSceneMgr.ParseInfo(arg1_305)
			local var2_308 = var0_308 .. "_base"

			arg0_305:ResetSceneStructure(SceneManager.GetSceneByName(var2_308))

			if Dorm3dSceneMgr.IsSameSceneInfo(arg1_305, arg0_305.dormSceneMgr.sceneInfo) then
				arg0_305:RefreshSlots()
			else
				arg0_305:SwitchAnim(var1_305, var0_0.ANIM.IDLE)
			end

			if not Dorm3dSceneMgr.IsSameSceneInfo(arg0_305.dormSceneMgr.subSceneInfo, arg0_305.dormSceneMgr.sceneInfo) then
				arg0_305:RefreshSlotsEmpty()
			end

			arg0_308()
		end)
	end

	table.insert(var0_305, function(arg0_309)
		onNextTick(function()
			arg0_305:ChangeCharacterPosition(var1_305)
			arg0_305:ChangePlayerPosition(var1_305.ladyActiveZone)
			arg0_305:TriggerLadyDistance()
			arg0_305:CheckInSector()
			arg0_309()
		end)
	end)
	seriesAsync(var0_305, arg2_305)
end

function var0_0.IsPointInSector(arg0_311, arg1_311)
	local var0_311 = arg1_311 - arg0_311.Position

	if var0_311.y > arg0_311.Radius then
		return false
	end

	var0_311.y = 0

	if var0_311.magnitude > arg0_311.Radius then
		return false
	end

	local var1_311 = arg0_311.Rotation

	return Vector3.Angle(var1_311 * Vector3.forward, var0_311) <= arg0_311.Angle / 2
end

function var0_0.GetRestritedHeightRange(arg0_312)
	if not arg0_312.isMultiFloor then
		return arg0_312.restrictedHeightRange
	else
		for iter0_312 = #arg0_312.restrictedHeightRange, 1, -1 do
			local var0_312 = arg0_312.restrictedHeightRange[iter0_312]

			if arg0_312.mainCameraTF.position.y >= var0_312[1] then
				return var0_312
			end
		end

		return arg0_312.restrictedHeightRange[1]
	end
end

function var0_0.willExit(arg0_313)
	var0_0.super.willExit(arg0_313)
	arg0_313.joystickTimer:Stop()
	arg0_313.moveStickTimer:Stop()
	UpdateBeat:RemoveListener(arg0_313.updateHandler)

	if arg0_313.moveTimer then
		arg0_313.moveTimer:Stop()

		arg0_313.moveTimer = nil
	end

	if arg0_313.moveWaitTimer then
		arg0_313.moveWaitTimer:Stop()

		arg0_313.moveWaitTimer = nil
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()

	if not IsNil(arg0_313.furnitures) then
		eachChild(arg0_313.furnitures, function(arg0_314)
			local var0_314 = GetComponent(arg0_314, typeof(EventTriggerListener))

			if not var0_314 then
				return
			end

			var0_314:ClearEvents()
		end)
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()

	for iter0_313, iter1_313 in pairs(arg0_313.ladyDict) do
		GetComponent(iter1_313.lady, typeof(EventTriggerListener)):ClearEvents()
	end

	arg0_313.camBrainEvenetHandler.OnBlendStarted = nil
	arg0_313.camBrainEvenetHandler.OnBlendFinished = nil

	arg0_313:UnOverlayPanel(arg0_313.blockLayer, arg0_313._tf)
	table.Foreach(arg0_313.expressionDict, function(arg0_315)
		arg0_313:RemoveExpression(arg0_315)
	end)
	arg0_313.loader:Clear()
	pg.ClickEffectMgr.GetInstance():SetClickEffect("NORMAL")
	pg.NodeCanvasMgr.GetInstance():Clear()
	arg0_313.dormSceneMgr:Dispose()

	arg0_313.dormSceneMgr = nil

	ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)

	if arg0_313.transformFilter then
		arg0_313.transformFilter:Dispose()
	end
end

return var0_0
