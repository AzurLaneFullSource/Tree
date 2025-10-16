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
	arg0_2.descTF = arg0_2.detailTF:Find("view/Viewport/content/desc")
	arg0_2.targetTF = arg0_2.detailTF:Find("view/Viewport/content/targets")

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
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_task_title"))
	setText(arg0_2._tf:Find("top/title/Text/en"), i18n("island_task_title_en"))
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
			onButton(arg0_3, arg2_8, function()
				arg0_3:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var0_8
				})
			end)
		end
	end)
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_10.FlushDetail)
	arg0_10:AddListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_10.Flush)
	arg0_10:AddListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_10.Flush)
	arg0_10:AddListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_10.Flush)
	arg0_10:AddListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_10.Flush)
	arg0_10:AddListener(IslandTaskAgency.TASK_ADDED, arg0_10.Flush)
	arg0_10:AddListener(IslandTaskAgency.TASK_UPDATED, arg0_10.Flush)
	arg0_10:AddListener(IslandTaskAgency.TASK_REMOVED, arg0_10.Flush)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLAND_SET_TRACE_TASK_DONE, arg0_11.FlushDetail)
	arg0_11:RemoveListener(GAME.ISLAND_ACCEPT_TASK_DONE, arg0_11.Flush)
	arg0_11:RemoveListener(GAME.ISLAND_SUBMIT_TASK_DONE, arg0_11.Flush)
	arg0_11:RemoveListener(GAME.ISLAND_UPDATE_TASK_DONE, arg0_11.Flush)
	arg0_11:RemoveListener(GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE, arg0_11.Flush)
	arg0_11:RemoveListener(IslandTaskAgency.TASK_ADDED, arg0_11.Flush)
	arg0_11:RemoveListener(IslandTaskAgency.TASK_UPDATED, arg0_11.Flush)
	arg0_11:RemoveListener(IslandTaskAgency.TASK_REMOVED, arg0_11.Flush)
end

function var0_0.InitToggleItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.toggleList[arg1_12 + 1]

	arg2_12.name = var0_12

	local var1_12 = IslandTaskType.ShowTypeNames[var0_12]

	setText(arg2_12:Find("unsel"), var1_12)
	setText(arg2_12:Find("sel/content/Text"), var1_12)

	if var0_12 ~= IslandTaskType.SHOW_ALL then
		LoadImageSpriteAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_12], arg2_12:Find("sel/content/Image"), false)
	end

	onToggle(arg0_12, arg2_12, function(arg0_13)
		if arg0_13 and (not arg0_12.selectedType or arg0_12.selectedType ~= var0_12) then
			arg0_12.selectedType = var0_12

			arg0_12:Flush()
			arg2_12:GetComponent(typeof(Animation)):Play()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.showTypeList[arg1_14 + 1]

	arg2_14.name = var0_14

	local var1_14 = IslandTaskType.ShowTypeNames[var0_14]

	setText(arg2_14:Find("title/Text"), var1_14)
	setImageColor(arg2_14:Find("title"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_14]))
	LoadImageSpriteAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_14], arg2_14:Find("title/Image"))
	setActive(arg2_14:Find("line"), arg1_14 + 1 ~= #arg0_14.showTypeList)

	local var2_14 = UIItemList.New(arg2_14:Find("list"), arg2_14:Find("list"):GetChild(0))

	var2_14:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_14.showTaskDict[var0_14][arg1_15 + 1]

			arg0_14:UpdateTaskItem(arg2_15, var0_15)
		end
	end)

	local var3_14 = arg0_14.showTaskDict[var0_14] and arg0_14.showTaskDict[var0_14] or {}

	var2_14:align(#var3_14)
end

function var0_0.UpdateTaskItem(arg0_16, arg1_16, arg2_16)
	arg1_16.name = arg2_16.id

	local var0_16 = arg2_16:GetShowType()

	setImageColor(arg1_16:Find("main/line"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_16]))

	local var1_16 = arg2_16:IsSeries()

	setText(arg1_16:Find("main/name"), var1_16 and arg2_16:GetSeriesTitle() or arg2_16:GetName())
	setActive(arg1_16:Find("sub"), var1_16)
	setActive(arg1_16:Find("main/location"), not var1_16)

	if var1_16 then
		local var2_16 = IslandTaskType.ShowTypeFields[var0_16]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "color_" .. var2_16, arg1_16:Find("sub/bg"))
		setText(arg1_16:Find("sub/name"), arg2_16:GetName())
		arg0_16:UpdateLocation(arg1_16:Find("sub/location"), arg2_16)
	else
		arg0_16:UpdateLocation(arg1_16:Find("main/location"), arg2_16)
	end

	onToggle(arg0_16, arg1_16, function(arg0_17)
		setActive(arg1_16:Find("main/selected"), arg0_17 and not var1_16)
		setActive(arg1_16:Find("sub/selected"), arg0_17 and var1_16)

		if arg0_17 and (not arg0_16.selectedTaskId or arg0_16.selectedTaskId ~= arg2_16.id or arg0_16.isOpen) then
			arg0_16.selectedTaskId = arg2_16.id

			arg0_16:FlushDetail()

			arg0_16.isOpen = false
		end
	end, SFX_PANEL)
