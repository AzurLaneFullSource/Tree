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

function var0_0.GetCommanderOrCharaType(arg0_15)
	return arg0_15:getConfig("dress_type")
end

function var0_0.GetExistTime(arg0_16)
	if arg0_16:IsNormalShop() then
		return var2_0[arg0_16.id].exist_time
	end

	return nil
end

function var0_0.GetPlayerRefreshResource(arg0_17)
	local var0_17 = var2_0[arg0_17.id].refresh_player

	if type(var0_17) == "table" then
		return var0_17
	end

	return nil
end

function var0_0.GetMaxRefreshCount(arg0_18)
	if arg0_18:IsNormalShop() then
		return var2_0[arg0_18.id].refresh_set
	end

	return 0
end

function var0_0.GetFirstRefreshFree(arg0_19)
	return var2_0[arg0_19.id].refresh_free == 1
end

function var0_0.UpdateData(arg0_20, arg1_20)
	arg0_20.existTime = arg1_20.exist_time
	arg0_20.refreshTime = arg1_20.refresh_time
	arg0_20.refreshCount = arg1_20.refresh_count

	arg0_20:SetCommodities(arg1_20.goods_list)
	arg0_20:SortCommodities()
end

function var0_0.SetCommodities(arg0_21, arg1_21)
	arg0_21.commodities = {}
	arg0_21.commodityIds = {}

	if arg0_21:IsTemporaryShop() then
		for iter0_21, iter1_21 in ipairs(arg1_21) do
			local var0_21 = IslandCommodity.New(iter1_21, arg0_21.id)

			table.insert(arg0_21.commodities, var0_21)
			table.insert(arg0_21.commodityIds, iter1_21.id)
		end
	else
		for iter2_21, iter3_21 in ipairs(arg0_21:GetGoodIds()) do
			if arg0_21:ShouldShowCommodity(iter3_21) then
				local var1_21 = IslandCommodity.New({
					num = 0,
					id = iter3_21
				}, arg0_21.id)

				table.insert(arg0_21.commodities, var1_21)
				table.insert(arg0_21.commodityIds, iter3_21)
			end
		end

		for iter4_21, iter5_21 in ipairs(arg1_21) do
			local var2_21 = arg0_21:GetCommodityById(iter5_21.id)

			if var2_21 then
				var2_21:UpdateNum(iter5_21.num)

				if var2_21:GetMaxNum() ~= 0 and var2_21.purchasedNum == var2_21:GetMaxNum() and not var2_21:IsShowSellOut() then
					table.removebyvalue(arg0_21.commodities, var2_21)
					table.removebyvalue(arg0_21.commodityIds, var2_21.id)
				end
			end
		end
	end
end

function var0_0.ShouldShowCommodity(arg0_22, arg1_22)
	local var0_22 = arg0_22.island:GetAblityAgency()
	local var1_22 = var3_0[arg1_22].unlock
	local var2_22 = true

	if type(var1_22) == "table" and #var1_22 > 0 then
		for iter0_22, iter1_22 in ipairs(var1_22) do
			if not var0_22:HasAbility(iter1_22) then
				var2_22 = false

				break
			end
		end
	end

	local var3_22 = pg.TimeMgr.GetInstance():inTime(var3_0[arg1_22].time)

	return var2_22 and var3_22
end

function var0_0.SortCommodities(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(arg0_23:GetGoodIds()) do
		local var1_23 = arg0_23:GetCommodityById(iter1_23)

		if var1_23 then
			table.insert(var0_23, var1_23)
		end
	end

	arg0_23.commodities = var0_23
end

function var0_0.GetCommodities(arg0_24)
	return arg0_24.commodities
end

function var0_0.GetCommodityById(arg0_25, arg1_25)
	if not table.contains(arg0_25.commodityIds, arg1_25) then
		return nil
	end

	for iter0_25, iter1_25 in ipairs(arg0_25.commodities) do
		if iter1_25.id == arg1_25 then
			return iter1_25
		end
	end
end

function var0_0.UpdateCommodity(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26:GetCommodityById(arg1_26)

	if var0_26 then
		var0_26:AddNum(arg2_26)
	end
end

function var0_0.GetBanners(arg0_27)
	if arg0_27:GetShowType() ~= 1 then
		return nil
	end

	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(var1_0.get_id_list_by_shop_page_id[arg0_27.id]) do
		local var1_27 = var1_0[iter1_27]

		if pg.TimeMgr.GetInstance():inTime(var1_27.time) then
			table.insert(var0_27, var1_27)
		end
	end
end

function var0_0.IsInTime(arg0_28)
	if arg0_28:IsNormalShop() then
		return pg.TimeMgr.GetInstance():inTime(arg0_28:GetExistTime())
	elseif arg0_28:IsTemporaryShop() then
		return pg.TimeMgr.GetInstance():GetServerTime() < arg0_28.existTime
	end
end

return var0_0
