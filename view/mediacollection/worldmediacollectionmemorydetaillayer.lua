local var0_0 = class("WorldMediaCollectionMemoryDetailLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionMemoryDetailUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)
	setActive(arg0_2._tf:Find("ItemRect/TitleRecord"), false)
	setActive(arg0_2._tf:Find("ItemRect/TitleMemory"), true)

	arg0_2.memoryItemList = arg0_2:findTF("ItemRect"):GetComponent("LScrollRect")

	function arg0_2.memoryItemList.onInitItem(arg0_3)
		arg0_2:onInitMemoryItem(arg0_3)
	end

	function arg0_2.memoryItemList.onUpdateItem(arg0_4, arg1_4)
		arg0_2:onUpdateMemoryItem(arg0_4, arg1_4)
	end

	arg0_2.memoryItems = {}

	local var0_2 = arg0_2:findTF("Item", arg0_2.memoryItemList)

	setActive(var0_2, false)

	arg0_2.loader = AutoLoader.New()

	setText(arg0_2._tf:Find("ItemRect/ProgressDesc"), i18n("world_collection_2"))

	arg0_2.rectAnchorX = arg0_2:findTF("ItemRect").anchoredPosition.x

	arg0_2:UpdateView()
end

function var0_0.onInitMemoryItem(arg0_5, arg1_5)
	if arg0_5.exited then
		return
	end

	onButton(arg0_5, arg1_5, function()
		local var0_6 = arg0_5.memoryItems[arg1_5]

		if var0_6 and (var0_6.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_6.story, true)) then
			arg0_5:PlayMemory(var0_6)
		end
	end, SOUND_BACK)
end

function var0_0.onUpdateMemoryItem(arg0_7, arg1_7, arg2_7)
	if arg0_7.exited then
		return
	end

	local var0_7 = arg0_7.memories and arg0_7.memories[arg1_7 + 1]

	arg0_7.memoryItems[arg2_7] = var0_7

	local var1_7 = tf(arg2_7)

	if var0_7.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_7.story, true) then
		setActive(var1_7:Find("normal"), true)
		setActive(var1_7:Find("lock"), false)

		var1_7:Find("normal/title"):GetComponent(typeof(Text)).text = var0_7.title

		arg0_7.loader:GetSpriteQuiet("memoryicon/" .. var0_7.icon, "", var1_7:Find("normal"))
		setText(var1_7:Find("normal/id"), string.format("#%u", arg1_7 + 1))
	else
		setActive(var1_7:Find("normal"), false)
		setActive(var1_7:Find("lock"), true)
		setText(var1_7:Find("lock/condition"), var0_7.condition)
	end
end

function var0_0.SetStoryMask(arg0_8, arg1_8)
	arg0_8.memoryMask = arg1_8
end

function var0_0.PlayMemory(arg0_9, arg1_9)
	if arg1_9.type == 1 then
		local var0_9 = findTF(arg0_9.memoryMask, "pic")

		if string.len(arg1_9.mask) > 0 then
			setActive(var0_9, true)

			var0_9:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_9.mask)
		else
			setActive(var0_9, false)
		end

		setActive(arg0_9.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1_9.story, function()
			setActive(arg0_9.memoryMask, false)
		end, true)
	elseif arg1_9.type == 2 then
		local var1_9 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_9.story)

		assert(var1_9 and var1_9 ~= 0, "Missing Story Stage ID: " .. (arg1_9.story or "NIL"))
		arg0_9:emit(WorldMediaCollectionMediator.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1_9
		})
	end
end

function var0_0.ShowSubMemories(arg0_11, arg1_11)
	arg0_11.contextData.memoryGroup = arg1_11.id
	arg0_11.memories = _.map(arg1_11.memories, function(arg0_12)
		return pg.memory_template[arg0_12]
	end)

	arg0_11.memoryItemList:SetTotalCount(#arg0_11.memories, 0)

	local var0_11 = #arg0_11.memories
	local var1_11 = _.reduce(arg0_11.memories, 0, function(arg0_13, arg1_13)
		if arg1_13.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg1_13.story, true) then
			arg0_13 = arg0_13 + 1
		end

		return arg0_13
	end)

	setText(arg0_11._tf:Find("ItemRect/ProgressText"), var1_11 .. "/" .. var0_11)

	local var2_11 = _.filter(pg.re_map_template.all, function(arg0_14)
		return pg.re_map_template[arg0_14].memory_group == arg1_11.id
	end)
	local var3_11 = var1_11 < var0_11 and #var2_11 > 0

	setActive(arg0_11._tf:Find("ItemRect/UnlockTip"), var3_11)

	if var3_11 then
		local var4_11 = _.map(_.sort(Map.GetRearChaptersOfRemaster(var2_11[1])), function(arg0_15)
			return getProxy(ChapterProxy):getChapterById(arg0_15, true):getConfig("chapter_name")
		end)

		setText(arg0_11._tf:Find("ItemRect/UnlockTip"), i18n("levelScene_remaster_unlock_tip", arg1_11.title, table.concat(var4_11, "/")))
	end
end

function var0_0.CleanList(arg0_16)
	arg0_16.memories = nil

	arg0_16.memoryItemList:SetTotalCount(0)
end

function var0_0.UpdateView(arg0_17)
	local var0_17 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0_17:findTF("ItemRect"), {
		x = var0_17 and 0 or arg0_17.rectAnchorX
	})
end

return var0_0
