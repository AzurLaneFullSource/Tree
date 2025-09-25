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
	arg0_4:UpdateFavorBtn()
end

function var0_0.UpdateFavorBtn(arg0_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	setActive(arg0_9.favorBtn, var0_9:ExpSystemIsOpen())
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_10.OnSubmitOrder)
	arg0_10:AddListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_10.OnReplaceOrder)
	arg0_10:AddListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_10.OnGenNewOrder)
	arg0_10:AddListener(IslandOrderAgency.UDPATE_ORDER, arg0_10.OnFlushOrder)
	arg0_10:AddListener(GAME.ISLAND_SET_ORDER_TENDENCY_DONE, arg0_10.OnOrderTendencyChanged)
	arg0_10:AddListener(IslandScene.ON_CHECK_ORDER_EXP_AWARD, arg0_10.OnCheckOrderExpAward)
	arg0_10:AddListener(var0_0.ON_UPDADE, arg0_10.OnUpgrade)
	arg0_10:AddListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_10.OnUpdateFinishCnt)
	arg0_10:AddListener(GAME.ISLAND_USE_TICKET_DONE, arg0_10.OnUseTicketDone)
	arg0_10:AddListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_10.OnUnlockSystem)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLAND_SUBMIT_ORDER_DONE, arg0_11.OnSubmitOrder)
	arg0_11:RemoveListener(GAME.ISLAND_REPLACE_ORDER_DONE, arg0_11.OnReplaceOrder)
	arg0_11:RemoveListener(GAME.ISLAND_SET_ORDER_TENDENCY_DONE, arg0_11.OnOrderTendencyChanged)
	arg0_11:RemoveListener(IslandOrderAgency.GEN_NEW_ORDER, arg0_11.OnGenNewOrder)
	arg0_11:RemoveListener(IslandOrderAgency.UDPATE_ORDER, arg0_11.OnFlushOrder)
	arg0_11:RemoveListener(var0_0.ON_UPDADE, arg0_11.OnUpgrade)
	arg0_11:RemoveListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_11.OnUpdateFinishCnt)
	arg0_11:RemoveListener(GAME.ISLAND_USE_TICKET_DONE, arg0_11.OnUseTicketDone)
	arg0_11:RemoveListener(IslandAblityAgency.UNLOCK_SYSTEM, arg0_11.OnUnlockSystem)
end

function var0_0.OnUnlockSystem(arg0_12)
	arg0_12:UpdateFavorBtn()
	arg0_12:CheckOrderExpAward()
end

function var0_0.OnReset(arg0_13)
	arg0_13:Flush()
end

function var0_0.OnUpgrade(arg0_14, arg1_14)
	arg0_14.upgradePage:ExecuteAction("Show", arg1_14.level, arg1_14.callback)
end

function var0_0.OnOrderTendencyChanged(arg0_15)
	local var0_15 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_15:UpdateTrendBtn(var0_15)
end

function var0_0.OnSubmitOrder(arg0_16, arg1_16)
	local var0_16 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_16:UpdateExpPanel(var0_16)
	arg0_16:UpdateOrderState(arg1_16.slotId)
	arg0_16:UpdateCount(var0_16)

	for iter0_16, iter1_16 in pairs(arg0_16.orderTpls or {}) do
		arg0_16:UpdateOrderState(iter0_16)
	end
end

function var0_0.OnReplaceOrder(arg0_17, arg1_17)
	arg0_17:UpdateOrderState(arg1_17.slotId)
end

function var0_0.OnGenNewOrder(arg0_18, arg1_18)
	arg0_18:UpdateOrderState(arg1_18.slotId)
end

function var0_0.OnFlushOrder(arg0_19, arg1_19)
	arg0_19:UpdateOrderState(arg1_19.slotId)
end

function var0_0.OnUseTicketDone(arg0_20, arg1_20)
	if arg1_20.type == IslandUseTicketCommand.TYPES.ORDER_CD then
		arg0_20:UpdateOrderState(arg1_20.id)
	end
end

function var0_0.OnCheckOrderExpAward(arg0_21)
	arg0_21:CheckOrderExpAward()
end

function var0_0.OnUpdateFinishCnt(arg0_22)
	local var0_22 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_22:UpdateCount(var0_22)
	arg0_22:UpdateExpPanel(var0_22)
end

function var0_0.Show(arg0_23)
	var0_0.super.Show(arg0_23)
	arg0_23:Flush()
end

function var0_0.Flush(arg0_24)
	local var0_24 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_24:UpdateExpPanel(var0_24)
	arg0_24:GenOrderList(var0_24)
	arg0_24:TriggerOrder(var0_24)
	arg0_24:UpdateTrendBtn(var0_24)
	arg0_24:UpdateCount(var0_24)
	arg0_24:CheckOrderExpAward()
end

function var0_0.UpdateCount(arg0_25, arg1_25)
	local var0_25 = arg1_25:GetMaxFinishCount()
	local var1_25 = arg1_25:GetFinishCnt()

	arg0_25.countTxt.text = i18n("island_order_leftCnt_tip") .. var0_25 - var1_25 .. "/" .. var0_25
