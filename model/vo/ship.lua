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

function var0_0.useSkin(arg0_7, arg1_7)
	if arg0_7.skinId == arg1_7 then
		return true
	end

	local var0_7 = ShipGroup.GetChangeSkinGroupId(arg0_7.skinId)
	local var1_7 = ShipGroup.GetChangeSkinGroupId(arg1_7)

	if var0_7 and var1_7 and var0_7 == var1_7 then
		return true
	end

	return false
end

function var0_0.rarity2bgPrint(arg0_8)
	return shipRarity2bgPrint(arg0_8:getRarity(), arg0_8:isBluePrintShip(), arg0_8:isMetaShip())
end

function var0_0.rarity2bgPrintForGet(arg0_9)
	return skinId2bgPrint(arg0_9.skinId) or arg0_9:rarity2bgPrint()
end

function var0_0.getShipBgPrint(arg0_10, arg1_10)
	local var0_10 = pg.ship_skin_template[arg0_10.skinId]

	assert(var0_10, "ship_skin_template not exist: " .. arg0_10.skinId)

	local var1_10

	if not arg1_10 and var0_10.bg_sp and var0_10.bg_sp ~= "" and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_10.painting, 0) == 0 then
		var1_10 = var0_10.bg_sp
	end

	return var1_10 and var1_10 or var0_10.bg and #var0_10.bg > 0 and var0_10.bg or arg0_10:rarity2bgPrintForGet()
end

function var0_0.getStar(arg0_11)
	return arg0_11:getConfig("star")
end

function var0_0.getMaxStar(arg0_12)
	return pg.ship_data_template[arg0_12.configId].star_max
end

function var0_0.getShipArmor(arg0_13)
	return arg0_13:getConfig("armor_type")
end

function var0_0.getShipArmorName(arg0_14)
	local var0_14 = arg0_14:getShipArmor()

	return ArmorType.Type2Name(var0_14)
end

function var0_0.getGroupId(arg0_15)
	return pg.ship_data_template[arg0_15.configId].group_type
end

function var0_0.getGroupIdByConfigId(arg0_16)
	return math.floor(arg0_16 / 10)
end

function var0_0.getShipWords(arg0_17)
	local var0_17 = pg.ship_skin_words[arg0_17]

	if not var0_17 then
		warning("找不到ship_skin_words: " .. arg0_17)

		return
	end

	local var1_17 = Clone(var0_17)

	for iter0_17, iter1_17 in pairs(var1_17) do
		if type(iter1_17) == "string" then
			var1_17[iter0_17] = HXSet.hxLan(iter1_17)
		end
	end

	local var2_17 = pg.ship_skin_words_extra[arg0_17]

	return var1_17, var2_17
end

function var0_0.getMainwordsCount(arg0_18)
	local var0_18 = var0_0.getShipWords(arg0_18)

	if not var0_18.main or var0_18.main == "" then
		var0_18 = var0_0.getShipWords(var0_0.getOriginalSkinId(arg0_18))
	end

	return #string.split(var0_18.main, "|")
end

function var0_0.getWordsEx(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
	local var0_19 = arg0_19 and arg0_19[arg1_19] or nil
	local var1_19 = false

	if not var0_19 or var0_19 == "" then
		if arg0_19 and arg0_19.id == arg4_19 then
			return
		end

		if not arg5_19 then
			return
		end

		local var2_19, var3_19 = var0_0.getShipWords(arg4_19)

		if not var3_19 then
			return
		end

		var0_19 = var3_19[arg1_19]

		if not var0_19 then
			return
		end

		var1_19 = true
	end

	if type(var0_19) == "string" then
		return
	end

	arg3_19 = arg3_19 or 0

	for iter0_19, iter1_19 in ipairs(var0_19) do
		if arg3_19 >= iter1_19[1] then
			if arg1_19 == "main" then
				return string.split(iter1_19[2], "|")[arg2_19], iter1_19[1], var1_19
			else
				return iter1_19[2], iter1_19[1], var1_19
			end
		end
	end
end

function var0_0.getWords(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20, var1_20 = var0_0.getShipWords(arg0_20)
	local var2_20 = var0_0.getOriginalSkinId(arg0_20)
	local var3_20 = math.fmod(arg0_20, var2_20)

	if not var0_20 then
		var0_20, var1_20 = var0_0.getShipWords(var2_20)

		if not var0_20 then
			return nil
		end
	end

	local var4_20 = 0
	local var5_20 = false
	local var6_20 = var0_20[arg1_20]

	if not var6_20 or var6_20 == "" then
		var5_20 = true

		if var0_20.id == var2_20 then
			return nil
		else
			var0_20 = var0_0.getShipWords(var2_20)

			if not var0_20 then
				return nil
			end

			var6_20 = var0_20[arg1_20]

			if not var6_20 or var6_20 == "" then
				return nil
			end
		end
	end

	local var7_20 = string.split(var6_20, "|")
	local var8_20 = arg2_20 or math.random(#var7_20)

	if arg1_20 == "main" and var7_20[var8_20] == "nil" then
		var5_20 = true
		var0_20 = var0_0.getShipWords(var2_20)

		if not var0_20 then
			return nil
		end

		local var9_20 = var0_20[arg1_20]

		if not var9_20 or var9_20 == "" then
			return nil
		end

		var7_20 = string.split(var9_20, "|")
	end

	rstEx, cvEx, defaultCoverEx = var0_0.getWordsEx(var1_20, arg1_20, var8_20, arg4_20, var2_20, var5_20)

	local var10_20
	local var11_20 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. pg.ship_skin_template[arg0_20].ship_group) == 2 and var0_20.voice_key_2 or var0_20.voice_key

	if var11_20 == 0 then
		if not var5_20 or rstEx and not defaultCoverEx then
			var10_20 = var0_0.getCVPath(var2_20, arg1_20, var8_20, var3_20)
		end
	elseif var11_20 == -2 then
		-- block empty
	else
		var10_20 = var0_0.getCVPath(var2_20, arg1_20, var8_20)
	end

	local var12_20 = var7_20[var8_20]

	if var12_20 and (arg3_20 == nil and PLATFORM_CODE ~= PLATFORM_US or arg3_20 == true) then
		var12_20 = var12_20:gsub("%s", " ")
	end

	if rstEx then
		var10_20 = var10_20 and var10_20 .. "_ex" .. cvEx
	end

	return rstEx or var12_20, var10_20, cvEx
end

function var0_0.getCVKeyID(arg0_21)
	local var0_21 = Ship.getShipWords(arg0_21)

	if not var0_21 then
		return -1
	end

	local var1_21
	local var2_21 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. pg.ship_skin_template[arg0_21].ship_group)
	local var3_21 = var2_21 == 2 and var0_21.voice_key_2 >= 0 and var0_21.voice_key_2 or var0_21.voice_key

	if var3_21 == 0 or var3_21 == -2 then
		local var4_21 = var0_0.getOriginalSkinId(arg0_21)
		local var5_21 = var0_0.getShipWords(var4_21)

		var3_21 = var2_21 == 2 and var5_21.voice_key_2 >= 0 and var5_21.voice_key_2 or var5_21.voice_key
	end

	return var3_21
end

function var0_0.getCVPath(arg0_22, arg1_22, arg2_22, arg3_22)
	arg2_22 = arg2_22 or 1

	local var0_22 = Ship.getShipWords(arg0_22)
	local var1_22 = var0_0.getOriginalSkinId(arg0_22)

	if not var0_22 then
		var0_22 = var0_0.getShipWords(var1_22)

		if not var0_22 then
			return
		end
	end

	local var2_22 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. arg0_22 / 10)
	local var3_22 = var0_22[arg1_22]

	if arg1_22 == "main" then
		var3_22 = string.split(var3_22, "|")[arg2_22]
		arg1_22 = arg1_22 .. arg2_22
	end

	if arg1_22 == "skill" or string.find(arg1_22, "link") then
		if var0_22.voice_key == 0 then
			var0_22 = var0_0.getShipWords(var1_22)
		end
	elseif not var3_22 or var3_22 == "" or var3_22 == "nil" then
		var0_22 = var0_0.getShipWords(var1_22)
	end

	local var4_22
	local var5_22 = var2_22 == 2 and var0_22.voice_key_2 or var0_22.voice_key

	if var5_22 ~= -1 and pg.character_voice[arg1_22] then
		var4_22 = pg.character_voice[arg1_22].resource_key

		if var4_22 then
			var4_22 = "event:/cv/" .. var5_22 .. "/" .. var4_22

			if arg3_22 then
				var4_22 = var4_22 .. "_" .. arg3_22
			end
		end
	end

	return var4_22
end

function var0_0.getCVCalibrate(arg0_23, arg1_23, arg2_23)
	local var0_23 = pg.ship_skin_template[arg0_23]

	if not var0_23 then
		return 0
	end

	if arg1_23 == "main" then
		arg1_23 = arg1_23 .. "_" .. arg2_23
	end

	return var0_23.l2d_voice_calibrate[arg1_23]
end

function var0_0.getL2dSoundEffect(arg0_24, arg1_24, arg2_24)
	local var0_24 = pg.ship_skin_template[arg0_24]

	if not var0_24 then
		return 0
	end

	if arg1_24 == "main" then
		arg1_24 = arg1_24 .. "_" .. arg2_24
	end

	return var0_24.l2d_se[arg1_24]
end

function var0_0.getOriginalSkinId(arg0_25)
	local var0_25 = pg.ship_skin_template[arg0_25].ship_group

	return ShipGroup.getDefaultSkin(var0_25).id
end

function var0_0.getTransformShipId(arg0_26)
	local var0_26 = pg.ship_data_template[arg0_26].group_type
	local var1_26 = pg.ship_data_trans[var0_26]

	if var1_26 then
		for iter0_26, iter1_26 in ipairs(var1_26.transform_list) do
			for iter2_26, iter3_26 in ipairs(iter1_26) do
				local var2_26 = pg.transform_data_template[iter3_26[2]]

				for iter4_26, iter5_26 in ipairs(var2_26.ship_id) do
					if iter5_26[1] == arg0_26 then
						return iter5_26[2]
					end
				end
			end
		end
	end
end

function var0_0.getAircraftCount(arg0_27)
	local var0_27 = arg0_27:getConfigTable().base_list
	local var1_27 = arg0_27:getConfigTable().default_equip_list
	local var2_27 = {}

	for iter0_27 = 1, 3 do
		local var3_27 = arg0_27:getEquip(iter0_27) and arg0_27:getEquip(iter0_27).configId or var1_27[iter0_27]
		local var4_27 = Equipment.getConfigData(var3_27).type

		if table.contains(EquipType.AirDomainEquip, var4_27) then
			var2_27[var4_27] = defaultValue(var2_27[var4_27], 0) + var0_27[iter0_27]
		end
	end

	return var2_27
end

function var0_0.getShipType(arg0_28)
	return arg0_28:getConfig("type")
