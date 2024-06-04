local var0 = class("BackYardShopFilterPanel", import("...Decoration.panles.BackYardDecorationFilterPanel"))

function var0.SortForDecorate(arg0, arg1, arg2)
	local var0 = arg2[1]
	local var1 = arg2[2]
	local var2 = arg2[3]

	local function var3(arg0)
		if arg0:getConfig("new") == -1 then
			return 0
		elseif arg0:canPurchaseByGem() and not arg0:canPurchaseByDormMoeny() then
			return 1
		elseif arg0:canPurchaseByGem() and arg0:canPurchaseByDormMoeny() then
			return 3
		elseif arg0:canPurchaseByDormMoeny() then
			return 4
		else
			return 5
		end
	end

	local function var4(arg0)
		local var0 = pg.furniture_shop_template[arg0.configId].time

		if arg0:getConfig("new") > 0 then
			return 4
		elseif var0 ~= "always" then
			return 3
		elseif var0 == "always" then
			return 2
		else
			return 1
		end
	end

	function var0.SortByDefault1(arg0, arg1)
		local var0 = var3(arg0)
		local var1 = var3(arg1)

		if var0 == var1 then
			local var2 = var4(arg0)
			local var3 = var4(arg1)

			if var2 == var3 then
				return arg0.id < arg1.id
			else
				return var2 < var3
			end
		else
			return var0 < var1
		end
	end

	function var0.SortByDefault2(arg0, arg1)
		local var0 = var3(arg0)
		local var1 = var3(arg1)

		if var0 == var1 then
			local var2 = var4(arg0)
			local var3 = var4(arg1)

			if var2 == var3 then
				return arg0.id > arg1.id
			else
				return var3 < var2
			end
		else
			return var0 < var1
		end
	end

	local var5 = arg0:canPurchase() and 1 or 0
	local var6 = arg1:canPurchase() and 1 or 0

	if var5 == var6 then
		if var0 == var0.SORT_MODE.BY_DEFAULT then
			return var0["SortByDefault" .. var2](arg0, arg1)
		elseif var0 == var0.SORT_MODE.BY_FUNC then
			return var0.SORT_BY_FUNC(arg0, arg1, var1, var2, function()
				return var0["SortByDefault" .. var2](arg0, arg1)
			end)
		elseif var0 == var0.SORT_MODE.BY_CONFIG then
			return var0.SORT_BY_CONFIG(arg0, arg1, var1, var2, function()
				return var0["SortByDefault" .. var2](arg0, arg1)
			end)
		end
	else
		return var6 < var5
	end
end

function var0.sort(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		return var0.SortForDecorate(arg0, arg1, {
			arg0.sortData[1],
			arg0.sortData[2],
			arg0.orderMode
		})
	end)

	arg0.furnitures = arg1
end

return var0
