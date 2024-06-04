local var0 = class("Map", import(".BaseVO"))

var0.INVALID = 0
var0.SCENARIO = 1
var0.ELITE = 2
var0.EVENT = 3
var0.ACTIVITY_EASY = 4
var0.ACTIVITY_HARD = 5
var0.ACT_EXTRA = 8
var0.ESCORT = 9
var0.SKIRMISH = 10
var0.NORMAL_MAP = {
	var0.INVALID,
	var0.SCENARIO,
	var0.ELITE,
	var0.EVENT,
	var0.ACTIVITY_EASY,
	var0.ACTIVITY_HARD,
	var0.ACT_EXTRA
}

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.id = arg0.configId
	arg0.chapterIds = arg1.chapterIds
end

function var0.bindConfigTable(arg0)
	return pg.expedition_data_by_map
end

function var0.isUnlock(arg0)
	if getProxy(PlayerProxy):getRawData().level < arg0:getConfig("level_limit") then
		return false, i18n("levelScene_chapter_unlock_tip", arg0:getConfig("level_limit"))
	elseif arg0:isActivity() then
		if arg0:isRemaster() then
			if arg0:isAnyChapterUnlocked() then
				return true
			else
				return false, i18n("battle_levelScene_lock")
			end
		else
			local var0 = getProxy(ActivityProxy):getActivityById(arg0:getConfig("on_activity"))

			if not var0 or var0:isEnd() then
				return false, i18n("common_activity_end")
			else
				local var1, var2 = arg0:isAnyChapterUnlocked(true)

				if var1 then
					return true
				elseif var2 then
					return false, i18n("battle_levelScene_close")
				elseif ChapterConst.IsAtelierMap(arg0) and arg0:isHardMap() then
					return false, i18n("battle_levelScene_ryza_lock")
				else
					return false, i18n("battle_levelScene_lock")
				end
			end
		end
	elseif arg0:getMapType() == Map.SCENARIO then
		if arg0:isAnyChapterUnlocked(false) then
			return true
		else
			return false, i18n("battle_levelScene_lock")
		end
	elseif arg0:getMapType() == Map.ELITE then
		if arg0:isEliteEnabled() then
			return true
		else
			return false, i18n("battle_levelScene_hard_lock")
		end
	else
		return true
	end
end

function var0.setRemaster(arg0, arg1)
	arg0.remasterId = arg1
end

function var0.isRemaster(arg0)
	return arg0.remasterId ~= nil
end

function var0.getRemaster(arg0)
	return arg0.remasterId
end

function var0.getMapType(arg0)
	return arg0:getConfig("type")
end

function var0.getMapTitleNumber(arg0)
	return arg0:getConfig("title")
end

function var0.getBindMapId(arg0)
	return arg0:getConfig("bind_map")
end

function var0.getBindMap(arg0)
	return getProxy(ChapterProxy):getMapById(arg0:getBindMapId())
end

function var0.getChapters(arg0)
	return _.filter(arg0:GetChapterItems(), function(arg0)
		return isa(arg0, Chapter)
	end)
end

function var0.GetChapterItems(arg0)
	local var0 = getProxy(ChapterProxy)

	return _.map(arg0:GetChapterList(), function(arg0)
		return var0:GetChapterItemById(arg0)
	end)
end

function var0.getEscortConfig(arg0)
	if arg0:isEscort() then
		return pg.escort_map_template[arg0.id]
	end
end

function var0.getChapterTimeLimit(arg0)
	if not arg0:isActivity() or arg0:isRemaster() then
		return 0
	end

	local var0 = pg.TimeMgr.GetInstance()
	local var1 = 0

	for iter0, iter1 in ipairs(arg0:getChapters()) do
		local var2 = pg.activity_template[iter1:GetBindActID()]

		if var2 and var2.time and #var2.time == 3 then
			local var3 = var0:parseTimeFromConfig(var2.time[2]) - var0:GetServerTime()

			if var3 > 0 then
				if var1 == 0 then
					var1 = var3
				else
					var1 = math.min(var1, var3)
				end
			end
		end
	end

	return var1
end

function var0.isClear(arg0)
	if arg0:getMapType() == var0.SCENARIO then
		return arg0:isAllChaptersClear()
	elseif arg0:isActivity() then
		return arg0:isClearForActivity()
	else
		return true
	end
