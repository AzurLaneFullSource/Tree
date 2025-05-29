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
	local var0_7 = arg0_7:getSkinId()

	if var0_7 == arg1_7 then
		return true
	end

	local var1_7 = ShipSkin.GetChangeSkinGroupId(var0_7)
	local var2_7 = ShipSkin.GetChangeSkinGroupId(arg1_7)

	if var1_7 and var2_7 and var1_7 == var2_7 then
		return true
	end

	return false
end

function var0_0.rarity2bgPrint(arg0_8)
	return shipRarity2bgPrint(arg0_8:getRarity(), arg0_8:isBluePrintShip(), arg0_8:isMetaShip())
end

function var0_0.rarity2bgPrintForGet(arg0_9)
	return skinId2bgPrint(arg0_9:getSkinId()) or arg0_9:rarity2bgPrint()
end

function var0_0.getShipBgPrint(arg0_10, arg1_10)
	local var0_10 = arg0_10:getSkinId()
	local var1_10 = pg.ship_skin_template[var0_10]

	assert(var1_10, "ship_skin_template not exist: " .. var0_10)

	local var2_10

	if not arg1_10 and var1_10.bg_sp and var1_10.bg_sp ~= "" and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var1_10.painting, 0) == 0 then
		var2_10 = var1_10.bg_sp
	end

	return var2_10 and var2_10 or var1_10.bg and #var1_10.bg > 0 and var1_10.bg or arg0_10:rarity2bgPrintForGet()
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

	arg0_49.phantomDic = {}

	arg0_49:updateSkinId(var5_49, 0)

	for iter8_49, iter9_49 in ipairs(arg1_49.skin_shadow_list or {}) do
		arg0_49:updateSkinId(iter9_49.value, iter9_49.key)
	end

	arg0_49.phantomRandomFlag = {}

	for iter10_49, iter11_49 in ipairs(arg1_49.char_random_flag or {}) do
		arg0_49:updateRandomFlag(1, iter11_49)
	end

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

function var0_0.getSkinId(arg0_58, arg1_58)
	local var0_58 = arg0_58:getPhandomSkin(arg1_58 or 0)
	local var1_58 = ShipSkin.GetChangeSkinGroupId(var0_58)

	if var1_58 then
		local var2_58 = ShipSkin.GetStoreChangeSkinId(var1_58)

		if var2_58 then
			return var2_58
		end
	end

	return var0_58
end

function var0_0.getPhandomSkin(arg0_59, arg1_59)
	if not arg1_59 or arg1_59 == 0 then
		return arg0_59.skinId
	else
		return arg0_59.phantomDic[arg0_59.phantomId] or arg0_59:getConfig("skin_id")
	end
end

function var0_0.updateSkinId(arg0_60, arg1_60, arg2_60)
	if not arg1_60 or arg1_60 == 0 then
		arg1_60 = arg0_60:getConfig("skin_id")
	end

	if arg2_60 == 0 then
		arg0_60.skinId = arg1_60
	else
		arg0_60.phantomDic[arg2_60] = arg1_60
	end
end

function var0_0.getAllShipPhantomMarks(arg0_61)
	local var0_61 = getGameset("technology_shadow_num")[1]
	local var1_61 = {}

	for iter0_61 = 0, var0_61 do
		if iter0_61 == 0 or arg0_61.phantomDic[iter0_61] then
			table.insert(var1_61, ShipPhantom.PackMark(arg0_61.id, iter0_61))
		end
	end

	return var1_61
end

function var0_0.getAllShipPhantom(arg0_62)
	local var0_62 = getGameset("technology_shadow_num")[1]
	local var1_62 = {}

	for iter0_62 = 0, var0_62 do
		if iter0_62 == 0 or arg0_62.phantomDic[iter0_62] then
			table.insert(var1_62, ShipPhantom.Create(arg0_62, iter0_62))
		end
	end

	return var1_62
end

function var0_0.updateRandomFlag(arg0_63, arg1_63, arg2_63)
	arg2_63 = defaultValue(arg2_63, 0)
	arg0_63.phantomRandomFlag[arg2_63] = arg1_63
end

function var0_0.getRandomFlag(arg0_64, arg1_64)
	return defaultValue(arg0_64.phantomRandomFlag[arg1_64 or 0], 0) > 0
end

function var0_0.getRandomFlagShipPhantomMarks(arg0_65)
	local var0_65 = getGameset("technology_shadow_num")[1]
	local var1_65 = {}

	for iter0_65 = 0, var0_65 do
		if defaultValue(arg0_65.phantomRandomFlag[iter0_65], 0) > 0 then
			table.insert(var1_65, arg0_65:GetShipPhantomMark(iter0_65))
		end
	end

	return var1_65
end

function var0_0.updateName(arg0_66)
	if arg0_66.name ~= pg.ship_data_statistics[arg0_66.configId].name then
		return
	end

	if arg0_66:isRemoulded() then
		arg0_66.name = pg.ship_skin_template[arg0_66:getRemouldSkinId()].name
	else
		arg0_66.name = pg.ship_data_statistics[arg0_66.configId].name
	end
end

function var0_0.isRemoulded(arg0_67)
	if arg0_67.remoulded then
		return true
	end

	local var0_67 = pg.ship_data_trans[arg0_67.groupId]

	if var0_67 then
		for iter0_67, iter1_67 in ipairs(var0_67.transform_list) do
			for iter2_67, iter3_67 in ipairs(iter1_67) do
				local var1_67 = pg.transform_data_template[iter3_67[2]]

				if var1_67.skin_id ~= 0 and arg0_67.transforms[iter3_67[2]] and arg0_67.transforms[iter3_67[2]].level == var1_67.max_level then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.getRemouldSkinId(arg0_68)
	local var0_68 = ShipGroup.getModSkin(arg0_68.groupId)

	if var0_68 then
		return var0_68.id
	end

	return nil
end

function var0_0.hasEquipmentSkinInPos(arg0_69, arg1_69)
	local var0_69 = arg0_69.equipments[arg1_69]

	return var0_69 and var0_69:hasSkin()
end

function var0_0.getPrefab(arg0_70)
	local var0_70 = arg0_70:getSkinId()

	if arg0_70:hasEquipmentSkinInPos(var2_0) then
		local var1_70 = arg0_70:getEquip(var2_0)
		local var2_70 = var7_0[var1_70:getSkinId()].ship_skin_id

		var0_70 = var2_70 ~= 0 and var2_70 or var0_70
	end

	local var3_70 = pg.ship_skin_template[var0_70]

	assert(var3_70, "ship_skin_template not exist: " .. arg0_70.configId .. " " .. var0_70)

	return var3_70.prefab
end

function var0_0.getAttachmentPrefab(arg0_71)
	local var0_71 = {}

	for iter0_71, iter1_71 in ipairs(arg0_71.equipments) do
		if iter1_71 and iter1_71:hasSkinOrbit() then
			local var1_71 = iter1_71:getSkinId()
			local var2_71 = var7_0[var1_71]

			var0_71[var1_71] = {
				config = var2_71,
				index = iter0_71
			}
		end
	end

	return var0_71
end

function var0_0.getPainting(arg0_72)
	local var0_72 = arg0_72:getSkinId()
	local var1_72 = pg.ship_skin_template[var0_72]

	assert(var1_72, "ship_skin_template not exist: " .. arg0_72.configId .. " " .. var0_72)

	return var1_72.painting
end

function var0_0.GetSkinConfig(arg0_73, arg1_73)
	local var0_73 = arg0_73:getSkinId()
	local var1_73 = pg.ship_skin_template[var0_73]

	assert(var1_73, "ship_skin_template not exist: " .. arg0_73.configId .. " " .. var0_73)

	return var1_73
end

function var0_0.getRemouldPainting(arg0_74)
	local var0_74 = arg0_74:getRemouldSkinId()
	local var1_74 = pg.ship_skin_template[var0_74]

	assert(var1_74, "ship_skin_template not exist: " .. arg0_74.configId .. " " .. var0_74)

	return var1_74.painting
end

function var0_0.updateStateInfo34(arg0_75, arg1_75, arg2_75)
	arg0_75.state_info_3 = arg1_75
	arg0_75.state_info_4 = arg2_75
end

function var0_0.hasStateInfo3Or4(arg0_76)
	return arg0_76.state_info_3 ~= 0 or arg0_76.state_info_4 ~= 0
end

function var0_0.isTestShip(arg0_77)
	return arg0_77.testShip
end

function var0_0.canUseTestShip(arg0_78, arg1_78)
	assert(arg0_78.testShip, "ship is not TestShip")

	return table.contains(arg0_78.testShip, arg1_78)
