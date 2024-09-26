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
		end
	}
end

function var0_0.InitGiftDaily(arg0_7)
	for iter0_7, iter1_7 in pairs(pg.dorm3d_gift.all) do
		local var0_7 = pg.dorm3d_gift[iter1_7]

		if #var0_7.shop_id > 0 then
			local var1_7 = pg.shop_template[var0_7.shop_id[1]].group

			if var1_7 ~= 0 then
				arg0_7.shopCount.dailyGift[var0_7.id] = getProxy(ShopsProxy):GetGroupPayCount(var1_7)
			end
		end
	end
end

function var0_0.updateApartment(arg0_8, arg1_8)
	arg0_8.data[arg1_8.configId] = arg1_8:clone()

	arg0_8:sendNotification(var0_0.UPDATE_APARTMENT, arg1_8)
end

function var0_0.updateRoom(arg0_9, arg1_9)
	arg0_9.roomData[arg1_9.configId] = arg1_9:clone()

	arg0_9:sendNotification(var0_0.UPDATE_ROOM, arg1_9)
end

function var0_0.triggerFavor(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.data[arg1_10]
	local var1_10 = pg.dorm3d_favor_trigger[arg2_10]
	local var2_10 = 0
	local var3_10 = 0

	if arg0_10.stamina >= var1_10.is_daily_max and not var0_10:isMaxFavor() then
		var3_10 = var1_10.is_daily_max
		var2_10 = math.min(var1_10.num, var0_10:getMaxFavor())
	end

	arg0_10.stamina = arg0_10.stamina - var3_10
	var0_10.favor = var0_10.favor + var2_10
	var0_10.triggerCountDic[arg2_10] = var0_10.triggerCountDic[arg2_10] + 1

	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataFavor(arg1_10, var2_10, var0_10.favor, var1_10.type, table.CastToString(var1_10.param)))
	arg0_10:updateApartment(var0_10)

	return var2_10, var3_10
end

function var0_0.getStamina(arg0_11)
	return arg0_11.stamina, getDorm3dGameset("daily_vigor_max")[1]
end

function var0_0.getApartment(arg0_12, arg1_12)
	return arg0_12.data[arg1_12] and arg0_12.data[arg1_12]:clone() or nil
end

function var0_0.getRoom(arg0_13, arg1_13)
	return arg0_13.roomData[arg1_13]
end

function var0_0.getGiftCount(arg0_14, arg1_14)
	return arg0_14.giftBag[arg1_14]
end

function var0_0.changeGiftCount(arg0_15, arg1_15, arg2_15)
	assert(arg2_15 ~= 0)

	arg0_15.giftBag[arg1_15] = arg0_15.giftBag[arg1_15] + arg2_15

	arg0_15:sendNotification(var0_0.UPDATE_GIFT_COUNT, arg1_15)
end

function var0_0.getApartmentGiftCount(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.giftBag) do
		if iter1_16 > 0 and pg.dorm3d_gift[iter0_16].ship_group_id == arg1_16 then
			return iter0_16
		end
	end

	return nil
end

function var0_0.addGiftGiveCount(arg0_17, arg1_17, arg2_17)
	arg0_17.giftGiveCount[arg1_17] = arg0_17.giftGiveCount[arg1_17] + arg2_17
end

function var0_0.isGiveGiftDone(arg0_18, arg1_18)
	return arg0_18.giftGiveCount[arg1_18] > 0
end

function var0_0.GetGiftShopCount(arg0_19, arg1_19)
	return arg0_19.shopCount.dailyGift[arg1_19] or arg0_19.shopCount.permanentGift[arg1_19] or 0
end

function var0_0.AddDailyGiftShopCount(arg0_20, arg1_20, arg2_20)
	arg0_20.shopCount.dailyGift[arg1_20] = (arg0_20.shopCount.dailyGift[arg1_20] or 0) + arg2_20
end

function var0_0.AddPermanentGiftShopCount(arg0_21, arg1_21, arg2_21)
	arg0_21.shopCount.permanentGift[arg1_21] = (arg0_21.shopCount.permanentGift[arg1_21] or 0) + arg2_21
end

function var0_0.GetFurnitureShopCount(arg0_22, arg1_22)
	return arg0_22.shopCount.dailyFurniture[arg1_22] or arg0_22.shopCount.permanentFurniture[arg1_22] or 0
end

function var0_0.AddDailyFurnitureShopCount(arg0_23, arg1_23, arg2_23)
	arg0_23.shopCount.dailyFurniture[arg1_23] = (arg0_23.shopCount.dailyFurniture[arg1_23] or 0) + arg2_23
