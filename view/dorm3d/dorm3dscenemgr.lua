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

				local var0_13 = GameObject.Find("[camera]").transform:GetComponentInChildren(typeof(Camera))

				setActive(var0_13, false)
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
	local var1_17
	local var2_17 = arg0_17.artSceneInfo

	table.insert(var0_17, function(arg0_18)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_19)
			var1_17 = arg0_19

			arg0_18()
		end)
	end)

	local var3_17, var4_17 = var0_0.ParseInfo(arg1_17)

	table.insert(var0_17, function(arg0_20)
		SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_17 .. "/" .. var3_17 .. "_scene"), var3_17, LoadSceneMode.Additive, function(arg0_21, arg1_21)
			SceneManager.SetActiveScene(arg0_21)

			local var0_21 = getSceneRootTFDic(arg0_21).MainCamera

			if var0_21 then
				setActive(var0_21, false)
			end

			arg0_20()
		end)
	end)

	local var5_17, var6_17 = var0_0.ParseInfo(var2_17)

	table.insert(var0_17, function(arg0_22)
		SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var6_17 .. "/" .. var5_17 .. "_scene"), var5_17, arg0_22)
	end)
	table.insert(var0_17, function(arg0_23)
		arg0_17.artSceneInfo = arg1_17

		arg0_23()
	end)
	seriesAsync(var0_17, function()
		existCall(arg2_17)
		existCall(var1_17)
	end)
end

function var0_0.ChangeSubScene(arg0_25, arg1_25, arg2_25)
	if var0_0.IsSameSceneInfo(arg1_25, arg0_25.subSceneInfo) then
		return existCall(arg2_25)
	end

	local var0_25 = {}
	local var1_25 = false
	local var2_25

	if not var0_0.IsSameSceneInfo(arg1_25, arg0_25.sceneInfo) then
		var1_25 = true

		table.insert(var0_25, function(arg0_26)
			pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_27)
				var2_25 = arg0_27

				arg0_26()
			end)
		end)

		local var3_25, var4_25 = var0_0.ParseInfo(arg1_25)
		local var5_25 = var3_25 .. "_base"

		table.insert(var0_25, function(arg0_28)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_25 .. "/" .. var5_25 .. "_scene"), var5_25, LoadSceneMode.Additive, arg0_28)
		end)
	end

	if not var0_0.IsSameSceneInfo(arg0_25.subSceneInfo, arg0_25.sceneInfo) then
		local var6_25, var7_25 = var0_0.ParseInfo(arg0_25.subSceneInfo)
		local var8_25 = var6_25 .. "_base"

		table.insert(var0_25, function(arg0_29)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var7_25 .. "/" .. var8_25 .. "_scene"), var8_25, arg0_29)
		end)
	end

	table.insert(var0_25, function(arg0_30)
		arg0_25.subSceneInfo = arg1_25

		arg0_30()

		if var1_25 then
			var2_25()
		end
	end)
	seriesAsync(var0_25, arg2_25)
end

function var0_0.Dispose(arg0_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in pairs(arg0_31.cacheSceneDic) do
		if iter1_31 then
			local var1_31 = iter1_31.assetRootName

			table.insert(var0_31, function(arg0_32)
				SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/character/scenes/" .. var1_31 .. "/timeline/" .. iter0_31 .. "/" .. iter0_31 .. "_scene"), iter0_31, arg0_32)
			end)
		end
	end

	local var2_31 = {
		arg0_31.sceneInfo
	}

	if not var0_0.IsSameSceneInfo(arg0_31.subSceneInfo, arg0_31.sceneInfo) then
		table.insert(var2_31, arg0_31.subSceneInfo)
	end

	for iter2_31, iter3_31 in ipairs(var2_31) do
		local var3_31, var4_31 = var0_0.ParseInfo(iter3_31)
		local var5_31 = var3_31 .. "_base"

		table.insert(var0_31, function(arg0_33)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var4_31 .. "/" .. var5_31 .. "_scene"), var5_31, arg0_33)
		end)
	end

	local var6_31 = {
		arg0_31.sceneInfo
	}

	if not var0_0.IsSameSceneInfo(arg0_31.artSceneInfo, arg0_31.sceneInfo) then
		table.insert(var6_31, arg0_31.artSceneInfo)
	end

	for iter4_31, iter5_31 in ipairs(var6_31) do
		local var7_31, var8_31 = var0_0.ParseInfo(iter5_31)

		table.insert(var0_31, function(arg0_34)
			SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var8_31 .. "/" .. var7_31 .. "_scene"), var7_31, arg0_34)
		end)
	end

	seriesAsync(var0_31, function()
		arg0_31.sceneInfo = nil
		arg0_31.artSceneInfo = nil
		arg0_31.subSceneInfo = nil
		arg0_31.lastSceneRootDict = nil
		arg0_31.cacheSceneDic = nil

		print("unload scene finish !")
	end)
end

function var0_0.IsSameSceneInfo(arg0_36, arg1_36)
	return string.lower(arg0_36) == string.lower(arg1_36)
end

return var0_0
