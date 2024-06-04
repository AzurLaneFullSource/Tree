local var0 = class("CommissionInfoItem")

function var0.Ctor(arg0, arg1, arg2)
	arg0.view = arg2

	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.parentTF = arg0._tf.parent
	arg0.goBtn = arg0._tf:Find("frame/go_btn")
	arg0.finishedBtn = arg0._tf:Find("frame/finish_btn")
	arg0.toggle = arg0._tf:Find("frame")
	arg0.foldFlag = arg0._tf:Find("frame/tip")
	arg0.finishedCounterContainer = arg0._tf:Find("frame/counter/finished")
	arg0.ongoingCounterContainer = arg0._tf:Find("frame/counter/ongoing")
	arg0.leisureCounterContainer = arg0._tf:Find("frame/counter/leisure")
	arg0.finishedCounter = arg0._tf:Find("frame/counter/finished/Text"):GetComponent(typeof(Text))
	arg0.ongoingCounter = arg0._tf:Find("frame/counter/ongoing/Text"):GetComponent(typeof(Text))
	arg0.leisureCounter = arg0._tf:Find("frame/counter/leisure/Text"):GetComponent(typeof(Text))

	local var0 = arg0._tf:Find("list")
	local var1 = var0:GetChild(0)

	arg0.uilist = UIItemList.New(var0, var1)

	setActive(arg0.finishedCounterContainer, false)
	setActive(arg0.ongoingCounterContainer, false)
	setActive(arg0.leisureCounterContainer, false)

	if getProxy(SettingsProxy):IsMellowStyle() then
		setText(arg0.goBtn:Find("Image"), i18n("commission_label_go_mellow"))
		setText(arg0.finishedBtn:Find("Image"), i18n("commission_label_finish_mellow"))
		setText(var1:Find("unlock/leisure/go_btn/Image"), i18n("commission_label_go_mellow"))
		setText(var1:Find("unlock/finished/finish_btn/Image"), i18n("commission_label_finish_mellow"))
	else
		setText(arg0.goBtn:Find("Image"), i18n("commission_label_go"))
		setText(arg0.finishedBtn:Find("Image"), i18n("commission_label_finish"))
		setText(var1:Find("unlock/leisure/go_btn/Image"), i18n("commission_label_go"))
		setText(var1:Find("unlock/finished/finish_btn/Image"), i18n("commission_label_finish"))
	end

	arg0.timers = {}
end

function var0.Init(arg0)
	onToggle(arg0, arg0.toggle, function(arg0)
		arg0.foldFlag.localScale = Vector3(1, arg0 and -1 or 1, 1)

		if not arg0 then
			return
		end

		local var0, var1 = arg0:CanOpen()

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)
			triggerToggle(arg0._tf, false)

			return
		end

		arg0:Adpater()

		if not arg0.isInitList then
			arg0:UpdateList()

			arg0.isInitList = true
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		arg0:OnSkip()
	end, SFX_PANEL)
	onButton(arg0, arg0.finishedBtn, function()
		arg0:OnFinishAll()
	end, SFX_PANEL)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.list[arg1 + 1]

			arg0:UpdateListItem(arg1 + 1, var0, arg2)
		end
	end)
	arg0:Flush()
end

function var0.Adpater(arg0)
	local var0 = arg0.parentTF.localPosition.x
	local var1 = Vector3(var0, math.abs(arg0._tf.localPosition.y), 0)

	arg0.parentTF.localPosition = var1
end

function var0.CanOpen(arg0)
	return true
end

function var0.Flush(arg0)
	if arg0:CanOpen() then
		arg0:OnFlush()
	end
end

function var0.Update(arg0)
	arg0:Flush()

	if arg0.isInitList then
		arg0:UpdateList()
	end
end

function var0.RemoveTimers(arg0)
	for iter0, iter1 in pairs(arg0.timers or {}) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.UpdateList(arg0)
	arg0:RemoveTimers()

	local var0, var1 = arg0:GetList()

	arg0.uilist:align(var1 or #var0)

	arg0.list = var0
end

function var0.OnFlush(arg0)
	return
end

function var0.UpdateListItem(arg0, arg1, arg2, arg3)
	return
end

function var0.GetList(arg0)
	assert(false)
end

function var0.OnSkip(arg0)
	assert(false)
end

function var0.OnFinishAll(arg0)
	assert(false)
end

function var0.emit(arg0, ...)
	arg0.view:emit(...)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:RemoveTimers()
end

return var0
