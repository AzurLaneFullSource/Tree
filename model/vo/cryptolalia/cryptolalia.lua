local var0 = class("Cryptolalia", import("model.vo.BaseVO"))

var0.STATE_LOCK = 1
var0.STATE_DOWNLOADABLE = 2
var0.STATE_PLAYABLE = 3
var0.STATE_DOWNLOADING = 4
var0.COST_TYPE_GEM = 1
var0.COST_TYPE_TICKET = 2
var0.LANG_TYPE_JP = 0
var0.LANG_TYPE_CH = 1

function var0.GetAssetBundlePath(arg0)
	local var0 = var0.BuildCpkPath(arg0)

	return PathMgr.getAssetBundle(var0)
end

function var0.GetSubtitleAssetBundlePath(arg0)
	local var0 = var0.BuildSubtitlePath(arg0)

	return PathMgr.getAssetBundle(var0)
end

function var0.BuildCpkPath(arg0)
	return "originsource/cipher/" .. string.lower(arg0) .. ".cpk"
end

function var0.BuildSubtitlePath(arg0)
	return "originsource/cipher/" .. string.lower(arg0) .. ".txt"
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.lock = true
	arg0.sizes = {}
end

function var0.GetState(arg0, arg1)
	if not arg0:IsLock() then
		if arg0:IsDownloadRes(arg1) then
			return var0.STATE_PLAYABLE
		else
			return var0.STATE_DOWNLOADABLE
		end
	else
		return var0.STATE_LOCK
	end
end

function var0.IsEmpty(arg0)
	return arg0 == nil or arg0 == ""
end

function var0.GetDefaultLangType(arg0)
	if not var0.IsEmpty(arg0:GetJpCpkName()) then
		return var0.LANG_TYPE_JP
	end

	if not var0.IsEmpty(arg0:GetCnCpkName()) then
		return var0.LANG_TYPE_CH
	end
end

function var0.IsDownloadableState(arg0, arg1)
	return arg0:GetState(arg1) == var0.STATE_DOWNLOADABLE
end

function var0.IsPlayableState(arg0, arg1)
	return arg0:GetState(arg1) == var0.STATE_PLAYABLE
end

function var0.IsDownloadRes(arg0, arg1)
	local var0 = arg0:GetCpkName(arg1)
	local var1 = var0.BuildCpkPath(var0)

	return pg.CipherGroupMgr.GetInstance():isCipherExist(var1)
end

function var0.IsDownloadAllRes(arg0)
	if arg0:IsMultiVersion() then
		return arg0:IsDownloadRes(var0.LANG_TYPE_CH) and arg0:IsDownloadRes(var0.LANG_TYPE_JP)
	elseif arg0:OnlyChVersion() then
		return arg0:IsDownloadRes(var0.LANG_TYPE_CH)
	elseif arg0:OnlyJpVersion() then
		return arg0:IsDownloadRes(var0.LANG_TYPE_JP)
	end
end

function var0.IsLockState(arg0, arg1)
	return arg0:GetState(arg1) == var0.STATE_LOCK
end

function var0.Unlock(arg0)
	arg0.lock = false
end

function var0.IsLock(arg0)
	return arg0.lock
end

function var0.bindConfigTable(arg0)
	return pg.soundstory_template
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetDescription(arg0)
	return arg0:getConfig("overview")
end

function var0.GetCnCvAuthor(arg0)
	return arg0:getConfig("CV_CN")
end

function var0.GetJpCvAuthor(arg0)
	return arg0:getConfig("CV_JP")
end

function var0.GetCvAuthor(arg0, arg1)
	if arg1 == var0.LANG_TYPE_CH then
		return arg0:GetCnCvAuthor()
	elseif arg1 == var0.LANG_TYPE_JP then
		return arg0:GetJpCvAuthor()
	end
end

function var0.GetShipGroupId(arg0)
	return arg0:getConfig("ship_id")
end

function var0.IsSameGroup(arg0, arg1)
	return arg0:GetShipGroupId() == arg1
end

function var0.GetShipName(arg0)
	local var0 = arg0:GetShipGroupId()
	local var1 = ShipGroup.getDefaultShipConfig(var0)

	return (HXSet.hxLan(var1.name))
end

function var0.ShipIcon(arg0)
	local var0 = arg0:GetShipGroupId()
	local var1 = ShipGroup.getDefaultShipConfig(var0)

	return pg.ship_skin_template[var1.skin_id].prefab
end

function var0.GetCnAudition(arg0)
	return arg0:getConfig("audition_resource_CN")
end

