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

function var0_0.getPrefab(arg0_71)
	local var0_71 = arg0_71:getSkinId()

	if arg0_71:hasEquipmentSkinInPos(var2_0) then
		local var1_71 = arg0_71:getEquip(var2_0)
		local var2_71 = var7_0[var1_71:getSkinId()].ship_skin_id

		var0_71 = var2_71 ~= 0 and var2_71 or var0_71
	end

	local var3_71 = pg.ship_skin_template[var0_71]

	assert(var3_71, "ship_skin_template not exist: " .. arg0_71.configId .. " " .. var0_71)

	return var3_71.prefab
end

function var0_0.getAttachmentPrefab(arg0_72)
	local var0_72 = {}

	for iter0_72, iter1_72 in ipairs(arg0_72.equipments) do
		if iter1_72 and iter1_72:hasSkinOrbit() then
			local var1_72 = iter1_72:getSkinId()
			local var2_72 = var7_0[var1_72]

			var0_72[var1_72] = {
				config = var2_72,
				index = iter0_72
			}
		end
	end

	return var0_72
end

function var0_0.getPainting(arg0_73)
	local var0_73 = arg0_73:getSkinId()
	local var1_73 = pg.ship_skin_template[var0_73]

	assert(var1_73, "ship_skin_template not exist: " .. arg0_73.configId .. " " .. var0_73)

	return var1_73.painting
end

function var0_0.GetSkinConfig(arg0_74, arg1_74)
	local var0_74 = arg0_74:getSkinId()
	local var1_74 = pg.ship_skin_template[var0_74]

	assert(var1_74, "ship_skin_template not exist: " .. arg0_74.configId .. " " .. var0_74)

	return var1_74
end

function var0_0.getRemouldPainting(arg0_75)
	local var0_75 = arg0_75:getRemouldSkinId()
	local var1_75 = pg.ship_skin_template[var0_75]

	assert(var1_75, "ship_skin_template not exist: " .. arg0_75.configId .. " " .. var0_75)

	return var1_75.painting
end

function var0_0.updateStateInfo34(arg0_76, arg1_76, arg2_76)
	arg0_76.state_info_3 = arg1_76
	arg0_76.state_info_4 = arg2_76
end

function var0_0.hasStateInfo3Or4(arg0_77)
	return arg0_77.state_info_3 ~= 0 or arg0_77.state_info_4 ~= 0
end

function var0_0.isTestShip(arg0_78)
	return arg0_78.testShip
end

function var0_0.canUseTestShip(arg0_79, arg1_79)
	assert(arg0_79.testShip, "ship is not TestShip")

	return table.contains(arg0_79.testShip, arg1_79)
end

function var0_0.updateEquip(arg0_80, arg1_80, arg2_80)
	assert(arg2_80 == nil or arg2_80.count == 1)

	local var0_80 = arg0_80.equipments[arg1_80]

	arg0_80.equipments[arg1_80] = arg2_80 and Clone(arg2_80) or false

	local function var1_80(arg0_81)
		arg0_81 = CreateShell(arg0_81)
		arg0_81.shipId = arg0_80.id
		arg0_81.shipPos = arg1_80

		return arg0_81
	end

	if var0_80 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0_80, arg0_80.id, arg1_80)
		var0_80:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1_80(var0_80))
	end

	if arg2_80 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2_80, arg0_80.id, arg1_80)
		arg0_80:reletiveEquipSkin(arg1_80)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1_80(arg2_80))
	end
end

function var0_0.reletiveEquipSkin(arg0_82, arg1_82)
	if arg0_82.equipments[arg1_82] and arg0_82.equipmentSkins[arg1_82] ~= 0 then
		local var0_82 = pg.equip_skin_template[arg0_82.equipmentSkins[arg1_82]].equip_type
		local var1_82 = arg0_82.equipments[arg1_82]:getType()

		if table.contains(var0_82, var1_82) then
			arg0_82.equipments[arg1_82]:setSkinId(arg0_82.equipmentSkins[arg1_82])
		else
			arg0_82.equipments[arg1_82]:setSkinId(0)
		end
	elseif arg0_82.equipments[arg1_82] then
		arg0_82.equipments[arg1_82]:setSkinId(0)
	end
end

function var0_0.updateEquipmentSkin(arg0_83, arg1_83, arg2_83)
	if not arg1_83 then
		return
	end

	if arg2_83 and arg2_83 > 0 then
		local var0_83 = arg0_83:getSkinTypes(arg1_83)
		local var1_83 = pg.equip_skin_template[arg2_83].equip_type
		local var2_83 = false

		for iter0_83, iter1_83 in ipairs(var0_83) do
			for iter2_83, iter3_83 in ipairs(var1_83) do
				if iter1_83 == iter3_83 then
					var2_83 = true

					break
				end
			end
		end

		if not var2_83 then
			assert(var2_83, "部位" .. arg1_83 .. " 无法穿戴皮肤 " .. arg2_83)

			return
		end

		local var3_83 = arg0_83.equipments[arg1_83] and arg0_83.equipments[arg1_83]:getType() or false

		arg0_83.equipmentSkins[arg1_83] = arg2_83

		if var3_83 and table.contains(var1_83, var3_83) then
			arg0_83.equipments[arg1_83]:setSkinId(arg0_83.equipmentSkins[arg1_83])
		elseif var3_83 and not table.contains(var1_83, var3_83) then
			arg0_83.equipments[arg1_83]:setSkinId(0)
		end
	else
		arg0_83.equipmentSkins[arg1_83] = 0

		if arg0_83.equipments[arg1_83] then
			arg0_83.equipments[arg1_83]:setSkinId(0)
		end
	end
end

function var0_0.getEquip(arg0_84, arg1_84)
	return Clone(arg0_84.equipments[arg1_84])
end

function var0_0.getEquipSkins(arg0_85)
	return Clone(arg0_85.equipmentSkins)
end

function var0_0.getEquipSkin(arg0_86, arg1_86)
	return arg0_86.equipmentSkins[arg1_86]
end

function var0_0.getCanEquipSkin(arg0_87, arg1_87)
	local var0_87 = arg0_87:getSkinTypes(arg1_87)

	if var0_87 and #var0_87 then
		for iter0_87, iter1_87 in ipairs(var0_87) do
			if pg.equip_data_by_type[iter1_87].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0_0.checkCanEquipSkin(arg0_88, arg1_88, arg2_88)
	if not arg1_88 or not arg2_88 then
		return
	end

	local var0_88 = arg0_88:getSkinTypes(arg1_88)
	local var1_88 = pg.equip_skin_template[arg2_88].equip_type

	for iter0_88, iter1_88 in ipairs(var0_88) do
		if table.contains(var1_88, iter1_88) then
			return true
		end
	end

	return false
end

function var0_0.getSkinTypes(arg0_89, arg1_89)
	return pg.ship_data_template[arg0_89.configId]["equip_" .. arg1_89] or {}
end

function var0_0.updateState(arg0_90, arg1_90)
	arg0_90.state = arg1_90
end

function var0_0.addSkillExp(arg0_91, arg1_91, arg2_91)
	local var0_91 = arg0_91.skills[arg1_91] or {
		exp = 0,
		level = 1,
		id = arg1_91
	}
	local var1_91 = var0_91.level and var0_91.level or 1
	local var2_91 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1_91 == var2_91 then
		return
	end

	local var3_91 = var0_91.exp and arg2_91 + var0_91.exp or 0 + arg2_91

	while var3_91 >= pg.skill_need_exp[var1_91].exp do
		var3_91 = var3_91 - pg.skill_need_exp[var1_91].exp
		var1_91 = var1_91 + 1

		if var1_91 == var2_91 then
			var3_91 = 0

			break
		end
	end

	arg0_91:updateSkill({
		id = var0_91.id,
		level = var1_91,
		exp = var3_91
	})
end

