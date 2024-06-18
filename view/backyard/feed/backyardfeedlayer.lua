local var0_0 = class("BackyardFeedLayer", import("...base.BaseUI"))
local var1_0 = {
	50001,
	50002,
	50003,
	50004,
	50005,
	50006
}

function var0_0.getUIName(arg0_1)
	return "BackyardFeedUI"
end

function var0_0.SetIsRemind(arg0_2, arg1_2)
	arg0_2.remindEndTime = arg1_2
end

function var0_0.OnUsageItem(arg0_3, arg1_3)
	local var0_3 = table.indexof(var1_0, arg1_3)

	if not var0_3 or var0_3 <= 0 then
		return
	end

	local var1_3 = arg0_3.cards[var0_3]
	local var2_3 = getProxy(BagProxy):getItemCountById(arg1_3)

	var1_3:UpdateCnt(var2_3)
end

function var0_0.OnDormUpdated(arg0_4)
	arg0_4:UpdateDorm()
end

function var0_0.OnShopDone(arg0_5)
	arg0_5:UpdateCards()
	arg0_5:UpdateDorm()
end

function var0_0.init(arg0_6)
	arg0_6.frame = arg0_6:findTF("frame")
	arg0_6.chatTxt = arg0_6:findTF("chat/Text"):GetComponent(typeof(Text))
	arg0_6.chatTxt1 = arg0_6:findTF("chat/Text1"):GetComponent(typeof(Text))
	arg0_6.chatTime = arg0_6:findTF("chat/Text/time"):GetComponent(typeof(Text))
	arg0_6.chatTxt2 = arg0_6:findTF("chat/Text2"):GetComponent(typeof(Text))
	arg0_6.capacityBar = arg0_6:findTF("frame/progress"):GetComponent(typeof(Slider))
	arg0_6.capacityBarEffect = arg0_6:findTF("frame/progress_effect"):GetComponent(typeof(Slider))
	arg0_6.capacityTxt = arg0_6:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_6.extendBtn = arg0_6:findTF("frame/extend_btn")
	arg0_6.additionTxt = arg0_6:findTF("frame/addition"):GetComponent(typeof(Text))
	arg0_6.paint = arg0_6:findTF("lenggui")
	arg0_6.cardTpl = arg0_6:findTF("frame/foodtpl")
	arg0_6.purchasePage = BackyardFeedPurchasePage.New(arg0_6._tf, arg0_6.event)
	arg0_6.extendPage = BackyardFeedExtendPage.New(arg0_6._tf, arg0_6.event)
	arg0_6.closeBtn = arg0_6:findTF("close")
	Input.multiTouchEnabled = false

	setText(arg0_6:findTF("frame/extend_btn/Text"), i18n("enter_extend_food_label"))
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.closeBtn, function()
		arg0_7:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.extendBtn, function()
		local var0_9 = getProxy(DormProxy):getRawData()
		local var1_9 = ShoppingStreet.getRiseShopId(ShopArgs.BackyardFoodExtend, var0_9.food_extend_count)

		if not var1_9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buy_max_count"))

			return
		end

		arg0_7.extendPage:ExecuteAction("Show", var1_9, var0_9:GetCapcity())
	end, SFX_PANEL)
	GetOrAddComponent(arg0_7.paint, "SpineAnimUI"):SetAction("animation", 0)
	arg0_7:UpdateDorm()
	arg0_7:InitFoods()
end

function var0_0.UpdateDorm(arg0_10)
	local var0_10 = getProxy(DormProxy):getRawData()

	arg0_10:InitCharChat(var0_10)

	if not arg0_10.playing then
		arg0_10:InitCapcity(var0_10)
	end
end

function var0_0.InitCharChat(arg0_11, arg1_11)
	arg0_11:RemoveTimer()
	arg0_11:ClearTxts()

	arg0_11.chatTxt2.text = ""

	if arg1_11:GetStateShipCnt(Ship.STATE_TRAIN) <= 0 then
		arg0_11.chatTxt2.text = i18n("backyard_backyardGranaryLayer_noShip")
	elseif arg1_11.food <= 0 then
		arg0_11.chatTxt2.text = i18n("backyard_backyardGranaryLayer_word")
	else
		arg0_11:AddChatTimer(arg1_11)
	end
end

function var0_0.ClearTxts(arg0_12)
	arg0_12.chatTxt.text = ""
	arg0_12.chatTxt1.text = ""
	arg0_12.chatTime.text = ""
end