end

function var0_0.updateEquip(arg0_79, arg1_79, arg2_79)
	assert(arg2_79 == nil or arg2_79.count == 1)

	local var0_79 = arg0_79.equipments[arg1_79]

	arg0_79.equipments[arg1_79] = arg2_79 and Clone(arg2_79) or false

	local function var1_79(arg0_80)
		arg0_80 = CreateShell(arg0_80)
		arg0_80.shipId = arg0_79.id
		arg0_80.shipPos = arg1_79

		return arg0_80
	end

	if var0_79 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0_79, arg0_79.id, arg1_79)
		var0_79:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1_79(var0_79))
	end

	if arg2_79 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2_79, arg0_79.id, arg1_79)
		arg0_79:reletiveEquipSkin(arg1_79)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1_79(arg2_79))
	end
end

function var0_0.reletiveEquipSkin(arg0_81, arg1_81)
	if arg0_81.equipments[arg1_81] and arg0_81.equipmentSkins[arg1_81] ~= 0 then
		local var0_81 = pg.equip_skin_template[arg0_81.equipmentSkins[arg1_81]].equip_type
		local var1_81 = arg0_81.equipments[arg1_81]:getType()

		if table.contains(var0_81, var1_81) then
			arg0_81.equipments[arg1_81]:setSkinId(arg0_81.equipmentSkins[arg1_81])
		else
			arg0_81.equipments[arg1_81]:setSkinId(0)
		end
	elseif arg0_81.equipments[arg1_81] then
		arg0_81.equipments[arg1_81]:setSkinId(0)
	end
end

function var0_0.updateEquipmentSkin(arg0_82, arg1_82, arg2_82)
	if not arg1_82 then
		return
	end

	if arg2_82 and arg2_82 > 0 then
		local var0_82 = arg0_82:getSkinTypes(arg1_82)
		local var1_82 = pg.equip_skin_template[arg2_82].equip_type
		local var2_82 = false

		for iter0_82, iter1_82 in ipairs(var0_82) do
			for iter2_82, iter3_82 in ipairs(var1_82) do
				if iter1_82 == iter3_82 then
					var2_82 = true

					break
				end
			end
		end

		if not var2_82 then
			assert(var2_82, "部位" .. arg1_82 .. " 无法穿戴皮肤 " .. arg2_82)

			return
		end

		local var3_82 = arg0_82.equipments[arg1_82] and arg0_82.equipments[arg1_82]:getType() or false

		arg0_82.equipmentSkins[arg1_82] = arg2_82

		if var3_82 and table.contains(var1_82, var3_82) then
			arg0_82.equipments[arg1_82]:setSkinId(arg0_82.equipmentSkins[arg1_82])
		elseif var3_82 and not table.contains(var1_82, var3_82) then
			arg0_82.equipments[arg1_82]:setSkinId(0)
		end
	else
		arg0_82.equipmentSkins[arg1_82] = 0

		if arg0_82.equipments[arg1_82] then
			arg0_82.equipments[arg1_82]:setSkinId(0)
		end
	end
end

function var0_0.getEquip(arg0_83, arg1_83)
	return Clone(arg0_83.equipments[arg1_83])
end

function var0_0.getEquipSkins(arg0_84)
	return Clone(arg0_84.equipmentSkins)
end

function var0_0.getEquipSkin(arg0_85, arg1_85)
	return arg0_85.equipmentSkins[arg1_85]
end

function var0_0.getCanEquipSkin(arg0_86, arg1_86)
	local var0_86 = arg0_86:getSkinTypes(arg1_86)

	if var0_86 and #var0_86 then
		for iter0_86, iter1_86 in ipairs(var0_86) do
			if pg.equip_data_by_type[iter1_86].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0_0.checkCanEquipSkin(arg0_87, arg1_87, arg2_87)
	if not arg1_87 or not arg2_87 then
		return
	end

	local var0_87 = arg0_87:getSkinTypes(arg1_87)
	local var1_87 = pg.equip_skin_template[arg2_87].equip_type

	for iter0_87, iter1_87 in ipairs(var0_87) do
		if table.contains(var1_87, iter1_87) then
			return true
		end
	end

	return false
end

function var0_0.getSkinTypes(arg0_88, arg1_88)
	return pg.ship_data_template[arg0_88.configId]["equip_" .. arg1_88] or {}
end

function var0_0.updateState(arg0_89, arg1_89)
	arg0_89.state = arg1_89
end

function var0_0.addSkillExp(arg0_90, arg1_90, arg2_90)
	local var0_90 = arg0_90.skills[arg1_90] or {
		exp = 0,
		level = 1,
		id = arg1_90
	}
	local var1_90 = var0_90.level and var0_90.level or 1
	local var2_90 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1_90 == var2_90 then
		return
	end

	local var3_90 = var0_90.exp and arg2_90 + var0_90.exp or 0 + arg2_90

	while var3_90 >= pg.skill_need_exp[var1_90].exp do
		var3_90 = var3_90 - pg.skill_need_exp[var1_90].exp
		var1_90 = var1_90 + 1

		if var1_90 == var2_90 then
			var3_90 = 0

			break
		end
	end

	arg0_90:updateSkill({
		id = var0_90.id,
		level = var1_90,
		exp = var3_90
	})
end

function var0_0.upSkillLevelForMeta(arg0_91, arg1_91)
	local var0_91 = arg0_91.skills[arg1_91] or {
		exp = 0,
		level = 0,
		id = arg1_91
	}
	local var1_91 = arg0_91:isSkillLevelMax(arg1_91)
	local var2_91 = var0_91.level

	if not var1_91 then
		var2_91 = var2_91 + 1
	end

	arg0_91:updateSkill({
		exp = 0,
		id = var0_91.id,
		level = var2_91
	})
end

function var0_0.getMetaSkillLevelBySkillID(arg0_92, arg1_92)
	return (arg0_92.skills[arg1_92] or {
		exp = 0,
		level = 0,
		id = arg1_92
	}).level
end

function var0_0.isSkillLevelMax(arg0_93, arg1_93)
	local var0_93 = arg0_93.skills[arg1_93] or {
		exp = 0,
		level = 1,
		id = arg1_93
	}

	return (var0_93.level and var0_93.level or 1) >= pg.skill_data_template[arg1_93].max_level
end

function var0_0.isAllMetaSkillLevelMax(arg0_94)
	local var0_94 = true
	local var1_94 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_94.configId)

	for iter0_94, iter1_94 in ipairs(var1_94) do
		if not arg0_94:isSkillLevelMax(iter1_94) then
			var0_94 = false

			break
		end
	end

	return var0_94
end

function var0_0.isAllMetaSkillLock(arg0_95)
	local var0_95 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_95.configId)
	local var1_95 = true

	for iter0_95, iter1_95 in ipairs(var0_95) do
		if arg0_95:getMetaSkillLevelBySkillID(iter1_95) > 0 then
			var1_95 = false

			break
		end
	end

	return var1_95
end

function var0_0.bindConfigTable(arg0_96)
	return pg.ship_data_statistics
end

function var0_0.isAvaiable(arg0_97)
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

