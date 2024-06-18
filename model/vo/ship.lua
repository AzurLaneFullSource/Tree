local var0_0 = class("Ship", import(".BaseVO"))

var0_0.ENERGY_MID = 40
var0_0.ENERGY_LOW = 0
var0_0.RECOVER_ENERGY_POINT = 2
var0_0.INTIMACY_PROPOSE = 6
var0_0.CONFIG_MAX_STAR = 6
var0_0.BACKYARD_1F_ENERGY_ADDITION = 2
var0_0.BACKYARD_2F_ENERGY_ADDITION = 3
var0_0.PREFERENCE_TAG_NONE = 0
var0_0.PREFERENCE_TAG_COMMON = 1

local var1_0 = {
	vanguard = i18n("word_vanguard_fleet"),
	main = i18n("word_main_fleet")
}

var0_0.CVBattleKey = {
	skill = "skill",
	link2 = "link2",
	lose = "lose",
	link5 = "link5",
	link3 = "link3",
	link6 = "link6",
	hp = "hp",
	link1 = "link1",
	link4 = "link4",
	warcry = "warcry",
	mvp = "mvp"
}
var0_0.LOCK_STATE_UNLOCK = 0
var0_0.LOCK_STATE_LOCK = 1
var0_0.WEAPON_COUNT = 3
var0_0.PREFAB_EQUIP = 4
var0_0.MAX_SKILL_LEVEL = 10
var0_0.ENERGY_RECOVER_TIME = 360
var0_0.STATE_NORMAL = 1
var0_0.STATE_REST = 2
var0_0.STATE_CLASS = 3
var0_0.STATE_COLLECT = 4
var0_0.STATE_TRAIN = 5

local var2_0 = 4
local var3_0 = 100
local var4_0 = 120
local var5_0 = pg.ship_data_strengthen
local var6_0 = pg.ship_level
local var7_0 = pg.equip_skin_template
local var8_0 = pg.ship_data_breakout

function nation2print(arg0_1)
	return Nation.Nation2Print(arg0_1)
end

function var0_0.getRecoverEnergyPoint(arg0_2)
	return arg0_2.propose and 3 or 2
end

function shipType2name(arg0_3)
	return ShipType.Type2Name(arg0_3)
end

function shipType2print(arg0_4)
	return ShipType.Type2Print(arg0_4)
end

function shipType2Battleprint(arg0_5)
	return ShipType.Type2BattlePrint(arg0_5)
end

function skinId2bgPrint(arg0_6)
	local var0_6 = pg.ship_skin_template[arg0_6].rarity_bg

	if var0_6 and var0_6 ~= "" then
		return var0_6
	end
end

function var0_0.rarity2bgPrint(arg0_7)
	return shipRarity2bgPrint(arg0_7:getRarity(), arg0_7:isBluePrintShip(), arg0_7:isMetaShip())
end

function var0_0.rarity2bgPrintForGet(arg0_8)
	return skinId2bgPrint(arg0_8.skinId) or arg0_8:rarity2bgPrint()
end

function var0_0.getShipBgPrint(arg0_9, arg1_9)
	local var0_9 = pg.ship_skin_template[arg0_9.skinId]

	assert(var0_9, "ship_skin_template not exist: " .. arg0_9.skinId)

	local var1_9

	if not arg1_9 and var0_9.bg_sp and var0_9.bg_sp ~= "" and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_9.painting, 0) == 0 then
		var1_9 = var0_9.bg_sp
	end

	return var1_9 and var1_9 or var0_9.bg and #var0_9.bg > 0 and var0_9.bg or arg0_9:rarity2bgPrintForGet()
end

function var0_0.getStar(arg0_10)
	return arg0_10:getConfig("star")
end

function var0_0.getMaxStar(arg0_11)
	return pg.ship_data_template[arg0_11.configId].star_max
end

function var0_0.getShipArmor(arg0_12)
	return arg0_12:getConfig("armor_type")
end

function var0_0.getShipArmorName(arg0_13)
	local var0_13 = arg0_13:getShipArmor()

	return ArmorType.Type2Name(var0_13)
end

function var0_0.getGroupId(arg0_14)
	return pg.ship_data_template[arg0_14.configId].group_type
end

function var0_0.getGroupIdByConfigId(arg0_15)
	return math.floor(arg0_15 / 10)
end

function var0_0.getShipWords(arg0_16)
	local var0_16 = pg.ship_skin_words[arg0_16]

	if not var0_16 then
		warning("找不到ship_skin_words: " .. arg0_16)

		return
	end

	local var1_16 = Clone(var0_16)

	for iter0_16, iter1_16 in pairs(var1_16) do
		if type(iter1_16) == "string" then
			var1_16[iter0_16] = HXSet.hxLan(iter1_16)
		end
	end

	local var2_16 = pg.ship_skin_words_extra[arg0_16]

	return var1_16, var2_16
end

function var0_0.getMainwordsCount(arg0_17)
	local var0_17 = var0_0.getShipWords(arg0_17)

	if not var0_17.main or var0_17.main == "" then
		var0_17 = var0_0.getShipWords(var0_0.getOriginalSkinId(arg0_17))
	end

	return #string.split(var0_17.main, "|")
end

function var0_0.getWordsEx(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	local var0_18 = arg0_18 and arg0_18[arg1_18] or nil
	local var1_18 = false

	if not var0_18 or var0_18 == "" then
		if arg0_18 and arg0_18.id == arg4_18 then
			return
		end

		if not arg5_18 then
			return
		end

		local var2_18, var3_18 = var0_0.getShipWords(arg4_18)

		if not var3_18 then
			return
		end

		var0_18 = var3_18[arg1_18]

		if not var0_18 then
			return
		end

		var1_18 = true
	end

	if type(var0_18) == "string" then
		return
	end

	arg3_18 = arg3_18 or 0

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if arg3_18 >= iter1_18[1] then
			if arg1_18 == "main" then
				return string.split(iter1_18[2], "|")[arg2_18], iter1_18[1], var1_18
			else
				return iter1_18[2], iter1_18[1], var1_18
			end
		end
	end
end

function var0_0.getWords(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19, var1_19 = var0_0.getShipWords(arg0_19)
	local var2_19 = var0_0.getOriginalSkinId(arg0_19)
	local var3_19 = math.fmod(arg0_19, var2_19)

	if not var0_19 then
		var0_19, var1_19 = var0_0.getShipWords(var2_19)

		if not var0_19 then
			return nil
		end
	end

	local var4_19 = 0
	local var5_19 = false
	local var6_19 = var0_19[arg1_19]

	if not var6_19 or var6_19 == "" then
		var5_19 = true

		if var0_19.id == var2_19 then
			return nil
		else
			var0_19 = var0_0.getShipWords(var2_19)

			if not var0_19 then
				return nil
			end

			var6_19 = var0_19[arg1_19]

			if not var6_19 or var6_19 == "" then
				return nil
			end
		end
	end

	local var7_19 = string.split(var6_19, "|")
	local var8_19 = arg2_19 or math.random(#var7_19)

	if arg1_19 == "main" and var7_19[var8_19] == "nil" then
		var5_19 = true
		var0_19 = var0_0.getShipWords(var2_19)

		if not var0_19 then
			return nil
		end

		local var9_19 = var0_19[arg1_19]

		if not var9_19 or var9_19 == "" then
			return nil
		end

		var7_19 = string.split(var9_19, "|")
	end

	rstEx, cvEx, defaultCoverEx = var0_0.getWordsEx(var1_19, arg1_19, var8_19, arg4_19, var2_19, var5_19)

	local var10_19
	local var11_19 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. pg.ship_skin_template[arg0_19].ship_group) == 2 and var0_19.voice_key_2 or var0_19.voice_key

	if var11_19 == 0 then
		if not var5_19 or rstEx and not defaultCoverEx then
			var10_19 = var0_0.getCVPath(var2_19, arg1_19, var8_19, var3_19)
		end
	elseif var11_19 == -2 then
		-- block empty
	else
		var10_19 = var0_0.getCVPath(var2_19, arg1_19, var8_19)
	end

	local var12_19 = var7_19[var8_19]

	if var12_19 and (arg3_19 == nil and PLATFORM_CODE ~= PLATFORM_US or arg3_19 == true) then
		var12_19 = var12_19:gsub("%s", " ")
	end

	if rstEx then
		var10_19 = var10_19 and var10_19 .. "_ex" .. cvEx
	end

	return rstEx or var12_19, var10_19, cvEx
end

function var0_0.getCVKeyID(arg0_20)
	local var0_20 = Ship.getShipWords(arg0_20)

	if not var0_20 then
		return -1
	end

	local var1_20
	local var2_20 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. pg.ship_skin_template[arg0_20].ship_group)
	local var3_20 = var2_20 == 2 and var0_20.voice_key_2 >= 0 and var0_20.voice_key_2 or var0_20.voice_key

	if var3_20 == 0 or var3_20 == -2 then
		local var4_20 = var0_0.getOriginalSkinId(arg0_20)
		local var5_20 = var0_0.getShipWords(var4_20)

		var3_20 = var2_20 == 2 and var5_20.voice_key_2 >= 0 and var5_20.voice_key_2 or var5_20.voice_key
	end

	return var3_20
end

function var0_0.getCVPath(arg0_21, arg1_21, arg2_21, arg3_21)
	arg2_21 = arg2_21 or 1

	local var0_21 = Ship.getShipWords(arg0_21)
	local var1_21 = var0_0.getOriginalSkinId(arg0_21)

	if not var0_21 then
		var0_21 = var0_0.getShipWords(var1_21)

		if not var0_21 then
			return
		end
	end

	local var2_21 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. arg0_21 / 10)
	local var3_21 = var0_21[arg1_21]

	if arg1_21 == "main" then
		var3_21 = string.split(var3_21, "|")[arg2_21]
		arg1_21 = arg1_21 .. arg2_21
	end

	if arg1_21 == "skill" or string.find(arg1_21, "link") then
		if var0_21.voice_key == 0 then
			var0_21 = var0_0.getShipWords(var1_21)
		end
	elseif not var3_21 or var3_21 == "" or var3_21 == "nil" then
		var0_21 = var0_0.getShipWords(var1_21)
	end

	local var4_21
	local var5_21 = var2_21 == 2 and var0_21.voice_key_2 or var0_21.voice_key

	if var5_21 ~= -1 and pg.character_voice[arg1_21] then
		var4_21 = pg.character_voice[arg1_21].resource_key

		if var4_21 then
			var4_21 = "event:/cv/" .. var5_21 .. "/" .. var4_21

			if arg3_21 then
				var4_21 = var4_21 .. "_" .. arg3_21
			end
		end
	end

	return var4_21
end

function var0_0.getCVCalibrate(arg0_22, arg1_22, arg2_22)
	local var0_22 = pg.ship_skin_template[arg0_22]

	if not var0_22 then
		return 0
	end

	if arg1_22 == "main" then
		arg1_22 = arg1_22 .. "_" .. arg2_22
	end

	return var0_22.l2d_voice_calibrate[arg1_22]
end

