local var0_0 = class("RefluxTaskView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RefluxTaskUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	arg0_4:Hide()
end

function var0_0.initData(arg0_5)
	arg0_5.taskProxy = getProxy(TaskProxy)
	arg0_5.refluxProxy = getProxy(RefluxProxy)

	local var0_5 = pg.return_task_template.all[#pg.return_task_template.all]

	arg0_5.totalDayCount = pg.return_task_template[var0_5].reward_date
	arg0_5.taskVOList = nil
	arg0_5.taskVOListForShow = nil
	arg0_5.lastSubmitTaskIDList = {}
end

function var0_0.initUI(arg0_6)
	local var0_6 = arg0_6:findTF("DayImg")

	arg0_6.daySpriteList = {}

	for iter0_6 = 0, arg0_6.totalDayCount - 1 do
		local var1_6 = var0_6:GetChild(iter0_6)
		local var2_6 = getImageSprite(var1_6)

		table.insert(arg0_6.daySpriteList, var2_6)
	end

	arg0_6.itemTpl = arg0_6:findTF("ItemTpl")

	local var3_6 = arg0_6:findTF("TaskTpl")
	local var4_6 = arg0_6:findTF("ScrollRect/Container")

	arg0_6.taskUIList = UIItemList.New(var4_6, var3_6)

	arg0_6.taskUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg1_7 = arg1_7 + 1

			local var0_7 = arg0_6.taskVOListForShow[arg1_7]

			arg0_6:updateTask(arg2_7, var0_7)
		end
	end)

	arg0_6.taskProgressText = arg0_6:findTF("BG/ProgressText")
	arg0_6.oneStepBtnDisable = arg0_6:findTF("OneStepDisable")
	arg0_6.oneStepBtn = arg0_6:findTF("OneStepBtn")

	onButton(arg0_6, arg0_6.oneStepBtn, function()
		if arg0_6:isTaskListOverflow() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("award_overflow_tip"))

			return
		else
			local var0_8 = {}
			local var1_8 = {}
			local var2_8 = arg0_6:getTaskVOList()

			for iter0_8, iter1_8 in ipairs(var2_8) do
				local var3_8 = iter1_8:getTaskStatus()
				local var4_8, var5_8 = arg0_6:isTaskOverflow(iter1_8)

				if var3_8 == 1 and arg0_6:isTaskUnlocked(iter1_8) and not var4_8 then
					table.insert(var0_8, iter1_8)
					table.insert(var1_8, iter1_8.id)
				end
			end

			if #var0_8 > 0 then
				arg0_6:setLastSubmitTask(var1_8)
				pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
					resultList = var0_8
				})
			end
		end
	end, SFX_PANEL)
end

function var0_0.updateData(arg0_9)
	arg0_9.taskVOList = arg0_9:getTaskVOList()
	arg0_9.taskVOListForShow = arg0_9:getTaskVOListForShow()
end

function var0_0.updateUI(arg0_10)
	arg0_10:updateData()
	arg0_10:updateTaskList()
	arg0_10:updateTaskProgress()
	arg0_10:updateOneStepBtn()
end

function var0_0.updateOutline(arg0_11)
	return
end

function var0_0.updateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12:findTF("Icon", arg1_12)
	local var1_12 = arg0_12:findTF("Count", arg1_12)

	setText(var1_12, arg2_12.count)

	if arg2_12.type ~= DROP_TYPE_SHIP then
		setImageSprite(var0_12, LoadSprite(arg2_12:getIcon()))
	else
		local var2_12 = Ship.New({
			configId = arg2_12.id
		}):getPainting()

		setImageSprite(var0_12, LoadSprite("QIcon/" .. var2_12))
	end
end

