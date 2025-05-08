local var0_0 = class("IslandAgoraAgency", import(".IslandBaseAgency"))

var0_0.AGORA_UPGRADE = "IslandAgoraAgency:AGORA_UPGRADE"
var0_0.ADD_PLACEMENT = "IslandAgoraAgency:ADD_PLACEMENT"
var0_0.DELETE_PLACEMENT = "IslandAgoraAgency:DELETE_PLACEMENT"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.level = arg1_1.agora.level or 1
	arg0_1.maxLevel = table.getCount(IslandConst.AGORA_LEVEL_2_SIZE)
	arg0_1.furnitures = {}
	arg0_1.placedList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.agora.furniture_list or {}) do
		table.insert(arg0_1.furnitures, IslandFurniture.New(iter1_1))
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.agora.placed_list or {}) do
		table.insert(arg0_1.placedList, IslandPlacementData.New(iter3_1))
	end
end

function var0_0.SetFurnitures(arg0_2, arg1_2)
	arg0_2.furnitures = arg1_2
end

function var0_0.GetLevel(arg0_3)
	return arg0_3.level
end

function var0_0.GetFurnitures(arg0_4)
	return arg0_4.furnitures
end

function var0_0.GetPlacedList(arg0_5)
	return arg0_5.placedList
end

function var0_0.UpdatePlacedList(arg0_6, arg1_6)
	arg0_6.placedList = arg1_6
end

function var0_0.CanUpgrade(arg0_7)
	return arg0_7.level < arg0_7.maxLevel
end

function var0_0.Upgrade(arg0_8)
	arg0_8.level = arg0_8.level + 1

	arg0_8:DispatchEvent(var0_0.AGORA_UPGRADE, arg0_8.level)
end

function var0_0.AddPlacements(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg1_9) do
		local var0_9 = IslandPlacementData.New(iter1_9)

		table.insert(arg0_9.placedList, var0_9)
		arg0_9:DispatchEvent(var0_0.ADD_PLACEMENT, var0_9)
	end
end

function var0_0.DeletePlacements(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg1_10) do
		local var0_10 = _.detect(arg0_10.placedList, function(arg0_11)
			return arg0_11.id == iter1_10.id
		end)

		if var0_10 then
			table.removebyvalue(arg0_10.placedList, var0_10)
			arg0_10:DispatchEvent(var0_0.DELETE_PLACEMENT, var0_10.id)
		end
	end
end

function var0_0.UpdatePlacements(arg0_12, arg1_12)
	arg0_12:DeletePlacements(arg1_12)
	arg0_12:AddPlacements(arg1_12)
end

return var0_0
