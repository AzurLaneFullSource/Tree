local var0_0 = class("IslandStaticUnitBuilder", import(".IslandUnitBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandStaticUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_NPC
end

function var0_0.AddComponents(arg0_3, arg1_3, arg2_3)
	GetOrAddComponent(arg1_3, typeof(WorldObjectItem)):SetItemId(arg2_3.id)
end

return var0_0
