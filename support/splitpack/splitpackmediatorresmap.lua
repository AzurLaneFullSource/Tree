local var0_0 = {}

SplitPackMediatorResMap = var0_0

function var0_0.TryGetList(arg0_1)
	local var0_1 = var0_0.TryGetConfigList(arg0_1)
	local var1_1 = var0_0.TryGetLogicList(arg0_1)

	return (var0_0.MergeLuaArr(var0_1, var1_1))
end

function var0_0.GetUIPreloadList(arg0_2)
	local var0_2 = arg0_2.context.viewComponent:preloadUIList()

	return (_.map(var0_2, function(arg0_3)
		return "ui/" .. arg0_3
	end))
end

function var0_0.GetBGMList(arg0_4)
	local var0_4 = arg0_4.context.viewComponent:getBGM()

	if var0_4 then
		return {
			"cue/bgm-" .. var0_4 .. ".b"
		}
	end

	return {}
end

function var0_0.TryGetConfigList(arg0_5)
	local var0_5 = arg0_5.context.viewComponent
	local var1_5 = arg0_5.context.mediator
	local var2_5 = var0_5.__cname
	local var3_5 = var1_5.__cname
	local var4_5 = pg.split_pack_config[var3_5]
	local var5_5 = {}

	if var4_5 then
		var5_5 = var4_5.res_list
	end

	local var6_5 = pg.split_pack_config[var2_5]
	local var7_5 = {}

	if var6_5 then
		var7_5 = var6_5.res_list
	end

	return (var0_0.MergeLuaArr(var5_5, var7_5))
end

function var0_0.TryGetLogicList(arg0_6)
	local var0_6 = arg0_6.context.viewComponent
	local var1_6 = arg0_6.context.mediator
	local var2_6 = var0_6.__cname
	local var3_6 = var1_6.__cname
	local var4_6 = var0_0.LogicMap[var3_6]
	local var5_6 = {}

	if var4_6 and type(var4_6) == "function" then
		var5_6 = var4_6(arg0_6)
	end

	local var6_6 = var0_0.LogicMap[var2_6]
	local var7_6 = {}

	if var6_6 and type(var6_6) == "function" then
		var7_6 = var6_6(arg0_6)
	end

	local var8_6 = {}
	local var9_6 = var0_6.getResource

	if var9_6 and type(var9_6) == "function" then
		var8_6 = var9_6(var0_6)
	end

	return (var0_0.MergeLuaArr(var5_6, var7_6, var8_6))
end

function var0_0.MergeLuaArr(...)
	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs({
		...
	}) do
		if iter1_7 then
			for iter2_7 = 1, #iter1_7 do
				var0_7[#var0_7 + 1] = iter1_7[iter2_7]
			end
		end
	end

	return var0_7
end

var0_0.LogicMap = {}

function var0_0.LogicMap.LoginScene(arg0_8)
	local var0_8 = var0_0.GetUIPreloadList(arg0_8)
	local var1_8 = var0_0.GetBGMList(arg0_8)
	local var2_8, var3_8, var4_8, var5_8, var6_8 = getLoginConfig()
	local var7_8 = {
		"effect/" .. var3_8,
		"loadingbg_hx/" .. var3_8,
		"loadingbg/" .. var3_8
	}

	if var4_8 and var4_8 ~= "" then
		local var8_8 = "cue/bgm-" .. var4_8 .. ".b"

		table.insert(var7_8, var8_8)
	end

	return (var0_0.MergeLuaArr(var7_8, var0_8, var1_8))
end

function var0_0.LogicMap.CombatLoadUI(arg0_9)
	local var0_9 = var0_0.GetUIPreloadList(arg0_9)
	local var1_9 = var0_0.GetBGMList(arg0_9)
	local var2_9 = CombatLoadUI.EnsureBaseBGList()
	local var3_9 = {}
	local var4_9, var5_9, var6_9 = CombatLoadUI.GetTotalResourceList(arg0_9.context.data)

	if var4_9 and #var4_9 > 0 then
		for iter0_9, iter1_9 in ipairs(var4_9) do
			iter1_9 = string.lower(iter1_9)

			table.insert(var3_9, iter1_9)
		end
	end

	return (var0_0.MergeLuaArr(var0_9, var1_9, var2_9, var3_9, var6_9))
end

function var0_0.LogicMap.BattleScene(arg0_10)
	local var0_10 = var0_0.GetUIPreloadList(arg0_10)
	local var1_10 = {}
	local var2_10
	local var3_10 = arg0_10.context.data

	table.insert(var1_10, var3_10.system == SYSTEM_WORLD and checkExist(pg.world_expedition_data[var3_10.stageId], {
		"bgm"
	}) or "")
	table.insert(var1_10, pg.expedition_data_template[var3_10.stageId].bgm)

	for iter0_10, iter1_10 in ipairs(var1_10) do
		if iter1_10 ~= "" then
			var2_10 = iter1_10

			break
		end
	end

	if #var1_10 == 0 then
		var2_10 = getBGM(arg0_10.context.viewComponent.__cname)
	end

	if var2_10 then
		local var4_10 = "cue/bgm-" .. var2_10 .. ".b"

		var1_10 = {
			var4_10
		}
	end

	return (var0_0.MergeLuaArr(var0_10, var1_10))
end

function var0_0.LogicMap.NewPlayerScene(arg0_11)
	local var0_11 = var0_0.GetUIPreloadList(arg0_11)
	local var1_11 = var0_0.GetBGMList(arg0_11)
	local var2_11 = {}
	local var3_11 = {}
	local var4_11 = {}
	local var5_11 = {
		101171,
		201211,
		401231
	}

	_.each(var5_11, function(arg0_12)
		PaintingGroupConst.AddPaintingNameByShipConfigID(var2_11, arg0_12)

		local var0_12 = pg.ship_data_template[arg0_12]

		_.each(var0_12.buff_list_display, function(arg0_13)
			local var0_13 = getSkillConfig(arg0_13)

			table.insert(var3_11, "skillicon/" .. var0_13.icon)
		end)

		local var1_12 = Ship.New({
			configId = arg0_12
		}):getPrefab()

		table.insert(var4_11, "char/" .. var1_12)
		table.insert(var4_11, "char/" .. var1_12 .. "_hx")
	end)

	return (var0_0.MergeLuaArr(var0_11, var1_11, var2_11, var3_11, var4_11))
end

function var0_0.LogicMap.SkillInfoLayer(arg0_14)
	local var0_14 = var0_0.GetUIPreloadList(arg0_14)
	local var1_14 = var0_0.GetBGMList(arg0_14)
	local var2_14 = {}
	local var3_14 = arg0_14.context.data.skillId
	local var4_14 = getSkillConfig(var3_14)

	table.insert(var2_14, "skillicon/" .. var4_14.icon)

	return (var0_0.MergeLuaArr(var0_14, var1_14, var2_14))
end

function var0_0.LogicMap.NewMainScene(arg0_15)
	local var0_15 = var0_0.GetUIPreloadList(arg0_15)
	local var1_15 = var0_0.GetBGMList(arg0_15)

	return (var0_0.MergeLuaArr(var0_15, var1_15))
end

return var0_0
