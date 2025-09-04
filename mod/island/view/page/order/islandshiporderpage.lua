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
	arg0_2.animator = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.uilistAniamtion = arg0_2._tf:Find("frame/list"):GetComponent(typeof(Animation))

	setText(arg0_2:findTF("frame/switch/on/Text"), i18n("island_order_ship_page_req"))
	setText(arg0_2:findTF("frame/switch/off/Text"), i18n("island_order_ship_page_award"))
	setText(arg0_2:findTF("list_1/onekey/btn/Text"), i18n("island_order_ship_page_onekey_loadup"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:PlayExitAnimation(function()
			arg0_3:Hide()
		end)
	end, SFX_PANEL)
	arg0_3:bind(var0_0.EVENT_CLOSE_LOAD_UP, function()
		arg0_3:ClearSelected()
	end)
	triggerToggle(arg0_3.switchBtn, false)
	onToggle(arg0_3, arg0_3.switchBtn, function(arg0_7)
		arg0_3:SwitchMode(arg0_7)
	end, SFX_PANEL)
end

function var0_0.PlayExitAnimation(arg0_8, arg1_8)
	arg0_8.canvasGroup.blocksRaycasts = false

	arg0_8.aniDft:SetEndEvent(function()
		arg0_8.canvasGroup.blocksRaycasts = true

		if arg1_8 then
			arg1_8()
		end
	end)
	arg0_8.animator:Play("anim_island_shiporder_out")
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_10.OnOrderUpdate)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLAND_SHIP_ORDER_OP_DONE, arg0_11.OnOrderUpdate)
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

function var0_0.OnShow(arg0_15)
	arg0_15.mode = var0_0.MODE_REQUEST_VIEW
	arg0_15.canvasGroup.blocksRaycasts = true

	arg0_15:FlushSlots()
	arg0_15:UnlockFirstSlot()
end

function var0_0.UnlockFirstSlot(arg0_16)
	local var0_16 = arg0_16.displays[1]

	if var0_16 and var0_16:IsLock() and var0_16:GetUnlockGold().count <= 0 then
		for iter0_16, iter1_16 in pairs(arg0_16.cards) do
			if iter1_16.slot.id == var0_16.id then
				target = iter1_16

				break
			end
		end

		if target then
			triggerButton(target.lockTr)
		end
	end
end

function var0_0.SwitchMode(arg0_17, arg1_17)
	arg0_17.mode = arg1_17 and var0_0.MODE_AWARD_VIEW or var0_0.MODE_REQUEST_VIEW

	for iter0_17, iter1_17 in pairs(arg0_17.cards) do
		iter1_17:SwitchMode(iter1_17.slot, arg0_17.mode)
	end

	arg0_17:ClearSelected()
	arg0_17.uilistAniamtion:Stop()
	arg0_17.uilistAniamtion:Play("anim_island_shiporder_list")
end

function var0_0.GetDisplays(arg0_18, ...)
	local var0_18 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipSlotList()
	local var1_18 = {}

	for iter0_18, iter1_18 in pairs(var0_18) do
		table.insert(var1_18, iter1_18)
	end

	return var1_18
end

function var0_0.FlushSlots(arg0_19)
	arg0_19.displays = arg0_19:GetDisplays()

	table.sort(arg0_19.displays, function(arg0_20, arg1_20)
		return arg0_20:GetUnlockLevel() < arg1_20:GetUnlockLevel()
	end)
	arg0_19.uiSlots:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			arg0_19:UpdateSlot(arg0_19.displays[arg1_21 + 1], arg2_21)
		end
	end)
	arg0_19.uiSlots:align(#arg0_19.displays)
	arg0_19:UpdateOnekeyBtns()
end

function var0_0.UpdateOnekeyBtns(arg0_22)
	arg0_22.onekeySlots:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = arg2_23:Find("btn")
			local var1_23 = arg0_22.displays[arg1_23 + 1]

			setActive(var0_23, var1_23:IsWaiting())

			local var2_23 = var1_23:IsWaiting() and not var1_23:GetOrder():AnyCanLoadUp()

			setGray(var0_23, var2_23, true)

			if not var2_23 then
				onButton(arg0_22, var0_23, function()
					arg0_22:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME_ONEKEY, var1_23.id)
				end, SFX_PANEL)
			else
				removeOnButton(var0_23)
			end
		end
	end)
	arg0_22.onekeySlots:align(#arg0_22.displays)
end

function var0_0.UpdateSlot(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.cards[arg2_25] or IslandShipOrderCard.New(arg2_25)

	var0_25:Flush(arg1_25, arg0_25.mode)
	onButton(arg0_25, var0_25.getBtn, function()
		arg0_25:emit(IslandMediator.GET_SHIP_ORDER_AWARD, var0_25.slot.id)
	end, SFX_PANEL)
	onButton(arg0_25, var0_25.lockTr, function()
		arg0_25:emit(IslandMediator.UNLOKC_SHIP_ORDER, var0_25.slot.id)
	end, SFX_PANEL)
	onButton(arg0_25, var0_25.loadingRequest, function()
		return
	end, SFX_PANEL)
	onNextTick(function()
		arg0_25:RegisterCardEvent(var0_25)
	end)

	arg0_25.cards[arg2_25] = var0_25
end

function var0_0.CheckSelected(arg0_30, arg1_30)
	if arg0_30.loadUpItem == arg1_30 then
		arg0_30:ClearSelected()

		return false
	end

	return true
end

function var0_0.RegisterCardEvent(arg0_31, arg1_31)
	arg1_31.uiRequestList:each(function(arg0_32, arg1_32)
		onButton(arg0_31, arg1_32, function()
			if not arg1_31.slot:IsWaiting() then
				return
			end

			if arg1_31.slot:GetOrder():ItemIsSubmited(arg0_32 + 1) then
				return
			end

			if not arg0_31:CheckSelected(arg1_32) then
				return
			end

			arg0_31:ClearSelected()
			setActive(arg1_32:Find("loaded_1"), true)
			arg0_31:LoadUpItem(arg1_31, arg0_32 + 1, arg1_32)
		end, SFX_PANEL)
	end)
end

function var0_0.ClearSelected(arg0_34)
	if arg0_34.loadUpItem then
		setActive(arg0_34.loadUpItem:Find("loaded_1"), false)
	end

	arg0_34.loadUpItem = nil

	if arg0_34.loadUpPage and arg0_34.loadUpPage:GetLoaded() and arg0_34.loadUpPage:isShowing() then
		arg0_34.loadUpPage:Hide()
	end
end

function var0_0.LoadUpItem(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = arg0_35._tf:InverseTransformPoint(arg3_35:Find("loaded_1").position)

	arg0_35.loadUpPage:ExecuteAction("Show", Vector3(var0_35.x, var0_35.y, 0), arg1_35.slot, arg2_35)

	arg0_35.loadUpItem = arg3_35
end

function var0_0.OnHide(arg0_36)
	arg0_36:ClearSelected()

	if arg0_36.loadUpPage then
		arg0_36.loadUpPage:Destroy()
		arg0_36.loadUpPage:Reset()
	end
end

function var0_0.OnDestroy(arg0_37)
	for iter0_37, iter1_37 in pairs(arg0_37.cards) do
		iter1_37:Dispose()
	end

	arg0_37.cards = {}

	if arg0_37.loadUpPage then
		arg0_37.loadUpPage:Destroy()

		arg0_37.loadUpPage = nil
	end
end

return var0_0
