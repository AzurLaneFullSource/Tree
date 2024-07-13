local var0_0 = class("SenrankaguraTaskPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.taskProxy = getProxy(TaskProxy)
	arg0_1.activityProxy = getProxy(ActivityProxy)

	arg0_1:findUI()
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.configID = arg0_2.activity:getConfig("config_id")
	arg0_2.configData = pg.activity_event_turning[arg0_2.configID]
	arg0_2.groupNum = arg0_2.configData.total_num
end

function var0_0.OnFirstFlush(arg0_3)
	return
end

function var0_0.OnUpdateFlush(arg0_4)
	local var0_4 = arg0_4:getCurIndex()

	if arg0_4.markClickPos and arg0_4.markClickPos > 0 then
		print("有操作再更新任务面板")
		arg0_4:openTaskAni()
	elseif var0_4 > 0 then
		if arg0_4.activity.data4 <= arg0_4.groupNum then
			print("直接更新任务面板")
			arg0_4:updateTaskPanel()
			setActive(arg0_4.posPanel, false)
			setActive(arg0_4.taskPanel, true)
		end
	elseif var0_4 == 0 then
		arg0_4:updatePosPanel()
		setActive(arg0_4.posPanel, true)
		setActive(arg0_4.taskPanel, false)

		if arg0_4:getStep() > arg0_4.groupNum then
			-- block empty
		end
	end

	arg0_4:check()
	arg0_4:updateLogText()
end

function var0_0.onDestroy(arg0_5)
	return
end

function var0_0.findUI(arg0_6)
	local var0_6 = arg0_6:findTF("IconList")

	arg0_6.nameList = {
		"feiniao",
		"banjiu",
		"yan",
		"xuequan",
		"xuebugui",
		"zi",
		"xishao"
	}
	arg0_6.paintingList = {
		"asuka",
		"ikaruga",
		"homura",
		"yumi",
		"fubuki",
		"murasaki",
		"yuuyaki"
	}
	arg0_6.iconSpriteDict = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.nameList) do
		local var1_6 = arg0_6:findTF(iter1_6, var0_6)
		local var2_6 = getImageSprite(var1_6)

		arg0_6.iconSpriteDict[iter0_6] = var2_6
		arg0_6.iconSpriteDict[iter1_6] = var2_6
	end

	local var3_6 = arg0_6:findTF("HXList")
	local var4_6 = {
		"feiniao",
		"yan",
		"xuequan",
		"xuebugui",
		"xishao"
	}

	arg0_6.hxSpriteDict = {}

	for iter2_6, iter3_6 in ipairs(var4_6) do
		local var5_6 = arg0_6:findTF(iter3_6, var3_6)
		local var6_6 = getImageSprite(var5_6)

		arg0_6.hxSpriteDict[iter3_6] = var6_6
	end

	arg0_6.hxPosDict = {
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
	arg0_6.paintingPosDict = {
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
	arg0_6.posPanel = arg0_6:findTF("PosPanel")
	arg0_6.finalLockTF = arg0_6:findTF("FinalAward/Lock", arg0_6.posPanel)
	arg0_6.finalGotTF = arg0_6:findTF("FinalAward/Got", arg0_6.posPanel)
	arg0_6.posTFList = {}

	local var7_6 = arg0_6:findTF("PosList", arg0_6.posPanel)

	for iter4_6 = 1, #arg0_6.nameList do
		local var8_6 = arg0_6:findTF(iter4_6, var7_6)

		table.insert(arg0_6.posTFList, var8_6)

		local var9_6 = arg0_6:findTF("Get", var8_6)

		onButton(arg0_6, var9_6, function()
			local var0_7 = arg0_6:getStep()

			if var0_7 < arg0_6:getCurDayCount() and var0_7 < arg0_6.groupNum then
				arg0_6.markClickPos = iter4_6

				arg0_6:selectPos(iter4_6)
			end
		end, SFX_PANEL)
	end

	arg0_6.taskPanel = arg0_6:findTF("TaskPanel")
	arg0_6.paintingTF = arg0_6:findTF("PaintingPanel/Main/Painting", arg0_6.taskPanel)
	arg0_6.paintingHXTF = arg0_6:findTF("PaintingPanel/Main/HX", arg0_6.taskPanel)
	arg0_6.progressTFList = {}

	local var10_6 = arg0_6:findTF("Progress", arg0_6.taskPanel)

	for iter5_6 = 1, #arg0_6.nameList do
		local var11_6 = arg0_6:findTF(iter5_6, var10_6)

		arg0_6.progressTFList[iter5_6] = var11_6
	end

	arg0_6.taskTFList = {}
	arg0_6.taskTFList[1] = arg0_6:findTF("Task1", arg0_6.taskPanel)
	arg0_6.taskTFList[2] = arg0_6:findTF("Task2", arg0_6.taskPanel)
	arg0_6.logText = arg0_6:findTF("LogText")
end

function var0_0.updatePosPanel(arg0_8)
	local var0_8 = arg0_8.posTFList
	local var1_8 = arg0_8.activity.data1_list

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var2_8 = var1_8[iter0_8] > 0
		local var3_8 = arg0_8:findTF("Got", iter1_8)
		local var4_8 = arg0_8:findTF("Icon", var3_8)
		local var5_8 = var1_8[iter0_8]
		local var6_8 = arg0_8.iconSpriteDict[var5_8]

		setImageSprite(var4_8, var6_8, true)
		setActive(var3_8, var2_8)
	end

	local var7_8 = arg0_8:isGotFinalAward()

	setActive(arg0_8.finalGotTF, var7_8)
	setActive(arg0_8.finalLockTF, not var7_8)
end

function var0_0.updateTaskPanel(arg0_9)
	arg0_9:updateTaskList()
	arg0_9:updateProgress()
	arg0_9:updatePainting()
end

function var0_0.updateTaskList(arg0_10)
	local var0_10 = arg0_10:getCurTaskIDList()

	for iter0_10, iter1_10 in ipairs(arg0_10.taskTFList) do
		local var1_10 = var0_10[iter0_10]
		local var2_10 = arg0_10.taskProxy:getTaskVO(var1_10)
		local var3_10 = arg0_10:findTF("Desc", iter1_10)

		setText(var3_10, var2_10:getConfig("desc"))

		local var4_10 = var2_10:getProgress()
		local var5_10 = var2_10:getConfig("target_num")
		local var6_10 = arg0_10:findTF("ProgressText", iter1_10)
		local var7_10 = arg0_10:findTF("ProgressBar", iter1_10)

		setText(var6_10, var4_10 .. "/" .. var5_10)
		setSlider(var7_10, 0, var5_10, var4_10)

		local var8_10 = var2_10:getTaskStatus()
		local var9_10 = arg0_10:findTF("GetBtn", iter1_10)
		local var10_10 = arg0_10:findTF("GotBtn", iter1_10)
		local var11_10 = arg0_10:findTF("GoBtn", iter1_10)

		setActive(var11_10, var8_10 == 0)
		setActive(var9_10, var8_10 == 1)
		setActive(var10_10, var8_10 == 2)
		onButton(arg0_10, var11_10, function()
			arg0_10:emit(ActivityMediator.ON_TASK_GO, var2_10)
		end, SFX_PANEL)
		onButton(arg0_10, var9_10, function()
			arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var2_10)
		end, SFX_PANEL)

		local var12_10 = var2_10:getConfig("award_display")[1]
		local var13_10 = {
			type = var12_10[1],
			id = var12_10[2],
			count = var12_10[3]
		}
		local var14_10 = arg0_10:findTF("Icon", iter1_10)

		updateDrop(var14_10, var13_10)
		onButton(arg0_10, var14_10, function()
			arg0_10:emit(BaseUI.ON_DROP, var13_10)
		end, SFX_PANEL)

		if arg0_10:isFinishedCurTaskList() then
			local var15_10 = arg0_10:getStep()
			local var16_10 = arg0_10.configData.story_task[var15_10][1]

			print("story", tostring(var16_10))

			if var16_10 then
				pg.NewStoryMgr.GetInstance():Play(var16_10, nil)
			end
		end
	end
end

function var0_0.updateProgress(arg0_14)
	local var0_14 = arg0_14:getStep()

	for iter0_14, iter1_14 in ipairs(arg0_14.progressTFList) do
		local var1_14 = arg0_14:findTF("Get", iter1_14)
		local var2_14 = arg0_14:findTF("Got", iter1_14)
		local var3_14 = arg0_14:findTF("Doing", iter1_14)

		setActive(var2_14, iter0_14 < var0_14)
		setActive(var1_14, var0_14 < iter0_14)
		setActive(var3_14, iter0_14 == var0_14)
	end
end

function var0_0.updatePainting(arg0_15)
	local var0_15 = arg0_15:getCurIndex()
	local var1_15 = arg0_15.nameList[var0_15]
	local var2_15 = arg0_15.paintingList[var0_15]
	local var3_15 = LoadSprite("activitypainting/" .. var2_15, var2_15)

	setImageSprite(arg0_15.paintingTF, var3_15, true)

	local var4_15 = arg0_15.paintingPosDict[var1_15]

	setLocalPosition(arg0_15.paintingTF, var4_15)

	if PLATFORM_CODE == PLATFORM_CH then
		local var5_15 = arg0_15.hxPosDict[var1_15]

		if var5_15 then
			local var6_15 = arg0_15.hxSpriteDict[var1_15]

			setImageSprite(arg0_15.paintingHXTF, var6_15, true)
			setLocalPosition(arg0_15.paintingHXTF, var5_15)
			setActive(arg0_15.paintingHXTF, true)
		else
			setActive(arg0_15.paintingHXTF, false)
		end
	else
		setActive(arg0_15.paintingHXTF, false)
	end
end

function var0_0.openTaskAni(arg0_16)
	local var0_16 = arg0_16:getCurIndex()
	local var1_16 = arg0_16.activity.data1_list
	local var2_16 = table.indexof(var1_16, var0_16, 1)
	local var3_16 = arg0_16.posTFList[var2_16]
	local var4_16 = arg0_16:findTF("Get", var3_16)
	local var5_16 = arg0_16:findTF("Got", var3_16)

	setImageAlpha(var4_16, 1)
	setImageAlpha(var5_16, 0)
	setActive(var4_16, true)
	setActive(var5_16, true)

	local var6_16 = arg0_16:findTF("Icon", var5_16)

	setActive(var6_16, false)

	local var7_16 = System.Action_float(function(arg0_17)
		setImageAlpha(var4_16, 1 - arg0_17)
		setImageAlpha(var5_16, arg0_17)
	end)
	local var8_16 = System.Action(function()
		local var0_18 = arg0_16:getCurIndex()
		local var1_18 = arg0_16.configData.story_list[var0_18]

		if var1_18 then
			pg.NewStoryMgr.GetInstance():Play(var1_18, function()
				arg0_16:updateTaskPanel()
				setActive(arg0_16.posPanel, false)
				setActive(arg0_16.taskPanel, true)
			end, true, true)
		else
			arg0_16:updateTaskPanel()
			setActive(arg0_16.posPanel, false)
			setActive(arg0_16.taskPanel, true)
		end

		arg0_16.markClickPos = nil
	end)

	var3_16:SetAsLastSibling()
	arg0_16:managedTween(LeanTween.value, nil, go(var3_16), var7_16, 0, 1, 0.5):setOnComplete(var8_16)

	arg0_16.tweenTF = var3_16
end

function var0_0.check(arg0_20)
	if not arg0_20:isGotFinalAward() then
		local var0_20 = arg0_20:getStep()

		if var0_20 <= arg0_20.groupNum and arg0_20:getCurTaskIDList() and arg0_20:isFinishedCurTaskList() then
			print("清除位置")
			arg0_20:resetPos()
		end

		if var0_20 == arg0_20.groupNum and not arg0_20:getCurTaskIDList() then
			print("领取最终奖励")
			arg0_20:getFinalAward()
		end
	end
end

function var0_0.isGotFinalAward(arg0_21)
	return arg0_21.activity.data2 > 0
end

function var0_0.getStep(arg0_22)
	return arg0_22.activity.data3
end

function var0_0.getCurIndex(arg0_23)
	return arg0_23.activity.data4
end

function var0_0.getCurTaskIDList(arg0_24)
	local var0_24 = arg0_24:getCurIndex()

	return arg0_24.configData.task_table[var0_24]
end

function var0_0.isFinishedCurTaskList(arg0_25)
	local var0_25 = arg0_25:getCurTaskIDList()

	return _.all(var0_25, function(arg0_26)
		return arg0_25.taskProxy:getTaskVO(arg0_26):getTaskStatus() == 2
	end)
end

function var0_0.getCurDayCount(arg0_27)
	local var0_27 = arg0_27.activity.data1
	local var1_27 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():DiffDay(var0_27, var1_27) + 1
end

function var0_0.getMaxDayCount(arg0_28)
	local var0_28 = arg0_28:getCurDayCount()

	return (math.clamp(var0_28, 1, arg0_28.configData.total_num))
end

function var0_0.resetPos(arg0_29)
	arg0_29:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 2,
		activity_id = arg0_29.activity.id
	})