function var0_0.upSkillLevelForMeta(arg0_92, arg1_92)
	local var0_92 = arg0_92.skills[arg1_92] or {
		exp = 0,
		level = 0,
		id = arg1_92
	}
	local var1_92 = arg0_92:isSkillLevelMax(arg1_92)
	local var2_92 = var0_92.level

	if not var1_92 then
		var2_92 = var2_92 + 1
	end

	arg0_92:updateSkill({
		exp = 0,
		id = var0_92.id,
		level = var2_92
	})
end

function var0_0.getMetaSkillLevelBySkillID(arg0_93, arg1_93)
	return (arg0_93.skills[arg1_93] or {
		exp = 0,
		level = 0,
		id = arg1_93
	}).level
end

function var0_0.isSkillLevelMax(arg0_94, arg1_94)
	local var0_94 = arg0_94.skills[arg1_94] or {
		exp = 0,
		level = 1,
		id = arg1_94
	}

	return (var0_94.level and var0_94.level or 1) >= pg.skill_data_template[arg1_94].max_level
end

function var0_0.isAllMetaSkillLevelMax(arg0_95)
	local var0_95 = true
	local var1_95 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_95.configId)

	for iter0_95, iter1_95 in ipairs(var1_95) do
		if not arg0_95:isSkillLevelMax(iter1_95) then
			var0_95 = false

			break
		end
	end

	return var0_95
end

function var0_0.isAllMetaSkillLock(arg0_96)
	local var0_96 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_96.configId)
	local var1_96 = true

	for iter0_96, iter1_96 in ipairs(var0_96) do
		if arg0_96:getMetaSkillLevelBySkillID(iter1_96) > 0 then
			var1_96 = false

			break
		end
	end

	return var1_96
end

function var0_0.bindConfigTable(arg0_97)
	return pg.ship_data_statistics
end

function var0_0.isAvaiable(arg0_98)
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

