local var0_0 = class("EquipUpgradeLayer", import("..base.BaseUI"))

var0_0.CHAT_DURATION_TIME = 0.3

function var0_0.getUIName(arg0_1)
	return "EquipUpgradeUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype",
		"ui/iconcolorful"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, {
		staticBlur = true
	})

	arg0_3.mainPanel = arg0_3._tf:Find("main")
	arg0_3.finishPanel = arg0_3._tf:Find("finish_panel")

	setActive(arg0_3.mainPanel, true)
	setActive(arg0_3.finishPanel, false)

	arg0_3.equipmentList = arg0_3.mainPanel:Find("panel/equipment_list")
	arg0_3.equipmentContain = arg0_3.equipmentList:Find("equipments")
	arg0_3.equipmentTpl = arg0_3:getTpl("equiptpl", arg0_3.equipmentContain)

	setActive(arg0_3.equipmentList, false)

	arg0_3.equipmentPanel = arg0_3.mainPanel:Find("panel/equipment_panel")
	arg0_3.materialPanel = arg0_3.mainPanel:Find("panel/material_panel")
	arg0_3.startBtn = arg0_3.materialPanel:Find("start_btn")
	arg0_3.overLimit = arg0_3.materialPanel:Find("materials/limit")

	setText(arg0_3.overLimit:Find("text"), i18n("equipment_upgrade_overlimit"))

	arg0_3.materialsContain = arg0_3.materialPanel:Find("materials/materials")

	setText(arg0_3.rtTogglesEmpty:Find("Text"), i18n("equip_enhancement_finish"))
	setText(arg0_3.rtPanelTitle, i18n("equip_enhancement_required"))
	setText(arg0_3.rtTitle, i18n("equip_enhancement_title"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.btnCancel, function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	arg0_4:updateAll()
end

function var0_0.updateAll(arg0_7)
	setActive(arg0_7.equipmentList, arg0_7.contextData.shipVO)

	if arg0_7.contextData.shipVO then
		arg0_7:displayEquipments()

		if arg0_7.contextData.pos then
			triggerButton(arg0_7.equipmentTFs[arg0_7.contextData.pos])
		else
			triggerButton(arg0_7.equipmentContain:GetChild(0))
		end
	else
		arg0_7:updateEquipment()
		arg0_7:updateMaterials()
	end
end

function var0_0.displayEquipments(arg0_8)
	arg0_8.equipmentTFs = {}

	removeAllChildren(arg0_8.equipmentContain)

	local var0_8 = arg0_8.contextData.shipVO

	for iter0_8, iter1_8 in ipairs(var0_8.equipments) do
		if iter1_8 then
			local var1_8 = cloneTplTo(arg0_8.equipmentTpl, arg0_8.equipmentContain)

			updateEquipment(var1_8, iter1_8)

			local var2_8 = var1_8:Find("tip")

			setActive(var2_8, false)

			if arg0_8:isMaterialEnough(iter1_8) and iter1_8:getConfig("next") ~= 0 then
				setActive(var2_8, true)
				blinkAni(var2_8, 0.5)
			end

			onButton(arg0_8, var1_8, function()
				local var0_9 = arg0_8.contextData.pos

				if var0_9 then
					setActive(arg0_8.equipmentTFs[var0_9]:Find("selected"), false)
					setActive(arg0_8.equipmentTFs[var0_9]:Find("tip"), arg0_8:isMaterialEnough(var0_8:getEquip(var0_9)) and var0_8:getEquip(var0_9):getConfig("next") ~= 0)
				end

				arg0_8.contextData.pos = iter0_8
				arg0_8.contextData.equipmentId = iter1_8.id
				arg0_8.contextData.equipmentVO = iter1_8

				local var1_9 = arg0_8.contextData.pos

				setActive(arg0_8.equipmentTFs[var1_9]:Find("selected"), true)
				setActive(arg0_8.equipmentTFs[var1_9]:Find("tip"), false)
				arg0_8:updateEquipment()
				arg0_8:updateMaterials()
			end, SFX_PANEL)

			arg0_8.equipmentTFs[iter0_8] = var1_8
		end
	end
end

function var0_0.isMaterialEnough(arg0_10, arg1_10)
	local var0_10 = arg1_10:getConfig("trans_use_item")

	if not var0_10 then
		return false
	end

	for iter0_10, iter1_10 in ipairs(underscore.map(var0_10, function(arg0_11)
		local var0_11, var1_11 = unpack(arg0_11)

		return Drop.New({
			type = DROP_TYPE_ITEM,
			id = var0_11,
			count = var1_11
		})
	end)) do
		if iter1_10.count > iter1_10:getOwnedCount() then
			return false
		end
	end

	return true
end

function var0_0.updateEquipment(arg0_12)
	local var0_12 = arg0_12.contextData.equipmentVO

	arg0_12.contextData.equipmentId = var0_12.id

	changeToScrollText(arg0_12.equipmentPanel:Find("name_container"), var0_12:getConfig("name"))
	setActive(findTF(arg0_12.equipmentPanel, "unique"), var0_12:isUnique())
	updateEquipment(arg0_12.equipmentPanel:Find("equiptpl"), var0_12)

	arg0_12.nextEquips = {}

	while var0_12:getConfig("next") > 0 do
		var0_12 = var0_12:MigrateTo(var0_12:getConfig("next"))

		table.insert(arg0_12.nextEquips, var0_12)
	end

	if #arg0_12.nextEquips == 0 then
		arg0_12.toggleEquips = nil
	else
		arg0_12.toggleEquips = {
			arg0_12.nextEquips[1]
		}

		if #arg0_12.nextEquips > 0 then
			local var1_12 = arg0_12.nextEquips[#arg0_12.nextEquips]
			local var2_12 = var1_12:getConfig("level")
			local var3_12 = switch(var1_12:getConfig("level") - 1, {
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

			for iter0_12, iter1_12 in ipairs(var3_12) do
				if #arg0_12.nextEquips > var2_12 - 1 - iter1_12 then
					table.insert(arg0_12.toggleEquips, arg0_12.nextEquips[#arg0_12.nextEquips - (var2_12 - 1 - iter1_12)])
				end
			end
		end
	end

	arg0_12:updateToggles()
end

function var0_0.updateToggles(arg0_20)
	setActive(arg0_20.rtToggles, tobool(arg0_20.toggleEquips))
	setActive(arg0_20.rtTogglesEmpty, not tobool(arg0_20.toggleEquips))

	if arg0_20.toggleEquips then
		UIItemList.StaticAlign(arg0_20.rtToggles, arg0_20.rtToggleTpl, #arg0_20.toggleEquips, function(arg0_21, arg1_21, arg2_21)
			arg1_21 = arg1_21 + 1

			if arg0_21 == UIItemList.EventUpdate then
				local var0_21 = arg0_20.toggleEquips[arg1_21]

				if arg1_21 == 1 then
					setText(arg2_21:Find("Text"), i18n("equip_enhancement_lv1"))
				else
					setText(arg2_21:Find("Text"), i18n("equip_enhancement_lvx", var0_21:getConfig("level") - 1))
				end

				onToggle(arg0_20, arg2_21, function(arg0_22)
					if arg0_22 then
						arg0_20.targetEquip = var0_21

						arg0_20:updateMaterials()
					end
				end, SFX_PANEL)
			end
		end)
		triggerToggle(arg0_20.rtToggles:GetChild(0), true)
	else
		arg0_20.targetEquip = nil

		arg0_20:updateMaterials()
	end
end

local function var1_0(arg0_23)
	local var0_23 = _.detect(arg0_23.sub, function(arg0_24)
		return arg0_24.type == AttributeType.Damage
	end)

	arg0_23.sub = {
		var0_23
	}
end

local function var2_0(arg0_25)
	local var0_25 = _.detect(arg0_25.sub, function(arg0_26)
		return arg0_26.type == AttributeType.Corrected
	end)

	arg0_25.sub = {
		var0_25
	}
end

function var0_0.updateAttrs(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg2_27:GetPropertiesInfo()

	for iter0_27 = 1, #var0_27.weapon.sub do
		var1_0(var0_27.weapon.sub[iter0_27])
	end

	var2_0(var0_27.equipInfo)

	var0_27.equipInfo.lock_open = true

	if arg3_27 then
		local var1_27 = arg3_27:GetPropertiesInfo()

		Equipment.InsertAttrsUpgrade(var0_27.attrs, var1_27.attrs)

		local var2_27 = arg2_27:GetSkill()
		local var3_27 = arg3_27:GetSkill()

		if checkExist(var2_27, {
			"name"
		}) ~= checkExist(var3_27, {
			"name"
		}) then
			local var4_27 = {
				lock_open = true,
				name = i18n("skill"),
				value = setColorStr(checkExist(var2_27, {
					"name"
				}) or i18n("equip_info_25"), "#FFDE00FF"),
				sub = {
					{
						name = i18n("equip_info_26"),
						value = setColorStr(checkExist(var3_27, {
							"name"
						}) or i18n("equip_info_25"), "#FFDE00FF")
					}
				}
			}

			table.insert(var0_27.attrs, var4_27)
		end

		if #var1_27.weapon.sub > #var0_27.weapon.sub then
			for iter1_27 = #var0_27.weapon.sub, #var1_27.weapon.sub do
				table.insert(var0_27.weapon.sub, {
					name = i18n("equip_info_25"),
					sub = {}
				})
			end
		end

		for iter2_27 = #var0_27.weapon.sub, 1, -1 do
			local var5_27 = var0_27.weapon.sub[iter2_27]
			local var6_27 = var1_27.weapon.sub[iter2_27]

			if var6_27 then
				var1_0(var1_27.weapon.sub[iter2_27])
			else
				var6_27 = {
					name = i18n("equip_info_25"),
					sub = {}
				}
			end

			if var5_27.name ~= var6_27.name then
				var5_27.sub = {
					{
						name = i18n("equip_info_27"),
						value = var6_27.name
					}
				}
			else
				Equipment.InsertAttrsUpgrade(var5_27.sub, var6_27.sub)
			end

			if #var5_27.sub == 0 then
				table.remove(var0_27.weapon.sub, iter2_27)

				if var1_27.weapon.sub[iter2_27] then
					table.remove(var1_27.weapon.sub, iter2_27)
				end
			end
		end

		var2_0(var1_27.equipInfo)
		Equipment.InsertAttrsUpgrade(var0_27.equipInfo.sub, var1_27.equipInfo.sub)
	end

	updateEquipUpgradeInfo(arg1_27, var0_27, arg0_27.contextData.shipVO)
end

function var0_0.updateMaterials(arg0_28)
	local var0_28 = tobool(arg0_28.targetEquip)

	setActive(arg0_28.materialsContain, var0_28)
	setActive(arg0_28.overLimit, not var0_28)
	setButtonEnabled(arg0_28.startBtn, var0_28)
	setTextAlpha(arg0_28.startBtn:Find("consume"), var0_28 and 1 or 0.5)

	local var1_28 = arg0_28.contextData.equipmentVO

	arg0_28:updateAttrs(arg0_28.equipmentPanel:Find("view/content"), var1_28, arg0_28.targetEquip)
	setText(arg0_28.rtLevel:Find("before"), i18n("equip_enhancement_lv"))
	setText(arg0_28.rtLevel:Find("before/number"), var1_28:getConfig("level") - 1)
	setText(arg0_28.rtLevel:Find("after"), i18n("equip_enhancement_lv"))
	setText(arg0_28.rtLevel:Find("after/number"), (arg0_28.targetEquip or var1_28):getConfig("level") - 1)
	setActive(arg0_28.rtLevel:Find("before"), var0_28)
	setActive(arg0_28.rtLevel:Find("Image"), var0_28)

	if not var0_28 then
		setText(arg0_28.startBtn:Find("consume"), 0)

		return
	end

	local var2_28 = underscore.to_array(var1_28:getConfig("trans_use_item") or {})
	local var3_28 = defaultValue(var1_28:getConfig("trans_use_gold"), 0)

	for iter0_28, iter1_28 in ipairs(arg0_28.nextEquips) do
		if iter1_28 == arg0_28.targetEquip then
			break
		else
			table.insertto(var2_28, iter1_28:getConfig("trans_use_item") or {})

			var3_28 = var3_28 + defaultValue(iter1_28:getConfig("trans_use_gold"), 0)
		end
	end

	local var4_28 = PlayerConst.MergeSameDrops(underscore.map(var2_28, function(arg0_29)
		local var0_29, var1_29 = unpack(arg0_29)

		return Drop.New({
			type = DROP_TYPE_ITEM,
			id = var0_29,
			count = var1_29
		})
	end))
	local var5_28 = true
	local var6_28
	local var7_28 = 0

	for iter2_28 = 1, 5 do
		local var8_28 = arg0_28.materialsContain:GetChild(iter2_28 - 1)
		local var9_28 = var4_28[iter2_28]

		setActive(findTF(var8_28, "off"), not var9_28)
		setActive(findTF(var8_28, "equiptpl"), var9_28)

		if var9_28 then
			local var10_28 = findTF(var8_28, "equiptpl")

			updateItem(var10_28, var9_28:getSubClass())
			onButton(arg0_28, var10_28, function()
				arg0_28:emit(BaseUI.ON_DROP, var9_28)
			end, SFX_PANEL)

			local var11_28 = var9_28:getOwnedCount()
			local var12_28 = var10_28:Find("icon_bg/count")

			if var11_28 < var9_28.count then
				setText(var12_28, setColorStr(var11_28, COLOR_RED) .. "/" .. var9_28.count)

				var5_28 = false
				var6_28 = var9_28.id
			else
				setText(var12_28, var11_28 .. "/" .. var9_28.count)
			end

			setActive(var12_28, true)
			onButton(arg0_28, var10_28:Find("click"), function()
				setActive(var10_28:Find("click"), false)

				var7_28 = var7_28 - 1
			end, SFX_PANEL)

			local var13_28 = var9_28:getDropRarity() > 3

			setActive(var10_28:Find("click"), var13_28)

			var7_28 = var7_28 + (var13_28 and 1 or 0)
		end
	end

	local var14_28 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = PlayerConst.ResGold,
		count = var3_28
	})
	local var15_28 = var14_28:getOwnedCount()

	if var15_28 < var14_28.count then
		setText(arg0_28.startBtn:Find("consume"), setColorStr(var3_28, COLOR_RED))
	else
		setText(arg0_28.startBtn:Find("consume"), var3_28)
	end

	onButton(arg0_28, arg0_28.startBtn, function()
		if not var5_28 then
			if not ItemTipPanel.ShowItemTipbyID(var6_28) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipUpgradeLayer2_noMaterail"))
			end

			return
		end

		if var7_28 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_costcheck_error"))

			return
		end

		if var15_28 < var3_28 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var3_28 - var15_28,
					var3_28
				}
			})

			return
		end

		arg0_28:emit(EquipUpgradeMediator.EQUIPMENT_UPGRDE, arg0_28.targetEquip, var4_28, var3_28)
	end, SFX_UI_DOCKYARD_REINFORCE)
end

function var0_0.upgradeFinish(arg0_33, arg1_33, arg2_33)
	setActive(arg0_33.mainPanel, false)
	setActive(arg0_33.finishPanel, true)
	onButton(arg0_33, arg0_33.finishPanel:Find("bg"), function()
		setActive(arg0_33.mainPanel, true)
		setActive(arg0_33.finishPanel, false)
	end, SFX_CANCEL)
	changeToScrollText(arg0_33.finishPanel:Find("frame/equipment_panel/name_container"), arg2_33:getConfig("name"))
	setActive(findTF(arg0_33.finishPanel, "frame/equipment_panel/unique"), arg2_33:isUnique())

	local var0_33 = arg0_33.finishPanel:Find("frame/equipment_panel/equiptpl")

	updateEquipment(var0_33, arg2_33)
	arg0_33:updateAttrs(arg0_33.finishPanel:Find("frame/equipment_panel/view/content"), arg1_33, arg2_33)
end

function var0_0.willExit(arg0_35)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_35._tf)
end

return var0_0
