local var0_0 = class("AnniversaryScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryUI"
end

function var0_0.setActivity(arg0_2, arg1_2)
	arg0_2.activityVO = arg1_2
	arg0_2.configData = arg0_2.activityVO:getConfig("config_data") or {}
	arg0_2.date = arg0_2.activityVO.data3
	arg0_2.currTaskId = arg0_2.activityVO.data2
end

function var0_0.setTaskList(arg0_3, arg1_3)
	arg0_3.taskVOs = arg1_3
end

function var0_0.getTaskById(arg0_4, arg1_4)
	local var0_4 = -1

	for iter0_4, iter1_4 in ipairs(arg0_4.configData) do
		for iter2_4, iter3_4 in pairs(iter1_4) do
			if arg1_4 == iter3_4 then
				var0_4 = iter0_4
			end
		end
	end

	if var0_4 ~= -1 then
		if var0_4 < arg0_4.date then
			local var1_4 = Task.New({
				submit_time = 2,
				id = arg1_4
			})

			var1_4.progress = var1_4:getConfig("target_num")

			return var1_4
		else
			return arg0_4.taskVOs[arg1_4]
		end
	end
end

function var0_0.init(arg0_5)
	arg0_5.backBtn = arg0_5:findTF("bg/top/back")
	arg0_5.mainPanel = arg0_5:findTF("bg/main")
	arg0_5.scrollRect = arg0_5:findTF("scroll_rect", arg0_5.mainPanel)
	arg0_5.taskGorupContainer = arg0_5:findTF("scroll_rect/content", arg0_5.mainPanel)
	arg0_5.taskGorupTpl = arg0_5:getTpl("taskGroup", arg0_5.taskGorupContainer)
	arg0_5.offset = Vector2(arg0_5.taskGorupTpl.rect.width / 2 + 30, arg0_5.taskGorupTpl.rect.height / 2 + 30)
	arg0_5.taskGroupDesc = arg0_5:findTF("taskGroup_desc", arg0_5.taskGorupContainer)
	arg0_5.bottomPanel = arg0_5:findTF("bg/bottom")
	arg0_5.bottomTaskGroups = arg0_5:findTF("taskGroups", arg0_5.bottomPanel)
	arg0_5.bottomBTpl = arg0_5:getTpl("bottom_task_tpl", arg0_5.bottomTaskGroups)
	arg0_5.startPosition = arg0_5.taskGorupContainer.localPosition
	arg0_5.titles = {}
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	arg0_6:initScrollRect()
end

local var1_0 = 2

function var0_0.getRow(arg0_8, arg1_8)
	return math.floor(arg1_8 / var1_0) * 2 + arg1_8 % var1_0
end

function var0_0.initScrollRect(arg0_9)
	local var0_9 = arg0_9.configData
	local var1_9 = arg0_9:getRow(#var0_9)

	arg0_9.taskGroupTFs = {}

	for iter0_9 = 0, var1_9 - 1 do
		for iter1_9 = 0, var1_0 - 1 do
			local var2_9 = arg0_9.offset.x * iter1_9
			local var3_9 = arg0_9.offset.y * iter0_9 * -1

			if iter0_9 % 2 == 0 == (iter1_9 % 2 == 0) then
				local var4_9 = cloneTplTo(arg0_9.taskGorupTpl, arg0_9.taskGorupContainer)

				var4_9.localPosition = Vector2(var2_9, var3_9)

				table.insert(arg0_9.taskGroupTFs, var4_9)
			end
		end
	end

	arg0_9:updateTaskGroups()

	arg0_9.dateIndex = math.max(arg0_9.date, 1)

	arg0_9:addVerticalDrag(arg0_9.scrollRect, function()
		local var0_10 = arg0_9.dateIndex + 1

		if var0_10 > #var0_9 then
			return
		end

		arg0_9:moveToTaskGroup(var0_10)
	end, function()
		local var0_11 = arg0_9.dateIndex - 1

		if var0_11 < 1 then
			return
		end

		arg0_9:moveToTaskGroup(var0_11)
	end)
	arg0_9:moveToTaskGroup(arg0_9.dateIndex, true)
	arg0_9:initBottomPanel()
end

function var0_0.initBottomPanel(arg0_12)
	arg0_12.bottomTaskGroupTFs = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.configData) do
		local var0_12 = cloneTplTo(arg0_12.bottomBTpl, arg0_12.bottomTaskGroups)

		arg0_12.bottomTaskGroupTFs[iter0_12] = var0_12

		arg0_12:updateBottomTaskGroup(iter0_12)
	end
end

function var0_0.updateBottomTaskGroup(arg0_13, arg1_13)
	local var0_13 = arg0_13.bottomTaskGroupTFs[arg1_13]
	local var1_13 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "h_part" .. arg1_13)
	local var2_13 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "part" .. arg1_13)

	var0_13:GetComponent(typeof(Image)).sprite = var2_13
	var0_13:Find("Image"):GetComponent(typeof(Image)).sprite = var1_13

	local var3_13 = arg0_13.configData[arg1_13]
	local var4_13 = _.all(var3_13, function(arg0_14)
		local var0_14 = arg0_13:getTaskById(arg0_14)

		return var0_14 and var0_14:isReceive()
	end)

	triggerToggle(var0_13, var4_13)
