local var0 = class("WorldbossPtBtn")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.ptTF = arg1
	arg0.pt = arg1:Find("Text"):GetComponent(typeof(Text))
	arg0.ptRecoveTF = arg1:Find("time")
	arg0.ptRecove = arg1:Find("time/Text"):GetComponent(typeof(Text))

	arg0:Init()
end

function var0.Init(arg0)
	arg0.ptRecoveTFFlag = false

	onButton(arg0, arg0.ptTF, function()
		arg0.ptRecoveTFFlag = not arg0.ptRecoveTFFlag

		setActive(arg0.ptRecoveTF, arg0.ptRecoveTFFlag)
	end, SFX_PANEL)
	setActive(arg0.ptRecoveTF, arg0.ptRecoveTFFlag)
	arg0:Update()
end

function var0.Update(arg0)
	local var0 = nowWorld():GetBossProxy()
	local var1 = var0.pt or 0

	arg0.pt.text = var1 .. "/" .. var0:GetMaxPt()

	local var2 = pg.gameset.joint_boss_ap_recove_cnt_pre_day.key_value

	arg0.ptRecove.text = i18n("world_boss_pt_recove_desc", var2)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
