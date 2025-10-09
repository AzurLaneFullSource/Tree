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
	onButton(arg0_3, arg0_3:findTF("frame/help"), function()
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
end

function var0_0.RemoveListeners(arg0_9)
	arg0_9:RemoveListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_9.OnOrderUpdate)
	arg0_9:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_9.OnUseTicketDone)
end

function var0_0.OnOrderUpdate(arg0_10, arg1_10)
	local var0_10 = arg1_10.id
	local var1_10

	for iter0_10, iter1_10 in pairs(arg0_10.cards) do
		if iter1_10.slot.id == var0_10 then
			var1_10 = iter1_10

			break
		end
	end

	if not var1_10 then
		return
	end

	arg0_10:ClearSelected()

	arg0_10.canvasGroup.blocksRaycasts = false

	seriesAsync({
		function(arg0_11)
			var1_10:PlayAniamtion(arg1_10.op, arg1_10.isLoadUpAll, arg0_11)
		end
	}, function()
		arg0_10.canvasGroup.blocksRaycasts = true

		var1_10:Flush(var1_10.slot, arg0_10.mode)
		arg0_10:RegisterCardEvent(var1_10)

		for iter0_12, iter1_12 in pairs(arg0_10.cards) do
			iter1_12:UpdateRequest(iter1_12.slot)
		end

		arg0_10:UpdateOnekeyBtns()
	end)
end

function var0_0.OnUseTicketDone(arg0_13, arg1_13)
	if arg1_13.type == IslandUseTicketCommand.TYPES.SHIP_ORDER then
		local var0_13 = arg1_13.id
		local var1_13

		for iter0_13, iter1_13 in pairs(arg0_13.cards) do
			if iter1_13.slot.id == var0_13 then
				var1_13 = iter1_13

				break
			end
		end

		if not var1_13 then
			return
		end

		var1_13:Flush(var1_13.slot, arg0_13.mode)
	end
end

function var0_0.OnShow(arg0_14)
	arg0_14.mode = var0_0.MODE_REQUEST_VIEW
	arg0_14.canvasGroup.blocksRaycasts = true

	arg0_14:FlushSlots()
	arg0_14:UnlockFirstSlot()
end

function var0_0.UnlockFirstSlot(arg0_15)
	local var0_15 = arg0_15.displays[1]

	if var0_15 and var0_15:IsLock() and var0_15:GetUnlockGold().count <= 0 then
		for iter0_15, iter1_15 in pairs(arg0_15.cards) do
			if iter1_15.slot.id == var0_15.id then
				target = iter1_15

				break
			end
		end

		if target then
			triggerButton(target.lockTr)
		end
	end
end

function var0_0.SwitchMode(arg0_16, arg1_16)
	arg0_16.mode = arg1_16 and var0_0.MODE_AWARD_VIEW or var0_0.MODE_REQUEST_VIEW

	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		iter1_16:SwitchMode(iter1_16.slot, arg0_16.mode)
	end

	arg0_16:ClearSelected()
	arg0_16.uilistAniamtion:Stop()
	arg0_16.uilistAniamtion:Play("anim_island_shiporder_list")
end

function var0_0.GetDisplays(arg0_17, ...)
	local var0_17 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipSlotList()
	local var1_17 = {}

	for iter0_17, iter1_17 in pairs(var0_17) do
		table.insert(var1_17, iter1_17)
	end

	return var1_17
end

