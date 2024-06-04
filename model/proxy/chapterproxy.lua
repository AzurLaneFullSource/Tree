local var0 = class("ChapterProxy", import(".NetProxy"))

var0.CHAPTER_UPDATED = "ChapterProxy:CHAPTER_UPDATED"
var0.CHAPTER_TIMESUP = "ChapterProxy:CHAPTER_TIMESUP"
var0.CHAPTER_CELL_UPDATED = "ChapterProxy:CHAPTER_CELL_UPDATED"
var0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED = "CHAPTERPROXY:CHAPTER_AUTO_FIGHT_FLAG_UPDATED"
var0.CHAPTER_SKIP_PRECOMBAT_UPDATED = "CHAPTERPROXY:CHAPTER_SKIP_PRECOMBAT_UPDATED"
var0.CHAPTER_REMASTER_INFO_UPDATED = "CHAPTERPROXY:CHAPTER_REMASTER_INFO_UPDATED"
var0.LAST_MAP_FOR_ACTIVITY = "last_map_for_activity"
var0.LAST_MAP = "last_map"

function var0.register(arg0)
	arg0:on(13001, function(arg0)
		arg0.mapEliteFleetCache = {}
		arg0.mapEliteCommanderCache = {}
		arg0.mapSupportFleetCache = {}

		local var0 = {}

		for iter0, iter1 in ipairs(arg0.fleet_list) do
			var0[iter1.map_id] = var0[iter1.map_id] or {}

			table.insert(var0[iter1.map_id], iter1)
		end

		for iter2, iter3 in pairs(var0) do
			arg0.mapEliteFleetCache[iter2], arg0.mapEliteCommanderCache[iter2], arg0.mapSupportFleetCache[iter2] = Chapter.BuildEliteFleetList(iter3)
		end

		for iter4, iter5 in ipairs(arg0.chapter_list) do
			if not pg.chapter_template[iter5.id] then
				errorMsg("chapter_template not exist: " .. iter5.id)
			else
				local var1 = Chapter.New(iter5)
				local var2 = var1:getConfig("formation")

				var1:setEliteFleetList(Clone(arg0.mapEliteFleetCache[var2]) or {
					{},
					{},
					{}
				})
				var1:setEliteCommanders(Clone(arg0.mapEliteCommanderCache[var2]) or {
					{},
					{},
					{}
				})
				var1:setSupportFleetList(Clone(arg0.mapSupportFleetCache[var2]) or {
					{}
				})
				arg0:updateChapter(var1)
			end
		end

		if arg0.current_chapter then
			local var3 = arg0.current_chapter.id

			if var3 > 0 then
				local var4 = arg0:getChapterById(var3, true)

				var4:update(arg0.current_chapter)
				arg0:updateChapter(var4)
			end
		end

		arg0.repairTimes = arg0.daily_repair_count

		if arg0.react_chapter then
			arg0.remasterTickets = arg0.react_chapter.count
			arg0.remasterDailyCount = arg0.react_chapter.daily_count
			arg0.remasterTip = not (arg0.remasterDailyCount > 0)
		end

		Map.lastMap = arg0:getLastMap(var0.LAST_MAP)
		Map.lastMapForActivity = arg0:getLastMap(var0.LAST_MAP_FOR_ACTIVITY)

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")
	end)

	arg0.timers = {}
	arg0.escortChallengeTimes = 0
	arg0.chaptersExtend = {}
	arg0.chapterStoryGroups = {}
	arg0.continuousData = {}

	arg0:buildMaps()
	arg0:buildRemasterInfo()
end

