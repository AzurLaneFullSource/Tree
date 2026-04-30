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
	local var0_30 = arg0_30:getEnergy()

	for iter0_30, iter1_30 in ipairs(pg.energy_template.all) do
		local var1_30 = pg.energy_template[iter1_30]

		if type(iter1_30) == "number" and var0_30 >= var1_30.lower_bound and var0_30 <= var1_30.upper_bound then
			return var1_30
		end
	end

	assert(false, "疲劳配置不存在：" .. arg0_30.energy)
end

function var0_0.isLowEnergy(arg0_31)
	return arg0_31:getEnergeConfig().id < 3
end

function var0_0.getEnergyPrint(arg0_32)
	local var0_32 = arg0_32:getEnergeConfig()

	return var0_32.icon, var0_32.desc
end

function var0_0.getIntimacy(arg0_33)
	return arg0_33.intimacy
end

function var0_0.getCVIntimacy(arg0_34)
	return arg0_34:getIntimacy() / 100 + (arg0_34.propose and 1000 or 0)
end

function var0_0.getIntimacyMax(arg0_35)
	if arg0_35.propose then
		return 200
	else
		return arg0_35:GetNoProposeIntimacyMax()
	end
end

function var0_0.GetNoProposeIntimacyMax(arg0_36)
	return 100
end

function var0_0.getIntimacyIcon(arg0_37)
	local var0_37 = pg.intimacy_template[arg0_37:getIntimacyLevel()]
	local var1_37 = ""

	if arg0_37:isMetaShip() then
		var1_37 = "_meta"
	elseif arg0_37:IsXIdol() then
		var1_37 = "_imas"
	end

	if not arg0_37.propose and math.floor(arg0_37:getIntimacy() / 100) >= arg0_37:getIntimacyMax() then
		return var0_37.icon .. var1_37, "heart" .. var1_37
	else
		return var0_37.icon .. var1_37
	end
end

function var0_0.getIntimacyDetail(arg0_38)
	return arg0_38:getIntimacyMax(), math.floor(arg0_38:getIntimacy() / 100)
end

function var0_0.getIntimacyInfo(arg0_39)
	local var0_39 = pg.intimacy_template[arg0_39:getIntimacyLevel()]

	return var0_39.icon, var0_39.desc
end

function var0_0.getIntimacyLevel(arg0_40)
	local var0_40 = 0

	for iter0_40, iter1_40 in pairs(pg.intimacy_template.all) do
		local var1_40 = pg.intimacy_template[iter1_40]

		if type(iter1_40) == "number" and arg0_40:getIntimacy() >= var1_40.lower_bound and arg0_40:getIntimacy() <= var1_40.upper_bound then
			var0_40 = iter1_40

			break
		end
	end

	if var0_40 < arg0_40.INTIMACY_PROPOSE and arg0_40.propose then
		var0_40 = arg0_40.INTIMACY_PROPOSE
	end

	return var0_40
end

function var0_0.getBluePrint(arg0_41)
	local var0_41 = ShipBluePrint.New({
		id = arg0_41.groupId
	})
	local var1_41 = arg0_41.strengthList[1] or {
		exp = 0,
		level = 0
	}

	var0_41:updateInfo({
		blue_print_level = var1_41.level,
		exp = var1_41.exp
	})

	return var0_41
end

function var0_0.getBaseList(arg0_42)
	if arg0_42:isBluePrintShip() then
		local var0_42 = arg0_42:getBluePrint()

		assert(var0_42, "blueprint can not be nil" .. arg0_42.configId)

		return var0_42:getBaseList(arg0_42)
	else
		return arg0_42:getConfig("base_list")
	end
end

function var0_0.getPreLoadCount(arg0_43)
	if arg0_43:isBluePrintShip() then
		return arg0_43:getBluePrint():getPreLoadCount(arg0_43)
	else
		return arg0_43:getConfig("preload_count")
	end
end

function var0_0.getNation(arg0_44)
	return arg0_44:getConfig("nationality")
end

function var0_0.getPaintingName(arg0_45)
	local var0_45 = pg.ship_data_statistics[arg0_45].skin_id
	local var1_45 = pg.ship_skin_template[var0_45]

	assert(var1_45, "ship_skin_template not exist: " .. arg0_45 .. " " .. var0_45)

	return var1_45.painting
end

function var0_0.getName(arg0_46)
	if arg0_46.propose and pg.PushNotificationMgr.GetInstance():isEnableShipName() then
		return arg0_46.name
	end

	if arg0_46:isRemoulded() then
		return pg.ship_skin_template[arg0_46:getRemouldSkinId()].name
	end

	return pg.ship_data_statistics[arg0_46.configId].name
end

function var0_0.GetDefaultName(arg0_47)
	if arg0_47:isRemoulded() then
		return pg.ship_skin_template[arg0_47:getRemouldSkinId()].name
	else
		return pg.ship_data_statistics[arg0_47.configId].name
	end
end

function var0_0.getShipName(arg0_48)
	return pg.ship_data_statistics[arg0_48].name
end

function var0_0.getBreakOutLevel(arg0_49)
	assert(arg0_49, "必须存在配置id")
	assert(pg.ship_data_statistics[arg0_49], "必须存在配置" .. arg0_49)

	return pg.ship_data_statistics[arg0_49].star
end

function var0_0.Ctor(arg0_50, arg1_50)
	arg0_50.id = arg1_50.id
	arg0_50.configId = arg1_50.template_id or arg1_50.configId
	arg0_50.level = arg1_50.level
	arg0_50.exp = arg1_50.exp
	arg0_50.energy = arg1_50.energy
	arg0_50.lockState = arg1_50.is_locked
	arg0_50.intimacy = arg1_50.intimacy
	arg0_50.propose = arg1_50.propose and arg1_50.propose > 0
	arg0_50.proposeTime = arg1_50.propose

	if arg0_50.intimacy and arg0_50.intimacy > 10000 and not arg0_50.propose then
		arg0_50.intimacy = 10000
	end

	arg0_50.renameTime = arg1_50.change_name_timestamp

	if arg1_50.name and arg1_50.name ~= "" then
		arg0_50.name = arg1_50.name
	else
		assert(pg.ship_data_statistics[arg0_50.configId], "必须存在配置" .. arg0_50.configId)

		arg0_50.name = pg.ship_data_statistics[arg0_50.configId].name
	end

	arg0_50.groupId = pg.ship_data_template[arg0_50.configId].group_type

	local var0_50 = pg.ship_data_group.get_id_list_by_group_type[arg0_50.groupId][1]

	arg0_50.bluePrintFlag = pg.ship_data_group[var0_50].handbook_type == 2
	arg0_50.strengthList = {}

	for iter0_50, iter1_50 in ipairs(arg1_50.strength_list or {}) do
		if not arg0_50:isBluePrintShip() then
			local var1_50 = ShipModAttr.ID_TO_ATTR[iter1_50.id]

			arg0_50.strengthList[var1_50] = iter1_50.exp
		else
			table.insert(arg0_50.strengthList, {
				level = iter1_50.id,
				exp = iter1_50.exp
			})
		end
	end

	local var2_50 = arg1_50.state or {}

	arg0_50.state = var2_50.state or 0
	arg0_50.state_info_1 = var2_50.state_info_1 or 0
	arg0_50.state_info_2 = var2_50.state_info_2 or 0
	arg0_50.state_info_3 = var2_50.state_info_3 or 0
	arg0_50.state_info_4 = var2_50.state_info_4 or 0
	arg0_50.equipmentSkins = {}
	arg0_50.equipments = {}

	if arg1_50.equip_info_list then
		for iter2_50, iter3_50 in ipairs(arg1_50.equip_info_list or {}) do
			arg0_50.equipments[iter2_50] = iter3_50.id > 0 and Equipment.New({
				count = 1,
				id = iter3_50.id,
				config_id = iter3_50.id,
				skinId = iter3_50.skinId
			}) or false
			arg0_50.equipmentSkins[iter2_50] = iter3_50.skinId > 0 and iter3_50.skinId or 0

			arg0_50:reletiveEquipSkin(iter2_50)
		end
	end

	arg0_50.spWeapon = nil

	if arg1_50.spweapon then
		arg0_50:UpdateSpWeapon(SpWeapon.CreateByNet(arg1_50.spweapon))
	end

	arg0_50.skills = {}

	for iter4_50, iter5_50 in ipairs(arg1_50.skill_id_list or {}) do
		arg0_50:updateSkill(iter5_50)
	end

	arg0_50.star = arg0_50:getConfig("rarity")
	arg0_50.transforms = {}

	for iter6_50, iter7_50 in ipairs(arg1_50.transform_list or {}) do
		arg0_50.transforms[iter7_50.id] = {
			id = iter7_50.id,
			level = iter7_50.level
		}
	end

	arg0_50.createTime = arg1_50.create_time or 0

	local var3_50 = getProxy(CollectionProxy)

	arg0_50.virgin = var3_50 and var3_50.shipGroups[arg0_50.groupId] == nil

	local var4_50 = {
		pg.gameset.test_ship_config_1.key_value,
		pg.gameset.test_ship_config_2.key_value,
		pg.gameset.test_ship_config_3.key_value
	}
	local var5_50 = table.indexof(var4_50, arg0_50.configId)

	if var5_50 == 1 then
		arg0_50.testShip = {
			2,
			3,
			4
		}
	elseif var5_50 == 2 then
		arg0_50.testShip = {
			5
		}
	elseif var5_50 == 3 then
		arg0_50.testShip = {
			6
		}
	else
		arg0_50.testShip = nil
	end

	arg0_50.maxIntimacy = pg.intimacy_template[#pg.intimacy_template.all].upper_bound

	local var6_50 = 0

	if not HXSet.isHxSkin() then
		var6_50 = arg1_50.skin_id or 0
	end

	arg0_50.phantomDic = {}

	arg0_50:updateSkinId(var6_50, 0)

	for iter8_50, iter9_50 in ipairs(arg1_50.skin_shadow_list or {}) do
		arg0_50:updateSkinId(iter9_50.value, iter9_50.key)
	end

	arg0_50.noChangeSkin = arg1_50.noChangeSkin or false
	arg0_50.phantomRandomFlag = {}

	for iter10_50, iter11_50 in ipairs(arg1_50.char_random_flag or {}) do
		arg0_50:updateRandomFlag(1, iter11_50)
	end

	if arg1_50.name and arg1_50.name ~= "" then
		arg0_50.name = arg1_50.name
	elseif arg0_50:isRemoulded() then
		arg0_50.name = pg.ship_skin_template[arg0_50:getRemouldSkinId()].name
	else
		arg0_50.name = pg.ship_data_statistics[arg0_50.configId].name
	end

	arg0_50.maxLevel = arg1_50.max_level
	arg0_50.proficiency = arg1_50.proficiency or 0
	arg0_50.preferenceTag = arg1_50.common_flag
	arg0_50.hpRant = 10000
	arg0_50.strategies = {}
	arg0_50.triggers = {}
	arg0_50.commanderId = arg1_50.commanderid or 0
	arg0_50.activityNpc = arg1_50.activity_npc or 0

	if var0_0.isMetaShipByConfigID(arg0_50.configId) then
		local var7_50 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_50.configId)

		arg0_50.metaCharacter = MetaCharacter.New({
			id = var7_50,
			repair_attr_info = arg1_50.meta_repair_list
		}, arg0_50)
	end
