local var0_0 = class("TrainingCampScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TrainingCampUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()

	if TechnologyConst.isNormalActOn() then
		arg0_2:initNormalPanel()
	end

	if TechnologyConst.isTecActOn() then
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
		if not arg0_5.isOnSwitchAni and TechnologyConst.isNormalActOn() then
			arg0_5:switchPanel(arg0_5.normalTaskactivity, true)
			setActive(arg0_5.switchToNormalBtn, false)
			setActive(arg0_5.switchToTecBtn, true)
			arg0_5:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.switchToTecBtn, function()
		if not arg0_5.isOnSwitchAni and TechnologyConst.isTecActOn() then
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
	local var0_12, var1_12 = TechnologyConst.isNormalActOn()
	local var2_12, var3_12 = TechnologyConst.isTecActOn()

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
	local var0_13, var1_13 = TechnologyConst.isNormalActOn()
	local var2_13, var3_13 = TechnologyConst.isTecActOn()
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
	local var0_15, var1_15 = TechnologyConst.isNormalActOn()
	local var2_15, var3_15 = TechnologyConst.isTecActOn()

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
	arg0_18:updateTaskUIItemList(arg0_18.normalTaskUIItemList, var1_18)
	arg0_18:updateNormalProgressPanel(arg1_18, var2_18, var1_18)
end

function var0_0.updateNormalProgressPanel(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:getTask(arg2_19)

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
	local var0_24 = arg0_24.tecTaskActivity:getConfig("config_data")[3]

	arg0_24.allTechPhase = #arg0_24.tecTaskActivity:getConfig("config_data")[3] + 1

	local var1_24 = arg0_24:findTF("ToggleList", arg0_24.tecPanel)
	local var2_24 = arg0_24:findTF("Phase1", var1_24)

	UIItemList.StaticAlign(var1_24, var2_24, arg0_24.allTechPhase, function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			arg2_25.name = "Phase" .. arg1_25

			setText(arg2_25:Find("TextImg"), i18n("tec_catchup_" .. arg1_25))
			onToggle(arg0_24, arg2_25, function(arg0_26)
				setTextColor(arg2_25:Find("TextImg"), arg0_26 and Color.white or Color.NewHex("525252"))

				if arg0_26 then
					arg0_24:updateTecPanel(arg1_25)
				end
			end, SFX_PANEL)
			onButton(arg0_24, arg2_25:Find("Disable"), function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("tec_notice_not_open_tip"))
			end, SFX_PANEL)
			onButton(arg0_24, arg2_25:Find("Unlock"), function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = string.format("are you unlock phase %d ?", arg1_25),
					onYes = function()
						if arg1_25 == 1 then
							warning("cmd 3")
							arg0_24:emit(TrainingCampMediator.ON_TRIGGER, {
								cmd = 3,
								activity_id = arg0_24.tecTaskActivity.id
							})
						else
							arg0_24:emit(TrainingCampMediator.ON_TRIGGER, {
								cmd = 1,
								activity_id = arg0_24.tecTaskActivity.id,
								arg1 = arg1_25 == 0 and 1 or arg1_25
							})
						end
					end
				})
			end, SFX_PANEL)
		end
	end)

	arg0_24.tecTaskUIItemList = UIItemList.New(arg0_24:findTF("ScrollRect/Content", arg0_24.tecPanel), arg0_24:findTF("ScrollRect/TaskTpl", arg0_24.tecPanel))
	arg0_24.tecProgressPanel = arg0_24:findTF("ProgressPanel", arg0_24.tecPanel)
end

function var0_0.updateTecPanel(arg0_30, arg1_30)
	arg0_30.cachePageID = arg1_30

	local var0_30 = arg0_30.tecTaskActivity:getConfig("config_data")[3]
	local var1_30 = var0_30[math.max(1, arg1_30)][1]
	local var2_30 = var0_30[math.max(1, arg1_30)][2]

	arg0_30:sortTaskIDList(var1_30)
	arg0_30:updateTaskUIItemList(arg0_30.tecTaskUIItemList, var1_30)
	arg0_30:updateTecProgressPanel(var2_30, arg1_30, var1_30)
end

