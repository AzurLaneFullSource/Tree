local var0_0 = class("Commander", import("..BaseVO"))
local var1_0 = pg.commander_level
local var2_0 = pg.commander_attribute_template
local var3_0 = 0
local var4_0 = 1

function var0_0.rarity2Print(arg0_1)
	if not var0_0.prints then
		var0_0.prints = {
			"n",
			"n",
			"r",
			"sr",
			"ssr"
		}
	end

	return var0_0.prints[arg0_1]
end

function var0_0.rarity2Frame(arg0_2)
	if not var0_0.frames then
		var0_0.frames = {
			"2",
			"2",
			"2",
			"3",
			"4"
		}
	end

	return var0_0.frames[arg0_2]
end

function var0_0.Ctor(arg0_3, arg1_3)
	arg0_3.id = arg1_3.id
	arg0_3.configId = arg1_3.template_id or arg0_3.id
	arg0_3.level = arg1_3.level
	arg0_3.exp = arg1_3.exp
	arg0_3.isLock = arg1_3.is_locked
	arg0_3.pt = arg1_3.used_pt

	if arg1_3.name and arg1_3.name ~= "" then
		arg0_3.name = arg1_3.name
	end

	local var0_3 = pg.gameset.commander_rename_coldtime.key_value

	arg0_3.renameTime = (arg1_3.rename_time or 0) + var0_3
	arg0_3.talentOrigins = {}

	for iter0_3, iter1_3 in ipairs(arg1_3.ability_origin) do
		local var1_3 = CommanderTalent.New({
			id = iter1_3
		})

		var1_3:setOrigin(var1_3)
		table.insert(arg0_3.talentOrigins, var1_3)
	end

	arg0_3.talents = {}

	for iter2_3, iter3_3 in ipairs(arg1_3.ability) do
		local var2_3 = CommanderTalent.New({
			id = iter3_3
		})

		arg0_3:addTalent(var2_3)
	end

	arg0_3.notLearnedList = {}
	arg0_3.abilityTime = arg1_3.ability_time
	arg0_3.skills = {}

	for iter4_3, iter5_3 in ipairs(arg1_3.skill) do
		local var3_3 = CommanderSkill.New({
			id = iter5_3.id,
			exp = iter5_3.exp
		})

		table.insert(arg0_3.skills, var3_3)
	end

	arg0_3.abilitys = {}

	arg0_3:updateAbilitys()

	arg0_3.maxLevel = var1_0.all[#var1_0.all]
	arg0_3.groupId = arg0_3:getConfig("group_type")
	arg0_3.cleanTime = arg1_3.home_clean_time or 0
	arg0_3.playTime = arg1_3.home_play_time or 0
	arg0_3.feedTime = arg1_3.home_feed_time or 0
end

function var0_0.IsRegularTalent(arg0_4)
	return arg0_4:getConfig("ability_refresh_type") == var4_0
end

function var0_0.getRenameTime(arg0_5)
	return arg0_5.renameTime
end

function var0_0.setRenameTime(arg0_6, arg1_6)
	arg0_6.renameTime = arg1_6
end

function var0_0.canModifyName(arg0_7)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_7.renameTime
end

function var0_0.getRenameTimeDesc(arg0_8)
	local var0_8 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_8 = arg0_8.renameTime
	local var2_8, var3_8, var4_8, var5_8 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_8 - var0_8)

	if var2_8 < 1 then
		if var3_8 < 1 then
			return var4_8 .. i18n("word_minute")
		else
			return var3_8 .. i18n("word_hour")
		end
	else
		return var2_8 .. i18n("word_date")
	end
end

function var0_0.setLock(arg0_9, arg1_9)
	assert(type(arg1_9) == "number")

	arg0_9.isLock = arg1_9
end

function var0_0.getLock(arg0_10)
	return arg0_10.isLock
end

function var0_0.isLocked(arg0_11)
	return arg0_11.isLock == 1
end

function var0_0.bindConfigTable(arg0_12)
	return pg.commander_data_template
end

function var0_0.getSkill(arg0_13, arg1_13)
	return _.detect(arg0_13.skills, function(arg0_14)
		return arg0_14.id == arg1_13
	end)
