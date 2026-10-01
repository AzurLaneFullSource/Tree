local var0_0 = class("RoomIKInput")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.system = arg1_1
	arg0_1.controlTouchPressTarget = nil
	arg0_1.controlDragIsIK = nil
end

function var0_0.GetSession(arg0_2)
	return arg0_2.system and arg0_2.system:GetSession()
end

function var0_0.CanHandleInput(arg0_3)
	return arg0_3.system and arg0_3.system:CanHandleIKInput()
end

function var0_0.OnControlPointerDown(arg0_4, arg1_4)
	if not arg0_4:CanHandleInput() then
		return
	end

	arg0_4.controlTouchPressTarget = nil

	local var0_4 = arg0_4:ResolveTouchTarget(arg1_4)

	if not var0_4 then
		return
	end

	arg0_4.controlTouchPressTarget = var0_4

	arg0_4:EmitTouchPress(true, var0_4, arg1_4)
end

function var0_0.OnControlPointerUp(arg0_5, arg1_5)
	local var0_5 = arg0_5.controlTouchPressTarget

	arg0_5.controlTouchPressTarget = nil

	if not var0_5 then
		return
	end

	arg0_5:EmitTouchPress(false, var0_5, arg1_5)
end

function var0_0.OnControlBeginDrag(arg0_6, arg1_6)
	if not arg0_6:CanHandleInput() then
		return
	end

	arg0_6.controlDragIsIK = nil

	local var0_6 = arg0_6:ResolveBodyTarget(arg1_6)

	if not var0_6 then
		return
	end

	local var1_6 = arg0_6:GetSession()

	if var1_6:IsBlocked() or var1_6.ikHandler then
		return
	end

	arg0_6.system:BeginIKBodyDrag(var0_6, arg1_6)

	arg0_6.controlDragIsIK = tobool(var1_6.ikHandler)
end

function var0_0.OnControlDrag(arg0_7, arg1_7, arg2_7)
	if not arg0_7:CanHandleInput() then
		return
	end

	if arg0_7:GetSession().ikHandler then
		arg0_7.system:DragIKBody(arg1_7)

		return
	end

	if arg0_7.controlDragIsIK then
		return
	end

	arg0_7.system:Emit(Dorm3dRoomTemplateScene.ON_STICK_MOVE, arg2_7)
end

function var0_0.OnControlEndDrag(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetSession()
	local var1_8 = var0_8 and var0_8.ikHandler or arg0_8.controlDragIsIK

	arg0_8.controlDragIsIK = nil

	if var1_8 then
		arg0_8.system:ReleaseIKBody()
	end
end

function var0_0.Cancel(arg0_9)
	arg0_9.controlTouchPressTarget = nil
	arg0_9.controlDragIsIK = nil

	if arg0_9.system then
		arg0_9.system:ReleaseIKBody()
	end
end

function var0_0.Dispose(arg0_10)
	arg0_10:Cancel()

	arg0_10.system = nil
end

function var0_0.GetIKRaycastTargets(arg0_11, arg1_11)
	local var0_11 = arg0_11:GetSession()
	local var1_11 = var0_11 and var0_11.ikSettings

	if not var1_11 or not var1_11.CameraRaycaster then
		return {}
	end

	local var2_11 = CameraMgr.instance:Raycast(var1_11.CameraRaycaster, arg1_11)

	return var2_11 and var2_11:ToTable() or {}
end

function var0_0.ResolveBodyTarget(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetSession()
	local var1_12 = var0_12 and var0_12.ikSettings

	if not var1_12 then
		return
	end

	for iter0_12, iter1_12 in ipairs(arg0_12:GetIKRaycastTargets(arg1_12)) do
		local var2_12 = iter1_12.gameObject.transform
		local var3_12 = table.keyof(var1_12.Colliders or {}, var2_12)

		if var3_12 then
			return var3_12
		end
	end
end

function var0_0.ResolveTouchTarget(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetSession()

	if not var0_13 or not var0_13.ikSettings then
		return
	end

	for iter0_13, iter1_13 in ipairs(arg0_13:GetIKRaycastTargets(arg1_13)) do
		local var1_13 = iter1_13.gameObject.transform
		local var2_13 = table.keyof(var0_13.ikSettings.Colliders or {}, var1_13)

		if var2_13 then
			return {
				source = "body",
				target = var2_13
			}
		end

		local var3_13 = arg0_13:ResolveTouchSceneItem(var1_13)

		if var3_13 then
			return {
				source = "scene_item",
				target = var3_13
			}
		end
	end
end

function var0_0.ResolveTouchSceneItem(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetSession()

	if not var0_14 or not var0_14.ikTouchDatas then
		return
	end

	for iter0_14, iter1_14 in ipairs(var0_14.ikTouchDatas) do
		local var1_14 = pg.dorm3d_ik_touch[iter1_14[1]]

		if #var1_14.scene_item > 0 then
			local var2_14 = arg0_14.system:GetSceneItem(var1_14.scene_item)

			if var2_14 and var0_0.IsTransformInHierarchy(arg1_14, var2_14) then
				return var1_14.scene_item
			end
		end
	end
end

function var0_0.IsTransformInHierarchy(arg0_15, arg1_15)
	while arg0_15 do
		if arg0_15 == arg1_15 then
			return true
		end

		arg0_15 = arg0_15.parent
	end

	return false
end

function var0_0.EmitTouchPress(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg2_16.source == "body" then
		arg0_16.system:Emit(arg1_16 and RoomTouchSystem.ON_TOUCH_CHARACTER_DOWN or RoomTouchSystem.ON_TOUCH_CHARACTER_UP, arg2_16.target, arg3_16)
	elseif arg2_16.source == "scene_item" then
		arg0_16.system:Emit(arg1_16 and RoomTouchSystem.ON_TOUCH_SCENE_ITEM_DOWN or RoomTouchSystem.ON_TOUCH_SCENE_ITEM_UP, arg2_16.target, arg3_16)
	end
end

return var0_0
