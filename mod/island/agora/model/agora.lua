local var0_0 = class("Agora", import(".AgoraPlaceableArea"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.size, arg1_1.placedlist)

	arg0_1.placeableList = arg1_1.placeableList
end

function var0_0.AddPlaceableList(arg0_2, arg1_2)
	arg0_2.placeableList[arg1_2.id] = arg1_2
end

function var0_0.GetPlaceableList(arg0_3)
	return arg0_3.placeableList
end

function var0_0.GetPlaceableItem(arg0_4, arg1_4)
	return arg0_4.placeableList[arg1_4]
end

function var0_0.PlaceItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.placeableList[arg1_5]

	var0_5:UpdatePosition(arg2_5)
	arg0_5:AddItem(var0_5)
	arg0_5:DispatchEvent(ISLAND_AGORA_EVT.GEN_ITEM, var0_5)
end

function var0_0.UnPlaceItem(arg0_6, arg1_6)
	local var0_6 = arg0_6.placeableList[arg1_6]

	arg0_6:RemoveItem(var0_6)
	arg0_6:DispatchEvent(ISLAND_AGORA_EVT.REMOVE_ITEM, var0_6)
end

return var0_0
