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
	arg0_2.targetBtnUIList = UIItemList.New(arg0_2.detailTF:Find("view/Viewport/btns"), arg0_2.detailTF:Find("view/Viewport/btns/tpl"))
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

	arg0_2.richtext = arg0_2.descTF:GetComponent("RichText")
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
	arg0_3.targetBtnUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_3:UpdateTargetBtnItem(arg1_8, arg2_8)
		end
	end)
	arg0_3.awardUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_3.showAwards[arg1_9 + 1]

			updateCustomDrop(arg2_9, var0_9)
			onButton(arg0_3, arg2_9, function()
				arg0_3:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var0_9
				})
			end)
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
		if arg0_14 and (not arg0_13.selectedType or arg0_13.selectedType ~= var0_13) then
			arg0_13.selectedType = var0_13

			arg0_13:Flush()
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
		setActive(arg1_17:Find("main/selected"), arg0_18 and not var1_17)
		setActive(arg1_17:Find("sub/selected"), arg0_18 and var1_17)

		if arg0_18 and (not arg0_17.selectedTaskId or arg0_17.selectedTaskId ~= arg2_17.id or arg0_17.isOpen) then
			arg0_17.selectedTaskId = arg2_17.id

			arg0_17:FlushDetail()

			arg0_17.isOpen = false
		end
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

	setText(arg2_21:Find("content/num"), "(" .. (var1_21 < var2_21 and setColorStr(var1_21, "#dd374e") or var1_21) .. "/" .. var2_21 .. ")")

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

function var0_0._SkipBtn(arg0_22, arg1_22)
	local var0_22 = pg.island_main_btns[arg1_22]

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_22.ability_id) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_taskjump_systemnoopen_tips"))

		return
	end

	if var0_22.open_page ~= "" then
		arg0_22:Hide()
		arg0_22:emit(IslandMediator.OPEN_PAGE, var0_22.open_page, var0_22.page_param)
	end
end

function var0_0._SkipObj(arg0_23, arg1_23)
	local var0_23 = pg.island_world_objects[arg1_23].mapId

	if not getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockMap(var0_23) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_taskjump_placenoopen_tips"))

		return
	end

	arg0_23:Hide(false)
	arg0_23:emit(IslandBaseMediator.SWITCH_MAP, var0_23, pg.island_map[var0_23].born_object)
end

