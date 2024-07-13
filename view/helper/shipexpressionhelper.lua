local var0_0 = class("ShipExpressionHelper")
local var1_0 = pg.ship_skin_expression
local var2_0 = pg.ship_skin_expression_ex
local var3_0 = false

local function var4_0(...)
	if var3_0 and IsUnityEditor then
		print(...)
	end
end

local function var5_0(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = var2_0[arg0_2]

	local function var1_2()
		local var0_3 = var0_2[arg1_2]
		local var1_3

		if var0_3 and var0_3 ~= "" then
			for iter0_3, iter1_3 in ipairs(var0_3) do
				if arg2_2 >= iter1_3[1] then
					var1_3 = iter1_3[2]
				end
			end
		end

		return var1_3
	end

	local function var2_2(arg0_4)
		local var0_4 = var0_2.main_ex

		if var0_4 and var0_4 ~= "" then
			local var1_4

			for iter0_4, iter1_4 in ipairs(var0_4) do
				if arg2_2 >= iter1_4[1] then
					var1_4 = iter1_4[2]
				end
			end

			if var1_4 then
				return string.split(var1_4, "|")[arg0_4]
			end
		end

		return nil
	end

	local function var3_2()
		local var0_5 = string.split(arg1_2, "_")[2]

		if not var0_5 then
			return nil
		end

		local var1_5 = tonumber(var0_5) - ShipWordHelper.GetMainSceneWordCnt(arg3_2)

		if var1_5 > 0 then
			return var2_2(var1_5)
		else
			return var1_2()
		end
	end

	local var4_2

	if var0_2 then
		if arg3_2 and string.find(arg1_2, "main") then
			var4_2 = var3_2()
		else
			var4_2 = var1_2()
		end
	end

	return var4_2
end

function var0_0.GetExpression(arg0_6, arg1_6, arg2_6, arg3_6)
	var4_0("name:", arg0_6, " - kind:", arg1_6, " - favor:", arg2_6)

	local var0_6 = var1_0[arg0_6]

	if not var0_6 then
		return nil
	end

	local var1_6 = var0_6[arg1_6]

	if arg2_6 then
		local var2_6 = var5_0(arg0_6, arg1_6, arg2_6, arg3_6)

		if var2_6 then
			var4_0("get expression form ex:", var2_6)

			var1_6 = var2_6
		end
	end

	if not var1_6 or var1_6 == "" then
		var1_6 = var0_6.default

		var4_0("get expression form default:", var1_6)
	end

	var4_0("get express :", var1_6)

	return var1_6
end

function var0_0.SetExpression(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = var0_0.GetExpression(arg1_7, arg2_7, arg3_7, arg4_7)

	return var0_0.UpdateExpression(arg0_7, arg1_7, var0_7)
end

function var0_0.UpdateExpression(arg0_8, arg1_8, arg2_8)
	local var0_8 = tf(arg0_8):Find("face")

	if not var0_8 then
		return false, nil
	end

	local var1_8 = arg1_8

	if not arg2_8 or arg2_8 == "" then
		var1_8 = string.gsub(arg1_8, "_n", "")

		if var0_0.DefaultFaceless(var1_8) then
			arg2_8 = var0_0.GetDefaultFace(var1_8)
		end
	end

	if not arg2_8 or arg2_8 == "" then
		setActive(var0_8, false)

		return false, nil
	end

	var0_0._UpdateExpression(var0_8, var1_8, arg2_8)

	return true, arg2_8
end

function var0_0._UpdateExpression(arg0_9, arg1_9, arg2_9)
	local var0_9 = GetSpriteFromAtlas("paintingface/" .. arg1_9, arg2_9)

	setImageSprite(arg0_9, var0_9)
	setActive(arg0_9, true)

	local var1_9 = findTF(arg0_9, "face_sub")

	if var1_9 then
		local var2_9 = GetSpriteFromAtlas("paintingface/" .. arg1_9, arg2_9 .. "_sub")

		setActive(var1_9, var2_9)

		if var2_9 then
			setImageSprite(var1_9, var2_9)
		end
	end
end

function var0_0.DefaultFaceless(arg0_10)
	local var0_10 = var1_0[arg0_10]

	return var0_10 and var0_10.default ~= ""
end

function var0_0.GetDefaultFace(arg0_11)
	return var1_0[arg0_11].default
end

return var0_0
