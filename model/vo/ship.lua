local var0 = class("Ship", import(".BaseVO"))

var0.ENERGY_MID = 40
var0.ENERGY_LOW = 0
var0.RECOVER_ENERGY_POINT = 2
var0.INTIMACY_PROPOSE = 6
var0.CONFIG_MAX_STAR = 6
var0.BACKYARD_1F_ENERGY_ADDITION = 2
var0.BACKYARD_2F_ENERGY_ADDITION = 3
var0.PREFERENCE_TAG_NONE = 0
var0.PREFERENCE_TAG_COMMON = 1

local var1 = {
	vanguard = i18n("word_vanguard_fleet"),
	main = i18n("word_main_fleet")
}

var0.CVBattleKey = {
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
var0.LOCK_STATE_UNLOCK = 0
var0.LOCK_STATE_LOCK = 1
var0.WEAPON_COUNT = 3
var0.PREFAB_EQUIP = 4
var0.MAX_SKILL_LEVEL = 10
var0.ENERGY_RECOVER_TIME = 360
var0.STATE_NORMAL = 1
var0.STATE_REST = 2
var0.STATE_CLASS = 3
var0.STATE_COLLECT = 4
var0.STATE_TRAIN = 5

local var2 = 4
local var3 = 100
local var4 = 120
local var5 = pg.ship_data_strengthen
local var6 = pg.ship_level
local var7 = pg.equip_skin_template
local var8 = pg.ship_data_breakout

function nation2print(arg0)
	return Nation.Nation2Print(arg0)
end

function var0.getRecoverEnergyPoint(arg0)
	return arg0.propose and 3 or 2
end

function shipType2name(arg0)
	return ShipType.Type2Name(arg0)
end

function shipType2print(arg0)
	return ShipType.Type2Print(arg0)
end

function shipType2Battleprint(arg0)
	return ShipType.Type2BattlePrint(arg0)
end

function skinId2bgPrint(arg0)
	local var0 = pg.ship_skin_template[arg0].rarity_bg

	if var0 and var0 ~= "" then
		return var0
	end
end

function var0.rarity2bgPrint(arg0)
	return shipRarity2bgPrint(arg0:getRarity(), arg0:isBluePrintShip(), arg0:isMetaShip())
end

function var0.rarity2bgPrintForGet(arg0)
	return skinId2bgPrint(arg0.skinId) or arg0:rarity2bgPrint()
end

function var0.getShipBgPrint(arg0, arg1)
	local var0 = pg.ship_skin_template[arg0.skinId]

	assert(var0, "ship_skin_template not exist: " .. arg0.skinId)

	local var1

	if not arg1 and var0.bg_sp and var0.bg_sp ~= "" and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0.painting, 0) == 0 then
		var1 = var0.bg_sp
	end

	return var1 and var1 or var0.bg and #var0.bg > 0 and var0.bg or arg0:rarity2bgPrintForGet()
end

function var0.getStar(arg0)
	return arg0:getConfig("star")
end

function var0.getMaxStar(arg0)
	return pg.ship_data_template[arg0.configId].star_max
end

function var0.getShipArmor(arg0)
	return arg0:getConfig("armor_type")
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

function var0.getShipWords(arg0)
	local var0 = pg.ship_skin_words[arg0]

	if not var0 then
		warning("找不到ship_skin_words: " .. arg0)

		return
	end

	local var1 = Clone(var0)

	for iter0, iter1 in pairs(var1) do
		if type(iter1) == "string" then
			var1[iter0] = HXSet.hxLan(iter1)
		end
	end

	local var2 = pg.ship_skin_words_extra[arg0]

	return var1, var2
end

function var0.getMainwordsCount(arg0)
	local var0 = var0.getShipWords(arg0)

	if not var0.main or var0.main == "" then
		var0 = var0.getShipWords(var0.getOriginalSkinId(arg0))
	end

	return #string.split(var0.main, "|")
end

function var0.getWordsEx(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0 and arg0[arg1] or nil
	local var1 = false

	if not var0 or var0 == "" then
		if arg0 and arg0.id == arg4 then
			return
		end

		if not arg5 then
			return
		end

		local var2, var3 = var0.getShipWords(arg4)

		if not var3 then
			return
		end

		var0 = var3[arg1]

		if not var0 then
			return
		end

		var1 = true
	end

	if type(var0) == "string" then
		return
	end

	arg3 = arg3 or 0

	for iter0, iter1 in ipairs(var0) do
		if arg3 >= iter1[1] then
			if arg1 == "main" then
				return string.split(iter1[2], "|")[arg2], iter1[1], var1
			else
				return iter1[2], iter1[1], var1
			end
		end
	end
end

function var0.getWords(arg0, arg1, arg2, arg3, arg4)
	local var0, var1 = var0.getShipWords(arg0)
	local var2 = var0.getOriginalSkinId(arg0)
	local var3 = math.fmod(arg0, var2)

	if not var0 then
		var0, var1 = var0.getShipWords(var2)

		if not var0 then
			return nil
		end
	end

	local var4 = 0
	local var5 = false
	local var6 = var0[arg1]

	if not var6 or var6 == "" then
		var5 = true

		if var0.id == var2 then
			return nil
		else
			var0 = var0.getShipWords(var2)

			if not var0 then
				return nil
			end

			var6 = var0[arg1]

			if not var6 or var6 == "" then
				return nil
			end
		end
	end

	local var7 = string.split(var6, "|")
	local var8 = arg2 or math.random(#var7)

	if arg1 == "main" and var7[var8] == "nil" then
		var5 = true
		var0 = var0.getShipWords(var2)

		if not var0 then
			return nil
		end

		local var9 = var0[arg1]

		if not var9 or var9 == "" then
			return nil
		end

		var7 = string.split(var9, "|")
	end

	rstEx, cvEx, defaultCoverEx = var0.getWordsEx(var1, arg1, var8, arg4, var2, var5)

	local var10
	local var11 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. pg.ship_skin_template[arg0].ship_group) == 2 and var0.voice_key_2 or var0.voice_key

	if var11 == 0 then
		if not var5 or rstEx and not defaultCoverEx then
			var10 = var0.getCVPath(var2, arg1, var8, var3)
		end
	elseif var11 == -2 then
		-- block empty
	else
		var10 = var0.getCVPath(var2, arg1, var8)
	end

	local var12 = var7[var8]

	if var12 and (arg3 == nil and PLATFORM_CODE ~= PLATFORM_US or arg3 == true) then
		var12 = var12:gsub("%s", " ")
	end

	if rstEx then
		var10 = var10 and var10 .. "_ex" .. cvEx
	end

	return rstEx or var12, var10, cvEx
end

function var0.getCVKeyID(arg0)
	local var0 = Ship.getShipWords(arg0)

	if not var0 then
		return -1
	end

	local var1
	local var2 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. pg.ship_skin_template[arg0].ship_group)
	local var3 = var2 == 2 and var0.voice_key_2 >= 0 and var0.voice_key_2 or var0.voice_key

	if var3 == 0 or var3 == -2 then
		local var4 = var0.getOriginalSkinId(arg0)
		local var5 = var0.getShipWords(var4)

		var3 = var2 == 2 and var5.voice_key_2 >= 0 and var5.voice_key_2 or var5.voice_key
	end

	return var3
end

function var0.getCVPath(arg0, arg1, arg2, arg3)
	arg2 = arg2 or 1

	local var0 = Ship.getShipWords(arg0)
	local var1 = var0.getOriginalSkinId(arg0)

	if not var0 then
		var0 = var0.getShipWords(var1)

		if not var0 then
			return
		end
	end

	local var2 = PlayerPrefs.GetInt("CV_LANGUAGE_" .. arg0 / 10)
	local var3 = var0[arg1]

	if arg1 == "main" then
		var3 = string.split(var3, "|")[arg2]
		arg1 = arg1 .. arg2
	end

	if arg1 == "skill" or string.find(arg1, "link") then
		if var0.voice_key == 0 then
			var0 = var0.getShipWords(var1)
		end
	elseif not var3 or var3 == "" or var3 == "nil" then
		var0 = var0.getShipWords(var1)
	end

	local var4
	local var5 = var2 == 2 and var0.voice_key_2 or var0.voice_key

	if var5 ~= -1 and pg.character_voice[arg1] then
		var4 = pg.character_voice[arg1].resource_key

		if var4 then
			var4 = "event:/cv/" .. var5 .. "/" .. var4

			if arg3 then
				var4 = var4 .. "_" .. arg3
			end
		end
	end

	return var4
end

function var0.getCVCalibrate(arg0, arg1, arg2)
	local var0 = pg.ship_skin_template[arg0]

	if not var0 then
		return 0
	end

	if arg1 == "main" then
		arg1 = arg1 .. "_" .. arg2
	end

	return var0.l2d_voice_calibrate[arg1]
end

function var0.getL2dSoundEffect(arg0, arg1, arg2)
	local var0 = pg.ship_skin_template[arg0]

	if not var0 then
		return 0
	end

	if arg1 == "main" then
		arg1 = arg1 .. "_" .. arg2
	end

	return var0.l2d_se[arg1]
end

