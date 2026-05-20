local var0_0 = class("NewWorldMediaCollectionMemoryDetailLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "NewWorldMediaCollectionMemoryDetailUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2.memoryItemList = arg0_2._tf:Find("AD/task/ItemRect"):GetComponent("LScrollRect")
	arg0_2.memoryItems = {}
	arg0_2.loader = AutoLoader.New()

	setText(arg0_2._tf:Find("AD/task/ProgressDesc"), i18n("activity_permanent_progress"))
end

function var0_0.onInitMemoryItem(arg0_3, arg1_3)
	if arg0_3.exited then
		return
	end
end

function var0_0.onUpdateMemoryItem(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4, arg6_4)
	if arg0_4.exited then
		return
	end

	local var0_4 = arg0_4.memories and arg0_4.memories[arg1_4]

	arg0_4.memoryItems[arg2_4] = var0_4

	local var1_4 = tf(arg2_4)
	local var2_4 = var0_4.task
	local var3_4 = getProxy(TaskProxy)

	setText(var1_4:Find("lock_bg/lockname"), var0_4.condition)
	setText(var1_4:Find("on/taskname"), var0_4.title)
	setText(var1_4:Find("on/num"), string.format("%02d", arg1_4))
	setText(var1_4:Find("deblocking/Text"), i18n("memory_unlock"))
	setText(var1_4:Find("lock_bg/go/name"), i18n("memory_goto"))

	if arg1_4 == 1 and not arg3_4 and arg5_4 < arg1_4 and arg0_4.groupInfo.id ~= 501 then
		setActive(var1_4:Find("deblocking"), true)
		setActive(var1_4:Find("lock_bg"), true)
		setActive(var1_4:Find("lock_bg/lock"), false)
		setActive(var1_4:Find("on"), false)
	else
		setActive(var1_4:Find("deblocking"), false)
		setActive(var1_4:Find("lock_bg"), arg5_4 < arg1_4)
		setActive(var1_4:Find("lock_bg/go"), not arg3_4 and arg1_4 == arg5_4 + 1)
		setActive(var1_4:Find("lock_bg/lock"), arg3_4 or arg1_4 > arg5_4 + 1)
		setActive(var1_4:Find("on"), arg1_4 <= arg5_4)
	end

	onButton(arg0_4, var1_4:Find("lock_bg/go"), function()
		arg0_4:emit(WorldMediaCollectionMediator.GO_TASK)
	end, SOUND_BACK)
	onButton(arg0_4, var1_4:Find("deblocking"), function()
		if arg0_4.isFoldState then
			return
		end

		arg0_4:emit(WorldMediaCollectionMediator.TRIGGER_PERSONAL_TASK, arg4_4, function()
			arg0_4:ShowSubMemories(arg0_4.groupInfo, arg0_4.memoryID)
		end)
	end, SOUND_BACK)
	onButton(arg0_4, var1_4:Find("on/play"), function()
		if var0_4 and (var0_4.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_4.unlock_pre, true)) then
			arg0_4:PlayMemory(var0_4)
		end
	end, SOUND_BACK)
end

function var0_0.SetStoryMask(arg0_9, arg1_9)
	arg0_9.memoryMask = arg1_9
end

function var0_0.PlayMemory(arg0_10, arg1_10)
	if arg1_10.type == 1 then
		local var0_10 = findTF(arg0_10.memoryMask, "pic")

		if string.len(arg1_10.mask) > 0 then
			setActive(var0_10, true)

			var0_10:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_10.mask)
		else
			setActive(var0_10, false)
		end

		setActive(arg0_10.memoryMask, true)
		pg.NewStoryMgr.GetInstance():ReViewPlay(arg1_10.story, function()
			setActive(arg0_10.memoryMask, false)
		end, true)
	elseif arg1_10.type == 2 then
		local var1_10 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_10.story)

		assert(var1_10 and var1_10 ~= 0, "Missing Story Stage ID: " .. (arg1_10.story or "NIL"))
		arg0_10:emit(WorldMediaCollectionMediator.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1_10
		})
	end
end

function var0_0.ShowSubMemories(arg0_12, arg1_12, arg2_12)
	arg0_12.groupInfo = arg1_12
	arg0_12.memoryID = arg2_12
	arg0_12.contextData.memoryGroup = arg1_12.id
	arg0_12.memories = _.map(arg1_12.memories, function(arg0_13)
		return pg.memory_template[arg0_13]
	end)

	local var0_12 = getProxy(CollectionProxy)
	local var1_12 = arg1_12.ship_group
	local var2_12 = ShipGroup.getDefaultShipConfig(var1_12)
	local var3_12 = var0_12 and var0_12.shipGroups[var1_12] == nil

	setText(arg0_12._tf:Find("AD/icon_bg/painting/name_bg/name"), var2_12.name)
	SetActive(arg0_12._tf:Find("AD/icon_bg/painting/name_bg/off"), var3_12)

	local var4_12 = arg0_12._tf:Find("AD/icon_bg/painting")
	local var5_12 = pg.ship_skin_template[var2_12.skin_id].painting

	setPaintingPrefabAsync(var4_12, var5_12, "duihua", function(arg0_14)
		arg0_12.rtPaint = arg0_14
	end)

	local var6_12 = 0

	arg0_12.memoryIds = _.map(arg1_12.memories, function(arg0_15)
		local var0_15 = pg.memory_template[arg0_15].number
		local var1_15 = var0_15 and var0_15 > 0

		if not var1_15 then
			var6_12 = var6_12 + 1
		end

		return var1_15 and var0_15 or var6_12
	end)

	local var7_12 = 0

	if arg2_12 then
		local var8_12 = 0

		for iter0_12 = 1, #arg0_12.memories do
			if arg0_12.memories[iter0_12].id == arg2_12 then
				var8_12 = iter0_12

				break
			end
		end

		if var8_12 > 0 then
			local var9_12 = arg0_12.memoryItemList
			local var10_12 = arg0_12.memoryItemsGrid.cellSize.y + arg0_12.memoryItemsGrid.spacing.y
			local var11_12 = arg0_12.memoryItemsGrid.constraintCount
			local var12_12 = var10_12 * math.ceil(#arg0_12.memories / var11_12)

			var7_12 = (var10_12 * math.floor((var8_12 - 1) / var11_12) + var9_12.paddingFront) / (var12_12 - arg0_12.memoryItemViewport.rect.height)
			var7_12 = Mathf.Clamp01(var7_12)
		end
	end

	local var13_12 = #arg0_12.memories
	local var14_12 = _.reduce(arg0_12.memories, 0, function(arg0_16, arg1_16)
		if arg1_16.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg1_16.story, true) then
			arg0_16 = arg0_16 + 1
		end

		return arg0_16
	end)

	setText(arg0_12._tf:Find("AD/task/ProgressText"), var14_12 .. "/" .. var13_12)
	setText(arg0_12._tf:Find("AD/task/headline_bg/headline_name"), arg1_12.title)

	function arg0_12.memoryItemList.onUpdateItem(arg0_17, arg1_17)
		arg0_12:onUpdateMemoryItem(arg0_17 + 1, arg1_17, var3_12, var1_12, var14_12, var13_12)
	end

	arg0_12.memoryItemList:SetTotalCount(#arg0_12.memories, var7_12)
end

function var0_0.CleanList(arg0_18)
	arg0_18.memories = nil

	arg0_18.memoryItemList:SetTotalCount(0)
end

function var0_0.UpdateView(arg0_19)
	return
end

return var0_0
