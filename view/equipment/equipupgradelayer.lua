local var0 = class("EquipUpgradeLayer", import("..base.BaseUI"))

var0.CHAT_DURATION_TIME = 0.3

function var0.getUIName(arg0)
	return "EquipUpgradeUI"
end

function var0.setItems(arg0, arg1)
	arg0.itemVOs = arg1
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0.mainPanel = arg0:findTF("main")
	arg0.finishPanel = arg0:findTF("finish_panel")

	setActive(arg0.mainPanel, true)
	setActive(arg0.finishPanel, false)

	arg0.equipmentList = arg0:findTF("panel/equipment_list", arg0.mainPanel)
	arg0.equipmentContain = arg0:findTF("equipments", arg0.equipmentList)
	arg0.equipmentTpl = arg0:getTpl("equiptpl", arg0.equipmentContain)

	setActive(arg0.equipmentList, false)

	arg0.equipmentPanel = arg0:findTF("panel/equipment_panel", arg0.mainPanel)
	arg0.materialPanel = arg0:findTF("panel/material_panel", arg0.mainPanel)
	arg0.startBtn = arg0:findTF("start_btn", arg0.materialPanel)
	arg0.overLimit = arg0:findTF("materials/limit", arg0.materialPanel)

	setText(arg0:findTF("text", arg0.overLimit), i18n("equipment_upgrade_overlimit"))

	arg0.materialsContain = arg0:findTF("materials/materials", arg0.materialPanel)
	arg0.uiMain = pg.UIMgr.GetInstance().UIMain
	arg0.Overlay = pg.UIMgr.GetInstance().OverlayMain
end

