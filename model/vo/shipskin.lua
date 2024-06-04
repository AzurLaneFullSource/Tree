local var0 = class("ShipSkin", import(".BaseVO"))

var0.SKIN_TYPE_DEFAULT = -1
var0.SKIN_TYPE_COMMON_FASHION = 0
var0.SKIN_TYPE_PROPOSE = 1
var0.SKIN_TYPE_REMAKE = 2
var0.SKIN_TYPE_OLD = 3
var0.SKIN_TYPE_NOT_HAVE_HIDE = 4
var0.SKIN_TYPE_SHOW_IN_TIME = 5
var0.WITH_LIVE2D = 1
var0.WITH_BG = 2
var0.WITH_EFFECT = 3
var0.WITH_DYNAMIC_BG = 4
var0.WITH_BGM = 5
var0.WITH_SPINE = 6
var0.WITH_SPINE_PLUS = 7

function var0.Tag2Name(arg0)
	if not var0.Tag2NameTab then
		var0.Tag2NameTab = {
			[var0.WITH_BG] = "bg",
			[var0.WITH_BGM] = "bgm",
			[var0.WITH_DYNAMIC_BG] = "dtbg",
			[var0.WITH_EFFECT] = "effect",
			[var0.WITH_LIVE2D] = "live2d",
			[var0.WITH_SPINE] = "spine",
			[var0.WITH_SPINE_PLUS] = "spine_plus"
		}
	end

	return var0.Tag2NameTab[arg0]
end

function var0.GetShopTypeIdBySkinId(arg0, arg1)
	local var0 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if arg1[arg0] then
		return arg1[arg0]
	end

	for iter0, iter1 in pairs(var0) do
		for iter2, iter3 in ipairs(iter1) do
			arg1[iter3] = iter0

			if iter3 == arg0 then
				return iter0
			end
		end
	end
end

local var1 = pg.ship_skin_template.get_id_list_by_ship_group

function var0.GetSkinByType(arg0, arg1)
	local var0 = var1[arg0] or {}

	for iter0, iter1 in ipairs(var0) do
		local var1 = pg.ship_skin_template[iter1]

		if var1.skin_type == arg1 then
			return var1
		end
	end
end

function var0.GetAllSkinByGroup(arg0)
	local var0 = {}
	local var1 = var1[arg0] or {}

	for iter0, iter1 in ipairs(var1) do
		local var2 = pg.ship_skin_template[iter1]

		if var2.no_showing ~= "1" then
			table.insert(var0, var2)
		end
	end

	return var0
end

function var0.GetShareSkinsByGroupId(arg0)
	local var0 = function(arg0)
		local var0 = arg0:getConfig("skin_type")

		return not (var0 == var0.SKIN_TYPE_DEFAULT or var0 == var0.SKIN_TYPE_REMAKE or var0 == var0.SKIN_TYPE_OLD)
	end
	local var1 = pg.ship_data_group.get_id_list_by_group_type[arg0][1]
	local var2 = pg.ship_data_group[var1]

	if not var2.share_group_id or #var2.share_group_id <= 0 then
		return {}
	end

	local var3 = {}

	for iter0, iter1 in ipairs(var2.share_group_id) do
		local var4 = pg.ship_skin_template.get_id_list_by_ship_group[iter1]

		for iter2, iter3 in ipairs(var4) do
			local var5 = ShipSkin.New({
				id = iter3
			})

			if var0(var5) then
				table.insert(var3, var5)
			end
		end
	end

	return var3
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.endTime = arg1.end_time or arg1.time or 0
	arg0.isNew = true

	local var0 = arg0:getConfig("ship_group")
	local var1 = ShipGroup.getDefaultShipConfig(var0)

	arg0.shipName = var1 and var1.name or ""
	arg0.skinName = arg0:getConfig("name")
end

function var0.HasNewFlag(arg0)
	return arg0.isNew
end

function var0.SetIsNew(arg0, arg1)
	arg0.isNew = arg1
end

function var0.bindConfigTable(arg0)
	return pg.ship_skin_template
end

function var0.isExpireType(arg0)
	return arg0.endTime > 0
end

function var0.getExpireTime(arg0)
	return arg0.endTime
end

