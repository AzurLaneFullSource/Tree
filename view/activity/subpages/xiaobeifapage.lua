local var0_0 = class("XiaobeiFaPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.layer = arg0_1:findTF("layer")
	arg0_1.btn = arg0_1:findTF("btn", arg0_1.layer)
	arg0_1.bonusList = arg0_1:findTF("bonus_list", arg0_1.layer)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.layer)
	arg0_1.progressTxt = arg0_1:findTF("progressText", arg0_1.layer)
	arg0_1.phaseTxt = arg0_1:findTF("phase/Text", arg0_1.layer)
	arg0_1.award = arg0_1:findTF("award", arg0_1.layer)
end

function var0_0.OnFirstFlush(arg0_2)
	local var0_2 = arg0_2.activity

	onButton(arg0_2, arg0_2.bonusList, function()
		local var0_3 = var0_2:getConfig("config_data")
		local var1_3 = var0_2:getConfig("config_client").pt_id
		local var2_3 = getProxy(ActivityProxy):getActivityById(var0_2:getConfig("config_client").rank_act_id).data1

		arg0_2:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtTaskAwardWindow, {
			tasklist = var0_3,
			ptId = var1_3,
			totalPt = var2_3
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_4)
	arg0_4:flush_task_list_pt_xiaobeifa()
end

function var0_0.flush_task_list_pt_xiaobeifa(arg0_5)
	arg0_5:flush_task_list_pt()

	local var0_5 = arg0_5.activity
	local var1_5, var2_5, var3_5 = arg0_5:getDoingTask(var0_5)

	if var0_5:getConfig("config_client").main_task then
		local var4_5 = var3_5 and var1_5 or var1_5 - 1

		arg0_5:setImportantProgress(var0_5, arg0_5:findTF("progress_important"), var4_5, var0_5:getConfig("config_client").main_task, var0_5:getConfig("config_data"))
	end
end

function var0_0.getDoingTask(arg0_6, arg1_6, arg2_6)
	local var0_6 = getProxy(TaskProxy)
	local var1_6 = _.flatten(arg1_6:getConfig("config_data"))
	local var2_6
	local var3_6

	if arg1_6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASKS then
		for iter0_6 = #var1_6, 1, -1 do
			local var4_6 = var0_6:getFinishTaskById(var1_6[iter0_6])

			if var4_6 then
				if not var3_6 then
					var2_6 = var1_6[iter0_6]
					var3_6 = var4_6
				end

				break
			end

			var2_6 = var1_6[iter0_6]
			var3_6 = var0_6:getTaskById(var1_6[iter0_6])
		end
	else
		var2_6, var3_6 = getActivityTask(arg1_6)
	end

	if not arg2_6 then
		assert(var3_6, "without taskVO " .. var2_6 .. " from server")
	end

	return table.indexof(var1_6, var2_6), var2_6, var3_6
end

function var0_0.flush_task_list_pt(arg0_7)
	local var0_7 = arg0_7.activity
	local var1_7 = _.flatten(var0_7:getConfig("config_data"))
	local var2_7, var3_7, var4_7 = arg0_7:getDoingTask(var0_7)
	local var5_7 = getProxy(ActivityProxy):getActivityById(var0_7:getConfig("config_client").rank_act_id).data1

	setText(arg0_7.phaseTxt, var2_7 .. "/" .. #var1_7)

	if var4_7 then
		local var6_7 = var4_7:getConfig("target_num")
		local var7_7 = setColorStr(math.min(var5_7, var6_7), var5_7 < var6_7 and COLOR_RED or COLOR_GREEN) .. "/" .. var6_7

		setText(arg0_7.progressTxt, var7_7)
		setSlider(arg0_7.progress, 0, var6_7, math.min(var5_7, var6_7))

		local var8_7 = var4_7:getConfig("award_display")[1]
		local var9_7 = {
			type = var8_7[1],
			id = var8_7[2],
			count = var8_7[3]
		}

		updateDrop(arg0_7.award, var9_7)
		onButton(arg0_7, arg0_7.award, function()
			arg0_7:emit(BaseUI.ON_DROP, var9_7)
		end, SFX_PANEL)

		arg0_7.btn:GetComponent(typeof(Image)).enabled = not var4_7:isFinish()

		setActive(arg0_7.btn:Find("get"), var4_7:isFinish() and not var4_7:isReceive())
		setActive(arg0_7.btn:Find("achieved"), var4_7:isReceive())
		onButton(arg0_7, arg0_7.btn, function()
			if not var4_7:isFinish() then
				arg0_7:emit(ActivityMediator.ON_TASK_GO, var4_7)
			else
				if not arg0_7:TaskSubmitCheck(var4_7) then
					return
				end

				arg0_7:emit(ActivityMediator.ON_TASK_SUBMIT, var4_7)
			end
		end, SFX_PANEL)
		setButtonEnabled(arg0_7.btn, not var4_7:isReceive())
	end
end

function var0_0.TaskSubmitCheck(arg0_10, arg1_10)
	if var0_0.checkList[arg1_10.id] then
		local var0_10 = getProxy(BayProxy):getShips()

		for iter0_10, iter1_10 in ipairs(var0_10) do
			if iter1_10:getGroupId() == var0_0.checkList[arg1_10.id] and iter1_10:isActivityNpc() then
				return true
			end
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_client"))

		return false
	end

	return true
end

function var0_0.setImportantProgress(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	local var0_11 = arg2_11:Find("award_display")
	local var1_11 = arg2_11:Find("important_task_tpl")
	local var2_11 = getProxy(TaskProxy)
	local var3_11 = pg.task_data_template[arg5_11[#arg5_11]].target_num
	local var4_11 = getProxy(ActivityProxy):getActivityById(arg1_11:getConfig("config_client").rank_act_id).data1

	setSlider(arg2_11, 0, var3_11, var4_11)

	local var5_11
	local var6_11 = var0_11:GetComponent(typeof(RectTransform)).rect.width
	local var7_11

	removeAllChildren(var0_11)
	setActive(var1_11, false)

	for iter0_11, iter1_11 in ipairs(arg4_11) do
		for iter2_11, iter3_11 in ipairs(arg5_11) do
			if iter1_11 == iter3_11 then
				local var8_11 = Instantiate(var1_11)

				SetParent(var8_11, var0_11)
				setActive(var8_11, true)
				setAnchoredPosition(var8_11, {
					x = pg.task_data_template[arg5_11[iter2_11]].target_num / var3_11 * var6_11
				})

				local var9_11 = pg.task_data_template[iter1_11]
				local var10_11 = var9_11.award_display[1]
				local var11_11 = arg0_11:findTF("award", var8_11)
				local var12_11 = {
					type = var10_11[1],
					id = var10_11[2],
					count = var10_11[3]
				}

				updateDrop(var11_11, var12_11)
				onButton(arg0_11, var11_11, function()
					arg0_11:emit(BaseUI.ON_DROP, var12_11)
				end, SFX_PANEL)
				setText(arg0_11:findTF("Text", var8_11), var9_11.target_num)

				local var13_11 = arg0_11:findTF("mask", var11_11)

				setActive(var13_11, iter2_11 <= arg3_11)

				break
			end
		end
	end
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