function var0_0.intimacyAdditions(arg0_98, arg1_98)
	local var0_98 = pg.intimacy_template[arg0_98:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0_98, iter1_98 in pairs(arg1_98) do
		if iter0_98 == AttributeType.Durability or iter0_98 == AttributeType.Cannon or iter0_98 == AttributeType.Torpedo or iter0_98 == AttributeType.AntiAircraft or iter0_98 == AttributeType.AntiSub or iter0_98 == AttributeType.Air or iter0_98 == AttributeType.Reload or iter0_98 == AttributeType.Hit or iter0_98 == AttributeType.Dodge then
			arg1_98[iter0_98] = arg1_98[iter0_98] * (var0_98 + 1)
		end
	end
end

function var0_0.getShipProperties(arg0_99)
	local var0_99 = arg0_99:getBaseProperties()

	if arg0_99:isBluePrintShip() then
		local var1_99 = arg0_99:getBluePrint()

		assert(var1_99, "blueprint can not be nil" .. arg0_99.configId)

		local var2_99 = var1_99:getTotalAdditions()

		for iter0_99, iter1_99 in pairs(var2_99) do
			var0_99[iter0_99] = var0_99[iter0_99] + calcFloor(iter1_99)
		end

		arg0_99:intimacyAdditions(var0_99)
	elseif arg0_99:isMetaShip() then
		assert(arg0_99.metaCharacter)

		for iter2_99, iter3_99 in pairs(var0_99) do
			var0_99[iter2_99] = var0_99[iter2_99] + arg0_99.metaCharacter:getAttrAddition(iter2_99)
		end

		arg0_99:intimacyAdditions(var0_99)
	else
		local var3_99 = pg.ship_data_template[arg0_99.configId].strengthen_id
		local var4_99 = var5_0[var3_99]

		for iter4_99, iter5_99 in pairs(arg0_99.strengthList) do
			local var5_99 = ShipModAttr.ATTR_TO_INDEX[iter4_99]
			local var6_99 = math.min(iter5_99, var4_99.durability[var5_99] * var4_99.level_exp[var5_99])
			local var7_99 = math.max(arg0_99:getModExpRatio(iter4_99), 1)

			var0_99[iter4_99] = var0_99[iter4_99] + calcFloor(var6_99 / var7_99)
		end

		arg0_99:intimacyAdditions(var0_99)

		for iter6_99, iter7_99 in pairs(arg0_99.transforms) do
			local var8_99 = pg.transform_data_template[iter7_99.id].effect

			for iter8_99 = 1, iter7_99.level do
				local var9_99 = var8_99[iter8_99] or {}

				for iter9_99, iter10_99 in pairs(var0_99) do
					if var9_99[iter9_99] then
						var0_99[iter9_99] = var0_99[iter9_99] + var9_99[iter9_99]
					end
				end
			end
		end
	end

	return var0_99
end

function var0_0.getTechNationAddition(arg0_100, arg1_100)
	local var0_100 = getProxy(TechnologyNationProxy)
	local var1_100 = arg0_100:getConfig("type")

	if var1_100 == ShipType.DaoQuV or var1_100 == ShipType.DaoQuM then
		var1_100 = ShipType.QuZhu
	end

	return var0_100:getShipAddition(var1_100, arg1_100)
end

function var0_0.getTechNationMaxAddition(arg0_101, arg1_101)
	local var0_101 = getProxy(TechnologyNationProxy)
	local var1_101 = arg0_101:getConfig("type")

	return var0_101:getShipMaxAddition(var1_101, arg1_101)
end

function var0_0.getEquipProficiencyByPos(arg0_102, arg1_102)
	return arg0_102:getEquipProficiencyList()[arg1_102]
end

function var0_0.getEquipProficiencyList(arg0_103)
	local var0_103 = arg0_103:getConfigTable()
	local var1_103 = Clone(var0_103.equipment_proficiency)

	if arg0_103:isBluePrintShip() then
		local var2_103 = arg0_103:getBluePrint()

		assert(var2_103, "blueprint can not be nil >>>" .. arg0_103.groupId)

		var1_103 = var2_103:getEquipProficiencyList(arg0_103)
	else
		for iter0_103, iter1_103 in ipairs(var1_103) do
			local var3_103 = 0

			for iter2_103, iter3_103 in pairs(arg0_103.transforms) do
				local var4_103 = pg.transform_data_template[iter3_103.id].effect

				for iter4_103 = 1, iter3_103.level do
					local var5_103 = var4_103[iter4_103] or {}

					if var5_103["equipment_proficiency_" .. iter0_103] then
						var3_103 = var3_103 + var5_103["equipment_proficiency_" .. iter0_103]
					end
				end
			end

			var1_103[iter0_103] = iter1_103 + var3_103
		end
	end

	return var1_103
end

function var0_0.getBaseProperties(arg0_104)
	local var0_104 = arg0_104:getConfigTable()

	assert(var0_104, "配置表没有这艘船" .. arg0_104.configId)

	local var1_104 = {}
	local var2_104 = {}

	for iter0_104, iter1_104 in ipairs(var0_0.PROPERTIES) do
		var1_104[iter1_104] = arg0_104:getGrowthForAttr(iter1_104)
		var2_104[iter1_104] = var1_104[iter1_104]
	end

	for iter2_104, iter3_104 in ipairs(arg0_104:getConfig("lock")) do
		var2_104[iter3_104] = var1_104[iter3_104]
	end

	for iter4_104, iter5_104 in ipairs(var0_0.DIVE_PROPERTIES) do
		var2_104[iter5_104] = var0_104[iter5_104]
	end

	for iter6_104, iter7_104 in ipairs(var0_0.SONAR_PROPERTIES) do
		var2_104[iter7_104] = 0
	end

	return var2_104
end

function var0_0.getGrowthForAttr(arg0_105, arg1_105)
	local var0_105 = arg0_105:getConfigTable()
	local var1_105 = table.indexof(var0_0.PROPERTIES, arg1_105)
	local var2_105 = pg.gameset.extra_attr_level_limit.key_value
	local var3_105 = var0_105.attrs[var1_105] + (arg0_105.level - 1) * var0_105.attrs_growth[var1_105] / 1000

	if var2_105 < arg0_105.level then
		var3_105 = var3_105 + (arg0_105.level - var2_105) * var0_105.attrs_growth_extra[var1_105] / 1000
	end

	return var3_105
end

function var0_0.isMaxStar(arg0_106)
	return arg0_106:getStar() >= arg0_106:getMaxStar()
end

function var0_0.IsMaxStarByTmpID(arg0_107)
	local var0_107 = pg.ship_data_template[arg0_107]

	return var0_107.star >= var0_107.star_max
end

function var0_0.IsSpweaponUnlock(arg0_108)
	if not arg0_108:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0_0.getModProperties(arg0_109, arg1_109)
	return arg0_109.strengthList[arg1_109] or 0
end

function var0_0.addModAttrExp(arg0_110, arg1_110, arg2_110)
	local var0_110 = arg0_110:getModAttrTopLimit(arg1_110)

	if var0_110 == 0 then
		return
	end

	local var1_110 = arg0_110:getModExpRatio(arg1_110)
	local var2_110 = arg0_110:getModProperties(arg1_110)

	if var2_110 + arg2_110 > var0_110 * var1_110 then
		arg0_110.strengthList[arg1_110] = var0_110 * var1_110
	else
		arg0_110.strengthList[arg1_110] = var2_110 + arg2_110
	end
end

function var0_0.getNeedModExp(arg0_111)
	local var0_111 = {}

	for iter0_111, iter1_111 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1_111 = arg0_111:getModAttrTopLimit(iter1_111)

		if var1_111 == 0 then
			var0_111[iter1_111] = 0
		else
			var0_111[iter1_111] = var1_111 * arg0_111:getModExpRatio(iter1_111) - arg0_111:getModProperties(iter1_111)
		end
	end

	return var0_111
end

function var0_0.attrVertify(arg0_112)
	if not BayProxy.checkShiplevelVertify(arg0_112) then
		return false
	end

	for iter0_112, iter1_112 in ipairs(arg0_112.equipments) do
		if iter1_112 and not iter1_112:vertify() then
			return false
		end
	end

	return true
end

function var0_0.getEquipmentProperties(arg0_113)
	local var0_113 = {}
	local var1_113 = {}

	for iter0_113, iter1_113 in ipairs(var0_0.PROPERTIES) do
		var0_113[iter1_113] = 0
	end

	for iter2_113, iter3_113 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_113[iter3_113] = 0
	end

	for iter4_113, iter5_113 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_113[iter5_113] = 0
	end

	for iter6_113, iter7_113 in ipairs(var0_0.PROPERTIES_ENHANCEMENT) do
		var1_113[iter7_113] = 0
	end

	var0_113[AttributeType.AirDominate] = 0
	var0_113[AttributeType.AntiSiren] = 0

	local var2_113 = arg0_113:getActiveEquipments()

	for iter8_113, iter9_113 in ipairs(var2_113) do
		if iter9_113 then
			local var3_113 = iter9_113:GetAttributes()

			for iter10_113, iter11_113 in ipairs(var3_113) do
				if iter11_113 and var0_113[iter11_113.type] then
					var0_113[iter11_113.type] = var0_113[iter11_113.type] + iter11_113.value
				end
			end

			local var4_113 = iter9_113:GetPropertyRate()

			for iter12_113, iter13_113 in pairs(var4_113) do
				var1_113[iter12_113] = math.max(var1_113[iter12_113], iter13_113)
			end

			local var5_113 = iter9_113:GetSonarProperty()

			if var5_113 then
				for iter14_113, iter15_113 in pairs(var5_113) do
					var0_113[iter14_113] = var0_113[iter14_113] + iter15_113
				end
			end

			local var6_113 = iter9_113:GetAntiSirenPower()

			if var6_113 then
				var0_113[AttributeType.AntiSiren] = var0_113[AttributeType.AntiSiren] + var6_113 / 10000
			end
		end
	end

	;(function()
		local var0_114 = arg0_113:GetSpWeapon()

		if not var0_114 then
			return
		end

		local var1_114 = var0_114:GetPropertiesInfo().attrs

		for iter0_114, iter1_114 in ipairs(var1_114) do
			if iter1_114 and var0_113[iter1_114.type] then
				var0_113[iter1_114.type] = var0_113[iter1_114.type] + iter1_114.value
			end
		end
	end)()

	for iter16_113, iter17_113 in pairs(var1_113) do
		var1_113[iter16_113] = iter17_113 + 1
	end

	return var0_113, var1_113
end

function var0_0.getSkillEffects(arg0_115)
	local var0_115 = arg0_115:getShipSkillEffects()

	_.each(arg0_115:getEquipmentSkillEffects(), function(arg0_116)
		table.insert(var0_115, arg0_116)
	end)

	return var0_115
end

function var0_0.getShipSkillEffects(arg0_117)
	local var0_117 = {}
	local var1_117 = arg0_117:getSkillList()

	for iter0_117, iter1_117 in ipairs(var1_117) do
		local var2_117 = arg0_117:RemapSkillId(iter1_117)
		local var3_117 = pg.buffCfg["buff_" .. var2_117]

		arg0_117:FilterActiveSkill(var0_117, var3_117, arg0_117.skills[iter1_117])
	end

	return var0_117
end

function var0_0.getEquipmentSkillEffects(arg0_118)
	local var0_118 = {}
	local var1_118 = arg0_118:getActiveEquipments()

	for iter0_118, iter1_118 in ipairs(var1_118) do
		local var2_118
		local var3_118 = iter1_118 and iter1_118:getConfig("skill_id")[1] and iter1_118:getConfig("skill_id")[1][1]

		if var3_118 then
			var2_118 = pg.buffCfg["buff_" .. var3_118]
		end

		arg0_118:FilterActiveSkill(var0_118, var2_118)
	end

	;(function()
		local var0_119 = arg0_118:GetSpWeapon()
		local var1_119 = var0_119 and var0_119:GetEffect() or 0
		local var2_119

		if var1_119 > 0 then
			var2_119 = pg.buffCfg["buff_" .. var1_119]
		end

		arg0_118:FilterActiveSkill(var0_118, var2_119)
	end)()

	return var0_118
end

function var0_0.FilterActiveSkill(arg0_120, arg1_120, arg2_120, arg3_120)
	if not arg2_120 or not arg2_120.const_effect_list then
		return
	end

	for iter0_120 = 1, #arg2_120.const_effect_list do
		local var0_120 = arg2_120.const_effect_list[iter0_120]
		local var1_120 = var0_120.trigger
		local var2_120 = var0_120.arg_list
		local var3_120 = 1

		if arg3_120 then
			var3_120 = arg3_120.level

			local var4_120 = arg2_120[var3_120].const_effect_list

			if var4_120 and var4_120[iter0_120] then
				var1_120 = var4_120[iter0_120].trigger or var1_120
				var2_120 = var4_120[iter0_120].arg_list or var2_120
			end
		end

		local var5_120 = true

		for iter1_120, iter2_120 in pairs(var1_120) do
			if arg0_120.triggers[iter1_120] ~= iter2_120 then
				var5_120 = false

				break
			end
		end

		if var5_120 then
			table.insert(arg1_120, {
				type = var0_120.type,
				arg_list = var2_120,
				level = var3_120
			})
		end
	end
end

function var0_0.getEquipmentGearScore(arg0_121)
	local var0_121 = 0
	local var1_121 = arg0_121:getActiveEquipments()

	for iter0_121, iter1_121 in ipairs(var1_121) do
		if iter1_121 then
			var0_121 = var0_121 + iter1_121:GetGearScore()
		end
	end

	return var0_121
end

function var0_0.getProperties(arg0_122, arg1_122, arg2_122, arg3_122, arg4_122)
	local var0_122 = arg1_122 or {}
	local var1_122 = arg0_122:getConfig("nationality")
	local var2_122 = arg0_122:getConfig("type")
	local var3_122 = arg0_122:getShipProperties()
	local var4_122, var5_122 = arg0_122:getEquipmentProperties()
	local var6_122
	local var7_122
	local var8_122

	if arg3_122 and arg0_122:getFlag("inWorld") then
		local var9_122 = WorldConst.FetchWorldShip(arg0_122.id)

		var6_122, var7_122 = var9_122:GetShipBuffProperties()
		var8_122 = var9_122:GetShipPowerBuffProperties()
	end

	for iter0_122, iter1_122 in ipairs(var0_0.PROPERTIES) do
		local var10_122 = 0
		local var11_122 = 0

		for iter2_122, iter3_122 in pairs(var0_122) do
			var10_122 = var10_122 + iter3_122:getAttrRatioAddition(iter1_122, var1_122, var2_122) / 100
			var11_122 = var11_122 + iter3_122:getAttrValueAddition(iter1_122, var1_122, var2_122)
		end

		local var12_122 = var10_122 + (var5_122[iter1_122] or 1)
		local var13_122 = var7_122 and var7_122[iter1_122] or 1
		local var14_122 = var6_122 and var6_122[iter1_122] or 0

		if iter1_122 == AttributeType.Speed then
			var3_122[iter1_122] = var3_122[iter1_122] * var12_122 * var13_122 + var11_122 + var4_122[iter1_122] + var14_122
		else
			var3_122[iter1_122] = calcFloor(calcFloor(var3_122[iter1_122]) * var12_122 * var13_122) + var11_122 + var4_122[iter1_122] + var14_122
		end
	end

	if not arg2_122 and arg0_122:isMaxStar() then
		for iter4_122, iter5_122 in pairs(var3_122) do
			local var15_122 = arg4_122 and arg0_122:getTechNationMaxAddition(iter4_122) or arg0_122:getTechNationAddition(iter4_122)

			var3_122[iter4_122] = var3_122[iter4_122] + var15_122
		end
	end

	for iter6_122, iter7_122 in ipairs(var0_0.DIVE_PROPERTIES) do
		var3_122[iter7_122] = var3_122[iter7_122] + var4_122[iter7_122]
	end

	for iter8_122, iter9_122 in ipairs(var0_0.SONAR_PROPERTIES) do
		var3_122[iter9_122] = var3_122[iter9_122] + var4_122[iter9_122]
	end

	if arg3_122 then
		var3_122[AttributeType.AntiSiren] = (var3_122[AttributeType.AntiSiren] or 0) + var4_122[AttributeType.AntiSiren]
	end

	if var8_122 then
		for iter10_122, iter11_122 in pairs(var8_122) do
			if var3_122[iter10_122] then
				if iter10_122 == AttributeType.Speed then
					var3_122[iter10_122] = var3_122[iter10_122] * iter11_122
				else
					var3_122[iter10_122] = math.floor(var3_122[iter10_122] * iter11_122)
				end
			end
		end
	end

	return var3_122
end

function var0_0.getTransGearScore(arg0_123)
	local var0_123 = 0
	local var1_123 = pg.transform_data_template

	for iter0_123, iter1_123 in pairs(arg0_123.transforms) do
		for iter2_123 = 1, iter1_123.level do
			var0_123 = var0_123 + (var1_123[iter1_123.id].gear_score[iter2_123] or 0)
		end
	end

	return var0_123
end

function var0_0.getShipCombatPower(arg0_124, arg1_124)
	local var0_124 = arg0_124:getProperties(arg1_124, nil, nil, true)
	local var1_124 = var0_124[AttributeType.Durability] / 5 + var0_124[AttributeType.Cannon] + var0_124[AttributeType.Torpedo] + var0_124[AttributeType.AntiAircraft] + var0_124[AttributeType.Air] + var0_124[AttributeType.AntiSub] + var0_124[AttributeType.Reload] + var0_124[AttributeType.Hit] * 2 + var0_124[AttributeType.Dodge] * 2 + var0_124[AttributeType.Speed] + arg0_124:getEquipmentGearScore() + arg0_124:getTransGearScore()

	return math.floor(var1_124)
end

function var0_0.cosumeEnergy(arg0_125, arg1_125)
	arg0_125:setEnergy(math.max(arg0_125:getEnergy() - arg1_125, 0))
end

function var0_0.addEnergy(arg0_126, arg1_126)
	arg0_126:setEnergy(arg0_126:getEnergy() + arg1_126)
end

function var0_0.setEnergy(arg0_127, arg1_127)
	arg0_127.energy = arg1_127
end

function var0_0.setLikability(arg0_128, arg1_128)
	assert(arg1_128 >= 0 and arg1_128 <= arg0_128.maxIntimacy, "intimacy value invaild" .. arg1_128)
	arg0_128:setIntimacy(arg1_128)
end

function var0_0.addLikability(arg0_129, arg1_129)
	local var0_129 = Mathf.Clamp(arg0_129:getIntimacy() + arg1_129, 0, arg0_129.maxIntimacy)

	arg0_129:setIntimacy(var0_129)
end

function var0_0.setIntimacy(arg0_130, arg1_130)
	if arg1_130 > 10000 and not arg0_130.propose then
		arg1_130 = 10000
	end

	arg0_130.intimacy = arg1_130

	if not arg0_130:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0_130.groupId]:updateMaxIntimacy(arg0_130:getIntimacy())
	end
