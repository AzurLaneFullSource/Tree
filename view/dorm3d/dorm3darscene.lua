local var0_0 = class("Dorm3dARScene", import("view.base.BaseUI"))
local var1_0 = "ARScene2|common/ar"

var0_0.AR_FAIL_CODE = {
	[0] = "None",
	"Unsupported",
	"CheckingAvailability",
	"NeedsInstall",
	"Installing",
	[-1] = "pc editor"
}
var0_0.AR_PASS_CODE = {
	5,
	6,
	7
}

function var0_0.getUIName(arg0_1)
	return "Dorm3DARUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)
	local var1_2, var2_2 = unpack(string.split(var1_0, "|"))

	table.insert(var0_2, string.lower("dorm3d/scenesres/scenes/" .. var2_2 .. "/" .. var1_2 .. "_scene"))
	table.insert(var0_2, string.lower(string.format("ui/dorm3dloading")))
	table.insert(var0_2, string.lower(string.format("dorm3dholylight/eff_smoke_114")))

	local var3_2 = getProxy(ApartmentProxy):getRoom(arg0_2.contextData.roomId)
	local var4_2 = getProxy(ApartmentProxy):getApartment(arg0_2.contextData.groupId)
	local var5_2 = var4_2:getConfig("asset_name")
	local var6_2 = var4_2:GetSkinModelID(var3_2:getConfig("tag"))
	local var7_2 = pg.dorm3d_resource[var6_2].model_id

	assert(var7_2)

	for iter0_2, iter1_2 in ipairs(Dorm3dHxHelper.GetMaterialResources(arg0_2.contextData.groupId)) do
		table.insert(var0_2, iter1_2)
	end

	table.insert(var0_2, string.lower(string.format("dorm3d/character/%s/prefabs/%s", var5_2, var7_2)))

	return var0_2
end

function var0_0.forceGC(arg0_3)
	return true
end

function var0_0.loadingQueue(arg0_4)
	return function(arg0_5)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_6)
			return arg0_5(arg0_6)
		end)
	end
end

function var0_0.Ctor(arg0_7, ...)
	var0_0.super.Ctor(arg0_7, ...)

	arg0_7.loader = AutoLoader.New()
	arg0_7.hxHelper = Dorm3dHxHelper.New(arg0_7.loader)
end

function var0_0.preload(arg0_8, arg1_8)
	arg0_8.room = getProxy(ApartmentProxy):getRoom(arg0_8.contextData.roomId)

	local var0_8, var1_8 = unpack(string.split(var1_0, "|"))

	seriesAsync({
		function(arg0_9)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var1_8 .. "/" .. var0_8 .. "_scene"), var0_8, LoadSceneMode.Additive, function(arg0_10, arg1_10)
				arg0_9()
			end)
		end,
		function(arg0_11)
			arg0_8:LoadCharacter({
				arg0_8.contextData.groupId
			}, arg0_11)
		end,
		function(arg0_12)
			local var0_12 = GameObject.Find("FakeAR/Main Camera")
			local var1_12 = GameObject.Find("AR/XR Origin/Camera Offset/Main Camera")

			if var0_12 then
				originalPrint("Fix Fake AR Camera Data")
				HotfixHelper.FixARCameraData(var0_12)
			end

			if var1_12 then
				originalPrint("Fix True AR Camera Data")
				HotfixHelper.FixARCameraData(var1_12)
			end

			arg0_12()
		end
	}, arg1_8)
end

