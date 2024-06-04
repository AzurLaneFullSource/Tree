local var0 = class("SenrankaguraTaskPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.activityProxy = getProxy(ActivityProxy)

	arg0:findUI()
end

function var0.OnDataSetting(arg0)
	arg0.configID = arg0.activity:getConfig("config_id")
	arg0.configData = pg.activity_event_turning[arg0.configID]
	arg0.groupNum = arg0.configData.total_num
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0:getCurIndex()

	if arg0.markClickPos and arg0.markClickPos > 0 then
		print("有操作再更新任务面板")
		arg0:openTaskAni()
	elseif var0 > 0 then
		if arg0.activity.data4 <= arg0.groupNum then
			print("直接更新任务面板")
			arg0:updateTaskPanel()
			setActive(arg0.posPanel, false)
			setActive(arg0.taskPanel, true)
		end
	elseif var0 == 0 then
		arg0:updatePosPanel()
		setActive(arg0.posPanel, true)
		setActive(arg0.taskPanel, false)

		if arg0:getStep() > arg0.groupNum then
			-- block empty
		end
	end

	arg0:check()
	arg0:updateLogText()
end

function var0.onDestroy(arg0)
	return
end

function var0.findUI(arg0)
	local var0 = arg0:findTF("IconList")

	arg0.nameList = {
		"feiniao",
		"banjiu",
		"yan",
		"xuequan",
		"xuebugui",
		"zi",
		"xishao"
	}
	arg0.paintingList = {
		"asuka",
		"ikaruga",
		"homura",
		"yumi",
		"fubuki",
		"murasaki",
		"yuuyaki"
	}
	arg0.iconSpriteDict = {}

	for iter0, iter1 in ipairs(arg0.nameList) do
		local var1 = arg0:findTF(iter1, var0)
		local var2 = getImageSprite(var1)

		arg0.iconSpriteDict[iter0] = var2
		arg0.iconSpriteDict[iter1] = var2
	end

	local var3 = arg0:findTF("HXList")
	local var4 = {
		"feiniao",
		"yan",
		"xuequan",
		"xuebugui",
		"xishao"
	}

	arg0.hxSpriteDict = {}

	for iter2, iter3 in ipairs(var4) do
		local var5 = arg0:findTF(iter3, var3)
		local var6 = getImageSprite(var5)

		arg0.hxSpriteDict[iter3] = var6
	end

	arg0.hxPosDict = {
		feiniao = {
			x = -47,
			y = -7
		},
		yan = {
			x = 24,
			y = -176
		},
		xuequan = {
			x = -92,
			y = -126
		},
		xuebugui = {
			x = 5,
			y = 22
		},
		xishao = {
			x = -86,
			y = -21
		}
	}
	arg0.paintingPosDict = {
		feiniao = {
			x = 42,
			y = -22
		},
		banjiu = {
			x = 23,
			y = -8
		},
		yan = {
			x = -11,
			y = 20
		},
		xuequan = {
			x = 39,
			y = 30
		},
		xuebugui = {
			x = 26,
			y = 12
		},
		zi = {
			x = 46,
			y = 36
		},
		xishao = {
			x = 20,
			y = -1
		}
	}
	arg0.posPanel = arg0:findTF("PosPanel")
	arg0.finalLockTF = arg0:findTF("FinalAward/Lock", arg0.posPanel)
	arg0.finalGotTF = arg0:findTF("FinalAward/Got", arg0.posPanel)
	arg0.posTFList = {}

	local var7 = arg0:findTF("PosList", arg0.posPanel)

	for iter4 = 1, #arg0.nameList do
		local var8 = arg0:findTF(iter4, var7)

		table.insert(arg0.posTFList, var8)

		local var9 = arg0:findTF("Get", var8)

		onButton(arg0, var9, function()
			local var0 = arg0:getStep()

			if var0 < arg0:getCurDayCount() and var0 < arg0.groupNum then
				arg0.markClickPos = iter4

				arg0:selectPos(iter4)
			end
		end, SFX_PANEL)
	end

	arg0.taskPanel = arg0:findTF("TaskPanel")
	arg0.paintingTF = arg0:findTF("PaintingPanel/Main/Painting", arg0.taskPanel)
	arg0.paintingHXTF = arg0:findTF("PaintingPanel/Main/HX", arg0.taskPanel)
	arg0.progressTFList = {}

	local var10 = arg0:findTF("Progress", arg0.taskPanel)

	for iter5 = 1, #arg0.nameList do
		local var11 = arg0:findTF(iter5, var10)

		arg0.progressTFList[iter5] = var11
	end

	arg0.taskTFList = {}
	arg0.taskTFList[1] = arg0:findTF("Task1", arg0.taskPanel)
	arg0.taskTFList[2] = arg0:findTF("Task2", arg0.taskPanel)
	arg0.logText = arg0:findTF("LogText")
end

function var0.updatePosPanel(arg0)
	local var0 = arg0.posTFList
	local var1 = arg0.activity.data1_list

	for iter0, iter1 in ipairs(var0) do
		local var2 = var1[iter0] > 0
		local var3 = arg0:findTF("Got", iter1)
		local var4 = arg0:findTF("Icon", var3)
		local var5 = var1[iter0]
		local var6 = arg0.iconSpriteDict[var5]

		setImageSprite(var4, var6, true)
		setActive(var3, var2)
	end

	local var7 = arg0:isGotFinalAward()

	setActive(arg0.finalGotTF, var7)
	setActive(arg0.finalLockTF, not var7)
end

function var0.updateTaskPanel(arg0)
	arg0:updateTaskList()
	arg0:updateProgress()
	arg0:updatePainting()
end

function var0.updateTaskList(arg0)
	local var0 = arg0:getCurTaskIDList()

	for iter0, iter1 in ipairs(arg0.taskTFList) do
		local var1 = var0[iter0]
		local var2 = arg0.taskProxy:getTaskVO(var1)
		local var3 = arg0:findTF("Desc", iter1)

		setText(var3, var2:getConfig("desc"))

		local var4 = var2:getProgress()
		local var5 = var2:getConfig("target_num")
		local var6 = arg0:findTF("ProgressText", iter1)
		local var7 = arg0:findTF("ProgressBar", iter1)

		setText(var6, var4 .. "/" .. var5)
		setSlider(var7, 0, var5, var4)

		local var8 = var2:getTaskStatus()
		local var9 = arg0:findTF("GetBtn", iter1)
		local var10 = arg0:findTF("GotBtn", iter1)
		local var11 = arg0:findTF("GoBtn", iter1)

		setActive(var11, var8 == 0)
		setActive(var9, var8 == 1)
		setActive(var10, var8 == 2)
		onButton(arg0, var11, function()
			arg0:emit(ActivityMediator.ON_TASK_GO, var2)
		end, SFX_PANEL)
		onButton(arg0, var9, function()
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var2)
		end, SFX_PANEL)

		local var12 = var2:getConfig("award_display")[1]
		local var13 = {
			type = var12[1],
			id = var12[2],
			count = var12[3]
		}
		local var14 = arg0:findTF("Icon", iter1)

		updateDrop(var14, var13)
		onButton(arg0, var14, function()
			arg0:emit(BaseUI.ON_DROP, var13)
		end, SFX_PANEL)

		if arg0:isFinishedCurTaskList() then
			local var15 = arg0:getStep()
			local var16 = arg0.configData.story_task[var15][1]

			print("story", tostring(var16))

			if var16 then
				pg.NewStoryMgr.GetInstance():Play(var16, nil)
			end
		end
	end
