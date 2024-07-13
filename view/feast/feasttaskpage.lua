local var0_0 = class("FeastTaskPage", import("view.base.BaseSubView"))

var0_0.PAGE_PT = 1
var0_0.PAGE_TASK = 2

function var0_0.getUIName(arg0_1)
	return "FeastTaskPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.getAllBtn = arg0_2:findTF("main/getall")
	arg0_2.getAllTip = arg0_2.getAllBtn:Find("tip")
	arg0_2.levelTxt = arg0_2:findTF("main/level/Text"):GetComponent(typeof(Text))
	arg0_2.progressTxt = arg0_2:findTF("main/level/value/Text"):GetComponent(typeof(Text))
	arg0_2.progress = arg0_2:findTF("main/level/progress/bar")
	arg0_2.lastAwardItem = arg0_2:findTF("main/level/item")
	arg0_2.lastAwardLvTxt = arg0_2.lastAwardItem:Find("lock/Text"):GetComponent(typeof(Text))

	setText(arg0_2.lastAwardItem:Find("get"), i18n("feast_task_pt_get"))
	setText(arg0_2.lastAwardItem:Find("got"), i18n("feast_task_pt_got"))
	setText(arg0_2:findTF("main/tip"), i18n("feast_click_to_close"))
	setText(arg0_2:findTF("main/level/value/label"), i18n("feast_task_pt_label"))

	arg0_2.taskTip = arg0_2:findTF("main/toggles/task/tip")
	arg0_2.toggles = {
		arg0_2:findTF("main/toggles/pt"),
		arg0_2:findTF("main/toggles/task")
	}
	arg0_2.scrollRects = {
		arg0_2:findTF("main/pt/scrollrect"):GetComponent("LScrollRect"),
		arg0_2:findTF("main/task/scrollrect"):GetComponent("LScrollRect")
	}
	arg0_2.cardCls = {
		FeastPtCard,
		FeastTaskCard
	}
	arg0_2.cards = {
		{},
		{}
	}
	arg0_2.counts = {
		0,
		0
	}

	arg0_2:AddListener()
end

function var0_0.AddListener(arg0_3)
	arg0_3:bind(FeastScene.ON_TASK_UPDATE, function(arg0_4)
		if arg0_3:isShowing() then
			arg0_3:GenTaskData()
			arg0_3:UpdateLevel()

			if arg0_3.page == var0_0.PAGE_TASK then
				arg0_3:SwitchPage(arg0_3.page)
			end
		end
	end)
	arg0_3:bind(FeastScene.ON_ACT_UPDATE, function(arg0_5)
		if arg0_3:isShowing() then
			arg0_3:GenPtData()
			arg0_3:UpdateLevel()

			if arg0_3.page == var0_0.PAGE_PT then
				arg0_3:SwitchPage(arg0_3.page)
			end
		end
	end)
end

function var0_0.OnInit(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.scrollRects) do
		function iter1_6.onInitItem(arg0_7)
			arg0_6:OnInitItem(iter0_6, arg0_7)
		end

		function iter1_6.onUpdateItem(arg0_8, arg1_8)
			arg0_6:OnUpdateItem(iter0_6, arg0_8, arg1_8)
		end
	end

	for iter2_6, iter3_6 in ipairs(arg0_6.toggles) do
		onToggle(arg0_6, iter3_6, function(arg0_9)
			if arg0_9 then
				arg0_6:SwitchPage(iter2_6)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.getAllBtn, function()
		if arg0_6.page == var0_0.PAGE_TASK then
			arg0_6:GetAllForTask()
		elseif arg0_6.page == var0_0.PAGE_PT then
			arg0_6:GetAllForPt()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateGetAllTip(arg0_12, arg1_12)
	local var0_12 = getProxy(FeastProxy)
	local var1_12 = false

	if arg1_12 == var0_0.PAGE_PT then
		var1_12 = var0_12:ShouldTipPt()
	elseif arg1_12 == var0_0.PAGE_TASK then
		var1_12 = var0_12:ShouldTipFeastTask()
	end

	setActive(arg0_12.getAllTip, var1_12)
	setActive(arg0_12.taskTip, var0_12:ShouldTipFeastTask())
end

function var0_0.GetAllForTask(arg0_13)
	local var0_13 = {}
	local var1_13 = getProxy(TaskProxy)

	for iter0_13, iter1_13 in ipairs(arg0_13.taskList) do
		local var2_13 = var1_13:getTaskById(iter1_13)

		if var2_13 and var2_13:isFinish() and not var2_13:isReceive() then
			table.insert(var0_13, var2_13)
		end
	end

	if #var0_13 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("faest_nothing_to_get"))

		return
	end

	arg0_13:emit(FeastMediator.ON_SUBMIT_ONE_KEY, var0_13)
end

function var0_0.GetAllForPt(arg0_14)
	if not arg0_14.ptActData:CanGetAward() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("faest_nothing_to_get"))

		return
	end

	local var0_14 = arg0_14.ptActData:GetCurrTarget()

	arg0_14:emit(FeastMediator.EVENT_PT_OPERATION, {
		cmd = 4,
		activity_id = arg0_14.ptActData:GetId(),
		arg1 = var0_14
	})
end

