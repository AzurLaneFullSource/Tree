local var0_0 = class("CardPuzzleShip", BaseVO)

function var0_0.getShipArmor(arg0_1)
	return arg0_1:getConfig("armor")
end

function var0_0.getShipArmorName(arg0_2)
	local var0_2 = arg0_2:getShipArmor()

	return ArmorType.Type2Name(var0_2)
end

function var0_0.getGroupId(arg0_3)
	return pg.ship_data_template[arg0_3.configId].group_type
end

function var0_0.getGroupIdByConfigId(arg0_4)
	return math.floor(arg0_4 / 10)
end

function var0_0.getShipType(arg0_5)
	return pg.ship_data_statistics[arg0_5.configId].type
end

function var0_0.getNation(arg0_6)
	assert(false)
end

function var0_0.getPaintingName(arg0_7)
	local var0_7 = pg.ship_data_statistics[arg0_7].skin_id
	local var1_7 = pg.ship_skin_template[var0_7]

	assert(var1_7, "ship_skin_template not exist: " .. arg0_7 .. " " .. var0_7)

	return var1_7.painting
end

function var0_0.getName(arg0_8)
	return pg.ship_data_statistics[arg0_8.configId].name
end

function var0_0.getShipName(arg0_9)
	return pg.ship_data_statistics[arg0_9].name
end

function var0_0.Ctor(arg0_10, arg1_10)
	arg0_10.configId = arg1_10.template_id or arg1_10.configId
	arg0_10.level = arg1_10.level
	arg0_10.exp = arg1_10.exp

	if arg1_10.name and arg1_10.name ~= "" then
		arg0_10.name = arg1_10.name
	else
		assert(pg.ship_data_statistics[arg0_10.configId], "必须存在配置" .. arg0_10.configId)

		arg0_10.name = pg.ship_data_statistics[arg0_10.configId].name
	end

	arg0_10.equipmentSkins = {}
	arg0_10.equipments = {}

	if arg1_10.equip_info_list then
		for iter0_10, iter1_10 in ipairs(arg1_10.equip_info_list or {}) do
			arg0_10.equipments[iter0_10] = iter1_10.id > 0 and Equipment.New({
				count = 1,
				id = iter1_10.id,
				config_id = iter1_10.id,
				skinId = iter1_10.skinId
			}) or false
			arg0_10.equipmentSkins[iter0_10] = iter1_10.skinId > 0 and iter1_10.skinId or 0

			arg0_10:reletiveEquipSkin(iter0_10)
		end
	end

	arg0_10.skills = {}

	for iter2_10, iter3_10 in ipairs(arg1_10.skill_id_list or {}) do
		arg0_10:updateSkill(iter3_10)
	end

	arg0_10.star = arg0_10:getConfig("rarity")
	arg0_10.transforms = {}

	if not HXSet.isHxSkin() then
		arg0_10.skinId = arg1_10.skin_id or 0
	else
		arg0_10.skinId = 0
	end

	if arg0_10.skinId == 0 then
		arg0_10.skinId = arg0_10:getConfig("skin_id")
	end
end

function var0_0.getActiveEquipments(arg0_11)
	local var0_11 = Clone(arg0_11.equipments)

	for iter0_11 = #var0_11, 1, -1 do
		local var1_11 = var0_11[iter0_11]

		if var1_11 then
			for iter1_11 = 1, iter0_11 - 1 do
				local var2_11 = var0_11[iter1_11]

				if var2_11 and var1_11:getConfig("equip_limit") ~= 0 and var2_11:getConfig("equip_limit") == var1_11:getConfig("equip_limit") then
					var0_11[iter0_11] = false
				end
			end
		end
	end

	return var0_11
end

function var0_0.getAllEquipments(arg0_12)
	return arg0_12.equipments
end

function var0_0.updateSkinId(arg0_13, arg1_13)
	arg0_13.skinId = arg1_13
end

function var0_0.getPrefab(arg0_14)
	local var0_14 = arg0_14.skinId
	local var1_14 = pg.ship_skin_template[var0_14]

	assert(var1_14, "ship_skin_template not exist: " .. arg0_14.configId .. " " .. var0_14)

	return var1_14.prefab
end

