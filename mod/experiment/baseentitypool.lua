local var0 = class("BaseEntityPool", import(".BaseEntity"))

var0.Fields = {
	pools = "table"
}

function var0.Build(arg0)
	arg0.pools = {}
end

function var0.Get(arg0, arg1)
	local var0 = arg0.pools

	var0[arg1] = var0[arg1] or {}

	local var1 = var0[arg1]

	if #var1 == 0 then
		return arg1.New()
	else
		var1[#var1]:Build()

		return table.remove(var1, #var1)
	end
end

function var0.Return(arg0, arg1, arg2)
	arg1:Dispose()

	arg2 = arg2 or arg1.class
	arg0.pools[arg2] = arg0.pools[arg2] or {}

	table.insert(arg0.pools[arg2], arg1)
end

function var0.ReturnArray(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg1) do
		arg0:Return(iter1, arg2)
	end
end

function var0.ReturnMap(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg1) do
		arg0:Return(iter1, arg2)
	end
end

return var0
