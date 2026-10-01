local var0_0 = class("CarWashScene", import("view.dorm3d.Core.Dorm3dBaseScene"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCarWashUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)

	for iter0_2, iter1_2 in ipairs(Dorm3dHxHelper.GetMaterialResources(arg0_2.contextData.groupId)) do
		table.insert(var0_2, iter1_2)
	end

	return var0_2
end

function var0_0.forceGC(arg0_3)
	return true
end

function var0_0.GetDefaultSystemClasses()
	return CarWashConst.GetDefaultSystemClasses()
end

function var0_0.loadingQueue(arg0_5)
	return function(arg0_6)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_7)
			return arg0_6(arg0_7)
		end)
	end
end

function var0_0.preload(arg0_8, arg1_8)
	arg0_8.sceneInfo = {
		{
			path = "dorm3d/scenesres/scenes/carwash/map_carwash_01_scene",
			name = "map_carwash_01"
		},
		{
			path = "dorm3d/scenesres/scenes/carwash/carwash_gameplay_scene",
			name = "carwash_gameplay"
		}
	}
	arg0_8.loader = AutoLoader.New()
	arg0_8.hxHelper = Dorm3dHxHelper.New(arg0_8.loader)

	seriesAsync({
		function(arg0_9)
			arg0_8.hxHelper:LoadMaterials(arg0_8.contextData.groupId, arg0_9)
		end,
		function(arg0_10)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_8.sceneInfo[1].path, arg0_8.sceneInfo[1].name, LoadSceneMode.Additive, function(arg0_11, arg1_11)
				SceneManager.SetActiveScene(arg0_11)
				arg0_10()
			end)
		end,
		function(arg0_12)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_8.sceneInfo[2].path, arg0_8.sceneInfo[2].name, LoadSceneMode.Additive, function(arg0_13, arg1_13)
				arg0_12()
			end)
		end,
		function(arg0_14)
			local var0_14 = pg.dorm3d_carwash[arg0_8.contextData.groupId].character_prefab

			arg0_8.loader:GetPrefab(var0_14, "", function(arg0_15)
				arg0_8.ladyGO = arg0_15

				arg0_14()
			end)
		end
	}, arg1_8)
end

function var0_0.willExit(arg0_16)
	var0_0.super.willExit(arg0_16)

	if arg0_16.updateHandler then
		UpdateBeat:RemoveListener(arg0_16.updateHandler)

		arg0_16.updateHandler = nil
	end

	arg0_16.loader:Clear()

	arg0_16.hxHelper = nil

	local var0_16 = underscore.map(arg0_16.sceneInfo, function(arg0_17)
		return function(arg0_18)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_17.path, arg0_17.name, arg0_18)
		end
	end)

	seriesAsync(var0_16, function()
		return
	end)
end

function var0_0.init(arg0_20)
	arg0_20:InitSceneRefs()
	arg0_20:InitExtraSystem({
		CarWashGameFlowSystem
	})
	arg0_20:InitPage()
	arg0_20:InitExtraSystem(CarWashConst.GetGameplaySystemClasses())
	arg0_20:InitHX()
end

function var0_0.InitHX(arg0_21)
	arg0_21.holyLightRoot = arg0_21._tf:Find("HolyLightRoot")

	arg0_21.hxHelper:Apply(arg0_21.ladyGO.transform)
	Dorm3dHxHelper.HideCharacterPart(arg0_21.ladyGO.transform, nil, true)
	Dorm3dHxHelper.ShowHolyLight({
		arg0_21.ladyGO.transform
	}, arg0_21.holyLightRoot, true)
end

function var0_0.InitPage(arg0_22)
	arg0_22.mainPage = CarWashMainPage.New(arg0_22._tf, arg0_22.event, arg0_22.contextData)
	arg0_22.gamePage = CarWashGamePage.New(arg0_22._tf:Find("game"), arg0_22.event, arg0_22.contextData)
	arg0_22.phase2Page = CarWashPhase2Page.New(arg0_22._tf:Find("phase2"), arg0_22.event, arg0_22.contextData)
	arg0_22.endPage = CarWashEndPage.New(arg0_22._tf:Find("end"), arg0_22.event, arg0_22.contextData)
end

function var0_0.InitSceneRefs(arg0_23)
	setActive(GameObject.Find("Camera"), false)

	arg0_23.mainCameraGO = GameObject.Find("BackYardMainCamera")
	arg0_23.mainCameraTF = arg0_23.mainCameraGO.transform
	arg0_23.mainCamera = arg0_23.mainCameraGO:GetComponent(typeof(Camera))
	arg0_23.cameraRoot = GameObject.Find("CM Cameras").transform
	arg0_23.raycastCamera = arg0_23.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_23.sceneRaycaster = arg0_23.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
end

function var0_0.didEnter(arg0_24)
	arg0_24:emit(CarWashGameFlowSystem.START_GAME, function()
		arg0_24:StartUpdate()
	end)
end

function var0_0.StartUpdate(arg0_26)
	if arg0_26.updateHandler then
		return
	end

	arg0_26.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_26:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_26.updateHandler)
end

function var0_0.Update(arg0_30)
	if arg0_30.exited then
		return
	end

	if arg0_30.systemManager then
		arg0_30.systemManager:Update(Time.deltaTime)
	end
end

return var0_0
