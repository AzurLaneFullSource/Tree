local var0_0 = class("ShipSkinProxy", import(".NetProxy"))

var0_0.SHIP_SKINS_UPDATE = "ship skins update"
var0_0.SHIP_SKIN_EXPIRED = "ship skin expired"
var0_0.FORBIDDEN_TYPE_HIDE = 0
var0_0.FORBIDDEN_TYPE_SHOW = 1

function var0_0.register(arg0_1)
	arg0_1.skins = {}
	arg0_1.cacheSkins = {}
	arg0_1.timers = {}
	arg0_1.forbiddenSkinList = {}

	arg0_1:on(12201, function(arg0_2)
		_.each(arg0_2.skin_list, function(arg0_3)
			local var0_3 = ShipSkin.New(arg0_3)

			arg0_1:addSkin(ShipSkin.New(arg0_3))
		end)
		_.each(arg0_2.forbidden_skin_list, function(arg0_4)
			table.insert(arg0_1.forbiddenSkinList, {
				id = arg0_4,
				type = var0_0.FORBIDDEN_TYPE_HIDE
			})
		end)

		for iter0_2, iter1_2 in ipairs(arg0_2.forbidden_skin_type) do
			arg0_1.forbiddenSkinList[iter0_2].type = iter1_2
		end
	end)
end

function var0_0.getOverDueSkins(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.cacheSkins) do
		table.insert(var0_5, iter1_5)
	end

	arg0_5.cacheSkins = {}

	return var0_5
end

function var0_0.getRawData(arg0_6)
	return arg0_6.skins
end

function var0_0.getSkinList(arg0_7)
	return _.map(_.values(arg0_7.skins), function(arg0_8)
		return arg0_8.id
	end)
end

function var0_0.addSkin(arg0_9, arg1_9)
	assert(isa(arg1_9, ShipSkin), "skin should be an instance of ShipSkin")

	if arg0_9.prevNewSkin then
		arg0_9.prevNewSkin:SetIsNew(false)
	end

	arg0_9.skins[arg1_9.id] = arg1_9
	arg0_9.prevNewSkin = arg1_9

	arg0_9:addExpireTimer(arg1_9)
	arg0_9.facade:sendNotification(var0_0.SHIP_SKINS_UPDATE)
end

function var0_0.getSkinById(arg0_10, arg1_10)
	return arg0_10.skins[arg1_10]
end

function var0_0.addExpireTimer(arg0_11, arg1_11)
	arg0_11:removeExpireTimer(arg1_11.id)

	if not arg1_11:isExpireType() then
		return
	end

	local function var0_11()
		table.insert(arg0_11.cacheSkins, arg1_11)
		arg0_11:removeSkinById(arg1_11.id)

		local var0_12 = getProxy(BayProxy)
		local var1_12 = var0_12:getShips()

		_.each(var1_12, function(arg0_13)
			if arg0_13.skinId == arg1_11.id then
				arg0_13.skinId = arg0_13:getConfig("skin_id")

				var0_12:updateShip(arg0_13)
			end
		end)
		arg0_11:sendNotification(GAME.SHIP_SKIN_EXPIRED)
	end

	local var1_11 = arg1_11:getExpireTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var1_11 <= 0 then
		var0_11()
	else
		arg0_11.timers[arg1_11.id] = Timer.New(var0_11, var1_11, 1)

		arg0_11.timers[arg1_11.id]:Start()
	end
end

function var0_0.removeExpireTimer(arg0_14, arg1_14)
	if arg0_14.timers[arg1_14] then
		arg0_14.timers[arg1_14]:Stop()

		arg0_14.timers[arg1_14] = nil
	end
end

function var0_0.removeSkinById(arg0_15, arg1_15)
	arg0_15.skins[arg1_15] = nil

	arg0_15:removeExpireTimer(arg1_15)
	arg0_15.facade:sendNotification(var0_0.SHIP_SKINS_UPDATE)
end

function var0_0.hasSkin(arg0_16, arg1_16)
	if ShipGroup.IsChangeSkin(arg1_16) then
		local var0_16 = ShipGroup.GetChangeSkinGroupId(arg1_16)

		return arg0_16:hasChangeSkin(var0_16)
	end

	return arg0_16.skins[arg1_16] ~= nil
