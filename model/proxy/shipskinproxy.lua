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
					},
					order = iter5_4.sort_order
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

		if arg2_8.order >= 0 then
			pg.shop_template[arg1_8].order = arg2_8.order
		end
	end
end

function var0_0.RemoveConfigOverwrite(arg0_12, arg1_12)
	if arg0_12.overwriteFlag[arg1_12] then
		arg0_12.overwriteFlag[arg1_12] = nil
		pg.shop_template[arg1_12].time = nil
		pg.shop_template[arg1_12].order = nil
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

	arg0_17.skins[arg1_17.id] = arg1_17

	if ShipSkin.IsChangeSkin(arg1_17.id) then
		arg0_17.changeSkinGroupDic[ShipSkin.GetChangeSkinGroupId(arg1_17.id)] = true
	end

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

function var0_0.getSkinCountById(arg0_26, arg1_26)
	return arg0_26:hasSkin(arg1_26) and 1 or 0
end

function var0_0.InForbiddenSkinListAndHide(arg0_27, arg1_27)
	return _.any(arg0_27.forbiddenSkinList, function(arg0_28)
		return arg0_28.id == arg1_27 and arg0_28.type == var0_0.FORBIDDEN_TYPE_HIDE
	end)
end

function var0_0.InForbiddenSkinListAndShow(arg0_29, arg1_29)
	return _.any(arg0_29.forbiddenSkinList, function(arg0_30)
		return arg0_30.id == arg1_29 and arg0_30.type == var0_0.FORBIDDEN_TYPE_SHOW
	end)
end

function var0_0.InForbiddenSkinList(arg0_31, arg1_31)
	return _.any(arg0_31.forbiddenSkinList, function(arg0_32)
		return arg0_32.id == arg1_31
	end)
end

function var0_0.remove(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.timers) do
		iter1_33:Stop()
	end

	arg0_33.timers = nil
end

function var0_0.GetAllSkins(arg0_34)
	local var0_34 = {}

	local function var1_34(arg0_35)
		local var0_35 = arg0_35:getSkinId()
		local var1_35 = getProxy(ShipSkinProxy):getSkinById(var0_35)
		local var2_35 = var1_35 and not var1_35:isExpireType() and 1 or 0

		arg0_35:updateBuyCount(var2_35)
	end

	local function var2_34(arg0_36)
		local var0_36 = Goods.Create({
			shop_id = arg0_36
		}, Goods.TYPE_SKIN)

		var1_34(var0_36)

		local var1_36 = pg.shop_template[arg0_36].collaboration_skin_time
		local var2_36 = var1_36 == "" or var1_36 == pg.shop_template[arg0_36].time
		local var3_36, var4_36 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_36].time)

		if var2_36 and var3_36 then
			table.insert(var0_34, var0_36)
		end
	end

	for iter0_34, iter1_34 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_34(iter1_34)
	end

	for iter2_34, iter3_34 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_34(iter3_34)
	end

	local var3_34 = getProxy(ActivityProxy)
	local var4_34 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_34, iter5_34 in ipairs(var4_34) do
		local var5_34 = pg.activity_shop_extra[iter5_34]
		local var6_34 = var3_34:getActivityById(var5_34.activity)

		if var5_34.activity == 0 and pg.TimeMgr.GetInstance():inTime(var5_34.time) or var6_34 and not var6_34:isEnd() then
			local var7_34 = Goods.Create({
				shop_id = iter5_34
			}, Goods.TYPE_ACTIVITY_EXTRA)

			var1_34(var7_34)
			table.insert(var0_34, var7_34)
		end
	end

	local var8_34 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_34, iter7_34 in ipairs(var8_34) do
		local var9_34 = pg.activity_shop_template[iter7_34]
		local var10_34 = var3_34:getActivityById(var9_34.activity)

		if var10_34 and not var10_34:isEnd() then
			local var11_34 = Goods.Create({
				shop_id = iter7_34
			}, Goods.TYPE_ACTIVITY)

			var1_34(var11_34)

			if not _.any(var0_34, function(arg0_37)
				return arg0_37:getSkinId() == var11_34:getSkinId()
			end) then
				table.insert(var0_34, var11_34)
			end
		end
	end

	for iter8_34 = #var0_34, 1, -1 do
		local var12_34 = var0_34[iter8_34]:getSkinId()

		if arg0_34:InForbiddenSkinList(var12_34) or not arg0_34:InShowTime(var12_34) then
			table.remove(var0_34, iter8_34)
		end
	end

	return var0_34
