local var0 = class("AnniversaryScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "AnniversaryUI"
end

function var0.setActivity(arg0, arg1)
	arg0.activityVO = arg1
	arg0.configData = arg0.activityVO:getConfig("config_data") or {}
	arg0.date = arg0.activityVO.data3
	arg0.currTaskId = arg0.activityVO.data2
end

function var0.setTaskList(arg0, arg1)
	arg0.taskVOs = arg1
end

function var0.getTaskById(arg0, arg1)
	local var0 = -1

	for iter0, iter1 in ipairs(arg0.configData) do
		for iter2, iter3 in pairs(iter1) do
			if arg1 == iter3 then
				var0 = iter0
			end
		end
	end

	if var0 ~= -1 then
		if var0 < arg0.date then
			local var1 = Task.New({
				submit_time = 2,
				id = arg1
			})

			var1.progress = var1:getConfig("target_num")

			return var1
		else
			return arg0.taskVOs[arg1]
		end
	end
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("bg/top/back")
	arg0.mainPanel = arg0:findTF("bg/main")
	arg0.scrollRect = arg0:findTF("scroll_rect", arg0.mainPanel)
	arg0.taskGorupContainer = arg0:findTF("scroll_rect/content", arg0.mainPanel)
	arg0.taskGorupTpl = arg0:getTpl("taskGroup", arg0.taskGorupContainer)
	arg0.offset = Vector2(arg0.taskGorupTpl.rect.width / 2 + 30, arg0.taskGorupTpl.rect.height / 2 + 30)
	arg0.taskGroupDesc = arg0:findTF("taskGroup_desc", arg0.taskGorupContainer)
	arg0.bottomPanel = arg0:findTF("bg/bottom")
	arg0.bottomTaskGroups = arg0:findTF("taskGroups", arg0.bottomPanel)
	arg0.bottomBTpl = arg0:getTpl("bottom_task_tpl", arg0.bottomTaskGroups)
	arg0.startPosition = arg0.taskGorupContainer.localPosition
	arg0.titles = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	arg0:initScrollRect()
end

local var1 = 2

function var0.getRow(arg0, arg1)
	return math.floor(arg1 / var1) * 2 + arg1 % var1
end

function var0.initScrollRect(arg0)
	local var0 = arg0.configData
	local var1 = arg0:getRow(#var0)

	arg0.taskGroupTFs = {}

	for iter0 = 0, var1 - 1 do
		for iter1 = 0, var1 - 1 do
			local var2 = arg0.offset.x * iter1
			local var3 = arg0.offset.y * iter0 * -1

			if iter0 % 2 == 0 == (iter1 % 2 == 0) then
				local var4 = cloneTplTo(arg0.taskGorupTpl, arg0.taskGorupContainer)

				var4.localPosition = Vector2(var2, var3)

				table.insert(arg0.taskGroupTFs, var4)
			end
		end
	end

	arg0:updateTaskGroups()

	arg0.dateIndex = math.max(arg0.date, 1)

	arg0:addVerticalDrag(arg0.scrollRect, function()
		local var0 = arg0.dateIndex + 1

		if var0 > #var0 then
			return
		end

		arg0:moveToTaskGroup(var0)
	end, function()
		local var0 = arg0.dateIndex - 1

		if var0 < 1 then
			return
		end

		arg0:moveToTaskGroup(var0)
	end)
	arg0:moveToTaskGroup(arg0.dateIndex, true)
	arg0:initBottomPanel()
end

function var0.initBottomPanel(arg0)
	arg0.bottomTaskGroupTFs = {}

	for iter0, iter1 in ipairs(arg0.configData) do
		local var0 = cloneTplTo(arg0.bottomBTpl, arg0.bottomTaskGroups)

		arg0.bottomTaskGroupTFs[iter0] = var0

		arg0:updateBottomTaskGroup(iter0)
	end
end

function var0.updateBottomTaskGroup(arg0, arg1)
	local var0 = arg0.bottomTaskGroupTFs[arg1]
	local var1 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "h_part" .. arg1)
	local var2 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "part" .. arg1)

	var0:GetComponent(typeof(Image)).sprite = var2
	var0:Find("Image"):GetComponent(typeof(Image)).sprite = var1

	local var3 = arg0.configData[arg1]
	local var4 = _.all(var3, function(arg0)
		local var0 = arg0:getTaskById(arg0)

		return var0 and var0:isReceive()
	end)

	triggerToggle(var0, var4)
