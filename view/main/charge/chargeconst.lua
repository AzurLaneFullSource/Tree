ChargeConst = {}

local var0 = ChargeConst

function var0.getBuyCount(arg0, arg1)
	if not arg0 then
		return 0
	end

	local var0 = arg0[arg1]

	return var0 and var0.buyCount or 0
end

function var0.getGroupLimit(arg0, arg1)
	if not arg0 then
		return 0
	end

	for iter0, iter1 in ipairs(arg0) do
		if iter1.shop_id == arg1 then
			return iter1.pay_count
		end
	end

	return 0
end

function var0.getGoodsLimitInfo(arg0)
	local var0
	local var1
	local var2
	local var3 = pg.shop_template[arg0]

	if var3 then
		local var4 = var3.limit_args[1]

		if type(var4) == "table" then
			for iter0, iter1 in ipairs(var3.limit_args) do
				local var5 = iter1[1]

				if var5 == "level" then
					var0 = iter1[2]
				elseif var5 == "count" then
					var1 = iter1[2]
					var2 = iter1[3]
				end
			end
		elseif type(var4) == "string" then
			if var4 == "level" then
				var0 = var3.limit_args[2]
			elseif var4 == "count" then
				var1 = var3.limit_args[2]
				var2 = var3.limit_args[3]
			end
		end
	end

	return var0, var1, var2
end

function var0.isNeedSetBirth()
	if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetIsPlatform() and not pg.SdkMgr.GetInstance():GetIsBirthSet() then
		return true
	end

	return false
end

return var0