end

function var0_0.updateTaskGroups(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.configData) do
		local var0_15 = arg0_15.taskGroupTFs[iter0_15]

		if var0_15 then
			arg0_15:updateTaskGroup(var0_15, iter0_15, iter1_15)
		end
	end
end

function var0_0.updateTaskGroup(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg1_16:Find("mask_lock")
	local var1_16 = arg1_16:Find("mask_prev_unfinish")
	local var2_16 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "lihui" .. arg2_16)

	arg1_16:Find("icon"):GetComponent(typeof(Image)).sprite = var2_16

	local var3_16 = arg2_16 > arg0_16.date
	local var4_16 = false
	local var5_16 = false

	if var3_16 then
		local var6_16 = arg0_16.activityVO.data1 + (arg2_16 - 1) * 86400

		var5_16 = var6_16 <= pg.TimeMgr.GetInstance():GetServerTime()

		local var7_16 = pg.TimeMgr.GetInstance():STimeDescC(var6_16, "%m/%d")

		setText(var0_16:Find("Text"), var7_16)
	else
		var4_16 = _.all(arg3_16, function(arg0_17)
			local var0_17 = arg0_16:getTaskById(arg0_17)

			return var0_17 and var0_17:isReceive()
		end)
	end

	setActive(var0_16, var3_16 and not var5_16)
	setActive(var1_16, var3_16 and var5_16)
	setActive(arg1_16:Find("completed"), var4_16)
end

