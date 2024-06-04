local var0 = class("TrainingCampScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "TrainingCampUI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()

	if var0.isNormalActOn() then
		arg0:initNormalPanel()
	end

	if var0.isTecActOn() then
		arg0:initTecPanel()
	end

	arg0:closeMsgBox()
end

function var0.findUI(arg0)
	arg0.adaptPanel = arg0:findTF("blur_panel/adapt")
	arg0.panelContainer = arg0:findTF("PanelContainer")
	arg0.normalPanel = arg0:findTF("NormalPanel", arg0.panelContainer)
	arg0.tecPanel = arg0:findTF("TecPanel", arg0.panelContainer)
	arg0.switchToNormalBtn = arg0:findTF("SwitchToNormal")
	arg0.switchToTecBtn = arg0:findTF("SwitchToTec")
	arg0.switchToNormalLight = GetOrAddComponent(arg0:findTF("Light", arg0.switchToNormalBtn), "Animator")
	arg0.switchToTecLight = GetOrAddComponent(arg0:findTF("Light", arg0.switchToTecBtn), "Animator")
	arg0.awardMsg = arg0:findTF("ChooseAwardPanel")
	arg0.helpBtn = arg0:findTF("HelpBtn")
	arg0.titleTf = arg0:findTF("blur_panel/adapt/top/title")

	GetComponent(findTF(arg0.titleTf, "img"), typeof(Image)):SetNativeSize()
end

function var0.initData(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.normalTaskactivity = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
	arg0.tecTaskActivity = arg0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)
	arg0.phaseId = nil
	arg0.cachePageID = nil
	arg0.activity = nil
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("top/back_button", arg0.adaptPanel), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.switchToNormalBtn, function()
		if not arg0.isOnSwitchAni and var0.isNormalActOn() then
			arg0:switchPanel(arg0.normalTaskactivity, true)
			setActive(arg0.switchToNormalBtn, false)
			setActive(arg0.switchToTecBtn, true)
			arg0:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.switchToTecBtn, function()
		if not arg0.isOnSwitchAni and var0.isTecActOn() then
			arg0:switchPanel(arg0.tecTaskActivity, true)
			setActive(arg0.switchToNormalBtn, true)
			setActive(arg0.switchToTecBtn, false)
			arg0:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("newplayer_help_tip")
		})
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	arg0:updateSwitchBtns()
	arg0:updateSwitchBtnsTag()
	arg0:autoSelectPanel()
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.normalPanel))
	LeanTween.cancel(go(arg0.tecPanel))
end

function var0.updateSwitchBtns(arg0)
	local var0, var1 = TrainingCampScene.isNormalActOn()
	local var2, var3 = TrainingCampScene.isTecActOn()

	if not var0 or not var2 then
		setActive(arg0.switchToNormalBtn, false)
		setActive(arg0.switchToTecBtn, false)
	elseif var0 and var2 then
		setActive(arg0.switchToNormalBtn, true)
		setActive(arg0.switchToTecBtn, true)
	end

	local var4 = arg0:findTF("Tag", arg0.switchToNormalBtn)
	local var5 = arg0:findTF("Tag", arg0.switchToTecBtn)

	setActive(var4, var1)
	setActive(var5, var3)
end

function var0.updateSwitchBtnsTag(arg0)
	local var0, var1 = TrainingCampScene.isNormalActOn()
	local var2, var3 = TrainingCampScene.isTecActOn()
	local var4 = arg0:findTF("Tag", arg0.switchToNormalBtn)
	local var5 = arg0:findTF("Tag", arg0.switchToTecBtn)

	setActive(var4, var1)
	setActive(var5, var3)

	local var6 = PlayerPrefs.GetInt("TrainCamp_Tec_Catchup_First_Tag", 0)

	arg0.switchToNormalLight.enabled = var6 == 0
	arg0.switchToTecLight.enabled = var6 == 0

	if var6 == 0 then
		PlayerPrefs.SetInt("TrainCamp_Tec_Catchup_First_Tag", 1)
	end
end

function var0.resetSwitchBtnsLight(arg0)
	arg0.switchToNormalLight.enabled = false
	arg0.switchToTecLight.enabled = false
end

function var0.autoSelectPanel(arg0)
	local var0, var1 = TrainingCampScene.isNormalActOn()
	local var2, var3 = TrainingCampScene.isTecActOn()

	if var0 and var2 then
		arg0:switchPanel(arg0.normalTaskactivity)
		setActive(arg0.switchToNormalBtn, false)
		setActive(arg0.switchToTecBtn, true)
	elseif var0 then
		arg0:switchPanel(arg0.normalTaskactivity)
	elseif var2 then
		arg0:switchPanel(arg0.tecTaskActivity)
	end