function var0.getOriginalSkinId(arg0)
	local var0 = pg.ship_skin_template[arg0].ship_group

	return ShipGroup.getDefaultSkin(var0).id
end

function var0.getTransformShipId(arg0)
	local var0 = pg.ship_data_template[arg0].group_type
	local var1 = pg.ship_data_trans[var0]

	if var1 then
		for iter0, iter1 in ipairs(var1.transform_list) do
			for iter2, iter3 in ipairs(iter1) do
				local var2 = pg.transform_data_template[iter3[2]]

				for iter4, iter5 in ipairs(var2.ship_id) do
					if iter5[1] == arg0 then
						return iter5[2]
					end
				end
			end
		end
	end
end

function var0.getAircraftCount(arg0)
	local var0 = arg0:getConfigTable().base_list
	local var1 = arg0:getConfigTable().default_equip_list
	local var2 = {}

	for iter0 = 1, 3 do
		local var3 = arg0:getEquip(iter0) and arg0:getEquip(iter0).configId or var1[iter0]
		local var4 = Equipment.getConfigData(var3).type

		if table.contains(EquipType.AirDomainEquip, var4) then
			var2[var4] = defaultValue(var2[var4], 0) + var0[iter0]
		end
	end

	return var2
end

function var0.getShipType(arg0)
	return arg0:getConfig("type")
end

function var0.getEnergy(arg0)
	return arg0.energy
end

function var0.getEnergeConfig(arg0)
	local var0 = pg.energy_template
	local var1 = arg0:getEnergy()

	for iter0, iter1 in pairs(var0) do
		if type(iter0) == "number" and var1 >= iter1.lower_bound and var1 <= iter1.upper_bound then
			return iter1
		end
	end

	assert(false, "疲劳配置不存在：" .. arg0.energy)
end

function var0.getEnergyPrint(arg0)
	local var0 = arg0:getEnergeConfig()

	return var0.icon, var0.desc
end

function var0.getIntimacy(arg0)
	return arg0.intimacy
end

function var0.getCVIntimacy(arg0)
	return arg0:getIntimacy() / 100 + (arg0.propose and 1000 or 0)
end

function var0.getIntimacyMax(arg0)
	if arg0.propose then
		return 200
	else
		return arg0:GetNoProposeIntimacyMax()
	end
end

function var0.GetNoProposeIntimacyMax(arg0)
	return 100
end

function var0.getIntimacyIcon(arg0)
	local var0 = pg.intimacy_template[arg0:getIntimacyLevel()]
	local var1 = ""

	if arg0:isMetaShip() then
		var1 = "_meta"
	elseif arg0:IsXIdol() then
		var1 = "_imas"
	end

	if not arg0.propose and math.floor(arg0:getIntimacy() / 100) >= arg0:getIntimacyMax() then
		return var0.icon .. var1, "heart" .. var1
	else
		return var0.icon .. var1
	end
end

function var0.getIntimacyDetail(arg0)
	return arg0:getIntimacyMax(), math.floor(arg0:getIntimacy() / 100)
end

function var0.getIntimacyInfo(arg0)
	local var0 = pg.intimacy_template[arg0:getIntimacyLevel()]

	return var0.icon, var0.desc
end

function var0.getIntimacyLevel(arg0)
	local var0 = 0
	local var1 = pg.intimacy_template

	for iter0, iter1 in pairs(var1) do
		if type(iter0) == "number" and arg0:getIntimacy() >= iter1.lower_bound and arg0:getIntimacy() <= iter1.upper_bound then
			var0 = iter0

			break
		end
	end

	if var0 < arg0.INTIMACY_PROPOSE and arg0.propose then
		var0 = arg0.INTIMACY_PROPOSE
	end

	return var0
end

function var0.getBluePrint(arg0)
	local var0 = ShipBluePrint.New({
		id = arg0.groupId
	})
	local var1 = arg0.strengthList[1] or {
		exp = 0,
		level = 0
	}

	var0:updateInfo({
		blue_print_level = var1.level,
		exp = var1.exp
	})

	return var0
end

function var0.getBaseList(arg0)
	if arg0:isBluePrintShip() then
		local var0 = arg0:getBluePrint()

		assert(var0, "blueprint can not be nil" .. arg0.configId)

		return var0:getBaseList(arg0)
	else
		return arg0:getConfig("base_list")
	end
end

function var0.getPreLoadCount(arg0)
	if arg0:isBluePrintShip() then
		return arg0:getBluePrint():getPreLoadCount(arg0)
	else
		return arg0:getConfig("preload_count")
	end
end

function var0.getNation(arg0)
	return arg0:getConfig("nationality")
end

function var0.getPaintingName(arg0)
	local var0 = pg.ship_data_statistics[arg0].skin_id
	local var1 = pg.ship_skin_template[var0]

	assert(var1, "ship_skin_template not exist: " .. arg0 .. " " .. var0)

	return var1.painting
end

function var0.getName(arg0)
	if arg0.propose and pg.PushNotificationMgr.GetInstance():isEnableShipName() then
		return arg0.name
	end

	if arg0:isRemoulded() then
		return pg.ship_skin_template[arg0:getRemouldSkinId()].name
	end

	return pg.ship_data_statistics[arg0.configId].name
end

function var0.GetDefaultName(arg0)
	if arg0:isRemoulded() then
		return pg.ship_skin_template[arg0:getRemouldSkinId()].name
	else
		return pg.ship_data_statistics[arg0.configId].name
	end
end

function var0.getShipName(arg0)
	return pg.ship_data_statistics[arg0].name
end

function var0.getBreakOutLevel(arg0)
	assert(arg0, "必须存在配置id")
	assert(pg.ship_data_statistics[arg0], "必须存在配置" .. arg0)

	return pg.ship_data_statistics[arg0].star
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.template_id or arg1.configId
	arg0.level = arg1.level
	arg0.exp = arg1.exp
	arg0.energy = arg1.energy
	arg0.lockState = arg1.is_locked
	arg0.intimacy = arg1.intimacy
	arg0.propose = arg1.propose and arg1.propose > 0
	arg0.proposeTime = arg1.propose

	if arg0.intimacy and arg0.intimacy > 10000 and not arg0.propose then
		arg0.intimacy = 10000
	end

	arg0.renameTime = arg1.change_name_timestamp

	if arg1.name and arg1.name ~= "" then
		arg0.name = arg1.name
	else
		assert(pg.ship_data_statistics[arg0.configId], "必须存在配置" .. arg0.configId)

		arg0.name = pg.ship_data_statistics[arg0.configId].name
	end

	arg0.bluePrintFlag = arg1.blue_print_flag or 0
	arg0.strengthList = {}

	for iter0, iter1 in ipairs(arg1.strength_list or {}) do
		if not arg0:isBluePrintShip() then
			local var0 = ShipModAttr.ID_TO_ATTR[iter1.id]

			arg0.strengthList[var0] = iter1.exp
		else
			table.insert(arg0.strengthList, {
				level = iter1.id,
				exp = iter1.exp
			})
		end
	end

	local var1 = arg1.state or {}

	arg0.state = var1.state
	arg0.state_info_1 = var1.state_info_1
	arg0.state_info_2 = var1.state_info_2
	arg0.state_info_3 = var1.state_info_3
	arg0.state_info_4 = var1.state_info_4
	arg0.equipmentSkins = {}
	arg0.equipments = {}

	if arg1.equip_info_list then
		for iter2, iter3 in ipairs(arg1.equip_info_list or {}) do
			arg0.equipments[iter2] = iter3.id > 0 and Equipment.New({
				count = 1,
				id = iter3.id,
				config_id = iter3.id,
				skinId = iter3.skinId
			}) or false
			arg0.equipmentSkins[iter2] = iter3.skinId > 0 and iter3.skinId or 0

			arg0:reletiveEquipSkin(iter2)
		end
	end

	arg0.spWeapon = nil

	if arg1.spweapon then
		arg0:UpdateSpWeapon(SpWeapon.CreateByNet(arg1.spweapon))
	end

	arg0.skills = {}

	for iter4, iter5 in ipairs(arg1.skill_id_list or {}) do
		arg0:updateSkill(iter5)
	end

	arg0.star = arg0:getConfig("rarity")
	arg0.transforms = {}

	for iter6, iter7 in ipairs(arg1.transform_list or {}) do
		arg0.transforms[iter7.id] = {
			id = iter7.id,
			level = iter7.level
		}
	end

	arg0.groupId = pg.ship_data_template[arg0.configId].group_type
	arg0.createTime = arg1.create_time or 0

	local var2 = getProxy(CollectionProxy)

	arg0.virgin = var2 and var2.shipGroups[arg0.groupId] == nil

	local var3 = {
		pg.gameset.test_ship_config_1.key_value,
		pg.gameset.test_ship_config_2.key_value,
		pg.gameset.test_ship_config_3.key_value
	}
	local var4 = table.indexof(var3, arg0.configId)

	if var4 == 1 then
		arg0.testShip = {
			2,
			3,
			4
		}
	elseif var4 == 2 then
		arg0.testShip = {
			5
		}
	elseif var4 == 3 then
		arg0.testShip = {
			6
		}
	else
		arg0.testShip = nil
	end

	arg0.maxIntimacy = pg.intimacy_template[#pg.intimacy_template.all].upper_bound

	if not HXSet.isHxSkin() then
		arg0.skinId = arg1.skin_id or 0
	else
		arg0.skinId = 0
	end

	if arg0.skinId == 0 then
		arg0.skinId = arg0:getConfig("skin_id")
	end

	if arg1.name and arg1.name ~= "" then
		arg0.name = arg1.name
	elseif arg0:isRemoulded() then
		arg0.name = pg.ship_skin_template[arg0:getRemouldSkinId()].name
	else
		arg0.name = pg.ship_data_statistics[arg0.configId].name
	end

	arg0.maxLevel = arg1.max_level
	arg0.proficiency = arg1.proficiency or 0
	arg0.preferenceTag = arg1.common_flag
	arg0.hpRant = 10000
	arg0.strategies = {}
	arg0.triggers = {}
	arg0.commanderId = arg1.commanderid or 0
	arg0.activityNpc = arg1.activity_npc or 0

	if var0.isMetaShipByConfigID(arg0.configId) then
		local var5 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0.configId)

		arg0.metaCharacter = MetaCharacter.New({
			id = var5,
			repair_attr_info = arg1.meta_repair_list
		}, arg0)
	end