function var0_0.intimacyAdditions(arg0_99, arg1_99)
	local var0_99 = pg.intimacy_template[arg0_99:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0_99, iter1_99 in pairs(arg1_99) do
		if iter0_99 == AttributeType.Durability or iter0_99 == AttributeType.Cannon or iter0_99 == AttributeType.Torpedo or iter0_99 == AttributeType.AntiAircraft or iter0_99 == AttributeType.AntiSub or iter0_99 == AttributeType.Air or iter0_99 == AttributeType.Reload or iter0_99 == AttributeType.Hit or iter0_99 == AttributeType.Dodge then
			arg1_99[iter0_99] = arg1_99[iter0_99] * (var0_99 + 1)
		end
	end
end

function var0_0.getShipProperties(arg0_100)
	local var0_100 = arg0_100:getBaseProperties()

	if arg0_100:isBluePrintShip() then
		local var1_100 = arg0_100:getBluePrint()

		assert(var1_100, "blueprint can not be nil" .. arg0_100.configId)

		local var2_100 = var1_100:getTotalAdditions()

		for iter0_100, iter1_100 in pairs(var2_100) do
			var0_100[iter0_100] = var0_100[iter0_100] + calcFloor(iter1_100)
		end

		arg0_100:intimacyAdditions(var0_100)
	elseif arg0_100:isMetaShip() then
		assert(arg0_100.metaCharacter)

		for iter2_100, iter3_100 in pairs(var0_100) do
			var0_100[iter2_100] = var0_100[iter2_100] + arg0_100.metaCharacter:getAttrAddition(iter2_100)
		end

		arg0_100:intimacyAdditions(var0_100)
	else
		local var3_100 = pg.ship_data_template[arg0_100.configId].strengthen_id
		local var4_100 = var5_0[var3_100]

		for iter4_100, iter5_100 in pairs(arg0_100.strengthList) do
			local var5_100 = ShipModAttr.ATTR_TO_INDEX[iter4_100]
			local var6_100 = math.min(iter5_100, var4_100.durability[var5_100] * var4_100.level_exp[var5_100])
			local var7_100 = math.max(arg0_100:getModExpRatio(iter4_100), 1)

			var0_100[iter4_100] = var0_100[iter4_100] + calcFloor(var6_100 / var7_100)
		end

		arg0_100:intimacyAdditions(var0_100)

		for iter6_100, iter7_100 in pairs(arg0_100.transforms) do
			local var8_100 = pg.transform_data_template[iter7_100.id].effect

			for iter8_100 = 1, iter7_100.level do
				local var9_100 = var8_100[iter8_100] or {}

				for iter9_100, iter10_100 in pairs(var0_100) do
					if var9_100[iter9_100] then
						var0_100[iter9_100] = var0_100[iter9_100] + var9_100[iter9_100]
					end
				end
			end
		end
	end

	return var0_100
end

function var0_0.getTechNationAddition(arg0_101, arg1_101)
	local var0_101 = getProxy(TechnologyNationProxy)
	local var1_101 = arg0_101:getConfig("type")

	if var1_101 == ShipType.DaoQuV or var1_101 == ShipType.DaoQuM then
		var1_101 = ShipType.QuZhu
	end

	return var0_101:getShipAddition(var1_101, arg1_101)
end

function var0_0.getTechNationMaxAddition(arg0_102, arg1_102)
	local var0_102 = getProxy(TechnologyNationProxy)
	local var1_102 = arg0_102:getConfig("type")

	return var0_102:getShipMaxAddition(var1_102, arg1_102)
end

function var0_0.getEquipProficiencyByPos(arg0_103, arg1_103)
	return arg0_103:getEquipProficiencyList()[arg1_103]
end

function var0_0.getEquipProficiencyList(arg0_104)
	local var0_104 = arg0_104:getConfigTable()
	local var1_104 = Clone(var0_104.equipment_proficiency)

	if arg0_104:isBluePrintShip() then
		local var2_104 = arg0_104:getBluePrint()

		assert(var2_104, "blueprint can not be nil >>>" .. arg0_104.groupId)

		var1_104 = var2_104:getEquipProficiencyList(arg0_104)
	else
		for iter0_104, iter1_104 in ipairs(var1_104) do
			local var3_104 = 0

			for iter2_104, iter3_104 in pairs(arg0_104.transforms) do
				local var4_104 = pg.transform_data_template[iter3_104.id].effect

				for iter4_104 = 1, iter3_104.level do
					local var5_104 = var4_104[iter4_104] or {}

					if var5_104["equipment_proficiency_" .. iter0_104] then
						var3_104 = var3_104 + var5_104["equipment_proficiency_" .. iter0_104]
					end
				end
			end

			var1_104[iter0_104] = iter1_104 + var3_104
		end
	end

	return var1_104
end

function var0_0.getBaseProperties(arg0_105)
	local var0_105 = arg0_105:getConfigTable()

	assert(var0_105, "配置表没有这艘船" .. arg0_105.configId)

	local var1_105 = {}
	local var2_105 = {}

	for iter0_105, iter1_105 in ipairs(var0_0.PROPERTIES) do
		var1_105[iter1_105] = arg0_105:getGrowthForAttr(iter1_105)
		var2_105[iter1_105] = var1_105[iter1_105]
	end

	for iter2_105, iter3_105 in ipairs(arg0_105:getConfig("lock")) do
		var2_105[iter3_105] = var1_105[iter3_105]
	end

	for iter4_105, iter5_105 in ipairs(var0_0.DIVE_PROPERTIES) do
		var2_105[iter5_105] = var0_105[iter5_105]
	end

	for iter6_105, iter7_105 in ipairs(var0_0.SONAR_PROPERTIES) do
		var2_105[iter7_105] = 0
	end

	return var2_105
end

function var0_0.getGrowthForAttr(arg0_106, arg1_106)
	local var0_106 = arg0_106:getConfigTable()
	local var1_106 = table.indexof(var0_0.PROPERTIES, arg1_106)
	local var2_106 = pg.gameset.extra_attr_level_limit.key_value
	local var3_106 = var0_106.attrs[var1_106] + (arg0_106.level - 1) * var0_106.attrs_growth[var1_106] / 1000

	if var2_106 < arg0_106.level then
		var3_106 = var3_106 + (arg0_106.level - var2_106) * var0_106.attrs_growth_extra[var1_106] / 1000
	end

	return var3_106
end

function var0_0.isMaxStar(arg0_107)
	return arg0_107:getStar() >= arg0_107:getMaxStar()
end

function var0_0.IsMaxStarByTmpID(arg0_108)
	local var0_108 = pg.ship_data_template[arg0_108]

	return var0_108.star >= var0_108.star_max
end

function var0_0.IsSpweaponUnlock(arg0_109)
	if not arg0_109:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0_0.getModProperties(arg0_110, arg1_110)
	return arg0_110.strengthList[arg1_110] or 0
end

function var0_0.addModAttrExp(arg0_111, arg1_111, arg2_111)
	local var0_111 = arg0_111:getModAttrTopLimit(arg1_111)

	if var0_111 == 0 then
		return
	end

	local var1_111 = arg0_111:getModExpRatio(arg1_111)
	local var2_111 = arg0_111:getModProperties(arg1_111)

	if var2_111 + arg2_111 > var0_111 * var1_111 then
		arg0_111.strengthList[arg1_111] = var0_111 * var1_111
	else
		arg0_111.strengthList[arg1_111] = var2_111 + arg2_111
	end
end

function var0_0.getNeedModExp(arg0_112)
	local var0_112 = {}

	for iter0_112, iter1_112 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1_112 = arg0_112:getModAttrTopLimit(iter1_112)

		if var1_112 == 0 then
			var0_112[iter1_112] = 0
		else
			var0_112[iter1_112] = var1_112 * arg0_112:getModExpRatio(iter1_112) - arg0_112:getModProperties(iter1_112)
		end
	end

	return var0_112
end

function var0_0.attrVertify(arg0_113)
	if not BayProxy.checkShiplevelVertify(arg0_113) then
		return false
	end

	for iter0_113, iter1_113 in ipairs(arg0_113.equipments) do
		if iter1_113 and not iter1_113:vertify() then
			return false
		end
	end

	return true
end

function var0_0.getEquipmentProperties(arg0_114)
	local var0_114 = {}
	local var1_114 = {}

	for iter0_114, iter1_114 in ipairs(var0_0.PROPERTIES) do
		var0_114[iter1_114] = 0
	end

	for iter2_114, iter3_114 in ipairs(var0_0.DIVE_PROPERTIES) do
		var0_114[iter3_114] = 0
	end

	for iter4_114, iter5_114 in ipairs(var0_0.SONAR_PROPERTIES) do
		var0_114[iter5_114] = 0
	end

	for iter6_114, iter7_114 in ipairs(var0_0.PROPERTIES_ENHANCEMENT) do
		var1_114[iter7_114] = 0
	end

	var0_114[AttributeType.AirDominate] = 0
	var0_114[AttributeType.AntiSiren] = 0

	local var2_114 = arg0_114:getActiveEquipments()

	for iter8_114, iter9_114 in ipairs(var2_114) do
		if iter9_114 then
			local var3_114 = iter9_114:GetAttributes()

			for iter10_114, iter11_114 in ipairs(var3_114) do
				if iter11_114 and var0_114[iter11_114.type] then
					var0_114[iter11_114.type] = var0_114[iter11_114.type] + iter11_114.value
				end
			end

			local var4_114 = iter9_114:GetPropertyRate()

			for iter12_114, iter13_114 in pairs(var4_114) do
				var1_114[iter12_114] = math.max(var1_114[iter12_114], iter13_114)
			end

			local var5_114 = iter9_114:GetSonarProperty()

			if var5_114 then
				for iter14_114, iter15_114 in pairs(var5_114) do
					var0_114[iter14_114] = var0_114[iter14_114] + iter15_114
				end
			end

			local var6_114 = iter9_114:GetAntiSirenPower()

			if var6_114 then
				var0_114[AttributeType.AntiSiren] = var0_114[AttributeType.AntiSiren] + var6_114 / 10000
			end
		end
	end

	;(function()
		local var0_115 = arg0_114:GetSpWeapon()

		if not var0_115 then
			return
		end

		local var1_115 = var0_115:GetPropertiesInfo().attrs

		for iter0_115, iter1_115 in ipairs(var1_115) do
			if iter1_115 and var0_114[iter1_115.type] then
				var0_114[iter1_115.type] = var0_114[iter1_115.type] + iter1_115.value
			end
		end
	end)()

	for iter16_114, iter17_114 in pairs(var1_114) do
		var1_114[iter16_114] = iter17_114 + 1
	end

	return var0_114, var1_114
end

function var0_0.getSkillEffects(arg0_116)
	local var0_116 = arg0_116:getShipSkillEffects()

	_.each(arg0_116:getEquipmentSkillEffects(), function(arg0_117)
		table.insert(var0_116, arg0_117)
	end)

	return var0_116
end

function var0_0.getShipSkillEffects(arg0_118)
	local var0_118 = {}
	local var1_118 = arg0_118:getSkillList()

	for iter0_118, iter1_118 in ipairs(var1_118) do
		local var2_118 = arg0_118:RemapSkillId(iter1_118)
		local var3_118 = pg.buffCfg["buff_" .. var2_118]

		arg0_118:FilterActiveSkill(var0_118, var3_118, arg0_118.skills[iter1_118])
	end

	return var0_118
end

function var0_0.getEquipmentSkillEffects(arg0_119)
	local var0_119 = {}
	local var1_119 = arg0_119:getActiveEquipments()

	for iter0_119, iter1_119 in ipairs(var1_119) do
		local var2_119
		local var3_119 = iter1_119 and iter1_119:getConfig("skill_id")[1] and iter1_119:getConfig("skill_id")[1][1]

		if var3_119 then
			var2_119 = pg.buffCfg["buff_" .. var3_119]
		end

		arg0_119:FilterActiveSkill(var0_119, var2_119)
	end

	;(function()
		local var0_120 = arg0_119:GetSpWeapon()
		local var1_120 = var0_120 and var0_120:GetEffect() or 0
		local var2_120

		if var1_120 > 0 then
			var2_120 = pg.buffCfg["buff_" .. var1_120]
		end

		arg0_119:FilterActiveSkill(var0_119, var2_120)
	end)()

	return var0_119
end

function var0_0.FilterActiveSkill(arg0_121, arg1_121, arg2_121, arg3_121)
	if not arg2_121 or not arg2_121.const_effect_list then
		return
	end

	for iter0_121 = 1, #arg2_121.const_effect_list do
		local var0_121 = arg2_121.const_effect_list[iter0_121]
		local var1_121 = var0_121.trigger
		local var2_121 = var0_121.arg_list
		local var3_121 = 1

		if arg3_121 then
			var3_121 = arg3_121.level

			local var4_121 = arg2_121[var3_121].const_effect_list

			if var4_121 and var4_121[iter0_121] then
				var1_121 = var4_121[iter0_121].trigger or var1_121
				var2_121 = var4_121[iter0_121].arg_list or var2_121
			end
		end

		local var5_121 = true

		for iter1_121, iter2_121 in pairs(var1_121) do
			if arg0_121.triggers[iter1_121] ~= iter2_121 then
				var5_121 = false

				break
			end
		end

		if var5_121 then
			table.insert(arg1_121, {
				type = var0_121.type,
				arg_list = var2_121,
				level = var3_121
			})
		end
	end
end

function var0_0.getEquipmentGearScore(arg0_122)
	local var0_122 = 0
	local var1_122 = arg0_122:getActiveEquipments()

	for iter0_122, iter1_122 in ipairs(var1_122) do
		if iter1_122 then
			var0_122 = var0_122 + iter1_122:GetGearScore()
		end
	end

	return var0_122
end

function var0_0.getProperties(arg0_123, arg1_123, arg2_123, arg3_123, arg4_123)
	local var0_123 = arg1_123 or {}
	local var1_123 = arg0_123:getConfig("nationality")
	local var2_123 = arg0_123:getConfig("type")
	local var3_123 = arg0_123:getShipProperties()
	local var4_123, var5_123 = arg0_123:getEquipmentProperties()
	local var6_123
	local var7_123
	local var8_123

	if arg3_123 and arg0_123:getFlag("inWorld") then
		local var9_123 = WorldConst.FetchWorldShip(arg0_123.id)

		var6_123, var7_123 = var9_123:GetShipBuffProperties()
		var8_123 = var9_123:GetShipPowerBuffProperties()
	end

	for iter0_123, iter1_123 in ipairs(var0_0.PROPERTIES) do
		local var10_123 = 0
		local var11_123 = 0

		for iter2_123, iter3_123 in pairs(var0_123) do
			var10_123 = var10_123 + iter3_123:getAttrRatioAddition(iter1_123, var1_123, var2_123) / 100
			var11_123 = var11_123 + iter3_123:getAttrValueAddition(iter1_123, var1_123, var2_123)
		end

		local var12_123 = var10_123 + (var5_123[iter1_123] or 1)
		local var13_123 = var7_123 and var7_123[iter1_123] or 1
		local var14_123 = var6_123 and var6_123[iter1_123] or 0

		if iter1_123 == AttributeType.Speed then
			var3_123[iter1_123] = var3_123[iter1_123] * var12_123 * var13_123 + var11_123 + var4_123[iter1_123] + var14_123
		else
			var3_123[iter1_123] = calcFloor(calcFloor(var3_123[iter1_123]) * var12_123 * var13_123) + var11_123 + var4_123[iter1_123] + var14_123
		end
	end

	if not arg2_123 and arg0_123:isMaxStar() then
		for iter4_123, iter5_123 in pairs(var3_123) do
			local var15_123 = arg4_123 and arg0_123:getTechNationMaxAddition(iter4_123) or arg0_123:getTechNationAddition(iter4_123)

			var3_123[iter4_123] = var3_123[iter4_123] + var15_123
		end
	end

	for iter6_123, iter7_123 in ipairs(var0_0.DIVE_PROPERTIES) do
		var3_123[iter7_123] = var3_123[iter7_123] + var4_123[iter7_123]
	end

	for iter8_123, iter9_123 in ipairs(var0_0.SONAR_PROPERTIES) do
		var3_123[iter9_123] = var3_123[iter9_123] + var4_123[iter9_123]
	end

	if arg3_123 then
		var3_123[AttributeType.AntiSiren] = (var3_123[AttributeType.AntiSiren] or 0) + var4_123[AttributeType.AntiSiren]
	end

	if var8_123 then
		for iter10_123, iter11_123 in pairs(var8_123) do
			if var3_123[iter10_123] then
				if iter10_123 == AttributeType.Speed then
					var3_123[iter10_123] = var3_123[iter10_123] * iter11_123
				else
					var3_123[iter10_123] = math.floor(var3_123[iter10_123] * iter11_123)
				end
			end
		end
	end

	return var3_123
end

function var0_0.getTransGearScore(arg0_124)
	local var0_124 = 0
	local var1_124 = pg.transform_data_template

	for iter0_124, iter1_124 in pairs(arg0_124.transforms) do
		for iter2_124 = 1, iter1_124.level do
			var0_124 = var0_124 + (var1_124[iter1_124.id].gear_score[iter2_124] or 0)
		end
	end

	return var0_124
end

function var0_0.getShipCombatPower(arg0_125, arg1_125)
	local var0_125 = arg0_125:getProperties(arg1_125, nil, nil, true)
	local var1_125 = var0_125[AttributeType.Durability] / 5 + var0_125[AttributeType.Cannon] + var0_125[AttributeType.Torpedo] + var0_125[AttributeType.AntiAircraft] + var0_125[AttributeType.Air] + var0_125[AttributeType.AntiSub] + var0_125[AttributeType.Reload] + var0_125[AttributeType.Hit] * 2 + var0_125[AttributeType.Dodge] * 2 + var0_125[AttributeType.Speed] + arg0_125:getEquipmentGearScore() + arg0_125:getTransGearScore()

	return math.floor(var1_125)
end

function var0_0.cosumeEnergy(arg0_126, arg1_126)
	arg0_126:setEnergy(math.max(arg0_126:getEnergy() - arg1_126, 0))
end

function var0_0.addEnergy(arg0_127, arg1_127)
	arg0_127:setEnergy(arg0_127:getEnergy() + arg1_127)
end

function var0_0.setEnergy(arg0_128, arg1_128)
	arg0_128.energy = arg1_128
end

function var0_0.setLikability(arg0_129, arg1_129)
	assert(arg1_129 >= 0 and arg1_129 <= arg0_129.maxIntimacy, "intimacy value invaild" .. arg1_129)
	arg0_129:setIntimacy(arg1_129)
end

function var0_0.addLikability(arg0_130, arg1_130)
	local var0_130 = Mathf.Clamp(arg0_130:getIntimacy() + arg1_130, 0, arg0_130.maxIntimacy)

	arg0_130:setIntimacy(var0_130)
end

function var0_0.setIntimacy(arg0_131, arg1_131)
	if arg1_131 > 10000 and not arg0_131.propose then
		arg1_131 = 10000
	end

	arg0_131.intimacy = arg1_131

	if not arg0_131:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0_131.groupId]:updateMaxIntimacy(arg0_131:getIntimacy())
	end