end

function var0.isClearForActivity(arg0)
	local var0 = arg0:GetChapterItems()

	for iter0, iter1 in ipairs(var0) do
		if iter0 > 1 and iter1.id - var0[iter0 - 1].id > 1 then
			break
		elseif not iter1:isClear() then
			return false
		end
	end

	return true
end

function var0.isEliteEnabled(arg0)
	local var0

	if arg0:getMapType() == var0.ELITE then
		var0 = getProxy(ChapterProxy):getMapById(arg0:getBindMapId())
	else
		var0 = arg0
	end

	return var0:isAllChaptersClear() and var0:isAllChaptersAchieve()
end

function var0.isAnyChapterUnlocked(arg0, arg1)
	local var0 = false

	for iter0, iter1 in ipairs(arg0:GetChapterItems()) do
		if iter1:isUnlock() then
			if not arg1 or iter1:inActTime() then
				return true
			else
				var0 = true
			end
		end
	end

	return false, var0
end

function var0.isAnyChapterClear(arg0)
	return underscore.any(arg0:GetChapterItems(), function(arg0)
		return arg0:isClear()
	end)
end

function var0.isAllChaptersClear(arg0)
	for iter0, iter1 in ipairs(arg0:GetChapterItems()) do
		if not iter1:isClear() then
			return false
		end
	end

	return true
end

function var0.isAllChaptersAchieve(arg0)
	for iter0, iter1 in ipairs(arg0:getChapters()) do
		if not iter1:isAllAchieve() then
			return false
		end
	end

	return true
end

function var0.getLastUnlockChapterName(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0:getChapters()) do
		if not iter1:isUnlock() then
			break
		end

		var0 = iter1
	end

	return var0:getConfig("chapter_name")
end

function var0.GetChapterInProgress(arg0)
	return underscore.detect(arg0:GetChapterItems(), function(arg0)
		return arg0:isUnlock() and not arg0:isClear()
	end)
end

function var0.GetChapterList(arg0)
	return arg0.chapterIds
end

function var0.GetRearChaptersOfRemaster(arg0)
	if not arg0 or arg0 == 0 then
		return
	end

	local var0 = getProxy(ChapterProxy)
	local var1 = _.reduce(pg.re_map_template[arg0].config_data, {}, function(arg0, arg1)
		local var0 = var0:getChapterById(arg1, true):getConfig("map")
		local var1 = var0:getMapById(var0):getConfig("type")

		arg0[var1] = arg0[var1] or {}

		table.insert(arg0[var1], arg1)

		return arg0
	end)
	local var2 = {}

	table.Foreach(var1, function(arg0, arg1)
		local var0 = _.reduce(arg1, {}, function(arg0, arg1)
			arg0[var0:getChapterById(arg1, true):getConfig("pre_chapter")] = arg1

			return arg0
		end)
		local var1 = _.filter(arg1, function(arg0)
			return not var0[arg0]
		end)

		table.insert(var2, _.max(var1))
	end)

	return var2
end

function var0.isActivity(arg0)
	local var0 = arg0:getMapType()

	if var0 == Map.EVENT then
		return true, false
	elseif var0 == Map.ACTIVITY_EASY or var0 == Map.ACTIVITY_HARD or var0 == Map.ACT_EXTRA then
		return true, true
	else
		return false
	end
end

function var0.isHardMap(arg0)
	local var0 = arg0:getMapType()

	return var0 == Map.ELITE or var0 == Map.ACTIVITY_HARD
end

function var0.isActExtra(arg0)
	return arg0:getMapType() == Map.ACT_EXTRA
end

function var0.isEscort(arg0)
	return arg0:getMapType() == Map.ESCORT
end

function var0.isSkirmish(arg0)
	return arg0:getMapType() == Map.SKIRMISH
end

function var0.isNormalMap(arg0)
	return table.contains(Map.NORMAL_MAP, arg0:getMapType())
end

function var0.NeedRecordMap(arg0)
	local var0 = arg0:getMapType()

	return var0 == var0.INVALID or var0 == var0.SCENARIO or var0 == var0.ELITE
end

return var0
