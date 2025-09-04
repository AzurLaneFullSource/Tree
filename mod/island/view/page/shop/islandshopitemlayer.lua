local var0_0 = class("IslandShopItemLayer", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShopItemUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.panel = arg0_2:findTF("panel")
	arg0_2.closeBtn = arg0_2:findTF("closeBtn", arg0_2.panel)
	arg0_2.icon = arg0_2:findTF("icon", arg0_2.panel)
	arg0_2.discount = arg0_2:findTF("discount", arg0_2.panel)
	arg0_2.remainTimer = arg0_2:findTF("remainTimer", arg0_2.panel)
	arg0_2.name = arg0_2:findTF("name", arg0_2.panel)
	arg0_2.desc = arg0_2:findTF("desc", arg0_2.panel)
	arg0_2.buyDesc = arg0_2:findTF("buyDesc", arg0_2.panel)
	arg0_2.count = arg0_2:findTF("count/number_panel/value", arg0_2.panel)
	arg0_2.leftBtn = arg0_2:findTF("count/left", arg0_2.panel)
	arg0_2.rightBtn = arg0_2:findTF("count/right", arg0_2.panel)
	arg0_2.minBtn = arg0_2:findTF("count/min", arg0_2.panel)
	arg0_2.maxBtn = arg0_2:findTF("count/max", arg0_2.panel)
	arg0_2.bottomItemList = UIItemList.New(arg0_2:findTF("itemList/Viewport/Content", arg0_2.panel), arg0_2:findTF("itemList/Viewport/Content/IslandItemTpl", arg0_2.panel))
	arg0_2.buyBtn = arg0_2:findTF("buyBtn", arg0_2.panel)
	arg0_2.consumeIcon = arg0_2:findTF("consume/icon", arg0_2.buyBtn)
	arg0_2.consumeCount = arg0_2:findTF("consume/count", arg0_2.buyBtn)
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
	GetImageSpriteFromAtlasAsync(arg2_6:GetIcon(), "", arg0_6.icon)
	setText(arg0_6.name, arg2_6:GetName())
	setText(arg0_6.desc, arg2_6:GetDescription())
	setActive(arg0_6.discount, arg2_6:GetDiscount() ~= 0)
	setText(arg0_6.discount:Find("Text"), "-" .. arg2_6:GetDiscount() .. "%")

	local var0_6 = false

	setActive(arg0_6.remainTimer, arg2_6:IsTimeLimitCommodity())

	if var0_6 then
		local var1_6 = pg.TimeMgr.GetInstance():GetServerTime()
		local var2_6 = arg2_6:getConfig("time")[1]
		local var3_6 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var2_6[1][1],
			month = var2_6[1][2],
			day = var2_6[1][3],
			hour = var2_6[2][1],
			min = var2_6[2][2],
			sec = var2_6[2][3]
		})
		local var4_6 = pg.TimeMgr.GetInstance():DescCDTime(var3_6 - var1_6)

		setText(arg0_6.remainTimer:Find("text"), var4_6)
	end

	local var5_6 = "购买数量"

	if arg2_6:GetMaxNum() ~= 0 then
		local var6_6 = arg2_6:GetMaxNum() - arg2_6.purchasedNum

		var5_6 = var5_6 .. "（剩余：" .. var6_6 .. "）"
	end

	setText(arg0_6.buyDesc, var5_6)

	local var7_6 = arg2_6:GetMaxNum() - arg2_6.purchasedNum

	if arg2_6:GetMaxNum() == 0 then
		var7_6 = 999
	end

	local var8_6 = arg2_6:GetItemsWithPt()
	local var9_6 = arg2_6:GetResourceConsume()

	local function var10_6(arg0_7)
		arg0_7 = math.max(arg0_7, 1)
		arg0_7 = math.min(arg0_7, var7_6)
		arg0_6.curCount = arg0_7

		setText(arg0_6.count, arg0_7)

		for iter0_7 = 1, #arg0_6.itemsCountTFs do
			local var0_7 = arg0_6.itemsCountTFs[iter0_7]

			setText(var0_7, var8_6[iter0_7][3] * arg0_6.curCount)
		end

		setText(arg0_6.consumeCount, math.ceil((100 - arg2_6:GetDiscount()) / 100 * var9_6[3]) * arg0_6.curCount)
	end

	onButton(arg0_6, arg0_6.leftBtn, function()
		var10_6(arg0_6.curCount - 1)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rightBtn, function()
		var10_6(arg0_6.curCount + 1)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.minBtn, function()
		var10_6(1)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.maxBtn, function()
		var10_6(var7_6)
	end, SFX_PANEL)

	arg0_6.itemsCountTFs = {}

	arg0_6.bottomItemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var8_6[arg1_12 + 1]
			local var1_12 = {
				type = var0_12[1],
				id = var0_12[2],
				count = var0_12[3]
			}

			updateCustomDrop(arg2_12, var1_12)
			table.insert(arg0_6.itemsCountTFs, arg2_12:Find("icon_bg/count_bg/count"))
		end
	end)
	arg0_6.bottomItemList:align(#var8_6)
	var10_6(1)

	if var9_6[1] == DROP_TYPE_RESOURCE then
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = var9_6[1],
			id = var9_6[2]
		}):getIcon(), "", arg0_6.consumeIcon)
	elseif var9_6[1] == DROP_TYPE_ISLAND_ITEM then
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = var9_6[1],
			id = var9_6[2]
		}):getIcon(), "", arg0_6.consumeIcon)
	end

	onButton(arg0_6, arg0_6.buyBtn, function()
		local var0_13 = {
			{
				key = arg1_6,
				value1 = arg2_6.id,
				value2 = arg0_6.curCount
			}
		}

		arg0_6:emit(IslandMediator.BUY_COMMODITY, var0_13)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_14, arg1_14, arg2_14)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf, false, {
		groupName = "IslandShop"
	})

	arg0_14.shopId = arg1_14
	arg0_14.commodity = arg2_14

	arg0_14:SetUp(arg1_14, arg2_14)
end

function var0_0.Refresh(arg0_15)
	arg0_15:SetUp(arg0_15.shopId, arg0_15.commodity)
end

function var0_0.OnHide(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, arg0_16._parentTf)
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
