local var0_0 = class("IslandTaskPage")
local var1_0 = {
	5,
	6,
	7,
	8
}
local var2_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.taskPage = arg1_1
	arg0_1.contextData = arg2_1
	arg0_1.taskItemTpl = findTF(arg3_1, "taskItemTpl")

	setActive(arg0_1.taskItemTpl, false)

	arg0_1.IconTpl = findTF(arg3_1, "IconTpl")

	setActive(arg0_1.IconTpl, false)

	arg0_1._event = arg4_1
	arg0_1.enterTaskId = nil
	arg0_1.enterTaskIds = nil

	if arg0_1.contextData.task_id then
		arg0_1.enterTaskId = arg0_1.contextData.task_id or nil
	elseif arg0_1.contextData.task_ids then
		arg0_1.enterTaskIds = arg0_1.contextData.task_ids or nil
	end

	arg0_1.activityId = ActivityConst.ISLAND_TASK_ID
	arg0_1.hideTask = pg.activity_template[arg0_1.activityId].config_client.hide_task or {}
	arg0_1.leanTweens = {}
	arg0_1.exitFlag = false
	arg0_1.btnGetAll = findTF(arg0_1.taskPage, "btnGetAll")
	arg0_1.taskTagPanel = findTF(arg0_1.taskPage, "taskTagPanel")
	arg0_1.taskListPanel = findTF(arg0_1.taskPage, "taskListPanel")
	arg0_1.scrollRect = findTF(arg0_1.taskPage, "taskListPanel/Content"):GetComponent("LScrollRect")
	arg0_1.taskDetailPanel = findTF(arg0_1.taskPage, "taskDetailPanel")
	arg0_1.detailTag = findTF(arg0_1.taskDetailPanel, "tag")
	arg0_1.detailTitleText = findTF(arg0_1.taskDetailPanel, "title/text")
	arg0_1.detailIcon = findTF(arg0_1.taskDetailPanel, "icon/image")
	arg0_1.detailDescText = findTF(arg0_1.taskDetailPanel, "desc/text")
	arg0_1.detaiProgressText = findTF(arg0_1.taskDetailPanel, "progress/text")
	arg0_1.detailAwardContent = findTF(arg0_1.taskDetailPanel, "awardDisplay/viewport/content")
	arg0_1.detailBtnGo = findTF(arg0_1.taskDetailPanel, "btnGo")
	arg0_1.detailBtnGet = findTF(arg0_1.taskDetailPanel, "btnGet")
	arg0_1.detailBtnSubmit = findTF(arg0_1.taskDetailPanel, "btnSubmit")
	arg0_1.detailBtnDetail = findTF(arg0_1.taskDetailPanel, "btnDetail")
	arg0_1.detailActive = findTF(arg0_1.taskDetailPanel, "active")

	for iter0_1 = 1, var2_0 do
		local var0_1 = findTF(arg0_1.taskTagPanel, "btn" .. iter0_1)

		if iter0_1 <= #var1_0 then
			local var1_1 = var1_0[iter0_1]

			setText(findTF(var0_1, "off/text"), i18n(IslandTaskScene.add_tages[var1_1]))
			setText(findTF(var0_1, "on/text"), i18n(IslandTaskScene.add_tages[var1_1]))
		else
			setActive(var0_1, false)
		end
	end

	setText(findTF(arg0_1.taskDetailPanel, "desc/title"), i18n(IslandTaskScene.ryza_task_detail_content))
	setText(findTF(arg0_1.taskDetailPanel, "awardText/txt"), i18n(IslandTaskScene.ryza_task_detail_award))

	arg0_1.btnTags = {}

	for iter1_1 = 1, var2_0 do
		local var2_1 = iter1_1
		local var3_1 = var1_0[iter1_1]
		local var4_1 = findTF(arg0_1.taskTagPanel, "btn" .. var2_1)

		onButton(arg0_1._event, var4_1, function()
			if arg0_1.clickIndex then
				setActive(findTF(arg0_1.btnTags[arg0_1.clickIndex], "on"), false)

				if arg0_1.clickIndex == var2_1 then
					arg0_1.clickIndex = nil
				else
					arg0_1.clickIndex = var2_1

					setActive(findTF(arg0_1.btnTags[arg0_1.clickIndex], "on"), true)
				end
			else
				arg0_1.clickIndex = var2_1

				setActive(findTF(arg0_1.btnTags[arg0_1.clickIndex], "on"), true)
			end

			arg0_1.tagId = arg0_1.clickIndex and var1_0[arg0_1.clickIndex] or nil

			arg0_1:onClickTag(var2_1)
		end)
		table.insert(arg0_1.btnTags, var4_1)
	end

	function arg0_1.scrollRect.onUpdateItem(arg0_3, arg1_3)
		arg0_1:onUpdateTaskItem(arg0_3, arg1_3)
	end

	arg0_1.iconTfs = {}
	arg0_1.awards = {}

	onButton(arg0_1._event, arg0_1.btnGetAll, function()
		local var0_4 = arg0_1.getAllTasks

		arg0_1._event:emit(IslandTaskMediator.SUBMIT_TASK_ALL, {
			activityId = arg0_1.activityId,
			ids = var0_4
		})
	end, SOUND_BACK)
	onButton(arg0_1._event, arg0_1.detailBtnGo, function()
		local var0_5 = Task.New(arg0_1.selectTask)

		arg0_1._event:emit(IslandTaskMediator.TASK_GO, {
			taskVO = var0_5
		})
	end, SOUND_BACK)
	onButton(arg0_1._event, arg0_1.detailBtnSubmit, function()
		local var0_6 = arg0_1.selectTask:getConfig("type")

		if arg0_1.selectTask:getConfig("sub_type") == 1006 then
			arg0_1._event:emit(IslandTaskScene.OPEN_SUBMIT, arg0_1.selectTask)
		else
			arg0_1._event:emit(IslandTaskMediator.SUBMIT_TASK, {
				activityId = arg0_1.activityId,
				id = arg0_1.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0_1._event, arg0_1.detailBtnGet, function()
		local var0_7 = arg0_1.selectTask:getConfig("type")

		if arg0_1.selectTask:getConfig("sub_type") == 1006 then
			arg0_1._event:emit(IslandTaskScene.OPEN_SUBMIT, arg0_1.selectTask)
		else
			arg0_1._event:emit(IslandTaskMediator.SUBMIT_TASK, {
				activityId = arg0_1.activityId,
				id = arg0_1.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0_1._event, arg0_1.detailBtnDetail, function()
		if arg0_1.selectTask then
			local var0_8 = tonumber(arg0_1.selectTask:getConfig("target_id_2"))

			if var0_8 and var0_8 > 0 then
				local var1_8 = AtelierMaterial.New({
					configId = var0_8,
					count = arg0_1.selectTask:getConfig("target_num")
				})

				arg0_1._event:emit(IslandTaskMediator.SHOW_DETAIL, var1_8)
			end
		end
	end, SOUND_BACK)
	arg0_1:updateTask()
	arg0_1:onClickTag()
end

function var0_0.onUpdateTaskItem(arg0_9, arg1_9, arg2_9)
	if arg0_9.exitFlag then
		return
	end

	arg0_9.leanTweens[arg2_9] = arg2_9

	table.insert(arg0_9.leanTweens, arg2_9)

	local var0_9 = GetComponent(arg2_9, typeof(CanvasGroup))

	var0_9.alpha = 0

	LeanTween.value(arg2_9, 0, 1, 0.3):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_10)
		var0_9.alpha = arg0_10
	end)):setOnComplete(System.Action(function()
		arg0_9.leanTweens[arg2_9] = nil
	end))

	arg1_9 = arg1_9 + 1

	local var1_9 = arg0_9.showTasks[arg1_9]
	local var2_9 = var1_9.id
	local var3_9 = var1_9:getProgress()
	local var4_9 = var1_9:getConfig("name")
	local var5_9 = var1_9:getConfig("ryza_icon")
	local var6_9 = var1_9:isOver()
	local var7_9 = var1_9:isFinish()
	local var8_9 = var1_9:isCircle()
	local var9_9 = var1_9:isDaily()

	setActive(findTF(arg2_9, "selected"), arg0_9.selectIndex == arg1_9)
	setActive(findTF(arg2_9, "typeNew"), var1_9:isNew())
	setActive(findTF(arg2_9, "typeCircle"), var1_9:isCircle() or var1_9:isDaily())
	setActive(findTF(arg2_9, "finish"), var6_9)
	setActive(findTF(arg2_9, "mask"), var6_9)
	setActive(findTF(arg2_9, "complete"), not var6_9 and var7_9 and not var8_9)
	setText(findTF(arg2_9, "desc/text"), setColorStr(shortenString(var4_9, 10), "#9D6B59"))

	if not var5_9 or var5_9 == 0 then
		var5_9 = "attack"
	end

	setImageSprite(findTF(arg2_9, "icon/image"), LoadSprite(IslandTaskScene.icon_atlas, var5_9))
	onButton(arg0_9._event, tf(arg2_9), function()
		if arg0_9.selectItem then
			setActive(findTF(arg0_9.selectItem, "selected"), false)
			setText(findTF(arg0_9.selectItem, "desc/text"), setColorStr(shortenString(arg0_9.selectTask:getConfig("name"), 10), "#9D6B59"))
		end

		setActive(findTF(arg2_9, "selected"), true)
		setText(findTF(arg2_9, "desc/text"), setColorStr(shortenString(var4_9, 10), "#5C3E24"))

		arg0_9.selectIndex = arg1_9
		arg0_9.selectItem = arg2_9
		arg0_9.selectTask = var1_9

		arg0_9:updateDetail()
	end)

	if arg1_9 == 1 then
		triggerButton(arg2_9)

		arg0_9.scrollIndex = nil
	end

	if arg0_9.enterTaskId ~= nil and arg0_9.enterTaskId > 0 then
		if var2_9 == arg0_9.enterTaskId then
			triggerButton(arg2_9)

			arg0_9.enterTaskId = nil
			arg0_9.scrollIndex = nil
		end
	elseif arg0_9.enterTaskIds and #arg0_9.enterTaskIds > 0 then
		for iter0_9, iter1_9 in ipairs(arg0_9.enterTaskIds) do
			if var2_9 == iter1_9 then
				triggerButton(arg2_9)

				arg0_9.enterTaskIds = nil
				arg0_9.scrollIndex = nil
			end
		end
	end
end

function var0_0.updateTask(arg0_13, arg1_13)
	arg0_13.displayTask = {}
	arg0_13.allDisplayTask = {}

	local var0_13 = getProxy(ActivityTaskProxy):getTaskById(arg0_13.activityId)

	arg0_13.getAllTasks = {}

	for iter0_13 = 1, #var0_13 do
		local var1_13 = var0_13[iter0_13]
		local var2_13 = var1_13.id

		if not table.contains(arg0_13.hideTask, var2_13) then
			local var3_13 = var1_13:getProgress()
			local var4_13 = var1_13:getTarget()
			local var5_13 = var1_13:getConfig("ryza_type")

			if not var5_13 or var5_13 <= 0 then
				var5_13 = 999
			end

			local var6_13 = var1_13:getConfig("type")
			local var7_13 = var1_13:getConfig("sub_type")

			if var5_13 > 0 then
				if not arg0_13.displayTask[var5_13] then
					arg0_13.displayTask[var5_13] = {}
				end

				table.insert(arg0_13.displayTask[var5_13], var1_13)
				table.insert(arg0_13.allDisplayTask, var1_13)

				if not var1_13:isFinish() or var1_13:isOver() or var7_13 == 1006 then
					-- block empty
				else
					table.insert(arg0_13.getAllTasks, var2_13)
				end
			end
		end
	end

	local var8_13 = getProxy(ActivityProxy):getActivityById(arg0_13.activityId)
	local var9_13 = {}

	if var8_13 then
		var9_13 = var8_13.data1_list
	end

	if var9_13 and #var9_13 > 0 then
		for iter1_13 = 1, #var9_13 do
			local var10_13 = var9_13[iter1_13]
			local var11_13 = ActivityTask.New(arg0_13.activityId, {
				progress = 0,
				id = var10_13
			})

			var11_13:setOver()

			local var12_13 = var11_13:getConfig("ryza_type")

			if var12_13 > 0 then
				if not arg0_13.displayTask[var12_13] then
					arg0_13.displayTask[var12_13] = {}
				end

				table.insert(arg0_13.displayTask[var12_13], var11_13)
				table.insert(arg0_13.allDisplayTask, var11_13)
			end
		end
	end

	local function var13_13(arg0_14, arg1_14)
		if arg0_14:isOver() and not arg1_14:isOver() then
			return false
		elseif not arg0_14:isOver() and arg1_14:isOver() then
			return true
		end

		if arg0_14:isFinish() and not arg1_14:isFinish() then
			return true
		elseif not arg0_14:isFinish() and arg1_14:isFinish() then
			return false
		end

		if arg0_14:isNew() and not arg1_14:isNew() then
			return true
		elseif not arg0_14:isNew() and arg1_14:isNew() then
			return false
		end

		if arg0_14.id > arg1_14.id then
			return false
		elseif arg0_14.id < arg1_14.id then
			return true
		end
	end

	for iter2_13, iter3_13 in pairs(arg0_13.displayTask) do
		table.sort(iter3_13, var13_13)
	end

	table.sort(arg0_13.allDisplayTask, var13_13)

	if arg1_13 then
		arg0_13:onClickTag()
	end

	if #arg0_13.getAllTasks > 0 then
		setActive(arg0_13.btnGetAll, true)
	else
		setActive(arg0_13.btnGetAll, false)
	end
end

function var0_0.updateDetail(arg0_15)
	local var0_15 = arg0_15.showTasks[arg0_15.selectIndex]
	local var1_15 = var0_15.id
	local var2_15 = var0_15:getProgress()
	local var3_15 = var0_15.target
	local var4_15 = pg.task_data_template[var1_15]
	local var5_15 = var0_15:isFinish()
	local var6_15 = var0_15:isOver()
	local var7_15 = var0_15:isCircle()
	local var8_15 = var0_15:isSubmit()

	arg0_15.awards = var4_15.award_display

	local var9_15 = var4_15.desc
	local var10_15 = var4_15.ryza_icon
	local var11_15 = var0_15:getConfig("sub_type")

	if not var10_15 or var10_15 == 0 then
		var10_15 = "attack"
	end

	if not var8_15 and var3_15 < var2_15 then
		var2_15 = var3_15
	end

	setText(arg0_15.detailDescText, var9_15)

	if not var6_15 then
		setText(arg0_15.detaiProgressText, setColorStr(var2_15, "#C2695B") .. " / " .. setColorStr(var3_15, "#9D6B59"))
	else
		setText(arg0_15.detaiProgressText, "--/--")
	end

	setText(arg0_15.detailTitleText, shortenString(var4_15.name, 11))
	setActive(arg0_15.detailBtnDetail, var11_15 == 1006 and not var5_15 and not var6_15)
	setActive(arg0_15.detailBtnGo, not var6_15 and not var5_15 and var11_15 ~= 1006)
	setActive(arg0_15.detailBtnGet, not var6_15 and var5_15 and not var8_15)
	setActive(arg0_15.detailBtnSubmit, not var6_15 and var5_15 and var8_15)
	setActive(arg0_15.detailActive, not var6_15 and not var5_15 and not var7_15)
	setImageSprite(arg0_15.detailIcon, LoadSprite(IslandTaskScene.icon_atlas, var10_15))

	if #arg0_15.iconTfs < #arg0_15.awards then
		local var12_15 = #arg0_15.awards - #arg0_15.iconTfs

		for iter0_15 = 1, var12_15 do
			local var13_15 = tf(Instantiate(arg0_15.IconTpl))

			setParent(var13_15, arg0_15.detailAwardContent)
			setActive(var13_15, true)
			table.insert(arg0_15.iconTfs, var13_15)
		end
	end

	for iter1_15 = 1, #arg0_15.iconTfs do
		if iter1_15 <= #arg0_15.awards then
			local var14_15 = arg0_15.awards[iter1_15]
			local var15_15 = {
				type = var14_15[1],
				id = var14_15[2],
				count = var14_15[3]
			}

			updateDrop(arg0_15.iconTfs[iter1_15], var15_15)
			onButton(arg0_15._event, arg0_15.iconTfs[iter1_15], function()
				arg0_15._event:emit(BaseUI.ON_DROP, var15_15)
			end, SFX_PANEL)
			setActive(arg0_15.iconTfs[iter1_15], true)
		else
			setActive(arg0_15.iconTfs[iter1_15], false)
		end
	end
end

function var0_0.onClickTag(arg0_17, arg1_17)
	if arg0_17.tagId and arg0_17.tagId > 0 then
		if arg0_17.displayTask[arg0_17.tagId] and #arg0_17.displayTask[arg0_17.tagId] > 0 then
			arg0_17.showTasks = arg0_17.displayTask[arg0_17.tagId]
		else
			triggerButton(arg0_17.btnTags[arg1_17])

			return
		end
	else
		arg0_17.showTasks = arg0_17.allDisplayTask
	end

	if arg0_17.enterTaskId and arg0_17.enterTaskId > 0 then
		for iter0_17 = 1, #arg0_17.showTasks do
			if arg0_17.showTasks[iter0_17].id == arg0_17.enterTaskId then
				arg0_17.scrollIndex = iter0_17
			end
		end
	end

	arg0_17.scrollRect:SetTotalCount(#arg0_17.showTasks, 0)

	if arg0_17.scrollIndex ~= nil then
		local var0_17 = arg0_17.scrollRect:HeadIndexToValue(arg0_17.scrollIndex - 1)

		arg0_17.scrollRect:ScrollTo(var0_17)
	end
end

function var0_0.setActive(arg0_18, arg1_18)
	setActive(arg0_18.taskPage, arg1_18)
end

function var0_0.dispose(arg0_19)
	arg0_19.exitFlag = true

	if arg0_19.leanTweens and #arg0_19.leanTweens > 0 then
		for iter0_19, iter1_19 in pairs(arg0_19.leanTweens) do
			if LeanTween.isTweening(iter1_19) then
				LeanTween.cancel(iter1_19)
			end
		end

		arg0_19.leanTweens = {}
	end

	for iter2_19 = 1, #arg0_19.allDisplayTask do
		local var0_19 = arg0_19.allDisplayTask[iter2_19]

		if var0_19:isNew() then
			var0_19:changeNew()
		end
	end
end

return var0_0
