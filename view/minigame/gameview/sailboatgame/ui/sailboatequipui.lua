local var0 = class("SailBoatEquipUI")
local var1

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	var1 = SailBoatGameVo
	arg0._equipUI = findTF(arg0._tf, "ui/equipUI")
	arg0.btnBack = findTF(arg0._equipUI, "back")
	arg0.btnBack1 = findTF(arg0._equipUI, "back_1")
	arg0.btnStart = findTF(arg0._equipUI, "btnStart")

	onButton(arg0._event, arg0.btnBack1, function()
		arg0:show(false)
		arg0._event:emit(SailBoatGameView.BACK_MENU)
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnStart, function()
		arg0._event:emit(SailBoatGameView.READY_START)
	end, SFX_CONFIRM)

	arg0.selectTpl = findTF(arg0._equipUI, "selectItem")
	arg0.equipTpl = findTF(arg0._equipUI, "equipItem")
	arg0.selectContent = findTF(arg0._equipUI, "select/ad/list")
	arg0.equipContent = findTF(arg0._equipUI, "equip/list")
	arg0.unEquipFlag = false
	arg0.baseHp = SailBoatGameConst.game_char[var1.char_id].hp
	arg0.baseSpeed = SailBoatGameConst.game_char[var1.char_id].speed.x
	arg0.speedTf = findTF(arg0._equipUI, "equip/speed")
	arg0.hpTf = findTF(arg0._equipUI, "equip/hp")
	arg0.btnUnEquip = findTF(arg0._equipUI, "btnUnEquip")

	onButton(arg0._event, arg0.btnUnEquip, function()
		if arg0.curSelectItem then
			arg0.unEquipFlag = true
		else
			arg0.unEquipFlag = not arg0.unEquipFlag
		end

		if arg0.unEquipFlag then
			arg0.curSelectData = nil
			arg0.curSelectItem = nil
		end

		arg0:updateUI()
	end)

	arg0.selects = {}

	for iter0 = 1, #SailBoatGameConst.equip_data do
		local var0 = SailBoatGameConst.equip_data[iter0]
		local var1 = tf(instantiate(arg0.selectTpl))

		onButton(arg0._event, var1, function()
			if arg0.curSelectItem == var1 then
				arg0.curSelectItem = nil
				arg0.curSelectData = nil
			else
				arg0.curSelectItem = var1
				arg0.curSelectData = var0

				if arg0.unEquipFlag then
					arg0.unEquipFlag = false
				end
			end

			arg0:updateUI()
		end, SFX_CANCEL)

		local var2 = GetComponent(findTF(var1, "icon"), typeof(Image))

		var2.sprite = var1.GetEquipIcon(var0.icon)

		var2:SetNativeSize()
		SetParent(var1, arg0.selectContent)
		table.insert(arg0.selects, var1)
	end

	arg0.equips = {}
	arg0.equipItems = {}

	for iter1 = 1, SailBoatGameConst.max_equip_count do
		table.insert(arg0.equips, 0)
	end

	for iter2 = 1, SailBoatGameConst.max_equip_count do
		local var3 = iter2
		local var4 = tf(instantiate(arg0.equipTpl))
		local var5 = arg0.equips[iter2]

		onButton(arg0._event, var4, function()
			local var0 = var1.GetGameUseTimes()

			if var1.GetGameTimes() > 0 then
				var0 = var0 + 1
			end

			if SailBoatGameConst.game_round[var0].equip_count >= var3 then
				if arg0.curSelectData then
					if not arg0:checkEquipAble(arg0.curSelectData.id) then
						return
					end

					arg0.equips[iter2] = arg0.curSelectData.id
				elseif arg0.unEquipFlag then
					arg0.equips[iter2] = 0
				end

				arg0:updateUI()
			end
		end, SFX_CANCEL)
		SetParent(var4, arg0.equipContent)
		table.insert(arg0.equipItems, var4)
	end

	arg0.descTf = findTF(arg0._equipUI, "desc")
	arg0.descTextTf = findTF(arg0._equipUI, "desc/bg/desc")
	arg0.curSelectItem = nil
	arg0.curSelectData = nil

	arg0:showUI()
	arg0:updateUI()
