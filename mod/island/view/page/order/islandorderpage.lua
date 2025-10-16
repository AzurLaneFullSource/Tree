local var0_0 = class("IslandOrderPage", import("...base.IslandBasePage"))

var0_0.ON_UPDADE = "IslandOrderPage:ON_UPDADE"

function var0_0.getUIName(arg0_1)
	return "IslandOrderUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("top/back")
	arg0_2.favorBtn = arg0_2._tf:Find("top/favor_bg")
	arg0_2.levelTxt = arg0_2._tf:Find("top/favor_bg/level"):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2._tf:Find("top/favor_bg/Text"):GetComponent(typeof(Text))
	arg0_2.charTr = arg0_2._tf:Find("bottom/char")
	arg0_2.chatTxt = arg0_2.charTr:Find("dialogue/Text"):GetComponent(typeof(Text))
	arg0_2.trendBtn = arg0_2._tf:Find("trend_btn")
	arg0_2.trendIco = arg0_2.trendBtn:Find("difficulty"):GetComponent(typeof(Image))
	arg0_2.trendTxt = arg0_2.trendBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.orderContainer = arg0_2._tf:Find("map")
	arg0_2.upgradePage = IslandOrderUpgradePage.New(arg0_2._parentTf)
	arg0_2.countTxt = arg0_2._tf:Find("count_bg/Text"):GetComponent(typeof(Text))
	arg0_2.orderTplPool = OrderTplPool.New(arg0_2._tf:Find("root/orderTpl"), 3, 6)
	arg0_2.orderTpls = {}
	arg0_2.timers = {}
	arg0_2.disappearTimers = {}

	setActive(arg0_2.charTr, false)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_order_title"))
end

function var0_0.OnHide(arg0_3)
	if arg0_3.upgradePage:GetLoaded() then
		arg0_3.upgradePage:Destroy()
		arg0_3.upgradePage:Reset()
	end
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("top/title/help"), function()
		arg0_4:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_helpbtn_order")
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.favorBtn, function()
		arg0_4:OpenPage(IslandOrderLevelInfoPage)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.trendBtn, function()
		local var0_8 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetTendency()

		arg0_4:ShowMsgBox({
			type = IslandMsgBox.TYPE_ORDER_TENDENCY,
			title = i18n("island_order_difficulty"),
			selected = var0_8,
			onYes = function(arg0_9)
				arg0_4:emit(IslandMediator.SET_ORDER_TENDENCY, arg0_9)
			end
		})
	end, SFX_PANEL)
	arg0_4:UpdateFavorBtn()
end

function var0_0.UpdateFavorBtn(arg0_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	setActive(arg0_10.favorBtn, var0_10:ExpSystemIsOpen())
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_11.OnSubmitOrder)
	arg0_11:AddListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_11.OnReplaceOrder)
	arg0_11:AddListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_11.OnGenNewOrder)
	arg0_11:AddListener(IslandOrderAgency.UDPATE_ORDER, arg0_11.OnFlushOrder)
	arg0_11:AddListener(GAME.ISLAND_SET_ORDER_TENDENCY_DONE, arg0_11.OnOrderTendencyChanged)
	arg0_11:AddListener(IslandScene.ON_CHECK_ORDER_EXP_AWARD, arg0_11.OnCheckOrderExpAward)
	arg0_11:AddListener(var0_0.ON_UPDADE, arg0_11.OnUpgrade)
	arg0_11:AddListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_11.OnUpdateFinishCnt)
	arg0_11:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_11.OnUseTicketDone)
	arg0_11:AddListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_11.OnUnlockSystem)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_12.OnSubmitOrder)
	arg0_12:RemoveListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_12.OnReplaceOrder)
	arg0_12:RemoveListener(GAME.ISLAND_SET_ORDER_TENDENCY_DONE, arg0_12.OnOrderTendencyChanged)
	arg0_12:RemoveListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_12.OnGenNewOrder)
	arg0_12:RemoveListener(IslandOrderAgency.UDPATE_ORDER, arg0_12.OnFlushOrder)
	arg0_12:RemoveListener(var0_0.ON_UPDADE, arg0_12.OnUpgrade)
	arg0_12:RemoveListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_12.OnUpdateFinishCnt)
	arg0_12:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_12.OnUseTicketDone)
	arg0_12:RemoveListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_12.OnUnlockSystem)