end

function var0_0.getLevelExpConfig(arg0_132, arg1_132)
	if arg0_132:getConfig("rarity") == ShipRarity.SSR then
		local var0_132 = Clone(getConfigFromLevel1(var6_0, arg1_132 or arg0_132.level))

		var0_132.exp = var0_132.exp_ur
		var0_132.exp_start = var0_132.exp_ur_start
		var0_132.exp_interval = var0_132.exp_ur_interval
		var0_132.exp_end = var0_132.exp_ur_end

		return var0_132
	else
		return getConfigFromLevel1(var6_0, arg1_132 or arg0_132.level)
	end
end

function var0_0.getExp(arg0_133)
	local var0_133 = arg0_133:getMaxLevel()

	if arg0_133.level == var0_133 and LOCK_FULL_EXP then
		return 0
	end

	return arg0_133.exp
end

function var0_0.getProficiency(arg0_134)
	return arg0_134.proficiency
end

function var0_0.addExp(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg0_135:getMaxLevel()

	if arg0_135.level == var0_135 then
		if arg0_135.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2_135 or not arg0_135:CanAccumulateExp() then
			arg1_135 = 0
		end
	end

	arg0_135.exp = arg0_135.exp + arg1_135

	local var1_135 = false

	while arg0_135:canLevelUp() do
		arg0_135.exp = arg0_135.exp - arg0_135:getLevelExpConfig().exp_interval
		arg0_135.level = math.min(arg0_135.level + 1, var0_135)
		var1_135 = true
	end

	if arg0_135.level == var0_135 then
		if arg2_135 and arg0_135:CanAccumulateExp() then
			arg0_135.exp = math.min(arg0_135.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1_135 then
			arg0_135.exp = 0
		end
	end
end

function var0_0.getMaxLevel(arg0_136)
	return arg0_136.maxLevel
end

function var0_0.canLevelUp(arg0_137)
	local var0_137 = arg0_137:getLevelExpConfig(arg0_137.level + 1)
	local var1_137 = arg0_137:getMaxLevel() <= arg0_137.level

	return var0_137 and arg0_137:getLevelExpConfig().exp_interval <= arg0_137.exp and not var1_137
end

function var0_0.getConfigMaxLevel(arg0_138)
	return var6_0.all[#var6_0.all]
end

function var0_0.isConfigMaxLevel(arg0_139)
	return arg0_139.level == arg0_139:getConfigMaxLevel()
end

function var0_0.updateMaxLevel(arg0_140, arg1_140)
	local var0_140 = arg0_140:getConfigMaxLevel()

	arg0_140.maxLevel = math.max(math.min(var0_140, arg1_140), arg0_140.maxLevel)
end

function var0_0.getNextMaxLevel(arg0_141)
	local var0_141 = arg0_141:getConfigMaxLevel()

	for iter0_141 = arg0_141:getMaxLevel() + 1, var0_141 do
		if var6_0[iter0_141].level_limit == 1 then
			return iter0_141
		end
	end
end

function var0_0.canUpgrade(arg0_142)
	if arg0_142:isBluePrintShip() then
		return false
	end

	if arg0_142:isMetaShip() then
		local var0_142 = arg0_142:getMetaCharacter()

		if not var0_142 then
			return false
		end

		local var1_142 = var0_142:getBreakOutInfo()

		if not var1_142:hasNextInfo() then
			return false
		end

		local var2_142, var3_142 = var1_142:getLimited()

		if var2_142 > arg0_142.level then
			return false
		end

		return true
	else
		local var4_142 = var8_0[arg0_142.configId]

		assert(var4_142, "不存在配置" .. arg0_142.configId)

		return not arg0_142:isMaxStar() and arg0_142.level >= var4_142.level
	end
end

function var0_0.isReachNextMaxLevel(arg0_143)
	return arg0_143.level == arg0_143:getMaxLevel() and arg0_143:CanAccumulateExp() and arg0_143:getNextMaxLevel() ~= nil
end

function var0_0.isAwakening(arg0_144)
	return arg0_144:isReachNextMaxLevel() and arg0_144.level < var4_0
end

function var0_0.isAwakening2(arg0_145)
	return arg0_145:isReachNextMaxLevel() and arg0_145.level >= var4_0
end

function var0_0.notMaxLevelForFilter(arg0_146)
	return arg0_146.level ~= arg0_146:getMaxLevel()
end

function var0_0.getNextMaxLevelConsume(arg0_147)
	local var0_147 = arg0_147:getMaxLevel()
	local var1_147 = var6_0[var0_147]["need_item_rarity" .. arg0_147:getConfig("rarity")]

	assert(var1_147, "items  can not be nil")

	return _.map(var1_147, function(arg0_148)
		return {
			type = arg0_148[1],
			id = arg0_148[2],
			count = arg0_148[3]
		}
	end)
end

function var0_0.canUpgradeMaxLevel(arg0_149)
	if not arg0_149:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0_149 = getProxy(PlayerProxy):getData()
		local var1_149 = getProxy(BagProxy)
		local var2_149 = arg0_149:getNextMaxLevelConsume()

		for iter0_149, iter1_149 in pairs(var2_149) do
			if iter1_149.type == DROP_TYPE_RESOURCE then
				if var0_149:getResById(iter1_149.id) < iter1_149.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1_149.type == DROP_TYPE_ITEM and var1_149:getItemCountById(iter1_149.id) < iter1_149.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.CanAccumulateExp(arg0_150)
	return pg.ship_data_template[arg0_150.configId].can_get_proficency == 1
end

function var0_0.getTotalExp(arg0_151)
	return arg0_151:getLevelExpConfig().exp_start + arg0_151.exp
end

function var0_0.getStartBattleExpend(arg0_152)
	if table.contains(TeamType.SubShipType, arg0_152:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0_152.configId].oil_at_start
	end
end

function var0_0.getEndBattleExpend(arg0_153)
	local var0_153 = pg.ship_data_template[arg0_153.configId]
	local var1_153 = arg0_153:getLevelExpConfig()

	return (math.floor(var0_153.oil_at_end * var1_153.fight_oil_ratio / 10000))
end

function var0_0.getBattleTotalExpend(arg0_154)
	return arg0_154:getStartBattleExpend() + arg0_154:getEndBattleExpend()
end

function var0_0.getShipAmmo(arg0_155)
	local var0_155 = arg0_155:getConfig(AttributeType.Ammo)

	for iter0_155, iter1_155 in pairs(arg0_155:getAllSkills()) do
		local var1_155 = tonumber(iter0_155 .. string.format("%.2d", iter1_155.level))
		local var2_155 = pg.skill_benefit_template[var1_155]

		if var2_155 and arg0_155:IsBenefitSkillActive(var2_155) and (var2_155.type == var0_0.BENEFIT_EQUIP or var2_155.type == var0_0.BENEFIT_SKILL) then
			var0_155 = var0_155 + defaultValue(var2_155.effect[1], 0)
		end
	end

	local var3_155 = arg0_155:getActiveEquipments()

	for iter2_155, iter3_155 in ipairs(var3_155) do
		local var4_155 = iter3_155 and iter3_155:getConfig("equip_parameters").ammo

		if var4_155 then
			var0_155 = var0_155 + var4_155
		end
	end

	return var0_155
end

function var0_0.getHuntingLv(arg0_156)
	local var0_156 = arg0_156:getConfig("huntingrange_level")

	for iter0_156, iter1_156 in pairs(arg0_156:getAllSkills()) do
		local var1_156 = tonumber(iter0_156 .. string.format("%.2d", iter1_156.level))
		local var2_156 = pg.skill_benefit_template[var1_156]

		if var2_156 and arg0_156:IsBenefitSkillActive(var2_156) and (var2_156.type == var0_0.BENEFIT_EQUIP or var2_156.type == var0_0.BENEFIT_SKILL) then
			var0_156 = var0_156 + defaultValue(var2_156.effect[2], 0)
		end
	end

	local var3_156 = arg0_156:getActiveEquipments()

	for iter2_156, iter3_156 in ipairs(var3_156) do
		local var4_156 = iter3_156 and iter3_156:getConfig("equip_parameters").hunting_lv

		if var4_156 then
			var0_156 = var0_156 + var4_156
		end
	end

	return (math.min(var0_156, arg0_156:getMaxHuntingLv()))
end

function var0_0.getMapAuras(arg0_157)
	local var0_157 = {}

	for iter0_157, iter1_157 in pairs(arg0_157:getAllSkills()) do
		local var1_157 = tonumber(iter0_157 .. string.format("%.2d", iter1_157.level))
		local var2_157 = pg.skill_benefit_template[var1_157]

		if var2_157 and arg0_157:IsBenefitSkillActive(var2_157) and var2_157.type == var0_0.BENEFIT_MAP_AURA then
			local var3_157 = {
				id = var2_157.effect[1],
				level = iter1_157.level
			}

			table.insert(var0_157, var3_157)
		end
	end

	return var0_157
end

function var0_0.getMapAids(arg0_158)
	local var0_158 = {}

	for iter0_158, iter1_158 in pairs(arg0_158:getAllSkills()) do
		local var1_158 = tonumber(iter0_158 .. string.format("%.2d", iter1_158.level))
		local var2_158 = pg.skill_benefit_template[var1_158]

		if var2_158 and arg0_158:IsBenefitSkillActive(var2_158) and var2_158.type == var0_0.BENEFIT_AID then
			local var3_158 = {
				id = var2_158.effect[1],
				level = iter1_158.level
			}

			table.insert(var0_158, var3_158)
		end
	end

	return var0_158
end

var0_0.BENEFIT_SKILL = 2
var0_0.BENEFIT_EQUIP = 3
var0_0.BENEFIT_MAP_AURA = 4
var0_0.BENEFIT_AID = 5

function var0_0.IsBenefitSkillActive(arg0_159, arg1_159)
	local var0_159 = false

	if arg1_159.type == var0_0.BENEFIT_SKILL then
		if not arg1_159.limit[1] or arg1_159.limit[1] == arg0_159.triggers.TeamNumbers then
			var0_159 = true
		end
	elseif arg1_159.type == var0_0.BENEFIT_EQUIP then
		local var1_159 = arg1_159.limit
		local var2_159 = arg0_159:getAllEquipments()

		for iter0_159, iter1_159 in ipairs(var2_159) do
			if iter1_159 and table.contains(var1_159, iter1_159:getConfig("id")) then
				var0_159 = true

				break
			end
		end
	elseif arg1_159.type == var0_0.BENEFIT_MAP_AURA then
		if arg0_159.hpRant and arg0_159.hpRant > 0 then
			return true
		end
	elseif arg1_159.type == var0_0.BENEFIT_AID and arg0_159.hpRant and arg0_159.hpRant > 0 then
		return true
	end

	return var0_159
end

function var0_0.getMaxHuntingLv(arg0_160)
	return #arg0_160:getConfig("hunting_range")
end

function var0_0.getHuntingRange(arg0_161, arg1_161)
	local var0_161 = arg0_161:getConfig("hunting_range")
	local var1_161 = Clone(var0_161[1])
	local var2_161 = arg1_161 or arg0_161:getHuntingLv()
	local var3_161 = math.min(var2_161, arg0_161:getMaxHuntingLv())

	for iter0_161 = 2, var3_161 do
		_.each(var0_161[iter0_161], function(arg0_162)
			table.insert(var1_161, {
				arg0_162[1],
				arg0_162[2]
			})
		end)
	end

	return var1_161
end

function var0_0.getTriggerSkills(arg0_163)
	local var0_163 = {}
	local var1_163 = arg0_163:getSkillEffects()

	_.each(var1_163, function(arg0_164)
		if arg0_164.type == "AddBuff" and arg0_164.arg_list and arg0_164.arg_list.buff_id then
			local var0_164 = arg0_164.arg_list.buff_id

			var0_163[var0_164] = {
				id = var0_164,
				level = arg0_164.level
			}
		end
	end)

	return var0_163
end

function var0_0.GetEquipmentSkills(arg0_165)
	local var0_165 = {}
	local var1_165 = arg0_165:getActiveEquipments()

	for iter0_165, iter1_165 in ipairs(var1_165) do
		if iter1_165 and iter1_165:getConfig("skill_id")[1] then
			local var2_165, var3_165 = unpack(iter1_165:getConfig("skill_id")[1])

			var0_165[var2_165] = {
				id = var2_165,
				level = var3_165
			}
		end
	end

	;(function()
		local var0_166 = arg0_165:GetSpWeapon()
		local var1_166 = var0_166 and var0_166:GetEffect() or 0

		if var1_166 > 0 then
			var0_165[var1_166] = {
				level = 1,
				id = var1_166
			}
		end
	end)()

	return var0_165
end

function var0_0.getAllSkills(arg0_167)
	local var0_167 = Clone(arg0_167.skills)

	for iter0_167, iter1_167 in pairs(arg0_167:GetEquipmentSkills()) do
		var0_167[iter0_167] = iter1_167
	end

	for iter2_167, iter3_167 in pairs(arg0_167:getTriggerSkills()) do
		var0_167[iter2_167] = iter3_167
	end

	return var0_167
end

function var0_0.isSameKind(arg0_168, arg1_168)
	return pg.ship_data_template[arg0_168.configId].group_type == pg.ship_data_template[arg1_168.configId].group_type
end

function var0_0.GetLockState(arg0_169)
	return arg0_169.lockState
end

function var0_0.IsLocked(arg0_170)
	return arg0_170.lockState == var0_0.LOCK_STATE_LOCK
end

function var0_0.SetLockState(arg0_171, arg1_171)
	arg0_171.lockState = arg1_171
end

function var0_0.GetPreferenceTag(arg0_172)
	return arg0_172.preferenceTag or 0
end

function var0_0.IsPreferenceTag(arg0_173)
	return arg0_173:GetPreferenceTag() == var0_0.PREFERENCE_TAG_COMMON
end

function var0_0.SetPreferenceTag(arg0_174, arg1_174)
	arg0_174.preferenceTag = arg1_174
end

function var0_0.calReturnRes(arg0_175)
	local var0_175 = pg.ship_data_by_type[arg0_175:getShipType()]
	local var1_175 = var0_175.distory_resource_gold_ratio
	local var2_175 = var0_175.distory_resource_oil_ratio
	local var3_175 = pg.ship_data_by_star[arg0_175:getConfig("rarity")].destory_item

	return var1_175, 0, var3_175
end

function var0_0.getRarity(arg0_176)
	local var0_176 = arg0_176:getConfig("rarity")

	if arg0_176:isRemoulded() then
		var0_176 = var0_176 + 1
	end

	return var0_176
end

function var0_0.updateSkill(arg0_177, arg1_177)
	local var0_177 = arg1_177.skill_id or arg1_177.id
	local var1_177 = arg1_177.skill_lv or arg1_177.lv or arg1_177.level
	local var2_177 = arg1_177.skill_exp or arg1_177.exp

	arg0_177.skills[var0_177] = {
		id = var0_177,
		level = var1_177,
		exp = var2_177
	}
end

function var0_0.canEquipAtPos(arg0_178, arg1_178, arg2_178)
	local var0_178, var1_178 = arg0_178:isForbiddenAtPos(arg1_178, arg2_178)

	if var0_178 then
		return false, var1_178
	end

	for iter0_178, iter1_178 in ipairs(arg0_178.equipments) do
		if iter1_178 and iter0_178 ~= arg2_178 and iter1_178:getConfig("equip_limit") ~= 0 and arg1_178:getConfig("equip_limit") == iter1_178:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0_0.isForbiddenAtPos(arg0_179, arg1_179, arg2_179)
	local var0_179 = pg.ship_data_template[arg0_179.configId]

	assert(var0_179, "can not find ship in ship_data_templtae: " .. arg0_179.configId)

	local var1_179 = var0_179["equip_" .. arg2_179]

	if not table.contains(var1_179, arg1_179:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1_179:getConfig("ship_type_forbidden"), arg0_179:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0_0.canEquipCommander(arg0_180, arg1_180)
	if arg1_180:getShipType() ~= arg0_180:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0_0.upgrade(arg0_181)
	local var0_181 = pg.ship_data_transform[arg0_181.configId]

	if var0_181.trans_id and var0_181.trans_id > 0 then
		arg0_181.configId = var0_181.trans_id
		arg0_181.star = arg0_181:getConfig("star")
	end
end

function var0_0.getTeamType(arg0_182)
	return TeamType.GetTeamFromShipType(arg0_182:getShipType())
end

function var0_0.getFleetName(arg0_183)
	local var0_183 = arg0_183:getTeamType()

	return var1_0[var0_183]
end

function var0_0.getMaxConfigId(arg0_184)
	local var0_184 = pg.ship_data_template
	local var1_184

	for iter0_184 = 4, 1, -1 do
		local var2_184 = tonumber(arg0_184.groupId .. iter0_184)

		if var0_184[var2_184] then
			var1_184 = var2_184

			break
		end
	end

	return var1_184
end

function var0_0.getFlag(arg0_185, arg1_185, arg2_185)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0_185.id, arg1_185, arg2_185)
end

function var0_0.hasAnyFlag(arg0_186, arg1_186)
	return _.any(arg1_186, function(arg0_187)
		return arg0_186:getFlag(arg0_187)
	end)
end

function var0_0.isBreakOut(arg0_188)
	return arg0_188.configId % 10 > 1
end

function var0_0.fateSkillChange(arg0_189, arg1_189)
	if not arg0_189.skillChangeList then
		arg0_189.skillChangeList = arg0_189:isBluePrintShip() and arg0_189:getBluePrint():getChangeSkillList() or {}
	end

	for iter0_189, iter1_189 in ipairs(arg0_189.skillChangeList) do
		if iter1_189[1] == arg1_189 and arg0_189.skills[iter1_189[2]] then
			return iter1_189[2]
		end
	end

	return arg1_189
end

function var0_0.RemapSkillId(arg0_190, arg1_190)
	local var0_190 = arg0_190:GetSpWeapon()

	if var0_190 then
		if table.contains(pg.ship_data_template[arg0_190.configId].hide_buff_list, arg1_190) then
			return var0_190:RemapHiddenSkillId(arg1_190)
		else
			return var0_190:RemapSkillId(arg1_190)
		end
	end

	return arg1_190
end

function var0_0.getSkillList(arg0_191)
	local var0_191 = pg.ship_data_template[arg0_191.configId]
	local var1_191 = Clone(var0_191.buff_list_display)
	local var2_191 = Clone(var0_191.buff_list)
	local var3_191 = pg.ship_data_trans[arg0_191.groupId]
	local var4_191 = 0

	if var3_191 and var3_191.skill_id ~= 0 then
		local var5_191 = var3_191.skill_id
		local var6_191 = pg.transform_data_template[var5_191]

		if arg0_191.transforms[var5_191] and var6_191.skill_id ~= 0 then
			table.insert(var2_191, var6_191.skill_id)
		end
	end

	local var7_191 = {}

	for iter0_191, iter1_191 in ipairs(var1_191) do
		for iter2_191, iter3_191 in ipairs(var2_191) do
			if iter1_191 == iter3_191 then
				table.insert(var7_191, arg0_191:fateSkillChange(iter1_191))
			end
		end
	end

	return var7_191
end

function var0_0.getModAttrTopLimit(arg0_192, arg1_192)
	local var0_192 = ShipModAttr.ATTR_TO_INDEX[arg1_192]
	local var1_192 = pg.ship_data_template[arg0_192.configId].strengthen_id
	local var2_192 = pg.ship_data_strengthen[var1_192].durability[var0_192]

	return calcFloor((3 + 7 * (math.min(arg0_192.level, 100) / 100)) * var2_192 * 0.1)
end

function var0_0.leftModAdditionPoint(arg0_193, arg1_193)
	local var0_193 = arg0_193:getModProperties(arg1_193)
	local var1_193 = arg0_193:getModExpRatio(arg1_193)
	local var2_193 = arg0_193:getModAttrTopLimit(arg1_193)
	local var3_193 = calcFloor(var0_193 / var1_193)

	return math.max(0, var2_193 - var3_193)
end

function var0_0.getModAttrBaseMax(arg0_194, arg1_194)
	if not table.contains(arg0_194:getConfig("lock"), arg1_194) then
		local var0_194 = arg0_194:leftModAdditionPoint(arg1_194)
		local var1_194 = arg0_194:getShipProperties()

		return calcFloor(var1_194[arg1_194] + var0_194)
	else
		return 0
	end
end

function var0_0.getModExpRatio(arg0_195, arg1_195)
	if not table.contains(arg0_195:getConfig("lock"), arg1_195) then
		local var0_195 = pg.ship_data_template[arg0_195.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0_195], "ship_data_strengthen>>>>>>" .. var0_195)

		return math.max(pg.ship_data_strengthen[var0_195].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1_195]], 1)
	else
		return 1
	end
