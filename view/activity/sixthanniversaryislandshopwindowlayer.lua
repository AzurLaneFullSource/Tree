local var0 = class("SixthAnniversaryIslandShopWindowLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "SixthAnniversaryIslandGoodsWindow"
end

function var0.setGoods(arg0, arg1)
	arg0.goods = arg1
	arg0.singleCost = arg1:getConfig("resource_num")
	arg0.max = math.floor(Drop.New({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getOwnedCount() / arg0.singleCost)

	if arg1:getConfig("num_limit") ~= 0 then
		arg0.max = math.min(arg0.max, math.max(arg1:GetPurchasableCnt(), 0))
	end
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	local var0 = arg0._tf:Find("content/calc")

	setText(var0:Find("cost/Text"), i18n("islandshop_tips3"))

	arg0.rtCost = var0:Find("cost/number")
	arg0.rtCount = var0:Find("dashboard/view/Text")

	onButton(arg0, var0:Find("dashboard/minus_10"), function()
		arg0:updateCount(-10)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("dashboard/plus_10"), function()
		arg0:updateCount(10)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("dashboard/view/minus"), function()
		arg0:updateCount(-1)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("dashboard/view/plus"), function()
		arg0:updateCount(1)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("dashboard/plus_max"), function()
		arg0:updateCount(arg0.max - arg0.count)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("content/bottom/btn_cancel"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("content/bottom/btn_confirm"), function()
		if arg0.count > arg0.max then
			pg.TipsMgr.GetInstance():ShowTips(i18n("islandshop_tips4", Drop.New({
				type = arg0.goods:getConfig("resource_category"),
				id = arg0.goods:getConfig("resource_type")
			}):getName()))

			return
		end

		arg0:emit(SixthAnniversaryIslandShopWindowMediator.SHOPPING_CONFIRM, arg0.count)
	end, SFX_CANCEL)
end

function var0.updateCount(arg0, arg1)
	arg0.count = math.clamp(arg0.count + arg1, 1, math.max(arg0.max, 1))

	setText(arg0.rtCount, arg0.count)
	setText(arg0.rtCost, arg0.count * arg0.singleCost)
end

function var0.didEnter(arg0)
	local var0 = arg0.goods
	local var1 = {
		type = var0:getConfig("commodity_type"),
		id = var0:getConfig("commodity_id"),
		count = var0:getConfig("num")
	}
	local var2 = arg0._tf:Find("content/main")

	updateDrop(var2:Find("icon/IconTpl"), var1)

	local var3, var4 = var1:getOwnedCount()

	setActive(var2:Find("owner"), var4)

	if var4 then
		setText(var2:Find("owner"), i18n("word_own1") .. var3)
	end

	setText(var2:Find("line/name"), var1:getConfig("name"))
	setText(var2:Find("line/content/Text"), string.gsub(var1.desc or var1:getConfig("desc"), "<[^>]+>", ""))
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var0:getConfig("resource_category"),
		id = var0:getConfig("resource_type")
	}):getIcon(), "", arg0._tf:Find("content/calc/cost/icon"))

	arg0.count = 1

	arg0:updateCount(0)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
