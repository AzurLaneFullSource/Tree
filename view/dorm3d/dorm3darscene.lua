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
						local var0_13 = arg0_13:GetAllAssetNames()

						table.IpairsCArray(var0_13, function(arg0_14, arg1_14)
							local var0_14, var1_14, var2_14 = string.find(arg1_14, "material_hx[/\\](.*).mat")

							if var0_14 then
								arg0_11.hxMatDict[var2_14] = {
									arg0_13,
									arg1_14
								}
							end
						end)
						arg0_12()
					end)
				end)
			end
		end

		var1_11.skinId = var4_11
		var1_11.skinIdList = {
			var4_11
		}

		table.insert(var0_11, function(arg0_15)
			local var0_15 = string.format("dorm3d/character/%s/prefabs/%s", var3_11, var5_11)

			arg0_11.loader:GetPrefab(var0_15, "", function(arg0_16)
				var1_11.ladyGameobject = arg0_16

				setActive(arg0_16.transform, false)

				arg0_11.skinDict[var4_11] = {
					ladyGameobject = arg0_16
				}

				arg0_15()
			end)
		end)
	end

	parallelAsync(var0_11, arg2_11)
end

function var0_0.InitCharacter(arg0_17, arg1_17)
	arg0_17.lady = arg0_17.ladyGameobject.transform

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
	arg0_17:HXCharacter(arg0_17.lady)
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

function var0_0.HXCharacter(arg0_20, arg1_20)
	if not HXSet.isHx() then
		return
	end

	local var0_20 = arg1_20:GetComponentsInChildren(typeof(SkinnedMeshRenderer))

	table.IpairsCArray(var0_20, function(arg0_21, arg1_21)
		local var0_21 = arg1_21.sharedMaterials
		local var1_21 = false

		table.IpairsCArray(var0_21, function(arg0_22, arg1_22)
			local var0_22 = arg1_22.name

			if not arg0_20.hxMatDict[var0_22] then
				return
			end

			var1_21 = true

			local var1_22 = arg0_20.hxMatDict[var0_22][1]:LoadAssetSync(arg0_20.hxMatDict[var0_22][2], typeof(Material), true, false)

			var0_21[arg0_22] = var1_22

			warning("Replace HX Material", arg0_20.hxMatDict[var0_22][2])
		end)

		if var1_21 then
			arg1_21.sharedMaterials = var0_21
		end
	end)
end

function var0_0.OnAnimationEvent(arg0_23, arg1_23)
	if arg1_23.animatorClipInfo.weight < 0.5 then
		return
	end

	local var0_23 = arg1_23.stringParameter
	local var1_23 = table.removebykey(arg0_23.animEventCallbacks, var0_23)

	existCall(var1_23)
end

function var0_0.init(arg0_24)
	arg0_24:findUI()
	arg0_24:addListener()
end

function var0_0.PlaySingleAction(arg0_25, arg1_25, arg2_25)
	local var0_25 = string.find(arg1_25, "^Face_")

	if tobool(var0_25) then
		arg0_25:PlayFaceAnim(arg1_25, arg2_25)

		return
	end

	arg0_25.animNameMap = arg0_25.animNameMap or {}
	arg0_25.animNameMap[arg0_25.ladyAnimator.StringToHash(arg1_25)] = arg1_25

	local var1_25 = {}

	if not arg0_25.ladyAnimator:GetCurrentAnimatorStateInfo(arg0_25.ladyAnimBaseLayerIndex):IsName(arg1_25) then
		table.insert(var1_25, function(arg0_26)
			arg0_25.nowState = arg1_25
			arg0_25.stateCallback = arg0_26

			arg0_25.ladyAnimator:CrossFadeInFixedTime(arg1_25, 0.25, arg0_25.ladyAnimBaseLayerIndex)
		end)
		table.insert(var1_25, function(arg0_27)
			arg0_25.nowState = nil
			arg0_25.stateCallback = nil

			arg0_27()
		end)
	end

	seriesAsync(var1_25, arg2_25)
end

function var0_0.SwitchAnim(arg0_28, arg1_28, arg2_28)
	local var0_28 = string.find(arg1_28, "^Face_")

	if tobool(var0_28) then
		arg0_28:PlayFaceAnim(arg1_28, arg2_28)

		return
	end

	arg0_28.animNameMap = arg0_28.animNameMap or {}
	arg0_28.animNameMap[arg0_28.ladyAnimator.StringToHash(arg1_28)] = arg1_28

	local var1_28 = {}

	table.insert(var1_28, function(arg0_29)
		arg0_28.nowState = arg1_28
		arg0_28.stateCallback = arg0_29

		arg0_28.ladyAnimator:PlayInFixedTime(arg1_28, arg0_28.ladyAnimBaseLayerIndex)
	end)
	table.insert(var1_28, function(arg0_30)
		arg0_28.nowState = nil
		arg0_28.stateCallback = nil

		arg0_30()
	end)
	seriesAsync(var1_28, arg2_28)
