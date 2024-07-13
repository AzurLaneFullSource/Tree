local var0_0 = class("HoloLivePtPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.taskProxy = getProxy(TaskProxy)
	arg0_1.activityProxy = getProxy(ActivityProxy)
	arg0_1.circleTF = arg0_1:findTF("CircleImg/Circle")
	arg0_1.startBtn = arg0_1:findTF("CircleImg/StartBtn")
	arg0_1.helpBtn1 = arg0_1:findTF("HelpBtn")
	arg0_1.taskPanel = arg0_1:findTF("AD")

	onButton(arg0_1, arg0_1.startBtn, function()
		if arg0_1.isTurning then
			return
		end

		arg0_1:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_1.activity.id
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.helpBtn1, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_goodmorning.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnDataSetting(arg0_4)
	arg0_4.activityStartTime = arg0_4.activity.data1
	arg0_4.isGotFinalAward = arg0_4.activity.data2
	arg0_4.progressStep = arg0_4.activity.data3
	arg0_4.configID = arg0_4.activity:getConfig("config_id")
	arg0_4.configData = pg.activity_event_turning[arg0_4.configID]
	arg0_4.groupNum = arg0_4.configData.total_num

	local var0_4 = pg.TimeMgr.GetInstance():DiffDay(arg0_4.activityStartTime, pg.TimeMgr.GetInstance():GetServerTime()) + 1

	arg0_4.maxday = math.clamp(var0_4, 1, arg0_4.configData.total_num)

	print("init data on setting:", tostring(arg0_4.maxday), tostring(arg0_4.isGotFinalAward), tostring(arg0_4.progressStep), tostring(arg0_4.activity.data4))
end

function var0_0.OnFirstFlush(arg0_5)
	arg0_5.curIndex = arg0_5.activity.data4

	if arg0_5.curIndex ~= 0 then
		arg0_5.curShipGroupID = arg0_5.configData.groupid_list[arg0_5.curIndex]
		arg0_5.curTaskIDList = arg0_5.configData.task_table[arg0_5.curIndex]
		arg0_5.curStoryID = arg0_5.configData.story_list[arg0_5.curIndex]
	end
end

function var0_0.OnUpdateFlush(arg0_6)
	if arg0_6.curIndex == 0 and arg0_6.activity.data4 > 0 then
		arg0_6.curIndex = arg0_6.activity.data4
		arg0_6.curShipGroupID = arg0_6.configData.groupid_list[arg0_6.curIndex]
		arg0_6.curTaskIDList = arg0_6.configData.task_table[arg0_6.curIndex]
		arg0_6.curStoryID = arg0_6.configData.story_list[arg0_6.curIndex]

		print("before rotate", tostring(arg0_6.curShipGroupID), tostring(arg0_6.curIndex), tostring(arg0_6.curStoryID))
		arg0_6:rotate()
	elseif arg0_6.activity.data4 > 0 then
		if arg0_6.activity.data4 <= arg0_6.groupNum then
			arg0_6.curIndex = arg0_6.activity.data4
			arg0_6.curShipGroupID = arg0_6.configData.groupid_list[arg0_6.curIndex]
			arg0_6.curTaskIDList = arg0_6.configData.task_table[arg0_6.curIndex]
			arg0_6.curStoryID = arg0_6.configData.story_list[arg0_6.curIndex]

			print("direct update", tostring(arg0_6.curShipGroupID), tostring(arg0_6.curIndex), tostring(arg0_6.curStoryID))
			arg0_6:updateTaskPanel()
		end
	elseif arg0_6.activity.data4 == 0 then
		arg0_6.curIndex = 0
		arg0_6.curShipGroupID = nil
		arg0_6.curTaskIDList = nil
		arg0_6.curStoryID = nil

		setActive(arg0_6.taskPanel, false)

		if arg0_6.progressStep > arg0_6.groupNum then
			arg0_6:lockTurnTable()
		end
	end

	arg0_6:checkAward()
end

function var0_0.onDestroy(arg0_7)
	LeanTween.cancel(go(arg0_7.circleTF))
end

function var0_0.rotate(arg0_8)
	local var0_8 = arg0_8.activity:getConfig("config_id")
	local var1_8 = pg.activity_event_turning[var0_8]
	local var2_8 = {
		6,
		0,
		4,
		2,
		5,
		3,
		1
	}
	local var3_8 = 4
	local var4_8 = 8
	local var5_8 = 360 - 360 / var1_8.total_num * var2_8[arg0_8.curIndex] + var4_8 * 360

	arg0_8.isTurning = true

	LeanTween.value(go(arg0_8.circleTF), 0, var5_8, var3_8):setEase(LeanTweenType.easeInOutCirc):setOnUpdate(System.Action_float(function(arg0_9)
		arg0_8.circleTF.localEulerAngles = Vector3(0, 0, -arg0_9)
	end)):setOnComplete(System.Action(function()
		pg.NewStoryMgr.GetInstance():Play(arg0_8.curStoryID, function()
			arg0_8:updateTaskPanel()
		end, true, true)

		arg0_8.isTurning = false
	end))
end

function var0_0.updateTaskPanel(arg0_12)
	arg0_12.charImg = arg0_12:findTF("CharImg", arg0_12.taskPanel)
	arg0_12.nameImg = arg0_12:findTF("NameImg", arg0_12.charImg)
	arg0_12.dayText = arg0_12:findTF("ProgressImg/day", arg0_12.taskPanel)
	arg0_12.taskItemTpl = arg0_12:findTF("item", arg0_12.taskPanel)
	arg0_12.taskItemContainer = arg0_12:findTF("items", arg0_12.taskPanel)
	arg0_12.backBtn = arg0_12:findTF("BackBtn", arg0_12.taskPanel)
	arg0_12.countText = arg0_12:findTF("RedPoint/Text", arg0_12.backBtn)
	arg0_12.helpBtn2 = arg0_12:findTF("HelpBtn", arg0_12.taskPanel)

	local var0_12 = "img_char_" .. arg0_12.curShipGroupID

	LoadSpriteAtlasAsync("ui/activityuipage/hololivemorningpage", var0_12, function(arg0_13)
		if arg0_12.curShipGroupID == 1050001 then
			rtf(arg0_12.charImg).sizeDelta = Vector2(1058, 714)

			setImageSprite(arg0_12.charImg, arg0_13)
		elseif arg0_12.curShipGroupID == 1050003 then
			rtf(arg0_12.charImg).sizeDelta = Vector2(1122, 714)

			setImageSprite(arg0_12.charImg, arg0_13)
		elseif arg0_12.curShipGroupID == 1050005 then
			rtf(arg0_12.charImg).sizeDelta = Vector2(1044, 714)

			setImageSprite(arg0_12.charImg, arg0_13)
		else
			setImageSprite(arg0_12.charImg, arg0_13, true)
		end
	end)

	local var1_12 = "img_name_" .. arg0_12.curShipGroupID

	LoadSpriteAtlasAsync("ui/activityuipage/hololivemorningpage", var1_12, function(arg0_14)
		setImageSprite(arg0_12.nameImg, arg0_14, true)
	end)
	setText(arg0_12.dayText, arg0_12.progressStep .. " / " .. arg0_12.configData.total_num)

	arg0_12.taskUIItemList = UIItemList.New(arg0_12.taskItemContainer, arg0_12.taskItemTpl)

	arg0_12.taskUIItemList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg1_15 + 1
			local var1_15 = arg0_12:findTF("item", arg2_15)
			local var2_15 = arg0_12.curTaskIDList[var0_15]
			local var3_15 = arg0_12.taskProxy:getTaskById(var2_15) or arg0_12.taskProxy:getFinishTaskById(var2_15)

			assert(var3_15, "without this task by id: " .. var2_15)

			local var4_15 = var3_15:getConfig("award_display")[1]
			local var5_15 = {
				type = var4_15[1],
				id = var4_15[2],
				count = var4_15[3]
			}

			updateDrop(var1_15, var5_15)
			onButton(arg0_12, var1_15, function()
				arg0_12:emit(BaseUI.ON_DROP, var5_15)
			end, SFX_PANEL)

			local var6_15 = var3_15:getProgress()
			local var7_15 = var3_15:getConfig("target_num")

			setText(arg0_12:findTF("description", arg2_15), var3_15:getConfig("desc") .. "(" .. var6_15 .. "/" .. var7_15 .. ")")
			setSlider(arg0_12:findTF("progress", arg2_15), 0, var7_15, var6_15)

			local var8_15 = arg0_12:findTF("go_btn", arg2_15)
			local var9_15 = arg0_12:findTF("get_btn", arg2_15)
			local var10_15 = arg0_12:findTF("got_btn", arg2_15)
			local var11_15 = var3_15:getTaskStatus()

			setActive(var8_15, var11_15 == 0)
			setActive(var9_15, var11_15 == 1)
			setActive(var10_15, var11_15 == 2)
			onButton(arg0_12, var8_15, function()
				arg0_12:emit(ActivityMediator.ON_TASK_GO, var3_15)
			end, SFX_PANEL)
			onButton(arg0_12, var9_15, function()
				arg0_12:emit(ActivityMediator.ON_TASK_SUBMIT, var3_15)
			end, SFX_PANEL)
		end
	end)
	arg0_12.taskUIItemList:align(#arg0_12.curTaskIDList)

	local var2_12 = true

	for iter0_12, iter1_12 in ipairs(arg0_12.curTaskIDList) do
		if (arg0_12.taskProxy:getTaskById(iter1_12) or arg0_12.taskProxy:getFinishTaskById(iter1_12)):getTaskStatus() ~= 2 then
			var2_12 = false

			break
		end
	end

	if var2_12 then
		local var3_12 = arg0_12.activity:getConfig("config_id")
		local var4_12 = pg.activity_event_turning[var3_12].story_task[arg0_12.progressStep][1]

		print("story", tostring(var4_12))

		if var4_12 then
			pg.NewStoryMgr.GetInstance():Play(var4_12, nil)
		end
	end

	if arg0_12.maxday <= arg0_12.progressStep then
		var2_12 = false
	end

	setActive(arg0_12.backBtn, var2_12)

	if var2_12 then
		setText(arg0_12.countText, tostring(arg0_12.maxday - arg0_12.progressStep))
	end

	setActive(arg0_12.taskPanel, true)
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:resetIndex()
	end, SFX_CANCEL)
	onButton(arg0_12, arg0_12.helpBtn2, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_goodmorning.tip
		})
	end, SFX_PANEL)
