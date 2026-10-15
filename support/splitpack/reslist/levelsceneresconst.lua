ResList = ResList or {}
ResList.LevelSceneResConst = {}

local var0_0 = ResList.LevelSceneResConst

function var0_0.GetResource(arg0_1)
	local var0_1 = arg0_1.contextData
	local var1_1 = {
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
		"chapter/cell_quad_mark",
		"artresource/effect/common/material/add",
		"effect/fleet_status_recorded"
	}

	table.insertto(var1_1, var0_0.GetInitialMapResList(arg0_1))
	table.insertto(var1_1, var0_0.GetDynamicResList(var0_1))

	return var1_1
end

function var0_0.GetInitialMapResList(arg0_2)
	local var0_2 = arg0_2.contextData
	local var1_2 = {}
	local var2_2 = var0_0.GetInitialMap(var0_2)

	if var2_2 then
		local var3_2 = arg0_2:GetMapBG(var2_2)

		_.each(var3_2 or {}, function(arg0_3)
			local var0_3 = arg0_3.bgPrefix and arg0_3.bgPrefix or ResPathSupport.ConstPath.LevelMap
			local var1_3 = ResPathSupport.CombinePath(var0_3, arg0_3.BG)

			table.insert(var1_2, var1_3)

			if arg0_3.Animator then
				table.insert(var1_2, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, arg0_3.Animator))
			end
		end)

		local var4_2 = var2_2:getConfig("cloud_suffix")

		if noEmptyStr(var4_2) then
			for iter0_2, iter1_2 in ipairs(var2_2:getConfig("clouds_pos") or {}) do
				table.insert(var1_2, "clouds/cloud_" .. iter0_2 .. "_" .. var4_2)
			end
		end
	end

	return var1_2
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
	table.insertto(var0_6, ResList.ChapterResConst.GetInactiveResList(var1_6))
	table.insertto(var0_6, var0_0.GetProcessAnimResList())

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

function var0_0.GetProcessAnimResList()
	return {
		"ui/spbombret",
		"ui/missilestrikebar",
		"ui/coastalgun",
		"ui/antiairfire",
		"ui/airstrikelava",
		"ui/airstrikebar",
		"ui/subsairentorpedoui"
	}
end

return var0_0
