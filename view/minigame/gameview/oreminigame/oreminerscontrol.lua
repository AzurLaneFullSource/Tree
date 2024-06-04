local var0 = class("OreMinersControl")

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg1
	arg0._tf = arg2
	arg0.tpl = findTF(arg0._tf, "tpl")

	arg0:Init()
end

function var0.Init(arg0)
	arg0.minerList = {}

	eachChild(findTF(arg0._tf, "pos"), function(arg0)
		local var0 = cloneTplTo(arg0.tpl, arg0, arg0.name)

		table.insert(arg0.minerList, OreMiner.New(arg0.binder, var0, 1.5 + math.random()))
	end)
end

function var0.Reset(arg0)
	for iter0, iter1 in ipairs(arg0.minerList) do
		iter1:Reset()
	end
end

function var0.OnTimer(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.minerList) do
		iter1:OnTimer(arg1)
	end
end

return var0
