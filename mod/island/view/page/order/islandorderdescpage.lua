local var0_0 = class("IslandOrderDescPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandOrderDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.infoPanel = arg0_2._tf:Find("info")
	arg0_2.nameTxt = arg0_2._tf:Find("info/name/Text"):GetComponent(typeof(Text))
	arg0_2.consumeUIList = UIItemList.New(arg0_2._tf:Find("info/subtitle_item/list"), arg0_2._tf:Find("info/subtitle_item/list/tpl"))
	arg0_2.awardUIList = UIItemList.New(arg0_2._tf:Find("info/subtitle_reward/list"), arg0_2._tf:Find("info/subtitle_reward/list/tpl"))
	arg0_2.submitBtn = arg0_2._tf:Find("info/btns/submit")
	arg0_2.submitBtnMark = arg0_2._tf:Find("info/btns/submit/mask")
	arg0_2.replaceBtn = arg0_2._tf:Find("info/btns/cancel")
	arg0_2.speedUpBtn = arg0_2._tf:Find("loading/submit")
	arg0_2.loadingPanel = arg0_2._tf:Find("loading")
	arg0_2.loadingTimeTxt = arg0_2.loadingPanel:Find("Text/time"):GetComponent(typeof(Text))

	setText(arg0_2._tf:Find("info/btns/cancel/Text"), i18n("island_word_turndown"))
	setText(arg0_2._tf:Find("info/btns/submit/Text"), i18n("island_word_sbumit"))
	setText(arg0_2._tf:Find("loading/Text"), i18n("island_order_cd_tip"))
	setText(arg0_2._tf:Find("loading/submit/Text"), i18n("island_word_speedup"))
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
		arg0_3:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.ORDER_CD, arg0_3.slot.id)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_7.OnSubmitOrder)
	arg0_7:AddListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_7.OnReplaceOrder)
	arg0_7:AddListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_7.OnGenNewOrder)
	arg0_7:AddListener(IslandOrderAgency.UDPATE_ORDER, arg0_7.OnFlushOrder)
	arg0_7:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_7.OnUseTicketDone)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_8.OnSubmitOrder)
	arg0_8:RemoveListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_8.OnReplaceOrder)
	arg0_8:RemoveListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_8.OnGenNewOrder)
	arg0_8:RemoveListener(IslandOrderAgency.UDPATE_ORDER, arg0_8.OnFlushOrder)
	arg0_8:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_8.OnUseTicketDone)
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

function var0_0.OnUseTicketDone(arg0_12, arg1_12)
	if arg1_12.type == IslandUseTicketCommand.TYPES.ORDER_CD then
		arg0_12:TryFlushOrderInfo(arg1_12.id)
	end
end

function var0_0.OnGenNewOrder(arg0_13, arg1_13)
	arg0_13:TryFlushOrderInfo(arg1_13.slotId)
end

function var0_0.TryFlushOrderInfo(arg0_14, arg1_14)
	local var0_14 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_14)

	if not arg0_14.slot then
		return
	end

	if arg0_14.slot.id ~= var0_14.id then
		return
	end

	arg0_14:Flush(var0_14)
end

function var0_0.Show(arg0_15, arg1_15)
	var0_0.super.Show(arg0_15)
	arg0_15:Flush(arg1_15)
end

function var0_0.Flush(arg0_16, arg1_16)
	arg0_16.slot = arg1_16

	if not arg1_16 or arg1_16:IsEmpty() then
		arg0_16:Hide()

		return
	end

	local var0_16 = arg1_16:IsLoading()

	setActive(arg0_16.infoPanel, not var0_16)
	setActive(arg0_16.loadingPanel, var0_16)
	arg0_16:RemoveSubmitCdTimer()
	arg0_16:RemoveLoadingTimer()
	arg0_16:RemoveDisappearTimer()

	if var0_16 then
		arg0_16:FlushLoadingPanel(arg1_16)
	else
		arg0_16:FlusInfoPanel(arg1_16)
	end

	if arg1_16:GetOrder():IsUrgency() then
		arg0_16:AddDisappearTimer(arg1_16)
	end
end

function var0_0.AddDisappearTimer(arg0_17, arg1_17)
	arg0_17:RemoveDisappearTimer()

	local var0_17 = arg1_17:GetDisappearTime()

	if var0_17 <= pg.TimeMgr.GetInstance():GetServerTime() then
		arg0_17:Hide()

		return
	end

	arg0_17.disappearTimer = Timer.New(function()
		local var0_18 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_17 - var0_18 < 0 then
			arg0_17:Hide()
		end
	end, 1, -1)

	arg0_17.disappearTimer.func()
	arg0_17.disappearTimer:Start()
end