end

function var0_0.getLevelExpConfig(arg0_131, arg1_131)
	if arg0_131:getConfig("rarity") == ShipRarity.SSR then
		local var0_131 = Clone(getConfigFromLevel1(var6_0, arg1_131 or arg0_131.level))

		var0_131.exp = var0_131.exp_ur
		var0_131.exp_start = var0_131.exp_ur_start
		var0_131.exp_interval = var0_131.exp_ur_interval
		var0_131.exp_end = var0_131.exp_ur_end

		return var0_131
	else
		return getConfigFromLevel1(var6_0, arg1_131 or arg0_131.level)
	end
end

function var0_0.getExp(arg0_132)
	local var0_132 = arg0_132:getMaxLevel()

	if arg0_132.level == var0_132 and LOCK_FULL_EXP then
		return 0
	end

	return arg0_132.exp
end

function var0_0.getProficiency(arg0_133)
	return arg0_133.proficiency
end

function var0_0.addExp(arg0_134, arg1_134, arg2_134)
	local var0_134 = arg0_134:getMaxLevel()

	if arg0_134.level == var0_134 then
		if arg0_134.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2_134 or not arg0_134:CanAccumulateExp() then
			arg1_134 = 0
		end
	end

	arg0_134.exp = arg0_134.exp + arg1_134

	local var1_134 = false

	while arg0_134:canLevelUp() do
		arg0_134.exp = arg0_134.exp - arg0_134:getLevelExpConfig().exp_interval
		arg0_134.level = math.min(arg0_134.level + 1, var0_134)
		var1_134 = true
	end

	if arg0_134.level == var0_134 then
		if arg2_134 and arg0_134:CanAccumulateExp() then
			arg0_134.exp = math.min(arg0_134.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1_134 then
			arg0_134.exp = 0
		end
	end
end

function var0_0.getMaxLevel(arg0_135)
	return arg0_135.maxLevel
end

function var0_0.canLevelUp(arg0_136)
	local var0_136 = arg0_136:getLevelExpConfig(arg0_136.level + 1)
	local var1_136 = arg0_136:getMaxLevel() <= arg0_136.level

	return var0_136 and arg0_136:getLevelExpConfig().exp_interval <= arg0_136.exp and not var1_136
end

function var0_0.getConfigMaxLevel(arg0_137)
	return var6_0.all[#var6_0.all]
end

function var0_0.isConfigMaxLevel(arg0_138)
	return arg0_138.level == arg0_138:getConfigMaxLevel()
end

function var0_0.updateMaxLevel(arg0_139, arg1_139)
	local var0_139 = arg0_139:getConfigMaxLevel()

	arg0_139.maxLevel = math.max(math.min(var0_139, arg1_139), arg0_139.maxLevel)
end

function var0_0.getNextMaxLevel(arg0_140)
	local var0_140 = arg0_140:getConfigMaxLevel()

	for iter0_140 = arg0_140:getMaxLevel() + 1, var0_140 do
		if var6_0[iter0_140].level_limit == 1 then
			return iter0_140
		end
	end
end

function var0_0.canUpgrade(arg0_141)
	if arg0_141:isBluePrintShip() then
		return false
	end

	if arg0_141:isMetaShip() then
		local var0_141 = arg0_141:getMetaCharacter()

		if not var0_141 then
			return false
		end

		local var1_141 = var0_141:getBreakOutInfo()

		if not var1_141:hasNextInfo() then
			return false
		end

		local var2_141, var3_141 = var1_141:getLimited()

		if var2_141 > arg0_141.level then
			return false
		end

		return true
	else
		local var4_141 = var8_0[arg0_141.configId]

		assert(var4_141, "不存在配置" .. arg0_141.configId)

		return not arg0_141:isMaxStar() and arg0_141.level >= var4_141.level
	end
end

function var0_0.isReachNextMaxLevel(arg0_142)
	return arg0_142.level == arg0_142:getMaxLevel() and arg0_142:CanAccumulateExp() and arg0_142:getNextMaxLevel() ~= nil
end

function var0_0.isAwakening(arg0_143)
	return arg0_143:isReachNextMaxLevel() and arg0_143.level < var4_0
end

function var0_0.isAwakening2(arg0_144)
	return arg0_144:isReachNextMaxLevel() and arg0_144.level >= var4_0
end

function var0_0.notMaxLevelForFilter(arg0_145)
	return arg0_145.level ~= arg0_145:getMaxLevel()
end

function var0_0.getNextMaxLevelConsume(arg0_146)
	local var0_146 = arg0_146:getMaxLevel()
	local var1_146 = var6_0[var0_146]["need_item_rarity" .. arg0_146:getConfig("rarity")]

	assert(var1_146, "items  can not be nil")

	return _.map(var1_146, function(arg0_147)
		return {
			type = arg0_147[1],
			id = arg0_147[2],
			count = arg0_147[3]
		}
	end)
end

function var0_0.canUpgradeMaxLevel(arg0_148)
	if not arg0_148:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0_148 = getProxy(PlayerProxy):getData()
		local var1_148 = getProxy(BagProxy)
		local var2_148 = arg0_148:getNextMaxLevelConsume()

		for iter0_148, iter1_148 in pairs(var2_148) do
			if iter1_148.type == DROP_TYPE_RESOURCE then
				if var0_148:getResById(iter1_148.id) < iter1_148.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1_148.type == DROP_TYPE_ITEM and var1_148:getItemCountById(iter1_148.id) < iter1_148.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.CanAccumulateExp(arg0_149)
	return pg.ship_data_template[arg0_149.configId].can_get_proficency == 1
end

function var0_0.getTotalExp(arg0_150)
	return arg0_150:getLevelExpConfig().exp_start + arg0_150.exp
end

function var0_0.getStartBattleExpend(arg0_151)
	if table.contains(TeamType.SubShipType, arg0_151:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0_151.configId].oil_at_start
	end
end

function var0_0.getEndBattleExpend(arg0_152)
	local var0_152 = pg.ship_data_template[arg0_152.configId]
	local var1_152 = arg0_152:getLevelExpConfig()

	return (math.floor(var0_152.oil_at_end * var1_152.fight_oil_ratio / 10000))
end

function var0_0.getBattleTotalExpend(arg0_153)
	return arg0_153:getStartBattleExpend() + arg0_153:getEndBattleExpend()
end

function var0_0.getShipAmmo(arg0_154)
	local var0_154 = arg0_154:getConfig(AttributeType.Ammo)

	for iter0_154, iter1_154 in pairs(arg0_154:getAllSkills()) do
		local var1_154 = tonumber(iter0_154 .. string.format("%.2d", iter1_154.level))
		local var2_154 = pg.skill_benefit_template[var1_154]

		if var2_154 and arg0_154:IsBenefitSkillActive(var2_154) and (var2_154.type == var0_0.BENEFIT_EQUIP or var2_154.type == var0_0.BENEFIT_SKILL) then
			var0_154 = var0_154 + defaultValue(var2_154.effect[1], 0)
		end
	end

	local var3_154 = arg0_154:getActiveEquipments()

	for iter2_154, iter3_154 in ipairs(var3_154) do
		local var4_154 = iter3_154 and iter3_154:getConfig("equip_parameters").ammo

		if var4_154 then
			var0_154 = var0_154 + var4_154
		end
	end

	return var0_154
end

function var0_0.getHuntingLv(arg0_155)
	local var0_155 = arg0_155:getConfig("huntingrange_level")

	for iter0_155, iter1_155 in pairs(arg0_155:getAllSkills()) do
		local var1_155 = tonumber(iter0_155 .. string.format("%.2d", iter1_155.level))
		local var2_155 = pg.skill_benefit_template[var1_155]

		if var2_155 and arg0_155:IsBenefitSkillActive(var2_155) and (var2_155.type == var0_0.BENEFIT_EQUIP or var2_155.type == var0_0.BENEFIT_SKILL) then
			var0_155 = var0_155 + defaultValue(var2_155.effect[2], 0)
		end
	end

	local var3_155 = arg0_155:getActiveEquipments()

	for iter2_155, iter3_155 in ipairs(var3_155) do
		local var4_155 = iter3_155 and iter3_155:getConfig("equip_parameters").hunting_lv

		if var4_155 then
			var0_155 = var0_155 + var4_155
		end
	end

	return (math.min(var0_155, arg0_155:getMaxHuntingLv()))
end

function var0_0.getMapAuras(arg0_156)
	local var0_156 = {}

	for iter0_156, iter1_156 in pairs(arg0_156:getAllSkills()) do
		local var1_156 = tonumber(iter0_156 .. string.format("%.2d", iter1_156.level))
		local var2_156 = pg.skill_benefit_template[var1_156]

		if var2_156 and arg0_156:IsBenefitSkillActive(var2_156) and var2_156.type == var0_0.BENEFIT_MAP_AURA then
			local var3_156 = {
				id = var2_156.effect[1],
				level = iter1_156.level
			}

			table.insert(var0_156, var3_156)
		end
	end

	return var0_156
end

function var0_0.getMapAids(arg0_157)
	local var0_157 = {}

	for iter0_157, iter1_157 in pairs(arg0_157:getAllSkills()) do
		local var1_157 = tonumber(iter0_157 .. string.format("%.2d", iter1_157.level))
		local var2_157 = pg.skill_benefit_template[var1_157]

		if var2_157 and arg0_157:IsBenefitSkillActive(var2_157) and var2_157.type == var0_0.BENEFIT_AID then
			local var3_157 = {
				id = var2_157.effect[1],
				level = iter1_157.level
			}

			table.insert(var0_157, var3_157)
		end
	end

	return var0_157
end

var0_0.BENEFIT_SKILL = 2
var0_0.BENEFIT_EQUIP = 3
var0_0.BENEFIT_MAP_AURA = 4
var0_0.BENEFIT_AID = 5

function var0_0.IsBenefitSkillActive(arg0_158, arg1_158)
	local var0_158 = false

	if arg1_158.type == var0_0.BENEFIT_SKILL then
		if not arg1_158.limit[1] or arg1_158.limit[1] == arg0_158.triggers.TeamNumbers then
			var0_158 = true
		end
	elseif arg1_158.type == var0_0.BENEFIT_EQUIP then
		local var1_158 = arg1_158.limit
		local var2_158 = arg0_158:getAllEquipments()

		for iter0_158, iter1_158 in ipairs(var2_158) do
			if iter1_158 and table.contains(var1_158, iter1_158:getConfig("id")) then
				var0_158 = true

				break
			end
		end
	elseif arg1_158.type == var0_0.BENEFIT_MAP_AURA then
		if arg0_158.hpRant and arg0_158.hpRant > 0 then
			return true
		end
	elseif arg1_158.type == var0_0.BENEFIT_AID and arg0_158.hpRant and arg0_158.hpRant > 0 then
		return true
	end

	return var0_158
end

function var0_0.getMaxHuntingLv(arg0_159)
	return #arg0_159:getConfig("hunting_range")
end

function var0_0.getHuntingRange(arg0_160, arg1_160)
	local var0_160 = arg0_160:getConfig("hunting_range")
	local var1_160 = Clone(var0_160[1])
	local var2_160 = arg1_160 or arg0_160:getHuntingLv()
	local var3_160 = math.min(var2_160, arg0_160:getMaxHuntingLv())

	for iter0_160 = 2, var3_160 do
		_.each(var0_160[iter0_160], function(arg0_161)
			table.insert(var1_160, {
				arg0_161[1],
				arg0_161[2]
			})
		end)
	end

	return var1_160
end

function var0_0.getTriggerSkills(arg0_162)
	local var0_162 = {}
	local var1_162 = arg0_162:getSkillEffects()

	_.each(var1_162, function(arg0_163)
		if arg0_163.type == "AddBuff" and arg0_163.arg_list and arg0_163.arg_list.buff_id then
			local var0_163 = arg0_163.arg_list.buff_id

			var0_162[var0_163] = {
				id = var0_163,
				level = arg0_163.level
			}
		end
	end)

	return var0_162
end

function var0_0.GetEquipmentSkills(arg0_164)
	local var0_164 = {}
	local var1_164 = arg0_164:getActiveEquipments()

	for iter0_164, iter1_164 in ipairs(var1_164) do
		if iter1_164 and iter1_164:getConfig("skill_id")[1] then
			local var2_164, var3_164 = unpack(iter1_164:getConfig("skill_id")[1])

			var0_164[var2_164] = {
				id = var2_164,
				level = var3_164
			}
		end
	end

	;(function()
		local var0_165 = arg0_164:GetSpWeapon()
		local var1_165 = var0_165 and var0_165:GetEffect() or 0

		if var1_165 > 0 then
			var0_164[var1_165] = {
				level = 1,
				id = var1_165
			}
		end
	end)()

	return var0_164
end

function var0_0.getAllSkills(arg0_166)
	local var0_166 = Clone(arg0_166.skills)

	for iter0_166, iter1_166 in pairs(arg0_166:GetEquipmentSkills()) do
		var0_166[iter0_166] = iter1_166
	end

	for iter2_166, iter3_166 in pairs(arg0_166:getTriggerSkills()) do
		var0_166[iter2_166] = iter3_166
	end

	return var0_166
end

function var0_0.isSameKind(arg0_167, arg1_167)
	return pg.ship_data_template[arg0_167.configId].group_type == pg.ship_data_template[arg1_167.configId].group_type
end

function var0_0.GetLockState(arg0_168)
	return arg0_168.lockState
end

function var0_0.IsLocked(arg0_169)
	return arg0_169.lockState == var0_0.LOCK_STATE_LOCK
end

function var0_0.SetLockState(arg0_170, arg1_170)
	arg0_170.lockState = arg1_170
end

function var0_0.GetPreferenceTag(arg0_171)
	return arg0_171.preferenceTag or 0
end

function var0_0.IsPreferenceTag(arg0_172)
	return arg0_172:GetPreferenceTag() == var0_0.PREFERENCE_TAG_COMMON
end

function var0_0.SetPreferenceTag(arg0_173, arg1_173)
	arg0_173.preferenceTag = arg1_173
end

function var0_0.calReturnRes(arg0_174)
	local var0_174 = pg.ship_data_by_type[arg0_174:getShipType()]
	local var1_174 = var0_174.distory_resource_gold_ratio
	local var2_174 = var0_174.distory_resource_oil_ratio
	local var3_174 = pg.ship_data_by_star[arg0_174:getConfig("rarity")].destory_item

	return var1_174, 0, var3_174
end

function var0_0.getRarity(arg0_175)
	local var0_175 = arg0_175:getConfig("rarity")

	if arg0_175:isRemoulded() then
		var0_175 = var0_175 + 1
	end

	return var0_175
end

function var0_0.updateSkill(arg0_176, arg1_176)
	local var0_176 = arg1_176.skill_id or arg1_176.id
	local var1_176 = arg1_176.skill_lv or arg1_176.lv or arg1_176.level
	local var2_176 = arg1_176.skill_exp or arg1_176.exp

	arg0_176.skills[var0_176] = {
		id = var0_176,
		level = var1_176,
		exp = var2_176
	}
end

function var0_0.canEquipAtPos(arg0_177, arg1_177, arg2_177)
	local var0_177, var1_177 = arg0_177:isForbiddenAtPos(arg1_177, arg2_177)

	if var0_177 then
		return false, var1_177
	end

	for iter0_177, iter1_177 in ipairs(arg0_177.equipments) do
		if iter1_177 and iter0_177 ~= arg2_177 and iter1_177:getConfig("equip_limit") ~= 0 and arg1_177:getConfig("equip_limit") == iter1_177:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0_0.isForbiddenAtPos(arg0_178, arg1_178, arg2_178)
	local var0_178 = pg.ship_data_template[arg0_178.configId]

	assert(var0_178, "can not find ship in ship_data_templtae: " .. arg0_178.configId)

	local var1_178 = var0_178["equip_" .. arg2_178]

	if not table.contains(var1_178, arg1_178:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1_178:getConfig("ship_type_forbidden"), arg0_178:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0_0.canEquipCommander(arg0_179, arg1_179)
	if arg1_179:getShipType() ~= arg0_179:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0_0.upgrade(arg0_180)
	local var0_180 = pg.ship_data_transform[arg0_180.configId]

	if var0_180.trans_id and var0_180.trans_id > 0 then
		arg0_180.configId = var0_180.trans_id
		arg0_180.star = arg0_180:getConfig("star")
	end
end

function var0_0.getTeamType(arg0_181)
	return TeamType.GetTeamFromShipType(arg0_181:getShipType())
end

function var0_0.getFleetName(arg0_182)
	local var0_182 = arg0_182:getTeamType()

	return var1_0[var0_182]
end

function var0_0.getMaxConfigId(arg0_183)
	local var0_183 = pg.ship_data_template
	local var1_183

	for iter0_183 = 4, 1, -1 do
		local var2_183 = tonumber(arg0_183.groupId .. iter0_183)

		if var0_183[var2_183] then
			var1_183 = var2_183

			break
		end
	end

	return var1_183
end

function var0_0.getFlag(arg0_184, arg1_184, arg2_184)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_184.id, arg1_184, arg2_184)
end

function var0_0.hasAnyFlag(arg0_185, arg1_185)
	return _.any(arg1_185, function(arg0_186)
		return arg0_185:getFlag(arg0_186)
	end)
end

function var0_0.isBreakOut(arg0_187)
	return arg0_187.configId % 10 > 1
end

function var0_0.fateSkillChange(arg0_188, arg1_188)
	if not arg0_188.skillChangeList then
		arg0_188.skillChangeList = arg0_188:isBluePrintShip() and arg0_188:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_188, iter1_188 in ipairs(arg0_188.skillChangeList) do
		if iter1_188[1] == arg1_188 and arg0_188.skills[iter1_188[2]] then
			return iter1_188[2]
		end
	end

	return arg1_188
end

function var0_0.RemapSkillId(arg0_189, arg1_189)
	local var0_189 = arg0_189:GetSpWeapon()

	if var0_189 then
		return var0_189:RemapSkillId(arg1_189)
	end

	return arg1_189
end

function var0_0.getSkillList(arg0_190)
	local var0_190 = pg.ship_data_template[arg0_190.configId]
	local var1_190 = Clone(var0_190.buff_list_display)
	local var2_190 = Clone(var0_190.buff_list)
	local var3_190 = pg.ship_data_trans[arg0_190.groupId]
	local var4_190 = 0

	if var3_190 and var3_190.skill_id ~= 0 then
		local var5_190 = var3_190.skill_id
		local var6_190 = pg.transform_data_template[var5_190]

		if arg0_190.transforms[var5_190] and var6_190.skill_id ~= 0 then
			table.insert(var2_190, var6_190.skill_id)
		end
	end

	local var7_190 = {}

	for iter0_190, iter1_190 in ipairs(var1_190) do
		for iter2_190, iter3_190 in ipairs(var2_190) do
			if iter1_190 == iter3_190 then
				table.insert(var7_190, arg0_190:fateSkillChange(iter1_190))
			end
		end
	end

	return var7_190
end

function var0_0.getModAttrTopLimit(arg0_191, arg1_191)
	local var0_191 = ShipModAttr.ATTR_TO_INDEX[arg1_191]
	local var1_191 = pg.ship_data_template[arg0_191.configId].strengthen_id
	local var2_191 = pg.ship_data_strengthen[var1_191].durability[var0_191]

	return calcFloor((3 + 7 * (math.min(arg0_191.level, 100) / 100)) * var2_191 * 0.1)
end

function var0_0.leftModAdditionPoint(arg0_192, arg1_192)
	local var0_192 = arg0_192:getModProperties(arg1_192)
	local var1_192 = arg0_192:getModExpRatio(arg1_192)
	local var2_192 = arg0_192:getModAttrTopLimit(arg1_192)
	local var3_192 = calcFloor(var0_192 / var1_192)

	return math.max(0, var2_192 - var3_192)
end

function var0_0.getModAttrBaseMax(arg0_193, arg1_193)
	if not table.contains(arg0_193:getConfig("lock"), arg1_193) then
		local var0_193 = arg0_193:leftModAdditionPoint(arg1_193)
		local var1_193 = arg0_193:getShipProperties()

		return calcFloor(var1_193[arg1_193] + var0_193)
	else
		return 0
	end
end

function var0_0.getModExpRatio(arg0_194, arg1_194)
	if not table.contains(arg0_194:getConfig("lock"), arg1_194) then
		local var0_194 = pg.ship_data_template[arg0_194.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0_194], "ship_data_strengthen>>>>>>" .. var0_194)

		return math.max(pg.ship_data_strengthen[var0_194].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1_194]], 1)
	else
		return 1
	end