end

function var0_0.isMetaShipByConfigID(arg0_51)
	local var0_51 = pg.ship_meta_breakout.all
	local var1_51 = var0_51[1]
	local var2_51 = false

	if var1_51 <= arg0_51 then
		for iter0_51, iter1_51 in ipairs(var0_51) do
			if arg0_51 == iter1_51 then
				var2_51 = true

				break
			end
		end
	end

	return var2_51
end

function var0_0.isMetaShip(arg0_52)
	return arg0_52.metaCharacter ~= nil
end

function var0_0.getMetaCharacter(arg0_53)
	return arg0_53.metaCharacter
end

function var0_0.unlockActivityNpc(arg0_54, arg1_54)
	arg0_54.activityNpc = arg1_54
end

function var0_0.isActivityNpc(arg0_55)
	return arg0_55.activityNpc > 0
end

function var0_0.getActiveEquipments(arg0_56)
	local var0_56 = Clone(arg0_56.equipments)

	for iter0_56 = #var0_56, 1, -1 do
		local var1_56 = var0_56[iter0_56]

		if var1_56 then
			for iter1_56 = 1, iter0_56 - 1 do
				local var2_56 = var0_56[iter1_56]

				if var2_56 and var1_56:getConfig("equip_limit") ~= 0 and var2_56:getConfig("equip_limit") == var1_56:getConfig("equip_limit") then
					var0_56[iter0_56] = false
				end
			end
		end
	end

	return var0_56
end

function var0_0.getAllEquipments(arg0_57)
	return arg0_57.equipments
end

function var0_0.isBluePrintShip(arg0_58)
	return arg0_58.bluePrintFlag
end

function var0_0.getSkinId(arg0_59, arg1_59)
	local var0_59 = arg0_59:getPhantomSkin(arg1_59 or 0)

	if not arg0_59.noChangeSkin and tobool(arg0_59.id) and ShipSkin.IsChangeSkin(var0_59) then
		local var1_59 = ShipSkin.GetStoreChangeSkinId(ShipSkin.GetChangeSkinGroupId(var0_59), arg0_59:GetShipPhantomMark())

		if var1_59 then
			return var1_59
		end
	end

	return var0_59
end

function var0_0.RevertAsmrSkin(arg0_60)
	local var0_60 = arg0_60:getSkinId()

	if not arg0_60.noChangeSkin and tobool(arg0_60.id) and ShipSkin.IsChangeSkin(var0_60) then
		local var1_60 = ShipSkin.GetChangeSkinCustomDataId(var0_60, "asmr") == 1 and true or false
		local var2_60 = ShipSkin.GetChangeSkinCustomDataId(var0_60, "index") == 1 and true or false

		if var1_60 and not var2_60 then
			local var3_60 = ShipSkin.GetChangeSkinMainId(var0_60)

			ShipSkin.SetStoreChangeSkinId(var3_60, arg0_60:GetShipPhantomMark())
		end
	end
end

function var0_0.getPhantomSkin(arg0_61, arg1_61)
	if not arg1_61 or arg1_61 == 0 then
		return arg0_61.skinId
	else
		return arg0_61.phantomDic[arg0_61.phantomId] or arg0_61:getConfig("skin_id")
	end
end

function var0_0.updateSkinId(arg0_62, arg1_62, arg2_62)
	if not arg1_62 or arg1_62 == 0 then
		arg1_62 = arg0_62:getConfig("skin_id")
	end

	if arg2_62 == 0 then
		arg0_62.skinId = arg1_62
	else
		arg0_62.phantomDic[arg2_62] = arg1_62
	end
end

function var0_0.getAllShipPhantomMarks(arg0_63)
	local var0_63 = getGameset("technology_shadow_num")[1]
	local var1_63 = {}

	for iter0_63 = 0, var0_63 do
		if iter0_63 == 0 or arg0_63.phantomDic[iter0_63] then
			table.insert(var1_63, ShipPhantom.PackMark(arg0_63.id, iter0_63))
		end
	end

	return var1_63
end

function var0_0.getAllShipPhantom(arg0_64)
	local var0_64 = getGameset("technology_shadow_num")[1]
	local var1_64 = {}

	for iter0_64 = 0, var0_64 do
		if iter0_64 == 0 or arg0_64.phantomDic[iter0_64] then
			table.insert(var1_64, ShipPhantom.Create(arg0_64, iter0_64))
		end
	end

	return var1_64
end

function var0_0.updateRandomFlag(arg0_65, arg1_65, arg2_65)
	arg2_65 = defaultValue(arg2_65, 0)
	arg0_65.phantomRandomFlag[arg2_65] = arg1_65
end

function var0_0.getRandomFlag(arg0_66, arg1_66)
	return defaultValue(arg0_66.phantomRandomFlag[arg1_66 or 0], 0) > 0
end

function var0_0.getRandomFlagShipPhantomMarks(arg0_67)
	local var0_67 = getGameset("technology_shadow_num")[1]
	local var1_67 = {}

	for iter0_67 = 0, var0_67 do
		if defaultValue(arg0_67.phantomRandomFlag[iter0_67], 0) > 0 then
			table.insert(var1_67, arg0_67:GetShipPhantomMark(iter0_67))
		end
	end

	return var1_67
end

function var0_0.updateName(arg0_68)
	if arg0_68.name ~= pg.ship_data_statistics[arg0_68.configId].name then
		return
	end

	if arg0_68:isRemoulded() then
		arg0_68.name = pg.ship_skin_template[arg0_68:getRemouldSkinId()].name
	else
		arg0_68.name = pg.ship_data_statistics[arg0_68.configId].name
	end
end

function var0_0.isRemoulded(arg0_69)
	if arg0_69.remoulded then
		return true
	end

	local var0_69 = pg.ship_data_trans[arg0_69.groupId]

	if var0_69 then
		for iter0_69, iter1_69 in ipairs(var0_69.transform_list) do
			for iter2_69, iter3_69 in ipairs(iter1_69) do
				local var1_69 = pg.transform_data_template[iter3_69[2]]

				if var1_69.skin_id ~= 0 and arg0_69.transforms[iter3_69[2]] and arg0_69.transforms[iter3_69[2]].level == var1_69.max_level then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.getRemouldSkinId(arg0_70)
	local var0_70 = ShipGroup.getModSkin(arg0_70.groupId)

	if var0_70 then
		return var0_70.id
	end

	return nil
end

function var0_0.hasEquipmentSkinInPos(arg0_71, arg1_71)
	local var0_71 = arg0_71.equipments[arg1_71]

	return var0_71 and var0_71:hasSkin()
end

function var0_0.getPrefab(arg0_72, arg1_72)
	local var0_72 = arg0_72:getSkinId()

	if arg0_72:hasEquipmentSkinInPos(var2_0) then
		local var1_72 = arg0_72:getEquip(var2_0)
		local var2_72 = var7_0[var1_72:getSkinId()].ship_skin_id

		var0_72 = var2_72 ~= 0 and var2_72 or var0_72
	end

	local var3_72 = pg.ship_skin_template[var0_72]

	assert(var3_72, "ship_skin_template not exist: " .. arg0_72.configId .. " " .. var0_72)

	if var3_72.double_char and var3_72.double_char == 1 and arg1_72 ~= nil then
		local var4_72

		if arg1_72 == 1 then
			return var3_72.prefab .. "_L"
		elseif arg1_72 == 2 then
			return var3_72.prefab .. "_R"
		end
	end

	return var3_72.prefab
end

function var0_0.IsDoubleSkin(arg0_73)
	local var0_73 = arg0_73:getSkinId()
	local var1_73 = pg.ship_skin_template[var0_73]

	assert(var1_73, "ship_skin_template not exist: " .. arg0_73.configId .. " " .. var0_73)

	return var1_73.double_char and var1_73.double_char == 1 or false
end

function var0_0.getAttachmentPrefab(arg0_74)
	local var0_74 = {}

	for iter0_74, iter1_74 in ipairs(arg0_74.equipments) do
		if iter1_74 and iter1_74:hasSkinOrbit() then
			local var1_74 = iter1_74:getSkinId()
			local var2_74 = var7_0[var1_74]

			var0_74[var1_74] = {
				config = var2_74,
				index = iter0_74
			}
		end
	end

	return var0_74
end

function var0_0.getPainting(arg0_75)
	local var0_75 = arg0_75:getSkinId()
	local var1_75 = pg.ship_skin_template[var0_75]

	assert(var1_75, "ship_skin_template not exist: " .. arg0_75.configId .. " " .. var0_75)

	return var1_75.painting
end

function var0_0.GetSkinConfig(arg0_76, arg1_76)
	local var0_76 = arg0_76:getSkinId()
	local var1_76 = pg.ship_skin_template[var0_76]

	assert(var1_76, "ship_skin_template not exist: " .. arg0_76.configId .. " " .. var0_76)

	return var1_76
end

function var0_0.getRemouldPainting(arg0_77)
	local var0_77 = arg0_77:getRemouldSkinId()
	local var1_77 = pg.ship_skin_template[var0_77]

	assert(var1_77, "ship_skin_template not exist: " .. arg0_77.configId .. " " .. var0_77)

	return var1_77.painting
