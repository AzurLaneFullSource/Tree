local var0_0 = class("NewShipDocumentView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewShipDocumentView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
	arg0_2:AddListener()
	setActive(arg0_2._tf, true)
	LeanTween.move(rtf(arg0_2._tf), Vector3(-30, 0, 0), 0.3)
end

function var0_0.OnDestroy(arg0_3)
	arg0_3._shipVO = nil
	arg0_3.confirmFunc = nil
end

function var0_0.InitUI(arg0_4)
	arg0_4.skillContainer = arg0_4:findTF("bg/skill_panel/frame/skill_list/viewport")
	arg0_4.skillTpl = arg0_4:getTpl("bg/skill_panel/frame/skilltpl", arg0_4._tf)
	arg0_4.emptyTpl = arg0_4:getTpl("bg/skill_panel/frame/emptytpl", arg0_4._tf)
	arg0_4.addTpl = arg0_4:getTpl("bg/skill_panel/frame/addtpl", arg0_4._tf)
end

function var0_0.AddListener(arg0_5)
	onButton(arg0_5, arg0_5:findTF("qr_btn"), function()
		arg0_5.confirmFunc()
	end, SFX_CONFIRM)
end

function var0_0.initSkills(arg0_7)
	local var0_7 = arg0_7._shipVO:getMaxConfigId()
	local var1_7 = pg.ship_data_template[var0_7]
	local var2_7 = 1

	for iter0_7, iter1_7 in ipairs(var1_7.buff_list_display) do
		local var3_7 = getSkillConfig(iter1_7)
		local var4_7 = arg0_7._shipVO.skills
		local var5_7

		if var4_7[iter1_7] then
			var5_7 = cloneTplTo(arg0_7.skillTpl, arg0_7.skillContainer)

			onButton(arg0_7, var5_7, function()
				arg0_7:emit(NewShipMediator.ON_SKILLINFO, var3_7.id, var4_7[iter1_7])
			end, SFX_PANEL)
		else
			var5_7 = cloneTplTo(arg0_7.emptyTpl, arg0_7.skillContainer)

			setActive(arg0_7:findTF("mask", var5_7), true)
			onButton(arg0_7, var5_7, function()
				arg0_7:emit(NewShipMediator.ON_SKILLINFO, var3_7.id)
			end, SFX_PANEL)
		end

		var2_7 = var2_7 + 1

		LoadImageSpriteAsync("skillicon/" .. var3_7.icon, findTF(var5_7, "icon"))
	end

	for iter2_7 = var2_7, 3 do
		cloneTplTo(arg0_7.addTpl, arg0_7.skillContainer)
	end
end

function var0_0.UpdatePropertyPanel(arg0_10)
	arg0_10.propertyPanel = PropertyPanel.New(arg0_10:findTF("bg/property_panel/frame"))

	arg0_10.propertyPanel:initProperty(arg0_10._shipVO.configId)
end

function var0_0.getTpl(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:findTF(arg1_11, arg2_11)

	var0_11:SetParent(arg0_11._tf, false)
	SetActive(var0_11, false)

	return var0_11
end

function var0_0.SetParams(arg0_12, arg1_12, arg2_12)
	arg0_12._shipVO = arg1_12
	arg0_12.confirmFunc = arg2_12
end

function var0_0.RefreshUI(arg0_13)
	arg0_13:initSkills()
	arg0_13:UpdatePropertyPanel()
end

return var0_0
