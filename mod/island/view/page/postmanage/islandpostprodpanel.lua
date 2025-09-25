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

	arg0_2.selectPanel = IslandDelegationSelectPanel.New(arg0_2._tf, arg0_2.event, {
		isPost = true
	})
end

function var0_0.OnInit(arg0_5)
	arg0_5.placeIds = pg.island_set.post_manage_produce.key_value_varchar
	arg0_5.cards = {}
	arg0_5.flushAll = true
end

function var0_0.OnInitItem(arg0_6, arg1_6)
	local var0_6 = IslandPostPlaceCard.New(arg1_6)

	arg0_6.cards[arg1_6] = var0_6
end

function var0_0.OnUpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.cards[arg2_7]

	if not var0_7 then
		arg0_7:OnInitItem(arg1_7, arg2_7)

		var0_7 = arg0_7.cards[arg2_7]
	end

	local var1_7 = arg0_7.placeIds[arg1_7 + 1]

	if var1_7 then
		var0_7:Update(var1_7, function(arg0_8)
			arg0_7:OpenSelectPanel(arg0_8)
		end)
	end
end

function var0_0.Show(arg0_9)
	arg0_9.super.Show(arg0_9)

	if arg0_9.flushAll then
		arg0_9:Flush()
	end

	arg0_9.flushAll = false
end

function var0_0.Flush(arg0_10)
	arg0_10.buildingAgency = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	arg0_10.buildings = arg0_10.buildingAgency:GetBuildings()

	arg0_10.scrollRect:SetTotalCount(#arg0_10.placeIds, -1)

	if arg0_10.selectPanel:isShowing() then
		arg0_10.selectPanel:ExecuteAction("Flush")
	end
end

function var0_0.FlushSlot(arg0_11, arg1_11)
	local var0_11 = pg.island_production_slot[arg1_11].place

	for iter0_11, iter1_11 in pairs(arg0_11.cards) do
		if iter1_11.id == var0_11 then
			iter1_11:UpdateSlot(arg1_11)
		end
	end

	if arg0_11.selectPanel:isShowing() then
		arg0_11.selectPanel:ExecuteAction("Flush")
	end
end

function var0_0.OpenSelectPanel(arg0_12, arg1_12)
	arg0_12.selectPanel:ExecuteAction("Show", arg1_12)
end

function var0_0.Hide(arg0_13)
	arg0_13.super.Hide(arg0_13)
	arg0_13.selectPanel:ExecuteAction("Hide")
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.selectPanel then
		arg0_14.selectPanel:Destroy()

		arg0_14.selectPanel = nil
	end

	for iter0_14, iter1_14 in pairs(arg0_14.cards) do
		iter1_14:Dispose()
	end

	arg0_14.cards = {}
end

return var0_0
