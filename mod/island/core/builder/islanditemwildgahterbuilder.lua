local var0_0 = class("IslandItemWildGahterBuilder", import(".IslandGenericBuilder"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.GetModule(arg0_2, arg1_2, arg2_2)
	return IslandWildGatherUnit.New(arg1_2, arg2_2)
end

function var0_0.SetTag(arg0_3, arg1_3)
	arg1_3.tag = IslandConst.TAG_NPC
end

function var0_0.AddComponents(arg0_4, arg1_4, arg2_4)
	return
end

return var0_0
