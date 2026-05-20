local var0_0 = class("MallOrderLayer", import("view.base.BaseUI"))

var0_0.STATUS = {
	EMPTY = 5,
	COMPLETE = 4,
	WAIT = 1,
	PREPARE = 2,
	DOING = 3
}

function var0_0.getUIName(arg0_1)
	return "MallOrderUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHomeBtn, function()
		arg0_2:quickExitFunc()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.mall_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiStaffSureBtn, function()
		setActive(arg0_2.uiOrderPanel, true)
		setActive(arg0_2.uiStaffPanel, false)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiOrderBtnsTF:Find("staff"), function()
		setActive(arg0_2.uiOrderPanel, false)
		setActive(arg0_2.uiStaffPanel, true)
		arg0_2.scrollCom:SetTotalCount(#arg0_2.staffList)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiOrderBtnsTF:Find("start"), function()
		arg0_2:emit(MallOrderMediator.START_ORDER, arg0_2.activity.id, arg0_2.showId, arg0_2.selectedIds)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiOrderBtnsTF:Find("complete"), function()
		arg0_2:emit(MallOrderMediator.COMPLETE_ORDER, arg0_2.activity.id, arg0_2.showId)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiDialogueTF, function()
		setActive(arg0_2.uiDialogueTF, false)
		existCall(arg0_2.completeCb)

		arg0_2.completeCb = nil
	end, SFX_PANEL)

	arg0_2.orderSlotUIList = UIItemList.New(arg0_2.uiOrderStaffTF, arg0_2.uiOrderStaffTF:Find("tpl"))

	arg0_2.orderSlotUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_2:UpdateOrderSlotTpl(arg1_11, arg2_11)
		end
	end)

	arg0_2.staffSlotUIList = UIItemList.New(arg0_2.uiStaffContentTF, arg0_2.uiStaffContentTF:Find("tpl"))

	arg0_2.staffSlotUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_2:UpdateStaffSlotTpl(arg1_12, arg2_12)
		end
	end)

	arg0_2.scrollCom = arg0_2.uiStaffScrollTF:GetComponent("LScrollRect")

	function arg0_2.scrollCom.onInitItem(arg0_13)
		arg0_2:OnInitStaffItem(arg0_13)
	end

	function arg0_2.scrollCom.onUpdateItem(arg0_14, arg1_14)
		arg0_2:OnUpdateStaffItem(arg0_14, arg1_14)
	end

	arg0_2.upgradeBox = MallUpgradeBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)

	setText(arg0_2.uiTitleText, i18n("mall_title"))
	setText(arg0_2.uiTitleEnText, i18n("mall_title_en"))
	setText(arg0_2.uiOrderBtnsTF:Find("staff/Text"), i18n("mall_order_btn_staff"))
	setText(arg0_2.uiOrderBtnsTF:Find("start/Text"), i18n("mall_order_btn_start"))
	setText(arg0_2.uiOrderBtnsTF:Find("doing/Text"), i18n("mall_order_btn_doing"))
	setText(arg0_2.uiOrderBtnsTF:Find("complete/Text"), i18n("mall_order_btn_complete"))
end

function var0_0.didEnter(arg0_15)
	arg0_15:UpdateData()
	arg0_15:UpdateView()
	triggerButton(arg0_15.uiStaffSureBtn)
end

function var0_0.UpdateData(arg0_16)
	arg0_16.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	arg0_16.level = arg0_16.activity:GetLevelData().level
	arg0_16.orderData = arg0_16.activity:GetOrderData()
	arg0_16.selectedIds = arg0_16.selectedIds or Clone(arg0_16.orderData:GetStaffList())
	arg0_16.finishedIds = arg0_16.orderData:GetFinishedList()
	arg0_16.staffList = arg0_16.activity:GetStaffList()
	arg0_16.cards = {}
end

function var0_0.ClearSelectedIds(arg0_17)
	arg0_17.selectedIds = nil
end

