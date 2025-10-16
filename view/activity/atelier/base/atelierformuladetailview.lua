local var0_0 = class("AtelierFormulaDetailView", import("view.base.BasePanel"))
local var1_0 = import("Mgr.Pool.PoolPlural")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1
	arg0_1.bundleName = arg2_1.bundleName
	arg0_1.commonBundleName = arg2_1.commonBundleName

	arg0_1:attach(arg2_1)
	arg0_1:Init()
	arg0_1:InitStr()

	arg0_1.layerFormulaDescriptionPanel = arg0_1._tf:Find("Overlay/Description")

	arg0_1:InitCustom()
end

function var0_0.InitCustom(arg0_2)
	arg0_2.atelierFormulaOverlayView = AtelierFormulaOverlayView.New(arg0_2.layerFormulaDescriptionPanel, arg0_2._parentClass)
end

function var0_0.Init(arg0_3)
	arg0_3.viewContent = arg0_3._parentClass.scrollView:Find("Content")

	setActive(arg0_3._go, false)
end

function var0_0.SetContextData(arg0_4, arg1_4)
	arg0_4.contextData = arg1_4

	arg0_4.atelierFormulaOverlayView:SetContextData(arg1_4)
end

function var0_0.SetActivity(arg0_5, arg1_5)
	arg0_5.activity = arg1_5

	arg0_5.atelierFormulaOverlayView:SetActivity(arg1_5)
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("Composite"), function()
		arg0_6:OnClickComposite()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("AutoFill"), function()
		arg0_6:OnClickAutoFill()
	end, SFX_PANEL)
	arg0_6.atelierFormulaOverlayView:didEnter()
end

function var0_0.Show(arg0_9, arg1_9)
	setActive(arg0_9._go, true)
	arg0_9.atelierFormulaOverlayView:RefreshFormulaInfo(arg1_9)

	arg0_9.unLockLayerIndex = 1

	if not arg0_9.nodePools then
		arg0_9.nodePools = {
			circle = var1_0.New(arg0_9._tf:Find("CircleNode").gameObject, 100),
			hexagon = var1_0.New(arg0_9._tf:Find("HexagonNode").gameObject, 100),
			anyHexagon = var1_0.New(arg0_9._tf:Find("AnyHexagonNode").gameObject, 100),
			doubleHexagon = var1_0.New(arg0_9._tf:Find("DoubleHexagonNode").gameObject, 100)
		}

		table.Foreach(arg0_9.nodePools, function(arg0_10, arg1_10)
			setActive(arg1_10.prefab, false)
		end)
	end

	arg0_9.pluralRoot = arg0_9.pluralRoot or pg.PoolMgr.GetInstance().root
	arg0_9.nodeList = arg0_9.nodeList or {}

	_.each(arg0_9.nodeList, function(arg0_11)
		local var0_11 = arg0_9.nodePools[arg0_9.poolNames[arg0_11.Data:GetType()]]
		local var1_11 = tf(arg0_11.GO)

		SetComponentEnabled(var1_11:Find("Item"), typeof(Image), false)
		arg0_9._parentClass.loader:ClearRequest(var1_11:Find("Ring"))
		arg0_9:CleanNodeLinks(arg0_11)
		arg0_9._parentClass.loader:ClearRequest(var1_11)

		if not var0_11:Enqueue(go(arg0_11.GO)) then
			setParent(go(arg0_11.GO), arg0_9.pluralRoot)
			setActive(go(arg0_11.GO), false)
		end
	end)
	table.clean(arg0_9.nodeList)
	setAnchoredPosition(arg0_9.viewContent, Vector2.zero)

	local var0_9 = 0

	_.each(arg1_9:GetCircleList(), function(arg0_12)
		local var0_12 = AtelierFormulaCircle.New({
			configId = arg0_12
		})
		local var1_12 = arg0_9.nodePools[arg0_9.poolNames[var0_12:GetType()]]:Dequeue()

		var1_12.name = arg0_12

		setActive(var1_12, true)
		setParent(tf(var1_12), arg0_9.viewContent)

		var0_9 = var0_9 + 1

		local var2_12 = {
			Change = true,
			ID = var0_9,
			Data = var0_12,
			GO = var1_12
		}

		table.insert(arg0_9.nodeList, var2_12)
	end)
	arg0_9:InitNodeLayer()
	arg0_9:SetCirclePanel()
	arg0_9:UpdateFormulaDetail()
