local var0_0 = class("IslandShip", import("model.vo.BaseVO"))

var0_0.STATE_NORMAL = 0
var0_0.STATE_DELEGATION = 1
var0_0.STATE_TECHNOLOGY = 2
var0_0.STATE_RESTAURANT = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or 0
	arg0_1.configId = arg0_1.id
	arg0_1.exp = arg1_1.exp or 0
	arg0_1.level = arg1_1.lv or 1
	arg0_1.breakLevel = arg1_1.break_lv or 0
	arg0_1.energy = arg1_1.power or 0
	arg0_1.recorverTime = arg1_1.recover_time or 0
	arg0_1.unlockExtraAttLimit = (arg1_1.up_limit_state or 0) == 1
	arg0_1.extraAttrs = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.extra_attr_list or {}) do
		local var0_1 = IslandShipAttr.GetAtrrName(iter1_1.id)

		arg0_1.extraAttrs[var0_1] = iter1_1.value
	end

	arg0_1.skill = IslandShipSkill.New({
		id = arg0_1:getConfig("skill_id"),
		level = arg1_1.skill_lv or 0
	})
	arg0_1.maxEnerey = arg0_1:getConfig("power")

	arg0_1:InitMaxEnergy()

	arg0_1.maxLevel = 1

	arg0_1:InitMaxLevel()

	arg0_1.attrs = {}

	arg0_1:InitAttrs()

	arg0_1.maxExtraAttrs = {}

	arg0_1:InitMaxExtraAttrs()
	arg0_1:InitSkill()

	arg0_1.status = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.buff_list or {}) do
		local var1_1 = IslandShipStatus.New(iter3_1)

		table.insert(arg0_1.status, var1_1)
	end

	arg0_1:InitEnergyRecoverTime()

	local var2_1 = arg1_1.work_place or {}

	arg0_1.state = var2_1.type or 0
	arg0_1.stateId = var2_1.place or 0
	arg0_1.cur_skin_id = arg1_1.cur_skin_id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_chara_template
end

function var0_0.GetCantFollowTaskIdList(arg0_3)
	return arg0_3:getConfig("in_task")
end

function var0_0.GetLevel(arg0_4)
	return arg0_4.level or 1
end

function var0_0.GetExp(arg0_5)
	return arg0_5.exp or 0
end

function var0_0.AddExp(arg0_6, arg1_6)
	if arg0_6:IsMaxLevel() then
		return
	end

	arg0_6.exp = arg0_6.exp + arg1_6

	while arg0_6:CanUpgrade() do
		arg0_6.exp = arg0_6.exp - arg0_6:GetTargetExp()
		arg0_6.level = arg0_6.level + 1

		arg0_6:InitAttrs()
	end

	if arg0_6:IsMaxLevel() then
		arg0_6.exp = 0
	end
end

function var0_0.CanUpgrade(arg0_7)
	return not arg0_7:IsMaxLevel() and arg0_7.exp >= arg0_7:GetTargetExp()
end

function var0_0.GetTargetExp(arg0_8)
	if arg0_8:IsMaxLevel() then
		return 0
	end

	return pg.island_chara_level[arg0_8.level].level_up_exp
end

function var0_0.IsMaxLevel(arg0_9)
	return arg0_9.level >= arg0_9.maxLevel
end

function var0_0.InitMaxLevel(arg0_10)
	arg0_10.maxLevel = arg0_10:GetBreakLevel() * arg0_10:GetBreakPhaseValue()
end

function var0_0.GetMaxLevel(arg0_11)
	return arg0_11.maxLevel
end

function var0_0.GetEnergy(arg0_12)
	return arg0_12.energy
end

function var0_0.AddEnergy(arg0_13, arg1_13)
	local var0_13 = arg0_13.energy + arg1_13
	local var1_13 = arg0_13:GetMaxEnergy()

	if var1_13 < var0_13 then
		arg0_13.energy = var1_13
	else
		arg0_13.energy = var0_13
	end
