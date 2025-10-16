local var0_0 = class("TaskWeekPage", import(".TaskCommonPage"))

var0_0.WEEK_TASK_TYPE_COMMON = 1
var0_0.WEEK_TASK_TYPE_PT = 2

function var0_0.getUIName(arg0_1)
	return "TaskListForWeekPage"
end

function var0_0.RefreshWeekProgress(arg0_2)
	arg0_2:UpdateWeekProgress(arg0_2.contextData.weekTaskProgressInfo)
end

function var0_0.OnLoaded(arg0_3)
	var0_0.super.OnLoaded(arg0_3)

	local var0_3 = arg0_3._tf:Find("task_progress")

	setActive(var0_3, true)
	setText(var0_3:Find("title"), i18n("week_task_title_label"))

	arg0_3.awardPreviewBtn = var0_3:Find("award_preview")

	setText(arg0_3.awardPreviewBtn:Find("Text"), i18n("week_task_award_preview_label"))

	arg0_3.phaseTxt = var0_3:Find("phase/Text"):GetComponent(typeof(Text))
	arg0_3.progressSlider = var0_3:Find("slider"):GetComponent(typeof(Slider))
	arg0_3.progressTxt = var0_3:Find("slider/Text"):GetComponent(typeof(Text))
	arg0_3.awardList = UIItemList.New(var0_3:Find("awards"), var0_3:Find("awards/itemtpl"))
	arg0_3.getBtn = var0_3:Find("get_btn")
	arg0_3.getBtnEnableTF = arg0_3.getBtn:Find("enable")
	arg0_3.getBtnDisableTF = arg0_3.getBtn:Find("disable")
	arg0_3.tip = var0_3:Find("tip")

	onButton(arg0_3, arg0_3.awardPreviewBtn, function()
		local var0_4 = arg0_3.contextData.weekTaskProgressInfo

		arg0_3.contextData.ptAwardWindow:ExecuteAction("Display", var0_4:GetAllPhaseDrops())
	end, SFX_PANEL)
end

function var0_0.onUpdateTask(arg0_5, arg1_5, arg2_5)
	var0_0.super.onUpdateTask(arg0_5, arg1_5, arg2_5)

	arg2_5.name = arg0_5.taskCards[arg2_5].taskVO.id
end

function var0_0.Update(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg0_6.contextData.weekTaskProgressInfo:ReachMaxPt() and arg0_6:isShowing() then
		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0_6:DoDisablePtTaskAnim(function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_6:Flush(arg2_6)

			if arg3_6 then
				arg3_6(arg0_6.taskVOs or {})
			end
		end)
	elseif TaskScene.IsPassScenario() then
		arg0_6:Flush(arg2_6)

		if arg3_6 then
			arg3_6(arg0_6.taskVOs or {})
		end
	else
		setActive(arg0_6._tf, false)

		if arg3_6 then
			arg3_6({})
		end
	end
end

function var0_0.DoDisablePtTaskAnim(arg0_8, arg1_8)
	local function var0_8(arg0_9, arg1_9)
		arg0_9:DoSubmitAnim(function()
			setActive(arg0_9._go, false)
			arg1_9()
		end)
	end

	arg0_8._scrollView.enabled = false

	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.taskVOs or {}) do
		if iter1_8.isWeekTask then
			local var2_8 = arg0_8:GetCard(iter1_8.id)

			if var2_8 then
				table.insert(var1_8, function(arg0_11)
					var0_8(var2_8, arg0_11)
				end)
			end
		end
	end

	seriesAsync(var1_8, function()
		arg0_8._scrollView.enabled = true

		arg1_8()
	end)
end

function var0_0.GetCard(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.taskCards) do
		if iter1_13.taskVO.id == arg1_13 then
			return iter1_13
		end
	end

	return nil
end

