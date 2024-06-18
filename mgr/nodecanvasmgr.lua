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

function var1_0.SetOwner(arg0_3, arg1_3)
	assert(not arg0_3.mainOwner)

	arg0_3.mainOwner = GetComponent(arg1_3, "GraphOwner")
	arg0_3.mainBlackboard = GetComponent(arg1_3, "Blackboard")
end

function var1_0.SetBlackboradValue(arg0_4, arg1_4, arg2_4, arg3_4)
	arg3_4 = arg3_4 or arg0_4.mainBlackboard

	if arg2_4 == nil then
		arg3_4:RemoveVariable(arg1_4)
	else
		arg3_4:SetVariableValue(arg1_4, arg2_4)
	end
end

function var1_0.SendEvent(arg0_5, arg1_5, arg2_5, arg3_5)
	arg3_5 = arg3_5 or arg0_5.mainOwner

	if arg2_5 == nil then
		arg3_5:SendEvent(arg1_5)
	else
		arg3_5:SendEvent(arg1_5, arg2_5, nil)
	end
end

function var1_0.SendGlobalEvent(arg0_6, arg1_6, arg2_6)
	arg0_6.mainOwner.graph:SendGlobalEvent(arg1_6, arg2_6, nil)
end

function var1_0.RegisterFunc(arg0_7, arg1_7, arg2_7)
	arg0_7.functionDic[arg1_7] = arg2_7
end

function var1_0.CallFunc(arg0_8, arg1_8, ...)
	assert(arg0_8.functionDic[arg1_8], "with out register call:" .. arg1_8)
	arg0_8.functionDic[arg1_8](...)
end

function var1_0.Clear(arg0_9)
	arg0_9.mainOwner = nil
	arg0_9.functionDic = {}
end

function LuaActionTaskCall(arg0_10, ...)
	local var0_10 = var0_0.NodeCanvasMgr.GetInstance()

	assert(var0_10 and var0_10.mainOwner)
	var0_10:CallFunc(arg0_10, ...)
end
