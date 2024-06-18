local var0_0 = class("SailBoatEquipUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = SailBoatGameVo
	arg0_1._equipUI = findTF(arg0_1._tf, "ui/equipUI")
	arg0_1.btnBack = findTF(arg0_1._equipUI, "back")
	arg0_1.btnBack1 = findTF(arg0_1._equipUI, "back_1")
	arg0_1.btnStart = findTF(arg0_1._equipUI, "btnStart")

	onButton(arg0_1._event, arg0_1.btnBack1, function()
		arg0_1:show(false)
		arg0_1._event:emit(SailBoatGameView.BACK_MENU)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnStart, function()
		arg0_1._event:emit(SailBoatGameView.READY_START)
	end, SFX_CONFIRM)

	arg0_1.selectTpl = findTF(arg0_1._equipUI, "selectItem")
	arg0_1.equipTpl = findTF(arg0_1._equipUI, "equipItem")
	arg0_1.selectContent = findTF(arg0_1._equipUI, "select/ad/list")
	arg0_1.equipContent = findTF(arg0_1._equipUI, "equip/list")
	arg0_1.unEquipFlag = false
	arg0_1.baseHp = SailBoatGameConst.game_char[var1_0.char_id].hp
	arg0_1.baseSpeed = SailBoatGameConst.game_char[var1_0.char_id].speed.x
	arg0_1.speedTf = findTF(arg0_1._equipUI, "equip/speed")
	arg0_1.hpTf = findTF(arg0_1._equipUI, "equip/hp")
	arg0_1.btnUnEquip = findTF(arg0_1._equipUI, "btnUnEquip")

	onButton(arg0_1._event, arg0_1.btnUnEquip, function()
		if arg0_1.curSelectItem then
			arg0_1.unEquipFlag = true
		else
			arg0_1.unEquipFlag = not arg0_1.unEquipFlag
		end

		if arg0_1.unEquipFlag then
			arg0_1.curSelectData = nil
			arg0_1.curSelectItem = nil
		end

		arg0_1:updateUI()
	end)

	arg0_1.selects = {}

	for iter0_1 = 1, #SailBoatGameConst.equip_data do
		local var0_1 = SailBoatGameConst.equip_data[iter0_1]
		local var1_1 = tf(instantiate(arg0_1.selectTpl))

		onButton(arg0_1._event, var1_1, function()
			if arg0_1.curSelectItem == var1_1 then
				arg0_1.curSelectItem = nil
				arg0_1.curSelectData = nil
			else
				arg0_1.curSelectItem = var1_1
				arg0_1.curSelectData = var0_1

				if arg0_1.unEquipFlag then
					arg0_1.unEquipFlag = false
				end
			end

			arg0_1:updateUI()
		end, SFX_CANCEL)

		local var2_1 = GetComponent(findTF(var1_1, "icon"), typeof(Image))

		var2_1.sprite = var1_0.GetEquipIcon(var0_1.icon)

		var2_1:SetNativeSize()
		SetParent(var1_1, arg0_1.selectContent)
		table.insert(arg0_1.selects, var1_1)
	end

	arg0_1.equips = {}
	arg0_1.equipItems = {}

	for iter1_1 = 1, SailBoatGameConst.max_equip_count do
		table.insert(arg0_1.equips, 0)
	end

	for iter2_1 = 1, SailBoatGameConst.max_equip_count do
		local var3_1 = iter2_1
		local var4_1 = tf(instantiate(arg0_1.equipTpl))
		local var5_1 = arg0_1.equips[iter2_1]

		onButton(arg0_1._event, var4_1, function()
			local var0_6 = var1_0.GetGameUseTimes()

			if var1_0.GetGameTimes() > 0 then
				var0_6 = var0_6 + 1
			end

			if SailBoatGameConst.game_round[var0_6].equip_count >= var3_1 then
				if arg0_1.curSelectData then
					if not arg0_1:checkEquipAble(arg0_1.curSelectData.id) then
						return
					end

					arg0_1.equips[iter2_1] = arg0_1.curSelectData.id
				elseif arg0_1.unEquipFlag then
					arg0_1.equips[iter2_1] = 0
				end

				arg0_1:updateUI()
			end
		end, SFX_CANCEL)
		SetParent(var4_1, arg0_1.equipContent)
		table.insert(arg0_1.equipItems, var4_1)
	end

	arg0_1.descTf = findTF(arg0_1._equipUI, "desc")
	arg0_1.descTextTf = findTF(arg0_1._equipUI, "desc/bg/desc")
	arg0_1.curSelectItem = nil
	arg0_1.curSelectData = nil

	arg0_1:showUI()
	arg0_1:updateUI()
end

function var0_0.show(arg0_7, arg1_7)
	setActive(arg0_7._equipUI, arg1_7)
	arg0_7:showUI()
	arg0_7:updateUI()
end

function var0_0.showUI(arg0_8)
	local var0_8 = var1_0.GetGameUseTimes()

	if var1_0.GetGameTimes() > 0 then
		var0_8 = var0_8 + 1
	end

	arg0_8.roundEquipData = SailBoatGameConst.game_equip_round[var0_8]

	for iter0_8 = 1, #arg0_8.selects do
		if arg0_8.roundEquipData[iter0_8][2] == 0 then
			setActive(arg0_8.selects[iter0_8], false)
		else
			setActive(arg0_8.selects[iter0_8], true)
		end
	end
end

function var0_0.checkEquipAble(arg0_9, arg1_9)
	local var0_9 = 0
	local var1_9 = var1_0.GetGameUseTimes()

	if var1_0.GetGameTimes() > 0 then
		var1_9 = var1_9 + 1
	end

	local var2_9 = SailBoatGameConst.game_equip_round[var1_9]

	for iter0_9 = 1, #var2_9 do
		if var2_9[iter0_9][1] == arg1_9 then
			var0_9 = var2_9[iter0_9][2]
		end
	end

	if var0_9 == 0 then
		return false, 0, 0
	end

	local var3_9 = 0

	for iter1_9 = 1, #arg0_9.equips do
		if arg0_9.equips[iter1_9] == arg1_9 then
			var3_9 = var3_9 + 1
		end
	end

	if var0_9 <= var3_9 then
		return false, var3_9, var0_9
	end

	return true, var3_9, var0_9
end

function var0_0.updateUI(arg0_10)
	for iter0_10 = 1, #arg0_10.selects do
		local var0_10 = arg0_10.selects[iter0_10]

		setActive(findTF(var0_10, "select"), arg0_10.curSelectItem == var0_10)

		local var1_10, var2_10, var3_10 = arg0_10:checkEquipAble(iter0_10)

		setText(findTF(var0_10, "amount"), var3_10 - var2_10)
	end

	setActive(arg0_10.descTf, arg0_10.curSelectItem ~= nil)

	if arg0_10.curSelectItem then
		arg0_10.descTf.anchoredPosition = arg0_10._equipUI:InverseTransformPoint(arg0_10.curSelectItem.position)

		setText(arg0_10.descTextTf, i18n(arg0_10.curSelectData.desc))
	end

	local var4_10 = var1_0.GetGameUseTimes()

	if var1_0.GetGameTimes() > 0 then
		var4_10 = var4_10 + 1
	end

	local var5_10 = SailBoatGameConst.game_round[var4_10].equip_count

	for iter1_10 = 1, SailBoatGameConst.max_equip_count do
		local var6_10 = iter1_10
		local var7_10 = arg0_10.equips[iter1_10]
		local var8_10 = arg0_10.equipItems[iter1_10]

		setActive(findTF(var8_10, "lock"), var5_10 < iter1_10)
		setActive(findTF(var8_10, "empty"), false)
		setActive(findTF(var8_10, "bg"), false)
		setActive(findTF(var8_10, "icon"), false)
		setActive(findTF(var8_10, "unEquip"), false)
		setActive(findTF(var8_10, "add"), false)
		setActive(findTF(var8_10, "add_2"), false)

		local var9_10 = true

		if var7_10 ~= 0 then
			local var10_10 = SailBoatGameConst.equip_data[var7_10]
			local var11_10 = GetComponent(findTF(var8_10, "icon"), typeof(Image))

			var11_10.sprite = var1_0.GetEquipIcon(var10_10.icon)

			var11_10:SetNativeSize()
			setActive(findTF(var8_10, "bg"), true)
			setActive(findTF(var8_10, "icon"), true)

			if arg0_10.unEquipFlag then
				setActive(findTF(var8_10, "unEquip"), true)
			end

			var9_10 = false
		else
			setActive(findTF(var8_10, "empty"), true)
		end

		if arg0_10.curSelectItem and iter1_10 <= var5_10 then
			if var9_10 then
				setActive(findTF(var8_10, "add"), true)
			else
				setActive(findTF(var8_10, "add_2"), true)
			end
		end
	end

	local var12_10 = arg0_10.baseHp
	local var13_10 = arg0_10.baseSpeed

	for iter2_10 = 1, #arg0_10.equips do
		local var14_10 = arg0_10.equips[iter2_10]

		if var14_10 ~= 0 then
			local var15_10 = SailBoatGameConst.equip_data[var14_10]

			var12_10 = var12_10 + var15_10.hp
			var13_10 = var13_10 + var15_10.speed
		end
	end

	setText(arg0_10.speedTf, tostring(var13_10))
	setText(arg0_10.hpTf, tostring(var12_10))

	var1_0.equips = arg0_10.equips
end

return var0_0