end

function var0_0.OnUnlockSystem(arg0_13)
	arg0_13:UpdateFavorBtn()
	arg0_13:CheckOrderExpAward()
end

function var0_0.OnReset(arg0_14)
	arg0_14:Flush()
end

function var0_0.OnUpgrade(arg0_15, arg1_15)
	arg0_15.upgradePage:ExecuteAction("Show", arg1_15.level, arg1_15.callback)
end

function var0_0.OnOrderTendencyChanged(arg0_16)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_16:UpdateTrendBtn(var0_16)
end

function var0_0.OnSubmitOrder(arg0_17, arg1_17)
	local var0_17 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_17:UpdateExpPanel(var0_17)
	arg0_17:UpdateOrderState(arg1_17.slotId)
	arg0_17:UpdateCount(var0_17)

	for iter0_17, iter1_17 in pairs(arg0_17.orderTpls or {}) do
		arg0_17:UpdateOrderState(iter0_17)
	end
end

function var0_0.OnReplaceOrder(arg0_18, arg1_18)
	arg0_18:UpdateOrderState(arg1_18.slotId)
end

function var0_0.OnGenNewOrder(arg0_19, arg1_19)
	arg0_19:UpdateOrderState(arg1_19.slotId)
end

function var0_0.OnFlushOrder(arg0_20, arg1_20)
	arg0_20:UpdateOrderState(arg1_20.slotId)
end

function var0_0.OnUseTicketDone(arg0_21, arg1_21)
	if arg1_21.type == IslandUseTicketCommand.TYPES.ORDER_CD then
		arg0_21:UpdateOrderState(arg1_21.id)
	end
end

function var0_0.OnCheckOrderExpAward(arg0_22)
	arg0_22:CheckOrderExpAward()
end

function var0_0.OnUpdateFinishCnt(arg0_23)
	local var0_23 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_23:UpdateCount(var0_23)
	arg0_23:UpdateExpPanel(var0_23)
end

function var0_0.Show(arg0_24)
	var0_0.super.Show(arg0_24)
	arg0_24:Flush()
end

function var0_0.Flush(arg0_25)
	local var0_25 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_25:UpdateExpPanel(var0_25)
	arg0_25:GenOrderList(var0_25)
	arg0_25:TriggerOrder(var0_25)
	arg0_25:UpdateTrendBtn(var0_25)
	arg0_25:UpdateCount(var0_25)
	arg0_25:CheckOrderExpAward()
end