end

function var0_0.getEnergy(arg0_29)
	return arg0_29.energy
end

function var0_0.getEnergeConfig(arg0_30)
	local var0_30 = pg.energy_template
	local var1_30 = arg0_30:getEnergy()

	for iter0_30, iter1_30 in pairs(var0_30) do
		if type(iter0_30) == "number" and var1_30 >= iter1_30.lower_bound and var1_30 <= iter1_30.upper_bound then
			return iter1_30
		end
	end

	assert(false, "疲劳配置不存在：" .. arg0_30.energy)
end

function var0_0.getEnergyPrint(arg0_31)
	local var0_31 = arg0_31:getEnergeConfig()

	return var0_31.icon, var0_31.desc
end

function var0_0.getIntimacy(arg0_32)
	return arg0_32.intimacy
end

function var0_0.getCVIntimacy(arg0_33)
	return arg0_33:getIntimacy() / 100 + (arg0_33.propose and 1000 or 0)
end

function var0_0.getIntimacyMax(arg0_34)
	if arg0_34.propose then
		return 200
	else
		return arg0_34:GetNoProposeIntimacyMax()
	end
end

function var0_0.GetNoProposeIntimacyMax(arg0_35)
	return 100
end

function var0_0.getIntimacyIcon(arg0_36)
	local var0_36 = pg.intimacy_template[arg0_36:getIntimacyLevel()]
	local var1_36 = ""

	if arg0_36:isMetaShip() then
		var1_36 = "_meta"
	elseif arg0_36:IsXIdol() then
		var1_36 = "_imas"
	end

	if not arg0_36.propose and math.floor(arg0_36:getIntimacy() / 100) >= arg0_36:getIntimacyMax() then
		return var0_36.icon .. var1_36, "heart" .. var1_36
	else
		return var0_36.icon .. var1_36
	end
end

function var0_0.getIntimacyDetail(arg0_37)
	return arg0_37:getIntimacyMax(), math.floor(arg0_37:getIntimacy() / 100)
end

function var0_0.getIntimacyInfo(arg0_38)
	local var0_38 = pg.intimacy_template[arg0_38:getIntimacyLevel()]

	return var0_38.icon, var0_38.desc
end

function var0_0.getIntimacyLevel(arg0_39)
	local var0_39 = 0
	local var1_39 = pg.intimacy_template

	for iter0_39, iter1_39 in pairs(var1_39) do
		if type(iter0_39) == "number" and arg0_39:getIntimacy() >= iter1_39.lower_bound and arg0_39:getIntimacy() <= iter1_39.upper_bound then
			var0_39 = iter0_39

			break
		end
	end

	if var0_39 < arg0_39.INTIMACY_PROPOSE and arg0_39.propose then
		var0_39 = arg0_39.INTIMACY_PROPOSE
	end

	return var0_39
end

function var0_0.getBluePrint(arg0_40)
	local var0_40 = ShipBluePrint.New({
		id = arg0_40.groupId
	})
	local var1_40 = arg0_40.strengthList[1] or {
		exp = 0,
		level = 0
	}

	var0_40:updateInfo({
		blue_print_level = var1_40.level,
		exp = var1_40.exp
	})

	return var0_40
end

function var0_0.getBaseList(arg0_41)
	if arg0_41:isBluePrintShip() then
		local var0_41 = arg0_41:getBluePrint()

		assert(var0_41, "blueprint can not be nil" .. arg0_41.configId)

		return var0_41:getBaseList(arg0_41)
	else
		return arg0_41:getConfig("base_list")
	end
end

function var0_0.getPreLoadCount(arg0_42)
	if arg0_42:isBluePrintShip() then
		return arg0_42:getBluePrint():getPreLoadCount(arg0_42)
	else
		return arg0_42:getConfig("preload_count")
	end
end

function var0_0.getNation(arg0_43)
	return arg0_43:getConfig("nationality")
end

function var0_0.getPaintingName(arg0_44)
	local var0_44 = pg.ship_data_statistics[arg0_44].skin_id
	local var1_44 = pg.ship_skin_template[var0_44]

	assert(var1_44, "ship_skin_template not exist: " .. arg0_44 .. " " .. var0_44)

	return var1_44.painting
end

function var0_0.getName(arg0_45)
	if arg0_45.propose and pg.PushNotificationMgr.GetInstance():isEnableShipName() then
		return arg0_45.name
	end

	if arg0_45:isRemoulded() then
		return pg.ship_skin_template[arg0_45:getRemouldSkinId()].name
	end

	return pg.ship_data_statistics[arg0_45.configId].name
end

function var0_0.GetDefaultName(arg0_46)
	if arg0_46:isRemoulded() then
		return pg.ship_skin_template[arg0_46:getRemouldSkinId()].name
	else
		return pg.ship_data_statistics[arg0_46.configId].name
	end
end

function var0_0.getShipName(arg0_47)
	return pg.ship_data_statistics[arg0_47].name
end

function var0_0.getBreakOutLevel(arg0_48)
	assert(arg0_48, "必须存在配置id")
	assert(pg.ship_data_statistics[arg0_48], "必须存在配置" .. arg0_48)

	return pg.ship_data_statistics[arg0_48].star
end

function var0_0.Ctor(arg0_49, arg1_49)
	arg0_49.id = arg1_49.id
	arg0_49.configId = arg1_49.template_id or arg1_49.configId
	arg0_49.level = arg1_49.level
	arg0_49.exp = arg1_49.exp
	arg0_49.energy = arg1_49.energy
	arg0_49.lockState = arg1_49.is_locked
	arg0_49.intimacy = arg1_49.intimacy
	arg0_49.propose = arg1_49.propose and arg1_49.propose > 0
	arg0_49.proposeTime = arg1_49.propose

	if arg0_49.intimacy and arg0_49.intimacy > 10000 and not arg0_49.propose then
		arg0_49.intimacy = 10000
	end

	arg0_49.renameTime = arg1_49.change_name_timestamp

	if arg1_49.name and arg1_49.name ~= "" then
		arg0_49.name = arg1_49.name
	else
		assert(pg.ship_data_statistics[arg0_49.configId], "必须存在配置" .. arg0_49.configId)

		arg0_49.name = pg.ship_data_statistics[arg0_49.configId].name
	end

	arg0_49.bluePrintFlag = arg1_49.blue_print_flag or 0
	arg0_49.strengthList = {}

	for iter0_49, iter1_49 in ipairs(arg1_49.strength_list or {}) do
		if not arg0_49:isBluePrintShip() then
			local var0_49 = ShipModAttr.ID_TO_ATTR[iter1_49.id]

			arg0_49.strengthList[var0_49] = iter1_49.exp
		else
			table.insert(arg0_49.strengthList, {
				level = iter1_49.id,
				exp = iter1_49.exp
			})
		end
	end

	local var1_49 = arg1_49.state or {}

	arg0_49.state = var1_49.state or 0
	arg0_49.state_info_1 = var1_49.state_info_1 or 0
	arg0_49.state_info_2 = var1_49.state_info_2 or 0
	arg0_49.state_info_3 = var1_49.state_info_3 or 0
	arg0_49.state_info_4 = var1_49.state_info_4 or 0
	arg0_49.equipmentSkins = {}
	arg0_49.equipments = {}

	if arg1_49.equip_info_list then
		for iter2_49, iter3_49 in ipairs(arg1_49.equip_info_list or {}) do
			arg0_49.equipments[iter2_49] = iter3_49.id > 0 and Equipment.New({
				count = 1,
				id = iter3_49.id,
				config_id = iter3_49.id,
				skinId = iter3_49.skinId
			}) or false
			arg0_49.equipmentSkins[iter2_49] = iter3_49.skinId > 0 and iter3_49.skinId or 0

			arg0_49:reletiveEquipSkin(iter2_49)
		end
	end

	arg0_49.spWeapon = nil

	if arg1_49.spweapon then
		arg0_49:UpdateSpWeapon(SpWeapon.CreateByNet(arg1_49.spweapon))
	end

	arg0_49.skills = {}

	for iter4_49, iter5_49 in ipairs(arg1_49.skill_id_list or {}) do
		arg0_49:updateSkill(iter5_49)
	end

	arg0_49.star = arg0_49:getConfig("rarity")
	arg0_49.transforms = {}

	for iter6_49, iter7_49 in ipairs(arg1_49.transform_list or {}) do
		arg0_49.transforms[iter7_49.id] = {
			id = iter7_49.id,
			level = iter7_49.level
		}
	end

	arg0_49.groupId = pg.ship_data_template[arg0_49.configId].group_type
	arg0_49.createTime = arg1_49.create_time or 0

	local var2_49 = getProxy(CollectionProxy)

	arg0_49.virgin = var2_49 and var2_49.shipGroups[arg0_49.groupId] == nil

	local var3_49 = {
		pg.gameset.test_ship_config_1.key_value,
		pg.gameset.test_ship_config_2.key_value,
		pg.gameset.test_ship_config_3.key_value
	}
	local var4_49 = table.indexof(var3_49, arg0_49.configId)

	if var4_49 == 1 then
		arg0_49.testShip = {
			2,
			3,
			4
		}
	elseif var4_49 == 2 then
		arg0_49.testShip = {
			5
		}
	elseif var4_49 == 3 then
		arg0_49.testShip = {
			6
		}
	else
		arg0_49.testShip = nil
	end

	arg0_49.maxIntimacy = pg.intimacy_template[#pg.intimacy_template.all].upper_bound

	local var5_49 = 0

	if not HXSet.isHxSkin() then
		var5_49 = arg1_49.skin_id or 0
	end

	if var5_49 == 0 then
		var5_49 = arg0_49:getConfig("skin_id")
	end

	arg0_49:updateSkinId(var5_49)

	if arg1_49.name and arg1_49.name ~= "" then
		arg0_49.name = arg1_49.name
	elseif arg0_49:isRemoulded() then
		arg0_49.name = pg.ship_skin_template[arg0_49:getRemouldSkinId()].name
	else
		arg0_49.name = pg.ship_data_statistics[arg0_49.configId].name
	end

	arg0_49.maxLevel = arg1_49.max_level
	arg0_49.proficiency = arg1_49.proficiency or 0
	arg0_49.preferenceTag = arg1_49.common_flag
	arg0_49.hpRant = 10000
	arg0_49.strategies = {}
	arg0_49.triggers = {}
	arg0_49.commanderId = arg1_49.commanderid or 0
	arg0_49.activityNpc = arg1_49.activity_npc or 0

	if var0_0.isMetaShipByConfigID(arg0_49.configId) then
		local var6_49 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_49.configId)

		arg0_49.metaCharacter = MetaCharacter.New({
			id = var6_49,
			repair_attr_info = arg1_49.meta_repair_list
		}, arg0_49)
	end
end

