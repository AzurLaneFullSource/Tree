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
		if arg0_9.state == var0_0.STATE_DISPOSE then
			-- block empty
		else
			local var0_10 = arg2_9 .. "_bound"
			local var1_10 = arg6_9[var0_10][1]
			local var2_10 = arg6_9[var0_10][2]
			local var3_10 = Object.Instantiate(arg0_10)
			local var4_10 = var3_10:GetComponentsInChildren(typeof(Spine.Unity.SkeletonGraphic)):ToTable()

			for iter0_10, iter1_10 in ipairs(var4_10) do
				iter1_10.raycastTarget = false
			end

			var3_10.transform.localPosition = Vector2(var2_10[1], var2_10[2])
			var3_10.transform.localScale = Vector3.one

			local var5_10 = SpineAnimUI.AddFollower(arg4_9, arg0_9._model.transform, var3_10.transform)

			arg0_9._attachmentList[var5_10] = {
				tf = var3_10.transform,
				p = arg3_9,
				hiddenActionList = arg6_9.orbit_hidden_action,
				index = arg5_9,
				back = arg6_9.orbit_ui_back
			}

			arg0_9:SetDefaultSortLayer(var3_10.transform)

			local var6_10 = var5_10:GetComponent("Spine.Unity.BoneFollowerGraphic")

			var6_10.followSkeletonFlip = false

			if arg6_9.orbit_rotate_ui ~= "" and arg6_9.orbit_rotate_ui == true then
				var6_10.followBoneRotation = true

				local var7_10 = var3_10.transform.localEulerAngles

				var3_10.transform.localEulerAngles = Vector3(var7_10.x, var7_10.y, var7_10.z - 90)
			else
				var6_10.followBoneRotation = false
			end

			if arg6_9.orbit_ui_back == 1 then
				var5_10:SetParent(arg0_9._modelRoot.transform, false)
				var5_10:SetAsFirstSibling()
			else
				var5_10:SetParent(arg0_9._modelRoot.transform, false)
				var5_10:SetAsLastSibling()
			end

			SetActive(var5_10, arg0_9._visible)
			arg0_9:sortAttachmentGO()
			arg0_9:UpdateEquipSkinSortLayer(var5_10.transform, arg0_9._attachmentList[var5_10])
		end
	end), true, true)
end

function var0_0.sortAttachmentGO(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11._attachmentList) do
		table.insert(var0_11, {
			tf = iter0_11,
			index = iter1_11.index,
			back = iter1_11.back,
			p = iter1_11.p
		})
	end

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12.index < arg1_12.index
	end)

	for iter2_11, iter3_11 in ipairs(var0_11) do
		if iter3_11.back ~= 1 then
			iter3_11.tf:SetAsLastSibling()

			break
		end
	end
end

function var0_0.GetAttachmentList(arg0_13)
	if arg0_13.ship then
		return arg0_13.ship:getAttachmentPrefab()
	else
		return arg0_13.attachmentData or {}
	end
end

function var0_0.SetSortLayer(arg0_14, arg1_14)
	arg0_14._setLayer = true

	local var0_14 = arg0_14._sortLayerCount

	arg0_14._sortLayerCount = arg1_14 or arg0_14._sortLayerCount

	if var0_14 ~= 0 then
		arg0_14:ResetSortLayer(var0_14)
	end

	arg0_14:ApplyModelSortLayer()

	for iter0_14, iter1_14 in pairs(arg0_14._attachmentList) do
		arg0_14:UpdateEquipSkinSortLayer(iter0_14.transform, iter1_14)
	end
end

function var0_0.ApplyModelSortLayer(arg0_15)
	if not arg0_15:CheckInited() then
		return
	end

	local var0_15 = GetOrAddComponent(arg0_15._model.transform, typeof(Canvas))

	var0_15.overrideSorting = true
	var0_15.sortingOrder = arg0_15._sortLayerCount

	pg.ViewUtils.SetLayer(arg0_15._model.transform, Layer.UI)
end