end

function var0_0.UpdateEnergy(arg0_14, arg1_14)
	arg0_14.energy = arg1_14
end

function var0_0.UpdateEnergyBeginRecoverTime(arg0_15, arg1_15)
	arg0_15.recorverTime = arg1_15
end

function var0_0.GetMaxEnergy(arg0_16)
	return arg0_16.maxEnerey
end

function var0_0.InitMaxEnergy(arg0_17, arg1_17)
	local var0_17 = arg0_17.maxEnerey
	local var1_17, var2_17 = arg0_17:GetBreakLevel(), arg0_17:getConfig("upgrade_power")

	for iter0_17 = 1, var1_17 do
		arg0_17.maxEnerey = arg0_17.maxEnerey + (var2_17[iter0_17] or 0)
	end

	if not arg1_17 then
		return
	end

	if arg0_17.maxEnerey - var0_17 > 0 then
		local var3_17 = var0_17 - arg0_17.energy

		arg0_17.energy = arg0_17.maxEnerey - var3_17
	end
end

function var0_0.InitEnergyRecoverTime(arg0_18)
	arg0_18.recoverSpeed = arg0_18:getConfig("power_recover")
end

function var0_0.GetCurrentEnergy(arg0_19)
	if arg0_19:GetState() ~= var0_0.STATE_NORMAL then
		return math.min(arg0_19.maxEnerey, arg0_19.energy)
	end

	local var0_19 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_19 = math.floor(arg0_19.energy + (var0_19 - arg0_19.recorverTime) / arg0_19.recoverSpeed)
	local var2_19 = arg0_19:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var2_19 == 0 then
		return math.min(arg0_19.maxEnerey, var1_19)
	end

	local function var3_19(arg0_20, arg1_20, arg2_20, arg3_20)
		local var0_20 = math.max(arg0_20, arg2_20)
		local var1_20 = math.min(arg1_20, arg3_20)

		if var0_20 < var1_20 then
			return var1_20 - var0_20
		else
			return 0
		end
	end

	local var4_19 = var2_19:GetBuffEffect()[1] * 0.01
	local var5_19 = var3_19(arg0_19.recorverTime, var0_19, var2_19:GetStartTime(), var2_19:GetEndTime())
	local var6_19 = var1_19 + math.floor(var5_19 / arg0_19.recoverSpeed * var4_19)

	return math.min(arg0_19.maxEnerey, var6_19)
end

function var0_0.GetCurrentEnergyDecimal(arg0_21)
	local var0_21 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_21 = arg0_21.energy + (var0_21 - arg0_21.recorverTime) / arg0_21.recoverSpeed
	local var2_21 = arg0_21:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var2_21 == 0 then
		return math.min(arg0_21.maxEnerey, var1_21)
	end

	local function var3_21(arg0_22, arg1_22, arg2_22, arg3_22)
		local var0_22 = math.max(arg0_22, arg2_22)
		local var1_22 = math.min(arg1_22, arg3_22)

		if var0_22 < var1_22 then
			return var1_22 - var0_22
		else
			return 0
		end
	end

	local var4_21 = var2_21:GetBuffEffect()[1] * 0.01
	local var5_21 = var1_21 + var3_21(arg0_21.recorverTime, var0_21, var2_21:GetStartTime(), var2_21:GetEndTime()) / arg0_21.recoverSpeed * var4_21

	return math.min(arg0_21.maxEnerey, var5_21)
end

