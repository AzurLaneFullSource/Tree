local var0_0 = class("Island3dTaskPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskUI"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("adapt/toggles/content")

	arg0_2.toggleUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("adapt/types/content")

	arg0_2.typeUIList = UIItemList.New(var1_2, var1_2:Find("type_tpl"))
	arg0_2.detailAnim = arg0_2._tf:Find("adapt/detail"):GetComponent(typeof(Animation))
	arg0_2.emptyTF = arg0_2._tf:Find("adapt/detail/empty")
	arg0_2.detailTF = arg0_2._tf:Find("adapt/detail/content")
	arg0_2.titleBg = arg0_2.detailTF:Find("title")
	arg0_2.typeIcon = arg0_2.detailTF:Find("title/icon")
	arg0_2.nameTF = arg0_2.detailTF:Find("title/icon/name")
	arg0_2.timeTF = arg0_2.detailTF:Find("title/time")
	arg0_2.descTF = arg0_2.detailTF:Find("desc")
	arg0_2.targetTF = arg0_2.detailTF:Find("targets")

	setText(arg0_2.targetTF:Find("Text"), i18n("island_task_target"))

	arg0_2.finishedTargetTF = arg0_2.targetTF:Find("content/finished")
	arg0_2.finishedTargetTextTF = arg0_2.finishedTargetTF:Find("Text")
	arg0_2.finishedTargetLocTF = arg0_2.finishedTargetTF:Find("location")
	arg0_2.targetContent = arg0_2.targetTF:Find("content/list")
	arg0_2.targetUIList = UIItemList.New(arg0_2.targetContent, arg0_2.targetContent:Find("tpl"))
	arg0_2.awardsTF = arg0_2.detailTF:Find("awards")

	setText(arg0_2.awardsTF:Find("title/Text"), i18n("island_task_award"))

	local var2_2 = arg0_2.awardsTF:Find("view/mask/content")

	arg0_2.awardUIList = UIItemList.New(var2_2, var2_2:Find("tpl"))
	arg0_2.detailBtns = arg0_2.detailTF:Find("btns")
	arg0_2.traceBtn = arg0_2.detailBtns:Find("trace")

	setText(arg0_2.traceBtn:Find("Text"), i18n("island_task_tracking"))

	arg0_2.tracedBtn = arg0_2.detailBtns:Find("traced")

	setText(arg0_2.tracedBtn:Find("Text"), i18n("island_task_tracked"))
	setText(arg0_2:findTF("top/title/Text"), i18n("island_task_title"))
	setText(arg0_2:findTF("top/title/Text/en"), i18n("island_task_title_en"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.toggleUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_3:InitToggleItem(arg1_5, arg2_5)
		end
	end)
	arg0_3.typeUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateTypeItem(arg1_6, arg2_6)
		end
	end)
	arg0_3.targetUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:UpdateTargetItem(arg1_7, arg2_7)
		end
	end)
	arg0_3.awardUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_3.showAwards[arg1_8 + 1]

			updateCustomDrop(arg2_8, var0_8)
		end
	end)
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_9.FlushDetail)
	arg0_9:AddListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_9.Flush)
	arg0_9:AddListener(IslandTaskAgency.TASK_ADDED, arg0_9.Flush)
	arg0_9:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_9.Flush)
	arg0_9:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_9.Flush)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_10.FlushDetail)
	arg0_10:RemoveListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_10.Flush)
	arg0_10:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_10.Flush)
	arg0_10:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_10.Flush)
end

