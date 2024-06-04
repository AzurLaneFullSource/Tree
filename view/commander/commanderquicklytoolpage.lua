local var0 = class("CommanderQuicklyToolPage", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderQuicklyToolPage"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close_btn")
	arg0.cancelBtn = arg0:findTF("frame/cancel_btn")
	arg0.confirmBtn = arg0:findTF("frame/confirm_btn")
	arg0.addBtn = arg0:findTF("frame/content/count/add")
	arg0.reduceBtn = arg0:findTF("frame/content/count/reduce")
	arg0.valueTxt = arg0:findTF("frame/content/count/Text"):GetComponent(typeof(Text))
	arg0.time1Txt = arg0:findTF("frame/content/time/Text"):GetComponent(typeof(Text))
	arg0.maxTxt = arg0:findTF("frame/total/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("frame/content/label1"), i18n("commander_box_quickly_tool_tip_1"))
	setText(arg0:findTF("frame/content/label2"), i18n("commander_box_quickly_tool_tip_2"))
	setText(arg0:findTF("frame/content/time/label"), i18n("commander_box_quickly_tool_tip_3"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.addBtn, function()
		if arg0.maxCnt == 0 then
			return
		end

		arg0:UpdateValue(math.min(arg0.value + 1, arg0.maxCnt))
	end, SFX_PANEL)
	onButton(arg0, arg0.reduceBtn, function()
		if arg0.value <= 1 then
			return
		end

		arg0:UpdateValue(math.max(1, arg0.value - 1))
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.value <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cat_accelfrate_notenough"))

			return
		end

		if arg0.value > arg0.maxCnt then
			return
		end

		local var0 = arg0:CalcMaxUsageCnt()

		if var0 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_box_was_finished"))

			return
		end

		if var0 < arg0.value then
			arg0:UpdateValue(var0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("comander_tool_cnt_is_reclac"))

			return
		end

		arg0:emit(CommanderCatMediator.USE_QUICKLY_TOOL, arg0.itemId, arg0.value, arg0.boxId)
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	setParent(arg0._tf, pg.UIMgr.GetInstance().OverlayMain)
	var0.super.Show(arg0)

	arg0.itemId = arg2
	arg0.boxId = arg1
	arg0.cost = Item.getConfigData(arg0.itemId).usage_arg[1]
	arg0.costM = arg0.cost / 60

	local var0 = getProxy(BagProxy):getItemCountById(arg2)
	local var1 = arg0:CalcMaxUsageCnt()

	arg0.maxCnt = math.min(var1, var0)
	arg0.maxTxt.text = var0

	arg0:UpdateValue(arg0.maxCnt)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	setParent(arg0._tf, arg0._parentTf)
end

function var0.UpdateValue(arg0, arg1)
	arg0.value = arg1
	arg0.valueTxt.text = arg1

	local var0 = arg0.costM * arg1 * 60
	local var1 = getProxy(CommanderProxy):getBoxById(arg0.boxId):getFinishTime() - var0

	arg0:AddTimer(var1)
end

function var0.CalcMaxUsageCnt(arg0)
	local var0 = getProxy(CommanderProxy):getBoxById(arg0.boxId):getFinishTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var0 > 0 then
		return (math.ceil(var0 / arg0.cost))
	else
		return 0
	end
end

function var0.AddTimer(arg0, arg1)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = arg1 - var0

		if var1 <= 0 then
			arg0:RemoveTimer()

			arg0.time1Txt.text = "00:00:00"
		else
			local var2 = pg.TimeMgr.GetInstance():DescCDTime(var1)

			arg0.time1Txt.text = var2
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:RemoveTimer()
end

function var0.OnDestroy(arg0)
	arg0:RemoveTimer()
end

return var0
