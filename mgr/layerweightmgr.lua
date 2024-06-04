pg = pg or {}

local var0 = pg

var0.LayerWeightMgr = singletonClass("LayerWeightMgr")

local var1 = var0.LayerWeightMgr

var1.DEBUG = false
var1.ADAPT_TAG = "(Adapt)"
var1.RECYCLE_ADAPT_TAG = "recycleAdapt"

function var1.Init(arg0, arg1)
	arg0.baseParent = tf(GameObject.Find("UICamera/Canvas"))

	local var0 = tf(GameObject.Find("UICamera/Canvas/UIMain"))

	arg0.uiOrigin = tf(instantiate(var0))
	arg0.uiOrigin.name = "UIOrigin"

	arg0.uiOrigin:SetParent(arg0.baseParent, false)

	arg0.originCanvas = GetOrAddComponent(arg0.uiOrigin, typeof(Canvas))
	arg0.originCanvas.overrideSorting = true
	arg0.originCanvas.sortingOrder = 200
	arg0.originCast = GetOrAddComponent(arg0.uiOrigin, typeof(GraphicRaycaster))
	arg0.lvCameraTf = tf(GameObject.Find("LevelCamera"))
	arg0.lvParent = tf(GameObject.Find("LevelCamera/Canvas"))
	arg0.lvCamera = GetOrAddComponent(arg0.lvCameraTf, typeof(Camera))
	arg0.adaptPool = {}
	arg0.UIMain = rtf(GameObject.Find("UICamera/Canvas/UIMain"))
	arg0.OverlayMain = rtf(GameObject.Find("OverlayCamera/Overlay/UIMain"))
	arg0.OverlayAdapt = rtf(GameObject.Find("OverlayCamera/Overlay/UIAdapt"))
	arg0.OverlayTop = rtf(GameObject.Find("OverlayCamera/Overlay/UIOverlay"))
	arg0.storeUIs = {}

	if arg1 ~= nil then
		arg1()
	end
end

function var1.CreateRefreshHandler(arg0)
	if not arg0.luHandle then
		arg0.luHandle = LateUpdateBeat:CreateListener(arg0.Refresh, arg0)

		LateUpdateBeat:AddListener(arg0.luHandle)
	end
end

function var1.ClearRefreshHandler(arg0)
	if arg0.luHandle then
		LateUpdateBeat:RemoveListener(arg0.luHandle)

		arg0.luHandle = nil
	end
end

function var1.Refresh(arg0)
	arg0:LayerSortHandler()
	arg0:ClearRefreshHandler()
end

function var1.Add2Overlay(arg0, arg1, arg2, arg3)
	arg3.type = arg1
	arg3.ui = arg2
	arg3.pbList = arg3.pbList or {}
	arg3.weight = arg3.weight or LayerWeightConst.BASE_LAYER
	arg3.overlayType = arg3.overlayType or LayerWeightConst.OVERLAY_UI_MAIN
	arg3.visible = true

	local var0

	if arg0.lvCamera.enabled then
		var0 = {
			var0.UIMgr.CameraLevel
		}
	else
		var0 = {
			var0.UIMgr.CameraUI
		}
	end

	arg3.blurCamList = arg3.blurCamList or var0

	if arg1 == LayerWeightConst.UI_TYPE_SYSTEM and #arg0.storeUIs > 0 or arg1 == LayerWeightConst.UI_TYPE_SUB or arg1 == LayerWeightConst.UI_TYPE_OVERLAY_FOREVER then
		arg0:Log("ui：" .. arg2.gameObject.name .. " 加入了ui层级管理, weight:" .. arg3.weight)

		local var1 = arg0:DelList(arg2)

		arg0:ClearBlurData(var1)
		table.insert(arg0.storeUIs, arg3)
		arg0:CreateRefreshHandler()
	end
end

function var1.DelFromOverlay(arg0, arg1, arg2)
	arg0:Log("ui：" .. arg1.gameObject.name .. " 去除了ui层级管理")

	local var0 = arg0:DelList(arg1)

	if var0 ~= nil then
		local var1 = var0.ui
		local var2 = arg0:GetAdaptObjFromUI(var1)

		if var2 == nil then
			var2 = var1
		end

		local var3 = GetOrAddComponent(var2, typeof(CanvasGroup))

		var3.interactable = true
		var3.blocksRaycasts = true

		arg0:CheckRecycleAdaptObj(var1, arg2)
		arg0:ClearBlurData(var0)
	end

	arg0:CreateRefreshHandler()
end

function var1.DelList(arg0, arg1)
	local var0

	for iter0 = #arg0.storeUIs, 1, -1 do
		if arg0.storeUIs[iter0].ui == arg1 then
			var0 = arg0.storeUIs[iter0]

			table.remove(arg0.storeUIs, iter0)

			break
		end
	end

	return var0
