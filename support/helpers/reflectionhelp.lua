local var0 = {}
local var1 = System.Reflection.BindingFlags
local var2 = bit.bor(var1.Instance, var1.Public, var1.NonPublic, var1.FlattenHierarchy, var1.Static)

function var0.RefCallStaticMethod(arg0, arg1, arg2, arg3)
	local var0
	local var1

	if arg2 then
		var0 = tolua.gettypemethod(arg0, arg1, var2, Type.DefaultBinder, arg2, {})
		var1 = var0:Call(unpack(arg3))
	else
		var0 = tolua.gettypemethod(arg0, arg1, var2)
		var1 = var0:Call()
	end

	var0:Destroy()

	return var1
end

function var0.RefCallMethod(arg0, arg1, arg2, arg3, arg4)
	local var0
	local var1

	if arg3 then
		var0 = tolua.gettypemethod(arg0, arg1, var2, Type.DefaultBinder, arg3, {})
		var1 = var0:Call(arg2, unpack(arg4))
	else
		var0 = tolua.gettypemethod(arg0, arg1, var2)
		var1 = var0:Call(arg2)
	end

	var0:Destroy()

	return var1
end

function var0.RefCallMethodEx(arg0, arg1, arg2, arg3, arg4)
	local var0
	local var1
	local var2 = tolua.gettypemethod(arg0, arg1, arg3)
	local var3 = var2:Call(arg2, unpack(arg4))

	var2:Destroy()

	return var3
end

function var0.RefGetField(arg0, arg1, arg2)
	local var0 = tolua.getfield(arg0, arg1, var2)
	local var1 = var0:Get(arg2)

	var0:Destroy()

	return var1
end

function var0.RefSetField(arg0, arg1, arg2, arg3)
	local var0 = tolua.getfield(arg0, arg1, var2)

	var0:Set(arg2, arg3)
	var0:Destroy()
end

function var0.RefGetProperty(arg0, arg1, arg2)
	local var0 = tolua.getproperty(arg0, arg1, var2)
	local var1 = var0:Get(arg2, null)

	var0:Destroy()

	return var1
end

function var0.RefSetProperty(arg0, arg1, arg2, arg3)
	local var0 = tolua.getproperty(arg0, arg1, var2)

	var0:Set(arg2, arg3, null)
	var0:Destroy()
end

return var0
