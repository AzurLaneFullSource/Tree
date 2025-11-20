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
	local var1_40 = pg.intimacy_template

	for iter0_40, iter1_40 in pairs(var1_40) do
		if type(iter0_40) == "number" and arg0_40:getIntimacy() >= iter1_40.lower_bound and arg0_40:getIntimacy() <= iter1_40.upper_bound then
			var0_40 = iter0_40

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

	arg0_50.bluePrintFlag = arg1_50.blue_print_flag or 0
	arg0_50.strengthList = {}

	for iter0_50, iter1_50 in ipairs(arg1_50.strength_list or {}) do
		if not arg0_50:isBluePrintShip() then
			local var0_50 = ShipModAttr.ID_TO_ATTR[iter1_50.id]

			arg0_50.strengthList[var0_50] = iter1_50.exp
		else
			table.insert(arg0_50.strengthList, {
				level = iter1_50.id,
				exp = iter1_50.exp
			})
		end
	end

	local var1_50 = arg1_50.state or {}

	arg0_50.state = var1_50.state or 0
	arg0_50.state_info_1 = var1_50.state_info_1 or 0
	arg0_50.state_info_2 = var1_50.state_info_2 or 0
	arg0_50.state_info_3 = var1_50.state_info_3 or 0
	arg0_50.state_info_4 = var1_50.state_info_4 or 0
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

	arg0_50.groupId = pg.ship_data_template[arg0_50.configId].group_type
	arg0_50.createTime = arg1_50.create_time or 0

	local var2_50 = getProxy(CollectionProxy)

	arg0_50.virgin = var2_50 and var2_50.shipGroups[arg0_50.groupId] == nil

	local var3_50 = {
		pg.gameset.test_ship_config_1.key_value,
		pg.gameset.test_ship_config_2.key_value,
		pg.gameset.test_ship_config_3.key_value
	}
	local var4_50 = table.indexof(var3_50, arg0_50.configId)

	if var4_50 == 1 then
		arg0_50.testShip = {
			2,
			3,
			4
		}
	elseif var4_50 == 2 then
		arg0_50.testShip = {
			5
		}
	elseif var4_50 == 3 then
		arg0_50.testShip = {
			6
		}
	else
		arg0_50.testShip = nil
	end

	arg0_50.maxIntimacy = pg.intimacy_template[#pg.intimacy_template.all].upper_bound

	local var5_50 = 0

	if not HXSet.isHxSkin() then
		var5_50 = arg1_50.skin_id or 0
	end

	arg0_50.phantomDic = {}

	arg0_50:updateSkinId(var5_50, 0)

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
		local var6_50 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_50.configId)

		arg0_50.metaCharacter = MetaCharacter.New({
			id = var6_50,
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
	return arg0_58.bluePrintFlag == 1
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

function var0_0.getPhantomSkin(arg0_60, arg1_60)
	if not arg1_60 or arg1_60 == 0 then
		return arg0_60.skinId
	else
		return arg0_60.phantomDic[arg0_60.phantomId] or arg0_60:getConfig("skin_id")
	end
end

function var0_0.updateSkinId(arg0_61, arg1_61, arg2_61)
	if not arg1_61 or arg1_61 == 0 then
		arg1_61 = arg0_61:getConfig("skin_id")
	end

	if arg2_61 == 0 then
		arg0_61.skinId = arg1_61
	else
		arg0_61.phantomDic[arg2_61] = arg1_61
	end
end

function var0_0.getAllShipPhantomMarks(arg0_62)
	local var0_62 = getGameset("technology_shadow_num")[1]
	local var1_62 = {}

	for iter0_62 = 0, var0_62 do
		if iter0_62 == 0 or arg0_62.phantomDic[iter0_62] then
			table.insert(var1_62, ShipPhantom.PackMark(arg0_62.id, iter0_62))
		end
	end

	return var1_62
end

function var0_0.getAllShipPhantom(arg0_63)
	local var0_63 = getGameset("technology_shadow_num")[1]
	local var1_63 = {}

	for iter0_63 = 0, var0_63 do
		if iter0_63 == 0 or arg0_63.phantomDic[iter0_63] then
			table.insert(var1_63, ShipPhantom.Create(arg0_63, iter0_63))
		end
	end

	return var1_63
end

function var0_0.updateRandomFlag(arg0_64, arg1_64, arg2_64)
	arg2_64 = defaultValue(arg2_64, 0)
	arg0_64.phantomRandomFlag[arg2_64] = arg1_64
end

function var0_0.getRandomFlag(arg0_65, arg1_65)
	return defaultValue(arg0_65.phantomRandomFlag[arg1_65 or 0], 0) > 0
end

function var0_0.getRandomFlagShipPhantomMarks(arg0_66)
	local var0_66 = getGameset("technology_shadow_num")[1]
	local var1_66 = {}

	for iter0_66 = 0, var0_66 do
		if defaultValue(arg0_66.phantomRandomFlag[iter0_66], 0) > 0 then
			table.insert(var1_66, arg0_66:GetShipPhantomMark(iter0_66))
		end
	end

	return var1_66
end

function var0_0.updateName(arg0_67)
	if arg0_67.name ~= pg.ship_data_statistics[arg0_67.configId].name then
		return
	end

	if arg0_67:isRemoulded() then
		arg0_67.name = pg.ship_skin_template[arg0_67:getRemouldSkinId()].name
	else
		arg0_67.name = pg.ship_data_statistics[arg0_67.configId].name
	end
end

function var0_0.isRemoulded(arg0_68)
	if arg0_68.remoulded then
		return true
	end

	local var0_68 = pg.ship_data_trans[arg0_68.groupId]

	if var0_68 then
		for iter0_68, iter1_68 in ipairs(var0_68.transform_list) do
			for iter2_68, iter3_68 in ipairs(iter1_68) do
				local var1_68 = pg.transform_data_template[iter3_68[2]]

				if var1_68.skin_id ~= 0 and arg0_68.transforms[iter3_68[2]] and arg0_68.transforms[iter3_68[2]].level == var1_68.max_level then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.getRemouldSkinId(arg0_69)
	local var0_69 = ShipGroup.getModSkin(arg0_69.groupId)

	if var0_69 then
		return var0_69.id
	end

	return nil
end

function var0_0.hasEquipmentSkinInPos(arg0_70, arg1_70)
	local var0_70 = arg0_70.equipments[arg1_70]

	return var0_70 and var0_70:hasSkin()
end

function var0_0.getPrefab(arg0_71, arg1_71)
	local var0_71 = arg0_71:getSkinId()

	if arg0_71:hasEquipmentSkinInPos(var2_0) then
		local var1_71 = arg0_71:getEquip(var2_0)
		local var2_71 = var7_0[var1_71:getSkinId()].ship_skin_id

		var0_71 = var2_71 ~= 0 and var2_71 or var0_71
	end

	local var3_71 = pg.ship_skin_template[var0_71]

	assert(var3_71, "ship_skin_template not exist: " .. arg0_71.configId .. " " .. var0_71)

	if var3_71.double_char and var3_71.double_char == 1 and arg1_71 ~= nil then
		local var4_71

		if arg1_71 == 1 then
			return var3_71.prefab .. "_L"
		elseif arg1_71 == 2 then
			return var3_71.prefab .. "_R"
		end
	end

	return var3_71.prefab
end

function var0_0.IsDoubleSkin(arg0_72)
	local var0_72 = arg0_72:getSkinId()
	local var1_72 = pg.ship_skin_template[var0_72]

	assert(var1_72, "ship_skin_template not exist: " .. arg0_72.configId .. " " .. var0_72)

	return var1_72.double_char and var1_72.double_char == 1 or false
end

function var0_0.getAttachmentPrefab(arg0_73)
	local var0_73 = {}

	for iter0_73, iter1_73 in ipairs(arg0_73.equipments) do
		if iter1_73 and iter1_73:hasSkinOrbit() then
			local var1_73 = iter1_73:getSkinId()
			local var2_73 = var7_0[var1_73]

			var0_73[var1_73] = {
				config = var2_73,
				index = iter0_73
			}
		end
	end

	return var0_73
end

function var0_0.getPainting(arg0_74)
	local var0_74 = arg0_74:getSkinId()
	local var1_74 = pg.ship_skin_template[var0_74]

	assert(var1_74, "ship_skin_template not exist: " .. arg0_74.configId .. " " .. var0_74)

	return var1_74.painting
end

function var0_0.GetSkinConfig(arg0_75, arg1_75)
	local var0_75 = arg0_75:getSkinId()
	local var1_75 = pg.ship_skin_template[var0_75]

	assert(var1_75, "ship_skin_template not exist: " .. arg0_75.configId .. " " .. var0_75)

	return var1_75
end

function var0_0.getRemouldPainting(arg0_76)
	local var0_76 = arg0_76:getRemouldSkinId()
	local var1_76 = pg.ship_skin_template[var0_76]

	assert(var1_76, "ship_skin_template not exist: " .. arg0_76.configId .. " " .. var0_76)

	return var1_76.painting
end

function var0_0.updateStateInfo34(arg0_77, arg1_77, arg2_77)
	arg0_77.state_info_3 = arg1_77
	arg0_77.state_info_4 = arg2_77
end

function var0_0.hasStateInfo3Or4(arg0_78)
	return arg0_78.state_info_3 ~= 0 or arg0_78.state_info_4 ~= 0
end

function var0_0.isTestShip(arg0_79)
	return arg0_79.testShip
end

function var0_0.canUseTestShip(arg0_80, arg1_80)
	assert(arg0_80.testShip, "ship is not TestShip")

	return table.contains(arg0_80.testShip, arg1_80)
end

function var0_0.updateEquip(arg0_81, arg1_81, arg2_81)
	assert(arg2_81 == nil or arg2_81.count == 1)

	local var0_81 = arg0_81.equipments[arg1_81]

	arg0_81.equipments[arg1_81] = arg2_81 and Clone(arg2_81) or false

	local function var1_81(arg0_82)
		arg0_82 = CreateShell(arg0_82)
		arg0_82.shipId = arg0_81.id
		arg0_82.shipPos = arg1_81

		return arg0_82
	end

	if var0_81 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0_81, arg0_81.id, arg1_81)
		var0_81:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1_81(var0_81))
	end

	if arg2_81 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2_81, arg0_81.id, arg1_81)
		arg0_81:reletiveEquipSkin(arg1_81)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1_81(arg2_81))
	end
