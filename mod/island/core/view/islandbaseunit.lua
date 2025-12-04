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

function var0_0.NotifiyCore(arg0_3, arg1_3, ...)
	arg0_3.view:NotifiyCore(arg1_3, ...)
end

function var0_0.Op(arg0_4, ...)
	arg0_4:GetView():Op(...)
end

function var0_0.NotifiyIsland(arg0_5, ...)
	arg0_5:GetView():NotifiyIsland(...)
end

function var0_0.NotifiyMeditor(arg0_6, arg1_6, ...)
	arg0_6:GetView():NotifiyMeditor(arg1_6, ...)
end

function var0_0.Init(arg0_7, ...)
	if arg0_7:IsEmpty() then
		arg0_7:OnInit(...)

		arg0_7.__state = var2_0
	else
		arg0_7:OnAnomalyInit(...)
	end
end

function var0_0.IsEmpty(arg0_8)
	return arg0_8.__state == var1_0
end

function var0_0.IsLoaded(arg0_9)
	return arg0_9.__state == var2_0
end

function var0_0.GetView(arg0_10)
	return arg0_10.view
end

function var0_0.GetPoolMgr(arg0_11)
	return arg0_11.view:GetPoolMgr()
end

function var0_0.GetIsland(arg0_12)
	return arg0_12.view:GetIsland()
end

function var0_0.GetSelfIsland(arg0_13)
	return arg0_13.view:GetSelfIsland()
end

function var0_0.Reset(arg0_14)
	if arg0_14:IsLoaded() then
		arg0_14:OnDispose()
	end

	arg0_14:OnDestroy()

	arg0_14.__state = var1_0
end

function var0_0.Dispose(arg0_15)
	if arg0_15.__state == var3_0 then
		return
	end

	pg.DelegateInfo.Dispose(arg0_15)

	if arg0_15:IsLoaded() then
		arg0_15:OnDispose()
	end

	arg0_15.__state = var3_0

	arg0_15:OnDestroy()

	arg0_15.view = nil
end

function var0_0.Update(arg0_16)
	if not arg0_16:IsLoaded() then
		return
	end

	arg0_16:OnUpdate()
end

function var0_0.LateUpdate(arg0_17)
	if not arg0_17:IsLoaded() then
		return
	end

	arg0_17:OnLateUpdate()
end

function var0_0.OnInit(arg0_18, ...)
	return
end

function var0_0.OnAnomalyInit(arg0_19, ...)
	return
end

function var0_0.Start(arg0_20)
	return
end

function var0_0.OnUpdate(arg0_21)
	return
end

function var0_0.OnLateUpdate(arg0_22)
	return
end

function var0_0.OnDispose(arg0_23)
	return
end

function var0_0.OnDestroy(arg0_24)
	return
end

return var0_0
