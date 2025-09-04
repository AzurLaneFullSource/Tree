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
	arg0_2.speedUpBtn = arg0_2:findTF("loading/submit")
	arg0_2.loadingPanel = arg0_2:findTF("loading")
	arg0_2.loadingTimeTxt = arg0_2.loadingPanel:Find("Text/time"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("info/btns/cancel/Text"), i18n("island_word_turndown"))
	setText(arg0_2:findTF("info/btns/submit/Text"), i18n("island_word_sbumit"))
	setText(arg0_2:findTF("loading/Text"), i18n("island_order_cd_tip"))
	setText(arg0_2:findTF("loading/submit/Text"), i18n("island_word_speedup"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.replaceBtn, function()
		arg0_3:emit(IslandMediator.ON_REPLACE_ORDER, arg0_3.slot.id)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.submitBtn, function()
		local var0_5, var1_5 = getProxy(IslandProxy):GetIsland():GetOrderAgency():CanSubmitOrder()

		if not var0_5 then
			local var2_5 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3_5 = pg.TimeMgr.GetInstance():DescCDTime(var1_5 - var2_5)

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_submit_order_cd_tip", var3_5))

			return
		end

		arg0_3:emit(IslandMediator.ON_SUBMIT_ORDER, arg0_3.slot.id)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.speedUpBtn, function()
		return
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_7.OnSubmitOrder)
	arg0_7:AddListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_7.OnReplaceOrder)
	arg0_7:AddListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_7.OnGenNewOrder)
	arg0_7:AddListener(IslandOrderAgency.UDPATE_ORDER, arg0_7.OnFlushOrder)
end

function var0_0.RemoveListener(arg0_8)
	arg0_8:RemoveListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_8.OnSubmitOrder)
	arg0_8:RemoveListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_8.OnReplaceOrder)
	arg0_8:RemoveListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_8.OnGenNewOrder)
	arg0_8:RemoveListener(IslandOrderAgency.UDPATE_ORDER, arg0_8.OnFlushOrder)
end

function var0_0.OnSubmitOrder(arg0_9, arg1_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_9.slotId)

	arg0_9:Flush(var0_9)
end

function var0_0.OnReplaceOrder(arg0_10, arg1_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_10.slotId)

	arg0_10:Flush(var0_10)
end

function var0_0.OnFlushOrder(arg0_11, arg1_11)
	arg0_11:TryFlushOrderInfo(arg1_11.slotId)
end

function var0_0.OnGenNewOrder(arg0_12, arg1_12)
	arg0_12:TryFlushOrderInfo(arg1_12.slotId)
end

function var0_0.TryFlushOrderInfo(arg0_13, arg1_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_13)

	if not arg0_13.slot then
		return
	end

	if arg0_13.slot.id ~= var0_13.id then
		return
	end

	arg0_13:Flush(var0_13)
end

function var0_0.Show(arg0_14, arg1_14)
	var0_0.super.Show(arg0_14)
	arg0_14:Flush(arg1_14)
end

function var0_0.Flush(arg0_15, arg1_15)
	arg0_15.slot = arg1_15

	if not arg1_15 or arg1_15:IsEmpty() then
		arg0_15:Hide()

		return
	end

	local var0_15 = arg1_15:IsLoading()

	setActive(arg0_15.infoPanel, not var0_15)
	setActive(arg0_15.loadingPanel, var0_15)
	arg0_15:RemoveSubmitCdTimer()
	arg0_15:RemoveLoadingTimer()
	arg0_15:RemoveDisappearTimer()

	if var0_15 then
		arg0_15:FlushLoadingPanel(arg1_15)
	else
		arg0_15:FlusInfoPanel(arg1_15)
	end

	if arg1_15:GetOrder():IsUrgency() then
		arg0_15:AddDisappearTimer(arg1_15)
	end
end

function var0_0.AddDisappearTimer(arg0_16, arg1_16)
	arg0_16:RemoveDisappearTimer()

	local var0_16 = arg1_16:GetDisappearTime()

	if var0_16 <= pg.TimeMgr.GetInstance():GetServerTime() then
		arg0_16:Hide()

		return
	end

	arg0_16.disappearTimer = Timer.New(function()
		local var0_17 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_16 - var0_17 < 0 then
			arg0_16:Hide()
		end
	end, 1, -1)

	arg0_16.disappearTimer.func()
	arg0_16.disappearTimer:Start()
end

