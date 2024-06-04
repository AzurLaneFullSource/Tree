local var0 = class("WSPool", import("...BaseEntity"))

var0.Fields = {
	tplDic = "table",
	pooltf = "userdata",
	pools = "table"
}

function var0.Setup(arg0, arg1)
	arg0.pools = {}
	arg0.pooltf = GameObject.Find("__Pool__").transform

	local var0 = GetComponent(arg1, "ItemList").prefabItem

	arg0.tplDic = {}

	for iter0 = 0, var0.Length - 1 do
		arg0.tplDic[var0[iter0].name] = var0[iter0]
	end

	setActive(arg1, false)
end

function var0.Dispose(arg0)
	for iter0, iter1 in pairs(arg0.pools) do
		_.each(iter1, function(arg0)
			Destroy(arg0)
		end)
	end

	arg0:Clear()
end

function var0.Get(arg0, arg1)
	local var0 = arg0.pools
	local var1 = var0[arg1]

	if not var1 then
		var1 = {}
		var0[arg1] = var1
	end

	local var2

	if #var1 > 0 then
		var2 = table.remove(var1, #var1)
	else
		var2 = Instantiate(arg0.tplDic[arg1])
	end

	setActive(var2, true)
	tf(var2):SetParent(arg0.pooltf, false)

	return var2
end

function var0.Return(arg0, arg1, arg2)
	setActive(arg2, false)
	arg2.transform:SetParent(arg0.pooltf, false)

	local var0 = arg0.pools[arg1]

	table.insert(var0, arg2)
end

return var0