function var0.OnBattleFinished(arg0, arg1, arg2)
	local var0 = arg0:getActiveChapter()

	if var0 then
		local var1 = 0

		local function var2()
			local var0 = getProxy(ContextProxy)

			if not var0 then
				return
			end

			if var0:getCurrentContext().mediator == LevelMediator2 then
				var1 = bit.bor(var1, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

				arg0:SetChapterAutoFlag(var0.id, false)

				return
			end

			local var1 = var0:getContextByMediator(LevelMediator2)

			if not var1 then
				return
			end

			var1.data.StopAutoFightFlag = true
		end

		if _.any(arg1.ai_list, function(arg0)
			return arg0.item_type == ChapterConst.AttachOni
		end) then
			var0:onOniEnter()
			var2()
		end

		if _.any(arg1.map_update, function(arg0)
			return arg0.item_type == ChapterConst.AttachBomb_Enemy
		end) then
			var0:onBombEnemyEnter()
			var2()
		end

		if #arg1.map_update > 0 then
			_.each(arg1.map_update, function(arg0)
				if arg0.item_type == ChapterConst.AttachStory and arg0.item_data == ChapterConst.StoryTrigger then
					local var0 = ChapterCell.Line2Name(arg0.pos.row, arg0.pos.column)
					local var1 = var0:GetChapterCellAttachemnts()
					local var2 = var1[var0]

					if var2 then
						if var2.flag == ChapterConst.CellFlagTriggerActive and arg0.item_flag == ChapterConst.CellFlagTriggerDisabled then
							local var3 = pg.map_event_template[var2.attachmentId].gametip

							if var3 ~= "" then
								pg.TipsMgr.GetInstance():ShowTips(i18n(var3))
							end
						end

						var2.attachment = arg0.item_type
						var2.attachmentId = arg0.item_id
						var2.flag = arg0.item_flag
						var2.data = arg0.item_data
					else
						var1[var0] = ChapterCell.New(arg0)
					end
				elseif arg0.item_type ~= ChapterConst.AttachNone and arg0.item_type ~= ChapterConst.AttachBorn and arg0.item_type ~= ChapterConst.AttachBorn_Sub and arg0.item_type ~= ChapterConst.AttachOni_Target and arg0.item_type ~= ChapterConst.AttachOni then
					local var4 = ChapterCell.New(arg0)

					var0:mergeChapterCell(var4)
				end
			end)

			var1 = bit.bor(var1, ChapterConst.DirtyAttachment, ChapterConst.DirtyAutoAction)
		end

		if #arg1.ai_list > 0 then
			_.each(arg1.ai_list, function(arg0)
				local var0 = ChapterChampionPackage.New(arg0)

				var0:mergeChampion(var0)
			end)

			var1 = bit.bor(var1, ChapterConst.DirtyChampion, ChapterConst.DirtyAutoAction)
		end

		if #arg1.add_flag_list > 0 or #arg1.del_flag_list > 0 then
			var1 = bit.bor(var1, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)

			arg0:updateExtraFlag(var0, arg1.add_flag_list, arg1.del_flag_list)
		end

		if #arg1.buff_list > 0 then
			var0:UpdateBuffList(arg1.buff_list)
		end

		if #arg1.cell_flag_list > 0 then
			_.each(arg1.cell_flag_list, function(arg0)
				local var0 = var0:getChapterCell(arg0.pos.row, arg0.pos.column)

				if var0 then
					var0:updateFlagList(arg0)
				else
					var0 = ChapterCell.New(arg0)
				end

				var0:updateChapterCell(var0)
			end)

			var1 = bit.bor(var1, ChapterConst.DirtyCellFlag)
		end

		arg0:updateChapter(var0, var1)

		if arg2 then
			arg0:sendNotification(GAME.CHAPTER_OP_DONE, {
				type = ChapterConst.OpSkipBattle
			})
		end
	end
end

function var0.setEliteCache(arg0, arg1)
	arg0.mapEliteFleetCache = {}
	arg0.mapEliteCommanderCache = {}
	arg0.mapSupportFleetCache = {}

	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		var0[iter1.map_id] = var0[iter1.map_id] or {}

		table.insert(var0[iter1.map_id], iter1)
	end

	for iter2, iter3 in pairs(var0) do
		arg0.mapEliteFleetCache[iter2], arg0.mapEliteCommanderCache[iter2], arg0.mapSupportFleetCache[iter2] = Chapter.BuildEliteFleetList(iter3)
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter4, iter5 in pairs(arg0.data) do
		local var1 = iter5:getConfig("formation")

		iter5:setEliteFleetList(Clone(arg0.mapEliteFleetCache[var1]) or {
			{},
			{},
			{}
		})
		iter5:setEliteCommanders(Clone(arg0.mapEliteCommanderCache[var1]) or {
			{},
			{},
			{}
		})
		iter5:setSupportFleetList(Clone(arg0.mapSupportFleetCache[var1]) or {
			{},
			{},
			{}
		})
		arg0:updateChapter(iter5)
	end
end

function var0.buildMaps(arg0)
	arg0:initChapters()
	arg0:buildBaseMaps()
	arg0:buildRemasterMaps()
end

function var0.initChapters(arg0)
	var0.MapToChapters = table.shallowCopy(pg.chapter_template.get_id_list_by_map)

	for iter0, iter1 in pairs(pg.story_group.get_id_list_by_map) do
		var0.MapToChapters[iter0] = var0.MapToChapters[iter0] or {}
		var0.MapToChapters[iter0] = table.mergeArray(var0.MapToChapters[iter0], iter1)
	end

	var0.FormationToChapters = pg.chapter_template.get_id_list_by_formation
end

function var0.buildBaseMaps(arg0)
	var0.ActToMaps = {}
	var0.TypeToMaps = {}

	local var0 = {}

	for iter0, iter1 in ipairs(pg.expedition_data_by_map.all) do
		local var1 = Map.New({
			id = iter1,
			chapterIds = var0.MapToChapters[iter1]
		})

		var0[iter1] = var1

		local var2 = var1:getConfig("on_activity")

		if var2 ~= 0 then
			var0.ActToMaps[var2] = var0.ActToMaps[var2] or {}

			table.insert(var0.ActToMaps[var2], var1.id)
		end

		local var3 = var1:getMapType()

		var0.TypeToMaps[var3] = var0.TypeToMaps[var3] or {}

		table.insert(var0.TypeToMaps[var3], var1.id)
	end

	arg0.baseMaps = var0
end

function var0.buildRemasterMaps(arg0)
	var0.RemasterToMaps = {}

	local var0 = {}

	_.each(pg.re_map_template.all, function(arg0)
		local var0 = pg.re_map_template[arg0]

		_.each(var0.config_data, function(arg0)
			local var0 = arg0.baseMaps[pg.chapter_template[arg0].map]

			assert(not var0[var0.id] or var0[var0.id] == arg0, "remaster chapter error:" .. arg0)

			if not var0[var0.id] then
				var0[var0.id] = arg0

				var0:setRemaster(arg0)

				var0.RemasterToMaps[arg0] = var0.RemasterToMaps[arg0] or {}

				table.insert(var0.RemasterToMaps[arg0], var0.id)
			end
		end)
	end)
end

function var0.IsChapterInRemaster(arg0, arg1)
	return _.detect(pg.re_map_template.all, function(arg0)
		local var0 = pg.re_map_template[arg0]

		return _.any(var0.config_data, function(arg0)
			return arg0 == arg1
		end)
	end)
end

function var0.getMaxEscortChallengeTimes(arg0)
	return getProxy(ActivityProxy):getActivityParameter("escort_daily_count") or 0
end

function var0.getEscortChapterIds(arg0)
	return getProxy(ActivityProxy):getActivityParameter("escort_exp_id") or {}
end

function var0.resetEscortChallengeTimes(arg0)
	arg0.escortChallengeTimes = 0
end

function var0.addChapterListener(arg0, arg1)
	if not arg1.dueTime or not arg0.timers then
		return
	end

	if arg0.timers[arg1.id] then
		arg0.timers[arg1.id]:Stop()

		arg0.timers[arg1.id] = nil
	end

	local var0 = arg1.dueTime - pg.TimeMgr.GetInstance():GetServerTime()

	local function var1()
		arg0.data[arg1.id].dueTime = nil

		arg0.data[arg1.id]:display("times'up")
		arg0:sendNotification(var0.CHAPTER_UPDATED, {
			dirty = 0,
			chapter = arg0.data[arg1.id]:clone()
		})
		arg0:sendNotification(var0.CHAPTER_TIMESUP)
	end

	if var0 > 0 then
		arg0.timers[arg1.id] = Timer.New(function()
			var1()
			arg0.timers[arg1.id]:Stop()

			arg0.timers[arg1.id] = nil
		end, var0, 1)

		arg0.timers[arg1.id]:Start()
	else
		var1()
	end
end

function var0.removeChapterListener(arg0, arg1)
	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end
end

function var0.remove(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = nil
end

function var0.GetRawChapterById(arg0, arg1)
	return arg0.data[arg1]
end

function var0.getChapterById(arg0, arg1, arg2)
	local var0 = arg0.data[arg1]

	if not var0 then
		assert(pg.chapter_template[arg1], "Not Exist Chapter ID: " .. (arg1 or "NIL"))

		var0 = Chapter.New({
			id = arg1
		})

		local var1 = var0:getConfig("formation")

		if var0:getConfig("type") == Chapter.CustomFleet then
			var0:setEliteFleetList(Clone(arg0.mapEliteFleetCache[var1]) or {
				{},
				{},
				{}
			})
			var0:setEliteCommanders(Clone(arg0.mapEliteCommanderCache[var1]) or {
				{},
				{},
				{}
			})
		elseif var0:getConfig("type") == Chapter.SelectFleet then
			var0:setSupportFleetList(Clone(arg0.mapSupportFleetCache[var1]) or {
				{},
				{},
				{}
			})
		end

		arg0.data[arg1] = var0
	end

	return arg2 and var0 or var0:clone()
end

function var0.GetChapterItemById(arg0, arg1)
	if Chapter:bindConfigTable()[arg1] then
		return arg0:getChapterById(arg1, true)
	elseif ChapterStoryGroup:bindConfigTable()[arg1] then
		local var0 = arg0.chapterStoryGroups[arg1]

		if not var0 then
			var0 = ChapterStoryGroup.New({
				configId = arg1
			})
			arg0.chapterStoryGroups[arg1] = var0
		end

		return var0
	end
end

function var0.updateChapter(arg0, arg1, arg2)
	assert(isa(arg1, Chapter), "should be an instance of Chapter")

	local var0 = arg0.data[arg1.id]
	local var1 = arg1

	arg0.data[arg1.id] = var1

	if var0 then
		arg0:removeChapterListener(var0.id)
	end

	arg0:addChapterListener(var1)

	if getProxy(PlayerProxy):getInited() then
		arg0.facade:sendNotification(var0.CHAPTER_UPDATED, {
			chapter = var1:clone(),
			dirty = defaultValue(arg2, 0)
		})
	end

	if var1.active and var1.fleet then
		var1.fleet:clearShipHpChange()
	end

	if tobool(checkExist(var0, {
		"active"
	})) ~= tobool(var1.active) then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
	end
end

function var0.getMapById(arg0, arg1)
	return arg0.baseMaps[arg1]
end

function var0.getNormalMaps(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.baseMaps) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.getMapsByType(arg0, arg1)
	if var0.TypeToMaps[arg1] then
		return _.map(var0.TypeToMaps[arg1], function(arg0)
			return arg0:getMapById(arg0)
		end)
	else
		return {}
	end
end

function var0.getMapsByActId(arg0, arg1)
	if var0.ActToMaps[arg1] then
		return underscore.map(var0.ActToMaps[arg1], function(arg0)
			return arg0:getMapById(arg0)
		end)
	else
		return {}
	end
end

function var0.getRemasterMaps(arg0, arg1)
	if var0.RemasterToMaps[arg1] then
		return underscore.map(var0.RemasterToMaps[arg1], function(arg0)
			return arg0:getMapById(arg0)
		end)
	else
		return {}
	end
end

function var0.getMapsByActivities(arg0)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

	underscore.each(var1, function(arg0)
		if not arg0:isEnd() then
			var0 = table.mergeArray(var0, arg0:getMapsByActId(arg0.id))
		end
	end)

	return var0
end

function var0.getLastUnlockMap(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0:getNormalMaps()) do
		if not iter1:isUnlock() then
			break
		end

		var0 = iter1
	end

	return var0
end

function var0.updateExtraFlag(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:updateExtraFlags(arg2, arg3)

	if not arg4 and not var0 then
		return
	end

	local var1 = {}

	for iter0, iter1 in ipairs(arg2) do
		table.insert(var1, iter1)
	end

	arg0:SetExtendChapterData(arg1.id, "extraFlagUpdate", var1)

	return true
end

function var0.extraFlagUpdated(arg0, arg1)
	arg0:RemoveExtendChapterData(arg1, "extraFlagUpdate")
end

function var0.getUpdatedExtraFlags(arg0, arg1)
	return arg0:GetExtendChapterData(arg1, "extraFlagUpdate")
end

function var0.SetExtendChapterData(arg0, arg1, arg2, arg3)
	assert(arg1, "Missing Chapter ID")

	arg0.chaptersExtend[arg1] = arg0.chaptersExtend[arg1] or {}
	arg0.chaptersExtend[arg1][arg2] = arg3
end

function var0.AddExtendChapterDataArray(arg0, arg1, arg2, arg3, arg4)
	assert(arg1, "Missing Chapter ID")

	arg0.chaptersExtend[arg1] = arg0.chaptersExtend[arg1] or {}

	if type(arg0.chaptersExtend[arg1][arg2]) ~= "table" then
		assert(arg0.chaptersExtend[arg1][arg2] == nil, "Changing NonEmpty ExtendData " .. arg2 .. " to Table ID: " .. arg1)

		arg0.chaptersExtend[arg1][arg2] = {}
	end

	arg4 = arg4 or #arg0.chaptersExtend[arg1][arg2] + 1
	arg0.chaptersExtend[arg1][arg2][arg4] = arg3
end

function var0.AddExtendChapterDataTable(arg0, arg1, arg2, arg3, arg4)
	assert(arg1, "Missing Chapter ID")

	arg0.chaptersExtend[arg1] = arg0.chaptersExtend[arg1] or {}

	if type(arg0.chaptersExtend[arg1][arg2]) ~= "table" then
		assert(arg0.chaptersExtend[arg1][arg2] == nil, "Changing NonEmpty ExtendData " .. arg2 .. " to Table ID: " .. arg1)

		arg0.chaptersExtend[arg1][arg2] = {}
	end

	assert(arg3, "Missing Index on Set HashData")

	arg0.chaptersExtend[arg1][arg2][arg3] = arg4
end

function var0.GetExtendChapterData(arg0, arg1, arg2)
	assert(arg1, "Missing Chapter ID")
	assert(arg2, "Requesting Empty key")

	if not arg2 or not arg0.chaptersExtend[arg1] then
		return
	end

	return arg0.chaptersExtend[arg1][arg2]
end

function var0.RemoveExtendChapterData(arg0, arg1, arg2)
	assert(arg1, "Missing Chapter ID")

	if not arg2 or not arg0.chaptersExtend[arg1] then
		return
	end

	arg0.chaptersExtend[arg1][arg2] = nil

	if next(arg0.chaptersExtend[arg1]) then
		return
	end

	arg0:RemoveExtendChapter(arg1)
end

function var0.GetExtendChapter(arg0, arg1)
	assert(arg1, "Missing Chapter ID")

	return arg0.chaptersExtend[arg1]
end

function var0.RemoveExtendChapter(arg0, arg1)
	assert(arg1, "Missing Chapter ID")

	if not arg0.chaptersExtend[arg1] then
		return
	end

	arg0.chaptersExtend[arg1] = nil
end

function var0.duplicateEliteFleet(arg0, arg1)
	if arg1:getConfig("type") ~= Chapter.CustomFleet then
		return
	end

	local var0 = arg1:getEliteFleetList()
	local var1 = arg1:getEliteFleetCommanders()
	local var2 = arg1:getConfig("formation")

	arg0.mapEliteFleetCache[var2] = Clone(var0)
	arg0.mapEliteCommanderCache[var2] = Clone(var1)

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")

	for iter0, iter1 in ipairs(var0.FormationToChapters[var2]) do
		local var3 = arg0:getChapterById(iter1, true)

		if var3.configId ~= arg1.configId then
			var3:setEliteFleetList(Clone(var0))
			var3:setEliteCommanders(Clone(var1))
			arg0:updateChapter(var3)
		end
	end
end

function var0.duplicateSupportFleet(arg0, arg1)
	local var0 = arg1:getSupportFleet()
	local var1 = arg1:getConfig("formation")

	arg0.mapSupportFleetCache[var1] = {
		Clone(var0)
	}

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inSupport")

	for iter0, iter1 in ipairs(var0.FormationToChapters[var1]) do
		local var2 = arg0:getChapterById(iter1, true)

		if var2.configId ~= arg1.configId then
			var2:setSupportFleetList({
				Clone(var0)
			})
			arg0:updateChapter(var2)
		end
	end
end

function var0.CheckUnitInSupportFleet(arg0, arg1)
	local var0 = {}
	local var1 = arg1.id

	for iter0, iter1 in pairs(arg0.mapSupportFleetCache) do
		for iter2, iter3 in ipairs(iter1) do
			if table.contains(iter3, var1) then
				var0[iter0] = true

				break
			end
		end
	end

	return next(var0), var0
end

function var0.RemoveUnitFromSupportFleet(arg0, arg1)
	arg0:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP, {
		shipId = arg1.id,
		callback = next
	})
end

function var0.getActiveChapter(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1.active then
			return arg1 and iter1 or iter1:clone()
		end
	end
end

function var0.getLastMapForActivity(arg0)
	local var0
	local var1
	local var2 = arg0:getActiveChapter()

	if var2 then
		local var3 = arg0:getMapById(var2:getConfig("map"))

		if var3:isActivity() and not var3:isRemaster() then
			return var3.id, var2.id
		end
	end

	local var4 = Map.lastMapForActivity and arg0:getMapById(Map.lastMapForActivity)

	if var4 and not var4:isRemaster() and var4:isUnlock() then
		return Map.lastMapForActivity
	end

	if Map.lastMapForActivity then
		Map.lastMapForActivity = nil

		arg0:recordLastMap(var0.LAST_MAP_FOR_ACTIVITY, 0)
	end

	local var5 = arg0:getMapsByActivities()

	table.sort(var5, function(arg0, arg1)
		return arg0.id > arg1.id
	end)

	local var6 = {}

	if _.all(var5, function(arg0)
		return arg0:getConfig("type") == Map.EVENT
	end) then
		var6 = var5
	else
		for iter0, iter1 in ipairs({
			Map.ACTIVITY_EASY,
			Map.ACTIVITY_HARD
		}) do
			local var7 = underscore.filter(var5, function(arg0)
				return arg0:getMapType() == iter1
			end)

			if #var7 > 0 then
				var6 = var7

				if underscore.any(var6, function(arg0)
					return not arg0:isClearForActivity()
				end) then
					break
				end
			end
		end
	end

	for iter2 = #var6, 1, -1 do
		local var8 = var6[iter2]

		if var8:isUnlock() then
			return var8.id
		end
	end

	if #var5 > 0 then
		return var5[1].id
	end
end

function var0.updateActiveChapterShips(arg0)
	local var0 = arg0:getActiveChapter(true)

	if var0 then
		_.each(var0.fleets, function(arg0)
			arg0:flushShips()
		end)
		arg0:updateChapter(var0, ChapterConst.DirtyFleet)
	end
end

function var0.resetRepairTimes(arg0)
	arg0.repairTimes = 0
end

function var0.getUseableEliteMap(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getMapsByType(Map.ELITE)) do
		if iter1:isEliteEnabled() then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var0.getUseableMaxEliteMap(arg0)
	local var0 = arg0:getUseableEliteMap()

	if #var0 == 0 then
		return false
	else
		local var1

		for iter0, iter1 in ipairs(var0) do
			if not var1 or var1.id < iter1.id then
				var1 = iter1
			end
		end

		return var1
	end
end

function var0.getHigestClearChapterAndMap(arg0)
	local var0 = arg0.baseMaps[1]

	for iter0, iter1 in ipairs(arg0:getNormalMaps()) do
		if not iter1:isAnyChapterClear() then
			break
		end

		var0 = iter1
	end

	local var1 = arg0:getChapterById(var0.chapterIds[1])

	for iter2, iter3 in ipairs(var0:getChapters()) do
		if not iter3:isClear() then
			break
		end

		var1 = iter3
	end

	return var1, var0
end

function var0.SortRecommendLimitation(arg0)
	table.sort(arg0, CompareFuncs({
		function(arg0)
			if type(arg0) == "number" then
				if arg0 == 0 then
					return 1
				else
					return -arg0
				end
			elseif type(arg0) == "string" then
				return 0
			else
				assert(false)
			end
		end
	}))
end

function var0.eliteFleetRecommend(arg0, arg1, arg2)
	local var0 = arg1:getEliteFleetList()[arg2]
	local var1 = arg1:getConfig("limitation")[arg2]
	local var2 = var1 and Clone(var1[1]) or {
		0,
		0,
		0
	}
	local var3 = var1 and Clone(var1[2]) or {
		0,
		0,
		0
	}
	local var4 = {
		0,
		0,
		0
	}

	var0.SortRecommendLimitation(var2)
	var0.SortRecommendLimitation(var3)
	var0.SortRecommendLimitation(var4)

	local var5 = {}

	for iter0, iter1 in ipairs(arg1:getEliteFleetList()) do
		for iter2, iter3 in ipairs(iter1) do
			var5[#var5 + 1] = iter3
		end
	end

	local var6

	if arg2 > 2 then
		var6 = {
			[TeamType.Submarine] = var4
		}
	else
		var6 = {
			[TeamType.Main] = var2,
			[TeamType.Vanguard] = var3
		}
	end

	local var7 = arg0:FleetRecommend(var0, var5, var6, function(arg0)
		return ShipStatus.ShipStatusCheck("inElite", arg0, nil, {
			inElite = arg1:getConfig("formation")
		})
	end)

	table.clean(var0)
	table.insertto(var0, var7)
end

function var0.SupportFleetRecommend(arg0, arg1, arg2)
	local var0 = arg1:getSupportFleet()
	local var1 = {
		[TeamType.Main] = {
			"hang",
			"hang",
			"hang"
		}
	}
	local var2 = table.shallowCopy(var0)
	local var3 = arg0:FleetRecommend(var0, var2, var1, function(arg0)
		return ShipStatus.ShipStatusCheck("inSupport", arg0, nil, {
			inSupport = arg1:getConfig("formation")
		})
	end)

	table.clean(var0)
	table.insertto(var0, var3)
end

function var0.FleetRecommend(arg0, arg1, arg2, arg3, arg4)
	arg1 = table.shallowCopy(arg1)
	arg2 = table.shallowCopy(arg2)

	local var0 = getProxy(BayProxy)
	local var1 = getProxy(BayProxy):getRawData()

	for iter0, iter1 in ipairs(arg1) do
		local var2 = var1[iter1]:getShipType()
		local var3 = TeamType.GetTeamFromShipType(var2)
		local var4 = 0
		local var5 = arg3[var3]

		for iter2, iter3 in ipairs(var5) do
			if ShipType.ContainInLimitBundle(iter3, var2) then
				var4 = iter3

				break
			end
		end

		for iter4, iter5 in ipairs(var5) do
			if iter5 == var4 then
				table.remove(var5, iter4)

				break
			end
		end
	end

	local function var6(arg0, arg1)
		local var0 = underscore.filter(TeamType.GetShipTypeListFromTeam(arg1), function(arg0)
			return ShipType.ContainInLimitBundle(arg0, arg0)
		end)
		local var1 = var0:GetRecommendShip(var0, arg2, arg4)

		if var1 then
			local var2 = var1.id

			arg2[#arg2 + 1] = var2
			arg1[#arg1 + 1] = var2
		end
	end

	for iter6, iter7 in pairs(arg3) do
		for iter8, iter9 in ipairs(iter7) do
			var6(iter9, iter6)
		end
	end

	return arg1
end

function var0.isClear(arg0, arg1)
	local var0 = arg0:GetChapterItemById(arg1)

	if not var0 then
		return false
	end

	return var0:isClear()
end

function var0.getEscortShop(arg0)
	return Clone(arg0.escortShop)
end

function var0.updateEscortShop(arg0, arg1)
	arg0.escortShop = arg1
end

function var0.recordLastMap(arg0, arg1, arg2)
	local var0 = false

	if arg1 == var0.LAST_MAP_FOR_ACTIVITY then
		Map.lastMapForActivity = arg2
		var0 = true
	elseif arg1 == var0.LAST_MAP and arg2 ~= Map.lastMap then
		Map.lastMap = arg2
		var0 = true
	end

	if var0 then
		local var1 = getProxy(PlayerProxy):getRawData()

		PlayerPrefs.SetInt(arg1 .. var1.id, arg2)
		PlayerPrefs.Save()
	end
end

function var0.getLastMap(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = PlayerPrefs.GetInt(arg1 .. var0.id)

	if var1 ~= 0 then
		return var1
	end
end

function var0.IsActivitySPChapterActive(arg0)
	local var0 = arg0:getMapsByActivities()
	local var1 = _.select(var0, function(arg0)
		return arg0:getMapType() == Map.ACT_EXTRA
	end)
	local var2 = _.reduce(var1, {}, function(arg0, arg1)
		local var0 = _.select(arg1:getChapters(true), function(arg0)
			return arg0:getPlayType() == ChapterConst.TypeRange
		end)

		return table.mergeArray(arg0, var0)
	end)

	return _.any(var2, function(arg0)
		return arg0:isUnlock() and arg0:isPlayerLVUnlock() and arg0:enoughTimes2Start()
	end)
end

function var0.getSubAidFlag(arg0, arg1)
	local var0 = ys.Battle.BattleConst.SubAidFlag
	local var1 = arg0.fleet
	local var2 = false
	local var3 = _.detect(arg0.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Submarine and arg0:isValid()
	end)

	if var3 then
		if var3:inHuntingRange(var1.line.row, var1.line.column) then
			var2 = true
		else
			local var4 = var3:getStrategies()
			local var5 = _.detect(var4, function(arg0)
				return arg0.id == ChapterConst.StrategyCallSubOutofRange
			end)

			if var5 and var5.count > 0 then
				var2 = true
			end
		end
	end

	if var2 then
		local var6 = getProxy(PlayerProxy):getRawData()
		local var7, var8 = arg0:getFleetCost(var1, arg1)
		local var9, var10 = arg0:getFleetAmmo(var3)
		local var11 = 0

		for iter0, iter1 in ipairs({
			arg0:getFleetCost(var3, arg1)
		}) do
			var11 = var11 + iter1.oil
		end

		if var10 <= 0 then
			return var0.AMMO_EMPTY
		elseif var11 + var8.oil >= var6.oil then
			return var0.OIL_EMPTY
		else
			return true, var3
		end
	else
		return var0.AID_EMPTY
	end
end

function var0.GetChapterAuraBuffs(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.fleets) do
		if iter1:getFleetType() ~= FleetType.Support then
			local var1 = iter1:getMapAura()

			for iter2, iter3 in ipairs(var1) do
				table.insert(var0, iter3)
			end
		end
	end

	return var0
end

function var0.GetChapterAidBuffs(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.fleets) do
		if iter1 ~= arg0.fleet and iter1:getFleetType() ~= FleetType.Support then
			local var1 = iter1:getMapAid()

			for iter2, iter3 in pairs(var1) do
				var0[iter2] = iter3
			end
		end
	end

	return var0
end

function var0.RecordComboHistory(arg0, arg1, arg2)
	if arg2 ~= nil then
		arg0:SetExtendChapterData(arg1, "comboHistoryBuffer", arg2)
	else
		arg0:RemoveExtendChapterData(arg1, "comboHistoryBuffer")
	end
end

function var0.GetComboHistory(arg0, arg1)
	return arg0:GetExtendChapterData(arg1, "comboHistoryBuffer")
end

function var0.RecordJustClearChapters(arg0, arg1, arg2)
	if arg2 ~= nil then
		arg0:SetExtendChapterData(arg1, "justClearChapters", arg2)
	else
		arg0:RemoveExtendChapterData(arg1, "justClearChapters")
	end
end

function var0.GetJustClearChapters(arg0, arg1)
	return arg0:GetExtendChapterData(arg1, "justClearChapters")
end

function var0.RecordLastDefeatedEnemy(arg0, arg1, arg2)
	if arg2 ~= nil then
		arg0:SetExtendChapterData(arg1, "defeatedEnemiesBuffer", arg2)
	else
		arg0:RemoveExtendChapterData(arg1, "defeatedEnemiesBuffer")
	end
end

function var0.GetLastDefeatedEnemy(arg0, arg1)
	return arg0:GetExtendChapterData(arg1, "defeatedEnemiesBuffer")
end

function var0.ifShowRemasterTip(arg0)
	return arg0.remasterTip
end

function var0.setRemasterTip(arg0, arg1)
	arg0.remasterTip = arg1
end

function var0.updateRemasterTicketsNum(arg0, arg1)
	arg0.remasterTickets = arg1
end

function var0.resetDailyCount(arg0)
	arg0.remasterDailyCount = 0
end

function var0.updateDailyCount(arg0)
	arg0.remasterDailyCount = arg0.remasterDailyCount + pg.gameset.reactivity_ticket_daily.key_value
end

function var0.GetSkipPrecombat(arg0)
	if arg0.skipPrecombat == nil then
		arg0.skipPrecombat = PlayerPrefs.GetInt("chapter_skip_precombat", 0)
	end

	return arg0.skipPrecombat > 0
end

function var0.UpdateSkipPrecombat(arg0, arg1)
	arg1 = tobool(arg1) and 1 or 0

	if arg1 ~= arg0:GetSkipPrecombat() then
		PlayerPrefs.SetInt("chapter_skip_precombat", arg1)

		arg0.skipPrecombat = arg1

		arg0:sendNotification(var0.CHAPTER_SKIP_PRECOMBAT_UPDATED, arg1)
	end
end

function var0.GetChapterAutoFlag(arg0, arg1)
	return arg0:GetExtendChapterData(arg1, "AutoFightFlag")
end

function var0.SetChapterAutoFlag(arg0, arg1, arg2, arg3)
	arg2 = tobool(arg2)

	if arg2 == (arg0:GetChapterAutoFlag(arg1) == 1) then
		return
	end

	arg0:SetExtendChapterData(arg1, "AutoFightFlag", arg2 and 1 or 0)

	if arg2 then
		arg0:UpdateSkipPrecombat(true)

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
		arg0:StopContinuousOperation(SYSTEM_SCENARIO, arg3)
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end
	end

	arg0.facade:sendNotification(var0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED, arg2 and 1 or 0)
	arg0.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, not arg2)
end

function var0.StopAutoFight(arg0, arg1)
	local var0 = arg0:getActiveChapter(true)

	if not var0 then
		return
	end

	arg0:SetChapterAutoFlag(var0.id, false, arg1)
end

function var0.FinishAutoFight(arg0, arg1)
	if arg0:GetChapterAutoFlag(arg1) == 1 then
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end

		arg0.facade:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
	end

	local var0 = arg0:GetExtendChapter(arg1)

	arg0:RemoveExtendChapter(arg1)

	return var0
end

function var0.buildRemasterInfo(arg0)
	arg0.remasterInfo = {}

	for iter0, iter1 in ipairs(pg.re_map_template.all) do
		for iter2, iter3 in ipairs(pg.re_map_template[iter1].drop_gain) do
			if #iter3 > 0 then
				local var0, var1, var2, var3 = unpack(iter3)

				arg0.remasterInfo[var0] = defaultValue(arg0.remasterInfo[var0], {})
				arg0.remasterInfo[var0][iter2] = {
					count = 0,
					receive = false,
					max = var3
				}
			end
		end
	end
end

function var0.checkRemasterInfomation(arg0)
	if not arg0.checkRemaster then
		arg0.checkRemaster = true

		arg0:sendNotification(GAME.CHAPTER_REMASTER_INFO_REQUEST)
	end
end

function var0.addRemasterPassCount(arg0, arg1)
	if not arg0.remasterInfo[arg1] then
		return
	end

	local var0

	for iter0, iter1 in pairs(arg0.remasterInfo[arg1]) do
		if iter1.count < iter1.max then
			iter1.count = iter1.count + 1
			var0 = true
		end
	end

	if var0 then
		arg0:sendNotification(var0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0.markRemasterPassReceive(arg0, arg1, arg2)
	local var0 = arg0.remasterInfo[arg1][arg2]

	if not arg0.remasterInfo[arg1][arg2] then
		return
	end

	if not var0.receive then
		var0.receive = true

		arg0:sendNotification(var0.CHAPTER_REMASTER_INFO_UPDATED)
	end
end

function var0.anyRemasterAwardCanReceive(arg0)
	for iter0, iter1 in pairs(arg0.remasterInfo) do
		for iter2, iter3 in pairs(iter1) do
			if not iter3.receive and iter3.count >= iter3.max then
				return true
			end
		end
	end

	return false
end

function var0.AddActBossRewards(arg0, arg1)
	arg0.actBossItems = arg0.actBossItems or {}

	table.insertto(arg0.actBossItems, arg1)
end

function var0.PopActBossRewards(arg0)
	local var0 = arg0.actBossItems or {}

	arg0.actBossItems = nil

	return var0
end

function var0.AddBossSingleRewards(arg0, arg1)
	arg0.bossSingleItems = arg0.bossSingleItems or {}

	table.insertto(arg0.bossSingleItems, arg1)
end

function var0.PopBossSingleRewards(arg0)
	local var0 = arg0.bossSingleItems or {}

	arg0.bossSingleItems = nil

	return var0
end

function var0.WriteBackOnExitBattleResult(arg0)
	local var0 = arg0:getActiveChapter()

	if var0 then
		if var0:existOni() then
			var0:clearSubmarineFleet()
			arg0:updateChapter(var0)
		elseif var0:isPlayingWithBombEnemy() then
			var0.fleets = {
				var0.fleet
			}
			var0.findex = 1

			arg0:updateChapter(var0)
		end
	end
end

function var0.GetContinuousData(arg0, arg1)
	return arg0.continuousData[arg1]
end

function var0.InitContinuousTime(arg0, arg1, arg2)
	local var0 = ContinuousOperationRuntimeData.New({
		system = arg1,
		totalBattleTime = arg2,
		battleTime = arg2
	})

	arg0.continuousData[arg1] = var0
end

function var0.StopContinuousOperation(arg0, arg1, arg2)
	local var0 = arg0:GetContinuousData(arg1)

	if not var0 or not var0:IsActive() then
		return
	end

	if arg2 == ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL and arg1 == SYSTEM_SCENARIO then
		pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_stop"))
	end

	var0:Stop(arg2)
end

function var0.PopContinuousData(arg0, arg1)
	local var0 = arg0.continuousData[arg1]

	arg0.continuousData[arg1] = nil

	return var0
end

function var0.SetLastFleetIndex(arg0, arg1, arg2)
	if arg2 and arg0.lastFleetIndex then
		return
	end

	arg0.lastFleetIndex = arg1
end

function var0.GetLastFleetIndex(arg0)
	return arg0.lastFleetIndex
end

return var0