function var0_0.updateTecProgressPanel(arg0_31, arg1_31, arg2_31, arg3_31)
	if arg0_31:isFinishedAll(arg3_31) then
		arg0_31:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 2,
			activity_id = arg0_31.activity.id
		})
	end

	local var0_31

	if arg0_31.phaseId == arg2_31 then
		var0_31 = arg0_31.taskProxy:getTaskVO(arg1_31)
	else
		var0_31 = arg0_31:getTask(arg1_31)
	end

	if var0_31 and var0_31:isClientTrigger() and not var0_31:isFinish() then
		arg0_31:emit(TrainingCampMediator.ON_UPDATE, var0_31)
	end

	local var1_31 = arg0_31.tecProgressPanel:Find("Get")
	local var2_31 = arg0_31.tecProgressPanel:Find("Lock")
	local var3_31 = arg0_31.tecProgressPanel:Find("Go")
	local var4_31 = arg0_31.tecProgressPanel:Find("Pass")

	setActive(var1_31, var0_31 and var0_31:isFinish() and not var0_31:isReceive())
	setActive(var2_31, not var0_31)
	setActive(var3_31, var0_31 and not var0_31:isFinish())
	setActive(var4_31, var0_31 and var0_31:isReceive())

	local var5_31 = arg0_31.tecProgressPanel:Find("Slider/LabelText")
	local var6_31 = arg0_31.tecProgressPanel:Find("Slider/ProgressText")

	if not var0_31 then
		local var7_31 = 0

		_.each(arg3_31, function(arg0_32)
			local var0_32 = arg0_31.taskProxy:getTaskVO(arg0_32)

			if var0_32 and var0_32:isReceive() then
				var7_31 = var7_31 + 1
			end
		end)

		var0_31 = Task.New({
			id = arg1_31
		})

		setText(var5_31, i18n("tec_notice", i18n("tec_catchup_" .. arg2_31)))
	else
		setText(var5_31, var0_31:getConfig("desc"))
	end

	setText(var6_31, math.min(var0_31.progress, var0_31:getConfig("target_num")) .. "/" .. var0_31:getConfig("target_num"))
	setSlider(arg0_31.tecProgressPanel:Find("Slider"), 0, var0_31:getConfig("target_num"), var0_31.progress)

	local var8_31 = arg0_31.tecProgressPanel:Find("Icon/Item")
	local var9_31 = var0_31:getConfig("award_display")[1]
	local var10_31 = {
		type = var9_31[1],
		id = var9_31[2],
		count = var9_31[3]
	}

	updateDrop(var8_31, var10_31)
	onButton(arg0_31, var8_31, function()
		arg0_31:emit(BaseUI.ON_DROP, var10_31)
	end, SFX_PANEL)
	setActive(arg0_31.tecProgressPanel:Find("TipText"), false)
	onButton(arg0_31, var1_31, function()
		if var0_31:isSelectable() then
			arg0_31:openMsgbox(function(arg0_35)
				arg0_31:emit(TrainingCampMediator.ON_SELECTABLE_GET, var0_31, arg0_35)
			end)
		else
			arg0_31:emit(TrainingCampMediator.ON_GET, var0_31)
		end
	end, SFX_PANEL)
	onButton(arg0_31, var3_31, function()
		arg0_31:emit(TrainingCampMediator.ON_GO, var0_31)
	end, SFX_PANEL)
end

function var0_0.updateToggleDisable(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg1_37) do
		setActive(iter1_37:Find("Disable"), iter0_37 > arg0_37.phaseId)
	end
end

function var0_0.updateTechToggleState(arg0_38)
	local var0_38 = arg0_38.techFinishTaskId and arg0_38.taskProxy:getTaskVO(arg0_38.techFinishTaskId)
	local var1_38 = arg0_38.phaseId == "ready" or TechnologyConst.isTecActOn() and var0_38 and var0_38:isReceive()

	eachChild(arg0_38.tecPanel:Find("ToggleList"), function(arg0_39, arg1_39)
		local var0_39 = not arg0_38.finishPhaseDic[arg1_39] and arg0_38.phaseId ~= arg1_39
		local var1_39 = var1_38 and (arg1_39 ~= 1 or arg0_38.finishPhaseDic[0] or arg0_38.phaseId == 0)

		setActive(arg0_39:Find("Unlock"), var0_39 and var1_39)
		setActive(arg0_39:Find("Disable"), var0_39 and not var1_39)
	end)
end

