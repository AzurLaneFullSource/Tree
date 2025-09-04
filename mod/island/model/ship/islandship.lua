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
	arg0_1.currentDressTypeDic = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.currentDressTypeDic or {}) do
		arg0_1.currentDressTypeDic[iter4_1] = iter5_1
	end

	arg0_1.cur_skin_id = arg1_1.cur_skin_id
	arg0_1.hasOwnDressList = {}

	for iter6_1, iter7_1 in ipairs(arg1_1.dress_list or {}) do
		table.insert(arg0_1.hasOwnDressList, IslandShipDressItem.New(iter7_1))
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_chara_template
end

function var0_0.GetLevel(arg0_3)
	return arg0_3.level or 1
end

function var0_0.GetExp(arg0_4)
	return arg0_4.exp or 0
end

function var0_0.AddExp(arg0_5, arg1_5)
	if arg0_5:IsMaxLevel() then
		return
	end

	arg0_5.exp = arg0_5.exp + arg1_5

	while arg0_5:CanUpgrade() do
		arg0_5.exp = arg0_5.exp - arg0_5:GetTargetExp()
		arg0_5.level = arg0_5.level + 1

		arg0_5:InitAttrs()
	end

	if arg0_5:IsMaxLevel() then
		arg0_5.exp = 0
	end
end

function var0_0.CanUpgrade(arg0_6)
	return not arg0_6:IsMaxLevel() and arg0_6.exp >= arg0_6:GetTargetExp()
end

function var0_0.GetTargetExp(arg0_7)
	if arg0_7:IsMaxLevel() then
		return 0
	end

	return pg.island_chara_level[arg0_7.level].level_up_exp
end

function var0_0.IsMaxLevel(arg0_8)
	return arg0_8.level >= arg0_8.maxLevel
end

function var0_0.InitMaxLevel(arg0_9)
	arg0_9.maxLevel = arg0_9:GetBreakLevel() * arg0_9:GetBreakPhaseValue()
end

function var0_0.GetMaxLevel(arg0_10)
	return arg0_10.maxLevel
end

function var0_0.GetEnergy(arg0_11)
	return arg0_11.energy
end

function var0_0.AddEnergy(arg0_12, arg1_12)
	local var0_12 = arg0_12.energy + arg1_12
	local var1_12 = arg0_12:GetMaxEnergy()

	if var1_12 < var0_12 then
		arg0_12.energy = var1_12
	else
		arg0_12.energy = var0_12
	end
end

function var0_0.UpdateEnergy(arg0_13, arg1_13)
	arg0_13.energy = arg1_13
end

function var0_0.UpdateEnergyBeginRecoverTime(arg0_14, arg1_14)
	arg0_14.recorverTime = arg1_14
end

function var0_0.GetMaxEnergy(arg0_15)
	return arg0_15.maxEnerey
end

function var0_0.InitMaxEnergy(arg0_16)
	local var0_16 = arg0_16.maxEnerey
	local var1_16, var2_16 = arg0_16:GetBreakLevel(), arg0_16:getConfig("upgrade_power")

	for iter0_16 = 1, var1_16 do
		arg0_16.maxEnerey = arg0_16.maxEnerey + (var2_16[iter0_16] or 0)
	end

	if arg0_16.maxEnerey - var0_16 > 0 then
		local var3_16 = var0_16 - arg0_16.energy

		arg0_16.energy = arg0_16.maxEnerey - var3_16
	end
end

function var0_0.InitEnergyRecoverTime(arg0_17)
	arg0_17.recoverSpeed = arg0_17:getConfig("power_recover")
end

