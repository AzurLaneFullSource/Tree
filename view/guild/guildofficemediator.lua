local var0_0 = class("GuildOfficeMediator", import("..base.ContextMediator"))

var0_0.ON_ACCEPT_TASK = "GuildOfficeMediator:ON_ACCEPT_TASK"
var0_0.ON_COMMIT = "GuildOfficeMediator:ON_COMMIT"
var0_0.ON_FETCH_CAPITAL_LOG = "GuildOfficeMediator:ON_FETCH_CAPITAL_LOG"
var0_0.ON_SELECT_TASK = "GuildOfficeMediator:ON_SELECT_TASK"
var0_0.ON_SUBMIT_TASK = "GuildOfficeMediator:ON_SUBMIT_TASK"
var0_0.UPDATE_WEEKLY_TASK = "GuildOfficeMediator:UPDATE_WEEKLY_TASK"
var0_0.ON_PURCHASE_SUPPLY = "GuildOfficeMediator:ON_PURCHASE_SUPPLY"
var0_0.GET_SUPPLY_AWARD = "GuildOfficeMediator:GET_SUPPLY_AWARD"
var0_0.REFRES_DONATE_LIST = "GuildOfficeMediator:REFRES_DONATE_LIST"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(GuildProxy)

	arg0_1:bind(var0_0.REFRES_DONATE_LIST, function(arg0_2, arg1_2)
		return
	end)
	arg0_1:bind(var0_0.UPDATE_WEEKLY_TASK, function(arg0_3)
		arg0_1:sendNotification(GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE)
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4)
	end)
	arg0_1:bind(var0_0.ON_SELECT_TASK, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.GUILD_SELECT_TASK, {
			taskId = arg1_5,
			num = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_ACCEPT_TASK, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.TRIGGER_TASK, arg1_6)
	end)
	arg0_1:bind(var0_0.ON_COMMIT, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.GUILD_COMMIT_DONATE, {
			taskId = arg1_7
		})
	end)
	arg0_1:bind(var0_0.ON_PURCHASE_SUPPLY, function(arg0_8)
		arg0_1:sendNotification(GAME.GUILD_BUY_SUPPLY)
	end)
	arg0_1:bind(var0_0.GET_SUPPLY_AWARD, function(arg0_9)
		arg0_1:sendNotification(GAME.GUILD_GET_SUPPLY_AWARD)
	end)

	local var1_1 = var0_1:getData()

	arg0_1.viewComponent:SetGuild(var1_1)

	local var2_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var2_1)
end

function var0_0.listNotificationInterests(arg0_10)
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

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == GuildProxy.GUILD_UPDATED then
		arg0_11.viewComponent:SetGuild(var1_11)
	elseif var0_11 == PlayerProxy.UPDATED then
		arg0_11.viewComponent:setPlayer(getProxy(PlayerProxy):getRawData())
	elseif var0_11 == GAME.GUILD_COMMIT_DONATE_DONE then
		arg0_11.viewComponent:UpdateContribution()

		local function var2_11()
			return
		end

		if var1_11.awards and #var1_11.awards > 0 then
			arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards, var2_11)
		else
			var2_11()
		end
	elseif var0_11 == GuildProxy.ON_DONATE_LIST_UPDATED then
		arg0_11.viewComponent:UpdateContribution()
	elseif var0_11 == GAME.TRIGGER_TASK_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_get_week_done"))
		arg0_11.viewComponent:UpdateTask()
	elseif var0_11 == GAME.SUBMIT_TASK_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11)
		arg0_11.viewComponent:UpdateTask(true)
	elseif var0_11 == GuildProxy.WEEKLYTASK_ADDED or var0_11 == GuildProxy.WEEKLYTASK_UPDATED or var0_11 == GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE_DONE then
		arg0_11.viewComponent:UpdateTask()
	elseif var0_11 == GAME.GUILD_GET_SUPPLY_AWARD_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.list)
		arg0_11.viewComponent:UpdateSupplyPanel()
	elseif var0_11 == GuildProxy.SUPPLY_STARTED then
		arg0_11.viewComponent:UpdateSupplyPanel()
	elseif var0_11 == GAME.ZERO_HOUR_OP_DONE then
		-- block empty
	elseif var0_11 == TaskProxy.TASK_UPDATED then
		local var3_11 = getProxy(GuildProxy):getRawData()

		if var3_11 then
			local var4_11 = var3_11:getWeeklyTask()

			if var4_11 and var4_11.id > 0 and var4_11:IsSamePrivateTask(var1_11) then
				arg0_11.viewComponent:UpdateTask()
			end
		end
	end
end

return var0_0