function var0.GetJpAudition(arg0)
	return arg0:getConfig("audition_resource_JP")
end

function var0.GetAudition(arg0, arg1)
	if arg1 == var0.LANG_TYPE_CH then
		return arg0:GetCnAudition()
	elseif arg1 == var0.LANG_TYPE_JP then
		return arg0:GetJpAudition()
	end
end

function var0.GetAuditionVoice(arg0, arg1)
	local var0 = arg0:GetAudition(arg1)

	if arg1 == var0.LANG_TYPE_CH then
		return var0 .. "-CN"
	elseif arg1 == var0.LANG_TYPE_JP then
		return var0 .. "-JP"
	end
end

function var0.GetAuditionTitle(arg0)
	return arg0:getConfig("audition_text")
end

function var0.GetCnCpkName(arg0)
	return arg0:getConfig("story_resource_CN")
end

function var0.GetJpCpkName(arg0)
	return arg0:getConfig("story_resource_JP")
end

function var0.GetCpkName(arg0, arg1)
	if arg1 == var0.LANG_TYPE_CH then
		return arg0:GetCnCpkName()
	elseif arg1 == var0.LANG_TYPE_JP then
		return arg0:GetJpCpkName()
	end
end

function var0.IsMultiVersion(arg0)
	return not var0.IsEmpty(arg0:GetCnCpkName()) and not var0.IsEmpty(arg0:GetJpCpkName())
end

function var0.OnlyChVersion(arg0)
	return not var0.IsEmpty(arg0:GetCnCpkName()) and var0.IsEmpty(arg0:GetJpCpkName())
end

function var0.OnlyJpVersion(arg0)
	return not var0.IsEmpty(arg0:GetJpCpkName()) and var0.IsEmpty(arg0:GetCnCpkName())
end

function var0.ExistLang(arg0, arg1)
	local var0 = arg0:GetCpkName(arg1)

	return not var0.IsEmpty(var0)
end

function var0.GetIcon(arg0)
	return arg0:getConfig("story_pic")
end

function var0.GetCost(arg0, arg1)
	return arg0:GetCostList()[arg1]
end

function var0.GetCostList(arg0)
	local var0 = arg0:getConfig("cost" .. var0.COST_TYPE_GEM)
	local var1 = arg0:getConfig("cost" .. var0.COST_TYPE_TICKET)

	return {
		[var0.COST_TYPE_GEM] = {
			type = var0[1],
			id = var0[2],
			count = var0[3]
		},
		[var0.COST_TYPE_TICKET] = {
			type = var1[1],
			id = var1[2],
			count = var1[3]
		}
	}
end

function var0.InTime(arg0)
	local var0 = arg0:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0)
end

function var0.IsExpired(arg0)
	return not arg0:InTime()
end

function var0.GetSortIndex(arg0)
	return arg0:getConfig("order")
end

function var0.IsForever(arg0)
	local var0 = arg0:getConfig("time")

	return type(var0) == "string" and var0 == "always"
end

function var0.GetExpiredTimeStr(arg0)
	if arg0:InTime() and not arg0:IsForever() then
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = arg0:getConfig("time")[3]
		local var2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1) - var0

		return var2 <= 0 and "" or skinTimeStamp(var2)
	else
		return ""
	end
end

local function var1(arg0)
	local var0 = io.open(arg0, "rb")

	if var0 then
		local var1 = var0:seek("end")

		var0:close()

		return var1
	else
		return nil
	end
end

function var0.ExistLocalFile(arg0, arg1)
	local var0 = arg0:GetCpkName(arg1)
	local var1 = var0.GetAssetBundlePath(var0)

	return PathMgr.FileExists(var1)
end

function var0.ExistLocalSubtitleFile(arg0, arg1)
	local var0 = arg0:GetCpkName(arg1)
	local var1 = var0.GetSubtitleAssetBundlePath(var0)

	return PathMgr.FileExists(var1)
end

function var0.GetResSize(arg0, arg1)
	if not arg0:IsDownloadRes(arg1) then
		return ""
	end

	if not arg0.sizes[arg1] and arg0:ExistLocalFile(arg1) then
		local var0 = arg0:GetCpkName(arg1)
		local var1 = var0.GetAssetBundlePath(var0)
		local var2 = var1(var1)
		local var3 = 0

		if arg0:ExistLocalSubtitleFile(arg1) then
			local var4 = var0.GetSubtitleAssetBundlePath(var0)

			var3 = var1(var4)
		end

		arg0.sizes[arg1] = HashUtil.BytesToString(var2 + var3)
	end

	return arg0.sizes[arg1] or 0
end

return var0