end

function var0_0.checkAward(arg0_21)
	if arg0_21.isGotFinalAward == 0 and arg0_21.progressStep == arg0_21.groupNum then
		if arg0_21.curTaskIDList then
			local var0_21 = true

			for iter0_21, iter1_21 in ipairs(arg0_21.curTaskIDList) do
				if (arg0_21.taskProxy:getTaskById(iter1_21) or arg0_21.taskProxy:getFinishTaskById(iter1_21)):getTaskStatus() ~= 2 then
					var0_21 = false

					break
				end
			end

			if var0_21 and arg0_21.activity.data4 ~= 0 and arg0_21.activity.data3 == arg0_21.groupNum then
				arg0_21:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 2,
					activity_id = arg0_21.activity.id
				})
			end
		else
			arg0_21:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_21.activity.id
			})
		end
	end
end

function var0_0.resetIndex(arg0_22)
	arg0_22:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 2,
		activity_id = arg0_22.activity.id
	})
end

function var0_0.lockTurnTable(arg0_23)
	arg0_23.finalTip = arg0_23:findTF("FinalTip")
	arg0_23.finalLock = arg0_23:findTF("CircleImg/FinalLock")

	setActive(arg0_23.finalTip, true)
	setActive(arg0_23.finalLock, true)

	arg0_23.tipImg = arg0_23:findTF("TipImg")

	setActive(arg0_23.tipImg, false)
end

return var0_0
