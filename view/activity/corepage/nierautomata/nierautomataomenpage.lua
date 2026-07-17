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

function var0_0.InvalidateWriter(arg0_7)
	arg0_7.writerToken = (arg0_7.writerToken or 0) + 1

	if arg0_7.desc1 then
		GetOrAddComponent(arg0_7.desc1, typeof(Typewriter)).endFunc = nil
	end

	if arg0_7.desc2 then
		GetOrAddComponent(arg0_7.desc2, typeof(Typewriter)).endFunc = nil
	end
end

function var0_0.Playwriter(arg0_8)
	arg0_8:InvalidateWriter()

	local var0_8 = arg0_8.writerToken

	local function var1_8()
		return arg0_8.writerToken == var0_8 and arg0_8._go and isActive(arg0_8._go)
	end

	local var2_8 = {}

	if not arg0_8.finishAll then
		table.insert(var2_8, function(arg0_10)
			if not var1_8() then
				return
			end

			local var0_10 = arg0_8.desc1
			local var1_10 = GetOrAddComponent(var0_10, typeof(Typewriter))

			function var1_10.endFunc()
				if not var1_8() then
					return
				end

				arg0_10()
			end

			var1_10:setSpeed(arg0_8:GetTypewriterSpeed())
			var1_10:Play()
		end)
	else
		table.insert(var2_8, function(arg0_12)
			if not var1_8() then
				return
			end

			local var0_12 = arg0_8.activity:getConfig("config_client").story
			local var1_12 = checkExist(var0_12, {
				arg0_8.nday
			}, {
				1
			})

			if var1_12 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_12) then
				pg.NewStoryMgr.GetInstance():Play(var1_12, function()
					if not var1_8() then
						return
					end

					arg0_12()
				end)
			else
				arg0_12()
			end
		end)
	end

	table.insert(var2_8, function(arg0_14)
		if not var1_8() then
			return
		end

		local var0_14 = arg0_8.desc2

		setActive(arg0_8.desc2, true)

		local var1_14 = GetOrAddComponent(var0_14, typeof(Typewriter))

		function var1_14.endFunc()
			if not var1_8() then
				return
			end

			arg0_14()
		end

		var1_14:setSpeed(arg0_8:GetTypewriterSpeed())
		var1_14:Play()
	end)
	seriesAsync(var2_8)
end

function var0_0.LocalFresh(arg0_16, arg1_16)
	local var0_16 = "nier_a2_text_block_day"
	local var1_16

	arg0_16.finishAll = arg1_16 >= 7 and arg0_16:lastFinish()

	if arg0_16.finishAll then
		var1_16 = i18n(var0_16 .. "_fin")

		setActive(arg0_16.desc1, false)
	else
		var1_16 = i18n(var0_16 .. arg1_16)

		setText(arg0_16.desc1, var1_16[1].info)
	end

	setText(arg0_16.desc2, var1_16[2].info)
	setActive(arg0_16.desc2, false)
	arg0_16:Playwriter()
end

