local var0_0 = class("RecommendCommodity", import("model.vo.BaseVO"))
local var1_0 = 1
local var2_0 = 2

var0_0.PRICE_TYPE_RMB = 1
var0_0.PRICE_TYPE_RES = 2

local function var3_0(arg0_1)
	local var0_1

	if arg0_1 == var1_0 then
		var0_1 = Goods.TYPE_CHARGE
	elseif arg0_1 == var2_0 then
		var0_1 = Goods.TYPE_GIFT_PACKAGE
	end

	assert(var0_1)

	return var0_1
end

local function var4_0(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = {}

	if arg0_2 == var1_0 then
		var0_2 = arg2_2
	elseif arg0_2 == var2_0 then
		var0_2 = arg3_2
	end

	return (ChargeConst.getBuyCount(var0_2, arg1_2))
end

local function var5_0(arg0_3, arg1_3, arg2_3)
	if arg0_3 == var1_0 then
		return 0
	elseif arg0_3 == var2_0 then
		return (ChargeConst.getGroupLimit(arg2_3, arg1_3 or 0))
	end
end

function var0_0.Ctor(arg0_4, arg1_4)
	arg0_4.id = arg1_4.id
	arg0_4.configId = arg0_4.id
	arg0_4.commodity = arg0_4:GenCommodity(arg1_4.chargedList, arg1_4.normalList, arg1_4.normalGroupList)
end

function var0_0.GenCommodity(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5:getConfig("shop_type")
	local var1_5 = arg0_5:getConfig("shop_id")
	local var2_5 = var3_0(var0_5)
	local var3_5 = Goods.Create({
		id = var1_5
	}, var2_5)
	local var4_5 = var4_0(var0_5, arg0_5:getConfig("shop_id"), arg1_5, arg2_5)

	var3_5:updateBuyCount(var4_5)

	if not var3_5:isChargeType() then
		local var5_5 = var5_0(var0_5, var3_5:getConfig("group"), arg3_5)

		var3_5:updateGroupCount(var5_5)
	end

	return var3_5
end

function var0_0.bindConfigTable(arg0_6)
	return pg.recommend_shop
end

function var0_0.GetName(arg0_7)
	return arg0_7.commodity:GetName() or ""
end

function var0_0.GetDesc(arg0_8)
	if arg0_8.commodity:isChargeType() then
		if arg0_8.commodity:isMonthCard() then
			return i18n("monthly_card_tip")
		else
			return arg0_8.commodity:getConfig("descrip")
		end
	else
		return arg0_8.commodity:getDropInfo():getConfig("display")
	end
end

function var0_0.GetDropList(arg0_9)
	if arg0_9.commodity:isChargeType() and arg0_9.commodity:isMonthCard() then
		return arg0_9.commodity:GetDropList()
	else
		return {}
	end
end

function var0_0.GetGem(arg0_10)
	if arg0_10.commodity:isChargeType() then
		return arg0_10.commodity:GetGemCnt()
	else
		return 0
	end
end

function var0_0.GetPrice(arg0_11)
	if arg0_11.commodity:isChargeType() then
		local var0_11 = arg0_11.commodity:getConfig("money")

		return var0_0.PRICE_TYPE_RMB, var0_11
	else
		local var1_11 = arg0_11.commodity:GetPrice()
		local var2_11 = arg0_11.commodity:GetResType()

		return var0_0.PRICE_TYPE_RES, var1_11, var2_11
	end
end

function var0_0.GetIcon(arg0_12)
	local var0_12 = arg0_12:getConfig("pic")

	if var0_12 and var0_12 ~= "" then
		return var0_12
	elseif arg0_12.commodity:isChargeType() then
		local var1_12 = arg0_12.commodity:getConfig("picture")

		return "ChargeIcon/" .. var1_12
	else
		return arg0_12.commodity:getDropInfo():getIcon() or ""
	end
end

function var0_0.InTime(arg0_13)
	local var0_13 = arg0_13:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0_13)
end

function var0_0.GetOrder(arg0_14)
	return arg0_14:getConfig("order")
end

function var0_0.CanPurchase(arg0_15)
	local function var0_15(arg0_16)
		if arg0_16:isChargeType() then
			return false
		end

		return arg0_15.commodity:IsGroupLimit()
	end

	return arg0_15:InTime() and arg0_15.commodity:canPurchase() and arg0_15.commodity:inTime() and not var0_15(arg0_15.commodity)
end

function var0_0.CanShow(arg0_17)
	if arg0_17:IsMonthCard() then
		return true
	else
		return arg0_17:CanPurchase()
	end
end

function var0_0.IsMonthCard(arg0_18)
	return arg0_18.commodity:isChargeType() and arg0_18.commodity:isMonthCard()
end

function var0_0.IsMonthCardAndCantPurchase(arg0_19)
	if arg0_19:IsMonthCard() then
		local var0_19 = getProxy(PlayerProxy):getRawData():getCardById(VipCard.MONTH)

		if var0_19 and var0_19:GetLeftDay() > (arg0_19.commodity:getConfig("limit_arg") or 0) then
			local var1_19 = i18n("charge_menu_month_tip", var0_19:GetLeftDay())

			return true, var1_19
		else
			return false
		end
	end

	return false
end

function var0_0.GetRealCommodity(arg0_20)
	return arg0_20.commodity
end

return var0_0
