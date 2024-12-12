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
			var1_6 = bit.bor(var1_6, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)

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

			var1_6 = bit.bor(var1_6, ChapterConst.DirtyCellFlag)
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
	arg0_13.mapEliteCommanderCache = {}
	arg0_13.mapSupportFleetCache = {}

	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		var0_13[iter1_13.map_id] = var0_13[iter1_13.map_id] or {}

		table.insert(var0_13[iter1_13.map_id], iter1_13)
	end

	for iter2_13, iter3_13 in pairs(var0_13) do
		arg0_13.mapEliteFleetCache[iter2_13], arg0_13.mapEliteCommanderCache[iter2_13], arg0_13.mapSupportFleetCache[iter2_13] = Chapter.BuildEliteFleetList(iter3_13)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter4_13, iter5_13 in pairs(arg0_13.data) do
		local var1_13 = iter5_13:getConfig("formation")

		iter5_13:setEliteFleetList(Clone(arg0_13.mapEliteFleetCache[var1_13]) or {
			{},
			{},
			{}
		})
		iter5_13:setEliteCommanders(Clone(arg0_13.mapEliteCommanderCache[var1_13]) or {
			{},
			{},
			{}
		})
		iter5_13:setSupportFleetList(Clone(arg0_13.mapSupportFleetCache[var1_13]) or {
			{},
			{},
			{}
		})
		arg0_13:updateChapter(iter5_13)
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
		var0_0.MapToChapters[iter0_15] = table.mergeArray(var0_0.MapToChapters[iter0_15], iter1_15)
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

	_.each(pg.re_map_template.all, function(arg0_18)
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
	return _.detect(pg.re_map_template.all, function(arg0_21)
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

		if var0_32:getConfig("type") == Chapter.CustomFleet then
			var0_32:setEliteFleetList(Clone(arg0_32.mapEliteFleetCache[var1_32]) or {
				{},
				{},
				{}
			})
			var0_32:setEliteCommanders(Clone(arg0_32.mapEliteCommanderCache[var1_32]) or {
				{},
				{},
				{}
			})
		elseif var0_32:getConfig("type") == Chapter.SelectFleet then
			var0_32:setSupportFleetList(Clone(arg0_32.mapSupportFleetCache[var1_32]) or {
				{},
				{},
				{}
			})
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

function var0_0.getMapsByActivities(arg0_43)
	local var0_43 = {}
	local var1_43 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

	underscore.each(var1_43, function(arg0_44)
		if not arg0_44:isEnd() then
			var0_43 = table.mergeArray(var0_43, arg0_43:getMapsByActId(arg0_44.id))
		end
	end)

	return var0_43
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
	local var0_46 = arg1_46:updateExtraFlags(arg2_46, arg3_46)

	if not arg4_46 and not var0_46 then
		return
	end

	local var1_46 = {}

	for iter0_46, iter1_46 in ipairs(arg2_46) do
		table.insert(var1_46, iter1_46)
	end

	arg0_46:SetExtendChapterData(arg1_46.id, "extraFlagUpdate", var1_46)

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
	if arg1_56:getConfig("type") ~= Chapter.CustomFleet then
		return
	end

	local var0_56 = arg1_56:getEliteFleetList()
	local var1_56 = arg1_56:getEliteFleetCommanders()
	local var2_56 = arg1_56:getConfig("formation")

	arg0_56.mapEliteFleetCache[var2_56] = Clone(var0_56)
	arg0_56.mapEliteCommanderCache[var2_56] = Clone(var1_56)

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")

	for iter0_56, iter1_56 in ipairs(var0_0.FormationToChapters[var2_56]) do
		local var3_56 = arg0_56:getChapterById(iter1_56, true)

		if var3_56.configId ~= arg1_56.configId then
			var3_56:setEliteFleetList(Clone(var0_56))
			var3_56:setEliteCommanders(Clone(var1_56))
			arg0_56:updateChapter(var3_56)
		end
	end
end

function var0_0.duplicateSupportFleet(arg0_57, arg1_57)
	local var0_57 = arg1_57:getSupportFleet()
	local var1_57 = arg1_57:getConfig("formation")

	arg0_57.mapSupportFleetCache[var1_57] = {
		Clone(var0_57)
	}

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter0_57, iter1_57 in ipairs(var0_0.FormationToChapters[var1_57]) do
		local var2_57 = arg0_57:getChapterById(iter1_57, true)

		if var2_57.configId ~= arg1_57.configId then
			var2_57:setSupportFleetList({
				Clone(var0_57)
			})
			arg0_57:updateChapter(var2_57)
		end
	end
end

function var0_0.CheckUnitInSupportFleet(arg0_58, arg1_58)
	local var0_58 = {}
	local var1_58 = arg1_58.id

	for iter0_58, iter1_58 in pairs(arg0_58.mapSupportFleetCache) do
		for iter2_58, iter3_58 in ipairs(iter1_58) do
			if table.contains(iter3_58, var1_58) then
				var0_58[iter0_58] = true

				break
			end
		end
	end

	return next(var0_58), var0_58
end

function var0_0.RemoveUnitFromSupportFleet(arg0_59, arg1_59)
	arg0_59:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
		shipId = arg1_59.id,
		callback = next
	})
