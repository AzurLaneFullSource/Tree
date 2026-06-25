local var0_0 = class("ApartmentProxy", import(".NetProxy"))

var0_0.UPDATE_APARTMENT = "ApartmentProxy.UPDATE_APARTMENT"
var0_0.UPDATE_ROOM = "ApartmentProxy.UPDATE_ROOM"
var0_0.UPDATE_GIFT_COUNT = "ApartmentProxy.UPDATE_GIFT_COUNT"
var0_0.ZERO_HOUR_REFRESH = "ApartmentProxy.ZERO_HOUR_REFRESH"
var0_0.UPDATE_ROOM_INVITE_LIST = "ApartmentProxy.UPDATE_ROOM_INVITE_LIST"
var0_0.UPDATE_SLIDE_INVITE_LIST = "ApartmentProxy.UPDATE_SLIDE_INVITE_LIST"

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
			var0_0.RefreshGiftDailyTip()
		end
	}
end

function var0_0.InitGiftDaily(arg0_7)
	pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
		callback = function()
			for iter0_8, iter1_8 in ipairs(pg.dorm3d_gift.all) do
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

function var0_0.ModifyApartment(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.data[arg1_11]

	assert(var0_11, "apartment not exist")

	if type(arg2_11) == "function" then
		arg2_11(var0_11)
	elseif type(arg2_11) == "table" then
		for iter0_11, iter1_11 in pairs(arg2_11) do
			var0_11[iter0_11] = iter1_11
		end
	end

	arg0_11:sendNotification(var0_0.UPDATE_APARTMENT, var0_11:clone())
end

function var0_0.ModifyRoom(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.roomData[arg1_12]

	assert(var0_12, "room not exist")

	if type(arg2_12) == "function" then
		arg2_12(var0_12)
	elseif type(arg2_12) == "table" then
		for iter0_12, iter1_12 in pairs(arg2_12) do
			var0_12[iter0_12] = iter1_12
		end
	end

	arg0_12:sendNotification(var0_0.UPDATE_ROOM, var0_12:clone())
end

function var0_0.triggerFavor(arg0_13, arg1_13, arg2_13, arg3_13)
	arg3_13 = arg3_13 or 1

	local var0_13 = arg0_13.data[arg1_13]
	local var1_13 = pg.dorm3d_favor_trigger[arg2_13]
	local var2_13 = 0
	local var3_13 = 0

	if arg0_13.stamina >= var1_13.is_daily_max and not var0_13:isMaxFavor() then
		var3_13 = var1_13.is_daily_max * arg3_13
		var2_13 = math.min(var1_13.num * arg3_13, var0_13:getMaxFavor() - var0_13.favor)
	end

	arg0_13.stamina = arg0_13.stamina - var3_13
	var0_13.favor = var0_13.favor + var2_13
	var0_13.triggerCountDic[arg2_13] = var0_13.triggerCountDic[arg2_13] + 1

	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataFavor(arg1_13, var2_13, var0_13.favor, var1_13.type, table.CastToString(var1_13.param)))
	arg0_13:updateApartment(var0_13)

	return var2_13, var3_13
end

function var0_0.getStamina(arg0_14)
	return arg0_14.stamina, getDorm3dGameset("daily_vigor_max")[1]
end

function var0_0.RawGetApartment(arg0_15, arg1_15)
	return arg0_15.data[arg1_15]
end

function var0_0.getApartment(arg0_16, arg1_16)
	return arg0_16.data[arg1_16] and arg0_16.data[arg1_16]:clone() or nil
end

function var0_0.getRoom(arg0_17, arg1_17)
	return arg0_17.roomData[arg1_17]
end

function var0_0.getGiftCount(arg0_18, arg1_18)
	return arg0_18.giftBag[arg1_18]
end

function var0_0.changeGiftCount(arg0_19, arg1_19, arg2_19)
	assert(arg2_19 ~= 0)

	arg0_19.giftBag[arg1_19] = arg0_19.giftBag[arg1_19] + arg2_19

	arg0_19:sendNotification(var0_0.UPDATE_GIFT_COUNT, arg1_19)
end

function var0_0.getApartmentGiftCount(arg0_20, arg1_20)
	for iter0_20, iter1_20 in pairs(arg0_20.giftBag) do
		if iter1_20 > 0 and pg.dorm3d_gift[iter0_20].ship_group_id == arg1_20 then
			return iter0_20
		end
	end

	return nil
end

function var0_0.HasGiftExpireSoon(arg0_21)
	for iter0_21, iter1_21 in pairs(arg0_21.giftBag) do
		if iter1_21 > 0 and Dorm3dGift.IsExpireSoon(iter0_21) then
			return true
		end
	end

	return false
end

function var0_0.HasShipGroupGiftExpireSoon(arg0_22, arg1_22)
	local var0_22 = pg.dorm3d_gift.get_id_list_by_ship_group_id[arg1_22] or {}

	return _.any(var0_22, function(arg0_23)
		return arg0_22:getGiftCount(arg0_23) > 0 and Dorm3dGift.IsExpireSoon(arg0_23)
	end)
end

function var0_0.GetShipGroupGiftExpireSoonTipIds(arg0_24, arg1_24)
	local var0_24 = pg.dorm3d_gift.get_id_list_by_ship_group_id[arg1_24] or {}

	return _.filter(var0_24, function(arg0_25)
		return arg0_24:getGiftCount(arg0_25) > 0 and Dorm3dGift.IsExpireSoon(arg0_25) and Dorm3dGift.GetExpireSoonTipFlag(arg0_25) == 0
	end)
end

function var0_0.addGiftGiveCount(arg0_26, arg1_26, arg2_26)
	arg0_26.giftGiveCount[arg1_26] = arg0_26.giftGiveCount[arg1_26] + arg2_26
end

function var0_0.isGiveGiftDone(arg0_27, arg1_27)
	return arg0_27.giftGiveCount[arg1_27] > 0
end

function var0_0.GetGiftShopCount(arg0_28, arg1_28)
	return arg0_28.shopCount.dailyGift[arg1_28] or arg0_28.shopCount.permanentGift[arg1_28] or 0
end

function var0_0.AddDailyGiftShopCount(arg0_29, arg1_29, arg2_29)
	arg0_29.shopCount.dailyGift[arg1_29] = (arg0_29.shopCount.dailyGift[arg1_29] or 0) + arg2_29
end

function var0_0.AddPermanentGiftShopCount(arg0_30, arg1_30, arg2_30)
	arg0_30.shopCount.permanentGift[arg1_30] = (arg0_30.shopCount.permanentGift[arg1_30] or 0) + arg2_30
end

function var0_0.GetFurnitureShopCount(arg0_31, arg1_31)
	return arg0_31.shopCount.dailyFurniture[arg1_31] or arg0_31.shopCount.permanentFurniture[arg1_31] or 0
end

function var0_0.AddDailyFurnitureShopCount(arg0_32, arg1_32, arg2_32)
	arg0_32.shopCount.dailyFurniture[arg1_32] = (arg0_32.shopCount.dailyFurniture[arg1_32] or 0) + arg2_32
end

function var0_0.AddPermanentFurnitureShopCount(arg0_33, arg1_33, arg2_33)
	arg0_33.shopCount.permanentFurniture[arg1_33] = (arg0_33.shopCount.permanentFurniture[arg1_33] or 0) + arg2_33
end

function var0_0.ResetDailyShopCount(arg0_34)
	table.clear(arg0_34.shopCount.dailyGift)
	table.clear(arg0_34.shopCount.dailyFurniture)
end

function var0_0.RecordEnterTime(arg0_35)
	arg0_35.dormEnterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_36)
	return arg0_36.dormEnterTimeStamp
