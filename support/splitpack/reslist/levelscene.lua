ResList = ResList or {}
ResList.LevelScene = {}

local var0_0 = ResList.LevelScene

function var0_0.GetResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/ambushwarnui",
		"ui/radareffectui",
		"ui/airstrike",
		"ui/torpeto",
		"ui/spunitwin",
		"ui/spunitlose",
		"ui/levelmaptransition_1420001",
		"ui/levelmaptransition_1420011",
		"ui/levels",
		"ui/escort_levels",
		"ui/skirmish_levels",
		"ui/bismarck_levels",
		"ui/bismarck_levels_atlas",
		"ui/shinano_levels",
		"ui/levelselectspui",
		"ui/levelselectspfullui",
		"ui/levelselectspseriesui",
		"ui/levelselectspseriesrecrewui",
		"ui/levelselectatelieryumia",
		"ui/levelselectatelieryumia_atlas",
		"ui/levelselectexspui",
		"chapterno",
		"ui/levelmainscene_atlas",
		"chapter/pic/cellgrid",
		"ui/share/ship_gizmos_atlas",
		"leveluiview/tpl_enemy",
		"leveluiview/tpl_staticchampion",
		"leveluiview/tpl_box",
		"leveluiview/tpl_box",
		"leveluiview/tpl_supply",
		"leveluiview/tpl_dead",
		"leveluiview/tpl_antiairgun",
		"leveluiview/tpl_antiairgunarea",
		"leveluiview/tpl_dockyard",
		"boxprefab/gangkou",
		"boxprefab/event_task_small",
		"boxprefab/event2",
		"chapter/plane",
		"chapter/cell",
		"chapter/cell_quad",
		"artresource/effect/common/material/add",
		"effect/fleet_status_recorded"
	}

	table.insertto(var0_1, var0_0.GetInitialMapResList(arg0_1, arg1_1))
	table.insertto(var0_1, var0_0.GetDynamicResList(arg1_1))

	return var0_1
end

function var0_0.GetInitialMapResList(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = var0_0.GetInitialMap(arg1_2)

	if var1_2 then
		local var2_2 = arg0_2:GetMapBG(var1_2)

		_.each(var2_2 or {}, function(arg0_3)
			local var0_3 = arg0_3.bgPrefix and arg0_3.bgPrefix or ResPathSupport.ConstPath.LevelMap
			local var1_3 = ResPathSupport.CombinePath(var0_3, arg0_3.BG)

			table.insert(var0_2, var1_3)

			if arg0_3.Animator then
				table.insert(var0_2, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, arg0_3.Animator))
			end
		end)

		local var3_2 = var1_2:getConfig("cloud_suffix")

		if noEmptyStr(var3_2) then
			for iter0_2, iter1_2 in ipairs(var1_2:getConfig("clouds_pos") or {}) do
				table.insert(var0_2, "clouds/cloud_" .. iter0_2 .. "_" .. var3_2)
			end
		end
	end

	local var4_2 = var0_0.GetInitialChapter(arg1_2)

	if var4_2 and var4_2.theme then
		local var5_2 = var4_2.theme

		if noEmptyStr(var5_2.assetSea) then
			table.insert(var0_2, ResPathSupport.CombinePath(ResPathSupport.ConstPath.ChapterPic, var5_2.assetSea))
		end

		if noEmptyStr(var5_2.seaBase) then
			table.insert(var0_2, ResPathSupport.CombinePath(ResPathSupport.ConstPath.ChapterPic, var5_2.seaBase))
		end
	end

	return var0_2
end

function var0_0.GetInitialMap(arg0_4)
	arg0_4 = arg0_4 or {}

	local var0_4 = getProxy(ChapterProxy)
	local var1_4 = arg0_4.map

	if arg0_4.chapterVO and arg0_4.chapterVO.active then
		var1_4 = var0_4:getMapById(arg0_4.chapterVO:getConfig("map"))
	elseif arg0_4.mapIdx then
		var1_4 = var0_4:getMapById(arg0_4.mapIdx)
	elseif arg0_4.targetMap then
		var1_4 = arg0_4.targetMap
	elseif arg0_4.eliteDefault then
		var1_4 = var0_4:getUseableMaxEliteMap()
	end

	if var1_4 then
		if var1_4:isUnlock() then
			return var1_4
		end

		return var0_4:getLastUnlockMap()
	end

	return var0_4:getMapById(var0_4:GetLastNormalMap())