end

function var0_0.inUnlockTip(arg0_196)
	local var0_196 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0_196, arg0_196)
end

function var0_0.proposeSkinOwned(arg0_197, arg1_197)
	return arg1_197 and arg0_197.propose and arg1_197.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0_0.getProposeSkin(arg0_198)
	return ShipSkin.GetSkinByType(arg0_198.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getDisplaySkillIds(arg0_199)
	return _.map(pg.ship_data_template[arg0_199.configId].buff_list_display, function(arg0_200)
		return arg0_199:fateSkillChange(arg0_200)
	end)
end

function var0_0.isFullSkillLevel(arg0_201)
	local var0_201 = pg.skill_data_template

	for iter0_201, iter1_201 in pairs(arg0_201.skills) do
		if var0_201[iter1_201.id].max_level ~= iter1_201.level then
			return false
		end
	end

	return true
end

function var0_0.setEquipmentRecord(arg0_202, arg1_202, arg2_202)
	local var0_202 = "equipment_record" .. "_" .. arg1_202 .. "_" .. arg0_202.id

	PlayerPrefs.SetString(var0_202, table.concat(_.flatten(arg2_202), ":"))
	PlayerPrefs.Save()
end

function var0_0.getEquipmentRecord(arg0_203, arg1_203)
	if not arg0_203.equipmentRecords then
		local var0_203 = "equipment_record" .. "_" .. arg1_203 .. "_" .. arg0_203.id
		local var1_203 = string.split(PlayerPrefs.GetString(var0_203) or "", ":")
		local var2_203 = {}

		for iter0_203 = 1, 3 do
			var2_203[iter0_203] = _.map(_.slice(var1_203, 5 * iter0_203 - 4, 5), function(arg0_204)
				return tonumber(arg0_204)
			end)
		end

		arg0_203.equipmentRecords = var2_203
	end

	return arg0_203.equipmentRecords
end

function var0_0.SetSpWeaponRecord(arg0_205, arg1_205, arg2_205)
	local var0_205 = "spweapon_record" .. "_" .. arg1_205 .. "_" .. arg0_205.id
	local var1_205 = _.map({
		1,
		2,
		3
	}, function(arg0_206)
		local var0_206 = arg2_205[arg0_206]

		if var0_206 then
			return (var0_206:GetUID() or 0) .. "," .. var0_206:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0_205, table.concat(var1_205, ":"))
	PlayerPrefs.Save()
end

function var0_0.GetSpWeaponRecord(arg0_207, arg1_207)
	local var0_207 = "spweapon_record" .. "_" .. arg1_207 .. "_" .. arg0_207.id

	return (_.map(string.split(PlayerPrefs.GetString(var0_207, ""), ":"), function(arg0_208)
		local var0_208 = string.split(arg0_208, ",")

		assert(var0_208)

		local var1_208 = tonumber(var0_208[1])
		local var2_208 = tonumber(var0_208[2])

		if not var2_208 or var2_208 == 0 then
			return false
		end

		return (SpWeapon.New({
			id = var2_208
		}))
	end))
end

function var0_0.hasEquipEquipmentSkin(arg0_209)
	for iter0_209, iter1_209 in ipairs(arg0_209.equipments) do
		if iter1_209 and iter1_209:hasSkin() then
			return true
		end
	end

	return false
end

function var0_0.hasCommander(arg0_210)
	return arg0_210.commanderId and arg0_210.commanderId ~= 0
end

function var0_0.getCommander(arg0_211)
	return arg0_211.commanderId
end

function var0_0.setCommander(arg0_212, arg1_212)
	arg0_212.commanderId = arg1_212
end

function var0_0.getSkillIndex(arg0_213, arg1_213)
	local var0_213 = arg0_213:getSkillList()

	for iter0_213, iter1_213 in ipairs(var0_213) do
		if arg1_213 == iter1_213 then
			return iter0_213
		end
	end
end

function var0_0.getTactics(arg0_214)
	return 1, "tactics_attack"
end

function var0_0.IsBgmSkin(arg0_215)
	local var0_215 = arg0_215:GetSkinConfig()

	return table.contains(var0_215.tag, ShipSkin.WITH_BGM)
end

function var0_0.GetSkinBgm(arg0_216)
	if arg0_216:IsBgmSkin() then
		return arg0_216:GetSkinConfig().bgm
	end
end

function var0_0.isIntensifyMax(arg0_217)
	local var0_217 = intProperties(arg0_217:getShipProperties())

	if arg0_217:isBluePrintShip() then
		return true
	end

	for iter0_217, iter1_217 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0_217:getModAttrBaseMax(iter1_217) ~= var0_217[iter1_217] then
			return false
		end
	end

	return true
end

function var0_0.isRemouldable(arg0_218)
	return not arg0_218:isTestShip() and not arg0_218:isBluePrintShip() and pg.ship_data_trans[arg0_218.groupId]
end

function var0_0.isAllRemouldFinish(arg0_219)
	local var0_219 = pg.ship_data_trans[arg0_219.groupId]

	assert(var0_219, "this ship group without remould config:" .. arg0_219.groupId)

	for iter0_219, iter1_219 in ipairs(var0_219.transform_list) do
		for iter2_219, iter3_219 in ipairs(iter1_219) do
			local var1_219 = pg.transform_data_template[iter3_219[2]]

			if #var1_219.edit_trans > 0 then
				-- block empty
			elseif not arg0_219.transforms[iter3_219[2]] or arg0_219.transforms[iter3_219[2]].level < var1_219.max_level then
				return false
			end
		end
	end

	return true
end

function var0_0.isSpecialFilter(arg0_220)
	local var0_220 = pg.ship_data_statistics[arg0_220.configId]

	assert(var0_220, "this ship without statistics:" .. arg0_220.configId)

	for iter0_220, iter1_220 in ipairs(var0_220.tag_list) do
		if iter1_220 == "special" then
			return true
		end
	end

	return false
end

function var0_0.hasAvailiableSkin(arg0_221)
	local var0_221 = getProxy(ShipSkinProxy)
	local var1_221 = var0_221:GetAllSkinForShip(arg0_221)
	local var2_221 = var0_221:getRawData()
	local var3_221 = 0

	for iter0_221, iter1_221 in ipairs(var1_221) do
		if arg0_221:proposeSkinOwned(iter1_221) or var2_221[iter1_221.id] or var0_221:hasSkin(iter1_221.id) then
			var3_221 = var3_221 + 1
		end
	end

	return var3_221 > 0
end

function var0_0.hasProposeSkin(arg0_222)
	local var0_222 = getProxy(ShipSkinProxy)
	local var1_222 = var0_222:GetAllSkinForShip(arg0_222)

	for iter0_222, iter1_222 in ipairs(var1_222) do
		if iter1_222.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2_222 = var0_222:GetShareSkinsForShip(arg0_222)

	for iter2_222, iter3_222 in ipairs(var2_222) do
		if iter3_222.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0_0.HasUniqueSpWeapon(arg0_223)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0_223:getGroupId()])