function var0_0.updateTaskUIItemList(arg0_40, arg1_40, arg2_40)
	arg1_40:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			arg1_41 = arg1_41 + 1

			arg0_40:updateTask(arg2_40[arg1_41], arg2_41)
		end
	end)
	arg1_40:align(#arg2_40)
end

function var0_0.updateTask(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg2_42:Find("Get")
	local var1_42 = arg2_42:Find("Got")
	local var2_42 = arg2_42:Find("Go")
	local var3_42 = arg0_42:getTask(arg1_42)

	setActive(var0_42, var3_42 and var3_42:isFinish() and not var3_42:isReceive())
	setActive(var1_42, var3_42 and var3_42:isReceive())
	setActive(var2_42, not var3_42 or var3_42 and not var3_42:isFinish())

	if var3_42 and var3_42:isClientTrigger() and not var3_42:isFinish() then
		arg0_42:emit(TrainingCampMediator.ON_UPDATE, var3_42)
	end

	setText(arg2_42:Find("TitleText"), var3_42:getConfig("desc"))

	local var4_42 = var3_42:getConfig("award_display")[1]
	local var5_42 = arg2_42:Find("Item")
	local var6_42 = {
		type = var4_42[1],
		id = var4_42[2],
		count = var4_42[3]
	}

	updateDrop(var5_42, var6_42)
	onButton(arg0_42, var5_42, function()
		arg0_42:emit(BaseUI.ON_DROP, var6_42)
	end, SFX_PANEL)
	setText(arg2_42:Find("ProgressText"), math.min(var3_42.progress, var3_42:getConfig("target_num")) .. "/" .. var3_42:getConfig("target_num"))
	onButton(arg0_42, var0_42, function()
		arg0_42:emit(TrainingCampMediator.ON_GET, var3_42)
	end, SFX_PANEL)
	onButton(arg0_42, var2_42, function()
		arg0_42:emit(TrainingCampMediator.ON_GO, var3_42)
	end, SFX_PANEL)
end

function var0_0.getTask(arg0_46, arg1_46)
	local var0_46 = arg0_46.taskProxy:getTaskVO(arg1_46)

	if not var0_46 then
		var0_46 = Task.New({
			id = arg1_46
		})
		var0_46.progress = var0_46:getConfig("target_num")
		var0_46.submitTime = 1
	end

	return var0_46
end

function var0_0.getTaskState(arg0_47, arg1_47)
	if arg1_47:isReceive() then
		return 0
	elseif arg1_47:isFinish() then
		return 2
	elseif not arg1_47:isFinish() then
		return 1
	end

	return -1
end

function var0_0.sortTaskIDList(arg0_48, arg1_48)
	table.sort(arg1_48, function(arg0_49, arg1_49)
		local var0_49 = arg0_48.taskProxy:getTaskVO(arg0_49) or Task.New({
			id = arg0_49
		})
		local var1_49 = arg0_48.taskProxy:getTaskVO(arg1_49) or Task.New({
			id = arg1_49
		})
		local var2_49 = arg0_48:getTaskState(var0_49)
		local var3_49 = arg0_48:getTaskState(var1_49)

		if var2_49 == var3_49 then
			return var0_49.id < var1_49.id
		else
			return var3_49 < var2_49
		end
	end)

	return arg1_48
end

function var0_0.isFinishedAll(arg0_50, arg1_50)
	return _.all(arg1_50, function(arg0_51)
		local var0_51 = arg0_50.taskProxy:getTaskVO(arg0_51)

		return var0_51 and var0_51:isReceive() or false
	end)
end

function var0_0.isMissTask(arg0_52, arg1_52)
	return _.any(arg1_52, function(arg0_53)
		return arg0_52.taskProxy:getTaskVO(arg0_53) == nil
	end)
end

function var0_0.setPhrase(arg0_54)
	if arg0_54.lockFirst == true then
		arg0_54.phaseId = 1

		return
	end

	local var0_54 = 1
	local var1_54 = arg0_54.activity:getConfig("config_data")[3]
	local var2_54 = #var1_54

	local function var3_54(arg0_55)
		if arg0_55 > 1 then
			local var0_55 = var1_54[arg0_55 - 1][2]

			return arg0_54.taskProxy:getFinishTaskById(var0_55) ~= nil
		end
	end

	for iter0_54 = var2_54, 1, -1 do
		local var4_54 = var1_54[iter0_54][1]

		if _.all(var4_54, function(arg0_56)
			return arg0_54.taskProxy:getTaskVO(arg0_56) ~= nil
		end) or var3_54(iter0_54) then
			var0_54 = iter0_54

			break
		end
	end

	arg0_54.phaseId = var0_54
end

function var0_0.setTechPhrase(arg0_57)
	if arg0_57.activity.data1 == 0 then
		arg0_57.phaseId = "ready"
	else
		arg0_57.phaseId = arg0_57.activity.data1

		if arg0_57.phaseId == 1 and arg0_57.activity.data2 < 1 then
			arg0_57.phaseId = 0
		end
	end

	arg0_57.techFinishTaskId = arg0_57.phaseId ~= "ready" and arg0_57.activity:getConfig("config_data")[3][math.max(1, arg0_57.phaseId)][2] or nil
	arg0_57.finishPhaseDic = {}

	for iter0_57, iter1_57 in ipairs(arg0_57.activity.data1_list) do
		arg0_57.finishPhaseDic[iter1_57] = true
	end

	arg0_57.finishPhaseDic[0] = arg0_57.finishPhaseDic[1]
	arg0_57.finishPhaseDic[1] = arg0_57.activity.data2 == 1 and arg0_57.activity.data1 ~= 1

	arg0_57:updateTechToggleState()
end

function var0_0.switchPanel(arg0_58, arg1_58, arg2_58)
	arg0_58.activity = arg1_58

	if arg1_58:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		arg0_58:setPhrase()

		if arg2_58 then
			arg0_58:aniOnSwitch(arg0_58.normalPanel, arg0_58.tecPanel)
		else
			setActive(arg0_58.normalPanel, true)
			setActive(arg0_58.tecPanel, false)
		end

		arg0_58:updateToggleDisable(arg0_58.normalToggles)
		triggerToggle(arg0_58.normalToggles[arg0_58.phaseId], true)
	elseif arg1_58:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		arg0_58:setTechPhrase()

		local var0_58 = arg0_58.phaseId == "ready"

		arg0_58.tecPanel:Find("ToggleList"):GetComponent(typeof(ToggleGroup)).allowSwitchOff = var0_58

		setActive(arg0_58.tecPanel:Find("ScrollRect"), not var0_58)
		setActive(arg0_58.tecPanel:Find("ProgressPanel"), not var0_58)

		if arg2_58 then
			arg0_58:aniOnSwitch(arg0_58.tecPanel, arg0_58.normalPanel)
		else
			setActive(arg0_58.normalPanel, false)
			setActive(arg0_58.tecPanel, true)
		end

		if arg0_58.phaseId == "ready" then
			eachChild(arg0_58.tecPanel:Find("ToggleList"), function(arg0_59)
				triggerToggle(arg0_59, false)
			end)
		else
			triggerToggle(arg0_58.tecPanel:Find("ToggleList"):GetChild(arg0_58.phaseId), true)
		end
	end
end

function var0_0.switchPageByMediator(arg0_60)
	if arg0_60.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		arg0_60:switchPanel(arg0_60.normalTaskactivity)
	elseif arg0_60.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		arg0_60:switchPanel(arg0_60.tecTaskActivity)
	end
end

function var0_0.aniOnSwitch(arg0_61, arg1_61, arg2_61)
	arg0_61.isOnSwitchAni = true

	arg1_61:SetAsLastSibling()
	setActive(arg1_61, true)
	GetOrAddComponent(arg1_61, "DftAniEvent"):SetEndEvent(function()
		arg0_61.isOnSwitchAni = false

		setActive(arg2_61, false)
	end)
end

function var0_0.openMsgbox(arg0_63, arg1_63)
	setActive(arg0_63.switchToNormalBtn, false)
	setActive(arg0_63.switchToTecBtn, false)
	setActive(arg0_63.awardMsg, true)
	setActive(arg0_63.normalPanel, false)

	local var0_63
	local var1_63 = arg0_63.awardMsg:Find("photos")

	for iter0_63 = 1, var1_63.childCount do
		local var2_63 = var1_63:GetChild(iter0_63 - 1)

		onToggle(arg0_63, var2_63, function(arg0_64)
			if arg0_64 then
				var0_63 = iter0_63
			end
		end, SFX_PANEL)
	end

	onButton(arg0_63, arg0_63.awardMsg:Find("confirm_btn"), function()
		if var0_63 then
			if arg1_63 then
				arg1_63(var0_63)
			end

			arg0_63:closeMsgBox()
		end
	end, SFX_PANEL)
end

function var0_0.closeMsgBox(arg0_66)
	setActive(arg0_66.awardMsg, false)
	setActive(arg0_66.normalPanel, true)
	arg0_66:updateSwitchBtns()
end

function var0_0.tryShowTecFixTip(arg0_67, arg1_67)
	if arg0_67.tecTaskActivity and arg1_67 == arg0_67.tecTaskActivity.id then
		arg0_67.tecTaskActivity = arg0_67.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)
	end
end

return var0_0
