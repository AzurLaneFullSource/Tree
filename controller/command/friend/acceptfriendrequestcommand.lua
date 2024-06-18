local var0_0 = class("AcceptFriendRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(FriendProxy)
	local var2_1 = var1_1:getFriendCount()

	local function var3_1(arg0_2)
		pg.ConnectionMgr.GetInstance():Send(50006, {
			id = var0_1
		}, 50007, function(arg0_3)
			if arg0_3.result == 0 then
				getProxy(NotificationProxy):removeRequest(var0_1)

				if arg0_2 then
					var1_1:relieveBlackListById(var0_1)
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("friend_add_ok"))
				arg0_1:sendNotification(GAME.FRIEND_ACCEPT_REQUEST_DONE, var0_1)
			else
				if arg0_3.result == 6 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("friend_max_count_1"))
				end

				pg.TipsMgr.GetInstance():ShowTips(errorTip("friend_acceptFriendRequest", arg0_3.result))
			end
		end)
	end

	if var2_1 == MAX_FRIEND_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_max_count"))

		return
	end

	if var1_1:isInBlackList(var0_1) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("friend_relieve_backlist_tip"),
			onYes = function()
				var3_1(true)
			end
		})
	else
		var3_1(false)
	end
end

return var0_0
