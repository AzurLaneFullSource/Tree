local var0_0 = class("MainPaintingLiteBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	setActive(arg0_1._tf, false)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0_1:changeLitOn(false)
	end)
	onButton(arg0_1, findTF(arg0_1._tf, "btn"), function()
		arg0_1:OnClickBtn()
	end)

	function SpinePaintingConst.painting_lit_action_callback()
		if arg0_1._litUI then
			arg0_1._litUI:SetVisible(arg0_1._liteOn and not SpinePaintingConst.spine_painting_action)
		end
	end

	arg0_1:changeLitOn(false)
end

function var0_0.OnClick(arg0_5)
	return
end

function var0_0.OnClickBtn(arg0_6)
	arg0_6:changeLitOn(not arg0_6._liteOn)
end

function var0_0.changeLitOn(arg0_7, arg1_7)
	arg0_7._liteOn = arg1_7
	SpinePaintingConst.painting_lit_opening = arg0_7._liteOn

	if arg0_7._litUI then
		arg0_7._litUI:SetVisible(arg0_7._liteOn and not SpinePaintingConst.spine_painting_action)
	end

	arg0_7:updateUI()
end

function var0_0.Flush(arg0_8, arg1_8)
	arg0_8:FlushUI()
end

function var0_0.FlushUI(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData():GetFlagShip()

	arg0_9._paintingName = var0_9:getPainting()
	arg0_9._shipId = var0_9.id

	local var1_9 = getProxy(SettingsProxy):getCharacterSetting(var0_9.id, SHIP_FLAG_SP)

	SpinePaintingConst.painting_lit_value = SpinePaintingDrag.GetPaintingLite(arg0_9._paintingName, arg0_9._shipId)

	local var2_9 = SpinePaintingConst.painting_lit_data[arg0_9._paintingName] and SpinePaintingConst.painting_lit_data[arg0_9._paintingName].classes or "MainPaintingLitUI"
	local var3_9

	if var2_9 and _G[var2_9] then
		var3_9 = _G[var2_9]
	end

	if var0_9:isLightSkin() and var1_9 then
		if arg0_9._litUI and arg0_9._litUI:GetSkinId() ~= var0_9:getSkinId() then
			arg0_9._litUI:Dispose()

			arg0_9._litUI = nil
		end

		if not arg0_9._litUI then
			arg0_9._litUI = var3_9.New(arg0_9._tf, arg0_9)

			arg0_9._litUI:SetShip(var0_9)
		end

		setActive(arg0_9._tf, true)
		arg0_9:changeLitOn(false)
	else
		setActive(arg0_9._tf, false)
	end

	if arg0_9._litUI then
		arg0_9._litUI:Flush()
	end

	arg0_9:updateUI()
end

function var0_0.updateUI(arg0_10)
	setActive(findTF(arg0_10._tf, "btn/on"), arg0_10._liteOn)
	setActive(findTF(arg0_10._tf, "btn/off"), not arg0_10._liteOn)

	if arg0_10._litUI then
		arg0_10._litUI:Update()
	end
end

function var0_0.IsFixed(arg0_11)
	return true
end

function var0_0.Dispose(arg0_12)
	pg.DelegateInfo.Dispose(arg0_12)
	var0_0.super.Dispose(arg0_12)
end

return var0_0
