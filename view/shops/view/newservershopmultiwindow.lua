local var0 = class("NewServerShopMultiWindow", import("..msgbox.ShopMultiWindow"))

function var0.InitWindow(arg0, arg1, arg2)
	local var0 = {
		id = arg1:getConfig("goods")[1],
		type = arg1:getConfig("type"),
		count = arg1:getConfig("num")
	}
	local var1, var2, var3 = arg1:CheckTimeLimit()

	setActive(arg0.timeLimitTF, var1)

	if var1 and var2 then
		local var4 = getProxy(ActivityProxy):getActivityById(Item.getConfigData(var0.id).link_id)
		local var5 = pg.TimeMgr.GetInstance():STimeDescC(var4.stopTime, "%m.%d")

		setText(arg0:findTF("Text", arg0.timeLimitTF), i18n("eventshop_time_hint", var5))
	end

	local var6 = Drop.New({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getOwnedCount()
	local var7 = math.max(math.floor(var6 / arg1:getConfig("resource_num")), 1)

	if arg1:getConfig("goods_purchase_limit") ~= 0 then
		local var8 = arg1:GetPurchasableCnt()

		var7 = math.min(var7, math.max(0, var8))
	end

	local function var9(arg0)
		arg0 = math.max(arg0, 1)
		arg0 = math.min(arg0, var7)
		arg0.countTF.text = arg0
		arg0.curCount = arg0
		arg0.itemCountTF.text = arg0 * arg1:getConfig("num")
	end

	var9(1)
	updateDrop(arg0.topItem:Find("left/IconTpl"), var0)
	UpdateOwnDisplay(arg0.ownerTF, var0)
	RegisterDetailButton(arg0, arg0.detailTF, var0)

	arg0.nameTF.text = var0:getConfig("name")
	arg0.descTF.text = var0.desc or var0:getConfig("desc")

	updateDrop(arg0.bottomItem, var0)
	onButton(arg0, arg0.confirmBtn, function()
		if arg2 then
			arg2(arg1, arg0.curCount, var0:getConfig("name"))
		end

		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.leftBtn, function()
		var9(arg0.curCount - 1)
	end)
	onButton(arg0, arg0.rightBtn, function()
		var9(arg0.curCount + 1)
	end)
	onButton(arg0, arg0.maxBtn, function()
		var9(var7)
	end)
end

return var0
