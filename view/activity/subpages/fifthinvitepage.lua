local var0_0 = class("FifthInvitePage", import(".FourthInvitePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.five_qingdian.tip
		})
	end, SFX_PANEL)
end

return var0_0