end

function var1.ClearBlurData(arg0, arg1)
	if arg1 == nil then
		return
	end

	if arg1.pbList ~= nil then
		var0.UIMgr.GetInstance():RevertPBMaterial(arg1.pbList)
	end

	local var0 = arg1.lockGlobalBlur

	if var0 then
		local var1 = arg1.blurCamList

		for iter0, iter1 in ipairs({
			var0.UIMgr.CameraUI,
			var0.UIMgr.CameraLevel
		}) do
			if table.contains(var1, iter1) then
				var0.UIMgr.GetInstance():UnblurCamera(iter1, var0)
			end
		end
	end
end

function var1.LayerSortHandler(arg0)
	arg0:switchOriginParent()
	arg0:SortStoreUIs()

	local var0 = false
	local var1 = false
	local var2 = {}
	local var3
	local var4 = false
	local var5 = false
	local var6 = false
	local var7 = {}
	local var8
	local var9 = 0
	local var10 = 0
	local var11 = #arg0.storeUIs

	for iter0 = #arg0.storeUIs, 1, -1 do
		local var12 = arg0.storeUIs[iter0]
		local var13 = var12.type
		local var14 = var12.ui
		local var15 = var12.pbList
		local var16 = var12.globalBlur
		local var17 = var12.lockGlobalBlur
		local var18 = var12.groupName
		local var19 = var12.overlayType
		local var20 = var12.hideLowerLayer
		local var21 = var12.staticBlur
		local var22 = var12.blurCamList
		local var23 = var12.visible
		local var24 = var12.parent
		local var25 = iter0 == var11

		if var13 == LayerWeightConst.UI_TYPE_SYSTEM then
			var0 = true
		end

		if var25 then
			if var18 ~= nil then
				var3 = var18
			end

			var4 = var16
			var5 = var17
			var6 = var21
			var7 = var22

			local var26 = var12
		end

		local function var27()
			arg0:ShowOrHideTF(var14, true)

			if var24 ~= nil then
				arg0:SetSpecificParent(var14, var24)
			elseif var19 == LayerWeightConst.OVERLAY_UI_TOP then
				arg0:SetToOverlayParent(var14, var19)
			else
				arg0:SetToOverlayParent(var14, var19, var9)
			end

			if var23 and not var16 and #var15 > 0 then
				table.insertto(var2, var15)
			end
		end

		local function var28()
			arg0:SetToOrigin(var14, var19, var10, var12.interactableAlways)

			if var0 or var1 then
				arg0:ShowOrHideTF(var14, false)
			else
				arg0:ShowOrHideTF(var14, true)

				if #var15 > 0 then
					var0.UIMgr.GetInstance():RevertPBMaterial(var15)
				end
			end
		end

		if var13 == LayerWeightConst.UI_TYPE_SUB then
			if var25 then
				var27()
			elseif var3 ~= nil and var3 == var18 then
				var27()
			else
				var28()
			end
		elseif var13 == LayerWeightConst.UI_TYPE_OVERLAY_FOREVER then
			if var25 then
				var11 = iter0 - 1

				var27()
			elseif var3 ~= nil and var3 == var18 then
				var27()
			else
				var28()
			end
		end

		if var20 then
			var1 = true
		end
	end

	if #var2 > 0 then
		var0.UIMgr.GetInstance():PartialBlurTfs(var2)
	else
		var0.UIMgr.GetInstance():ShutdownPartialBlur()
	end

	if var4 then
		for iter1, iter2 in ipairs({
			var0.UIMgr.CameraUI,
			var0.UIMgr.CameraLevel
		}) do
			if table.contains(var7, iter2) then
				var0.UIMgr.GetInstance():BlurCamera(iter2, var6, var5)
			else
				var0.UIMgr.GetInstance():UnblurCamera(iter2)
			end
		end
	else
		for iter3, iter4 in ipairs({
			var0.UIMgr.CameraUI,
			var0.UIMgr.CameraLevel
		}) do
			var0.UIMgr.GetInstance():UnblurCamera(iter4)
		end
	end
end

function var1.SetSpecificParent(arg0, arg1, arg2)
	SetParent(arg1, arg2, false)

	local var0 = GetOrAddComponent(arg1, typeof(CanvasGroup))

	var0.interactable = true
	var0.blocksRaycasts = true
end

