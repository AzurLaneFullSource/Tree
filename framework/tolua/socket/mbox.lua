local var0_0 = {}

if module then
	mbox = var0_0
end

function var0_0.split_message(arg0_1)
	local var0_1 = {}

	arg0_1 = string.gsub(arg0_1, "\r\n", "\n")

	string.gsub(arg0_1, "^(.-\n)\n", function(arg0_2)
		var0_1.headers = arg0_2
	end)
	string.gsub(arg0_1, "^.-\n\n(.*)", function(arg0_3)
		var0_1.body = arg0_3
	end)

	if not var0_1.body then
		string.gsub(arg0_1, "^\n(.*)", function(arg0_4)
			var0_1.body = arg0_4
		end)
	end

	if not var0_1.headers and not var0_1.body then
		var0_1.headers = arg0_1
	end

	return var0_1.headers or "", var0_1.body or ""
end

function var0_0.split_headers(arg0_5)
	local var0_5 = {}

	arg0_5 = string.gsub(arg0_5, "\r\n", "\n")
	arg0_5 = string.gsub(arg0_5, "\n[ ]+", " ")

	string.gsub("\n" .. arg0_5, "\n([^\n]+)", function(arg0_6)
		table.insert(var0_5, arg0_6)
	end)

	return var0_5
end

function var0_0.parse_header(arg0_7)
	arg0_7 = string.gsub(arg0_7, "\n[ ]+", " ")
	arg0_7 = string.gsub(arg0_7, "\n+", "")

	local var0_7, var1_7, var2_7, var3_7 = string.find(arg0_7, "([^%s:]-):%s*(.*)")

	return var2_7, var3_7
end

function var0_0.parse_headers(arg0_8)
	local var0_8 = var0_0.split_headers(arg0_8)
	local var1_8 = {}

	for iter0_8 = 1, #var0_8 do
		local var2_8, var3_8 = var0_0.parse_header(var0_8[iter0_8])

		if var2_8 then
			local var4_8 = string.lower(var2_8)

			if var1_8[var4_8] then
				var1_8[var4_8] = var1_8[var4_8] .. ", " .. var3_8
			else
				var1_8[var4_8] = var3_8
			end
		end
	end

	return var1_8
end

function var0_0.parse_from(arg0_9)
	local var0_9, var1_9, var2_9, var3_9 = string.find(arg0_9, "^%s*(.-)%s*%<(.-)%>")

	if not var3_9 then
		local var4_9, var5_9

		var4_9, var5_9, var3_9 = string.find(arg0_9, "%s*(.+)%s*")
	end

	var2_9 = var2_9 or ""
	var3_9 = var3_9 or ""

	if var2_9 == "" then
		var2_9 = var3_9
	end

	return string.gsub(var2_9, "\"", ""), var3_9
end

function var0_0.split_mbox(arg0_10)
	local var0_10 = {}

	arg0_10 = string.gsub(arg0_10, "\r\n", "\n") .. "\n\nFrom \n"

	local var1_10 = 1
	local var2_10 = 1
	local var3_10 = 1

	while true do
		local var4_10, var5_10 = string.find(arg0_10, "\n\nFrom .-\n", var3_10)

		if not var4_10 then
			break
		end

		local var6_10 = string.sub(arg0_10, var3_10, var4_10 - 1)

		table.insert(var0_10, var6_10)

		var3_10 = var5_10 + 1
	end

	return var0_10
end

function var0_0.parse(arg0_11)
	local var0_11 = var0_0.split_mbox(arg0_11)

	for iter0_11 = 1, #var0_11 do
		var0_11[iter0_11] = var0_0.parse_message(var0_11[iter0_11])
	end

	return var0_11
end

function var0_0.parse_message(arg0_12)
	local var0_12 = {}

	var0_12.headers, var0_12.body = var0_0.split_message(arg0_12)
	var0_12.headers = var0_0.parse_headers(var0_12.headers)

	return var0_12
end

return var0_0
