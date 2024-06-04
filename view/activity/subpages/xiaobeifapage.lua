local var0 = class("XiaobeiFaPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.layer = arg0:findTF("layer")
	arg0.btn = arg0:findTF("btn", arg0.layer)
	arg0.bonusList = arg0:findTF("bonus_list", arg0.layer)
	arg0.progress = arg0:findTF("progress", arg0.layer)
	arg0.progressTxt = arg0:findTF("progressText", arg0.layer)
	arg0.phaseTxt = arg0:findTF("phase/Text", arg0.layer)
	arg0.award = arg0:findTF("award", arg0.layer)
end

function var0.OnFirstFlush(arg0)
	local var0 = arg0.activity

	onButton(arg0, arg0.bonusList, function()
		local var0 = var0:getConfig("config_data")
		local var1 = var0:getConfig("config_client").pt_id
		local var2 = getProxy(ActivityProxy):getActivityById(var0:getConfig("config_client").rank_act_id).data1

		arg0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtTaskAwardWindow, {
			tasklist = var0,
			ptId = var1,
			totalPt = var2
		})
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0:flush_task_list_pt_xiaobeifa()
end

function var0.flush_task_list_pt_xiaobeifa(arg0)
	arg0:flush_task_list_pt()

	local var0 = arg0.activity
	local var1, var2, var3 = arg0:getDoingTask(var0)

	if var0:getConfig("config_client").main_task then
		local var4 = var3 and var1 or var1 - 1

		arg0:setImportantProgress(var0, arg0:findTF("progress_important"), var4, var0:getConfig("config_client").main_task, var0:getConfig("config_data"))
	end
end

function var0.getDoingTask(arg0, arg1, arg2)
	local var0 = getProxy(TaskProxy)
	local var1 = _.flatten(arg1:getConfig("config_data"))
	local var2
	local var3

	if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASKS then
		for iter0 = #var1, 1, -1 do
			local var4 = var0:getFinishTaskById(var1[iter0])

			if var4 then
				if not var3 then
					var2 = var1[iter0]
					var3 = var4
				end

				break
			end

			var2 = var1[iter0]
			var3 = var0:getTaskById(var1[iter0])
		end
	else
		var2, var3 = getActivityTask(arg1)
	end

	if not arg2 then
		assert(var3, "without taskVO " .. var2 .. " from server")
	end

	return table.indexof(var1, var2), var2, var3
end

function var0.flush_task_list_pt(arg0)
	local var0 = arg0.activity
	local var1 = _.flatten(var0:getConfig("config_data"))
	local var2, var3, var4 = arg0:getDoingTask(var0)
	local var5 = getProxy(ActivityProxy):getActivityById(var0:getConfig("config_client").rank_act_id).data1

	setText(arg0.phaseTxt, var2 .. "/" .. #var1)

	if var4 then
		local var6 = var4:getConfig("target_num")
		local var7 = setColorStr(math.min(var5, var6), var5 < var6 and COLOR_RED or COLOR_GREEN) .. "/" .. var6

		setText(arg0.progressTxt, var7)
		setSlider(arg0.progress, 0, var6, math.min(var5, var6))

		local var8 = var4:getConfig("award_display")[1]
		local var9 = {
			type = var8[1],
			id = var8[2],
			count = var8[3]
		}

		updateDrop(arg0.award, var9)
		onButton(arg0, arg0.award, function()
			arg0:emit(BaseUI.ON_DROP, var9)
		end, SFX_PANEL)

		arg0.btn:GetComponent(typeof(Image)).enabled = not var4:isFinish()

		setActive(arg0.btn:Find("get"), var4:isFinish() and not var4:isReceive())
		setActive(arg0.btn:Find("achieved"), var4:isReceive())
		onButton(arg0, arg0.btn, function()
			if not var4:isFinish() then
				arg0:emit(ActivityMediator.ON_TASK_GO, var4)
			else
				if not arg0:TaskSubmitCheck(var4) then
					return
				end

				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var4)
			end
		end, SFX_PANEL)
		setButtonEnabled(arg0.btn, not var4:isReceive())
	end
end

function var0.TaskSubmitCheck(arg0, arg1)
	if var0.checkList[arg1.id] then
		local var0 = getProxy(BayProxy):getShips()

		for iter0, iter1 in ipairs(var0) do
			if iter1:getGroupId() == var0.checkList[arg1.id] and iter1:isActivityNpc() then
				return true
			end
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_client"))

		return false
	end

	return true
end

function var0.setImportantProgress(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg2:Find("award_display")
	local var1 = arg2:Find("important_task_tpl")
	local var2 = getProxy(TaskProxy)
	local var3 = pg.task_data_template[arg5[#arg5]].target_num
	local var4 = getProxy(ActivityProxy):getActivityById(arg1:getConfig("config_client").rank_act_id).data1

	setSlider(arg2, 0, var3, var4)

	local var5
	local var6 = var0:GetComponent(typeof(RectTransform)).rect.width
	local var7

	removeAllChildren(var0)
	setActive(var1, false)

	for iter0, iter1 in ipairs(arg4) do
		for iter2, iter3 in ipairs(arg5) do
			if iter1 == iter3 then
				local var8 = Instantiate(var1)

				SetParent(var8, var0)
				setActive(var8, true)
				setAnchoredPosition(var8, {
					x = pg.task_data_template[arg5[iter2]].target_num / var3 * var6
				})

				local var9 = pg.task_data_template[iter1]
				local var10 = var9.award_display[1]
				local var11 = arg0:findTF("award", var8)
				local var12 = {
					type = var10[1],
					id = var10[2],
					count = var10[3]
				}

				updateDrop(var11, var12)
				onButton(arg0, var11, function()
					arg0:emit(BaseUI.ON_DROP, var12)
				end, SFX_PANEL)
				setText(arg0:findTF("Text", var8), var9.target_num)

				local var13 = arg0:findTF("mask", var11)

				setActive(var13, iter2 <= arg3)

				break
			end
		end
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
