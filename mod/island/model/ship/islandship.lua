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

	local var0_20 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_20 = math.floor(arg0_20.energy + (var0_20 - arg0_20.recorverTime) / arg0_20.recoverSpeed)
	local var2_20 = arg0_20:GetSkillAddRecoverSpeed()

	if var2_20 > 0 then
		local var3_20 = math.floor((var0_20 - arg0_20.recorverTime) / arg0_20.recoverSpeed)

		var1_20 = var1_20 + math.floor(var3_20 * var2_20 * 0.01)
	end

	local var4_20 = arg0_20:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var4_20 == 0 then
		return math.min(arg0_20.maxEnerey, var1_20)
	end

	local function var5_20(arg0_21, arg1_21, arg2_21, arg3_21)
		local var0_21 = math.max(arg0_21, arg2_21)
		local var1_21 = math.min(arg1_21, arg3_21)

		if var0_21 < var1_21 then
			return var1_21 - var0_21
		else
			return 0
		end
	end

	local var6_20 = var4_20:GetBuffEffect()[1] * 0.01
	local var7_20 = var5_20(arg0_20.recorverTime, var0_20, var4_20:GetStartTime(), var4_20:GetEndTime())
	local var8_20 = var1_20 + math.floor(var7_20 / arg0_20.recoverSpeed * var6_20)

	return math.min(arg0_20.maxEnerey, var8_20)
end

function var0_0.GetCurrentEnergyDecimal(arg0_22)
	local var0_22 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_22 = arg0_22.energy + (var0_22 - arg0_22.recorverTime) / arg0_22.recoverSpeed
	local var2_22 = arg0_22:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)
	local var3_22 = arg0_22:GetSkillAddRecoverSpeed()

	if var3_22 > 0 then
		var1_22 = var1_22 + (var0_22 - arg0_22.recorverTime) / arg0_22.recoverSpeed * var3_22 * 0.01
	end

	if #var2_22 == 0 then
		return math.min(arg0_22.maxEnerey, var1_22)
	end

	local function var4_22(arg0_23, arg1_23, arg2_23, arg3_23)
		local var0_23 = math.max(arg0_23, arg2_23)
		local var1_23 = math.min(arg1_23, arg3_23)

		if var0_23 < var1_23 then
			return var1_23 - var0_23
		else
			return 0
		end
	end

	local var5_22 = var2_22:GetBuffEffect()[1] * 0.01
	local var6_22 = var1_22 + var4_22(arg0_22.recorverTime, var0_22, var2_22:GetStartTime(), var2_22:GetEndTime()) / arg0_22.recoverSpeed * var5_22

	return math.min(arg0_22.maxEnerey, var6_22)
end

function var0_0.GetEnergyMaxTime(arg0_24)
	local var0_24 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_24 = arg0_24.maxEnerey - arg0_24:GetCurrentEnergyDecimal()
	local var2_24 = arg0_24:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)
	local var3_24 = arg0_24:GetSkillAddRecoverSpeed()
	local var4_24 = arg0_24.recoverSpeed / (1 + var3_24 * 0.01)

	if #var2_24 == 0 then
		return var0_24 + math.floor(var1_24 * var4_24)
	end

	if var0_24 <= var2_24:GetEndTime() then
		local var5_24 = var2_24:GetEndTime() - var0_24
		local var6_24 = var4_24 / (1 + var2_24:GetBuffEffect()[1] * 0.01)
		local var7_24 = var6_24 * var5_24

		if var1_24 <= var7_24 then
			return var0_24 + math.floor(var1_24 / var6_24)
		end

		local var8_24 = var1_24 - var7_24

		return var0_24 + math.floor(var8_24 / var4_24) + math.floor(var1_24 / var6_24)
	end

	return var0_24 + math.floor(var1_24 * var4_24)
end

function var0_0.AnySkillCanUpgrade(arg0_25)
	return arg0_25:CanUpgradeSkill()
