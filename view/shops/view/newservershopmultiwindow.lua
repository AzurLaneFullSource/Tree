local var0_0 = class("NewServerShopMultiWindow", import("..msgbox.ShopMultiWindow"))

function var0_0.InitWindow(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		id = arg1_1:getConfig("goods")[1],
		type = arg1_1:getConfig("type"),
		count = arg1_1:getConfig("num")
	}
	local var1_1, var2_1, var3_1 = arg1_1:CheckTimeLimit()

	setActive(arg0_1.timeLimitTF, var1_1)

	if var1_1 and var2_1 then
		local var4_1 = getProxy(ActivityProxy):getActivityById(Item.getConfigData(var0_1.id).link_id)
		local var5_1 = pg.TimeMgr.GetInstance():STimeDescC(var4_1.stopTime, "%m.%d")

		setText(arg0_1:findTF("Text", arg0_1.timeLimitTF), i18n("eventshop_time_hint", var5_1))
	end

	local var6_1 = Drop.New({
		type = arg1_1:getConfig("resource_category"),
		id = arg1_1:getConfig("resource_type")
	}):getOwnedCount()
	local var7_1 = math.max(math.floor(var6_1 / arg1_1:getConfig("resource_num")), 1)

	if arg1_1:getConfig("goods_purchase_limit") ~= 0 then
		local var8_1 = arg1_1:GetPurchasableCnt()

		var7_1 = math.min(var7_1, math.max(0, var8_1))
	end

	local function var9_1(arg0_2)
		arg0_2 = math.max(arg0_2, 1)
		arg0_2 = math.min(arg0_2, var7_1)
		arg0_1.countTF.text = arg0_2
		arg0_1.curCount = arg0_2
		arg0_1.itemCountTF.text = arg0_2 * arg1_1:getConfig("num")
	end

	var9_1(1)
	updateDrop(arg0_1.topItem:Find("left/IconTpl"), var0_1)
	UpdateOwnDisplay(arg0_1.ownerTF, var0_1)
	RegisterDetailButton(arg0_1, arg0_1.detailTF, var0_1)

	arg0_1.nameTF.text = var0_1:getConfig("name")
	arg0_1.descTF.text = var0_1.desc or var0_1:getConfig("desc")

	updateDrop(arg0_1.bottomItem, var0_1)
	onButton(arg0_1, arg0_1.confirmBtn, function()
		if arg2_1 then
			arg2_1(arg1_1, arg0_1.curCount, var0_1:getConfig("name"))
		end

		arg0_1:Close()
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.leftBtn, function()
		var9_1(arg0_1.curCount - 1)
	end)
	onButton(arg0_1, arg0_1.rightBtn, function()
		var9_1(arg0_1.curCount + 1)
	end)
	onButton(arg0_1, arg0_1.maxBtn, function()
		var9_1(var7_1)
	end)
end

return var0_0
