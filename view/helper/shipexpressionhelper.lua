local var0 = class("ShipExpressionHelper")
local var1 = pg.ship_skin_expression
local var2 = pg.ship_skin_expression_ex
local var3 = false

local function var4(...)
	if var3 and IsUnityEditor then
		print(...)
	end
end

local function var5(arg0, arg1, arg2, arg3)
	local var0 = var2[arg0]

	local function var1()
		local var0 = var0[arg1]
		local var1

		if var0 and var0 ~= "" then
			for iter0, iter1 in ipairs(var0) do
				if arg2 >= iter1[1] then
					var1 = iter1[2]
				end
			end
		end

		return var1
	end

	local function var2(arg0)
		local var0 = var0.main_ex

		if var0 and var0 ~= "" then
			local var1

			for iter0, iter1 in ipairs(var0) do
				if arg2 >= iter1[1] then
					var1 = iter1[2]
				end
			end

			if var1 then
				return string.split(var1, "|")[arg0]
			end
		end

		return nil
	end

	local function var3()
		local var0 = string.split(arg1, "_")[2]

		if not var0 then
			return nil
		end

		local var1 = tonumber(var0) - ShipWordHelper.GetMainSceneWordCnt(arg3)

		if var1 > 0 then
			return var2(var1)
		else
			return var1()
		end
	end

	local var4

	if var0 then
		if arg3 and string.find(arg1, "main") then
			var4 = var3()
		else
			var4 = var1()
		end
	end

	return var4
end

function var0.GetExpression(arg0, arg1, arg2, arg3)
	var4("name:", arg0, " - kind:", arg1, " - favor:", arg2)

	local var0 = var1[arg0]

	if not var0 then
		return nil
	end

	local var1 = var0[arg1]

	if arg2 then
		local var2 = var5(arg0, arg1, arg2, arg3)

		if var2 then
			var4("get expression form ex:", var2)

			var1 = var2
		end
	end

	if not var1 or var1 == "" then
		var1 = var0.default

		var4("get expression form default:", var1)
	end

	var4("get express :", var1)

	return var1
end

function var0.SetExpression(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.GetExpression(arg1, arg2, arg3, arg4)

	return var0.UpdateExpression(arg0, arg1, var0)
end

function var0.UpdateExpression(arg0, arg1, arg2)
	local var0 = tf(arg0):Find("face")

	if not var0 then
		return false, nil
	end

	local var1 = arg1

	if not arg2 or arg2 == "" then
		var1 = string.gsub(arg1, "_n", "")

		if var0.DefaultFaceless(var1) then
			arg2 = var0.GetDefaultFace(var1)
		end
	end

	if not arg2 or arg2 == "" then
		setActive(var0, false)

		return false, nil
	end

	var0._UpdateExpression(var0, var1, arg2)

	return true, arg2
end

function var0._UpdateExpression(arg0, arg1, arg2)
	local var0 = GetSpriteFromAtlas("paintingface/" .. arg1, arg2)

	setImageSprite(arg0, var0)
	setActive(arg0, true)

	local var1 = findTF(arg0, "face_sub")

	if var1 then
		local var2 = GetSpriteFromAtlas("paintingface/" .. arg1, arg2 .. "_sub")

		setActive(var1, var2)

		if var2 then
			setImageSprite(var1, var2)
		end
	end
end

function var0.DefaultFaceless(arg0)
	local var0 = var1[arg0]

	return var0 and var0.default ~= ""
end

function var0.GetDefaultFace(arg0)
	return var1[arg0].default
end

return var0
