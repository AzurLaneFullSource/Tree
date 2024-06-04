local var0 = class("GuildMainMediator", import("..base.ContextMediator"))

var0.OPEN_MEMBER = "GuildMainMediator:OPEN_MEMBER"
var0.CLOSE_MEMBER = "GuildMainMediator:CLOSE_MEMBER"
var0.OPEN_APPLY = "GuildMainMediator:OPEN_APPLY"
var0.CLOSE_APPLY = "GuildMainMediator:CLOSE_APPLY"
var0.MODIFY = "GuildMainMediator:MODIFY"
var0.DISSOLVE = "GuildMainMediator:DISSOLVE"
var0.QUIT = "GuildMainMediator:QUIT"
var0.ON_BACK = "GuildMainMediator:ON_BACK"
var0.REBUILD_ALL = "GuildMainMediator:REBUILD_ALL"
var0.ON_REBUILD_LOG_ALL = "GuildMainMediator:ON_REBUILD_LOG_ALL"
var0.SEND_MSG = "GuildMainMediator:SEND_MSG"
var0.OPEN_EMOJI = "GuildMainMediator:OPEN_EMOJI"
var0.OPEN_OFFICE = "GuildMainMediator:OPEN_OFFICE"
var0.OPEN_TECH = "GuildMainMediator:OPEN_TECH"
var0.OPEN_BATTLE = "GuildMainMediator:OPEN_BATTLE"
var0.CLOSE_OFFICE = "GuildMainMediator:CLOSE_OFFICE"
var0.CLOSE_TECH = "GuildMainMediator:CLOSE_TECH"
var0.CLOSE_BATTLE = "GuildMainMediator:CLOSE_BATTLE"
var0.ON_FETCH_CAPITAL = "GuildOfficeMediator:ON_FETCH_CAPITAL"
var0.ON_FETCH_CAPITAL_LOG = "GuildOfficeMediator:ON_FETCH_CAPITAL_LOG"
var0.OPEN_EVENT_REPORT = "GuildOfficeMediator:OPEN_EVENT_REPORT"
var0.OPEN_EVENT = "GuildOfficeMediator:OPEN_EVENT"
var0.OPEN_MAIN = "GuildOfficeMediator:OPEN_MAIN"
var0.SWITCH_TO_OFFICE = "GuildOfficeMediator:SWITCH_TO_OFFICE"
var0.OPEN_SHOP = "GuildMainMediator:OPEN_SHOP"

