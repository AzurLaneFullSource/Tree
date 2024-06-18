local var0_0 = class("BaseShop", import("..BaseVO"))

function var0_0.IsSameKind(arg0_1, arg1_1)
	assert(false)
end

function var0_0.GetCommodityById(arg0_2, arg1_2)
	assert(false)
end

function var0_0.GetCommodities(arg0_3)
	assert(false)
end

function var0_0.IsPurchaseAll(arg0_4)
	local var0_4 = arg0_4:GetCommodities()

	for iter0_4, iter1_4 in pairs(var0_4) do
		if iter1_4:canPurchase() then
			return false
		end
	end

	return true
end

return var0_0