function var0_0.LoadCharacter(arg0_13, arg1_13, arg2_13)
	arg0_13.ladyDict = {}
	arg0_13.skinDict = {}

	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		local var1_13 = arg0_13

		arg0_13.ladyDict[iter1_13] = var1_13

		local var2_13 = getProxy(ApartmentProxy):getApartment(iter1_13)
		local var3_13 = var2_13:getConfig("asset_name")
		local var4_13 = var2_13:GetSkinModelID(arg0_13.room:getConfig("tag"))
		local var5_13 = pg.dorm3d_resource[var4_13].model_id

		assert(var5_13)
		table.insert(var0_13, function(arg0_14)
			arg0_13.hxHelper:LoadMaterials(iter1_13, arg0_14)
		end)

		var1_13.skinId = var4_13
		var1_13.skinIdList = {
			var4_13
		}

		table.insert(var0_13, function(arg0_15)
			local var0_15 = string.format("dorm3d/character/%s/prefabs/%s", var3_13, var5_13)

			arg0_13.loader:GetPrefab(var0_15, "", function(arg0_16)
				var1_13.ladyGameObject = arg0_16

				setActive(arg0_16.transform, false)

				arg0_13.skinDict[var4_13] = {
					ladyGameObject = arg0_16
				}

				arg0_15()
			end)
		end)
	end

	parallelAsync(var0_13, arg2_13)
end

function var0_0.InitCharacter(arg0_17, arg1_17)
	arg0_17.lady = arg0_17.ladyGameObject.transform

	arg0_17.lady:SetParent(arg0_17.mainCameraTF)
	arg0_17.lady:SetParent(nil)
	setActive(arg0_17.lady, true)

	arg0_17.ladyAnimator = arg0_17.lady:GetComponent(typeof(Animator))
	arg0_17.ladyAnimBaseLayerIndex = arg0_17.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_17.ladyAnimFaceLayerIndex = arg0_17.ladyAnimator:GetLayerIndex("Face")
	arg0_17.ladyBoneMaps = {}

	local var0_17 = arg0_17.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var0_17, function(arg0_18, arg1_18)
		if arg1_18.name == "BodyCollider" then
			arg0_17.ladyCollider = arg1_18
		elseif arg1_18.name == "Interest" then
			arg0_17.ladyInterestRoot = arg1_18
		elseif arg1_18.name == "Head Center" then
			arg0_17.ladyHeadCenter = arg1_18
		end
	end)
	arg0_17:HXCharacter(arg0_17.lady, arg0_17.skinId)
	arg0_17.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_19)
		if arg0_17.nowState and arg0_19.animatorStateInfo:IsName(arg0_17.nowState) then
			existCall(arg0_17.stateCallback)

			return
		end

		local var0_19 = arg0_19.animatorStateInfo

		for iter0_19, iter1_19 in pairs(arg0_17.animCallbacks) do
			if var0_19:IsName(iter0_19) then
				warning("Active", iter0_19)

				local var1_19 = table.removebykey(arg0_17.animCallbacks, iter0_19)

				existCall(var1_19)

				return
			end
		end

		if arg0_19.stringParameter ~= "" then
			arg0_17:OnAnimationEvent(arg0_19)
		end
	end)

	arg0_17.animEventCallbacks = {}
	arg0_17.animCallbacks = {}
end

function var0_0.HXCharacter(arg0_20, arg1_20, arg2_20)
	if not HXSet.isHx() then
		return
	end

	Dorm3dHxHelper.ShowHolyLight({
		arg1_20
	}, arg0_20.holyLightRoot)
	arg0_20.hxHelper:Apply(arg1_20, arg2_20)
end

function var0_0.OnAnimationEvent(arg0_21, arg1_21)
	if arg1_21.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_21 = arg1_21.stringParameter
	local var1_21 = table.removebykey(arg0_21.animEventCallbacks, var0_21)

	existCall(var1_21)
end

function var0_0.init(arg0_22)
	arg0_22:findUI()
	arg0_22:addListener()
end