end

function var0_0.GetShopShowingSkins(arg0_38)
	local var0_38 = {}

	local function var1_38(arg0_39)
		local var0_39 = arg0_39:getSkinId()
		local var1_39 = getProxy(ShipSkinProxy):getSkinById(var0_39)
		local var2_39 = var1_39 and not var1_39:isExpireType() and 1 or 0

		arg0_39:updateBuyCount(var2_39)
	end

	local function var2_38(arg0_40)
		local var0_40 = Goods.Create({
			shop_id = arg0_40
		}, Goods.TYPE_SKIN)

		var1_38(var0_40)
		table.insert(var0_38, var0_40)
	end

	for iter0_38, iter1_38 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShop]) do
		var2_38(iter1_38)
	end

	for iter2_38, iter3_38 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.SkinShopTimeLimit]) do
		var2_38(iter3_38)
	end

	local var3_38 = getProxy(ActivityProxy)
	local var4_38 = pg.activity_shop_extra.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter4_38, iter5_38 in ipairs(var4_38) do
		local var5_38 = Goods.Create({
			shop_id = iter5_38
		}, Goods.TYPE_ACTIVITY_EXTRA)

		var1_38(var5_38)
		table.insert(var0_38, var5_38)
	end

	local var6_38 = pg.activity_shop_template.get_id_list_by_commodity_type[DROP_TYPE_SKIN]

	for iter6_38, iter7_38 in ipairs(var6_38) do
		local var7_38 = Goods.Create({
			shop_id = iter7_38
		}, Goods.TYPE_ACTIVITY)

		var1_38(var7_38)

		if not _.any(var0_38, function(arg0_41)
			return arg0_41:getSkinId() == var7_38:getSkinId()
		end) then
			table.insert(var0_38, var7_38)
		end
	end

	return var0_38
end

function var0_0.GetAllSkinForShip(arg0_42, arg1_42)
	assert(isa(arg1_42, Ship), "ship should be an instance of Ship")

	local var0_42 = arg1_42.groupId
	local var1_42 = ShipGroup.getSkinList(var0_42)

	for iter0_42 = #var1_42, 1, -1 do
		local var2_42 = var1_42[iter0_42]

		if var2_42.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_42:hasSkin(var2_42.id) then
			table.remove(var1_42, iter0_42)
		elseif not arg0_42:InShowTime(var2_42.id) then
			table.remove(var1_42, iter0_42)
		end
	end

	if pg.ship_data_trans[var0_42] and not arg1_42:isRemoulded() then
		local var3_42 = ShipGroup.GetGroupConfig(var0_42).trans_skin

		for iter1_42 = #var1_42, 1, -1 do
			if var1_42[iter1_42].id == var3_42 then
				table.remove(var1_42, iter1_42)

				break
			end
		end
	end

	for iter2_42 = #var1_42, 1, -1 do
		local var4_42 = var1_42[iter2_42]

		if var4_42.show_time and (type(var4_42.show_time) == "string" and var4_42.show_time == "stop" or type(var4_42.show_time) == "table" and not pg.TimeMgr.GetInstance():inTime(var4_42.show_time)) then
			table.remove(var1_42, iter2_42)
		end

		if var4_42.no_showing == "1" then
			table.remove(var1_42, iter2_42)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_42.id].isHX == 1 then
			table.remove(var1_42, iter2_42)
		end
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var5_42 = pg.gameset.big_seven_old_skin_timestamp.key_value

		for iter3_42 = #var1_42, 1, -1 do
			if var1_42[iter3_42].skin_type == ShipSkin.SKIN_TYPE_OLD and var5_42 < arg1_42.createTime then
				table.remove(var1_42, iter3_42)
			end
		end
	end

	if #arg0_42.forbiddenSkinList > 0 then
		for iter4_42 = #var1_42, 1, -1 do
			local var6_42 = var1_42[iter4_42].id

			if not arg0_42:hasSkin(var6_42) and arg0_42:InForbiddenSkinListAndHide(var6_42) then
				table.remove(var1_42, iter4_42)
			end
		end
	end

	for iter5_42 = #var1_42, 1, -1 do
		local var7_42 = var1_42[iter5_42]
		local var8_42 = ShipSkin.GetChangeSkinGroupId(var7_42.id)

		if var8_42 then
			local var9_42 = ShipSkin.GetStoreChangeSkinId(var8_42, arg1_42:GetShipPhantomMark())

			if not var9_42 then
				if var7_42.change_skin.index ~= 1 then
					print("没有缓存的id ，" .. "移除了id" .. var7_42.id)
					table.remove(var1_42, iter5_42)
				end
			elseif var9_42 ~= var7_42.id then
				print("有缓存的id = " .. var9_42 .. "移除了id" .. var7_42.id)
				table.remove(var1_42, iter5_42)
			end
		end
	end

	return var1_42
