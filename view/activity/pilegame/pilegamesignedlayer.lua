local var0 = class("PileGameSignedLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "PileSignedUI"
end

function var0.SetData(arg0, arg1)
	arg0.data = arg1
	arg0.ultimate = arg1.ultimate
	arg0.usedtime = arg1.usedtime
end

function var0.init(arg0)
	arg0.icons = {
		arg0:findTF("bg/icon/npc1"),
		arg0:findTF("bg/icon/npc2"),
		arg0:findTF("bg/icon/npc3"),
		arg0:findTF("bg/icon/npc4"),
		arg0:findTF("bg/icon/npc5"),
		arg0:findTF("bg/icon/npc6"),
		arg0:findTF("bg/icon/npc7")
	}
	arg0.helpBtn = arg0:findTF("bg/btn/pngbtn_help")
	arg0.getBtn = arg0:findTF("bg/btn/btn_djlq")
	arg0.gotBtn = arg0:findTF("bg/btn/btn_ylq")
	arg0.parent = arg0._tf.parent

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_stamp.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		if arg0.data:getConfig("reward_need") > arg0.usedtime then
			return
		end

		arg0:emit(PileGameSignedMediator.ON_GET_AWARD)
	end, SFX_PANEL)
	arg0:UpdateIconDesc()
	arg0:UpdateSigned()
end

function var0.UpdateIconDesc(arg0)
	for iter0, iter1 in ipairs(arg0.icons) do
		onButton(arg0, iter1, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("special_animal" .. iter0)
			})
		end, SFX_PANEL)
	end
end

function var0.UpdateSigned(arg0)
	local var0 = arg0.data:getConfig("reward_need")
	local var1 = arg0.usedtime
	local var2 = arg0.ultimate == 0

	setActive(arg0.getBtn, var2)
	setActive(arg0.gotBtn, not var2)
	setGray(arg0.getBtn, var2 and var1 < var0, true)

	for iter0, iter1 in ipairs(arg0.icons) do
		local var3 = iter0 <= var1

		iter1:GetComponent(typeof(Image)).color = var3 and Color.New(1, 1, 1, 1) or Color.New(1, 1, 1, 0.1)
	end
end

function var0.willExit(arg0)
	arg0.icons = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.parent)
end

return var0
