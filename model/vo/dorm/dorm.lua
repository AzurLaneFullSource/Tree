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
	arg0_1.foodMax = arg1_1.food_max_increase
	arg0_1.exp_pos = arg1_1.exp_pos or 2
	arg0_1.rest_pos = arg0_1.exp_pos
	arg0_1.lastAddExpTime = arg1_1.load_time or 0
	arg0_1.nextAddShipExpTime = arg1_1.next_timestamp or 0
	arg0_1.name = arg1_1.name
	arg0_1.ships = {}
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

function var0_0.GetFoodMax(arg0_2)
	return arg0_2.foodMax
end

function var0_0.GetExpandId(arg0_3)
	local var0_3 = arg0_3.level - 1

	for iter0_3, iter1_3 in ipairs(arg0_3.expandIds) do
		if arg0_3.shopCfg[iter1_3].limit_args[1][2] == var0_3 then
			return iter1_3
		end
	end
end

function var0_0.IsMaxLevel(arg0_4)
	return arg0_4.level >= var0_0.MAX_LEVEL
end

function var0_0.GetMapSize(arg0_5)
	return var0_0.StaticGetMapSize(arg0_5.level)
end

function var0_0.StaticGetMapSize(arg0_6)
	local var0_6 = 12 - (arg0_6 - 1) * 4
	local var1_6 = var0_6
	local var2_6 = var0_6
	local var3_6 = BackYardConst.MAX_MAP_SIZE
	local var4_6 = var3_6.x
	local var5_6 = var3_6.y

	return Vector4(var1_6, var2_6, var4_6, var5_6)
end

function var0_0.isUnlockFloor(arg0_7, arg1_7)
	return arg1_7 <= arg0_7.floorNum
end

function var0_0.setFloorNum(arg0_8, arg1_8)
	assert(arg1_8 <= var0_0.MAX_FLOOR, "floornum more than max" .. arg1_8)

	arg0_8.floorNum = arg1_8
end

function var0_0.setName(arg0_9, arg1_9)
	arg0_9.name = arg1_9
end

function var0_0.GetName(arg0_10)
	return arg0_10.name
end

function var0_0.getExtendTrainPosShopId(arg0_11)
	local var0_11 = pg.shop_template

	for iter0_11, iter1_11 in pairs({
		3,
		4,
		18,
		26
	}) do
		if var0_11[iter1_11].effect_args == ShopArgs.EffectDromExpPos and arg0_11.exp_pos >= var0_11[iter1_11].limit_args[1][2] and arg0_11.exp_pos <= var0_11[iter1_11].limit_args[1][3] then
			return iter1_11
		end
	end
end

function var0_0.bindConfigTable(arg0_12)
	return pg.dorm_data_template
end

function var0_0.getComfortable(arg0_13, arg1_13)
	local var0_13 = 0
	local var1_13 = {}

	local function var2_13(arg0_14)
		local var0_14 = arg0_14:getTypeForComfortable()

		if not var1_13[var0_14] then
			var1_13[var0_14] = {}
		end

		table.insert(var1_13[var0_14], arg0_14:getConfig("comfortable"))
	end

	for iter0_13, iter1_13 in pairs(arg0_13.furnitures) do
		local var3_13 = iter1_13.count or 1

		for iter2_13 = 1, var3_13 do
			var2_13(iter1_13)
		end
	end

	for iter3_13, iter4_13 in pairs(arg1_13 or {}) do
		var2_13(iter4_13)
	end

	local var4_13 = arg0_13:getConfig("comfortable_count")

	for iter5_13, iter6_13 in pairs(var4_13) do
		local var5_13 = var1_13[iter6_13[1]] or {}

		table.sort(var5_13, function(arg0_15, arg1_15)
			return arg1_15 < arg0_15
		end)

		for iter7_13 = 1, iter6_13[2] do
			var0_13 = var0_13 + (var5_13[iter7_13] or 0)
		end
	end

	local var6_13 = var0_13 + arg0_13:getConfig("comfortable")

	if arg0_13:isUnlockFloor(2) then
		var6_13 = var6_13 + var0_0.DORM_2_FLOOR_COMFORTABLE_ADDITION
	end

	return var6_13
end

function var0_0.GetComfortableLevel(arg0_16, arg1_16)
	if arg1_16 < 30 then
		return var0_0.COMFORTABLE_LEVEL_1
	elseif arg1_16 >= 30 and arg1_16 < 68 then
		return var0_0.COMFORTABLE_LEVEL_2
	else
		return var0_0.COMFORTABLE_LEVEL_3
	end
end

function var0_0._GetComfortableLevel(arg0_17)
	local var0_17 = arg0_17:getComfortable()

	return arg0_17:GetComfortableLevel(var0_17)
end

function var0_0.GetComfortableColor(arg0_18, arg1_18)
	return ({
		Color.New(0.9490196, 0.772549, 0.772549, 1),
		Color.New(0.9882353, 0.9333333, 0.7647059, 1),
		Color.New(0.8588235, 0.9490196, 0.772549, 1)
	})[arg1_18]
end