end

function var0_0.AddPermanentFurnitureShopCount(arg0_24, arg1_24, arg2_24)
	arg0_24.shopCount.permanentFurniture[arg1_24] = (arg0_24.shopCount.permanentFurniture[arg1_24] or 0) + arg2_24
end

function var0_0.ResetDailyShopCount(arg0_25)
	table.clear(arg0_25.shopCount.dailyGift)
	table.clear(arg0_25.shopCount.dailyFurniture)
end

function var0_0.RecordEnterTime(arg0_26)
	arg0_26.dormEnterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_27)
	return arg0_27.dormEnterTimeStamp
end

function var0_0.RecordAccompanyTime(arg0_28)
	arg0_28.dormAccompanyTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetAccompanyTime(arg0_29)
	return arg0_29.dormAccompanyTimeStamp
end

local var1_0 = {
	6,
	18
}

function var0_0.GetTimeIndex(arg0_30)
	local var0_30 = #var1_0

	for iter0_30, iter1_30 in ipairs(var1_0) do
		if arg0_30 < iter1_30 then
			break
		else
			var0_30 = iter0_30
		end
	end

	return var0_30
end

function var0_0.GetTimePPName()
	local var0_31 = getProxy(PlayerProxy):getRawData()

	return "DORM3D_SCENE_LOCK_TIME_IN_PLAYER:" .. var0_31.id
end

function var0_0.CheckUnlockConfig(arg0_32)
	if arg0_32 == nil or arg0_32 == "" or #arg0_32 == 0 then
		return true
	end

	return switch(arg0_32[1], {
		function(arg0_33, arg1_33, arg2_33)
			local var0_33 = getProxy(ApartmentProxy):getApartment(arg1_33)

			if var0_33 and arg2_33 <= var0_33.level then
				return true
			else
				return false, i18n("apartment_level_unenough", arg2_33)
			end
		end,
		function(arg0_34, arg1_34)
			local var0_34 = getProxy(ApartmentProxy):getRoom(pg.dorm3d_furniture_template[arg1_34].room_id)

			if var0_34 and underscore.any(var0_34.furnitures, function(arg0_35)
				return arg0_35.configId == arg1_34
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", arg1_34)
			end
		end,
		function(arg0_36, arg1_36)
			if getProxy(ApartmentProxy):isGiveGiftDone(arg1_36) then
				return true
			else
				return false, string.format("gift:%d didn't had given", arg1_36)
			end
		end,
		function(arg0_37, arg1_37)
			local var0_37 = getProxy(CollectionProxy):getShipGroup(arg1_37)

			if var0_37 and var0_37.married > 0 then
				return true
			else
				return false, string.format("ship:%d was not married", arg1_37)
			end
		end,
		function(arg0_38, arg1_38, arg2_38)
			local var0_38 = getProxy(ApartmentProxy):getRoom(arg1_38)

			return var0_38 and var0_38.unlockCharacter[arg2_38], i18n("dorm3d_skin_locked")
		end
	}, function(arg0_39)
		return false, string.format("without unlock type:%d", arg0_39)
	end, unpack(arg0_32))
end

function var0_0.PendingRandom(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in ipairs(arg1_40) do
		if underscore.detect(pg.dorm3d_rooms[arg0_40].character_welcome, function(arg0_41)
			return arg0_41[1] == iter1_40
		end)[2] > math.random() * 10000 then
			var0_40[iter1_40] = {}
		end
	end

	for iter2_40, iter3_40 in ipairs(pg.dorm3d_welcome.get_id_list_by_room_id[arg0_40] or {}) do
		local var1_40 = pg.dorm3d_welcome[iter3_40]

		if var0_40[var1_40.ship_id] then
			table.insert(var0_40[var1_40.ship_id], iter3_40)
		end
	end

	local var2_40 = {}

	for iter4_40, iter5_40 in pairs(var0_40) do
		local var3_40 = 0
		local var4_40 = 0

		for iter6_40, iter7_40 in ipairs(iter5_40) do
			var4_40 = var4_40 + pg.dorm3d_welcome[iter7_40].weight
		end

		local var5_40 = math.random() * var4_40

		for iter8_40, iter9_40 in ipairs(iter5_40) do
			var3_40 = var3_40 + pg.dorm3d_welcome[iter9_40].weight

			if var5_40 < var3_40 then
				var2_40[iter4_40] = iter9_40

				break
			end
		end
	end

	return var2_40
end

return var0_0
