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
	return arg0_16.skins[arg1_16] ~= nil
end

function var0_0.hasNonLimitSkin(arg0_17, arg1_17)
	local var0_17 = arg0_17.skins[arg1_17]

	return var0_17 ~= nil and not var0_17:isExpireType()
end

function var0_0.hasOldNonLimitSkin(arg0_18, arg1_18)
	local var0_18 = arg0_18.skins[arg1_18]

	return var0_18 and not var0_18:HasNewFlag() and not var0_18:isExpireType()
end

function var0_0.getSkinCountById(arg0_19, arg1_19)
	return arg0_19:hasSkin(arg1_19) and 1 or 0
end

function var0_0.InForbiddenSkinListAndHide(arg0_20, arg1_20)
	return _.any(arg0_20.forbiddenSkinList, function(arg0_21)
		return arg0_21.id == arg1_20 and arg0_21.type == var0_0.FORBIDDEN_TYPE_HIDE
	end)
end

function var0_0.InForbiddenSkinListAndShow(arg0_22, arg1_22)
	return _.any(arg0_22.forbiddenSkinList, function(arg0_23)
		return arg0_23.id == arg1_22 and arg0_23.type == var0_0.FORBIDDEN_TYPE_SHOW
	end)
end

function var0_0.InForbiddenSkinList(arg0_24, arg1_24)
	return _.any(arg0_24.forbiddenSkinList, function(arg0_25)
		return arg0_25.id == arg1_24
	end)
end

function var0_0.remove(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.timers) do
		iter1_26:Stop()
	end

	arg0_26.timers = nil
end

function var0_0.GetAllSkins(arg0_27)
	local var0_27 = {}

	local function var1_27(arg0_28)
		local var0_28 = arg0_28:getSkinId()
		local var1_28 = getProxy(ShipSkinProxy):getSkinById(var0_28)
		local var2_28 = var1_28 and not var1_28:isExpireType() and 1 or 0

		arg0_28:updateBuyCount(var2_28)
	end

	local function var2_27(arg0_29)
		local var0_29 = Goods.Create({
			shop_id = arg0_29
		}, Goods.TYPE_SKIN)

		var1_27(var0_29)

		local var1_29, var2_29 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_29].time)

		if var1_29 then
			table.insert(var0_27, var0_29)
		end
	end

	for iter0_27, iter1_27 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_27(iter1_27)
	end

	for iter2_27, iter3_27 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_27(iter3_27)
	end

	local var3_27 = getProxy(ActivityProxy)
	local var4_27 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_27, iter5_27 in ipairs(var4_27) do
		local var5_27 = pg.activity_shop_extra[iter5_27]
		local var6_27 = var3_27:getActivityById(var5_27.activity)

		if var5_27.activity == 0 and pg.TimeMgr.GetInstance():inTime(var5_27.time) or var6_27 and not var6_27:isEnd() then
			local var7_27 = Goods.Create({
				shop_id = iter5_27
			}, Goods.TYPE_ACTIVITY_EXTRA)

			var1_27(var7_27)
			table.insert(var0_27, var7_27)
		end
	end

	local var8_27 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_27, iter7_27 in ipairs(var8_27) do
		local var9_27 = pg.activity_shop_template[iter7_27]
		local var10_27 = var3_27:getActivityById(var9_27.activity)

		if var10_27 and not var10_27:isEnd() then
			local var11_27 = Goods.Create({
				shop_id = iter7_27
			}, Goods.TYPE_ACTIVITY)

			var1_27(var11_27)

			if not _.any(var0_27, function(arg0_30)
				return arg0_30:getSkinId() == var11_27:getSkinId()
			end) then
				table.insert(var0_27, var11_27)
			end
		end
	end

	for iter8_27 = #var0_27, 1, -1 do
		local var12_27 = var0_27[iter8_27]:getSkinId()

		if arg0_27:InForbiddenSkinList(var12_27) or not arg0_27:InShowTime(var12_27) then
			table.remove(var0_27, iter8_27)
		end
	end

	return var0_27
end

function var0_0.GetShopShowingSkins(arg0_31)
	local var0_31 = {}

	local function var1_31(arg0_32)
		local var0_32 = arg0_32:getSkinId()
		local var1_32 = getProxy(ShipSkinProxy):getSkinById(var0_32)
		local var2_32 = var1_32 and not var1_32:isExpireType() and 1 or 0

		arg0_32:updateBuyCount(var2_32)
	end

	local function var2_31(arg0_33)
		local var0_33 = Goods.Create({
			shop_id = arg0_33
		}, Goods.TYPE_SKIN)

		var1_31(var0_33)
		table.insert(var0_31, var0_33)
	end

	for iter0_31, iter1_31 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_31(iter1_31)
	end

	for iter2_31, iter3_31 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_31(iter3_31)
	end

	local var3_31 = getProxy(ActivityProxy)
	local var4_31 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_31, iter5_31 in ipairs(var4_31) do
		local var5_31 = Goods.Create({
			shop_id = iter5_31
		}, Goods.TYPE_ACTIVITY_EXTRA)

		var1_31(var5_31)
		table.insert(var0_31, var5_31)
	end

	local var6_31 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_31, iter7_31 in ipairs(var6_31) do
		local var7_31 = Goods.Create({
			shop_id = iter7_31
		}, Goods.TYPE_ACTIVITY)

		var1_31(var7_31)

		if not _.any(var0_31, function(arg0_34)
			return arg0_34:getSkinId() == var7_31:getSkinId()
		end) then
			table.insert(var0_31, var7_31)
		end
	end

	return var0_31
