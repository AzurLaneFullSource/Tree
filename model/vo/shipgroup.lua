local var0_0 = class("ShipGroup", import(".BaseVO"))

var0_0.REQ_INTERVAL = 60

function var0_0.GetGroupConfig(arg0_1)
	local var0_1 = checkExist(pg.ship_data_group.get_id_list_by_group_type[arg0_1], {
		1
	})

	return var0_1 and pg.ship_data_group[var0_1] or nil
end

function var0_0.getDefaultShipConfig(arg0_2)
	return pg.ship_data_statistics[arg0_2 * 10 + 1]
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

function var0_0.LockCv1(arg0_7)
	local var0_7 = pg.gameset.profile_cv1_button_block.description

	return table.contains(var0_7, arg0_7)
end

var0_0.STATE_LOCK = 0
var0_0.STATE_NOTGET = 1
var0_0.STATE_UNLOCK = 2
var0_0.ENABLE_SKIP_TO_CHAPTER = true

local var1_0 = pg.ship_data_group

function var0_0.getState(arg0_8, arg1_8, arg2_8)
	if var0_0.ENABLE_SKIP_TO_CHAPTER then
		if arg2_8 and not arg1_8 then
			return var0_0.STATE_NOTGET
		end

		if var1_0[arg0_8] then
			local var0_8 = var1_0[arg0_8]

			assert(var0_8.hide, "hide can not be nil in code " .. arg0_8)

			if not var0_8.hide then
				return var0_0.STATE_LOCK
			end

			if var0_8.hide == 1 then
				return var0_0.STATE_LOCK
			elseif var0_8.hide ~= 0 then
				assert(var0_8.hide == 0 or var0_8.hide == 1, "hide sign invalid in code " .. arg0_8)

				return var0_0.STATE_LOCK
			end
		end

		if arg1_8 then
			return var0_0.STATE_UNLOCK
		else
			local var1_8 = var1_0[arg0_8]

			if not var1_8 then
				return var0_0.STATE_LOCK
			end

			assert(var1_8, "code can not be nil" .. arg0_8)

			local var2_8 = var1_8.redirect_id
			local var3_8 = getProxy(ChapterProxy)
			local var4_8

			if var2_8 ~= 0 then
				var4_8 = var3_8:getChapterById(var2_8)
			end

			if var2_8 == 0 or var4_8 and var4_8:isClear() then
				return var0_0.STATE_NOTGET
			else
				return var0_0.STATE_LOCK
			end
		end
	else
		return arg1_8 and var0_0.STATE_UNLOCK or var0_0.STATE_LOCK
	end
end

function var0_0.Ctor(arg0_9, arg1_9)
	arg0_9.id = arg1_9.id
	arg0_9.star = arg1_9.star
	arg0_9.hearts = arg1_9.heart_count
	arg0_9.iheart = (arg1_9.heart_flag or 0) > 0
	arg0_9.married = arg1_9.marry_flag
	arg0_9.maxIntimacy = arg1_9.intimacy_max
	arg0_9.maxLV = arg1_9.lv_max
	arg0_9.evaluation = nil
	arg0_9.equipCodes = nil
	arg0_9.lastReqStamp = 0
	arg0_9.trans = false
	arg0_9.remoulded = arg1_9.remoulded

	local var0_9 = var0_0.getDefaultShipConfig(arg0_9.id)

	assert(var0_9, "can not find ship_data_statistics for group " .. arg0_9.id)

	arg0_9.shipConfig = setmetatable({}, {
		__index = function(arg0_10, arg1_10)
			return var0_9[arg1_10]
		end
	})

	local var1_9 = var0_0.GetGroupConfig(arg0_9.id)

	assert(var1_9, "can not find ship_data_group for group " .. arg0_9.id)

	arg0_9.groupConfig = setmetatable({}, {
		__index = function(arg0_11, arg1_11)
			return var1_9[arg1_11]
		end
	})
end

function var0_0.getName(arg0_12, arg1_12)
	local var0_12 = arg0_12.shipConfig.name

	if arg1_12 and arg0_12.trans then
		local var1_12 = arg0_12.groupConfig.trans_skin

		var0_12 = pg.ship_skin_template[var1_12].name
	end

	return var0_12
end

function var0_0.getNation(arg0_13)
	return arg0_13.shipConfig.nationality
end

function var0_0.getRarity(arg0_14, arg1_14)
	local var0_14 = arg0_14.shipConfig.rarity

	if arg1_14 and arg0_14.trans then
		var0_14 = var0_14 + 1
	end

	return var0_14
end

