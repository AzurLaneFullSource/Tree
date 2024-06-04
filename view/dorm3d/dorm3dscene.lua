local var0 = class("Dorm3dScene", import("view.base.BaseUI"))

var0.CAMERA = {
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
var0.BONE_TO_TOUCH = {
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
var0.CAMERA_MAX_OPERATION = {
	RIGHT = "right",
	DOWN = "donw",
	ZOOMIN = "zoom_in",
	ZOOMOUT = "zoom_out",
	UP = "up",
	LEFT = "left"
}
var0.ANIM = {
	IDLE = "Idle"
}
var0.PLAY_SINGLE_ACTION = "Dorm3dScene.PLAY_ACTION"
var0.SWITCH_ACTION = "Dorm3dScene.SWITCH_ACTION"
var0.PLAY_TIMELINE = "Dorm3dScene.PLAY_TIMELINE"
var0.MOVE_PLAYER_TO_FURNITURE = "Dorm3dScene.MOVE_PLAYER_TO_FURNITURE"
var0.ACTIVE_CAMERA = "Dorm3dScene.ACTIVE_CAMERA"
var0.SHOW_BLOCK = "Dorm3dScene.SHOW_BLOCK"
var0.HIDE_BLOCK = "Dorm3dScene.HIDE_BLOCK"
var0.ENTER_FREELOOK_MODE = "Dorm3dScene.ENTER_FREELOOK_MODE"
var0.EXIT_FREELOOK_MODE = "Dorm3dScene.EXIT_FREELOOK_MODE"
var0.ENTER_WATCH_MODE = "Dorm3dScene.ENTER_WATCH_MODE"
var0.EXIT_WATCH_MODE = "Dorm3dScene.EXIT_WATCH_MODE"
var0.WATCH_MODE_INTERACTIVE = "Dorm3dScene.WATCH_MODE_INTERACTIVE"
var0.ENTER_GIFT_MODE = "Dorm3dScene.ENTER_GIFT_MODE"
var0.EXIT_GIFT_MODE = "Dorm3dScene.EXIT_GIFT_MODE"
var0.ON_DIALOGUE_BEGIN = "Dorm3dScene.ON_DIALOGUE_BEGIN"
var0.ON_DIALOGUE_END = "Dorm3dScene.ON_DIALOGUE_END"
var0.ON_TOUCH_CHARACTER = "Dorm3dScene.ON_TOUCH_CHARACTER"
var0.ON_ROLEWATCH_CAMERA_MAX = "Dorm3dScene.ON_ROLEWATCH_CAMERA_MAX"
var0.ON_UPDATE_CONTACT_STSTE = "Dorm3dScene.ON_UPDATE_CONTACT_STSTE"
var0.ON_UPDATE_CONTACT_POSITION = "Dorm3dScene.ON_UPDATE_CONTACT_POSITION"
var0.ON_STICK_MOVE = "Dorm3dScene.ON_STICK_MOVE"

function var0.getUIName(arg0)
	return "Dorm3dMainUI"
end

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.sceneDataList = {}
	arg0.sceneCounter = 0
end

function var0.preload(arg0, arg1)
	local var0 = arg0.contextData.groupId
	local var1 = getProxy(ApartmentProxy):getApartment(var0)

	arg0:SetApartment(var1)

	arg0.sceneRootName = var1:GetSceneRootName()
	arg0.assetRootName = var1:GetAssetName()

	for iter0, iter1 in ipairs({
		"sceneName",
		"baseSceneName",
		"modelName"
	}) do
		arg0[iter1] = arg0.contextData.sceneData[iter1]
	end

	arg0.contextData.inFurnitureName = arg0.contextData.inFurnitureName or "Default"

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn(false)
			arg0:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0.sceneRootName .. "/" .. arg0.sceneName .. "_scene"), arg0.sceneName, function(arg0, arg1)
				SceneOpMgr.Inst:SetActiveSceneByIndex(1)
				onNextTick(arg0)
			end)
		end,
		function(arg0)
			arg0:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0.sceneRootName .. "/" .. arg0.baseSceneName .. "_scene"), arg0.baseSceneName, function(arg0, arg1)
				arg0()
			end)
		end,
		function(arg0)
			arg0:LoadCharacter(arg0)
		end,
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0()
		end,
		arg1
	})
end

function var0.init(arg0)
	arg0:initScene()
	arg0:InitCharacter()

	arg0.retainCount = 0
	arg0.blockLayer = arg0._tf:Find("Block")

	setActive(arg0.blockLayer, false)

	arg0.blackLayer = arg0._tf:Find("BlackScreen")

	setActive(arg0.blackLayer, false)

	arg0.loader = AutoLoader.New()

	arg0:BindEvent()

	arg0.baseView = Dorm3dBaseView.New(nil, arg0.event, arg0.contextData)

	arg0.baseView:SetExtra(arg0._tf)
	arg0.baseView:Load()
	arg0.baseView:BindEvent()
	arg0.baseView:SetApartment(arg0.apartment)
	arg0.baseView:initNodeCanvas(arg0.rtMainAI)
	arg0.baseView:SetLadyTransform(arg0.lady)
end

function var0.BindEvent(arg0)
	arg0:bind(Dorm3dScene.PLAY_SINGLE_ACTION, function(arg0, arg1, arg2)
		arg0:PlaySingleAction(arg1, arg2)
	end)
	arg0:bind(Dorm3dScene.SWITCH_ACTION, function(arg0, arg1, arg2)
		arg0:SwitchAnim(arg1, arg2)
	end)
	arg0:bind(Dorm3dScene.PLAY_TIMELINE, function(arg0, arg1, arg2)
		arg0:PlayTimeline(arg1, arg2)
	end)
	arg0:bind(Dorm3dScene.MOVE_PLAYER_TO_FURNITURE, function(arg0, arg1, arg2)
		arg0:PlayerMove(arg1, arg2)
	end)
	arg0:bind(Dorm3dScene.ACTIVE_CAMERA, function(arg0, arg1)
		local var0 = arg0.cameras[arg1]

		arg0:ActiveCamera(var0)
	end)
	arg0:bind(Dorm3dScene.SHOW_BLOCK, function()
		arg0.retainCount = arg0.retainCount + 1

		setActive(arg0.blockLayer, true)
	end)
	arg0:bind(Dorm3dScene.HIDE_BLOCK, function()
		arg0.retainCount = math.max(arg0.retainCount - 1, 0)

		if arg0.retainCount > 0 then
			return
		end

		setActive(arg0.blockLayer, false)
	end)
	arg0:bind(Dorm3dScene.ENTER_FREELOOK_MODE, function(arg0, arg1, arg2)
		arg0:EnterFreelookMode(arg1, arg2)
	end)
	arg0:bind(Dorm3dScene.EXIT_FREELOOK_MODE, function(arg0, arg1, arg2)
		arg0:ExitFreelookMode(arg1, arg2)
	end)
	arg0:bind(Dorm3dScene.ENTER_WATCH_MODE, function(arg0)
		arg0:EnterWatchMode()
	end)
	arg0:bind(Dorm3dScene.EXIT_WATCH_MODE, function(arg0)
		arg0:ExitWatchMode()
	end)
	arg0:bind(Dorm3dScene.WATCH_MODE_INTERACTIVE, function(arg0)
		arg0:WatchModeInteractive()
	end)
	arg0:bind(Dorm3dScene.ENTER_GIFT_MODE, function(arg0)
		arg0:EnterGiftMode()
	end)
	arg0:bind(Dorm3dScene.EXIT_GIFT_MODE, function(arg0)
		arg0:ExitGiftMode()
	end)
	arg0:bind(Dorm3dScene.ON_DIALOGUE_BEGIN, function(arg0, arg1)
		arg1()
	end)
	arg0:bind(Dorm3dScene.ON_DIALOGUE_END, function(arg0, arg1)
		arg1()
	end)
	arg0:bind(Dorm3dScene.ON_UPDATE_CONTACT_STSTE, function(arg0, arg1)
		warning("test")
		arg0:ActiveContact(arg1)
	end)
	arg0:bind(Dorm3dScene.ON_UPDATE_CONTACT_POSITION, function(arg0, arg1)
		arg0:UpdateContactPosition(arg1)
	end)
	arg0:bind(Dorm3dScene.ON_STICK_MOVE, function(arg0, arg1)
		arg0:OnStickMove(arg1)
	end)
