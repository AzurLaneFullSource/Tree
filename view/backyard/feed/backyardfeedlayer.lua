local var0 = class("BackyardFeedLayer", import("...base.BaseUI"))
local var1 = {
	50001,
	50002,
	50003,
	50004,
	50005,
	50006
}

function var0.getUIName(arg0)
	return "BackyardFeedUI"
end

function var0.SetIsRemind(arg0, arg1)
	arg0.remindEndTime = arg1
end

function var0.OnUsageItem(arg0, arg1)
	local var0 = table.indexof(var1, arg1)

	if not var0 or var0 <= 0 then
		return
	end

	local var1 = arg0.cards[var0]
	local var2 = getProxy(BagProxy):getItemCountById(arg1)

	var1:UpdateCnt(var2)
end

function var0.OnDormUpdated(arg0)
	arg0:UpdateDorm()
end

function var0.OnShopDone(arg0)
	arg0:UpdateCards()
	arg0:UpdateDorm()
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.chatTxt = arg0:findTF("chat/Text"):GetComponent(typeof(Text))
	arg0.chatTxt1 = arg0:findTF("chat/Text1"):GetComponent(typeof(Text))
	arg0.chatTime = arg0:findTF("chat/Text/time"):GetComponent(typeof(Text))
	arg0.chatTxt2 = arg0:findTF("chat/Text2"):GetComponent(typeof(Text))
	arg0.capacityBar = arg0:findTF("frame/progress"):GetComponent(typeof(Slider))
	arg0.capacityBarEffect = arg0:findTF("frame/progress_effect"):GetComponent(typeof(Slider))
	arg0.capacityTxt = arg0:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0.extendBtn = arg0:findTF("frame/extend_btn")
	arg0.additionTxt = arg0:findTF("frame/addition"):GetComponent(typeof(Text))
	arg0.paint = arg0:findTF("lenggui")
	arg0.cardTpl = arg0:findTF("frame/foodtpl")
	arg0.purchasePage = BackyardFeedPurchasePage.New(arg0._tf, arg0.event)
	arg0.extendPage = BackyardFeedExtendPage.New(arg0._tf, arg0.event)
	arg0.closeBtn = arg0:findTF("close")
	Input.multiTouchEnabled = false

	setText(arg0:findTF("frame/extend_btn/Text"), i18n("enter_extend_food_label"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.extendBtn, function()
		local var0 = getProxy(DormProxy):getRawData()
		local var1 = ShoppingStreet.getRiseShopId(ShopArgs.BackyardFoodExtend, var0.food_extend_count)

		if not var1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buy_max_count"))

			return
		end

		arg0.extendPage:ExecuteAction("Show", var1, var0:GetCapcity())
	end, SFX_PANEL)
	GetOrAddComponent(arg0.paint, "SpineAnimUI"):SetAction("animation", 0)
	arg0:UpdateDorm()
	arg0:InitFoods()
end

function var0.UpdateDorm(arg0)
	local var0 = getProxy(DormProxy):getRawData()

	arg0:InitCharChat(var0)

	if not arg0.playing then
		arg0:InitCapcity(var0)
	end
end

function var0.InitCharChat(arg0, arg1)
	arg0:RemoveTimer()
	arg0:ClearTxts()

	arg0.chatTxt2.text = ""

	if arg1:GetStateShipCnt(Ship.STATE_TRAIN) <= 0 then
		arg0.chatTxt2.text = i18n("backyard_backyardGranaryLayer_noShip")
	elseif arg1.food <= 0 then
		arg0.chatTxt2.text = i18n("backyard_backyardGranaryLayer_word")
	else
		arg0:AddChatTimer(arg1)
	end
end

function var0.ClearTxts(arg0)
	arg0.chatTxt.text = ""
	arg0.chatTxt1.text = ""
	arg0.chatTime.text = ""
end

function var0.AddChatTimer(arg0, arg1)
	local var0 = arg1:getFoodLeftTime()

	arg0.chatTxt.text = i18n("backyard_backyardGranaryLayer_foodTimeNotice_top")
	arg0.chatTxt1.text = i18n("backyard_backyardGranaryLayer_foodTimeNotice_bottom")

	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= 0 then
			arg0:RemoveTimer()

			arg0.chatTxt2.text = i18n("backyard_backyardGranaryLayer_word")

			arg0:ClearTxts()
		else
			arg0.chatTime.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.InitCapcity(arg0, arg1)
	local var0 = arg1:GetCapcity()

	arg0:UpdateCapacity(arg1.food, var0)
end

function var0.UpdateCapacity(arg0, arg1, arg2)
	local var0 = arg1 / arg2

	arg0.capacityBar.value = var0
	arg0.capacityBarEffect.value = var0

	arg0:UpdateCapacityTxt(arg1, arg2)
end

function var0.UpdateCapacityTxt(arg0, arg1, arg2)
	arg0.capacityTxt.text = "<color=#eb9e30>" .. arg1 .. "</color><color=#606064>/" .. arg2 .. "</color>"
end

function var0.UpdateCapacityWithAnim(arg0, arg1, arg2)
	if LeanTween.isTweening(arg0.capacityBarEffect.gameObject) then
		LeanTween.cancel(arg0.capacityBarEffect.gameObject)
	end

	if LeanTween.isTweening(arg0.capacityBar.gameObject) then
		LeanTween.cancel(arg0.capacityBar.gameObject)
	end

	arg0.playing = true

	local var0 = arg0.capacityBarEffect.value
	local var1 = arg1 / arg2

	arg0:UpdateCapacityTxt(arg1, arg2)
	LeanTween.value(arg0.capacityBarEffect.gameObject, var0, var1, 0.396):setOnUpdate(System.Action_float(function(arg0)
		arg0.capacityBarEffect.value = arg0
	end)):setEase(LeanTweenType.easeOutQuint)
	LeanTween.value(arg0.capacityBar.gameObject, var0, var1, 0.396):setEase(LeanTweenType.easeInOutQuart):setOnUpdate(System.Action_float(function(arg0)
		arg0.capacityBar.value = arg0
	end)):setOnComplete(System.Action(function()
		arg0:UpdateDorm()

		arg0.playing = false
	end)):setDelay(0.069)
end

local function var2(arg0, arg1)
	onButton(arg0, arg1.mask, function()
		arg0.purchasePage:ExecuteAction("Show", arg1.foodId)
	end, SFX_PANEL)
	onButton(arg0, arg1.addTF, function()
		arg0.purchasePage:ExecuteAction("Show", arg1.foodId)
	end, SFX_PANEL)
	pressPersistTrigger(arg1.icon, 0.5, function(arg0)
		arg0:SimulateAddFood(arg1.foodId, arg0)
	end, function()
		arg0:TriggerAddFood(arg1.foodId, arg0.simulateUsageCnt)

		arg0.simulateFood = nil
		arg0.simulateCapacity = nil
		arg0.simulateAddition = nil
		arg0.simulateItemCnt = nil
		arg0.simulateUsageCnt = nil
		arg0.isSimulation = nil
	end, true, true, 0.15, SFX_PANEL)
end

function var0.InitFoods(arg0)
	arg0.cards = {}

	local var0 = FoodCard.New(arg0.cardTpl)

	table.insert(arg0.cards, var0)
	var2(arg0, var0)

	local var1 = {}

	for iter0 = 1, #var1 - 1 do
		table.insert(var1, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = FoodCard.New(cloneTplTo(arg0.cardTpl, arg0.cardTpl.parent))

			var0:UpdatePositin(iter0)
			var2(arg0, var0)
			table.insert(arg0.cards, var0)
			onNextTick(arg0)
		end)
	end

	seriesAsync(var1, function()
		if arg0.exited then
			return
		end

		arg0:UpdateCards()
	end)
end

function var0.UpdateCards(arg0)
	for iter0 = 1, #var1 do
		local var0 = var1[iter0]
		local var1 = arg0.cards[iter0]
		local var2 = getProxy(BagProxy):getItemCountById(var0)

		var1:Update(var0, var2)
	end
end

function var0.SimulateAddFood(arg0, arg1, arg2)
	if not arg0.isSimulation then
		local var0 = getProxy(DormProxy):getRawData()

		arg0.simulateFood = var0.food
		arg0.simulateCapacity = var0:GetCapcity()
		arg0.simulateAddition = Item.getConfigData(arg1).usage_arg[1]
		arg0.simulateItemCnt = getProxy(BagProxy):getItemCountById(arg1)
		arg0.simulateUsageCnt = 0
		arg0.isSimulation = true
	end

	if arg0.simulateFood >= arg0.simulateCapacity then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_full"))
		arg2()

		return
	elseif arg0.simulateItemCnt == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_foodCountLimit"))
		arg2()

		return
	elseif arg0.simulateFood + arg0.simulateAddition > arg0.simulateCapacity and pg.TimeMgr.GetInstance():GetServerTime() > arg0.remindEndTime then
		arg0:ShowCapcityTip(arg1, arg0.simulateFood, arg0.simulateCapacity, arg0.simulateAddition)
		arg2()

		return
	end

	arg0.simulateItemCnt = arg0.simulateItemCnt - 1
	arg0.simulateUsageCnt = arg0.simulateUsageCnt + 1
	arg0.simulateFood = arg0.simulateFood + arg0.simulateAddition

	arg0:UpdateCapacityWithAnim(arg0.simulateFood, arg0.simulateCapacity)

	local var1 = table.indexof(var1, arg1)

	arg0.cards[var1]:UpdateCnt(arg0.simulateItemCnt)
	arg0:DoAddFoodAnimation(arg0.simulateAddition)
end

function var0.DoAddFoodAnimation(arg0, arg1)
	arg0.additionTxt.text = "+" .. arg1

	if LeanTween.isTweening(go(arg0.additionTxt)) then
		LeanTween.cancel(go(arg0.additionTxt))
	end

	LeanTween.moveLocalY(go(arg0.additionTxt), 220, 0.5):setFrom(160):setOnComplete(System.Action(function()
		arg0.additionTxt.text = ""
	end))
end

function var0.ShowCapcityTip(arg0, arg1, arg2, arg3, arg4)
	local var0 = pg.MsgboxMgr.GetInstance()
	local var1 = Item.getConfigData(arg1).name

	var0:ShowMsgBox({
		showStopRemind = true,
		type = MSGBOX_TYPE_SINGLE_ITEM,
		content = i18n("backyard_food_remind", var1),
		name = i18n("backyard_food_count", arg2 .. "/" .. arg3),
		drop = {
			type = DROP_TYPE_ITEM,
			id = arg1,
			count = i18n("common_food") .. ":" .. arg4
		},
		onYes = function()
			arg0:emit(BackyardFeedMediator.USE_FOOD, arg1, 1, var0.stopRemindToggle.isOn)
		end
	})
end

function var0.TriggerAddFood(arg0, arg1, arg2)
	if not arg2 or arg2 <= 0 then
		return
	end

	arg0:emit(BackyardFeedMediator.USE_FOOD, arg1, arg2)
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.willExit(arg0)
	if LeanTween.isTweening(arg0.capacityBarEffect.gameObject) then
		LeanTween.cancel(arg0.capacityBarEffect.gameObject)
	end

	if LeanTween.isTweening(arg0.capacityBar.gameObject) then
		LeanTween.cancel(arg0.capacityBar.gameObject)
	end

	arg0:RemoveTimer()

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil

	if LeanTween.isTweening(go(arg0.additionTxt)) then
		LeanTween.cancel(go(arg0.additionTxt))
	end

	if arg0.purchasePage then
		arg0.purchasePage:Destroy()

		arg0.purchasePage = nil
	end

	if arg0.extendPage then
		arg0.extendPage:Destroy()

		arg0.extendPage = nil
	end

	Input.multiTouchEnabled = true
end

return var0
