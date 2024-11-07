local var0_0 = class("Dorm3dARScene", import("view.base.BaseUI"))
local var1_0 = "arscene|common/ar"

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

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.loadingQueue(arg0_3)
	return function(arg0_4)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_5)
			return arg0_4(arg0_5)
		end)
	end
end

function var0_0.Ctor(arg0_6, ...)
	var0_0.super.Ctor(arg0_6, ...)

	arg0_6.loader = AutoLoader.New()
end

function var0_0.preload(arg0_7, arg1_7)
	arg0_7.room = getProxy(ApartmentProxy):getRoom(arg0_7.contextData.roomId)

	local var0_7, var1_7 = unpack(string.split(string.lower(var1_0), "|"))

	seriesAsync({
		function(arg0_8)
			SceneOpMgr.Inst:LoadSceneAsync("dorm3d/scenesres/scenes/" .. var1_7 .. "/" .. var0_7 .. "_scene", var0_7, LoadSceneMode.Additive, function(arg0_9, arg1_9)
				arg0_8()
			end)
		end,
		function(arg0_10)
			arg0_7:LoadCharacter({
				arg0_7.contextData.groupId
			}, arg0_10)
		end
	}, arg1_7)
end

function var0_0.LoadCharacter(arg0_11, arg1_11, arg2_11)
	arg0_11.hxMatDict = {}
	arg0_11.ladyDict = {}
	arg0_11.skinDict = {}

	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		local var1_11 = arg0_11

		arg0_11.ladyDict[iter1_11] = var1_11

		local var2_11 = getProxy(ApartmentProxy):getApartment(iter1_11)
		local var3_11 = var2_11:getConfig("asset_name")
		local var4_11 = var2_11:GetSkinModelID(arg0_11.room:getConfig("tag"))
		local var5_11 = pg.dorm3d_resource[var4_11].model_id

		assert(var5_11)

		for iter2_11, iter3_11 in ipairs({
			"common",
			var5_11
		}) do
			local var6_11 = string.format("dorm3d/character/%s/res/%s", var3_11, iter3_11)

			if checkABExist(var6_11) then
				table.insert(var0_11, function(arg0_12)
					arg0_11.loader:LoadBundle(var6_11, function(arg0_13)
						for iter0_13, iter1_13 in ipairs(arg0_13:GetAllAssetNames()) do
							local var0_13, var1_13, var2_13 = string.find(iter1_13, "material_hx[/\\](.*).mat")

							if var0_13 then
								arg0_11.hxMatDict[var2_13] = {
									arg0_13,
									iter1_13
								}
							end
						end

						arg0_12()
					end)
				end)
			end
		end

		var1_11.skinId = var4_11
		var1_11.skinIdList = {
			var4_11
		}

		table.insert(var0_11, function(arg0_14)
			local var0_14 = string.format("dorm3d/character/%s/prefabs/%s", var3_11, var5_11)

			arg0_11.loader:GetPrefab(var0_14, "", function(arg0_15)
				var1_11.ladyGameobject = arg0_15

				setActive(arg0_15.transform, false)

				arg0_11.skinDict[var4_11] = {
					ladyGameobject = arg0_15
				}

				arg0_14()
			end)
		end)
	end

	parallelAsync(var0_11, arg2_11)
end

function var0_0.InitCharacter(arg0_16, arg1_16)
	arg0_16.lady = arg0_16.ladyGameobject.transform

	arg0_16.lady:SetParent(arg0_16.mainCameraTF)
	arg0_16.lady:SetParent(nil)
	setActive(arg0_16.lady, true)

	arg0_16.ladyAnimator = arg0_16.lady:GetComponent(typeof(Animator))
	arg0_16.ladyAnimBaseLayerIndex = arg0_16.ladyAnimator:GetLayerIndex("Base Layer")
	arg0_16.ladyAnimFaceLayerIndex = arg0_16.ladyAnimator:GetLayerIndex("Face")
	arg0_16.ladyBoneMaps = {}

	local var0_16 = arg0_16.lady:GetComponentsInChildren(typeof(Transform), true)

	table.IpairsCArray(var0_16, function(arg0_17, arg1_17)
		if arg1_17.name == "BodyCollider" then
			arg0_16.ladyCollider = arg1_17
		elseif arg1_17.name == "Interest" then
			arg0_16.ladyInterestRoot = arg1_17
		elseif arg1_17.name == "Head Center" then
			arg0_16.ladyHeadCenter = arg1_17
		end
	end)
	arg0_16:HXCharacter(arg0_16.lady)
	arg0_16.ladyAnimator:GetComponent("DftAniEvent"):SetCommonEvent(function(arg0_18)
		if arg0_16.nowState and arg0_18.animatorStateInfo:IsName(arg0_16.nowState) then
			existCall(arg0_16.stateCallback)

			return
		end

		local var0_18 = arg0_18.animatorStateInfo

		for iter0_18, iter1_18 in pairs(arg0_16.animCallbacks) do
			if var0_18:IsName(iter0_18) then
				warning("Active", iter0_18)

				local var1_18 = table.removebykey(arg0_16.animCallbacks, iter0_18)

				existCall(var1_18)

				return
			end
		end

		if arg0_18.stringParameter ~= "" then
			arg0_16:OnAnimationEvent(arg0_18)
		end
	end)

	arg0_16.animEventCallbacks = {}
	arg0_16.animCallbacks = {}
