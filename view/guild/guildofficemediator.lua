local var0 = class("GuildOfficeMediator", import("..base.ContextMediator"))

var0.ON_ACCEPT_TASK = "GuildOfficeMediator:ON_ACCEPT_TASK"
var0.ON_COMMIT = "GuildOfficeMediator:ON_COMMIT"
var0.ON_FETCH_CAPITAL_LOG = "GuildOfficeMediator:ON_FETCH_CAPITAL_LOG"
var0.ON_SELECT_TASK = "GuildOfficeMediator:ON_SELECT_TASK"
var0.ON_SUBMIT_TASK = "GuildOfficeMediator:ON_SUBMIT_TASK"
var0.UPDATE_WEEKLY_TASK = "GuildOfficeMediator:UPDATE_WEEKLY_TASK"
var0.ON_PURCHASE_SUPPLY = "GuildOfficeMediator:ON_PURCHASE_SUPPLY"
var0.GET_SUPPLY_AWARD = "GuildOfficeMediator:GET_SUPPLY_AWARD"
var0.REFRES_DONATE_LIST = "GuildOfficeMediator:REFRES_DONATE_LIST"

function var0.register(arg0)
	local var0 = getProxy(GuildProxy)

	arg0:bind(var0.REFRES_DONATE_LIST, function(arg0, arg1)
		return
	end)
	arg0:bind(var0.UPDATE_WEEKLY_TASK, function(arg0)
		arg0:sendNotification(GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE)
	end)
	arg0:bind(var0.ON_SUBMIT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
	end)
	arg0:bind(var0.ON_SELECT_TASK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_SELECT_TASK, {
			taskId = arg1,
			num = arg2
		})
	end)
	arg0:bind(var0.ON_ACCEPT_TASK, function(arg0, arg1)
		arg0:sendNotification(GAME.TRIGGER_TASK, arg1)
	end)
	arg0:bind(var0.ON_COMMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_COMMIT_DONATE, {
			taskId = arg1
		})
	end)
	arg0:bind(var0.ON_PURCHASE_SUPPLY, function(arg0)
		arg0:sendNotification(GAME.GUILD_BUY_SUPPLY)
	end)
	arg0:bind(var0.GET_SUPPLY_AWARD, function(arg0)
		arg0:sendNotification(GAME.GUILD_GET_SUPPLY_AWARD)
	end)

	local var1 = var0:getData()

	arg0.viewComponent:SetGuild(var1)

	local var2 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:setPlayer(var2)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.TRIGGER_TASK_DONE,
		GAME.GUILD_COMMIT_DONATE_DONE,
		GAME.SUBMIT_TASK_DONE,
		GuildProxy.GUILD_UPDATED,
		GuildProxy.WEEKLYTASK_ADDED,
		GuildProxy.WEEKLYTASK_UPDATED,
		GuildProxy.CAPITAL_UPDATED,
		PlayerProxy.UPDATED,
		GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE_DONE,
		GAME.GUILD_GET_SUPPLY_AWARD_DONE,
		GuildProxy.SUPPLY_STARTED,
		GAME.ZERO_HOUR_OP_DONE,
		TaskProxy.TASK_UPDATED,
		GuildProxy.ON_DONATE_LIST_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GuildProxy.GUILD_UPDATED then
		arg0.viewComponent:SetGuild(var1)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getRawData())
	elseif var0 == GAME.GUILD_COMMIT_DONATE_DONE then
		arg0.viewComponent:UpdateContribution()

		local function var2()
			return
		end

		if var1.awards and #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var2)
		else
			var2()
		end
	elseif var0 == GuildProxy.ON_DONATE_LIST_UPDATED then
		arg0.viewComponent:UpdateContribution()
	elseif var0 == GAME.TRIGGER_TASK_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_get_week_done"))
		arg0.viewComponent:UpdateTask()
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
		arg0.viewComponent:UpdateTask(true)
	elseif var0 == GuildProxy.WEEKLYTASK_ADDED or var0 == GuildProxy.WEEKLYTASK_UPDATED or var0 == GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE_DONE then
		arg0.viewComponent:UpdateTask()
	elseif var0 == GAME.GUILD_GET_SUPPLY_AWARD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.list)
		arg0.viewComponent:UpdateSupplyPanel()
	elseif var0 == GuildProxy.SUPPLY_STARTED then
		arg0.viewComponent:UpdateSupplyPanel()
	elseif var0 == GAME.ZERO_HOUR_OP_DONE then
		-- block empty
	elseif var0 == TaskProxy.TASK_UPDATED then
		local var3 = getProxy(GuildProxy):getRawData()

		if var3 then
			local var4 = var3:getWeeklyTask()

			if var4 and var4.id > 0 and var4:IsSamePrivateTask(var1) then
				arg0.viewComponent:UpdateTask()
			end
		end
	end
end

return var0
