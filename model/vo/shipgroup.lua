local var0_0 = class("ShipGroup", import(".BaseVO"))

var0_0.REQ_INTERVAL = 60

function var0_0.GetGroupConfig(arg0_1)
	local var0_1 = checkExist(pg.ship_data_group.get_id_list_by_group_type[arg0_1], {
		1
	})

	return var0_1 and pg.ship_data_group[var0_1] or nil
end

function var0_0.getDefaultShipConfig(arg0_2)
	local var0_2

	for iter0_2 = 4, 1, -1 do
		var0_2 = pg.ship_data_statistics[tonumber(arg0_2 .. iter0_2)]

		if var0_2 then
			break
		end
	end

	return var0_2
end

function var0_0.getDefaultShipNameByGroupID(arg0_3)
	return var0_0.getDefaultShipConfig(arg0_3).name
end

function var0_0.IsBluePrintGroup(arg0_4)
	return tobool(pg.ship_data_blueprint[arg0_4])
end

function var0_0.IsMetaGroup(arg0_5)
	return tobool(pg.ship_strengthen_meta[arg0_5])
end

function var0_0.IsMotGroup(arg0_6)
	return var0_0.getDefaultShipConfig(arg0_6).nationality == Nation.MOT
end

var0_0.STATE_LOCK = 0
var0_0.STATE_NOTGET = 1
var0_0.STATE_UNLOCK = 2
var0_0.ENABLE_SKIP_TO_CHAPTER = true

local var1_0 = pg.ship_data_group

function var0_0.getState(arg0_7, arg1_7, arg2_7)
	if var0_0.ENABLE_SKIP_TO_CHAPTER then
		if arg2_7 and not arg1_7 then
			return var0_0.STATE_NOTGET
		end

		if var1_0[arg0_7] then
			local var0_7 = var1_0[arg0_7]

			assert(var0_7.hide, "hide can not be nil in code " .. arg0_7)

			if not var0_7.hide then
				return var0_0.STATE_LOCK
			end

			if var0_7.hide == 1 then
				return var0_0.STATE_LOCK
			elseif var0_7.hide ~= 0 then
				assert(var0_7.hide == 0 or var0_7.hide == 1, "hide sign invalid in code " .. arg0_7)

				return var0_0.STATE_LOCK
			end
		end

		if arg1_7 then
			return var0_0.STATE_UNLOCK
		else
			local var1_7 = var1_0[arg0_7]

			if not var1_7 then
				return var0_0.STATE_LOCK
			end

			assert(var1_7, "code can not be nil" .. arg0_7)

			local var2_7 = var1_7.redirect_id
			local var3_7 = getProxy(ChapterProxy)
			local var4_7

			if var2_7 ~= 0 then
				var4_7 = var3_7:getChapterById(var2_7)
			end

			if var2_7 == 0 or var4_7 and var4_7:isClear() then
				return var0_0.STATE_NOTGET
			else
				return var0_0.STATE_LOCK
			end
		end
	else
		return arg1_7 and var0_0.STATE_UNLOCK or var0_0.STATE_LOCK
	end
end

function var0_0.Ctor(arg0_8, arg1_8)
	arg0_8.id = arg1_8.id
	arg0_8.star = arg1_8.star
	arg0_8.hearts = arg1_8.heart_count
	arg0_8.iheart = (arg1_8.heart_flag or 0) > 0
	arg0_8.married = arg1_8.marry_flag
	arg0_8.maxIntimacy = arg1_8.intimacy_max
	arg0_8.maxLV = arg1_8.lv_max
	arg0_8.evaluation = nil
	arg0_8.equipCodes = nil
	arg0_8.lastReqStamp = 0
	arg0_8.trans = false
	arg0_8.remoulded = arg1_8.remoulded

	local var0_8 = var0_0.getDefaultShipConfig(arg0_8.id)

	assert(var0_8, "can not find ship_data_statistics for group " .. arg0_8.id)

	arg0_8.shipConfig = setmetatable({}, {
		__index = function(arg0_9, arg1_9)
			return var0_8[arg1_9]
		end
	})

	local var1_8 = var0_0.GetGroupConfig(arg0_8.id)

	assert(var1_8, "can not find ship_data_group for group " .. arg0_8.id)

	arg0_8.groupConfig = setmetatable({}, {
		__index = function(arg0_10, arg1_10)
			return var1_8[arg1_10]
		end
	})
end