end

function var0_0.HXCharacter(arg0_19, arg1_19)
	if not HXSet.isHx() then
		return
	end

	local var0_19 = arg1_19:GetComponentsInChildren(typeof(SkinnedMeshRenderer))

	table.IpairsCArray(var0_19, function(arg0_20, arg1_20)
		local var0_20 = arg1_20.sharedMaterials
		local var1_20 = false

		table.IpairsCArray(var0_20, function(arg0_21, arg1_21)
			local var0_21 = arg1_21.name

			if not arg0_19.hxMatDict[var0_21] then
				return
			end

			var1_20 = true

			local var1_21, var2_21 = unpack(arg0_19.hxMatDict[var0_21])
			local var3_21 = var1_21:LoadAssetSync(var2_21, typeof(Material), true, false)

			var0_20[arg0_21] = var3_21

			warning("Replace HX Material", arg0_19.hxMatDict[var0_21][2])
		end)

		if var1_20 then
			arg1_20.sharedMaterials = var0_20
		end
	end)
end

function var0_0.OnAnimationEvent(arg0_22, arg1_22)
	if arg1_22.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_22 = arg1_22.stringParameter
	local var1_22 = table.removebykey(arg0_22.animEventCallbacks, var0_22)

	existCall(var1_22)
end

function var0_0.init(arg0_23)
	arg0_23:findUI()
	arg0_23:addListener()
end