function var0_0.GetCurrentEnergy(arg0_18)
	if arg0_18:GetState() ~= var0_0.STATE_NORMAL then
		return math.min(arg0_18.maxEnerey, arg0_18.energy)
	end

	local var0_18 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_18 = math.floor(arg0_18.energy + (var0_18 - arg0_18.recorverTime) / arg0_18.recoverSpeed)
	local var2_18 = arg0_18:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var2_18 == 0 then
		return math.min(arg0_18.maxEnerey, var1_18)
	end

	local function var3_18(arg0_19, arg1_19, arg2_19, arg3_19)
		local var0_19 = math.max(arg0_19, arg2_19)
		local var1_19 = math.min(arg1_19, arg3_19)

		if var0_19 < var1_19 then
			return var1_19 - var0_19
		else
			return 0
		end
	end

	local var4_18 = var2_18:GetBuffEffect()[1] * 0.01
	local var5_18 = var3_18(arg0_18.recorverTime, var0_18, var2_18:GetStartTime(), var2_18:GetEndTime())
	local var6_18 = var1_18 + math.floor(var5_18 / arg0_18.recoverSpeed * var4_18)

	return math.min(arg0_18.maxEnerey, var6_18)
end

function var0_0.GetCurrentEnergyDecimal(arg0_20)
	local var0_20 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_20 = arg0_20.energy + (var0_20 - arg0_20.recorverTime) / arg0_20.recoverSpeed
	local var2_20 = arg0_20:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var2_20 == 0 then
		return math.min(arg0_20.maxEnerey, var1_20)
	end

	local function var3_20(arg0_21, arg1_21, arg2_21, arg3_21)
		local var0_21 = math.max(arg0_21, arg2_21)
		local var1_21 = math.min(arg1_21, arg3_21)

		if var0_21 < var1_21 then
			return var1_21 - var0_21
		else
			return 0
		end
	end

	local var4_20 = var2_20:GetBuffEffect()[1] * 0.01
	local var5_20 = var1_20 + var3_20(arg0_20.recorverTime, var0_20, var2_20:GetStartTime(), var2_20:GetEndTime()) / arg0_20.recoverSpeed * var4_20

	return math.min(arg0_20.maxEnerey, var5_20)
end

function var0_0.GetEnergyMaxTime(arg0_22)
	local var0_22 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_22 = arg0_22.maxEnerey - arg0_22:GetCurrentEnergyDecimal()
	local var2_22 = arg0_22:GetVaildStatusByType(IslandBuffType.SHIP_POWER_RECOVER)

	if #var2_22 == 0 then
		return var0_22 + var1_22 * arg0_22.recoverSpeed
	end

	if var0_22 <= var2_22:GetEndTime() then
		local var3_22 = var2_22:GetEndTime() - var0_22
		local var4_22 = var2_22:GetBuffEffect()[1] * 0.01
		local var5_22 = arg0_22.recoverSpeed / (1 + var4_22)
		local var6_22 = var5_22 * var3_22

		if var1_22 <= var6_22 then
			return var0_22 + var1_22 / var5_22
		end

		return var0_22 + (var1_22 - var6_22) / arg0_22.recoverSpeed + var1_22 / var5_22
	end

	return var0_22 + var1_22 * arg0_22.recoverSpeed
end

function var0_0.AnySkillCanUpgrade(arg0_23)
	return arg0_23:CanUpgradeSkill()
end

function var0_0.HasStatus(arg0_24)
	return table.getCount(arg0_24:GetVaildStatus()) > 0
end

function var0_0.GetPower(arg0_25)
	local var0_25 = arg0_25:GetLevel() * 1000000
	local var1_25 = 0

	for iter0_25, iter1_25 in pairs(arg0_25:GetAttrs()) do
		var1_25 = var1_25 + iter1_25
	end

	return var0_25 + var1_25
end

function var0_0.GetName(arg0_26)
	return arg0_26:getConfig("name")
end

function var0_0.GetEnName(arg0_27)
	local var0_27 = arg0_27:GetShipGroup()

	return ShipGroup.getDefaultShipConfig(var0_27).english_name
end

function var0_0.StaticGetName(arg0_28)
	return pg.island_chara_template[arg0_28].name
end

function var0_0.GetPrefab(arg0_29)
	return var0_0.StaticGetPrefab(arg0_29.configId)
end

