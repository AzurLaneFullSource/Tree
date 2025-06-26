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

function var0_0.addGiftGiveCount(arg0_21, arg1_21, arg2_21)
	arg0_21.giftGiveCount[arg1_21] = arg0_21.giftGiveCount[arg1_21] + arg2_21
end

function var0_0.isGiveGiftDone(arg0_22, arg1_22)
	return arg0_22.giftGiveCount[arg1_22] > 0
end

function var0_0.GetGiftShopCount(arg0_23, arg1_23)
	return arg0_23.shopCount.dailyGift[arg1_23] or arg0_23.shopCount.permanentGift[arg1_23] or 0
end

function var0_0.AddDailyGiftShopCount(arg0_24, arg1_24, arg2_24)
	arg0_24.shopCount.dailyGift[arg1_24] = (arg0_24.shopCount.dailyGift[arg1_24] or 0) + arg2_24
end

function var0_0.AddPermanentGiftShopCount(arg0_25, arg1_25, arg2_25)
	arg0_25.shopCount.permanentGift[arg1_25] = (arg0_25.shopCount.permanentGift[arg1_25] or 0) + arg2_25
end

function var0_0.GetFurnitureShopCount(arg0_26, arg1_26)
	return arg0_26.shopCount.dailyFurniture[arg1_26] or arg0_26.shopCount.permanentFurniture[arg1_26] or 0
end

function var0_0.AddDailyFurnitureShopCount(arg0_27, arg1_27, arg2_27)
	arg0_27.shopCount.dailyFurniture[arg1_27] = (arg0_27.shopCount.dailyFurniture[arg1_27] or 0) + arg2_27
end

function var0_0.AddPermanentFurnitureShopCount(arg0_28, arg1_28, arg2_28)
	arg0_28.shopCount.permanentFurniture[arg1_28] = (arg0_28.shopCount.permanentFurniture[arg1_28] or 0) + arg2_28
end

function var0_0.ResetDailyShopCount(arg0_29)
	table.clear(arg0_29.shopCount.dailyGift)
	table.clear(arg0_29.shopCount.dailyFurniture)
end

function var0_0.RecordEnterTime(arg0_30)
	arg0_30.dormEnterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_31)
	return arg0_31.dormEnterTimeStamp
end

function var0_0.RecordAccompanyTime(arg0_32)
	arg0_32.dormAccompanyTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetAccompanyTime(arg0_33)
	return arg0_33.dormAccompanyTimeStamp
end

function var0_0.GetRoomInviteList(arg0_34)
	return underscore.map(string.split(PlayerPrefs.GetString(string.format("room%d_invite_list", arg0_34), ""), "|"), function(arg0_35)
		return tonumber(arg0_35)
	end)
end