end

function var0_0.getSkills(arg0_15)
	return arg0_15.skills
end

local function var5_0(arg0_16, arg1_16)
	table.sort(arg1_16, function(arg0_17, arg1_17)
		return arg0_17.configId < arg1_17.configId
	end)

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		if arg0_16:IsLearnedTalent(iter1_16.id) then
			return iter1_16
		end
	end

	return arg1_16[1]
end

function var0_0.GetDisplayTalents(arg0_18)
	if arg0_18:IsRegularTalent() then
		local var0_18 = {}

		for iter0_18, iter1_18 in ipairs(arg0_18:getConfig("ability_show")) do
			local var1_18 = CommanderTalent.New({
				id = iter1_18
			})

			if not var0_18[var1_18.groupId] then
				var0_18[var1_18.groupId] = {}
			end

			table.insert(var0_18[var1_18.groupId], var1_18)
		end

		local var2_18 = {}
		local var3_18 = {}

		for iter2_18, iter3_18 in pairs(var0_18) do
			local var4_18 = var5_0(arg0_18, iter3_18)

			table.insert(var2_18, var4_18)

			var3_18[var4_18.id] = arg0_18:IsLearnedTalent(var4_18.id)
		end

		table.sort(var2_18, function(arg0_19, arg1_19)
			return (var3_18[arg0_19.id] and 1 or 0) > (var3_18[arg1_19.id] and 1 or 0)
		end)

		do return var2_18 end
		return
	end

	return arg0_18:getTalents()
end

function var0_0.IsLearnedTalent(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.talents) do
		if iter1_20.id == arg1_20 then
			return true
		end
	end

	return false
end

function var0_0.getTalents(arg0_21)
	return arg0_21.talents
end

function var0_0.getTalentOrigins(arg0_22)
	return arg0_22.talentOrigins
end

function var0_0.addTalent(arg0_23, arg1_23)
	local var0_23 = _.detect(arg0_23.talentOrigins, function(arg0_24)
		return arg0_24.groupId == arg1_23.groupId
	end)

	arg1_23:setOrigin(var0_23)
	table.insert(arg0_23.talents, arg1_23)
end

function var0_0.deleteTablent(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.talents) do
		if iter1_25.id == arg1_25 then
			table.remove(arg0_25.talents, iter0_25)

			break
		end
	end
end

function var0_0.getTalent(arg0_26, arg1_26)
	for iter0_26, iter1_26 in pairs(arg0_26.talents) do
		if iter1_26 == arg1_26 then
			return iter1_26
		end
	end
end

function var0_0.resetTalents(arg0_27)
	arg0_27.talents = Clone(arg0_27.talentOrigins)
end

function var0_0.getNotLearnedList(arg0_28)
	return arg0_28.notLearnedList
end

function var0_0.updateNotLearnedList(arg0_29, arg1_29)
	arg0_29.notLearnedList = arg1_29
end

function var0_0.getResetTalentConsume(arg0_30)
	return pg.gameset.commander_skill_reset_cost.description[1][arg0_30.pt]
end

function var0_0.getTotalPoint(arg0_31)
	return math.floor(arg0_31.level / CommanderConst.TALENT_POINT_LEVEL) * CommanderConst.TALENT_POINT
end

function var0_0.getTalentPoint(arg0_32)
	return arg0_32:getTotalPoint() - arg0_32.pt
end

function var0_0.updatePt(arg0_33, arg1_33)
	arg0_33.pt = arg1_33
end

function var0_0.getPt(arg0_34)
	return arg0_34.pt
end

function var0_0.fullTalentCnt(arg0_35)
	return #arg0_35.talents >= CommanderConst.MAX_TELENT_COUNT
end

function var0_0.hasTalent(arg0_36, arg1_36)
	return arg0_36:getSameGroupTalent(arg1_36.groupId) ~= nil
end

function var0_0.getSameGroupTalent(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.talents) do
		if iter1_37.groupId == arg1_37 then
			return iter1_37
		end
	end
end

