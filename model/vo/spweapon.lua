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

function var0_0.GetUniqueShips(arg0_11)
	local var0_11 = arg0_11:GetUniqueGroup()

	return getProxy(BayProxy):findShipsByGroup(var0_11)
end

function var0_0.GetType(arg0_12)
	return arg0_12:getConfig("type")
end

function var0_0.GetName(arg0_13)
	return arg0_13:getConfig("name")
end

function var0_0.GetLevel(arg0_14)
	return arg0_14:getConfig("level")
end

function var0_0.GetTechTier(arg0_15)
	return arg0_15:getConfig("tech")
end

function var0_0.GetIconPath(arg0_16)
	return "SpWeapon/" .. arg0_16:getConfig("icon")
end

function var0_0.GetRarity(arg0_17)
	return arg0_17:getConfig("rarity")
end

function var0_0.GetPt(arg0_18)
	return arg0_18:IsReal() and arg0_18.pt or 0
end

function var0_0.SetPt(arg0_19, arg1_19)
	assert(arg1_19)

	arg0_19.pt = arg1_19 or 0
end

function var0_0.GetEffect(arg0_20)
	return arg0_20:getConfig("effect_id")
end

function var0_0.GetDisplayEffect(arg0_21)
	return arg0_21:getConfig("effect_id_display")
end

function var0_0.GetUpgradableSkillIds(arg0_22)
	return arg0_22:getConfig("skill_upgrade")
end

function var0_0.GetUpgradableHiddenSkillIds(arg0_23)
	return arg0_23:getConfig("hide_buff_upgrade")
end

function var0_0.GetNextUpgradeID(arg0_24)
	return arg0_24:getConfig("next")
end

function var0_0.GetPrevUpgradeID(arg0_25)
	return arg0_25:getConfig("prev")
end

function var0_0.MigrateTo(arg0_26, arg1_26)
	local var0_26 = Clone(arg0_26)

	var0_26.id = arg1_26
	var0_26.configId = arg1_26
	var0_26.pt = 0

	return var0_26
end

function var0_0.GetLabel(arg0_27)
	return arg0_27:getConfig("label")
end

function var0_0.SetShipId(arg0_28, arg1_28)
	arg0_28.shipId = arg1_28
end

function var0_0.GetShipId(arg0_29)
	return arg0_29.shipId
end

function var0_0.GetSkill(arg0_30)
	local var0_30 = arg0_30:GetEffect()

	return var0_30 > 0 and getSkillConfig(var0_30) or nil
end

function var0_0.GetSkillInfo(arg0_31)
	local var0_31 = {
		lv = 1,
		skillId = arg0_31:GetDisplayEffect()
	}

	var0_31.unlock = var0_31.skillId == arg0_31:GetEffect()

	local var1_31 = arg0_31:GetShipId()

	if not var1_31 or var1_31 == 0 then
		var0_31.descTrigger = true
	end

	return var0_31
end

function var0_0.GetUpgradableSkillInfo(arg0_32)
	local var0_32 = arg0_32:GetShipId()
	local var1_32 = {}
	local var2_32
	local var3_32

	if var0_32 then
		var2_32 = getProxy(BayProxy):getShipById(var0_32)
		var3_32 = arg0_32:GetActiveUpgradableSkillList(var2_32)
	end

	for iter0_32, iter1_32 in ipairs(arg0_32:GetUpgradableSkillIds()) do
		local var4_32 = iter1_32[2]
		local var5_32 = 1
		local var6_32 = false

		if var2_32 then
			for iter2_32, iter3_32 in ipairs(var3_32) do
				if iter3_32.mapSkillID == iter1_32[2] and iter3_32.originalSkillID == iter1_32[1] then
					local var7_32 = var2_32.skills[iter3_32.originalSkillID]

					var5_32 = var7_32 and var7_32.level or 1
					var6_32 = true

					break
				end
			end
		else
			var6_32 = var6_32 or iter1_32[1] ~= 0
		end

		table.insert(var1_32, {
			skillId = var4_32,
			lv = var5_32,
			unlock = var6_32,
			descTrigger = not var2_32 or nil
		})
	end

	return var1_32
end

