local var0_0 = string
local var1_0 = math
local var2_0 = print
local var3_0 = getmetatable
local var4_0 = table
local var5_0 = ipairs
local var6_0 = tostring
local var7_0 = require("descriptor")

module("text_format")

function format(arg0_1)
	local var0_1 = var0_0.len(arg0_1)

	for iter0_1 = 1, var0_1, 16 do
		local var1_1 = ""

		for iter1_1 = iter0_1, var1_0.min(iter0_1 + 16 - 1, var0_1) do
			var1_1 = var0_0.format("%s  %02x", var1_1, var0_0.byte(arg0_1, iter1_1))
		end

		var2_0(var1_1)
	end
end

local var8_0 = var7_0.FieldDescriptor

function msg_format_indent(arg0_2, arg1_2, arg2_2)
	for iter0_2, iter1_2 in arg1_2:ListFields() do
		local function var0_2(arg0_3)
			local var0_3 = iter0_2.name

			arg0_2(var0_0.rep(" ", arg2_2))

			if iter0_2.type == var8_0.TYPE_MESSAGE then
				if var3_0(arg1_2)._extensions_by_name[iter0_2.full_name] then
					arg0_2("[" .. var0_3 .. "] {\n")
				else
					arg0_2(var0_3 .. " {\n")
				end

				msg_format_indent(arg0_2, arg0_3, arg2_2 + 4)
				arg0_2(var0_0.rep(" ", arg2_2))
				arg0_2("}\n")
			else
				arg0_2(var0_0.format("%s: %s\n", var0_3, var6_0(arg0_3)))
			end
		end

		if iter0_2.label == var8_0.LABEL_REPEATED then
			for iter2_2, iter3_2 in var5_0(iter1_2) do
				var0_2(iter3_2)
			end
		else
			var0_2(iter1_2)
		end
	end
end

function msg_format(arg0_4)
	local var0_4 = {}

	local function var1_4(arg0_5)
		var0_4[#var0_4 + 1] = arg0_5
	end

	msg_format_indent(var1_4, arg0_4, 0)

	return var4_0.concat(var0_4)
end