function var0_0.UpdateEquipSkinSortLayer(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16:GetComponentsInChildren(typeof(SkeletonGraphic), true):ToTable()

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var1_16 = GetOrAddComponent(iter1_16.gameObject, typeof(Canvas))

		var1_16.overrideSorting = true

		if var1_16.sortingOrder == 0 then
			var1_16.sortingOrder = arg2_16.back == 1 and -1 or 1
		end

		iter1_16.gameObject.layer = LayerMask.NameToLayer("UI")
	end

	print("set layer for " .. arg1_16.name .. " with sort order " .. arg0_16._sortLayerCount)
	WorldConst.ArrayEffectOrder(arg1_16, arg0_16._sortLayerCount)
end

function var0_0.ResetSortLayer(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17._attachmentList) do
		local var0_17 = {}
		local var1_17 = iter0_17.transform:GetComponentsInChildren(typeof(Renderer), true):ToTable()

		table.insertto(var0_17, var1_17)

		local var2_17 = iter0_17.transform:GetComponentsInChildren(typeof(Canvas), true):ToTable()

		table.insertto(var0_17, var2_17)

		for iter2_17, iter3_17 in ipairs(var0_17) do
			iter3_17.sortingOrder = arg0_17:GetDefaultSortLayer(iter1_17.tf.name, iter3_17.transform.name)
		end
	end
end

function var0_0.SetDefaultSortLayer(arg0_18, arg1_18)
	if not arg0_18._attachmentLayerDic then
		arg0_18._attachmentLayerDic = {}
	end

	local var0_18 = {}
	local var1_18 = arg1_18.transform:GetComponentsInChildren(typeof(Renderer), true):ToTable()

	table.insertto(var0_18, var1_18)

	local var2_18 = arg1_18.transform:GetComponentsInChildren(typeof(Canvas), true):ToTable()

	table.insertto(var0_18, var2_18)

	for iter0_18, iter1_18 in ipairs(var0_18) do
		arg0_18._attachmentLayerDic[arg1_18.transform.name .. "_" .. iter1_18.transform.name] = iter1_18.sortingOrder
	end
end

function var0_0.GetDefaultSortLayer(arg0_19, arg1_19, arg2_19)
	local var0_19 = 0

	if arg0_19._attachmentLayerDic and arg0_19._attachmentLayerDic[arg1_19 .. "_" .. arg2_19] then
		var0_19 = arg0_19._attachmentLayerDic[arg1_19 .. "_" .. arg2_19]
	end

	return var0_19
end

function var0_0.CheckInited(arg0_20)
	return arg0_20.state == var0_0.STATE_INITED
end

function var0_0.GetName(arg0_21)
	if arg0_21:CheckInited() then
		return arg0_21._modelRoot.name
	end
end

function var0_0.SetName(arg0_22, arg1_22)
	if arg0_22:CheckInited() then
		arg0_22._modelRoot.name = arg1_22
	end
end

function var0_0.GetRoleModel(arg0_23)
	if arg0_23:CheckInited() then
		return arg0_23._model
	end

	return nil
end

function var0_0.GetRootModel(arg0_24)
	if arg0_24:CheckInited() then
		return arg0_24._modelRoot
	end

	return nil
end

function var0_0.GetSpineAnimUI(arg0_25)
	if arg0_25:CheckInited() then
		return arg0_25._modleAnim
	end

	return nil
end

function var0_0.SetSiblingIndex(arg0_26, arg1_26)
	if arg0_26:CheckInited() then
		arg0_26._modelRoot.transform:SetSiblingIndex(arg1_26)
	end
end

function var0_0.SetParent(arg0_27, arg1_27, arg2_27)
	if arg0_27:CheckInited() then
		SetParent(tf(arg0_27._modelRoot), tf(arg1_27), arg2_27 and true or false)

		if arg0_27._setLayer then
			arg0_27:ApplyModelSortLayer()
		end
	end
end

function var0_0.SetRaycastTarget(arg0_28, arg1_28)
	if arg0_28:CheckInited() then
		arg0_28._modleGraphic.raycastTarget = arg1_28
	end
end

function var0_0.GetSkeletonGraphic(arg0_29)
	if arg0_29:CheckInited() then
		return arg0_29._modleGraphic
	end
end

function var0_0.ModifyName(arg0_30, arg1_30)
	if arg0_30:CheckInited() then
		arg0_30._modelRoot.name = arg1_30
	end
end

function var0_0.SetVisible(arg0_31, arg1_31)
	if arg0_31:CheckInited() then
		arg0_31._visible = arg1_31
		arg0_31._modleGraphic.color = Color.New(1, 1, 1, arg1_31 and 1 or 0)

		for iter0_31, iter1_31 in pairs(arg0_31._attachmentList) do
			SetActive(iter0_31, arg1_31)
		end
	end
end

function var0_0.SetAnchoredPosition3D(arg0_32, arg1_32)
	if arg0_32:CheckInited() then
		arg0_32._modelRoot.transform.anchoredPosition3D = arg1_32
	end
end

function var0_0.SetAction(arg0_33, arg1_33)
	if not arg0_33:CheckInited() then
		return
	end

	local var0_33 = math.sign(arg0_33._rootScale.x)
	local var1_33, var2_33 = SpineAnimUtil.GetCharAnimationDirect(arg0_33._modleGraphic, var0_33, arg1_33)

	if var2_33 then
		arg0_33._model.transform.localScale = Vector3(var0_33 * math.abs(arg0_33._modelScale.x), arg0_33._modelScale.y, arg0_33._modelScale.z)
	else
		arg0_33._model.transform.localScale = arg0_33._modelScale
	end

	arg0_33._modleAnim:SetAction(var1_33, 0)

	arg0_33._action = arg1_33

	arg0_33:HiddenAttachmentByAction(arg1_33)
end

function var0_0.SetActionOnce(arg0_34, arg1_34)
	if not arg0_34:CheckInited() then
		return
	end

	arg0_34._modleGraphic.AnimationState:SetAnimation(0, arg1_34, false)
	arg0_34:HiddenAttachmentByAction(arg1_34)
end

function var0_0.SetActionCallBack(arg0_35, arg1_35)
	if not arg0_35:CheckInited() then
		return
	end

	arg0_35._modleAnim:SetActionCallBack(function(arg0_36)
		arg0_35:changeAttachLListVisible(arg0_36)

		if arg1_35 then
			arg1_35(arg0_36)
		end
	end)
end

function var0_0.changeAttachLListVisible(arg0_37, arg1_37)
	local var0_37

	if arg1_37 == "skin_on" then
		var0_37 = true
	elseif arg1_37 == "skin_off" then
		var0_37 = false
	else
		return
	end

	for iter0_37, iter1_37 in pairs(arg0_37._attachmentList) do
		SetActive(iter0_37, var0_37)
	end
end

function var0_0.HiddenAttachmentByAction(arg0_38, arg1_38)
	for iter0_38, iter1_38 in pairs(arg0_38._attachmentList) do
		SetActive(iter0_38, not table.contains(iter1_38.hiddenActionList, arg1_38))
	end
end

function var0_0.SetSizeDelta(arg0_39, arg1_39)
	if arg0_39:CheckInited() then
		rtf(arg0_39._modelRoot).sizeDelta = arg1_39
	end
end

function var0_0.SetModelScale(arg0_40, arg1_40)
	if arg0_40:CheckInited() then
		arg0_40._model.transform.localScale = arg1_40
		arg0_40._modelScale = arg1_40
	end
end

function var0_0.SetLocalScale(arg0_41, arg1_41)
	if arg0_41:CheckInited() then
		arg0_41._rootScale = arg1_41
		arg0_41._modelRoot.transform.localScale = arg1_41

		if arg0_41._action then
			arg0_41:SetAction(arg0_41._action)
		end
	end
end

function var0_0.GetLocalScale(arg0_42)
	if arg0_42:CheckInited() then
		return arg0_42._modelRoot.transform.localScale
	end
end

function var0_0.SetLocalPosition(arg0_43, arg1_43)
	if arg0_43:CheckInited() then
		arg0_43._modelRoot.transform.localPosition = arg1_43
	end
end

function var0_0.SetAsFirstSibling(arg0_44)
	if arg0_44:CheckInited() then
		arg0_44._modelRoot.transform:SetAsFirstSibling()
	end
end

function var0_0.SetLayer(arg0_45, arg1_45)
	if arg0_45:CheckInited() then
		pg.ViewUtils.SetLayer(arg0_45._modelRoot.transform, arg1_45)
	end
end

function var0_0.TweenShining(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46, arg6_46, arg7_46, arg8_46, arg9_46, arg10_46)
	if arg0_46:CheckInited() then
		arg0_46:StopTweenShining()

		local var0_46 = arg0_46._modleGraphic.material
		local var1_46 = LeanTween.value(arg0_46._modelRoot, arg3_46, arg4_46, arg1_46):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_47)
			if arg7_46 then
				var0_46:SetColor("_Color", Color.Lerp(arg5_46, arg6_46, arg0_47))
			else
				arg0_46._modleGraphic.color = Color.Lerp(arg5_46, arg6_46, arg0_47)
			end

			existCall(arg9_46, arg0_47)
		end)):setOnComplete(System.Action(function()
			arg0_46._tweenShiningId = nil

			if arg8_46 then
				if arg7_46 then
					var0_46:SetColor("_Color", arg5_46)
				else
					arg0_46._modleGraphic.color = arg5_46
				end
			end

			existCall(arg10_46)
		end))

		if arg2_46 then
			var1_46:setLoopPingPong(arg2_46)
		end

		arg0_46._tweenShiningId = var1_46.uniqueId
	end
