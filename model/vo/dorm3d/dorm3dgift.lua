local var0_0 = class("Dorm3dGift", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_gift
end

function var0_0.GetName(arg0_2)
	return arg0_2:getConfig("name")
end

function var0_0.GetRarity(arg0_3)
	return arg0_3:getConfig("rarity")
end

function var0_0.GetShipGroupId(arg0_4)
	return arg0_4:getConfig("ship_group_id")
end

function var0_0.GetIcon(arg0_5)
	return arg0_5:getConfig("icon")
end

function var0_0.GetDesc(arg0_6)
	return arg0_6:getConfig("display")
end

function var0_0.GetShopID(arg0_7)
	local var0_7 = arg0_7:getConfig("shop_id")
	local var1_7 = getProxy(ApartmentProxy):GetGiftShopCount(arg0_7.configId)

	for iter0_7 = 1, #var0_7 - 1 do
		local var2_7 = var0_7[iter0_7]
		local var3_7 = pg.shop_template[var2_7]
		local var4_7 = var3_7.limit_args[1]

		if not var4_7 and var3_7.group_type == 0 then
			return var2_7
		elseif var4_7 and (var4_7[1] == "dailycount" or var4_7[1] == "count") then
			if var1_7 < var4_7[3] then
				return var2_7
			end
		elseif var3_7.group_type == 2 then
			if var1_7 < var3_7.group_limit then
				return var2_7
			end
		else
			return var2_7
		end
	end

	return var0_7[#var0_7]
end

function var0_0.CheckBuyLimit(arg0_8)
	local var0_8 = arg0_8:GetShopID()
	local var1_8 = pg.shop_template[var0_8]
	local var2_8 = getProxy(ApartmentProxy):GetGiftShopCount(var1_8.effect_args[1])

	if var1_8.limit_args then
		local var3_8 = var1_8.limit_args[1]

		if type(var3_8) == "table" and (var3_8[1] == "dailycount" or var3_8[1] == "count") and var2_8 >= var3_8[3] then
			return false
		end
	end

	if var1_8.group_limit > 0 and var2_8 >= var1_8.group_limit then
		return false
	end

	return true
end

function var0_0.NeedViewTip(arg0_9)
	local var0_9 = var0_0.bindConfigTable()
	local var1_9 = _.keys(var0_9.get_id_list_by_ship_group_id)

	return _.any(var1_9, function(arg0_10)
		if arg0_10 == 0 then
			return
		end

		if arg0_9 and arg0_9 > 0 and arg0_10 ~= arg0_9 then
			return
		end

		local var0_10 = var0_9.get_id_list_by_ship_group_id[arg0_10]

		return _.any(var0_10, function(arg0_11)
			return Dorm3dGift.New({
				configId = arg0_11
			}):GetShopID() and not getProxy(ApartmentProxy):isGiveGiftDone(arg0_11) and Dorm3dGift.GetViewedFlag(arg0_11) == 0
		end)
	end)
end

function var0_0.GetViewedFlag(arg0_12)
	local var0_12 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_12 .. "_dorm3dGiftViewed_" .. arg0_12, 0)
end

function var0_0.SetViewedFlag(arg0_13)
	if var0_0.GetViewedFlag(arg0_13) > 0 then
		return
	end

	local var0_13 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_13 .. "_dorm3dGiftViewed_" .. arg0_13, 1)

	return true
end

return var0_0
