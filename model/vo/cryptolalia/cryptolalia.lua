local var0_0 = class("Cryptolalia", import("model.vo.BaseVO"))

var0_0.STATE_LOCK = 1
var0_0.STATE_DOWNLOADABLE = 2
var0_0.STATE_PLAYABLE = 3
var0_0.STATE_DOWNLOADING = 4
var0_0.COST_TYPE_GEM = 1
var0_0.COST_TYPE_TICKET = 2
var0_0.LANG_TYPE_JP = 0
var0_0.LANG_TYPE_CH = 1

function var0_0.GetAssetBundlePath(arg0_1)
	local var0_1 = var0_0.BuildCpkPath(arg0_1)

	return PathMgr.getAssetBundle(var0_1)
end

function var0_0.GetSubtitleAssetBundlePath(arg0_2)
	local var0_2 = var0_0.BuildSubtitlePath(arg0_2)

	return PathMgr.getAssetBundle(var0_2)
end

function var0_0.BuildCpkPath(arg0_3)
	return "originsource/cipher/" .. string.lower(arg0_3) .. ".cpk"
end

function var0_0.BuildSubtitlePath(arg0_4)
	return "originsource/cipher/" .. string.lower(arg0_4) .. ".txt"
end

function var0_0.Ctor(arg0_5, arg1_5)
	arg0_5.id = arg1_5.id
	arg0_5.configId = arg1_5.id
	arg0_5.lock = true
	arg0_5.sizes = {}
end

function var0_0.GetState(arg0_6, arg1_6)
	if not arg0_6:IsLock() then
		if arg0_6:IsDownloadRes(arg1_6) then
			return var0_0.STATE_PLAYABLE
		else
			return var0_0.STATE_DOWNLOADABLE
		end
	else
		return var0_0.STATE_LOCK
	end
end

function var0_0.IsEmpty(arg0_7)
	return arg0_7 == nil or arg0_7 == ""
end

function var0_0.GetDefaultLangType(arg0_8)
	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CHT then
		if not var0_0.IsEmpty(arg0_8:GetCnCpkName()) then
			return var0_0.LANG_TYPE_CH
		end

		if not var0_0.IsEmpty(arg0_8:GetJpCpkName()) then
			return var0_0.LANG_TYPE_JP
		end
	else
		if not var0_0.IsEmpty(arg0_8:GetJpCpkName()) then
			return var0_0.LANG_TYPE_JP
		end

		if not var0_0.IsEmpty(arg0_8:GetCnCpkName()) then
			return var0_0.LANG_TYPE_CH
		end
	end
end

function var0_0.IsDownloadableState(arg0_9, arg1_9)
	return arg0_9:GetState(arg1_9) == var0_0.STATE_DOWNLOADABLE
end

function var0_0.IsPlayableState(arg0_10, arg1_10)
	return arg0_10:GetState(arg1_10) == var0_0.STATE_PLAYABLE
end

function var0_0.IsDownloadRes(arg0_11, arg1_11)
	local var0_11 = arg0_11:GetCpkName(arg1_11)
	local var1_11 = var0_0.BuildCpkPath(var0_11)

	return pg.CipherGroupMgr.GetInstance():isCipherExist(var1_11)
end

function var0_0.IsDownloadAllRes(arg0_12)
	if arg0_12:IsMultiVersion() then
		return arg0_12:IsDownloadRes(var0_0.LANG_TYPE_CH) and arg0_12:IsDownloadRes(var0_0.LANG_TYPE_JP)
	elseif arg0_12:OnlyChVersion() then
		return arg0_12:IsDownloadRes(var0_0.LANG_TYPE_CH)
	elseif arg0_12:OnlyJpVersion() then
		return arg0_12:IsDownloadRes(var0_0.LANG_TYPE_JP)
	end
end

function var0_0.IsLockState(arg0_13, arg1_13)
	return arg0_13:GetState(arg1_13) == var0_0.STATE_LOCK
end

function var0_0.Unlock(arg0_14)
	arg0_14.lock = false
end

function var0_0.IsLock(arg0_15)
	return arg0_15.lock
end

function var0_0.bindConfigTable(arg0_16)
	return pg.soundstory_template
end

function var0_0.GetName(arg0_17)
	return arg0_17:getConfig("name")
end

function var0_0.GetDescription(arg0_18)
	return arg0_18:getConfig("overview")
end

function var0_0.GetCnCvAuthor(arg0_19)
	return arg0_19:getConfig("CV_CN")
end

function var0_0.GetJpCvAuthor(arg0_20)
	return arg0_20:getConfig("CV_JP")
end

function var0_0.GetCvAuthor(arg0_21, arg1_21)
	if arg1_21 == var0_0.LANG_TYPE_CH then
		return arg0_21:GetCnCvAuthor()
	elseif arg1_21 == var0_0.LANG_TYPE_JP then
		return arg0_21:GetJpCvAuthor()
	end
end

function var0_0.GetShipGroupId(arg0_22)
	return arg0_22:getConfig("ship_id")
end

function var0_0.IsSameGroup(arg0_23, arg1_23)
	return arg0_23:GetShipGroupId() == arg1_23
end

function var0_0.GetShipName(arg0_24)
	local var0_24 = arg0_24:GetShipGroupId()
	local var1_24 = ShipGroup.getDefaultShipConfig(var0_24)

	return (HXSet.hxLan(var1_24.name))
end

function var0_0.ShipIcon(arg0_25)
	local var0_25 = arg0_25:GetShipGroupId()
	local var1_25 = ShipGroup.getDefaultShipConfig(var0_25)

	return pg.ship_skin_template[var1_25.skin_id].prefab
