local var0_0 = class("SpineRole")

var0_0.STATE_EMPTY = 0
var0_0.STATE_LOADING = 1
var0_0.STATE_INITED = 2
var0_0.STATE_DISPOSE = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.state = var0_0.STATE_EMPTY

	if arg1_1 then
		arg0_1.ship = arg1_1
		arg0_1.prefabName = arg0_1.ship:getPrefab(arg2_1)
	end
end

function var0_0.SetData(arg0_2, arg1_2, arg2_2)
	arg0_2.prefabName = arg1_2
	arg0_2.attachmentData = arg2_2
end

var0_0.ORBIT_KEY_UI = "orbit_ui"
var0_0.ORBIT_KEY_SLG = "orbit_slg"

function var0_0.Load(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg2_3 == nil then
		arg2_3 = true
	end

	PoolMgr.GetInstance():GetSpineChar(arg0_3.prefabName, arg2_3, function(arg0_4)
		assert(arg0_4, "没有这个角色的模型  " .. arg0_3.prefabName)

		if arg0_3.state == var0_0.STATE_DISPOSE then
			PoolMgr.GetInstance():ReturnSpineChar(arg0_3.prefabName, arg0_4)
		else
			arg0_3._modelRoot = GameObject.New(arg0_3.prefabName .. "_root")

			arg0_3._modelRoot:AddComponent(typeof(RectTransform))

			arg0_3._model = arg0_4

			arg0_3:Init()
			arg0_3:SetLocalScale(Vector3.one)
			arg0_3:SetModelScale(Vector3.one)
			arg0_3._model.transform:SetParent(arg0_3._modelRoot.transform, false)

			arg0_3._model.transform.localPosition = Vector3.zero

			setActive(arg0_3._model.transform, true)

			if arg1_3 then
				arg1_3()
			end

			arg0_3:AttachOrbit(arg3_3)
			arg0_3:sortAttachmentGO()
		end
	end)
end

function var0_0.LoadLite(arg0_5, arg1_5, arg2_5)
	if arg2_5 == nil then
		arg2_5 = true
	end

	PoolMgr.GetInstance():GetSpineChar(arg0_5.prefabName, arg2_5, function(arg0_6)
		assert(arg0_6, "没有这个角色的模型  " .. arg0_5.prefabName)

		if arg0_5.state == var0_0.STATE_DISPOSE then
			PoolMgr.GetInstance():ReturnSpineChar(arg0_5.prefabName, arg0_6)
		else
			arg0_5._modelRoot = arg0_6
			arg0_5._model = arg0_6

			arg0_5:Init()
			arg0_5:SetLocalScale(Vector3.one)
			arg0_5:SetModelScale(Vector3.one)

			arg0_5._model.transform.localPosition = Vector3.zero

			if arg1_5 then
				arg1_5()
			end
		end
	end)
end

function var0_0.Init(arg0_7)
	arg0_7.state = var0_0.STATE_INITED
	arg0_7._sortLayerCount = 0
	arg0_7._modleGraphic = arg0_7._model:GetComponent("SkeletonGraphic")
	arg0_7._modleAnim = arg0_7._model:GetComponent("SpineAnimUI")
	arg0_7._attachmentList = {}
	arg0_7._visible = true
	arg0_7._orbitVisible = true
end

function var0_0.AttachOrbit(arg0_8, arg1_8)
	local var0_8 = arg1_8 or var0_0.ORBIT_KEY_UI
	local var1_8 = arg0_8:GetAttachmentList()

	for iter0_8, iter1_8 in pairs(var1_8) do
		local var2_8 = iter1_8.config
		local var3_8 = iter1_8.index
		local var4_8 = var2_8[var0_8]

		if var0_8 ~= var0_0.ORBIT_KEY_UI and var4_8 == "" then
			var4_8 = var2_8.orbit_ui
			var0_8 = var0_0.ORBIT_KEY_UI
		end

		if var4_8 ~= "" then
			local var5_8 = var2_8.orbit_ui_bound[1]
			local var6_8 = arg0_8.ship and arg0_8.ship:IsDoubleSkin() and true or false
			local var7_8 = arg0_8._modleGraphic.Skeleton:FindBoneIndex("char1_" .. var5_8)
			local var8_8 = arg0_8._modleGraphic.Skeleton:FindBoneIndex("char2_" .. var5_8)
			local var9_8 = var2_8.double_char_bone
			local var10_8 = ys.Battle.BattleResourceManager.GetOrbitPath(var4_8)

			if var6_8 and (var7_8 >= 0 or var8_8 > 0) or var7_8 >= 0 and var8_8 > 0 then
				if var8_8 >= 0 and var9_8 and #var9_8 > 0 and var9_8[1] == 1 then
					arg0_8:loadOrbitUI(var10_8, var0_8, var4_8, "char2" .. "_" .. var5_8, var3_8, var2_8)
				end

				if var9_8 and #var9_8 > 0 and var9_8[2] == 1 then
					arg0_8:loadOrbitUI(var10_8, var0_8, var4_8, var5_8, var3_8, var2_8)
				end

				if var7_8 >= 0 and var9_8 and #var9_8 > 0 and var9_8[3] == 1 then
					arg0_8:loadOrbitUI(var10_8, var0_8, var4_8, "char1" .. "_" .. var5_8, var3_8, var2_8)
				end
			else
				arg0_8:loadOrbitUI(var10_8, var0_8, var4_8, var5_8, var3_8, var2_8)
			end
		end
	end
end

function var0_0.loadOrbitUI(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
	ResourceMgr.Inst:getAssetAsync(arg1_9, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_10)
		local var0_10 = tf(arg0_10).childCount

		if var0_10 > 1 then
			for iter0_10 = 1, var0_10 do
				arg0_9:CreateOrbitUI(iter0_10, arg0_10, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
			end
		else
			arg0_9:CreateOrbitUI(0, arg0_10, arg2_9, arg3_9, arg4_9, arg5_9, arg6_9)
		end
	end), true, true)
end

function var0_0.CreateOrbitUI(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11, arg7_11)
	if arg0_11.state == var0_0.STATE_DISPOSE then
		return
	end

	local var0_11 = arg3_11 .. "_bound"
	local var1_11 = arg7_11[var0_11][1]
	local var2_11 = arg7_11[var0_11][2]
	local var3_11 = Object.Instantiate(arg2_11)
	local var4_11 = 0

	if arg1_11 ~= 0 then
		for iter0_11 = var3_11.transform.childCount, 1, -1 do
			local var5_11 = var3_11.transform:GetChild(iter0_11 - 1)

			if iter0_11 ~= arg1_11 then
				Destroy(var5_11.gameObject)
			else
				local var6_11 = var5_11:GetComponent(typeof(Canvas))

				if var6_11 then
					var4_11 = var6_11.sortingOrder

					RemoveComponent(var5_11.transform, "Canvas")
				end
			end
		end
	else
		local var7_11 = var3_11.transform:GetChild(0)

		if var7_11:GetComponent(typeof(Canvas)) then
			RemoveComponent(var7_11.transform, "Canvas")
		end
	end

	local var8_11 = var3_11:GetComponentsInChildren(typeof(Spine.Unity.SkeletonGraphic)):ToTable()

	for iter1_11, iter2_11 in ipairs(var8_11) do
		iter2_11.raycastTarget = false
	end

	var3_11.transform.localPosition = Vector2(var2_11[1], var2_11[2])
	var3_11.transform.localScale = Vector3.one

	local var9_11 = SpineAnimUI.AddFollower(arg5_11, arg0_11._model.transform, var3_11.transform)

	arg0_11._attachmentList[var9_11] = {
		tf = var3_11.transform,
		p = arg4_11,
		hiddenActionList = arg7_11.orbit_hidden_action,
		index = arg6_11,
		back = arg7_11.orbit_ui_back,
		sortOrder = var4_11
	}

	local var10_11 = var9_11:GetComponent("Spine.Unity.BoneFollowerGraphic")

	var10_11.followSkeletonFlip = false

	if arg7_11.orbit_rotate_ui ~= "" and arg7_11.orbit_rotate_ui == true then
		var10_11.followBoneRotation = true

		local var11_11 = var3_11.transform.localEulerAngles

		var3_11.transform.localEulerAngles = Vector3(var11_11.x, var11_11.y, var11_11.z - 90)
	else
		var10_11.followBoneRotation = false
	end

	if var4_11 and var4_11 < 0 then
		var9_11:SetParent(arg0_11._modelRoot.transform, false)
		var9_11:SetAsFirstSibling()
	elseif var4_11 and var4_11 > 0 then
		var9_11:SetParent(arg0_11._modelRoot.transform, false)
		var9_11:SetAsLastSibling()
	elseif arg7_11.orbit_ui_back == 1 then
		var9_11:SetParent(arg0_11._modelRoot.transform, false)
		var9_11:SetAsFirstSibling()
	else
		var9_11:SetParent(arg0_11._modelRoot.transform, false)
		var9_11:SetAsLastSibling()
	end

	SetActive(var9_11, false)
	onNextTick(function()
		SetActive(var9_11, arg0_11._visible)
	end)
	arg0_11:sortAttachmentGO()
end

function var0_0.sortAttachmentGO(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13._attachmentList) do
		table.insert(var0_13, {
			tf = iter0_13,
			index = iter1_13.index,
			back = iter1_13.back,
			p = iter1_13.p,
			sortOrder = iter1_13.sortOrder
		})
	end

	table.sort(var0_13, function(arg0_14, arg1_14)
		return arg0_14.index < arg1_14.index
	end)

	for iter2_13, iter3_13 in ipairs(var0_13) do
		if iter3_13.back ~= 1 and iter3_13.sortOrder == 0 then
			iter3_13.tf:SetAsLastSibling()

			break
		elseif iter3_13.back == 1 and iter3_13.sortOrder == 0 then
			iter3_13.tf:SetAsFirstSibling()
		end
	end
end

function var0_0.GetAttachmentList(arg0_15)
	if arg0_15.ship then
		return arg0_15.ship:getAttachmentPrefab()
	else
		return arg0_15.attachmentData or {}
	end
end

function var0_0.CheckInited(arg0_16)
	return arg0_16.state == var0_0.STATE_INITED
end

function var0_0.GetName(arg0_17)
	if arg0_17:CheckInited() then
		return arg0_17._modelRoot.name
	end
end

function var0_0.SetName(arg0_18, arg1_18)
	if arg0_18:CheckInited() then
		arg0_18._modelRoot.name = arg1_18
	end
end

function var0_0.GetRoleModel(arg0_19)
	if arg0_19:CheckInited() then
		return arg0_19._model
	end

	return nil
end

function var0_0.GetRootModel(arg0_20)
	if arg0_20:CheckInited() then
		return arg0_20._modelRoot
	end

	return nil
end

function var0_0.GetSpineAnimUI(arg0_21)
	if arg0_21:CheckInited() then
		return arg0_21._modleAnim
	end

	return nil
end

function var0_0.SetSiblingIndex(arg0_22, arg1_22)
	if arg0_22:CheckInited() then
		arg0_22._modelRoot.transform:SetSiblingIndex(arg1_22)
	end
end

function var0_0.SetParent(arg0_23, arg1_23, arg2_23)
	if arg0_23:CheckInited() then
		SetParent(tf(arg0_23._modelRoot), tf(arg1_23), arg2_23 and true or false)
	end
end

function var0_0.SetRaycastTarget(arg0_24, arg1_24)
	if arg0_24:CheckInited() then
		arg0_24._modleGraphic.raycastTarget = arg1_24
	end
end

function var0_0.GetSkeletonGraphic(arg0_25)
	if arg0_25:CheckInited() then
		return arg0_25._modleGraphic
	end
end

function var0_0.ModifyName(arg0_26, arg1_26)
	if arg0_26:CheckInited() then
		arg0_26._modelRoot.name = arg1_26
	end
end

function var0_0.SetOrbitVisible(arg0_27, arg1_27)
	if arg0_27:CheckInited() then
		arg0_27._orbitVisible = arg1_27

		for iter0_27, iter1_27 in pairs(arg0_27._attachmentList) do
			SetActive(iter0_27, arg1_27)
		end
	end
end

function var0_0.SetVisible(arg0_28, arg1_28)
	if arg0_28:CheckInited() then
		arg0_28._visible = arg1_28
		arg0_28._orbitVisible = arg1_28
		arg0_28._modleGraphic.color = Color.New(1, 1, 1, arg1_28 and 1 or 0)

		for iter0_28, iter1_28 in pairs(arg0_28._attachmentList) do
			SetActive(iter0_28, arg1_28)
		end
	end
end

function var0_0.SetAnchoredPosition3D(arg0_29, arg1_29)
	if arg0_29:CheckInited() then
		arg0_29._modelRoot.transform.anchoredPosition3D = arg1_29
	end
end

function var0_0.SetAction(arg0_30, arg1_30)
	if not arg0_30:CheckInited() then
		return
	end

	local var0_30 = math.sign(arg0_30._rootScale.x)
	local var1_30, var2_30 = SpineAnimUtil.GetCharAnimationDirect(arg0_30._modleGraphic, var0_30, arg1_30)

	if var2_30 then
		arg0_30._model.transform.localScale = Vector3(var0_30 * math.abs(arg0_30._modelScale.x), arg0_30._modelScale.y, arg0_30._modelScale.z)
	else
		arg0_30._model.transform.localScale = arg0_30._modelScale
	end

	arg0_30._modleAnim:SetAction(var1_30, 0)

	arg0_30._action = arg1_30

	arg0_30:HiddenAttachmentByAction(arg1_30)
end

function var0_0.SetActionOnce(arg0_31, arg1_31)
	if not arg0_31:CheckInited() then
		return
	end

	arg0_31._modleGraphic.AnimationState:SetAnimation(0, arg1_31, false)
	arg0_31:HiddenAttachmentByAction(arg1_31)
end

function var0_0.SetActionCallBack(arg0_32, arg1_32)
	if not arg0_32:CheckInited() then
		return
	end

	arg0_32._modleAnim:SetActionCallBack(function(arg0_33)
		arg0_32:changeAttachLListVisible(arg0_33)

		if arg1_32 then
			arg1_32(arg0_33)
		end
	end)
end

function var0_0.changeAttachLListVisible(arg0_34, arg1_34)
	local var0_34

	if arg1_34 == "skin_on" then
		var0_34 = true
	elseif arg1_34 == "skin_off" then
		var0_34 = false
	else
		return
	end

	for iter0_34, iter1_34 in pairs(arg0_34._attachmentList) do
		SetActive(iter0_34, var0_34)
	end
end

function var0_0.HiddenAttachmentByAction(arg0_35, arg1_35)
	for iter0_35, iter1_35 in pairs(arg0_35._attachmentList) do
		SetActive(iter0_35, not table.contains(iter1_35.hiddenActionList, arg1_35) and arg0_35._orbitVisible)
	end
end

function var0_0.SetSizeDelta(arg0_36, arg1_36)
	if arg0_36:CheckInited() then
		rtf(arg0_36._modelRoot).sizeDelta = arg1_36
	end
end

function var0_0.SetModelScale(arg0_37, arg1_37)
	if arg0_37:CheckInited() then
		arg0_37._model.transform.localScale = arg1_37
		arg0_37._modelScale = arg1_37
	end
end

function var0_0.SetLocalScale(arg0_38, arg1_38)
	if arg0_38:CheckInited() then
		arg0_38._rootScale = arg1_38
		arg0_38._modelRoot.transform.localScale = arg1_38

		if arg0_38._action then
			arg0_38:SetAction(arg0_38._action)
		end
	end
end

function var0_0.GetLocalScale(arg0_39)
	if arg0_39:CheckInited() then
		return arg0_39._modelRoot.transform.localScale
	end
end

function var0_0.SetLocalPosition(arg0_40, arg1_40)
	if arg0_40:CheckInited() then
		arg0_40._modelRoot.transform.localPosition = arg1_40
	end
end

function var0_0.SetAsFirstSibling(arg0_41)
	if arg0_41:CheckInited() then
		arg0_41._modelRoot.transform:SetAsFirstSibling()
	end
end

function var0_0.SetLayer(arg0_42, arg1_42)
	if arg0_42:CheckInited() then
		pg.ViewUtils.SetLayer(arg0_42._modelRoot.transform, arg1_42)
	end
end

function var0_0.TweenShining(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43, arg6_43, arg7_43, arg8_43, arg9_43, arg10_43)
	if arg0_43:CheckInited() then
		arg0_43:StopTweenShining()

		local var0_43 = arg0_43._modleGraphic.material
		local var1_43 = LeanTween.value(arg0_43._modelRoot, arg3_43, arg4_43, arg1_43):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_44)
			if arg7_43 then
				var0_43:SetColor("_Color", Color.Lerp(arg5_43, arg6_43, arg0_44))
			else
				arg0_43._modleGraphic.color = Color.Lerp(arg5_43, arg6_43, arg0_44)
			end

			existCall(arg9_43, arg0_44)
		end)):setOnComplete(System.Action(function()
			arg0_43._tweenShiningId = nil

			if arg8_43 then
				if arg7_43 then
					var0_43:SetColor("_Color", arg5_43)
				else
					arg0_43._modleGraphic.color = arg5_43
				end
			end

			existCall(arg10_43)
		end))

		if arg2_43 then
			var1_43:setLoopPingPong(arg2_43)
		end

		arg0_43._tweenShiningId = var1_43.uniqueId
	end
