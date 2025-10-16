local var0_0 = class("IslandShopItemLayer", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShopItemUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.panel = arg0_2._tf:Find("panel")
	arg0_2.closeBtn = arg0_2.panel:Find("closeBtn")
	arg0_2.icon = arg0_2.panel:Find("icon")
	arg0_2.discount = arg0_2.panel:Find("discount")
	arg0_2.remainTimer = arg0_2.panel:Find("remainTimer")
	arg0_2.name = arg0_2.panel:Find("name")
	arg0_2.desc = arg0_2.panel:Find("desc")
	arg0_2.buyDesc = arg0_2.panel:Find("buyDesc")
	arg0_2.count = arg0_2.panel:Find("count/number_panel/value")
	arg0_2.leftBtn = arg0_2.panel:Find("count/left")
	arg0_2.rightBtn = arg0_2.panel:Find("count/right")
	arg0_2.minBtn = arg0_2.panel:Find("count/min")
	arg0_2.maxBtn = arg0_2.panel:Find("count/max")
	arg0_2.bottomItemList = UIItemList.New(arg0_2.panel:Find("itemList/Viewport/Content"), arg0_2.panel:Find("itemList/Viewport/Content/IslandItemTpl"))
	arg0_2.buyBtn = arg0_2.panel:Find("buyBtn")
	arg0_2.consumeIcon = arg0_2.buyBtn:Find("consume/icon")
	arg0_2.consumeCount = arg0_2.buyBtn:Find("consume/count")

	setText(arg0_2._tf:Find("panel/title"), i18n("island_3Dshop_buy_confirm"))
	setText(arg0_2._tf:Find("panel/buyBtn/text"), i18n("island_3Dshop_buy"))
	setText(arg0_2._tf:Find("panel/getDesc"), i18n("island_3Dshop_buy_tip0"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_6, arg1_6, arg2_6)
	if arg0_6.charaId then
		GetImageSpriteFromAtlasAsync("island/islandshipiconall/" .. arg0_6.charaId, "", arg0_6.icon)
	else
		GetImageSpriteFromAtlasAsync(arg2_6:GetIcon(), "", arg0_6.icon)
	end

	setText(arg0_6.name, arg2_6:GetName())
	setText(arg0_6.desc, arg2_6:GetDescription())
	setActive(arg0_6.discount, arg2_6:GetDiscount() ~= 0)
	setText(arg0_6.discount:Find("Text"), "-" .. arg2_6:GetDiscount() .. "%")

	local var0_6 = arg2_6:IsTimeLimitCommodity()

	setActive(arg0_6.remainTimer, var0_6)

	if var0_6 then
		local var1_6 = arg2_6:getConfig("time")[2]
		local var2_6 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var1_6[1][1],
			month = var1_6[1][2],
			day = var1_6[1][3],
			hour = var1_6[2][1],
			min = var1_6[2][2],
			sec = var1_6[2][3]
		})
		local var3_6 = 86400

		arg0_6:StartTimer(function()
			local var0_7 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_7 = var2_6 - var0_7

			if var1_7 < var3_6 then
				local var2_7 = pg.TimeMgr.GetInstance():DescCDTime(var1_7)

				setText(arg0_6.remainTimer:Find("text"), var2_7)
			else
				setText(arg0_6.remainTimer:Find("text"), i18n("island_3Dshop_goods_time", math.floor(var1_7 / var3_6)))
			end
		end)
	end

	local var4_6 = i18n("island_3Dshop_buy_no")

	if arg2_6:GetMaxNum() ~= 0 then
		local var5_6 = arg2_6:GetMaxNum() - arg2_6.purchasedNum

		var4_6 = var4_6 .. i18n("island_3Dshop_last", var5_6)
	end

	setText(arg0_6.buyDesc, var4_6)

	local var6_6 = arg2_6:GetMaxNum() - arg2_6.purchasedNum

	if arg2_6:GetMaxNum() == 0 then
		var6_6 = 999
	end

	local var7_6 = arg2_6:GetResourceConsume()
	local var8_6 = (100 - arg2_6:GetDiscount()) / 100 * var7_6[3]
	local var9_6 = 1
	local var10_6 = var7_6[1]
	local var11_6 = var7_6[2]

	if var10_6 == DROP_TYPE_RESOURCE then
		local var12_6 = getProxy(PlayerProxy):getRawData()

		if var11_6 == 1 then
			local var13_6 = var12_6.gold

			var9_6 = math.floor(var13_6 / var8_6)
		elseif var11_6 == 4 or var11_6 == 14 then
			local var14_6 = var12_6:getTotalGem()

			var9_6 = math.floor(var14_6 / var8_6)
		end
	elseif var10_6 == DROP_TYPE_ISLAND_ITEM then
		local var15_6 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(var11_6)

		var9_6 = math.floor(var15_6 / var8_6)
	end

	local var16_6 = math.clamp(var9_6, 1, var6_6)
	local var17_6 = arg2_6:GetItemsWithPt()

	local function var18_6(arg0_8)
		arg0_8 = math.clamp(arg0_8, 1, var16_6)
		arg0_6.curCount = arg0_8

		setText(arg0_6.count, arg0_8)

		for iter0_8 = 1, #arg0_6.itemsCountTFs do
			local var0_8 = arg0_6.itemsCountTFs[iter0_8]

			setText(var0_8, var17_6[iter0_8][3] * arg0_6.curCount)
		end

		setText(arg0_6.consumeCount, math.ceil(var8_6 * arg0_6.curCount))
	end

	pressPersistTrigger(arg0_6.leftBtn, 0.5, function(arg0_9)
		var18_6(arg0_6.curCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_6.rightBtn, 0.5, function(arg0_10)
		var18_6(arg0_6.curCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_6.minBtn, 0.5, function(arg0_11)
		var18_6(arg0_6.curCount - 10)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_6.maxBtn, 0.5, function(arg0_12)
		var18_6(arg0_6.curCount + 10)
	end, nil, true, true, 0.1, SFX_PANEL)

	arg0_6.itemsCountTFs = {}

	arg0_6.bottomItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var17_6[arg1_13 + 1]
			local var1_13 = {
				type = var0_13[1],
				id = var0_13[2],
				count = var0_13[3]
			}

			updateCustomDrop(arg2_13, var1_13, {
				style = "island"
			})
			table.insert(arg0_6.itemsCountTFs, arg2_13:Find("icon_bg/count_bg/count"))
		end
	end)
	arg0_6.bottomItemList:align(#var17_6)
	var18_6(1)

	if var7_6[1] == DROP_TYPE_RESOURCE then
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = var7_6[1],
			id = var7_6[2]
		}):getIcon(), "", arg0_6.consumeIcon)
	elseif var7_6[1] == DROP_TYPE_ISLAND_ITEM then
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = var7_6[1],
			id = var7_6[2]
		}):getIcon(), "", arg0_6.consumeIcon)
	end

	onButton(arg0_6, arg0_6.buyBtn, function()
		local var0_14 = {
			{
				key = arg1_6,
				value1 = arg2_6.id,
				value2 = arg0_6.curCount
			}
		}

		arg0_6:emit(IslandMediator.BUY_COMMODITY, var0_14)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_15.Hide)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_16.Hide)
end

function var0_0.OnShow(arg0_17, arg1_17, arg2_17, arg3_17)
	arg0_17:BlurPanel(arg0_17._tf)

	arg0_17.shopId = arg1_17
	arg0_17.commodity = arg2_17

	arg0_17:SetUp(arg1_17, arg2_17)

	if arg3_17 then
		arg0_17.charaId = arg3_17
	end
end

function var0_0.Refresh(arg0_18)
	arg0_18:SetUp(arg0_18.shopId, arg0_18.commodity)
end

function var0_0.StartTimer(arg0_19, arg1_19)
	arg0_19.timer = Timer.New(arg1_19, 1, -1)

	arg0_19.timer:Start()
end

function var0_0.RemoveTimer(arg0_20)
	if arg0_20.timer then
		arg0_20.timer:Stop()

		arg0_20.timer = nil
	end
end

function var0_0.OnHide(arg0_21)
	arg0_21:RemoveTimer()
	arg0_21:UnOverlayPanel(arg0_21._tf, arg0_21._parentTf)
end

function var0_0.OnDestroy(arg0_22)
	return
end

return var0_0
