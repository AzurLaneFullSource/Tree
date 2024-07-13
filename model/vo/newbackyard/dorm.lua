local var0_0 = class("Dorm", import("..BaseVO"))

var0_0.MAX_FLOOR = 2
var0_0.MAX_LEVEL = 4
var0_0.DORM_2_FLOOR_COMFORTABLE_ADDITION = 20
var0_0.COMFORTABLE_LEVEL_1 = 1
var0_0.COMFORTABLE_LEVEL_2 = 2
var0_0.COMFORTABLE_LEVEL_3 = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id or arg1_1.lv
	arg0_1.id = arg0_1.configId
	arg0_1.level = arg0_1.id
	arg0_1.food = arg1_1.food or 0
	arg0_1.food_extend_count = arg1_1.food_max_increase_count
	arg0_1.dorm_food_max = arg1_1.food_max_increase
	arg0_1.next_timestamp = arg1_1.next_timestamp or 0
	arg0_1.exp_pos = arg1_1.exp_pos or 2
	arg0_1.rest_pos = arg0_1.exp_pos
	arg0_1.load_exp = 0
	arg0_1.load_food = 0
	arg0_1.load_time = arg1_1.load_time or 0
	arg0_1.name = arg1_1.name
	arg0_1.shipIds = arg1_1.shipIds or {}
	arg0_1.floorNum = arg1_1.floor_num or 1
	arg0_1.furnitures = {}
	arg0_1.themes = {}
	arg0_1.expandIds = {
		50011,
		50012,
		50013
	}
	arg0_1.shopCfg = pg.shop_template
end

function var0_0.GetExpandId(arg0_2)
	local var0_2 = arg0_2.level - 1

	for iter0_2, iter1_2 in ipairs(arg0_2.expandIds) do
		if arg0_2.shopCfg[iter1_2].limit_args[1][2] == var0_2 then
			return iter1_2
		end
	end
end

function var0_0.IsMaxLevel(arg0_3)
	return arg0_3.level >= var0_0.MAX_LEVEL
end

function var0_0.GetMapSize(arg0_4)
	return var0_0.StaticGetMapSize(arg0_4.level)
end

function var0_0.StaticGetMapSize(arg0_5)
	local var0_5 = 12 - (arg0_5 - 1) * 4
	local var1_5 = var0_5
	local var2_5 = var0_5
	local var3_5 = BackYardConst.MAX_MAP_SIZE
	local var4_5 = var3_5.x
	local var5_5 = var3_5.y

	return Vector4(var1_5, var2_5, var4_5, var5_5)
end

function var0_0.isUnlockFloor(arg0_6, arg1_6)
	return arg1_6 <= arg0_6.floorNum
end

function var0_0.setFloorNum(arg0_7, arg1_7)
	assert(arg1_7 <= var0_0.MAX_FLOOR, "floornum more than max" .. arg1_7)

	arg0_7.floorNum = arg1_7
end

function var0_0.setName(arg0_8, arg1_8)
	arg0_8.name = arg1_8
end

function var0_0.GetName(arg0_9)
	return arg0_9.name
end

function var0_0.getExtendTrainPosShopId(arg0_10)
	local var0_10 = pg.shop_template

	for iter0_10, iter1_10 in pairs({
		3,
		4,
		18,
		26
	}) do
		if var0_10[iter1_10].effect_args == ShopArgs.EffectDromExpPos and arg0_10.exp_pos >= var0_10[iter1_10].limit_args[1][2] and arg0_10.exp_pos <= var0_10[iter1_10].limit_args[1][3] then
			return iter1_10
		end
	end
end

function var0_0.bindConfigTable(arg0_11)
	return pg.dorm_data_template
end

function var0_0.getComfortable(arg0_12, arg1_12)
	local var0_12 = 0
	local var1_12 = {}

	local function var2_12(arg0_13)
		local var0_13 = arg0_13:getTypeForComfortable()

		if not var1_12[var0_13] then
			var1_12[var0_13] = {}
		end

		table.insert(var1_12[var0_13], arg0_13:getConfig("comfortable"))
	end

	for iter0_12, iter1_12 in pairs(arg0_12.furnitures) do
		local var3_12 = iter1_12.count or 1

		for iter2_12 = 1, var3_12 do
			var2_12(iter1_12)
		end
	end

	for iter3_12, iter4_12 in pairs(arg1_12 or {}) do
		var2_12(iter4_12)
	end

	local var4_12 = arg0_12:getConfig("comfortable_count")

	for iter5_12, iter6_12 in pairs(var4_12) do
		local var5_12 = var1_12[iter6_12[1]] or {}

		table.sort(var5_12, function(arg0_14, arg1_14)
			return arg1_14 < arg0_14
		end)

		for iter7_12 = 1, iter6_12[2] do
			var0_12 = var0_12 + (var5_12[iter7_12] or 0)
		end
	end

	local var6_12 = var0_12 + (arg0_12.level - 1) * 10

	if arg0_12:isUnlockFloor(2) then
		var6_12 = var6_12 + var0_0.DORM_2_FLOOR_COMFORTABLE_ADDITION
	end

	return var6_12
