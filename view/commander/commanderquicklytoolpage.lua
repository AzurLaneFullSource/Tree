local var0_0 = class("CommanderQuicklyToolPage", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderQuicklyToolPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close_btn")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel_btn")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm_btn")
	arg0_2.addBtn = arg0_2:findTF("frame/content/count/add")
	arg0_2.reduceBtn = arg0_2:findTF("frame/content/count/reduce")
	arg0_2.valueTxt = arg0_2:findTF("frame/content/count/Text"):GetComponent(typeof(Text))
	arg0_2.time1Txt = arg0_2:findTF("frame/content/time/Text"):GetComponent(typeof(Text))
	arg0_2.maxTxt = arg0_2:findTF("frame/total/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("frame/content/label1"), i18n("commander_box_quickly_tool_tip_1"))
	setText(arg0_2:findTF("frame/content/label2"), i18n("commander_box_quickly_tool_tip_2"))
	setText(arg0_2:findTF("frame/content/time/label"), i18n("commander_box_quickly_tool_tip_3"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.addBtn, function()
		if arg0_3.maxCnt == 0 then
			return
		end

		arg0_3:UpdateValue(math.min(arg0_3.value + 1, arg0_3.maxCnt))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.reduceBtn, function()
		if arg0_3.value <= 1 then
			return
		end

		arg0_3:UpdateValue(math.max(1, arg0_3.value - 1))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.value <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cat_accelfrate_notenough"))

			return
		end

		if arg0_3.value > arg0_3.maxCnt then
			return
		end

		local var0_9 = arg0_3:CalcMaxUsageCnt()

		if var0_9 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_box_was_finished"))

			return
		end

		if var0_9 < arg0_3.value then
			arg0_3:UpdateValue(var0_9)
			pg.TipsMgr.GetInstance():ShowTips(i18n("comander_tool_cnt_is_reclac"))

			return
		end

		arg0_3:emit(CommanderCatMediator.USE_QUICKLY_TOOL, arg0_3.itemId, arg0_3.value, arg0_3.boxId)
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_10, arg1_10, arg2_10)
	setParent(arg0_10._tf, pg.UIMgr.GetInstance().OverlayMain)
	var0_0.super.Show(arg0_10)

	arg0_10.itemId = arg2_10
	arg0_10.boxId = arg1_10
	arg0_10.cost = Item.getConfigData(arg0_10.itemId).usage_arg[1]
	arg0_10.costM = arg0_10.cost / 60

	local var0_10 = getProxy(BagProxy):getItemCountById(arg2_10)
	local var1_10 = arg0_10:CalcMaxUsageCnt()

	arg0_10.maxCnt = math.min(var1_10, var0_10)
	arg0_10.maxTxt.text = var0_10

	arg0_10:UpdateValue(arg0_10.maxCnt)
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	setParent(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.UpdateValue(arg0_12, arg1_12)
	arg0_12.value = arg1_12
	arg0_12.valueTxt.text = arg1_12

	local var0_12 = arg0_12.costM * arg1_12 * 60
	local var1_12 = getProxy(CommanderProxy):getBoxById(arg0_12.boxId):getFinishTime() - var0_12

	arg0_12:AddTimer(var1_12)
end

function var0_0.CalcMaxUsageCnt(arg0_13)
	local var0_13 = getProxy(CommanderProxy):getBoxById(arg0_13.boxId):getFinishTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var0_13 > 0 then
		return (math.ceil(var0_13 / arg0_13.cost))
	else
		return 0
	end
end

function var0_0.AddTimer(arg0_14, arg1_14)
	arg0_14:RemoveTimer()

	arg0_14.timer = Timer.New(function()
		local var0_15 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_15 = arg1_14 - var0_15

		if var1_15 <= 0 then
			arg0_14:RemoveTimer()

			arg0_14.time1Txt.text = "00:00:00"
		else
			local var2_15 = pg.TimeMgr.GetInstance():DescCDTime(var1_15)

			arg0_14.time1Txt.text = var2_15
		end
	end, 1, -1)

	arg0_14.timer:Start()
	arg0_14.timer.func()
end

function var0_0.RemoveTimer(arg0_16)
	if arg0_16.timer then
		arg0_16.timer:Stop()

		arg0_16.timer = nil
	end
end

function var0_0.Hide(arg0_17)
	var0_0.super.Hide(arg0_17)
	arg0_17:RemoveTimer()
end

function var0_0.OnDestroy(arg0_18)
	arg0_18:RemoveTimer()
end

return var0_0
