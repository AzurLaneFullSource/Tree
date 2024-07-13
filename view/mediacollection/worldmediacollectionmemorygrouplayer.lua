local var0_0 = class("WorldMediaCollectionMemoryGroupLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionMemoryGroupUI"
end

var0_0.PAGE_ACTIVITY = 2

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2.memoryGroups = _.map(pg.memory_group.all, function(arg0_3)
		return pg.memory_group[arg0_3]
	end)
	arg0_2.memoryGroupList = arg0_2:findTF("GroupRect"):GetComponent("LScrollRect")

	function arg0_2.memoryGroupList.onInitItem(arg0_4)
		arg0_2:onInitMemoryGroup(arg0_4)
	end

	function arg0_2.memoryGroupList.onUpdateItem(arg0_5, arg1_5)
		arg0_2:onUpdateMemoryGroup(arg0_5 + 1, arg1_5)
	end

	arg0_2.memoryGroupInfos = {}

	local var0_2 = arg0_2:findTF("GroupItem", arg0_2.memoryGroupList)

	setActive(var0_2, false)

	arg0_2.memoryGroupViewport = arg0_2:findTF("Viewport", arg0_2.memoryGroupList)
	arg0_2.memoryGroupsGrid = arg0_2:findTF("Viewport/Content", arg0_2.memoryGroupList):GetComponent(typeof(GridLayoutGroup))
	arg0_2.memoryTogGroup = arg0_2:findTF("Toggles", arg0_2._tf)

	setActive(arg0_2.memoryTogGroup, true)

	arg0_2.memoryToggles = {}

	for iter0_2 = 0, 3 do
		arg0_2.memoryToggles[iter0_2 + 1] = arg0_2:findTF(iter0_2, arg0_2.memoryTogGroup)
	end

	arg0_2.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0_2.memoryActivityTogGroup = arg0_2:findTF("ActivityBar", arg0_2._tf)

	setActive(arg0_2.memoryActivityTogGroup, true)

	arg0_2.memoryActivityToggles = {}

	for iter1_2 = 0, 3 do
		arg0_2.memoryActivityToggles[iter1_2 + 1] = arg0_2:findTF(iter1_2, arg0_2.memoryActivityTogGroup)
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

	triggerToggle(arg0_2.memoryToggles[var1_2], true)
	arg0_2:SwitchMemoryFilter(var1_2)

	for iter4_2, iter5_2 in ipairs(arg0_2.memoryToggles) do
		onToggle(arg0_2, iter5_2, function(arg0_7)
			if not arg0_7 then
				return
			end

			arg0_2:SwitchMemoryFilter(iter4_2)
			arg0_2:MemoryFilter()
		end, SFX_UI_TAG)
	end

	arg0_2.viewParent:Add2TopContainer(arg0_2.memoryTogGroup)

	arg0_2.loader = AutoLoader.New()

	arg0_2:MemoryFilter()

	arg0_2.rectAnchorX = arg0_2:findTF("GroupRect").anchoredPosition.x

	arg0_2:UpdateView()
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)
	setActive(arg0_8.memoryTogGroup, true)
end

function var0_0.Hide(arg0_9)
	setActive(arg0_9.memoryTogGroup, false)
	var0_0.super.Hide(arg0_9)
end

function var0_0.SwitchMemoryFilter(arg0_10, arg1_10)
	if arg1_10 == 1 then
		arg0_10.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0_10 in ipairs(arg0_10.memoryFilterIndex) do
			arg0_10.memoryFilterIndex[iter0_10] = arg1_10 - 1 == iter0_10
		end

		if arg1_10 - 1 == var0_0.PAGE_ACTIVITY then
			arg0_10.activityFilter = 0

			arg0_10:UpdateActivityBar()
		end
	end
end