end

function var0_0.HasStatus(arg0_26)
	return table.getCount(arg0_26:GetVaildStatus()) > 0
end

function var0_0.GetPower(arg0_27)
	local var0_27 = arg0_27:GetLevel() * 1000000
	local var1_27 = 0

	for iter0_27, iter1_27 in pairs(arg0_27:GetAttrs()) do
		var1_27 = var1_27 + iter1_27
	end

	return var0_27 + var1_27
end

function var0_0.GetName(arg0_28)
	return arg0_28:getConfig("name")
end

function var0_0.GetEnName(arg0_29)
	local var0_29 = arg0_29:GetModelUnit()

	return pg.island_unit_character[var0_29].english_name
end

function var0_0.StaticGetName(arg0_30)
	return pg.island_chara_template[arg0_30].name
end

function var0_0.GetPrefab(arg0_31)
	return var0_0.StaticGetPrefab(arg0_31.configId)
end

function var0_0.GetModelUnit(arg0_32)
	local var0_32 = arg0_32:getConfig("unit_id")

	if arg0_32.cur_skin_id and arg0_32.cur_skin_id ~= 0 then
		var0_32 = pg.island_skin_template[arg0_32.cur_skin_id].model

		local var1_32 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetCurrentSkinColorByShipId(arg0_32.id, arg0_32.cur_skin_id)

		if var1_32 ~= 0 then
			var0_32 = pg.island_skin_colordiff_template[var1_32].model
		end
	end

	return var0_32
end

function var0_0.GetCurrentSkinId(arg0_33)
	return arg0_33.cur_skin_id or 0
end

function var0_0.GetModel(arg0_34)
	local var0_34 = arg0_34:GetModelUnit()
	local var1_34 = pg.island_unit_character[var0_34]
	local var2_34 = var1_34.personal_ani

	return {
		model = var1_34.model,
		animator = var1_34.animator,
		personal_ani = var2_34
	}
end

