pg = pg or {}

local var0 = pg

var0.NodeCanvasMgr = singletonClass("NodeCanvasMgr")

local var1 = var0.NodeCanvasMgr

function var1.Ctor(arg0)
	arg0:Clear()
end

function var1.Init(arg0, arg1)
	print("initializing NodeCanvas manager...")
	existCall(arg1)
end

function var1.SetOwner(arg0, arg1)
	assert(not arg0.mainOwner)

	arg0.mainOwner = GetComponent(arg1, "GraphOwner")
	arg0.mainBlackboard = GetComponent(arg1, "Blackboard")
end

function var1.SetBlackboradValue(arg0, arg1, arg2, arg3)
	arg3 = arg3 or arg0.mainBlackboard

	if arg2 == nil then
		arg3:RemoveVariable(arg1)
	else
		arg3:SetVariableValue(arg1, arg2)
	end
end

function var1.SendEvent(arg0, arg1, arg2, arg3)
	arg3 = arg3 or arg0.mainOwner

	if arg2 == nil then
		arg3:SendEvent(arg1)
	else
		arg3:SendEvent(arg1, arg2, nil)
	end
end

function var1.SendGlobalEvent(arg0, arg1, arg2)
	arg0.mainOwner.graph:SendGlobalEvent(arg1, arg2, nil)
end

function var1.RegisterFunc(arg0, arg1, arg2)
	arg0.functionDic[arg1] = arg2
end

function var1.CallFunc(arg0, arg1, ...)
	assert(arg0.functionDic[arg1], "with out register call:" .. arg1)
	arg0.functionDic[arg1](...)
end

function var1.Clear(arg0)
	arg0.mainOwner = nil
	arg0.functionDic = {}
end

function LuaActionTaskCall(arg0, ...)
	local var0 = var0.NodeCanvasMgr.GetInstance()

	assert(var0 and var0.mainOwner)
	var0:CallFunc(arg0, ...)
end
