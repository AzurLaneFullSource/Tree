local var0_0 = class("Dorm3dScene", import("view.base.BaseUI"))

var0_0.CAMERA = {
	GIFT = 8,
	PHOTO = 10,
	FURNITURE_WATCH = 7,
	TALK = 4,
	ROLE_WATCH = 5,
	AIM = 1,
	ROLE2 = 9,
	FURNITURE_FREELOOK = 6,
	ROLE = 3,
	AIM2 = 2
}
var0_0.BONE_TO_TOUCH = {
	Head = "head",
	LeftUpperArm = "hand",
	RightThigh = "leg",
	Butt = "butt",
	LeftCalf = "leg",
	RightLowerArm = "hand",
	Chest = "chest",
	RightCalf = "leg",
	RightUpperArm = "hand",
	LeftThigh = "leg",
	Back = "back",
	LeftLowerArm = "hand",
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
var0_0.PLAY_SINGLE_ACTION = "Dorm3dScene.PLAY_ACTION"
var0_0.SWITCH_ACTION = "Dorm3dScene.SWITCH_ACTION"
var0_0.PLAY_TIMELINE = "Dorm3dScene.PLAY_TIMELINE"
var0_0.MOVE_PLAYER_TO_FURNITURE = "Dorm3dScene.MOVE_PLAYER_TO_FURNITURE"
var0_0.ACTIVE_CAMERA = "Dorm3dScene.ACTIVE_CAMERA"
var0_0.SHOW_BLOCK = "Dorm3dScene.SHOW_BLOCK"
var0_0.HIDE_BLOCK = "Dorm3dScene.HIDE_BLOCK"
var0_0.ENTER_FREELOOK_MODE = "Dorm3dScene.ENTER_FREELOOK_MODE"
var0_0.EXIT_FREELOOK_MODE = "Dorm3dScene.EXIT_FREELOOK_MODE"
var0_0.ENTER_WATCH_MODE = "Dorm3dScene.ENTER_WATCH_MODE"
var0_0.EXIT_WATCH_MODE = "Dorm3dScene.EXIT_WATCH_MODE"
var0_0.WATCH_MODE_INTERACTIVE = "Dorm3dScene.WATCH_MODE_INTERACTIVE"
var0_0.ENTER_GIFT_MODE = "Dorm3dScene.ENTER_GIFT_MODE"
var0_0.EXIT_GIFT_MODE = "Dorm3dScene.EXIT_GIFT_MODE"
var0_0.ON_DIALOGUE_BEGIN = "Dorm3dScene.ON_DIALOGUE_BEGIN"
var0_0.ON_DIALOGUE_END = "Dorm3dScene.ON_DIALOGUE_END"
var0_0.ON_TOUCH_CHARACTER = "Dorm3dScene.ON_TOUCH_CHARACTER"
var0_0.ON_ROLEWATCH_CAMERA_MAX = "Dorm3dScene.ON_ROLEWATCH_CAMERA_MAX"
var0_0.ON_UPDATE_CONTACT_STSTE = "Dorm3dScene.ON_UPDATE_CONTACT_STSTE"
var0_0.ON_UPDATE_CONTACT_POSITION = "Dorm3dScene.ON_UPDATE_CONTACT_POSITION"
var0_0.ON_STICK_MOVE = "Dorm3dScene.ON_STICK_MOVE"

function var0_0.getUIName(arg0_1)
	return "Dorm3dMainUI"
end

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.sceneDataList = {}
	arg0_2.sceneCounter = 0
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = arg0_3.contextData.groupId
	local var1_3 = getProxy(ApartmentProxy):getApartment(var0_3)

	arg0_3:SetApartment(var1_3)

	arg0_3.sceneRootName = var1_3:GetSceneRootName()
	arg0_3.assetRootName = var1_3:GetAssetName()

	for iter0_3, iter1_3 in ipairs({
		"sceneName",
		"baseSceneName",
		"modelName"
	}) do
		arg0_3[iter1_3] = arg0_3.contextData.sceneData[iter1_3]
	end

	arg0_3.contextData.inFurnitureName = arg0_3.contextData.inFurnitureName or "Default"

	seriesAsync({
		function(arg0_4)
			pg.UIMgr.GetInstance():LoadingOn(false)
			arg0_3:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_3.sceneRootName .. "/" .. arg0_3.sceneName .. "_scene"), arg0_3.sceneName, function(arg0_5, arg1_5)
				SceneOpMgr.Inst:SetActiveSceneByIndex(1)
				onNextTick(arg0_4)
			end)
		end,
		function(arg0_6)
			arg0_3:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_3.sceneRootName .. "/" .. arg0_3.baseSceneName .. "_scene"), arg0_3.baseSceneName, function(arg0_7, arg1_7)
				arg0_6()
			end)
		end,
		function(arg0_8)
			arg0_3:LoadCharacter(arg0_8)
		end,
		function(arg0_9)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_9()
		end,
		arg1_3
	})
end

function var0_0.init(arg0_10)
	arg0_10:initScene()
	arg0_10:InitCharacter()

	arg0_10.retainCount = 0
	arg0_10.blockLayer = arg0_10._tf:Find("Block")

	setActive(arg0_10.blockLayer, false)

	arg0_10.blackLayer = arg0_10._tf:Find("BlackScreen")

	setActive(arg0_10.blackLayer, false)

	arg0_10.loader = AutoLoader.New()

	arg0_10:BindEvent()

	arg0_10.baseView = Dorm3dBaseView.New(nil, arg0_10.event, arg0_10.contextData)

	arg0_10.baseView:SetExtra(arg0_10._tf)
	arg0_10.baseView:Load()
	arg0_10.baseView:BindEvent()
	arg0_10.baseView:SetApartment(arg0_10.apartment)
	arg0_10.baseView:initNodeCanvas(arg0_10.rtMainAI)
	arg0_10.baseView:SetLadyTransform(arg0_10.lady)
end

function var0_0.BindEvent(arg0_11)
	arg0_11:bind(Dorm3dScene.PLAY_SINGLE_ACTION, function(arg0_12, arg1_12, arg2_12)
		arg0_11:PlaySingleAction(arg1_12, arg2_12)
	end)
	arg0_11:bind(Dorm3dScene.SWITCH_ACTION, function(arg0_13, arg1_13, arg2_13)
		arg0_11:SwitchAnim(arg1_13, arg2_13)
	end)
	arg0_11:bind(Dorm3dScene.PLAY_TIMELINE, function(arg0_14, arg1_14, arg2_14)
		arg0_11:PlayTimeline(arg1_14, arg2_14)
	end)
	arg0_11:bind(Dorm3dScene.MOVE_PLAYER_TO_FURNITURE, function(arg0_15, arg1_15, arg2_15)
		arg0_11:PlayerMove(arg1_15, arg2_15)
	end)
	arg0_11:bind(Dorm3dScene.ACTIVE_CAMERA, function(arg0_16, arg1_16)
		local var0_16 = arg0_11.cameras[arg1_16]

		arg0_11:ActiveCamera(var0_16)
	end)
	arg0_11:bind(Dorm3dScene.SHOW_BLOCK, function()
		arg0_11.retainCount = arg0_11.retainCount + 1

		setActive(arg0_11.blockLayer, true)
	end)
	arg0_11:bind(Dorm3dScene.HIDE_BLOCK, function()
		arg0_11.retainCount = math.max(arg0_11.retainCount - 1, 0)

		if arg0_11.retainCount > 0 then
			return
		end

		setActive(arg0_11.blockLayer, false)
	end)
	arg0_11:bind(Dorm3dScene.ENTER_FREELOOK_MODE, function(arg0_19, arg1_19, arg2_19)
		arg0_11:EnterFreelookMode(arg1_19, arg2_19)
	end)
	arg0_11:bind(Dorm3dScene.EXIT_FREELOOK_MODE, function(arg0_20, arg1_20, arg2_20)
		arg0_11:ExitFreelookMode(arg1_20, arg2_20)
	end)
	arg0_11:bind(Dorm3dScene.ENTER_WATCH_MODE, function(arg0_21)
		arg0_11:EnterWatchMode()
	end)
	arg0_11:bind(Dorm3dScene.EXIT_WATCH_MODE, function(arg0_22)
		arg0_11:ExitWatchMode()
	end)
	arg0_11:bind(Dorm3dScene.WATCH_MODE_INTERACTIVE, function(arg0_23)
		arg0_11:WatchModeInteractive()
	end)
	arg0_11:bind(Dorm3dScene.ENTER_GIFT_MODE, function(arg0_24)
		arg0_11:EnterGiftMode()
	end)
	arg0_11:bind(Dorm3dScene.EXIT_GIFT_MODE, function(arg0_25)
		arg0_11:ExitGiftMode()
	end)
	arg0_11:bind(Dorm3dScene.ON_DIALOGUE_BEGIN, function(arg0_26, arg1_26)
		arg1_26()
	end)
	arg0_11:bind(Dorm3dScene.ON_DIALOGUE_END, function(arg0_27, arg1_27)
		arg1_27()
	end)
	arg0_11:bind(Dorm3dScene.ON_UPDATE_CONTACT_STSTE, function(arg0_28, arg1_28)
		warning("test")
		arg0_11:ActiveContact(arg1_28)
	end)
	arg0_11:bind(Dorm3dScene.ON_UPDATE_CONTACT_POSITION, function(arg0_29, arg1_29)
		arg0_11:UpdateContactPosition(arg1_29)
	end)
	arg0_11:bind(Dorm3dScene.ON_STICK_MOVE, function(arg0_30, arg1_30)
		arg0_11:OnStickMove(arg1_30)
	end)
