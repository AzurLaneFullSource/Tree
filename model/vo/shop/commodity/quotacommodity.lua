local var0_0 = class("QuotaCommodity", import(".BaseCommodity"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_shop_template
end

function var0_0.canPurchase(arg0_2)
	return arg0_2:GetPurchasableCnt() > 0
end

function var0_0.GetPurchasableCnt(arg0_3)
	return math.max(arg0_3:GetLimitGoodCount() - arg0_3:GetOwnedGoodCount(), 0)
end

function var0_0.GetOwnedGoodCount(arg0_4)
	return Drop.New({
		id = arg0_4:getConfig("commodity_id"),
		type = arg0_4:getConfig("commodity_type"),
		count = arg0_4:getConfig("num")
	}):getOwnedCount()
end

function var0_0.GetLimitGoodCount(arg0_5)
	local var0_5 = arg0_5:getConfig("limit_args")

	if type(var0_5) == "table" then
		for iter0_5, iter1_5 in ipairs(var0_5) do
			if iter1_5[1] == "quota" then
				return iter1_5[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with id: " .. arg0_5.id)
end

return var0_0
