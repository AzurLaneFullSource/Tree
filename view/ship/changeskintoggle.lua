local var0_0 = class("ChangeSkinToggle")
local var1_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._toggles = {}

	for iter0_1 = 1, var1_0 do
		local var0_1 = findTF(arg0_1._tf, "ad/toggle/" .. iter0_1)
		local var1_1 = GetComponent(var0_1, typeof(Toggle))

		var1_1.isOn = false

		table.insert(arg0_1._toggles, var1_1)
	end

	setActive(arg0_1._tf, false)
end

function var0_0.setShipData(arg0_2, arg1_2, arg2_2)
	arg0_2._skinId = arg1_2
	arg0_2._shipId = arg2_2

	local var0_2 = ShipGroup.GetChangeSkinGroupId(arg0_2._skinId)
	local var1_2 = ShipGroup.GetStoreChangeSkinId(var0_2, arg0_2._shipId)

	arg0_2._toggleIndex = 1

	if var1_2 then
		arg0_2._toggleIndex = ShipGroup.GetChangeSkinIndex(var1_2)
	end

	setActive(arg0_2._tf, true)
	arg0_2:updateUI()
end

function var0_0.setSkinData(arg0_3, arg1_3)
	arg0_3._skinId = arg1_3
	arg0_3._toggleIndex = ShipGroup.GetChangeSkinIndex(arg1_3)

	setActive(arg0_3._tf, true)
	arg0_3:updateUI()
end

function var0_0.updateUI(arg0_4)
	for iter0_4 = 1, #arg0_4._toggles do
		arg0_4._toggles[iter0_4].isOn = iter0_4 == arg0_4._toggleIndex and true or false
	end
end

return var0_0
