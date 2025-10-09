local var0_0 = class("ShipSkinProxy", import(".NetProxy"))

var0_0.SHIP_SKINS_UPDATE = "ship skins update"
var0_0.SHIP_SKIN_EXPIRED = "ship skin expired"
var0_0.FORBIDDEN_TYPE_HIDE = 0
var0_0.FORBIDDEN_TYPE_SHOW = 1
var0_0.FORBIDDEN_OVERWRITE_TYPE_TIME = 1
var0_0.FORBIDDEN_OVERWRITE_TYPE_STOP = 2

function var0_0.timeCall(arg0_1)
	return {
		[ProxyRegister.SecondCall] = function(arg0_2)
			local var0_2 = pg.TimeMgr.GetInstance():GetServerTime()

			for iter0_2, iter1_2 in ipairs(arg0_1.forbiddenSkinOverwriteList) do
				arg0_1:CheckConfigOverwrite(var0_2, iter0_2, iter1_2)
			end
		end
	}
end

function var0_0.register(arg0_3)
	arg0_3.skins = {}
	arg0_3.changeSkinGroupDic = {}
	arg0_3.cacheSkins = {}
	arg0_3.timers = {}
	arg0_3.forbiddenSkinList = {}
	arg0_3.forbiddenSkinOverwriteList = {}
	arg0_3.overwriteFlag = {}

	arg0_3:on(12201, function(arg0_4)
		_.each(arg0_4.skin_list, function(arg0_5)
			local var0_5 = ShipSkin.New(arg0_5)

			arg0_3:addSkin(ShipSkin.New(arg0_5))
		end)

		arg0_3.forbiddenSkinList = {}

		_.each(arg0_4.forbidden_skin_list, function(arg0_6)
			table.insert(arg0_3.forbiddenSkinList, {
				id = arg0_6,
				type = var0_0.FORBIDDEN_TYPE_HIDE
			})
		end)

		for iter0_4, iter1_4 in ipairs(arg0_4.forbidden_skin_type) do
			arg0_3.forbiddenSkinList[iter0_4].type = iter1_4
		end

		for iter2_4, iter3_4 in ipairs(arg0_3.forbiddenSkinOverwriteList) do
			arg0_3:RemoveConfigOverwrite(iter2_4)
		end

		arg0_3.forbiddenSkinOverwriteList = {}

		local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

		for iter4_4, iter5_4 in ipairs(arg0_4.forbidden_list) do
			local var1_4 = pg.shop_template[iter5_4.id]

			if not var1_4 then
				warning("without config in shop_template:" .. iter5_4.id)
			elseif var1_4.genre ~= "skin_shop" then
				warning("config genre error in shop_template:" .. iter5_4.id)
			else
				warning(iter5_4.id, iter5_4.type, pg.TimeMgr.GetInstance():STimeDescS(iter5_4.start_time), pg.TimeMgr.GetInstance():STimeDescS(iter5_4.stop_time))

				arg0_3.forbiddenSkinOverwriteList[iter5_4.id] = {
					type = iter5_4.type,
					range = {
						iter5_4.start_time,
						iter5_4.stop_time
					}
				}

				arg0_3:CheckConfigOverwrite(var0_4, iter5_4.id, arg0_3.forbiddenSkinOverwriteList[iter5_4.id])
			end
		end
	end)
end

