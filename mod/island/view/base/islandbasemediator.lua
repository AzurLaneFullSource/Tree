local var0_0 = class("IslandBaseMediator", import("view.base.ContextMediator"))

var0_0.SET_UP = "IslandBaseScene:SET_UP"
var0_0.SWITCH_MAP = "IslandBaseMediator:SWITCH_MAP"
var0_0.RECORD_PLAYER_POS = "IslandBaseMediator:RECORD_PLAYER_POS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SET_UP, function(arg0_2)
		arg0_1:SetUp()
	end)
	arg0_1:bind(var0_0.SWITCH_MAP, function(arg0_3, arg1_3, arg2_3)
		local var0_3 = arg0_1.viewComponent:GetIsland()

		if not var0_3:GetAblityAgency():IsUnlockMap(arg1_3) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_lock_map_tip"))

			return
		end

		arg0_1:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = var0_3.id,
			mapId = arg1_3,
			callback = function()
				local var0_4 = pg.island_world_objects[arg2_3]

				if var0_4 then
					local var1_4 = BuildVector3(var0_4.param.position)
					local var2_4 = BuildVector3(var0_4.param.rotation)

					arg0_1:RecordPlayerPosition(arg1_3, var1_4, var2_4)
				end

				arg0_1:SwitchScene(arg1_3, arg2_3)
			end
		})
	end)
	arg0_1:bind(var0_0.RECORD_PLAYER_POS, function(arg0_5)
		if not _IslandCore then
			return
		end

		local var0_5 = _IslandCore:GetController().mapId
		local var1_5 = _IslandCore:GetView().player

		if not var1_5 then
			return
		end

		local var2_5, var3_5 = var1_5:LastGroundedPosition()

		arg0_1:RecordPlayerPosition(var0_5, var2_5, var3_5)
	end)
	arg0_1:_register()
end

function var0_0.RecordPlayerPosition(arg0_6, arg1_6, arg2_6, arg3_6)
	if not _IslandCore then
		return
	end

	if not _IslandCore:GetController():IsSelfIsland() then
		return
	end

	arg0_6:sendNotification(GAME.ISLAND_RECORD_LAST_EXIT_POS, {
		islandId = arg0_6.viewComponent:GetIsland().id,
		mapId = arg1_6,
		position = arg2_6,
		rotation = arg3_6
	})
end

function var0_0.listNotificationInterests(arg0_7)
	return arg0_7:_listNotificationInterests()
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	arg0_8:_handleNotification(arg1_8)
	arg0_8.viewComponent:emit(var0_8, var1_8)
end

function var0_0.SetUp(arg0_9)
	local var0_9 = arg0_9.viewComponent:GetIsland()
	local var1_9 = var0_9.mapID
	local var2_9 = var0_9.spawnPointId

	_IslandCore = IslandCore.New(arg0_9.viewComponent:GetPoolMgr(), var0_9)

	arg0_9.viewComponent:OnSetUpCore(var1_9, var2_9)
end

function var0_0.SwitchScene(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.viewComponent:GetIsland()

	var0_10:SetMapId(arg1_10)

	if arg2_10 then
		var0_10:SetSpawnPointId(arg2_10)
	end

	arg0_10:UnloadScene()
	arg0_10:SetUp()
end

function var0_0.UnloadScene(arg0_11, arg1_11)
	arg0_11.viewComponent:OnUnloadScene()

	if _IslandCore then
		_IslandCore:Dispose(arg1_11)

		_IslandCore = nil
	end
end

function var0_0.remove(arg0_12)
	arg0_12:UnloadScene(true)
	arg0_12:_remove()
end

function var0_0._register(arg0_13)
	return
end

function var0_0._listNotificationInterests(arg0_14)
	return {}
end

function var0_0._handleNotification(arg0_15, arg1_15)
	return
end

function var0_0._remove(arg0_16)
	return
end

return var0_0
