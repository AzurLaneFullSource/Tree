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
		level = arg1_1.skill_lv or 0,
		isUseToday = (arg1_1.skill_use_state or 0) == 1
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
	local var3_17 = arg0_17:getConfig("power")
	local var4_17 = 0

	for iter0_17 = 1, var1_17 do
		var4_17 = var4_17 + (var2_17[iter0_17] or 0)
	end

	arg0_17.maxEnerey = var3_17 + var4_17

	if not arg1_17 then
		return
	end

	if arg0_17.maxEnerey - var0_17 > 0 then
		local var5_17 = var0_17 - arg0_17.energy

		arg0_17.energy = arg0_17.maxEnerey - var5_17
	end
end

function var0_0.InitEnergyRecoverTime(arg0_18)
	arg0_18.recoverSpeed = arg0_18:getConfig("power_recover")
end

function var0_0.GetSkillAddRecoverSpeed(arg0_19)
	local var0_19 = 0

	if arg0_19.skill then
		local var1_19 = arg0_19.skill:GetUnlockShipEffectIds()

		for iter0_19, iter1_19 in ipairs(var1_19) do
			local var2_19 = pg.island_buff_template[iter1_19]

			if var2_19.buff_type == IslandBuffType.SHIP_POWER_RECOVER then
				var0_19 = var0_19 + var2_19.type_use[1]
			end
		end
	end

	return var0_19
end

function var0_0.GetCurrentEnergy(arg0_20)
	if arg0_20:GetState() ~= var0_0.STATE_NORMAL then
		return math.min(arg0_20.maxEnerey, arg0_20.energy)
	end

	return math.floor(arg0_20:GetCurrentEnergyDecimal())
end

function var0_0.GetCurrentEnergyDecimal(arg0_21)
	local var0_21 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_21 = arg0_21.energy + (var0_21 - arg0_21.recorverTime) / arg0_21.recoverSpeed
	local var2_21 = arg0_21:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)
	local var3_21 = arg0_21:GetSkillAddRecoverSpeed()
	local var4_21 = var1_21 + (var0_21 - arg0_21.recorverTime) / arg0_21.recoverSpeed * var3_21 * 0.01

	if #var2_21 == 0 then
		return math.min(arg0_21.maxEnerey, var4_21)
	end

	local function var5_21(arg0_22, arg1_22, arg2_22, arg3_22)
		local var0_22 = math.max(arg0_22, arg2_22)
		local var1_22 = math.min(arg1_22, arg3_22)

		if var0_22 < var1_22 then
			return var1_22 - var0_22
		else
			return 0
		end
	end

	local var6_21 = var2_21:GetBuffEffect()[1] * 0.01
	local var7_21 = var4_21 + var5_21(arg0_21.recorverTime, var0_21, var2_21:GetStartTime(), var2_21:GetEndTime()) / arg0_21.recoverSpeed * var6_21

	return math.min(arg0_21.maxEnerey, var7_21)
end

function var0_0.GetEnergyMaxTime(arg0_23)
	local var0_23 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_23 = arg0_23.maxEnerey - arg0_23:GetCurrentEnergyDecimal()
	local var2_23 = arg0_23:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)
	local var3_23 = arg0_23:GetSkillAddRecoverSpeed()
	local var4_23 = arg0_23.recoverSpeed / (1 + var3_23 * 0.01)

	if #var2_23 == 0 then
		return var0_23 + math.floor(var1_23 * var4_23)
	end

	if var0_23 <= var2_23:GetEndTime() then
		local var5_23 = var2_23:GetEndTime() - var0_23
		local var6_23 = var4_23 / (1 + var2_23:GetBuffEffect()[1] * 0.01)
		local var7_23 = var6_23 * var5_23

		if var1_23 <= var7_23 then
			return var0_23 + math.floor(var1_23 / var6_23)
		end

		local var8_23 = var1_23 - var7_23

		return var0_23 + math.floor(var8_23 / var4_23) + math.floor(var1_23 / var6_23)
	end

	return var0_23 + math.floor(var1_23 * var4_23)
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
	local var0_28 = arg0_28:GetModelUnit()

	return pg.island_unit_character[var0_28].english_name
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
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_41.recorverTime then
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