end

function var0_0.PlayFaceAnim(arg0_31, arg1_31, arg2_31)
	arg0_31.ladyAnimator:CrossFadeInFixedTime(arg1_31, 0.2, arg0_31.ladyAnimFaceLayerIndex)
	existCall(arg2_31)
end

function var0_0.SetARUIActive(arg0_32, arg1_32)
	setActive(arg0_32.backBtn, arg1_32)
	setActive(arg0_32.menuListTF, arg1_32)
	setActive(arg0_32.tipTextTF, arg1_32)
end

function var0_0.SetARUIActiveWhenInit(arg0_33, arg1_33)
	setActive(arg0_33.resetBtn, arg1_33)
end

function var0_0.ResetCharPos(arg0_34)
	arg0_34.lady.localPosition = Vector3.zero
	arg0_34.lady.localRotation = Vector3.zero
end

function var0_0.didEnter(arg0_35)
	arg0_35:emit(Dorm3dARMediator.IN_ITAR_PHOTO)
end

function var0_0.SetARLite(arg0_36, arg1_36)
	arg0_36.ARState = arg1_36
	arg0_36.ARCheck = table.contains(var0_0.AR_PASS_CODE, arg1_36)
end

function var0_0.InitARPlane(arg0_37)
	arg0_37._initState = true

	if arg0_37.lady then
		setActive(arg0_37.lady, false)
	end

	arg0_37:SetARUIActiveWhenInit(false)

	if arg0_37.ARCheck then
		originalPrint("AR CHECK SUCCESS, INIT AR")
		setActive(arg0_37.snapShot, false)
		arg0_37.aiHelperSC:Init()
		arg0_37:emit(Dorm3dARMediator.INIT_AR_PLANE)
	else
		originalPrint("AR CHECK FAIL")
		setActive(arg0_37.snapShot, true)
		arg0_37:InitARFinish()
		arg0_37:EnabledDrag()
	end

	if PLATFORM == PLATFORM_WINDOWSEDITOR then
		arg0_37:InitARFinish()
	end
end

function var0_0.Reset(arg0_38)
	arg0_38._initState = true

	if arg0_38.lady then
		setActive(arg0_38.lady, false)
	end

	arg0_38:SetARUIActiveWhenInit(false)
	arg0_38.aiHelperSC:ResetAll()
end

function var0_0.InitARFinish(arg0_39)
	setActive(arg0_39.tipsLabel, false)
	arg0_39:emit(Dorm3dARMediator.AR_INIT_FINISH)
	arg0_39:InitCharacter(arg0_39.contextData.groupId)

	if arg0_39.ARCheck then
		local var0_39 = GameObject.Find("Tpl(Clone)").transform

		arg0_39.lady:SetParent(var0_39)
	else
		arg0_39.lady:SetParent(arg0_39.tpl)
	end

	arg0_39:ResetCharPos()
	arg0_39:SetARUIActiveWhenInit(true)

	arg0_39._initState = false
end

function var0_0.willExit(arg0_40)
	arg0_40.loader:Clear()
	arg0_40.aiHelperSC:Destroy()

	local var0_40, var1_40 = unpack(string.split(string.lower(var1_0), "|"))

	SceneOpMgr.Inst:UnloadSceneAsync(var1_40, var0_40)

	if arg0_40.luHandle then
		LateUpdateBeat:RemoveListener(arg0_40.luHandle)
	end
end

function var0_0.findUI(arg0_41)
	arg0_41.backBtn = arg0_41:findTF("BackBtn")
	arg0_41.menuListTF = arg0_41:findTF("MenuList")
	arg0_41.initARBtn = arg0_41:findTF("InitARBtn", arg0_41.menuListTF)
	arg0_41.resetBtn = arg0_41:findTF("ResetBtn", arg0_41.menuListTF)
	arg0_41.tipTextTF = arg0_41:findTF("TipText")
	arg0_41.tipsLabel = arg0_41:findTF("tipsText", arg0_41.tipTextTF)
	arg0_41.tipsText = arg0_41:findTF("tipsText/text", arg0_41.tipTextTF)

	setActive(arg0_41.tipsLabel, false)

	arg0_41.snapShot = GameObject.Find("ARCanvas").transform
	arg0_41.arCamera = GameObject.Find("AR Camera"):GetComponent("Camera")

	setActive(arg0_41.snapShot, false)

	arg0_41.drag = arg0_41:findTF("drag")

	local var0_41 = GameObject.Find("ARScriptHandle")

	arg0_41.aiHelperSC = GetComponent(var0_41, "ARHelper")
	arg0_41.aiHelperSC.tplPrefab = GameObject.Find("Tpl")
	arg0_41.tpl = GameObject.Find("Tpl").transform
end

