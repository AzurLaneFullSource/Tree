local var0_0 = class("IslandAgoraPlacedListMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandAgoraPlacedInfoMsgBox"
end

local function var1_0(arg0_2)
	local var0_2 = {
		go = arg0_2
	}
	local var1_2 = arg0_2.transform:Find("icon"):GetComponent(typeof(Image))
	local var2_2 = arg0_2.transform:Find("name"):GetComponent(typeof(Text))
	local var3_2 = arg0_2.transform:Find("count"):GetComponent(typeof(Text))
	local var4_2 = arg0_2.transform:Find("capacity"):GetComponent(typeof(Text))

	function var0_2.Update(arg0_3)
		var2_2.text = arg0_3.name
		var3_2.text = "X" .. arg0_3.count
		var4_2.text = arg0_3.capacity

		LoadSpriteAsync("island/IslandFurnitureIcon/" .. arg0_3.icon, function(arg0_4)
			var1_2.sprite = arg0_4
		end)
	end

	return var0_2
end

function var0_0.OnLoaded(arg0_5)
	var0_0.super.OnLoaded(arg0_5)
	setText(arg0_5._tf:Find("list/titles/1"), i18n("island_label_furniture"))
	setText(arg0_5._tf:Find("list/titles/2"), i18n("island_label_furniture_cnt"))
	setText(arg0_5._tf:Find("list/titles/3"), i18n("island_label_furniture_capacity"))

	arg0_5.capacityTxt = arg0_5._tf:Find("capacity"):GetComponent(typeof(Text))
	arg0_5.scrollRect = arg0_5._tf:Find("list/scrollrect"):GetComponent("LScrollRect")

	function arg0_5.scrollRect.onInitItem(arg0_6)
		arg0_5:OnInitItem(arg0_6)
	end

	function arg0_5.scrollRect.onUpdateItem(arg0_7, arg1_7)
		arg0_5:OnUpdateItem(arg0_7, arg1_7)
	end

	arg0_5.cards = {}
end

function var0_0.FlushBtn(arg0_8, arg1_8)
	return
end

function var0_0.OnShow(arg0_9)
	arg0_9.settings.content = i18n("island_label_furniture_tip")

	var0_0.super.OnShow(arg0_9)

	local var0_9 = arg0_9.settings.list
	local var1_9 = arg0_9.settings.totalCnt

	arg0_9:UpdateCapacity(var0_9, var1_9)
	arg0_9:UpdateList(var0_9)
end

function var0_0.UpdateCapacity(arg0_10, arg1_10, arg2_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		var0_10 = var0_10 + iter1_10.capacity
	end

	arg0_10.capacityTxt.text = i18n("island_label_furniture_capacity_display") .. var0_10 .. "/" .. arg2_10
end

function var0_0.OnInitItem(arg0_11, arg1_11)
	local var0_11 = var1_0(arg1_11)

	arg0_11.cards[arg1_11] = var0_11
end

function var0_0.OnUpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.cards[arg2_12]

	if not var0_12 then
		arg0_12:OnInitItem(arg2_12)

		var0_12 = arg0_12.cards[arg2_12]
	end

	local var1_12 = arg0_12.settings.list[arg1_12 + 1]

	var0_12.Update(var1_12)
end

function var0_0.UpdateList(arg0_13, arg1_13)
	arg0_13.scrollRect:SetTotalCount(#arg1_13)
end

function var0_0.OnDestroy(arg0_14)
	var0_0.super.OnDestroy(arg0_14)
	ClearLScrollrect(arg0_14.scrollRect)
end

return var0_0
