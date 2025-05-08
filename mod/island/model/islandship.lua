local var0_0 = class("IslandShip", import("model.vo.BaseVO"))

var0_0.GIFT_OP_SHIP = 1
var0_0.GIFT_OP_MARRIED = 2
var0_0.STATE_NORMAL = 1
var0_0.STATE_WORKING = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or 0
	arg0_1.configId = arg0_1.id
	arg0_1.exp = arg1_1.exp or 0
	arg0_1.level = arg1_1.level or 1
	arg0_1.energy = arg1_1.energy or 0
	arg0_1.giftOp = arg1_1.vow_gift or 0
	arg0_1.attrs = {}

	arg0_1:InitAttrs()

	arg0_1.skills = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.skill_list or {}) do
		table.insert(arg0_1.skills, iter1_1)
	end

	if #arg0_1.skills == 0 then
		local var0_1 = arg0_1:getConfig("skill")
		local var1_1 = pg.island_ship_skill.get_id_list_by_group[var0_1]

		table.insert(arg0_1.skills, var1_1[1])
	end

	arg0_1.status = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.buff_list or {}) do
		local var2_1 = IslandShipStatus.New(iter3_1)

		table.insert(arg0_1.status, var2_1)
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_ship
end

function var0_0.AnyExtraAwardCanGet(arg0_3)
	return arg0_3:CanGetOwnShipAward() or arg0_3:CanGetMarriedShipAward()
end

function var0_0.CanGetOwnShipAward(arg0_4)
	return not (bit.band(arg0_4.giftOp, var0_0.GIFT_OP_SHIP) > 0) and arg0_4:OwnShipInGame()
end

function var0_0.CanGetMarriedShipAward(arg0_5)
	return not (bit.band(arg0_5.giftOp, var0_0.GIFT_OP_MARRIED) > 0) and arg0_5:IsMarriedInGame()
end

function var0_0.IsMarriedInGame(arg0_6)
	local var0_6 = arg0_6:OwnShipInGame()

	return var0_6 and var0_6:IsMarried()
end

function var0_0.OwnShipInGame(arg0_7)
	local var0_7 = arg0_7:GetShipGroup()

	return (getProxy(CollectionProxy):getShipGroup(var0_7))
end

function var0_0.UpdateExtraAwardValue(arg0_8, arg1_8)
	arg0_8.giftOp = bit.bor(arg0_8.giftOp, arg1_8)
end

function var0_0.GetAllExtraAwardOP(arg0_9)
	return {
		var0_0.GIFT_OP_SHIP,
		var0_0.GIFT_OP_MARRIED
	}
end

function var0_0.GetExtraAwardList(arg0_10, arg1_10)
	local var0_10 = table.indexof(arg0_10:GetAllExtraAwardOP(), arg1_10)
	local var1_10 = arg0_10:getConfig("vow_gift")
	local var2_10 = {}
	local var3_10 = var1_10[var0_10] or {}

	table.insert(var2_10, var3_10[1] or 0)

	if var3_10[2] then
		table.insert(var2_10, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = var3_10[2][1],
			count = var3_10[2][2]
		})
	end

	return var2_10
end

function var0_0.GetEnergy(arg0_11)
	return arg0_11.energy
end

function var0_0.AddEnergy(arg0_12, arg1_12)
	arg0_12.energy = arg0_12.energy + arg1_12
end

function var0_0.UpdateEnergy(arg0_13, arg1_13)
	arg0_13.energy = arg1_13
end

function var0_0.UpdateEnergyBeginRecoverTime(arg0_14, arg1_14)
	arg0_14.recorverTime = arg1_14
end

function var0_0.GetMaxEnergy(arg0_15)
	return arg0_15:getConfig("stamina_base") + arg0_15:getConfig("stamina_upgrade") * (arg0_15.level - 1)
end

function var0_0.ExistPotency(arg0_16)
	return false
end

function var0_0.AnySkillCanUpgrade(arg0_17)
	return false
end

function var0_0.HasStatus(arg0_18)
	return false
end

function var0_0.GetCreateTime(arg0_19)
	return 0
end

function var0_0.GetPower(arg0_20)
	return 0
end

function var0_0.GetName(arg0_21)
	return arg0_21:getConfig("name")
end

function var0_0.GetEnName(arg0_22)
	local var0_22 = arg0_22:GetShipGroup()

	return ShipGroup.getDefaultShipConfig(var0_22).english_name
end

function var0_0.GetRarity(arg0_23)
	return arg0_23:getConfig("rarity")