end

function var0.SetApartment(arg0, arg1)
	arg0.apartment = arg1

	if arg0.baseView then
		arg0.baseView:SetApartment(arg1)
	end
end

function var0.GetApartment(arg0)
	return arg0.apartment
end

function var0.initScene(arg0)
	arg0.mainCameraTF = GameObject.Find("BackYardMainCamera").transform
	arg0.camBrain = arg0.mainCameraTF:GetComponent(typeof(Cinemachine.CinemachineBrain))
	arg0.camBrainEvenetHandler = arg0.mainCameraTF:GetComponent(typeof(CameraBrainEventsHandler))
	arg0.player = GameObject.Find("Player").transform
	arg0.furnitures = GameObject.Find("Furnitures").transform
	arg0.attachedPoints = {}

	eachChild(arg0.furnitures, function(arg0)
		table.insert(arg0.attachedPoints, 1, arg0)
		setActive(arg0:Find("FreeLook Camera"), false)
		setActive(arg0:Find("RoleWatch Camera"), false)
	end)

	arg0.dollyParent = GameObject.Find("Dollys").transform
	arg0.inFurniture = arg0.furnitures:Find(arg0.contextData.inFurnitureName)

	local var0 = GetComponent(arg0.inFurniture, typeof(UnityEngine.Collider))

	if var0 then
		var0.enabled = false
	end

	arg0.modelRoot = GameObject.Find("fbx").transform
	arg0.slotRoot = GameObject.Find("FurnitureSlots").transform

	setActive(arg0.slotRoot, true)
	arg0:InitSlots()

	arg0.contactRoot = GameObject.Find("ContactColliders").transform

	setActive(arg0.contactRoot, true)
	arg0:InitContact()

	local var1 = GameObject.Find("CM Cameras").transform

	arg0.cameraAim = var1:Find("Aim Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.cameraAim2 = var1:Find("Aim2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.cameraFree = nil
	arg0.cameraFurnitureWatch = nil
	arg0.cameraRole = var1:Find("Role Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.cameraRole2 = var1:Find("Role2 Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.cameraTalk = var1:Find("Talk Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.cameraGift = var1:Find("Gift Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.cameraRoleWatch = nil
	arg0.cameraPhoto = var1:Find("Photo Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook))
	arg0.cameras = {
		arg0.cameraAim,
		arg0.cameraAim2,
		arg0.cameraRole,
		arg0.cameraTalk,
		arg0.cameraRoleWatch,
		[var0.CAMERA.GIFT] = arg0.cameraGift,
		[var0.CAMERA.ROLE2] = arg0.cameraRole2,
		[var0.CAMERA.PHOTO] = arg0.cameraPhoto
	}
	arg0.compDolly = arg0.cameraAim:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Body)
	arg0.compPov = nil
	arg0.ladyInterest = GameObject.Find("InterestProxy").transform
	arg0.rtMainAI = GameObject.Find("MainAI").transform
	arg0.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera)).fieldOfView = arg0.mainCameraTF:GetComponent(typeof(Camera)).fieldOfView

	arg0:InitTimeline()

	arg0.globalVolume = GameObject.Find("GlobalVolume")

	arg0:RegisterGlobalVolume()

	arg0.characterLight = GameObject.Find("CharacterLight")

	arg0:RecordCharacterLight()

	local var2 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var2:GetComponentsInChildren(typeof(Light)), function(arg0, arg1)
		arg1.shadows = UnityEngine.LightShadows.None
	end)

	arg0.daynightCtrlComp = GameObject.Find("[MainBlock]").transform:GetComponent(typeof(DayNightCtrl))
end

function var0.InitSlots(arg0)
	local var0 = arg0.apartment:GetSlots()
	local var1 = arg0.modelRoot:GetComponentsInChildren(typeof(Transform))

	arg0.slotDict = {}

	_.each(var0, function(arg0)
		local var0 = arg0:GetFurnitureName()
		local var1 = arg0:GetConfigID()
		local var2 = arg0.slotRoot:Find(tostring(var1))

		assert(var2)

		local var3 = {
			trans = var2
		}
		local var4 = var2:Find("Selector")

		if var4 then
			GetOrAddComponent(var4, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0, arg1)
				arg0:emit(Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT, var1)
			end)
			setActive(var4, false)
		end

		local var5

		for iter0 = 0, var1.Length - 1 do
			local var6 = var1[iter0]

			if var6.name == var0 then
				var5 = var6

				break
			end
		end

		if var5 then
			var3.model = var5
		end

		arg0.slotDict[var1] = var3
	end)
end

function var0.InitContact(arg0)
	eachChild(arg0.contactRoot, function(arg0)
		local var0 = arg0:Find("Selector")

		GetOrAddComponent(var0, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0, arg1)
			arg0.baseView:SendNodeCanvasEvent("ClickContact", tf(arg0).parent.name)
		end)
		setActive(arg0, false)
	end)
end

function var0.ActiveContact(arg0, arg1)
	warning("ActiveContact", PrintTable(arg1))
	eachChild(arg0.contactRoot, function(arg0)
		local var0 = arg0.name

		warning(var0)
		setActive(arg0, tobool(arg1[var0]))

		if arg0.baseView.rtFloatPage:Find(var0) then
			setActive(arg0.baseView.rtFloatPage:Find(var0), tobool(arg1[var0]))
		elseif tobool(arg1[var0]) then
			cloneTplTo(arg0.baseView.tplFloat, arg0.baseView.rtFloatPage, var0)
		end
	end)
end

function var0.UpdateContactPosition(arg0, arg1)
	if not arg1 then
		return
	end

	for iter0, iter1 in pairs(arg1) do
		local var0 = arg0.baseView.rtFloatPage:Find(iter0)

		if var0 then
			local var1 = arg0:GetScreenPosition(arg0.contactRoot:Find(iter0)) or Vector2.New(-10000, -10000)

			setAnchoredPosition(var0, var1)
		else
			warning("without this contact colliders:" .. iter0)
		end
	end
end

function var0.InitTimeline(arg0)
	return
end

function var0.LoadCharacter(arg0, arg1)
	PoolMgr.GetInstance():GetPrefab("dorm3d/character/" .. arg0.assetRootName .. "/prefabs/" .. arg0.modelName, "", true, function(arg0)
		arg0.ladyGameobject = arg0

		existCall(arg1)
	end)
end

function var0.InitCharacter(arg0)
	arg0.lady = arg0.ladyGameobject.transform

	arg0.lady:SetParent(arg0.mainCameraTF)
	arg0.lady:SetParent(nil)

	local var0 = arg0.furnitures:Find(arg0.contextData.charFurnitureName or arg0.contextData.inFurnitureName)

	arg0.contextData.charFurnitureName = nil
	arg0.lady.position = var0:Find("StayPoint").position
	arg0.lady.rotation = var0:Find("StayPoint").rotation
	arg0.ladyAgent = arg0.lady:GetComponent(typeof(UnityEngine.AI.NavMeshAgent))
	arg0.ladyAgent.autoRepath = true
	arg0.ladyHeadIKComp = arg0.lady:GetComponent(typeof(HeadAimIK))
	arg0.ladyHeadIKComp.AimTarget = arg0.mainCameraTF:Find("AimTarget")
	arg0.ladyHeadIKData = {
		DampTime = arg0.ladyHeadIKComp.DampTime,
		blinkSpeed = arg0.ladyHeadIKComp.blinkSpeed
	}
	arg0.ladyAnimator = arg0.lady:GetComponent(typeof(Animator))

	local var1 = arg0.lady:GetComponentsInChildren(typeof(Transform))

	table.IpairsCArray(var1, function(arg0, arg1)
		if arg1.name == "BodyCollider" then
			arg0.ladyCollider = arg1
		elseif arg1.name == "Interest" then
			arg0.ladyInterestRoot = arg1
		end
	end)

	arg0.ladyColliders = {}
	arg0.ladyTouchColliders = {}

	table.IpairsCArray(arg0.lady:GetComponentsInChildren(typeof(UnityEngine.Collider)), function(arg0, arg1)
		arg1 = tf(arg1)

		local var0 = arg1.name
		local var1 = var0 and string.find(var0, "Collider") or -1

		if var1 <= 0 then
			errorMsg("Wrong Name to lady Collider : " .. var0)

			return
		end

		local var2 = string.sub(var0, 1, var1 - 1)

		arg0.ladyColliders[var2] = arg1

		if var2 ~= "Body" then
			table.insert(arg0.ladyTouchColliders, arg1)
			setActive(arg1, false)
		end
	end)

	arg0.cameraAim2.LookAt = arg0.ladyInterestRoot
	arg0.cameraTalk.Follow = arg0.ladyInterestRoot
	arg0.cameraTalk.LookAt = arg0.ladyInterestRoot
	arg0.cameraGift.Follow = arg0.ladyInterestRoot
	arg0.cameraGift.LookAt = arg0.ladyInterestRoot
	arg0.cameraRole2.LookAt = arg0.ladyInterestRoot
	arg0.cameraPhoto.Follow = arg0.ladyInterestRoot
	arg0.cameraPhoto.LookAt = arg0.ladyInterestRoot
