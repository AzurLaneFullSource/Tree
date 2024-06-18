local var0_0 = class("MonthlyShop", import(".BaseShop"))

function var0_0.Ctor(arg0_1)
	arg0_1.goods = {}
end

var0_0.GoodsType = nil

function var0_0.IsSameKind(arg0_2, arg1_2)
	return isa(arg1_2, MonthlyShop)
end

function var0_0.GetCommodityById(arg0_3, arg1_3)
	return arg0_3:getGoodsById(arg1_3)
end

function var0_0.GetCommodities(arg0_4)
	return arg0_4:getSortGoods()
end

function var0_0.isOpen(arg0_5)
	if not arg0_5.id then
		return false
	end

	local var0_5 = false

	if arg0_5:bindConfigTable()[arg0_5.id] then
		local var1_5 = pg.TimeMgr.GetInstance()

		var0_5 = var1_5:STimeDescS(var1_5:GetServerTime(), "*t").month == arg0_5.id
	end

	return var0_5
end

function var0_0.getRestDays(arg0_6)
	if not arg0_6.id then
		return 0
	end

	local var0_6 = pg.TimeMgr.GetInstance()
	local var1_6 = var0_6:STimeDescS(var0_6:GetServerTime(), "*t")
	local var2_6 = Clone(var1_6)

	var2_6.month = arg0_6.id

	if var2_6.month >= 12 then
		var2_6.month = 0
		var2_6.year = var2_6.year + 1
	end

	var2_6.month = var2_6.month + 1
	var2_6.day = 0

	local var3_6 = os.date("%d", os.time(var2_6)) - var1_6.day + 1

	return (math.max(var3_6, 1))
end

function var0_0.GetRestTime(arg0_7)
	if not arg0_7.id then
		return 0
	end

	local var0_7 = pg.TimeMgr.GetInstance()
	local var1_7 = var0_7:STimeDescS(var0_7:GetServerTime(), "*t")
	local var2_7 = Clone(var1_7)

	var2_7.month = arg0_7.id

	if var2_7.month >= 12 then
		var2_7.month = 0
		var2_7.year = var2_7.year + 1
	end

	var2_7.month = var2_7.month + 1
	var2_7.day = 0
	var2_7.hour = 23
	var2_7.min = 59
	var2_7.sec = 59
	var2_7.isdst = false

	local var3_7 = os.time(var2_7) - var0_7:GetServerTime()

	return (math.max(var3_7, 0))
end

function var0_0.getSortGoods(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.goods) do
		table.insert(var0_8, iter1_8)
	end

	local function var1_8(arg0_9)
		return math.floor(arg0_9 * 0.1)
	end

	table.sort(var0_8, function(arg0_10, arg1_10)
		local var0_10 = 100
		local var1_10 = 1000
		local var2_10 = arg0_10:getConfig("order") + arg0_10.id / 100000
		local var3_10 = arg1_10:getConfig("order") + arg1_10.id / 100000
		local var4_10 = getProxy(CollectionProxy)

		local function var5_10(arg0_11)
			local var0_11 = arg0_11:getConfig("commodity_id")

			return arg0_11:isSham() and arg0_11:checkCommodityType(DROP_TYPE_SHIP) and var4_10:getShipGroup(var1_8(var0_11))
		end

		local function var6_10(arg0_12)
			return not arg0_12:canPurchase()
		end

		var2_10 = var5_10(arg0_10) and not var6_10(arg0_10) and var2_10 + var0_10 or var2_10
		var3_10 = var5_10(arg1_10) and not var6_10(arg1_10) and var3_10 + var0_10 or var3_10
		var2_10 = var6_10(arg0_10) and var2_10 + var1_10 or var2_10
		var3_10 = var6_10(arg1_10) and var3_10 + var1_10 or var3_10

		return var2_10 < var3_10
	end)

	return var0_8
end

function var0_0.getGoodsCfg(arg0_13, arg1_13)
	return pg.activity_shop_template[arg1_13]
end

function var0_0.getGoodsById(arg0_14, arg1_14)
	return arg0_14.goods[arg1_14]
end

function var0_0.bindConfigTable(arg0_15)
	return pg.month_shop_template
end

return var0_0