function var0_0.isMetaShipByConfigID(arg0_50)
	local var0_50 = pg.ship_meta_breakout.all
	local var1_50 = var0_50[1]
	local var2_50 = false

	if var1_50 <= arg0_50 then
		for iter0_50, iter1_50 in ipairs(var0_50) do
			if arg0_50 == iter1_50 then
				var2_50 = true

				break
			end
		end
	end

	return var2_50
end

function var0_0.isMetaShip(arg0_51)
	return arg0_51.metaCharacter ~= nil
end

function var0_0.getMetaCharacter(arg0_52)
	return arg0_52.metaCharacter
end

function var0_0.unlockActivityNpc(arg0_53, arg1_53)
	arg0_53.activityNpc = arg1_53
end

function var0_0.isActivityNpc(arg0_54)
	return arg0_54.activityNpc > 0
end

function var0_0.getActiveEquipments(arg0_55)
	local var0_55 = Clone(arg0_55.equipments)

	for iter0_55 = #var0_55, 1, -1 do
		local var1_55 = var0_55[iter0_55]

		if var1_55 then
			for iter1_55 = 1, iter0_55 - 1 do
				local var2_55 = var0_55[iter1_55]

				if var2_55 and var1_55:getConfig("equip_limit") ~= 0 and var2_55:getConfig("equip_limit") == var1_55:getConfig("equip_limit") then
					var0_55[iter0_55] = false
				end
			end
		end
	end

	return var0_55
end

function var0_0.getAllEquipments(arg0_56)
	return arg0_56.equipments
end

function var0_0.isBluePrintShip(arg0_57)
	return arg0_57.bluePrintFlag == 1
end

function var0_0.getSkinId(arg0_58)
	return arg0_58.skinId
end

function var0_0.updateSkinId(arg0_59, arg1_59)
	if not arg1_59 or arg1_59 == 0 then
		arg1_59 = arg0_59:getConfig("skin_id")
	end

	local var0_59 = ShipGroup.GetChangeSkinGroupId(arg1_59)

	if var0_59 then
		local var1_59 = ShipGroup.GetStoreChangeSkinId(var0_59, arg0_59.id)

		arg0_59.skinId = var1_59 and var1_59 or arg1_59
	else
		arg0_59.skinId = arg1_59
	end
end

function var0_0.updateName(arg0_60)
	if arg0_60.name ~= pg.ship_data_statistics[arg0_60.configId].name then
		return
	end

	if arg0_60:isRemoulded() then
		arg0_60.name = pg.ship_skin_template[arg0_60:getRemouldSkinId()].name
	else
		arg0_60.name = pg.ship_data_statistics[arg0_60.configId].name
	end
end

function var0_0.isRemoulded(arg0_61)
	if arg0_61.remoulded then
		return true
	end

	local var0_61 = pg.ship_data_trans[arg0_61.groupId]

	if var0_61 then
		for iter0_61, iter1_61 in ipairs(var0_61.transform_list) do
			for iter2_61, iter3_61 in ipairs(iter1_61) do
				local var1_61 = pg.transform_data_template[iter3_61[2]]

				if var1_61.skin_id ~= 0 and arg0_61.transforms[iter3_61[2]] and arg0_61.transforms[iter3_61[2]].level == var1_61.max_level then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.getRemouldSkinId(arg0_62)
	local var0_62 = ShipGroup.getModSkin(arg0_62.groupId)

	if var0_62 then
		return var0_62.id
	end

	return nil
end

function var0_0.hasEquipmentSkinInPos(arg0_63, arg1_63)
	local var0_63 = arg0_63.equipments[arg1_63]

	return var0_63 and var0_63:hasSkin()
end

function var0_0.getPrefab(arg0_64)
	local var0_64 = arg0_64.skinId

	if arg0_64:hasEquipmentSkinInPos(var2_0) then
		local var1_64 = arg0_64:getEquip(var2_0)
		local var2_64 = var7_0[var1_64:getSkinId()].ship_skin_id

		var0_64 = var2_64 ~= 0 and var2_64 or var0_64
	end

	local var3_64 = pg.ship_skin_template[var0_64]

	assert(var3_64, "ship_skin_template not exist: " .. arg0_64.configId .. " " .. var0_64)

	return var3_64.prefab
end

function var0_0.getAttachmentPrefab(arg0_65)
	local var0_65 = {}

	for iter0_65, iter1_65 in ipairs(arg0_65.equipments) do
		if iter1_65 and iter1_65:hasSkinOrbit() then
			local var1_65 = iter1_65:getSkinId()
			local var2_65 = var7_0[var1_65]

			var0_65[var1_65] = {
				config = var2_65,
				index = iter0_65
			}
		end
	end

	return var0_65
end

function var0_0.getPainting(arg0_66)
	local var0_66 = pg.ship_skin_template[arg0_66.skinId]

	assert(var0_66, "ship_skin_template not exist: " .. arg0_66.configId .. " " .. arg0_66.skinId)

	return var0_66.painting
end

function var0_0.GetSkinConfig(arg0_67)
	local var0_67 = pg.ship_skin_template[arg0_67.skinId]

	assert(var0_67, "ship_skin_template not exist: " .. arg0_67.configId .. " " .. arg0_67.skinId)

	return var0_67
end

function var0_0.getRemouldPainting(arg0_68)
	local var0_68 = pg.ship_skin_template[arg0_68:getRemouldSkinId()]

	assert(var0_68, "ship_skin_template not exist: " .. arg0_68.configId .. " " .. arg0_68.skinId)

	return var0_68.painting
end

function var0_0.updateStateInfo34(arg0_69, arg1_69, arg2_69)
	arg0_69.state_info_3 = arg1_69
	arg0_69.state_info_4 = arg2_69
end

function var0_0.hasStateInfo3Or4(arg0_70)
	return arg0_70.state_info_3 ~= 0 or arg0_70.state_info_4 ~= 0
end

function var0_0.isTestShip(arg0_71)
	return arg0_71.testShip
end

function var0_0.canUseTestShip(arg0_72, arg1_72)
	assert(arg0_72.testShip, "ship is not TestShip")

	return table.contains(arg0_72.testShip, arg1_72)
end

function var0_0.updateEquip(arg0_73, arg1_73, arg2_73)
	assert(arg2_73 == nil or arg2_73.count == 1)

	local var0_73 = arg0_73.equipments[arg1_73]

	arg0_73.equipments[arg1_73] = arg2_73 and Clone(arg2_73) or false

	local function var1_73(arg0_74)
		arg0_74 = CreateShell(arg0_74)
		arg0_74.shipId = arg0_73.id
		arg0_74.shipPos = arg1_73

		return arg0_74
	end

	if var0_73 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0_73, arg0_73.id, arg1_73)
		var0_73:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1_73(var0_73))
	end

	if arg2_73 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2_73, arg0_73.id, arg1_73)
		arg0_73:reletiveEquipSkin(arg1_73)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1_73(arg2_73))
	end
end

function var0_0.reletiveEquipSkin(arg0_75, arg1_75)
	if arg0_75.equipments[arg1_75] and arg0_75.equipmentSkins[arg1_75] ~= 0 then
		local var0_75 = pg.equip_skin_template[arg0_75.equipmentSkins[arg1_75]].equip_type
		local var1_75 = arg0_75.equipments[arg1_75]:getType()

		if table.contains(var0_75, var1_75) then
			arg0_75.equipments[arg1_75]:setSkinId(arg0_75.equipmentSkins[arg1_75])
		else
			arg0_75.equipments[arg1_75]:setSkinId(0)
		end
	elseif arg0_75.equipments[arg1_75] then
		arg0_75.equipments[arg1_75]:setSkinId(0)
	end
end

function var0_0.updateEquipmentSkin(arg0_76, arg1_76, arg2_76)
	if not arg1_76 then
		return
	end

	if arg2_76 and arg2_76 > 0 then
		local var0_76 = arg0_76:getSkinTypes(arg1_76)
		local var1_76 = pg.equip_skin_template[arg2_76].equip_type
		local var2_76 = false

		for iter0_76, iter1_76 in ipairs(var0_76) do
			for iter2_76, iter3_76 in ipairs(var1_76) do
				if iter1_76 == iter3_76 then
					var2_76 = true

					break
				end
			end
		end

		if not var2_76 then
			assert(var2_76, "部位" .. arg1_76 .. " 无法穿戴皮肤 " .. arg2_76)

			return
		end

		local var3_76 = arg0_76.equipments[arg1_76] and arg0_76.equipments[arg1_76]:getType() or false

		arg0_76.equipmentSkins[arg1_76] = arg2_76

		if var3_76 and table.contains(var1_76, var3_76) then
			arg0_76.equipments[arg1_76]:setSkinId(arg0_76.equipmentSkins[arg1_76])
		elseif var3_76 and not table.contains(var1_76, var3_76) then
			arg0_76.equipments[arg1_76]:setSkinId(0)
		end
	else
		arg0_76.equipmentSkins[arg1_76] = 0

		if arg0_76.equipments[arg1_76] then
			arg0_76.equipments[arg1_76]:setSkinId(0)
		end
	end
end

function var0_0.getEquip(arg0_77, arg1_77)
	return Clone(arg0_77.equipments[arg1_77])
end

function var0_0.getEquipSkins(arg0_78)
	return Clone(arg0_78.equipmentSkins)
end

function var0_0.getEquipSkin(arg0_79, arg1_79)
	return arg0_79.equipmentSkins[arg1_79]
end

function var0_0.getCanEquipSkin(arg0_80, arg1_80)
	local var0_80 = arg0_80:getSkinTypes(arg1_80)

	if var0_80 and #var0_80 then
		for iter0_80, iter1_80 in ipairs(var0_80) do
			if pg.equip_data_by_type[iter1_80].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0_0.checkCanEquipSkin(arg0_81, arg1_81, arg2_81)
	if not arg1_81 or not arg2_81 then
		return
	end

	local var0_81 = arg0_81:getSkinTypes(arg1_81)
	local var1_81 = pg.equip_skin_template[arg2_81].equip_type

	for iter0_81, iter1_81 in ipairs(var0_81) do
		if table.contains(var1_81, iter1_81) then
			return true
		end
	end

	return false
end

function var0_0.getSkinTypes(arg0_82, arg1_82)
	return pg.ship_data_template[arg0_82.configId]["equip_" .. arg1_82] or {}
end

function var0_0.updateState(arg0_83, arg1_83)
	arg0_83.state = arg1_83
end