end

function var0_0.reletiveEquipSkin(arg0_83, arg1_83)
	if arg0_83.equipments[arg1_83] and arg0_83.equipmentSkins[arg1_83] ~= 0 then
		local var0_83 = pg.equip_skin_template[arg0_83.equipmentSkins[arg1_83]].equip_type
		local var1_83 = arg0_83.equipments[arg1_83]:getType()

		if table.contains(var0_83, var1_83) then
			arg0_83.equipments[arg1_83]:setSkinId(arg0_83.equipmentSkins[arg1_83])
		else
			arg0_83.equipments[arg1_83]:setSkinId(0)
		end
	elseif arg0_83.equipments[arg1_83] then
		arg0_83.equipments[arg1_83]:setSkinId(0)
	end
end

function var0_0.updateEquipmentSkin(arg0_84, arg1_84, arg2_84)
	if not arg1_84 then
		return
	end

	if arg2_84 and arg2_84 > 0 then
		local var0_84 = arg0_84:getSkinTypes(arg1_84)
		local var1_84 = pg.equip_skin_template[arg2_84].equip_type
		local var2_84 = false

		for iter0_84, iter1_84 in ipairs(var0_84) do
			for iter2_84, iter3_84 in ipairs(var1_84) do
				if iter1_84 == iter3_84 then
					var2_84 = true

					break
				end
			end
		end

		if not var2_84 then
			assert(var2_84, "部位" .. arg1_84 .. " 无法穿戴皮肤 " .. arg2_84)

			return
		end

		local var3_84 = arg0_84.equipments[arg1_84] and arg0_84.equipments[arg1_84]:getType() or false

		arg0_84.equipmentSkins[arg1_84] = arg2_84

		if var3_84 and table.contains(var1_84, var3_84) then
			arg0_84.equipments[arg1_84]:setSkinId(arg0_84.equipmentSkins[arg1_84])
		elseif var3_84 and not table.contains(var1_84, var3_84) then
			arg0_84.equipments[arg1_84]:setSkinId(0)
		end
	else
		arg0_84.equipmentSkins[arg1_84] = 0

		if arg0_84.equipments[arg1_84] then
			arg0_84.equipments[arg1_84]:setSkinId(0)
		end
	end
end

function var0_0.getEquip(arg0_85, arg1_85)
	return Clone(arg0_85.equipments[arg1_85])
end

function var0_0.getEquipSkins(arg0_86)
	return Clone(arg0_86.equipmentSkins)
end

function var0_0.getEquipSkin(arg0_87, arg1_87)
	return arg0_87.equipmentSkins[arg1_87]
end

function var0_0.getCanEquipSkin(arg0_88, arg1_88)
	local var0_88 = arg0_88:getSkinTypes(arg1_88)

	if var0_88 and #var0_88 then
		for iter0_88, iter1_88 in ipairs(var0_88) do
			if pg.equip_data_by_type[iter1_88].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0_0.checkCanEquipSkin(arg0_89, arg1_89, arg2_89)
	if not arg1_89 or not arg2_89 then
		return
	end

	local var0_89 = arg0_89:getSkinTypes(arg1_89)
	local var1_89 = pg.equip_skin_template[arg2_89].equip_type

	for iter0_89, iter1_89 in ipairs(var0_89) do
		if table.contains(var1_89, iter1_89) then
			return true
		end
	end

	return false
end

function var0_0.getSkinTypes(arg0_90, arg1_90)
	return pg.ship_data_template[arg0_90.configId]["equip_" .. arg1_90] or {}
end

function var0_0.updateState(arg0_91, arg1_91)
	arg0_91.state = arg1_91
end

function var0_0.addSkillExp(arg0_92, arg1_92, arg2_92)
	local var0_92 = arg0_92.skills[arg1_92] or {
		exp = 0,
		level = 1,
		id = arg1_92
	}
	local var1_92 = var0_92.level and var0_92.level or 1
	local var2_92 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1_92 == var2_92 then
		return
	end

	local var3_92 = var0_92.exp and arg2_92 + var0_92.exp or 0 + arg2_92

	while var3_92 >= pg.skill_need_exp[var1_92].exp do
		var3_92 = var3_92 - pg.skill_need_exp[var1_92].exp
		var1_92 = var1_92 + 1

		if var1_92 == var2_92 then
			var3_92 = 0

			break
		end
	end

	arg0_92:updateSkill({
		id = var0_92.id,
		level = var1_92,
		exp = var3_92
	})
end

function var0_0.upSkillLevelForMeta(arg0_93, arg1_93)
	local var0_93 = arg0_93.skills[arg1_93] or {
		exp = 0,
		level = 0,
		id = arg1_93
	}
	local var1_93 = arg0_93:isSkillLevelMax(arg1_93)
	local var2_93 = var0_93.level

	if not var1_93 then
		var2_93 = var2_93 + 1
	end

	arg0_93:updateSkill({
		exp = 0,
		id = var0_93.id,
		level = var2_93
	})
end

function var0_0.getMetaSkillLevelBySkillID(arg0_94, arg1_94)
	return (arg0_94.skills[arg1_94] or {
		exp = 0,
		level = 0,
		id = arg1_94
	}).level
end

function var0_0.isSkillLevelMax(arg0_95, arg1_95)
	local var0_95 = arg0_95.skills[arg1_95] or {
		exp = 0,
		level = 1,
		id = arg1_95
	}

	return (var0_95.level and var0_95.level or 1) >= pg.skill_data_template[arg1_95].max_level
end

function var0_0.isAllMetaSkillLevelMax(arg0_96)
	local var0_96 = true
	local var1_96 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_96.configId)

	for iter0_96, iter1_96 in ipairs(var1_96) do
		if not arg0_96:isSkillLevelMax(iter1_96) then
			var0_96 = false

			break
		end
	end

	return var0_96
end

function var0_0.isAllMetaSkillLock(arg0_97)
	local var0_97 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_97.configId)
	local var1_97 = true

	for iter0_97, iter1_97 in ipairs(var0_97) do
		if arg0_97:getMetaSkillLevelBySkillID(iter1_97) > 0 then
			var1_97 = false

			break
		end
	end

	return var1_97
end

function var0_0.bindConfigTable(arg0_98)
	return pg.ship_data_statistics
end

function var0_0.isAvaiable(arg0_99)
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

