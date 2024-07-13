if System.Reflection == nil then
	System.Reflection = {}
end

local function var0_0(...)
	local var0_1 = {
		...
	}
	local var1_1 = 0

	for iter0_1 = 1, #var0_1 do
		var1_1 = var1_1 + var0_1[iter0_1]
	end

	return var1_1
end

local var1_0 = {
	Default = 0,
	SetField = 2048,
	Static = 8,
	FlattenHierarchy = 64,
	ExactBinding = 65536,
	InvokeMethod = 256,
	NonPublic = 32,
	PutRefDispProperty = 32768,
	SuppressChangeType = 131072,
	IgnoreReturn = 16777216,
	CreateInstance = 512,
	GetField = 1024,
	OptionalParamBinding = 262144,
	Public = 16,
	Instance = 4,
	SetProperty = 8192,
	DeclaredOnly = 2,
	GetProperty = 4096,
	PutDispProperty = 16384,
	IgnoreCase = 1
}

System.Reflection.BindingFlags = var1_0
System.Reflection.BindingFlags.GetMask = var0_0

return var1_0
