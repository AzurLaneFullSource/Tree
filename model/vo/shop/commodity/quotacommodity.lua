local var0_0 = class("QuotaCommodity", import(".BaseCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_shop_template
end

function var0_0.canPurchase(arg0_2)
	return arg0_2:GetPurchasableCnt() > 0
end

function var0_0.GetPurchasableCnt(arg0_3)
	return arg0_3:GetLimitGoodCount() - arg0_3.buyCount
end

function var0_0.GetLimitGoodCount(arg0_4)
	local var0_4 = arg0_4:getConfig("limit_args")

	if type(var0_4) == "table" then
		for iter0_4, iter1_4 in ipairs(var0_4) do
			if iter1_4[1] == "quota" then
				return iter1_4[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with id: " .. arg0_4.id)
end

return var0_0
