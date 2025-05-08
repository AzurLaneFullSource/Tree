local var0_0 = class("IslandShipOrderPage", import("...base.IslandBasePage"))

var0_0.MODE_REQUEST_VIEW = 0
var0_0.MODE_AWARD_VIEW = 1

function var0_0.getUIName(arg0_1)
	return "IslandShipOrderUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.uiSlots = UIItemList.New(arg0_2:findTF("frame/list"), arg0_2:findTF("frame/list/tpl"))
	arg0_2.switchBtn = arg0_2:findTF("frame/switch")
	arg0_2.cards = {}
	arg0_2.loadUpPage = IslandShipOrderLoadUpPage.New(arg0_2._tf, arg0_2.event)

	setText(arg0_2:findTF("frame/switch/on/Text"), i18n1("查看清单需求"))
	setText(arg0_2:findTF("frame/switch/off/Text"), i18n1("查看订单奖励"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	triggerToggle(arg0_3.switchBtn, false)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_5)
		arg0_3:SwitchMode(arg0_5)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_6.OnOrderUpdate)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_7.OnOrderUpdate)
end

function var0_0.OnOrderUpdate(arg0_8, arg1_8)
	local var0_8 = arg1_8.id
	local var1_8

	for iter0_8, iter1_8 in pairs(arg0_8.cards) do
		if iter1_8.slot.id == var0_8 then
			var1_8 = iter1_8

			break
		end
	end

	if not var1_8 then
		return
	end

	arg0_8:ClearSelected()
	seriesAsync({
		function(arg0_9)
			if not arg1_8.isLoadUpAll then
				arg0_9()

				return
			end

			var1_8:PlaySignAnim(arg0_9)
		end
	}, function()
		var1_8:Flush(var1_8.slot, arg0_8.mode)
	end)
end

function var0_0.OnShow(arg0_11)
	arg0_11.mode = var0_0.MODE_REQUEST_VIEW

	arg0_11:FlushSlots()
end

function var0_0.SwitchMode(arg0_12, arg1_12)
	arg0_12.mode = arg1_12 and var0_0.MODE_AWARD_VIEW or var0_0.MODE_REQUEST_VIEW

	for iter0_12, iter1_12 in pairs(arg0_12.cards) do
		iter1_12:SwitchMode(iter1_12.slot, arg0_12.mode)
	end

	arg0_12:ClearSelected()
end

function var0_0.FlushSlots(arg0_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipSlotList()
	local var1_13 = {}

	for iter0_13, iter1_13 in pairs(var0_13) do
		table.insert(var1_13, iter1_13)
	end

	table.sort(var1_13, function(arg0_14, arg1_14)
		return arg0_14:GetUnlockLevel() < arg1_14:GetUnlockLevel()
	end)
	arg0_13.uiSlots:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg0_13:UpdateSlot(var1_13[arg1_15 + 1], arg2_15)
		end
	end)
	arg0_13.uiSlots:align(#var1_13)
end

function var0_0.UpdateSlot(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.cards[arg2_16] or IslandShipOrderCard.New(arg2_16)

	var0_16:Flush(arg1_16, arg0_16.mode)
	onButton(arg0_16, var0_16.getBtn, function()
		arg0_16:emit(IslandMediator.GET_SHIP_ORDER_AWARD, var0_16.slot.id)
	end, SFX_PANEL)
	onButton(arg0_16, var0_16.lockTr, function()
		arg0_16:emit(IslandMediator.UNLOKC_SHIP_ORDER, var0_16.slot.id)
	end, SFX_PANEL)

	local function var1_16(arg0_19)
		if arg0_16.loadUpItem == arg0_19 then
			arg0_16:ClearSelected()

			return false
		end

		return true
	end

	local function var2_16()
		var0_16.uiRequestList:each(function(arg0_21, arg1_21)
			onButton(arg0_16, arg1_21, function()
				if not var0_16.slot:IsWaiting() then
					return
				end

				if var0_16.slot:GetOrder():ItemIsSubmited(arg0_21 + 1) then
					return
				end

				if not var1_16(arg1_21) then
					return
				end

				arg0_16:ClearSelected()
				setActive(arg1_21:Find("loaded_1"), true)
				arg0_16:LoadUpItem(var0_16, arg0_21 + 1, arg1_21)
			end, SFX_PANEL)
		end)
	end

	onNextTick(var2_16)

	arg0_16.cards[arg2_16] = var0_16
end

function var0_0.ClearSelected(arg0_23)
	if arg0_23.loadUpItem then
		setActive(arg0_23.loadUpItem:Find("loaded_1"), false)
	end

	arg0_23.loadUpItem = nil

	if arg0_23.loadUpPage and arg0_23.loadUpPage:GetLoaded() and arg0_23.loadUpPage:isShowing() then
		arg0_23.loadUpPage:Hide()
	end
end

function var0_0.LoadUpItem(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg0_24._tf:InverseTransformPoint(arg3_24:Find("loaded_1").position)

	arg0_24.loadUpPage:ExecuteAction("Show", Vector3(var0_24.x, var0_24.y - 60, 0), arg1_24.slot, arg2_24)

	arg0_24.loadUpItem = arg3_24
end

function var0_0.OnHide(arg0_25)
	arg0_25:ClearSelected()

	if arg0_25.loadUpPage then
		arg0_25.loadUpPage:Destroy()
		arg0_25.loadUpPage:Reset()
	end
end

function var0_0.OnDestroy(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.cards) do
		iter1_26:Dispose()
	end

	arg0_26.cards = {}

	if arg0_26.loadUpPage then
		arg0_26.loadUpPage:Destroy()

		arg0_26.loadUpPage = nil
	end
end

return var0_0
