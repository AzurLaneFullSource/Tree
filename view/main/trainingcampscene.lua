local var0_0 = class("TrainingCampScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TrainingCampUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()

	if var0_0.isNormalActOn() then
		arg0_2:initNormalPanel()
	end

	if var0_0.isTecActOn() then
		arg0_2:initTecPanel()
	end

	arg0_2:closeMsgBox()
end

function var0_0.findUI(arg0_3)
	arg0_3.adaptPanel = arg0_3:findTF("blur_panel/adapt")
	arg0_3.panelContainer = arg0_3:findTF("PanelContainer")
	arg0_3.normalPanel = arg0_3:findTF("NormalPanel", arg0_3.panelContainer)
	arg0_3.tecPanel = arg0_3:findTF("TecPanel", arg0_3.panelContainer)
	arg0_3.switchToNormalBtn = arg0_3:findTF("SwitchToNormal")
	arg0_3.switchToTecBtn = arg0_3:findTF("SwitchToTec")
	arg0_3.switchToNormalLight = GetOrAddComponent(arg0_3:findTF("Light", arg0_3.switchToNormalBtn), "Animator")
	arg0_3.switchToTecLight = GetOrAddComponent(arg0_3:findTF("Light", arg0_3.switchToTecBtn), "Animator")
	arg0_3.awardMsg = arg0_3:findTF("ChooseAwardPanel")
	arg0_3.helpBtn = arg0_3:findTF("HelpBtn")
	arg0_3.titleTf = arg0_3:findTF("blur_panel/adapt/top/title")

	GetComponent(findTF(arg0_3.titleTf, "img"), typeof(Image)):SetNativeSize()
end

function var0_0.initData(arg0_4)
	arg0_4.taskProxy = getProxy(TaskProxy)
	arg0_4.activityProxy = getProxy(ActivityProxy)
	arg0_4.normalTaskactivity = arg0_4.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
	arg0_4.tecTaskActivity = arg0_4.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)
	arg0_4.phaseId = nil
	arg0_4.cachePageID = nil
	arg0_4.activity = nil
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5:findTF("top/back_button", arg0_5.adaptPanel), function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.switchToNormalBtn, function()
		if not arg0_5.isOnSwitchAni and var0_0.isNormalActOn() then
			arg0_5:switchPanel(arg0_5.normalTaskactivity, true)
			setActive(arg0_5.switchToNormalBtn, false)
			setActive(arg0_5.switchToTecBtn, true)
			arg0_5:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.switchToTecBtn, function()
		if not arg0_5.isOnSwitchAni and var0_0.isTecActOn() then
			arg0_5:switchPanel(arg0_5.tecTaskActivity, true)
			setActive(arg0_5.switchToNormalBtn, true)
			setActive(arg0_5.switchToTecBtn, false)
			arg0_5:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("newplayer_help_tip")
		})
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_10)
	arg0_10:updateSwitchBtns()
	arg0_10:updateSwitchBtnsTag()
	arg0_10:autoSelectPanel()
end

function var0_0.willExit(arg0_11)
	LeanTween.cancel(go(arg0_11.normalPanel))
	LeanTween.cancel(go(arg0_11.tecPanel))
end

function var0_0.updateSwitchBtns(arg0_12)
	local var0_12, var1_12 = TrainingCampScene.isNormalActOn()
	local var2_12, var3_12 = TrainingCampScene.isTecActOn()

	if not var0_12 or not var2_12 then
		setActive(arg0_12.switchToNormalBtn, false)
		setActive(arg0_12.switchToTecBtn, false)
	elseif var0_12 and var2_12 then
		setActive(arg0_12.switchToNormalBtn, true)
		setActive(arg0_12.switchToTecBtn, true)
	end

	local var4_12 = arg0_12:findTF("Tag", arg0_12.switchToNormalBtn)
	local var5_12 = arg0_12:findTF("Tag", arg0_12.switchToTecBtn)

	setActive(var4_12, var1_12)
	setActive(var5_12, var3_12)