function var0_0.IsDelegable(arg0_48)
	return arg0_48:GetState() == var0_0.STATE_NORMAL and not getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(arg0_48.id)
end

function var0_0.GetBreakLevel(arg0_49)
	return arg0_49.breakLevel
end

function var0_0.GetBreakMaxLevel(arg0_50)
	return arg0_50:getConfig("upgrade_level")[2] + 1
end

function var0_0.GetBreakPhaseValue(arg0_51)
	return arg0_51:getConfig("upgrade_level")[1]
end

function var0_0.IsMaxBreakLevel(arg0_52)
	return arg0_52:GetBreakMaxLevel() <= arg0_52:GetBreakLevel()
end

function var0_0.CanBreakOut(arg0_53)
	if arg0_53:IsMaxBreakLevel() then
		return false
	end

	local var0_53 = arg0_53:GetBreakPhaseValue()

	return arg0_53.level % var0_53 == 0
end

function var0_0.UpgradeBreakOut(arg0_54)
	arg0_54.breakLevel = arg0_54.breakLevel + 1

	arg0_54:InitMaxLevel()

	local var0_54 = arg0_54:GetMaxEnergy()
	local var1_54 = var0_54 - arg0_54:GetEnergy()

	arg0_54:InitMaxEnergy(true)

	local var2_54 = arg0_54:GetMaxEnergy()

	if var0_54 < var2_54 then
		arg0_54.energy = var2_54 - var1_54
	end

	arg0_54:InitSkill()
end

function var0_0.GetBreakoutMatrials(arg0_55)
	local var0_55 = arg0_55:getConfig("upgrade_material")
	local var1_55 = {}
	local var2_55 = var0_55[arg0_55:GetBreakLevel()] or {}

	for iter0_55, iter1_55 in ipairs(var2_55) do
		table.insert(var1_55, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_55[1],
			count = iter1_55[2]
		})
	end

	return var1_55
end

function var0_0.InitAttrs(arg0_56)
	local var0_56 = arg0_56:GetBreakPhaseValue()
	local var1_56 = math.floor(arg0_56.level / var0_56)
	local var2_56 = arg0_56.level % var0_56
	local var3_56 = arg0_56:getConfig("base_att")

	for iter0_56, iter1_56 in ipairs(var3_56) do
		local var4_56 = iter1_56[1]
		local var5_56 = iter1_56[2]
		local var6_56 = IslandShipAttr.GetAtrrName(var4_56)

		arg0_56.attrs[var6_56] = var5_56
	end

	local var7_56 = arg0_56:getConfig("growth_att")

	for iter2_56, iter3_56 in ipairs(var7_56) do
		local var8_56 = iter3_56[1]
		local var9_56 = iter3_56[2]
		local var10_56 = IslandShipAttr.GetAtrrName(var8_56)
		local var11_56 = 0

		for iter4_56 = 1, var1_56 do
			var11_56 = var11_56 + var9_56[iter4_56] * var0_56
		end

		if var1_56 < #var9_56 then
			var11_56 = var11_56 + var9_56[var1_56 + 1] * var2_56
		end

		arg0_56.attrs[var10_56] = arg0_56.attrs[var10_56] + var11_56
	end

	for iter5_56, iter6_56 in pairs(arg0_56.extraAttrs) do
		arg0_56.attrs[iter5_56] = arg0_56.attrs[iter5_56] + iter6_56
	end

	for iter7_56, iter8_56 in pairs(arg0_56.attrs) do
		arg0_56.attrs[iter7_56] = math.floor(iter8_56)
	end
end

