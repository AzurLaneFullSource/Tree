local var0 = class("JiujiuYoyoPage", import("...base.BaseActivityPage"))
local var1 = PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_CHT

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.taskBtn = arg0:findTF("task_btn", arg0.bg)
	arg0.taskRedDot = arg0:findTF("red_dot", arg0.taskBtn)
	arg0.ticketNumTF = arg0:findTF("ticket_num", arg0.bg)
	arg0.rollingCountTF = arg0:findTF("rolling_count", arg0.bg)
	arg0.rollingBlink = arg0:findTF("blink", arg0.bg)

	if var1 then
		arg0.awardTpl = arg0:findTF("item_jp", arg0.bg)
		arg0.awardContainter = arg0:findTF("award_list_jp", arg0.bg)
	else
		arg0.awardTpl = arg0:findTF("item", arg0.bg)
		arg0.awardContainter = arg0:findTF("award_list", arg0.bg)
	end

	arg0.awardUIList = UIItemList.New(arg0.awardContainter, arg0.awardTpl)
	arg0.finalGot = arg0:findTF("final_got_jp", arg0.bg)
	arg0.rollingAni = arg0:findTF("rolling_mask", arg0.bg)
	arg0.rollingSpine = arg0:findTF("rolling", arg0.rollingAni):GetComponent("SpineAnimUI")
	arg0.rollingGraphic = arg0:findTF("rolling", arg0.rollingAni):GetComponent("SkeletonGraphic")
	arg0.forbidMask = arg0:findTF("forbid_mask", arg0.bg)
	arg0.taskWindow = arg0:findTF("TaskWindow")
	arg0.closeBtn = arg0:findTF("panel/close_btn", arg0.taskWindow)
	arg0.taskTpl = arg0:findTF("panel/scrollview/item", arg0.taskWindow)
	arg0.taskContainter = arg0:findTF("panel/scrollview/items", arg0.taskWindow)
	arg0.taskUIList = UIItemList.New(arg0.taskContainter, arg0.taskTpl)

	arg0:register()
end

function var0.register(arg0)
	arg0:bind(ActivityMediator.ON_SHAKE_BEADS_RESULT, function(arg0, arg1)
		arg0:displayResult(arg1.awards, arg1.number, function()
			arg1.callback()
		end)
	end)
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)

	local var0 = arg0.activity:getConfig("config_client").taskActID

	arg0.taskList = pg.activity_template[var0].config_data
	arg0.startTime = arg0.activity:getStartTime()
	arg0.totalNumList = {}
	arg0.remainNumList = {}
	arg0.remainTotalNum = 0
	arg0.awardList = {}
	arg0.finalAward = arg0.activity:getConfig("config_client").finalAward
	arg0.awardConifg = arg0.activity:getConfig("config_client").award
	arg0.beadsConfig = arg0.activity:getConfig("config_data")[1]

	for iter0, iter1 in ipairs(arg0.beadsConfig) do
		local var1 = iter1[1]

		arg0.awardList[var1] = arg0.awardConifg[var1]
		arg0.totalNumList[var1] = iter1[2]
	end
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("tips_shakebeads")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.taskBtn, function()
		arg0:openTask()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeTask()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("mask", arg0.taskWindow), function()
		arg0:closeTask()
	end, SFX_PANEL)
	onButton(arg0, arg0.rollingBlink, function()
		if arg0.ticketNum <= 0 then
			return
		end

		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)
	setActive(arg0.taskRedDot, false)

	if LeanTween.isTweening(arg0.rollingBlink) then
		LeanTween.cancel(arg0.rollingBlink)
	end

	setImageAlpha(arg0.rollingBlink, 1)
	blinkAni(arg0.rollingBlink, 0.5)
end