end

function var0_0.OnClickComposite(arg0_13)
	if not _.all(arg0_13.nodeList, function(arg0_14)
		return arg0_14.Instance
	end) then
		arg0_13._parentClass:ShowMaterialsPreview()

		return
	end

	if not arg0_13.activity:GetFormulas()[arg0_13.contextData.formulaId]:IsAvaliable() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

		return
	end

	arg0_13._parentClass:ShowCompositeConfirmWindow(arg0_13.nodeList)
end

function var0_0.OnClickAutoFill(arg0_15)
	arg0_15.temps = {}

	local var0_15 = {}

	_.each(arg0_15.nodeList, function(arg0_16)
		local var0_16 = arg0_16.Instance

		if var0_16 then
			arg0_15:UseMat(var0_16)
		else
			table.insert(var0_15, arg0_16)
		end
	end)

	if #var0_15 <= 0 then
		return
	end

	arg0_15:AutoFillAllNode(var0_15)
end

function var0_0.UseMat(arg0_17, arg1_17)
	local var0_17 = arg0_17.temps[arg1_17:GetConfigID()] or Clone(arg0_17.activity:GetItems()[arg1_17:GetConfigID()])

	var0_17.count = var0_17.count - 1
	arg0_17.temps[arg1_17:GetConfigID()] = var0_17
end

function var0_0.FillNode(arg0_18, arg1_18, arg2_18)
	local var0_18 = {}

	table.insert(var0_18, function(arg0_19)
		arg0_18:FillNodeAndPlayAnim(arg1_18, AtelierMaterial.New({
			count = 1,
			configId = arg2_18:GetConfigID()
		}), arg0_19, true)
	end)

	local var1_18 = arg0_18.unLockLayerIndex
	local var2_18 = _.select(arg0_18.nodeLayer[var1_18], function(arg0_20)
		return arg0_18.nodeList[arg0_20].Instance == nil
	end)

	if var1_18 < #arg0_18.nodeLayer and #var2_18 == 1 and var2_18[1] == arg1_18.ID then
		table.insert(var0_18, function(arg0_21)
			arg0_18:DisPlayUnlockEffect(var1_18 + 1, arg0_21)
		end)
	end

	table.insert(var0_18, function(arg0_22)
		arg0_18:UpdateFormulaDetail()
		arg0_22()
	end)
	seriesAsync(var0_18)
end