function var0_0.GetGrowthAtt(arg0_57)
	local var0_57 = {}
	local var1_57 = arg0_57:getConfig("growth_att")

	for iter0_57, iter1_57 in ipairs(var1_57) do
		local var2_57 = iter1_57[1]
		local var3_57 = iter1_57[2]

		var0_57[IslandShipAttr.GetAtrrName(var2_57)] = var3_57[arg0_57:GetBreakLevel()] or 0
	end

	return var0_57
end

function var0_0.GetAttrs(arg0_58)
	return arg0_58.attrs
end

function var0_0.GetAttr(arg0_59, arg1_59)
	return arg0_59.attrs[arg1_59] or 0
end

function var0_0.GetAttrGradeCnt(arg0_60, arg1_60)
	local var0_60 = 0

	for iter0_60, iter1_60 in pairs(arg0_60.attrs) do
		if arg1_60 >= arg0_60:GetAttrGrade(iter0_60) then
			var0_60 = var0_60 + 1
		end
	end

	return var0_60
end

function var0_0.GetAttrGradeByValue(arg0_61, arg1_61)
	local var0_61 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_61, iter1_61 in ipairs(pg.island_chara_att.all) do
		local var1_61 = pg.island_chara_att[iter1_61]
		local var2_61 = var1_61.range[1]
		local var3_61 = var1_61.range[2]

		if var2_61 <= arg1_61 and arg1_61 <= var3_61 then
			var0_61 = iter1_61

			break
		end
	end

	return var0_61
end

function var0_0.GetAttrGrade(arg0_62, arg1_62)
	local var0_62 = arg0_62:GetAttr(arg1_62)

	return arg0_62:GetAttrGradeByValue(var0_62)
end

