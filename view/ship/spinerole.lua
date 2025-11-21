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
			arg0_3._model.transform.localScale = Vector3.one
			arg0_3._modelScale = Vector3.one

			arg0_3._model.transform:SetParent(arg0_3._modelRoot.transform, false)

			arg0_3._model.transform.localPosition = Vector3.zero

			arg0_3:Init()

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
			arg0_5._model.transform.localScale = Vector3.one
			arg0_5._modelScale = Vector3.one
			arg0_5._model.transform.localPosition = Vector3.zero

			arg0_5:Init()

			if arg1_5 then
				arg1_5()
			end
		end
	end)
end

function var0_0.Init(arg0_7)
	arg0_7.state = var0_0.STATE_INITED
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
				p = arg3_9,
				hiddenActionList = arg6_9.orbit_hidden_action,
				index = arg5_9,
				back = arg6_9.orbit_ui_back
			}

			local var6_10 = var5_10:GetComponent("Spine.Unity.BoneFollowerGraphic")

			if arg6_9.orbit_rotate then
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

function var0_0.CheckInited(arg0_14)
	return arg0_14.state == var0_0.STATE_INITED
end

function var0_0.GetName(arg0_15)
	if arg0_15:CheckInited() then
		return arg0_15._modelRoot.name
	end
end

function var0_0.SetName(arg0_16, arg1_16)
	if arg0_16:CheckInited() then
		arg0_16._modelRoot.name = arg1_16
	end
end

function var0_0.GetRoleModel(arg0_17)
	if arg0_17:CheckInited() then
		return arg0_17._model
	end

	return nil
end

function var0_0.GetRootModel(arg0_18)
	if arg0_18:CheckInited() then
		return arg0_18._modelRoot
	end

	return nil
end

function var0_0.GetSpineAnimUI(arg0_19)
	if arg0_19:CheckInited() then
		return arg0_19._modleAnim
	end

	return nil
end

function var0_0.SetSiblingIndex(arg0_20, arg1_20)
	if arg0_20:CheckInited() then
		arg0_20._modelRoot.transform:SetSiblingIndex(arg1_20)
	end
end

function var0_0.SetParent(arg0_21, arg1_21, arg2_21)
	if arg0_21:CheckInited() then
		SetParent(tf(arg0_21._modelRoot), tf(arg1_21), arg2_21 and true or false)
	end
end

function var0_0.SetRaycastTarget(arg0_22, arg1_22)
	if arg0_22:CheckInited() then
		arg0_22._modleGraphic.raycastTarget = arg1_22
	end
end

function var0_0.GetSkeletonGraphic(arg0_23)
	if arg0_23:CheckInited() then
		return arg0_23._modleGraphic
	end
end

function var0_0.ModifyName(arg0_24, arg1_24)
	if arg0_24:CheckInited() then
		arg0_24._modelRoot.name = arg1_24
	end
end

function var0_0.SetVisible(arg0_25, arg1_25)
	if arg0_25:CheckInited() then
		arg0_25._visible = arg1_25
		arg0_25._modleGraphic.color = Color.New(1, 1, 1, arg1_25 and 1 or 0)

		for iter0_25, iter1_25 in pairs(arg0_25._attachmentList) do
			SetActive(iter0_25, arg1_25)
		end
	end
end

function var0_0.SetAnchoredPosition3D(arg0_26, arg1_26)
	if arg0_26:CheckInited() then
		arg0_26._modelRoot.transform.anchoredPosition3D = arg1_26
	end
end

function var0_0.SetAction(arg0_27, arg1_27)
	if not arg0_27:CheckInited() then
		return
	end

	local var0_27 = math.sign(arg0_27._modelRoot.transform.localScale.x)
	local var1_27, var2_27 = SpineAnimUtil.GetCharAnimationDirect(arg0_27._modleGraphic, var0_27, arg1_27)

	if var2_27 then
		arg0_27._model.transform.localScale = Vector3(var0_27, arg0_27._modelScale.y, arg0_27._modelScale.z)
	else
		arg0_27._model.transform.localScale = arg0_27._modelScale
	end

	print("root朝向 =" .. var0_27 .. "，model朝向 =" .. var0_27 .. "播放动作:" .. var1_27)
	arg0_27._modleAnim:SetAction(var1_27, 0)

	arg0_27._action = arg1_27

	arg0_27:HiddenAttachmentByAction(arg1_27)
end

function var0_0.SetActionOnce(arg0_28, arg1_28)
	if not arg0_28:CheckInited() then
		return
	end

	arg0_28._modleGraphic.AnimationState:SetAnimation(0, arg1_28, false)
	arg0_28:HiddenAttachmentByAction(arg1_28)
end

function var0_0.SetActionCallBack(arg0_29, arg1_29)
	if not arg0_29:CheckInited() then
		return
	end

	arg0_29._modleAnim:SetActionCallBack(arg1_29)
end

function var0_0.HiddenAttachmentByAction(arg0_30, arg1_30)
	for iter0_30, iter1_30 in pairs(arg0_30._attachmentList) do
		SetActive(iter0_30, not table.contains(iter1_30.hiddenActionList, arg1_30))
	end
end

function var0_0.SetSizeDelta(arg0_31, arg1_31)
	if arg0_31:CheckInited() then
		rtf(arg0_31._modelRoot).sizeDelta = arg1_31
	end
end

function var0_0.SetLocalScale(arg0_32, arg1_32)
	if arg0_32:CheckInited() then
		arg0_32._modelRoot.transform.localScale = arg1_32

		if arg0_32._action then
			arg0_32:SetAction(arg0_32._action)
		end
	end
