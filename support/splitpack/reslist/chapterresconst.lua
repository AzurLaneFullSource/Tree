ResList = ResList or {}
ResList.ChapterResConst = {}

local var0_0 = ResList.ChapterResConst

local function var1_0(arg0_1, arg1_1, arg2_1)
	if noEmptyStr(arg2_1) then
		table.insert(arg0_1, ResPathSupport.CombinePath(arg1_1, arg2_1))
	end
end

local var2_0 = {
	"effect/huoqiubaozha",
	"effect/atdun_full_slg",
	"effect/dexiv4_slg_missile",
	"effect/shellhitblue",
	"effect/miwuxiaosan",
	"effect/qianting_01"
}

function var0_0.IsActive(arg0_2)
	return arg0_2 ~= nil and arg0_2.active == true
end

function var0_0.GetResList(arg0_3)
	local var0_3 = var0_0.GetInactiveResList(arg0_3)

	table.insertto(var0_3, var0_0.GetActiveResList(arg0_3))

	return var0_3
end

function var0_0.GetInactiveResList(arg0_4)
	local var0_4 = {}

	if not arg0_4 then
		return var0_4
	end

	table.insertto(var0_4, var0_0.GetThemeResList(arg0_4))
	table.insertto(var0_4, var0_0.GetEffectResList(arg0_4))
	table.insertto(var0_4, var0_0.GetSceneResList(arg0_4))

	return var0_4
end

function var0_0.GetActiveResList(arg0_5)
	local var0_5 = {}

	if not var0_0.IsActive(arg0_5) then
		return var0_5
	end

	table.insertto(var0_5, var0_0.GetFleetResList(arg0_5))
	table.insertto(var0_5, var0_0.GetChampionResList(arg0_5))
	table.insertto(var0_5, var0_0.GetCellAttachmentResList(arg0_5))
	table.insertto(var0_5, var0_0.GetStrategyResList(arg0_5))
	table.insertto(var0_5, var0_0.GetCommanderSkillResList(arg0_5))
	table.insertto(var0_5, var0_0.GetFleetIconResList(arg0_5))

	return var0_5
end

function var0_0.GetThemeResList(arg0_6)
	local var0_6 = {}

	if not arg0_6 then
		return var0_6
	end

	local var1_6 = arg0_6:getConfig("theme")

	if type(var1_6) ~= "table" then
		return var0_6
	end

	for iter0_6, iter1_6 in ipairs({
		1,
		10
	}) do
		local var2_6 = var1_6[iter1_6]

		if noEmptyStr(var2_6) then
			table.insert(var0_6, ResPathSupport.CombinePath(ResPathSupport.ConstPath.ChapterPic, var2_6))
		end
	end

	return var0_6
end

function var0_0.GetEffectResList(arg0_7)
	local var0_7 = {}

	if not arg0_7 then
		return var0_7
	end

	local var1_7 = arg0_7:getConfig("chapter_fx")

	if type(var1_7) == "table" then
		for iter0_7, iter1_7 in pairs(var1_7) do
			if noEmptyStr(iter0_7) then
				table.insert(var0_7, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, iter0_7))
			end
		end
	end

	local var2_7 = arg0_7:getConfig("wall_prefab")

	if type(var2_7) == "table" then
		for iter2_7, iter3_7 in ipairs(var2_7) do
			var1_0(var0_7, ResPathSupport.ConstPath.UI.Effect, iter3_7[3])
			var1_0(var0_7, ResPathSupport.ConstPath.UI.Effect, iter3_7[4])
		end
	end

	for iter4_7, iter5_7 in ipairs(var2_0) do
		table.insert(var0_7, iter5_7)
	end

	return var0_7
end

function var0_0.GetSceneResList(arg0_8)
	local var0_8 = {}

	if not arg0_8 then
		return var0_8
	end

	local var1_8 = arg0_8:getConfig("bg")

	if noEmptyStr(var1_8) then
		table.insert(var0_8, ResPathSupport.CombinePath(ResPathSupport.ConstPath.LevelMap, var1_8))
	end

	table.insertto(var0_8, var0_0.GetUIAnimResList(arg0_8:getConfig("pop_pic")))

	local var2_8 = arg0_8:getConfig("bgm")

	if noEmptyStr(var2_8) then
		table.insert(var0_8, "cue/bgm-" .. var2_8 .. ".b")
	end

	return var0_8
