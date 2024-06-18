local var0_0 = class("WSAnim", import("...BaseEntity"))

var0_0.Fields = {
	caches = "table"
}

function var0_0.Setup(arg0_1)
	arg0_1.caches = {}
end

function var0_0.Dispose(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2.caches) do
		iter1_2:Dispose()
	end

	arg0_2:Clear()
end

function var0_0.GetAnim(arg0_3, arg1_3)
	return arg0_3.caches[arg1_3]
end

function var0_0.SetAnim(arg0_4, arg1_4, arg2_4)
	arg0_4.caches[arg1_4] = arg2_4
end

function var0_0.Stop(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.caches) do
		if iter1_5.playing then
			iter1_5:Stop()
		end
	end
end

return var0_0
