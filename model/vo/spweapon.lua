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

function var0_0.GetUpgradableHiddenSkillIds(arg0_22)
	return arg0_22:getConfig("hide_buff_upgrade")
end

function var0_0.GetNextUpgradeID(arg0_23)
	return arg0_23:getConfig("next")
end

function var0_0.GetPrevUpgradeID(arg0_24)
	return arg0_24:getConfig("prev")
end

function var0_0.MigrateTo(arg0_25, arg1_25)
	local var0_25 = Clone(arg0_25)

	var0_25.id = arg1_25
	var0_25.configId = arg1_25
	var0_25.pt = 0

	return var0_25
end

function var0_0.GetLabel(arg0_26)
	return arg0_26:getConfig("label")
end

function var0_0.SetShipId(arg0_27, arg1_27)
	arg0_27.shipId = arg1_27
end

function var0_0.GetShipId(arg0_28)
	return arg0_28.shipId
end

function var0_0.GetSkill(arg0_29)
	local var0_29 = arg0_29:GetEffect()

	return var0_29 > 0 and getSkillConfig(var0_29) or nil
end

function var0_0.GetSkillInfo(arg0_30)
	local var0_30 = {
		lv = 1,
		skillId = arg0_30:GetDisplayEffect()
	}

	var0_30.unlock = var0_30.skillId == arg0_30:GetEffect()

	local var1_30 = arg0_30:GetShipId()

	if not var1_30 or var1_30 == 0 then
		var0_30.descTrigger = true
	end

	return var0_30
end

function var0_0.GetUpgradableSkillInfo(arg0_31)
	local var0_31 = arg0_31:GetShipId()
	local var1_31 = {}
	local var2_31
	local var3_31

	if var0_31 then
		var2_31 = getProxy(BayProxy):getShipById(var0_31)
		var3_31 = arg0_31:GetActiveUpgradableSkillList(var2_31)
	end

	for iter0_31, iter1_31 in ipairs(arg0_31:GetUpgradableSkillIds()) do
		local var4_31 = iter1_31[2]
		local var5_31 = 1
		local var6_31 = false

		if var2_31 then
			for iter2_31, iter3_31 in ipairs(var3_31) do
				if iter3_31.mapSkillID == iter1_31[2] and iter3_31.originalSkillID == iter1_31[1] then
					local var7_31 = var2_31.skills[iter3_31.originalSkillID]

					var5_31 = var7_31 and var7_31.level or 1
					var6_31 = true

					break
				end
			end
		else
			var6_31 = var6_31 or iter1_31[1] ~= 0
		end

		table.insert(var1_31, {
			skillId = var4_31,
			lv = var5_31,
			unlock = var6_31,
			descTrigger = not var2_31 or nil
		})
	end

	return var1_31
end

