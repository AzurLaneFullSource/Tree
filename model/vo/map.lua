local var0_0 = class("Map", import(".BaseVO"))

var0_0.INVALID = 0
var0_0.SCENARIO = 1
var0_0.ELITE = 2
var0_0.EVENT = 3
var0_0.ACTIVITY_EASY = 4
var0_0.ACTIVITY_HARD = 5
var0_0.ACT_EXTRA = 8
var0_0.ESCORT = 9
var0_0.SKIRMISH = 10
var0_0.NORMAL_MAP = {
	var0_0.INVALID,
	var0_0.SCENARIO,
	var0_0.ELITE,
	var0_0.EVENT,
	var0_0.ACTIVITY_EASY,
	var0_0.ACTIVITY_HARD,
	var0_0.ACT_EXTRA
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg0_1.configId
	arg0_1.chapterIds = arg1_1.chapterIds
end

function var0_0.bindConfigTable(arg0_2)
	return pg.expedition_data_by_map
end

function var0_0.isUnlock(arg0_3)
	if getProxy(PlayerProxy):getRawData().level < arg0_3:getConfig("level_limit") then
		return false, i18n("levelScene_chapter_unlock_tip", arg0_3:getConfig("level_limit"))
	elseif arg0_3:isActivity() then
		if arg0_3:isRemaster() then
			if arg0_3:isAnyChapterUnlocked() then
				return true
			else
				return false, i18n("battle_levelScene_lock")
			end
		else
			local var0_3 = getProxy(ActivityProxy):getActivityById(arg0_3:getConfig("on_activity"))

			if not var0_3 or var0_3:isEnd() then
				return false, i18n("common_activity_end")
			else
				local var1_3, var2_3 = arg0_3:isAnyChapterUnlocked(true)

				if var1_3 then
					return true
				elseif var2_3 then
					return false, i18n("battle_levelScene_close")
				elseif ChapterConst.IsAtelierMap(arg0_3) and arg0_3:isHardMap() then
					return false, i18n("battle_levelScene_ryza_lock")
				else
					return false, i18n("battle_levelScene_lock")
				end
			end
		end
	elseif arg0_3:getMapType() == Map.SCENARIO then
		if arg0_3:isAnyChapterUnlocked(false) then
			return true
		else
			return false, i18n("battle_levelScene_lock")
		end
	elseif arg0_3:getMapType() == Map.ELITE then
		if arg0_3:isEliteEnabled() then
			return true
		else
			return false, i18n("battle_levelScene_hard_lock")
		end
	else
		return true
	end
end

function var0_0.setRemaster(arg0_4, arg1_4)
	arg0_4.remasterId = arg1_4
end

function var0_0.isRemaster(arg0_5)
	return arg0_5.remasterId ~= nil
end

function var0_0.getRemaster(arg0_6)
	return arg0_6.remasterId
end

function var0_0.getMapType(arg0_7)
	return arg0_7:getConfig("type")
end

function var0_0.getMapTitleNumber(arg0_8)
	return arg0_8:getConfig("title")
end

function var0_0.getBindMapId(arg0_9)
	return arg0_9:getConfig("bind_map")
end

function var0_0.getBindMap(arg0_10)
	return getProxy(ChapterProxy):getMapById(arg0_10:getBindMapId())
end

function var0_0.getChapters(arg0_11)
	return _.filter(arg0_11:GetChapterItems(), function(arg0_12)
		return isa(arg0_12, Chapter)
	end)
end

function var0_0.GetChapterItems(arg0_13)
	local var0_13 = getProxy(ChapterProxy)

	return _.map(arg0_13:GetChapterList(), function(arg0_14)
		return var0_13:GetChapterItemById(arg0_14)
	end)
end

function var0_0.getEscortConfig(arg0_15)
	if arg0_15:isEscort() then
		return pg.escort_map_template[arg0_15.id]
	end
end

function var0_0.getChapterTimeLimit(arg0_16)
	if not arg0_16:isActivity() or arg0_16:isRemaster() then
		return 0
	end

	local var0_16 = pg.TimeMgr.GetInstance()
	local var1_16 = 0

	for iter0_16, iter1_16 in ipairs(arg0_16:getChapters()) do
		local var2_16 = pg.activity_template[iter1_16:GetBindActID()]

		if var2_16 and var2_16.time and #var2_16.time == 3 then
			local var3_16 = var0_16:parseTimeFromConfig(var2_16.time[2]) - var0_16:GetServerTime()

			if var3_16 > 0 then
				if var1_16 == 0 then
					var1_16 = var3_16
				else
					var1_16 = math.min(var1_16, var3_16)
				end
			end
		end
	end

	return var1_16
end

function var0_0.isClear(arg0_17)
	if arg0_17:getMapType() == var0_0.SCENARIO then
		return arg0_17:isAllChaptersClear()
	elseif arg0_17:isActivity() then
		return arg0_17:isClearForActivity()
	else
		return true
	end
end

function var0_0.isClearForActivity(arg0_18)
	local var0_18 = arg0_18:GetChapterItems()

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if iter0_18 > 1 and iter1_18.id - var0_18[iter0_18 - 1].id > 1 then
			break
		elseif not iter1_18:isClear() then
			return false
		end
	end

	return true
end

function var0_0.isEliteEnabled(arg0_19)
	local var0_19

	if arg0_19:getMapType() == var0_0.ELITE then
		var0_19 = getProxy(ChapterProxy):getMapById(arg0_19:getBindMapId())
	else
		var0_19 = arg0_19
	end

	return var0_19:isAllChaptersClear() and var0_19:isAllChaptersAchieve()
end

function var0_0.isAnyChapterUnlocked(arg0_20, arg1_20)
	local var0_20 = false

	for iter0_20, iter1_20 in ipairs(arg0_20:GetChapterItems()) do
		if iter1_20:isUnlock() then
			if not arg1_20 or iter1_20:inActTime() then
				return true
			else
				var0_20 = true
			end
		end
	end

	return false, var0_20
end

function var0_0.isAnyChapterClear(arg0_21)
	return underscore.any(arg0_21:GetChapterItems(), function(arg0_22)
		return arg0_22:isClear()
	end)
end

function var0_0.isAllChaptersClear(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23:GetChapterItems()) do
		if not iter1_23:isClear() then
			return false
		end
	end

	return true
end

function var0_0.isAllChaptersAchieve(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24:getChapters()) do
		if not iter1_24:isAllAchieve() then
			return false
		end
	end

	return true
end

function var0_0.getLastUnlockChapterName(arg0_25)
	local var0_25

	for iter0_25, iter1_25 in ipairs(arg0_25:getChapters()) do
		if not iter1_25:isUnlock() then
			break
		end

		var0_25 = iter1_25
	end

	return var0_25:getConfig("chapter_name")
end

function var0_0.GetChapterInProgress(arg0_26)
	return underscore.detect(arg0_26:GetChapterItems(), function(arg0_27)
		return arg0_27:isUnlock() and not arg0_27:isClear()
	end)
end

function var0_0.GetChapterList(arg0_28)
	return arg0_28.chapterIds
end

function var0_0.GetRearChaptersOfRemaster(arg0_29)
	if not arg0_29 or arg0_29 == 0 then
		return
	end

	local var0_29 = getProxy(ChapterProxy)
	local var1_29 = _.reduce(pg.re_map_template[arg0_29].config_data, {}, function(arg0_30, arg1_30)
		local var0_30 = var0_29:getChapterById(arg1_30, true):getConfig("map")
		local var1_30 = var0_29:getMapById(var0_30):getConfig("type")

		arg0_30[var1_30] = arg0_30[var1_30] or {}

		table.insert(arg0_30[var1_30], arg1_30)

		return arg0_30
	end)
	local var2_29 = {}

	table.Foreach(var1_29, function(arg0_31, arg1_31)
		local var0_31 = _.reduce(arg1_31, {}, function(arg0_32, arg1_32)
			arg0_32[var0_29:getChapterById(arg1_32, true):getConfig("pre_chapter")] = arg1_32

			return arg0_32
		end)
		local var1_31 = _.filter(arg1_31, function(arg0_33)
			return not var0_31[arg0_33]
		end)

		table.insert(var2_29, _.max(var1_31))
	end)

	return var2_29
end

function var0_0.isActivity(arg0_34)
	local var0_34 = arg0_34:getMapType()

	if var0_34 == Map.EVENT then
		return true, false
	elseif var0_34 == Map.ACTIVITY_EASY or var0_34 == Map.ACTIVITY_HARD or var0_34 == Map.ACT_EXTRA then
		return true, true
	else
		return false
	end
end

function var0_0.isHardMap(arg0_35)
	local var0_35 = arg0_35:getMapType()

	return var0_35 == Map.ELITE or var0_35 == Map.ACTIVITY_HARD
end

function var0_0.isActExtra(arg0_36)
	return arg0_36:getMapType() == Map.ACT_EXTRA
end

function var0_0.isEscort(arg0_37)
	return arg0_37:getMapType() == Map.ESCORT
end

function var0_0.isSkirmish(arg0_38)
	return arg0_38:getMapType() == Map.SKIRMISH
end

function var0_0.isNormalMap(arg0_39)
	return table.contains(Map.NORMAL_MAP, arg0_39:getMapType())
end

function var0_0.NeedRecordMap(arg0_40)
	local var0_40 = arg0_40:getMapType()

	return var0_40 == var0_0.INVALID or var0_40 == var0_0.SCENARIO or var0_40 == var0_0.ELITE
end

return var0_0
