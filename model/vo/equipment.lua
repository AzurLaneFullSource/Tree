local var0 = class("Equipment", import(".BaseVO"))

var0.EQUIPMENT_STATE_LOCK = 1
var0.EQUIPMENT_STATE_EMPTY = 0
var0.EQUIPMENT_NORMAL = 1
var0.EQUIPMENT_IMPORTANCE = 2

local var1 = pg.equip_skin_template

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.config_id or arg0.id

	arg0:InitConfig()

	arg0.count = defaultValue(arg1.count, 0)
	arg0.new = defaultValue(arg1.new, 0)
	arg0.isSkin = defaultValue(arg1.isSkin, false)
	arg0.skinId = arg1.skinId or 0
end

function var0.getConfigData(arg0)
	local var0 = {
		pg.equip_data_statistics,
		pg.equip_data_template
	}
	local var1

	if underscore.any(var0, function(arg0)
		return arg0[arg0] ~= nil
	end) then
		var1 = setmetatable({}, {
			__index = function(arg0, arg1)
				for iter0, iter1 in ipairs(var0) do
					if iter1[arg0] and iter1[arg0][arg1] ~= nil then
						arg0[arg1] = iter1[arg0][arg1]

						return arg0[arg1]
					end
				end
			end
		})

		local var2 = var1.weapon_id

		if var2 and #var2 > 0 then
			local var3 = pg.weapon_property[var2[1]]

			var1[AttributeType.CD] = var3 and var3.reload_max
		end
	end

	return var1
end

function var0.InitConfig(arg0)
	arg0.cfg = var0.getConfigData(arg0.configId)

	if not IsUnityEditor then
		arg0.config = arg0.cfg
	end

	assert(arg0.cfg, string.format("without equip config from id_%d", arg0.id))
end

function var0.getConfigTable(arg0)
	return arg0.cfg
end

function var0.GetAttributes(arg0)
	local var0 = {}

	for iter0 = 1, 3 do
		local var1 = arg0:getConfig("attribute_" .. iter0)
		local var2 = arg0:getConfig("value_" .. iter0)

		var0[iter0] = var1 ~= nil and {
			type = var1,
			value = string.match(var2, "^[%d|\\.]+$") and tonumber(var2) or var2,
			auxBoost = arg0:isDevice()
		} or false
	end

	return var0
end

function var0.GetPropertyRate(arg0)
	return arg0:getConfig("property_rate")
end

function var0.CanInBag(arg0)
	return tobool(pg.equip_data_template[arg0])
end

function var0.vertify(arg0)
	local var0 = pg.equip_data_statistics[arg0.configId]
	local var1 = pg.equip_data_template[arg0.configId]

	if arg0:getConfig("value_1") ~= var0.value_1 or arg0:getConfig("value_2") ~= var0.value_2 then
		return false
	end

	return true
end

function var0.CalcWeanponCD(arg0, arg1)
	local var0 = arg0 or 0
	local var1 = arg1 and arg1:getProperties().reload or 100

	return string.format("%0.2f", ys.Battle.BattleFormulas.CalculateReloadTime(var0, var1))
end

local var2 = {
	attribute_cd = "cd_normal",
	equip_info_34 = "equip_info_33"
}
local var3

local function var4(arg0)
	if not var3 then
		var3 = {}

		for iter0, iter1 in pairs(var2) do
			var3[i18n(iter0)] = i18n(iter1)
		end
	end

	return var3[arg0]
end

function var0.GetInfoTrans(arg0, arg1)
	local var0 = arg0.name
	local var1 = arg0.value
	local var2 = arg0.auxBoost

	if arg0.type == AttributeType.CD then
		var1 = var0.CalcWeanponCD(var1, arg1) .. "s" .. pg.equip_data_code.WAVE.text
	elseif arg0.type == AttributeType.AirDurability then
		local var3 = arg1 and arg1.level or 100

		var1 = math.floor(var1[1] + var1[2] * (var3 - 1) / 1000)
	elseif arg0.type == AttributeType.AntiSiren then
		var1 = math.floor(var1 / 100)
		var1 = (var1 > 0 and "+" or var1 < 0 and "-" or "") .. var1 .. "%"
	end

	var0 = var0 or AttributeType.Type2Name(arg0.type)

	if not arg1 then
		var0 = defaultValue(var4(var0), var0)
	end

	var1 = var1 or ""
	var2 = var2 and arg1 and table.contains(arg1:getSpecificType(), ShipType.SpecificTypeTable.auxiliary)

	return var0, var1, var2
