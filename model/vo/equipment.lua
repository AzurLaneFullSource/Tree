local var0_0 = class("Equipment", import(".BaseVO"))

var0_0.EQUIPMENT_STATE_LOCK = 1
var0_0.EQUIPMENT_STATE_EMPTY = 0
var0_0.EQUIPMENT_NORMAL = 1
var0_0.EQUIPMENT_IMPORTANCE = 2

local var1_0 = pg.equip_skin_template

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.config_id or arg0_1.id

	arg0_1:InitConfig()

	arg0_1.count = defaultValue(arg1_1.count, 0)
	arg0_1.new = defaultValue(arg1_1.new, 0)
	arg0_1.isSkin = defaultValue(arg1_1.isSkin, false)
	arg0_1.skinId = arg1_1.skinId or 0
end

function var0_0.getConfigData(arg0_2)
	local var0_2 = {
		pg.equip_data_statistics,
		pg.equip_data_template
	}
	local var1_2

	if underscore.any(var0_2, function(arg0_3)
		return arg0_3[arg0_2] ~= nil
	end) then
		var1_2 = setmetatable({}, {
			__index = function(arg0_4, arg1_4)
				for iter0_4, iter1_4 in ipairs(var0_2) do
					if iter1_4[arg0_2] and iter1_4[arg0_2][arg1_4] ~= nil then
						arg0_4[arg1_4] = iter1_4[arg0_2][arg1_4]

						return arg0_4[arg1_4]
					end
				end
			end
		})

		local var2_2 = var1_2.weapon_id

		if var2_2 and #var2_2 > 0 then
			local var3_2 = pg.weapon_property[var2_2[1]]

			var1_2[AttributeType.CD] = var3_2 and var3_2.reload_max
		end
	end

	return var1_2
end

function var0_0.InitConfig(arg0_5)
	arg0_5.cfg = var0_0.getConfigData(arg0_5.configId)

	if not IsUnityEditor then
		arg0_5.config = arg0_5.cfg
	end

	assert(arg0_5.cfg, string.format("without equip config from id_%d", arg0_5.id))
end

function var0_0.getConfigTable(arg0_6)
	return arg0_6.cfg
end

function var0_0.GetAttributes(arg0_7)
	local var0_7 = {}

	for iter0_7 = 1, 3 do
		local var1_7 = arg0_7:getConfig("attribute_" .. iter0_7)
		local var2_7 = arg0_7:getConfig("value_" .. iter0_7)

		var0_7[iter0_7] = var1_7 ~= nil and {
			type = var1_7,
			value = string.match(var2_7, "^[%d|\\.]+$") and tonumber(var2_7) or var2_7,
			auxBoost = arg0_7:isDevice()
		} or false
	end

	return var0_7
end

function var0_0.GetPropertyRate(arg0_8)
	return arg0_8:getConfig("property_rate")
end

function var0_0.CanInBag(arg0_9)
	return tobool(pg.equip_data_template[arg0_9])
end

function var0_0.vertify(arg0_10)
	local var0_10 = pg.equip_data_statistics[arg0_10.configId]
	local var1_10 = pg.equip_data_template[arg0_10.configId]

	if arg0_10:getConfig("value_1") ~= var0_10.value_1 or arg0_10:getConfig("value_2") ~= var0_10.value_2 then
		return false
	end

	return true
end

function var0_0.CalcWeanponCD(arg0_11, arg1_11)
	local var0_11 = arg0_11 or 0
	local var1_11 = arg1_11 and arg1_11:getProperties().reload or 100

	return string.format("%0.2f", ys.Battle.BattleFormulas.CalculateReloadTime(var0_11, var1_11))
end

local var2_0 = {
	attribute_cd = "cd_normal",
	equip_info_34 = "equip_info_33"
}
local var3_0

local function var4_0(arg0_12)
	if not var3_0 then
		var3_0 = {}

		for iter0_12, iter1_12 in pairs(var2_0) do
			var3_0[i18n(iter0_12)] = i18n(iter1_12)
		end
	end

	return var3_0[arg0_12]
end