end

function var0_0.inUnlockTip(arg0_195)
	local var0_195 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0_195, arg0_195)
end

function var0_0.proposeSkinOwned(arg0_196, arg1_196)
	return arg1_196 and arg0_196.propose and arg1_196.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0_0.getProposeSkin(arg0_197)
	return ShipSkin.GetSkinByType(arg0_197.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getDisplaySkillIds(arg0_198)
	return _.map(pg.ship_data_template[arg0_198.configId].buff_list_display, function(arg0_199)
		return arg0_198:fateSkillChange(arg0_199)
	end)
end

function var0_0.isFullSkillLevel(arg0_200)
	local var0_200 = pg.skill_data_template

	for iter0_200, iter1_200 in pairs(arg0_200.skills) do
		if var0_200[iter1_200.id].max_level ~= iter1_200.level then
			return false
		end
	end

	return true
end

function var0_0.setEquipmentRecord(arg0_201, arg1_201, arg2_201)
	local var0_201 = "equipment_record" .. "_" .. arg1_201 .. "_" .. arg0_201.id

	PlayerPrefs.SetString(var0_201, table.concat(_.flatten(arg2_201), ":"))
	PlayerPrefs.Save()
end

function var0_0.getEquipmentRecord(arg0_202, arg1_202)
	if not arg0_202.equipmentRecords then
		local var0_202 = "equipment_record" .. "_" .. arg1_202 .. "_" .. arg0_202.id
		local var1_202 = string.split(PlayerPrefs.GetString(var0_202) or "", ":")
		local var2_202 = {}

		for iter0_202 = 1, 3 do
			var2_202[iter0_202] = _.map(_.slice(var1_202, 5 * iter0_202 - 4, 5), function(arg0_203)
				return tonumber(arg0_203)
			end)
		end

		arg0_202.equipmentRecords = var2_202
	end

	return arg0_202.equipmentRecords
end

function var0_0.SetSpWeaponRecord(arg0_204, arg1_204, arg2_204)
	local var0_204 = "spweapon_record" .. "_" .. arg1_204 .. "_" .. arg0_204.id
	local var1_204 = _.map({
		1,
		2,
		3
	}, function(arg0_205)
		local var0_205 = arg2_204[arg0_205]

		if var0_205 then
			return (var0_205:GetUID() or 0) .. "," .. var0_205:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0_204, table.concat(var1_204, ":"))
	PlayerPrefs.Save()
end

function var0_0.GetSpWeaponRecord(arg0_206, arg1_206)
	local var0_206 = "spweapon_record" .. "_" .. arg1_206 .. "_" .. arg0_206.id

	return (_.map(string.split(PlayerPrefs.GetString(var0_206, ""), ":"), function(arg0_207)
		local var0_207 = string.split(arg0_207, ",")

		assert(var0_207)

		local var1_207 = tonumber(var0_207[1])
		local var2_207 = tonumber(var0_207[2])

		if not var2_207 or var2_207 == 0 then
			return false
		end

		return (SpWeapon.New({
			id = var2_207
		}))
	end))
end

function var0_0.hasEquipEquipmentSkin(arg0_208)
	for iter0_208, iter1_208 in ipairs(arg0_208.equipments) do
		if iter1_208 and iter1_208:hasSkin() then
			return true
		end
	end

	return false
end

function var0_0.hasCommander(arg0_209)
	return arg0_209.commanderId and arg0_209.commanderId ~= 0
end

function var0_0.getCommander(arg0_210)
	return arg0_210.commanderId
end

function var0_0.setCommander(arg0_211, arg1_211)
	arg0_211.commanderId = arg1_211
end

function var0_0.getSkillIndex(arg0_212, arg1_212)
	local var0_212 = arg0_212:getSkillList()

	for iter0_212, iter1_212 in ipairs(var0_212) do
		if arg1_212 == iter1_212 then
			return iter0_212
		end
	end
end

function var0_0.getTactics(arg0_213)
	return 1, "tactics_attack"
end

function var0_0.IsBgmSkin(arg0_214)
	local var0_214 = arg0_214:GetSkinConfig()

	return table.contains(var0_214.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_215)
	if arg0_215:IsBgmSkin() then
		return arg0_215:GetSkinConfig().bgm
	end
end

function var0_0.isIntensifyMax(arg0_216)
	local var0_216 = intProperties(arg0_216:getShipProperties())

	if arg0_216:isBluePrintShip() then
		return true
	end

	for iter0_216, iter1_216 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_216:getModAttrBaseMax(iter1_216) ~= var0_216[iter1_216] then
			return false
		end
	end

	return true
end

function var0_0.isRemouldable(arg0_217)
	return not arg0_217:isTestShip() and not arg0_217:isBluePrintShip() and pg.ship_data_trans[arg0_217.groupId]
end

function var0_0.isAllRemouldFinish(arg0_218)
	local var0_218 = pg.ship_data_trans[arg0_218.groupId]

	assert(var0_218, "this ship group without remould config:" .. arg0_218.groupId)

	for iter0_218, iter1_218 in ipairs(var0_218.transform_list) do
		for iter2_218, iter3_218 in ipairs(iter1_218) do
			local var1_218 = pg.transform_data_template[iter3_218[2]]

			if #var1_218.edit_trans > 0 then
				-- block empty
			elseif not arg0_218.transforms[iter3_218[2]] or arg0_218.transforms[iter3_218[2]].level < var1_218.max_level then
				return false
			end
		end
	end

	return true
end

function var0_0.isSpecialFilter(arg0_219)
	local var0_219 = pg.ship_data_statistics[arg0_219.configId]

	assert(var0_219, "this ship without statistics:" .. arg0_219.configId)

	for iter0_219, iter1_219 in ipairs(var0_219.tag_list) do
		if iter1_219 == "special" then
			return true
		end
	end

	return false
end

function var0_0.hasAvailiableSkin(arg0_220)
	local var0_220 = getProxy(ShipSkinProxy)
	local var1_220 = var0_220:GetAllSkinForShip(arg0_220)
	local var2_220 = var0_220:getRawData()
	local var3_220 = 0

	for iter0_220, iter1_220 in ipairs(var1_220) do
		if arg0_220:proposeSkinOwned(iter1_220) or var2_220[iter1_220.id] or var0_220:hasSkin(iter1_220.id) then
			var3_220 = var3_220 + 1
		end
	end

	return var3_220 > 0
end

function var0_0.hasProposeSkin(arg0_221)
	local var0_221 = getProxy(ShipSkinProxy)
	local var1_221 = var0_221:GetAllSkinForShip(arg0_221)

	for iter0_221, iter1_221 in ipairs(var1_221) do
		if iter1_221.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2_221 = var0_221:GetShareSkinsForShip(arg0_221)

	for iter2_221, iter3_221 in ipairs(var2_221) do
		if iter3_221.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0_0.HasUniqueSpWeapon(arg0_222)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0_222:getGroupId()])
