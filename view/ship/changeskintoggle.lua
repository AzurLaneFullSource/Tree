local var0_0 = class("ChangeSkinToggle")
local var1_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._toggles = {}
	arg0_1._toggleTfs = {}

	for iter0_1 = 1, var1_0 do
		local var0_1 = findTF(arg0_1._tf, "ad/toggle/" .. iter0_1)
		local var1_1 = GetComponent(var0_1, typeof(Toggle))

		var1_1.isOn = false

		table.insert(arg0_1._toggles, var1_1)
		table.insert(arg0_1._toggleTfs, var0_1)
	end

	arg0_1._toggleContainer = findTF(arg0_1._tf, "ad/toggle")
	arg0_1._asmrContainer = findTF(arg0_1._tf, "ad/asmr")

	arg0_1:UpdateVisible(false)

	arg0_1._asmrTurnning = false
end

function var0_0.setShipData(arg0_2, arg1_2, arg2_2)
	arg0_2._skinId = arg1_2

	local var0_2 = ShipSkin.GetChangeSkinGroupId(arg0_2._skinId)
	local var1_2 = ShipSkin.GetStoreChangeSkinId(var0_2, arg2_2)

	arg0_2._toggleIndex = 1

	if var1_2 then
		arg0_2._toggleIndex = ShipSkin.GetChangeSkinIndex(var1_2)
	end

	arg0_2._nextSkinId = ShipSkin.GetChangeSkinNextId(arg0_2._skinId)

	arg0_2:UpdateVisible(true)
	arg0_2:updateUI()
end

function var0_0.setSkinData(arg0_3, arg1_3)
	arg0_3._skinId = arg1_3
	arg0_3._toggleIndex = ShipSkin.GetChangeSkinIndex(arg1_3)
	arg0_3._nextSkinId = ShipSkin.GetChangeSkinNextId(arg0_3._skinId)

	arg0_3:UpdateVisible(true)
	arg0_3:updateUI()
end

function var0_0.updateUI(arg0_4)
	for iter0_4 = 1, #arg0_4._toggles do
		local var0_4 = arg0_4._toggles[iter0_4]
		local var1_4 = arg0_4._toggleTfs[iter0_4]

		var0_4.isOn = iter0_4 == arg0_4._toggleIndex and true or false

		setActive(findTF(var1_4, "bg"), var0_4.isOn)
	end

	arg0_4:updateToggleUI()
	arg0_4:updateAsmrUI()
end

function var0_0.updateToggleUI(arg0_5)
	local var0_5 = ShipSkin.GetChangeSkinCustomDataId(arg0_5._skinId, "toggle_skin") or 1

	for iter0_5 = 1, #arg0_5._toggleTfs do
		local var1_5 = arg0_5._toggleTfs[iter0_5]

		arg0_5:setChildVisible(findTF(var1_5, "bg"), false)

		local var2_5 = findTF(var1_5, "bg/Checkmark_" .. var0_5)

		setActive(var2_5, true)

		local var3_5 = pg.ship_skin_template[arg0_5._skinId].tag
		local var4_5 = pg.ship_skin_template[arg0_5._nextSkinId].tag

		if iter0_5 == arg0_5._toggleIndex then
			setActive(findTF(var2_5, "l2d"), table.contains(var3_5, ShipSkin.WITH_LIVE2D) or table.contains(var3_5, ShipSkin.WITH_LIVE2D_PLUS))
			setActive(findTF(var2_5, "spine"), table.contains(var3_5, ShipSkin.WITH_SPINE) or table.contains(var3_5, ShipSkin.WITH_SPINE_PLUS))
		else
			setActive(findTF(var1_5, "tag/l2d"), table.contains(var4_5, ShipSkin.WITH_LIVE2D) or table.contains(var4_5, ShipSkin.WITH_LIVE2D_PLUS))
			setActive(findTF(var1_5, "tag/spine"), table.contains(var4_5, ShipSkin.WITH_SPINE) or table.contains(var4_5, ShipSkin.WITH_SPINE_PLUS))
		end
	end

	setActive(arg0_5._toggleContainer, not arg0_5:IsAsmrSkin())
end

function var0_0.updateAsmrUI(arg0_6)
	setActive(arg0_6._asmrContainer, arg0_6:IsAsmrSkin())

	local var0_6 = ShipSkin.GetChangeSkinCustomDataId(arg0_6._skinId, "asmr") == 1

	setActive(findTF(arg0_6._asmrContainer, "on"), var0_6)
	setActive(findTF(arg0_6._asmrContainer, "off"), not var0_6)
end

function var0_0.setChildVisible(arg0_7, arg1_7, arg2_7)
	for iter0_7 = 1, arg1_7.childCount do
		setActive(arg1_7:GetChild(iter0_7 - 1), arg2_7)
	end
end

function var0_0.SetAsmrTurnning(arg0_8, arg1_8)
	arg0_8._asmrTurnning = arg1_8

	arg0_8:UpdateVisible(true)

	if arg0_8._skinId then
		arg0_8:updateUI()
	end
end

function var0_0.UpdateVisible(arg0_9, arg1_9)
	if not arg0_9._skinId then
		setActive(arg0_9._tf, false)

		return
	end

	if arg0_9:IsAsmrSkin() and not arg0_9._asmrTurnning then
		setActive(arg0_9._tf, false)

		return
	end

	setActive(arg0_9._tf, arg1_9)
end

function var0_0.IsAsmrSkin(arg0_10)
	if not arg0_10._skinId then
		return false
	end

	return ShipSkin.GetChangeSkinCustomDataId(arg0_10._skinId, "asmr") == 1 or ShipSkin.GetChangeSkinCustomDataId(arg0_10._nextSkinId, "asmr") == 1 or false
end

return var0_0
