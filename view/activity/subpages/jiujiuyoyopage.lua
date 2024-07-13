local var0_0 = class("JiujiuYoyoPage", import("...base.BaseActivityPage"))
local var1_0 = PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_CHT

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.taskBtn = arg0_1:findTF("task_btn", arg0_1.bg)
	arg0_1.taskRedDot = arg0_1:findTF("red_dot", arg0_1.taskBtn)
	arg0_1.ticketNumTF = arg0_1:findTF("ticket_num", arg0_1.bg)
	arg0_1.rollingCountTF = arg0_1:findTF("rolling_count", arg0_1.bg)
	arg0_1.rollingBlink = arg0_1:findTF("blink", arg0_1.bg)

	if var1_0 then
		arg0_1.awardTpl = arg0_1:findTF("item_jp", arg0_1.bg)
		arg0_1.awardContainter = arg0_1:findTF("award_list_jp", arg0_1.bg)
	else
		arg0_1.awardTpl = arg0_1:findTF("item", arg0_1.bg)
		arg0_1.awardContainter = arg0_1:findTF("award_list", arg0_1.bg)
	end

	arg0_1.awardUIList = UIItemList.New(arg0_1.awardContainter, arg0_1.awardTpl)
	arg0_1.finalGot = arg0_1:findTF("final_got_jp", arg0_1.bg)
	arg0_1.rollingAni = arg0_1:findTF("rolling_mask", arg0_1.bg)
	arg0_1.rollingSpine = arg0_1:findTF("rolling", arg0_1.rollingAni):GetComponent("SpineAnimUI")
	arg0_1.rollingGraphic = arg0_1:findTF("rolling", arg0_1.rollingAni):GetComponent("SkeletonGraphic")
	arg0_1.forbidMask = arg0_1:findTF("forbid_mask", arg0_1.bg)
	arg0_1.taskWindow = arg0_1:findTF("TaskWindow")
	arg0_1.closeBtn = arg0_1:findTF("panel/close_btn", arg0_1.taskWindow)
	arg0_1.taskTpl = arg0_1:findTF("panel/scrollview/item", arg0_1.taskWindow)
	arg0_1.taskContainter = arg0_1:findTF("panel/scrollview/items", arg0_1.taskWindow)
	arg0_1.taskUIList = UIItemList.New(arg0_1.taskContainter, arg0_1.taskTpl)

	arg0_1:register()
end

function var0_0.register(arg0_2)
	arg0_2:bind(ActivityMediator.ON_SHAKE_BEADS_RESULT, function(arg0_3, arg1_3)
		arg0_2:displayResult(arg1_3.awards, arg1_3.number, function()
			arg1_3.callback()
		end)
	end)
end

function var0_0.OnDataSetting(arg0_5)
	arg0_5.taskProxy = getProxy(TaskProxy)

	local var0_5 = arg0_5.activity:getConfig("config_client").taskActID

	arg0_5.taskList = pg.activity_template[var0_5].config_data
	arg0_5.startTime = arg0_5.activity:getStartTime()
	arg0_5.totalNumList = {}
	arg0_5.remainNumList = {}
	arg0_5.remainTotalNum = 0
	arg0_5.awardList = {}
	arg0_5.finalAward = arg0_5.activity:getConfig("config_client").finalAward
	arg0_5.awardConifg = arg0_5.activity:getConfig("config_client").award
	arg0_5.beadsConfig = arg0_5.activity:getConfig("config_data")[1]

	for iter0_5, iter1_5 in ipairs(arg0_5.beadsConfig) do
		local var1_5 = iter1_5[1]

		arg0_5.awardList[var1_5] = arg0_5.awardConifg[var1_5]
		arg0_5.totalNumList[var1_5] = iter1_5[2]
	end
end

function var0_0.OnFirstFlush(arg0_6)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("tips_shakebeads")
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.taskBtn, function()
		arg0_6:openTask()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.closeBtn, function()
		arg0_6:closeTask()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6:findTF("mask", arg0_6.taskWindow), function()
		arg0_6:closeTask()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rollingBlink, function()
		if arg0_6.ticketNum <= 0 then
			return
		end

		arg0_6:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_6.activity.id
		})
	end, SFX_PANEL)
	setActive(arg0_6.taskRedDot, false)

	if LeanTween.isTweening(arg0_6.rollingBlink) then
		LeanTween.cancel(arg0_6.rollingBlink)
	end

	setImageAlpha(arg0_6.rollingBlink, 1)
	blinkAni(arg0_6.rollingBlink, 0.5)
end

