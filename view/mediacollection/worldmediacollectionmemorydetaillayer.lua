local var0_0 = class("WorldMediaCollectionMemoryDetailLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionMemoryDetailUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)
	setActive(arg0_2._tf:Find("ItemRect/TitleRecord"), false)
	setActive(arg0_2._tf:Find("ItemRect/TitleMemory"), true)

	arg0_2.memoryItemList = arg0_2._tf:Find("ItemRect"):GetComponent("LScrollRect")

	function arg0_2.memoryItemList.onInitItem(arg0_3)
		arg0_2:onInitMemoryItem(arg0_3)
	end

	function arg0_2.memoryItemList.onUpdateItem(arg0_4, arg1_4)
		arg0_2:onUpdateMemoryItem(arg0_4, arg1_4)
	end

	arg0_2.memoryItems = {}

	local var0_2 = tf(arg0_2.memoryItemList):Find("Item")

	setActive(var0_2, false)

	arg0_2.loader = AutoLoader.New()
	arg0_2.memoryItemViewport = tf(arg0_2.memoryItemList):Find("Viewport")
	arg0_2.memoryItemsGrid = tf(arg0_2.memoryItemList):Find("Viewport/Content"):GetComponent(typeof(GridLayoutGroup))

	setText(arg0_2._tf:Find("ItemRect/ProgressDesc"), i18n("world_collection_2"))

	arg0_2.rectAnchorX = arg0_2._tf:Find("ItemRect").anchoredPosition.x

	arg0_2:UpdateView()
end

function var0_0.onInitMemoryItem(arg0_5, arg1_5)
	if arg0_5.exited then
		return
	end

	onButton(arg0_5, arg1_5, function()
		local var0_6 = arg0_5.memoryItems[arg1_5]

		if var0_6 and (var0_6.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_6.unlock_pre, true)) then
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

	if var0_7.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_7.unlock_pre, true) then
		setActive(var1_7:Find("normal"), true)
		setActive(var1_7:Find("lock"), false)

		var1_7:Find("normal/title"):GetComponent(typeof(Text)).text = var0_7.title

		arg0_7.loader:GetSpriteQuiet("memoryicon/" .. var0_7.icon, "", var1_7:Find("normal"))
		setText(var1_7:Find("normal/id"), "#" .. arg0_7.memoryIds[arg1_7 + 1])
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
		pg.NewStoryMgr.GetInstance():ReViewPlay(arg1_9.story, function()
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

function var0_0.ShowSubMemories(arg0_11, arg1_11, arg2_11)
	arg0_11.contextData.memoryGroup = arg1_11.id
	arg0_11.memories = _.map(arg1_11.memories, function(arg0_12)
		return pg.memory_template[arg0_12]
	end)

	local var0_11 = 0

	arg0_11.memoryIds = _.map(arg1_11.memories, function(arg0_13)
		local var0_13 = pg.memory_template[arg0_13].number
		local var1_13 = var0_13 and var0_13 > 0

		if not var1_13 then
			var0_11 = var0_11 + 1
		end

		return var1_13 and var0_13 or var0_11
	end)

	local var1_11 = 0

	if arg2_11 then
		local var2_11 = 0

		for iter0_11 = 1, #arg0_11.memories do
			if arg0_11.memories[iter0_11].id == arg2_11 then
				var2_11 = iter0_11

				break
			end
		end

		if var2_11 > 0 then
			local var3_11 = arg0_11.memoryItemList
			local var4_11 = arg0_11.memoryItemsGrid.cellSize.y + arg0_11.memoryItemsGrid.spacing.y
			local var5_11 = arg0_11.memoryItemsGrid.constraintCount
			local var6_11 = var4_11 * math.ceil(#arg0_11.memories / var5_11)

			var1_11 = (var4_11 * math.floor((var2_11 - 1) / var5_11) + var3_11.paddingFront) / (var6_11 - arg0_11.memoryItemViewport.rect.height)
			var1_11 = Mathf.Clamp01(var1_11)
		end
	end

	arg0_11.memoryItemList:SetTotalCount(#arg0_11.memories, var1_11)

	local var7_11 = #arg0_11.memories
	local var8_11 = _.reduce(arg0_11.memories, 0, function(arg0_14, arg1_14)
		if arg1_14.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg1_14.unlock_pre, true) then
			arg0_14 = arg0_14 + 1
		end

		return arg0_14
	end)

	setText(arg0_11._tf:Find("ItemRect/ProgressText"), var8_11 .. "/" .. var7_11)

	local var9_11 = _.filter(pg.re_map_template.all, function(arg0_15)
		return pg.re_map_template[arg0_15].memory_group == arg1_11.id
	end)
	local var10_11 = var8_11 < var7_11 and #var9_11 > 0

	setActive(arg0_11._tf:Find("ItemRect/UnlockTip"), var10_11)

	if var10_11 then
		local var11_11 = _.map(_.sort(Map.GetRearChaptersOfRemaster(var9_11[1])), function(arg0_16)
			return getProxy(ChapterProxy):getChapterById(arg0_16, true):getConfig("chapter_name")
		end)

		setText(arg0_11._tf:Find("ItemRect/UnlockTip"), i18n("levelScene_remaster_unlock_tip", arg1_11.title, table.concat(var11_11, "/")))
	end
end

function var0_0.CleanList(arg0_17)
	arg0_17.memories = nil

	arg0_17.memoryItemList:SetTotalCount(0)
end

function var0_0.UpdateView(arg0_18)
	local var0_18 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0_18._tf:Find("ItemRect"), {
		x = var0_18 and 0 or arg0_18.rectAnchorX
	})
end

return var0_0
