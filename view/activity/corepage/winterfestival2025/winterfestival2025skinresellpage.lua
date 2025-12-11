local var0_0 = class("WinterFestival2025SkinReSellPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.rtSkinCoupon = arg0_1._tf:Find("AD/skin_coupon")
	arg0_1.rtLogin = arg0_1._tf:Find("AD/login")
	arg0_1.btnShop = arg0_1._tf:Find("AD/btn_shop")
	arg0_1.btnGift = arg0_1._tf:Find("AD/btn_gift")
	arg0_1.btnHelp = arg0_1._tf:Find("AD/btn_help")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.couponItemId = arg0_2.activity:getConfig("config_client").item_id
	arg0_2.couponGet = arg0_2.activity:getData1()

	local var0_2 = getProxy(ActivityProxy):getActivityById(Item.getConfigData(arg0_2.couponItemId).link_id)

	arg0_2.couponCount = var0_2 and not var0_2:isEnd() and var0_2:GetCanUsageCnt() or 0
	arg0_2.subActivity = getProxy(ActivityProxy):getActivityById(arg0_2.activity:getConfig("config_client").sub_act_id)
	arg0_2.nday = arg0_2.subActivity.data3
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.subActivity:getConfig("config_data")

	return updateActivityTaskStatus(arg0_2.subActivity)
end

function var0_0.GetPageLink(arg0_3)
	local var0_3 = arg0_3.activity:getConfig("config_client").sub_act_id

	return {
		var0_3
	}
end

function var0_0.OnFirstFlush(arg0_4)
	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_4:GetTips()
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnShop, function()
		arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP, {
			page = NewSkinShopScene.PAGE_RETURN
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnGift, function()
		arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_4:GetGiftShopType()
		})
	end, SFX_PANEL)

	for iter0_4, iter1_4 in ipairs(arg0_4.taskGroup) do
		local var0_4 = iter1_4[1]
		local var1_4 = arg0_4.taskProxy:getTaskVO(var0_4) or Task.New({
			id = var0_4
		})
		local var2_4 = arg0_4.rtLogin:GetChild(iter0_4 - 1)

		setText(var2_4:Find("day/Text"), "DAY" .. iter0_4)

		local var3_4 = Drop.Create(var1_4:getConfig("award_display")[1])

		updateDrop(var2_4:Find("IconTpl"), var3_4)
		onButton(arg0_4, var2_4:Find("get"), function()
			arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var1_4)
		end, SFX_CONFIRM)
		onButton(arg0_4, var2_4, function()
			arg0_4:emit(BaseUI.ON_DROP, var3_4)
		end)
	end

	onButton(arg0_4, arg0_4.rtSkinCoupon:Find("icon/get"), function()
		arg0_4:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_4.activity.id
		})
	end, SFX_CONFIRM)
end

function var0_0.OnUpdateFlush(arg0_11)
	local var0_11 = false

	for iter0_11, iter1_11 in ipairs(arg0_11.taskGroup) do
		local var1_11 = iter1_11[1]
		local var2_11 = arg0_11.taskProxy:getTaskVO(var1_11) or Task.New({
			id = var1_11
		})
		local var3_11 = arg0_11.rtLogin:GetChild(iter0_11 - 1)
		local var4_11 = var2_11:isReceive()

		setActive(var3_11:Find("got"), var4_11 or iter0_11 < arg0_11.nday)
		setActive(var3_11:Find("get"), not var0_11 and not var4_11 and iter0_11 == arg0_11.nday)

		var0_11 = var0_11 or isActive(var3_11:Find("get"))
	end

	local var5_11 = Drop.New({
		type = 8,
		id = arg0_11.couponItemId,
		count = arg0_11.couponGet
	})

	onButton(arg0_11, arg0_11.rtSkinCoupon:Find("icon"), function()
		arg0_11:emit(BaseUI.ON_DROP, var5_11)
	end, SFX_CONFIRM)
	updateDrop(arg0_11.rtSkinCoupon:Find("icon/IconTpl"), var5_11)
	setActive(arg0_11.rtSkinCoupon:Find("icon/get"), arg0_11.couponGet > 0)
	setText(arg0_11.rtSkinCoupon:Find("count"), arg0_11:GetCouponCountText())
	setActive(arg0_11.rtSkinCoupon:Find("icon/get"), arg0_11.couponGet > 0)
end

function var0_0.GetTips(arg0_13)
	return pg.gametip.SkinDiscountHelp_Winter.tip
end

function var0_0.GetCouponCountText(arg0_14)
	return arg0_14.couponCount
end

function var0_0.GetGiftShopType(arg0_15)
	return ChargeScene.TYPE_PICK
end

return var0_0
