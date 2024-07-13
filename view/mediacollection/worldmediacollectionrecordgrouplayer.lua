local var0_0 = class("WorldMediaCollectionRecordGroupLayer", import(".WorldMediaCollectionTemplateLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionRecordGroupUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.scroll = arg0_2._tf:Find("ScrollRect")
	arg0_2.scrollComp = arg0_2.scroll:GetComponent("LScrollRect")

	setActive(arg0_2.scroll:Find("Item"), false)

	arg0_2.content = arg0_2.scroll:Find("Viewport/Content")
	arg0_2.progressText = arg0_2.scroll:Find("ProgressText")
	arg0_2.recordTogGroup = arg0_2:findTF("Toggles", arg0_2._top)
	arg0_2.recordToggles = {
		arg0_2:findTF("0", arg0_2.recordTogGroup),
		arg0_2:findTF("1", arg0_2.recordTogGroup),
		arg0_2:findTF("2", arg0_2.recordTogGroup),
		arg0_2:findTF("3", arg0_2.recordTogGroup)
	}
	arg0_2.recordFilterIndex = {
		false,
		false,
		false
	}

	_.each(pg.world_collection_record_group.all, function(arg0_3)
		local var0_3 = pg.world_collection_record_group[arg0_3]

		arg0_2.recordFilterIndex[var0_3.type] = true
	end)

	local var0_2 = #arg0_2.recordFilterIndex
	local var1_2

	for iter0_2 = 1, #arg0_2.recordFilterIndex do
		setActive(arg0_2.recordToggles[1 + iter0_2], arg0_2.recordFilterIndex[iter0_2])

		if not arg0_2.recordFilterIndex[iter0_2] then
			var0_2 = var0_2 - 1
		else
			var1_2 = var1_2 or iter0_2 + 1
		end
	end

	setActive(arg0_2.recordToggles[1], var0_2 > 1)

	var1_2 = var0_2 <= 1 and var1_2 or 1

	local var2_2 = arg0_2.contextData.toggle or var1_2

	arg0_2.contextData.toggle = nil

	triggerToggle(arg0_2.recordToggles[var2_2], true)
	arg0_2:SwitchRecordFilter(var2_2)

	for iter1_2, iter2_2 in ipairs(arg0_2.recordToggles) do
		onToggle(arg0_2, iter2_2, function(arg0_4)
			if not arg0_4 then
				return
			end

			arg0_2:SwitchRecordFilter(iter1_2)
			arg0_2:RecordFilter()
		end, SFX_UI_TAG)
	end

	function arg0_2.scrollComp.onUpdateItem(arg0_5, arg1_5)
		arg0_2:OnUpdateGroup(arg0_5 + 1, arg1_5)
	end

	arg0_2.recordGroups = {}

	arg0_2.viewParent:Add2TopContainer(arg0_2.recordTogGroup)

	arg0_2.loader = AutoLoader.New()

	setText(arg0_2.scroll:Find("ProgressDesc"), i18n("world_collection_3"))
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)
	setActive(arg0_6.recordTogGroup, true)
end

function var0_0.Hide(arg0_7)
	LeanTween.cancel(go(arg0_7.content))
	arg0_7.scrollComp:SetDraggingStatus(false)
	arg0_7.scrollComp:StopMovement()

	arg0_7.scrolling = false

	var0_0.super.Hide(arg0_7)
	setActive(arg0_7.recordTogGroup, false)
	var0_0.super.Hide(arg0_7)
end

local var1_0 = {
	"img_zhuxian",
	"img_zhixian",
	"img_shoujijilu"
}

function var0_0.OnUpdateGroup(arg0_8, arg1_8, arg2_8)
	if arg0_8.exited then
		return
	end

	local var0_8 = arg0_8.recordGroups[arg1_8]

	assert(var0_8, "Not Initialize FileGroup Index " .. arg1_8)

	local var1_8 = tf(arg2_8)

	setText(var1_8:Find("FileIndex"), var0_8.id)

	local var2_8 = var1_8:Find("NameRect/FileName1")
	local var3_8 = GetPerceptualSize(var0_8.name_abbreviate)
	local var4_8
	local var5_8

	var5_8.fontSize, var5_8 = var3_8 <= 4 and 32 or var3_8 <= 6 and 28 or 24, var2_8:GetComponent(typeof(Text))
	var5_8.text = var0_8.name_abbreviate

	arg0_8.loader:GetSprite("ui/WorldMediaCollectionRecordUI_atlas", var1_0[var0_8.type], var1_8:Find("BG"))

	local var6_8 = nowWorld():GetCollectionProxy()
	local var7_8 = #var0_8.child
	local var8_8 = _.reduce(var0_8.child, 0, function(arg0_9, arg1_9)
		local var0_9 = WorldCollectionProxy.GetCollectionTemplate(arg1_9)

		if var0_9 and WorldMediaCollectionRecordDetailLayer.CheckRecordIsUnlock(var0_9) then
			arg0_9 = arg0_9 + 1
		end

		return arg0_9
	end)

	setText(var1_8:Find("FileProgress"), var8_8 .. "/" .. var7_8)

	local var9_8 = arg0_8.scroll.rect.width
	local var10_8 = arg0_8.scroll:Find("Item").rect.width
	local var11_8 = arg0_8.content:GetComponent(typeof(HorizontalLayoutGroup))
	local var12_8 = var11_8.padding.left
	local var13_8 = var11_8.spacing

	onButton(arg0_8, var1_8, function()
		arg0_8.viewParent:ShowRecordGroup(var0_8.id)
	end, SFX_PANEL)
end

function var0_0.SwitchRecordFilter(arg0_11, arg1_11)
	if arg1_11 == 1 then
		arg0_11.recordFilterIndex = {
			true,
			true,
			true
		}
	else
		for iter0_11 in ipairs(arg0_11.recordFilterIndex) do
			arg0_11.recordFilterIndex[iter0_11] = arg1_11 - 1 == iter0_11
		end
	end
end

function var0_0.RecordFilter(arg0_12)
	table.clear(arg0_12.recordGroups)

	local var0_12 = 0
	local var1_12 = 0

	_.each(pg.world_collection_record_group.all, function(arg0_13)
		local var0_13 = pg.world_collection_record_group[arg0_13]
		local var1_13 = _.reduce(var0_13.child, 0, function(arg0_14, arg1_14)
			local var0_14 = WorldCollectionProxy.GetCollectionTemplate(arg1_14)

			if var0_14 and WorldMediaCollectionRecordDetailLayer.CheckRecordIsUnlock(var0_14) then
				arg0_14 = arg0_14 + 1
			end

			return arg0_14
		end)

		var0_12 = var0_12 + #var0_13.child
		var1_12 = var1_12 + var1_13

		if arg0_12.recordFilterIndex[var0_13.type] then
			table.insert(arg0_12.recordGroups, var0_13)
		end
	end)
	setText(arg0_12.progressText, var1_12 .. "/" .. var0_12)
	table.sort(arg0_12.recordGroups, function(arg0_15, arg1_15)
		return arg0_15.id < arg1_15.id
	end)
	arg0_12.scrollComp:SetTotalCount(#arg0_12.recordGroups)
end

return var0_0
