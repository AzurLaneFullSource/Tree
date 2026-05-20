local var0_0 = class("MallScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MallUI"
end

function var0_0.init(arg0_2)
	arg0_2.animDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.animDft:SetEndEvent(function(arg0_3)
		var0_0.super.onBackPressed(arg0_2)
	end)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:onBackPressed()
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
	onButton(arg0_2, arg0_2.uiMapBtn, function()
		arg0_2:emit(MallMediator.CHANGE_SCENE, SCENE.MALL_MAP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiBookBtn, function()
		arg0_2:emit(MallMediator.GO_SUBLAYER, Context.New({
			mediator = MallStoryLineMediator,
			viewComponent = MallStoryLineLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiOrderBtn, function()
		arg0_2:emit(MallMediator.GO_SUBLAYER, Context.New({
			mediator = MallOrderMediator,
			viewComponent = MallOrderLayer,
			data = {
				onExit = function()
					arg0_2:UpdateData()
					arg0_2:UpdateView()
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSummaryBtn, function()
		arg0_2:ShowSummaryBox()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiAwardBtn, function()
		arg0_2:emit(MallMediator.GO_SUBLAYER, Context.New({
			mediator = MallAwardMediator,
			viewComponent = MallAwardLayer,
			data = {
				onExit = function()
					arg0_2:UpdateData()
					arg0_2:UpdateView()
				end
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiRightUpgradeBtn, function()
		setActive(arg0_2.uiRightUpgradeTF, true)
		setActive(arg0_2.uiRightSummaryTF, false)
		setText(arg0_2.uiRightTitleText, i18n("mall_right_title_summary"))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiRightSummaryBtn, function()
		setActive(arg0_2.uiRightSummaryTF, true)
		setActive(arg0_2.uiRightUpgradeTF, false)
		setText(arg0_2.uiRightTitleText, i18n("mall_right_title_upgrade"))
	end, SFX_PANEL)

	arg0_2.upgradeUIList = UIItemList.New(arg0_2.uiUpgradeConditionTF, arg0_2.uiUpgradeConditionTF:Find("tpl"))

	arg0_2.upgradeUIList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg0_2:UpdateConditionTpl(arg1_16, arg2_16)
		end
	end)

	arg0_2.upgradeBox = MallUpgradeBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.settleBox = MallSettleBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.summaryBox = MallSummaryBox.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)

	setText(arg0_2.uiTitleText, i18n("mall_title"))
	setText(arg0_2.uiTitleEnText, i18n("mall_title_en"))
	setText(arg0_2.uiRoundHeaderText, i18n("mall_round_header"))
	setText(arg0_2.uiLevelHeaderText, i18n("mall_level_header"))
	setText(arg0_2.uiRightUpgradeTF:Find("max/Text"), i18n("mall_level_max"))
end

function var0_0.didEnter(arg0_17)
	arg0_17:UpdateData()
	arg0_17:UpdateView()
	triggerButton(arg0_17.uiRightSummaryBtn)
end

function var0_0.UpdateData(arg0_18)
	arg0_18.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	assert(arg0_18.activity and not arg0_18.activity:isEnd(), "not exist mall act, type: " .. ActivityConst.ACTIVITY_TYPE_MALL)

	arg0_18.levelDate = arg0_18.activity:GetLevelData()
	arg0_18.conditionList = arg0_18.levelDate:getConfig("upgrade_task")
	arg0_18.conditionDescList = arg0_18.levelDate:getConfig("upgrade_task_desc")

	local var0_18 = getProxy(ActivityProxy):getActivityById(arg0_18.activity:getConfig("config_id"))
	local var1_18 = ActivityPtData.New(var0_18)

	arg0_18.curPt = var1_18.count
	arg0_18.ptTargets = var1_18.targets
	arg0_18.ptUnlockStamps = var1_18:GetDayUnlockStamps()
end

function var0_0.UpdateView(arg0_19)
	setText(arg0_19.uiGoldText, arg0_19.activity:GetGold())
	setText(arg0_19.uiRoundText, arg0_19.activity:GetRound())
	setText(arg0_19.uiLevelText, arg0_19.levelDate.level)

	local var0_19 = arg0_19.levelDate:IsMaxLevel()

	setActive(arg0_19.uiRightUpgradeTF:Find("conditions"), not var0_19)
	setActive(arg0_19.uiRightUpgradeTF:Find("max"), var0_19)
	arg0_19.upgradeUIList:align(var0_19 and 0 or #arg0_19.conditionList)
	arg0_19:UpdateFloors()
	arg0_19:UpdateOrderBtn()
	arg0_19:UpdateTips()
	arg0_19:UpdateStartBtn()
end

function var0_0.UpdateOrderBtn(arg0_20)
	setActive(arg0_20.uiOrderTimeTF, false)

	arg0_20.orderData = arg0_20.activity:GetOrderData()

	if arg0_20.orderData.id ~= 0 then
		if pg.TimeMgr.GetInstance():GetServerTime() < arg0_20.orderData:GetEndTime() then
			setActive(arg0_20.uiOrderTimeTF, true)
			arg0_20:StartTimer()
		end
	else
		arg0_20:StopTimer()
	end
end

function var0_0.UpdateTips(arg0_21)
	setActive(arg0_21.uiAwardTip, var0_0.IsAwardTip())
	setActive(arg0_21.uiOrderTip, var0_0.IsOrderTip())
	setActive(arg0_21.uiMapTip, var0_0.IsMapTip())
end

function var0_0.UpdateStartBtn(arg0_22)
	local var0_22 = false

	for iter0_22, iter1_22 in ipairs(arg0_22.activity:GetFloorList()) do
		if iter1_22:IsUnlock() and iter1_22:GetStaffList()[1] ~= 0 then
			var0_22 = false

			break
		end

		var0_22 = true
	end

	if var0_22 then
		setActive(arg0_22.uiStartBtn, false)
		setActive(arg0_22.uiStartGreyBtn, true)
		onButton(arg0_22, arg0_22.uiStartGreyBtn, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("mall_floor_all_empty_tip"))
		end, SFX_PANEL)

		return
	end

	local var1_22, var2_22, var3_22 = (function()
		local var0_24 = pg.TimeMgr.GetInstance()

		for iter0_24, iter1_24 in ipairs(arg0_22.ptTargets) do
			local var1_24 = arg0_22.ptUnlockStamps[iter0_24]

			if var1_24 and var1_24 > var0_24:GetServerTime() then
				local var2_24 = var0_24:STimeDescS(var1_24, "%m")
				local var3_24 = var0_24:STimeDescS(var1_24, "%d")

				return iter0_24, var2_24, var3_24
			end
		end

		return nil
	end)()
	local var4_22 = var1_22 and var1_22 - 1 or #arg0_22.ptTargets
	local var5_22 = arg0_22.ptTargets[var4_22] <= arg0_22.curPt + arg0_22.activity:GetGold()

	setActive(arg0_22.uiStartBtn, not var5_22 or not var1_22)
	onButton(arg0_22, arg0_22.uiStartBtn, function()
		if var5_22 and var1_22 then
			return
		end

		arg0_22:emit(MallMediator.SETTLE_ROUND, arg0_22.activity.id)
	end, SFX_PANEL)
	setActive(arg0_22.uiStartGreyBtn, var5_22 and var1_22)
	onButton(arg0_22, arg0_22.uiStartGreyBtn, function()
		if not var5_22 then
			return
		end

		if var1_22 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mall_unlock_date_tip", var2_22, var3_22))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("mall_finished_all_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.UpdateConditionTpl(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.conditionList[arg1_27 + 1][1]
	local var1_27 = arg0_27.conditionList[arg1_27 + 1][2]
	local var2_27 = 0
	local var3_27 = 0
	local var4_27 = arg0_27.conditionDescList[arg1_27 + 1]

	switch(var0_27, {
		[MallLevel.CONDITION_TYPE.ROUND] = function()
			var2_27 = arg0_27.activity:GetRound()
			var3_27 = var1_27[1]
		end,
		[MallLevel.CONDITION_TYPE.ORDER] = function()
			var2_27 = #arg0_27.activity:GetOrderData():GetFinishedList()
			var3_27 = var1_27[1]
		end,
		[MallLevel.CONDITION_TYPE.ROUND_INCOME] = function()
			var2_27 = arg0_27.activity:GetLastIncome()
			var3_27 = var1_27[1]
		end,
		[MallLevel.CONDITION_TYPE.FLOOR_INCOME] = function()
			var2_27 = arg0_27.activity:GetFloorData()[var1_27[1]]:GetLastIncome()
			var3_27 = var1_27[2]
		end
	})

	local var5_27 = var3_27 <= var2_27

	setActive(arg2_27:Find("unfinished"), not var5_27)
	setActive(arg2_27:Find("finished"), var5_27)

	local var6_27 = var5_27 and var2_27 or setColorStr(var2_27, "#bd5d4a")
	local var7_27 = string.gsub(var4_27, "$1", var6_27)
	local var8_27 = string.gsub(var7_27, "$2", var3_27)

	setText(arg2_27:Find("Text"), var8_27)
end

function var0_0.UpdateFloors(arg0_32)
	eachChild(arg0_32.uiFloorsTF, function(arg0_33)
		local var0_33 = tonumber(arg0_33.name)

		arg0_32:UpdateFloorTpl(var0_33, arg0_33)
	end)
end

function var0_0.UpdateFloorTpl(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.activity:GetFloor(arg1_34)
	local var1_34 = var0_34:IsUnlock()

	setActive(arg2_34:Find("lock"), not var1_34)

	if arg2_34:Find("sign") then
		setActive(arg2_34:Find("sign"), var1_34)
	end

	local var2_34 = var0_34:GetStaffList()
	local var3_34 = underscore.reduce(var2_34, 0, function(arg0_35, arg1_35)
		return arg0_35 + (arg1_35 ~= 0 and 1 or 0)
	end)

	setActive(arg2_34:Find("bg"), var3_34 ~= 0)
	setActive(arg2_34:Find("empty"), var3_34 == 0)
	setText(arg2_34:Find("rank/Text"), var3_34 .. "/" .. #var2_34)

	local var4_34 = {}

	for iter0_34, iter1_34 in ipairs(var0_34:GetTargetInfos(arg0_34.levelDate.level)) do
		table.insert(var4_34, {
			cur = 0,
			id = iter0_34,
			base = iter1_34[1],
			max = iter1_34[2]
		})
	end

	for iter2_34, iter3_34 in ipairs(var2_34) do
		if iter3_34 ~= 0 then
			local var5_34 = arg0_34.activity:GetStaff(iter3_34)

			for iter4_34, iter5_34 in ipairs(var5_34:GetAttrList()) do
				var4_34[iter4_34].cur = var4_34[iter4_34].cur + iter5_34
			end
		end
	end

	local var6_34 = underscore.select(var4_34, function(arg0_36)
		return arg0_36.base ~= 0 and arg0_36.max ~= 0
	end)
	local var7_34 = underscore.reduce(var6_34, 0, function(arg0_37, arg1_37)
		return arg0_37 + arg1_37.cur
	end)
	local var8_34 = underscore.reduce(var6_34, 0, function(arg0_38, arg1_38)
		return arg0_38 + arg1_38.base
	end)
	local var9_34 = MallUtil.GetFloorRank(var7_34, var8_34)

	GetImageSpriteFromAtlasAsync("ui/mallui_atlas", "rank_" .. var9_34, arg2_34:Find("rank"), true)
	onButton(arg0_34, arg2_34, function()
		if not var1_34 then
			return
		end

		arg0_34:emit(MallMediator.GO_SUBLAYER, Context.New({
			mediator = MallStaffMediator,
			viewComponent = MallStaffLayer,
			data = {
				floorId = var0_34.id
			}
		}))
	end, SFX_PANEL)
end

function var0_0.StartTimer(arg0_40)
	arg0_40:StopTimer()

	arg0_40.orderEndTime = arg0_40.orderData:GetEndTime()
	arg0_40.timer = Timer.New(function()
		local var0_41 = arg0_40.orderEndTime - pg.TimeMgr.GetInstance():GetServerTime()

		setText(arg0_40.uiOrderTimeTF:Find("Text"), pg.TimeMgr.GetInstance():DescCDTime(var0_41))

		if var0_41 <= 0 then
			arg0_40:UpdateOrderBtn()
			setActive(arg0_40.uiOrderTip, true)
		end
	end, 1, -1)

	arg0_40.timer:Start()
	arg0_40.timer.func()
end

function var0_0.StopTimer(arg0_42)
	if arg0_42.timer then
		arg0_42.timer:Stop()

		arg0_42.timer = nil
	end
end

function var0_0.ShowUpgradeBox(arg0_43, arg1_43, arg2_43, arg3_43)
	arg0_43.upgradeBox:ExecuteAction("Show", arg1_43, arg2_43, arg3_43)
end

function var0_0.ShowSettleBox(arg0_44, arg1_44, arg2_44)
	arg0_44.settleBox:ExecuteAction("Show", arg1_44, arg2_44)
end

function var0_0.ShowSummaryBox(arg0_45)
	arg0_45.summaryBox:ExecuteAction("Show")
end

function var0_0.onBackPressed(arg0_46)
	if arg0_46.upgradeBox and arg0_46.upgradeBox:isShowing() then
		arg0_46.upgradeBox:ExecuteAction("Hide")

		return
	end

	if arg0_46.summaryBox and arg0_46.summaryBox:isShowing() then
		arg0_46.summaryBox:ExecuteAction("Hide")

		return
	end

	if arg0_46.settleBox and arg0_46.settleBox:isShowing() then
		arg0_46.settleBox:ExecuteAction("Hide")

		return
	end

	quickPlayAnimation(arg0_46._tf, "anim_MallUI_out")
end

function var0_0.willExit(arg0_47)
	arg0_47.animDft:SetEndEvent(nil)

	if arg0_47.upgradeBox then
		arg0_47.upgradeBox:Destroy()

		arg0_47.upgradeBox = nil
	end

	if arg0_47.settleBox then
		arg0_47.settleBox:Destroy()

		arg0_47.settleBox = nil
	end

	if arg0_47.summaryBox then
		arg0_47.summaryBox:Destroy()

		arg0_47.summaryBox = nil
	end

	arg0_47:StopTimer()
end

function var0_0.IsAwardTip()
	return MallAwardLayer.IsAwardTip() or MallAwardLayer.IsInputTip() or MallAwardLayer.IsTaskTip()
end

function var0_0.IsOrderTip()
	local var0_49 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	local var1_49 = var0_49:GetOrderData()

	if var1_49:IsFinishedAll() then
		return false
	end

	local var2_49 = var1_49:GetFinishedList()
	local var3_49 = underscore.detect(pg.activity_mall_custom_order.all, function(arg0_50)
		return not table.contains(var2_49, arg0_50)
	end)
	local var4_49 = pg.activity_mall_custom_order[var3_49]

	if not (var0_49:GetLevelData().level >= var4_49.unlock_lv and var0_49:getDayIndex() >= var4_49.unlock_time) then
		var3_49 = 0
	end

	return var3_49 ~= 0 and (var1_49.startTime == 0 or pg.TimeMgr.GetInstance():GetServerTime() >= var1_49:GetEndTime())
end

function var0_0.IsMapTip()
	local var0_51 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	local var1_51 = var0_51:GetTriggeredPointIds()
	local var2_51 = var0_51:GetLevelData():GetUnlockStoryIds()

	return #underscore.select(var2_51, function(arg0_52)
		local var0_52 = pg.activity_mall_story[arg0_52]
		local var1_52 = var0_52.type ~= MallActivity.POINT_TYPE.SITE

		return not table.contains(var1_51, arg0_52) or var1_52 and var0_52.lua ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_52.lua)
	end) > 0
end

return var0_0