end

function var0_0.GetInitialChapter(arg0_5)
	arg0_5 = arg0_5 or {}

	local var0_5 = getProxy(ChapterProxy)

	if arg0_5.chapterVO then
		return arg0_5.chapterVO
	end

	if arg0_5.chapterId then
		return var0_5:getChapterById(arg0_5.chapterId)
	end

	return var0_5:getActiveChapter(true)
end

function var0_0.GetDynamicResList(arg0_6)
	local var0_6 = {}
	local var1_6 = var0_0.GetInitialChapter(arg0_6)

	table.insertto(var0_6, var0_0.GetEntranceActivityResList())
	table.insertto(var0_6, var0_0.GetActivityResList(arg0_6))
	table.insertto(var0_6, var0_0.GetChapterShipResList(var1_6))
	table.insertto(var0_6, var0_0.GetChapterChampionResList(var1_6))
	table.insertto(var0_6, var0_0.GetChapterCommanderResList(var1_6))
	table.insertto(var0_6, var0_0.GetLevelGridResList(var1_6))
	table.insertto(var0_6, var0_0.GetProcessAnimResList(var1_6))

	return var0_6
end

function var0_0.GetEntranceActivityResList()
	local var0_7 = {}
	local var1_7 = getProxy(ActivityProxy):getEnterReadyActivity()[1]

	if var1_7 then
		local var2_7 = var1_7:getConfig("config_client").entrance_bg

		if noEmptyStr(var2_7) then
			table.insert(var0_7, var2_7)
		end
	end

	return var0_7
end

function var0_0.GetActivityResList(arg0_8)
	local var0_8 = {}
	local var1_8 = var0_0.GetInitialMap(arg0_8)

	if var1_8 and var1_8.isActivity and var1_8:isActivity() and not var1_8:isRemaster() then
		local var2_8 = getProxy(ActivityProxy):getActivityById(var1_8:getConfig("on_activity"))
		local var3_8 = var2_8 and not var2_8:isEnd() and var2_8:GetConfigClientSetting("PTID")

		if var3_8 then
			local var4_8 = underscore.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_9)
				return arg0_9:getConfig("config_id") == var3_8
			end)

			if var4_8 then
				local var5_8 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = tonumber(var4_8:getConfig("config_id"))
				}):getIcon()

				if noEmptyStr(var5_8) then
					table.insert(var0_8, var5_8)
				end
			end
		end
	end

	return var0_8
end

function var0_0.GetUIAnimResList(arg0_10)
	local var0_10 = {}

	if noEmptyStr(arg0_10) then
		table.insert(var0_10, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, arg0_10))
	end

	return var0_10
end

function var0_0.GetChapterShipResList(arg0_11)
	local var0_11 = {}

	if arg0_11 and arg0_11.fleets then
		_.each(arg0_11.fleets, function(arg0_12)
			if arg0_12.getShips then
				local var0_12 = arg0_12:getShips(false)

				_.each(var0_12, function(arg0_13)
					table.insertto(var0_11, var0_0.GetShipStrikeResList(arg0_13, arg0_13:GetMapStrikeAnim()))
				end)
			end
		end)
	end

	return var0_11
end

function var0_0.GetChapterChampionResList(arg0_14)
	local var0_14 = {}

	if arg0_14 and arg0_14.champions then
		_.each(arg0_14.champions, function(arg0_15)
			table.insertto(var0_14, var0_0.GetEnemyStrikeResList(arg0_15, "SubSairenTorpedoUI"))
		end)
	end

	return var0_14
end