function var0_0.getL2dSoundEffect(arg0_23, arg1_23, arg2_23)
	local var0_23 = pg.ship_skin_template[arg0_23]

	if not var0_23 then
		return 0
	end

	if arg1_23 == "main" then
		arg1_23 = arg1_23 .. "_" .. arg2_23
	end

	return var0_23.l2d_se[arg1_23]
end

function var0_0.getOriginalSkinId(arg0_24)
	local var0_24 = pg.ship_skin_template[arg0_24].ship_group

	return ShipGroup.getDefaultSkin(var0_24).id
end

function var0_0.getTransformShipId(arg0_25)
	local var0_25 = pg.ship_data_template[arg0_25].group_type
	local var1_25 = pg.ship_data_trans[var0_25]

	if var1_25 then
		for iter0_25, iter1_25 in ipairs(var1_25.transform_list) do
			for iter2_25, iter3_25 in ipairs(iter1_25) do
				local var2_25 = pg.transform_data_template[iter3_25[2]]

				for iter4_25, iter5_25 in ipairs(var2_25.ship_id) do
					if iter5_25[1] == arg0_25 then
						return iter5_25[2]
					end
				end
			end
		end
	end
end

function var0_0.getAircraftCount(arg0_26)
	local var0_26 = arg0_26:getConfigTable().base_list
	local var1_26 = arg0_26:getConfigTable().default_equip_list
	local var2_26 = {}

	for iter0_26 = 1, 3 do
		local var3_26 = arg0_26:getEquip(iter0_26) and arg0_26:getEquip(iter0_26).configId or var1_26[iter0_26]
		local var4_26 = Equipment.getConfigData(var3_26).type

		if table.contains(EquipType.AirDomainEquip, var4_26) then
			var2_26[var4_26] = defaultValue(var2_26[var4_26], 0) + var0_26[iter0_26]
		end
	end

	return var2_26
end

function var0_0.getShipType(arg0_27)
	return arg0_27:getConfig("type")
end

function var0_0.getEnergy(arg0_28)
	return arg0_28.energy
end

function var0_0.getEnergeConfig(arg0_29)
	local var0_29 = pg.energy_template
	local var1_29 = arg0_29:getEnergy()

	for iter0_29, iter1_29 in pairs(var0_29) do
		if type(iter0_29) == "number" and var1_29 >= iter1_29.lower_bound and var1_29 <= iter1_29.upper_bound then
			return iter1_29
		end
	end

	assert(false, "疲劳配置不存在：" .. arg0_29.energy)
end

function var0_0.getEnergyPrint(arg0_30)
	local var0_30 = arg0_30:getEnergeConfig()

	return var0_30.icon, var0_30.desc
end

function var0_0.getIntimacy(arg0_31)
	return arg0_31.intimacy
end

function var0_0.getCVIntimacy(arg0_32)
	return arg0_32:getIntimacy() / 100 + (arg0_32.propose and 1000 or 0)
end

function var0_0.getIntimacyMax(arg0_33)
	if arg0_33.propose then
		return 200
	else
		return arg0_33:GetNoProposeIntimacyMax()
	end
end

function var0_0.GetNoProposeIntimacyMax(arg0_34)
	return 100
end

function var0_0.getIntimacyIcon(arg0_35)
	local var0_35 = pg.intimacy_template[arg0_35:getIntimacyLevel()]
	local var1_35 = ""

	if arg0_35:isMetaShip() then
		var1_35 = "_meta"
	elseif arg0_35:IsXIdol() then
		var1_35 = "_imas"
	end

	if not arg0_35.propose and math.floor(arg0_35:getIntimacy() / 100) >= arg0_35:getIntimacyMax() then
		return var0_35.icon .. var1_35, "heart" .. var1_35
	else
		return var0_35.icon .. var1_35
	end
end

function var0_0.getIntimacyDetail(arg0_36)
	return arg0_36:getIntimacyMax(), math.floor(arg0_36:getIntimacy() / 100)
end

function var0_0.getIntimacyInfo(arg0_37)
	local var0_37 = pg.intimacy_template[arg0_37:getIntimacyLevel()]

	return var0_37.icon, var0_37.desc
end

function var0_0.getIntimacyLevel(arg0_38)
	local var0_38 = 0
	local var1_38 = pg.intimacy_template

	for iter0_38, iter1_38 in pairs(var1_38) do
		if type(iter0_38) == "number" and arg0_38:getIntimacy() >= iter1_38.lower_bound and arg0_38:getIntimacy() <= iter1_38.upper_bound then
			var0_38 = iter0_38

			break
		end
	end

	if var0_38 < arg0_38.INTIMACY_PROPOSE and arg0_38.propose then
		var0_38 = arg0_38.INTIMACY_PROPOSE
	end

	return var0_38
end

function var0_0.getBluePrint(arg0_39)
	local var0_39 = ShipBluePrint.New({
		id = arg0_39.groupId
	})
	local var1_39 = arg0_39.strengthList[1] or {
		exp = 0,
		level = 0
	}

	var0_39:updateInfo({
		blue_print_level = var1_39.level,
		exp = var1_39.exp
	})

	return var0_39
end

function var0_0.getBaseList(arg0_40)
	if arg0_40:isBluePrintShip() then
		local var0_40 = arg0_40:getBluePrint()

		assert(var0_40, "blueprint can not be nil" .. arg0_40.configId)

		return var0_40:getBaseList(arg0_40)
	else
		return arg0_40:getConfig("base_list")
	end
end

function var0_0.getPreLoadCount(arg0_41)
	if arg0_41:isBluePrintShip() then
		return arg0_41:getBluePrint():getPreLoadCount(arg0_41)
	else
		return arg0_41:getConfig("preload_count")
	end
end

function var0_0.getNation(arg0_42)
	return arg0_42:getConfig("nationality")
end

function var0_0.getPaintingName(arg0_43)
	local var0_43 = pg.ship_data_statistics[arg0_43].skin_id
	local var1_43 = pg.ship_skin_template[var0_43]

	assert(var1_43, "ship_skin_template not exist: " .. arg0_43 .. " " .. var0_43)

	return var1_43.painting
end

function var0_0.getName(arg0_44)
	if arg0_44.propose and pg.PushNotificationMgr.GetInstance():isEnableShipName() then
		return arg0_44.name
	end

	if arg0_44:isRemoulded() then
		return pg.ship_skin_template[arg0_44:getRemouldSkinId()].name
	end

	return pg.ship_data_statistics[arg0_44.configId].name
end

function var0_0.GetDefaultName(arg0_45)
	if arg0_45:isRemoulded() then
		return pg.ship_skin_template[arg0_45:getRemouldSkinId()].name
	else
		return pg.ship_data_statistics[arg0_45.configId].name
	end
end

function var0_0.getShipName(arg0_46)
	return pg.ship_data_statistics[arg0_46].name
end

function var0_0.getBreakOutLevel(arg0_47)
	assert(arg0_47, "必须存在配置id")
	assert(pg.ship_data_statistics[arg0_47], "必须存在配置" .. arg0_47)

	return pg.ship_data_statistics[arg0_47].star
end

function var0_0.Ctor(arg0_48, arg1_48)
	arg0_48.id = arg1_48.id
	arg0_48.configId = arg1_48.template_id or arg1_48.configId
	arg0_48.level = arg1_48.level
	arg0_48.exp = arg1_48.exp
	arg0_48.energy = arg1_48.energy
	arg0_48.lockState = arg1_48.is_locked
	arg0_48.intimacy = arg1_48.intimacy
	arg0_48.propose = arg1_48.propose and arg1_48.propose > 0
	arg0_48.proposeTime = arg1_48.propose

	if arg0_48.intimacy and arg0_48.intimacy > 10000 and not arg0_48.propose then
		arg0_48.intimacy = 10000
	end

	arg0_48.renameTime = arg1_48.change_name_timestamp

	if arg1_48.name and arg1_48.name ~= "" then
		arg0_48.name = arg1_48.name
	else
		assert(pg.ship_data_statistics[arg0_48.configId], "必须存在配置" .. arg0_48.configId)

		arg0_48.name = pg.ship_data_statistics[arg0_48.configId].name
	end

	arg0_48.bluePrintFlag = arg1_48.blue_print_flag or 0
	arg0_48.strengthList = {}

	for iter0_48, iter1_48 in ipairs(arg1_48.strength_list or {}) do
		if not arg0_48:isBluePrintShip() then
			local var0_48 = ShipModAttr.ID_TO_ATTR[iter1_48.id]

			arg0_48.strengthList[var0_48] = iter1_48.exp
		else
			table.insert(arg0_48.strengthList, {
				level = iter1_48.id,
				exp = iter1_48.exp
			})
		end
	end

	local var1_48 = arg1_48.state or {}

	arg0_48.state = var1_48.state
	arg0_48.state_info_1 = var1_48.state_info_1
	arg0_48.state_info_2 = var1_48.state_info_2
	arg0_48.state_info_3 = var1_48.state_info_3
	arg0_48.state_info_4 = var1_48.state_info_4
	arg0_48.equipmentSkins = {}
	arg0_48.equipments = {}

	if arg1_48.equip_info_list then
		for iter2_48, iter3_48 in ipairs(arg1_48.equip_info_list or {}) do
			arg0_48.equipments[iter2_48] = iter3_48.id > 0 and Equipment.New({
				count = 1,
				id = iter3_48.id,
				config_id = iter3_48.id,
				skinId = iter3_48.skinId
			}) or false
			arg0_48.equipmentSkins[iter2_48] = iter3_48.skinId > 0 and iter3_48.skinId or 0

			arg0_48:reletiveEquipSkin(iter2_48)
		end
	end

	arg0_48.spWeapon = nil

	if arg1_48.spweapon then
		arg0_48:UpdateSpWeapon(SpWeapon.CreateByNet(arg1_48.spweapon))
	end

	arg0_48.skills = {}

	for iter4_48, iter5_48 in ipairs(arg1_48.skill_id_list or {}) do
		arg0_48:updateSkill(iter5_48)
	end

	arg0_48.star = arg0_48:getConfig("rarity")
	arg0_48.transforms = {}

	for iter6_48, iter7_48 in ipairs(arg1_48.transform_list or {}) do
		arg0_48.transforms[iter7_48.id] = {
			id = iter7_48.id,
			level = iter7_48.level
		}
	end

	arg0_48.groupId = pg.ship_data_template[arg0_48.configId].group_type
	arg0_48.createTime = arg1_48.create_time or 0

	local var2_48 = getProxy(CollectionProxy)

	arg0_48.virgin = var2_48 and var2_48.shipGroups[arg0_48.groupId] == nil

	local var3_48 = {
		pg.gameset.test_ship_config_1.key_value,
		pg.gameset.test_ship_config_2.key_value,
		pg.gameset.test_ship_config_3.key_value
	}
	local var4_48 = table.indexof(var3_48, arg0_48.configId)

	if var4_48 == 1 then
		arg0_48.testShip = {
			2,
			3,
			4
		}
	elseif var4_48 == 2 then
		arg0_48.testShip = {
			5
		}
	elseif var4_48 == 3 then
		arg0_48.testShip = {
			6
		}
	else
		arg0_48.testShip = nil
	end

	arg0_48.maxIntimacy = pg.intimacy_template[#pg.intimacy_template.all].upper_bound

	if not HXSet.isHxSkin() then
		arg0_48.skinId = arg1_48.skin_id or 0
	else
		arg0_48.skinId = 0
	end

	if arg0_48.skinId == 0 then
		arg0_48.skinId = arg0_48:getConfig("skin_id")
	end

	if arg1_48.name and arg1_48.name ~= "" then
		arg0_48.name = arg1_48.name
	elseif arg0_48:isRemoulded() then
		arg0_48.name = pg.ship_skin_template[arg0_48:getRemouldSkinId()].name
	else
		arg0_48.name = pg.ship_data_statistics[arg0_48.configId].name
	end

	arg0_48.maxLevel = arg1_48.max_level
	arg0_48.proficiency = arg1_48.proficiency or 0
	arg0_48.preferenceTag = arg1_48.common_flag
	arg0_48.hpRant = 10000
	arg0_48.strategies = {}
	arg0_48.triggers = {}
	arg0_48.commanderId = arg1_48.commanderid or 0
	arg0_48.activityNpc = arg1_48.activity_npc or 0

	if var0_0.isMetaShipByConfigID(arg0_48.configId) then
		local var5_48 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_48.configId)

		arg0_48.metaCharacter = MetaCharacter.New({
			id = var5_48,
			repair_attr_info = arg1_48.meta_repair_list
		}, arg0_48)
	end