end

function var0_0.getAircraftReloadCD(arg0_224)
	local var0_224 = arg0_224:getConfigTable().base_list
	local var1_224 = arg0_224:getConfigTable().default_equip_list
	local var2_224 = 0
	local var3_224 = 0

	for iter0_224 = 1, 3 do
		local var4_224 = arg0_224:getEquip(iter0_224)
		local var5_224 = var4_224 and var4_224.configId or var1_224[iter0_224]
		local var6_224 = Equipment.getConfigData(var5_224).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0_225)
			return var6_224 == arg0_225
		end) then
			var2_224 = var2_224 + Equipment.GetEquipReloadStatic(var5_224) * var0_224[iter0_224]
			var3_224 = var3_224 + var0_224[iter0_224]
		end
	end

	local var7_224 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2_224 / var3_224 * var7_224
	}
end

function var0_0.IsTagShip(arg0_226, arg1_226)
	local var0_226 = arg0_226:getConfig("tag_list")

	return table.contains(var0_226, arg1_226)
end

function var0_0.setReMetaSpecialItemVO(arg0_227, arg1_227)
	arg0_227.reMetaSpecialItemVO = arg1_227
end

function var0_0.getReMetaSpecialItemVO(arg0_228, arg1_228)
	return arg0_228.reMetaSpecialItemVO