end

function var0_0.hasChangeSkin(arg0_17, arg1_17)
	for iter0_17, iter1_17 in pairs(arg0_17.skins) do
		if iter1_17:IsChangeSkin() and ShipGroup.GetChangeSkinGroupId(iter0_17) == arg1_17 then
			return true
		end
	end

	return false
end

function var0_0.hasNonLimitSkin(arg0_18, arg1_18)
	local var0_18 = arg0_18.skins[arg1_18]

	return var0_18 ~= nil and not var0_18:isExpireType()
end

function var0_0.hasOldNonLimitSkin(arg0_19, arg1_19)
	local var0_19 = arg0_19.skins[arg1_19]

	return var0_19 and not var0_19:HasNewFlag() and not var0_19:isExpireType()
end

function var0_0.getSkinCountById(arg0_20, arg1_20)
	return arg0_20:hasSkin(arg1_20) and 1 or 0
end

function var0_0.InForbiddenSkinListAndHide(arg0_21, arg1_21)
	return _.any(arg0_21.forbiddenSkinList, function(arg0_22)
		return arg0_22.id == arg1_21 and arg0_22.type == var0_0.FORBIDDEN_TYPE_HIDE
	end)
end

function var0_0.InForbiddenSkinListAndShow(arg0_23, arg1_23)
	return _.any(arg0_23.forbiddenSkinList, function(arg0_24)
		return arg0_24.id == arg1_23 and arg0_24.type == var0_0.FORBIDDEN_TYPE_SHOW
	end)
end

function var0_0.InForbiddenSkinList(arg0_25, arg1_25)
	return _.any(arg0_25.forbiddenSkinList, function(arg0_26)
		return arg0_26.id == arg1_25
	end)
end

function var0_0.remove(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.timers) do
		iter1_27:Stop()
	end

	arg0_27.timers = nil
end

function var0_0.GetAllSkins(arg0_28)
	local var0_28 = {}

	local function var1_28(arg0_29)
		local var0_29 = arg0_29:getSkinId()
		local var1_29 = getProxy(ShipSkinProxy):getSkinById(var0_29)
		local var2_29 = var1_29 and not var1_29:isExpireType() and 1 or 0

		arg0_29:updateBuyCount(var2_29)
	end

	local function var2_28(arg0_30)
		local var0_30 = Goods.Create({
			shop_id = arg0_30
		}, Goods.TYPE_SKIN)

		var1_28(var0_30)

		local var1_30 = pg.shop_template[arg0_30].collaboration_skin_time
		local var2_30 = var1_30 == "" or var1_30 == pg.shop_template[arg0_30].time
		local var3_30, var4_30 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_30].time)

		if var2_30 and var3_30 then
			table.insert(var0_28, var0_30)
		end
	end

	for iter0_28, iter1_28 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_28(iter1_28)
	end

	for iter2_28, iter3_28 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_28(iter3_28)
	end

	local var3_28 = getProxy(ActivityProxy)
	local var4_28 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_28, iter5_28 in ipairs(var4_28) do
		local var5_28 = pg.activity_shop_extra[iter5_28]
		local var6_28 = var3_28:getActivityById(var5_28.activity)

		if var5_28.activity == 0 and pg.TimeMgr.GetInstance():inTime(var5_28.time) or var6_28 and not var6_28:isEnd() then
			local var7_28 = Goods.Create({
				shop_id = iter5_28
			}, Goods.TYPE_ACTIVITY_EXTRA)

			var1_28(var7_28)
			table.insert(var0_28, var7_28)
		end
	end

	local var8_28 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_28, iter7_28 in ipairs(var8_28) do
		local var9_28 = pg.activity_shop_template[iter7_28]
		local var10_28 = var3_28:getActivityById(var9_28.activity)

		if var10_28 and not var10_28:isEnd() then
			local var11_28 = Goods.Create({
				shop_id = iter7_28
			}, Goods.TYPE_ACTIVITY)

			var1_28(var11_28)

			if not _.any(var0_28, function(arg0_31)
				return arg0_31:getSkinId() == var11_28:getSkinId()
			end) then
				table.insert(var0_28, var11_28)
			end
		end
	end

	for iter8_28 = #var0_28, 1, -1 do
		local var12_28 = var0_28[iter8_28]:getSkinId()

		if arg0_28:InForbiddenSkinList(var12_28) or not arg0_28:InShowTime(var12_28) then
			table.remove(var0_28, iter8_28)
		end
	end

	return var0_28
