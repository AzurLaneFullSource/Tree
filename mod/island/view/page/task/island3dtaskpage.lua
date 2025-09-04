local var0_0 = class("Island3dTaskPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.uiAnimEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.uiAnimEvent:SetEndEvent(function()
		arg0_2.playingHideAnim = false

		var0_0.super.Hide(arg0_2)
	end)

	local var0_2 = arg0_2._tf:Find("toggles/content")

	arg0_2.toggleUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("types/content")

	arg0_2.typeUIList = UIItemList.New(var1_2, var1_2:Find("type_tpl"))
	arg0_2.detailAnim = arg0_2._tf:Find("detail"):GetComponent(typeof(Animation))
	arg0_2.emptyTF = arg0_2._tf:Find("detail/empty")
	arg0_2.detailTF = arg0_2._tf:Find("detail/content")
	arg0_2.titleBg = arg0_2.detailTF:Find("title")
	arg0_2.typeIcon = arg0_2.detailTF:Find("title/icon")
	arg0_2.nameTF = arg0_2.detailTF:Find("title/icon/name")
	arg0_2.timeTF = arg0_2.detailTF:Find("title/time")
	arg0_2.descTF = arg0_2.detailTF:Find("desc")
	arg0_2.targetTF = arg0_2.detailTF:Find("targets")

	setText(arg0_2.targetTF:Find("Text"), i18n("island_task_target"))

	arg0_2.finishedTargetTF = arg0_2.targetTF:Find("finished")
	arg0_2.finishedTargetTextTF = arg0_2.finishedTargetTF:Find("Text")
	arg0_2.finishedTargetLocTF = arg0_2.finishedTargetTF:Find("location")
	arg0_2.targetContent = arg0_2.targetTF:Find("content")
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
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("top/back"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("top/home"), function()
		arg0_4:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_4.toggleUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			arg0_4:InitToggleItem(arg1_7, arg2_7)
		end
	end)

	arg0_4.toggleList = underscore.keys(IslandTaskType.ShowTypeNames)

	table.sort(arg0_4.toggleList)
	arg0_4.toggleUIList:align(#arg0_4.toggleList)
	arg0_4.typeUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_4:UpdateTypeItem(arg1_8, arg2_8)
		end
	end)
	arg0_4.targetUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_4:UpdateTargetItem(arg1_9, arg2_9)
		end
	end)
	arg0_4.awardUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_4.showAwards[arg1_10 + 1]

			updateCustomDrop(arg2_10, var0_10)
		end
	end)
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_11.FlushDetail)
	arg0_11:AddListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_11.Flush)
	arg0_11:AddListener(IslandTaskAgency.TASK_ADDED, arg0_11.Flush)
	arg0_11:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_11.Flush)
	arg0_11:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_11.Flush)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_12.FlushDetail)
	arg0_12:RemoveListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_12.Flush)
	arg0_12:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_12.Flush)
	arg0_12:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_12.Flush)
end

