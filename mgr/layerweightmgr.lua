pg = pg or {}

local var0_0 = pg

var0_0.LayerWeightMgr = singletonClass("LayerWeightMgr")

local var1_0 = var0_0.LayerWeightMgr

var1_0.DEBUG = false
var1_0.ADAPT_TAG = "(Adapt)"
var1_0.RECYCLE_ADAPT_TAG = "recycleAdapt"

function var1_0.Init(arg0_1, arg1_1)
	arg0_1.baseParent = tf(GameObject.Find("UICamera/Canvas"))
	arg0_1.uiMain = arg0_1.baseParent:Find("UIMain")
	arg0_1.uiOrigin = tf(instantiate(arg0_1.uiMain, arg0_1.baseParent, false))
	arg0_1.uiOrigin.name = "UIOrigin"

	local var0_1 = GetOrAddComponent(arg0_1.uiOrigin, typeof(Canvas))

	var0_1.overrideSorting = true
	var0_1.sortingOrder = 200

	GetOrAddComponent(arg0_1.uiOrigin, typeof(GraphicRaycaster))

	arg0_1.lvCamera = GetOrAddComponent(GameObject.Find("LevelCamera"), typeof(Camera))
	arg0_1.lvParent = tf(arg0_1.lvCamera):Find("Canvas")
	arg0_1.lvOrigin = tf(instantiate(arg0_1.uiOrigin, arg0_1.lvParent, false))
	arg0_1.lvOrigin.name = "LevelOrigin"
	GetOrAddComponent(arg0_1.lvOrigin, typeof(Canvas)).sortingOrder = 5000
	arg0_1.adaptPool = {}

	local var1_1 = rtf(GameObject.Find("OverlayCamera/Overlay"))

	arg0_1.OverlayMain = var1_1:Find("UIMain")
	arg0_1.OverlayAdapt = var1_1:Find("UIAdapt")
	arg0_1.OverlayTop = var1_1:Find("UIOverlay")
	arg0_1.groupWeightDic = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			if arg1_2 == LayerWeightConst.GROUP_TOP then
				return arg0_2[arg0_1.groupStack[#arg0_1.groupStack]] + 1
			else
				return 0
			end
		end
	})
	arg0_1.groupStack = {}
	arg0_1.storeUIs = {}

	existCall(arg1_1)
end

function var1_0.RegisterGroupWeight(arg0_3, arg1_3)
	if arg0_3.groupWeightDic[arg1_3] > 0 then
		return
	end

	arg0_3.groupWeightDic[arg1_3] = arg0_3.groupWeightDic[LayerWeightConst.GROUP_TOP]

	table.insert(arg0_3.groupStack, arg1_3)
end

function var1_0.RemoveGroupWeight(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.storeUIs) do
		if iter1_4.groupName == arg1_4 then
			return
		end
	end

	arg0_4.groupWeightDic[arg1_4] = nil

	table.removebyvalue(arg0_4.groupStack, arg1_4)
end

function var1_0.CreateRefreshHandler(arg0_5)
	if not arg0_5.luHandle then
		arg0_5:Log("CreateRefreshHandler")

		arg0_5.luHandle = LateUpdateBeat:CreateListener(arg0_5.Refresh, arg0_5)

		LateUpdateBeat:AddListener(arg0_5.luHandle)
	end
end

function var1_0.ClearRefreshHandler(arg0_6)
	if arg0_6.luHandle then
		LateUpdateBeat:RemoveListener(arg0_6.luHandle)

		arg0_6.luHandle = nil
	end
end

function var1_0.Refresh(arg0_7)
	arg0_7:LayerSortHandler()
	arg0_7:ClearRefreshHandler()
end

function var1_0.Add2Overlay(arg0_8, arg1_8, arg2_8)
	arg2_8.ui = arg1_8
	arg2_8.type = arg2_8.type
	arg2_8.pbList = arg2_8.pbList or {}
	arg2_8.overlayType = arg2_8.overlayType or LayerWeightConst.OVERLAY_UI_MAIN
	arg2_8.groupName = arg2_8.groupName or LayerWeightConst.GROUP_TOP
	arg2_8.groupDelta = arg2_8.groupDelta or 0

	if not arg2_8.blurCamList then
		if arg2_8.globalBlur or #arg2_8.pbList > 0 then
			arg2_8.blurCamList = {
				var0_0.UIMgr.CameraLevel,
				var0_0.UIMgr.CameraUI
			}
		else
			arg2_8.blurCamList = {}
		end
	end

	local var0_8 = arg2_8.type

	assert(var0_8 and LayerWeightConst.TYPE_DIC[var0_8])
	arg0_8:Log(string.format("ui:%s 加入了ui层级管理\n%s", arg1_8.name, PrintTable(arg2_8)))

	local var1_8 = arg0_8:DelList(arg1_8)

	table.insert(arg0_8.storeUIs, arg2_8)
	arg0_8:CreateRefreshHandler()

	if arg2_8.force then
		arg0_8:Refresh()
	end
end

function var1_0.DelFromOverlay(arg0_9, arg1_9, arg2_9)
	arg0_9:Log(string.format("ui:%s 退出了ui层级管理", arg1_9.name))

	local var0_9 = arg0_9:DelList(arg1_9)

	if var0_9 ~= nil then
		local var1_9 = var0_9.ui

		if not arg0_9:GetAdaptObjFromUI(var1_9) then
			local var2_9 = var1_9
		end

		arg0_9:CheckRecycleAdaptObj(var1_9, arg2_9)
	end

	arg0_9:CreateRefreshHandler()
end