end

local function var5(arg0)
	local var0 = pg.equip_data_code.WAVE.text

	if string.match(arg0, var0) then
		arg0 = string.gsub(arg0, var0, "")
	end

	arg0 = string.gsub(arg0, " ", "")

	local var1 = {
		string.match(arg0, "~(%d+)")
	}

	if #var1 > 0 then
		arg0 = string.gsub(arg0, "~" .. var1[1], "")
	end

	local var2 = {
		string.match(arg0, "(%d+)x(%d+)")
	}

	while #var2 > 0 do
		local var3 = var2[1]
		local var4 = var2[2]

		arg0 = string.gsub(arg0, var3 .. "x" .. var4, var3 * var4, 1)
		var2 = {
			string.match(arg0, "(%d+)x(%d+)")
		}
	end

	return tonumber(arg0)
end

function var0.AlignAttrs(arg0, arg1)
	for iter0 = 1, #arg0 do
		if not arg1[iter0] or arg0[iter0].type ~= arg1[iter0].type then
			table.insert(arg1, iter0, Clone(arg0[iter0]))

			arg1[iter0].value = 0

			for iter1 = iter0 + 1, #arg1 do
				if arg1[iter0].type == arg1[iter1].type then
					arg1[iter0].value = arg1[iter1].value

					table.remove(arg1, iter1)

					break
				end
			end
		end
	end

	for iter2 = #arg0 + 1, #arg1 do
		table.insert(arg0, Clone(arg1[iter2]))

		arg0[iter2].value = 0
	end
end

function var0.CompareInfo(arg0, arg1, arg2)
	if arg0.type == AttributeType.Damage then
		local var0 = var5(arg0.value)

		arg1.compare = var5(arg1.value) - var0
	elseif arg0.type == AttributeType.CD then
		local var1 = var0.CalcWeanponCD(arg0.value, arg2)

		arg1.compare = -(var0.CalcWeanponCD(arg1.value, arg2) - var1)
	else
		arg1.compare = arg1.value - arg0.value
	end
end

function var0.InsertAttrsUpgrade(arg0, arg1, arg2)
	var0.AlignAttrs(arg0, arg1)

	for iter0 = #arg0, 1, -1 do
		if arg0[iter0].value == arg1[iter0].value then
			if not arg2 then
				table.remove(arg0, iter0)
				table.remove(arg1, iter0)
			end
		else
			arg0[iter0].nextValue = arg1[iter0].value
		end
	end
end

function var0.InsertAttrsCompare(arg0, arg1, arg2)
	var0.AlignAttrs(arg0, arg1)

	for iter0 = 1, #arg0 do
		var0.CompareInfo(arg0[iter0], arg1[iter0], arg2)
	end
end

function var0.GetPropertiesInfo(arg0)
	local var0 = {
		attrs = {}
	}

	if arg0:getConfig(AttributeType.Damage) then
		table.insert(var0.attrs, {
			type = AttributeType.Damage,
			value = arg0:getConfig(AttributeType.Damage)
		})
	end

	if arg0:getConfig(AttributeType.CD) then
		local var1 = {
			type = AttributeType.CD,
			value = arg0:getConfig(AttributeType.CD)
		}

		table.insert(var0.attrs, var1)

		if arg0:isAircraftExtend() and arg0:getConfig("weapon_id") then
			var1.sub = {}

			for iter0, iter1 in ipairs(arg0:getConfig("weapon_id")) do
				if pg.weapon_property[iter1].type == 11 then
					table.insert(var1.sub, {
						name = i18n("equip_info_34"),
						type = AttributeType.CD,
						value = pg.weapon_property[iter1].reload_max
					})
				end
			end
		end
	end

	for iter2, iter3 in ipairs(arg0:GetAttributes()) do
		if iter3 and iter3.type ~= AttributeType.OxyRaidDistance then
			table.insert(var0.attrs, iter3)
		end
	end

	if arg0:GetAntiSirenPower() then
		table.insert(var0.attrs, {
			type = AttributeType.AntiSiren,
			value = arg0:GetAntiSirenPower()
		})
	end

	local var2 = arg0:GetSonarProperty()

	if var2 then
		table.insert(var0.attrs, {
			type = AttributeType.SonarRange,
			value = var2[AttributeType.SonarRange]
		})
	end

	var0.weapon = {
		lock_open = true,
		name = i18n(arg0:isAircraftExtend() and "equip_info_24" or "equip_info_5"),
		sub = {}
	}

	for iter4, iter5 in ipairs(arg0:getConfig("ammo_info")) do
		table.insert(var0.weapon.sub, arg0:GetWeaponPageInfo(iter5[1], iter5[2]))
	end

	var0.equipInfo = {
		name = i18n("equip_info_14"),
		sub = {}
	}

	for iter6, iter7 in ipairs(arg0:getConfig("equip_info")) do
		table.insert(var0.equipInfo.sub, arg0:GetEquipAttrPageInfo(iter7))
	end

	var0.part = {
		arg0:getConfig("part_main"),
		arg0:getConfig("part_sub")
	}
	var0.equipmentType = arg0:getConfig("type")

	return var0