function var0_0.AddChatTimer(arg0_13, arg1_13)
	local var0_13 = arg1_13:getFoodLeftTime()

	arg0_13.chatTxt.text = i18n("backyard_backyardGranaryLayer_foodTimeNotice_top")
	arg0_13.chatTxt1.text = i18n("backyard_backyardGranaryLayer_foodTimeNotice_bottom")

	arg0_13:RemoveTimer()

	arg0_13.timer = Timer.New(function()
		local var0_14 = var0_13 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_14 <= 0 then
			arg0_13:RemoveTimer()

			arg0_13.chatTxt2.text = i18n("backyard_backyardGranaryLayer_word")

			arg0_13:ClearTxts()
		else
			arg0_13.chatTime.text = pg.TimeMgr.GetInstance():DescCDTime(var0_14)
		end
	end, 1, -1)

	arg0_13.timer:Start()
	arg0_13.timer.func()
end

function var0_0.InitCapcity(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetCapcity()

	arg0_15:UpdateCapacity(arg1_15.food, var0_15)
end

function var0_0.UpdateCapacity(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16 / arg2_16

	arg0_16.capacityBar.value = var0_16
	arg0_16.capacityBarEffect.value = var0_16

	arg0_16:UpdateCapacityTxt(arg1_16, arg2_16)
end

function var0_0.UpdateCapacityTxt(arg0_17, arg1_17, arg2_17)
	arg0_17.capacityTxt.text = "<color=#eb9e30>" .. arg1_17 .. "</color><color=#606064>/" .. arg2_17 .. "</color>"
end

function var0_0.UpdateCapacityWithAnim(arg0_18, arg1_18, arg2_18)
	if LeanTween.isTweening(arg0_18.capacityBarEffect.gameObject) then
		LeanTween.cancel(arg0_18.capacityBarEffect.gameObject)
	end

	if LeanTween.isTweening(arg0_18.capacityBar.gameObject) then
		LeanTween.cancel(arg0_18.capacityBar.gameObject)
	end

	arg0_18.playing = true

	local var0_18 = arg0_18.capacityBarEffect.value
	local var1_18 = arg1_18 / arg2_18

	arg0_18:UpdateCapacityTxt(arg1_18, arg2_18)
	LeanTween.value(arg0_18.capacityBarEffect.gameObject, var0_18, var1_18, 0.396):setOnUpdate(System.Action_float(function(arg0_19)
		arg0_18.capacityBarEffect.value = arg0_19
	end)):setEase(LeanTweenType.easeOutQuint)
	LeanTween.value(arg0_18.capacityBar.gameObject, var0_18, var1_18, 0.396):setEase(LeanTweenType.easeInOutQuart):setOnUpdate(System.Action_float(function(arg0_20)
		arg0_18.capacityBar.value = arg0_20
	end)):setOnComplete(System.Action(function()
		arg0_18:UpdateDorm()

		arg0_18.playing = false
	end)):setDelay(0.069)
end

local function var2_0(arg0_22, arg1_22)
	onButton(arg0_22, arg1_22.mask, function()
		arg0_22.purchasePage:ExecuteAction("Show", arg1_22.foodId)
	end, SFX_PANEL)
	onButton(arg0_22, arg1_22.addTF, function()
		arg0_22.purchasePage:ExecuteAction("Show", arg1_22.foodId)
	end, SFX_PANEL)
	pressPersistTrigger(arg1_22.icon, 0.5, function(arg0_25)
		arg0_22:SimulateAddFood(arg1_22.foodId, arg0_25)
	end, function()
		arg0_22:TriggerAddFood(arg1_22.foodId, arg0_22.simulateUsageCnt)

		arg0_22.simulateFood = nil
		arg0_22.simulateCapacity = nil
		arg0_22.simulateAddition = nil
		arg0_22.simulateItemCnt = nil
		arg0_22.simulateUsageCnt = nil
		arg0_22.isSimulation = nil
	end, true, true, 0.15, SFX_PANEL)
end

function var0_0.InitFoods(arg0_27)
	arg0_27.cards = {}

	local var0_27 = FoodCard.New(arg0_27.cardTpl)

	table.insert(arg0_27.cards, var0_27)
	var2_0(arg0_27, var0_27)

	local var1_27 = {}

	for iter0_27 = 1, #var1_0 - 1 do
		table.insert(var1_27, function(arg0_28)
			if arg0_27.exited then
				return
			end

			local var0_28 = FoodCard.New(cloneTplTo(arg0_27.cardTpl, arg0_27.cardTpl.parent))

			var0_28:UpdatePositin(iter0_27)
			var2_0(arg0_27, var0_28)
			table.insert(arg0_27.cards, var0_28)
			onNextTick(arg0_28)
		end)
	end

	seriesAsync(var1_27, function()
		if arg0_27.exited then
			return
		end

		arg0_27:UpdateCards()
	end)
end

function var0_0.UpdateCards(arg0_30)
	for iter0_30 = 1, #var1_0 do
		local var0_30 = var1_0[iter0_30]
		local var1_30 = arg0_30.cards[iter0_30]
		local var2_30 = getProxy(BagProxy):getItemCountById(var0_30)

		var1_30:Update(var0_30, var2_30)
	end
end

function var0_0.SimulateAddFood(arg0_31, arg1_31, arg2_31)
	if not arg0_31.isSimulation then
		local var0_31 = getProxy(DormProxy):getRawData()

		arg0_31.simulateFood = var0_31.food
		arg0_31.simulateCapacity = var0_31:GetCapcity()
		arg0_31.simulateAddition = Item.getConfigData(arg1_31).usage_arg[1]
		arg0_31.simulateItemCnt = getProxy(BagProxy):getItemCountById(arg1_31)
		arg0_31.simulateUsageCnt = 0
		arg0_31.isSimulation = true
	end

	if arg0_31.simulateFood >= arg0_31.simulateCapacity then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_full"))
		arg2_31()

		return
	elseif arg0_31.simulateItemCnt == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_foodCountLimit"))
		arg2_31()

		return
	elseif arg0_31.simulateFood + arg0_31.simulateAddition > arg0_31.simulateCapacity and pg.TimeMgr.GetInstance():GetServerTime() > arg0_31.remindEndTime then
		arg0_31:ShowCapcityTip(arg1_31, arg0_31.simulateFood, arg0_31.simulateCapacity, arg0_31.simulateAddition)
		arg2_31()

		return
	end

	arg0_31.simulateItemCnt = arg0_31.simulateItemCnt - 1
	arg0_31.simulateUsageCnt = arg0_31.simulateUsageCnt + 1
	arg0_31.simulateFood = arg0_31.simulateFood + arg0_31.simulateAddition

	arg0_31:UpdateCapacityWithAnim(arg0_31.simulateFood, arg0_31.simulateCapacity)

	local var1_31 = table.indexof(var1_0, arg1_31)

	arg0_31.cards[var1_31]:UpdateCnt(arg0_31.simulateItemCnt)
	arg0_31:DoAddFoodAnimation(arg0_31.simulateAddition)
end

function var0_0.DoAddFoodAnimation(arg0_32, arg1_32)
	arg0_32.additionTxt.text = "+" .. arg1_32

	if LeanTween.isTweening(go(arg0_32.additionTxt)) then
		LeanTween.cancel(go(arg0_32.additionTxt))
	end

	LeanTween.moveLocalY(go(arg0_32.additionTxt), 220, 0.5):setFrom(160):setOnComplete(System.Action(function()
		arg0_32.additionTxt.text = ""
	end))
end

function var0_0.ShowCapcityTip(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = pg.MsgboxMgr.GetInstance()
	local var1_34 = Item.getConfigData(arg1_34).name

	var0_34:ShowMsgBox({
		showStopRemind = true,
		type = MSGBOX_TYPE_SINGLE_ITEM,
		content = i18n("backyard_food_remind", var1_34),
		name = i18n("backyard_food_count", arg2_34 .. "/" .. arg3_34),
		drop = {
			type = DROP_TYPE_ITEM,
			id = arg1_34,
			count = i18n("common_food") .. ":" .. arg4_34
		},
		onYes = function()
			arg0_34:emit(BackyardFeedMediator.USE_FOOD, arg1_34, 1, var0_34.stopRemindToggle.isOn)
		end
	})
end

function var0_0.TriggerAddFood(arg0_36, arg1_36, arg2_36)
	if not arg2_36 or arg2_36 <= 0 then
		return
	end

	arg0_36:emit(BackyardFeedMediator.USE_FOOD, arg1_36, arg2_36)
end

function var0_0.RemoveTimer(arg0_37)
	if arg0_37.timer then
		arg0_37.timer:Stop()

		arg0_37.timer = nil
	end
end

function var0_0.willExit(arg0_38)
	if LeanTween.isTweening(arg0_38.capacityBarEffect.gameObject) then
		LeanTween.cancel(arg0_38.capacityBarEffect.gameObject)
	end

	if LeanTween.isTweening(arg0_38.capacityBar.gameObject) then
		LeanTween.cancel(arg0_38.capacityBar.gameObject)
	end

	arg0_38:RemoveTimer()

	for iter0_38, iter1_38 in pairs(arg0_38.cards) do
		iter1_38:Dispose()
	end

	arg0_38.cards = nil

	if LeanTween.isTweening(go(arg0_38.additionTxt)) then
		LeanTween.cancel(go(arg0_38.additionTxt))
	end

	if arg0_38.purchasePage then
		arg0_38.purchasePage:Destroy()

		arg0_38.purchasePage = nil
	end

	if arg0_38.extendPage then
		arg0_38.extendPage:Destroy()

		arg0_38.extendPage = nil
	end

	Input.multiTouchEnabled = true
end

return var0_0