function var0_0.GetActiveUpgradableSkillList(arg0_32, arg1_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in ipairs(arg1_32:getSkillList()) do
		local var1_32, var2_32 = arg0_32:RemapSkillId(iter1_32)

		if var2_32 then
			table.insert(var0_32, {
				mapSkillID = var1_32,
				originalSkillID = iter1_32
			})
		end
	end

	local var3_32 = pg.ship_data_template[arg1_32.configId].hide_buff_list

	for iter2_32, iter3_32 in ipairs(var3_32) do
		local var4_32, var5_32 = arg0_32:RemapSkillId(iter3_32)

		if var5_32 then
			table.insert(var0_32, {
				mapSkillID = var4_32,
				originalSkillID = iter3_32
			})
		end
	end

	return var0_32
end

function var0_0.RemapSkillId(arg0_33, arg1_33)
	for iter0_33, iter1_33 in ipairs(arg0_33:GetUpgradableSkillIds()) do
		if iter1_33[1] == arg1_33 then
			return iter1_33[2], true
		end
	end

	return arg1_33, false
end

function var0_0.RemapHiddenSkillId(arg0_34, arg1_34)
	for iter0_34, iter1_34 in ipairs(arg0_34:GetUpgradableHiddenSkillIds()) do
		if iter1_34[1] == arg1_34 then
			return iter1_34[2], true
		end
	end

	return arg1_34, false
end

function var0_0.GetSkillGroup(arg0_35)
	return {
		arg0_35:GetSkillInfo(),
		(arg0_35:GetUpgradableSkillInfo())
	}
end

function var0_0.GetConfigAttributes(arg0_36)
	return {
		arg0_36:getConfig("value_1"),
		arg0_36:getConfig("value_2")
	}
end

function var0_0.GetAttributesRange(arg0_37)
	return {
		arg0_37:getConfig("value_1_random"),
		arg0_37:getConfig("value_2_random")
	}
end

function var0_0.GetAttributes(arg0_38)
	local var0_38 = arg0_38:GetConfigAttributes()

	if arg0_38:IsReal() then
		var0_38[1] = var0_38[1] + arg0_38.attr1
		var0_38[2] = var0_38[2] + arg0_38.attr2
	end

	return var0_38
end

function var0_0.GetBaseAttributes(arg0_39)
	return {
		arg0_39.attr1 or 0,
		arg0_39.attr2 or 0
	}
end

function var0_0.SetBaseAttributes(arg0_40, arg1_40)
	arg0_40.attr1 = arg1_40[1]
	arg0_40.attr2 = arg1_40[2]
end

function var0_0.GetAttributeOptions(arg0_41)
	return {
		arg0_41.attrTemp1 or 0,
		arg0_41.attrTemp2 or 0
	}
end

function var0_0.SetAttributeOptions(arg0_42, arg1_42)
	arg0_42.attrTemp1 = arg1_42[1]
	arg0_42.attrTemp2 = arg1_42[2]
end

function var0_0.GetPropertiesInfo(arg0_43)
	local var0_43 = {
		attrs = {}
	}
	local var1_43 = arg0_43:GetAttributes()

	table.insert(var0_43.attrs, {
		type = arg0_43:getConfig("attribute_1"),
		value = var1_43[1]
	})
	table.insert(var0_43.attrs, {
		type = arg0_43:getConfig("attribute_2"),
		value = var1_43[2]
	})

	var0_43.weapon = {
		sub = {}
	}
	var0_43.equipInfo = {
		sub = {}
	}

	local var2_43 = arg0_43:GetWearableShipTypes()

	var0_43.part = {
		var2_43,
		var2_43
	}

	return var0_43
end

function var0_0.GetWearableShipTypes(arg0_44)
	local var0_44 = arg0_44:getConfig("usability")

	if var0_44 and #var0_44 > 0 then
		return var0_44
	end

	return pg.spweapon_type[arg0_44:GetType()].ship_type
end

function var0_0.IsCraftable(arg0_45)
	return not arg0_45:IsUnCraftable() and arg0_45:GetUpgradeConfig().create_use_gold > 0
end

function var0_0.GetUpgradeConfig(arg0_46)
	local var0_46 = arg0_46:getConfig("upgrade_id")

	return pg.spweapon_upgrade[var0_46]
end

function var0_0.IsUnCraftable(arg0_47)
	return arg0_47:getConfig("uncraftable") == 1
end

function var0_0.CalculateHistoryPt(arg0_48, arg1_48)
	local var0_48 = _.reduce(arg0_48, 0, function(arg0_49, arg1_49)
		return arg0_49 + Item.getConfigData(arg1_49.id).usage_arg[1] * arg1_49.count
	end)

	return (_.reduce(arg1_48, var0_48, function(arg0_50, arg1_50)
		return arg0_50 + (0 + arg1_50:GetUpgradeConfig().upgrade_supply_pt)
	end))
end

function var0_0.IsMatchKey(arg0_51, arg1_51)
	local var0_51 = {
		arg0_51:getConfig("name")
	}

	return EquipmentTools.IsMatchKey(var0_51, arg1_51)
end

return var0_0
