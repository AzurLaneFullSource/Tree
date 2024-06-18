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

	local var0_3 = arg0_3:findTF("right_panel/task_progress")

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

	arg0_3.topTF = arg0_3._scrllPanel.parent
	arg0_3.topPosy = arg0_3._scrllPanel.localPosition.y + arg0_3._scrllPanel.rect.height * 0.5

	arg0_3._scrollView.onValueChanged:AddListener(function(arg0_5)
		arg0_3:UpdateCardTip()
	end)
end

function var0_0.UpdateCardTip(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.taskCards) do
		local var0_6 = arg0_6.topTF:InverseTransformPoint(iter1_6._tf.position).y + iter1_6.height * 0.5

		iter1_6.tip.anchoredPosition3D = math.abs(var0_6 - arg0_6.topPosy) < iter1_6.tip.rect.height * 0.5 and Vector3(-5, -25) or Vector3(-5, 0)
	end
end

function var0_0.onUpdateTask(arg0_7, arg1_7, arg2_7)
	var0_0.super.onUpdateTask(arg0_7, arg1_7, arg2_7)

	if arg1_7 == 0 then
		arg0_7.taskCards[arg2_7].tip.anchoredPosition3D = Vector3(-5, -25)
	end
end

function var0_0.Update(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg0_8.contextData.weekTaskProgressInfo:ReachMaxPt() and arg0_8:isShowing() then
		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0_8:DoDisablePtTaskAnim(function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_8:Flush(arg2_8)

			if arg3_8 then
				arg3_8(arg0_8.taskVOs or {})
			end
		end)
	elseif TaskScene.IsPassScenario() then
		arg0_8:Flush(arg2_8)

		if arg3_8 then
			arg3_8(arg0_8.taskVOs or {})
		end
	else
		setActive(arg0_8._tf, false)

		if arg3_8 then
			arg3_8({})
		end
	end
end

function var0_0.DoDisablePtTaskAnim(arg0_10, arg1_10)
	local function var0_10(arg0_11, arg1_11)
		arg0_11:DoSubmitAnim(function()
			setActive(arg0_11._go, false)
			arg1_11()
		end)
	end

	arg0_10._scrollView.enabled = false

	local var1_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.taskVOs or {}) do
		if iter1_10.isWeekTask then
			local var2_10 = arg0_10:GetCard(iter1_10.id)

			if var2_10 then
				table.insert(var1_10, function(arg0_13)
					var0_10(var2_10, arg0_13)
				end)
			end
		end
	end

	seriesAsync(var1_10, function()
		arg0_10._scrollView.enabled = true

		arg1_10()
	end)
end

function var0_0.GetCard(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.taskCards) do
		if iter1_15.taskVO.id == arg1_15 then
			return iter1_15
		end
	end

	return nil
end

function var0_0.Flush(arg0_16, arg1_16)
	arg0_16.taskVOs = {}

	local var0_16 = arg0_16.contextData.weekTaskProgressInfo

	arg0_16:UpdateWeekProgress(var0_16)

	if not var0_16:ReachMaxPt() then
		local var1_16 = var0_16:GetSubTasks()

		for iter0_16, iter1_16 in pairs(var1_16) do
			table.insert(arg0_16.taskVOs, iter1_16)
		end
	end

	local var2_16 = arg0_16.contextData.taskVOsById

	for iter2_16, iter3_16 in pairs(var2_16) do
		if iter3_16:ShowOnTaskScene() and arg1_16[iter3_16:GetRealType()] then
			table.insert(arg0_16.taskVOs, iter3_16)
		end
	end

	table.sort(arg0_16.taskVOs, function(arg0_17, arg1_17)
		local var0_17 = arg0_17:getTaskStatus(arg0_17)
		local var1_17 = arg1_17:getTaskStatus(arg1_17)

		if var0_17 == var1_17 then
			return (arg0_17.isWeekTask and 0 or 1) > (arg1_17.isWeekTask and 0 or 1)
		else
			return var1_17 < var0_17
		end
	end)
	arg0_16:Show()
	arg0_16._scrollView:SetTotalCount(#arg0_16.taskVOs, -1)
end

function var0_0.UpdateWeekProgress(arg0_18, arg1_18)
	arg0_18:UpdateWeekProgressGetBtn(arg1_18)

	arg0_18.phaseTxt.text = arg1_18:GetPhase() .. "/" .. arg1_18:GetTotalPhase()

	local var0_18 = arg1_18:GetProgress()
	local var1_18 = arg1_18:GetTarget()

	arg0_18.progressSlider.value = var0_18 / var1_18
	arg0_18.progressTxt.text = var0_18 .. "/" .. var1_18

	local var2_18 = arg1_18:GetDropList()

	arg0_18.awardList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var2_18[arg1_19 + 1]
			local var1_19 = {
				type = var0_19[1],
				id = var0_19[2],
				count = var0_19[3]
			}

			updateDrop(arg2_19, var1_19)
			onButton(arg0_18, arg2_19, function()
				arg0_18:emit(TaskMediator.ON_DROP, var1_19)
			end, SFX_PANEL)
		end
	end)
	arg0_18.awardList:align(#var2_18)
end

function var0_0.UpdateWeekProgressGetBtn(arg0_21, arg1_21)
	local var0_21 = arg1_21:CanUpgrade()

	setGray(arg0_21.getBtn, not var0_21, false)
	setActive(arg0_21.getBtnEnableTF, var0_21)
	setActive(arg0_21.getBtnDisableTF, not var0_21)
	setActive(arg0_21.tip, var0_21)
	onButton(arg0_21, arg0_21.getBtn, function()
		if var0_21 then
			arg0_21:JudgeOverflow(arg1_21, function()
				arg0_21:emit(TaskMediator.ON_SUBMIT_WEEK_PROGREE)
			end)
		end
	end, SFX_PANEL)
end

function var0_0.JudgeOverflow(arg0_24, arg1_24, arg2_24)
	local var0_24 = getProxy(PlayerProxy):getRawData()
	local var1_24 = pg.gameset.urpt_chapter_max.description[1]
	local var2_24 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var1_24)
	local var3_24 = arg1_24:GetDropList()
	local var4_24, var5_24 = Task.StaticJudgeOverflow(var0_24.gold, var0_24.oil, var2_24, true, true, var3_24)

	if var4_24 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("award_max_warning"),
			items = var5_24,
			onYes = arg2_24
		})
	else
		arg2_24()
	end
end

function var0_0.OnDestroy(arg0_25)
	arg0_25._scrollView.onValueChanged:RemoveAllListeners()
end

function var0_0.RefreshWeekTaskPageBefore(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetCard(arg1_26)

	if var0_26 then
		setActive(var0_26._go, false)
	end
end

return var0_0
