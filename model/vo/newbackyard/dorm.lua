local var0 = class("Dorm", import("..BaseVO"))

var0.MAX_FLOOR = 2
var0.MAX_LEVEL = 4
var0.DORM_2_FLOOR_COMFORTABLE_ADDITION = 20
var0.COMFORTABLE_LEVEL_1 = 1
var0.COMFORTABLE_LEVEL_2 = 2
var0.COMFORTABLE_LEVEL_3 = 3

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id or arg1.lv
	arg0.id = arg0.configId
	arg0.level = arg0.id
	arg0.food = arg1.food or 0
	arg0.food_extend_count = arg1.food_max_increase_count
	arg0.dorm_food_max = arg1.food_max_increase
	arg0.next_timestamp = arg1.next_timestamp or 0
	arg0.exp_pos = arg1.exp_pos or 2
	arg0.rest_pos = arg0.exp_pos
	arg0.load_exp = 0
	arg0.load_food = 0
	arg0.load_time = arg1.load_time or 0
	arg0.name = arg1.name
	arg0.shipIds = arg1.shipIds or {}
	arg0.floorNum = arg1.floor_num or 1
	arg0.furnitures = {}
	arg0.themes = {}
	arg0.expandIds = {
		50011,
		50012,
		50013
	}
	arg0.shopCfg = pg.shop_template
end

function var0.GetExpandId(arg0)
	local var0 = arg0.level - 1

	for iter0, iter1 in ipairs(arg0.expandIds) do
		if arg0.shopCfg[iter1].limit_args[1][2] == var0 then
			return iter1
		end
	end
end

function var0.IsMaxLevel(arg0)
	return arg0.level >= var0.MAX_LEVEL
end

function var0.GetMapSize(arg0)
	return var0.StaticGetMapSize(arg0.level)
end

function var0.StaticGetMapSize(arg0)
	local var0 = 12 - (arg0 - 1) * 4
	local var1 = var0
	local var2 = var0
	local var3 = BackYardConst.MAX_MAP_SIZE
	local var4 = var3.x
	local var5 = var3.y

	return Vector4(var1, var2, var4, var5)
end

function var0.isUnlockFloor(arg0, arg1)
	return arg1 <= arg0.floorNum
end

function var0.setFloorNum(arg0, arg1)
	assert(arg1 <= var0.MAX_FLOOR, "floornum more than max" .. arg1)

	arg0.floorNum = arg1
end

function var0.setName(arg0, arg1)
	arg0.name = arg1
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.getExtendTrainPosShopId(arg0)
	local var0 = pg.shop_template

	for iter0, iter1 in pairs({
		3,
		4,
		18,
		26
	}) do
		if var0[iter1].effect_args == ShopArgs.EffectDromExpPos and arg0.exp_pos >= var0[iter1].limit_args[1][2] and arg0.exp_pos <= var0[iter1].limit_args[1][3] then
			return iter1
		end
	end
end

function var0.bindConfigTable(arg0)
	return pg.dorm_data_template
end

function var0.getComfortable(arg0, arg1)
	local var0 = 0
	local var1 = {}

	local function var2(arg0)
		local var0 = arg0:getTypeForComfortable()

		if not var1[var0] then
			var1[var0] = {}
		end

		table.insert(var1[var0], arg0:getConfig("comfortable"))
	end

	for iter0, iter1 in pairs(arg0.furnitures) do
		local var3 = iter1.count or 1

		for iter2 = 1, var3 do
			var2(iter1)
		end
	end

	for iter3, iter4 in pairs(arg1 or {}) do
		var2(iter4)
	end

	local var4 = arg0:getConfig("comfortable_count")

	for iter5, iter6 in pairs(var4) do
		local var5 = var1[iter6[1]] or {}

		table.sort(var5, function(arg0, arg1)
			return arg1 < arg0
		end)

		for iter7 = 1, iter6[2] do
			var0 = var0 + (var5[iter7] or 0)
		end
	end

	local var6 = var0 + (arg0.level - 1) * 10

	if arg0:isUnlockFloor(2) then
		var6 = var6 + var0.DORM_2_FLOOR_COMFORTABLE_ADDITION
	end

	return var6
end

function var0.GetComfortableLevel(arg0, arg1)
	if arg1 < 30 then
		return var0.COMFORTABLE_LEVEL_1
	elseif arg1 >= 30 and arg1 < 68 then
		return var0.COMFORTABLE_LEVEL_2
	else
		return var0.COMFORTABLE_LEVEL_3
	end
end

function var0._GetComfortableLevel(arg0)
	local var0 = arg0:getComfortable()

	return arg0:GetComfortableLevel(var0)
end

function var0.GetComfortableColor(arg0, arg1)
	return ({
		Color.New(0.9490196, 0.772549, 0.772549, 1),
		Color.New(0.9882353, 0.9333333, 0.7647059, 1),
		Color.New(0.8588235, 0.9490196, 0.772549, 1)
	})[arg1]
end

function var0.increaseTrainPos(arg0)
	arg0.exp_pos = arg0.exp_pos + 1
end

function var0.increaseRestPos(arg0)
	arg0.rest_pos = arg0.rest_pos + 1
