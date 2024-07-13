local var0_0 = class("GuildMainMediator", import("..base.ContextMediator"))

var0_0.OPEN_MEMBER = "GuildMainMediator:OPEN_MEMBER"
var0_0.CLOSE_MEMBER = "GuildMainMediator:CLOSE_MEMBER"
var0_0.OPEN_APPLY = "GuildMainMediator:OPEN_APPLY"
var0_0.CLOSE_APPLY = "GuildMainMediator:CLOSE_APPLY"
var0_0.MODIFY = "GuildMainMediator:MODIFY"
var0_0.DISSOLVE = "GuildMainMediator:DISSOLVE"
var0_0.QUIT = "GuildMainMediator:QUIT"
var0_0.ON_BACK = "GuildMainMediator:ON_BACK"
var0_0.REBUILD_ALL = "GuildMainMediator:REBUILD_ALL"
var0_0.ON_REBUILD_LOG_ALL = "GuildMainMediator:ON_REBUILD_LOG_ALL"
var0_0.SEND_MSG = "GuildMainMediator:SEND_MSG"
var0_0.OPEN_EMOJI = "GuildMainMediator:OPEN_EMOJI"
var0_0.OPEN_OFFICE = "GuildMainMediator:OPEN_OFFICE"
var0_0.OPEN_TECH = "GuildMainMediator:OPEN_TECH"
var0_0.OPEN_BATTLE = "GuildMainMediator:OPEN_BATTLE"
var0_0.CLOSE_OFFICE = "GuildMainMediator:CLOSE_OFFICE"
var0_0.CLOSE_TECH = "GuildMainMediator:CLOSE_TECH"
var0_0.CLOSE_BATTLE = "GuildMainMediator:CLOSE_BATTLE"
var0_0.ON_FETCH_CAPITAL = "GuildOfficeMediator:ON_FETCH_CAPITAL"
var0_0.ON_FETCH_CAPITAL_LOG = "GuildOfficeMediator:ON_FETCH_CAPITAL_LOG"
var0_0.OPEN_EVENT_REPORT = "GuildOfficeMediator:OPEN_EVENT_REPORT"
var0_0.OPEN_EVENT = "GuildOfficeMediator:OPEN_EVENT"
var0_0.OPEN_MAIN = "GuildOfficeMediator:OPEN_MAIN"
var0_0.SWITCH_TO_OFFICE = "GuildOfficeMediator:SWITCH_TO_OFFICE"
var0_0.OPEN_SHOP = "GuildMainMediator:OPEN_SHOP"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ContextProxy)
	local var1_1 = var0_1:GetPrevContext(1)

	if var1_1.mediator == NewGuildMediator then
		var0_1:RemoveContext(var1_1)
	end

	local var2_1 = getProxy(GuildProxy)
	local var3_1 = var2_1:getData()

	arg0_1.viewComponent:setGuildVO(var3_1)

	local var4_1 = var2_1:getChatMsgs()

	arg0_1.viewComponent:setChatMsgs(var4_1)
	arg0_1:bind(var0_0.OPEN_SHOP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_GUILD
		})
	end)
	arg0_1:bind(var0_0.OPEN_MAIN, function()
		arg0_1:closePage(GuildEventReportMediator)
	end)
	arg0_1:bind(var0_0.OPEN_EVENT, function(arg0_4)
		arg0_1.viewComponent:openPage(GuildMainScene.TOGGLE_TAG[6])
	end)
	arg0_1:bind(var0_0.OPEN_EVENT_REPORT, function(arg0_5)
		arg0_1:sendNotification(GAME.GUILD_OPEN_EVENT_REPORT)
	end)
	arg0_1:bind(var0_0.ON_FETCH_CAPITAL, function(arg0_6)
		arg0_1:sendNotification(GAME.GUILD_REFRESH_CAPITAL)
	end)

	local var5_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayerVO(var5_1)
	arg0_1:bind(var0_0.ON_BACK, function(arg0_7)
		arg0_1:sendNotification(GAME.GO_BACK)
	end)
	arg0_1:bind(var0_0.REBUILD_ALL, function(arg0_8)
		local var0_8 = getProxy(GuildProxy):getChatMsgs()

		arg0_1.viewComponent:UpdateAllChat(var0_8)
	end)
	arg0_1:bind(var0_0.OPEN_MEMBER, function()
		arg0_1:closePage(GuildEventReportMediator)
		arg0_1:addSubLayers(Context.New({
			viewComponent = GuildMemberLayer,
			mediator = GuildMemberMediator
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_MEMBER, function()
		arg0_1:closePage(GuildMemberMediator)
	end)
	arg0_1:bind(var0_0.OPEN_APPLY, function()
		arg0_1:closePage(GuildEventReportMediator)
		arg0_1:addSubLayers(Context.New({
			viewComponent = GuildRequestLayer,
			mediator = GuildRequestMediator
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_APPLY, function()
		arg0_1:closePage(GuildRequestMediator)
	end)
	arg0_1:bind(var0_0.MODIFY, function(arg0_13, arg1_13, arg2_13, arg3_13)
		arg0_1:sendNotification(GAME.MODIFY_GUILD_INFO, {
			type = arg1_13,
			int = arg2_13,
			string = arg3_13
		})
	end)
	arg0_1:bind(var0_0.DISSOLVE, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.GUILD_DISSOLVE, arg1_14)
	end)
	arg0_1:bind(var0_0.QUIT, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.GUILD_QUIT, arg1_15)
	end)
	arg0_1:bind(var0_0.ON_REBUILD_LOG_ALL, function(arg0_16)
		local var0_16 = getProxy(GuildProxy):getData():getLogs()

		arg0_1.viewComponent:UpdateAllLog(var0_16)
	end)
	arg0_1:bind(var0_0.SEND_MSG, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.GUILD_SEND_MSG, arg1_17)
	end)
	arg0_1:bind(var0_0.OPEN_EMOJI, function(arg0_18, arg1_18, arg2_18)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EmojiLayer,
			mediator = EmojiMediator,
			data = {
				pos = arg1_18,
				callback = arg2_18,
				emojiIconCallback = function(arg0_19)
					arg0_1.viewComponent:insertEmojiToInputText(arg0_19)
				end
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_OFFICE, function()
		arg0_1:closePage(GuildEventReportMediator)
		arg0_1:addSubLayers(Context.New({
			viewComponent = GuildOfficeLayer,
			mediator = GuildOfficeMediator
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_OFFICE, function()
		arg0_1:closePage(GuildOfficeMediator)
	end)
	arg0_1:bind(var0_0.OPEN_TECH, function()
		arg0_1:closePage(GuildEventReportMediator)
		arg0_1:addSubLayers(Context.New({
			viewComponent = GuildTechnologyLayer,
			mediator = GuildTechnologyMediator
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_TECH, function()
		arg0_1:closePage(GuildTechnologyMediator)
	end)
	arg0_1:bind(var0_0.ON_FETCH_CAPITAL_LOG, function(arg0_24)
		if var2_1:getData():shouldRequestCapitalLog() then
			arg0_1:sendNotification(GAME.GUILD_FETCH_CAPITAL_LOG)
		else
			arg0_1.viewComponent:openResourceLog()
		end
	end)
	arg0_1:bind(var0_0.OPEN_BATTLE, function()
		arg0_1:closePage(GuildEventReportMediator)
		arg0_1:addSubLayers(Context.New({
			viewComponent = GuildEventLayer,
			mediator = GuildEventMediator
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_BATTLE, function()
		arg0_1:closePage(GuildEventMediator)
	end)

	local var6_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayerVO(var6_1)
end

function var0_0.closePage(arg0_27, arg1_27)
	local var0_27 = getProxy(ContextProxy):getContextByMediator(arg1_27)

	if var0_27 then
		arg0_27:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_27
		})
	end
end

function var0_0.listNotificationInterests(arg0_28)
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

function var0_0.handleNotification(arg0_29, arg1_29)
	local var0_29 = arg1_29:getName()
	local var1_29 = arg1_29:getBody()

	if var0_29 == GuildProxy.GUILD_UPDATED then
		arg0_29.viewComponent:setGuildVO(var1_29)
	elseif var0_29 == GuildProxy.EXIT_GUILD then
		arg0_29.viewComponent:emit(var0_0.ON_BACK)
	elseif var0_29 == GAME.MODIFY_GUILD_INFO_DONE then
		arg0_29.viewComponent:initTheme()
	elseif var0_29 == GuildProxy.NEW_MSG_ADDED then
		arg0_29.viewComponent:Append(var1_29, -1)
	elseif var0_29 == GuildProxy.LOG_ADDED then
		arg0_29.viewComponent:AppendLog(var1_29, true)
	elseif var0_29 == GuildProxy.REQUEST_COUNT_UPDATED or var0_29 == GuildProxy.REQUEST_DELETED or var0_29 == GAME.GUILD_GET_REQUEST_LIST_DONE then
		local var2_29 = getProxy(GuildProxy)

		arg0_29.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_APPLY)
	elseif var0_29 == GAME.GUILD_FETCH_CAPITAL_LOG_DONE then
		arg0_29.viewComponent:openResourceLog()
	elseif var0_29 == PlayerProxy.UPDATED then
		arg0_29.viewComponent:setPlayerVO(var1_29)
		arg0_29.viewComponent:UpdateRes()
	elseif var0_29 == GAME.GUILD_COMMIT_DONATE_DONE or var0_29 == GAME.GUILD_GET_SUPPLY_AWARD_DONE then
		arg0_29.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_OFFICE)
	elseif GuildProxy.ON_DELETED_MEMBER == var0_29 then
		arg0_29.viewComponent:OnDeleteMember(var1_29.member)
	elseif GuildProxy.ON_ADDED_MEMBER == var0_29 then
		arg0_29.viewComponent:OnAddMember(var1_29.member)
	elseif var0_29 == GAME.GUILD_OPEN_EVENT_REPORT then
		arg0_29:addSubLayers(Context.New({
			viewComponent = GuildEventReportLayer,
			mediator = GuildEventReportMediator
		}))
	elseif var0_29 == GAME.SUBMIT_GUILD_REPORT_DONE then
		arg0_29.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_29.awards, var1_29.callback)
		arg0_29.viewComponent:OnReportUpdated()
		arg0_29.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_BATTLE)
		arg0_29.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_MAIN)
	elseif var0_29 == GuildProxy.BATTLE_BTN_FLAG_CHANGE or var0_29 == GAME.ON_GUILD_JOIN_EVENT_DONE or var0_29 == GAME.GUILD_ACTIVE_EVENT_DONE or var0_29 == GAME.GUILD_JOIN_MISSION_DONE then
		arg0_29.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_BATTLE)
	elseif var0_29 == GAME.BEGIN_STAGE_DONE then
		arg0_29:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_29)
	elseif var0_29 == GuildTechnologyMediator.ON_OPEN_OFFICE then
		local var3_29 = arg0_29.contextData.toggles[GuildMainScene.TOGGLE_TAG[4]]

		triggerToggle(var3_29, true)
	elseif var0_29 == GAME.OPEN_MSGBOX_DONE then
		pg.GuildLayerMgr:GetInstance():OnShowMsgBox()
	elseif var0_29 == GuildProxy.TECHNOLOGY_START then
		arg0_29.viewComponent:UpdateNotices(GuildMainScene.NOTIFY_TYPE_TECH)
	elseif var0_29 == GAME.GUILD_START_TECH_DONE then
		local var4_29 = getProxy(PlayerProxy):getData()

		arg0_29.viewComponent:setPlayerVO(var4_29)
		arg0_29.viewComponent:UpdateRes()
	elseif var0_29 == GAME.GO_WORLD_BOSS_SCENE then
		arg0_29.contextData.page = nil
	elseif var0_29 == GuildMainMediator.SWITCH_TO_OFFICE then
		arg0_29.viewComponent:TriggerOfficePage()
	elseif var0_29 == GAME.LOAD_LAYERS then
		if var1_29.context.mediator == AwardInfoMediator then
			pg.GuildLayerMgr:GetInstance():UnBlurTopPanel()
		end
	elseif var0_29 == GAME.REMOVE_LAYERS and var1_29.context.mediator == AwardInfoMediator then
		pg.GuildLayerMgr:GetInstance():_BlurTopPanel()
	end
end

return var0_0