function var0_0.AutoFillAllNode(arg0_23, arg1_23)
	local var0_23 = {}
	local var1_23 = false

	for iter0_23, iter1_23 in ipairs(arg0_23.nodeLayer) do
		local var2_23 = {}

		for iter2_23, iter3_23 in ipairs(iter1_23) do
			local var3_23 = arg0_23.nodeList[iter3_23]

			if var3_23 and var3_23.Instance ~= nil then
				-- block empty
			else
				table.insert(var2_23, var3_23)
			end
		end

		if #var2_23 > 0 then
			local var4_23 = false

			if iter0_23 == 1 then
				for iter4_23, iter5_23 in ipairs(var2_23) do
					local var5_23 = iter5_23.Data
					local var6_23 = var5_23:GetLimitItemID()

					if var6_23 ~= 0 then
						local var7_23 = arg0_23.temps[var6_23] or arg0_23.activity:GetItems()[var6_23]

						if var7_23 and var7_23.count > 0 then
							arg0_23:UseMat(var7_23)
							table.insert(var0_23, function(arg0_24)
								arg0_23:FillNodeAndPlayAnim(iter5_23, AtelierMaterial.New({
									count = 1,
									configId = var6_23
								}), arg0_24, true)
							end)
						else
							var4_23 = true
						end
					else
						local var8_23 = arg0_23.activity:GetFormulas()[arg0_23.contextData.formulaId]

						for iter6_23, iter7_23 in ipairs(arg0_23.circleTypeList) do
							if var5_23:GetType() == iter7_23 then
								local var9_23 = false

								for iter8_23, iter9_23 in ipairs(pg.activity_ryza_item.all) do
									local var10_23 = arg0_23.temps[iter9_23] or arg0_23.activity:GetItems()[iter9_23]

									if var10_23 and var10_23.count > 0 and var10_23:IsNormal() and var5_23:CanUseMaterial(var10_23, var8_23, arg0_23.contextData.versionIndex) then
										arg0_23:UseMat(var10_23)
										table.insert(var0_23, function(arg0_25)
											arg0_23:FillNodeAndPlayAnim(iter5_23, AtelierMaterial.New({
												count = 1,
												configId = var10_23:GetConfigID()
											}), arg0_25, true)
										end)

										var9_23 = true

										break
									end
								end

								if not var9_23 then
									var4_23 = true
								end
							end
						end
					end
				end
			else
				table.insert(var0_23, function(arg0_26)
					arg0_23._parentClass:PlaySoundEffect(arg0_23._parentClass.soundStr.formulaDetail)
					arg0_26()
				end)

				local var11_23 = arg0_23.activity:GetFormulas()[arg0_23.contextData.formulaId]
				local var12_23 = {}

				for iter10_23, iter11_23 in ipairs(arg0_23.circleTypeList) do
					_.each(var2_23, function(arg0_27)
						local var0_27 = arg0_27.Data

						if var0_27:GetType() == iter11_23 then
							local var1_27 = false

							for iter0_27, iter1_27 in ipairs(pg.activity_ryza_item.all) do
								local var2_27 = arg0_23.temps[iter1_27] or arg0_23.activity:GetItems()[iter1_27]

								if var2_27 and var2_27.count > 0 and var2_27:IsNormal() and var0_27:CanUseMaterial(var2_27, var11_23, arg0_23.contextData.versionIndex) then
									arg0_23:UseMat(var2_27)
									table.insert(var12_23, function()
										arg0_23:FillNodeAndPlayAnim(arg0_27, AtelierMaterial.New({
											count = 1,
											configId = var2_27:GetConfigID()
										}), true)
									end)

									var1_27 = true

									break
								end
							end

							if not var1_27 then
								var4_23 = true
							end
						end
					end)
				end

				if #var12_23 > 0 then
					table.insert(var0_23, function(arg0_29)
						for iter0_29, iter1_29 in ipairs(var12_23) do
							iter1_29()
						end

						arg0_23._parentClass:managedTween(LeanTween.delayedCall, function()
							arg0_29()
						end, 0.7, nil)
					end)
				end
			end

			if var4_23 then
				var1_23 = true

				table.insert(var0_23, function(arg0_31)
					pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_material_not_enough"))
					arg0_31()
				end)

				break
			end

			if iter0_23 < #arg0_23.nodeLayer then
				table.insert(var0_23, function(arg0_32)
					arg0_23:DisPlayUnlockEffect(iter0_23 + 1, arg0_32)
				end)
			end
		end
	end

	if #var0_23 > 0 and (#var0_23 ~= 1 or not var1_23) then
		table.insert(var0_23, 1, function(arg0_33)
			arg0_23._parentClass:DispalyChat(arg0_23._parentClass.chatText.selectMaterial)
			arg0_33()
		end)
	end

	seriesAsync(var0_23)
end