function var0_0.SetRoomInviteList(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36, var1_36, var2_36 = table.Diff(var0_0.GetRoomInviteList(arg1_36), arg2_36)

	PlayerPrefs.SetString(string.format("room%d_invite_list", arg1_36), table.concat(arg2_36, "|"))
	arg0_36:sendNotification(var0_0.UPDATE_ROOM_INVITE_LIST, {
		roomId = arg1_36,
		groupIds = arg2_36,
		addIds = var1_36,
		removeIds = var2_36,
		callback = arg3_36
	})
end

function var0_0.GetSlideInviteList()
	return underscore.map(string.split(PlayerPrefs.GetString("slide_invite_list", ""), "|"), function(arg0_38)
		return tonumber(arg0_38)
	end) or {}
end

function var0_0.SetSlideInviteList(arg0_39, arg1_39, arg2_39)
	local var0_39, var1_39, var2_39 = table.Diff(var0_0.GetSlideInviteList(), arg1_39)

	PlayerPrefs.SetString("slide_invite_list", table.concat(arg1_39, "|"))
	arg0_39:sendNotification(var0_0.UPDATE_SLIDE_INVITE_LIST, {
		groupIds = arg1_39,
		addIds = var1_39,
		removeIds = var2_39,
		callback = arg2_39
	})
end

local var1_0 = {
	6,
	18
}

function var0_0.GetTimeIndex(arg0_40)
	local var0_40 = #var1_0

	for iter0_40, iter1_40 in ipairs(var1_0) do
		if arg0_40 < iter1_40 then
			break
		else
			var0_40 = iter0_40
		end
	end

	return var0_40
end

function var0_0.GetTimePPName(arg0_41)
	local var0_41 = getProxy(PlayerProxy):getRawData()

	return "DORM3D_SCENE_LOCK_TIME_IN_PLAYER:" .. var0_41.id .. "_ROOM_" .. arg0_41
end

function var0_0.CheckUnlockConfig(arg0_42)
	if arg0_42 == nil or arg0_42 == "" or #arg0_42 == 0 then
		return true
	end

	return switch(arg0_42[1], {
		function(arg0_43, arg1_43, arg2_43)
			local var0_43 = getProxy(ApartmentProxy):getApartment(arg1_43)

			if var0_43 and arg2_43 <= var0_43.level then
				return true
			else
				return false, i18n("apartment_level_unenough", arg2_43)
			end
		end,
		function(arg0_44, arg1_44)
			local var0_44 = getProxy(ApartmentProxy):getRoom(pg.dorm3d_furniture_template[arg1_44].room_id)

			if var0_44 and underscore.any(var0_44.furnitures, function(arg0_45)
				return arg0_45.configId == arg1_44
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", arg1_44)
			end
		end,
		function(arg0_46, arg1_46)
			if getProxy(ApartmentProxy):isGiveGiftDone(arg1_46) then
				return true
			else
				return false, string.format("gift:%d didn't had given", arg1_46)
			end
		end,
		function(arg0_47, arg1_47)
			local var0_47 = getProxy(CollectionProxy):getShipGroup(arg1_47)

			if var0_47 and var0_47.married > 0 then
				return true
			else
				return false, string.format("ship:%d was not married", arg1_47)
			end
		end,
		function(arg0_48, arg1_48, arg2_48)
			local var0_48 = getProxy(ApartmentProxy):getRoom(arg1_48)

			return var0_48 and var0_48.unlockCharacter[arg2_48], i18n("dorm3d_skin_locked")
		end,
		function(arg0_49, arg1_49, arg2_49)
			local var0_49 = getProxy(ApartmentProxy):getApartment(arg2_49)

			return var0_49 and _.detect(var0_49.skinList, function(arg0_50)
				return arg0_50 == arg1_49
			end), i18n("dorm3d_skin_locked")
		end
	}, function(arg0_51)
		return false, string.format("without unlock type:%d", arg0_51)
	end, unpack(arg0_42))
end

function var0_0.PendingRandom(arg0_52, arg1_52)
	local var0_52 = {}

	for iter0_52, iter1_52 in ipairs(arg1_52) do
		local var1_52 = underscore.detect(pg.dorm3d_rooms[arg0_52].character_welcome, function(arg0_53)
			return arg0_53[1] == iter1_52
		end)

		if var1_52 and var1_52[2] > math.random() * 10000 then
			var0_52[iter1_52] = {}
		end
	end

	for iter2_52, iter3_52 in ipairs(pg.dorm3d_welcome.get_id_list_by_room_id[arg0_52] or {}) do
		local var2_52 = pg.dorm3d_welcome[iter3_52]

		if var0_52[var2_52.ship_id] then
			table.insert(var0_52[var2_52.ship_id], iter3_52)
		end
	end

	local var3_52 = {}

	for iter4_52, iter5_52 in pairs(var0_52) do
		local var4_52 = 0
		local var5_52 = 0

		for iter6_52, iter7_52 in ipairs(iter5_52) do
			var5_52 = var5_52 + pg.dorm3d_welcome[iter7_52].weight
		end

		local var6_52 = math.random() * var5_52

		for iter8_52, iter9_52 in ipairs(iter5_52) do
			var4_52 = var4_52 + pg.dorm3d_welcome[iter9_52].weight

			if var6_52 < var4_52 then
				var3_52[iter4_52] = iter9_52

				break
			end
		end
	end

	return var3_52
end

function var0_0.RefreshGiftDailyTip()
	for iter0_54, iter1_54 in pairs(pg.dorm3d_shop_template.all) do
		local var0_54 = pg.dorm3d_shop_template[iter1_54]

		if pg.shop_template[var0_54.shop_id[1]].group ~= 0 then
			local var1_54 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt(var1_54 .. "_dorm3dGiftWeekViewed_" .. var0_54.item_id, 0)
			PlayerPrefs.SetInt(var1_54 .. "_dorm3dGiftWeekRefreshTimeStamp", pg.TimeMgr.GetInstance():GetServerTime())
		end
	end
end

function var0_0.CheckDeviceRAMEnough()
	local var0_55 = SystemInfo.systemMemorySize
	local var1_55 = getDorm3dGameset("drom3d_memory_limit")[1]

	return var0_55 == 0 or var1_55 < var0_55
end

function var0_0.CheckAllRoomInviteAll(arg0_56)
	for iter0_56, iter1_56 in ipairs(pg.dorm3d_rooms.all) do
		if iter1_56 ~= 5 then
			if not arg0_56.roomData[iter1_56] then
				return false
			end

			if not arg0_56.roomData[iter1_56]:isPersonalRoom() and not arg0_56.roomData[iter1_56]:unlockAllInvite() then
				return false
			end
		end
	end

	return true
end

return var0_0
