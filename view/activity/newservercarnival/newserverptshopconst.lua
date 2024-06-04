NewServerPTShopConst = {}

local var0 = NewServerPTShopConst

var0.ConfigTable = pg.newserver_shop_template

function var0.GetActivity()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)

	if var0 and not var0:isEnd() then
		return var0
	end
end

var0.GoodStatu = {
	OnSell = 1,
	Locked = 2,
	SellOut = 3
}

function var0.GetGoodStatu(arg0, arg1)
	arg1 = arg1 or var0.GetActivity()

	if var0.isGoodOnSell(arg0, arg1) then
		return var0.GoodStatu.OnSell
	elseif var0.isGoodSellOut(arg0, arg1) then
		return var0.GoodStatu.SellOut
	elseif var0.isGoodLocked(arg0, arg1) then
		return var0.GoodStatu.Locked
	end
end

function var0.isGoodOnSell(arg0, arg1)
	local var0 = var0.isGoodInTime(arg0, arg1)
	local var1 = arg0:isLeftCount()

	return var0 and var1
end

function var0.isGoodSellOut(arg0, arg1)
	local var0 = var0.isGoodInTime(arg0, arg1)
	local var1 = not arg0:isLeftCount()

	return var0 and var1
end

function var0.isGoodLocked(arg0, arg1)
	return not var0.isGoodInTime(arg0, arg1)
end

function var0.GetAllGoodVOList(arg0)
	arg0 = arg0 or var0.GetActivity()

	local var0 = {}
	local var1 = arg0.data2KeyValueList

	for iter0, iter1 in pairs(var1) do
		local var2 = NewServerPTGood.New(iter0)

		var2:updateAllInfo(arg0)
		table.insert(var0, var2)
	end

	return var0
end

function var0.GetGoodVOListByIndex(arg0, arg1, arg2)
	arg1 = arg1 or var0.GetActivity()
	arg2 = arg2 or var0.GetAllGoodVOList()

	local var0 = {}

	for iter0, iter1 in ipairs(arg2) do
		if iter1:getUnlockIndex() == arg0 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.SortGoodVOList(arg0, arg1)
	arg1 = arg1 or var0.GetActivity()

	local var0 = function(arg0, arg1)
		local var0 = arg0:getUnlockIndex()
		local var1 = arg1:getUnlockIndex()
		local var2 = var0.GetGoodStatu(arg0, arg1)
		local var3 = var0.GetGoodStatu(arg1, arg1)

		if var0 < var1 then
			return true
		elseif var1 < var0 then
			return false
		elseif var0 == var1 then
			if var2 < var3 then
				return true
			elseif var3 < var2 then
				return false
			elseif var2 == var3 then
				return arg0.configID < arg1.configID
			end
		end
	end

	table.sort(arg0, var0)

	return arg0
end

function var0.GetStartTime(arg0)
	arg0 = arg0 or var0.GetActivity()

	return arg0.stopTime - 1814400
end

function var0.GetSecSinceStart(arg0)
	arg0 = arg0 or var0.GetActivity()

	return pg.TimeMgr.GetInstance():GetServerTime() - var0.GetStartTime(arg0)
end

function var0.isGoodInTime(arg0, arg1)
	arg1 = arg1 or var0.GetActivity()

	return var0.GetSecSinceStart(arg1) >= arg0:getConfig("unlock_time")
end

return var0