end

function var0_0.isMetaShipByConfigID(arg0_49)
	local var0_49 = pg.ship_meta_breakout.all
	local var1_49 = var0_49[1]
	local var2_49 = false

	if var1_49 <= arg0_49 then
		for iter0_49, iter1_49 in ipairs(var0_49) do
			if arg0_49 == iter1_49 then
				var2_49 = true

				break
			end
		end
	end

	return var2_49
end

function var0_0.isMetaShip(arg0_50)
	return arg0_50.metaCharacter ~= nil
end

function var0_0.getMetaCharacter(arg0_51)
	return arg0_51.metaCharacter
end

function var0_0.unlockActivityNpc(arg0_52, arg1_52)
	arg0_52.activityNpc = arg1_52
end

function var0_0.isActivityNpc(arg0_53)
	return arg0_53.activityNpc > 0
end

function var0_0.getActiveEquipments(arg0_54)
	local var0_54 = Clone(arg0_54.equipments)

	for iter0_54 = #var0_54, 1, -1 do
		local var1_54 = var0_54[iter0_54]

		if var1_54 then
			for iter1_54 = 1, iter0_54 - 1 do
				local var2_54 = var0_54[iter1_54]

				if var2_54 and var1_54:getConfig("equip_limit") ~= 0 and var2_54:getConfig("equip_limit") == var1_54:getConfig("equip_limit") then
					var0_54[iter0_54] = false
				end
			end
		end
	end

	return var0_54
end

function var0_0.getAllEquipments(arg0_55)
	return arg0_55.equipments
end

function var0_0.isBluePrintShip(arg0_56)
	return arg0_56.bluePrintFlag == 1
end

function var0_0.updateSkinId(arg0_57, arg1_57)
	arg0_57.skinId = arg1_57
end

function var0_0.updateName(arg0_58)
	if arg0_58.name ~= pg.ship_data_statistics[arg0_58.configId].name then
		return
	end

	if arg0_58:isRemoulded() then
		arg0_58.name = pg.ship_skin_template[arg0_58:getRemouldSkinId()].name
	else
		arg0_58.name = pg.ship_data_statistics[arg0_58.configId].name
	end
end

function var0_0.isRemoulded(arg0_59)
	if arg0_59.remoulded then
		return true
	end

	local var0_59 = pg.ship_data_trans[arg0_59.groupId]

	if var0_59 then
		for iter0_59, iter1_59 in ipairs(var0_59.transform_list) do
			for iter2_59, iter3_59 in ipairs(iter1_59) do
				local var1_59 = pg.transform_data_template[iter3_59[2]]

				if var1_59.skin_id ~= 0 and arg0_59.transforms[iter3_59[2]] and arg0_59.transforms[iter3_59[2]].level == var1_59.max_level then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.getRemouldSkinId(arg0_60)
	local var0_60 = ShipGroup.getModSkin(arg0_60.groupId)

	if var0_60 then
		return var0_60.id
	end

	return nil
end

function var0_0.hasEquipmentSkinInPos(arg0_61, arg1_61)
	local var0_61 = arg0_61.equipments[arg1_61]

	return var0_61 and var0_61:hasSkin()
end

function var0_0.getPrefab(arg0_62)
	local var0_62 = arg0_62.skinId

	if arg0_62:hasEquipmentSkinInPos(var2_0) then
		local var1_62 = arg0_62:getEquip(var2_0)
		local var2_62 = var7_0[var1_62:getSkinId()].ship_skin_id

		var0_62 = var2_62 ~= 0 and var2_62 or var0_62
	end

	local var3_62 = pg.ship_skin_template[var0_62]

	assert(var3_62, "ship_skin_template not exist: " .. arg0_62.configId .. " " .. var0_62)

	return var3_62.prefab
end

function var0_0.getAttachmentPrefab(arg0_63)
	local var0_63 = {}

	for iter0_63, iter1_63 in ipairs(arg0_63.equipments) do
		if iter1_63 and iter1_63:hasSkinOrbit() then
			local var1_63 = iter1_63:getSkinId()

			var0_63[var1_63] = var7_0[var1_63]
		end
	end

	return var0_63
end

function var0_0.getPainting(arg0_64)
	local var0_64 = pg.ship_skin_template[arg0_64.skinId]

	assert(var0_64, "ship_skin_template not exist: " .. arg0_64.configId .. " " .. arg0_64.skinId)

	return var0_64.painting
end

function var0_0.GetSkinConfig(arg0_65)
	local var0_65 = pg.ship_skin_template[arg0_65.skinId]

	assert(var0_65, "ship_skin_template not exist: " .. arg0_65.configId .. " " .. arg0_65.skinId)

	return var0_65
end

function var0_0.getRemouldPainting(arg0_66)
	local var0_66 = pg.ship_skin_template[arg0_66:getRemouldSkinId()]

	assert(var0_66, "ship_skin_template not exist: " .. arg0_66.configId .. " " .. arg0_66.skinId)

	return var0_66.painting
end

function var0_0.updateStateInfo34(arg0_67, arg1_67, arg2_67)
	arg0_67.state_info_3 = arg1_67
	arg0_67.state_info_4 = arg2_67
end

function var0_0.hasStateInfo3Or4(arg0_68)
	return arg0_68.state_info_3 ~= 0 or arg0_68.state_info_4 ~= 0
end

function var0_0.isTestShip(arg0_69)
	return arg0_69.testShip
end

function var0_0.canUseTestShip(arg0_70, arg1_70)
	assert(arg0_70.testShip, "ship is not TestShip")

	return table.contains(arg0_70.testShip, arg1_70)
end

function var0_0.updateEquip(arg0_71, arg1_71, arg2_71)
	assert(arg2_71 == nil or arg2_71.count == 1)

	local var0_71 = arg0_71.equipments[arg1_71]

	arg0_71.equipments[arg1_71] = arg2_71 and Clone(arg2_71) or false

	local function var1_71(arg0_72)
		arg0_72 = CreateShell(arg0_72)
		arg0_72.shipId = arg0_71.id
		arg0_72.shipPos = arg1_71

		return arg0_72
	end

	if var0_71 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0_71, arg0_71.id, arg1_71)
		var0_71:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1_71(var0_71))
	end

	if arg2_71 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2_71, arg0_71.id, arg1_71)
		arg0_71:reletiveEquipSkin(arg1_71)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1_71(arg2_71))
	end
end

function var0_0.reletiveEquipSkin(arg0_73, arg1_73)
	if arg0_73.equipments[arg1_73] and arg0_73.equipmentSkins[arg1_73] ~= 0 then
		local var0_73 = pg.equip_skin_template[arg0_73.equipmentSkins[arg1_73]].equip_type
		local var1_73 = arg0_73.equipments[arg1_73]:getType()

		if table.contains(var0_73, var1_73) then
			arg0_73.equipments[arg1_73]:setSkinId(arg0_73.equipmentSkins[arg1_73])
		else
			arg0_73.equipments[arg1_73]:setSkinId(0)
		end
	elseif arg0_73.equipments[arg1_73] then
		arg0_73.equipments[arg1_73]:setSkinId(0)
	end
end

function var0_0.updateEquipmentSkin(arg0_74, arg1_74, arg2_74)
	if not arg1_74 then
		return
	end

	if arg2_74 and arg2_74 > 0 then
		local var0_74 = arg0_74:getSkinTypes(arg1_74)
		local var1_74 = pg.equip_skin_template[arg2_74].equip_type
		local var2_74 = false

		for iter0_74, iter1_74 in ipairs(var0_74) do
			for iter2_74, iter3_74 in ipairs(var1_74) do
				if iter1_74 == iter3_74 then
					var2_74 = true

					break
				end
			end
		end

		if not var2_74 then
			assert(var2_74, "部位" .. arg1_74 .. " 无法穿戴皮肤 " .. arg2_74)

			return
		end

		local var3_74 = arg0_74.equipments[arg1_74] and arg0_74.equipments[arg1_74]:getType() or false

		arg0_74.equipmentSkins[arg1_74] = arg2_74

		if var3_74 and table.contains(var1_74, var3_74) then
			arg0_74.equipments[arg1_74]:setSkinId(arg0_74.equipmentSkins[arg1_74])
		elseif var3_74 and not table.contains(var1_74, var3_74) then
			arg0_74.equipments[arg1_74]:setSkinId(0)
		end
	else
		arg0_74.equipmentSkins[arg1_74] = 0

		if arg0_74.equipments[arg1_74] then
			arg0_74.equipments[arg1_74]:setSkinId(0)
		end
	end
end

function var0_0.getEquip(arg0_75, arg1_75)
	return Clone(arg0_75.equipments[arg1_75])
end

function var0_0.getEquipSkins(arg0_76)
	return Clone(arg0_76.equipmentSkins)
end

function var0_0.getEquipSkin(arg0_77, arg1_77)
	return arg0_77.equipmentSkins[arg1_77]
end

function var0_0.getCanEquipSkin(arg0_78, arg1_78)
	local var0_78 = arg0_78:getSkinTypes(arg1_78)

	if var0_78 and #var0_78 then
		for iter0_78, iter1_78 in ipairs(var0_78) do
			if pg.equip_data_by_type[iter1_78].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0_0.checkCanEquipSkin(arg0_79, arg1_79, arg2_79)
	if not arg1_79 or not arg2_79 then
		return
	end

	local var0_79 = arg0_79:getSkinTypes(arg1_79)
	local var1_79 = pg.equip_skin_template[arg2_79].equip_type

	for iter0_79, iter1_79 in ipairs(var0_79) do
		if table.contains(var1_79, iter1_79) then
			return true
		end
	end

	return false
end

function var0_0.getSkinTypes(arg0_80, arg1_80)
	return pg.ship_data_template[arg0_80.configId]["equip_" .. arg1_80] or {}
end

function var0_0.updateState(arg0_81, arg1_81)
	arg0_81.state = arg1_81
end

