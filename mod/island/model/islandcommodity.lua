local var0_0 = class("IslandCommodity", import("model.vo.BaseVO"))
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

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("goods_name")
end

function var0_0.GetDescription(arg0_4)
	return arg0_4:getConfig("desc")
end

function var0_0.GetIcon(arg0_5)
	return "island/" .. arg0_5:getConfig("icon")
end

function var0_0.GetResourceConsume(arg0_6)
	return arg0_6:getConfig("resource_consume")
end

function var0_0.GetItems(arg0_7)
	return arg0_7:getConfig("items")
end

function var0_0.GetItemsWithPt(arg0_8)
	local var0_8 = arg0_8:getConfig("pt_award")
	local var1_8 = Clone(arg0_8:GetItems())

	if var0_8 > 0 then
		table.insert(var1_8, {
			VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
			0,
			var0_8
		})
	end

	return var1_8
end

function var0_0.GetPayId(arg0_9)
	return arg0_9:getConfig("pay_id")
end

function var0_0.GetMaxNum(arg0_10)
	return arg0_10:getConfig("limited_num")
end

function var0_0.IsShowPurchaseLimit(arg0_11)
	return arg0_11:getConfig("limited_show") == 1
end

function var0_0.IsShowSellOut(arg0_12)
	return arg0_12:getConfig("remian_show") == 1
end

function var0_0.IsShowHave(arg0_13)
	return arg0_13:getConfig("goods_have") == 1 and #arg0_13:GetItems() == 1
end

function var0_0.IsShowHold(arg0_14)
	return arg0_14:getConfig("have_show") == 1 and #arg0_14:GetItems() == 1
end

function var0_0.GetDiscount(arg0_15)
	local var0_15 = 0

	if pg.TimeMgr.GetInstance():inTime(arg0_15:getConfig("discount_time")) then
		var0_15 = arg0_15:getConfig("discount")
	end

	return var0_15
end

function var0_0.GetCommodityShowType(arg0_16)
	return arg0_16:getConfig("goods_detail_type")
end

function var0_0.GetPacketItemsShowTypes(arg0_17)
	return arg0_17:getConfig("groups_detail_type")
end

function var0_0.GetModel(arg0_18)
	return arg0_18:getConfig("items_model")
end

function var0_0.GetModelParam(arg0_19)
	return arg0_19:getConfig("model_param")
end

function var0_0.UpdateNum(arg0_20, arg1_20)
	arg0_20.purchasedNum = arg1_20
end

function var0_0.AddNum(arg0_21, arg1_21)
	arg0_21.purchasedNum = arg0_21.purchasedNum + arg1_21
end

function var0_0.GetPayConfig(arg0_22)
	return var1_0[arg0_22:GetPayId()]
end

function var0_0.IsTimeLimitCommodity(arg0_23)
	local var0_23 = arg0_23:getConfig("time")

	if type(var0_23) == "table" then
		return true
	end

	return false
end

function var0_0.IsCharacterInviteItemHold(arg0_24)
	local var0_24 = arg0_24:GetItems()
	local var1_24 = pg.island_chara_template.all
	local var2_24 = {}

	for iter0_24, iter1_24 in ipairs(pg.island_chara_template.all) do
		table.insert(var2_24, pg.island_chara_template[iter1_24].invite_item)
	end

	if #var0_24 ~= 1 or not table.contains(var2_24, var0_24[1][2]) then
		return false
	end

	local var3_24 = var1_24[table.indexof(var2_24, var0_24[1][2])]

	return getProxy(IslandProxy):GetIsland():GetCharacterAgency():HasInvite(var3_24)
end

function var0_0.GetDressType(arg0_25)
	local var0_25 = arg0_25:GetItems()

	if not var0_25[1] or var0_25[1][1] ~= DROP_TYPE_ISLAND_DRESS then
		return nil
	end

	local var1_25 = pg.island_dress_template[var0_25[1][2]]

	if not var1_25 then
		return nil
	end

	return var1_25.type
end

return var0_0
