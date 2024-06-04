local var0 = class("WorldMediaCollectionMemoryDetailLayer", import(".WorldMediaCollectionSubLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionMemoryDetailUI"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	assert(arg0.viewParent, "Need assign ViewParent for " .. arg0.__cname)
	setActive(arg0._tf:Find("ItemRect/TitleRecord"), false)
	setActive(arg0._tf:Find("ItemRect/TitleMemory"), true)

	arg0.memoryItemList = arg0:findTF("ItemRect"):GetComponent("LScrollRect")

	function arg0.memoryItemList.onInitItem(arg0)
		arg0:onInitMemoryItem(arg0)
	end

	function arg0.memoryItemList.onUpdateItem(arg0, arg1)
		arg0:onUpdateMemoryItem(arg0, arg1)
	end

	arg0.memoryItems = {}

	local var0 = arg0:findTF("Item", arg0.memoryItemList)

	setActive(var0, false)

	arg0.loader = AutoLoader.New()

	setText(arg0._tf:Find("ItemRect/ProgressDesc"), i18n("world_collection_2"))

	arg0.rectAnchorX = arg0:findTF("ItemRect").anchoredPosition.x

	arg0:UpdateView()
end

function var0.onInitMemoryItem(arg0, arg1)
	if arg0.exited then
		return
	end

	onButton(arg0, arg1, function()
		local var0 = arg0.memoryItems[arg1]

		if var0 and (var0.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0.story, true)) then
			arg0:PlayMemory(var0)
		end
	end, SOUND_BACK)
end

function var0.onUpdateMemoryItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.memories and arg0.memories[arg1 + 1]

	arg0.memoryItems[arg2] = var0

	local var1 = tf(arg2)

	if var0.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0.story, true) then
		setActive(var1:Find("normal"), true)
		setActive(var1:Find("lock"), false)

		var1:Find("normal/title"):GetComponent(typeof(Text)).text = var0.title

		arg0.loader:GetSpriteQuiet("memoryicon/" .. var0.icon, "", var1:Find("normal"))
		setText(var1:Find("normal/id"), string.format("#%u", arg1 + 1))
	else
		setActive(var1:Find("normal"), false)
		setActive(var1:Find("lock"), true)
		setText(var1:Find("lock/condition"), var0.condition)
	end
end

function var0.SetStoryMask(arg0, arg1)
	arg0.memoryMask = arg1
end

function var0.PlayMemory(arg0, arg1)
	if arg1.type == 1 then
		local var0 = findTF(arg0.memoryMask, "pic")

		if string.len(arg1.mask) > 0 then
			setActive(var0, true)

			var0:GetComponent(typeof(Image)).sprite = LoadSprite(arg1.mask)
		else
			setActive(var0, false)
		end

		setActive(arg0.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1.story, function()
			setActive(arg0.memoryMask, false)
		end, true)
	elseif arg1.type == 2 then
		local var1 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1.story)

		assert(var1 and var1 ~= 0, "Missing Story Stage ID: " .. (arg1.story or "NIL"))
		arg0:emit(WorldMediaCollectionMediator.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1
		})
	end
end

function var0.ShowSubMemories(arg0, arg1)
	arg0.contextData.memoryGroup = arg1.id
	arg0.memories = _.map(arg1.memories, function(arg0)
		return pg.memory_template[arg0]
	end)

	arg0.memoryItemList:SetTotalCount(#arg0.memories, 0)

	local var0 = #arg0.memories
	local var1 = _.reduce(arg0.memories, 0, function(arg0, arg1)
		if arg1.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg1.story, true) then
			arg0 = arg0 + 1
		end

		return arg0
	end)

	setText(arg0._tf:Find("ItemRect/ProgressText"), var1 .. "/" .. var0)

	local var2 = _.filter(pg.re_map_template.all, function(arg0)
		return pg.re_map_template[arg0].memory_group == arg1.id
	end)
	local var3 = var1 < var0 and #var2 > 0

	setActive(arg0._tf:Find("ItemRect/UnlockTip"), var3)

	if var3 then
		local var4 = _.map(_.sort(Map.GetRearChaptersOfRemaster(var2[1])), function(arg0)
			return getProxy(ChapterProxy):getChapterById(arg0, true):getConfig("chapter_name")
		end)

		setText(arg0._tf:Find("ItemRect/UnlockTip"), i18n("levelScene_remaster_unlock_tip", arg1.title, table.concat(var4, "/")))
	end
end

function var0.CleanList(arg0)
	arg0.memories = nil

	arg0.memoryItemList:SetTotalCount(0)
end

function var0.UpdateView(arg0)
	local var0 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0:findTF("ItemRect"), {
		x = var0 and 0 or arg0.rectAnchorX
	})
end

return var0