function var0_0.getTeamType(arg0_15)
	return ShipType.GetTeamFromShipType(arg0_15:getShipType())
end

function var0_0.getPainting(arg0_16, arg1_16)
	local var0_16 = arg0_16.shipConfig.skin_id

	if arg1_16 and arg0_16.trans then
		var0_16 = arg0_16.groupConfig.trans_skin
	end

	local var1_16 = pg.ship_skin_template[var0_16]

	assert(var1_16, "ship_skin_template not exist: " .. var0_16)

	return var1_16.painting
end

function var0_0.getPaintingId(arg0_17, arg1_17)
	local var0_17 = arg0_17.shipConfig.skin_id

	if arg1_17 and arg0_17.trans then
		var0_17 = arg0_17.groupConfig.trans_skin
	end

	return var0_17
end

function var0_0.getShipType(arg0_18, arg1_18)
	local var0_18 = arg0_18.shipConfig.type

	if arg1_18 and arg0_18.trans then
		local var1_18 = Ship.getTransformShipId(arg0_18.shipConfig.id)

		if var1_18 then
			var0_18 = pg.ship_data_statistics[var1_18].type
		end
	end

	return var0_18
end

function var0_0.getShipConfigId(arg0_19, arg1_19)
	local var0_19 = arg0_19.shipConfig.id

	if arg1_19 and arg0_19.trans then
		local var1_19 = Ship.getTransformShipId(arg0_19.shipConfig.id)

		if var1_19 then
			var0_19 = pg.ship_data_statistics[var1_19].id
		end
	end

	return var0_19
end

function var0_0.getSkinList(arg0_20)
	return ShipSkin.GetAllSkinByGroup(arg0_20)
end

function var0_0.GetDisplayableSkinList(arg0_21)
	local var0_21 = {}

	local function var1_21(arg0_22)
		return arg0_22.skin_type == ShipSkin.SKIN_TYPE_OLD or arg0_22.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not getProxy(ShipSkinProxy):hasSkin(arg0_22.id)
	end

	local function var2_21(arg0_23)
		return getProxy(ShipSkinProxy):InShowTime(arg0_23)
	end

	for iter0_21, iter1_21 in ipairs(pg.ship_skin_template.all) do
		local var3_21 = pg.ship_skin_template[iter1_21]

		if var3_21.ship_group == arg0_21 and var3_21.no_showing ~= "1" and not var1_21(var3_21) and var2_21(var3_21.id) then
			table.insert(var0_21, var3_21)
		end
	end

	for iter2_21 = #var0_21, 1, -1 do
		local var4_21 = var0_21[iter2_21]

		if ShipSkin.GetChangeSkinGroupId(var4_21.id) and ShipSkin.GetChangeSkinIndex(var4_21.id) ~= 1 then
			table.remove(var0_21, iter2_21)
		end
	end

	return var0_21
end

function var0_0.getDefaultSkin(arg0_24)
	return ShipSkin.GetSkinByType(arg0_24, ShipSkin.SKIN_TYPE_DEFAULT)
end

