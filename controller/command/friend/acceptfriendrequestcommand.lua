local var0 = class("AcceptFriendRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(FriendProxy)
	local var2 = var1:getFriendCount()

	local function var3(arg0)
		pg.ConnectionMgr.GetInstance():Send(50006, {
			id = var0
		}, 50007, function(arg0)
			if arg0.result == 0 then
				getProxy(NotificationProxy):removeRequest(var0)

				if arg0 then
					var1:relieveBlackListById(var0)
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("friend_add_ok"))
				arg0:sendNotification(GAME.FRIEND_ACCEPT_REQUEST_DONE, var0)
			else
				if arg0.result == 6 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("friend_max_count_1"))
				end

				pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_acceptFriendRequest", arg0.result))
			end
		end)
	end

	if var2 == MAX_FRIEND_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_max_count"))

		return
	end

	if var1:isInBlackList(var0) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("friend_relieve_backlist_tip"),
			onYes = function()
				var3(true)
			end
		})
	else
		var3(false)
	end
end

return var0
