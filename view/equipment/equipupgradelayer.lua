local var0_0 = class("EquipUpgradeLayer", import("..base.BaseUI"))

var0_0.CHAT_DURATION_TIME = 0.3

function var0_0.getUIName(arg0_1)
	return "EquipUpgradeUI"
end

function var0_0.setItems(arg0_2, arg1_2)
	arg0_2.itemVOs = arg1_2
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_3.mainPanel = arg0_3:findTF("main")
	arg0_3.finishPanel = arg0_3:findTF("finish_panel")

	setActive(arg0_3.mainPanel, true)
	setActive(arg0_3.finishPanel, false)

	arg0_3.equipmentList = arg0_3:findTF("panel/equipment_list", arg0_3.mainPanel)
	arg0_3.equipmentContain = arg0_3:findTF("equipments", arg0_3.equipmentList)
	arg0_3.equipmentTpl = arg0_3:getTpl("equiptpl", arg0_3.equipmentContain)

	setActive(arg0_3.equipmentList, false)

	arg0_3.equipmentPanel = arg0_3:findTF("panel/equipment_panel", arg0_3.mainPanel)
	arg0_3.materialPanel = arg0_3:findTF("panel/material_panel", arg0_3.mainPanel)
	arg0_3.startBtn = arg0_3:findTF("start_btn", arg0_3.materialPanel)
	arg0_3.overLimit = arg0_3:findTF("materials/limit", arg0_3.materialPanel)

	setText(arg0_3:findTF("text", arg0_3.overLimit), i18n("equipment_upgrade_overlimit"))

	arg0_3.materialsContain = arg0_3:findTF("materials/materials", arg0_3.materialPanel)
	arg0_3.uiMain = pg.UIMgr.GetInstance().UIMain
	arg0_3.Overlay = pg.UIMgr.GetInstance().OverlayMain
end

function var0_0.updateRes(arg0_4, arg1_4)
	arg0_4.playerVO = arg1_4
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("bg"), function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	arg0_5:updateAll()
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
	local var0_10 = true
	local var1_10 = arg1_10:getConfig("trans_use_item")

	if not var1_10 then
		return false
	end

	for iter0_10 = 1, #var1_10 do
		local var2_10 = var1_10[iter0_10][1]

		if defaultValue(arg0_10.itemVOs[var2_10], {
			count = 0
		}).count < var1_10[iter0_10][2] then
			var0_10 = false
		end
	end

	return var0_10
end

function var0_0.updateEquipment(arg0_11)
	local var0_11 = arg0_11.contextData.equipmentVO

	arg0_11.contextData.equipmentId = var0_11.id

	local var1_11 = var0_11:getConfig("next") > 0 and var0_11:MigrateTo(var0_11:getConfig("next")) or nil

	arg0_11:updateAttrs(arg0_11.equipmentPanel:Find("view/content"), var0_11, var1_11)
	changeToScrollText(arg0_11.equipmentPanel:Find("name_container"), var0_11:getConfig("name"))
	setActive(findTF(arg0_11.equipmentPanel, "unique"), var0_11:isUnique())

	local var2_11 = arg0_11:findTF("equiptpl", arg0_11.equipmentPanel)

	updateEquipment(var2_11, var0_11)
end

local function var1_0(arg0_12)
	local var0_12 = _.detect(arg0_12.sub, function(arg0_13)
		return arg0_13.type == AttributeType.Damage
	end)

	arg0_12.sub = {
		var0_12
	}
end

local function var2_0(arg0_14)
	local var0_14 = _.detect(arg0_14.sub, function(arg0_15)
		return arg0_15.type == AttributeType.Corrected
	end)

	arg0_14.sub = {
		var0_14
	}
end