end

function var0_0.SetApartment(arg0_31, arg1_31)
	arg0_31.apartment = arg1_31

	if arg0_31.baseView then
		arg0_31.baseView:SetApartment(arg1_31)
	end
end

function var0_0.GetApartment(arg0_32)
	return arg0_32.apartment
end

function var0_0.initScene(arg0_33)
	arg0_33.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0_33.camBrain = arg0_33.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0_33.camBrainEvenetHandler = arg0_33.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0_33.player = GameObject.Find("Player").transform
	arg0_33.furnitures = GameObject.Find("Furnitures").transform
	arg0_33.attachedPoints = {}

	eachChild(arg0_33.furnitures, function(arg0_34)
		table.insert(arg0_33.attachedPoints, 1, arg0_34)
		setActive(arg0_34:Find("FreeLook Camera"), false)
		setActive(arg0_34:Find("RoleWatch Camera"), false)
	end)

	arg0_33.dollyParent = GameObject.Find("Dollys").transform
	arg0_33.inFurniture = arg0_33.furnitures:Find(arg0_33.contextData.inFurnitureName)

	local var0_33 = GetComponent(arg0_33.inFurniture, typeof(UnityEngine.Collider))

	if var0_33 then
		var0_33.enabled = false
	end

	arg0_33.modelRoot = GameObject.Find("fbx").transform
	arg0_33.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0_33.slotRoot, true)
	arg0_33:InitSlots()

	arg0_33.contactRoot = GameObject.Find("ContactColliders").transform

	setActive(arg0_33.contactRoot, true)
	arg0_33:InitContact()

	local var1_33 = GameObject.Find("CM Cameras").transform

	arg0_33.cameraAim = var1_33:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraAim2 = var1_33:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraFree = nil
	arg0_33.cameraFurnitureWatch = nil
	arg0_33.cameraRole = var1_33:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraRole2 = var1_33:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraTalk = var1_33:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraGift = var1_33:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_33.cameraRoleWatch = nil
	arg0_33.cameraPhoto = var1_33:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook))
	arg0_33.cameras = {
		arg0_33.cameraAim,
		arg0_33.cameraAim2,
		arg0_33.cameraRole,
		arg0_33.cameraTalk,
		arg0_33.cameraRoleWatch,
		[var0_0.CAMERA.GIFT] = arg0_33.cameraGift,
		[var0_0.CAMERA.ROLE2] = arg0_33.cameraRole2,
		[var0_0.CAMERA.PHOTO] = arg0_33.cameraPhoto
	}
	arg0_33.compDolly = arg0_33.cameraAim:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Body)
	arg0_33.compPov = nil
	arg0_33.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0_33.rtMainAI = GameObject.Find("MainAI").transform
	arg0_33.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera)).fieldOfView = arg0_33.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	arg0_33:InitTimeline()

	arg0_33.globalVolume = GameObject.Find("GlobalVolume")

	arg0_33:RegisterGlobalVolume()

	arg0_33.characterLight = GameObject.Find("CharacterLight")

	arg0_33:RecordCharacterLight()

	local var2_33 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var2_33:GetComponentsInChildren(typeof(Light)), function(arg0_35, arg1_35)
		arg1_35.shadows = UnityEngine.LightShadows.None
	end)

	arg0_33.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))
end

function var0_0.InitSlots(arg0_36)
	local var0_36 = arg0_36.apartment:GetSlots()
	local var1_36 = arg0_36.modelRoot:GetComponentsInChildren(typeof(Transform))

	arg0_36.slotDict = {}

	_.each(var0_36, function(arg0_37)
		local var0_37 = arg0_37:GetFurnitureName()
		local var1_37 = arg0_37:GetConfigID()
		local var2_37 = arg0_36.slotRoot:Find(tostring(var1_37))

		assert(var2_37)

		local var3_37 = {
			trans = var2_37
		}
		local var4_37 = var2_37:Find("Selector")

		if var4_37 then
			GetOrAddComponent(var4_37, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_38, arg1_38)
				arg0_36:emit(Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT, var1_37)
			end)
			setActive(var4_37, false)
		end

		local var5_37

		for iter0_37 = 0, var1_36.Length - 1 do
			local var6_37 = var1_36[iter0_37]

			if var6_37.name == var0_37 then
				var5_37 = var6_37

				break
			end
		end

		if var5_37 then
			var3_37.model = var5_37
		end

		arg0_36.slotDict[var1_37] = var3_37
	end)
end

function var0_0.InitContact(arg0_39)
	eachChild(arg0_39.contactRoot, function(arg0_40)
		local var0_40 = arg0_40:Find("Selector")

		GetOrAddComponent(var0_40, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_41, arg1_41)
			arg0_39.baseView:SendNodeCanvasEvent("ClickContact", tf(arg0_41).parent.name)
		end)
		setActive(arg0_40, false)
	end)
end

function var0_0.ActiveContact(arg0_42, arg1_42)
	warning("ActiveContact", PrintTable(arg1_42))
	eachChild(arg0_42.contactRoot, function(arg0_43)
		local var0_43 = arg0_43.name

		warning(var0_43)
		setActive(arg0_43, tobool(arg1_42[var0_43]))

		if arg0_42.baseView.rtFloatPage:Find(var0_43) then
			setActive(arg0_42.baseView.rtFloatPage:Find(var0_43), tobool(arg1_42[var0_43]))
		elseif tobool(arg1_42[var0_43]) then
			cloneTplTo(arg0_42.baseView.tplFloat, arg0_42.baseView.rtFloatPage, var0_43)
		end
	end)
end

function var0_0.UpdateContactPosition(arg0_44, arg1_44)
	if not arg1_44 then
		return
	end

	for iter0_44, iter1_44 in pairs(arg1_44) do
		local var0_44 = arg0_44.baseView.rtFloatPage:Find(iter0_44)

		if var0_44 then
			local var1_44 = arg0_44:GetScreenPosition(arg0_44.contactRoot:Find(iter0_44)) or Vector2.New(-10000, -10000)

			setAnchoredPosition(var0_44, var1_44)
		else
			warning("without this contact colliders:" .. iter0_44)
		end
	end
end

function var0_0.InitTimeline(arg0_45)
	return
end

function var0_0.LoadCharacter(arg0_46, arg1_46)
	PoolMgr.GetInstance():GetPrefab("dorm3d/character/" .. arg0_46.assetRootName .. "/prefabs/" .. arg0_46.modelName, "", true, function(arg0_47)
		arg0_46.ladyGameobject = arg0_47

		existCall(arg1_46)
	end)
end

function var0_0.InitCharacter(arg0_48)
	arg0_48.lady = arg0_48.ladyGameobject.transform

	arg0_48.lady:SetParent(arg0_48.mainCameraTF)
	arg0_48.lady:SetParent(nil)

	local var0_48 = arg0_48.furnitures:Find(arg0_48.contextData.charFurnitureName or arg0_48.contextData.inFurnitureName)

	arg0_48.contextData.charFurnitureName = nil
	arg0_48.lady.position = var0_48:Find("StayPoint").position
	arg0_48.lady.rotation = var0_48:Find("StayPoint").rotation
	arg0_48.ladyAgent = arg0_48.lady:GetComponent(typeof(UnityEngine.AI.NavMeshAgent))
	arg0_48.ladyAgent.autoRepath = true
	arg0_48.ladyHeadIKComp = arg0_48.lady:GetComponent(typeof(HeadAimIK))
	arg0_48.ladyHeadIKComp.AimTarget = arg0_48.mainCameraTF:Find("AimTarget")
	arg0_48.ladyHeadIKData = {
		DampTime = arg0_48.ladyHeadIKComp.DampTime,
		blinkSpeed = arg0_48.ladyHeadIKComp.blinkSpeed
	}
	arg0_48.ladyAnimator = arg0_48.lady:GetComponent(typeof(Animator))

	local var1_48 = arg0_48.lady:GetComponentsInChildren(typeof(Transform))

	table.IpairsCArray(var1_48, function(arg0_49, arg1_49)
		if arg1_49.name == "BodyCollider" then
			arg0_48.ladyCollider = arg1_49
		elseif arg1_49.name == "Interest" then
			arg0_48.ladyInterestRoot = arg1_49
		end
	end)

	arg0_48.ladyColliders = {}
	arg0_48.ladyTouchColliders = {}

	table.IpairsCArray(arg0_48.lady:GetComponentsInChildren(typeof(UnityEngine.Collider)), function(arg0_50, arg1_50)
		arg1_50 = tf(arg1_50)

		local var0_50 = arg1_50.name
		local var1_50 = var0_50 and string.find(var0_50, "Collider") or -1

		if var1_50 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0_50)

			return
		end

		local var2_50 = string.sub(var0_50, 1, var1_50 - 1)

		arg0_48.ladyColliders[var2_50] = arg1_50

		if var2_50 ~= "Body" then
			table.insert(arg0_48.ladyTouchColliders, arg1_50)
			setActive(arg1_50, false)
		end
	end)

	arg0_48.cameraAim2.LookAt = arg0_48.ladyInterestRoot
	arg0_48.cameraTalk.Follow = arg0_48.ladyInterestRoot
	arg0_48.cameraTalk.LookAt = arg0_48.ladyInterestRoot
	arg0_48.cameraGift.Follow = arg0_48.ladyInterestRoot
	arg0_48.cameraGift.LookAt = arg0_48.ladyInterestRoot
	arg0_48.cameraRole2.LookAt = arg0_48.ladyInterestRoot
	arg0_48.cameraPhoto.Follow = arg0_48.ladyInterestRoot
	arg0_48.cameraPhoto.LookAt = arg0_48.ladyInterestRoot
