local var0 = {}

local function var1(arg0)
	return ReflectionHelp.RefGetField(typeof("UnityEngine.UILineInfo"), "startCharIdx", arg0)
end

local function var2(arg0)
	local var0 = {}

	for iter0 = 0, #arg0 - 1 do
		var0[iter0] = 0
	end

	for iter1, iter2 in ipairs({
		" ",
		"\n"
	}) do
		local var1 = Clone(arg0)
		local var2 = 0
		local var3 = string.find(var1, iter2)

		while var3 do
			for iter3 = 0, #iter2 - 1 do
				var0[var2 + var3 + iter3] = 3
			end

			var2 = var2 + var3 + #iter2
			var1 = string.sub(var1, var3 + #iter2)
			var3 = string.find(var1, iter2)
		end
	end

	local var4

	for iter4, iter5 in ipairs({
		"b",
		"i",
		"size",
		"color",
		"material"
	}) do
		local var5 = "</" .. iter5 .. ">"
		local var6 = string.match(arg0, "</*" .. iter5 .. "[^>]*>")
		local var7 = {}

		while var6 do
			local var8 = string.find(arg0, var6)

			if var6 == var5 then
				if #var7 > 0 then
					local var9 = table.remove(var7)

					for iter6 = 0, #var9.str - 1 do
						var0[var9.start + iter6] = 1
					end

					for iter7 = 0, #var6 - 1 do
						var0[var8 + iter7] = 2
					end
				end
			else
				local var10 = {
					str = var6,
					start = var8
				}

				table.insert(var7, var10)
			end
		end

		local var11 = string.match(arg0, "</*" .. iter5 .. "[^>]*>")
	end

	local var12 = {}
	local var13 = 0

	for iter8 = 0, #arg0 - 1 do
		if var0[iter8] == 0 then
			var12[iter8] = var13
			var13 = var13 + 1
		else
			var12[iter8] = -2
		end
	end

	for iter9 = 0, #arg0 - 1 do
		if var12[iter9] ~= -2 or var0[iter9] == 0 then
			-- block empty
		elseif var0[iter9] == 1 then
			var12[iter9] = findRight(var0, var12, #arg0, iter9 + 1)
		elseif var0[iter9] == 2 then
			var12[iter9] = var12[iter9 - 1]
		elseif var0[iter9] == 3 then
			var12[iter9] = -1
		end
	end

	return var12
end

local function var3(arg0, arg1, arg2, arg3)
	if arg3 < arg2 then
		if arg0[arg3] == 0 then
			return arg1[arg3]
		elseif arg0[arg3] == 1 then
			arg1[arg3] = var3(arg0, arg1, arg2, arg3 + 1)

			return arg1[arg3]
		elseif arg0[arg3] == 2 then
			return -1
		elseif arg0[arg3] == 3 then
			arg1[arg3] = var3(arg0, arg1, arg2, arg3 + 1)

			return arg1[arg3]
		end
	end

	return -1
end

function var0.ModifyMesh()
	return function(arg0, arg1)
		if not ReflectionHelp.RefCallMethod(typeof("VerticalText"), "IsActive", arg0) then
			return
		end

		local var0 = GetComponent(ReflectionHelp.RefGetProperty(typeof("VerticalText"), "gameObject", arg0), typeof(Text))
		local var1 = var0.cachedTextGenerator

		ReflectionHelp.RefSetField(typeof("VerticalText"), "lineSpacing", arg0, var0.fontSize * var0.lineSpacing)

		local var2 = ReflectionHelp.RefGetField(typeof("VerticalText"), "spacing", arg0)

		ReflectionHelp.RefSetField(typeof("VerticalText"), "textSpacing", arg0, var0.fontSize * var2)
		ReflectionHelp.RefSetField(typeof("VerticalText"), "xOffset", arg0, var0.rectTransform.sizeDelta.x / 2 - var0.fontSize / 2)
		ReflectionHelp.RefSetField(typeof("VerticalText"), "yOffset", arg0, var0.rectTransform.sizeDelta.y / 2 - var0.fontSize / 2)

		local var3 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.TextGenerator"), "lines", var1)
		local var4 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.UI.RichText"), "RichStringProjection", {
			typeof("System.String")
		}, {
			var0.text
		})
		local var5 = var3.Count

		for iter0 = 0, var5 - 1 do
			local var6 = var5 > iter0 + 1 and var1(var3[iter0 + 1]) or utf8_len(var0.text)
			local var7 = 0

			for iter1 = var1(var3[iter0]), var6 - 1 do
				if var4[iter1] >= 0 then
					ReflectionHelp.RefCallMethod(typeof("VerticalText"), "modifyText", arg0, {
						typeof("UnityEngine.UI.VertexHelper"),
						typeof("System.Int32"),
						typeof("System.Int32"),
						typeof("System.Int32")
					}, {
						arg1,
						var4[iter1],
						var7,
						iter0
					})
				end

				var7 = var7 + 1
			end
		end
	end, LuaInterface.InjectType.Replace
end

InjectByName("VerticalText", var0)