end

function var0_0.GetShopShowingSkins(arg0_32)
	local var0_32 = {}

	local function var1_32(arg0_33)
		local var0_33 = arg0_33:getSkinId()
		local var1_33 = getProxy(ShipSkinProxy):getSkinById(var0_33)
		local var2_33 = var1_33 and not var1_33:isExpireType() and 1 or 0

		arg0_33:updateBuyCount(var2_33)
	end

	local function var2_32(arg0_34)
		local var0_34 = Goods.Create({
			shop_id = arg0_34
		}, Goods.TYPE_SKIN)

		var1_32(var0_34)
		table.insert(var0_32, var0_34)
	end

	for iter0_32, iter1_32 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_32(iter1_32)
	end

	for iter2_32, iter3_32 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_32(iter3_32)
	end

	local var3_32 = getProxy(ActivityProxy)
	local var4_32 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_32, iter5_32 in ipairs(var4_32) do
		local var5_32 = Goods.Create({
			shop_id = iter5_32
		}, Goods.TYPE_ACTIVITY_EXTRA)

		var1_32(var5_32)
		table.insert(var0_32, var5_32)
	end

	local var6_32 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_32, iter7_32 in ipairs(var6_32) do
		local var7_32 = Goods.Create({
			shop_id = iter7_32
		}, Goods.TYPE_ACTIVITY)

		var1_32(var7_32)

		if not _.any(var0_32, function(arg0_35)
			return arg0_35:getSkinId() == var7_32:getSkinId()
		end) then
			table.insert(var0_32, var7_32)
		end
	end

	return var0_32
end

function var0_0.GetAllSkinForShip(arg0_36, arg1_36)
	assert(isa(arg1_36, Ship), "ship should be an instance of Ship")

	local var0_36 = arg1_36.groupId
	local var1_36 = ShipGroup.getSkinList(var0_36)

	for iter0_36 = #var1_36, 1, -1 do
		local var2_36 = var1_36[iter0_36]

		if var2_36.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_36:hasSkin(var2_36.id) then
			table.remove(var1_36, iter0_36)
		elseif not arg0_36:InShowTime(var2_36.id) then
			table.remove(var1_36, iter0_36)
		end
	end

	if pg.ship_data_trans[var0_36] and not arg1_36:isRemoulded() then
		local var3_36 = ShipGroup.GetGroupConfig(var0_36).trans_skin

		for iter1_36 = #var1_36, 1, -1 do
			if var1_36[iter1_36].id == var3_36 then
				table.remove(var1_36, iter1_36)

				break
			end
		end
	end

	for iter2_36 = #var1_36, 1, -1 do
		local var4_36 = var1_36[iter2_36]

		if var4_36.show_time and (type(var4_36.show_time) == "string" and var4_36.show_time == "stop" or type(var4_36.show_time) == "table" and not pg.TimeMgr.GetInstance():inTime(var4_36.show_time)) then
			table.remove(var1_36, iter2_36)
		end

		if var4_36.no_showing == "1" then
			table.remove(var1_36, iter2_36)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_36.id].isHX == 1 then
			table.remove(var1_36, iter2_36)
		end
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var5_36 = pg.gameset.big_seven_old_skin_timestamp.key_value

		for iter3_36 = #var1_36, 1, -1 do
			if var1_36[iter3_36].skin_type == ShipSkin.SKIN_TYPE_OLD and var5_36 < arg1_36.createTime then
				table.remove(var1_36, iter3_36)
			end
		end
	end

	if #arg0_36.forbiddenSkinList > 0 then
		for iter4_36 = #var1_36, 1, -1 do
			local var6_36 = var1_36[iter4_36].id

			if not arg0_36:hasSkin(var6_36) and arg0_36:InForbiddenSkinListAndHide(var6_36) then
				table.remove(var1_36, iter4_36)
			end
		end
	end

	for iter5_36 = #var1_36, 1, -1 do
		local var7_36 = var1_36[iter5_36]

		if var7_36 and var7_36.change_skin and var7_36.change_skin.group then
			local var8_36 = var7_36.change_skin.group
			local var9_36 = ShipGroup.GetStoreChangeSkinId(var8_36, arg1_36.id)

			if var9_36 and var9_36 ~= var7_36.id then
				print("有缓存的id = " .. var9_36 .. "移除了id" .. var7_36.id)
				table.remove(var1_36, iter5_36)
			elseif not var9_36 and var7_36.change_skin.index ~= 1 then
				print("没有缓存的id ，" .. "移除了id" .. var7_36.id)
				table.remove(var1_36, iter5_36)
			end
		end
	end

	return var1_36
