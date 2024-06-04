pg = pg or {}

local var0 = pg
local var1 = class("DelegateInfo")

var0.DelegateInfo = var1
var1.ClientsInfo = {}

function var1.Ctor(arg0, arg1)
	var1.ClientsInfo[arg1] = arg0
	arg0.events = {}
end

function var1.Add(arg0, arg1)
	if arg0 == nil then
		return
	end

	local var0 = var1.ClientsInfo[arg0]

	assert(var0, "没有初始化委托处理" .. arg0.__cname)

	if var0 then
		var0:AddEventOb(arg1)
	end
end

function var1.AddEventOb(arg0, arg1)
	arg0.events[arg1] = true
end

function var1.Dispose(arg0)
	local var0 = var1.ClientsInfo[arg0]

	assert(var0, "没有初始化委托处理" .. arg0.__cname)

	if var0 then
		var0:Clear()
	end

	var1.ClientsInfo[arg0] = nil
end

function var1.Clear(arg0)
	for iter0, iter1 in pairs(arg0.events) do
		iter0:RemoveAllListeners()
	end

	arg0.events = nil
end