function var0_0.UpdateView(arg0_18)
	setText(arg0_18.uiGoldText, arg0_18.activity:GetGold())

	arg0_18.status = arg0_18:GetStatus()
	arg0_18.paintName, arg0_18.showWord, arg0_18.showName = arg0_18:GetPaintingInfo()

	if arg0_18.paintName ~= "" then
		arg0_18.paintingName = checkABExist("painting/" .. arg0_18.paintName .. "_n") and arg0_18.paintName .. "_n" or arg0_18.paintName

		setPaintingPrefab(arg0_18.uiPaintTF, arg0_18.paintingName, "duihua")
		setText(arg0_18.uiOrderDescText, pg.activity_mall_custom_order[arg0_18.showId].desc)
		setText(arg0_18.uiOrderNameText, i18n("mall_order_char_header") .. arg0_18.showName)
	end

	local var0_18 = arg0_18.status ~= var0_0.STATUS.WAIT and arg0_18.status ~= var0_0.STATUS.EMPTY

	setActive(arg0_18.uiOrderPanel:Find("content"), var0_18)
	setActive(arg0_18.uiOrderPanel:Find("empty"), not var0_18)

	if var0_18 then
		arg0_18:UpdateInfoPanel()
		arg0_18:StopNextTimer()
	else
		arg0_18:UpdateEmptyPanel()
	end

	arg0_18:CheckShowDialogue()
end

function var0_0.GetStatus(arg0_19)
	if arg0_19.orderData:IsFinishedAll() then
		return var0_0.STATUS.EMPTY
	end

	arg0_19.showId = 0

	if arg0_19.orderData.id ~= 0 then
		arg0_19.showId = arg0_19.orderData.id

		return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_19.orderData:GetEndTime() and var0_0.STATUS.COMPLETE or var0_0.STATUS.DOING
	else
		arg0_19.showId = underscore.detect(pg.activity_mall_custom_order.all, function(arg0_20)
			return not table.contains(arg0_19.finishedIds, arg0_20)
		end)

		local var0_19 = pg.activity_mall_custom_order[arg0_19.showId]

		return arg0_19.level >= var0_19.unlock_lv and arg0_19.activity:getDayIndex() >= var0_19.unlock_time and var0_0.STATUS.PREPARE or var0_0.STATUS.WAIT
	end
end

function var0_0.GetPaintingInfo(arg0_21)
	local var0_21 = pg.activity_mall_custom_order[arg0_21.showId]
	local var1_21 = pg.ship_skin_template

	return switch(arg0_21.status, {
		[var0_0.STATUS.WAIT] = function()
			return "", "", ""
		end,
		[var0_0.STATUS.PREPARE] = function()
			return var1_21[var0_21.char].painting, var0_21.word.intro_word[1], var0_21.char_name or ""
		end,
		[var0_0.STATUS.DOING] = function()
			return var1_21[var0_21.char].painting, var0_21.word.ongoing_word[1], var0_21.char_name or ""
		end,
		[var0_0.STATUS.COMPLETE] = function()
			return var1_21[var0_21.char].painting, var0_21.word.ongoing_word[1], var0_21.char_name or ""
		end,
		[var0_0.STATUS.EMPTY] = function()
			return "", "", ""
		end
	})
end

function var0_0.CheckShowDialogue(arg0_27)
	setActive(arg0_27.uiPaintDialogueTF, false)

	if arg0_27.status ~= var0_0.STATUS.WAIT and arg0_27.status ~= var0_0.STATUS.EMPTY then
		setText(arg0_27.uiPaintDialogueTF:Find("Text"), arg0_27.showWord)
		setActive(arg0_27.uiPaintDialogueTF, true)
	end
end

function var0_0.ShowCompleteDialogue(arg0_28, arg1_28)
	arg0_28.completeCb = arg1_28

	setPaintingPrefab(arg0_28.uiDialogueTF:Find("paint"), arg0_28.paintName, "duihua")

	local var0_28 = pg.activity_mall_custom_order[arg0_28.showId].word.finished_word[1]

	setText(arg0_28.uiDialogueTF:Find("content/Text"), var0_28)
	setActive(arg0_28.uiDialogueTF, true)
end

function var0_0.UpdateInfoPanel(arg0_29)
	arg0_29.showConfig = pg.activity_mall_custom_order[arg0_29.showId]

	arg0_29:UpdateStaffAndTarget()
	arg0_29:UpdataOrderInfo()
	arg0_29:UpdateBtns()
	arg0_29:SetTotalCount()
end