end

function var0.updateProgress(arg0)
	local var0 = arg0:getStep()

	for iter0, iter1 in ipairs(arg0.progressTFList) do
		local var1 = arg0:findTF("Get", iter1)
		local var2 = arg0:findTF("Got", iter1)
		local var3 = arg0:findTF("Doing", iter1)

		setActive(var2, iter0 < var0)
		setActive(var1, var0 < iter0)
		setActive(var3, iter0 == var0)
	end
end

function var0.updatePainting(arg0)
	local var0 = arg0:getCurIndex()
	local var1 = arg0.nameList[var0]
	local var2 = arg0.paintingList[var0]
	local var3 = LoadSprite("activitypainting/" .. var2, var2)

	setImageSprite(arg0.paintingTF, var3, true)

	local var4 = arg0.paintingPosDict[var1]

	setLocalPosition(arg0.paintingTF, var4)

	if PLATFORM_CODE == PLATFORM_CH then
		local var5 = arg0.hxPosDict[var1]

		if var5 then
			local var6 = arg0.hxSpriteDict[var1]

			setImageSprite(arg0.paintingHXTF, var6, true)
			setLocalPosition(arg0.paintingHXTF, var5)
			setActive(arg0.paintingHXTF, true)
		else
			setActive(arg0.paintingHXTF, false)
		end
	else
		setActive(arg0.paintingHXTF, false)
	end
end

