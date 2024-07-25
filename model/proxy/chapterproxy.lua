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
		arg0_1.mapEliteCommanderCache = {}
		arg0_1.mapSupportFleetCache = {}

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.fleet_list) do
			var0_2[iter1_2.map_id] = var0_2[iter1_2.map_id] or {}

			table.insert(var0_2[iter1_2.map_id], iter1_2)
		end

		for iter2_2, iter3_2 in pairs(var0_2) do
			arg0_1.mapEliteFleetCache[iter2_2], arg0_1.mapEliteCommanderCache[iter2_2], arg0_1.mapSupportFleetCache[iter2_2] = Chapter.BuildEliteFleetList(iter3_2)
		end

		for iter4_2, iter5_2 in ipairs(arg0_2.chapter_list) do
			if not pg.chapter_template[iter5_2.id] then
				errorMsg("chapter_template not exist: " .. iter5_2.id)
			else
				local var1_2 = Chapter.New(iter5_2)
				local var2_2 = var1_2:getConfig("formation")

				var1_2:setEliteFleetList(Clone(arg0_1.mapEliteFleetCache[var2_2]) or {
					{},
					{},
					{}
				})
				var1_2:setEliteCommanders(Clone(arg0_1.mapEliteCommanderCache[var2_2]) or {
					{},
					{},
					{}
				})
				var1_2:setSupportFleetList(Clone(arg0_1.mapSupportFleetCache[var2_2]) or {
					{}
				})
				arg0_1:updateChapter(var1_2)
			end
		end

		if arg0_2.current_chapter then
			local var3_2 = arg0_2.current_chapter.id

			if var3_2 > 0 then
				local var4_2 = arg0_1:getChapterById(var3_2, true)

				var4_2:update(arg0_2.current_chapter)
				arg0_1:updateChapter(var4_2)
			end
		end

		arg0_1.repairTimes = arg0_2.daily_repair_count

		if arg0_2.react_chapter then
			arg0_1.remasterTickets = arg0_2.react_chapter.count
			arg0_1.remasterDailyCount = arg0_2.react_chapter.daily_count
			arg0_1.remasterTip = not (arg0_1.remasterDailyCount > 0)
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

function var0_0.timeCall(arg0_3)
	return {
		[ProxyRegister.DayCall] = function(arg0_4)
			arg0_3:resetRepairTimes()
			arg0_3:resetEscortChallengeTimes()

			local var0_4 = arg0_3:getData()

			for iter0_4, iter1_4 in pairs(var0_4) do
				if iter1_4.todayDefeatCount > 0 then
					iter1_4.todayDefeatCount = 0

					arg0_3:updateChapter(iter1_4)
				end
			end

			arg0_3:resetDailyCount()
		end
	}
end