function var1_0.DelList(arg0_10, arg1_10)
	local var0_10

	for iter0_10 = #arg0_10.storeUIs, 1, -1 do
		if arg0_10.storeUIs[iter0_10].ui == arg1_10 then
			var0_10 = arg0_10.storeUIs[iter0_10]

			table.remove(arg0_10.storeUIs, iter0_10)

			break
		end
	end

	return var0_10
end

function var1_0.SortStoreUIs(arg0_11)
	arg0_11:Log("-----------------------------------------")
	mergeSort(arg0_11.storeUIs, CompareFuncs({
		function(arg0_12)
			return arg0_11.groupWeightDic[arg0_12.groupName]
		end,
		function(arg0_13)
			return arg0_13.groupDelta
		end
	}, true))
	arg0_11:Log(PrintTable(arg0_11.storeUIs))
	arg0_11:Log("-----------------------------------------")
end

function var1_0.LayerSortHandler(arg0_14)
	arg0_14:SortStoreUIs()

	arg0_14.indexDic = {}

	local var0_14
	local var1_14
	local var2_14 = {}
	local var3_14 = false
	local var4_14 = false
	local var5_14 = false
	local var6_14 = {}

	for iter0_14 = #arg0_14.storeUIs, 1, -1 do
		local var7_14 = arg0_14.storeUIs[iter0_14]
		local var8_14 = var7_14.ui
		local var9_14 = var7_14.parent
		local var10_14 = var7_14.type
		local var11_14 = var7_14.overlayType
		local var12_14 = var7_14.groupName
		local var13_14 = var7_14.globalBlur
		local var14_14 = var7_14.lockGlobalBlur
		local var15_14 = var7_14.staticBlur
		local var16_14 = var7_14.blurCamList
		local var17_14 = var7_14.pbList
		local var18_14 = var7_14.stopTop

		var1_14 = var1_14 or var12_14

		if not var0_14 then
			if var12_14 ~= var1_14 then
				var0_14 = iter0_14 + 1
			elseif var13_14 or var18_14 or var1_14 == LayerWeightConst.GROUP_TOP then
				var0_14 = iter0_14
			end
		end

		local var19_14 = not var0_14 or var0_14 <= iter0_14

		var4_14 = var4_14 or var14_14

		if var19_14 then
			var3_14 = var3_14 or var13_14
			var5_14 = var5_14 or var15_14

			table.insertto(var6_14, var16_14)

			if #var17_14 > 0 then
				table.insertto(var2_14, var17_14)
			end
		end

		local var20_14 = var8_14

		if var11_14 == LayerWeightConst.OVERLAY_UI_ADAPT then
			var20_14 = arg0_14:GetAdaptObjFromUI(var8_14) or arg0_14:GetAdaptObj(var8_14)
		end

		local var21_14 = switch(var10_14, {
			[LayerWeightConst.UI_TYPE_SUB] = function()
				if var19_14 then
					if var9_14 then
						arg0_14:SetSpecificParent(var20_14, var9_14)
					else
						return arg0_14.OverlayMain
					end
				else
					return arg0_14.lvCamera.enabled and arg0_14.lvOrigin or arg0_14.uiOrigin
				end
			end,
			[LayerWeightConst.UI_TYPE_SYSTEM] = function()
				return arg0_14.uiMain
			end
		}, function()
			assert(false)
		end)

		if var21_14 then
			arg0_14:SetSpecificParent(var20_14, var21_14, 0)
		end
	end

	arg0_14:SequentizationUIIndex()

	if not var4_14 then
		var0_0.UIMgr.GetInstance():SetCameraBlurLock(var4_14)
	end

	if not var3_14 and #var2_14 > 0 then
		var0_0.UIMgr.GetInstance():PartialBlurTfs(var2_14)
	else
		var0_0.UIMgr.GetInstance():ShutdownPartialBlur()
	end

	for iter1_14, iter2_14 in ipairs({
		var0_0.UIMgr.CameraUI,
		var0_0.UIMgr.CameraLevel
	}) do
		if var3_14 and table.contains(var6_14, iter2_14) then
			var0_0.UIMgr.GetInstance():BlurCamera(iter2_14, var5_14)
		else
			var0_0.UIMgr.GetInstance():UnblurCamera(iter2_14)
		end
	end

	if var4_14 then
		var0_0.UIMgr.GetInstance():SetCameraBlurLock(var4_14)
	end
end

function var1_0.SetSpecificParent(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg3_18 then
		arg0_18.indexDic[arg2_18] = arg0_18.indexDic[arg2_18] or {}

		table.insert(arg0_18.indexDic[arg2_18], 1, arg1_18)
	else
		SetParent(arg1_18, arg2_18, false)
	end
end

function var1_0.SequentizationUIIndex(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.indexDic) do
		for iter2_19, iter3_19 in ipairs(iter1_19) do
			SetParent(iter3_19, iter0_19, false)

			if iter3_19:GetSiblingIndex() ~= iter2_19 - 1 then
				iter3_19:SetSiblingIndex(iter2_19 - 1)
			end
		end
	end

	arg0_19.indexDic = nil
end

function var1_0.GetAdaptObj(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetAdatpObjName(arg1_20)
	local var1_20

	if #arg0_20.adaptPool > 0 then
		var1_20 = table.remove(arg0_20.adaptPool, #arg0_20.adaptPool)
		var1_20.name = var0_20
	else
		var1_20 = GameObject.New(var0_20, typeof(RectTransform), typeof(NotchAdapt)).transform
	end

	var1_20.anchorMin = Vector2.zero
	var1_20.anchorMax = Vector2.one
	var1_20.pivot = Vector2(0.5, 0.5)
	var1_20.offsetMax = Vector2.zero
	var1_20.offsetMin = Vector2.zero
	var1_20.localPosition = Vector3.zero

	SetActive(var1_20, true)
	SetParent(arg1_20, var1_20, false)

	return var1_20
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