end

function var0_0.RemoveCharacter(arg0_51)
	PoolMgr.GetInstance():ReturnPrefab("dorm3d/character/" .. arg0_51.assetRootName .. "/prefabs/" .. arg0_51.modelName, "", arg0_51.ladyGameobject, true)
end

function var0_0.didEnter(arg0_52)
	GetComponent(arg0_52.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_53, arg1_53)
		if arg1_53.rawPointerPress.transform == arg0_52.ladyCollider then
			arg0_52.baseView:SendNodeCanvasEvent("ClickCharacter", arg0_52.lady)
		else
			local var0_53 = table.keyof(arg0_52.ladyColliders, arg1_53.rawPointerPress.transform)

			warning(arg1_53.rawPointerPress.name, var0_53)
			arg0_52:emit(var0_0.ON_TOUCH_CHARACTER, Dorm3dScene.BONE_TO_TOUCH[var0_53] or arg1_53.rawPointerPress.name)
		end
	end)
	eachChild(arg0_52.furnitures, function(arg0_54)
		local var0_54 = GetComponent(arg0_54, typeof(EventTriggerListener))

		if not var0_54 then
			return
		end

		var0_54:AddPointClickFunc(function(arg0_55, arg1_55)
			arg0_52.baseView:SendNodeCanvasEvent("ClickFurniture", arg0_55.transform)
		end)
	end)

	local var0_52 = -21.6 / Screen.height

	arg0_52.joystickDelta = Vector2.zero
	arg0_52.joystickTimer = FrameTimer.New(function()
		local var0_56 = arg0_52.joystickDelta * var0_52
		local var1_56 = var0_56.x
		local var2_56 = var0_56.y

		local function var3_56(arg0_57, arg1_57, arg2_57)
			local var0_57 = arg0_57[arg1_57]

			var0_57.m_InputAxisValue = arg2_57
			arg0_57[arg1_57] = var0_57
		end

		if arg0_52.compPov and go(arg0_52.compPov).activeInHierarchy then
			var3_56(arg0_52.compPov, "m_HorizontalAxis", var1_56)
			var3_56(arg0_52.compPov, "m_VerticalAxis", var2_56)

			if math.abs(var1_56) < 0.01 and math.abs(var2_56) < 0.01 then
				if not arg0_52.recentTweenId and Time.time > arg0_52.nextRecentTime then
					arg0_52:DoRecenter()
				end
			else
				arg0_52:ResetRecenterTimer()
			end
		else
			arg0_52:ResetRecenterTimer()
		end

		if arg0_52.surroudCamera and not arg0_52.pinchMode then
			var3_56(arg0_52.surroudCamera, "m_XAxis", var1_56)
			var3_56(arg0_52.surroudCamera, "m_YAxis", var2_56)

			if arg0_52.surroudCamera == arg0_52.cameraRoleWatch then
				if var1_56 ~= 0 then
					local var4_56 = arg0_52.cameraRoleWatch.m_XAxis

					if not var4_56.m_Wrap then
						local var5_56 = var1_56 * (var4_56.m_InvertInput and -1 or 1)

						if var5_56 < 0 and var4_56.Value - 0.01 < var4_56.m_MinValue then
							arg0_52:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.RIGHT)
						elseif var5_56 > 0 and var4_56.Value + 0.01 > var4_56.m_MaxValue then
							arg0_52:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.LEFT)
						end
					end
				end

				if var2_56 ~= 0 then
					local var6_56 = arg0_52.cameraRoleWatch.m_YAxis

					if not var6_56.m_Wrap then
						if var2_56 < 0 and var6_56.Value - 0.01 < var6_56.m_MinValue then
							arg0_52:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.DOWN)
						elseif var2_56 > 0 and var6_56.Value + 0.01 > var6_56.m_MaxValue then
							arg0_52:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.UP)
						end
					end
				end
			end
		end

		arg0_52.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0_52.joystickTimer:Start()

	arg0_52.pinchMode = false
	arg0_52.pinchSize = 0
	arg0_52.pinchValue = 1
	arg0_52.pinchNodeOrder = 1

	local var1_52 = 0.5
	local var2_52 = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0_58, arg1_58)
		if not arg0_52.surroudCamera or not isActive(arg0_52.surroudCamera) then
			return
		end

		arg0_52.pinchMode = true
		arg0_52.pinchSize = (arg0_58 - arg1_58):Magnitude()
		arg0_52.pinchNodeOrder = arg1_58.x < arg0_58.x and -1 or 1
	end)

	local var3_52 = 0.01

	if IsUnityEditor then
		var3_52 = 0.1
	end

	local var4_52 = var3_52 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0_59, arg1_59)
		if not arg0_52.pinchMode then
			return
		end

		local var0_59 = (arg0_59 - arg1_59):Magnitude()
		local var1_59 = arg0_52.pinchSize - var0_59
		local var2_59 = arg0_52.pinchNodeOrder * (arg1_59.x < arg0_59.x and -1 or 1)
		local var3_59 = var1_59 * var4_52 * var2_59

		arg0_52:SetPinchValue(math.clamp(arg0_52.pinchValue + var3_59, var1_52, var2_52))

		arg0_52.pinchSize = var0_59

		if arg0_52.surroudCamera == arg0_52.cameraRoleWatch then
			if var3_59 > 0.01 and arg0_52.pinchValue == var2_52 then
				arg0_52:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.ZOOMOUT)
			elseif var3_59 < -0.01 and arg0_52.pinchValue == var1_52 then
				arg0_52:emit(var0_0.ON_ROLEWATCH_CAMERA_MAX, var0_0.CAMERA_MAX_OPERATION.ZOOMIN)
			end
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0_52.pinchMode = false
		arg0_52.pinchSize = 0
	end)
	arg0_52.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_61)
		if arg0_52.nowState and arg0_61.animatorStateInfo:IsName(arg0_52.nowState) then
			existCall(arg0_52.stateCallback)
		elseif arg0_61.stringParameter ~= "" then
			arg0_52:OnAnimationEnd(arg0_61)
		end
	end)

	arg0_52.animCallbacks = {}
	arg0_52.cameraBlendCallbacks = {}

	function arg0_52.camBrainEvenetHandler.OnBlendFinished(arg0_62)
		arg0_52:OnCameraBlendFinished(arg0_62)
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_52.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0_52:OnSwitchStaticPosition()

	arg0_52.nextRecentTime = 0

	arg0_52:RefreshSlots(arg0_52.apartment)
	arg0_52.baseView:TreeStart()
end

function var0_0.OnStickMove(arg0_63, arg1_63)
	arg0_63.joystickDelta = arg1_63
end

function var0_0.SetPinchValue(arg0_64, arg1_64)
	arg0_64.pinchValue = arg1_64

	arg0_64:SetCameraObrits()
end

function var0_0.ShowBaseView(arg0_65)
	setActive(arg0_65.contactRoot, false)
	arg0_65.baseView:TempHideUI(false)
end

function var0_0.HideBaseView(arg0_66)
	setActive(arg0_66.contactRoot, true)
	arg0_66.baseView:TempHideUI(true)
end

function var0_0.RefreshSlots(arg0_67, arg1_67)
	local var0_67 = arg1_67:GetSlots()
	local var1_67 = arg1_67:GetFurnitures()

	arg0_67:emit(Dorm3dScene.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_67, function(arg0_68, arg1_68, arg2_68)
		local var0_68 = arg1_68:GetConfigID()
		local var1_68 = _.detect(var1_67, function(arg0_69)
			return arg0_69:GetSlotID() == var0_68
		end)
		local var2_68 = var1_68 and var1_68:GetModel() or ""

		if arg0_67.slotDict[var0_68].displayModelName == var2_68 then
			arg2_68()

			return
		end

		local var3_68 = arg0_67.slotDict[var0_68].model

		arg0_67.slotDict[var0_68].displayModelName = var2_68

		if not var2_68 or var2_68 == "" then
			arg0_67.loader:ClearRequest("slot_" .. var0_68)

			if var3_68 then
				setActive(var3_68, true)
			end

			arg2_68()

			return
		end

		local var4_68 = arg0_67.slotDict[var0_68].trans

		arg0_67.loader:GetPrefab("dorm3d/furniture/prefabs/" .. var2_68, "", function(arg0_70)
			arg2_68()
			assert(arg0_70)
			setParent(arg0_70, var4_68)

			if var3_68 then
				local var0_70 = arg0_70:GetComponentsInChildren(typeof(Renderer))

				table.IpairsCArray(var0_70, function(arg0_71, arg1_71)
					LuaHelper.CopyLightMap(arg1_71.gameObject, arg0_70)
				end)
				setActive(var3_68, false)
			end
		end, "slot_" .. var0_68)
	end, function()
		arg0_67:emit(Dorm3dScene.HIDE_BLOCK)
	end)
