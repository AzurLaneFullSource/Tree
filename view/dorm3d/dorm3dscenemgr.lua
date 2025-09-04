local var0_0 = class("Dorm3dSceneMgr")

function var0_0.ParseInfo(arg0_1)
	return unpack(string.split(arg0_1, "|"))
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2.sceneInfo = arg1_2
	arg0_2.artSceneInfo = arg0_2.sceneInfo
	arg0_2.subSceneInfo = arg0_2.sceneInfo
	arg0_2.lastSceneRootDict = {}
	arg0_2.cacheSceneDic = {}

	local var0_2, var1_2 = var0_0.ParseInfo(arg0_2.sceneInfo)
	local var2_2 = {
		function(arg0_3)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_2 .. "/" .. var0_2 .. "_scene"), var0_2, LoadSceneMode.Additive, function(arg0_4, arg1_4)
				arg0_2.originArtScene = arg0_4

				SceneManager.SetActiveScene(arg0_4)

				local var0_4 = getSceneRootTFDic(arg0_4).MainCamera

				if var0_4 then
					setActive(var0_4, false)
				end

				arg0_3()
			end)
		end,
		function(arg0_5)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_2 .. "/" .. var0_2 .. "_base_scene"), var0_2 .. "_base", LoadSceneMode.Additive, arg0_5)
		end
	}

	seriesAsync(var2_2, arg2_2)
end

function var0_0.EnableSceneDisplay(arg0_6, arg1_6, arg2_6)
	assert(tobool(arg0_6.lastSceneRootDict[arg1_6]) == arg2_6)

	if arg2_6 then
		table.Foreach(arg0_6.lastSceneRootDict[arg1_6], function(arg0_7, arg1_7)
			if IsNil(arg0_7) then
				return
			end

			setActive(arg0_7, arg1_7)
		end)

		arg0_6.lastSceneRootDict[arg1_6] = nil
	else
		arg0_6.lastSceneRootDict[arg1_6] = {}

		local var0_6 = SceneManager.GetSceneByName(arg1_6)

		table.IpairsCArray(var0_6:GetRootGameObjects(), function(arg0_8, arg1_8)
			if tostring(arg1_8.hideFlags) ~= "None" then
				return
			end

			arg0_6.lastSceneRootDict[arg1_6][arg1_8] = isActive(arg1_8)

			setActive(arg1_8, false)
		end)
	end
end

function var0_0.LoadTimelineScene(arg0_9, arg1_9, arg2_9)
	local var0_9 = {}
	local var1_9

	if not arg0_9.cacheSceneDic[arg1_9.name] then
		arg0_9.cacheSceneDic[arg1_9.name] = arg1_9

		table.insert(var0_9, function(arg0_10)
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_11)
				if arg1_9.waitForTimeline then
					arg1_9.waitForTimeline(arg0_11)
				else
					var1_9 = arg0_11
				end

				arg0_10()
			end)
		end)
		table.insert(var0_9, function(arg0_12)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. arg1_9.assetRootName .. "/timeline/" .. arg1_9.name .. "/" .. arg1_9.name .. "_scene"), arg1_9.name, LoadSceneMode.Additive, function(arg0_13, arg1_13)
				existCall(arg1_9.loadSceneFunc, arg0_13, arg1_13)

				local var0_13 = GameObject.Find("[sequence]").transform:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

				var0_13:Stop()

				local var1_13 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera))

				setActive(var1_13, false)
				TimelineSupport.InitTimeline(var0_13)
				TimelineSupport.InitSubtitle(var0_13, arg1_9.callName)
				arg0_12()
			end)
		end)
	end

	table.insert(var0_9, function(arg0_14)
		if tobool(arg0_9.lastSceneRootDict[arg1_9.name]) ~= tobool(arg1_9.isCache) then
			arg0_9:EnableSceneDisplay(arg1_9.name, not arg1_9.isCache)
		end

		arg0_14()
		existCall(var1_9)
	end)
	seriesAsync(var0_9, arg2_9)
end

function var0_0.UnloadTimelineScene(arg0_15, arg1_15, arg2_15, arg3_15)
	assert(arg0_15.cacheSceneDic[arg1_15])

	local var0_15 = arg0_15.cacheSceneDic[arg1_15]

	if tobool(arg2_15) == tobool(var0_15.isCache) then
		local var1_15 = var0_15.assetRootName

		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var1_15 .. "/timeline/" .. arg1_15 .. "/" .. arg1_15 .. "_scene"), arg1_15, function()
			arg0_15.cacheSceneDic[arg1_15] = nil
			arg0_15.lastSceneRootDict[arg1_15] = nil

			existCall(arg3_15)
		end)
	else
		arg0_15:EnableSceneDisplay(arg1_15, false)
		existCall(arg3_15)
	end
end

