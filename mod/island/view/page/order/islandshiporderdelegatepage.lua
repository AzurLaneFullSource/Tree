local var0_0 = class("IslandShipOrderDelegatePage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 1
local var4_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandShipOrderDelegateUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.toggles = {
		[var3_0] = arg0_2._tf:Find("frame/tags/request"),
		[var4_0] = arg0_2._tf:Find("frame/tags/award")
	}
	arg0_2.toggleLabels = {
		[var3_0] = i18n("island_ship_order_toggle_label_request"),
		[var4_0] = i18n("island_ship_order_toggle_label_award")
	}
	arg0_2.confirmBtn = arg0_2._tf:Find("frame/confirm")
	arg0_2.cancelBtn = arg0_2._tf:Find("frame/cancel")
	arg0_2.refreshBtn = arg0_2._tf:Find("frame/refresh")
	arg0_2.speedUpBtn = arg0_2._tf:Find("frame/refresh/time")
	arg0_2.refreshTimeTxt = arg0_2._tf:Find("frame/refresh/time/Text"):GetComponent(typeof(Text))
	arg0_2.autoRefreshTimeTr = arg0_2._tf:Find("frame/list/label")
	arg0_2.autoRefreshTimeTxt = arg0_2._tf:Find("frame/list/label/Text/time"):GetComponent(typeof(Text))
	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("frame/list/content"), arg0_2._tf:Find("frame/list/content/tpl"))

	setText(arg0_2._tf:Find("frame/confirm/Text"), i18n("word_ok"))
	setText(arg0_2._tf:Find("frame/cancel/Text"), i18n("word_cancel"))
	setText(arg0_2._tf:Find("frame/list/label"), i18n("island_ship_order_delegate_auto_refresh_label"))
	setText(arg0_2._tf:Find("frame/list/label/Text"), i18n("island_ship_order_delegate_auto_refresh_time"))
end

function var0_0.IsEmptySlot(arg0_3)
	local var0_3 = arg0_3:GetIsland():GetOrderAgency():GetShipOrderSlot(arg0_3.slotId)

	return var0_3 and var0_3:IsEmpty()
end

function var0_0.IsAnyLoadUp(arg0_4)
	local var0_4 = arg0_4:GetIsland():GetOrderAgency():GetShipOrderSlot(arg0_4.slotId)

	return var0_4 and var0_4:GetOrder():IsAnyLoadUp()
end

function var0_0.CanExchange(arg0_5)
	local var0_5 = arg0_5:GetIsland():GetOrderAgency():GetShipOrderSlot(arg0_5.slotId)

	return var0_5 and var0_5:CanTransport()
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.confirmBtn, function()
		if arg0_6:IsSelectMode() and arg0_6.selectedId then
			local var0_7 = arg0_6.selectedId

			if arg0_6:IsEmptySlot() then
				arg0_6:emit(IslandMediator.EXCHANGE_SHIP_ORDER, arg0_6.slotId, var0_7)
			elseif arg0_6:IsAnyLoadUp() and not arg0_6:CanExchange() then
				pg.TipsMgr.GetInstance():ShowTip(i18n("island_order_ship_exchange_tip_2"))
			else
				local var1_7 = arg0_6:IsAnyLoadUp() and i18n("island_order_ship_exchange_tip_1") or i18n("island_order_ship_exchange_tip")

				arg0_6:ShowMsgBox({
					content = var1_7,
					onYes = function()
						arg0_6:emit(IslandMediator.EXCHANGE_SHIP_ORDER, arg0_6.slotId, var0_7)
					end
				})
			end
		end

		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.cancelBtn, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.refreshBtn, function()
		arg0_6:ShowMsgBox({
			content = i18n("island_order_ship_reset_all"),
			onYes = function()
				arg0_6:emit(IslandMediator.RESET_SHIP_ORDER)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.speedUpBtn, function()
		arg0_6:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.SHIP_ORDER_RELOAD, 0)
	end, SFX_PANEL)
	arg0_6:InitToggles()