function var0_0.CheckConfigOverwrite(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg1_7 == math.clamp(arg1_7, unpack(arg3_7.range))

	if var0_7 ~= tobool(arg0_7.overwriteFlag[arg2_7]) then
		if var0_7 then
			arg0_7:AddConfigOverwrite(arg2_7, arg3_7)
		else
			arg0_7:RemoveConfigOverwrite(arg2_7)
		end
	end
end

function var0_0.AddConfigOverwrite(arg0_8, arg1_8, arg2_8)
	if not arg0_8.overwriteFlag[arg1_8] then
		arg0_8.overwriteFlag[arg1_8] = true
		pg.shop_template[arg1_8].time = switch(arg2_8.type, {
			[var0_0.FORBIDDEN_OVERWRITE_TYPE_TIME] = function()
				local var0_9 = {}

				for iter0_9, iter1_9 in ipairs(arg2_8.range) do
					local var1_9 = underscore.map(string.split(pg.TimeMgr.GetInstance():STimeDescS(iter1_9, "%Y/%m/%d/%H/%M/%S"), "/"), function(arg0_10)
						return tonumber(arg0_10)
					end)

					var0_9[iter0_9] = {
						underscore.first(var1_9, 3),
						underscore.rest(var1_9, 4)
					}
				end

				return var0_9
			end,
			[var0_0.FORBIDDEN_OVERWRITE_TYPE_STOP] = function()
				return "stop"
			end
		})
	end
end

function var0_0.RemoveConfigOverwrite(arg0_12, arg1_12)
	if arg0_12.overwriteFlag[arg1_12] then
		arg0_12.overwriteFlag[arg1_12] = nil
		pg.shop_template[arg1_12].time = nil
	end
end

function var0_0.getOverDueSkins(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.cacheSkins) do
		table.insert(var0_13, iter1_13)
	end

	arg0_13.cacheSkins = {}

	return var0_13
end

function var0_0.getRawData(arg0_14)
	return arg0_14.skins
end

function var0_0.getSkinList(arg0_15)
	return _.map(_.values(arg0_15.skins), function(arg0_16)
		return arg0_16.id
	end)
end

function var0_0.addSkin(arg0_17, arg1_17)
	assert(isa(arg1_17, ShipSkin), "skin should be an instance of ShipSkin")

	if arg0_17.prevNewSkin then
		arg0_17.prevNewSkin:SetIsNew(false)
	end

	arg0_17.skins[arg1_17.id] = arg1_17

	if ShipSkin.IsChangeSkin(arg1_17.id) then
		arg0_17.changeSkinGroupDic[ShipSkin.GetChangeSkinGroupId(arg1_17.id)] = true
	end

	arg0_17.prevNewSkin = arg1_17

	arg0_17:addExpireTimer(arg1_17)

	if arg1_17:getConfig("skin_type") == ShipSkin.SKIN_TYPE_TB then
		NewEducateHelper.UpdateUnlockBySkinId(arg1_17.id)
	end

	arg0_17.facade:sendNotification(var0_0.SHIP_SKINS_UPDATE)
end

function var0_0.getSkinById(arg0_18, arg1_18)
	return arg0_18.skins[arg1_18]
end

function var0_0.addExpireTimer(arg0_19, arg1_19)
	arg0_19:removeExpireTimer(arg1_19.id)

	if not arg1_19:isExpireType() then
		return
	end

	local function var0_19()
		table.insert(arg0_19.cacheSkins, arg1_19)
		arg0_19:removeSkinById(arg1_19.id)

		local var0_20 = getProxy(BayProxy)
		local var1_20 = {}

		underscore.each(var0_20:CanUseShareSkinPhantoms(arg1_19.id), function(arg0_21)
			if arg0_21:getSkinId() == arg1_19.id then
				var0_20:updateShipSkin(arg0_21.id, arg0_21.phantomId, arg0_21:getConfig("skin_id"))
			end
		end)
		arg0_19:sendNotification(GAME.SHIP_SKIN_EXPIRED)
	end

	local var1_19 = arg1_19:getExpireTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var1_19 <= 0 then
		var0_19()
	else
		arg0_19.timers[arg1_19.id] = Timer.New(var0_19, var1_19, 1)

		arg0_19.timers[arg1_19.id]:Start()
	end
end

function var0_0.removeExpireTimer(arg0_22, arg1_22)
	if arg0_22.timers[arg1_22] then
		arg0_22.timers[arg1_22]:Stop()

		arg0_22.timers[arg1_22] = nil
	end
end

function var0_0.removeSkinById(arg0_23, arg1_23)
	arg0_23.skins[arg1_23] = nil

	arg0_23:removeExpireTimer(arg1_23)
	arg0_23.facade:sendNotification(var0_0.SHIP_SKINS_UPDATE)
end

function var0_0.hasSkin(arg0_24, arg1_24)
	if ShipSkin.IsChangeSkin(arg1_24) then
		local var0_24 = ShipSkin.GetChangeSkinGroupId(arg1_24)

		return arg0_24.changeSkinGroupDic[var0_24]
	end

	return arg0_24.skins[arg1_24] ~= nil
end

function var0_0.hasNonLimitSkin(arg0_25, arg1_25)
	local var0_25 = arg0_25.skins[arg1_25]

	return var0_25 ~= nil and not var0_25:isExpireType()
end

function var0_0.hasOldNonLimitSkin(arg0_26, arg1_26)
	local var0_26 = arg0_26.skins[arg1_26]

	return var0_26 and not var0_26:HasNewFlag() and not var0_26:isExpireType()
end

function var0_0.getSkinCountById(arg0_27, arg1_27)
	return arg0_27:hasSkin(arg1_27) and 1 or 0
end

function var0_0.InForbiddenSkinListAndHide(arg0_28, arg1_28)
	return _.any(arg0_28.forbiddenSkinList, function(arg0_29)
		return arg0_29.id == arg1_28 and arg0_29.type == var0_0.FORBIDDEN_TYPE_HIDE
	end)
end

function var0_0.InForbiddenSkinListAndShow(arg0_30, arg1_30)
	return _.any(arg0_30.forbiddenSkinList, function(arg0_31)
		return arg0_31.id == arg1_30 and arg0_31.type == var0_0.FORBIDDEN_TYPE_SHOW
	end)
end

function var0_0.InForbiddenSkinList(arg0_32, arg1_32)
	return _.any(arg0_32.forbiddenSkinList, function(arg0_33)
		return arg0_33.id == arg1_32
	end)
end

function var0_0.remove(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34.timers) do
		iter1_34:Stop()
	end

	arg0_34.timers = nil
end

function var0_0.GetAllSkins(arg0_35)
	local var0_35 = {}

	local function var1_35(arg0_36)
		local var0_36 = arg0_36:getSkinId()
		local var1_36 = getProxy(ShipSkinProxy):getSkinById(var0_36)
		local var2_36 = var1_36 and not var1_36:isExpireType() and 1 or 0

		arg0_36:updateBuyCount(var2_36)
	end

	local function var2_35(arg0_37)
		local var0_37 = Goods.Create({
			shop_id = arg0_37
		}, Goods.TYPE_SKIN)

		var1_35(var0_37)

		local var1_37 = pg.shop_template[arg0_37].collaboration_skin_time
		local var2_37 = var1_37 == "" or var1_37 == pg.shop_template[arg0_37].time
		local var3_37, var4_37 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_37].time)

		if var2_37 and var3_37 then
			table.insert(var0_35, var0_37)
		end
	end

	for iter0_35, iter1_35 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_35(iter1_35)
	end

	for iter2_35, iter3_35 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_35(iter3_35)
	end

	local var3_35 = getProxy(ActivityProxy)
	local var4_35 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_35, iter5_35 in ipairs(var4_35) do
		local var5_35 = pg.activity_shop_extra[iter5_35]
		local var6_35 = var3_35:getActivityById(var5_35.activity)

		if var5_35.activity == 0 and pg.TimeMgr.GetInstance():inTime(var5_35.time) or var6_35 and not var6_35:isEnd() then
			local var7_35 = Goods.Create({
				shop_id = iter5_35
			}, Goods.TYPE_ACTIVITY_EXTRA)

			var1_35(var7_35)
			table.insert(var0_35, var7_35)
		end
	end

	local var8_35 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_35, iter7_35 in ipairs(var8_35) do
		local var9_35 = pg.activity_shop_template[iter7_35]
		local var10_35 = var3_35:getActivityById(var9_35.activity)

		if var10_35 and not var10_35:isEnd() then
			local var11_35 = Goods.Create({
				shop_id = iter7_35
			}, Goods.TYPE_ACTIVITY)

			var1_35(var11_35)

			if not _.any(var0_35, function(arg0_38)
				return arg0_38:getSkinId() == var11_35:getSkinId()
			end) then
				table.insert(var0_35, var11_35)
			end
		end
	end

	for iter8_35 = #var0_35, 1, -1 do
		local var12_35 = var0_35[iter8_35]:getSkinId()

		if arg0_35:InForbiddenSkinList(var12_35) or not arg0_35:InShowTime(var12_35) then
			table.remove(var0_35, iter8_35)
		end
	end

	return var0_35
