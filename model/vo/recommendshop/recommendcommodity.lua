local var0 = class("RecommendCommodity", import("model.vo.BaseVO"))
local var1 = 1
local var2 = 2

var0.PRICE_TYPE_RMB = 1
var0.PRICE_TYPE_RES = 2

local function var3(arg0)
	local var0

	if arg0 == var1 then
		var0 = Goods.TYPE_CHARGE
	elseif arg0 == var2 then
		var0 = Goods.TYPE_GIFT_PACKAGE
	end

	assert(var0)

	return var0
end

local function var4(arg0, arg1, arg2, arg3)
	local var0 = {}

	if arg0 == var1 then
		var0 = arg2
	elseif arg0 == var2 then
		var0 = arg3
	end

	return (ChargeConst.getBuyCount(var0, arg1))
end

local function var5(arg0, arg1, arg2)
	if arg0 == var1 then
		return 0
	elseif arg0 == var2 then
		return (ChargeConst.getGroupLimit(arg2, arg1 or 0))
	end
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.commodity = arg0:GenCommodity(arg1.chargedList, arg1.normalList, arg1.normalGroupList)
end

function var0.GenCommodity(arg0, arg1, arg2, arg3)
	local var0 = arg0:getConfig("shop_type")
	local var1 = arg0:getConfig("shop_id")
	local var2 = var3(var0)
	local var3 = Goods.Create({
		id = var1
	}, var2)
	local var4 = var4(var0, arg0:getConfig("shop_id"), arg1, arg2)

	var3:updateBuyCount(var4)

	if not var3:isChargeType() then
		local var5 = var5(var0, var3:getConfig("group"), arg3)

		var3:updateGroupCount(var5)
	end

	return var3
end

function var0.bindConfigTable(arg0)
	return pg.recommend_shop
end

function var0.GetName(arg0)
	return arg0.commodity:GetName() or ""
end

function var0.GetDesc(arg0)
	if arg0.commodity:isChargeType() then
		if arg0.commodity:isMonthCard() then
			return i18n("monthly_card_tip")
		else
			return arg0.commodity:getConfig("descrip")
		end
	else
		return arg0.commodity:getDropInfo():getConfig("display")
	end
end

function var0.GetDropList(arg0)
	if arg0.commodity:isChargeType() and arg0.commodity:isMonthCard() then
		return arg0.commodity:GetDropList()
	else
		return {}
	end
end

function var0.GetGem(arg0)
	if arg0.commodity:isChargeType() then
		return arg0.commodity:GetGemCnt()
	else
		return 0
	end
end

function var0.GetPrice(arg0)
	if arg0.commodity:isChargeType() then
		local var0 = arg0.commodity:getConfig("money")

		return var0.PRICE_TYPE_RMB, var0
	else
		local var1 = arg0.commodity:GetPrice()
		local var2 = arg0.commodity:GetResType()

		return var0.PRICE_TYPE_RES, var1, var2
	end
end

function var0.GetIcon(arg0)
	local var0 = arg0:getConfig("pic")

	if var0 and var0 ~= "" then
		return var0
	elseif arg0.commodity:isChargeType() then
		local var1 = arg0.commodity:getConfig("picture")

		return "ChargeIcon/" .. var1
	else
		return arg0.commodity:getDropInfo():getIcon() or ""
	end
end

function var0.InTime(arg0)
	local var0 = arg0:getConfig("time")

	return pg.TimeMgr.GetInstance():inTime(var0)
end

function var0.GetOrder(arg0)
	return arg0:getConfig("order")
end

function var0.CanPurchase(arg0)
	local function var0(arg0)
		if arg0:isChargeType() then
			return false
		end

		return arg0.commodity:IsGroupLimit()
	end

	return arg0:InTime() and arg0.commodity:canPurchase() and arg0.commodity:inTime() and not var0(arg0.commodity)
end

function var0.CanShow(arg0)
	if arg0:IsMonthCard() then
		return true
	else
		return arg0:CanPurchase()
	end
end

function var0.IsMonthCard(arg0)
	return arg0.commodity:isChargeType() and arg0.commodity:isMonthCard()
end

function var0.IsMonthCardAndCantPurchase(arg0)
	if arg0:IsMonthCard() then
		local var0 = getProxy(PlayerProxy):getRawData():getCardById(VipCard.MONTH)

		if var0 and var0:GetLeftDay() > (arg0.commodity:getConfig("limit_arg") or 0) then
			local var1 = i18n("charge_menu_month_tip", var0:GetLeftDay())

			return true, var1
		else
			return false
		end
	end

	return false
end

function var0.GetRealCommodity(arg0)
	return arg0.commodity
end

return var0
