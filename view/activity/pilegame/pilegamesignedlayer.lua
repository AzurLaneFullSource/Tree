local var0_0 = class("PileGameSignedLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PileSignedUI"
end

function var0_0.SetData(arg0_2, arg1_2)
	arg0_2.data = arg1_2
	arg0_2.ultimate = arg1_2.ultimate
	arg0_2.usedtime = arg1_2.usedtime
end

function var0_0.init(arg0_3)
	arg0_3.icons = {
		arg0_3:findTF("bg/icon/npc1"),
		arg0_3:findTF("bg/icon/npc2"),
		arg0_3:findTF("bg/icon/npc3"),
		arg0_3:findTF("bg/icon/npc4"),
		arg0_3:findTF("bg/icon/npc5"),
		arg0_3:findTF("bg/icon/npc6"),
		arg0_3:findTF("bg/icon/npc7")
	}
	arg0_3.helpBtn = arg0_3:findTF("bg/btn/pngbtn_help")
	arg0_3.getBtn = arg0_3:findTF("bg/btn/btn_djlq")
	arg0_3.gotBtn = arg0_3:findTF("bg/btn/btn_ylq")
	arg0_3.parent = arg0_3._tf.parent

	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_stamp.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.getBtn, function()
		if arg0_4.data:getConfig("reward_need") > arg0_4.usedtime then
			return
		end

		arg0_4:emit(PileGameSignedMediator.ON_GET_AWARD)
	end, SFX_PANEL)
	arg0_4:UpdateIconDesc()
	arg0_4:UpdateSigned()
end

function var0_0.UpdateIconDesc(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.icons) do
		onButton(arg0_8, iter1_8, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("special_animal" .. iter0_8)
			})
		end, SFX_PANEL)
	end
end

function var0_0.UpdateSigned(arg0_10)
	local var0_10 = arg0_10.data:getConfig("reward_need")
	local var1_10 = arg0_10.usedtime
	local var2_10 = arg0_10.ultimate == 0

	setActive(arg0_10.getBtn, var2_10)
	setActive(arg0_10.gotBtn, not var2_10)
	setGray(arg0_10.getBtn, var2_10 and var1_10 < var0_10, true)

	for iter0_10, iter1_10 in ipairs(arg0_10.icons) do
		local var3_10 = iter0_10 <= var1_10

		iter1_10:GetComponent(typeof(Image)).color = var3_10 and Color.New(1, 1, 1, 1) or Color.New(1, 1, 1, 0.1)
	end
end

function var0_0.willExit(arg0_11)
	arg0_11.icons = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11.parent)
end

return var0_0