end

function var0_0.GetShareSkinsForShipGroup(arg0_43, arg1_43)
	local var0_43 = pg.ship_data_group.get_id_list_by_group_type[arg1_43][1]
	local var1_43 = pg.ship_data_group[var0_43]

	if not var1_43.share_group_id or #var1_43.share_group_id <= 0 then
		return {}
	end

	local var2_43 = {}

	for iter0_43, iter1_43 in ipairs(var1_43.share_group_id) do
		local var3_43 = pg.ship_skin_template.get_id_list_by_ship_group[iter1_43]

		for iter2_43, iter3_43 in ipairs(var3_43) do
			local var4_43 = ShipSkin.New({
				id = iter3_43
			})

			if var4_43:CanShare() then
				table.insert(var2_43, var4_43)
			end
		end
	end

	return var2_43
end

function var0_0.GetShareSkinsForShip(arg0_44, arg1_44)
	local var0_44 = arg1_44.groupId
	local var1_44 = arg0_44:GetShareSkinsForShipGroup(var0_44)

	for iter0_44 = #var1_44, 1, -1 do
		local var2_44 = var1_44[iter0_44]
		local var3_44 = ShipSkin.GetChangeSkinGroupId(var2_44.id)

		if var3_44 then
			local var4_44 = ShipSkin.GetStoreChangeSkinId(var3_44, arg1_44:GetShipPhantomMark())
			local var5_44 = var2_44:getConfig("change_skin")

			if not var4_44 then
				if var5_44 and var5_44 ~= "" and var5_44.index ~= 1 then
					table.remove(var1_44, iter0_44)
				end
			elseif not arg0_44:hasSkin(var2_44.id) then
				if var5_44 and var5_44 ~= "" and var5_44.index ~= 1 then
					table.remove(var1_44, iter0_44)
				end
			elseif var4_44 ~= var2_44.id then
				table.remove(var1_44, iter0_44)
			end
		end
	end

	return var1_44
end

function var0_0.GetAllSkinForARCamera(arg0_45, arg1_45)
	local var0_45 = ShipGroup.getSkinList(arg1_45)

	for iter0_45 = #var0_45, 1, -1 do
		if var0_45[iter0_45].skin_type == ShipSkin.SKIN_TYPE_OLD then
			table.remove(var0_45, iter0_45)
		end
	end

	local var1_45 = ShipGroup.GetGroupConfig(arg1_45).trans_skin

	if var1_45 ~= 0 then
		local var2_45 = false
		local var3_45 = getProxy(CollectionProxy):getShipGroup(arg1_45)

		if var3_45 then
			for iter1_45, iter2_45 in ipairs(var0_45) do
				if iter2_45.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var3_45.trans then
					var2_45 = true

					break
				end
			end
		end

		if not var2_45 then
			for iter3_45 = #var0_45, 1, -1 do
				if var0_45[iter3_45].id == var1_45 then
					table.remove(var0_45, iter3_45)

					break
				end
			end
		end
	end

	for iter4_45 = #var0_45, 1, -1 do
		local var4_45 = var0_45[iter4_45]

		if var4_45.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not arg0_45:hasSkin(var4_45.id) then
			table.remove(var0_45, iter4_45)
		elseif var4_45.no_showing == "1" then
			table.remove(var0_45, iter4_45)
		elseif PLATFORM == PLATFORM_KR and pg.ship_skin_template[var4_45.id].isHX == 1 then
			table.remove(var0_45, iter4_45)
		elseif not arg0_45:InShowTime(var4_45.id) then
			table.remove(var0_45, iter4_45)
		end
	end

	if #arg0_45.forbiddenSkinList > 0 then
		for iter5_45 = #var0_45, 1, -1 do
			local var5_45 = var0_45[iter5_45].id

			if not arg0_45:hasSkin(var5_45) and arg0_45:InForbiddenSkinListAndHide(var5_45) then
				table.remove(var0_45, iter5_45)
			end
		end
	end

	for iter6_45 = #var0_45, 1, -1 do
		local var6_45 = var0_45[iter6_45]

		if var6_45 and var6_45.change_skin and var6_45.change_skin.index and var6_45.change_skin.index ~= 1 then
			table.remove(var0_45, iter6_45)
		end
	end

	return var0_45
