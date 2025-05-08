local var0_0 = class("IslandOrderDescPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandOrderDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.infoPanel = arg0_2:findTF("info")
	arg0_2.nameTxt = arg0_2:findTF("info/name/Text"):GetComponent(typeof(Text))
	arg0_2.consumeUIList = UIItemList.New(arg0_2:findTF("info/subtitle_item/list"), arg0_2:findTF("info/subtitle_item/list/tpl"))
	arg0_2.awardUIList = UIItemList.New(arg0_2:findTF("info/subtitle_reward/list"), arg0_2:findTF("info/subtitle_reward/list/tpl"))
	arg0_2.submitBtn = arg0_2:findTF("info/btns/submit")
	arg0_2.submitBtnMark = arg0_2:findTF("info/btns/submit/mask")
	arg0_2.replaceBtn = arg0_2:findTF("info/btns/cancel")
	arg0_2.loadingPanel = arg0_2:findTF("loading")
	arg0_2.loadingTimeTxt = arg0_2.loadingPanel:Find("Text/time"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("info/btns/cancel/Text"), i18n1("驳回"))
	setText(arg0_2:findTF("info/btns/submit/Text"), i18n1("交付"))
	setText(arg0_2:findTF("loading/Text"), i18n1("订单正在重新准备中\n新的订单预计还需要                      "))
	setText(arg0_2:findTF("loading/submit/Text"), i18n1("加速"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.replaceBtn, function()
		arg0_3:emit(IslandMediator.ON_REPLACE_ORDER, arg0_3.slot.id)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.submitBtn, function()
		if not getProxy(IslandProxy):GetIsland():GetOrderAgency():CanSubmitOrder() then
			return
		end

		arg0_3:emit(IslandMediator.ON_SUBMIT_ORDER, arg0_3.slot.id)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_6.OnSubmitOrder)
	arg0_6:AddListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_6.OnReplaceOrder)
	arg0_6:AddListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_6.OnGenNewOrder)
	arg0_6:AddListener(IslandOrderAgency.UDPATE_ORDER, arg0_6.OnFlushOrder)
end

function var0_0.RemoveListener(arg0_7)
	arg0_7:RemoveListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_7.OnSubmitOrder)
	arg0_7:RemoveListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_7.OnReplaceOrder)
	arg0_7:RemoveListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_7.OnGenNewOrder)
	arg0_7:RemoveListener(IslandOrderAgency.UDPATE_ORDER, arg0_7.OnFlushOrder)
end

function var0_0.OnSubmitOrder(arg0_8, arg1_8)
	local var0_8 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_8.slotId)

	arg0_8:Flush(var0_8)
end

function var0_0.OnReplaceOrder(arg0_9, arg1_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_9.slotId)

	arg0_9:Flush(var0_9)
end

function var0_0.OnFlushOrder(arg0_10, arg1_10)
	arg0_10:TryFlushOrderInfo(arg1_10.slotId)
end

function var0_0.OnGenNewOrder(arg0_11, arg1_11)
	arg0_11:TryFlushOrderInfo(arg1_11.slotId)
end

function var0_0.TryFlushOrderInfo(arg0_12, arg1_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_12)

	if not arg0_12.slot then
		return
	end

	if arg0_12.slot.id ~= var0_12.id then
		return
	end

	arg0_12:Flush(var0_12)
end

function var0_0.Show(arg0_13, arg1_13)
	var0_0.super.Show(arg0_13)
	arg0_13:Flush(arg1_13)
end

function var0_0.Flush(arg0_14, arg1_14)
	arg0_14.slot = arg1_14

	if not arg1_14 or arg1_14:IsEmpty() then
		arg0_14:Hide()

		return
	end

	local var0_14 = arg1_14:IsLoading()

	setActive(arg0_14.infoPanel, not var0_14)
	setActive(arg0_14.loadingPanel, var0_14)
	arg0_14:RemoveSubmitCdTimer()
	arg0_14:RemoveLoadingTimer()
	arg0_14:RemoveDisappearTimer()

	if var0_14 then
		arg0_14:FlushLoadingPanel(arg1_14)
	else
		arg0_14:FlusInfoPanel(arg1_14)
	end

	if arg1_14:GetOrder():IsUrgency() then
		arg0_14:AddDisappearTimer(arg1_14)
	end
end

function var0_0.AddDisappearTimer(arg0_15, arg1_15)
	arg0_15:RemoveDisappearTimer()

	local var0_15 = arg1_15:GetDisappearTime()

	if var0_15 <= pg.TimeMgr.GetInstance():GetServerTime() then
		arg0_15:Hide()

		return
	end

	arg0_15.disappearTimer = Timer.New(function()
		local var0_16 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_15 - var0_16 < 0 then
			arg0_15:Hide()
		end
	end, 1, -1)

	arg0_15.disappearTimer.func()
	arg0_15.disappearTimer:Start()