function var0_0.GetModelUnit(arg0_30)
	local var0_30 = arg0_30:getConfig("unit_id")

	if arg0_30.cur_skin_id and arg0_30.cur_skin_id ~= 0 then
		var0_30 = pg.island_skin_template[arg0_30.cur_skin_id].model

		local var1_30 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetCurrentSkinColorByShipId(arg0_30.id, arg0_30.cur_skin_id)

		if var1_30 ~= 0 then
			var0_30 = pg.island_skin_colordiff_template[var1_30].model
		end
	end

	return var0_30
end

function var0_0.GetModel(arg0_31)
	local var0_31 = arg0_31:GetModelUnit()
	local var1_31 = pg.island_unit_character[var0_31]

	return {
		model = var1_31.model,
		animator = var1_31.animator
	}
end

function var0_0.GetModelBySkinAndColorId(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32:getConfig("unit_id")

	if arg1_32 and arg1_32 ~= 0 then
		var0_32 = pg.island_skin_template[arg1_32].model

		if arg2_32 ~= 0 then
			var0_32 = pg.island_skin_colordiff_template[arg2_32].model
		end
	end

	return var0_32
end

function var0_0.ChangeSkinId(arg0_33, arg1_33)
	if arg0_33.cur_skin_id ~= arg1_33 then
		arg0_33.cur_skin_id = arg1_33
	end
end

function var0_0.GetCurSkinId(arg0_34)
	return arg0_34.cur_skin_id or 0
end

function var0_0.GetNewShipWord(arg0_35)
	return ""
end

function var0_0.GetShipGroup(arg0_36)
	return arg0_36.configId
end

function var0_0.StaticGetPrefab(arg0_37)
	if arg0_37 == IslandCharacterAgency.NPC_CONFIG_ID then
		return "jiujiu"
	end

	local var0_37 = arg0_37
	local var1_37 = ShipGroup.getDefaultShipConfig(var0_37).skin_id

	return pg.ship_skin_template[var1_37].prefab
end

function var0_0.UpdateState(arg0_38, arg1_38, arg2_38)
	arg0_38.state = arg1_38
	arg0_38.stateId = arg2_38
end

function var0_0.GetState(arg0_39)
	if pg.TimeMgr.GetInstance():GetServerTime() > arg0_39.recorverTime then
		return var0_0.STATE_NORMAL
	end

	return arg0_39.state
end

function var0_0.GetStateId(arg0_40)
	return arg0_40.stateId
end

function var0_0.GetStatePlaceName(arg0_41)
	return switch(arg0_41.state, {
		[var0_0.STATE_DELEGATION] = function()
			return pg.island_production_place[arg0_41.stateId].name
		end,
		[var0_0.STATE_TECHNOLOGY] = function()
			return pg.island_production_place[arg0_41.stateId].name
		end,
		[var0_0.STATE_RESTAURANT] = function()
			return pg.island_manage_restaurant[arg0_41.stateId].name
		end
	}, function()
		return ""
	end)
end

function var0_0.GetBreakLevel(arg0_46)
	return arg0_46.breakLevel
end

function var0_0.GetBreakMaxLevel(arg0_47)
	return arg0_47:getConfig("upgrade_level")[2] + 1
end

function var0_0.GetBreakPhaseValue(arg0_48)
	return arg0_48:getConfig("upgrade_level")[1]
end

function var0_0.IsMaxBreakLevel(arg0_49)
	return arg0_49:GetBreakMaxLevel() <= arg0_49:GetBreakLevel()
end

function var0_0.CanBreakOut(arg0_50)
	if arg0_50:IsMaxBreakLevel() then
		return false
	end

	local var0_50 = arg0_50:GetBreakPhaseValue()

	return arg0_50.level % var0_50 == 0
end

function var0_0.UpgradeBreakOut(arg0_51)
	arg0_51.breakLevel = arg0_51.breakLevel + 1

	arg0_51:InitMaxLevel()

	local var0_51 = arg0_51:GetMaxEnergy()
	local var1_51 = var0_51 - arg0_51:GetEnergy()

	arg0_51:InitMaxEnergy()

	if var0_51 < arg0_51:GetMaxEnergy() then
		arg0_51.energy = arg0_51.energy + var1_51
	end

	arg0_51:InitSkill()
end

function var0_0.GetBreakoutMatrials(arg0_52)
	local var0_52 = arg0_52:getConfig("upgrade_material")
	local var1_52 = {}
	local var2_52 = var0_52[arg0_52:GetBreakLevel()] or {}

	for iter0_52, iter1_52 in ipairs(var2_52) do
		table.insert(var1_52, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_52[1],
			count = iter1_52[2]
		})
	end

	return var1_52
