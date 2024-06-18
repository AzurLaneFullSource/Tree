local var0_0 = class("WorldMediaCollectionRecordDetailLayer", import(".WorldMediaCollectionSubLayer"))

var0_0.TypeStory = 1
var0_0.TypeBattle = 2

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionMemoryDetailUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)
	setActive(arg0_2._tf:Find("ItemRect/TitleRecord"), true)
	setActive(arg0_2._tf:Find("ItemRect/TitleMemory"), false)

	arg0_2.recordItemList = arg0_2:findTF("ItemRect"):GetComponent("LScrollRect")

	function arg0_2.recordItemList.onInitItem(arg0_3)
		arg0_2:OnInitRecordItem(arg0_3)
	end

	function arg0_2.recordItemList.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateRecordItem(arg0_4 + 1, arg1_4)
	end

	arg0_2.recordItems = {}

	local var0_2 = arg0_2:findTF("Item", arg0_2.recordItemList)

	setActive(var0_2, false)

	arg0_2.loader = AutoLoader.New()

	setText(arg0_2._tf:Find("ItemRect/ProgressDesc"), i18n("world_collection_2"))
end

function var0_0.OnInitRecordItem(arg0_5, arg1_5)
	if arg0_5.exited then
		return
	end

	onButton(arg0_5, arg1_5, function()
		local var0_6 = arg0_5.recordItems[arg1_5]
		local var1_6 = nowWorld():GetCollectionProxy()

		if var0_6 and arg0_5.CheckRecordIsUnlock(var0_6) then
			arg0_5:PlayMemory(var0_6)
		end
	end, SOUND_BACK)
end

function var0_0.OnUpdateRecordItem(arg0_7, arg1_7, arg2_7)
	if arg0_7.exited then
		return
	end

	local var0_7 = arg0_7.records and arg0_7.records[arg1_7]

	assert("Not Initialize RecordGroups ID: " .. (arg0_7.contextData.recordGroup or "NIL"))

	arg0_7.recordItems[arg2_7] = var0_7

	local var1_7 = tf(arg2_7)

	if arg0_7.CheckRecordIsUnlock(var0_7) then
		setActive(var1_7:Find("normal"), true)
		setActive(var1_7:Find("lock"), false)

		var1_7:Find("normal/title"):GetComponent(typeof(Text)).text = var0_7.name

		arg0_7.loader:GetSpriteQuiet("memoryicon/" .. var0_7.icon, "", var1_7:Find("normal"))
		setText(var1_7:Find("normal/id"), string.format("#%u", var0_7.group_ID))
	else
		setActive(var1_7:Find("normal"), false)
		setActive(var1_7:Find("lock"), true)
		setText(var1_7:Find("lock/condition"), var0_7.condition)
	end

	onButton(arg0_7, var1_7, function()
		if not arg0_7.CheckRecordIsUnlock(var0_7) then
			return
		end

		arg0_7:PlayMemory(var0_7)
	end, SFX_PANEL)
end

function var0_0.SetStoryMask(arg0_9, arg1_9)
	arg0_9.memoryMask = arg1_9
end

function var0_0.PlayMemory(arg0_10, arg1_10)
	if arg1_10.type == var0_0.TypeBattle then
		local var0_10 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_10.story)

		arg0_10:emit(WorldMediaCollectionMediator.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var0_10
		})
	else
		local var1_10 = findTF(arg0_10.memoryMask, "pic")

		if string.len(arg1_10.mask) > 0 then
			setActive(var1_10, true)

			var1_10:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_10.mask)
		else
			setActive(var1_10, false)
		end

		setActive(arg0_10.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1_10.story, function()
			setActive(arg0_10.memoryMask, false)
		end, true)
	end
end

function var0_0.ShowRecordGroup(arg0_12, arg1_12)
	arg0_12.contextData.recordGroup = arg1_12

	local var0_12 = WorldCollectionProxy.GetCollectionRecordGroupTemplate(arg1_12)

	assert("Missing Record Group Config ID: " .. (arg1_12 or "NIL"))

	arg0_12.records = _.map(var0_12.child, function(arg0_13)
		return WorldCollectionProxy.GetCollectionTemplate(arg0_13)
	end)

	arg0_12.recordItemList:SetTotalCount(#arg0_12.records, 0)

	local var1_12 = #arg0_12.records
	local var2_12 = _.reduce(arg0_12.records, 0, function(arg0_14, arg1_14)
		if arg0_12.CheckRecordIsUnlock(arg1_14) then
			arg0_14 = arg0_14 + 1
		end

		return arg0_14
	end)

	setText(arg0_12._tf:Find("ItemRect/ProgressText"), var2_12 .. "/" .. var1_12)
end

function var0_0.CheckRecordIsUnlock(arg0_15)
	return nowWorld():GetCollectionProxy():IsUnlock(arg0_15.id) or pg.NewStoryMgr.GetInstance():IsPlayed(arg0_15.story, true)
end

function var0_0.CleanList(arg0_16)
	arg0_16.records = nil

	arg0_16.recordItemList:SetTotalCount(0)
end

return var0_0
