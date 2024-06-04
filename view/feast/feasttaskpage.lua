local var0 = class("FeastTaskPage", import("view.base.BaseSubView"))

var0.PAGE_PT = 1
var0.PAGE_TASK = 2

function var0.getUIName(arg0)
	return "FeastTaskPage"
end

function var0.OnLoaded(arg0)
	arg0.getAllBtn = arg0:findTF("main/getall")
	arg0.getAllTip = arg0.getAllBtn:Find("tip")
	arg0.levelTxt = arg0:findTF("main/level/Text"):GetComponent(typeof(Text))
	arg0.progressTxt = arg0:findTF("main/level/value/Text"):GetComponent(typeof(Text))
	arg0.progress = arg0:findTF("main/level/progress/bar")
	arg0.lastAwardItem = arg0:findTF("main/level/item")
	arg0.lastAwardLvTxt = arg0.lastAwardItem:Find("lock/Text"):GetComponent(typeof(Text))

	setText(arg0.lastAwardItem:Find("get"), i18n("feast_task_pt_get"))
	setText(arg0.lastAwardItem:Find("got"), i18n("feast_task_pt_got"))
	setText(arg0:findTF("main/tip"), i18n("feast_click_to_close"))
	setText(arg0:findTF("main/level/value/label"), i18n("feast_task_pt_label"))

	arg0.taskTip = arg0:findTF("main/toggles/task/tip")
	arg0.toggles = {
		arg0:findTF("main/toggles/pt"),
		arg0:findTF("main/toggles/task")
	}
	arg0.scrollRects = {
		arg0:findTF("main/pt/scrollrect"):GetComponent("LScrollRect"),
		arg0:findTF("main/task/scrollrect"):GetComponent("LScrollRect")
	}
	arg0.cardCls = {
		FeastPtCard,
		FeastTaskCard
	}
	arg0.cards = {
		{},
		{}
	}
	arg0.counts = {
		0,
		0
	}

	arg0:AddListener()
end

function var0.AddListener(arg0)
	arg0:bind(FeastScene.ON_TASK_UPDATE, function(arg0)
		if arg0:isShowing() then
			arg0:GenTaskData()
			arg0:UpdateLevel()

			if arg0.page == var0.PAGE_TASK then
				arg0:SwitchPage(arg0.page)
			end
		end
	end)
	arg0:bind(FeastScene.ON_ACT_UPDATE, function(arg0)
		if arg0:isShowing() then
			arg0:GenPtData()
			arg0:UpdateLevel()

			if arg0.page == var0.PAGE_PT then
				arg0:SwitchPage(arg0.page)
			end
		end
	end)
end

function var0.OnInit(arg0)
	for iter0, iter1 in ipairs(arg0.scrollRects) do
		function iter1.onInitItem(arg0)
			arg0:OnInitItem(iter0, arg0)
		end

		function iter1.onUpdateItem(arg0, arg1)
			arg0:OnUpdateItem(iter0, arg0, arg1)
		end
	end

	for iter2, iter3 in ipairs(arg0.toggles) do
		onToggle(arg0, iter3, function(arg0)
			if arg0 then
				arg0:SwitchPage(iter2)
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.getAllBtn, function()
		if arg0.page == var0.PAGE_TASK then
			arg0:GetAllForTask()
		elseif arg0.page == var0.PAGE_PT then
			arg0:GetAllForPt()
		end
	end, SFX_PANEL)
end

function var0.UpdateGetAllTip(arg0, arg1)
	local var0 = getProxy(FeastProxy)
	local var1 = false

	if arg1 == var0.PAGE_PT then
		var1 = var0:ShouldTipPt()
	elseif arg1 == var0.PAGE_TASK then
		var1 = var0:ShouldTipFeastTask()
	end

	setActive(arg0.getAllTip, var1)
	setActive(arg0.taskTip, var0:ShouldTipFeastTask())
end

function var0.GetAllForTask(arg0)
	local var0 = {}
	local var1 = getProxy(TaskProxy)

	for iter0, iter1 in ipairs(arg0.taskList) do
		local var2 = var1:getTaskById(iter1)

		if var2 and var2:isFinish() and not var2:isReceive() then
			table.insert(var0, var2)
		end
	end

	if #var0 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("faest_nothing_to_get"))

		return
	end

	arg0:emit(FeastMediator.ON_SUBMIT_ONE_KEY, var0)
end

