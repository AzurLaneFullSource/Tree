local var0_0 = class("IslandSeasonShopPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonShopPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("content")

	arg0_2.lockTF = var0_2:Find("view/lock")
	arg0_2.goodUIList = UIItemList.New(var0_2:Find("view/content"), var0_2:Find("view/content/tpl"))

	local var1_2 = var0_2:Find("toggles")

	arg0_2.togglesUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.shopIds = arg0_3.contextData.season:getConfig("shop_id")

	arg0_3.togglesUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			arg2_4.name = arg1_4 + 1

			setText(arg2_4:Find("unsel/Text"), i18n("island_season_shop_stage" .. arg1_4 + 1))
			setText(arg2_4:Find("sel/Text"), i18n("island_season_shop_stage" .. arg1_4 + 1))
			onToggle(arg0_3, arg2_4, function(arg0_5)
				if arg0_5 then
					arg0_3.showPhase = arg1_4 + 1

					arg0_3:Flush()
				end
			end, SFX_PANEL)
		end
	end)
	arg0_3.togglesUIList:align(#arg0_3.shopIds)
	arg0_3.goodUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateGood(arg1_6, arg2_6)
		end
	end)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)

	arg0_7.showPhase = 1

	triggerToggle(arg0_7.togglesUIList.container:GetChild(0), true)
end

function var0_0.UpdateGood(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.displaysGoods[arg1_8 + 1]

	arg2_8.name = var0_8.id

	setText(arg2_8:Find("name"), var0_8:GetName())

	if #var0_8:GetItems() == 1 then
		local var1_8 = var0_8:GetItems()[1]
		local var2_8 = {
			type = var1_8[1],
			id = var1_8[2],
			count = var1_8[3]
		}

		updateCustomDrop(arg2_8:Find("IslandItemTpl"), var2_8)
	else
		GetImageSpriteFromAtlasAsync("island/" .. var0_8:GetIcon(), "", arg2_8:Find("IslandItemTpl/icon_bg/icon"))
	end

	local var3_8 = var0_8:GetResourceConsume()

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var3_8[1],
		id = var3_8[2]
	}):getIcon(), "", arg2_8:Find("cost/icon"))
	setText(arg2_8:Find("cost/num"), math.ceil((100 - var0_8:GetDiscount()) / 100 * var3_8[3]))
	setActive(arg2_8:Find("IslandItemTpl/icon_bg/count_bg"), var0_8:IsShowPurchaseLimit())

	local var4_8 = var0_8:GetMaxNum() - var0_8.purchasedNum

	setText(arg2_8:Find("IslandItemTpl/icon_bg/count_bg/count"), var4_8 .. "/" .. var0_8:GetMaxNum())
	setActive(arg2_8:Find("sellOut"), var0_8:GetMaxNum() ~= 0 and var4_8 == 0)
	setActive(arg2_8:Find("timeLimit"), var0_8:IsTimeLimitCommodity())
	setActive(arg2_8:Find("discount"), var0_8:GetDiscount() ~= 0)
	setText(arg2_8:Find("discount/Text"), "-" .. var0_8:GetDiscount() .. "%")

	local var5_8 = arg0_8.inventoryAgency:GetOwnCount(var0_8:GetItems()[1][2])

	setActive(arg2_8:Find("have"), var0_8:IsShowHave())
	setText(arg2_8:Find("have"), i18n("island_word_own", var5_8))
	setActive(arg2_8:Find("hold"), var0_8:IsShowHold() and (var5_8 > 0 or var0_8:IsCharacterInviteItemHold()))
	setActive(arg2_8:Find("cost"), not isActive(arg2_8:Find("hold")))
	setActive(arg2_8:Find("notInTime"), not arg0_8.displayShop:IsInTime())

	if isActive(arg2_8:Find("sellOut")) or isActive(arg2_8:Find("hold")) or isActive(arg2_8:Find("notInTime")) then
		removeOnButton(arg2_8)
	else
		onButton(arg0_8, arg2_8, function()
			arg0_8.contextData.openBuyLayer(arg0_8.displayShop.id, var0_8)
		end, SFX_PANEL)
	end
end

function var0_0.Flush(arg0_10)
	arg0_10.inventoryAgency = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	arg0_10.shops = getProxy(IslandProxy):GetIsland():GetShopAgency():GetSeasonShops()

	local var0_10 = arg0_10.shopIds[arg0_10.showPhase or 1]

	arg0_10.displayShop = arg0_10.shops[var0_10]

	local var1_10 = pg.TimeMgr.GetInstance()
	local var2_10 = arg0_10.displayShop:GetExistTime()
	local var3_10 = var1_10:inTime(var2_10)

	setActive(arg0_10.lockTF, not var3_10)

	if not var3_10 then
		local var4_10 = var1_10:DescDateFromConfig(var2_10[1]) .. "~" .. var1_10:DescDateFromConfig(var2_10[2])

		setText(arg0_10.lockTF:Find("layout/Text"), var4_10)
	end

	arg0_10.displaysGoods = arg0_10.displayShop:GetCommodities()

	arg0_10.goodUIList:align(#arg0_10.displaysGoods)
	setActive(arg0_10.lockTF, not arg0_10.displayShop:IsInTime())
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
