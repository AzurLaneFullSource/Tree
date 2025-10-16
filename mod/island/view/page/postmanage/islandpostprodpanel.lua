local var0_0 = class("IslandPostProdPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandPostProdPanel"
end

function var0_0.OnLoaded(arg0_2)
	setActive(arg0_2._tf:Find("tpl"), false)

	arg0_2.scrollRect = arg0_2._tf:Find("view"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.selectPanel = IslandDelegationSelectPanel.New(arg0_2._tf, arg0_2.event, setmetatable({
		isPost = true,
		ShowMsgBox = function(arg0_5, arg1_5)
			arg0_2.contextData:ShowMsgBox(arg1_5)
		end
	}, {
		__index = arg0_2.contextData
	}))
end

function var0_0.OnInit(arg0_6)
	arg0_6.placeIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_6.cards = {}
	arg0_6.flushAll = true
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = IslandPostPlaceCard.New(arg1_7)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cards[arg2_8]

	if not var0_8 then
		arg0_8:OnInitItem(arg1_8, arg2_8)

		var0_8 = arg0_8.cards[arg2_8]
	end

	local var1_8 = arg0_8.placeIds[arg1_8 + 1]

	if var1_8 then
		var0_8:Update(var1_8, function(arg0_9)
			arg0_8:OpenSelectPanel(arg0_9)
		end)
	end
end

function var0_0.Show(arg0_10)
	arg0_10.super.Show(arg0_10)

	if arg0_10.flushAll then
		arg0_10:Flush()
	end

	arg0_10.flushAll = false
end

function var0_0.Flush(arg0_11)
	arg0_11.buildingAgency = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	arg0_11.buildings = arg0_11.buildingAgency:GetBuildings()

	arg0_11.scrollRect:SetTotalCount(#arg0_11.placeIds, -1)

	if arg0_11.selectPanel:isShowing() then
		arg0_11.selectPanel:ExecuteAction("Flush")
	end
end

function var0_0.FlushSlot(arg0_12, arg1_12)
	local var0_12 = pg.island_production_slot[arg1_12].place

	for iter0_12, iter1_12 in pairs(arg0_12.cards) do
		if iter1_12.id == var0_12 then
			iter1_12:UpdateSlot(arg1_12)
		end
	end

	if arg0_12.selectPanel:isShowing() then
		arg0_12.selectPanel:ExecuteAction("Flush")
	end
end

function var0_0.OpenSelectPanel(arg0_13, arg1_13)
	arg0_13.selectPanel:ExecuteAction("Show", arg1_13)
end

function var0_0.Hide(arg0_14)
	arg0_14.super.Hide(arg0_14)
	arg0_14.selectPanel:ExecuteAction("Hide")
end

function var0_0.OnDestroy(arg0_15)
	ClearLScrollrect(arg0_15.scrollRect)

	if arg0_15.selectPanel then
		arg0_15.selectPanel:Destroy()

		arg0_15.selectPanel = nil
	end

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		iter1_15:Dispose()
	end

	arg0_15.cards = {}
end

return var0_0
