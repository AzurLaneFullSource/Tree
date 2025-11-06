local var0_0 = class("IslandShipOrderPage", import("...base.IslandBasePage"))

var0_0.MODE_REQUEST_VIEW = 0
var0_0.MODE_AWARD_VIEW = 1
var0_0.EVENT_CLOSE_LOAD_UP = "IslandShipOrderPage:EVENT_CLOSE_LOAD_UP"

function var0_0.getUIName(arg0_1)
	return "IslandShipOrderUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("back")
	arg0_2.uiSlots = UIItemList.New(arg0_2._tf:Find("frame/list"), arg0_2._tf:Find("frame/list/tpl"))
	arg0_2.onekeySlots = UIItemList.New(arg0_2._tf:Find("list_1"), arg0_2._tf:Find("list_1/onekey"))
	arg0_2.switchBtn = arg0_2._tf:Find("frame/switch")
	arg0_2.cards = {}
	arg0_2.loadUpPage = IslandShipOrderLoadUpPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.delegateBtn = arg0_2._tf:Find("frame/event_btn")
	arg0_2.uilistAniamtion = arg0_2._tf:Find("frame/list"):GetComponent(typeof(Animation))

	setText(arg0_2._tf:Find("frame/switch/on/Text"), i18n("island_order_ship_page_req"))
	setText(arg0_2._tf:Find("frame/switch/off/Text"), i18n("island_order_ship_page_award"))
	setText(arg0_2._tf:Find("list_1/onekey/btn/Text"), i18n("island_order_ship_page_onekey_loadup"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("frame/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_ship_order.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.delegateBtn, function()
		arg0_3:OpenPage(IslandShipOrderDelegatePage)
	end, SFX_PANEL)
	arg0_3:bind(var0_0.EVENT_CLOSE_LOAD_UP, function()
		arg0_3:ClearSelected()
	end)
	triggerToggle(arg0_3.switchBtn, false)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_8)
		arg0_3:SwitchMode(arg0_8)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_9.OnOrderUpdate)
	arg0_9:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_9.OnUseTicketDone)
	arg0_9:AddListener(GAME.ISLAND_REFRESH_SHIP_ORDER_DONE, arg0_9.OnRefreshOrder)
	arg0_9:AddListener(IslandShipOrderCard.EVENT_CD_END, arg0_9.OnOrderReloadingEnd)
	arg0_9:AddListener(GAME.ISLAND_EXCHANGE_SHIP_ORDER_DONE, arg0_9.OnExchangeShipOrderDone)
	arg0_9:AddListener(GAME.ISLAND_RESET_SHIP_ORDER_DONE, arg0_9.OnResetShipOrderList)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_10.OnOrderUpdate)
	arg0_10:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_10.OnUseTicketDone)
	arg0_10:RemoveListener(GAME.ISLAND_REFRESH_SHIP_ORDER_DONE, arg0_10.OnRefreshOrder)
	arg0_10:RemoveListener(IslandShipOrderCard.EVENT_CD_END, arg0_10.OnOrderReloadingEnd)
	arg0_10:RemoveListener(GAME.ISLAND_EXCHANGE_SHIP_ORDER_DONE, arg0_10.OnExchangeShipOrderDone)
	arg0_10:RemoveListener(GAME.ISLAND_RESET_SHIP_ORDER_DONE, arg0_10.OnResetShipOrderList)
end

function var0_0.OnResetShipOrderList(arg0_11)
	arg0_11:FlushSlots()
end

function var0_0.OnExchangeShipOrderDone(arg0_12, arg1_12)
	arg0_12:OnRefreshOrder({
		id = arg1_12.id
	})
	arg0_12:UpdateOnekeyBtns()
end

function var0_0.OnOrderReloadingEnd(arg0_13)
	arg0_13:UpdateOnekeyBtns()
end

function var0_0.OnRefreshOrder(arg0_14, arg1_14)
	local var0_14 = arg1_14.id
	local var1_14

	for iter0_14, iter1_14 in pairs(arg0_14.cards) do
		if iter1_14.slot.id == var0_14 then
			var1_14 = iter1_14

			break
		end
	end

	if not var1_14 then
		return
	end

	var1_14:Flush(var1_14.slot, arg0_14.mode)
	arg0_14:UpdateOnekeyBtns()
