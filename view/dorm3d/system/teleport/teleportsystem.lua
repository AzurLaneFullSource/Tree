local var0_0 = class("TeleportSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.MAX_DISTANCE = 1.5

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1:GetRoom().id

	warning("TeleportSystem Init for room:", var0_1)

	arg0_1.configs = pg.dorm3d_teleport.get_id_list_by_room_id[var0_1] or {}
	arg0_1.boundTriggers = {}

	arg0_1:BindClickFunc()
end

function var0_0.BindClickFunc(arg0_2)
	arg0_2:ClearClickBindings()
	_.each(arg0_2.configs, function(arg0_3)
		local var0_3 = pg.dorm3d_teleport[arg0_3]

		warning(var0_3)

		local var1_3 = arg0_2:GetSceneItem(var0_3.item_path)

		if not var1_3 then
			return
		end

		local var2_3 = pg.dorm3d_zone_template[var0_3.teleport_zone] and pg.dorm3d_zone_template[var0_3.teleport_zone].watch_camera

		assert(var2_3, "invalid zone:" .. tostring(var0_3.teleport_zone))

		local var3_3 = GetOrAddComponent(var1_3, typeof(EventTriggerListener))

		var3_3:AddPointClickFunc(function(arg0_4, arg1_4)
			if arg0_2:GetIsInFurnitureSelect() then
				return
			end

			local var0_4 = arg1_4.position
			local var1_4 = CameraMgr.instance:Raycast(arg0_2:GetSceneRaycaster(), var0_4):ToTable()

			if #var1_4 > 0 then
				if var1_4[1].gameObject.transform ~= var1_3.transform then
					return
				end

				local var2_4 = arg0_2:GetPlayer()

				if Vector3.Distance(var2_4.transform.position, var1_3.transform.position) > var0_0.MAX_DISTANCE then
					return
				end

				arg0_2:Emit(Dorm3dRoomTemplateScene.SHIFT_ZONE_SAFE, var2_3)
			end
		end)

		arg0_2.boundTriggers[var1_3] = var3_3
	end)
end

function var0_0.RegisterEvents(arg0_5)
	arg0_5:Bind(Dorm3dRoomTemplateScene.ART_SCENE_WILL_CHANGE, function()
		arg0_5:ClearClickBindings()
	end)
	arg0_5:Bind(Dorm3dRoomTemplateScene.ART_SCENE_CHANGED, function(arg0_7, arg1_7, arg2_7)
		if arg2_7 then
			arg0_5:BindClickFunc()
		end
	end)
end

function var0_0.OnHandleNotification(arg0_8, arg1_8, arg2_8)
	return
end

function var0_0.GetInterests()
	return {}
end

function var0_0.OnDispose(arg0_10)
	arg0_10:ClearClickBindings()
end

function var0_0.ClearClickBindings(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.boundTriggers or {}) do
		iter1_11:RemovePointClickFunc()
	end

	arg0_11.boundTriggers = {}
end

return var0_0