function var0_0.GetEnergyMaxTime(arg0_23)
	local var0_23 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_23 = arg0_23.maxEnerey - arg0_23:GetCurrentEnergyDecimal()
	local var2_23 = arg0_23:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var2_23 == 0 then
		return var0_23 + var1_23 * arg0_23.recoverSpeed
	end

	if var0_23 <= var2_23:GetEndTime() then
		local var3_23 = var2_23:GetEndTime() - var0_23
		local var4_23 = var2_23:GetBuffEffect()[1] * 0.01
		local var5_23 = arg0_23.recoverSpeed / (1 + var4_23)
		local var6_23 = var5_23 * var3_23

		if var1_23 <= var6_23 then
			return var0_23 + var1_23 / var5_23
		end

		return var0_23 + (var1_23 - var6_23) / arg0_23.recoverSpeed + var1_23 / var5_23
	end

	return var0_23 + var1_23 * arg0_23.recoverSpeed
end

function var0_0.AnySkillCanUpgrade(arg0_24)
	return arg0_24:CanUpgradeSkill()
end

function var0_0.HasStatus(arg0_25)
	return table.getCount(arg0_25:GetVaildStatus()) > 0
end

function var0_0.GetPower(arg0_26)
	local var0_26 = arg0_26:GetLevel() * 1000000
	local var1_26 = 0

	for iter0_26, iter1_26 in pairs(arg0_26:GetAttrs()) do
		var1_26 = var1_26 + iter1_26
	end

	return var0_26 + var1_26
end

function var0_0.GetName(arg0_27)
	return arg0_27:getConfig("name")
end

function var0_0.GetEnName(arg0_28)
	local var0_28 = arg0_28:GetShipGroup()

	return ShipGroup.getDefaultShipConfig(var0_28).english_name
end

function var0_0.StaticGetName(arg0_29)
	return pg.island_chara_template[arg0_29].name
end

function var0_0.GetPrefab(arg0_30)
	return var0_0.StaticGetPrefab(arg0_30.configId)
end

function var0_0.GetModelUnit(arg0_31)
	local var0_31 = arg0_31:getConfig("unit_id")

	if arg0_31.cur_skin_id and arg0_31.cur_skin_id ~= 0 then
		var0_31 = pg.island_skin_template[arg0_31.cur_skin_id].model

		local var1_31 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetCurrentSkinColorByShipId(arg0_31.id, arg0_31.cur_skin_id)

		if var1_31 ~= 0 then
			var0_31 = pg.island_skin_colordiff_template[var1_31].model
		end
	end

	return var0_31
end

function var0_0.GetCurrentSkinId(arg0_32)
	return arg0_32.cur_skin_id or 0
end

function var0_0.GetModel(arg0_33)
	local var0_33 = arg0_33:GetModelUnit()
	local var1_33 = pg.island_unit_character[var0_33]
	local var2_33 = var1_33.personal_ani

	return {
		model = var1_33.model,
		animator = var1_33.animator,
		personal_ani = var2_33
	}
end