function var0_0.GetInfoTrans(arg0_13, arg1_13)
	local var0_13 = arg0_13.name
	local var1_13 = arg0_13.value
	local var2_13 = arg0_13.auxBoost

	if arg0_13.type == AttributeType.CD then
		var1_13 = var0_0.CalcWeanponCD(var1_13, arg1_13) .. "s" .. pg.equip_data_code.WAVE.text
	elseif arg0_13.type == AttributeType.AirDurability then
		local var3_13 = arg1_13 and arg1_13.level or 100

		var1_13 = math.floor(var1_13[1] + var1_13[2] * (var3_13 - 1) / 1000)
	elseif arg0_13.type == AttributeType.AntiSiren then
		var1_13 = math.floor(var1_13 / 100)
		var1_13 = (var1_13 > 0 and "+" or var1_13 < 0 and "-" or "") .. var1_13 .. "%"
	end

	var0_13 = var0_13 or AttributeType.Type2Name(arg0_13.type)

	if not arg1_13 then
		var0_13 = defaultValue(var4_0(var0_13), var0_13)
	end

	var1_13 = var1_13 or ""
	var2_13 = var2_13 and arg1_13 and table.contains(arg1_13:getSpecificType(), ShipType.SpecificTypeTable.auxiliary)

	return var0_13, var1_13, var2_13
end

local function var5_0(arg0_14)
	local var0_14 = pg.equip_data_code.WAVE.text

	if string.match(arg0_14, var0_14) then
		arg0_14 = string.gsub(arg0_14, var0_14, "")
	end

	arg0_14 = string.gsub(arg0_14, " ", "")

	local var1_14 = {
		string.match(arg0_14, "~(%d+)")
	}

	if #var1_14 > 0 then
		arg0_14 = string.gsub(arg0_14, "~" .. var1_14[1], "")
	end

	local var2_14 = {
		string.match(arg0_14, "(%d+)x(%d+)")
	}

	while #var2_14 > 0 do
		local var3_14 = var2_14[1]
		local var4_14 = var2_14[2]

		arg0_14 = string.gsub(arg0_14, var3_14 .. "x" .. var4_14, var3_14 * var4_14, 1)
		var2_14 = {
			string.match(arg0_14, "(%d+)x(%d+)")
		}
	end

	return tonumber(arg0_14)
end

function var0_0.AlignAttrs(arg0_15, arg1_15)
	for iter0_15 = 1, #arg0_15 do
		if not arg1_15[iter0_15] or arg0_15[iter0_15].type ~= arg1_15[iter0_15].type then
			table.insert(arg1_15, iter0_15, Clone(arg0_15[iter0_15]))

			arg1_15[iter0_15].value = 0

			for iter1_15 = iter0_15 + 1, #arg1_15 do
				if arg1_15[iter0_15].type == arg1_15[iter1_15].type then
					arg1_15[iter0_15].value = arg1_15[iter1_15].value

					table.remove(arg1_15, iter1_15)

					break
				end
			end
		end
	end

	for iter2_15 = #arg0_15 + 1, #arg1_15 do
		table.insert(arg0_15, Clone(arg1_15[iter2_15]))

		arg0_15[iter2_15].value = 0
	end
end

function var0_0.CompareInfo(arg0_16, arg1_16, arg2_16)
	if arg0_16.type == AttributeType.Damage then
		local var0_16 = var5_0(arg0_16.value)

		arg1_16.compare = var5_0(arg1_16.value) - var0_16
	elseif arg0_16.type == AttributeType.CD then
		local var1_16 = var0_0.CalcWeanponCD(arg0_16.value, arg2_16)

		arg1_16.compare = -(var0_0.CalcWeanponCD(arg1_16.value, arg2_16) - var1_16)
	else
		arg1_16.compare = arg1_16.value - arg0_16.value
	end
end

function var0_0.InsertAttrsUpgrade(arg0_17, arg1_17, arg2_17)
	var0_0.AlignAttrs(arg0_17, arg1_17)

	for iter0_17 = #arg0_17, 1, -1 do
		if arg0_17[iter0_17].value == arg1_17[iter0_17].value then
			if not arg2_17 then
				table.remove(arg0_17, iter0_17)
				table.remove(arg1_17, iter0_17)
			end
		else
			arg0_17[iter0_17].nextValue = arg1_17[iter0_17].value
		end
	end