end

function var0_0.GetShopShowingSkins(arg0_39)
	local var0_39 = {}

	local function var1_39(arg0_40)
		local var0_40 = arg0_40:getSkinId()
		local var1_40 = getProxy(ShipSkinProxy):getSkinById(var0_40)
		local var2_40 = var1_40 and not var1_40:isExpireType() and 1 or 0

		arg0_40:updateBuyCount(var2_40)
	end

	local function var2_39(arg0_41)
		local var0_41 = Goods.Create({
			shop_id = arg0_41
		}, Goods.TYPE_SKIN)

		var1_39(var0_41)
		table.insert(var0_39, var0_41)
	end

	for iter0_39, iter1_39 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_39(iter1_39)
	end

	for iter2_39, iter3_39 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_39(iter3_39)
	end

	local var3_39 = getProxy(ActivityProxy)
	local var4_39 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_39, iter5_39 in ipairs(var4_39) do
		local var5_39 = Goods.Create({
			shop_id = iter5_39
		}, Goods.TYPE_ACTIVITY_EXTRA)

		var1_39(var5_39)
		table.insert(var0_39, var5_39)
	end

	local var6_39 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_39, iter7_39 in ipairs(var6_39) do
		local var7_39 = Goods.Create({
			shop_id = iter7_39
		}, Goods.TYPE_ACTIVITY)

		var1_39(var7_39)

		if not _.any(var0_39, function(arg0_42)
			return arg0_42:getSkinId() == var7_39:getSkinId()
		end) then
			table.insert(var0_39, var7_39)
		end
	end

	return var0_39