function var0_0.getTalentsDesc(arg0_38)
	local var0_38 = {}
	local var1_38 = arg0_38:getTalents()

	for iter0_38, iter1_38 in ipairs(var1_38) do
		for iter2_38, iter3_38 in pairs(iter1_38:getDesc()) do
			if var0_38[iter2_38] then
				var0_38[iter2_38].value = var0_38[iter2_38].value + iter3_38.value
			else
				var0_38[iter2_38] = {
					name = iter2_38,
					value = iter3_38.value,
					type = iter3_38.type
				}
			end
		end
	end

	return var0_38
end

function var0_0.getAbilitys(arg0_39)
	return arg0_39.abilitys
end

function var0_0.updateAbilitys(arg0_40)
	local var0_40 = pg.gameset.commander_grow_form_a.key_value
	local var1_40 = pg.gameset.commander_grow_form_b.key_value

	local function var2_40(arg0_41)
		local var0_41 = arg0_40:getConfig(arg0_41 .. "_value")

		return math.floor(var0_41 + var0_41 * (arg0_40.level - 1) * var0_40 / var1_40)
	end

	local var3_40 = {
		"command",
		"tactic",
		"support"
	}
	local var4_40 = {
		101,
		102,
		103
	}

	for iter0_40, iter1_40 in ipairs(var3_40) do
		local var5_40 = var2_40(iter1_40)

		arg0_40.abilitys[iter1_40] = {
			value = var5_40,
			id = var4_40[iter0_40]
		}
	end
end

function var0_0.getAbilitysAddition(arg0_42)
	local var0_42 = pg.gameset.commander_form_a.key_value
	local var1_42 = pg.gameset.commander_form_b.key_value
	local var2_42 = pg.gameset.commander_form_c.key_value
	local var3_42 = pg.gameset.commander_form_n.key_value

	local function var4_42(arg0_43)
		local var0_43 = 0

		for iter0_43, iter1_43 in pairs(arg0_42.abilitys) do
			local var1_43 = var2_0[iter1_43.id]

			if var1_43["rate_" .. arg0_43] then
				local var2_43 = var1_43["rate_" .. arg0_43] / 10000

				if var2_43 > 0 then
					var0_43 = var0_43 + iter1_43.value * var2_43
				end
			end
		end

		return tonumber(string.format("%0.3f", (var0_42 - var1_42 / (var0_43 + var2_42)) * var3_42))
	end

	local var5_42 = {}

	for iter0_42, iter1_42 in ipairs(CommanderConst.PROPERTIES) do
		var5_42[iter1_42] = var4_42(iter1_42)
	end

	return var5_42
end

function var0_0.getTalentsAddition(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44)
	local var0_44 = 0
	local var1_44 = arg0_44:getTalents()

	for iter0_44, iter1_44 in pairs(var1_44) do
		local var2_44, var3_44 = iter1_44:getAttrsAddition()
		local var4_44

		if arg1_44 == CommanderConst.TALENT_ADDITION_NUMBER then
			var4_44 = var2_44
		elseif arg1_44 == CommanderConst.TALENT_ADDITION_RATIO then
			var4_44 = var3_44
		end

		local var5_44 = var4_44[arg2_44]
		local var6_44 = true

		if var5_44 then
			if #var5_44.nation > 0 and not table.contains(var5_44.nation, arg3_44) then
				var6_44 = false
			end

			if #var5_44.shiptype > 0 and not table.contains(var5_44.shiptype, arg4_44) then
				var6_44 = false
			end
		else
			var6_44 = false
		end

		if var6_44 then
			var0_44 = var0_44 + var5_44.value
		end
	end

	return var0_44
end

function var0_0.getAttrRatioAddition(arg0_45, arg1_45, arg2_45, arg3_45)
	if table.contains(CommanderConst.PROPERTIES, arg1_45) then
		return arg0_45:getAbilitysAddition()[arg1_45] + arg0_45:getTalentsAddition(CommanderConst.TALENT_ADDITION_RATIO, arg1_45, arg2_45, arg3_45) / 100
	else
		return 0
	end
end

