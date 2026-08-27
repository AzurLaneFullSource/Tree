local var0_0 = class("ChapterProxy", import(".NetProxy"))

var0_0.CHAPTER_UPDATED = "ChapterProxy:CHAPTER_UPDATED"
var0_0.CHAPTER_TIMESUP = "ChapterProxy:CHAPTER_TIMESUP"
var0_0.CHAPTER_CELL_UPDATED = "ChapterProxy:CHAPTER_CELL_UPDATED"
var0_0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED = "CHAPTERPROXY:CHAPTER_AUTO_FIGHT_FLAG_UPDATED"
var0_0.CHAPTER_SKIP_PRECOMBAT_UPDATED = "CHAPTERPROXY:CHAPTER_SKIP_PRECOMBAT_UPDATED"
var0_0.CHAPTER_REMASTER_INFO_UPDATED = "CHAPTERPROXY:CHAPTER_REMASTER_INFO_UPDATED"
var0_0.LAST_MAP_FOR_ACTIVITY = "last_map_for_activity"
var0_0.LAST_MAP = "last_map"

function var0_0.register(arg0_1)
	arg0_1:on(13001, function(arg0_2)
		arg0_1.mapEliteFleetCache = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.fleet_list) do
			local var0_2 = iter1_2.id

			arg0_1.mapEliteFleetCache[var0_2] = Chapter.BuildEliteFleetInfo(iter1_2)
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.chapter_list) do
			if not pg.chapter_template[iter3_2.id] then
				errorMsg("chapter_template not exist: " .. iter3_2.id)
			else
				local var1_2 = Chapter.New(iter3_2)
				local var2_2 = var1_2:getConfig("formation")

				var1_2:setEliteFleetList(Clone(arg0_1.mapEliteFleetCache[var2_2]))
				arg0_1:updateChapter(var1_2)
			end
		end

		if arg0_2.react_chapter then
			arg0_1.remasterTickets = arg0_2.react_chapter.count
			arg0_1.remasterDailyCount = arg0_2.react_chapter.daily_count
			arg0_1.remasterTip = not (arg0_1.remasterDailyCount > 0)
		end
	end)
	arg0_1:on(13000, function(arg0_3)
		arg0_1.repairTimes = arg0_3.daily_repair_count

		if arg0_3.current_chapter then
			local var0_3 = arg0_3.current_chapter.id

			if var0_3 > 0 then
				local var1_3 = arg0_1:getChapterById(var0_3, true)

				var1_3:update(arg0_3.current_chapter)
				arg0_1:updateChapter(var1_3)
			end
		end

		Map.lastMap = arg0_1:getLastMap(var0_0.LAST_MAP)
		Map.lastMapForActivity = arg0_1:getLastMap(var0_0.LAST_MAP_FOR_ACTIVITY)

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")
	end)

	arg0_1.timers = {}
	arg0_1.escortChallengeTimes = 0
	arg0_1.chaptersExtend = {}
	arg0_1.chapterStoryGroups = {}
	arg0_1.continuousData = {}

	arg0_1:buildMaps()
	arg0_1:buildRemasterInfo()
end

function var0_0.timeCall(arg0_4)
	return {
		[ProxyRegister.DayCall] = function(arg0_5)
			arg0_4:resetRepairTimes()
			arg0_4:resetEscortChallengeTimes()

			local var0_5 = arg0_4:getData()

			for iter0_5, iter1_5 in pairs(var0_5) do
				if iter1_5.todayDefeatCount > 0 then
					iter1_5.todayDefeatCount = 0

					arg0_4:updateChapter(iter1_5)
				end
			end

			arg0_4:resetDailyCount()
		end
	}
end

