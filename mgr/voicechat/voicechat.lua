local var0_0 = class("VoiceChat")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.bgName = arg1_1.bgName
	arg0_1.shipGroup = arg1_1.shipGroup
	arg0_1.steps = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.scripts or {}) do
		local var0_1 = VoiceChatStep.New(iter1_1)

		table.insert(arg0_1.steps, var0_1)
	end

	arg0_1.branchCode = nil
	arg0_1.skipAll = false
end

function var0_0.GetBgName(arg0_2)
	return arg0_2.bgName
end

function var0_0.GetShipName(arg0_3)
	local var0_3 = ShipGroup.getDefaultShipConfig(arg0_3.shipGroup)

	assert(var0_3, "shipGroup not found:" .. arg0_3.shipGroup)

	return var0_3.name
end

function var0_0.MarkSkip(arg0_4)
	arg0_4.skipAll = true
end

function var0_0.IsSkipAll(arg0_5)
	return arg0_5.skipAll == true
end

function var0_0.SetBranchCode(arg0_6, arg1_6)
	arg0_6.branchCode = arg1_6
end

function var0_0.GetStepByIndex(arg0_7, arg1_7)
	if arg0_7:IsSkipAll() then
		return nil
	end

	local var0_7 = arg0_7.steps[arg1_7]

	if not var0_7 or arg0_7.branchCode and not var0_7:IsSameBranch(arg0_7.branchCode) then
		return nil
	end

	return var0_7
end

return var0_0