end

function var0_0.updateStateInfo34(arg0_78, arg1_78, arg2_78)
	arg0_78.state_info_3 = arg1_78
	arg0_78.state_info_4 = arg2_78
end

function var0_0.hasStateInfo3Or4(arg0_79)
	return arg0_79.state_info_3 ~= 0 or arg0_79.state_info_4 ~= 0
end

function var0_0.isTestShip(arg0_80)
	return arg0_80.testShip
end

function var0_0.canUseTestShip(arg0_81, arg1_81)
	assert(arg0_81.testShip, "ship is not TestShip")

	return table.contains(arg0_81.testShip, arg1_81)
end

function var0_0.updateEquip(arg0_82, arg1_82, arg2_82)
	assert(arg2_82 == nil or arg2_82.count == 1)

	local var0_82 = arg0_82.equipments[arg1_82]

	arg0_82.equipments[arg1_82] = arg2_82 and Clone(arg2_82) or false

	local function var1_82(arg0_83)
		arg0_83 = CreateShell(arg0_83)
		arg0_83.shipId = arg0_82.id
		arg0_83.shipPos = arg1_82

		return arg0_83
	end

	if var0_82 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0_82, arg0_82.id, arg1_82)
		var0_82:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1_82(var0_82))
	end

	if arg2_82 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2_82, arg0_82.id, arg1_82)
		arg0_82:reletiveEquipSkin(arg1_82)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1_82(arg2_82))
	end
end

function var0_0.reletiveEquipSkin(arg0_84, arg1_84)
	if arg0_84.equipments[arg1_84] and arg0_84.equipmentSkins[arg1_84] ~= 0 then
		local var0_84 = pg.equip_skin_template[arg0_84.equipmentSkins[arg1_84]].equip_type
		local var1_84 = arg0_84.equipments[arg1_84]:getType()

		if table.contains(var0_84, var1_84) then
			arg0_84.equipments[arg1_84]:setSkinId(arg0_84.equipmentSkins[arg1_84])
		else
			arg0_84.equipments[arg1_84]:setSkinId(0)
		end
	elseif arg0_84.equipments[arg1_84] then
		arg0_84.equipments[arg1_84]:setSkinId(0)
	end
end

function var0_0.updateEquipmentSkin(arg0_85, arg1_85, arg2_85)
	if not arg1_85 then
		return
	end

	if arg2_85 and arg2_85 > 0 then
		local var0_85 = arg0_85:getSkinTypes(arg1_85)
		local var1_85 = pg.equip_skin_template[arg2_85].equip_type
		local var2_85 = false

		for iter0_85, iter1_85 in ipairs(var0_85) do
			for iter2_85, iter3_85 in ipairs(var1_85) do
				if iter1_85 == iter3_85 then
					var2_85 = true

					break
				end
			end
		end

		if not var2_85 then
			assert(var2_85, "部位" .. arg1_85 .. " 无法穿戴皮肤 " .. arg2_85)

			return
		end

		local var3_85 = arg0_85.equipments[arg1_85] and arg0_85.equipments[arg1_85]:getType() or false

		arg0_85.equipmentSkins[arg1_85] = arg2_85

		if var3_85 and table.contains(var1_85, var3_85) then
			arg0_85.equipments[arg1_85]:setSkinId(arg0_85.equipmentSkins[arg1_85])
		elseif var3_85 and not table.contains(var1_85, var3_85) then
			arg0_85.equipments[arg1_85]:setSkinId(0)
		end
	else
		arg0_85.equipmentSkins[arg1_85] = 0

		if arg0_85.equipments[arg1_85] then
			arg0_85.equipments[arg1_85]:setSkinId(0)
		end
	end
end

function var0_0.getEquip(arg0_86, arg1_86)
	return Clone(arg0_86.equipments[arg1_86])
end

function var0_0.getEquipSkins(arg0_87)
	return Clone(arg0_87.equipmentSkins)
end

function var0_0.getEquipSkin(arg0_88, arg1_88)
	return arg0_88.equipmentSkins[arg1_88]
end

function var0_0.getCanEquipSkin(arg0_89, arg1_89)
	local var0_89 = arg0_89:getSkinTypes(arg1_89)

	if var0_89 and #var0_89 then
		for iter0_89, iter1_89 in ipairs(var0_89) do
			if pg.equip_data_by_type[iter1_89].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0_0.checkCanEquipSkin(arg0_90, arg1_90, arg2_90)
	if not arg1_90 or not arg2_90 then
		return
	end

	local var0_90 = arg0_90:getSkinTypes(arg1_90)
	local var1_90 = pg.equip_skin_template[arg2_90].equip_type

	for iter0_90, iter1_90 in ipairs(var0_90) do
		if table.contains(var1_90, iter1_90) then
			return true
		end
	end

	return false
end

function var0_0.getSkinTypes(arg0_91, arg1_91)
	return pg.ship_data_template[arg0_91.configId]["equip_" .. arg1_91] or {}
end

function var0_0.updateState(arg0_92, arg1_92)
	arg0_92.state = arg1_92
end

function var0_0.addSkillExp(arg0_93, arg1_93, arg2_93)
	local var0_93 = arg0_93.skills[arg1_93] or {
		exp = 0,
		level = 1,
		id = arg1_93
	}
	local var1_93 = var0_93.level and var0_93.level or 1
	local var2_93 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1_93 == var2_93 then
		return
	end

	local var3_93 = var0_93.exp and arg2_93 + var0_93.exp or 0 + arg2_93

	while var3_93 >= pg.skill_need_exp[var1_93].exp do
		var3_93 = var3_93 - pg.skill_need_exp[var1_93].exp
		var1_93 = var1_93 + 1

		if var1_93 == var2_93 then
			var3_93 = 0

			break
		end
	end

	arg0_93:updateSkill({
		id = var0_93.id,
		level = var1_93,
		exp = var3_93
	})
end

function var0_0.upSkillLevelForMeta(arg0_94, arg1_94)
	local var0_94 = arg0_94.skills[arg1_94] or {
		exp = 0,
		level = 0,
		id = arg1_94
	}
	local var1_94 = arg0_94:isSkillLevelMax(arg1_94)
	local var2_94 = var0_94.level

	if not var1_94 then
		var2_94 = var2_94 + 1
	end

	arg0_94:updateSkill({
		exp = 0,
		id = var0_94.id,
		level = var2_94
	})
end

function var0_0.getMetaSkillLevelBySkillID(arg0_95, arg1_95)
	return (arg0_95.skills[arg1_95] or {
		exp = 0,
		level = 0,
		id = arg1_95
	}).level
end

function var0_0.isSkillLevelMax(arg0_96, arg1_96)
	local var0_96 = arg0_96.skills[arg1_96] or {
		exp = 0,
		level = 1,
		id = arg1_96
	}

	return (var0_96.level and var0_96.level or 1) >= pg.skill_data_template[arg1_96].max_level
end

function var0_0.isAllMetaSkillLevelMax(arg0_97)
	local var0_97 = true
	local var1_97 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_97.configId)

	for iter0_97, iter1_97 in ipairs(var1_97) do
		if not arg0_97:isSkillLevelMax(iter1_97) then
			var0_97 = false

			break
		end
	end

	return var0_97
end

function var0_0.isAllMetaSkillLock(arg0_98)
	local var0_98 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_98.configId)
	local var1_98 = true

	for iter0_98, iter1_98 in ipairs(var0_98) do
		if arg0_98:getMetaSkillLevelBySkillID(iter1_98) > 0 then
			var1_98 = false

			break
		end
	end

	return var1_98
end

function var0_0.bindConfigTable(arg0_99)
	return pg.ship_data_statistics
end

function var0_0.isAvaiable(arg0_100)
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

