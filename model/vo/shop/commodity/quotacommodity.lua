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
	return arg0_4:getDropInfo():getOwnedCount()
end

function var0_0.getDropInfo(arg0_5)
	return Drop.New({
		type = arg0_5:getConfig("commodity_type"),
		id = arg0_5:getConfig("commodity_id"),
		count = arg0_5:getConfig("num")
	})
end

function var0_0.GetLimitGoodCount(arg0_6)
	local var0_6 = arg0_6:getConfig("limit_args")

	if type(var0_6) == "table" then
		for iter0_6, iter1_6 in ipairs(var0_6) do
			if iter1_6[1] == "quota" then
				return iter1_6[2]
			end
		end
	end

	assert(false, "good not limit_args 'quota' with id: " .. arg0_6.id)
end

return var0_0