function var0_0.PlaySingleAction(arg0_23, arg1_23, arg2_23)
	local var0_23 = string.find(arg1_23, "^Face_")

	if tobool(var0_23) then
		arg0_23:PlayFaceAnim(arg1_23, arg2_23)

		return
	end

	arg0_23.animNameMap = arg0_23.animNameMap or {}
	arg0_23.animNameMap[arg0_23.ladyAnimator.StringToHash(arg1_23)] = arg1_23

	local var1_23 = {}

	if not arg0_23.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_23.ladyAnimBaseLayerIndex):IsName(arg1_23) then
		table.insert(var1_23, function(arg0_24)
			arg0_23.nowState = arg1_23
			arg0_23.stateCallback = arg0_24

			arg0_23.ladyAnimator:CrossFadeInFixedTime(arg1_23, 0.25, arg0_23.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_23, function(arg0_25)
			arg0_23.nowState = nil
			arg0_23.stateCallback = nil

			arg0_25()
		end)
	end

	seriesAsync(var1_23, arg2_23)
end

function var0_0.SwitchAnim(arg0_26, arg1_26, arg2_26)
	local var0_26 = string.find(arg1_26, "^Face_")

	if tobool(var0_26) then
		arg0_26:PlayFaceAnim(arg1_26, arg2_26)

		return
	end

	arg0_26.animNameMap = arg0_26.animNameMap or {}
	arg0_26.animNameMap[arg0_26.ladyAnimator.StringToHash(arg1_26)] = arg1_26

	local var1_26 = {}

	table.insert(var1_26, function(arg0_27)
		arg0_26.nowState = arg1_26
		arg0_26.stateCallback = arg0_27

		arg0_26.ladyAnimator:PlayInFixedTime(arg1_26, arg0_26.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_26, function(arg0_28)
		arg0_26.nowState = nil
		arg0_26.stateCallback = nil

		arg0_28()
	end)
	seriesAsync(var1_26, arg2_26)
end

function var0_0.PlayFaceAnim(arg0_29, arg1_29, arg2_29)
	arg0_29.ladyAnimator:CrossFadeInFixedTime(arg1_29, 0.2, arg0_29.ladyAnimFaceLayerIndex)
	existCall(arg2_29)
end

function var0_0.SetARUIActive(arg0_30, arg1_30)
	setActive(arg0_30.backBtn, arg1_30)
	setActive(arg0_30.menuListTF, arg1_30)
	setActive(arg0_30.tipTextTF, arg1_30)
end

function var0_0.SetARUIActiveWhenInit(arg0_31, arg1_31)
	setActive(arg0_31.resetBtn, false)
end

function var0_0.ResetCharPos(arg0_32)
	if arg0_32.ARCheck then
		arg0_32.lady.localPosition = Vector3.zero
		arg0_32.lady.localRotation = Vector3(0, 180, 0)
	else
		arg0_32.lady.localPosition = Vector3(0, 0, 2)
		arg0_32.lady.localRotation = Vector3(0, 180, 0)
	end
end

function var0_0.didEnter(arg0_33)
	arg0_33:emit(Dorm3dARMediator.IN_ITAR_PHOTO)
end

function var0_0.SetARLite(arg0_34, arg1_34)
	arg0_34.ARState = arg1_34
	arg0_34.ARCheck = table.contains(var0_0.AR_PASS_CODE, arg1_34)

	if GraphApiHelper.IsUsingVulkan() then
		arg0_34.ARCheck = false

		warning("ar not allow on vulkan.")
	end
end

function var0_0.InitARPlane(arg0_35)
	arg0_35._initState = true

	if arg0_35.lady then
		setActive(arg0_35.lady, false)
	end

	arg0_35:SetARUIActiveWhenInit(false)

	local var0_35 = GameObject.Find("AR")

	SetActive(var0_35, arg0_35.ARCheck)

	local var1_35 = GameObject.Find("FakeAR")

	SetActive(var1_35, not arg0_35.ARCheck)

	if arg0_35.ARCheck then
		originalPrint("AR CHECK SUCCESS, INIT AR")
		arg0_35.aiHelperSC:Init()
		arg0_35:emit(Dorm3dARMediator.INIT_AR_PLANE)
	else
		originalPrint("AR CHECK FAIL")
		arg0_35:InitARFinish()
		arg0_35:EnabledDrag()
	end

	if PLATFORM == PLATFORM_WINDOWSEDITOR then
		arg0_35:InitARFinish()
	end
end

function var0_0.Reset(arg0_36)
	arg0_36._initState = true

	if arg0_36.lady then
		setActive(arg0_36.lady, false)
	end

	arg0_36:SetARUIActiveWhenInit(false)

	if arg0_36.ARCheck then
		arg0_36.aiHelperSC:ResetAll()
	end
end

function var0_0.InitARFinish(arg0_37)
	setActive(arg0_37.tipsLabel, false)
	arg0_37:emit(Dorm3dARMediator.AR_INIT_FINISH)
	arg0_37:InitCharacter(arg0_37.contextData.groupId)

	if arg0_37.ARCheck then
		local var0_37 = GameObject.Find("Tpl(Clone)").transform

		arg0_37.lady:SetParent(var0_37)
	else
		arg0_37.lady:SetParent(arg0_37.tpl)
	end

	arg0_37:ResetCharPos()
	arg0_37:SetARUIActiveWhenInit(true)

	arg0_37._initState = false
end

function var0_0.willExit(arg0_38)
	arg0_38.loader:Clear()

	arg0_38.hxHelper = nil

	if arg0_38.ARCheck then
		arg0_38.aiHelperSC:ResetAll()
		arg0_38.aiHelperSC:Destroy()
	end

	local var0_38 = GameObject.Find("Tpl(Clone)")

	if var0_38 then
		Destroy(var0_38)
	end

	local var1_38, var2_38 = unpack(string.split(var1_0, "|"))

	SceneOpMgr.Inst:UnloadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. var2_38 .. "/" .. var1_38 .. "_scene"), var1_38)

	if arg0_38.luHandle then
		LateUpdateBeat:RemoveListener(arg0_38.luHandle)
	end