end

function var0_0.SyncInterestTransform(arg0_73)
	arg0_73.ladyInterest.position = arg0_73.ladyInterestRoot.position
	arg0_73.ladyInterest.rotation = arg0_73.ladyInterestRoot.rotation
end

function var0_0.OnSwitchStaticPosition(arg0_74, arg1_74)
	arg0_74.baseView:SetInFurniture(arg0_74.inFurniture)

	local var0_74 = GetComponent(arg0_74.inFurniture, typeof(UnityEngine.Collider))

	if var0_74 then
		var0_74.enabled = false
	end

	local var1_74 = arg0_74.inFurniture
	local var2_74 = var1_74:Find("FreeLook Camera")

	arg0_74:SyncInterestTransform()

	local var3_74 = var2_74.transform.position

	var3_74.y = 0
	arg0_74.player.position = var3_74

	if arg0_74.cameraFree then
		setActive(arg0_74.cameraFree, false)

		arg0_74.cameras[var0_0.CAMERA.FURNITURE_FREELOOK] = nil
	end

	arg0_74.cameraFree = var1_74:Find("FreeLook Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0_74.compPov = arg0_74.cameraFree:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0_74.cameras[var0_0.CAMERA.FURNITURE_FREELOOK] = arg0_74.cameraFree

	if arg0_74.cameraRoleWatch then
		arg0_74:RevertCameraOrbit()
	end

	arg0_74.cameraRoleWatch = var1_74:Find("RoleWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook))
	arg0_74.cameras[var0_0.CAMERA.ROLE_WATCH] = arg0_74.cameraRoleWatch

	arg0_74:RegisterOrbits(arg0_74.cameraRoleWatch)

	local var4_74 = arg0_74.ladyInterest.position - var2_74.transform.position
	local var5_74 = Quaternion.LookRotation(var4_74).eulerAngles
	local var6_74 = var5_74.y
	local var7_74 = var5_74.x
	local var8_74 = arg0_74.compPov.m_HorizontalAxis

	var8_74.Value = arg0_74:GetNearestAngle(var6_74, var8_74.m_MinValue, var8_74.m_MaxValue)
	arg0_74.compPov.m_HorizontalAxis = var8_74

	local var9_74 = arg0_74.compPov.m_VerticalAxis

	var9_74.Value = var7_74
	arg0_74.compPov.m_VerticalAxis = var9_74

	arg0_74:ResetRecenterTimer()
	arg0_74:RegisterCameraBlendFinished(arg0_74.cameraFree, arg1_74)
	arg0_74:ActiveCamera(arg0_74.cameraFree)
end

function var0_0.GetAttachedFurnitureName(arg0_75)
	return arg0_75.inFurniture.name
end

function var0_0.GetFurnitureByName(arg0_76, arg1_76)
	return underscore.detect(arg0_76.attachedPoints, function(arg0_77)
		return arg0_77.name == arg1_76
	end)
end

function var0_0.GetSlotByID(arg0_78, arg1_78)
	return arg0_78.displaySlots[arg1_78] and arg0_78.displaySlots[arg1_78].trans
end

function var0_0.GetScreenPosition(arg0_79, arg1_79)
	local var0_79 = arg0_79.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera)):WorldToScreenPoint(arg1_79.position)

	if var0_79.z < 0 then
		return false
	end

	local var1_79 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect

	return (Vector2.New(var0_79.x / Screen.width * var1_79.width, var0_79.y / Screen.height * var1_79.height))
end

function var0_0.GetModelRoot(arg0_80)
	return arg0_80.modelRoot
end

function var0_0.PlayerMove(arg0_81, arg1_81, arg2_81)
	local var0_81 = arg0_81:GetFurnitureByName(arg1_81)

	if not var0_81 then
		errorMsg(arg1_81 .. " Not Find")
		existCall(arg2_81)

		return
	end

	if var0_81 == arg0_81.inFurniture then
		existCall(arg2_81)

		return
	end

	local var1_81 = arg0_81.inFurniture
	local var2_81 = var1_81:Find("FreeLook Camera")
	local var3_81 = _.detect(arg0_81.apartment:GetZones(), function(arg0_82)
		return arg0_82:GetWatchCameraName() == var1_81.name
	end)
	local var4_81 = _.detect(arg0_81.apartment:GetZones(), function(arg0_83)
		return arg0_83:GetWatchCameraName() == arg1_81
	end)
	local var5_81 = table.indexof(arg0_81.attachedPoints, arg0_81.inFurniture)
	local var6_81 = table.indexof(arg0_81.attachedPoints, var0_81)
	local var7_81 = false

	if var6_81 < var5_81 then
		var7_81 = true
		var5_81, var6_81 = var6_81, var5_81
	end

	local var8_81 = "Dolly" .. var5_81 .. "_" .. var6_81
	local var9_81 = arg0_81.dollyParent:Find(var8_81):GetComponent(typeof(Cinemachine.CinemachineSmoothPath))

	arg0_81.compDolly.m_Path = var9_81

	local var10_81 = GetComponent(arg0_81.inFurniture, typeof(UnityEngine.Collider))

	if var10_81 then
		var10_81.enabled = true
	end

	local var11_81 = var0_81:Find("Interest")
	local var12_81 = var0_81:Find("StayPoint")

	seriesAsync({
		function(arg0_84)
			arg0_81:emit(Dorm3dScene.SHOW_BLOCK)

			arg0_81.cameraAim.transform.position = var2_81.transform.position
			arg0_81.cameraAim2.transform.position = var2_81.transform.position

			arg0_81:ActiveCamera(arg0_81.cameraAim2)
			arg0_84()
		end,
		function(arg0_85)
			local var0_85 = arg0_81.ladyAgent

			var0_85.enabled = true
			var0_85.destination = var12_81.position
			var0_85.speed = 0
			arg0_81.moveTimer = waitUntil(function()
				arg0_81:WalkByRootMotionLoop(var0_85, arg0_81.ladyAnimator)

				return var0_85.remainingDistance < 0.1
			end, function()
				var0_85.enabled = false

				arg0_85()
			end)
		end,
		function(arg0_88)
			local var0_88 = arg0_81.lady.rotation
			local var1_88 = var12_81.rotation:ToEulerAngles().y - var0_88:ToEulerAngles().y

			if var1_88 < -180 then
				var1_88 = var1_88 + 360
			elseif var1_88 > 180 then
				var1_88 = var1_88 - 360
			end

			arg0_81.ladyAnimator:SetFloat("Speed", 0)
			arg0_81.ladyAnimator:SetBool("Turn", true)
			arg0_81.ladyAnimator:SetFloat("TurnAngle", var1_88)
			arg0_81:RegisterCallback("TurnEnd", function()
				arg0_81.ladyAnimator:SetFloat("TurnAngle", 0)
				arg0_81.ladyAnimator:SetBool("Turn", false)
				arg0_88()
			end)
		end,
		function(arg0_90)
			arg0_81:ActiveCamera(arg0_81.cameraAim)

			arg0_81.cameraAim.LookAt = var11_81

			local var0_90 = 1
			local var1_90 = arg0_81.compDolly.m_Path.PathLength
			local var2_90 = var1_90 / var0_90

			arg0_81:managedTween(LeanTween.value, arg0_90, go(arg0_81.cameraAim), 0, 1, var2_90):setOnUpdate(System.Action_float(function(arg0_91)
				local var0_91 = var7_81 and 1 - arg0_91 or arg0_91

				arg0_81.compDolly.m_PathPosition = var1_90 * var0_91
			end))
		end,
		function(arg0_92)
			arg0_81.inFurniture = var0_81
			arg0_81.contextData.inFurnitureName = var0_81.name

			arg0_81:OnSwitchStaticPosition(arg0_92)
		end,
		function(arg0_93)
			arg0_81:emit(Dorm3dScene.HIDE_BLOCK)
			arg0_93()
		end
	}, arg2_81)
end

function var0_0.WalkByRootMotionLoop(arg0_94, arg1_94, arg2_94)
	if arg1_94.pathPending then
		arg2_94:SetFloat("Speed", 0)

		return
	end

	arg2_94:SetFloat("Speed", 1)

	local var0_94 = arg1_94.path.corners

	if var0_94.Length > 1 then
		local var1_94 = var0_94[1] - arg1_94.transform.position

		var1_94.y = 0

		local var2_94 = Quaternion.LookRotation(var1_94)
		local var3_94 = arg1_94.transform.rotation
		local var4_94 = 1
		local var5_94 = Damp(1, var4_94, Time.deltaTime)

		arg1_94.transform.rotation = Quaternion.Lerp(var3_94, var2_94, var5_94)
	end
end

function var0_0.ActiveCamera(arg0_95, arg1_95)
	table.Foreach(arg0_95.cameras, function(arg0_96, arg1_96)
		setActive(arg1_96, arg1_96 == arg1_95)
	end)
end