end

function var0_0.StopTweenShining(arg0_46)
	if arg0_46:CheckInited() and arg0_46._tweenShiningId then
		LeanTween.cancel(arg0_46._tweenShiningId, true)

		arg0_46._tweenShiningId = nil
	end
end

function var0_0.ChangeMaterial(arg0_47, arg1_47)
	if not arg0_47:CheckInited() then
		return
	end

	if not arg0_47._stageMaterial then
		arg0_47._stageMaterial = arg0_47._modleGraphic.material
	end

	arg0_47._modleGraphic.material = arg1_47
end

function var0_0.RevertMaterial(arg0_48)
	if not arg0_48:CheckInited() then
		return
	end

	if not arg0_48._stageMaterial then
		return
	end

	arg0_48._modleGraphic.material = arg0_48._stageMaterial
end

function var0_0.CreateInterface(arg0_49)
	arg0_49._mouseChild = GameObject("mouseChild")

	arg0_49._mouseChild.transform:SetParent(arg0_49._modelRoot.transform, false)

	arg0_49._mouseChild.transform.localPosition = Vector3.zero
	arg0_49._modelClick = GetOrAddComponent(arg0_49._mouseChild, "ModelDrag")
	arg0_49._modelPress = GetOrAddComponent(arg0_49._mouseChild, "UILongPressTrigger")
	arg0_49._dragDelegate = GetOrAddComponent(arg0_49._mouseChild, "EventTriggerListener")

	arg0_49._modelClick:Init()

	local var0_49 = GetOrAddComponent(arg0_49._mouseChild, typeof(RectTransform))

	var0_49.pivot = Vector2(0.5, 0)
	var0_49.anchoredPosition = Vector2(0, 0)
	var0_49.localScale = Vector2(100, 100)
	var0_49.sizeDelta = Vector2(3, 3)

	return arg0_49._modelClick, arg0_49._modelPress, arg0_49._dragDelegate