end

function var0_0.GetAllSkinForShip(arg0_43, arg1_43)
	assert(isa(arg1_43, Ship), "ship should be an instance of Ship")

	local var0_43 = arg1_43.groupId
	local var1_43 = ShipGroup.getSkinList(var0_43)

	for iter0_43 = #var1_43, 1, -1 do
		local var2_43 = var1_43[iter0_43]

		if var2_43.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_43:hasSkin(var2_43.id) then
			table.remove(var1_43, iter0_43)
		elseif not arg0_43:InShowTime(var2_43.id) then
			table.remove(var1_43, iter0_43)
		end
	end

	if pg.ship_data_trans[var0_43] and not arg1_43:isRemoulded() then
		local var3_43 = ShipGroup.GetGroupConfig(var0_43).trans_skin

		for iter1_43 = #var1_43, 1, -1 do
			if var1_43[iter1_43].id == var3_43 then
				table.remove(var1_43, iter1_43)

				break
			end
		end
	end

	for iter2_43 = #var1_43, 1, -1 do
		local var4_43 = var1_43[iter2_43]

		if var4_43.show_time and (type(var4_43.show_time) == "string" and var4_43.show_time == "stop" or type(var4_43.show_time) == "table" and not pg.TimeMgr.GetInstance():inTime(var4_43.show_time)) then
			table.remove(var1_43, iter2_43)
		end

		if var4_43.no_showing == "1" then
			table.remove(var1_43, iter2_43)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_43.id].isHX == 1 then
			table.remove(var1_43, iter2_43)
		end
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var5_43 = pg.gameset.big_seven_old_skin_timestamp.key_value

		for iter3_43 = #var1_43, 1, -1 do
			if var1_43[iter3_43].skin_type == ShipSkin.SKIN_TYPE_OLD and var5_43 < arg1_43.createTime then
				table.remove(var1_43, iter3_43)
			end
		end
	end

	if #arg0_43.forbiddenSkinList > 0 then
		for iter4_43 = #var1_43, 1, -1 do
			local var6_43 = var1_43[iter4_43].id

			if not arg0_43:hasSkin(var6_43) and arg0_43:InForbiddenSkinListAndHide(var6_43) then
				table.remove(var1_43, iter4_43)
			end
		end
	end

	for iter5_43 = #var1_43, 1, -1 do
		local var7_43 = var1_43[iter5_43]
		local var8_43 = ShipSkin.GetChangeSkinGroupId(var7_43.id)

		if var8_43 then
			local var9_43 = ShipSkin.GetStoreChangeSkinId(var8_43, arg1_43:GetShipPhantomMark())

			if not var9_43 then
				if var7_43.change_skin.index ~= 1 then
					print("没有缓存的id ，" .. "移除了id" .. var7_43.id)
					table.remove(var1_43, iter5_43)
				end
			elseif var9_43 ~= var7_43.id then
				print("有缓存的id = " .. var9_43 .. "移除了id" .. var7_43.id)
				table.remove(var1_43, iter5_43)
			end
		end
	end

	return var1_43
end

function var0_0.GetShareSkinsForShipGroup(arg0_44, arg1_44)
	local var0_44 = pg.ship_data_group.get_id_list_by_group_type[arg1_44][1]
	local var1_44 = pg.ship_data_group[var0_44]

	if not var1_44.share_group_id or #var1_44.share_group_id <= 0 then
		return {}
	end

	local var2_44 = {}

	for iter0_44, iter1_44 in ipairs(var1_44.share_group_id) do
		local var3_44 = pg.ship_skin_template.get_id_list_by_ship_group[iter1_44]

		for iter2_44, iter3_44 in ipairs(var3_44) do
			local var4_44 = ShipSkin.New({
				id = iter3_44
			})

			if var4_44:CanShare() then
				table.insert(var2_44, var4_44)
			end
		end
	end

	return var2_44
