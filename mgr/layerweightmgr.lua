pg = pg or {}

local var0_0 = pg

var0_0.LayerWeightMgr = singletonClass("LayerWeightMgr")

local var1_0 = var0_0.LayerWeightMgr

var1_0.DEBUG = false
var1_0.ADAPT_TAG = "(Adapt)"
var1_0.RECYCLE_ADAPT_TAG = "recycleAdapt"

function var1_0.Init(arg0_1, arg1_1)
	arg0_1.baseParent = tf(GameObject.Find("UICamera/Canvas"))

	local var0_1 = tf(GameObject.Find("UICamera/Canvas/UIMain"))

	arg0_1.uiOrigin = tf(instantiate(var0_1))
	arg0_1.uiOrigin.name = "UIOrigin"

	arg0_1.uiOrigin:SetParent(arg0_1.baseParent, false)

	arg0_1.originCanvas = GetOrAddComponent(arg0_1.uiOrigin, typeof(Canvas))
	arg0_1.originCanvas.overrideSorting = true
	arg0_1.originCanvas.sortingOrder = 200
	arg0_1.originCast = GetOrAddComponent(arg0_1.uiOrigin, typeof(GraphicRaycaster))
	arg0_1.lvCameraTf = tf(GameObject.Find("LevelCamera"))
	arg0_1.lvParent = tf(GameObject.Find("LevelCamera/Canvas"))
	arg0_1.lvCamera = GetOrAddComponent(arg0_1.lvCameraTf, typeof(Camera))
	arg0_1.adaptPool = {}
	arg0_1.UIMain = rtf(GameObject.Find("UICamera/Canvas/UIMain"))
	arg0_1.OverlayMain = rtf(GameObject.Find("OverlayCamera/Overlay/UIMain"))
	arg0_1.OverlayAdapt = rtf(GameObject.Find("OverlayCamera/Overlay/UIAdapt"))
	arg0_1.OverlayTop = rtf(GameObject.Find("OverlayCamera/Overlay/UIOverlay"))
	arg0_1.storeUIs = {}

	if arg1_1 ~= nil then
		arg1_1()
	end
end

function var1_0.CreateRefreshHandler(arg0_2)
	if not arg0_2.luHandle then
		arg0_2.luHandle = LateUpdateBeat:CreateListener(arg0_2.Refresh, arg0_2)

		LateUpdateBeat:AddListener(arg0_2.luHandle)
	end
end

function var1_0.ClearRefreshHandler(arg0_3)
	if arg0_3.luHandle then
		LateUpdateBeat:RemoveListener(arg0_3.luHandle)

		arg0_3.luHandle = nil
	end
end

function var1_0.Refresh(arg0_4)
	arg0_4:LayerSortHandler()
	arg0_4:ClearRefreshHandler()
end

function var1_0.Add2Overlay(arg0_5, arg1_5, arg2_5, arg3_5)
	arg3_5.type = arg1_5
	arg3_5.ui = arg2_5
	arg3_5.pbList = arg3_5.pbList or {}
	arg3_5.weight = arg3_5.weight or LayerWeightConst.BASE_LAYER
	arg3_5.overlayType = arg3_5.overlayType or LayerWeightConst.OVERLAY_UI_MAIN
	arg3_5.visible = true

	local var0_5

	if arg0_5.lvCamera.enabled then
		var0_5 = {
			var0_0.UIMgr.CameraLevel
		}
	else
		var0_5 = {
			var0_0.UIMgr.CameraUI
		}
	end

	arg3_5.blurCamList = arg3_5.blurCamList or var0_5

	if arg1_5 == LayerWeightConst.UI_TYPE_SYSTEM and #arg0_5.storeUIs > 0 or arg1_5 == LayerWeightConst.UI_TYPE_SUB or arg1_5 == LayerWeightConst.UI_TYPE_OVERLAY_FOREVER then
		arg0_5:Log("ui：" .. arg2_5.gameObject.name .. " 加入了ui层级管理, weight:" .. arg3_5.weight)

		local var1_5 = arg0_5:DelList(arg2_5)

		arg0_5:ClearBlurData(var1_5)
		table.insert(arg0_5.storeUIs, arg3_5)
		arg0_5:CreateRefreshHandler()
	end