function var0_0.updateTaskGroupDesc(arg0_18, arg1_18)
	local var0_18 = arg0_18.configData[arg1_18]
	local var1_18 = arg0_18:findTF("main/desc", arg0_18.taskGroupDesc)
	local var2_18 = var1_18:Find("Image"):GetComponent(typeof(Image))
	local var3_18

	if arg0_18.titles[arg1_18] then
		var3_18 = arg0_18.titles[arg1_18]
	else
		var3_18 = GetSpriteFromAtlas("ui/anniversaryui_atlas", "title" .. arg1_18)
	end

	var2_18.sprite = var3_18

	local var4_18 = arg0_18:findTF("main/task_list", arg0_18.taskGroupDesc)
	local var5_18 = var4_18:Find("task_tpl")

	setText(var1_18, i18n("anniversary_task_title_" .. arg1_18))

	local function var6_18(arg0_19, arg1_19)
		local var0_19 = arg0_18:getTaskById(arg1_19) or Task.New({
			id = arg1_19
		})

		setText(arg0_19:Find("name"), var0_19:getConfig("name"))
		setText(arg0_19:Find("desc"), var0_19:getConfig("desc"))
		onButton(arg0_18, arg0_19:Find("confirm_btn"), function()
			if var0_19:isReceive() then
				-- block empty
			elseif not var0_19:isFinish() then
				arg0_18:emit(AnniversaryMediator.TO_TASK, var0_19)
			elseif var0_19:isFinish() then
				arg0_18:emit(AnniversaryMediator.ON_SUBMIT_TASK, arg1_19)
			end
		end, SFX_PANEL)
		setActive(arg0_19:Find("confirm_btn/go"), not var0_19:isFinish())
		setActive(arg0_19:Find("confirm_btn/finished"), var0_19:isReceive())
		setActive(arg0_19:Find("confirm_btn/get"), var0_19:isFinish() and not var0_19:isReceive())

		local var1_19 = arg0_18:findTF("icon", arg0_19)
		local var2_19 = var0_19:getConfig("award_display")[1]

		updateDrop(var1_19, {
			type = var2_19[1],
			id = var2_19[2],
			count = var2_19[3]
		})
		onButton(arg0_18, var1_19, function()
			local var0_21

			if var2_19[1] == DROP_TYPE_RESOURCE then
				var0_21 = id2ItemId(var2_19[2])
			elseif var2_19[1] == DROP_TYPE_ITEM then
				var0_21 = var2_19[2]
			end

			if var0_21 then
				arg0_18:emit(var0_0.ON_ITEM, var0_21)
			end
		end, SFX_PANEL)

		arg0_18:findTF("slider", arg0_19):GetComponent(typeof(Slider)).value = var0_19:getProgress() / var0_19:getConfig("target_num")

		setText(arg0_18:findTF("slider/Text", arg0_19), var0_19:getProgress() .. "/" .. var0_19:getConfig("target_num"))
	end

	arg0_18.ulist = UIItemList.New(var4_18, var5_18)

	arg0_18.ulist:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			var6_18(arg2_22, var0_18[arg1_22 + 1])
		end
	end)
	arg0_18.ulist:align(#var0_18)
end

function var0_0.moveToTaskGroup(arg0_23, arg1_23, arg2_23, arg3_23)
	if arg3_23 then
		LeanTween.cancel(go(arg0_23.taskGroupDesc))
		LeanTween.cancel(go(arg0_23.taskGorupContainer))
	elseif LeanTween.isTweening(go(arg0_23.taskGroupDesc)) or LeanTween.isTweening(go(arg0_23.taskGorupContainer)) then
		return
	end

	local function var0_23()
		arg0_23.dateIndex = arg1_23
	end

	if arg1_23 > arg0_23.date then
		local var1_23 = arg0_23:getRow(arg1_23)
		local var2_23 = arg0_23.startPosition.y + (var1_23 - 1) * arg0_23.offset.y
		local var3_23 = arg0_23.taskGorupContainer.localPosition.x

		LeanTween.moveLocal(go(arg0_23.taskGorupContainer), Vector3(var3_23, var2_23, 0), 0.2):setOnComplete(System.Action(var0_23))

		arg0_23.taskGroupDesc.localScale = Vector3(0, 1, 1)
		arg0_23.overStep = true

		if arg0_23.dateIndex then
			triggerToggle(arg0_23.taskGroupTFs[arg0_23.dateIndex], false)
		end
	else
		if arg2_23 or arg0_23.overStep then
			arg0_23.taskGroupDesc.localScale = Vector3(0, 1, 1)

			arg0_23:openAnim(arg1_23, var0_23)
			arg0_23:updateTaskGroupDesc(arg1_23)
		elseif arg0_23.dateIndex then
			arg0_23:closeAnim(arg0_23.dateIndex, function()
				arg0_23:openAnim(arg1_23, var0_23)

				arg0_23.dateIndex = arg1_23

				arg0_23:updateTaskGroupDesc(arg0_23.dateIndex)
			end)
		end

		arg0_23.overStep = nil
	end
end

function var0_0.openAnim(arg0_26, arg1_26, arg2_26)
	local var0_26 = {}

	assert(arg1_26, "index can not be nil" .. arg1_26)

	local var1_26 = arg0_26.taskGroupTFs[arg1_26]
	local var2_26 = arg0_26:getRow(arg1_26)
	local var3_26 = arg0_26.startPosition.y + (var2_26 - 1) * arg0_26.offset.y
	local var4_26 = arg0_26.taskGorupContainer.localPosition.x

	table.insert(var0_26, function(arg0_27)
		LeanTween.moveLocal(go(arg0_26.taskGorupContainer), Vector3(var4_26, var3_26, 0), 0.2):setOnComplete(System.Action(arg0_27))
	end)
	table.insert(var0_26, function(arg0_28)
		triggerToggle(var1_26, true)

		local var0_28 = var1_26.eulerAngles.x
		local var1_28 = var1_26.eulerAngles.z

		LeanTween.rotate(go(var1_26), Vector3(var0_28, 0, var1_28), 0.2):setFrom(Vector3(var0_28, -180, var1_28)):setOnComplete(System.Action(arg0_28))
	end)
	table.insert(var0_26, function(arg0_29)
		LeanTween.scale(arg0_26.taskGroupDesc, Vector3(1, 1, 1), 0.2):setFrom(Vector3(0, 1, 1)):setOnComplete(System.Action(arg0_29))

		arg0_26.taskGroupDesc.position = var1_26.position

		arg0_26.taskGroupDesc:SetAsLastSibling()
		var1_26:SetAsLastSibling()
	end)
	seriesAsync(var0_26, arg2_26)
end

function var0_0.closeAnim(arg0_30, arg1_30, arg2_30)
	local var0_30 = {}
	local var1_30 = arg0_30.taskGroupTFs[arg1_30]

	table.insert(var0_30, function(arg0_31)
		LeanTween.scale(arg0_30.taskGroupDesc, Vector3(0, 1, 1), 0.2):setFrom(Vector3(1, 1, 1)):setOnComplete(System.Action(arg0_31))
	end)
	table.insert(var0_30, function(arg0_32)
		local var0_32 = var1_30.eulerAngles.x
		local var1_32 = var1_30.eulerAngles.z

		LeanTween.rotate(go(var1_30), Vector3(var0_32, 0, var1_32), 0.2):setFrom(Vector3(var0_32, -180, var1_32)):setOnComplete(System.Action(arg0_32))
	end)
	table.insert(var0_30, function(arg0_33)
		triggerToggle(var1_30, false)
		arg0_33()
	end)
	seriesAsync(var0_30, arg2_30)
end

function var0_0.addVerticalDrag(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = GetOrAddComponent(arg1_34, "EventTriggerListener")
	local var1_34
	local var2_34 = 0
	local var3_34 = 50

	var0_34:AddBeginDragFunc(function()
		var2_34 = 0
		var1_34 = nil
	end)
	var0_34:AddDragFunc(function(arg0_36, arg1_36)
		local var0_36 = arg1_36.position

		if not var1_34 then
			var1_34 = var0_36
		end

		var2_34 = var0_36.y - var1_34.y
	end)
	var0_34:AddDragEndFunc(function(arg0_37, arg1_37)
		if var2_34 < -var3_34 then
			if arg3_34 then
				arg3_34()
			end
		elseif var2_34 > var3_34 and arg2_34 then
			arg2_34()
		end
	end)
end

function var0_0.willExit(arg0_38)
	return
end

return var0_0
