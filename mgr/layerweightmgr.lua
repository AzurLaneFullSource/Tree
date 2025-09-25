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

	local var0_8 = arg0_8.lvCamera.enabled and {
		var0_0.UIMgr.CameraLevel
	} or {
		var0_0.UIMgr.CameraUI
	}

	arg2_8.blurCamList = arg2_8.blurCamList or var0_8

	local var1_8 = arg2_8.type

	assert(var1_8 and LayerWeightConst.TYPE_DIC[var1_8])
	arg0_8:Log(string.format("ui:%s 加入了ui层级管理\n%s", arg1_8.name, PrintTable(arg2_8)))

	local var2_8 = arg0_8:DelList(arg1_8)

	arg0_8:ClearBlurData(var2_8)
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
		arg0_9:ClearBlurData(var0_9)
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

function var1_0.ClearBlurData(arg0_11, arg1_11)
	if arg1_11 == nil then
		return
	end

	if arg1_11.pbList ~= nil then
		var0_0.UIMgr.GetInstance():RevertPBMaterial(arg1_11.pbList)
	end

	local var0_11 = arg1_11.lockGlobalBlur

	if var0_11 then
		local var1_11 = arg1_11.blurCamList

		for iter0_11, iter1_11 in ipairs({
			var0_0.UIMgr.CameraUI,
			var0_0.UIMgr.CameraLevel
		}) do
			if table.contains(var1_11, iter1_11) then
				var0_0.UIMgr.GetInstance():UnblurCamera(iter1_11, var0_11)
			end
		end
	end
end

function var1_0.SortStoreUIs(arg0_12)
	arg0_12:Log("-----------------------------------------")
	mergeSort(arg0_12.storeUIs, CompareFuncs({
		function(arg0_13)
			return arg0_12.groupWeightDic[arg0_13.groupName]
		end,
		function(arg0_14)
			return arg0_14.groupDelta
		end
	}, true))
	arg0_12:Log(PrintTable(arg0_12.storeUIs))
	arg0_12:Log("-----------------------------------------")
end

function var1_0.LayerSortHandler(arg0_15)
	arg0_15:SortStoreUIs()

	local var0_15
	local var1_15
	local var2_15 = {}
	local var3_15 = false
	local var4_15 = false
	local var5_15 = false
	local var6_15 = {}

	for iter0_15 = #arg0_15.storeUIs, 1, -1 do
		local var7_15 = arg0_15.storeUIs[iter0_15]
		local var8_15 = var7_15.ui
		local var9_15 = var7_15.parent
		local var10_15 = var7_15.type
		local var11_15 = var7_15.overlayType
		local var12_15 = var7_15.groupName
		local var13_15 = var7_15.globalBlur
		local var14_15 = var7_15.lockGlobalBlur
		local var15_15 = var7_15.staticBlur
		local var16_15 = var7_15.blurCamList
		local var17_15 = var7_15.pbList
		local var18_15 = var7_15.stopTop

		var1_15 = var1_15 or var12_15

		if not var0_15 then
			if var12_15 ~= var1_15 then
				var0_15 = iter0_15 + 1
			elseif var13_15 or var18_15 or var1_15 == LayerWeightConst.GROUP_TOP then
				var0_15 = iter0_15
			end
		end

		local var19_15 = not var0_15 or var0_15 <= iter0_15

		if var19_15 then
			var3_15 = var3_15 or var13_15
			var4_15 = var4_15 or var14_15
			var5_15 = var5_15 or var15_15

			table.insertto(var6_15, var16_15)
		end

		if #var17_15 > 0 then
			if var19_15 then
				table.insertto(var2_15, var17_15)
			else
				var0_0.UIMgr.GetInstance():RevertPBMaterial(var17_15)
			end
		end

		local var20_15 = var8_15

		if var11_15 == LayerWeightConst.OVERLAY_UI_ADAPT then
			var20_15 = arg0_15:GetAdaptObjFromUI(var8_15) or arg0_15:GetAdaptObj(var8_15)
		end

		local var21_15 = switch(var10_15, {
			[LayerWeightConst.UI_TYPE_SUB] = function()
				if var19_15 then
					if var9_15 then
						arg0_15:SetSpecificParent(var20_15, var9_15)
					else
						return arg0_15.OverlayMain
					end
				else
					return arg0_15.lvCamera.enabled and arg0_15.lvOrigin or arg0_15.uiOrigin
				end
			end,
			[LayerWeightConst.UI_TYPE_SYSTEM] = function()
				return arg0_15.uiMain
			end
		}, function()
			assert(false)
		end)

		if var21_15 then
			arg0_15:SetSpecificParent(var20_15, var21_15, 0)
		end
	end

	if not var3_15 and #var2_15 > 0 then
		var0_0.UIMgr.GetInstance():PartialBlurTfs(var2_15)
	else
		var0_0.UIMgr.GetInstance():ShutdownPartialBlur()
	end

	if var3_15 then
		for iter1_15, iter2_15 in ipairs({
			var0_0.UIMgr.CameraUI,
			var0_0.UIMgr.CameraLevel
		}) do
			if table.contains(var6_15, iter2_15) then
				var0_0.UIMgr.GetInstance():BlurCamera(iter2_15, var5_15, var4_15)
			else
				var0_0.UIMgr.GetInstance():UnblurCamera(iter2_15)
			end
		end
	else
		for iter3_15, iter4_15 in ipairs({
			var0_0.UIMgr.CameraUI,
			var0_0.UIMgr.CameraLevel
		}) do
			var0_0.UIMgr.GetInstance():UnblurCamera(iter4_15)
		end
	end
end

function var1_0.SetSpecificParent(arg0_19, arg1_19, arg2_19, arg3_19)
	SetParent(arg1_19, arg2_19, false)

	if arg3_19 then
		arg1_19:SetSiblingIndex(arg3_19)
	end
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
