local var0_0 = class("ApartmentProxy", import(".NetProxy"))

var0_0.UPDATE_APARTMENT = "ApartmentProxy.UPDATE_APARTMENT"
var0_0.UPDATE_ROOM = "ApartmentProxy.UPDATE_ROOM"
var0_0.UPDATE_GIFT_COUNT = "ApartmentProxy.UPDATE_GIFT_COUNT"
var0_0.ZERO_HOUR_REFRESH = "ApartmentProxy.ZERO_HOUR_REFRESH"

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.roomData = {}
	arg0_1.giftBag = setDefaultZeroMetatable({})
	arg0_1.giftGiveCount = setDefaultZeroMetatable({})
	arg0_1.stamina = 0
	arg0_1.shopCount = {
		dailyGift = {},
		permanentGift = {},
		dailyFurniture = {},
		permanentFurniture = {}
	}

	arg0_1:on(28000, function(arg0_2)
		arg0_1.stamina = getDorm3dGameset("daily_vigor_max")[1] - arg0_2.daily_vigor_max

		for iter0_2, iter1_2 in ipairs(arg0_2.gifts) do
			arg0_1.giftBag[iter1_2.gift_id] = iter1_2.number
			arg0_1.giftGiveCount[iter1_2.gift_id] = iter1_2.used_number
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.ships) do
			local var0_2 = Apartment.New(iter3_2)

			arg0_1.data[var0_2:GetConfigID()] = var0_2
		end

		for iter4_2, iter5_2 in ipairs(arg0_2.rooms) do
			local var1_2 = ApartmentRoom.New(iter5_2)

			arg0_1.roomData[var1_2:GetConfigID()] = var1_2
		end

		local function var2_2(arg0_3, arg1_3)
			_.each(arg0_3 or {}, function(arg0_4)
				arg1_3[arg0_4.gift_id] = arg0_4.count
			end)
		end

		var2_2(arg0_2.gift_daily, arg0_1.shopCount.dailyGift)
		var2_2(arg0_2.gift_permanent, arg0_1.shopCount.permanentGift)
		var2_2(arg0_2.furniture_daily, arg0_1.shopCount.dailyFurniture)
		var2_2(arg0_2.furniture_permanent, arg0_1.shopCount.permanentFurniture)
	end)
end

function var0_0.timeCall(arg0_5)
	return {
		[ProxyRegister.DayCall] = function(arg0_6, arg1_6)
			if pg.TimeMgr.GetInstance():GetServerWeek() ~= 1 then
				return
			end

			arg0_5:ResetDailyShopCount()

			arg0_5.stamina = getDorm3dGameset("daily_vigor_max")[1]

			arg0_5:sendNotification(var0_0.ZERO_HOUR_REFRESH)
			arg0_5:InitGiftDaily()
		end
	}
end

function var0_0.InitGiftDaily(arg0_7)
	pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
		callback = function()
			for iter0_8, iter1_8 in pairs(pg.dorm3d_gift.all) do
				local var0_8 = pg.dorm3d_gift[iter1_8]

				if #var0_8.shop_id > 0 then
					local var1_8 = pg.shop_template[var0_8.shop_id[1]].group

					if var1_8 ~= 0 then
						arg0_7.shopCount.dailyGift[var0_8.id] = getProxy(ShopsProxy):GetGroupPayCount(var1_8)
					end
				end
			end
		end
	})
end

function var0_0.updateApartment(arg0_9, arg1_9)
	arg0_9.data[arg1_9.configId] = arg1_9:clone()

	arg0_9:sendNotification(var0_0.UPDATE_APARTMENT, arg1_9)
end

function var0_0.updateRoom(arg0_10, arg1_10)
	arg0_10.roomData[arg1_10.configId] = arg1_10:clone()

	arg0_10:sendNotification(var0_0.UPDATE_ROOM, arg1_10)
end

