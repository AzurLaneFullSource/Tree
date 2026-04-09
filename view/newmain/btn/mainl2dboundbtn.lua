local var0_0 = class("MainL2dBoundBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	setActive(arg0_1._tf, false)
	arg0_1:bind(GAME.ROTATE_PAINTING_INDEX, function()
		arg0_1:FlushL2d()
	end)
end

function var0_0.OnClick(arg0_3)
	Live2dConst.l2d_bound_open = not tobool(Live2dConst.l2d_bound_open)

	arg0_3:FlushL2d()
	pg.TipsMgr.GetInstance():ShowTips(i18n(Live2dConst.l2d_bound_open and "l2d_tip_on" or "l2d_tip_off"))
end

function var0_0.Flush(arg0_4, arg1_4)
	arg0_4:FlushL2d()
end

function var0_0.IsFixed(arg0_5)
	return true
end

function var0_0.FlushL2d(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData():GetCurrentFlagShip()
	local var1_6 = MainPaintingView.GetAssistantStatus(var0_6) == MainPaintingView.STATE_L2D
	local var2_6 = var0_6:GetSkinConfig().id
	local var3_6 = var0_6:GetSkinConfig().ship_l2d_id

	if pg.ship_l2d_tips[var2_6] and var1_6 and var3_6 and type(var3_6) == "table" and #var3_6 > 0 then
		setActive(arg0_6._tf, true)
		setActive(findTF(arg0_6._tf, "on"), not Live2dConst.l2d_bound_open)
		setActive(findTF(arg0_6._tf, "off"), Live2dConst.l2d_bound_open)
	else
		Live2dConst.l2d_bound_open = false

		setActive(arg0_6._tf, false)
	end

	arg0_6:emit(NewMainScene.L2D_BOUND_CHANGE)
end

return var0_0