end

function var0.GetWeaponPageInfo(arg0, arg1, arg2)
	local var0
	local var1 = pg.equip_bullet_type[arg1]
	local var2 = var1.exhibition_type == 2

	for iter0, iter1 in ipairs(var1.exhibition_list) do
		if not var0 then
			var0 = arg0:GetWeaponInfo(iter1, arg2, var2)
			var0.sub = {}
		else
			table.insert(var0.sub, arg0:GetWeaponInfo(iter1, arg2, var2))
		end
	end

	return var0
end

function var0.GetWeaponInfo(arg0, arg1, arg2, arg3)
	local var0 = arg3 and pg.weapon_property[arg2].bullet_ID[1] or arg2

	return switch(arg1, {
		function()
			return {
				name = i18n("equip_ammo_type_" .. arg0:getConfig(AttributeType.Ammo))
			}
		end,
		function()
			return {
				name = pg.weapon_name[arg2].name
			}
		end,
		function()
			return {
				type = AttributeType.Damage,
				value = pg.weapon_property[arg2].damage
			}
		end,
		function()
			return {
				name = i18n("equip_info_6"),
				value = pg.bullet_template[var0].velocity
			}
		end,
		function()
			return {
				name = i18n("equip_info_7"),
				value = pg.bullet_template[var0].velocity
			}
		end,
		function()
			local var0 = pg.bullet_template[var0].damage_type

			return {
				name = i18n("equip_info_8"),
				value = var0[1] * 100 .. "-" .. var0[2] * 100 .. "-" .. var0[3] * 100
			}
		end,
		function()
			return {
				name = i18n("equip_info_9"),
				value = pg.bullet_template[var0].hit_type.range
			}
		end,
		function()
			return {
				name = i18n("equip_info_10"),
				value = pg.weapon_property[arg2].range
			}
		end,
		function()
			return {
				name = i18n("equip_info_11"),
				value = pg.weapon_property[arg2].angle
			}
		end,
		function()
			return {
				name = i18n("equip_info_12"),
				value = (pg.bullet_template[var0].extra_param.randomOffsetX or "0") .. "*" .. (pg.bullet_template[var0].extra_param.randomOffsetZ or "0")
			}
		end,
		function()
			return {
				name = i18n("equip_info_13"),
				value = arg0:getConfig(AttributeType.Speciality)
			}
		end,
		function()
			return {
				type = AttributeType.CD,
				value = pg.weapon_property[arg2].reload_max
			}
		end,
		function()
			return {
				name = i18n("attribute_max_distance_damage"),
				value = (1 - pg.bullet_template[var0].hit_type.decay) * 100 .. "%"
			}
		end
	})
end

local var6 = {
	nil,
	nil,
	true,
	true,
	true,
	[13] = true
}

function var0.GetEquipAttrPageInfo(arg0, arg1)
	local var0
	local var1

	if type(arg1) == "table" then
		var0, var1 = arg1[1], arg1[2]
	else
		var0, var1 = arg1, arg0:getConfig("weapon_id")[1]
	end

	assert(tobool(var6[var0]) == (type(arg1) == "table"), "equip attr sid type error from equip:" .. arg0.id)

	return arg0:GetEquipAttrInfo(var0, var1)
