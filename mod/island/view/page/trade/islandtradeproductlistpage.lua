local var0_0 = class("IslandTradeProductListPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTradeProductListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiitemList = UIItemList.New(arg0_2._tf:Find("shopView/Viewport/Content"), arg0_2._tf:Find("shopView/Viewport/Content/tpl"))
end

function var0_0.Show(arg0_3, arg1_3)
	var0_0.super.Show(arg0_3)

	arg0_3.island = arg1_3

	arg0_3:UpdateProductList()
end

function var0_0.GetDisplays(arg0_4)
	return {
		IslandItem.New({
			num = 1,
			id = IslandItem.PEARL_ID
		})
	}
end

function var0_0.UpdateProductList(arg0_5)
	local var0_5 = arg0_5:GetDisplays()

	arg0_5.uiitemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]

			arg0_5:UpdateItem(arg2_6, var0_6)
		end
	end)
	arg0_5.uiitemList:align(#var0_5)
end

function var0_0.GetPrice(arg0_7)
	return (arg0_7.island:GetTradeAgency():GetTodayPrice())
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	setText(arg1_8:Find("name"), arg2_8:getConfig("name"))
	updateCustomDrop(arg1_8:Find("item"), Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg2_8.id
	}))
	setText(arg1_8:Find("name"), arg2_8:getConfig("name"))
	setText(arg1_8:Find("cost/num"), arg0_8:GetPrice())
	onButton(arg0_8, arg1_8, function()
		arg0_8:OnClick()
	end, SFX_PANEL)
end

function var0_0.OnClick(arg0_10)
	arg0_10:emit(IslandTradePage.OPEN_CONFIRM_PAGE, IslandConst.TRADE_PURCHASE)
end

return var0_0
