local var0 = class("BaseEntityBank", import(".BaseEntityPool"))

var0.Fields = {
	marks = "table"
}

function var0.Build(arg0)
	var0.super.Build(arg0)

	arg0.marks = {}
end

function var0.Fetch(arg0, arg1)
	local var0 = arg0:Get(arg1)

	arg0.marks[arg1] = arg0.marks[arg1] or {}

	table.insert(arg0.marks[arg1], var0)

	return var0
end

function var0.Recycle(arg0, arg1)
	local var0 = arg0.marks[arg1]

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			arg0:Return(iter1, arg1)
		end

		arg0.marks[arg1] = nil
	end
end

function var0.RecycleAll(arg0)
	for iter0, iter1 in pairs(arg0.marks) do
		for iter2, iter3 in ipairs(iter1) do
			arg0:Return(iter3, iter0)
		end
	end

	arg0.marks = {}
end

return var0