function var0_0.InitToggleItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.toggleList[arg1_11 + 1]

	arg2_11.name = var0_11

	local var1_11 = IslandTaskType.ShowTypeNames[var0_11]

	setText(arg2_11:Find("unsel"), var1_11)
	setText(arg2_11:Find("sel/content/Text"), var1_11)

	if var0_11 ~= IslandTaskType.SHOW_ALL then
		LoadImageSpriteAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_11], arg2_11:Find("sel/content/Image"), false)
	end

	onToggle(arg0_11, arg2_11, function(arg0_12)
		if arg0_12 and (not arg0_11.selectedType or arg0_11.selectedType ~= var0_11) then
			arg0_11.selectedType = var0_11

			arg0_11:Flush()
			arg2_11:GetComponent(typeof(Animation)):Play()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.showTypeList[arg1_13 + 1]

	arg2_13.name = var0_13

	local var1_13 = IslandTaskType.ShowTypeNames[var0_13]

	setText(arg2_13:Find("title/Text"), var1_13)
	setImageColor(arg2_13:Find("title"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_13]))
	LoadImageSpriteAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_13], arg2_13:Find("title/Image"))
	setActive(arg2_13:Find("line"), arg1_13 + 1 ~= #arg0_13.showTypeList)

	local var2_13 = UIItemList.New(arg2_13:Find("list"), arg2_13:Find("list"):GetChild(0))

	var2_13:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_13.showTaskDict[var0_13][arg1_14 + 1]

			arg0_13:UpdateTaskItem(arg2_14, var0_14)
		end
	end)

	local var3_13 = arg0_13.showTaskDict[var0_13] and arg0_13.showTaskDict[var0_13] or {}

	var2_13:align(#var3_13)
end

function var0_0.UpdateTaskItem(arg0_15, arg1_15, arg2_15)
	arg1_15.name = arg2_15.id

	local var0_15 = arg2_15:GetShowType()

	setImageColor(arg1_15:Find("main/line"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_15]))

	local var1_15 = arg2_15:IsSeries()

	setText(arg1_15:Find("main/name"), var1_15 and arg2_15:GetSeriesTitle() or arg2_15:GetName())
	setActive(arg1_15:Find("sub"), var1_15)
	setActive(arg1_15:Find("main/location"), not var1_15)

	if var1_15 then
		local var2_15 = IslandTaskType.ShowTypeFields[var0_15]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "color_" .. var2_15, arg1_15:Find("sub/bg"))
		setText(arg1_15:Find("sub/name"), arg2_15:GetName())
		arg0_15:UpdateLocation(arg1_15:Find("sub/location"), arg2_15)
	else
		arg0_15:UpdateLocation(arg1_15:Find("main/location"), arg2_15)
	end

	onToggle(arg0_15, arg1_15, function(arg0_16)
		setActive(arg1_15:Find("main/selected"), arg0_16 and not var1_15)
		setActive(arg1_15:Find("sub/selected"), arg0_16 and var1_15)

		if arg0_16 and (not arg0_15.selectedTaskId or arg0_15.selectedTaskId ~= arg2_15.id or arg0_15.isOpen) then
			arg0_15.selectedTaskId = arg2_15.id

			arg0_15:FlushDetail()

			arg0_15.isOpen = false
		end
	end, SFX_PANEL)
end

function var0_0.UpdateLocation(arg0_17, arg1_17, arg2_17)
	setActive(arg1_17, arg2_17.id == arg0_17.trackTaskId)

	if arg2_17.id == arg0_17.trackTaskId then
		local var0_17 = arg2_17:GetTraceParam()
		local var1_17 = tonumber(var0_17)

		setActive(arg1_17, var1_17)

		if var1_17 then
			local var2_17 = pg.island_world_objects[var1_17].mapId
			local var3_17 = var2_17 == arg0_17.curMapId and arg0_17:CalcDistance(var1_17) .. "m" or pg.island_map[var2_17].name

			setText(arg1_17:Find("Text"), var3_17)
		end
	end
end

function var0_0.CalcDistance(arg0_18, arg1_18)
	local var0_18 = _IslandCore:GetView():GetPlayerPosition()
	local var1_18 = _IslandCore:GetView():GetUnitPosition(arg1_18) or var0_18
	local var2_18 = Vector3.Distance(var0_18, var1_18)

	return math.ceil(var2_18)
end

function var0_0.UpdateTargetItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.showTargets[arg1_19 + 1]

	setText(arg2_19:Find("content/Text"), var0_19:getConfig("name"))

	local var1_19 = var0_19:GetProgress()
	local var2_19 = var0_19:GetTargetNum()

	setText(arg2_19:Find("content/num"), string.format("(%d/%d)", var1_19, var2_19))

	local var3_19 = var0_19:IsFinish()

	setActive(arg2_19:Find("status/unfinish"), not var3_19)
	setActive(arg2_19:Find("status/finished"), var3_19)

	local var4_19, var5_19 = arg0_19.showVO:GetTraceParam()
	local var6_19 = arg2_19:Find("content/location")
	local var7_19 = var5_19 and var5_19 == arg1_19 + 1

	setActive(var6_19, var7_19)

	if var7_19 then
		arg0_19:UpdateLocation(var6_19, arg0_19.showVO)
	end
end