function var0_0.getPainting(arg0_15)
	local var0_15 = pg.ship_skin_template[arg0_15.skinId]

	assert(var0_15, "ship_skin_template not exist: " .. arg0_15.configId .. " " .. arg0_15.skinId)

	return var0_15.painting
end

function var0_0.GetSkinConfig(arg0_16)
	local var0_16 = pg.ship_skin_template[arg0_16.skinId]

	assert(var0_16, "ship_skin_template not exist: " .. arg0_16.configId .. " " .. arg0_16.skinId)

	return var0_16
end

function var0_0.updateEquip(arg0_17, arg1_17, arg2_17)
	assert(arg2_17 == nil or arg2_17.count == 1)

	local var0_17 = arg0_17.equipments[arg1_17]

	arg0_17.equipments[arg1_17] = arg2_17 and Clone(arg2_17) or false
end

function var0_0.getEquip(arg0_18, arg1_18)
	return Clone(arg0_18.equipments[arg1_18])
end

function var0_0.bindConfigTable(arg0_19)
	return pg.puzzle_ship_template
end

function var0_0.isAvaiable(arg0_20)
	return true
end

var0_0.PROPERTIES = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.AntiSub,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.Armor,
	AttributeType.Hit,
	AttributeType.Speed,
	AttributeType.Dodge,
	AttributeType.Luck
}
var0_0.DIVE_PROPERTIES = {
	AttributeType.OxyMax,
	AttributeType.OxyCost,
	AttributeType.OxyRecovery,
	AttributeType.OxyRecoveryBench,
	AttributeType.OxyAttackDuration,
	AttributeType.OxyRaidDistance
}
var0_0.SONAR_PROPERTIES = {
	AttributeType.SonarRange
}

function var0_0.getShipProperties(arg0_21)
	return (arg0_21:getBaseProperties())
end

function var0_0.getBaseProperties(arg0_22)
	local var0_22 = arg0_22:getConfigTable()

	assert(var0_22, "配置表没有这艘船" .. arg0_22.configId)

	local var1_22 = {}

	for iter0_22, iter1_22 in ipairs(var0_0.PROPERTIES) do
		var1_22[iter1_22] = var0_22[iter1_22]
	end

	for iter2_22, iter3_22 in ipairs(var0_0.DIVE_PROPERTIES) do
		var1_22[iter3_22] = 0
	end

	for iter4_22, iter5_22 in ipairs(var0_0.SONAR_PROPERTIES) do
		var1_22[iter5_22] = 0
	end

	return var1_22
end

