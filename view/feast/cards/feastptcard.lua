local var0_0 = class("FeastPtCard")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.indexTxt = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.lockBtn = arg0_1._tf:Find("btns/lock")
	arg0_1.getBtn = arg0_1._tf:Find("btns/get")
	arg0_1.gotBtn = arg0_1._tf:Find("btns/got")
	arg0_1.award = arg0_1._tf:Find("award")

	setText(arg0_1.getBtn:Find("Text"), i18n("feast_task_pt_get"))
	setText(arg0_1.gotBtn:Find("Text"), i18n("feast_task_pt_got"))
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2)
	arg0_2.indexTxt.text = i18n("feast_task_pt_level", arg2_2)

	local var0_2 = arg1_2:GetDrop(arg2_2)

	updateDrop(arg0_2.award, var0_2)
	onButton(arg0_2.binder, arg0_2.award, function()
		arg0_2.binder:emit(BaseUI.ON_DROP, var0_2)
	end, SFX_PANEL)

	local var1_2 = arg1_2:GetDroptItemState(arg2_2)

	setActive(arg0_2.lockBtn, var1_2 == ActivityPtData.STATE_LOCK)
	setActive(arg0_2.getBtn, var1_2 == ActivityPtData.STATE_CAN_GET)
	setActive(arg0_2.gotBtn, var1_2 == ActivityPtData.STATE_GOT)
	onButton(arg0_2.binder, arg0_2._tf, function()
		if var1_2 == ActivityPtData.STATE_CAN_GET then
			local var0_4 = arg1_2:GetPtTarget(arg2_2)

			arg0_2.binder:emit(FeastMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg1_2:GetId(),
				arg1 = var0_4
			})
		end
	end, SFX_PANEL)
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