function var0_0.RemoveDisappearTimer(arg0_18)
	if arg0_18.disappearTimer then
		arg0_18.disappearTimer:Stop()

		arg0_18.disappearTimer = nil
	end
end

function var0_0.FlushLoadingPanel(arg0_19, arg1_19)
	local function var0_19()
		arg0_19.loadingTimeTxt.text = ""

		arg0_19:Flush(arg1_19)
	end

	local var1_19 = arg1_19:GetCanSubmitTime()

	if var1_19 <= pg.TimeMgr.GetInstance():GetServerTime() then
		var0_19()

		return
	end

	arg0_19.loadingTimer = Timer.New(function()
		local var0_21 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_21 = var1_19 - var0_21

		arg0_19.loadingTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_21)

		if var1_21 < 0 then
			arg0_19:RemoveLoadingTimer()
			var0_19()
		end
	end, 1, -1)

	arg0_19.loadingTimer:Start()
	arg0_19.loadingTimer.func()
end

function var0_0.RemoveLoadingTimer(arg0_22)
	if arg0_22.loadingTimer then
		arg0_22.loadingTimer:Stop()

		arg0_22.loadingTimer = nil
	end
end

function var0_0.FlusInfoPanel(arg0_23, arg1_23)
	local var0_23 = arg1_23:GetOrder()

	arg0_23:FlushAwards(var0_23)
	arg0_23:FlushConsume(var0_23)
	setActive(arg0_23.replaceBtn, not var0_23:IsUrgency())

	arg0_23.nameTxt.text = var0_23:GetRoleName()

	local var1_23, var2_23 = getProxy(IslandProxy):GetIsland():GetOrderAgency():CanSubmitOrder()

	setActive(arg0_23.submitBtnMark, not var0_23:CanFinish())

	if var1_23 then
		arg0_23:SetMaskFillAmount(arg0_23.submitBtnMark, 1)

		return
	end

	local var3_23 = pg.island_set.order_complete_refresh_time.key_value_int

	arg0_23.submitTimer = Timer.New(function()
		local var0_24 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_24 = (var2_23 - var0_24) / var3_23

		arg0_23:SetMaskFillAmount(arg0_23.submitBtnMark, 1 - var1_24)

		if var1_24 <= 0 then
			arg0_23:RemoveSubmitCdTimer()
		end
	end, 1, -1)

	arg0_23.submitTimer:Start()
	arg0_23.submitTimer.func()
end

function var0_0.SetMaskFillAmount(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg1_25:GetComponent(typeof(RectMask2D))
	local var1_25 = arg1_25.sizeDelta.x * arg2_25

	var0_25.padding = Vector4(var1_25, 0, 0, 0)
end

function var0_0.FlushAwards(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetDisplayAwards()

	arg0_26.awardUIList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = var0_26[arg1_27 + 1]

			updateCustomDrop(arg2_27, var0_27)
		end
	end)
	arg0_26.awardUIList:align(#var0_26)
end

function var0_0.FlushConsume(arg0_28, arg1_28)
	local var0_28 = arg1_28:GetConsume()

	arg0_28.consumeUIList:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = var0_28[arg1_29 + 1]
			local var1_29 = {
				count = 0,
				type = var0_29.type,
				id = var0_29.id
			}

			updateCustomDrop(arg2_29:Find("tpl"), var1_29)
			setText(arg2_29:Find("Text"), var1_29.cfg.name)

			local var2_29 = Drop.New({
				type = var1_29.type,
				id = var1_29.id
			}):getOwnedCount()
			local var3_29 = var2_29 >= var0_29.count

			if var3_29 then
				setText(arg2_29:Find("count"), var2_29 .. "/" .. var0_29.count)
			else
				setText(arg2_29:Find("count"), setColorStr(var2_29, COLOR_RED) .. "/" .. var0_29.count)
			end

			setActive(arg2_29:Find("finish"), var3_29)
			setActive(arg2_29:Find("line"), arg1_29 + 1 ~= #var0_28)
		end
	end)
	arg0_28.consumeUIList:align(#var0_28)
end

function var0_0.RemoveSubmitCdTimer(arg0_30)
	if arg0_30.submitTimer then
		arg0_30.submitTimer:Stop()

		arg0_30.submitTimer = nil
	end
end

function var0_0.OnDestroy(arg0_31)
	arg0_31:RemoveSubmitCdTimer()
	arg0_31:RemoveLoadingTimer()
	arg0_31:RemoveDisappearTimer()
end

return var0_0