function var0_0.UpdateCount(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetMaxFinishCount()
	local var1_26 = arg1_26:GetFinishCnt()

	arg0_26.countTxt.text = i18n("island_order_leftCnt_tip") .. var0_26 - var1_26 .. "/" .. var0_26
end

function var0_0.UpdateTrendBtn(arg0_27, arg1_27)
	local var0_27 = arg1_27:GetTendency()

	arg0_27.trendTxt.text = IslandOrderSlot.TENDENCY2CN(var0_27)

	local var1_27 = ({
		"icon_common",
		"icon_easy",
		"icon_hard"
	})[var0_27 + 1]
	local var2_27 = GetSpriteFromAtlas("ui/IslandOrderUI_atlas", var1_27)

	arg0_27.trendIco.sprite = var2_27
end

function var0_0.CheckOrderExpAward(arg0_28)
	local var0_28 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	if not var0_28:ExpSystemIsOpen() then
		arg0_28:CheckGuide()

		return
	end

	local var1_28 = var0_28:GetAllCanGetAwardList()
	local var2_28 = {}

	for iter0_28, iter1_28 in ipairs(var1_28) do
		table.insert(var2_28, function(arg0_29)
			arg0_28:emit(IslandMediator.ON_GET_ORDER_EXP_AWARD, iter1_28, arg0_29)
		end)
	end

	seriesAsync(var2_28, function()
		arg0_28:CheckGuide()
	end)
end

function var0_0.CheckGuide(arg0_31)
	if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(IslandGuideChecker.ORDER_TASK_ID) then
		onDelayTick(function()
			IslandGuideChecker.CheckGuide("ISLAND_GUIDE_7", IslandGuideChecker.FINISH_TYPE.ON_GUIDE)
		end, 0.2)
	end
end

function var0_0.TriggerOrder(arg0_33, arg1_33)
	local var0_33 = arg1_33:GetCacheSelectedId()
	local var1_33 = arg1_33:GetSlots()
	local var2_33 = var1_33[var0_33]

	if var2_33 and not var2_33:IsEmpty() then
		local var3_33 = arg0_33.orderTpls[var2_33.id]

		if var3_33 then
			triggerButton(var3_33)
		end
	else
		local var4_33

		for iter0_33, iter1_33 in pairs(var1_33) do
			if not iter1_33:IsEmpty() then
				var4_33 = iter1_33

				break
			end
		end

		if var4_33 then
			local var5_33 = arg0_33.orderTpls[var4_33.id]

			if var5_33 then
				triggerButton(var5_33)
			end
		end
	end
end

function var0_0.GenOrderList(arg0_34, arg1_34)
	arg0_34:ReturnOrderTplList()

	local var0_34 = arg1_34:GetSlots()

	for iter0_34, iter1_34 in pairs(var0_34) do
		arg0_34:NewOrderTpl(iter1_34.id)
		arg0_34:UpdateOrderState(iter1_34.id)
	end
end

function var0_0.NewOrderTpl(arg0_35, arg1_35)
	local var0_35 = arg0_35.orderTplPool:Dequeue()

	setParent(var0_35, arg0_35.orderContainer)

	arg0_35.orderTpls[arg1_35] = var0_35

	return var0_35
end

function var0_0.ReturnOrderTplList(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36.orderTpls) do
		arg0_36.orderTplPool:Enqueue(iter1_36)
	end

	arg0_36.orderTpls = {}
end

function var0_0.UpdateOrderState(arg0_37, arg1_37)
	local var0_37 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_37)
	local var1_37 = arg0_37.orderTpls[arg1_37] or arg0_37:NewOrderTpl(arg1_37)

	arg0_37:RemoveLoadingTimer(arg1_37)
	arg0_37:RemoveDisappearTimer(arg1_37)
	arg0_37:ShowDiaglog(var0_37)

	if not var0_37 or var0_37:IsEmpty() then
		removeOnButton(var1_37)
		setActive(var1_37, false)

		return
	end

	var1_37.transform.localPosition = var0_37:GetPosition()

	setActive(var1_37, true)
	onButton(arg0_37, var1_37, function()
		arg0_37:ClickOrder(var1_37, var0_37)

		arg0_37.selected = var1_37
	end, SFX_PANEL)

	local var2_37 = var0_37:GetOrder()
	local var3_37 = var0_37:CanSubmit()

	setActive(var1_37.transform:Find("bg_urgent"), var2_37:IsUrgency())
	setActive(var1_37.transform:Find("bg_act"), var2_37:IsActivity())
	setActive(var1_37.transform:Find("sel"), arg0_37.selected and arg0_37.selected == var1_37)
	setActive(var1_37.transform:Find("finish"), var3_37)
	setActive(var1_37.transform:Find("easy"), var2_37:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_EASY)
	setActive(var1_37.transform:Find("hard"), var2_37:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_HARD)

	local var4_37 = var0_37:IsLoading()

	setActive(var1_37.transform:Find("icon"), not var4_37)
	setActive(var1_37.transform:Find("loading"), var4_37)
	setActive(var1_37.transform:Find("bg/progress"), not var4_37)

	local var5_37 = var2_37:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var5_37, "", var1_37.transform:Find("icon"))

	if var4_37 then
		arg0_37:AddLoadingTimer(var1_37, var0_37)
	end

	if var2_37:IsUrgency() then
		arg0_37:AddDisappearTimer(var1_37, var0_37)
	end
end

