local var0_0 = class("IslandBaseUnit")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.__state = var1_0
	arg0_1.view = arg1_1
end

function var0_0.IsSelfIsland(arg0_2)
	return arg0_2.view:IsSelfIsland()
end

function var0_0.Emit(arg0_3, arg1_3, ...)
	arg0_3.view:Emit(arg1_3, ...)
end

function var0_0.Op(arg0_4, ...)
	arg0_4:GetView():Op(...)
end

function var0_0.Init(arg0_5, ...)
	if arg0_5:IsEmpty() then
		arg0_5:OnInit(...)

		arg0_5.__state = var2_0
	end
end

function var0_0.IsEmpty(arg0_6)
	return arg0_6.__state == var1_0
end

function var0_0.IsLoaded(arg0_7)
	return arg0_7.__state == var2_0
end

function var0_0.GetView(arg0_8)
	return arg0_8.view
end

function var0_0.Dispose(arg0_9)
	if arg0_9:IsLoaded() then
		arg0_9.__state = var3_0

		arg0_9:OnDispose()

		arg0_9.view = nil
	end

	arg0_9:OnDestroy()
end

function var0_0.Update(arg0_10)
	if not arg0_10:IsLoaded() then
		return
	end

	arg0_10:OnUpdate()
end

function var0_0.LateUpdate(arg0_11)
	if not arg0_11:IsLoaded() then
		return
	end

	arg0_11:OnLateUpdate()
end

function var0_0.OnInit(arg0_12, ...)
	return
end

function var0_0.Start(arg0_13)
	return
end

function var0_0.OnUpdate(arg0_14)
	return
end

function var0_0.OnLateUpdate(arg0_15)
	return
end

function var0_0.OnDispose(arg0_16)
	return
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
