ChargeConst = {}

local var0_0 = ChargeConst

function var0_0.getBuyCount(arg0_1, arg1_1)
	if not arg0_1 then
		return 0
	end

	local var0_1 = arg0_1[arg1_1]

	return var0_1 and var0_1.buyCount or 0
end

function var0_0.getGroupLimit(arg0_2, arg1_2)
	if not arg0_2 then
		return 0
	end

	for iter0_2, iter1_2 in ipairs(arg0_2) do
		if iter1_2.shop_id == arg1_2 then
			return iter1_2.pay_count
		end
	end

	return 0
end

function var0_0.getGoodsLimitInfo(arg0_3)
	local var0_3
	local var1_3
	local var2_3
	local var3_3 = pg.shop_template[arg0_3]

	if var3_3 then
		local var4_3 = var3_3.limit_args[1]

		if type(var4_3) == "table" then
			for iter0_3, iter1_3 in ipairs(var3_3.limit_args) do
				local var5_3 = iter1_3[1]

				if var5_3 == "level" then
					var0_3 = iter1_3[2]
				elseif var5_3 == "count" then
					var1_3 = iter1_3[2]
					var2_3 = iter1_3[3]
				end
			end
		elseif type(var4_3) == "string" then
			if var4_3 == "level" then
				var0_3 = var3_3.limit_args[2]
			elseif var4_3 == "count" then
				var1_3 = var3_3.limit_args[2]
				var2_3 = var3_3.limit_args[3]
			end
		end
	end

	return var0_3, var1_3, var2_3
end

function var0_0.isNeedSetBirth()
	if PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetIsPlatform() and not pg.SdkMgr.GetInstance():GetIsBirthSet() then
		return true
	end

	return false
end

return var0_0
