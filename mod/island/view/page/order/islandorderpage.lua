local var0_0 = class("IslandOrderPage", import("...base.IslandBasePage"))

var0_0.ON_UPDADE = "IslandOrderPage:ON_UPDADE"

function var0_0.getUIName(arg0_1)
	return "IslandOrderUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("top/back")
	arg0_2.favorBtn = arg0_2:findTF("top/favor_bg")
	arg0_2.levelTxt = arg0_2:findTF("top/favor_bg/level"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("top/favor_bg/Text"):GetComponent(typeof(Text))
	arg0_2.charTr = arg0_2:findTF("bottom/char")
	arg0_2.chatTxt = arg0_2.charTr:Find("dialogue/Text"):GetComponent(typeof(Text))
	arg0_2.trendBtn = arg0_2:findTF("trend_btn")
	arg0_2.trendIco = arg0_2.trendBtn:Find("difficulty"):GetComponent(typeof(Image))
	arg0_2.trendTxt = arg0_2.trendBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.orderContainer = arg0_2:findTF("map")
	arg0_2.tendencyPage = IslandOrderTendencyPage.New(arg0_2, arg0_2._parentTf)
	arg0_2.upgradePage = IslandOrderUpgradePage.New(arg0_2._parentTf)
	arg0_2.countTxt = arg0_2:findTF("count_bg/Text"):GetComponent(typeof(Text))
	arg0_2.orderTplPool = OrderTplPool.New(arg0_2:findTF("root/orderTpl"), 3, 6)
	arg0_2.orderTpls = {}
	arg0_2.timers = {}
	arg0_2.disappearTimers = {}

	setActive(arg0_2.charTr, false)
	setText(arg0_2:findTF("top/title/Text"), i18n1("订单中心"))
end

function var0_0.OnHide(arg0_3)
	if arg0_3.tendencyPage:GetLoaded() then
		arg0_3.tendencyPage:Destroy()
		arg0_3.tendencyPage:Reset()
	end

	if arg0_3.upgradePage:GetLoaded() then
		arg0_3.upgradePage:Destroy()
		arg0_3.upgradePage:Reset()
	end
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.favorBtn, function()
		arg0_4:OpenPage(IslandOrderLevelInfoPage)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.trendBtn, function()
		local var0_7 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetTendency()

		arg0_4.tendencyPage:ExecuteAction("Show", var0_7, function(arg0_8)
			arg0_4:emit(IslandMediator.SET_ORDER_TENDENCY, arg0_8)
		end)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_9.OnSubmitOrder)
	arg0_9:AddListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_9.OnReplaceOrder)
	arg0_9:AddListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_9.OnGenNewOrder)
	arg0_9:AddListener(IslandOrderAgency.UDPATE_ORDER, arg0_9.OnFlushOrder)
	arg0_9:AddListener(GAME.ISLAND_SET_ORDER_TENDENCY_DONE, arg0_9.OnOrderTendencyChanged)
	arg0_9:AddListener(IslandScene.ON_CHECK_ORDER_EXP_AWARD, arg0_9.OnCheckOrderExpAward)
	arg0_9:AddListener(var0_0.ON_UPDADE, arg0_9.OnUpgrade)
	arg0_9:AddListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_9.OnUpdateFinishCnt)
end

function var0_0.RemoveListener(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_10.OnSubmitOrder)
	arg0_10:RemoveListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_10.OnReplaceOrder)
	arg0_10:RemoveListener(GAME.ISLAND_SET_ORDER_TENDENCY_DONE, arg0_10.OnOrderTendencyChanged)
	arg0_10:RemoveListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_10.OnGenNewOrder)
	arg0_10:RemoveListener(IslandOrderAgency.UDPATE_ORDER, arg0_10.OnFlushOrder)
	arg0_10:RemoveListener(var0_0.ON_UPDADE, arg0_10.OnUpgrade)
	arg0_10:RemoveListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_10.OnUpdateFinishCnt)
end

function var0_0.OnReset(arg0_11)
	arg0_11:Flush()
end

function var0_0.OnUpgrade(arg0_12, arg1_12)
	arg0_12.upgradePage:ExecuteAction("Show", arg1_12.level, arg1_12.callback)
end

function var0_0.OnOrderTendencyChanged(arg0_13)
	local var0_13 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_13:UpdateTrendBtn(var0_13)
end

function var0_0.OnSubmitOrder(arg0_14, arg1_14)
	local var0_14 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_14:UpdateExpPanel(var0_14)
	arg0_14:UpdateOrderState(arg1_14.slotId)
	arg0_14:UpdateCount(var0_14)
end

function var0_0.OnReplaceOrder(arg0_15, arg1_15)
	arg0_15:UpdateOrderState(arg1_15.slotId)
end

function var0_0.OnGenNewOrder(arg0_16, arg1_16)
	arg0_16:UpdateOrderState(arg1_16.slotId)
end

function var0_0.OnFlushOrder(arg0_17, arg1_17)
	arg0_17:UpdateOrderState(arg1_17.slotId)
end