end

function var0.updateTaskGroups(arg0)
	for iter0, iter1 in ipairs(arg0.configData) do
		local var0 = arg0.taskGroupTFs[iter0]

		if var0 then
			arg0:updateTaskGroup(var0, iter0, iter1)
		end
	end
end

function var0.updateTaskGroup(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("mask_lock")
	local var1 = arg1:Find("mask_prev_unfinish")
	local var2 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "lihui" .. arg2)

	arg1:Find("icon"):GetComponent(typeof(Image)).sprite = var2

	local var3 = arg2 > arg0.date
	local var4 = false
	local var5 = false

	if var3 then
		local var6 = arg0.activityVO.data1 + (arg2 - 1) * 86400

		var5 = var6 <= pg.TimeMgr.GetInstance():GetServerTime()

		local var7 = pg.TimeMgr.GetInstance():STimeDescC(var6, "%m/%d")

		setText(var0:Find("Text"), var7)
	else
		var4 = _.all(arg3, function(arg0)
			local var0 = arg0:getTaskById(arg0)

			return var0 and var0:isReceive()
		end)
	end

	setActive(var0, var3 and not var5)
	setActive(var1, var3 and var5)
	setActive(arg1:Find("completed"), var4)
end

function var0.updateTaskGroupDesc(arg0, arg1)
	local var0 = arg0.configData[arg1]
	local var1 = arg0:findTF("main/desc", arg0.taskGroupDesc)
	local var2 = var1:Find("Image"):GetComponent(typeof(Image))
	local var3

	if arg0.titles[arg1] then
		var3 = arg0.titles[arg1]
	else
		var3 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "title" .. arg1)
	end

	var2.sprite = var3

	local var4 = arg0:findTF("main/task_list", arg0.taskGroupDesc)
	local var5 = var4:Find("task_tpl")

	setText(var1, i18n("anniversary_task_title_" .. arg1))

	local function var6(arg0, arg1)
		local var0 = arg0:getTaskById(arg1) or Task.New({
			id = arg1
		})

		setText(arg0:Find("name"), var0:getConfig("name"))
		setText(arg0:Find("desc"), var0:getConfig("desc"))
		onButton(arg0, arg0:Find("confirm_btn"), function()
			if var0:isReceive() then
				-- block empty
			elseif not var0:isFinish() then
				arg0:emit(AnniversaryMediator.TO_TASK, var0)
			elseif var0:isFinish() then
				arg0:emit(AnniversaryMediator.ON_SUBMIT_TASK, arg1)
			end
		end, SFX_PANEL)
		setActive(arg0:Find("confirm_btn/go"), not var0:isFinish())
		setActive(arg0:Find("confirm_btn/finished"), var0:isReceive())
		setActive(arg0:Find("confirm_btn/get"), var0:isFinish() and not var0:isReceive())

		local var1 = arg0:findTF("icon", arg0)
		local var2 = var0:getConfig("award_display")[1]

		updateDrop(var1, {
			type = var2[1],
			id = var2[2],
			count = var2[3]
		})
		onButton(arg0, var1, function()
			local var0

			if var2[1] == DROP_TYPE_RESOURCE then
				var0 = id2ItemId(var2[2])
			elseif var2[1] == DROP_TYPE_ITEM then
				var0 = var2[2]
			end

			if var0 then
				arg0:emit(var0.ON_ITEM, var0)
			end
		end, SFX_PANEL)

		arg0:findTF("slider", arg0):GetComponent(typeof(Slider)).value = var0:getProgress() / var0:getConfig("target_num")

		setText(arg0:findTF("slider/Text", arg0), var0:getProgress() .. "/" .. var0:getConfig("target_num"))
	end

	arg0.ulist = UIItemList.New(var4, var5)

	arg0.ulist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var6(arg2, var0[arg1 + 1])
		end
	end)
	arg0.ulist:align(#var0)
end

function var0.moveToTaskGroup(arg0, arg1, arg2, arg3)
	if arg3 then
		LeanTween.cancel(go(arg0.taskGroupDesc))
		LeanTween.cancel(go(arg0.taskGorupContainer))
	elseif LeanTween.isTweening(go(arg0.taskGroupDesc)) or LeanTween.isTweening(go(arg0.taskGorupContainer)) then
		return
	end

	local function var0()
		arg0.dateIndex = arg1
	end

	if arg1 > arg0.date then
		local var1 = arg0:getRow(arg1)
		local var2 = arg0.startPosition.y + (var1 - 1) * arg0.offset.y
		local var3 = arg0.taskGorupContainer.localPosition.x

		LeanTween.moveLocal(go(arg0.taskGorupContainer), Vector3(var3, var2, 0), 0.2):setOnComplete(System.Action(var0))

		arg0.taskGroupDesc.localScale = Vector3(0, 1, 1)
		arg0.overStep = true

		if arg0.dateIndex then
			triggerToggle(arg0.taskGroupTFs[arg0.dateIndex], false)
		end
	else
		if arg2 or arg0.overStep then
			arg0.taskGroupDesc.localScale = Vector3(0, 1, 1)

			arg0:openAnim(arg1, var0)
			arg0:updateTaskGroupDesc(arg1)
		elseif arg0.dateIndex then
			arg0:closeAnim(arg0.dateIndex, function()
				arg0:openAnim(arg1, var0)

				arg0.dateIndex = arg1

				arg0:updateTaskGroupDesc(arg0.dateIndex)
			end)
		end

		arg0.overStep = nil
	end
end

function var0.openAnim(arg0, arg1, arg2)
	local var0 = {}

	assert(arg1, "index can not be nil" .. arg1)

	local var1 = arg0.taskGroupTFs[arg1]
	local var2 = arg0:getRow(arg1)
	local var3 = arg0.startPosition.y + (var2 - 1) * arg0.offset.y
	local var4 = arg0.taskGorupContainer.localPosition.x

	table.insert(var0, function(arg0)
		LeanTween.moveLocal(go(arg0.taskGorupContainer), Vector3(var4, var3, 0), 0.2):setOnComplete(System.Action(arg0))
	end)
	table.insert(var0, function(arg0)
		triggerToggle(var1, true)

		local var0 = var1.eulerAngles.x
		local var1 = var1.eulerAngles.z

		LeanTween.rotate(go(var1), Vector3(var0, 0, var1), 0.2):setFrom(Vector3(var0, -180, var1)):setOnComplete(System.Action(arg0))
	end)
	table.insert(var0, function(arg0)
		LeanTween.scale(arg0.taskGroupDesc, Vector3(1, 1, 1), 0.2):setFrom(Vector3(0, 1, 1)):setOnComplete(System.Action(arg0))

		arg0.taskGroupDesc.position = var1.position

		arg0.taskGroupDesc:SetAsLastSibling()
		var1:SetAsLastSibling()
	end)
	seriesAsync(var0, arg2)
end

function var0.closeAnim(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg0.taskGroupTFs[arg1]

	table.insert(var0, function(arg0)
		LeanTween.scale(arg0.taskGroupDesc, Vector3(0, 1, 1), 0.2):setFrom(Vector3(1, 1, 1)):setOnComplete(System.Action(arg0))
	end)
	table.insert(var0, function(arg0)
		local var0 = var1.eulerAngles.x
		local var1 = var1.eulerAngles.z

		LeanTween.rotate(go(var1), Vector3(var0, 0, var1), 0.2):setFrom(Vector3(var0, -180, var1)):setOnComplete(System.Action(arg0))
	end)
	table.insert(var0, function(arg0)
		triggerToggle(var1, false)
		arg0()
	end)
	seriesAsync(var0, arg2)
end

function var0.addVerticalDrag(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, "EventTriggerListener")
	local var1
	local var2 = 0
	local var3 = 50

	var0:AddBeginDragFunc(function()
		var2 = 0
		var1 = nil
	end)
	var0:AddDragFunc(function(arg0, arg1)
		local var0 = arg1.position

		if not var1 then
			var1 = var0
		end

		var2 = var0.y - var1.y
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if var2 < -var3 then
			if arg3 then
				arg3()
			end
		elseif var2 > var3 and arg2 then
			arg2()
		end
	end)
end

function var0.willExit(arg0)
	return
end

return var0
