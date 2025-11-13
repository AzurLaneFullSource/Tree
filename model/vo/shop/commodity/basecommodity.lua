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

function var0_0.isTip(arg0_14)
	return false
end

function var0_0.isDisCount(arg0_15)
	return false
end

function var0_0.isChargeType(arg0_16)
	return false
end

function var0_0.isGiftPackage(arg0_17)
	return arg0_17.type == Goods.TYPE_GIFT_PACKAGE
end

function var0_0.isActGiftPackage(arg0_18)
	return arg0_18.type == Goods.TYPE_GIFT_PACKAGE_ACT
end

function var0_0.isSham(arg0_19)
	return arg0_19.type == Goods.TYPE_SHAM_BATTLE
end

function var0_0.IsActivityExtra(arg0_20)
	return arg0_20.type == Goods.TYPE_ACTIVITY_EXTRA
end

function var0_0.getKey(arg0_21)
	return arg0_21.id .. "_" .. arg0_21.type
end

function var0_0.updateBuyCount(arg0_22, arg1_22)
	arg0_22.buyCount = arg1_22
end

function var0_0.updateGroupCount(arg0_23, arg1_23)
	arg0_23.groupCount = arg1_23
end

function var0_0.firstPayDouble(arg0_24)
	return false
end

function var0_0.inTime(arg0_25)
	if arg0_25.type == Goods.TYPE_NEW_SERVER then
		local var0_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

		if var0_25 and not var0_25:isEnd() then
			return true, var0_25.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
		else
			return false
		end
	end

	local var1_25 = arg0_25:getConfig("time")

	if not var1_25 then
		return true
	end

	if type(var1_25) == "string" then
		return var1_25 == "always"
	else
		local var2_25, var3_25 = arg0_25:getTimeStamp()

		if var2_25 and var3_25 then
			local var4_25 = pg.TimeMgr.GetInstance():GetServerTime()

			return var2_25 <= var4_25 and var4_25 <= var3_25, var3_25 - var4_25
		else
			return true
		end
	end
end

function var0_0.getTimeStamp(arg0_26)
	local var0_26 = arg0_26:getConfig("time")

	if var0_26 and type(var0_26) == "table" then
		local var1_26
		local var2_26

		if #var0_26 > 0 then
			local var3_26 = var0_26[1][1][1] .. "-" .. var0_26[1][1][2] .. "-" .. var0_26[1][1][3] .. " " .. var0_26[1][2][1] .. ":" .. var0_26[1][2][2] .. ":" .. var0_26[1][2][3]

			var1_26 = pg.TimeMgr.GetInstance():ParseTimeEx(var3_26, nil, true)
		end

		if #var0_26 > 1 then
			local var4_26 = var0_26[2][1][1] .. "-" .. var0_26[2][1][2] .. "-" .. var0_26[2][1][3] .. " " .. var0_26[2][2][1] .. ":" .. var0_26[2][2][2] .. ":" .. var0_26[2][2][3]

			var2_26 = pg.TimeMgr.GetInstance():ParseTimeEx(var4_26, nil, true)
		end

		if var1_26 and var2_26 then
			return var1_26, var2_26
		end
	end
end

function var0_0.calDayLeft(arg0_27)
	local var0_27, var1_27 = arg0_27:inTime()

	if var0_27 and var1_27 and var1_27 > 0 then
		local var2_27 = pg.TimeMgr.GetInstance():parseTimeFrom(var1_27)

		return var0_27, var2_27 + 1
	end
end

function var0_0.GetGiftList(arg0_28)
	return {}
end

function var0_0.GetName(arg0_29)
	assert(false, "overwrite me !!!!")
end

function var0_0.IsGroupLimit(arg0_30)
	assert(false, "overwrite me !!!!")
end

function var0_0.CanUseVoucherType(arg0_31)
	return false
end

function var0_0.ExistExclusiveDiscountItem(arg0_32)
	return false
end

function var0_0.StaticCanUseVoucherType(arg0_33, arg1_33)
	return false
end

return var0_0