end

function var0_0.GetShareSkinsForShipGroup(arg0_37, arg1_37)
	local var0_37 = pg.ship_data_group.get_id_list_by_group_type[arg1_37][1]
	local var1_37 = pg.ship_data_group[var0_37]

	if not var1_37.share_group_id or #var1_37.share_group_id <= 0 then
		return {}
	end

	local var2_37 = {}

	for iter0_37, iter1_37 in ipairs(var1_37.share_group_id) do
		local var3_37 = pg.ship_skin_template.get_id_list_by_ship_group[iter1_37]

		for iter2_37, iter3_37 in ipairs(var3_37) do
			local var4_37 = ShipSkin.New({
				id = iter3_37
			})

			if var4_37:CanShare() then
				table.insert(var2_37, var4_37)
			end
		end
	end

	return var2_37
end

function var0_0.GetShareSkinsForShip(arg0_38, arg1_38)
	local var0_38 = arg1_38.groupId

	return arg0_38:GetShareSkinsForShipGroup(var0_38)
end

function var0_0.GetAllSkinForARCamera(arg0_39, arg1_39)
	local var0_39 = ShipGroup.getSkinList(arg1_39)

	for iter0_39 = #var0_39, 1, -1 do
		if var0_39[iter0_39].skin_type == ShipSkin.SKIN_TYPE_OLD then
			table.remove(var0_39, iter0_39)
		end
	end

	local var1_39 = ShipGroup.GetGroupConfig(arg1_39).trans_skin

	if var1_39 ~= 0 then
		local var2_39 = false
		local var3_39 = getProxy(CollectionProxy):getShipGroup(arg1_39)

		if var3_39 then
			for iter1_39, iter2_39 in ipairs(var0_39) do
				if iter2_39.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var3_39.trans then
					var2_39 = true

					break
				end
			end
		end

		if not var2_39 then
			for iter3_39 = #var0_39, 1, -1 do
				if var0_39[iter3_39].id == var1_39 then
					table.remove(var0_39, iter3_39)

					break
				end
			end
		end
	end

	for iter4_39 = #var0_39, 1, -1 do
		local var4_39 = var0_39[iter4_39]

		if var4_39.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_39:hasSkin(var4_39.id) then
			table.remove(var0_39, iter4_39)
		elseif var4_39.no_showing == "1" then
			table.remove(var0_39, iter4_39)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_39.id].isHX == 1 then
			table.remove(var0_39, iter4_39)
		elseif not arg0_39:InShowTime(var4_39.id) then
			table.remove(var0_39, iter4_39)
		end
	end

	if #arg0_39.forbiddenSkinList > 0 then
		for iter5_39 = #var0_39, 1, -1 do
			local var5_39 = var0_39[iter5_39].id

			if not arg0_39:hasSkin(var5_39) and arg0_39:InForbiddenSkinListAndHide(var5_39) then
				table.remove(var0_39, iter5_39)
			end
		end
	end

	for iter6_39 = #var0_39, 1, -1 do
		local var6_39 = var0_39[iter6_39]

		if var6_39 and var6_39.change_skin and var6_39.change_skin.index and var6_39.change_skin.index ~= 1 then
			table.remove(var0_39, iter6_39)
		end
	end

	return var0_39
end

function var0_0.InShowTime(arg0_40, arg1_40)
	local var0_40 = pg.ship_skin_template_column_time[arg1_40]

	if var0_40 and var0_40.time ~= "" and type(var0_40.time) == "table" and #var0_40.time > 0 then
		return pg.TimeMgr.GetInstance():passTime(var0_40.time)
	end

	return true
