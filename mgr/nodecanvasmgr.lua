pg = pg or {}

local var0_0 = pg

var0_0.NodeCanvasMgr = singletonClass("NodeCanvasMgr")

local var1_0 = var0_0.NodeCanvasMgr

function var1_0.Ctor(arg0_1)
	arg0_1:Clear()
end

function var1_0.Init(arg0_2, arg1_2)
	print("initializing NodeCanvas manager...")
	existCall(arg1_2)
end

function var1_0.Active(arg0_3, arg1_3)
	assert(not arg0_3.functionDic)

	arg0_3.functionDic = {}

	if arg1_3 then
		arg0_3:SetOwner(arg1_3)
	end
end

function var1_0.SetOwner(arg0_4, arg1_4)
	arg0_4.mainOwner = GetComponent(arg1_4, "GraphOwner")
	arg0_4.mainBlackboard = GetComponent(arg1_4, "Blackboard")
end

function var1_0.SetBlackboradValue(arg0_5, arg1_5, arg2_5, arg3_5)
	arg3_5 = arg3_5 or arg0_5.mainBlackboard

	if arg2_5 == nil then
		arg3_5:RemoveVariable(arg1_5)
	else
		arg3_5:SetVariableValue(arg1_5, arg2_5)
	end
end

function var1_0.GetBlackboradValue(arg0_6, arg1_6, arg2_6)
	arg2_6 = arg2_6 or arg0_6.mainBlackboard

	return arg2_6:GetVariable(arg1_6).value
end

function var1_0.CopyAllBlackBoardValue(arg0_7, arg1_7, arg2_7)
	local var0_7 = ReflectionHelp.RefGetProperty(typeof("NodeCanvas.Framework.IBlackboard"), "variables", arg1_7):GetEnumerator()

	while var0_7:MoveNext() do
		local var1_7 = var0_7.Current
		local var2_7 = var1_7.Key
		local var3_7 = var1_7.Value.value

		if type(var3_7) == "number" then
			-- block empty
		else
			arg0_7:SetBlackboradValue(var2_7, var3_7, arg2_7)
		end
	end
end

function var1_0.SendEvent(arg0_8, arg1_8, arg2_8, arg3_8)
	arg3_8 = arg3_8 or arg0_8.mainOwner

	if arg2_8 == nil then
		arg3_8:SendEvent(arg1_8)
	else
		arg3_8:SendEvent(arg1_8, arg2_8, nil)
	end
end

function var1_0.SendGlobalEvent(arg0_9, arg1_9, arg2_9)
	arg0_9.mainOwner.graph:SendGlobalEvent(arg1_9, arg2_9, nil)
end

function var1_0.RegisterFunc(arg0_10, arg1_10, arg2_10)
	arg0_10.functionDic[arg1_10] = arg2_10
end

function var1_0.UnregisterFunc(arg0_11, arg1_11)
	if arg0_11.functionDic[arg1_11] then
		arg0_11.functionDic[arg1_11] = nil
	else
		warning("NodeCanvasMgr UnregisterFunc not found:" .. arg1_11)
	end
end

function var1_0.CallFunc(arg0_12, arg1_12, ...)
	assert(arg0_12.functionDic[arg1_12], "with out register call:" .. arg1_12)
	arg0_12.functionDic[arg1_12](...)
end

function var1_0.Clear(arg0_13)
	arg0_13.functionDic = nil
	arg0_13.mainOwner = nil
	arg0_13.mainBlackboard = nil
end

function LuaActionTaskCall(arg0_14, ...)
	local var0_14 = var0_0.NodeCanvasMgr.GetInstance()

	assert(var0_14 and var0_14.functionDic)
	var0_14:CallFunc(arg0_14, ...)
end