end

function var0.RemoveCharacter(arg0)
	PoolMgr.GetInstance():ReturnPrefab("dorm3d/character/" .. arg0.assetRootName .. "/prefabs/" .. arg0.modelName, "", arg0.ladyGameobject, true)
end

function var0.didEnter(arg0)
	GetComponent(arg0.lady, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0, arg1)
		if arg1.rawPointerPress.transform == arg0.ladyCollider then
			arg0.baseView:SendNodeCanvasEvent("ClickCharacter", arg0.lady)
		else
			local var0 = table.keyof(arg0.ladyColliders, arg1.rawPointerPress.transform)

			warning(arg1.rawPointerPress.name, var0)
			arg0:emit(var0.ON_TOUCH_CHARACTER, Dorm3dScene.BONE_TO_TOUCH[var0] or arg1.rawPointerPress.name)
		end
	end)
	eachChild(arg0.furnitures, function(arg0)
		local var0 = GetComponent(arg0, typeof(EventTriggerListener))

		if not var0 then
			return
		end

		var0:AddPointClickFunc(function(arg0, arg1)
			arg0.baseView:SendNodeCanvasEvent("ClickFurniture", arg0.transform)
		end)
	end)

	local var0 = -21.6 / Screen.height

	arg0.joystickDelta = Vector2.zero
	arg0.joystickTimer = FrameTimer.New(function()
		local var0 = arg0.joystickDelta * var0
		local var1 = var0.x
		local var2 = var0.y

		local function var3(arg0, arg1, arg2)
			local var0 = arg0[arg1]

			var0.m_InputAxisValue = arg2
			arg0[arg1] = var0
		end

		if arg0.compPov and go(arg0.compPov).activeInHierarchy then
			var3(arg0.compPov, "m_HorizontalAxis", var1)
			var3(arg0.compPov, "m_VerticalAxis", var2)

			if math.abs(var1) < 0.01 and math.abs(var2) < 0.01 then
				if not arg0.recentTweenId and Time.time > arg0.nextRecentTime then
					arg0:DoRecenter()
				end
			else
				arg0:ResetRecenterTimer()
			end
		else
			arg0:ResetRecenterTimer()
		end

		if arg0.surroudCamera and not arg0.pinchMode then
			var3(arg0.surroudCamera, "m_XAxis", var1)
			var3(arg0.surroudCamera, "m_YAxis", var2)

			if arg0.surroudCamera == arg0.cameraRoleWatch then
				if var1 ~= 0 then
					local var4 = arg0.cameraRoleWatch.m_XAxis

					if not var4.m_Wrap then
						local var5 = var1 * (var4.m_InvertInput and -1 or 1)

						if var5 < 0 and var4.Value - 0.01 < var4.m_MinValue then
							arg0:emit(var0.ON_ROLEWATCH_CAMERA_MAX, var0.CAMERA_MAX_OPERATION.RIGHT)
						elseif var5 > 0 and var4.Value + 0.01 > var4.m_MaxValue then
							arg0:emit(var0.ON_ROLEWATCH_CAMERA_MAX, var0.CAMERA_MAX_OPERATION.LEFT)
						end
					end
				end

				if var2 ~= 0 then
					local var6 = arg0.cameraRoleWatch.m_YAxis

					if not var6.m_Wrap then
						if var2 < 0 and var6.Value - 0.01 < var6.m_MinValue then
							arg0:emit(var0.ON_ROLEWATCH_CAMERA_MAX, var0.CAMERA_MAX_OPERATION.DOWN)
						elseif var2 > 0 and var6.Value + 0.01 > var6.m_MaxValue then
							arg0:emit(var0.ON_ROLEWATCH_CAMERA_MAX, var0.CAMERA_MAX_OPERATION.UP)
						end
					end
				end
			end
		end

		arg0.joystickDelta = Vector2.zero
	end, 1, -1)

	arg0.joystickTimer:Start()

	arg0.pinchMode = false
	arg0.pinchSize = 0
	arg0.pinchValue = 1
	arg0.pinchNodeOrder = 1

	local var1 = 0.5
	local var2 = 1

	GlobalClickEventMgr.Inst:AddBeginPinchFunc(function(arg0, arg1)
		if not arg0.surroudCamera or not isActive(arg0.surroudCamera) then
			return
		end

		arg0.pinchMode = true
		arg0.pinchSize = (arg0 - arg1):Magnitude()
		arg0.pinchNodeOrder = arg1.x < arg0.x and -1 or 1
	end)

	local var3 = 0.01

	if IsUnityEditor then
		var3 = 0.1
	end

	local var4 = var3 * 1080 / Screen.height

	GlobalClickEventMgr.Inst:AddPinchFunc(function(arg0, arg1)
		if not arg0.pinchMode then
			return
		end

		local var0 = (arg0 - arg1):Magnitude()
		local var1 = arg0.pinchSize - var0
		local var2 = arg0.pinchNodeOrder * (arg1.x < arg0.x and -1 or 1)
		local var3 = var1 * var4 * var2

		arg0:SetPinchValue(math.clamp(arg0.pinchValue + var3, var1, var2))

		arg0.pinchSize = var0

		if arg0.surroudCamera == arg0.cameraRoleWatch then
			if var3 > 0.01 and arg0.pinchValue == var2 then
				arg0:emit(var0.ON_ROLEWATCH_CAMERA_MAX, var0.CAMERA_MAX_OPERATION.ZOOMOUT)
			elseif var3 < -0.01 and arg0.pinchValue == var1 then
				arg0:emit(var0.ON_ROLEWATCH_CAMERA_MAX, var0.CAMERA_MAX_OPERATION.ZOOMIN)
			end
		end
	end)
	GlobalClickEventMgr.Inst:AddEndPinchFunc(function()
		arg0.pinchMode = false
		arg0.pinchSize = 0
	end)
	arg0.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0)
		if arg0.nowState and arg0.animatorStateInfo:IsName(arg0.nowState) then
			existCall(arg0.stateCallback)
		elseif arg0.stringParameter ~= "" then
			arg0:OnAnimationEnd(arg0)
		end
	end)

	arg0.animCallbacks = {}
	arg0.cameraBlendCallbacks = {}

	function arg0.camBrainEvenetHandler.OnBlendFinished(arg0)
		arg0:OnCameraBlendFinished(arg0)
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0.blockLayer, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})
	arg0:OnSwitchStaticPosition()

	arg0.nextRecentTime = 0

	arg0:RefreshSlots(arg0.apartment)
	arg0.baseView:TreeStart()
end

function var0.OnStickMove(arg0, arg1)
	arg0.joystickDelta = arg1
end

function var0.SetPinchValue(arg0, arg1)
	arg0.pinchValue = arg1

	arg0:SetCameraObrits()
end

function var0.ShowBaseView(arg0)
	setActive(arg0.contactRoot, false)
	arg0.baseView:TempHideUI(false)
end

function var0.HideBaseView(arg0)
	setActive(arg0.contactRoot, true)
	arg0.baseView:TempHideUI(true)
