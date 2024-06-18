local var0_0 = class("SenrankaguraMedalScene", import("..base.BaseUI"))
local var1_0
local var2_0
local var3_0 = 4
local var4_0 = "shan_luan_task_help"
local var5_0 = "shan_luan_task_help"

function var0_0.getUIName(arg0_1)
	return "SenrankaguraMedalUI"
end

function var0_0.GetTaskCountAble()
	local var0_2 = ActivityConst.SENRANKAGURA_TASK_ID

	if not getProxy(ActivityProxy):getActivityById(var0_2) then
		return false
	end

	local var1_2 = pg.activity_template[var0_2].config_client.player_task
	local var2_2 = {}
	local var3_2 = 0

	for iter0_2, iter1_2 in ipairs(var1_2) do
		for iter2_2, iter3_2 in ipairs(iter1_2) do
			table.insert(var2_2, iter3_2)
		end
	end

	local var4_2

	local function var5_2(arg0_3)
		if not arg0_3 then
			return true
		end

		local var0_3 = getProxy(TaskProxy):getTaskById(arg0_3)
		local var1_3 = getProxy(TaskProxy):getFinishTaskById(arg0_3)

		if not var0_3 and not var1_3 then
			return false
		end

		local var2_3 = pg.task_data_template[arg0_3].activity_client_config.before

		if var0_3 and var0_3:getTaskStatus() <= 0 then
			return false
		end

		return var5_2(var2_3)
	end

	for iter4_2 = 1, #var2_2 do
		local var6_2 = var2_2[iter4_2]
		local var7_2 = getProxy(TaskProxy):getTaskById(var6_2)

		if var7_2 then
			local var8_2 = pg.task_data_template[var6_2].activity_client_config.before

			if var7_2:getTaskStatus() == 1 then
				local var9_2 = pg.task_data_template[var6_2].activity_client_config.before

				if not var9_2 then
					var3_2 = var3_2 + 1
				elseif var5_2(var9_2) then
					var3_2 = var3_2 + 1
				end
			end
		end
	end

	return var3_2 > 0, var3_2
end

