local var0_0 = class("GuildEventReportMediator", import("...base.ContextMediator"))

var0_0.ON_GET_REPORTS = "GuildEventReportMediator:ON_GET_REPORTS"
var0_0.ON_SUBMIT_REPORTS = "GuildEventReportMediator:ON_SUBMIT_REPORTS"
var0_0.GET_REPORT_RANK = "GuildEventReportMediator:GET_REPORT_RANK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_REPORT_RANK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GET_GUILD_REPORT_RANK, {
			id = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_REPORTS, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_GUILD_REPORT, {
			ids = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_GET_REPORTS, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GET_GUILD_REPORT, {
			callback = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SUBMIT_GUILD_REPORT_DONE,
		GAME.GET_GUILD_REPORT_RANK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SUBMIT_GUILD_REPORT_DONE then
		arg0_6.viewComponent:UpdateReports(var1_6.list)
	elseif var0_6 == GAME.GET_GUILD_REPORT_RANK_DONE then
		arg0_6.viewComponent:OnGetReportRankList(var1_6.ranks)
	end
end

return var0_0
