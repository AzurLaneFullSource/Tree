local var0 = class("MonthlyShop", import(".BaseShop"))

function var0.Ctor(arg0)
	arg0.goods = {}
end

var0.GoodsType = nil

function var0.IsSameKind(arg0, arg1)
	return isa(arg1, MonthlyShop)
end

function var0.GetCommodityById(arg0, arg1)
	return arg0:getGoodsById(arg1)
end

function var0.GetCommodities(arg0)
	return arg0:getSortGoods()
end

function var0.isOpen(arg0)
	if not arg0.id then
		return false
	end

	local var0 = false

	if arg0:bindConfigTable()[arg0.id] then
		local var1 = pg.TimeMgr.GetInstance()

		var0 = var1:STimeDescS(var1:GetServerTime(), "*t").month == arg0.id
	end

	return var0
end

function var0.getRestDays(arg0)
	if not arg0.id then
		return 0
	end

	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:STimeDescS(var0:GetServerTime(), "*t")
	local var2 = Clone(var1)

	var2.month = arg0.id

	if var2.month >= 12 then
		var2.month = 0
		var2.year = var2.year + 1
	end

	var2.month = var2.month + 1
	var2.day = 0

	local var3 = os.date("%d", os.time(var2)) - var1.day + 1

	return (math.max(var3, 1))
end

function var0.GetRestTime(arg0)
	if not arg0.id then
		return 0
	end

	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:STimeDescS(var0:GetServerTime(), "*t")
	local var2 = Clone(var1)

	var2.month = arg0.id

	if var2.month >= 12 then
		var2.month = 0
		var2.year = var2.year + 1
	end

	var2.month = var2.month + 1
	var2.day = 0
	var2.hour = 23
	var2.min = 59
	var2.sec = 59
	var2.isdst = false

	local var3 = os.time(var2) - var0:GetServerTime()

	return (math.max(var3, 0))
end

function var0.getSortGoods(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.goods) do
		table.insert(var0, iter1)
	end

	local function var1(arg0)
		return math.floor(arg0 * 0.1)
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = 100
		local var1 = 1000
		local var2 = arg0:getConfig("order") + arg0.id / 100000
		local var3 = arg1:getConfig("order") + arg1.id / 100000
		local var4 = getProxy(CollectionProxy)

		local function var5(arg0)
			local var0 = arg0:getConfig("commodity_id")

			return arg0:isSham() and arg0:checkCommodityType(DROP_TYPE_SHIP) and var4:getShipGroup(var1(var0))
		end

		local function var6(arg0)
			return not arg0:canPurchase()
		end

		var2 = var5(arg0) and not var6(arg0) and var2 + var0 or var2
		var3 = var5(arg1) and not var6(arg1) and var3 + var0 or var3
		var2 = var6(arg0) and var2 + var1 or var2
		var3 = var6(arg1) and var3 + var1 or var3

		return var2 < var3
	end)

	return var0
end

function var0.getGoodsCfg(arg0, arg1)
	return pg.activity_shop_template[arg1]
end

function var0.getGoodsById(arg0, arg1)
	return arg0.goods[arg1]
end

function var0.bindConfigTable(arg0)
	return pg.month_shop_template
end

return var0
