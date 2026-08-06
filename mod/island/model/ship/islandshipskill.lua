local var0_0 = class("IslandShipSkill", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.level = arg1_1.level or 1
	arg0_1.isUsedToday = defaultValue(arg1_1.isUseToday, false)
	arg0_1.maxLevel = 1

	arg0_1:InitMaxLevel()

	arg0_1.lock = true
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_chara_skill
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("name")
end

function var0_0.GetIcon(arg0_4)
	return arg0_4:getConfig("icon")
end

function var0_0.Unlock(arg0_5)
	arg0_5.lock = false

	if arg0_5.level <= 0 then
		arg0_5.level = 1
	end
end

function var0_0.IsUnlock(arg0_6)
	return not arg0_6.lock
end

function var0_0.GetLevel(arg0_7)
	return arg0_7.level
end

function var0_0.IsMaxLevel(arg0_8)
	return arg0_8.level >= arg0_8.maxLevel
end

function var0_0.InitMaxLevel(arg0_9)
	arg0_9.maxLevel = #arg0_9:getConfig("skill_effect")
end

function var0_0.Upgrade(arg0_10)
	if arg0_10:IsMaxLevel() then
		return
	end

	arg0_10.level = arg0_10.level + 1
end

function var0_0.IsGreetingType(arg0_11)
	return underscore.any(arg0_11:GetEffectIds(), function(arg0_12)
		local var0_12 = pg.island_buff_template[arg0_12]

		return IslandBuffType.IsGreetingType(var0_12.buff_type)
	end)
end

local function var1_0(arg0_13, arg1_13, arg2_13)
	if arg2_13.buff_type == IslandBuffType.SHIP_POWER_RECOVER_BY_GREETING then
		local function var0_13()
			local var0_14 = arg1_13:GetCurrentEnergy()
			local var1_14 = arg2_13.type_use[1]
			local var2_14 = arg2_13.type_use[2]

			return var0_14 <= var1_14
		end

		return not arg0_13 and var0_13()
	elseif arg2_13.buff_type == IslandBuffType.SHIP_AWARD_BY_GREETING then
		return not arg0_13
	else
		return true
	end
end

function var0_0.CanUse4Ship(arg0_15, arg1_15, arg2_15)
	return underscore.any(arg0_15:GetEffectIds(), function(arg0_16)
		local var0_16 = pg.island_buff_template[arg0_16]

		return table.contains(arg2_15, var0_16.buff_type) and var1_0(arg0_15.isUsedToday, arg1_15, var0_16)
	end)
end

function var0_0.Apply(arg0_17, arg1_17, arg2_17)
	if arg2_17 == IslandBuffType.SHIP_POWER_RECOVER_BY_GREETING then
		for iter0_17, iter1_17 in ipairs(arg0_17:GetEffectIds()) do
			local var0_17 = pg.island_buff_template[iter1_17]

			if var0_17.buff_type == arg2_17 then
				local var1_17 = var0_17.type_use[1]
				local var2_17 = var0_17.type_use[2]
				local var3_17 = arg1_17:GetEnergy()

				arg1_17:UpdateEnergy(var3_17 + var2_17)
				arg0_17:UpdateUsedToday(true)
			end
		end
	elseif arg2_17 == IslandBuffType.SHIP_AWARD_BY_GREETING then
		arg0_17:UpdateUsedToday(true)
	end
end

function var0_0.UpdateUsedToday(arg0_18, arg1_18)
	arg0_18.isUsedToday = arg1_18
end

function var0_0.GetLastEffectIds(arg0_19)
	return arg0_19:getConfig("skill_effect")[arg0_19.level - 1] or {}
end

function var0_0.GetEffectIds(arg0_20)
	return arg0_20:getConfig("skill_effect")[arg0_20.level] or {}
end

function var0_0.GetUnlockShipEffectIds(arg0_21)
	if arg0_21.lock then
		return {}
	end

	return underscore.select(arg0_21:GetEffectIds(), function(arg0_22)
		return not IslandBuffType.IsGlobalType(pg.island_buff_template[arg0_22].buff_type)
	end)
end

function var0_0.GetEffectDesc(arg0_23)
	if arg0_23.lock then
		return ""
	end

	local var0_23 = Clone(arg0_23:getConfig("desc"))

	for iter0_23, iter1_23 in ipairs(arg0_23:getConfig("desc_add")) do
		var0_23 = string.gsub(var0_23, "$" .. iter0_23, iter1_23[arg0_23.level][1])
	end

	return var0_23
end

function var0_0.IsEffectiveInPlace(arg0_24, arg1_24)
	return underscore.any(arg0_24:GetEffectIds(), function(arg0_25)
		local var0_25 = pg.island_buff_template[arg0_25]

		if var0_25.buff_type == IslandBuffType.SHIP_POWER_RECOVER then
			return true
		end

		return IslandBuffType.IsLimitPlaceType(var0_25.buff_type) and table.contains(var0_25.type_use[1], arg1_24)
	end)
end

function var0_0.IsEffectiveInRest(arg0_26, arg1_26)
	return underscore.any(arg0_26:GetEffectIds(), function(arg0_27)
		local var0_27 = pg.island_buff_template[arg0_27]

		return IslandBuffType.IsLimitRestaurantType(var0_27.buff_type) and table.contains(var0_27.type_use[1], arg1_26)
	end)
end

function var0_0.IsAllEffectiveType(arg0_28)
	return underscore.any(arg0_28:GetEffectIds(), function(arg0_29)
		return pg.island_buff_template[arg0_29].buff_type == IslandBuffType.SHIP_ATTR
	end)
end

function var0_0.IsPlaceDefaultEffectiveType(arg0_30)
	return underscore.any(arg0_30:GetEffectIds(), function(arg0_31)
		return pg.island_buff_template[arg0_31].buff_type == IslandBuffType.SHIP_POWER_RECOVER
	end)
end

function var0_0.GetUpgradeMaterial(arg0_32)
	local var0_32 = arg0_32:getConfig("material")
	local var1_32 = {}

	for iter0_32, iter1_32 in ipairs(var0_32[arg0_32.level] or {}) do
		table.insert(var1_32, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_32[1],
			count = iter1_32[2]
		})
	end

	return var1_32
end

return var0_0