function var0_0.updateTaskList(arg0_13)
	arg0_13.taskUIList:align(#arg0_13.taskVOListForShow)
end

function var0_0.updateTask(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:findTF("Go", arg1_14)
	local var1_14 = arg0_14:findTF("Btn", var0_14)
	local var2_14 = arg0_14:findTF("Progress", var0_14)
	local var3_14 = arg0_14:findTF("Text", var2_14)
	local var4_14 = arg0_14:findTF("Get", arg1_14)
	local var5_14 = arg0_14:findTF("Btn", var4_14)
	local var6_14 = arg0_14:findTF("Progress", var4_14)
	local var7_14 = arg0_14:findTF("Text", var6_14)
	local var8_14 = arg0_14:findTF("Got", arg1_14)
	local var9_14 = arg2_14:getTaskStatus()

	setActive(var0_14, var9_14 == 0)
	setActive(var4_14, var9_14 == 1)
	setActive(var8_14, var9_14 == 2)

	local var10_14 = arg0_14:findTF("DayImg", arg1_14)
	local var11_14 = arg0_14:getTaskUnlockSignCount(arg2_14)

	setImageSprite(var10_14, arg0_14.daySpriteList[var11_14])

	local var12_14 = arg0_14:findTF("Lock", arg1_14)

	setActive(var12_14, not arg0_14:isTaskUnlocked(arg2_14))

	local var13_14 = arg0_14:findTF("DescText", arg1_14)

	setText(var13_14, arg2_14:getConfig("desc"))

	local var14_14 = arg2_14:getProgress()
	local var15_14 = arg2_14:getConfig("target_num")

	setSlider(var2_14, 0, var15_14, var14_14)
	setText(var3_14, var14_14 .. "/" .. var15_14)
	setSlider(var6_14, 0, var15_14, var14_14)
	setText(var7_14, var14_14 .. "/" .. var15_14)

	local var16_14 = arg0_14:findTF("Drops", arg1_14)
	local var17_14 = arg0_14:getTaskAwardForShow(arg2_14)
	local var18_14 = UIItemList.New(var16_14, arg0_14.itemTpl)

	var18_14:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg1_15 = arg1_15 + 1

			local var0_15 = var17_14[arg1_15]

			arg0_14:updateItem(arg2_15, var0_15)
		end
	end)
	var18_14:align(#var17_14)
	onButton(arg0_14, var1_14, function()
		pg.m02:sendNotification(GAME.TASK_GO, {
			taskVO = arg2_14
		})
	end, SFX_PANEL)
	onButton(arg0_14, var5_14, function()
		local function var0_17()
			pg.m02:sendNotification(GAME.SUBMIT_TASK, arg2_14.id)
			arg0_14:setLastSubmitTask({
				arg2_14.id
			})
		end

		local var1_17, var2_17 = arg0_14:isTaskOverflow(arg2_14)

		if var1_17 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var2_17,
				onYes = var0_17
			})
		else
			var0_17()
		end
	end, SFX_PANEL)
end

function var0_0.updateTaskProgress(arg0_19)
	local var0_19 = arg0_19:getTaskVOList()
	local var1_19 = 0
	local var2_19 = #var0_19

	for iter0_19, iter1_19 in ipairs(var0_19) do
		if arg0_19:isTaskUnlocked(iter1_19) then
			var1_19 = var1_19 + 1
		end
	end

	setText(arg0_19.taskProgressText, var1_19 .. "/" .. var2_19)
end

function var0_0.updateOneStepBtn(arg0_20)
	local var0_20 = 0
	local var1_20 = arg0_20:getTaskVOList()

	for iter0_20, iter1_20 in ipairs(var1_20) do
		if iter1_20:getTaskStatus() == 1 and arg0_20:isTaskUnlocked(iter1_20) then
			var0_20 = var0_20 + 1
		end
	end

	setActive(arg0_20.oneStepBtnDisable, not (var0_20 > 1))
end

function var0_0.getTaskVOList(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(pg.return_task_template.all) do
		local var1_21 = arg0_21.taskProxy:getTaskVO(iter1_21)

		table.insert(var0_21, var1_21)
	end

	return var0_21
end

function var0_0.getTaskVOListForShow(arg0_22)
	local var0_22 = {}
	local var1_22 = {}

	for iter0_22, iter1_22 in ipairs(arg0_22.taskVOList) do
		if arg0_22:isTaskUnlocked(iter1_22) then
			table.insert(var0_22, iter1_22)
		else
			table.insert(var1_22, iter1_22)
		end
	end

	local function var2_22(arg0_23, arg1_23)
		local var0_23 = arg0_23:getTaskStatus()
		local var1_23 = arg1_23:getTaskStatus()

		if var0_23 == 2 then
			var0_23 = -1
		end

		if var1_23 == 2 then
			var1_23 = -1
		end

		if var0_23 == var1_23 then
			return arg0_22:getTaskUnlockSignCount(arg0_23) < arg0_22:getTaskUnlockSignCount(arg1_23)
		else
			return var1_23 < var0_23
		end
	end

	table.sort(var0_22, var2_22)

	local function var3_22(arg0_24, arg1_24)
		return arg0_24.id < arg1_24.id
	end

	table.sort(var1_22, var3_22)

	local var4_22 = {}

	for iter2_22, iter3_22 in ipairs(var0_22) do
		table.insert(var4_22, iter3_22)
	end

	for iter4_22, iter5_22 in ipairs(var1_22) do
		table.insert(var4_22, iter5_22)
	end

	return var4_22
end

function var0_0.getTaskUnlockSignCount(arg0_25, arg1_25)
	local var0_25 = arg1_25.id

	return pg.return_task_template[var0_25].reward_date
end

function var0_0.isTaskUnlocked(arg0_26, arg1_26)
	return arg0_26:getTaskUnlockSignCount(arg1_26) <= arg0_26.refluxProxy.signCount
end

function var0_0.isTaskOverflow(arg0_27, arg1_27)
	local var0_27 = getProxy(PlayerProxy):getRawData()
	local var1_27 = pg.gameset.urpt_chapter_max.description[1]
	local var2_27

	var2_27 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var1_27)

	local var3_27 = arg0_27:getTaskAwardForShow(arg1_27)
	local var4_27 = {
		var3_27[1].type,
		var3_27[1].id,
		var3_27[1].count
	}
	local var5_27 = {
		var4_27
	}
	local var6_27, var7_27 = Task.StaticJudgeOverflow(false, false, false, true, true, var5_27)

	return var6_27, var7_27