end

function var0_0.selectPos(arg0_30, arg1_30)
	arg0_30:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 1,
		activity_id = arg0_30.activity.id,
		arg1 = arg1_30
	})
end

function var0_0.getFinalAward(arg0_31)
	arg0_31:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 1,
		activity_id = arg0_31.activity.id
	})
end

function var0_0.updateLogText(arg0_32)
	local var0_32 = arg0_32.activity.data1
	local var1_32 = arg0_32.activity.data2
	local var2_32 = arg0_32.activity.data3
	local var3_32 = arg0_32.activity.data4
	local var4_32 = arg0_32.activity.data1_list
	local var5_32 = arg0_32.activity:getConfig("config_id")
	local var6_32 = pg.activity_event_turning[var5_32].total_num
	local var7_32 = pg.activity_event_turning[var5_32].groupid_list
	local var8_32 = pg.TimeMgr.GetInstance():DiffDay(var0_32, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	local var9_32 = math.clamp(var8_32, 1, var6_32)
	local var10_32 = ""

	local function var11_32(arg0_33)
		var10_32 = var10_32 .. arg0_33 .. "\n"
	end

	var11_32("开始时间戳：" .. tostring(var0_32))
	var11_32("是否领取最终奖励：" .. tostring(var1_32))
	var11_32("当前进度：" .. tostring(var2_32))
	var11_32("抽到的索引：" .. tostring(var3_32))
	var11_32("抽到的位置-索引列表：" .. table.concat(var4_32, "-"))
	var11_32("活动开始到现在的天数：" .. tostring(var8_32))
	var11_32("活动的最大抽取次数：" .. tostring(var9_32))
	var11_32("配置的总段数：" .. tostring(var6_32))
	var11_32("配置的GroupID列表：" .. table.concat(var7_32, "-"))

	if var3_32 > 0 then
		local var12_32 = pg.activity_event_turning[var5_32][var3_32]
		local var13_32 = pg.activity_event_turning[var5_32].task_table[var3_32]
		local var14_32 = pg.activity_event_turning[var5_32].story_list[var3_32]

		var11_32("当前的GroupID：" .. tostring(var12_32))
		var11_32("当前的任务列表：" .. table.concat(var13_32, "-"))
		var11_32("当前的剧情ID：" .. tostring(var14_32))
	end

	setText(arg0_32.logText, var10_32)
	print(var10_32)
end

return var0_0
