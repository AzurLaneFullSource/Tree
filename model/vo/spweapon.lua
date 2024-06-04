local var0 = class("SpWeapon", import(".BaseVO"))

var0.type = DROP_TYPE_SPWEAPON
var0.CONFIRM_OP_DISCARD = 0
var0.CONFIRM_OP_EXCHANGE = 1

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.configId = arg1.id
end

function var0.CreateByNet(arg0)
	if arg0.template_id == 0 then
		return
	end

	local var0 = {
		uid = arg0.id,
		id = arg0.template_id,
		attr1 = arg0.attr_1,
		attr2 = arg0.attr_2,
		attrTemp1 = arg0.attr_temp_1,
		attrTemp2 = arg0.attr_temp_2,
		pt = arg0.pt
	}

	return var0.New(var0)
end

function var0.bindConfigTable(arg0)
	return pg.spweapon_data_statistics
end

function var0.GetUID(arg0)
	return arg0.uid
end

function var0.IsReal(arg0)
	return tobool(arg0:GetUID())
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.GetOriginID(arg0)
	return arg0:getConfig("base") or arg0:GetConfigID()
end

function var0.IsImportant(arg0)
	return arg0:getConfig("important") == 2
end

function var0.IsUnique(arg0)
	return arg0:getConfig("unique") ~= 0
end

function var0.GetUniqueGroup(arg0)
	return arg0:getConfig("unique")
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetLevel(arg0)
	return arg0:getConfig("level")
end

function var0.GetTechTier(arg0)
	return arg0:getConfig("tech")
end

function var0.GetIconPath(arg0)
	return "SpWeapon/" .. arg0:getConfig("icon")
end

function var0.GetRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.GetPt(arg0)
	return arg0:IsReal() and arg0.pt or 0
end

function var0.SetPt(arg0, arg1)
	assert(arg1)

	arg0.pt = arg1 or 0
end

function var0.GetEffect(arg0)
	return arg0:getConfig("effect_id")
end

function var0.GetDisplayEffect(arg0)
	return arg0:getConfig("effect_id_display")
end

function var0.GetUpgradableSkillIds(arg0)
	return arg0:getConfig("skill_upgrade")
end

function var0.GetNextUpgradeID(arg0)
	return arg0:getConfig("next")
end

function var0.GetPrevUpgradeID(arg0)
	return arg0:getConfig("prev")
end

function var0.MigrateTo(arg0, arg1)
	local var0 = Clone(arg0)

	var0.id = arg1
	var0.configId = arg1
	var0.pt = 0

	return var0
end

function var0.GetLabel(arg0)
	return arg0:getConfig("label")
end

function var0.SetShipId(arg0, arg1)
	arg0.shipId = arg1
end

function var0.GetShipId(arg0)
	return arg0.shipId
end

function var0.GetSkill(arg0)
	local var0 = arg0:GetEffect()

	return var0 > 0 and getSkillConfig(var0) or nil
end

function var0.GetSkillInfo(arg0)
	local var0 = {
		lv = 1,
		skillId = arg0:GetDisplayEffect()
	}

	var0.unlock = var0.skillId == arg0:GetEffect()

	return var0
end

function var0.GetUpgradableSkillInfo(arg0)
	local var0 = 0
	local var1 = 1
	local var2 = false
	local var3 = arg0:GetShipId()

	if var3 then
		local var4 = getProxy(BayProxy):getShipById(var3)
		local var5, var6 = arg0:GetActiveUpgradableSkill(var4)

		if var5 then
			var0 = var5

			local var7 = var4 and var4.skills[var6]

			var1 = var7 and var7.level or var1
			var2 = true
		end
	end

	if var0 == 0 then
		local var8 = arg0:GetUpgradableSkillIds()[1]

		if var8 and var8[2] then
			var0 = var8[2]
			var2 = var8[1] ~= 0
		end
	end

	return {
		skillId = var0,
		lv = var1,
		unlock = var2
	}
end

function var0.GetActiveUpgradableSkill(arg0, arg1)
	for iter0, iter1 in ipairs(arg1:getSkillList()) do
		local var0, var1 = arg0:RemapSkillId(iter1)

		if var1 then
			return var0, iter1
		end
	end
end

function var0.RemapSkillId(arg0, arg1)
	for iter0, iter1 in ipairs(arg0:GetUpgradableSkillIds()) do
		if iter1[1] == arg1 then
			return iter1[2], true
		end
	end

	return arg1, false
end

function var0.GetSkillGroup(arg0)
	return {
		arg0:GetSkillInfo(),
		(arg0:GetUpgradableSkillInfo())
	}
end

function var0.GetConfigAttributes(arg0)
	return {
		arg0:getConfig("value_1"),
		arg0:getConfig("value_2")
	}
end

function var0.GetAttributesRange(arg0)
	return {
		arg0:getConfig("value_1_random"),
		arg0:getConfig("value_2_random")
	}
end

function var0.GetAttributes(arg0)
	local var0 = arg0:GetConfigAttributes()

	if arg0:IsReal() then
		var0[1] = var0[1] + arg0.attr1
		var0[2] = var0[2] + arg0.attr2
	end

	return var0
end

function var0.GetBaseAttributes(arg0)
	return {
		arg0.attr1 or 0,
		arg0.attr2 or 0
	}
end

function var0.SetBaseAttributes(arg0, arg1)
	arg0.attr1 = arg1[1]
	arg0.attr2 = arg1[2]
end

function var0.GetAttributeOptions(arg0)
	return {
		arg0.attrTemp1 or 0,
		arg0.attrTemp2 or 0
	}
end

function var0.SetAttributeOptions(arg0, arg1)
	arg0.attrTemp1 = arg1[1]
	arg0.attrTemp2 = arg1[2]
end

function var0.GetPropertiesInfo(arg0)
	local var0 = {
		attrs = {}
	}
	local var1 = arg0:GetAttributes()

	table.insert(var0.attrs, {
		type = arg0:getConfig("attribute_1"),
		value = var1[1]
	})
	table.insert(var0.attrs, {
		type = arg0:getConfig("attribute_2"),
		value = var1[2]
	})

	var0.weapon = {
		sub = {}
	}
	var0.equipInfo = {
		sub = {}
	}

	local var2 = arg0:GetWearableShipTypes()

	var0.part = {
		var2,
		var2
	}

	return var0
end

function var0.GetWearableShipTypes(arg0)
	local var0 = arg0:getConfig("usability")

	if var0 and #var0 > 0 then
		return var0
	end

	return pg.spweapon_type[arg0:GetType()].ship_type
end

function var0.IsCraftable(arg0)
	return not arg0:IsUnCraftable() and arg0:GetUpgradeConfig().create_use_gold > 0
end

function var0.GetUpgradeConfig(arg0)
	local var0 = arg0:getConfig("upgrade_id")

	return pg.spweapon_upgrade[var0]
end

function var0.IsUnCraftable(arg0)
	return arg0:getConfig("uncraftable") == 1
end

function var0.CalculateHistoryPt(arg0, arg1)
	local var0 = _.reduce(arg0, 0, function(arg0, arg1)
		return arg0 + Item.getConfigData(arg1.id).usage_arg[1] * arg1.count
	end)

	return (_.reduce(arg1, var0, function(arg0, arg1)
		return arg0 + (0 + arg1:GetUpgradeConfig().upgrade_supply_pt)
	end))
end

return var0