end

function var1_0.DelFromOverlay(arg0_6, arg1_6, arg2_6)
	arg0_6:Log("ui：" .. arg1_6.gameObject.name .. " 去除了ui层级管理")

	local var0_6 = arg0_6:DelList(arg1_6)

	if var0_6 ~= nil then
		local var1_6 = var0_6.ui
		local var2_6 = arg0_6:GetAdaptObjFromUI(var1_6)

		if var2_6 == nil then
			var2_6 = var1_6
		end

		local var3_6 = GetOrAddComponent(var2_6, typeof(CanvasGroup))

		var3_6.interactable = true
		var3_6.blocksRaycasts = true

		arg0_6:CheckRecycleAdaptObj(var1_6, arg2_6)
		arg0_6:ClearBlurData(var0_6)
	end

	arg0_6:CreateRefreshHandler()
end

function var1_0.DelList(arg0_7, arg1_7)
	local var0_7

	for iter0_7 = #arg0_7.storeUIs, 1, -1 do
		if arg0_7.storeUIs[iter0_7].ui == arg1_7 then
			var0_7 = arg0_7.storeUIs[iter0_7]

			table.remove(arg0_7.storeUIs, iter0_7)

			break
		end
	end

	return var0_7
end

function var1_0.ClearBlurData(arg0_8, arg1_8)
	if arg1_8 == nil then
		return
	end

	if arg1_8.pbList ~= nil then
		var0_0.UIMgr.GetInstance():RevertPBMaterial(arg1_8.pbList)
	end

	local var0_8 = arg1_8.lockGlobalBlur

	if var0_8 then
		local var1_8 = arg1_8.blurCamList

		for iter0_8, iter1_8 in ipairs({
			var0_0.UIMgr.CameraUI,
			var0_0.UIMgr.CameraLevel
		}) do
			if table.contains(var1_8, iter1_8) then
				var0_0.UIMgr.GetInstance():UnblurCamera(iter1_8, var0_8)
			end
		end
	end
end

function var1_0.LayerSortHandler(arg0_9)
	arg0_9:switchOriginParent()
	arg0_9:SortStoreUIs()

	local var0_9 = false
	local var1_9 = false
	local var2_9 = {}
	local var3_9
	local var4_9 = false
	local var5_9 = false
	local var6_9 = false
	local var7_9 = {}
	local var8_9
	local var9_9 = 0
	local var10_9 = 0
	local var11_9 = #arg0_9.storeUIs

	for iter0_9 = #arg0_9.storeUIs, 1, -1 do
		local var12_9 = arg0_9.storeUIs[iter0_9]
		local var13_9 = var12_9.type
		local var14_9 = var12_9.ui
		local var15_9 = var12_9.pbList
		local var16_9 = var12_9.globalBlur
		local var17_9 = var12_9.lockGlobalBlur
		local var18_9 = var12_9.groupName
		local var19_9 = var12_9.overlayType
		local var20_9 = var12_9.hideLowerLayer
		local var21_9 = var12_9.staticBlur
		local var22_9 = var12_9.blurCamList
		local var23_9 = var12_9.visible
		local var24_9 = var12_9.parent
		local var25_9 = iter0_9 == var11_9

		if var13_9 == LayerWeightConst.UI_TYPE_SYSTEM then
			var0_9 = true
		end

		if var25_9 then
			if var18_9 ~= nil then
				var3_9 = var18_9
			end

			var4_9 = var16_9
			var5_9 = var17_9
			var6_9 = var21_9
			var7_9 = var22_9

			local var26_9 = var12_9
		end

		local function var27_9()
			arg0_9:ShowOrHideTF(var14_9, true)

			if var24_9 ~= nil then
				arg0_9:SetSpecificParent(var14_9, var24_9)
			elseif var19_9 == LayerWeightConst.OVERLAY_UI_TOP then
				arg0_9:SetToOverlayParent(var14_9, var19_9)
			else
				arg0_9:SetToOverlayParent(var14_9, var19_9, var9_9)
			end

			if var23_9 and not var16_9 and #var15_9 > 0 then
				table.insertto(var2_9, var15_9)
			end
		end

		local function var28_9()
			arg0_9:SetToOrigin(var14_9, var19_9, var10_9, var12_9.interactableAlways)

			if var0_9 or var1_9 then
				arg0_9:ShowOrHideTF(var14_9, false)
			else
				arg0_9:ShowOrHideTF(var14_9, true)

				if #var15_9 > 0 then
					var0_0.UIMgr.GetInstance():RevertPBMaterial(var15_9)
				end
			end
		end

		if var13_9 == LayerWeightConst.UI_TYPE_SUB then
			if var25_9 then
				var27_9()
			elseif var3_9 ~= nil and var3_9 == var18_9 then
				var27_9()
			else
				var28_9()
			end
		elseif var13_9 == LayerWeightConst.UI_TYPE_OVERLAY_FOREVER then
			if var25_9 then
				var11_9 = iter0_9 - 1

				var27_9()
			elseif var3_9 ~= nil and var3_9 == var18_9 then
				var27_9()
			else
				var28_9()
			end
		end

		if var20_9 then
			var1_9 = true
		end
	end

	if #var2_9 > 0 then
		var0_0.UIMgr.GetInstance():PartialBlurTfs(var2_9)
	else
		var0_0.UIMgr.GetInstance():ShutdownPartialBlur()
	end

	if var4_9 then
		for iter1_9, iter2_9 in ipairs({
			var0_0.UIMgr.CameraUI,
			var0_0.UIMgr.CameraLevel
		}) do
			if table.contains(var7_9, iter2_9) then
				var0_0.UIMgr.GetInstance():BlurCamera(iter2_9, var6_9, var5_9)
			else
				var0_0.UIMgr.GetInstance():UnblurCamera(iter2_9)
			end
		end
	else
		for iter3_9, iter4_9 in ipairs({
			var0_0.UIMgr.CameraUI,
			var0_0.UIMgr.CameraLevel
		}) do
			var0_0.UIMgr.GetInstance():UnblurCamera(iter4_9)
		end
	end
