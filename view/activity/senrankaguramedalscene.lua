local var0 = class("SenrankaguraMedalScene", import("..base.BaseUI"))
local var1
local var2
local var3 = 4
local var4 = "shan_luan_task_help"
local var5 = "shan_luan_task_help"

function var0.getUIName(arg0)
	return "SenrankaguraMedalUI"
end

function var0.GetTaskCountAble()
	local var0 = ActivityConst.SENRANKAGURA_TASK_ID

	if not getProxy(ActivityProxy):getActivityById(var0) then
		return false
	end

	local var1 = pg.activity_template[var0].config_client.player_task
	local var2 = {}
	local var3 = 0

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(var2, iter3)
		end
	end

	local var4

	local function var5(arg0)
		if not arg0 then
			return true
		end

		local var0 = getProxy(TaskProxy):getTaskById(arg0)
		local var1 = getProxy(TaskProxy):getFinishTaskById(arg0)

		if not var0 and not var1 then
			return false
		end

		local var2 = pg.task_data_template[arg0].activity_client_config.before

		if var0 and var0:getTaskStatus() <= 0 then
			return false
		end

		return var5(var2)
	end

	for iter4 = 1, #var2 do
		local var6 = var2[iter4]
		local var7 = getProxy(TaskProxy):getTaskById(var6)

		if var7 then
			local var8 = pg.task_data_template[var6].activity_client_config.before

			if var7:getTaskStatus() == 1 then
				local var9 = pg.task_data_template[var6].activity_client_config.before

				if not var9 then
					var3 = var3 + 1
				elseif var5(var9) then
					var3 = var3 + 1
				end
			end
		end
	end

	return var3 > 0, var3
end

