local var0 = class("ShipSkinProxy", import(".NetProxy"))

var0.SHIP_SKINS_UPDATE = "ship skins update"
var0.SHIP_SKIN_EXPIRED = "ship skin expired"
var0.FORBIDDEN_TYPE_HIDE = 0
var0.FORBIDDEN_TYPE_SHOW = 1

function var0.register(arg0)
	arg0.skins = {}
	arg0.cacheSkins = {}
	arg0.timers = {}
	arg0.forbiddenSkinList = {}

	arg0:on(12201, function(arg0)
		_.each(arg0.skin_list, function(arg0)
			local var0 = ShipSkin.New(arg0)

			arg0:addSkin(ShipSkin.New(arg0))
		end)
		_.each(arg0.forbidden_skin_list, function(arg0)
			table.insert(arg0.forbiddenSkinList, {
				id = arg0,
				type = var0.FORBIDDEN_TYPE_HIDE
			})
		end)

		for iter0, iter1 in ipairs(arg0.forbidden_skin_type) do
			arg0.forbiddenSkinList[iter0].type = iter1
		end
	end)
end

function var0.getOverDueSkins(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.cacheSkins) do
		table.insert(var0, iter1)
	end

	arg0.cacheSkins = {}

	return var0
end

function var0.getRawData(arg0)
	return arg0.skins
end

function var0.getSkinList(arg0)
	return _.map(_.values(arg0.skins), function(arg0)
		return arg0.id
	end)
end

function var0.addSkin(arg0, arg1)
	assert(isa(arg1, ShipSkin), "skin should be an instance of ShipSkin")

	if arg0.prevNewSkin then
		arg0.prevNewSkin:SetIsNew(false)
	end

	arg0.skins[arg1.id] = arg1
	arg0.prevNewSkin = arg1

	arg0:addExpireTimer(arg1)
	arg0.facade:sendNotification(var0.SHIP_SKINS_UPDATE)
end

function var0.getSkinById(arg0, arg1)
	return arg0.skins[arg1]
end

function var0.addExpireTimer(arg0, arg1)
	arg0:removeExpireTimer(arg1.id)

	if not arg1:isExpireType() then
		return
	end

	local function var0()
		table.insert(arg0.cacheSkins, arg1)
		arg0:removeSkinById(arg1.id)

		local var0 = getProxy(BayProxy)
		local var1 = var0:getShips()

		_.each(var1, function(arg0)
			if arg0.skinId == arg1.id then
				arg0.skinId = arg0:getConfig("skin_id")

				var0:updateShip(arg0)
			end
		end)
		arg0:sendNotification(GAME.SHIP_SKIN_EXPIRED)
	end

	local var1 = arg1:getExpireTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var1 <= 0 then
		var0()
	else
		arg0.timers[arg1.id] = Timer.New(var0, var1, 1)

		arg0.timers[arg1.id]:Start()
	end
end

function var0.removeExpireTimer(arg0, arg1)
	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end
end

function var0.removeSkinById(arg0, arg1)
	arg0.skins[arg1] = nil

	arg0:removeExpireTimer(arg1)
	arg0.facade:sendNotification(var0.SHIP_SKINS_UPDATE)
end

function var0.hasSkin(arg0, arg1)
	return arg0.skins[arg1] ~= nil
end

function var0.hasNonLimitSkin(arg0, arg1)
	local var0 = arg0.skins[arg1]

	return var0 ~= nil and not var0:isExpireType()
end

function var0.hasOldNonLimitSkin(arg0, arg1)
	local var0 = arg0.skins[arg1]

	return var0 and not var0:HasNewFlag() and not var0:isExpireType()
end

function var0.getSkinCountById(arg0, arg1)
	return arg0:hasSkin(arg1) and 1 or 0
end

function var0.InForbiddenSkinListAndHide(arg0, arg1)
	return _.any(arg0.forbiddenSkinList, function(arg0)
		return arg0.id == arg1 and arg0.type == var0.FORBIDDEN_TYPE_HIDE
	end)
