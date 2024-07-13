local var0_0 = class("BaseCommodity", import("...BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.goods_id or arg1_1.shop_id or arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.discount = arg1_1.discount or 100
	arg0_1.buyCount = arg1_1.buy_count or arg1_1.count or arg1_1.pay_count or 0

	assert(arg2_1, "type should exist")

	arg0_1.type = arg2_1
	arg0_1.groupCount = arg1_1.groupCount or 0
end

function var0_0.bindConfigTable(arg0_2)
	assert(false, "overwrite!!!")
end

function var0_0.GetPrice(arg0_3)
	assert(false, "overwrite!!!")
end

function var0_0.GetPurchasableCnt(arg0_4)
	assert(false, "overwrite!!!")
end

function var0_0.GetName(arg0_5)
	assert(false, "overwrite!!!")
end

function var0_0.GetDropList(arg0_6)
	assert(false, "overwrite!!!")
end

function var0_0.GetResType(arg0_7)
	assert(false, "overwrite!!!")
end

function var0_0.reduceBuyCount(arg0_8)
	arg0_8.buyCount = arg0_8.buyCount - 1
end

function var0_0.increaseBuyCount(arg0_9)
	if not arg0_9.buyCount then
		arg0_9.buyCount = 0
	end

	arg0_9.buyCount = arg0_9.buyCount + 1
end

function var0_0.addBuyCount(arg0_10, arg1_10)
	arg0_10.buyCount = arg0_10.buyCount + arg1_10
end

function var0_0.canPurchase(arg0_11)
	return arg0_11.buyCount > 0
end

function var0_0.hasDiscount(arg0_12)
	return arg0_12.discount < 100
end

function var0_0.isFree(arg0_13)
	return arg0_13:getConfig("discount") == 100
end

function var0_0.isDisCount(arg0_14)
	return false
end

function var0_0.isChargeType(arg0_15)
	return false
end

function var0_0.isGiftPackage(arg0_16)
	return arg0_16.type == Goods.TYPE_GIFT_PACKAGE
end

function var0_0.isSham(arg0_17)
	return arg0_17.type == Goods.TYPE_SHAM_BATTLE
end

function var0_0.IsActivityExtra(arg0_18)
	return arg0_18.type == Goods.TYPE_ACTIVITY_EXTRA
end

function var0_0.getKey(arg0_19)
	return arg0_19.id .. "_" .. arg0_19.type
end

function var0_0.updateBuyCount(arg0_20, arg1_20)
	arg0_20.buyCount = arg1_20
end

function var0_0.updateGroupCount(arg0_21, arg1_21)
	arg0_21.groupCount = arg1_21
end

function var0_0.firstPayDouble(arg0_22)
	return false
end

function var0_0.inTime(arg0_23)
	if arg0_23.type == Goods.TYPE_NEW_SERVER then
		local var0_23 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

		if var0_23 and not var0_23:isEnd() then
			return true, var0_23.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
		else
			return false
		end
	end

	local var1_23 = arg0_23:getConfig("time")

	if not var1_23 then
		return true
	end

	if type(var1_23) == "string" then
		return var1_23 == "always"
	else
		local var2_23, var3_23 = arg0_23:getTimeStamp()

		if var2_23 and var3_23 then
			local var4_23 = pg.TimeMgr.GetInstance():GetServerTime()

			return var2_23 <= var4_23 and var4_23 <= var3_23, var3_23 - var4_23
		else
			return true
		end
	end
end

function var0_0.getTimeStamp(arg0_24)
	local var0_24 = arg0_24:getConfig("time")

	if var0_24 and type(var0_24) == "table" then
		local var1_24
		local var2_24

		if #var0_24 > 0 then
			local var3_24 = var0_24[1][1][1] .. "-" .. var0_24[1][1][2] .. "-" .. var0_24[1][1][3] .. " " .. var0_24[1][2][1] .. ":" .. var0_24[1][2][2] .. ":" .. var0_24[1][2][3]

			var1_24 = pg.TimeMgr.GetInstance():ParseTimeEx(var3_24, nil, true)
		end

		if #var0_24 > 1 then
			local var4_24 = var0_24[2][1][1] .. "-" .. var0_24[2][1][2] .. "-" .. var0_24[2][1][3] .. " " .. var0_24[2][2][1] .. ":" .. var0_24[2][2][2] .. ":" .. var0_24[2][2][3]

			var2_24 = pg.TimeMgr.GetInstance():ParseTimeEx(var4_24, nil, true)
		end

		if var1_24 and var2_24 then
			return var1_24, var2_24
		end
	end
end

function var0_0.calDayLeft(arg0_25)
	local var0_25, var1_25 = arg0_25:inTime()

	if var0_25 and var1_25 and var1_25 > 0 then
		local var2_25 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_25)

		return var0_25, var2_25 + 1
	end
end

function var0_0.GetGiftList(arg0_26)
	return {}
end

function var0_0.GetName(arg0_27)
	assert(false, "overwrite me !!!!")
end

function var0_0.IsGroupLimit(arg0_28)
	assert(false, "overwrite me !!!!")
end

function var0_0.CanUseVoucherType(arg0_29)
	return false
end

function var0_0.StaticCanUseVoucherType(arg0_30, arg1_30)
	return false
end

return var0_0
