local var0_0 = class("NieRAutomataOmenPage", import("view.activity.CorePage.CoreLoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.introduction = arg0_1.bg:Find("Introduction")
	arg0_1.desc1 = arg0_1.introduction:Find("desc1")
	arg0_1.desc2 = arg0_1.introduction:Find("desc2")
	arg0_1.total = arg0_1.bg:Find("total_progress")
	arg0_1.dayTF = arg0_1.total:Find("day")
	arg0_1.maxDayTF = arg0_1.total:Find("max_day")
	arg0_1.btnDetail = arg0_1.total:Find("btn_detail")
	arg0_1.btnDetailText = arg0_1.btnDetail:Find("detail")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.taskWindow = NieRAutomataOmenTaskWindow.New(arg0_1._tf, arg0_1.event)
	arg0_1.finishAll = false

	setActive(arg0_1.item, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_client").unlock_task

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	setActive(arg0_3.maxTF, #arg0_3.taskGroup)
	setText(arg0_3.btnDetailText, i18n("nier_a2_mission_detail"))
	onButton(arg0_3, arg0_3.btnDetail, function()
		arg0_3.taskWindow:ExecuteAction("Show", arg0_3.activity)
	end, SFX_PANEL)
end

function var0_0.OnShowFlush(arg0_5)
	var0_0.super.OnShowFlush(arg0_5)
end

function var0_0.GetTypewriterSpeed(arg0_6)
	local var0_6 = arg0_6.activity:getConfig("config_client").typewriterSpeed

	return var0_6 and var0_6 or 0.1
end

function var0_0.Playwriter(arg0_7)
	local var0_7 = {}

	if not arg0_7.finishAll then
		table.insert(var0_7, function(arg0_8)
			local var0_8 = arg0_7.desc1
			local var1_8 = GetOrAddComponent(var0_8, typeof(Typewriter))

			function var1_8.endFunc()
				arg0_8()
			end

			var1_8:setSpeed(arg0_7:GetTypewriterSpeed())
			var1_8:Play()
		end)
	else
		table.insert(var0_7, function(arg0_10)
			local var0_10 = arg0_7.activity:getConfig("config_client").story
			local var1_10 = checkExist(var0_10, {
				arg0_7.nday
			}, {
				1
			})

			if var1_10 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_10) then
				pg.NewStoryMgr.GetInstance():Play(var1_10, function()
					arg0_10()
				end)
			else
				arg0_10()
			end
		end)
	end

	table.insert(var0_7, function(arg0_12)
		local var0_12 = arg0_7.desc2

		setActive(arg0_7.desc2, true)

		local var1_12 = GetOrAddComponent(var0_12, typeof(Typewriter))

		function var1_12.endFunc()
			arg0_12()
		end

		var1_12:setSpeed(arg0_7:GetTypewriterSpeed())
		var1_12:Play()
	end)
	seriesAsync(var0_7, callback)
end

function var0_0.LocalFresh(arg0_14, arg1_14)
	local var0_14 = "nier_a2_text_block_day"
	local var1_14

	arg0_14.finishAll = arg1_14 >= 7 and arg0_14:lastFinish()

	if arg0_14.finishAll then
		var1_14 = i18n(var0_14 .. "_fin")

		setActive(arg0_14.desc1, false)
	else
		var1_14 = i18n(var0_14 .. arg1_14)

		setText(arg0_14.desc1, var1_14[1].info)
	end

	setText(arg0_14.desc2, var1_14[2].info)
	setActive(arg0_14.desc2, false)
	arg0_14:Playwriter()
end

function var0_0.lastFinish(arg0_15)
	local var0_15 = arg0_15.taskGroup[#arg0_15.taskGroup]
	local var1_15 = getProxy(TaskProxy):getTaskVO(var0_15[1])
	local var2_15 = getProxy(TaskProxy):getTaskVO(var0_15[2])

	return var1_15:getTaskStatus() == 2 and var2_15:getTaskStatus() == 2
end

function var0_0.UpdateTask(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16 + 1
	local var1_16 = arg2_16:Find("item")
	local var2_16 = arg0_16.taskGroup[arg0_16.nday][var0_16]
	local var3_16 = arg0_16.taskProxy:getTaskById(var2_16) or arg0_16.taskProxy:getFinishTaskById(var2_16)

	assert(var3_16, "without this task by id: " .. var2_16)

	local var4_16 = Drop.Create(var3_16:getConfig("award_display")[1])

	updateDrop(var1_16, var4_16)
	onButton(arg0_16, var1_16, function()
		arg0_16:emit(BaseUI.ON_DROP, var4_16)
	end, SFX_PANEL)

	local var5_16 = var3_16:getProgress()
	local var6_16 = var3_16:getConfig("target_num")
	local var7_16 = var3_16:getConfig("desc")

	if utf8.len(var7_16) >= 11 then
		setScrollText(arg2_16:Find("mask/description"), var7_16)
	else
		setText(arg2_16:Find("mask/description"), var7_16)
	end

	local var8_16, var9_16 = arg0_16:GetProgressColor()
	local var10_16

	var10_16 = var8_16 and setColorStr(var5_16, var8_16) or var5_16

	local var11_16

	var11_16 = var9_16 and setColorStr("/" .. var6_16, var9_16) or "/" .. var6_16

	setText(arg2_16:Find("progressText"), var10_16 .. var11_16)
	setSlider(arg2_16:Find("progress"), 0, var6_16, var5_16)

	local var12_16 = arg2_16:Find("go_btn")
	local var13_16 = arg2_16:Find("get_btn")
	local var14_16 = arg2_16:Find("got_btn")
	local var15_16 = var3_16:getTaskStatus()

	setActive(var12_16, var15_16 == 0)
	setActive(var13_16, var15_16 == 1)
	setActive(var14_16, var15_16 == 2)
	onButton(arg0_16, var12_16, function()
		arg0_16:emit(ActivityMediator.ON_TASK_GO, var3_16)
	end, SFX_PANEL)
	onButton(arg0_16, var13_16, function()
		local var0_19 = {}
		local var1_19 = var3_16:getConfig("award_display")
		local var2_19 = getProxy(PlayerProxy):getRawData()
		local var3_19 = pg.gameset.urpt_chapter_max.description[1]
		local var4_19 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_19)
		local var5_19, var6_19 = Task.StaticJudgeOverflow(var2_19.gold, var2_19.oil, var4_19, true, true, var1_19)

		if var5_19 then
			table.insert(var0_19, function(arg0_20)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_19,
					onYes = arg0_20
				})
			end)
		end

		seriesAsync(var0_19, function()
			arg0_16:emit(ActivityMediator.ON_TASK_SUBMIT, var3_16)
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_22)
	arg0_22.nday = arg0_22:getTaskIdx(arg0_22.activity)

	if arg0_22.dayTF then
		setText(arg0_22.dayTF, arg0_22.nday)
		setText(arg0_22.maxDayTF, "/" .. #arg0_22.taskGroup)
	end

	arg0_22:LocalFresh(arg0_22.nday)
	arg0_22.uilist:align(#arg0_22.taskGroup[arg0_22.nday])

	if arg0_22.taskWindow:isShowing() then
		arg0_22.taskWindow:ExecuteAction("Show", arg0_22.activity)
	end
end

function var0_0.getTaskIdx(arg0_23, arg1_23)
	local var0_23 = 1
	local var1_23 = arg1_23:getNDay()
	local var2_23 = #arg0_23.taskGroup
	local var3_23 = math.min(var1_23, var2_23)
	local var4_23 = true

	for iter0_23 = 1, var3_23 do
		if not var4_23 then
			break
		end

		var0_23 = iter0_23

		if iter0_23 < var3_23 then
			for iter1_23, iter2_23 in ipairs(arg0_23.taskGroup[iter0_23]) do
				if not arg0_23:isTaskFinished(iter2_23) then
					var4_23 = false

					break
				end
			end
		end
	end

	return math.min(var0_23, var2_23)
end

function var0_0.isTaskFinished(arg0_24, arg1_24)
	if not arg0_24.taskProxy then
		arg0_24.taskProxy = getProxy(TaskProxy)
	end

	local var0_24 = arg0_24.taskProxy:getTaskById(arg1_24) or arg0_24.taskProxy:getFinishTaskById(arg1_24)

	return var0_24 and var0_24:getTaskStatus() == 2
end

function var0_0.GetProgressColor(arg0_25)
	return "#ffbc46", "#52514a"
end

function var0_0.OnHideFlush(arg0_26)
	if arg0_26.taskWindow:isShowing() then
		arg0_26.taskWindow:Hide()
	end
end

function var0_0.OnDestroy(arg0_27)
	if arg0_27.taskWindow then
		arg0_27.taskWindow:Hide()
		arg0_27.taskWindow:Destroy()

		arg0_27.taskWindow = nil
	end
end

return var0_0