end

function var0_0.InitAttrs(arg0_53)
	local var0_53 = arg0_53:GetBreakPhaseValue()
	local var1_53 = math.floor(arg0_53.level / var0_53)
	local var2_53 = arg0_53.level % var0_53
	local var3_53 = arg0_53:getConfig("base_att")

	for iter0_53, iter1_53 in ipairs(var3_53) do
		local var4_53 = iter1_53[1]
		local var5_53 = iter1_53[2]
		local var6_53 = IslandShipAttr.GetAtrrName(var4_53)

		arg0_53.attrs[var6_53] = var5_53
	end

	local var7_53 = arg0_53:getConfig("growth_att")

	for iter2_53, iter3_53 in ipairs(var7_53) do
		local var8_53 = iter3_53[1]
		local var9_53 = iter3_53[2]
		local var10_53 = IslandShipAttr.GetAtrrName(var8_53)
		local var11_53 = 0

		for iter4_53 = 1, var1_53 do
			var11_53 = var11_53 + var9_53[iter4_53] * var0_53
		end

		if var1_53 < #var9_53 then
			var11_53 = var11_53 + var9_53[var1_53 + 1] * var2_53
		end

		arg0_53.attrs[var10_53] = arg0_53.attrs[var10_53] + var11_53
	end

	for iter5_53, iter6_53 in pairs(arg0_53.extraAttrs) do
		arg0_53.attrs[iter5_53] = arg0_53.attrs[iter5_53] + iter6_53
	end
end

function var0_0.GetGrowthAtt(arg0_54)
	local var0_54 = {}
	local var1_54 = arg0_54:getConfig("growth_att")

	for iter0_54, iter1_54 in ipairs(var1_54) do
		local var2_54 = iter1_54[1]
		local var3_54 = iter1_54[2]

		var0_54[IslandShipAttr.GetAtrrName(var2_54)] = var3_54[arg0_54:GetBreakLevel()] or 0
	end

	return var0_54
end

function var0_0.GetAttrs(arg0_55)
	return arg0_55.attrs
end

function var0_0.GetAttr(arg0_56, arg1_56)
	return arg0_56.attrs[arg1_56] or 0
end

function var0_0.GetAttrGradeCnt(arg0_57, arg1_57)
	local var0_57 = 0

	for iter0_57, iter1_57 in pairs(arg0_57.attrs) do
		if arg1_57 >= arg0_57:GetAttrGrade(iter0_57) then
			var0_57 = var0_57 + 1
		end
	end

	return var0_57
end