function var0_0.ChangeArtScene(arg0_17, arg1_17, arg2_17)
	if var0_0.IsSameSceneInfo(arg1_17, arg0_17.artSceneInfo) then
		existCall(arg2_17)

		return
	end

	local var0_17 = {}
	local var1_17 = false
	local var2_17

	if var0_0.IsSameSceneInfo(arg1_17, arg0_17.sceneInfo) then
		table.insert(var0_17, function(arg0_18)
			local var0_18, var1_18 = var0_0.ParseInfo(arg0_17.sceneInfo)

			SceneManager.SetActiveScene(SceneManager.GetSceneByName(var0_18))
			arg0_17:EnableSceneDisplay(var0_18, true)
			arg0_18()
		end)
	else
		var1_17 = true

		table.insert(var0_17, function(arg0_19)
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_20)
				var2_17 = arg0_20

				arg0_19()
			end)
		end)

		local var3_17, var4_17 = var0_0.ParseInfo(arg1_17)

		table.insert(var0_17, function(arg0_21)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_17 .. "/" .. var3_17 .. "_scene"), var3_17, LoadSceneMode.Additive, function(arg0_22, arg1_22)
				SceneManager.SetActiveScene(arg0_22)

				local var0_22 = getSceneRootTFDic(arg0_22).MainCamera

				if var0_22 then
					setActive(var0_22, false)
				end

				arg0_21()
			end)
		end)
	end

	if var0_0.IsSameSceneInfo(arg0_17.artSceneInfo, arg0_17.sceneInfo) then
		table.insert(var0_17, function(arg0_23)
			local var0_23, var1_23 = var0_0.ParseInfo(arg0_17.sceneInfo)

			arg0_17:EnableSceneDisplay(var0_23, false)
			arg0_23()
		end)
	else
		local var5_17, var6_17 = var0_0.ParseInfo(arg0_17.artSceneInfo)

		table.insert(var0_17, function(arg0_24)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_17 .. "/" .. var5_17 .. "_scene"), var5_17, function()
				HotfixHelper.FixLightMapStorageByScene(arg0_17.originArtScene)
				existCall(arg0_24)
			end)
		end)
	end

	table.insert(var0_17, function(arg0_26)
		arg0_26()

		if var1_17 then
			HotfixHelper.FixLightMapStorageByScene(arg0_17.originArtScene)
			var2_17()
		end
	end)

	arg0_17.artSceneInfo = arg1_17

	seriesAsync(var0_17, arg2_17)
end

function var0_0.ChangeSubScene(arg0_27, arg1_27, arg2_27)
	if var0_0.IsSameSceneInfo(arg1_27, arg0_27.subSceneInfo) then
		return existCall(arg2_27)
	end

	local var0_27 = {}
	local var1_27 = false
	local var2_27

	if not var0_0.IsSameSceneInfo(arg1_27, arg0_27.sceneInfo) then
		var1_27 = true

		table.insert(var0_27, function(arg0_28)
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_29)
				var2_27 = arg0_29

				arg0_28()
			end)
		end)

		local var3_27, var4_27 = var0_0.ParseInfo(arg1_27)
		local var5_27 = var3_27 .. "_base"

		table.insert(var0_27, function(arg0_30)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_27 .. "/" .. var5_27 .. "_scene"), var5_27, LoadSceneMode.Additive, arg0_30)
		end)
	end

	if not var0_0.IsSameSceneInfo(arg0_27.subSceneInfo, arg0_27.sceneInfo) then
		local var6_27, var7_27 = var0_0.ParseInfo(arg0_27.subSceneInfo)
		local var8_27 = var6_27 .. "_base"

		table.insert(var0_27, function(arg0_31)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_27 .. "/" .. var8_27 .. "_scene"), var8_27, arg0_31)
		end)
	end

	table.insert(var0_27, function(arg0_32)
		arg0_32()

		if var1_27 then
			var2_27()
		end
	end)

	arg0_27.subSceneInfo = arg1_27

	seriesAsync(var0_27, arg2_27)
end

function var0_0.Dispose(arg0_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.cacheSceneDic) do
		if iter1_33 then
			local var1_33 = iter1_33.assetRootName

			table.insert(var0_33, function(arg0_34)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var1_33 .. "/timeline/" .. iter0_33 .. "/" .. iter0_33 .. "_scene"), iter0_33, arg0_34)
			end)
		end
	end

	local var2_33 = {
		arg0_33.sceneInfo
	}

	if not var0_0.IsSameSceneInfo(arg0_33.subSceneInfo, arg0_33.sceneInfo) then
		table.insert(var2_33, arg0_33.subSceneInfo)
	end

	for iter2_33, iter3_33 in ipairs(var2_33) do
		local var3_33, var4_33 = var0_0.ParseInfo(iter3_33)
		local var5_33 = var3_33 .. "_base"

		table.insert(var0_33, function(arg0_35)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_33 .. "/" .. var5_33 .. "_scene"), var5_33, arg0_35)
		end)
	end

	local var6_33 = {
		arg0_33.sceneInfo
	}

	if not var0_0.IsSameSceneInfo(arg0_33.artSceneInfo, arg0_33.sceneInfo) then
		table.insert(var6_33, arg0_33.artSceneInfo)
	end

	for iter4_33, iter5_33 in ipairs(var6_33) do
		local var7_33, var8_33 = var0_0.ParseInfo(iter5_33)

		table.insert(var0_33, function(arg0_36)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_33 .. "/" .. var7_33 .. "_scene"), var7_33, arg0_36)
		end)
	end

	seriesAsync(var0_33, function()
		arg0_33.sceneInfo = nil
		arg0_33.artSceneInfo = nil
		arg0_33.subSceneInfo = nil
		arg0_33.lastSceneRootDict = nil
		arg0_33.cacheSceneDic = nil

		print("unload scene finish !")
	end)
end

function var0_0.IsSameSceneInfo(arg0_38, arg1_38)
	return string.lower(arg0_38) == string.lower(arg1_38)
end

return var0_0