end

function var0_0.GetComfortableLevel(arg0_15, arg1_15)
	if arg1_15 < 30 then
		return var0_0.COMFORTABLE_LEVEL_1
	elseif arg1_15 >= 30 and arg1_15 < 68 then
		return var0_0.COMFORTABLE_LEVEL_2
	else
		return var0_0.COMFORTABLE_LEVEL_3
	end
end

function var0_0._GetComfortableLevel(arg0_16)
	local var0_16 = arg0_16:getComfortable()

	return arg0_16:GetComfortableLevel(var0_16)
end

function var0_0.GetComfortableColor(arg0_17, arg1_17)
	return ({
		Color.New(0.9490196, 0.772549, 0.772549, 1),
		Color.New(0.9882353, 0.9333333, 0.7647059, 1),
		Color.New(0.8588235, 0.9490196, 0.772549, 1)
	})[arg1_17]
end

function var0_0.increaseTrainPos(arg0_18)
	arg0_18.exp_pos = arg0_18.exp_pos + 1
end

function var0_0.increaseRestPos(arg0_19)
	arg0_19.rest_pos = arg0_19.rest_pos + 1
end

function var0_0.increaseFoodExtendCount(arg0_20)
	arg0_20.food_extend_count = arg0_20.food_extend_count + 1
end

function var0_0.extendFoodCapacity(arg0_21, arg1_21)
	arg0_21.dorm_food_max = arg0_21.dorm_food_max + arg1_21
end

function var0_0.levelUp(arg0_22)
	arg0_22.configId = arg0_22.configId + 1
	arg0_22.id = arg0_22.configId
	arg0_22.level = arg0_22.configId
	arg0_22.comfortable = (arg0_22.level - 1) * 10
end

function var0_0.consumeFood(arg0_23, arg1_23)
	arg0_23.food = math.max(arg0_23.food - arg1_23, 0)
end

function var0_0.restNextTime(arg0_24)
	local var0_24 = arg0_24:bindConfigTable()[arg0_24.id]

	arg0_24.next_timestamp = pg.TimeMgr.GetInstance():GetServerTime() + var0_24.time
end

function var0_0.isMaxFood(arg0_25)
	local var0_25 = arg0_25:bindConfigTable()[arg0_25.id]

	return arg0_25.food >= arg0_25.dorm_food_max + var0_25.capacity
end

function var0_0.getFoodLeftTime(arg0_26)
	local var0_26 = arg0_26:bindConfigTable()[arg0_26.id]
	local var1_26 = getProxy(DormProxy):getTrainShipCount()

	if var1_26 == 0 then
		return 0
	end

	local var2_26 = pg.gameset["dorm_food_ratio_by_" .. var1_26].key_value / 100 * var0_26.consume
	local var3_26 = arg0_26.food - arg0_26.food % var2_26

	return arg0_26.next_timestamp + (var3_26 / var2_26 - 1) * var0_26.time
end

function var0_0.GetCapcity(arg0_27)
	local var0_27 = arg0_27.dorm_food_max

	return arg0_27:getConfig("capacity") + var0_27
end

function var0_0.setShipIds(arg0_28, arg1_28)
	arg0_28.shipIds = arg1_28
end

function var0_0.addShip(arg0_29, arg1_29)
	table.insert(arg0_29.shipIds, arg1_29)
end

function var0_0.deleteShip(arg0_30, arg1_30)
	for iter0_30, iter1_30 in ipairs(arg0_30.shipIds) do
		if iter1_30 == arg1_30 then
			table.remove(arg0_30.shipIds, iter0_30)

			break
		end
	end
end

function var0_0.GetStateShipCnt(arg0_31, arg1_31)
	local var0_31 = 0

	for iter0_31, iter1_31 in ipairs(arg0_31.shipIds) do
		if getProxy(BayProxy):RawGetShipById(iter1_31).state == arg1_31 then
			var0_31 = var0_31 + 1
		end
	end

	return var0_31