function var0_0.MemoryFilter(arg0_11)
	table.clear(arg0_11.memoryGroups)

	local var0_11 = not _.all(arg0_11.memoryFilterIndex, function(arg0_12)
		return arg0_12
	end) and arg0_11.memoryFilterIndex[var0_0.PAGE_ACTIVITY]

	for iter0_11, iter1_11 in ipairs(pg.memory_group.all) do
		local var1_11 = pg.memory_group[iter1_11]

		if arg0_11.memoryFilterIndex[var1_11.type] then
			if var0_11 then
				if arg0_11.activityFilter == 0 or arg0_11.activityFilter == var1_11.subtype then
					table.insert(arg0_11.memoryGroups, var1_11)
				end
			else
				table.insert(arg0_11.memoryGroups, var1_11)
			end
		end
	end

	table.sort(arg0_11.memoryGroups, function(arg0_13, arg1_13)
		return arg0_13.id < arg1_13.id
	end)
	arg0_11.memoryGroupList:SetTotalCount(#arg0_11.memoryGroups, 0)
	setActive(arg0_11.memoryActivityTogGroup, var0_11)
end

function var0_0.onInitMemoryGroup(arg0_14, arg1_14)
	if arg0_14.exited then
		return
	end

	onButton(arg0_14, arg1_14, function()
		local var0_15 = arg0_14.memoryGroupInfos[arg1_14]

		if var0_15 then
			local var1_15 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.DeleteKey("MEMORY_GROUP_NOTIFICATION" .. var1_15 .. " " .. var0_15.id)
			arg0_14.viewParent:ShowSubMemories(var0_15)
		end
	end, SOUND_BACK)
end

function var0_0.onUpdateMemoryGroup(arg0_16, arg1_16, arg2_16)
	if arg0_16.exited then
		return
	end

	local var0_16 = arg0_16.memoryGroups[arg1_16]

	assert(var0_16, "MemoryGroup Missing Config Index " .. arg1_16)

	arg0_16.memoryGroupInfos[arg2_16] = var0_16

	setText(tf(arg2_16):Find("title"), var0_16.title)
	arg0_16.loader:GetSpriteQuiet("memoryicon/" .. var0_16.icon, "", tf(arg2_16):Find("BG"))

	local var1_16 = getProxy(PlayerProxy):getRawData().id
	local var2_16 = PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1_16 .. " " .. var0_16.id, 0) == 1

	setActive(tf(arg2_16):Find("Tip"), var2_16)

	local var3_16 = #var0_16.memories
	local var4_16 = _.reduce(var0_16.memories, 0, function(arg0_17, arg1_17)
		local var0_17 = pg.memory_template[arg1_17]

		if var0_17.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_17.story, true) then
			arg0_17 = arg0_17 + 1
		end

		return arg0_17
	end)

	setText(tf(arg2_16):Find("count"), var4_16 .. "/" .. var3_16)
end

function var0_0.Return2MemoryGroup(arg0_18)
	local var0_18 = arg0_18.contextData.memoryGroup

	if not var0_18 then
		return
	end

	local var1_18 = 0

	for iter0_18, iter1_18 in ipairs(arg0_18.memoryGroups) do
		if iter1_18.id == var0_18 then
			var1_18 = iter0_18

			break
		end
	end

	local var2_18 = arg0_18:GetIndexRatio(var1_18)

	arg0_18.memoryGroupList:SetTotalCount(#arg0_18.memoryGroups, var2_18)
end

function var0_0.SwitchReddotMemory(arg0_19)
	local var0_19 = 0
	local var1_19 = getProxy(PlayerProxy):getRawData().id

	for iter0_19, iter1_19 in ipairs(arg0_19.memoryGroups) do
		if PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1_19 .. " " .. iter1_19.id, 0) == 1 then
			var0_19 = iter0_19

			break
		end
	end

	if var0_19 == 0 then
		return
	end

	local var2_19 = arg0_19:GetIndexRatio(var0_19)

	arg0_19.memoryGroupList:SetTotalCount(#arg0_19.memoryGroups, var2_19)
end

function var0_0.GetIndexRatio(arg0_20, arg1_20)
	local var0_20 = 0

	if arg1_20 > 0 then
		local var1_20 = arg0_20.memoryGroupList
		local var2_20 = arg0_20.memoryGroupsGrid.cellSize.y + arg0_20.memoryGroupsGrid.spacing.y
		local var3_20 = arg0_20.memoryGroupsGrid.constraintCount
		local var4_20 = var2_20 * math.ceil(#arg0_20.memoryGroups / var3_20)

		var0_20 = (var2_20 * math.floor((arg1_20 - 1) / var3_20) + var1_20.paddingFront) / (var4_20 - arg0_20.memoryGroupViewport.rect.height)
		var0_20 = Mathf.Clamp01(var0_20)
	end

	return var0_20
end

function var0_0.UpdateView(arg0_21)
	local var0_21 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0_21:findTF("GroupRect"), {
		x = var0_21 and 0 or arg0_21.rectAnchorX
	})

	for iter0_21, iter1_21 in ipairs(arg0_21.memoryActivityToggles) do
		setActive(iter1_21, _.any(pg.memory_group.all, function(arg0_22)
			return pg.memory_group[arg0_22].subtype == iter0_21
		end))
	end
end

function var0_0.UpdateActivityBar(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.memoryActivityToggles) do
		local var0_23 = arg0_23.activityFilter == iter0_23

		setActive(iter1_23:Find("Image1"), not var0_23)
		setActive(iter1_23:Find("Image2"), var0_23)
	end
end

return var0_0
