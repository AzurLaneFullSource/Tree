local var0 = class("WorldMediaCollectionFileGroupLayer", import(".WorldMediaCollectionSubLayer"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionFileGroupUI"
end

function var0.OnInit(arg0)
	arg0.scroll = arg0._tf:Find("ScrollRect")
	arg0.scrollComp = arg0.scroll:GetComponent("LScrollRect")

	setActive(arg0.scroll:Find("Item"), false)

	arg0.content = arg0.scroll:Find("Viewport/Content")
	arg0.progressText = arg0.scroll:Find("ProgressText")
	arg0.emptyTip = arg0._tf:Find("EmptyTip")
	arg0.fileGroups = {}

	function arg0.scrollComp.onUpdateItem(arg0, ...)
		arg0:OnUpdateFileGroup(arg0 + 1, ...)
	end

	arg0.scrolling = false
	arg0.blurFlag = nil

	setText(arg0.scroll:Find("ProgressDesc"), i18n("world_collection_3"))

	arg0.loader = AutoLoader.New()
end

function var0.UpdateGroupList(arg0)
	local var0 = nowWorld():GetCollectionProxy()

	table.clear(arg0.fileGroups)

	local var1 = 0
	local var2 = 0

	_.each(pg.world_collection_file_group.all, function(arg0)
		local var0 = pg.world_collection_file_group[arg0]
		local var1 = _.reduce(var0.child, 0, function(arg0, arg1)
			if var0:IsUnlock(arg1) then
				arg0 = arg0 + 1
			end

			return arg0
		end)

		if var1 > 0 then
			table.insert(arg0.fileGroups, var0)
		end

		var1 = var1 + #var0.child
		var2 = var2 + var1
	end)

	local var3 = #arg0.fileGroups == 0

	setActive(arg0.emptyTip, var3)

	if var3 then
		arg0:BlurTip()
	else
		arg0:UnBlurTip()
	end

	setActive(arg0.scroll, not var3)
	arg0.scrollComp:SetTotalCount(#arg0.fileGroups)
	setText(arg0.progressText, var2 .. "/" .. var1)
end

function var0.BlurTip(arg0)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.emptyTip, {
		pbList = {
			arg0.emptyTip:Find("EmptyTip")
		},
		groupName = LayerWeightConst.GROUP_COLLECTION,
		weight = LayerWeightConst.BASE_LAYER - 1
	})
	arg0.emptyTip:SetSiblingIndex(0)

	arg0.blurFlag = true
end

function var0.UnBlurTip(arg0)
	if arg0.blurFlag then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.emptyTip, arg0._tf)
	end

	arg0.blurFlag = nil
end

function var0.Show(arg0)
	var0.super.Show(arg0)

	if arg0.blurFlag then
		arg0:BlurTip()
	end
end

function var0.Hide(arg0)
	LeanTween.cancel(go(arg0.content))
	arg0.scrollComp:SetDraggingStatus(false)
	arg0.scrollComp:StopMovement()

	arg0.scrolling = false

	arg0:UnBlurTip()
	var0.super.Hide(arg0)
end

function var0.OnUpdateFileGroup(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.fileGroups[arg1]

	assert(var0, "Not Initialize FileGroup Index " .. arg1)

	local var1 = tf(arg2)

	setText(var1:Find("FileIndex"), var0.id_2)
	arg0.loader:GetSprite("ui/WorldMediaCollectionFileUI_atlas", var0.type, var1:Find("BG"))
	arg0.loader:GetSprite("CollectionFileTitle/" .. var0.name_abbreviate, "", var1:Find("FileTitle"), true)

	local var2 = nowWorld():GetCollectionProxy()
	local var3 = 0
	local var4 = #var0.child

	for iter0, iter1 in ipairs(var0.child) do
		if var2:IsUnlock(iter1) then
			var3 = var3 + 1
		end
	end

	setText(var1:Find("FileProgress"), var3 .. "/" .. var4)

	local var5 = arg0.scroll.rect.width
	local var6 = arg0.scroll:Find("Item").rect.width
	local var7 = arg0.content:GetComponent(typeof(HorizontalLayoutGroup))
	local var8 = var7.padding.left
	local var9 = var7.spacing

	onButton(arg0, var1, function()
		arg0.viewParent:OpenDetailLayer(var0.id, true)
	end, SFX_PANEL)
end

return var0
