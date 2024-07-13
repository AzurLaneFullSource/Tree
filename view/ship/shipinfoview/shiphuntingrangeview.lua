local var0_0 = class("ShipHuntingRangeView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipHuntingRangeView"
end

function var0_0.OnInit(arg0_2)
	arg0_2.huntingRange = arg0_2._tf

	setActive(arg0_2.huntingRange, false)

	arg0_2.curLevel = arg0_2.huntingRange:Find("frame/current_level")
	arg0_2.showLevel = arg0_2.huntingRange:Find("frame/level/Text")
	arg0_2.tips = arg0_2.huntingRange:Find("frame/tips")
	arg0_2.closeBtn = arg0_2.huntingRange:Find("frame/close_btn")
	arg0_2.helpBtn = arg0_2.huntingRange:Find("frame/help")
	arg0_2.cellRoot = arg0_2.huntingRange:Find("frame/range")
	arg0_2.onSelected = false
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.GetShipVO(arg0_4)
	if arg0_4.shareData and arg0_4.shareData.shipVO then
		return arg0_4.shareData.shipVO
	end

	return nil
end

function var0_0.DisplayHuntingRange(arg0_5)
	arg0_5.onSelected = true

	local var0_5 = arg0_5:GetShipVO()

	setActive(arg0_5.huntingRange, true)
	arg0_5:UpdateHuntingRange(var0_5, var0_5:getHuntingLv())
	setText(arg0_5.curLevel, "Lv." .. var0_5:getHuntingLv())
	setText(arg0_5.tips, i18n("ship_hunting_level_tips"))
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:HideHuntingRange()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_hunting.tip
		})
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5.huntingRange)
end

function var0_0.UpdateHuntingRange(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cellRoot

	for iter0_8 = 0, var0_8.childCount - 1 do
		local var1_8 = var0_8:GetChild(iter0_8)

		setActive(arg0_8:findTF("activate", var1_8), false)
	end

	local var2_8 = arg1_8:getHuntingRange(arg2_8)

	_.each(var2_8, function(arg0_9)
		local var0_9 = arg0_9[1]
		local var1_9 = arg0_9[2]
		local var2_9 = var0_9 * 7 + var1_9 + math.floor(24.5)
		local var3_9 = var0_8:GetChild(var2_9)

		if var3_9 and var2_9 ~= 24 then
			setActive(arg0_8:findTF("activate", var3_9), true)
		end
	end)

	local var3_8 = arg0_8.huntingRange:Find("frame/last")
	local var4_8 = arg0_8.huntingRange:Find("frame/next")

	setActive(var3_8, arg2_8 > 1)
	setActive(var4_8, arg2_8 < #arg1_8:getConfig("hunting_range"))
	setText(arg0_8.showLevel, "Lv." .. arg2_8)
	onButton(arg0_8, var3_8, function()
		local var0_10 = arg2_8 - 1

		if var0_10 == 0 then
			var0_10 = #arg1_8:getConfig("hunting_range")
		end

		arg0_8:UpdateHuntingRange(arg1_8, var0_10)
	end, SFX_PANEL)
	onButton(arg0_8, var4_8, function()
		local var0_11 = arg2_8 + 1

		if var0_11 == #arg1_8:getConfig("hunting_range") + 1 then
			var0_11 = 1
		end

		arg0_8:UpdateHuntingRange(arg1_8, var0_11)
	end, SFX_PANEL)
end

function var0_0.HideHuntingRange(arg0_12)
	setActive(arg0_12.huntingRange, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12.huntingRange, arg0_12._tf)

	arg0_12.onSelected = false
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:HideHuntingRange()

	arg0_13.shareData = nil
end

return var0_0
