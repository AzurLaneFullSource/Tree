local var0 = class("Commander", import("..BaseVO"))
local var1 = pg.commander_level
local var2 = pg.commander_attribute_template
local var3 = 0
local var4 = 1

function var0.rarity2Print(arg0)
	if not var0.prints then
		var0.prints = {
			"n",
			"n",
			"r",
			"sr",
			"ssr"
		}
	end

	return var0.prints[arg0]
end

function var0.rarity2Frame(arg0)
	if not var0.frames then
		var0.frames = {
			"2",
			"2",
			"2",
			"3",
			"4"
		}
	end

	return var0.frames[arg0]
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.template_id or arg0.id
	arg0.level = arg1.level
	arg0.exp = arg1.exp
	arg0.isLock = arg1.is_locked
	arg0.pt = arg1.used_pt

	if arg1.name and arg1.name ~= "" then
		arg0.name = arg1.name
	end

	local var0 = pg.gameset.commander_rename_coldtime.key_value

	arg0.renameTime = (arg1.rename_time or 0) + var0
	arg0.talentOrigins = {}

	for iter0, iter1 in ipairs(arg1.ability_origin) do
		local var1 = CommanderTalent.New({
			id = iter1
		})

		var1:setOrigin(var1)
		table.insert(arg0.talentOrigins, var1)
	end

	arg0.talents = {}

	for iter2, iter3 in ipairs(arg1.ability) do
		local var2 = CommanderTalent.New({
			id = iter3
		})

		arg0:addTalent(var2)
	end

	arg0.notLearnedList = {}
	arg0.abilityTime = arg1.ability_time
	arg0.skills = {}

	for iter4, iter5 in ipairs(arg1.skill) do
		local var3 = CommanderSkill.New({
			id = iter5.id,
			exp = iter5.exp
		})

		table.insert(arg0.skills, var3)
	end

	arg0.abilitys = {}

	arg0:updateAbilitys()

	arg0.maxLevel = var1.all[#var1.all]
	arg0.groupId = arg0:getConfig("group_type")
	arg0.cleanTime = arg1.home_clean_time or 0
	arg0.playTime = arg1.home_play_time or 0
	arg0.feedTime = arg1.home_feed_time or 0
end

function var0.IsRegularTalent(arg0)
	return arg0:getConfig("ability_refresh_type") == var4
end

function var0.getRenameTime(arg0)
	return arg0.renameTime
end

function var0.setRenameTime(arg0, arg1)
	arg0.renameTime = arg1
end

function var0.canModifyName(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.renameTime
end

function var0.getRenameTimeDesc(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = arg0.renameTime
	local var2, var3, var4, var5 = pg.TimeMgr.GetInstance():parseTimeFrom(var1 - var0)

	if var2 < 1 then
		if var3 < 1 then
			return var4 .. i18n("word_minute")
		else
			return var3 .. i18n("word_hour")
		end
	else
		return var2 .. i18n("word_date")
	end
end

function var0.setLock(arg0, arg1)
	assert(type(arg1) == "number")

	arg0.isLock = arg1
end

function var0.getLock(arg0)
	return arg0.isLock
end

function var0.isLocked(arg0)
	return arg0.isLock == 1
end

function var0.bindConfigTable(arg0)
	return pg.commander_data_template
end

function var0.getSkill(arg0, arg1)
	return _.detect(arg0.skills, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getSkills(arg0)
	return arg0.skills
end

local function var5(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		return arg0.configId < arg1.configId
	end)

	for iter0, iter1 in ipairs(arg1) do
		if arg0:IsLearnedTalent(iter1.id) then
			return iter1
		end
	end

	return arg1[1]
end

function var0.GetDisplayTalents(arg0)
	if arg0:IsRegularTalent() then
		local var0 = {}

		for iter0, iter1 in ipairs(arg0:getConfig("ability_show")) do
			local var1 = CommanderTalent.New({
				id = iter1
			})

			if not var0[var1.groupId] then
				var0[var1.groupId] = {}
			end

			table.insert(var0[var1.groupId], var1)
		end

		local var2 = {}
		local var3 = {}

		for iter2, iter3 in pairs(var0) do
			local var4 = var5(arg0, iter3)

			table.insert(var2, var4)

			var3[var4.id] = arg0:IsLearnedTalent(var4.id)
		end

		table.sort(var2, function(arg0, arg1)
			return (var3[arg0.id] and 1 or 0) > (var3[arg1.id] and 1 or 0)
		end)

		do return var2 end
		return
	end

	return arg0:getTalents()
end

function var0.IsLearnedTalent(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.talents) do
		if iter1.id == arg1 then
			return true
		end
	end

	return false
end

function var0.getTalents(arg0)
	return arg0.talents
end

function var0.getTalentOrigins(arg0)
	return arg0.talentOrigins
end

function var0.addTalent(arg0, arg1)
	local var0 = _.detect(arg0.talentOrigins, function(arg0)
		return arg0.groupId == arg1.groupId
	end)

	arg1:setOrigin(var0)
	table.insert(arg0.talents, arg1)
end

function var0.deleteTablent(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.talents) do
		if iter1.id == arg1 then
			table.remove(arg0.talents, iter0)

			break
		end
	end
end

function var0.getTalent(arg0, arg1)
	for iter0, iter1 in pairs(arg0.talents) do
		if iter1 == arg1 then
			return iter1
		end
	end
end

function var0.resetTalents(arg0)
	arg0.talents = Clone(arg0.talentOrigins)
end

function var0.getNotLearnedList(arg0)
	return arg0.notLearnedList
end

function var0.updateNotLearnedList(arg0, arg1)
	arg0.notLearnedList = arg1
end

function var0.getResetTalentConsume(arg0)
	return pg.gameset.commander_skill_reset_cost.description[1][arg0.pt]
end

function var0.getTotalPoint(arg0)
	return math.floor(arg0.level / CommanderConst.TALENT_POINT_LEVEL) * CommanderConst.TALENT_POINT
end

function var0.getTalentPoint(arg0)
	return arg0:getTotalPoint() - arg0.pt
end

function var0.updatePt(arg0, arg1)
	arg0.pt = arg1
end

function var0.getPt(arg0)
	return arg0.pt
end

function var0.fullTalentCnt(arg0)
	return #arg0.talents >= CommanderConst.MAX_TELENT_COUNT
end

function var0.hasTalent(arg0, arg1)
	return arg0:getSameGroupTalent(arg1.groupId) ~= nil
end

function var0.getSameGroupTalent(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.talents) do
		if iter1.groupId == arg1 then
			return iter1
		end
	end
end

function var0.getTalentsDesc(arg0)
	local var0 = {}
	local var1 = arg0:getTalents()

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in pairs(iter1:getDesc()) do
			if var0[iter2] then
				var0[iter2].value = var0[iter2].value + iter3.value
			else
				var0[iter2] = {
					name = iter2,
					value = iter3.value,
					type = iter3.type
				}
			end
		end
	end

	return var0
end

function var0.getAbilitys(arg0)
	return arg0.abilitys
end

function var0.updateAbilitys(arg0)
	local var0 = pg.gameset.commander_grow_form_a.key_value
	local var1 = pg.gameset.commander_grow_form_b.key_value

	local function var2(arg0)
		local var0 = arg0:getConfig(arg0 .. "_value")

		return math.floor(var0 + var0 * (arg0.level - 1) * var0 / var1)
	end

	local var3 = {
		"command",
		"tactic",
		"support"
	}
	local var4 = {
		101,
		102,
		103
	}

	for iter0, iter1 in ipairs(var3) do
		local var5 = var2(iter1)

		arg0.abilitys[iter1] = {
			value = var5,
			id = var4[iter0]
		}
	end
end

function var0.getAbilitysAddition(arg0)
	local var0 = pg.gameset.commander_form_a.key_value
	local var1 = pg.gameset.commander_form_b.key_value
	local var2 = pg.gameset.commander_form_c.key_value
	local var3 = pg.gameset.commander_form_n.key_value

	local function var4(arg0)
		local var0 = 0

		for iter0, iter1 in pairs(arg0.abilitys) do
			local var1 = var2[iter1.id]

			if var1["rate_" .. arg0] then
				local var2 = var1["rate_" .. arg0] / 10000

				if var2 > 0 then
					var0 = var0 + iter1.value * var2
				end
			end
		end

		return tonumber(string.format("%0.3f", (var0 - var1 / (var0 + var2)) * var3))
	end

	local var5 = {}

	for iter0, iter1 in ipairs(CommanderConst.PROPERTIES) do
		var5[iter1] = var4(iter1)
	end

	return var5
end

function var0.getTalentsAddition(arg0, arg1, arg2, arg3, arg4)
	local var0 = 0
	local var1 = arg0:getTalents()

	for iter0, iter1 in pairs(var1) do
		local var2, var3 = iter1:getAttrsAddition()
		local var4

		if arg1 == CommanderConst.TALENT_ADDITION_NUMBER then
			var4 = var2
		elseif arg1 == CommanderConst.TALENT_ADDITION_RATIO then
			var4 = var3
		end

		local var5 = var4[arg2]
		local var6 = true

		if var5 then
			if #var5.nation > 0 and not table.contains(var5.nation, arg3) then
				var6 = false
			end

			if #var5.shiptype > 0 and not table.contains(var5.shiptype, arg4) then
				var6 = false
			end
		else
			var6 = false
		end

		if var6 then
			var0 = var0 + var5.value
		end
	end

	return var0
end

function var0.getAttrRatioAddition(arg0, arg1, arg2, arg3)
	if table.contains(CommanderConst.PROPERTIES, arg1) then
		return arg0:getAbilitysAddition()[arg1] + arg0:getTalentsAddition(CommanderConst.TALENT_ADDITION_RATIO, arg1, arg2, arg3) / 100
	else
		return 0
	end
end

function var0.getAttrValueAddition(arg0, arg1, arg2, arg3)
	if table.contains(CommanderConst.PROPERTIES, arg1) then
		return (arg0:getTalentsAddition(CommanderConst.TALENT_ADDITION_NUMBER, arg1, arg2, arg3))
	else
		return 0
	end
end

function var0.addExp(arg0, arg1)
	if arg0:isMaxLevel() then
		return
	end

	arg0.exp = arg0.exp + arg1

	while not arg0:isMaxLevel() and arg0:canLevelUp() do
		arg0.exp = arg0.exp - arg0:getNextLevelExp()

		arg0:updateLevel()
	end
end

function var0.ReduceExp(arg0, arg1)
	arg0.exp = arg0.exp - arg1

	while arg0.exp < 0 do
		arg0.level = arg0.level - 1
		arg0.exp = arg0:getNextLevelExp() + arg0.exp
	end
end

function var0.canLevelUp(arg0)
	return arg0.exp >= arg0:getNextLevelExp()
end

function var0.isMaxLevel(arg0)
	return arg0:getMaxLevel() <= arg0.level
end

function var0.getMaxLevel(arg0)
	return arg0.maxLevel
end

function var0.updateLevel(arg0)
	arg0.level = arg0.level + 1

	arg0:updateAbilitys()

	if arg0.level % CommanderConst.TALENT_POINT_LEVEL == 0 then
		arg0.notLearnedList = {}
	end
end

function var0.getConfigExp(arg0, arg1)
	arg1 = math.max(arg1, 1)

	local var0 = var1[arg1]

	return var0["exp_" .. arg0:getRarity()] or var0.exp
end

function var0.getNextLevelExp(arg0)
	return arg0:getConfigExp(arg0.level)
end

function var0.UpdateLevelAndExp(arg0, arg1, arg2)
	arg0.exp = arg2
	arg0.level = arg1
end

function var0.getName(arg0, arg1)
	if arg1 then
		return arg0:getConfig("name")
	else
		return arg0.name or arg0:getConfig("name")
	end
end

function var0.setName(arg0, arg1)
	arg0.name = arg1
end

function var0.getRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.isSSR(arg0)
	return arg0:getRarity() == 5
end

function var0.isSR(arg0)
	return arg0:getRarity() == 4
end

function var0.isR(arg0)
	return arg0:getRarity() == 3
end

function var0.getPainting(arg0)
	return arg0:getConfig("painting")
end

function var0.getLevel(arg0)
	return arg0.level
end

function var0.getDestoryedExp(arg0, arg1)
	local var0 = 0

	for iter0 = 1, arg0.level - 1 do
		var0 = var0 + arg0:getConfigExp(iter0)
	end

	local var1 = var0 + arg0.exp

	local function var2()
		local var0 = 0
		local var1 = 0
		local var2 = arg0:getTalents()

		for iter0, iter1 in ipairs(var2) do
			var0 = var0 + iter1:getDestoryExpValue()
			var1 = var1 + iter1:getDestoryExpRetio()
		end

		return var0, var1 / 10000
	end

	local var3 = pg.gameset.commander_exp_a.key_value / 10000
	local var4 = pg.gameset.commander_exp_same_rate.key_value / 10000
	local var5 = arg1 == arg0.groupId and var4 or 1
	local var6, var7 = var2()

	return (arg0:getConfig("exp") + var1 * var3) * var5 * (1 + var7) + var6
end

function var0.getDestoryedSkillExp(arg0, arg1)
	if arg1 == arg0.groupId then
		return pg.gameset.commander_skill_exp.key_value
	end

	return 0
end

function var0.updateAbilityTime(arg0, arg1)
	arg0.abilityTime = arg1
end

function var0.GetNextResetAbilityTime(arg0)
	if pg.gameset.commander_ability_reset_time.key_value == 1 then
		return pg.TimeMgr:GetInstance():GetNextTimeByTimeStamp(arg0.abilityTime) + 86400
	else
		return arg0.abilityTime + pg.gameset.commander_ability_reset_coldtime.key_value
	end
end

function var0.isLevelUp(arg0, arg1)
	return arg0.level > 1 and arg0.exp - arg1 < 0
end

function var0.isSameGroup(arg0, arg1)
	return arg1 == arg0.groupId
end

function var0.getUpgradeConsume(arg0)
	local var0 = arg0:getConfig("exp_cost")

	return var0 + var0 * (arg0.level - 1) * (0.85 + 0.15 * arg0.level)
end

function var0.canEquipToEliteChapter(arg0, arg1, arg2, arg3)
	local var0 = getProxy(ChapterProxy):getChapterById(arg0):getEliteFleetCommanders() or {}

	return var0.canEquipToFleetList(var0, arg1, arg2, arg3)
end

function var0.canEquipToFleetList(arg0, arg1, arg2, arg3)
	local var0 = getProxy(CommanderProxy)
	local var1 = var0:getCommanderById(arg3)

	if not var1 then
		return false, i18n("commander_not_found")
	end

	for iter0, iter1 in pairs(arg0) do
		if iter0 == arg1 then
			for iter2, iter3 in pairs(iter1) do
				local var2 = var0:getCommanderById(iter3)

				if var2 and var2.groupId == var1.groupId and iter2 ~= arg2 then
					return false, i18n("commander_can_not_select_same_group")
				end
			end
		else
			for iter4, iter5 in pairs(iter1) do
				if arg3 == iter5 then
					return false, i18n("commander_is_in_fleet_already")
				end
			end
		end
	end

	return true
end

function var0.ExistCleanFlag(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(arg0.cleanTime, var0)
end

function var0.ExitFeedFlag(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(arg0.feedTime, var0)
end

function var0.ExitPlayFlag(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(arg0.playTime, var0)
end

function var0.UpdateHomeOpTime(arg0, arg1, arg2)
	if arg1 == 1 then
		arg0.cleanTime = arg2
	elseif arg1 == 2 then
		arg0.feedTime = arg2
	elseif arg1 == 3 then
		arg0.playTime = arg2
	end
end

function var0.IsSameTalent(arg0)
	local var0 = arg0:getTalentOrigins()
	local var1 = arg0:getTalents()

	if #var0 == #var1 and _.all(var0, function(arg0)
		return _.any(var1, function(arg0)
			return arg0.id == arg0.id
		end)
	end) then
		return true
	end

	return false
end

function var0.CanReset(arg0)
	return arg0:GetNextResetAbilityTime() <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.ShouldTipLock(arg0)
	return arg0:isSSR() and not arg0:isLocked()
end

return var0