function var0_0.addSkillExp(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg0_84.skills[arg1_84] or {
		exp = 0,
		level = 1,
		id = arg1_84
	}
	local var1_84 = var0_84.level and var0_84.level or 1
	local var2_84 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1_84 == var2_84 then
		return
	end

	local var3_84 = var0_84.exp and arg2_84 + var0_84.exp or 0 + arg2_84

	while var3_84 >= pg.skill_need_exp[var1_84].exp do
		var3_84 = var3_84 - pg.skill_need_exp[var1_84].exp
		var1_84 = var1_84 + 1

		if var1_84 == var2_84 then
			var3_84 = 0

			break
		end
	end

	arg0_84:updateSkill({
		id = var0_84.id,
		level = var1_84,
		exp = var3_84
	})
end

function var0_0.upSkillLevelForMeta(arg0_85, arg1_85)
	local var0_85 = arg0_85.skills[arg1_85] or {
		exp = 0,
		level = 0,
		id = arg1_85
	}
	local var1_85 = arg0_85:isSkillLevelMax(arg1_85)
	local var2_85 = var0_85.level

	if not var1_85 then
		var2_85 = var2_85 + 1
	end

	arg0_85:updateSkill({
		exp = 0,
		id = var0_85.id,
		level = var2_85
	})
end

function var0_0.getMetaSkillLevelBySkillID(arg0_86, arg1_86)
	return (arg0_86.skills[arg1_86] or {
		exp = 0,
		level = 0,
		id = arg1_86
	}).level
end

function var0_0.isSkillLevelMax(arg0_87, arg1_87)
	local var0_87 = arg0_87.skills[arg1_87] or {
		exp = 0,
		level = 1,
		id = arg1_87
	}

	return (var0_87.level and var0_87.level or 1) >= pg.skill_data_template[arg1_87].max_level
end

function var0_0.isAllMetaSkillLevelMax(arg0_88)
	local var0_88 = true
	local var1_88 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_88.configId)

	for iter0_88, iter1_88 in ipairs(var1_88) do
		if not arg0_88:isSkillLevelMax(iter1_88) then
			var0_88 = false

			break
		end
	end

	return var0_88
end

function var0_0.isAllMetaSkillLock(arg0_89)
	local var0_89 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_89.configId)
	local var1_89 = true

	for iter0_89, iter1_89 in ipairs(var0_89) do
		if arg0_89:getMetaSkillLevelBySkillID(iter1_89) > 0 then
			var1_89 = false

			break
		end
	end

	return var1_89
end

function var0_0.bindConfigTable(arg0_90)
	return pg.ship_data_statistics
end

function var0_0.isAvaiable(arg0_91)
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