end

function var0.InForbiddenSkinListAndShow(arg0, arg1)
	return _.any(arg0.forbiddenSkinList, function(arg0)
		return arg0.id == arg1 and arg0.type == var0.FORBIDDEN_TYPE_SHOW
	end)
end

function var0.InForbiddenSkinList(arg0, arg1)
	return _.any(arg0.forbiddenSkinList, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.remove(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = nil
end

function var0.GetAllSkins(arg0)
	local var0 = {}

	local function var1(arg0)
		local var0 = arg0:getSkinId()
		local var1 = getProxy(ShipSkinProxy):getSkinById(var0)
		local var2 = var1 and not var1:isExpireType() and 1 or 0

		arg0:updateBuyCount(var2)
	end

	local function var2(arg0)
		local var0 = Goods.Create({
			shop_id = arg0
		}, Goods.TYPE_SKIN)

		var1(var0)

		local var1, var2 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0].time)

		if var1 then
			table.insert(var0, var0)
		end
	end

	for iter0, iter1 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2(iter1)
	end

	for iter2, iter3 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2(iter3)
	end

	local var3 = getProxy(ActivityProxy)
	local var4 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4, iter5 in ipairs(var4) do
		local var5 = pg.activity_shop_extra[iter5]
		local var6 = var3:getActivityById(var5.activity)

		if var5.activity == 0 and pg.TimeMgr.GetInstance():inTime(var5.time) or var6 and not var6:isEnd() then
			local var7 = Goods.Create({
				shop_id = iter5
			}, Goods.TYPE_ACTIVITY_EXTRA)

			var1(var7)
			table.insert(var0, var7)
		end
	end

	local var8 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6, iter7 in ipairs(var8) do
		local var9 = pg.activity_shop_template[iter7]
		local var10 = var3:getActivityById(var9.activity)

		if var10 and not var10:isEnd() then
			local var11 = Goods.Create({
				shop_id = iter7
			}, Goods.TYPE_ACTIVITY)

			var1(var11)

			if not _.any(var0, function(arg0)
				return arg0:getSkinId() == var11:getSkinId()
			end) then
				table.insert(var0, var11)
			end
		end
	end

	for iter8 = #var0, 1, -1 do
		local var12 = var0[iter8]:getSkinId()

		if arg0:InForbiddenSkinList(var12) or not arg0:InShowTime(var12) then
			table.remove(var0, iter8)
		end
	end

	return var0
end

function var0.GetShopShowingSkins(arg0)
	local var0 = {}

	local function var1(arg0)
		local var0 = arg0:getSkinId()
		local var1 = getProxy(ShipSkinProxy):getSkinById(var0)
		local var2 = var1 and not var1:isExpireType() and 1 or 0

		arg0:updateBuyCount(var2)
	end

	local function var2(arg0)
		local var0 = Goods.Create({
			shop_id = arg0
		}, Goods.TYPE_SKIN)

		var1(var0)
		table.insert(var0, var0)
	end

	for iter0, iter1 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2(iter1)
	end

	for iter2, iter3 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2(iter3)
	end

	local var3 = getProxy(ActivityProxy)
	local var4 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4, iter5 in ipairs(var4) do
		local var5 = Goods.Create({
			shop_id = iter5
		}, Goods.TYPE_ACTIVITY_EXTRA)

		var1(var5)
		table.insert(var0, var5)
	end

	local var6 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6, iter7 in ipairs(var6) do
		local var7 = Goods.Create({
			shop_id = iter7
		}, Goods.TYPE_ACTIVITY)

		var1(var7)

		if not _.any(var0, function(arg0)
			return arg0:getSkinId() == var7:getSkinId()
		end) then
			table.insert(var0, var7)
		end
	end

	return var0
end