function var0_0.GetAttrGradeName(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetAttrGrade(arg1_63)

	return pg.island_chara_att[var0_63].name
end

function var0_0.GetAttrGradeEffect(arg0_64, arg1_64)
	local var0_64 = arg0_64:GetAttrGrade(arg1_64)

	return pg.island_chara_att[var0_64].effect
end

function var0_0.SetUnlockExtraAttLimit(arg0_65)
	arg0_65.unlockExtraAttLimit = true

	arg0_65:InitMaxExtraAttrs()
end

function var0_0.IsUnlockExtraAttLimit(arg0_66)
	return arg0_66.unlockExtraAttLimit
end

function var0_0.InitMaxExtraAttrs(arg0_67)
	for iter0_67, iter1_67 in ipairs(arg0_67:getConfig("extra_max")) do
		local var0_67 = iter1_67[1]
		local var1_67 = iter1_67[2][1]
		local var2_67 = iter1_67[2][2]
		local var3_67 = arg0_67.unlockExtraAttLimit and var2_67 or var1_67
		local var4_67 = IslandShipAttr.GetAtrrName(var0_67)

		arg0_67.maxExtraAttrs[var4_67] = var3_67
	end
end

function var0_0.GetExtraAttrLimit(arg0_68, arg1_68)
	return arg0_68.maxExtraAttrs[arg1_68] or 0
end

function var0_0.GetExtraAttrValue(arg0_69, arg1_69)
	return arg0_69.extraAttrs[arg1_69] or 0
end

function var0_0.ExistPotency(arg0_70)
	for iter0_70, iter1_70 in pairs(IslandShipAttr.ATTRS) do
		if arg0_70:GetExtraAttrLimit(iter1_70) > arg0_70:GetExtraAttrValue(iter1_70) then
			return true
		end
	end

	return false
end

function var0_0.AddExtraAttr(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71:GetExtraAttrLimit(arg1_71)
	local var1_71 = arg0_71:GetExtraAttrValue(arg1_71) + arg2_71

	arg0_71.extraAttrs[arg1_71] = math.min(var1_71, var0_71)

	arg0_71:InitAttrs()
end

function var0_0.GetUpgradeExtraAttrConsume(arg0_72, arg1_72)
	local var0_72 = table.indexof(IslandShipAttr.ATTRS, arg1_72)

	if var0_72 <= 0 then
		return {}
	end

	local var1_72 = arg0_72:getConfig("att_item")
	local var2_72 = {}

	for iter0_72, iter1_72 in ipairs(var1_72[var0_72] or {}) do
		table.insert(var2_72, {
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_72
		})
	end

	return var2_72
end

function var0_0.GetExtraAttrLimitUnlockConsume(arg0_73)
	return {
		{
			id = 100000,
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM
		}
	}
end

function var0_0.InitSkill(arg0_74)
	if arg0_74:getConfig("skill_unlock") <= arg0_74:GetBreakLevel() then
		arg0_74.skill:Unlock()
	end
end

function var0_0.GetSkillUnlockLevel(arg0_75)
	return arg0_75:getConfig("skill_unlock")
end

function var0_0.GetSkill(arg0_76)
	return arg0_76.skill
end

function var0_0.CanUpgradeSkill(arg0_77)
	if not arg0_77.skill:IsUnlock() then
		return false
	end

	if arg0_77.skill:IsMaxLevel() then
		return false
	end

	local var0_77 = arg0_77.skill:GetUpgradeMaterial()
	local var1_77 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	return _.all(var0_77, function(arg0_78)
		return var1_77:GetOwnCount(arg0_78.id) >= arg0_78.count
	end)
end

function var0_0.HasGreetingSkill(arg0_79)
	local var0_79 = arg0_79:GetSkill()

	return var0_79 and var0_79:IsUnlock() and var0_79:IsGreetingType()
end

function var0_0.ApplySkill(arg0_80, arg1_80)
	arg0_80:GetSkill():Apply(arg0_80, arg1_80)
end

function var0_0.GetVaildStatusByGroup(arg0_81, arg1_81)
	return _.select(arg0_81.status, function(arg0_82)
		return not arg0_82:IsExpiration() and arg0_82:GetGroup() == arg1_81
	end)
end

function var0_0.GetVaildStatus(arg0_83)
	return _.select(arg0_83.status, function(arg0_84)
		return not arg0_84:IsExpiration()
	end)
end

function var0_0.GetVaildStatusByType(arg0_85, arg1_85)
	return _.select(arg0_85.status, function(arg0_86)
		return not arg0_86:IsExpiration() and arg0_86:GetBuffType() == arg1_85
	end)
end

function var0_0.GetDisplayStatus(arg0_87)
	return _.select(arg0_87.status, function(arg0_88)
		return not arg0_88:IsExpiration() and arg0_88:CanDisplay()
	end)
end

function var0_0.GetFavoriteGift(arg0_89)
	return arg0_89:getConfig("gift_id")
end

function var0_0.IsFavoriteGift(arg0_90, arg1_90)
	local var0_90 = arg0_90:GetFavoriteGift()

	return _.any(var0_90, function(arg0_91)
		return arg0_91 == arg1_90
	end)
end

function var0_0.AddStatus(arg0_92, arg1_92)
	local var0_92 = _.detect(arg0_92.status, function(arg0_93)
		return arg0_93.id == arg1_92.id
	end)

	if var0_92 then
		table.removebyvalue(arg0_92.status, var0_92)
	end

	local var1_92 = arg0_92:GetVaildStatus()
	local var2_92 = arg1_92:GetDuelTypeList()
	local var3_92 = _.detect(var1_92, function(arg0_94)
		return table.contains(var2_92, arg0_94:GetGroup())
	end)

	if var3_92 then
		table.removebyvalue(arg0_92.status, var3_92)
	end

	local var4_92 = arg1_92:GetDuelIdList()
	local var5_92 = _.detect(var1_92, function(arg0_95)
		return table.contains(var4_92, arg0_95.id)
	end)

	if var5_92 then
		table.removebyvalue(arg0_92.status, var5_92)
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipAddBuff(arg0_92.id, arg1_92.id))
	table.insert(arg0_92.status, arg1_92)
end

return var0_0