end

function var0_0.getActiveChapter(arg0_60, arg1_60)
	for iter0_60, iter1_60 in pairs(arg0_60.data) do
		if iter1_60.active then
			return arg1_60 and iter1_60 or iter1_60:clone()
		end
	end
end

function var0_0.GetLastNormalMap(arg0_61)
	local var0_61 = Map.lastMap and arg0_61:getMapById(Map.lastMap)

	if var0_61 and var0_61:isUnlock() and var0_61:getMapType() == Map.SCENARIO then
		return Map.lastMap
	end

	return arg0_61:getLastUnlockMap().id
end

function var0_0.getLastMapForActivity(arg0_62)
	local var0_62
	local var1_62
	local var2_62 = arg0_62:getActiveChapter()

	if var2_62 then
		local var3_62 = arg0_62:getMapById(var2_62:getConfig("map"))

		if var3_62:isActivity() and not var3_62:isRemaster() then
			return var3_62.id, var2_62.id
		end
	end

	local var4_62 = Map.lastMapForActivity and arg0_62:getMapById(Map.lastMapForActivity)

	if var4_62 and not var4_62:isRemaster() and var4_62:isUnlock() then
		return Map.lastMapForActivity
	end

	if Map.lastMapForActivity then
		arg0_62:recordLastMap(var0_0.LAST_MAP_FOR_ACTIVITY, 0)
	end

	local var5_62 = arg0_62:getMapsByActivities()

	table.sort(var5_62, function(arg0_63, arg1_63)
		return arg0_63.id > arg1_63.id
	end)

	local var6_62 = {}

	if _.all(var5_62, function(arg0_64)
		return arg0_64:getConfig("type") == Map.EVENT
	end) then
		var6_62 = var5_62
	else
		for iter0_62, iter1_62 in ipairs({
			Map.ACTIVITY_EASY,
			Map.ACTIVITY_HARD
		}) do
			local var7_62 = underscore.filter(var5_62, function(arg0_65)
				return arg0_65:getMapType() == iter1_62
			end)

			if #var7_62 > 0 then
				var6_62 = var7_62

				if underscore.any(var6_62, function(arg0_66)
					return not arg0_66:isClearForActivity()
				end) then
					break
				end
			end
		end
	end

	for iter2_62 = #var6_62, 1, -1 do
		local var8_62 = var6_62[iter2_62]

		if var8_62:isUnlock() then
			return var8_62.id
		end
	end

	if #var5_62 > 0 then
		return var5_62[1].id
	end
end

function var0_0.updateActiveChapterShips(arg0_67)
	local var0_67 = arg0_67:getActiveChapter(true)

	if var0_67 then
		_.each(var0_67.fleets, function(arg0_68)
			arg0_68:flushShips()
		end)
		arg0_67:updateChapter(var0_67, ChapterConst.DirtyFleet)
	end
end

function var0_0.resetRepairTimes(arg0_69)
	arg0_69.repairTimes = 0
end