end

function var0_0.OnOrderUpdate(arg0_15, arg1_15)
	local var0_15 = arg1_15.id
	local var1_15

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		if iter1_15.slot.id == var0_15 then
			var1_15 = iter1_15

			break
		end
	end

	if not var1_15 then
		return
	end

	arg0_15:ClearSelected()

	arg0_15.canvasGroup.blocksRaycasts = false

	seriesAsync({
		function(arg0_16)
			var1_15:PlayAniamtion(arg1_15.op, arg1_15.isLoadUpAll, arg0_16)
		end
	}, function()
		arg0_15.canvasGroup.blocksRaycasts = true

		var1_15:Flush(var1_15.slot, arg0_15.mode)
		arg0_15:RegisterCardEvent(var1_15)

		for iter0_17, iter1_17 in pairs(arg0_15.cards) do
			iter1_17:UpdateRequest(iter1_17.slot)
		end

		arg0_15:UpdateOnekeyBtns()
	end)
end

function var0_0.OnUseTicketDone(arg0_18, arg1_18)
	if arg1_18.type == IslandUseTicketCommand.TYPES.SHIP_ORDER then
		local var0_18 = arg1_18.id
		local var1_18

		for iter0_18, iter1_18 in pairs(arg0_18.cards) do
			if iter1_18.slot.id == var0_18 then
				var1_18 = iter1_18

				break
			end
		end

		if not var1_18 then
			return
		end

		var1_18:Flush(var1_18.slot, arg0_18.mode)
	end

	arg0_18:UpdateOnekeyBtns()
end

function var0_0.OnShow(arg0_19)
	arg0_19.mode = var0_0.MODE_REQUEST_VIEW
	arg0_19.canvasGroup.blocksRaycasts = true

	arg0_19:FlushSlots()
	arg0_19:UnlockFirstSlot()
end

function var0_0.UnlockFirstSlot(arg0_20)
	local var0_20 = arg0_20.displays[1]

	if var0_20 and var0_20:IsLock() and var0_20:GetUnlockGold().count <= 0 then
		for iter0_20, iter1_20 in pairs(arg0_20.cards) do
			if iter1_20.slot.id == var0_20.id then
				target = iter1_20

				break
			end
		end

		if target then
			triggerButton(target.lockTr)
		end
	end
end

function var0_0.SwitchMode(arg0_21, arg1_21)
	arg0_21.mode = arg1_21 and var0_0.MODE_AWARD_VIEW or var0_0.MODE_REQUEST_VIEW

	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		iter1_21:SwitchMode(iter1_21.slot, arg0_21.mode)
	end

	arg0_21:ClearSelected()
	arg0_21.uilistAniamtion:Stop()
	arg0_21.uilistAniamtion:Play("anim_island_shiporder_list")
end

function var0_0.GetDisplays(arg0_22, ...)
	local var0_22 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipSlotList()
	local var1_22 = {}

	for iter0_22, iter1_22 in pairs(var0_22) do
		table.insert(var1_22, iter1_22)
	end

	return var1_22
end

