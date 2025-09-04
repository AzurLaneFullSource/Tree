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
	arg0_2.upgradePage = IslandOrderUpgradePage.New(arg0_2._parentTf)
	arg0_2.countTxt = arg0_2:findTF("count_bg/Text"):GetComponent(typeof(Text))
	arg0_2.orderTplPool = OrderTplPool.New(arg0_2:findTF("root/orderTpl"), 3, 6)
	arg0_2.orderTpls = {}
	arg0_2.timers = {}
	arg0_2.disappearTimers = {}

	setActive(arg0_2.charTr, false)
	setText(arg0_2:findTF("top/title/Text"), i18n("island_order_title"))
end

function var0_0.OnHide(arg0_3)
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

		arg0_4:ShowMsgBox({
			type = IslandMsgBox.TYPE_ORDER_TENDENCY,
			title = i18n("island_order_difficulty"),
			selected = var0_7,
			onYes = function(arg0_8)
				arg0_4:emit(IslandMediator.SET_ORDER_TENDENCY, arg0_8)
			end
		})
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

	for iter0_14, iter1_14 in pairs(arg0_14.orderTpls or {}) do
		arg0_14:UpdateOrderState(iter0_14)
	end
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

	arg0_22.countTxt.text = i18n("island_order_leftCnt_tip") .. var0_22 - var1_22 .. "/" .. var0_22
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

	seriesAsync(var1_24, function()
		if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(IslandGuideChecker.ORDER_TASK_ID) then
			onDelayTick(function()
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_7", IslandGuideChecker.FINISH_TYPE.ON_GUIDE)
			end, 0.2)
		end
	end)
end

function var0_0.TriggerOrder(arg0_28, arg1_28)
	local var0_28 = arg1_28:GetCacheSelectedId()
	local var1_28 = arg1_28:GetSlots()
	local var2_28 = var1_28[var0_28]

	if var2_28 and not var2_28:IsEmpty() then
		local var3_28 = arg0_28.orderTpls[var2_28.id]

		if var3_28 then
			triggerButton(var3_28)
		end
	else
		local var4_28

		for iter0_28, iter1_28 in pairs(var1_28) do
			if not iter1_28:IsEmpty() then
				var4_28 = iter1_28

				break
			end
		end

		if var4_28 then
			local var5_28 = arg0_28.orderTpls[var4_28.id]

			if var5_28 then
				triggerButton(var5_28)
			end
		end
	end
end

function var0_0.GenOrderList(arg0_29, arg1_29)
	arg0_29:ReturnOrderTplList()

	local var0_29 = arg1_29:GetSlots()

	for iter0_29, iter1_29 in pairs(var0_29) do
		arg0_29:NewOrderTpl(iter1_29.id)
		arg0_29:UpdateOrderState(iter1_29.id)
	end
end

function var0_0.NewOrderTpl(arg0_30, arg1_30)
	local var0_30 = arg0_30.orderTplPool:Dequeue()

	setParent(var0_30, arg0_30.orderContainer)

	arg0_30.orderTpls[arg1_30] = var0_30

	return var0_30
end

function var0_0.ReturnOrderTplList(arg0_31)
	for iter0_31, iter1_31 in pairs(arg0_31.orderTpls) do
		arg0_31.orderTplPool:Enqueue(iter1_31)
	end

	arg0_31.orderTpls = {}
end

function var0_0.UpdateOrderState(arg0_32, arg1_32)
	local var0_32 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_32)
	local var1_32 = arg0_32.orderTpls[arg1_32] or arg0_32:NewOrderTpl(arg1_32)

	arg0_32:RemoveLoadingTimer(arg1_32)
	arg0_32:RemoveDisappearTimer(arg1_32)
	arg0_32:ShowDiaglog(var0_32)

	if not var0_32 or var0_32:IsEmpty() then
		removeOnButton(var1_32)
		setActive(var1_32, false)

		return
	end

	var1_32.transform.localPosition = var0_32:GetPosition()

	setActive(var1_32, true)
	onButton(arg0_32, var1_32, function()
		arg0_32:ClickOrder(var1_32, var0_32)

		arg0_32.selected = var1_32
	end, SFX_PANEL)

	local var2_32 = var0_32:GetOrder()
	local var3_32 = var0_32:CanSubmit()

	setActive(var1_32.transform:Find("bg_urgent"), var2_32:IsUrgency())
	setActive(var1_32.transform:Find("sel"), arg0_32.selected and arg0_32.selected == var1_32)
	setActive(var1_32.transform:Find("finish"), var3_32)
	setActive(var1_32.transform:Find("easy"), var2_32:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_EASY)
	setActive(var1_32.transform:Find("hard"), var2_32:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_HARD)

	local var4_32 = var0_32:IsLoading()

	setActive(var1_32.transform:Find("icon"), not var4_32)
	setActive(var1_32.transform:Find("loading"), var4_32)
	setActive(var1_32.transform:Find("bg/progress"), not var4_32)

	local var5_32 = var2_32:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var5_32, "", var1_32.transform:Find("icon"))

	if var4_32 then
		arg0_32:AddLoadingTimer(var1_32, var0_32)
	end

	if var2_32:IsUrgency() then
		arg0_32:AddDisappearTimer(var1_32, var0_32)
	end