end

function var0_0.GetShareSkinsForShip(arg0_45, arg1_45)
	local var0_45 = arg1_45.groupId

	return arg0_45:GetShareSkinsForShipGroup(var0_45)
end

function var0_0.GetAllSkinForARCamera(arg0_46, arg1_46)
	local var0_46 = ShipGroup.getSkinList(arg1_46)

	for iter0_46 = #var0_46, 1, -1 do
		if var0_46[iter0_46].skin_type == ShipSkin.SKIN_TYPE_OLD then
			table.remove(var0_46, iter0_46)
		end
	end

	local var1_46 = ShipGroup.GetGroupConfig(arg1_46).trans_skin

	if var1_46 ~= 0 then
		local var2_46 = false
		local var3_46 = getProxy(CollectionProxy):getShipGroup(arg1_46)

		if var3_46 then
			for iter1_46, iter2_46 in ipairs(var0_46) do
				if iter2_46.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var3_46.trans then
					var2_46 = true

					break
				end
			end
		end

		if not var2_46 then
			for iter3_46 = #var0_46, 1, -1 do
				if var0_46[iter3_46].id == var1_46 then
					table.remove(var0_46, iter3_46)

					break
				end
			end
		end
	end

	for iter4_46 = #var0_46, 1, -1 do
		local var4_46 = var0_46[iter4_46]

		if var4_46.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_46:hasSkin(var4_46.id) then
			table.remove(var0_46, iter4_46)
		elseif var4_46.no_showing == "1" then
			table.remove(var0_46, iter4_46)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_46.id].isHX == 1 then
			table.remove(var0_46, iter4_46)
		elseif not arg0_46:InShowTime(var4_46.id) then
			table.remove(var0_46, iter4_46)
		end
	end

	if #arg0_46.forbiddenSkinList > 0 then
		for iter5_46 = #var0_46, 1, -1 do
			local var5_46 = var0_46[iter5_46].id

			if not arg0_46:hasSkin(var5_46) and arg0_46:InForbiddenSkinListAndHide(var5_46) then
				table.remove(var0_46, iter5_46)
			end
		end
	end

	for iter6_46 = #var0_46, 1, -1 do
		local var6_46 = var0_46[iter6_46]

		if var6_46 and var6_46.change_skin and var6_46.change_skin.index and var6_46.change_skin.index ~= 1 then
			table.remove(var0_46, iter6_46)
		end
	end

	return var0_46
end

function var0_0.InShowTime(arg0_47, arg1_47)
	local var0_47 = pg.ship_skin_template_column_time[arg1_47]

	if var0_47 and var0_47.time ~= "" and type(var0_47.time) == "table" and #var0_47.time > 0 then
		return pg.TimeMgr.GetInstance():passTime(var0_47.time)
	end

	return true
end

function var0_0.HasFashion(arg0_48, arg1_48)
	if #arg0_48:GetShareSkinsForShip(arg1_48) > 0 then
		return true
	end

	local var0_48 = arg0_48:GetAllSkinForShip(arg1_48)

	if #var0_48 == 1 then
		local var1_48 = var0_48[1]

		return (checkABExist("painting/" .. var1_48.painting .. "_n"))
	end

	return #var0_48 > 1
end

function var0_0.GetEncoreSkins(arg0_49)
	local var0_49 = {}
	local var1_49 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	local function var2_49(arg0_50)
		local var0_50 = arg0_50:getConfig("config_client")

		if var0_50 and var0_50[1] and type(var0_50[1]) == "table" then
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_50[1]) <= pg.TimeMgr.GetInstance():GetServerTime()
		else
			return arg0_50:isEnd()
		end
	end

	for iter0_49, iter1_49 in ipairs(var1_49) do
		if iter1_49:getDataConfig("type") == 5 and not var2_49(iter1_49) then
			for iter2_49, iter3_49 in ipairs(iter1_49:getConfig("config_data")) do
				table.insert(var0_49, iter3_49)
			end
		end
	end

	local var3_49 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING)

	for iter4_49, iter5_49 in ipairs(var3_49) do
		if iter5_49 and not iter5_49:isEnd() then
			for iter6_49, iter7_49 in ipairs(iter5_49:getConfig("config_data")[2]) do
				if not table.contains(var0_49, iter7_49) then
					table.insert(var0_49, iter7_49)
				end
			end
		end
	end

	return var0_49
end

