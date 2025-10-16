local var0_0 = class("AtelierFormulaDetailYumiaView", import("view.activity.Atelier.base.AtelierFormulaDetailView"))
local var1_0 = import("Mgr.Pool.PoolPlural")

function var0_0.InitCustom(arg0_1)
	arg0_1.atelierFormulaOverlayView = AtelierFormulaOverlayYumiaView.New(arg0_1.layerFormulaDescriptionPanel, arg0_1._parentClass)
	arg0_1.compositePanel = arg0_1._tf:Find("Overlay/compositePanel")
	arg0_1.tipsText = arg0_1._tf:Find("tips/Text")

	setText(arg0_1._tf:Find("Overlay/compositePanel/backBtn/Text"), i18n("yumia_atelier_tip9"))
	setText(arg0_1._tf:Find("Overlay/compositePanel/CompositeBtn/Text"), i18n("yumia_atelier_tip18"))
	setText(arg0_1._tf:Find("Overlay/compositePanel/autoBtn/Text"), i18n("yumia_atelier_tip23"))

	arg0_1.lineGoList = {
		arg0_1._tf:Find("ScrollView/Content/lineGo1"),
		arg0_1._tf:Find("ScrollView/Content/lineGo2"),
		arg0_1._tf:Find("ScrollView/Content/lineGo3")
	}

	SetComponentEnabled(arg0_1._parentClass.scrollView, typeof(ScrollRect), false)
end