function var0_0.init(arg0_4)
	arg0_4.activityId = ActivityConst.SENRANKAGURA_TASK_ID
	arg0_4.taskActivity = getProxy(ActivityProxy):getActivityById(arg0_4.activityId)
	arg0_4.taskIds = pg.activity_template[arg0_4.activityId].config_client.player_task
	arg0_4.taskCount = 0
	arg0_4.allTasksIds = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.taskIds) do
		arg0_4.taskCount = arg0_4.taskCount + #iter1_4

		for iter2_4, iter3_4 in ipairs(iter1_4) do
			table.insert(arg0_4.allTasksIds, iter3_4)
		end
	end

	arg0_4.openTaskFlag = arg0_4.contextData.task
	arg0_4.buffs = pg.activity_template[arg0_4.activityId].config_client.buff
	arg0_4.ptId = pg.activity_template[arg0_4.activityId].config_client.pt_id
	arg0_4.ptName = pg.player_resource[arg0_4.ptId].name
	arg0_4.ptMaxNum = #arg0_4.allTasksIds
	var1_0 = #arg0_4.taskIds
	var2_0 = #arg0_4.buffs
	arg0_4.taskListDatas = {}

	for iter4_4 = 1, #arg0_4.taskIds do
		local var0_4 = arg0_4.taskIds[iter4_4]
		local var1_4 = {}

		for iter5_4, iter6_4 in ipairs(var0_4) do
			arg0_4:initTaskListIds(iter6_4, var1_4)
		end

		arg0_4:sortListDatas(var1_4)
		table.insert(arg0_4.taskListDatas, var1_4)
	end

	local var2_4 = findTF(arg0_4._tf, "ad")

	arg0_4.btnDetail = findTF(var2_4, "btnDetail")
	arg0_4.btnBack = findTF(var2_4, "frame/btnBack")
	arg0_4.btnHelp = findTF(var2_4, "frame/btnHelp")
	arg0_4.btnHome = findTF(var2_4, "frame/btnHome")
	arg0_4.hxTf = findTF(var2_4, "hx")

	setActive(arg0_4.hxTf, PLATFORM_CODE == PLATFORM_CH)
	onButton(arg0_4, arg0_4.btnDetail, function()
		if arg0_4:getMedalGetAble() then
			pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = ActivityConst.SENRANKAGURA_MEDAL_ID
			})
		elseif arg0_4.taskActivity then
			arg0_4:openDetailPane()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:closeView()
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4.btnHome, function()
		arg0_4:emit(BaseUI.ON_HOME)
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var4_0].tip
		})
	end, SFX_CONFIRM)

	arg0_4.btnPlayers = {}

	for iter7_4 = 1, var1_0 do
		local var3_4 = iter7_4
		local var4_4 = findTF(var2_4, "player/" .. iter7_4)

		GetComponent(findTF(var4_4, "img"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

		if arg0_4.taskActivity then
			onButton(arg0_4, var4_4, function()
				arg0_4:openTaskPanel(iter7_4)
			end, SFX_CONFIRM)
		end

		setActive(findTF(var4_4, "redTip"), false)
		table.insert(arg0_4.btnPlayers, var4_4)
	end

	local var5_4 = findTF(arg0_4._tf, "pop")

	arg0_4.detailPanel = findTF(var5_4, "detailPanel")

	setActive(arg0_4.detailPanel, false)
	arg0_4:initDetailPanel()

	arg0_4.taskPanel = findTF(var5_4, "taskPanel")

	setActive(arg0_4.taskPanel, false)
	arg0_4:initTaskPanel()

	arg0_4.submitPanel = findTF(var5_4, "submitPanel")

	setActive(arg0_4.submitPanel, false)
	arg0_4:initSubmitPanel()
end

function var0_0.didEnter(arg0_10)
	arg0_10:updateUI()

	if arg0_10.taskActivity and arg0_10.openTaskFlag then
		arg0_10.openTaskFlag = false

		arg0_10:openTaskPanel()
	end
end

function var0_0.updateUI(arg0_11)
	local var0_11 = arg0_11:getMedalGetAble()

	setActive(findTF(arg0_11.btnDetail, "detail"), not var0_11 and arg0_11.taskActivity)
	setActive(findTF(arg0_11.btnDetail, "get"), var0_11)

	local var1_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var2_11 = var1_11.data2_list
	local var3_11 = var1_11:GetPicturePuzzleIds()

	for iter0_11 = 1, #arg0_11.btnPlayers do
		local var4_11 = var3_11[iter0_11]
		local var5_11 = arg0_11.btnPlayers[iter0_11]

		setActive(findTF(var5_11, "medal/icon"), table.contains(var2_11, var4_11))
		setActive(findTF(var5_11, "img/got"), table.contains(var2_11, var4_11))
	end

	local var6_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var7_11 = var6_11.data1_list
	local var8_11 = var6_11.data2_list
	local var9_11 = false

	for iter1_11 = 1, #var7_11 do
		if not var9_11 and not table.contains(var8_11, var7_11[iter1_11]) then
			var9_11 = true

			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = var7_11[iter1_11],
				actId = var6_11.id
			})
		end
	end

	if arg0_11.taskActivity then
		local var10_11 = arg0_11:getGetAbleTask()
		local var11_11 = {}

		for iter2_11 = 1, #arg0_11.taskIds do
			local var12_11 = iter2_11

			for iter3_11, iter4_11 in ipairs(arg0_11.taskIds[iter2_11]) do
				if table.contains(var10_11, iter4_11) then
					if not var11_11[var12_11] then
						var11_11[var12_11] = 1
					else
						var11_11[var12_11] = var11_11[var12_11] + 1
					end
				end
			end
		end

		for iter5_11 = 1, #arg0_11.btnPlayers do
			setActive(findTF(arg0_11.btnPlayers[iter5_11], "redTip"), var11_11[iter5_11] ~= nil)
		end

		arg0_11:updateDetailPanel()
		arg0_11:updateTask()
	end
end

function var0_0.getMedalGetAble(arg0_12)
	local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var1_12 = var0_12.data1_list
	local var2_12 = var0_12.data2_list
	local var3_12 = var0_12:GetPicturePuzzleIds()

	if #var2_12 == #var3_12 and var0_12.data1 ~= 1 then
		return true
	end

	return false
end

