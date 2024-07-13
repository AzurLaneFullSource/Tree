local var0_0 = class("CourtYardAgent")

function var0_0.Ctor(arg0_1, arg1_1)
	setmetatable(arg0_1, {
		__index = function(arg0_2, arg1_2)
			local var0_2 = rawget(arg0_2, "class")

			return var0_2[arg1_2] and var0_2[arg1_2] or arg1_1[arg1_2]
		end
	})
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0