function var0_0.addListener(arg0_42)
	onButton(arg0_42, arg0_42.backBtn, function()
		arg0_42:closeView()
	end, SFX_PANEL)
	onButton(arg0_42, arg0_42.resetBtn, function()
		arg0_42:Reset()
	end, SFX_PANEL)

	function arg0_42.aiHelperSC.planeCountCB(arg0_45, arg1_45)
		local var0_45 = arg0_45 > 0

		setActive(arg0_42.tipsLabel, true)
		arg0_42.aiHelperSC:ShowAllPlane(true)

		if not var0_45 then
			setText(arg0_42.tipsText, i18n("AR_plane_check"))
		elseif not arg1_45 then
			setText(arg0_42.tipsText, i18n("AR_plane_long_press_to_summon"))
		elseif arg0_42._initState then
			arg0_42:InitARFinish()
		end
	end

	function arg0_42.aiHelperSC.distanceCB(arg0_46)
		if arg0_46 < 0.3 then
			arg0_42.distanceFlag = true

			setActive(arg0_42.lady, false)
			setActive(arg0_42.tipsLabel, true)
			setText(arg0_42.tipsText, i18n("AR_plane_distance_near"))
		elseif arg0_42.distanceFlag then
			setActive(arg0_42.tipsLabel, false)
			setActive(arg0_42.lady, true)

			arg0_42.distanceFlag = false
		end
	end

	function arg0_42.aiHelperSC.insPrefabFailCB()
		warning("距离过近，呼出角色失败")
		pg.TipsMgr.GetInstance():ShowTips(i18n("AR_plane_summon_fail_by_near"))
	end

	function arg0_42.aiHelperSC.insPrefabSuccCB()
		arg0_42.aiHelperSC:ShowAllPlane(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("AR_plane_summon_success"))
		arg0_42.aiHelperSC:StopPlaneCheck()
	end
end

function var0_0.EnabledDrag(arg0_49)
	arg0_49.lady.localScale = Vector3(5, 5, 5)

	local var0_49 = LuaHelper.GetWorldCorners(arg0_49._tf:GetComponent("RectTransform"))
	local var1_49 = var0_49[2].x - var0_49[0].x
	local var2_49 = var0_49[2].y - var0_49[0].y

	arg0_49.widthRate = var1_49 / pg.CameraFixMgr.GetInstance().actualWidth
	arg0_49.heightRate = var2_49 / pg.CameraFixMgr.GetInstance().actualHeight
	arg0_49.halfWidth = var1_49 / 2
	arg0_49.halfHeight = var2_49 / 2
	arg0_49.isEnableDrag = true

	local var3_49 = arg0_49.drag.gameObject

	arg0_49.zoom = GetOrAddComponent(arg0_49._tf, typeof(PinchZoom))
	arg0_49.zoom.enabled = true

	local var4_49 = GetOrAddComponent(var3_49, typeof(EventTriggerListener))
	local var5_49 = Vector3(0, 0, 0)

	var4_49:AddBeginDragFunc(function(arg0_50, arg1_50)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if arg0_49.zoom.processing then
			return
		end

		setButtonEnabled(var3_49, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_50 = var0_0.Screen2Local(var3_49.transform.parent, arg1_50.position)

		var5_49 = arg0_49.drag.localPosition - var0_50
	end)
	var4_49:AddDragFunc(function(arg0_51, arg1_51)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if arg0_49.zoom.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_51 = var0_0.Screen2Local(var3_49.transform.parent, arg1_51.position)

		arg0_49.drag.localPosition = Vector3(var0_51.x, var0_51.y, 0) + var5_49
		arg0_49.tpl.localPosition = arg0_49:GetUI2Char(arg1_51.position)
	end)
	var4_49:AddDragEndFunc(function()
		setButtonEnabled(var3_49, true)
	end)

	var4_49.enabled = true
	Input.multiTouchEnabled = true
	arg0_49.arCamera.orthographicSize = 8
	arg0_49.arCamera.orthographic = true
	arg0_49.luHandle = LateUpdateBeat:CreateListener(function()
		if arg0_49.zoom.processing then
			local var0_53 = arg0_49.drag.localScale.x

			arg0_49.tpl.localScale = Vector3(var0_53, var0_53, var0_53)
		end
	end, arg0_49)

	LateUpdateBeat:AddListener(arg0_49.luHandle)
end

function var0_0.GetUI2Char(arg0_54, arg1_54)
	local var0_54 = arg0_54.widthRate * arg1_54.x - arg0_54.halfWidth
	local var1_54 = arg0_54.heightRate * arg1_54.y - arg0_54.halfHeight

	return Vector3(var0_54, var1_54, 2)
end

function var0_0.Screen2Local(arg0_55, arg1_55)
	local var0_55 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_55 = arg0_55:GetComponent("RectTransform")
	local var2_55 = LuaHelper.ScreenToLocal(var1_55, arg1_55, var0_55)

	return Vector3(var2_55.x, var2_55.y, 0)
end

return var0_0
