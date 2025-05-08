local var0_0 = class("Island3dTaskPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskUI"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("toggles/content")

	arg0_2.toggleUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("types/content")

	arg0_2.typeUIList = UIItemList.New(var1_2, var1_2:Find("type_tpl"))
	arg0_2.emptyTF = arg0_2._tf:Find("detail/empty")
	arg0_2.detailTF = arg0_2._tf:Find("detail/content")
	arg0_2.titleBg = arg0_2.detailTF:Find("title")
	arg0_2.typeIcon = arg0_2.detailTF:Find("title/icon")
	arg0_2.nameTF = arg0_2.detailTF:Find("title/icon/name")
	arg0_2.timeTF = arg0_2.detailTF:Find("title/time")
	arg0_2.descTF = arg0_2.detailTF:Find("desc")
	arg0_2.targetTF = arg0_2.detailTF:Find("targets")

	setText(arg0_2.targetTF:Find("Text"), i18n1("任务目标："))

	arg0_2.finishedTargetTF = arg0_2.targetTF:Find("finished")
	arg0_2.targetContent = arg0_2.targetTF:Find("content")
	arg0_2.targetUIList = UIItemList.New(arg0_2.targetContent, arg0_2.targetContent:Find("tpl"))
	arg0_2.awardsTF = arg0_2.detailTF:Find("awards")

	setText(arg0_2.awardsTF:Find("title/Text"), i18n1("任务奖励"))

	local var2_2 = arg0_2.awardsTF:Find("view/mask/content")

	arg0_2.awardUIList = UIItemList.New(var2_2, var2_2:Find("tpl"))
	arg0_2.detailBtns = arg0_2.detailTF:Find("btns")
	arg0_2.traceBtn = arg0_2.detailBtns:Find("trace")

	setText(arg0_2.traceBtn:Find("Text"), i18n1("追踪任务"))

	arg0_2.tracedBtn = arg0_2.detailBtns:Find("traced")

	setText(arg0_2.tracedBtn:Find("Text"), i18n1("已追踪"))

	arg0_2.submitBtn = arg0_2.detailBtns:Find("submit")
	arg0_2.acceptBtn = arg0_2._tf:Find("top/accept")
	arg0_2.acceptPanel = arg0_2._tf:Find("accept_panel")

	setActive(arg0_2.acceptPanel, false)

	arg0_2.acceptUIList = UIItemList.New(arg0_2.acceptPanel:Find("Viewport/Content"), arg0_2.acceptPanel:Find("Viewport/Content/tpl"))

	arg0_2.acceptUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.canAcceptTask[arg1_3 + 1]

			setText(arg2_3:Find("id"), var0_3.id)
			setText(arg2_3:Find("name"), var0_3:getConfig("name"))
			onButton(arg0_2, arg2_3:Find("btn"), function()
				arg0_2:emit(IslandMediator.ON_ACCEPT_TASK, {
					var0_3.id
				})
				setActive(arg0_2.acceptPanel, false)
				arg0_2:Hide()
			end, SFX_PANEL)
		end
	end)
	onButton(arg0_2, arg0_2.acceptBtn, function()
		arg0_2.canAcceptTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasks()

		arg0_2.acceptUIList:align(#arg0_2.canAcceptTask)
		setActive(arg0_2.acceptPanel, #arg0_2.canAcceptTask > 0)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.acceptPanel:Find("close"), function()
		setActive(arg0_2.acceptPanel, false)
	end, SFX_PANEL)
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7._tf:Find("top/back"), function()
		arg0_7:Hide()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("top/home"), function()
		arg0_7:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_7.toggleUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventInit then
			arg0_7:InitToggleItem(arg1_10, arg2_10)
		end
	end)

	arg0_7.toggleList = underscore.keys(IslandTaskType.ShowTypeNames)

	table.sort(arg0_7.toggleList)
	arg0_7.toggleUIList:align(#arg0_7.toggleList)
	arg0_7.typeUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_7:UpdateTypeItem(arg1_11, arg2_11)
		end
	end)
	arg0_7.targetUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_7:UpdateTargetItem(arg1_12, arg2_12)
		end
	end)
	arg0_7.awardUIList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg0_7.showAwards[arg1_13 + 1]

			updateDrop(arg2_13, var0_13)
		end
	end)
	triggerToggle(arg0_7.toggleUIList.container:GetChild(0), true)
