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
	arg0_3:bind(var0_0.EVENT_CLOSE_LOAD_UP, function()
		arg0_3:ClearSelected()
	end)
	triggerToggle(arg0_3.switchBtn, false)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_7)
		arg0_3:SwitchMode(arg0_7)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_8)
	arg0_8:AddListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_8.OnOrderUpdate)
	arg0_8:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_8.OnUseTicketDone)
	arg0_8:AddListener(GAME.ISLAND_REFRESH_SHIP_ORDER_DONE, arg0_8.OnRefreshOrder)
	arg0_8:AddListener(IslandShipOrderCard.EVENT_CD_END, arg0_8.OnOrderReloadingEnd)
end

function var0_0.RemoveListeners(arg0_9)
	arg0_9:RemoveListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_9.OnOrderUpdate)
	arg0_9:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_9.OnUseTicketDone)
	arg0_9:RemoveListener(GAME.ISLAND_REFRESH_SHIP_ORDER_DONE, arg0_9.OnRefreshOrder)
	arg0_9:RemoveListener(IslandShipOrderCard.EVENT_CD_END, arg0_9.OnOrderReloadingEnd)
end

function var0_0.OnOrderReloadingEnd(arg0_10)
	arg0_10:UpdateOnekeyBtns()
end

function var0_0.OnRefreshOrder(arg0_11, arg1_11)
	local var0_11 = arg1_11.id
	local var1_11

	for iter0_11, iter1_11 in pairs(arg0_11.cards) do
		if iter1_11.slot.id == var0_11 then
			var1_11 = iter1_11

			break
		end
	end

	if not var1_11 then
		return
	end

	var1_11:Flush(var1_11.slot, arg0_11.mode)
	arg0_11:UpdateOnekeyBtns()
end

function var0_0.OnOrderUpdate(arg0_12, arg1_12)
	local var0_12 = arg1_12.id
	local var1_12

	for iter0_12, iter1_12 in pairs(arg0_12.cards) do
		if iter1_12.slot.id == var0_12 then
			var1_12 = iter1_12

			break
		end
	end

	if not var1_12 then
		return
	end

	arg0_12:ClearSelected()

	arg0_12.canvasGroup.blocksRaycasts = false

	seriesAsync({
		function(arg0_13)
			var1_12:PlayAniamtion(arg1_12.op, arg1_12.isLoadUpAll, arg0_13)
		end
	}, function()
		arg0_12.canvasGroup.blocksRaycasts = true

		var1_12:Flush(var1_12.slot, arg0_12.mode)
		arg0_12:RegisterCardEvent(var1_12)

		for iter0_14, iter1_14 in pairs(arg0_12.cards) do
			iter1_14:UpdateRequest(iter1_14.slot)
		end

		arg0_12:UpdateOnekeyBtns()
	end)
end

function var0_0.OnUseTicketDone(arg0_15, arg1_15)
	if arg1_15.type == IslandUseTicketCommand.TYPES.SHIP_ORDER or arg1_15.type == IslandUseTicketCommand.TYPES.SHIP_ORDER_RELOAD then
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

		var1_15:Flush(var1_15.slot, arg0_15.mode)
		arg0_15:UpdateOnekeyBtns()
	end
end

function var0_0.OnShow(arg0_16)
	arg0_16.mode = var0_0.MODE_REQUEST_VIEW
	arg0_16.canvasGroup.blocksRaycasts = true

	arg0_16:FlushSlots()
	arg0_16:UnlockFirstSlot()
end

function var0_0.UnlockFirstSlot(arg0_17)
	local var0_17 = arg0_17.displays[1]

	if var0_17 and var0_17:IsLock() and var0_17:GetUnlockGold().count <= 0 then
		for iter0_17, iter1_17 in pairs(arg0_17.cards) do
			if iter1_17.slot.id == var0_17.id then
				target = iter1_17

				break
			end
		end

		if target then
			triggerButton(target.lockTr)
		end
	end
end

function var0_0.SwitchMode(arg0_18, arg1_18)
	arg0_18.mode = arg1_18 and var0_0.MODE_AWARD_VIEW or var0_0.MODE_REQUEST_VIEW

	for iter0_18, iter1_18 in pairs(arg0_18.cards) do
		iter1_18:SwitchMode(iter1_18.slot, arg0_18.mode)
	end

	arg0_18:ClearSelected()
	arg0_18.uilistAniamtion:Stop()
	arg0_18.uilistAniamtion:Play("anim_island_shiporder_list")
end

function var0_0.GetDisplays(arg0_19, ...)
	local var0_19 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipSlotList()
	local var1_19 = {}

	for iter0_19, iter1_19 in pairs(var0_19) do
		table.insert(var1_19, iter1_19)
	end

	return var1_19
end

