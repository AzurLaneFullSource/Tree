local var0_0 = class("IslandSeasonShopPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonShopPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("content")

	arg0_2.lockTF = var0_2:Find("view/lock")

	setText(var0_2:Find("view/content/tpl/sellOut/Text"), i18n("common_sale_out"))

	arg0_2.resCntTxt = var0_2:Find("res/Text"):GetComponent(typeof(Text))
	arg0_2.goodUIList = UIItemList.New(var0_2:Find("view/content"), var0_2:Find("view/content/tpl"))

	local var1_2 = var0_2:Find("toggles")

	arg0_2.togglesUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.shopIds = arg0_3.contextData.season:getConfig("shop_id")

	arg0_3.togglesUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			local function var0_4()
				setActive(arg2_4:Find("red"), IslandSeasonRedDotHelper.TipShopShowPhase(arg1_4 + 1))
			end

			arg2_4.name = arg1_4 + 1

			setText(arg2_4:Find("unsel/Text"), i18n("island_season_shop_stage" .. arg1_4 + 1))
			setText(arg2_4:Find("sel/Text"), i18n("island_season_shop_stage" .. arg1_4 + 1))
			onToggle(arg0_3, arg2_4, function(arg0_6)
				if arg0_6 then
					arg0_3.showPhase = arg1_4 + 1

					arg0_3:Flush()
					var0_4()
				end
			end, SFX_PANEL)
			var0_4()
		end
	end)
	arg0_3.togglesUIList:align(#arg0_3.shopIds)
	arg0_3.goodUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:UpdateGood(arg1_7, arg2_7)
		end
	end)
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)

	arg0_8.showPhase = 1

	triggerToggle(arg0_8.togglesUIList.container:GetChild(0), true)
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_18")
end

function var0_0.UpdateGood(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.displaysGoods[arg1_9 + 1]

	arg2_9.name = var0_9.id

	IslandShopPage.StaticUpdateCommodityTpl(arg2_9, var0_9)
	setActive(arg2_9:Find("notInTime"), not arg0_9.displayShop:IsInTime())

	if isActive(arg2_9:Find("sellOut")) or isActive(arg2_9:Find("hold")) or isActive(arg2_9:Find("notInTime")) then
		removeOnButton(arg2_9)
	else
		onButton(arg0_9, arg2_9, function()
			arg0_9.contextData.openBuyLayer(arg0_9.displayShop.id, var0_9)
		end, SFX_PANEL)
	end
end

function var0_0.Flush(arg0_11)
	arg0_11.inventoryAgency = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	arg0_11.shops = getProxy(IslandProxy):GetIsland():GetShopAgency():GetSeasonShops()

	local var0_11 = arg0_11.shopIds[arg0_11.showPhase or 1]

	arg0_11.displayShop = arg0_11.shops[var0_11]

	IslandSeasonRedDotHelper.UpdateEnterShopPhase(arg0_11.showPhase)
	arg0_11:emit(IslandSeasonPage.UPDATE_REDDOT, IslandSeasonPage.PAGE_SHOP)

	local var1_11 = pg.TimeMgr.GetInstance()
	local var2_11 = arg0_11.displayShop:GetExistTime()
	local var3_11 = var1_11:inTime(var2_11)

	setActive(arg0_11.lockTF, not var3_11)

	if not var3_11 then
		local var4_11 = var1_11:DescDateFromConfig(var2_11[1]) .. "~" .. var1_11:DescDateFromConfig(var2_11[2])

		setText(arg0_11.lockTF:Find("layout/Text"), var4_11)
	end

	arg0_11.displaysGoods = arg0_11.displayShop:GetCommodities()

	IslandShopPage.SortShopCommodities(arg0_11.displaysGoods)
	arg0_11.goodUIList:align(#arg0_11.displaysGoods)
	setActive(arg0_11.lockTF, not arg0_11.displayShop:IsInTime())

	arg0_11.resCntTxt.text = arg0_11.inventoryAgency:GetOwnCount(IslandItem.GOLD_ID)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