function var0_0.Flush(arg0_20)
	if not arg0_20.selectedType then
		arg0_20.selectedType = IslandTaskType.SHOW_ALL
	end

	local var0_20 = getProxy(IslandProxy):GetIsland()

	arg0_20.curMapId = var0_20:GetMapId()
	arg0_20.taskAgency = var0_20:GetTaskAgency()
	arg0_20.trackTaskId = arg0_20.taskAgency:GetTraceId()

	local var1_20 = arg0_20.taskAgency:GetShowTasks()

	arg0_20.showTaskDict = {}

	for iter0_20, iter1_20 in pairs(var1_20) do
		local var2_20 = iter1_20:GetShowType()

		if var2_20 then
			if not arg0_20.showTaskDict[var2_20] then
				arg0_20.showTaskDict[var2_20] = {}
			end

			table.insert(arg0_20.showTaskDict[var2_20], iter1_20)
		end
	end

	arg0_20.showTypeList = {
		arg0_20.selectedType
	}

	if arg0_20.selectedType == IslandTaskType.SHOW_ALL then
		arg0_20.showTypeList = arg0_20:GetShowTypeList()
	end

	table.sort(arg0_20.showTypeList)
	arg0_20.typeUIList:align(#arg0_20.showTypeList)
	arg0_20:PingFirstTask()
end

function var0_0.FlushTypeUIList(arg0_21)
	arg0_21.typeUIList:align(#arg0_21.showTypeList)

	local var0_21 = {}

	arg0_21.typeUIList:eachActive(function(arg0_22, arg1_22)
		arg1_22:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_21, function(arg0_23)
			arg1_22:GetComponent(typeof(Animation)):Play()

			arg1_22:GetComponent(typeof(CanvasGroup)).alpha = 1

			arg0_21:managedTween(LeanTween.delayedCall, function()
				arg0_23()
			end, 0.06, nil)
		end)
	end)
	seriesAsync(var0_21)
end

function var0_0.PingFirstTask(arg0_25)
	local var0_25 = underscore.detect(arg0_25.showTypeList, function(arg0_26)
		return arg0_25.showTaskDict[arg0_26] and #arg0_25.showTaskDict[arg0_26] > 0
	end)

	if var0_25 then
		triggerToggle(arg0_25.typeUIList.container:Find(var0_25 .. "/list"):GetChild(0), true)
	else
		arg0_25.selectedTaskId = nil

		arg0_25:FlushDetail()
	end
end

function var0_0.FlushDetail(arg0_27)
	arg0_27.trackTaskId = arg0_27.taskAgency:GetTraceId()

	setActive(arg0_27.detailTF, arg0_27.selectedTaskId)
	setActive(arg0_27.emptyTF, not arg0_27.selectedTaskId)

	arg0_27.showVO = arg0_27.taskAgency:GetTask(arg0_27.selectedTaskId)

	if arg0_27.selectedTaskId and arg0_27.showVO then
		arg0_27.detailAnim:Play()

		local var0_27 = arg0_27.showVO:GetShowType()
		local var1_27 = IslandTaskType.ShowTypeFields[var0_27]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_bg_" .. var1_27, arg0_27.titleBg)
		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_icon_" .. var1_27, arg0_27.typeIcon)
		setText(arg0_27.nameTF, arg0_27.showVO:GetName())
		setActive(arg0_27.timeTF, var0_27 == IslandTaskType.SHOW_ACTIVITY)

		if var0_27 == IslandTaskType.SHOW_ACTIVITY then
			setText(arg0_27.timeTF:Find("Text"), arg0_27.showVO:GetRemainTimeStr())
		end

		setText(arg0_27.descTF, arg0_27.showVO:GetDesc())

		arg0_27.showTargets = arg0_27.showVO:GetTargetList()

		local var2_27 = not arg0_27.showVO:IsSubmitImmediately() and arg0_27.showVO:IsFinish()

		arg0_27.targetUIList:align(#arg0_27.showTargets)
		setActive(arg0_27.finishedTargetTF, var2_27)

		if var2_27 then
			setText(arg0_27.finishedTargetTextTF, arg0_27.showVO:GetFinishedDesc())
			arg0_27:UpdateLocation(arg0_27.finishedTargetLocTF, arg0_27.showVO)
		end

		arg0_27.showAwards = arg0_27.showVO:GetAwards()

		arg0_27.awardUIList:align(#arg0_27.showAwards)
		setActive(arg0_27.traceBtn, arg0_27.showVO.id ~= arg0_27.trackTaskId)
		onButton(arg0_27, arg0_27.traceBtn, function()
			arg0_27:emit(IslandMediator.ON_SET_TRACE_ID, arg0_27.showVO.id)
		end, SFX_PANEL)
		setActive(arg0_27.tracedBtn, arg0_27.showVO.id == arg0_27.trackTaskId)
		onButton(arg0_27, arg0_27.tracedBtn, function()
			arg0_27:emit(IslandMediator.ON_SET_TRACE_ID, 0)
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_30, arg1_30, arg2_30)
	arg0_30.isOpen = true
	arg0_30.toggleList = arg0_30:GetShowTypeList()

	table.insert(arg0_30.toggleList, 1, IslandTaskType.SHOW_ALL)
	arg0_30.toggleUIList:align(#arg0_30.toggleList)
	arg0_30:Flush()

	local var0_30 = false

	if arg1_30 and arg0_30.toggleUIList.container:Find(arg1_30) then
		triggerToggle(arg0_30.toggleUIList.container:Find(arg1_30), true)

		var0_30 = true
	end

	if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg2_30 or 0) then
		if not var0_30 then
			triggerToggle(arg0_30.toggleUIList.container:GetChild(0), true)
		end

		local var1_30 = IslandTaskType.Type2ShowType[pg.island_task[arg2_30].type]

		triggerToggle(arg0_30.typeUIList.container:Find(var1_30 .. "/list/" .. arg2_30), true)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_30._tf)
end

function var0_0.GetShowTypeList(arg0_31)
	local var0_31 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_31 = underscore.select(underscore.keys(IslandTaskType.ShowTypeUnlockId), function(arg0_32)
		return var0_31:HasAbility(IslandTaskType.ShowTypeUnlockId[arg0_32])
	end)

	table.sort(var1_31)

	return var1_31
end

function var0_0.OnHide(arg0_33)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_33._tf)
end

function var0_0.OnDisable(arg0_34)
	arg0_34:OnHide()
end

function var0_0.OnDestroy(arg0_35)
	arg0_35:OnHide()
end

return var0_0