end

function var0_0.findUI(arg0_39)
	arg0_39.backBtn = arg0_39._tf:Find("BackBtn")
	arg0_39.menuListTF = arg0_39._tf:Find("MenuList")
	arg0_39.initARBtn = arg0_39.menuListTF:Find("InitARBtn")
	arg0_39.resetBtn = arg0_39.menuListTF:Find("ResetBtn")
	arg0_39.tipTextTF = arg0_39._tf:Find("TipText")
	arg0_39.tipsLabel = arg0_39.tipTextTF:Find("tipsText")
	arg0_39.tipsText = arg0_39.tipTextTF:Find("tipsText/text")

	setActive(arg0_39.tipsLabel, false)

	arg0_39.fakeARCanvas = GameObject.Find("FakeAR/Main Camera/ARCanvas").transform

	setSizeDelta(arg0_39.fakeARCanvas, Vector2(Screen.width, Screen.height))

	arg0_39.fakeARCamera = GameObject.Find("FakeAR/Main Camera"):GetComponent("Camera")
	arg0_39.drag = arg0_39._tf:Find("drag")

	local var0_39 = GameObject.Find("ARScriptHandle")

	arg0_39.aiHelperSC = GetComponent(var0_39, "ARHelper")
	arg0_39.aiHelperSC.tplPrefab = GameObject.Find("Tpl")
	arg0_39.tpl = GameObject.Find("Tpl").transform
	arg0_39.holyLightRoot = arg0_39._tf:Find("HolyLightRoot")
end

function var0_0.addListener(arg0_40)
	onButton(arg0_40, arg0_40.backBtn, function()
		arg0_40:closeView()
	end, SFX_PANEL)
	onButton(arg0_40, arg0_40.resetBtn, function()
		arg0_40:Reset()
	end, SFX_PANEL)

	function arg0_40.aiHelperSC.planeCountCB(arg0_43, arg1_43)
		if not (arg0_43 > 0) then
			setActive(arg0_40.tipsLabel, true)
			setText(arg0_40.tipsText, i18n("AR_plane_check"))
		elseif not arg1_43 then
			setActive(arg0_40.tipsLabel, true)
			setText(arg0_40.tipsText, i18n("AR_plane_long_press_to_summon"))
		elseif arg0_40._initState then
			arg0_40:InitARFinish()
		end
	end

	function arg0_40.aiHelperSC.distanceCB(arg0_44)
		if arg0_44 < 0.3 then
			arg0_40.distanceFlag = true

			setActive(arg0_40.lady, false)
			setActive(arg0_40.tipsLabel, true)
			setText(arg0_40.tipsText, i18n("AR_plane_distance_near"))
		elseif arg0_40.distanceFlag then
			setActive(arg0_40.tipsLabel, false)
			setActive(arg0_40.lady, true)

			arg0_40.distanceFlag = false
		end
	end

	function arg0_40.aiHelperSC.insPrefabFailCB()
		warning("距离过近，呼出角色失败")
		pg.TipsMgr.GetInstance():ShowTips(i18n("AR_plane_summon_fail_by_near"))
	end

	function arg0_40.aiHelperSC.insPrefabSuccCB()
		setActive(arg0_40.tipsLabel, false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("AR_plane_summon_success"))
		arg0_40.aiHelperSC:StopPlaneCheck()
	end