function var0_0.UpdateStaffAndTarget(arg0_30)
	arg0_30.targetNum, arg0_30.targetAttrs, arg0_30.curAttrs = 0, {}, {}

	for iter0_30, iter1_30 in ipairs(arg0_30.showConfig.order_need) do
		if iter0_30 == 1 then
			arg0_30.targetNum = iter1_30
		else
			table.insert(arg0_30.targetAttrs, iter1_30)
			table.insert(arg0_30.curAttrs, 0)
		end
	end

	for iter2_30, iter3_30 in ipairs(arg0_30.selectedIds) do
		local var0_30 = arg0_30.activity:GetStaff(iter3_30)

		for iter4_30, iter5_30 in ipairs(var0_30:GetAttrList()) do
			arg0_30.curAttrs[iter4_30] = arg0_30.curAttrs[iter4_30] + iter5_30
		end
	end

	arg0_30:UpdateStaffAttrsCond(arg0_30.uiStaffAttrsCondTF)
	arg0_30.orderSlotUIList:align(arg0_30.targetNum)
	arg0_30.staffSlotUIList:align(arg0_30.targetNum)

	if isActive(arg0_30.uiStaffPanel) then
		arg0_30.scrollCom:SetTotalCount(#arg0_30.staffList)
	end

	arg0_30:CheckStartBtn()
end

function var0_0.UpdateStaffAttrsCond(arg0_31, arg1_31)
	local var0_31 = arg1_31:Find("desc")

	setText(var0_31:Find("Text"), i18n("mall_order_need_attrs_header"))

	local var1_31 = true

	for iter0_31, iter1_31 in ipairs(arg0_31.targetAttrs) do
		local var2_31 = iter1_31 <= arg0_31.curAttrs[iter0_31]

		if not var2_31 then
			var1_31 = false
		end

		setActive(var0_31:Find("list/" .. iter0_31), iter1_31 > 0)

		if iter1_31 > 0 then
			local var3_31 = setColorStr(arg0_31.curAttrs[iter0_31], var2_31 and "#4c9922" or "#df6126") .. "/" .. iter1_31

			setText(var0_31:Find("list/" .. iter0_31 .. "/Text"), var3_31)
		end
	end

	setActive(arg1_31:Find("unfinished"), not var1_31)
	setActive(arg1_31:Find("finished"), var1_31)
end

function var0_0.UpdataOrderInfo(arg0_32)
	local var0_32 = underscore.map(arg0_32.showConfig.order_cost_show, function(arg0_33)
		local var0_33 = Drop.Create(arg0_33)

		return {
			text = i18n("word_consume") .. var0_33.count .. var0_33:getName(),
			isReach = var0_33:getOwnedCount() >= var0_33.count
		}
	end)

	arg0_32:UpdateStaffAttrsCond(arg0_32.uiOrderAttrsCondTF)

	local var1_32 = #arg0_32.selectedIds >= arg0_32.targetNum
	local var2_32 = setColorStr(#arg0_32.selectedIds, var1_32 and "#4c9922" or "#df6126")
	local var3_32 = i18n("mall_order_need_staff_header") .. var2_32 .. "/" .. arg0_32.targetNum

	table.insert(var0_32, 1, {
		text = var3_32,
		isReach = var1_32
	})
	UIItemList.StaticAlign(arg0_32.uiOrderCostTF, arg0_32.uiOrderCostTF:Find("tpl"), #var0_32, function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			setText(arg2_34:Find("Text"), var0_32[arg1_34 + 1].text)
			setActive(arg2_34:Find("unfinished"), not var0_32[arg1_34 + 1].isReach)
			setActive(arg2_34:Find("finished"), var0_32[arg1_34 + 1].isReach)
		end
	end)

	local var4_32 = underscore.map(arg0_32.showConfig.order_reward_show, function(arg0_35)
		local var0_35 = Drop.Create(arg0_35)

		return var0_35:getName() .. "*" .. var0_35.count
	end)

	UIItemList.StaticAlign(arg0_32.uiOrderAwardTF, arg0_32.uiOrderAwardTF:Find("tpl"), #var4_32, function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventUpdate then
			setText(arg2_36:Find("Text"), var4_32[arg1_36 + 1])
		end
	end)
end

function var0_0.UpdateBtns(arg0_37)
	arg0_37:CheckStartBtn()
	setActive(arg0_37.uiOrderBtnsTF:Find("doing"), arg0_37.status == var0_0.STATUS.DOING)
	setActive(arg0_37.uiOrderBtnsTF:Find("complete"), arg0_37.status == var0_0.STATUS.COMPLETE)
	setActive(arg0_37.uiOrderBtnsTF:Find("time"), arg0_37.status == var0_0.STATUS.DOING or arg0_37.status == var0_0.STATUS.PREPARE)

	if arg0_37.status == var0_0.STATUS.PREPARE then
		setText(arg0_37.uiOrderBtnsTF:Find("time/Text"), pg.TimeMgr.GetInstance():DescCDTime(arg0_37.showConfig.cost_time))
	end

	if arg0_37.status == var0_0.STATUS.DOING then
		arg0_37:StartTimer()
	else
		arg0_37:StopTimer()
	end
end

function var0_0.CheckStartBtn(arg0_38)
	if arg0_38.status == var0_0.STATUS.PREPARE then
		setActive(arg0_38.uiOrderBtnsTF:Find("start"), arg0_38:CanStart())
	else
		setActive(arg0_38.uiOrderBtnsTF:Find("start"), false)
	end
end

function var0_0.CanStart(arg0_39)
	if #arg0_39.selectedIds ~= arg0_39.targetNum then
		return false
	end

	if arg0_39.activity:GetGold() < arg0_39.showConfig.order_cost_gold then
		return false
	end

	for iter0_39, iter1_39 in ipairs(arg0_39.targetAttrs) do
		if iter1_39 > arg0_39.curAttrs[iter0_39] then
			return false
		end
	end

	for iter2_39, iter3_39 in ipairs(MallOrder.GetCost(arg0_39.showId)) do
		if iter3_39:getOwnedCount() < iter3_39.count then
			return false
		end
	end

	return true
end

function var0_0.UpdateEmptyPanel(arg0_40)
	arg0_40:StopNextTimer()

	local var0_40 = arg0_40.uiOrderPanel:Find("empty")
	local var1_40 = var0_40:Find("list/tip")

	setActive(var1_40, arg0_40.status == var0_0.STATUS.EMPTY)

	local var2_40 = var0_40:Find("list/time")
	local var3_40 = var0_40:Find("list/level")

	if arg0_40.status == var0_0.STATUS.EMPTY then
		setText(var1_40, i18n("mall_order_finished_all_tip"))
		setActive(var2_40, false)
		setActive(var3_40, false)
	else
		local var4_40 = pg.activity_mall_custom_order[arg0_40.showId]

		if arg0_40.level < var4_40.unlock_lv then
			setText(var3_40, i18n("mall_order_unlock_lv_tip", var4_40.unlock_lv))
			setActive(var3_40, true)
		else
			setActive(var3_40, false)
		end

		local var5_40 = var4_40.unlock_time - arg0_40.activity:getDayIndex()

		if var5_40 > 0 then
			setText(var2_40:Find("Text"), i18n("mall_order_wait_tip"))
			arg0_40:StartNextTimer(var5_40)
			setActive(var2_40, true)
		else
			setActive(var2_40, false)
		end
	end
end

function var0_0.OnInitStaffItem(arg0_41, arg1_41)
	local var0_41 = MallStaffCard.New(arg1_41)

	onButton(arg0_41, var0_41._go, function()
		if arg0_41.status ~= var0_0.STATUS.PREPARE then
			return
		end

		if #arg0_41.selectedIds == arg0_41.targetNum then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mall_staff_position_full_tip"))

			return
		end

		if table.contains(arg0_41.selectedIds, var0_41.staff.id) then
			return
		end

		local var0_42, var1_42 = var0_41.staff:GetStatusInfos()

		if var0_42 == MallStaff.STATUS.ORDER then
			return
		end

		seriesAsync({
			function(arg0_43)
				if var0_42 == MallStaff.STATUS.FLOOR then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("mall_remove_floor_sure"),
						onYes = function()
							arg0_41.activity:SetFloorStaff(var1_42.floorId, var1_42.floorIdx, 0)
							MallStaffLayer.CheckUpdateFloorStaffs(arg0_41.activity, arg0_43)
						end
					})
				else
					arg0_43()
				end
			end
		}, function()
			table.insert(arg0_41.selectedIds, var0_41.staff.id)
			arg0_41:UpdateInfoPanel()
		end)
	end, SFX_PANEL)

	arg0_41.cards[arg1_41] = var0_41
