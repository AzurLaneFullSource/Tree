local var0_0 = class("MainReddotView")

function var0_0.Ctor(arg0_1)
	arg0_1.listener = {}
	arg0_1.redDotMgr = pg.RedDotMgr.GetInstance()
	arg0_1.nodes = {}
end

function var0_0.Init(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg1_2) do
		table.insert(arg0_2.nodes, iter1_2)
	end

	arg0_2.redDotMgr:RegisterRedDotNodes(arg0_2.nodes)
end

function var0_0.AddNode(arg0_3, arg1_3)
	table.insert(arg0_3.nodes, arg1_3)
	arg0_3.redDotMgr:RegisterRedDotNode(arg1_3)
	arg1_3:RefreshSelf()
end

function var0_0.RemoveNode(arg0_4, arg1_4)
	table.removebyvalue(arg0_4.nodes, arg1_4)
	arg0_4.redDotMgr:UnRegisterRedDotNode(arg1_4)
end

function var0_0.Refresh(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.nodes) do
		if iter1_5.Resume then
			iter1_5:Resume()
		end
	end

	arg0_5:_Refresh()
end

function var0_0._Refresh(arg0_6)
	arg0_6.redDotMgr:_NotifyAll()
end

function var0_0.Disable(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.nodes) do
		if iter1_7.Puase then
			iter1_7:Puase()
		end
	end
end

function var0_0.GetNotifyType(arg0_8)
	if not arg0_8.listener or #arg0_8.listener == 0 then
		arg0_8.listener = {
			[pg.RedDotMgr.TYPES.ATTIRE] = {
				GAME.EDUCATE_GET_ENDINGS_DONE
			},
			[pg.RedDotMgr.TYPES.TASK] = {
				TaskProxy.TASK_UPDATED,
				AvatarFrameProxy.FRAME_TASK_UPDATED
			},
			[pg.RedDotMgr.TYPES.COURTYARD] = {
				DormProxy.INIMACY_AND_MONEY_ADD
			},
			[pg.RedDotMgr.TYPES.MAIL] = {
				MailProxy.UPDATE_ATTACHMENT_COUNT
			},
			[pg.RedDotMgr.TYPES.BUILD] = {
				BuildShipProxy.TIMEUP
			},
			[pg.RedDotMgr.TYPES.GUILD] = {
				GAME.GUILD_GET_REQUEST_LIST_DONE,
				GuildProxy.REQUEST_DELETED,
				GuildProxy.REQUEST_COUNT_UPDATED,
				GAME.BOSS_EVENT_START_DONE,
				GAME.GET_GUILD_INFO_DONE
			},
			[pg.RedDotMgr.TYPES.SCHOOL] = {
				CollectionProxy.TROPHY_UPDATE
			},
			[pg.RedDotMgr.TYPES.FRIEND] = {
				NotificationProxy.FRIEND_REQUEST_ADDED,
				NotificationProxy.FRIEND_REQUEST_REMOVED,
				FriendProxy.FRIEND_NEW_MSG,
				FriendProxy.FRIEND_UPDATED
			},
			[pg.RedDotMgr.TYPES.COMMISSION] = {
				PlayerProxy.UPDATED,
				GAME.EVENT_LIST_UPDATE,
				GAME.CANCEL_LEARN_TACTICS_DONE
			},
			[pg.RedDotMgr.TYPES.SERVER] = {
				ServerNoticeProxy.SERVER_NOTICES_UPDATE
			},
			[pg.RedDotMgr.TYPES.BLUEPRINT] = {
				TechnologyConst.UPDATE_REDPOINT_ON_TOP,
				GAME.REMOVE_LAYERS
			},
			[pg.RedDotMgr.TYPES.EVENT] = {
				GAME.EVENT_LIST_UPDATE
			},
			[pg.RedDotMgr.TYPES.ACT_NEWBIE] = {
				GAME.REMOVE_LAYERS
			},
			[pg.RedDotMgr.TYPES.ACT_RETURN] = {
				GAME.REMOVE_LAYERS
			}
		}
	end

	return arg0_8.listener
end

function var0_0.Notify(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9:GetNotifyType()) do
		for iter2_9, iter3_9 in ipairs(iter1_9) do
			if iter3_9 == arg1_9 then
				arg0_9.redDotMgr:NotifyAll(iter0_9)
			end
		end
	end
end

function var0_0.Clear(arg0_10)
	arg0_10.redDotMgr:UnRegisterRedDotNodes(arg0_10.nodes)

	arg0_10.nodes = {}
end

function var0_0.Dispose(arg0_11)
	arg0_11:Clear()

	arg0_11.listener = nil
end

return var0_0