function var0.isExpired(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.endTime
end

function var0.getRemainTime(arg0)
	return arg0:getExpireTime() - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.getIcon(arg0)
	return arg0:getConfig("painting")
end

function var0.InShowTime(arg0)
	return getProxy(ShipSkinProxy):InShowTime(arg0.id)
end

function var0.IsDefault(arg0)
	return arg0:getConfig("skin_type") == var0.SKIN_TYPE_DEFAULT
end

function var0.IsType(arg0, arg1)
	return arg0:getConfig("shop_type_id") == arg1
end

function var0.IsMatchKey(arg0, arg1)
	if not arg1 or arg1 == "" then
		return true
	end

	arg1 = string.lower(string.gsub(arg1, "%.", "%%."))
	arg1 = string.lower(string.gsub(arg1, "%-", "%%-"))

	return string.find(string.lower(arg0.shipName), arg1) or string.find(string.lower(arg0.skinName), arg1)
end

function var0.ToShip(arg0)
	local var0 = arg0:getConfig("ship_group")
	local var1 = ShipGroup.getDefaultShipConfig(var0)

	if var1 then
		return Ship.New({
			id = 1,
			intimacy = 10000,
			template_id = var1.id,
			skin_id = arg0.id
		})
	else
		return nil
	end
end

function var0.GetDefaultShipConfig(arg0)
	local var0 = arg0:getConfig("ship_group")

	return (ShipGroup.getDefaultShipConfig(var0))
end

function var0.IsLive2d(arg0)
	if not arg0.isLive2dTag then
		arg0.isLive2dTag = table.contains(arg0:getConfig("tag"), var0.WITH_LIVE2D)
	end

	return arg0.isLive2dTag
end

function var0.IsDbg(arg0)
	if not arg0.isDGBTag then
		arg0.isDGBTag = table.contains(arg0:getConfig("tag"), var0.WITH_DYNAMIC_BG)
	end

	return arg0.isDGBTag
end

function var0.IsBG(arg0)
	if not arg0.isBGTag then
		arg0.isBGTag = table.contains(arg0:getConfig("tag"), var0.WITH_BG)
	end

	return arg0.isBGTag
end

function var0.IsEffect(arg0)
	if not arg0.isEffectTag then
		arg0.isEffectTag = table.contains(arg0:getConfig("tag"), var0.WITH_EFFECT)
	end

	return arg0.isEffectTag
end

function var0.isBgm(arg0)
	if not arg0.isBgmTag then
		arg0.isBgmTag = table.contains(arg0:getConfig("tag"), var0.WITH_BGM)
	end

	return arg0.isBgmTag
end

function var0.IsSpine(arg0)
	if not arg0.isSpine then
		arg0.isSpine = table.contains(arg0:getConfig("tag"), var0.WITH_SPINE)
	end

	return arg0.isSpine
end

function var0.CantUse(arg0)
	local var0 = arg0:IsTransSkin()
	local var1 = arg0:IsProposeSkin()
	local var2 = arg0:getConfig("ship_group")
	local var3 = getProxy(BayProxy):_ExistGroupShip(var2, var0, var1)
	local var4 = getProxy(CollectionProxy).shipGroups[var2] == nil

	return not var3 or var4
end

function var0.OwnShip(arg0)
	local var0 = arg0:IsTransSkin()
	local var1 = arg0:IsProposeSkin()
	local var2 = arg0:getConfig("ship_group")

	return (getProxy(BayProxy):_ExistGroupShip(var2, var0, var1))
end

function var0.WithoutUse(arg0)
	local var0 = arg0:getConfig("ship_group")
	local var1 = getProxy(BayProxy):findShipsByGroup(var0)
	local var2 = _.all(var1, function(arg0)
		return arg0.skinId ~= arg0.id
	end)

	return #var1 > 0 and var2
end

function var0.ExistShip(arg0)
	local var0 = arg0:getConfig("ship_group")

	return pg.ship_data_statistics[tonumber(var0 .. 1)] ~= nil
end

function var0.IsTransSkin(arg0)
	return arg0:getConfig("skin_type") == var0.SKIN_TYPE_REMAKE
end

function var0.IsProposeSkin(arg0)
	return arg0:getConfig("skin_type") == var0.SKIN_TYPE_PROPOSE
end

function var0.CanShare(arg0)
	local var0 = getProxy(ShipSkinProxy):hasSkin(arg0.configId)

	local function var1()
		if var0 then
			return true
		end

		return arg0:InShowTime()
	end

	local function var2()
		local var0 = arg0:getConfig("ship_group")
		local var1 = getProxy(BayProxy):getRawData()

		for iter0, iter1 in pairs(var1) do
			if iter1.groupId == var0 and iter1.propose then
				return true
			end
		end

		return false
	end

	local var3 = arg0:getConfig("skin_type")

	return not (var3 == var0.SKIN_TYPE_DEFAULT or var3 == var0.SKIN_TYPE_REMAKE or var3 == var0.SKIN_TYPE_OLD or var3 == var0.SKIN_TYPE_NOT_HAVE_HIDE and not var0 or var3 == var0.SKIN_TYPE_SHOW_IN_TIME and not var1())
end

function var0.IsShareSkin(arg0, arg1)
	local var0 = pg.ship_skin_template[arg1]
	local var1 = pg.ship_data_group
	local var2 = var1[var1.get_id_list_by_group_type[arg0.groupId][1]].share_group_id

	return table.contains(var2, var0.ship_group)
end

function var0.CanUseShareSkinForShip(arg0, arg1)
	local var0 = var0.IsShareSkin(arg0, arg1)
	local var1 = ShipSkin.New({
		id = arg1
	})
	local var2 = false
	local var3 = var1:CanShare()
	local var4 = var1:IsProposeSkin()

	if var3 and var4 and arg0.propose then
		var2 = true
	elseif var3 and not var4 then
		var2 = math.floor(arg0:getIntimacy() / 100) >= arg0:GetNoProposeIntimacyMax()
	end

	return var0 and var2
end

function var0.ExistReward(arg0)
	local var0 = pg.ship_skin_reward[arg0.configId]

	return var0 ~= nil and #var0.reward > 0
end

function var0.GetRewardList(arg0)
	if not arg0:ExistReward() then
		return {}
	end

	local var0 = pg.ship_skin_reward[arg0.configId]
	local var1 = {}

	for iter0, iter1 in pairs(var0.reward) do
		table.insert(var1, {
			type = iter1[1],
			id = iter1[2],
			count = iter1[3]
		})
	end

	return var1
end

function var0.GetRewardListDesc(arg0)
	local var0 = arg0:GetRewardList()

	if #var0 <= 0 then
		return ""
	end

	local var1 = _.map(var0, function(arg0)
		return {
			arg0.type,
			arg0.id,
			arg0.count
		}
	end)

	return getDropInfo(var1)
end

return var0