end

function var0_0.UpdateLocation(arg0_18, arg1_18, arg2_18)
	setActive(arg1_18, arg2_18.id == arg0_18.trackTaskId)

	if arg2_18.id == arg0_18.trackTaskId then
		local var0_18 = arg2_18:GetTraceParam()
		local var1_18 = tonumber(var0_18)

		setActive(arg1_18, var1_18)

		if var1_18 then
			local var2_18 = pg.island_world_objects[var1_18].mapId
			local var3_18 = var2_18 == arg0_18.curMapId and arg0_18:CalcDistance(var1_18) .. "m" or pg.island_map[var2_18].name

			setText(arg1_18:Find("Text"), var3_18)
		end
	end
end

function var0_0.CalcDistance(arg0_19, arg1_19)
	local var0_19 = _IslandCore:GetView():GetPlayerPosition()
	local var1_19 = _IslandCore:GetView():GetUnitPosition(arg1_19) or var0_19
	local var2_19 = Vector3.Distance(var0_19, var1_19)

	return math.ceil(var2_19)
end

function var0_0.UpdateTargetItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.showTargets[arg1_20 + 1]

	setText(arg2_20:Find("content/Text"), var0_20:getConfig("name"))

	local var1_20 = var0_20:GetProgress()
	local var2_20 = var0_20:GetTargetNum()

	setText(arg2_20:Find("content/num"), string.format("(%d/%d)", var1_20, var2_20))

	local var3_20 = var0_20:IsFinish()

	setActive(arg2_20:Find("status/unfinish"), not var3_20)
	setActive(arg2_20:Find("status/finished"), var3_20)

	local var4_20, var5_20 = arg0_20.showVO:GetTraceParam()
	local var6_20 = arg2_20:Find("content/location")
	local var7_20 = var5_20 and var5_20 == arg1_20 + 1

	setActive(var6_20, var7_20)

	if var7_20 then
		arg0_20:UpdateLocation(var6_20, arg0_20.showVO)
	end
end

