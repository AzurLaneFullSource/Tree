local var0 = class("CardPuzzleShip", BaseVO)

function var0.getShipArmor(arg0)
	return arg0:getConfig("armor")
end

function var0.getShipArmorName(arg0)
	local var0 = arg0:getShipArmor()

	return ArmorType.Type2Name(var0)
end

function var0.getGroupId(arg0)
	return pg.ship_data_template[arg0.configId].group_type
end

function var0.getGroupIdByConfigId(arg0)
	return math.floor(arg0 / 10)
end

function var0.getShipType(arg0)
	return pg.ship_data_statistics[arg0.configId].type
end

function var0.getNation(arg0)
	assert(false)
end

function var0.getPaintingName(arg0)
	local var0 = pg.ship_data_statistics[arg0].skin_id
	local var1 = pg.ship_skin_template[var0]

	assert(var1, "ship_skin_template not exist: " .. arg0 .. " " .. var0)

	return var1.painting
end

function var0.getName(arg0)
	return pg.ship_data_statistics[arg0.configId].name
end

function var0.getShipName(arg0)
	return pg.ship_data_statistics[arg0].name
end

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.template_id or arg1.configId
	arg0.level = arg1.level
	arg0.exp = arg1.exp

	if arg1.name and arg1.name ~= "" then
		arg0.name = arg1.name
	else
		assert(pg.ship_data_statistics[arg0.configId], "必须存在配置" .. arg0.configId)

		arg0.name = pg.ship_data_statistics[arg0.configId].name
	end

	arg0.equipmentSkins = {}
	arg0.equipments = {}

	if arg1.equip_info_list then
		for iter0, iter1 in ipairs(arg1.equip_info_list or {}) do
			arg0.equipments[iter0] = iter1.id > 0 and Equipment.New({
				count = 1,
				id = iter1.id,
				config_id = iter1.id,
				skinId = iter1.skinId
			}) or false
			arg0.equipmentSkins[iter0] = iter1.skinId > 0 and iter1.skinId or 0

			arg0:reletiveEquipSkin(iter0)
		end
	end

	arg0.skills = {}

	for iter2, iter3 in ipairs(arg1.skill_id_list or {}) do
		arg0:updateSkill(iter3)
	end

	arg0.star = arg0:getConfig("rarity")
	arg0.transforms = {}

	if not HXSet.isHxSkin() then
		arg0.skinId = arg1.skin_id or 0
	else
		arg0.skinId = 0
	end

	if arg0.skinId == 0 then
		arg0.skinId = arg0:getConfig("skin_id")
	end
end

function var0.getActiveEquipments(arg0)
	local var0 = Clone(arg0.equipments)

	for iter0 = #var0, 1, -1 do
		local var1 = var0[iter0]

		if var1 then
			for iter1 = 1, iter0 - 1 do
				local var2 = var0[iter1]

				if var2 and var1:getConfig("equip_limit") ~= 0 and var2:getConfig("equip_limit") == var1:getConfig("equip_limit") then
					var0[iter0] = false
				end
			end
		end
	end

	return var0
end

function var0.getAllEquipments(arg0)
	return arg0.equipments
end

function var0.updateSkinId(arg0, arg1)
	arg0.skinId = arg1
end

function var0.getPrefab(arg0)
	local var0 = arg0.skinId
	local var1 = pg.ship_skin_template[var0]

	assert(var1, "ship_skin_template not exist: " .. arg0.configId .. " " .. var0)

	return var1.prefab
end

function var0.getPainting(arg0)
	local var0 = pg.ship_skin_template[arg0.skinId]

	assert(var0, "ship_skin_template not exist: " .. arg0.configId .. " " .. arg0.skinId)

	return var0.painting
end

function var0.GetSkinConfig(arg0)
	local var0 = pg.ship_skin_template[arg0.skinId]

	assert(var0, "ship_skin_template not exist: " .. arg0.configId .. " " .. arg0.skinId)

	return var0
end

function var0.updateEquip(arg0, arg1, arg2)
	assert(arg2 == nil or arg2.count == 1)

	local var0 = arg0.equipments[arg1]

	arg0.equipments[arg1] = arg2 and Clone(arg2) or false
end

function var0.getEquip(arg0, arg1)
	return Clone(arg0.equipments[arg1])
end

function var0.bindConfigTable(arg0)
	return pg.puzzle_ship_template
end

function var0.isAvaiable(arg0)
	return true
end