function var0_0.GetModelBySkinAndColorId(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34:getConfig("unit_id")

	if arg1_34 and arg1_34 ~= 0 then
		var0_34 = pg.island_skin_template[arg1_34].model

		if arg2_34 ~= 0 then
			var0_34 = pg.island_skin_colordiff_template[arg2_34].model
		end
	end

	return var0_34
end

function var0_0.ChangeSkinId(arg0_35, arg1_35)
	if arg0_35.cur_skin_id ~= arg1_35 then
		arg0_35.cur_skin_id = arg1_35
	end
end

function var0_0.GetCurSkinId(arg0_36)
	return arg0_36.cur_skin_id or 0
end

function var0_0.GetNewShipWord(arg0_37)
	return ""
end

function var0_0.GetShipGroup(arg0_38)
	return arg0_38.configId
end

function var0_0.StaticGetPrefab(arg0_39)
	local var0_39 = pg.island_chara_template[arg0_39].unit_id

	return pg.island_unit_character[var0_39].IslandShipIcon
end

function var0_0.UpdateState(arg0_40, arg1_40, arg2_40)
	arg0_40.state = arg1_40
	arg0_40.stateId = arg2_40
end

function var0_0.GetState(arg0_41)
	if pg.TimeMgr.GetInstance():GetServerTime() > arg0_41.recorverTime then
		return var0_0.STATE_NORMAL
	end

	return arg0_41.state
end

function var0_0.GetStateId(arg0_42)
	return arg0_42.stateId
end

function var0_0.GetStatePlaceName(arg0_43)
	return switch(arg0_43.state, {
		[var0_0.STATE_DELEGATION] = function()
			return pg.island_production_place[arg0_43.stateId].name
		end,
		[var0_0.STATE_TECHNOLOGY] = function()
			return pg.island_production_place[arg0_43.stateId].name
		end,
		[var0_0.STATE_RESTAURANT] = function()
			return pg.island_manage_restaurant[arg0_43.stateId].name
		end
	}, function()
		return ""
	end)
end

function var0_0.GetBreakLevel(arg0_48)
	return arg0_48.breakLevel
end

function var0_0.GetBreakMaxLevel(arg0_49)
	return arg0_49:getConfig("upgrade_level")[2] + 1
end

function var0_0.GetBreakPhaseValue(arg0_50)
	return arg0_50:getConfig("upgrade_level")[1]
end

function var0_0.IsMaxBreakLevel(arg0_51)
	return arg0_51:GetBreakMaxLevel() <= arg0_51:GetBreakLevel()
end

function var0_0.CanBreakOut(arg0_52)
	if arg0_52:IsMaxBreakLevel() then
		return false
	end

	local var0_52 = arg0_52:GetBreakPhaseValue()

	return arg0_52.level % var0_52 == 0
end

function var0_0.UpgradeBreakOut(arg0_53)
	arg0_53.breakLevel = arg0_53.breakLevel + 1

	arg0_53:InitMaxLevel()

	local var0_53 = arg0_53:GetMaxEnergy()
	local var1_53 = var0_53 - arg0_53:GetEnergy()

	arg0_53:InitMaxEnergy(true)

	if var0_53 < arg0_53:GetMaxEnergy() then
		arg0_53.energy = arg0_53.energy + var1_53
	end

	arg0_53:InitSkill()
end

function var0_0.GetBreakoutMatrials(arg0_54)
	local var0_54 = arg0_54:getConfig("upgrade_material")
	local var1_54 = {}
	local var2_54 = var0_54[arg0_54:GetBreakLevel()] or {}

	for iter0_54, iter1_54 in ipairs(var2_54) do
		table.insert(var1_54, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_54[1],
			count = iter1_54[2]
		})
	end

	return var1_54
end

function var0_0.InitAttrs(arg0_55)
	local var0_55 = arg0_55:GetBreakPhaseValue()
	local var1_55 = math.floor(arg0_55.level / var0_55)
	local var2_55 = arg0_55.level % var0_55
	local var3_55 = arg0_55:getConfig("base_att")

	for iter0_55, iter1_55 in ipairs(var3_55) do
		local var4_55 = iter1_55[1]
		local var5_55 = iter1_55[2]
		local var6_55 = IslandShipAttr.GetAtrrName(var4_55)

		arg0_55.attrs[var6_55] = var5_55
	end

	local var7_55 = arg0_55:getConfig("growth_att")

	for iter2_55, iter3_55 in ipairs(var7_55) do
		local var8_55 = iter3_55[1]
		local var9_55 = iter3_55[2]
		local var10_55 = IslandShipAttr.GetAtrrName(var8_55)
		local var11_55 = 0

		for iter4_55 = 1, var1_55 do
			var11_55 = var11_55 + var9_55[iter4_55] * var0_55
		end

		if var1_55 < #var9_55 then
			var11_55 = var11_55 + var9_55[var1_55 + 1] * var2_55
		end

		arg0_55.attrs[var10_55] = arg0_55.attrs[var10_55] + var11_55
	end

	for iter5_55, iter6_55 in pairs(arg0_55.extraAttrs) do
		arg0_55.attrs[iter5_55] = arg0_55.attrs[iter5_55] + iter6_55
	end
