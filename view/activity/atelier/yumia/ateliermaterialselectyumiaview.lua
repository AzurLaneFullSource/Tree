local var0_0 = class("AtelierMaterialSelectYumiaView", import("view.activity.Atelier.base.AtelierMaterialSelectView"))

function var0_0.InitCustom(arg0_1)
	arg0_1.item = arg0_1:findTF("left/Icon")
	arg0_1.itemName = arg0_1:findTF("left/titleBg/Name")
	arg0_1.itemCnt = arg0_1:findTF("left/titleBg/cntText")
	arg0_1.itemDescription = arg0_1:findTF("left/Description/Text")

	setText(arg0_1:findTF("Frame/closeBtn/Text"), i18n("yumia_atelier_tip10"))
	setText(arg0_1:findTF("left/titleBg/Text_1"), i18n("yumia_atelier_tip8"))
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	onButton(arg0_2, arg0_2:findTF("Frame/closeBtn"), function()
		arg0_2:CloseCandicatePanel()
	end, SFX_PANEL)
end

function var0_0.UpdateCandicateItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = tf(arg2_4)
	local var1_4 = arg0_4.candicates[arg1_4]

	arg0_4._parentClass:UpdateRyzaItem(var0_4, var1_4, true)

	local var2_4 = var1_4.count <= 0

	onButton(arg0_4, var0_4, function()
		if var2_4 then
			var1_4 = CreateShell(var1_4)
			var1_4.count = false

			arg0_4._parentClass:ShowItemDetail(var1_4)
		else
			arg0_4._parentClass:OnSelectMaterial(arg0_4.nodeTarget, var1_4)
			arg0_4:HideCandicatePanel()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateCandicatePanel(arg0_6, arg1_6)
	arg0_6.candicates = {}

	local var0_6 = arg0_6.activity:GetItems()
	local var1_6 = arg0_6.activity:GetFormulas()[arg0_6.contextData.formulaId]
	local var2_6 = _.map(pg.activity_ryza_item.all, function(arg0_7)
		local var0_7 = var0_6[arg0_7] or AtelierMaterial.New({
			configId = arg0_7
		})

		if var0_7:IsShow() ~= 0 and arg0_6.nodeTarget.Data:CanUseMaterial(var0_7, var1_6, arg0_6.contextData.versionIndex) then
			if var0_6[arg0_7] then
				var0_7 = AtelierMaterial.New({
					configId = arg0_7,
					count = var0_6[arg0_7].count
				})
				var0_7.count = _.reduce(arg1_6, var0_7.count, function(arg0_8, arg1_8)
					if arg1_8.Instance and arg1_8.Instance:GetConfigID() == arg0_7 then
						arg0_8 = arg0_8 - 1
					end

					return arg0_8
				end)
			end

			return var0_7
		end
	end)

	table.sort(var2_6, function(arg0_9, arg1_9)
		if arg0_9.count * arg1_9.count == 0 and arg0_9.count - arg1_9.count ~= 0 then
			return arg0_9.count > arg1_9.count
		else
			return arg0_9:GetConfigID() < arg1_9:GetConfigID()
		end
	end)
	_.each(var2_6, function(arg0_10)
		table.insert(arg0_6.candicates, arg0_10)
	end)
	arg0_6.candicatesRect:SetTotalCount(#arg0_6.candicates, 0)
end

function var0_0.ShowCandicatePanel(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11:findTF("Target")

	setActive(arg0_11._go, true)
	SetComponentEnabled(arg0_11._parentClass.scrollView, typeof(ScrollRect), false)

	GetComponent(arg0_11._parentClass.scrollView, typeof(CanvasGroup)).blocksRaycasts = false

	setParent(arg0_11.BG, arg0_11._parentClass.layerFormulaDetailPanel)
	arg0_11.BG:SetSiblingIndex(0)

	arg0_11.nodeTarget = arg2_11

	arg0_11:UpdateCandicatePanel(arg3_11)
	arg0_11:RefreshFormula()
	tf(arg2_11.GO):SetAsLastSibling()
	setActive(arg0_11:findTF("select", arg2_11.GO), true)
end

function var0_0.RefreshFormula(arg0_12)
	local var0_12 = arg0_12.activity:GetFormulas()[arg0_12.contextData.formulaId]
	local var1_12 = {
		type = var0_12:GetProduction()[1],
		id = var0_12:GetProduction()[2]
	}

	arg0_12._parentClass:UpdateRyzaDrop(arg0_12.item, var1_12)
	setText(arg0_12.itemName, var0_12:GetName())
	setText(arg0_12.itemDescription, var0_12:GetDesc())

	local var2_12 = tostring(var0_12:GetMaxLimit() - var0_12:GetUsedCount())

	if var0_12:GetMaxLimit() < 0 then
		var2_12 = "∞"
	end

	setText(arg0_12.itemCnt, var2_12)
end

function var0_0.CloseCandicatePanel(arg0_13)
	arg0_13:StopBgAnimation(function()
		arg0_13:HideCandicatePanel()
	end)
end

function var0_0.HideCandicatePanel(arg0_15)
	if not isActive(arg0_15._go) then
		return
	end

	setActive(arg0_15:findTF("select", arg0_15.nodeTarget.GO), false)
	setActive(arg0_15._go, false)

	GetComponent(arg0_15._parentClass.scrollView, typeof(CanvasGroup)).blocksRaycasts = true

	setParent(arg0_15.BG, arg0_15._tf)
	arg0_15._parentClass:RefreshScrollViewPosition()

	arg0_15.candicateTarget = nil

	return true
end

function var0_0.PlayBgAnimation(arg0_16)
	return
end

function var0_0.StopBgAnimation(arg0_17, arg1_17)
	arg1_17()
end

return var0_0
