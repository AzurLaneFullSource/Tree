local var0_0 = class("LoveLetter", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.groupId = arg1_1.group_id
	arg0_1.configId = arg0_1.groupId
	arg0_1.exp = arg1_1.exp or 0
	arg0_1.level = arg1_1.level or 0
	arg0_1.unlockLetterDic = {}
end

function var0_0.bindConfigTable(arg0_2)
	return pg.lover_character_template
end

function var0_0.SetUnlockLetters(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3) do
		arg0_3.unlockLetterDic[iter1_3] = defaultValue(arg0_3.unlockLetterDic[iter1_3], 0) + 1
	end
end

function var0_0.GetLetterUnlock(arg0_4, arg1_4)
	return defaultValue(arg0_4.unlockLetterDic[arg1_4], 0) > 0
end

function var0_0.GetLetterList(arg0_5)
	local var0_5 = getProxy(LoveLetterProxy):GetRecordGiftLetters(arg0_5.groupId)

	for iter0_5, iter1_5 in ipairs(pg.lover_letter_content.get_id_list_by_ship_group[arg0_5.groupId]) do
		if not table.contains(var0_5, iter1_5) then
			table.insert(var0_5, iter1_5)
		end
	end

	return var0_5
end

function var0_0.IsExpMax(arg0_6)
	return arg0_6.exp >= arg0_6:getConfig("exp_upper_limit")
end

function var0_0.IsLevelMax(arg0_7)
	return arg0_7.level >= arg0_7:GetMaxLevel()
end

function var0_0.AddExp(arg0_8, arg1_8)
	if arg0_8:IsExpMax() then
		return 0
	end

	local var0_8 = arg0_8:getConfig("exp_upper_limit")

	arg1_8, arg0_8.exp = arg0_8.exp, math.min(arg0_8.exp + arg1_8, var0_8)

	return arg0_8.exp - arg1_8
end

function var0_0.AddGiftExp(arg0_9, arg1_9)
	arg0_9.exp = arg0_9.exp + arg0_9:getConfig("exp_up") * arg1_9
	arg0_9.level = arg0_9.level + arg1_9
end

function var0_0.GetMaxLevel(arg0_10)
	if not arg0_10.maxLevel then
		arg0_10.maxLevel = calcFloor(arg0_10:getConfig("exp_upper_limit") / arg0_10:getConfig("exp_up"))
	end

	return arg0_10.maxLevel
end

function var0_0.CanLevelUp(arg0_11)
	return arg0_11.exp >= (arg0_11.level + 1) * arg0_11:getConfig("exp_up")
end

function var0_0.MaxLevelUp(arg0_12)
	arg0_12.level = calcFloor(arg0_12.exp / arg0_12:getConfig("exp_up"))
end

function var0_0.CanUnlockLetter(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetLetterList()
	local var1_13 = table.indexof(var0_13, arg1_13)

	assert(var1_13)

	return var1_13 <= arg0_13.level
end

function var0_0.GetDisplayLetterList(arg0_14)
	return underscore.first(arg0_14:GetLetterList(), arg0_14.level)
end

function var0_0.GetDisplayLevel(arg0_15)
	return math.min(arg0_15.level, arg0_15:GetMaxLevel())
end

function var0_0.GetDisplayRank(arg0_16)
	return math.floor((arg0_16:GetDisplayLevel() - 1) / 10) + 1
end

var0_0.Mark = {
	"I",
	"II",
	"III",
	"IV",
	"V",
	"VI",
	"VII",
	"VIII",
	"IX",
	"X"
}

function var0_0.GetDisplayLevelMark(arg0_17)
	return arg0_17:GetDisplayLevel()
end

function var0_0.GetDisplayExp(arg0_18)
	if arg0_18:IsLevelMax() then
		return 0, 0
	else
		local var0_18 = arg0_18:getConfig("exp_up")

		return math.min(arg0_18.exp - arg0_18.level * var0_18, var0_18), var0_18
	end
end

function var0_0.GetPrefabName(arg0_19)
	return "lovelettermedal/default_" .. arg0_19:GetDisplayRank()
end

function var0_0.GetEmptyShipGroup(arg0_20)
	if not arg0_20.shipGroup then
		arg0_20.shipGroup = ShipGroup.New({
			id = arg0_20.configId
		})
	end

	return arg0_20.shipGroup
end

function var0_0.GetPainting(arg0_21)
	return arg0_21:GetEmptyShipGroup():getPainting()
end

function var0_0.GetName(arg0_22)
	return arg0_22:GetEmptyShipGroup():getName()
end

function var0_0.GetNation(arg0_23)
	return arg0_23:GetEmptyShipGroup():getNation()
end

function var0_0.GetDisplayInfo(arg0_24)
	local var0_24 = arg0_24:GetEmptyShipGroup():getPaintingId()
	local var1_24 = pg.ship_skin_template[var0_24]

	return {
		hand = var1_24.lover_hand,
		kiss = var1_24.lover_kiss
	}
end

function var0_0.GetLetterDataFromId(arg0_25)
	local var0_25 = pg.lover_nation[arg0_25:GetNation()]

	return {
		bg = var0_25.bg,
		prefab = var0_25.letter
	}
end

function var0_0.GetTrophyList(arg0_26)
	local var0_26 = {}

	for iter0_26 = 1, arg0_26.level, 10 do
		local var1_26 = 1000000000 + arg0_26.groupId * 100 + iter0_26

		table.insert(var0_26, LoveLetterTrophy.New({
			id = var1_26
		}))
	end

	return var0_26
end

return var0_0