end

function var0_0.AddListeners(arg0_14)
	arg0_14:AddListener(GAME.ISLAND_RESET_SHIP_ORDER_DONE, arg0_14.OnResetShipOrderList)
	arg0_14:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_14.OnUseTicketDone)
end

function var0_0.RemoveListeners(arg0_15)
	arg0_15:RemoveListener(GAME.ISLAND_RESET_SHIP_ORDER_DONE, arg0_15.OnResetShipOrderList)
	arg0_15:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_15.OnUseTicketDone)
end

function var0_0.OnUseTicketDone(arg0_16, arg1_16)
	if arg1_16.type == IslandUseTicketCommand.TYPES.SHIP_ORDER_RELOAD then
		arg0_16:FlushRefreshBtn()
	end
end

function var0_0.OnResetShipOrderList(arg0_17)
	arg0_17:InitList()
	arg0_17:FlushRefreshBtn()
end

function var0_0.OnShow(arg0_18, arg1_18)
	arg0_18.slotId = arg1_18

	arg0_18:UpdateMode(arg1_18)
	arg0_18:FlushRefreshBtn()
	arg0_18:InitList()
	arg0_18:TriggerDefaultToggle()
end

function var0_0.IsSelectMode(arg0_19)
	return arg0_19.mode == var2_0 and arg0_19.slotId ~= nil
end

function var0_0.UpdateMode(arg0_20, arg1_20)
	arg0_20.mode = var1_0

	if arg1_20 then
		arg0_20.mode = var2_0
	end
end

function var0_0.GetDisplays(arg0_21)
	local var0_21 = {}
	local var1_21 = arg0_21:GetIsland():GetOrderAgency():GetDelegateList()

	for iter0_21, iter1_21 in pairs(var1_21) do
		if iter1_21:CanShow() then
			table.insert(var0_21, iter1_21)
		end
	end

	return var0_21
end

function var0_0.InitList(arg0_22)
	local var0_22 = arg0_22:GetDisplays()

	arg0_22:RemoveNextAutoRefreshTimer()
	setActive(arg0_22.autoRefreshTimeTr, #var0_22 <= 0)

	if #var0_22 <= 0 then
		arg0_22.selectedId = nil

		arg0_22:AddNextAutoRefreshTimer()
		arg0_22.uiItemList:align(0)

		return
	end

	arg0_22.uiItemList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			arg0_22:UpdateItem(arg2_23, var0_22[arg1_23 + 1])
			onToggle(arg0_22, arg2_23, function(arg0_24)
				if arg0_24 then
					arg0_22.selectedId = var0_22[arg1_23 + 1].id
				end
			end, SFX_PANEL)

			if arg1_23 == 0 then
				triggerToggle(arg2_23, true)
			end
		end
	end)
	arg0_22.uiItemList:align(#var0_22)
end

function var0_0.AddNextAutoRefreshTimer(arg0_25)
	local var0_25 = arg0_25:GetIsland():GetOrderAgency():GetNextAutoReloadDelegateTime()

	arg0_25.autoTimer = Timer.New(function()
		local var0_26 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_26 = var0_25 - var0_26

		if var1_26 < 0 then
			arg0_25:RemoveNextAutoRefreshTimer()

			arg0_25.autoRefreshTimeTxt.text = ""

			if #arg0_25:GetDisplays() > 0 then
				arg0_25:InitList()
			end
		else
			arg0_25.autoRefreshTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_26)
		end
	end, 1, -1)

	arg0_25.autoTimer:Start()
	arg0_25.autoTimer.func()
end

function var0_0.RemoveNextAutoRefreshTimer(arg0_27)
	if arg0_27.autoTimer then
		arg0_27.autoTimer:Stop()

		arg0_27.autoTimer = nil
	end
end