function var0_0.FlushSlots(arg0_18)
	arg0_18.displays = arg0_18:GetDisplays()

	table.sort(arg0_18.displays, function(arg0_19, arg1_19)
		return arg0_19:GetUnlockLevel() < arg1_19:GetUnlockLevel()
	end)
	arg0_18.uiSlots:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			arg0_18:UpdateSlot(arg0_18.displays[arg1_20 + 1], arg2_20)
		end
	end)
	arg0_18.uiSlots:align(#arg0_18.displays)
	arg0_18:UpdateOnekeyBtns()
end

function var0_0.UpdateOnekeyBtns(arg0_21)
	arg0_21.onekeySlots:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg2_22:Find("btn")
			local var1_22 = arg0_21.displays[arg1_22 + 1]

			setActive(var0_22, var1_22:IsWaiting())

			local var2_22 = var1_22:IsWaiting() and not var1_22:GetOrder():AnyCanLoadUp()

			setGray(var0_22, var2_22, true)

			if not var2_22 then
				onButton(arg0_21, var0_22, function()
					arg0_21:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME_ONEKEY, var1_22.id)
				end, SFX_PANEL)
			else
				removeOnButton(var0_22)
			end
		end
	end)
	arg0_21.onekeySlots:align(#arg0_21.displays)
end

function var0_0.UpdateSlot(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.cards[arg2_24] or IslandShipOrderCard.New(arg2_24)

	var0_24:Flush(arg1_24, arg0_24.mode)
	onButton(arg0_24, var0_24.getBtn, function()
		arg0_24:emit(IslandMediator.GET_SHIP_ORDER_AWARD, var0_24.slot.id)
	end, SFX_PANEL)
	onButton(arg0_24, var0_24.lockTr, function()
		arg0_24:emit(IslandMediator.UNLOKC_SHIP_ORDER, var0_24.slot.id)
	end, SFX_PANEL)
	onButton(arg0_24, var0_24.loadingRequest, function()
		arg0_24:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.SHIP_ORDER, var0_24.slot.id)
	end, SFX_PANEL)
	onNextTick(function()
		arg0_24:RegisterCardEvent(var0_24)
	end)

	arg0_24.cards[arg2_24] = var0_24
end

function var0_0.CheckSelected(arg0_29, arg1_29)
	if arg0_29.loadUpItem == arg1_29 then
		arg0_29:ClearSelected()

		return false
	end

	return true
end

function var0_0.RegisterCardEvent(arg0_30, arg1_30)
	arg1_30.uiRequestList:each(function(arg0_31, arg1_31)
		onButton(arg0_30, arg1_31, function()
			if not arg1_30.slot:IsWaiting() then
				return
			end

			if arg1_30.slot:GetOrder():ItemIsSubmited(arg0_31 + 1) then
				return
			end

			if not arg0_30:CheckSelected(arg1_31) then
				return
			end

			arg0_30:ClearSelected()
			setActive(arg1_31:Find("loaded_1"), true)
			arg0_30:LoadUpItem(arg1_30, arg0_31 + 1, arg1_31)
		end, SFX_PANEL)
	end)
end

function var0_0.ClearSelected(arg0_33)
	if arg0_33.loadUpItem then
		setActive(arg0_33.loadUpItem:Find("loaded_1"), false)
	end

	arg0_33.loadUpItem = nil

	if arg0_33.loadUpPage and arg0_33.loadUpPage:GetLoaded() and arg0_33.loadUpPage:isShowing() then
		arg0_33.loadUpPage:Hide()
	end
end

function var0_0.LoadUpItem(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg0_34._tf:InverseTransformPoint(arg3_34:Find("loaded_1").position)

	arg0_34.loadUpPage:ExecuteAction("Show", Vector3(var0_34.x, var0_34.y, 0), arg1_34.slot, arg2_34)

	arg0_34.loadUpItem = arg3_34
end

function var0_0.OnHide(arg0_35)
	arg0_35:ClearSelected()

	if arg0_35.loadUpPage then
		arg0_35.loadUpPage:Destroy()
		arg0_35.loadUpPage:Reset()
	end
end

function var0_0.OnDestroy(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36.cards) do
		iter1_36:Dispose()
	end

	arg0_36.cards = {}

	if arg0_36.loadUpPage then
		arg0_36.loadUpPage:Destroy()

		arg0_36.loadUpPage = nil
	end
end

return var0_0
