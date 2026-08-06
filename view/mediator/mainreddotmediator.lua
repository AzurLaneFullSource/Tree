local var0_0 = class("MainReddotMediator", pm.Mediator)

function var0_0.GetNotifyDic(arg0_1)
	arg0_1.listener = arg0_1.listener or {
		ATTIRE = {
			GAME.EDUCATE_GET_ENDINGS_DONE,
			AttireProxy.ATTIREFRAME_ADDED
		},
		TASK = {
			TaskProxy.TASK_ADDED,
			TaskProxy.TASK_UPDATED,
			TaskProxy.TASK_REMOVED,
			TaskProxy.TASK_DELETE,
			TaskProxy.WEEK_TASK_UPDATED,
			TaskProxy.WEEK_TASKS_ADDED,
			TaskProxy.WEEK_TASKS_DELETED,
			TaskProxy.WEEK_TASK_RESET,
			GAME.SUBMIT_TASK_DONE,
			GAME.SUBMIT_ACTIVITY_TASK_DONE,
			GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE,
			GAME.TOTAL_TASK_UPDATED,
			AvatarFrameProxy.FRAME_TASK_UPDATED,
			GAME.SUBMIT_WEEK_TASK_DONE,
			GAME.BATCH_SUBMIT_WEEK_TASK_DONE
		},
		COURTYARD = {
			DormProxy.INIMACY_AND_MONEY_ADD
		},
		MAIL = {
			MailProxy.UPDATE_ATTACHMENT_COUNT
		},
		BUILD = {
			BuildShipProxy.TIMEUP,
			BuildShipProxy.UPDATED,
			BuildShipProxy.REMOVED,
			GAME.BUILD_SHIP_IMMEDIATELY_DONE,
			GAME.GET_SHIP_DONE,
			GAME.CONFIRM_GET_SHIP
		},
		GUILD = {
			GuildProxy.GUILD_UPDATED,
			GuildProxy.REQUEST_DELETED,
			GuildProxy.REQUEST_COUNT_UPDATED,
			GuildProxy.WEEKLYTASK_ADDED,
			GuildProxy.SUPPLY_STARTED,
			GuildProxy.DONATE_UPDTAE,
			GuildProxy.ON_DONATE_LIST_UPDATED,
			GuildProxy.TECHNOLOGY_START,
			GuildProxy.CAPITAL_UPDATED,
			GAME.SUBMIT_GUILD_REPORT_DONE,
			GAME.GUILD_GET_BOSS_INFO_DONE,
			GAME.GUILD_REFRESH_MISSION_DONE,
			GAME.GUILD_JOIN_MISSION_DONE,
			GuildProxy.BATTLE_BTN_FLAG_CHANGE
		},
		SCHOOL = {
			CollectionProxy.TROPHY_UPDATE,
			GAME.CANCEL_LEARN_TACTICS_DONE
		},
		FRIEND = {
			NotificationProxy.FRIEND_REQUEST_ADDED,
			NotificationProxy.FRIEND_REQUEST_REMOVED,
			FriendProxy.FRIEND_NEW_MSG,
			FriendProxy.FRIEND_UPDATED
		},
		COMMISSION = {
			PlayerProxy.UPDATED,
			GAME.EVENT_LIST_UPDATE,
			GAME.EVENT_FINISH_UPDATE,
			GAME.CANCEL_LEARN_TACTICS_DONE
		},
		SERVER = {
			ServerNoticeProxy.SERVER_NOTICES_UPDATE
		},
		BLUEPRINT = {
			TechnologyConst.UPDATE_REDPOINT_ON_TOP,
			TechnologyProxy.BLUEPRINT_UPDATED,
			GAME.REMOVE_LAYERS
		},
		EVENT = {
			GAME.EVENT_LIST_UPDATE,
			GAME.EVENT_FINISH_UPDATE
		},
		ACT_NEWBIE = {
			GAME.REMOVE_LAYERS
		},
		ACT_RETURN = {
			GAME.REMOVE_LAYERS
		},
		COLLECTION = {
			CollectionProxy.AWARDS_UPDATE,
			CollectionProxy.GROUP_INFO_UPDATE,
			CollectionProxy.GROUP_EVALUATION_UPDATE
		},
		COMMANDER = {
			CommanderProxy.COMMANDER_UPDATED,
			PlayerProxy.UPDATED
		},
		MEMORY_REVIEW = {
			LoveLetterProxy.UPDATE_LOVE_LETTER
		},
		ISLAND = {
			ActivityProxy.ACTIVITY_ADDED,
			ActivityProxy.ACTIVITY_UPDATED,
			ActivityProxy.ACTIVITY_END
		},
		RYZA_TASK = {
			ActivityProxy.ACTIVITY_UPDATED,
			ActivityProxy.ACTIVITY_ADDED
		},
		COMMANDER_MANUAL = {
			TechnologyConst.UPDATE_REDPOINT_ON_TOP,
			GAME.REMOVE_LAYERS
		},
		NEW_SERVER = {
			GAME.REMOVE_LAYERS
		},
		SETTING = {
			GAME.REMOVE_LAYERS
		},
		DORM3D_SHOP_TIMELIMIT = {
			GAME.REMOVE_LAYERS
		},
		EDUCATE_NEW_CHILD = {
			GAME.REMOVE_LAYERS
		},
		ISLAND_3D = {
			GAME.REMOVE_LAYERS
		}
	}

	if not arg0_1.dic then
		arg0_1.dic = {}

		for iter0_1, iter1_1 in pairs(arg0_1.listener) do
			for iter2_1, iter3_1 in pairs(iter1_1) do
				arg0_1.dic[iter3_1] = arg0_1.dic[iter3_1] or {}

				table.insert(arg0_1.dic[iter3_1], iter0_1)
			end
		end
	end

	return arg0_1.dic
end

function var0_0.listNotificationInterests(arg0_2)
	return underscore.keys(arg0_2:GetNotifyDic())
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg0_3:GetNotifyDic()[arg1_3:getName()]

	if not var0_3 then
		return
	end

	pg.EasyRedDotMgr.GetInstance():TriggerMarks(unpack(var0_3))
end

return var0_0