function var0_0.UpdateItem(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg2_28:GetRequestList()

	setText(arg1_28:Find("num"), "0" .. arg2_28.id)

	local var1_28 = UIItemList.New(arg1_28:Find("request"), arg1_28:Find("request/tpl"))

	var1_28:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = var0_28[arg1_29 + 1]
			local var1_29 = Drop.New(var0_29)
			local var2_29 = var1_29.icon or var1_29:getConfig("icon")

			GetImageSpriteFromAtlasAsync("island/" .. var2_29, "", arg2_29:Find("icon"))

			local var3_29 = var1_29:getOwnedCount()

			setText(arg2_29:Find("cnt"), setColorStr(var3_29 .. "/" .. var1_29.count, var3_29 >= var1_29.count and "#39beff" or "#f36c6e"))
			setActive(arg2_29:Find("mark"), var3_29 >= var1_29.count)
		end
	end)
	var1_28:align(#var0_28)

	local var2_28 = arg2_28:GetAwardList()
	local var3_28 = UIItemList.New(arg1_28:Find("award"), arg1_28:Find("award/tpl"))

	var3_28:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = var2_28[arg1_30 + 1]
			local var1_30 = Drop.New(var0_30)

			updateCustomDrop(arg2_30, Drop.New(var0_30))
		end
	end)
	var3_28:align(#var2_28)
end

function var0_0.FlushRefreshBtn(arg0_31)
	local var0_31, var1_31 = arg0_31:GetIsland():GetOrderAgency():CanRefreshShipOrderDelegate()

	setGray(arg0_31.refreshBtn, not var0_31, true)
	setButtonEnabled(arg0_31.refreshBtn, var0_31)
	setActive(arg0_31.refreshTimeTxt.gameObject.transform.parent, not var0_31)
	arg0_31:RemoveRefreshTimer()

	if not var0_31 then
		arg0_31:AddRefreshTimer(var1_31)
	end
end

function var0_0.AddRefreshTimer(arg0_32, arg1_32)
	arg0_32.timer = Timer.New(function()
		local var0_33 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_33 = arg1_32 - var0_33

		if var1_33 < 0 then
			arg0_32:RemoveRefreshTimer()

			arg0_32.refreshTimeTxt.text = ""

			arg0_32:FlushRefreshBtn()
		else
			arg0_32.refreshTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_33)
		end
	end, 1, -1)

	arg0_32.timer:Start()
	arg0_32.timer.func()
end

function var0_0.RemoveRefreshTimer(arg0_34)
	if arg0_34.timer then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end
end

function var0_0.InitToggles(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.toggles) do
		onToggle(arg0_35, iter1_35, function(arg0_36)
			arg0_35:SwitchPage(iter0_35)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPage(arg0_37, arg1_37)
	arg0_37.pageIndex = arg1_37

	for iter0_37, iter1_37 in pairs(arg0_37.toggles) do
		local var0_37 = iter0_37 == arg1_37 and "#F9B64B" or "#707172"
		local var1_37 = setColorStr(arg0_37.toggleLabels[iter0_37], var0_37)

		setText(iter1_37:Find("Text"), var1_37)
	end

	arg0_37.uiItemList:each(function(arg0_38, arg1_38)
		setActive(arg1_38:Find("request"), arg1_37 == var3_0)
		setActive(arg1_38:Find("award"), arg1_37 == var4_0)
	end)
end

function var0_0.TriggerDefaultToggle(arg0_39)
	triggerToggle(arg0_39.toggles[var3_0], true)
end

function var0_0.RemoveTimers(arg0_40)
	arg0_40:RemoveRefreshTimer()
	arg0_40:RemoveNextAutoRefreshTimer()
end

function var0_0.OnHide(arg0_41)
	arg0_41:RemoveTimers()

	arg0_41.selectedId = nil
end

function var0_0.OnExit(arg0_42)
	arg0_42:RemoveTimers()

	arg0_42.selectedId = nil
end

return var0_0
