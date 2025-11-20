local var0_0 = class("BossRushDALUpgradeView", import("view.base.BaseSubView"))

var0_0.RES_ID = 65742

function var0_0.getUIName(arg0_1)
	return "BossRushUpgradeUIDALCollab"
end

function var0_0.SetData(arg0_2, arg1_2)
	arg0_2._upgradeActivity = arg1_2
end

function var0_0.Show(arg0_3)
	var0_0.super.Show(arg0_3)
	arg0_3:UpdateView()
	arg0_3:ShowOrHideResUI(false)
	arg0_3:BlurPanel(arg0_3._tf)
end

function var0_0.UpdateView(arg0_4)
	arg0_4:updateRes()

	if arg0_4._upgradeDetailView.gameObject.activeSelf then
		arg0_4:updateDetail(arg0_4._lastSelectedID)
	end

	for iter0_4, iter1_4 in pairs(arg0_4._upgradeList) do
		local var0_4 = "LV." .. arg0_4._upgradeActivity:GetBuildingLevel(iter0_4) - 1

		setText(iter1_4:Find("unselected/level"), var0_4)
		setText(iter1_4:Find("selected/level"), var0_4)
	end

	local var1_4 = arg0_4._upgradeActivity:getConfig("config_data")

	for iter2_4, iter3_4 in ipairs(var1_4) do
		local var2_4 = arg0_4._tf:Find("Panel/upgrade_" .. iter3_4)

		setText(var2_4:Find("mask/name"), arg0_4._upgradeActivity:GetBuildingConfigTable(iter3_4).name)
	end
end

function var0_0.Hide(arg0_5)
	if arg0_5._upgradeDetailView.gameObject.activeSelf then
		arg0_5:closeUpgradeDetail()

		return
	end

	var0_0.super.Hide(arg0_5)
	arg0_5:UnOverlayPanel(arg0_5._tf, arg0_5._parentTf)
end

function var0_0.OnLoaded(arg0_6)
	arg0_6.parentTr = arg0_6._tf.parent
	arg0_6._go = arg0_6._tf.gameObject
	arg0_6._upgradeList = {}

	local var0_6 = arg0_6._upgradeActivity:getConfig("config_data")

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var1_6 = arg0_6._tf:Find("Panel/upgrade_" .. iter1_6)

		onButton(arg0_6, var1_6, function()
			arg0_6:openUpgradeDetail(iter1_6)
			arg0_6:setSelected(iter1_6)
		end)

		local var2_6 = "LV." .. arg0_6._upgradeActivity:GetBuildingLevel(iter1_6) - 1

		setText(var1_6:Find("unselected/level"), var2_6)
		setText(var1_6:Find("selected/level"), var2_6)
		setText(var1_6:Find("mask/name"), arg0_6._upgradeActivity:GetBuildingConfigTable(iter1_6).name)

		arg0_6._upgradeList[iter1_6] = var1_6
	end

	arg0_6._upgradeDetailView = arg0_6._tf:Find("UpgradePage")
	arg0_6._upgradeDetailCurrentName = arg0_6._upgradeDetailView:Find("page/skill/name")
	arg0_6._upgradeDetailLevel = arg0_6._upgradeDetailView:Find("page/skill/level")
	arg0_6._upgradeDetailIcon = arg0_6._upgradeDetailView:Find("page/skill/icon")
	arg0_6._upgradeDetailList = {}

	for iter2_6 = 1, 3 do
		local var3_6 = arg0_6._upgradeDetailView:Find("page/upgrade_list/skill_detail_" .. iter2_6)

		setText(var3_6:Find("active/level"), "LV." .. iter2_6)
		setText(var3_6:Find("active/active"), i18n("DAL_upgrade_active"))
		setText(var3_6:Find("disable/level"), "LV." .. iter2_6)
		setText(var3_6:Find("disable/unlock"), i18n("DAL_upgrade_unlock"))
		table.insert(arg0_6._upgradeDetailList, var3_6)
	end

	arg0_6._closeDetailBtn = arg0_6._upgradeDetailView:Find("Top/back_btn")

	setText(arg0_6._closeDetailBtn:Find("label"), i18n("DAL_upgrade_program"))
	onButton(arg0_6, arg0_6._closeDetailBtn, function()
		arg0_6:closeUpgradeDetail()
	end)

	arg0_6._upgradeBtn = arg0_6._upgradeDetailView:Find("page/upgrade_btn")

	setText(arg0_6._upgradeBtn:Find("label/upgrade"), i18n("word_levelup"))
	onButton(arg0_6, arg0_6._upgradeBtn, function()
		arg0_6.event:emit(BossRushDALCollabMediator.ON_UPGRADE, {
			cmd = 1,
			activity_id = arg0_6._upgradeActivity.id,
			arg1 = arg0_6._lastSelectedID
		})
	end)

	arg0_6._closeBtn = arg0_6._tf:Find("Top/back_btn")

	setText(arg0_6._closeBtn:Find("label"), i18n("DAL_upgrade_ship"))
	setText(arg0_6._upgradeDetailView:Find("Top/back_btn/label"), i18n("DAL_upgrade_ship"))
	onButton(arg0_6, arg0_6._tf:Find("Top/res"), function()
		arg0_6.event:emit(BaseUI.ON_ITEM, var0_0.RES_ID)
	end)
	onButton(arg0_6, arg0_6._upgradeDetailView:Find("Top/res"), function()
		arg0_6.event:emit(BaseUI.ON_ITEM, var0_0.RES_ID)
	end)
	onButton(arg0_6, arg0_6._closeBtn, function()
		arg0_6:Hide()
	end)