end

function var0_0.GetFleetResList(arg0_9)
	local var0_9 = {}

	if not var0_0.IsActive(arg0_9) then
		return var0_9
	end

	_.each(arg0_9.fleets or {}, function(arg0_10)
		if arg0_10.getFleetType and arg0_10:getFleetType() == FleetType.Transport then
			var1_0(var0_9, "enemies", arg0_10:getPrefab())
		end

		if arg0_10.getShips then
			_.each(arg0_10:getShips(false), function(arg0_11)
				table.insertto(var0_9, var0_0.GetShipStrikeResList(arg0_11, arg0_11:GetMapStrikeAnim()))
			end)
		end

		if arg0_10.getCommanders then
			for iter0_10, iter1_10 in pairs(arg0_10:getCommanders()) do
				table.insertto(var0_9, var0_0.GetCommanderResList(iter1_10))
			end
		end
	end)

	return var0_9
end

function var0_0.GetChampionResList(arg0_12)
	local var0_12 = {}

	if not var0_0.IsActive(arg0_12) then
		return var0_12
	end

	_.each(arg0_12.champions or {}, function(arg0_13)
		if arg0_13:getPoolType() == ChapterConst.TemplateOni then
			for iter0_13 = 1, #(arg0_12.fleets or {}) + 1 do
				var1_0(var0_12, "enemies", "sp_" .. iter0_13)
			end
		else
			if arg0_13:getPoolType() == ChapterConst.TemplateChampion then
				table.insertto(var0_12, var0_0.GetEnemyStrikeResList(arg0_13, "SubSairenTorpedoUI"))
			end

			table.insertto(var0_12, var0_0.GetEnemyMapResList(arg0_13:getConfigTable()))
		end
	end)

	return var0_12
end

function var0_0.GetEnemyMapResList(arg0_14, arg1_14)
	local var0_14 = {}

	if not arg0_14 then
		return var0_14
	end

	if noEmptyStr(arg0_14.icon) then
		if arg0_14.icon_type == 1 then
			var1_0(var0_14, "enemies", arg0_14.icon)

			if arg1_14 then
				var1_0(var0_14, "enemies", arg0_14.icon .. "_d_blue")
			end

			table.insert(var0_14, "enemies/fogsrqz")
		else
			table.insertto(var0_14, ResPathSupport.GetSpineCharListByPrefabName(arg0_14.icon))
		end
	end

	var1_0(var0_14, ResPathSupport.ConstPath.UI.Effect, arg0_14.effect_prefab)

	return var0_14
end

function var0_0.GetTransformedUIResList(arg0_15, arg1_15)
	local var0_15 = {}

	if not var0_0.IsActive(arg0_15) or not noEmptyStr(arg1_15) then
		return var0_15
	end

	local var1_15 = {
		arg1_15
	}
	local var2_15 = arg0_15:getConfig("ItemTransformPattern")

	if type(var2_15) == "table" then
		for iter0_15, iter1_15 in ipairs(arg0_15:getExtraFlags()) do
			local var3_15 = var2_15[iter1_15]

			if var3_15 then
				local var4_15 = {}

				for iter2_15, iter3_15 in ipairs(var1_15) do
					if var3_15[3] and var3_15[3] < 1 then
						table.insert(var4_15, iter3_15)
					end

					if not var3_15[3] or var3_15[3] > 0 then
						local var5_15 = string.gsub(iter3_15, var3_15[1], var3_15[2])

						table.insert(var4_15, var5_15)
					end
				end

				var1_15 = var4_15
			end
		end
	end

	for iter4_15, iter5_15 in ipairs(var1_15) do
		var1_0(var0_15, ResPathSupport.ConstPath.UI.Base, iter5_15)
	end

	return var0_15
end

