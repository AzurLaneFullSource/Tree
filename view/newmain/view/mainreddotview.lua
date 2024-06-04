local var0 = class("MainReddotView")

function var0.Ctor(arg0)
	arg0.listener = {}
	arg0.redDotMgr = pg.RedDotMgr.GetInstance()
	arg0.nodes = {}
end

function var0.Init(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.nodes, iter1)
	end

	arg0.redDotMgr:RegisterRedDotNodes(arg0.nodes)
end

function var0.AddNode(arg0, arg1)
	table.insert(arg0.nodes, arg1)
	arg0.redDotMgr:RegisterRedDotNode(arg1)
	arg1:RefreshSelf()
end

function var0.RemoveNode(arg0, arg1)
	table.removebyvalue(arg0.nodes, arg1)
	arg0.redDotMgr:UnRegisterRedDotNode(arg1)
end

function var0.Refresh(arg0)
	for iter0, iter1 in ipairs(arg0.nodes) do
		if iter1.Resume then
			iter1:Resume()
		end
	end

	arg0:_Refresh()
end

function var0._Refresh(arg0)
	arg0.redDotMgr:_NotifyAll()
end

function var0.Disable(arg0)
	for iter0, iter1 in ipairs(arg0.nodes) do
		if iter1.Puase then
			iter1:Puase()
		end
	end
end

function var0.GetNotifyType(arg0)
	if not arg0.listener or #arg0.listener == 0 then
		arg0.listener = {
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

	return arg0.listener
end

function var0.Notify(arg0, arg1)
	for iter0, iter1 in pairs(arg0:GetNotifyType()) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3 == arg1 then
				arg0.redDotMgr:NotifyAll(iter0)
			end
		end
	end
end

function var0.Clear(arg0)
	arg0.redDotMgr:UnRegisterRedDotNodes(arg0.nodes)

	arg0.nodes = {}
end

function var0.Dispose(arg0)
	arg0:Clear()

	arg0.listener = nil
end

return var0
