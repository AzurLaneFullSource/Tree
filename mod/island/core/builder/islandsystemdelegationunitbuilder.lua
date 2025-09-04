local var0_0 = class("IslandSystemDelegationUnitBuilder", import(".IslandSystemNpcBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandSystemDelegationUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_NPC
end

return var0_0
