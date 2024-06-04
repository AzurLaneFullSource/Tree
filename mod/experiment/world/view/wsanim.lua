local var0 = class("WSAnim", import("...BaseEntity"))

var0.Fields = {
	caches = "table"
}

function var0.Setup(arg0)
	arg0.caches = {}
end

function var0.Dispose(arg0)
	for iter0, iter1 in pairs(arg0.caches) do
		iter1:Dispose()
	end

	arg0:Clear()
end

function var0.GetAnim(arg0, arg1)
	return arg0.caches[arg1]
end

function var0.SetAnim(arg0, arg1, arg2)
	arg0.caches[arg1] = arg2
end

function var0.Stop(arg0)
	for iter0, iter1 in pairs(arg0.caches) do
		if iter1.playing then
			iter1:Stop()
		end
	end
end

return var0
