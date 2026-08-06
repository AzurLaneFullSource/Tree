local var0_0 = class("WSPool", import("...BaseEntity"))

var0_0.Fields = {
	tplDic = "table",
	pooltf = "userdata",
	pools = "table"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.pools = {}
	arg0_1.pooltf = GameObject.Find("__Pool__").transform
	arg0_1.tplDic = {}

	eachChild(tf(arg1_1), function(arg0_2, arg1_2)
		arg0_1.tplDic[arg0_2.name] = arg0_2
	end)
	setActive(arg1_1, false)
end

function var0_0.Dispose(arg0_3)
	for iter0_3, iter1_3 in pairs(arg0_3.pools) do
		_.each(iter1_3, function(arg0_4)
			Destroy(arg0_4)
		end)
	end

	for iter2_3, iter3_3 in pairs(arg0_3.tplDic) do
		arg0_3.tplDic[iter2_3] = nil
	end

	arg0_3.tplDic = nil

	arg0_3:Clear()
end

function var0_0.Get(arg0_5, arg1_5)
	local var0_5 = arg0_5.pools
	local var1_5 = var0_5[arg1_5]

	if not var1_5 then
		var1_5 = {}
		var0_5[arg1_5] = var1_5
	end

	local var2_5

	if #var1_5 > 0 then
		var2_5 = table.remove(var1_5, #var1_5)
	else
		var2_5 = Instantiate(arg0_5.tplDic[arg1_5])
	end

	setActive(var2_5, true)
	tf(var2_5):SetParent(arg0_5.pooltf, false)

	return var2_5
end

function var0_0.Return(arg0_6, arg1_6, arg2_6)
	setActive(arg2_6, false)
	arg2_6.transform:SetParent(arg0_6.pooltf, false)

	local var0_6 = arg0_6.pools[arg1_6]

	table.insert(var0_6, arg2_6)
end

return var0_0