function var0_0.GetActiveUpgradableSkillList(arg0_33, arg1_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in ipairs(arg1_33:getSkillList()) do
		local var1_33, var2_33 = arg0_33:RemapSkillId(iter1_33)

		if var2_33 then
			table.insert(var0_33, {
				mapSkillID = var1_33,
				originalSkillID = iter1_33
			})
		end
	end

	local var3_33 = pg.ship_data_template[arg1_33.configId].hide_buff_list

	for iter2_33, iter3_33 in ipairs(var3_33) do
		local var4_33, var5_33 = arg0_33:RemapSkillId(iter3_33)

		if var5_33 then
			table.insert(var0_33, {
				mapSkillID = var4_33,
				originalSkillID = iter3_33
			})
		end
	end

	return var0_33
end

function var0_0.RemapSkillId(arg0_34, arg1_34)
	for iter0_34, iter1_34 in ipairs(arg0_34:GetUpgradableSkillIds()) do
		if iter1_34[1] == arg1_34 then
			return iter1_34[2], true
		end
	end

	return arg1_34, false
end

function var0_0.RemapHiddenSkillId(arg0_35, arg1_35)
	for iter0_35, iter1_35 in ipairs(arg0_35:GetUpgradableHiddenSkillIds()) do
		if iter1_35[1] == arg1_35 then
			return iter1_35[2], true
		end
	end

	return arg1_35, false
end

function var0_0.GetSkillGroup(arg0_36)
	return {
		arg0_36:GetSkillInfo(),
		(arg0_36:GetUpgradableSkillInfo())
	}
end

function var0_0.GetConfigAttributes(arg0_37)
	return {
		arg0_37:getConfig("value_1"),
		arg0_37:getConfig("value_2")
	}
end

function var0_0.GetAttributesRange(arg0_38)
	return {
		arg0_38:getConfig("value_1_random"),
		arg0_38:getConfig("value_2_random")
	}
end

function var0_0.GetAttributes(arg0_39)
	local var0_39 = arg0_39:GetConfigAttributes()

	if arg0_39:IsReal() then
		var0_39[1] = var0_39[1] + arg0_39.attr1
		var0_39[2] = var0_39[2] + arg0_39.attr2
	end

	return var0_39
end

function var0_0.GetBaseAttributes(arg0_40)
	return {
		arg0_40.attr1 or 0,
		arg0_40.attr2 or 0
	}
end

function var0_0.SetBaseAttributes(arg0_41, arg1_41)
	arg0_41.attr1 = arg1_41[1]
	arg0_41.attr2 = arg1_41[2]
end

function var0_0.GetAttributeOptions(arg0_42)
	return {
		arg0_42.attrTemp1 or 0,
		arg0_42.attrTemp2 or 0
	}
end

function var0_0.SetAttributeOptions(arg0_43, arg1_43)
	arg0_43.attrTemp1 = arg1_43[1]
	arg0_43.attrTemp2 = arg1_43[2]
end

function var0_0.GetPropertiesInfo(arg0_44)
	local var0_44 = {
		attrs = {}
	}
	local var1_44 = arg0_44:GetAttributes()

	table.insert(var0_44.attrs, {
		type = arg0_44:getConfig("attribute_1"),
		value = var1_44[1]
	})
	table.insert(var0_44.attrs, {
		type = arg0_44:getConfig("attribute_2"),
		value = var1_44[2]
	})

	var0_44.weapon = {
		sub = {}
	}
	var0_44.equipInfo = {
		sub = {}
	}

	local var2_44 = arg0_44:GetWearableShipTypes()

	var0_44.part = {
		var2_44,
		var2_44
	}

	return var0_44
end

function var0_0.GetWearableShipTypes(arg0_45)
	local var0_45 = arg0_45:getConfig("usability")

	if var0_45 and #var0_45 > 0 then
		return var0_45
	end

	return pg.spweapon_type[arg0_45:GetType()].ship_type
end

function var0_0.IsCraftable(arg0_46)
	return not arg0_46:IsUnCraftable() and arg0_46:GetUpgradeConfig().create_use_gold > 0
end

function var0_0.GetUpgradeConfig(arg0_47)
	local var0_47 = arg0_47:getConfig("upgrade_id")

	return pg.spweapon_upgrade[var0_47]
end

function var0_0.IsUnCraftable(arg0_48)
	return arg0_48:getConfig("uncraftable") == 1
end

function var0_0.CalculateHistoryPt(arg0_49, arg1_49)
	local var0_49 = _.reduce(arg0_49, 0, function(arg0_50, arg1_50)
		return arg0_50 + Item.getConfigData(arg1_50.id).usage_arg[1] * arg1_50.count
	end)

	return (_.reduce(arg1_49, var0_49, function(arg0_51, arg1_51)
		return arg0_51 + (0 + arg1_51:GetUpgradeConfig().upgrade_supply_pt)
	end))
end

function var0_0.IsMatchKey(arg0_52, arg1_52)
	local var0_52 = {
		arg0_52:getConfig("name")
	}

	return EquipmentTools.IsMatchKey(var0_52, arg1_52)
end

return var0_0
