local var0 = class("MainUrShipReFetchSequence", import("...base.ContextMediator"))

var0.ON_TIME_UP = "MainUrShipReFetchSequence:ON_TIME_UP"

function var0.Ctor(arg0)
	var0.super.Ctor(arg0, BaseEventLogic.New())
	pg.m02:registerMediator(arg0)
end

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GRAFTING)

	if #var0 == 0 then
		arg1()

		return
	end

	arg0:CheckUrShipAct(var0, arg1)
end

local function var1(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0)

	return var0 and not var0:isEnd()
end

local function var2(arg0)
	return arg0 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or arg0 == ActivityConst.ACTIVITY_TYPE_BUILD or arg0 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

local function var3(arg0)
	if not arg0 or arg0:isEnd() then
		return false
	end

	local var0 = arg0:getConfig("config_id")

	if var1(var0) then
		return false
	end

	local var1 = pg.activity_template[var0]

	return var1 and var2(var1.type)
end

function var0.CheckUrShipAct(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg1) do
		if var3(iter1) then
			table.insert(var0, function(arg0)
				arg0:TryFetchUrShips(iter1, arg0)
			end)
		end
	end

	seriesAsync(var0, arg2)
end

local function var4(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0)

	if not var0 or var0:isEnd() then
		return false
	end

	local var1 = var0:getConfig("config_id")
	local var2 = pg.ship_data_create_exchange[var1]
	local var3 = var2.exchange_request
	local var4 = var2.exchange_available_times
	local var5 = var0.data1
	local var6 = var0.data2
	local var7 = math.min(var4, var6 + 1) * var3

	return var6 < var4 and var7 <= var5
end

function var0.TryFetchUrShips(arg0, arg1, arg2)
	local function var0()
		arg0:TryFetchUrShips(arg1, arg2)
	end

	if var4(arg1.id) then
		arg0:ShowFetchShipMsgbox(arg1.id, var0)
	else
		arg2()
	end
end

function var0.ShowFetchShipMsgbox(arg0, arg1, arg2)
	arg0.callback = arg2
	arg0.page = UrShipRefetchWindow.New(pg.UIMgr.GetInstance().UIMain)

	arg0.page:ExecuteAction("Show", arg1)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.GRAFTING_ACT_OP_DONE,
		MainUrShipReFetchSequence.ON_TIME_UP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.GRAFTING_ACT_OP_DONE and var2(var1.linkActType) then
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, arg0.callback)
		else
			arg0.callback()
		end

		if arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() then
			arg0.page:Hide()
		end

		arg0.callback = nil
	elseif var0 == MainUrShipReFetchSequence.ON_TIME_UP then
		if arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() then
			arg0.page:Hide()
		end

		if arg0.callback then
			arg0.callback()

			arg0.callback = nil
		end
	end
end

function var0.Clear(arg0)
	if arg0.page then
		arg0.page:Destroy()

		arg0.page = nil
	end
end

function var0.Dispose(arg0)
	pg.m02:removeMediator(arg0.__cname)
	arg0:Clear()
end

function var0.addSubLayers(arg0, arg1, arg2, arg3)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewMainMediator)

	if arg2 then
		while var0.parent do
			var0 = var0.parent
		end
	end

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0,
		context = arg1,
		callback = arg3
	})
end

return var0