function var0.init(arg0)
	arg0.activityId = ActivityConst.SENRANKAGURA_TASK_ID
	arg0.taskActivity = getProxy(ActivityProxy):getActivityById(arg0.activityId)
	arg0.taskIds = pg.activity_template[arg0.activityId].config_client.player_task
	arg0.taskCount = 0
	arg0.allTasksIds = {}

	for iter0, iter1 in ipairs(arg0.taskIds) do
		arg0.taskCount = arg0.taskCount + #iter1

		for iter2, iter3 in ipairs(iter1) do
			table.insert(arg0.allTasksIds, iter3)
		end
	end

	arg0.openTaskFlag = arg0.contextData.task
	arg0.buffs = pg.activity_template[arg0.activityId].config_client.buff
	arg0.ptId = pg.activity_template[arg0.activityId].config_client.pt_id
	arg0.ptName = pg.player_resource[arg0.ptId].name
	arg0.ptMaxNum = #arg0.allTasksIds
	var1 = #arg0.taskIds
	var2 = #arg0.buffs
	arg0.taskListDatas = {}

	for iter4 = 1, #arg0.taskIds do
		local var0 = arg0.taskIds[iter4]
		local var1 = {}

		for iter5, iter6 in ipairs(var0) do
			arg0:initTaskListIds(iter6, var1)
		end

		arg0:sortListDatas(var1)
		table.insert(arg0.taskListDatas, var1)
	end

	local var2 = findTF(arg0._tf, "ad")

	arg0.btnDetail = findTF(var2, "btnDetail")
	arg0.btnBack = findTF(var2, "frame/btnBack")
	arg0.btnHelp = findTF(var2, "frame/btnHelp")
	arg0.btnHome = findTF(var2, "frame/btnHome")
	arg0.hxTf = findTF(var2, "hx")

	setActive(arg0.hxTf, PLATFORM_CODE == PLATFORM_CH)
	onButton(arg0, arg0.btnDetail, function()
		if arg0:getMedalGetAble() then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = ActivityConst.SENRANKAGURA_MEDAL_ID
			})
		elseif arg0.taskActivity then
			arg0:openDetailPane()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end, SOUND_BACK)
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0.btnHome, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var4].tip
		})
	end, SFX_CONFIRM)

	arg0.btnPlayers = {}

	for iter7 = 1, var1 do
		local var3 = iter7
		local var4 = findTF(var2, "player/" .. iter7)

		GetComponent(findTF(var4, "img"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

		if arg0.taskActivity then
			onButton(arg0, var4, function()
				arg0:openTaskPanel(iter7)
			end, SFX_CONFIRM)
		end

		setActive(findTF(var4, "redTip"), false)
		table.insert(arg0.btnPlayers, var4)
	end

	local var5 = findTF(arg0._tf, "pop")

	arg0.detailPanel = findTF(var5, "detailPanel")

	setActive(arg0.detailPanel, false)
	arg0:initDetailPanel()

	arg0.taskPanel = findTF(var5, "taskPanel")

	setActive(arg0.taskPanel, false)
	arg0:initTaskPanel()

	arg0.submitPanel = findTF(var5, "submitPanel")

	setActive(arg0.submitPanel, false)
	arg0:initSubmitPanel()
end

function var0.didEnter(arg0)
	arg0:updateUI()

	if arg0.taskActivity and arg0.openTaskFlag then
		arg0.openTaskFlag = false

		arg0:openTaskPanel()
	end
end

function var0.updateUI(arg0)
	local var0 = arg0:getMedalGetAble()

	setActive(findTF(arg0.btnDetail, "detail"), not var0 and arg0.taskActivity)
	setActive(findTF(arg0.btnDetail, "get"), var0)

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var2 = var1.data2_list
	local var3 = var1:GetPicturePuzzleIds()

	for iter0 = 1, #arg0.btnPlayers do
		local var4 = var3[iter0]
		local var5 = arg0.btnPlayers[iter0]

		setActive(findTF(var5, "medal/icon"), table.contains(var2, var4))
		setActive(findTF(var5, "img/got"), table.contains(var2, var4))
	end

	local var6 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var7 = var6.data1_list
	local var8 = var6.data2_list
	local var9 = false

	for iter1 = 1, #var7 do
		if not var9 and not table.contains(var8, var7[iter1]) then
			var9 = true

			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = var7[iter1],
				actId = var6.id
			})
		end
	end

	if arg0.taskActivity then
		local var10 = arg0:getGetAbleTask()
		local var11 = {}

		for iter2 = 1, #arg0.taskIds do
			local var12 = iter2

			for iter3, iter4 in ipairs(arg0.taskIds[iter2]) do
				if table.contains(var10, iter4) then
					if not var11[var12] then
						var11[var12] = 1
					else
						var11[var12] = var11[var12] + 1
					end
				end
			end
		end

		for iter5 = 1, #arg0.btnPlayers do
			setActive(findTF(arg0.btnPlayers[iter5], "redTip"), var11[iter5] ~= nil)
		end

		arg0:updateDetailPanel()
		arg0:updateTask()
	end
end