end

function var0.isMetaShipByConfigID(arg0)
	local var0 = pg.ship_meta_breakout.all
	local var1 = var0[1]
	local var2 = false

	if var1 <= arg0 then
		for iter0, iter1 in ipairs(var0) do
			if arg0 == iter1 then
				var2 = true

				break
			end
		end
	end

	return var2
end

function var0.isMetaShip(arg0)
	return arg0.metaCharacter ~= nil
end

function var0.getMetaCharacter(arg0)
	return arg0.metaCharacter
end

function var0.unlockActivityNpc(arg0, arg1)
	arg0.activityNpc = arg1
end

function var0.isActivityNpc(arg0)
	return arg0.activityNpc > 0
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

function var0.isBluePrintShip(arg0)
	return arg0.bluePrintFlag == 1
end

function var0.updateSkinId(arg0, arg1)
	arg0.skinId = arg1
end

function var0.updateName(arg0)
	if arg0.name ~= pg.ship_data_statistics[arg0.configId].name then
		return
	end

	if arg0:isRemoulded() then
		arg0.name = pg.ship_skin_template[arg0:getRemouldSkinId()].name
	else
		arg0.name = pg.ship_data_statistics[arg0.configId].name
	end
end

function var0.isRemoulded(arg0)
	if arg0.remoulded then
		return true
	end

	local var0 = pg.ship_data_trans[arg0.groupId]

	if var0 then
		for iter0, iter1 in ipairs(var0.transform_list) do
			for iter2, iter3 in ipairs(iter1) do
				local var1 = pg.transform_data_template[iter3[2]]

				if var1.skin_id ~= 0 and arg0.transforms[iter3[2]] and arg0.transforms[iter3[2]].level == var1.max_level then
					return true
				end
			end
		end
	end

	return false
end

function var0.getRemouldSkinId(arg0)
	local var0 = ShipGroup.getModSkin(arg0.groupId)

	if var0 then
		return var0.id
	end

	return nil
end

function var0.hasEquipmentSkinInPos(arg0, arg1)
	local var0 = arg0.equipments[arg1]

	return var0 and var0:hasSkin()
end

function var0.getPrefab(arg0)
	local var0 = arg0.skinId

	if arg0:hasEquipmentSkinInPos(var2) then
		local var1 = arg0:getEquip(var2)
		local var2 = var7[var1:getSkinId()].ship_skin_id

		var0 = var2 ~= 0 and var2 or var0
	end

	local var3 = pg.ship_skin_template[var0]

	assert(var3, "ship_skin_template not exist: " .. arg0.configId .. " " .. var0)

	return var3.prefab
end

function var0.getAttachmentPrefab(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.equipments) do
		if iter1 and iter1:hasSkinOrbit() then
			local var1 = iter1:getSkinId()

			var0[var1] = var7[var1]
		end
	end

	return var0
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

function var0.getRemouldPainting(arg0)
	local var0 = pg.ship_skin_template[arg0:getRemouldSkinId()]

	assert(var0, "ship_skin_template not exist: " .. arg0.configId .. " " .. arg0.skinId)

	return var0.painting
end

function var0.updateStateInfo34(arg0, arg1, arg2)
	arg0.state_info_3 = arg1
	arg0.state_info_4 = arg2
end

function var0.hasStateInfo3Or4(arg0)
	return arg0.state_info_3 ~= 0 or arg0.state_info_4 ~= 0
end

function var0.isTestShip(arg0)
	return arg0.testShip
end

function var0.canUseTestShip(arg0, arg1)
	assert(arg0.testShip, "ship is not TestShip")

	return table.contains(arg0.testShip, arg1)
end

function var0.updateEquip(arg0, arg1, arg2)
	assert(arg2 == nil or arg2.count == 1)

	local var0 = arg0.equipments[arg1]

	arg0.equipments[arg1] = arg2 and Clone(arg2) or false

	local function var1(arg0)
		arg0 = CreateShell(arg0)
		arg0.shipId = arg0.id
		arg0.shipPos = arg1

		return arg0
	end

	if var0 then
		getProxy(EquipmentProxy):OnShipEquipsRemove(var0, arg0.id, arg1)
		var0:setSkinId(0)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_REMOVED, var1(var0))
	end

	if arg2 then
		getProxy(EquipmentProxy):OnShipEquipsAdd(arg2, arg0.id, arg1)
		arg0:reletiveEquipSkin(arg1)
		pg.m02:sendNotification(BayProxy.SHIP_EQUIPMENT_ADDED, var1(arg2))
	end
end

function var0.reletiveEquipSkin(arg0, arg1)
	if arg0.equipments[arg1] and arg0.equipmentSkins[arg1] ~= 0 then
		local var0 = pg.equip_skin_template[arg0.equipmentSkins[arg1]].equip_type
		local var1 = arg0.equipments[arg1]:getType()

		if table.contains(var0, var1) then
			arg0.equipments[arg1]:setSkinId(arg0.equipmentSkins[arg1])
		else
			arg0.equipments[arg1]:setSkinId(0)
		end
	elseif arg0.equipments[arg1] then
		arg0.equipments[arg1]:setSkinId(0)
	end
end

function var0.updateEquipmentSkin(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	if arg2 and arg2 > 0 then
		local var0 = arg0:getSkinTypes(arg1)
		local var1 = pg.equip_skin_template[arg2].equip_type
		local var2 = false

		for iter0, iter1 in ipairs(var0) do
			for iter2, iter3 in ipairs(var1) do
				if iter1 == iter3 then
					var2 = true

					break
				end
			end
		end

		if not var2 then
			assert(var2, "部位" .. arg1 .. " 无法穿戴皮肤 " .. arg2)

			return
		end

		local var3 = arg0.equipments[arg1] and arg0.equipments[arg1]:getType() or false

		arg0.equipmentSkins[arg1] = arg2

		if var3 and table.contains(var1, var3) then
			arg0.equipments[arg1]:setSkinId(arg0.equipmentSkins[arg1])
		elseif var3 and not table.contains(var1, var3) then
			arg0.equipments[arg1]:setSkinId(0)
		end
	else
		arg0.equipmentSkins[arg1] = 0

		if arg0.equipments[arg1] then
			arg0.equipments[arg1]:setSkinId(0)
		end
	end
end

function var0.getEquip(arg0, arg1)
	return Clone(arg0.equipments[arg1])
end

function var0.getEquipSkins(arg0)
	return Clone(arg0.equipmentSkins)
end

function var0.getEquipSkin(arg0, arg1)
	return arg0.equipmentSkins[arg1]
end

function var0.getCanEquipSkin(arg0, arg1)
	local var0 = arg0:getSkinTypes(arg1)

	if var0 and #var0 then
		for iter0, iter1 in ipairs(var0) do
			if pg.equip_data_by_type[iter1].equip_skin == 1 then
				return true
			end
		end
	end

	return false
end

function var0.checkCanEquipSkin(arg0, arg1, arg2)
	if not arg1 or not arg2 then
		return
	end

	local var0 = arg0:getSkinTypes(arg1)
	local var1 = pg.equip_skin_template[arg2].equip_type

	for iter0, iter1 in ipairs(var0) do
		if table.contains(var1, iter1) then
			return true
		end
	end

	return false
end

function var0.getSkinTypes(arg0, arg1)
	return pg.ship_data_template[arg0.configId]["equip_" .. arg1] or {}
end

function var0.updateState(arg0, arg1)
	arg0.state = arg1
end

function var0.addSkillExp(arg0, arg1, arg2)
	local var0 = arg0.skills[arg1] or {
		exp = 0,
		level = 1,
		id = arg1
	}
	local var1 = var0.level and var0.level or 1
	local var2 = pg.skill_need_exp.all[#pg.skill_need_exp.all]

	if var1 == var2 then
		return
	end

	local var3 = var0.exp and arg2 + var0.exp or 0 + arg2

	while var3 >= pg.skill_need_exp[var1].exp do
		var3 = var3 - pg.skill_need_exp[var1].exp
		var1 = var1 + 1

		if var1 == var2 then
			var3 = 0

			break
		end
	end

	arg0:updateSkill({
		id = var0.id,
		level = var1,
		exp = var3
	})
end

function var0.upSkillLevelForMeta(arg0, arg1)
	local var0 = arg0.skills[arg1] or {
		exp = 0,
		level = 0,
		id = arg1
	}
	local var1 = arg0:isSkillLevelMax(arg1)
	local var2 = var0.level

	if not var1 then
		var2 = var2 + 1
	end

	arg0:updateSkill({
		exp = 0,
		id = var0.id,
		level = var2
	})
end

function var0.getMetaSkillLevelBySkillID(arg0, arg1)
	return (arg0.skills[arg1] or {
		exp = 0,
		level = 0,
		id = arg1
	}).level
end

function var0.isSkillLevelMax(arg0, arg1)
	local var0 = arg0.skills[arg1] or {
		exp = 0,
		level = 1,
		id = arg1
	}

	return (var0.level and var0.level or 1) >= pg.skill_data_template[arg1].max_level
end

function var0.isAllMetaSkillLevelMax(arg0)
	local var0 = true
	local var1 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0.configId)

	for iter0, iter1 in ipairs(var1) do
		if not arg0:isSkillLevelMax(iter1) then
			var0 = false

			break
		end
	end

	return var0
end

function var0.isAllMetaSkillLock(arg0)
	local var0 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0.configId)
	local var1 = true

	for iter0, iter1 in ipairs(var0) do
		if arg0:getMetaSkillLevelBySkillID(iter1) > 0 then
			var1 = false

			break
		end
	end

	return var1