end

function var0_0.updateRes(arg0_13)
	local var0_13 = arg0_13._upgradeActivity:GetMaterialCount(var0_0.RES_ID)

	setText(arg0_13._tf:Find("Top/res/text"), var0_13)
	setText(arg0_13._upgradeDetailView:Find("Top/res/text"), var0_13)
end

function var0_0.openUpgradeDetail(arg0_14, arg1_14)
	setActive(arg0_14._upgradeDetailView, true)

	local var0_14 = arg0_14._upgradeActivity:GetBuildingConfigTable(arg1_14)

	setText(arg0_14._upgradeDetailCurrentName, var0_14.name)

	local var1_14 = arg0_14._upgradeList[arg1_14]:Find("unselected/icon"):GetComponent(typeof(Image)).sprite

	arg0_14._upgradeDetailIcon:GetComponent(typeof(Image)).sprite = var1_14

	local var2_14 = arg0_14._upgradeActivity:GetBuildingLevel(arg1_14) - 1

	setText(arg0_14._upgradeDetailLevel, "LV." .. var2_14)
	arg0_14:updateDetail(arg1_14)
	arg0_14:BlurPanel(arg0_14._upgradeDetailView)
end

function var0_0.updateDetail(arg0_15, arg1_15)
	local var0_15 = arg0_15._upgradeActivity:GetBuildingConfigTable(arg1_15)
	local var1_15 = arg0_15._upgradeActivity:GetBuildingLevel(arg1_15)

	setText(arg0_15._upgradeDetailLevel, "LV." .. var1_15 - 1)

	for iter0_15, iter1_15 in ipairs(arg0_15._upgradeDetailList) do
		if iter0_15 <= var1_15 - 1 then
			setActive(iter1_15:Find("disable"), false)
			setActive(iter1_15:Find("active"), true)
			setText(iter1_15:Find("active/desc"), var0_15.desc[iter0_15])
		else
			setActive(iter1_15:Find("disable"), true)
			setActive(iter1_15:Find("active"), false)
		end
	end

	if var1_15 >= 4 then
		setActive(arg0_15._upgradeBtn, false)
	else
		setActive(arg0_15._upgradeBtn, true)

		local var2_15 = var0_15.material[var1_15][1][3]

		setText(arg0_15._upgradeBtn:Find("label/value"), var2_15)
	end
end

function var0_0.closeUpgradeDetail(arg0_16)
	setActive(arg0_16._upgradeDetailView, false)
	arg0_16:UnOverlayPanel(arg0_16._upgradeDetailView, arg0_16._tf)
end

function var0_0.setSelected(arg0_17, arg1_17)
	if arg0_17._lastSelectedID then
		local var0_17 = arg0_17._upgradeList[arg0_17._lastSelectedID]
	end

	local var1_17 = arg0_17._upgradeList[arg1_17]

	arg0_17._lastSelectedID = arg1_17
end

function var0_0.ResUISettings(arg0_18)
	return true
end

function var0_0.OnDestroy(arg0_19)
	arg0_19.exited = true
end

return var0_0