function var0_0.FillNodeAndPlayAnim(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	arg0_34._parentClass:LoadingOn()

	arg1_34.ChangeInstance = arg1_34.ChangeInstance or tobool(arg1_34.Instance) ~= tobool(arg2_34)
	arg1_34.Instance = arg2_34
	arg1_34.Change = true

	local var0_34 = {}
	local var1_34 = {}

	seriesAsync({
		function(arg0_35)
			table.ParallelIpairsAsync({
				"ui/laisha_ui_wupinzhiru",
				"ui/laisha_ui_baoshi"
			}, function(arg0_36, arg1_36, arg2_36)
				var0_34[arg0_36] = arg0_34._parentClass.loader:GetPrefab(arg1_36, "", function(arg0_37)
					setParent(arg0_37, tf(arg1_34.GO))
					setAnchoredPosition(arg0_37, Vector2.zero)

					var1_34[arg0_36] = arg0_37

					setActive(arg0_37, false)
					arg2_36()
				end)
			end, arg0_35)
		end,
		function(arg0_38)
			setActive(var1_34[1], true)
			arg0_34._parentClass:managedTween(LeanTween.delayedCall, function()
				if not arg4_34 then
					for iter0_39, iter1_39 in ipairs(arg0_34.nodeLayer[arg0_34.unLockLayerIndex]) do
						arg0_34:UpdateNodeView(arg0_34.nodeList[iter1_39])
					end
				else
					arg0_34:UpdateNodeView(arg1_34)
				end

				arg0_34._parentClass:PlaySoundEffect(arg0_34._parentClass.soundStr.formulaDetailFill)
				arg0_38()
			end, 0.2, nil)
		end,
		function(arg0_40)
			setActive(var1_34[2], true)
			arg0_34._parentClass:managedTween(LeanTween.delayedCall, function()
				arg0_40()
			end, 0.5, nil)
		end,
		function(arg0_42)
			arg0_34._parentClass.loader:ClearRequest(var0_34[1])
			arg0_34._parentClass.loader:ClearRequest(var0_34[2])
			arg0_34._parentClass:LoadingOff()
			arg0_34:RefreshBtn()
			existCall(arg3_34)
		end
	})
end

function var0_0.DisPlayUnlockEffect(arg0_43, arg1_43, arg2_43)
	arg0_43._parentClass:LoadingOn()

	local var0_43 = {}

	for iter0_43, iter1_43 in ipairs(arg0_43.nodeLayer[arg1_43]) do
		local var1_43 = arg0_43.nodeList[iter1_43]
		local var2_43 = arg0_43._parentClass.loader:GetPrefab("ui/" .. arg0_43.unlockEffect, "", function(arg0_44)
			setParent(arg0_44, tf(var1_43.GO))
			setAnchoredPosition(arg0_44, Vector2.zero)
		end)

		table.insert(var0_43, var2_43)
	end

	arg0_43._parentClass:managedTween(LeanTween.delayedCall, function()
		arg0_43._parentClass:PlaySoundEffect(arg0_43._parentClass.soundStr.formulaDetailUnlock)
	end, 0.7, nil)
	arg0_43._parentClass:managedTween(LeanTween.delayedCall, function()
		_.each(var0_43, function(arg0_47)
			arg0_43._parentClass.loader:ClearRequest(arg0_47)
		end)
		arg0_43._parentClass:LoadingOff()

		arg0_43.unLockLayerIndex = arg1_43

		existCall(arg2_43)
	end, 1.7, nil)
end

function var0_0.UpdateFormulaDetail(arg0_48)
	_.each(arg0_48.nodeList, function(arg0_49)
		arg0_48:UpdateNodeView(arg0_49)
	end)
	arg0_48:RefreshBtn()
end

function var0_0.RefreshBtn(arg0_50)
	local var0_50 = #arg0_50.nodeList
	local var1_50 = #_.select(arg0_50.nodeList, function(arg0_51)
		return arg0_51.Instance ~= nil
	end)

	setText(arg0_50._tf:Find("Bar/Text"), i18n("ryza_tip_put_materials", var1_50, var0_50))
	setGray(arg0_50._tf:Find("AutoFill"), not arg0_50.activity:GetFormulas()[arg0_50.contextData.formulaId]:IsAvaliable())
	setActive(arg0_50._tf:Find("Composite/Disabled"), var1_50 < var0_50)
end