end

function var0_0.isTaskListOverflow(arg0_28)
	local var0_28 = {}
	local var1_28 = arg0_28:getTaskVOList()

	for iter0_28, iter1_28 in ipairs(var1_28) do
		if iter1_28:getTaskStatus() == 1 and arg0_28:isTaskUnlocked(iter1_28) then
			local var2_28 = arg0_28:getTaskAwardForShow(iter1_28)
			local var3_28 = var2_28[1].type
			local var4_28 = var2_28[1].id
			local var5_28 = var2_28[1].count
			local var6_28 = var0_28[var4_28]

			if not var6_28 then
				var6_28 = {
					var3_28,
					var4_28,
					var5_28
				}
			else
				var6_28[3] = var6_28[3] + var5_28
			end

			var0_28[var4_28] = var6_28
		end
	end

	local var7_28 = {}

	for iter2_28, iter3_28 in pairs(var0_28) do
		table.insert(var7_28, iter3_28)
	end

	local var8_28, var9_28 = Task.StaticJudgeOverflow(false, false, false, true, true, var7_28)

	return var8_28, var9_28
end

function var0_0.setLastSubmitTask(arg0_29, arg1_29)
	arg0_29.lastSubmitTaskIDList = arg1_29
end

function var0_0.clearLastSubmitTask(arg0_30)
	arg0_30.lastSubmitTaskIDList = {}
end

function var0_0.calcLastSubmitTaskPT(arg0_31)
	local var0_31 = 0
	local var1_31 = 0

	for iter0_31, iter1_31 in ipairs(arg0_31.lastSubmitTaskIDList) do
		local var2_31 = pg.return_task_template[iter1_31]

		var0_31 = var0_31 + var2_31.pt_award
		var1_31 = var2_31.pt_item
	end

	arg0_31:clearLastSubmitTask()

	return {
		type = DROP_TYPE_ITEM,
		id = var1_31,
		count = var0_31
	}
end

function var0_0.getTaskAwardForShow(arg0_32, arg1_32)
	local var0_32 = arg1_32.id
	local var1_32 = pg.return_task_template[var0_32]
	local var2_32 = var1_32.level
	local var3_32 = arg0_32.refluxProxy.returnLV
	local var4_32

	for iter0_32, iter1_32 in ipairs(var2_32) do
		local var5_32 = iter1_32[1]
		local var6_32 = iter1_32[2]

		if var5_32 <= var3_32 and var3_32 <= var6_32 then
			var4_32 = iter0_32
		end
	end

	local var7_32 = {}
	local var8_32 = var1_32.award_display[var4_32]
	local var9_32 = Drop.New({
		type = var8_32[1],
		id = var8_32[2],
		count = var8_32[3]
	})

	table.insert(var7_32, var9_32)

	local var10_32 = var1_32.pt_award
	local var11_32 = var1_32.pt_item
	local var12_32 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = var11_32,
		count = var10_32
	})

	table.insert(var7_32, var12_32)

	return var7_32
end

function var0_0.isAnyTaskCanGetAward()
	local var0_33 = getProxy(TaskProxy)
	local var1_33 = getProxy(RefluxProxy)
	local var2_33 = {}

	for iter0_33, iter1_33 in ipairs(pg.return_task_template.all) do
		local var3_33 = var0_33:getTaskVO(iter1_33)

		table.insert(var2_33, var3_33)
	end

	local function var4_33(arg0_34)
		local var0_34 = arg0_34.id

		return pg.return_task_template[var0_34].reward_date
	end

	local function var5_33(arg0_35)
		return var4_33(arg0_35) <= var1_33.signCount
	end

	for iter2_33, iter3_33 in ipairs(var2_33) do
		if iter3_33:getTaskStatus() == 1 and var5_33(iter3_33) then
			return true
		end
	end

	return false
end

return var0_0