function var0_0.GetOwnSkins(arg0_51)
	local var0_51 = {}
	local var1_51 = arg0_51:getRawData()

	for iter0_51, iter1_51 in pairs(var1_51) do
		table.insert(var0_51, iter1_51)
	end

	local var2_51 = getProxy(CollectionProxy).shipGroups

	for iter2_51, iter3_51 in pairs(var2_51) do
		if iter3_51.married == 1 then
			local var3_51 = ShipGroup.getProposeSkin(iter3_51.id)

			if var3_51 then
				table.insert(var0_51, ShipSkin.New({
					id = var3_51.id
				}))
			end
		end

		if iter3_51.trans then
			local var4_51 = pg.ship_data_trans[iter3_51.id].skin_id

			table.insert(var0_51, ShipSkin.New({
				id = var4_51
			}))
		end
	end

	return var0_51
end

function var0_0.GetOwnAndShareSkins(arg0_52)
	local var0_52 = arg0_52:GetOwnSkins()
	local var1_52 = {}

	for iter0_52, iter1_52 in ipairs(var0_52) do
		var1_52[iter1_52.id] = iter1_52
	end

	local var2_52 = getProxy(CollectionProxy).shipGroups

	for iter2_52, iter3_52 in pairs(var2_52) do
		if iter3_52.married == 1 then
			local var3_52 = arg0_52:GetShareSkinsForShipGroup(iter3_52.id)

			for iter4_52, iter5_52 in ipairs(var3_52) do
				if not var1_52[iter5_52.id] then
					table.insert(var0_52, iter5_52)
				end
			end
		end
	end

	return var0_52
end

function var0_0.GetProbabilitySkins(arg0_53, arg1_53)
	local var0_53 = {}

	local function var1_53(arg0_54)
		local var0_54 = arg0_54:getSkinId()
		local var1_54 = getProxy(ShipSkinProxy):getSkinById(var0_54)
		local var2_54 = var1_54 and not var1_54:isExpireType() and 1 or 0

		arg0_54:updateBuyCount(var2_54)
	end

	local function var2_53(arg0_55)
		local var0_55 = Goods.Create({
			shop_id = arg0_55
		}, Goods.TYPE_SKIN)

		var1_53(var0_55)

		local var1_55, var2_55 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_55].time)

		if var1_55 then
			table.insert(var0_53, var0_55)
		end
	end

	local var3_53 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4_53 = {}

	for iter0_53, iter1_53 in ipairs(var3_53) do
		if iter1_53:getConfig("genre") ~= ShopArgs.SkinShopTimeLimit then
			var4_53[iter1_53:getSkinId()] = iter1_53.id
		end
	end

	for iter2_53, iter3_53 in ipairs(arg1_53) do
		local var5_53 = var4_53[iter3_53[1]]

		if var5_53 then
			var2_53(var5_53)
		end
	end

	return var0_53
end

function var0_0.GetSkinProbabilitys(arg0_56, arg1_56)
	local var0_56 = {}

	for iter0_56, iter1_56 in ipairs(arg1_56) do
		var0_56[iter1_56[1]] = iter1_56[2]
	end

	return var0_56
end

function var0_0.GetInTimeSkins(arg0_57)
	local var0_57 = arg0_57:GetAllSkins()

	for iter0_57 = #var0_57, 1, -1 do
		local var1_57 = var0_57[iter0_57]

		if var1_57.type == Goods.TYPE_SKIN then
			if var1_57:getConfig("time") == "always" then
				table.remove(var0_57, iter0_57)
			end
		elseif var1_57.type == Goods.TYPE_ACTIVITY_EXTRA and pg.activity_shop_extra[var1_57.id].shop_tag ~= 1 then
			table.remove(var0_57, iter0_57)
		end
	end

	return var0_57
end

function var0_0.GetPermanentSkins(arg0_58)
	local var0_58 = arg0_58:GetAllSkins()

	for iter0_58 = #var0_58, 1, -1 do
		local var1_58 = var0_58[iter0_58]

		if var1_58.type == Goods.TYPE_SKIN then
			if var1_58:getConfig("time") ~= "always" then
				table.remove(var0_58, iter0_58)
			end
		elseif var1_58.type == Goods.TYPE_ACTIVITY_EXTRA then
			if pg.activity_shop_extra[var1_58.id].shop_tag ~= 2 then
				table.remove(var0_58, iter0_58)
			end
		elseif var1_58.type == Goods.TYPE_ACTIVITY then
			table.remove(var0_58, iter0_58)
		end
	end

	return var0_58
end

return var0_0