function var0_0.intimacyAdditions(arg0_101, arg1_101)
	local var0_101 = pg.intimacy_template[arg0_101:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0_101, iter1_101 in pairs(arg1_101) do
		if iter0_101 == AttributeType.Durability or iter0_101 == AttributeType.Cannon or iter0_101 == AttributeType.Torpedo or iter0_101 == AttributeType.AntiAircraft or iter0_101 == AttributeType.AntiSub or iter0_101 == AttributeType.Air or iter0_101 == AttributeType.Reload or iter0_101 == AttributeType.Hit or iter0_101 == AttributeType.Dodge then
			arg1_101[iter0_101] = arg1_101[iter0_101] * (var0_101 + 1)
		end
	end
end

function var0_0.getShipProperties(arg0_102)
	local var0_102 = arg0_102:getBaseProperties()

	if arg0_102:isBluePrintShip() then
		local var1_102 = arg0_102:getBluePrint()

		assert(var1_102, "blueprint can not be nil" .. arg0_102.configId)

		local var2_102 = var1_102:getTotalAdditions()

		for iter0_102, iter1_102 in pairs(var2_102) do
			var0_102[iter0_102] = var0_102[iter0_102] + calcFloor(iter1_102)
		end

		arg0_102:intimacyAdditions(var0_102)
	elseif arg0_102:isMetaShip() then
		assert(arg0_102.metaCharacter)

		for iter2_102, iter3_102 in pairs(var0_102) do
			var0_102[iter2_102] = var0_102[iter2_102] + arg0_102.metaCharacter:getAttrAddition(iter2_102)
		end

		arg0_102:intimacyAdditions(var0_102)
	else
		local var3_102 = pg.ship_data_template[arg0_102.configId].strengthen_id
		local var4_102 = var5_0[var3_102]

		for iter4_102, iter5_102 in pairs(arg0_102.strengthList) do
			local var5_102 = ShipModAttr.ATTR_TO_INDEX[iter4_102]
			local var6_102 = math.min(iter5_102, var4_102.durability[var5_102] * var4_102.level_exp[var5_102])
			local var7_102 = math.max(arg0_102:getModExpRatio(iter4_102), 1)

			var0_102[iter4_102] = var0_102[iter4_102] + calcFloor(var6_102 / var7_102)
		end

		arg0_102:intimacyAdditions(var0_102)

		for iter6_102, iter7_102 in pairs(arg0_102.transforms) do
			local var8_102 = pg.transform_data_template[iter7_102.id].effect

			for iter8_102 = 1, iter7_102.level do
				local var9_102 = var8_102[iter8_102] or {}

				for iter9_102, iter10_102 in pairs(var0_102) do
					if var9_102[iter9_102] then
						var0_102[iter9_102] = var0_102[iter9_102] + var9_102[iter9_102]
					end
				end
			end
		end
	end

	return var0_102
end

function var0_0.getTechNationAddition(arg0_103, arg1_103)
	local var0_103 = getProxy(TechnologyNationProxy)
	local var1_103 = arg0_103:getConfig("type")

	if var1_103 == ShipType.DaoQuV or var1_103 == ShipType.DaoQuM then
		var1_103 = ShipType.QuZhu
	end

	return var0_103:getShipAddition(var1_103, arg1_103)
end

function var0_0.getTechNationMaxAddition(arg0_104, arg1_104)
	local var0_104 = getProxy(TechnologyNationProxy)
	local var1_104 = arg0_104:getConfig("type")

	return var0_104:getShipMaxAddition(var1_104, arg1_104)
end

function var0_0.getEquipProficiencyByPos(arg0_105, arg1_105)
	return arg0_105:getEquipProficiencyList()[arg1_105]
end

function var0_0.getEquipProficiencyList(arg0_106)
	local var0_106 = arg0_106:getConfigTable()
	local var1_106 = Clone(var0_106.equipment_proficiency)

	if arg0_106:isBluePrintShip() then
		local var2_106 = arg0_106:getBluePrint()

		assert(var2_106, "blueprint can not be nil >>>" .. arg0_106.groupId)

		var1_106 = var2_106:getEquipProficiencyList(arg0_106)
	else
		for iter0_106, iter1_106 in ipairs(var1_106) do
			local var3_106 = 0

			for iter2_106, iter3_106 in pairs(arg0_106.transforms) do
				local var4_106 = pg.transform_data_template[iter3_106.id].effect

				for iter4_106 = 1, iter3_106.level do
					local var5_106 = var4_106[iter4_106] or {}

					if var5_106["equipment_proficiency_" .. iter0_106] then
						var3_106 = var3_106 + var5_106["equipment_proficiency_" .. iter0_106]
					end
				end
			end

			var1_106[iter0_106] = iter1_106 + var3_106
		end
	end

	return var1_106
end

function var0_0.getBaseProperties(arg0_107)
	local var0_107 = arg0_107:getConfigTable()

	assert(var0_107, "配置表没有这艘船" .. arg0_107.configId)

	local var1_107 = {}
	local var2_107 = {}

	for iter0_107, iter1_107 in ipairs(var0_0.PROPERTIES) do
		var1_107[iter1_107] = arg0_107:getGrowthForAttr(iter1_107)
		var2_107[iter1_107] = var1_107[iter1_107]
	end

	for iter2_107, iter3_107 in ipairs(arg0_107:getConfig("lock")) do
		var2_107[iter3_107] = var1_107[iter3_107]
	end

	for iter4_107, iter5_107 in ipairs(var0_0.DIVE_PROPERTIES) do
		var2_107[iter5_107] = var0_107[iter5_107]
	end

	for iter6_107, iter7_107 in ipairs(var0_0.SONAR_PROPERTIES) do
		var2_107[iter7_107] = 0
	end

	return var2_107
end

function var0_0.getGrowthForAttr(arg0_108, arg1_108)
	local var0_108 = arg0_108:getConfigTable()
	local var1_108 = table.indexof(var0_0.PROPERTIES, arg1_108)
	local var2_108 = pg.gameset.extra_attr_level_limit.key_value
	local var3_108 = var0_108.attrs[var1_108] + (arg0_108.level - 1) * var0_108.attrs_growth[var1_108] / 1000

	if var2_108 < arg0_108.level then
		var3_108 = var3_108 + (arg0_108.level - var2_108) * var0_108.attrs_growth_extra[var1_108] / 1000
	end

	return var3_108
end

function var0_0.isMaxStar(arg0_109)
	return arg0_109:getStar() >= arg0_109:getMaxStar()
end

function var0_0.IsMaxStarByTmpID(arg0_110)
	local var0_110 = pg.ship_data_template[arg0_110]

	return var0_110.star >= var0_110.star_max
end

function var0_0.IsSpweaponUnlock(arg0_111)
	if not arg0_111:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0_0.getModProperties(arg0_112, arg1_112)
	return arg0_112.strengthList[arg1_112] or 0
end

function var0_0.addModAttrExp(arg0_113, arg1_113, arg2_113)
	local var0_113 = arg0_113:getModAttrTopLimit(arg1_113)

	if var0_113 == 0 then
		return
	end

	local var1_113 = arg0_113:getModExpRatio(arg1_113)
	local var2_113 = arg0_113:getModProperties(arg1_113)

	if var2_113 + arg2_113 > var0_113 * var1_113 then
		arg0_113.strengthList[arg1_113] = var0_113 * var1_113
	else
		arg0_113.strengthList[arg1_113] = var2_113 + arg2_113
	end
end

function var0_0.getNeedModExp(arg0_114)
	local var0_114 = {}

	for iter0_114, iter1_114 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1_114 = arg0_114:getModAttrTopLimit(iter1_114)

		if var1_114 == 0 then
			var0_114[iter1_114] = 0
		else
			var0_114[iter1_114] = var1_114 * arg0_114:getModExpRatio(iter1_114) - arg0_114:getModProperties(iter1_114)
		end
	end

	return var0_114
end

function var0_0.attrVertify(arg0_115)
	if not BayProxy.checkShiplevelVertify(arg0_115) then
		return false
	end

	for iter0_115, iter1_115 in ipairs(arg0_115.equipments) do
		if iter1_115 and not iter1_115:vertify() then
			return false
		end
	end

	return true
end

function var0_0.getEquipmentProperties(arg0_116)
	local var0_116 = {}
	local var1_116 = {}

	for iter0_116, iter1_116 in ipairs(var0_0.PROPERTIES) do
		var0_116[iter1_116] = 0
	end

	for iter2_116, iter3_116 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_116[iter3_116] = 0
	end

	for iter4_116, iter5_116 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_116[iter5_116] = 0
	end

	for iter6_116, iter7_116 in ipairs(var0_0.PROPERTIES_ENHANCEMENT) do
		var1_116[iter7_116] = 0
	end

	var0_116[AttributeType.AirDominate] = 0
	var0_116[AttributeType.AntiSiren] = 0

	local var2_116 = arg0_116:getActiveEquipments()

	for iter8_116, iter9_116 in ipairs(var2_116) do
		if iter9_116 then
			local var3_116 = iter9_116:GetAttributes()

			for iter10_116, iter11_116 in ipairs(var3_116) do
				if iter11_116 and var0_116[iter11_116.type] then
					var0_116[iter11_116.type] = var0_116[iter11_116.type] + iter11_116.value
				end
			end

			local var4_116 = iter9_116:GetPropertyRate()

			for iter12_116, iter13_116 in pairs(var4_116) do
				var1_116[iter12_116] = math.max(var1_116[iter12_116], iter13_116)
			end

			local var5_116 = iter9_116:GetSonarProperty()

			if var5_116 then
				for iter14_116, iter15_116 in pairs(var5_116) do
					var0_116[iter14_116] = var0_116[iter14_116] + iter15_116
				end
			end

			local var6_116 = iter9_116:GetAntiSirenPower()

			if var6_116 then
				var0_116[AttributeType.AntiSiren] = var0_116[AttributeType.AntiSiren] + var6_116 / 10000
			end
		end
	end

	;(function()
		local var0_117 = arg0_116:GetSpWeapon()

		if not var0_117 then
			return
		end

		local var1_117 = var0_117:GetPropertiesInfo().attrs

		for iter0_117, iter1_117 in ipairs(var1_117) do
			if iter1_117 and var0_116[iter1_117.type] then
				var0_116[iter1_117.type] = var0_116[iter1_117.type] + iter1_117.value
			end
		end
	end)()

	for iter16_116, iter17_116 in pairs(var1_116) do
		var1_116[iter16_116] = iter17_116 + 1
	end

	return var0_116, var1_116
end

function var0_0.getSkillEffects(arg0_118)
	local var0_118 = arg0_118:getShipSkillEffects()

	_.each(arg0_118:getEquipmentSkillEffects(), function(arg0_119)
		table.insert(var0_118, arg0_119)
	end)

	return var0_118
end

function var0_0.getShipSkillEffects(arg0_120)
	local var0_120 = {}
	local var1_120 = arg0_120:getSkillList()

	for iter0_120, iter1_120 in ipairs(var1_120) do
		local var2_120 = arg0_120:RemapSkillId(iter1_120, true)
		local var3_120 = pg.buffCfg["buff_" .. var2_120]

		arg0_120:FilterActiveSkill(var0_120, var3_120, arg0_120.skills[iter1_120])
	end

	return var0_120
end

function var0_0.getEquipmentSkillEffects(arg0_121)
	local var0_121 = {}
	local var1_121 = arg0_121:getActiveEquipments()

	for iter0_121, iter1_121 in ipairs(var1_121) do
		local var2_121
		local var3_121 = iter1_121 and iter1_121:getConfig("skill_id")[1] and iter1_121:getConfig("skill_id")[1][1]

		if var3_121 then
			var2_121 = pg.buffCfg["buff_" .. var3_121]
		end

		arg0_121:FilterActiveSkill(var0_121, var2_121)
	end

	;(function()
		local var0_122 = arg0_121:GetSpWeapon()
		local var1_122 = var0_122 and var0_122:GetEffect() or 0
		local var2_122

		if var1_122 > 0 then
			var2_122 = pg.buffCfg["buff_" .. var1_122]
		end

		arg0_121:FilterActiveSkill(var0_121, var2_122)
	end)()

	return var0_121
end

function var0_0.FilterActiveSkill(arg0_123, arg1_123, arg2_123, arg3_123)
	if not arg2_123 or not arg2_123.const_effect_list then
		return
	end

	for iter0_123 = 1, #arg2_123.const_effect_list do
		local var0_123 = arg2_123.const_effect_list[iter0_123]
		local var1_123 = var0_123.trigger
		local var2_123 = var0_123.arg_list
		local var3_123 = 1

		if arg3_123 then
			var3_123 = arg3_123.level

			local var4_123 = arg2_123[var3_123].const_effect_list

			if var4_123 and var4_123[iter0_123] then
				var1_123 = var4_123[iter0_123].trigger or var1_123
				var2_123 = var4_123[iter0_123].arg_list or var2_123
			end
		end

		local var5_123 = true

		for iter1_123, iter2_123 in pairs(var1_123) do
			if arg0_123.triggers[iter1_123] ~= iter2_123 then
				var5_123 = false

				break
			end
		end

		if var5_123 then
			table.insert(arg1_123, {
				type = var0_123.type,
				arg_list = var2_123,
				level = var3_123
			})
		end
	end
end

function var0_0.getEquipmentGearScore(arg0_124)
	local var0_124 = 0
	local var1_124 = arg0_124:getActiveEquipments()

	for iter0_124, iter1_124 in ipairs(var1_124) do
		if iter1_124 then
			var0_124 = var0_124 + iter1_124:GetGearScore()
		end
	end

	return var0_124
end

function var0_0.getProperties(arg0_125, arg1_125, arg2_125, arg3_125, arg4_125)
	local var0_125 = arg1_125 or {}
	local var1_125 = arg0_125:getConfig("nationality")
	local var2_125 = arg0_125:getConfig("type")
	local var3_125 = arg0_125:getShipProperties()
	local var4_125, var5_125 = arg0_125:getEquipmentProperties()
	local var6_125
	local var7_125
	local var8_125

	if arg3_125 and arg0_125:getFlag("inWorld") then
		local var9_125 = WorldConst.FetchWorldShip(arg0_125.id)

		var6_125, var7_125 = var9_125:GetShipBuffProperties()
		var8_125 = var9_125:GetShipPowerBuffProperties()
	end

	for iter0_125, iter1_125 in ipairs(var0_0.PROPERTIES) do
		local var10_125 = 0
		local var11_125 = 0

		for iter2_125, iter3_125 in pairs(var0_125) do
			var10_125 = var10_125 + iter3_125:getAttrRatioAddition(iter1_125, var1_125, var2_125) / 100
			var11_125 = var11_125 + iter3_125:getAttrValueAddition(iter1_125, var1_125, var2_125)
		end

		local var12_125 = var10_125 + (var5_125[iter1_125] or 1)
		local var13_125 = var7_125 and var7_125[iter1_125] or 1
		local var14_125 = var6_125 and var6_125[iter1_125] or 0

		if iter1_125 == AttributeType.Speed then
			var3_125[iter1_125] = var3_125[iter1_125] * var12_125 * var13_125 + var11_125 + var4_125[iter1_125] + var14_125
		else
			var3_125[iter1_125] = calcFloor(calcFloor(var3_125[iter1_125]) * var12_125 * var13_125) + var11_125 + var4_125[iter1_125] + var14_125
		end
	end

	if not arg2_125 and arg0_125:isMaxStar() then
		for iter4_125, iter5_125 in pairs(var3_125) do
			local var15_125 = arg4_125 and arg0_125:getTechNationMaxAddition(iter4_125) or arg0_125:getTechNationAddition(iter4_125)

			var3_125[iter4_125] = var3_125[iter4_125] + var15_125
		end
	end

	for iter6_125, iter7_125 in ipairs(var0_0.DIVE_PROPERTIES) do
		var3_125[iter7_125] = var3_125[iter7_125] + var4_125[iter7_125]
	end

	for iter8_125, iter9_125 in ipairs(var0_0.SONAR_PROPERTIES) do
		var3_125[iter9_125] = var3_125[iter9_125] + var4_125[iter9_125]
	end

	if arg3_125 then
		var3_125[AttributeType.AntiSiren] = (var3_125[AttributeType.AntiSiren] or 0) + var4_125[AttributeType.AntiSiren]
	end

	if var8_125 then
		for iter10_125, iter11_125 in pairs(var8_125) do
			if var3_125[iter10_125] then
				if iter10_125 == AttributeType.Speed then
					var3_125[iter10_125] = var3_125[iter10_125] * iter11_125
				else
					var3_125[iter10_125] = math.floor(var3_125[iter10_125] * iter11_125)
				end
			end
		end
	end

	return var3_125
end

function var0_0.getTransGearScore(arg0_126)
	local var0_126 = 0
	local var1_126 = pg.transform_data_template

	for iter0_126, iter1_126 in pairs(arg0_126.transforms) do
		for iter2_126 = 1, iter1_126.level do
			var0_126 = var0_126 + (var1_126[iter1_126.id].gear_score[iter2_126] or 0)
		end
	end

	return var0_126
end

function var0_0.getShipCombatPower(arg0_127, arg1_127)
	local var0_127 = arg0_127:getProperties(arg1_127, nil, nil, true)
	local var1_127 = var0_127[AttributeType.Durability] / 5 + var0_127[AttributeType.Cannon] + var0_127[AttributeType.Torpedo] + var0_127[AttributeType.AntiAircraft] + var0_127[AttributeType.Air] + var0_127[AttributeType.AntiSub] + var0_127[AttributeType.Reload] + var0_127[AttributeType.Hit] * 2 + var0_127[AttributeType.Dodge] * 2 + var0_127[AttributeType.Speed] + arg0_127:getEquipmentGearScore() + arg0_127:getTransGearScore()

	return math.floor(var1_127)
end

function var0_0.cosumeEnergy(arg0_128, arg1_128)
	arg0_128:setEnergy(math.max(arg0_128:getEnergy() - arg1_128, 0))
end

function var0_0.addEnergy(arg0_129, arg1_129)
	arg0_129:setEnergy(arg0_129:getEnergy() + arg1_129)
end

function var0_0.setEnergy(arg0_130, arg1_130)
	arg0_130.energy = arg1_130
end

function var0_0.setLikability(arg0_131, arg1_131)
	assert(arg1_131 >= 0 and arg1_131 <= arg0_131.maxIntimacy, "intimacy value invaild" .. arg1_131)
	arg0_131:setIntimacy(arg1_131)
end

function var0_0.addLikability(arg0_132, arg1_132)
	local var0_132 = Mathf.Clamp(arg0_132:getIntimacy() + arg1_132, 0, arg0_132.maxIntimacy)

	arg0_132:setIntimacy(var0_132)
end

function var0_0.setIntimacy(arg0_133, arg1_133)
	if arg1_133 > 10000 and not arg0_133.propose then
		arg1_133 = 10000
	end

	arg0_133.intimacy = arg1_133

	if not arg0_133:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0_133.groupId]:updateMaxIntimacy(arg0_133:getIntimacy())
	end