end

function var0_0.RemoveDisappearTimer(arg0_17)
	if arg0_17.disappearTimer then
		arg0_17.disappearTimer:Stop()

		arg0_17.disappearTimer = nil
	end
end

function var0_0.FlushLoadingPanel(arg0_18, arg1_18)
	local function var0_18()
		arg0_18.loadingTimeTxt.text = ""

		arg0_18:Flush(arg1_18)
	end

	local var1_18 = arg1_18:GetCanSubmitTime()

	if var1_18 <= pg.TimeMgr.GetInstance():GetServerTime() then
		var0_18()

		return
	end

	arg0_18.loadingTimer = Timer.New(function()
		local var0_20 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_20 = var1_18 - var0_20

		arg0_18.loadingTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_20)

		if var1_20 < 0 then
			arg0_18:RemoveLoadingTimer()
			var0_18()
		end
	end, 1, -1)

	arg0_18.loadingTimer:Start()
	arg0_18.loadingTimer.func()
end

function var0_0.RemoveLoadingTimer(arg0_21)
	if arg0_21.loadingTimer then
		arg0_21.loadingTimer:Stop()

		arg0_21.loadingTimer = nil
	end
end

function var0_0.FlusInfoPanel(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetOrder()

	arg0_22:FlushAwards(var0_22)
	arg0_22:FlushConsume(var0_22)
	setActive(arg0_22.replaceBtn, not var0_22:IsUrgency())

	arg0_22.nameTxt.text = var0_22:GetRoleName()

	local var1_22, var2_22 = getProxy(IslandProxy):GetIsland():GetOrderAgency():CanSubmitOrder()

	setActive(arg0_22.submitBtnMark, not var0_22:CanFinish())

	if var1_22 then
		arg0_22:SetMaskFillAmount(arg0_22.submitBtnMark, 1)

		return
	end

	local var3_22 = pg.island_set.order_complete_refresh_time.key_value_int

	arg0_22.submitTimer = Timer.New(function()
		local var0_23 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_23 = (var2_22 - var0_23) / var3_22

		arg0_22:SetMaskFillAmount(arg0_22.submitBtnMark, 1 - var1_23)

		if var1_23 <= 0 then
			arg0_22:RemoveSubmitCdTimer()
		end
	end, 1, -1)

	arg0_22.submitTimer:Start()
	arg0_22.submitTimer.func()
end

function var0_0.SetMaskFillAmount(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24:GetComponent(typeof(RectMask2D))
	local var1_24 = arg1_24.sizeDelta.x * arg2_24

	var0_24.padding = Vector4(var1_24, 0, 0, 0)
end

function var0_0.FlushAwards(arg0_25, arg1_25)
	local var0_25 = arg1_25:GetDisplayAwards()

	arg0_25.awardUIList:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var0_25[arg1_26 + 1]

			updateDrop(arg2_26, var0_26)
		end
	end)
	arg0_25.awardUIList:align(#var0_25)
end

function var0_0.FlushConsume(arg0_27, arg1_27)
	local var0_27 = arg1_27:GetConsume()

	arg0_27.consumeUIList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var0_27[arg1_28 + 1]
			local var1_28 = {
				count = 0,
				type = var0_28.type,
				id = var0_28.id
			}

			updateDrop(arg2_28:Find("tpl"), var1_28)
			setText(arg2_28:Find("Text"), var1_28.cfg.name)

			local var2_28 = Drop.New({
				type = var1_28.type,
				id = var1_28.id
			}):getOwnedCount()
			local var3_28 = var2_28 >= var0_28.count

			if var3_28 then
				setText(arg2_28:Find("count"), var2_28 .. "/" .. var0_28.count)
			else
				setText(arg2_28:Find("count"), setColorStr(var2_28, COLOR_RED) .. "/" .. var0_28.count)
			end

			setActive(arg2_28:Find("finish"), var3_28)
			setActive(arg2_28:Find("line"), arg1_28 + 1 ~= #var0_27)
		end
	end)
	arg0_27.consumeUIList:align(#var0_27)
end

function var0_0.RemoveSubmitCdTimer(arg0_29)
	if arg0_29.submitTimer then
		arg0_29.submitTimer:Stop()

		arg0_29.submitTimer = nil
	end
end

function var0_0.OnDestroy(arg0_30)
	arg0_30:RemoveSubmitCdTimer()
	arg0_30:RemoveLoadingTimer()
	arg0_30:RemoveDisappearTimer()
end

return var0_0
