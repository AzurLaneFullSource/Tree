local var0_0 = class("IslandCommodity", import("model.vo.BaseVO"))

var0_0.TAG = {
	HOT = 4,
	NEW = 3,
	NONE = 1,
	TIME = 2
}

local var1_0 = pg.pay_data_display

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg1_1.id
	arg0_1.purchasedNum = arg1_1.num
	arg0_1.shopId = arg2_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_shop_goods
end

function var0_0.SetCfgSortIdx(arg0_3, arg1_3)
	arg0_3.cfgSortIdx = arg1_3
end

function var0_0.GetCfgSortIdx(arg0_4)
	return arg0_4.cfgSortIdx or arg0_4.id
end

function var0_0.GetName(arg0_5)
	return arg0_5:getConfig("goods_name")
end

function var0_0.GetDescription(arg0_6)
	return arg0_6:getConfig("desc")
end

function var0_0.GetIcon(arg0_7)
	return "island/" .. arg0_7:getConfig("icon")
end

function var0_0.GetResourceConsume(arg0_8)
	return arg0_8:getConfig("resource_consume")
end

function var0_0.GetItems(arg0_9)
	return arg0_9:getConfig("items")
end

function var0_0.GetDisplayItems(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10:GetItems()) do
		if not var0_0.IsHideCommondity(iter1_10) then
			table.insert(var0_10, iter1_10)
		end
	end

	return var0_10
end

function var0_0.GetItemsWithPt(arg0_11)
	local var0_11 = arg0_11:getConfig("pt_award")
	local var1_11 = Clone(arg0_11:GetItems())

	if var0_11 > 0 then
		table.insert(var1_11, {
			VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
			0,
			var0_11
		})
	end

	return var1_11
end

function var0_0.GetPayId(arg0_12)
	return arg0_12:getConfig("pay_id")
end

function var0_0.GetMaxNum(arg0_13)
	return arg0_13:getConfig("limited_num")
end

function var0_0.IsShowPurchaseLimit(arg0_14)
	return arg0_14:getConfig("limited_show") == 1
end

function var0_0.IsShowSellOut(arg0_15)
	return arg0_15:getConfig("remian_show") == 1
end

function var0_0.IsShowHave(arg0_16)
	return arg0_16:getConfig("goods_have") == 1 and #arg0_16:GetItems() == 1
end

function var0_0.IsShowHold(arg0_17)
	return arg0_17:getConfig("have_show") == 1
end

function var0_0.GetDiscount(arg0_18)
	local var0_18 = 0

	if pg.TimeMgr.GetInstance():inTime(arg0_18:getConfig("discount_time")) then
		var0_18 = arg0_18:getConfig("discount")
	end

	return var0_18
end

function var0_0.GetCommodityShowType(arg0_19)
	return arg0_19:getConfig("goods_detail_type")
end

function var0_0.GetPacketItemsShowTypes(arg0_20)
	return arg0_20:getConfig("groups_detail_type")
end

function var0_0.GetModel(arg0_21)
	return arg0_21:getConfig("items_model")
end

function var0_0.GetModelParam(arg0_22)
	return arg0_22:getConfig("model_param")
end

function var0_0.UpdateNum(arg0_23, arg1_23)
	arg0_23.purchasedNum = arg1_23
end

function var0_0.AddNum(arg0_24, arg1_24)
	arg0_24.purchasedNum = arg0_24.purchasedNum + arg1_24
end

function var0_0.GetPayConfig(arg0_25)
	return var1_0[arg0_25:GetPayId()]
end

function var0_0.GetTag(arg0_26)
	local var0_26 = arg0_26:getConfig("tag") or 0

	return switch(var0_26, {
		[0] = function()
			return arg0_26:IsTimeLimitCommodity() and var0_0.TAG.TIME or var0_0.TAG.NONE
		end,
		function()
			return var0_0.TAG.NEW
		end,
		function()
			return var0_0.TAG.HOT
		end
	}, function()
		return var0_0.TAG.NONE
	end)
end

function var0_0.IsTimeLimitCommodity(arg0_31)
	local var0_31 = arg0_31:getConfig("time")

	if type(var0_31) == "table" then
		return true
	end

	return false
end

function var0_0.IsCharacterInviteItemHold(arg0_32)
	local var0_32 = arg0_32:GetItems()
	local var1_32 = pg.island_chara_template.all
	local var2_32 = {}

	for iter0_32, iter1_32 in ipairs(pg.island_chara_template.all) do
		table.insert(var2_32, pg.island_chara_template[iter1_32].invite_item)
	end

	if #var0_32 ~= 1 or not table.contains(var2_32, var0_32[1][2]) then
		return false
	end

	local var3_32 = var1_32[table.indexof(var2_32, var0_32[1][2])]

	return getProxy(IslandProxy):GetIsland():GetCharacterAgency():HasInvite(var3_32)
end

function var0_0.GetDressType(arg0_33)
	local var0_33 = arg0_33:GetItems()

	if not var0_33[1] or var0_33[1][1] ~= DROP_TYPE_ISLAND_DRESS then
		return nil
	end

	local var1_33 = pg.island_dress_template[var0_33[1][2]]

	if not var1_33 then
		return nil
	end

	return var1_33.type
end

function var0_0.IsHideCommondity(arg0_34)
	local var0_34 = arg0_34.type or arg0_34[1]
	local var1_34 = arg0_34.id or arg0_34[2]

	if var0_34 == DROP_TYPE_ISLAND_DRESS then
		local var2_34 = pg.island_dress_template[var1_34]

		if var2_34 and var2_34.is_hide == 1 then
			return true
		end
	end

	return false
end

return var0_0
