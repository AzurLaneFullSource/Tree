local var0_0 = class("IslandAnimationAttachmentHelper")

function var0_0.ResolveId(arg0_1, arg1_1)
	local var0_1 = pg.island_animation_attachments[arg1_1]

	if not var0_1 or not arg0_1 then
		return arg1_1
	end

	local var1_1 = var0_1.override

	if var1_1 == "" or type(var1_1) ~= "table" then
		return arg1_1
	end

	local function var2_1(arg0_2)
		if not arg0_2 or arg0_2 == "" then
			return false
		end

		local var0_2 = arg0_1.runtimeAnimatorController

		if not var0_2 then
			return false
		end

		return string.gsub(var0_2.name, "%(Clone%)$", "") == arg0_2
	end

	if type(var1_1[1]) == "table" then
		for iter0_1, iter1_1 in ipairs(var1_1) do
			if var2_1(iter1_1[1]) then
				return iter1_1[2] or arg1_1
			end
		end
	elseif var2_1(var1_1[1]) then
		return var1_1[2] or arg1_1
	end

	return arg1_1
end

return var0_0