end

function var0.RefreshSlots(arg0, arg1)
	local var0 = arg1:GetSlots()
	local var1 = arg1:GetFurnitures()

	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0, function(arg0, arg1, arg2)
		local var0 = arg1:GetConfigID()
		local var1 = _.detect(var1, function(arg0)
			return arg0:GetSlotID() == var0
		end)
		local var2 = var1 and var1:GetModel() or ""

		if arg0.slotDict[var0].displayModelName == var2 then
			arg2()

			return
		end

		local var3 = arg0.slotDict[var0].model

		arg0.slotDict[var0].displayModelName = var2

		if not var2 or var2 == "" then
			arg0.loader:ClearRequest("slot_" .. var0)

			if var3 then
				setActive(var3, true)
			end

			arg2()

			return
		end

		local var4 = arg0.slotDict[var0].trans

		arg0.loader:GetPrefab("dorm3d/furniture/prefabs/" .. var2, "", function(arg0)
			arg2()
			assert(arg0)
			setParent(arg0, var4)

			if var3 then
				local var0 = arg0:GetComponentsInChildren(typeof(Renderer))

				table.IpairsCArray(var0, function(arg0, arg1)
					LuaHelper.CopyLightMap(arg1.gameObject, arg0)
				end)
				setActive(var3, false)
			end
		end, "slot_" .. var0)
	end, function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
	end)
end

function var0.SyncInterestTransform(arg0)
	arg0.ladyInterest.position = arg0.ladyInterestRoot.position
	arg0.ladyInterest.rotation = arg0.ladyInterestRoot.rotation
end

function var0.OnSwitchStaticPosition(arg0, arg1)
	arg0.baseView:SetInFurniture(arg0.inFurniture)

	local var0 = GetComponent(arg0.inFurniture, typeof(UnityEngine.Collider))

	if var0 then
		var0.enabled = false
	end

	local var1 = arg0.inFurniture
	local var2 = var1:Find("FreeLook Camera")

	arg0:SyncInterestTransform()

	local var3 = var2.transform.position

	var3.y = 0
	arg0.player.position = var3

	if arg0.cameraFree then
		setActive(arg0.cameraFree, false)

		arg0.cameras[var0.CAMERA.FURNITURE_FREELOOK] = nil
	end

	arg0.cameraFree = var1:Find("FreeLook Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))
	arg0.compPov = arg0.cameraFree:GetCinemachineComponent(Cinemachine.CinemachineCore.Stage.Aim)
	arg0.cameras[var0.CAMERA.FURNITURE_FREELOOK] = arg0.cameraFree

	if arg0.cameraRoleWatch then
		arg0:RevertCameraOrbit()
	end

	arg0.cameraRoleWatch = var1:Find("RoleWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineFreeLook))
	arg0.cameras[var0.CAMERA.ROLE_WATCH] = arg0.cameraRoleWatch

	arg0:RegisterOrbits(arg0.cameraRoleWatch)

	local var4 = arg0.ladyInterest.position - var2.transform.position
	local var5 = Quaternion.LookRotation(var4).eulerAngles
	local var6 = var5.y
	local var7 = var5.x
	local var8 = arg0.compPov.m_HorizontalAxis

	var8.Value = arg0:GetNearestAngle(var6, var8.m_MinValue, var8.m_MaxValue)
	arg0.compPov.m_HorizontalAxis = var8

	local var9 = arg0.compPov.m_VerticalAxis

	var9.Value = var7
	arg0.compPov.m_VerticalAxis = var9

	arg0:ResetRecenterTimer()
	arg0:RegisterCameraBlendFinished(arg0.cameraFree, arg1)
	arg0:ActiveCamera(arg0.cameraFree)
end

function var0.GetAttachedFurnitureName(arg0)
	return arg0.inFurniture.name
end

function var0.GetFurnitureByName(arg0, arg1)
	return underscore.detect(arg0.attachedPoints, function(arg0)
		return arg0.name == arg1
	end)
end

function var0.GetSlotByID(arg0, arg1)
	return arg0.displaySlots[arg1] and arg0.displaySlots[arg1].trans
end

function var0.GetScreenPosition(arg0, arg1)
	local var0 = arg0.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera)):WorldToScreenPoint(arg1.position)

	if var0.z < 0 then
		return false
	end

	local var1 = pg.UIMgr.GetInstance().uiCamera:Find("Canvas").rect

	return (Vector2.New(var0.x / Screen.width * var1.width, var0.y / Screen.height * var1.height))
end

function var0.GetModelRoot(arg0)
	return arg0.modelRoot
end

function var0.PlayerMove(arg0, arg1, arg2)
	local var0 = arg0:GetFurnitureByName(arg1)

	if not var0 then
		errorMsg(arg1 .. " Not Find")
		existCall(arg2)

		return
	end

	if var0 == arg0.inFurniture then
		existCall(arg2)

		return
	end

	local var1 = arg0.inFurniture
	local var2 = var1:Find("FreeLook Camera")
	local var3 = _.detect(arg0.apartment:GetZones(), function(arg0)
		return arg0:GetWatchCameraName() == var1.name
	end)
	local var4 = _.detect(arg0.apartment:GetZones(), function(arg0)
		return arg0:GetWatchCameraName() == arg1
	end)
	local var5 = table.indexof(arg0.attachedPoints, arg0.inFurniture)
	local var6 = table.indexof(arg0.attachedPoints, var0)
	local var7 = false

	if var6 < var5 then
		var7 = true
		var5, var6 = var6, var5
	end

	local var8 = "Dolly" .. var5 .. "_" .. var6
	local var9 = arg0.dollyParent:Find(var8):GetComponent(typeof(Cinemachine.CinemachineSmoothPath))

	arg0.compDolly.m_Path = var9

	local var10 = GetComponent(arg0.inFurniture, typeof(UnityEngine.Collider))

	if var10 then
		var10.enabled = true
	end

	local var11 = var0:Find("Interest")
	local var12 = var0:Find("StayPoint")

	seriesAsync({
		function(arg0)
			arg0:emit(Dorm3dScene.SHOW_BLOCK)

			arg0.cameraAim.transform.position = var2.transform.position
			arg0.cameraAim2.transform.position = var2.transform.position

			arg0:ActiveCamera(arg0.cameraAim2)
			arg0()
		end,
		function(arg0)
			local var0 = arg0.ladyAgent

			var0.enabled = true
			var0.destination = var12.position
			var0.speed = 0
			arg0.moveTimer = waitUntil(function()
				arg0:WalkByRootMotionLoop(var0, arg0.ladyAnimator)

				return var0.remainingDistance < 0.1
			end, function()
				var0.enabled = false

				arg0()
			end)
		end,
		function(arg0)
			local var0 = arg0.lady.rotation
			local var1 = var12.rotation:ToEulerAngles().y - var0:ToEulerAngles().y

			if var1 < -180 then
				var1 = var1 + 360
			elseif var1 > 180 then
				var1 = var1 - 360
			end

			arg0.ladyAnimator:SetFloat("Speed", 0)
			arg0.ladyAnimator:SetBool("Turn", true)
			arg0.ladyAnimator:SetFloat("TurnAngle", var1)
			arg0:RegisterCallback("TurnEnd", function()
				arg0.ladyAnimator:SetFloat("TurnAngle", 0)
				arg0.ladyAnimator:SetBool("Turn", false)
				arg0()
			end)
		end,
		function(arg0)
			arg0:ActiveCamera(arg0.cameraAim)

			arg0.cameraAim.LookAt = var11

			local var0 = 1
			local var1 = arg0.compDolly.m_Path.PathLength
			local var2 = var1 / var0

			arg0:managedTween(LeanTween.value, arg0, go(arg0.cameraAim), 0, 1, var2):setOnUpdate(System.Action_float(function(arg0)
				local var0 = var7 and 1 - arg0 or arg0

				arg0.compDolly.m_PathPosition = var1 * var0
			end))
		end,
		function(arg0)
			arg0.inFurniture = var0
			arg0.contextData.inFurnitureName = var0.name

			arg0:OnSwitchStaticPosition(arg0)
		end,
		function(arg0)
			arg0:emit(Dorm3dScene.HIDE_BLOCK)
			arg0()
		end
	}, arg2)
