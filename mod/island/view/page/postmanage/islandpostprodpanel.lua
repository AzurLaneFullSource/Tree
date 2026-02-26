local var0_0 = class("IslandPostProdPanel", import("view.base.BaseSubView"))

var0_0.ScrollValue = 0

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

	local var0_6 = arg0_6.scrollRect.onValueChanged

	var0_6:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0_6, var0_6)
	var0_6:AddListener(function(arg0_7)
		var0_0.ScrollValue = arg0_7.y
	end)
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = IslandPostPlaceCard.New(arg1_8)

	arg0_8.cards[arg1_8] = var0_8
end

function var0_0.OnUpdateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.cards[arg2_9]

	if not var0_9 then
		arg0_9:OnInitItem(arg1_9, arg2_9)

		var0_9 = arg0_9.cards[arg2_9]
	end

	local var1_9 = arg0_9.placeIds[arg1_9 + 1]

	if var1_9 then
		var0_9:Update(var1_9, function(arg0_10)
			arg0_9:OpenSelectPanel(arg0_10)
		end)
	end
end

function var0_0.Show(arg0_11)
	arg0_11.super.Show(arg0_11)

	if arg0_11.flushAll then
		arg0_11:Flush()
	end

	arg0_11.flushAll = false

	arg0_11.scrollRect:ScrollTo(var0_0.ScrollValue)
end

function var0_0.Flush(arg0_12)
	arg0_12.buildingAgency = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	arg0_12.buildings = arg0_12.buildingAgency:GetBuildings()

	arg0_12.scrollRect:SetTotalCount(#arg0_12.placeIds, -1)

	if arg0_12.selectPanel:isShowing() then
		arg0_12.selectPanel:ExecuteAction("Flush")
	end
end

function var0_0.FlushSlot(arg0_13, arg1_13)
	local var0_13 = pg.island_production_slot[arg1_13].place

	for iter0_13, iter1_13 in pairs(arg0_13.cards) do
		if iter1_13.id == var0_13 then
			iter1_13:UpdateSlot(arg1_13)
		end
	end

	if arg0_13.selectPanel:isShowing() then
		arg0_13.selectPanel:ExecuteAction("Flush")
	end
end

function var0_0.OpenSelectPanel(arg0_14, arg1_14)
	arg0_14.selectPanel:ExecuteAction("Show", arg1_14)
end

function var0_0.Hide(arg0_15)
	arg0_15.super.Hide(arg0_15)
	arg0_15.selectPanel:ExecuteAction("Hide")
end

function var0_0.OnDestroy(arg0_16)
	ClearLScrollrect(arg0_16.scrollRect)

	if arg0_16.selectPanel then
		arg0_16.selectPanel:Destroy()

		arg0_16.selectPanel = nil
	end

	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		iter1_16:Dispose()
	end

	arg0_16.cards = {}
end

return var0_0