end

function var0_0.StopTweenShining(arg0_49)
	if arg0_49:CheckInited() and arg0_49._tweenShiningId then
		LeanTween.cancel(arg0_49._tweenShiningId, true)

		arg0_49._tweenShiningId = nil
	end
end

function var0_0.ChangeMaterial(arg0_50, arg1_50)
	if not arg0_50:CheckInited() then
		return
	end

	if not arg0_50._stageMaterial then
		arg0_50._stageMaterial = arg0_50._modleGraphic.material
	end

	arg0_50._modleGraphic.material = arg1_50
end

function var0_0.RevertMaterial(arg0_51)
	if not arg0_51:CheckInited() then
		return
	end

	if not arg0_51._stageMaterial then
		return
	end

	arg0_51._modleGraphic.material = arg0_51._stageMaterial
end

function var0_0.CreateInterface(arg0_52)
	arg0_52._mouseChild = GameObject("mouseChild")

	arg0_52._mouseChild.transform:SetParent(arg0_52._modelRoot.transform, false)

	arg0_52._mouseChild.transform.localPosition = Vector3.zero
	arg0_52._modelClick = GetOrAddComponent(arg0_52._mouseChild, "ModelDrag")
	arg0_52._modelPress = GetOrAddComponent(arg0_52._mouseChild, "UILongPressTrigger")
	arg0_52._dragDelegate = GetOrAddComponent(arg0_52._mouseChild, "EventTriggerListener")

	arg0_52._modelClick:Init()

	local var0_52 = GetOrAddComponent(arg0_52._mouseChild, typeof(RectTransform))

	var0_52.pivot = Vector2(0.5, 0)
	var0_52.anchoredPosition = Vector2(0, 0)
	var0_52.localScale = Vector2(100, 100)
	var0_52.sizeDelta = Vector2(3, 3)

	return arg0_52._modelClick, arg0_52._modelPress, arg0_52._dragDelegate