function var0_0.getProposeSkin(arg0_25)
	return ShipSkin.GetSkinByType(arg0_25, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0_0.getModSkin(arg0_26)
	local var0_26 = pg.ship_data_trans[arg0_26]

	if var0_26 then
		return pg.ship_skin_template[var0_26.skin_id]
	end

	return nil
end

function var0_0.GetSkin(arg0_27, arg1_27)
	if not arg1_27 then
		return var0_0.getDefaultSkin(arg0_27.id)
	else
		return var0_0.getModSkin(arg0_27.id)
	end
end

function var0_0.updateMaxIntimacy(arg0_28, arg1_28)
	arg0_28.maxIntimacy = math.max(arg1_28, arg0_28.maxIntimacy)
end

function var0_0.updateMarriedFlag(arg0_29)
	arg0_29.married = 1
end

function var0_0.IsMarried(arg0_30)
	return arg0_30.married == 1
end

function var0_0.isBluePrintGroup(arg0_31)
	return var0_0.IsBluePrintGroup(arg0_31.id)
end

function var0_0.getBluePrintChangeSkillList(arg0_32)
	assert(arg0_32:isBluePrintGroup(), "ShipGroup " .. arg0_32.id .. "isn't BluePrint")

	return pg.ship_data_blueprint[arg0_32.id].change_skill
end

function var0_0.GetNationTxt(arg0_33)
	local var0_33 = arg0_33.shipConfig.nationality

	return Nation.Nation2facionName(var0_33) .. "-" .. Nation.Nation2Name(var0_33)
end

var0_0.CONDITION_FORBIDDEN = -1
var0_0.CONDITION_CLEAR = 0
var0_0.CONDITION_INTIMACY = 1
var0_0.CONDITION_MARRIED = 2

function var0_0.VoiceReplayCodition(arg0_34, arg1_34)
	local var0_34 = true
	local var1_34 = ""

	if arg0_34:isBluePrintGroup() then
		local var2_34 = getProxy(TechnologyProxy):getBluePrintById(arg0_34.id)

		assert(var2_34, "blueprint can not be nil >>" .. arg0_34.id)

		local var3_34 = var2_34:getUnlockVoices()

		if not table.contains(var3_34, arg1_34.key) then
			local var4_34 = var2_34:getUnlockLevel(arg1_34.key)

			if var4_34 > 0 then
				var0_34 = false

				return var0_34, i18n("ship_profile_voice_locked_design", var4_34)
			end
		end
	end

	if arg0_34:isMetaGroup() then
		local var5_34 = getProxy(BayProxy):getMetaShipByGroupId(arg0_34.id):getMetaCharacter()
		local var6_34 = var5_34:getUnlockedVoiceList()

		if not table.contains(var6_34, arg1_34.key) then
			local var7_34 = var5_34:getUnlockVoiceRepairPercent(arg1_34.key)

			if var7_34 > 0 then
				var0_34 = false

				return var0_34, i18n("ship_profile_voice_locked_meta", var7_34)
			end
		end
	end

	if arg1_34.unlock_condition[1] == var0_0.CONDITION_INTIMACY then
		if arg0_34.maxIntimacy < arg1_34.unlock_condition[2] then
			var0_34 = false
			var1_34 = i18n("ship_profile_voice_locked_intimacy", math.floor(arg1_34.unlock_condition[2] / 100))
		end
	elseif arg1_34.unlock_condition[1] == var0_0.CONDITION_MARRIED and arg0_34.married == 0 then
		var0_34 = false

		if arg0_34:IsXIdol() then
			var1_34 = i18n("ship_profile_voice_locked_propose_imas")
		else
			var1_34 = i18n("ship_profile_voice_locked_propose")
		end
	end

	return var0_34, var1_34
end

function var0_0.GetMaxIntimacy(arg0_35)
	return arg0_35.maxIntimacy / 100 + (arg0_35.married and arg0_35.married * 1000 or 0)
end

function var0_0.isSpecialFilter(arg0_36)
	for iter0_36, iter1_36 in ipairs(arg0_36.shipConfig.tag_list) do
		if iter1_36 == "special" then
			return true
		end
	end

	return false
end

function var0_0.getGroupId(arg0_37)
	return arg0_37.id
end

function var0_0.isRemoulded(arg0_38)
	return arg0_38.remoulded
end

function var0_0.isMetaGroup(arg0_39)
	return var0_0.IsMetaGroup(arg0_39.id)
end

local var2_0 = {
	feeling2 = true,
	feeling3 = true,
	feeling5 = true,
	feeling4 = true,
	propose = true,
	feeling1 = true
}

function var0_0.getIntimacyName(arg0_40, arg1_40)
	if not var2_0[arg1_40] then
		return
	end

	if arg0_40:isMetaGroup() then
		return i18n("meta_voice_name_" .. arg1_40)
	elseif arg0_40:IsXIdol() then
		return i18n("idolmaster_voice_name_" .. arg1_40)
	end
end

function var0_0.getProposeType(arg0_41)
	if arg0_41:isMetaGroup() then
		return "meta"
	elseif arg0_41:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

function var0_0.IsXIdol(arg0_42)
	return arg0_42:getNation() == Nation.IDOL_LINK
end

function var0_0.CanUseShareSkin(arg0_43)
	return arg0_43.groupConfig.share_group_id and #arg0_43.groupConfig.share_group_id > 0
end

function var0_0.rarity2bgPrint(arg0_44, arg1_44)
	return shipRarity2bgPrint(arg0_44:getRarity(arg1_44), arg0_44:isBluePrintGroup(), arg0_44:isMetaGroup())
end

function var0_0.rarity2bgPrintForGet(arg0_45, arg1_45, arg2_45)
	return skinId2bgPrint(arg2_45 or arg0_45:GetSkin(arg1_45).id) or arg0_45:rarity2bgPrint(arg1_45)
end

function var0_0.setEquipCodes(arg0_46, arg1_46)
	arg0_46.equipCodes = arg1_46
end

function var0_0.getEquipCodes(arg0_47)
	return arg0_47.equipCodes
end

return var0_0
