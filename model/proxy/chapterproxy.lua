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

function var0_0.OnBattleFinished(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:getActiveChapter()

	if var0_3 then
		local var1_3 = 0

		local function var2_3()
			local var0_4 = getProxy(ContextProxy)

			if not var0_4 then
				return
			end

			if var0_4:getCurrentContext().mediator == LevelMediator2 then
				var1_3 = bit.bor(var1_3, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

				arg0_3:SetChapterAutoFlag(var0_3.id, false)

				return
			end

			local var1_4 = var0_4:getContextByMediator(LevelMediator2)

			if not var1_4 then
				return
			end

			var1_4.data.StopAutoFightFlag = true
		end

		if _.any(arg1_3.ai_list, function(arg0_5)
			return arg0_5.item_type == ChapterConst.AttachOni
		end) then
			var0_3:onOniEnter()
			var2_3()
		end

		if _.any(arg1_3.map_update, function(arg0_6)
			return arg0_6.item_type == ChapterConst.AttachBomb_Enemy
		end) then
			var0_3:onBombEnemyEnter()
			var2_3()
		end

		if #arg1_3.map_update > 0 then
			_.each(arg1_3.map_update, function(arg0_7)
				if arg0_7.item_type == ChapterConst.AttachStory and arg0_7.item_data == ChapterConst.StoryTrigger then
					local var0_7 = ChapterCell.Line2Name(arg0_7.pos.row, arg0_7.pos.column)
					local var1_7 = var0_3:GetChapterCellAttachemnts()
					local var2_7 = var1_7[var0_7]

					if var2_7 then
						if var2_7.flag == ChapterConst.CellFlagTriggerActive and arg0_7.item_flag == ChapterConst.CellFlagTriggerDisabled then
							local var3_7 = pg.map_event_template[var2_7.attachmentId].gametip

							if var3_7 ~= "" then
								pg.TipsMgr.GetInstance():ShowTips(i18n(var3_7))
							end
						end

						var2_7.attachment = arg0_7.item_type
						var2_7.attachmentId = arg0_7.item_id
						var2_7.flag = arg0_7.item_flag
						var2_7.data = arg0_7.item_data
					else
						var1_7[var0_7] = ChapterCell.New(arg0_7)
					end
				elseif arg0_7.item_type ~= ChapterConst.AttachNone and arg0_7.item_type ~= ChapterConst.AttachBorn and arg0_7.item_type ~= ChapterConst.AttachBorn_Sub and arg0_7.item_type ~= ChapterConst.AttachOni_Target and arg0_7.item_type ~= ChapterConst.AttachOni then
					local var4_7 = ChapterCell.New(arg0_7)

					var0_3:mergeChapterCell(var4_7)
				end
			end)

			var1_3 = bit.bor(var1_3, ChapterConst.DirtyAttachment, ChapterConst.DirtyAutoAction)
		end

		if #arg1_3.ai_list > 0 then
			_.each(arg1_3.ai_list, function(arg0_8)
				local var0_8 = ChapterChampionPackage.New(arg0_8)

				var0_3:mergeChampion(var0_8)
			end)

			var1_3 = bit.bor(var1_3, ChapterConst.DirtyChampion, ChapterConst.DirtyAutoAction)
		end

		if #arg1_3.add_flag_list > 0 or #arg1_3.del_flag_list > 0 then
			var1_3 = bit.bor(var1_3, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)

			arg0_3:updateExtraFlag(var0_3, arg1_3.add_flag_list, arg1_3.del_flag_list)
		end

		if #arg1_3.buff_list > 0 then
			var0_3:UpdateBuffList(arg1_3.buff_list)
		end

		if #arg1_3.cell_flag_list > 0 then
			_.each(arg1_3.cell_flag_list, function(arg0_9)
				local var0_9 = var0_3:getChapterCell(arg0_9.pos.row, arg0_9.pos.column)

				if var0_9 then
					var0_9:updateFlagList(arg0_9)
				else
					var0_9 = ChapterCell.New(arg0_9)
				end

				var0_3:updateChapterCell(var0_9)
			end)

			var1_3 = bit.bor(var1_3, ChapterConst.DirtyCellFlag)
		end

		arg0_3:updateChapter(var0_3, var1_3)

		if arg2_3 then
			arg0_3:sendNotification(GAME.CHAPTER_OP_DONE, {
				type = ChapterConst.OpSkipBattle
			})
		end
	end
end

function var0_0.setEliteCache(arg0_10, arg1_10)
	arg0_10.mapEliteFleetCache = {}
	arg0_10.mapEliteCommanderCache = {}
	arg0_10.mapSupportFleetCache = {}

	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		var0_10[iter1_10.map_id] = var0_10[iter1_10.map_id] or {}

		table.insert(var0_10[iter1_10.map_id], iter1_10)
	end

	for iter2_10, iter3_10 in pairs(var0_10) do
		arg0_10.mapEliteFleetCache[iter2_10], arg0_10.mapEliteCommanderCache[iter2_10], arg0_10.mapSupportFleetCache[iter2_10] = Chapter.BuildEliteFleetList(iter3_10)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter4_10, iter5_10 in pairs(arg0_10.data) do
		local var1_10 = iter5_10:getConfig("formation")

		iter5_10:setEliteFleetList(Clone(arg0_10.mapEliteFleetCache[var1_10]) or {
			{},
			{},
			{}
		})
		iter5_10:setEliteCommanders(Clone(arg0_10.mapEliteCommanderCache[var1_10]) or {
			{},
			{},
			{}
		})
		iter5_10:setSupportFleetList(Clone(arg0_10.mapSupportFleetCache[var1_10]) or {
			{},
			{},
			{}
		})
		arg0_10:updateChapter(iter5_10)
	end
end

function var0_0.buildMaps(arg0_11)
	arg0_11:initChapters()
	arg0_11:buildBaseMaps()
	arg0_11:buildRemasterMaps()
end

function var0_0.initChapters(arg0_12)
	var0_0.MapToChapters = table.shallowCopy(pg.chapter_template.get_id_list_by_map)

	for iter0_12, iter1_12 in pairs(pg.story_group.get_id_list_by_map) do
		var0_0.MapToChapters[iter0_12] = var0_0.MapToChapters[iter0_12] or {}
		var0_0.MapToChapters[iter0_12] = table.mergeArray(var0_0.MapToChapters[iter0_12], iter1_12)
	end

	var0_0.FormationToChapters = pg.chapter_template.get_id_list_by_formation
end

function var0_0.buildBaseMaps(arg0_13)
	var0_0.ActToMaps = {}
	var0_0.TypeToMaps = {}

	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(pg.expedition_data_by_map.all) do
		local var1_13 = Map.New({
			id = iter1_13,
			chapterIds = var0_0.MapToChapters[iter1_13]
		})

		var0_13[iter1_13] = var1_13

		local var2_13 = var1_13:getConfig("on_activity")

		if var2_13 ~= 0 then
			var0_0.ActToMaps[var2_13] = var0_0.ActToMaps[var2_13] or {}

			table.insert(var0_0.ActToMaps[var2_13], var1_13.id)
		end

		local var3_13 = var1_13:getMapType()

		var0_0.TypeToMaps[var3_13] = var0_0.TypeToMaps[var3_13] or {}

		table.insert(var0_0.TypeToMaps[var3_13], var1_13.id)
	end

	arg0_13.baseMaps = var0_13
end

function var0_0.buildRemasterMaps(arg0_14)
	var0_0.RemasterToMaps = {}

	local var0_14 = {}

	_.each(pg.re_map_template.all, function(arg0_15)
		local var0_15 = pg.re_map_template[arg0_15]

		_.each(var0_15.config_data, function(arg0_16)
			local var0_16 = arg0_14.baseMaps[pg.chapter_template[arg0_16].map]

			assert(not var0_14[var0_16.id] or var0_14[var0_16.id] == arg0_15, "remaster chapter error:" .. arg0_16)

			if not var0_14[var0_16.id] then
				var0_14[var0_16.id] = arg0_15

				var0_16:setRemaster(arg0_15)

				var0_0.RemasterToMaps[arg0_15] = var0_0.RemasterToMaps[arg0_15] or {}

				table.insert(var0_0.RemasterToMaps[arg0_15], var0_16.id)
			end
		end)
	end)
end

function var0_0.IsChapterInRemaster(arg0_17, arg1_17)
	return _.detect(pg.re_map_template.all, function(arg0_18)
		local var0_18 = pg.re_map_template[arg0_18]

		return _.any(var0_18.config_data, function(arg0_19)
			return arg0_19 == arg1_17
		end)
	end)
end

function var0_0.getMaxEscortChallengeTimes(arg0_20)
	return getProxy(ActivityProxy):getActivityParameter("escort_daily_count") or 0
end

function var0_0.getEscortChapterIds(arg0_21)
	return getProxy(ActivityProxy):getActivityParameter("escort_exp_id") or {}
end

function var0_0.resetEscortChallengeTimes(arg0_22)
	arg0_22.escortChallengeTimes = 0
end

function var0_0.addChapterListener(arg0_23, arg1_23)
	if not arg1_23.dueTime or not arg0_23.timers then
		return
	end

	if arg0_23.timers[arg1_23.id] then
		arg0_23.timers[arg1_23.id]:Stop()

		arg0_23.timers[arg1_23.id] = nil
	end

	local var0_23 = arg1_23.dueTime - pg.TimeMgr.GetInstance():GetServerTime()

	local function var1_23()
		arg0_23.data[arg1_23.id].dueTime = nil

		arg0_23.data[arg1_23.id]:display("times'up")
		arg0_23:sendNotification(var0_0.CHAPTER_UPDATED, {
			dirty = 0,
			chapter = arg0_23.data[arg1_23.id]:clone()
		})
		arg0_23:sendNotification(var0_0.CHAPTER_TIMESUP)
	end

	if var0_23 > 0 then
		arg0_23.timers[arg1_23.id] = Timer.New(function()
			var1_23()
			arg0_23.timers[arg1_23.id]:Stop()

			arg0_23.timers[arg1_23.id] = nil
		end, var0_23, 1)

		arg0_23.timers[arg1_23.id]:Start()
	else
		var1_23()
	end
end

function var0_0.removeChapterListener(arg0_26, arg1_26)
	if arg0_26.timers[arg1_26] then
		arg0_26.timers[arg1_26]:Stop()

		arg0_26.timers[arg1_26] = nil
	end
end

function var0_0.remove(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.timers) do
		iter1_27:Stop()
	end

	arg0_27.timers = nil
end

function var0_0.GetRawChapterById(arg0_28, arg1_28)
	return arg0_28.data[arg1_28]
end

function var0_0.getChapterById(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.data[arg1_29]

	if not var0_29 then
		assert(pg.chapter_template[arg1_29], "Not Exist Chapter ID: " .. (arg1_29 or "NIL"))

		var0_29 = Chapter.New({
			id = arg1_29
		})

		local var1_29 = var0_29:getConfig("formation")

		if var0_29:getConfig("type") == Chapter.CustomFleet then
			var0_29:setEliteFleetList(Clone(arg0_29.mapEliteFleetCache[var1_29]) or {
				{},
				{},
				{}
			})
			var0_29:setEliteCommanders(Clone(arg0_29.mapEliteCommanderCache[var1_29]) or {
				{},
				{},
				{}
			})
		elseif var0_29:getConfig("type") == Chapter.SelectFleet then
			var0_29:setSupportFleetList(Clone(arg0_29.mapSupportFleetCache[var1_29]) or {
				{},
				{},
				{}
			})
		end

		arg0_29.data[arg1_29] = var0_29
	end

	return arg2_29 and var0_29 or var0_29:clone()
end

function var0_0.GetChapterItemById(arg0_30, arg1_30)
	if Chapter:bindConfigTable()[arg1_30] then
		return arg0_30:getChapterById(arg1_30, true)
	elseif ChapterStoryGroup:bindConfigTable()[arg1_30] then
		local var0_30 = arg0_30.chapterStoryGroups[arg1_30]

		if not var0_30 then
			var0_30 = ChapterStoryGroup.New({
				configId = arg1_30
			})
			arg0_30.chapterStoryGroups[arg1_30] = var0_30
		end

		return var0_30
	end
end

function var0_0.updateChapter(arg0_31, arg1_31, arg2_31)
	assert(isa(arg1_31, Chapter), "should be an instance of Chapter")

	local var0_31 = arg0_31.data[arg1_31.id]
	local var1_31 = arg1_31

	arg0_31.data[arg1_31.id] = var1_31

	if var0_31 then
		arg0_31:removeChapterListener(var0_31.id)
	end

	arg0_31:addChapterListener(var1_31)

	if getProxy(PlayerProxy):getInited() then
		arg0_31.facade:sendNotification(var0_0.CHAPTER_UPDATED, {
			chapter = var1_31:clone(),
			dirty = defaultValue(arg2_31, 0)
		})
	end

	if var1_31.active and var1_31.fleet then
		var1_31.fleet:clearShipHpChange()
	end

	if tobool(checkExist(var0_31, {
		"active"
	})) ~= tobool(var1_31.active) then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
	end
end

function var0_0.getMapById(arg0_32, arg1_32)
	return arg0_32.baseMaps[arg1_32]
end

function var0_0.getNormalMaps(arg0_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in ipairs(arg0_33.baseMaps) do
		table.insert(var0_33, iter1_33)
	end

	return var0_33
end

function var0_0.getMapsByType(arg0_34, arg1_34)
	if var0_0.TypeToMaps[arg1_34] then
		return _.map(var0_0.TypeToMaps[arg1_34], function(arg0_35)
			return arg0_34:getMapById(arg0_35)
		end)
	else
		return {}
	end
end

function var0_0.getMapsByActId(arg0_36, arg1_36)
	if var0_0.ActToMaps[arg1_36] then
		return underscore.map(var0_0.ActToMaps[arg1_36], function(arg0_37)
			return arg0_36:getMapById(arg0_37)
		end)
	else
		return {}
	end
end

function var0_0.getRemasterMaps(arg0_38, arg1_38)
	if var0_0.RemasterToMaps[arg1_38] then
		return underscore.map(var0_0.RemasterToMaps[arg1_38], function(arg0_39)
			return arg0_38:getMapById(arg0_39)
		end)
	else
		return {}
	end
end

function var0_0.getMapsByActivities(arg0_40)
	local var0_40 = {}
	local var1_40 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

	underscore.each(var1_40, function(arg0_41)
		if not arg0_41:isEnd() then
			var0_40 = table.mergeArray(var0_40, arg0_40:getMapsByActId(arg0_41.id))
		end
	end)

	return var0_40
end

function var0_0.getLastUnlockMap(arg0_42)
	local var0_42

	for iter0_42, iter1_42 in ipairs(arg0_42:getNormalMaps()) do
		if not iter1_42:isUnlock() then
			break
		end

		var0_42 = iter1_42
	end

	return var0_42
end

function var0_0.updateExtraFlag(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	local var0_43 = arg1_43:updateExtraFlags(arg2_43, arg3_43)

	if not arg4_43 and not var0_43 then
		return
	end

	local var1_43 = {}

	for iter0_43, iter1_43 in ipairs(arg2_43) do
		table.insert(var1_43, iter1_43)
	end

	arg0_43:SetExtendChapterData(arg1_43.id, "extraFlagUpdate", var1_43)

	return true
end

function var0_0.extraFlagUpdated(arg0_44, arg1_44)
	arg0_44:RemoveExtendChapterData(arg1_44, "extraFlagUpdate")
end

function var0_0.getUpdatedExtraFlags(arg0_45, arg1_45)
	return arg0_45:GetExtendChapterData(arg1_45, "extraFlagUpdate")
end

function var0_0.SetExtendChapterData(arg0_46, arg1_46, arg2_46, arg3_46)
	assert(arg1_46, "Missing Chapter ID")

	arg0_46.chaptersExtend[arg1_46] = arg0_46.chaptersExtend[arg1_46] or {}
	arg0_46.chaptersExtend[arg1_46][arg2_46] = arg3_46
end

function var0_0.AddExtendChapterDataArray(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
	assert(arg1_47, "Missing Chapter ID")

	arg0_47.chaptersExtend[arg1_47] = arg0_47.chaptersExtend[arg1_47] or {}

	if type(arg0_47.chaptersExtend[arg1_47][arg2_47]) ~= "table" then
		assert(arg0_47.chaptersExtend[arg1_47][arg2_47] == nil, "Changing NonEmpty ExtendData " .. arg2_47 .. " to Table ID: " .. arg1_47)

		arg0_47.chaptersExtend[arg1_47][arg2_47] = {}
	end

	arg4_47 = arg4_47 or #arg0_47.chaptersExtend[arg1_47][arg2_47] + 1
	arg0_47.chaptersExtend[arg1_47][arg2_47][arg4_47] = arg3_47
end

function var0_0.AddExtendChapterDataTable(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48)
	assert(arg1_48, "Missing Chapter ID")

	arg0_48.chaptersExtend[arg1_48] = arg0_48.chaptersExtend[arg1_48] or {}

	if type(arg0_48.chaptersExtend[arg1_48][arg2_48]) ~= "table" then
		assert(arg0_48.chaptersExtend[arg1_48][arg2_48] == nil, "Changing NonEmpty ExtendData " .. arg2_48 .. " to Table ID: " .. arg1_48)

		arg0_48.chaptersExtend[arg1_48][arg2_48] = {}
	end

	assert(arg3_48, "Missing Index on Set HashData")

	arg0_48.chaptersExtend[arg1_48][arg2_48][arg3_48] = arg4_48
end

function var0_0.GetExtendChapterData(arg0_49, arg1_49, arg2_49)
	assert(arg1_49, "Missing Chapter ID")
	assert(arg2_49, "Requesting Empty key")

	if not arg2_49 or not arg0_49.chaptersExtend[arg1_49] then
		return
	end

	return arg0_49.chaptersExtend[arg1_49][arg2_49]
end

function var0_0.RemoveExtendChapterData(arg0_50, arg1_50, arg2_50)
	assert(arg1_50, "Missing Chapter ID")

	if not arg2_50 or not arg0_50.chaptersExtend[arg1_50] then
		return
	end

	arg0_50.chaptersExtend[arg1_50][arg2_50] = nil

	if next(arg0_50.chaptersExtend[arg1_50]) then
		return
	end

	arg0_50:RemoveExtendChapter(arg1_50)
end

function var0_0.GetExtendChapter(arg0_51, arg1_51)
	assert(arg1_51, "Missing Chapter ID")

	return arg0_51.chaptersExtend[arg1_51]
end

function var0_0.RemoveExtendChapter(arg0_52, arg1_52)
	assert(arg1_52, "Missing Chapter ID")

	if not arg0_52.chaptersExtend[arg1_52] then
		return
	end

	arg0_52.chaptersExtend[arg1_52] = nil
end

function var0_0.duplicateEliteFleet(arg0_53, arg1_53)
	if arg1_53:getConfig("type") ~= Chapter.CustomFleet then
		return
	end

	local var0_53 = arg1_53:getEliteFleetList()
	local var1_53 = arg1_53:getEliteFleetCommanders()
	local var2_53 = arg1_53:getConfig("formation")

	arg0_53.mapEliteFleetCache[var2_53] = Clone(var0_53)
	arg0_53.mapEliteCommanderCache[var2_53] = Clone(var1_53)

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")

	for iter0_53, iter1_53 in ipairs(var0_0.FormationToChapters[var2_53]) do
		local var3_53 = arg0_53:getChapterById(iter1_53, true)

		if var3_53.configId ~= arg1_53.configId then
			var3_53:setEliteFleetList(Clone(var0_53))
			var3_53:setEliteCommanders(Clone(var1_53))
			arg0_53:updateChapter(var3_53)
		end
	end
end

function var0_0.duplicateSupportFleet(arg0_54, arg1_54)
	local var0_54 = arg1_54:getSupportFleet()
	local var1_54 = arg1_54:getConfig("formation")

	arg0_54.mapSupportFleetCache[var1_54] = {
		Clone(var0_54)
	}

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter0_54, iter1_54 in ipairs(var0_0.FormationToChapters[var1_54]) do
		local var2_54 = arg0_54:getChapterById(iter1_54, true)

		if var2_54.configId ~= arg1_54.configId then
			var2_54:setSupportFleetList({
				Clone(var0_54)
			})
			arg0_54:updateChapter(var2_54)
		end
	end
end

function var0_0.CheckUnitInSupportFleet(arg0_55, arg1_55)
	local var0_55 = {}
	local var1_55 = arg1_55.id

	for iter0_55, iter1_55 in pairs(arg0_55.mapSupportFleetCache) do
		for iter2_55, iter3_55 in ipairs(iter1_55) do
			if table.contains(iter3_55, var1_55) then
				var0_55[iter0_55] = true

				break
			end
		end
	end

	return next(var0_55), var0_55
end

function var0_0.RemoveUnitFromSupportFleet(arg0_56, arg1_56)
	arg0_56:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
		shipId = arg1_56.id,
		callback = next
	})
end

function var0_0.getActiveChapter(arg0_57, arg1_57)
	for iter0_57, iter1_57 in pairs(arg0_57.data) do
		if iter1_57.active then
			return arg1_57 and iter1_57 or iter1_57:clone()
		end
	end
end

function var0_0.getLastMapForActivity(arg0_58)
	local var0_58
	local var1_58
	local var2_58 = arg0_58:getActiveChapter()

	if var2_58 then
		local var3_58 = arg0_58:getMapById(var2_58:getConfig("map"))

		if var3_58:isActivity() and not var3_58:isRemaster() then
			return var3_58.id, var2_58.id
		end
	end

	local var4_58 = Map.lastMapForActivity and arg0_58:getMapById(Map.lastMapForActivity)

	if var4_58 and not var4_58:isRemaster() and var4_58:isUnlock() then
		return Map.lastMapForActivity
	end

	if Map.lastMapForActivity then
		Map.lastMapForActivity = nil

		arg0_58:recordLastMap(var0_0.LAST_MAP_FOR_ACTIVITY, 0)
	end

	local var5_58 = arg0_58:getMapsByActivities()

	table.sort(var5_58, function(arg0_59, arg1_59)
		return arg0_59.id > arg1_59.id
	end)

	local var6_58 = {}

	if _.all(var5_58, function(arg0_60)
		return arg0_60:getConfig("type") == Map.EVENT
	end) then
		var6_58 = var5_58
	else
		for iter0_58, iter1_58 in ipairs({
			Map.ACTIVITY_EASY,
			Map.ACTIVITY_HARD
		}) do
			local var7_58 = underscore.filter(var5_58, function(arg0_61)
				return arg0_61:getMapType() == iter1_58
			end)

			if #var7_58 > 0 then
				var6_58 = var7_58

				if underscore.any(var6_58, function(arg0_62)
					return not arg0_62:isClearForActivity()
				end) then
					break
				end
			end
		end
	end

	for iter2_58 = #var6_58, 1, -1 do
		local var8_58 = var6_58[iter2_58]

		if var8_58:isUnlock() then
			return var8_58.id
		end
	end

	if #var5_58 > 0 then
		return var5_58[1].id
	end
end

function var0_0.updateActiveChapterShips(arg0_63)
	local var0_63 = arg0_63:getActiveChapter(true)

	if var0_63 then
		_.each(var0_63.fleets, function(arg0_64)
			arg0_64:flushShips()
		end)
		arg0_63:updateChapter(var0_63, ChapterConst.DirtyFleet)
	end
end

function var0_0.resetRepairTimes(arg0_65)
	arg0_65.repairTimes = 0
end

function var0_0.getUseableEliteMap(arg0_66)
	local var0_66 = {}

	for iter0_66, iter1_66 in ipairs(arg0_66:getMapsByType(Map.ELITE)) do
		if iter1_66:isEliteEnabled() then
			var0_66[#var0_66 + 1] = iter1_66
		end
	end

	return var0_66
end

function var0_0.getUseableMaxEliteMap(arg0_67)
	local var0_67 = arg0_67:getUseableEliteMap()

	if #var0_67 == 0 then
		return false
	else
		local var1_67

		for iter0_67, iter1_67 in ipairs(var0_67) do
			if not var1_67 or var1_67.id < iter1_67.id then
				var1_67 = iter1_67
			end
		end

		return var1_67
	end
end

function var0_0.getHigestClearChapterAndMap(arg0_68)
	local var0_68 = arg0_68.baseMaps[1]

	for iter0_68, iter1_68 in ipairs(arg0_68:getNormalMaps()) do
		if not iter1_68:isAnyChapterClear() then
			break
		end

		var0_68 = iter1_68
	end

	local var1_68 = arg0_68:getChapterById(var0_68.chapterIds[1])

	for iter2_68, iter3_68 in ipairs(var0_68:getChapters()) do
		if not iter3_68:isClear() then
			break
		end

		var1_68 = iter3_68
	end

	return var1_68, var0_68
end

function var0_0.SortRecommendLimitation(arg0_69)
	table.sort(arg0_69, CompareFuncs({
		function(arg0_70)
			if type(arg0_70) == "number" then
				if arg0_70 == 0 then
					return 1
				else
					return -arg0_70
				end
			elseif type(arg0_70) == "string" then
				return 0
			else
				assert(false)
			end
		end
	}))
end

function var0_0.eliteFleetRecommend(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg1_71:getEliteFleetList()[arg2_71]
	local var1_71 = arg1_71:getConfig("limitation")[arg2_71]
	local var2_71 = var1_71 and Clone(var1_71[1]) or {
		0,
		0,
		0
	}
	local var3_71 = var1_71 and Clone(var1_71[2]) or {
		0,
		0,
		0
	}
	local var4_71 = {
		0,
		0,
		0
	}

	var0_0.SortRecommendLimitation(var2_71)
	var0_0.SortRecommendLimitation(var3_71)
	var0_0.SortRecommendLimitation(var4_71)

	local var5_71 = {}

	for iter0_71, iter1_71 in ipairs(arg1_71:getEliteFleetList()) do
		for iter2_71, iter3_71 in ipairs(iter1_71) do
			var5_71[#var5_71 + 1] = iter3_71
		end
	end

	local var6_71

	if arg2_71 > 2 then
		var6_71 = {
			[TeamType.Submarine] = var4_71
		}
	else
		var6_71 = {
			[TeamType.Main] = var2_71,
			[TeamType.Vanguard] = var3_71
		}
	end

	local var7_71 = arg0_71:FleetRecommend(var0_71, var5_71, var6_71, function(arg0_72)
		return ShipStatus.ShipStatusCheck("inElite", arg0_72, nil, {
			inElite = arg1_71:getConfig("formation")
		})
	end)

	table.clean(var0_71)
	table.insertto(var0_71, var7_71)
end

function var0_0.SupportFleetRecommend(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg1_73:getSupportFleet()
	local var1_73 = {
		[TeamType.Main] = {
			"hang",
			"hang",
			"hang"
		}
	}
	local var2_73 = table.shallowCopy(var0_73)
	local var3_73 = arg0_73:FleetRecommend(var0_73, var2_73, var1_73, function(arg0_74)
		return ShipStatus.ShipStatusCheck("inSupport", arg0_74, nil, {
			inSupport = arg1_73:getConfig("formation")
		})
	end)

	table.clean(var0_73)
	table.insertto(var0_73, var3_73)
end

function var0_0.FleetRecommend(arg0_75, arg1_75, arg2_75, arg3_75, arg4_75)
	arg1_75 = table.shallowCopy(arg1_75)
	arg2_75 = table.shallowCopy(arg2_75)

	local var0_75 = getProxy(BayProxy)
	local var1_75 = getProxy(BayProxy):getRawData()

	for iter0_75, iter1_75 in ipairs(arg1_75) do
		local var2_75 = var1_75[iter1_75]:getShipType()
		local var3_75 = TeamType.GetTeamFromShipType(var2_75)
		local var4_75 = 0
		local var5_75 = arg3_75[var3_75]

		for iter2_75, iter3_75 in ipairs(var5_75) do
			if ShipType.ContainInLimitBundle(iter3_75, var2_75) then
				var4_75 = iter3_75

				break
			end
		end

		for iter4_75, iter5_75 in ipairs(var5_75) do
			if iter5_75 == var4_75 then
				table.remove(var5_75, iter4_75)

				break
			end
		end
	end

	local function var6_75(arg0_76, arg1_76)
		local var0_76 = underscore.filter(TeamType.GetShipTypeListFromTeam(arg1_76), function(arg0_77)
			return ShipType.ContainInLimitBundle(arg0_76, arg0_77)
		end)
		local var1_76 = var0_75:GetRecommendShip(var0_76, arg2_75, arg4_75)

		if var1_76 then
			local var2_76 = var1_76.id

			arg2_75[#arg2_75 + 1] = var2_76
			arg1_75[#arg1_75 + 1] = var2_76
		end
	end

	for iter6_75, iter7_75 in pairs(arg3_75) do
		for iter8_75, iter9_75 in ipairs(iter7_75) do
			var6_75(iter9_75, iter6_75)
		end
	end

	return arg1_75
end

function var0_0.isClear(arg0_78, arg1_78)
	local var0_78 = arg0_78:GetChapterItemById(arg1_78)

	if not var0_78 then
		return false
	end

	return var0_78:isClear()
end

function var0_0.getEscortShop(arg0_79)
	return Clone(arg0_79.escortShop)
end

function var0_0.updateEscortShop(arg0_80, arg1_80)
	arg0_80.escortShop = arg1_80
end

function var0_0.recordLastMap(arg0_81, arg1_81, arg2_81)
	local var0_81 = false

	if arg1_81 == var0_0.LAST_MAP_FOR_ACTIVITY then
		Map.lastMapForActivity = arg2_81
		var0_81 = true
	elseif arg1_81 == var0_0.LAST_MAP and arg2_81 ~= Map.lastMap then
		Map.lastMap = arg2_81
		var0_81 = true
	end

	if var0_81 then
		local var1_81 = getProxy(PlayerProxy):getRawData()

		PlayerPrefs.SetInt(arg1_81 .. var1_81.id, arg2_81)
		PlayerPrefs.Save()
	end
end

function var0_0.getLastMap(arg0_82, arg1_82)
	local var0_82 = getProxy(PlayerProxy):getRawData()
	local var1_82 = PlayerPrefs.GetInt(arg1_82 .. var0_82.id)

	if var1_82 ~= 0 then
		return var1_82
	end
end

function var0_0.IsActivitySPChapterActive(arg0_83)
	local var0_83 = arg0_83:getMapsByActivities()
	local var1_83 = _.select(var0_83, function(arg0_84)
		return arg0_84:getMapType() == Map.ACT_EXTRA
	end)
	local var2_83 = _.reduce(var1_83, {}, function(arg0_85, arg1_85)
		local var0_85 = _.select(arg1_85:getChapters(true), function(arg0_86)
			return arg0_86:getPlayType() == ChapterConst.TypeRange
		end)

		return table.mergeArray(arg0_85, var0_85)
	end)

	return _.any(var2_83, function(arg0_87)
		return arg0_87:isUnlock() and arg0_87:isPlayerLVUnlock() and arg0_87:enoughTimes2Start()
	end)
end

function var0_0.getSubAidFlag(arg0_88, arg1_88)
	local var0_88 = ys.Battle.BattleConst.SubAidFlag
	local var1_88 = arg0_88.fleet
	local var2_88 = false
	local var3_88 = _.detect(arg0_88.fleets, function(arg0_89)
		return arg0_89:getFleetType() == FleetType.Submarine and arg0_89:isValid()
	end)

	if var3_88 then
		if var3_88:inHuntingRange(var1_88.line.row, var1_88.line.column) then
			var2_88 = true
		else
			local var4_88 = var3_88:getStrategies()
			local var5_88 = _.detect(var4_88, function(arg0_90)
				return arg0_90.id == ChapterConst.StrategyCallSubOutofRange
			end)

			if var5_88 and var5_88.count > 0 then
				var2_88 = true
			end
		end
	end

	if var2_88 then
		local var6_88 = getProxy(PlayerProxy):getRawData()
		local var7_88, var8_88 = arg0_88:getFleetCost(var1_88, arg1_88)
		local var9_88, var10_88 = arg0_88:getFleetAmmo(var3_88)
		local var11_88 = 0

		for iter0_88, iter1_88 in ipairs({
			arg0_88:getFleetCost(var3_88, arg1_88)
		}) do
			var11_88 = var11_88 + iter1_88.oil
		end

		if var10_88 <= 0 then
			return var0_88.AMMO_EMPTY
		elseif var11_88 + var8_88.oil >= var6_88.oil then
			return var0_88.OIL_EMPTY
		else
			return true, var3_88
		end
	else
		return var0_88.AID_EMPTY
	end
end

function var0_0.GetChapterAuraBuffs(arg0_91)
	local var0_91 = {}

	for iter0_91, iter1_91 in ipairs(arg0_91.fleets) do
		if iter1_91:getFleetType() ~= FleetType.Support then
			local var1_91 = iter1_91:getMapAura()

			for iter2_91, iter3_91 in ipairs(var1_91) do
				table.insert(var0_91, iter3_91)
			end
		end
	end

	return var0_91
end

function var0_0.GetChapterAidBuffs(arg0_92)
	local var0_92 = {}

	for iter0_92, iter1_92 in ipairs(arg0_92.fleets) do
		if iter1_92 ~= arg0_92.fleet and iter1_92:getFleetType() ~= FleetType.Support then
			local var1_92 = iter1_92:getMapAid()

			for iter2_92, iter3_92 in pairs(var1_92) do
				var0_92[iter2_92] = iter3_92
			end
		end
	end

	return var0_92
end

function var0_0.RecordComboHistory(arg0_93, arg1_93, arg2_93)
	if arg2_93 ~= nil then
		arg0_93:SetExtendChapterData(arg1_93, "comboHistoryBuffer", arg2_93)
	else
		arg0_93:RemoveExtendChapterData(arg1_93, "comboHistoryBuffer")
	end
end

function var0_0.GetComboHistory(arg0_94, arg1_94)
	return arg0_94:GetExtendChapterData(arg1_94, "comboHistoryBuffer")
end

function var0_0.RecordJustClearChapters(arg0_95, arg1_95, arg2_95)
	if arg2_95 ~= nil then
		arg0_95:SetExtendChapterData(arg1_95, "justClearChapters", arg2_95)
	else
		arg0_95:RemoveExtendChapterData(arg1_95, "justClearChapters")
	end
end

function var0_0.GetJustClearChapters(arg0_96, arg1_96)
	return arg0_96:GetExtendChapterData(arg1_96, "justClearChapters")
end

function var0_0.RecordLastDefeatedEnemy(arg0_97, arg1_97, arg2_97)
	if arg2_97 ~= nil then
		arg0_97:SetExtendChapterData(arg1_97, "defeatedEnemiesBuffer", arg2_97)
	else
		arg0_97:RemoveExtendChapterData(arg1_97, "defeatedEnemiesBuffer")
	end
end

function var0_0.GetLastDefeatedEnemy(arg0_98, arg1_98)
	return arg0_98:GetExtendChapterData(arg1_98, "defeatedEnemiesBuffer")
end

function var0_0.ifShowRemasterTip(arg0_99)
	return arg0_99.remasterTip
end

function var0_0.setRemasterTip(arg0_100, arg1_100)
	arg0_100.remasterTip = arg1_100
end

function var0_0.updateRemasterTicketsNum(arg0_101, arg1_101)
	arg0_101.remasterTickets = arg1_101
end

function var0_0.resetDailyCount(arg0_102)
	arg0_102.remasterDailyCount = 0
end

function var0_0.updateDailyCount(arg0_103)
	arg0_103.remasterDailyCount = arg0_103.remasterDailyCount + pg.gameset.reactivity_ticket_daily.key_value
end

function var0_0.GetSkipPrecombat(arg0_104)
	if arg0_104.skipPrecombat == nil then
		arg0_104.skipPrecombat = PlayerPrefs.GetInt("chapter_skip_precombat", 0)
	end

	return arg0_104.skipPrecombat > 0
end

function var0_0.UpdateSkipPrecombat(arg0_105, arg1_105)
	arg1_105 = tobool(arg1_105) and 1 or 0

	if arg1_105 ~= arg0_105:GetSkipPrecombat() then
		PlayerPrefs.SetInt("chapter_skip_precombat", arg1_105)

		arg0_105.skipPrecombat = arg1_105

		arg0_105:sendNotification(var0_0.CHAPTER_SKIP_PRECOMBAT_UPDATED, arg1_105)
	end
end

function var0_0.GetChapterAutoFlag(arg0_106, arg1_106)
	return arg0_106:GetExtendChapterData(arg1_106, "AutoFightFlag")
end

function var0_0.SetChapterAutoFlag(arg0_107, arg1_107, arg2_107, arg3_107)
	arg2_107 = tobool(arg2_107)

	if arg2_107 == (arg0_107:GetChapterAutoFlag(arg1_107) == 1) then
		return
	end

	arg0_107:SetExtendChapterData(arg1_107, "AutoFightFlag", arg2_107 and 1 or 0)

	if arg2_107 then
		arg0_107:UpdateSkipPrecombat(true)

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
		arg0_107:StopContinuousOperation(SYSTEM_SCENARIO, arg3_107)
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end
	end

	arg0_107.facade:sendNotification(var0_0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED, arg2_107 and 1 or 0)
	arg0_107.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, not arg2_107)
end

function var0_0.StopAutoFight(arg0_108, arg1_108)
	local var0_108 = arg0_108:getActiveChapter(true)

	if not var0_108 then
		return
	end

	arg0_108:SetChapterAutoFlag(var0_108.id, false, arg1_108)
end

function var0_0.FinishAutoFight(arg0_109, arg1_109)
	if arg0_109:GetChapterAutoFlag(arg1_109) == 1 then
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end

		arg0_109.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
	end

	local var0_109 = arg0_109:GetExtendChapter(arg1_109)

	arg0_109:RemoveExtendChapter(arg1_109)

	return var0_109
end

function var0_0.buildRemasterInfo(arg0_110)
	arg0_110.remasterInfo = {}

	for iter0_110, iter1_110 in ipairs(pg.re_map_template.all) do
		for iter2_110, iter3_110 in ipairs(pg.re_map_template[iter1_110].drop_gain) do
			if #iter3_110 > 0 then
				local var0_110, var1_110, var2_110, var3_110 = unpack(iter3_110)

				arg0_110.remasterInfo[var0_110] = defaultValue(arg0_110.remasterInfo[var0_110], {})
				arg0_110.remasterInfo[var0_110][iter2_110] = {
					count = 0,
					receive = false,
					max = var3_110
				}
			end
		end
	end
end

function var0_0.checkRemasterInfomation(arg0_111)
	if not arg0_111.checkRemaster then
		arg0_111.checkRemaster = true

		arg0_111:sendNotification(GAME.CHAPTER_REMASTER_INFO_REQUEST)
	end
end

function var0_0.addRemasterPassCount(arg0_112, arg1_112)
	if not arg0_112.remasterInfo[arg1_112] then
		return
	end

	local var0_112

	for iter0_112, iter1_112 in pairs(arg0_112.remasterInfo[arg1_112]) do
		if iter1_112.count < iter1_112.max then
			iter1_112.count = iter1_112.count + 1
			var0_112 = true
		end
	end

	if var0_112 then
		arg0_112:sendNotification(var0_0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0_0.markRemasterPassReceive(arg0_113, arg1_113, arg2_113)
	local var0_113 = arg0_113.remasterInfo[arg1_113][arg2_113]

	if not arg0_113.remasterInfo[arg1_113][arg2_113] then
		return
	end

	if not var0_113.receive then
		var0_113.receive = true

		arg0_113:sendNotification(var0_0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0_0.anyRemasterAwardCanReceive(arg0_114)
	for iter0_114, iter1_114 in pairs(arg0_114.remasterInfo) do
		for iter2_114, iter3_114 in pairs(iter1_114) do
			if not iter3_114.receive and iter3_114.count >= iter3_114.max then
				return true
			end
		end
	end

	return false
end

function var0_0.AddActBossRewards(arg0_115, arg1_115)
	arg0_115.actBossItems = arg0_115.actBossItems or {}

	table.insertto(arg0_115.actBossItems, arg1_115)
end

function var0_0.PopActBossRewards(arg0_116)
	local var0_116 = arg0_116.actBossItems or {}

	arg0_116.actBossItems = nil

	return var0_116
end

function var0_0.AddBossSingleRewards(arg0_117, arg1_117)
	arg0_117.bossSingleItems = arg0_117.bossSingleItems or {}

	table.insertto(arg0_117.bossSingleItems, arg1_117)
end

function var0_0.PopBossSingleRewards(arg0_118)
	local var0_118 = arg0_118.bossSingleItems or {}

	arg0_118.bossSingleItems = nil

	return var0_118
end

function var0_0.WriteBackOnExitBattleResult(arg0_119)
	local var0_119 = arg0_119:getActiveChapter()

	if var0_119 then
		if var0_119:existOni() then
			var0_119:clearSubmarineFleet()
			arg0_119:updateChapter(var0_119)
		elseif var0_119:isPlayingWithBombEnemy() then
			var0_119.fleets = {
				var0_119.fleet
			}
			var0_119.findex = 1

			arg0_119:updateChapter(var0_119)
		end
	end
end

function var0_0.GetContinuousData(arg0_120, arg1_120)
	return arg0_120.continuousData[arg1_120]
end

function var0_0.InitContinuousTime(arg0_121, arg1_121, arg2_121)
	local var0_121 = ContinuousOperationRuntimeData.New({
		system = arg1_121,
		totalBattleTime = arg2_121,
		battleTime = arg2_121
	})

	arg0_121.continuousData[arg1_121] = var0_121
end

function var0_0.StopContinuousOperation(arg0_122, arg1_122, arg2_122)
	local var0_122 = arg0_122:GetContinuousData(arg1_122)

	if not var0_122 or not var0_122:IsActive() then
		return
	end

	if arg2_122 == ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL and arg1_122 == SYSTEM_SCENARIO then
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_stop"))
	end

	var0_122:Stop(arg2_122)
end

function var0_0.PopContinuousData(arg0_123, arg1_123)
	local var0_123 = arg0_123.continuousData[arg1_123]

	arg0_123.continuousData[arg1_123] = nil

	return var0_123
end

function var0_0.SetLastFleetIndex(arg0_124, arg1_124, arg2_124)
	if arg2_124 and arg0_124.lastFleetIndex then
		return
	end

	arg0_124.lastFleetIndex = arg1_124
end

function var0_0.GetLastFleetIndex(arg0_125)
	return arg0_125.lastFleetIndex
end

return var0_0
