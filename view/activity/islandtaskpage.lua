local var0 = class("IslandTaskPage")
local var1 = {
	5,
	6,
	7,
	8
}
local var2 = 4

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.taskPage = arg1
	arg0.contextData = arg2
	arg0.taskItemTpl = findTF(arg3, "taskItemTpl")

	setActive(arg0.taskItemTpl, false)

	arg0.IconTpl = findTF(arg3, "IconTpl")

	setActive(arg0.IconTpl, false)

	arg0._event = arg4
	arg0.enterTaskId = nil
	arg0.enterTaskIds = nil

	if arg0.contextData.task_id then
		arg0.enterTaskId = arg0.contextData.task_id or nil
	elseif arg0.contextData.task_ids then
		arg0.enterTaskIds = arg0.contextData.task_ids or nil
	end

	arg0.activityId = ActivityConst.ISLAND_TASK_ID
	arg0.hideTask = pg.activity_template[arg0.activityId].config_client.hide_task or {}
	arg0.leanTweens = {}
	arg0.exitFlag = false
	arg0.btnGetAll = findTF(arg0.taskPage, "btnGetAll")
	arg0.taskTagPanel = findTF(arg0.taskPage, "taskTagPanel")
	arg0.taskListPanel = findTF(arg0.taskPage, "taskListPanel")
	arg0.scrollRect = findTF(arg0.taskPage, "taskListPanel/Content"):GetComponent("LScrollRect")
	arg0.taskDetailPanel = findTF(arg0.taskPage, "taskDetailPanel")
	arg0.detailTag = findTF(arg0.taskDetailPanel, "tag")
	arg0.detailTitleText = findTF(arg0.taskDetailPanel, "title/text")
	arg0.detailIcon = findTF(arg0.taskDetailPanel, "icon/image")
	arg0.detailDescText = findTF(arg0.taskDetailPanel, "desc/text")
	arg0.detaiProgressText = findTF(arg0.taskDetailPanel, "progress/text")
	arg0.detailAwardContent = findTF(arg0.taskDetailPanel, "awardDisplay/viewport/content")
	arg0.detailBtnGo = findTF(arg0.taskDetailPanel, "btnGo")
	arg0.detailBtnGet = findTF(arg0.taskDetailPanel, "btnGet")
	arg0.detailBtnSubmit = findTF(arg0.taskDetailPanel, "btnSubmit")
	arg0.detailBtnDetail = findTF(arg0.taskDetailPanel, "btnDetail")
	arg0.detailActive = findTF(arg0.taskDetailPanel, "active")

	for iter0 = 1, var2 do
		local var0 = findTF(arg0.taskTagPanel, "btn" .. iter0)

		if iter0 <= #var1 then
			local var1 = var1[iter0]

			setText(findTF(var0, "off/text"), i18n(IslandTaskScene.add_tages[var1]))
			setText(findTF(var0, "on/text"), i18n(IslandTaskScene.add_tages[var1]))
		else
			setActive(var0, false)
		end
	end

	setText(findTF(arg0.taskDetailPanel, "desc/title"), i18n(IslandTaskScene.ryza_task_detail_content))
	setText(findTF(arg0.taskDetailPanel, "awardText/txt"), i18n(IslandTaskScene.ryza_task_detail_award))

	arg0.btnTags = {}

	for iter1 = 1, var2 do
		local var2 = iter1
		local var3 = var1[iter1]
		local var4 = findTF(arg0.taskTagPanel, "btn" .. var2)

		onButton(arg0._event, var4, function()
			if arg0.clickIndex then
				setActive(findTF(arg0.btnTags[arg0.clickIndex], "on"), false)

				if arg0.clickIndex == var2 then
					arg0.clickIndex = nil
				else
					arg0.clickIndex = var2

					setActive(findTF(arg0.btnTags[arg0.clickIndex], "on"), true)
				end
			else
				arg0.clickIndex = var2

				setActive(findTF(arg0.btnTags[arg0.clickIndex], "on"), true)
			end

			arg0.tagId = arg0.clickIndex and var1[arg0.clickIndex] or nil

			arg0:onClickTag(var2)
		end)
		table.insert(arg0.btnTags, var4)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateTaskItem(arg0, arg1)
	end

	arg0.iconTfs = {}
	arg0.awards = {}

	onButton(arg0._event, arg0.btnGetAll, function()
		local var0 = arg0.getAllTasks

		arg0._event:emit(IslandTaskMediator.SUBMIT_TASK_ALL, {
			activityId = arg0.activityId,
			ids = var0
		})
	end, SOUND_BACK)
	onButton(arg0._event, arg0.detailBtnGo, function()
		local var0 = Task.New(arg0.selectTask)

		arg0._event:emit(IslandTaskMediator.TASK_GO, {
			taskVO = var0
		})
	end, SOUND_BACK)
	onButton(arg0._event, arg0.detailBtnSubmit, function()
		local var0 = arg0.selectTask:getConfig("type")

		if arg0.selectTask:getConfig("sub_type") == 1006 then
			arg0._event:emit(IslandTaskScene.OPEN_SUBMIT, arg0.selectTask)
		else
			arg0._event:emit(IslandTaskMediator.SUBMIT_TASK, {
				activityId = arg0.activityId,
				id = arg0.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0._event, arg0.detailBtnGet, function()
		local var0 = arg0.selectTask:getConfig("type")

		if arg0.selectTask:getConfig("sub_type") == 1006 then
			arg0._event:emit(IslandTaskScene.OPEN_SUBMIT, arg0.selectTask)
		else
			arg0._event:emit(IslandTaskMediator.SUBMIT_TASK, {
				activityId = arg0.activityId,
				id = arg0.selectTask.id
			})
		end
	end, SOUND_BACK)
	onButton(arg0._event, arg0.detailBtnDetail, function()
		if arg0.selectTask then
			local var0 = tonumber(arg0.selectTask:getConfig("target_id_2"))

			if var0 and var0 > 0 then
				local var1 = AtelierMaterial.New({
					configId = var0,
					count = arg0.selectTask:getConfig("target_num")
				})

				arg0._event:emit(IslandTaskMediator.SHOW_DETAIL, var1)
			end
		end
	end, SOUND_BACK)
	arg0:updateTask()
	arg0:onClickTag()
end

function var0.onUpdateTaskItem(arg0, arg1, arg2)
	if arg0.exitFlag then
		return
	end

	arg0.leanTweens[arg2] = arg2

	table.insert(arg0.leanTweens, arg2)

	local var0 = GetComponent(arg2, typeof(CanvasGroup))

	var0.alpha = 0

	LeanTween.value(arg2, 0, 1, 0.3):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.leanTweens[arg2] = nil
	end))

	arg1 = arg1 + 1

	local var1 = arg0.showTasks[arg1]
	local var2 = var1.id
	local var3 = var1:getProgress()
	local var4 = var1:getConfig("name")
	local var5 = var1:getConfig("ryza_icon")
	local var6 = var1:isOver()
	local var7 = var1:isFinish()
	local var8 = var1:isCircle()
	local var9 = var1:isDaily()

	setActive(findTF(arg2, "selected"), arg0.selectIndex == arg1)
	setActive(findTF(arg2, "typeNew"), var1:isNew())
	setActive(findTF(arg2, "typeCircle"), var1:isCircle() or var1:isDaily())
	setActive(findTF(arg2, "finish"), var6)
	setActive(findTF(arg2, "mask"), var6)
	setActive(findTF(arg2, "complete"), not var6 and var7 and not var8)
	setText(findTF(arg2, "desc/text"), setColorStr(shortenString(var4, 10), "#9D6B59"))

	if not var5 or var5 == 0 then
		var5 = "attack"
	end

	setImageSprite(findTF(arg2, "icon/image"), LoadSprite(IslandTaskScene.icon_atlas, var5))
	onButton(arg0._event, tf(arg2), function()
		if arg0.selectItem then
			setActive(findTF(arg0.selectItem, "selected"), false)
			setText(findTF(arg0.selectItem, "desc/text"), setColorStr(shortenString(arg0.selectTask:getConfig("name"), 10), "#9D6B59"))
		end

		setActive(findTF(arg2, "selected"), true)
		setText(findTF(arg2, "desc/text"), setColorStr(shortenString(var4, 10), "#5C3E24"))

		arg0.selectIndex = arg1
		arg0.selectItem = arg2
		arg0.selectTask = var1

		arg0:updateDetail()
	end)

	if arg1 == 1 then
		triggerButton(arg2)

		arg0.scrollIndex = nil
	end

	if arg0.enterTaskId ~= nil and arg0.enterTaskId > 0 then
		if var2 == arg0.enterTaskId then
			triggerButton(arg2)

			arg0.enterTaskId = nil
			arg0.scrollIndex = nil
		end
	elseif arg0.enterTaskIds and #arg0.enterTaskIds > 0 then
		for iter0, iter1 in ipairs(arg0.enterTaskIds) do
			if var2 == iter1 then
				triggerButton(arg2)

				arg0.enterTaskIds = nil
				arg0.scrollIndex = nil
			end
		end
	end