end

function var0_0.GetAllSkinForShip(arg0_35, arg1_35)
	assert(isa(arg1_35, Ship), "ship should be an instance of Ship")

	local var0_35 = arg1_35.groupId
	local var1_35 = ShipGroup.getSkinList(var0_35)

	for iter0_35 = #var1_35, 1, -1 do
		local var2_35 = var1_35[iter0_35]

		if var2_35.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_35:hasSkin(var2_35.id) then
			table.remove(var1_35, iter0_35)
		elseif not arg0_35:InShowTime(var2_35.id) then
			table.remove(var1_35, iter0_35)
		end
	end

	if pg.ship_data_trans[var0_35] and not arg1_35:isRemoulded() then
		local var3_35 = ShipGroup.GetGroupConfig(var0_35).trans_skin

		for iter1_35 = #var1_35, 1, -1 do
			if var1_35[iter1_35].id == var3_35 then
				table.remove(var1_35, iter1_35)

				break
			end
		end
	end

	for iter2_35 = #var1_35, 1, -1 do
		local var4_35 = var1_35[iter2_35]

		if var4_35.show_time and (type(var4_35.show_time) == "string" and var4_35.show_time == "stop" or type(var4_35.show_time) == "table" and not pg.TimeMgr.GetInstance():inTime(var4_35.show_time)) then
			table.remove(var1_35, iter2_35)
		end

		if var4_35.no_showing == "1" then
			table.remove(var1_35, iter2_35)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_35.id].isHX == 1 then
			table.remove(var1_35, iter2_35)
		end
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var5_35 = pg.gameset.big_seven_old_skin_timestamp.key_value

		for iter3_35 = #var1_35, 1, -1 do
			if var1_35[iter3_35].skin_type == ShipSkin.SKIN_TYPE_OLD and var5_35 < arg1_35.createTime then
				table.remove(var1_35, iter3_35)
			end
		end
	end

	if #arg0_35.forbiddenSkinList > 0 then
		for iter4_35 = #var1_35, 1, -1 do
			local var6_35 = var1_35[iter4_35].id

			if not arg0_35:hasSkin(var6_35) and arg0_35:InForbiddenSkinListAndHide(var6_35) then
				table.remove(var1_35, iter4_35)
			end
		end
	end

	return var1_35
end

function var0_0.GetShareSkinsForShipGroup(arg0_36, arg1_36)
	local var0_36 = pg.ship_data_group.get_id_list_by_group_type[arg1_36][1]
	local var1_36 = pg.ship_data_group[var0_36]

	if not var1_36.share_group_id or #var1_36.share_group_id <= 0 then
		return {}
	end

	local var2_36 = {}

	for iter0_36, iter1_36 in ipairs(var1_36.share_group_id) do
		local var3_36 = pg.ship_skin_template.get_id_list_by_ship_group[iter1_36]

		for iter2_36, iter3_36 in ipairs(var3_36) do
			local var4_36 = ShipSkin.New({
				id = iter3_36
			})

			if var4_36:CanShare() then
				table.insert(var2_36, var4_36)
			end
		end
	end

	return var2_36
end

function var0_0.GetShareSkinsForShip(arg0_37, arg1_37)
	local var0_37 = arg1_37.groupId

	return arg0_37:GetShareSkinsForShipGroup(var0_37)
end

function var0_0.GetAllSkinForARCamera(arg0_38, arg1_38)
	local var0_38 = ShipGroup.getSkinList(arg1_38)

	for iter0_38 = #var0_38, 1, -1 do
		if var0_38[iter0_38].skin_type == ShipSkin.SKIN_TYPE_OLD then
			table.remove(var0_38, iter0_38)
		end
	end

	local var1_38 = ShipGroup.GetGroupConfig(arg1_38).trans_skin

	if var1_38 ~= 0 then
		local var2_38 = false
		local var3_38 = getProxy(CollectionProxy):getShipGroup(arg1_38)

		if var3_38 then
			for iter1_38, iter2_38 in ipairs(var0_38) do
				if iter2_38.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var3_38.trans then
					var2_38 = true

					break
				end
			end
		end

		if not var2_38 then
			for iter3_38 = #var0_38, 1, -1 do
				if var0_38[iter3_38].id == var1_38 then
					table.remove(var0_38, iter3_38)

					break
				end
			end
		end
	end

	for iter4_38 = #var0_38, 1, -1 do
		local var4_38 = var0_38[iter4_38]

		if var4_38.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_38:hasSkin(var4_38.id) then
			table.remove(var0_38, iter4_38)
		elseif var4_38.no_showing == "1" then
			table.remove(var0_38, iter4_38)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_38.id].isHX == 1 then
			table.remove(var0_38, iter4_38)
		elseif not arg0_38:InShowTime(var4_38.id) then
			table.remove(var0_38, iter4_38)
		end
	end

	if #arg0_38.forbiddenSkinList > 0 then
		for iter5_38 = #var0_38, 1, -1 do
			local var5_38 = var0_38[iter5_38].id

			if not arg0_38:hasSkin(var5_38) and arg0_38:InForbiddenSkinListAndHide(var5_38) then
				table.remove(var0_38, iter5_38)
			end
		end
	end

	return var0_38
