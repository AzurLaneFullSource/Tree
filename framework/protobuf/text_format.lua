local var0 = string
local var1 = math
local var2 = print
local var3 = getmetatable
local var4 = table
local var5 = ipairs
local var6 = tostring
local var7 = require("descriptor")

module("text_format")

function format(arg0)
	local var0 = var0.len(arg0)

	for iter0 = 1, var0, 16 do
		local var1 = ""

		for iter1 = iter0, var1.min(iter0 + 16 - 1, var0) do
			var1 = var0.format("%s  %02x", var1, var0.byte(arg0, iter1))
		end

		var2(var1)
	end
end

local var8 = var7.FieldDescriptor

function msg_format_indent(arg0, arg1, arg2)
	for iter0, iter1 in arg1:ListFields() do
		local var0 = function(arg0)
			local var0 = iter0.name

			arg0(var0.rep(" ", arg2))

			if iter0.type == var8.TYPE_MESSAGE then
				if var3(arg1)._extensions_by_name[iter0.full_name] then
					arg0("[" .. var0 .. "] {\n")
				else
					arg0(var0 .. " {\n")
				end

				msg_format_indent(arg0, arg0, arg2 + 4)
				arg0(var0.rep(" ", arg2))
				arg0("}\n")
			else
				arg0(var0.format("%s: %s\n", var0, var6(arg0)))
			end
		end

		if iter0.label == var8.LABEL_REPEATED then
			for iter2, iter3 in var5(iter1) do
				var0(iter3)
			end
		else
			var0(iter1)
		end
	end
end

function msg_format(arg0)
	local var0 = {}

	local function var1(arg0)
		var0[#var0 + 1] = arg0
	end

	msg_format_indent(var1, arg0, 0)

	return var4.concat(var0)
end