function var0_0.RemoveDisappearTimer(arg0_19)
	if arg0_19.disappearTimer then
		arg0_19.disappearTimer:Stop()

		arg0_19.disappearTimer = nil
	end
end

function var0_0.FlushLoadingPanel(arg0_20, arg1_20)
	local function var0_20()
		arg0_20.loadingTimeTxt.text = ""

		arg0_20:Flush(arg1_20)
	end

	local var1_20 = arg1_20:GetCanSubmitTime()

	if var1_20 <= pg.TimeMgr.GetInstance():GetServerTime() then
		var0_20()

		return
	end

	arg0_20.loadingTimer = Timer.New(function()
		local var0_22 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_22 = var1_20 - var0_22

		arg0_20.loadingTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_22)

		if var1_22 < 0 then
			arg0_20:RemoveLoadingTimer()
			var0_20()
		end
	end, 1, -1)

	arg0_20.loadingTimer:Start()
	arg0_20.loadingTimer.func()
end

function var0_0.RemoveLoadingTimer(arg0_23)
	if arg0_23.loadingTimer then
		arg0_23.loadingTimer:Stop()

		arg0_23.loadingTimer = nil
	end
end

function var0_0.FlusInfoPanel(arg0_24, arg1_24)
	local var0_24 = arg1_24:GetOrder()

	arg0_24:FlushAwards(var0_24)
	arg0_24:FlushConsume(var0_24)
	setActive(arg0_24.replaceBtn, not var0_24:IsUrgency())

	arg0_24.nameTxt.text = var0_24:GetRoleName()

	local var1_24, var2_24 = getProxy(IslandProxy):GetIsland():GetOrderAgency():CanSubmitOrder()

	setActive(arg0_24.submitBtnMark, not var0_24:CanFinish())

	if var1_24 then
		arg0_24:SetMaskFillAmount(arg0_24.submitBtnMark, 1)

		return
	end

	local var3_24 = pg.island_set.order_complete_refresh_time.key_value_int

	arg0_24.submitTimer = Timer.New(function()
		local var0_25 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_25 = (var2_24 - var0_25) / var3_24

		arg0_24:SetMaskFillAmount(arg0_24.submitBtnMark, 1 - var1_25)

		if var1_25 <= 0 then
			arg0_24:RemoveSubmitCdTimer()
		end
	end, 1, -1)

	arg0_24.submitTimer:Start()
	arg0_24.submitTimer.func()
end

function var0_0.SetMaskFillAmount(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg1_26:GetComponent(typeof(RectMask2D))
	local var1_26 = arg1_26.sizeDelta.x * arg2_26

	var0_26.padding = Vector4(var1_26, 0, 0, 0)
end

function var0_0.FlushAwards(arg0_27, arg1_27)
	local var0_27 = arg1_27:GetDisplayAwards()

	arg0_27.awardUIList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var0_27[arg1_28 + 1]

			updateCustomDrop(arg2_28, var0_28)
			onButton(arg0_27, arg2_28, function()
				arg0_27:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var0_28
				})
			end)
		end
	end)
	arg0_27.awardUIList:align(#var0_27)
end

function var0_0.FlushConsume(arg0_30, arg1_30)
	local var0_30 = arg1_30:GetConsume()

	arg0_30.consumeUIList:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = var0_30[arg1_31 + 1]
			local var1_31 = {
				count = 0,
				type = var0_31.type,
				id = var0_31.id
			}

			updateCustomDrop(arg2_31:Find("tpl"), var1_31)
			onButton(arg0_30, arg2_31, function()
				arg0_30:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var1_31
				})
			end)
			setText(arg2_31:Find("Text"), var1_31.cfg.name)

			local var2_31 = Drop.New({
				type = var1_31.type,
				id = var1_31.id
			}):getOwnedCount()
			local var3_31 = var2_31 >= var0_31.count

			if var3_31 then
				setText(arg2_31:Find("count"), var2_31 .. "/" .. var0_31.count)
			else
				setText(arg2_31:Find("count"), setColorStr(var2_31, COLOR_RED) .. "/" .. var0_31.count)
			end

			setActive(arg2_31:Find("finish"), var3_31)
			setActive(arg2_31:Find("line"), arg1_31 + 1 ~= #var0_30)
		end
	end)
	arg0_30.consumeUIList:align(#var0_30)
end

function var0_0.RemoveSubmitCdTimer(arg0_33)
	if arg0_33.submitTimer then
		arg0_33.submitTimer:Stop()

		arg0_33.submitTimer = nil
	end
end

function var0_0.OnDestroy(arg0_34)
	arg0_34:RemoveSubmitCdTimer()
	arg0_34:RemoveLoadingTimer()
	arg0_34:RemoveDisappearTimer()
end

return var0_0