function var0.GetAllForPt(arg0)
	if not arg0.ptActData:CanGetAward() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("faest_nothing_to_get"))

		return
	end

	local var0 = arg0.ptActData:GetCurrTarget()

	arg0:emit(FeastMediator.EVENT_PT_OPERATION, {
		cmd = 4,
		activity_id = arg0.ptActData:GetId(),
		arg1 = var0
	})
end

function var0.SwitchPage(arg0, arg1)
	local var0 = arg0.counts[arg1] or 0

	arg0.scrollRects[arg1]:SetTotalCount(var0)

	arg0.page = arg1

	arg0:UpdateGetAllTip(arg1)
	arg0:UpdateLevel()
end

function var0.UpdateLevel(arg0)
	local var0 = arg0.ptActData:GetCurrLevel()

	arg0.levelTxt.text = var0

	local var1 = 0
	local var2 = 0

	if not arg0.ptActData:IsMaxLevel() then
		local var3 = arg0.ptActData:GetPtTarget(var0)

		var1, var2 = arg0.ptActData.count, arg0.ptActData:GetNextLevelTarget()
		var1 = var1 - var3
		var2 = var2 - var3
		var1 = math.min(var1, var2)
		arg0.progressTxt.text = var1 .. "/" .. var2
	else
		var1, var2 = 1, 1
		arg0.progressTxt.text = "MAX"
	end

	setFillAmount(arg0.progress, var1 / var2)

	local var4 = arg0.page == var0.PAGE_PT

	setActive(arg0.lastAwardItem, var4)

	if var4 then
		arg0:UpdateLastAward()
	end
end

function var0.UpdateLastAward(arg0)
	local var0 = arg0.lastAwardItem:Find("award")
	local var1 = arg0.ptActData:GetLastAward()

	updateDrop(var0, var1)

	local var2 = arg0.ptActData.targets
	local var3 = arg0.ptActData:GetDroptItemState(#var2)

	arg0.lastAwardLvTxt.text = i18n("feast_task_pt_level", #var2)

	setActive(arg0.lastAwardItem:Find("lock"), var3 == ActivityPtData.STATE_LOCK)
	setActive(arg0.lastAwardItem:Find("get"), var3 == ActivityPtData.STATE_CAN_GET)
	setActive(arg0.lastAwardItem:Find("got"), var3 == ActivityPtData.STATE_GOT)
	onButton(arg0, var0, function()
		if var3 == ActivityPtData.STATE_CAN_GET then
			local var0 = arg0.ptActData:GetPtTarget(#var2)

			arg0:emit(FeastMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptActData:GetId(),
				arg1 = var0
			})
		else
			arg0:emit(BaseUI.ON_DROP, var1)
		end
	end, SFX_PANEL)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:GenPtData()
	arg0:GenTaskData()
	triggerToggle(arg0.toggles[var0.PAGE_PT], true)
end

function var0.GenPtData(arg0)
	arg0.ptActData = getProxy(FeastProxy):GetPtActData()
	arg0.counts[var0.PAGE_PT] = #arg0.ptActData.targets
end

function var0.GenTaskData(arg0)
	arg0.taskList = getProxy(FeastProxy):GetTaskList()

	local var0 = getProxy(TaskProxy)

	table.sort(arg0.taskList, function(arg0, arg1)
		local var0 = var0:getTaskById(arg0) or var0:getFinishTaskById(arg0)
		local var1 = var0:getTaskById(arg1) or var0:getFinishTaskById(arg1)
		local var2 = var0:isReceive() and 1 or 0
		local var3 = var1:isReceive() and 1 or 0

		if var2 == var3 then
			local var4 = var0:IsActRoutineType() and 1 or 0
			local var5 = var1:IsActRoutineType() and 1 or 0

			if var4 == var5 then
				return arg0 < arg1
			else
				return var5 < var4
			end
		else
			return var2 < var3
		end
	end)

	arg0.counts[var0.PAGE_TASK] = #arg0.taskList
end

function var0.OnInitItem(arg0, arg1, arg2)
	local var0 = arg0.cardCls[arg1].New(arg2, arg0)

	arg0.cards[arg1][arg2] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2, arg3)
	local var0 = arg0.cards[arg1][arg3]

	if not var0 then
		arg0:OnInitItem(arg1, arg3)

		var0 = arg0.cards[arg1][arg3]
	end

	local var1

	if arg1 == var0.PAGE_PT then
		var1 = arg0.ptActData
	elseif arg1 == var0.PAGE_TASK then
		var1 = arg0.taskList[arg2 + 1]
	end

	var0:Flush(var1, arg2 + 1)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