end

function var0_0.GetLocalScale(arg0_33)
	if arg0_33:CheckInited() then
		return arg0_33._modelRoot.transform.localScale
	end
end

function var0_0.SetLocalPosition(arg0_34, arg1_34)
	if arg0_34:CheckInited() then
		arg0_34._modelRoot.transform.localPosition = arg1_34
	end
end

function var0_0.SetAsFirstSibling(arg0_35)
	if arg0_35:CheckInited() then
		arg0_35._modelRoot.transform:SetAsFirstSibling()
	end
end

function var0_0.SetLayer(arg0_36, arg1_36)
	if arg0_36:CheckInited() then
		pg.ViewUtils.SetLayer(arg0_36._modelRoot.transform, arg1_36)
	end
end

function var0_0.TweenShining(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37, arg6_37, arg7_37, arg8_37, arg9_37, arg10_37)
	if arg0_37:CheckInited() then
		arg0_37:StopTweenShining()

		local var0_37 = arg0_37._modleGraphic.material
		local var1_37 = LeanTween.value(arg0_37._modelRoot, arg3_37, arg4_37, arg1_37):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_38)
			if arg7_37 then
				var0_37:SetColor("_Color", Color.Lerp(arg5_37, arg6_37, arg0_38))
			else
				arg0_37._modleGraphic.color = Color.Lerp(arg5_37, arg6_37, arg0_38)
			end

			existCall(arg9_37, arg0_38)
		end)):setOnComplete(System.Action(function()
			arg0_37._tweenShiningId = nil

			if arg8_37 then
				if arg7_37 then
					var0_37:SetColor("_Color", arg5_37)
				else
					arg0_37._modleGraphic.color = arg5_37
				end
			end

			existCall(arg10_37)
		end))

		if arg2_37 then
			var1_37:setLoopPingPong(arg2_37)
		end

		arg0_37._tweenShiningId = var1_37.uniqueId
	end
end

function var0_0.StopTweenShining(arg0_40)
	if arg0_40:CheckInited() and arg0_40._tweenShiningId then
		LeanTween.cancel(arg0_40._tweenShiningId, true)

		arg0_40._tweenShiningId = nil
	end
end

function var0_0.ChangeMaterial(arg0_41, arg1_41)
	if not arg0_41:CheckInited() then
		return
	end

	if not arg0_41._stageMaterial then
		arg0_41._stageMaterial = arg0_41._modleGraphic.material
	end

	arg0_41._modleGraphic.material = arg1_41
end

function var0_0.RevertMaterial(arg0_42)
	if not arg0_42:CheckInited() then
		return
	end

	if not arg0_42._stageMaterial then
		return
	end

	arg0_42._modleGraphic.material = arg0_42._stageMaterial
end

function var0_0.CreateInterface(arg0_43)
	arg0_43._mouseChild = GameObject("mouseChild")

	arg0_43._mouseChild.transform:SetParent(arg0_43._modelRoot.transform, false)

	arg0_43._mouseChild.transform.localPosition = Vector3.zero
	arg0_43._modelClick = GetOrAddComponent(arg0_43._mouseChild, "ModelDrag")
	arg0_43._modelPress = GetOrAddComponent(arg0_43._mouseChild, "UILongPressTrigger")
	arg0_43._dragDelegate = GetOrAddComponent(arg0_43._mouseChild, "EventTriggerListener")

	arg0_43._modelClick:Init()

	local var0_43 = GetOrAddComponent(arg0_43._mouseChild, typeof(RectTransform))

	var0_43.pivot = Vector2(0.5, 0)
	var0_43.anchoredPosition = Vector2(0, 0)
	var0_43.localScale = Vector2(100, 100)
	var0_43.sizeDelta = Vector2(3, 3)

	return arg0_43._modelClick, arg0_43._modelPress, arg0_43._dragDelegate
end

function var0_0.resumeRole(arg0_44)
	if arg0_44._modleAnim and arg0_44._modleAnim:GetAnimationState() then
		arg0_44._modleAnim:Resume()
	end
end

function var0_0.GetInterface(arg0_45)
	return arg0_45._modelClick, arg0_45._modelPress, arg0_45._dragDelegate
end

function var0_0.EnableInterface(arg0_46)
	arg0_46._mouseChild:GetComponent(typeof(Image)).enabled = true
end

function var0_0.DisableInterface(arg0_47)
	arg0_47._mouseChild:GetComponent(typeof(Image)).enabled = false
end

function var0_0.Dispose(arg0_48)
	if arg0_48.state == var0_0.STATE_INITED then
		arg0_48:StopTweenShining()
		arg0_48:RevertMaterial()
		PoolMgr.GetInstance():ReturnSpineChar(arg0_48.prefabName, arg0_48._model)
		arg0_48:SetVisible(true)
		arg0_48._modleGraphic.material:SetColor("_Color", Color.New(0, 0, 0, 0))

		arg0_48._modleGraphic.color = Color.New(1, 1, 1, 1)

		for iter0_48, iter1_48 in pairs(arg0_48._attachmentList) do
			Object.Destroy(iter0_48.gameObject)
		end

		arg0_48._model = nil
		arg0_48.prefabName = nil
		arg0_48.ship = nil
		arg0_48.attachmentData = nil
		arg0_48._modleGraphic = nil
		arg0_48._modleAnim = nil
		arg0_48._attachmentList = nil
	end

	arg0_48.state = var0_0.STATE_DISPOSE
end

return var0_0
