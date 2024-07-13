local var0_0 = class("WorldbossPtBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.ptTF = arg1_1
	arg0_1.pt = arg1_1:Find("Text"):GetComponent(typeof(Text))
	arg0_1.ptRecoveTF = arg1_1:Find("time")
	arg0_1.ptRecove = arg1_1:Find("time/Text"):GetComponent(typeof(Text))

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.ptRecoveTFFlag = false

	onButton(arg0_2, arg0_2.ptTF, function()
		arg0_2.ptRecoveTFFlag = not arg0_2.ptRecoveTFFlag

		setActive(arg0_2.ptRecoveTF, arg0_2.ptRecoveTFFlag)
	end, SFX_PANEL)
	setActive(arg0_2.ptRecoveTF, arg0_2.ptRecoveTFFlag)
	arg0_2:Update()
end

function var0_0.Update(arg0_4)
	local var0_4 = nowWorld():GetBossProxy()
	local var1_4 = var0_4.pt or 0

	arg0_4.pt.text = var1_4 .. "/" .. var0_4:GetMaxPt()

	local var2_4 = pg.gameset.joint_boss_ap_recove_cnt_pre_day.key_value

	arg0_4.ptRecove.text = i18n("world_boss_pt_recove_desc", var2_4)
end

function var0_0.Dispose(arg0_5)
	pg.DelegateInfo.Dispose(arg0_5)
end

return var0_0