end

function var0_0.UpdateTrendBtn(arg0_26, arg1_26)
	local var0_26 = arg1_26:GetTendency()

	arg0_26.trendTxt.text = IslandOrderSlot.TENDENCY2CN(var0_26)

	local var1_26 = ({
		"icon_common",
		"icon_easy",
		"icon_hard"
	})[var0_26 + 1]
	local var2_26 = GetSpriteFromAtlas("ui/IslandOrderUI_atlas", var1_26)

	arg0_26.trendIco.sprite = var2_26
end

function var0_0.CheckOrderExpAward(arg0_27)
	local var0_27 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	if not var0_27:ExpSystemIsOpen() then
		arg0_27:CheckGuide()

		return
	end

	local var1_27 = var0_27:GetAllCanGetAwardList()
	local var2_27 = {}

	for iter0_27, iter1_27 in ipairs(var1_27) do
		table.insert(var2_27, function(arg0_28)
			arg0_27:emit(IslandMediator.ON_GET_ORDER_EXP_AWARD, iter1_27, arg0_28)
		end)
	end

	seriesAsync(var2_27, function()
		arg0_27:CheckGuide()
	end)
end

function var0_0.CheckGuide(arg0_30)
	if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(IslandGuideChecker.ORDER_TASK_ID) then
		onDelayTick(function()
			IslandGuideChecker.CheckGuide("ISLAND_GUIDE_7", IslandGuideChecker.FINISH_TYPE.ON_GUIDE)
		end, 0.2)
	end
end

function var0_0.TriggerOrder(arg0_32, arg1_32)
	local var0_32 = arg1_32:GetCacheSelectedId()
	local var1_32 = arg1_32:GetSlots()
	local var2_32 = var1_32[var0_32]

	if var2_32 and not var2_32:IsEmpty() then
		local var3_32 = arg0_32.orderTpls[var2_32.id]

		if var3_32 then
			triggerButton(var3_32)
		end
	else
		local var4_32

		for iter0_32, iter1_32 in pairs(var1_32) do
			if not iter1_32:IsEmpty() then
				var4_32 = iter1_32

				break
			end
		end

		if var4_32 then
			local var5_32 = arg0_32.orderTpls[var4_32.id]

			if var5_32 then
				triggerButton(var5_32)
			end
		end
	end
end

function var0_0.GenOrderList(arg0_33, arg1_33)
	arg0_33:ReturnOrderTplList()

	local var0_33 = arg1_33:GetSlots()

	for iter0_33, iter1_33 in pairs(var0_33) do
		arg0_33:NewOrderTpl(iter1_33.id)
		arg0_33:UpdateOrderState(iter1_33.id)
	end
end

function var0_0.NewOrderTpl(arg0_34, arg1_34)
	local var0_34 = arg0_34.orderTplPool:Dequeue()

	setParent(var0_34, arg0_34.orderContainer)

	arg0_34.orderTpls[arg1_34] = var0_34

	return var0_34
end

function var0_0.ReturnOrderTplList(arg0_35)
	for iter0_35, iter1_35 in pairs(arg0_35.orderTpls) do
		arg0_35.orderTplPool:Enqueue(iter1_35)
	end

	arg0_35.orderTpls = {}
end

function var0_0.UpdateOrderState(arg0_36, arg1_36)
	local var0_36 = getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg1_36)
	local var1_36 = arg0_36.orderTpls[arg1_36] or arg0_36:NewOrderTpl(arg1_36)

	arg0_36:RemoveLoadingTimer(arg1_36)
	arg0_36:RemoveDisappearTimer(arg1_36)
	arg0_36:ShowDiaglog(var0_36)

	if not var0_36 or var0_36:IsEmpty() then
		removeOnButton(var1_36)
		setActive(var1_36, false)

		return
	end

	var1_36.transform.localPosition = var0_36:GetPosition()

	setActive(var1_36, true)
	onButton(arg0_36, var1_36, function()
		arg0_36:ClickOrder(var1_36, var0_36)

		arg0_36.selected = var1_36
	end, SFX_PANEL)

	local var2_36 = var0_36:GetOrder()
	local var3_36 = var0_36:CanSubmit()

	setActive(var1_36.transform:Find("bg_urgent"), var2_36:IsUrgency())
	setActive(var1_36.transform:Find("bg_act"), var2_36:IsActivity())
	setActive(var1_36.transform:Find("sel"), arg0_36.selected and arg0_36.selected == var1_36)
	setActive(var1_36.transform:Find("finish"), var3_36)
	setActive(var1_36.transform:Find("easy"), var2_36:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_EASY)
	setActive(var1_36.transform:Find("hard"), var2_36:GetTendency() == IslandOrderSlot.TENDENCY_TYPE_HARD)

	local var4_36 = var0_36:IsLoading()

	setActive(var1_36.transform:Find("icon"), not var4_36)
	setActive(var1_36.transform:Find("loading"), var4_36)
	setActive(var1_36.transform:Find("bg/progress"), not var4_36)

	local var5_36 = var2_36:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var5_36, "", var1_36.transform:Find("icon"))

	if var4_36 then
		arg0_36:AddLoadingTimer(var1_36, var0_36)
	end

	if var2_36:IsUrgency() then
		arg0_36:AddDisappearTimer(var1_36, var0_36)
	end
