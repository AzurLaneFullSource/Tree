NewServerPTShopConst = {}

local var0_0 = NewServerPTShopConst

var0_0.ConfigTable = pg.newserver_shop_template

function var0_0.GetActivity()
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)

	if var0_1 and not var0_1:isEnd() then
		return var0_1
	end
end

var0_0.GoodStatu = {
	OnSell = 1,
	Locked = 2,
	SellOut = 3
}

function var0_0.GetGoodStatu(arg0_2, arg1_2)
	arg1_2 = arg1_2 or var0_0.GetActivity()

	if var0_0.isGoodOnSell(arg0_2, arg1_2) then
		return var0_0.GoodStatu.OnSell
	elseif var0_0.isGoodSellOut(arg0_2, arg1_2) then
		return var0_0.GoodStatu.SellOut
	elseif var0_0.isGoodLocked(arg0_2, arg1_2) then
		return var0_0.GoodStatu.Locked
	end
end

function var0_0.isGoodOnSell(arg0_3, arg1_3)
	local var0_3 = var0_0.isGoodInTime(arg0_3, arg1_3)
	local var1_3 = arg0_3:isLeftCount()

	return var0_3 and var1_3
end

function var0_0.isGoodSellOut(arg0_4, arg1_4)
	local var0_4 = var0_0.isGoodInTime(arg0_4, arg1_4)
	local var1_4 = not arg0_4:isLeftCount()

	return var0_4 and var1_4
end

function var0_0.isGoodLocked(arg0_5, arg1_5)
	return not var0_0.isGoodInTime(arg0_5, arg1_5)
end

function var0_0.GetAllGoodVOList(arg0_6)
	arg0_6 = arg0_6 or var0_0.GetActivity()

	local var0_6 = {}
	local var1_6 = arg0_6.data2KeyValueList

	for iter0_6, iter1_6 in pairs(var1_6) do
		local var2_6 = NewServerPTGood.New(iter0_6)

		var2_6:updateAllInfo(arg0_6)
		table.insert(var0_6, var2_6)
	end

	return var0_6
end

function var0_0.GetGoodVOListByIndex(arg0_7, arg1_7, arg2_7)
	arg1_7 = arg1_7 or var0_0.GetActivity()
	arg2_7 = arg2_7 or var0_0.GetAllGoodVOList()

	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs(arg2_7) do
		if iter1_7:getUnlockIndex() == arg0_7 then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.SortGoodVOList(arg0_8, arg1_8)
	arg1_8 = arg1_8 or var0_0.GetActivity()

	local function var0_8(arg0_9, arg1_9)
		local var0_9 = arg0_9:getUnlockIndex()
		local var1_9 = arg1_9:getUnlockIndex()
		local var2_9 = var0_0.GetGoodStatu(arg0_9, arg1_8)
		local var3_9 = var0_0.GetGoodStatu(arg1_9, arg1_8)

		if var0_9 < var1_9 then
			return true
		elseif var1_9 < var0_9 then
			return false
		elseif var0_9 == var1_9 then
			if var2_9 < var3_9 then
				return true
			elseif var3_9 < var2_9 then
				return false
			elseif var2_9 == var3_9 then
				return arg0_9.configID < arg1_9.configID
			end
		end
	end

	table.sort(arg0_8, var0_8)

	return arg0_8
end

function var0_0.GetStartTime(arg0_10)
	arg0_10 = arg0_10 or var0_0.GetActivity()

	return arg0_10.stopTime - 1814400
end

function var0_0.GetSecSinceStart(arg0_11)
	arg0_11 = arg0_11 or var0_0.GetActivity()

	return pg.TimeMgr.GetInstance():GetServerTime() - var0_0.GetStartTime(arg0_11)
end

function var0_0.isGoodInTime(arg0_12, arg1_12)
	arg1_12 = arg1_12 or var0_0.GetActivity()

	return var0_0.GetSecSinceStart(arg1_12) >= arg0_12:getConfig("unlock_time")
end

return var0_0