function var0_0.increaseTrainPos(arg0_19)
	arg0_19.exp_pos = arg0_19.exp_pos + 1
end

function var0_0.increaseRestPos(arg0_20)
	arg0_20.rest_pos = arg0_20.rest_pos + 1
end

function var0_0.increaseFoodExtendCount(arg0_21)
	arg0_21.food_extend_count = arg0_21.food_extend_count + 1
end

function var0_0.extendFoodCapacity(arg0_22, arg1_22)
	arg0_22.foodMax = arg0_22.foodMax + arg1_22
end

function var0_0.levelUp(arg0_23)
	arg0_23.configId = arg0_23.configId + 1
	arg0_23.id = arg0_23.configId
	arg0_23.level = arg0_23.configId
	arg0_23.comfortable = arg0_23:getConfig("comfortable")
end

function var0_0.consumeFood(arg0_24, arg1_24)
	arg0_24.food = math.max(arg0_24.food - arg1_24, 0)
end

function var0_0.isMaxFood(arg0_25)
	local var0_25 = arg0_25:bindConfigTable()[arg0_25.id]

	return arg0_25.food >= arg0_25.foodMax + var0_25.capacity
end

function var0_0.getFoodLeftTime(arg0_26)
	local var0_26 = arg0_26:bindConfigTable()[arg0_26.id]
	local var1_26 = arg0_26:GetFloorShipCnt(DormShip.FLOOR_1)

	if var1_26 == 0 then
		return 0
	end

	local var2_26 = pg.gameset["dorm_food_ratio_by_" .. var1_26].key_value / 100 * var0_26.consume
	local var3_26 = arg0_26.food - arg0_26.food % var2_26

	return arg0_26.nextAddShipExpTime + (var3_26 / var2_26 - 1) * var0_26.time
end

function var0_0.GetCapcity(arg0_27)
	local var0_27 = arg0_27.foodMax

	return arg0_27:getConfig("capacity") + var0_27
end

function var0_0.IsLackOfFood(arg0_28)
	if arg0_28:GetFloorShipCnt(DormShip.FLOOR_1) == 0 then
		return false
	end

	if arg0_28.food <= 0 then
		return true
	end

	return arg0_28:getFoodLeftTime() - pg.TimeMgr.GetInstance():GetServerTime() <= 0
end

function var0_0.GetLastAddShipExpTime(arg0_29)
	return arg0_29.lastAddExpTime
end

function var0_0.UpdateLastAddShipExpTime(arg0_30, arg1_30)
	arg0_30.lastAddExpTime = arg1_30
end

function var0_0.GetNextSettlementShipExpTime(arg0_31)
	return arg0_31.nextAddShipExpTime
end

function var0_0.UpdateNextSettlementShipExpTime(arg0_32, arg1_32)
	local var0_32 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg1_32 <= var0_32 then
		arg1_32 = var0_32 + 10
	end

	arg0_32.nextAddShipExpTime = arg1_32
end

function var0_0.ShouldRequestShipExp(arg0_33)
	local var0_33 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0_33 >= arg0_33.nextAddShipExpTime, arg0_33.nextAddShipExpTime - var0_33
end

function var0_0.AddInimacyAndMoney(arg0_34, arg1_34, arg2_34, arg3_34)
	arg0_34:GetShip(arg1_34):AddmoneyAndIntimacy(arg3_34, arg2_34)
end

function var0_0.SetShips(arg0_35, arg1_35)
	arg0_35.ships = arg1_35
end

function var0_0.GetShips(arg0_36)
	return arg0_36.ships
end

function var0_0.GetShipIds(arg0_37)
	return _.map(arg0_37.ships, function(arg0_38)
		return arg0_38.id
	end)
end

function var0_0.GetFloorShipCnt(arg0_39, arg1_39)
	local var0_39 = 0

	for iter0_39, iter1_39 in ipairs(arg0_39.ships) do
		if iter1_39:IsSameFloor(arg1_39) then
			var0_39 = var0_39 + 1
		end
	end

	return var0_39
end

function var0_0.InBackYard(arg0_40, arg1_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.ships) do
		if iter1_40:IsSame(arg1_40) then
			return true, iter1_40.floor
		end
	end

	return false
end

function var0_0.AddShip(arg0_41, arg1_41, arg2_41)
	table.insert(arg0_41.ships, DormShip.New({
		id = arg1_41,
		floor = arg2_41
	}))
end

function var0_0.DeleteShip(arg0_42, arg1_42)
	for iter0_42, iter1_42 in ipairs(arg0_42.ships) do
		if iter1_42:IsSame(arg1_42) then
			table.remove(arg0_42.ships, iter0_42)

			break
		end
	end
end

function var0_0.GetShip(arg0_43, arg1_43)
	for iter0_43, iter1_43 in ipairs(arg0_43.ships) do
		if iter1_43:IsSame(arg1_43) then
			return iter1_43
		end
	end

	return nil
end