function var0_0.UpdateTargetBtnItem(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.showTargets[arg1_24 + 1]
	local var1_24 = arg2_24:Find("btn")

	removeOnButton(var1_24)
	setActive(var1_24, false)

	if var0_24 then
		local var2_24 = pg.island_task_target[var0_24.id]
		local var3_24 = tonumber(var2_24.tips)
		local var4_24 = tonumber(var2_24.jump_ui)

		if not var0_24:IsFinish() then
			if var4_24 then
				setActive(var1_24, true)
				onButton(arg0_24, var1_24, function()
					arg0_24:_SkipBtn(var4_24)
				end, SFX_PANEL)
			elseif var3_24 then
				local var5_24 = pg.island_world_objects[var3_24].mapId

				if IslandMainBtnTipHelper.IsUnlock("map") and arg0_24.curMapId ~= var5_24 then
					setActive(var1_24, true)
					onButton(arg0_24, var1_24, function()
						arg0_24:_SkipObj(var3_24)
					end, SFX_PANEL)
				end
			end
		end
	else
		setActive(var1_24, false)

		local var6_24 = tonumber(arg0_24.showVO:getConfig("complete_data"))

		if var6_24 and var6_24 ~= 0 then
			local var7_24 = pg.island_world_objects[var6_24].mapId

			if IslandMainBtnTipHelper.IsUnlock("map") and arg0_24.curMapId ~= var7_24 then
				setActive(var1_24, true)
				onButton(arg0_24, var1_24, function()
					arg0_24:_SkipObj(var6_24)
				end, SFX_PANEL)
			end
		end
	end
end

function var0_0.Flush(arg0_28)
	if not arg0_28.selectedType then
		arg0_28.selectedType = IslandTaskType.SHOW_ALL
	end

	local var0_28 = getProxy(IslandProxy):GetIsland()

	arg0_28.curMapId = var0_28:GetMapId()
	arg0_28.taskAgency = var0_28:GetTaskAgency()
	arg0_28.trackTaskId = arg0_28.taskAgency:GetTraceId()

	local var1_28 = arg0_28.taskAgency:GetShowTasks()

	arg0_28.showTaskDict = {}

	for iter0_28, iter1_28 in pairs(var1_28) do
		local var2_28 = iter1_28:GetShowType()

		if var2_28 then
			if not arg0_28.showTaskDict[var2_28] then
				arg0_28.showTaskDict[var2_28] = {}
			end

			table.insert(arg0_28.showTaskDict[var2_28], iter1_28)
		end
	end

	arg0_28.showTypeList = {
		arg0_28.selectedType
	}

	if arg0_28.selectedType == IslandTaskType.SHOW_ALL then
		arg0_28.showTypeList = arg0_28:GetShowTypeList()
	end

	table.sort(arg0_28.showTypeList)
	arg0_28.typeUIList:align(#arg0_28.showTypeList)
	arg0_28:PingFirstTask()
end

function var0_0.FlushTypeUIList(arg0_29)
	arg0_29.typeUIList:align(#arg0_29.showTypeList)

	local var0_29 = {}

	arg0_29.typeUIList:eachActive(function(arg0_30, arg1_30)
		arg1_30:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_29, function(arg0_31)
			arg1_30:GetComponent(typeof(Animation)):Play()

			arg1_30:GetComponent(typeof(CanvasGroup)).alpha = 1

			arg0_29:managedTween(LeanTween.delayedCall, function()
				arg0_31()
			end, 0.06, nil)
		end)
	end)
	seriesAsync(var0_29)
end

function var0_0.PingFirstTask(arg0_33)
	local var0_33 = underscore.detect(arg0_33.showTypeList, function(arg0_34)
		return arg0_33.showTaskDict[arg0_34] and #arg0_33.showTaskDict[arg0_34] > 0
	end)

	if var0_33 then
		triggerToggle(arg0_33.typeUIList.container:Find(var0_33 .. "/list"):GetChild(0), true)
	else
		arg0_33.selectedTaskId = nil

		arg0_33:FlushDetail()
	end
end

function var0_0.FlushDetail(arg0_35)
	arg0_35.trackTaskId = arg0_35.taskAgency:GetTraceId()

	setActive(arg0_35.detailTF, arg0_35.selectedTaskId)
	setActive(arg0_35.emptyTF, not arg0_35.selectedTaskId)

	arg0_35.showVO = arg0_35.taskAgency:GetTask(arg0_35.selectedTaskId)

	if arg0_35.selectedTaskId and arg0_35.showVO then
		arg0_35.detailAnim:Play()

		local var0_35 = arg0_35.showVO:GetShowType()
		local var1_35 = IslandTaskType.ShowTypeFields[var0_35]

		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_bg_" .. var1_35, arg0_35.titleBg)
		LoadImageSpriteAtlasAsync("ui/island3dtaskui_atlas", "title_icon_" .. var1_35, arg0_35.typeIcon)
		setText(arg0_35.nameTF, arg0_35.showVO:GetName())
		setActive(arg0_35.timeTF, var0_35 == IslandTaskType.SHOW_ACTIVITY)

		if var0_35 == IslandTaskType.SHOW_ACTIVITY then
			setText(arg0_35.timeTF:Find("Text"), arg0_35.showVO:GetRemainTimeStr())
		end

		arg0_35.richtext.text = arg0_35.showVO:GetDesc()

		arg0_35.richtext:RemoveAllListeners()
		arg0_35.richtext:AddListener(function(arg0_36, arg1_36)
			if arg0_36 == "dropDesHandle" then
				local var0_36, var1_36 = string.match(arg1_36, "{(%d+),(%d+)}")
				local var2_36 = Drop.New({
					count = 0,
					type = tonumber(var0_36),
					id = tonumber(var1_36)
				})

				arg0_35:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var2_36
				})
			end
		end)

		arg0_35.showTargets = arg0_35.showVO:GetTargetList()

		local var2_35 = not arg0_35.showVO:IsSubmitImmediately() and arg0_35.showVO:IsFinish()

		arg0_35.targetUIList:align(#arg0_35.showTargets)
		setActive(arg0_35.finishedTargetTF, var2_35)

		if var2_35 then
			setText(arg0_35.finishedTargetTextTF, arg0_35.showVO:GetFinishedDesc())
			arg0_35:UpdateLocation(arg0_35.finishedTargetLocTF, arg0_35.showVO)
		end

		arg0_35.targetBtnUIList:align(#arg0_35.showTargets + (var2_35 and 1 or 0))

		arg0_35.showAwards = arg0_35.showVO:GetAwards()

		arg0_35.awardUIList:align(#arg0_35.showAwards)

		local var3_35 = arg0_35.showVO:GetType() == IslandTaskType.MAIN
		local var4_35 = var3_35 and IslandTaskTrackCard.TYPES.MAIN or IslandTaskTrackCard.TYPES.OTHER

		setActive(arg0_35.traceBtn, not var3_35 and arg0_35.showVO.id ~= arg0_35.trackTaskId)
		onButton(arg0_35, arg0_35.traceBtn, function()
			arg0_35:emit(IslandMediator.ON_SET_TRACE_ID, arg0_35.showVO.id, var4_35)
		end, SFX_PANEL)
		setActive(arg0_35.tracedBtn, var3_35 or arg0_35.showVO.id == arg0_35.trackTaskId)
		onButton(arg0_35, arg0_35.tracedBtn, function()
			if var3_35 then
				return
			end

			arg0_35:emit(IslandMediator.ON_SET_TRACE_ID, 0, var4_35)
		end, SFX_PANEL)
	end
end

function var0_0.OnShow(arg0_39, arg1_39, arg2_39)
	arg0_39.isOpen = true
	arg0_39.toggleList = arg0_39:GetShowTypeList()

	table.insert(arg0_39.toggleList, 1, IslandTaskType.SHOW_ALL)
	arg0_39.toggleUIList:align(#arg0_39.toggleList)
	arg0_39:Flush()

	local var0_39 = false

	if arg1_39 and arg0_39.toggleUIList.container:Find(arg1_39) then
		triggerToggle(arg0_39.toggleUIList.container:Find(arg1_39), true)

		var0_39 = true
	end

	if getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg2_39 or 0) then
		if not var0_39 then
			triggerToggle(arg0_39.toggleUIList.container:GetChild(0), true)
		end

		local var1_39 = IslandTaskType.Type2ShowType[pg.island_task[arg2_39].type]

		triggerToggle(arg0_39.typeUIList.container:Find(var1_39 .. "/list/" .. arg2_39), true)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_39._tf)
end

function var0_0.GetShowTypeList(arg0_40)
	local var0_40 = getProxy(IslandProxy):GetIsland():GetAblityAgency()
	local var1_40 = underscore.select(underscore.keys(IslandTaskType.ShowTypeUnlockId), function(arg0_41)
		return var0_40:HasAbility(IslandTaskType.ShowTypeUnlockId[arg0_41])
	end)

	table.sort(var1_40)

	return var1_40
end

function var0_0.OnHide(arg0_42)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_42._tf)
end

function var0_0.OnDisable(arg0_43)
	arg0_43:OnHide()
end

function var0_0.OnDestroy(arg0_44)
	arg0_44.richtext:RemoveAllListeners()
	arg0_44:OnHide()
end

return var0_0