function var0_0.openDetailPane(arg0_13)
	setActive(arg0_13.detailPanel, true)
end

function var0_0.initDetailPanel(arg0_14)
	arg0_14.detailSlider = findTF(arg0_14.detailPanel, "ad/progressSlider")
	arg0_14.detailClose = findTF(arg0_14.detailPanel, "ad/btnClose")

	onButton(arg0_14, findTF(arg0_14.detailPanel, "ad/black"), function()
		setActive(arg0_14.detailPanel, false)
	end, SOUND_BACK)
	onButton(arg0_14, arg0_14.detailClose, function()
		setActive(arg0_14.detailPanel, false)
	end)

	arg0_14.detailProgressTipContent = findTF(arg0_14.detailPanel, "ad/progressDetail")
	arg0_14.detailProgressTipTpl = findTF(arg0_14.detailPanel, "ad/progressDetail/tipTpl")

	setActive(arg0_14.detailProgressTipTpl, false)

	local var0_14 = findTF(arg0_14.detailPanel, "ad/progressDetail").sizeDelta.x

	arg0_14.medalTfs = {}

	for iter0_14 = 1, var1_0 do
		table.insert(arg0_14.medalTfs, findTF(arg0_14.detailPanel, "ad/medals/" .. iter0_14))
	end

	for iter1_14 = 1, var2_0 do
		local var1_14 = arg0_14.buffs[iter1_14].pt[1]
		local var2_14 = tf(instantiate(arg0_14.detailProgressTipTpl))

		setImageSprite(findTF(var2_14, "num"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "buff_" .. iter1_14), true)
		setImageSprite(findTF(var2_14, "count"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "buff_count_" .. iter1_14), true)

		var2_14.anchoredPosition = Vector3(var1_14 / arg0_14.ptMaxNum * var0_14, 0, 0)

		SetParent(var2_14, arg0_14.detailProgressTipContent)
		SetActive(var2_14, true)
	end

	arg0_14.detailBuffTfs = {}

	for iter2_14 = 1, var3_0 do
		local var3_14 = findTF(arg0_14.detailPanel, "ad/buff/" .. iter2_14)

		table.insert(arg0_14.detailBuffTfs, var3_14)
	end

	arg0_14.detailProgressDesc = findTF(arg0_14.detailPanel, "ad/progressDesc")
	arg0_14.detailLevelDesc = findTF(arg0_14.detailPanel, "ad/levelDesc")
end

function var0_0.updateDetailPanel(arg0_17)
	local var0_17 = arg0_17:getPtNum()
	local var1_17 = arg0_17:getBuildLv(var0_17)
	local var2_17

	if var1_17 ~= 0 then
		var2_17 = arg0_17.buffs[var1_17].benefit
	end

	for iter0_17 = 1, var3_0 do
		local var3_17

		if var2_17 then
			local var4_17 = var2_17[iter0_17]

			var3_17 = pg.benefit_buff_template[var4_17].desc
		else
			var3_17 = i18n("shan_luan_task_buff_default")
		end

		local var5_17 = arg0_17.detailBuffTfs[iter0_17]

		setText(findTF(var5_17, "desc"), var3_17)
	end

	setSlider(arg0_17.detailSlider, 0, arg0_17.ptMaxNum, var0_17)

	local var6_17 = getProxy(ActivityProxy):getActivityById(ActivityConst.SENRANKAGURA_MEDAL_ID)
	local var7_17 = var6_17.data1_list
	local var8_17 = var6_17.data2_list
	local var9_17 = var6_17:GetPicturePuzzleIds()

	for iter1_17 = 1, #arg0_17.medalTfs do
		local var10_17 = arg0_17.medalTfs[iter1_17]
		local var11_17 = var9_17[iter1_17]

		setActive(findTF(var10_17, "icon"), table.contains(var8_17, var11_17))
	end

	setText(findTF(arg0_17.detailProgressDesc, "desc"), i18n("shan_luan_task_progress_tip", arg0_17:getTaskCompleteCount() .. "/" .. arg0_17.taskCount))
	setText(findTF(arg0_17.detailLevelDesc, "desc"), i18n("shan_luan_task_level_tip", "Lv." .. var1_17))
end