end

function var0_0.InShowTime(arg0_46, arg1_46)
	local var0_46 = pg.ship_skin_template_column_time[arg1_46]

	if var0_46 and var0_46.time ~= "" and type(var0_46.time) == "table" and #var0_46.time > 0 then
		return pg.TimeMgr.GetInstance():passTime(var0_46.time)
	end

	return true
end

function var0_0.HasFashion(arg0_47, arg1_47)
	if #arg0_47:GetShareSkinsForShip(arg1_47) > 0 then
		return true
	end

	local var0_47 = arg0_47:GetAllSkinForShip(arg1_47)

	if #var0_47 == 1 then
		local var1_47 = var0_47[1]

		return (checkABExist("painting/" .. var1_47.painting .. "_n"))
	end

	return #var0_47 > 1
end

function var0_0.GetEncoreSkins(arg0_48)
	local var0_48 = {}
	local var1_48 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	local function var2_48(arg0_49)
		local var0_49 = arg0_49:getConfig("config_client")

		if var0_49 and var0_49[1] and type(var0_49[1]) == "table" then
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_49[1]) <= pg.TimeMgr.GetInstance():GetServerTime()
		else
			return arg0_49:isEnd()
		end
	end

	for iter0_48, iter1_48 in ipairs(var1_48) do
		if iter1_48:getDataConfig("type") == 5 and not var2_48(iter1_48) then
			for iter2_48, iter3_48 in ipairs(iter1_48:getConfig("config_data")) do
				table.insert(var0_48, iter3_48)
			end
		end
	end

	local var3_48 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON_COUNTING)

	for iter4_48, iter5_48 in ipairs(var3_48) do
		if iter5_48 and not iter5_48:isEnd() then
			for iter6_48, iter7_48 in ipairs(iter5_48:getConfig("config_data")[2]) do
				if not table.contains(var0_48, iter7_48) then
					table.insert(var0_48, iter7_48)
				end
			end
		end
	end

	return var0_48
end

function var0_0.GetOwnSkins(arg0_50)
	local var0_50 = {}
	local var1_50 = arg0_50:getRawData()

	for iter0_50, iter1_50 in pairs(var1_50) do
		table.insert(var0_50, iter1_50)
	end

	local var2_50 = getProxy(CollectionProxy).shipGroups

	for iter2_50, iter3_50 in pairs(var2_50) do
		if iter3_50.married == 1 then
			local var3_50 = ShipGroup.getProposeSkin(iter3_50.id)

			if var3_50 then
				table.insert(var0_50, ShipSkin.New({
					id = var3_50.id
				}))
			end
		end

		if iter3_50.trans then
			local var4_50 = pg.ship_data_trans[iter3_50.id].skin_id

			table.insert(var0_50, ShipSkin.New({
				id = var4_50
			}))
		end
	end

	return var0_50
end

function var0_0.GetOwnAndShareSkins(arg0_51)
	local var0_51 = arg0_51:GetOwnSkins()
	local var1_51 = {}

	for iter0_51, iter1_51 in ipairs(var0_51) do
		var1_51[iter1_51.id] = iter1_51
	end

	local var2_51 = getProxy(CollectionProxy).shipGroups

	for iter2_51, iter3_51 in pairs(var2_51) do
		if iter3_51.married == 1 then
			local var3_51 = arg0_51:GetShareSkinsForShipGroup(iter3_51.id)

			for iter4_51, iter5_51 in ipairs(var3_51) do
				if not var1_51[iter5_51.id] then
					table.insert(var0_51, iter5_51)
				end
			end
		end
	end

	return var0_51