end

function var0_0.getLevelExpConfig(arg0_134, arg1_134)
	if arg0_134:getConfig("rarity") == ShipRarity.SSR then
		local var0_134 = Clone(getConfigFromLevel1(var6_0, arg1_134 or arg0_134.level))

		var0_134.exp = var0_134.exp_ur
		var0_134.exp_start = var0_134.exp_ur_start
		var0_134.exp_interval = var0_134.exp_ur_interval
		var0_134.exp_end = var0_134.exp_ur_end

		return var0_134
	else
		return getConfigFromLevel1(var6_0, arg1_134 or arg0_134.level)
	end
end

function var0_0.getExp(arg0_135)
	local var0_135 = arg0_135:getMaxLevel()

	if arg0_135.level == var0_135 and LOCK_FULL_EXP then
		return 0
	end

	return arg0_135.exp
end

function var0_0.getProficiency(arg0_136)
	return arg0_136.proficiency
end

function var0_0.addExp(arg0_137, arg1_137, arg2_137)
	local var0_137 = arg0_137:getMaxLevel()

	if arg0_137.level == var0_137 then
		if arg0_137.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2_137 or not arg0_137:CanAccumulateExp() then
			arg1_137 = 0
		end
	end

	arg0_137.exp = arg0_137.exp + arg1_137

	local var1_137 = false

	while arg0_137:canLevelUp() do
		arg0_137.exp = arg0_137.exp - arg0_137:getLevelExpConfig().exp_interval
		arg0_137.level = math.min(arg0_137.level + 1, var0_137)
		var1_137 = true
	end

	if arg0_137.level == var0_137 then
		if arg2_137 and arg0_137:CanAccumulateExp() then
			arg0_137.exp = math.min(arg0_137.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1_137 then
			arg0_137.exp = 0
		end
	end
end

function var0_0.getMaxLevel(arg0_138)
	return arg0_138.maxLevel
end

function var0_0.canLevelUp(arg0_139)
	local var0_139 = arg0_139:getLevelExpConfig(arg0_139.level + 1)
	local var1_139 = arg0_139:getMaxLevel() <= arg0_139.level

	return var0_139 and arg0_139:getLevelExpConfig().exp_interval <= arg0_139.exp and not var1_139
end

function var0_0.getConfigMaxLevel(arg0_140)
	return var6_0.all[#var6_0.all]
end

function var0_0.isConfigMaxLevel(arg0_141)
	return arg0_141.level == arg0_141:getConfigMaxLevel()
end

function var0_0.updateMaxLevel(arg0_142, arg1_142)
	local var0_142 = arg0_142:getConfigMaxLevel()

	arg0_142.maxLevel = math.max(math.min(var0_142, arg1_142), arg0_142.maxLevel)
end

function var0_0.getNextMaxLevel(arg0_143)
	local var0_143 = arg0_143:getConfigMaxLevel()

	for iter0_143 = arg0_143:getMaxLevel() + 1, var0_143 do
		if var6_0[iter0_143].level_limit == 1 then
			return iter0_143
		end
	end
end

function var0_0.canUpgrade(arg0_144)
	if arg0_144:isBluePrintShip() then
		return false
	end

	if arg0_144:isMetaShip() then
		local var0_144 = arg0_144:getMetaCharacter()

		if not var0_144 then
			return false
		end

		local var1_144 = var0_144:getBreakOutInfo()

		if not var1_144:hasNextInfo() then
			return false
		end

		local var2_144, var3_144 = var1_144:getLimited()

		if var2_144 > arg0_144.level then
			return false
		end

		return true
	else
		local var4_144 = var8_0[arg0_144.configId]

		assert(var4_144, "不存在配置" .. arg0_144.configId)

		return not arg0_144:isMaxStar() and arg0_144.level >= var4_144.level
	end
end

function var0_0.isReachNextMaxLevel(arg0_145)
	return arg0_145.level == arg0_145:getMaxLevel() and arg0_145:CanAccumulateExp() and arg0_145:getNextMaxLevel() ~= nil
end

function var0_0.isAwakening(arg0_146)
	return arg0_146:isReachNextMaxLevel() and arg0_146.level < var4_0
end

function var0_0.isAwakening2(arg0_147)
	return arg0_147:isReachNextMaxLevel() and arg0_147.level >= var4_0
end

function var0_0.notMaxLevelForFilter(arg0_148)
	return arg0_148.level ~= arg0_148:getMaxLevel()
end

function var0_0.getNextMaxLevelConsume(arg0_149)
	local var0_149 = arg0_149:getMaxLevel()
	local var1_149 = var6_0[var0_149]["need_item_rarity" .. arg0_149:getConfig("rarity")]

	assert(var1_149, "items  can not be nil")

	return _.map(var1_149, function(arg0_150)
		return {
			type = arg0_150[1],
			id = arg0_150[2],
			count = arg0_150[3]
		}
	end)
end

function var0_0.canUpgradeMaxLevel(arg0_151)
	if not arg0_151:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0_151 = getProxy(PlayerProxy):getData()
		local var1_151 = getProxy(BagProxy)
		local var2_151 = arg0_151:getNextMaxLevelConsume()

		for iter0_151, iter1_151 in pairs(var2_151) do
			if iter1_151.type == DROP_TYPE_RESOURCE then
				if var0_151:getResById(iter1_151.id) < iter1_151.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1_151.type == DROP_TYPE_ITEM and var1_151:getItemCountById(iter1_151.id) < iter1_151.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.CanAccumulateExp(arg0_152)
	return pg.ship_data_template[arg0_152.configId].can_get_proficency == 1
end

function var0_0.getTotalExp(arg0_153)
	return arg0_153:getLevelExpConfig().exp_start + arg0_153.exp
end

function var0_0.getStartBattleExpend(arg0_154)
	if table.contains(ShipType.SubShipType, arg0_154:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0_154.configId].oil_at_start
	end
end

function var0_0.getEndBattleExpend(arg0_155)
	local var0_155 = pg.ship_data_template[arg0_155.configId]
	local var1_155 = arg0_155:getLevelExpConfig()

	return (math.floor(var0_155.oil_at_end * var1_155.fight_oil_ratio / 10000))
end

function var0_0.getBattleTotalExpend(arg0_156)
	return arg0_156:getStartBattleExpend() + arg0_156:getEndBattleExpend()
end

function var0_0.getShipAmmo(arg0_157)
	local var0_157 = arg0_157:getConfig(AttributeType.Ammo)

	for iter0_157, iter1_157 in pairs(arg0_157:getAllSkills()) do
		local var1_157 = tonumber(iter0_157 .. string.format("%.2d", iter1_157.level))
		local var2_157 = pg.skill_benefit_template[var1_157]

		if var2_157 and arg0_157:IsBenefitSkillActive(var2_157) and (var2_157.type == var0_0.BENEFIT_EQUIP or var2_157.type == var0_0.BENEFIT_SKILL) then
			var0_157 = var0_157 + defaultValue(var2_157.effect[1], 0)
		end
	end

	local var3_157 = arg0_157:getActiveEquipments()

	for iter2_157, iter3_157 in ipairs(var3_157) do
		local var4_157 = iter3_157 and iter3_157:getConfig("equip_parameters").ammo

		if var4_157 then
			var0_157 = var0_157 + var4_157
		end
	end

	return var0_157
end

function var0_0.getHuntingLv(arg0_158)
	local var0_158 = arg0_158:getConfig("huntingrange_level")

	for iter0_158, iter1_158 in pairs(arg0_158:getAllSkills()) do
		local var1_158 = tonumber(iter0_158 .. string.format("%.2d", iter1_158.level))
		local var2_158 = pg.skill_benefit_template[var1_158]

		if var2_158 and arg0_158:IsBenefitSkillActive(var2_158) and (var2_158.type == var0_0.BENEFIT_EQUIP or var2_158.type == var0_0.BENEFIT_SKILL) then
			var0_158 = var0_158 + defaultValue(var2_158.effect[2], 0)
		end
	end

	local var3_158 = arg0_158:getActiveEquipments()

	for iter2_158, iter3_158 in ipairs(var3_158) do
		local var4_158 = iter3_158 and iter3_158:getConfig("equip_parameters").hunting_lv

		if var4_158 then
			var0_158 = var0_158 + var4_158
		end
	end

	return (math.min(var0_158, arg0_158:getMaxHuntingLv()))
end

function var0_0.getMapAuras(arg0_159)
	local var0_159 = {}

	for iter0_159, iter1_159 in pairs(arg0_159:getAllSkills()) do
		local var1_159 = tonumber(iter0_159 .. string.format("%.2d", iter1_159.level))
		local var2_159 = pg.skill_benefit_template[var1_159]

		if var2_159 and arg0_159:IsBenefitSkillActive(var2_159) and var2_159.type == var0_0.BENEFIT_MAP_AURA then
			local var3_159 = {
				id = var2_159.effect[1],
				level = iter1_159.level
			}

			table.insert(var0_159, var3_159)
		end
	end

	return var0_159
end

function var0_0.getMapAids(arg0_160)
	local var0_160 = {}

	for iter0_160, iter1_160 in pairs(arg0_160:getAllSkills()) do
		local var1_160 = tonumber(iter0_160 .. string.format("%.2d", iter1_160.level))
		local var2_160 = pg.skill_benefit_template[var1_160]

		if var2_160 and arg0_160:IsBenefitSkillActive(var2_160) and var2_160.type == var0_0.BENEFIT_AID then
			local var3_160 = {
				id = var2_160.effect[1],
				level = iter1_160.level
			}

			table.insert(var0_160, var3_160)
		end
	end

	return var0_160
end

var0_0.BENEFIT_SKILL = 2
var0_0.BENEFIT_EQUIP = 3
var0_0.BENEFIT_MAP_AURA = 4
var0_0.BENEFIT_AID = 5

function var0_0.IsBenefitSkillActive(arg0_161, arg1_161)
	local var0_161 = false

	if arg1_161.type == var0_0.BENEFIT_SKILL then
		if not arg1_161.limit[1] or arg1_161.limit[1] == arg0_161.triggers.TeamNumbers then
			var0_161 = true
		end
	elseif arg1_161.type == var0_0.BENEFIT_EQUIP then
		local var1_161 = arg1_161.limit
		local var2_161 = arg0_161:getAllEquipments()

		for iter0_161, iter1_161 in ipairs(var2_161) do
			if iter1_161 and table.contains(var1_161, iter1_161:getConfig("id")) then
				var0_161 = true

				break
			end
		end
	elseif arg1_161.type == var0_0.BENEFIT_MAP_AURA then
		if arg0_161.hpRant and arg0_161.hpRant > 0 then
			return true
		end
	elseif arg1_161.type == var0_0.BENEFIT_AID and arg0_161.hpRant and arg0_161.hpRant > 0 then
		return true
	end

	return var0_161
end

function var0_0.getMaxHuntingLv(arg0_162)
	return #arg0_162:getConfig("hunting_range")
end

function var0_0.getHuntingRange(arg0_163, arg1_163)
	local var0_163 = arg0_163:getConfig("hunting_range")
	local var1_163 = Clone(var0_163[1])
	local var2_163 = arg1_163 or arg0_163:getHuntingLv()
	local var3_163 = math.min(var2_163, arg0_163:getMaxHuntingLv())

	for iter0_163 = 2, var3_163 do
		_.each(var0_163[iter0_163], function(arg0_164)
			table.insert(var1_163, {
				arg0_164[1],
				arg0_164[2]
			})
		end)
	end

	return var1_163
end

function var0_0.getTriggerSkills(arg0_165)
	local var0_165 = {}
	local var1_165 = arg0_165:getSkillEffects()

	_.each(var1_165, function(arg0_166)
		if arg0_166.type == "AddBuff" and arg0_166.arg_list and arg0_166.arg_list.buff_id then
			local var0_166 = arg0_166.arg_list.buff_id

			var0_165[var0_166] = {
				id = var0_166,
				level = arg0_166.level
			}
		end
	end)

	return var0_165
end

function var0_0.GetEquipmentSkills(arg0_167)
	local var0_167 = {}
	local var1_167 = arg0_167:getActiveEquipments()

	for iter0_167, iter1_167 in ipairs(var1_167) do
		if iter1_167 and iter1_167:getConfig("skill_id")[1] then
			local var2_167, var3_167 = unpack(iter1_167:getConfig("skill_id")[1])

			var0_167[var2_167] = {
				id = var2_167,
				level = var3_167
			}
		end
	end

	;(function()
		local var0_168 = arg0_167:GetSpWeapon()
		local var1_168 = var0_168 and var0_168:GetEffect() or 0

		if var1_168 > 0 then
			var0_167[var1_168] = {
				level = 1,
				id = var1_168
			}
		end
	end)()

	return var0_167
end

function var0_0.getAllSkills(arg0_169)
	local var0_169 = Clone(arg0_169.skills)

	for iter0_169, iter1_169 in pairs(arg0_169:GetEquipmentSkills()) do
		var0_169[iter0_169] = iter1_169
	end

	for iter2_169, iter3_169 in pairs(arg0_169:getTriggerSkills()) do
		var0_169[iter2_169] = iter3_169
	end

	return var0_169
end

function var0_0.isSameKind(arg0_170, arg1_170)
	return pg.ship_data_template[arg0_170.configId].group_type == pg.ship_data_template[arg1_170.configId].group_type
end

function var0_0.GetLockState(arg0_171)
	return arg0_171.lockState
end

function var0_0.IsLocked(arg0_172)
	return arg0_172.lockState == var0_0.LOCK_STATE_LOCK
end

function var0_0.SetLockState(arg0_173, arg1_173)
	arg0_173.lockState = arg1_173
end

function var0_0.GetPreferenceTag(arg0_174)
	return arg0_174.preferenceTag or 0
end

function var0_0.IsPreferenceTag(arg0_175)
	return arg0_175:GetPreferenceTag() == var0_0.PREFERENCE_TAG_COMMON
end

function var0_0.SetPreferenceTag(arg0_176, arg1_176)
	arg0_176.preferenceTag = arg1_176
end

function var0_0.calReturnRes(arg0_177)
	local var0_177 = pg.ship_data_by_type[arg0_177:getShipType()]
	local var1_177 = var0_177.distory_resource_gold_ratio
	local var2_177 = var0_177.distory_resource_oil_ratio
	local var3_177 = pg.ship_data_by_star[arg0_177:getConfig("rarity")].destory_item

	return var1_177, 0, var3_177
end

function var0_0.getRarity(arg0_178)
	local var0_178 = arg0_178:getConfig("rarity")

	if arg0_178:isRemoulded() then
		var0_178 = var0_178 + 1
	end

	return var0_178
end

function var0_0.updateSkill(arg0_179, arg1_179)
	local var0_179 = arg1_179.skill_id or arg1_179.id
	local var1_179 = arg1_179.skill_lv or arg1_179.lv or arg1_179.level
	local var2_179 = arg1_179.skill_exp or arg1_179.exp

	arg0_179.skills[var0_179] = {
		id = var0_179,
		level = var1_179,
		exp = var2_179
	}
end

function var0_0.canEquipAtPos(arg0_180, arg1_180, arg2_180)
	local var0_180, var1_180 = arg0_180:isForbiddenAtPos(arg1_180, arg2_180)

	if var0_180 then
		return false, var1_180
	end

	for iter0_180, iter1_180 in ipairs(arg0_180.equipments) do
		if iter1_180 and iter0_180 ~= arg2_180 and iter1_180:getConfig("equip_limit") ~= 0 and arg1_180:getConfig("equip_limit") == iter1_180:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0_0.isForbiddenAtPos(arg0_181, arg1_181, arg2_181)
	local var0_181 = pg.ship_data_template[arg0_181.configId]

	assert(var0_181, "can not find ship in ship_data_templtae: " .. arg0_181.configId)

	local var1_181 = var0_181["equip_" .. arg2_181]

	if not table.contains(var1_181, arg1_181:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1_181:getConfig("ship_type_forbidden"), arg0_181:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0_0.canEquipCommander(arg0_182, arg1_182)
	if arg1_182:getShipType() ~= arg0_182:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0_0.upgrade(arg0_183)
	local var0_183 = pg.ship_data_transform[arg0_183.configId]

	if var0_183.trans_id and var0_183.trans_id > 0 then
		arg0_183.configId = var0_183.trans_id
		arg0_183.star = arg0_183:getConfig("star")
	end
end

function var0_0.getTeamType(arg0_184)
	return ShipType.GetTeamFromShipType(arg0_184:getShipType())
end

function var0_0.getFleetName(arg0_185)
	local var0_185 = arg0_185:getTeamType()

	return var1_0[var0_185]
end

function var0_0.getMaxConfigId(arg0_186)
	local var0_186 = pg.ship_data_template
	local var1_186

	for iter0_186 = 4, 1, -1 do
		local var2_186 = tonumber(arg0_186.groupId .. iter0_186)

		if var0_186[var2_186] then
			var1_186 = var2_186

			break
		end
	end

	return var1_186
end

function var0_0.getFlag(arg0_187, arg1_187, arg2_187)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_187.id, arg1_187, arg2_187)
end

function var0_0.hasAnyFlag(arg0_188, arg1_188)
	return _.any(arg1_188, function(arg0_189)
		return arg0_188:getFlag(arg0_189)
	end)
end

function var0_0.isBreakOut(arg0_190)
	return arg0_190.configId % 10 > 1
end

function var0_0.fateSkillChange(arg0_191, arg1_191)
	if not arg0_191.skillChangeList then
		arg0_191.skillChangeList = arg0_191:isBluePrintShip() and arg0_191:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_191, iter1_191 in ipairs(arg0_191.skillChangeList) do
		if iter1_191[1] == arg1_191 and arg0_191.skills[iter1_191[2]] then
			return iter1_191[2]
		end
	end

	return arg1_191
end

function var0_0.RemapSkillId(arg0_192, arg1_192, arg2_192)
	local var0_192 = arg0_192:GetSpWeapon()

	if var0_192 then
		if table.contains(pg.ship_data_template[arg0_192.configId].hide_buff_list, arg1_192) then
			return var0_192:RemapHiddenSkillId(arg1_192)
		elseif arg2_192 then
			local var1_192 = var0_192:RemapHiddenSkillId(arg1_192)

			if var1_192 == arg1_192 then
				var1_192 = var0_192:RemapSkillId(arg1_192)
			end

			return var1_192
		else
			return var0_192:RemapSkillId(arg1_192)
		end
	end

	return arg1_192
end

function var0_0.getSkillList(arg0_193)
	local var0_193 = pg.ship_data_template[arg0_193.configId]
	local var1_193 = Clone(var0_193.buff_list_display)
	local var2_193 = Clone(var0_193.buff_list)
	local var3_193 = pg.ship_data_trans[arg0_193.groupId]
	local var4_193 = 0

	if var3_193 and var3_193.skill_id ~= 0 then
		local var5_193 = var3_193.skill_id
		local var6_193 = pg.transform_data_template[var5_193]

		if arg0_193.transforms[var5_193] and var6_193.skill_id ~= 0 then
			table.insert(var2_193, var6_193.skill_id)
		end
	end

	local var7_193 = {}

	for iter0_193, iter1_193 in ipairs(var1_193) do
		for iter2_193, iter3_193 in ipairs(var2_193) do
			if iter1_193 == iter3_193 then
				table.insert(var7_193, arg0_193:fateSkillChange(iter1_193))
			end
		end
	end

	return var7_193
end

function var0_0.getModAttrTopLimit(arg0_194, arg1_194)
	local var0_194 = ShipModAttr.ATTR_TO_INDEX[arg1_194]
	local var1_194 = pg.ship_data_template[arg0_194.configId].strengthen_id
	local var2_194 = pg.ship_data_strengthen[var1_194].durability[var0_194]

	return calcFloor((3 + 7 * (math.min(arg0_194.level, 100) / 100)) * var2_194 * 0.1)
end

function var0_0.leftModAdditionPoint(arg0_195, arg1_195)
	local var0_195 = arg0_195:getModProperties(arg1_195)
	local var1_195 = arg0_195:getModExpRatio(arg1_195)
	local var2_195 = arg0_195:getModAttrTopLimit(arg1_195)
	local var3_195 = calcFloor(var0_195 / var1_195)

	return math.max(0, var2_195 - var3_195)
end

function var0_0.getModAttrBaseMax(arg0_196, arg1_196)
	if not table.contains(arg0_196:getConfig("lock"), arg1_196) then
		local var0_196 = arg0_196:leftModAdditionPoint(arg1_196)
		local var1_196 = arg0_196:getShipProperties()

		return calcFloor(var1_196[arg1_196] + var0_196)
	else
		return 0
	end
end

function var0_0.getModExpRatio(arg0_197, arg1_197)
	if not table.contains(arg0_197:getConfig("lock"), arg1_197) then
		local var0_197 = pg.ship_data_template[arg0_197.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0_197], "ship_data_strengthen>>>>>>" .. var0_197)

		return math.max(pg.ship_data_strengthen[var0_197].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1_197]], 1)
	else
		return 1
	end