end

function var0_0.getAircraftReloadCD(arg0_223)
	local var0_223 = arg0_223:getConfigTable().base_list
	local var1_223 = arg0_223:getConfigTable().default_equip_list
	local var2_223 = 0
	local var3_223 = 0

	for iter0_223 = 1, 3 do
		local var4_223 = arg0_223:getEquip(iter0_223)
		local var5_223 = var4_223 and var4_223.configId or var1_223[iter0_223]
		local var6_223 = Equipment.getConfigData(var5_223).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0_224)
			return var6_223 == arg0_224
		end) then
			var2_223 = var2_223 + Equipment.GetEquipReloadStatic(var5_223) * var0_223[iter0_223]
			var3_223 = var3_223 + var0_223[iter0_223]
		end
	end

	local var7_223 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2_223 / var3_223 * var7_223
	}
end

function var0_0.IsTagShip(arg0_225, arg1_225)
	local var0_225 = arg0_225:getConfig("tag_list")

	return table.contains(var0_225, arg1_225)
end

function var0_0.setReMetaSpecialItemVO(arg0_226, arg1_226)
	arg0_226.reMetaSpecialItemVO = arg1_226
end

function var0_0.getReMetaSpecialItemVO(arg0_227, arg1_227)
	return arg0_227.reMetaSpecialItemVO
