local var0_0 = class("NewShipDocumentView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewShipDocumentView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg1_2.ship

	if var1_2 then
		local var2_2 = var1_2:getMaxConfigId()
		local var3_2 = pg.ship_data_template[var2_2]

		_.each(var3_2.buff_list_display, function(arg0_3)
			local var0_3 = getSkillConfig(arg0_3)
			local var1_3 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.ShipSkillIcon, var0_3.icon)

			table.insert(var0_2, var1_3)
		end)
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.OnInit(arg0_4)
	arg0_4:InitUI()
	arg0_4:AddListener()
	setActive(arg0_4._tf, true)
	LeanTween.move(rtf(arg0_4._tf), Vector3(-30, 0, 0), 0.3)
end

function var0_0.OnDestroy(arg0_5)
	arg0_5._shipVO = nil
	arg0_5.confirmFunc = nil
end

function var0_0.InitUI(arg0_6)
	arg0_6.skillContainer = arg0_6._tf:Find("bg/skill_panel/frame/skill_list/viewport")
	arg0_6.skillTpl = arg0_6:getTpl("bg/skill_panel/frame/skilltpl", arg0_6._tf)
	arg0_6.emptyTpl = arg0_6:getTpl("bg/skill_panel/frame/emptytpl", arg0_6._tf)
	arg0_6.addTpl = arg0_6:getTpl("bg/skill_panel/frame/addtpl", arg0_6._tf)
end

function var0_0.AddListener(arg0_7)
	onButton(arg0_7, arg0_7._tf:Find("qr_btn"), function()
		arg0_7.confirmFunc()
	end, SFX_CONFIRM)
end

function var0_0.initSkills(arg0_9)
	local var0_9 = arg0_9._shipVO:getMaxConfigId()
	local var1_9 = pg.ship_data_template[var0_9]
	local var2_9 = 1

	for iter0_9, iter1_9 in ipairs(var1_9.buff_list_display) do
		local var3_9 = getSkillConfig(iter1_9)
		local var4_9 = arg0_9._shipVO.skills
		local var5_9

		if var4_9[iter1_9] then
			var5_9 = cloneTplTo(arg0_9.skillTpl, arg0_9.skillContainer)

			onButton(arg0_9, var5_9, function()
				arg0_9:emit(NewShipMediator.ON_SKILLINFO, var3_9.id, var4_9[iter1_9])
			end, SFX_PANEL)
		else
			var5_9 = cloneTplTo(arg0_9.emptyTpl, arg0_9.skillContainer)

			setActive(var5_9:Find("mask"), true)
			onButton(arg0_9, var5_9, function()
				arg0_9:emit(NewShipMediator.ON_SKILLINFO, var3_9.id)
			end, SFX_PANEL)
		end

		var2_9 = var2_9 + 1

		LoadImageSpriteAsync("skillicon/" .. var3_9.icon, findTF(var5_9, "icon"))
	end

	for iter2_9 = var2_9, 3 do
		cloneTplTo(arg0_9.addTpl, arg0_9.skillContainer)
	end
end

function var0_0.UpdatePropertyPanel(arg0_12)
	arg0_12.propertyPanel = PropertyPanel.New(arg0_12._tf:Find("bg/property_panel/frame"))

	arg0_12.propertyPanel:initProperty(arg0_12._shipVO.configId)
end

function var0_0.getTpl(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13:Find(arg1_13)

	var0_13:SetParent(arg0_13._tf, false)
	SetActive(var0_13, false)

	return var0_13
end

function var0_0.SetParams(arg0_14, arg1_14, arg2_14)
	arg0_14._shipVO = arg1_14
	arg0_14.confirmFunc = arg2_14
end

function var0_0.RefreshUI(arg0_15)
	arg0_15:initSkills()
	arg0_15:UpdatePropertyPanel()
end

return var0_0
