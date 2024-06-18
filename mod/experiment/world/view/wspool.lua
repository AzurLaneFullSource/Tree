local var0_0 = class("WSPool", import("...BaseEntity"))

var0_0.Fields = {
	tplDic = "table",
	pooltf = "userdata",
	pools = "table"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.pools = {}
	arg0_1.pooltf = GameObject.Find("__Pool__").transform

	local var0_1 = GetComponent(arg1_1, "ItemList").prefabItem

	arg0_1.tplDic = {}

	for iter0_1 = 0, var0_1.Length - 1 do
		arg0_1.tplDic[var0_1[iter0_1].name] = var0_1[iter0_1]
	end

	setActive(arg1_1, false)
end

function var0_0.Dispose(arg0_2)
	for iter0_2, iter1_2 in pairs(arg0_2.pools) do
		_.each(iter1_2, function(arg0_3)
			Destroy(arg0_3)
		end)
	end

	arg0_2:Clear()
end

function var0_0.Get(arg0_4, arg1_4)
	local var0_4 = arg0_4.pools
	local var1_4 = var0_4[arg1_4]

	if not var1_4 then
		var1_4 = {}
		var0_4[arg1_4] = var1_4
	end

	local var2_4

	if #var1_4 > 0 then
		var2_4 = table.remove(var1_4, #var1_4)
	else
		var2_4 = Instantiate(arg0_4.tplDic[arg1_4])
	end

	setActive(var2_4, true)
	tf(var2_4):SetParent(arg0_4.pooltf, false)

	return var2_4
end

function var0_0.Return(arg0_5, arg1_5, arg2_5)
	setActive(arg2_5, false)
	arg2_5.transform:SetParent(arg0_5.pooltf, false)

	local var0_5 = arg0_5.pools[arg1_5]

	table.insert(var0_5, arg2_5)
end

return var0_0
