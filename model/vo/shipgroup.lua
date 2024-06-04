local var0 = class("ShipGroup", import(".BaseVO"))

var0.REQ_INTERVAL = 60

function var0.GetGroupConfig(arg0)
	local var0 = checkExist(pg.ship_data_group.get_id_list_by_group_type[arg0], {
		1
	})

	return var0 and pg.ship_data_group[var0] or nil
end

function var0.getDefaultShipConfig(arg0)
	local var0

	for iter0 = 4, 1, -1 do
		var0 = pg.ship_data_statistics[tonumber(arg0 .. iter0)]

		if var0 then
			break
		end
	end

	return var0
end

function var0.getDefaultShipNameByGroupID(arg0)
	return var0.getDefaultShipConfig(arg0).name
end

function var0.IsBluePrintGroup(arg0)
	return tobool(pg.ship_data_blueprint[arg0])
end

function var0.IsMetaGroup(arg0)
	return tobool(pg.ship_strengthen_meta[arg0])
end

function var0.IsMotGroup(arg0)
	return var0.getDefaultShipConfig(arg0).nationality == Nation.MOT
end

var0.STATE_LOCK = 0
var0.STATE_NOTGET = 1
var0.STATE_UNLOCK = 2
var0.ENABLE_SKIP_TO_CHAPTER = true

local var1 = pg.ship_data_group

function var0.getState(arg0, arg1, arg2)
	if var0.ENABLE_SKIP_TO_CHAPTER then
		if arg2 and not arg1 then
			return var0.STATE_NOTGET
		end

		if var1[arg0] then
			local var0 = var1[arg0]

			assert(var0.hide, "hide can not be nil in code " .. arg0)

			if not var0.hide then
				return var0.STATE_LOCK
			end

			if var0.hide == 1 then
				return var0.STATE_LOCK
			elseif var0.hide ~= 0 then
				assert(var0.hide == 0 or var0.hide == 1, "hide sign invalid in code " .. arg0)

				return var0.STATE_LOCK
			end
		end

		if arg1 then
			return var0.STATE_UNLOCK
		else
			local var1 = var1[arg0]

			if not var1 then
				return var0.STATE_LOCK
			end

			assert(var1, "code can not be nil" .. arg0)

			local var2 = var1.redirect_id
			local var3 = getProxy(ChapterProxy)
			local var4

			if var2 ~= 0 then
				var4 = var3:getChapterById(var2)
			end

			if var2 == 0 or var4 and var4:isClear() then
				return var0.STATE_NOTGET
			else
				return var0.STATE_LOCK
			end
		end
	else
		return arg1 and var0.STATE_UNLOCK or var0.STATE_LOCK
	end
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.star = arg1.star
	arg0.hearts = arg1.heart_count
	arg0.iheart = (arg1.heart_flag or 0) > 0
	arg0.married = arg1.marry_flag
	arg0.maxIntimacy = arg1.intimacy_max
	arg0.maxLV = arg1.lv_max
	arg0.evaluation = nil
	arg0.equipCodes = nil
	arg0.lastReqStamp = 0
	arg0.trans = false
	arg0.remoulded = arg1.remoulded

	local var0 = var0.getDefaultShipConfig(arg0.id)

	assert(var0, "can not find ship_data_statistics for group " .. arg0.id)

	arg0.shipConfig = setmetatable({}, {
		__index = function(arg0, arg1)
			return var0[arg1]
		end
	})

	local var1 = var0.GetGroupConfig(arg0.id)

	assert(var1, "can not find ship_data_group for group " .. arg0.id)

	arg0.groupConfig = setmetatable({}, {
		__index = function(arg0, arg1)
			return var1[arg1]
		end
	})
end

function var0.getName(arg0, arg1)
	local var0 = arg0.shipConfig.name

	if arg1 and arg0.trans then
		local var1 = arg0.groupConfig.trans_skin

		var0 = pg.ship_skin_template[var1].name
	end

	return var0
end

function var0.getNation(arg0)
	return arg0.shipConfig.nationality
end

function var0.getRarity(arg0, arg1)
	local var0 = arg0.shipConfig.rarity

	if arg1 and arg0.trans then
		var0 = var0 + 1
	end

	return var0
end

function var0.getTeamType(arg0)
	return TeamType.GetTeamFromShipType(arg0:getShipType())
end

function var0.getPainting(arg0, arg1)
	local var0 = arg0.shipConfig.skin_id

	if arg1 and arg0.trans then
		var0 = arg0.groupConfig.trans_skin
	end

	local var1 = pg.ship_skin_template[var0]

	assert(var1, "ship_skin_template not exist: " .. var0)

	return var1.painting
end

function var0.getShipType(arg0, arg1)
	local var0 = arg0.shipConfig.type

	if arg1 and arg0.trans then
		local var1 = Ship.getTransformShipId(arg0.shipConfig.id)

		if var1 then
			var0 = pg.ship_data_statistics[var1].type
		end
	end

	return var0
end

function var0.getShipConfigId(arg0, arg1)
	local var0 = arg0.shipConfig.id

	if arg1 and arg0.trans then
		local var1 = Ship.getTransformShipId(arg0.shipConfig.id)

		if var1 then
			var0 = pg.ship_data_statistics[var1].id
		end
	end

	return var0
end

function var0.getSkinList(arg0)
	return ShipSkin.GetAllSkinByGroup(arg0)
end