end

function var0_0.GetGrowthAtt(arg0_56)
	local var0_56 = {}
	local var1_56 = arg0_56:getConfig("growth_att")

	for iter0_56, iter1_56 in ipairs(var1_56) do
		local var2_56 = iter1_56[1]
		local var3_56 = iter1_56[2]

		var0_56[IslandShipAttr.GetAtrrName(var2_56)] = var3_56[arg0_56:GetBreakLevel()] or 0
	end

	return var0_56
end

function var0_0.GetAttrs(arg0_57)
	return arg0_57.attrs
end

function var0_0.GetAttr(arg0_58, arg1_58)
	return arg0_58.attrs[arg1_58] or 0
end

function var0_0.GetAttrGradeCnt(arg0_59, arg1_59)
	local var0_59 = 0

	for iter0_59, iter1_59 in pairs(arg0_59.attrs) do
		if arg1_59 >= arg0_59:GetAttrGrade(iter0_59) then
			var0_59 = var0_59 + 1
		end
	end

	return var0_59
end

function var0_0.GetAttrGradeByValue(arg0_60, arg1_60)
	local var0_60 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_60, iter1_60 in ipairs(pg.island_chara_att.all) do
		local var1_60 = pg.island_chara_att[iter1_60]
		local var2_60 = var1_60.range[1]
		local var3_60 = var1_60.range[2]

		if var2_60 <= arg1_60 and arg1_60 <= var3_60 then
			var0_60 = iter1_60

			break
		end
	end

	return var0_60
end

function var0_0.GetAttrGrade(arg0_61, arg1_61)
	local var0_61 = arg0_61:GetAttr(arg1_61)

	return arg0_61:GetAttrGradeByValue(var0_61)
end

function var0_0.GetAttrGradeName(arg0_62, arg1_62)
	local var0_62 = arg0_62:GetAttrGrade(arg1_62)

	return pg.island_chara_att[var0_62].name
end