function var0_0.addSkillExp(arg0_82, arg1_82, arg2_82)
	local var0_82 = arg0_82.skills[arg1_82] or {
		exp = 0,
		level = 1,
		id = arg1_82
	}
	local var1_82 = var0_82.level and var0_82.level or 1
	local var2_82 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1_82 == var2_82 then
		return
	end

	local var3_82 = var0_82.exp and arg2_82 + var0_82.exp or 0 + arg2_82

	while var3_82 >= pg.skill_need_exp[var1_82].exp do
		var3_82 = var3_82 - pg.skill_need_exp[var1_82].exp
		var1_82 = var1_82 + 1

		if var1_82 == var2_82 then
			var3_82 = 0

			break
		end
	end

	arg0_82:updateSkill({
		id = var0_82.id,
		level = var1_82,
		exp = var3_82
	})
end

function var0_0.upSkillLevelForMeta(arg0_83, arg1_83)
	local var0_83 = arg0_83.skills[arg1_83] or {
		exp = 0,
		level = 0,
		id = arg1_83
	}
	local var1_83 = arg0_83:isSkillLevelMax(arg1_83)
	local var2_83 = var0_83.level

	if not var1_83 then
		var2_83 = var2_83 + 1
	end

	arg0_83:updateSkill({
		exp = 0,
		id = var0_83.id,
		level = var2_83
	})
end

function var0_0.getMetaSkillLevelBySkillID(arg0_84, arg1_84)
	return (arg0_84.skills[arg1_84] or {
		exp = 0,
		level = 0,
		id = arg1_84
	}).level
end

function var0_0.isSkillLevelMax(arg0_85, arg1_85)
	local var0_85 = arg0_85.skills[arg1_85] or {
		exp = 0,
		level = 1,
		id = arg1_85
	}

	return (var0_85.level and var0_85.level or 1) >= pg.skill_data_template[arg1_85].max_level
end

function var0_0.isAllMetaSkillLevelMax(arg0_86)
	local var0_86 = true
	local var1_86 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_86.configId)

	for iter0_86, iter1_86 in ipairs(var1_86) do
		if not arg0_86:isSkillLevelMax(iter1_86) then
			var0_86 = false

			break
		end
	end

	return var0_86
end

function var0_0.isAllMetaSkillLock(arg0_87)
	local var0_87 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_87.configId)
	local var1_87 = true

	for iter0_87, iter1_87 in ipairs(var0_87) do
		if arg0_87:getMetaSkillLevelBySkillID(iter1_87) > 0 then
			var1_87 = false

			break
		end
	end

	return var1_87
end

function var0_0.bindConfigTable(arg0_88)
	return pg.ship_data_statistics
end

function var0_0.isAvaiable(arg0_89)
	return true
end

var0_0.PROPERTIES = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.Armor,
	AttributeType.Hit,
	AttributeType.Dodge,
	AttributeType.Speed,
	AttributeType.Luck,
	AttributeType.AntiSub
}
var0_0.PROPERTIES_ENHANCEMENT = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.Hit,
	AttributeType.Dodge,
	AttributeType.Speed,
	AttributeType.Luck,
	AttributeType.AntiSub
}
var0_0.DIVE_PROPERTIES = {
	AttributeType.OxyMax,
	AttributeType.OxyCost,
	AttributeType.OxyRecovery,
	AttributeType.OxyRecoveryBench,
	AttributeType.OxyRecoverySurface,
	AttributeType.OxyAttackDuration,
	AttributeType.OxyRaidDistance
}
var0_0.SONAR_PROPERTIES = {
	AttributeType.SonarRange
}