function var0.getDisplayableSkinList(arg0)
	local var0 = {}

	local function var1(arg0)
		return arg0.skin_type == ShipSkin.SKIN_TYPE_OLD or arg0.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not getProxy(ShipSkinProxy):hasSkin(arg0.id)
	end

	local function var2(arg0)
		return getProxy(ShipSkinProxy):InShowTime(arg0)
	end

	for iter0, iter1 in ipairs(pg.ship_skin_template.all) do
		local var3 = pg.ship_skin_template[iter1]

		if var3.ship_group == arg0.id and var3.no_showing ~= "1" and not var1(var3) and var2(var3.id) then
			table.insert(var0, var3)
		end
	end

	return var0
end

function var0.getDefaultSkin(arg0)
	return ShipSkin.GetSkinByType(arg0, ShipSkin.SKIN_TYPE_DEFAULT)
end

function var0.getProposeSkin(arg0)
	return ShipSkin.GetSkinByType(arg0, ShipSkin.SKIN_TYPE_PROPOSE)
end

function var0.getModSkin(arg0)
	local var0 = pg.ship_data_trans[arg0]

	if var0 then
		return pg.ship_skin_template[var0.skin_id]
	end

	return nil
end

function var0.GetSkin(arg0, arg1)
	if not arg1 then
		return var0.getDefaultSkin(arg0.id)
	else
		return var0.getModSkin(arg0.id)
	end
end

function var0.updateMaxIntimacy(arg0, arg1)
	arg0.maxIntimacy = math.max(arg1, arg0.maxIntimacy)
end

function var0.updateMarriedFlag(arg0)
	arg0.married = 1
end

function var0.isBluePrintGroup(arg0)
	return var0.IsBluePrintGroup(arg0.id)
end

function var0.getBluePrintChangeSkillList(arg0)
	assert(arg0:isBluePrintGroup(), "ShipGroup " .. arg0.id .. "isn't BluePrint")

	return pg.ship_data_blueprint[arg0.id].change_skill
end

function var0.GetNationTxt(arg0)
	local var0 = arg0.shipConfig.nationality

	return Nation.Nation2facionName(var0) .. "-" .. Nation.Nation2Name(var0)
end

var0.CONDITION_FORBIDDEN = -1
var0.CONDITION_CLEAR = 0
var0.CONDITION_INTIMACY = 1
var0.CONDITION_MARRIED = 2

function var0.VoiceReplayCodition(arg0, arg1)
	local var0 = true
	local var1 = ""

	if arg0:isBluePrintGroup() then
		local var2 = getProxy(TechnologyProxy):getBluePrintById(arg0.id)

		assert(var2, "blueprint can not be nil >>" .. arg0.id)

		local var3 = var2:getUnlockVoices()

		if not table.contains(var3, arg1.key) then
			local var4 = var2:getUnlockLevel(arg1.key)

			if var4 > 0 then
				var0 = false

				return var0, i18n("ship_profile_voice_locked_design", var4)
			end
		end
	end

	if arg0:isMetaGroup() then
		local var5 = getProxy(BayProxy):getMetaShipByGroupId(arg0.id):getMetaCharacter()
		local var6 = var5:getUnlockedVoiceList()

		if not table.contains(var6, arg1.key) then
			local var7 = var5:getUnlockVoiceRepairPercent(arg1.key)

			if var7 > 0 then
				var0 = false

				return var0, i18n("ship_profile_voice_locked_meta", var7)
			end
		end
	end

	if arg1.unlock_condition[1] == var0.CONDITION_INTIMACY then
		if arg0.maxIntimacy < arg1.unlock_condition[2] then
			var0 = false
			var1 = i18n("ship_profile_voice_locked_intimacy", math.floor(arg1.unlock_condition[2] / 100))
		end
	elseif arg1.unlock_condition[1] == var0.CONDITION_MARRIED and arg0.married == 0 then
		var0 = false

		if arg0:IsXIdol() then
			var1 = i18n("ship_profile_voice_locked_propose_imas")
		else
			var1 = i18n("ship_profile_voice_locked_propose")
		end
	end

	return var0, var1
end

function var0.GetMaxIntimacy(arg0)
	return arg0.maxIntimacy / 100 + (arg0.married and arg0.married * 1000 or 0)
end

function var0.isSpecialFilter(arg0)
	for iter0, iter1 in ipairs(arg0.shipConfig.tag_list) do
		if iter1 == "special" then
			return true
		end
	end

	return false
end

function var0.getGroupId(arg0)
	return arg0.id
end

function var0.isRemoulded(arg0)
	return arg0.remoulded
end

function var0.isMetaGroup(arg0)
	return var0.IsMetaGroup(arg0.id)
end

local var2 = {
	feeling2 = true,
	feeling3 = true,
	feeling5 = true,
	feeling4 = true,
	propose = true,
	feeling1 = true
}

function var0.getIntimacyName(arg0, arg1)
	if not var2[arg1] then
		return
	end

	if arg0:isMetaGroup() then
		return i18n("meta_voice_name_" .. arg1)
	elseif arg0:IsXIdol() then
		return i18n("idolmaster_voice_name_" .. arg1)
	end
end

function var0.getProposeType(arg0)
	if arg0:isMetaGroup() then
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

function var0.CanUseShareSkin(arg0)
	return arg0.groupConfig.share_group_id and #arg0.groupConfig.share_group_id > 0
end

function var0.rarity2bgPrint(arg0, arg1)
	return shipRarity2bgPrint(arg0:getRarity(arg1), arg0:isBluePrintGroup(), arg0:isMetaGroup())
end

function var0.rarity2bgPrintForGet(arg0, arg1, arg2)
	return skinId2bgPrint(arg2 or arg0:GetSkin(arg1).id) or arg0:rarity2bgPrint(arg1)
end

function var0.setEquipCodes(arg0, arg1)
	arg0.equipCodes = arg1
end

function var0.getEquipCodes(arg0)
	return arg0.equipCodes
end

return var0
