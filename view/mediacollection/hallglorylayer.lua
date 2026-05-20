local var0_0 = class("HallGloryLayer", import(".WorldMediaCollectionSubLayer"))

var0_0.type = 4

function var0_0.getUIName(arg0_1)
	return "HallGloryUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)

	arg0_2.AD = arg0_2._tf:Find("AD")
	arg0_2.progress = arg0_2.AD:Find("progress")
	arg0_2.memoryGroupList = arg0_2.AD:Find("ItemRect/Content"):GetComponent("LScrollRect")

	function arg0_2.memoryGroupList.onInitItem(arg0_3)
		arg0_2:onInitMemoryGroup(arg0_3)
	end

	function arg0_2.memoryGroupList.onUpdateItem(arg0_4, arg1_4)
		arg0_2:onUpdateMemoryGroup(arg0_4 + 1, arg1_4)
	end

	arg0_2.memoryGroups = _.map(pg.memory_group.all, function(arg0_5)
		return pg.memory_group[arg0_5]
	end)
	arg0_2.memories = {}

	arg0_2:MemoryFilter()

	arg0_2.memoryItems = {}
	arg0_2.loader = AutoLoader.New()

	setText(arg0_2.AD:Find("progress/Text"), i18n("memory_filter_option_2"))
end

function var0_0.MemoryFilter(arg0_6)
	table.clear(arg0_6.memoryGroups)

	for iter0_6, iter1_6 in ipairs(pg.memory_group.all) do
		local var0_6 = pg.memory_group[iter1_6]

		if var0_6.type == arg0_6.type then
			table.insert(arg0_6.memoryGroups, var0_6)
		end
	end

	arg0_6.memories = _.map(arg0_6.memoryGroups[1].memories, function(arg0_7)
		return pg.memory_template[arg0_7]
	end)
	arg0_6.memoryGroupList.enabled = true

	arg0_6.memoryGroupList:SetTotalCount(#arg0_6.memories / 3, 0)

	local var1_6 = #arg0_6.memories
	local var2_6 = _.reduce(arg0_6.memories, 0, function(arg0_8, arg1_8)
		if arg1_8.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg1_8.unlock_pre, true) then
			arg0_8 = arg0_8 + 1
		end

		return arg0_8
	end)

	arg0_6.contextData.memoryGroup = arg0_6.memoryGroups[1].id

	setText(arg0_6.AD:Find("progress/num"), var2_6 .. "/" .. var1_6)
end

function var0_0.onInitMemoryGroup(arg0_9, arg1_9)
	if arg0_9.exited then
		return
	end

	for iter0_9 = 1, 3 do
		local var0_9 = tf(arg1_9):Find("item_" .. iter0_9)

		onButton(arg0_9, var0_9:Find("BG/play"), function()
			local var0_10 = arg0_9.memoryItems[var0_9]

			if var0_10 and (var0_10.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_10.unlock_pre, true)) then
				arg0_9:PlayMemory(var0_10)
			end
		end, SOUND_BACK)
	end
end

function var0_0.onUpdateMemoryGroup(arg0_11, arg1_11, arg2_11)
	for iter0_11 = 1, 3 do
		local var0_11 = arg0_11.memories[(arg1_11 - 1) * 3 + iter0_11]
		local var1_11 = tf(arg2_11):Find("item_" .. iter0_11)

		arg0_11.memoryItems[var1_11] = var0_11

		local var2_11 = var0_11.ship_group
		local var3_11 = var0_11.title
		local var4_11 = var0_11.title
		local var5_11 = var0_11.condition
		local var6_11 = var0_11.icon
		local var7_11 = var0_11.year
		local var8_11 = var0_11.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_11.unlock_pre, true)
		local var9_11 = ShipGroup.getDefaultShipConfig(var2_11)

		setActive(var1_11:Find("BG/lock"), not var8_11)
		setActive(var1_11:Find("BG/headline"), var8_11)
		setActive(var1_11:Find("BG/play"), var8_11)

		if var8_11 then
			setText(var1_11:Find("name_bg/name"), var9_11.name)
			setText(var1_11:Find("BG/lock/Text"), var5_11)
			setText(var1_11:Find("wire/yer"), var7_11)
			setText(var1_11:Find("BG/headline/Text"), var4_11)
		else
			setText(var1_11:Find("name_bg/name"), var9_11.name)
			setText(var1_11:Find("BG/headline/Text"), var4_11)
			setText(var1_11:Find("wire/yer"), var7_11)
		end

		setText(var1_11:Find("BG/lock/Text"), var5_11)
		LoadImageSpriteAsync("MemoryIcon/" .. var6_11, var1_11:Find("BG/bg/bg/icon"), true)
	end
end

function var0_0.SetStoryMask(arg0_12, arg1_12)
	arg0_12.memoryMask = arg1_12
end

function var0_0.PlayMemory(arg0_13, arg1_13)
	if arg1_13.type == 1 then
		local var0_13 = findTF(arg0_13.memoryMask, "pic")

		if string.len(arg1_13.mask) > 0 then
			setActive(var0_13, true)

			var0_13:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_13.mask)
		else
			setActive(var0_13, false)
		end

		setActive(arg0_13.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1_13.story, function()
			setActive(arg0_13.memoryMask, false)
		end, true)
	elseif arg1_13.type == 2 then
		local var1_13 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_13.story)

		assert(var1_13 and var1_13 ~= 0, "Missing Story Stage ID: " .. (arg1_13.story or "NIL"))
		arg0_13:emit(WorldMediaCollectionMediator.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1_13
		})
	end
end

return var0_0