end

function var0_0.resumeRole(arg0_50)
	if arg0_50._modleAnim and arg0_50._modleAnim:GetAnimationState() then
		arg0_50._modleAnim:Resume()
	end
end

function var0_0.GetInterface(arg0_51)
	return arg0_51._modelClick, arg0_51._modelPress, arg0_51._dragDelegate
end

function var0_0.EnableInterface(arg0_52)
	arg0_52._mouseChild:GetComponent(typeof(Image)).enabled = true
end

function var0_0.DisableInterface(arg0_53)
	arg0_53._mouseChild:GetComponent(typeof(Image)).enabled = false
end

function var0_0.Dispose(arg0_54)
	if arg0_54.state == var0_0.STATE_INITED then
		arg0_54._modleAnim:SetActionCallBack(nil)
		arg0_54:StopTweenShining()
		arg0_54:RevertMaterial()
		PoolMgr.GetInstance():ReturnSpineChar(arg0_54.prefabName, arg0_54._model)
		arg0_54:SetVisible(true)
		arg0_54._modleGraphic.material:SetColor("_Color", Color.New(0, 0, 0, 0))

		arg0_54._modleGraphic.color = Color.New(1, 1, 1, 1)

		for iter0_54, iter1_54 in pairs(arg0_54._attachmentList) do
			Object.Destroy(iter0_54.gameObject)
		end

		arg0_54._model = nil
		arg0_54.prefabName = nil
		arg0_54.ship = nil
		arg0_54.attachmentData = nil
		arg0_54._modleGraphic = nil
		arg0_54._modleAnim = nil
		arg0_54._attachmentList = nil
		arg0_54._sortLayerCount = 0
	end

	arg0_54.state = var0_0.STATE_DISPOSE
end

return var0_0
