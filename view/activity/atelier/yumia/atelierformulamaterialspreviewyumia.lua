local var0_0 = class("AtelierFormulaMaterialsYumiaPreview", import("view.activity.Atelier.base.AtelierFormulaMaterialsPreview"))

function var0_0.InitCustom(arg0_1)
	setText(arg0_1:findTF("Frame/closeText"), i18n("yumia_atelier_tip13"))
	setText(arg0_1:findTF("Frame/Text"), i18n("yumia_atelier_tip11"))
	setText(arg0_1:findTF("Frame/Text_1"), i18n("yumia_atelier_tip12"))
end

function var0_0.didEnter(arg0_2)
	onButton(arg0_2, arg0_2:findTF("BG"), function()
		arg0_2:HideMaterialsPreview(true)
	end, SFX_CANCEL)
end

function var0_0.ShowMaterialsPreview(arg0_4, arg1_4)
	GetComponent(arg0_4._tf, typeof(Animation)):Play("Anim_AtelierCompositeYumiaUI_FormulaMaterialPreview_In")
	setActive(arg0_4._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)

	local var0_4 = arg0_4.activity:GetItems()
	local var1_4 = arg0_4.activity:GetFormulas()[arg0_4.contextData.formulaId]
	local var2_4 = AtelierMaterial.bindConfigTable()
	local var3_4 = {}
	local var4_4 = {}
	local var5_4 = {}

	local function var6_4(arg0_5)
		local var0_5 = var5_4[arg0_5:GetConfigID()] or Clone(var0_4[arg0_5:GetConfigID()])

		assert(var0_5, "Using Unexist material")

		var0_5.count = var0_5.count - 1
		var5_4[arg0_5:GetConfigID()] = var0_5
	end

	_.each(arg1_4, function(arg0_6)
		local var0_6 = arg0_6.Data:GetLimitItemID()

		if var0_6 ~= 0 then
			local var1_6 = var5_4[var0_6] or var0_4[var0_6]

			if var1_6 and var1_6.count > 0 then
				var3_4[var0_6] = (var3_4[var0_6] or 0) + 1

				var6_4(var1_6)
			else
				var4_4[var0_6] = (var4_4[var0_6] or 0) + 1
			end
		end
	end)

	local function var7_4(arg0_7)
		if arg0_7.Instance then
			if arg0_7.Data:GetLimitItemID() == 0 then
				var3_4[arg0_7.Instance:GetConfigID()] = (var3_4[arg0_7.Instance:GetConfigID()] or 0) + 1

				var6_4(arg0_7.Instance)
			end

			return
		end

		local var0_7 = arg0_7.Data
		local var1_7

		for iter0_7, iter1_7 in ipairs(var2_4.all) do
			local var2_7 = var5_4[iter1_7] or var0_4[iter1_7] or AtelierMaterial.New({
				configId = iter1_7
			})

			if var2_7:IsNormal() and var0_7:CanUseMaterial(var2_7, var1_4, arg0_4.contextData.versionIndex) then
				var1_7 = var1_7 or iter1_7

				if var2_7.count > 0 then
					var3_4[var1_7] = (var3_4[var1_7] or 0) + 1

					var6_4(var2_7)

					return
				end
			end
		end

		if var1_7 then
			var4_4[var1_7] = (var4_4[var1_7] or 0) + 1
		else
			assert(false, string.format("节点 %s 找不到合适的材料", var0_7:GetConfigID()))
		end
	end

	_.each(arg1_4, function(arg0_8)
		if arg0_8.Data:GetType() == AtelierFormulaCircle.TYPE.NORMAL then
			var7_4(arg0_8)
		end
	end)
	_.each(arg1_4, function(arg0_9)
		if arg0_9.Data:GetType() == AtelierFormulaCircle.TYPE.ANY then
			var7_4(arg0_9)
		end
	end)
	_.each(arg1_4, function(arg0_10)
		if arg0_10.Data:GetType() == AtelierFormulaCircle.TYPE.ELEMENT_CATEGORY then
			var7_4(arg0_10)
		end
	end)
	_.each(arg1_4, function(arg0_11)
		if arg0_11.Data:GetType() == AtelierFormulaCircle.TYPE.CATEGORY then
			var7_4(arg0_11)
		end
	end)
	_.each(arg1_4, function(arg0_12)
		if arg0_12.Data:GetType() == AtelierFormulaCircle.TYPE.ELEMENT then
			var7_4(arg0_12)
		end
	end)
	_.each(arg1_4, function(arg0_13)
		if arg0_13.Data:GetType() == AtelierFormulaCircle.TYPE.NONE then
			var7_4(arg0_13)
		end
	end)

	local function var8_4(arg0_14, arg1_14)
		return arg0_14 < arg1_14
	end

	local var9_4 = {}

	for iter0_4, iter1_4 in pairs(var3_4) do
		table.insert(var9_4, iter0_4)
	end

	local var10_4 = {}

	for iter2_4, iter3_4 in pairs(var4_4) do
		table.insert(var10_4, iter2_4)
	end

	table.sort(var9_4, var8_4)
	table.sort(var10_4, var8_4)

	local function var11_4()
		local var0_15 = arg0_4:findTF("Frame/Scroll/Content")

		setActive(var0_15.parent, #var9_4 > 0)

		if #var9_4 == 0 then
			return
		end

		local var1_15 = CustomIndexLayer.Clone2Full(var0_15, #var9_4)

		table.Foreach(var1_15, function(arg0_16, arg1_16)
			local var0_16 = var9_4[arg0_16]
			local var1_16 = AtelierMaterial.New({
				configId = var0_16
			})

			var1_16.count = var3_4[var0_16]

			arg0_4._parentClass:UpdateRyzaItem(arg1_16, var1_16, true)
			onButton(arg0_4, arg1_16, function()
				arg0_4._parentClass:ShowItemDetail(var1_16)
			end, SFX_PANEL)
		end)
	end

	local function var12_4()
		local var0_18 = arg0_4:findTF("Frame/LackScroll/Content")

		setActive(var0_18.parent, #var10_4 > 0)

		if #var10_4 == 0 then
			return
		end

		local var1_18 = CustomIndexLayer.Clone2Full(var0_18, #var10_4)

		table.Foreach(var1_18, function(arg0_19, arg1_19)
			local var0_19 = var10_4[arg0_19]
			local var1_19 = AtelierMaterial.New({
				configId = var0_19
			})

			var1_19.count = var4_4[var0_19]

			arg0_4._parentClass:UpdateRyzaItem(arg1_19, var1_19, true)
			onButton(arg0_4, arg1_19, function()
				arg0_4._parentClass:ShowItemDetail(var1_19)
			end, SFX_PANEL)
		end)
	end

	var11_4()
	var12_4()
	arg0_4:AddTimer(#var9_4, #var10_4)
end

function var0_0.HideMaterialsPreview(arg0_21, arg1_21)
	if not isActive(arg0_21._go) then
		return
	end

	local var0_21 = GetComponent(arg0_21._tf, typeof(Animation))

	var0_21:Play("Anim_AtelierCompositeYumiaUI_FormulaMaterialPreview_Out")
	pg.UIMgr.GetInstance():LoadingOn(false)

	if not arg1_21 then
		arg0_21:StopCloseTimer()
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_21:StopTimer()
		var0_0.super.HideMaterialsPreview(arg0_21)

		return
	end

	arg0_21.closeTimer = FrameTimer.New(function()
		if not var0_21:IsPlaying("Anim_AtelierCompositeYumiaUI_FormulaMaterialPreview_Out") then
			arg0_21:StopCloseTimer()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_21:StopTimer()
			var0_0.super.HideMaterialsPreview(arg0_21)
		end
	end, 1, -1)

	arg0_21.closeTimer:Start()

	return true
end

function var0_0.StopCloseTimer(arg0_23)
	if arg0_23.closeTimer then
		arg0_23.closeTimer:Stop()

		arg0_23.closeTimer = nil
	end
end

function var0_0.AddTimer(arg0_24, arg1_24, arg2_24)
	local var0_24 = 0
	local var1_24 = arg0_24:findTF("Frame/Scroll/Content")
	local var2_24 = arg0_24:findTF("Frame/LackScroll/Content")

	arg0_24.timer = FrameTimer.New(function()
		local var0_25 = 0

		for iter0_25 = 0, var1_24.childCount - 1 do
			if var1_24:GetChild(iter0_25).gameObject.activeSelf then
				var0_25 = var0_25 + 1
			end
		end

		local var1_25 = math.min(var0_25, math.min(arg1_24, 8))
		local var2_25 = 0

		for iter1_25 = 0, var2_24.childCount - 1 do
			if var2_24:GetChild(iter1_25).gameObject.activeSelf then
				var2_25 = var2_25 + 1
			end
		end

		local var3_25 = math.min(var2_25, math.min(arg2_24, 8))

		if var1_25 <= arg1_24 and var3_25 <= arg2_24 then
			arg0_24:StopTimer()
			arg0_24:AddTimer2()
		end
	end, 1, -1)

	arg0_24.timer:Start()
end

function var0_0.AddTimer2(arg0_26)
	local var0_26 = arg0_26:findTF("Frame/Scroll/Content")
	local var1_26 = arg0_26:findTF("Frame/LackScroll/Content")
	local var2_26 = var0_26.childCount
	local var3_26 = var1_26.childCount

	for iter0_26 = 0, var2_26 - 1 do
		SetComponentEnabled(var0_26:GetChild(iter0_26), typeof(Animation), false)

		GetComponent(var0_26:GetChild(iter0_26), typeof(CanvasGroup)).alpha = 0
	end

	for iter1_26 = 0, var3_26 - 1 do
		SetComponentEnabled(var1_26:GetChild(iter1_26), typeof(Animation), false)

		GetComponent(var1_26:GetChild(iter1_26), typeof(CanvasGroup)).alpha = 0
	end

	local var4_26 = 0

	arg0_26.timer = Timer.New(function()
		if var4_26 >= var2_26 and var4_26 >= var3_26 then
			arg0_26:StopTimer()

			return
		end

		if var4_26 < var2_26 then
			local var0_27 = GetComponent(var0_26:GetChild(var4_26), typeof(Animation))

			var0_27.enabled = true

			var0_27:Stop()
			var0_27:Play("Anim_AtelierStoreYumiaUI_Tpl_In")
		end

		if var4_26 < var3_26 then
			local var1_27 = GetComponent(var1_26:GetChild(var4_26), typeof(Animation))

			var1_27.enabled = true

			var1_27:Stop()
			var1_27:Play("Anim_AtelierStoreYumiaUI_Tpl_In")
		end

		var4_26 = var4_26 + 1
	end, 0.08, -1)

	arg0_26.timer:Start()
end

function var0_0.StopTimer(arg0_28)
	if arg0_28.timer then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end
end

return var0_0
