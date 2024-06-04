local var0 = class("TaskWeekPage", import(".TaskCommonPage"))

var0.WEEK_TASK_TYPE_COMMON = 1
var0.WEEK_TASK_TYPE_PT = 2

function var0.getUIName(arg0)
	return "TaskListForWeekPage"
end

function var0.RefreshWeekProgress(arg0)
	arg0:UpdateWeekProgress(arg0.contextData.weekTaskProgressInfo)
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	local var0 = arg0:findTF("right_panel/task_progress")

	setActive(var0, true)
	setText(var0:Find("title"), i18n("week_task_title_label"))

	arg0.awardPreviewBtn = var0:Find("award_preview")

	setText(arg0.awardPreviewBtn:Find("Text"), i18n("week_task_award_preview_label"))

	arg0.phaseTxt = var0:Find("phase/Text"):GetComponent(typeof(Text))
	arg0.progressSlider = var0:Find("slider"):GetComponent(typeof(Slider))
	arg0.progressTxt = var0:Find("slider/Text"):GetComponent(typeof(Text))
	arg0.awardList = UIItemList.New(var0:Find("awards"), var0:Find("awards/itemtpl"))
	arg0.getBtn = var0:Find("get_btn")
	arg0.getBtnEnableTF = arg0.getBtn:Find("enable")
	arg0.getBtnDisableTF = arg0.getBtn:Find("disable")
	arg0.tip = var0:Find("tip")

	onButton(arg0, arg0.awardPreviewBtn, function()
		local var0 = arg0.contextData.weekTaskProgressInfo

		arg0.contextData.ptAwardWindow:ExecuteAction("Display", var0:GetAllPhaseDrops())
	end, SFX_PANEL)

	arg0.topTF = arg0._scrllPanel.parent
	arg0.topPosy = arg0._scrllPanel.localPosition.y + arg0._scrllPanel.rect.height * 0.5

	arg0._scrollView.onValueChanged:AddListener(function(arg0)
		arg0:UpdateCardTip()
	end)
end

function var0.UpdateCardTip(arg0)
	for iter0, iter1 in pairs(arg0.taskCards) do
		local var0 = arg0.topTF:InverseTransformPoint(iter1._tf.position).y + iter1.height * 0.5

		iter1.tip.anchoredPosition3D = math.abs(var0 - arg0.topPosy) < iter1.tip.rect.height * 0.5 and Vector3(-5, -25) or Vector3(-5, 0)
	end
end

function var0.onUpdateTask(arg0, arg1, arg2)
	var0.super.onUpdateTask(arg0, arg1, arg2)

	if arg1 == 0 then
		arg0.taskCards[arg2].tip.anchoredPosition3D = Vector3(-5, -25)
	end
end

function var0.Update(arg0, arg1, arg2, arg3)
	if arg0.contextData.weekTaskProgressInfo:ReachMaxPt() and arg0:isShowing() then
		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0:DoDisablePtTaskAnim(function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0:Flush(arg2)

			if arg3 then
				arg3(arg0.taskVOs or {})
			end
		end)
	elseif TaskScene.IsPassScenario() then
		arg0:Flush(arg2)

		if arg3 then
			arg3(arg0.taskVOs or {})
		end
	else
		setActive(arg0._tf, false)

		if arg3 then
			arg3({})
		end
	end
end

function var0.DoDisablePtTaskAnim(arg0, arg1)
	local function var0(arg0, arg1)
		arg0:DoSubmitAnim(function()
			setActive(arg0._go, false)
			arg1()
		end)
	end

	arg0._scrollView.enabled = false

	local var1 = {}

	for iter0, iter1 in ipairs(arg0.taskVOs or {}) do
		if iter1.isWeekTask then
			local var2 = arg0:GetCard(iter1.id)

			if var2 then
				table.insert(var1, function(arg0)
					var0(var2, arg0)
				end)
			end
		end
	end

	seriesAsync(var1, function()
		arg0._scrollView.enabled = true

		arg1()
	end)
end

function var0.GetCard(arg0, arg1)
	for iter0, iter1 in pairs(arg0.taskCards) do
		if iter1.taskVO.id == arg1 then
			return iter1
		end
	end

	return nil
end

function var0.Flush(arg0, arg1)
	arg0.taskVOs = {}

	local var0 = arg0.contextData.weekTaskProgressInfo

	arg0:UpdateWeekProgress(var0)

	if not var0:ReachMaxPt() then
		local var1 = var0:GetSubTasks()

		for iter0, iter1 in pairs(var1) do
			table.insert(arg0.taskVOs, iter1)
		end
	end

	local var2 = arg0.contextData.taskVOsById

	for iter2, iter3 in pairs(var2) do
		if iter3:ShowOnTaskScene() and arg1[iter3:GetRealType()] then
			table.insert(arg0.taskVOs, iter3)
		end
	end

	table.sort(arg0.taskVOs, function(arg0, arg1)
		local var0 = arg0:getTaskStatus(arg0)
		local var1 = arg1:getTaskStatus(arg1)

		if var0 == var1 then
			return (arg0.isWeekTask and 0 or 1) > (arg1.isWeekTask and 0 or 1)
		else
			return var1 < var0
		end
	end)
	arg0:Show()
	arg0._scrollView:SetTotalCount(#arg0.taskVOs, -1)
end

function var0.UpdateWeekProgress(arg0, arg1)
	arg0:UpdateWeekProgressGetBtn(arg1)

	arg0.phaseTxt.text = arg1:GetPhase() .. "/" .. arg1:GetTotalPhase()

	local var0 = arg1:GetProgress()
	local var1 = arg1:GetTarget()

	arg0.progressSlider.value = var0 / var1
	arg0.progressTxt.text = var0 .. "/" .. var1

	local var2 = arg1:GetDropList()

	arg0.awardList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(TaskMediator.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.awardList:align(#var2)
end

function var0.UpdateWeekProgressGetBtn(arg0, arg1)
	local var0 = arg1:CanUpgrade()

	setGray(arg0.getBtn, not var0, false)
	setActive(arg0.getBtnEnableTF, var0)
	setActive(arg0.getBtnDisableTF, not var0)
	setActive(arg0.tip, var0)
	onButton(arg0, arg0.getBtn, function()
		if var0 then
			arg0:JudgeOverflow(arg1, function()
				arg0:emit(TaskMediator.ON_SUBMIT_WEEK_PROGREE)
			end)
		end
	end, SFX_PANEL)
end

function var0.JudgeOverflow(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.gameset.urpt_chapter_max.description[1]
	local var2 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var1)
	local var3 = arg1:GetDropList()
	local var4, var5 = Task.StaticJudgeOverflow(var0.gold, var0.oil, var2, true, true, var3)

	if var4 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("award_max_warning"),
			items = var5,
			onYes = arg2
		})
	else
		arg2()
	end
end

function var0.OnDestroy(arg0)
	arg0._scrollView.onValueChanged:RemoveAllListeners()
end

function var0.RefreshWeekTaskPageBefore(arg0, arg1)
	local var0 = arg0:GetCard(arg1)

	if var0 then
		setActive(var0._go, false)
	end
end

return var0
