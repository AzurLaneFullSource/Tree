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

function var1_0.SendEvent(arg0_7, arg1_7, arg2_7, arg3_7)
	arg3_7 = arg3_7 or arg0_7.mainOwner

	if arg2_7 == nil then
		arg3_7:SendEvent(arg1_7)
	else
		arg3_7:SendEvent(arg1_7, arg2_7, nil)
	end
end

function var1_0.SendGlobalEvent(arg0_8, arg1_8, arg2_8)
	arg0_8.mainOwner.graph:SendGlobalEvent(arg1_8, arg2_8, nil)
end

function var1_0.RegisterFunc(arg0_9, arg1_9, arg2_9)
	arg0_9.functionDic[arg1_9] = arg2_9
end

function var1_0.CallFunc(arg0_10, arg1_10, ...)
	assert(arg0_10.functionDic[arg1_10], "with out register call:" .. arg1_10)
	arg0_10.functionDic[arg1_10](...)
end

function var1_0.Clear(arg0_11)
	arg0_11.functionDic = nil
	arg0_11.mainOwner = nil
	arg0_11.mainBlackboard = nil
end

function LuaActionTaskCall(arg0_12, ...)
	local var0_12 = var0_0.NodeCanvasMgr.GetInstance()

	assert(var0_12 and var0_12.functionDic)
	var0_12:CallFunc(arg0_12, ...)
end