function var0_0.intimacyAdditions(arg0_100, arg1_100)
	local var0_100 = pg.intimacy_template[arg0_100:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0_100, iter1_100 in pairs(arg1_100) do
		if iter0_100 == AttributeType.Durability or iter0_100 == AttributeType.Cannon or iter0_100 == AttributeType.Torpedo or iter0_100 == AttributeType.AntiAircraft or iter0_100 == AttributeType.AntiSub or iter0_100 == AttributeType.Air or iter0_100 == AttributeType.Reload or iter0_100 == AttributeType.Hit or iter0_100 == AttributeType.Dodge then
			arg1_100[iter0_100] = arg1_100[iter0_100] * (var0_100 + 1)
		end
	end
end

function var0_0.getShipProperties(arg0_101)
	local var0_101 = arg0_101:getBaseProperties()

	if arg0_101:isBluePrintShip() then
		local var1_101 = arg0_101:getBluePrint()

		assert(var1_101, "blueprint can not be nil" .. arg0_101.configId)

		local var2_101 = var1_101:getTotalAdditions()

		for iter0_101, iter1_101 in pairs(var2_101) do
			var0_101[iter0_101] = var0_101[iter0_101] + calcFloor(iter1_101)
		end

		arg0_101:intimacyAdditions(var0_101)
	elseif arg0_101:isMetaShip() then
		assert(arg0_101.metaCharacter)

		for iter2_101, iter3_101 in pairs(var0_101) do
			var0_101[iter2_101] = var0_101[iter2_101] + arg0_101.metaCharacter:getAttrAddition(iter2_101)
		end

		arg0_101:intimacyAdditions(var0_101)
	else
		local var3_101 = pg.ship_data_template[arg0_101.configId].strengthen_id
		local var4_101 = var5_0[var3_101]

		for iter4_101, iter5_101 in pairs(arg0_101.strengthList) do
			local var5_101 = ShipModAttr.ATTR_TO_INDEX[iter4_101]
			local var6_101 = math.min(iter5_101, var4_101.durability[var5_101] * var4_101.level_exp[var5_101])
			local var7_101 = math.max(arg0_101:getModExpRatio(iter4_101), 1)

			var0_101[iter4_101] = var0_101[iter4_101] + calcFloor(var6_101 / var7_101)
		end

		arg0_101:intimacyAdditions(var0_101)

		for iter6_101, iter7_101 in pairs(arg0_101.transforms) do
			local var8_101 = pg.transform_data_template[iter7_101.id].effect

			for iter8_101 = 1, iter7_101.level do
				local var9_101 = var8_101[iter8_101] or {}

				for iter9_101, iter10_101 in pairs(var0_101) do
					if var9_101[iter9_101] then
						var0_101[iter9_101] = var0_101[iter9_101] + var9_101[iter9_101]
					end
				end
			end
		end
	end

	return var0_101
end

function var0_0.getTechNationAddition(arg0_102, arg1_102)
	local var0_102 = getProxy(TechnologyNationProxy)
	local var1_102 = arg0_102:getConfig("type")

	if var1_102 == ShipType.DaoQuV or var1_102 == ShipType.DaoQuM then
		var1_102 = ShipType.QuZhu
	end

	return var0_102:getShipAddition(var1_102, arg1_102)
end

function var0_0.getTechNationMaxAddition(arg0_103, arg1_103)
	local var0_103 = getProxy(TechnologyNationProxy)
	local var1_103 = arg0_103:getConfig("type")

	return var0_103:getShipMaxAddition(var1_103, arg1_103)
end

function var0_0.getEquipProficiencyByPos(arg0_104, arg1_104)
	return arg0_104:getEquipProficiencyList()[arg1_104]
end

function var0_0.getEquipProficiencyList(arg0_105)
	local var0_105 = arg0_105:getConfigTable()
	local var1_105 = Clone(var0_105.equipment_proficiency)

	if arg0_105:isBluePrintShip() then
		local var2_105 = arg0_105:getBluePrint()

		assert(var2_105, "blueprint can not be nil >>>" .. arg0_105.groupId)

		var1_105 = var2_105:getEquipProficiencyList(arg0_105)
	else
		for iter0_105, iter1_105 in ipairs(var1_105) do
			local var3_105 = 0

			for iter2_105, iter3_105 in pairs(arg0_105.transforms) do
				local var4_105 = pg.transform_data_template[iter3_105.id].effect

				for iter4_105 = 1, iter3_105.level do
					local var5_105 = var4_105[iter4_105] or {}

					if var5_105["equipment_proficiency_" .. iter0_105] then
						var3_105 = var3_105 + var5_105["equipment_proficiency_" .. iter0_105]
					end
				end
			end

			var1_105[iter0_105] = iter1_105 + var3_105
		end
	end

	return var1_105
end

function var0_0.getBaseProperties(arg0_106)
	local var0_106 = arg0_106:getConfigTable()

	assert(var0_106, "配置表没有这艘船" .. arg0_106.configId)

	local var1_106 = {}
	local var2_106 = {}

	for iter0_106, iter1_106 in ipairs(var0_0.PROPERTIES) do
		var1_106[iter1_106] = arg0_106:getGrowthForAttr(iter1_106)
		var2_106[iter1_106] = var1_106[iter1_106]
	end

	for iter2_106, iter3_106 in ipairs(arg0_106:getConfig("lock")) do
		var2_106[iter3_106] = var1_106[iter3_106]
	end

	for iter4_106, iter5_106 in ipairs(var0_0.DIVE_PROPERTIES) do
		var2_106[iter5_106] = var0_106[iter5_106]
	end

	for iter6_106, iter7_106 in ipairs(var0_0.SONAR_PROPERTIES) do
		var2_106[iter7_106] = 0
	end

	return var2_106
end

function var0_0.getGrowthForAttr(arg0_107, arg1_107)
	local var0_107 = arg0_107:getConfigTable()
	local var1_107 = table.indexof(var0_0.PROPERTIES, arg1_107)
	local var2_107 = pg.gameset.extra_attr_level_limit.key_value
	local var3_107 = var0_107.attrs[var1_107] + (arg0_107.level - 1) * var0_107.attrs_growth[var1_107] / 1000

	if var2_107 < arg0_107.level then
		var3_107 = var3_107 + (arg0_107.level - var2_107) * var0_107.attrs_growth_extra[var1_107] / 1000
	end

	return var3_107
end

function var0_0.isMaxStar(arg0_108)
	return arg0_108:getStar() >= arg0_108:getMaxStar()
end

function var0_0.IsMaxStarByTmpID(arg0_109)
	local var0_109 = pg.ship_data_template[arg0_109]

	return var0_109.star >= var0_109.star_max
end

function var0_0.IsSpweaponUnlock(arg0_110)
	if not arg0_110:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0_0.getModProperties(arg0_111, arg1_111)
	return arg0_111.strengthList[arg1_111] or 0
end

function var0_0.addModAttrExp(arg0_112, arg1_112, arg2_112)
	local var0_112 = arg0_112:getModAttrTopLimit(arg1_112)

	if var0_112 == 0 then
		return
	end

	local var1_112 = arg0_112:getModExpRatio(arg1_112)
	local var2_112 = arg0_112:getModProperties(arg1_112)

	if var2_112 + arg2_112 > var0_112 * var1_112 then
		arg0_112.strengthList[arg1_112] = var0_112 * var1_112
	else
		arg0_112.strengthList[arg1_112] = var2_112 + arg2_112
	end
end

function var0_0.getNeedModExp(arg0_113)
	local var0_113 = {}

	for iter0_113, iter1_113 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1_113 = arg0_113:getModAttrTopLimit(iter1_113)

		if var1_113 == 0 then
			var0_113[iter1_113] = 0
		else
			var0_113[iter1_113] = var1_113 * arg0_113:getModExpRatio(iter1_113) - arg0_113:getModProperties(iter1_113)
		end
	end

	return var0_113
end

function var0_0.attrVertify(arg0_114)
	if not BayProxy.checkShiplevelVertify(arg0_114) then
		return false
	end

	for iter0_114, iter1_114 in ipairs(arg0_114.equipments) do
		if iter1_114 and not iter1_114:vertify() then
			return false
		end
	end

	return true
end

function var0_0.getEquipmentProperties(arg0_115)
	local var0_115 = {}
	local var1_115 = {}

	for iter0_115, iter1_115 in ipairs(var0_0.PROPERTIES) do
		var0_115[iter1_115] = 0
	end

	for iter2_115, iter3_115 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_115[iter3_115] = 0
	end

	for iter4_115, iter5_115 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_115[iter5_115] = 0
	end

	for iter6_115, iter7_115 in ipairs(var0_0.PROPERTIES_ENHANCEMENT) do
		var1_115[iter7_115] = 0
	end

	var0_115[AttributeType.AirDominate] = 0
	var0_115[AttributeType.AntiSiren] = 0

	local var2_115 = arg0_115:getActiveEquipments()

	for iter8_115, iter9_115 in ipairs(var2_115) do
		if iter9_115 then
			local var3_115 = iter9_115:GetAttributes()

			for iter10_115, iter11_115 in ipairs(var3_115) do
				if iter11_115 and var0_115[iter11_115.type] then
					var0_115[iter11_115.type] = var0_115[iter11_115.type] + iter11_115.value
				end
			end

			local var4_115 = iter9_115:GetPropertyRate()

			for iter12_115, iter13_115 in pairs(var4_115) do
				var1_115[iter12_115] = math.max(var1_115[iter12_115], iter13_115)
			end

			local var5_115 = iter9_115:GetSonarProperty()

			if var5_115 then
				for iter14_115, iter15_115 in pairs(var5_115) do
					var0_115[iter14_115] = var0_115[iter14_115] + iter15_115
				end
			end

			local var6_115 = iter9_115:GetAntiSirenPower()

			if var6_115 then
				var0_115[AttributeType.AntiSiren] = var0_115[AttributeType.AntiSiren] + var6_115 / 10000
			end
		end
	end

	;(function()
		local var0_116 = arg0_115:GetSpWeapon()

		if not var0_116 then
			return
		end

		local var1_116 = var0_116:GetPropertiesInfo().attrs

		for iter0_116, iter1_116 in ipairs(var1_116) do
			if iter1_116 and var0_115[iter1_116.type] then
				var0_115[iter1_116.type] = var0_115[iter1_116.type] + iter1_116.value
			end
		end
	end)()

	for iter16_115, iter17_115 in pairs(var1_115) do
		var1_115[iter16_115] = iter17_115 + 1
	end

	return var0_115, var1_115
end

function var0_0.getSkillEffects(arg0_117)
	local var0_117 = arg0_117:getShipSkillEffects()

	_.each(arg0_117:getEquipmentSkillEffects(), function(arg0_118)
		table.insert(var0_117, arg0_118)
	end)

	return var0_117
end

function var0_0.getShipSkillEffects(arg0_119)
	local var0_119 = {}
	local var1_119 = arg0_119:getSkillList()

	for iter0_119, iter1_119 in ipairs(var1_119) do
		local var2_119 = arg0_119:RemapSkillId(iter1_119)
		local var3_119 = pg.buffCfg["buff_" .. var2_119]

		arg0_119:FilterActiveSkill(var0_119, var3_119, arg0_119.skills[iter1_119])
	end

	return var0_119
end

function var0_0.getEquipmentSkillEffects(arg0_120)
	local var0_120 = {}
	local var1_120 = arg0_120:getActiveEquipments()

	for iter0_120, iter1_120 in ipairs(var1_120) do
		local var2_120
		local var3_120 = iter1_120 and iter1_120:getConfig("skill_id")[1] and iter1_120:getConfig("skill_id")[1][1]

		if var3_120 then
			var2_120 = pg.buffCfg["buff_" .. var3_120]
		end

		arg0_120:FilterActiveSkill(var0_120, var2_120)
	end

	;(function()
		local var0_121 = arg0_120:GetSpWeapon()
		local var1_121 = var0_121 and var0_121:GetEffect() or 0
		local var2_121

		if var1_121 > 0 then
			var2_121 = pg.buffCfg["buff_" .. var1_121]
		end

		arg0_120:FilterActiveSkill(var0_120, var2_121)
	end)()

	return var0_120
end

function var0_0.FilterActiveSkill(arg0_122, arg1_122, arg2_122, arg3_122)
	if not arg2_122 or not arg2_122.const_effect_list then
		return
	end

	for iter0_122 = 1, #arg2_122.const_effect_list do
		local var0_122 = arg2_122.const_effect_list[iter0_122]
		local var1_122 = var0_122.trigger
		local var2_122 = var0_122.arg_list
		local var3_122 = 1

		if arg3_122 then
			var3_122 = arg3_122.level

			local var4_122 = arg2_122[var3_122].const_effect_list

			if var4_122 and var4_122[iter0_122] then
				var1_122 = var4_122[iter0_122].trigger or var1_122
				var2_122 = var4_122[iter0_122].arg_list or var2_122
			end
		end

		local var5_122 = true

		for iter1_122, iter2_122 in pairs(var1_122) do
			if arg0_122.triggers[iter1_122] ~= iter2_122 then
				var5_122 = false

				break
			end
		end

		if var5_122 then
			table.insert(arg1_122, {
				type = var0_122.type,
				arg_list = var2_122,
				level = var3_122
			})
		end
	end
end

function var0_0.getEquipmentGearScore(arg0_123)
	local var0_123 = 0
	local var1_123 = arg0_123:getActiveEquipments()

	for iter0_123, iter1_123 in ipairs(var1_123) do
		if iter1_123 then
			var0_123 = var0_123 + iter1_123:GetGearScore()
		end
	end

	return var0_123
end

function var0_0.getProperties(arg0_124, arg1_124, arg2_124, arg3_124, arg4_124)
	local var0_124 = arg1_124 or {}
	local var1_124 = arg0_124:getConfig("nationality")
	local var2_124 = arg0_124:getConfig("type")
	local var3_124 = arg0_124:getShipProperties()
	local var4_124, var5_124 = arg0_124:getEquipmentProperties()
	local var6_124
	local var7_124
	local var8_124

	if arg3_124 and arg0_124:getFlag("inWorld") then
		local var9_124 = WorldConst.FetchWorldShip(arg0_124.id)

		var6_124, var7_124 = var9_124:GetShipBuffProperties()
		var8_124 = var9_124:GetShipPowerBuffProperties()
	end

	for iter0_124, iter1_124 in ipairs(var0_0.PROPERTIES) do
		local var10_124 = 0
		local var11_124 = 0

		for iter2_124, iter3_124 in pairs(var0_124) do
			var10_124 = var10_124 + iter3_124:getAttrRatioAddition(iter1_124, var1_124, var2_124) / 100
			var11_124 = var11_124 + iter3_124:getAttrValueAddition(iter1_124, var1_124, var2_124)
		end

		local var12_124 = var10_124 + (var5_124[iter1_124] or 1)
		local var13_124 = var7_124 and var7_124[iter1_124] or 1
		local var14_124 = var6_124 and var6_124[iter1_124] or 0

		if iter1_124 == AttributeType.Speed then
			var3_124[iter1_124] = var3_124[iter1_124] * var12_124 * var13_124 + var11_124 + var4_124[iter1_124] + var14_124
		else
			var3_124[iter1_124] = calcFloor(calcFloor(var3_124[iter1_124]) * var12_124 * var13_124) + var11_124 + var4_124[iter1_124] + var14_124
		end
	end

	if not arg2_124 and arg0_124:isMaxStar() then
		for iter4_124, iter5_124 in pairs(var3_124) do
			local var15_124 = arg4_124 and arg0_124:getTechNationMaxAddition(iter4_124) or arg0_124:getTechNationAddition(iter4_124)

			var3_124[iter4_124] = var3_124[iter4_124] + var15_124
		end
	end

	for iter6_124, iter7_124 in ipairs(var0_0.DIVE_PROPERTIES) do
		var3_124[iter7_124] = var3_124[iter7_124] + var4_124[iter7_124]
	end

	for iter8_124, iter9_124 in ipairs(var0_0.SONAR_PROPERTIES) do
		var3_124[iter9_124] = var3_124[iter9_124] + var4_124[iter9_124]
	end

	if arg3_124 then
		var3_124[AttributeType.AntiSiren] = (var3_124[AttributeType.AntiSiren] or 0) + var4_124[AttributeType.AntiSiren]
	end

	if var8_124 then
		for iter10_124, iter11_124 in pairs(var8_124) do
			if var3_124[iter10_124] then
				if iter10_124 == AttributeType.Speed then
					var3_124[iter10_124] = var3_124[iter10_124] * iter11_124
				else
					var3_124[iter10_124] = math.floor(var3_124[iter10_124] * iter11_124)
				end
			end
		end
	end

	return var3_124
end

function var0_0.getTransGearScore(arg0_125)
	local var0_125 = 0
	local var1_125 = pg.transform_data_template

	for iter0_125, iter1_125 in pairs(arg0_125.transforms) do
		for iter2_125 = 1, iter1_125.level do
			var0_125 = var0_125 + (var1_125[iter1_125.id].gear_score[iter2_125] or 0)
		end
	end

	return var0_125
end

function var0_0.getShipCombatPower(arg0_126, arg1_126)
	local var0_126 = arg0_126:getProperties(arg1_126, nil, nil, true)
	local var1_126 = var0_126[AttributeType.Durability] / 5 + var0_126[AttributeType.Cannon] + var0_126[AttributeType.Torpedo] + var0_126[AttributeType.AntiAircraft] + var0_126[AttributeType.Air] + var0_126[AttributeType.AntiSub] + var0_126[AttributeType.Reload] + var0_126[AttributeType.Hit] * 2 + var0_126[AttributeType.Dodge] * 2 + var0_126[AttributeType.Speed] + arg0_126:getEquipmentGearScore() + arg0_126:getTransGearScore()

	return math.floor(var1_126)
end

function var0_0.cosumeEnergy(arg0_127, arg1_127)
	arg0_127:setEnergy(math.max(arg0_127:getEnergy() - arg1_127, 0))
end

function var0_0.addEnergy(arg0_128, arg1_128)
	arg0_128:setEnergy(arg0_128:getEnergy() + arg1_128)
end

function var0_0.setEnergy(arg0_129, arg1_129)
	arg0_129.energy = arg1_129
end

function var0_0.setLikability(arg0_130, arg1_130)
	assert(arg1_130 >= 0 and arg1_130 <= arg0_130.maxIntimacy, "intimacy value invaild" .. arg1_130)
	arg0_130:setIntimacy(arg1_130)
end

function var0_0.addLikability(arg0_131, arg1_131)
	local var0_131 = Mathf.Clamp(arg0_131:getIntimacy() + arg1_131, 0, arg0_131.maxIntimacy)

	arg0_131:setIntimacy(var0_131)
end

function var0_0.setIntimacy(arg0_132, arg1_132)
	if arg1_132 > 10000 and not arg0_132.propose then
		arg1_132 = 10000
	end

	arg0_132.intimacy = arg1_132

	if not arg0_132:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0_132.groupId]:updateMaxIntimacy(arg0_132:getIntimacy())
	end