function var0_0.getAttrValueAddition(arg0_46, arg1_46, arg2_46, arg3_46)
	if table.contains(CommanderConst.PROPERTIES, arg1_46) then
		return (arg0_46:getTalentsAddition(CommanderConst.TALENT_ADDITION_NUMBER, arg1_46, arg2_46, arg3_46))
	else
		return 0
	end
end

function var0_0.addExp(arg0_47, arg1_47)
	if arg0_47:isMaxLevel() then
		return
	end

	arg0_47.exp = arg0_47.exp + arg1_47

	while not arg0_47:isMaxLevel() and arg0_47:canLevelUp() do
		arg0_47.exp = arg0_47.exp - arg0_47:getNextLevelExp()

		arg0_47:updateLevel()
	end
end

function var0_0.ReduceExp(arg0_48, arg1_48)
	arg0_48.exp = arg0_48.exp - arg1_48

	while arg0_48.exp < 0 do
		arg0_48.level = arg0_48.level - 1
		arg0_48.exp = arg0_48:getNextLevelExp() + arg0_48.exp
	end
end

function var0_0.canLevelUp(arg0_49)
	return arg0_49.exp >= arg0_49:getNextLevelExp()
end

function var0_0.isMaxLevel(arg0_50)
	return arg0_50:getMaxLevel() <= arg0_50.level
end

function var0_0.getMaxLevel(arg0_51)
	return arg0_51.maxLevel
end

function var0_0.updateLevel(arg0_52)
	arg0_52.level = arg0_52.level + 1

	arg0_52:updateAbilitys()

	if arg0_52.level % CommanderConst.TALENT_POINT_LEVEL == 0 then
		arg0_52.notLearnedList = {}
	end
end

function var0_0.getConfigExp(arg0_53, arg1_53)
	arg1_53 = math.max(arg1_53, 1)

	local var0_53 = var1_0[arg1_53]

	return var0_53["exp_" .. arg0_53:getRarity()] or var0_53.exp
end

function var0_0.getNextLevelExp(arg0_54)
	return arg0_54:getConfigExp(arg0_54.level)
end

function var0_0.UpdateLevelAndExp(arg0_55, arg1_55, arg2_55)
	arg0_55.exp = arg2_55
	arg0_55.level = arg1_55
end

function var0_0.getName(arg0_56, arg1_56)
	if arg1_56 then
		return arg0_56:getConfig("name")
	else
		return arg0_56.name or arg0_56:getConfig("name")
	end
end

function var0_0.setName(arg0_57, arg1_57)
	arg0_57.name = arg1_57
end

function var0_0.getRarity(arg0_58)
	return arg0_58:getConfig("rarity")
end

function var0_0.isSSR(arg0_59)
	return arg0_59:getRarity() == 5
end

function var0_0.isSR(arg0_60)
	return arg0_60:getRarity() == 4
end

function var0_0.isR(arg0_61)
	return arg0_61:getRarity() == 3
end

function var0_0.getPainting(arg0_62)
	return arg0_62:getConfig("painting")
end

function var0_0.getLevel(arg0_63)
	return arg0_63.level
end

function var0_0.getDestoryedExp(arg0_64, arg1_64)
	local var0_64 = 0

	for iter0_64 = 1, arg0_64.level - 1 do
		var0_64 = var0_64 + arg0_64:getConfigExp(iter0_64)
	end

	local var1_64 = var0_64 + arg0_64.exp

	local function var2_64()
		local var0_65 = 0
		local var1_65 = 0
		local var2_65 = arg0_64:getTalents()

		for iter0_65, iter1_65 in ipairs(var2_65) do
			var0_65 = var0_65 + iter1_65:getDestoryExpValue()
			var1_65 = var1_65 + iter1_65:getDestoryExpRetio()
		end

		return var0_65, var1_65 / 10000
	end

	local var3_64 = pg.gameset.commander_exp_a.key_value / 10000
	local var4_64 = pg.gameset.commander_exp_same_rate.key_value / 10000
	local var5_64 = arg1_64 == arg0_64.groupId and var4_64 or 1
	local var6_64, var7_64 = var2_64()

	return (arg0_64:getConfig("exp") + var1_64 * var3_64) * var5_64 * (1 + var7_64) + var6_64