end

function var0_0.GetCnAudition(arg0_26)
	return arg0_26:getConfig("audition_resource_CN")
end

function var0_0.GetJpAudition(arg0_27)
	return arg0_27:getConfig("audition_resource_JP")
end

function var0_0.GetAudition(arg0_28, arg1_28)
	if arg1_28 == var0_0.LANG_TYPE_CH then
		return arg0_28:GetCnAudition()
	elseif arg1_28 == var0_0.LANG_TYPE_JP then
		return arg0_28:GetJpAudition()
	end
end

function var0_0.GetAuditionVoice(arg0_29, arg1_29)
	local var0_29 = arg0_29:GetAudition(arg1_29)

	if arg1_29 == var0_0.LANG_TYPE_CH then
		return var0_29 .. "-CN"
	elseif arg1_29 == var0_0.LANG_TYPE_JP then
		return var0_29 .. "-JP"
	end
end

function var0_0.GetAuditionTitle(arg0_30)
	return arg0_30:getConfig("audition_text")
end

function var0_0.GetCnCpkName(arg0_31)
	return arg0_31:getConfig("story_resource_CN")
end

function var0_0.GetJpCpkName(arg0_32)
	return arg0_32:getConfig("story_resource_JP")
end

function var0_0.GetCpkName(arg0_33, arg1_33)
	if arg1_33 == var0_0.LANG_TYPE_CH then
		return arg0_33:GetCnCpkName()
	elseif arg1_33 == var0_0.LANG_TYPE_JP then
		return arg0_33:GetJpCpkName()
	end
end

function var0_0.IsMultiVersion(arg0_34)
	return not var0_0.IsEmpty(arg0_34:GetCnCpkName()) and not var0_0.IsEmpty(arg0_34:GetJpCpkName())
end

function var0_0.OnlyChVersion(arg0_35)
	return not var0_0.IsEmpty(arg0_35:GetCnCpkName()) and var0_0.IsEmpty(arg0_35:GetJpCpkName())
end

function var0_0.OnlyJpVersion(arg0_36)
	return not var0_0.IsEmpty(arg0_36:GetJpCpkName()) and var0_0.IsEmpty(arg0_36:GetCnCpkName())
end

function var0_0.ExistLang(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetCpkName(arg1_37)

	return not var0_0.IsEmpty(var0_37)
end

function var0_0.GetIcon(arg0_38)
	return arg0_38:getConfig("story_pic")
end

function var0_0.GetCost(arg0_39, arg1_39)
	return arg0_39:GetCostList()[arg1_39]
end

function var0_0.GetCostList(arg0_40)
	local var0_40 = arg0_40:getConfig("cost" .. var0_0.COST_TYPE_GEM)
	local var1_40 = arg0_40:getConfig("cost" .. var0_0.COST_TYPE_TICKET)

	return {
		[var0_0.COST_TYPE_GEM] = {
			type = var0_40[1],
			id = var0_40[2],
			count = var0_40[3]
		},
		[var0_0.COST_TYPE_TICKET] = {
			type = var1_40[1],
			id = var1_40[2],
			count = var1_40[3]
		}
	}
end

function var0_0.InTime(arg0_41)
	local var0_41 = arg0_41:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0_41)
end

function var0_0.IsExpired(arg0_42)
	return not arg0_42:InTime()
end

function var0_0.GetSortIndex(arg0_43)
	return arg0_43:getConfig("order")
end

function var0_0.IsForever(arg0_44)
	local var0_44 = arg0_44:getConfig("time")

	return type(var0_44) == "string" and var0_44 == "always"
end

function var0_0.GetExpiredTimeStr(arg0_45)
	if arg0_45:InTime() and not arg0_45:IsForever() then
		local var0_45 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_45 = arg0_45:getConfig("time")[3]
		local var2_45 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_45) - var0_45

		return var2_45 <= 0 and "" or skinTimeStamp(var2_45)
	else
		return ""
	end
end

local function var1_0(arg0_46)
	local var0_46 = io.open(arg0_46, "rb")

	if var0_46 then
		local var1_46 = var0_46:seek("end")

		var0_46:close()

		return var1_46
	else
		return nil
	end
end

function var0_0.ExistLocalFile(arg0_47, arg1_47)
	local var0_47 = arg0_47:GetCpkName(arg1_47)
	local var1_47 = var0_0.GetAssetBundlePath(var0_47)

	return PathMgr.FileExists(var1_47)
end

function var0_0.ExistLocalSubtitleFile(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetCpkName(arg1_48)
	local var1_48 = var0_0.GetSubtitleAssetBundlePath(var0_48)

	return PathMgr.FileExists(var1_48)
end

function var0_0.GetResSize(arg0_49, arg1_49)
	if not arg0_49:IsDownloadRes(arg1_49) then
		return ""
	end

	if not arg0_49.sizes[arg1_49] and arg0_49:ExistLocalFile(arg1_49) then
		local var0_49 = arg0_49:GetCpkName(arg1_49)
		local var1_49 = var0_0.GetAssetBundlePath(var0_49)
		local var2_49 = var1_0(var1_49)
		local var3_49 = 0

		if arg0_49:ExistLocalSubtitleFile(arg1_49) then
			local var4_49 = var0_0.GetSubtitleAssetBundlePath(var0_49)

			var3_49 = var1_0(var4_49)
		end

		arg0_49.sizes[arg1_49] = HashUtil.BytesToString(var2_49 + var3_49)
	end

	return arg0_49.sizes[arg1_49] or 0
end

function var0_0.GetCaptionsColor(arg0_50)
	return arg0_50:getConfig("captions_color")
end

return var0_0