end

function var0_0.InShowTime(arg0_39, arg1_39)
	local var0_39 = pg.ship_skin_template_column_time[arg1_39]

	if var0_39 and var0_39.time ~= "" and type(var0_39.time) == "table" and #var0_39.time > 0 then
		return pg.TimeMgr.GetInstance():passTime(var0_39.time)
	end

	return true
end

function var0_0.HasFashion(arg0_40, arg1_40)
	if #arg0_40:GetShareSkinsForShip(arg1_40) > 0 then
		return true
	end

	local var0_40 = arg0_40:GetAllSkinForShip(arg1_40)

	if #var0_40 == 1 then
		local var1_40 = var0_40[1]

		return (checkABExist("painting/" .. var1_40.painting .. "_n"))
	end

	return #var0_40 > 1
end

function var0_0.GetEncoreSkins(arg0_41)
	local var0_41 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	local function var1_41(arg0_42)
		local var0_42 = arg0_42:getConfig("config_client")

		if var0_42 and var0_42[1] and type(var0_42[1]) == "table" then
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_42[1]) <= pg.TimeMgr.GetInstance():GetServerTime()
		else
			return arg0_42:isEnd()
		end
	end

	for iter0_41, iter1_41 in ipairs(var0_41) do
		if iter1_41:getDataConfig("type") == 5 and not var1_41(iter1_41) then
			return iter1_41:getConfig("config_data")
		end
	end

	return {}
end

function var0_0.GetOwnSkins(arg0_43)
	local var0_43 = {}
	local var1_43 = arg0_43:getRawData()

	for iter0_43, iter1_43 in pairs(var1_43) do
		table.insert(var0_43, iter1_43)
	end

	local var2_43 = getProxy(CollectionProxy).shipGroups

	for iter2_43, iter3_43 in pairs(var2_43) do
		if iter3_43.married == 1 then
			local var3_43 = ShipGroup.getProposeSkin(iter3_43.id)

			if var3_43 then
				table.insert(var0_43, ShipSkin.New({
					id = var3_43.id
				}))
			end
		end

		if iter3_43.trans then
			local var4_43 = pg.ship_data_trans[iter3_43.id].skin_id

			table.insert(var0_43, ShipSkin.New({
				id = var4_43
			}))
		end
	end

	return var0_43
end

function var0_0.GetOwnAndShareSkins(arg0_44)
	local var0_44 = arg0_44:GetOwnSkins()
	local var1_44 = {}

	for iter0_44, iter1_44 in ipairs(var0_44) do
		var1_44[iter1_44.id] = iter1_44
	end

	local var2_44 = getProxy(CollectionProxy).shipGroups

	for iter2_44, iter3_44 in pairs(var2_44) do
		if iter3_44.married == 1 then
			local var3_44 = arg0_44:GetShareSkinsForShipGroup(iter3_44.id)

			for iter4_44, iter5_44 in ipairs(var3_44) do
				if not var1_44[iter5_44.id] then
					table.insert(var0_44, iter5_44)
				end
			end
		end
	end

	return var0_44
end

function var0_0.GetProbabilitySkins(arg0_45, arg1_45)
	local var0_45 = {}

	local function var1_45(arg0_46)
		local var0_46 = arg0_46:getSkinId()
		local var1_46 = getProxy(ShipSkinProxy):getSkinById(var0_46)
		local var2_46 = var1_46 and not var1_46:isExpireType() and 1 or 0

		arg0_46:updateBuyCount(var2_46)
	end

	local function var2_45(arg0_47)
		local var0_47 = Goods.Create({
			shop_id = arg0_47
		}, Goods.TYPE_SKIN)

		var1_45(var0_47)

		local var1_47, var2_47 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_47].time)

		if var1_47 then
			table.insert(var0_45, var0_47)
		end
	end

	local var3_45 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4_45 = {}

	for iter0_45, iter1_45 in ipairs(var3_45) do
		if iter1_45:getConfig("genre") ~= ShopArgs.SkinShopTimeLimit then
			var4_45[iter1_45:getSkinId()] = iter1_45.id
		end
	end

	for iter2_45, iter3_45 in ipairs(arg1_45) do
		local var5_45 = var4_45[iter3_45[1]]

		if var5_45 then
			var2_45(var5_45)
		end
	end

	return var0_45
end

function var0_0.GetSkinProbabilitys(arg0_48, arg1_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs(arg1_48) do
		var0_48[iter1_48[1]] = iter1_48[2]
	end

	return var0_48
end

return var0_0