end

function var0_0.getLevelExpConfig(arg0_133, arg1_133)
	if arg0_133:getConfig("rarity") == ShipRarity.SSR then
		local var0_133 = Clone(getConfigFromLevel1(var6_0, arg1_133 or arg0_133.level))

		var0_133.exp = var0_133.exp_ur
		var0_133.exp_start = var0_133.exp_ur_start
		var0_133.exp_interval = var0_133.exp_ur_interval
		var0_133.exp_end = var0_133.exp_ur_end

		return var0_133
	else
		return getConfigFromLevel1(var6_0, arg1_133 or arg0_133.level)
	end
end

function var0_0.getExp(arg0_134)
	local var0_134 = arg0_134:getMaxLevel()

	if arg0_134.level == var0_134 and LOCK_FULL_EXP then
		return 0
	end

	return arg0_134.exp
end

function var0_0.getProficiency(arg0_135)
	return arg0_135.proficiency
end

function var0_0.addExp(arg0_136, arg1_136, arg2_136)
	local var0_136 = arg0_136:getMaxLevel()

	if arg0_136.level == var0_136 then
		if arg0_136.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2_136 or not arg0_136:CanAccumulateExp() then
			arg1_136 = 0
		end
	end

	arg0_136.exp = arg0_136.exp + arg1_136

	local var1_136 = false

	while arg0_136:canLevelUp() do
		arg0_136.exp = arg0_136.exp - arg0_136:getLevelExpConfig().exp_interval
		arg0_136.level = math.min(arg0_136.level + 1, var0_136)
		var1_136 = true
	end

	if arg0_136.level == var0_136 then
		if arg2_136 and arg0_136:CanAccumulateExp() then
			arg0_136.exp = math.min(arg0_136.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1_136 then
			arg0_136.exp = 0
		end
	end
end

function var0_0.getMaxLevel(arg0_137)
	return arg0_137.maxLevel
end

function var0_0.canLevelUp(arg0_138)
	local var0_138 = arg0_138:getLevelExpConfig(arg0_138.level + 1)
	local var1_138 = arg0_138:getMaxLevel() <= arg0_138.level

	return var0_138 and arg0_138:getLevelExpConfig().exp_interval <= arg0_138.exp and not var1_138
end

function var0_0.getConfigMaxLevel(arg0_139)
	return var6_0.all[#var6_0.all]
end

function var0_0.isConfigMaxLevel(arg0_140)
	return arg0_140.level == arg0_140:getConfigMaxLevel()
end

function var0_0.updateMaxLevel(arg0_141, arg1_141)
	local var0_141 = arg0_141:getConfigMaxLevel()

	arg0_141.maxLevel = math.max(math.min(var0_141, arg1_141), arg0_141.maxLevel)
end

function var0_0.getNextMaxLevel(arg0_142)
	local var0_142 = arg0_142:getConfigMaxLevel()

	for iter0_142 = arg0_142:getMaxLevel() + 1, var0_142 do
		if var6_0[iter0_142].level_limit == 1 then
			return iter0_142
		end
	end
end

function var0_0.canUpgrade(arg0_143)
	if arg0_143:isBluePrintShip() then
		return false
	end

	if arg0_143:isMetaShip() then
		local var0_143 = arg0_143:getMetaCharacter()

		if not var0_143 then
			return false
		end

		local var1_143 = var0_143:getBreakOutInfo()

		if not var1_143:hasNextInfo() then
			return false
		end

		local var2_143, var3_143 = var1_143:getLimited()

		if var2_143 > arg0_143.level then
			return false
		end

		return true
	else
		local var4_143 = var8_0[arg0_143.configId]

		assert(var4_143, "不存在配置" .. arg0_143.configId)

		return not arg0_143:isMaxStar() and arg0_143.level >= var4_143.level
	end
end

function var0_0.isReachNextMaxLevel(arg0_144)
	return arg0_144.level == arg0_144:getMaxLevel() and arg0_144:CanAccumulateExp() and arg0_144:getNextMaxLevel() ~= nil
end

function var0_0.isAwakening(arg0_145)
	return arg0_145:isReachNextMaxLevel() and arg0_145.level < var4_0
end

function var0_0.isAwakening2(arg0_146)
	return arg0_146:isReachNextMaxLevel() and arg0_146.level >= var4_0
end

function var0_0.notMaxLevelForFilter(arg0_147)
	return arg0_147.level ~= arg0_147:getMaxLevel()
end

function var0_0.getNextMaxLevelConsume(arg0_148)
	local var0_148 = arg0_148:getMaxLevel()
	local var1_148 = var6_0[var0_148]["need_item_rarity" .. arg0_148:getConfig("rarity")]

	assert(var1_148, "items  can not be nil")

	return _.map(var1_148, function(arg0_149)
		return {
			type = arg0_149[1],
			id = arg0_149[2],
			count = arg0_149[3]
		}
	end)
end

function var0_0.canUpgradeMaxLevel(arg0_150)
	if not arg0_150:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0_150 = getProxy(PlayerProxy):getData()
		local var1_150 = getProxy(BagProxy)
		local var2_150 = arg0_150:getNextMaxLevelConsume()

		for iter0_150, iter1_150 in pairs(var2_150) do
			if iter1_150.type == DROP_TYPE_RESOURCE then
				if var0_150:getResById(iter1_150.id) < iter1_150.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1_150.type == DROP_TYPE_ITEM and var1_150:getItemCountById(iter1_150.id) < iter1_150.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.CanAccumulateExp(arg0_151)
	return pg.ship_data_template[arg0_151.configId].can_get_proficency == 1
end

function var0_0.getTotalExp(arg0_152)
	return arg0_152:getLevelExpConfig().exp_start + arg0_152.exp
end

function var0_0.getStartBattleExpend(arg0_153)
	if table.contains(TeamType.SubShipType, arg0_153:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0_153.configId].oil_at_start
	end
end

function var0_0.getEndBattleExpend(arg0_154)
	local var0_154 = pg.ship_data_template[arg0_154.configId]
	local var1_154 = arg0_154:getLevelExpConfig()

	return (math.floor(var0_154.oil_at_end * var1_154.fight_oil_ratio / 10000))
end

function var0_0.getBattleTotalExpend(arg0_155)
	return arg0_155:getStartBattleExpend() + arg0_155:getEndBattleExpend()
end

function var0_0.getShipAmmo(arg0_156)
	local var0_156 = arg0_156:getConfig(AttributeType.Ammo)

	for iter0_156, iter1_156 in pairs(arg0_156:getAllSkills()) do
		local var1_156 = tonumber(iter0_156 .. string.format("%.2d", iter1_156.level))
		local var2_156 = pg.skill_benefit_template[var1_156]

		if var2_156 and arg0_156:IsBenefitSkillActive(var2_156) and (var2_156.type == var0_0.BENEFIT_EQUIP or var2_156.type == var0_0.BENEFIT_SKILL) then
			var0_156 = var0_156 + defaultValue(var2_156.effect[1], 0)
		end
	end

	local var3_156 = arg0_156:getActiveEquipments()

	for iter2_156, iter3_156 in ipairs(var3_156) do
		local var4_156 = iter3_156 and iter3_156:getConfig("equip_parameters").ammo

		if var4_156 then
			var0_156 = var0_156 + var4_156
		end
	end

	return var0_156
end

function var0_0.getHuntingLv(arg0_157)
	local var0_157 = arg0_157:getConfig("huntingrange_level")

	for iter0_157, iter1_157 in pairs(arg0_157:getAllSkills()) do
		local var1_157 = tonumber(iter0_157 .. string.format("%.2d", iter1_157.level))
		local var2_157 = pg.skill_benefit_template[var1_157]

		if var2_157 and arg0_157:IsBenefitSkillActive(var2_157) and (var2_157.type == var0_0.BENEFIT_EQUIP or var2_157.type == var0_0.BENEFIT_SKILL) then
			var0_157 = var0_157 + defaultValue(var2_157.effect[2], 0)
		end
	end

	local var3_157 = arg0_157:getActiveEquipments()

	for iter2_157, iter3_157 in ipairs(var3_157) do
		local var4_157 = iter3_157 and iter3_157:getConfig("equip_parameters").hunting_lv

		if var4_157 then
			var0_157 = var0_157 + var4_157
		end
	end

	return (math.min(var0_157, arg0_157:getMaxHuntingLv()))
end

function var0_0.getMapAuras(arg0_158)
	local var0_158 = {}

	for iter0_158, iter1_158 in pairs(arg0_158:getAllSkills()) do
		local var1_158 = tonumber(iter0_158 .. string.format("%.2d", iter1_158.level))
		local var2_158 = pg.skill_benefit_template[var1_158]

		if var2_158 and arg0_158:IsBenefitSkillActive(var2_158) and var2_158.type == var0_0.BENEFIT_MAP_AURA then
			local var3_158 = {
				id = var2_158.effect[1],
				level = iter1_158.level
			}

			table.insert(var0_158, var3_158)
		end
	end

	return var0_158
end

function var0_0.getMapAids(arg0_159)
	local var0_159 = {}

	for iter0_159, iter1_159 in pairs(arg0_159:getAllSkills()) do
		local var1_159 = tonumber(iter0_159 .. string.format("%.2d", iter1_159.level))
		local var2_159 = pg.skill_benefit_template[var1_159]

		if var2_159 and arg0_159:IsBenefitSkillActive(var2_159) and var2_159.type == var0_0.BENEFIT_AID then
			local var3_159 = {
				id = var2_159.effect[1],
				level = iter1_159.level
			}

			table.insert(var0_159, var3_159)
		end
	end

	return var0_159
end

var0_0.BENEFIT_SKILL = 2
var0_0.BENEFIT_EQUIP = 3
var0_0.BENEFIT_MAP_AURA = 4
var0_0.BENEFIT_AID = 5

function var0_0.IsBenefitSkillActive(arg0_160, arg1_160)
	local var0_160 = false

	if arg1_160.type == var0_0.BENEFIT_SKILL then
		if not arg1_160.limit[1] or arg1_160.limit[1] == arg0_160.triggers.TeamNumbers then
			var0_160 = true
		end
	elseif arg1_160.type == var0_0.BENEFIT_EQUIP then
		local var1_160 = arg1_160.limit
		local var2_160 = arg0_160:getAllEquipments()

		for iter0_160, iter1_160 in ipairs(var2_160) do
			if iter1_160 and table.contains(var1_160, iter1_160:getConfig("id")) then
				var0_160 = true

				break
			end
		end
	elseif arg1_160.type == var0_0.BENEFIT_MAP_AURA then
		if arg0_160.hpRant and arg0_160.hpRant > 0 then
			return true
		end
	elseif arg1_160.type == var0_0.BENEFIT_AID and arg0_160.hpRant and arg0_160.hpRant > 0 then
		return true
	end

	return var0_160
end

function var0_0.getMaxHuntingLv(arg0_161)
	return #arg0_161:getConfig("hunting_range")
end

function var0_0.getHuntingRange(arg0_162, arg1_162)
	local var0_162 = arg0_162:getConfig("hunting_range")
	local var1_162 = Clone(var0_162[1])
	local var2_162 = arg1_162 or arg0_162:getHuntingLv()
	local var3_162 = math.min(var2_162, arg0_162:getMaxHuntingLv())

	for iter0_162 = 2, var3_162 do
		_.each(var0_162[iter0_162], function(arg0_163)
			table.insert(var1_162, {
				arg0_163[1],
				arg0_163[2]
			})
		end)
	end

	return var1_162
end

function var0_0.getTriggerSkills(arg0_164)
	local var0_164 = {}
	local var1_164 = arg0_164:getSkillEffects()

	_.each(var1_164, function(arg0_165)
		if arg0_165.type == "AddBuff" and arg0_165.arg_list and arg0_165.arg_list.buff_id then
			local var0_165 = arg0_165.arg_list.buff_id

			var0_164[var0_165] = {
				id = var0_165,
				level = arg0_165.level
			}
		end
	end)

	return var0_164
end

function var0_0.GetEquipmentSkills(arg0_166)
	local var0_166 = {}
	local var1_166 = arg0_166:getActiveEquipments()

	for iter0_166, iter1_166 in ipairs(var1_166) do
		if iter1_166 and iter1_166:getConfig("skill_id")[1] then
			local var2_166, var3_166 = unpack(iter1_166:getConfig("skill_id")[1])

			var0_166[var2_166] = {
				id = var2_166,
				level = var3_166
			}
		end
	end

	;(function()
		local var0_167 = arg0_166:GetSpWeapon()
		local var1_167 = var0_167 and var0_167:GetEffect() or 0

		if var1_167 > 0 then
			var0_166[var1_167] = {
				level = 1,
				id = var1_167
			}
		end
	end)()

	return var0_166
end

function var0_0.getAllSkills(arg0_168)
	local var0_168 = Clone(arg0_168.skills)

	for iter0_168, iter1_168 in pairs(arg0_168:GetEquipmentSkills()) do
		var0_168[iter0_168] = iter1_168
	end

	for iter2_168, iter3_168 in pairs(arg0_168:getTriggerSkills()) do
		var0_168[iter2_168] = iter3_168
	end

	return var0_168
end

function var0_0.isSameKind(arg0_169, arg1_169)
	return pg.ship_data_template[arg0_169.configId].group_type == pg.ship_data_template[arg1_169.configId].group_type
end

function var0_0.GetLockState(arg0_170)
	return arg0_170.lockState
end

function var0_0.IsLocked(arg0_171)
	return arg0_171.lockState == var0_0.LOCK_STATE_LOCK
end

function var0_0.SetLockState(arg0_172, arg1_172)
	arg0_172.lockState = arg1_172
end

function var0_0.GetPreferenceTag(arg0_173)
	return arg0_173.preferenceTag or 0
end

function var0_0.IsPreferenceTag(arg0_174)
	return arg0_174:GetPreferenceTag() == var0_0.PREFERENCE_TAG_COMMON
end

function var0_0.SetPreferenceTag(arg0_175, arg1_175)
	arg0_175.preferenceTag = arg1_175
end

function var0_0.calReturnRes(arg0_176)
	local var0_176 = pg.ship_data_by_type[arg0_176:getShipType()]
	local var1_176 = var0_176.distory_resource_gold_ratio
	local var2_176 = var0_176.distory_resource_oil_ratio
	local var3_176 = pg.ship_data_by_star[arg0_176:getConfig("rarity")].destory_item

	return var1_176, 0, var3_176
end

function var0_0.getRarity(arg0_177)
	local var0_177 = arg0_177:getConfig("rarity")

	if arg0_177:isRemoulded() then
		var0_177 = var0_177 + 1
	end

	return var0_177
end

function var0_0.updateSkill(arg0_178, arg1_178)
	local var0_178 = arg1_178.skill_id or arg1_178.id
	local var1_178 = arg1_178.skill_lv or arg1_178.lv or arg1_178.level
	local var2_178 = arg1_178.skill_exp or arg1_178.exp

	arg0_178.skills[var0_178] = {
		id = var0_178,
		level = var1_178,
		exp = var2_178
	}
end

function var0_0.canEquipAtPos(arg0_179, arg1_179, arg2_179)
	local var0_179, var1_179 = arg0_179:isForbiddenAtPos(arg1_179, arg2_179)

	if var0_179 then
		return false, var1_179
	end

	for iter0_179, iter1_179 in ipairs(arg0_179.equipments) do
		if iter1_179 and iter0_179 ~= arg2_179 and iter1_179:getConfig("equip_limit") ~= 0 and arg1_179:getConfig("equip_limit") == iter1_179:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0_0.isForbiddenAtPos(arg0_180, arg1_180, arg2_180)
	local var0_180 = pg.ship_data_template[arg0_180.configId]

	assert(var0_180, "can not find ship in ship_data_templtae: " .. arg0_180.configId)

	local var1_180 = var0_180["equip_" .. arg2_180]

	if not table.contains(var1_180, arg1_180:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1_180:getConfig("ship_type_forbidden"), arg0_180:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0_0.canEquipCommander(arg0_181, arg1_181)
	if arg1_181:getShipType() ~= arg0_181:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0_0.upgrade(arg0_182)
	local var0_182 = pg.ship_data_transform[arg0_182.configId]

	if var0_182.trans_id and var0_182.trans_id > 0 then
		arg0_182.configId = var0_182.trans_id
		arg0_182.star = arg0_182:getConfig("star")
	end
end

function var0_0.getTeamType(arg0_183)
	return TeamType.GetTeamFromShipType(arg0_183:getShipType())
end

function var0_0.getFleetName(arg0_184)
	local var0_184 = arg0_184:getTeamType()

	return var1_0[var0_184]
end

function var0_0.getMaxConfigId(arg0_185)
	local var0_185 = pg.ship_data_template
	local var1_185

	for iter0_185 = 4, 1, -1 do
		local var2_185 = tonumber(arg0_185.groupId .. iter0_185)

		if var0_185[var2_185] then
			var1_185 = var2_185

			break
		end
	end

	return var1_185
end

function var0_0.getFlag(arg0_186, arg1_186, arg2_186)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_186.id, arg1_186, arg2_186)
end

function var0_0.hasAnyFlag(arg0_187, arg1_187)
	return _.any(arg1_187, function(arg0_188)
		return arg0_187:getFlag(arg0_188)
	end)
end

function var0_0.isBreakOut(arg0_189)
	return arg0_189.configId % 10 > 1
end

function var0_0.fateSkillChange(arg0_190, arg1_190)
	if not arg0_190.skillChangeList then
		arg0_190.skillChangeList = arg0_190:isBluePrintShip() and arg0_190:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_190, iter1_190 in ipairs(arg0_190.skillChangeList) do
		if iter1_190[1] == arg1_190 and arg0_190.skills[iter1_190[2]] then
			return iter1_190[2]
		end
	end

	return arg1_190
end

function var0_0.RemapSkillId(arg0_191, arg1_191)
	local var0_191 = arg0_191:GetSpWeapon()

	if var0_191 then
		if table.contains(pg.ship_data_template[arg0_191.configId].hide_buff_list, arg1_191) then
			return var0_191:RemapHiddenSkillId(arg1_191)
		else
			return var0_191:RemapSkillId(arg1_191)
		end
	end

	return arg1_191
end

function var0_0.getSkillList(arg0_192)
	local var0_192 = pg.ship_data_template[arg0_192.configId]
	local var1_192 = Clone(var0_192.buff_list_display)
	local var2_192 = Clone(var0_192.buff_list)
	local var3_192 = pg.ship_data_trans[arg0_192.groupId]
	local var4_192 = 0

	if var3_192 and var3_192.skill_id ~= 0 then
		local var5_192 = var3_192.skill_id
		local var6_192 = pg.transform_data_template[var5_192]

		if arg0_192.transforms[var5_192] and var6_192.skill_id ~= 0 then
			table.insert(var2_192, var6_192.skill_id)
		end
	end

	local var7_192 = {}

	for iter0_192, iter1_192 in ipairs(var1_192) do
		for iter2_192, iter3_192 in ipairs(var2_192) do
			if iter1_192 == iter3_192 then
				table.insert(var7_192, arg0_192:fateSkillChange(iter1_192))
			end
		end
	end

	return var7_192
end

function var0_0.getModAttrTopLimit(arg0_193, arg1_193)
	local var0_193 = ShipModAttr.ATTR_TO_INDEX[arg1_193]
	local var1_193 = pg.ship_data_template[arg0_193.configId].strengthen_id
	local var2_193 = pg.ship_data_strengthen[var1_193].durability[var0_193]

	return calcFloor((3 + 7 * (math.min(arg0_193.level, 100) / 100)) * var2_193 * 0.1)
end

function var0_0.leftModAdditionPoint(arg0_194, arg1_194)
	local var0_194 = arg0_194:getModProperties(arg1_194)
	local var1_194 = arg0_194:getModExpRatio(arg1_194)
	local var2_194 = arg0_194:getModAttrTopLimit(arg1_194)
	local var3_194 = calcFloor(var0_194 / var1_194)

	return math.max(0, var2_194 - var3_194)
end

function var0_0.getModAttrBaseMax(arg0_195, arg1_195)
	if not table.contains(arg0_195:getConfig("lock"), arg1_195) then
		local var0_195 = arg0_195:leftModAdditionPoint(arg1_195)
		local var1_195 = arg0_195:getShipProperties()

		return calcFloor(var1_195[arg1_195] + var0_195)
	else
		return 0
	end
end

function var0_0.getModExpRatio(arg0_196, arg1_196)
	if not table.contains(arg0_196:getConfig("lock"), arg1_196) then
		local var0_196 = pg.ship_data_template[arg0_196.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0_196], "ship_data_strengthen>>>>>>" .. var0_196)

		return math.max(pg.ship_data_strengthen[var0_196].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1_196]], 1)
	else
		return 1
	end