function var0.GetAllSkinForShip(arg0, arg1)
	assert(isa(arg1, Ship), "ship should be an instance of Ship")

	local var0 = arg1.groupId
	local var1 = ShipGroup.getSkinList(var0)

	for iter0 = #var1, 1, -1 do
		local var2 = var1[iter0]

		if var2.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0:hasSkin(var2.id) then
			table.remove(var1, iter0)
		elseif not arg0:InShowTime(var2.id) then
			table.remove(var1, iter0)
		end
	end

	if pg.ship_data_trans[var0] and not arg1:isRemoulded() then
		local var3 = ShipGroup.GetGroupConfig(var0).trans_skin

		for iter1 = #var1, 1, -1 do
			if var1[iter1].id == var3 then
				table.remove(var1, iter1)

				break
			end
		end
	end

	for iter2 = #var1, 1, -1 do
		local var4 = var1[iter2]

		if var4.show_time and (type(var4.show_time) == "string" and var4.show_time == "stop" or type(var4.show_time) == "table" and not pg.TimeMgr.GetInstance():inTime(var4.show_time)) then
			table.remove(var1, iter2)
		end

		if var4.no_showing == "1" then
			table.remove(var1, iter2)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4.id].isHX == 1 then
			table.remove(var1, iter2)
		end
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var5 = pg.gameset.big_seven_old_skin_timestamp.key_value

		for iter3 = #var1, 1, -1 do
			if var1[iter3].skin_type == ShipSkin.SKIN_TYPE_OLD and var5 < arg1.createTime then
				table.remove(var1, iter3)
			end
		end
	end

	if #arg0.forbiddenSkinList > 0 then
		for iter4 = #var1, 1, -1 do
			local var6 = var1[iter4].id

			if not arg0:hasSkin(var6) and arg0:InForbiddenSkinListAndHide(var6) then
				table.remove(var1, iter4)
			end
		end
	end

	return var1
end

function var0.GetShareSkinsForShipGroup(arg0, arg1)
	local var0 = pg.ship_data_group.get_id_list_by_group_type[arg1][1]
	local var1 = pg.ship_data_group[var0]

	if not var1.share_group_id or #var1.share_group_id <= 0 then
		return {}
	end

	local var2 = {}

	for iter0, iter1 in ipairs(var1.share_group_id) do
		local var3 = pg.ship_skin_template.get_id_list_by_ship_group[iter1]

		for iter2, iter3 in ipairs(var3) do
			local var4 = ShipSkin.New({
				id = iter3
			})

			if var4:CanShare() then
				table.insert(var2, var4)
			end
		end
	end

	return var2
end

function var0.GetShareSkinsForShip(arg0, arg1)
	local var0 = arg1.groupId

	return arg0:GetShareSkinsForShipGroup(var0)
end

function var0.GetAllSkinForARCamera(arg0, arg1)
	local var0 = ShipGroup.getSkinList(arg1)

	for iter0 = #var0, 1, -1 do
		if var0[iter0].skin_type == ShipSkin.SKIN_TYPE_OLD then
			table.remove(var0, iter0)
		end
	end

	local var1 = ShipGroup.GetGroupConfig(arg1).trans_skin

	if var1 ~= 0 then
		local var2 = false
		local var3 = getProxy(CollectionProxy):getShipGroup(arg1)

		if var3 then
			for iter1, iter2 in ipairs(var0) do
				if iter2.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var3.trans then
					var2 = true

					break
				end
			end
		end

		if not var2 then
			for iter3 = #var0, 1, -1 do
				if var0[iter3].id == var1 then
					table.remove(var0, iter3)

					break
				end
			end
		end
	end

	for iter4 = #var0, 1, -1 do
		local var4 = var0[iter4]

		if var4.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0:hasSkin(var4.id) then
			table.remove(var0, iter4)
		elseif var4.no_showing == "1" then
			table.remove(var0, iter4)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4.id].isHX == 1 then
			table.remove(var0, iter4)
		elseif not arg0:InShowTime(var4.id) then
			table.remove(var0, iter4)
		end
	end

	if #arg0.forbiddenSkinList > 0 then
		for iter5 = #var0, 1, -1 do
			local var5 = var0[iter5].id

			if not arg0:hasSkin(var5) and arg0:InForbiddenSkinListAndHide(var5) then
				table.remove(var0, iter5)
			end
		end
	end

	return var0
