local var0_0 = class("RoomIKDriver")

function var0_0.Ctor(arg0_1)
	arg0_1.session = nil
	arg0_1.generation = nil
	arg0_1.callbacks = nil
	arg0_1.attached = false
	arg0_1.envRegistered = false
end

function var0_0.IsCurrent(arg0_2)
	return arg0_2.attached and arg0_2.session and arg0_2.session:IsCurrent(arg0_2.generation)
end

function var0_0.Forward(arg0_3, arg1_3, ...)
	if not arg0_3:IsCurrent() then
		return
	end

	local var0_3 = arg0_3.callbacks and arg0_3.callbacks[arg1_3]

	existCall(var0_3, ...)
end

function var0_0.Attach(arg0_4, arg1_4, arg2_4)
	assert(arg1_4, "Missing RoomIK session")
	assert(arg1_4.controllers, "Missing RoomIK controllers")

	if #arg1_4.controllers == 0 then
		arg0_4:Detach()

		return
	end

	assert(arg1_4.ikRoot, "Missing RoomIK IK root")
	assert(arg1_4.boneMaps, "Missing RoomIK bone maps")
	arg0_4:Detach()

	arg0_4.session = arg1_4
	arg0_4.generation = arg1_4.generation
	arg0_4.callbacks = arg2_4 or {}

	local var0_4 = pg.IKMgr.GetInstance()

	var0_4:RegisterEnv(arg1_4.ikRoot, arg1_4.boneMaps)

	arg0_4.envRegistered = true
	arg0_4.attached = true

	var0_4:RegisterOnIKLayerActive(function(arg0_5)
		arg0_4:Forward("active", arg0_5)
	end)
	var0_4:RegisterOnIKLayerDrag(function(arg0_6)
		arg0_4:Forward("drag", arg0_6)
	end)
	var0_4:RegisterOnIKLayerDeactive(function(arg0_7, arg1_7)
		arg0_4:Forward("deactive", arg0_7, arg1_7)
	end)
	var0_4:RegisterOnIKLayerAction(function(arg0_8)
		arg0_4:Forward("action", arg0_8)
	end)
	var0_4:SetIKStatus(arg1_4.controllers)
end

function var0_0.Detach(arg0_9)
	local var0_9 = arg0_9.envRegistered

	arg0_9.attached = false
	arg0_9.envRegistered = false
	arg0_9.callbacks = nil
	arg0_9.session = nil
	arg0_9.generation = nil

	if not var0_9 then
		return
	end

	local var1_9 = pg.IKMgr.GetInstance()

	var1_9:ReleaseDrag()
	var1_9:UnregisterEnv()
end

function var0_0.BeginDrag(arg0_10, arg1_10, arg2_10)
	if not arg0_10:IsCurrent() then
		return
	end

	pg.IKMgr.GetInstance():OnDragBegin(arg1_10, arg2_10)
end

function var0_0.Drag(arg0_11, arg1_11)
	if not arg0_11:IsCurrent() then
		return
	end

	pg.IKMgr.GetInstance():HandleBodyDrag(arg1_11)
end

function var0_0.Release(arg0_12)
	if not arg0_12.attached then
		return
	end

	pg.IKMgr.GetInstance():ReleaseDrag()
end

function var0_0.Reset(arg0_13, arg1_13)
	if not arg0_13:IsCurrent() then
		return
	end

	pg.IKMgr.GetInstance():ResetIK(arg1_13)
end

function var0_0.ResetActiveLayers(arg0_14)
	if not arg0_14:IsCurrent() then
		return
	end

	pg.IKMgr.GetInstance():ResetActiveIKs()
end

function var0_0.PlayMove(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15)
	if not arg0_15:IsCurrent() then
		return
	end

	pg.IKMgr.GetInstance():PlayIKMove(arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15)
end

return var0_0
