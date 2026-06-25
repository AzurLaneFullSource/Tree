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

function var0_0.InTime(arg0_7)
	return pg.TimeMgr.GetInstance():inTime(arg0_7:getConfig("time"))
end

function var0_0.IsSingleGiveGift(arg0_8)
	return pg.dorm3d_gift[arg0_8].unlock_dialogue_id ~= 0
end

function var0_0.IsExpireSoon(arg0_9)
	local var0_9 = pg.dorm3d_gift[arg0_9].time

	if type(var0_9) ~= "table" or #var0_9 <= 1 then
		return false
	end

	local var1_9 = pg.TimeMgr.GetInstance()
	local var2_9 = var1_9:GetServerTime()
	local var3_9 = var1_9:parseTimeFromConfig(var0_9[2])

	return var1_9:inTime(var0_9) and var3_9 - var2_9 <= 172800
end

function var0_0.GetExpireSoonTipFlag(arg0_10)
	local var0_10 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_10 .. "_dorm3dGiftExpireSoonTip_" .. arg0_10, 0)
end

function var0_0.SetExpireSoonTipFlag(arg0_11)
	if var0_0.GetExpireSoonTipFlag(arg0_11) > 0 then
		return
	end

	local var0_11 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_11 .. "_dorm3dGiftExpireSoonTip_" .. arg0_11, 1)

	return true
end

function var0_0.GetShopID(arg0_12)
	local var0_12 = arg0_12:getConfig("shop_id")
	local var1_12 = getProxy(ApartmentProxy):GetGiftShopCount(arg0_12.configId)

	for iter0_12 = 1, #var0_12 - 1 do
		local var2_12 = var0_12[iter0_12]
		local var3_12 = pg.shop_template[var2_12]
		local var4_12 = var3_12.limit_args[1]

		if not var4_12 and var3_12.group_type == 0 then
			return var2_12
		elseif var4_12 and (var4_12[1] == "dailycount" or var4_12[1] == "count") then
			if var1_12 < var4_12[3] then
				return var2_12
			end
		elseif var3_12.group_type == 2 then
			if var1_12 < var3_12.group_limit then
				return var2_12
			end
		else
			return var2_12
		end
	end

	return var0_12[#var0_12] or 0
end

function var0_0.CheckBuyLimit(arg0_13)
	local var0_13 = arg0_13:GetShopID()
	local var1_13 = pg.shop_template[var0_13]
	local var2_13 = getProxy(ApartmentProxy):GetGiftShopCount(var1_13.effect_args[1])

	if var1_13.limit_args then
		local var3_13 = var1_13.limit_args[1]

		if type(var3_13) == "table" and (var3_13[1] == "dailycount" or var3_13[1] == "count") and var2_13 >= var3_13[3] then
			return false
		end
	end

	if var1_13.group_limit > 0 and var2_13 >= var1_13.group_limit then
		return false
	end

	return true
end

function var0_0.NeedViewTip(arg0_14)
	local var0_14 = var0_0.bindConfigTable()
	local var1_14 = _.keys(var0_14.get_id_list_by_ship_group_id)

	return _.any(var1_14, function(arg0_15)
		if arg0_15 == 0 then
			return
		end

		if arg0_14 and arg0_14 > 0 and arg0_15 ~= arg0_14 then
			return
		end

		local var0_15 = var0_14.get_id_list_by_ship_group_id[arg0_15]

		return _.any(var0_15, function(arg0_16)
			local var0_16 = Dorm3dGift.New({
				configId = arg0_16
			})

			return var0_16:GetShopID() and type(var0_16:getConfig("time")) ~= "table" and (not Dorm3dGift.IsSingleGiveGift(arg0_16) or not getProxy(ApartmentProxy):isGiveGiftDone(arg0_16)) and Dorm3dGift.GetViewedFlag(arg0_16) == 0
		end)
	end)
end

function var0_0.NeedViewTipByGiftId(arg0_17)
	return Dorm3dGift.GetViewedFlag(arg0_17) == 0 and (not Dorm3dGift.IsSingleGiveGift(arg0_17) or not getProxy(ApartmentProxy):isGiveGiftDone(arg0_17))
end

function var0_0.GetViewedFlag(arg0_18)
	local var0_18 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(var0_18 .. "_dorm3dGiftViewed_" .. arg0_18, 0)
end

function var0_0.SetViewedFlag(arg0_19)
	if var0_0.GetViewedFlag(arg0_19) > 0 then
		return
	end

	local var0_19 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_19 .. "_dorm3dGiftViewed_" .. arg0_19, 1)

	return true
end

return var0_0
