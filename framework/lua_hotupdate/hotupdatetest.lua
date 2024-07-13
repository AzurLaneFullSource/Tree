local var0_0 = 0

function HUT_Var1()
	var0_0 = var0_0 + 2

	print("x = ", var0_0)
end

function HUT_Var3()
	var0_0 = var0_0 + 10

	print("x = ", var0_0)
end

local var1_0 = HUT_Var1

function HUT_Func()
	var1_0()
end

function HUT_FUNC2()
	print("y = 4")
end