end

function var0_0.inUnlockTip(arg0_198)
	local var0_198 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0_198, arg0_198)
end

function var0_0.proposeSkinOwned(arg0_199, arg1_199)
	return arg1_199 and arg0_199.propose and arg1_199.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0_0.getProposeSkin(arg0_200)
	return ShipSkin.GetSkinByType(arg0_200.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getDisplaySkillIds(arg0_201)
	return _.map(pg.ship_data_template[arg0_201.configId].buff_list_display, function(arg0_202)
		return arg0_201:fateSkillChange(arg0_202)
	end)
end

function var0_0.isFullSkillLevel(arg0_203)
	local var0_203 = pg.skill_data_template

	for iter0_203, iter1_203 in pairs(arg0_203.skills) do
		if var0_203[iter1_203.id].max_level ~= iter1_203.level then
			return false
		end
	end

	return true
end

function var0_0.setEquipmentRecord(arg0_204, arg1_204, arg2_204)
	local var0_204 = "equipment_record" .. "_" .. arg1_204 .. "_" .. arg0_204.id

	PlayerPrefs.SetString(var0_204, table.concat(_.flatten(arg2_204), ":"))
	PlayerPrefs.Save()
end

function var0_0.getEquipmentRecord(arg0_205, arg1_205)
	if not arg0_205.equipmentRecords then
		local var0_205 = "equipment_record" .. "_" .. arg1_205 .. "_" .. arg0_205.id
		local var1_205 = string.split(PlayerPrefs.GetString(var0_205) or "", ":")
		local var2_205 = {}

		for iter0_205 = 1, 3 do
			var2_205[iter0_205] = _.map(_.slice(var1_205, 5 * iter0_205 - 4, 5), function(arg0_206)
				return tonumber(arg0_206)
			end)
		end

		arg0_205.equipmentRecords = var2_205
	end

	return arg0_205.equipmentRecords
end

function var0_0.SetSpWeaponRecord(arg0_207, arg1_207, arg2_207)
	local var0_207 = "spweapon_record" .. "_" .. arg1_207 .. "_" .. arg0_207.id
	local var1_207 = _.map({
		1,
		2,
		3
	}, function(arg0_208)
		local var0_208 = arg2_207[arg0_208]

		if var0_208 then
			return (var0_208:GetUID() or 0) .. "," .. var0_208:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0_207, table.concat(var1_207, ":"))
	PlayerPrefs.Save()
end

function var0_0.GetSpWeaponRecord(arg0_209, arg1_209)
	local var0_209 = "spweapon_record" .. "_" .. arg1_209 .. "_" .. arg0_209.id

	return (_.map(string.split(PlayerPrefs.GetString(var0_209, ""), ":"), function(arg0_210)
		local var0_210 = string.split(arg0_210, ",")

		assert(var0_210)

		local var1_210 = tonumber(var0_210[1])
		local var2_210 = tonumber(var0_210[2])

		if not var2_210 or var2_210 == 0 then
			return false
		end

		return (SpWeapon.New({
			id = var2_210
		}))
	end))
end

function var0_0.hasEquipEquipmentSkin(arg0_211)
	for iter0_211, iter1_211 in ipairs(arg0_211.equipments) do
		if iter1_211 and iter1_211:hasSkin() then
			return true
		end
	end

	return false
end

function var0_0.hasCommander(arg0_212)
	return arg0_212.commanderId and arg0_212.commanderId ~= 0
end

function var0_0.getCommander(arg0_213)
	return arg0_213.commanderId
end

function var0_0.setCommander(arg0_214, arg1_214)
	arg0_214.commanderId = arg1_214
end

function var0_0.getSkillIndex(arg0_215, arg1_215)
	local var0_215 = arg0_215:getSkillList()

	for iter0_215, iter1_215 in ipairs(var0_215) do
		if arg1_215 == iter1_215 then
			return iter0_215
		end
	end
end

function var0_0.getTactics(arg0_216)
	return 1, "tactics_attack"
end

function var0_0.IsBgmSkin(arg0_217)
	local var0_217 = arg0_217:GetSkinConfig()

	return table.contains(var0_217.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_218)
	if arg0_218:IsBgmSkin() then
		return arg0_218:GetSkinConfig().bgm
	end
end

function var0_0.isIntensifyMax(arg0_219)
	local var0_219 = intProperties(arg0_219:getShipProperties())

	if arg0_219:isBluePrintShip() then
		return true
	end

	for iter0_219, iter1_219 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_219:getModAttrBaseMax(iter1_219) ~= var0_219[iter1_219] then
			return false
		end
	end

	return true
end

function var0_0.isRemouldable(arg0_220)
	return not arg0_220:isTestShip() and not arg0_220:isBluePrintShip() and pg.ship_data_trans[arg0_220.groupId]
end

function var0_0.isAllRemouldFinish(arg0_221)
	local var0_221 = pg.ship_data_trans[arg0_221.groupId]

	assert(var0_221, "this ship group without remould config:" .. arg0_221.groupId)

	for iter0_221, iter1_221 in ipairs(var0_221.transform_list) do
		for iter2_221, iter3_221 in ipairs(iter1_221) do
			local var1_221 = pg.transform_data_template[iter3_221[2]]

			if #var1_221.edit_trans > 0 then
				-- block empty
			elseif not arg0_221.transforms[iter3_221[2]] or arg0_221.transforms[iter3_221[2]].level < var1_221.max_level then
				return false
			end
		end
	end

	return true
end

function var0_0.isSpecialFilter(arg0_222)
	local var0_222 = pg.ship_data_statistics[arg0_222.configId]

	assert(var0_222, "this ship without statistics:" .. arg0_222.configId)

	for iter0_222, iter1_222 in ipairs(var0_222.tag_list) do
		if iter1_222 == "special" then
			return true
		end
	end

	return false
end

function var0_0.hasAvailiableSkin(arg0_223)
	local var0_223 = getProxy(ShipSkinProxy)
	local var1_223 = var0_223:GetAllSkinForShip(arg0_223)
	local var2_223 = var0_223:getRawData()
	local var3_223 = 0

	for iter0_223, iter1_223 in ipairs(var1_223) do
		if arg0_223:proposeSkinOwned(iter1_223) or var2_223[iter1_223.id] or var0_223:hasSkin(iter1_223.id) then
			var3_223 = var3_223 + 1
		end
	end

	return var3_223 > 0
end

function var0_0.hasProposeSkin(arg0_224)
	local var0_224 = getProxy(ShipSkinProxy)
	local var1_224 = var0_224:GetAllSkinForShip(arg0_224)

	for iter0_224, iter1_224 in ipairs(var1_224) do
		if iter1_224.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2_224 = var0_224:GetShareSkinsForShip(arg0_224)

	for iter2_224, iter3_224 in ipairs(var2_224) do
		if iter3_224.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0_0.HasUniqueSpWeapon(arg0_225)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0_225:getGroupId()])