end

function var0_0.AddDisappearTimer(arg0_34, arg1_34, arg2_34)
	arg0_34:RemoveDisappearTimer(arg2_34.id)

	local var0_34 = arg2_34:GetDisappearTime()

	if var0_34 <= pg.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	arg0_34.disappearTimers[arg2_34.id] = Timer.New(function()
		local var0_35 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_35 = var0_34 - var0_35
		local var2_35 = pg.TimeMgr.GetInstance():DescCDTime(var1_35)

		setText(arg1_34.transform:Find("bg_urgent/time_label/Text"), var2_35)

		if var1_35 < 0 then
			arg0_34:UpdateOrderState(arg2_34.id)
		end
	end, 1, -1)

	arg0_34.disappearTimers[arg2_34.id].func()
	arg0_34.disappearTimers[arg2_34.id]:Start()
end

function var0_0.RemoveDisappearTimer(arg0_36, arg1_36)
	if arg0_36.disappearTimers[arg1_36] then
		arg0_36.disappearTimers[arg1_36]:Stop()

		arg0_36.disappearTimers[arg1_36] = nil
	end
end

function var0_0.ClickOrder(arg0_37, arg1_37, arg2_37)
	arg0_37:OpenPage(IslandOrderDescPage, arg2_37)
	arg0_37:ShowDiaglog(arg2_37)
	getProxy(IslandProxy):GetIsland():GetOrderAgency():SetCacheSelectedId(arg2_37.id)

	if arg0_37.selected then
		setActive(arg0_37.selected.transform:Find("sel"), false)
	end

	setActive(arg1_37.transform:Find("sel"), true)
end

function var0_0.ShowDiaglog(arg0_38, arg1_38)
	if not arg1_38 or not arg1_38:GetOrder() or arg1_38:IsEmpty() or arg1_38:IsLoading() then
		setActive(arg0_38.charTr, false)

		return
	end

	local var0_38 = arg1_38:GetOrder()

	setActive(arg0_38.charTr, true)

	local var1_38 = var0_38:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("island/IslandShipIconHalf/" .. var1_38, "", arg0_38.charTr)

	arg0_38.chatTxt.text = var0_38:GetDesc()
end

function var0_0.AddLoadingTimer(arg0_39, arg1_39, arg2_39)
	local function var0_39()
		arg0_39:UpdateOrderState(arg2_39.id)
	end

	local var1_39 = arg2_39:GetCanSubmitTime()
	local var2_39 = arg2_39:GetTotalTime()
	local var3_39 = Timer.New(function()
		local var0_41 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_41 = var1_39 - var0_41

		setText(arg1_39.transform:Find("loading/time_label/Text"), pg.TimeMgr.GetInstance():DescCDTime(var1_41))
		setFillAmount(arg1_39.transform:Find("loading/progress"), 1 - var1_41 / var2_39)

		if var1_41 <= 0 then
			var0_39()
		end
	end, 1, -1)

	var3_39:Start()
	var3_39.func()

	arg0_39.timers[arg2_39.id] = var3_39
end

function var0_0.RemoveLoadingTimer(arg0_42, arg1_42)
	if arg0_42.timers[arg1_42] then
		arg0_42.timers[arg1_42]:Stop()

		arg0_42.timers[arg1_42] = nil
	end
end

function var0_0.RemoveAllLoadingTimer(arg0_43)
	for iter0_43, iter1_43 in pairs(arg0_43.timers) do
		iter1_43:Stop()
	end

	for iter2_43, iter3_43 in pairs(arg0_43.disappearTimers) do
		iter3_43:Stop()
	end

	arg0_43.disappearTimers = {}
	arg0_43.timers = {}
end

function var0_0.UpdateExpPanel(arg0_44, arg1_44)
	arg0_44.levelTxt.text = arg1_44:GetLevel()

	if arg1_44:IsMaxLevel() then
		arg0_44.expTxt.text = "MAX"
	else
		local var0_44 = arg1_44:GetExp()
		local var1_44 = math.max(1, arg1_44:GetNextTargetExp())

		arg0_44.expTxt.text = var0_44 .. "/" .. var1_44
	end
end

function var0_0.OnDestroy(arg0_45)
	if arg0_45.upgradePage:GetLoaded() then
		arg0_45.upgradePage:Destroy()

		arg0_45.upgradePage = nil
	end

	if arg0_45.orderTplPool then
		arg0_45.orderTplPool:Dispose()

		arg0_45.orderTplPool = nil
	end

	arg0_45:RemoveAllLoadingTimer()
end

return var0_0
