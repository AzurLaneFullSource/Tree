local var0_0 = class("IslandPlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.name = arg1_1.name
	arg0_1.position = Vector3.zero
	arg0_1.rotation = Vector3.zero

	arg0_1:InitDressupData()
end

function var0_0.GetShipId(arg0_2)
	if arg0_2:IsSelf() then
		return IslandConst.SPAWN_PLAYER_ID
	else
		return IslandConst.SPAWN_PLAYER_ID_OTHER
	end
end

function var0_0.IsSelf(arg0_3)
	return arg0_3.id == getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetName(arg0_4)
	return arg0_4.name
end

function var0_0.SetPosition(arg0_5, arg1_5)
	arg0_5.position = arg1_5
end

function var0_0.SetRotation(arg0_6, arg1_6)
	arg0_6.rotation = arg1_6
end

function var0_0.UpdateName(arg0_7, arg1_7)
	arg0_7.name = arg1_7
end

function var0_0.InitDressupData(arg0_8)
	arg0_8.dressupData = {}
end

function var0_0.ChangeDressUpByType(arg0_9, arg1_9, arg2_9)
	arg0_9.dressupData[arg1_9] = arg2_9
end

function var0_0.GetDressupData(arg0_10)
	return arg0_10.dressupData
end

return var0_0
