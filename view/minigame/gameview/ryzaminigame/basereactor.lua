local var0_0 = class("BaseReactor")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.responder = arg3_1
	arg0_1._tf = arg2_1
	arg0_1.callDic = {}
	arg0_1.rangeDic = {}

	arg0_1:Init(arg1_1)
	arg0_1.responder:CreateCall(arg0_1)
end

function var0_0.Init(arg0_2, arg1_2)
	return
end

function var0_0.Register(arg0_3, arg1_3, arg2_3, arg3_3)
	assert(arg3_3)

	arg0_3.callDic[arg1_3] = arg2_3
	arg0_3.rangeDic[arg1_3] = underscore.map(arg3_3, function(arg0_4)
		return NewPos(unpack(arg0_4))
	end)

	arg0_3.responder:AddListener(arg1_3, arg0_3, arg0_3.rangeDic[arg1_3])
end

function var0_0.Deregister(arg0_5, arg1_5)
	arg0_5.responder:RemoveListener(arg1_5, arg0_5, arg0_5.rangeDic[arg1_5])

	arg0_5.callDic[arg1_5] = nil
	arg0_5.rangeDic[arg1_5] = nil
end

function var0_0.DeregisterAll(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.callDic) do
		arg0_6:Deregister(iter0_6)
	end
end

function var0_0.Calling(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.responder:EventCall(arg1_7, arg2_7, arg0_7, arg3_7)
end

function var0_0.React(arg0_8, arg1_8, arg2_8)
	if not arg0_8.callDic[arg1_8] then
		return
	end

	arg0_8.callDic[arg1_8](unpack(arg2_8))
end

function var0_0.Destroy(arg0_9, arg1_9)
	arg0_9:DeregisterAll()

	local var0_9 = defaultValue(arg1_9, true) and RyzaMiniGameConfig.GetDestroyPoint(arg0_9) or 0

	arg0_9.responder:DestroyCall(arg0_9, var0_9)

	arg0_9.responder = nil
	arg0_9.callDic = nil
	arg0_9.rangeDic = nil

	Destroy(arg0_9._tf)
end

return var0_0