function var0_0.OnBattleFinished(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:getActiveChapter()

	if var0_6 then
		local var1_6 = 0

		local function var2_6()
			local var0_7 = getProxy(ContextProxy)

			if not var0_7 then
				return
			end

			if var0_7:getCurrentContext().mediator == LevelMediator2 then
				var1_6 = bit.bor(var1_6, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

				arg0_6:SetChapterAutoFlag(var0_6.id, false)

				return
			end

			local var1_7 = var0_7:getContextByMediator(LevelMediator2)

			if not var1_7 then
				return
			end

			var1_7.data.StopAutoFightFlag = true
		end

		if _.any(arg1_6.ai_list, function(arg0_8)
			return arg0_8.item_type == ChapterConst.AttachOni
		end) then
			var0_6:onOniEnter()
			var2_6()
		end

		if _.any(arg1_6.map_update, function(arg0_9)
			return arg0_9.item_type == ChapterConst.AttachBomb_Enemy
		end) then
			var0_6:onBombEnemyEnter()
			var2_6()
		end

		if #arg1_6.map_update > 0 then
			_.each(arg1_6.map_update, function(arg0_10)
				if arg0_10.item_type == ChapterConst.AttachStory and arg0_10.item_data == ChapterConst.StoryTrigger then
					local var0_10 = ChapterCell.Line2Name(arg0_10.pos.row, arg0_10.pos.column)
					local var1_10 = var0_6:GetChapterCellAttachemnts()
					local var2_10 = var1_10[var0_10]

					if var2_10 then
						if var2_10.flag == ChapterConst.CellFlagTriggerActive and arg0_10.item_flag == ChapterConst.CellFlagTriggerDisabled then
							local var3_10 = pg.map_event_template[var2_10.attachmentId].gametip

							if var3_10 ~= "" then
								pg.TipsMgr.GetInstance():ShowTips(i18n(var3_10))
							end
						end

						var2_10.attachment = arg0_10.item_type
						var2_10.attachmentId = arg0_10.item_id
						var2_10.flag = arg0_10.item_flag
						var2_10.data = arg0_10.item_data
					else
						var1_10[var0_10] = ChapterCell.New(arg0_10)
					end
				elseif arg0_10.item_type ~= ChapterConst.AttachNone and arg0_10.item_type ~= ChapterConst.AttachBorn and arg0_10.item_type ~= ChapterConst.AttachBorn_Sub and arg0_10.item_type ~= ChapterConst.AttachOni_Target and arg0_10.item_type ~= ChapterConst.AttachOni then
					local var4_10 = ChapterCell.New(arg0_10)

					var0_6:mergeChapterCell(var4_10)
				end
			end)

			var1_6 = bit.bor(var1_6, ChapterConst.DirtyAttachment, ChapterConst.DirtyAutoAction)
		end

		if #arg1_6.ai_list > 0 then
			_.each(arg1_6.ai_list, function(arg0_11)
				local var0_11 = ChapterChampionPackage.New(arg0_11)

				var0_6:mergeChampion(var0_11)
			end)

			var1_6 = bit.bor(var1_6, ChapterConst.DirtyChampion, ChapterConst.DirtyAutoAction)
		end

		if #arg1_6.add_flag_list > 0 or #arg1_6.del_flag_list > 0 then
			var1_6 = bit.bor(var1_6, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment, ChapterConst.DirtyWeather)

			arg0_6:updateExtraFlag(var0_6, arg1_6.add_flag_list, arg1_6.del_flag_list)
		end

		if #arg1_6.buff_list > 0 then
			var0_6:UpdateBuffList(arg1_6.buff_list)
		end

		if #arg1_6.cell_flag_list > 0 then
			_.each(arg1_6.cell_flag_list, function(arg0_12)
				local var0_12 = var0_6:getChapterCell(arg0_12.pos.row, arg0_12.pos.column)

				if var0_12 then
					var0_12:updateFlagList(arg0_12)
				else
					var0_12 = ChapterCell.New(arg0_12)
				end

				var0_6:updateChapterCell(var0_12)
			end)

			var1_6 = bit.bor(var1_6, ChapterConst.DirtyCellFlag, ChapterConst.DirtyWeather)
		end

		arg0_6:updateChapter(var0_6, var1_6)

		if arg2_6 then
			arg0_6:sendNotification(GAME.CHAPTER_OP_DONE, {
				type = ChapterConst.OpSkipBattle
			})
		end
	end
end

function var0_0.setEliteCache(arg0_13, arg1_13)
	arg0_13.mapEliteFleetCache = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		local var0_13 = iter1_13.id

		arg0_13.mapEliteFleetCache[var0_13] = Chapter.BuildEliteFleetInfo(iter1_13)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter2_13, iter3_13 in pairs(arg0_13.data) do
		local var1_13 = iter3_13:getConfig("formation")

		iter3_13:setEliteFleetList(Clone(arg0_13.mapEliteFleetCache[var1_13]))
		arg0_13:updateChapter(iter3_13)
	end
end

function var0_0.buildMaps(arg0_14)
	arg0_14:initChapters()
	arg0_14:buildBaseMaps()
	arg0_14:buildRemasterMaps()
end

function var0_0.initChapters(arg0_15)
	var0_0.MapToChapters = table.shallowCopy(pg.chapter_template.get_id_list_by_map)

	for iter0_15, iter1_15 in pairs(pg.story_group.get_id_list_by_map) do
		var0_0.MapToChapters[iter0_15] = var0_0.MapToChapters[iter0_15] or {}

		table.insertto(var0_0.MapToChapters[iter0_15], iter1_15)
	end

	var0_0.FormationToChapters = pg.chapter_template.get_id_list_by_formation
end

function var0_0.buildBaseMaps(arg0_16)
	var0_0.ActToMaps = {}
	var0_0.TypeToMaps = {}

	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(pg.expedition_data_by_map.all) do
		local var1_16 = Map.New({
			id = iter1_16,
			chapterIds = var0_0.MapToChapters[iter1_16]
		})

		var0_16[iter1_16] = var1_16

		local var2_16 = var1_16:getConfig("on_activity")

		if var2_16 ~= 0 then
			var0_0.ActToMaps[var2_16] = var0_0.ActToMaps[var2_16] or {}

			table.insert(var0_0.ActToMaps[var2_16], var1_16.id)
		end

		local var3_16 = var1_16:getMapType()

		var0_0.TypeToMaps[var3_16] = var0_0.TypeToMaps[var3_16] or {}

		table.insert(var0_0.TypeToMaps[var3_16], var1_16.id)
	end

	arg0_16.baseMaps = var0_16
end

function var0_0.buildRemasterMaps(arg0_17)
	var0_0.RemasterToMaps = {}

	local var0_17 = {}

	_.each(BossRushChapterRemasterHelper.GetAllNonActivityIds(), function(arg0_18)
		local var0_18 = pg.re_map_template[arg0_18]

		_.each(var0_18.config_data, function(arg0_19)
			local var0_19 = arg0_17.baseMaps[pg.chapter_template[arg0_19].map]

			assert(not var0_17[var0_19.id] or var0_17[var0_19.id] == arg0_18, "remaster chapter error:" .. arg0_19)

			if not var0_17[var0_19.id] then
				var0_17[var0_19.id] = arg0_18

				var0_19:setRemaster(arg0_18)

				var0_0.RemasterToMaps[arg0_18] = var0_0.RemasterToMaps[arg0_18] or {}

				table.insert(var0_0.RemasterToMaps[arg0_18], var0_19.id)
			end
		end)
	end)
end

function var0_0.IsChapterInRemaster(arg0_20, arg1_20)
	return _.detect(BossRushChapterRemasterHelper.GetAllNonActivityIds(), function(arg0_21)
		local var0_21 = pg.re_map_template[arg0_21]

		return _.any(var0_21.config_data, function(arg0_22)
			return arg0_22 == arg1_20
		end)
	end)
end

function var0_0.getMaxEscortChallengeTimes(arg0_23)
	return getProxy(ActivityProxy):getActivityParameter("escort_daily_count") or 0
end

function var0_0.getEscortChapterIds(arg0_24)
	return getProxy(ActivityProxy):getActivityParameter("escort_exp_id") or {}
end

function var0_0.resetEscortChallengeTimes(arg0_25)
	arg0_25.escortChallengeTimes = 0
end

function var0_0.addChapterListener(arg0_26, arg1_26)
	if not arg1_26.dueTime or not arg0_26.timers then
		return
	end

	if arg0_26.timers[arg1_26.id] then
		arg0_26.timers[arg1_26.id]:Stop()

		arg0_26.timers[arg1_26.id] = nil
	end

	local var0_26 = arg1_26.dueTime - pg.TimeMgr.GetInstance():GetServerTime()

	local function var1_26()
		arg0_26.data[arg1_26.id].dueTime = nil

		arg0_26.data[arg1_26.id]:display("times'up")
		arg0_26:sendNotification(var0_0.CHAPTER_UPDATED, {
			dirty = 0,
			chapter = arg0_26.data[arg1_26.id]:clone()
		})
		arg0_26:sendNotification(var0_0.CHAPTER_TIMESUP)
	end

	if var0_26 > 0 then
		arg0_26.timers[arg1_26.id] = Timer.New(function()
			var1_26()
			arg0_26.timers[arg1_26.id]:Stop()

			arg0_26.timers[arg1_26.id] = nil
		end, var0_26, 1)

		arg0_26.timers[arg1_26.id]:Start()
	else
		var1_26()
	end
end

function var0_0.removeChapterListener(arg0_29, arg1_29)
	if arg0_29.timers[arg1_29] then
		arg0_29.timers[arg1_29]:Stop()

		arg0_29.timers[arg1_29] = nil
	end
end

function var0_0.remove(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.timers) do
		iter1_30:Stop()
	end

	arg0_30.timers = nil
end

function var0_0.GetRawChapterById(arg0_31, arg1_31)
	return arg0_31.data[arg1_31]
end

function var0_0.getChapterById(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.data[arg1_32]

	if not var0_32 then
		assert(pg.chapter_template[arg1_32], "Not Exist Chapter ID: " .. (arg1_32 or "NIL"))

		var0_32 = Chapter.New({
			id = arg1_32
		})

		local var1_32 = var0_32:getConfig("formation")

		if var0_32:getConfig("type") == Chapter.CustomFleet or var0_32:GetSupportFleetMaxCount() > 0 then
			var0_32:setEliteFleetList(Clone(arg0_32.mapEliteFleetCache[var1_32]))
		end

		arg0_32.data[arg1_32] = var0_32
	end

	return arg2_32 and var0_32 or var0_32:clone()
end

function var0_0.GetChapterItemById(arg0_33, arg1_33)
	if Chapter:bindConfigTable()[arg1_33] then
		return arg0_33:getChapterById(arg1_33, true)
	elseif ChapterStoryGroup:bindConfigTable()[arg1_33] then
		local var0_33 = arg0_33.chapterStoryGroups[arg1_33]

		if not var0_33 then
			var0_33 = ChapterStoryGroup.New({
				configId = arg1_33
			})
			arg0_33.chapterStoryGroups[arg1_33] = var0_33
		end

		return var0_33
	end
end

function var0_0.updateChapter(arg0_34, arg1_34, arg2_34)
	assert(isa(arg1_34, Chapter), "should be an instance of Chapter")

	local var0_34 = arg0_34.data[arg1_34.id]
	local var1_34 = arg1_34

	arg0_34.data[arg1_34.id] = var1_34

	if var0_34 then
		arg0_34:removeChapterListener(var0_34.id)
	end

	arg0_34:addChapterListener(var1_34)

	if getProxy(PlayerProxy):getInited() then
		arg0_34.facade:sendNotification(var0_0.CHAPTER_UPDATED, {
			chapter = var1_34:clone(),
			dirty = defaultValue(arg2_34, 0)
		})
	end

	if var1_34.active and var1_34.fleet then
		var1_34.fleet:clearShipHpChange()
	end

	if tobool(checkExist(var0_34, {
		"active"
	})) ~= tobool(var1_34.active) then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
	end
end

function var0_0.getMapById(arg0_35, arg1_35)
	return arg0_35.baseMaps[arg1_35]
end

function var0_0.getNormalMaps(arg0_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in ipairs(arg0_36.baseMaps) do
		table.insert(var0_36, iter1_36)
	end

	return var0_36
end

function var0_0.getMapsByType(arg0_37, arg1_37)
	if var0_0.TypeToMaps[arg1_37] then
		return _.map(var0_0.TypeToMaps[arg1_37], function(arg0_38)
			return arg0_37:getMapById(arg0_38)
		end)
	else
		return {}
	end
end

function var0_0.getMapsByActId(arg0_39, arg1_39)
	if var0_0.ActToMaps[arg1_39] then
		return underscore.map(var0_0.ActToMaps[arg1_39], function(arg0_40)
			return arg0_39:getMapById(arg0_40)
		end)
	else
		return {}
	end
end

function var0_0.getRemasterMaps(arg0_41, arg1_41)
	if var0_0.RemasterToMaps[arg1_41] then
		return underscore.map(var0_0.RemasterToMaps[arg1_41], function(arg0_42)
			return arg0_41:getMapById(arg0_42)
		end)
	else
		return {}
	end
end

function var0_0.getMapsByActivities(arg0_43, arg1_43)
	local var0_43 = getProxy(ActivityProxy)
	local var1_43

	if arg1_43 then
		var1_43 = var0_43:getActivityById(arg1_43)
	else
		local var2_43 = var0_43:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

		table.sort(var2_43, CompareFuncs({
			function(arg0_44)
				return defaultValue(arg0_44:GetConfigClientSetting("order"), 1)
			end
		}))

		var1_43 = var2_43[1]
	end

	if not var1_43 then
		return {}
	end

	local var3_43 = pg.chapter_template[var1_43:getConfig("config_data")[1]].map
	local var4_43 = pg.expedition_data_by_map[var3_43].on_activity

	if getProxy(ActivityProxy):IsActivityNotEnd(var4_43) then
		return arg0_43:getMapsByActId(var4_43)
	else
		return {}
	end
end

function var0_0.getLastUnlockMap(arg0_45)
	local var0_45

	for iter0_45, iter1_45 in ipairs(arg0_45:getNormalMaps()) do
		if not iter1_45:isUnlock() then
			break
		end

		var0_45 = iter1_45
	end

	return var0_45
end

function var0_0.updateExtraFlag(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
	local var0_46 = underscore.to_array(arg1_46:getExtraFlags())
	local var1_46 = arg1_46:updateExtraFlags(arg2_46, arg3_46)

	if not arg4_46 and not var1_46 then
		return
	end

	local var2_46 = {}

	for iter0_46, iter1_46 in ipairs(arg1_46:getExtraFlags()) do
		if not table.contains(var0_46, iter1_46) then
			table.insert(var2_46, iter1_46)
		end
	end

	arg0_46:SetExtendChapterData(arg1_46.id, "extraFlagUpdate", var2_46)

	return true
end

function var0_0.extraFlagUpdated(arg0_47, arg1_47)
	arg0_47:RemoveExtendChapterData(arg1_47, "extraFlagUpdate")
end

function var0_0.getUpdatedExtraFlags(arg0_48, arg1_48)
	return arg0_48:GetExtendChapterData(arg1_48, "extraFlagUpdate")
end

function var0_0.SetExtendChapterData(arg0_49, arg1_49, arg2_49, arg3_49)
	assert(arg1_49, "Missing Chapter ID")

	arg0_49.chaptersExtend[arg1_49] = arg0_49.chaptersExtend[arg1_49] or {}
	arg0_49.chaptersExtend[arg1_49][arg2_49] = arg3_49
end

function var0_0.AddExtendChapterDataArray(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	assert(arg1_50, "Missing Chapter ID")

	arg0_50.chaptersExtend[arg1_50] = arg0_50.chaptersExtend[arg1_50] or {}

	if type(arg0_50.chaptersExtend[arg1_50][arg2_50]) ~= "table" then
		assert(arg0_50.chaptersExtend[arg1_50][arg2_50] == nil, "Changing NonEmpty ExtendData " .. arg2_50 .. " to Table ID: " .. arg1_50)

		arg0_50.chaptersExtend[arg1_50][arg2_50] = {}
	end

	arg4_50 = arg4_50 or #arg0_50.chaptersExtend[arg1_50][arg2_50] + 1
	arg0_50.chaptersExtend[arg1_50][arg2_50][arg4_50] = arg3_50
end

function var0_0.AddExtendChapterDataTable(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	assert(arg1_51, "Missing Chapter ID")

	arg0_51.chaptersExtend[arg1_51] = arg0_51.chaptersExtend[arg1_51] or {}

	if type(arg0_51.chaptersExtend[arg1_51][arg2_51]) ~= "table" then
		assert(arg0_51.chaptersExtend[arg1_51][arg2_51] == nil, "Changing NonEmpty ExtendData " .. arg2_51 .. " to Table ID: " .. arg1_51)

		arg0_51.chaptersExtend[arg1_51][arg2_51] = {}
	end

	assert(arg3_51, "Missing Index on Set HashData")

	arg0_51.chaptersExtend[arg1_51][arg2_51][arg3_51] = arg4_51
end

function var0_0.GetExtendChapterData(arg0_52, arg1_52, arg2_52)
	assert(arg1_52, "Missing Chapter ID")
	assert(arg2_52, "Requesting Empty key")

	if not arg2_52 or not arg0_52.chaptersExtend[arg1_52] then
		return
	end

	return arg0_52.chaptersExtend[arg1_52][arg2_52]
end

function var0_0.RemoveExtendChapterData(arg0_53, arg1_53, arg2_53)
	assert(arg1_53, "Missing Chapter ID")

	if not arg2_53 or not arg0_53.chaptersExtend[arg1_53] then
		return
	end

	arg0_53.chaptersExtend[arg1_53][arg2_53] = nil

	if next(arg0_53.chaptersExtend[arg1_53]) then
		return
	end

	arg0_53:RemoveExtendChapter(arg1_53)
end

function var0_0.GetExtendChapter(arg0_54, arg1_54)
	assert(arg1_54, "Missing Chapter ID")

	return arg0_54.chaptersExtend[arg1_54]
end

function var0_0.RemoveExtendChapter(arg0_55, arg1_55)
	assert(arg1_55, "Missing Chapter ID")

	if not arg0_55.chaptersExtend[arg1_55] then
		return
	end

	arg0_55.chaptersExtend[arg1_55] = nil
end

function var0_0.duplicateEliteFleet(arg0_56, arg1_56)
	if arg1_56:getConfig("type") ~= Chapter.CustomFleet and arg1_56:GetSupportFleetMaxCount() == 0 then
		return
	end

	local var0_56 = arg1_56:getConfig("formation")

	arg0_56.mapEliteFleetCache[var0_56] = Clone(arg1_56.eliteFleetList)

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter0_56, iter1_56 in ipairs(var0_0.FormationToChapters[var0_56]) do
		local var1_56 = arg0_56:getChapterById(iter1_56, true)

		if var1_56.configId ~= arg1_56.configId then
			var1_56:setEliteFleetList(Clone(arg1_56.eliteFleetList))
			arg0_56:updateChapter(var1_56)
		end
	end
end

function var0_0.RemoveUnitFromSupportFleet(arg0_57, arg1_57)
	arg0_57:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
		shipId = arg1_57.id
	})
end

function var0_0.getActiveChapter(arg0_58, arg1_58)
	for iter0_58, iter1_58 in pairs(arg0_58.data) do
		if iter1_58.active then
			return arg1_58 and iter1_58 or iter1_58:clone()
		end
	end
end

function var0_0.GetLastNormalMap(arg0_59)
	local var0_59 = Map.lastMap and arg0_59:getMapById(Map.lastMap)

	if var0_59 and var0_59:isUnlock() and var0_59:getMapType() == Map.SCENARIO then
		return Map.lastMap
	end

	return arg0_59:getLastUnlockMap().id
end

function var0_0.getLastMapForActivity(arg0_60, arg1_60)
	local var0_60
	local var1_60
	local var2_60 = arg0_60:getActiveChapter()

	if var2_60 then
		local var3_60 = arg0_60:getMapById(var2_60:getConfig("map"))

		if var3_60:isActivity() and not var3_60:isRemaster() then
			return var3_60.id, var2_60.id
		end
	end

	local var4_60 = Map.lastMapForActivity and arg0_60:getMapById(Map.lastMapForActivity)

	if var4_60 and not var4_60:isRemaster() and var4_60:isUnlock() and (not arg1_60 or var4_60:getConfig("on_activity") == arg1_60) then
		return Map.lastMapForActivity
	end

	if Map.lastMapForActivity then
		arg0_60:recordLastMap(var0_0.LAST_MAP_FOR_ACTIVITY, 0)
	end

	return arg0_60:getActivityLastUnlockMap(arg1_60)
end

function var0_0.getActivityLastUnlockMap(arg0_61, arg1_61)
	local var0_61 = arg0_61:getMapsByActivities(arg1_61)

	if not _.all(var0_61, function(arg0_62)
		return arg0_62:getConfig("type") == Map.EVENT
	end) then
		for iter0_61, iter1_61 in ipairs({
			Map.ACTIVITY_EASY,
			Map.ACTIVITY_HARD
		}) do
			local var1_61 = underscore.filter(var0_61, function(arg0_63)
				return arg0_63:getMapType() == iter1_61
			end)

			if #var1_61 > 0 and underscore.any(var1_61, function(arg0_64)
				return not arg0_64:isClearForActivity()
			end) then
				var0_61 = var1_61

				break
			end
		end
	end

	for iter2_61 = #var0_61, 1, -1 do
		local var2_61 = var0_61[iter2_61]

		if var2_61:isUnlock() then
			return var2_61.id
		end
	end

	if #var0_61 > 0 then
		return var0_61[1].id
	end
end

function var0_0.updateActiveChapterShips(arg0_65)
	local var0_65 = arg0_65:getActiveChapter(true)

	if var0_65 then
		_.each(var0_65.fleets, function(arg0_66)
			arg0_66:flushShips()
		end)
		arg0_65:updateChapter(var0_65, ChapterConst.DirtyFleet)
	end
end

function var0_0.resetRepairTimes(arg0_67)
	arg0_67.repairTimes = 0
end

function var0_0.getUseableEliteMap(arg0_68)
	local var0_68 = {}

	for iter0_68, iter1_68 in ipairs(arg0_68:getMapsByType(Map.ELITE)) do
		if iter1_68:isEliteEnabled() then
			var0_68[#var0_68 + 1] = iter1_68
		end
	end

	return var0_68
end

function var0_0.getUseableMaxEliteMap(arg0_69)
	local var0_69 = arg0_69:getUseableEliteMap()

	if #var0_69 == 0 then
		return false
	else
		local var1_69

		for iter0_69, iter1_69 in ipairs(var0_69) do
			if not var1_69 or var1_69.id < iter1_69.id then
				var1_69 = iter1_69
			end
		end

		return var1_69
	end
end

function var0_0.getHigestClearChapterAndMap(arg0_70)
	local var0_70 = arg0_70.baseMaps[1]

	for iter0_70, iter1_70 in ipairs(arg0_70:getNormalMaps()) do
		if not iter1_70:isAnyChapterClear() then
			break
		end

		var0_70 = iter1_70
	end

	local var1_70 = arg0_70:getChapterById(var0_70.chapterIds[1])

	for iter2_70, iter3_70 in ipairs(var0_70:getChapters()) do
		if not iter3_70:isClear() then
			break
		end

		var1_70 = iter3_70
	end

	return var1_70, var0_70
end

function var0_0.SortRecommendLimitation(arg0_71)
	table.sort(arg0_71, CompareFuncs({
		function(arg0_72)
			if type(arg0_72) == "number" then
				if arg0_72 == 0 then
					return 1
				else
					return -arg0_72
				end
			elseif type(arg0_72) == "string" then
				return 0
			else
				assert(false)
			end
		end
	}))
end

function var0_0.eliteFleetRecommend(arg0_73, arg1_73, arg2_73)
	local var0_73 = {}

	for iter0_73, iter1_73 in ipairs(arg1_73:getEliteFleetList()) do
		for iter2_73, iter3_73 in ipairs(iter1_73) do
			var0_73[#var0_73 + 1] = iter3_73
		end
	end

	local function var1_73(arg0_74, arg1_74, arg2_74, arg3_74)
		arg3_74 = arg3_74 or "inElite"

		return arg0_73:FleetRecommend(arg0_74, var0_73, arg2_74, arg1_74, function(arg0_75)
			return ShipStatus.ShipStatusCheck(arg3_74, arg0_75, nil, {
				[arg3_74] = arg1_73:getConfig("formation")
			})
		end)
	end

	local var2_73, var3_73 = arg1_73:getEliteTeamByIndex(arg2_73)

	table.insertto(var2_73[TeamType.FormShips], switch(var3_73, {
		[FleetType.Normal] = function()
			local var0_76 = arg1_73:getConfig("limitation")[arg2_73]
			local var1_76 = var0_76 and Clone(var0_76[1]) or {
				0,
				0,
				0
			}
			local var2_76 = var0_76 and Clone(var0_76[2]) or {
				0,
				0,
				0
			}

			var0_0.SortRecommendLimitation(var1_76)
			var0_0.SortRecommendLimitation(var2_76)

			local var3_76 = {}
			local var4_76 = getProxy(BayProxy):getRawData()

			for iter0_76, iter1_76 in pairs({
				[TeamType.Main] = {
					var1_76,
					ShipType.MainShipType
				},
				[TeamType.Vanguard] = {
					var2_76,
					ShipType.VanguardShipType
				}
			}) do
				local var5_76, var6_76 = unpack(iter1_76)

				table.insertto(var3_76, var1_73(underscore.filter(var2_73[TeamType.FormShips], function(arg0_77)
					return var4_76[arg0_77] and var4_76[arg0_77]:getTeamType() == iter0_76
				end), var5_76, var6_76))
			end

			return var3_76
		end,
		[FleetType.Submarine] = function()
			local var0_78 = {
				0,
				0,
				0
			}

			return var1_73(var2_73[TeamType.FormShips], var0_78, ShipType.SubShipType)
		end,
		[FleetType.Support] = function()
			local var0_79 = arg1_73:getConfigMiscArg("submarine_support") and {
				"qian",
				"qian",
				"qian"
			} or {
				"hang",
				"hang",
				"hang"
			}

			return var1_73(var2_73[TeamType.FormShips], var0_79, ShipType.AllShipType, "inSupport")
		end
	}))
end

function var0_0.FleetRecommend(arg0_80, arg1_80, arg2_80, arg3_80, arg4_80, arg5_80)
	arg2_80 = table.shallowCopy(arg2_80)

	local var0_80 = getProxy(BayProxy)
	local var1_80 = getProxy(BayProxy):getRawData()

	for iter0_80, iter1_80 in ipairs(arg1_80) do
		local var2_80 = var1_80[iter1_80]:getShipType()

		for iter2_80, iter3_80 in ipairs(arg4_80) do
			if ShipType.ContainInLimitBundle(iter3_80, var2_80) then
				table.remove(arg4_80, iter2_80)

				break
			end
		end
	end

	local var3_80 = {}

	local function var4_80(arg0_81)
		local var0_81 = underscore.filter(arg3_80, function(arg0_82)
			return ShipType.ContainInLimitBundle(arg0_81, arg0_82)
		end)
		local var1_81 = var0_80:GetRecommendShip(var0_81, arg2_80, arg5_80)

		if var1_81 then
			local var2_81 = var1_81.id

			arg2_80[#arg2_80 + 1] = var2_81

			table.insert(var3_80, var2_81)
		end
	end

	for iter4_80, iter5_80 in ipairs(arg4_80) do
		var4_80(iter5_80)
	end

	return var3_80
end

function var0_0.isClear(arg0_83, arg1_83)
	local var0_83 = arg0_83:GetChapterItemById(arg1_83)

	if not var0_83 then
		return false
	end

	return var0_83:isClear()
end

function var0_0.recordLastMap(arg0_84, arg1_84, arg2_84)
	local var0_84 = false

	if arg1_84 == var0_0.LAST_MAP_FOR_ACTIVITY and arg2_84 ~= Map.lastMapForActivity then
		Map.lastMapForActivity = arg2_84
		var0_84 = true
	elseif arg1_84 == var0_0.LAST_MAP and arg2_84 ~= Map.lastMap then
		Map.lastMap = arg2_84
		var0_84 = true
	end

	if var0_84 then
		local var1_84 = getProxy(PlayerProxy):getRawData()

		PlayerPrefs.SetInt(arg1_84 .. var1_84.id, arg2_84)
		PlayerPrefs.Save()
	end
end

function var0_0.getLastMap(arg0_85, arg1_85)
	local var0_85 = getProxy(PlayerProxy):getRawData()
	local var1_85 = PlayerPrefs.GetInt(arg1_85 .. var0_85.id)

	if var1_85 ~= 0 then
		return var1_85
	end
end

function var0_0.IsActivitySPChapterActive(arg0_86, arg1_86)
	local var0_86 = arg0_86:getMapsByActivities(arg1_86)
	local var1_86 = _.reduce(var0_86, {}, function(arg0_87, arg1_87)
		table.insertto(arg0_87, _.select(arg1_87:getChapters(), function(arg0_88)
			return arg0_88:IsSpChapter()
		end))

		return arg0_87
	end)

	return _.any(var1_86, function(arg0_89)
		return arg0_89:isUnlock() and arg0_89:isPlayerLVUnlock() and arg0_89:enoughTimes2Start()
	end)
end

function var0_0.getSubAidFlag(arg0_90, arg1_90)
	local var0_90 = ys.Battle.BattleConst.SubAidFlag
	local var1_90 = arg0_90.fleet
	local var2_90 = false
	local var3_90 = _.detect(arg0_90.fleets, function(arg0_91)
		return arg0_91:getFleetType() == FleetType.Submarine and arg0_91:isValid()
	end)

	if var3_90 then
		if var3_90:inHuntingRange(var1_90.line.row, var1_90.line.column) then
			var2_90 = true
		else
			local var4_90 = var3_90:getStrategies()
			local var5_90 = _.detect(var4_90, function(arg0_92)
				return arg0_92.id == ChapterConst.StrategyCallSubOutofRange
			end)

			if var5_90 and var5_90.count > 0 then
				var2_90 = true
			end
		end
	end

	if var2_90 then
		local var6_90 = getProxy(PlayerProxy):getRawData()
		local var7_90, var8_90 = arg0_90:getFleetCost(var1_90, arg1_90)
		local var9_90, var10_90 = arg0_90:getFleetAmmo(var3_90)
		local var11_90 = 0

		for iter0_90, iter1_90 in ipairs({
			arg0_90:getFleetCost(var3_90, arg1_90)
		}) do
			var11_90 = var11_90 + iter1_90.oil
		end

		if var10_90 <= 0 then
			return var0_90.AMMO_EMPTY
		elseif var11_90 + var8_90.oil >= var6_90.oil then
			return var0_90.OIL_EMPTY
		else
			return true, var3_90
		end
	else
		return var0_90.AID_EMPTY
	end
end

function var0_0.GetChapterAuraBuffs(arg0_93)
	local var0_93 = {}

	for iter0_93, iter1_93 in ipairs(arg0_93.fleets) do
		if iter1_93:getFleetType() ~= FleetType.Support then
			local var1_93 = iter1_93:getMapAura()

			for iter2_93, iter3_93 in ipairs(var1_93) do
				table.insert(var0_93, iter3_93)
			end
		end
	end

	return var0_93
end

function var0_0.GetChapterAidBuffs(arg0_94)
	local var0_94 = {}

	for iter0_94, iter1_94 in ipairs(arg0_94.fleets) do
		if iter1_94 ~= arg0_94.fleet and iter1_94:getFleetType() ~= FleetType.Support then
			local var1_94 = iter1_94:getMapAid()

			for iter2_94, iter3_94 in pairs(var1_94) do
				var0_94[iter2_94] = iter3_94
			end
		end
	end

	return var0_94
end

function var0_0.RecordComboHistory(arg0_95, arg1_95, arg2_95)
	if arg2_95 ~= nil then
		arg0_95:SetExtendChapterData(arg1_95, "comboHistoryBuffer", arg2_95)
	else
		arg0_95:RemoveExtendChapterData(arg1_95, "comboHistoryBuffer")
	end
end

function var0_0.GetComboHistory(arg0_96, arg1_96)
	return arg0_96:GetExtendChapterData(arg1_96, "comboHistoryBuffer")
end

function var0_0.RecordJustClearChapters(arg0_97, arg1_97, arg2_97)
	if arg2_97 ~= nil then
		arg0_97:SetExtendChapterData(arg1_97, "justClearChapters", arg2_97)
	else
		arg0_97:RemoveExtendChapterData(arg1_97, "justClearChapters")
	end
end

function var0_0.GetJustClearChapters(arg0_98, arg1_98)
	return arg0_98:GetExtendChapterData(arg1_98, "justClearChapters")
end

function var0_0.RecordLastDefeatedEnemy(arg0_99, arg1_99, arg2_99)
	if arg2_99 ~= nil then
		arg0_99:SetExtendChapterData(arg1_99, "defeatedEnemiesBuffer", arg2_99)
	else
		arg0_99:RemoveExtendChapterData(arg1_99, "defeatedEnemiesBuffer")
	end
end

function var0_0.GetLastDefeatedEnemy(arg0_100, arg1_100)
	return arg0_100:GetExtendChapterData(arg1_100, "defeatedEnemiesBuffer")
end

function var0_0.ifShowRemasterTip(arg0_101)
	return arg0_101.remasterTip
end

function var0_0.setRemasterTip(arg0_102, arg1_102)
	arg0_102.remasterTip = arg1_102
end

function var0_0.updateRemasterTicketsNum(arg0_103, arg1_103)
	arg0_103.remasterTickets = arg1_103
end

function var0_0.getRemasterTicketCost(arg0_104)
	return 5
end

function var0_0.resetDailyCount(arg0_105)
	arg0_105.remasterDailyCount = 0
end

function var0_0.updateDailyCount(arg0_106)
	arg0_106.remasterDailyCount = arg0_106.remasterDailyCount + pg.gameset.reactivity_ticket_daily.key_value
end

function var0_0.GetSkipPrecombat(arg0_107)
	if arg0_107.skipPrecombat == nil then
		arg0_107.skipPrecombat = PlayerPrefs.GetInt("chapter_skip_precombat", 0)
	end

	return arg0_107.skipPrecombat > 0
end

function var0_0.UpdateSkipPrecombat(arg0_108, arg1_108)
	arg1_108 = tobool(arg1_108) and 1 or 0

	if arg1_108 ~= arg0_108:GetSkipPrecombat() then
		PlayerPrefs.SetInt("chapter_skip_precombat", arg1_108)

		arg0_108.skipPrecombat = arg1_108

		arg0_108:sendNotification(var0_0.CHAPTER_SKIP_PRECOMBAT_UPDATED, arg1_108)
	end
end

function var0_0.GetChapterAutoFlag(arg0_109, arg1_109)
	return arg0_109:GetExtendChapterData(arg1_109, "AutoFightFlag")
end

function var0_0.SetChapterAutoFlag(arg0_110, arg1_110, arg2_110, arg3_110)
	arg2_110 = tobool(arg2_110)

	if arg2_110 == (arg0_110:GetChapterAutoFlag(arg1_110) == 1) then
		return
	end

	arg0_110:SetExtendChapterData(arg1_110, "AutoFightFlag", arg2_110 and 1 or 0)

	if arg2_110 then
		arg0_110:UpdateSkipPrecombat(true)

		if AutoBotCommand.autoBotSatisfied() then
			PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(), 1)
		end

		getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(true)

		if not LOCK_BATTERY_SAVEMODE and PlayerPrefs.GetInt(AUTOFIGHT_BATTERY_SAVEMODE, 0) == 1 and pg.BrightnessMgr.GetInstance():IsPermissionGranted() then
			pg.BrightnessMgr.GetInstance():EnterManualMode()

			if PlayerPrefs.GetInt(AUTOFIGHT_DOWN_FRAME, 0) == 1 then
				getProxy(SettingsProxy):RecordFrameRate()

				Application.targetFrameRate = 30
			end
		end
	else
		arg0_110:StopContinuousOperation(SYSTEM_SCENARIO, arg3_110)
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end
	end

	arg0_110.facade:sendNotification(var0_0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED, arg2_110 and 1 or 0)
	arg0_110.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, not arg2_110)
end

function var0_0.StopAutoFight(arg0_111, arg1_111)
	local var0_111 = arg0_111:getActiveChapter(true)

	if not var0_111 then
		return
	end

	arg0_111:SetChapterAutoFlag(var0_111.id, false, arg1_111)
end

function var0_0.FinishAutoFight(arg0_112, arg1_112)
	if arg0_112:GetChapterAutoFlag(arg1_112) == 1 then
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end

		arg0_112.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
	end

	local var0_112 = arg0_112:GetExtendChapter(arg1_112)

	arg0_112:RemoveExtendChapter(arg1_112)

	return var0_112
end

function var0_0.buildRemasterInfo(arg0_113)
	arg0_113.remasterInfo = {}

	for iter0_113, iter1_113 in ipairs(pg.re_map_template.all) do
		local var0_113 = pg.re_map_template[iter1_113]
		local var1_113 = var0_113.activity_id or 0

		for iter2_113, iter3_113 in ipairs(var0_113.drop_gain) do
			if #iter3_113 > 0 then
				local var2_113, var3_113, var4_113, var5_113 = unpack(iter3_113)

				arg0_113.remasterInfo[var1_113] = defaultValue(arg0_113.remasterInfo[var1_113], {})
				arg0_113.remasterInfo[var1_113][var2_113] = defaultValue(arg0_113.remasterInfo[var1_113][var2_113], {})
				arg0_113.remasterInfo[var1_113][var2_113][iter2_113] = {
					count = 0,
					receive = false,
					max = var5_113
				}
			end
		end
	end
end

function var0_0.checkRemasterInfomation(arg0_114)
	if not arg0_114.checkRemaster then
		arg0_114.checkRemaster = true

		arg0_114:sendNotification(GAME.CHAPTER_REMASTER_INFO_REQUEST)
	end
end

function var0_0.getRemasterInfo(arg0_115, arg1_115, arg2_115, arg3_115)
	arg1_115 = arg1_115 or 0

	local var0_115 = arg0_115.remasterInfo and arg0_115.remasterInfo[arg1_115]

	if not var0_115 then
		return nil
	end

	local var1_115 = var0_115[arg2_115]

	if not var1_115 then
		return nil
	end

	if arg3_115 then
		return var1_115[arg3_115]
	end

	return var1_115
end

function var0_0.addRemasterPassCount(arg0_116, arg1_116, arg2_116, arg3_116)
	local var0_116 = arg3_116 or 1
	local var1_116 = arg0_116:getRemasterInfo(arg2_116, arg1_116)

	if not var1_116 then
		return
	end

	local var2_116

	for iter0_116, iter1_116 in pairs(var1_116) do
		if iter1_116.count < iter1_116.max then
			iter1_116.count = iter1_116.count + var0_116
			var2_116 = true
		end
	end

	if var2_116 then
		arg0_116:sendNotification(var0_0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0_0.markRemasterPassReceive(arg0_117, arg1_117, arg2_117, arg3_117)
	local var0_117 = arg0_117:getRemasterInfo(arg3_117, arg1_117, arg2_117)

	if not var0_117 then
		return
	end

	if not var0_117.receive then
		var0_117.receive = true

		arg0_117:sendNotification(var0_0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0_0.anyRemasterAwardCanReceive(arg0_118)
	for iter0_118, iter1_118 in pairs(arg0_118.remasterInfo) do
		for iter2_118, iter3_118 in pairs(iter1_118) do
			for iter4_118, iter5_118 in pairs(iter3_118) do
				if not iter5_118.receive and iter5_118.count >= iter5_118.max then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.AddActBossRewards(arg0_119, arg1_119)
	arg0_119.actBossItems = arg0_119.actBossItems or {}

	table.insertto(arg0_119.actBossItems, arg1_119)
end

function var0_0.PopActBossRewards(arg0_120)
	local var0_120 = arg0_120.actBossItems or {}

	arg0_120.actBossItems = nil

	return var0_120
end

function var0_0.AddBossSingleRewards(arg0_121, arg1_121)
	arg0_121.bossSingleItems = arg0_121.bossSingleItems or {}

	table.insertto(arg0_121.bossSingleItems, arg1_121)
end

function var0_0.PopBossSingleRewards(arg0_122)
	local var0_122 = arg0_122.bossSingleItems or {}

	arg0_122.bossSingleItems = nil

	return var0_122
end

function var0_0.WriteBackOnExitBattleResult(arg0_123)
	local var0_123 = arg0_123:getActiveChapter()

	if var0_123 then
		if var0_123:existOni() then
			var0_123:clearSubmarineFleet()
			arg0_123:updateChapter(var0_123)
		elseif var0_123:isPlayingWithBombEnemy() then
			var0_123.fleets = {
				var0_123.fleet
			}
			var0_123.findex = 1

			arg0_123:updateChapter(var0_123)
		end
	end
end

function var0_0.GetContinuousData(arg0_124, arg1_124)
	return arg0_124.continuousData[arg1_124]
end

function var0_0.InitContinuousTime(arg0_125, arg1_125, arg2_125)
	local var0_125 = ContinuousOperationRuntimeData.New({
		system = arg1_125,
		totalBattleTime = arg2_125,
		battleTime = arg2_125
	})

	arg0_125.continuousData[arg1_125] = var0_125
end

function var0_0.StopContinuousOperation(arg0_126, arg1_126, arg2_126)
	local var0_126 = arg0_126:GetContinuousData(arg1_126)

	if not var0_126 or not var0_126:IsActive() then
		return
	end

	if arg2_126 == ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL and arg1_126 == SYSTEM_SCENARIO then
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_stop"))
	end

	var0_126:Stop(arg2_126)
end

function var0_0.PopContinuousData(arg0_127, arg1_127)
	local var0_127 = arg0_127.continuousData[arg1_127]

	arg0_127.continuousData[arg1_127] = nil

	return var0_127
end

function var0_0.SetLastFleetIndex(arg0_128, arg1_128, arg2_128)
	if arg2_128 and arg0_128.lastFleetIndex then
		return
	end

	arg0_128.lastFleetIndex = arg1_128
end

function var0_0.GetLastFleetIndex(arg0_129)
	return arg0_129.lastFleetIndex
end

function var0_0.RemoveEliteFleetCommander(arg0_130, arg1_130)
	local var0_130 = {}

	for iter0_130, iter1_130 in ipairs(arg1_130) do
		var0_130[iter1_130] = true
	end

	local var1_130 = {}

	for iter2_130, iter3_130 in pairs(arg0_130.mapEliteFleetCache) do
		for iter4_130, iter5_130 in pairs(iter3_130) do
			for iter6_130, iter7_130 in ipairs(iter5_130) do
				for iter8_130, iter9_130 in ipairs(iter7_130[TeamType.FormCommander]) do
					if var0_130[iter9_130] then
						iter7_130[TeamType.FormCommander][iter8_130] = 0
						var1_130[iter2_130] = true
					end
				end
			end
		end
	end

	for iter10_130, iter11_130 in pairs(arg0_130.data) do
		local var2_130 = iter11_130:getConfig("formation")

		if var1_130[var2_130] then
			iter11_130:setEliteFleetList(Clone(arg0_130.mapEliteFleetCache[var2_130]))
			arg0_130:updateChapter(iter11_130)
		end
	end
end

function var0_0.GetAutoChapterId(arg0_131)
	local var0_131 = getProxy(ChapterAutoProxy):GetCommissionList()

	if #var0_131 == 0 then
		return nil
	end

	local var1_131 = var0_131[1]

	if var1_131.type ~= ChapterAutoProxy.TYPE.SLG then
		return nil
	end

	return var1_131.id
end

return var0_0
