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
				TimelineSupport.InitTimeline(var0_13)
				TimelineSupport.InitSubtitle(var0_13, arg1_9.callName)

				arg1_9.unloadDirector = var0_13

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

		if var0_15.unloadDirector then
			TimelineSupport.UnloadPlayable(var0_15.unloadDirector)
		end

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
	if arg1_17 == arg0_17.artSceneInfo then
		existCall(arg2_17)

		return
	end

	local var0_17 = {}
	local var1_17 = false
	local var2_17

	if arg1_17 == arg0_17.sceneInfo then
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

	if arg0_17.artSceneInfo == arg0_17.sceneInfo then
		table.insert(var0_17, function(arg0_23)
			local var0_23, var1_23 = var0_0.ParseInfo(arg0_17.sceneInfo)

			arg0_17:EnableSceneDisplay(var0_23, false)
			arg0_23()
		end)
	else
		local var5_17, var6_17 = var0_0.ParseInfo(arg0_17.artSceneInfo)

		table.insert(var0_17, function(arg0_24)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_17 .. "/" .. var5_17 .. "_scene"), var5_17, arg0_24)
		end)
	end

	table.insert(var0_17, function(arg0_25)
		arg0_25()

		if var1_17 then
			var2_17()
		end
	end)

	arg0_17.artSceneInfo = arg1_17

	seriesAsync(var0_17, arg2_17)
end

function var0_0.ChangeSubScene(arg0_26, arg1_26, arg2_26)
	arg1_26 = string.lower(arg1_26)

	warning(arg0_26.subSceneInfo, "->", arg1_26, arg1_26 == arg0_26.subSceneInfo)

	if arg1_26 == arg0_26.subSceneInfo then
		return existCall(arg2_26)
	end

	local var0_26 = {}
	local var1_26 = false
	local var2_26

	if arg1_26 ~= arg0_26.sceneInfo then
		var1_26 = true

		table.insert(var0_26, function(arg0_27)
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_28)
				var2_26 = arg0_28

				arg0_27()
			end)
		end)

		local var3_26, var4_26 = var0_0.ParseInfo(arg1_26)
		local var5_26 = var3_26 .. "_base"

		table.insert(var0_26, function(arg0_29)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_26 .. "/" .. var5_26 .. "_scene"), var5_26, LoadSceneMode.Additive, arg0_29)
		end)
	end

	if arg0_26.subSceneInfo ~= arg0_26.sceneInfo then
		local var6_26, var7_26 = var0_0.ParseInfo(arg0_26.subSceneInfo)
		local var8_26 = var6_26 .. "_base"

		table.insert(var0_26, function(arg0_30)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_26 .. "/" .. var8_26 .. "_scene"), var8_26, arg0_30)
		end)
	end

	table.insert(var0_26, function(arg0_31)
		arg0_31()

		if var1_26 then
			var2_26()
		end
	end)

	arg0_26.subSceneInfo = arg1_26

	seriesAsync(var0_26, arg2_26)
end

function var0_0.Dispose(arg0_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.cacheSceneDic) do
		if iter1_32 then
			local var1_32 = iter1_32.assetRootName

			table.insert(var0_32, function(arg0_33)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var1_32 .. "/timeline/" .. iter0_32 .. "/" .. iter0_32 .. "_scene"), iter0_32, arg0_33)
			end)
		end
	end

	local var2_32 = {
		arg0_32.sceneInfo
	}

	if arg0_32.subSceneInfo ~= arg0_32.sceneInfo then
		table.insert(var2_32, arg0_32.subSceneInfo)
	end

	for iter2_32, iter3_32 in ipairs(var2_32) do
		local var3_32, var4_32 = var0_0.ParseInfo(iter3_32)
		local var5_32 = var3_32 .. "_base"

		table.insert(var0_32, function(arg0_34)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_32 .. "/" .. var5_32 .. "_scene"), var5_32, arg0_34)
		end)
	end

	local var6_32 = {
		arg0_32.sceneInfo
	}

	if arg0_32.artSceneInfo ~= arg0_32.sceneInfo then
		table.insert(var6_32, arg0_32.artSceneInfo)
	end

	for iter4_32, iter5_32 in ipairs(var6_32) do
		local var7_32, var8_32 = var0_0.ParseInfo(iter5_32)

		table.insert(var0_32, function(arg0_35)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_32 .. "/" .. var7_32 .. "_scene"), var7_32, arg0_35)
		end)
	end

	seriesAsync(var0_32, function()
		arg0_32.sceneInfo = nil
		arg0_32.artSceneInfo = nil
		arg0_32.subSceneInfo = nil
		arg0_32.lastSceneRootDict = nil
		arg0_32.cacheSceneDic = nil

		print("unload scene finish !")
	end)
end

return var0_0