function var0_0.GetModelBySkinAndColorId(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35:getConfig("unit_id")

	if arg1_35 and arg1_35 ~= 0 then
		var0_35 = pg.island_skin_template[arg1_35].model

		if arg2_35 ~= 0 then
			var0_35 = pg.island_skin_colordiff_template[arg2_35].model
		end
	end

	return var0_35
end

function var0_0.ChangeSkinId(arg0_36, arg1_36)
	if arg0_36.cur_skin_id ~= arg1_36 then
		arg0_36.cur_skin_id = arg1_36
	end
end

function var0_0.GetCurSkinId(arg0_37)
	return arg0_37.cur_skin_id or 0
end

function var0_0.GetNewShipWord(arg0_38)
	return ""
end

function var0_0.GetShipGroup(arg0_39)
	return arg0_39.configId
end

function var0_0.StaticGetPrefab(arg0_40)
	local var0_40 = pg.island_chara_template[arg0_40].unit_id

	return pg.island_unit_character[var0_40].IslandShipIcon
end

function var0_0.UpdateState(arg0_41, arg1_41, arg2_41)
	arg0_41.state = arg1_41
	arg0_41.stateId = arg2_41
end

function var0_0.GetState(arg0_42)
	if pg.TimeMgr.GetInstance():GetServerTime() >= arg0_42.recorverTime then
		return var0_0.STATE_NORMAL
	end

	return arg0_42.state
end

function var0_0.GetStateId(arg0_43)
	return arg0_43.stateId
end

function var0_0.GetStatePlaceName(arg0_44)
	return switch(arg0_44.state, {
		[var0_0.STATE_DELEGATION] = function()
			return pg.island_production_place[arg0_44.stateId].name
		end,
		[var0_0.STATE_TECHNOLOGY] = function()
			return pg.island_production_place[arg0_44.stateId].name
		end,
		[var0_0.STATE_RESTAURANT] = function()
			return pg.island_manage_restaurant[arg0_44.stateId].name
		end
	}, function()
		return ""
	end)
end

function var0_0.IsDelegable(arg0_49)
	return arg0_49:GetState() == var0_0.STATE_NORMAL and not getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(arg0_49.id)
end

function var0_0.GetBreakLevel(arg0_50)
	return arg0_50.breakLevel
end

function var0_0.GetBreakMaxLevel(arg0_51)
	return arg0_51:getConfig("upgrade_level")[2] + 1
end

function var0_0.GetBreakPhaseValue(arg0_52)
	return arg0_52:getConfig("upgrade_level")[1]
end

function var0_0.IsMaxBreakLevel(arg0_53)
	return arg0_53:GetBreakMaxLevel() <= arg0_53:GetBreakLevel()
end

function var0_0.CanBreakOut(arg0_54)
	if arg0_54:IsMaxBreakLevel() then
		return false
	end

	local var0_54 = arg0_54:GetBreakPhaseValue()

	return arg0_54.level % var0_54 == 0
end

function var0_0.UpgradeBreakOut(arg0_55)
	arg0_55.breakLevel = arg0_55.breakLevel + 1

	arg0_55:InitMaxLevel()

	local var0_55 = arg0_55:GetMaxEnergy()
	local var1_55 = var0_55 - arg0_55:GetEnergy()

	arg0_55:InitMaxEnergy(true)

	local var2_55 = arg0_55:GetMaxEnergy()

	if var0_55 < var2_55 then
		arg0_55.energy = var2_55 - var1_55
	end

	arg0_55:InitSkill()
end

function var0_0.GetBreakoutMatrials(arg0_56)
	local var0_56 = arg0_56:getConfig("upgrade_material")
	local var1_56 = {}
	local var2_56 = var0_56[arg0_56:GetBreakLevel()] or {}

	for iter0_56, iter1_56 in ipairs(var2_56) do
		table.insert(var1_56, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_56[1],
			count = iter1_56[2]
		})
	end

	return var1_56
end

function var0_0.InitAttrs(arg0_57)
	local var0_57 = arg0_57:GetBreakPhaseValue()
	local var1_57 = math.floor(arg0_57.level / var0_57)
	local var2_57 = arg0_57.level % var0_57
	local var3_57 = arg0_57:getConfig("base_att")

	for iter0_57, iter1_57 in ipairs(var3_57) do
		local var4_57 = iter1_57[1]
		local var5_57 = iter1_57[2]
		local var6_57 = IslandShipAttr.GetAtrrName(var4_57)

		arg0_57.attrs[var6_57] = var5_57
	end

	local var7_57 = arg0_57:getConfig("growth_att")

	for iter2_57, iter3_57 in ipairs(var7_57) do
		local var8_57 = iter3_57[1]
		local var9_57 = iter3_57[2]
		local var10_57 = IslandShipAttr.GetAtrrName(var8_57)
		local var11_57 = 0

		for iter4_57 = 1, var1_57 do
			var11_57 = var11_57 + var9_57[iter4_57] * var0_57
		end

		if var1_57 < #var9_57 then
			var11_57 = var11_57 + var9_57[var1_57 + 1] * var2_57
		end

		arg0_57.attrs[var10_57] = arg0_57.attrs[var10_57] + var11_57
	end

	for iter5_57, iter6_57 in pairs(arg0_57.extraAttrs) do
		arg0_57.attrs[iter5_57] = arg0_57.attrs[iter5_57] + iter6_57
	end

	for iter7_57, iter8_57 in pairs(arg0_57.attrs) do
		arg0_57.attrs[iter7_57] = math.floor(iter8_57)
	end
end