end

function var0_0.AddDisappearTimer(arg0_38, arg1_38, arg2_38)
	arg0_38:RemoveDisappearTimer(arg2_38.id)

	local var0_38 = arg2_38:GetDisappearTime()

	if var0_38 <= pg.TimeMgr.GetInstance():GetServerTime() then
		return
	end

	arg0_38.disappearTimers[arg2_38.id] = Timer.New(function()
		local var0_39 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_39 = var0_38 - var0_39
		local var2_39 = pg.TimeMgr.GetInstance():DescCDTime(var1_39)

		setText(arg1_38.transform:Find("bg_urgent/time_label/Text"), var2_39)

		if var1_39 < 0 then
			arg0_38:UpdateOrderState(arg2_38.id)
		end
	end, 1, -1)

	arg0_38.disappearTimers[arg2_38.id].func()
	arg0_38.disappearTimers[arg2_38.id]:Start()
end

function var0_0.RemoveDisappearTimer(arg0_40, arg1_40)
	if arg0_40.disappearTimers[arg1_40] then
		arg0_40.disappearTimers[arg1_40]:Stop()

		arg0_40.disappearTimers[arg1_40] = nil
	end
end

function var0_0.ClickOrder(arg0_41, arg1_41, arg2_41)
	arg0_41:OpenPage(IslandOrderDescPage, arg2_41)
	arg0_41:ShowDiaglog(arg2_41)
	getProxy(IslandProxy):GetIsland():GetOrderAgency():SetCacheSelectedId(arg2_41.id)

	if arg0_41.selected then
		setActive(arg0_41.selected.transform:Find("sel"), false)
	end

	setActive(arg1_41.transform:Find("sel"), true)
end

function var0_0.ShowDiaglog(arg0_42, arg1_42)
	if not arg1_42 or not arg1_42:GetOrder() or arg1_42:IsEmpty() or arg1_42:IsLoading() then
		setActive(arg0_42.charTr, false)

		return
	end

	local var0_42 = arg1_42:GetOrder()

	setActive(arg0_42.charTr, true)

	local var1_42 = var0_42:GetRoleIcon()

	GetImageSpriteFromAtlasAsync("island/IslandShipIconHalf/" .. var1_42, "", arg0_42.charTr)

	arg0_42.chatTxt.text = var0_42:GetDesc()
end

function var0_0.AddLoadingTimer(arg0_43, arg1_43, arg2_43)
	local function var0_43()
		arg0_43:UpdateOrderState(arg2_43.id)
	end

	local var1_43 = arg2_43:GetCanSubmitTime()
	local var2_43 = arg2_43:GetTotalTime()
	local var3_43 = Timer.New(function()
		local var0_45 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_45 = var1_43 - var0_45

		setText(arg1_43.transform:Find("loading/time_label/Text"), pg.TimeMgr.GetInstance():DescCDTime(var1_45))
		setFillAmount(arg1_43.transform:Find("loading/progress"), 1 - var1_45 / var2_43)

		if var1_45 <= 0 then
			var0_43()
		end
	end, 1, -1)

	var3_43:Start()
	var3_43.func()

	arg0_43.timers[arg2_43.id] = var3_43
end

function var0_0.RemoveLoadingTimer(arg0_46, arg1_46)
	if arg0_46.timers[arg1_46] then
		arg0_46.timers[arg1_46]:Stop()

		arg0_46.timers[arg1_46] = nil
	end
end

function var0_0.RemoveAllLoadingTimer(arg0_47)
	for iter0_47, iter1_47 in pairs(arg0_47.timers) do
		iter1_47:Stop()
	end

	for iter2_47, iter3_47 in pairs(arg0_47.disappearTimers) do
		iter3_47:Stop()
	end

	arg0_47.disappearTimers = {}
	arg0_47.timers = {}
end

function var0_0.UpdateExpPanel(arg0_48, arg1_48)
	arg0_48.levelTxt.text = arg1_48:GetLevel()

	if arg1_48:IsMaxLevel() then
		arg0_48.expTxt.text = "MAX"
	else
		local var0_48 = arg1_48:GetExp()
		local var1_48 = math.max(1, arg1_48:GetNextTargetExp())

		arg0_48.expTxt.text = var0_48 .. "/" .. var1_48
	end
end

function var0_0.OnDestroy(arg0_49)
	if arg0_49.upgradePage:GetLoaded() then
		arg0_49.upgradePage:Destroy()

		arg0_49.upgradePage = nil
	end

	if arg0_49.orderTplPool then
		arg0_49.orderTplPool:Dispose()

		arg0_49.orderTplPool = nil
	end

	arg0_49:RemoveAllLoadingTimer()
end

return var0_0
