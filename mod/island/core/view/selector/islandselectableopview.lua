local var0_0 = class("IslandSelectableOpView", import("Mod.Island.Core.View.IslandASynLoadAndCacheSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandSelectableOpUI"
end

function var0_0.SetUIParent(arg0_2, arg1_2)
	return arg0_2:GetView().topContainer
end

function var0_0.FirstFlush(arg0_3)
	arg0_3.frameTr = arg0_3._tf:Find("list")
	arg0_3.cotainer = arg0_3._tf:Find("list/content")
	arg0_3.tpl = arg0_3._tf:Find("list/content/item")
	arg0_3.gridLayoutGroup = arg0_3.cotainer:GetComponent(typeof(GridLayoutGroup))
	arg0_3.uiItemList = UIItemList.New(arg0_3.cotainer, arg0_3.tpl)
	arg0_3.descPanle = IslandSelectableDescPanel.New(arg0_3._tf:Find("desc"), arg0_3:IsShowItemCount())

	onButton(arg0_3, arg0_3._tf, function()
		if arg0_3.descPanle:IsShowing() then
			arg0_3.descPanle:Hide()

			return
		end

		arg0_3:Dispose()
	end, SFX_PANEL)
end

function var0_0.Filter(arg0_5, arg1_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg1_5) do
		assert(isa(iter1_5, IslandItem), "v is not a IslandItem")

		if iter1_5:GetCount() > 0 then
			table.insert(var0_5, iter1_5)
		end
	end

	arg0_5:Sort(var0_5)

	return var0_5
end

function var0_0.Sort(arg0_6, arg1_6)
	table.sort(arg1_6, function(arg0_7, arg1_7)
		local var0_7 = arg0_7:GetRarity()
		local var1_7 = arg1_7:GetRarity()

		if var0_7 == var1_7 then
			return arg0_7.id > arg1_7.id
		else
			return var1_7 < var0_7
		end
	end)
end

function var0_0.Flush(arg0_8)
	arg0_8.selectedId = arg0_8:GetSelectedId()
	arg0_8.displays = arg0_8:Filter(arg0_8:GetDisplayData())

	seriesAsync({
		function(arg0_9)
			arg0_8:PreloadList(arg0_9)
		end
	}, function()
		arg0_8:UpdateLayout()
		arg0_8:UpdateList()
	end)
end

function var0_0.PreloadList(arg0_11, arg1_11)
	local var0_11 = arg0_11.displays

	if #var0_11 <= 5 then
		arg1_11()

		return
	end

	local var1_11 = {}

	for iter0_11, iter1_11 in ipairs(var0_11) do
		table.insert(var1_11, function(arg0_12)
			cloneTplTo(arg0_11.tpl, arg0_11.cotainer)

			if iter0_11 % 3 == 0 then
				onNextTick(arg0_12)
			else
				arg0_12()
			end
		end)
	end

	seriesAsync(var1_11, arg1_11)
end

function var0_0.UpdateLayout(arg0_13)
	local var0_13 = arg0_13.displays
	local var1_13 = arg0_13:GetMaxHrzCnt()
	local var2_13 = math.min(#var0_13, var1_13)

	arg0_13.gridLayoutGroup.constraintCount = var2_13

	local var3_13 = arg0_13:GetTargetTr()

	arg0_13.frameTr.position = var0_0.TrPosition2LocalPos(var3_13.parent, arg0_13.frameTr.parent, var3_13.position)
end

function var0_0.TrPosition2LocalPos(arg0_14, arg1_14, arg2_14)
	if arg0_14 == arg1_14 then
		return arg2_14
	else
		local var0_14 = arg0_14:TransformPoint(arg2_14)
		local var1_14 = arg1_14:InverseTransformPoint(var0_14)

		return Vector3(var1_14.x, var1_14.y, 0)
	end
end

function var0_0.UpdateList(arg0_15)
	local var0_15 = arg0_15.displays

	arg0_15.uiItemList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg0_15:UpdateItem(arg2_16, var0_15[arg1_16 + 1])
		end
	end)
	arg0_15.uiItemList:align(#var0_15)
	arg0_15:UpdateSelected()
end

function var0_0.UpdateItem(arg0_17, arg1_17, arg2_17)
	assert(isa(arg2_17, IslandItem), "islandItem is not a IslandItem")
	updateCustomDrop(arg1_17, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg2_17.id,
		count = arg2_17:GetCount()
	}))
	setActive(arg1_17:Find("icon_bg/count_bg"), arg0_17:IsShowItemCount())

	local var0_17 = false

	onButton(arg0_17, arg1_17, function()
		if var0_17 then
			var0_17 = false

			return
		end

		arg0_17.selectedId = arg2_17.id

		arg0_17:UpdateSelected()
		arg0_17:OnSelected(arg2_17.id)
		arg0_17:Dispose()
	end, SFX_PANEL)

	local var1_17 = GetOrAddComponent(arg1_17, typeof(UILongPressTrigger))

	var1_17.onLongPressed:RemoveAllListeners()
	var1_17.onLongPressed:AddListener(function()
		var0_17 = true

		arg0_17.descPanle:Show(arg1_17.position, arg2_17)
	end)
end

function var0_0.UpdateSelected(arg0_20)
	local var0_20 = arg0_20.displays

	arg0_20.uiItemList:eachActive(function(arg0_21, arg1_21)
		local var0_21 = var0_20[arg0_21 + 1]

		setActive(arg1_21:Find("select"), arg0_20.selectedId == var0_21.id)
	end)
end

function var0_0.OnHide(arg0_22)
	arg0_22.descPanle:Hide()

	arg0_22.selectedId = nil

	arg0_22.uiItemList:each(function(arg0_23, arg1_23)
		GetOrAddComponent(arg1_23, typeof(UILongPressTrigger)).onLongPressed:RemoveAllListeners()
	end)
end

function var0_0.OnDestroy(arg0_24)
	if arg0_24.descPanle then
		arg0_24.descPanle:Dispose()

		arg0_24.descPanle = nil
	end
end

function var0_0.GetDisplayData(arg0_25)
	assert(false, "over write me")
end

function var0_0.GetTargetTr(arg0_26)
	assert(false, "over write me")
end

function var0_0.IsShowItemCount(arg0_27)
	return true
end

function var0_0.GetSelectedId(arg0_28)
	return 0
end

function var0_0.OnSelected(arg0_29, arg1_29)
	return
end

function var0_0.GetMaxHrzCnt(arg0_30)
	return 7
end

return var0_0