var0.PROPERTIES = {
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
var0.DIVE_PROPERTIES = {
	AttributeType.OxyMax,
	AttributeType.OxyCost,
	AttributeType.OxyRecovery,
	AttributeType.OxyRecoveryBench,
	AttributeType.OxyAttackDuration,
	AttributeType.OxyRaidDistance
}
var0.SONAR_PROPERTIES = {
	AttributeType.SonarRange
}

function var0.getShipProperties(arg0)
	return (arg0:getBaseProperties())
end

function var0.getBaseProperties(arg0)
	local var0 = arg0:getConfigTable()

	assert(var0, "配置表没有这艘船" .. arg0.configId)

	local var1 = {}

	for iter0, iter1 in ipairs(var0.PROPERTIES) do
		var1[iter1] = var0[iter1]
	end

	for iter2, iter3 in ipairs(var0.DIVE_PROPERTIES) do
		var1[iter3] = 0
	end

	for iter4, iter5 in ipairs(var0.SONAR_PROPERTIES) do
		var1[iter5] = 0
	end

	return var1
end

function var0.getGiftProperties(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(var0.PROPERTIES) do
		var0[iter1] = 0
	end

	for iter2, iter3 in ipairs(var0.DIVE_PROPERTIES) do
		var0[iter3] = 0
	end

	for iter4, iter5 in ipairs(var0.SONAR_PROPERTIES) do
		var0[iter5] = 0
	end

	for iter6, iter7 in ipairs(arg1) do
		if iter7 then
			local var1 = iter7:GetAttributeBonus(arg0)

			for iter8, iter9 in ipairs(var1) do
				if iter9 and var0[iter9.type] then
					var0[iter9.type] = var0[iter9.type] + iter9.value
				end
			end
		end
	end

	return var0
end

function var0.getProperties(arg0, arg1)
	local var0 = arg0:getShipProperties()
	local var1 = arg0:getGiftProperties(arg1)

	for iter0, iter1 in ipairs(var0.PROPERTIES) do
		if iter1 == AttributeType.Speed then
			var0[iter1] = var0[iter1] + var1[iter1]
		else
			var0[iter1] = calcFloor(var0[iter1] + var1[iter1])
		end
	end

	for iter2, iter3 in ipairs(var0.DIVE_PROPERTIES) do
		var0[iter3] = var0[iter3] + var1[iter3]
	end

	for iter4, iter5 in ipairs(var0.SONAR_PROPERTIES) do
		var0[iter5] = var0[iter5] + var1[iter5]
	end

	return var0
end

function var0.getTriggerSkills(arg0)
	local var0 = {}
	local var1 = arg0:getSkillEffects()

	_.each(var1, function(arg0)
		if arg0.type == "AddBuff" and arg0.arg_list and arg0.arg_list.buff_id then
			local var0 = arg0.arg_list.buff_id

			var0[var0] = {
				id = var0,
				level = arg0.level
			}
		end
	end)

	return var0
end

function var0.GetEquipmentSkills(arg0)
	local var0 = {}
	local var1 = arg0:getActiveEquipments()

	for iter0, iter1 in ipairs(var1) do
		if iter1 then
			local var2 = iter1:getConfig("skill_id")[1]

			if var2 then
				var0[var2] = {
					level = 1,
					id = var2
				}
			end
		end
	end

	return var0
end

function var0.getAllSkills(arg0)
	local var0 = Clone(arg0.skills)

	for iter0, iter1 in pairs(arg0:GetEquipmentSkills()) do
		var0[iter0] = iter1
	end

	for iter2, iter3 in pairs(arg0:getTriggerSkills()) do
		var0[iter2] = iter3
	end

	return var0
end

function var0.getRarity(arg0)
	assert(false)
end

function var0.getExchangePrice(arg0)
	assert(false)
end

function var0.upgrade(arg0)
	assert(false)
end

function var0.getTeamType(arg0)
	return TeamType.GetTeamFromShipType(arg0:getShipType())
end

function var0.getMaxConfigId(arg0)
	local var0 = pg.ship_data_template
	local var1

	for iter0 = 4, 1, -1 do
		local var2 = tonumber(arg0.groupId .. iter0)

		if var0[var2] then
			var1 = var2

			break
		end
	end

	return var1
end

function var0.fateSkillChange(arg0, arg1)
	if not arg0.skillChangeList then
		arg0.skillChangeList = arg0:isBluePrintShip() and arg0:getBluePrint():getChangeSkillList() or {}
	end

	for iter0, iter1 in ipairs(arg0.skillChangeList) do
		if iter1[1] == arg1 and arg0.skills[iter1[2]] then
			return iter1[2]
		end
	end

	return arg1
end

function var0.getSkillList(arg0)
	local var0 = pg.ship_data_template[arg0.configId]
	local var1 = Clone(var0.buff_list_display)
	local var2 = Clone(var0.buff_list)
	local var3 = pg.ship_data_trans[arg0.groupId]
	local var4 = 0

	if var3 and var3.skill_id ~= 0 then
		local var5 = var3.skill_id
		local var6 = pg.transform_data_template[var5]

		if arg0.transforms[var5] and var6.skill_id ~= 0 then
			table.insert(var2, var6.skill_id)
		end
	end

	local var7 = {}

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in ipairs(var2) do
			if iter1 == iter3 then
				table.insert(var7, arg0:fateSkillChange(iter1))
			end
		end
	end

	return var7
end

function var0.getDisplaySkillIds(arg0)
	return _.map(pg.ship_data_template[arg0.configId].buff_list_display, function(arg0)
		return arg0:fateSkillChange(arg0)
	end)
end

function var0.getSkillIndex(arg0, arg1)
	local var0 = arg0:getSkillList()

	for iter0, iter1 in ipairs(var0) do
		if arg1 == iter1 then
			return iter0
		end
	end
end

function var0.IsBgmSkin(arg0)
	local var0 = arg0:GetSkinConfig()

	return table.contains(var0.tag, ShipSkin.WITH_BGM)
end

function var0.GetSkinBgm(arg0)
	if arg0:IsBgmSkin() then
		return arg0:GetSkinConfig().bgm
	end
end

function var0.GetConfigId(arg0)
	return arg0.configId
end

function var0.GetDefaultCards(arg0)
	return arg0:getConfig("default_card")
end

return var0