function var0.register(arg0)
	local var0 = getProxy(ContextProxy)
	local var1 = var0:GetPrevContext(1)

	if var1.mediator == NewGuildMediator then
		var0:RemoveContext(var1)
	end

	local var2 = getProxy(GuildProxy)
	local var3 = var2:getData()

	arg0.viewComponent:setGuildVO(var3)

	local var4 = var2:getChatMsgs()

	arg0.viewComponent:setChatMsgs(var4)
	arg0:bind(var0.OPEN_SHOP, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_GUILD
		})
	end)
	arg0:bind(var0.OPEN_MAIN, function()
		arg0:closePage(GuildEventReportMediator)
	end)
	arg0:bind(var0.OPEN_EVENT, function(arg0)
		arg0.viewComponent:openPage(GuildMainScene.TOGGLE_TAG[6])
	end)
	arg0:bind(var0.OPEN_EVENT_REPORT, function(arg0)
		arg0:sendNotification(GAME.GUILD_OPEN_EVENT_REPORT)
	end)
	arg0:bind(var0.ON_FETCH_CAPITAL, function(arg0)
		arg0:sendNotification(GAME.GUILD_REFRESH_CAPITAL)
	end)

	local var5 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayerVO(var5)
	arg0:bind(var0.ON_BACK, function(arg0)
		arg0:sendNotification(GAME.GO_BACK)
	end)
	arg0:bind(var0.REBUILD_ALL, function(arg0)
		local var0 = getProxy(GuildProxy):getChatMsgs()

		arg0.viewComponent:UpdateAllChat(var0)
	end)
	arg0:bind(var0.OPEN_MEMBER, function()
		arg0:closePage(GuildEventReportMediator)
		arg0:addSubLayers(Context.New({
			viewComponent = GuildMemberLayer,
			mediator = GuildMemberMediator
		}))
	end)
	arg0:bind(var0.CLOSE_MEMBER, function()
		arg0:closePage(GuildMemberMediator)
	end)
	arg0:bind(var0.OPEN_APPLY, function()
		arg0:closePage(GuildEventReportMediator)
		arg0:addSubLayers(Context.New({
			viewComponent = GuildRequestLayer,
			mediator = GuildRequestMediator
		}))
	end)
	arg0:bind(var0.CLOSE_APPLY, function()
		arg0:closePage(GuildRequestMediator)
	end)
	arg0:bind(var0.MODIFY, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.MODIFY_GUILD_INFO, {
			type = arg1,
			int = arg2,
			string = arg3
		})
	end)
	arg0:bind(var0.DISSOLVE, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_DISSOLVE, arg1)
	end)
	arg0:bind(var0.QUIT, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_QUIT, arg1)
	end)
	arg0:bind(var0.ON_REBUILD_LOG_ALL, function(arg0)
		local var0 = getProxy(GuildProxy):getData():getLogs()

		arg0.viewComponent:UpdateAllLog(var0)
	end)
	arg0:bind(var0.SEND_MSG, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_SEND_MSG, arg1)
	end)
	arg0:bind(var0.OPEN_EMOJI, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				pos = arg1,
				callback = arg2,
				emojiIconCallback = function(arg0)
					arg0.viewComponent:insertEmojiToInputText(arg0)
				end
			}
		}))
	end)
	arg0:bind(var0.OPEN_OFFICE, function()
		arg0:closePage(GuildEventReportMediator)
		arg0:addSubLayers(Context.New({
			viewComponent = GuildOfficeLayer,
			mediator = GuildOfficeMediator
		}))
	end)
	arg0:bind(var0.CLOSE_OFFICE, function()
		arg0:closePage(GuildOfficeMediator)
	end)
	arg0:bind(var0.OPEN_TECH, function()
		arg0:closePage(GuildEventReportMediator)
		arg0:addSubLayers(Context.New({
			viewComponent = GuildTechnologyLayer,
			mediator = GuildTechnologyMediator
		}))
	end)
	arg0:bind(var0.CLOSE_TECH, function()
		arg0:closePage(GuildTechnologyMediator)
	end)
	arg0:bind(var0.ON_FETCH_CAPITAL_LOG, function(arg0)
		if var2:getData():shouldRequestCapitalLog() then
			arg0:sendNotification(GAME.GUILD_FETCH_CAPITAL_LOG)
		else
			arg0.viewComponent:openResourceLog()
		end
	end)
	arg0:bind(var0.OPEN_BATTLE, function()
		arg0:closePage(GuildEventReportMediator)
		arg0:addSubLayers(Context.New({
			viewComponent = GuildEventLayer,
			mediator = GuildEventMediator
		}))
	end)
	arg0:bind(var0.CLOSE_BATTLE, function()
		arg0:closePage(GuildEventMediator)
	end)

	local var6 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayerVO(var6)
end