function var1.SetToOverlayParent(arg0, arg1, arg2, arg3)
	local var0

	if arg2 == LayerWeightConst.OVERLAY_UI_ADAPT then
		var0 = arg0:GetAdaptObjFromUI(arg1)

		if var0 ~= nil then
			var0 = arg1.parent

			SetParent(var0, arg0.OverlayMain, false)
		else
			var0 = arg0:GetAdaptObj()
			var0.name = arg0:GetAdatpObjName(arg1)

			SetParent(arg1, var0, false)
			SetParent(var0, arg0.OverlayMain, false)
		end
	elseif arg2 == LayerWeightConst.OVERLAY_UI_TOP then
		var0 = arg1

		SetParent(var0, arg0.OverlayTop, false)
	else
		var0 = arg1

		SetParent(var0, arg0.OverlayMain, false)
	end

	if arg3 ~= nil then
		var0:SetSiblingIndex(arg3)
	end

	local var1 = GetOrAddComponent(var0, typeof(CanvasGroup))

	var1.interactable = true
	var1.blocksRaycasts = true
end

function var1.SetToOrigin(arg0, arg1, arg2, arg3, arg4)
	local var0

	if arg2 == LayerWeightConst.OVERLAY_UI_ADAPT then
		var0 = arg0:GetAdaptObjFromUI(arg1)

		if var0 ~= nil then
			var0 = arg1.parent
		else
			var0 = arg0:GetAdaptObj()
			var0.name = arg0:GetAdatpObjName(arg1)

			SetParent(arg1, var0, false)
		end
	else
		var0 = arg1
	end

	SetParent(var0, arg0.uiOrigin, false)

	if arg3 ~= nil then
		var0:SetSiblingIndex(arg3)
	end

	local var1 = GetOrAddComponent(var0, typeof(CanvasGroup))

	var1.interactable = arg4
	var1.blocksRaycasts = arg4
end

function var1.SortStoreUIs(arg0)
	arg0:Log("-----------------------------------------")

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.storeUIs) do
		if not table.contains(var0, iter1.weight) then
			table.insert(var0, iter1.weight)
		end
	end

	table.sort(var0, function(arg0, arg1)
		return arg0 < arg1
	end)

	local var1 = {}

	for iter2, iter3 in ipairs(var0) do
		for iter4, iter5 in ipairs(arg0.storeUIs) do
			if iter3 == iter5.weight then
				table.insert(var1, iter5)
				arg0:Log(iter5.ui.gameObject.name .. "   globalBlur:" .. tostring(iter5.globalBlur))
			end
		end
	end

	arg0.storeUIs = var1

	arg0:Log("-----------------------------------------")
end

function var1.ShowOrHideTF(arg0, arg1, arg2)
	GetOrAddComponent(arg1, typeof(CanvasGroup)).alpha = arg2 and 1 or 0
end

function var1.SetVisibleViaLayer(arg0, arg1, arg2)
	setActiveViaLayer(arg1, arg2)

	for iter0, iter1 in pairs(arg0.storeUIs) do
		if iter1.ui == arg1 then
			iter1.visible = arg2

			arg0:CreateRefreshHandler()
		end
	end
end

function var1.switchOriginParent(arg0)
	if arg0.lvCamera.enabled then
		arg0.uiOrigin:SetParent(arg0.lvParent, false)

		arg0.originCanvas.sortingOrder = 5000
	else
		arg0.uiOrigin:SetParent(arg0.baseParent, false)

		arg0.originCanvas.sortingOrder = 200
	end
end

function var1.GetAdaptObj(arg0)
	local var0

	if #arg0.adaptPool > 0 then
		var0 = table.remove(arg0.adaptPool, #arg0.adaptPool)
	else
		local var1 = GameObject.New()

		var1:AddComponent(typeof(NotchAdapt))

		var0 = var1:AddComponent(typeof(RectTransform))
	end

	var0.anchorMin = Vector2.zero
	var0.anchorMax = Vector2.one
	var0.pivot = Vector2(0.5, 0.5)
	var0.offsetMax = Vector2.zero
	var0.offsetMin = Vector2.zero
	var0.localPosition = Vector3.zero

	SetActive(var0, true)
	arg0:ShowOrHideTF(var0, true)

	return var0
end

function var1.CheckRecycleAdaptObj(arg0, arg1, arg2)
	local var0 = arg0:GetAdaptObjFromUI(arg1)

	if arg2 ~= nil then
		SetParent(arg1, arg2, false)
	end

	if var0 ~= nil then
		if #arg0.adaptPool < 4 then
			table.insert(arg0.adaptPool, var0)
			SetParent(var0, arg0.OverlayAdapt, false)

			var0.name = var1.RECYCLE_ADAPT_TAG

			SetActive(var0, false)
		else
			Destroy(var0)
		end
	end
end

function var1.GetAdaptObjFromUI(arg0, arg1)
	if arg1.parent ~= nil and arg1.parent.name == arg0:GetAdatpObjName(arg1) then
		return arg1.parent
	end

	return nil
end

function var1.GetAdatpObjName(arg0, arg1)
	return arg1.name .. var1.ADAPT_TAG
end

function var1.Log(arg0, arg1)
	if not var1.DEBUG then
		return
	end

	originalPrint(arg1)
end
