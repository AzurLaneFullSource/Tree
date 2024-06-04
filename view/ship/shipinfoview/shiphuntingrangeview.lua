local var0 = class("ShipHuntingRangeView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipHuntingRangeView"
end

function var0.OnInit(arg0)
	arg0.huntingRange = arg0._tf

	setActive(arg0.huntingRange, false)

	arg0.curLevel = arg0.huntingRange:Find("frame/current_level")
	arg0.showLevel = arg0.huntingRange:Find("frame/level/Text")
	arg0.tips = arg0.huntingRange:Find("frame/tips")
	arg0.closeBtn = arg0.huntingRange:Find("frame/close_btn")
	arg0.helpBtn = arg0.huntingRange:Find("frame/help")
	arg0.cellRoot = arg0.huntingRange:Find("frame/range")
	arg0.onSelected = false
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.GetShipVO(arg0)
	if arg0.shareData and arg0.shareData.shipVO then
		return arg0.shareData.shipVO
	end

	return nil
end

function var0.DisplayHuntingRange(arg0)
	arg0.onSelected = true

	local var0 = arg0:GetShipVO()

	setActive(arg0.huntingRange, true)
	arg0:UpdateHuntingRange(var0, var0:getHuntingLv())
	setText(arg0.curLevel, "Lv." .. var0:getHuntingLv())
	setText(arg0.tips, i18n("ship_hunting_level_tips"))
	onButton(arg0, arg0.closeBtn, function()
		arg0:HideHuntingRange()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_hunting.tip
		})
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0.huntingRange)
end

function var0.UpdateHuntingRange(arg0, arg1, arg2)
	local var0 = arg0.cellRoot

	for iter0 = 0, var0.childCount - 1 do
		local var1 = var0:GetChild(iter0)

		setActive(arg0:findTF("activate", var1), false)
	end

	local var2 = arg1:getHuntingRange(arg2)

	_.each(var2, function(arg0)
		local var0 = arg0[1]
		local var1 = arg0[2]
		local var2 = var0 * 7 + var1 + math.floor(24.5)
		local var3 = var0:GetChild(var2)

		if var3 and var2 ~= 24 then
			setActive(arg0:findTF("activate", var3), true)
		end
	end)

	local var3 = arg0.huntingRange:Find("frame/last")
	local var4 = arg0.huntingRange:Find("frame/next")

	setActive(var3, arg2 > 1)
	setActive(var4, arg2 < #arg1:getConfig("hunting_range"))
	setText(arg0.showLevel, "Lv." .. arg2)
	onButton(arg0, var3, function()
		local var0 = arg2 - 1

		if var0 == 0 then
			var0 = #arg1:getConfig("hunting_range")
		end

		arg0:UpdateHuntingRange(arg1, var0)
	end, SFX_PANEL)
	onButton(arg0, var4, function()
		local var0 = arg2 + 1

		if var0 == #arg1:getConfig("hunting_range") + 1 then
			var0 = 1
		end

		arg0:UpdateHuntingRange(arg1, var0)
	end, SFX_PANEL)
end

function var0.HideHuntingRange(arg0)
	setActive(arg0.huntingRange, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.huntingRange, arg0._tf)

	arg0.onSelected = false
end

function var0.OnDestroy(arg0)
	arg0:HideHuntingRange()

	arg0.shareData = nil
end

return var0