end

function var0.WalkByRootMotionLoop(arg0, arg1, arg2)
	if arg1.pathPending then
		arg2:SetFloat("Speed", 0)

		return
	end

	arg2:SetFloat("Speed", 1)

	local var0 = arg1.path.corners

	if var0.Length > 1 then
		local var1 = var0[1] - arg1.transform.position

		var1.y = 0

		local var2 = Quaternion.LookRotation(var1)
		local var3 = arg1.transform.rotation
		local var4 = 1
		local var5 = Damp(1, var4, Time.deltaTime)

		arg1.transform.rotation = Quaternion.Lerp(var3, var2, var5)
	end
end

function var0.ActiveCamera(arg0, arg1)
	table.Foreach(arg0.cameras, function(arg0, arg1)
		setActive(arg1, arg1 == arg1)
	end)
end

function var0.ShowBlackScreen(arg0, arg1, arg2)
	local var0 = 0.3

	seriesAsync({
		function(arg0)
			setActive(arg0.blackLayer, true)
			arg0:managedTween(LeanTween.alpha, arg0, arg0.blackLayer, 1, var0)
		end,
		function(arg0)
			arg1(arg0)
		end,
		function(arg0)
			arg0:managedTween(LeanTween.alpha, arg0, arg0.blackLayer, 0, var0)
		end,
		function()
			setActive(arg0.blackLayer, false)
			existCall(arg2)
		end
	})
end

function var0.RegisterOrbits(arg0, arg1)
	arg0.orbits = {
		original = arg1.m_Orbits
	}
	arg0.orbits.current = _.range(3):map(function(arg0)
		local var0 = arg0.orbits.original[arg0 - 1]

		return Cinemachine.CinemachineFreeLook.Orbit.New(var0.m_Height, var0.m_Radius)
	end)
	arg0.surroudCamera = arg1
end

function var0.SetCameraObrits(arg0)
	local var0 = arg0.surroudCamera

	if not var0 then
		return
	end

	local var1 = arg0.orbits.original[1]

	for iter0 = 0, #arg0.orbits.current - 1 do
		local var2 = arg0.orbits.current[iter0 + 1]
		local var3 = arg0.orbits.original[iter0]

		var2.m_Height = math.lerp(var1.m_Height, var3.m_Height, arg0.pinchValue)
		var2.m_Radius = var3.m_Radius * arg0.pinchValue
	end

	var0.m_Orbits = arg0.orbits.current
end

function var0.RevertCameraOrbit(arg0)
	local var0 = arg0.surroudCamera

	if not var0 then
		return
	end

	for iter0 = 0, #arg0.orbits.current - 1 do
		local var1 = arg0.orbits.current[iter0 + 1]
		local var2 = arg0.orbits.original[iter0]

		var1.m_Height = var2.m_Height
		var1.m_Radius = var2.m_Radius
	end

	var0.m_Orbits = arg0.orbits.current
	arg0.surroudCamera = nil
end

function var0.EnterWatchMode(arg0)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0.baseView:EnableJoystick(false)
	arg0:ResetRecenterTimer()
	arg0:DoRecenterQuick(function()
		seriesAsync({
			function(arg0)
				arg0:RegisterCameraBlendFinished(arg0.cameraRole, arg0)
				arg0:ActiveCamera(arg0.cameraRole)
			end
		}, function()
			arg0.baseView:EnterWatchMode()
			arg0:emit(Dorm3dScene.HIDE_BLOCK)
		end)
	end)
end

function var0.ExitWatchMode(arg0)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0.baseView:ExitWatchMode()
	seriesAsync({
		function(arg0)
			arg0:ResetRecenterTimer()
			arg0:RegisterCameraBlendFinished(arg0.cameraFree, arg0)
			arg0:ActiveCamera(arg0.cameraFree)
		end
	}, function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
		arg0.baseView:EnableJoystick(true)
	end)
end

function var0.WatchModeInteractive(arg0)
	if arg0.inFurniture.name ~= "Bed" then
		arg0:PlaySingleAction("Bow")
	end
end

function var0.EnterFreelookMode(arg0, arg1, arg2)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	seriesAsync({
		function(arg0)
			if arg2.standby_action and arg2.standby_action ~= "" then
				parallelAsync({
					function(arg0)
						arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, arg2.standby_action, arg0)
					end,
					function(arg0)
						arg0.cameras[var0.CAMERA.ROLE2].transform.position = arg0.cameraRole.transform.position

						arg0:ResetRecenterTimer()
						arg0:RegisterCameraBlendFinished(arg0.cameras[var0.CAMERA.ROLE2], arg0)
						arg0:ActiveCamera(arg0.cameras[var0.CAMERA.ROLE2])
					end
				}, arg0)

				return
			end

			arg0()
		end,
		function(arg0)
			arg0:ResetRecenterTimer()

			arg0.pinchValue = 1

			arg0:SetCameraObrits()

			local var0 = arg0.cameraRoleWatch.m_XAxis

			var0.Value = 180
			arg0.cameraRoleWatch.m_XAxis = var0

			local var1 = arg0.cameraRoleWatch.m_YAxis

			var1.Value = 0.7
			arg0.cameraRoleWatch.m_YAxis = var1

			arg0:SyncInterestTransform()
			arg0:RegisterCameraBlendFinished(arg0.cameraRoleWatch, arg0)
			arg0:ActiveCamera(arg0.cameraRoleWatch)
		end,
		function(arg0)
			setActive(arg0.ladyCollider, false)
			_.each(arg0.ladyTouchColliders, function(arg0)
				setActive(arg0, true)
			end)
			arg0()
		end
	}, function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
		arg1()
	end)
end

function var0.ExitFreelookMode(arg0, arg1, arg2)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	seriesAsync({
		function(arg0)
			setActive(arg0.ladyCollider, true)
			_.each(arg0.ladyTouchColliders, function(arg0)
				setActive(arg0, false)
			end)
			arg0()
		end,
		function(arg0)
			if arg2.finish_action and arg2.finish_action ~= "" then
				parallelAsync({
					function(arg0)
						arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, arg2.finish_action, arg0)
					end,
					function(arg0)
						arg0:ResetRecenterTimer()
						arg0:RegisterCameraBlendFinished(arg0.cameras[var0.CAMERA.ROLE2], arg0)
						arg0:ActiveCamera(arg0.cameras[var0.CAMERA.ROLE2])
					end
				}, arg0)

				return
			end

			arg0()
		end,
		function(arg0)
			arg0:SyncInterestTransform()
			arg0:RegisterCameraBlendFinished(arg0.cameraRole, arg0)
			arg0:ActiveCamera(arg0.cameraRole)
		end
	}, function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
		arg1()
	end)
end

function var0.EnableHeadIK(arg0, arg1)
	arg0.ladyHeadIKComp.enableIk = arg1
end

function var0.HideCharacter(arg0)
	arg0.lastCharacterPosition = arg0.lady.position

	setLocalPosition(arg0.lady, Vector3(0, -10000, 0))
end

function var0.RevertCharacter(arg0)
	setLocalPosition(arg0.lady, arg0.lastCharacterPosition or Vector3.zero)
end

function var0.EnterFurnitureWatchMode(arg0)
	arg0:HideCharacter()

	arg0.lastCamera = table.Find(arg0.cameras, function(arg0, arg1)
		return isActive(arg1)
	end)

	eachChild(arg0.furnitures, function(arg0)
		local var0 = arg0:GetComponent(typeof(UnityEngine.Collider))

		if not var0 then
			return
		end

		var0.enabled = false
	end)
end

function var0.ExitFurnitureWatchMode(arg0)
	arg0:HideFurnitureSlots()
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0:ShowBlackScreen(function(arg0)
		arg0:RegisterCameraBlendFinished(arg0.lastCamera, arg0)
		arg0:ActiveCamera(arg0.lastCamera)
	end, function()
		arg0.lastCamera = nil

		arg0:emit(Dorm3dScene.HIDE_BLOCK)
	end)
	eachChild(arg0.furnitures, function(arg0)
		local var0 = arg0:GetComponent(typeof(UnityEngine.Collider))

		if not var0 then
			return
		end

		var0.enabled = true
	end)
	arg0:RefreshSlots(arg0.apartment)
