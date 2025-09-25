local var0_0 = class("IslandShipOrderPage", import("...base.IslandBasePage"))

var0_0.MODE_REQUEST_VIEW = 0
var0_0.MODE_AWARD_VIEW = 1
var0_0.EVENT_CLOSE_LOAD_UP = "IslandShipOrderPage:EVENT_CLOSE_LOAD_UP"

function var0_0.getUIName(arg0_1)
	return "IslandShipOrderUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.uiSlots = UIItemList.New(arg0_2:findTF("frame/list"), arg0_2:findTF("frame/list/tpl"))
	arg0_2.onekeySlots = UIItemList.New(arg0_2:findTF("list_1"), arg0_2:findTF("list_1/onekey"))
	arg0_2.switchBtn = arg0_2:findTF("frame/switch")
	arg0_2.cards = {}
	arg0_2.loadUpPage = IslandShipOrderLoadUpPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.uilistAniamtion = arg0_2._tf:Find("frame/list"):GetComponent(typeof(Animation))

	setText(arg0_2:findTF("frame/switch/on/Text"), i18n("island_order_ship_page_req"))
	setText(arg0_2:findTF("frame/switch/off/Text"), i18n("island_order_ship_page_award"))
	setText(arg0_2:findTF("list_1/onekey/btn/Text"), i18n("island_order_ship_page_onekey_loadup"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3:bind(var0_0.EVENT_CLOSE_LOAD_UP, function()
		arg0_3:ClearSelected()
	end)
	triggerToggle(arg0_3.switchBtn, false)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_6)
		arg0_3:SwitchMode(arg0_6)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_7.OnOrderUpdate)
	arg0_7:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_7.OnUseTicketDone)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_8.OnOrderUpdate)
	arg0_8:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_8.OnUseTicketDone)
end

function var0_0.OnOrderUpdate(arg0_9, arg1_9)
	local var0_9 = arg1_9.id
	local var1_9

	for iter0_9, iter1_9 in pairs(arg0_9.cards) do
		if iter1_9.slot.id == var0_9 then
			var1_9 = iter1_9

			break
		end
	end

	if not var1_9 then
		return
	end

	arg0_9:ClearSelected()

	arg0_9.canvasGroup.blocksRaycasts = false

	seriesAsync({
		function(arg0_10)
			var1_9:PlayAniamtion(arg1_9.op, arg1_9.isLoadUpAll, arg0_10)
		end
	}, function()
		arg0_9.canvasGroup.blocksRaycasts = true

		var1_9:Flush(var1_9.slot, arg0_9.mode)
		arg0_9:RegisterCardEvent(var1_9)

		for iter0_11, iter1_11 in pairs(arg0_9.cards) do
			iter1_11:UpdateRequest(iter1_11.slot)
		end

		arg0_9:UpdateOnekeyBtns()
	end)
end

function var0_0.OnUseTicketDone(arg0_12, arg1_12)
	if arg1_12.type == IslandUseTicketCommand.TYPES.SHIP_ORDER then
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

		var1_12:Flush(var1_12.slot, arg0_12.mode)
	end
end

function var0_0.OnShow(arg0_13)
	arg0_13.mode = var0_0.MODE_REQUEST_VIEW
	arg0_13.canvasGroup.blocksRaycasts = true

	arg0_13:FlushSlots()
	arg0_13:UnlockFirstSlot()
end

function var0_0.UnlockFirstSlot(arg0_14)
	local var0_14 = arg0_14.displays[1]

	if var0_14 and var0_14:IsLock() and var0_14:GetUnlockGold().count <= 0 then
		for iter0_14, iter1_14 in pairs(arg0_14.cards) do
			if iter1_14.slot.id == var0_14.id then
				target = iter1_14

				break
			end
		end

		if target then
			triggerButton(target.lockTr)
		end
	end
end

function var0_0.SwitchMode(arg0_15, arg1_15)
	arg0_15.mode = arg1_15 and var0_0.MODE_AWARD_VIEW or var0_0.MODE_REQUEST_VIEW

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		iter1_15:SwitchMode(iter1_15.slot, arg0_15.mode)
	end

	arg0_15:ClearSelected()
	arg0_15.uilistAniamtion:Stop()
	arg0_15.uilistAniamtion:Play("anim_island_shiporder_list")
end

function var0_0.GetDisplays(arg0_16, ...)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipSlotList()
	local var1_16 = {}

	for iter0_16, iter1_16 in pairs(var0_16) do
		table.insert(var1_16, iter1_16)
	end

	return var1_16