end

function var0.GetEquipAttrInfo(arg0, arg1, arg2)
	return switch(arg1, {
		function()
			local var0 = pg.weapon_property[arg2]

			return {
				name = i18n("equip_info_15"),
				value = var0.min_range == 0 and var0.range or var0.min_range .. "-" .. var0.range
			}
		end,
		function()
			return {
				name = i18n("equip_info_16"),
				value = pg.weapon_property[arg2].angle
			}
		end,
		function()
			local var0 = pg.bullet_template[arg2]

			return {
				name = i18n("equip_info_17"),
				value = var0.range - var0.range_offset .. "-" .. var0.range + var0.range_offset
			}
		end,
		function()
			local var0 = pg.barrage_template[arg2]

			return {
				name = i18n("equip_info_18"),
				value = var0.random_angle and var0.angle or math.abs(var0.delta_angle) * var0.primal_repeat
			}
		end,
		function()
			return {
				name = i18n("attribute_scatter"),
				value = pg.bullet_template[arg2].extra_param.randomOffsetX
			}
		end,
		function()
			return {
				name = i18n("equip_info_19"),
				value = Nation.Nation2Name(arg0:getConfig("nationality"))
			}
		end,
		function()
			local var0 = pg.aircraft_template[arg0.id]

			return {
				name = i18n("equip_info_20"),
				value = var0.speed
			}
		end,
		function()
			local var0 = pg.aircraft_template[arg0.id]

			return {
				name = i18n("equip_info_21"),
				type = AttributeType.AirDurability,
				value = {
					var0.max_hp,
					var0.hp_growth
				}
			}
		end,
		function()
			local var0 = pg.aircraft_template[arg0.id]

			return {
				name = i18n("equip_info_22"),
				value = var0.dodge_limit
			}
		end,
		function()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return {
					name = i18n("equip_info_28"),
					type = AttributeType.Corrected,
					value = EquipmentRarity.Rarity2CorrectedLevel(arg0:getConfig("rarity"), arg0:getConfig("level"))
				}
			else
				return {
					name = i18n("equip_info_28"),
					type = AttributeType.Corrected,
					value = pg.weapon_property[arg2].corrected .. "%"
				}
			end
		end,
		function()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return nil
			else
				local var0 = {
					AttributeType.Cannon,
					AttributeType.Torpedo,
					AttributeType.AntiAircraft,
					AttributeType.Air,
					AttributeType.AntiSub
				}

				return {
					name = i18n("equip_info_29"),
					value = AttributeType.Type2Name(var0[pg.weapon_property[arg2].attack_attribute])
				}
			end
		end,
		function()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return nil
			else
				return {
					name = i18n("equip_info_30"),
					value = pg.weapon_property[arg2].attack_attribute_ratio .. "%"
				}
			end
		end,
		function()
			local var0 = pg.bullet_template[arg2]

			return {
				name = i18n("equip_info_32"),
				value = math.abs(var0.extra_param.aim_offset)
			}
		end
	})
end

function var0.GetGearScore(arg0)
	local var0 = arg0:getConfig("rarity")
	local var1 = arg0:getConfig("level")

	assert(pg.equip_data_by_quality[var0], "equip_data_by_quality not exist: " .. var0)

	local var2 = pg.equip_data_by_quality[var0]

	return var2.gear_score + var1 * var2.gear_score_addition
end

function var0.GetSkill(arg0)
	local var0
	local var1 = arg0:getConfig("skill_id")[1]

	if var1 then
		var0 = getSkillConfig(var1)
	end

	return var0
end

function var0.GetWeaponID(arg0)
	return arg0:getConfig("weapon_id")
end

function var0.GetSonarProperty(arg0)
	local var0 = arg0:getConfig("equip_parameters").range

	if var0 then
		return {
			[AttributeType.SonarRange] = var0
		}
	else
		return nil
	end
end

function var0.GetAntiSirenPower(arg0)
	return arg0:getConfig("anti_siren")
end

function var0.canUpgrade(arg0)
	return var0.getConfigData(arg0).next ~= 0
end

function var0.hasPrevLevel(arg0)
	return arg0:getConfig("prev") ~= 0
end