function var0_0.Flush(arg0_21)
	if not arg0_21.selectedType then
		arg0_21.selectedType = IslandTaskType.SHOW_ALL
	end

	local var0_21 = getProxy(IslandProxy):GetIsland()

	arg0_21.curMapId = var0_21:GetMapId()
	arg0_21.taskAgency = var0_21:GetTaskAgency()
	arg0_21.trackTaskId = arg0_21.taskAgency:GetTraceId()

	local var1_21 = arg0_21.taskAgency:GetShowTasks()

	arg0_21.showTaskDict = {}

	for iter0_21, iter1_21 in pairs(var1_21) do
		local var2_21 = iter1_21:GetShowType()

		if var2_21 then
			if not arg0_21.showTaskDict[var2_21] then
				arg0_21.showTaskDict[var2_21] = {}
			end

			table.insert(arg0_21.showTaskDict[var2_21], iter1_21)
		end
	end

	arg0_21.showTypeList = {
		arg0_21.selectedType
	}

	if arg0_21.selectedType == IslandTaskType.SHOW_ALL then
		arg0_21.showTypeList = arg0_21:GetShowTypeList()
	end

	table.sort(arg0_21.showTypeList)
	arg0_21.typeUIList:align(#arg0_21.showTypeList)
	arg0_21:PingFirstTask()
end

function var0_0.FlushTypeUIList(arg0_22)
	arg0_22.typeUIList:align(#arg0_22.showTypeList)

	local var0_22 = {}

	arg0_22.typeUIList:eachActive(function(arg0_23, arg1_23)
		arg1_23:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_22, function(arg0_24)
			arg1_23:GetComponent(typeof(Animation)):Play()

			arg1_23:GetComponent(typeof(CanvasGroup)).alpha = 1

			arg0_22:managedTween(LeanTween.delayedCall, function()
				arg0_24()
			end, 0.06, nil)
		end)
	end)
	seriesAsync(var0_22)
end

function var0_0.PingFirstTask(arg0_26)
	local var0_26 = underscore.detect(arg0_26.showTypeList, function(arg0_27)
		return arg0_26.showTaskDict[arg0_27] and #arg0_26.showTaskDict[arg0_27] > 0
	end)

	if var0_26 then
		triggerToggle(arg0_26.typeUIList.container:Find(var0_26 .. "/list"):GetChild(0), true)
	else
		arg0_26.selectedTaskId = nil

		arg0_26:FlushDetail()
	end
end

function var0_0.FlushDetail(arg0_28)
	arg0_28.trackTaskId = arg0_28.taskAgency:GetTraceId()

	setActive(arg0_28.detailTF, arg0_28.selectedTaskId)
	setActive(arg0_28.emptyTF, not arg0_28.selectedTaskId)

	arg0_28.showVO = arg0_28.taskAgency:GetTask(arg0_28.selectedTaskId)

	if arg0_28.selectedTaskId and arg0_28.showVO then
		arg0_28.detailAnim:Play()

		local var0_28 = arg0_28.showVO:GetShowType()
		local var1_28 = IslandTaskType.ShowTypeFields[var0_28]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_bg_" .. var1_28, arg0_28.titleBg)
		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_icon_" .. var1_28, arg0_28.typeIcon)
		setText(arg0_28.nameTF, arg0_28.showVO:GetName())
		setActive(arg0_28.timeTF, var0_28 == IslandTaskType.SHOW_ACTIVITY)

		if var0_28 == IslandTaskType.SHOW_ACTIVITY then
			setText(arg0_28.timeTF:Find("Text"), arg0_28.showVO:GetRemainTimeStr())
		end

		setText(arg0_28.descTF, arg0_28.showVO:GetDesc())

		arg0_28.showTargets = arg0_28.showVO:GetTargetList()

		local var2_28 = not arg0_28.showVO:IsSubmitImmediately() and arg0_28.showVO:IsFinish()

		arg0_28.targetUIList:align(#arg0_28.showTargets)
		setActive(arg0_28.finishedTargetTF, var2_28)

		if var2_28 then
			setText(arg0_28.finishedTargetTextTF, arg0_28.showVO:GetFinishedDesc())
			arg0_28:UpdateLocation(arg0_28.finishedTargetLocTF, arg0_28.showVO)
		end

		arg0_28.showAwards = arg0_28.showVO:GetAwards()

		arg0_28.awardUIList:align(#arg0_28.showAwards)
		setActive(arg0_28.traceBtn, arg0_28.showVO.id ~= arg0_28.trackTaskId)
		onButton(arg0_28, arg0_28.traceBtn, function()
			arg0_28:emit(IslandMediator.ON_SET_TRACE_ID, arg0_28.showVO.id)
		end, SFX_PANEL)
		setActive(arg0_28.tracedBtn, arg0_28.showVO.id == arg0_28.trackTaskId)
		onButton(arg0_28, arg0_28.tracedBtn, function()
			arg0_28:emit(IslandMediator.ON_SET_TRACE_ID, 0)
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_31, arg1_31, arg2_31)
	arg0_31.isOpen = true
	arg0_31.toggleList = arg0_31:GetShowTypeList()

	table.insert(arg0_31.toggleList, 1, IslandTaskType.SHOW_ALL)
	arg0_31.toggleUIList:align(#arg0_31.toggleList)
	arg0_31:Flush()

	local var0_31 = false

	if arg1_31 and arg0_31.toggleUIList.container:Find(arg1_31) then
		triggerToggle(arg0_31.toggleUIList.container:Find(arg1_31), true)

		var0_31 = true
	end

	if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg2_31 or 0) then
		if not var0_31 then
			triggerToggle(arg0_31.toggleUIList.container:GetChild(0), true)
		end

		local var1_31 = IslandTaskType.Type2ShowType[pg.island_task[arg2_31].type]

		triggerToggle(arg0_31.typeUIList.container:Find(var1_31 .. "/list/" .. arg2_31), true)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_31._tf)
end

function var0_0.GetShowTypeList(arg0_32)
	local var0_32 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_32 = underscore.select(underscore.keys(IslandTaskType.ShowTypeUnlockId), function(arg0_33)
		return var0_32:HasAbility(IslandTaskType.ShowTypeUnlockId[arg0_33])
	end)

	table.sort(var1_32)

	return var1_32
end

function var0_0.OnHide(arg0_34)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_34._tf)
end

function var0_0.OnDisable(arg0_35)
	arg0_35:OnHide()
end

function var0_0.OnDestroy(arg0_36)
	arg0_36:OnHide()
end

return var0_0
