local var0 = class("BaseReactor")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.responder = arg3
	arg0._tf = arg2
	arg0.callDic = {}
	arg0.rangeDic = {}

	arg0:Init(arg1)
	arg0.responder:CreateCall(arg0)
end

function var0.Init(arg0, arg1)
	return
end

function var0.Register(arg0, arg1, arg2, arg3)
	assert(arg3)

	arg0.callDic[arg1] = arg2
	arg0.rangeDic[arg1] = underscore.map(arg3, function(arg0)
		return NewPos(unpack(arg0))
	end)

	arg0.responder:AddListener(arg1, arg0, arg0.rangeDic[arg1])
end

function var0.Deregister(arg0, arg1)
	arg0.responder:RemoveListener(arg1, arg0, arg0.rangeDic[arg1])

	arg0.callDic[arg1] = nil
	arg0.rangeDic[arg1] = nil
end

function var0.DeregisterAll(arg0)
	for iter0, iter1 in pairs(arg0.callDic) do
		arg0:Deregister(iter0)
	end
end

function var0.Calling(arg0, arg1, arg2, arg3)
	arg0.responder:EventCall(arg1, arg2, arg0, arg3)
end

function var0.React(arg0, arg1, arg2)
	if not arg0.callDic[arg1] then
		return
	end

	arg0.callDic[arg1](unpack(arg2))
end

function var0.Destroy(arg0, arg1)
	arg0:DeregisterAll()

	local var0 = defaultValue(arg1, true) and RyzaMiniGameConfig.GetDestroyPoint(arg0) or 0

	arg0.responder:DestroyCall(arg0, var0)

	arg0.responder = nil
	arg0.callDic = nil
	arg0.rangeDic = nil

	Destroy(arg0._tf)
end

return var0