function var0_0.OnCheckOrderExpAward(arg0_18)
	arg0_18:CheckOrderExpAward()
end

function var0_0.OnUpdateFinishCnt(arg0_19)
	local var0_19 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_19:UpdateCount(var0_19)
	arg0_19:UpdateExpPanel(var0_19)
end

function var0_0.Show(arg0_20)
	var0_0.super.Show(arg0_20)
	arg0_20:Flush()
end

function var0_0.Flush(arg0_21)
	local var0_21 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_21:UpdateExpPanel(var0_21)
	arg0_21:GenOrderList(var0_21)
	arg0_21:TriggerOrder(var0_21)
	arg0_21:UpdateTrendBtn(var0_21)
	arg0_21:UpdateCount(var0_21)
	arg0_21:CheckOrderExpAward()
end

function var0_0.UpdateCount(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetMaxFinishCount()
	local var1_22 = arg1_22:GetFinishCnt()

	arg0_22.countTxt.text = i18n1("剩余订单：") .. var0_22 - var1_22 .. "/" .. var0_22
end

function var0_0.UpdateTrendBtn(arg0_23, arg1_23)
	local var0_23 = arg1_23:GetTendency()

	arg0_23.trendTxt.text = IslandOrderSlot.TENDENCY2CN(var0_23)

	local var1_23 = ({
		"icon_common",
		"icon_easy",
		"icon_hard"
	})[var0_23 + 1]
	local var2_23 = GetSpriteFromAtlas("ui/IslandOrderUI_atlas", var1_23)

	arg0_23.trendIco.sprite = var2_23
end

function var0_0.CheckOrderExpAward(arg0_24)
	local var0_24 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetAllCanGetAwardList()
	local var1_24 = {}

	for iter0_24, iter1_24 in ipairs(var0_24) do
		table.insert(var1_24, function(arg0_25)
			arg0_24:emit(IslandMediator.ON_GET_ORDER_EXP_AWARD, iter1_24, arg0_25)
		end)
	end

	seriesAsync(var1_24)
end

function var0_0.TriggerOrder(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetCacheSelectedId()
	local var1_26 = arg1_26:GetSlots()
	local var2_26 = var1_26[var0_26]

	if var2_26 and not var2_26:IsEmpty() then
		local var3_26 = arg0_26.orderTpls[var2_26.id]

		if var3_26 then
			triggerButton(var3_26)
		end
	else
		local var4_26

		for iter0_26, iter1_26 in pairs(var1_26) do
			if not iter1_26:IsEmpty() then
				var4_26 = iter1_26

				break
			end
		end

		if var4_26 then
			local var5_26 = arg0_26.orderTpls[var4_26.id]

			if var5_26 then
				triggerButton(var5_26)
			end
		end
	end
end

function var0_0.GenOrderList(arg0_27, arg1_27)
	arg0_27:ReturnOrderTplList()

	local var0_27 = arg1_27:GetSlots()

	for iter0_27, iter1_27 in pairs(var0_27) do
		arg0_27:NewOrderTpl(iter1_27.id)
		arg0_27:UpdateOrderState(iter1_27.id)
	end
end

function var0_0.NewOrderTpl(arg0_28, arg1_28)
	local var0_28 = arg0_28.orderTplPool:Dequeue()

	setParent(var0_28, arg0_28.orderContainer)

	arg0_28.orderTpls[arg1_28] = var0_28
end

function var0_0.ReturnOrderTplList(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29.orderTpls) do
		arg0_29.orderTplPool:Enqueue(iter1_29)
	end

	arg0_29.orderTpls = {}
end

function var0_0.UpdateOrderState(arg0_30, arg1_30)
	local var0_30 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_30)
	local var1_30 = arg0_30.orderTpls[arg1_30] or arg0_30:NewOrderTpl(arg1_30)

	arg0_30:RemoveLoadingTimer(arg1_30)
	arg0_30:RemoveDisappearTimer(arg1_30)
	arg0_30:ShowDiaglog(var0_30)

	if not var0_30 or var0_30:IsEmpty() then
		removeOnButton(var1_30)
		setActive(var1_30, false)

		return
	end

	var1_30.transform.localPosition = var0_30:GetPosition()

	setActive(var1_30, true)
	onButton(arg0_30, var1_30, function()
		arg0_30:ClickOrder(var1_30, var0_30)

		arg0_30.selected = var1_30
	end, SFX_PANEL)

	local var2_30 = var0_30:GetOrder()
	local var3_30 = var0_30:CanSubmit()

	setActive(var1_30.transform:Find("bg_urgent"), var2_30:IsUrgency())
	setActive(var1_30.transform:Find("sel"), arg0_30.selected and arg0_30.selected == var1_30)
	setActive(var1_30.transform:Find("finish"), var3_30)
	setActive(var1_30.transform:Find("easy"), var2_30:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_EASY)
	setActive(var1_30.transform:Find("hard"), var2_30:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_HARD)

	local var4_30 = var0_30:IsLoading()

	setActive(var1_30.transform:Find("icon"), not var4_30)
	setActive(var1_30.transform:Find("loading"), var4_30)
	setActive(var1_30.transform:Find("bg/progress"), not var4_30)

	local var5_30 = var2_30:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("QIcon/" .. var5_30, "", var1_30.transform:Find("icon"))

	if var4_30 then
		arg0_30:AddLoadingTimer(var1_30, var0_30)
	end

	if var2_30:IsUrgency() then
		arg0_30:AddDisappearTimer(var1_30, var0_30)
	end
end

function var0_0.AddDisappearTimer(arg0_32, arg1_32, arg2_32)
	arg0_32:RemoveDisappearTimer(arg2_32.id)

	local var0_32 = arg2_32:GetDisappearTime()

	if var0_32 <= pg.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	arg0_32.disappearTimers[arg2_32.id] = Timer.New(function()
		local var0_33 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_33 = var0_32 - var0_33
		local var2_33 = pg.TimeMgr.GetInstance():DescCDTime(var1_33)

		setText(arg1_32.transform:Find("bg_urgent/time_label/Text"), var2_33)

		if var1_33 < 0 then
			arg0_32:UpdateOrderState(arg2_32.id)
		end
	end, 1, -1)

	arg0_32.disappearTimers[arg2_32.id].func()
	arg0_32.disappearTimers[arg2_32.id]:Start()
end

function var0_0.RemoveDisappearTimer(arg0_34, arg1_34)
	if arg0_34.disappearTimers[arg1_34] then
		arg0_34.disappearTimers[arg1_34]:Stop()

		arg0_34.disappearTimers[arg1_34] = nil
	end
end

function var0_0.ClickOrder(arg0_35, arg1_35, arg2_35)
	arg0_35:OpenPage(IslandOrderDescPage, arg2_35)
	arg0_35:ShowDiaglog(arg2_35)
	getProxy(IslandProxy):GetIsland():GetOrderAgency():SetCacheSelectedId(arg2_35.id)

	if arg0_35.selected then
		setActive(arg0_35.selected.transform:Find("sel"), false)
	end

	setActive(arg1_35.transform:Find("sel"), true)
end

function var0_0.ShowDiaglog(arg0_36, arg1_36)
	if not arg1_36 or not arg1_36:GetOrder() or arg1_36:IsEmpty() or arg1_36:IsLoading() then
		setActive(arg0_36.charTr, false)

		return
	end

	local var0_36 = arg1_36:GetOrder()

	setActive(arg0_36.charTr, true)

	arg0_36.chatTxt.text = var0_36:GetDesc()
end

function var0_0.AddLoadingTimer(arg0_37, arg1_37, arg2_37)
	local function var0_37()
		arg0_37:UpdateOrderState(arg2_37.id)
	end

	local var1_37 = arg2_37:GetCanSubmitTime()
	local var2_37 = arg2_37:GetTotalTime()
	local var3_37 = Timer.New(function()
		local var0_39 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_39 = var1_37 - var0_39

		setText(arg1_37.transform:Find("loading/time_label/Text"), pg.TimeMgr.GetInstance():DescCDTime(var1_39))
		setFillAmount(arg1_37.transform:Find("loading/progress"), 1 - var1_39 / var2_37)

		if var1_39 <= 0 then
			var0_37()
		end
	end, 1, -1)

	var3_37:Start()
	var3_37.func()

	arg0_37.timers[arg2_37.id] = var3_37
end

function var0_0.RemoveLoadingTimer(arg0_40, arg1_40)
	if arg0_40.timers[arg1_40] then
		arg0_40.timers[arg1_40]:Stop()

		arg0_40.timers[arg1_40] = nil
	end
end

function var0_0.RemoveAllLoadingTimer(arg0_41)
	for iter0_41, iter1_41 in pairs(arg0_41.timers) do
		iter1_41:Stop()
	end

	for iter2_41, iter3_41 in pairs(arg0_41.disappearTimers) do
		iter3_41:Stop()
	end

	arg0_41.disappearTimers = {}
	arg0_41.timers = {}
end

function var0_0.UpdateExpPanel(arg0_42, arg1_42)
	arg0_42.levelTxt.text = arg1_42:GetLevel()

	if arg1_42:IsMaxLevel() then
		arg0_42.expTxt.text = "MAX"
	else
		local var0_42 = arg1_42:GetExp()
		local var1_42 = math.max(1, arg1_42:GetNextTargetExp())

		arg0_42.expTxt.text = var0_42 .. "/" .. var1_42
	end
end

function var0_0.OnDestroy(arg0_43)
	if arg0_43.tendencyPage then
		arg0_43.tendencyPage:Destroy()

		arg0_43.tendencyPage = nil
	end

	if arg0_43.upgradePage:GetLoaded() then
		arg0_43.upgradePage:Destroy()

		arg0_43.upgradePage = nil
	end

	if arg0_43.orderTplPool then
		arg0_43.orderTplPool:Dispose()

		arg0_43.orderTplPool = nil
	end

	arg0_43:RemoveAllLoadingTimer()
end

return var0_0