end

function var0_0.FlushSlots(arg0_17)
	arg0_17.displays = arg0_17:GetDisplays()

	table.sort(arg0_17.displays, function(arg0_18, arg1_18)
		return arg0_18:GetUnlockLevel() < arg1_18:GetUnlockLevel()
	end)
	arg0_17.uiSlots:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			arg0_17:UpdateSlot(arg0_17.displays[arg1_19 + 1], arg2_19)
		end
	end)
	arg0_17.uiSlots:align(#arg0_17.displays)
	arg0_17:UpdateOnekeyBtns()
end

function var0_0.UpdateOnekeyBtns(arg0_20)
	arg0_20.onekeySlots:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = arg2_21:Find("btn")
			local var1_21 = arg0_20.displays[arg1_21 + 1]

			setActive(var0_21, var1_21:IsWaiting())

			local var2_21 = var1_21:IsWaiting() and not var1_21:GetOrder():AnyCanLoadUp()

			setGray(var0_21, var2_21, true)

			if not var2_21 then
				onButton(arg0_20, var0_21, function()
					arg0_20:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME_ONEKEY, var1_21.id)
				end, SFX_PANEL)
			else
				removeOnButton(var0_21)
			end
		end
	end)
	arg0_20.onekeySlots:align(#arg0_20.displays)
end

function var0_0.UpdateSlot(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.cards[arg2_23] or IslandShipOrderCard.New(arg2_23)

	var0_23:Flush(arg1_23, arg0_23.mode)
	onButton(arg0_23, var0_23.getBtn, function()
		arg0_23:emit(IslandMediator.GET_SHIP_ORDER_AWARD, var0_23.slot.id)
	end, SFX_PANEL)
	onButton(arg0_23, var0_23.lockTr, function()
		arg0_23:emit(IslandMediator.UNLOKC_SHIP_ORDER, var0_23.slot.id)
	end, SFX_PANEL)
	onButton(arg0_23, var0_23.loadingRequest, function()
		arg0_23:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.SHIP_ORDER, var0_23.slot.id)
	end, SFX_PANEL)
	onNextTick(function()
		arg0_23:RegisterCardEvent(var0_23)
	end)

	arg0_23.cards[arg2_23] = var0_23
end

function var0_0.CheckSelected(arg0_28, arg1_28)
	if arg0_28.loadUpItem == arg1_28 then
		arg0_28:ClearSelected()

		return false
	end

	return true
end

function var0_0.RegisterCardEvent(arg0_29, arg1_29)
	arg1_29.uiRequestList:each(function(arg0_30, arg1_30)
		onButton(arg0_29, arg1_30, function()
			if not arg1_29.slot:IsWaiting() then
				return
			end

			if arg1_29.slot:GetOrder():ItemIsSubmited(arg0_30 + 1) then
				return
			end

			if not arg0_29:CheckSelected(arg1_30) then
				return
			end

			arg0_29:ClearSelected()
			setActive(arg1_30:Find("loaded_1"), true)
			arg0_29:LoadUpItem(arg1_29, arg0_30 + 1, arg1_30)
		end, SFX_PANEL)
	end)
end

function var0_0.ClearSelected(arg0_32)
	if arg0_32.loadUpItem then
		setActive(arg0_32.loadUpItem:Find("loaded_1"), false)
	end

	arg0_32.loadUpItem = nil

	if arg0_32.loadUpPage and arg0_32.loadUpPage:GetLoaded() and arg0_32.loadUpPage:isShowing() then
		arg0_32.loadUpPage:Hide()
	end
end

function var0_0.LoadUpItem(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = arg0_33._tf:InverseTransformPoint(arg3_33:Find("loaded_1").position)

	arg0_33.loadUpPage:ExecuteAction("Show", Vector3(var0_33.x, var0_33.y, 0), arg1_33.slot, arg2_33)

	arg0_33.loadUpItem = arg3_33
end

function var0_0.OnHide(arg0_34)
	arg0_34:ClearSelected()

	if arg0_34.loadUpPage then
		arg0_34.loadUpPage:Destroy()
		arg0_34.loadUpPage:Reset()
	end
end

function var0_0.OnDestroy(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.cards) do
		iter1_35:Dispose()
	end

	arg0_35.cards = {}

	if arg0_35.loadUpPage then
		arg0_35.loadUpPage:Destroy()

		arg0_35.loadUpPage = nil
	end
end

return var0_0
