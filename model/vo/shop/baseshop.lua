local var0 = class("BaseShop", import("..BaseVO"))

function var0.IsSameKind(arg0, arg1)
	assert(false)
end

function var0.GetCommodityById(arg0, arg1)
	assert(false)
end

function var0.GetCommodities(arg0)
	assert(false)
end

function var0.IsPurchaseAll(arg0)
	local var0 = arg0:GetCommodities()

	for iter0, iter1 in pairs(var0) do
		if iter1:canPurchase() then
			return false
		end
	end

	return true
end

return var0