function var0_0.FlushSlots(arg0_23)
	arg0_23.displays = arg0_23:GetDisplays()

	table.sort(arg0_23.displays, function(arg0_24, arg1_24)
		return arg0_24:GetUnlockLevel() < arg1_24:GetUnlockLevel()
	end)
	arg0_23.uiSlots:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = arg0_23.displays[arg1_25 + 1].nextRefreshFinishCntTime
			local var1_25 = pg.TimeMgr.GetInstance():GetServerTime()

			print(arg0_23.displays[arg1_25 + 1].finishCnt, var0_25 <= var1_25)
			arg0_23:UpdateSlot(arg0_23.displays[arg1_25 + 1], arg2_25)
		end
	end)
	arg0_23.uiSlots:align(#arg0_23.displays)
	arg0_23:UpdateOnekeyBtns()
end

function var0_0.UpdateOnekeyBtns(arg0_26)
	arg0_26.onekeySlots:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = arg2_27:Find("btn")
			local var1_27 = arg0_26.displays[arg1_27 + 1]

			setActive(var0_27, var1_27:IsWaiting() and not var1_27:IsEmpty())

			local var2_27 = var1_27:IsWaiting() and not var1_27:GetOrder():AnyCanLoadUp() or not var1_27:CanTransport()

			setGray(var0_27, var2_27, true)

			if not var2_27 then
				onButton(arg0_26, var0_27, function()
					if var1_27:IsEmpty() then
						return
					end

					arg0_26:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME_ONEKEY, var1_27.id)
				end, SFX_PANEL)
			else
				removeOnButton(var0_27)
			end
		end
	end)
	arg0_26.onekeySlots:align(#arg0_26.displays)
end

function var0_0.UpdateSlot(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.cards[arg2_29] or IslandShipOrderCard.New(arg2_29, arg0_29)

	var0_29:Flush(arg1_29, arg0_29.mode)
	onButton(arg0_29, var0_29.getBtn, function()
		arg0_29:emit(IslandMediator.GET_SHIP_ORDER_AWARD, var0_29.slot.id)
	end, SFX_PANEL)
	onButton(arg0_29, var0_29.lockTr, function()
		arg0_29:emit(IslandMediator.UNLOKC_SHIP_ORDER, var0_29.slot.id)
	end, SFX_PANEL)
	onButton(arg0_29, var0_29.loadingRequest, function()
		arg0_29:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.SHIP_ORDER, var0_29.slot.id)
	end, SFX_PANEL)
	onButton(arg0_29, var0_29.exchangeBtn, function()
		arg0_29:OpenPage(IslandShipOrderDelegatePage, var0_29.slot.id)
	end, SFX_PANEL)
	onButton(arg0_29, var0_29.emptyTr, function()
		arg0_29:OpenPage(IslandShipOrderDelegatePage, var0_29.slot.id)
	end, SFX_PANEL)
	onNextTick(function()
		arg0_29:RegisterCardEvent(var0_29)
	end)

	arg0_29.cards[arg2_29] = var0_29
end

function var0_0.CheckSelected(arg0_36, arg1_36)
	if arg0_36.loadUpItem == arg1_36 then
		arg0_36:ClearSelected()

		return false
	end

	return true
end

function var0_0.RegisterCardEvent(arg0_37, arg1_37)
	arg1_37.uiRequestList:each(function(arg0_38, arg1_38)
		onButton(arg0_37, arg1_38, function()
			if not arg1_37.slot:IsWaiting() then
				return
			end

			if arg1_37.slot:GetOrder():ItemIsSubmited(arg0_38 + 1) then
				return
			end

			if not arg0_37:CheckSelected(arg1_38) then
				return
			end

			arg0_37:ClearSelected()
			setActive(arg1_38:Find("loaded_1"), true)
			arg0_37:LoadUpItem(arg1_37, arg0_38 + 1, arg1_38)
		end, SFX_PANEL)
	end)
end

function var0_0.ClearSelected(arg0_40)
	if arg0_40.loadUpItem then
		setActive(arg0_40.loadUpItem:Find("loaded_1"), false)
	end

	arg0_40.loadUpItem = nil

	if arg0_40.loadUpPage and arg0_40.loadUpPage:GetLoaded() and arg0_40.loadUpPage:isShowing() then
		arg0_40.loadUpPage:Hide()
	end
end

function var0_0.LoadUpItem(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41 = arg0_41._tf:InverseTransformPoint(arg3_41:Find("loaded_1").position)

	arg0_41.loadUpPage:ExecuteAction("Show", Vector3(var0_41.x, var0_41.y, 0), arg1_41.slot, arg2_41)

	arg0_41.loadUpItem = arg3_41
end

function var0_0.OnHide(arg0_42)
	arg0_42:ClearSelected()

	if arg0_42.loadUpPage then
		arg0_42.loadUpPage:Destroy()
		arg0_42.loadUpPage:Reset()
	end
end

function var0_0.OnDestroy(arg0_43)
	for iter0_43, iter1_43 in pairs(arg0_43.cards) do
		iter1_43:Dispose()
	end

	arg0_43.cards = {}

	if arg0_43.loadUpPage then
		arg0_43.loadUpPage:Destroy()

		arg0_43.loadUpPage = nil
	end
end

return var0_0
