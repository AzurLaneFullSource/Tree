local var0_0 = class("OreMinersControl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.tpl = findTF(arg0_1._tf, "tpl")

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.minerList = {}

	eachChild(findTF(arg0_2._tf, "pos"), function(arg0_3)
		local var0_3 = cloneTplTo(arg0_2.tpl, arg0_3, arg0_3.name)

		table.insert(arg0_2.minerList, OreMiner.New(arg0_2.binder, var0_3, 1.5 + math.random()))
	end)
end

function var0_0.Reset(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.minerList) do
		iter1_4:Reset()
	end
end

function var0_0.OnTimer(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.minerList) do
		iter1_5:OnTimer(arg1_5)
	end
end

return var0_0