function var0_0.intimacyAdditions(arg0_92, arg1_92)
	local var0_92 = pg.intimacy_template[arg0_92:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0_92, iter1_92 in pairs(arg1_92) do
		if iter0_92 == AttributeType.Durability or iter0_92 == AttributeType.Cannon or iter0_92 == AttributeType.Torpedo or iter0_92 == AttributeType.AntiAircraft or iter0_92 == AttributeType.AntiSub or iter0_92 == AttributeType.Air or iter0_92 == AttributeType.Reload or iter0_92 == AttributeType.Hit or iter0_92 == AttributeType.Dodge then
			arg1_92[iter0_92] = arg1_92[iter0_92] * (var0_92 + 1)
		end
	end
end

function var0_0.getShipProperties(arg0_93)
	local var0_93 = arg0_93:getBaseProperties()

	if arg0_93:isBluePrintShip() then
		local var1_93 = arg0_93:getBluePrint()

		assert(var1_93, "blueprint can not be nil" .. arg0_93.configId)

		local var2_93 = var1_93:getTotalAdditions()

		for iter0_93, iter1_93 in pairs(var2_93) do
			var0_93[iter0_93] = var0_93[iter0_93] + calcFloor(iter1_93)
		end

		arg0_93:intimacyAdditions(var0_93)
	elseif arg0_93:isMetaShip() then
		assert(arg0_93.metaCharacter)

		for iter2_93, iter3_93 in pairs(var0_93) do
			var0_93[iter2_93] = var0_93[iter2_93] + arg0_93.metaCharacter:getAttrAddition(iter2_93)
		end

		arg0_93:intimacyAdditions(var0_93)
	else
		local var3_93 = pg.ship_data_template[arg0_93.configId].strengthen_id
		local var4_93 = var5_0[var3_93]

		for iter4_93, iter5_93 in pairs(arg0_93.strengthList) do
			local var5_93 = ShipModAttr.ATTR_TO_INDEX[iter4_93]
			local var6_93 = math.min(iter5_93, var4_93.durability[var5_93] * var4_93.level_exp[var5_93])
			local var7_93 = math.max(arg0_93:getModExpRatio(iter4_93), 1)

			var0_93[iter4_93] = var0_93[iter4_93] + calcFloor(var6_93 / var7_93)
		end

		arg0_93:intimacyAdditions(var0_93)

		for iter6_93, iter7_93 in pairs(arg0_93.transforms) do
			local var8_93 = pg.transform_data_template[iter7_93.id].effect

			for iter8_93 = 1, iter7_93.level do
				local var9_93 = var8_93[iter8_93] or {}

				for iter9_93, iter10_93 in pairs(var0_93) do
					if var9_93[iter9_93] then
						var0_93[iter9_93] = var0_93[iter9_93] + var9_93[iter9_93]
					end
				end
			end
		end
	end

	return var0_93
end

function var0_0.getTechNationAddition(arg0_94, arg1_94)
	local var0_94 = getProxy(TechnologyNationProxy)
	local var1_94 = arg0_94:getConfig("type")

	if var1_94 == ShipType.DaoQuV or var1_94 == ShipType.DaoQuM then
		var1_94 = ShipType.QuZhu
	end

	return var0_94:getShipAddition(var1_94, arg1_94)
end

function var0_0.getTechNationMaxAddition(arg0_95, arg1_95)
	local var0_95 = getProxy(TechnologyNationProxy)
	local var1_95 = arg0_95:getConfig("type")

	return var0_95:getShipMaxAddition(var1_95, arg1_95)
end

function var0_0.getEquipProficiencyByPos(arg0_96, arg1_96)
	return arg0_96:getEquipProficiencyList()[arg1_96]
end

function var0_0.getEquipProficiencyList(arg0_97)
	local var0_97 = arg0_97:getConfigTable()
	local var1_97 = Clone(var0_97.equipment_proficiency)

	if arg0_97:isBluePrintShip() then
		local var2_97 = arg0_97:getBluePrint()

		assert(var2_97, "blueprint can not be nil >>>" .. arg0_97.groupId)

		var1_97 = var2_97:getEquipProficiencyList(arg0_97)
	else
		for iter0_97, iter1_97 in ipairs(var1_97) do
			local var3_97 = 0

			for iter2_97, iter3_97 in pairs(arg0_97.transforms) do
				local var4_97 = pg.transform_data_template[iter3_97.id].effect

				for iter4_97 = 1, iter3_97.level do
					local var5_97 = var4_97[iter4_97] or {}

					if var5_97["equipment_proficiency_" .. iter0_97] then
						var3_97 = var3_97 + var5_97["equipment_proficiency_" .. iter0_97]
					end
				end
			end

			var1_97[iter0_97] = iter1_97 + var3_97
		end
	end

	return var1_97
end

function var0_0.getBaseProperties(arg0_98)
	local var0_98 = arg0_98:getConfigTable()

	assert(var0_98, "配置表没有这艘船" .. arg0_98.configId)

	local var1_98 = {}
	local var2_98 = {}

	for iter0_98, iter1_98 in ipairs(var0_0.PROPERTIES) do
		var1_98[iter1_98] = arg0_98:getGrowthForAttr(iter1_98)
		var2_98[iter1_98] = var1_98[iter1_98]
	end

	for iter2_98, iter3_98 in ipairs(arg0_98:getConfig("lock")) do
		var2_98[iter3_98] = var1_98[iter3_98]
	end

	for iter4_98, iter5_98 in ipairs(var0_0.DIVE_PROPERTIES) do
		var2_98[iter5_98] = var0_98[iter5_98]
	end

	for iter6_98, iter7_98 in ipairs(var0_0.SONAR_PROPERTIES) do
		var2_98[iter7_98] = 0
	end

	return var2_98
end

function var0_0.getGrowthForAttr(arg0_99, arg1_99)
	local var0_99 = arg0_99:getConfigTable()
	local var1_99 = table.indexof(var0_0.PROPERTIES, arg1_99)
	local var2_99 = pg.gameset.extra_attr_level_limit.key_value
	local var3_99 = var0_99.attrs[var1_99] + (arg0_99.level - 1) * var0_99.attrs_growth[var1_99] / 1000

	if var2_99 < arg0_99.level then
		var3_99 = var3_99 + (arg0_99.level - var2_99) * var0_99.attrs_growth_extra[var1_99] / 1000
	end

	return var3_99
end

function var0_0.isMaxStar(arg0_100)
	return arg0_100:getStar() >= arg0_100:getMaxStar()
end

function var0_0.IsMaxStarByTmpID(arg0_101)
	local var0_101 = pg.ship_data_template[arg0_101]

	return var0_101.star >= var0_101.star_max
end

function var0_0.IsSpweaponUnlock(arg0_102)
	if not arg0_102:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0_0.getModProperties(arg0_103, arg1_103)
	return arg0_103.strengthList[arg1_103] or 0
end

function var0_0.addModAttrExp(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg0_104:getModAttrTopLimit(arg1_104)

	if var0_104 == 0 then
		return
	end

	local var1_104 = arg0_104:getModExpRatio(arg1_104)
	local var2_104 = arg0_104:getModProperties(arg1_104)

	if var2_104 + arg2_104 > var0_104 * var1_104 then
		arg0_104.strengthList[arg1_104] = var0_104 * var1_104
	else
		arg0_104.strengthList[arg1_104] = var2_104 + arg2_104
	end
end

function var0_0.getNeedModExp(arg0_105)
	local var0_105 = {}

	for iter0_105, iter1_105 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1_105 = arg0_105:getModAttrTopLimit(iter1_105)

		if var1_105 == 0 then
			var0_105[iter1_105] = 0
		else
			var0_105[iter1_105] = var1_105 * arg0_105:getModExpRatio(iter1_105) - arg0_105:getModProperties(iter1_105)
		end
	end

	return var0_105
end

function var0_0.attrVertify(arg0_106)
	if not BayProxy.checkShiplevelVertify(arg0_106) then
		return false
	end

	for iter0_106, iter1_106 in ipairs(arg0_106.equipments) do
		if iter1_106 and not iter1_106:vertify() then
			return false
		end
	end

	return true
end

function var0_0.getEquipmentProperties(arg0_107)
	local var0_107 = {}
	local var1_107 = {}

	for iter0_107, iter1_107 in ipairs(var0_0.PROPERTIES) do
		var0_107[iter1_107] = 0
	end

	for iter2_107, iter3_107 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_107[iter3_107] = 0
	end

	for iter4_107, iter5_107 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_107[iter5_107] = 0
	end

	for iter6_107, iter7_107 in ipairs(var0_0.PROPERTIES_ENHANCEMENT) do
		var1_107[iter7_107] = 0
	end

	var0_107[AttributeType.AirDominate] = 0
	var0_107[AttributeType.AntiSiren] = 0

	local var2_107 = arg0_107:getActiveEquipments()

	for iter8_107, iter9_107 in ipairs(var2_107) do
		if iter9_107 then
			local var3_107 = iter9_107:GetAttributes()

			for iter10_107, iter11_107 in ipairs(var3_107) do
				if iter11_107 and var0_107[iter11_107.type] then
					var0_107[iter11_107.type] = var0_107[iter11_107.type] + iter11_107.value
				end
			end

			local var4_107 = iter9_107:GetPropertyRate()

			for iter12_107, iter13_107 in pairs(var4_107) do
				var1_107[iter12_107] = math.max(var1_107[iter12_107], iter13_107)
			end

			local var5_107 = iter9_107:GetSonarProperty()

			if var5_107 then
				for iter14_107, iter15_107 in pairs(var5_107) do
					var0_107[iter14_107] = var0_107[iter14_107] + iter15_107
				end
			end

			local var6_107 = iter9_107:GetAntiSirenPower()

			if var6_107 then
				var0_107[AttributeType.AntiSiren] = var0_107[AttributeType.AntiSiren] + var6_107 / 10000
			end
		end
	end

	;(function()
		local var0_108 = arg0_107:GetSpWeapon()

		if not var0_108 then
			return
		end

		local var1_108 = var0_108:GetPropertiesInfo().attrs

		for iter0_108, iter1_108 in ipairs(var1_108) do
			if iter1_108 and var0_107[iter1_108.type] then
				var0_107[iter1_108.type] = var0_107[iter1_108.type] + iter1_108.value
			end
		end
	end)()

	for iter16_107, iter17_107 in pairs(var1_107) do
		var1_107[iter16_107] = iter17_107 + 1
	end

	return var0_107, var1_107
end

function var0_0.getSkillEffects(arg0_109)
	local var0_109 = arg0_109:getShipSkillEffects()

	_.each(arg0_109:getEquipmentSkillEffects(), function(arg0_110)
		table.insert(var0_109, arg0_110)
	end)

	return var0_109
end

function var0_0.getShipSkillEffects(arg0_111)
	local var0_111 = {}
	local var1_111 = arg0_111:getSkillList()

	for iter0_111, iter1_111 in ipairs(var1_111) do
		local var2_111 = arg0_111:RemapSkillId(iter1_111)
		local var3_111 = pg.buffCfg["buff_" .. var2_111]

		arg0_111:FilterActiveSkill(var0_111, var3_111, arg0_111.skills[iter1_111])
	end

	return var0_111
end

function var0_0.getEquipmentSkillEffects(arg0_112)
	local var0_112 = {}
	local var1_112 = arg0_112:getActiveEquipments()

	for iter0_112, iter1_112 in ipairs(var1_112) do
		local var2_112
		local var3_112 = iter1_112 and iter1_112:getConfig("skill_id")[1]

		if var3_112 then
			var2_112 = pg.buffCfg["buff_" .. var3_112]
		end

		arg0_112:FilterActiveSkill(var0_112, var2_112)
	end

	;(function()
		local var0_113 = arg0_112:GetSpWeapon()
		local var1_113 = var0_113 and var0_113:GetEffect() or 0
		local var2_113

		if var1_113 > 0 then
			var2_113 = pg.buffCfg["buff_" .. var1_113]
		end

		arg0_112:FilterActiveSkill(var0_112, var2_113)
	end)()

	return var0_112
end

function var0_0.FilterActiveSkill(arg0_114, arg1_114, arg2_114, arg3_114)
	if not arg2_114 or not arg2_114.const_effect_list then
		return
	end

	for iter0_114 = 1, #arg2_114.const_effect_list do
		local var0_114 = arg2_114.const_effect_list[iter0_114]
		local var1_114 = var0_114.trigger
		local var2_114 = var0_114.arg_list
		local var3_114 = 1

		if arg3_114 then
			var3_114 = arg3_114.level

			local var4_114 = arg2_114[var3_114].const_effect_list

			if var4_114 and var4_114[iter0_114] then
				var1_114 = var4_114[iter0_114].trigger or var1_114
				var2_114 = var4_114[iter0_114].arg_list or var2_114
			end
		end

		local var5_114 = true

		for iter1_114, iter2_114 in pairs(var1_114) do
			if arg0_114.triggers[iter1_114] ~= iter2_114 then
				var5_114 = false

				break
			end
		end

		if var5_114 then
			table.insert(arg1_114, {
				type = var0_114.type,
				arg_list = var2_114,
				level = var3_114
			})
		end
	end
end

function var0_0.getEquipmentGearScore(arg0_115)
	local var0_115 = 0
	local var1_115 = arg0_115:getActiveEquipments()

	for iter0_115, iter1_115 in ipairs(var1_115) do
		if iter1_115 then
			var0_115 = var0_115 + iter1_115:GetGearScore()
		end
	end

	return var0_115
end

function var0_0.getProperties(arg0_116, arg1_116, arg2_116, arg3_116, arg4_116)
	local var0_116 = arg1_116 or {}
	local var1_116 = arg0_116:getConfig("nationality")
	local var2_116 = arg0_116:getConfig("type")
	local var3_116 = arg0_116:getShipProperties()
	local var4_116, var5_116 = arg0_116:getEquipmentProperties()
	local var6_116
	local var7_116
	local var8_116

	if arg3_116 and arg0_116:getFlag("inWorld") then
		local var9_116 = WorldConst.FetchWorldShip(arg0_116.id)

		var6_116, var7_116 = var9_116:GetShipBuffProperties()
		var8_116 = var9_116:GetShipPowerBuffProperties()
	end

	for iter0_116, iter1_116 in ipairs(var0_0.PROPERTIES) do
		local var10_116 = 0
		local var11_116 = 0

		for iter2_116, iter3_116 in pairs(var0_116) do
			var10_116 = var10_116 + iter3_116:getAttrRatioAddition(iter1_116, var1_116, var2_116) / 100
			var11_116 = var11_116 + iter3_116:getAttrValueAddition(iter1_116, var1_116, var2_116)
		end

		local var12_116 = var10_116 + (var5_116[iter1_116] or 1)
		local var13_116 = var7_116 and var7_116[iter1_116] or 1
		local var14_116 = var6_116 and var6_116[iter1_116] or 0

		if iter1_116 == AttributeType.Speed then
			var3_116[iter1_116] = var3_116[iter1_116] * var12_116 * var13_116 + var11_116 + var4_116[iter1_116] + var14_116
		else
			var3_116[iter1_116] = calcFloor(calcFloor(var3_116[iter1_116]) * var12_116 * var13_116) + var11_116 + var4_116[iter1_116] + var14_116
		end
	end

	if not arg2_116 and arg0_116:isMaxStar() then
		for iter4_116, iter5_116 in pairs(var3_116) do
			local var15_116 = arg4_116 and arg0_116:getTechNationMaxAddition(iter4_116) or arg0_116:getTechNationAddition(iter4_116)

			var3_116[iter4_116] = var3_116[iter4_116] + var15_116
		end
	end

	for iter6_116, iter7_116 in ipairs(var0_0.DIVE_PROPERTIES) do
		var3_116[iter7_116] = var3_116[iter7_116] + var4_116[iter7_116]
	end

	for iter8_116, iter9_116 in ipairs(var0_0.SONAR_PROPERTIES) do
		var3_116[iter9_116] = var3_116[iter9_116] + var4_116[iter9_116]
	end

	if arg3_116 then
		var3_116[AttributeType.AntiSiren] = (var3_116[AttributeType.AntiSiren] or 0) + var4_116[AttributeType.AntiSiren]
	end

	if var8_116 then
		for iter10_116, iter11_116 in pairs(var8_116) do
			if var3_116[iter10_116] then
				if iter10_116 == AttributeType.Speed then
					var3_116[iter10_116] = var3_116[iter10_116] * iter11_116
				else
					var3_116[iter10_116] = math.floor(var3_116[iter10_116] * iter11_116)
				end
			end
		end
	end

	return var3_116
end

function var0_0.getTransGearScore(arg0_117)
	local var0_117 = 0
	local var1_117 = pg.transform_data_template

	for iter0_117, iter1_117 in pairs(arg0_117.transforms) do
		for iter2_117 = 1, iter1_117.level do
			var0_117 = var0_117 + (var1_117[iter1_117.id].gear_score[iter2_117] or 0)
		end
	end

	return var0_117
end

function var0_0.getShipCombatPower(arg0_118, arg1_118)
	local var0_118 = arg0_118:getProperties(arg1_118, nil, nil, true)
	local var1_118 = var0_118[AttributeType.Durability] / 5 + var0_118[AttributeType.Cannon] + var0_118[AttributeType.Torpedo] + var0_118[AttributeType.AntiAircraft] + var0_118[AttributeType.Air] + var0_118[AttributeType.AntiSub] + var0_118[AttributeType.Reload] + var0_118[AttributeType.Hit] * 2 + var0_118[AttributeType.Dodge] * 2 + var0_118[AttributeType.Speed] + arg0_118:getEquipmentGearScore() + arg0_118:getTransGearScore()

	return math.floor(var1_118)
end

function var0_0.cosumeEnergy(arg0_119, arg1_119)
	arg0_119:setEnergy(math.max(arg0_119:getEnergy() - arg1_119, 0))
end

function var0_0.addEnergy(arg0_120, arg1_120)
	arg0_120:setEnergy(arg0_120:getEnergy() + arg1_120)
end

function var0_0.setEnergy(arg0_121, arg1_121)
	arg0_121.energy = arg1_121
end

function var0_0.setLikability(arg0_122, arg1_122)
	assert(arg1_122 >= 0 and arg1_122 <= arg0_122.maxIntimacy, "intimacy value invaild" .. arg1_122)
	arg0_122:setIntimacy(arg1_122)
end

function var0_0.addLikability(arg0_123, arg1_123)
	local var0_123 = Mathf.Clamp(arg0_123:getIntimacy() + arg1_123, 0, arg0_123.maxIntimacy)

	arg0_123:setIntimacy(var0_123)
end

function var0_0.setIntimacy(arg0_124, arg1_124)
	if arg1_124 > 10000 and not arg0_124.propose then
		arg1_124 = 10000
	end

	arg0_124.intimacy = arg1_124

	if not arg0_124:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0_124.groupId]:updateMaxIntimacy(arg0_124:getIntimacy())
	end
end

function var0_0.getLevelExpConfig(arg0_125, arg1_125)
	if arg0_125:getConfig("rarity") == ShipRarity.SSR then
		local var0_125 = Clone(getConfigFromLevel1(var6_0, arg1_125 or arg0_125.level))

		var0_125.exp = var0_125.exp_ur
		var0_125.exp_start = var0_125.exp_ur_start
		var0_125.exp_interval = var0_125.exp_ur_interval
		var0_125.exp_end = var0_125.exp_ur_end

		return var0_125
	else
		return getConfigFromLevel1(var6_0, arg1_125 or arg0_125.level)
	end
end

function var0_0.getExp(arg0_126)
	local var0_126 = arg0_126:getMaxLevel()

	if arg0_126.level == var0_126 and LOCK_FULL_EXP then
		return 0
	end

	return arg0_126.exp
end

function var0_0.getProficiency(arg0_127)
	return arg0_127.proficiency
end

function var0_0.addExp(arg0_128, arg1_128, arg2_128)
	local var0_128 = arg0_128:getMaxLevel()

	if arg0_128.level == var0_128 then
		if arg0_128.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2_128 or not arg0_128:CanAccumulateExp() then
			arg1_128 = 0
		end
	end

	arg0_128.exp = arg0_128.exp + arg1_128

	local var1_128 = false

	while arg0_128:canLevelUp() do
		arg0_128.exp = arg0_128.exp - arg0_128:getLevelExpConfig().exp_interval
		arg0_128.level = math.min(arg0_128.level + 1, var0_128)
		var1_128 = true
	end

	if arg0_128.level == var0_128 then
		if arg2_128 and arg0_128:CanAccumulateExp() then
			arg0_128.exp = math.min(arg0_128.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1_128 then
			arg0_128.exp = 0
		end
	end
end

function var0_0.getMaxLevel(arg0_129)
	return arg0_129.maxLevel
end

function var0_0.canLevelUp(arg0_130)
	local var0_130 = arg0_130:getLevelExpConfig(arg0_130.level + 1)
	local var1_130 = arg0_130:getMaxLevel() <= arg0_130.level

	return var0_130 and arg0_130:getLevelExpConfig().exp_interval <= arg0_130.exp and not var1_130
end

function var0_0.getConfigMaxLevel(arg0_131)
	return var6_0.all[#var6_0.all]
end

function var0_0.isConfigMaxLevel(arg0_132)
	return arg0_132.level == arg0_132:getConfigMaxLevel()
end

function var0_0.updateMaxLevel(arg0_133, arg1_133)
	local var0_133 = arg0_133:getConfigMaxLevel()

	arg0_133.maxLevel = math.max(math.min(var0_133, arg1_133), arg0_133.maxLevel)
end

function var0_0.getNextMaxLevel(arg0_134)
	local var0_134 = arg0_134:getConfigMaxLevel()

	for iter0_134 = arg0_134:getMaxLevel() + 1, var0_134 do
		if var6_0[iter0_134].level_limit == 1 then
			return iter0_134
		end
	end
end

function var0_0.canUpgrade(arg0_135)
	if arg0_135:isBluePrintShip() then
		return false
	end

	if arg0_135:isMetaShip() then
		local var0_135 = arg0_135:getMetaCharacter()

		if not var0_135 then
			return false
		end

		local var1_135 = var0_135:getBreakOutInfo()

		if not var1_135:hasNextInfo() then
			return false
		end

		local var2_135, var3_135 = var1_135:getLimited()

		if var2_135 > arg0_135.level then
			return false
		end

		return true
	else
		local var4_135 = var8_0[arg0_135.configId]

		assert(var4_135, "不存在配置" .. arg0_135.configId)

		return not arg0_135:isMaxStar() and arg0_135.level >= var4_135.level
	end
end

function var0_0.isReachNextMaxLevel(arg0_136)
	return arg0_136.level == arg0_136:getMaxLevel() and arg0_136:CanAccumulateExp() and arg0_136:getNextMaxLevel() ~= nil
end

function var0_0.isAwakening(arg0_137)
	return arg0_137:isReachNextMaxLevel() and arg0_137.level < var4_0
end

function var0_0.isAwakening2(arg0_138)
	return arg0_138:isReachNextMaxLevel() and arg0_138.level >= var4_0
end

function var0_0.notMaxLevelForFilter(arg0_139)
	return arg0_139.level ~= arg0_139:getMaxLevel()
end

function var0_0.getNextMaxLevelConsume(arg0_140)
	local var0_140 = arg0_140:getMaxLevel()
	local var1_140 = var6_0[var0_140]["need_item_rarity" .. arg0_140:getConfig("rarity")]

	assert(var1_140, "items  can not be nil")

	return _.map(var1_140, function(arg0_141)
		return {
			type = arg0_141[1],
			id = arg0_141[2],
			count = arg0_141[3]
		}
	end)
end

function var0_0.canUpgradeMaxLevel(arg0_142)
	if not arg0_142:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0_142 = getProxy(PlayerProxy):getData()
		local var1_142 = getProxy(BagProxy)
		local var2_142 = arg0_142:getNextMaxLevelConsume()

		for iter0_142, iter1_142 in pairs(var2_142) do
			if iter1_142.type == DROP_TYPE_RESOURCE then
				if var0_142:getResById(iter1_142.id) < iter1_142.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1_142.type == DROP_TYPE_ITEM and var1_142:getItemCountById(iter1_142.id) < iter1_142.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.CanAccumulateExp(arg0_143)
	return pg.ship_data_template[arg0_143.configId].can_get_proficency == 1
end

function var0_0.getTotalExp(arg0_144)
	return arg0_144:getLevelExpConfig().exp_start + arg0_144.exp
end

function var0_0.getStartBattleExpend(arg0_145)
	if table.contains(TeamType.SubShipType, arg0_145:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0_145.configId].oil_at_start
	end
end

function var0_0.getEndBattleExpend(arg0_146)
	local var0_146 = pg.ship_data_template[arg0_146.configId]
	local var1_146 = arg0_146:getLevelExpConfig()

	return (math.floor(var0_146.oil_at_end * var1_146.fight_oil_ratio / 10000))
end

function var0_0.getBattleTotalExpend(arg0_147)
	return arg0_147:getStartBattleExpend() + arg0_147:getEndBattleExpend()
end

function var0_0.getShipAmmo(arg0_148)
	local var0_148 = arg0_148:getConfig(AttributeType.Ammo)

	for iter0_148, iter1_148 in pairs(arg0_148:getAllSkills()) do
		local var1_148 = tonumber(iter0_148 .. string.format("%.2d", iter1_148.level))
		local var2_148 = pg.skill_benefit_template[var1_148]

		if var2_148 and arg0_148:IsBenefitSkillActive(var2_148) and (var2_148.type == var0_0.BENEFIT_EQUIP or var2_148.type == var0_0.BENEFIT_SKILL) then
			var0_148 = var0_148 + defaultValue(var2_148.effect[1], 0)
		end
	end

	local var3_148 = arg0_148:getActiveEquipments()

	for iter2_148, iter3_148 in ipairs(var3_148) do
		local var4_148 = iter3_148 and iter3_148:getConfig("equip_parameters").ammo

		if var4_148 then
			var0_148 = var0_148 + var4_148
		end
	end

	return var0_148
end

function var0_0.getHuntingLv(arg0_149)
	local var0_149 = arg0_149:getConfig("huntingrange_level")

	for iter0_149, iter1_149 in pairs(arg0_149:getAllSkills()) do
		local var1_149 = tonumber(iter0_149 .. string.format("%.2d", iter1_149.level))
		local var2_149 = pg.skill_benefit_template[var1_149]

		if var2_149 and arg0_149:IsBenefitSkillActive(var2_149) and (var2_149.type == var0_0.BENEFIT_EQUIP or var2_149.type == var0_0.BENEFIT_SKILL) then
			var0_149 = var0_149 + defaultValue(var2_149.effect[2], 0)
		end
	end

	local var3_149 = arg0_149:getActiveEquipments()

	for iter2_149, iter3_149 in ipairs(var3_149) do
		local var4_149 = iter3_149 and iter3_149:getConfig("equip_parameters").hunting_lv

		if var4_149 then
			var0_149 = var0_149 + var4_149
		end
	end

	return (math.min(var0_149, arg0_149:getMaxHuntingLv()))
end

function var0_0.getMapAuras(arg0_150)
	local var0_150 = {}

	for iter0_150, iter1_150 in pairs(arg0_150:getAllSkills()) do
		local var1_150 = tonumber(iter0_150 .. string.format("%.2d", iter1_150.level))
		local var2_150 = pg.skill_benefit_template[var1_150]

		if var2_150 and arg0_150:IsBenefitSkillActive(var2_150) and var2_150.type == var0_0.BENEFIT_MAP_AURA then
			local var3_150 = {
				id = var2_150.effect[1],
				level = iter1_150.level
			}

			table.insert(var0_150, var3_150)
		end
	end

	return var0_150
end

function var0_0.getMapAids(arg0_151)
	local var0_151 = {}

	for iter0_151, iter1_151 in pairs(arg0_151:getAllSkills()) do
		local var1_151 = tonumber(iter0_151 .. string.format("%.2d", iter1_151.level))
		local var2_151 = pg.skill_benefit_template[var1_151]

		if var2_151 and arg0_151:IsBenefitSkillActive(var2_151) and var2_151.type == var0_0.BENEFIT_AID then
			local var3_151 = {
				id = var2_151.effect[1],
				level = iter1_151.level
			}

			table.insert(var0_151, var3_151)
		end
	end

	return var0_151
end

var0_0.BENEFIT_SKILL = 2
var0_0.BENEFIT_EQUIP = 3
var0_0.BENEFIT_MAP_AURA = 4
var0_0.BENEFIT_AID = 5

function var0_0.IsBenefitSkillActive(arg0_152, arg1_152)
	local var0_152 = false

	if arg1_152.type == var0_0.BENEFIT_SKILL then
		if not arg1_152.limit[1] or arg1_152.limit[1] == arg0_152.triggers.TeamNumbers then
			var0_152 = true
		end
	elseif arg1_152.type == var0_0.BENEFIT_EQUIP then
		local var1_152 = arg1_152.limit
		local var2_152 = arg0_152:getAllEquipments()

		for iter0_152, iter1_152 in ipairs(var2_152) do
			if iter1_152 and table.contains(var1_152, iter1_152:getConfig("id")) then
				var0_152 = true

				break
			end
		end
	elseif arg1_152.type == var0_0.BENEFIT_MAP_AURA then
		if arg0_152.hpRant and arg0_152.hpRant > 0 then
			return true
		end
	elseif arg1_152.type == var0_0.BENEFIT_AID and arg0_152.hpRant and arg0_152.hpRant > 0 then
		return true
	end

	return var0_152
end

function var0_0.getMaxHuntingLv(arg0_153)
	return #arg0_153:getConfig("hunting_range")
end

function var0_0.getHuntingRange(arg0_154, arg1_154)
	local var0_154 = arg0_154:getConfig("hunting_range")
	local var1_154 = Clone(var0_154[1])
	local var2_154 = arg1_154 or arg0_154:getHuntingLv()
	local var3_154 = math.min(var2_154, arg0_154:getMaxHuntingLv())

	for iter0_154 = 2, var3_154 do
		_.each(var0_154[iter0_154], function(arg0_155)
			table.insert(var1_154, {
				arg0_155[1],
				arg0_155[2]
			})
		end)
	end

	return var1_154
end

function var0_0.getTriggerSkills(arg0_156)
	local var0_156 = {}
	local var1_156 = arg0_156:getSkillEffects()

	_.each(var1_156, function(arg0_157)
		if arg0_157.type == "AddBuff" and arg0_157.arg_list and arg0_157.arg_list.buff_id then
			local var0_157 = arg0_157.arg_list.buff_id

			var0_156[var0_157] = {
				id = var0_157,
				level = arg0_157.level
			}
		end
	end)

	return var0_156
end

function var0_0.GetEquipmentSkills(arg0_158)
	local var0_158 = {}
	local var1_158 = arg0_158:getActiveEquipments()

	for iter0_158, iter1_158 in ipairs(var1_158) do
		if iter1_158 then
			local var2_158 = iter1_158:getConfig("skill_id")[1]

			if var2_158 then
				var0_158[var2_158] = {
					level = 1,
					id = var2_158
				}
			end
		end
	end

	;(function()
		local var0_159 = arg0_158:GetSpWeapon()
		local var1_159 = var0_159 and var0_159:GetEffect() or 0

		if var1_159 > 0 then
			var0_158[var1_159] = {
				level = 1,
				id = var1_159
			}
		end
	end)()

	return var0_158
end

function var0_0.getAllSkills(arg0_160)
	local var0_160 = Clone(arg0_160.skills)

	for iter0_160, iter1_160 in pairs(arg0_160:GetEquipmentSkills()) do
		var0_160[iter0_160] = iter1_160
	end

	for iter2_160, iter3_160 in pairs(arg0_160:getTriggerSkills()) do
		var0_160[iter2_160] = iter3_160
	end

	return var0_160
end

function var0_0.isSameKind(arg0_161, arg1_161)
	return pg.ship_data_template[arg0_161.configId].group_type == pg.ship_data_template[arg1_161.configId].group_type
end

function var0_0.GetLockState(arg0_162)
	return arg0_162.lockState
end

function var0_0.IsLocked(arg0_163)
	return arg0_163.lockState == var0_0.LOCK_STATE_LOCK
end

function var0_0.SetLockState(arg0_164, arg1_164)
	arg0_164.lockState = arg1_164
end

function var0_0.GetPreferenceTag(arg0_165)
	return arg0_165.preferenceTag or 0
end

function var0_0.IsPreferenceTag(arg0_166)
	return arg0_166:GetPreferenceTag() == var0_0.PREFERENCE_TAG_COMMON
end

function var0_0.SetPreferenceTag(arg0_167, arg1_167)
	arg0_167.preferenceTag = arg1_167
end

function var0_0.calReturnRes(arg0_168)
	local var0_168 = pg.ship_data_by_type[arg0_168:getShipType()]
	local var1_168 = var0_168.distory_resource_gold_ratio
	local var2_168 = var0_168.distory_resource_oil_ratio
	local var3_168 = pg.ship_data_by_star[arg0_168:getConfig("rarity")].destory_item

	return var1_168, 0, var3_168
end

function var0_0.getRarity(arg0_169)
	local var0_169 = arg0_169:getConfig("rarity")

	if arg0_169:isRemoulded() then
		var0_169 = var0_169 + 1
	end

	return var0_169
end

function var0_0.getExchangePrice(arg0_170)
	local var0_170 = arg0_170:getConfig("rarity")

	return pg.ship_data_by_star[var0_170].exchange_price
end

function var0_0.updateSkill(arg0_171, arg1_171)
	local var0_171 = arg1_171.skill_id or arg1_171.id
	local var1_171 = arg1_171.skill_lv or arg1_171.lv or arg1_171.level
	local var2_171 = arg1_171.skill_exp or arg1_171.exp

	arg0_171.skills[var0_171] = {
		id = var0_171,
		level = var1_171,
		exp = var2_171
	}
end

function var0_0.canEquipAtPos(arg0_172, arg1_172, arg2_172)
	local var0_172, var1_172 = arg0_172:isForbiddenAtPos(arg1_172, arg2_172)

	if var0_172 then
		return false, var1_172
	end

	for iter0_172, iter1_172 in ipairs(arg0_172.equipments) do
		if iter1_172 and iter0_172 ~= arg2_172 and iter1_172:getConfig("equip_limit") ~= 0 and arg1_172:getConfig("equip_limit") == iter1_172:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0_0.isForbiddenAtPos(arg0_173, arg1_173, arg2_173)
	local var0_173 = pg.ship_data_template[arg0_173.configId]

	assert(var0_173, "can not find ship in ship_data_templtae: " .. arg0_173.configId)

	local var1_173 = var0_173["equip_" .. arg2_173]

	if not table.contains(var1_173, arg1_173:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1_173:getConfig("ship_type_forbidden"), arg0_173:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0_0.canEquipCommander(arg0_174, arg1_174)
	if arg1_174:getShipType() ~= arg0_174:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0_0.upgrade(arg0_175)
	local var0_175 = pg.ship_data_transform[arg0_175.configId]

	if var0_175.trans_id and var0_175.trans_id > 0 then
		arg0_175.configId = var0_175.trans_id
		arg0_175.star = arg0_175:getConfig("star")
	end
end

function var0_0.getTeamType(arg0_176)
	return TeamType.GetTeamFromShipType(arg0_176:getShipType())
end

function var0_0.getFleetName(arg0_177)
	local var0_177 = arg0_177:getTeamType()

	return var1_0[var0_177]
end

function var0_0.getMaxConfigId(arg0_178)
	local var0_178 = pg.ship_data_template
	local var1_178

	for iter0_178 = 4, 1, -1 do
		local var2_178 = tonumber(arg0_178.groupId .. iter0_178)

		if var0_178[var2_178] then
			var1_178 = var2_178

			break
		end
	end

	return var1_178
end

function var0_0.getFlag(arg0_179, arg1_179, arg2_179)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_179.id, arg1_179, arg2_179)
end

function var0_0.hasAnyFlag(arg0_180, arg1_180)
	return _.any(arg1_180, function(arg0_181)
		return arg0_180:getFlag(arg0_181)
	end)
end

function var0_0.isBreakOut(arg0_182)
	return arg0_182.configId % 10 > 1
end

function var0_0.fateSkillChange(arg0_183, arg1_183)
	if not arg0_183.skillChangeList then
		arg0_183.skillChangeList = arg0_183:isBluePrintShip() and arg0_183:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_183, iter1_183 in ipairs(arg0_183.skillChangeList) do
		if iter1_183[1] == arg1_183 and arg0_183.skills[iter1_183[2]] then
			return iter1_183[2]
		end
	end

	return arg1_183
end

function var0_0.RemapSkillId(arg0_184, arg1_184)
	local var0_184 = arg0_184:GetSpWeapon()

	if var0_184 then
		return var0_184:RemapSkillId(arg1_184)
	end

	return arg1_184
end

function var0_0.getSkillList(arg0_185)
	local var0_185 = pg.ship_data_template[arg0_185.configId]
	local var1_185 = Clone(var0_185.buff_list_display)
	local var2_185 = Clone(var0_185.buff_list)
	local var3_185 = pg.ship_data_trans[arg0_185.groupId]
	local var4_185 = 0

	if var3_185 and var3_185.skill_id ~= 0 then
		local var5_185 = var3_185.skill_id
		local var6_185 = pg.transform_data_template[var5_185]

		if arg0_185.transforms[var5_185] and var6_185.skill_id ~= 0 then
			table.insert(var2_185, var6_185.skill_id)
		end
	end

	local var7_185 = {}

	for iter0_185, iter1_185 in ipairs(var1_185) do
		for iter2_185, iter3_185 in ipairs(var2_185) do
			if iter1_185 == iter3_185 then
				table.insert(var7_185, arg0_185:fateSkillChange(iter1_185))
			end
		end
	end

	return var7_185
end

function var0_0.getModAttrTopLimit(arg0_186, arg1_186)
	local var0_186 = ShipModAttr.ATTR_TO_INDEX[arg1_186]
	local var1_186 = pg.ship_data_template[arg0_186.configId].strengthen_id
	local var2_186 = pg.ship_data_strengthen[var1_186].durability[var0_186]

	return calcFloor((3 + 7 * (math.min(arg0_186.level, 100) / 100)) * var2_186 * 0.1)
end

function var0_0.leftModAdditionPoint(arg0_187, arg1_187)
	local var0_187 = arg0_187:getModProperties(arg1_187)
	local var1_187 = arg0_187:getModExpRatio(arg1_187)
	local var2_187 = arg0_187:getModAttrTopLimit(arg1_187)
	local var3_187 = calcFloor(var0_187 / var1_187)

	return math.max(0, var2_187 - var3_187)
end

function var0_0.getModAttrBaseMax(arg0_188, arg1_188)
	if not table.contains(arg0_188:getConfig("lock"), arg1_188) then
		local var0_188 = arg0_188:leftModAdditionPoint(arg1_188)
		local var1_188 = arg0_188:getShipProperties()

		return calcFloor(var1_188[arg1_188] + var0_188)
	else
		return 0
	end
end

function var0_0.getModExpRatio(arg0_189, arg1_189)
	if not table.contains(arg0_189:getConfig("lock"), arg1_189) then
		local var0_189 = pg.ship_data_template[arg0_189.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0_189], "ship_data_strengthen>>>>>>" .. var0_189)

		return math.max(pg.ship_data_strengthen[var0_189].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1_189]], 1)
	else
		return 1
	end