function var0_0.UpdateNodeView(arg0_52, arg1_52)
	arg0_52:RefreshNodeLinks(arg1_52)

	local var0_52 = tf(arg1_52.GO)
	local var1_52 = arg1_52.Data
	local var2_52 = var1_52:GetElementName()
	local var3_52 = arg0_52:IsLockNode(arg1_52)

	setActive(var0_52:Find("Lock"), var3_52)

	if var3_52 then
		if var1_52:GetType() ~= AtelierFormulaCircle.TYPE.ANY then
			arg0_52._parentClass.loader:GetSpriteQuiet(arg0_52.commonBundleName, "element_" .. var2_52, var0_52:Find("Lock/Require/Icon"))
		end

		setText(var0_52:Find("Lock/Require/Text"), "X" .. var1_52:GetLevel())
	end

	for iter0_52 = 3, var1_52:GetLevel() + 1, -1 do
		local var4_52 = var0_52:Find("Slots"):GetChild(iter0_52 - 1)

		arg0_52._parentClass.loader:GetSpriteQuiet(arg0_52.bundleName, "slot_BLOCKED", var4_52:Find("Image"))
	end

	local var5_52 = arg1_52.Instance
	local var6_52 = var0_52:Find("Item")

	if not var5_52 then
		if var1_52:GetType() == AtelierFormulaCircle.TYPE.ANY then
			setActive(var0_52:Find("All"), true)
		else
			setActive(var0_52:Find("Icon"), true)
			arg0_52._parentClass.loader:GetSpriteQuiet(arg0_52.bundleName, "icon_" .. var2_52, var0_52:Find("Icon"), true)
		end

		setActive(var6_52, false)

		if var1_52:GetType() == AtelierFormulaCircle.TYPE.BASE or var1_52:GetType() == AtelierFormulaCircle.TYPE.SAIREN then
			local var7_52 = AtelierMaterial.New({
				configId = var1_52:GetLimitItemID()
			})

			setActive(var0_52:Find("Name"), true)
			setScrollText(var0_52:Find("Name/Rect/Text"), var7_52:GetName())
		else
			setActive(var0_52:Find("Name"), false)
		end

		for iter1_52 = 1, var1_52:GetLevel() do
			local var8_52 = var0_52:Find("Slots"):GetChild(iter1_52 - 1)

			arg0_52._parentClass.loader:GetSpriteQuiet(arg0_52.bundleName, "slot_NULL", var8_52:Find("Image"))
		end
	else
		local var9_52 = var1_52:GetRingElement(var5_52)
		local var10_52 = AtelierFormulaCircle.ELEMENT_NAME[var9_52]

		if var1_52:GetType() == AtelierFormulaCircle.TYPE.ANY then
			setActive(var0_52:Find("All"), false)
		else
			setActive(var0_52:Find("Icon"), false)
		end

		setActive(var6_52, true)

		local var11_52

		if var1_52:GetType() == AtelierFormulaCircle.TYPE.BASE or var1_52:GetType() == AtelierFormulaCircle.TYPE.SAIREN then
			var11_52 = var5_52:GetBaseCircleTransform()
		else
			var11_52 = var5_52:GetNormalCircleTransform()
		end

		setLocalScale(var6_52, Vector3.New(unpack(var11_52, 1, 3)))
		setAnchoredPosition(var6_52, Vector2.New(unpack(var11_52, 4, 5)))
		arg0_52._parentClass.loader:GetSpriteQuiet(var5_52:GetIconPath(), "", var6_52, true)
		setActive(var0_52:Find("Name"), true)
		setScrollText(var0_52:Find("Name/Rect/Text"), var5_52:GetName())

		for iter2_52 = 1, var1_52:GetLevel() do
			local var12_52 = var0_52:Find("Slots"):GetChild(iter2_52 - 1)

			arg0_52._parentClass.loader:GetSpriteQuiet(arg0_52.bundleName, "slot_" .. var10_52, var12_52:Find("Image"))
		end
	end

	local var13_52 = var0_52:Find("Ring")

	setImageColor(var13_52, var1_52:GetElementRingColor(var5_52))

	if arg1_52.Change then
		local var14_52 = arg1_52.Data:GetRingElement(var5_52)

		if var3_52 then
			var14_52 = nil
		end

		if arg0_52.ringEffect[var14_52] then
			local var15_52 = arg1_52.Data:GetType() == AtelierFormulaCircle.TYPE.BASE and "_o" or "_6"

			arg0_52._parentClass.loader:GetPrefab("ui/" .. arg0_52.ringEffect[var14_52] .. var15_52, "", function(arg0_53)
				setParent(arg0_53, var13_52)
				setAnchoredPosition(arg0_53, Vector2.zero)
			end, var13_52)
		else
			arg0_52._parentClass.loader:ClearRequest(var13_52)
		end

		arg0_52:RefreshNodeLinkEffects(var0_52, arg1_52, var3_52)

		arg1_52.Change = nil
	end

	if arg1_52.ChangeInstance then
		if var5_52 then
			arg0_52._parentClass.loader:GetPrefab("ui/" .. arg0_52.deployEffect, "", function(arg0_54)
				setParent(arg0_54, var6_52)
				setAnchoredPosition(arg0_54, Vector2.zero)
			end, var0_52)
		else
			arg0_52._parentClass.loader:ClearRequest(var0_52)
		end

		arg1_52.ChangeInstance = nil
	end

	onButton(arg0_52, var0_52, function()
		if var3_52 then
			return
		end

		arg0_52._parentClass:ShowMaterialSelectWindow(var0_52, arg1_52, arg0_52.nodeList)
	end, SFX_PANEL)
