local var0 = class("HoloLivePtPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.circleTF = arg0:findTF("CircleImg/Circle")
	arg0.startBtn = arg0:findTF("CircleImg/StartBtn")
	arg0.helpBtn1 = arg0:findTF("HelpBtn")
	arg0.taskPanel = arg0:findTF("AD")

	onButton(arg0, arg0.startBtn, function()
		if arg0.isTurning then
			return
		end

		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn1, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_goodmorning.tip
		})
	end, SFX_PANEL)
end

function var0.OnDataSetting(arg0)
	arg0.activityStartTime = arg0.activity.data1
	arg0.isGotFinalAward = arg0.activity.data2
	arg0.progressStep = arg0.activity.data3
	arg0.configID = arg0.activity:getConfig("config_id")
	arg0.configData = pg.activity_event_turning[arg0.configID]
	arg0.groupNum = arg0.configData.total_num

	local var0 = pg.TimeMgr.GetInstance():DiffDay(arg0.activityStartTime, pg.TimeMgr.GetInstance():GetServerTime()) + 1

	arg0.maxday = math.clamp(var0, 1, arg0.configData.total_num)

	print("init data on setting:", tostring(arg0.maxday), tostring(arg0.isGotFinalAward), tostring(arg0.progressStep), tostring(arg0.activity.data4))
end

function var0.OnFirstFlush(arg0)
	arg0.curIndex = arg0.activity.data4

	if arg0.curIndex ~= 0 then
		arg0.curShipGroupID = arg0.configData.groupid_list[arg0.curIndex]
		arg0.curTaskIDList = arg0.configData.task_table[arg0.curIndex]
		arg0.curStoryID = arg0.configData.story_list[arg0.curIndex]
	end
end

function var0.OnUpdateFlush(arg0)
	if arg0.curIndex == 0 and arg0.activity.data4 > 0 then
		arg0.curIndex = arg0.activity.data4
		arg0.curShipGroupID = arg0.configData.groupid_list[arg0.curIndex]
		arg0.curTaskIDList = arg0.configData.task_table[arg0.curIndex]
		arg0.curStoryID = arg0.configData.story_list[arg0.curIndex]

		print("before rotate", tostring(arg0.curShipGroupID), tostring(arg0.curIndex), tostring(arg0.curStoryID))
		arg0:rotate()
	elseif arg0.activity.data4 > 0 then
		if arg0.activity.data4 <= arg0.groupNum then
			arg0.curIndex = arg0.activity.data4
			arg0.curShipGroupID = arg0.configData.groupid_list[arg0.curIndex]
			arg0.curTaskIDList = arg0.configData.task_table[arg0.curIndex]
			arg0.curStoryID = arg0.configData.story_list[arg0.curIndex]

			print("direct update", tostring(arg0.curShipGroupID), tostring(arg0.curIndex), tostring(arg0.curStoryID))
			arg0:updateTaskPanel()
		end
	elseif arg0.activity.data4 == 0 then
		arg0.curIndex = 0
		arg0.curShipGroupID = nil
		arg0.curTaskIDList = nil
		arg0.curStoryID = nil

		setActive(arg0.taskPanel, false)

		if arg0.progressStep > arg0.groupNum then
			arg0:lockTurnTable()
		end
	end

	arg0:checkAward()
end

function var0.onDestroy(arg0)
	LeanTween.cancel(go(arg0.circleTF))
end

function var0.rotate(arg0)
	local var0 = arg0.activity:getConfig("config_id")
	local var1 = pg.activity_event_turning[var0]
	local var2 = {
		6,
		0,
		4,
		2,
		5,
		3,
		1
	}
	local var3 = 4
	local var4 = 8
	local var5 = 360 - 360 / var1.total_num * var2[arg0.curIndex] + var4 * 360

	arg0.isTurning = true

	LeanTween.value(go(arg0.circleTF), 0, var5, var3):setEase(LeanTweenType.easeInOutCirc):setOnUpdate(System.Action_float(function(arg0)
		arg0.circleTF.localEulerAngles = Vector3(0, 0, -arg0)
	end)):setOnComplete(System.Action(function()
		pg.NewStoryMgr.GetInstance():Play(arg0.curStoryID, function()
			arg0:updateTaskPanel()
		end, true, true)

		arg0.isTurning = false
	end))
end