end

function var0_0.StaticGetRarity(arg0_24)
	return pg.island_ship[arg0_24].rarity
end

function var0_0.GetPrefab(arg0_25)
	return var0_0.StaticGetPrefab(arg0_25.configId)
end

function var0_0.GetShipGroup(arg0_26)
	return var0_0.StaticGetShipGroup(arg0_26.configId)
end

function var0_0.StaticGetShipGroup(arg0_27)
	return pg.ship_skin_template[arg0_27].ship_group
end

function var0_0.StaticGetPrefab(arg0_28)
	local var0_28 = pg.ship_skin_template[arg0_28]

	assert(var0_28, arg0_28)

	return var0_28.prefab
end

function var0_0.GetLevel(arg0_29)
	return arg0_29.level or 1
end

function var0_0.GetExp(arg0_30)
	return arg0_30.exp or 0
end

function var0_0.AddExp(arg0_31, arg1_31)
	if arg0_31:IsMaxLevel() then
		return
	end

	arg0_31.exp = arg0_31.exp + arg1_31

	if arg0_31:CanUpgrade() then
		arg0_31.exp = arg0_31.exp - arg0_31:GetTargetExp()
		arg0_31.level = arg0_31.level + 1

		arg0_31:InitAttrs()
	end

	if arg0_31:IsMaxLevel() then
		arg0_31.exp = 0
	end
end

function var0_0.CanUpgrade(arg0_32)
	return not arg0_32:IsMaxLevel() and arg0_32.exp >= arg0_32:GetTargetExp()
end

function var0_0.GetTargetExp(arg0_33)
	if arg0_33:IsMaxLevel() then
		return 0
	end

	return pg.island_ship_level[arg0_33.level].exp
end

function var0_0.IsMaxLevel(arg0_34)
	return arg0_34.level >= arg0_34:getConfig("level_limit")
end

function var0_0.InitAttrs(arg0_35)
	local var0_35 = arg0_35.level
	local var1_35 = arg0_35:getConfig("attribute_base")
	local var2_35 = arg0_35:getConfig("attribute_upgrade")

	for iter0_35, iter1_35 in ipairs(var1_35) do
		local var3_35 = IslandShipAttr.ATTRS[iter0_35]
		local var4_35 = arg0_35:GetAttrGradeValue(var3_35)

		arg0_35.attrs[var3_35] = var1_35[iter0_35] + var4_35 * (var0_35 - 1)
	end
end

function var0_0.GetAttrs(arg0_36)
	return arg0_36.attrs
end

function var0_0.GetAttr(arg0_37, arg1_37)
	return arg0_37.attrs[arg1_37] or 0
end

function var0_0.GetAttrGrade(arg0_38, arg1_38)
	local var0_38 = table.indexof(IslandShipAttr.ATTRS, arg1_38)

	return arg0_38:getConfig("attribute_upgrade")[var0_38]
end

function var0_0.GetAttrGradeStr(arg0_39, arg1_39)
	return ({
		"S",
		"A",
		"B",
		"C",
		"D"
	})[arg0_39:GetAttrGrade(arg1_39)]
end

function var0_0.GetAttrGradeValue(arg0_40, arg1_40)
	local var0_40 = arg0_40:GetAttrGrade(arg1_40)

	return pg.island_set.ship_attribute_value.key_value_varchar[var0_40]
end

function var0_0.StaticGetUnlockItemId(arg0_41)
	local var0_41 = IslandItem.StaticGetMapUsageList(IslandItemUsage.usage_island_invitation)

	for iter0_41, iter1_41 in ipairs(var0_41) do
		local var1_41 = IslandItem.StaticGetUsageArg(iter1_41)

		assert(type(var1_41) == "string")

		if tonumber(var1_41) == arg0_41 then
			return iter1_41
		end
	end

	return nil
end

function var0_0.StaticCanUnlock(arg0_42)
	local var0_42 = var0_0.StaticGetUnlockItemId(arg0_42)

	return var0_42 and getProxy(IslandProxy):GetIsland():GetInventoryAgency():OwnItem(var0_42)
end

function var0_0.UpgradeMainSkill(arg0_43)
	local var0_43 = arg0_43:GetNextLevelMainSkillId()

	if not var0_43 then
		return
	end

	arg0_43.skills[1] = var0_43
end

function var0_0.GetMainSkill(arg0_44)
	return arg0_44.skills[1]
end

