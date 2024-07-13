local var0_0 = class("CastStep", import(".StoryStep"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.layout = arg1_1.layout
	arg0_1.time = arg1_1.time or 5
	arg0_1.spacing = arg1_1.spacing or 35
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_CAST
end

function var0_0.DataToLayout(arg0_3, arg1_3)
	if arg1_3[1] == var1_0 then
		return {
			type = var1_0,
			text = arg1_3[2]
		}
	elseif arg1_3[1] == var2_0 then
		local var0_3 = Vector2(arg1_3[3] or 0, arg1_3[4] or 0)

		return {
			type = var2_0,
			path = arg1_3[2],
			size = var0_3
		}
	elseif arg1_3[1] == var3_0 then
		local var1_3 = {}
		local var2_3 = arg1_3[2]
		local var3_3 = arg0_3:ShouldReplacePlayer()

		for iter0_3 = 1, #var2_3 do
			local var4_3 = var2_3[iter0_3]

			if var3_3 then
				var4_3 = arg0_3:ReplacePlayerName(var4_3)
			end

			local var5_3 = HXSet.hxLan(var4_3)

			table.insert(var1_3, var5_3)
		end

		return {
			type = var3_0,
			names = var1_3,
			column = arg1_3[3] or 2,
			evenColumnColor = arg1_3[4] or "#c2c2c2"
		}
	elseif arg1_3[1] == var4_0 then
		return {
			type = var4_0
		}
	end
end

function var0_0.GetLayout(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.layout or {}) do
		local var1_4 = arg0_4:DataToLayout(iter1_4)

		table.insert(var0_4, var1_4)
	end

	return var0_4
end

function var0_0.GetSpacing(arg0_5)
	return arg0_5.spacing
end

function var0_0.GetPlayTime(arg0_6)
	return arg0_6.time
end

return var0_0