end

function var0.updateTask(arg0, arg1)
	arg0.displayTask = {}
	arg0.allDisplayTask = {}

	local var0 = getProxy(ActivityTaskProxy):getTaskById(arg0.activityId)

	arg0.getAllTasks = {}

	for iter0 = 1, #var0 do
		local var1 = var0[iter0]
		local var2 = var1.id

		if not table.contains(arg0.hideTask, var2) then
			local var3 = var1:getProgress()
			local var4 = var1:getTarget()
			local var5 = var1:getConfig("ryza_type")

			if not var5 or var5 <= 0 then
				var5 = 999
			end

			local var6 = var1:getConfig("type")
			local var7 = var1:getConfig("sub_type")

			if var5 > 0 then
				if not arg0.displayTask[var5] then
					arg0.displayTask[var5] = {}
				end

				table.insert(arg0.displayTask[var5], var1)
				table.insert(arg0.allDisplayTask, var1)

				if not var1:isFinish() or var1:isOver() or var7 == 1006 then
					-- block empty
				else
					table.insert(arg0.getAllTasks, var2)
				end
			end
		end
	end

	local var8 = getProxy(ActivityProxy):getActivityById(arg0.activityId)
	local var9 = {}

	if var8 then
		var9 = var8.data1_list
	end

	if var9 and #var9 > 0 then
		for iter1 = 1, #var9 do
			local var10 = var9[iter1]
			local var11 = ActivityTask.New(arg0.activityId, {
				progress = 0,
				id = var10
			})

			var11:setOver()

			local var12 = var11:getConfig("ryza_type")

			if var12 > 0 then
				if not arg0.displayTask[var12] then
					arg0.displayTask[var12] = {}
				end

				table.insert(arg0.displayTask[var12], var11)
				table.insert(arg0.allDisplayTask, var11)
			end
		end
	end

	local function var13(arg0, arg1)
		if arg0:isOver() and not arg1:isOver() then
			return false
		elseif not arg0:isOver() and arg1:isOver() then
			return true
		end

		if arg0:isFinish() and not arg1:isFinish() then
			return true
		elseif not arg0:isFinish() and arg1:isFinish() then
			return false
		end

		if arg0:isNew() and not arg1:isNew() then
			return true
		elseif not arg0:isNew() and arg1:isNew() then
			return false
		end

		if arg0.id > arg1.id then
			return false
		elseif arg0.id < arg1.id then
			return true
		end
	end

	for iter2, iter3 in pairs(arg0.displayTask) do
		table.sort(iter3, var13)
	end

	table.sort(arg0.allDisplayTask, var13)

	if arg1 then
		arg0:onClickTag()
	end

	if #arg0.getAllTasks > 0 then
		setActive(arg0.btnGetAll, true)
	else
		setActive(arg0.btnGetAll, false)
	end