end

function var0.initNormalPanel(arg0)
	local var0 = arg0:findTF("ToggleList", arg0.normalPanel)

	arg0.normalToggles = {
		arg0:findTF("Phase1", var0),
		arg0:findTF("Phase2", var0),
		arg0:findTF("Phase3", var0)
	}
	arg0.normalTaskUIItemList = UIItemList.New(arg0:findTF("ScrollRect/Content", arg0.normalPanel), arg0:findTF("ScrollRect/TaskTpl", arg0.normalPanel))
	arg0.normalProgressPanel = arg0:findTF("ProgressPanel", arg0.normalPanel)

	for iter0, iter1 in pairs(arg0.normalToggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				if arg0.phaseId < iter0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("newplayer_notice_7"))
					triggerToggle(arg0.normalToggles[arg0.cachePageID], true)
				else
					arg0:updateNormalPanel(iter0)
				end
			end
		end, SFX_PANEL)
	end
end

function var0.updateNormalPanel(arg0, arg1)
	arg0.cachePageID = arg1

	local var0 = arg0.normalTaskactivity:getConfig("config_data")[3]
	local var1 = var0[arg1][1]
	local var2 = var0[arg1][2]

	arg0:sortTaskIDList(var1)
	arg0:updateTaskUIItemList(arg0.normalTaskUIItemList, var1, arg1)
	arg0:updateNormalProgressPanel(arg1, var2, var1)
end

