local var0 = class("WorldMediaCollectionRecordGroupLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionRecordGroupUI"
end

function var0.OnInit(arg0)
	arg0.scroll = arg0._tf:Find("ScrollRect")
	arg0.scrollComp = arg0.scroll:GetComponent("LScrollRect")

	setActive(arg0.scroll:Find("Item"), false)

	arg0.content = arg0.scroll:Find("Viewport/Content")
	arg0.progressText = arg0.scroll:Find("ProgressText")
	arg0.recordTogGroup = arg0:findTF("Toggles", arg0._top)
	arg0.recordToggles = {
		arg0:findTF("0", arg0.recordTogGroup),
		arg0:findTF("1", arg0.recordTogGroup),
		arg0:findTF("2", arg0.recordTogGroup),
		arg0:findTF("3", arg0.recordTogGroup)
	}
	arg0.recordFilterIndex = {
		false,
		false,
		false
	}

	_.each(pg.world_collection_record_group.all, function(arg0)
		local var0 = pg.world_collection_record_group[arg0]

		arg0.recordFilterIndex[var0.type] = true
	end)

	local var0 = #arg0.recordFilterIndex
	local var1

	for iter0 = 1, #arg0.recordFilterIndex do
		setActive(arg0.recordToggles[1 + iter0], arg0.recordFilterIndex[iter0])

		if not arg0.recordFilterIndex[iter0] then
			var0 = var0 - 1
		else
			var1 = var1 or iter0 + 1
		end
	end

	setActive(arg0.recordToggles[1], var0 > 1)

	var1 = var0 <= 1 and var1 or 1

	local var2 = arg0.contextData.toggle or var1

	arg0.contextData.toggle = nil

	triggerToggle(arg0.recordToggles[var2], true)
	arg0:SwitchRecordFilter(var2)

	for iter1, iter2 in ipairs(arg0.recordToggles) do
		onToggle(arg0, iter2, function(arg0)
			if not arg0 then
				return
			end

			arg0:SwitchRecordFilter(iter1)
			arg0:RecordFilter()
		end, SFX_UI_TAG)
	end

	function arg0.scrollComp.onUpdateItem(arg0, arg1)
		arg0:OnUpdateGroup(arg0 + 1, arg1)
	end

	arg0.recordGroups = {}

	arg0.viewParent:Add2TopContainer(arg0.recordTogGroup)

	arg0.loader = AutoLoader.New()

	setText(arg0.scroll:Find("ProgressDesc"), i18n("world_collection_3"))
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	setActive(arg0.recordTogGroup, true)
end

function var0.Hide(arg0)
	LeanTween.cancel(go(arg0.content))
	arg0.scrollComp:SetDraggingStatus(false)
	arg0.scrollComp:StopMovement()

	arg0.scrolling = false

	var0.super.Hide(arg0)
	setActive(arg0.recordTogGroup, false)
	var0.super.Hide(arg0)
end

local var1 = {
	"img_zhuxian",
	"img_zhixian",
	"img_shoujijilu"
}

function var0.OnUpdateGroup(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.recordGroups[arg1]

	assert(var0, "Not Initialize FileGroup Index " .. arg1)

	local var1 = tf(arg2)

	setText(var1:Find("FileIndex"), var0.id)

	local var2 = var1:Find("NameRect/FileName1")
	local var3 = GetPerceptualSize(var0.name_abbreviate)
	local var4
	local var5

	var5.fontSize, var5 = var3 <= 4 and 32 or var3 <= 6 and 28 or 24, var2:GetComponent(typeof(Text))
	var5.text = var0.name_abbreviate

	arg0.loader:GetSprite("ui/WorldMediaCollectionRecordUI_atlas", var1[var0.type], var1:Find("BG"))

	local var6 = nowWorld():GetCollectionProxy()
	local var7 = #var0.child
	local var8 = _.reduce(var0.child, 0, function(arg0, arg1)
		local var0 = WorldCollectionProxy.GetCollectionTemplate(arg1)

		if var0 and WorldMediaCollectionRecordDetailLayer.CheckRecordIsUnlock(var0) then
			arg0 = arg0 + 1
		end

		return arg0
	end)

	setText(var1:Find("FileProgress"), var8 .. "/" .. var7)

	local var9 = arg0.scroll.rect.width
	local var10 = arg0.scroll:Find("Item").rect.width
	local var11 = arg0.content:GetComponent(typeof(HorizontalLayoutGroup))
	local var12 = var11.padding.left
	local var13 = var11.spacing

	onButton(arg0, var1, function()
		arg0.viewParent:ShowRecordGroup(var0.id)
	end, SFX_PANEL)
end

function var0.SwitchRecordFilter(arg0, arg1)
	if arg1 == 1 then
		arg0.recordFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0 in ipairs(arg0.recordFilterIndex) do
			arg0.recordFilterIndex[iter0] = arg1 - 1 == iter0
		end
	end
end

function var0.RecordFilter(arg0)
	table.clear(arg0.recordGroups)

	local var0 = 0
	local var1 = 0

	_.each(pg.world_collection_record_group.all, function(arg0)
		local var0 = pg.world_collection_record_group[arg0]
		local var1 = _.reduce(var0.child, 0, function(arg0, arg1)
			local var0 = WorldCollectionProxy.GetCollectionTemplate(arg1)

			if var0 and WorldMediaCollectionRecordDetailLayer.CheckRecordIsUnlock(var0) then
				arg0 = arg0 + 1
			end

			return arg0
		end)

		var0 = var0 + #var0.child
		var1 = var1 + var1

		if arg0.recordFilterIndex[var0.type] then
			table.insert(arg0.recordGroups, var0)
		end
	end)
	setText(arg0.progressText, var1 .. "/" .. var0)
	table.sort(arg0.recordGroups, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.scrollComp:SetTotalCount(#arg0.recordGroups)
end

return var0