end

function var0_0.AddListeners(arg0_14)
	arg0_14:AddListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_14.Flush)
	arg0_14:AddListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_14.Flush)
	arg0_14:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_14.Flush)
	arg0_14:AddListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_14.Flush)
	arg0_14:AddListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_14.Flush)
	arg0_14:AddListener(IslandTaskAgency.TASK_ADDED, arg0_14.Flush)
	arg0_14:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_14.Flush)
	arg0_14:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_14.Flush)
end

function var0_0.RemoveListener(arg0_15)
	arg0_15:RemoveListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_15.Flush)
	arg0_15:RemoveListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_15.Flush)
	arg0_15:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_15.Flush)
	arg0_15:RemoveListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_15.Flush)
	arg0_15:RemoveListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_15.Flush)
	arg0_15:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_15.Flush)
	arg0_15:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_15.Flush)
	arg0_15:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_15.Flush)
end

function var0_0.InitToggleItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.toggleList[arg1_16 + 1]

	arg2_16.name = var0_16

	local var1_16 = IslandTaskType.ShowTypeNames[var0_16]

	setText(arg2_16:Find("unsel"), var1_16)
	setText(arg2_16:Find("sel/content/Text"), var1_16)

	if var0_16 ~= IslandTaskType.SHOW_ALL then
		LoadImageSpriteAsync("islandtasktype/" .. IslandTaskType.ShowTypeFields[var0_16], arg2_16:Find("sel/content/Image"))
	end

	onToggle(arg0_16, arg2_16, function(arg0_17)
		if arg0_17 and (not arg0_16.selectedType or arg0_16.selectedType ~= var0_16) then
			arg0_16.selectedType = var0_16

			arg0_16:Flush()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.showTypeList[arg1_18 + 1]

	arg2_18.name = var0_18

	local var1_18 = IslandTaskType.ShowTypeNames[var0_18]

	setText(arg2_18:Find("title/Text"), var1_18)
	setImageColor(arg2_18:Find("title"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_18]))
	LoadImageSpriteAsync("islandtasktype/" .. IslandTaskType.ShowTypeFields[var0_18], arg2_18:Find("title/Image"))
	setActive(arg2_18:Find("line"), arg1_18 + 1 ~= #arg0_18.showTypeList)

	local var2_18 = UIItemList.New(arg2_18:Find("list"), arg2_18:Find("list"):GetChild(0))

	var2_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = arg0_18.showTaskDict[var0_18][arg1_19 + 1]

			arg0_18:UpdateTaskItem(arg2_19, var0_19)
		end
	end)

	local var3_18 = arg0_18.showTaskDict[var0_18] and arg0_18.showTaskDict[var0_18] or {}

	var2_18:align(#var3_18)
end

function var0_0.UpdateTaskItem(arg0_20, arg1_20, arg2_20)
	arg1_20.name = arg2_20.id

	local var0_20 = arg2_20:GetShowType()

	setImageColor(arg1_20:Find("main/line"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_20]))
	setText(arg1_20:Find("main/desc"), arg2_20:GetDesc())

	local var1_20 = arg2_20:IsSeries()

	setText(arg1_20:Find("main/name"), var1_20 and arg2_20:GetSeriesTitle() or arg2_20:GetName())
	setActive(arg1_20:Find("sub"), var1_20)
	setActive(arg1_20:Find("main/location"), not var1_20)
	setActive(arg1_20:Find("main/desc"), not var1_20)

	if var1_20 then
		local var2_20 = IslandTaskType.ShowTypeFields[var0_20]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "color_" .. var2_20, arg1_20:Find("sub/bg"))
		setText(arg1_20:Find("sub/name"), arg2_20:GetName())
		arg0_20:UpdateLocation(arg1_20:Find("sub/location"), arg2_20)
	else
		arg0_20:UpdateLocation(arg1_20:Find("main/location"), arg2_20)
	end

	onToggle(arg0_20, arg1_20, function(arg0_21)
		if arg0_21 and (not arg0_20.selectedTaskId or arg0_20.selectedTaskId ~= arg2_20.id) then
			arg0_20.selectedTaskId = arg2_20.id

			arg0_20:FlushDetail()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateLocation(arg0_22, arg1_22, arg2_22)
	setActive(arg1_22, arg2_22.id == arg0_22.trackTaskId)

	if arg2_22.id == arg0_22.trackTaskId then
		local var0_22 = arg2_22:GetTraceParam()
		local var1_22 = tonumber(var0_22)

		setActive(arg1_22, var1_22)

		if var1_22 then
			local var2_22 = pg.island_world_objects[var1_22].mapId
			local var3_22 = var2_22 == arg0_22.curMapId and arg0_22:CalcDistance(var1_22) .. "m" or pg.island_map[var2_22].name

			setText(arg1_22:Find("Text"), var3_22)
		end
	end
end

function var0_0.CalcDistance(arg0_23, arg1_23)
	local var0_23 = _IslandCore:GetView():GetPlayerPosition()
	local var1_23 = _IslandCore:GetView():GetUnitPosition(arg1_23) or var0_23
	local var2_23 = Vector3.Distance(var0_23, var1_23)

	return math.ceil(var2_23)
end

function var0_0.UpdateTargetItem(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.showTargets[arg1_24 + 1]

	setText(arg2_24:Find("content/Text"), var0_24:getConfig("name"))

	local var1_24 = var0_24:GetProgress()
	local var2_24 = var0_24:GetTargetNum()

	setText(arg2_24:Find("content/num"), string.format("(%d/%d)", var1_24, var2_24))

	local var3_24 = var0_24:IsFinish()

	setActive(arg2_24:Find("status/unfinish"), not var3_24)
	setActive(arg2_24:Find("status/finished"), var3_24)

	local var4_24, var5_24 = arg0_24.showVO:GetTraceParam()
	local var6_24 = arg2_24:Find("content/location")
	local var7_24 = var5_24 and var5_24 == arg1_24 + 1

	setActive(var6_24, var7_24)

	if var7_24 then
		arg0_24:UpdateLocation(var6_24, arg0_24.showVO)
	end

	onButton(arg0_24, arg2_24:Find("content/add_progress"), function()
		arg0_24:emit(IslandMediator.ON_CLIENT_UPDATE_TASK, {
			progress = 1,
			taskId = arg0_24.showVO.id,
			targetId = var0_24.id
		})
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_26, arg1_26)
	local var0_26 = getProxy(IslandProxy):GetIsland()

	arg0_26.curMapId = var0_26:GetMapId()
	arg0_26.taskAgency = var0_26:GetTaskAgency()
	arg0_26.trackTaskId = arg0_26.taskAgency:GetTraceId()

	local var1_26 = arg0_26.taskAgency:GetTasks()

	arg0_26.showTaskDict = {}

	for iter0_26, iter1_26 in pairs(var1_26) do
		local var2_26 = iter1_26:GetShowType()

		if not arg0_26.showTaskDict[var2_26] then
			arg0_26.showTaskDict[var2_26] = {}
		end

		table.insert(arg0_26.showTaskDict[var2_26], iter1_26)
	end

	arg0_26.showTypeList = {
		arg0_26.selectedType
	}

	if arg0_26.selectedType == IslandTaskType.SHOW_ALL then
		arg0_26.showTypeList = underscore.keys(IslandTaskType.ShowTypeFields)
	end

	table.sort(arg0_26.showTypeList)
	arg0_26.typeUIList:align(#arg0_26.showTypeList)

	if not arg0_26.selectedTaskId or not arg0_26.showVO or not table.contains(arg0_26.showTypeList, arg0_26.showVO:GetShowType()) then
		arg0_26:PingFirstTask()
	else
		arg0_26:FlushDetail()
	end

	if isActive(arg0_26.acceptPanel) then
		triggerButton(arg0_26.acceptBtn)
	end
end

function var0_0.PingFirstTask(arg0_27)
	local var0_27 = underscore.detect(arg0_27.showTypeList, function(arg0_28)
		return arg0_27.showTaskDict[arg0_28] and #arg0_27.showTaskDict[arg0_28] > 0
	end)

	if var0_27 then
		triggerToggle(arg0_27.typeUIList.container:Find(var0_27 .. "/list"):GetChild(0), true)
	else
		arg0_27.selectedTaskId = nil

		arg0_27:FlushDetail()
	end
end

function var0_0.FlushDetail(arg0_29)
	setActive(arg0_29.detailTF, arg0_29.selectedTaskId)
	setActive(arg0_29.emptyTF, not arg0_29.selectedTaskId)

	if arg0_29.selectedTaskId then
		arg0_29.showVO = arg0_29.taskAgency:GetTask(arg0_29.selectedTaskId)

		local var0_29 = arg0_29.showVO:GetShowType()
		local var1_29 = IslandTaskType.ShowTypeFields[var0_29]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_bg_" .. var1_29, arg0_29.titleBg)
		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_icon_" .. var1_29, arg0_29.typeIcon)
		setText(arg0_29.nameTF, arg0_29.showVO:GetName())
		setActive(arg0_29.timeTF, var0_29 == IslandTaskType.SHOW_ACTIVITY)

		if var0_29 == IslandTaskType.SHOW_ACTIVITY then
			setText(arg0_29.timeTF:Find("Text"), arg0_29.showVO:GetRemainTimeStr())
		end

		setText(arg0_29.descTF, arg0_29.showVO:GetDesc())

		arg0_29.showTargets = arg0_29.showVO:GetTargetList()

		local var2_29 = not arg0_29.showVO:IsSubmitImmediately() and arg0_29.showVO:IsFinish()

		setActive(arg0_29.finishedTargetTF, var2_29)
		setActive(arg0_29.targetContent, not var2_29)

		if var2_29 then
			setText(arg0_29.finishedTargetTF, arg0_29.showVO:GetFinishedDesc())
		else
			arg0_29.targetUIList:align(#arg0_29.showTargets)
		end

		arg0_29.showAwards = arg0_29.showVO:GetAwards()

		arg0_29.awardUIList:align(#arg0_29.showAwards)
		setActive(arg0_29.traceBtn, arg0_29.showVO.id ~= arg0_29.trackTaskId)
		onButton(arg0_29, arg0_29.traceBtn, function()
			arg0_29:emit(IslandMediator.ON_SET_TRACE_ID, arg0_29.showVO.id)
		end, SFX_PANEL)
		setActive(arg0_29.tracedBtn, arg0_29.showVO.id == arg0_29.trackTaskId)
		onButton(arg0_29, arg0_29.tracedBtn, function()
			arg0_29:emit(IslandMediator.ON_SET_TRACE_ID, 0)
		end, SFX_PANEL)

		local var3_29 = arg0_29.showVO:IsFinish()

		setActive(arg0_29.submitBtn, var3_29)
		onButton(arg0_29, arg0_29.submitBtn, function()
			arg0_29.selectedTaskId = nil

			arg0_29:emit(IslandMediator.ON_SUBMIT_TASK, arg0_29.showVO.id)
			arg0_29:Hide()
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_33, arg1_33)
	if arg1_33 and arg1_33 ~= 0 then
		triggerToggle(arg0_33.toggleUIList.container:GetChild(0), true)

		local var0_33 = IslandTaskType.Type2ShowType[pg.island_task[arg1_33].type]

		triggerToggle(arg0_33.typeUIList.container:Find(var0_33 .. "/list/" .. arg1_33), true)
	else
		arg0_33:Flush()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_33._tf)
end

function var0_0.OnHide(arg0_34)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_34._tf)
end

return var0_0