end

function var0_0.IsLockNode(arg0_56, arg1_56)
	local var0_56 = 1

	for iter0_56, iter1_56 in ipairs(arg0_56.nodeLayer) do
		if _.detect(iter1_56, function(arg0_57)
			return arg0_56.nodeList[arg0_57] == arg1_56
		end) ~= ni then
			var0_56 = iter0_56

			break
		end
	end

	if var0_56 > arg0_56.unLockLayerIndex then
		return true
	end

	return false
end

function var0_0.willExit(arg0_58)
	arg0_58.atelierFormulaOverlayView:willExit()

	arg0_58.atelierFormulaOverlayView = nil

	arg0_58:detach()
end

function var0_0.InitStr(arg0_59)
	arg0_59.poolNames = {
		[AtelierFormulaCircle.TYPE.BASE] = "circle",
		[AtelierFormulaCircle.TYPE.NORMAL] = "hexagon",
		[AtelierFormulaCircle.TYPE.SAIREN] = "doubleHexagon",
		[AtelierFormulaCircle.TYPE.ANY] = "anyHexagon",
		[AtelierFormulaCircle.TYPE.NONE] = "circle",
		[AtelierFormulaCircle.TYPE.ELEMENT] = "hexagon",
		[AtelierFormulaCircle.TYPE.CATEGORY] = "doubleHexagon",
		[AtelierFormulaCircle.TYPE.ELEMENT_CATEGORY] = "doubleHexagon"
	}
	arg0_59.lineEffect = {
		"laisha_ui_lianjie01",
		"laisha_ui_lianjie02",
		"laisha_ui_lianjie_qiehuan"
	}
	arg0_59.ringEffect = {
		[AtelierFormulaCircle.ELEMENT_TYPE.PYRO] = "laisha_ui_huo",
		[AtelierFormulaCircle.ELEMENT_TYPE.CRYO] = "laisha_ui_bing",
		[AtelierFormulaCircle.ELEMENT_TYPE.ELECTRO] = "laisha_ui_lei",
		[AtelierFormulaCircle.ELEMENT_TYPE.ANEMO] = "laisha_ui_feng",
		[AtelierFormulaCircle.ELEMENT_TYPE.SAIREN] = "laisha_ui_sairen"
	}
	arg0_59.deployEffect = "laisha_ui_wupinshanguang"
	arg0_59.unlockEffect = "laisha_ui_jiesuo"
	arg0_59.circleTypeList = {
		AtelierFormulaCircle.TYPE.BASE,
		AtelierFormulaCircle.TYPE.NORMAL,
		AtelierFormulaCircle.TYPE.SAIREN,
		AtelierFormulaCircle.TYPE.ANY
	}
end

function var0_0.InitNodeLayer(arg0_60)
	arg0_60.nodeLayer = {
		{}
	}

	for iter0_60, iter1_60 in pairs(arg0_60.nodeList) do
		local var0_60 = iter1_60.Data:GetType()

		if var0_60 == AtelierFormulaCircle.TYPE.BASE or var0_60 == AtelierFormulaCircle.TYPE.SAIREN then
			arg0_60.nodeLayer[1] = arg0_60.nodeLayer[1] or {}

			table.insert(arg0_60.nodeLayer[1], iter0_60)
		else
			arg0_60.nodeLayer[2] = arg0_60.nodeLayer[2] or {}

			table.insert(arg0_60.nodeLayer[2], iter0_60)
		end
	end

	for iter2_60 = #arg0_60.nodeLayer, 1, -1 do
		if #arg0_60.nodeLayer[iter2_60] == 0 then
			table.remove(arg0_60.nodeLayer, iter2_60)
		end
	end