function var0_0.getName(arg0_11, arg1_11)
	local var0_11 = arg0_11.shipConfig.name

	if arg1_11 and arg0_11.trans then
		local var1_11 = arg0_11.groupConfig.trans_skin

		var0_11 = pg.ship_skin_template[var1_11].name
	end

	return var0_11
end

function var0_0.getNation(arg0_12)
	return arg0_12.shipConfig.nationality
end

function var0_0.getRarity(arg0_13, arg1_13)
	local var0_13 = arg0_13.shipConfig.rarity

	if arg1_13 and arg0_13.trans then
		var0_13 = var0_13 + 1
	end

	return var0_13
end

function var0_0.getTeamType(arg0_14)
	return TeamType.GetTeamFromShipType(arg0_14:getShipType())
end

function var0_0.getPainting(arg0_15, arg1_15)
	local var0_15 = arg0_15.shipConfig.skin_id

	if arg1_15 and arg0_15.trans then
		var0_15 = arg0_15.groupConfig.trans_skin
	end

	local var1_15 = pg.ship_skin_template[var0_15]

	assert(var1_15, "ship_skin_template not exist: " .. var0_15)

	return var1_15.painting
end

function var0_0.getPaintingId(arg0_16, arg1_16)
	local var0_16 = arg0_16.shipConfig.skin_id

	if arg1_16 and arg0_16.trans then
		var0_16 = arg0_16.groupConfig.trans_skin
	end

	return var0_16
end

function var0_0.getShipType(arg0_17, arg1_17)
	local var0_17 = arg0_17.shipConfig.type

	if arg1_17 and arg0_17.trans then
		local var1_17 = Ship.getTransformShipId(arg0_17.shipConfig.id)

		if var1_17 then
			var0_17 = pg.ship_data_statistics[var1_17].type
		end
	end

	return var0_17
end

function var0_0.getShipConfigId(arg0_18, arg1_18)
	local var0_18 = arg0_18.shipConfig.id

	if arg1_18 and arg0_18.trans then
		local var1_18 = Ship.getTransformShipId(arg0_18.shipConfig.id)

		if var1_18 then
			var0_18 = pg.ship_data_statistics[var1_18].id
		end
	end

	return var0_18
end

function var0_0.getSkinList(arg0_19)
	return ShipSkin.GetAllSkinByGroup(arg0_19)
end

function var0_0.getDisplayableSkinList(arg0_20)
	local var0_20 = {}

	local function var1_20(arg0_21)
		return arg0_21.skin_type == ShipSkin.SKIN_TYPE_OLD or arg0_21.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not getProxy(ShipSkinProxy):hasSkin(arg0_21.id)
	end

	local function var2_20(arg0_22)
		return getProxy(ShipSkinProxy):InShowTime(arg0_22)
	end

	for iter0_20, iter1_20 in ipairs(pg.ship_skin_template.all) do
		local var3_20 = pg.ship_skin_template[iter1_20]

		if var3_20.ship_group == arg0_20.id and var3_20.no_showing ~= "1" and not var1_20(var3_20) and var2_20(var3_20.id) then
			table.insert(var0_20, var3_20)
		end
	end

	return var0_20
end

function var0_0.getDefaultSkin(arg0_23)
	return ShipSkin.GetSkinByType(arg0_23, ShipSkin.SKIN_TYPE_DEFAULT)
end

