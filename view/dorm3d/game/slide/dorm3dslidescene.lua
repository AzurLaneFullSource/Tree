local var0_0 = class("Dorm3dSlideScene", import("view.dorm3d.Game.Dorm3dGameTemplate"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dSlideUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.groupId

	arg0_2:SetApartment(getProxy(ApartmentProxy):getApartment(var0_2))

	arg0_2.sceneRootName = "beach"
	arg0_2.sceneName = "beach_01"
	arg0_2.sceneInfo = {
		{
			path = string.lower("dorm3d/scenesres/scenes/" .. arg0_2.sceneRootName .. "/" .. arg0_2.sceneName .. "_scene"),
			name = arg0_2.sceneName
		},
		{
			path = string.lower("dorm3d/character/" .. arg0_2.timelineSceneRootName .. "/timeline/" .. arg0_2.timelineSceneName .. "/" .. arg0_2.timelineSceneName .. "_scene"),
			name = arg0_2.timelineSceneName
		}
	}

	seriesAsync({
		function(arg0_3)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_2.sceneInfo[1].path, arg0_2.sceneInfo[1].name, LoadSceneMode.Additive, function(arg0_4, arg1_4)
				SceneManager.SetActiveScene(arg0_4)
				arg0_3()
			end)
		end,
		function(arg0_5)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_2.sceneInfo[2].path, arg0_2.sceneInfo[2].name, LoadSceneMode.Additive, function(arg0_6, arg1_6)
				arg0_5()
			end)
		end
	}, arg1_2)
end

function var0_0.init(arg0_7)
	arg0_7:InitScene()
	arg0_7:InitUI()
end

function var0_0.InitUI(arg0_8)
	return
end

function var0_0.InitScene(arg0_9)
	local var0_9 = SceneManager.GetSceneByName(arg0_9.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_9, function(arg0_10, arg1_10)
		return
	end)

	local var1_9 = SceneManager.GetSceneByName(arg0_9.timelineSceneName):GetRootGameObjects()

	table.IpairsCArray(var1_9, function(arg0_11, arg1_11)
		return
	end)
end

function var0_0.didEnter(arg0_12)
	return
end

function var0_0.willExit(arg0_13)
	local var0_13 = underscore.map(arg0_13.sceneInfo, function(arg0_14)
		return function(arg0_15)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_14.path, arg0_14.name, arg0_15)
		end
	end)

	seriesAsync(var0_13, function()
		return
	end)
end

return var0_0