end

function var0_0.GetProbabilitySkins(arg0_52, arg1_52)
	local var0_52 = {}

	local function var1_52(arg0_53)
		local var0_53 = arg0_53:getSkinId()
		local var1_53 = getProxy(ShipSkinProxy):getSkinById(var0_53)
		local var2_53 = var1_53 and not var1_53:isExpireType() and 1 or 0

		arg0_53:updateBuyCount(var2_53)
	end

	local function var2_52(arg0_54)
		local var0_54 = Goods.Create({
			shop_id = arg0_54
		}, Goods.TYPE_SKIN)

		var1_52(var0_54)

		local var1_54, var2_54 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[arg0_54].time)

		if var1_54 then
			table.insert(var0_52, var0_54)
		end
	end

	local var3_52 = getProxy(ShipSkinProxy):GetAllSkins()
	local var4_52 = {}

	for iter0_52, iter1_52 in ipairs(var3_52) do
		if iter1_52:getConfig("genre") ~= ShopArgs.SkinShopTimeLimit then
			var4_52[iter1_52:getSkinId()] = iter1_52.id
		end
	end

	for iter2_52, iter3_52 in ipairs(arg1_52) do
		local var5_52 = var4_52[iter3_52[1]]

		if var5_52 then
			var2_52(var5_52)
		end
	end

	return var0_52
end

function var0_0.GetSkinProbabilitys(arg0_55, arg1_55)
	local var0_55 = {}

	for iter0_55, iter1_55 in ipairs(arg1_55) do
		var0_55[iter1_55[1]] = iter1_55[2]
	end

	return var0_55
end

function var0_0.GetInTimeSkins(arg0_56)
	local var0_56 = arg0_56:GetAllSkins()

	for iter0_56 = #var0_56, 1, -1 do
		local var1_56 = var0_56[iter0_56]

		if var1_56.type == Goods.TYPE_SKIN then
			if var1_56:getConfig("time") == "always" then
				table.remove(var0_56, iter0_56)
			end
		elseif var1_56.type == Goods.TYPE_ACTIVITY_EXTRA and pg.activity_shop_extra[var1_56.id].shop_tag ~= 1 then
			table.remove(var0_56, iter0_56)
		end
	end

	return var0_56
end

function var0_0.GetPermanentSkins(arg0_57)
	local var0_57 = arg0_57:GetAllSkins()

	for iter0_57 = #var0_57, 1, -1 do
		local var1_57 = var0_57[iter0_57]

		if var1_57.type == Goods.TYPE_SKIN then
			if var1_57:getConfig("time") ~= "always" then
				table.remove(var0_57, iter0_57)
			end
		elseif var1_57.type == Goods.TYPE_ACTIVITY_EXTRA then
			if pg.activity_shop_extra[var1_57.id].shop_tag ~= 2 then
				table.remove(var0_57, iter0_57)
			end
		elseif var1_57.type == Goods.TYPE_ACTIVITY then
			table.remove(var0_57, iter0_57)
		end
	end

	return var0_57
end

function var0_0.GetShareSkinsForShipGroupInJuus(arg0_58, arg1_58)
	local var0_58 = pg.ship_data_group.get_id_list_by_group_type[arg1_58][1]
	local var1_58 = pg.ship_data_group[var0_58]

	if not var1_58.share_group_id or #var1_58.share_group_id <= 0 then
		return {}
	end

	local var2_58 = {}

	for iter0_58, iter1_58 in ipairs(var1_58.share_group_id) do
		local var3_58 = pg.ship_skin_template.get_id_list_by_ship_group[iter1_58]

		for iter2_58, iter3_58 in ipairs(var3_58) do
			local var4_58 = ShipSkin.New({
				id = iter3_58
			})

			if var4_58:CanShareInJuus() then
				table.insert(var2_58, var4_58)
			end
		end
	end

	return var2_58
end

return var0_0
