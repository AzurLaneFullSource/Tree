local var0_0 = class("EquipUpgradeLayer", import("..base.BaseUI"))

var0_0.CHAT_DURATION_TIME = 0.3

function var0_0.getUIName(arg0_1)
	return "EquipUpgradeUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)

	arg0_2.mainPanel = arg0_2._tf:Find("main")
	arg0_2.finishPanel = arg0_2._tf:Find("finish_panel")

	setActive(arg0_2.mainPanel, true)
	setActive(arg0_2.finishPanel, false)

	arg0_2.equipmentList = arg0_2.mainPanel:Find("panel/equipment_list")
	arg0_2.equipmentContain = arg0_2.equipmentList:Find("equipments")
	arg0_2.equipmentTpl = arg0_2:getTpl("equiptpl", arg0_2.equipmentContain)

	setActive(arg0_2.equipmentList, false)

	arg0_2.equipmentPanel = arg0_2.mainPanel:Find("panel/equipment_panel")
	arg0_2.materialPanel = arg0_2.mainPanel:Find("panel/material_panel")
	arg0_2.startBtn = arg0_2.materialPanel:Find("start_btn")
	arg0_2.overLimit = arg0_2.materialPanel:Find("materials/limit")

	setText(arg0_2.overLimit:Find("text"), i18n("equipment_upgrade_overlimit"))

	arg0_2.materialsContain = arg0_2.materialPanel:Find("materials/materials")

	setText(arg0_2.rtTogglesEmpty:Find("Text"), i18n("equip_enhancement_finish"))
	setText(arg0_2.rtPanelTitle, i18n("equip_enhancement_required"))
	setText(arg0_2.rtTitle, i18n("equip_enhancement_title"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.btnCancel, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	arg0_3:updateAll()
end

function var0_0.updateAll(arg0_6)
	setActive(arg0_6.equipmentList, arg0_6.contextData.shipVO)

	if arg0_6.contextData.shipVO then
		arg0_6:displayEquipments()

		if arg0_6.contextData.pos then
			triggerButton(arg0_6.equipmentTFs[arg0_6.contextData.pos])
		else
			triggerButton(arg0_6.equipmentContain:GetChild(0))
		end
	else
		arg0_6:updateEquipment()
		arg0_6:updateMaterials()
	end
end

function var0_0.displayEquipments(arg0_7)
	arg0_7.equipmentTFs = {}

	removeAllChildren(arg0_7.equipmentContain)

	local var0_7 = arg0_7.contextData.shipVO

	for iter0_7, iter1_7 in ipairs(var0_7.equipments) do
		if iter1_7 then
			local var1_7 = cloneTplTo(arg0_7.equipmentTpl, arg0_7.equipmentContain)

			updateEquipment(var1_7, iter1_7)

			local var2_7 = var1_7:Find("tip")

			setActive(var2_7, false)

			if arg0_7:isMaterialEnough(iter1_7) and iter1_7:getConfig("next") ~= 0 then
				setActive(var2_7, true)
				blinkAni(var2_7, 0.5)
			end

			onButton(arg0_7, var1_7, function()
				local var0_8 = arg0_7.contextData.pos

				if var0_8 then
					setActive(arg0_7.equipmentTFs[var0_8]:Find("selected"), false)
					setActive(arg0_7.equipmentTFs[var0_8]:Find("tip"), arg0_7:isMaterialEnough(var0_7:getEquip(var0_8)) and var0_7:getEquip(var0_8):getConfig("next") ~= 0)
				end

				arg0_7.contextData.pos = iter0_7
				arg0_7.contextData.equipmentId = iter1_7.id
				arg0_7.contextData.equipmentVO = iter1_7

				local var1_8 = arg0_7.contextData.pos

				setActive(arg0_7.equipmentTFs[var1_8]:Find("selected"), true)
				setActive(arg0_7.equipmentTFs[var1_8]:Find("tip"), false)
				arg0_7:updateEquipment()
				arg0_7:updateMaterials()
			end, SFX_PANEL)

			arg0_7.equipmentTFs[iter0_7] = var1_7
		end
	end
end

function var0_0.isMaterialEnough(arg0_9, arg1_9)
	local var0_9 = arg1_9:getConfig("trans_use_item")

	if not var0_9 then
		return false
	end

	for iter0_9, iter1_9 in ipairs(underscore.map(var0_9, function(arg0_10)
		local var0_10, var1_10 = unpack(arg0_10)

		return Drop.New({
			type = DROP_TYPE_ITEM,
			id = var0_10,
			count = var1_10
		})
	end)) do
		if iter1_9.count > iter1_9:getOwnedCount() then
			return false
		end
	end

	return true
end

function var0_0.updateEquipment(arg0_11)
	local var0_11 = arg0_11.contextData.equipmentVO

	arg0_11.contextData.equipmentId = var0_11.id

	changeToScrollText(arg0_11.equipmentPanel:Find("name_container"), var0_11:getConfig("name"))
	setActive(findTF(arg0_11.equipmentPanel, "unique"), var0_11:isUnique())
	updateEquipment(arg0_11.equipmentPanel:Find("equiptpl"), var0_11)

	arg0_11.nextEquips = {}

	while var0_11:getConfig("next") > 0 do
		var0_11 = var0_11:MigrateTo(var0_11:getConfig("next"))

		table.insert(arg0_11.nextEquips, var0_11)
	end

	if #arg0_11.nextEquips == 0 then
		arg0_11.toggleEquips = nil
	else
		arg0_11.toggleEquips = {
			arg0_11.nextEquips[1]
		}

		if #arg0_11.nextEquips > 0 then
			local var1_11 = arg0_11.nextEquips[#arg0_11.nextEquips]
			local var2_11 = var1_11:getConfig("level")
			local var3_11 = switch(var1_11:getConfig("level") - 1, {
				[13] = function()
					return {
						10,
						13
					}
				end,
				[11] = function()
					return {
						10,
						11
					}
				end,
				[10] = function()
					return {
						10
					}
				end,
				[7] = function()
					return {
						6,
						7
					}
				end,
				[6] = function()
					return {
						6
					}
				end,
				[3] = function()
					return {
						3
					}
				end
			}, function()
				return {}
			end)

			for iter0_11, iter1_11 in ipairs(var3_11) do
				if #arg0_11.nextEquips > var2_11 - 1 - iter1_11 then
					table.insert(arg0_11.toggleEquips, arg0_11.nextEquips[#arg0_11.nextEquips - (var2_11 - 1 - iter1_11)])
				end
			end
		end
	end

	arg0_11:updateToggles()
end

function var0_0.updateToggles(arg0_19)
	setActive(arg0_19.rtToggles, tobool(arg0_19.toggleEquips))
	setActive(arg0_19.rtTogglesEmpty, not tobool(arg0_19.toggleEquips))

	if arg0_19.toggleEquips then
		UIItemList.StaticAlign(arg0_19.rtToggles, arg0_19.rtToggleTpl, #arg0_19.toggleEquips, function(arg0_20, arg1_20, arg2_20)
			arg1_20 = arg1_20 + 1

			if arg0_20 == UIItemList.EventUpdate then
				local var0_20 = arg0_19.toggleEquips[arg1_20]

				if arg1_20 == 1 then
					setText(arg2_20:Find("Text"), i18n("equip_enhancement_lv1"))
				else
					setText(arg2_20:Find("Text"), i18n("equip_enhancement_lvx", var0_20:getConfig("level") - 1))
				end

				onToggle(arg0_19, arg2_20, function(arg0_21)
					if arg0_21 then
						arg0_19.targetEquip = var0_20

						arg0_19:updateMaterials()
					end
				end, SFX_PANEL)
			end
		end)
		triggerToggle(arg0_19.rtToggles:GetChild(0), true)
	else
		arg0_19.targetEquip = nil

		arg0_19:updateMaterials()
	end
end

local function var1_0(arg0_22)
	local var0_22 = _.detect(arg0_22.sub, function(arg0_23)
		return arg0_23.type == AttributeType.Damage
	end)

	arg0_22.sub = {
		var0_22
	}
end

local function var2_0(arg0_24)
	local var0_24 = _.detect(arg0_24.sub, function(arg0_25)
		return arg0_25.type == AttributeType.Corrected
	end)

	arg0_24.sub = {
		var0_24
	}
end

function var0_0.updateAttrs(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg2_26:GetPropertiesInfo()

	for iter0_26 = 1, #var0_26.weapon.sub do
		var1_0(var0_26.weapon.sub[iter0_26])
	end

	var2_0(var0_26.equipInfo)

	var0_26.equipInfo.lock_open = true

	if arg3_26 then
		local var1_26 = arg3_26:GetPropertiesInfo()

		Equipment.InsertAttrsUpgrade(var0_26.attrs, var1_26.attrs)

		local var2_26 = arg2_26:GetSkill()
		local var3_26 = arg3_26:GetSkill()

		if checkExist(var2_26, {
			"name"
		}) ~= checkExist(var3_26, {
			"name"
		}) then
			local var4_26 = {
				lock_open = true,
				name = i18n("skill"),
				value = setColorStr(checkExist(var2_26, {
					"name"
				}) or i18n("equip_info_25"), "#FFDE00FF"),
				sub = {
					{
						name = i18n("equip_info_26"),
						value = setColorStr(checkExist(var3_26, {
							"name"
						}) or i18n("equip_info_25"), "#FFDE00FF")
					}
				}
			}

			table.insert(var0_26.attrs, var4_26)
		end

		if #var1_26.weapon.sub > #var0_26.weapon.sub then
			for iter1_26 = #var0_26.weapon.sub, #var1_26.weapon.sub do
				table.insert(var0_26.weapon.sub, {
					name = i18n("equip_info_25"),
					sub = {}
				})
			end
		end

		for iter2_26 = #var0_26.weapon.sub, 1, -1 do
			local var5_26 = var0_26.weapon.sub[iter2_26]
			local var6_26 = var1_26.weapon.sub[iter2_26]

			if var6_26 then
				var1_0(var1_26.weapon.sub[iter2_26])
			else
				var6_26 = {
					name = i18n("equip_info_25"),
					sub = {}
				}
			end

			if var5_26.name ~= var6_26.name then
				var5_26.sub = {
					{
						name = i18n("equip_info_27"),
						value = var6_26.name
					}
				}
			else
				Equipment.InsertAttrsUpgrade(var5_26.sub, var6_26.sub)
			end

			if #var5_26.sub == 0 then
				table.remove(var0_26.weapon.sub, iter2_26)

				if var1_26.weapon.sub[iter2_26] then
					table.remove(var1_26.weapon.sub, iter2_26)
				end
			end
		end

		var2_0(var1_26.equipInfo)
		Equipment.InsertAttrsUpgrade(var0_26.equipInfo.sub, var1_26.equipInfo.sub)
	end

	updateEquipUpgradeInfo(arg1_26, var0_26, arg0_26.contextData.shipVO)
end

function var0_0.updateMaterials(arg0_27)
	local var0_27 = tobool(arg0_27.targetEquip)

	setActive(arg0_27.materialsContain, var0_27)
	setActive(arg0_27.overLimit, not var0_27)
	setButtonEnabled(arg0_27.startBtn, var0_27)
	setTextAlpha(arg0_27.startBtn:Find("consume"), var0_27 and 1 or 0.5)

	local var1_27 = arg0_27.contextData.equipmentVO

	arg0_27:updateAttrs(arg0_27.equipmentPanel:Find("view/content"), var1_27, arg0_27.targetEquip)
	setText(arg0_27.rtLevel:Find("before"), i18n("equip_enhancement_lv"))
	setText(arg0_27.rtLevel:Find("before/number"), var1_27:getConfig("level") - 1)
	setText(arg0_27.rtLevel:Find("after"), i18n("equip_enhancement_lv"))
	setText(arg0_27.rtLevel:Find("after/number"), (arg0_27.targetEquip or var1_27):getConfig("level") - 1)
	setActive(arg0_27.rtLevel:Find("before"), var0_27)
	setActive(arg0_27.rtLevel:Find("Image"), var0_27)

	if not var0_27 then
		setText(arg0_27.startBtn:Find("consume"), 0)

		return
	end

	local var2_27 = underscore.to_array(var1_27:getConfig("trans_use_item") or {})
	local var3_27 = defaultValue(var1_27:getConfig("trans_use_gold"), 0)

	for iter0_27, iter1_27 in ipairs(arg0_27.nextEquips) do
		if iter1_27 == arg0_27.targetEquip then
			break
		else
			table.insertto(var2_27, iter1_27:getConfig("trans_use_item") or {})

			var3_27 = var3_27 + defaultValue(iter1_27:getConfig("trans_use_gold"), 0)
		end
	end

	local var4_27 = PlayerConst.MergeSameDrops(underscore.map(var2_27, function(arg0_28)
		local var0_28, var1_28 = unpack(arg0_28)

		return Drop.New({
			type = DROP_TYPE_ITEM,
			id = var0_28,
			count = var1_28
		})
	end))
	local var5_27 = true
	local var6_27
	local var7_27 = 0

	for iter2_27 = 1, 5 do
		local var8_27 = arg0_27.materialsContain:GetChild(iter2_27 - 1)
		local var9_27 = var4_27[iter2_27]

		setActive(findTF(var8_27, "off"), not var9_27)
		setActive(findTF(var8_27, "equiptpl"), var9_27)

		if var9_27 then
			local var10_27 = findTF(var8_27, "equiptpl")

			updateItem(var10_27, var9_27:getSubClass())
			onButton(arg0_27, var10_27, function()
				arg0_27:emit(BaseUI.ON_DROP, var9_27)
			end, SFX_PANEL)

			local var11_27 = var9_27:getOwnedCount()
			local var12_27 = var10_27:Find("icon_bg/count")

			if var11_27 < var9_27.count then
				setText(var12_27, setColorStr(var11_27, COLOR_RED) .. "/" .. var9_27.count)

				var5_27 = false
				var6_27 = var9_27.id
			else
				setText(var12_27, var11_27 .. "/" .. var9_27.count)
			end

			setActive(var12_27, true)
			onButton(arg0_27, var10_27:Find("click"), function()
				setActive(var10_27:Find("click"), false)

				var7_27 = var7_27 - 1
			end, SFX_PANEL)

			local var13_27 = var9_27:getDropRarity() > 3

			setActive(var10_27:Find("click"), var13_27)

			var7_27 = var7_27 + (var13_27 and 1 or 0)
		end
	end

	local var14_27 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResGold,
		count = var3_27
	})
	local var15_27 = var14_27:getOwnedCount()

	if var15_27 < var14_27.count then
		setText(arg0_27.startBtn:Find("consume"), setColorStr(var3_27, COLOR_RED))
	else
		setText(arg0_27.startBtn:Find("consume"), var3_27)
	end

	onButton(arg0_27, arg0_27.startBtn, function()
		if not var5_27 then
			if not ItemTipPanel.ShowItemTipbyID(var6_27) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipUpgradeLayer2_noMaterail"))
			end

			return
		end

		if var7_27 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_costcheck_error"))

			return
		end

		if var15_27 < var3_27 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var3_27 - var15_27,
					var3_27
				}
			})

			return
		end

		arg0_27:emit(EquipUpgradeMediator.EQUIPMENT_UPGRDE, arg0_27.targetEquip, var4_27, var3_27)
	end, SFX_UI_DOCKYARD_REINFORCE)
end

function var0_0.upgradeFinish(arg0_32, arg1_32, arg2_32)
	setActive(arg0_32.mainPanel, false)
	setActive(arg0_32.finishPanel, true)
	onButton(arg0_32, arg0_32.finishPanel:Find("bg"), function()
		setActive(arg0_32.mainPanel, true)
		setActive(arg0_32.finishPanel, false)
	end, SFX_CANCEL)
	changeToScrollText(arg0_32.finishPanel:Find("frame/equipment_panel/name_container"), arg2_32:getConfig("name"))
	setActive(findTF(arg0_32.finishPanel, "frame/equipment_panel/unique"), arg2_32:isUnique())

	local var0_32 = arg0_32.finishPanel:Find("frame/equipment_panel/equiptpl")

	updateEquipment(var0_32, arg2_32)
	arg0_32:updateAttrs(arg0_32.finishPanel:Find("frame/equipment_panel/view/content"), arg1_32, arg2_32)
end

function var0_0.willExit(arg0_34)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_34._tf)
end

return var0_0