end

function var0_0.getProposeType(arg0_229)
	if arg0_229:isMetaShip() then
		return "meta"
	elseif arg0_229:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_230)
	return arg0_230:getNation() == Nation.IDOL_LINK
end

function var0_0.getSpecificType(arg0_231)
	return pg.ship_data_template[arg0_231.configId].specific_type
end

function var0_0.GetSpWeapon(arg0_232)
	return arg0_232.spWeapon
end

function var0_0.UpdateSpWeapon(arg0_233, arg1_233)
	local var0_233 = (arg1_233 and arg1_233:GetUID() or 0) == (arg0_233.spWeapon and arg0_233.spWeapon:GetUID() or 0)

	arg0_233.spWeapon = arg1_233

	if arg1_233 then
		arg1_233:SetShipId(arg0_233.id)
	end

	if var0_233 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0_0.CanEquipSpWeapon(arg0_234, arg1_234)
	local var0_234, var1_234 = arg0_234:IsSpWeaponForbidden(arg1_234)

	if var0_234 then
		return false, var1_234
	end

	return true
end

function var0_0.IsSpWeaponForbidden(arg0_235, arg1_235)
	local var0_235 = arg1_235:GetWearableShipTypes()
	local var1_235 = arg0_235:getShipType()

	if not table.contains(var0_235, var1_235) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2_235 = arg1_235:GetUniqueGroup()
	local var3_235 = arg0_235:getGroupId()

	if var2_235 ~= 0 and var2_235 ~= var3_235 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0_0.GetMapStrikeAnim(arg0_236)
	local var0_236
	local var1_236 = arg0_236:getShipType()

	switch(TeamType.GetTeamFromShipType(var1_236), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1_236) then
				var0_236 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1_236) then
				var0_236 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1_236) then
				var0_236 = "CannonUI"
			else
				var0_236 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1_236) then
				var0_236 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0_236:getNation() == Nation.MOT then
				var0_236 = "CannonUI"
			else
				var0_236 = "SubTorpedoUI"
			end
		end
	})

	return var0_236