end

function var0_0.inUnlockTip(arg0_190)
	local var0_190 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0_190, arg0_190)
end

function var0_0.proposeSkinOwned(arg0_191, arg1_191)
	return arg1_191 and arg0_191.propose and arg1_191.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0_0.getProposeSkin(arg0_192)
	return ShipSkin.GetSkinByType(arg0_192.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getDisplaySkillIds(arg0_193)
	return _.map(pg.ship_data_template[arg0_193.configId].buff_list_display, function(arg0_194)
		return arg0_193:fateSkillChange(arg0_194)
	end)
end

function var0_0.isFullSkillLevel(arg0_195)
	local var0_195 = pg.skill_data_template

	for iter0_195, iter1_195 in pairs(arg0_195.skills) do
		if var0_195[iter1_195.id].max_level ~= iter1_195.level then
			return false
		end
	end

	return true
end

function var0_0.setEquipmentRecord(arg0_196, arg1_196, arg2_196)
	local var0_196 = "equipment_record" .. "_" .. arg1_196 .. "_" .. arg0_196.id

	PlayerPrefs.SetString(var0_196, table.concat(_.flatten(arg2_196), ":"))
	PlayerPrefs.Save()
end

function var0_0.getEquipmentRecord(arg0_197, arg1_197)
	if not arg0_197.equipmentRecords then
		local var0_197 = "equipment_record" .. "_" .. arg1_197 .. "_" .. arg0_197.id
		local var1_197 = string.split(PlayerPrefs.GetString(var0_197) or "", ":")
		local var2_197 = {}

		for iter0_197 = 1, 3 do
			var2_197[iter0_197] = _.map(_.slice(var1_197, 5 * iter0_197 - 4, 5), function(arg0_198)
				return tonumber(arg0_198)
			end)
		end

		arg0_197.equipmentRecords = var2_197
	end

	return arg0_197.equipmentRecords
end

function var0_0.SetSpWeaponRecord(arg0_199, arg1_199, arg2_199)
	local var0_199 = "spweapon_record" .. "_" .. arg1_199 .. "_" .. arg0_199.id
	local var1_199 = _.map({
		1,
		2,
		3
	}, function(arg0_200)
		local var0_200 = arg2_199[arg0_200]

		if var0_200 then
			return (var0_200:GetUID() or 0) .. "," .. var0_200:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0_199, table.concat(var1_199, ":"))
	PlayerPrefs.Save()
end

function var0_0.GetSpWeaponRecord(arg0_201, arg1_201)
	local var0_201 = "spweapon_record" .. "_" .. arg1_201 .. "_" .. arg0_201.id

	return (_.map(string.split(PlayerPrefs.GetString(var0_201, ""), ":"), function(arg0_202)
		local var0_202 = string.split(arg0_202, ",")

		assert(var0_202)

		local var1_202 = tonumber(var0_202[1])
		local var2_202 = tonumber(var0_202[2])

		if not var2_202 or var2_202 == 0 then
			return false
		end

		return (SpWeapon.New({
			id = var2_202
		}))
	end))
end

function var0_0.hasEquipEquipmentSkin(arg0_203)
	for iter0_203, iter1_203 in ipairs(arg0_203.equipments) do
		if iter1_203 and iter1_203:hasSkin() then
			return true
		end
	end

	return false
end

function var0_0.hasCommander(arg0_204)
	return arg0_204.commanderId and arg0_204.commanderId ~= 0
end

function var0_0.getCommander(arg0_205)
	return arg0_205.commanderId
end

function var0_0.setCommander(arg0_206, arg1_206)
	arg0_206.commanderId = arg1_206
end

function var0_0.getSkillIndex(arg0_207, arg1_207)
	local var0_207 = arg0_207:getSkillList()

	for iter0_207, iter1_207 in ipairs(var0_207) do
		if arg1_207 == iter1_207 then
			return iter0_207
		end
	end
end

function var0_0.getTactics(arg0_208)
	return 1, "tactics_attack"
end

function var0_0.IsBgmSkin(arg0_209)
	local var0_209 = arg0_209:GetSkinConfig()

	return table.contains(var0_209.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_210)
	if arg0_210:IsBgmSkin() then
		return arg0_210:GetSkinConfig().bgm
	end
end

function var0_0.isIntensifyMax(arg0_211)
	local var0_211 = intProperties(arg0_211:getShipProperties())

	if arg0_211:isBluePrintShip() then
		return true
	end

	for iter0_211, iter1_211 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_211:getModAttrBaseMax(iter1_211) ~= var0_211[iter1_211] then
			return false
		end
	end

	return true
end

function var0_0.isRemouldable(arg0_212)
	return not arg0_212:isTestShip() and not arg0_212:isBluePrintShip() and pg.ship_data_trans[arg0_212.groupId]
end

function var0_0.isAllRemouldFinish(arg0_213)
	local var0_213 = pg.ship_data_trans[arg0_213.groupId]

	assert(var0_213, "this ship group without remould config:" .. arg0_213.groupId)

	for iter0_213, iter1_213 in ipairs(var0_213.transform_list) do
		for iter2_213, iter3_213 in ipairs(iter1_213) do
			local var1_213 = pg.transform_data_template[iter3_213[2]]

			if #var1_213.edit_trans > 0 then
				-- block empty
			elseif not arg0_213.transforms[iter3_213[2]] or arg0_213.transforms[iter3_213[2]].level < var1_213.max_level then
				return false
			end
		end
	end

	return true
end

function var0_0.isSpecialFilter(arg0_214)
	local var0_214 = pg.ship_data_statistics[arg0_214.configId]

	assert(var0_214, "this ship without statistics:" .. arg0_214.configId)

	for iter0_214, iter1_214 in ipairs(var0_214.tag_list) do
		if iter1_214 == "special" then
			return true
		end
	end

	return false
end

function var0_0.hasAvailiableSkin(arg0_215)
	local var0_215 = getProxy(ShipSkinProxy)
	local var1_215 = var0_215:GetAllSkinForShip(arg0_215)
	local var2_215 = var0_215:getRawData()
	local var3_215 = 0

	for iter0_215, iter1_215 in ipairs(var1_215) do
		if arg0_215:proposeSkinOwned(iter1_215) or var2_215[iter1_215.id] then
			var3_215 = var3_215 + 1
		end
	end

	return var3_215 > 0
end

function var0_0.hasProposeSkin(arg0_216)
	local var0_216 = getProxy(ShipSkinProxy)
	local var1_216 = var0_216:GetAllSkinForShip(arg0_216)

	for iter0_216, iter1_216 in ipairs(var1_216) do
		if iter1_216.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2_216 = var0_216:GetShareSkinsForShip(arg0_216)

	for iter2_216, iter3_216 in ipairs(var2_216) do
		if iter3_216.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0_0.HasUniqueSpWeapon(arg0_217)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0_217:getGroupId()])