end

function var0.InShowTime(arg0, arg1)
	local var0 = pg.ship_skin_template_column_time[arg1]

	if var0 and var0.time ~= "" and type(var0.time) == "table" and #var0.time > 0 then
		return pg.TimeMgr.GetInstance():passTime(var0.time)
	end

	return true
end

function var0.HasFashion(arg0, arg1)
	if #arg0:GetShareSkinsForShip(arg1) > 0 then
		return true
	end

	local var0 = arg0:GetAllSkinForShip(arg1)

	if #var0 == 1 then
		local var1 = var0[1]

		return (checkABExist("painting/" .. var1.painting .. "_n"))
	end

	return #var0 > 1
end

function var0.GetEncoreSkins(arg0)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	local function var1(arg0)
		local var0 = arg0:getConfig("config_client")

		if var0 and var0[1] and type(var0[1]) == "table" then
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0[1]) <= pg.TimeMgr.GetInstance():GetServerTime()
		else
			return arg0:isEnd()
		end
	end

	for iter0, iter1 in ipairs(var0) do
		if iter1:getDataConfig("type") == 5 and not var1(iter1) then
			return iter1:getConfig("config_data")
		end
	end

	return {}
end

function var0.GetOwnSkins(arg0)
	local var0 = {}
	local var1 = arg0:getRawData()

	for iter0, iter1 in pairs(var1) do
		table.insert(var0, iter1)
	end

	local var2 = getProxy(CollectionProxy).shipGroups

	for iter2, iter3 in pairs(var2) do
		if iter3.married == 1 then
			local var3 = ShipGroup.getProposeSkin(iter3.id)

			if var3 then
				table.insert(var0, ShipSkin.New({
					id = var3.id
				}))
			end
		end

		if iter3.trans then
			local var4 = pg.ship_data_trans[iter3.id].skin_id

			table.insert(var0, ShipSkin.New({
				id = var4
			}))
		end
	end

	return var0
end

function var0.GetOwnAndShareSkins(arg0)
	local var0 = arg0:GetOwnSkins()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[iter1.id] = iter1
	end

	local var2 = getProxy(CollectionProxy).shipGroups

	for iter2, iter3 in pairs(var2) do
		if iter3.married == 1 then
			local var3 = arg0:GetShareSkinsForShipGroup(iter3.id)

			for iter4, iter5 in ipairs(var3) do
				if not var1[iter5.id] then
					table.insert(var0, iter5)
				end
			end
		end
	end

	return var0
end

function var0.GetProbabilitySkins(arg0, arg1)
	local var0 = {}

	local function var1(arg0)
		local var0 = arg0:getSkinId()
		local var1 = getProxy(ShipSkinProxy):getSkinById(var0)
		local var2 = var1 and not var1:isExpireType() and 1 or 0

		arg0:updateBuyCount(var2)
	end

	local function var2(arg0)
		local var0 = Goods.Create({
			shop_id = arg0
		}, Goods.TYPE_SKIN)

		var1(var0)

		local var1, var2 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0].time)

		if var1 then
			table.insert(var0, var0)
		end
	end

	local var3 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4 = {}

	for iter0, iter1 in ipairs(var3) do
		if iter1:getConfig("genre") ~= ShopArgs.SkinShopTimeLimit then
			var4[iter1:getSkinId()] = iter1.id
		end
	end

	for iter2, iter3 in ipairs(arg1) do
		local var5 = var4[iter3[1]]

		if var5 then
			var2(var5)
		end
	end

	return var0
end

function var0.GetSkinProbabilitys(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		var0[iter1[1]] = iter1[2]
	end

	return var0
end

return var0