function var0_0.ShowBlackScreen(arg0_97, arg1_97, arg2_97)
	local var0_97 = 0.3

	seriesAsync({
		function(arg0_98)
			setActive(arg0_97.blackLayer, true)
			arg0_97:managedTween(LeanTween.alpha, arg0_98, arg0_97.blackLayer, 1, var0_97)
		end,
		function(arg0_99)
			arg1_97(arg0_99)
		end,
		function(arg0_100)
			arg0_97:managedTween(LeanTween.alpha, arg0_100, arg0_97.blackLayer, 0, var0_97)
		end,
		function()
			setActive(arg0_97.blackLayer, false)
			existCall(arg2_97)
		end
	})
end

function var0_0.RegisterOrbits(arg0_102, arg1_102)
	arg0_102.orbits = {
		original = arg1_102.m_Orbits
	}
	arg0_102.orbits.current = _.range(3):map(function(arg0_103)
		local var0_103 = arg0_102.orbits.original[arg0_103 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0_103.m_Height, var0_103.m_Radius)
	end)
	arg0_102.surroudCamera = arg1_102
end

function var0_0.SetCameraObrits(arg0_104)
	local var0_104 = arg0_104.surroudCamera

	if not var0_104 then
		return
	end

	local var1_104 = arg0_104.orbits.original[1]

	for iter0_104 = 0, #arg0_104.orbits.current - 1 do
		local var2_104 = arg0_104.orbits.current[iter0_104 + 1]
		local var3_104 = arg0_104.orbits.original[iter0_104]

		var2_104.m_Height = math.lerp(var1_104.m_Height, var3_104.m_Height, arg0_104.pinchValue)
		var2_104.m_Radius = var3_104.m_Radius * arg0_104.pinchValue
	end

	var0_104.m_Orbits = arg0_104.orbits.current
end

function var0_0.RevertCameraOrbit(arg0_105)
	local var0_105 = arg0_105.surroudCamera

	if not var0_105 then
		return
	end

	for iter0_105 = 0, #arg0_105.orbits.current - 1 do
		local var1_105 = arg0_105.orbits.current[iter0_105 + 1]
		local var2_105 = arg0_105.orbits.original[iter0_105]

		var1_105.m_Height = var2_105.m_Height
		var1_105.m_Radius = var2_105.m_Radius
	end

	var0_105.m_Orbits = arg0_105.orbits.current
	arg0_105.surroudCamera = nil
end

function var0_0.EnterWatchMode(arg0_106)
	arg0_106:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_106.baseView:EnableJoystick(false)
	arg0_106:ResetRecenterTimer()
	arg0_106:DoRecenterQuick(function()
		seriesAsync({
			function(arg0_108)
				arg0_106:RegisterCameraBlendFinished(arg0_106.cameraRole, arg0_108)
				arg0_106:ActiveCamera(arg0_106.cameraRole)
			end
		}, function()
			arg0_106.baseView:EnterWatchMode()
			arg0_106:emit(Dorm3dScene.HIDE_BLOCK)
		end)
	end)
end

function var0_0.ExitWatchMode(arg0_110)
	arg0_110:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_110.baseView:ExitWatchMode()
	seriesAsync({
		function(arg0_111)
			arg0_110:ResetRecenterTimer()
			arg0_110:RegisterCameraBlendFinished(arg0_110.cameraFree, arg0_111)
			arg0_110:ActiveCamera(arg0_110.cameraFree)
		end
	}, function()
		arg0_110:emit(Dorm3dScene.HIDE_BLOCK)
		arg0_110.baseView:EnableJoystick(true)
	end)
end

function var0_0.WatchModeInteractive(arg0_113)
	if arg0_113.inFurniture.name ~= "Bed" then
		arg0_113:PlaySingleAction("Bow")
	end
end

function var0_0.EnterFreelookMode(arg0_114, arg1_114, arg2_114)
	arg0_114:emit(Dorm3dScene.SHOW_BLOCK)
	seriesAsync({
		function(arg0_115)
			if arg2_114.standby_action and arg2_114.standby_action ~= "" then
				parallelAsync({
					function(arg0_116)
						arg0_114:emit(Dorm3dScene.PLAY_SINGLE_ACTION, arg2_114.standby_action, arg0_116)
					end,
					function(arg0_117)
						arg0_114.cameras[var0_0.CAMERA.ROLE2].transform.position = arg0_114.cameraRole.transform.position

						arg0_114:ResetRecenterTimer()
						arg0_114:RegisterCameraBlendFinished(arg0_114.cameras[var0_0.CAMERA.ROLE2], arg0_117)
						arg0_114:ActiveCamera(arg0_114.cameras[var0_0.CAMERA.ROLE2])
					end
				}, arg0_115)

				return
			end

			arg0_115()
		end,
		function(arg0_118)
			arg0_114:ResetRecenterTimer()

			arg0_114.pinchValue = 1

			arg0_114:SetCameraObrits()

			local var0_118 = arg0_114.cameraRoleWatch.m_XAxis

			var0_118.Value = 180
			arg0_114.cameraRoleWatch.m_XAxis = var0_118

			local var1_118 = arg0_114.cameraRoleWatch.m_YAxis

			var1_118.Value = 0.7
			arg0_114.cameraRoleWatch.m_YAxis = var1_118

			arg0_114:SyncInterestTransform()
			arg0_114:RegisterCameraBlendFinished(arg0_114.cameraRoleWatch, arg0_118)
			arg0_114:ActiveCamera(arg0_114.cameraRoleWatch)
		end,
		function(arg0_119)
			setActive(arg0_114.ladyCollider, false)
			_.each(arg0_114.ladyTouchColliders, function(arg0_120)
				setActive(arg0_120, true)
			end)
			arg0_119()
		end
	}, function()
		arg0_114:emit(Dorm3dScene.HIDE_BLOCK)
		arg1_114()
	end)
end

function var0_0.ExitFreelookMode(arg0_122, arg1_122, arg2_122)
	arg0_122:emit(Dorm3dScene.SHOW_BLOCK)
	seriesAsync({
		function(arg0_123)
			setActive(arg0_122.ladyCollider, true)
			_.each(arg0_122.ladyTouchColliders, function(arg0_124)
				setActive(arg0_124, false)
			end)
			arg0_123()
		end,
		function(arg0_125)
			if arg2_122.finish_action and arg2_122.finish_action ~= "" then
				parallelAsync({
					function(arg0_126)
						arg0_122:emit(Dorm3dScene.PLAY_SINGLE_ACTION, arg2_122.finish_action, arg0_126)
					end,
					function(arg0_127)
						arg0_122:ResetRecenterTimer()
						arg0_122:RegisterCameraBlendFinished(arg0_122.cameras[var0_0.CAMERA.ROLE2], arg0_127)
						arg0_122:ActiveCamera(arg0_122.cameras[var0_0.CAMERA.ROLE2])
					end
				}, arg0_125)

				return
			end

			arg0_125()
		end,
		function(arg0_128)
			arg0_122:SyncInterestTransform()
			arg0_122:RegisterCameraBlendFinished(arg0_122.cameraRole, arg0_128)
			arg0_122:ActiveCamera(arg0_122.cameraRole)
		end
	}, function()
		arg0_122:emit(Dorm3dScene.HIDE_BLOCK)
		arg1_122()
	end)
end

function var0_0.EnableHeadIK(arg0_130, arg1_130)
	arg0_130.ladyHeadIKComp.enableIk = arg1_130
end

function var0_0.HideCharacter(arg0_131)
	arg0_131.lastCharacterPosition = arg0_131.lady.position

	setLocalPosition(arg0_131.lady, Vector3(0, -10000, 0))
end

function var0_0.RevertCharacter(arg0_132)
	setLocalPosition(arg0_132.lady, arg0_132.lastCharacterPosition or Vector3.zero)
end

function var0_0.EnterFurnitureWatchMode(arg0_133)
	arg0_133:HideCharacter()

	arg0_133.lastCamera = table.Find(arg0_133.cameras, function(arg0_134, arg1_134)
		return isActive(arg1_134)
	end)

	eachChild(arg0_133.furnitures, function(arg0_135)
		local var0_135 = arg0_135:GetComponent(typeof(UnityEngine.Collider))

		if not var0_135 then
			return
		end

		var0_135.enabled = false
	end)
end

function var0_0.ExitFurnitureWatchMode(arg0_136)
	arg0_136:HideFurnitureSlots()
	arg0_136:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_136:ShowBlackScreen(function(arg0_137)
		arg0_136:RegisterCameraBlendFinished(arg0_136.lastCamera, arg0_137)
		arg0_136:ActiveCamera(arg0_136.lastCamera)
	end, function()
		arg0_136.lastCamera = nil

		arg0_136:emit(Dorm3dScene.HIDE_BLOCK)
	end)
	eachChild(arg0_136.furnitures, function(arg0_139)
		local var0_139 = arg0_139:GetComponent(typeof(UnityEngine.Collider))

		if not var0_139 then
			return
		end

		var0_139.enabled = true
	end)
	arg0_136:RefreshSlots(arg0_136.apartment)
end

function var0_0.EnterGiftMode(arg0_140)
	arg0_140:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_140:RegisterCameraBlendFinished(arg0_140.cameras[var0_0.CAMERA.GIFT], function()
		arg0_140:emit(Dorm3dScene.HIDE_BLOCK)
	end)
	arg0_140:ActiveCamera(arg0_140.cameras[var0_0.CAMERA.GIFT])
