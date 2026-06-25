local var0_0 = class("CarWashScene", import("view.dorm3d.Core.Dorm3dBaseScene"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCarWashUI"
end

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.GetDefaultSystemClasses()
	return CarWashConst.GetDefaultSystemClasses()
end

function var0_0.loadingQueue(arg0_4)
	return function(arg0_5)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_6)
			return arg0_5(arg0_6)
		end)
	end
end

function var0_0.preload(arg0_7, arg1_7)
	arg0_7.sceneInfo = {
		{
			path = "dorm3d/scenesres/scenes/carwash/map_carwash_01_scene",
			name = "map_carwash_01"
		},
		{
			path = "dorm3d/scenesres/scenes/carwash/carwash_gameplay_scene",
			name = "carwash_gameplay"
		}
	}
	arg0_7.loader = AutoLoader.New()

	seriesAsync({
		function(arg0_8)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_7.sceneInfo[1].path, arg0_7.sceneInfo[1].name, LoadSceneMode.Additive, function(arg0_9, arg1_9)
				SceneManager.SetActiveScene(arg0_9)
				arg0_8()
			end)
		end,
		function(arg0_10)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_7.sceneInfo[2].path, arg0_7.sceneInfo[2].name, LoadSceneMode.Additive, function(arg0_11, arg1_11)
				arg0_10()
			end)
		end,
		function(arg0_12)
			local var0_12 = pg.dorm3d_carwash[arg0_7.contextData.groupId].character_prefab

			arg0_7.loader:GetPrefab(var0_12, "", function(arg0_13)
				arg0_7.ladyGO = arg0_13

				arg0_12()
			end)
		end
	}, arg1_7)
end

function var0_0.willExit(arg0_14)
	var0_0.super.willExit(arg0_14)

	if arg0_14.updateHandler then
		UpdateBeat:RemoveListener(arg0_14.updateHandler)

		arg0_14.updateHandler = nil
	end

	arg0_14.loader:Clear()

	local var0_14 = underscore.map(arg0_14.sceneInfo, function(arg0_15)
		return function(arg0_16)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_15.path, arg0_15.name, arg0_16)
		end
	end)

	seriesAsync(var0_14, function()
		return
	end)
end

function var0_0.init(arg0_18)
	arg0_18:InitSceneRefs()
	arg0_18:InitExtraSystem({
		CarWashGameFlowSystem
	})
	arg0_18:InitPage()
	arg0_18:InitExtraSystem(CarWashConst.GetGameplaySystemClasses())
	arg0_18:InitHX()
end

function var0_0.InitHX(arg0_19)
	arg0_19.holyLightRoot = arg0_19._tf:Find("HolyLightRoot")

	Dorm3dHxHelper.ReplaceCharacterParts(arg0_19.ladyGO.transform)
	Dorm3dHxHelper.HideCharacterPart(arg0_19.ladyGO.transform, nil, true)
	Dorm3dHxHelper.ShowHolyLight({
		arg0_19.ladyGO.transform
	}, arg0_19.holyLightRoot, true)
end

function var0_0.InitPage(arg0_20)
	arg0_20.mainPage = CarWashMainPage.New(arg0_20._tf, arg0_20.event, arg0_20.contextData)
	arg0_20.gamePage = CarWashGamePage.New(arg0_20._tf:Find("game"), arg0_20.event, arg0_20.contextData)
	arg0_20.phase2Page = CarWashPhase2Page.New(arg0_20._tf:Find("phase2"), arg0_20.event, arg0_20.contextData)
	arg0_20.endPage = CarWashEndPage.New(arg0_20._tf:Find("end"), arg0_20.event, arg0_20.contextData)
end

function var0_0.InitSceneRefs(arg0_21)
	setActive(GameObject.Find("Camera"), false)

	arg0_21.mainCameraGO = GameObject.Find("BackYardMainCamera")
	arg0_21.mainCameraTF = arg0_21.mainCameraGO.transform
	arg0_21.mainCamera = arg0_21.mainCameraGO:GetComponent(typeof(Camera))
	arg0_21.cameraRoot = GameObject.Find("CM Cameras").transform
	arg0_21.raycastCamera = arg0_21.mainCameraTF:Find("CameraForRaycast"):GetComponent(typeof(Camera))
	arg0_21.sceneRaycaster = arg0_21.raycastCamera:GetComponent(typeof(UnityEngine.EventSystems.PhysicsRaycaster))
end

function var0_0.didEnter(arg0_22)
	arg0_22:emit(CarWashGameFlowSystem.START_GAME, function()
		arg0_22:StartUpdate()
	end)
end

function var0_0.StartUpdate(arg0_24)
	if arg0_24.updateHandler then
		return
	end

	arg0_24.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_24:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_24.updateHandler)
end

function var0_0.Update(arg0_28)
	if arg0_28.exited then
		return
	end

	if arg0_28.systemManager then
		arg0_28.systemManager:Update(Time.deltaTime)
	end
end

return var0_0