function var0.getRevertAwards(arg0)
	local var0 = {}
	local var1 = 0
	local var2 = arg0

	while var2:hasPrevLevel() do
		var2 = Equipment.New({
			id = var2:getConfig("prev")
		})

		for iter0, iter1 in ipairs(var2:getConfig("trans_use_item")) do
			table.insert(var0, Drop.New({
				type = DROP_TYPE_ITEM,
				id = iter1[1],
				count = iter1[2]
			}))
		end

		var1 = var1 + var2:getConfig("trans_use_gold")
	end

	local var3 = PlayerConst.MergeSameDrops(var0)

	if var1 > 0 then
		table.insert(var3, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = var1
		}))
	end

	return var3
end

function var0.canEquipSkin(arg0)
	local var0 = arg0:getConfig("type")

	return pg.equip_data_by_type[var0].equip_skin == 1
end

function var0.getType(arg0)
	return arg0:getConfig("type")
end

function var0.hasSkin(arg0)
	return arg0.skinId and arg0.skinId ~= 0
end

function var0.setSkinId(arg0, arg1)
	arg0.skinId = arg1
end

function var0.getSkinId(arg0)
	return arg0.skinId
end

function var0.hasSkinOrbit(arg0)
	if not arg0:hasSkin() then
		return false
	end

	return var0.IsOrbitSkin(arg0.skinId)
end

function var0.IsOrbitSkin(arg0)
	local var0 = var1[arg0]

	if var0.orbit_combat ~= "" or var0.orbit_ui ~= "" then
		return true
	else
		return false
	end
end

function var0.isImportance(arg0)
	return arg0:getConfig("important") == var0.EQUIPMENT_IMPORTANCE
end

function var0.isUnique(arg0)
	return arg0:getConfig("equip_limit") ~= 0
end

function var0.isDevice(arg0)
	local var0 = arg0:getConfig("type")

	return underscore.any(EquipType.DeviceEquipTypes, function(arg0)
		return arg0 == var0
	end)
end

function var0.isAircraft(arg0)
	local var0 = arg0:getConfig("type")

	return underscore.any(EquipType.AirEquipTypes, function(arg0)
		return arg0 == var0
	end)
end

function var0.isAircraftExtend(arg0)
	local var0 = arg0:getConfig("type")

	return underscore.any(EquipType.AirExtendEquipTypes, function(arg0)
		return arg0 == var0
	end)
end

function var0.MigrateTo(arg0, arg1)
	assert(not arg0.isSkin)

	return Equipment.New({
		id = arg1,
		config_id = arg1,
		count = arg0.count
	})
end

function var0.GetRootEquipment(arg0)
	local var0 = var0.getConfigData(arg0.configId)

	while var0.prev > 0 do
		var0 = var0.getConfigData(var0.prev)
	end

	local var1 = arg0:MigrateTo(var0.id)

	var1.count = 1

	return var1
end

function var0.getNation(arg0)
	return arg0:getConfig("nationality")
end

function var0.GetEquipRootStatic(arg0)
	local var0 = var0.getConfigData(arg0)

	while var0.prev > 0 do
		var0 = var0.getConfigData(var0.prev)
	end

	return var0.id
end

function var0.GetRevertRewardsStatic(arg0)
	local var0 = {}
	local var1 = var0.getConfigData(arg0)

	while var1.prev > 0 do
		var1 = var0.getConfigData(var1.prev)

		for iter0, iter1 in ipairs(var1.trans_use_item) do
			var0[iter1[1]] = (var0[iter1[1]] or 0) + iter1[2]
		end

		var0.gold = (var0.gold or 0) + var1.trans_use_gold
	end

	return var0
end

function var0.GetEquipReloadStatic(arg0)
	local var0 = var0.getConfigData(arg0).weapon_id

	if var0 and #var0 > 0 then
		local var1 = pg.weapon_property[var0[1]]

		if var1 then
			return var1.reload_max
		end
	end
end

function var0.GetEquipComposeCfgStatic(arg0)
	local var0 = pg.compose_data_template

	for iter0, iter1 in ipairs(var0.all) do
		local var1 = var0[iter1]
		local var2 = true

		for iter2, iter3 in pairs(arg0) do
			var2 = var2 and var1[iter2] == iter3
		end

		if var2 then
			return var1
		end
	end
end

return var0
