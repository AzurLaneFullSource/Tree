local var0_0 = class("SpWeapon", import(".BaseVO"))

var0_0.type = DROP_TYPE_SPWEAPON
var0_0.CONFIRM_OP_DISCARD = 0
var0_0.CONFIRM_OP_EXCHANGE = 1

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.configId = arg1_1.id
end

function var0_0.CreateByNet(arg0_2)
	if arg0_2.template_id == 0 then
		return
	end

	local var0_2 = {
		uid = arg0_2.id,
		id = arg0_2.template_id,
		attr1 = arg0_2.attr_1,
		attr2 = arg0_2.attr_2,
		attrTemp1 = arg0_2.attr_temp_1,
		attrTemp2 = arg0_2.attr_temp_2,
		pt = arg0_2.pt
	}

	return var0_0.New(var0_2)
end

function var0_0.bindConfigTable(arg0_3)
	return pg.spweapon_data_statistics
end

function var0_0.GetUID(arg0_4)
	return arg0_4.uid
end

function var0_0.IsReal(arg0_5)
	return tobool(arg0_5:GetUID())
end

function var0_0.GetConfigID(arg0_6)
	return arg0_6.configId
end

function var0_0.GetOriginID(arg0_7)
	return arg0_7:getConfig("base") or arg0_7:GetConfigID()
end

function var0_0.IsImportant(arg0_8)
	return arg0_8:getConfig("important") == 2
end

function var0_0.IsUnique(arg0_9)
	return arg0_9:getConfig("unique") ~= 0
end

function var0_0.GetUniqueGroup(arg0_10)
	return arg0_10:getConfig("unique")
end

function var0_0.GetType(arg0_11)
	return arg0_11:getConfig("type")
end

function var0_0.GetName(arg0_12)
	return arg0_12:getConfig("name")
end

function var0_0.GetLevel(arg0_13)
	return arg0_13:getConfig("level")
end

function var0_0.GetTechTier(arg0_14)
	return arg0_14:getConfig("tech")
end

function var0_0.GetIconPath(arg0_15)
	return "SpWeapon/" .. arg0_15:getConfig("icon")
end

function var0_0.GetRarity(arg0_16)
	return arg0_16:getConfig("rarity")
end

function var0_0.GetPt(arg0_17)
	return arg0_17:IsReal() and arg0_17.pt or 0
end

function var0_0.SetPt(arg0_18, arg1_18)
	assert(arg1_18)

	arg0_18.pt = arg1_18 or 0
end

function var0_0.GetEffect(arg0_19)
	return arg0_19:getConfig("effect_id")
end

function var0_0.GetDisplayEffect(arg0_20)
	return arg0_20:getConfig("effect_id_display")
end

function var0_0.GetUpgradableSkillIds(arg0_21)
	return arg0_21:getConfig("skill_upgrade")
end

function var0_0.GetNextUpgradeID(arg0_22)
	return arg0_22:getConfig("next")
end

function var0_0.GetPrevUpgradeID(arg0_23)
	return arg0_23:getConfig("prev")
end

function var0_0.MigrateTo(arg0_24, arg1_24)
	local var0_24 = Clone(arg0_24)

	var0_24.id = arg1_24
	var0_24.configId = arg1_24
	var0_24.pt = 0

	return var0_24
end

function var0_0.GetLabel(arg0_25)
	return arg0_25:getConfig("label")
end

function var0_0.SetShipId(arg0_26, arg1_26)
	arg0_26.shipId = arg1_26
end

function var0_0.GetShipId(arg0_27)
	return arg0_27.shipId
end

function var0_0.GetSkill(arg0_28)
	local var0_28 = arg0_28:GetEffect()

	return var0_28 > 0 and getSkillConfig(var0_28) or nil
end

function var0_0.GetSkillInfo(arg0_29)
	local var0_29 = {
		lv = 1,
		skillId = arg0_29:GetDisplayEffect()
	}

	var0_29.unlock = var0_29.skillId == arg0_29:GetEffect()

	return var0_29
end

function var0_0.GetUpgradableSkillInfo(arg0_30)
	local var0_30 = 0
	local var1_30 = 1
	local var2_30 = false
	local var3_30 = arg0_30:GetShipId()

	if var3_30 then
		local var4_30 = getProxy(BayProxy):getShipById(var3_30)
		local var5_30, var6_30 = arg0_30:GetActiveUpgradableSkill(var4_30)

		if var5_30 then
			var0_30 = var5_30

			local var7_30 = var4_30 and var4_30.skills[var6_30]

			var1_30 = var7_30 and var7_30.level or var1_30
			var2_30 = true
		end
	end

	if var0_30 == 0 then
		local var8_30 = arg0_30:GetUpgradableSkillIds()[1]

		if var8_30 and var8_30[2] then
			var0_30 = var8_30[2]
			var2_30 = var8_30[1] ~= 0
		end
	end

	return {
		skillId = var0_30,
		lv = var1_30,
		unlock = var2_30
	}