end

function var0.updateDetail(arg0)
	local var0 = arg0.showTasks[arg0.selectIndex]
	local var1 = var0.id
	local var2 = var0:getProgress()
	local var3 = var0.target
	local var4 = pg.task_data_template[var1]
	local var5 = var0:isFinish()
	local var6 = var0:isOver()
	local var7 = var0:isCircle()
	local var8 = var0:isSubmit()

	arg0.awards = var4.award_display

	local var9 = var4.desc
	local var10 = var4.ryza_icon
	local var11 = var0:getConfig("sub_type")

	if not var10 or var10 == 0 then
		var10 = "attack"
	end

	if not var8 and var3 < var2 then
		var2 = var3
	end

	setText(arg0.detailDescText, var9)

	if not var6 then
		setText(arg0.detaiProgressText, setColorStr(var2, "#C2695B") .. " / " .. setColorStr(var3, "#9D6B59"))
	else
		setText(arg0.detaiProgressText, "--/--")
	end

	setText(arg0.detailTitleText, shortenString(var4.name, 11))
	setActive(arg0.detailBtnDetail, var11 == 1006 and not var5 and not var6)
	setActive(arg0.detailBtnGo, not var6 and not var5 and var11 ~= 1006)
	setActive(arg0.detailBtnGet, not var6 and var5 and not var8)
	setActive(arg0.detailBtnSubmit, not var6 and var5 and var8)
	setActive(arg0.detailActive, not var6 and not var5 and not var7)
	setImageSprite(arg0.detailIcon, LoadSprite(IslandTaskScene.icon_atlas, var10))

	if #arg0.iconTfs < #arg0.awards then
		local var12 = #arg0.awards - #arg0.iconTfs

		for iter0 = 1, var12 do
			local var13 = tf(Instantiate(arg0.IconTpl))

			setParent(var13, arg0.detailAwardContent)
			setActive(var13, true)
			table.insert(arg0.iconTfs, var13)
		end
	end

	for iter1 = 1, #arg0.iconTfs do
		if iter1 <= #arg0.awards then
			local var14 = arg0.awards[iter1]
			local var15 = {
				type = var14[1],
				id = var14[2],
				count = var14[3]
			}

			updateDrop(arg0.iconTfs[iter1], var15)
			onButton(arg0._event, arg0.iconTfs[iter1], function()
				arg0._event:emit(BaseUI.ON_DROP, var15)
			end, SFX_PANEL)
			setActive(arg0.iconTfs[iter1], true)
		else
			setActive(arg0.iconTfs[iter1], false)
		end
	end