function var0_0.getUseableEliteMap(arg0_70)
	local var0_70 = {}

	for iter0_70, iter1_70 in ipairs(arg0_70:getMapsByType(Map.ELITE)) do
		if iter1_70:isEliteEnabled() then
			var0_70[#var0_70 + 1] = iter1_70
		end
	end

	return var0_70
end

function var0_0.getUseableMaxEliteMap(arg0_71)
	local var0_71 = arg0_71:getUseableEliteMap()

	if #var0_71 == 0 then
		return false
	else
		local var1_71

		for iter0_71, iter1_71 in ipairs(var0_71) do
			if not var1_71 or var1_71.id < iter1_71.id then
				var1_71 = iter1_71
			end
		end

		return var1_71
	end
end

function var0_0.getHigestClearChapterAndMap(arg0_72)
	local var0_72 = arg0_72.baseMaps[1]

	for iter0_72, iter1_72 in ipairs(arg0_72:getNormalMaps()) do
		if not iter1_72:isAnyChapterClear() then
			break
		end

		var0_72 = iter1_72
	end

	local var1_72 = arg0_72:getChapterById(var0_72.chapterIds[1])

	for iter2_72, iter3_72 in ipairs(var0_72:getChapters()) do
		if not iter3_72:isClear() then
			break
		end

		var1_72 = iter3_72
	end

	return var1_72, var0_72
end

function var0_0.SortRecommendLimitation(arg0_73)
	table.sort(arg0_73, CompareFuncs({
		function(arg0_74)
			if type(arg0_74) == "number" then
				if arg0_74 == 0 then
					return 1
				else
					return -arg0_74
				end
			elseif type(arg0_74) == "string" then
				return 0
			else
				assert(false)
			end
		end
	}))
end

function var0_0.eliteFleetRecommend(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg1_75:getEliteFleetList()[arg2_75]
	local var1_75 = arg1_75:getConfig("limitation")[arg2_75]
	local var2_75 = var1_75 and Clone(var1_75[1]) or {
		0,
		0,
		0
	}
	local var3_75 = var1_75 and Clone(var1_75[2]) or {
		0,
		0,
		0
	}
	local var4_75 = {
		0,
		0,
		0
	}

	var0_0.SortRecommendLimitation(var2_75)
	var0_0.SortRecommendLimitation(var3_75)
	var0_0.SortRecommendLimitation(var4_75)

	local var5_75 = {}

	for iter0_75, iter1_75 in ipairs(arg1_75:getEliteFleetList()) do
		for iter2_75, iter3_75 in ipairs(iter1_75) do
			var5_75[#var5_75 + 1] = iter3_75
		end
	end

	local var6_75

	if arg2_75 > 2 then
		var6_75 = {
			[TeamType.Submarine] = var4_75
		}
	else
		var6_75 = {
			[TeamType.Main] = var2_75,
			[TeamType.Vanguard] = var3_75
		}
	end

	local var7_75 = arg0_75:FleetRecommend(var0_75, var5_75, var6_75, function(arg0_76)
		return ShipStatus.ShipStatusCheck("inElite", arg0_76, nil, {
			inElite = arg1_75:getConfig("formation")
		})
	end)

	table.clean(var0_75)
	table.insertto(var0_75, var7_75)
end

function var0_0.SupportFleetRecommend(arg0_77, arg1_77, arg2_77)
	local var0_77 = arg1_77:getSupportFleet()
	local var1_77 = {
		[TeamType.Main] = {
			"hang",
			"hang",
			"hang"
		}
	}
	local var2_77 = table.shallowCopy(var0_77)
	local var3_77 = arg0_77:FleetRecommend(var0_77, var2_77, var1_77, function(arg0_78)
		return ShipStatus.ShipStatusCheck("inSupport", arg0_78, nil, {
			inSupport = arg1_77:getConfig("formation")
		})
	end)

	table.clean(var0_77)
	table.insertto(var0_77, var3_77)
end

function var0_0.FleetRecommend(arg0_79, arg1_79, arg2_79, arg3_79, arg4_79)
	arg1_79 = table.shallowCopy(arg1_79)
	arg2_79 = table.shallowCopy(arg2_79)

	local var0_79 = getProxy(BayProxy)
	local var1_79 = getProxy(BayProxy):getRawData()

	for iter0_79, iter1_79 in ipairs(arg1_79) do
		local var2_79 = var1_79[iter1_79]:getShipType()
		local var3_79 = TeamType.GetTeamFromShipType(var2_79)
		local var4_79 = 0
		local var5_79 = arg3_79[var3_79]

		for iter2_79, iter3_79 in ipairs(var5_79) do
			if ShipType.ContainInLimitBundle(iter3_79, var2_79) then
				var4_79 = iter3_79

				break
			end
		end

		for iter4_79, iter5_79 in ipairs(var5_79) do
			if iter5_79 == var4_79 then
				table.remove(var5_79, iter4_79)

				break
			end
		end
	end

	local function var6_79(arg0_80, arg1_80)
		local var0_80 = underscore.filter(TeamType.GetShipTypeListFromTeam(arg1_80), function(arg0_81)
			return ShipType.ContainInLimitBundle(arg0_80, arg0_81)
		end)
		local var1_80 = var0_79:GetRecommendShip(var0_80, arg2_79, arg4_79)

		if var1_80 then
			local var2_80 = var1_80.id

			arg2_79[#arg2_79 + 1] = var2_80
			arg1_79[#arg1_79 + 1] = var2_80
		end
	end

	for iter6_79, iter7_79 in pairs(arg3_79) do
		for iter8_79, iter9_79 in ipairs(iter7_79) do
			var6_79(iter9_79, iter6_79)
		end
	end

	return arg1_79
end

function var0_0.isClear(arg0_82, arg1_82)
	local var0_82 = arg0_82:GetChapterItemById(arg1_82)

	if not var0_82 then
		return false
	end

	return var0_82:isClear()
end

function var0_0.recordLastMap(arg0_83, arg1_83, arg2_83)
	local var0_83 = false

	if arg1_83 == var0_0.LAST_MAP_FOR_ACTIVITY and arg2_83 ~= Map.lastMapForActivity then
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