function var0.OnUpdateFlush(arg0)
	arg0.curDay = pg.TimeMgr.GetInstance():DiffDay(arg0.startTime, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0.ticketNum = arg0.activity.data1
	arg0.hasNumList = arg0.activity.data1KeyValueList[1]
	arg0.remainTotalNum = 0

	for iter0, iter1 in ipairs(arg0.beadsConfig) do
		local var0 = iter1[1]

		if not arg0.hasNumList[var0] then
			arg0.hasNumList[var0] = 0
		end

		arg0.remainNumList[var0] = arg0.totalNumList[var0] - arg0.hasNumList[var0]
		arg0.remainTotalNum = arg0.remainTotalNum + arg0.remainNumList[var0]
	end

	setText(arg0.ticketNumTF, arg0.ticketNum)
	setText(arg0.rollingCountTF, arg0.remainTotalNum)
	setActive(arg0.rollingBlink, arg0.ticketNum > 0)
	arg0:initAwardList()
	arg0:initTaskWindow()

	arg0.isFirst = PlayerPrefs.GetInt("jiujiuyoyo_first_" .. getProxy(PlayerProxy):getData().id)

	if arg0.isFirst == 0 then
		setActive(arg0.taskRedDot, true)
	end

	if #arg0.finishItemList > 0 then
		arg0:openTask()
	end

	setActive(arg0.finalGot, var1 and arg0.activity.data2 == 1)
	arg0:CheckFinalAward()
end

function var0.initAwardList(arg0)
	arg0.awardUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.totalNumList[var0]
			local var2 = arg0.remainNumList[var0]

			if var2 == 0 then
				setTextColor(arg0:findTF("num", arg2), Color.New(0.55, 0.55, 0.55, 1))
				setOutlineColor(arg0:findTF("num", arg2), Color.New(0.26, 0.26, 0.26, 1))
			end

			setText(arg0:findTF("num", arg2), var2 .. "/" .. var1)
			setActive(arg0:findTF("got", arg2), var2 == 0)

			local var3 = arg0:findTF("award_mask/award", arg2)
			local var4 = arg0.awardList[var0]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3] * var2
			}

			updateDrop(var3, var5)
			onButton(arg0, var3, function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)
		end
	end)
	arg0.awardUIList:align(#arg0.awardList)
end

function var0.initTaskWindow(arg0)
	arg0.finishItemList = {}
	arg0.finishTaskVOList = {}

	arg0.taskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("award/award", arg2)
			local var2 = arg0.taskList[var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			assert(var3, "without this task by id: " .. var2)

			local var4 = var3:getProgress()
			local var5 = var3:getConfig("target_num")
			local var6 = var3:getTaskStatus()
			local var7 = var3:getConfig("desc")
			local var8 = var3:getConfig("award_display")[1]
			local var9 = var0 > arg0.curDay

			setText(arg0:findTF("description", arg2), var7)
			setText(arg0:findTF("progress/progressText", arg2), var4 .. "/" .. var5)
			setSlider(arg0:findTF("progress", arg2), 0, var5, var4)

			local var10 = {
				type = var8[1],
				id = var8[2],
				count = var8[3]
			}

			updateDrop(var1, var10)
			onButton(arg0, arg0:findTF("award/Image", arg2), function()
				arg0:emit(BaseUI.ON_DROP, var10)
			end, SFX_PANEL)

			local var11 = arg0:findTF("go_btn", arg2)
			local var12 = arg0:findTF("get_btn", arg2)

			setActive(var11, var6 == 0)
			setActive(var12, var6 == 1)
			onButton(arg0, var11, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var3)
			end, SFX_PANEL)
			onButton(arg0, var12, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end, SFX_PANEL)
			setActive(arg0:findTF("finnal", arg2), var6 == 2 and not var9)
			setText(arg0:findTF("lock/tip", arg2), i18n("unlock_tips", var0))
			setActive(arg0:findTF("lock", arg2), var9)

			if var6 == 1 and not var9 then
				table.insert(arg0.finishItemList, arg2)
				table.insert(arg0.finishTaskVOList, var3)
			end
		end
	end)
	arg0.taskUIList:align(#arg0.taskList)
end

function var0.closeTask(arg0)
	setActive(arg0.taskWindow, false)
end

function var0.openTask(arg0)
	setActive(arg0.taskWindow, true)

	if arg0.isFirst == 0 then
		PlayerPrefs.SetInt("jiujiuyoyo_first_" .. getProxy(PlayerProxy):getData().id, 1)
		setActive(arg0.taskRedDot, false)
	end

	arg0.hasClickTask = true

	eachChild(arg0.taskContainter, function(arg0)
		if isActive(arg0:findTF("finnal", arg0)) then
			arg0:SetAsLastSibling()
		end
	end)

	if #arg0.finishItemList > 0 then
		arg0:autoFinishTask()
	end
end

function var0.autoFinishTask(arg0)
	local var0 = 0.01
	local var1 = 0.5

	for iter0, iter1 in ipairs(arg0.finishItemList) do
		local var2 = GetOrAddComponent(iter1, typeof(CanvasGroup))

		arg0:managedTween(LeanTween.delayedCall, function()
			iter1:SetAsFirstSibling()
			LeanTween.value(go(iter1), 1, 0, var1):setOnUpdate(System.Action_float(function(arg0)
				var2.alpha = arg0
			end)):setOnComplete(System.Action(function()
				var2.alpha = 1

				setActive(arg0:findTF("finnal", iter1), true)
				iter1:SetAsLastSibling()
			end))
		end, var0, nil)

		var0 = var0 + var1 + 0.1
	end

	arg0:managedTween(LeanTween.delayedCall, function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg0.finishTaskVOList
		})
	end, var0, nil)
end

function var0.CheckFinalAward(arg0)
	if var1 and arg0.activity.data2 == 0 and arg0.remainTotalNum == 0 then
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = arg0.activity.id
		})
	end
end

function var0.displayResult(arg0, arg1, arg2, arg3)
	arg0:setForbidMaskStatus(true)
	setActive(arg0.rollingAni, true)

	function arg0.aniCallback()
		arg3()
	end

	arg0.rollingSpine:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			setActive(arg0.rollingAni, false)
			arg3()

			arg0.aniCallback = nil

			arg0:setForbidMaskStatus(false)
		end
	end)
	arg0.rollingSpine:SetAction(tostring(arg2), 0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/zhuanzhu")
	arg0:managedTween(LeanTween.delayedCall, function()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/zhengque")
	end, 4, nil)
end

function var0.setForbidMaskStatus(arg0, arg1)
	if arg1 then
		setActive(arg0.forbidMask, true)
		pg.UIMgr.GetInstance():OverlayPanel(arg0.forbidMask)
	else
		setActive(arg0.forbidMask, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.forbidMask, arg0.bg)
	end
end

function var0.canFinishTask()
	local var0 = pg.activity_template[ActivityConst.JIUJIU_YOYO_ID]
	local var1 = var0.config_client.taskActID
	local var2 = pg.activity_template[var1].config_data
	local var3 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.time[2])
	local var4 = pg.TimeMgr.GetInstance():DiffDay(var3, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	local var5 = false
	local var6 = getProxy(TaskProxy)

	for iter0, iter1 in pairs(var2) do
		local var7 = var4 < iter0
		local var8 = var6:getTaskById(iter1) or var6:getFinishTaskById(iter1)

		assert(var8, "without this task by id: " .. iter1)

		if var8:getTaskStatus() == 1 and not var7 then
			var5 = true

			break
		end
	end

	return var5
end

function var0.IsShowRed()
	return getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_YOYO_ID).data1 > 0 or var0.canFinishTask()
end

return var0