end

function var0_0.ExitGiftMode(arg0_142)
	arg0_142:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_142:RegisterCameraBlendFinished(arg0_142.cameras[var0_0.CAMERA.ROLE], function()
		arg0_142:emit(Dorm3dScene.HIDE_BLOCK)
	end)
	arg0_142:ActiveCamera(arg0_142.cameras[var0_0.CAMERA.ROLE])
end

function var0_0.SwitchZone(arg0_144, arg1_144, arg2_144)
	local var0_144 = arg0_144:GetFurnitureByName(arg1_144:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0_144.cameraFurnitureWatch and arg0_144.cameraFurnitureWatch ~= var0_144 then
		arg0_144:UnRegisterCameraBlendFinished(arg0_144.cameraFurnitureWatch)
		setActive(arg0_144.cameraFurnitureWatch, false)
	end

	arg0_144.cameraFurnitureWatch = var0_144
	arg0_144.cameras[var0_0.CAMERA.FURNITURE_WATCH] = arg0_144.cameraFurnitureWatch

	arg0_144:RegisterCameraBlendFinished(arg0_144.cameraFurnitureWatch, function()
		arg0_144:emit(Dorm3dScene.HIDE_BLOCK)
		existCall(arg2_144)
	end)
	arg0_144:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_144:ActiveCamera(arg0_144.cameraFurnitureWatch)
end

function var0_0.HideFurnitureSlots(arg0_146)
	if arg0_146.displaySlots then
		arg0_146:UpdateDisplaySlots({})
		table.Foreach(arg0_146.displaySlots, function(arg0_147, arg1_147)
			local var0_147 = arg1_147.trans

			if IsNil(var0_147:Find("Selector")) then
				return
			end

			setActive(var0_147:Find("Selector"), false)
		end)

		arg0_146.displaySlots = nil
	end
end

function var0_0.DisplayFurnitureSlots(arg0_148, arg1_148)
	arg0_148:HideFurnitureSlots()

	arg0_148.displaySlots = {}

	_.each(arg1_148, function(arg0_149)
		arg0_148.displaySlots[arg0_149] = arg0_148.slotDict[arg0_149]

		if not arg0_148.displaySlots[arg0_149] then
			errorMsg("Slot " .. arg0_149 .. " Not Binding Scene Object")

			return
		end

		local var0_149 = arg0_148.displaySlots[arg0_149].trans

		if var0_149:Find("Selector") then
			setActive(var0_149:Find("Selector"), true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_150, arg1_150)
	table.Foreach(arg0_150.displaySlots, function(arg0_151, arg1_151)
		local var0_151 = arg1_151.trans

		if not IsNil(var0_151:Find("Selector")) then
			setActive(var0_151:Find("Selector/Normal"), arg1_150[arg0_151] == 0)
			setActive(var0_151:Find("Selector/Active"), arg1_150[arg0_151] == 1)
			setActive(var0_151:Find("Selector/Ban"), arg1_150[arg0_151] == 2)
		end

		local var1_151 = arg0_150.slotDict[arg0_151].model
		local var2_151 = arg0_150.slotDict[arg0_151].displayModelName

		if var2_151 and var2_151 ~= "" then
			var1_151 = var0_151:GetChild(var0_151.childCount - 1)
		end

		local function var3_151(arg0_152, arg1_152)
			local var0_152 = arg0_152:GetComponentsInChildren(typeof(Renderer))

			table.IpairsCArray(var0_152, function(arg0_153, arg1_153)
				local var0_153 = arg1_153.material

				if var0_153 and var0_153:HasProperty("_FinalTint") then
					var0_153:SetColor("_FinalTint", arg1_152)
				end
			end)
		end

		if var1_151 then
			if arg1_150[arg0_151] == 1 then
				var3_151(var1_151, Color.NewHex("3F83AE73"))
			else
				var3_151(var1_151, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0_0.EnterPhotoMode(arg0_154, arg1_154)
	arg0_154.lastCamera = table.Find(arg0_154.cameras, function(arg0_155, arg1_155)
		return isActive(arg1_155)
	end)

	arg0_154:ShowBlackScreen(function(arg0_156)
		arg0_154:SwitchAnim(var0_0.ANIM.IDLE)
		onNextTick(function()
			arg0_154:ResetCharPosByZone(arg1_154)
			arg0_154:SyncInterestTransform()
		end)

		local var0_156 = arg0_154.cameraPhoto
		local var1_156 = var0_156.m_XAxis

		var1_156.Value = 180
		var0_156.m_XAxis = var1_156

		local var2_156 = var0_156.m_YAxis

		var2_156.Value = 0.7
		var0_156.m_YAxis = var2_156

		arg0_154:RegisterOrbits(arg0_154.cameraPhoto)

		arg0_154.pinchValue = 1

		arg0_154:SetCameraObrits()
		arg0_154:RegisterCameraBlendFinished(var0_156, arg0_156)
		arg0_154:ActiveCamera(var0_156)
	end)
end

function var0_0.ExitPhotoMode(arg0_158)
	arg0_158:emit(Dorm3dScene.SHOW_BLOCK)
	arg0_158:ShowBlackScreen(function(arg0_159)
		arg0_158:RevertCameraOrbit()
		arg0_158:SwitchAnim(var0_0.ANIM.IDLE)
		onNextTick(function()
			local var0_160 = arg0_158.inFurniture:Find("StayPoint")

			arg0_158.lady.position = var0_160.position
			arg0_158.lady.rotation = var0_160.rotation

			arg0_158:SyncInterestTransform()
		end)
		arg0_158:RegisterCameraBlendFinished(arg0_158.lastCamera, arg0_159)
		arg0_158:ActiveCamera(arg0_158.lastCamera)
	end, function()
		arg0_158.lastCamera = nil

		arg0_158:RefreshSlots(arg0_158.apartment)
		arg0_158:emit(Dorm3dScene.HIDE_BLOCK)
	end)
end

function var0_0.SwitchCameraZone(arg0_162, arg1_162, arg2_162)
	arg0_162:emit(var0_0.SHOW_BLOCK)
	arg0_162:ShowBlackScreen(function(arg0_163)
		arg0_162:SwitchAnim(var0_0.ANIM.IDLE)
		onNextTick(function()
			arg0_162:ResetCharPosByZone(arg1_162)
			arg0_162:SyncInterestTransform()
			arg0_163()
		end)
	end, function()
		arg0_162:emit(var0_0.HIDE_BLOCK)
		existCall(arg2_162)
	end)
end

function var0_0.ResetCharPosByZone(arg0_166, arg1_166)
	local var0_166 = arg0_166:GetFurnitureByName(arg1_166:GetWatchCameraName()):Find("StayPoint")

	arg0_166.lady.position = var0_166.position
	arg0_166.lady.rotation = var0_166.rotation
end

function var0_0.GetNearestAngle(arg0_167, arg1_167, arg2_167, arg3_167)
	if arg3_167 < arg2_167 then
		arg3_167 = arg3_167 + 360
	end

	if arg2_167 <= arg1_167 and arg1_167 <= arg3_167 then
		return arg1_167
	end

	local var0_167 = (arg2_167 + arg3_167) / 2

	arg1_167 = var0_167 - Mathf.DeltaAngle(arg1_167, var0_167)
	arg1_167 = math.clamp(arg1_167, arg2_167, arg3_167)

	return arg1_167
end

function var0_0.PlayTimeline(arg0_168, arg1_168, arg2_168)
	local var0_168 = {}
	local var1_168 = arg1_168.name

	seriesAsync({
		function(arg0_169)
			pg.UIMgr.GetInstance():LoadingOn(false)
			arg0_169()
		end,
		function(arg0_170)
			arg0_168:LoadSceneAsync(string.lower("dorm3d/character/" .. arg0_168.assetRootName .. "/timeline/" .. var1_168 .. "/" .. var1_168 .. "_scene"), var1_168, function(arg0_171, arg1_171)
				onNextTick(arg0_170)
			end)
		end,
		function(arg0_172)
			if not arg1_168.scene then
				return arg0_172()
			end

			seriesAsync({
				function(arg0_173)
					local var0_173 = arg1_168.scene
					local var1_173 = arg1_168.sceneRoot

					arg0_168:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_173 .. "/" .. var0_173 .. "_scene"), var0_173, function(arg0_174, arg1_174)
						local var0_174 = _.detect(arg0_168.sceneDataList, function(arg0_175)
							return arg0_175.name == var0_173
						end)

						SceneOpMgr.Inst:SetActiveSceneByIndex(var0_174.index)
						onNextTick(arg0_173)
					end)
				end,
				function(arg0_176)
					arg0_168:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_168.sceneRootName .. "/" .. arg0_168.sceneName .. "_scene"), arg0_168.sceneName)
					arg0_176()
				end
			}, arg0_172)
		end,
		function(arg0_177)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_168.timelineCallback = arg2_168

			local var0_177 = GameObject.Find("[sequence]").transform
			local var1_177 = var0_177:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
			local var2_177 = GameObject.Find("[actor]").transform:GetComponentsInChildren(typeof(Animator))

			table.IpairsCArray(var2_177, function(arg0_178, arg1_178)
				GetOrAddComponent(arg1_178.transform, typeof(DftAniEvent))
			end)

			if arg1_168.time then
				var1_177.time = math.clamp(arg1_168.time, 0, var1_177.duration)
			end

			var1_177:Stop()

			local var3_177 = {}

			GetOrAddComponent(var0_177, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_179)
				local function var0_179()
					return
				end

				switch(arg0_179.stringParameter, {
					TimelinePause = function()
						arg0_168.timelineSpeed = 0

						setDirectorSpeed(var1_177, arg0_168.timelineSpeed)
					end,
					TimelineResume = function()
						arg0_168.timelineSpeed = 0

						setDirectorSpeed(var1_177, arg0_168.timelineSpeed)
					end,
					TimelinePlayOnTime = function()
						if arg0_179.intParameter == 0 or arg0_179.intParameter == var3_177.optionIndex then
							var1_177.time = arg0_179.floatParameter
						end
					end,
					TimelineSelectStart = function()
						var3_177.selectIndex = nil

						if arg1_168.options then
							arg0_168.baseView:DoTimelineOption(arg1_168.options, function(arg0_185)
								var3_177.selectIndex = arg0_185
								var3_177.optionIndex = arg1_168.options[arg0_185].flag
							end)
						end
					end,
					TimelineTouchStart = function()
						var3_177.selectIndex = nil

						if arg1_168.touchs then
							arg0_168.baseView:DoTimelineTouch(arg1_168.touchs, function(arg0_187)
								var3_177.selectIndex = arg0_187
								var3_177.optionIndex = arg1_168.touchs[arg0_187].flag
							end)
						end
					end,
					TimelineSelectLoop = function()
						if not var3_177.selectIndex then
							var1_177.time = arg0_179.floatParameter
						end
					end,
					TimelineEnd = function()
						var3_177.finish = true

						var1_177:Pause()
					end
				}, function()
					warning("other event trigger:" .. arg0_179.stringParameter)
				end)

				if var3_177.finish then
					seriesAsync({
						function(arg0_191)
							if not arg1_168.scene then
								return arg0_191()
							end

							arg0_168:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_168.sceneRootName .. "/" .. arg0_168.sceneName .. "_scene"), arg0_168.sceneName, function(arg0_192, arg1_192)
								local var0_192 = _.detect(arg0_168.sceneDataList, function(arg0_193)
									return arg0_193.name == arg0_168.sceneName
								end)

								SceneOpMgr.Inst:SetActiveSceneByIndex(var0_192.index)

								local var1_192 = arg1_168.scene
								local var2_192 = arg1_168.sceneRoot

								arg0_168:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var2_192 .. "/" .. var1_192 .. "_scene"), var1_192)
								arg0_191()
							end)
						end,
						function(arg0_194)
							arg0_168:RevertCharacter()
							setActive(arg0_168.mainCameraTF, true)
							arg0_168:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. arg0_168.assetRootName .. "/timeline/" .. var1_168 .. "/" .. var1_168 .. "_scene"), var1_168)
							warning(arg0_179.stringParameter, arg0_168.timelineCallback)

							local var0_194 = arg0_168.timelineCallback

							arg0_168.timelineCallback = nil

							existCall(var0_194, var3_177)
						end
					})
				end
			end)

			if defaultValue(arg0_168.timelineSpeed, 1) ~= 1 then
				arg0_168.timelineSpeed = 1

				setDirectorSpeed(var1_177, arg0_168.timelineSpeed)
			end

			arg0_168:HideCharacter()
			setActive(arg0_168.mainCameraTF, false)
			var1_177:Play()
		end
	})
