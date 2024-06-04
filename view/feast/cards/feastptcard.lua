local var0 = class("FeastPtCard")
local var1 = 0
local var2 = 1
local var3 = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg2
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.indexTxt = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.lockBtn = arg0._tf:Find("btns/lock")
	arg0.getBtn = arg0._tf:Find("btns/get")
	arg0.gotBtn = arg0._tf:Find("btns/got")
	arg0.award = arg0._tf:Find("award")

	setText(arg0.getBtn:Find("Text"), i18n("feast_task_pt_get"))
	setText(arg0.gotBtn:Find("Text"), i18n("feast_task_pt_got"))
end

function var0.Flush(arg0, arg1, arg2)
	arg0.indexTxt.text = i18n("feast_task_pt_level", arg2)

	local var0 = arg1:GetDrop(arg2)

	updateDrop(arg0.award, var0)
	onButton(arg0.binder, arg0.award, function()
		arg0.binder:emit(BaseUI.ON_DROP, var0)
	end, SFX_PANEL)

	local var1 = arg1:GetDroptItemState(arg2)

	setActive(arg0.lockBtn, var1 == ActivityPtData.STATE_LOCK)
	setActive(arg0.getBtn, var1 == ActivityPtData.STATE_CAN_GET)
	setActive(arg0.gotBtn, var1 == ActivityPtData.STATE_GOT)
	onButton(arg0.binder, arg0._tf, function()
		if var1 == ActivityPtData.STATE_CAN_GET then
			local var0 = arg1:GetPtTarget(arg2)

			arg0.binder:emit(FeastMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg1:GetId(),
				arg1 = var0
			})
		end
	end, SFX_PANEL)
end

function var0.Dispose(arg0)
	return
end

return var0