end

function var0_0.getAircraftReloadCD(arg0_226)
	local var0_226 = arg0_226:getConfigTable().base_list
	local var1_226 = arg0_226:getConfigTable().default_equip_list
	local var2_226 = 0
	local var3_226 = 0

	for iter0_226 = 1, 3 do
		local var4_226 = arg0_226:getEquip(iter0_226)
		local var5_226 = var4_226 and var4_226.configId or var1_226[iter0_226]
		local var6_226 = Equipment.getConfigData(var5_226).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0_227)
			return var6_226 == arg0_227
		end) then
			var2_226 = var2_226 + Equipment.GetEquipReloadStatic(var5_226) * var0_226[iter0_226]
			var3_226 = var3_226 + var0_226[iter0_226]
		end
	end

	local var7_226 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2_226 / var3_226 * var7_226
	}
end

function var0_0.IsTagShip(arg0_228, arg1_228)
	local var0_228 = arg0_228:getConfig("tag_list")

	return table.contains(var0_228, arg1_228)
end

function var0_0.setReMetaSpecialItemVO(arg0_229, arg1_229)
	arg0_229.reMetaSpecialItemVO = arg1_229
end

function var0_0.getReMetaSpecialItemVO(arg0_230, arg1_230)
	return arg0_230.reMetaSpecialItemVO