end

function var0.onClickTag(arg0, arg1)
	if arg0.tagId and arg0.tagId > 0 then
		if arg0.displayTask[arg0.tagId] and #arg0.displayTask[arg0.tagId] > 0 then
			arg0.showTasks = arg0.displayTask[arg0.tagId]
		else
			triggerButton(arg0.btnTags[arg1])

			return
		end
	else
		arg0.showTasks = arg0.allDisplayTask
	end

	if arg0.enterTaskId and arg0.enterTaskId > 0 then
		for iter0 = 1, #arg0.showTasks do
			if arg0.showTasks[iter0].id == arg0.enterTaskId then
				arg0.scrollIndex = iter0
			end
		end
	end

	arg0.scrollRect:SetTotalCount(#arg0.showTasks, 0)

	if arg0.scrollIndex ~= nil then
		local var0 = arg0.scrollRect:HeadIndexToValue(arg0.scrollIndex - 1)

		arg0.scrollRect:ScrollTo(var0)
	end
end

function var0.setActive(arg0, arg1)
	setActive(arg0.taskPage, arg1)
end

function var0.dispose(arg0)
	arg0.exitFlag = true

	if arg0.leanTweens and #arg0.leanTweens > 0 then
		for iter0, iter1 in pairs(arg0.leanTweens) do
			if LeanTween.isTweening(iter1) then
				LeanTween.cancel(iter1)
			end
		end

		arg0.leanTweens = {}
	end

	for iter2 = 1, #arg0.allDisplayTask do
		local var0 = arg0.allDisplayTask[iter2]

		if var0:isNew() then
			var0:changeNew()
		end
	end
end

return var0