function var0_0.InitToggleItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.toggleList[arg1_13 + 1]

	arg2_13.name = var0_13

	local var1_13 = IslandTaskType.ShowTypeNames[var0_13]

	setText(arg2_13:Find("unsel"), var1_13)
	setText(arg2_13:Find("sel/content/Text"), var1_13)

	if var0_13 ~= IslandTaskType.SHOW_ALL then
		LoadImageSpriteAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_13], arg2_13:Find("sel/content/Image"), false)
	end

	onToggle(arg0_13, arg2_13, function(arg0_14)
		arg0_13.selectedType = var0_13

		arg0_13:Flush()

		if arg0_14 then
			arg2_13:GetComponent(typeof(Animation)):Play()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.showTypeList[arg1_15 + 1]

	arg2_15.name = var0_15

	local var1_15 = IslandTaskType.ShowTypeNames[var0_15]

	setText(arg2_15:Find("title/Text"), var1_15)
	setImageColor(arg2_15:Find("title"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_15]))
	LoadImageSpriteAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_15], arg2_15:Find("title/Image"))
	setActive(arg2_15:Find("line"), arg1_15 + 1 ~= #arg0_15.showTypeList)

	local var2_15 = UIItemList.New(arg2_15:Find("list"), arg2_15:Find("list"):GetChild(0))

	var2_15:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg0_15.showTaskDict[var0_15][arg1_16 + 1]

			arg0_15:UpdateTaskItem(arg2_16, var0_16)
		end
	end)

	local var3_15 = arg0_15.showTaskDict[var0_15] and arg0_15.showTaskDict[var0_15] or {}

	var2_15:align(#var3_15)
end

function var0_0.UpdateTaskItem(arg0_17, arg1_17, arg2_17)
	arg1_17.name = arg2_17.id

	local var0_17 = arg2_17:GetShowType()

	setImageColor(arg1_17:Find("main/line"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_17]))

	local var1_17 = arg2_17:IsSeries()

	setText(arg1_17:Find("main/name"), var1_17 and arg2_17:GetSeriesTitle() or arg2_17:GetName())
	setActive(arg1_17:Find("sub"), var1_17)
	setActive(arg1_17:Find("main/location"), not var1_17)

	if var1_17 then
		local var2_17 = IslandTaskType.ShowTypeFields[var0_17]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "color_" .. var2_17, arg1_17:Find("sub/bg"))
		setText(arg1_17:Find("sub/name"), arg2_17:GetName())
		arg0_17:UpdateLocation(arg1_17:Find("sub/location"), arg2_17)
	else
		arg0_17:UpdateLocation(arg1_17:Find("main/location"), arg2_17)
	end

	onToggle(arg0_17, arg1_17, function(arg0_18)
		arg0_17.selectedTaskId = arg2_17.id

		setActive(arg1_17:Find("main/selected"), arg0_18 and not var1_17)
		setActive(arg1_17:Find("sub/selected"), arg0_18 and var1_17)
		arg0_17:FlushDetail()
	end, SFX_PANEL)
end

function var0_0.UpdateLocation(arg0_19, arg1_19, arg2_19)
	setActive(arg1_19, arg2_19.id == arg0_19.trackTaskId)

	if arg2_19.id == arg0_19.trackTaskId then
		local var0_19 = arg2_19:GetTraceParam()
		local var1_19 = tonumber(var0_19)

		setActive(arg1_19, var1_19)

		if var1_19 then
			local var2_19 = pg.island_world_objects[var1_19].mapId
			local var3_19 = var2_19 == arg0_19.curMapId and arg0_19:CalcDistance(var1_19) .. "m" or pg.island_map[var2_19].name

			setText(arg1_19:Find("Text"), var3_19)
		end
	end
end

function var0_0.CalcDistance(arg0_20, arg1_20)
	local var0_20 = _IslandCore:GetView():GetPlayerPosition()
	local var1_20 = _IslandCore:GetView():GetUnitPosition(arg1_20) or var0_20
	local var2_20 = Vector3.Distance(var0_20, var1_20)

	return math.ceil(var2_20)
end

function var0_0.UpdateTargetItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.showTargets[arg1_21 + 1]

	setText(arg2_21:Find("content/Text"), var0_21:getConfig("name"))

	local var1_21 = var0_21:GetProgress()
	local var2_21 = var0_21:GetTargetNum()

	setText(arg2_21:Find("content/num"), string.format("(%d/%d)", var1_21, var2_21))

	local var3_21 = var0_21:IsFinish()

	setActive(arg2_21:Find("status/unfinish"), not var3_21)
	setActive(arg2_21:Find("status/finished"), var3_21)

	local var4_21, var5_21 = arg0_21.showVO:GetTraceParam()
	local var6_21 = arg2_21:Find("content/location")
	local var7_21 = var5_21 and var5_21 == arg1_21 + 1

	setActive(var6_21, var7_21)

	if var7_21 then
		arg0_21:UpdateLocation(var6_21, arg0_21.showVO)
	end