function var0_0.intimacyAdditions(arg0_90, arg1_90)
	local var0_90 = pg.intimacy_template[arg0_90:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0_90, iter1_90 in pairs(arg1_90) do
		if iter0_90 == AttributeType.Durability or iter0_90 == AttributeType.Cannon or iter0_90 == AttributeType.Torpedo or iter0_90 == AttributeType.AntiAircraft or iter0_90 == AttributeType.AntiSub or iter0_90 == AttributeType.Air or iter0_90 == AttributeType.Reload or iter0_90 == AttributeType.Hit or iter0_90 == AttributeType.Dodge then
			arg1_90[iter0_90] = arg1_90[iter0_90] * (var0_90 + 1)
		end
	end
end

function var0_0.getShipProperties(arg0_91)
	local var0_91 = arg0_91:getBaseProperties()

	if arg0_91:isBluePrintShip() then
		local var1_91 = arg0_91:getBluePrint()

		assert(var1_91, "blueprint can not be nil" .. arg0_91.configId)

		local var2_91 = var1_91:getTotalAdditions()

		for iter0_91, iter1_91 in pairs(var2_91) do
			var0_91[iter0_91] = var0_91[iter0_91] + calcFloor(iter1_91)
		end

		arg0_91:intimacyAdditions(var0_91)
	elseif arg0_91:isMetaShip() then
		assert(arg0_91.metaCharacter)

		for iter2_91, iter3_91 in pairs(var0_91) do
			var0_91[iter2_91] = var0_91[iter2_91] + arg0_91.metaCharacter:getAttrAddition(iter2_91)
		end

		arg0_91:intimacyAdditions(var0_91)
	else
		local var3_91 = pg.ship_data_template[arg0_91.configId].strengthen_id
		local var4_91 = var5_0[var3_91]

		for iter4_91, iter5_91 in pairs(arg0_91.strengthList) do
			local var5_91 = ShipModAttr.ATTR_TO_INDEX[iter4_91]
			local var6_91 = math.min(iter5_91, var4_91.durability[var5_91] * var4_91.level_exp[var5_91])
			local var7_91 = math.max(arg0_91:getModExpRatio(iter4_91), 1)

			var0_91[iter4_91] = var0_91[iter4_91] + calcFloor(var6_91 / var7_91)
		end

		arg0_91:intimacyAdditions(var0_91)

		for iter6_91, iter7_91 in pairs(arg0_91.transforms) do
			local var8_91 = pg.transform_data_template[iter7_91.id].effect

			for iter8_91 = 1, iter7_91.level do
				local var9_91 = var8_91[iter8_91] or {}

				for iter9_91, iter10_91 in pairs(var0_91) do
					if var9_91[iter9_91] then
						var0_91[iter9_91] = var0_91[iter9_91] + var9_91[iter9_91]
					end
				end
			end
		end
	end

	return var0_91
end

function var0_0.getTechNationAddition(arg0_92, arg1_92)
	local var0_92 = getProxy(TechnologyNationProxy)
	local var1_92 = arg0_92:getConfig("type")

	if var1_92 == ShipType.DaoQuV or var1_92 == ShipType.DaoQuM then
		var1_92 = ShipType.QuZhu
	end

	return var0_92:getShipAddition(var1_92, arg1_92)
end

function var0_0.getTechNationMaxAddition(arg0_93, arg1_93)
	local var0_93 = getProxy(TechnologyNationProxy)
	local var1_93 = arg0_93:getConfig("type")

	return var0_93:getShipMaxAddition(var1_93, arg1_93)
end

function var0_0.getEquipProficiencyByPos(arg0_94, arg1_94)
	return arg0_94:getEquipProficiencyList()[arg1_94]
end

function var0_0.getEquipProficiencyList(arg0_95)
	local var0_95 = arg0_95:getConfigTable()
	local var1_95 = Clone(var0_95.equipment_proficiency)

	if arg0_95:isBluePrintShip() then
		local var2_95 = arg0_95:getBluePrint()

		assert(var2_95, "blueprint can not be nil >>>" .. arg0_95.groupId)

		var1_95 = var2_95:getEquipProficiencyList(arg0_95)
	else
		for iter0_95, iter1_95 in ipairs(var1_95) do
			local var3_95 = 0

			for iter2_95, iter3_95 in pairs(arg0_95.transforms) do
				local var4_95 = pg.transform_data_template[iter3_95.id].effect

				for iter4_95 = 1, iter3_95.level do
					local var5_95 = var4_95[iter4_95] or {}

					if var5_95["equipment_proficiency_" .. iter0_95] then
						var3_95 = var3_95 + var5_95["equipment_proficiency_" .. iter0_95]
					end
				end
			end

			var1_95[iter0_95] = iter1_95 + var3_95
		end
	end

	return var1_95
end

function var0_0.getBaseProperties(arg0_96)
	local var0_96 = arg0_96:getConfigTable()

	assert(var0_96, "配置表没有这艘船" .. arg0_96.configId)

	local var1_96 = {}
	local var2_96 = {}

	for iter0_96, iter1_96 in ipairs(var0_0.PROPERTIES) do
		var1_96[iter1_96] = arg0_96:getGrowthForAttr(iter1_96)
		var2_96[iter1_96] = var1_96[iter1_96]
	end

	for iter2_96, iter3_96 in ipairs(arg0_96:getConfig("lock")) do
		var2_96[iter3_96] = var1_96[iter3_96]
	end

	for iter4_96, iter5_96 in ipairs(var0_0.DIVE_PROPERTIES) do
		var2_96[iter5_96] = var0_96[iter5_96]
	end

	for iter6_96, iter7_96 in ipairs(var0_0.SONAR_PROPERTIES) do
		var2_96[iter7_96] = 0
	end

	return var2_96
end

function var0_0.getGrowthForAttr(arg0_97, arg1_97)
	local var0_97 = arg0_97:getConfigTable()
	local var1_97 = table.indexof(var0_0.PROPERTIES, arg1_97)
	local var2_97 = pg.gameset.extra_attr_level_limit.key_value
	local var3_97 = var0_97.attrs[var1_97] + (arg0_97.level - 1) * var0_97.attrs_growth[var1_97] / 1000

	if var2_97 < arg0_97.level then
		var3_97 = var3_97 + (arg0_97.level - var2_97) * var0_97.attrs_growth_extra[var1_97] / 1000
	end

	return var3_97
end

function var0_0.isMaxStar(arg0_98)
	return arg0_98:getStar() >= arg0_98:getMaxStar()
end

function var0_0.IsMaxStarByTmpID(arg0_99)
	local var0_99 = pg.ship_data_template[arg0_99]

	return var0_99.star >= var0_99.star_max
end

function var0_0.IsSpweaponUnlock(arg0_100)
	if not arg0_100:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0_0.getModProperties(arg0_101, arg1_101)
	return arg0_101.strengthList[arg1_101] or 0
end

function var0_0.addModAttrExp(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg0_102:getModAttrTopLimit(arg1_102)

	if var0_102 == 0 then
		return
	end

	local var1_102 = arg0_102:getModExpRatio(arg1_102)
	local var2_102 = arg0_102:getModProperties(arg1_102)

	if var2_102 + arg2_102 > var0_102 * var1_102 then
		arg0_102.strengthList[arg1_102] = var0_102 * var1_102
	else
		arg0_102.strengthList[arg1_102] = var2_102 + arg2_102
	end
end

function var0_0.getNeedModExp(arg0_103)
	local var0_103 = {}

	for iter0_103, iter1_103 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1_103 = arg0_103:getModAttrTopLimit(iter1_103)

		if var1_103 == 0 then
			var0_103[iter1_103] = 0
		else
			var0_103[iter1_103] = var1_103 * arg0_103:getModExpRatio(iter1_103) - arg0_103:getModProperties(iter1_103)
		end
	end

	return var0_103
end

function var0_0.attrVertify(arg0_104)
	if not BayProxy.checkShiplevelVertify(arg0_104) then
		return false
	end

	for iter0_104, iter1_104 in ipairs(arg0_104.equipments) do
		if iter1_104 and not iter1_104:vertify() then
			return false
		end
	end

	return true
end

function var0_0.getEquipmentProperties(arg0_105)
	local var0_105 = {}
	local var1_105 = {}

	for iter0_105, iter1_105 in ipairs(var0_0.PROPERTIES) do
		var0_105[iter1_105] = 0
	end

	for iter2_105, iter3_105 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_105[iter3_105] = 0
	end

	for iter4_105, iter5_105 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_105[iter5_105] = 0
	end

	for iter6_105, iter7_105 in ipairs(var0_0.PROPERTIES_ENHANCEMENT) do
		var1_105[iter7_105] = 0
	end

	var0_105[AttributeType.AirDominate] = 0
	var0_105[AttributeType.AntiSiren] = 0

	local var2_105 = arg0_105:getActiveEquipments()

	for iter8_105, iter9_105 in ipairs(var2_105) do
		if iter9_105 then
			local var3_105 = iter9_105:GetAttributes()

			for iter10_105, iter11_105 in ipairs(var3_105) do
				if iter11_105 and var0_105[iter11_105.type] then
					var0_105[iter11_105.type] = var0_105[iter11_105.type] + iter11_105.value
				end
			end

			local var4_105 = iter9_105:GetPropertyRate()

			for iter12_105, iter13_105 in pairs(var4_105) do
				var1_105[iter12_105] = math.max(var1_105[iter12_105], iter13_105)
			end

			local var5_105 = iter9_105:GetSonarProperty()

			if var5_105 then
				for iter14_105, iter15_105 in pairs(var5_105) do
					var0_105[iter14_105] = var0_105[iter14_105] + iter15_105
				end
			end

			local var6_105 = iter9_105:GetAntiSirenPower()

			if var6_105 then
				var0_105[AttributeType.AntiSiren] = var0_105[AttributeType.AntiSiren] + var6_105 / 10000
			end
		end
	end

	;(function()
		local var0_106 = arg0_105:GetSpWeapon()

		if not var0_106 then
			return
		end

		local var1_106 = var0_106:GetPropertiesInfo().attrs

		for iter0_106, iter1_106 in ipairs(var1_106) do
			if iter1_106 and var0_105[iter1_106.type] then
				var0_105[iter1_106.type] = var0_105[iter1_106.type] + iter1_106.value
			end
		end
	end)()

	for iter16_105, iter17_105 in pairs(var1_105) do
		var1_105[iter16_105] = iter17_105 + 1
	end

	return var0_105, var1_105
end

function var0_0.getSkillEffects(arg0_107)
	local var0_107 = arg0_107:getShipSkillEffects()

	_.each(arg0_107:getEquipmentSkillEffects(), function(arg0_108)
		table.insert(var0_107, arg0_108)
	end)

	return var0_107
end

function var0_0.getShipSkillEffects(arg0_109)
	local var0_109 = {}
	local var1_109 = arg0_109:getSkillList()

	for iter0_109, iter1_109 in ipairs(var1_109) do
		local var2_109 = arg0_109:RemapSkillId(iter1_109)
		local var3_109 = require("GameCfg.buff.buff_" .. var2_109)

		arg0_109:FilterActiveSkill(var0_109, var3_109, arg0_109.skills[iter1_109])
	end

	return var0_109
end

function var0_0.getEquipmentSkillEffects(arg0_110)
	local var0_110 = {}
	local var1_110 = arg0_110:getActiveEquipments()

	for iter0_110, iter1_110 in ipairs(var1_110) do
		local var2_110
		local var3_110 = iter1_110 and iter1_110:getConfig("skill_id")[1]

		if var3_110 then
			var2_110 = require("GameCfg.buff.buff_" .. var3_110)
		end

		arg0_110:FilterActiveSkill(var0_110, var2_110)
	end

	;(function()
		local var0_111 = arg0_110:GetSpWeapon()
		local var1_111 = var0_111 and var0_111:GetEffect() or 0
		local var2_111

		if var1_111 > 0 then
			var2_111 = require("GameCfg.buff.buff_" .. var1_111)
		end

		arg0_110:FilterActiveSkill(var0_110, var2_111)
	end)()

	return var0_110
end

function var0_0.FilterActiveSkill(arg0_112, arg1_112, arg2_112, arg3_112)
	if not arg2_112 or not arg2_112.const_effect_list then
		return
	end

	for iter0_112 = 1, #arg2_112.const_effect_list do
		local var0_112 = arg2_112.const_effect_list[iter0_112]
		local var1_112 = var0_112.trigger
		local var2_112 = var0_112.arg_list
		local var3_112 = 1

		if arg3_112 then
			var3_112 = arg3_112.level

			local var4_112 = arg2_112[var3_112].const_effect_list

			if var4_112 and var4_112[iter0_112] then
				var1_112 = var4_112[iter0_112].trigger or var1_112
				var2_112 = var4_112[iter0_112].arg_list or var2_112
			end
		end

		local var5_112 = true

		for iter1_112, iter2_112 in pairs(var1_112) do
			if arg0_112.triggers[iter1_112] ~= iter2_112 then
				var5_112 = false

				break
			end
		end

		if var5_112 then
			table.insert(arg1_112, {
				type = var0_112.type,
				arg_list = var2_112,
				level = var3_112
			})
		end
	end
end

function var0_0.getEquipmentGearScore(arg0_113)
	local var0_113 = 0
	local var1_113 = arg0_113:getActiveEquipments()

	for iter0_113, iter1_113 in ipairs(var1_113) do
		if iter1_113 then
			var0_113 = var0_113 + iter1_113:GetGearScore()
		end
	end

	return var0_113
end

function var0_0.getProperties(arg0_114, arg1_114, arg2_114, arg3_114, arg4_114)
	local var0_114 = arg1_114 or {}
	local var1_114 = arg0_114:getConfig("nationality")
	local var2_114 = arg0_114:getConfig("type")
	local var3_114 = arg0_114:getShipProperties()
	local var4_114, var5_114 = arg0_114:getEquipmentProperties()
	local var6_114
	local var7_114
	local var8_114

	if arg3_114 and arg0_114:getFlag("inWorld") then
		local var9_114 = WorldConst.FetchWorldShip(arg0_114.id)

		var6_114, var7_114 = var9_114:GetShipBuffProperties()
		var8_114 = var9_114:GetShipPowerBuffProperties()
	end

	for iter0_114, iter1_114 in ipairs(var0_0.PROPERTIES) do
		local var10_114 = 0
		local var11_114 = 0

		for iter2_114, iter3_114 in pairs(var0_114) do
			var10_114 = var10_114 + iter3_114:getAttrRatioAddition(iter1_114, var1_114, var2_114) / 100
			var11_114 = var11_114 + iter3_114:getAttrValueAddition(iter1_114, var1_114, var2_114)
		end

		local var12_114 = var10_114 + (var5_114[iter1_114] or 1)
		local var13_114 = var7_114 and var7_114[iter1_114] or 1
		local var14_114 = var6_114 and var6_114[iter1_114] or 0

		if iter1_114 == AttributeType.Speed then
			var3_114[iter1_114] = var3_114[iter1_114] * var12_114 * var13_114 + var11_114 + var4_114[iter1_114] + var14_114
		else
			var3_114[iter1_114] = calcFloor(calcFloor(var3_114[iter1_114]) * var12_114 * var13_114) + var11_114 + var4_114[iter1_114] + var14_114
		end
	end

	if not arg2_114 and arg0_114:isMaxStar() then
		for iter4_114, iter5_114 in pairs(var3_114) do
			local var15_114 = arg4_114 and arg0_114:getTechNationMaxAddition(iter4_114) or arg0_114:getTechNationAddition(iter4_114)

			var3_114[iter4_114] = var3_114[iter4_114] + var15_114
		end
	end

	for iter6_114, iter7_114 in ipairs(var0_0.DIVE_PROPERTIES) do
		var3_114[iter7_114] = var3_114[iter7_114] + var4_114[iter7_114]
	end

	for iter8_114, iter9_114 in ipairs(var0_0.SONAR_PROPERTIES) do
		var3_114[iter9_114] = var3_114[iter9_114] + var4_114[iter9_114]
	end

	if arg3_114 then
		var3_114[AttributeType.AntiSiren] = (var3_114[AttributeType.AntiSiren] or 0) + var4_114[AttributeType.AntiSiren]
	end

	if var8_114 then
		for iter10_114, iter11_114 in pairs(var8_114) do
			if var3_114[iter10_114] then
				if iter10_114 == AttributeType.Speed then
					var3_114[iter10_114] = var3_114[iter10_114] * iter11_114
				else
					var3_114[iter10_114] = math.floor(var3_114[iter10_114] * iter11_114)
				end
			end
		end
	end

	return var3_114
end

function var0_0.getTransGearScore(arg0_115)
	local var0_115 = 0
	local var1_115 = pg.transform_data_template

	for iter0_115, iter1_115 in pairs(arg0_115.transforms) do
		for iter2_115 = 1, iter1_115.level do
			var0_115 = var0_115 + (var1_115[iter1_115.id].gear_score[iter2_115] or 0)
		end
	end

	return var0_115
end

function var0_0.getShipCombatPower(arg0_116, arg1_116)
	local var0_116 = arg0_116:getProperties(arg1_116, nil, nil, true)
	local var1_116 = var0_116[AttributeType.Durability] / 5 + var0_116[AttributeType.Cannon] + var0_116[AttributeType.Torpedo] + var0_116[AttributeType.AntiAircraft] + var0_116[AttributeType.Air] + var0_116[AttributeType.AntiSub] + var0_116[AttributeType.Reload] + var0_116[AttributeType.Hit] * 2 + var0_116[AttributeType.Dodge] * 2 + var0_116[AttributeType.Speed] + arg0_116:getEquipmentGearScore() + arg0_116:getTransGearScore()

	return math.floor(var1_116)
end

function var0_0.cosumeEnergy(arg0_117, arg1_117)
	arg0_117:setEnergy(math.max(arg0_117:getEnergy() - arg1_117, 0))
end

function var0_0.addEnergy(arg0_118, arg1_118)
	arg0_118:setEnergy(arg0_118:getEnergy() + arg1_118)
end

function var0_0.setEnergy(arg0_119, arg1_119)
	arg0_119.energy = arg1_119
end

function var0_0.setLikability(arg0_120, arg1_120)
	assert(arg1_120 >= 0 and arg1_120 <= arg0_120.maxIntimacy, "intimacy value invaild" .. arg1_120)
	arg0_120:setIntimacy(arg1_120)
end

function var0_0.addLikability(arg0_121, arg1_121)
	local var0_121 = Mathf.Clamp(arg0_121:getIntimacy() + arg1_121, 0, arg0_121.maxIntimacy)

	arg0_121:setIntimacy(var0_121)
end

function var0_0.setIntimacy(arg0_122, arg1_122)
	if arg1_122 > 10000 and not arg0_122.propose then
		arg1_122 = 10000
	end

	arg0_122.intimacy = arg1_122

	if not arg0_122:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0_122.groupId]:updateMaxIntimacy(arg0_122:getIntimacy())
	end
end

function var0_0.getLevelExpConfig(arg0_123, arg1_123)
	if arg0_123:getConfig("rarity") == ShipRarity.SSR then
		local var0_123 = Clone(getConfigFromLevel1(var6_0, arg1_123 or arg0_123.level))

		var0_123.exp = var0_123.exp_ur
		var0_123.exp_start = var0_123.exp_ur_start
		var0_123.exp_interval = var0_123.exp_ur_interval
		var0_123.exp_end = var0_123.exp_ur_end

		return var0_123
	else
		return getConfigFromLevel1(var6_0, arg1_123 or arg0_123.level)
	end
end

function var0_0.getExp(arg0_124)
	local var0_124 = arg0_124:getMaxLevel()

	if arg0_124.level == var0_124 and LOCK_FULL_EXP then
		return 0
	end

	return arg0_124.exp
end

function var0_0.getProficiency(arg0_125)
	return arg0_125.proficiency
end

function var0_0.addExp(arg0_126, arg1_126, arg2_126)
	local var0_126 = arg0_126:getMaxLevel()

	if arg0_126.level == var0_126 then
		if arg0_126.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2_126 or not arg0_126:CanAccumulateExp() then
			arg1_126 = 0
		end
	end

	arg0_126.exp = arg0_126.exp + arg1_126

	local var1_126 = false

	while arg0_126:canLevelUp() do
		arg0_126.exp = arg0_126.exp - arg0_126:getLevelExpConfig().exp_interval
		arg0_126.level = math.min(arg0_126.level + 1, var0_126)
		var1_126 = true
	end

	if arg0_126.level == var0_126 then
		if arg2_126 and arg0_126:CanAccumulateExp() then
			arg0_126.exp = math.min(arg0_126.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1_126 then
			arg0_126.exp = 0
		end
	end
end

function var0_0.getMaxLevel(arg0_127)
	return arg0_127.maxLevel
end

function var0_0.canLevelUp(arg0_128)
	local var0_128 = arg0_128:getLevelExpConfig(arg0_128.level + 1)
	local var1_128 = arg0_128:getMaxLevel() <= arg0_128.level

	return var0_128 and arg0_128:getLevelExpConfig().exp_interval <= arg0_128.exp and not var1_128
end

function var0_0.getConfigMaxLevel(arg0_129)
	return var6_0.all[#var6_0.all]
end

function var0_0.isConfigMaxLevel(arg0_130)
	return arg0_130.level == arg0_130:getConfigMaxLevel()
end

function var0_0.updateMaxLevel(arg0_131, arg1_131)
	local var0_131 = arg0_131:getConfigMaxLevel()

	arg0_131.maxLevel = math.max(math.min(var0_131, arg1_131), arg0_131.maxLevel)
end

function var0_0.getNextMaxLevel(arg0_132)
	local var0_132 = arg0_132:getConfigMaxLevel()

	for iter0_132 = arg0_132:getMaxLevel() + 1, var0_132 do
		if var6_0[iter0_132].level_limit == 1 then
			return iter0_132
		end
	end
end

function var0_0.canUpgrade(arg0_133)
	if arg0_133:isMetaShip() or arg0_133:isBluePrintShip() then
		return false
	else
		local var0_133 = var8_0[arg0_133.configId]

		assert(var0_133, "不存在配置" .. arg0_133.configId)

		return not arg0_133:isMaxStar() and arg0_133.level >= var0_133.level
	end
end

function var0_0.isReachNextMaxLevel(arg0_134)
	return arg0_134.level == arg0_134:getMaxLevel() and arg0_134:CanAccumulateExp() and arg0_134:getNextMaxLevel() ~= nil
end

function var0_0.isAwakening(arg0_135)
	return arg0_135:isReachNextMaxLevel() and arg0_135.level < var4_0
end

function var0_0.isAwakening2(arg0_136)
	return arg0_136:isReachNextMaxLevel() and arg0_136.level >= var4_0
end

function var0_0.notMaxLevelForFilter(arg0_137)
	return arg0_137.level ~= arg0_137:getMaxLevel()
end

function var0_0.getNextMaxLevelConsume(arg0_138)
	local var0_138 = arg0_138:getMaxLevel()
	local var1_138 = var6_0[var0_138]["need_item_rarity" .. arg0_138:getConfig("rarity")]

	assert(var1_138, "items  can not be nil")

	return _.map(var1_138, function(arg0_139)
		return {
			type = arg0_139[1],
			id = arg0_139[2],
			count = arg0_139[3]
		}
	end)
end

function var0_0.canUpgradeMaxLevel(arg0_140)
	if not arg0_140:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0_140 = getProxy(PlayerProxy):getData()
		local var1_140 = getProxy(BagProxy)
		local var2_140 = arg0_140:getNextMaxLevelConsume()

		for iter0_140, iter1_140 in pairs(var2_140) do
			if iter1_140.type == DROP_TYPE_RESOURCE then
				if var0_140:getResById(iter1_140.id) < iter1_140.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1_140.type == DROP_TYPE_ITEM and var1_140:getItemCountById(iter1_140.id) < iter1_140.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.CanAccumulateExp(arg0_141)
	return pg.ship_data_template[arg0_141.configId].can_get_proficency == 1
end

function var0_0.getTotalExp(arg0_142)
	return arg0_142:getLevelExpConfig().exp_start + arg0_142.exp
end

function var0_0.getStartBattleExpend(arg0_143)
	if table.contains(TeamType.SubShipType, arg0_143:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0_143.configId].oil_at_start
	end
end

function var0_0.getEndBattleExpend(arg0_144)
	local var0_144 = pg.ship_data_template[arg0_144.configId]
	local var1_144 = arg0_144:getLevelExpConfig()

	return (math.floor(var0_144.oil_at_end * var1_144.fight_oil_ratio / 10000))
end

function var0_0.getBattleTotalExpend(arg0_145)
	return arg0_145:getStartBattleExpend() + arg0_145:getEndBattleExpend()
end

function var0_0.getShipAmmo(arg0_146)
	local var0_146 = arg0_146:getConfig(AttributeType.Ammo)

	for iter0_146, iter1_146 in pairs(arg0_146:getAllSkills()) do
		local var1_146 = tonumber(iter0_146 .. string.format("%.2d", iter1_146.level))
		local var2_146 = pg.skill_benefit_template[var1_146]

		if var2_146 and arg0_146:IsBenefitSkillActive(var2_146) and (var2_146.type == var0_0.BENEFIT_EQUIP or var2_146.type == var0_0.BENEFIT_SKILL) then
			var0_146 = var0_146 + defaultValue(var2_146.effect[1], 0)
		end
	end

	local var3_146 = arg0_146:getActiveEquipments()

	for iter2_146, iter3_146 in ipairs(var3_146) do
		local var4_146 = iter3_146 and iter3_146:getConfig("equip_parameters").ammo

		if var4_146 then
			var0_146 = var0_146 + var4_146
		end
	end

	return var0_146
end

function var0_0.getHuntingLv(arg0_147)
	local var0_147 = arg0_147:getConfig("huntingrange_level")

	for iter0_147, iter1_147 in pairs(arg0_147:getAllSkills()) do
		local var1_147 = tonumber(iter0_147 .. string.format("%.2d", iter1_147.level))
		local var2_147 = pg.skill_benefit_template[var1_147]

		if var2_147 and arg0_147:IsBenefitSkillActive(var2_147) and (var2_147.type == var0_0.BENEFIT_EQUIP or var2_147.type == var0_0.BENEFIT_SKILL) then
			var0_147 = var0_147 + defaultValue(var2_147.effect[2], 0)
		end
	end

	local var3_147 = arg0_147:getActiveEquipments()

	for iter2_147, iter3_147 in ipairs(var3_147) do
		local var4_147 = iter3_147 and iter3_147:getConfig("equip_parameters").hunting_lv

		if var4_147 then
			var0_147 = var0_147 + var4_147
		end
	end

	return (math.min(var0_147, arg0_147:getMaxHuntingLv()))
end

function var0_0.getMapAuras(arg0_148)
	local var0_148 = {}

	for iter0_148, iter1_148 in pairs(arg0_148:getAllSkills()) do
		local var1_148 = tonumber(iter0_148 .. string.format("%.2d", iter1_148.level))
		local var2_148 = pg.skill_benefit_template[var1_148]

		if var2_148 and arg0_148:IsBenefitSkillActive(var2_148) and var2_148.type == var0_0.BENEFIT_MAP_AURA then
			local var3_148 = {
				id = var2_148.effect[1],
				level = iter1_148.level
			}

			table.insert(var0_148, var3_148)
		end
	end

	return var0_148
end

function var0_0.getMapAids(arg0_149)
	local var0_149 = {}

	for iter0_149, iter1_149 in pairs(arg0_149:getAllSkills()) do
		local var1_149 = tonumber(iter0_149 .. string.format("%.2d", iter1_149.level))
		local var2_149 = pg.skill_benefit_template[var1_149]

		if var2_149 and arg0_149:IsBenefitSkillActive(var2_149) and var2_149.type == var0_0.BENEFIT_AID then
			local var3_149 = {
				id = var2_149.effect[1],
				level = iter1_149.level
			}

			table.insert(var0_149, var3_149)
		end
	end

	return var0_149
end

var0_0.BENEFIT_SKILL = 2
var0_0.BENEFIT_EQUIP = 3
var0_0.BENEFIT_MAP_AURA = 4
var0_0.BENEFIT_AID = 5

function var0_0.IsBenefitSkillActive(arg0_150, arg1_150)
	local var0_150 = false

	if arg1_150.type == var0_0.BENEFIT_SKILL then
		if not arg1_150.limit[1] or arg1_150.limit[1] == arg0_150.triggers.TeamNumbers then
			var0_150 = true
		end
	elseif arg1_150.type == var0_0.BENEFIT_EQUIP then
		local var1_150 = arg1_150.limit
		local var2_150 = arg0_150:getAllEquipments()

		for iter0_150, iter1_150 in ipairs(var2_150) do
			if iter1_150 and table.contains(var1_150, iter1_150:getConfig("id")) then
				var0_150 = true

				break
			end
		end
	elseif arg1_150.type == var0_0.BENEFIT_MAP_AURA then
		if arg0_150.hpRant and arg0_150.hpRant > 0 then
			return true
		end
	elseif arg1_150.type == var0_0.BENEFIT_AID and arg0_150.hpRant and arg0_150.hpRant > 0 then
		return true
	end

	return var0_150
end

function var0_0.getMaxHuntingLv(arg0_151)
	return #arg0_151:getConfig("hunting_range")
end

function var0_0.getHuntingRange(arg0_152, arg1_152)
	local var0_152 = arg0_152:getConfig("hunting_range")
	local var1_152 = Clone(var0_152[1])
	local var2_152 = arg1_152 or arg0_152:getHuntingLv()
	local var3_152 = math.min(var2_152, arg0_152:getMaxHuntingLv())

	for iter0_152 = 2, var3_152 do
		_.each(var0_152[iter0_152], function(arg0_153)
			table.insert(var1_152, {
				arg0_153[1],
				arg0_153[2]
			})
		end)
	end

	return var1_152
end

function var0_0.getTriggerSkills(arg0_154)
	local var0_154 = {}
	local var1_154 = arg0_154:getSkillEffects()

	_.each(var1_154, function(arg0_155)
		if arg0_155.type == "AddBuff" and arg0_155.arg_list and arg0_155.arg_list.buff_id then
			local var0_155 = arg0_155.arg_list.buff_id

			var0_154[var0_155] = {
				id = var0_155,
				level = arg0_155.level
			}
		end
	end)

	return var0_154
end

function var0_0.GetEquipmentSkills(arg0_156)
	local var0_156 = {}
	local var1_156 = arg0_156:getActiveEquipments()

	for iter0_156, iter1_156 in ipairs(var1_156) do
		if iter1_156 then
			local var2_156 = iter1_156:getConfig("skill_id")[1]

			if var2_156 then
				var0_156[var2_156] = {
					level = 1,
					id = var2_156
				}
			end
		end
	end

	;(function()
		local var0_157 = arg0_156:GetSpWeapon()
		local var1_157 = var0_157 and var0_157:GetEffect() or 0

		if var1_157 > 0 then
			var0_156[var1_157] = {
				level = 1,
				id = var1_157
			}
		end
	end)()

	return var0_156
end

function var0_0.getAllSkills(arg0_158)
	local var0_158 = Clone(arg0_158.skills)

	for iter0_158, iter1_158 in pairs(arg0_158:GetEquipmentSkills()) do
		var0_158[iter0_158] = iter1_158
	end

	for iter2_158, iter3_158 in pairs(arg0_158:getTriggerSkills()) do
		var0_158[iter2_158] = iter3_158
	end

	return var0_158
end

function var0_0.isSameKind(arg0_159, arg1_159)
	return pg.ship_data_template[arg0_159.configId].group_type == pg.ship_data_template[arg1_159.configId].group_type
end

function var0_0.GetLockState(arg0_160)
	return arg0_160.lockState
end

function var0_0.IsLocked(arg0_161)
	return arg0_161.lockState == var0_0.LOCK_STATE_LOCK
end

function var0_0.SetLockState(arg0_162, arg1_162)
	arg0_162.lockState = arg1_162
end

function var0_0.GetPreferenceTag(arg0_163)
	return arg0_163.preferenceTag or 0
end

function var0_0.IsPreferenceTag(arg0_164)
	return arg0_164:GetPreferenceTag() == var0_0.PREFERENCE_TAG_COMMON
end

function var0_0.SetPreferenceTag(arg0_165, arg1_165)
	arg0_165.preferenceTag = arg1_165
end

function var0_0.calReturnRes(arg0_166)
	local var0_166 = pg.ship_data_by_type[arg0_166:getShipType()]
	local var1_166 = var0_166.distory_resource_gold_ratio
	local var2_166 = var0_166.distory_resource_oil_ratio
	local var3_166 = pg.ship_data_by_star[arg0_166:getConfig("rarity")].destory_item

	return var1_166, 0, var3_166
end

function var0_0.getRarity(arg0_167)
	local var0_167 = arg0_167:getConfig("rarity")

	if arg0_167:isRemoulded() then
		var0_167 = var0_167 + 1
	end

	return var0_167
end

function var0_0.getExchangePrice(arg0_168)
	local var0_168 = arg0_168:getConfig("rarity")

	return pg.ship_data_by_star[var0_168].exchange_price
end

function var0_0.updateSkill(arg0_169, arg1_169)
	local var0_169 = arg1_169.skill_id or arg1_169.id
	local var1_169 = arg1_169.skill_lv or arg1_169.lv or arg1_169.level
	local var2_169 = arg1_169.skill_exp or arg1_169.exp

	arg0_169.skills[var0_169] = {
		id = var0_169,
		level = var1_169,
		exp = var2_169
	}
end

function var0_0.canEquipAtPos(arg0_170, arg1_170, arg2_170)
	local var0_170, var1_170 = arg0_170:isForbiddenAtPos(arg1_170, arg2_170)

	if var0_170 then
		return false, var1_170
	end

	for iter0_170, iter1_170 in ipairs(arg0_170.equipments) do
		if iter1_170 and iter0_170 ~= arg2_170 and iter1_170:getConfig("equip_limit") ~= 0 and arg1_170:getConfig("equip_limit") == iter1_170:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0_0.isForbiddenAtPos(arg0_171, arg1_171, arg2_171)
	local var0_171 = pg.ship_data_template[arg0_171.configId]

	assert(var0_171, "can not find ship in ship_data_templtae: " .. arg0_171.configId)

	local var1_171 = var0_171["equip_" .. arg2_171]

	if not table.contains(var1_171, arg1_171:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1_171:getConfig("ship_type_forbidden"), arg0_171:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0_0.canEquipCommander(arg0_172, arg1_172)
	if arg1_172:getShipType() ~= arg0_172:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0_0.upgrade(arg0_173)
	local var0_173 = pg.ship_data_transform[arg0_173.configId]

	if var0_173.trans_id and var0_173.trans_id > 0 then
		arg0_173.configId = var0_173.trans_id
		arg0_173.star = arg0_173:getConfig("star")
	end
end

function var0_0.getTeamType(arg0_174)
	return TeamType.GetTeamFromShipType(arg0_174:getShipType())
end

function var0_0.getFleetName(arg0_175)
	local var0_175 = arg0_175:getTeamType()

	return var1_0[var0_175]
end

function var0_0.getMaxConfigId(arg0_176)
	local var0_176 = pg.ship_data_template
	local var1_176

	for iter0_176 = 4, 1, -1 do
		local var2_176 = tonumber(arg0_176.groupId .. iter0_176)

		if var0_176[var2_176] then
			var1_176 = var2_176

			break
		end
	end

	return var1_176
end

function var0_0.getFlag(arg0_177, arg1_177, arg2_177)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_177.id, arg1_177, arg2_177)
end

function var0_0.hasAnyFlag(arg0_178, arg1_178)
	return _.any(arg1_178, function(arg0_179)
		return arg0_178:getFlag(arg0_179)
	end)
end

function var0_0.isBreakOut(arg0_180)
	return arg0_180.configId % 10 > 1
end

function var0_0.fateSkillChange(arg0_181, arg1_181)
	if not arg0_181.skillChangeList then
		arg0_181.skillChangeList = arg0_181:isBluePrintShip() and arg0_181:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_181, iter1_181 in ipairs(arg0_181.skillChangeList) do
		if iter1_181[1] == arg1_181 and arg0_181.skills[iter1_181[2]] then
			return iter1_181[2]
		end
	end

	return arg1_181
end

function var0_0.RemapSkillId(arg0_182, arg1_182)
	local var0_182 = arg0_182:GetSpWeapon()

	if var0_182 then
		return var0_182:RemapSkillId(arg1_182)
	end

	return arg1_182
end

function var0_0.getSkillList(arg0_183)
	local var0_183 = pg.ship_data_template[arg0_183.configId]
	local var1_183 = Clone(var0_183.buff_list_display)
	local var2_183 = Clone(var0_183.buff_list)
	local var3_183 = pg.ship_data_trans[arg0_183.groupId]
	local var4_183 = 0

	if var3_183 and var3_183.skill_id ~= 0 then
		local var5_183 = var3_183.skill_id
		local var6_183 = pg.transform_data_template[var5_183]

		if arg0_183.transforms[var5_183] and var6_183.skill_id ~= 0 then
			table.insert(var2_183, var6_183.skill_id)
		end
	end

	local var7_183 = {}

	for iter0_183, iter1_183 in ipairs(var1_183) do
		for iter2_183, iter3_183 in ipairs(var2_183) do
			if iter1_183 == iter3_183 then
				table.insert(var7_183, arg0_183:fateSkillChange(iter1_183))
			end
		end
	end

	return var7_183
end

function var0_0.getModAttrTopLimit(arg0_184, arg1_184)
	local var0_184 = ShipModAttr.ATTR_TO_INDEX[arg1_184]
	local var1_184 = pg.ship_data_template[arg0_184.configId].strengthen_id
	local var2_184 = pg.ship_data_strengthen[var1_184].durability[var0_184]

	return calcFloor((3 + 7 * (math.min(arg0_184.level, 100) / 100)) * var2_184 * 0.1)
end

function var0_0.leftModAdditionPoint(arg0_185, arg1_185)
	local var0_185 = arg0_185:getModProperties(arg1_185)
	local var1_185 = arg0_185:getModExpRatio(arg1_185)
	local var2_185 = arg0_185:getModAttrTopLimit(arg1_185)
	local var3_185 = calcFloor(var0_185 / var1_185)

	return math.max(0, var2_185 - var3_185)
end

function var0_0.getModAttrBaseMax(arg0_186, arg1_186)
	if not table.contains(arg0_186:getConfig("lock"), arg1_186) then
		local var0_186 = arg0_186:leftModAdditionPoint(arg1_186)
		local var1_186 = arg0_186:getShipProperties()

		return calcFloor(var1_186[arg1_186] + var0_186)
	else
		return 0
	end
end

function var0_0.getModExpRatio(arg0_187, arg1_187)
	if not table.contains(arg0_187:getConfig("lock"), arg1_187) then
		local var0_187 = pg.ship_data_template[arg0_187.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0_187], "ship_data_strengthen>>>>>>" .. var0_187)

		return math.max(pg.ship_data_strengthen[var0_187].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1_187]], 1)
	else
		return 1
	end