end

function var0_0.getProposeType(arg0_228)
	if arg0_228:isMetaShip() then
		return "meta"
	elseif arg0_228:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_229)
	return arg0_229:getNation() == Nation.IDOL_LINK
end

function var0_0.getSpecificType(arg0_230)
	return pg.ship_data_template[arg0_230.configId].specific_type
end

function var0_0.GetSpWeapon(arg0_231)
	return arg0_231.spWeapon
end

function var0_0.UpdateSpWeapon(arg0_232, arg1_232)
	local var0_232 = (arg1_232 and arg1_232:GetUID() or 0) == (arg0_232.spWeapon and arg0_232.spWeapon:GetUID() or 0)

	arg0_232.spWeapon = arg1_232

	if arg1_232 then
		arg1_232:SetShipId(arg0_232.id)
	end

	if var0_232 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0_0.CanEquipSpWeapon(arg0_233, arg1_233)
	local var0_233, var1_233 = arg0_233:IsSpWeaponForbidden(arg1_233)

	if var0_233 then
		return false, var1_233
	end

	return true
end

function var0_0.IsSpWeaponForbidden(arg0_234, arg1_234)
	local var0_234 = arg1_234:GetWearableShipTypes()
	local var1_234 = arg0_234:getShipType()

	if not table.contains(var0_234, var1_234) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2_234 = arg1_234:GetUniqueGroup()
	local var3_234 = arg0_234:getGroupId()

	if var2_234 ~= 0 and var2_234 ~= var3_234 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0_0.GetMapStrikeAnim(arg0_235)
	local var0_235
	local var1_235 = arg0_235:getShipType()

	switch(TeamType.GetTeamFromShipType(var1_235), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1_235) then
				var0_235 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1_235) then
				var0_235 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1_235) then
				var0_235 = "CannonUI"
			else
				var0_235 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1_235) then
				var0_235 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0_235:getNation() == Nation.MOT then
				var0_235 = "CannonUI"
			else
				var0_235 = "SubTorpedoUI"
			end
		end
	})

	return var0_235