function var0_0.GetStoryResList(arg0_16, arg1_16)
	local var0_16 = {}

	if not var0_0.IsActive(arg0_16) or not arg1_16 then
		return var0_16
	end

	local var1_16 = pg.map_event_template[arg1_16.attachmentId]

	if not var1_16 then
		return var0_16
	end

	if arg1_16.data == ChapterConst.Story then
		var1_0(var0_16, "boxprefab", var1_16.icon)
	elseif arg1_16.data == ChapterConst.StoryObstacle then
		if noEmptyStr(var1_16.icon) then
			table.insertto(var0_16, var0_0.GetTransformedUIResList(arg0_16, var1_16.icon .. "_2"))
		end

		var1_0(var0_16, ResPathSupport.ConstPath.UI.Base, var1_16.animation)
	elseif arg1_16.data == ChapterConst.StoryTrigger and var1_16.c_type ~= ChapterConst.EvtType_AdditionalFloor and noEmptyStr(var1_16.icon) then
		table.insertto(var0_16, var0_0.GetTransformedUIResList(arg0_16, var1_16.icon .. "_1"))

		local var2_16 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, var1_16.icon .. "_1shangceng")

		if checkABExist(var2_16) then
			table.insert(var0_16, var2_16)
		end
	end

	return var0_16
end

function var0_0.GetCellAttachmentResList(arg0_17)
	local var0_17 = {}

	if not var0_0.IsActive(arg0_17) then
		return var0_17
	end

	local function var1_17(arg0_18)
		local var0_18 = ChapterConst.GetDestroyFX(arg0_18)

		if noEmptyStr(var0_18) then
			table.insert(var0_17, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var0_18))
		end
	end

	for iter0_17, iter1_17 in pairs(arg0_17.cells or {}) do
		if ChapterConst.IsEnemyAttach(iter1_17.attachment) then
			var1_17(iter1_17)
			table.insertto(var0_17, var0_0.GetEnemyMapResList(pg.expedition_data_template[iter1_17.attachmentId], iter1_17.attachment ~= ChapterConst.AttachAmbush))
		elseif iter1_17.attachment == ChapterConst.AttachStory then
			table.insertto(var0_17, var0_0.GetStoryResList(arg0_17, iter1_17))
		elseif iter1_17.attachment == ChapterConst.AttachBox then
			local var2_17 = pg.box_data_template[iter1_17.attachmentId]

			var1_0(var0_17, "boxprefab", var2_17 and var2_17.icon)
		elseif iter1_17.attachment == ChapterConst.AttachBomb_Enemy then
			local var3_17 = pg.specialunit_template[iter1_17.attachmentId]
			local var4_17 = pg.land_based_template[iter1_17.attachmentId]

			var1_0(var0_17, "enemies", var3_17 and var3_17.prefab)

			if var4_17 and noEmptyStr(var4_17.prefab) then
				var1_0(var0_17, "enemies", var4_17.prefab .. "_d_blue")
			end
		elseif iter1_17.attachment == ChapterConst.AttachLandbase then
			local var5_17 = pg.land_based_template[iter1_17.attachmentId]

			if var5_17 and noEmptyStr(var5_17.prefab) then
				if var5_17.type == ChapterConst.LBCoastalGun then
					var1_0(var0_17, "enemies", var5_17.prefab)
					var1_0(var0_17, "enemies", var5_17.prefab .. "_d_blue")
				elseif var5_17.type == ChapterConst.LBFogLightBase then
					var1_0(var0_17, "chapter", var5_17.prefab)
					var1_0(var0_17, "chapter", var5_17.prefab .. "_d_blue")
				end
			end
		end

		var1_0(var0_17, "chapter", iter1_17.item)

		if iter1_17.GetWeatherFlagList then
			for iter2_17, iter3_17 in ipairs(iter1_17:GetWeatherFlagList()) do
				local var6_17 = pg.weather_data_template[iter3_17]

				var1_0(var0_17, ResPathSupport.ConstPath.UI.Base, var6_17 and var6_17.icon)
			end
		end
	end

	for iter4_17, iter5_17 in pairs(arg0_17:GetChapterCellAttachemnts() or {}) do
		table.insertto(var0_17, var0_0.GetStoryResList(arg0_17, iter5_17))
	end

	for iter6_17, iter7_17 in pairs(arg0_17.wallAssets or {}) do
		var1_0(var0_17, ResPathSupport.ConstPath.UI.Effect, iter7_17[3])
		var1_0(var0_17, ResPathSupport.ConstPath.UI.Effect, iter7_17[4])
	end

	local var7_17 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg0_17.id)

	if var7_17 then
		var1_17(var7_17)
	end

	return var0_17
end

