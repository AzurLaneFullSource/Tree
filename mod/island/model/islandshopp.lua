local var0_0 = class("IslandShopp", import("model.vo.BaseVO"))
local var1_0 = pg.island_shop_banner
local var2_0 = pg.island_shop_normal_template
local var3_0 = pg.island_shop_goods

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg1_1.id
	arg0_1.island = arg2_1

	arg0_1:UpdateData(arg1_1)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_shop_template
end

function var0_0.GetTagType(arg0_3)
	return arg0_3:getConfig("tag_type")
end

function var0_0.GetShopIcon(arg0_4)
	return arg0_4:getConfig("shop_icon")
end

function var0_0.GetTagIcon(arg0_5)
	return arg0_5:getConfig("tag_icon")
end

function var0_0.GetFirstShopId(arg0_6)
	return arg0_6:getConfig("first_shop")
end

function var0_0.GetSecondShopId(arg0_7)
	return arg0_7:getConfig("second_shop")
end

function var0_0.GetShowType(arg0_8)
	return arg0_8:getConfig("show_type")
end

function var0_0.GetTopResources(arg0_9)
	return arg0_9:getConfig("top_resource")
end

function var0_0.GetCameraSet(arg0_10)
	return arg0_10:getConfig("camera_set")
end

function var0_0.GetOrder(arg0_11)
	return arg0_11:getConfig("order")
end

function var0_0.GetGoodIds(arg0_12)
	return arg0_12:getConfig("goods_id")
end

function var0_0.IsNormalShop(arg0_13)
	return arg0_13:getConfig("shop_type") == 1
end

function var0_0.IsTemporaryShop(arg0_14)
	return arg0_14:getConfig("shop_type") == 2
end

function var0_0.GetExistTime(arg0_15)
	if arg0_15:IsNormalShop() then
		return var2_0[arg0_15.id].exist_time
	end

	return nil
end

function var0_0.GetPlayerRefreshResource(arg0_16)
	local var0_16 = var2_0[arg0_16.id].refresh_player

	if type(var0_16) == "table" then
		return var0_16
	end

	return nil
end

function var0_0.GetMaxRefreshCount(arg0_17)
	if arg0_17:IsNormalShop() then
		return var2_0[arg0_17.id].refresh_set
	end

	return 0
end

function var0_0.GetFirstRefreshFree(arg0_18)
	return var2_0[arg0_18.id].refresh_free == 1
end

function var0_0.UpdateData(arg0_19, arg1_19)
	arg0_19.existTime = arg1_19.exist_time
	arg0_19.refreshTime = arg1_19.refresh_time
	arg0_19.refreshCount = arg1_19.refresh_count

	arg0_19:SetCommodities(arg1_19.goods_list)
	arg0_19:SortCommodities()
end

function var0_0.SetCommodities(arg0_20, arg1_20)
	arg0_20.commodities = {}
	arg0_20.commodityIds = {}

	if arg0_20:IsTemporaryShop() then
		for iter0_20, iter1_20 in ipairs(arg1_20) do
			local var0_20 = IslandCommodity.New(iter1_20)

			table.insert(arg0_20.commodities, var0_20)
			table.insert(arg0_20.commodityIds, iter1_20.id)
		end
	else
		for iter2_20, iter3_20 in ipairs(arg0_20:GetGoodIds()) do
			if arg0_20:ShouldShowCommodity(iter3_20) then
				local var1_20 = IslandCommodity.New({
					num = 0,
					id = iter3_20
				})

				table.insert(arg0_20.commodities, var1_20)
				table.insert(arg0_20.commodityIds, iter3_20)
			end
		end

		for iter4_20, iter5_20 in ipairs(arg1_20) do
			local var2_20 = arg0_20:GetCommodityById(iter5_20.id)

			if var2_20 then
				var2_20:UpdateNum(iter5_20.count)

				if var2_20:GetMaxNum() ~= 0 and var2_20.purchasedNum == var2_20:GetMaxNum() and not var2_20:IsShowSellOut() then
					table.remove(arg0_20.commodities, var2_20)
					table.remove(arg0_20.commodityIds, var2_20.id)
				end
			end
		end
	end
end

function var0_0.ShouldShowCommodity(arg0_21, arg1_21)
	local var0_21 = arg0_21.island:GetAblityAgency()
	local var1_21 = var3_0[arg1_21].unlock
	local var2_21 = true

	if type(var1_21) == "table" and #var1_21 > 0 then
		for iter0_21, iter1_21 in ipairs(var1_21) do
			if not var0_21:HasAbility(iter1_21) then
				var2_21 = false

				break
			end
		end
	end

	local var3_21 = pg.TimeMgr.GetInstance():inTime(var3_0[arg1_21].time)

	return var2_21 and var3_21
end

function var0_0.SortCommodities(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(arg0_22:GetGoodIds()) do
		local var1_22 = arg0_22:GetCommodityById(iter1_22)

		if var1_22 then
			table.insert(var0_22, var1_22)
		end
	end

	arg0_22.commodities = var0_22
end

function var0_0.GetCommodities(arg0_23)
	return arg0_23.commodities
end

function var0_0.GetCommodityById(arg0_24, arg1_24)
	if not table.contains(arg0_24.commodityIds, arg1_24) then
		return nil
	end

	for iter0_24, iter1_24 in ipairs(arg0_24.commodities) do
		if iter1_24.id == arg1_24 then
			return iter1_24
		end
	end
end

function var0_0.UpdateCommodity(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25:GetCommodityById(arg1_25)

	if var0_25 then
		var0_25:AddNum(arg2_25)
	end
end

function var0_0.GetBanners(arg0_26)
	if arg0_26:GetShowType() ~= 1 then
		return nil
	end

	local var0_26 = {}

	for iter0_26, iter1_26 in ipairs(var1_0.get_id_list_by_shop_page_id[arg0_26.id]) do
		local var1_26 = var1_0[iter1_26]

		if pg.TimeMgr.GetInstance():inTime(var1_26.time) then
			table.insert(var0_26, var1_26)
		end
	end
end

return var0_0