end

function var0_0.inUnlockTip(arg0_188)
	local var0_188 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0_188, arg0_188)
end

function var0_0.proposeSkinOwned(arg0_189, arg1_189)
	return arg1_189 and arg0_189.propose and arg1_189.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0_0.getProposeSkin(arg0_190)
	return ShipSkin.GetSkinByType(arg0_190.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getDisplaySkillIds(arg0_191)
	return _.map(pg.ship_data_template[arg0_191.configId].buff_list_display, function(arg0_192)
		return arg0_191:fateSkillChange(arg0_192)
	end)
end

function var0_0.isFullSkillLevel(arg0_193)
	local var0_193 = pg.skill_data_template

	for iter0_193, iter1_193 in pairs(arg0_193.skills) do
		if var0_193[iter1_193.id].max_level ~= iter1_193.level then
			return false
		end
	end

	return true
end

function var0_0.setEquipmentRecord(arg0_194, arg1_194, arg2_194)
	local var0_194 = "equipment_record" .. "_" .. arg1_194 .. "_" .. arg0_194.id

	PlayerPrefs.SetString(var0_194, table.concat(_.flatten(arg2_194), ":"))
	PlayerPrefs.Save()
end

function var0_0.getEquipmentRecord(arg0_195, arg1_195)
	if not arg0_195.equipmentRecords then
		local var0_195 = "equipment_record" .. "_" .. arg1_195 .. "_" .. arg0_195.id
		local var1_195 = string.split(PlayerPrefs.GetString(var0_195) or "", ":")
		local var2_195 = {}

		for iter0_195 = 1, 3 do
			var2_195[iter0_195] = _.map(_.slice(var1_195, 5 * iter0_195 - 4, 5), function(arg0_196)
				return tonumber(arg0_196)
			end)
		end

		arg0_195.equipmentRecords = var2_195
	end

	return arg0_195.equipmentRecords
end

function var0_0.SetSpWeaponRecord(arg0_197, arg1_197, arg2_197)
	local var0_197 = "spweapon_record" .. "_" .. arg1_197 .. "_" .. arg0_197.id
	local var1_197 = _.map({
		1,
		2,
		3
	}, function(arg0_198)
		local var0_198 = arg2_197[arg0_198]

		if var0_198 then
			return (var0_198:GetUID() or 0) .. "," .. var0_198:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0_197, table.concat(var1_197, ":"))
	PlayerPrefs.Save()
end

function var0_0.GetSpWeaponRecord(arg0_199, arg1_199)
	local var0_199 = "spweapon_record" .. "_" .. arg1_199 .. "_" .. arg0_199.id

	return (_.map(string.split(PlayerPrefs.GetString(var0_199, ""), ":"), function(arg0_200)
		local var0_200 = string.split(arg0_200, ",")

		assert(var0_200)

		local var1_200 = tonumber(var0_200[1])
		local var2_200 = tonumber(var0_200[2])

		if not var2_200 or var2_200 == 0 then
			return false
		end

		local var3_200 = getProxy(EquipmentProxy):GetSpWeaponByUid(var1_200) or _.detect(getProxy(BayProxy):GetSpWeaponsInShips(), function(arg0_201)
			return arg0_201:GetUID() == var1_200
		end)

		var3_200 = var3_200 or SpWeapon.New({
			id = var2_200
		})

		return var3_200
	end))
end

function var0_0.hasEquipEquipmentSkin(arg0_202)
	for iter0_202, iter1_202 in ipairs(arg0_202.equipments) do
		if iter1_202 and iter1_202:hasSkin() then
			return true
		end
	end

	return false
end

function var0_0.hasCommander(arg0_203)
	return arg0_203.commanderId and arg0_203.commanderId ~= 0
end

function var0_0.getCommander(arg0_204)
	return arg0_204.commanderId
end

function var0_0.setCommander(arg0_205, arg1_205)
	arg0_205.commanderId = arg1_205
end

function var0_0.getSkillIndex(arg0_206, arg1_206)
	local var0_206 = arg0_206:getSkillList()

	for iter0_206, iter1_206 in ipairs(var0_206) do
		if arg1_206 == iter1_206 then
			return iter0_206
		end
	end
end

function var0_0.getTactics(arg0_207)
	return 1, "tactics_attack"
end

function var0_0.IsBgmSkin(arg0_208)
	local var0_208 = arg0_208:GetSkinConfig()

	return table.contains(var0_208.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_209)
	if arg0_209:IsBgmSkin() then
		return arg0_209:GetSkinConfig().bgm
	end
end

function var0_0.isIntensifyMax(arg0_210)
	local var0_210 = intProperties(arg0_210:getShipProperties())

	if arg0_210:isBluePrintShip() then
		return true
	end

	for iter0_210, iter1_210 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_210:getModAttrBaseMax(iter1_210) ~= var0_210[iter1_210] then
			return false
		end
	end

	return true
end

function var0_0.isRemouldable(arg0_211)
	return not arg0_211:isTestShip() and not arg0_211:isBluePrintShip() and pg.ship_data_trans[arg0_211.groupId]
end

function var0_0.isAllRemouldFinish(arg0_212)
	local var0_212 = pg.ship_data_trans[arg0_212.groupId]

	assert(var0_212, "this ship group without remould config:" .. arg0_212.groupId)

	for iter0_212, iter1_212 in ipairs(var0_212.transform_list) do
		for iter2_212, iter3_212 in ipairs(iter1_212) do
			local var1_212 = pg.transform_data_template[iter3_212[2]]

			if #var1_212.edit_trans > 0 then
				-- block empty
			elseif not arg0_212.transforms[iter3_212[2]] or arg0_212.transforms[iter3_212[2]].level < var1_212.max_level then
				return false
			end
		end
	end

	return true
end

function var0_0.isSpecialFilter(arg0_213)
	local var0_213 = pg.ship_data_statistics[arg0_213.configId]

	assert(var0_213, "this ship without statistics:" .. arg0_213.configId)

	for iter0_213, iter1_213 in ipairs(var0_213.tag_list) do
		if iter1_213 == "special" then
			return true
		end
	end

	return false
end

function var0_0.hasAvailiableSkin(arg0_214)
	local var0_214 = getProxy(ShipSkinProxy)
	local var1_214 = var0_214:GetAllSkinForShip(arg0_214)
	local var2_214 = var0_214:getRawData()
	local var3_214 = 0

	for iter0_214, iter1_214 in ipairs(var1_214) do
		if arg0_214:proposeSkinOwned(iter1_214) or var2_214[iter1_214.id] then
			var3_214 = var3_214 + 1
		end
	end

	return var3_214 > 0
end

function var0_0.hasProposeSkin(arg0_215)
	local var0_215 = getProxy(ShipSkinProxy)
	local var1_215 = var0_215:GetAllSkinForShip(arg0_215)

	for iter0_215, iter1_215 in ipairs(var1_215) do
		if iter1_215.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2_215 = var0_215:GetShareSkinsForShip(arg0_215)

	for iter2_215, iter3_215 in ipairs(var2_215) do
		if iter3_215.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0_0.HasUniqueSpWeapon(arg0_216)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0_216:getGroupId()])
