local var0_0 = class("CommissionInfoItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg2_1

	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.parentTF = arg0_1._tf.parent
	arg0_1.goBtn = arg0_1._tf:Find("frame/go_btn")
	arg0_1.finishedBtn = arg0_1._tf:Find("frame/finish_btn")
	arg0_1.toggle = arg0_1._tf:Find("frame")
	arg0_1.foldFlag = arg0_1._tf:Find("frame/tip")
	arg0_1.finishedCounterContainer = arg0_1._tf:Find("frame/counter/finished")
	arg0_1.ongoingCounterContainer = arg0_1._tf:Find("frame/counter/ongoing")
	arg0_1.leisureCounterContainer = arg0_1._tf:Find("frame/counter/leisure")
	arg0_1.finishedCounter = arg0_1._tf:Find("frame/counter/finished/Text"):GetComponent(typeof(Text))
	arg0_1.ongoingCounter = arg0_1._tf:Find("frame/counter/ongoing/Text"):GetComponent(typeof(Text))
	arg0_1.leisureCounter = arg0_1._tf:Find("frame/counter/leisure/Text"):GetComponent(typeof(Text))

	local var0_1 = arg0_1._tf:Find("list")
	local var1_1 = var0_1:GetChild(0)

	arg0_1.uilist = UIItemList.New(var0_1, var1_1)

	setActive(arg0_1.finishedCounterContainer, false)
	setActive(arg0_1.ongoingCounterContainer, false)
	setActive(arg0_1.leisureCounterContainer, false)

	if getProxy(SettingsProxy):IsMellowStyle() then
		setText(arg0_1.goBtn:Find("Image"), i18n("commission_label_go_mellow"))
		setText(arg0_1.finishedBtn:Find("Image"), i18n("commission_label_finish_mellow"))
		setText(var1_1:Find("unlock/leisure/go_btn/Image"), i18n("commission_label_go_mellow"))
		setText(var1_1:Find("unlock/finished/finish_btn/Image"), i18n("commission_label_finish_mellow"))
	else
		setText(arg0_1.goBtn:Find("Image"), i18n("commission_label_go"))
		setText(arg0_1.finishedBtn:Find("Image"), i18n("commission_label_finish"))
		setText(var1_1:Find("unlock/leisure/go_btn/Image"), i18n("commission_label_go"))
		setText(var1_1:Find("unlock/finished/finish_btn/Image"), i18n("commission_label_finish"))
	end

	arg0_1.timers = {}
end

function var0_0.Init(arg0_2)
	onToggle(arg0_2, arg0_2.toggle, function(arg0_3)
		arg0_2.foldFlag.localScale = Vector3(1, arg0_3 and -1 or 1, 1)

		if not arg0_3 then
			return
		end

		local var0_3, var1_3 = arg0_2:CanOpen()

		if not var0_3 then
			pg.TipsMgr.GetInstance():ShowTips(var1_3)
			triggerToggle(arg0_2._tf, false)

			return
		end

		arg0_2:Adpater()

		if not arg0_2.isInitList then
			arg0_2:UpdateList()

			arg0_2.isInitList = true
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.goBtn, function()
		arg0_2:OnSkip()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.finishedBtn, function()
		arg0_2:OnFinishAll()
	end, SFX_PANEL)
	arg0_2.uilist:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_2.list[arg1_6 + 1]

			arg0_2:UpdateListItem(arg1_6 + 1, var0_6, arg2_6)
		end
	end)
	arg0_2:Flush()
end

function var0_0.Adpater(arg0_7)
	local var0_7 = arg0_7.parentTF.localPosition.x
	local var1_7 = Vector3(var0_7, math.abs(arg0_7._tf.localPosition.y), 0)

	arg0_7.parentTF.localPosition = var1_7
end

function var0_0.CanOpen(arg0_8)
	return true
end

function var0_0.Flush(arg0_9)
	if arg0_9:CanOpen() then
		arg0_9:OnFlush()
	end
end

function var0_0.Update(arg0_10)
	arg0_10:Flush()

	if arg0_10.isInitList then
		arg0_10:UpdateList()
	end
end

function var0_0.RemoveTimers(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.timers or {}) do
		iter1_11:Stop()
	end

	arg0_11.timers = {}
end

function var0_0.UpdateList(arg0_12)
	arg0_12:RemoveTimers()

	local var0_12, var1_12 = arg0_12:GetList()

	arg0_12.uilist:align(var1_12 or #var0_12)

	arg0_12.list = var0_12
end

function var0_0.OnFlush(arg0_13)
	return
end

function var0_0.UpdateListItem(arg0_14, arg1_14, arg2_14, arg3_14)
	return
end

function var0_0.GetList(arg0_15)
	assert(false)
end

function var0_0.OnSkip(arg0_16)
	assert(false)
end

function var0_0.OnFinishAll(arg0_17)
	assert(false)
end

function var0_0.emit(arg0_18, ...)
	arg0_18.view:emit(...)
end

function var0_0.Dispose(arg0_19)
	pg.DelegateInfo.Dispose(arg0_19)
	arg0_19:RemoveTimers()
end

return var0_0
