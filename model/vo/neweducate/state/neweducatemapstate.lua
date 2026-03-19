local var0_0 = class("NewEducateMapState", import(".NewEducateStateBase"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.charId = arg1_1

	arg0_1:SetSiteState(arg2_1.state or {})

	arg0_1.events = arg2_1.events or {}

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg2_1.buys or {}) do
		var0_1[iter1_1.key] = iter1_1.value
	end

	local var1_1 = arg2_1.shops or {}

	arg0_1.goods = {}

	for iter2_1, iter3_1 in ipairs(var1_1) do
		arg0_1.goods[iter3_1] = NewEducateGoods.New(iter3_1, var0_1[iter3_1] or 0)
	end

	arg0_1.selectedShip = arg2_1.character_this_round or {}
	arg0_1.refreshShopCnt = arg2_1.refresh_count or 0
end

function var0_0.SetSiteState(arg0_2, arg1_2)
	if not arg1_2.key or arg1_2.key == 0 then
		arg0_2.curSiteId = 0
	end

	local var0_2 = 0
	local var1_2 = getProxy(NewEducateProxy):GetChar(arg0_2.charId)

	if arg1_2.key == NewEducateConst.SITE_STATE_TYPE.EVENT then
		arg0_2.curSiteId = var1_2:GetSiteId(NewEducateConst.SITE_TYPE.EVENT, arg1_2.value)
	elseif arg1_2.key == NewEducateConst.SITE_STATE_TYPE.NORMAL then
		local var2_2 = pg.child2_site_normal[arg1_2.value].type
		local var3_2 = NewEducateHelper.NormalType2SiteType(var2_2)

		arg0_2.curSiteId = var1_2:GetSiteId(var3_2)
	elseif arg1_2.key == NewEducateConst.SITE_STATE_TYPE.SHIP then
		arg0_2.curSiteId = var1_2:GetSiteId(NewEducateConst.SITE_TYPE.SHIP, arg1_2.value)
	elseif arg1_2.key == NewEducateConst.SITE_STATE_TYPE.SHOP then
		arg0_2.curSiteId = var1_2:GetSiteId(NewEducateConst.SITE_TYPE.SHOP)
	end
end

function var0_0.GetCurSiteId(arg0_3)
	return arg0_3.curSiteId
end

function var0_0.GetEvents(arg0_4)
	return arg0_4.events
end

function var0_0.FinishEvent(arg0_5, arg1_5)
	table.removebyvalue(arg0_5.events, arg1_5)
end

function var0_0.GetGoodList(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.goods) do
		table.insert(var0_6, iter1_6)
	end

	return var0_6
end

function var0_0.AddBuyCnt(arg0_7, arg1_7, arg2_7)
	arg0_7.goods[arg1_7]:AddBuyCnt(arg2_7)
end

function var0_0.AddSelectedShip(arg0_8, arg1_8)
	table.insert(arg0_8.selectedShip, arg1_8)
end

function var0_0.IsSelectedShip(arg0_9, arg1_9)
	return table.contains(arg0_9.selectedShip, arg1_9)
end

function var0_0.IsSpecial(arg0_10)
	return underscore.any(arg0_10.events, function(arg0_11)
		assert(pg.child2_site_event_group[arg0_11], "child2_site_event_group不存在id" .. arg0_11)

		return #pg.child2_site_event_group[arg0_11].performance > 0
	end)
end

function var0_0.GetRefreshShopCnt(arg0_12)
	return arg0_12.refreshShopCnt
end

function var0_0.OnRefreshShopDone(arg0_13, arg1_13, arg2_13)
	if arg2_13 then
		arg0_13.refreshShopCnt = arg0_13.refreshShopCnt + 1
	end

	arg0_13.goods = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		arg0_13.goods[iter1_13] = NewEducateGoods.New(iter1_13)
	end
end

function var0_0.IsFinish(arg0_14)
	return true
end

function var0_0.Reset(arg0_15)
	arg0_15.events = {}
	arg0_15.goods = {}
	arg0_15.selectedShip = {}
	arg0_15.refreshShopCnt = 0
end

return var0_0