function var0_0.getProposeSkin(arg0_24)
	return ShipSkin.GetSkinByType(arg0_24, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getModSkin(arg0_25)
	local var0_25 = pg.ship_data_trans[arg0_25]

	if var0_25 then
		return pg.ship_skin_template[var0_25.skin_id]
	end

	return nil
end

function var0_0.GetSkin(arg0_26, arg1_26)
	if not arg1_26 then
		return var0_0.getDefaultSkin(arg0_26.id)
	else
		return var0_0.getModSkin(arg0_26.id)
	end
end

function var0_0.updateMaxIntimacy(arg0_27, arg1_27)
	arg0_27.maxIntimacy = math.max(arg1_27, arg0_27.maxIntimacy)
end

function var0_0.updateMarriedFlag(arg0_28)
	arg0_28.married = 1
end

function var0_0.isBluePrintGroup(arg0_29)
	return var0_0.IsBluePrintGroup(arg0_29.id)
end

function var0_0.getBluePrintChangeSkillList(arg0_30)
	assert(arg0_30:isBluePrintGroup(), "ShipGroup " .. arg0_30.id .. "isn't BluePrint")

	return pg.ship_data_blueprint[arg0_30.id].change_skill
end

function var0_0.GetNationTxt(arg0_31)
	local var0_31 = arg0_31.shipConfig.nationality

	return Nation.Nation2facionName(var0_31) .. "-" .. Nation.Nation2Name(var0_31)
end

var0_0.CONDITION_FORBIDDEN = -1
var0_0.CONDITION_CLEAR = 0
var0_0.CONDITION_INTIMACY = 1
var0_0.CONDITION_MARRIED = 2

function var0_0.VoiceReplayCodition(arg0_32, arg1_32)
	local var0_32 = true
	local var1_32 = ""

	if arg0_32:isBluePrintGroup() then
		local var2_32 = getProxy(TechnologyProxy):getBluePrintById(arg0_32.id)

		assert(var2_32, "blueprint can not be nil >>" .. arg0_32.id)

		local var3_32 = var2_32:getUnlockVoices()

		if not table.contains(var3_32, arg1_32.key) then
			local var4_32 = var2_32:getUnlockLevel(arg1_32.key)

			if var4_32 > 0 then
				var0_32 = false

				return var0_32, i18n("ship_profile_voice_locked_design", var4_32)
			end
		end
	end

	if arg0_32:isMetaGroup() then
		local var5_32 = getProxy(BayProxy):getMetaShipByGroupId(arg0_32.id):getMetaCharacter()
		local var6_32 = var5_32:getUnlockedVoiceList()

		if not table.contains(var6_32, arg1_32.key) then
			local var7_32 = var5_32:getUnlockVoiceRepairPercent(arg1_32.key)

			if var7_32 > 0 then
				var0_32 = false

				return var0_32, i18n("ship_profile_voice_locked_meta", var7_32)
			end
		end
	end

	if arg1_32.unlock_condition[1] == var0_0.CONDITION_INTIMACY then
		if arg0_32.maxIntimacy < arg1_32.unlock_condition[2] then
			var0_32 = false
			var1_32 = i18n("ship_profile_voice_locked_intimacy", math.floor(arg1_32.unlock_condition[2] / 100))
		end
	elseif arg1_32.unlock_condition[1] == var0_0.CONDITION_MARRIED and arg0_32.married == 0 then
		var0_32 = false

		if arg0_32:IsXIdol() then
			var1_32 = i18n("ship_profile_voice_locked_propose_imas")
		else
			var1_32 = i18n("ship_profile_voice_locked_propose")
		end
	end

	return var0_32, var1_32
end

function var0_0.GetMaxIntimacy(arg0_33)
	return arg0_33.maxIntimacy / 100 + (arg0_33.married and arg0_33.married * 1000 or 0)
end

function var0_0.isSpecialFilter(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.shipConfig.tag_list) do
		if iter1_34 == "special" then
			return true
		end
	end

	return false
end

function var0_0.getGroupId(arg0_35)
	return arg0_35.id
end

function var0_0.isRemoulded(arg0_36)
	return arg0_36.remoulded
end

function var0_0.isMetaGroup(arg0_37)
	return var0_0.IsMetaGroup(arg0_37.id)
end

local var2_0 = {
	feeling2 = true,
	feeling3 = true,
	feeling5 = true,
	feeling4 = true,
	propose = true,
	feeling1 = true
}

function var0_0.getIntimacyName(arg0_38, arg1_38)
	if not var2_0[arg1_38] then
		return
	end

	if arg0_38:isMetaGroup() then
		return i18n("meta_voice_name_" .. arg1_38)
	elseif arg0_38:IsXIdol() then
		return i18n("idolmaster_voice_name_" .. arg1_38)
	end
end

function var0_0.getProposeType(arg0_39)
	if arg0_39:isMetaGroup() then
		return "meta"
	elseif arg0_39:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_40)
	return arg0_40:getNation() == Nation.IDOL_LINK
end

function var0_0.CanUseShareSkin(arg0_41)
	return arg0_41.groupConfig.share_group_id and #arg0_41.groupConfig.share_group_id > 0
end

function var0_0.rarity2bgPrint(arg0_42, arg1_42)
	return shipRarity2bgPrint(arg0_42:getRarity(arg1_42), arg0_42:isBluePrintGroup(), arg0_42:isMetaGroup())
end

function var0_0.rarity2bgPrintForGet(arg0_43, arg1_43, arg2_43)
	return skinId2bgPrint(arg2_43 or arg0_43:GetSkin(arg1_43).id) or arg0_43:rarity2bgPrint(arg1_43)
end

function var0_0.setEquipCodes(arg0_44, arg1_44)
	arg0_44.equipCodes = arg1_44
end

function var0_0.getEquipCodes(arg0_45)
	return arg0_45.equipCodes
end

return var0_0
