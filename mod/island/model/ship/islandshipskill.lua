local var0_0 = class("IslandShipSkill", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.level = arg1_1.level or 1
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

function var0_0.GetLastEffectIds(arg0_11)
	return arg0_11:getConfig("skill_effect")[arg0_11.level - 1] or {}
end

function var0_0.GetEffectIds(arg0_12)
	return arg0_12:getConfig("skill_effect")[arg0_12.level] or {}
end

function var0_0.GetUnlockShipEffectIds(arg0_13)
	if arg0_13.lock then
		return {}
	end

	return underscore.select(arg0_13:GetEffectIds(), function(arg0_14)
		return not IslandBuffType.IsGlobalType(pg.island_buff_template[arg0_14].buff_type)
	end)
end

function var0_0.GetEffectDesc(arg0_15)
	if arg0_15.lock then
		return ""
	end

	local var0_15 = Clone(arg0_15:getConfig("desc"))

	for iter0_15, iter1_15 in ipairs(arg0_15:getConfig("desc_add")) do
		var0_15 = string.gsub(var0_15, "$" .. iter0_15, iter1_15[arg0_15.level][1])
	end

	return var0_15
end

function var0_0.IsEffectiveInPlace(arg0_16, arg1_16)
	return underscore.any(arg0_16:GetEffectIds(), function(arg0_17)
		local var0_17 = pg.island_buff_template[arg0_17]

		if var0_17.buff_type == IslandBuffType.SHIP_POWER_RECOVER then
			return true
		end

		return IslandBuffType.IsLimitPlaceType(var0_17.buff_type) and table.contains(var0_17.type_use[1], arg1_16)
	end)
end

function var0_0.IsEffectiveInRest(arg0_18, arg1_18)
	return underscore.any(arg0_18:GetEffectIds(), function(arg0_19)
		local var0_19 = pg.island_buff_template[arg0_19]

		return IslandBuffType.IsLimitRestaurantType(var0_19.buff_type) and table.contains(var0_19.type_use[1], arg1_18)
	end)
end

function var0_0.IsAllEffectiveType(arg0_20)
	return underscore.any(arg0_20:GetEffectIds(), function(arg0_21)
		return pg.island_buff_template[arg0_21].buff_type == IslandBuffType.SHIP_ATTR
	end)
end

function var0_0.IsPlaceDefaultEffectiveType(arg0_22)
	return underscore.any(arg0_22:GetEffectIds(), function(arg0_23)
		return pg.island_buff_template[arg0_23].buff_type == IslandBuffType.SHIP_POWER_RECOVER
	end)
end

function var0_0.GetUpgradeMaterial(arg0_24)
	local var0_24 = arg0_24:getConfig("material")
	local var1_24 = {}

	for iter0_24, iter1_24 in ipairs(var0_24[arg0_24.level] or {}) do
		table.insert(var1_24, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_24[1],
			count = iter1_24[2]
		})
	end

	return var1_24
end

return var0_0
