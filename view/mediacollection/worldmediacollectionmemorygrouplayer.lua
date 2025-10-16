local var0_0 = class("WorldMediaCollectionMemoryGroupLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionMemoryGroupUI"
end

var0_0.PAGE_ACTIVITY = 2
var0_0.FORM_MODE = 1
var0_0.LINE_MODE = -1

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2.memoryGroups = _.map(pg.memory_group.all, function(arg0_3)
		return pg.memory_group[arg0_3]
	end)
	arg0_2.memoryGroupList = arg0_2._tf:Find("GroupRect"):GetComponent("LScrollRect")

	function arg0_2.memoryGroupList.onInitItem(arg0_4)
		arg0_2:onInitMemoryGroup(arg0_4)
	end

	function arg0_2.memoryGroupList.onUpdateItem(arg0_5, arg1_5)
		arg0_2:onUpdateMemoryGroup(arg0_5 + 1, arg1_5)
	end

	arg0_2.memoryGroupInfos = {}

	local var0_2 = tf(arg0_2.memoryGroupList):Find("GroupItem")

	setActive(var0_2, false)

	arg0_2.memoryGroupViewport = tf(arg0_2.memoryGroupList):Find("Viewport")
	arg0_2.memoryGroupsGrid = tf(arg0_2.memoryGroupList):Find("Viewport/Content"):GetComponent(typeof(GridLayoutGroup))
	arg0_2.memoryTogGroup = arg0_2._tf:Find("Toggles")

	setActive(arg0_2.memoryTogGroup, true)

	arg0_2.memoryToggles = {}

	for iter0_2 = 0, 3 do
		arg0_2.memoryToggles[iter0_2 + 1] = arg0_2.memoryTogGroup:Find(iter0_2)
	end

	arg0_2.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0_2.groupToggle = arg0_2._tf:Find("ActivityToggle")
	arg0_2.memoryActivityTogGroup = arg0_2._tf:Find("ActivityToggle/ActivityBar")

	setActive(arg0_2.memoryActivityTogGroup, true)

	arg0_2.memoryActivityToggles = {}

	for iter1_2 = 0, 3 do
		arg0_2.memoryActivityToggles[iter1_2 + 1] = arg0_2.memoryActivityTogGroup:Find(iter1_2)
	end

	arg0_2.activityFilter = 0

	arg0_2:UpdateActivityBar()

	for iter2_2, iter3_2 in ipairs(arg0_2.memoryActivityToggles) do
		onButton(arg0_2, iter3_2, function()
			if iter2_2 == arg0_2.activityFilter then
				arg0_2.activityFilter = 0
			elseif iter2_2 ~= arg0_2.activityFilter then
				arg0_2.activityFilter = iter2_2
			end

			arg0_2:UpdateActivityBar()
			arg0_2:MemoryFilter()
		end, SFX_UI_TAG)
	end

	setText(arg0_2.memoryActivityToggles[1]:Find("Image1/Text"), i18n("memory_actiivty_ex"))
	setText(arg0_2.memoryActivityToggles[1]:Find("Image2/Text"), i18n("memory_actiivty_ex"))
	setText(arg0_2.memoryActivityToggles[2]:Find("Image1/Text"), i18n("memory_activity_sp"))
	setText(arg0_2.memoryActivityToggles[2]:Find("Image2/Text"), i18n("memory_activity_sp"))
	setText(arg0_2.memoryActivityToggles[3]:Find("Image1/Text"), i18n("memory_activity_daily"))
	setText(arg0_2.memoryActivityToggles[3]:Find("Image2/Text"), i18n("memory_activity_daily"))
	setText(arg0_2.memoryActivityToggles[4]:Find("Image1/Text"), i18n("memory_activity_others"))
	setText(arg0_2.memoryActivityToggles[4]:Find("Image2/Text"), i18n("memory_activity_others"))

	arg0_2.contextData.toggle = arg0_2.contextData.toggle or 1

	local var1_2 = arg0_2.contextData.toggle

	arg0_2.shipNameSearchFlag = true

	triggerToggle(arg0_2.memoryToggles[var1_2], true)
	arg0_2:SwitchMemoryFilter(var1_2)

	for iter4_2, iter5_2 in ipairs(arg0_2.memoryToggles) do
		onToggle(arg0_2, iter5_2, function(arg0_7)
			if not arg0_7 then
				return
			end

			if iter4_2 == 1 or iter4_2 == 4 then
				arg0_2.shipNameSearchFlag = true
			else
				arg0_2.shipNameSearchFlag = false
			end

			arg0_2:SwitchMemoryFilter(iter4_2)
			arg0_2:MemoryFilter()
		end, SFX_UI_TAG)
	end

	arg0_2:OverlayPanel(arg0_2.memoryTogGroup)

	arg0_2.loader = AutoLoader.New()
	arg0_2.searchBtn = arg0_2._tf:Find("ActivityToggle/search_btn/btn")
	arg0_2.nameSearchInput = arg0_2._tf:Find("ActivityToggle/search_btn/search")
	arg0_2.closeSearch = arg0_2._tf:Find("ActivityToggle/search_btn/icon")

	setText(arg0_2.searchBtn:Find("label"), i18n("storyline_memorysearch2"))
	onButton(arg0_2, arg0_2.searchBtn, function()
		setActive(arg0_2.nameSearchInput, true)
		setActive(arg0_2.searchBtn, false)
		setText(arg0_2.nameSearchInput:Find("holder"), i18n("storyline_memorysearch1"))

		arg0_2.searchOpen = true
	end)
	onButton(arg0_2, arg0_2.closeSearch, function()
		if arg0_2.searchOpen then
			setActive(arg0_2.nameSearchInput, false)
			setActive(arg0_2.searchBtn, true)
			setText(arg0_2.searchBtn:Find("label"), i18n("storyline_memorysearch2"))
		else
			triggerButton(arg0_2.searchBtn)
		end
	end)
	setInputText(arg0_2.nameSearchInput, "")
	onInputChanged(arg0_2, arg0_2.nameSearchInput, function()
		arg0_2:searchFilter()
	end)
	arg0_2:MemoryFilter()

	arg0_2.rectAnchorX = arg0_2._tf:Find("GroupRect").anchoredPosition.x

	arg0_2:UpdateView()

	arg0_2.storyLineBtn = arg0_2._tf:Find("StoryLineBtn")
	arg0_2.storyLineEntranceBtn = arg0_2._tf:Find("StoryLineBtn/entranceBtn")
	arg0_2.storyLineHideBtn = arg0_2._tf:Find("StoryLineBtn/closeBtn")
	arg0_2.currentMode = var0_0.FORM_MODE

	onButton(arg0_2, arg0_2.storyLineEntranceBtn, function()
		arg0_2:SwitchStoryLineMode(var0_0.LINE_MODE)
	end)
	onButton(arg0_2, arg0_2.storyLineHideBtn, function()
		arg0_2:StoryLineBtnSetActive(false)
	end)
	onButton(arg0_2, arg0_2.storyLineBtn, function()
		arg0_2:StoryLineBtnSetActive(true)
	end)

	arg0_2.storylineTF = arg0_2._tf:Find("StoryLine")
	arg0_2.storyLineView = WorldMediaCollectionStoryLineView.New(arg0_2.storylineTF)

	local function var2_2(arg0_14, arg1_14)
		arg0_2.viewParent:ShowSubMemories(arg0_14, true, arg1_14)
		var0_0.super.Hide(arg0_2)
	end

	local function var3_2(arg0_15, arg1_15, arg2_15)
		arg0_2.viewParent.viewParent:WarpToRecord(arg0_15, arg1_15, arg2_15)
	end

	arg0_2.storyLineView:ConfigCallback(var2_2, var3_2)
end

function var0_0.StoryLineBtnSetActive(arg0_16, arg1_16)
	setActive(arg0_16.storyLineEntranceBtn, arg1_16)
	setActive(arg0_16.storyLineHideBtn, arg1_16)
	setActive(arg0_16._tf:Find("StoryLineBtn/on"), not arg1_16)
end

function var0_0.SwitchStoryLineMode(arg0_17, arg1_17)
	arg0_17.currentMode = arg1_17

	if arg1_17 == var0_0.FORM_MODE then
		setActive(arg0_17._tf:Find("GroupRect"), true)
		setActive(arg0_17.memoryTogGroup, true)
		setActive(arg0_17.groupToggle, true)
		setActive(arg0_17.storylineTF, false)
		setActive(arg0_17.storyLineBtn, true)
		arg0_17.storyLineView:closeFilter()
		arg0_17:MemoryFilter()
		pg.BgmMgr.GetInstance():ContinuePlay()
	elseif arg1_17 == var0_0.LINE_MODE then
		setActive(arg0_17._tf:Find("GroupRect"), false)
		setActive(arg0_17.memoryTogGroup, false)
		setActive(arg0_17.groupToggle, false)
		setActive(arg0_17.storylineTF, true)
		setActive(arg0_17.storyLineBtn, false)
		arg0_17.storyLineView:refresh()
	end
end

function var0_0.Show(arg0_18)
	var0_0.super.Show(arg0_18)
	setActive(arg0_18.memoryTogGroup, arg0_18.currentMode == var0_0.FORM_MODE)
end

function var0_0.Hide(arg0_19)
	if arg0_19.currentMode == var0_0.FORM_MODE then
		setActive(arg0_19.memoryTogGroup, false)
		var0_0.super.Hide(arg0_19)
	else
		arg0_19:SwitchStoryLineMode(var0_0.FORM_MODE)
	end
end

function var0_0.GetCurrentMode(arg0_20)
	return arg0_20.currentMode
end

function var0_0.SwitchMemoryFilter(arg0_21, arg1_21)
	if arg1_21 == 1 then
		arg0_21.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0_21 in ipairs(arg0_21.memoryFilterIndex) do
			arg0_21.memoryFilterIndex[iter0_21] = arg1_21 - 1 == iter0_21
		end

		if arg1_21 - 1 == var0_0.PAGE_ACTIVITY then
			arg0_21.activityFilter = 0

			arg0_21:UpdateActivityBar()
		end
	end
end

function var0_0.MemoryFilter(arg0_22)
	table.clear(arg0_22.memoryGroups)

	local var0_22 = not _.all(arg0_22.memoryFilterIndex, function(arg0_23)
		return arg0_23
	end) and arg0_22.memoryFilterIndex[var0_0.PAGE_ACTIVITY]

	for iter0_22, iter1_22 in ipairs(pg.memory_group.all) do
		local var1_22 = pg.memory_group[iter1_22]

		if arg0_22.memoryFilterIndex[var1_22.type] then
			if var0_22 then
				if arg0_22.activityFilter == 0 or arg0_22.activityFilter == var1_22.subtype then
					table.insert(arg0_22.memoryGroups, var1_22)
				end
			else
				table.insert(arg0_22.memoryGroups, var1_22)
			end
		end
	end

	table.sort(arg0_22.memoryGroups, function(arg0_24, arg1_24)
		return arg0_24.id < arg1_24.id
	end)
	arg0_22:searchFilter()
	setActive(arg0_22.memoryActivityTogGroup, var0_22)
end

function var0_0.searchFilter(arg0_25)
	local var0_25 = getInputText(arg0_25.nameSearchInput)

	if not var0_25 or var0_25 == "" then
		arg0_25.searchGroupList = nil

		arg0_25.memoryGroupList:SetTotalCount(#arg0_25.memoryGroups, 0)
	else
		arg0_25.searchGroupList = arg0_25:GetMatchGroupList(var0_25)

		arg0_25.memoryGroupList:SetTotalCount(#arg0_25.searchGroupList, 0)
	end
end

function var0_0.onInitMemoryGroup(arg0_26, arg1_26)
	if arg0_26.exited then
		return
	end

	onButton(arg0_26, arg1_26, function()
		local var0_27 = arg0_26.memoryGroupInfos[arg1_26]

		if var0_27 then
			local var1_27 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.DeleteKey("MEMORY_GROUP_NOTIFICATION" .. var1_27 .. " " .. var0_27.id)
			arg0_26.viewParent:ShowSubMemories(var0_27)
		end
	end, SOUND_BACK)
end

function var0_0.onUpdateMemoryGroup(arg0_28, arg1_28, arg2_28)
	if arg0_28.exited then
		return
	end

	local var0_28 = arg0_28.searchGroupList and arg0_28.searchGroupList[arg1_28] or arg0_28.memoryGroups[arg1_28]

	assert(var0_28, "MemoryGroup Missing Config Index " .. arg1_28)

	arg0_28.memoryGroupInfos[arg2_28] = var0_28

	setText(tf(arg2_28):Find("title"), var0_28.title)
	arg0_28.loader:GetSpriteQuiet("memoryicon/" .. var0_28.icon, "", tf(arg2_28):Find("BG"))

	local var1_28 = getProxy(PlayerProxy):getRawData().id
	local var2_28 = PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1_28 .. " " .. var0_28.id, 0) == 1

	setActive(tf(arg2_28):Find("Tip"), var2_28)

	local var3_28 = #var0_28.memories
	local var4_28 = _.reduce(var0_28.memories, 0, function(arg0_29, arg1_29)
		local var0_29 = pg.memory_template[arg1_29]

		if var0_29.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_29.story, true) then
			arg0_29 = arg0_29 + 1
		end

		return arg0_29
	end)

	setText(tf(arg2_28):Find("count"), var4_28 .. "/" .. var3_28)
end

function var0_0.Return2MemoryGroup(arg0_30)
	local var0_30 = arg0_30.contextData.memoryGroup

	if not var0_30 or arg0_30:GetCurrentMode() == var0_0.LINE_MODE then
		return
	end

	local var1_30 = 0

	for iter0_30, iter1_30 in ipairs(arg0_30.memoryGroups) do
		if iter1_30.id == var0_30 then
			var1_30 = iter0_30

			break
		end
	end

	local var2_30 = arg0_30:GetIndexRatio(var1_30)

	arg0_30.memoryGroupList:SetTotalCount(#arg0_30.memoryGroups, var2_30)
end

function var0_0.SwitchReddotMemory(arg0_31)
	local var0_31 = 0
	local var1_31 = getProxy(PlayerProxy):getRawData().id

	for iter0_31, iter1_31 in ipairs(arg0_31.memoryGroups) do
		if PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1_31 .. " " .. iter1_31.id, 0) == 1 then
			var0_31 = iter0_31

			break
		end
	end

	if var0_31 == 0 then
		return
	end

	local var2_31 = arg0_31:GetIndexRatio(var0_31)

	arg0_31.memoryGroupList:SetTotalCount(#arg0_31.memoryGroups, var2_31)
end

function var0_0.GetIndexRatio(arg0_32, arg1_32)
	local var0_32 = 0

	if arg1_32 > 0 then
		local var1_32 = arg0_32.memoryGroupList
		local var2_32 = arg0_32.memoryGroupsGrid.cellSize.y + arg0_32.memoryGroupsGrid.spacing.y
		local var3_32 = arg0_32.memoryGroupsGrid.constraintCount
		local var4_32 = var2_32 * math.ceil(#arg0_32.memoryGroups / var3_32)

		var0_32 = (var2_32 * math.floor((arg1_32 - 1) / var3_32) + var1_32.paddingFront) / (var4_32 - arg0_32.memoryGroupViewport.rect.height)
		var0_32 = Mathf.Clamp01(var0_32)
	end

	return var0_32
end

function var0_0.UpdateView(arg0_33)
	local var0_33 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0_33._tf:Find("GroupRect"), {
		x = var0_33 and 0 or arg0_33.rectAnchorX
	})

	for iter0_33, iter1_33 in ipairs(arg0_33.memoryActivityToggles) do
		setActive(iter1_33, _.any(pg.memory_group.all, function(arg0_34)
			return pg.memory_group[arg0_34].subtype == iter0_33
		end))
	end
end

function var0_0.UpdateActivityBar(arg0_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.memoryActivityToggles) do
		local var0_35 = arg0_35.activityFilter == iter0_35

		setActive(iter1_35:Find("Image1"), not var0_35)
		setActive(iter1_35:Find("Image2"), var0_35)
	end
end

function var0_0.OnDestroy(arg0_36)
	var0_0.super.OnDestroy(arg0_36)
	arg0_36.storyLineView:Dispose()
end

function var0_0.GetMatchGroupList(arg0_37, arg1_37, arg2_37)
	arg1_37 = string.lower(string.gsub(arg1_37, "%.", "%%."))

	local var0_37 = {}

	for iter0_37, iter1_37 in pairs(arg0_37.memoryGroups) do
		if string.find(string.lower(iter1_37.title), arg1_37) then
			table.insert(var0_37, iter1_37)
		end
	end

	if arg0_37.shipNameSearchFlag then
		local var1_37 = {}

		for iter2_37, iter3_37 in pairs(pg.ship_data_statistics) do
			if string.find(string.lower(iter3_37.name), arg1_37) then
				table.insert(var1_37, iter2_37)
			end
		end

		local var2_37 = {}

		for iter4_37, iter5_37 in ipairs(var1_37) do
			local var3_37 = tostring(iter5_37)

			var2_37[tonumber(string.sub(var3_37, 1, #var3_37 - 1))] = true
		end

		for iter6_37, iter7_37 in pairs(arg0_37.memoryGroups) do
			if type(iter7_37.group_id) == "table" then
				for iter8_37, iter9_37 in ipairs(iter7_37.group_id) do
					if var2_37[iter9_37] and not table.contains(var0_37, iter7_37) then
						table.insert(var0_37, iter7_37)
					end
				end
			end
		end
	end

	return var0_37
end

return var0_0