end

function var0_0.OnUpdateStaffItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.cards[arg2_46]

	if not var0_46 then
		arg0_46:OnInitStaffItem(arg2_46)

		var0_46 = arg0_46.cards[arg2_46]
	end

	local var1_46 = arg0_46.staffList[arg1_46 + 1]

	var0_46:Update(var1_46, arg0_46.selectedIds)
end

function var0_0.UpdateOrderSlotTpl(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg0_47.selectedIds[arg1_47 + 1]

	setActive(arg2_47:Find("icon"), var0_47)

	if var0_47 then
		local var1_47 = arg0_47.activity:GetStaff(var0_47)

		MallStaffCard.StaticUpdateIcon(arg2_47:Find("icon"), var1_47.tid)
	end

	onButton(arg0_47, arg2_47, function()
		if arg0_47.status ~= var0_0.STATUS.PREPARE then
			return
		end

		setActive(arg0_47.uiOrderPanel, false)
		setActive(arg0_47.uiStaffPanel, true)
		arg0_47:SetTotalCount()
	end, SFX_PANEL)
end

function var0_0.SetTotalCount(arg0_49)
	table.sort(arg0_49.staffList, CompareFuncs({
		function(arg0_50)
			local var0_50, var1_50 = arg0_50:GetStatusInfos()

			return var0_50 == MallStaff.STATUS.FLOOR and 1 or 0
		end,
		function(arg0_51)
			return -arg0_51.id
		end
	}))

	if isActive(arg0_49.uiStaffPanel) then
		arg0_49.scrollCom:SetTotalCount(#arg0_49.staffList)
	end
end

function var0_0.UpdateStaffSlotTpl(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52.selectedIds[arg1_52 + 1]

	setActive(arg2_52:Find("icon"), var0_52)

	if var0_52 then
		local var1_52 = arg0_52.activity:GetStaff(var0_52)

		MallStaffCard.StaticUpdateIcon(arg2_52:Find("icon"), var1_52.tid)
	end

	onButton(arg0_52, arg2_52:Find("icon"), function()
		table.removebyvalue(arg0_52.selectedIds, var0_52)
		arg0_52:UpdateInfoPanel()
	end, SFX_PANEL)
end

function var0_0.ShowUpgradeBox(arg0_54, arg1_54, arg2_54, arg3_54)
	arg0_54.upgradeBox:ExecuteAction("Show", arg1_54, arg2_54, arg3_54)
end

function var0_0.StartTimer(arg0_55)
	arg0_55:StopTimer()

	arg0_55.endTime = arg0_55.orderData:GetEndTime()
	arg0_55.timer = Timer.New(function()
		local var0_56 = arg0_55.endTime - pg.TimeMgr.GetInstance():GetServerTime()

		setText(arg0_55.uiOrderBtnsTF:Find("time/Text"), pg.TimeMgr.GetInstance():DescCDTime(var0_56))

		if var0_56 <= 0 then
			arg0_55:UpdateData()
			arg0_55:UpdateView()
		end
	end, 1, -1)

	arg0_55.timer:Start()
	arg0_55.timer.func()
end

function var0_0.StopTimer(arg0_57)
	if arg0_57.timer then
		arg0_57.timer:Stop()

		arg0_57.timer = nil
	end
end

function var0_0.StartNextTimer(arg0_58, arg1_58)
	arg0_58:StopNextTimer()

	arg0_58.nextOrderTime = pg.TimeMgr.GetInstance():GetTimeToNextTime() + (arg1_58 - 1) * 86400
	arg0_58.nextTimer = Timer.New(function()
		local var0_59 = arg0_58.nextOrderTime - pg.TimeMgr.GetInstance():GetServerTime()

		setText(arg0_58.uiOrderPanel:Find("empty/list/time/value"), pg.TimeMgr.GetInstance():DescCDTime(var0_59))

		if var0_59 <= 0 then
			arg0_58:UpdateData()
			arg0_58:UpdateView()
		end
	end, 1, -1)

	arg0_58.nextTimer:Start()
	arg0_58.nextTimer.func()
end

function var0_0.StopNextTimer(arg0_60)
	if arg0_60.nextTimer then
		arg0_60.nextTimer:Stop()

		arg0_60.nextTimer = nil
	end
end

function var0_0.onBackPressed(arg0_61)
	if arg0_61.upgradeBox and arg0_61.upgradeBox:isShowing() then
		arg0_61.upgradeBox:ExecuteAction("Hide")

		return
	end

	var0_0.super.onBackPressed(arg0_61)
end

function var0_0.willExit(arg0_62)
	existCall(arg0_62.contextData.onExit)

	arg0_62.contextData.onExit = nil

	if arg0_62.upgradeBox then
		arg0_62.upgradeBox:Destroy()

		arg0_62.upgradeBox = nil
	end

	ClearLScrollrect(arg0_62.scrollCom)

	for iter0_62, iter1_62 in pairs(arg0_62.cards) do
		iter1_62:Dispose()
	end

	arg0_62.cards = {}

	arg0_62:StopTimer()
	arg0_62:StopNextTimer()
end

return var0_0