end

function var0_0.RecordAccompanyTime(arg0_37)
	arg0_37.dormAccompanyTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetAccompanyTime(arg0_38)
	return arg0_38.dormAccompanyTimeStamp
end

function var0_0.GetRoomInviteList(arg0_39)
	return underscore.map(string.split(PlayerPrefs.GetString(string.format("room%d_invite_list", arg0_39), ""), "|"), function(arg0_40)
		return tonumber(arg0_40)
	end)
end

function var0_0.SetRoomInviteList(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41, var1_41, var2_41 = table.Diff(var0_0.GetRoomInviteList(arg1_41), arg2_41)

	PlayerPrefs.SetString(string.format("room%d_invite_list", arg1_41), table.concat(arg2_41, "|"))
	arg0_41:sendNotification(var0_0.UPDATE_ROOM_INVITE_LIST, {
		roomId = arg1_41,
		groupIds = arg2_41,
		addIds = var1_41,
		removeIds = var2_41,
		callback = arg3_41
	})

	local var3_41 = var0_0.GetSlideInviteList()
	local var4_41 = underscore.filter(var3_41, function(arg0_42)
		return not table.contains(var2_41, arg0_42)
	end)

	if #var4_41 ~= #var3_41 then
		arg0_41:SetSlideInviteList(var4_41)
	end
end

function var0_0.GetSlideInviteList()
	return underscore.map(string.split(PlayerPrefs.GetString("slide_invite_list", ""), "|"), function(arg0_44)
		return tonumber(arg0_44)
	end) or {}
end

function var0_0.SetSlideInviteList(arg0_45, arg1_45, arg2_45)
	local var0_45, var1_45, var2_45 = table.Diff(var0_0.GetSlideInviteList(), arg1_45)

	PlayerPrefs.SetString("slide_invite_list", table.concat(arg1_45, "|"))
	arg0_45:sendNotification(var0_0.UPDATE_SLIDE_INVITE_LIST, {
		groupIds = arg1_45,
		addIds = var1_45,
		removeIds = var2_45,
		callback = arg2_45
	})
end

local var1_0 = {
	6,
	18
}

function var0_0.GetTimeIndex(arg0_46)
	local var0_46 = #var1_0

	for iter0_46, iter1_46 in ipairs(var1_0) do
		if arg0_46 < iter1_46 then
			break
		else
			var0_46 = iter0_46
		end
	end

	return var0_46
end

function var0_0.GetTimePPName(arg0_47)
	local var0_47 = getProxy(PlayerProxy):getRawData()

	return "DORM3D_SCENE_LOCK_TIME_IN_PLAYER:" .. var0_47.id .. "_ROOM_" .. arg0_47
end

function var0_0.CheckUnlockConfig(arg0_48)
	if arg0_48 == nil or arg0_48 == "" or #arg0_48 == 0 then
		return true
	end

	return switch(arg0_48[1], {
		function(arg0_49, arg1_49, arg2_49)
			local var0_49 = getProxy(ApartmentProxy):getApartment(arg1_49)

			if var0_49 and arg2_49 <= var0_49.level then
				return true
			else
				return false, i18n("apartment_level_unenough", arg2_49)
			end
		end,
		function(arg0_50, arg1_50)
			local var0_50 = getProxy(ApartmentProxy):getRoom(pg.dorm3d_furniture_template[arg1_50].room_id)

			if var0_50 and underscore.any(var0_50.furnitures, function(arg0_51)
				return arg0_51.configId == arg1_50
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", arg1_50)
			end
		end,
		function(arg0_52, arg1_52)
			if getProxy(ApartmentProxy):isGiveGiftDone(arg1_52) then
				return true
			else
				return false, string.format("gift:%d didn't had given", arg1_52)
			end
		end,
		function(arg0_53, arg1_53)
			local var0_53 = getProxy(CollectionProxy):getShipGroup(arg1_53)

			if var0_53 and var0_53.married > 0 then
				return true
			else
				return false, string.format("ship:%d was not married", arg1_53)
			end
		end,
		function(arg0_54, arg1_54, arg2_54)
			local var0_54 = getProxy(ApartmentProxy):getRoom(arg1_54)

			return var0_54 and var0_54.unlockCharacter[arg2_54], i18n("dorm3d_skin_locked")
		end,
		function(arg0_55, arg1_55, arg2_55)
			local var0_55 = getProxy(ApartmentProxy):getApartment(arg2_55)

			return var0_55 and _.detect(var0_55.skinList, function(arg0_56)
				return arg0_56 == arg1_55
			end), i18n("dorm3d_skin_locked")
		end
	}, function(arg0_57)
		return false, string.format("without unlock type:%d", arg0_57)
	end, unpack(arg0_48))
end

function var0_0.PendingRandom(arg0_58, arg1_58)
	local var0_58 = {}

	for iter0_58, iter1_58 in ipairs(arg1_58) do
		local var1_58 = underscore.detect(pg.dorm3d_rooms[arg0_58].character_welcome, function(arg0_59)
			return arg0_59[1] == iter1_58
		end)

		if var1_58 and var1_58[2] > math.random() * 10000 then
			var0_58[iter1_58] = {}
		end
	end

	for iter2_58, iter3_58 in ipairs(pg.dorm3d_welcome.get_id_list_by_room_id[arg0_58] or {}) do
		local var2_58 = pg.dorm3d_welcome[iter3_58]

		if var0_58[var2_58.ship_id] then
			table.insert(var0_58[var2_58.ship_id], iter3_58)
		end
	end

	local var3_58 = {}

	for iter4_58, iter5_58 in pairs(var0_58) do
		local var4_58 = 0
		local var5_58 = 0

		for iter6_58, iter7_58 in ipairs(iter5_58) do
			var5_58 = var5_58 + pg.dorm3d_welcome[iter7_58].weight
		end

		local var6_58 = math.random() * var5_58

		for iter8_58, iter9_58 in ipairs(iter5_58) do
			var4_58 = var4_58 + pg.dorm3d_welcome[iter9_58].weight

			if var6_58 < var4_58 then
				var3_58[iter4_58] = iter9_58

				break
			end
		end
	end

	return var3_58
end

function var0_0.RefreshGiftDailyTip()
	for iter0_60, iter1_60 in ipairs(pg.dorm3d_shop_template.all) do
		local var0_60 = pg.dorm3d_shop_template[iter1_60]

		if pg.shop_template[var0_60.shop_id[1]].group ~= 0 then
			local var1_60 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt(var1_60 .. "_dorm3dGiftWeekViewed_" .. var0_60.item_id, 0)
			PlayerPrefs.SetInt(var1_60 .. "_dorm3dGiftWeekRefreshTimeStamp", pg.TimeMgr.GetInstance():GetServerTime())
		end
	end
end

function var0_0.CheckDeviceRAMEnough()
	local var0_61 = SystemInfo.systemMemorySize
	local var1_61 = getDorm3dGameset("drom3d_memory_limit")[1]

	return var0_61 == 0 or var1_61 < var0_61
end

function var0_0.CheckAllRoomInviteAll(arg0_62)
	for iter0_62, iter1_62 in ipairs(pg.dorm3d_rooms.all) do
		if iter1_62 ~= 5 then
			if not arg0_62.roomData[iter1_62] then
				return false
			end

			if not arg0_62.roomData[iter1_62]:isPersonalRoom() and not arg0_62.roomData[iter1_62]:unlockAllInvite() then
				return false
			end
		end
	end

	return true
end

return var0_0