function var0_0.getTaskCompleteCount(arg0_18)
	local var0_18 = 0
	local var1_18 = arg0_18:getActiveTask()

	for iter0_18, iter1_18 in ipairs(var1_18) do
		if arg0_18:getTask(iter1_18):getTaskStatus() == 2 then
			var0_18 = var0_18 + 1
		else
			print()
		end
	end

	return var0_18
end

function var0_0.getPtNum(arg0_19)
	local var0_19 = 0

	if arg0_19.ptId then
		var0_19 = getProxy(PlayerProxy):getData()[arg0_19.ptName] or 0
	else
		var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2):GetBuildingLevelSum()
	end

	if var0_19 > arg0_19.ptMaxNum then
		var0_19 = arg0_19.ptMaxNum
	end

	return var0_19
end

function var0_0.getBuildLv(arg0_20, arg1_20)
	local var0_20 = 0

	for iter0_20 = #arg0_20.buffs, 1, -1 do
		var0_20 = arg1_20 >= arg0_20.buffs[iter0_20].pt[1] and var0_20 < iter0_20 and iter0_20 or var0_20
	end

	return var0_20
end

function var0_0.initTaskListIds(arg0_21, arg1_21, arg2_21)
	local var0_21
	local var1_21 = pg.task_data_template[arg1_21].activity_client_config.before
	local var2_21 = pg.task_data_template[arg1_21].activity_client_config.special or false
	local var3_21 = {
		id = arg1_21,
		before = var1_21,
		special = var2_21
	}

	for iter0_21, iter1_21 in ipairs(arg2_21) do
		for iter2_21, iter3_21 in ipairs(iter1_21) do
			if iter3_21.id == var1_21 then
				table.insert(iter1_21, var3_21)

				return
			elseif iter3_21.before == arg1_21 then
				table.insert(iter1_21, var3_21)

				return
			end
		end
	end

	table.insert(arg2_21, {
		var3_21
	})
end