function var0_0.OnUpdateFlush(arg0_12)
	arg0_12.curDay = pg.TimeMgr.GetInstance():DiffDay(arg0_12.startTime, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_12.ticketNum = arg0_12.activity.data1
	arg0_12.hasNumList = arg0_12.activity.data1KeyValueList[1]
	arg0_12.remainTotalNum = 0

	for iter0_12, iter1_12 in ipairs(arg0_12.beadsConfig) do
		local var0_12 = iter1_12[1]

		if not arg0_12.hasNumList[var0_12] then
			arg0_12.hasNumList[var0_12] = 0
		end

		arg0_12.remainNumList[var0_12] = arg0_12.totalNumList[var0_12] - arg0_12.hasNumList[var0_12]
		arg0_12.remainTotalNum = arg0_12.remainTotalNum + arg0_12.remainNumList[var0_12]
	end

	setText(arg0_12.ticketNumTF, arg0_12.ticketNum)
	setText(arg0_12.rollingCountTF, arg0_12.remainTotalNum)
	setActive(arg0_12.rollingBlink, arg0_12.ticketNum > 0)
	arg0_12:initAwardList()
	arg0_12:initTaskWindow()

	arg0_12.isFirst = PlayerPrefs.GetInt("jiujiuyoyo_first_" .. getProxy(PlayerProxy):getData().id)

	if arg0_12.isFirst == 0 then
		setActive(arg0_12.taskRedDot, true)
	end

	if #arg0_12.finishItemList > 0 then
		arg0_12:openTask()
	end

	setActive(arg0_12.finalGot, var1_0 and arg0_12.activity.data2 == 1)
	arg0_12:CheckFinalAward()
end

function var0_0.initAwardList(arg0_13)
	arg0_13.awardUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_14 + 1
			local var1_14 = arg0_13.totalNumList[var0_14]
			local var2_14 = arg0_13.remainNumList[var0_14]

			if var2_14 == 0 then
				setTextColor(arg0_13:findTF("num", arg2_14), Color.New(0.55, 0.55, 0.55, 1))
				setOutlineColor(arg0_13:findTF("num", arg2_14), Color.New(0.26, 0.26, 0.26, 1))
			end

			setText(arg0_13:findTF("num", arg2_14), var2_14 .. "/" .. var1_14)
			setActive(arg0_13:findTF("got", arg2_14), var2_14 == 0)

			local var3_14 = arg0_13:findTF("award_mask/award", arg2_14)
			local var4_14 = arg0_13.awardList[var0_14]
			local var5_14 = {
				type = var4_14[1],
				id = var4_14[2],
				count = var4_14[3] * var2_14
			}

			updateDrop(var3_14, var5_14)
			onButton(arg0_13, var3_14, function()
				arg0_13:emit(BaseUI.ON_DROP, var5_14)
			end, SFX_PANEL)
		end
	end)
	arg0_13.awardUIList:align(#arg0_13.awardList)
end

function var0_0.initTaskWindow(arg0_16)
	arg0_16.finishItemList = {}
	arg0_16.finishTaskVOList = {}

	arg0_16.taskUIList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg1_17 + 1
			local var1_17 = arg0_16:findTF("award/award", arg2_17)
			local var2_17 = arg0_16.taskList[var0_17]
			local var3_17 = arg0_16.taskProxy:getTaskById(var2_17) or arg0_16.taskProxy:getFinishTaskById(var2_17)

			assert(var3_17, "without this task by id: " .. var2_17)

			local var4_17 = var3_17:getProgress()
			local var5_17 = var3_17:getConfig("target_num")
			local var6_17 = var3_17:getTaskStatus()
			local var7_17 = var3_17:getConfig("desc")
			local var8_17 = var3_17:getConfig("award_display")[1]
			local var9_17 = var0_17 > arg0_16.curDay

			setText(arg0_16:findTF("description", arg2_17), var7_17)
			setText(arg0_16:findTF("progress/progressText", arg2_17), var4_17 .. "/" .. var5_17)
			setSlider(arg0_16:findTF("progress", arg2_17), 0, var5_17, var4_17)

			local var10_17 = {
				type = var8_17[1],
				id = var8_17[2],
				count = var8_17[3]
			}

			updateDrop(var1_17, var10_17)
			onButton(arg0_16, arg0_16:findTF("award/Image", arg2_17), function()
				arg0_16:emit(BaseUI.ON_DROP, var10_17)
			end, SFX_PANEL)

			local var11_17 = arg0_16:findTF("go_btn", arg2_17)
			local var12_17 = arg0_16:findTF("get_btn", arg2_17)

			setActive(var11_17, var6_17 == 0)
			setActive(var12_17, var6_17 == 1)
			onButton(arg0_16, var11_17, function()
				arg0_16:emit(ActivityMediator.ON_TASK_GO, var3_17)
			end, SFX_PANEL)
			onButton(arg0_16, var12_17, function()
				arg0_16:emit(ActivityMediator.ON_TASK_SUBMIT, var3_17)
			end, SFX_PANEL)
			setActive(arg0_16:findTF("finnal", arg2_17), var6_17 == 2 and not var9_17)
			setText(arg0_16:findTF("lock/tip", arg2_17), i18n("unlock_tips", var0_17))
			setActive(arg0_16:findTF("lock", arg2_17), var9_17)

			if var6_17 == 1 and not var9_17 then
				table.insert(arg0_16.finishItemList, arg2_17)
				table.insert(arg0_16.finishTaskVOList, var3_17)
			end
		end
	end)
	arg0_16.taskUIList:align(#arg0_16.taskList)
end

function var0_0.closeTask(arg0_21)
	setActive(arg0_21.taskWindow, false)
end

function var0_0.openTask(arg0_22)
	setActive(arg0_22.taskWindow, true)

	if arg0_22.isFirst == 0 then
		PlayerPrefs.SetInt("jiujiuyoyo_first_" .. getProxy(PlayerProxy):getData().id, 1)
		setActive(arg0_22.taskRedDot, false)
	end

	arg0_22.hasClickTask = true

	eachChild(arg0_22.taskContainter, function(arg0_23)
		if isActive(arg0_22:findTF("finnal", arg0_23)) then
			arg0_23:SetAsLastSibling()
		end
	end)

	if #arg0_22.finishItemList > 0 then
		arg0_22:autoFinishTask()
	end
end

function var0_0.autoFinishTask(arg0_24)
	local var0_24 = 0.01
	local var1_24 = 0.5

	for iter0_24, iter1_24 in ipairs(arg0_24.finishItemList) do
		local var2_24 = GetOrAddComponent(iter1_24, typeof(CanvasGroup))

		arg0_24:managedTween(LeanTween.delayedCall, function()
			iter1_24:SetAsFirstSibling()
			LeanTween.value(go(iter1_24), 1, 0, var1_24):setOnUpdate(System.Action_float(function(arg0_26)
				var2_24.alpha = arg0_26
			end)):setOnComplete(System.Action(function()
				var2_24.alpha = 1

				setActive(arg0_24:findTF("finnal", iter1_24), true)
				iter1_24:SetAsLastSibling()
			end))
		end, var0_24, nil)

		var0_24 = var0_24 + var1_24 + 0.1
	end

	arg0_24:managedTween(LeanTween.delayedCall, function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg0_24.finishTaskVOList
		})
	end, var0_24, nil)
