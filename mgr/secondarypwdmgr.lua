pg = pg or {}

local var0 = pg

var0.SecondaryPWDMgr = singletonClass("SecondaryPWDMgr")

local var1 = var0.SecondaryPWDMgr

var1.UNLOCK_SHIP = 1
var1.UNLOCK_COMMANDER = 2
var1.RESOLVE_EQUIPMENT = 3
var1.CREATE_INHERIT = 4
var1.CLOSE_PASSWORD = 98
var1.SET_PASSWORD = 99
var1.CHANGE_SETTING = 100

local function var2()
	if not PLATFORM_CODE then
		return
	end

	local var0 = {
		var1.UNLOCK_SHIP,
		var1.RESOLVE_EQUIPMENT
	}

	if PLATFORM_CODE ~= PLATFORM_US then
		table.insert(var0, 2, var1.UNLOCK_COMMANDER)
	end

	if PLATFORM_CODE == PLATFORM_JP then
		table.insert(var0, var1.CREATE_INHERIT)
	end

	return var0
end

function var1.Init(arg0, arg1)
	var1.LIMITED_OPERATION = var2()

	if arg1 then
		arg1()
	end
end

function var1.LimitedOperation(arg0, arg1, arg2, arg3)
	local var0 = getProxy(SecondaryPWDProxy)
	local var1 = var0:getRawData()

	if not table.contains(var1.system_list, arg1) then
		if arg3 then
			arg3()
		end

		return
	end

	if var1.state == 0 then
		if arg3 then
			arg3()
		end

		return
	end

	local var2, var3 = var0:GetPermissionState()

	if not var2 then
		arg0:ShowWarningWindow()
		var0.m02:sendNotification(GAME.CANCEL_LIMITED_OPERATION)

		return
	end

	if var1.state == 2 then
		if arg3 then
			arg3()
		end

		return
	end

	local var4 = Context.New({
		mediator = SecondaryPasswordMediator,
		viewComponent = SecondaryPasswordLayer,
		data = {
			mode = SecondaryPasswordLayer.InputView,
			type = arg1,
			info = arg2,
			callback = arg3,
			LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
		}
	})

	arg0:LoadLayer(var4)
end

function var1.ChangeSetting(arg0, arg1, arg2)
	local var0 = getProxy(SecondaryPWDProxy)
	local var1 = var0:getRawData()

	if table.equal(arg1, var1.system_list) then
		return
	end

	local var2, var3 = var0:GetPermissionState()

	if not var2 then
		arg0:ShowWarningWindow()
		var0.m02:sendNotification(GAME.CANCEL_LIMITED_OPERATION)

		return
	end

	local var4 = Context.New({
		mediator = SecondaryPasswordMediator,
		viewComponent = SecondaryPasswordLayer,
		data = {
			mode = SecondaryPasswordLayer.InputView,
			type = #arg1 == 0 and var1.CLOSE_PASSWORD or var1.CHANGE_SETTING,
			settings = arg1,
			callback = arg2
		}
	})

	arg0:LoadLayer(var4)
end

function var1.SetPassword(arg0, arg1)
	if getProxy(SecondaryPWDProxy):getRawData().state > 0 then
		return
	end

	local var0 = Context.New({
		mediator = SecondaryPasswordMediator,
		viewComponent = SecondaryPasswordLayer,
		data = {
			mode = SecondaryPasswordLayer.SetView,
			type = var1.SET_PASSWORD,
			settings = var1.LIMITED_OPERATION,
			callback = arg1
		}
	})

	arg0:LoadLayer(var0)
end

function var1.LoadLayer(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext()
	local var1 = var0:getContextByMediator(var0.mediator)

	while var1.parent do
		var1 = var1.parent
	end

	var0.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var1,
		context = arg1
	})
end

function var1.ShowWarningWindow(arg0)
	local var0 = {
		title = "warning",
		mode = "showresttime",
		hideNo = true,
		type = MSGBOX_TYPE_SECONDPWD
	}

	var0.MsgboxMgr.GetInstance():ShowMsgBox(var0)
end

function var1.FetchData(arg0)
	var0.m02:sendNotification(GAME.FETCH_PASSWORD_STATE)
end

function var1.IsNormalOp(arg0, arg1)
	if not arg1 then
		return false
	end

	return table.contains(var1.LIMITED_OPERATION, arg1)
end

function var1.Dispose(arg0)
	return
end

return var1