end

function var0.show(arg0, arg1)
	setActive(arg0._equipUI, arg1)
	arg0:showUI()
	arg0:updateUI()
end

function var0.showUI(arg0)
	local var0 = var1.GetGameUseTimes()

	if var1.GetGameTimes() > 0 then
		var0 = var0 + 1
	end

	arg0.roundEquipData = SailBoatGameConst.game_equip_round[var0]

	for iter0 = 1, #arg0.selects do
		if arg0.roundEquipData[iter0][2] == 0 then
			setActive(arg0.selects[iter0], false)
		else
			setActive(arg0.selects[iter0], true)
		end
	end
end

function var0.checkEquipAble(arg0, arg1)
	local var0 = 0
	local var1 = var1.GetGameUseTimes()

	if var1.GetGameTimes() > 0 then
		var1 = var1 + 1
	end

	local var2 = SailBoatGameConst.game_equip_round[var1]

	for iter0 = 1, #var2 do
		if var2[iter0][1] == arg1 then
			var0 = var2[iter0][2]
		end
	end

	if var0 == 0 then
		return false, 0, 0
	end

	local var3 = 0

	for iter1 = 1, #arg0.equips do
		if arg0.equips[iter1] == arg1 then
			var3 = var3 + 1
		end
	end

	if var0 <= var3 then
		return false, var3, var0
	end

	return true, var3, var0
end

function var0.updateUI(arg0)
	for iter0 = 1, #arg0.selects do
		local var0 = arg0.selects[iter0]

		setActive(findTF(var0, "select"), arg0.curSelectItem == var0)

		local var1, var2, var3 = arg0:checkEquipAble(iter0)

		setText(findTF(var0, "amount"), var3 - var2)
	end

	setActive(arg0.descTf, arg0.curSelectItem ~= nil)

	if arg0.curSelectItem then
		arg0.descTf.anchoredPosition = arg0._equipUI:InverseTransformPoint(arg0.curSelectItem.position)

		setText(arg0.descTextTf, i18n(arg0.curSelectData.desc))
	end

	local var4 = var1.GetGameUseTimes()

	if var1.GetGameTimes() > 0 then
		var4 = var4 + 1
	end

	local var5 = SailBoatGameConst.game_round[var4].equip_count

	for iter1 = 1, SailBoatGameConst.max_equip_count do
		local var6 = iter1
		local var7 = arg0.equips[iter1]
		local var8 = arg0.equipItems[iter1]

		setActive(findTF(var8, "lock"), var5 < iter1)
		setActive(findTF(var8, "empty"), false)
		setActive(findTF(var8, "bg"), false)
		setActive(findTF(var8, "icon"), false)
		setActive(findTF(var8, "unEquip"), false)
		setActive(findTF(var8, "add"), false)
		setActive(findTF(var8, "add_2"), false)

		local var9 = true

		if var7 ~= 0 then
			local var10 = SailBoatGameConst.equip_data[var7]
			local var11 = GetComponent(findTF(var8, "icon"), typeof(Image))

			var11.sprite = var1.GetEquipIcon(var10.icon)

			var11:SetNativeSize()
			setActive(findTF(var8, "bg"), true)
			setActive(findTF(var8, "icon"), true)

			if arg0.unEquipFlag then
				setActive(findTF(var8, "unEquip"), true)
			end

			var9 = false
		else
			setActive(findTF(var8, "empty"), true)
		end

		if arg0.curSelectItem and iter1 <= var5 then
			if var9 then
				setActive(findTF(var8, "add"), true)
			else
				setActive(findTF(var8, "add_2"), true)
			end
		end
	end

	local var12 = arg0.baseHp
	local var13 = arg0.baseSpeed

	for iter2 = 1, #arg0.equips do
		local var14 = arg0.equips[iter2]

		if var14 ~= 0 then
			local var15 = SailBoatGameConst.equip_data[var14]

			var12 = var12 + var15.hp
			var13 = var13 + var15.speed
		end
	end

	setText(arg0.speedTf, tostring(var13))
	setText(arg0.hpTf, tostring(var12))

	var1.equips = arg0.equips
end

return var0
