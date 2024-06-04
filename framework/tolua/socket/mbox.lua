local var0 = {}

if module then
	mbox = var0
end

function var0.split_message(arg0)
	local var0 = {}

	arg0 = string.gsub(arg0, "\r\n", "\n")

	string.gsub(arg0, "^(.-\n)\n", function(arg0)
		var0.headers = arg0
	end)
	string.gsub(arg0, "^.-\n\n(.*)", function(arg0)
		var0.body = arg0
	end)

	if not var0.body then
		string.gsub(arg0, "^\n(.*)", function(arg0)
			var0.body = arg0
		end)
	end

	if not var0.headers and not var0.body then
		var0.headers = arg0
	end

	return var0.headers or "", var0.body or ""
end

function var0.split_headers(arg0)
	local var0 = {}

	arg0 = string.gsub(arg0, "\r\n", "\n")
	arg0 = string.gsub(arg0, "\n[ ]+", " ")

	string.gsub("\n" .. arg0, "\n([^\n]+)", function(arg0)
		table.insert(var0, arg0)
	end)

	return var0
end

function var0.parse_header(arg0)
	arg0 = string.gsub(arg0, "\n[ ]+", " ")
	arg0 = string.gsub(arg0, "\n+", "")

	local var0, var1, var2, var3 = string.find(arg0, "([^%s:]-):%s*(.*)")

	return var2, var3
end

function var0.parse_headers(arg0)
	local var0 = var0.split_headers(arg0)
	local var1 = {}

	for iter0 = 1, #var0 do
		local var2, var3 = var0.parse_header(var0[iter0])

		if var2 then
			local var4 = string.lower(var2)

			if var1[var4] then
				var1[var4] = var1[var4] .. ", " .. var3
			else
				var1[var4] = var3
			end
		end
	end

	return var1
end

function var0.parse_from(arg0)
	local var0, var1, var2, var3 = string.find(arg0, "^%s*(.-)%s*%<(.-)%>")

	if not var3 then
		local var4, var5

		var4, var5, var3 = string.find(arg0, "%s*(.+)%s*")
	end

	var2 = var2 or ""
	var3 = var3 or ""

	if var2 == "" then
		var2 = var3
	end

	return string.gsub(var2, "\"", ""), var3
end

function var0.split_mbox(arg0)
	local var0 = {}

	arg0 = string.gsub(arg0, "\r\n", "\n") .. "\n\nFrom \n"

	local var1 = 1
	local var2 = 1
	local var3 = 1

	while true do
		local var4, var5 = string.find(arg0, "\n\nFrom .-\n", var3)

		if not var4 then
			break
		end

		local var6 = string.sub(arg0, var3, var4 - 1)

		table.insert(var0, var6)

		var3 = var5 + 1
	end

	return var0
end

function var0.parse(arg0)
	local var0 = var0.split_mbox(arg0)

	for iter0 = 1, #var0 do
		var0[iter0] = var0.parse_message(var0[iter0])
	end

	return var0
end

function var0.parse_message(arg0)
	local var0 = {}

	var0.headers, var0.body = var0.split_message(arg0)
	var0.headers = var0.parse_headers(var0.headers)

	return var0
end

return var0