end

function var0_0.updateSwitchBtnsTag(arg0_13)
	local var0_13, var1_13 = TrainingCampScene.isNormalActOn()
	local var2_13, var3_13 = TrainingCampScene.isTecActOn()
	local var4_13 = arg0_13:findTF("Tag", arg0_13.switchToNormalBtn)
	local var5_13 = arg0_13:findTF("Tag", arg0_13.switchToTecBtn)

	setActive(var4_13, var1_13)
	setActive(var5_13, var3_13)

	local var6_13 = PlayerPrefs.GetInt("TrainCamp_Tec_Catchup_First_Tag", 0)

	arg0_13.switchToNormalLight.enabled = var6_13 == 0
	arg0_13.switchToTecLight.enabled = var6_13 == 0

	if var6_13 == 0 then
		PlayerPrefs.SetInt("TrainCamp_Tec_Catchup_First_Tag", 1)
	end
end

function var0_0.resetSwitchBtnsLight(arg0_14)
	arg0_14.switchToNormalLight.enabled = false
	arg0_14.switchToTecLight.enabled = false
end

function var0_0.autoSelectPanel(arg0_15)
	local var0_15, var1_15 = TrainingCampScene.isNormalActOn()
	local var2_15, var3_15 = TrainingCampScene.isTecActOn()

	if var0_15 and var2_15 then
		arg0_15:switchPanel(arg0_15.normalTaskactivity)
		setActive(arg0_15.switchToNormalBtn, false)
		setActive(arg0_15.switchToTecBtn, true)
	elseif var0_15 then
		arg0_15:switchPanel(arg0_15.normalTaskactivity)
	elseif var2_15 then
		arg0_15:switchPanel(arg0_15.tecTaskActivity)
	end
end

function var0_0.initNormalPanel(arg0_16)
	local var0_16 = arg0_16:findTF("ToggleList", arg0_16.normalPanel)

	arg0_16.normalToggles = {
		arg0_16:findTF("Phase1", var0_16),
		arg0_16:findTF("Phase2", var0_16),
		arg0_16:findTF("Phase3", var0_16)
	}
	arg0_16.normalTaskUIItemList = UIItemList.New(arg0_16:findTF("ScrollRect/Content", arg0_16.normalPanel), arg0_16:findTF("ScrollRect/TaskTpl", arg0_16.normalPanel))
	arg0_16.normalProgressPanel = arg0_16:findTF("ProgressPanel", arg0_16.normalPanel)

	for iter0_16, iter1_16 in pairs(arg0_16.normalToggles) do
		onToggle(arg0_16, iter1_16, function(arg0_17)
			if arg0_17 then
				if arg0_16.phaseId < iter0_16 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("newplayer_notice_7"))
					triggerToggle(arg0_16.normalToggles[arg0_16.cachePageID], true)
				else
					arg0_16:updateNormalPanel(iter0_16)
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateNormalPanel(arg0_18, arg1_18)
	arg0_18.cachePageID = arg1_18

	local var0_18 = arg0_18.normalTaskactivity:getConfig("config_data")[3]
	local var1_18 = var0_18[arg1_18][1]
	local var2_18 = var0_18[arg1_18][2]

	arg0_18:sortTaskIDList(var1_18)
	arg0_18:updateTaskUIItemList(arg0_18.normalTaskUIItemList, var1_18, arg1_18)
	arg0_18:updateNormalProgressPanel(arg1_18, var2_18, var1_18)
end