end

function var0_0.HasFashion(arg0_41, arg1_41)
	if #arg0_41:GetShareSkinsForShip(arg1_41) > 0 then
		return true
	end

	local var0_41 = arg0_41:GetAllSkinForShip(arg1_41)

	if #var0_41 == 1 then
		local var1_41 = var0_41[1]

		return (checkABExist("painting/" .. var1_41.painting .. "_n"))
	end

	return #var0_41 > 1
end

function var0_0.GetEncoreSkins(arg0_42)
	local var0_42 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	local function var1_42(arg0_43)
		local var0_43 = arg0_43:getConfig("config_client")

		if var0_43 and var0_43[1] and type(var0_43[1]) == "table" then
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_43[1]) <= pg.TimeMgr.GetInstance():GetServerTime()
		else
			return arg0_43:isEnd()
		end
	end

	for iter0_42, iter1_42 in ipairs(var0_42) do
		if iter1_42:getDataConfig("type") == 5 and not var1_42(iter1_42) then
			return iter1_42:getConfig("config_data")
		end
	end

	return {}
end

function var0_0.GetOwnSkins(arg0_44)
	local var0_44 = {}
	local var1_44 = arg0_44:getRawData()

	for iter0_44, iter1_44 in pairs(var1_44) do
		table.insert(var0_44, iter1_44)
	end

	local var2_44 = getProxy(CollectionProxy).shipGroups

	for iter2_44, iter3_44 in pairs(var2_44) do
		if iter3_44.married == 1 then
			local var3_44 = ShipGroup.getProposeSkin(iter3_44.id)

			if var3_44 then
				table.insert(var0_44, ShipSkin.New({
					id = var3_44.id
				}))
			end
		end

		if iter3_44.trans then
			local var4_44 = pg.ship_data_trans[iter3_44.id].skin_id

			table.insert(var0_44, ShipSkin.New({
				id = var4_44
			}))
		end
	end

	return var0_44
end

function var0_0.GetOwnAndShareSkins(arg0_45)
	local var0_45 = arg0_45:GetOwnSkins()
	local var1_45 = {}

	for iter0_45, iter1_45 in ipairs(var0_45) do
		var1_45[iter1_45.id] = iter1_45
	end

	local var2_45 = getProxy(CollectionProxy).shipGroups

	for iter2_45, iter3_45 in pairs(var2_45) do
		if iter3_45.married == 1 then
			local var3_45 = arg0_45:GetShareSkinsForShipGroup(iter3_45.id)

			for iter4_45, iter5_45 in ipairs(var3_45) do
				if not var1_45[iter5_45.id] then
					table.insert(var0_45, iter5_45)
				end
			end
		end
	end

	return var0_45
end

function var0_0.GetProbabilitySkins(arg0_46, arg1_46)
	local var0_46 = {}

	local function var1_46(arg0_47)
		local var0_47 = arg0_47:getSkinId()
		local var1_47 = getProxy(ShipSkinProxy):getSkinById(var0_47)
		local var2_47 = var1_47 and not var1_47:isExpireType() and 1 or 0

		arg0_47:updateBuyCount(var2_47)
	end

	local function var2_46(arg0_48)
		local var0_48 = Goods.Create({
			shop_id = arg0_48
		}, Goods.TYPE_SKIN)

		var1_46(var0_48)

		local var1_48, var2_48 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_48].time)

		if var1_48 then
			table.insert(var0_46, var0_48)
		end
	end

	local var3_46 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4_46 = {}

	for iter0_46, iter1_46 in ipairs(var3_46) do
		if iter1_46:getConfig("genre") ~= ShopArgs.SkinShopTimeLimit then
			var4_46[iter1_46:getSkinId()] = iter1_46.id
		end
	end

	for iter2_46, iter3_46 in ipairs(arg1_46) do
		local var5_46 = var4_46[iter3_46[1]]

		if var5_46 then
			var2_46(var5_46)
		end
	end

	return var0_46
end

function var0_0.GetSkinProbabilitys(arg0_49, arg1_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in ipairs(arg1_49) do
		var0_49[iter1_49[1]] = iter1_49[2]
	end

	return var0_49
end

return var0_0