end

function var0_0.IsDefaultSkin(arg0_240)
	local var0_240 = arg0_240:getSkinId()

	return var0_240 == 0 or var0_240 == arg0_240:getConfig("skin_id")
end

function var0_0.IsMatchKey(arg0_241, arg1_241)
	if not arg1_241 or arg1_241 == "" then
		return true
	end

	arg1_241 = string.lower(string.gsub(arg1_241, "%.", "%%."))

	local var0_241 = {
		arg0_241:getName(),
		arg0_241:GetDefaultName()
	}

	if var0_241[1] == var0_241[2] then
		table.remove(var0_241)
	end

	return underscore.any(var0_241, function(arg0_242)
		return string.find(string.lower(arg0_242), arg1_241)
	end)
end

function var0_0.IsOwner(arg0_243)
	return tobool(arg0_243.id)
end

function var0_0.GetUniqueId(arg0_244)
	return arg0_244.id
end

function var0_0.ShowPropose(arg0_245)
	if not arg0_245.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0_245:IsOwner() and arg0_245:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0_0.GetColorName(arg0_246, arg1_246)
	arg1_246 = arg1_246 or arg0_246:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0_246.propose then
		return setColorStr(arg1_246, "#FFAACEFF")
	else
		return arg1_246
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

function var0_0.GetFrameAndEffect(arg0_247, arg1_247)
	arg1_247 = tobool(arg1_247)

	local var0_247
	local var1_247

	if arg0_247.propose then
		if arg0_247:isMetaShip() then
			var1_247 = string.format(var9_0.effect[1])
			var0_247 = string.format(var9_0.frame[1])
		elseif arg0_247:isBluePrintShip() then
			var1_247 = string.format(var9_0.effect[2])
			var0_247 = string.format(var9_0.frame[2], arg0_247:rarity2bgPrint())
		else
			var1_247 = string.format(var9_0.effect[3])
			var0_247 = string.format(var9_0.frame[3])
		end

		if not arg0_247:ShowPropose() then
			var0_247 = nil
		end
	elseif arg0_247:isMetaShip() then
		var1_247 = string.format(var9_0.effect[4], arg0_247:rarity2bgPrint())
	elseif arg0_247:getRarity() == ShipRarity.SSR then
		var1_247 = string.format(var9_0.effect[5])
	end

	if arg1_247 then
		var1_247 = var1_247 and var1_247 .. "_1"
	end

	return var0_247, var1_247
end

function var0_0.GetRecordPosKey(arg0_248)
	return arg0_248:getSkinId()
end

function var0_0.GetShipPhantomMark(arg0_249, arg1_249)
	return ShipPhantom.PackMark(arg0_249.id, arg1_249)
end

function var0_0.GetSelectMark(arg0_250)
	return arg0_250.id
end

return var0_0
