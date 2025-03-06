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

function var0_0.RawGetApartment(arg0_13, arg1_13)
	return arg0_13.data[arg1_13]
end

function var0_0.getApartment(arg0_14, arg1_14)
	return arg0_14.data[arg1_14] and arg0_14.data[arg1_14]:clone() or nil
end

function var0_0.getRoom(arg0_15, arg1_15)
	return arg0_15.roomData[arg1_15]
end

function var0_0.getGiftCount(arg0_16, arg1_16)
	return arg0_16.giftBag[arg1_16]
end

function var0_0.changeGiftCount(arg0_17, arg1_17, arg2_17)
	assert(arg2_17 ~= 0)

	arg0_17.giftBag[arg1_17] = arg0_17.giftBag[arg1_17] + arg2_17

	arg0_17:sendNotification(var0_0.UPDATE_GIFT_COUNT, arg1_17)
end

function var0_0.getApartmentGiftCount(arg0_18, arg1_18)
	for iter0_18, iter1_18 in pairs(arg0_18.giftBag) do
		if iter1_18 > 0 and pg.dorm3d_gift[iter0_18].ship_group_id == arg1_18 then
			return iter0_18
		end
	end

	return nil
end

function var0_0.addGiftGiveCount(arg0_19, arg1_19, arg2_19)
	arg0_19.giftGiveCount[arg1_19] = arg0_19.giftGiveCount[arg1_19] + arg2_19
end

function var0_0.isGiveGiftDone(arg0_20, arg1_20)
	return arg0_20.giftGiveCount[arg1_20] > 0
end

function var0_0.GetGiftShopCount(arg0_21, arg1_21)
	return arg0_21.shopCount.dailyGift[arg1_21] or arg0_21.shopCount.permanentGift[arg1_21] or 0
end

function var0_0.AddDailyGiftShopCount(arg0_22, arg1_22, arg2_22)
	arg0_22.shopCount.dailyGift[arg1_22] = (arg0_22.shopCount.dailyGift[arg1_22] or 0) + arg2_22
end

function var0_0.AddPermanentGiftShopCount(arg0_23, arg1_23, arg2_23)
	arg0_23.shopCount.permanentGift[arg1_23] = (arg0_23.shopCount.permanentGift[arg1_23] or 0) + arg2_23
end

function var0_0.GetFurnitureShopCount(arg0_24, arg1_24)
	return arg0_24.shopCount.dailyFurniture[arg1_24] or arg0_24.shopCount.permanentFurniture[arg1_24] or 0
end

function var0_0.AddDailyFurnitureShopCount(arg0_25, arg1_25, arg2_25)
	arg0_25.shopCount.dailyFurniture[arg1_25] = (arg0_25.shopCount.dailyFurniture[arg1_25] or 0) + arg2_25
end

function var0_0.AddPermanentFurnitureShopCount(arg0_26, arg1_26, arg2_26)
	arg0_26.shopCount.permanentFurniture[arg1_26] = (arg0_26.shopCount.permanentFurniture[arg1_26] or 0) + arg2_26
end

function var0_0.ResetDailyShopCount(arg0_27)
	table.clear(arg0_27.shopCount.dailyGift)
	table.clear(arg0_27.shopCount.dailyFurniture)
end

function var0_0.RecordEnterTime(arg0_28)
	arg0_28.dormEnterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_29)
	return arg0_29.dormEnterTimeStamp
end

function var0_0.RecordAccompanyTime(arg0_30)
	arg0_30.dormAccompanyTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetAccompanyTime(arg0_31)
	return arg0_31.dormAccompanyTimeStamp
end

local var1_0 = {
	6,
	18
}

function var0_0.GetTimeIndex(arg0_32)
	local var0_32 = #var1_0

	for iter0_32, iter1_32 in ipairs(var1_0) do
		if arg0_32 < iter1_32 then
			break
		else
			var0_32 = iter0_32
		end
	end

	return var0_32
end

function var0_0.GetTimePPName(arg0_33)
	local var0_33 = getProxy(PlayerProxy):getRawData()

	return "DORM3D_SCENE_LOCK_TIME_IN_PLAYER:" .. var0_33.id .. "_ROOM_" .. arg0_33
end

function var0_0.CheckUnlockConfig(arg0_34)
	if arg0_34 == nil or arg0_34 == "" or #arg0_34 == 0 then
		return true
	end

	return switch(arg0_34[1], {
		function(arg0_35, arg1_35, arg2_35)
			local var0_35 = getProxy(ApartmentProxy):getApartment(arg1_35)

			if var0_35 and arg2_35 <= var0_35.level then
				return true
			else
				return false, i18n("apartment_level_unenough", arg2_35)
			end
		end,
		function(arg0_36, arg1_36)
			local var0_36 = getProxy(ApartmentProxy):getRoom(pg.dorm3d_furniture_template[arg1_36].room_id)

			if var0_36 and underscore.any(var0_36.furnitures, function(arg0_37)
				return arg0_37.configId == arg1_36
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", arg1_36)
			end
		end,
		function(arg0_38, arg1_38)
			if getProxy(ApartmentProxy):isGiveGiftDone(arg1_38) then
				return true
			else
				return false, string.format("gift:%d didn't had given", arg1_38)
			end
		end,
		function(arg0_39, arg1_39)
			local var0_39 = getProxy(CollectionProxy):getShipGroup(arg1_39)

			if var0_39 and var0_39.married > 0 then
				return true
			else
				return false, string.format("ship:%d was not married", arg1_39)
			end
		end,
		function(arg0_40, arg1_40, arg2_40)
			local var0_40 = getProxy(ApartmentProxy):getRoom(arg1_40)

			return var0_40 and var0_40.unlockCharacter[arg2_40], i18n("dorm3d_skin_locked")
		end
	}, function(arg0_41)
		return false, string.format("without unlock type:%d", arg0_41)
	end, unpack(arg0_34))
end

function var0_0.PendingRandom(arg0_42, arg1_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in ipairs(arg1_42) do
		local var1_42 = underscore.detect(pg.dorm3d_rooms[arg0_42].character_welcome, function(arg0_43)
			return arg0_43[1] == iter1_42
		end)

		if var1_42 and var1_42[2] > math.random() * 10000 then
			var0_42[iter1_42] = {}
		end
	end

	for iter2_42, iter3_42 in ipairs(pg.dorm3d_welcome.get_id_list_by_room_id[arg0_42] or {}) do
		local var2_42 = pg.dorm3d_welcome[iter3_42]

		if var0_42[var2_42.ship_id] then
			table.insert(var0_42[var2_42.ship_id], iter3_42)
		end
	end

	local var3_42 = {}

	for iter4_42, iter5_42 in pairs(var0_42) do
		local var4_42 = 0
		local var5_42 = 0

		for iter6_42, iter7_42 in ipairs(iter5_42) do
			var5_42 = var5_42 + pg.dorm3d_welcome[iter7_42].weight
		end

		local var6_42 = math.random() * var5_42

		for iter8_42, iter9_42 in ipairs(iter5_42) do
			var4_42 = var4_42 + pg.dorm3d_welcome[iter9_42].weight

			if var6_42 < var4_42 then
				var3_42[iter4_42] = iter9_42

				break
			end
		end
	end

	return var3_42
end

function var0_0.CheckDeviceRAMEnough()
	local var0_44 = SystemInfo.systemMemorySize
	local var1_44 = getDorm3dGameset("drom3d_memory_limit")[1]

	return var0_44 == 0 or var1_44 < var0_44
end

return var0_0