end

function var0.EnterGiftMode(arg0)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0:RegisterCameraBlendFinished(arg0.cameras[var0.CAMERA.GIFT], function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
	end)
	arg0:ActiveCamera(arg0.cameras[var0.CAMERA.GIFT])
end

function var0.ExitGiftMode(arg0)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0:RegisterCameraBlendFinished(arg0.cameras[var0.CAMERA.ROLE], function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
	end)
	arg0:ActiveCamera(arg0.cameras[var0.CAMERA.ROLE])
end

function var0.SwitchZone(arg0, arg1, arg2)
	local var0 = arg0:GetFurnitureByName(arg1:GetWatchCameraName()):Find("FurnitureWatch Camera"):GetComponent(typeof(Cinemachine.CinemachineVirtualCamera))

	if arg0.cameraFurnitureWatch and arg0.cameraFurnitureWatch ~= var0 then
		arg0:UnRegisterCameraBlendFinished(arg0.cameraFurnitureWatch)
		setActive(arg0.cameraFurnitureWatch, false)
	end

	arg0.cameraFurnitureWatch = var0
	arg0.cameras[var0.CAMERA.FURNITURE_WATCH] = arg0.cameraFurnitureWatch

	arg0:RegisterCameraBlendFinished(arg0.cameraFurnitureWatch, function()
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
		existCall(arg2)
	end)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0:ActiveCamera(arg0.cameraFurnitureWatch)
end

function var0.HideFurnitureSlots(arg0)
	if arg0.displaySlots then
		arg0:UpdateDisplaySlots({})
		table.Foreach(arg0.displaySlots, function(arg0, arg1)
			local var0 = arg1.trans

			if IsNil(var0:Find("Selector")) then
				return
			end

			setActive(var0:Find("Selector"), false)
		end)

		arg0.displaySlots = nil
	end
end

function var0.DisplayFurnitureSlots(arg0, arg1)
	arg0:HideFurnitureSlots()

	arg0.displaySlots = {}

	_.each(arg1, function(arg0)
		arg0.displaySlots[arg0] = arg0.slotDict[arg0]

		if not arg0.displaySlots[arg0] then
			errorMsg("Slot " .. arg0 .. " Not Binding Scene Object")

			return
		end

		local var0 = arg0.displaySlots[arg0].trans

		if var0:Find("Selector") then
			setActive(var0:Find("Selector"), true)
		end
	end)
end

function var0.UpdateDisplaySlots(arg0, arg1)
	table.Foreach(arg0.displaySlots, function(arg0, arg1)
		local var0 = arg1.trans

		if not IsNil(var0:Find("Selector")) then
			setActive(var0:Find("Selector/Normal"), arg1[arg0] == 0)
			setActive(var0:Find("Selector/Active"), arg1[arg0] == 1)
			setActive(var0:Find("Selector/Ban"), arg1[arg0] == 2)
		end

		local var1 = arg0.slotDict[arg0].model
		local var2 = arg0.slotDict[arg0].displayModelName

		if var2 and var2 ~= "" then
			var1 = var0:GetChild(var0.childCount - 1)
		end

		local function var3(arg0, arg1)
			local var0 = arg0:GetComponentsInChildren(typeof(Renderer))

			table.IpairsCArray(var0, function(arg0, arg1)
				local var0 = arg1.material

				if var0 and var0:HasProperty("_FinalTint") then
					var0:SetColor("_FinalTint", arg1)
				end
			end)
		end

		if var1 then
			if arg1[arg0] == 1 then
				var3(var1, Color.NewHex("3F83AE73"))
			else
				var3(var1, Color.New(0, 0, 0, 0))
			end
		end
	end)
end

function var0.EnterPhotoMode(arg0, arg1)
	arg0.lastCamera = table.Find(arg0.cameras, function(arg0, arg1)
		return isActive(arg1)
	end)

	arg0:ShowBlackScreen(function(arg0)
		arg0:SwitchAnim(var0.ANIM.IDLE)
		onNextTick(function()
			arg0:ResetCharPosByZone(arg1)
			arg0:SyncInterestTransform()
		end)

		local var0 = arg0.cameraPhoto
		local var1 = var0.m_XAxis

		var1.Value = 180
		var0.m_XAxis = var1

		local var2 = var0.m_YAxis

		var2.Value = 0.7
		var0.m_YAxis = var2

		arg0:RegisterOrbits(arg0.cameraPhoto)

		arg0.pinchValue = 1

		arg0:SetCameraObrits()
		arg0:RegisterCameraBlendFinished(var0, arg0)
		arg0:ActiveCamera(var0)
	end)
end

function var0.ExitPhotoMode(arg0)
	arg0:emit(Dorm3dScene.SHOW_BLOCK)
	arg0:ShowBlackScreen(function(arg0)
		arg0:RevertCameraOrbit()
		arg0:SwitchAnim(var0.ANIM.IDLE)
		onNextTick(function()
			local var0 = arg0.inFurniture:Find("StayPoint")

			arg0.lady.position = var0.position
			arg0.lady.rotation = var0.rotation

			arg0:SyncInterestTransform()
		end)
		arg0:RegisterCameraBlendFinished(arg0.lastCamera, arg0)
		arg0:ActiveCamera(arg0.lastCamera)
	end, function()
		arg0.lastCamera = nil

		arg0:RefreshSlots(arg0.apartment)
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
	end)
end

function var0.SwitchCameraZone(arg0, arg1, arg2)
	arg0:emit(var0.SHOW_BLOCK)
	arg0:ShowBlackScreen(function(arg0)
		arg0:SwitchAnim(var0.ANIM.IDLE)
		onNextTick(function()
			arg0:ResetCharPosByZone(arg1)
			arg0:SyncInterestTransform()
			arg0()
		end)
	end, function()
		arg0:emit(var0.HIDE_BLOCK)
		existCall(arg2)
	end)
end

function var0.ResetCharPosByZone(arg0, arg1)
	local var0 = arg0:GetFurnitureByName(arg1:GetWatchCameraName()):Find("StayPoint")

	arg0.lady.position = var0.position
	arg0.lady.rotation = var0.rotation
end

function var0.GetNearestAngle(arg0, arg1, arg2, arg3)
	if arg3 < arg2 then
		arg3 = arg3 + 360
	end

	if arg2 <= arg1 and arg1 <= arg3 then
		return arg1
	end

	local var0 = (arg2 + arg3) / 2

	arg1 = var0 - Mathf.DeltaAngle(arg1, var0)
	arg1 = math.clamp(arg1, arg2, arg3)

	return arg1
end