function var0_0.SwitchPage(arg0_15, arg1_15)
	local var0_15 = arg0_15.counts[arg1_15] or 0

	arg0_15.scrollRects[arg1_15]:SetTotalCount(var0_15)

	arg0_15.page = arg1_15

	arg0_15:UpdateGetAllTip(arg1_15)
	arg0_15:UpdateLevel()
end

function var0_0.UpdateLevel(arg0_16)
	local var0_16 = arg0_16.ptActData:GetCurrLevel()

	arg0_16.levelTxt.text = var0_16

	local var1_16 = 0
	local var2_16 = 0

	if not arg0_16.ptActData:IsMaxLevel() then
		local var3_16 = arg0_16.ptActData:GetPtTarget(var0_16)

		var1_16, var2_16 = arg0_16.ptActData.count, arg0_16.ptActData:GetNextLevelTarget()
		var1_16 = var1_16 - var3_16
		var2_16 = var2_16 - var3_16
		var1_16 = math.min(var1_16, var2_16)
		arg0_16.progressTxt.text = var1_16 .. "/" .. var2_16
	else
		var1_16, var2_16 = 1, 1
		arg0_16.progressTxt.text = "MAX"
	end

	setFillAmount(arg0_16.progress, var1_16 / var2_16)

	local var4_16 = arg0_16.page == var0_0.PAGE_PT

	setActive(arg0_16.lastAwardItem, var4_16)

	if var4_16 then
		arg0_16:UpdateLastAward()
	end
end

function var0_0.UpdateLastAward(arg0_17)
	local var0_17 = arg0_17.lastAwardItem:Find("award")
	local var1_17 = arg0_17.ptActData:GetLastAward()

	updateDrop(var0_17, var1_17)

	local var2_17 = arg0_17.ptActData.targets
	local var3_17 = arg0_17.ptActData:GetDroptItemState(#var2_17)

	arg0_17.lastAwardLvTxt.text = i18n("feast_task_pt_level", #var2_17)

	setActive(arg0_17.lastAwardItem:Find("lock"), var3_17 == ActivityPtData.STATE_LOCK)
	setActive(arg0_17.lastAwardItem:Find("get"), var3_17 == ActivityPtData.STATE_CAN_GET)
	setActive(arg0_17.lastAwardItem:Find("got"), var3_17 == ActivityPtData.STATE_GOT)
	onButton(arg0_17, var0_17, function()
		if var3_17 == ActivityPtData.STATE_CAN_GET then
			local var0_18 = arg0_17.ptActData:GetPtTarget(#var2_17)

			arg0_17:emit(FeastMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_17.ptActData:GetId(),
				arg1 = var0_18
			})
		else
			arg0_17:emit(BaseUI.ON_DROP, var1_17)
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_19)
	var0_0.super.Show(arg0_19)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19._tf)
	arg0_19:GenPtData()
	arg0_19:GenTaskData()
	triggerToggle(arg0_19.toggles[var0_0.PAGE_PT], true)
end

function var0_0.GenPtData(arg0_20)
	arg0_20.ptActData = getProxy(FeastProxy):GetPtActData()
	arg0_20.counts[var0_0.PAGE_PT] = #arg0_20.ptActData.targets
end

function var0_0.GenTaskData(arg0_21)
	arg0_21.taskList = getProxy(FeastProxy):GetTaskList()

	local var0_21 = getProxy(TaskProxy)

	table.sort(arg0_21.taskList, function(arg0_22, arg1_22)
		local var0_22 = var0_21:getTaskById(arg0_22) or var0_21:getFinishTaskById(arg0_22)
		local var1_22 = var0_21:getTaskById(arg1_22) or var0_21:getFinishTaskById(arg1_22)
		local var2_22 = var0_22:isReceive() and 1 or 0
		local var3_22 = var1_22:isReceive() and 1 or 0

		if var2_22 == var3_22 then
			local var4_22 = var0_22:IsActRoutineType() and 1 or 0
			local var5_22 = var1_22:IsActRoutineType() and 1 or 0

			if var4_22 == var5_22 then
				return arg0_22 < arg1_22
			else
				return var5_22 < var4_22
			end
		else
			return var2_22 < var3_22
		end
	end)

	arg0_21.counts[var0_0.PAGE_TASK] = #arg0_21.taskList
end

function var0_0.OnInitItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.cardCls[arg1_23].New(arg2_23, arg0_23)

	arg0_23.cards[arg1_23][arg2_23] = var0_23
end

function var0_0.OnUpdateItem(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg0_24.cards[arg1_24][arg3_24]

	if not var0_24 then
		arg0_24:OnInitItem(arg1_24, arg3_24)

		var0_24 = arg0_24.cards[arg1_24][arg3_24]
	end

	local var1_24

	if arg1_24 == var0_0.PAGE_PT then
		var1_24 = arg0_24.ptActData
	elseif arg1_24 == var0_0.PAGE_TASK then
		var1_24 = arg0_24.taskList[arg2_24 + 1]
	end

	var0_24:Flush(var1_24, arg2_24 + 1)
end

function var0_0.Hide(arg0_25)
	var0_0.super.Hide(arg0_25)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_25._tf, arg0_25._parentTf)
end

function var0_0.OnDestroy(arg0_26)
	if arg0_26:isShowing() then
		arg0_26:Hide()
	end
end

return var0_0