function var0.getMedalGetAble(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var1 = var0.data1_list
	local var2 = var0.data2_list
	local var3 = var0:GetPicturePuzzleIds()

	if #var2 == #var3 and var0.data1 ~= 1 then
		return true
	end

	return false
end

function var0.openDetailPane(arg0)
	setActive(arg0.detailPanel, true)
end

function var0.initDetailPanel(arg0)
	arg0.detailSlider = findTF(arg0.detailPanel, "ad/progressSlider")
	arg0.detailClose = findTF(arg0.detailPanel, "ad/btnClose")

	onButton(arg0, findTF(arg0.detailPanel, "ad/black"), function()
		setActive(arg0.detailPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.detailClose, function()
		setActive(arg0.detailPanel, false)
	end)

	arg0.detailProgressTipContent = findTF(arg0.detailPanel, "ad/progressDetail")
	arg0.detailProgressTipTpl = findTF(arg0.detailPanel, "ad/progressDetail/tipTpl")

	setActive(arg0.detailProgressTipTpl, false)

	local var0 = findTF(arg0.detailPanel, "ad/progressDetail").sizeDelta.x

	arg0.medalTfs = {}

	for iter0 = 1, var1 do
		table.insert(arg0.medalTfs, findTF(arg0.detailPanel, "ad/medals/" .. iter0))
	end

	for iter1 = 1, var2 do
		local var1 = arg0.buffs[iter1].pt[1]
		local var2 = tf(instantiate(arg0.detailProgressTipTpl))

		setImageSprite(findTF(var2, "num"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "buff_" .. iter1), true)
		setImageSprite(findTF(var2, "count"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "buff_count_" .. iter1), true)

		var2.anchoredPosition = Vector3(var1 / arg0.ptMaxNum * var0, 0, 0)

		SetParent(var2, arg0.detailProgressTipContent)
		SetActive(var2, true)
	end

	arg0.detailBuffTfs = {}

	for iter2 = 1, var3 do
		local var3 = findTF(arg0.detailPanel, "ad/buff/" .. iter2)

		table.insert(arg0.detailBuffTfs, var3)
	end

	arg0.detailProgressDesc = findTF(arg0.detailPanel, "ad/progressDesc")
	arg0.detailLevelDesc = findTF(arg0.detailPanel, "ad/levelDesc")
end

function var0.updateDetailPanel(arg0)
	local var0 = arg0:getPtNum()
	local var1 = arg0:getBuildLv(var0)
	local var2

	if var1 ~= 0 then
		var2 = arg0.buffs[var1].benefit
	end

	for iter0 = 1, var3 do
		local var3

		if var2 then
			local var4 = var2[iter0]

			var3 = pg.benefit_buff_template[var4].desc
		else
			var3 = i18n("shan_luan_task_buff_default")
		end

		local var5 = arg0.detailBuffTfs[iter0]

		setText(findTF(var5, "desc"), var3)
	end

	setSlider(arg0.detailSlider, 0, arg0.ptMaxNum, var0)

	local var6 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var7 = var6.data1_list
	local var8 = var6.data2_list
	local var9 = var6:GetPicturePuzzleIds()

	for iter1 = 1, #arg0.medalTfs do
		local var10 = arg0.medalTfs[iter1]
		local var11 = var9[iter1]

		setActive(findTF(var10, "icon"), table.contains(var8, var11))
	end

	setText(findTF(arg0.detailProgressDesc, "desc"), i18n("shan_luan_task_progress_tip", arg0:getTaskCompleteCount() .. "/" .. arg0.taskCount))
	setText(findTF(arg0.detailLevelDesc, "desc"), i18n("shan_luan_task_level_tip", "Lv." .. var1))
end

function var0.getTaskCompleteCount(arg0)
	local var0 = 0
	local var1 = arg0:getActiveTask()

	for iter0, iter1 in ipairs(var1) do
		if arg0:getTask(iter1):getTaskStatus() == 2 then
			var0 = var0 + 1
		else
			print()
		end
	end

	return var0
end

function var0.getPtNum(arg0)
	local var0 = 0

	if arg0.ptId then
		var0 = getProxy(PlayerProxy):getData()[arg0.ptName] or 0
	else
		var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetBuildingLevelSum()
	end

	if var0 > arg0.ptMaxNum then
		var0 = arg0.ptMaxNum
	end

	return var0
end

function var0.getBuildLv(arg0, arg1)
	local var0 = 0

	for iter0 = #arg0.buffs, 1, -1 do
		var0 = arg1 >= arg0.buffs[iter0].pt[1] and var0 < iter0 and iter0 or var0
	end

	return var0
end

function var0.initTaskListIds(arg0, arg1, arg2)
	local var0
	local var1 = pg.task_data_template[arg1].activity_client_config.before
	local var2 = pg.task_data_template[arg1].activity_client_config.special or false
	local var3 = {
		id = arg1,
		before = var1,
		special = var2
	}

	for iter0, iter1 in ipairs(arg2) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3.id == var1 then
				table.insert(iter1, var3)

				return
			elseif iter3.before == arg1 then
				table.insert(iter1, var3)

				return
			end
		end
	end

	table.insert(arg2, {
		var3
	})
end

function var0.initTaskPanel(arg0)
	local var0 = findTF(arg0.taskPanel, "ad/frame/btnBack")
	local var1 = findTF(arg0.taskPanel, "ad/frame/btnHelp")
	local var2 = findTF(arg0.taskPanel, "ad/frame/btnHome")

	onButton(arg0, var0, function()
		setActive(arg0.taskPanel, false)
	end, SOUND_BACK)
	onButton(arg0, var2, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_CONFIRM)
	onButton(arg0, var1, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var5].tip
		})
	end, SFX_CONFIRM)

	arg0.taskTagTfs = {}

	local var3 = findTF(arg0.taskPanel, "ad/tag/content")
	local var4 = findTF(arg0.taskPanel, "ad/tag/content/tagTpl")

	setActive(var4, false)

	for iter0 = 1, var1 do
		local var5 = iter0
		local var6 = tf(instantiate(var4))

		setImageSprite(findTF(var6, "icon"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "player_icon_" .. iter0), true)
		SetParent(var6, var3)
		setActive(var6, true)
		table.insert(arg0.taskTagTfs, var6)
		onButton(arg0, var6, function()
			arg0:taskSelectTag(var5, true)
		end, SFX_CONFIRM)
	end

	arg0.taskButtonTpl = findTF(arg0.taskPanel, "ad/taskButtonTpl")
	arg0.taskList = {}

	local var7 = findTF(arg0.taskPanel, "ad/task/content")

	arg0.taskDragTf = findTF(arg0.taskPanel, "ad/task/drag")

	local var8 = findTF(arg0.taskPanel, "ad/taskTpl")
	local var9 = findTF(arg0.taskPanel, "ad/taskButtonTpl")

	setActive(var8, false)
	setActive(var9, false)

	arg0.taskGroups = {}

	for iter1 = 1, var1 do
		local var10 = {}
		local var11 = arg0.taskListDatas[iter1]

		for iter2 = 1, #var11 do
			local var12 = tf(instantiate(var8))

			setParent(var12, var7)
			setActive(var12, true)

			local var13 = var11[iter2]
			local var14 = {}

			for iter3, iter4 in ipairs(var13) do
				local var15 = tf(instantiate(var9))

				var15.anchoredPosition = Vector2(iter4.pos[1] * 325 + iter4.pos[2] * 90, iter4.pos[2] * 190)

				local var16 = iter4.special

				if var16 then
					if iter4.pos[2] ~= 0 then
						setImageSprite(findTF(var15, "get"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_get_" .. 4), true)
						setImageSprite(findTF(var15, "got"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_got_" .. 4), true)
					else
						setImageSprite(findTF(var15, "get"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_get_" .. 2), true)
						setImageSprite(findTF(var15, "got"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_got_" .. 2), true)
					end
				elseif not var16 and iter4.pos[2] ~= 0 then
					setImageSprite(findTF(var15, "get"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_get_" .. 3), true)
					setImageSprite(findTF(var15, "got"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_got_" .. 3), true)
				end

				setActive(var15, true)
				SetParent(var15, var12)
				table.insert(var14, {
					tf = var15,
					data = iter4
				})
				onButton(arg0, var15, function()
					arg0:openSubmitPanel(iter4)
				end, SFX_CONFIRM)
			end

			var10.listTf = var12
			var10.taskDic = var14
		end

		table.insert(arg0.taskGroups, var10)
	end

	arg0.taskButtonTpl = findTF(arg0.taskPanel, "ad/buttonTpl")
	arg0.taskBtnGetAll = findTF(arg0.taskPanel, "ad/btnGetAll")

	onButton(arg0, arg0.taskBtnGetAll, function()
		local var0 = arg0:getGetAbleTask()

		if var0 and #var0 > 0 then
			arg0:emit(SenrankaguraMedalMediator.SUBMIT_TASK_ALL, var0)
		end
	end, SFX_CONFIRM)
end

function var0.updateTask(arg0)
	for iter0 = 1, #arg0.taskGroups do
		local var0 = arg0.taskGroups[iter0].taskDic

		for iter1, iter2 in ipairs(var0) do
			local var1 = iter2.tf
			local var2 = arg0:getTask(iter2.data.id)

			setActive(findTF(var1, "lock"), false)
			setActive(findTF(var1, "getAble"), false)
			setActive(findTF(var1, "get"), false)
			setActive(findTF(var1, "got"), false)

			if var2 then
				if arg0:checkTaskBeforeComplete(var2:getConfig("activity_client_config").before) then
					if var2:getTaskStatus() == 0 then
						setActive(findTF(var1, "get"), true)
					elseif var2:getTaskStatus() == 1 then
						setActive(findTF(var1, "get"), true)
						setActive(findTF(var1, "getAble"), true)
					elseif var2:getTaskStatus() == 2 then
						setActive(findTF(var1, "got"), true)
					end
				else
					setActive(findTF(var1, "lock"), true)
					setActive(findTF(var1, "get"), true)
				end
			else
				setActive(findTF(var1, "lock"), true)
				setActive(findTF(var1, "get"), true)
			end
		end
	end

	if #arg0:getGetAbleTask() > 0 then
		setActive(arg0.taskBtnGetAll, true)
	else
		setActive(arg0.taskBtnGetAll, false)
	end

	for iter3 = 1, #arg0.taskGroups do
		local var3 = arg0.taskGroups[iter3].taskDic
		local var4 = arg0.taskGroups[iter3].listTf

		for iter4, iter5 in ipairs(var3) do
			local var5 = iter5.data.pos
			local var6 = iter5.data.before
			local var7 = iter5.tf

			setActive(findTF(var7, "line/back"), false)
			setActive(findTF(var7, "line/bottom"), false)
			setActive(findTF(var7, "line/top"), false)
			var7:SetAsFirstSibling()

			if not var6 then
				setActive(findTF(var7, "line"), false)
			else
				local var8 = arg0:getTaskPos(var6)
				local var9 = arg0:getTask(var6)
				local var10 = arg0:checkTaskBeforeComplete(var6) and Color.New(0.992156862745098, 0.964705882352941, 0.866666666666667) or Color.New(0.486274509803922, 0.352941176470588, 0.290196078431373)

				if var8[1] < var5[1] then
					setActive(findTF(var7, "line/back"), true)
					setImageColor(findTF(var7, "line/back"), var10)
				elseif var8[2] < var5[2] then
					setActive(findTF(var7, "line/bottom"), true)
					setImageColor(findTF(var7, "line/bottom"), var10)
				else
					setActive(findTF(var7, "line/top"), true)
					setImageColor(findTF(var7, "line/top"), var10)
				end

				setActive(findTF(var7, "line"), true)
			end
		end
	end
end

function var0.checkTaskBeforeComplete(arg0, arg1)
	if not arg1 then
		return true
	end

	local var0 = arg0:getTaskGroupData(arg1).before
	local var1 = arg0:getTask(arg1)

	if not var1 then
		return true
	end

	if var1:getTaskStatus() == 0 then
		return false
	end

	if var1:getTaskStatus() >= 1 then
		return arg0:checkTaskBeforeComplete(var0)
	end

	return true
end

function var0.getTaskGroupData(arg0, arg1)
	for iter0 = 1, #arg0.taskGroups do
		local var0 = arg0.taskGroups[iter0].taskDic

		for iter1, iter2 in ipairs(var0) do
			if iter2.data.id == arg1 then
				return iter2.data
			end
		end
	end

	return nil
end

function var0.getTaskPos(arg0, arg1)
	for iter0 = 1, #arg0.taskGroups do
		local var0 = arg0.taskGroups[iter0].taskDic

		for iter1, iter2 in ipairs(var0) do
			if iter2.data.id == arg1 then
				return iter2.data.pos
			end
		end
	end

	return nil
end

function var0.getTask(arg0, arg1)
	local var0 = getProxy(TaskProxy)
	local var1
	local var2 = var0:getTaskById(arg1)

	if var2 then
		return var2
	end

	local var3 = var0:getFinishTaskById(arg1)

	if var3 then
		return var3
	end

	return nil
end

function var0.getGetAbleTask(arg0)
	local var0 = {}
	local var1 = getProxy(TaskProxy)
	local var2 = arg0:getActiveTask()

	for iter0 = 1, #var2 do
		local var3 = var1:getTaskById(var2[iter0])

		if var3 and var3:getTaskStatus() == 1 then
			table.insert(var0, var3.id)
		end
	end

	return var0
end

function var0.getActiveTask(arg0)
	local var0 = {}

	for iter0 = 1, #arg0.taskGroups do
		local var1 = arg0.taskGroups[iter0].taskDic

		for iter1, iter2 in ipairs(var1) do
			if not iter2.data.before then
				table.insert(var0, iter2.data.id)
			elseif arg0:checkTaskBeforeComplete(iter2.data.before) then
				table.insert(var0, iter2.data.id)
			end
		end
	end

	return var0
end

function var0.taskSelectTag(arg0, arg1, arg2)
	local var0 = 0

	if arg0.currentSelectIndex then
		var0 = math.abs(arg0.currentSelectIndex - arg1)
	end

	arg0.currentSelectIndex = arg1
	arg0.currentSelectTag = arg0.taskTagTfs[arg1]
	arg0.currentTaskDatas = arg0.taskListDatas[arg1]

	for iter0 = 1, #arg0.taskTagTfs do
		local var1 = arg0.taskTagTfs[iter0]

		setActive(findTF(var1, "select"), arg0.currentSelectTag == var1)
	end

	arg0.taskScrollRect = GetComponent(findTF(arg0.taskPanel, "ad/task"), typeof(ScrollRect))

	local var2 = var1 - 1
	local var3 = Vector2(arg0.taskScrollRect.normalizedPosition.x, arg0.taskScrollRect.normalizedPosition.y)

	if arg2 then
		local var4 = arg0.taskScrollRect.normalizedPosition.y
		local var5 = (var2 - (arg1 - 1)) / var2

		if LeanTween.isTweening(go(arg0._tf)) then
			LeanTween.cancel(go(arg0._tf))
		end

		LeanTween.value(go(arg0._tf), var4, var5, 0.3 + var0 * 0.1):setOnUpdate(System.Action_float(function(arg0)
			var3.y = arg0
			arg0.taskScrollRect.normalizedPosition = var3

			arg0.taskScrollRect.onValueChanged:Invoke(var3)
		end))
	else
		scrollTo(arg0.taskScrollRect, 0, (var2 - (arg1 - 1)) / var2)
	end
end

function var0.openTaskPanel(arg0, arg1)
	arg1 = arg1 or 1

	arg0:taskSelectTag(arg1, false)
	setActive(arg0.taskPanel, true)
end

function var0.sortListDatas(arg0, arg1)
	local var0

	local function var1(arg0)
		for iter0, iter1 in ipairs(var0) do
			if iter1[1] == arg0[1] and iter1[2] == arg0[2] then
				return false
			end
		end

		return true
	end

	local function var2(arg0, arg1)
		for iter0, iter1 in ipairs(arg1) do
			if iter1.id == arg0 then
				return iter1
			end
		end
	end

	for iter0 = 1, #arg1 do
		var0 = {}

		local var3 = arg1[iter0]
		local var4

		for iter1 = 1, #var3 do
			local var5
			local var6 = var3[iter1]

			if not var6.before then
				var5 = {
					0,
					0
				}
			elseif var6.before then
				local var7 = var2(var6.before, var3)

				assert(var7, "找不到前置id.." .. var6.before)

				local var8 = var7.pos
				local var9 = {
					var8[1] + 1,
					var8[2]
				}

				for iter2 = 1, 10 do
					if var1(var9) then
						break
					else
						if iter2 == 1 then
							var9[1] = var9[1] - 1
						end

						if var9[2] > 0 then
							var9[2] = var9[2] * -1
						else
							var9[2] = math.abs(var9[2]) + 1
						end

						if var8[2] - var9[2] > 1 then
							var7.pos = {
								var9[1],
								var9[2]
							}
							var9[1] = var9[1] + 1
						end
					end

					assert(iter2 ~= 10, "任务分支超过10个")
				end

				var5 = var9
			end

			var6.pos = var5

			table.insert(var0, var5)
		end
	end
end

function var0.openSubmitPanel(arg0, arg1)
	setActive(arg0.submitPanel, true)

	local var0 = arg0.currentSelectIndex

	setImageSprite(findTF(arg0.submitPanel, "icon/img"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "player_icon_" .. var0), true)

	local var1 = arg0:getTask(arg1.id)
	local var2 = arg0:checkTaskBeforeComplete(arg1.before)

	if var1 then
		arg0.selectTask = var1

		setText(findTF(arg0.submitPanel, "taskDesc"), var1:getConfig("desc"))
		setText(findTF(arg0.submitPanel, "img/taskName"), var1:getConfig("name"))

		local var3 = var1:getProgress()
		local var4 = var1:getConfig("target_num")

		setText(findTF(arg0.submitPanel, "progress/taskProgress"), setColorStr(var3, "#C2695B") .. "/" .. setColorStr(var4, "#9D6B59"))

		local var5 = var1:getConfig("award_display")

		arg0:setSubmitAward(var5)
		setActive(arg0.submitGo, var1:getTaskStatus() == 0 or not var2)
		setActive(arg0.submitGet, var1:getTaskStatus() == 1 and var2)
		setActive(arg0.submitGot, var1:getTaskStatus() == 2)
	end
end

function var0.initSubmitPanel(arg0)
	arg0.submitGet = findTF(arg0.submitPanel, "get")
	arg0.submitGot = findTF(arg0.submitPanel, "got")
	arg0.submitGo = findTF(arg0.submitPanel, "go")
	arg0.submitbtnBack = findTF(arg0.submitPanel, "back")
	arg0.submitDisplayContent = findTF(arg0.submitPanel, "itemDisplay/viewport/content")
	arg0.submitItemTpl = findTF(arg0.submitPanel, "itemDisplay/viewport/content/item")

	setActive(arg0.submitItemTpl, false)

	arg0.submitItemDesc = findTF(arg0.submitPanel, "itemDesc")
	arg0.submitItems = {}

	onButton(arg0, findTF(arg0.submitPanel, "black"), function()
		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.submitbtnBack, function()
		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.submitGet, function()
		if arg0.selectTask then
			arg0:emit(SenrankaguraMedalMediator.SUBMIT_TASK, arg0.selectTask.id)
		end

		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.submitGo, function()
		setActive(arg0.submitPanel, false)

		if arg0.selectTask then
			arg0:emit(SenrankaguraMedalMediator.TASK_GO, arg0.selectTask)
		end
	end, SOUND_BACK)
	setText(findTF(arg0.submitPanel, "bg/txtDesc"), i18n("ryza_task_detail_content"))
	setText(findTF(arg0.submitPanel, "bg/txtAward"), i18n("ryza_task_detail_award"))
end

function var0.setSubmitAward(arg0, arg1)
	if #arg0.submitItems < #arg1 then
		for iter0 = 1, #arg1 - #arg0.submitItems do
			local var0 = tf(instantiate(arg0.submitItemTpl))

			setParent(var0, arg0.submitDisplayContent)
			table.insert(arg0.submitItems, var0)
		end
	end

	for iter1 = 1, #arg0.submitItems do
		local var1 = arg0.submitItems[iter1]

		if iter1 <= #arg1 then
			local var2 = {
				type = arg1[iter1][1],
				id = arg1[iter1][2],
				count = arg1[iter1][3]
			}

			updateDrop(var1, var2)
			onButton(arg0, var1, function()
				arg0:emit(BaseUI.ON_DROP, var2)
			end, SFX_PANEL)
			setActive(var1, true)
		else
			setActive(var1, false)
		end
	end
end

function var0.willExit(arg0)
	if LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end
end

return var0