end

function var0_0.InsertAttrsCompare(arg0_18, arg1_18, arg2_18)
	var0_0.AlignAttrs(arg0_18, arg1_18)

	for iter0_18 = 1, #arg0_18 do
		var0_0.CompareInfo(arg0_18[iter0_18], arg1_18[iter0_18], arg2_18)
	end
end

function var0_0.GetPropertiesInfo(arg0_19)
	local var0_19 = {
		attrs = {}
	}

	if arg0_19:getConfig(AttributeType.Damage) then
		table.insert(var0_19.attrs, {
			type = AttributeType.Damage,
			value = arg0_19:getConfig(AttributeType.Damage)
		})
	end

	if arg0_19:getConfig(AttributeType.CD) then
		local var1_19 = {
			type = AttributeType.CD,
			value = arg0_19:getConfig(AttributeType.CD)
		}

		table.insert(var0_19.attrs, var1_19)

		if arg0_19:isAircraftExtend() and arg0_19:getConfig("weapon_id") then
			var1_19.sub = {}

			for iter0_19, iter1_19 in ipairs(arg0_19:getConfig("weapon_id")) do
				if pg.weapon_property[iter1_19].type == 11 then
					table.insert(var1_19.sub, {
						name = i18n("equip_info_34"),
						type = AttributeType.CD,
						value = pg.weapon_property[iter1_19].reload_max
					})
				end
			end
		end
	end

	for iter2_19, iter3_19 in ipairs(arg0_19:GetAttributes()) do
		if iter3_19 and iter3_19.type ~= AttributeType.OxyRaidDistance then
			table.insert(var0_19.attrs, iter3_19)
		end
	end

	if arg0_19:GetAntiSirenPower() then
		table.insert(var0_19.attrs, {
			type = AttributeType.AntiSiren,
			value = arg0_19:GetAntiSirenPower()
		})
	end

	local var2_19 = arg0_19:GetSonarProperty()

	if var2_19 then
		table.insert(var0_19.attrs, {
			type = AttributeType.SonarRange,
			value = var2_19[AttributeType.SonarRange]
		})
	end

	var0_19.weapon = {
		lock_open = true,
		name = i18n(arg0_19:isAircraftExtend() and "equip_info_24" or "equip_info_5"),
		sub = {}
	}

	for iter4_19, iter5_19 in ipairs(arg0_19:getConfig("ammo_info")) do
		table.insert(var0_19.weapon.sub, arg0_19:GetWeaponPageInfo(iter5_19[1], iter5_19[2]))
	end

	var0_19.equipInfo = {
		name = i18n("equip_info_14"),
		sub = {}
	}

	for iter6_19, iter7_19 in ipairs(arg0_19:getConfig("equip_info")) do
		table.insert(var0_19.equipInfo.sub, arg0_19:GetEquipAttrPageInfo(iter7_19))
	end

	var0_19.part = {
		arg0_19:getConfig("part_main"),
		arg0_19:getConfig("part_sub")
	}
	var0_19.equipmentType = arg0_19:getConfig("type")

	return var0_19
end

function var0_0.GetWeaponPageInfo(arg0_20, arg1_20, arg2_20)
	local var0_20
	local var1_20 = pg.equip_bullet_type[arg1_20]
	local var2_20 = var1_20.exhibition_type == 2

	for iter0_20, iter1_20 in ipairs(var1_20.exhibition_list) do
		if not var0_20 then
			var0_20 = arg0_20:GetWeaponInfo(iter1_20, arg2_20, var2_20)
			var0_20.sub = {}
		else
			table.insert(var0_20.sub, arg0_20:GetWeaponInfo(iter1_20, arg2_20, var2_20))
		end
	end

	return var0_20
end