end

function var0_0.inUnlockTip(arg0_197)
	local var0_197 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0_197, arg0_197)
end

function var0_0.proposeSkinOwned(arg0_198, arg1_198)
	return arg1_198 and arg0_198.propose and arg1_198.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0_0.getProposeSkin(arg0_199)
	return ShipSkin.GetSkinByType(arg0_199.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getDisplaySkillIds(arg0_200)
	return _.map(pg.ship_data_template[arg0_200.configId].buff_list_display, function(arg0_201)
		return arg0_200:fateSkillChange(arg0_201)
	end)
end

function var0_0.isFullSkillLevel(arg0_202)
	local var0_202 = pg.skill_data_template

	for iter0_202, iter1_202 in pairs(arg0_202.skills) do
		if var0_202[iter1_202.id].max_level ~= iter1_202.level then
			return false
		end
	end

	return true
end

function var0_0.setEquipmentRecord(arg0_203, arg1_203, arg2_203)
	local var0_203 = "equipment_record" .. "_" .. arg1_203 .. "_" .. arg0_203.id

	PlayerPrefs.SetString(var0_203, table.concat(_.flatten(arg2_203), ":"))
	PlayerPrefs.Save()
end

function var0_0.getEquipmentRecord(arg0_204, arg1_204)
	if not arg0_204.equipmentRecords then
		local var0_204 = "equipment_record" .. "_" .. arg1_204 .. "_" .. arg0_204.id
		local var1_204 = string.split(PlayerPrefs.GetString(var0_204) or "", ":")
		local var2_204 = {}

		for iter0_204 = 1, 3 do
			var2_204[iter0_204] = _.map(_.slice(var1_204, 5 * iter0_204 - 4, 5), function(arg0_205)
				return tonumber(arg0_205)
			end)
		end

		arg0_204.equipmentRecords = var2_204
	end

	return arg0_204.equipmentRecords
end

function var0_0.SetSpWeaponRecord(arg0_206, arg1_206, arg2_206)
	local var0_206 = "spweapon_record" .. "_" .. arg1_206 .. "_" .. arg0_206.id
	local var1_206 = _.map({
		1,
		2,
		3
	}, function(arg0_207)
		local var0_207 = arg2_206[arg0_207]

		if var0_207 then
			return (var0_207:GetUID() or 0) .. "," .. var0_207:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0_206, table.concat(var1_206, ":"))
	PlayerPrefs.Save()
end

function var0_0.GetSpWeaponRecord(arg0_208, arg1_208)
	local var0_208 = "spweapon_record" .. "_" .. arg1_208 .. "_" .. arg0_208.id

	return (_.map(string.split(PlayerPrefs.GetString(var0_208, ""), ":"), function(arg0_209)
		local var0_209 = string.split(arg0_209, ",")

		assert(var0_209)

		local var1_209 = tonumber(var0_209[1])
		local var2_209 = tonumber(var0_209[2])

		if not var2_209 or var2_209 == 0 then
			return false
		end

		return (SpWeapon.New({
			id = var2_209
		}))
	end))
end

function var0_0.hasEquipEquipmentSkin(arg0_210)
	for iter0_210, iter1_210 in ipairs(arg0_210.equipments) do
		if iter1_210 and iter1_210:hasSkin() then
			return true
		end
	end

	return false
end

function var0_0.hasCommander(arg0_211)
	return arg0_211.commanderId and arg0_211.commanderId ~= 0
end

function var0_0.getCommander(arg0_212)
	return arg0_212.commanderId
end

function var0_0.setCommander(arg0_213, arg1_213)
	arg0_213.commanderId = arg1_213
end

function var0_0.getSkillIndex(arg0_214, arg1_214)
	local var0_214 = arg0_214:getSkillList()

	for iter0_214, iter1_214 in ipairs(var0_214) do
		if arg1_214 == iter1_214 then
			return iter0_214
		end
	end
end

function var0_0.getTactics(arg0_215)
	return 1, "tactics_attack"
end

function var0_0.IsBgmSkin(arg0_216)
	local var0_216 = arg0_216:GetSkinConfig()

	return table.contains(var0_216.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_217)
	if arg0_217:IsBgmSkin() then
		return arg0_217:GetSkinConfig().bgm
	end
end

function var0_0.isIntensifyMax(arg0_218)
	local var0_218 = intProperties(arg0_218:getShipProperties())

	if arg0_218:isBluePrintShip() then
		return true
	end

	for iter0_218, iter1_218 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_218:getModAttrBaseMax(iter1_218) ~= var0_218[iter1_218] then
			return false
		end
	end

	return true
end

function var0_0.isRemouldable(arg0_219)
	return not arg0_219:isTestShip() and not arg0_219:isBluePrintShip() and pg.ship_data_trans[arg0_219.groupId]
end

function var0_0.isAllRemouldFinish(arg0_220)
	local var0_220 = pg.ship_data_trans[arg0_220.groupId]

	assert(var0_220, "this ship group without remould config:" .. arg0_220.groupId)

	for iter0_220, iter1_220 in ipairs(var0_220.transform_list) do
		for iter2_220, iter3_220 in ipairs(iter1_220) do
			local var1_220 = pg.transform_data_template[iter3_220[2]]

			if #var1_220.edit_trans > 0 then
				-- block empty
			elseif not arg0_220.transforms[iter3_220[2]] or arg0_220.transforms[iter3_220[2]].level < var1_220.max_level then
				return false
			end
		end
	end

	return true
end

function var0_0.isSpecialFilter(arg0_221)
	local var0_221 = pg.ship_data_statistics[arg0_221.configId]

	assert(var0_221, "this ship without statistics:" .. arg0_221.configId)

	for iter0_221, iter1_221 in ipairs(var0_221.tag_list) do
		if iter1_221 == "special" then
			return true
		end
	end

	return false
end

function var0_0.hasAvailiableSkin(arg0_222)
	local var0_222 = getProxy(ShipSkinProxy)
	local var1_222 = var0_222:GetAllSkinForShip(arg0_222)
	local var2_222 = var0_222:getRawData()
	local var3_222 = 0

	for iter0_222, iter1_222 in ipairs(var1_222) do
		if arg0_222:proposeSkinOwned(iter1_222) or var2_222[iter1_222.id] or var0_222:hasSkin(iter1_222.id) then
			var3_222 = var3_222 + 1
		end
	end

	return var3_222 > 0
end

function var0_0.hasProposeSkin(arg0_223)
	local var0_223 = getProxy(ShipSkinProxy)
	local var1_223 = var0_223:GetAllSkinForShip(arg0_223)

	for iter0_223, iter1_223 in ipairs(var1_223) do
		if iter1_223.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2_223 = var0_223:GetShareSkinsForShip(arg0_223)

	for iter2_223, iter3_223 in ipairs(var2_223) do
		if iter3_223.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0_0.HasUniqueSpWeapon(arg0_224)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0_224:getGroupId()])