end

function var0_0.GetStateShips(arg0_32, arg1_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in ipairs(arg0_32.shipIds) do
		local var1_32 = getProxy(BayProxy):RawGetShipById(iter1_32)

		if var1_32.state == arg1_32 then
			table.insert(var0_32, var1_32)
		end
	end

	return var0_32
end

function var0_0.GetStateShipsById(arg0_33, arg1_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in ipairs(arg0_33.shipIds) do
		local var1_33 = getProxy(BayProxy):RawGetShipById(iter1_33)

		if var1_33.state == arg1_33 then
			var0_33[var1_33.id] = var1_33
		end
	end

	return var0_33
end

function var0_0.GetNonStateShips(arg0_34, arg1_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in ipairs(arg0_34.shipIds) do
		local var1_34 = getProxy(BayProxy):RawGetShipById(iter1_34)

		if var1_34.state ~= arg1_34 then
			table.insert(var0_34, var1_34)
		end
	end

	return var0_34
end

function var0_0.GetShips(arg0_35)
	local var0_35 = {}
	local var1_35 = getProxy(BayProxy)

	for iter0_35, iter1_35 in ipairs(arg0_35.shipIds) do
		local var2_35 = var1_35:RawGetShipById(iter1_35)

		if var2_35 then
			var0_35[var2_35.id] = var2_35
		else
			print("not found ship >>>", iter1_35)
		end
	end

	return var0_35
end

function var0_0.AnyShipExistIntimacyOrMoney(arg0_36)
	local var0_36 = arg0_36:GetShips()

	for iter0_36, iter1_36 in pairs(var0_36) do
		if iter1_36.state_info_3 > 0 or iter1_36.state_info_4 > 0 then
			return true
		end
	end

	return false
end

function var0_0.GetThemeList(arg0_37, arg1_37)
	return arg0_37.themes
end

function var0_0.SetTheme(arg0_38, arg1_38, arg2_38)
	arg0_38.themes[arg1_38] = arg2_38
end

function var0_0.GetTheme(arg0_39, arg1_39)
	return arg0_39.themes[arg1_39]
end

function var0_0.GetPurchasedFurnitures(arg0_40)
	return arg0_40.furnitures
end

function var0_0.GetOwnFurnitureCount(arg0_41, arg1_41)
	local var0_41 = arg0_41.furnitures[arg1_41]

	if not var0_41 then
		return 0
	else
		return var0_41.count
	end
end

function var0_0.SetFurnitures(arg0_42, arg1_42)
	arg0_42.furnitures = arg1_42
end

function var0_0.AddFurniture(arg0_43, arg1_43)
	if not arg0_43.furnitures[arg1_43.id] then
		arg1_43:MarkNew()

		arg0_43.furnitures[arg1_43.id] = arg1_43
	else
		local var0_43 = arg0_43.furnitures[arg1_43.id]

		var0_43:setCount(var0_43.count + arg1_43.count)
	end
end

function var0_0.IsPurchasedFurniture(arg0_44, arg1_44)
	return arg0_44.furnitures[arg1_44] ~= nil and arg0_44.furnitures[arg1_44].count > 0
end

function var0_0.HasFurniture(arg0_45, arg1_45)
	return arg0_45.furnitures[arg1_45] ~= nil
end

function var0_0.GetFurniture(arg0_46, arg1_46)
	return arg0_46.furnitures[arg1_46]
end

function var0_0.GetPutFurnitureList(arg0_47, arg1_47)
	local var0_47 = {}
	local var1_47 = arg0_47:GetTheme(arg1_47)
	local var2_47 = var1_47 and var1_47:GetAllFurniture() or {}

	for iter0_47, iter1_47 in pairs(var2_47) do
		table.insert(var0_47, iter1_47)
	end

	table.sort(var0_47, BackyardThemeFurniture._LoadWeight)

	return var0_47
end

function var0_0.GetPutShipList(arg0_48, arg1_48)
	local var0_48 = {}
	local var1_48 = ({
		Ship.STATE_TRAIN,
		Ship.STATE_REST
	})[arg1_48]

	for iter0_48, iter1_48 in pairs(arg0_48:GetShips()) do
		if iter1_48.state == var1_48 then
			table.insert(var0_48, iter1_48)
		end
	end

	return var0_48
end

return var0_0
