local var0_0 = {}

local function var1_0(arg0_1)
	return ReflectionHelp.RefGetField(typeof("UnityEngine.UILineInfo"), "startCharIdx", arg0_1)
end

local function var2_0(arg0_2)
	local var0_2 = {}

	for iter0_2 = 0, #arg0_2 - 1 do
		var0_2[iter0_2] = 0
	end

	for iter1_2, iter2_2 in ipairs({
		" ",
		"\n"
	}) do
		local var1_2 = Clone(arg0_2)
		local var2_2 = 0
		local var3_2 = string.find(var1_2, iter2_2)

		while var3_2 do
			for iter3_2 = 0, #iter2_2 - 1 do
				var0_2[var2_2 + var3_2 + iter3_2] = 3
			end

			var2_2 = var2_2 + var3_2 + #iter2_2
			var1_2 = string.sub(var1_2, var3_2 + #iter2_2)
			var3_2 = string.find(var1_2, iter2_2)
		end
	end

	local var4_2

	for iter4_2, iter5_2 in ipairs({
		"b",
		"i",
		"size",
		"color",
		"material"
	}) do
		local var5_2 = "</" .. iter5_2 .. ">"
		local var6_2 = string.match(arg0_2, "</*" .. iter5_2 .. "[^>]*>")
		local var7_2 = {}

		while var6_2 do
			local var8_2 = string.find(arg0_2, var6_2)

			if var6_2 == var5_2 then
				if #var7_2 > 0 then
					local var9_2 = table.remove(var7_2)

					for iter6_2 = 0, #var9_2.str - 1 do
						var0_2[var9_2.start + iter6_2] = 1
					end

					for iter7_2 = 0, #var6_2 - 1 do
						var0_2[var8_2 + iter7_2] = 2
					end
				end
			else
				local var10_2 = {
					str = var6_2,
					start = var8_2
				}

				table.insert(var7_2, var10_2)
			end
		end

		local var11_2 = string.match(arg0_2, "</*" .. iter5_2 .. "[^>]*>")
	end

	local var12_2 = {}
	local var13_2 = 0

	for iter8_2 = 0, #arg0_2 - 1 do
		if var0_2[iter8_2] == 0 then
			var12_2[iter8_2] = var13_2
			var13_2 = var13_2 + 1
		else
			var12_2[iter8_2] = -2
		end
	end

	for iter9_2 = 0, #arg0_2 - 1 do
		if var12_2[iter9_2] ~= -2 or var0_2[iter9_2] == 0 then
			-- block empty
		elseif var0_2[iter9_2] == 1 then
			var12_2[iter9_2] = findRight(var0_2, var12_2, #arg0_2, iter9_2 + 1)
		elseif var0_2[iter9_2] == 2 then
			var12_2[iter9_2] = var12_2[iter9_2 - 1]
		elseif var0_2[iter9_2] == 3 then
			var12_2[iter9_2] = -1
		end
	end

	return var12_2
end

local function var3_0(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg3_3 < arg2_3 then
		if arg0_3[arg3_3] == 0 then
			return arg1_3[arg3_3]
		elseif arg0_3[arg3_3] == 1 then
			arg1_3[arg3_3] = var3_0(arg0_3, arg1_3, arg2_3, arg3_3 + 1)

			return arg1_3[arg3_3]
		elseif arg0_3[arg3_3] == 2 then
			return -1
		elseif arg0_3[arg3_3] == 3 then
			arg1_3[arg3_3] = var3_0(arg0_3, arg1_3, arg2_3, arg3_3 + 1)

			return arg1_3[arg3_3]
		end
	end

	return -1
end

function var0_0.ModifyMesh()
	return function(arg0_5, arg1_5)
		if not ReflectionHelp.RefCallMethod(typeof("VerticalText"), "IsActive", arg0_5) then
			return
		end

		local var0_5 = GetComponent(ReflectionHelp.RefGetProperty(typeof("VerticalText"), "gameObject", arg0_5), typeof(Text))
		local var1_5 = var0_5.cachedTextGenerator

		ReflectionHelp.RefSetField(typeof("VerticalText"), "lineSpacing", arg0_5, var0_5.fontSize * var0_5.lineSpacing)

		local var2_5 = ReflectionHelp.RefGetField(typeof("VerticalText"), "spacing", arg0_5)

		ReflectionHelp.RefSetField(typeof("VerticalText"), "textSpacing", arg0_5, var0_5.fontSize * var2_5)
		ReflectionHelp.RefSetField(typeof("VerticalText"), "xOffset", arg0_5, var0_5.rectTransform.sizeDelta.x / 2 - var0_5.fontSize / 2)
		ReflectionHelp.RefSetField(typeof("VerticalText"), "yOffset", arg0_5, var0_5.rectTransform.sizeDelta.y / 2 - var0_5.fontSize / 2)

		local var3_5 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.TextGenerator"), "lines", var1_5)
		local var4_5 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.UI.RichText"), "RichStringProjection", {
			typeof("System.String")
		}, {
			var0_5.text
		})
		local var5_5 = var3_5.Count

		for iter0_5 = 0, var5_5 - 1 do
			local var6_5 = var5_5 > iter0_5 + 1 and var1_0(var3_5[iter0_5 + 1]) or utf8_len(var0_5.text)
			local var7_5 = 0

			for iter1_5 = var1_0(var3_5[iter0_5]), var6_5 - 1 do
				if var4_5[iter1_5] >= 0 then
					ReflectionHelp.RefCallMethod(typeof("VerticalText"), "modifyText", arg0_5, {
						typeof("UnityEngine.UI.VertexHelper"),
						typeof("System.Int32"),
						typeof("System.Int32"),
						typeof("System.Int32")
					}, {
						arg1_5,
						var4_5[iter1_5],
						var7_5,
						iter0_5
					})
				end

				var7_5 = var7_5 + 1
			end
		end
	end, LuaInterface.InjectType.Replace
end

InjectByName("VerticalText", var0_0)