function var0_0.updateAttrs(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg2_16:GetPropertiesInfo()

	for iter0_16 = 1, #var0_16.weapon.sub do
		var1_0(var0_16.weapon.sub[iter0_16])
	end

	var2_0(var0_16.equipInfo)

	var0_16.equipInfo.lock_open = true

	if arg3_16 then
		local var1_16 = arg3_16:GetPropertiesInfo()

		Equipment.InsertAttrsUpgrade(var0_16.attrs, var1_16.attrs)

		local var2_16 = arg2_16:GetSkill()
		local var3_16 = arg3_16:GetSkill()

		if checkExist(var2_16, {
			"name"
		}) ~= checkExist(var3_16, {
			"name"
		}) then
			local var4_16 = {
				lock_open = true,
				name = i18n("skill"),
				value = setColorStr(checkExist(var2_16, {
					"name"
				}) or i18n("equip_info_25"), "#FFDE00FF"),
				sub = {
					{
						name = i18n("equip_info_26"),
						value = setColorStr(checkExist(var3_16, {
							"name"
						}) or i18n("equip_info_25"), "#FFDE00FF")
					}
				}
			}

			table.insert(var0_16.attrs, var4_16)
		end

		if #var1_16.weapon.sub > #var0_16.weapon.sub then
			for iter1_16 = #var0_16.weapon.sub, #var1_16.weapon.sub do
				table.insert(var0_16.weapon.sub, {
					name = i18n("equip_info_25"),
					sub = {}
				})
			end
		end

		for iter2_16 = #var0_16.weapon.sub, 1, -1 do
			local var5_16 = var0_16.weapon.sub[iter2_16]
			local var6_16 = var1_16.weapon.sub[iter2_16]

			if var6_16 then
				var1_0(var1_16.weapon.sub[iter2_16])
			else
				var6_16 = {
					name = i18n("equip_info_25"),
					sub = {}
				}
			end

			if var5_16.name ~= var6_16.name then
				var5_16.sub = {
					{
						name = i18n("equip_info_27"),
						value = var6_16.name
					}
				}
			else
				Equipment.InsertAttrsUpgrade(var5_16.sub, var6_16.sub)
			end

			if #var5_16.sub == 0 then
				table.remove(var0_16.weapon.sub, iter2_16)

				if var1_16.weapon.sub[iter2_16] then
					table.remove(var1_16.weapon.sub, iter2_16)
				end
			end
		end

		var2_0(var1_16.equipInfo)
		Equipment.InsertAttrsUpgrade(var0_16.equipInfo.sub, var1_16.equipInfo.sub)
	end

	updateEquipUpgradeInfo(arg1_16, var0_16, arg0_16.contextData.shipVO)
end

function var0_0.updateMaterials(arg0_17)
	local var0_17 = true
	local var1_17 = arg0_17.contextData.equipmentVO
	local var2_17 = var1_17:getConfig("trans_use_item")
	local var3_17 = var1_17:getConfig("trans_use_gold")
	local var4_17 = defaultValue(var2_17, {})
	local var5_17
	local var6_17 = 0

	for iter0_17 = 1, 3 do
		local var7_17 = arg0_17.materialsContain:GetChild(iter0_17 - 1)

		setActive(findTF(var7_17, "off"), not var4_17[iter0_17])
		setActive(findTF(var7_17, "equiptpl"), var4_17[iter0_17])

		if var4_17[iter0_17] then
			local var8_17 = var4_17[iter0_17][1]
			local var9_17 = findTF(var7_17, "equiptpl")

			updateItem(var9_17, Item.New({
				id = var8_17
			}))
			onButton(arg0_17, var9_17, function()
				arg0_17:emit(EquipUpgradeMediator.ON_ITEM, var8_17)
			end, SFX_PANEL)

			local var10_17 = defaultValue(arg0_17.itemVOs[var8_17], {
				count = 0
			})
			local var11_17 = var10_17.count .. "/" .. var4_17[iter0_17][2]

			if var10_17.count < var4_17[iter0_17][2] then
				var11_17 = setColorStr(var10_17.count, COLOR_RED) .. "/" .. var4_17[iter0_17][2]
				var0_17 = false
				var5_17 = var4_17[iter0_17]
			end

			local var12_17 = findTF(var9_17, "icon_bg/count")

			setActive(var12_17, true)
			setText(var12_17, var11_17)
			onButton(arg0_17, var9_17:Find("click"), function()
				setActive(var9_17:Find("click"), false)

				var6_17 = var6_17 - 1
			end, SFX_PANEL)
			setActive(var9_17:Find("click"), var1_17:getConfig("level") > 10)

			var6_17 = var6_17 + (var1_17:getConfig("level") > 10 and 1 or 0)
		end
	end

	setText(arg0_17:findTF("cost/consume", arg0_17.materialPanel), var3_17)
	setActive(arg0_17.startBtn, var4_17)

	local var13_17 = Equipment.canUpgrade(var1_17.configId)

	setActive(arg0_17.materialsContain, var13_17)
	setActive(arg0_17.overLimit, not var13_17)
	onButton(arg0_17, arg0_17.startBtn, function()
		if not var0_17 then
			if not ItemTipPanel.ShowItemTipbyID(var5_17[1]) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipUpgradeLayer2_noMaterail"))
			end

			return
		end

		if var6_17 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_costcheck_error"))

			return
		end

		if arg0_17.playerVO.gold < var3_17 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var3_17 - arg0_17.playerVO.gold,
					var3_17
				}
			})

			return
		end

		arg0_17:emit(EquipUpgradeMediator.EQUIPMENT_UPGRDE)
	end, SFX_UI_DOCKYARD_REINFORCE)
	setButtonEnabled(arg0_17.startBtn, var13_17)
end

function var0_0.upgradeFinish(arg0_21, arg1_21, arg2_21)
	setActive(arg0_21.mainPanel, false)
	setActive(arg0_21.finishPanel, true)
	onButton(arg0_21, arg0_21.finishPanel:Find("bg"), function()
		setActive(arg0_21.mainPanel, true)
		setActive(arg0_21.finishPanel, false)
	end, SFX_CANCEL)
	changeToScrollText(arg0_21.finishPanel:Find("frame/equipment_panel/name_container"), arg2_21:getConfig("name"))
	setActive(findTF(arg0_21.finishPanel, "frame/equipment_panel/unique"), arg2_21:isUnique())

	local var0_21 = arg0_21:findTF("frame/equipment_panel/equiptpl", arg0_21.finishPanel)

	updateEquipment(var0_21, arg2_21)
	arg0_21:updateAttrs(arg0_21:findTF("frame/equipment_panel/view/content", arg0_21.finishPanel), arg1_21, arg2_21)
end

function var0_0.willExit(arg0_23)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_23._tf)
end

return var0_0