function var0_0.triggerFavor(arg0_11, arg1_11, arg2_11, arg3_11)
	arg3_11 = arg3_11 or 1

	local var0_11 = arg0_11.data[arg1_11]
	local var1_11 = pg.dorm3d_favor_trigger[arg2_11]
	local var2_11 = 0
	local var3_11 = 0

	if arg0_11.stamina >= var1_11.is_daily_max and not var0_11:isMaxFavor() then
		var3_11 = var1_11.is_daily_max * arg3_11
		var2_11 = math.min(var1_11.num * arg3_11, var0_11:getMaxFavor() - var0_11.favor)
	end

	arg0_11.stamina = arg0_11.stamina - var3_11
	var0_11.favor = var0_11.favor + var2_11
	var0_11.triggerCountDic[arg2_11] = var0_11.triggerCountDic[arg2_11] + 1

	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataFavor(arg1_11, var2_11, var0_11.favor, var1_11.type, table.CastToString(var1_11.param)))
	arg0_11:updateApartment(var0_11)

	return var2_11, var3_11
end

function var0_0.getStamina(arg0_12)
	return arg0_12.stamina, getDorm3dGameset("daily_vigor_max")[1]
end

function var0_0.getApartment(arg0_13, arg1_13)
	return arg0_13.data[arg1_13] and arg0_13.data[arg1_13]:clone() or nil
end

function var0_0.getRoom(arg0_14, arg1_14)
	return arg0_14.roomData[arg1_14]
end

function var0_0.getGiftCount(arg0_15, arg1_15)
	return arg0_15.giftBag[arg1_15]
end

function var0_0.changeGiftCount(arg0_16, arg1_16, arg2_16)
	assert(arg2_16 ~= 0)

	arg0_16.giftBag[arg1_16] = arg0_16.giftBag[arg1_16] + arg2_16

	arg0_16:sendNotification(var0_0.UPDATE_GIFT_COUNT, arg1_16)
end

function var0_0.getApartmentGiftCount(arg0_17, arg1_17)
	for iter0_17, iter1_17 in pairs(arg0_17.giftBag) do
		if iter1_17 > 0 and pg.dorm3d_gift[iter0_17].ship_group_id == arg1_17 then
			return iter0_17
		end
	end

	return nil
end

function var0_0.addGiftGiveCount(arg0_18, arg1_18, arg2_18)
	arg0_18.giftGiveCount[arg1_18] = arg0_18.giftGiveCount[arg1_18] + arg2_18
end

function var0_0.isGiveGiftDone(arg0_19, arg1_19)
	return arg0_19.giftGiveCount[arg1_19] > 0
end

function var0_0.GetGiftShopCount(arg0_20, arg1_20)
	return arg0_20.shopCount.dailyGift[arg1_20] or arg0_20.shopCount.permanentGift[arg1_20] or 0
end

function var0_0.AddDailyGiftShopCount(arg0_21, arg1_21, arg2_21)
	arg0_21.shopCount.dailyGift[arg1_21] = (arg0_21.shopCount.dailyGift[arg1_21] or 0) + arg2_21
end

function var0_0.AddPermanentGiftShopCount(arg0_22, arg1_22, arg2_22)
	arg0_22.shopCount.permanentGift[arg1_22] = (arg0_22.shopCount.permanentGift[arg1_22] or 0) + arg2_22
end

function var0_0.GetFurnitureShopCount(arg0_23, arg1_23)
	return arg0_23.shopCount.dailyFurniture[arg1_23] or arg0_23.shopCount.permanentFurniture[arg1_23] or 0
end

function var0_0.AddDailyFurnitureShopCount(arg0_24, arg1_24, arg2_24)
	arg0_24.shopCount.dailyFurniture[arg1_24] = (arg0_24.shopCount.dailyFurniture[arg1_24] or 0) + arg2_24
end

function var0_0.AddPermanentFurnitureShopCount(arg0_25, arg1_25, arg2_25)
	arg0_25.shopCount.permanentFurniture[arg1_25] = (arg0_25.shopCount.permanentFurniture[arg1_25] or 0) + arg2_25
end

function var0_0.ResetDailyShopCount(arg0_26)
	table.clear(arg0_26.shopCount.dailyGift)
	table.clear(arg0_26.shopCount.dailyFurniture)