end

function var0_0.getAircraftReloadCD(arg0_217)
	local var0_217 = arg0_217:getConfigTable().base_list
	local var1_217 = arg0_217:getConfigTable().default_equip_list
	local var2_217 = 0
	local var3_217 = 0

	for iter0_217 = 1, 3 do
		local var4_217 = arg0_217:getEquip(iter0_217)
		local var5_217 = var4_217 and var4_217.configId or var1_217[iter0_217]
		local var6_217 = Equipment.getConfigData(var5_217).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0_218)
			return var6_217 == arg0_218
		end) then
			var2_217 = var2_217 + Equipment.GetEquipReloadStatic(var5_217) * var0_217[iter0_217]
			var3_217 = var3_217 + var0_217[iter0_217]
		end
	end

	local var7_217 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2_217 / var3_217 * var7_217
	}
end

function var0_0.IsTagShip(arg0_219, arg1_219)
	local var0_219 = arg0_219:getConfig("tag_list")

	return table.contains(var0_219, arg1_219)
end

function var0_0.setReMetaSpecialItemVO(arg0_220, arg1_220)
	arg0_220.reMetaSpecialItemVO = arg1_220
end

function var0_0.getReMetaSpecialItemVO(arg0_221, arg1_221)
	return arg0_221.reMetaSpecialItemVO
