local var0_0 = class("AuctionGameTaskScene", import("view.base.BaseUI"))

var0_0.TASK_TYPE = {
	DAILY = 1,
	CHALLENGE = 2
}

function var0_0.getUIName(arg0_1)
	return "AuctionGameTaskUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	setText(arg0_2.uiGetAllText, i18n("auction_signin_collect"))
	onButton(arg0_2, arg0_2.uiGetAllBtn, function()
		local var0_4 = {}

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			for iter0_4, iter1_4 in ipairs(arg0_2.dailyTaskList) do
				if iter1_4:getTaskStatus() == 1 then
					table.insert(var0_4, iter1_4.id)
				end
			end

			for iter2_4, iter3_4 in ipairs(arg0_2.challengeTaskList) do
				if iter3_4:getTaskStatus() == 1 then
					table.insert(var0_4, iter3_4.id)
				end
			end
		else
			for iter4_4, iter5_4 in ipairs(arg0_2.taskList) do
				if iter5_4:getTaskStatus() == 1 then
					table.insert(var0_4, iter5_4.id)
				end
			end
		end

		if #var0_4 <= 0 then
			return
		end

		arg0_2:emit(AuctionGameTaskMediator.ON_ACTIVITY_TASK_SUBMIT_ONESTEP, arg0_2.taskActivityID, var0_4)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiDailyBtn, function()
		arg0_2:OnSwitchBtn(var0_0.TASK_TYPE.DAILY)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiChallengeBtn, function()
		arg0_2:OnSwitchBtn(var0_0.TASK_TYPE.CHALLENGE)
	end, SFX_PANEL)
	setText(arg0_2.uiDailyText, i18n("auction_task_daily"))
	setText(arg0_2.uiChallengeText, i18n("auction_task_challenge"))

	arg0_2.itemList = {}
	arg0_2.uiLScroll = GetComponent(arg0_2.uiScroll, "LScrollRect")
	arg0_2.onInitItemHandler = handler(arg0_2, arg0_2.OnInitItem)
	arg0_2.onUpdateItemHandler = handler(arg0_2, arg0_2.OnUpdateItem)
	arg0_2.uiLScroll.onInitItem = arg0_2.onInitItemHandler
	arg0_2.uiLScroll.onUpdateItem = arg0_2.onUpdateItemHandler
end

function var0_0.didEnter(arg0_7)
	arg0_7:OverlayPanel(arg0_7._tf, {})
	setPaintingPrefabAsync(arg0_7.uiPaintingTf, pg.ship_skin_template[900284].painting, "chuanwu", nil, {
		skinID = 900284
	})
	arg0_7:OnSwitchBtn(var0_0.TASK_TYPE.DAILY)
end

function var0_0.willExit(arg0_8)
	arg0_8:UnOverlayPanel(arg0_8._tf)
	retPaintingPrefab(arg0_8.uiPaintingTf, pg.ship_skin_template[900284].painting)

	arg0_8.uiLScroll.onInitItem = nil
	arg0_8.uiLScroll.onUpdateItem = nil
	arg0_8.onInitItemHandler = nil
	arg0_8.onUpdateItemHandler = nil
end

function var0_0.OnSwitchBtn(arg0_9, arg1_9)
	if arg1_9 == var0_0.TASK_TYPE.DAILY then
		setTextColor(arg0_9.uiDailyText, Color.NewHex("#FFFFFF"))
		setTextColor(arg0_9.uiChallengeText, Color.NewHex("#393A3C"))
		setActive(arg0_9.uiDailySelectedGo, true)
		setActive(arg0_9.uiChallengeSelectedGo, false)
	else
		setTextColor(arg0_9.uiDailyText, Color.NewHex("#393A3C"))
		setTextColor(arg0_9.uiChallengeText, Color.NewHex("#FFFFFF"))
		setActive(arg0_9.uiDailySelectedGo, false)
		setActive(arg0_9.uiChallengeSelectedGo, true)
	end

	arg0_9.selectedType = arg1_9

	arg0_9:RefreshUI()
end

function var0_0.GetTaskList(arg0_10)
	local var0_10 = {}
	local var1_10 = {}
	local var2_10 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").taskActID
	local var3_10 = pg.activity_template[var2_10].config_data

	arg0_10.taskActivityID = var2_10

	local var4_10 = getProxy(TaskProxy)

	for iter0_10, iter1_10 in ipairs(var3_10) do
		local var5_10 = var4_10:getTaskVO(iter1_10) or Task.New({
			id = iter1_10
		})

		if var5_10:IsActRoutineType() then
			table.insert(var0_10, var5_10)
		else
			table.insert(var1_10, var5_10)
		end
	end

	return var0_10, var1_10
end

function var0_0.RefreshUI(arg0_11)
	arg0_11.dailyTaskList, arg0_11.challengeTaskList = arg0_11:GetTaskList()

	if arg0_11.selectedType == var0_0.TASK_TYPE.DAILY then
		arg0_11.taskList = arg0_11.dailyTaskList

		setGray(arg0_11.uiGetAllBtn, not arg0_11:IsDailyTip())
	else
		arg0_11.taskList = arg0_11.challengeTaskList

		setGray(arg0_11.uiGetAllBtn, not arg0_11:IsChallengeTip())
	end

	arg0_11:Sort(arg0_11.taskList)
	arg0_11.uiLScroll:SetTotalCount(#arg0_11.taskList)
	setActive(arg0_11.uiDailyTipGo, arg0_11:IsDailyTip())
	setActive(arg0_11.uiChallengeTipGo, arg0_11:IsChallengeTip())
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	arg0_12.itemList[arg1_12] = AuctionGameTaskItem.New(tf(arg1_12), arg0_12)
end

function var0_0.OnUpdateItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.itemList[arg2_13]

	if var0_13 == nil then
		arg0_13:OnInitItem(arg2_13)

		var0_13 = arg0_13.itemList[arg2_13]
	end

	local var1_13 = arg0_13.taskList[arg1_13 + 1]

	var0_13:SetData(var1_13)
end

function var0_0.Sort(arg0_14)
	local function var0_14(arg0_15, arg1_15, arg2_15)
		local function var0_15(arg0_16)
			for iter0_16, iter1_16 in ipairs(arg2_15) do
				if arg0_16 == iter1_16 then
					return iter0_16
				end
			end
		end

		return var0_15(arg0_15) < var0_15(arg1_15)
	end

	table.sort(arg0_14.taskList, function(arg0_17, arg1_17)
		local var0_17 = arg0_17:getTaskStatus()
		local var1_17 = arg1_17:getTaskStatus()

		if var0_17 == var1_17 then
			return arg0_17.id < arg1_17.id
		end

		return var0_14(var0_17, var1_17, {
			1,
			0,
			2,
			-1
		})
	end)
end

function var0_0.IsDailyTip(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.dailyTaskList) do
		if iter1_18:getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

function var0_0.IsChallengeTip(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.challengeTaskList) do
		if iter1_19:getTaskStatus() == 1 then
			return true
		end
	end

	return false
end

return var0_0