function var0.closePage(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(arg1)

	if var0 then
		arg0:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0
		})
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GuildProxy.GUILD_UPDATED,
		GuildProxy.EXIT_GUILD,
		GAME.MODIFY_GUILD_INFO_DONE,
		GuildProxy.NEW_MSG_ADDED,
		GuildProxy.LOG_ADDED,
		GuildProxy.REQUEST_COUNT_UPDATED,
		GuildProxy.REQUEST_DELETED,
		GAME.GUILD_GET_REQUEST_LIST_DONE,
		GAME.REMOVE_LAYERS,
		PlayerProxy.UPDATED,
		GAME.GUILD_FETCH_CAPITAL_LOG_DONE,
		GAME.GUILD_COMMIT_DONATE_DONE,
		GuildProxy.ON_DELETED_MEMBER,
		GuildProxy.ON_ADDED_MEMBER,
		GAME.GUILD_OPEN_EVENT_REPORT,
		GuildProxy.BATTLE_BTN_FLAG_CHANGE,
		GAME.BEGIN_STAGE_DONE,
		GAME.SUBMIT_GUILD_REPORT_DONE,
		GuildTechnologyMediator.ON_OPEN_OFFICE,
		GAME.OPEN_MSGBOX_DONE,
		GuildProxy.TECHNOLOGY_START,
		GAME.GO_WORLD_BOSS_SCENE,
		GAME.GUILD_START_TECH_DONE,
		GuildMainMediator.SWITCH_TO_OFFICE,
		GAME.ON_GUILD_JOIN_EVENT_DONE,
		GAME.GUILD_JOIN_MISSION_DONE,
		GAME.GUILD_GET_SUPPLY_AWARD_DONE,
		GAME.LOAD_LAYERS,
		GAME.REMOVE_LAYERS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GuildProxy.GUILD_UPDATED then
		arg0.viewComponent:setGuildVO(var1)
	elseif var0 == GuildProxy.EXIT_GUILD then
		arg0.viewComponent:emit(var0.ON_BACK)
	elseif var0 == GAME.MODIFY_GUILD_INFO_DONE then
		arg0.viewComponent:initTheme()
	elseif var0 == GuildProxy.NEW_MSG_ADDED then
		arg0.viewComponent:Append(var1, -1)
	elseif var0 == GuildProxy.LOG_ADDED then
		arg0.viewComponent:AppendLog(var1, true)
	elseif var0 == GuildProxy.REQUEST_COUNT_UPDATED or var0 == GuildProxy.REQUEST_DELETED or var0 == GAME.GUILD_GET_REQUEST_LIST_DONE then
		local var2 = getProxy(GuildProxy)

		arg0.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_APPLY)
	elseif var0 == GAME.GUILD_FETCH_CAPITAL_LOG_DONE then
		arg0.viewComponent:openResourceLog()
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerVO(var1)
		arg0.viewComponent:UpdateRes()
	elseif var0 == GAME.GUILD_COMMIT_DONATE_DONE or var0 == GAME.GUILD_GET_SUPPLY_AWARD_DONE then
		arg0.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_OFFICE)
	elseif GuildProxy.ON_DELETED_MEMBER == var0 then
		arg0.viewComponent:OnDeleteMember(var1.member)
	elseif GuildProxy.ON_ADDED_MEMBER == var0 then
		arg0.viewComponent:OnAddMember(var1.member)
	elseif var0 == GAME.GUILD_OPEN_EVENT_REPORT then
		arg0:addSubLayers(Context.New({
			viewComponent = GuildEventReportLayer,
			mediator = GuildEventReportMediator
		}))
	elseif var0 == GAME.SUBMIT_GUILD_REPORT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
		arg0.viewComponent:OnReportUpdated()
		arg0.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_BATTLE)
		arg0.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_MAIN)
	elseif var0 == GuildProxy.BATTLE_BTN_FLAG_CHANGE or var0 == GAME.ON_GUILD_JOIN_EVENT_DONE or var0 == GAME.GUILD_ACTIVE_EVENT_DONE or var0 == GAME.GUILD_JOIN_MISSION_DONE then
		arg0.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_BATTLE)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == GuildTechnologyMediator.ON_OPEN_OFFICE then
		local var3 = arg0.contextData.toggles[GuildMainScene.TOGGLE_TAG[4]]

		triggerToggle(var3, true)
	elseif var0 == GAME.OPEN_MSGBOX_DONE then
		pg.GuildLayerMgr:GetInstance():OnShowMsgBox()
	elseif var0 == GuildProxy.TECHNOLOGY_START then
		arg0.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_TECH)
	elseif var0 == GAME.GUILD_START_TECH_DONE then
		local var4 = getProxy(PlayerProxy):getData()

		arg0.viewComponent:setPlayerVO(var4)
		arg0.viewComponent:UpdateRes()
	elseif var0 == GAME.GO_WORLD_BOSS_SCENE then
		arg0.contextData.page = nil
	elseif var0 == GuildMainMediator.SWITCH_TO_OFFICE then
		arg0.viewComponent:TriggerOfficePage()
	elseif var0 == GAME.LOAD_LAYERS then
		if var1.context.mediator == AwardInfoMediator then
			pg.GuildLayerMgr:GetInstance():UnBlurTopPanel()
		end
	elseif var0 == GAME.REMOVE_LAYERS and var1.context.mediator == AwardInfoMediator then
		pg.GuildLayerMgr:GetInstance():_BlurTopPanel()
	end
end

return var0
