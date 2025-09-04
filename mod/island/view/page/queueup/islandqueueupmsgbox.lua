local var0_0 = class("IslandQueueUpMsgBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandQueueUpUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentTxt = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel")

	setText(arg0_2:findTF("frame/title"), i18n("island_msg_info"))
	setText(arg0_2:findTF("frame/cancel/Text"), i18n("island_cancel_queue"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Destroy()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	arg0_5:Flush(arg2_5)
	arg0_5:AddTimer(arg1_5)
end

function var0_0.Flush(arg0_6, arg1_6)
	arg0_6.contentTxt.text = i18n("island_queue_display", arg1_6)
end

function var0_0.AddTimer(arg0_7, arg1_7)
	arg0_7.timer = Timer.New(function()
		arg0_7:Send(arg1_7)
	end, IslandConst.QUEUE_UP_REFRESH_TIME, -1)

	arg0_7.timer:Start()
end

function var0_0.Send(arg0_9, arg1_9)
	pg.ConnectionMgr.GetInstance():Send(21208, {
		island_id = arg1_9
	}, 21203, function(arg0_10)
		if arg0_10.result == 0 then
			arg0_9:Destroy()
			pg.m02:sendNotification(GAME.ISLAND_GET_DATA, {
				id = arg0_10.island_id,
				list = arg0_10.player_list
			})
		elseif arg0_10.result == 6 then
			arg0_9:Flush(arg0_10.pos)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_10.result] .. arg0_10.result)
		end
	end)
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:RemoveTimer()
	arg0_12:Reset()
end

return var0_0