end

function var0_0.PlaySingleAction(arg0_195, arg1_195, arg2_195)
	local var0_195 = {}

	warning("Play", arg1_195)

	if not arg0_195.ladyAnimator:GetCurrentAnimatorStateInfo(0):IsName(arg1_195) then
		table.insert(var0_195, function(arg0_196)
			arg0_195.nowState = arg1_195
			arg0_195.stateCallback = arg0_196

			arg0_195.ladyAnimator:CrossFade(arg1_195, 0.05)
		end)
		table.insert(var0_195, function(arg0_197)
			arg0_195.nowState = nil
			arg0_195.stateCallback = nil

			arg0_197()
		end)
	end

	seriesAsync(var0_195, arg2_195)
end

function var0_0.SwitchAnim(arg0_198, arg1_198, arg2_198)
	local var0_198 = {}

	warning("Switch", arg1_198)
	table.insert(var0_198, function(arg0_199)
		arg0_198.nowState = arg1_198
		arg0_198.stateCallback = arg0_199

		arg0_198.ladyAnimator:Play(arg1_198, 0, 0)
	end)
	table.insert(var0_198, function(arg0_200)
		arg0_198.nowState = nil
		arg0_198.stateCallback = nil

		arg0_200()
	end)
	seriesAsync(var0_198, arg2_198)
end

function var0_0.GetCurrentAnimatorStateInfo(arg0_201)
	return (arg0_201.ladyAnimator:GetCurrentAnimatorStateInfo(0))
end

function var0_0.SetCharacterAnimSpeed(arg0_202, arg1_202)
	arg0_202.ladyAnimator.speed = arg1_202
	arg0_202.ladyHeadIKComp.blinkSpeed = arg0_202.ladyHeadIKData.blinkSpeed * arg1_202

	if arg1_202 > 0 then
		arg0_202.ladyHeadIKComp.DampTime = arg0_202.ladyHeadIKData.DampTime / arg1_202
	else
		arg0_202.ladyHeadIKComp.DampTime = arg0_202.ladyHeadIKData.DampTime * math.huge
	end
end

function var0_0.OnAnimationEnd(arg0_203, arg1_203)
	if arg1_203.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_203 = arg1_203.stringParameter
	local var1_203 = table.removebykey(arg0_203.animCallbacks, var0_203)

	existCall(var1_203)
end

function var0_0.RegisterCallback(arg0_204, arg1_204, arg2_204)
	arg0_204.animCallbacks[arg1_204] = arg2_204
end

function var0_0.RegisterCameraBlendFinished(arg0_205, arg1_205, arg2_205)
	arg0_205.cameraBlendCallbacks[arg1_205] = arg2_205
end

function var0_0.UnRegisterCameraBlendFinished(arg0_206, arg1_206)
	arg0_206.cameraBlendCallbacks[arg1_206] = nil
end

function var0_0.OnCameraBlendFinished(arg0_207, arg1_207)
	if not arg1_207 then
		return
	end

	local var0_207 = table.removebykey(arg0_207.cameraBlendCallbacks, arg1_207)

	existCall(var0_207)
end