end

function var0_0.Flush(arg0_22)
	if not arg0_22.selectedType then
		arg0_22.selectedType = IslandTaskType.SHOW_ALL
	end

	local var0_22 = getProxy(IslandProxy):GetIsland()

	arg0_22.curMapId = var0_22:GetMapId()
	arg0_22.taskAgency = var0_22:GetTaskAgency()
	arg0_22.trackTaskId = arg0_22.taskAgency:GetTraceId()

	local var1_22 = arg0_22.taskAgency:GetShowTasks()

	arg0_22.showTaskDict = {}

	for iter0_22, iter1_22 in pairs(var1_22) do
		local var2_22 = iter1_22:GetShowType()

		if var2_22 then
			if not arg0_22.showTaskDict[var2_22] then
				arg0_22.showTaskDict[var2_22] = {}
			end

			table.insert(arg0_22.showTaskDict[var2_22], iter1_22)
		end
	end

	arg0_22.showTypeList = {
		arg0_22.selectedType
	}

	if arg0_22.selectedType == IslandTaskType.SHOW_ALL then
		arg0_22.showTypeList = underscore.keys(IslandTaskType.ShowTypeFields)
	end

	table.sort(arg0_22.showTypeList)
	arg0_22:FlushTypeUIList()
	arg0_22:PingFirstTask()
end

function var0_0.FlushTypeUIList(arg0_23)
	arg0_23.typeUIList:align(#arg0_23.showTypeList)

	local var0_23 = {}

	arg0_23.typeUIList:eachActive(function(arg0_24, arg1_24)
		arg1_24:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_23, function(arg0_25)
			arg1_24:GetComponent(typeof(Animation)):Play()

			arg1_24:GetComponent(typeof(CanvasGroup)).alpha = 1

			arg0_23:managedTween(LeanTween.delayedCall, function()
				arg0_25()
			end, 0.06, nil)
		end)
	end)
	seriesAsync(var0_23)
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
	arg0_29.trackTaskId = arg0_29.taskAgency:GetTraceId()

	setActive(arg0_29.detailTF, arg0_29.selectedTaskId)
	setActive(arg0_29.emptyTF, not arg0_29.selectedTaskId)

	if arg0_29.selectedTaskId then
		arg0_29.detailAnim:Play()

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
			setText(arg0_29.finishedTargetTextTF, arg0_29.showVO:GetFinishedDesc())
			arg0_29:UpdateLocation(arg0_29.finishedTargetLocTF, arg0_29.showVO)
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
	end
end

function var0_0.OnShow(arg0_32, arg1_32, arg2_32)
	local var0_32 = false

	if arg1_32 and arg0_32.toggleUIList.container:Find(arg1_32) then
		triggerToggle(arg0_32.toggleUIList.container:Find(arg1_32), true)

		var0_32 = true
	end

	if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg2_32 or 0) then
		if not var0_32 then
			triggerToggle(arg0_32.toggleUIList.container:GetChild(0), true)
		end

		local var1_32 = IslandTaskType.Type2ShowType[pg.island_task[arg2_32].type]

		triggerToggle(arg0_32.typeUIList.container:Find(var1_32 .. "/list/" .. arg2_32), true)
	else
		arg0_32:Flush()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_32._tf)
end

function var0_0.Hide(arg0_33)
	if arg0_33.playingHideAnim then
		return
	end

	arg0_33.uiAnim:Play("Anim_Island3dTaskUI_out")

	arg0_33.playingHideAnim = true
end

function var0_0.OnHide(arg0_34)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_34._tf)
end

function var0_0.OnDisable(arg0_35)
	arg0_35:OnHide()
end

function var0_0.OnDestroy(arg0_36)
	arg0_36.uiAnimEvent:SetEndEvent(nil)
end

return var0_0
