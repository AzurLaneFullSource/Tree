local var0 = class("MainRequestFeastActDataSequence")

function var0.Execute(arg0, arg1)
	getProxy(FeastProxy):RequestData(arg1)
end

return var0
