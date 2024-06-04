local var0 = class("WorldMediaCollectionMemoryGroupLayer", import(".WorldMediaCollectionSubLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionMemoryGroupUI"
end

var0.PAGE_ACTIVITY = 2

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	assert(arg0.viewParent, "Need assign ViewParent for " .. arg0.__cname)

	arg0.memoryGroups = _.map(pg.memory_group.all, function(arg0)
		return pg.memory_group[arg0]
	end)
	arg0.memoryGroupList = arg0:findTF("GroupRect"):GetComponent("LScrollRect")

	function arg0.memoryGroupList.onInitItem(arg0)
		arg0:onInitMemoryGroup(arg0)
	end

	function arg0.memoryGroupList.onUpdateItem(arg0, arg1)
		arg0:onUpdateMemoryGroup(arg0 + 1, arg1)
	end

	arg0.memoryGroupInfos = {}

	local var0 = arg0:findTF("GroupItem", arg0.memoryGroupList)

	setActive(var0, false)

	arg0.memoryGroupViewport = arg0:findTF("Viewport", arg0.memoryGroupList)
	arg0.memoryGroupsGrid = arg0:findTF("Viewport/Content", arg0.memoryGroupList):GetComponent(typeof(GridLayoutGroup))
	arg0.memoryTogGroup = arg0:findTF("Toggles", arg0._tf)

	setActive(arg0.memoryTogGroup, true)

	arg0.memoryToggles = {}

	for iter0 = 0, 3 do
		arg0.memoryToggles[iter0 + 1] = arg0:findTF(iter0, arg0.memoryTogGroup)
	end

	arg0.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0.memoryActivityTogGroup = arg0:findTF("ActivityBar", arg0._tf)

	setActive(arg0.memoryActivityTogGroup, true)

	arg0.memoryActivityToggles = {}

	for iter1 = 0, 3 do
		arg0.memoryActivityToggles[iter1 + 1] = arg0:findTF(iter1, arg0.memoryActivityTogGroup)
	end

	arg0.activityFilter = 0

	arg0:UpdateActivityBar()

	for iter2, iter3 in ipairs(arg0.memoryActivityToggles) do
		onButton(arg0, iter3, function()
			if iter2 == arg0.activityFilter then
				arg0.activityFilter = 0
			elseif iter2 ~= arg0.activityFilter then
				arg0.activityFilter = iter2
			end

			arg0:UpdateActivityBar()
			arg0:MemoryFilter()
		end, SFX_UI_TAG)
	end

	setText(arg0.memoryActivityToggles[1]:Find("Image1/Text"), i18n("memory_actiivty_ex"))
	setText(arg0.memoryActivityToggles[1]:Find("Image2/Text"), i18n("memory_actiivty_ex"))
	setText(arg0.memoryActivityToggles[2]:Find("Image1/Text"), i18n("memory_activity_sp"))
	setText(arg0.memoryActivityToggles[2]:Find("Image2/Text"), i18n("memory_activity_sp"))
	setText(arg0.memoryActivityToggles[3]:Find("Image1/Text"), i18n("memory_activity_daily"))
	setText(arg0.memoryActivityToggles[3]:Find("Image2/Text"), i18n("memory_activity_daily"))
	setText(arg0.memoryActivityToggles[4]:Find("Image1/Text"), i18n("memory_activity_others"))
	setText(arg0.memoryActivityToggles[4]:Find("Image2/Text"), i18n("memory_activity_others"))

	arg0.contextData.toggle = arg0.contextData.toggle or 1

	local var1 = arg0.contextData.toggle

	triggerToggle(arg0.memoryToggles[var1], true)
	arg0:SwitchMemoryFilter(var1)

	for iter4, iter5 in ipairs(arg0.memoryToggles) do
		onToggle(arg0, iter5, function(arg0)
			if not arg0 then
				return
			end

			arg0:SwitchMemoryFilter(iter4)
			arg0:MemoryFilter()
		end, SFX_UI_TAG)
	end

	arg0.viewParent:Add2TopContainer(arg0.memoryTogGroup)

	arg0.loader = AutoLoader.New()

	arg0:MemoryFilter()

	arg0.rectAnchorX = arg0:findTF("GroupRect").anchoredPosition.x

	arg0:UpdateView()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	setActive(arg0.memoryTogGroup, true)
end

function var0.Hide(arg0)
	setActive(arg0.memoryTogGroup, false)
	var0.super.Hide(arg0)
end

function var0.SwitchMemoryFilter(arg0, arg1)
	if arg1 == 1 then
		arg0.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0 in ipairs(arg0.memoryFilterIndex) do
			arg0.memoryFilterIndex[iter0] = arg1 - 1 == iter0
		end

		if arg1 - 1 == var0.PAGE_ACTIVITY then
			arg0.activityFilter = 0

			arg0:UpdateActivityBar()
		end
	end
end

function var0.MemoryFilter(arg0)
	table.clear(arg0.memoryGroups)

	local var0 = not _.all(arg0.memoryFilterIndex, function(arg0)
		return arg0
	end) and arg0.memoryFilterIndex[var0.PAGE_ACTIVITY]

	for iter0, iter1 in ipairs(pg.memory_group.all) do
		local var1 = pg.memory_group[iter1]

		if arg0.memoryFilterIndex[var1.type] then
			if var0 then
				if arg0.activityFilter == 0 or arg0.activityFilter == var1.subtype then
					table.insert(arg0.memoryGroups, var1)
				end
			else
				table.insert(arg0.memoryGroups, var1)
			end
		end
	end

	table.sort(arg0.memoryGroups, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.memoryGroupList:SetTotalCount(#arg0.memoryGroups, 0)
	setActive(arg0.memoryActivityTogGroup, var0)
end

function var0.onInitMemoryGroup(arg0, arg1)
	if arg0.exited then
		return
	end

	onButton(arg0, arg1, function()
		local var0 = arg0.memoryGroupInfos[arg1]

		if var0 then
			local var1 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.DeleteKey("MEMORY_GROUP_NOTIFICATION" .. var1 .. " " .. var0.id)
			arg0.viewParent:ShowSubMemories(var0)
		end
	end, SOUND_BACK)
end

function var0.onUpdateMemoryGroup(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.memoryGroups[arg1]

	assert(var0, "MemoryGroup Missing Config Index " .. arg1)

	arg0.memoryGroupInfos[arg2] = var0

	setText(tf(arg2):Find("title"), var0.title)
	arg0.loader:GetSpriteQuiet("memoryicon/" .. var0.icon, "", tf(arg2):Find("BG"))

	local var1 = getProxy(PlayerProxy):getRawData().id
	local var2 = PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1 .. " " .. var0.id, 0) == 1

	setActive(tf(arg2):Find("Tip"), var2)

	local var3 = #var0.memories
	local var4 = _.reduce(var0.memories, 0, function(arg0, arg1)
		local var0 = pg.memory_template[arg1]

		if var0.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0.story, true) then
			arg0 = arg0 + 1
		end

		return arg0
	end)

	setText(tf(arg2):Find("count"), var4 .. "/" .. var3)
end

function var0.Return2MemoryGroup(arg0)
	local var0 = arg0.contextData.memoryGroup

	if not var0 then
		return
	end

	local var1 = 0

	for iter0, iter1 in ipairs(arg0.memoryGroups) do
		if iter1.id == var0 then
			var1 = iter0

			break
		end
	end

	local var2 = arg0:GetIndexRatio(var1)

	arg0.memoryGroupList:SetTotalCount(#arg0.memoryGroups, var2)
end

function var0.SwitchReddotMemory(arg0)
	local var0 = 0
	local var1 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(arg0.memoryGroups) do
		if PlayerPrefs.GetInt("MEMORY_GROUP_NOTIFICATION" .. var1 .. " " .. iter1.id, 0) == 1 then
			var0 = iter0

			break
		end
	end

	if var0 == 0 then
		return
	end

	local var2 = arg0:GetIndexRatio(var0)

	arg0.memoryGroupList:SetTotalCount(#arg0.memoryGroups, var2)
end

function var0.GetIndexRatio(arg0, arg1)
	local var0 = 0

	if arg1 > 0 then
		local var1 = arg0.memoryGroupList
		local var2 = arg0.memoryGroupsGrid.cellSize.y + arg0.memoryGroupsGrid.spacing.y
		local var3 = arg0.memoryGroupsGrid.constraintCount
		local var4 = var2 * math.ceil(#arg0.memoryGroups / var3)

		var0 = (var2 * math.floor((arg1 - 1) / var3) + var1.paddingFront) / (var4 - arg0.memoryGroupViewport.rect.height)
		var0 = Mathf.Clamp01(var0)
	end

	return var0
end

function var0.UpdateView(arg0)
	local var0 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0:findTF("GroupRect"), {
		x = var0 and 0 or arg0.rectAnchorX
	})

	for iter0, iter1 in ipairs(arg0.memoryActivityToggles) do
		setActive(iter1, _.any(pg.memory_group.all, function(arg0)
			return pg.memory_group[arg0].subtype == iter0
		end))
	end
end

function var0.UpdateActivityBar(arg0)
	for iter0, iter1 in ipairs(arg0.memoryActivityToggles) do
		local var0 = arg0.activityFilter == iter0

		setActive(iter1:Find("Image1"), not var0)
		setActive(iter1:Find("Image2"), var0)
	end
end

return var0
