local var0 = class("QuotaCommodity", import(".BaseCommodity"))

function var0.bindConfigTable(arg0)
	return pg.activity_shop_template
end

function var0.canPurchase(arg0)
	return arg0:GetPurchasableCnt() > 0
end

function var0.GetPurchasableCnt(arg0)
	return arg0:GetLimitGoodCount() - arg0.buyCount
end

function var0.GetLimitGoodCount(arg0)
	local var0 = arg0:getConfig("limit_args")

	if type(var0) == "table" then
		for iter0, iter1 in ipairs(var0) do
			if iter1[1] == "quota" then
				return iter1[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with id: " .. arg0.id)
end

return var0