function var0_0.getGiftProperties(arg0_23, arg1_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(var0_0.PROPERTIES) do
		var0_23[iter1_23] = 0
	end

	for iter2_23, iter3_23 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_23[iter3_23] = 0
	end

	for iter4_23, iter5_23 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_23[iter5_23] = 0
	end

	for iter6_23, iter7_23 in ipairs(arg1_23) do
		if iter7_23 then
			local var1_23 = iter7_23:GetAttributeBonus(arg0_23)

			for iter8_23, iter9_23 in ipairs(var1_23) do
				if iter9_23 and var0_23[iter9_23.type] then
					var0_23[iter9_23.type] = var0_23[iter9_23.type] + iter9_23.value
				end
			end
		end
	end

	return var0_23
end

function var0_0.getProperties(arg0_24, arg1_24)
	local var0_24 = arg0_24:getShipProperties()
	local var1_24 = arg0_24:getGiftProperties(arg1_24)

	for iter0_24, iter1_24 in ipairs(var0_0.PROPERTIES) do
		if iter1_24 == AttributeType.Speed then
			var0_24[iter1_24] = var0_24[iter1_24] + var1_24[iter1_24]
		else
			var0_24[iter1_24] = calcFloor(var0_24[iter1_24] + var1_24[iter1_24])
		end
	end

	for iter2_24, iter3_24 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_24[iter3_24] = var0_24[iter3_24] + var1_24[iter3_24]
	end

	for iter4_24, iter5_24 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_24[iter5_24] = var0_24[iter5_24] + var1_24[iter5_24]
	end

	return var0_24
end

function var0_0.getTriggerSkills(arg0_25)
	local var0_25 = {}
	local var1_25 = arg0_25:getSkillEffects()

	_.each(var1_25, function(arg0_26)
		if arg0_26.type == "AddBuff" and arg0_26.arg_list and arg0_26.arg_list.buff_id then
			local var0_26 = arg0_26.arg_list.buff_id

			var0_25[var0_26] = {
				id = var0_26,
				level = arg0_26.level
			}
		end
	end)

	return var0_25
end

function var0_0.GetEquipmentSkills(arg0_27)
	local var0_27 = {}
	local var1_27 = arg0_27:getActiveEquipments()

	for iter0_27, iter1_27 in ipairs(var1_27) do
		if iter1_27 then
			local var2_27 = iter1_27:getConfig("skill_id")[1]

			if var2_27 then
				var0_27[var2_27] = {
					level = 1,
					id = var2_27
				}
			end
		end
	end

	return var0_27
end

function var0_0.getAllSkills(arg0_28)
	local var0_28 = Clone(arg0_28.skills)

	for iter0_28, iter1_28 in pairs(arg0_28:GetEquipmentSkills()) do
		var0_28[iter0_28] = iter1_28
	end

	for iter2_28, iter3_28 in pairs(arg0_28:getTriggerSkills()) do
		var0_28[iter2_28] = iter3_28
	end

	return var0_28
end

function var0_0.getRarity(arg0_29)
	assert(false)
end

function var0_0.getExchangePrice(arg0_30)
	assert(false)
end

function var0_0.upgrade(arg0_31)
	assert(false)
end

function var0_0.getTeamType(arg0_32)
	return TeamType.GetTeamFromShipType(arg0_32:getShipType())
end

function var0_0.getMaxConfigId(arg0_33)
	local var0_33 = pg.ship_data_template
	local var1_33

	for iter0_33 = 4, 1, -1 do
		local var2_33 = tonumber(arg0_33.groupId .. iter0_33)

		if var0_33[var2_33] then
			var1_33 = var2_33

			break
		end
	end

	return var1_33
end

function var0_0.fateSkillChange(arg0_34, arg1_34)
	if not arg0_34.skillChangeList then
		arg0_34.skillChangeList = arg0_34:isBluePrintShip() and arg0_34:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_34, iter1_34 in ipairs(arg0_34.skillChangeList) do
		if iter1_34[1] == arg1_34 and arg0_34.skills[iter1_34[2]] then
			return iter1_34[2]
		end
	end

	return arg1_34
end

function var0_0.getSkillList(arg0_35)
	local var0_35 = pg.ship_data_template[arg0_35.configId]
	local var1_35 = Clone(var0_35.buff_list_display)
	local var2_35 = Clone(var0_35.buff_list)
	local var3_35 = pg.ship_data_trans[arg0_35.groupId]
	local var4_35 = 0

	if var3_35 and var3_35.skill_id ~= 0 then
		local var5_35 = var3_35.skill_id
		local var6_35 = pg.transform_data_template[var5_35]

		if arg0_35.transforms[var5_35] and var6_35.skill_id ~= 0 then
			table.insert(var2_35, var6_35.skill_id)
		end
	end

	local var7_35 = {}

	for iter0_35, iter1_35 in ipairs(var1_35) do
		for iter2_35, iter3_35 in ipairs(var2_35) do
			if iter1_35 == iter3_35 then
				table.insert(var7_35, arg0_35:fateSkillChange(iter1_35))
			end
		end
	end

	return var7_35
end

function var0_0.getDisplaySkillIds(arg0_36)
	return _.map(pg.ship_data_template[arg0_36.configId].buff_list_display, function(arg0_37)
		return arg0_36:fateSkillChange(arg0_37)
	end)
end

function var0_0.getSkillIndex(arg0_38, arg1_38)
	local var0_38 = arg0_38:getSkillList()

	for iter0_38, iter1_38 in ipairs(var0_38) do
		if arg1_38 == iter1_38 then
			return iter0_38
		end
	end
end

function var0_0.IsBgmSkin(arg0_39)
	local var0_39 = arg0_39:GetSkinConfig()

	return table.contains(var0_39.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_40)
	if arg0_40:IsBgmSkin() then
		return arg0_40:GetSkinConfig().bgm
	end
end

function var0_0.GetConfigId(arg0_41)
	return arg0_41.configId
end

function var0_0.GetDefaultCards(arg0_42)
	return arg0_42:getConfig("default_card")
end

return var0_0