function var0_0.RegisterGlobalVolume(arg0_208)
	local var0_208 = arg0_208.globalVolume
	local var1_208 = BLHX.PostEffect.Overrides.DepthOfField
	local var2_208 = LuaHelper.GetOrAddVolumeComponent(var0_208, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var3_208 = LuaHelper.GetOrAddVolumeComponent(var0_208, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0_208.originalCameraSettings = {
		depthOfField = {
			enabeld = var2_208.enabled.value,
			focusDistance = {
				length = 2,
				min = var2_208.gaussianStart.min,
				value = var2_208.gaussianStart.value
			},
			blurRadius = {
				min = var2_208.blurRadius.min,
				max = var2_208.blurRadius.max,
				value = var2_208.blurRadius.value
			}
		},
		postExposure = {
			value = var3_208.postExposure.value
		},
		contrast = {
			min = var3_208.contrast.min,
			max = var3_208.contrast.max,
			value = var3_208.contrast.value
		},
		saturate = {
			min = var3_208.saturation.min,
			max = var3_208.saturation.max,
			value = var3_208.saturation.value
		}
	}
	arg0_208.originalCameraSettings.depthOfField.enabeld = true

	local var4_208 = var0_208:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_208.originalVolume = {
		profile = var4_208.sharedProfile,
		weight = var4_208.weight
	}
end

function var0_0.SettingCamera(arg0_209, arg1_209)
	arg0_209.activeCameraSettings = arg1_209

	local var0_209 = arg0_209.globalVolume
	local var1_209 = LuaHelper.GetOrAddVolumeComponent(var0_209, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2_209 = LuaHelper.GetOrAddVolumeComponent(var0_209, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1_209.enabled:Override(arg1_209.depthOfField.enabeld)
	var1_209.gaussianStart:Override(arg1_209.depthOfField.focusDistance.value)
	var1_209.gaussianEnd:Override(arg1_209.depthOfField.focusDistance.value + arg1_209.depthOfField.focusDistance.length)
	var1_209.blurRadius:Override(arg1_209.depthOfField.blurRadius.value)
	var2_209.postExposure:Override(arg1_209.postExposure.value)
	var2_209.contrast:Override(arg1_209.contrast.value)
	var2_209.saturation:Override(arg1_209.saturate.value)
end

function var0_0.GetCameraSettings(arg0_210)
	return arg0_210.originalCameraSettings
end

function var0_0.RevertCameraSettings(arg0_211)
	arg0_211:SettingCamera(arg0_211.originalCameraSettings)

	arg0_211.activeCameraSettings = nil
end

function var0_0.SetVolumeProfile(arg0_212, arg1_212, arg2_212)
	warning(arg1_212, arg2_212)

	local var0_212 = arg0_212.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0_212.activeProfileWeight = arg2_212

	if arg0_212.activeProfileName ~= arg1_212 then
		arg0_212.activeProfileName = arg1_212

		arg0_212.loader:LoadReference("dorm3d/scenesres/res/common", arg1_212, nil, function(arg0_213)
			warning(arg0_213 and arg0_213.name or "NIL")

			var0_212.profile = arg0_213
			var0_212.weight = arg0_212.activeProfileWeight

			if arg0_212.activeCameraSettings then
				arg0_212:SettingCamera(arg0_212.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0_212.weight = arg0_212.activeProfileWeight
	end
end

function var0_0.RevertVolumeProfile(arg0_214)
	local var0_214 = arg0_214.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0_214.profile = arg0_214.originalVolume.profile
	var0_214.weight = arg0_214.originalVolume.weight

	if arg0_214.activeCameraSettings then
		arg0_214:SettingCamera(arg0_214.activeCameraSettings)
	end

	arg0_214.activeProfileName = nil
end

function var0_0.RecordCharacterLight(arg0_215)
	local var0_215 = arg0_215.characterLight:GetComponent(typeof(Light))

	arg0_215.originalCharacterColor = {
		color = var0_215.color,
		intensity = var0_215.intensity
	}
end

function var0_0.SetCharacterLight(arg0_216, arg1_216, arg2_216, arg3_216)
	local var0_216 = arg0_216.characterLight:GetComponent(typeof(Light))

	var0_216.color = Color.Lerp(arg0_216.originalCharacterColor.color, arg1_216, arg3_216)
	var0_216.intensity = math.lerp(arg0_216.originalCharacterColor.intensity, arg2_216, arg3_216)
end

function var0_0.RevertCharacterLight(arg0_217)
	arg0_217:SetCharacterLight(arg0_217.originalCharacterColor.color, arg0_217.originalCharacterColor.intensity, 1)
end

function var0_0.LoadSceneAsync(arg0_218, arg1_218, arg2_218, arg3_218)
	table.insert(arg0_218.sceneDataList, {
		index = 0,
		status = "Loading",
		path = arg1_218,
		name = arg2_218
	})
	SceneOpMgr.Inst:LoadSceneAsync(arg1_218, arg2_218, LoadSceneMode.Additive, function(arg0_219, arg1_219)
		local var0_219 = _.detect(arg0_218.sceneDataList, function(arg0_220)
			return arg0_220.name == arg2_218
		end)

		var0_219.status = "Loaded"
		arg0_218.sceneCounter = arg0_218.sceneCounter + 1
		var0_219.index = arg0_218.sceneCounter

		existCall(arg3_218, arg0_219, arg1_219)
	end)
end

function var0_0.UnloadSceneAsync(arg0_221, arg1_221, arg2_221)
	SceneOpMgr.Inst:UnloadSceneAsync(arg1_221, arg2_221)

	local var0_221 = _.detect(arg0_221.sceneDataList, function(arg0_222)
		return arg0_222.name == arg2_221
	end)
	local var1_221 = var0_221.index

	var0_221.status = "Unloaded"
	arg0_221.sceneCounter = arg0_221.sceneCounter - 1
	var0_221.index = 0

	table.removebyvalue(arg0_221.sceneDataList, var0_221)
	_.each(arg0_221.sceneDataList, function(arg0_223)
		if arg0_223.index <= var1_221 then
			return
		end

		arg0_223.index = arg0_223.index - 1
	end)
end

function var0_0.SwitchLadyInterestInPhotoMode(arg0_224, arg1_224)
	if not arg1_224 then
		arg0_224:SyncInterestTransform()

		arg0_224.cameraPhoto.Follow = arg0_224.ladyInterest
		arg0_224.cameraPhoto.LookAt = arg0_224.ladyInterest
	else
		arg0_224.cameraPhoto.Follow = arg0_224.ladyInterestRoot
		arg0_224.cameraPhoto.LookAt = arg0_224.ladyInterestRoot
	end
end

function var0_0.SwitchDayNight(arg0_225, arg1_225)
	if not arg0_225.daynightCtrlComp then
		return
	end

	arg0_225.daynightCtrlComp:SwitcherToIndex(arg1_225)
end

local var1_0 = 5
local var2_0 = 2

function var0_0.DoRecenter(arg0_226)
	if arg0_226.recentTweenId then
		return
	end

	arg0_226.nextRecentTime = Time.time

	local var0_226 = arg0_226.ladyInterest.position - arg0_226.cameraFree.transform.position
	local var1_226 = Quaternion.LookRotation(var0_226).eulerAngles
	local var2_226 = var1_226.y
	local var3_226 = var1_226.x
	local var4_226 = arg0_226.compPov.m_HorizontalAxis.Value
	local var5_226 = arg0_226.compPov.m_VerticalAxis.Value
	local var6_226 = arg0_226:GetNearestAngle(var2_226, arg0_226.compPov.m_HorizontalAxis.m_MinValue, arg0_226.compPov.m_HorizontalAxis.m_MaxValue)

	arg0_226.recentTweenId = arg0_226:managedTween(LeanTween.value, nil, go(arg0_226.cameraFree), 0, 1, var2_0):setOnUpdate(System.Action_float(function(arg0_227)
		local var0_227 = math.lerp(var4_226, var6_226, arg0_227)
		local var1_227 = math.lerp(var5_226, var3_226, arg0_227)
		local var2_227 = arg0_226.compPov.m_HorizontalAxis

		var2_227.Value = var0_227
		arg0_226.compPov.m_HorizontalAxis = var2_227

		local var3_227 = arg0_226.compPov.m_VerticalAxis

		var3_227.Value = var1_227
		arg0_226.compPov.m_VerticalAxis = var3_227
	end)):setEase(LeanTweenType.easeOutSine).uniqueId
end

function var0_0.ResetRecenterTimer(arg0_228)
	arg0_228.nextRecentTime = Time.time + var1_0

	if not arg0_228.recentTweenId then
		return
	end

	LeanTween.cancel(arg0_228.recentTweenId)

	arg0_228.recentTweenId = nil
end

local var3_0 = 30

function var0_0.DoRecenterQuick(arg0_229, arg1_229)
	if arg0_229.recentTweenId then
		return
	end

	arg0_229.nextRecentTime = Time.time

	local var0_229 = arg0_229.ladyInterest.position - arg0_229.cameraFree.transform.position
	local var1_229 = Quaternion.LookRotation(var0_229).eulerAngles
	local var2_229 = var1_229.y
	local var3_229 = var1_229.x
	local var4_229 = arg0_229.compPov.m_HorizontalAxis.Value
	local var5_229 = arg0_229.compPov.m_VerticalAxis.Value
	local var6_229 = arg0_229:GetNearestAngle(var2_229, arg0_229.compPov.m_HorizontalAxis.m_MinValue, arg0_229.compPov.m_HorizontalAxis.m_MaxValue)
	local var7_229 = math.abs(var6_229 - var4_229) / var3_0

	if var7_229 < 0.5 then
		return existCall(arg1_229)
	end

	arg0_229.recentTweenId = arg0_229:managedTween(LeanTween.value, arg1_229, go(arg0_229.cameraFree), 0, 1, var7_229):setOnUpdate(System.Action_float(function(arg0_230)
		local var0_230 = math.lerp(var4_229, var6_229, arg0_230)
		local var1_230 = math.lerp(var5_229, var3_229, arg0_230)
		local var2_230 = arg0_229.compPov.m_HorizontalAxis

		var2_230.Value = var0_230
		arg0_229.compPov.m_HorizontalAxis = var2_230

		local var3_230 = arg0_229.compPov.m_VerticalAxis

		var3_230.Value = var1_230
		arg0_229.compPov.m_VerticalAxis = var3_230
	end)):setEase(LeanTweenType.easeOutSine).uniqueId
end

function var0_0.onBackPressed(arg0_231)
	if not arg0_231.baseView or arg0_231.retainCount > 0 then
		return
	end

	if not arg0_231.baseView:onBackPressed() then
		arg0_231:closeView()
	end
end

function var0_0.willExit(arg0_232)
	while arg0_232.baseView:onBackPressed() do
		-- block empty
	end

	arg0_232.baseView:Destroy()
	arg0_232.joystickTimer:Stop()
	arg0_232:ResetRecenterTimer()

	if arg0_232.moveTimer then
		arg0_232.moveTimer:Stop()
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()
	eachChild(arg0_232.furnitures, function(arg0_233)
		local var0_233 = GetComponent(arg0_233, typeof(EventTriggerListener))

		if not var0_233 then
			return
		end

		var0_233:ClearEvents()
	end)
	GetComponent(arg0_232.lady, typeof(EventTriggerListener)):ClearEvents()

	arg0_232.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_232.blockLayer, arg0_232._tf)
	arg0_232:RemoveCharacter()
	arg0_232.loader:Clear()
	arg0_232:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_232.sceneRootName .. "/" .. arg0_232.baseSceneName .. "_scene"), arg0_232.baseSceneName)
	arg0_232:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_232.sceneRootName .. "/" .. arg0_232.sceneName .. "_scene"), arg0_232.sceneName)
end

return var0_0
