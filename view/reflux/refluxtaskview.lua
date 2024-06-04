local var0 = class("RefluxTaskView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "RefluxTaskUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	arg0:Hide()
end

function var0.initData(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.refluxProxy = getProxy(RefluxProxy)

	local var0 = pg.return_task_template.all[#pg.return_task_template.all]

	arg0.totalDayCount = pg.return_task_template[var0].reward_date
	arg0.taskVOList = nil
	arg0.taskVOListForShow = nil
	arg0.lastSubmitTaskIDList = {}
end

function var0.initUI(arg0)
	local var0 = arg0:findTF("DayImg")

	arg0.daySpriteList = {}

	for iter0 = 0, arg0.totalDayCount - 1 do
		local var1 = var0:GetChild(iter0)
		local var2 = getImageSprite(var1)

		table.insert(arg0.daySpriteList, var2)
	end

	arg0.itemTpl = arg0:findTF("ItemTpl")

	local var3 = arg0:findTF("TaskTpl")
	local var4 = arg0:findTF("ScrollRect/Container")

	arg0.taskUIList = UIItemList.New(var4, var3)

	arg0.taskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = arg0.taskVOListForShow[arg1]

			arg0:updateTask(arg2, var0)
		end
	end)

	arg0.taskProgressText = arg0:findTF("BG/ProgressText")
	arg0.oneStepBtnDisable = arg0:findTF("OneStepDisable")
	arg0.oneStepBtn = arg0:findTF("OneStepBtn")

	onButton(arg0, arg0.oneStepBtn, function()
		if arg0:isTaskListOverflow() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("award_overflow_tip"))

			return
		else
			local var0 = {}
			local var1 = {}
			local var2 = arg0:getTaskVOList()

			for iter0, iter1 in ipairs(var2) do
				local var3 = iter1:getTaskStatus()
				local var4, var5 = arg0:isTaskOverflow(iter1)

				if var3 == 1 and arg0:isTaskUnlocked(iter1) and not var4 then
					table.insert(var0, iter1)
					table.insert(var1, iter1.id)
				end
			end

			if #var0 > 0 then
				arg0:setLastSubmitTask(var1)
				pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
					resultList = var0
				})
			end
		end
	end, SFX_PANEL)
end

function var0.updateData(arg0)
	arg0.taskVOList = arg0:getTaskVOList()
	arg0.taskVOListForShow = arg0:getTaskVOListForShow()
end

function var0.updateUI(arg0)
	arg0:updateData()
	arg0:updateTaskList()
	arg0:updateTaskProgress()
	arg0:updateOneStepBtn()
end

function var0.updateOutline(arg0)
	return
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = arg0:findTF("Icon", arg1)
	local var1 = arg0:findTF("Count", arg1)

	setText(var1, arg2.count)

	if arg2.type ~= DROP_TYPE_SHIP then
		setImageSprite(var0, LoadSprite(arg2:getIcon()))
	else
		local var2 = Ship.New({
			configId = arg2.id
		}):getPainting()

		setImageSprite(var0, LoadSprite("QIcon/" .. var2))
	end
end

function var0.updateTaskList(arg0)
	arg0.taskUIList:align(#arg0.taskVOListForShow)
end

function var0.updateTask(arg0, arg1, arg2)
	local var0 = arg0:findTF("Go", arg1)
	local var1 = arg0:findTF("Btn", var0)
	local var2 = arg0:findTF("Progress", var0)
	local var3 = arg0:findTF("Text", var2)
	local var4 = arg0:findTF("Get", arg1)
	local var5 = arg0:findTF("Btn", var4)
	local var6 = arg0:findTF("Progress", var4)
	local var7 = arg0:findTF("Text", var6)
	local var8 = arg0:findTF("Got", arg1)
	local var9 = arg2:getTaskStatus()

	setActive(var0, var9 == 0)
	setActive(var4, var9 == 1)
	setActive(var8, var9 == 2)

	local var10 = arg0:findTF("DayImg", arg1)
	local var11 = arg0:getTaskUnlockSignCount(arg2)

	setImageSprite(var10, arg0.daySpriteList[var11])

	local var12 = arg0:findTF("Lock", arg1)

	setActive(var12, not arg0:isTaskUnlocked(arg2))

	local var13 = arg0:findTF("DescText", arg1)

	setText(var13, arg2:getConfig("desc"))

	local var14 = arg2:getProgress()
	local var15 = arg2:getConfig("target_num")

	setSlider(var2, 0, var15, var14)
	setText(var3, var14 .. "/" .. var15)
	setSlider(var6, 0, var15, var14)
	setText(var7, var14 .. "/" .. var15)

	local var16 = arg0:findTF("Drops", arg1)
	local var17 = arg0:getTaskAwardForShow(arg2)
	local var18 = UIItemList.New(var16, arg0.itemTpl)

	var18:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = var17[arg1]

			arg0:updateItem(arg2, var0)
		end
	end)
	var18:align(#var17)
	onButton(arg0, var1, function()
		pg.m02:sendNotification(GAME.TASK_GO, {
			taskVO = arg2
		})
	end, SFX_PANEL)
	onButton(arg0, var5, function()
		local function var0()
			pg.m02:sendNotification(GAME.SUBMIT_TASK, arg2.id)
			arg0:setLastSubmitTask({
				arg2.id
			})
		end

		local var1, var2 = arg0:isTaskOverflow(arg2)

		if var1 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var2,
				onYes = var0
			})
		else
			var0()
		end
	end, SFX_PANEL)
end