function var0_0.GetAttrGradeByValue(arg0_58, arg1_58)
	local var0_58 = pg.island_chara_att.all[#pg.island_chara_att.all]

	for iter0_58, iter1_58 in ipairs(pg.island_chara_att.all) do
		local var1_58 = pg.island_chara_att[iter1_58]
		local var2_58 = var1_58.range[1]
		local var3_58 = var1_58.range[2]

		if var2_58 <= arg1_58 and arg1_58 <= var3_58 then
			var0_58 = iter1_58

			break
		end
	end

	return var0_58
end

function var0_0.GetAttrGrade(arg0_59, arg1_59)
	local var0_59 = arg0_59:GetAttr(arg1_59)

	return arg0_59:GetAttrGradeByValue(var0_59)
end

function var0_0.GetAttrGradeName(arg0_60, arg1_60)
	local var0_60 = arg0_60:GetAttrGrade(arg1_60)

	return pg.island_chara_att[var0_60].name
end

function var0_0.GetAttrGradeEffect(arg0_61, arg1_61)
	local var0_61 = arg0_61:GetAttrGrade(arg1_61)

	return pg.island_chara_att[var0_61].effect
end

function var0_0.SetUnlockExtraAttLimit(arg0_62)
	arg0_62.unlockExtraAttLimit = true

	arg0_62:InitMaxExtraAttrs()
end

function var0_0.IsUnlockExtraAttLimit(arg0_63)
	return arg0_63.unlockExtraAttLimit
end

function var0_0.InitMaxExtraAttrs(arg0_64)
	for iter0_64, iter1_64 in ipairs(arg0_64:getConfig("extra_max")) do
		local var0_64 = iter1_64[1]
		local var1_64 = iter1_64[2][1]
		local var2_64 = iter1_64[2][2]
		local var3_64 = arg0_64.unlockExtraAttLimit and var2_64 or var1_64
		local var4_64 = IslandShipAttr.GetAtrrName(var0_64)

		arg0_64.maxExtraAttrs[var4_64] = var3_64
	end
end

function var0_0.GetExtraAttrLimit(arg0_65, arg1_65)
	return arg0_65.maxExtraAttrs[arg1_65] or 0
end

function var0_0.GetExtraAttrValue(arg0_66, arg1_66)
	return arg0_66.extraAttrs[arg1_66] or 0
end

function var0_0.ExistPotency(arg0_67)
	for iter0_67, iter1_67 in pairs(IslandShipAttr.ATTRS) do
		if arg0_67:GetExtraAttrLimit(iter1_67) > arg0_67:GetExtraAttrValue(iter1_67) then
			return true
		end
	end

	return false
end

function var0_0.AddExtraAttr(arg0_68, arg1_68, arg2_68)
	local var0_68 = arg0_68:GetExtraAttrLimit(arg1_68)
	local var1_68 = arg0_68:GetExtraAttrValue(arg1_68) + arg2_68

	arg0_68.extraAttrs[arg1_68] = math.min(var1_68, var0_68)

	arg0_68:InitAttrs()
end

function var0_0.GetUpgradeExtraAttrConsume(arg0_69, arg1_69)
	local var0_69 = table.indexof(IslandShipAttr.ATTRS, arg1_69)

	if var0_69 <= 0 then
		return {}
	end

	local var1_69 = arg0_69:getConfig("att_item")
	local var2_69 = {}

	for iter0_69, iter1_69 in ipairs(var1_69[var0_69] or {}) do
		table.insert(var2_69, {
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_69
		})
	end

	return var2_69
end

function var0_0.GetExtraAttrLimitUnlockConsume(arg0_70)
	return {
		{
			id = 100000,
			count = 1,
			type = DROP_TYPE_ISLAND_ITEM
		}
	}
end

function var0_0.InitSkill(arg0_71)
	if arg0_71:getConfig("skill_unlock") <= arg0_71:GetBreakLevel() then
		arg0_71.skill:Unlock()
	end
end

function var0_0.GetSkillUnlockLevel(arg0_72)
	return arg0_72:getConfig("skill_unlock")
end

function var0_0.GetSkill(arg0_73)
	return arg0_73.skill
end

function var0_0.CanUpgradeSkill(arg0_74)
	if not arg0_74.skill:IsUnlock() then
		return false
	end

	if arg0_74.skill:IsMaxLevel() then
		return false
	end

	local var0_74 = arg0_74.skill:GetUpgradeMaterial()
	local var1_74 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	return _.all(var0_74, function(arg0_75)
		return var1_74:GetOwnCount(arg0_75.id) >= arg0_75.count
	end)
end

function var0_0.GetVaildStatusByGroup(arg0_76, arg1_76)
	return _.select(arg0_76.status, function(arg0_77)
		return not arg0_77:IsExpiration() and arg0_77:GetGroup() == arg1_76
	end)
end

function var0_0.GetVaildStatus(arg0_78)
	return _.select(arg0_78.status, function(arg0_79)
		return not arg0_79:IsExpiration()
	end)
end

function var0_0.GetVaildStatusByType(arg0_80, arg1_80)
	return _.select(arg0_80.status, function(arg0_81)
		return not arg0_81:IsExpiration() and arg0_81:GetBuffType() == arg1_80
	end)
end

function var0_0.GetDisplayStatus(arg0_82)
	return _.select(arg0_82.status, function(arg0_83)
		return not arg0_83:IsExpiration() and arg0_83:CanDisplay()
	end)
end

function var0_0.GetFavoriteGift(arg0_84)
	return arg0_84:getConfig("gift_id")
end

function var0_0.IsFavoriteGift(arg0_85, arg1_85)
	local var0_85 = arg0_85:GetFavoriteGift()

	return _.any(var0_85, function(arg0_86)
		return arg0_86 == arg1_85
	end)
end

function var0_0.AddStatus(arg0_87, arg1_87)
	local var0_87 = _.detect(arg0_87.status, function(arg0_88)
		return arg0_88.id == arg1_87.id
	end)

	if var0_87 then
		table.removebyvalue(arg0_87.status, var0_87)
	end

	local var1_87 = arg0_87:GetVaildStatus()
	local var2_87 = arg1_87:GetDuelTypeList()
	local var3_87 = _.detect(var1_87, function(arg0_89)
		return table.contains(var2_87, arg0_89:GetGroup())
	end)

	if var3_87 then
		table.removebyvalue(arg0_87.status, var3_87)
	end

	local var4_87 = arg1_87:GetDuelIdList()
	local var5_87 = _.detect(var1_87, function(arg0_90)
		return table.contains(var4_87, arg0_90.id)
	end)

	if var5_87 then
		table.removebyvalue(arg0_87.status, var5_87)
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipAddBuff(arg0_87.id, arg1_87.id))
	table.insert(arg0_87.status, arg1_87)