function var0.updateNormalProgressPanel(arg0, arg1, arg2, arg3)
	local var0 = arg0:getTask(arg1, arg2)

	if arg1 == arg0.phaseId and arg0:isMissTask(arg3) then
		arg0:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end

	if var0 and var0:isClientTrigger() and not var0:isFinish() then
		arg0:emit(TrainingCampMediator.ON_UPDATE, var0)
	end

	local var1 = arg0.normalProgressPanel:Find("Get")
	local var2 = arg0.normalProgressPanel:Find("Lock")
	local var3 = arg0.normalProgressPanel:Find("Go")
	local var4 = arg0.normalProgressPanel:Find("Pass")

	setActive(var1, var0 and var0:isFinish() and not var0:isReceive())
	setActive(var2, not var0)
	setActive(var3, var0 and not var0:isFinish())
	setActive(var4, var0 and var0:isReceive())

	local var5 = arg0.normalProgressPanel:Find("Slider/LabelText")
	local var6 = arg0.normalProgressPanel:Find("Slider/ProgressText")

	if not var0 then
		var0 = Task.New({
			id = arg2
		})

		if arg0:isFinishedAll(arg3) then
			arg0:emit(TrainingCampMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = arg0.activity.id
			})
		end

		setText(var5, i18n("newplayer_notice_" .. arg1))

		local var7 = 0

		_.each(arg3, function(arg0)
			if arg0.taskProxy:getFinishTaskById(arg0) ~= nil then
				var7 = var7 + 1
			end
		end)
		setText(var6, var7 .. "/" .. #arg3)
	else
		setText(var5, var0:getConfig("desc"))
		setText(var6, math.min(var0.progress, var0:getConfig("target_num")) .. "/" .. var0:getConfig("target_num"))
	end

	arg0.normalProgressPanel:Find("Slider"):GetComponent(typeof(Slider)).value = var0.progress / var0:getConfig("target_num")
	arg0.normalProgressPanel:Find("Icon"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/trainingcampui_atlas", "panel_phase_award_" .. arg1)

	setText(arg0.normalProgressPanel:Find("TipText"), i18n("newplayer_notice_" .. 3 + arg1))
	onButton(arg0, var1, function()
		if var0:isSelectable() then
			arg0:openMsgbox(function(arg0)
				arg0:emit(TrainingCampMediator.ON_SELECTABLE_GET, var0, arg0)
			end)
		else
			arg0:emit(TrainingCampMediator.ON_GET, var0)
		end
	end, SFX_PANEL)
	onButton(arg0, var3, function()
		arg0:emit(TrainingCampMediator.ON_GO, var0)
	end, SFX_PANEL)
end

function var0.initTecPanel(arg0)
	local var0 = #arg0.tecTaskActivity:getConfig("config_data")[3]
	local var1 = arg0:findTF("ToggleList", arg0.tecPanel)

	arg0.tecToggles = {
		arg0:findTF("Phase1", var1)
	}

	for iter0 = #arg0.tecToggles + 1, var0 do
		local var2 = cloneTplTo(arg0.tecToggles[1], var1)

		table.insert(arg0.tecToggles, var2)

		var2.name = "Phase" .. iter0
	end

	for iter1 = 1, var0 do
		local var3 = var1:GetChild(iter1 - 1)
		local var4 = arg0:findTF("TextImg", var3)

		setText(var4, i18n("tec_catchup_" .. iter1))

		local var5 = arg0:findTF("Selected/TextImage", var3)

		setText(var5, i18n("tec_catchup_" .. iter1))
	end

	arg0.tecTaskUIItemList = UIItemList.New(arg0:findTF("ScrollRect/Content", arg0.tecPanel), arg0:findTF("ScrollRect/TaskTpl", arg0.tecPanel))
	arg0.tecProgressPanel = arg0:findTF("ProgressPanel", arg0.tecPanel)

	for iter2, iter3 in pairs(arg0.tecToggles) do
		onToggle(arg0, iter3, function(arg0)
			if arg0 then
				if arg0.phaseId < iter2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tec_notice_not_open_tip"))
					triggerToggle(arg0.tecToggles[arg0.cachePageID], true)
				else
					arg0:updateTecPanel(iter2)
				end
			end
		end, SFX_PANEL)
	end
end

function var0.updateTecPanel(arg0, arg1)
	arg0.cachePageID = arg1

	local var0 = arg0.tecTaskActivity:getConfig("config_data")[3]
	local var1 = var0[arg1][1]
	local var2 = var0[arg1][2]

	arg0:sortTaskIDList(var1)
	arg0:updateTaskUIItemList(arg0.tecTaskUIItemList, var1, arg1)
	arg0:updateTecProgressPanel(arg1, var2, var1)
end

function var0.updateTecProgressPanel(arg0, arg1, arg2, arg3)
	local var0 = arg0:isFinishedAll(arg3)
	local var1

	if not var0 then
		var1 = true
	end

	local var2 = arg0:getTask(arg1, arg2, var1)

	if arg1 == arg0.phaseId and arg0:isMissTask(arg3) then
		arg0:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end

	if var2 and var2:isClientTrigger() and not var2:isFinish() then
		arg0:emit(TrainingCampMediator.ON_UPDATE, var2)
	end

	local var3 = arg0.tecProgressPanel:Find("Get")
	local var4 = arg0.tecProgressPanel:Find("Lock")
	local var5 = arg0.tecProgressPanel:Find("Go")
	local var6 = arg0.tecProgressPanel:Find("Pass")

	setActive(var3, var2 and var2:isFinish() and not var2:isReceive())
	setActive(var4, not var2)
	setActive(var5, var2 and not var2:isFinish())
	setActive(var6, var2 and var2:isReceive())

	local var7 = arg0.tecProgressPanel:Find("Slider/LabelText")
	local var8 = arg0.tecProgressPanel:Find("Slider/ProgressText")

	if not var2 then
		var2 = Task.New({
			id = arg2
		})

		if arg0:isFinishedAll(arg3) then
			arg0:emit(TrainingCampMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = arg0.activity.id
			})
		end

		setText(var7, i18n("tec_notice", i18n("tec_catchup_" .. arg1)))

		local var9 = 0

		_.each(arg3, function(arg0)
			local var0 = arg0.taskProxy:getTaskVO(arg0)

			if var0 and var0:isReceive() then
				var9 = var9 + 1
			end
		end)
		setText(var8, var9 .. "/" .. #arg3)
	else
		setText(var7, var2:getConfig("desc"))
		setText(var8, math.min(var2.progress, var2:getConfig("target_num")) .. "/" .. var2:getConfig("target_num"))
	end

	arg0.tecProgressPanel:Find("Slider"):GetComponent(typeof(Slider)).value = var2.progress / var2:getConfig("target_num")

	local var10 = arg0.tecProgressPanel:Find("Icon/Item")
	local var11 = var2:getConfig("award_display")[1]
	local var12 = {
		type = var11[1],
		id = var11[2],
		count = var11[3]
	}

	updateDrop(var10, var12)
	onButton(arg0, var10, function()
		arg0:emit(BaseUI.ON_DROP, var12)
	end, SFX_PANEL)
	setActive(arg0.tecProgressPanel:Find("TipText"), false)
	onButton(arg0, var3, function()
		if var2:isSelectable() then
			arg0:openMsgbox(function(arg0)
				arg0:emit(TrainingCampMediator.ON_SELECTABLE_GET, var2, arg0)
			end)
		else
			arg0:emit(TrainingCampMediator.ON_GET, var2)

			if arg0.phaseId == 1 then
				arg0.isSubmitTecFirstTaskTag = true

				arg0:emit(TrainingCampMediator.ON_TRIGGER, {
					cmd = 1,
					activity_id = arg0.activity.id
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0, var5, function()
		arg0:emit(TrainingCampMediator.ON_GO, var2)
	end, SFX_PANEL)
end

function var0.updateToggleDisable(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		setActive(iter1:Find("Disable"), iter0 > arg0.phaseId)
	end
end

function var0.updateTaskUIItemList(arg0, arg1, arg2, arg3)
	arg1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateTask(arg2[arg1], arg2, arg3)
		end
	end)
	arg1:align(#arg2)
end

function var0.updateTask(arg0, arg1, arg2, arg3)
	local var0 = arg2:Find("Get")
	local var1 = arg2:Find("Got")
	local var2 = arg2:Find("Go")
	local var3 = arg0:getTask(arg3, arg1)

	setActive(var0, var3 and var3:isFinish() and not var3:isReceive())
	setActive(var1, var3 and var3:isReceive())
	setActive(var2, not var3 or var3 and not var3:isFinish())

	if var3 and var3:isClientTrigger() and not var3:isFinish() then
		arg0:emit(TrainingCampMediator.ON_UPDATE, var3)
	end

	var3 = var3 or Task.New({
		id = arg1
	})

	setText(arg2:Find("TitleText"), var3:getConfig("desc"))

	local var4 = var3:getConfig("award_display")[1]
	local var5 = arg2:Find("Item")
	local var6 = {
		type = var4[1],
		id = var4[2],
		count = var4[3]
	}

	updateDrop(var5, var6)
	onButton(arg0, var5, function()
		arg0:emit(BaseUI.ON_DROP, var6)
	end, SFX_PANEL)
	setText(arg2:Find("ProgressText"), math.min(var3.progress, var3:getConfig("target_num")) .. "/" .. var3:getConfig("target_num"))
	onButton(arg0, var0, function()
		arg0:emit(TrainingCampMediator.ON_GET, var3)
	end, SFX_PANEL)
	onButton(arg0, var2, function()
		arg0:emit(TrainingCampMediator.ON_GO, var3)
	end, SFX_PANEL)
end

function var0.getTask(arg0, arg1, arg2, arg3)
	local var0

	if arg1 >= arg0.phaseId then
		if arg3 == true then
			return nil
		end

		var0 = arg0.taskProxy:getTaskById(arg2) or arg0.taskProxy:getFinishTaskById(arg2)
	else
		var0 = Task.New({
			id = arg2
		})
		var0.progress = var0:getConfig("target_num")
		var0.submitTime = 1
	end

	return var0
end

function var0.getTaskState(arg0, arg1)
	if arg1:isReceive() then
		return 0
	elseif arg1:isFinish() then
		return 2
	elseif not arg1:isFinish() then
		return 1
	end

	return -1
end

function var0.sortTaskIDList(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		local var0 = arg0.taskProxy:getTaskVO(arg0) or Task.New({
			id = arg0
		})
		local var1 = arg0.taskProxy:getTaskVO(arg1) or Task.New({
			id = arg1
		})
		local var2 = arg0:getTaskState(var0)
		local var3 = arg0:getTaskState(var1)

		if var2 == var3 then
			return var0.id < var1.id
		else
			return var3 < var2
		end
	end)

	return arg1
end

function var0.isFinishedAll(arg0, arg1)
	return _.all(arg1, function(arg0)
		local var0 = arg0.taskProxy:getTaskVO(arg0)

		return var0 and var0:isReceive() or false
	end)
end

function var0.isMissTask(arg0, arg1)
	return _.any(arg1, function(arg0)
		return arg0.taskProxy:getTaskVO(arg0) == nil
	end)
end

function var0.setPhrase(arg0)
	if arg0.lockFirst == true then
		arg0.phaseId = 1

		return
	end

	local var0 = 1
	local var1 = arg0.activity:getConfig("config_data")[3]
	local var2 = #var1

	local function var3(arg0)
		if arg0 > 1 then
			local var0 = var1[arg0 - 1][2]

			return arg0.taskProxy:getFinishTaskById(var0) ~= nil
		end
	end

	for iter0 = var2, 1, -1 do
		local var4 = var1[iter0][1]

		if _.all(var4, function(arg0)
			return arg0.taskProxy:getTaskVO(arg0) ~= nil
		end) or var3(iter0) then
			var0 = iter0

			break
		end
	end

	arg0.phaseId = var0
end

function var0.isNormalActOn()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
	local var1 = var0 and not var0:isEnd()
	local var2 = false
	local var3 = false

	if var1 then
		local var4 = var0:getConfig("config_data")[1]
		local var5 = getProxy(ChapterProxy):getChapterById(var4)

		var2 = var5 and var5:isClear()

		local var6 = _.flatten(var0:getConfig("config_data")[3])
		local var7 = getProxy(TaskProxy)

		var3 = _.any(var6, function(arg0)
			local var0 = var7:getTaskById(arg0)

			return var0 and var0:isFinish() and not var0:isReceive()
		end)
	end

	return var1 and var2, var3
end

function var0.isTecActOn()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)
	local var1 = var0 and not var0:isEnd()
	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var2.level, "ShipBluePrintMediator")
	local var4 = false
	local var5 = false

	if var1 then
		local var6 = var0:getConfig("config_data")[1]
		local var7 = getProxy(ChapterProxy):getChapterById(var6)

		var4 = var7 and var7:isClear()

		local var8 = _.flatten(var0:getConfig("config_data")[3])
		local var9 = getProxy(TaskProxy)

		var5 = _.any(var8, function(arg0)
			local var0 = var9:getTaskById(arg0)

			return var0 and var0:isFinish() and not var0:isReceive()
		end)
	end

	return var1 and var4 and var3, var5
end

function var0.switchPanel(arg0, arg1, arg2)
	arg0.activity = arg1

	if arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		arg0:setPhrase()

		if arg2 then
			arg0:aniOnSwitch(arg0.normalPanel, arg0.tecPanel)
		else
			setActive(arg0.normalPanel, true)
			setActive(arg0.tecPanel, false)
		end

		arg0:updateToggleDisable(arg0.normalToggles)
		triggerToggle(arg0.normalToggles[arg0.phaseId], true)
	elseif arg1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		arg0:setPhrase()

		if arg2 then
			arg0:aniOnSwitch(arg0.tecPanel, arg0.normalPanel)
		else
			setActive(arg0.normalPanel, false)
			setActive(arg0.tecPanel, true)
		end

		arg0:updateToggleDisable(arg0.tecToggles)
		triggerToggle(arg0.tecToggles[arg0.phaseId], true)
	end
end

function var0.switchPageByMediator(arg0)
	if arg0.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		arg0:switchPanel(arg0.normalTaskactivity)
	elseif arg0.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		arg0:switchPanel(arg0.tecTaskActivity)
	end
end

function var0.aniOnSwitch(arg0, arg1, arg2)
	arg0.isOnSwitchAni = true

	arg1:SetAsLastSibling()
	setActive(arg1, true)
	GetOrAddComponent(arg1, "DftAniEvent"):SetEndEvent(function()
		arg0.isOnSwitchAni = false

		setActive(arg2, false)
	end)
end

function var0.openMsgbox(arg0, arg1)
	setActive(arg0.switchToNormalBtn, false)
	setActive(arg0.switchToTecBtn, false)
	setActive(arg0.awardMsg, true)
	setActive(arg0.normalPanel, false)

	local var0
	local var1 = arg0.awardMsg:Find("photos")

	for iter0 = 1, var1.childCount do
		local var2 = var1:GetChild(iter0 - 1)

		onToggle(arg0, var2, function(arg0)
			if arg0 then
				var0 = iter0
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.awardMsg:Find("confirm_btn"), function()
		if var0 then
			if arg1 then
				arg1(var0)
			end

			arg0:closeMsgBox()
		end
	end, SFX_PANEL)
end

function var0.closeMsgBox(arg0)
	setActive(arg0.awardMsg, false)
	setActive(arg0.normalPanel, true)
	arg0:updateSwitchBtns()
end

function var0.tryShowTecFixTip(arg0)
	if arg0.isSubmitTecFirstTaskTag == true then
		arg0.isSubmitTecFirstTaskTag = false

		local var0 = arg0.tecTaskActivity:getConfig("config_data")[3][1][1]

		if _.all(var0, function(arg0)
			return arg0.taskProxy:getTaskById(arg0) ~= nil
		end) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				hideClose = true,
				content = i18n("tec_catchup_errorfix"),
				weight = LayerWeightConst.TOP_LAYER,
				onClose = function()
					arg0.lockFirst = true

					arg0:switchPanel(arg0.tecTaskActivity)
				end,
				onYes = function()
					arg0.lockFirst = true

					arg0:switchPanel(arg0.tecTaskActivity)
				end
			})
		end
	end
end

return var0
