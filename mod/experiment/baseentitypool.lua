local var0_0 = class("BaseEntityPool", import(".BaseEntity"))

var0_0.Fields = {
	pools = "table"
}

function var0_0.Build(arg0_1)
	arg0_1.pools = {}
end

function var0_0.Get(arg0_2, arg1_2)
	local var0_2 = arg0_2.pools

	var0_2[arg1_2] = var0_2[arg1_2] or {}

	local var1_2 = var0_2[arg1_2]

	if #var1_2 == 0 then
		return arg1_2.New()
	else
		var1_2[#var1_2]:Build()

		return table.remove(var1_2, #var1_2)
	end
end

function var0_0.Return(arg0_3, arg1_3, arg2_3)
	arg1_3:Dispose()

	arg2_3 = arg2_3 or arg1_3.class
	arg0_3.pools[arg2_3] = arg0_3.pools[arg2_3] or {}

	table.insert(arg0_3.pools[arg2_3], arg1_3)
end

function var0_0.ReturnArray(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg1_4) do
		arg0_4:Return(iter1_4, arg2_4)
	end
end

function var0_0.ReturnMap(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in pairs(arg1_5) do
		arg0_5:Return(iter1_5, arg2_5)
	end
end

return var0_0
