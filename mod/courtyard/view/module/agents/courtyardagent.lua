local var0 = class("CourtYardAgent")

function var0.Ctor(arg0, arg1)
	setmetatable(arg0, {
		__index = function(arg0, arg1)
			local var0 = rawget(arg0, "class")

			return var0[arg1] and var0[arg1] or arg1[arg1]
		end
	})
end

function var0.Dispose(arg0)
	return
end

return var0