end

function var0_0.GetActiveUpgradableSkill(arg0_31, arg1_31)
	for iter0_31, iter1_31 in ipairs(arg1_31:getSkillList()) do
		local var0_31, var1_31 = arg0_31:RemapSkillId(iter1_31)

		if var1_31 then
			return var0_31, iter1_31
		end
	end
end

function var0_0.RemapSkillId(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg0_32:GetUpgradableSkillIds()) do
		if iter1_32[1] == arg1_32 then
			return iter1_32[2], true
		end
	end

	return arg1_32, false
end

function var0_0.GetSkillGroup(arg0_33)
	return {
		arg0_33:GetSkillInfo(),
		(arg0_33:GetUpgradableSkillInfo())
	}
end

function var0_0.GetConfigAttributes(arg0_34)
	return {
		arg0_34:getConfig("value_1"),
		arg0_34:getConfig("value_2")
	}
end

function var0_0.GetAttributesRange(arg0_35)
	return {
		arg0_35:getConfig("value_1_random"),
		arg0_35:getConfig("value_2_random")
	}
end

function var0_0.GetAttributes(arg0_36)
	local var0_36 = arg0_36:GetConfigAttributes()

	if arg0_36:IsReal() then
		var0_36[1] = var0_36[1] + arg0_36.attr1
		var0_36[2] = var0_36[2] + arg0_36.attr2
	end

	return var0_36
end

function var0_0.GetBaseAttributes(arg0_37)
	return {
		arg0_37.attr1 or 0,
		arg0_37.attr2 or 0
	}
end

function var0_0.SetBaseAttributes(arg0_38, arg1_38)
	arg0_38.attr1 = arg1_38[1]
	arg0_38.attr2 = arg1_38[2]
end

function var0_0.GetAttributeOptions(arg0_39)
	return {
		arg0_39.attrTemp1 or 0,
		arg0_39.attrTemp2 or 0
	}
end

function var0_0.SetAttributeOptions(arg0_40, arg1_40)
	arg0_40.attrTemp1 = arg1_40[1]
	arg0_40.attrTemp2 = arg1_40[2]
end

function var0_0.GetPropertiesInfo(arg0_41)
	local var0_41 = {
		attrs = {}
	}
	local var1_41 = arg0_41:GetAttributes()

	table.insert(var0_41.attrs, {
		type = arg0_41:getConfig("attribute_1"),
		value = var1_41[1]
	})
	table.insert(var0_41.attrs, {
		type = arg0_41:getConfig("attribute_2"),
		value = var1_41[2]
	})

	var0_41.weapon = {
		sub = {}
	}
	var0_41.equipInfo = {
		sub = {}
	}

	local var2_41 = arg0_41:GetWearableShipTypes()

	var0_41.part = {
		var2_41,
		var2_41
	}

	return var0_41
end

function var0_0.GetWearableShipTypes(arg0_42)
	local var0_42 = arg0_42:getConfig("usability")

	if var0_42 and #var0_42 > 0 then
		return var0_42
	end

	return pg.spweapon_type[arg0_42:GetType()].ship_type
end

function var0_0.IsCraftable(arg0_43)
	return not arg0_43:IsUnCraftable() and arg0_43:GetUpgradeConfig().create_use_gold > 0
end

function var0_0.GetUpgradeConfig(arg0_44)
	local var0_44 = arg0_44:getConfig("upgrade_id")

	return pg.spweapon_upgrade[var0_44]
end

function var0_0.IsUnCraftable(arg0_45)
	return arg0_45:getConfig("uncraftable") == 1
end

function var0_0.CalculateHistoryPt(arg0_46, arg1_46)
	local var0_46 = _.reduce(arg0_46, 0, function(arg0_47, arg1_47)
		return arg0_47 + Item.getConfigData(arg1_47.id).usage_arg[1] * arg1_47.count
	end)

	return (_.reduce(arg1_46, var0_46, function(arg0_48, arg1_48)
		return arg0_48 + (0 + arg1_48:GetUpgradeConfig().upgrade_supply_pt)
	end))
end

return var0_0