function var0.openTaskAni(arg0)
	local var0 = arg0:getCurIndex()
	local var1 = arg0.activity.data1_list
	local var2 = table.indexof(var1, var0, 1)
	local var3 = arg0.posTFList[var2]
	local var4 = arg0:findTF("Get", var3)
	local var5 = arg0:findTF("Got", var3)

	setImageAlpha(var4, 1)
	setImageAlpha(var5, 0)
	setActive(var4, true)
	setActive(var5, true)

	local var6 = arg0:findTF("Icon", var5)

	setActive(var6, false)

	local var7 = System.Action_float(function(arg0)
		setImageAlpha(var4, 1 - arg0)
		setImageAlpha(var5, arg0)
	end)
	local var8 = System.Action(function()
		local var0 = arg0:getCurIndex()
		local var1 = arg0.configData.story_list[var0]

		if var1 then
			pg.NewStoryMgr.GetInstance():Play(var1, function()
				arg0:updateTaskPanel()
				setActive(arg0.posPanel, false)
				setActive(arg0.taskPanel, true)
			end, true, true)
		else
			arg0:updateTaskPanel()
			setActive(arg0.posPanel, false)
			setActive(arg0.taskPanel, true)
		end

		arg0.markClickPos = nil
	end)

	var3:SetAsLastSibling()
	arg0:managedTween(LeanTween.value, nil, go(var3), var7, 0, 1, 0.5):setOnComplete(var8)

	arg0.tweenTF = var3
end

function var0.check(arg0)
	if not arg0:isGotFinalAward() then
		local var0 = arg0:getStep()

		if var0 <= arg0.groupNum and arg0:getCurTaskIDList() and arg0:isFinishedCurTaskList() then
			print("清除位置")
			arg0:resetPos()
		end

		if var0 == arg0.groupNum and not arg0:getCurTaskIDList() then
			print("领取最终奖励")
			arg0:getFinalAward()
		end
	end
end

function var0.isGotFinalAward(arg0)
	return arg0.activity.data2 > 0
end

function var0.getStep(arg0)
	return arg0.activity.data3
end

function var0.getCurIndex(arg0)
	return arg0.activity.data4
end

function var0.getCurTaskIDList(arg0)
	local var0 = arg0:getCurIndex()

	return arg0.configData.task_table[var0]
end

function var0.isFinishedCurTaskList(arg0)
	local var0 = arg0:getCurTaskIDList()

	return _.all(var0, function(arg0)
		return arg0.taskProxy:getTaskVO(arg0):getTaskStatus() == 2
	end)
end

function var0.getCurDayCount(arg0)
	local var0 = arg0.activity.data1
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():DiffDay(var0, var1) + 1
end

function var0.getMaxDayCount(arg0)
	local var0 = arg0:getCurDayCount()

	return (math.clamp(var0, 1, arg0.configData.total_num))
end

function var0.resetPos(arg0)
	arg0:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 2,
		activity_id = arg0.activity.id
	})
end

function var0.selectPos(arg0, arg1)
	arg0:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 1,
		activity_id = arg0.activity.id,
		arg1 = arg1
	})
end

function var0.getFinalAward(arg0)
	arg0:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 1,
		activity_id = arg0.activity.id
	})
end

function var0.updateLogText(arg0)
	local var0 = arg0.activity.data1
	local var1 = arg0.activity.data2
	local var2 = arg0.activity.data3
	local var3 = arg0.activity.data4
	local var4 = arg0.activity.data1_list
	local var5 = arg0.activity:getConfig("config_id")
	local var6 = pg.activity_event_turning[var5].total_num
	local var7 = pg.activity_event_turning[var5].groupid_list
	local var8 = pg.TimeMgr.GetInstance():DiffDay(var0, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	local var9 = math.clamp(var8, 1, var6)
	local var10 = ""

	local function var11(arg0)
		var10 = var10 .. arg0 .. "\n"
	end

	var11("开始时间戳：" .. tostring(var0))
	var11("是否领取最终奖励：" .. tostring(var1))
	var11("当前进度：" .. tostring(var2))
	var11("抽到的索引：" .. tostring(var3))
	var11("抽到的位置-索引列表：" .. table.concat(var4, "-"))
	var11("活动开始到现在的天数：" .. tostring(var8))
	var11("活动的最大抽取次数：" .. tostring(var9))
	var11("配置的总段数：" .. tostring(var6))
	var11("配置的GroupID列表：" .. table.concat(var7, "-"))

	if var3 > 0 then
		local var12 = pg.activity_event_turning[var5][var3]
		local var13 = pg.activity_event_turning[var5].task_table[var3]
		local var14 = pg.activity_event_turning[var5].story_list[var3]

		var11("当前的GroupID：" .. tostring(var12))
		var11("当前的任务列表：" .. table.concat(var13, "-"))
		var11("当前的剧情ID：" .. tostring(var14))
	end

	setText(arg0.logText, var10)
	print(var10)
end

return var0