end

function var1_0.SetSpecificParent(arg0_12, arg1_12, arg2_12)
	SetParent(arg1_12, arg2_12, false)

	local var0_12 = GetOrAddComponent(arg1_12, typeof(CanvasGroup))

	var0_12.interactable = true
	var0_12.blocksRaycasts = true
end

function var1_0.SetToOverlayParent(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13

	if arg2_13 == LayerWeightConst.OVERLAY_UI_ADAPT then
		var0_13 = arg0_13:GetAdaptObjFromUI(arg1_13)

		if var0_13 ~= nil then
			var0_13 = arg1_13.parent

			SetParent(var0_13, arg0_13.OverlayMain, false)
		else
			var0_13 = arg0_13:GetAdaptObj()
			var0_13.name = arg0_13:GetAdatpObjName(arg1_13)

			SetParent(arg1_13, var0_13, false)
			SetParent(var0_13, arg0_13.OverlayMain, false)
		end
	elseif arg2_13 == LayerWeightConst.OVERLAY_UI_TOP then
		var0_13 = arg1_13

		SetParent(var0_13, arg0_13.OverlayTop, false)
	else
		var0_13 = arg1_13

		SetParent(var0_13, arg0_13.OverlayMain, false)
	end

	if arg3_13 ~= nil then
		var0_13:SetSiblingIndex(arg3_13)
	end

	local var1_13 = GetOrAddComponent(var0_13, typeof(CanvasGroup))

	var1_13.interactable = true
	var1_13.blocksRaycasts = true
end

function var1_0.SetToOrigin(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	local var0_14

	if arg2_14 == LayerWeightConst.OVERLAY_UI_ADAPT then
		var0_14 = arg0_14:GetAdaptObjFromUI(arg1_14)

		if var0_14 ~= nil then
			var0_14 = arg1_14.parent
		else
			var0_14 = arg0_14:GetAdaptObj()
			var0_14.name = arg0_14:GetAdatpObjName(arg1_14)

			SetParent(arg1_14, var0_14, false)
		end
	else
		var0_14 = arg1_14
	end

	SetParent(var0_14, arg0_14.uiOrigin, false)

	if arg3_14 ~= nil then
		var0_14:SetSiblingIndex(arg3_14)
	end

	local var1_14 = GetOrAddComponent(var0_14, typeof(CanvasGroup))

	var1_14.interactable = arg4_14
	var1_14.blocksRaycasts = arg4_14
end

function var1_0.SortStoreUIs(arg0_15)
	arg0_15:Log("-----------------------------------------")

	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.storeUIs) do
		if not table.contains(var0_15, iter1_15.weight) then
			table.insert(var0_15, iter1_15.weight)
		end
	end

	table.sort(var0_15, function(arg0_16, arg1_16)
		return arg0_16 < arg1_16
	end)

	local var1_15 = {}

	for iter2_15, iter3_15 in ipairs(var0_15) do
		for iter4_15, iter5_15 in ipairs(arg0_15.storeUIs) do
			if iter3_15 == iter5_15.weight then
				table.insert(var1_15, iter5_15)
				arg0_15:Log(iter5_15.ui.gameObject.name .. "   globalBlur:" .. tostring(iter5_15.globalBlur))
			end
		end
	end

	arg0_15.storeUIs = var1_15

	arg0_15:Log("-----------------------------------------")
end

function var1_0.ShowOrHideTF(arg0_17, arg1_17, arg2_17)
	GetOrAddComponent(arg1_17, typeof(CanvasGroup)).alpha = arg2_17 and 1 or 0
end

function var1_0.SetVisibleViaLayer(arg0_18, arg1_18, arg2_18)
	setActiveViaLayer(arg1_18, arg2_18)

	for iter0_18, iter1_18 in pairs(arg0_18.storeUIs) do
		if iter1_18.ui == arg1_18 then
			iter1_18.visible = arg2_18

			arg0_18:CreateRefreshHandler()
		end
	end
end

function var1_0.switchOriginParent(arg0_19)
	if arg0_19.lvCamera.enabled then
		arg0_19.uiOrigin:SetParent(arg0_19.lvParent, false)

		arg0_19.originCanvas.sortingOrder = 5000
	else
		arg0_19.uiOrigin:SetParent(arg0_19.baseParent, false)

		arg0_19.originCanvas.sortingOrder = 200
	end
end

function var1_0.GetAdaptObj(arg0_20)
	local var0_20

	if #arg0_20.adaptPool > 0 then
		var0_20 = table.remove(arg0_20.adaptPool, #arg0_20.adaptPool)
	else
		local var1_20 = GameObject.New()

		var1_20:AddComponent(typeof(NotchAdapt))

		var0_20 = var1_20:AddComponent(typeof(RectTransform))
	end

	var0_20.anchorMin = Vector2.zero
	var0_20.anchorMax = Vector2.one
	var0_20.pivot = Vector2(0.5, 0.5)
	var0_20.offsetMax = Vector2.zero
	var0_20.offsetMin = Vector2.zero
	var0_20.localPosition = Vector3.zero

	SetActive(var0_20, true)
	arg0_20:ShowOrHideTF(var0_20, true)

	return var0_20
end

function var1_0.CheckRecycleAdaptObj(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21:GetAdaptObjFromUI(arg1_21)

	if arg2_21 ~= nil then
		SetParent(arg1_21, arg2_21, false)
	end

	if var0_21 ~= nil then
		if #arg0_21.adaptPool < 4 then
			table.insert(arg0_21.adaptPool, var0_21)
			SetParent(var0_21, arg0_21.OverlayAdapt, false)

			var0_21.name = var1_0.RECYCLE_ADAPT_TAG

			SetActive(var0_21, false)
		else
			Destroy(var0_21)
		end
	end
end

function var1_0.GetAdaptObjFromUI(arg0_22, arg1_22)
	if arg1_22.parent ~= nil and arg1_22.parent.name == arg0_22:GetAdatpObjName(arg1_22) then
		return arg1_22.parent
	end

	return nil
end

function var1_0.GetAdatpObjName(arg0_23, arg1_23)
	return arg1_23.name .. var1_0.ADAPT_TAG
end

function var1_0.Log(arg0_24, arg1_24)
	if not var1_0.DEBUG then
		return
	end

	originalPrint(arg1_24)
end