end

function var0_0.getAircraftReloadCD(arg0_225)
	local var0_225 = arg0_225:getConfigTable().base_list
	local var1_225 = arg0_225:getConfigTable().default_equip_list
	local var2_225 = 0
	local var3_225 = 0

	for iter0_225 = 1, 3 do
		local var4_225 = arg0_225:getEquip(iter0_225)
		local var5_225 = var4_225 and var4_225.configId or var1_225[iter0_225]
		local var6_225 = Equipment.getConfigData(var5_225).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0_226)
			return var6_225 == arg0_226
		end) then
			var2_225 = var2_225 + Equipment.GetEquipReloadStatic(var5_225) * var0_225[iter0_225]
			var3_225 = var3_225 + var0_225[iter0_225]
		end
	end

	local var7_225 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2_225 / var3_225 * var7_225
	}
end

function var0_0.IsTagShip(arg0_227, arg1_227)
	local var0_227 = arg0_227:getConfig("tag_list")

	return table.contains(var0_227, arg1_227)
end

function var0_0.setReMetaSpecialItemVO(arg0_228, arg1_228)
	arg0_228.reMetaSpecialItemVO = arg1_228
end

function var0_0.getReMetaSpecialItemVO(arg0_229, arg1_229)
	return arg0_229.reMetaSpecialItemVO
