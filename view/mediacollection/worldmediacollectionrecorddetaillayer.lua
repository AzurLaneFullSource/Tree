local var0 = class("WorldMediaCollectionRecordDetailLayer", import(".WorldMediaCollectionSubLayer"))

var0.TypeStory = 1
var0.TypeBattle = 2

function var0.getUIName(arg0)
	return "WorldMediaCollectionMemoryDetailUI"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	assert(arg0.viewParent, "Need assign ViewParent for " .. arg0.__cname)
	setActive(arg0._tf:Find("ItemRect/TitleRecord"), true)
	setActive(arg0._tf:Find("ItemRect/TitleMemory"), false)

	arg0.recordItemList = arg0:findTF("ItemRect"):GetComponent("LScrollRect")

	function arg0.recordItemList.onInitItem(arg0)
		arg0:OnInitRecordItem(arg0)
	end

	function arg0.recordItemList.onUpdateItem(arg0, arg1)
		arg0:OnUpdateRecordItem(arg0 + 1, arg1)
	end

	arg0.recordItems = {}

	local var0 = arg0:findTF("Item", arg0.recordItemList)

	setActive(var0, false)

	arg0.loader = AutoLoader.New()

	setText(arg0._tf:Find("ItemRect/ProgressDesc"), i18n("world_collection_2"))
end

function var0.OnInitRecordItem(arg0, arg1)
	if arg0.exited then
		return
	end

	onButton(arg0, arg1, function()
		local var0 = arg0.recordItems[arg1]
		local var1 = nowWorld():GetCollectionProxy()

		if var0 and arg0.CheckRecordIsUnlock(var0) then
			arg0:PlayMemory(var0)
		end
	end, SOUND_BACK)
end

function var0.OnUpdateRecordItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.records and arg0.records[arg1]

	assert("Not Initialize RecordGroups ID: " .. (arg0.contextData.recordGroup or "NIL"))

	arg0.recordItems[arg2] = var0

	local var1 = tf(arg2)

	if arg0.CheckRecordIsUnlock(var0) then
		setActive(var1:Find("normal"), true)
		setActive(var1:Find("lock"), false)

		var1:Find("normal/title"):GetComponent(typeof(Text)).text = var0.name

		arg0.loader:GetSpriteQuiet("memoryicon/" .. var0.icon, "", var1:Find("normal"))
		setText(var1:Find("normal/id"), string.format("#%u", var0.group_ID))
	else
		setActive(var1:Find("normal"), false)
		setActive(var1:Find("lock"), true)
		setText(var1:Find("lock/condition"), var0.condition)
	end

	onButton(arg0, var1, function()
		if not arg0.CheckRecordIsUnlock(var0) then
			return
		end

		arg0:PlayMemory(var0)
	end, SFX_PANEL)
end

function var0.SetStoryMask(arg0, arg1)
	arg0.memoryMask = arg1
end

function var0.PlayMemory(arg0, arg1)
	if arg1.type == var0.TypeBattle then
		local var0 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1.story)

		arg0:emit(WorldMediaCollectionMediator.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var0
		})
	else
		local var1 = findTF(arg0.memoryMask, "pic")

		if string.len(arg1.mask) > 0 then
			setActive(var1, true)

			var1:GetComponent(typeof(Image)).sprite = LoadSprite(arg1.mask)
		else
			setActive(var1, false)
		end

		setActive(arg0.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1.story, function()
			setActive(arg0.memoryMask, false)
		end, true)
	end
end

function var0.ShowRecordGroup(arg0, arg1)
	arg0.contextData.recordGroup = arg1

	local var0 = WorldCollectionProxy.GetCollectionRecordGroupTemplate(arg1)

	assert("Missing Record Group Config ID: " .. (arg1 or "NIL"))

	arg0.records = _.map(var0.child, function(arg0)
		return WorldCollectionProxy.GetCollectionTemplate(arg0)
	end)

	arg0.recordItemList:SetTotalCount(#arg0.records, 0)

	local var1 = #arg0.records
	local var2 = _.reduce(arg0.records, 0, function(arg0, arg1)
		if arg0.CheckRecordIsUnlock(arg1) then
			arg0 = arg0 + 1
		end

		return arg0
	end)

	setText(arg0._tf:Find("ItemRect/ProgressText"), var2 .. "/" .. var1)
end

function var0.CheckRecordIsUnlock(arg0)
	return nowWorld():GetCollectionProxy():IsUnlock(arg0.id) or pg.NewStoryMgr.GetInstance():IsPlayed(arg0.story, true)
end

function var0.CleanList(arg0)
	arg0.records = nil

	arg0.recordItemList:SetTotalCount(0)
end

return var0