function var0_0.lastFinish(arg0_17)
	local var0_17 = arg0_17.taskGroup[#arg0_17.taskGroup]
	local var1_17 = getProxy(TaskProxy):getTaskVO(var0_17[1])
	local var2_17 = getProxy(TaskProxy):getTaskVO(var0_17[2])

	return var1_17:getTaskStatus() == 2 and var2_17:getTaskStatus() == 2
end

function var0_0.UpdateTask(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18 + 1
	local var1_18 = arg2_18:Find("item")
	local var2_18 = arg0_18.taskGroup[arg0_18.nday][var0_18]
	local var3_18 = arg0_18.taskProxy:getTaskById(var2_18) or arg0_18.taskProxy:getFinishTaskById(var2_18)

	assert(var3_18, "without this task by id: " .. var2_18)

	local var4_18 = Drop.Create(var3_18:getConfig("award_display")[1])

	updateDrop(var1_18, var4_18)
	onButton(arg0_18, var1_18, function()
		arg0_18:emit(BaseUI.ON_DROP, var4_18)
	end, SFX_PANEL)

	local var5_18 = var3_18:getProgress()
	local var6_18 = var3_18:getConfig("target_num")
	local var7_18 = var3_18:getConfig("desc")

	if utf8.len(var7_18) >= 11 then
		setScrollText(arg2_18:Find("mask/description"), var7_18)
	else
		setText(arg2_18:Find("mask/description"), var7_18)
	end

	local var8_18, var9_18 = arg0_18:GetProgressColor()
	local var10_18

	var10_18 = var8_18 and setColorStr(var5_18, var8_18) or var5_18

	local var11_18

	var11_18 = var9_18 and setColorStr("/" .. var6_18, var9_18) or "/" .. var6_18

	setText(arg2_18:Find("progressText"), var10_18 .. var11_18)
	setSlider(arg2_18:Find("progress"), 0, var6_18, var5_18)

	local var12_18 = arg2_18:Find("go_btn")
	local var13_18 = arg2_18:Find("get_btn")
	local var14_18 = arg2_18:Find("got_btn")
	local var15_18 = var3_18:getTaskStatus()

	setActive(var12_18, var15_18 == 0)
	setActive(var13_18, var15_18 == 1)
	setActive(var14_18, var15_18 == 2)
	onButton(arg0_18, var12_18, function()
		arg0_18:emit(ActivityMediator.ON_TASK_GO, var3_18)
	end, SFX_PANEL)
	onButton(arg0_18, var13_18, function()
		local var0_21 = {}
		local var1_21 = var3_18:getConfig("award_display")
		local var2_21 = getProxy(PlayerProxy):getRawData()
		local var3_21 = pg.gameset.urpt_chapter_max.description[1]
		local var4_21 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_21)
		local var5_21, var6_21 = Task.StaticJudgeOverflow(var2_21.gold, var2_21.oil, var4_21, true, true, var1_21)

		if var5_21 then
			table.insert(var0_21, function(arg0_22)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_21,
					onYes = arg0_22
				})
			end)
		end

		seriesAsync(var0_21, function()
			arg0_18:emit(ActivityMediator.ON_TASK_SUBMIT, var3_18)
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_24)
	arg0_24.nday = arg0_24:getTaskIdx(arg0_24.activity)

	if arg0_24.dayTF then
		setText(arg0_24.dayTF, arg0_24.nday)
		setText(arg0_24.maxDayTF, "/" .. #arg0_24.taskGroup)
	end

	arg0_24:LocalFresh(arg0_24.nday)
	arg0_24.uilist:align(#arg0_24.taskGroup[arg0_24.nday])

	if arg0_24.taskWindow:isShowing() then
		arg0_24.taskWindow:ExecuteAction("Show", arg0_24.activity)
	end
end

function var0_0.getTaskIdx(arg0_25, arg1_25)
	local var0_25 = 1
	local var1_25 = arg1_25:getNDay()
	local var2_25 = #arg0_25.taskGroup
	local var3_25 = math.min(var1_25, var2_25)
	local var4_25 = true

	for iter0_25 = 1, var3_25 do
		if not var4_25 then
			break
		end

		var0_25 = iter0_25

		if iter0_25 < var3_25 then
			for iter1_25, iter2_25 in ipairs(arg0_25.taskGroup[iter0_25]) do
				if not arg0_25:isTaskFinished(iter2_25) then
					var4_25 = false

					break
				end
			end
		end
	end

	return math.min(var0_25, var2_25)
end

function var0_0.isTaskFinished(arg0_26, arg1_26)
	if not arg0_26.taskProxy then
		arg0_26.taskProxy = getProxy(TaskProxy)
	end

	local var0_26 = arg0_26.taskProxy:getTaskById(arg1_26) or arg0_26.taskProxy:getFinishTaskById(arg1_26)

	return var0_26 and var0_26:getTaskStatus() == 2
end

function var0_0.GetProgressColor(arg0_27)
	return "#ffbc46", "#52514a"
end

function var0_0.OnHideFlush(arg0_28)
	arg0_28:InvalidateWriter()

	if arg0_28.taskWindow:isShowing() then
		arg0_28.taskWindow:Hide()
	end
end

function var0_0.OnDestroy(arg0_29)
	arg0_29:InvalidateWriter()

	if arg0_29.taskWindow then
		arg0_29.taskWindow:Hide()
		arg0_29.taskWindow:Destroy()

		arg0_29.taskWindow = nil
	end
end

return var0_0