function var0_0.updateNormalProgressPanel(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:getTask(arg1_19, arg2_19)

	if arg1_19 == arg0_19.phaseId and arg0_19:isMissTask(arg3_19) then
		arg0_19:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 1,
			activity_id = arg0_19.activity.id
		})
	end

	if var0_19 and var0_19:isClientTrigger() and not var0_19:isFinish() then
		arg0_19:emit(TrainingCampMediator.ON_UPDATE, var0_19)
	end

	local var1_19 = arg0_19.normalProgressPanel:Find("Get")
	local var2_19 = arg0_19.normalProgressPanel:Find("Lock")
	local var3_19 = arg0_19.normalProgressPanel:Find("Go")
	local var4_19 = arg0_19.normalProgressPanel:Find("Pass")

	setActive(var1_19, var0_19 and var0_19:isFinish() and not var0_19:isReceive())
	setActive(var2_19, not var0_19)
	setActive(var3_19, var0_19 and not var0_19:isFinish())
	setActive(var4_19, var0_19 and var0_19:isReceive())

	local var5_19 = arg0_19.normalProgressPanel:Find("Slider/LabelText")
	local var6_19 = arg0_19.normalProgressPanel:Find("Slider/ProgressText")

	if not var0_19 then
		var0_19 = Task.New({
			id = arg2_19
		})

		if arg0_19:isFinishedAll(arg3_19) then
			arg0_19:emit(TrainingCampMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = arg0_19.activity.id
			})
		end

		setText(var5_19, i18n("newplayer_notice_" .. arg1_19))

		local var7_19 = 0

		_.each(arg3_19, function(arg0_20)
			if arg0_19.taskProxy:getFinishTaskById(arg0_20) ~= nil then
				var7_19 = var7_19 + 1
			end
		end)
		setText(var6_19, var7_19 .. "/" .. #arg3_19)
	else
		setText(var5_19, var0_19:getConfig("desc"))
		setText(var6_19, math.min(var0_19.progress, var0_19:getConfig("target_num")) .. "/" .. var0_19:getConfig("target_num"))
	end

	arg0_19.normalProgressPanel:Find("Slider"):GetComponent(typeof(Slider)).value = var0_19.progress / var0_19:getConfig("target_num")
	arg0_19.normalProgressPanel:Find("Icon"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/trainingcampui_atlas", "panel_phase_award_" .. arg1_19)

	setText(arg0_19.normalProgressPanel:Find("TipText"), i18n("newplayer_notice_" .. 3 + arg1_19))
	onButton(arg0_19, var1_19, function()
		if var0_19:isSelectable() then
			arg0_19:openMsgbox(function(arg0_22)
				arg0_19:emit(TrainingCampMediator.ON_SELECTABLE_GET, var0_19, arg0_22)
			end)
		else
			arg0_19:emit(TrainingCampMediator.ON_GET, var0_19)
		end
	end, SFX_PANEL)
	onButton(arg0_19, var3_19, function()
		arg0_19:emit(TrainingCampMediator.ON_GO, var0_19)
	end, SFX_PANEL)
end

function var0_0.initTecPanel(arg0_24)
	local var0_24 = #arg0_24.tecTaskActivity:getConfig("config_data")[3]
	local var1_24 = arg0_24:findTF("ToggleList", arg0_24.tecPanel)

	arg0_24.tecToggles = {
		arg0_24:findTF("Phase1", var1_24)
	}

	for iter0_24 = #arg0_24.tecToggles + 1, var0_24 do
		local var2_24 = cloneTplTo(arg0_24.tecToggles[1], var1_24)

		table.insert(arg0_24.tecToggles, var2_24)

		var2_24.name = "Phase" .. iter0_24
	end

	for iter1_24 = 1, var0_24 do
		local var3_24 = var1_24:GetChild(iter1_24 - 1)
		local var4_24 = arg0_24:findTF("TextImg", var3_24)

		setText(var4_24, i18n("tec_catchup_" .. iter1_24))

		local var5_24 = arg0_24:findTF("Selected/TextImage", var3_24)

		setText(var5_24, i18n("tec_catchup_" .. iter1_24))
	end

	arg0_24.tecTaskUIItemList = UIItemList.New(arg0_24:findTF("ScrollRect/Content", arg0_24.tecPanel), arg0_24:findTF("ScrollRect/TaskTpl", arg0_24.tecPanel))
	arg0_24.tecProgressPanel = arg0_24:findTF("ProgressPanel", arg0_24.tecPanel)

	for iter2_24, iter3_24 in pairs(arg0_24.tecToggles) do
		onToggle(arg0_24, iter3_24, function(arg0_25)
			if arg0_25 then
				if arg0_24.phaseId < iter2_24 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tec_notice_not_open_tip"))
					triggerToggle(arg0_24.tecToggles[arg0_24.cachePageID], true)
				else
					arg0_24:updateTecPanel(iter2_24)
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateTecPanel(arg0_26, arg1_26)
	arg0_26.cachePageID = arg1_26

	local var0_26 = arg0_26.tecTaskActivity:getConfig("config_data")[3]
	local var1_26 = var0_26[arg1_26][1]
	local var2_26 = var0_26[arg1_26][2]

	arg0_26:sortTaskIDList(var1_26)
	arg0_26:updateTaskUIItemList(arg0_26.tecTaskUIItemList, var1_26, arg1_26)
	arg0_26:updateTecProgressPanel(arg1_26, var2_26, var1_26)
end

function var0_0.updateTecProgressPanel(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg0_27:isFinishedAll(arg3_27)
	local var1_27

	if not var0_27 then
		var1_27 = true
	end

	local var2_27 = arg0_27:getTask(arg1_27, arg2_27, var1_27)

	if arg1_27 == arg0_27.phaseId and arg0_27:isMissTask(arg3_27) then
		arg0_27:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 1,
			activity_id = arg0_27.activity.id
		})
	end

	if var2_27 and var2_27:isClientTrigger() and not var2_27:isFinish() then
		arg0_27:emit(TrainingCampMediator.ON_UPDATE, var2_27)
	end

	local var3_27 = arg0_27.tecProgressPanel:Find("Get")
	local var4_27 = arg0_27.tecProgressPanel:Find("Lock")
	local var5_27 = arg0_27.tecProgressPanel:Find("Go")
	local var6_27 = arg0_27.tecProgressPanel:Find("Pass")

	setActive(var3_27, var2_27 and var2_27:isFinish() and not var2_27:isReceive())
	setActive(var4_27, not var2_27)
	setActive(var5_27, var2_27 and not var2_27:isFinish())
	setActive(var6_27, var2_27 and var2_27:isReceive())

	local var7_27 = arg0_27.tecProgressPanel:Find("Slider/LabelText")
	local var8_27 = arg0_27.tecProgressPanel:Find("Slider/ProgressText")

	if not var2_27 then
		var2_27 = Task.New({
			id = arg2_27
		})

		if arg0_27:isFinishedAll(arg3_27) then
			arg0_27:emit(TrainingCampMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = arg0_27.activity.id
			})
		end

		setText(var7_27, i18n("tec_notice", i18n("tec_catchup_" .. arg1_27)))

		local var9_27 = 0

		_.each(arg3_27, function(arg0_28)
			local var0_28 = arg0_27.taskProxy:getTaskVO(arg0_28)

			if var0_28 and var0_28:isReceive() then
				var9_27 = var9_27 + 1
			end
		end)
		setText(var8_27, var9_27 .. "/" .. #arg3_27)
	else
		setText(var7_27, var2_27:getConfig("desc"))
		setText(var8_27, math.min(var2_27.progress, var2_27:getConfig("target_num")) .. "/" .. var2_27:getConfig("target_num"))
	end

	arg0_27.tecProgressPanel:Find("Slider"):GetComponent(typeof(Slider)).value = var2_27.progress / var2_27:getConfig("target_num")

	local var10_27 = arg0_27.tecProgressPanel:Find("Icon/Item")
	local var11_27 = var2_27:getConfig("award_display")[1]
	local var12_27 = {
		type = var11_27[1],
		id = var11_27[2],
		count = var11_27[3]
	}

	updateDrop(var10_27, var12_27)
	onButton(arg0_27, var10_27, function()
		arg0_27:emit(BaseUI.ON_DROP, var12_27)
	end, SFX_PANEL)
	setActive(arg0_27.tecProgressPanel:Find("TipText"), false)
	onButton(arg0_27, var3_27, function()
		if var2_27:isSelectable() then
			arg0_27:openMsgbox(function(arg0_31)
				arg0_27:emit(TrainingCampMediator.ON_SELECTABLE_GET, var2_27, arg0_31)
			end)
		else
			arg0_27:emit(TrainingCampMediator.ON_GET, var2_27)

			if arg0_27.phaseId == 1 then
				arg0_27.isSubmitTecFirstTaskTag = true

				arg0_27:emit(TrainingCampMediator.ON_TRIGGER, {
					cmd = 1,
					activity_id = arg0_27.activity.id
				})
			end
		end
	end, SFX_PANEL)
	onButton(arg0_27, var5_27, function()
		arg0_27:emit(TrainingCampMediator.ON_GO, var2_27)
	end, SFX_PANEL)
end

function var0_0.updateToggleDisable(arg0_33, arg1_33)
	for iter0_33, iter1_33 in ipairs(arg1_33) do
		setActive(iter1_33:Find("Disable"), iter0_33 > arg0_33.phaseId)
	end
end

function var0_0.updateTaskUIItemList(arg0_34, arg1_34, arg2_34, arg3_34)
	arg1_34:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			arg1_35 = arg1_35 + 1

			arg0_34:updateTask(arg2_34[arg1_35], arg2_35, arg3_34)
		end
	end)
	arg1_34:align(#arg2_34)
end

function var0_0.updateTask(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = arg2_36:Find("Get")
	local var1_36 = arg2_36:Find("Got")
	local var2_36 = arg2_36:Find("Go")
	local var3_36 = arg0_36:getTask(arg3_36, arg1_36)

	setActive(var0_36, var3_36 and var3_36:isFinish() and not var3_36:isReceive())
	setActive(var1_36, var3_36 and var3_36:isReceive())
	setActive(var2_36, not var3_36 or var3_36 and not var3_36:isFinish())

	if var3_36 and var3_36:isClientTrigger() and not var3_36:isFinish() then
		arg0_36:emit(TrainingCampMediator.ON_UPDATE, var3_36)
	end

	var3_36 = var3_36 or Task.New({
		id = arg1_36
	})

	setText(arg2_36:Find("TitleText"), var3_36:getConfig("desc"))

	local var4_36 = var3_36:getConfig("award_display")[1]
	local var5_36 = arg2_36:Find("Item")
	local var6_36 = {
		type = var4_36[1],
		id = var4_36[2],
		count = var4_36[3]
	}

	updateDrop(var5_36, var6_36)
	onButton(arg0_36, var5_36, function()
		arg0_36:emit(BaseUI.ON_DROP, var6_36)
	end, SFX_PANEL)
	setText(arg2_36:Find("ProgressText"), math.min(var3_36.progress, var3_36:getConfig("target_num")) .. "/" .. var3_36:getConfig("target_num"))
	onButton(arg0_36, var0_36, function()
		arg0_36:emit(TrainingCampMediator.ON_GET, var3_36)
	end, SFX_PANEL)
	onButton(arg0_36, var2_36, function()
		arg0_36:emit(TrainingCampMediator.ON_GO, var3_36)
	end, SFX_PANEL)
end

function var0_0.getTask(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40

	if arg1_40 >= arg0_40.phaseId then
		if arg3_40 == true then
			return nil
		end

		var0_40 = arg0_40.taskProxy:getTaskById(arg2_40) or arg0_40.taskProxy:getFinishTaskById(arg2_40)
	else
		var0_40 = Task.New({
			id = arg2_40
		})
		var0_40.progress = var0_40:getConfig("target_num")
		var0_40.submitTime = 1
	end

	return var0_40
end

function var0_0.getTaskState(arg0_41, arg1_41)
	if arg1_41:isReceive() then
		return 0
	elseif arg1_41:isFinish() then
		return 2
	elseif not arg1_41:isFinish() then
		return 1
	end

	return -1
end

function var0_0.sortTaskIDList(arg0_42, arg1_42)
	table.sort(arg1_42, function(arg0_43, arg1_43)
		local var0_43 = arg0_42.taskProxy:getTaskVO(arg0_43) or Task.New({
			id = arg0_43
		})
		local var1_43 = arg0_42.taskProxy:getTaskVO(arg1_43) or Task.New({
			id = arg1_43
		})
		local var2_43 = arg0_42:getTaskState(var0_43)
		local var3_43 = arg0_42:getTaskState(var1_43)

		if var2_43 == var3_43 then
			return var0_43.id < var1_43.id
		else
			return var3_43 < var2_43
		end
	end)

	return arg1_42
end

function var0_0.isFinishedAll(arg0_44, arg1_44)
	return _.all(arg1_44, function(arg0_45)
		local var0_45 = arg0_44.taskProxy:getTaskVO(arg0_45)

		return var0_45 and var0_45:isReceive() or false
	end)
end

function var0_0.isMissTask(arg0_46, arg1_46)
	return _.any(arg1_46, function(arg0_47)
		return arg0_46.taskProxy:getTaskVO(arg0_47) == nil
	end)
end

function var0_0.setPhrase(arg0_48)
	if arg0_48.lockFirst == true then
		arg0_48.phaseId = 1

		return
	end

	local var0_48 = 1
	local var1_48 = arg0_48.activity:getConfig("config_data")[3]
	local var2_48 = #var1_48

	local function var3_48(arg0_49)
		if arg0_49 > 1 then
			local var0_49 = var1_48[arg0_49 - 1][2]

			return arg0_48.taskProxy:getFinishTaskById(var0_49) ~= nil
		end
	end

	for iter0_48 = var2_48, 1, -1 do
		local var4_48 = var1_48[iter0_48][1]

		if _.all(var4_48, function(arg0_50)
			return arg0_48.taskProxy:getTaskVO(arg0_50) ~= nil
		end) or var3_48(iter0_48) then
			var0_48 = iter0_48

			break
		end
	end

	arg0_48.phaseId = var0_48
end

function var0_0.isNormalActOn()
	local var0_51 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
	local var1_51 = var0_51 and not var0_51:isEnd()
	local var2_51 = false
	local var3_51 = false

	if var1_51 then
		local var4_51 = var0_51:getConfig("config_data")[1]
		local var5_51 = getProxy(ChapterProxy):getChapterById(var4_51)

		var2_51 = var5_51 and var5_51:isClear()

		local var6_51 = _.flatten(var0_51:getConfig("config_data")[3])
		local var7_51 = getProxy(TaskProxy)

		var3_51 = _.any(var6_51, function(arg0_52)
			local var0_52 = var7_51:getTaskById(arg0_52)

			return var0_52 and var0_52:isFinish() and not var0_52:isReceive()
		end)
	end

	return var1_51 and var2_51, var3_51
end

function var0_0.isTecActOn()
	local var0_53 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)
	local var1_53 = var0_53 and not var0_53:isEnd()
	local var2_53 = getProxy(PlayerProxy):getRawData()
	local var3_53 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var2_53.level, "ShipBluePrintMediator")
	local var4_53 = false
	local var5_53 = false

	if var1_53 then
		local var6_53 = var0_53:getConfig("config_data")[1]
		local var7_53 = getProxy(ChapterProxy):getChapterById(var6_53)

		var4_53 = var7_53 and var7_53:isClear()

		local var8_53 = _.flatten(var0_53:getConfig("config_data")[3])
		local var9_53 = getProxy(TaskProxy)

		var5_53 = _.any(var8_53, function(arg0_54)
			local var0_54 = var9_53:getTaskById(arg0_54)

			return var0_54 and var0_54:isFinish() and not var0_54:isReceive()
		end)
	end

	return var1_53 and var4_53 and var3_53, var5_53
end

function var0_0.switchPanel(arg0_55, arg1_55, arg2_55)
	arg0_55.activity = arg1_55

	if arg1_55:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		arg0_55:setPhrase()

		if arg2_55 then
			arg0_55:aniOnSwitch(arg0_55.normalPanel, arg0_55.tecPanel)
		else
			setActive(arg0_55.normalPanel, true)
			setActive(arg0_55.tecPanel, false)
		end

		arg0_55:updateToggleDisable(arg0_55.normalToggles)
		triggerToggle(arg0_55.normalToggles[arg0_55.phaseId], true)
	elseif arg1_55:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		arg0_55:setPhrase()

		if arg2_55 then
			arg0_55:aniOnSwitch(arg0_55.tecPanel, arg0_55.normalPanel)
		else
			setActive(arg0_55.normalPanel, false)
			setActive(arg0_55.tecPanel, true)
		end

		arg0_55:updateToggleDisable(arg0_55.tecToggles)
		triggerToggle(arg0_55.tecToggles[arg0_55.phaseId], true)
	end
end

function var0_0.switchPageByMediator(arg0_56)
	if arg0_56.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		arg0_56:switchPanel(arg0_56.normalTaskactivity)
	elseif arg0_56.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		arg0_56:switchPanel(arg0_56.tecTaskActivity)
	end
end

function var0_0.aniOnSwitch(arg0_57, arg1_57, arg2_57)
	arg0_57.isOnSwitchAni = true

	arg1_57:SetAsLastSibling()
	setActive(arg1_57, true)
	GetOrAddComponent(arg1_57, "DftAniEvent"):SetEndEvent(function()
		arg0_57.isOnSwitchAni = false

		setActive(arg2_57, false)
	end)
end

function var0_0.openMsgbox(arg0_59, arg1_59)
	setActive(arg0_59.switchToNormalBtn, false)
	setActive(arg0_59.switchToTecBtn, false)
	setActive(arg0_59.awardMsg, true)
	setActive(arg0_59.normalPanel, false)

	local var0_59
	local var1_59 = arg0_59.awardMsg:Find("photos")

	for iter0_59 = 1, var1_59.childCount do
		local var2_59 = var1_59:GetChild(iter0_59 - 1)

		onToggle(arg0_59, var2_59, function(arg0_60)
			if arg0_60 then
				var0_59 = iter0_59
			end
		end, SFX_PANEL)
	end

	onButton(arg0_59, arg0_59.awardMsg:Find("confirm_btn"), function()
		if var0_59 then
			if arg1_59 then
				arg1_59(var0_59)
			end

			arg0_59:closeMsgBox()
		end
	end, SFX_PANEL)
end

function var0_0.closeMsgBox(arg0_62)
	setActive(arg0_62.awardMsg, false)
	setActive(arg0_62.normalPanel, true)
	arg0_62:updateSwitchBtns()
end

function var0_0.tryShowTecFixTip(arg0_63)
	if arg0_63.isSubmitTecFirstTaskTag == true then
		arg0_63.isSubmitTecFirstTaskTag = false

		local var0_63 = arg0_63.tecTaskActivity:getConfig("config_data")[3][1][1]

		if _.all(var0_63, function(arg0_64)
			return arg0_63.taskProxy:getTaskById(arg0_64) ~= nil
		end) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = true,
				hideClose = true,
				content = i18n("tec_catchup_errorfix"),
				weight = LayerWeightConst.TOP_LAYER,
				onClose = function()
					arg0_63.lockFirst = true

					arg0_63:switchPanel(arg0_63.tecTaskActivity)
				end,
				onYes = function()
					arg0_63.lockFirst = true

					arg0_63:switchPanel(arg0_63.tecTaskActivity)
				end
			})
		end
	end
end

return var0_0