function var0.updateTaskPanel(arg0)
	arg0.charImg = arg0:findTF("CharImg", arg0.taskPanel)
	arg0.nameImg = arg0:findTF("NameImg", arg0.charImg)
	arg0.dayText = arg0:findTF("ProgressImg/day", arg0.taskPanel)
	arg0.taskItemTpl = arg0:findTF("item", arg0.taskPanel)
	arg0.taskItemContainer = arg0:findTF("items", arg0.taskPanel)
	arg0.backBtn = arg0:findTF("BackBtn", arg0.taskPanel)
	arg0.countText = arg0:findTF("RedPoint/Text", arg0.backBtn)
	arg0.helpBtn2 = arg0:findTF("HelpBtn", arg0.taskPanel)

	local var0 = "img_char_" .. arg0.curShipGroupID

	LoadSpriteAtlasAsync("ui/activityuipage/hololivemorningpage", var0, function(arg0)
		if arg0.curShipGroupID == 1050001 then
			rtf(arg0.charImg).sizeDelta = Vector2(1058, 714)

			setImageSprite(arg0.charImg, arg0)
		elseif arg0.curShipGroupID == 1050003 then
			rtf(arg0.charImg).sizeDelta = Vector2(1122, 714)

			setImageSprite(arg0.charImg, arg0)
		elseif arg0.curShipGroupID == 1050005 then
			rtf(arg0.charImg).sizeDelta = Vector2(1044, 714)

			setImageSprite(arg0.charImg, arg0)
		else
			setImageSprite(arg0.charImg, arg0, true)
		end
	end)

	local var1 = "img_name_" .. arg0.curShipGroupID

	LoadSpriteAtlasAsync("ui/activityuipage/hololivemorningpage", var1, function(arg0)
		setImageSprite(arg0.nameImg, arg0, true)
	end)
	setText(arg0.dayText, arg0.progressStep .. " / " .. arg0.configData.total_num)

	arg0.taskUIItemList = UIItemList.New(arg0.taskItemContainer, arg0.taskItemTpl)

	arg0.taskUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("item", arg2)
			local var2 = arg0.curTaskIDList[var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			assert(var3, "without this task by id: " .. var2)

			local var4 = var3:getConfig("award_display")[1]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			}

			updateDrop(var1, var5)
			onButton(arg0, var1, function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)

			local var6 = var3:getProgress()
			local var7 = var3:getConfig("target_num")

			setText(arg0:findTF("description", arg2), var3:getConfig("desc") .. "(" .. var6 .. "/" .. var7 .. ")")
			setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

			local var8 = arg0:findTF("go_btn", arg2)
			local var9 = arg0:findTF("get_btn", arg2)
			local var10 = arg0:findTF("got_btn", arg2)
			local var11 = var3:getTaskStatus()

			setActive(var8, var11 == 0)
			setActive(var9, var11 == 1)
			setActive(var10, var11 == 2)
			onButton(arg0, var8, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var3)
			end, SFX_PANEL)
			onButton(arg0, var9, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end, SFX_PANEL)
		end
	end)
	arg0.taskUIItemList:align(#arg0.curTaskIDList)

	local var2 = true

	for iter0, iter1 in ipairs(arg0.curTaskIDList) do
		if (arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1)):getTaskStatus() ~= 2 then
			var2 = false

			break
		end
	end

	if var2 then
		local var3 = arg0.activity:getConfig("config_id")
		local var4 = pg.activity_event_turning[var3].story_task[arg0.progressStep][1]

		print("story", tostring(var4))

		if var4 then
			pg.NewStoryMgr.GetInstance():Play(var4, nil)
		end
	end

	if arg0.maxday <= arg0.progressStep then
		var2 = false
	end

	setActive(arg0.backBtn, var2)

	if var2 then
		setText(arg0.countText, tostring(arg0.maxday - arg0.progressStep))
	end

	setActive(arg0.taskPanel, true)
	onButton(arg0, arg0.backBtn, function()
		arg0:resetIndex()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn2, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_goodmorning.tip
		})
	end, SFX_PANEL)
end

function var0.checkAward(arg0)
	if arg0.isGotFinalAward == 0 and arg0.progressStep == arg0.groupNum then
		if arg0.curTaskIDList then
			local var0 = true

			for iter0, iter1 in ipairs(arg0.curTaskIDList) do
				if (arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1)):getTaskStatus() ~= 2 then
					var0 = false

					break
				end
			end

			if var0 and arg0.activity.data4 ~= 0 and arg0.activity.data3 == arg0.groupNum then
				arg0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 2,
					activity_id = arg0.activity.id
				})
			end
		else
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0.activity.id
			})
		end
	end
end

function var0.resetIndex(arg0)
	arg0:emit(ActivityMediator.EVENT_OPERATION, {
		cmd = 2,
		activity_id = arg0.activity.id
	})
end

function var0.lockTurnTable(arg0)
	arg0.finalTip = arg0:findTF("FinalTip")
	arg0.finalLock = arg0:findTF("CircleImg/FinalLock")

	setActive(arg0.finalTip, true)
	setActive(arg0.finalLock, true)

	arg0.tipImg = arg0:findTF("TipImg")

	setActive(arg0.tipImg, false)
end

return var0