end

function var0_0.getProposeType(arg0_231)
	if arg0_231:isMetaShip() then
		return "meta"
	elseif arg0_231:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_232)
	return arg0_232:getNation() == Nation.IDOL_LINK
end

function var0_0.getSpecificType(arg0_233)
	return pg.ship_data_template[arg0_233.configId].specific_type
end

function var0_0.GetSpWeapon(arg0_234)
	return arg0_234.spWeapon
end

function var0_0.UpdateSpWeapon(arg0_235, arg1_235)
	local var0_235 = (arg1_235 and arg1_235:GetUID() or 0) == (arg0_235.spWeapon and arg0_235.spWeapon:GetUID() or 0)

	arg0_235.spWeapon = arg1_235

	if arg1_235 then
		arg1_235:SetShipId(arg0_235.id)
	end

	if var0_235 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0_0.CanEquipSpWeapon(arg0_236, arg1_236)
	local var0_236, var1_236 = arg0_236:IsSpWeaponForbidden(arg1_236)

	if var0_236 then
		return false, var1_236
	end

	return true
end

function var0_0.IsSpWeaponForbidden(arg0_237, arg1_237)
	local var0_237 = arg1_237:GetWearableShipTypes()
	local var1_237 = arg0_237:getShipType()

	if not table.contains(var0_237, var1_237) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2_237 = arg1_237:GetUniqueGroup()
	local var3_237 = arg0_237:getGroupId()

	if var2_237 ~= 0 and var2_237 ~= var3_237 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0_0.GetMapStrikeAnim(arg0_238)
	local var0_238
	local var1_238 = arg0_238:getShipType()

	switch(ShipType.GetTeamFromShipType(var1_238), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1_238) then
				var0_238 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1_238) then
				var0_238 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1_238) then
				var0_238 = "CannonUI"
			else
				var0_238 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1_238) then
				var0_238 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0_238:getNation() == Nation.MOT then
				var0_238 = "CannonUI"
			else
				var0_238 = "SubTorpedoUI"
			end
		end
	})

	return var0_238
end

function var0_0.IsDefaultSkin(arg0_242)
	local var0_242 = arg0_242:getSkinId()

	return var0_242 == 0 or var0_242 == arg0_242:getConfig("skin_id")
end

function var0_0.IsMatchKey(arg0_243, arg1_243)
	if not arg1_243 or arg1_243 == "" then
		return true
	end

	arg1_243 = string.lower(string.gsub(arg1_243, "%.", "%%."))

	local var0_243 = {
		arg0_243:getName(),
		arg0_243:GetDefaultName()
	}

	if var0_243[1] == var0_243[2] then
		table.remove(var0_243)
	end

	return underscore.any(var0_243, function(arg0_244)
		return string.find(string.lower(arg0_244), arg1_243)
	end)
end

function var0_0.IsOwner(arg0_245)
	return tobool(arg0_245.id)
end

function var0_0.GetUniqueId(arg0_246)
	return arg0_246.id
end

function var0_0.ShowPropose(arg0_247)
	if not arg0_247.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0_247:IsOwner() and arg0_247:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0_0.GetColorName(arg0_248, arg1_248)
	arg1_248 = arg1_248 or arg0_248:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0_248.propose then
		return setColorStr(arg1_248, "#FFAACEFF")
	else
		return arg1_248
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

function var0_0.GetFrameAndEffect(arg0_249, arg1_249)
	arg1_249 = tobool(arg1_249)

	local var0_249
	local var1_249

	if arg0_249.propose then
		if arg0_249:isMetaShip() then
			var1_249 = string.format(var9_0.effect[1])
			var0_249 = string.format(var9_0.frame[1])
		elseif arg0_249:isBluePrintShip() then
			var1_249 = string.format(var9_0.effect[2])
			var0_249 = string.format(var9_0.frame[2], arg0_249:rarity2bgPrint())
		else
			var1_249 = string.format(var9_0.effect[3])
			var0_249 = string.format(var9_0.frame[3])
		end

		if not arg0_249:ShowPropose() then
			var0_249 = nil
		end
	elseif arg0_249:isMetaShip() then
		var1_249 = string.format(var9_0.effect[4], arg0_249:rarity2bgPrint())
	elseif arg0_249:getRarity() == ShipRarity.SSR then
		var1_249 = string.format(var9_0.effect[5])
	end

	if arg1_249 then
		var1_249 = var1_249 and var1_249 .. "_1"
	end

	return var0_249, var1_249
end

function var0_0.GetRecordPosKey(arg0_250)
	return arg0_250:getSkinId()
end

function var0_0.GetShipPhantomMark(arg0_251, arg1_251)
	return ShipPhantom.PackMark(arg0_251.id, arg1_251)
end

function var0_0.GetSelectMark(arg0_252)
	return arg0_252.id
end

return var0_0