end

function var0_0.resumeRole(arg0_53)
	if arg0_53._modleAnim and arg0_53._modleAnim:GetAnimationState() then
		arg0_53._modleAnim:Resume()
	end
end

function var0_0.GetInterface(arg0_54)
	return arg0_54._modelClick, arg0_54._modelPress, arg0_54._dragDelegate
end

function var0_0.EnableInterface(arg0_55)
	arg0_55._mouseChild:GetComponent(typeof(Image)).enabled = true
end

function var0_0.DisableInterface(arg0_56)
	arg0_56._mouseChild:GetComponent(typeof(Image)).enabled = false
end

function var0_0.Dispose(arg0_57)
	if arg0_57.state == var0_0.STATE_INITED then
		if arg0_57._setLayer then
			RemoveComponent(arg0_57._model.transform, "Canvas")

			arg0_57._setLayer = nil
		end

		arg0_57._modleAnim:SetActionCallBack(nil)
		arg0_57:StopTweenShining()
		arg0_57:RevertMaterial()
		PoolMgr.GetInstance():ReturnSpineChar(arg0_57.prefabName, arg0_57._model)
		arg0_57:SetVisible(true)
		arg0_57._modleGraphic.material:SetColor("_Color", Color.New(0, 0, 0, 0))

		arg0_57._modleGraphic.color = Color.New(1, 1, 1, 1)

		for iter0_57, iter1_57 in pairs(arg0_57._attachmentList) do
			Object.Destroy(iter0_57.gameObject)
		end

		arg0_57._model = nil
		arg0_57.prefabName = nil
		arg0_57.ship = nil
		arg0_57.attachmentData = nil
		arg0_57._modleGraphic = nil
		arg0_57._modleAnim = nil
		arg0_57._attachmentList = nil
		arg0_57._sortLayerCount = 0
	end

	arg0_57.state = var0_0.STATE_DISPOSE
end

return var0_0