end

function var0_0.getProposeType(arg0_230)
	if arg0_230:isMetaShip() then
		return "meta"
	elseif arg0_230:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_231)
	return arg0_231:getNation() == Nation.IDOL_LINK
end

function var0_0.getSpecificType(arg0_232)
	return pg.ship_data_template[arg0_232.configId].specific_type
end

function var0_0.GetSpWeapon(arg0_233)
	return arg0_233.spWeapon
end

function var0_0.UpdateSpWeapon(arg0_234, arg1_234)
	local var0_234 = (arg1_234 and arg1_234:GetUID() or 0) == (arg0_234.spWeapon and arg0_234.spWeapon:GetUID() or 0)

	arg0_234.spWeapon = arg1_234

	if arg1_234 then
		arg1_234:SetShipId(arg0_234.id)
	end

	if var0_234 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0_0.CanEquipSpWeapon(arg0_235, arg1_235)
	local var0_235, var1_235 = arg0_235:IsSpWeaponForbidden(arg1_235)

	if var0_235 then
		return false, var1_235
	end

	return true
end

function var0_0.IsSpWeaponForbidden(arg0_236, arg1_236)
	local var0_236 = arg1_236:GetWearableShipTypes()
	local var1_236 = arg0_236:getShipType()

	if not table.contains(var0_236, var1_236) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2_236 = arg1_236:GetUniqueGroup()
	local var3_236 = arg0_236:getGroupId()

	if var2_236 ~= 0 and var2_236 ~= var3_236 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0_0.GetMapStrikeAnim(arg0_237)
	local var0_237
	local var1_237 = arg0_237:getShipType()

	switch(TeamType.GetTeamFromShipType(var1_237), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1_237) then
				var0_237 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1_237) then
				var0_237 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1_237) then
				var0_237 = "CannonUI"
			else
				var0_237 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1_237) then
				var0_237 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0_237:getNation() == Nation.MOT then
				var0_237 = "CannonUI"
			else
				var0_237 = "SubTorpedoUI"
			end
		end
	})

	return var0_237