end

function var0.bindConfigTable(arg0)
	return pg.ship_data_statistics
end

function var0.isAvaiable(arg0)
	return true
end

var0.PROPERTIES = {
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
var0.PROPERTIES_ENHANCEMENT = {
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
var0.DIVE_PROPERTIES = {
	AttributeType.OxyMax,
	AttributeType.OxyCost,
	AttributeType.OxyRecovery,
	AttributeType.OxyRecoveryBench,
	AttributeType.OxyRecoverySurface,
	AttributeType.OxyAttackDuration,
	AttributeType.OxyRaidDistance
}
var0.SONAR_PROPERTIES = {
	AttributeType.SonarRange
}

function var0.intimacyAdditions(arg0, arg1)
	local var0 = pg.intimacy_template[arg0:getIntimacyLevel()].attr_bonus * 0.0001

	for iter0, iter1 in pairs(arg1) do
		if iter0 == AttributeType.Durability or iter0 == AttributeType.Cannon or iter0 == AttributeType.Torpedo or iter0 == AttributeType.AntiAircraft or iter0 == AttributeType.AntiSub or iter0 == AttributeType.Air or iter0 == AttributeType.Reload or iter0 == AttributeType.Hit or iter0 == AttributeType.Dodge then
			arg1[iter0] = arg1[iter0] * (var0 + 1)
		end
	end
end

function var0.getShipProperties(arg0)
	local var0 = arg0:getBaseProperties()

	if arg0:isBluePrintShip() then
		local var1 = arg0:getBluePrint()

		assert(var1, "blueprint can not be nil" .. arg0.configId)

		local var2 = var1:getTotalAdditions()

		for iter0, iter1 in pairs(var2) do
			var0[iter0] = var0[iter0] + calcFloor(iter1)
		end

		arg0:intimacyAdditions(var0)
	elseif arg0:isMetaShip() then
		assert(arg0.metaCharacter)

		for iter2, iter3 in pairs(var0) do
			var0[iter2] = var0[iter2] + arg0.metaCharacter:getAttrAddition(iter2)
		end

		arg0:intimacyAdditions(var0)
	else
		local var3 = pg.ship_data_template[arg0.configId].strengthen_id
		local var4 = var5[var3]

		for iter4, iter5 in pairs(arg0.strengthList) do
			local var5 = ShipModAttr.ATTR_TO_INDEX[iter4]
			local var6 = math.min(iter5, var4.durability[var5] * var4.level_exp[var5])
			local var7 = math.max(arg0:getModExpRatio(iter4), 1)

			var0[iter4] = var0[iter4] + calcFloor(var6 / var7)
		end

		arg0:intimacyAdditions(var0)

		for iter6, iter7 in pairs(arg0.transforms) do
			local var8 = pg.transform_data_template[iter7.id].effect

			for iter8 = 1, iter7.level do
				local var9 = var8[iter8] or {}

				for iter9, iter10 in pairs(var0) do
					if var9[iter9] then
						var0[iter9] = var0[iter9] + var9[iter9]
					end
				end
			end
		end
	end

	return var0
end

function var0.getTechNationAddition(arg0, arg1)
	local var0 = getProxy(TechnologyNationProxy)
	local var1 = arg0:getConfig("type")

	if var1 == ShipType.DaoQuV or var1 == ShipType.DaoQuM then
		var1 = ShipType.QuZhu
	end

	return var0:getShipAddition(var1, arg1)
end

function var0.getTechNationMaxAddition(arg0, arg1)
	local var0 = getProxy(TechnologyNationProxy)
	local var1 = arg0:getConfig("type")

	return var0:getShipMaxAddition(var1, arg1)
end

function var0.getEquipProficiencyByPos(arg0, arg1)
	return arg0:getEquipProficiencyList()[arg1]
end

function var0.getEquipProficiencyList(arg0)
	local var0 = arg0:getConfigTable()
	local var1 = Clone(var0.equipment_proficiency)

	if arg0:isBluePrintShip() then
		local var2 = arg0:getBluePrint()

		assert(var2, "blueprint can not be nil >>>" .. arg0.groupId)

		var1 = var2:getEquipProficiencyList(arg0)
	else
		for iter0, iter1 in ipairs(var1) do
			local var3 = 0

			for iter2, iter3 in pairs(arg0.transforms) do
				local var4 = pg.transform_data_template[iter3.id].effect

				for iter4 = 1, iter3.level do
					local var5 = var4[iter4] or {}

					if var5["equipment_proficiency_" .. iter0] then
						var3 = var3 + var5["equipment_proficiency_" .. iter0]
					end
				end
			end

			var1[iter0] = iter1 + var3
		end
	end

	return var1
end

function var0.getBaseProperties(arg0)
	local var0 = arg0:getConfigTable()

	assert(var0, "配置表没有这艘船" .. arg0.configId)

	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0.PROPERTIES) do
		var1[iter1] = arg0:getGrowthForAttr(iter1)
		var2[iter1] = var1[iter1]
	end

	for iter2, iter3 in ipairs(arg0:getConfig("lock")) do
		var2[iter3] = var1[iter3]
	end

	for iter4, iter5 in ipairs(var0.DIVE_PROPERTIES) do
		var2[iter5] = var0[iter5]
	end

	for iter6, iter7 in ipairs(var0.SONAR_PROPERTIES) do
		var2[iter7] = 0
	end

	return var2
end

function var0.getGrowthForAttr(arg0, arg1)
	local var0 = arg0:getConfigTable()
	local var1 = table.indexof(var0.PROPERTIES, arg1)
	local var2 = pg.gameset.extra_attr_level_limit.key_value
	local var3 = var0.attrs[var1] + (arg0.level - 1) * var0.attrs_growth[var1] / 1000

	if var2 < arg0.level then
		var3 = var3 + (arg0.level - var2) * var0.attrs_growth_extra[var1] / 1000
	end

	return var3
end

function var0.isMaxStar(arg0)
	return arg0:getStar() >= arg0:getMaxStar()
end

function var0.IsMaxStarByTmpID(arg0)
	local var0 = pg.ship_data_template[arg0]

	return var0.star >= var0.star_max
end

function var0.IsSpweaponUnlock(arg0)
	if not arg0:CanAccumulateExp() then
		return false, "spweapon_tip_locked"
	else
		return true
	end
end

function var0.getModProperties(arg0, arg1)
	return arg0.strengthList[arg1] or 0
end

function var0.addModAttrExp(arg0, arg1, arg2)
	local var0 = arg0:getModAttrTopLimit(arg1)

	if var0 == 0 then
		return
	end

	local var1 = arg0:getModExpRatio(arg1)
	local var2 = arg0:getModProperties(arg1)

	if var2 + arg2 > var0 * var1 then
		arg0.strengthList[arg1] = var0 * var1
	else
		arg0.strengthList[arg1] = var2 + arg2
	end
end

function var0.getNeedModExp(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(ShipModAttr.ID_TO_ATTR) do
		local var1 = arg0:getModAttrTopLimit(iter1)

		if var1 == 0 then
			var0[iter1] = 0
		else
			var0[iter1] = var1 * arg0:getModExpRatio(iter1) - arg0:getModProperties(iter1)
		end
	end

	return var0
end

function var0.attrVertify(arg0)
	if not BayProxy.checkShiplevelVertify(arg0) then
		return false
	end

	for iter0, iter1 in ipairs(arg0.equipments) do
		if iter1 and not iter1:vertify() then
			return false
		end
	end

	return true
end

function var0.getEquipmentProperties(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(var0.PROPERTIES) do
		var0[iter1] = 0
	end

	for iter2, iter3 in ipairs(var0.DIVE_PROPERTIES) do
		var0[iter3] = 0
	end

	for iter4, iter5 in ipairs(var0.SONAR_PROPERTIES) do
		var0[iter5] = 0
	end

	for iter6, iter7 in ipairs(var0.PROPERTIES_ENHANCEMENT) do
		var1[iter7] = 0
	end

	var0[AttributeType.AirDominate] = 0
	var0[AttributeType.AntiSiren] = 0

	local var2 = arg0:getActiveEquipments()

	for iter8, iter9 in ipairs(var2) do
		if iter9 then
			local var3 = iter9:GetAttributes()

			for iter10, iter11 in ipairs(var3) do
				if iter11 and var0[iter11.type] then
					var0[iter11.type] = var0[iter11.type] + iter11.value
				end
			end

			local var4 = iter9:GetPropertyRate()

			for iter12, iter13 in pairs(var4) do
				var1[iter12] = math.max(var1[iter12], iter13)
			end

			local var5 = iter9:GetSonarProperty()

			if var5 then
				for iter14, iter15 in pairs(var5) do
					var0[iter14] = var0[iter14] + iter15
				end
			end

			local var6 = iter9:GetAntiSirenPower()

			if var6 then
				var0[AttributeType.AntiSiren] = var0[AttributeType.AntiSiren] + var6 / 10000
			end
		end
	end

	;(function()
		local var0 = arg0:GetSpWeapon()

		if not var0 then
			return
		end

		local var1 = var0:GetPropertiesInfo().attrs

		for iter0, iter1 in ipairs(var1) do
			if iter1 and var0[iter1.type] then
				var0[iter1.type] = var0[iter1.type] + iter1.value
			end
		end
	end)()

	for iter16, iter17 in pairs(var1) do
		var1[iter16] = iter17 + 1
	end

	return var0, var1
end

function var0.getSkillEffects(arg0)
	local var0 = arg0:getShipSkillEffects()

	_.each(arg0:getEquipmentSkillEffects(), function(arg0)
		table.insert(var0, arg0)
	end)

	return var0
end

function var0.getShipSkillEffects(arg0)
	local var0 = {}
	local var1 = arg0:getSkillList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = arg0:RemapSkillId(iter1)
		local var3 = require("GameCfg.buff.buff_" .. var2)

		arg0:FilterActiveSkill(var0, var3, arg0.skills[iter1])
	end

	return var0
end

function var0.getEquipmentSkillEffects(arg0)
	local var0 = {}
	local var1 = arg0:getActiveEquipments()

	for iter0, iter1 in ipairs(var1) do
		local var2
		local var3 = iter1 and iter1:getConfig("skill_id")[1]

		if var3 then
			var2 = require("GameCfg.buff.buff_" .. var3)
		end

		arg0:FilterActiveSkill(var0, var2)
	end

	;(function()
		local var0 = arg0:GetSpWeapon()
		local var1 = var0 and var0:GetEffect() or 0
		local var2

		if var1 > 0 then
			var2 = require("GameCfg.buff.buff_" .. var1)
		end

		arg0:FilterActiveSkill(var0, var2)
	end)()

	return var0
end

function var0.FilterActiveSkill(arg0, arg1, arg2, arg3)
	if not arg2 or not arg2.const_effect_list then
		return
	end

	for iter0 = 1, #arg2.const_effect_list do
		local var0 = arg2.const_effect_list[iter0]
		local var1 = var0.trigger
		local var2 = var0.arg_list
		local var3 = 1

		if arg3 then
			var3 = arg3.level

			local var4 = arg2[var3].const_effect_list

			if var4 and var4[iter0] then
				var1 = var4[iter0].trigger or var1
				var2 = var4[iter0].arg_list or var2
			end
		end

		local var5 = true

		for iter1, iter2 in pairs(var1) do
			if arg0.triggers[iter1] ~= iter2 then
				var5 = false

				break
			end
		end

		if var5 then
			table.insert(arg1, {
				type = var0.type,
				arg_list = var2,
				level = var3
			})
		end
	end
end

function var0.getEquipmentGearScore(arg0)
	local var0 = 0
	local var1 = arg0:getActiveEquipments()

	for iter0, iter1 in ipairs(var1) do
		if iter1 then
			var0 = var0 + iter1:GetGearScore()
		end
	end

	return var0
end

function var0.getProperties(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1 or {}
	local var1 = arg0:getConfig("nationality")
	local var2 = arg0:getConfig("type")
	local var3 = arg0:getShipProperties()
	local var4, var5 = arg0:getEquipmentProperties()
	local var6
	local var7
	local var8

	if arg3 and arg0:getFlag("inWorld") then
		local var9 = WorldConst.FetchWorldShip(arg0.id)

		var6, var7 = var9:GetShipBuffProperties()
		var8 = var9:GetShipPowerBuffProperties()
	end

	for iter0, iter1 in ipairs(var0.PROPERTIES) do
		local var10 = 0
		local var11 = 0

		for iter2, iter3 in pairs(var0) do
			var10 = var10 + iter3:getAttrRatioAddition(iter1, var1, var2) / 100
			var11 = var11 + iter3:getAttrValueAddition(iter1, var1, var2)
		end

		local var12 = var10 + (var5[iter1] or 1)
		local var13 = var7 and var7[iter1] or 1
		local var14 = var6 and var6[iter1] or 0

		if iter1 == AttributeType.Speed then
			var3[iter1] = var3[iter1] * var12 * var13 + var11 + var4[iter1] + var14
		else
			var3[iter1] = calcFloor(calcFloor(var3[iter1]) * var12 * var13) + var11 + var4[iter1] + var14
		end
	end

	if not arg2 and arg0:isMaxStar() then
		for iter4, iter5 in pairs(var3) do
			local var15 = arg4 and arg0:getTechNationMaxAddition(iter4) or arg0:getTechNationAddition(iter4)

			var3[iter4] = var3[iter4] + var15
		end
	end

	for iter6, iter7 in ipairs(var0.DIVE_PROPERTIES) do
		var3[iter7] = var3[iter7] + var4[iter7]
	end

	for iter8, iter9 in ipairs(var0.SONAR_PROPERTIES) do
		var3[iter9] = var3[iter9] + var4[iter9]
	end

	if arg3 then
		var3[AttributeType.AntiSiren] = (var3[AttributeType.AntiSiren] or 0) + var4[AttributeType.AntiSiren]
	end

	if var8 then
		for iter10, iter11 in pairs(var8) do
			if var3[iter10] then
				if iter10 == AttributeType.Speed then
					var3[iter10] = var3[iter10] * iter11
				else
					var3[iter10] = math.floor(var3[iter10] * iter11)
				end
			end
		end
	end

	return var3
end

function var0.getTransGearScore(arg0)
	local var0 = 0
	local var1 = pg.transform_data_template

	for iter0, iter1 in pairs(arg0.transforms) do
		for iter2 = 1, iter1.level do
			var0 = var0 + (var1[iter1.id].gear_score[iter2] or 0)
		end
	end

	return var0
end

function var0.getShipCombatPower(arg0, arg1)
	local var0 = arg0:getProperties(arg1, nil, nil, true)
	local var1 = var0[AttributeType.Durability] / 5 + var0[AttributeType.Cannon] + var0[AttributeType.Torpedo] + var0[AttributeType.AntiAircraft] + var0[AttributeType.Air] + var0[AttributeType.AntiSub] + var0[AttributeType.Reload] + var0[AttributeType.Hit] * 2 + var0[AttributeType.Dodge] * 2 + var0[AttributeType.Speed] + arg0:getEquipmentGearScore() + arg0:getTransGearScore()

	return math.floor(var1)
end

function var0.cosumeEnergy(arg0, arg1)
	arg0:setEnergy(math.max(arg0:getEnergy() - arg1, 0))
end

function var0.addEnergy(arg0, arg1)
	arg0:setEnergy(arg0:getEnergy() + arg1)
end

function var0.setEnergy(arg0, arg1)
	arg0.energy = arg1
end

function var0.setLikability(arg0, arg1)
	assert(arg1 >= 0 and arg1 <= arg0.maxIntimacy, "intimacy value invaild" .. arg1)
	arg0:setIntimacy(arg1)
end

function var0.addLikability(arg0, arg1)
	local var0 = Mathf.Clamp(arg0:getIntimacy() + arg1, 0, arg0.maxIntimacy)

	arg0:setIntimacy(var0)
end

function var0.setIntimacy(arg0, arg1)
	if arg1 > 10000 and not arg0.propose then
		arg1 = 10000
	end

	arg0.intimacy = arg1

	if not arg0:isActivityNpc() then
		getProxy(CollectionProxy).shipGroups[arg0.groupId]:updateMaxIntimacy(arg0:getIntimacy())
	end
end

function var0.getLevelExpConfig(arg0, arg1)
	if arg0:getConfig("rarity") == ShipRarity.SSR then
		local var0 = Clone(getConfigFromLevel1(var6, arg1 or arg0.level))

		var0.exp = var0.exp_ur
		var0.exp_start = var0.exp_ur_start
		var0.exp_interval = var0.exp_ur_interval
		var0.exp_end = var0.exp_ur_end

		return var0
	else
		return getConfigFromLevel1(var6, arg1 or arg0.level)
	end
end

function var0.getExp(arg0)
	local var0 = arg0:getMaxLevel()

	if arg0.level == var0 and LOCK_FULL_EXP then
		return 0
	end

	return arg0.exp
end

function var0.getProficiency(arg0)
	return arg0.proficiency
end

function var0.addExp(arg0, arg1, arg2)
	local var0 = arg0:getMaxLevel()

	if arg0.level == var0 then
		if arg0.exp >= pg.gameset.exp_overflow_max.key_value then
			return
		end

		if LOCK_FULL_EXP or not arg2 or not arg0:CanAccumulateExp() then
			arg1 = 0
		end
	end

	arg0.exp = arg0.exp + arg1

	local var1 = false

	while arg0:canLevelUp() do
		arg0.exp = arg0.exp - arg0:getLevelExpConfig().exp_interval
		arg0.level = math.min(arg0.level + 1, var0)
		var1 = true
	end

	if arg0.level == var0 then
		if arg2 and arg0:CanAccumulateExp() then
			arg0.exp = math.min(arg0.exp, pg.gameset.exp_overflow_max.key_value)
		elseif var1 then
			arg0.exp = 0
		end
	end
end

function var0.getMaxLevel(arg0)
	return arg0.maxLevel
end

function var0.canLevelUp(arg0)
	local var0 = arg0:getLevelExpConfig(arg0.level + 1)
	local var1 = arg0:getMaxLevel() <= arg0.level

	return var0 and arg0:getLevelExpConfig().exp_interval <= arg0.exp and not var1
end

function var0.getConfigMaxLevel(arg0)
	return var6.all[#var6.all]
end

function var0.isConfigMaxLevel(arg0)
	return arg0.level == arg0:getConfigMaxLevel()
end

function var0.updateMaxLevel(arg0, arg1)
	local var0 = arg0:getConfigMaxLevel()

	arg0.maxLevel = math.max(math.min(var0, arg1), arg0.maxLevel)
end

function var0.getNextMaxLevel(arg0)
	local var0 = arg0:getConfigMaxLevel()

	for iter0 = arg0:getMaxLevel() + 1, var0 do
		if var6[iter0].level_limit == 1 then
			return iter0
		end
	end
end

function var0.canUpgrade(arg0)
	if arg0:isMetaShip() or arg0:isBluePrintShip() then
		return false
	else
		local var0 = var8[arg0.configId]

		assert(var0, "不存在配置" .. arg0.configId)

		return not arg0:isMaxStar() and arg0.level >= var0.level
	end
end

function var0.isReachNextMaxLevel(arg0)
	return arg0.level == arg0:getMaxLevel() and arg0:CanAccumulateExp() and arg0:getNextMaxLevel() ~= nil
end

function var0.isAwakening(arg0)
	return arg0:isReachNextMaxLevel() and arg0.level < var4
end

function var0.isAwakening2(arg0)
	return arg0:isReachNextMaxLevel() and arg0.level >= var4
end

function var0.notMaxLevelForFilter(arg0)
	return arg0.level ~= arg0:getMaxLevel()
end

function var0.getNextMaxLevelConsume(arg0)
	local var0 = arg0:getMaxLevel()
	local var1 = var6[var0]["need_item_rarity" .. arg0:getConfig("rarity")]

	assert(var1, "items  can not be nil")

	return _.map(var1, function(arg0)
		return {
			type = arg0[1],
			id = arg0[2],
			count = arg0[3]
		}
	end)
end

function var0.canUpgradeMaxLevel(arg0)
	if not arg0:isReachNextMaxLevel() then
		return false, i18n("upgrade_to_next_maxlevel_failed")
	else
		local var0 = getProxy(PlayerProxy):getData()
		local var1 = getProxy(BagProxy)
		local var2 = arg0:getNextMaxLevelConsume()

		for iter0, iter1 in pairs(var2) do
			if iter1.type == DROP_TYPE_RESOURCE then
				if var0:getResById(iter1.id) < iter1.count then
					return false, i18n("common_no_resource")
				end
			elseif iter1.type == DROP_TYPE_ITEM and var1:getItemCountById(iter1.id) < iter1.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0.CanAccumulateExp(arg0)
	return pg.ship_data_template[arg0.configId].can_get_proficency == 1
end

function var0.getTotalExp(arg0)
	return arg0:getLevelExpConfig().exp_start + arg0.exp
end

function var0.getStartBattleExpend(arg0)
	if table.contains(TeamType.SubShipType, arg0:getShipType()) then
		return 0
	else
		return pg.ship_data_template[arg0.configId].oil_at_start
	end
end

function var0.getEndBattleExpend(arg0)
	local var0 = pg.ship_data_template[arg0.configId]
	local var1 = arg0:getLevelExpConfig()

	return (math.floor(var0.oil_at_end * var1.fight_oil_ratio / 10000))
end

function var0.getBattleTotalExpend(arg0)
	return arg0:getStartBattleExpend() + arg0:getEndBattleExpend()
end

function var0.getShipAmmo(arg0)
	local var0 = arg0:getConfig(AttributeType.Ammo)

	for iter0, iter1 in pairs(arg0:getAllSkills()) do
		local var1 = tonumber(iter0 .. string.format("%.2d", iter1.level))
		local var2 = pg.skill_benefit_template[var1]

		if var2 and arg0:IsBenefitSkillActive(var2) and (var2.type == var0.BENEFIT_EQUIP or var2.type == var0.BENEFIT_SKILL) then
			var0 = var0 + defaultValue(var2.effect[1], 0)
		end
	end

	local var3 = arg0:getActiveEquipments()

	for iter2, iter3 in ipairs(var3) do
		local var4 = iter3 and iter3:getConfig("equip_parameters").ammo

		if var4 then
			var0 = var0 + var4
		end
	end

	return var0
end

function var0.getHuntingLv(arg0)
	local var0 = arg0:getConfig("huntingrange_level")

	for iter0, iter1 in pairs(arg0:getAllSkills()) do
		local var1 = tonumber(iter0 .. string.format("%.2d", iter1.level))
		local var2 = pg.skill_benefit_template[var1]

		if var2 and arg0:IsBenefitSkillActive(var2) and (var2.type == var0.BENEFIT_EQUIP or var2.type == var0.BENEFIT_SKILL) then
			var0 = var0 + defaultValue(var2.effect[2], 0)
		end
	end

	local var3 = arg0:getActiveEquipments()

	for iter2, iter3 in ipairs(var3) do
		local var4 = iter3 and iter3:getConfig("equip_parameters").hunting_lv

		if var4 then
			var0 = var0 + var4
		end
	end

	return (math.min(var0, arg0:getMaxHuntingLv()))
end

function var0.getMapAuras(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:getAllSkills()) do
		local var1 = tonumber(iter0 .. string.format("%.2d", iter1.level))
		local var2 = pg.skill_benefit_template[var1]

		if var2 and arg0:IsBenefitSkillActive(var2) and var2.type == var0.BENEFIT_MAP_AURA then
			local var3 = {
				id = var2.effect[1],
				level = iter1.level
			}

			table.insert(var0, var3)
		end
	end

	return var0
end

function var0.getMapAids(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:getAllSkills()) do
		local var1 = tonumber(iter0 .. string.format("%.2d", iter1.level))
		local var2 = pg.skill_benefit_template[var1]

		if var2 and arg0:IsBenefitSkillActive(var2) and var2.type == var0.BENEFIT_AID then
			local var3 = {
				id = var2.effect[1],
				level = iter1.level
			}

			table.insert(var0, var3)
		end
	end

	return var0
end

var0.BENEFIT_SKILL = 2
var0.BENEFIT_EQUIP = 3
var0.BENEFIT_MAP_AURA = 4
var0.BENEFIT_AID = 5

function var0.IsBenefitSkillActive(arg0, arg1)
	local var0 = false

	if arg1.type == var0.BENEFIT_SKILL then
		if not arg1.limit[1] or arg1.limit[1] == arg0.triggers.TeamNumbers then
			var0 = true
		end
	elseif arg1.type == var0.BENEFIT_EQUIP then
		local var1 = arg1.limit
		local var2 = arg0:getAllEquipments()

		for iter0, iter1 in ipairs(var2) do
			if iter1 and table.contains(var1, iter1:getConfig("id")) then
				var0 = true

				break
			end
		end
	elseif arg1.type == var0.BENEFIT_MAP_AURA then
		if arg0.hpRant and arg0.hpRant > 0 then
			return true
		end
	elseif arg1.type == var0.BENEFIT_AID and arg0.hpRant and arg0.hpRant > 0 then
		return true
	end

	return var0
end

function var0.getMaxHuntingLv(arg0)
	return #arg0:getConfig("hunting_range")
end

function var0.getHuntingRange(arg0, arg1)
	local var0 = arg0:getConfig("hunting_range")
	local var1 = Clone(var0[1])
	local var2 = arg1 or arg0:getHuntingLv()
	local var3 = math.min(var2, arg0:getMaxHuntingLv())

	for iter0 = 2, var3 do
		_.each(var0[iter0], function(arg0)
			table.insert(var1, {
				arg0[1],
				arg0[2]
			})
		end)
	end

	return var1
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

	;(function()
		local var0 = arg0:GetSpWeapon()
		local var1 = var0 and var0:GetEffect() or 0

		if var1 > 0 then
			var0[var1] = {
				level = 1,
				id = var1
			}
		end
	end)()

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

function var0.isSameKind(arg0, arg1)
	return pg.ship_data_template[arg0.configId].group_type == pg.ship_data_template[arg1.configId].group_type
end

function var0.GetLockState(arg0)
	return arg0.lockState
end

function var0.IsLocked(arg0)
	return arg0.lockState == var0.LOCK_STATE_LOCK
end

function var0.SetLockState(arg0, arg1)
	arg0.lockState = arg1
end

function var0.GetPreferenceTag(arg0)
	return arg0.preferenceTag or 0
end

function var0.IsPreferenceTag(arg0)
	return arg0:GetPreferenceTag() == var0.PREFERENCE_TAG_COMMON
end

function var0.SetPreferenceTag(arg0, arg1)
	arg0.preferenceTag = arg1
end

function var0.calReturnRes(arg0)
	local var0 = pg.ship_data_by_type[arg0:getShipType()]
	local var1 = var0.distory_resource_gold_ratio
	local var2 = var0.distory_resource_oil_ratio
	local var3 = pg.ship_data_by_star[arg0:getConfig("rarity")].destory_item

	return var1, 0, var3
end

function var0.getRarity(arg0)
	local var0 = arg0:getConfig("rarity")

	if arg0:isRemoulded() then
		var0 = var0 + 1
	end

	return var0
end

function var0.getExchangePrice(arg0)
	local var0 = arg0:getConfig("rarity")

	return pg.ship_data_by_star[var0].exchange_price
end

function var0.updateSkill(arg0, arg1)
	local var0 = arg1.skill_id or arg1.id
	local var1 = arg1.skill_lv or arg1.lv or arg1.level
	local var2 = arg1.skill_exp or arg1.exp

	arg0.skills[var0] = {
		id = var0,
		level = var1,
		exp = var2
	}
end

function var0.canEquipAtPos(arg0, arg1, arg2)
	local var0, var1 = arg0:isForbiddenAtPos(arg1, arg2)

	if var0 then
		return false, var1
	end

	for iter0, iter1 in ipairs(arg0.equipments) do
		if iter1 and iter0 ~= arg2 and iter1:getConfig("equip_limit") ~= 0 and arg1:getConfig("equip_limit") == iter1:getConfig("equip_limit") then
			return false, i18n("ship_equip_same_group_equipment")
		end
	end

	return true
end

function var0.isForbiddenAtPos(arg0, arg1, arg2)
	local var0 = pg.ship_data_template[arg0.configId]

	assert(var0, "can not find ship in ship_data_templtae: " .. arg0.configId)

	local var1 = var0["equip_" .. arg2]

	if not table.contains(var1, arg1:getConfig("type")) then
		return true, i18n("common_limit_equip")
	end

	if table.contains(arg1:getConfig("ship_type_forbidden"), arg0:getShipType()) then
		return true, i18n("common_limit_equip")
	end

	return false
end

function var0.canEquipCommander(arg0, arg1)
	if arg1:getShipType() ~= arg0:getShipType() then
		return false, i18n("commander_type_unmatch")
	end

	return true
end

function var0.upgrade(arg0)
	local var0 = pg.ship_data_transform[arg0.configId]

	if var0.trans_id and var0.trans_id > 0 then
		arg0.configId = var0.trans_id
		arg0.star = arg0:getConfig("star")
	end
end

function var0.getTeamType(arg0)
	return TeamType.GetTeamFromShipType(arg0:getShipType())
end

function var0.getFleetName(arg0)
	local var0 = arg0:getTeamType()

	return var1[var0]
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

function var0.getFlag(arg0, arg1, arg2)
	return pg.ShipFlagMgr.GetInstance():GetShipFlag(arg0.id, arg1, arg2)
end

function var0.hasAnyFlag(arg0, arg1)
	return _.any(arg1, function(arg0)
		return arg0:getFlag(arg0)
	end)
end

function var0.isBreakOut(arg0)
	return arg0.configId % 10 > 1
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

function var0.RemapSkillId(arg0, arg1)
	local var0 = arg0:GetSpWeapon()

	if var0 then
		return var0:RemapSkillId(arg1)
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

function var0.getModAttrTopLimit(arg0, arg1)
	local var0 = ShipModAttr.ATTR_TO_INDEX[arg1]
	local var1 = pg.ship_data_template[arg0.configId].strengthen_id
	local var2 = pg.ship_data_strengthen[var1].durability[var0]

	return calcFloor((3 + 7 * (math.min(arg0.level, 100) / 100)) * var2 * 0.1)
end

function var0.leftModAdditionPoint(arg0, arg1)
	local var0 = arg0:getModProperties(arg1)
	local var1 = arg0:getModExpRatio(arg1)
	local var2 = arg0:getModAttrTopLimit(arg1)
	local var3 = calcFloor(var0 / var1)

	return math.max(0, var2 - var3)
end

function var0.getModAttrBaseMax(arg0, arg1)
	if not table.contains(arg0:getConfig("lock"), arg1) then
		local var0 = arg0:leftModAdditionPoint(arg1)
		local var1 = arg0:getShipProperties()

		return calcFloor(var1[arg1] + var0)
	else
		return 0
	end
end

function var0.getModExpRatio(arg0, arg1)
	if not table.contains(arg0:getConfig("lock"), arg1) then
		local var0 = pg.ship_data_template[arg0.configId].strengthen_id

		assert(pg.ship_data_strengthen[var0], "ship_data_strengthen>>>>>>" .. var0)

		return math.max(pg.ship_data_strengthen[var0].level_exp[ShipModAttr.ATTR_TO_INDEX[arg1]], 1)
	else
		return 1
	end
end

function var0.inUnlockTip(arg0)
	local var0 = pg.gameset.tip_unlock_shipIds.description[0]

	return table.contains(var0, arg0)
end

function var0.proposeSkinOwned(arg0, arg1)
	return arg1 and arg0.propose and arg1.skin_type == ShipSkin.SKIN_TYPE_PROPOSE
end

function var0.getProposeSkin(arg0)
	return ShipSkin.GetSkinByType(arg0.groupId, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0.getDisplaySkillIds(arg0)
	return _.map(pg.ship_data_template[arg0.configId].buff_list_display, function(arg0)
		return arg0:fateSkillChange(arg0)
	end)
end

function var0.isFullSkillLevel(arg0)
	local var0 = pg.skill_data_template

	for iter0, iter1 in pairs(arg0.skills) do
		if var0[iter1.id].max_level ~= iter1.level then
			return false
		end
	end

	return true
end

function var0.setEquipmentRecord(arg0, arg1, arg2)
	local var0 = "equipment_record" .. "_" .. arg1 .. "_" .. arg0.id

	PlayerPrefs.SetString(var0, table.concat(_.flatten(arg2), ":"))
	PlayerPrefs.Save()
end

function var0.getEquipmentRecord(arg0, arg1)
	if not arg0.equipmentRecords then
		local var0 = "equipment_record" .. "_" .. arg1 .. "_" .. arg0.id
		local var1 = string.split(PlayerPrefs.GetString(var0) or "", ":")
		local var2 = {}

		for iter0 = 1, 3 do
			var2[iter0] = _.map(_.slice(var1, 5 * iter0 - 4, 5), function(arg0)
				return tonumber(arg0)
			end)
		end

		arg0.equipmentRecords = var2
	end

	return arg0.equipmentRecords
end

function var0.SetSpWeaponRecord(arg0, arg1, arg2)
	local var0 = "spweapon_record" .. "_" .. arg1 .. "_" .. arg0.id
	local var1 = _.map({
		1,
		2,
		3
	}, function(arg0)
		local var0 = arg2[arg0]

		if var0 then
			return (var0:GetUID() or 0) .. "," .. var0:GetConfigID()
		else
			return "0,0"
		end
	end)

	PlayerPrefs.SetString(var0, table.concat(var1, ":"))
	PlayerPrefs.Save()
end

function var0.GetSpWeaponRecord(arg0, arg1)
	local var0 = "spweapon_record" .. "_" .. arg1 .. "_" .. arg0.id

	return (_.map(string.split(PlayerPrefs.GetString(var0, ""), ":"), function(arg0)
		local var0 = string.split(arg0, ",")

		assert(var0)

		local var1 = tonumber(var0[1])
		local var2 = tonumber(var0[2])

		if not var2 or var2 == 0 then
			return false
		end

		local var3 = getProxy(EquipmentProxy):GetSpWeaponByUid(var1) or _.detect(getProxy(BayProxy):GetSpWeaponsInShips(), function(arg0)
			return arg0:GetUID() == var1
		end)

		var3 = var3 or SpWeapon.New({
			id = var2
		})

		return var3
	end))
end

function var0.hasEquipEquipmentSkin(arg0)
	for iter0, iter1 in ipairs(arg0.equipments) do
		if iter1 and iter1:hasSkin() then
			return true
		end
	end

	return false
end

function var0.hasCommander(arg0)
	return arg0.commanderId and arg0.commanderId ~= 0
end

function var0.getCommander(arg0)
	return arg0.commanderId
end

function var0.setCommander(arg0, arg1)
	arg0.commanderId = arg1
end

function var0.getSkillIndex(arg0, arg1)
	local var0 = arg0:getSkillList()

	for iter0, iter1 in ipairs(var0) do
		if arg1 == iter1 then
			return iter0
		end
	end
end

function var0.getTactics(arg0)
	return 1, "tactics_attack"
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

function var0.isIntensifyMax(arg0)
	local var0 = intProperties(arg0:getShipProperties())

	if arg0:isBluePrintShip() then
		return true
	end

	for iter0, iter1 in pairs(ShipModAttr.ID_TO_ATTR) do
		if arg0:getModAttrBaseMax(iter1) ~= var0[iter1] then
			return false
		end
	end

	return true
end

function var0.isRemouldable(arg0)
	return not arg0:isTestShip() and not arg0:isBluePrintShip() and pg.ship_data_trans[arg0.groupId]
end

function var0.isAllRemouldFinish(arg0)
	local var0 = pg.ship_data_trans[arg0.groupId]

	assert(var0, "this ship group without remould config:" .. arg0.groupId)

	for iter0, iter1 in ipairs(var0.transform_list) do
		for iter2, iter3 in ipairs(iter1) do
			local var1 = pg.transform_data_template[iter3[2]]

			if #var1.edit_trans > 0 then
				-- block empty
			elseif not arg0.transforms[iter3[2]] or arg0.transforms[iter3[2]].level < var1.max_level then
				return false
			end
		end
	end

	return true
end

function var0.isSpecialFilter(arg0)
	local var0 = pg.ship_data_statistics[arg0.configId]

	assert(var0, "this ship without statistics:" .. arg0.configId)

	for iter0, iter1 in ipairs(var0.tag_list) do
		if iter1 == "special" then
			return true
		end
	end

	return false
end

function var0.hasAvailiableSkin(arg0)
	local var0 = getProxy(ShipSkinProxy)
	local var1 = var0:GetAllSkinForShip(arg0)
	local var2 = var0:getRawData()
	local var3 = 0

	for iter0, iter1 in ipairs(var1) do
		if arg0:proposeSkinOwned(iter1) or var2[iter1.id] then
			var3 = var3 + 1
		end
	end

	return var3 > 0
end

function var0.hasProposeSkin(arg0)
	local var0 = getProxy(ShipSkinProxy)
	local var1 = var0:GetAllSkinForShip(arg0)

	for iter0, iter1 in ipairs(var1) do
		if iter1.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	local var2 = var0:GetShareSkinsForShip(arg0)

	for iter2, iter3 in ipairs(var2) do
		if iter3.skin_type == ShipSkin.SKIN_TYPE_PROPOSE then
			return true
		end
	end

	return false
end

function var0.HasUniqueSpWeapon(arg0)
	return tobool(pg.spweapon_data_statistics.get_id_list_by_unique[arg0:getGroupId()])
end

function var0.getAircraftReloadCD(arg0)
	local var0 = arg0:getConfigTable().base_list
	local var1 = arg0:getConfigTable().default_equip_list
	local var2 = 0
	local var3 = 0

	for iter0 = 1, 3 do
		local var4 = arg0:getEquip(iter0)
		local var5 = var4 and var4.configId or var1[iter0]
		local var6 = Equipment.getConfigData(var5).type

		if underscore.any(EquipType.AirEquipTypes, function(arg0)
			return var6 == arg0
		end) then
			var2 = var2 + Equipment.GetEquipReloadStatic(var5) * var0[iter0]
			var3 = var3 + var0[iter0]
		end
	end

	local var7 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT

	return {
		name = i18n("equip_info_31"),
		type = AttributeType.CD,
		value = var2 / var3 * var7
	}
end

function var0.IsTagShip(arg0, arg1)
	local var0 = arg0:getConfig("tag_list")

	return table.contains(var0, arg1)
end

function var0.setReMetaSpecialItemVO(arg0, arg1)
	arg0.reMetaSpecialItemVO = arg1
end

function var0.getReMetaSpecialItemVO(arg0, arg1)
	return arg0.reMetaSpecialItemVO
end

function var0.getProposeType(arg0)
	if arg0:isMetaShip() then
		return "meta"
	elseif arg0:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0.IsXIdol(arg0)
	return arg0:getNation() == Nation.IDOL_LINK
end

function var0.getSpecificType(arg0)
	return pg.ship_data_template[arg0.configId].specific_type
end

function var0.GetSpWeapon(arg0)
	return arg0.spWeapon
end

function var0.UpdateSpWeapon(arg0, arg1)
	local var0 = (arg1 and arg1:GetUID() or 0) == (arg0.spWeapon and arg0.spWeapon:GetUID() or 0)

	arg0.spWeapon = arg1

	if arg1 then
		arg1:SetShipId(arg0.id)
	end

	if var0 then
		pg.m02:sendNotification(EquipmentProxy.SPWEAPONS_UPDATED)
	end
end

function var0.CanEquipSpWeapon(arg0, arg1)
	local var0, var1 = arg0:IsSpWeaponForbidden(arg1)

	if var0 then
		return false, var1
	end

	return true
end

function var0.IsSpWeaponForbidden(arg0, arg1)
	local var0 = arg1:GetWearableShipTypes()
	local var1 = arg0:getShipType()

	if not table.contains(var0, var1) then
		return true, i18n("spweapon_tip_group_error")
	end

	local var2 = arg1:GetUniqueGroup()
	local var3 = arg0:getGroupId()

	if var2 ~= 0 and var2 ~= var3 then
		return true, i18n("spweapon_tip_group_error")
	end

	return false
end

function var0.GetMapStrikeAnim(arg0)
	local var0
	local var1 = arg0:getShipType()

	switch(TeamType.GetTeamFromShipType(var1), {
		[TeamType.Main] = function()
			if ShipType.IsTypeQuZhu(var1) then
				var0 = "SubTorpedoUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleAircraftCarrier, var1) then
				var0 = "AirStrikeUI"
			elseif ShipType.ContainInLimitBundle(ShipType.BundleBattleShip, var1) then
				var0 = "CannonUI"
			else
				var0 = "CannonUI"
			end
		end,
		[TeamType.Vanguard] = function()
			if ShipType.IsTypeQuZhu(var1) then
				var0 = "SubTorpedoUI"
			end
		end,
		[TeamType.Submarine] = function()
			if arg0:getNation() == Nation.MOT then
				var0 = "CannonUI"
			else
				var0 = "SubTorpedoUI"
			end
		end
	})

	return var0
end

function var0.IsDefaultSkin(arg0)
	return arg0.skinId == 0 or arg0.skinId == arg0:getConfig("skin_id")
end

function var0.IsMatchKey(arg0, arg1)
	if not arg1 or arg1 == "" then
		return true
	end

	arg1 = string.lower(string.gsub(arg1, "%.", "%%."))

	return string.find(string.lower(arg0:GetDefaultName()), arg1)
end

function var0.IsOwner(arg0)
	return tobool(arg0.id)
end

function var0.GetUniqueId(arg0)
	return arg0.id
end

function var0.ShowPropose(arg0)
	if not arg0.propose then
		return false
	else
		return not HXSet.isHxPropose() or arg0:IsOwner() and arg0:GetUniqueId() == getProxy(PlayerProxy):getRawData():GetProposeShipId()
	end
end

function var0.GetColorName(arg0, arg1)
	arg1 = arg1 or arg0:getName()

	if PlayerPrefs.GetInt("SHIP_NAME_COLOR", PLATFORM_CODE == PLATFORM_CH and 1 or 0) == 1 and arg0.propose then
		return setColorStr(arg1, "#FFAACEFF")
	else
		return arg1
	end
end

local var9 = {
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

function var0.GetFrameAndEffect(arg0, arg1)
	arg1 = tobool(arg1)

	local var0
	local var1

	if arg0.propose then
		if arg0:isMetaShip() then
			var1 = string.format(var9.effect[1])
			var0 = string.format(var9.frame[1])
		elseif arg0:isBluePrintShip() then
			var1 = string.format(var9.effect[2])
			var0 = string.format(var9.frame[2], arg0:rarity2bgPrint())
		else
			var1 = string.format(var9.effect[3])
			var0 = string.format(var9.frame[3])
		end

		if not arg0:ShowPropose() then
			var0 = nil
		end
	elseif arg0:isMetaShip() then
		var1 = string.format(var9.effect[4], arg0:rarity2bgPrint())
	elseif arg0:getRarity() == ShipRarity.SSR then
		var1 = string.format(var9.effect[5])
	end

	if arg1 then
		var1 = var1 and var1 .. "_1"
	end

	return var0, var1
end

function var0.GetRecordPosKey(arg0)
	return arg0.skinId
end

return var0