function var0_0.GetHasMoneyOrIntimacyShips(arg0_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in ipairs(arg0_44.ships) do
		if iter1_44:HasMoneyOrIntimacy() then
			table.insert(var0_44, iter1_44)
		end
	end

	return var0_44
end

function var0_0.AnyShipExistIntimacyOrMoney(arg0_45)
	return #arg0_45:GetHasMoneyOrIntimacyShips() > 0
end

function var0_0.GetShipsMoneyAndIntimacy(arg0_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in ipairs(arg0_46.ships) do
		local var1_46 = iter1_46:GetMoney()
		local var2_46 = iter1_46:GetIntimacy()

		var0_46[iter1_46.id] = {
			var1_46,
			var2_46
		}
	end

	return var0_46
end

function var0_0.GetBayShipOnFloor(arg0_47, arg1_47)
	local var0_47 = {}

	for iter0_47, iter1_47 in ipairs(arg0_47.ships) do
		local var1_47 = iter1_47:ToBayShip()

		if iter1_47:IsSameFloor(arg1_47) then
			table.insert(var0_47, var1_47)
		end
	end

	return var0_47
end

function var0_0.GetDicBayShipOnFloor(arg0_48, arg1_48)
	local var0_48 = {}
	local var1_48 = arg0_48:GetBayShipOnFloor(arg1_48)

	for iter0_48, iter1_48 in ipairs(var1_48) do
		var0_48[iter1_48.id] = iter1_48
	end

	return var0_48
end

function var0_0.HarvestInimacyAndMoney(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetShip(arg1_49)
	local var1_49 = var0_49:ToBayShip()

	if not isa(var0_49, DormShip) or not var1_49 then
		return
	end

	local var2_49 = 0
	local var3_49 = 0

	if var0_49:HasIntimacy() then
		var3_49 = var0_49:GetIntimacy()

		var1_49:addLikability(var3_49)
		getProxy(BayProxy):updateShip(var1_49)
		var0_49:ClearIntimacy()
	end

	if var0_49:HasMoney() then
		local var4_49 = getProxy(PlayerProxy):getRawData()

		var2_49 = var0_49:GetMoney()

		var4_49:addResources({
			dormMoney = var2_49
		})
		var0_49:ClearMoney()
		getProxy(PlayerProxy):updatePlayer(var4_49)
	end

	return var2_49, var3_49
end

function var0_0.GetThemeList(arg0_50, arg1_50)
	return arg0_50.themes
end

function var0_0.SetTheme(arg0_51, arg1_51, arg2_51)
	arg0_51.themes[arg1_51] = arg2_51
end

function var0_0.GetTheme(arg0_52, arg1_52)
	return arg0_52.themes[arg1_52]
end

function var0_0.GetPurchasedFurnitures(arg0_53)
	return arg0_53.furnitures
end

function var0_0.GetOwnFurnitureCount(arg0_54, arg1_54)
	local var0_54 = arg0_54.furnitures[arg1_54]

	if not var0_54 then
		return 0
	else
		return var0_54.count
	end
end

function var0_0.SetFurnitures(arg0_55, arg1_55)
	arg0_55.furnitures = arg1_55
end

function var0_0.AddFurniture(arg0_56, arg1_56)
	if not arg0_56.furnitures[arg1_56.id] then
		arg1_56:MarkNew()

		arg0_56.furnitures[arg1_56.id] = arg1_56
	else
		local var0_56 = arg0_56.furnitures[arg1_56.id]

		var0_56:setCount(var0_56.count + arg1_56.count)
	end
end

function var0_0.AddFurnitrues(arg0_57, arg1_57)
	for iter0_57, iter1_57 in ipairs(arg1_57) do
		local var0_57 = Furniture.New({
			count = 1,
			id = iter1_57
		})

		arg0_57:AddFurniture(var0_57)
	end
end

function var0_0.IsPurchasedFurniture(arg0_58, arg1_58)
	return arg0_58.furnitures[arg1_58] ~= nil and arg0_58.furnitures[arg1_58].count > 0
end

function var0_0.HasFurniture(arg0_59, arg1_59)
	return arg0_59.furnitures[arg1_59] ~= nil
end

function var0_0.GetFurniture(arg0_60, arg1_60)
	return arg0_60.furnitures[arg1_60]
end

function var0_0.GetPutFurnitureList(arg0_61, arg1_61)
	local var0_61 = {}
	local var1_61 = arg0_61:GetTheme(arg1_61)
	local var2_61 = var1_61 and var1_61:GetAllFurniture() or {}

	for iter0_61, iter1_61 in pairs(var2_61) do
		table.insert(var0_61, iter1_61)
	end

	table.sort(var0_61, BackyardThemeFurniture._LoadWeight)

	return var0_61
end

function var0_0.ClearNewFlag(arg0_62)
	local var0_62 = arg0_62:GetPurchasedFurnitures()

	for iter0_62, iter1_62 in pairs(var0_62) do
		iter1_62:ClearNewFlag()
	end
end

function var0_0.ClearNewFlagById(arg0_63, arg1_63)
	local var0_63 = arg0_63:GetPurchasedFurnitures()[arg1_63]

	if var0_63 then
		var0_63:ClearNewFlag()
	end
end

return var0_0
