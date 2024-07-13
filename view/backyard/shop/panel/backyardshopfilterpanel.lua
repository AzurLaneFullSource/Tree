local var0_0 = class("BackYardShopFilterPanel", import("...Decoration.panles.BackYardDecorationFilterPanel"))

function var0_0.SortForDecorate(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg2_1[1]
	local var1_1 = arg2_1[2]
	local var2_1 = arg2_1[3]

	local function var3_1(arg0_2)
		if arg0_2:getConfig("new") == -1 then
			return 0
		elseif arg0_2:canPurchaseByGem() and not arg0_2:canPurchaseByDormMoeny() then
			return 1
		elseif arg0_2:canPurchaseByGem() and arg0_2:canPurchaseByDormMoeny() then
			return 3
		elseif arg0_2:canPurchaseByDormMoeny() then
			return 4
		else
			return 5
		end
	end

	local function var4_1(arg0_3)
		local var0_3 = pg.furniture_shop_template[arg0_3.configId].time

		if arg0_3:getConfig("new") > 0 then
			return 4
		elseif var0_3 ~= "always" then
			return 3
		elseif var0_3 == "always" then
			return 2
		else
			return 1
		end
	end

	function var0_0.SortByDefault1(arg0_4, arg1_4)
		local var0_4 = var3_1(arg0_4)
		local var1_4 = var3_1(arg1_4)

		if var0_4 == var1_4 then
			local var2_4 = var4_1(arg0_4)
			local var3_4 = var4_1(arg1_4)

			if var2_4 == var3_4 then
				return arg0_4.id < arg1_4.id
			else
				return var2_4 < var3_4
			end
		else
			return var0_4 < var1_4
		end
	end

	function var0_0.SortByDefault2(arg0_5, arg1_5)
		local var0_5 = var3_1(arg0_5)
		local var1_5 = var3_1(arg1_5)

		if var0_5 == var1_5 then
			local var2_5 = var4_1(arg0_5)
			local var3_5 = var4_1(arg1_5)

			if var2_5 == var3_5 then
				return arg0_5.id > arg1_5.id
			else
				return var3_5 < var2_5
			end
		else
			return var0_5 < var1_5
		end
	end

	local var5_1 = arg0_1:canPurchase() and 1 or 0
	local var6_1 = arg1_1:canPurchase() and 1 or 0

	if var5_1 == var6_1 then
		if var0_1 == var0_0.SORT_MODE.BY_DEFAULT then
			return var0_0["SortByDefault" .. var2_1](arg0_1, arg1_1)
		elseif var0_1 == var0_0.SORT_MODE.BY_FUNC then
			return var0_0.SORT_BY_FUNC(arg0_1, arg1_1, var1_1, var2_1, function()
				return var0_0["SortByDefault" .. var2_1](arg0_1, arg1_1)
			end)
		elseif var0_1 == var0_0.SORT_MODE.BY_CONFIG then
			return var0_0.SORT_BY_CONFIG(arg0_1, arg1_1, var1_1, var2_1, function()
				return var0_0["SortByDefault" .. var2_1](arg0_1, arg1_1)
			end)
		end
	else
		return var6_1 < var5_1
	end
end

function var0_0.sort(arg0_8, arg1_8)
	table.sort(arg1_8, function(arg0_9, arg1_9)
		return var0_0.SortForDecorate(arg0_9, arg1_9, {
			arg0_8.sortData[1],
			arg0_8.sortData[2],
			arg0_8.orderMode
		})
	end)

	arg0_8.furnitures = arg1_8
end

return var0_0
