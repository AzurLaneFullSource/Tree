local var0_0 = {}
local var1_0 = System.Reflection.BindingFlags
local var2_0 = bit.bor(var1_0.Instance, var1_0.Public, var1_0.NonPublic, var1_0.FlattenHierarchy, var1_0.Static)

function var0_0.RefCallStaticMethod(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1
	local var1_1

	if arg2_1 then
		var0_1 = tolua.gettypemethod(arg0_1, arg1_1, var2_0, Type.DefaultBinder, arg2_1, {})
		var1_1 = var0_1:Call(unpack(arg3_1))
	else
		var0_1 = tolua.gettypemethod(arg0_1, arg1_1, var2_0)
		var1_1 = var0_1:Call()
	end

	var0_1:Destroy()

	return var1_1
end

function var0_0.RefCallMethod(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	local var0_2
	local var1_2

	if arg3_2 then
		var0_2 = tolua.gettypemethod(arg0_2, arg1_2, var2_0, Type.DefaultBinder, arg3_2, {})
		var1_2 = var0_2:Call(arg2_2, unpack(arg4_2))
	else
		var0_2 = tolua.gettypemethod(arg0_2, arg1_2, var2_0)
		var1_2 = var0_2:Call(arg2_2)
	end

	var0_2:Destroy()

	return var1_2
end

function var0_0.RefCallMethodEx(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3
	local var1_3
	local var2_3 = tolua.gettypemethod(arg0_3, arg1_3, arg3_3)
	local var3_3 = var2_3:Call(arg2_3, unpack(arg4_3))

	var2_3:Destroy()

	return var3_3
end

function var0_0.RefGetField(arg0_4, arg1_4, arg2_4)
	local var0_4 = tolua.getfield(arg0_4, arg1_4, var2_0)
	local var1_4 = var0_4:Get(arg2_4)

	var0_4:Destroy()

	return var1_4
end

function var0_0.RefSetField(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = tolua.getfield(arg0_5, arg1_5, var2_0)

	var0_5:Set(arg2_5, arg3_5)
	var0_5:Destroy()
end

function var0_0.RefGetProperty(arg0_6, arg1_6, arg2_6)
	local var0_6 = tolua.getproperty(arg0_6, arg1_6, var2_0)
	local var1_6 = var0_6:Get(arg2_6, null)

	var0_6:Destroy()

	return var1_6
end

function var0_0.RefSetProperty(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = tolua.getproperty(arg0_7, arg1_7, var2_0)

	var0_7:Set(arg2_7, arg3_7, null)
	var0_7:Destroy()
end

return var0_0