function var0_0.Flush(arg0_14, arg1_14)
	arg0_14.taskVOs = {}

	local var0_14 = arg0_14.contextData.weekTaskProgressInfo

	arg0_14:UpdateWeekProgress(var0_14)

	if not var0_14:ReachMaxPt() then
		local var1_14 = var0_14:GetSubTasks()

		for iter0_14, iter1_14 in pairs(var1_14) do
			table.insert(arg0_14.taskVOs, iter1_14)
		end
	end

	local var2_14 = arg0_14.contextData.taskVOsById

	for iter2_14, iter3_14 in pairs(var2_14) do
		if iter3_14:ShowOnTaskScene() and arg1_14[iter3_14:GetRealType()] then
			table.insert(arg0_14.taskVOs, iter3_14)
		end
	end

	table.sort(arg0_14.taskVOs, CompareFuncs({
		function(arg0_15)
			return -arg0_15:getTaskStatus(arg0_15)
		end,
		function(arg0_16)
			return pg.NewGuideMgr.GetInstance():IsBusy() and arg0_16.id == getDorm3dGameset("drom3d_weekly_task")[1] and 0 or 1
		end,
		function(arg0_17)
			return arg0_17.isWeekTask and 1 or 0
		end,
		function(arg0_18)
			return arg0_18.id
		end
	}))
	arg0_14:Show()

	arg0_14._scrollView.enabled = true

	arg0_14._scrollView:SetTotalCount(#arg0_14.taskVOs, -1)
end

function var0_0.UpdateWeekProgress(arg0_19, arg1_19)
	arg0_19:UpdateWeekProgressGetBtn(arg1_19)

	arg0_19.phaseTxt.text = arg1_19:GetPhase() .. "/" .. arg1_19:GetTotalPhase()

	local var0_19 = arg1_19:GetProgress()
	local var1_19 = arg1_19:GetTarget()

	arg0_19.progressSlider.value = var0_19 / var1_19
	arg0_19.progressTxt.text = var0_19 .. "/" .. var1_19

	local var2_19 = arg1_19:GetDropList()

	arg0_19.awardList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = var2_19[arg1_20 + 1]
			local var1_20 = {
				type = var0_20[1],
				id = var0_20[2],
				count = var0_20[3]
			}

			updateDrop(arg2_20, var1_20)
			onButton(arg0_19, arg2_20, function()
				arg0_19:emit(TaskMediator.ON_DROP, var1_20)
			end, SFX_PANEL)
		end
	end)
	arg0_19.awardList:align(#var2_19)
end

function var0_0.UpdateWeekProgressGetBtn(arg0_22, arg1_22)
	local var0_22 = arg1_22:CanUpgrade()

	setGray(arg0_22.getBtn, not var0_22, false)
	setActive(arg0_22.getBtnEnableTF, var0_22)
	setActive(arg0_22.getBtnDisableTF, not var0_22)
	setActive(arg0_22.tip, var0_22)
	onButton(arg0_22, arg0_22.getBtn, function()
		if var0_22 then
			arg0_22:JudgeOverflow(arg1_22, function()
				arg0_22:emit(TaskMediator.ON_SUBMIT_WEEK_PROGREE)
			end)
		end
	end, SFX_PANEL)
end

function var0_0.JudgeOverflow(arg0_25, arg1_25, arg2_25)
	local var0_25 = getProxy(PlayerProxy):getRawData()
	local var1_25 = pg.gameset.urpt_chapter_max.description[1]
	local var2_25 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var1_25)
	local var3_25 = arg1_25:GetDropList()
	local var4_25, var5_25 = Task.StaticJudgeOverflow(var0_25.gold, var0_25.oil, var2_25, true, true, var3_25)

	if var4_25 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("award_max_warning"),
			items = var5_25,
			onYes = arg2_25
		})
	else
		arg2_25()
	end
end

function var0_0.OnDestroy(arg0_26)
	arg0_26._scrollView.onValueChanged:RemoveAllListeners()
end

function var0_0.RefreshWeekTaskPageBefore(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetCard(arg1_27)

	if var0_27 then
		setActive(var0_27._go, false)
	end
end

return var0_0