function var0_0.initTaskPanel(arg0_22)
	local var0_22 = findTF(arg0_22.taskPanel, "ad/frame/btnBack")
	local var1_22 = findTF(arg0_22.taskPanel, "ad/frame/btnHelp")
	local var2_22 = findTF(arg0_22.taskPanel, "ad/frame/btnHome")

	onButton(arg0_22, var0_22, function()
		setActive(arg0_22.taskPanel, false)
	end, SOUND_BACK)
	onButton(arg0_22, var2_22, function()
		arg0_22:emit(BaseUI.ON_HOME)
	end, SFX_CONFIRM)
	onButton(arg0_22, var1_22, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var5_0].tip
		})
	end, SFX_CONFIRM)

	arg0_22.taskTagTfs = {}

	local var3_22 = findTF(arg0_22.taskPanel, "ad/tag/content")
	local var4_22 = findTF(arg0_22.taskPanel, "ad/tag/content/tagTpl")

	setActive(var4_22, false)

	for iter0_22 = 1, var1_0 do
		local var5_22 = iter0_22
		local var6_22 = tf(instantiate(var4_22))

		setImageSprite(findTF(var6_22, "icon"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "player_icon_" .. iter0_22), true)
		SetParent(var6_22, var3_22)
		setActive(var6_22, true)
		table.insert(arg0_22.taskTagTfs, var6_22)
		onButton(arg0_22, var6_22, function()
			arg0_22:taskSelectTag(var5_22, true)
		end, SFX_CONFIRM)
	end

	arg0_22.taskButtonTpl = findTF(arg0_22.taskPanel, "ad/taskButtonTpl")
	arg0_22.taskList = {}

	local var7_22 = findTF(arg0_22.taskPanel, "ad/task/content")

	arg0_22.taskDragTf = findTF(arg0_22.taskPanel, "ad/task/drag")

	local var8_22 = findTF(arg0_22.taskPanel, "ad/taskTpl")
	local var9_22 = findTF(arg0_22.taskPanel, "ad/taskButtonTpl")

	setActive(var8_22, false)
	setActive(var9_22, false)

	arg0_22.taskGroups = {}

	for iter1_22 = 1, var1_0 do
		local var10_22 = {}
		local var11_22 = arg0_22.taskListDatas[iter1_22]

		for iter2_22 = 1, #var11_22 do
			local var12_22 = tf(instantiate(var8_22))

			setParent(var12_22, var7_22)
			setActive(var12_22, true)

			local var13_22 = var11_22[iter2_22]
			local var14_22 = {}

			for iter3_22, iter4_22 in ipairs(var13_22) do
				local var15_22 = tf(instantiate(var9_22))

				var15_22.anchoredPosition = Vector2(iter4_22.pos[1] * 325 + iter4_22.pos[2] * 90, iter4_22.pos[2] * 190)

				local var16_22 = iter4_22.special

				if var16_22 then
					if iter4_22.pos[2] ~= 0 then
						setImageSprite(findTF(var15_22, "get"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_get_" .. 4), true)
						setImageSprite(findTF(var15_22, "got"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_got_" .. 4), true)
					else
						setImageSprite(findTF(var15_22, "get"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_get_" .. 2), true)
						setImageSprite(findTF(var15_22, "got"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_got_" .. 2), true)
					end
				elseif not var16_22 and iter4_22.pos[2] ~= 0 then
					setImageSprite(findTF(var15_22, "get"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_get_" .. 3), true)
					setImageSprite(findTF(var15_22, "got"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "task_got_" .. 3), true)
				end

				setActive(var15_22, true)
				SetParent(var15_22, var12_22)
				table.insert(var14_22, {
					tf = var15_22,
					data = iter4_22
				})
				onButton(arg0_22, var15_22, function()
					arg0_22:openSubmitPanel(iter4_22)
				end, SFX_CONFIRM)
			end

			var10_22.listTf = var12_22
			var10_22.taskDic = var14_22
		end

		table.insert(arg0_22.taskGroups, var10_22)
	end

	arg0_22.taskButtonTpl = findTF(arg0_22.taskPanel, "ad/buttonTpl")
	arg0_22.taskBtnGetAll = findTF(arg0_22.taskPanel, "ad/btnGetAll")

	onButton(arg0_22, arg0_22.taskBtnGetAll, function()
		local var0_28 = arg0_22:getGetAbleTask()

		if var0_28 and #var0_28 > 0 then
			arg0_22:emit(SenrankaguraMedalMediator.SUBMIT_TASK_ALL, var0_28)
		end
	end, SFX_CONFIRM)
end

function var0_0.updateTask(arg0_29)
	for iter0_29 = 1, #arg0_29.taskGroups do
		local var0_29 = arg0_29.taskGroups[iter0_29].taskDic

		for iter1_29, iter2_29 in ipairs(var0_29) do
			local var1_29 = iter2_29.tf
			local var2_29 = arg0_29:getTask(iter2_29.data.id)

			setActive(findTF(var1_29, "lock"), false)
			setActive(findTF(var1_29, "getAble"), false)
			setActive(findTF(var1_29, "get"), false)
			setActive(findTF(var1_29, "got"), false)

			if var2_29 then
				if arg0_29:checkTaskBeforeComplete(var2_29:getConfig("activity_client_config").before) then
					if var2_29:getTaskStatus() == 0 then
						setActive(findTF(var1_29, "get"), true)
					elseif var2_29:getTaskStatus() == 1 then
						setActive(findTF(var1_29, "get"), true)
						setActive(findTF(var1_29, "getAble"), true)
					elseif var2_29:getTaskStatus() == 2 then
						setActive(findTF(var1_29, "got"), true)
					end
				else
					setActive(findTF(var1_29, "lock"), true)
					setActive(findTF(var1_29, "get"), true)
				end
			else
				setActive(findTF(var1_29, "lock"), true)
				setActive(findTF(var1_29, "get"), true)
			end
		end
	end

	if #arg0_29:getGetAbleTask() > 0 then
		setActive(arg0_29.taskBtnGetAll, true)
	else
		setActive(arg0_29.taskBtnGetAll, false)
	end

	for iter3_29 = 1, #arg0_29.taskGroups do
		local var3_29 = arg0_29.taskGroups[iter3_29].taskDic
		local var4_29 = arg0_29.taskGroups[iter3_29].listTf

		for iter4_29, iter5_29 in ipairs(var3_29) do
			local var5_29 = iter5_29.data.pos
			local var6_29 = iter5_29.data.before
			local var7_29 = iter5_29.tf

			setActive(findTF(var7_29, "line/back"), false)
			setActive(findTF(var7_29, "line/bottom"), false)
			setActive(findTF(var7_29, "line/top"), false)
			var7_29:SetAsFirstSibling()

			if not var6_29 then
				setActive(findTF(var7_29, "line"), false)
			else
				local var8_29 = arg0_29:getTaskPos(var6_29)
				local var9_29 = arg0_29:getTask(var6_29)
				local var10_29 = arg0_29:checkTaskBeforeComplete(var6_29) and Color.New(0.992156862745098, 0.964705882352941, 0.866666666666667) or Color.New(0.486274509803922, 0.352941176470588, 0.290196078431373)

				if var8_29[1] < var5_29[1] then
					setActive(findTF(var7_29, "line/back"), true)
					setImageColor(findTF(var7_29, "line/back"), var10_29)
				elseif var8_29[2] < var5_29[2] then
					setActive(findTF(var7_29, "line/bottom"), true)
					setImageColor(findTF(var7_29, "line/bottom"), var10_29)
				else
					setActive(findTF(var7_29, "line/top"), true)
					setImageColor(findTF(var7_29, "line/top"), var10_29)
				end

				setActive(findTF(var7_29, "line"), true)
			end
		end
	end
end

function var0_0.checkTaskBeforeComplete(arg0_30, arg1_30)
	if not arg1_30 then
		return true
	end

	local var0_30 = arg0_30:getTaskGroupData(arg1_30).before
	local var1_30 = arg0_30:getTask(arg1_30)

	if not var1_30 then
		return true
	end

	if var1_30:getTaskStatus() == 0 then
		return false
	end

	if var1_30:getTaskStatus() >= 1 then
		return arg0_30:checkTaskBeforeComplete(var0_30)
	end

	return true
end

function var0_0.getTaskGroupData(arg0_31, arg1_31)
	for iter0_31 = 1, #arg0_31.taskGroups do
		local var0_31 = arg0_31.taskGroups[iter0_31].taskDic

		for iter1_31, iter2_31 in ipairs(var0_31) do
			if iter2_31.data.id == arg1_31 then
				return iter2_31.data
			end
		end
	end

	return nil
end

function var0_0.getTaskPos(arg0_32, arg1_32)
	for iter0_32 = 1, #arg0_32.taskGroups do
		local var0_32 = arg0_32.taskGroups[iter0_32].taskDic

		for iter1_32, iter2_32 in ipairs(var0_32) do
			if iter2_32.data.id == arg1_32 then
				return iter2_32.data.pos
			end
		end
	end

	return nil
end

function var0_0.getTask(arg0_33, arg1_33)
	local var0_33 = getProxy(TaskProxy)
	local var1_33
	local var2_33 = var0_33:getTaskById(arg1_33)

	if var2_33 then
		return var2_33
	end

	local var3_33 = var0_33:getFinishTaskById(arg1_33)

	if var3_33 then
		return var3_33
	end

	return nil
end

function var0_0.getGetAbleTask(arg0_34)
	local var0_34 = {}
	local var1_34 = getProxy(TaskProxy)
	local var2_34 = arg0_34:getActiveTask()

	for iter0_34 = 1, #var2_34 do
		local var3_34 = var1_34:getTaskById(var2_34[iter0_34])

		if var3_34 and var3_34:getTaskStatus() == 1 then
			table.insert(var0_34, var3_34.id)
		end
	end

	return var0_34
end

function var0_0.getActiveTask(arg0_35)
	local var0_35 = {}

	for iter0_35 = 1, #arg0_35.taskGroups do
		local var1_35 = arg0_35.taskGroups[iter0_35].taskDic

		for iter1_35, iter2_35 in ipairs(var1_35) do
			if not iter2_35.data.before then
				table.insert(var0_35, iter2_35.data.id)
			elseif arg0_35:checkTaskBeforeComplete(iter2_35.data.before) then
				table.insert(var0_35, iter2_35.data.id)
			end
		end
	end

	return var0_35
end

function var0_0.taskSelectTag(arg0_36, arg1_36, arg2_36)
	local var0_36 = 0

	if arg0_36.currentSelectIndex then
		var0_36 = math.abs(arg0_36.currentSelectIndex - arg1_36)
	end

	arg0_36.currentSelectIndex = arg1_36
	arg0_36.currentSelectTag = arg0_36.taskTagTfs[arg1_36]
	arg0_36.currentTaskDatas = arg0_36.taskListDatas[arg1_36]

	for iter0_36 = 1, #arg0_36.taskTagTfs do
		local var1_36 = arg0_36.taskTagTfs[iter0_36]

		setActive(findTF(var1_36, "select"), arg0_36.currentSelectTag == var1_36)
	end

	arg0_36.taskScrollRect = GetComponent(findTF(arg0_36.taskPanel, "ad/task"), typeof(ScrollRect))

	local var2_36 = var1_0 - 1
	local var3_36 = Vector2(arg0_36.taskScrollRect.normalizedPosition.x, arg0_36.taskScrollRect.normalizedPosition.y)

	if arg2_36 then
		local var4_36 = arg0_36.taskScrollRect.normalizedPosition.y
		local var5_36 = (var2_36 - (arg1_36 - 1)) / var2_36

		if LeanTween.isTweening(go(arg0_36._tf)) then
			LeanTween.cancel(go(arg0_36._tf))
		end

		LeanTween.value(go(arg0_36._tf), var4_36, var5_36, 0.3 + var0_36 * 0.1):setOnUpdate(System.Action_float(function(arg0_37)
			var3_36.y = arg0_37
			arg0_36.taskScrollRect.normalizedPosition = var3_36

			arg0_36.taskScrollRect.onValueChanged:Invoke(var3_36)
		end))
	else
		scrollTo(arg0_36.taskScrollRect, 0, (var2_36 - (arg1_36 - 1)) / var2_36)
	end
end

function var0_0.openTaskPanel(arg0_38, arg1_38)
	arg1_38 = arg1_38 or 1

	arg0_38:taskSelectTag(arg1_38, false)
	setActive(arg0_38.taskPanel, true)
end

function var0_0.sortListDatas(arg0_39, arg1_39)
	local var0_39

	local function var1_39(arg0_40)
		for iter0_40, iter1_40 in ipairs(var0_39) do
			if iter1_40[1] == arg0_40[1] and iter1_40[2] == arg0_40[2] then
				return false
			end
		end

		return true
	end

	local function var2_39(arg0_41, arg1_41)
		for iter0_41, iter1_41 in ipairs(arg1_41) do
			if iter1_41.id == arg0_41 then
				return iter1_41
			end
		end
	end

	for iter0_39 = 1, #arg1_39 do
		var0_39 = {}

		local var3_39 = arg1_39[iter0_39]
		local var4_39

		for iter1_39 = 1, #var3_39 do
			local var5_39
			local var6_39 = var3_39[iter1_39]

			if not var6_39.before then
				var5_39 = {
					0,
					0
				}
			elseif var6_39.before then
				local var7_39 = var2_39(var6_39.before, var3_39)

				assert(var7_39, "找不到前置id.." .. var6_39.before)

				local var8_39 = var7_39.pos
				local var9_39 = {
					var8_39[1] + 1,
					var8_39[2]
				}

				for iter2_39 = 1, 10 do
					if var1_39(var9_39) then
						break
					else
						if iter2_39 == 1 then
							var9_39[1] = var9_39[1] - 1
						end

						if var9_39[2] > 0 then
							var9_39[2] = var9_39[2] * -1
						else
							var9_39[2] = math.abs(var9_39[2]) + 1
						end

						if var8_39[2] - var9_39[2] > 1 then
							var7_39.pos = {
								var9_39[1],
								var9_39[2]
							}
							var9_39[1] = var9_39[1] + 1
						end
					end

					assert(iter2_39 ~= 10, "任务分支超过10个")
				end

				var5_39 = var9_39
			end

			var6_39.pos = var5_39

			table.insert(var0_39, var5_39)
		end
	end
end

function var0_0.openSubmitPanel(arg0_42, arg1_42)
	setActive(arg0_42.submitPanel, true)

	local var0_42 = arg0_42.currentSelectIndex

	setImageSprite(findTF(arg0_42.submitPanel, "icon/img"), GetSpriteFromAtlas("ui/senrankaguramedalui_atlas", "player_icon_" .. var0_42), true)

	local var1_42 = arg0_42:getTask(arg1_42.id)
	local var2_42 = arg0_42:checkTaskBeforeComplete(arg1_42.before)

	if var1_42 then
		arg0_42.selectTask = var1_42

		setText(findTF(arg0_42.submitPanel, "taskDesc"), var1_42:getConfig("desc"))
		setText(findTF(arg0_42.submitPanel, "img/taskName"), var1_42:getConfig("name"))

		local var3_42 = var1_42:getProgress()
		local var4_42 = var1_42:getConfig("target_num")

		setText(findTF(arg0_42.submitPanel, "progress/taskProgress"), setColorStr(var3_42, "#C2695B") .. "/" .. setColorStr(var4_42, "#9D6B59"))

		local var5_42 = var1_42:getConfig("award_display")

		arg0_42:setSubmitAward(var5_42)
		setActive(arg0_42.submitGo, var1_42:getTaskStatus() == 0 or not var2_42)
		setActive(arg0_42.submitGet, var1_42:getTaskStatus() == 1 and var2_42)
		setActive(arg0_42.submitGot, var1_42:getTaskStatus() == 2)
	end
end

function var0_0.initSubmitPanel(arg0_43)
	arg0_43.submitGet = findTF(arg0_43.submitPanel, "get")
	arg0_43.submitGot = findTF(arg0_43.submitPanel, "got")
	arg0_43.submitGo = findTF(arg0_43.submitPanel, "go")
	arg0_43.submitbtnBack = findTF(arg0_43.submitPanel, "back")
	arg0_43.submitDisplayContent = findTF(arg0_43.submitPanel, "itemDisplay/viewport/content")
	arg0_43.submitItemTpl = findTF(arg0_43.submitPanel, "itemDisplay/viewport/content/item")

	setActive(arg0_43.submitItemTpl, false)

	arg0_43.submitItemDesc = findTF(arg0_43.submitPanel, "itemDesc")
	arg0_43.submitItems = {}

	onButton(arg0_43, findTF(arg0_43.submitPanel, "black"), function()
		setActive(arg0_43.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0_43, arg0_43.submitbtnBack, function()
		setActive(arg0_43.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0_43, arg0_43.submitGet, function()
		if arg0_43.selectTask then
			arg0_43:emit(SenrankaguraMedalMediator.SUBMIT_TASK, arg0_43.selectTask.id)
		end

		setActive(arg0_43.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0_43, arg0_43.submitGo, function()
		setActive(arg0_43.submitPanel, false)

		if arg0_43.selectTask then
			arg0_43:emit(SenrankaguraMedalMediator.TASK_GO, arg0_43.selectTask)
		end
	end, SOUND_BACK)
	setText(findTF(arg0_43.submitPanel, "bg/txtDesc"), i18n("ryza_task_detail_content"))
	setText(findTF(arg0_43.submitPanel, "bg/txtAward"), i18n("ryza_task_detail_award"))
end

function var0_0.setSubmitAward(arg0_48, arg1_48)
	if #arg0_48.submitItems < #arg1_48 then
		for iter0_48 = 1, #arg1_48 - #arg0_48.submitItems do
			local var0_48 = tf(instantiate(arg0_48.submitItemTpl))

			setParent(var0_48, arg0_48.submitDisplayContent)
			table.insert(arg0_48.submitItems, var0_48)
		end
	end

	for iter1_48 = 1, #arg0_48.submitItems do
		local var1_48 = arg0_48.submitItems[iter1_48]

		if iter1_48 <= #arg1_48 then
			local var2_48 = {
				type = arg1_48[iter1_48][1],
				id = arg1_48[iter1_48][2],
				count = arg1_48[iter1_48][3]
			}

			updateDrop(var1_48, var2_48)
			onButton(arg0_48, var1_48, function()
				arg0_48:emit(BaseUI.ON_DROP, var2_48)
			end, SFX_PANEL)
			setActive(var1_48, true)
		else
			setActive(var1_48, false)
		end
	end
end

function var0_0.willExit(arg0_50)
	if LeanTween.isTweening(go(arg0_50._tf)) then
		LeanTween.cancel(go(arg0_50._tf))
	end
end

return var0_0
