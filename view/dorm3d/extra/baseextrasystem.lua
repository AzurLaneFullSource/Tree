local var0_0 = class("BaseExtraSystem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg1_1
	arg0_1.scene = arg2_1
	arg0_1.context = arg0_1:WrapContext(arg2_1)
	arg0_1.bindings = {}
	arg0_1.isInitialized = false
end

function var0_0.WrapContext(arg0_2, arg1_2)
	return {
		GetModelRoot = function()
			return arg1_2:GetModelRoot()
		end,
		GetCurrentLadyEnv = function()
			return arg1_2:GetCurrentLadyEnv()
		end,
		GetSceneItem = function(arg0_5)
			return arg1_2:GetSceneItem(arg0_5)
		end,
		GetFurnitureByName = function(arg0_6)
			return arg1_2:GetFurnitureByName(arg0_6)
		end,
		GetLoader = function()
			return arg1_2.loader
		end,
		GetRoom = function()
			return arg1_2.room
		end,
		_raw = arg1_2
	}
end

function var0_0.Init(arg0_9)
	if arg0_9.isInitialized then
		warning(arg0_9.__cname .. " already initialized")

		return
	end

	arg0_9.isInitialized = true

	arg0_9:OnInit()
	arg0_9:RegisterEvents()
end

function var0_0.OnInit(arg0_10)
	return
end

function var0_0.RegisterEvents(arg0_11)
	return
end

function var0_0.Emit(arg0_12, arg1_12, ...)
	arg0_12.event:emit(arg1_12, ...)
end

function var0_0.Bind(arg0_13, arg1_13, arg2_13)
	arg0_13.bindings[arg1_13] = arg0_13.bindings[arg1_13] or {}

	table.insert(arg0_13.bindings[arg1_13], arg2_13)
	arg0_13.event:connect(arg1_13, arg2_13)
end

function var0_0.Unbind(arg0_14, arg1_14)
	local var0_14 = arg0_14.bindings[arg1_14]

	if not var0_14 then
		return
	end

	for iter0_14, iter1_14 in ipairs(var0_14) do
		arg0_14.event:disconnect(arg1_14, iter1_14)
	end

	arg0_14.bindings[arg1_14] = nil
end

function var0_0.UnbindAll(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.bindings) do
		arg0_15:Unbind(iter0_15)
	end

	arg0_15.bindings = {}
end

function var0_0.Update(arg0_16, arg1_16)
	if not arg0_16.isInitialized then
		return
	end

	arg0_16:OnUpdate(arg1_16)
end

function var0_0.OnUpdate(arg0_17, arg1_17)
	return
end

function var0_0.LateUpdate(arg0_18, arg1_18)
	if not arg0_18.isInitialized then
		return
	end

	arg0_18:OnLateUpdate(arg1_18)
end

function var0_0.OnLateUpdate(arg0_19, arg1_19)
	return
end

function var0_0.HandleNotification(arg0_20, arg1_20, arg2_20)
	if not arg0_20.isInitialized then
		return
	end

	arg0_20:OnHandleNotification(arg1_20, arg2_20)
end

function var0_0.OnHandleNotification(arg0_21, arg1_21, arg2_21)
	return
end

function var0_0.GetInterests()
	return {}
end

function var0_0.Func(arg0_23, arg1_23, ...)
	if not arg0_23.isInitialized then
		return nil
	end

	local var0_23 = arg0_23.scene

	if not var0_23 then
		warning("Scene is nil")

		return nil
	end

	local var1_23 = var0_23[arg1_23]

	if not var1_23 then
		warning("Method " .. arg1_23 .. " not found in scene")

		return nil
	end

	return var1_23(var0_23, ...)
end

function var0_0.Get(arg0_24, arg1_24)
	if not arg0_24.isInitialized then
		return nil
	end

	return arg0_24.scene[arg1_24]
end

function var0_0.GetModelRoot(arg0_25)
	return arg0_25.context.GetModelRoot()
end

function var0_0.GetCurrentLadyEnv(arg0_26)
	return arg0_26.context.GetCurrentLadyEnv()
end

function var0_0.GetSceneItem(arg0_27, arg1_27)
	return arg0_27.context.GetSceneItem(arg1_27)
end

function var0_0.GetFurnitureByName(arg0_28, arg1_28)
	return arg0_28.context.GetFurnitureByName(arg1_28)
end

function var0_0.GetLoader(arg0_29)
	return arg0_29.context.GetLoader()
end

function var0_0.GetRoom(arg0_30)
	return arg0_30.context.GetRoom()
end

function var0_0.IsOpen()
	return true
end

function var0_0.GetName(arg0_32)
	return arg0_32.__cname or "BaseExtraSystem"
end

function var0_0.Dispose(arg0_33)
	arg0_33:OnDispose()
	arg0_33:UnbindAll()

	arg0_33.event = nil
	arg0_33.context = nil
	arg0_33.scene = nil
	arg0_33.isInitialized = false
end

function var0_0.OnDispose(arg0_34)
	return
end

return var0_0
