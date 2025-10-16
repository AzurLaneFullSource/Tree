local var0_0 = class("AtelierFormulaMaterialsPreview", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	setActive(arg0_1._go, false)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_3)
	setText(arg0_3._tf:Find("Frame/Text"), i18n("ryza_tip_item_access"))
end

function var0_0.SetContextData(arg0_4, arg1_4)
	arg0_4.contextData = arg1_4
end

function var0_0.SetActivity(arg0_5, arg1_5)
	arg0_5.activity = arg1_5
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("BG"), function()
		arg0_6:HideMaterialsPreview()
	end, SFX_CANCEL)
end

function var0_0.ShowMaterialsPreview(arg0_8, arg1_8)
	setActive(arg0_8._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)

	local var0_8 = arg0_8.activity:GetItems()
	local var1_8 = arg0_8.activity:GetFormulas()[arg0_8.contextData.formulaId]
	local var2_8 = AtelierMaterial.bindConfigTable()
	local var3_8 = {}
	local var4_8 = {}
	local var5_8 = {}

	local function var6_8(arg0_9)
		local var0_9 = var5_8[arg0_9:GetConfigID()] or Clone(var0_8[arg0_9:GetConfigID()])

		assert(var0_9, "Using Unexist material")

		var0_9.count = var0_9.count - 1
		var5_8[arg0_9:GetConfigID()] = var0_9
	end

	_.each(arg1_8, function(arg0_10)
		local var0_10 = arg0_10.Data:GetLimitItemID()

		if var0_10 ~= 0 then
			local var1_10 = var5_8[var0_10] or var0_8[var0_10]

			if var1_10 and var1_10.count > 0 then
				local var2_10 = AtelierMaterial.New({
					configId = var0_10
				})

				var2_10.count = false

				table.insert(var3_8, var2_10)
				var6_8(var1_10)
			else
				local var3_10 = AtelierMaterial.New({
					configId = var0_10
				})

				var3_10.count = false

				table.insert(var4_8, var3_10)
			end
		end
	end)

	local function var7_8(arg0_11)
		if arg0_11.Instance then
			local var0_11 = AtelierMaterial.New({
				configId = arg0_11.Instance:GetConfigID()
			})

			var0_11.count = false

			table.insert(var3_8, var0_11)
			var6_8(arg0_11.Instance)

			return
		end

		local var1_11 = arg0_11.Data
		local var2_11

		for iter0_11, iter1_11 in ipairs(var2_8.all) do
			local var3_11 = var5_8[iter1_11] or var0_8[iter1_11] or AtelierMaterial.New({
				configId = iter1_11
			})

			if var3_11:IsNormal() and var1_11:CanUseMaterial(var3_11, var1_8, arg0_8.contextData.versionIndex) then
				var2_11 = var2_11 or iter1_11

				if var3_11.count > 0 then
					local var4_11 = AtelierMaterial.New({
						configId = iter1_11
					})

					var4_11.count = false

					table.insert(var3_8, var4_11)
					var6_8(var3_11)

					return
				end
			end
		end

		local var5_11 = AtelierMaterial.New({
			configId = var2_11
		})

		var5_11.count = false

		table.insert(var4_8, var5_11)
	end

	_.each(arg1_8, function(arg0_12)
		if arg0_12.Data:GetType() == AtelierFormulaCircle.TYPE.NORMAL then
			var7_8(arg0_12)
		end
	end)
	_.each(arg1_8, function(arg0_13)
		if arg0_13.Data:GetType() == AtelierFormulaCircle.TYPE.ANY then
			var7_8(arg0_13)
		end
	end)
	_.each(arg1_8, function(arg0_14)
		if arg0_14.Data:GetType() == AtelierFormulaCircle.TYPE.ELEMENT_CATEGORY then
			var7_8(arg0_14)
		end
	end)
	_.each(arg1_8, function(arg0_15)
		if arg0_15.Data:GetType() == AtelierFormulaCircle.TYPE.CATEGORY then
			var7_8(arg0_15)
		end
	end)
	_.each(arg1_8, function(arg0_16)
		if arg0_16.Data:GetType() == AtelierFormulaCircle.TYPE.ELEMENT then
			var7_8(arg0_16)
		end
	end)
	_.each(arg1_8, function(arg0_17)
		if arg0_17.Data:GetType() == AtelierFormulaCircle.TYPE.NONE then
			var7_8(arg0_17)
		end
	end)

	local function var8_8(arg0_18, arg1_18)
		return arg0_18:GetConfigID() < arg1_18:GetConfigID()
	end

	table.sort(var3_8, var8_8)
	table.sort(var4_8, var8_8)

	local function var9_8()
		local var0_19 = arg0_8._tf:Find("Frame/Scroll/Content/Owned/List")

		setActive(var0_19.parent, #var3_8 > 0)

		if #var3_8 == 0 then
			return
		end

		local var1_19 = CustomIndexLayer.Clone2Full(var0_19, #var3_8)

		table.Foreach(var1_19, function(arg0_20, arg1_20)
			local var0_20 = var3_8[arg0_20]

			arg0_8._parentClass:UpdateRyzaItem(arg1_20:Find("IconBG"), var0_20, true)
			onButton(arg0_8, arg1_20, function()
				arg0_8._parentClass:ShowItemDetail(var0_20)
			end, SFX_PANEL)
		end)
	end

	local function var10_8()
		local var0_22 = arg0_8._tf:Find("Frame/Scroll/Content/Lack/List")

		setActive(var0_22.parent, #var4_8 > 0)

		if #var4_8 == 0 then
			return
		end

		local var1_22 = CustomIndexLayer.Clone2Full(var0_22, #var4_8)

		table.Foreach(var1_22, function(arg0_23, arg1_23)
			local var0_23 = var4_8[arg0_23]

			arg0_8._parentClass:UpdateRyzaItem(arg1_23:Find("IconBG"), var0_23, true)
			onButton(arg0_8, arg1_23, function()
				arg0_8._parentClass:ShowItemDetail(var0_23)
			end, SFX_PANEL)
		end)
	end

	var9_8()
	var10_8()
end

function var0_0.HideMaterialsPreview(arg0_25)
	if not isActive(arg0_25._go) then
		return
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25._tf, arg0_25._parentClass._tf)
	setActive(arg0_25._go, false)

	return true
end

function var0_0.willExit(arg0_26)
	arg0_26:detach()
end

return var0_0
