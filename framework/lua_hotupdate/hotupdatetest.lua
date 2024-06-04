local var0 = 0

function HUT_Var1()
	var0 = var0 + 2

	print("x = ", var0)
end

function HUT_Var3()
	var0 = var0 + 10

	print("x = ", var0)
end

local var1 = HUT_Var1

function HUT_Func()
	var1()
end

function HUT_FUNC2()
	print("y = 4")
end
