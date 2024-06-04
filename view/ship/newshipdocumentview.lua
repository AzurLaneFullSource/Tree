local var0 = class("NewShipDocumentView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewShipDocumentView"
end

function var0.OnInit(arg0)
	arg0:InitUI()
	arg0:AddListener()
	setActive(arg0._tf, true)
	LeanTween.move(rtf(arg0._tf), Vector3(-30, 0, 0), 0.3)
end

function var0.OnDestroy(arg0)
	arg0._shipVO = nil
	arg0.confirmFunc = nil
end

function var0.InitUI(arg0)
	arg0.skillContainer = arg0:findTF("bg/skill_panel/frame/skill_list/viewport")
	arg0.skillTpl = arg0:getTpl("bg/skill_panel/frame/skilltpl", arg0._tf)
	arg0.emptyTpl = arg0:getTpl("bg/skill_panel/frame/emptytpl", arg0._tf)
	arg0.addTpl = arg0:getTpl("bg/skill_panel/frame/addtpl", arg0._tf)
end

function var0.AddListener(arg0)
	onButton(arg0, arg0:findTF("qr_btn"), function()
		arg0.confirmFunc()
	end, SFX_CONFIRM)
end

function var0.initSkills(arg0)
	local var0 = arg0._shipVO:getMaxConfigId()
	local var1 = pg.ship_data_template[var0]
	local var2 = 1

	for iter0, iter1 in ipairs(var1.buff_list_display) do
		local var3 = getSkillConfig(iter1)
		local var4 = arg0._shipVO.skills
		local var5

		if var4[iter1] then
			var5 = cloneTplTo(arg0.skillTpl, arg0.skillContainer)

			onButton(arg0, var5, function()
				arg0:emit(NewShipMediator.ON_SKILLINFO, var3.id, var4[iter1])
			end, SFX_PANEL)
		else
			var5 = cloneTplTo(arg0.emptyTpl, arg0.skillContainer)

			setActive(arg0:findTF("mask", var5), true)
			onButton(arg0, var5, function()
				arg0:emit(NewShipMediator.ON_SKILLINFO, var3.id)
			end, SFX_PANEL)
		end

		var2 = var2 + 1

		LoadImageSpriteAsync("skillicon/" .. var3.icon, findTF(var5, "icon"))
	end

	for iter2 = var2, 3 do
		cloneTplTo(arg0.addTpl, arg0.skillContainer)
	end
end

function var0.UpdatePropertyPanel(arg0)
	arg0.propertyPanel = PropertyPanel.New(arg0:findTF("bg/property_panel/frame"))

	arg0.propertyPanel:initProperty(arg0._shipVO.configId)
end

function var0.getTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF(arg1, arg2)

	var0:SetParent(arg0._tf, false)
	SetActive(var0, false)

	return var0
end

function var0.SetParams(arg0, arg1, arg2)
	arg0._shipVO = arg1
	arg0.confirmFunc = arg2
end

function var0.RefreshUI(arg0)
	arg0:initSkills()
	arg0:UpdatePropertyPanel()
end

return var0