end

function var0_0.getAircraftReloadCD(arg0_218)
	local var0_218 = arg0_218:getConfigTable().base_list
	local var1_218 = arg0_218:getConfigTable().default_equip_list
	local var2_218 = 0
	local var3_218 = 0

	for iter0_218 = 1, 3 do
		local var4_218 = arg0_218:getEquip(iter0_218)
		local var5_218 = var4_218 and var4_218.configId or var1_218[iter0_218]
		local var6_218 = Equipment.getConfigData(var5_218).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0_219)
			return var6_218 == arg0_219
		end) then
			var2_218 = var2_218 + Equipment.GetEquipReloadStatic(var5_218) * var0_218[iter0_218]
			var3_218 = var3_218 + var0_218[iter0_218]
		end
	end

	local var7_218 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2_218 / var3_218 * var7_218
	}
end

function var0_0.IsTagShip(arg0_220, arg1_220)
	local var0_220 = arg0_220:getConfig("tag_list")

	return table.contains(var0_220, arg1_220)
end

function var0_0.setReMetaSpecialItemVO(arg0_221, arg1_221)
	arg0_221.reMetaSpecialItemVO = arg1_221
end

function var0_0.getReMetaSpecialItemVO(arg0_222, arg1_222)
	return arg0_222.reMetaSpecialItemVO