function var0.PlayTimeline(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1.name

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn(false)
			arg0()
		end,
		function(arg0)
			arg0:LoadSceneAsync(string.lower("dorm3d/character/" .. arg0.assetRootName .. "/timeline/" .. var1 .. "/" .. var1 .. "_scene"), var1, function(arg0, arg1)
				onNextTick(arg0)
			end)
		end,
		function(arg0)
			if not arg1.scene then
				return arg0()
			end

			seriesAsync({
				function(arg0)
					local var0 = arg1.scene
					local var1 = arg1.sceneRoot

					arg0:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1 .. "/" .. var0 .. "_scene"), var0, function(arg0, arg1)
						local var0 = _.detect(arg0.sceneDataList, function(arg0)
							return arg0.name == var0
						end)

						SceneOpMgr.Inst:SetActiveSceneByIndex(var0.index)
						onNextTick(arg0)
					end)
				end,
				function(arg0)
					arg0:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0.sceneRootName .. "/" .. arg0.sceneName .. "_scene"), arg0.sceneName)
					arg0()
				end
			}, arg0)
		end,
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0.timelineCallback = arg2

			local var0 = GameObject.Find("[sequence]").transform
			local var1 = var0:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
			local var2 = GameObject.Find("[actor]").transform:GetComponentsInChildren(typeof(Animator))

			table.IpairsCArray(var2, function(arg0, arg1)
				GetOrAddComponent(arg1.transform, typeof(DftAniEvent))
			end)

			if arg1.time then
				var1.time = math.clamp(arg1.time, 0, var1.duration)
			end

			var1:Stop()

			local var3 = {}

			GetOrAddComponent(var0, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0)
				local function var0()
					return
				end

				switch(arg0.stringParameter, {
					TimelinePause = function()
						arg0.timelineSpeed = 0

						setDirectorSpeed(var1, arg0.timelineSpeed)
					end,
					TimelineResume = function()
						arg0.timelineSpeed = 0

						setDirectorSpeed(var1, arg0.timelineSpeed)
					end,
					TimelinePlayOnTime = function()
						if arg0.intParameter == 0 or arg0.intParameter == var3.optionIndex then
							var1.time = arg0.floatParameter
						end
					end,
					TimelineSelectStart = function()
						var3.selectIndex = nil

						if arg1.options then
							arg0.baseView:DoTimelineOption(arg1.options, function(arg0)
								var3.selectIndex = arg0
								var3.optionIndex = arg1.options[arg0].flag
							end)
						end
					end,
					TimelineTouchStart = function()
						var3.selectIndex = nil

						if arg1.touchs then
							arg0.baseView:DoTimelineTouch(arg1.touchs, function(arg0)
								var3.selectIndex = arg0
								var3.optionIndex = arg1.touchs[arg0].flag
							end)
						end
					end,
					TimelineSelectLoop = function()
						if not var3.selectIndex then
							var1.time = arg0.floatParameter
						end
					end,
					TimelineEnd = function()
						var3.finish = true

						var1:Pause()
					end
				}, function()
					warning("other event trigger:" .. arg0.stringParameter)
				end)

				if var3.finish then
					seriesAsync({
						function(arg0)
							if not arg1.scene then
								return arg0()
							end

							arg0:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0.sceneRootName .. "/" .. arg0.sceneName .. "_scene"), arg0.sceneName, function(arg0, arg1)
								local var0 = _.detect(arg0.sceneDataList, function(arg0)
									return arg0.name == arg0.sceneName
								end)

								SceneOpMgr.Inst:SetActiveSceneByIndex(var0.index)

								local var1 = arg1.scene
								local var2 = arg1.sceneRoot

								arg0:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var2 .. "/" .. var1 .. "_scene"), var1)
								arg0()
							end)
						end,
						function(arg0)
							arg0:RevertCharacter()
							setActive(arg0.mainCameraTF, true)
							arg0:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. arg0.assetRootName .. "/timeline/" .. var1 .. "/" .. var1 .. "_scene"), var1)
							warning(arg0.stringParameter, arg0.timelineCallback)

							local var0 = arg0.timelineCallback

							arg0.timelineCallback = nil

							existCall(var0, var3)
						end
					})
				end
			end)

			if defaultValue(arg0.timelineSpeed, 1) ~= 1 then
				arg0.timelineSpeed = 1

				setDirectorSpeed(var1, arg0.timelineSpeed)
			end

			arg0:HideCharacter()
			setActive(arg0.mainCameraTF, false)
			var1:Play()
		end
	})
end

