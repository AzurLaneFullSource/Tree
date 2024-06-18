local var0_0 = class("WorldMediaCollectionFileGroupLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionFileGroupUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.scroll = arg0_2._tf:Find("ScrollRect")
	arg0_2.scrollComp = arg0_2.scroll:GetComponent("LScrollRect")

	setActive(arg0_2.scroll:Find("Item"), false)

	arg0_2.content = arg0_2.scroll:Find("Viewport/Content")
	arg0_2.progressText = arg0_2.scroll:Find("ProgressText")
	arg0_2.emptyTip = arg0_2._tf:Find("EmptyTip")
	arg0_2.fileGroups = {}

	function arg0_2.scrollComp.onUpdateItem(arg0_3, ...)
		arg0_2:OnUpdateFileGroup(arg0_3 + 1, ...)
	end

	arg0_2.scrolling = false
	arg0_2.blurFlag = nil

	setText(arg0_2.scroll:Find("ProgressDesc"), i18n("world_collection_3"))

	arg0_2.loader = AutoLoader.New()
end

function var0_0.UpdateGroupList(arg0_4)
	local var0_4 = nowWorld():GetCollectionProxy()

	table.clear(arg0_4.fileGroups)

	local var1_4 = 0
	local var2_4 = 0

	_.each(pg.world_collection_file_group.all, function(arg0_5)
		local var0_5 = pg.world_collection_file_group[arg0_5]
		local var1_5 = _.reduce(var0_5.child, 0, function(arg0_6, arg1_6)
			if var0_4:IsUnlock(arg1_6) then
				arg0_6 = arg0_6 + 1
			end

			return arg0_6
		end)

		if var1_5 > 0 then
			table.insert(arg0_4.fileGroups, var0_5)
		end

		var1_4 = var1_4 + #var0_5.child
		var2_4 = var2_4 + var1_5
	end)

	local var3_4 = #arg0_4.fileGroups == 0

	setActive(arg0_4.emptyTip, var3_4)

	if var3_4 then
		arg0_4:BlurTip()
	else
		arg0_4:UnBlurTip()
	end

	setActive(arg0_4.scroll, not var3_4)
	arg0_4.scrollComp:SetTotalCount(#arg0_4.fileGroups)
	setText(arg0_4.progressText, var2_4 .. "/" .. var1_4)
end

function var0_0.BlurTip(arg0_7)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_7.emptyTip, {
		pbList = {
			arg0_7.emptyTip:Find("EmptyTip")
		},
		groupName = LayerWeightConst.GROUP_COLLECTION,
		weight = LayerWeightConst.BASE_LAYER - 1
	})
	arg0_7.emptyTip:SetSiblingIndex(0)

	arg0_7.blurFlag = true
end

function var0_0.UnBlurTip(arg0_8)
	if arg0_8.blurFlag then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_8.emptyTip, arg0_8._tf)
	end

	arg0_8.blurFlag = nil
end

function var0_0.Show(arg0_9)
	var0_0.super.Show(arg0_9)

	if arg0_9.blurFlag then
		arg0_9:BlurTip()
	end
end

function var0_0.Hide(arg0_10)
	LeanTween.cancel(go(arg0_10.content))
	arg0_10.scrollComp:SetDraggingStatus(false)
	arg0_10.scrollComp:StopMovement()

	arg0_10.scrolling = false

	arg0_10:UnBlurTip()
	var0_0.super.Hide(arg0_10)
end

function var0_0.OnUpdateFileGroup(arg0_11, arg1_11, arg2_11)
	if arg0_11.exited then
		return
	end

	local var0_11 = arg0_11.fileGroups[arg1_11]

	assert(var0_11, "Not Initialize FileGroup Index " .. arg1_11)

	local var1_11 = tf(arg2_11)

	setText(var1_11:Find("FileIndex"), var0_11.id_2)
	arg0_11.loader:GetSprite("ui/WorldMediaCollectionFileUI_atlas", var0_11.type, var1_11:Find("BG"))
	arg0_11.loader:GetSprite("CollectionFileTitle/" .. var0_11.name_abbreviate, "", var1_11:Find("FileTitle"), true)

	local var2_11 = nowWorld():GetCollectionProxy()
	local var3_11 = 0
	local var4_11 = #var0_11.child

	for iter0_11, iter1_11 in ipairs(var0_11.child) do
		if var2_11:IsUnlock(iter1_11) then
			var3_11 = var3_11 + 1
		end
	end

	setText(var1_11:Find("FileProgress"), var3_11 .. "/" .. var4_11)

	local var5_11 = arg0_11.scroll.rect.width
	local var6_11 = arg0_11.scroll:Find("Item").rect.width
	local var7_11 = arg0_11.content:GetComponent(typeof(HorizontalLayoutGroup))
	local var8_11 = var7_11.padding.left
	local var9_11 = var7_11.spacing

	onButton(arg0_11, var1_11, function()
		arg0_11.viewParent:OpenDetailLayer(var0_11.id, true)
	end, SFX_PANEL)
end

return var0_0