end

function var0_0.IsDefaultSkin(arg0_239)
	local var0_239 = arg0_239:getSkinId()

	return var0_239 == 0 or var0_239 == arg0_239:getConfig("skin_id")
end

function var0_0.IsMatchKey(arg0_240, arg1_240)
	if not arg1_240 or arg1_240 == "" then
		return true
	end

	arg1_240 = string.lower(string.gsub(arg1_240, "%.", "%%."))

	local var0_240 = {
		arg0_240:getName(),
		arg0_240:GetDefaultName()
	}

	if var0_240[1] == var0_240[2] then
		table.remove(var0_240)
	end

	return underscore.any(var0_240, function(arg0_241)
		return string.find(string.lower(arg0_241), arg1_240)
	end)
end

function var0_0.IsOwner(arg0_242)
	return tobool(arg0_242.id)
end

function var0_0.GetUniqueId(arg0_243)
	return arg0_243.id
end

function var0_0.ShowPropose(arg0_244)
	if not arg0_244.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0_244:IsOwner() and arg0_244:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0_0.GetColorName(arg0_245, arg1_245)
	arg1_245 = arg1_245 or arg0_245:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0_245.propose then
		return setColorStr(arg1_245, "#FFAACEFF")
	else
		return arg1_245
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

function var0_0.GetFrameAndEffect(arg0_246, arg1_246)
	arg1_246 = tobool(arg1_246)

	local var0_246
	local var1_246

	if arg0_246.propose then
		if arg0_246:isMetaShip() then
			var1_246 = string.format(var9_0.effect[1])
			var0_246 = string.format(var9_0.frame[1])
		elseif arg0_246:isBluePrintShip() then
			var1_246 = string.format(var9_0.effect[2])
			var0_246 = string.format(var9_0.frame[2], arg0_246:rarity2bgPrint())
		else
			var1_246 = string.format(var9_0.effect[3])
			var0_246 = string.format(var9_0.frame[3])
		end

		if not arg0_246:ShowPropose() then
			var0_246 = nil
		end
	elseif arg0_246:isMetaShip() then
		var1_246 = string.format(var9_0.effect[4], arg0_246:rarity2bgPrint())
	elseif arg0_246:getRarity() == ShipRarity.SSR then
		var1_246 = string.format(var9_0.effect[5])
	end

	if arg1_246 then
		var1_246 = var1_246 and var1_246 .. "_1"
	end

	return var0_246, var1_246
end

function var0_0.GetRecordPosKey(arg0_247)
	return arg0_247:getSkinId()
end

function var0_0.GetShipPhantomMark(arg0_248, arg1_248)
	return ShipPhantom.PackMark(arg0_248.id, arg1_248)
end

function var0_0.GetSelectMark(arg0_249)
	return arg0_249.id
end

return var0_0