function var0_0.GetAttrGradeEffect(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetAttrGrade(arg1_63)

	return pg.island_chara_att[var0_63].effect
end

function var0_0.SetUnlockExtraAttLimit(arg0_64)
	arg0_64.unlockExtraAttLimit = true

	arg0_64:InitMaxExtraAttrs()
end

function var0_0.IsUnlockExtraAttLimit(arg0_65)
	return arg0_65.unlockExtraAttLimit
end

function var0_0.InitMaxExtraAttrs(arg0_66)
	for iter0_66, iter1_66 in ipairs(arg0_66:getConfig("extra_max")) do
		local var0_66 = iter1_66[1]
		local var1_66 = iter1_66[2][1]
		local var2_66 = iter1_66[2][2]
		local var3_66 = arg0_66.unlockExtraAttLimit and var2_66 or var1_66
		local var4_66 = IslandShipAttr.GetAtrrName(var0_66)

		arg0_66.maxExtraAttrs[var4_66] = var3_66
	end
end

function var0_0.GetExtraAttrLimit(arg0_67, arg1_67)
	return arg0_67.maxExtraAttrs[arg1_67] or 0
end

function var0_0.GetExtraAttrValue(arg0_68, arg1_68)
	return arg0_68.extraAttrs[arg1_68] or 0
end

function var0_0.ExistPotency(arg0_69)
	for iter0_69, iter1_69 in pairs(IslandShipAttr.ATTRS) do
		if arg0_69:GetExtraAttrLimit(iter1_69) > arg0_69:GetExtraAttrValue(iter1_69) then
			return true
		end
	end

	return false
end

function var0_0.AddExtraAttr(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg0_70:GetExtraAttrLimit(arg1_70)
	local var1_70 = arg0_70:GetExtraAttrValue(arg1_70) + arg2_70

	arg0_70.extraAttrs[arg1_70] = math.min(var1_70, var0_70)

	arg0_70:InitAttrs()
end

function var0_0.GetUpgradeExtraAttrConsume(arg0_71, arg1_71)
	local var0_71 = table.indexof(IslandShipAttr.ATTRS, arg1_71)

	if var0_71 <= 0 then
		return {}
	end

	local var1_71 = arg0_71:getConfig("att_item")
	local var2_71 = {}

	for iter0_71, iter1_71 in ipairs(var1_71[var0_71] or {}) do
		table.insert(var2_71, {
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_71
		})
	end

	return var2_71
end

function var0_0.GetExtraAttrLimitUnlockConsume(arg0_72)
	return {
		{
			id = 100000,
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM
		}
	}
end

function var0_0.InitSkill(arg0_73)
	if arg0_73:getConfig("skill_unlock") <= arg0_73:GetBreakLevel() then
		arg0_73.skill:Unlock()
	end
end

function var0_0.GetSkillUnlockLevel(arg0_74)
	return arg0_74:getConfig("skill_unlock")
end

function var0_0.GetSkill(arg0_75)
	return arg0_75.skill
end

function var0_0.CanUpgradeSkill(arg0_76)
	if not arg0_76.skill:IsUnlock() then
		return false
	end

	if arg0_76.skill:IsMaxLevel() then
		return false
	end

	local var0_76 = arg0_76.skill:GetUpgradeMaterial()
	local var1_76 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	return _.all(var0_76, function(arg0_77)
		return var1_76:GetOwnCount(arg0_77.id) >= arg0_77.count
	end)
end

function var0_0.GetVaildStatusByGroup(arg0_78, arg1_78)
	return _.select(arg0_78.status, function(arg0_79)
		return not arg0_79:IsExpiration() and arg0_79:GetGroup() == arg1_78
	end)
end

function var0_0.GetVaildStatus(arg0_80)
	return _.select(arg0_80.status, function(arg0_81)
		return not arg0_81:IsExpiration()
	end)
end

function var0_0.GetVaildStatusByType(arg0_82, arg1_82)
	return _.select(arg0_82.status, function(arg0_83)
		return not arg0_83:IsExpiration() and arg0_83:GetBuffType() == arg1_82
	end)
end

function var0_0.GetDisplayStatus(arg0_84)
	return _.select(arg0_84.status, function(arg0_85)
		return not arg0_85:IsExpiration() and arg0_85:CanDisplay()
	end)
end

function var0_0.GetFavoriteGift(arg0_86)
	return arg0_86:getConfig("gift_id")
end

function var0_0.IsFavoriteGift(arg0_87, arg1_87)
	local var0_87 = arg0_87:GetFavoriteGift()

	return _.any(var0_87, function(arg0_88)
		return arg0_88 == arg1_87
	end)
end

function var0_0.AddStatus(arg0_89, arg1_89)
	local var0_89 = _.detect(arg0_89.status, function(arg0_90)
		return arg0_90.id == arg1_89.id
	end)

	if var0_89 then
		table.removebyvalue(arg0_89.status, var0_89)
	end

	local var1_89 = arg0_89:GetVaildStatus()
	local var2_89 = arg1_89:GetDuelTypeList()
	local var3_89 = _.detect(var1_89, function(arg0_91)
		return table.contains(var2_89, arg0_91:GetGroup())
	end)

	if var3_89 then
		table.removebyvalue(arg0_89.status, var3_89)
	end

	local var4_89 = arg1_89:GetDuelIdList()
	local var5_89 = _.detect(var1_89, function(arg0_92)
		return table.contains(var4_89, arg0_92.id)
	end)

	if var5_89 then
		table.removebyvalue(arg0_89.status, var5_89)
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipAddBuff(arg0_89.id, arg1_89.id))
	table.insert(arg0_89.status, arg1_89)
end

return var0_0