end

function var0.increaseFoodExtendCount(arg0)
	arg0.food_extend_count = arg0.food_extend_count + 1
end

function var0.extendFoodCapacity(arg0, arg1)
	arg0.dorm_food_max = arg0.dorm_food_max + arg1
end

function var0.levelUp(arg0)
	arg0.configId = arg0.configId + 1
	arg0.id = arg0.configId
	arg0.level = arg0.configId
	arg0.comfortable = (arg0.level - 1) * 10
end

function var0.consumeFood(arg0, arg1)
	arg0.food = math.max(arg0.food - arg1, 0)
end

function var0.restNextTime(arg0)
	local var0 = arg0:bindConfigTable()[arg0.id]

	arg0.next_timestamp = pg.TimeMgr.GetInstance():GetServerTime() + var0.time
end

function var0.isMaxFood(arg0)
	local var0 = arg0:bindConfigTable()[arg0.id]

	return arg0.food >= arg0.dorm_food_max + var0.capacity
end

function var0.getFoodLeftTime(arg0)
	local var0 = arg0:bindConfigTable()[arg0.id]
	local var1 = getProxy(DormProxy):getTrainShipCount()

	if var1 == 0 then
		return 0
	end

	local var2 = pg.gameset["dorm_food_ratio_by_" .. var1].key_value / 100 * var0.consume
	local var3 = arg0.food - arg0.food % var2

	return arg0.next_timestamp + (var3 / var2 - 1) * var0.time
end

function var0.GetCapcity(arg0)
	local var0 = arg0.dorm_food_max

	return arg0:getConfig("capacity") + var0
end

function var0.setShipIds(arg0, arg1)
	arg0.shipIds = arg1
end

function var0.addShip(arg0, arg1)
	table.insert(arg0.shipIds, arg1)
end

function var0.deleteShip(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.shipIds) do
		if iter1 == arg1 then
			table.remove(arg0.shipIds, iter0)

			break
		end
	end
end

function var0.GetStateShipCnt(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.shipIds) do
		if getProxy(BayProxy):RawGetShipById(iter1).state == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.GetStateShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.shipIds) do
		local var1 = getProxy(BayProxy):RawGetShipById(iter1)

		if var1.state == arg1 then
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.GetStateShipsById(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.shipIds) do
		local var1 = getProxy(BayProxy):RawGetShipById(iter1)

		if var1.state == arg1 then
			var0[var1.id] = var1
		end
	end

	return var0
end

function var0.GetNonStateShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.shipIds) do
		local var1 = getProxy(BayProxy):RawGetShipById(iter1)

		if var1.state ~= arg1 then
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.GetShips(arg0)
	local var0 = {}
	local var1 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(arg0.shipIds) do
		local var2 = var1:RawGetShipById(iter1)

		if var2 then
			var0[var2.id] = var2
		else
			print("not found ship >>>", iter1)
		end
	end

	return var0
end

function var0.AnyShipExistIntimacyOrMoney(arg0)
	local var0 = arg0:GetShips()

	for iter0, iter1 in pairs(var0) do
		if iter1.state_info_3 > 0 or iter1.state_info_4 > 0 then
			return true
		end
	end

	return false
end

function var0.GetThemeList(arg0, arg1)
	return arg0.themes
end

function var0.SetTheme(arg0, arg1, arg2)
	arg0.themes[arg1] = arg2
end

function var0.GetTheme(arg0, arg1)
	return arg0.themes[arg1]
end

function var0.GetPurchasedFurnitures(arg0)
	return arg0.furnitures
end

function var0.GetOwnFurnitureCount(arg0, arg1)
	local var0 = arg0.furnitures[arg1]

	if not var0 then
		return 0
	else
		return var0.count
	end
end

function var0.SetFurnitures(arg0, arg1)
	arg0.furnitures = arg1
end

function var0.AddFurniture(arg0, arg1)
	if not arg0.furnitures[arg1.id] then
		arg1:MarkNew()

		arg0.furnitures[arg1.id] = arg1
	else
		local var0 = arg0.furnitures[arg1.id]

		var0:setCount(var0.count + arg1.count)
	end
end

function var0.IsPurchasedFurniture(arg0, arg1)
	return arg0.furnitures[arg1] ~= nil and arg0.furnitures[arg1].count > 0
end

function var0.HasFurniture(arg0, arg1)
	return arg0.furnitures[arg1] ~= nil
end

function var0.GetFurniture(arg0, arg1)
	return arg0.furnitures[arg1]
end

function var0.GetPutFurnitureList(arg0, arg1)
	local var0 = {}
	local var1 = arg0:GetTheme(arg1)
	local var2 = var1 and var1:GetAllFurniture() or {}

	for iter0, iter1 in pairs(var2) do
		table.insert(var0, iter1)
	end

	table.sort(var0, BackyardThemeFurniture._LoadWeight)

	return var0
end

function var0.GetPutShipList(arg0, arg1)
	local var0 = {}
	local var1 = ({
		Ship.STATE_TRAIN,
		Ship.STATE_REST
	})[arg1]

	for iter0, iter1 in pairs(arg0:GetShips()) do
		if iter1.state == var1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