function var0.updateRes(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	arg0:updateAll()
end

function var0.updateAll(arg0)
	setActive(arg0.equipmentList, arg0.contextData.shipVO)

	if arg0.contextData.shipVO then
		arg0:displayEquipments()

		if arg0.contextData.pos then
			triggerButton(arg0.equipmentTFs[arg0.contextData.pos])
		else
			triggerButton(arg0.equipmentContain:GetChild(0))
		end
	else
		arg0:updateEquipment()
		arg0:updateMaterials()
	end
end

function var0.displayEquipments(arg0)
	arg0.equipmentTFs = {}

	removeAllChildren(arg0.equipmentContain)

	local var0 = arg0.contextData.shipVO

	for iter0, iter1 in ipairs(var0.equipments) do
		if iter1 then
			local var1 = cloneTplTo(arg0.equipmentTpl, arg0.equipmentContain)

			updateEquipment(var1, iter1)

			local var2 = var1:Find("tip")

			setActive(var2, false)

			if arg0:isMaterialEnough(iter1) and iter1:getConfig("next") ~= 0 then
				setActive(var2, true)
				blinkAni(var2, 0.5)
			end

			onButton(arg0, var1, function()
				local var0 = arg0.contextData.pos

				if var0 then
					setActive(arg0.equipmentTFs[var0]:Find("selected"), false)
					setActive(arg0.equipmentTFs[var0]:Find("tip"), arg0:isMaterialEnough(var0:getEquip(var0)) and var0:getEquip(var0):getConfig("next") ~= 0)
				end

				arg0.contextData.pos = iter0
				arg0.contextData.equipmentId = iter1.id
				arg0.contextData.equipmentVO = iter1

				local var1 = arg0.contextData.pos

				setActive(arg0.equipmentTFs[var1]:Find("selected"), true)
				setActive(arg0.equipmentTFs[var1]:Find("tip"), false)
				arg0:updateEquipment()
				arg0:updateMaterials()
			end, SFX_PANEL)

			arg0.equipmentTFs[iter0] = var1
		end
	end
end

function var0.isMaterialEnough(arg0, arg1)
	local var0 = true
	local var1 = arg1:getConfig("trans_use_item")

	if not var1 then
		return false
	end

	for iter0 = 1, #var1 do
		local var2 = var1[iter0][1]

		if defaultValue(arg0.itemVOs[var2], {
			count = 0
		}).count < var1[iter0][2] then
			var0 = false
		end
	end

	return var0
end

function var0.updateEquipment(arg0)
	local var0 = arg0.contextData.equipmentVO

	arg0.contextData.equipmentId = var0.id

	local var1 = var0:getConfig("next") > 0 and var0:MigrateTo(var0:getConfig("next")) or nil

	arg0:updateAttrs(arg0.equipmentPanel:Find("view/content"), var0, var1)
	changeToScrollText(arg0.equipmentPanel:Find("name_container"), var0:getConfig("name"))
	setActive(findTF(arg0.equipmentPanel, "unique"), var0:isUnique())

	local var2 = arg0:findTF("equiptpl", arg0.equipmentPanel)

	updateEquipment(var2, var0)
end

local function var1(arg0)
	local var0 = _.detect(arg0.sub, function(arg0)
		return arg0.type == AttributeType.Damage
	end)

	arg0.sub = {
		var0
	}
end

local function var2(arg0)
	local var0 = _.detect(arg0.sub, function(arg0)
		return arg0.type == AttributeType.Corrected
	end)

	arg0.sub = {
		var0
	}
end

function var0.updateAttrs(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetPropertiesInfo()

	for iter0 = 1, #var0.weapon.sub do
		var1(var0.weapon.sub[iter0])
	end

	var2(var0.equipInfo)

	var0.equipInfo.lock_open = true

	if arg3 then
		local var1 = arg3:GetPropertiesInfo()

		Equipment.InsertAttrsUpgrade(var0.attrs, var1.attrs)

		local var2 = arg2:GetSkill()
		local var3 = arg3:GetSkill()

		if checkExist(var2, {
			"name"
		}) ~= checkExist(var3, {
			"name"
		}) then
			local var4 = {
				lock_open = true,
				name = i18n("skill"),
				value = setColorStr(checkExist(var2, {
					"name"
				}) or i18n("equip_info_25"), "#FFDE00FF"),
				sub = {
					{
						name = i18n("equip_info_26"),
						value = setColorStr(checkExist(var3, {
							"name"
						}) or i18n("equip_info_25"), "#FFDE00FF")
					}
				}
			}

			table.insert(var0.attrs, var4)
		end

		if #var1.weapon.sub > #var0.weapon.sub then
			for iter1 = #var0.weapon.sub, #var1.weapon.sub do
				table.insert(var0.weapon.sub, {
					name = i18n("equip_info_25"),
					sub = {}
				})
			end
		end

		for iter2 = #var0.weapon.sub, 1, -1 do
			local var5 = var0.weapon.sub[iter2]
			local var6 = var1.weapon.sub[iter2]

			if var6 then
				var1(var1.weapon.sub[iter2])
			else
				var6 = {
					name = i18n("equip_info_25"),
					sub = {}
				}
			end

			if var5.name ~= var6.name then
				var5.sub = {
					{
						name = i18n("equip_info_27"),
						value = var6.name
					}
				}
			else
				Equipment.InsertAttrsUpgrade(var5.sub, var6.sub)
			end

			if #var5.sub == 0 then
				table.remove(var0.weapon.sub, iter2)

				if var1.weapon.sub[iter2] then
					table.remove(var1.weapon.sub, iter2)
				end
			end
		end

		var2(var1.equipInfo)
		Equipment.InsertAttrsUpgrade(var0.equipInfo.sub, var1.equipInfo.sub)
	end

	updateEquipUpgradeInfo(arg1, var0, arg0.contextData.shipVO)
end

function var0.updateMaterials(arg0)
	local var0 = true
	local var1 = arg0.contextData.equipmentVO
	local var2 = var1:getConfig("trans_use_item")
	local var3 = var1:getConfig("trans_use_gold")
	local var4 = defaultValue(var2, {})
	local var5
	local var6 = 0

	for iter0 = 1, 3 do
		local var7 = arg0.materialsContain:GetChild(iter0 - 1)

		setActive(findTF(var7, "off"), not var4[iter0])
		setActive(findTF(var7, "equiptpl"), var4[iter0])

		if var4[iter0] then
			local var8 = var4[iter0][1]
			local var9 = findTF(var7, "equiptpl")

			updateItem(var9, Item.New({
				id = var8
			}))
			onButton(arg0, var9, function()
				arg0:emit(EquipUpgradeMediator.ON_ITEM, var8)
			end, SFX_PANEL)

			local var10 = defaultValue(arg0.itemVOs[var8], {
				count = 0
			})
			local var11 = var10.count .. "/" .. var4[iter0][2]

			if var10.count < var4[iter0][2] then
				var11 = setColorStr(var10.count, COLOR_RED) .. "/" .. var4[iter0][2]
				var0 = false
				var5 = var4[iter0]
			end

			local var12 = findTF(var9, "icon_bg/count")

			setActive(var12, true)
			setText(var12, var11)
			onButton(arg0, var9:Find("click"), function()
				setActive(var9:Find("click"), false)

				var6 = var6 - 1
			end, SFX_PANEL)
			setActive(var9:Find("click"), var1:getConfig("level") > 10)

			var6 = var6 + (var1:getConfig("level") > 10 and 1 or 0)
		end
	end

	setText(arg0:findTF("cost/consume", arg0.materialPanel), var3)
	setActive(arg0.startBtn, var4)

	local var13 = Equipment.canUpgrade(var1.configId)

	setActive(arg0.materialsContain, var13)
	setActive(arg0.overLimit, not var13)
	onButton(arg0, arg0.startBtn, function()
		if not var0 then
			if not ItemTipPanel.ShowItemTipbyID(var5[1]) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipUpgradeLayer2_noMaterail"))
			end

			return
		end

		if var6 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_costcheck_error"))

			return
		end

		if arg0.playerVO.gold < var3 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var3 - arg0.playerVO.gold,
					var3
				}
			})

			return
		end

		arg0:emit(EquipUpgradeMediator.EQUIPMENT_UPGRDE)
	end, SFX_UI_DOCKYARD_REINFORCE)
	setButtonEnabled(arg0.startBtn, var13)
end

function var0.upgradeFinish(arg0, arg1, arg2)
	setActive(arg0.mainPanel, false)
	setActive(arg0.finishPanel, true)
	onButton(arg0, arg0.finishPanel:Find("bg"), function()
		setActive(arg0.mainPanel, true)
		setActive(arg0.finishPanel, false)
	end, SFX_CANCEL)
	changeToScrollText(arg0.finishPanel:Find("frame/equipment_panel/name_container"), arg2:getConfig("name"))
	setActive(findTF(arg0.finishPanel, "frame/equipment_panel/unique"), arg2:isUnique())

	local var0 = arg0:findTF("frame/equipment_panel/equiptpl", arg0.finishPanel)

	updateEquipment(var0, arg2)
	arg0:updateAttrs(arg0:findTF("frame/equipment_panel/view/content", arg0.finishPanel), arg1, arg2)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
