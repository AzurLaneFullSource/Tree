local var0_0 = class("IslandBaseMediator", import("view.base.ContextMediator"))

var0_0.SET_UP = "IslandBaseScene:SET_UP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SET_UP, function(arg0_2)
		arg0_1:SetUp()
	end)
	arg0_1:_register()
end

function var0_0.listNotificationInterests(arg0_3)
	return arg0_3:_listNotificationInterests()
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	arg0_4:_handleNotification(arg1_4)
	arg0_4.viewComponent:emit(var0_4, var1_4)
end

function var0_0.SetUp(arg0_5, arg1_5)
	local var0_5 = arg0_5.viewComponent:GetIsland()

	_IslandCore = IslandCore.New(var0_5, arg1_5)
end

function var0_0.SwitchScene(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.viewComponent:GetIsland()

	var0_6:SetMapId(arg1_6)

	if arg2_6 then
		var0_6:SetSpawnPointId(arg2_6)
	end

	arg0_6:UnloadScene()
	arg0_6:SetUp(true)
end

function var0_0.UnloadScene(arg0_7, arg1_7)
	arg0_7.viewComponent:OnUnloadScene()

	if _IslandCore then
		_IslandCore:Dispose(arg1_7)

		_IslandCore = nil
	end
end

function var0_0.remove(arg0_8)
	arg0_8:UnloadScene(true)
	arg0_8:_remove()
end

function var0_0._register(arg0_9)
	return
end

function var0_0._listNotificationInterests(arg0_10)
	return {}
end

function var0_0._handleNotification(arg0_11, arg1_11)
	return
end

function var0_0._remove(arg0_12)
	return
end

return var0_0
