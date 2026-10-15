local var0_0 = class("WindFogCorridorSkinPage", import("view.activity.CorePage.CoreLoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.prog = arg0_1.bg:Find("total_progress/prog")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnDetail = arg0_1.bg:Find("btn_detail")
	arg0_1.getBtn = arg0_1.bg:Find("btn_get_pt")
	arg0_1.getBtnGray = arg0_1.bg:Find("btn_get_pt_gray")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.clientConfig = arg0_2.activity:getConfig("config_client")
	arg0_2.taskGroup = arg0_2.clientConfig.unlock_task

	local var0_2 = getProxy(ActivityProxy):getActivityById(arg0_2.clientConfig.ptActId)

	arg0_2.ptData = ActivityPtData.New(var0_2)

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.btnDetail, function()
		arg0_3:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			blur = true,
			isBtnActive = true,
			type = arg0_3.ptData.type,
			dropList = arg0_3.ptData.dropList,
			targets = arg0_3.ptData.targets,
			level = arg0_3.ptData.level,
			count = arg0_3.ptData.count,
			resId = arg0_3.ptData.resId,
			resDrop = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_3.ptData.resId
			}),
			unlockStamps = arg0_3.ptData:GetDayUnlockStamps(),
			ptActId = arg0_3.clientConfig.ptActId
		})
	end)
	onButton(arg0_3, arg0_3.getBtn, function()
		if not arg0_3.ptData or arg0_3.ptData:GetMaxAvailableTargetIndex() == arg0_3.ptData:GetLevel() then
			return
		end

		local var0_5 = {}
		local var1_5 = getProxy(PlayerProxy):getRawData()
		local var2_5 = pg.gameset.urpt_chapter_max.description[1]
		local var3_5 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var2_5)
		local var4_5 = arg0_3.ptData:GetAllAvailableAwards()
		local var5_5, var6_5 = Task.StaticJudgeOverflow(var1_5.gold, var1_5.oil, var3_5, true, true, var4_5)

		if var5_5 then
			table.insert(var0_5, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_5,
					onYes = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			local var0_7 = arg0_3.ptData:GetCurrTarget()

			arg0_3:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 4,
				activity_id = arg0_3.ptData:GetId(),
				arg1 = var0_7
			})
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8.nday = arg0_8:getTaskIdx(arg0_8.activity)

	if not table.contains(arg0_8.taskGroup[arg0_8.nday], arg0_8.clientConfig.daily_task) then
		table.insert(arg0_8.taskGroup[arg0_8.nday], 2, arg0_8.clientConfig.daily_task)
	end

	if not table.contains(arg0_8.taskGroup[arg0_8.nday], arg0_8.clientConfig.once_task) then
		table.insert(arg0_8.taskGroup[arg0_8.nday], 4, arg0_8.clientConfig.once_task)
	end

	if arg0_8.prog then
		local var0_8, var1_8 = arg0_8:GetPtColor()
		local var2_8 = var0_8 and setColorStr(arg0_8.ptData.count, var0_8) or arg0_8.ptData.count
		local var3_8 = var1_8 and setColorStr("/" .. arg0_8.ptData:GetTotalResRequire(), var1_8) or "/" .. arg0_8.ptData:GetTotalResRequire()

		setText(arg0_8.prog, var2_8 .. var3_8)
	end

	arg0_8.uilist:align(#arg0_8.taskGroup[arg0_8.nday])
	setActive(arg0_8.getBtnGray, arg0_8.ptData:GetMaxAvailableTargetIndex() == arg0_8.ptData:GetLevel())
	setActive(arg0_8.getBtn, arg0_8.ptData:GetMaxAvailableTargetIndex() ~= arg0_8.ptData:GetLevel())
end

function var0_0.getTaskIdx(arg0_9, arg1_9)
	local var0_9 = 1
	local var1_9 = arg1_9:getNDay()
	local var2_9 = #arg0_9.taskGroup
	local var3_9 = math.min(var1_9, var2_9)
	local var4_9 = true

	for iter0_9 = 1, var3_9 do
		if not var4_9 then
			break
		end

		var0_9 = iter0_9

		if iter0_9 < var3_9 then
			for iter1_9, iter2_9 in ipairs(arg0_9.taskGroup[iter0_9]) do
				if iter2_9 ~= arg0_9.clientConfig.daily_task and iter2_9 ~= arg0_9.clientConfig.once_task and not arg0_9:isTaskFinished(iter2_9) then
					var4_9 = false

					break
				end
			end
		end
	end

	return math.min(var0_9, var2_9)
end

function var0_0.isTaskFinished(arg0_10, arg1_10)
	if not arg0_10.taskProxy then
		arg0_10.taskProxy = getProxy(TaskProxy)
	end

	local var0_10 = arg0_10.taskProxy:getTaskById(arg1_10) or arg0_10.taskProxy:getFinishTaskById(arg1_10)

	originalPrint(" >>>>>>>>>> taskId = ", arg1_10, ", isFinished = ", var0_10 and var0_10:getTaskStatus() == 2)

	return var0_10 and var0_10:getTaskStatus() == 2
end

function var0_0.GetPtColor(arg0_11)
	return "#864749", "#f29b76"
end

return var0_0