function var0_0.GetGrowthAtt(arg0_58)
	local var0_58 = {}
	local var1_58 = arg0_58:getConfig("growth_att")

	for iter0_58, iter1_58 in ipairs(var1_58) do
		local var2_58 = iter1_58[1]
		local var3_58 = iter1_58[2]

		var0_58[IslandShipAttr.GetAtrrName(var2_58)] = var3_58[arg0_58:GetBreakLevel()] or 0
	end

	return var0_58
end

function var0_0.GetAttrs(arg0_59)
	return arg0_59.attrs
end

function var0_0.GetAttr(arg0_60, arg1_60)
	return arg0_60.attrs[arg1_60] or 0
end

function var0_0.GetAttrGradeCnt(arg0_61, arg1_61)
	local var0_61 = 0

	for iter0_61, iter1_61 in pairs(arg0_61.attrs) do
		if arg1_61 >= arg0_61:GetAttrGrade(iter0_61) then
			var0_61 = var0_61 + 1
		end
	end

	return var0_61
end

function var0_0.GetAttrGradeByValue(arg0_62, arg1_62)
	local var0_62 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_62, iter1_62 in ipairs(pg.island_chara_att.all) do
		local var1_62 = pg.island_chara_att[iter1_62]
		local var2_62 = var1_62.range[1]
		local var3_62 = var1_62.range[2]

		if var2_62 <= arg1_62 and arg1_62 <= var3_62 then
			var0_62 = iter1_62

			break
		end
	end

	return var0_62
end