end

function var0_0.getProposeType(arg0_223)
	if arg0_223:isMetaShip() then
		return "meta"
	elseif arg0_223:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_224)
	return arg0_224:getNation() == Nation.IDOL_LINK
end

function var0_0.getSpecificType(arg0_225)
	return pg.ship_data_template[arg0_225.configId].specific_type
end

function var0_0.GetSpWeapon(arg0_226)
	return arg0_226.spWeapon
end

function var0_0.UpdateSpWeapon(arg0_227, arg1_227)
	local var0_227 = (arg1_227 and arg1_227:GetUID() or 0) == (arg0_227.spWeapon and arg0_227.spWeapon:GetUID() or 0)

	arg0_227.spWeapon = arg1_227

	if arg1_227 then
		arg1_227:SetShipId(arg0_227.id)
	end

	if var0_227 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0_0.CanEquipSpWeapon(arg0_228, arg1_228)
	local var0_228, var1_228 = arg0_228:IsSpWeaponForbidden(arg1_228)

	if var0_228 then
		return false, var1_228
	end

	return true
end

function var0_0.IsSpWeaponForbidden(arg0_229, arg1_229)
	local var0_229 = arg1_229:GetWearableShipTypes()
	local var1_229 = arg0_229:getShipType()

	if not table.contains(var0_229, var1_229) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2_229 = arg1_229:GetUniqueGroup()
	local var3_229 = arg0_229:getGroupId()

	if var2_229 ~= 0 and var2_229 ~= var3_229 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0_0.GetMapStrikeAnim(arg0_230)
	local var0_230
	local var1_230 = arg0_230:getShipType()

	switch(TeamType.GetTeamFromShipType(var1_230), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1_230) then
				var0_230 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1_230) then
				var0_230 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1_230) then
				var0_230 = "CannonUI"
			else
				var0_230 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1_230) then
				var0_230 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0_230:getNation() == Nation.MOT then
				var0_230 = "CannonUI"
			else
				var0_230 = "SubTorpedoUI"
			end
		end
	})

	return var0_230
end

function var0_0.IsDefaultSkin(arg0_234)
	return arg0_234.skinId == 0 or arg0_234.skinId == arg0_234:getConfig("skin_id")
end

function var0_0.IsMatchKey(arg0_235, arg1_235)
	if not arg1_235 or arg1_235 == "" then
		return true
	end

	arg1_235 = string.lower(string.gsub(arg1_235, "%.", "%%."))

	return string.find(string.lower(arg0_235:GetDefaultName()), arg1_235)
end

function var0_0.IsOwner(arg0_236)
	return tobool(arg0_236.id)
end

function var0_0.GetUniqueId(arg0_237)
	return arg0_237.id
end

function var0_0.ShowPropose(arg0_238)
	if not arg0_238.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0_238:IsOwner() and arg0_238:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0_0.GetColorName(arg0_239, arg1_239)
	arg1_239 = arg1_239 or arg0_239:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0_239.propose then
		return setColorStr(arg1_239, "#FFAACEFF")
	else
		return arg1_239
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

function var0_0.GetFrameAndEffect(arg0_240, arg1_240)
	arg1_240 = tobool(arg1_240)

	local var0_240
	local var1_240

	if arg0_240.propose then
		if arg0_240:isMetaShip() then
			var1_240 = string.format(var9_0.effect[1])
			var0_240 = string.format(var9_0.frame[1])
		elseif arg0_240:isBluePrintShip() then
			var1_240 = string.format(var9_0.effect[2])
			var0_240 = string.format(var9_0.frame[2], arg0_240:rarity2bgPrint())
		else
			var1_240 = string.format(var9_0.effect[3])
			var0_240 = string.format(var9_0.frame[3])
		end

		if not arg0_240:ShowPropose() then
			var0_240 = nil
		end
	elseif arg0_240:isMetaShip() then
		var1_240 = string.format(var9_0.effect[4], arg0_240:rarity2bgPrint())
	elseif arg0_240:getRarity() == ShipRarity.SSR then
		var1_240 = string.format(var9_0.effect[5])
	end

	if arg1_240 then
		var1_240 = var1_240 and var1_240 .. "_1"
	end

	return var0_240, var1_240
end

function var0_0.GetRecordPosKey(arg0_241)
	return arg0_241.skinId
end

return var0_0