function var0_0.GetWeaponInfo(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg3_21 and pg.weapon_property[arg2_21].bullet_ID[1] or arg2_21

	return switch(arg1_21, {
		function()
			return {
				name = i18n("equip_ammo_type_" .. arg0_21:getConfig(AttributeType.Ammo))
			}
		end,
		function()
			return {
				name = pg.weapon_name[arg2_21].name
			}
		end,
		function()
			return {
				type = AttributeType.Damage,
				value = pg.weapon_property[arg2_21].damage
			}
		end,
		function()
			return {
				name = i18n("equip_info_6"),
				value = pg.bullet_template[var0_21].velocity
			}
		end,
		function()
			return {
				name = i18n("equip_info_7"),
				value = pg.bullet_template[var0_21].velocity
			}
		end,
		function()
			local var0_27 = pg.bullet_template[var0_21].damage_type

			return {
				name = i18n("equip_info_8"),
				value = var0_27[1] * 100 .. "-" .. var0_27[2] * 100 .. "-" .. var0_27[3] * 100
			}
		end,
		function()
			return {
				name = i18n("equip_info_9"),
				value = pg.bullet_template[var0_21].hit_type.range
			}
		end,
		function()
			return {
				name = i18n("equip_info_10"),
				value = pg.weapon_property[arg2_21].range
			}
		end,
		function()
			return {
				name = i18n("equip_info_11"),
				value = pg.weapon_property[arg2_21].angle
			}
		end,
		function()
			return {
				name = i18n("equip_info_12"),
				value = (pg.bullet_template[var0_21].extra_param.randomOffsetX or "0") .. "*" .. (pg.bullet_template[var0_21].extra_param.randomOffsetZ or "0")
			}
		end,
		function()
			return {
				name = i18n("equip_info_13"),
				value = arg0_21:getConfig(AttributeType.Speciality)
			}
		end,
		function()
			return {
				type = AttributeType.CD,
				value = pg.weapon_property[arg2_21].reload_max
			}
		end,
		function()
			return {
				name = i18n("attribute_max_distance_damage"),
				value = (1 - pg.bullet_template[var0_21].hit_type.decay) * 100 .. "%"
			}
		end
	})
end

local var6_0 = {
	nil,
	nil,
	true,
	true,
	true,
	[13] = true
}

function var0_0.GetEquipAttrPageInfo(arg0_35, arg1_35)
	local var0_35
	local var1_35

	if type(arg1_35) == "table" then
		var0_35, var1_35 = arg1_35[1], arg1_35[2]
	else
		var0_35, var1_35 = arg1_35, arg0_35:getConfig("weapon_id")[1]
	end

	assert(tobool(var6_0[var0_35]) == (type(arg1_35) == "table"), "equip attr sid type error from equip:" .. arg0_35.id)

	return arg0_35:GetEquipAttrInfo(var0_35, var1_35)
end

function var0_0.GetEquipAttrInfo(arg0_36, arg1_36, arg2_36)
	return switch(arg1_36, {
		function()
			local var0_37 = pg.weapon_property[arg2_36]

			return {
				name = i18n("equip_info_15"),
				value = var0_37.min_range == 0 and var0_37.range or var0_37.min_range .. "-" .. var0_37.range
			}
		end,
		function()
			return {
				name = i18n("equip_info_16"),
				value = pg.weapon_property[arg2_36].angle
			}
		end,
		function()
			local var0_39 = pg.bullet_template[arg2_36]

			return {
				name = i18n("equip_info_17"),
				value = var0_39.range - var0_39.range_offset .. "-" .. var0_39.range + var0_39.range_offset
			}
		end,
		function()
			local var0_40 = pg.barrage_template[arg2_36]

			return {
				name = i18n("equip_info_18"),
				value = var0_40.random_angle and var0_40.angle or math.abs(var0_40.delta_angle) * var0_40.primal_repeat
			}
		end,
		function()
			return {
				name = i18n("attribute_scatter"),
				value = pg.bullet_template[arg2_36].extra_param.randomOffsetX
			}
		end,
		function()
			return {
				name = i18n("equip_info_19"),
				value = Nation.Nation2Name(arg0_36:getConfig("nationality"))
			}
		end,
		function()
			local var0_43 = pg.aircraft_template[arg0_36.id]

			return {
				name = i18n("equip_info_20"),
				value = var0_43.speed
			}
		end,
		function()
			local var0_44 = pg.aircraft_template[arg0_36.id]

			return {
				name = i18n("equip_info_21"),
				type = AttributeType.AirDurability,
				value = {
					var0_44.max_hp,
					var0_44.hp_growth
				}
			}
		end,
		function()
			local var0_45 = pg.aircraft_template[arg0_36.id]

			return {
				name = i18n("equip_info_22"),
				value = var0_45.dodge_limit
			}
		end,
		function()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return {
					name = i18n("equip_info_28"),
					type = AttributeType.Corrected,
					value = EquipmentRarity.Rarity2CorrectedLevel(arg0_36:getConfig("rarity"), arg0_36:getConfig("level"))
				}
			else
				return {
					name = i18n("equip_info_28"),
					type = AttributeType.Corrected,
					value = pg.weapon_property[arg2_36].corrected .. "%"
				}
			end
		end,
		function()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return nil
			else
				local var0_47 = {
					AttributeType.Cannon,
					AttributeType.Torpedo,
					AttributeType.AntiAircraft,
					AttributeType.Air,
					AttributeType.AntiSub
				}

				return {
					name = i18n("equip_info_29"),
					value = AttributeType.Type2Name(var0_47[pg.weapon_property[arg2_36].attack_attribute])
				}
			end
		end,
		function()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return nil
			else
				return {
					name = i18n("equip_info_30"),
					value = pg.weapon_property[arg2_36].attack_attribute_ratio .. "%"
				}
			end
		end,
		function()
			local var0_49 = pg.bullet_template[arg2_36]

			return {
				name = i18n("equip_info_32"),
				value = math.abs(var0_49.extra_param.aim_offset)
			}
		end
	})
end

function var0_0.GetGearScore(arg0_50)
	local var0_50 = arg0_50:getConfig("rarity")
	local var1_50 = arg0_50:getConfig("level")

	assert(pg.equip_data_by_quality[var0_50], "equip_data_by_quality not exist: " .. var0_50)

	local var2_50 = pg.equip_data_by_quality[var0_50]

	return var2_50.gear_score + var1_50 * var2_50.gear_score_addition
end

function var0_0.GetSkill(arg0_51)
	local var0_51
	local var1_51 = arg0_51:getConfig("skill_id")[1]

	if var1_51 then
		var0_51 = getSkillConfig(var1_51)
	end

	return var0_51
end

function var0_0.GetWeaponID(arg0_52)
	return arg0_52:getConfig("weapon_id")
end

function var0_0.GetSonarProperty(arg0_53)
	local var0_53 = arg0_53:getConfig("equip_parameters").range

	if var0_53 then
		return {
			[AttributeType.SonarRange] = var0_53
		}
	else
		return nil
	end
end

function var0_0.GetAntiSirenPower(arg0_54)
	return arg0_54:getConfig("anti_siren")
end

function var0_0.canUpgrade(arg0_55)
	return var0_0.getConfigData(arg0_55).next ~= 0
end

function var0_0.hasPrevLevel(arg0_56)
	return arg0_56:getConfig("prev") ~= 0
end

function var0_0.getRevertAwards(arg0_57)
	local var0_57 = {}
	local var1_57 = 0
	local var2_57 = arg0_57

	while var2_57:hasPrevLevel() do
		var2_57 = Equipment.New({
			id = var2_57:getConfig("prev")
		})

		for iter0_57, iter1_57 in ipairs(var2_57:getConfig("trans_use_item")) do
			table.insert(var0_57, Drop.New({
				type = DROP_TYPE_ITEM,
				id = iter1_57[1],
				count = iter1_57[2]
			}))
		end

		var1_57 = var1_57 + var2_57:getConfig("trans_use_gold")
	end

	local var3_57 = PlayerConst.MergeSameDrops(var0_57)

	if var1_57 > 0 then
		table.insert(var3_57, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = var1_57
		}))
	end

	return var3_57
