ResList = ResList or {}
ResList.LevelStageView = {}

local var0_0 = ResList.LevelStageView

function var0_0.GetResource(arg0_1)
	local var0_1 = {}
	local var1_1 = arg0_1 and arg0_1.chapterVO

	table.insertto(var0_1, var0_0.GetStrategyResList(var1_1))
	table.insertto(var0_1, var0_0.GetCommanderSkillResList(var1_1))
	table.insertto(var0_1, var0_0.GetShipResList(var1_1))
	table.insertto(var0_1, ResList.LevelScene.GetLevelGridResList(var1_1))

	return var0_1
end

function var0_0.GetStrategyResList(arg0_2)
	local var0_2 = {}

	if not arg0_2 then
		return var0_2
	end

	_.each(arg0_2:GetShowingStrategies() or {}, function(arg0_3)
		local var0_3 = pg.strategy_data_template[arg0_3]

		if var0_3 and noEmptyStr(var0_3.icon) then
			local var1_3 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_3.icon)

			table.insert(var0_2, var1_3)
		end
	end)

	local var1_2 = arg0_2.fleet
	local var2_2 = var1_2 and var1_2:getStrategies() or {}

	_.each(var2_2, function(arg0_4)
		local var0_4 = pg.strategy_data_template[arg0_4.id]

		if var0_4 and noEmptyStr(var0_4.icon) then
			local var1_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_4.icon)

			table.insert(var0_2, var1_4)
		end
	end)
	_.each(arg0_2:GetWeather(), function(arg0_5)
		local var0_5 = pg.weather_data_template[arg0_5]

		if var0_5 and noEmptyStr(var0_5.buff_icon) then
			local var1_5 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_5.buff_icon)

			table.insert(var0_2, var1_5)
		end
	end)
	_.each(arg0_2:GetChapterCellAttachemnts(), function(arg0_6)
		if arg0_6.attachment == ChapterConst.AttachStrategy then
			local var0_6 = ChapterStrategy.New(pg.strategy_data_template[arg0_6.attachmentId])

			if var0_6 and var0_6.count > 0 then
				local var1_6 = pg.strategy_data_template[var0_6.id]

				if var1_6 and noEmptyStr(var1_6.icon) then
					local var2_6 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var1_6.icon)

					table.insert(var0_2, var2_6)
				end
			end
		end
	end)
	_.each(arg0_2:GetInteractableStrategies(), function(arg0_7)
		if arg0_7.id ~= ChapterConst.StrategyHuntingRange and arg0_7.id ~= ChapterConst.StrategySubAutoAttack then
			local var0_7 = pg.strategy_data_template[arg0_7.id]

			if var0_7 and noEmptyStr(var0_7.icon) then
				local var1_7 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.StrategyIcon, var0_7.icon)

				table.insert(var0_2, var1_7)
			end
		end
	end)

	return var0_2
end

function var0_0.GetCommanderSkillResList(arg0_8)
	local var0_8 = {}

	if not arg0_8 or not arg0_8.fleets then
		return var0_8
	end

	_.each(arg0_8.fleets, function(arg0_9)
		if arg0_9 and arg0_9.getCommanders then
			_.each(arg0_9:getCommanders(), function(arg0_10)
				local var0_10 = arg0_10 and arg0_10:getSkills()[1]
				local var1_10 = var0_10 and var0_10:getConfig("icon")

				if noEmptyStr(var1_10) then
					table.insert(var0_8, "commanderskillicon/" .. var1_10)
				end
			end)
		end
	end)

	return var0_8
end

function var0_0.GetShipResList(arg0_11)
	local var0_11 = {}

	if not arg0_11 or not arg0_11.fleets then
		return var0_11
	end

	_.each(arg0_11.fleets, function(arg0_12)
		if arg0_12 and arg0_12.getShips then
			_.each(arg0_12:getShips(true), function(arg0_13)
				var0_0.InsertShipResList(var0_11, arg0_13)
			end)
		end
	end)

	local var1_11 = arg0_11:getChapterSupportFleet()

	if var1_11 and var1_11.getShips then
		_.each(var1_11:getShips(true), function(arg0_14)
			var0_0.InsertShipResList(var0_11, arg0_14)
		end)
	end

	return var0_11
end

function var0_0.InsertShipResList(arg0_15, arg1_15)
	if not arg1_15 then
		return
	end

	table.insertto(arg0_15, ResPathSupport.GetPaintingSquareIconListByPaintingName(arg1_15:getPainting()))
	table.insertto(arg0_15, ResPathSupport.GetSpineQIconListByPrefabName(arg1_15:getPrefab()))
end

return var0_0