function var0_0.CanUpgradeMainSkill(arg0_45)
	local function var0_45(arg0_46)
		for iter0_46, iter1_46 in ipairs(arg0_46) do
			local var0_46 = Drop.New({
				type = iter1_46[1],
				id = iter1_46[2],
				count = iter1_46[3]
			})

			if var0_46:getOwnedCount() < var0_46.count then
				return false
			end
		end

		return true
	end

	local function var1_45(arg0_47)
		if not arg0_47 then
			return true
		end

		local var0_47 = pg.island_ship_skill[arg0_47]

		return arg0_45.level >= var0_47.upgrade_unlock
	end

	local var2_45 = arg0_45:GetMainSkill()
	local var3_45 = pg.island_ship_skill[var2_45]

	return not arg0_45:IsMaxMainSkillLevel() and var0_45(var3_45.upgrade_cost) and var1_45(arg0_45:GetNextLevelMainSkillId())
end

function var0_0.GetUpgradeSkillConsume(arg0_48)
	local var0_48 = arg0_48:GetMainSkill()
	local var1_48 = pg.island_ship_skill[var0_48]
	local var2_48 = {}

	for iter0_48, iter1_48 in ipairs(var1_48.upgrade_cost) do
		table.insert(var2_48, iter1_48)
	end

	return var2_48
end

function var0_0.IsMaxMainSkillLevel(arg0_49)
	local var0_49 = arg0_49:GetMainSkill()
	local var1_49 = pg.island_ship_skill[var0_49]
	local var2_49 = pg.island_ship_skill.get_id_list_by_group[var1_49.group]
	local var3_49 = var2_49[#var2_49]

	return var1_49.level >= pg.island_ship_skill[var3_49].level
end

function var0_0.GetMainSkillUpgradeEffectDesc(arg0_50)
	local var0_50 = {}
	local var1_50 = arg0_50:GetMainSkill()
	local var2_50 = pg.island_ship_skill[var1_50].group
	local var3_50 = pg.island_ship_skill.get_id_list_by_group[var2_50]

	for iter0_50, iter1_50 in pairs(var3_50) do
		local var4_50 = pg.island_ship_skill[iter1_50]
		local var5_50 = var4_50.upgrade_desc

		if var5_50 and var5_50 ~= "" then
			table.insert(var0_50, {
				level = var4_50.level,
				desc = var5_50
			})
		end
	end

	return var0_50
end

function var0_0.GetNextLevelMainSkillId(arg0_51)
	if arg0_51:IsMaxMainSkillLevel() then
		return nil
	end

	local var0_51 = arg0_51:GetMainSkill()
	local var1_51 = pg.island_ship_skill[var0_51]
	local var2_51 = pg.island_ship_skill.get_id_list_by_group[var1_51.group]

	return var2_51[table.indexof(var2_51, var0_51) + 1]
end

function var0_0.IsMainSkillEffective(arg0_52, arg1_52)
	local var0_52 = pg.island_ship_skill[arg0_52:GetMainSkill()]

	return underscore.any(var0_52.trigger_type, function(arg0_53)
		if arg0_53[2] == 2 then
			return true
		end

		if arg0_53[1] == 1 and arg0_53[2] == arg1_52 then
			return true
		end

		return false
	end)
end

function var0_0.GetState(arg0_54)
	return var0_0.STATE_NORMAL
end

function var0_0.GetValidStatus(arg0_55)
	local var0_55 = {}

	for iter0_55, iter1_55 in ipairs(arg0_55.status) do
		if not iter1_55:IsExpiration() then
			table.insert(var0_55, iter1_55)
		end
	end

	return var0_55
end

function var0_0.GetFavoriteGift(arg0_56)
	return arg0_56:getConfig("favorite_gift")
end

function var0_0.StaticGetGiftStatue()
	return pg.island_set.favorite_gifts_state.key_value_int
end

function var0_0.ExistStatus(arg0_58, arg1_58)
	return _.detect(arg0_58.status, function(arg0_59)
		return arg0_59.id == arg1_58
	end) ~= nil
end

function var0_0.AddStatus(arg0_60, arg1_60, arg2_60)
	local var0_60 = _.detect(arg0_60.status, function(arg0_61)
		return arg0_61.id == arg1_60
	end)

	if var0_60 then
		var0_60:AddTime(arg2_60)
	else
		local var1_60 = pg.TimeMgr.GetInstance():GetServerTime()
		local var2_60 = IslandShipStatus.New({
			id = arg1_60,
			end_time = var1_60 + arg2_60
		})

		table.insert(arg0_60.status, var2_60)
	end
end

return var0_0
