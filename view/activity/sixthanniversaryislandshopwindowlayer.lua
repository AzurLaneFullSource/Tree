local var0_0 = class("SixthAnniversaryIslandShopWindowLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryIslandGoodsWindow"
end

function var0_0.setGoods(arg0_2, arg1_2)
	arg0_2.goods = arg1_2
	arg0_2.singleCost = arg1_2:getConfig("resource_num")
	arg0_2.max = math.floor(Drop.New({
		type = arg1_2:getConfig("resource_category"),
		id = arg1_2:getConfig("resource_type")
	}):getOwnedCount() / arg0_2.singleCost)

	if arg1_2:getConfig("num_limit") ~= 0 then
		arg0_2.max = math.min(arg0_2.max, math.max(arg1_2:GetPurchasableCnt(), 0))
	end
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)

	local var0_3 = arg0_3._tf:Find("content/calc")

	setText(var0_3:Find("cost/Text"), i18n("islandshop_tips3"))

	arg0_3.rtCost = var0_3:Find("cost/number")
	arg0_3.rtCount = var0_3:Find("dashboard/view/Text")

	onButton(arg0_3, var0_3:Find("dashboard/minus_10"), function()
		arg0_3:updateCount(-10)
	end, SFX_PANEL)
	onButton(arg0_3, var0_3:Find("dashboard/plus_10"), function()
		arg0_3:updateCount(10)
	end, SFX_PANEL)
	onButton(arg0_3, var0_3:Find("dashboard/view/minus"), function()
		arg0_3:updateCount(-1)
	end, SFX_PANEL)
	onButton(arg0_3, var0_3:Find("dashboard/view/plus"), function()
		arg0_3:updateCount(1)
	end, SFX_PANEL)
	onButton(arg0_3, var0_3:Find("dashboard/plus_max"), function()
		arg0_3:updateCount(arg0_3.max - arg0_3.count)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("content/bottom/btn_cancel"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("content/bottom/btn_confirm"), function()
		if arg0_3.count > arg0_3.max then
			pg.TipsMgr.GetInstance():ShowTips(i18n("islandshop_tips4", Drop.New({
				type = arg0_3.goods:getConfig("resource_category"),
				id = arg0_3.goods:getConfig("resource_type")
			}):getName()))

			return
		end

		arg0_3:emit(SixthAnniversaryIslandShopWindowMediator.SHOPPING_CONFIRM, arg0_3.count)
	end, SFX_CANCEL)
end

function var0_0.updateCount(arg0_12, arg1_12)
	arg0_12.count = math.clamp(arg0_12.count + arg1_12, 1, math.max(arg0_12.max, 1))

	setText(arg0_12.rtCount, arg0_12.count)
	setText(arg0_12.rtCost, arg0_12.count * arg0_12.singleCost)
end

function var0_0.didEnter(arg0_13)
	local var0_13 = arg0_13.goods
	local var1_13 = {
		type = var0_13:getConfig("commodity_type"),
		id = var0_13:getConfig("commodity_id"),
		count = var0_13:getConfig("num")
	}
	local var2_13 = arg0_13._tf:Find("content/main")

	updateDrop(var2_13:Find("icon/IconTpl"), var1_13)

	local var3_13, var4_13 = var1_13:getOwnedCount()

	setActive(var2_13:Find("owner"), var4_13)

	if var4_13 then
		setText(var2_13:Find("owner"), i18n("word_own1") .. var3_13)
	end

	setText(var2_13:Find("line/name"), var1_13:getConfig("name"))
	setText(var2_13:Find("line/content/Text"), string.gsub(var1_13.desc or var1_13:getConfig("desc"), "<[^>]+>", ""))
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var0_13:getConfig("resource_category"),
		id = var0_13:getConfig("resource_type")
	}):getIcon(), "", arg0_13._tf:Find("content/calc/cost/icon"))

	arg0_13.count = 1

	arg0_13:updateCount(0)
end

function var0_0.willExit(arg0_14)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)
end

return var0_0