end

function var0_0.getDestoryedSkillExp(arg0_66, arg1_66)
	if arg1_66 == arg0_66.groupId then
		return pg.gameset.commander_skill_exp.key_value
	end

	return 0
end

function var0_0.updateAbilityTime(arg0_67, arg1_67)
	arg0_67.abilityTime = arg1_67
end

function var0_0.GetNextResetAbilityTime(arg0_68)
	if pg.gameset.commander_ability_reset_time.key_value == 1 then
		return pg.TimeMgr:GetInstance():GetNextTimeByTimeStamp(arg0_68.abilityTime) + 86400
	else
		return arg0_68.abilityTime + pg.gameset.commander_ability_reset_coldtime.key_value
	end
end

function var0_0.isLevelUp(arg0_69, arg1_69)
	return arg0_69.level > 1 and arg0_69.exp - arg1_69 < 0
end

function var0_0.isSameGroup(arg0_70, arg1_70)
	return arg1_70 == arg0_70.groupId
end

function var0_0.getUpgradeConsume(arg0_71)
	local var0_71 = arg0_71:getConfig("exp_cost")

	return var0_71 + var0_71 * (arg0_71.level - 1) * (0.85 + 0.15 * arg0_71.level)
end

function var0_0.canEquipToEliteChapter(arg0_72, arg1_72, arg2_72, arg3_72)
	local var0_72 = getProxy(ChapterProxy):getChapterById(arg0_72):getEliteFleetCommanders() or {}

	return var0_0.canEquipToFleetList(var0_72, arg1_72, arg2_72, arg3_72)
end

function var0_0.canEquipToFleetList(arg0_73, arg1_73, arg2_73, arg3_73)
	local var0_73 = getProxy(CommanderProxy)
	local var1_73 = var0_73:getCommanderById(arg3_73)

	if not var1_73 then
		return false, i18n("commander_not_found")
	end

	for iter0_73, iter1_73 in pairs(arg0_73) do
		if iter0_73 == arg1_73 then
			for iter2_73, iter3_73 in pairs(iter1_73) do
				local var2_73 = var0_73:getCommanderById(iter3_73)

				if var2_73 and var2_73.groupId == var1_73.groupId and iter2_73 ~= arg2_73 then
					return false, i18n("commander_can_not_select_same_group")
				end
			end
		else
			for iter4_73, iter5_73 in pairs(iter1_73) do
				if arg3_73 == iter5_73 then
					return false, i18n("commander_is_in_fleet_already")
				end
			end
		end
	end

	return true
end

function var0_0.ExistCleanFlag(arg0_74)
	local var0_74 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(arg0_74.cleanTime, var0_74)
end

function var0_0.ExitFeedFlag(arg0_75)
	local var0_75 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(arg0_75.feedTime, var0_75)
end

function var0_0.ExitPlayFlag(arg0_76)
	local var0_76 = pg.TimeMgr.GetInstance():GetServerTime()

	return not pg.TimeMgr.GetInstance():IsSameDay(arg0_76.playTime, var0_76)
end

function var0_0.UpdateHomeOpTime(arg0_77, arg1_77, arg2_77)
	if arg1_77 == 1 then
		arg0_77.cleanTime = arg2_77
	elseif arg1_77 == 2 then
		arg0_77.feedTime = arg2_77
	elseif arg1_77 == 3 then
		arg0_77.playTime = arg2_77
	end
end

function var0_0.IsSameTalent(arg0_78)
	local var0_78 = arg0_78:getTalentOrigins()
	local var1_78 = arg0_78:getTalents()

	if #var0_78 == #var1_78 and _.all(var0_78, function(arg0_79)
		return _.any(var1_78, function(arg0_80)
			return arg0_80.id == arg0_79.id
		end)
	end) then
		return true
	end

	return false
end

function var0_0.CanReset(arg0_81)
	return arg0_81:GetNextResetAbilityTime() <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.ShouldTipLock(arg0_82)
	return arg0_82:isSSR() and not arg0_82:isLocked()
end

return var0_0
