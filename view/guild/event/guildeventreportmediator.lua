local var0 = class("GuildEventReportMediator", import("...base.ContextMediator"))

var0.ON_GET_REPORTS = "GuildEventReportMediator:ON_GET_REPORTS"
var0.ON_SUBMIT_REPORTS = "GuildEventReportMediator:ON_SUBMIT_REPORTS"
var0.GET_REPORT_RANK = "GuildEventReportMediator:GET_REPORT_RANK"

function var0.register(arg0)
	arg0:bind(var0.GET_REPORT_RANK, function(arg0, arg1)
		arg0:sendNotification(GAME.GET_GUILD_REPORT_RANK, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_SUBMIT_REPORTS, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_GUILD_REPORT, {
			ids = arg1
		})
	end)
	arg0:bind(var0.ON_GET_REPORTS, function(arg0, arg1)
		arg0:sendNotification(GAME.GET_GUILD_REPORT, {
			callback = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SUBMIT_GUILD_REPORT_DONE,
		GAME.GET_GUILD_REPORT_RANK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SUBMIT_GUILD_REPORT_DONE then
		arg0.viewComponent:UpdateReports(var1.list)
	elseif var0 == GAME.GET_GUILD_REPORT_RANK_DONE then
		arg0.viewComponent:OnGetReportRankList(var1.ranks)
	end
end

return var0
