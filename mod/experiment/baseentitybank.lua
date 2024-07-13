local var0_0 = class("BaseEntityBank", import(".BaseEntityPool"))

var0_0.Fields = {
	marks = "table"
}

function var0_0.Build(arg0_1)
	var0_0.super.Build(arg0_1)

	arg0_1.marks = {}
end

function var0_0.Fetch(arg0_2, arg1_2)
	local var0_2 = arg0_2:Get(arg1_2)

	arg0_2.marks[arg1_2] = arg0_2.marks[arg1_2] or {}

	table.insert(arg0_2.marks[arg1_2], var0_2)

	return var0_2
end

function var0_0.Recycle(arg0_3, arg1_3)
	local var0_3 = arg0_3.marks[arg1_3]

	if var0_3 then
		for iter0_3, iter1_3 in ipairs(var0_3) do
			arg0_3:Return(iter1_3, arg1_3)
		end

		arg0_3.marks[arg1_3] = nil
	end
end

function var0_0.RecycleAll(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.marks) do
		for iter2_4, iter3_4 in ipairs(iter1_4) do
			arg0_4:Return(iter3_4, iter0_4)
		end
	end

	arg0_4.marks = {}
end

return var0_0
