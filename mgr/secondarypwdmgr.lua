pg = pg or {}

local var0_0 = pg

var0_0.SecondaryPWDMgr = singletonClass("SecondaryPWDMgr")

local var1_0 = var0_0.SecondaryPWDMgr

var1_0.UNLOCK_SHIP = 1
var1_0.UNLOCK_COMMANDER = 2
var1_0.RESOLVE_EQUIPMENT = 3
var1_0.CREATE_INHERIT = 4
var1_0.CLOSE_PASSWORD = 98
var1_0.SET_PASSWORD = 99
var1_0.CHANGE_SETTING = 100

local function var2_0()
	if not PLATFORM_CODE then
		return
	end

	local var0_1 = {
		var1_0.UNLOCK_SHIP,
		var1_0.RESOLVE_EQUIPMENT
	}

	if PLATFORM_CODE ~= PLATFORM_US then
		table.insert(var0_1, 2, var1_0.UNLOCK_COMMANDER)
	end

	if PLATFORM_CODE == PLATFORM_JP then
		table.insert(var0_1, var1_0.CREATE_INHERIT)
	end

	return var0_1
end

function var1_0.Init(arg0_2, arg1_2)
	var1_0.LIMITED_OPERATION = var2_0()

	if arg1_2 then
		arg1_2()
	end
end

function var1_0.LimitedOperation(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = getProxy(SecondaryPWDProxy)
	local var1_3 = var0_3:getRawData()

	if not table.contains(var1_3.system_list, arg1_3) then
		if arg3_3 then
			arg3_3()
		end

		return
	end

	if var1_3.state == 0 then
		if arg3_3 then
			arg3_3()
		end

		return
	end

	local var2_3, var3_3 = var0_3:GetPermissionState()

	if not var2_3 then
		arg0_3:ShowWarningWindow()
		var0_0.m02:sendNotification(GAME.CANCEL_LIMITED_OPERATION)

		return
	end

	if var1_3.state == 2 then
		if arg3_3 then
			arg3_3()
		end

		return
	end

	local var4_3 = Context.New({
		mediator = SecondaryPasswordMediator,
		viewComponent = SecondaryPasswordLayer,
		data = {
			mode = SecondaryPasswordLayer.InputView,
			type = arg1_3,
			info = arg2_3,
			callback = arg3_3,
			LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
		}
	})

	arg0_3:LoadLayer(var4_3)
end

function var1_0.ChangeSetting(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(SecondaryPWDProxy)
	local var1_4 = var0_4:getRawData()

	if table.equal(arg1_4, var1_4.system_list) then
		return
	end

	local var2_4, var3_4 = var0_4:GetPermissionState()

	if not var2_4 then
		arg0_4:ShowWarningWindow()
		var0_0.m02:sendNotification(GAME.CANCEL_LIMITED_OPERATION)

		return
	end

	local var4_4 = Context.New({
		mediator = SecondaryPasswordMediator,
		viewComponent = SecondaryPasswordLayer,
		data = {
			mode = SecondaryPasswordLayer.InputView,
			type = #arg1_4 == 0 and var1_0.CLOSE_PASSWORD or var1_0.CHANGE_SETTING,
			settings = arg1_4,
			callback = arg2_4
		}
	})

	arg0_4:LoadLayer(var4_4)
end

function var1_0.SetPassword(arg0_5, arg1_5)
	if getProxy(SecondaryPWDProxy):getRawData().state > 0 then
		return
	end

	local var0_5 = Context.New({
		mediator = SecondaryPasswordMediator,
		viewComponent = SecondaryPasswordLayer,
		data = {
			mode = SecondaryPasswordLayer.SetView,
			type = var1_0.SET_PASSWORD,
			settings = var1_0.LIMITED_OPERATION,
			callback = arg1_5
		}
	})

	arg0_5:LoadLayer(var0_5)
end

function var1_0.LoadLayer(arg0_6, arg1_6)
	local var0_6 = getProxy(ContextProxy):getCurrentContext()
	local var1_6 = var0_6:getContextByMediator(var0_6.mediator)

	while var1_6.parent do
		var1_6 = var1_6.parent
	end

	var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var1_6,
		context = arg1_6
	})
end

function var1_0.ShowWarningWindow(arg0_7)
	local var0_7 = {
		title = "warning",
		mode = "showresttime",
		hideNo = true,
		type = MSGBOX_TYPE_SECONDPWD
	}

	var0_0.MsgboxMgr.GetInstance():ShowMsgBox(var0_7)
end

function var1_0.FetchData(arg0_8)
	var0_0.m02:sendNotification(GAME.FETCH_PASSWORD_STATE)
end

function var1_0.IsNormalOp(arg0_9, arg1_9)
	if not arg1_9 then
		return false
	end

	return table.contains(var1_0.LIMITED_OPERATION, arg1_9)
end

function var1_0.Dispose(arg0_10)
	return
end

return var1_0