end

function var0_0.canEquipSkin(arg0_58)
	local var0_58 = arg0_58:getConfig("type")

	return pg.equip_data_by_type[var0_58].equip_skin == 1
end

function var0_0.getType(arg0_59)
	return arg0_59:getConfig("type")
end

function var0_0.hasSkin(arg0_60)
	return arg0_60.skinId and arg0_60.skinId ~= 0
end

function var0_0.setSkinId(arg0_61, arg1_61)
	arg0_61.skinId = arg1_61
end

function var0_0.getSkinId(arg0_62)
	return arg0_62.skinId
end

function var0_0.hasSkinOrbit(arg0_63)
	if not arg0_63:hasSkin() then
		return false
	end

	return var0_0.IsOrbitSkin(arg0_63.skinId)
end

function var0_0.IsOrbitSkin(arg0_64)
	local var0_64 = var1_0[arg0_64]

	if var0_64.orbit_combat ~= "" or var0_64.orbit_ui ~= "" then
		return true
	else
		return false
	end
end

function var0_0.isImportance(arg0_65)
	return arg0_65:getConfig("important") == var0_0.EQUIPMENT_IMPORTANCE
end

function var0_0.isUnique(arg0_66)
	return arg0_66:getConfig("equip_limit") ~= 0
end

function var0_0.isDevice(arg0_67)
	local var0_67 = arg0_67:getConfig("type")

	return underscore.any(EquipType.DeviceEquipTypes, function(arg0_68)
		return arg0_68 == var0_67
	end)