end

function var0_0.CheckFinalAward(arg0_29)
	if var1_0 and arg0_29.activity.data2 == 0 and arg0_29.remainTotalNum == 0 then
		arg0_29:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = arg0_29.activity.id
		})
	end
end

function var0_0.displayResult(arg0_30, arg1_30, arg2_30, arg3_30)
	arg0_30:setForbidMaskStatus(true)
	setActive(arg0_30.rollingAni, true)

	function arg0_30.aniCallback()
		arg3_30()
	end

	arg0_30.rollingSpine:SetActionCallBack(function(arg0_32)
		if arg0_32 == "finish" then
			setActive(arg0_30.rollingAni, false)
			arg3_30()

			arg0_30.aniCallback = nil

			arg0_30:setForbidMaskStatus(false)
		end
	end)
	arg0_30.rollingSpine:SetAction(tostring(arg2_30), 0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/zhuanzhu")
	arg0_30:managedTween(LeanTween.delayedCall, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/zhengque")
	end, 4, nil)
end

function var0_0.setForbidMaskStatus(arg0_34, arg1_34)
	if arg1_34 then
		setActive(arg0_34.forbidMask, true)
		pg.UIMgr.GetInstance():OverlayPanel(arg0_34.forbidMask)
	else
		setActive(arg0_34.forbidMask, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_34.forbidMask, arg0_34.bg)
	end
end

function var0_0.canFinishTask()
	local var0_35 = pg.activity_template[ActivityConst.JIUJIU_YOYO_ID]
	local var1_35 = var0_35.config_client.taskActID
	local var2_35 = pg.activity_template[var1_35].config_data
	local var3_35 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_35.time[2])
	local var4_35 = pg.TimeMgr.GetInstance():DiffDay(var3_35, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	local var5_35 = false
	local var6_35 = getProxy(TaskProxy)

	for iter0_35, iter1_35 in pairs(var2_35) do
		local var7_35 = var4_35 < iter0_35
		local var8_35 = var6_35:getTaskById(iter1_35) or var6_35:getFinishTaskById(iter1_35)

		assert(var8_35, "without this task by id: " .. iter1_35)

		if var8_35:getTaskStatus() == 1 and not var7_35 then
			var5_35 = true

			break
		end
	end

	return var5_35
end

function var0_0.IsShowRed()
	return getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_YOYO_ID).data1 > 0 or var0_0.canFinishTask()
end

return var0_0