end

function var0_0.IsDefaultSkin(arg0_241)
	local var0_241 = arg0_241:getSkinId()

	return var0_241 == 0 or var0_241 == arg0_241:getConfig("skin_id")
end

function var0_0.IsMatchKey(arg0_242, arg1_242)
	if not arg1_242 or arg1_242 == "" then
		return true
	end

	arg1_242 = string.lower(string.gsub(arg1_242, "%.", "%%."))

	local var0_242 = {
		arg0_242:getName(),
		arg0_242:GetDefaultName()
	}

	if var0_242[1] == var0_242[2] then
		table.remove(var0_242)
	end

	return underscore.any(var0_242, function(arg0_243)
		return string.find(string.lower(arg0_243), arg1_242)
	end)
end

function var0_0.IsOwner(arg0_244)
	return tobool(arg0_244.id)
end

function var0_0.GetUniqueId(arg0_245)
	return arg0_245.id
end

function var0_0.ShowPropose(arg0_246)
	if not arg0_246.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0_246:IsOwner() and arg0_246:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0_0.GetColorName(arg0_247, arg1_247)
	arg1_247 = arg1_247 or arg0_247:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0_247.propose then
		return setColorStr(arg1_247, "#FFAACEFF")
	else
		return arg1_247
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

function var0_0.GetFrameAndEffect(arg0_248, arg1_248)
	arg1_248 = tobool(arg1_248)

	local var0_248
	local var1_248

	if arg0_248.propose then
		if arg0_248:isMetaShip() then
			var1_248 = string.format(var9_0.effect[1])
			var0_248 = string.format(var9_0.frame[1])
		elseif arg0_248:isBluePrintShip() then
			var1_248 = string.format(var9_0.effect[2])
			var0_248 = string.format(var9_0.frame[2], arg0_248:rarity2bgPrint())
		else
			var1_248 = string.format(var9_0.effect[3])
			var0_248 = string.format(var9_0.frame[3])
		end

		if not arg0_248:ShowPropose() then
			var0_248 = nil
		end
	elseif arg0_248:isMetaShip() then
		var1_248 = string.format(var9_0.effect[4], arg0_248:rarity2bgPrint())
	elseif arg0_248:getRarity() == ShipRarity.SSR then
		var1_248 = string.format(var9_0.effect[5])
	end

	if arg1_248 then
		var1_248 = var1_248 and var1_248 .. "_1"
	end

	return var0_248, var1_248
end

function var0_0.GetRecordPosKey(arg0_249)
	return arg0_249:getSkinId()
end

function var0_0.GetShipPhantomMark(arg0_250, arg1_250)
	return ShipPhantom.PackMark(arg0_250.id, arg1_250)
end

function var0_0.GetSelectMark(arg0_251)
	return arg0_251.id
end

return var0_0