function var0.PlaySingleAction(arg0, arg1, arg2)
	local var0 = {}

	warning("Play", arg1)

	if not arg0.ladyAnimator:GetCurrentAnimatorStateInfo(0):IsName(arg1) then
		table.insert(var0, function(arg0)
			arg0.nowState = arg1
			arg0.stateCallback = arg0

			arg0.ladyAnimator:CrossFade(arg1, 0.05)
		end)
		table.insert(var0, function(arg0)
			arg0.nowState = nil
			arg0.stateCallback = nil

			arg0()
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.SwitchAnim(arg0, arg1, arg2)
	local var0 = {}

	warning("Switch", arg1)
	table.insert(var0, function(arg0)
		arg0.nowState = arg1
		arg0.stateCallback = arg0

		arg0.ladyAnimator:Play(arg1, 0, 0)
	end)
	table.insert(var0, function(arg0)
		arg0.nowState = nil
		arg0.stateCallback = nil

		arg0()
	end)
	seriesAsync(var0, arg2)
end

function var0.GetCurrentAnimatorStateInfo(arg0)
	return (arg0.ladyAnimator:GetCurrentAnimatorStateInfo(0))
end

function var0.SetCharacterAnimSpeed(arg0, arg1)
	arg0.ladyAnimator.speed = arg1
	arg0.ladyHeadIKComp.blinkSpeed = arg0.ladyHeadIKData.blinkSpeed * arg1

	if arg1 > 0 then
		arg0.ladyHeadIKComp.DampTime = arg0.ladyHeadIKData.DampTime / arg1
	else
		arg0.ladyHeadIKComp.DampTime = arg0.ladyHeadIKData.DampTime * math.huge
	end
end

function var0.OnAnimationEnd(arg0, arg1)
	if arg1.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0 = arg1.stringParameter
	local var1 = table.removebykey(arg0.animCallbacks, var0)

	existCall(var1)
end

function var0.RegisterCallback(arg0, arg1, arg2)
	arg0.animCallbacks[arg1] = arg2
end

function var0.RegisterCameraBlendFinished(arg0, arg1, arg2)
	arg0.cameraBlendCallbacks[arg1] = arg2
end

function var0.UnRegisterCameraBlendFinished(arg0, arg1)
	arg0.cameraBlendCallbacks[arg1] = nil
end

function var0.OnCameraBlendFinished(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = table.removebykey(arg0.cameraBlendCallbacks, arg1)

	existCall(var0)
end

function var0.RegisterGlobalVolume(arg0)
	local var0 = arg0.globalVolume
	local var1 = BLHX.PostEffect.Overrides.DepthOfField
	local var2 = LuaHelper.GetOrAddVolumeComponent(var0, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var3 = LuaHelper.GetOrAddVolumeComponent(var0, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	arg0.originalCameraSettings = {
		depthOfField = {
			enabeld = var2.enabled.value,
			focusDistance = {
				length = 2,
				min = var2.gaussianStart.min,
				value = var2.gaussianStart.value
			},
			blurRadius = {
				min = var2.blurRadius.min,
				max = var2.blurRadius.max,
				value = var2.blurRadius.value
			}
		},
		postExposure = {
			value = var3.postExposure.value
		},
		contrast = {
			min = var3.contrast.min,
			max = var3.contrast.max,
			value = var3.contrast.value
		},
		saturate = {
			min = var3.saturation.min,
			max = var3.saturation.max,
			value = var3.saturation.value
		}
	}
	arg0.originalCameraSettings.depthOfField.enabeld = true

	local var4 = var0:GetComponent(typeof(BLHX.Volume.Volume))

	arg0.originalVolume = {
		profile = var4.sharedProfile,
		weight = var4.weight
	}
end

function var0.SettingCamera(arg0, arg1)
	arg0.activeCameraSettings = arg1

	local var0 = arg0.globalVolume
	local var1 = LuaHelper.GetOrAddVolumeComponent(var0, typeof(BLHX.PostEffect.Overrides.DepthOfField))
	local var2 = LuaHelper.GetOrAddVolumeComponent(var0, typeof(BLHX.PostEffect.Overrides.ColorGrading))

	var1.enabled:Override(arg1.depthOfField.enabeld)
	var1.gaussianStart:Override(arg1.depthOfField.focusDistance.value)
	var1.gaussianEnd:Override(arg1.depthOfField.focusDistance.value + arg1.depthOfField.focusDistance.length)
	var1.blurRadius:Override(arg1.depthOfField.blurRadius.value)
	var2.postExposure:Override(arg1.postExposure.value)
	var2.contrast:Override(arg1.contrast.value)
	var2.saturation:Override(arg1.saturate.value)
end

function var0.GetCameraSettings(arg0)
	return arg0.originalCameraSettings
end

function var0.RevertCameraSettings(arg0)
	arg0:SettingCamera(arg0.originalCameraSettings)

	arg0.activeCameraSettings = nil
end

function var0.SetVolumeProfile(arg0, arg1, arg2)
	warning(arg1, arg2)

	local var0 = arg0.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	arg0.activeProfileWeight = arg2

	if arg0.activeProfileName ~= arg1 then
		arg0.activeProfileName = arg1

		arg0.loader:LoadReference("dorm3d/scenesres/res/common", arg1, nil, function(arg0)
			warning(arg0 and arg0.name or "NIL")

			var0.profile = arg0
			var0.weight = arg0.activeProfileWeight

			if arg0.activeCameraSettings then
				arg0:SettingCamera(arg0.activeCameraSettings)
			end
		end, "VolumeProfile")
	else
		var0.weight = arg0.activeProfileWeight
	end
end

function var0.RevertVolumeProfile(arg0)
	local var0 = arg0.globalVolume:GetComponent(typeof(BLHX.Volume.Volume))

	var0.profile = arg0.originalVolume.profile
	var0.weight = arg0.originalVolume.weight

	if arg0.activeCameraSettings then
		arg0:SettingCamera(arg0.activeCameraSettings)
	end

	arg0.activeProfileName = nil
end

function var0.RecordCharacterLight(arg0)
	local var0 = arg0.characterLight:GetComponent(typeof(Light))

	arg0.originalCharacterColor = {
		color = var0.color,
		intensity = var0.intensity
	}
end

function var0.SetCharacterLight(arg0, arg1, arg2, arg3)
	local var0 = arg0.characterLight:GetComponent(typeof(Light))

	var0.color = Color.Lerp(arg0.originalCharacterColor.color, arg1, arg3)
	var0.intensity = math.lerp(arg0.originalCharacterColor.intensity, arg2, arg3)
end

function var0.RevertCharacterLight(arg0)
	arg0:SetCharacterLight(arg0.originalCharacterColor.color, arg0.originalCharacterColor.intensity, 1)
end

function var0.LoadSceneAsync(arg0, arg1, arg2, arg3)
	table.insert(arg0.sceneDataList, {
		index = 0,
		status = "Loading",
		path = arg1,
		name = arg2
	})
	SceneOpMgr.Inst:LoadSceneAsync(arg1, arg2, LoadSceneMode.Additive, function(arg0, arg1)
		local var0 = _.detect(arg0.sceneDataList, function(arg0)
			return arg0.name == arg2
		end)

		var0.status = "Loaded"
		arg0.sceneCounter = arg0.sceneCounter + 1
		var0.index = arg0.sceneCounter

		existCall(arg3, arg0, arg1)
	end)
end

function var0.UnloadSceneAsync(arg0, arg1, arg2)
	SceneOpMgr.Inst:UnloadSceneAsync(arg1, arg2)

	local var0 = _.detect(arg0.sceneDataList, function(arg0)
		return arg0.name == arg2
	end)
	local var1 = var0.index

	var0.status = "Unloaded"
	arg0.sceneCounter = arg0.sceneCounter - 1
	var0.index = 0

	table.removebyvalue(arg0.sceneDataList, var0)
	_.each(arg0.sceneDataList, function(arg0)
		if arg0.index <= var1 then
			return
		end

		arg0.index = arg0.index - 1
	end)
end

function var0.SwitchLadyInterestInPhotoMode(arg0, arg1)
	if not arg1 then
		arg0:SyncInterestTransform()

		arg0.cameraPhoto.Follow = arg0.ladyInterest
		arg0.cameraPhoto.LookAt = arg0.ladyInterest
	else
		arg0.cameraPhoto.Follow = arg0.ladyInterestRoot
		arg0.cameraPhoto.LookAt = arg0.ladyInterestRoot
	end
end

function var0.SwitchDayNight(arg0, arg1)
	if not arg0.daynightCtrlComp then
		return
	end

	arg0.daynightCtrlComp:SwitcherToIndex(arg1)
end

local var1 = 5
local var2 = 2

function var0.DoRecenter(arg0)
	if arg0.recentTweenId then
		return
	end

	arg0.nextRecentTime = Time.time

	local var0 = arg0.ladyInterest.position - arg0.cameraFree.transform.position
	local var1 = Quaternion.LookRotation(var0).eulerAngles
	local var2 = var1.y
	local var3 = var1.x
	local var4 = arg0.compPov.m_HorizontalAxis.Value
	local var5 = arg0.compPov.m_VerticalAxis.Value
	local var6 = arg0:GetNearestAngle(var2, arg0.compPov.m_HorizontalAxis.m_MinValue, arg0.compPov.m_HorizontalAxis.m_MaxValue)

	arg0.recentTweenId = arg0:managedTween(LeanTween.value, nil, go(arg0.cameraFree), 0, 1, var2):setOnUpdate(System.Action_float(function(arg0)
		local var0 = math.lerp(var4, var6, arg0)
		local var1 = math.lerp(var5, var3, arg0)
		local var2 = arg0.compPov.m_HorizontalAxis

		var2.Value = var0
		arg0.compPov.m_HorizontalAxis = var2

		local var3 = arg0.compPov.m_VerticalAxis

		var3.Value = var1
		arg0.compPov.m_VerticalAxis = var3
	end)):setEase(LeanTweenType.easeOutSine).uniqueId
end

function var0.ResetRecenterTimer(arg0)
	arg0.nextRecentTime = Time.time + var1

	if not arg0.recentTweenId then
		return
	end

	LeanTween.cancel(arg0.recentTweenId)

	arg0.recentTweenId = nil
end

local var3 = 30

function var0.DoRecenterQuick(arg0, arg1)
	if arg0.recentTweenId then
		return
	end

	arg0.nextRecentTime = Time.time

	local var0 = arg0.ladyInterest.position - arg0.cameraFree.transform.position
	local var1 = Quaternion.LookRotation(var0).eulerAngles
	local var2 = var1.y
	local var3 = var1.x
	local var4 = arg0.compPov.m_HorizontalAxis.Value
	local var5 = arg0.compPov.m_VerticalAxis.Value
	local var6 = arg0:GetNearestAngle(var2, arg0.compPov.m_HorizontalAxis.m_MinValue, arg0.compPov.m_HorizontalAxis.m_MaxValue)
	local var7 = math.abs(var6 - var4) / var3

	if var7 < 0.5 then
		return existCall(arg1)
	end

	arg0.recentTweenId = arg0:managedTween(LeanTween.value, arg1, go(arg0.cameraFree), 0, 1, var7):setOnUpdate(System.Action_float(function(arg0)
		local var0 = math.lerp(var4, var6, arg0)
		local var1 = math.lerp(var5, var3, arg0)
		local var2 = arg0.compPov.m_HorizontalAxis

		var2.Value = var0
		arg0.compPov.m_HorizontalAxis = var2

		local var3 = arg0.compPov.m_VerticalAxis

		var3.Value = var1
		arg0.compPov.m_VerticalAxis = var3
	end)):setEase(LeanTweenType.easeOutSine).uniqueId
end

function var0.onBackPressed(arg0)
	if not arg0.baseView or arg0.retainCount > 0 then
		return
	end

	if not arg0.baseView:onBackPressed() then
		arg0:closeView()
	end
end

function var0.willExit(arg0)
	while arg0.baseView:onBackPressed() do
		-- block empty
	end

	arg0.baseView:Destroy()
	arg0.joystickTimer:Stop()
	arg0:ResetRecenterTimer()

	if arg0.moveTimer then
		arg0.moveTimer:Stop()
	end

	GlobalClickEventMgr.Inst:RemoveBeginPinchFunc()
	GlobalClickEventMgr.Inst:RemovePinchFunc()
	GlobalClickEventMgr.Inst:RemoveEndPinchFunc()
	eachChild(arg0.furnitures, function(arg0)
		local var0 = GetComponent(arg0, typeof(EventTriggerListener))

		if not var0 then
			return
		end

		var0:ClearEvents()
	end)
	GetComponent(arg0.lady, typeof(EventTriggerListener)):ClearEvents()

	arg0.camBrainEvenetHandler.OnBlendFinished = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blockLayer, arg0._tf)
	arg0:RemoveCharacter()
	arg0.loader:Clear()
	arg0:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0.sceneRootName .. "/" .. arg0.baseSceneName .. "_scene"), arg0.baseSceneName)
	arg0:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0.sceneRootName .. "/" .. arg0.sceneName .. "_scene"), arg0.sceneName)
end

return var0