end

function var0_0.isAircraft(arg0_69)
	local var0_69 = arg0_69:getConfig("type")

	return underscore.any(EquipType.AirEquipTypes, function(arg0_70)
		return arg0_70 == var0_69
	end)
end

function var0_0.isAircraftExtend(arg0_71)
	local var0_71 = arg0_71:getConfig("type")

	return underscore.any(EquipType.AirExtendEquipTypes, function(arg0_72)
		return arg0_72 == var0_71
	end)
end

function var0_0.MigrateTo(arg0_73, arg1_73)
	assert(not arg0_73.isSkin)

	return Equipment.New({
		id = arg1_73,
		config_id = arg1_73,
		count = arg0_73.count
	})
end

function var0_0.GetRootEquipment(arg0_74)
	local var0_74 = var0_0.getConfigData(arg0_74.configId)

	while var0_74.prev > 0 do
		var0_74 = var0_0.getConfigData(var0_74.prev)
	end

	local var1_74 = arg0_74:MigrateTo(var0_74.id)

	var1_74.count = 1

	return var1_74
end

function var0_0.getNation(arg0_75)
	return arg0_75:getConfig("nationality")
end

function var0_0.GetEquipRootStatic(arg0_76)
	local var0_76 = var0_0.getConfigData(arg0_76)

	while var0_76.prev > 0 do
		var0_76 = var0_0.getConfigData(var0_76.prev)
	end

	return var0_76.id
end

function var0_0.GetRevertRewardsStatic(arg0_77)
	local var0_77 = {}
	local var1_77 = var0_0.getConfigData(arg0_77)

	while var1_77.prev > 0 do
		var1_77 = var0_0.getConfigData(var1_77.prev)

		for iter0_77, iter1_77 in ipairs(var1_77.trans_use_item) do
			var0_77[iter1_77[1]] = (var0_77[iter1_77[1]] or 0) + iter1_77[2]
		end

		var0_77.gold = (var0_77.gold or 0) + var1_77.trans_use_gold
	end

	return var0_77
end

function var0_0.GetEquipReloadStatic(arg0_78)
	local var0_78 = var0_0.getConfigData(arg0_78).weapon_id

	if var0_78 and #var0_78 > 0 then
		local var1_78 = pg.weapon_property[var0_78[1]]

		if var1_78 then
			return var1_78.reload_max
		end
	end
end

function var0_0.GetEquipComposeCfgStatic(arg0_79)
	local var0_79 = pg.compose_data_template

	for iter0_79, iter1_79 in ipairs(var0_79.all) do
		local var1_79 = var0_79[iter1_79]
		local var2_79 = true

		for iter2_79, iter3_79 in pairs(arg0_79) do
			var2_79 = var2_79 and var1_79[iter2_79] == iter3_79
		end

		if var2_79 then
			return var1_79
		end
	end
end

return var0_0