function var0_0.didEnter(arg0_2)
	arg0_2.atelierFormulaOverlayView:didEnter()
	onButton(arg0_2, arg0_2._tf:Find("Overlay/compositePanel/CompositeBtn"), function()
		arg0_2:OnClickComposite()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("Overlay/compositePanel/backBtn"), function()
		arg0_2._parentClass:OnClickFormulaBack()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("Overlay/compositePanel/autoBtn"), function()
		arg0_2:OnClickAutoFill()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	setActive(arg0_6._go, true)

	arg0_6.unLockLayerIndex = 1

	if not arg0_6.nodePools then
		arg0_6.nodePools = {
			core = var1_0.New(arg0_6._tf:Find("coreNode").gameObject, 100),
			material = var1_0.New(arg0_6._tf:Find("materialNode").gameObject, 100)
		}

		table.Foreach(arg0_6.nodePools, function(arg0_7, arg1_7)
			setActive(arg1_7.prefab, false)
		end)
	end

	arg0_6.pluralRoot = arg0_6.pluralRoot or pg.PoolMgr.GetInstance().root
	arg0_6.nodeList = arg0_6.nodeList or {}

	_.each(arg0_6.nodeList, function(arg0_8)
		local var0_8 = arg0_6.nodePools[arg0_8.GoType]
		local var1_8 = tf(arg0_8.GO)

		arg0_6._parentClass.loader:ClearRequest(var1_8)

		if not var0_8:Enqueue(go(arg0_8.GO)) then
			setParent(go(arg0_8.GO), arg0_6.pluralRoot)
			setActive(go(arg0_8.GO), false)
		end
	end)
	table.clean(arg0_6.nodeList)
	setAnchoredPosition(arg0_6.viewContent, Vector2.zero)

	local var0_6 = 0

	_.each(arg1_6:GetCircleList(), function(arg0_9)
		local var0_9 = AtelierFormulaCircle.New({
			configId = arg0_9
		})
		local var1_9
		local var2_9 = var0_9:GetNeighbors()[1] == 1 and "core" or "material"
		local var3_9 = arg0_6.nodePools[var2_9]:Dequeue()

		var3_9.name = arg0_9

		setActive(var3_9, true)
		setParent(tf(var3_9), arg0_6.viewContent)

		var0_6 = var0_6 + 1

		local var4_9 = {
			Change = true,
			ID = var0_6,
			Data = var0_9,
			GO = var3_9,
			GoType = var2_9
		}

		table.insert(arg0_6.nodeList, var4_9)

		if var0_9:GetNeighbors()[1] ~= 1 then
			arg0_6:HideNodeLight(var4_9)
		end

		setActive(var3_9:Find("select"), false)
	end)
	arg0_6:InitNodeLayer()
	arg0_6:SetCirclePanel()
	arg0_6:UpdateFormulaDetail()
	arg0_6:InitLine(arg1_6)
	arg0_6.atelierFormulaOverlayView:RefreshFormulaInfo(arg1_6)
	arg0_6:RefreshScrollViewPosition()
end

function var0_0.UpdateNodeView(arg0_10, arg1_10)
	local var0_10 = tf(arg1_10.GO)
	local var1_10 = arg1_10.Data
	local var2_10 = var1_10:GetElementName()
	local var3_10 = arg0_10:IsLockNode(arg1_10)

	setActive(arg1_10.GO, not var3_10)

	local var4_10 = arg1_10.Instance

	if table.contains(arg0_10.nodeLayer[1], arg1_10.ID) then
		-- block empty
	else
		local var5_10 = var1_10:GetType()

		if var5_10 == AtelierFormulaCircle.TYPE.NONE then
			arg0_10:RefreshElement(arg1_10)
			arg0_10:HideCategory(arg1_10)
		elseif var5_10 == AtelierFormulaCircle.TYPE.ELEMENT then
			arg0_10:RefreshElement(arg1_10)
			arg0_10:HideCategory(arg1_10)
		elseif var5_10 == AtelierFormulaCircle.TYPE.CATEGORY then
			arg0_10:RefreshElement(arg1_10)
			arg0_10:RefreshCategory(arg1_10)
		elseif var5_10 == AtelierFormulaCircle.TYPE.ELEMENT_CATEGORY then
			arg0_10:RefreshElement(arg1_10)
			arg0_10:RefreshCategory(arg1_10)
		end

		if var4_10 == nil then
			arg0_10:AddStarList(arg1_10)
		end
	end

	onButton(arg0_10, var0_10, function()
		if var3_10 then
			return
		end

		arg0_10._parentClass:ShowMaterialSelectWindow(var0_10, arg1_10, arg0_10.nodeList)
	end, SFX_PANEL)
end

function var0_0.RefreshElement(arg0_12, arg1_12)
	local var0_12 = tf(arg1_12.GO)
	local var1_12 = arg1_12.Data
	local var2_12 = var1_12:GetProp()

	GetImageSpriteFromAtlasAsync("ui/ateliercommonyumiaui_atlas", "slot_" .. AtelierFormulaCircle.ELEMENT_NAME[var2_12], var0_12:Find("icon"))

	local var3_12 = var0_12:Find("light")

	setImageColor(var3_12, var1_12:GetElementLightColor(instance))
end

function var0_0.RefreshCategory(arg0_13, arg1_13)
	local var0_13 = tf(arg1_13.GO)
	local var1_13 = arg1_13.Data:GetCategory()

	if var1_13 ~= 0 then
		GetImageSpriteFromAtlasAsync("ui/ateliercommonyumiaui_atlas", "category" .. var1_13, var0_13:Find("categoryBg/category"))
	end

	setActive(var0_13:Find("categoryBg"), true)
end

function var0_0.HideCategory(arg0_14, arg1_14)
	local var0_14 = tf(arg1_14.GO)

	setActive(var0_14:Find("categoryBg"), false)
end

function var0_0.DisPlayUnlockEffect(arg0_15, arg1_15, arg2_15)
	arg0_15.unLockLayerIndex = arg1_15

	arg0_15:RefreshLine()

	for iter0_15, iter1_15 in ipairs(arg0_15.nodeLayer[arg1_15]) do
		local var0_15 = arg0_15.nodeList[iter1_15]

		arg0_15:UpdateNodeView(var0_15)
	end

	existCall(arg2_15)
end

function var0_0.FillNodeAndPlayAnim(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	arg0_16._parentClass:LoadingOn()

	arg1_16.ChangeInstance = arg1_16.ChangeInstance or tobool(arg1_16.Instance) ~= tobool(arg2_16)
	arg1_16.Instance = arg2_16
	arg1_16.Change = true

	local var0_16 = {}
	local var1_16 = {}

	seriesAsync({
		function(arg0_17)
			table.ParallelIpairsAsync({
				"ui/laisha_ui_wupinzhiru",
				"ui/laisha_ui_baoshi"
			}, function(arg0_18, arg1_18, arg2_18)
				var0_16[arg0_18] = arg0_16._parentClass.loader:GetPrefab(arg1_18, "", function(arg0_19)
					setParent(arg0_19, tf(arg1_16.GO))
					setAnchoredPosition(arg0_19, Vector2.zero)

					var1_16[arg0_18] = arg0_19

					setActive(arg0_19, false)
					arg2_18()
				end)
			end, arg0_17)
		end,
		function(arg0_20)
			setActive(var1_16[1], true)
			arg0_16:PlayStarAnimation(arg1_16)
			arg0_16._parentClass:managedTween(LeanTween.delayedCall, function()
				if not arg4_16 then
					for iter0_21, iter1_21 in ipairs(arg0_16.nodeLayer[arg0_16.unLockLayerIndex]) do
						arg0_16:UpdateNodeView(arg0_16.nodeList[iter1_21])
					end
				else
					arg0_16:UpdateNodeView(arg1_16)
				end

				arg0_16._parentClass:PlaySoundEffect(arg0_16._parentClass.soundStr.formulaDetailFill)
				arg0_20()
			end, 0.2, nil)
		end,
		function(arg0_22)
			setActive(var1_16[2], true)
			arg0_16._parentClass:managedTween(LeanTween.delayedCall, function()
				arg0_22()
			end, 0.5, nil)
		end,
		function(arg0_24)
			arg0_16._parentClass.loader:ClearRequest(var0_16[1])
			arg0_16._parentClass.loader:ClearRequest(var0_16[2])
			arg0_16._parentClass:LoadingOff()
			arg0_16:RefreshBtn()
			existCall(arg3_16)
		end
	})
end

function var0_0.InitLine(arg0_25, arg1_25)
	local var0_25 = arg1_25:GetShapeID()

	for iter0_25, iter1_25 in ipairs(arg0_25.lineGoList) do
		setActive(iter1_25, iter0_25 == var0_25)

		if iter0_25 == var0_25 then
			arg0_25.lineGo = iter1_25
		end
	end

	arg0_25:RefreshLine()
end

function var0_0.RefreshLine(arg0_26)
	for iter0_26 = 0, arg0_26.lineGo.childCount - 1 do
		setActive(arg0_26.lineGo:GetChild(iter0_26), iter0_26 < arg0_26.unLockLayerIndex - 1)
	end
end

function var0_0.RefreshBtn(arg0_27)
	return
end

function var0_0.RefreshScrollViewPosition(arg0_28)
	if arg0_28.nodeList[1].Instance == nil then
		setAnchoredPosition(arg0_28._parentClass.scrollView, Vector2.zero)
		setAnchoredPosition(arg0_28.viewContent, Vector2.zero)
		arg0_28.atelierFormulaOverlayView:Show(true)
		arg0_28._parentClass:ShowTopBar(false)
		arg0_28:HideCompositePanel()
		setText(arg0_28.tipsText, i18n("yumia_atelier_tip7"))
	else
		arg0_28:HideDescriptionView()
		arg0_28:ShowCompositePanel()
		setText(arg0_28.tipsText, i18n("yumia_atelier_tip17"))
	end
end

function var0_0.HideDescriptionView(arg0_29)
	arg0_29.atelierFormulaOverlayView:Show(false)
	arg0_29._parentClass:ShowTopBar(true)
	setAnchoredPosition(arg0_29._parentClass.scrollView, Vector2(-397, 0))
end

function var0_0.ShowCompositePanel(arg0_30)
	setActive(arg0_30.compositePanel, true)
end

function var0_0.HideCompositePanel(arg0_31)
	setActive(arg0_31.compositePanel, false)
end

function var0_0.AddStarList(arg0_32, arg1_32)
	local var0_32 = arg1_32.Data
	local var1_32 = var0_32:GetStarList()
	local var2_32 = arg1_32.GO:Find("starContant")

	arg0_32:HideStarList(arg1_32)

	if type(var1_32) ~= "table" then
		return
	end

	for iter0_32, iter1_32 in ipairs(var0_32:GetStarList()) do
		local var3_32 = iter0_32 <= var2_32.childCount and var2_32:GetChild(iter0_32 - 1) or cloneTplTo(var2_32:GetChild(0), var2_32)

		setActive(var3_32, true)
		setAnchoredPosition(var3_32, Vector2(unpack(iter1_32)))
	end
end

function var0_0.PlayStarAnimation(arg0_33, arg1_33)
	local var0_33 = arg1_33.Data:GetStarList()

	arg0_33:ShowNodeLight(arg1_33)

	if type(var0_33) ~= "table" then
		return
	end

	local var1_33 = arg1_33.GO:Find("starContant")

	for iter0_33 = 0, var1_33.childCount - 1 do
		arg0_33._parentClass:managedTween(LeanTween.moveLocal, nil, var1_33:GetChild(iter0_33).gameObject, Vector3.zero, 0.5)
	end

	arg0_33._parentClass:managedTween(LeanTween.delayedCall, function()
		arg0_33:HideStarList(arg1_33)
	end, 0.5, nil)
end

function var0_0.HideStarList(arg0_35, arg1_35)
	local var0_35 = arg1_35.GO:Find("starContant")

	for iter0_35 = 0, var0_35.childCount - 1 do
		setActive(var0_35:GetChild(iter0_35), false)
	end
end

function var0_0.ShowNodeLight(arg0_36, arg1_36)
	if arg1_36.Data:GetNeighbors()[1] == 1 then
		return
	end

	setActive(arg1_36.GO:Find("light"), true)
end

function var0_0.HideNodeLight(arg0_37, arg1_37)
	setActive(arg1_37.GO:Find("light"), false)
end

function var0_0.InitStr(arg0_38)
	arg0_38.ringEffect = {
		[AtelierFormulaCircle.ELEMENT_TYPE.PYRO] = "laisha_ui_huo",
		[AtelierFormulaCircle.ELEMENT_TYPE.CRYO] = "laisha_ui_bing",
		[AtelierFormulaCircle.ELEMENT_TYPE.ELECTRO] = "laisha_ui_lei",
		[AtelierFormulaCircle.ELEMENT_TYPE.ANEMO] = "laisha_ui_feng",
		[AtelierFormulaCircle.ELEMENT_TYPE.SAIREN] = "laisha_ui_sairen"
	}
	arg0_38.deployEffect = "laisha_ui_wupinshanguang"
	arg0_38.unlockEffect = "laisha_ui_jiesuo"
	arg0_38.circleTypeList = {
		AtelierFormulaCircle.TYPE.ELEMENT_CATEGORY,
		AtelierFormulaCircle.TYPE.CATEGORY,
		AtelierFormulaCircle.TYPE.ELEMENT,
		AtelierFormulaCircle.TYPE.NONE
	}
end

function var0_0.InitNodeLayer(arg0_39)
	arg0_39.nodeLayer = {
		{}
	}

	for iter0_39, iter1_39 in ipairs(arg0_39.nodeList) do
		local var0_39 = iter1_39.Data:GetNeighbors()

		arg0_39.nodeLayer[var0_39[1]] = arg0_39.nodeLayer[var0_39[1]] or {}

		table.insert(arg0_39.nodeLayer[var0_39[1]], iter0_39)
	end
end

function var0_0.SetCirclePanel(arg0_40)
	local var0_40 = 280

	arg0_40:SetCirclePosition()
	setSizeDelta(arg0_40.viewContent, (arg0_40.viewMax + Vector2.New(var0_40, var0_40)) * 2)
end

function var0_0.SetCirclePosition(arg0_41)
	local var0_41 = 0
	local var1_41 = 0

	_.each(arg0_41.nodeList, function(arg0_42)
		local var0_42 = arg0_42.Data:GetNeighbors()
		local var1_42 = Vector2(var0_42[2], var0_42[3])

		setAnchoredPosition(arg0_42.GO, var1_42)

		var0_41 = math.max(var0_41, math.abs(var0_42[2]))
		var1_41 = math.max(var1_41, math.abs(var0_42[3]))
	end)

	arg0_41.viewMax = Vector2(var0_41, var1_41)
end

return var0_0