end

function var0_0.RecordEnterTime(arg0_27)
	arg0_27.dormEnterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_28)
	return arg0_28.dormEnterTimeStamp
end

function var0_0.RecordAccompanyTime(arg0_29)
	arg0_29.dormAccompanyTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetAccompanyTime(arg0_30)
	return arg0_30.dormAccompanyTimeStamp
end

local var1_0 = {
	6,
	18
}

function var0_0.GetTimeIndex(arg0_31)
	local var0_31 = #var1_0

	for iter0_31, iter1_31 in ipairs(var1_0) do
		if arg0_31 < iter1_31 then
			break
		else
			var0_31 = iter0_31
		end
	end

	return var0_31
end

function var0_0.GetTimePPName()
	local var0_32 = getProxy(PlayerProxy):getRawData()

	return "DORM3D_SCENE_LOCK_TIME_IN_PLAYER:" .. var0_32.id
end

function var0_0.CheckUnlockConfig(arg0_33)
	if arg0_33 == nil or arg0_33 == "" or #arg0_33 == 0 then
		return true
	end

	return switch(arg0_33[1], {
		function(arg0_34, arg1_34, arg2_34)
			local var0_34 = getProxy(ApartmentProxy):getApartment(arg1_34)

			if var0_34 and arg2_34 <= var0_34.level then
				return true
			else
				return false, i18n("apartment_level_unenough", arg2_34)
			end
		end,
		function(arg0_35, arg1_35)
			local var0_35 = getProxy(ApartmentProxy):getRoom(pg.dorm3d_furniture_template[arg1_35].room_id)

			if var0_35 and underscore.any(var0_35.furnitures, function(arg0_36)
				return arg0_36.configId == arg1_35
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", arg1_35)
			end
		end,
		function(arg0_37, arg1_37)
			if getProxy(ApartmentProxy):isGiveGiftDone(arg1_37) then
				return true
			else
				return false, string.format("gift:%d didn't had given", arg1_37)
			end
		end,
		function(arg0_38, arg1_38)
			local var0_38 = getProxy(CollectionProxy):getShipGroup(arg1_38)

			if var0_38 and var0_38.married > 0 then
				return true
			else
				return false, string.format("ship:%d was not married", arg1_38)
			end
		end,
		function(arg0_39, arg1_39, arg2_39)
			local var0_39 = getProxy(ApartmentProxy):getRoom(arg1_39)

			return var0_39 and var0_39.unlockCharacter[arg2_39], i18n("dorm3d_skin_locked")
		end
	}, function(arg0_40)
		return false, string.format("without unlock type:%d", arg0_40)
	end, unpack(arg0_33))
end

function var0_0.PendingRandom(arg0_41, arg1_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg1_41) do
		local var1_41 = underscore.detect(pg.dorm3d_rooms[arg0_41].character_welcome, function(arg0_42)
			return arg0_42[1] == iter1_41
		end)

		if var1_41 and var1_41[2] > math.random() * 10000 then
			var0_41[iter1_41] = {}
		end
	end

	for iter2_41, iter3_41 in ipairs(pg.dorm3d_welcome.get_id_list_by_room_id[arg0_41] or {}) do
		local var2_41 = pg.dorm3d_welcome[iter3_41]

		if var0_41[var2_41.ship_id] then
			table.insert(var0_41[var2_41.ship_id], iter3_41)
		end
	end

	local var3_41 = {}

	for iter4_41, iter5_41 in pairs(var0_41) do
		local var4_41 = 0
		local var5_41 = 0

		for iter6_41, iter7_41 in ipairs(iter5_41) do
			var5_41 = var5_41 + pg.dorm3d_welcome[iter7_41].weight
		end

		local var6_41 = math.random() * var5_41

		for iter8_41, iter9_41 in ipairs(iter5_41) do
			var4_41 = var4_41 + pg.dorm3d_welcome[iter9_41].weight

			if var6_41 < var4_41 then
				var3_41[iter4_41] = iter9_41

				break
			end
		end
	end

	return var3_41
end

return var0_0