end

function var0_0.CheckHasOwnDressByDressId(arg0_91, arg1_91)
	return arg0_91.hasOwnDressList[arg1_91] or false
end

function var0_0.GetDressUpData(arg0_92)
	return arg0_92.currentDressTypeDic
end

function var0_0.GetDressByType(arg0_93, arg1_93)
	return arg0_93.currentDressTypeDic[arg1_93]
end

function var0_0.GetAllOwnDressList(arg0_94)
	local var0_94 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var1_94 = {}

	for iter0_94, iter1_94 in pairs(var0_94:GetAllOwnDressDic() or {}) do
		if iter1_94.num > 0 and not arg0_94:CheckHasOwnDressByDressId(iter0_94) then
			table.insert(var1_94, iter0_94)
		end
	end

	return var1_94
end

function var0_0.GetALLHasSendToShipDress(arg0_95)
	local var0_95 = {}

	for iter0_95, iter1_95 in ipairs(arg0_95.hasOwnDressList or {}) do
		table.insert(var0_95, iter1_95.id)
	end

	return var0_95
end

function var0_0.GetHasSendToShipDressByType(arg0_96, arg1_96)
	local var0_96 = {}

	for iter0_96, iter1_96 in pairs(arg0_96.hasOwnDressList or {}) do
		if pg.island_dress_template[iter1_96.id].type == arg1_96 then
			table.insert(var0_96, iter1_96.id)
		end
	end

	return var0_96
end

function var0_0.SetDressIdOwned(arg0_97, arg1_97)
	table.insert(arg0_97.hasOwnDressList, IslandShipDressItem.New({
		color = 0,
		id = arg1_97,
		color_list = {}
	}))
end

function var0_0.ChangeDressColor(arg0_98, arg1_98)
	for iter0_98, iter1_98 in ipairs(arg0_98.hasOwnDressList) do
		if iter1_98.id == arg1_98.id then
			iter1_98:ChangeColor(arg1_98.color)

			return
		end
	end
end

return var0_0