function var0_0.AddDisappearTimer(arg0_39, arg1_39, arg2_39)
	arg0_39:RemoveDisappearTimer(arg2_39.id)

	local var0_39 = arg2_39:GetDisappearTime()

	if var0_39 <= pg.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	arg0_39.disappearTimers[arg2_39.id] = Timer.New(function()
		local var0_40 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_40 = var0_39 - var0_40
		local var2_40 = pg.TimeMgr.GetInstance():DescCDTime(var1_40)

		setText(arg1_39.transform:Find("bg_urgent/time_label/Text"), var2_40)

		if var1_40 < 0 then
			arg0_39:UpdateOrderState(arg2_39.id)
		end
	end, 1, -1)

	arg0_39.disappearTimers[arg2_39.id].func()
	arg0_39.disappearTimers[arg2_39.id]:Start()
end

function var0_0.RemoveDisappearTimer(arg0_41, arg1_41)
	if arg0_41.disappearTimers[arg1_41] then
		arg0_41.disappearTimers[arg1_41]:Stop()

		arg0_41.disappearTimers[arg1_41] = nil
	end
end

function var0_0.ClickOrder(arg0_42, arg1_42, arg2_42)
	arg0_42:OpenPage(IslandOrderDescPage, arg2_42)
	arg0_42:ShowDiaglog(arg2_42)
	getProxy(IslandProxy):GetIsland():GetOrderAgency():SetCacheSelectedId(arg2_42.id)

	if arg0_42.selected then
		setActive(arg0_42.selected.transform:Find("sel"), false)
	end

	setActive(arg1_42.transform:Find("sel"), true)
end

function var0_0.ShowDiaglog(arg0_43, arg1_43)
	if not arg1_43 or not arg1_43:GetOrder() or arg1_43:IsEmpty() or arg1_43:IsLoading() then
		setActive(arg0_43.charTr, false)

		return
	end

	local var0_43 = arg1_43:GetOrder()

	setActive(arg0_43.charTr, true)

	local var1_43 = var0_43:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("island/IslandShipIconHalf/" .. var1_43, "", arg0_43.charTr)

	arg0_43.chatTxt.text = var0_43:GetDesc()
end

function var0_0.AddLoadingTimer(arg0_44, arg1_44, arg2_44)
	local function var0_44()
		arg0_44:UpdateOrderState(arg2_44.id)
	end

	local var1_44 = arg2_44:GetCanSubmitTime()
	local var2_44 = arg2_44:GetTotalTime()
	local var3_44 = Timer.New(function()
		local var0_46 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_46 = var1_44 - var0_46

		setText(arg1_44.transform:Find("loading/time_label/Text"), pg.TimeMgr.GetInstance():DescCDTime(var1_46))
		setFillAmount(arg1_44.transform:Find("loading/progress"), 1 - var1_46 / var2_44)

		if var1_46 <= 0 then
			var0_44()
		end
	end, 1, -1)

	var3_44:Start()
	var3_44.func()

	arg0_44.timers[arg2_44.id] = var3_44
end

function var0_0.RemoveLoadingTimer(arg0_47, arg1_47)
	if arg0_47.timers[arg1_47] then
		arg0_47.timers[arg1_47]:Stop()

		arg0_47.timers[arg1_47] = nil
	end
end

function var0_0.RemoveAllLoadingTimer(arg0_48)
	for iter0_48, iter1_48 in pairs(arg0_48.timers) do
		iter1_48:Stop()
	end

	for iter2_48, iter3_48 in pairs(arg0_48.disappearTimers) do
		iter3_48:Stop()
	end

	arg0_48.disappearTimers = {}
	arg0_48.timers = {}
end

function var0_0.UpdateExpPanel(arg0_49, arg1_49)
	arg0_49.levelTxt.text = arg1_49:GetLevel()

	if arg1_49:IsMaxLevel() then
		arg0_49.expTxt.text = "MAX"
	else
		local var0_49 = arg1_49:GetExp()
		local var1_49 = math.max(1, arg1_49:GetNextTargetExp())

		arg0_49.expTxt.text = var0_49 .. "/" .. var1_49
	end
end

function var0_0.OnDestroy(arg0_50)
	if arg0_50.upgradePage:GetLoaded() then
		arg0_50.upgradePage:Destroy()

		arg0_50.upgradePage = nil
	end

	if arg0_50.orderTplPool then
		arg0_50.orderTplPool:Dispose()

		arg0_50.orderTplPool = nil
	end

	arg0_50:RemoveAllLoadingTimer()
end

return var0_0
