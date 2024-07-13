pg = pg or {}

local var0_0 = pg
local var1_0 = class("DelegateInfo")

var0_0.DelegateInfo = var1_0
var1_0.ClientsInfo = {}

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.ClientsInfo[arg1_1] = arg0_1
	arg0_1.events = {}
end

function var1_0.Add(arg0_2, arg1_2)
	if arg0_2 == nil then
		return
	end

	local var0_2 = var1_0.ClientsInfo[arg0_2]

	assert(var0_2, "没有初始化委托处理" .. arg0_2.__cname)

	if var0_2 then
		var0_2:AddEventOb(arg1_2)
	end
end

function var1_0.AddEventOb(arg0_3, arg1_3)
	arg0_3.events[arg1_3] = true
end

function var1_0.Dispose(arg0_4)
	local var0_4 = var1_0.ClientsInfo[arg0_4]

	assert(var0_4, "没有初始化委托处理" .. arg0_4.__cname)

	if var0_4 then
		var0_4:Clear()
	end

	var1_0.ClientsInfo[arg0_4] = nil
end

function var1_0.Clear(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.events) do
		iter0_5:RemoveAllListeners()
	end

	arg0_5.events = nil
end