function var0_0.FlushSlots(arg0_20)
	arg0_20.displays = arg0_20:GetDisplays()

	table.sort(arg0_20.displays, function(arg0_21, arg1_21)
		return arg0_21:GetUnlockLevel() < arg1_21:GetUnlockLevel()
	end)
	arg0_20.uiSlots:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			arg0_20:UpdateSlot(arg0_20.displays[arg1_22 + 1], arg2_22)
		end
	end)
	arg0_20.uiSlots:align(#arg0_20.displays)
	arg0_20:UpdateOnekeyBtns()
end

function var0_0.UpdateOnekeyBtns(arg0_23)
	arg0_23.onekeySlots:make(function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = arg2_24:Find("btn")
			local var1_24 = arg0_23.displays[arg1_24 + 1]

			setActive(var0_24, var1_24:IsWaiting() and not var1_24:IsReloading())

			local var2_24 = var1_24:IsWaiting() and not var1_24:GetOrder():AnyCanLoadUp()

			setGray(var0_24, var2_24, true)

			if not var2_24 then
				onButton(arg0_23, var0_24, function()
					if var1_24:IsReloading() then
						return
					end

					arg0_23:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME_ONEKEY, var1_24.id)
				end, SFX_PANEL)
			else
				removeOnButton(var0_24)
			end
		end
	end)
	arg0_23.onekeySlots:align(#arg0_23.displays)
end

function var0_0.UpdateSlot(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26.cards[arg2_26] or IslandShipOrderCard.New(arg2_26, arg0_26)

	var0_26:Flush(arg1_26, arg0_26.mode)
	onButton(arg0_26, var0_26.getBtn, function()
		arg0_26:emit(IslandMediator.GET_SHIP_ORDER_AWARD, var0_26.slot.id)
	end, SFX_PANEL)
	onButton(arg0_26, var0_26.lockTr, function()
		arg0_26:emit(IslandMediator.UNLOKC_SHIP_ORDER, var0_26.slot.id)
	end, SFX_PANEL)
	onButton(arg0_26, var0_26.loadingRequest, function()
		arg0_26:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.SHIP_ORDER, var0_26.slot.id)
	end, SFX_PANEL)
	onButton(arg0_26, var0_26.refreshBtn, function()
		if not arg1_26:CanRefresh() then
			arg0_26:ShowMsgBox({
				hideNo = true,
				content = i18n("island_shiporder_refresh_tip1")
			})
		else
			arg0_26:ShowMsgBox({
				content = i18n("island_shiporder_refresh_tip2"),
				onYes = function()
					arg0_26:emit(IslandMediator.REFRESH_SHIP_ORDER, var0_26.slot.id)
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_26, var0_26.reloadingTr, function()
		arg0_26:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.SHIP_ORDER_RELOAD, var0_26.slot.id)
	end, SFX_PANEL)
	onNextTick(function()
		arg0_26:RegisterCardEvent(var0_26)
	end)

	arg0_26.cards[arg2_26] = var0_26
end

function var0_0.CheckSelected(arg0_34, arg1_34)
	if arg0_34.loadUpItem == arg1_34 then
		arg0_34:ClearSelected()

		return false
	end

	return true
end

function var0_0.RegisterCardEvent(arg0_35, arg1_35)
	arg1_35.uiRequestList:each(function(arg0_36, arg1_36)
		onButton(arg0_35, arg1_36, function()
			if not arg1_35.slot:IsWaiting() then
				return
			end

			if arg1_35.slot:GetOrder():ItemIsSubmited(arg0_36 + 1) then
				return
			end

			if not arg0_35:CheckSelected(arg1_36) then
				return
			end

			arg0_35:ClearSelected()
			setActive(arg1_36:Find("loaded_1"), true)
			arg0_35:LoadUpItem(arg1_35, arg0_36 + 1, arg1_36)
		end, SFX_PANEL)
	end)
end

function var0_0.ClearSelected(arg0_38)
	if arg0_38.loadUpItem then
		setActive(arg0_38.loadUpItem:Find("loaded_1"), false)
	end

	arg0_38.loadUpItem = nil

	if arg0_38.loadUpPage and arg0_38.loadUpPage:GetLoaded() and arg0_38.loadUpPage:isShowing() then
		arg0_38.loadUpPage:Hide()
	end
end

function var0_0.LoadUpItem(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = arg0_39._tf:InverseTransformPoint(arg3_39:Find("loaded_1").position)

	arg0_39.loadUpPage:ExecuteAction("Show", Vector3(var0_39.x, var0_39.y, 0), arg1_39.slot, arg2_39)

	arg0_39.loadUpItem = arg3_39
end

function var0_0.OnHide(arg0_40)
	arg0_40:ClearSelected()

	if arg0_40.loadUpPage then
		arg0_40.loadUpPage:Destroy()
		arg0_40.loadUpPage:Reset()
	end
end

function var0_0.OnDestroy(arg0_41)
	for iter0_41, iter1_41 in pairs(arg0_41.cards) do
		iter1_41:Dispose()
	end

	arg0_41.cards = {}

	if arg0_41.loadUpPage then
		arg0_41.loadUpPage:Destroy()

		arg0_41.loadUpPage = nil
	end
end

return var0_0
