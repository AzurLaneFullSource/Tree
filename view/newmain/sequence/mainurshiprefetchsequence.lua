local var0_0 = class("MainUrShipReFetchSequence", import("...base.ContextMediator"))

var0_0.ON_TIME_UP = "MainUrShipReFetchSequence:ON_TIME_UP"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1, BaseEventLogic.New())
	pg.m02:registerMediator(arg0_1)
end

function var0_0.Execute(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GRAFTING)

	if #var0_2 == 0 then
		arg1_2()

		return
	end

	arg0_2:CheckUrShipAct(var0_2, arg1_2)
end

local function var1_0(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityById(arg0_3)

	return var0_3 and not var0_3:isEnd()
end

local function var2_0(arg0_4)
	return arg0_4 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or arg0_4 == ActivityConst.ACTIVITY_TYPE_BUILD or arg0_4 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

local function var3_0(arg0_5)
	if not arg0_5 or arg0_5:isEnd() then
		return false
	end

	local var0_5 = arg0_5:getConfig("config_id")

	if var1_0(var0_5) then
		return false
	end

	local var1_5 = pg.activity_template[var0_5]

	return var1_5 and var2_0(var1_5.type)
end

function var0_0.CheckUrShipAct(arg0_6, arg1_6, arg2_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg1_6) do
		if var3_0(iter1_6) then
			table.insert(var0_6, function(arg0_7)
				arg0_6:TryFetchUrShips(iter1_6, arg0_7)
			end)
		end
	end

	seriesAsync(var0_6, arg2_6)
end

local function var4_0(arg0_8)
	local var0_8 = getProxy(ActivityProxy):getActivityById(arg0_8)

	if not var0_8 or var0_8:isEnd() then
		return false
	end

	local var1_8 = var0_8:getConfig("config_id")
	local var2_8 = pg.ship_data_create_exchange[var1_8]
	local var3_8 = var2_8.exchange_request
	local var4_8 = var2_8.exchange_available_times
	local var5_8 = var0_8.data1
	local var6_8 = var0_8.data2
	local var7_8 = math.min(var4_8, var6_8 + 1) * var3_8

	return var6_8 < var4_8 and var7_8 <= var5_8
end

function var0_0.TryFetchUrShips(arg0_9, arg1_9, arg2_9)
	local function var0_9()
		arg0_9:TryFetchUrShips(arg1_9, arg2_9)
	end

	if var4_0(arg1_9.id) then
		arg0_9:ShowFetchShipMsgbox(arg1_9.id, var0_9)
	else
		arg2_9()
	end
end

function var0_0.ShowFetchShipMsgbox(arg0_11, arg1_11, arg2_11)
	arg0_11.callback = arg2_11
	arg0_11.page = UrShipRefetchWindow.New(pg.UIMgr.GetInstance().UIMain)

	arg0_11.page:ExecuteAction("Show", arg1_11)
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		GAME.GRAFTING_ACT_OP_DONE,
		MainUrShipReFetchSequence.ON_TIME_UP
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()

	if var0_13 == GAME.GRAFTING_ACT_OP_DONE and var2_0(var1_13.linkActType) then
		if #var1_13.awards > 0 then
			arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_13.awards, arg0_13.callback)
		else
			arg0_13.callback()
		end

		if arg0_13.page and arg0_13.page:GetLoaded() and arg0_13.page:isShowing() then
			arg0_13.page:Hide()
		end

		arg0_13.callback = nil
	elseif var0_13 == MainUrShipReFetchSequence.ON_TIME_UP then
		if arg0_13.page and arg0_13.page:GetLoaded() and arg0_13.page:isShowing() then
			arg0_13.page:Hide()
		end

		if arg0_13.callback then
			arg0_13.callback()

			arg0_13.callback = nil
		end
	end
end

function var0_0.Clear(arg0_14)
	if arg0_14.page then
		arg0_14.page:Destroy()

		arg0_14.page = nil
	end
end

function var0_0.Dispose(arg0_15)
	pg.m02:removeMediator(arg0_15.__cname)
	arg0_15:Clear()
end

function var0_0.addSubLayers(arg0_16, arg1_16, arg2_16, arg3_16)
	assert(isa(arg1_16, Context), "should be an instance of Context")

	local var0_16 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewMainMediator)

	if arg2_16 then
		while var0_16.parent do
			var0_16 = var0_16.parent
		end
	end

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_16,
		context = arg1_16,
		callback = arg3_16
	})
end

return var0_0