function var0_0.OnBattleFinished(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:getActiveChapter()

	if var0_5 then
		local var1_5 = 0

		local function var2_5()
			local var0_6 = getProxy(ContextProxy)

			if not var0_6 then
				return
			end

			if var0_6:getCurrentContext().mediator == LevelMediator2 then
				var1_5 = bit.bor(var1_5, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

				arg0_5:SetChapterAutoFlag(var0_5.id, false)

				return
			end

			local var1_6 = var0_6:getContextByMediator(LevelMediator2)

			if not var1_6 then
				return
			end

			var1_6.data.StopAutoFightFlag = true
		end

		if _.any(arg1_5.ai_list, function(arg0_7)
			return arg0_7.item_type == ChapterConst.AttachOni
		end) then
			var0_5:onOniEnter()
			var2_5()
		end

		if _.any(arg1_5.map_update, function(arg0_8)
			return arg0_8.item_type == ChapterConst.AttachBomb_Enemy
		end) then
			var0_5:onBombEnemyEnter()
			var2_5()
		end

		if #arg1_5.map_update > 0 then
			_.each(arg1_5.map_update, function(arg0_9)
				if arg0_9.item_type == ChapterConst.AttachStory and arg0_9.item_data == ChapterConst.StoryTrigger then
					local var0_9 = ChapterCell.Line2Name(arg0_9.pos.row, arg0_9.pos.column)
					local var1_9 = var0_5:GetChapterCellAttachemnts()
					local var2_9 = var1_9[var0_9]

					if var2_9 then
						if var2_9.flag == ChapterConst.CellFlagTriggerActive and arg0_9.item_flag == ChapterConst.CellFlagTriggerDisabled then
							local var3_9 = pg.map_event_template[var2_9.attachmentId].gametip

							if var3_9 ~= "" then
								pg.TipsMgr.GetInstance():ShowTips(i18n(var3_9))
							end
						end

						var2_9.attachment = arg0_9.item_type
						var2_9.attachmentId = arg0_9.item_id
						var2_9.flag = arg0_9.item_flag
						var2_9.data = arg0_9.item_data
					else
						var1_9[var0_9] = ChapterCell.New(arg0_9)
					end
				elseif arg0_9.item_type ~= ChapterConst.AttachNone and arg0_9.item_type ~= ChapterConst.AttachBorn and arg0_9.item_type ~= ChapterConst.AttachBorn_Sub and arg0_9.item_type ~= ChapterConst.AttachOni_Target and arg0_9.item_type ~= ChapterConst.AttachOni then
					local var4_9 = ChapterCell.New(arg0_9)

					var0_5:mergeChapterCell(var4_9)
				end
			end)

			var1_5 = bit.bor(var1_5, ChapterConst.DirtyAttachment, ChapterConst.DirtyAutoAction)
		end

		if #arg1_5.ai_list > 0 then
			_.each(arg1_5.ai_list, function(arg0_10)
				local var0_10 = ChapterChampionPackage.New(arg0_10)

				var0_5:mergeChampion(var0_10)
			end)

			var1_5 = bit.bor(var1_5, ChapterConst.DirtyChampion, ChapterConst.DirtyAutoAction)
		end

		if #arg1_5.add_flag_list > 0 or #arg1_5.del_flag_list > 0 then
			var1_5 = bit.bor(var1_5, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)

			arg0_5:updateExtraFlag(var0_5, arg1_5.add_flag_list, arg1_5.del_flag_list)
		end

		if #arg1_5.buff_list > 0 then
			var0_5:UpdateBuffList(arg1_5.buff_list)
		end

		if #arg1_5.cell_flag_list > 0 then
			_.each(arg1_5.cell_flag_list, function(arg0_11)
				local var0_11 = var0_5:getChapterCell(arg0_11.pos.row, arg0_11.pos.column)

				if var0_11 then
					var0_11:updateFlagList(arg0_11)
				else
					var0_11 = ChapterCell.New(arg0_11)
				end

				var0_5:updateChapterCell(var0_11)
			end)

			var1_5 = bit.bor(var1_5, ChapterConst.DirtyCellFlag)
		end

		arg0_5:updateChapter(var0_5, var1_5)

		if arg2_5 then
			arg0_5:sendNotification(GAME.CHAPTER_OP_DONE, {
				type = ChapterConst.OpSkipBattle
			})
		end
	end
end

function var0_0.setEliteCache(arg0_12, arg1_12)
	arg0_12.mapEliteFleetCache = {}
	arg0_12.mapEliteCommanderCache = {}
	arg0_12.mapSupportFleetCache = {}

	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		var0_12[iter1_12.map_id] = var0_12[iter1_12.map_id] or {}

		table.insert(var0_12[iter1_12.map_id], iter1_12)
	end

	for iter2_12, iter3_12 in pairs(var0_12) do
		arg0_12.mapEliteFleetCache[iter2_12], arg0_12.mapEliteCommanderCache[iter2_12], arg0_12.mapSupportFleetCache[iter2_12] = Chapter.BuildEliteFleetList(iter3_12)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter4_12, iter5_12 in pairs(arg0_12.data) do
		local var1_12 = iter5_12:getConfig("formation")

		iter5_12:setEliteFleetList(Clone(arg0_12.mapEliteFleetCache[var1_12]) or {
			{},
			{},
			{}
		})
		iter5_12:setEliteCommanders(Clone(arg0_12.mapEliteCommanderCache[var1_12]) or {
			{},
			{},
			{}
		})
		iter5_12:setSupportFleetList(Clone(arg0_12.mapSupportFleetCache[var1_12]) or {
			{},
			{},
			{}
		})
		arg0_12:updateChapter(iter5_12)
	end
end

function var0_0.buildMaps(arg0_13)
	arg0_13:initChapters()
	arg0_13:buildBaseMaps()
	arg0_13:buildRemasterMaps()
end

function var0_0.initChapters(arg0_14)
	var0_0.MapToChapters = table.shallowCopy(pg.chapter_template.get_id_list_by_map)

	for iter0_14, iter1_14 in pairs(pg.story_group.get_id_list_by_map) do
		var0_0.MapToChapters[iter0_14] = var0_0.MapToChapters[iter0_14] or {}
		var0_0.MapToChapters[iter0_14] = table.mergeArray(var0_0.MapToChapters[iter0_14], iter1_14)
	end

	var0_0.FormationToChapters = pg.chapter_template.get_id_list_by_formation
end

function var0_0.buildBaseMaps(arg0_15)
	var0_0.ActToMaps = {}
	var0_0.TypeToMaps = {}

	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(pg.expedition_data_by_map.all) do
		local var1_15 = Map.New({
			id = iter1_15,
			chapterIds = var0_0.MapToChapters[iter1_15]
		})

		var0_15[iter1_15] = var1_15

		local var2_15 = var1_15:getConfig("on_activity")

		if var2_15 ~= 0 then
			var0_0.ActToMaps[var2_15] = var0_0.ActToMaps[var2_15] or {}

			table.insert(var0_0.ActToMaps[var2_15], var1_15.id)
		end

		local var3_15 = var1_15:getMapType()

		var0_0.TypeToMaps[var3_15] = var0_0.TypeToMaps[var3_15] or {}

		table.insert(var0_0.TypeToMaps[var3_15], var1_15.id)
	end

	arg0_15.baseMaps = var0_15
end

function var0_0.buildRemasterMaps(arg0_16)
	var0_0.RemasterToMaps = {}

	local var0_16 = {}

	_.each(pg.re_map_template.all, function(arg0_17)
		local var0_17 = pg.re_map_template[arg0_17]

		_.each(var0_17.config_data, function(arg0_18)
			local var0_18 = arg0_16.baseMaps[pg.chapter_template[arg0_18].map]

			assert(not var0_16[var0_18.id] or var0_16[var0_18.id] == arg0_17, "remaster chapter error:" .. arg0_18)

			if not var0_16[var0_18.id] then
				var0_16[var0_18.id] = arg0_17

				var0_18:setRemaster(arg0_17)

				var0_0.RemasterToMaps[arg0_17] = var0_0.RemasterToMaps[arg0_17] or {}

				table.insert(var0_0.RemasterToMaps[arg0_17], var0_18.id)
			end
		end)
	end)
end

function var0_0.IsChapterInRemaster(arg0_19, arg1_19)
	return _.detect(pg.re_map_template.all, function(arg0_20)
		local var0_20 = pg.re_map_template[arg0_20]

		return _.any(var0_20.config_data, function(arg0_21)
			return arg0_21 == arg1_19
		end)
	end)
end

function var0_0.getMaxEscortChallengeTimes(arg0_22)
	return getProxy(ActivityProxy):getActivityParameter("escort_daily_count") or 0
end

function var0_0.getEscortChapterIds(arg0_23)
	return getProxy(ActivityProxy):getActivityParameter("escort_exp_id") or {}
end

function var0_0.resetEscortChallengeTimes(arg0_24)
	arg0_24.escortChallengeTimes = 0
end

function var0_0.addChapterListener(arg0_25, arg1_25)
	if not arg1_25.dueTime or not arg0_25.timers then
		return
	end

	if arg0_25.timers[arg1_25.id] then
		arg0_25.timers[arg1_25.id]:Stop()

		arg0_25.timers[arg1_25.id] = nil
	end

	local var0_25 = arg1_25.dueTime - pg.TimeMgr.GetInstance():GetServerTime()

	local function var1_25()
		arg0_25.data[arg1_25.id].dueTime = nil

		arg0_25.data[arg1_25.id]:display("times'up")
		arg0_25:sendNotification(var0_0.CHAPTER_UPDATED, {
			dirty = 0,
			chapter = arg0_25.data[arg1_25.id]:clone()
		})
		arg0_25:sendNotification(var0_0.CHAPTER_TIMESUP)
	end

	if var0_25 > 0 then
		arg0_25.timers[arg1_25.id] = Timer.New(function()
			var1_25()
			arg0_25.timers[arg1_25.id]:Stop()

			arg0_25.timers[arg1_25.id] = nil
		end, var0_25, 1)

		arg0_25.timers[arg1_25.id]:Start()
	else
		var1_25()
	end
end

function var0_0.removeChapterListener(arg0_28, arg1_28)
	if arg0_28.timers[arg1_28] then
		arg0_28.timers[arg1_28]:Stop()

		arg0_28.timers[arg1_28] = nil
	end
end

function var0_0.remove(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.timers) do
		iter1_29:Stop()
	end

	arg0_29.timers = nil
end

function var0_0.GetRawChapterById(arg0_30, arg1_30)
	return arg0_30.data[arg1_30]
end

function var0_0.getChapterById(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.data[arg1_31]

	if not var0_31 then
		assert(pg.chapter_template[arg1_31], "Not Exist Chapter ID: " .. (arg1_31 or "NIL"))

		var0_31 = Chapter.New({
			id = arg1_31
		})

		local var1_31 = var0_31:getConfig("formation")

		if var0_31:getConfig("type") == Chapter.CustomFleet then
			var0_31:setEliteFleetList(Clone(arg0_31.mapEliteFleetCache[var1_31]) or {
				{},
				{},
				{}
			})
			var0_31:setEliteCommanders(Clone(arg0_31.mapEliteCommanderCache[var1_31]) or {
				{},
				{},
				{}
			})
		elseif var0_31:getConfig("type") == Chapter.SelectFleet then
			var0_31:setSupportFleetList(Clone(arg0_31.mapSupportFleetCache[var1_31]) or {
				{},
				{},
				{}
			})
		end

		arg0_31.data[arg1_31] = var0_31
	end

	return arg2_31 and var0_31 or var0_31:clone()
end

function var0_0.GetChapterItemById(arg0_32, arg1_32)
	if Chapter:bindConfigTable()[arg1_32] then
		return arg0_32:getChapterById(arg1_32, true)
	elseif ChapterStoryGroup:bindConfigTable()[arg1_32] then
		local var0_32 = arg0_32.chapterStoryGroups[arg1_32]

		if not var0_32 then
			var0_32 = ChapterStoryGroup.New({
				configId = arg1_32
			})
			arg0_32.chapterStoryGroups[arg1_32] = var0_32
		end

		return var0_32
	end
end

function var0_0.updateChapter(arg0_33, arg1_33, arg2_33)
	assert(isa(arg1_33, Chapter), "should be an instance of Chapter")

	local var0_33 = arg0_33.data[arg1_33.id]
	local var1_33 = arg1_33

	arg0_33.data[arg1_33.id] = var1_33

	if var0_33 then
		arg0_33:removeChapterListener(var0_33.id)
	end

	arg0_33:addChapterListener(var1_33)

	if getProxy(PlayerProxy):getInited() then
		arg0_33.facade:sendNotification(var0_0.CHAPTER_UPDATED, {
			chapter = var1_33:clone(),
			dirty = defaultValue(arg2_33, 0)
		})
	end

	if var1_33.active and var1_33.fleet then
		var1_33.fleet:clearShipHpChange()
	end

	if tobool(checkExist(var0_33, {
		"active"
	})) ~= tobool(var1_33.active) then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
	end
end

function var0_0.getMapById(arg0_34, arg1_34)
	return arg0_34.baseMaps[arg1_34]
end

function var0_0.getNormalMaps(arg0_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.baseMaps) do
		table.insert(var0_35, iter1_35)
	end

	return var0_35
end

function var0_0.getMapsByType(arg0_36, arg1_36)
	if var0_0.TypeToMaps[arg1_36] then
		return _.map(var0_0.TypeToMaps[arg1_36], function(arg0_37)
			return arg0_36:getMapById(arg0_37)
		end)
	else
		return {}
	end
end

function var0_0.getMapsByActId(arg0_38, arg1_38)
	if var0_0.ActToMaps[arg1_38] then
		return underscore.map(var0_0.ActToMaps[arg1_38], function(arg0_39)
			return arg0_38:getMapById(arg0_39)
		end)
	else
		return {}
	end
end

function var0_0.getRemasterMaps(arg0_40, arg1_40)
	if var0_0.RemasterToMaps[arg1_40] then
		return underscore.map(var0_0.RemasterToMaps[arg1_40], function(arg0_41)
			return arg0_40:getMapById(arg0_41)
		end)
	else
		return {}
	end
end

function var0_0.getMapsByActivities(arg0_42)
	local var0_42 = {}
	local var1_42 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

	underscore.each(var1_42, function(arg0_43)
		if not arg0_43:isEnd() then
			var0_42 = table.mergeArray(var0_42, arg0_42:getMapsByActId(arg0_43.id))
		end
	end)

	return var0_42
end

function var0_0.getLastUnlockMap(arg0_44)
	local var0_44

	for iter0_44, iter1_44 in ipairs(arg0_44:getNormalMaps()) do
		if not iter1_44:isUnlock() then
			break
		end

		var0_44 = iter1_44
	end

	return var0_44
end

function var0_0.updateExtraFlag(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45)
	local var0_45 = arg1_45:updateExtraFlags(arg2_45, arg3_45)

	if not arg4_45 and not var0_45 then
		return
	end

	local var1_45 = {}

	for iter0_45, iter1_45 in ipairs(arg2_45) do
		table.insert(var1_45, iter1_45)
	end

	arg0_45:SetExtendChapterData(arg1_45.id, "extraFlagUpdate", var1_45)

	return true
end

function var0_0.extraFlagUpdated(arg0_46, arg1_46)
	arg0_46:RemoveExtendChapterData(arg1_46, "extraFlagUpdate")
end

function var0_0.getUpdatedExtraFlags(arg0_47, arg1_47)
	return arg0_47:GetExtendChapterData(arg1_47, "extraFlagUpdate")
end

function var0_0.SetExtendChapterData(arg0_48, arg1_48, arg2_48, arg3_48)
	assert(arg1_48, "Missing Chapter ID")

	arg0_48.chaptersExtend[arg1_48] = arg0_48.chaptersExtend[arg1_48] or {}
	arg0_48.chaptersExtend[arg1_48][arg2_48] = arg3_48
end

function var0_0.AddExtendChapterDataArray(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	assert(arg1_49, "Missing Chapter ID")

	arg0_49.chaptersExtend[arg1_49] = arg0_49.chaptersExtend[arg1_49] or {}

	if type(arg0_49.chaptersExtend[arg1_49][arg2_49]) ~= "table" then
		assert(arg0_49.chaptersExtend[arg1_49][arg2_49] == nil, "Changing NonEmpty ExtendData " .. arg2_49 .. " to Table ID: " .. arg1_49)

		arg0_49.chaptersExtend[arg1_49][arg2_49] = {}
	end

	arg4_49 = arg4_49 or #arg0_49.chaptersExtend[arg1_49][arg2_49] + 1
	arg0_49.chaptersExtend[arg1_49][arg2_49][arg4_49] = arg3_49
end

function var0_0.AddExtendChapterDataTable(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	assert(arg1_50, "Missing Chapter ID")

	arg0_50.chaptersExtend[arg1_50] = arg0_50.chaptersExtend[arg1_50] or {}

	if type(arg0_50.chaptersExtend[arg1_50][arg2_50]) ~= "table" then
		assert(arg0_50.chaptersExtend[arg1_50][arg2_50] == nil, "Changing NonEmpty ExtendData " .. arg2_50 .. " to Table ID: " .. arg1_50)

		arg0_50.chaptersExtend[arg1_50][arg2_50] = {}
	end

	assert(arg3_50, "Missing Index on Set HashData")

	arg0_50.chaptersExtend[arg1_50][arg2_50][arg3_50] = arg4_50
end

function var0_0.GetExtendChapterData(arg0_51, arg1_51, arg2_51)
	assert(arg1_51, "Missing Chapter ID")
	assert(arg2_51, "Requesting Empty key")

	if not arg2_51 or not arg0_51.chaptersExtend[arg1_51] then
		return
	end

	return arg0_51.chaptersExtend[arg1_51][arg2_51]
end

function var0_0.RemoveExtendChapterData(arg0_52, arg1_52, arg2_52)
	assert(arg1_52, "Missing Chapter ID")

	if not arg2_52 or not arg0_52.chaptersExtend[arg1_52] then
		return
	end

	arg0_52.chaptersExtend[arg1_52][arg2_52] = nil

	if next(arg0_52.chaptersExtend[arg1_52]) then
		return
	end

	arg0_52:RemoveExtendChapter(arg1_52)
end

function var0_0.GetExtendChapter(arg0_53, arg1_53)
	assert(arg1_53, "Missing Chapter ID")

	return arg0_53.chaptersExtend[arg1_53]
end

function var0_0.RemoveExtendChapter(arg0_54, arg1_54)
	assert(arg1_54, "Missing Chapter ID")

	if not arg0_54.chaptersExtend[arg1_54] then
		return
	end

	arg0_54.chaptersExtend[arg1_54] = nil
end

function var0_0.duplicateEliteFleet(arg0_55, arg1_55)
	if arg1_55:getConfig("type") ~= Chapter.CustomFleet then
		return
	end

	local var0_55 = arg1_55:getEliteFleetList()
	local var1_55 = arg1_55:getEliteFleetCommanders()
	local var2_55 = arg1_55:getConfig("formation")

	arg0_55.mapEliteFleetCache[var2_55] = Clone(var0_55)
	arg0_55.mapEliteCommanderCache[var2_55] = Clone(var1_55)

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")

	for iter0_55, iter1_55 in ipairs(var0_0.FormationToChapters[var2_55]) do
		local var3_55 = arg0_55:getChapterById(iter1_55, true)

		if var3_55.configId ~= arg1_55.configId then
			var3_55:setEliteFleetList(Clone(var0_55))
			var3_55:setEliteCommanders(Clone(var1_55))
			arg0_55:updateChapter(var3_55)
		end
	end
end

function var0_0.duplicateSupportFleet(arg0_56, arg1_56)
	local var0_56 = arg1_56:getSupportFleet()
	local var1_56 = arg1_56:getConfig("formation")

	arg0_56.mapSupportFleetCache[var1_56] = {
		Clone(var0_56)
	}

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter0_56, iter1_56 in ipairs(var0_0.FormationToChapters[var1_56]) do
		local var2_56 = arg0_56:getChapterById(iter1_56, true)

		if var2_56.configId ~= arg1_56.configId then
			var2_56:setSupportFleetList({
				Clone(var0_56)
			})
			arg0_56:updateChapter(var2_56)
		end
	end
end

function var0_0.CheckUnitInSupportFleet(arg0_57, arg1_57)
	local var0_57 = {}
	local var1_57 = arg1_57.id

	for iter0_57, iter1_57 in pairs(arg0_57.mapSupportFleetCache) do
		for iter2_57, iter3_57 in ipairs(iter1_57) do
			if table.contains(iter3_57, var1_57) then
				var0_57[iter0_57] = true

				break
			end
		end
	end

	return next(var0_57), var0_57
end

function var0_0.RemoveUnitFromSupportFleet(arg0_58, arg1_58)
	arg0_58:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
		shipId = arg1_58.id,
		callback = next
	})
end

function var0_0.getActiveChapter(arg0_59, arg1_59)
	for iter0_59, iter1_59 in pairs(arg0_59.data) do
		if iter1_59.active then
			return arg1_59 and iter1_59 or iter1_59:clone()
		end
	end
end

function var0_0.getLastMapForActivity(arg0_60)
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

	if var4_60 and not var4_60:isRemaster() and var4_60:isUnlock() then
		return Map.lastMapForActivity
	end

	if Map.lastMapForActivity then
		Map.lastMapForActivity = nil

		arg0_60:recordLastMap(var0_0.LAST_MAP_FOR_ACTIVITY, 0)
	end

	local var5_60 = arg0_60:getMapsByActivities()

	table.sort(var5_60, function(arg0_61, arg1_61)
		return arg0_61.id > arg1_61.id
	end)

	local var6_60 = {}

	if _.all(var5_60, function(arg0_62)
		return arg0_62:getConfig("type") == Map.EVENT
	end) then
		var6_60 = var5_60
	else
		for iter0_60, iter1_60 in ipairs({
			Map.ACTIVITY_EASY,
			Map.ACTIVITY_HARD
		}) do
			local var7_60 = underscore.filter(var5_60, function(arg0_63)
				return arg0_63:getMapType() == iter1_60
			end)

			if #var7_60 > 0 then
				var6_60 = var7_60

				if underscore.any(var6_60, function(arg0_64)
					return not arg0_64:isClearForActivity()
				end) then
					break
				end
			end
		end
	end

	for iter2_60 = #var6_60, 1, -1 do
		local var8_60 = var6_60[iter2_60]

		if var8_60:isUnlock() then
			return var8_60.id
		end
	end

	if #var5_60 > 0 then
		return var5_60[1].id
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
	local var0_73 = arg1_73:getEliteFleetList()[arg2_73]
	local var1_73 = arg1_73:getConfig("limitation")[arg2_73]
	local var2_73 = var1_73 and Clone(var1_73[1]) or {
		0,
		0,
		0
	}
	local var3_73 = var1_73 and Clone(var1_73[2]) or {
		0,
		0,
		0
	}
	local var4_73 = {
		0,
		0,
		0
	}

	var0_0.SortRecommendLimitation(var2_73)
	var0_0.SortRecommendLimitation(var3_73)
	var0_0.SortRecommendLimitation(var4_73)

	local var5_73 = {}

	for iter0_73, iter1_73 in ipairs(arg1_73:getEliteFleetList()) do
		for iter2_73, iter3_73 in ipairs(iter1_73) do
			var5_73[#var5_73 + 1] = iter3_73
		end
	end

	local var6_73

	if arg2_73 > 2 then
		var6_73 = {
			[TeamType.Submarine] = var4_73
		}
	else
		var6_73 = {
			[TeamType.Main] = var2_73,
			[TeamType.Vanguard] = var3_73
		}
	end

	local var7_73 = arg0_73:FleetRecommend(var0_73, var5_73, var6_73, function(arg0_74)
		return ShipStatus.ShipStatusCheck("inElite", arg0_74, nil, {
			inElite = arg1_73:getConfig("formation")
		})
	end)

	table.clean(var0_73)
	table.insertto(var0_73, var7_73)
end

function var0_0.SupportFleetRecommend(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg1_75:getSupportFleet()
	local var1_75 = {
		[TeamType.Main] = {
			"hang",
			"hang",
			"hang"
		}
	}
	local var2_75 = table.shallowCopy(var0_75)
	local var3_75 = arg0_75:FleetRecommend(var0_75, var2_75, var1_75, function(arg0_76)
		return ShipStatus.ShipStatusCheck("inSupport", arg0_76, nil, {
			inSupport = arg1_75:getConfig("formation")
		})
	end)

	table.clean(var0_75)
	table.insertto(var0_75, var3_75)
end

function var0_0.FleetRecommend(arg0_77, arg1_77, arg2_77, arg3_77, arg4_77)
	arg1_77 = table.shallowCopy(arg1_77)
	arg2_77 = table.shallowCopy(arg2_77)

	local var0_77 = getProxy(BayProxy)
	local var1_77 = getProxy(BayProxy):getRawData()

	for iter0_77, iter1_77 in ipairs(arg1_77) do
		local var2_77 = var1_77[iter1_77]:getShipType()
		local var3_77 = TeamType.GetTeamFromShipType(var2_77)
		local var4_77 = 0
		local var5_77 = arg3_77[var3_77]

		for iter2_77, iter3_77 in ipairs(var5_77) do
			if ShipType.ContainInLimitBundle(iter3_77, var2_77) then
				var4_77 = iter3_77

				break
			end
		end

		for iter4_77, iter5_77 in ipairs(var5_77) do
			if iter5_77 == var4_77 then
				table.remove(var5_77, iter4_77)

				break
			end
		end
	end

	local function var6_77(arg0_78, arg1_78)
		local var0_78 = underscore.filter(TeamType.GetShipTypeListFromTeam(arg1_78), function(arg0_79)
			return ShipType.ContainInLimitBundle(arg0_78, arg0_79)
		end)
		local var1_78 = var0_77:GetRecommendShip(var0_78, arg2_77, arg4_77)

		if var1_78 then
			local var2_78 = var1_78.id

			arg2_77[#arg2_77 + 1] = var2_78
			arg1_77[#arg1_77 + 1] = var2_78
		end
	end

	for iter6_77, iter7_77 in pairs(arg3_77) do
		for iter8_77, iter9_77 in ipairs(iter7_77) do
			var6_77(iter9_77, iter6_77)
		end
	end

	return arg1_77
end

function var0_0.isClear(arg0_80, arg1_80)
	local var0_80 = arg0_80:GetChapterItemById(arg1_80)

	if not var0_80 then
		return false
	end

	return var0_80:isClear()
end

function var0_0.getEscortShop(arg0_81)
	return Clone(arg0_81.escortShop)
end

function var0_0.updateEscortShop(arg0_82, arg1_82)
	arg0_82.escortShop = arg1_82
end

function var0_0.recordLastMap(arg0_83, arg1_83, arg2_83)
	local var0_83 = false

	if arg1_83 == var0_0.LAST_MAP_FOR_ACTIVITY then
		Map.lastMapForActivity = arg2_83
		var0_83 = true
	elseif arg1_83 == var0_0.LAST_MAP and arg2_83 ~= Map.lastMap then
		Map.lastMap = arg2_83
		var0_83 = true
	end

	if var0_83 then
		local var1_83 = getProxy(PlayerProxy):getRawData()

		PlayerPrefs.SetInt(arg1_83 .. var1_83.id, arg2_83)
		PlayerPrefs.Save()
	end
end

function var0_0.getLastMap(arg0_84, arg1_84)
	local var0_84 = getProxy(PlayerProxy):getRawData()
	local var1_84 = PlayerPrefs.GetInt(arg1_84 .. var0_84.id)

	if var1_84 ~= 0 then
		return var1_84
	end
end

function var0_0.IsActivitySPChapterActive(arg0_85)
	local var0_85 = arg0_85:getMapsByActivities()
	local var1_85 = _.reduce(var0_85, {}, function(arg0_86, arg1_86)
		local var0_86 = _.select(arg1_86:getChapters(), function(arg0_87)
			return arg0_87:IsSpChapter()
		end)

		return table.mergeArray(arg0_86, var0_86)
	end)

	return _.any(var1_85, function(arg0_88)
		return arg0_88:isUnlock() and arg0_88:isPlayerLVUnlock() and arg0_88:enoughTimes2Start()
	end)
end

function var0_0.getSubAidFlag(arg0_89, arg1_89)
	local var0_89 = ys.Battle.BattleConst.SubAidFlag
	local var1_89 = arg0_89.fleet
	local var2_89 = false
	local var3_89 = _.detect(arg0_89.fleets, function(arg0_90)
		return arg0_90:getFleetType() == FleetType.Submarine and arg0_90:isValid()
	end)

	if var3_89 then
		if var3_89:inHuntingRange(var1_89.line.row, var1_89.line.column) then
			var2_89 = true
		else
			local var4_89 = var3_89:getStrategies()
			local var5_89 = _.detect(var4_89, function(arg0_91)
				return arg0_91.id == ChapterConst.StrategyCallSubOutofRange
			end)

			if var5_89 and var5_89.count > 0 then
				var2_89 = true
			end
		end
	end

	if var2_89 then
		local var6_89 = getProxy(PlayerProxy):getRawData()
		local var7_89, var8_89 = arg0_89:getFleetCost(var1_89, arg1_89)
		local var9_89, var10_89 = arg0_89:getFleetAmmo(var3_89)
		local var11_89 = 0

		for iter0_89, iter1_89 in ipairs({
			arg0_89:getFleetCost(var3_89, arg1_89)
		}) do
			var11_89 = var11_89 + iter1_89.oil
		end

		if var10_89 <= 0 then
			return var0_89.AMMO_EMPTY
		elseif var11_89 + var8_89.oil >= var6_89.oil then
			return var0_89.OIL_EMPTY
		else
			return true, var3_89
		end
	else
		return var0_89.AID_EMPTY
	end
end

function var0_0.GetChapterAuraBuffs(arg0_92)
	local var0_92 = {}

	for iter0_92, iter1_92 in ipairs(arg0_92.fleets) do
		if iter1_92:getFleetType() ~= FleetType.Support then
			local var1_92 = iter1_92:getMapAura()

			for iter2_92, iter3_92 in ipairs(var1_92) do
				table.insert(var0_92, iter3_92)
			end
		end
	end

	return var0_92
end

function var0_0.GetChapterAidBuffs(arg0_93)
	local var0_93 = {}

	for iter0_93, iter1_93 in ipairs(arg0_93.fleets) do
		if iter1_93 ~= arg0_93.fleet and iter1_93:getFleetType() ~= FleetType.Support then
			local var1_93 = iter1_93:getMapAid()

			for iter2_93, iter3_93 in pairs(var1_93) do
				var0_93[iter2_93] = iter3_93
			end
		end
	end

	return var0_93
end

function var0_0.RecordComboHistory(arg0_94, arg1_94, arg2_94)
	if arg2_94 ~= nil then
		arg0_94:SetExtendChapterData(arg1_94, "comboHistoryBuffer", arg2_94)
	else
		arg0_94:RemoveExtendChapterData(arg1_94, "comboHistoryBuffer")
	end
end

function var0_0.GetComboHistory(arg0_95, arg1_95)
	return arg0_95:GetExtendChapterData(arg1_95, "comboHistoryBuffer")
end

function var0_0.RecordJustClearChapters(arg0_96, arg1_96, arg2_96)
	if arg2_96 ~= nil then
		arg0_96:SetExtendChapterData(arg1_96, "justClearChapters", arg2_96)
	else
		arg0_96:RemoveExtendChapterData(arg1_96, "justClearChapters")
	end
end

function var0_0.GetJustClearChapters(arg0_97, arg1_97)
	return arg0_97:GetExtendChapterData(arg1_97, "justClearChapters")
end

function var0_0.RecordLastDefeatedEnemy(arg0_98, arg1_98, arg2_98)
	if arg2_98 ~= nil then
		arg0_98:SetExtendChapterData(arg1_98, "defeatedEnemiesBuffer", arg2_98)
	else
		arg0_98:RemoveExtendChapterData(arg1_98, "defeatedEnemiesBuffer")
	end
end

function var0_0.GetLastDefeatedEnemy(arg0_99, arg1_99)
	return arg0_99:GetExtendChapterData(arg1_99, "defeatedEnemiesBuffer")
end

function var0_0.ifShowRemasterTip(arg0_100)
	return arg0_100.remasterTip
end

function var0_0.setRemasterTip(arg0_101, arg1_101)
	arg0_101.remasterTip = arg1_101
end

function var0_0.updateRemasterTicketsNum(arg0_102, arg1_102)
	arg0_102.remasterTickets = arg1_102
end

function var0_0.resetDailyCount(arg0_103)
	arg0_103.remasterDailyCount = 0
end

function var0_0.updateDailyCount(arg0_104)
	arg0_104.remasterDailyCount = arg0_104.remasterDailyCount + pg.gameset.reactivity_ticket_daily.key_value
end

function var0_0.GetSkipPrecombat(arg0_105)
	if arg0_105.skipPrecombat == nil then
		arg0_105.skipPrecombat = PlayerPrefs.GetInt("chapter_skip_precombat", 0)
	end

	return arg0_105.skipPrecombat > 0
end

function var0_0.UpdateSkipPrecombat(arg0_106, arg1_106)
	arg1_106 = tobool(arg1_106) and 1 or 0

	if arg1_106 ~= arg0_106:GetSkipPrecombat() then
		PlayerPrefs.SetInt("chapter_skip_precombat", arg1_106)

		arg0_106.skipPrecombat = arg1_106

		arg0_106:sendNotification(var0_0.CHAPTER_SKIP_PRECOMBAT_UPDATED, arg1_106)
	end
end

function var0_0.GetChapterAutoFlag(arg0_107, arg1_107)
	return arg0_107:GetExtendChapterData(arg1_107, "AutoFightFlag")
end

function var0_0.SetChapterAutoFlag(arg0_108, arg1_108, arg2_108, arg3_108)
	arg2_108 = tobool(arg2_108)

	if arg2_108 == (arg0_108:GetChapterAutoFlag(arg1_108) == 1) then
		return
	end

	arg0_108:SetExtendChapterData(arg1_108, "AutoFightFlag", arg2_108 and 1 or 0)

	if arg2_108 then
		arg0_108:UpdateSkipPrecombat(true)

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
		arg0_108:StopContinuousOperation(SYSTEM_SCENARIO, arg3_108)
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end
	end

	arg0_108.facade:sendNotification(var0_0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED, arg2_108 and 1 or 0)
	arg0_108.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, not arg2_108)
end

function var0_0.StopAutoFight(arg0_109, arg1_109)
	local var0_109 = arg0_109:getActiveChapter(true)

	if not var0_109 then
		return
	end

	arg0_109:SetChapterAutoFlag(var0_109.id, false, arg1_109)
end

function var0_0.FinishAutoFight(arg0_110, arg1_110)
	if arg0_110:GetChapterAutoFlag(arg1_110) == 1 then
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end

		arg0_110.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
	end

	local var0_110 = arg0_110:GetExtendChapter(arg1_110)

	arg0_110:RemoveExtendChapter(arg1_110)

	return var0_110
end

function var0_0.buildRemasterInfo(arg0_111)
	arg0_111.remasterInfo = {}

	for iter0_111, iter1_111 in ipairs(pg.re_map_template.all) do
		for iter2_111, iter3_111 in ipairs(pg.re_map_template[iter1_111].drop_gain) do
			if #iter3_111 > 0 then
				local var0_111, var1_111, var2_111, var3_111 = unpack(iter3_111)

				arg0_111.remasterInfo[var0_111] = defaultValue(arg0_111.remasterInfo[var0_111], {})
				arg0_111.remasterInfo[var0_111][iter2_111] = {
					count = 0,
					receive = false,
					max = var3_111
				}
			end
		end
	end
end

function var0_0.checkRemasterInfomation(arg0_112)
	if not arg0_112.checkRemaster then
		arg0_112.checkRemaster = true

		arg0_112:sendNotification(GAME.CHAPTER_REMASTER_INFO_REQUEST)
	end
end

function var0_0.addRemasterPassCount(arg0_113, arg1_113)
	if not arg0_113.remasterInfo[arg1_113] then
		return
	end

	local var0_113

	for iter0_113, iter1_113 in pairs(arg0_113.remasterInfo[arg1_113]) do
		if iter1_113.count < iter1_113.max then
			iter1_113.count = iter1_113.count + 1
			var0_113 = true
		end
	end

	if var0_113 then
		arg0_113:sendNotification(var0_0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0_0.markRemasterPassReceive(arg0_114, arg1_114, arg2_114)
	local var0_114 = arg0_114.remasterInfo[arg1_114][arg2_114]

	if not arg0_114.remasterInfo[arg1_114][arg2_114] then
		return
	end

	if not var0_114.receive then
		var0_114.receive = true

		arg0_114:sendNotification(var0_0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0_0.anyRemasterAwardCanReceive(arg0_115)
	for iter0_115, iter1_115 in pairs(arg0_115.remasterInfo) do
		for iter2_115, iter3_115 in pairs(iter1_115) do
			if not iter3_115.receive and iter3_115.count >= iter3_115.max then
				return true
			end
		end
	end

	return false
end

function var0_0.AddActBossRewards(arg0_116, arg1_116)
	arg0_116.actBossItems = arg0_116.actBossItems or {}

	table.insertto(arg0_116.actBossItems, arg1_116)
end

function var0_0.PopActBossRewards(arg0_117)
	local var0_117 = arg0_117.actBossItems or {}

	arg0_117.actBossItems = nil

	return var0_117
end

function var0_0.AddBossSingleRewards(arg0_118, arg1_118)
	arg0_118.bossSingleItems = arg0_118.bossSingleItems or {}

	table.insertto(arg0_118.bossSingleItems, arg1_118)
end

function var0_0.PopBossSingleRewards(arg0_119)
	local var0_119 = arg0_119.bossSingleItems or {}

	arg0_119.bossSingleItems = nil

	return var0_119
end

function var0_0.WriteBackOnExitBattleResult(arg0_120)
	local var0_120 = arg0_120:getActiveChapter()

	if var0_120 then
		if var0_120:existOni() then
			var0_120:clearSubmarineFleet()
			arg0_120:updateChapter(var0_120)
		elseif var0_120:isPlayingWithBombEnemy() then
			var0_120.fleets = {
				var0_120.fleet
			}
			var0_120.findex = 1

			arg0_120:updateChapter(var0_120)
		end
	end
end

function var0_0.GetContinuousData(arg0_121, arg1_121)
	return arg0_121.continuousData[arg1_121]
end

function var0_0.InitContinuousTime(arg0_122, arg1_122, arg2_122)
	local var0_122 = ContinuousOperationRuntimeData.New({
		system = arg1_122,
		totalBattleTime = arg2_122,
		battleTime = arg2_122
	})

	arg0_122.continuousData[arg1_122] = var0_122
end

function var0_0.StopContinuousOperation(arg0_123, arg1_123, arg2_123)
	local var0_123 = arg0_123:GetContinuousData(arg1_123)

	if not var0_123 or not var0_123:IsActive() then
		return
	end

	if arg2_123 == ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL and arg1_123 == SYSTEM_SCENARIO then
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_stop"))
	end

	var0_123:Stop(arg2_123)
end

function var0_0.PopContinuousData(arg0_124, arg1_124)
	local var0_124 = arg0_124.continuousData[arg1_124]

	arg0_124.continuousData[arg1_124] = nil

	return var0_124
end

function var0_0.SetLastFleetIndex(arg0_125, arg1_125, arg2_125)
	if arg2_125 and arg0_125.lastFleetIndex then
		return
	end

	arg0_125.lastFleetIndex = arg1_125
end

function var0_0.GetLastFleetIndex(arg0_126)
	return arg0_126.lastFleetIndex
end

return var0_0