function var0_0.GetAttrGrade(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetAttr(arg1_63)

	return arg0_63:GetAttrGradeByValue(var0_63)
end

function var0_0.GetAttrGradeName(arg0_64, arg1_64)
	local var0_64 = arg0_64:GetAttrGrade(arg1_64)

	return pg.island_chara_att[var0_64].name
end

function var0_0.GetAttrGradeEffect(arg0_65, arg1_65)
	local var0_65 = arg0_65:GetAttrGrade(arg1_65)

	return pg.island_chara_att[var0_65].effect
end

function var0_0.SetUnlockExtraAttLimit(arg0_66)
	arg0_66.unlockExtraAttLimit = true

	arg0_66:InitMaxExtraAttrs()
end

function var0_0.IsUnlockExtraAttLimit(arg0_67)
	return arg0_67.unlockExtraAttLimit
end

function var0_0.InitMaxExtraAttrs(arg0_68)
	for iter0_68, iter1_68 in ipairs(arg0_68:getConfig("extra_max")) do
		local var0_68 = iter1_68[1]
		local var1_68 = iter1_68[2][1]
		local var2_68 = iter1_68[2][2]
		local var3_68 = arg0_68.unlockExtraAttLimit and var2_68 or var1_68
		local var4_68 = IslandShipAttr.GetAtrrName(var0_68)

		arg0_68.maxExtraAttrs[var4_68] = var3_68
	end
end

function var0_0.GetExtraAttrLimit(arg0_69, arg1_69)
	return arg0_69.maxExtraAttrs[arg1_69] or 0
end

function var0_0.GetExtraAttrValue(arg0_70, arg1_70)
	return arg0_70.extraAttrs[arg1_70] or 0
end

function var0_0.ExistPotency(arg0_71)
	for iter0_71, iter1_71 in pairs(IslandShipAttr.ATTRS) do
		if arg0_71:GetExtraAttrLimit(iter1_71) > arg0_71:GetExtraAttrValue(iter1_71) then
			return true
		end
	end

	return false
end

function var0_0.AddExtraAttr(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72:GetExtraAttrLimit(arg1_72)
	local var1_72 = arg0_72:GetExtraAttrValue(arg1_72) + arg2_72

	arg0_72.extraAttrs[arg1_72] = math.min(var1_72, var0_72)

	arg0_72:InitAttrs()
end

function var0_0.GetUpgradeExtraAttrConsume(arg0_73, arg1_73)
	local var0_73 = table.indexof(IslandShipAttr.ATTRS, arg1_73)

	if var0_73 <= 0 then
		return {}
	end

	local var1_73 = arg0_73:getConfig("att_item")
	local var2_73 = {}

	for iter0_73, iter1_73 in ipairs(var1_73[var0_73] or {}) do
		table.insert(var2_73, {
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_73
		})
	end

	return var2_73
end

function var0_0.GetExtraAttrLimitUnlockConsume(arg0_74)
	return {
		{
			id = 100000,
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM
		}
	}
end

function var0_0.InitSkill(arg0_75)
	if arg0_75:getConfig("skill_unlock") <= arg0_75:GetBreakLevel() then
		arg0_75.skill:Unlock()
	end
end

function var0_0.GetSkillUnlockLevel(arg0_76)
	return arg0_76:getConfig("skill_unlock")
end

function var0_0.GetSkill(arg0_77)
	return arg0_77.skill
end

function var0_0.CanUpgradeSkill(arg0_78)
	if not arg0_78.skill:IsUnlock() then
		return false
	end

	if arg0_78.skill:IsMaxLevel() then
		return false
	end

	local var0_78 = arg0_78.skill:GetUpgradeMaterial()
	local var1_78 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	return _.all(var0_78, function(arg0_79)
		return var1_78:GetOwnCount(arg0_79.id) >= arg0_79.count
	end)
end

function var0_0.HasGreetingSkill(arg0_80)
	local var0_80 = arg0_80:GetSkill()

	return var0_80 and var0_80:IsUnlock() and var0_80:IsGreetingType()
end

function var0_0.ApplySkill(arg0_81, arg1_81)
	arg0_81:GetSkill():Apply(arg0_81, arg1_81)
end

function var0_0.GetVaildStatusByGroup(arg0_82, arg1_82)
	return _.select(arg0_82.status, function(arg0_83)
		return not arg0_83:IsExpiration() and arg0_83:GetGroup() == arg1_82
	end)
end

function var0_0.GetVaildStatus(arg0_84)
	return _.select(arg0_84.status, function(arg0_85)
		return not arg0_85:IsExpiration()
	end)
end

function var0_0.GetVaildStatusByType(arg0_86, arg1_86)
	return _.select(arg0_86.status, function(arg0_87)
		return not arg0_87:IsExpiration() and arg0_87:GetBuffType() == arg1_86
	end)
end

function var0_0.GetDisplayStatus(arg0_88)
	return _.select(arg0_88.status, function(arg0_89)
		return not arg0_89:IsExpiration() and arg0_89:CanDisplay()
	end)
end

function var0_0.GetFavoriteGift(arg0_90)
	return arg0_90:getConfig("gift_id")
end

function var0_0.IsFavoriteGift(arg0_91, arg1_91)
	local var0_91 = arg0_91:GetFavoriteGift()

	return _.any(var0_91, function(arg0_92)
		return arg0_92 == arg1_91
	end)
end

function var0_0.AddStatus(arg0_93, arg1_93)
	local var0_93 = _.detect(arg0_93.status, function(arg0_94)
		return arg0_94.id == arg1_93.id
	end)

	if var0_93 then
		table.removebyvalue(arg0_93.status, var0_93)
	end

	local var1_93 = arg0_93:GetVaildStatus()
	local var2_93 = arg1_93:GetDuelTypeList()
	local var3_93 = _.detect(var1_93, function(arg0_95)
		return table.contains(var2_93, arg0_95:GetGroup())
	end)

	if var3_93 then
		table.removebyvalue(arg0_93.status, var3_93)
	end

	local var4_93 = arg1_93:GetDuelIdList()
	local var5_93 = _.detect(var1_93, function(arg0_96)
		return table.contains(var4_93, arg0_96.id)
	end)

	if var5_93 then
		table.removebyvalue(arg0_93.status, var5_93)
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipAddBuff(arg0_93.id, arg1_93.id))
	table.insert(arg0_93.status, arg1_93)
end

return var0_0