function var0_0.GetStrategyResList(arg0_19)
	local var0_19 = {}

	if not var0_0.IsActive(arg0_19) then
		return var0_19
	end

	local function var1_19(arg0_20)
		local var0_20 = pg.strategy_data_template[arg0_20]

		if var0_20 and noEmptyStr(var0_20.icon) then
			table.insert(var0_19, ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_20.icon))
		end
	end

	_.each(arg0_19:GetShowingStrategies(), var1_19)
	_.each(arg0_19.fleets or {}, function(arg0_21)
		if arg0_21.getStrategies then
			_.each(arg0_21:getStrategies(), function(arg0_22)
				var1_19(arg0_22.id)
			end)
		end
	end)

	if arg0_19:getChapterSupportFleet() and not arg0_19:IsSupportSubmarineStage() then
		var1_19(ChapterConst.StrategyAirSupportFriendly)
	end

	_.each(arg0_19:GetWeather(), function(arg0_23)
		local var0_23 = pg.weather_data_template[arg0_23]

		if var0_23 and noEmptyStr(var0_23.buff_icon) then
			table.insert(var0_19, ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_23.buff_icon))
		end
	end)

	for iter0_19, iter1_19 in pairs(arg0_19.cells or {}) do
		if iter1_19.attachment == ChapterConst.AttachStrategy then
			local var2_19 = ChapterStrategy.New(pg.strategy_data_template[iter1_19.attachmentId])

			if var2_19 and var2_19.count > 0 then
				var1_19(var2_19.id)
			end
		end
	end

	_.each(arg0_19:GetInteractableStrategies(), function(arg0_24)
		if arg0_24.id ~= ChapterConst.StrategyHuntingRange and arg0_24.id ~= ChapterConst.StrategySubAutoAttack then
			var1_19(arg0_24.id)
		end
	end)

	return var0_19
end

function var0_0.GetCommanderSkillResList(arg0_25)
	local var0_25 = {}

	if not var0_0.IsActive(arg0_25) then
		return var0_25
	end

	_.each(arg0_25.fleets or {}, function(arg0_26)
		if arg0_26.getCommanders then
			for iter0_26, iter1_26 in pairs(arg0_26:getCommanders()) do
				local var0_26 = iter1_26:getSkills()[1]
				local var1_26 = var0_26 and var0_26:getConfig("icon")

				if noEmptyStr(var1_26) then
					table.insert(var0_25, "commanderskillicon/" .. var1_26)
				end
			end
		end
	end)

	return var0_25
end

function var0_0.GetFleetIconResList(arg0_27)
	local var0_27 = {}

	if not var0_0.IsActive(arg0_27) then
		return var0_27
	end

	_.each(arg0_27.fleets or {}, function(arg0_28)
		if arg0_28.getShips then
			_.each(arg0_28:getShips(true), function(arg0_29)
				table.insertto(var0_27, ResPathSupport.GetPaintingSquareIconListByPaintingName(arg0_29:getPainting()))
				table.insertto(var0_27, ResPathSupport.GetSpineQIconListByPrefabName(arg0_29:getPrefab()))
			end)
		end
	end)

	return var0_27
end

function var0_0.GetUIAnimResList(arg0_30)
	local var0_30 = {}

	if noEmptyStr(arg0_30) then
		table.insert(var0_30, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, arg0_30))
	end

	return var0_30
end

function var0_0.GetShipStrikeResList(arg0_31, arg1_31)
	local var0_31 = var0_0.GetUIAnimResList(arg1_31)

	if arg0_31 then
		local var1_31 = arg0_31:getPainting()

		if noEmptyStr(var1_31) then
			table.insertto(var0_31, ResPathSupport.GetPaintingListByPaintingName(var1_31))
		end

		table.insertto(var0_31, ResPathSupport.GetSpineCharListByPrefabName(arg0_31:getPrefab()))
	end

	return var0_31
end

function var0_0.GetEnemyStrikeResList(arg0_32, arg1_32)
	local var0_32 = var0_0.GetUIAnimResList(arg1_32)

	if arg0_32 then
		table.insertto(var0_32, ResPathSupport.GetSpineCharListByPrefabName(arg0_32:getPrefab()))
	end

	return var0_32
end

function var0_0.GetCommanderResList(arg0_33)
	local var0_33 = {}

	if arg0_33 then
		local var1_33 = arg0_33:getConfig("painting")

		if noEmptyStr(var1_33) then
			table.insert(var0_33, ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderHrz, var1_33))
		end
	end

	return var0_33
end

return var0_0