function var0_0.GetChapterCommanderResList(arg0_16)
	local var0_16 = {}

	if arg0_16 and arg0_16.fleets then
		_.each(arg0_16.fleets, function(arg0_17)
			if arg0_17.getCommanders then
				_.each(arg0_17:getCommanders(), function(arg0_18)
					table.insertto(var0_16, var0_0.GetCommanderResList(arg0_18))
				end)
			end
		end)
	end

	return var0_16
end

function var0_0.GetLevelGridResList(arg0_19)
	local var0_19 = {}

	if not arg0_19 then
		return var0_19
	end

	if arg0_19.theme then
		local var1_19 = arg0_19.theme

		if noEmptyStr(var1_19.assetSea) then
			table.insert(var0_19, ResPathSupport.CombinePath(ResPathSupport.ConstPath.ChapterPic, var1_19.assetSea))
		end

		if noEmptyStr(var1_19.seaBase) then
			table.insert(var0_19, ResPathSupport.CombinePath(ResPathSupport.ConstPath.ChapterPic, var1_19.seaBase))
		end
	end

	local var2_19 = arg0_19:getConfig("chapter_fx")

	if type(var2_19) == "table" then
		for iter0_19, iter1_19 in pairs(var2_19) do
			if noEmptyStr(iter0_19) then
				local var3_19 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, iter0_19)

				table.insert(var0_19, var3_19)
			end
		end
	end

	table.insert(var0_19, "effect/huoqiubaozha")
	table.insert(var0_19, "effect/atdun_full_slg")
	table.insert(var0_19, "effect/dexiv4_slg_missile")
	table.insert(var0_19, "effect/shellhitblue")
	table.insert(var0_19, "effect/miwuxiaosan")
	table.insert(var0_19, "effect/qianting_01")
	_.each(arg0_19:GetChapterCellAttachemnts(), function(arg0_20)
		local var0_20 = pg.expedition_data_template[arg0_20.attachmentId]
		local var1_20 = var0_20 and var0_20.SLG_destroy_FX

		if not noEmptyStr(var1_20) then
			var1_20 = "huoqiubaozha"
		end

		table.insert(var0_19, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var1_20))
	end)

	return var0_19
end

function var0_0.GetProcessAnimResList(arg0_21)
	local var0_21 = {
		"ui/spbombret",
		"ui/missilestrikebar",
		"ui/coastalgun",
		"ui/antiairfire",
		"ui/airstrikelava",
		"ui/airstrikebar",
		"ui/subsairentorpedoui"
	}

	if arg0_21 and arg0_21.fleets then
		_.each(arg0_21.fleets, function(arg0_22)
			if arg0_22.getShips then
				_.each(arg0_22:getShips(false), function(arg0_23)
					table.insertto(var0_21, var0_0.GetUIAnimResList(arg0_23:GetMapStrikeAnim()))
				end)
			end
		end)
	end

	return var0_21
end

function var0_0.GetShipStrikeResList(arg0_24, arg1_24)
	local var0_24 = var0_0.GetUIAnimResList(arg1_24)

	if arg0_24 then
		local var1_24 = arg0_24:getPainting()

		if noEmptyStr(var1_24) then
			local var2_24 = ResPathSupport.GetPaintingListByPaintingName(var1_24)

			table.insertto(var0_24, var2_24)
		end

		table.insertto(var0_24, ResPathSupport.GetSpineCharListByPrefabName(arg0_24:getPrefab()))
	end

	return var0_24
end

function var0_0.GetEnemyStrikeResList(arg0_25, arg1_25)
	local var0_25 = var0_0.GetUIAnimResList(arg1_25)

	if arg0_25 then
		table.insertto(var0_25, ResPathSupport.GetSpineCharListByPrefabName(arg0_25:getPrefab()))
	end

	return var0_25
end

function var0_0.GetCommanderResList(arg0_26)
	local var0_26 = {}

	if arg0_26 then
		local var1_26 = arg0_26:getConfig("painting")

		if noEmptyStr(var1_26) then
			local var2_26 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderHrz, var1_26)

			table.insert(var0_26, var2_26)
		end
	end

	return var0_26
end

return var0_0