end

function var0_0.SetCirclePanel(arg0_61)
	local var0_61 = 280
	local var1_61 = math.deg2Rad * 30

	arg0_61.axisX, arg0_61.axisY = var0_61 * Vector2.New(math.cos(var1_61), math.sin(var1_61)), var0_61 * Vector2(0, 1)
	arg0_61.viewMax = Vector2.zero

	arg0_61:SetCirclePosition(arg0_61.nodeList[1], Vector2.zero)
	setSizeDelta(arg0_61.viewContent, (arg0_61.viewMax + Vector2.New(var0_61, var0_61)) * 2)
end

local var2_0 = {
	{
		0,
		1
	},
	{
		-1,
		1
	},
	{
		-1,
		0
	},
	{
		0,
		-1
	},
	{
		1,
		-1
	},
	{
		1,
		0
	}
}

function var0_0.SetCirclePosition(arg0_62, arg1_62, arg2_62)
	setAnchoredPosition(arg1_62.GO, arg2_62)

	local var0_62 = arg1_62.Data:GetNeighbors()

	arg1_62.links = {}

	_.each(var0_62, function(arg0_63)
		local var0_63 = arg0_63[1]
		local var1_63 = arg0_63[2]
		local var2_63 = var2_0[var0_63]
		local var3_63 = var2_63[1] * arg0_62.axisX + var2_63[2] * arg0_62.axisY
		local var4_63 = _.detect(arg0_62.nodeList, function(arg0_64)
			return arg0_64.Data:GetConfigID() == var1_63
		end)

		var4_63.prevLink = {
			(var0_63 + 2) % 5 + 1,
			arg1_62
		}
		arg1_62.links[var0_63] = var4_63

		local var5_63 = arg2_62 + var3_63

		arg0_62:SetCirclePosition(var4_63, var5_63)

		arg0_62.viewMax = Vector2.Max(arg0_62.viewMax, -var5_63)
		arg0_62.viewMax = Vector2.Max(arg0_62.viewMax, var5_63)
	end)
end

function var0_0.RefreshNodeLinks(arg0_65, arg1_65)
	local var0_65 = tf(arg1_65.GO)

	for iter0_65 = 1, 6 do
		setActive(var0_65:Find("Links"):GetChild(iter0_65 - 1), false)
	end

	local var1_65 = arg1_65.Data

	_.each(var1_65:GetNeighbors(), function(arg0_66)
		setActive(var0_65:Find("Links"):GetChild(arg0_66[1] - 1), true)
	end)
end

function var0_0.RefreshNodeLinkEffects(arg0_67, arg1_67, arg2_67, arg3_67)
	table.Foreach(arg2_67.links, function(arg0_68, arg1_68)
		local var0_68 = arg1_67:Find("Links/" .. arg0_68)
		local var1_68 = arg0_67.lineEffect[3]

		if arg1_68.Lock and arg3_67 then
			var1_68 = arg0_67.lineEffect[1]
		elseif not arg1_68.Lock and not arg3_67 then
			var1_68 = arg0_67.lineEffect[2]
		end

		arg0_67._parentClass.loader:GetPrefab("ui/" .. var1_68, "", function(arg0_69)
			setParent(arg0_69, var0_68:Find("Link"))
			setAnchoredPosition(arg0_69, Vector2.New(0, -15))
		end, var0_68)
	end)
end

function var0_0.CleanNodeLinks(arg0_70, arg1_70)
	table.Foreach(arg1_70.links, function(arg0_71)
		local var0_71 = nodeTF:Find("Links/" .. arg0_71)

		arg0_70._parentClass.loader:ClearRequest(var0_71)
	end)
end

return var0_0