end

function var0_0.getProposeType(arg0_222)
	if arg0_222:isMetaShip() then
		return "meta"
	elseif arg0_222:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_223)
	return arg0_223:getNation() == Nation.IDOL_LINK
end

function var0_0.getSpecificType(arg0_224)
	return pg.ship_data_template[arg0_224.configId].specific_type
end

function var0_0.GetSpWeapon(arg0_225)
	return arg0_225.spWeapon
end

function var0_0.UpdateSpWeapon(arg0_226, arg1_226)
	local var0_226 = (arg1_226 and arg1_226:GetUID() or 0) == (arg0_226.spWeapon and arg0_226.spWeapon:GetUID() or 0)

	arg0_226.spWeapon = arg1_226

	if arg1_226 then
		arg1_226:SetShipId(arg0_226.id)
	end

	if var0_226 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0_0.CanEquipSpWeapon(arg0_227, arg1_227)
	local var0_227, var1_227 = arg0_227:IsSpWeaponForbidden(arg1_227)

	if var0_227 then
		return false, var1_227
	end

	return true
end

function var0_0.IsSpWeaponForbidden(arg0_228, arg1_228)
	local var0_228 = arg1_228:GetWearableShipTypes()
	local var1_228 = arg0_228:getShipType()

	if not table.contains(var0_228, var1_228) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2_228 = arg1_228:GetUniqueGroup()
	local var3_228 = arg0_228:getGroupId()

	if var2_228 ~= 0 and var2_228 ~= var3_228 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0_0.GetMapStrikeAnim(arg0_229)
	local var0_229
	local var1_229 = arg0_229:getShipType()

	switch(TeamType.GetTeamFromShipType(var1_229), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1_229) then
				var0_229 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1_229) then
				var0_229 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1_229) then
				var0_229 = "CannonUI"
			else
				var0_229 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1_229) then
				var0_229 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0_229:getNation() == Nation.MOT then
				var0_229 = "CannonUI"
			else
				var0_229 = "SubTorpedoUI"
			end
		end
	})

	return var0_229
end

function var0_0.IsDefaultSkin(arg0_233)
	return arg0_233.skinId == 0 or arg0_233.skinId == arg0_233:getConfig("skin_id")
end

function var0_0.IsMatchKey(arg0_234, arg1_234)
	if not arg1_234 or arg1_234 == "" then
		return true
	end

	arg1_234 = string.lower(string.gsub(arg1_234, "%.", "%%."))

	return string.find(string.lower(arg0_234:GetDefaultName()), arg1_234)
end

function var0_0.IsOwner(arg0_235)
	return tobool(arg0_235.id)
end

function var0_0.GetUniqueId(arg0_236)
	return arg0_236.id
end

function var0_0.ShowPropose(arg0_237)
	if not arg0_237.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0_237:IsOwner() and arg0_237:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0_0.GetColorName(arg0_238, arg1_238)
	arg1_238 = arg1_238 or arg0_238:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0_238.propose then
		return setColorStr(arg1_238, "#FFAACEFF")
	else
		return arg1_238
	end
end

local var9_0 = {
	effect = {
		"duang_meta_jiehun",
		"duang_6_jiehun_tuzhi",
		"duang_6_jiehun",
		"duang_meta_%s",
		"duang_6"
	},
	frame = {
		"prop4_1",
		"prop%s",
		"prop"
	}
}

function var0_0.GetFrameAndEffect(arg0_239, arg1_239)
	arg1_239 = tobool(arg1_239)

	local var0_239
	local var1_239

	if arg0_239.propose then
		if arg0_239:isMetaShip() then
			var1_239 = string.format(var9_0.effect[1])
			var0_239 = string.format(var9_0.frame[1])
		elseif arg0_239:isBluePrintShip() then
			var1_239 = string.format(var9_0.effect[2])
			var0_239 = string.format(var9_0.frame[2], arg0_239:rarity2bgPrint())
		else
			var1_239 = string.format(var9_0.effect[3])
			var0_239 = string.format(var9_0.frame[3])
		end

		if not arg0_239:ShowPropose() then
			var0_239 = nil
		end
	elseif arg0_239:isMetaShip() then
		var1_239 = string.format(var9_0.effect[4], arg0_239:rarity2bgPrint())
	elseif arg0_239:getRarity() == ShipRarity.SSR then
		var1_239 = string.format(var9_0.effect[5])
	end

	if arg1_239 then
		var1_239 = var1_239 and var1_239 .. "_1"
	end

	return var0_239, var1_239
end

function var0_0.GetRecordPosKey(arg0_240)
	return arg0_240.skinId
end

return var0_0