function var0_0.PlaySingleAction(arg0_24, arg1_24, arg2_24)
	local var0_24 = string.find(arg1_24, "^Face_")

	if tobool(var0_24) then
		arg0_24:PlayFaceAnim(arg1_24, arg2_24)

		return
	end

	arg0_24.animNameMap = arg0_24.animNameMap or {}
	arg0_24.animNameMap[arg0_24.ladyAnimator.StringToHash(arg1_24)] = arg1_24

	local var1_24 = {}

	if not arg0_24.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_24.ladyAnimBaseLayerIndex):IsName(arg1_24) then
		table.insert(var1_24, function(arg0_25)
			arg0_24.nowState = arg1_24
			arg0_24.stateCallback = arg0_25

			arg0_24.ladyAnimator:CrossFadeInFixedTime(arg1_24, 0.25, arg0_24.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_24, function(arg0_26)
			arg0_24.nowState = nil
			arg0_24.stateCallback = nil

			arg0_26()
		end)
	end

	seriesAsync(var1_24, arg2_24)
end

function var0_0.SwitchAnim(arg0_27, arg1_27, arg2_27)
	local var0_27 = string.find(arg1_27, "^Face_")

	if tobool(var0_27) then
		arg0_27:PlayFaceAnim(arg1_27, arg2_27)

		return
	end

	arg0_27.animNameMap = arg0_27.animNameMap or {}
	arg0_27.animNameMap[arg0_27.ladyAnimator.StringToHash(arg1_27)] = arg1_27

	local var1_27 = {}

	table.insert(var1_27, function(arg0_28)
		arg0_27.nowState = arg1_27
		arg0_27.stateCallback = arg0_28

		arg0_27.ladyAnimator:PlayInFixedTime(arg1_27, arg0_27.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_27, function(arg0_29)
		arg0_27.nowState = nil
		arg0_27.stateCallback = nil

		arg0_29()
	end)
	seriesAsync(var1_27, arg2_27)
end

function var0_0.PlayFaceAnim(arg0_30, arg1_30, arg2_30)
	arg0_30.ladyAnimator:CrossFadeInFixedTime(arg1_30, 0.2, arg0_30.ladyAnimFaceLayerIndex)
	existCall(arg2_30)
end

function var0_0.SetARUIActive(arg0_31, arg1_31)
	setActive(arg0_31.backBtn, arg1_31)
	setActive(arg0_31.menuListTF, arg1_31)
	setActive(arg0_31.tipTextTF, arg1_31)
end

function var0_0.SetARUIActiveWhenInit(arg0_32, arg1_32)
	setActive(arg0_32.resetBtn, arg1_32)
end

function var0_0.ResetCharPos(arg0_33)
	arg0_33.lady.localPosition = Vector3.zero
	arg0_33.lady.localRotation = Vector3.zero
end

function var0_0.didEnter(arg0_34)
	arg0_34:emit(Dorm3dARMediator.IN_ITAR_PHOTO)
end

function var0_0.SetARLite(arg0_35, arg1_35)
	arg0_35.ARState = arg1_35
	arg0_35.ARCheck = table.contains(var0_0.AR_PASS_CODE, arg1_35)
end

function var0_0.InitARPlane(arg0_36)
	arg0_36._initState = true

	if arg0_36.lady then
		setActive(arg0_36.lady, false)
	end

	arg0_36:SetARUIActiveWhenInit(false)

	if arg0_36.ARCheck then
		originalPrint("AR CHECK SUCCESS, INIT AR")
		setActive(arg0_36.snapShot, false)
		arg0_36.aiHelperSC:Init()
		arg0_36:emit(Dorm3dARMediator.INIT_AR_PLANE)
	else
		originalPrint("AR CHECK FAIL")
		setActive(arg0_36.snapShot, true)
		arg0_36:InitARFinish()
		arg0_36:EnabledDrag()
	end

	if PLATFORM == PLATFORM_WINDOWSEDITOR then
		arg0_36:InitARFinish()
	end
end

function var0_0.Reset(arg0_37)
	arg0_37._initState = true

	if arg0_37.lady then
		setActive(arg0_37.lady, false)
	end

	arg0_37:SetARUIActiveWhenInit(false)
	arg0_37.aiHelperSC:ResetAll()
end

function var0_0.InitARFinish(arg0_38)
	setActive(arg0_38.tipsLabel, false)
	arg0_38:emit(Dorm3dARMediator.AR_INIT_FINISH)
	arg0_38:InitCharacter(arg0_38.contextData.groupId)

	if arg0_38.ARCheck then
		local var0_38 = GameObject.Find("Tpl(Clone)").transform

		arg0_38.lady:SetParent(var0_38)
	else
		arg0_38.lady:SetParent(arg0_38.tpl)
	end

	arg0_38:ResetCharPos()
	arg0_38:SetARUIActiveWhenInit(true)

	arg0_38._initState = false
end

function var0_0.willExit(arg0_39)
	arg0_39.loader:Clear()
	arg0_39.aiHelperSC:Destroy()

	local var0_39, var1_39 = unpack(string.split(string.lower(var1_0), "|"))

	SceneOpMgr.Inst:UnloadSceneAsync(var1_39, var0_39)

	if arg0_39.luHandle then
		LateUpdateBeat:RemoveListener(arg0_39.luHandle)
	end
end

function var0_0.findUI(arg0_40)
	arg0_40.backBtn = arg0_40:findTF("BackBtn")
	arg0_40.menuListTF = arg0_40:findTF("MenuList")
	arg0_40.initARBtn = arg0_40:findTF("InitARBtn", arg0_40.menuListTF)
	arg0_40.resetBtn = arg0_40:findTF("ResetBtn", arg0_40.menuListTF)
	arg0_40.tipTextTF = arg0_40:findTF("TipText")
	arg0_40.tipsLabel = arg0_40:findTF("tipsText", arg0_40.tipTextTF)
	arg0_40.tipsText = arg0_40:findTF("tipsText/text", arg0_40.tipTextTF)

	setActive(arg0_40.tipsLabel, false)

	arg0_40.snapShot = GameObject.Find("ARCanvas").transform
	arg0_40.arCamera = GameObject.Find("AR Camera"):GetComponent("Camera")

	setActive(arg0_40.snapShot, false)

	arg0_40.drag = arg0_40:findTF("drag")

	local var0_40 = GameObject.Find("ARScriptHandle")

	arg0_40.aiHelperSC = GetComponent(var0_40, "ARHelper")
	arg0_40.aiHelperSC.tplPrefab = GameObject.Find("Tpl")
	arg0_40.tpl = GameObject.Find("Tpl").transform
end

function var0_0.addListener(arg0_41)
	onButton(arg0_41, arg0_41.backBtn, function()
		arg0_41:closeView()
	end, SFX_PANEL)
	onButton(arg0_41, arg0_41.resetBtn, function()
		arg0_41:Reset()
	end, SFX_PANEL)

	function arg0_41.aiHelperSC.planeCountCB(arg0_44, arg1_44)
		local var0_44 = arg0_44 > 0

		setActive(arg0_41.tipsLabel, true)
		arg0_41.aiHelperSC:ShowAllPlane(true)

		if not var0_44 then
			setText(arg0_41.tipsText, i18n("AR_plane_check"))
		elseif not arg1_44 then
			setText(arg0_41.tipsText, i18n("AR_plane_long_press_to_summon"))
		elseif arg0_41._initState then
			arg0_41:InitARFinish()
		end
	end

	function arg0_41.aiHelperSC.distanceCB(arg0_45)
		if arg0_45 < 0.3 then
			arg0_41.distanceFlag = true

			setActive(arg0_41.lady, false)
			setActive(arg0_41.tipsLabel, true)
			setText(arg0_41.tipsText, i18n("AR_plane_distance_near"))
		elseif arg0_41.distanceFlag then
			setActive(arg0_41.tipsLabel, false)
			setActive(arg0_41.lady, true)

			arg0_41.distanceFlag = false
		end
	end

	function arg0_41.aiHelperSC.insPrefabFailCB()
		warning("距离过近，呼出角色失败")
		pg.TipsMgr.GetInstance():ShowTips(i18n("AR_plane_summon_fail_by_near"))
	end

	function arg0_41.aiHelperSC.insPrefabSuccCB()
		arg0_41.aiHelperSC:ShowAllPlane(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("AR_plane_summon_success"))
		arg0_41.aiHelperSC:StopPlaneCheck()
	end
end

function var0_0.EnabledDrag(arg0_48)
	arg0_48.lady.localScale = Vector3(5, 5, 5)

	local var0_48 = LuaHelper.GetWorldCorners(arg0_48._tf:GetComponent("RectTransform"))
	local var1_48 = var0_48[2].x - var0_48[0].x
	local var2_48 = var0_48[2].y - var0_48[0].y

	arg0_48.widthRate = var1_48 / pg.CameraFixMgr.GetInstance().actualWidth
	arg0_48.heightRate = var2_48 / pg.CameraFixMgr.GetInstance().actualHeight
	arg0_48.halfWidth = var1_48 / 2
	arg0_48.halfHeight = var2_48 / 2
	arg0_48.isEnableDrag = true

	local var3_48 = arg0_48.drag.gameObject

	arg0_48.zoom = GetOrAddComponent(arg0_48._tf, typeof(PinchZoom))
	arg0_48.zoom.enabled = true

	local var4_48 = GetOrAddComponent(var3_48, typeof(EventTriggerListener))
	local var5_48 = Vector3(0, 0, 0)

	var4_48:AddBeginDragFunc(function(arg0_49, arg1_49)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if arg0_48.zoom.processing then
			return
		end

		setButtonEnabled(var3_48, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_49 = var0_0.Screen2Local(var3_48.transform.parent, arg1_49.position)

		var5_48 = arg0_48.drag.localPosition - var0_49
	end)
	var4_48:AddDragFunc(function(arg0_50, arg1_50)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if arg0_48.zoom.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_50 = var0_0.Screen2Local(var3_48.transform.parent, arg1_50.position)

		arg0_48.drag.localPosition = Vector3(var0_50.x, var0_50.y, 0) + var5_48
		arg0_48.tpl.localPosition = arg0_48:GetUI2Char(arg1_50.position)
	end)
	var4_48:AddDragEndFunc(function()
		setButtonEnabled(var3_48, true)
	end)

	var4_48.enabled = true
	Input.multiTouchEnabled = true
	arg0_48.arCamera.orthographicSize = 8
	arg0_48.arCamera.orthographic = true
	arg0_48.luHandle = LateUpdateBeat:CreateListener(function()
		if arg0_48.zoom.processing then
			local var0_52 = arg0_48.drag.localScale.x

			arg0_48.tpl.localScale = Vector3(var0_52, var0_52, var0_52)
		end
	end, arg0_48)

	LateUpdateBeat:AddListener(arg0_48.luHandle)
end

function var0_0.GetUI2Char(arg0_53, arg1_53)
	local var0_53 = arg0_53.widthRate * arg1_53.x - arg0_53.halfWidth
	local var1_53 = arg0_53.heightRate * arg1_53.y - arg0_53.halfHeight

	return Vector3(var0_53, var1_53, 2)
end

function var0_0.Screen2Local(arg0_54, arg1_54)
	local var0_54 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_54 = arg0_54:GetComponent("RectTransform")
	local var2_54 = LuaHelper.ScreenToLocal(var1_54, arg1_54, var0_54)

	return Vector3(var2_54.x, var2_54.y, 0)
end

return var0_0