function var0.updateTaskProgress(arg0)
	local var0 = arg0:getTaskVOList()
	local var1 = 0
	local var2 = #var0

	for iter0, iter1 in ipairs(var0) do
		if arg0:isTaskUnlocked(iter1) then
			var1 = var1 + 1
		end
	end

	setText(arg0.taskProgressText, var1 .. "/" .. var2)
end

function var0.updateOneStepBtn(arg0)
	local var0 = 0
	local var1 = arg0:getTaskVOList()

	for iter0, iter1 in ipairs(var1) do
		if iter1:getTaskStatus() == 1 and arg0:isTaskUnlocked(iter1) then
			var0 = var0 + 1
		end
	end

	setActive(arg0.oneStepBtnDisable, not (var0 > 1))
end

function var0.getTaskVOList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.return_task_template.all) do
		local var1 = arg0.taskProxy:getTaskVO(iter1)

		table.insert(var0, var1)
	end

	return var0
end

function var0.getTaskVOListForShow(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.taskVOList) do
		if arg0:isTaskUnlocked(iter1) then
			table.insert(var0, iter1)
		else
			table.insert(var1, iter1)
		end
	end

	local function var2(arg0, arg1)
		local var0 = arg0:getTaskStatus()
		local var1 = arg1:getTaskStatus()

		if var0 == 2 then
			var0 = -1
		end

		if var1 == 2 then
			var1 = -1
		end

		if var0 == var1 then
			return arg0:getTaskUnlockSignCount(arg0) < arg0:getTaskUnlockSignCount(arg1)
		else
			return var1 < var0
		end
	end

	table.sort(var0, var2)

	local function var3(arg0, arg1)
		return arg0.id < arg1.id
	end

	table.sort(var1, var3)

	local var4 = {}

	for iter2, iter3 in ipairs(var0) do
		table.insert(var4, iter3)
	end

	for iter4, iter5 in ipairs(var1) do
		table.insert(var4, iter5)
	end

	return var4
end

function var0.getTaskUnlockSignCount(arg0, arg1)
	local var0 = arg1.id

	return pg.return_task_template[var0].reward_date
end

function var0.isTaskUnlocked(arg0, arg1)
	return arg0:getTaskUnlockSignCount(arg1) <= arg0.refluxProxy.signCount
end

function var0.isTaskOverflow(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.gameset.urpt_chapter_max.description[1]
	local var2

	var2 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var1)

	local var3 = arg0:getTaskAwardForShow(arg1)
	local var4 = {
		var3[1].type,
		var3[1].id,
		var3[1].count
	}
	local var5 = {
		var4
	}
	local var6, var7 = Task.StaticJudgeOverflow(false, false, false, true, true, var5)

	return var6, var7
end

function var0.isTaskListOverflow(arg0)
	local var0 = {}
	local var1 = arg0:getTaskVOList()

	for iter0, iter1 in ipairs(var1) do
		if iter1:getTaskStatus() == 1 and arg0:isTaskUnlocked(iter1) then
			local var2 = arg0:getTaskAwardForShow(iter1)
			local var3 = var2[1].type
			local var4 = var2[1].id
			local var5 = var2[1].count
			local var6 = var0[var4]

			if not var6 then
				var6 = {
					var3,
					var4,
					var5
				}
			else
				var6[3] = var6[3] + var5
			end

			var0[var4] = var6
		end
	end

	local var7 = {}

	for iter2, iter3 in pairs(var0) do
		table.insert(var7, iter3)
	end

	local var8, var9 = Task.StaticJudgeOverflow(false, false, false, true, true, var7)

	return var8, var9
end

function var0.setLastSubmitTask(arg0, arg1)
	arg0.lastSubmitTaskIDList = arg1
end

function var0.clearLastSubmitTask(arg0)
	arg0.lastSubmitTaskIDList = {}
end

function var0.calcLastSubmitTaskPT(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.lastSubmitTaskIDList) do
		local var2 = pg.return_task_template[iter1]

		var0 = var0 + var2.pt_award
		var1 = var2.pt_item
	end

	arg0:clearLastSubmitTask()

	return {
		type = DROP_TYPE_ITEM,
		id = var1,
		count = var0
	}
end

function var0.getTaskAwardForShow(arg0, arg1)
	local var0 = arg1.id
	local var1 = pg.return_task_template[var0]
	local var2 = var1.level
	local var3 = arg0.refluxProxy.returnLV
	local var4

	for iter0, iter1 in ipairs(var2) do
		local var5 = iter1[1]
		local var6 = iter1[2]

		if var5 <= var3 and var3 <= var6 then
			var4 = iter0
		end
	end

	local var7 = {}
	local var8 = var1.award_display[var4]
	local var9 = Drop.New({
		type = var8[1],
		id = var8[2],
		count = var8[3]
	})

	table.insert(var7, var9)

	local var10 = var1.pt_award
	local var11 = var1.pt_item
	local var12 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var11,
		count = var10
	})

	table.insert(var7, var12)

	return var7
end

function var0.isAnyTaskCanGetAward()
	local var0 = getProxy(TaskProxy)
	local var1 = getProxy(RefluxProxy)
	local var2 = {}

	for iter0, iter1 in ipairs(pg.return_task_template.all) do
		local var3 = var0:getTaskVO(iter1)

		table.insert(var2, var3)
	end

	local function var4(arg0)
		local var0 = arg0.id

		return pg.return_task_template[var0].reward_date
	end

	local function var5(arg0)
		return var4(arg0) <= var1.signCount
	end

	for iter2, iter3 in ipairs(var2) do
		if iter3:getTaskStatus() == 1 and var5(iter3) then
			return true
		end
	end

	return false
end

return var0
