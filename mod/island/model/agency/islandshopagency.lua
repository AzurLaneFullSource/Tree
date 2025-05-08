local var0_0 = class("IslandShopAgency", import(".IslandBaseAgency"))
local var1_0 = pg.island_shop_template
local var2_0 = pg.island_shop_goods
local var3_0 = pg.island_shop_normal_template

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.shop_list

	arg0_1:SetShops(var0_1)
end

function var0_0.SetShops(arg0_2, arg1_2)
	arg0_2.shops = {}
	arg0_2.shopIds = {}

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		local var0_2 = IslandShopp.New(iter1_2, arg0_2:GetHost())

		table.insert(arg0_2.shops, var0_2)
		table.insert(arg0_2.shopIds, iter1_2.id)
	end
end

function var0_0.IsShowShop(arg0_3, arg1_3)
	return table.contains(arg0_3.shopIds, arg1_3)
end

function var0_0.GetShopById(arg0_4, arg1_4)
	if not arg0_4:IsShowShop(arg1_4) then
		return nil
	end

	for iter0_4, iter1_4 in ipairs(arg0_4.shops) do
		if iter1_4.id == arg1_4 then
			return iter1_4
		end
	end
end

function var0_0.GetShopCommodity(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GetShopById(arg1_5)

	if var0_5 then
		return var0_5:GetCommodityById(arg2_5)
	end
end

function var0_0.RefreshShopData(arg0_6, arg1_6)
	arg0_6:sendNotification(GAME.ISLAND_SHOP_OP, {
		operation = IslandConst.SHOP_GET_DATA,
		shopId = arg1_6
	})
end

function var0_0.UpdateShop(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:GetShopById(arg1_7)

	if var0_7 then
		if arg2_7 ~= nil then
			var0_7:UpdateData(arg2_7)
		else
			table.remove(arg0_7.shops, var0_7)
			table.remove(arg0_7.shopIds, arg1_7)
		end
	elseif arg2_7 ~= nil then
		local var1_7 = IslandShopp.New(arg2_7, arg0_7:GetHost())

		table.insert(arg0_7.shops, var1_7)
		table.insert(arg0_7.shopIds, arg2_7.id)
	end
end

function var0_0.UpdateShopCommodity(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg0_8:GetShopById(arg1_8)

	if var0_8 then
		var0_8:UpdateCommodity(arg2_8, arg3_8)
	end
end

function var0_0.GetSortedShopConfigs(arg0_9, arg1_9)
	table.sort(arg1_9, function(arg0_10, arg1_10)
		return arg0_10.order < arg1_10.order
	end)

	return arg1_9
end

function var0_0.ShouldShowFirstShop(arg0_11, arg1_11, arg2_11)
	if arg1_11.shop_type ~= 0 and arg0_11:IsShowShop(arg1_11.id) and table.contains(arg2_11, arg1_11.show_type) then
		return true
	end

	for iter0_11, iter1_11 in ipairs(arg0_11.shops) do
		if iter1_11:GetFirstShopId() == arg1_11.id and table.contains(arg2_11, iter1_11:GetShowType()) then
			return true
		end
	end

	return false
end

function var0_0.ShouldShowSecondShop(arg0_12, arg1_12, arg2_12)
	if arg1_12.shop_type ~= 0 and arg0_12:IsShowShop(arg1_12.id) and table.contains(arg2_12, arg1_12.show_type) then
		return true
	end

	for iter0_12, iter1_12 in ipairs(arg0_12.shops) do
		if iter1_12:GetSecondShopId() == arg1_12.id and table.contains(arg2_12, iter1_12:GetShowType()) then
			return true
		end
	end

	return false
end

function var0_0.GetFirstShopConfigs(arg0_13, arg1_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(var1_0.all) do
		local var1_13 = var1_0[iter1_13]

		if var1_13.tag_type == 1 and arg0_13:ShouldShowFirstShop(var1_13, arg1_13) then
			table.insert(var0_13, var1_13)
		end
	end

	return arg0_13:GetSortedShopConfigs(var0_13)
end

function var0_0.GetSecondShopConfigs(arg0_14, arg1_14, arg2_14)
	local var0_14 = {}

	if arg2_14 == 0 then
		return var0_14
	end

	for iter0_14, iter1_14 in ipairs(var1_0.get_id_list_by_first_shop[arg2_14]) do
		local var1_14 = var1_0[iter1_14]

		if var1_14.tag_type == 2 and arg0_14:ShouldShowSecondShop(var1_14, arg1_14) then
			table.insert(var0_14, var1_14)
		end
	end

	return arg0_14:GetSortedShopConfigs(var0_14)
end

function var0_0.GetThirdShopConfigs(arg0_15, arg1_15, arg2_15)
	local var0_15 = {}

	if arg2_15 == 0 then
		return var0_15
	end

	for iter0_15, iter1_15 in ipairs(var1_0.get_id_list_by_second_shop[arg2_15]) do
		local var1_15 = var1_0[iter1_15]

		if var1_15.tag_type == 3 and arg0_15:IsShowShop(iter1_15) and table.contains(arg1_15, var1_15.show_type) then
			table.insert(var0_15, var1_15)
		end
	end

	return arg0_15:GetSortedShopConfigs(var0_15)
end

function var0_0.GetInitShowingShop(arg0_16, arg1_16)
	local var0_16
	local var1_16 = arg0_16:GetFirstShopConfigs(arg1_16)[1]

	if var1_16.shop_type == 0 then
		local var2_16 = arg0_16:GetSecondShopConfigs(arg1_16, var1_16.id)[1]

		if var2_16.shop_type == 0 then
			var0_16 = arg0_16:GetThirdShopConfigs(arg1_16, var2_16.id)[1]
		else
			var0_16 = var2_16
		end
	else
		var0_16 = var1_16
	end

	if var0_16 then
		return arg0_16:GetShopById(var0_16.id)
	else
		return nil
	end
end

function var0_0.GetNewOrOverdueShopIds(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(var3_0.all) do
		local var1_17 = var3_0[iter1_17]
		local var2_17 = pg.TimeMgr.GetInstance():inTime(var1_17.exist_time)

		if arg0_17:IsShowShop(iter1_17) and not var2_17 or not arg0_17:IsShowShop(iter1_17) and var2_17 then
			table.insert(var0_17, iter1_17)
		end
	end

	for iter2_17, iter3_17 in ipairs(arg0_17.shops) do
		if not (pg.TimeMgr.GetInstance():GetServerTime() < iter3_17.existTime) then
			table.insert(var0_17, iter3_17.id)
		end
	end

	return var0_17
end

return var0_0
