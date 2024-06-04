local var0 = class("BaseCommodity", import("...BaseVO"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg1.goods_id or arg1.shop_id or arg1.id
	arg0.configId = arg0.id
	arg0.discount = arg1.discount or 100
	arg0.buyCount = arg1.buy_count or arg1.count or arg1.pay_count or 0

	assert(arg2, "type should exist")

	arg0.type = arg2
	arg0.groupCount = arg1.groupCount or 0
end

function var0.bindConfigTable(arg0)
	assert(false, "overwrite!!!")
end

function var0.GetPrice(arg0)
	assert(false, "overwrite!!!")
end

function var0.GetPurchasableCnt(arg0)
	assert(false, "overwrite!!!")
end

function var0.GetName(arg0)
	assert(false, "overwrite!!!")
end

function var0.GetDropList(arg0)
	assert(false, "overwrite!!!")
end

function var0.GetResType(arg0)
	assert(false, "overwrite!!!")
end

function var0.reduceBuyCount(arg0)
	arg0.buyCount = arg0.buyCount - 1
end

function var0.increaseBuyCount(arg0)
	if not arg0.buyCount then
		arg0.buyCount = 0
	end

	arg0.buyCount = arg0.buyCount + 1
end

function var0.addBuyCount(arg0, arg1)
	arg0.buyCount = arg0.buyCount + arg1
end

function var0.canPurchase(arg0)
	return arg0.buyCount > 0
end

function var0.hasDiscount(arg0)
	return arg0.discount < 100
end

function var0.isFree(arg0)
	return arg0:getConfig("discount") == 100
end

function var0.isDisCount(arg0)
	return false
end

function var0.isChargeType(arg0)
	return false
end

function var0.isGiftPackage(arg0)
	return arg0.type == Goods.TYPE_GIFT_PACKAGE
end

function var0.isSham(arg0)
	return arg0.type == Goods.TYPE_SHAM_BATTLE
end

function var0.IsActivityExtra(arg0)
	return arg0.type == Goods.TYPE_ACTIVITY_EXTRA
end

function var0.getKey(arg0)
	return arg0.id .. "_" .. arg0.type
end

function var0.updateBuyCount(arg0, arg1)
	arg0.buyCount = arg1
end

function var0.updateGroupCount(arg0, arg1)
	arg0.groupCount = arg1
end

function var0.firstPayDouble(arg0)
	return false
end

function var0.inTime(arg0)
	if arg0.type == Goods.TYPE_NEW_SERVER then
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

		if var0 and not var0:isEnd() then
			return true, var0.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
		else
			return false
		end
	end

	local var1 = arg0:getConfig("time")

	if not var1 then
		return true
	end

	if type(var1) == "string" then
		return var1 == "always"
	else
		local var2, var3 = arg0:getTimeStamp()

		if var2 and var3 then
			local var4 = pg.TimeMgr.GetInstance():GetServerTime()

			return var2 <= var4 and var4 <= var3, var3 - var4
		else
			return true
		end
	end
end

function var0.getTimeStamp(arg0)
	local var0 = arg0:getConfig("time")

	if var0 and type(var0) == "table" then
		local var1
		local var2

		if #var0 > 0 then
			local var3 = var0[1][1][1] .. "-" .. var0[1][1][2] .. "-" .. var0[1][1][3] .. " " .. var0[1][2][1] .. ":" .. var0[1][2][2] .. ":" .. var0[1][2][3]

			var1 = pg.TimeMgr.GetInstance():ParseTimeEx(var3, nil, true)
		end

		if #var0 > 1 then
			local var4 = var0[2][1][1] .. "-" .. var0[2][1][2] .. "-" .. var0[2][1][3] .. " " .. var0[2][2][1] .. ":" .. var0[2][2][2] .. ":" .. var0[2][2][3]

			var2 = pg.TimeMgr.GetInstance():ParseTimeEx(var4, nil, true)
		end

		if var1 and var2 then
			return var1, var2
		end
	end
end

function var0.calDayLeft(arg0)
	local var0, var1 = arg0:inTime()

	if var0 and var1 and var1 > 0 then
		local var2 = pg.TimeMgr.GetInstance():parseTimeFrom(var1)

		return var0, var2 + 1
	end
end

function var0.GetGiftList(arg0)
	return {}
end

function var0.GetName(arg0)
	assert(false, "overwrite me !!!!")
end

function var0.IsGroupLimit(arg0)
	assert(false, "overwrite me !!!!")
end

function var0.CanUseVoucherType(arg0)
	return false
end

function var0.StaticCanUseVoucherType(arg0, arg1)
	return false
end

return var0
