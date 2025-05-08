local var0_0 = class("NodeCanvasBaseObject")

function var0_0.Ctor(arg0_1)
	arg0_1.args = {}
	arg0_1.instance = nil
end

function var0_0.Init(arg0_2, arg1_2, arg2_2)
	arg0_2:SetArgs(arg2_2)

	arg0_2.instance = arg1_2
end

function var0_0.SetArgs(arg0_3, arg1_3)
	arg0_3.args = {}

	local var0_3 = arg1_3:GetEnumerator()

	while var0_3:MoveNext() do
		local var1_3 = var0_3.Current

		arg0_3.args[var1_3.Key] = var1_3.Value
	end
end

function var0_0.GetNodeInstance(arg0_4)
	return arg0_4.instance
end

function var0_0.GetRouter(arg0_5)
	local var0_5 = arg0_5:GetNodeInstance()

	if var0_5 then
		return var0_5.router
	end
end

function var0_0.GetElapsedTime(arg0_6)
	local var0_6 = arg0_6:GetNodeInstance()

	if var0_6 then
		return var0_6.elapsedTime
	end

	return 0
end

function var0_0.GetBlackboard(arg0_7)
	local var0_7 = arg0_7:GetNodeInstance()

	if not var0_7 then
		return nil
	end

	return var0_7.blackboard
end

function var0_0.GetBlackboardVariable(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetBlackboard()

	if not var0_8 then
		return nil
	end

	local var1_8 = arg0_8:GetNodeInstance()

	return var0_8:GetVariable(arg1_8).value
end

function var0_0.SetBlackboardVariable(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetBlackboard()

	if not var0_9 then
		return
	end

	var0_9:SetVariableValue(arg1_9, arg2_9)
end

function var0_0.AddBlackboardVariable(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:GetBlackboard()

	if not var0_10 then
		return
	end

	var0_10:AddVariable(arg1_10, arg2_10)
end

function var0_0.GetAgent(arg0_11)
	local var0_11 = arg0_11:GetNodeInstance()

	if not var0_11 then
		return nil
	end

	return var0_11.agent
end

function var0_0.GetComponent(arg0_12, arg1_12)
	return arg0_12:GetAgent():GetComponent(arg1_12)
end

function var0_0.ExistArg(arg0_13, arg1_13)
	assert(arg0_13.args[arg1_13] ~= nil, "arg is null >>>>" .. arg1_13)

	return arg0_13.args[arg1_13] ~= nil
end

function var0_0.GetArgByName(arg0_14, arg1_14)
	return arg0_14.args[arg1_14]
end

function var0_0.GetStringArg(arg0_15, arg1_15)
	if not arg0_15:ExistArg(arg1_15) then
		return ""
	end

	return arg0_15:GetArgByName(arg1_15)
end

function var0_0.GetFloatArg(arg0_16, arg1_16)
	if not arg0_16:ExistArg(arg1_16) then
		return 0
	end

	local var0_16 = arg0_16:GetArgByName(arg1_16)

	return tonumber(var0_16)
end

function var0_0.GetBoolArg(arg0_17, arg1_17)
	if not arg0_17:ExistArg(arg1_17) then
		return false
	end

	local var0_17 = arg0_17:GetArgByName(arg1_17)

	if type(var0_17) == "string" then
		if var0_17 == "true" then
			return true
		end

		return false
	else
		return var0_17
	end
end

return var0_0
