local var0_0 = class("AtelierMaterialSelectView", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.BG = arg0_2._tf:Find("BG")
	arg0_2.candicatesRect = GetComponent(arg0_2._tf:Find("Frame/List"), "LScrollRect")

	local var0_2 = arg0_2._tf:Find("Frame/Item")

	setActive(var0_2, false)

	function arg0_2.candicatesRect.onUpdateItem(arg0_3, arg1_3)
		arg0_2:UpdateCandicateItem(arg0_3 + 1, arg1_3)
	end

	setActive(arg0_2._go, false)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_4)
	local var0_4 = arg0_4._tf:Find("Frame/Item")

	setText(var0_4:Find("IconBG/Lack/Text"), i18n("ryza_ui_show_acess"))
end

function var0_0.SetContextData(arg0_5, arg1_5)
	arg0_5.contextData = arg1_5
end

function var0_0.SetActivity(arg0_6, arg1_6)
	arg0_6.activity = arg1_6
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.BG, function()
		arg0_7:CloseCandicatePanel()
	end, SFX_CANCEL)
end

function var0_0.UpdateCandicateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = tf(arg2_9)
	local var1_9 = arg0_9.candicates[arg1_9]

	arg0_9._parentClass:UpdateRyzaItem(var0_9:Find("IconBG"), var1_9, true)

	local var2_9 = var1_9.count <= 0

	setActive(var0_9:Find("IconBG/Lack"), var2_9)
	onButton(arg0_9, var0_9, function()
		if var2_9 then
			var1_9 = CreateShell(var1_9)
			var1_9.count = false

			arg0_9._parentClass:ShowItemDetail(var1_9)
		else
			arg0_9._parentClass:OnSelectMaterial(arg0_9.nodeTarget, var1_9)
			arg0_9:HideCandicatePanel()
		end
	end, SFX_PANEL)
end

function var0_0.ShowCandicatePanel(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11._tf:Find("Target")
	local var1_11 = tf(Instantiate(arg1_11))

	SetComponentEnabled(var1_11, typeof(Button), false)
	removeAllChildren(arg0_11._tf:Find("Target"))
	setParent(var1_11, var0_11)
	setAnchoredPosition(var1_11, Vector2.zero)
	arg0_11:HideNodeLinks(var1_11)

	local var2_11 = arg0_11._parentClass.layerFormulaDetailPanel
	local var3_11 = var0_11.anchoredPosition
	local var4_11 = arg0_11._parentClass.scrollView:Find("Content")
	local var5_11 = arg1_11.anchoredPosition + arg0_11._parentClass.scrollView.anchoredPosition

	setAnchoredPosition(var4_11, var3_11 - var5_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._parentClass.top)
	setActive(arg0_11._go, true)
	SetComponentEnabled(arg0_11._parentClass.scrollView, typeof(ScrollRect), false)

	arg0_11.nodeTarget = arg2_11

	arg0_11:PlayBgAnimation()
	arg0_11:UpdateCandicatePanel(arg3_11)
end

function var0_0.CloseCandicatePanel(arg0_12)
	arg0_12:StopBgAnimation(function()
		arg0_12:HideCandicatePanel()
	end)
end

function var0_0.HideCandicatePanel(arg0_14)
	if not isActive(arg0_14._go) then
		return
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_14._parentClass.top)
	arg0_14._parentClass.painting:SetSiblingIndex(1)
	setActive(arg0_14._go, false)
	removeAllChildren(arg0_14._tf:Find("Target"))
	SetComponentEnabled(arg0_14._parentClass.scrollView, typeof(ScrollRect), true)

	arg0_14.candicateTarget = nil

	return true
end

function var0_0.UpdateCandicatePanel(arg0_15, arg1_15)
	arg0_15.candicates = {}

	local var0_15 = arg0_15.activity:GetItems()
	local var1_15 = arg0_15.activity:GetFormulas()[arg0_15.contextData.formulaId]
	local var2_15 = _.map(pg.activity_ryza_item.all, function(arg0_16)
		local var0_16 = var0_15[arg0_16] or AtelierMaterial.New({
			configId = arg0_16
		})

		if var0_16:IsShow() ~= 0 and arg0_15.nodeTarget.Data:CanUseMaterial(var0_16, var1_15, arg0_15.contextData.versionIndex) then
			if var0_15[arg0_16] then
				var0_16 = AtelierMaterial.New({
					configId = arg0_16,
					count = var0_15[arg0_16].count
				})
				var0_16.count = _.reduce(arg1_15, var0_16.count, function(arg0_17, arg1_17)
					if arg1_17.Instance and arg1_17.Instance:GetConfigID() == arg0_16 then
						arg0_17 = arg0_17 - 1
					end

					return arg0_17
				end)
			end

			return var0_16
		end
	end)

	table.sort(var2_15, function(arg0_18, arg1_18)
		if arg0_18.count * arg1_18.count == 0 and arg0_18.count - arg1_18.count ~= 0 then
			return arg0_18.count < arg1_18.count
		else
			return arg0_18:GetConfigID() < arg1_18:GetConfigID()
		end
	end)
	_.each(var2_15, function(arg0_19)
		for iter0_19 = 1, math.max(arg0_19.count, 1) do
			table.insert(arg0_15.candicates, arg0_19)
		end
	end)
	arg0_15.candicatesRect:SetTotalCount(#arg0_15.candicates, 0)
end

function var0_0.willExit(arg0_20)
	arg0_20:detach()
end

function var0_0.HideNodeLinks(arg0_21, arg1_21)
	for iter0_21 = 1, 6 do
		setActive(arg1_21:Find("Links"):GetChild(iter0_21 - 1), false)
	end
end

function var0_0.PlayBgAnimation(arg0_22)
	local var0_22 = arg0_22._tf:Find("TargetBG")

	var0_22.localRotation = Quaternion.identity

	local var1_22 = arg0_22.nodeTarget.Data:GetType() == AtelierFormulaCircle.TYPE.BASE and 300 or 245

	setSizeDelta(var0_22, {
		x = var1_22,
		y = var1_22
	})
	GetComponent(var0_22, typeof(Animator)):SetBool("Selecting", true)
end

function var0_0.StopBgAnimation(arg0_23, arg1_23)
	arg0_23._parentClass:LoadingOn()

	local var0_23 = GetComponent(arg0_23._tf:Find("TargetBG"), typeof(DftAniEvent))

	var0_23:SetEndEvent(function()
		arg0_23._parentClass:LoadingOff()
		arg1_23()
		var0_23:SetEndEvent(nil)
	end)
	GetComponent(arg0_23._tf:Find("TargetBG"), typeof(Animator)):SetBool("Selecting", false)
end

return var0_0