end

function var0_0.EnabledDrag(arg0_47)
	arg0_47.lady.localScale = Vector3(5, 5, 5)

	local var0_47 = LuaHelper.GetWorldCorners(arg0_47._tf:GetComponent("RectTransform"))
	local var1_47 = var0_47[2].x - var0_47[0].x
	local var2_47 = var0_47[2].y - var0_47[0].y

	arg0_47.widthRate = var1_47 / pg.CameraFixMgr.GetInstance().actualWidth
	arg0_47.heightRate = var2_47 / pg.CameraFixMgr.GetInstance().actualHeight
	arg0_47.halfWidth = var1_47 / 2
	arg0_47.halfHeight = var2_47 / 2
	arg0_47.isEnableDrag = true

	local var3_47 = arg0_47.drag.gameObject

	GetOrAddComponent(var3_47, typeof(Button))

	arg0_47.zoom = GetOrAddComponent(arg0_47._tf, typeof(PinchZoom))
	arg0_47.zoom.enabled = true

	local var4_47 = GetOrAddComponent(var3_47, typeof(EventTriggerListener))
	local var5_47 = Vector3(0, 0, 0)

	var4_47:AddBeginDragFunc(function(arg0_48, arg1_48)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if arg0_47.zoom.processing then
			return
		end

		setButtonEnabled(var3_47, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_48 = var0_0.Screen2Local(var3_47.transform.parent, arg1_48.position)

		var5_47 = arg0_47.drag.localPosition - var0_48
	end)
	var4_47:AddDragFunc(function(arg0_49, arg1_49)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if arg0_47.zoom.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_49 = var0_0.Screen2Local(var3_47.transform.parent, arg1_49.position)

		arg0_47.drag.localPosition = Vector3(var0_49.x, var0_49.y, 0) + var5_47
		arg0_47.tpl.localPosition = arg0_47:GetUI2Char(arg1_49.position)
	end)
	var4_47:AddDragEndFunc(function()
		setButtonEnabled(var3_47, true)
	end)

	var4_47.enabled = true
	Input.multiTouchEnabled = true
	arg0_47.fakeARCamera.orthographicSize = 8
	arg0_47.fakeARCamera.orthographic = true
	arg0_47.luHandle = LateUpdateBeat:CreateListener(function()
		if arg0_47.zoom.processing then
			local var0_51 = arg0_47.drag.localScale.x

			arg0_47.tpl.localScale = Vector3(var0_51, var0_51, var0_51)
		end
	end, arg0_47)

	LateUpdateBeat:AddListener(arg0_47.luHandle)
end

function var0_0.GetUI2Char(arg0_52, arg1_52)
	local var0_52 = arg0_52.widthRate * arg1_52.x - arg0_52.halfWidth
	local var1_52 = arg0_52.heightRate * arg1_52.y - arg0_52.halfHeight

	return Vector3(var0_52, var1_52, 2)
end

function var0_0.Screen2Local(arg0_53, arg1_53)
	local var0_53 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_53 = arg0_53:GetComponent("RectTransform")
	local var2_53 = LuaHelper.ScreenToLocal(var1_53, arg1_53, var0_53)

	return Vector3(var2_53.x, var2_53.y, 0)
end

return var0_0
