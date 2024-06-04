local var0 = class("CastStep", import(".StoryStep"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.layout = arg1.layout
	arg0.time = arg1.time or 5
	arg0.spacing = arg1.spacing or 35
end

function var0.GetMode(arg0)
	return Story.MODE_CAST
end

function var0.DataToLayout(arg0, arg1)
	if arg1[1] == var1 then
		return {
			type = var1,
			text = arg1[2]
		}
	elseif arg1[1] == var2 then
		local var0 = Vector2(arg1[3] or 0, arg1[4] or 0)

		return {
			type = var2,
			path = arg1[2],
			size = var0
		}
	elseif arg1[1] == var3 then
		local var1 = {}
		local var2 = arg1[2]
		local var3 = arg0:ShouldReplacePlayer()

		for iter0 = 1, #var2 do
			local var4 = var2[iter0]

			if var3 then
				var4 = arg0:ReplacePlayerName(var4)
			end

			local var5 = HXSet.hxLan(var4)

			table.insert(var1, var5)
		end

		return {
			type = var3,
			names = var1,
			column = arg1[3] or 2,
			evenColumnColor = arg1[4] or "#c2c2c2"
		}
	elseif arg1[1] == var4 then
		return {
			type = var4
		}
	end
end

function var0.GetLayout(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.layout or {}) do
		local var1 = arg0:DataToLayout(iter1)

		table.insert(var0, var1)
	end

	return var0
end

function var0.GetSpacing(arg0)
	return arg0.spacing
end

function var0.GetPlayTime(arg0)
	return arg0.time
end

return var0
