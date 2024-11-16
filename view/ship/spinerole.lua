local var0_0 = class("SpineRole")

var0_0.STATE_EMPTY = 0
var0_0.STATE_LOADING = 1
var0_0.STATE_INITED = 2
var0_0.STATE_DISPOSE = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.state = var0_0.STATE_EMPTY

	if arg1_1 then
		arg0_1.ship = arg1_1
		arg0_1.prefabName = arg0_1.ship:getPrefab()
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
			arg0_3.modelRoot = GameObject.New(arg0_3.prefabName .. "_root")

			arg0_3.modelRoot:AddComponent(typeof(RectTransform))

			arg0_3.model = arg0_4
			arg0_3.model.transform.localScale = Vector3.one

			arg0_3.model.transform:SetParent(arg0_3.modelRoot.transform, false)

			arg0_3.model.transform.localPosition = Vector3.zero

			arg0_3:Init()

			if arg1_3 then
				arg1_3()
			end

			arg0_3:AttachOrbit(arg3_3)
		end
	end)
end

function var0_0.Init(arg0_5)
	arg0_5.state = var0_0.STATE_INITED
	arg0_5._modleGraphic = arg0_5.model:GetComponent("SkeletonGraphic")
	arg0_5._modleAnim = arg0_5.model:GetComponent("SpineAnimUI")
	arg0_5._attachmentList = {}
	arg0_5._visible = true
end

function var0_0.AttachOrbit(arg0_6, arg1_6)
	local var0_6 = arg1_6 or var0_0.ORBIT_KEY_UI
	local var1_6 = arg0_6:GetAttachmentList()

	for iter0_6, iter1_6 in pairs(var1_6) do
		local var2_6 = iter1_6[var0_6]

		if var0_6 ~= var0_0.ORBIT_KEY_UI and var2_6 == "" then
			var2_6 = iter1_6.orbit_ui
			var0_6 = var0_0.ORBIT_KEY_UI
		end

		if var2_6 ~= "" then
			local var3_6 = ys.Battle.BattleResourceManager.GetOrbitPath(var2_6)

			ResourceMgr.Inst:getAssetAsync(var3_6, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
				if arg0_6.state == var0_0.STATE_DISPOSE then
					-- block empty
				else
					local var0_7 = var0_6 .. "_bound"
					local var1_7 = iter1_6[var0_7][1]
					local var2_7 = iter1_6[var0_7][2]
					local var3_7 = Object.Instantiate(arg0_7)
					local var4_7 = var3_7:GetComponentsInChildren(typeof(Spine.Unity.SkeletonGraphic))

					for iter0_7 = 1, var4_7.Length do
						var4_7[iter0_7 - 1].raycastTarget = false
					end

					var3_7.transform.localPosition = Vector2(var2_7[1], var2_7[2])

					local var5_7 = SpineAnimUI.AddFollower(var1_7, arg0_6.model.transform, var3_7.transform)

					var3_7.transform.localScale = Vector3.one
					arg0_6._attachmentList[var5_7] = iter1_6.orbit_hidden_action

					local var6_7 = var5_7:GetComponent("Spine.Unity.BoneFollowerGraphic")

					if iter1_6.orbit_rotate then
						var6_7.followBoneRotation = true

						local var7_7 = var3_7.transform.localEulerAngles

						var3_7.transform.localEulerAngles = Vector3(var7_7.x, var7_7.y, var7_7.z - 90)
					else
						var6_7.followBoneRotation = false
					end

					if iter1_6.orbit_ui_back == 1 then
						var5_7:SetParent(arg0_6.modelRoot.transform, false)
						var5_7:SetAsFirstSibling()
					else
						var5_7:SetParent(arg0_6.modelRoot.transform, false)
						var5_7:SetAsLastSibling()
					end

					SetActive(var3_7, arg0_6._visible)
				end
			end), true, true)
		end
	end
end

function var0_0.GetAttachmentList(arg0_8)
	if arg0_8.ship then
		return arg0_8.ship:getAttachmentPrefab()
	else
		return arg0_8.attachmentData or {}
	end
end

function var0_0.CheckInited(arg0_9)
	return arg0_9.state == var0_0.STATE_INITED
end

function var0_0.GetName(arg0_10)
	return arg0_10.modelRoot.name
end

function var0_0.SetParent(arg0_11, arg1_11)
	if arg0_11:CheckInited() then
		SetParent(arg0_11.modelRoot, arg1_11, false)
	end
end

function var0_0.SetRaycastTarget(arg0_12, arg1_12)
	if arg0_12:CheckInited() then
		arg0_12._modleGraphic.raycastTarget = arg1_12
	end
end

function var0_0.ModifyName(arg0_13, arg1_13)
	if arg0_13:CheckInited() then
		arg0_13.modelRoot.name = arg1_13
	end
end

function var0_0.SetVisible(arg0_14, arg1_14)
	if arg0_14:CheckInited() then
		arg0_14._visible = arg1_14
		arg0_14._modleGraphic.color = Color.New(1, 1, 1, arg1_14 and 1 or 0)

		for iter0_14, iter1_14 in pairs(arg0_14._attachmentList) do
			SetActive(iter0_14, arg1_14)
		end
	end
end

function var0_0.SetAction(arg0_15, arg1_15)
	if not arg0_15:CheckInited() then
		return
	end

	arg0_15._modleAnim:SetAction(arg1_15, 0)
	arg0_15:HiddenAttachmentByAction(arg1_15)
end

function var0_0.SetActionOnce(arg0_16, arg1_16)
	if not arg0_16:CheckInited() then
		return
	end

	arg0_16._modleGraphic.AnimationState:SetAnimation(0, arg1_16, false)
	arg0_16:HiddenAttachmentByAction(arg1_16)
end

function var0_0.SetActionCallBack(arg0_17, arg1_17)
	if not arg0_17:CheckInited() then
		return
	end

	arg0_17._modleAnim:SetActionCallBack(arg1_17)
end

function var0_0.HiddenAttachmentByAction(arg0_18, arg1_18)
	for iter0_18, iter1_18 in pairs(arg0_18._attachmentList) do
		SetActive(iter0_18, not table.contains(iter1_18, arg1_18))
	end
end

function var0_0.SetSizeDelta(arg0_19, arg1_19)
	if arg0_19:CheckInited() then
		rtf(arg0_19.modelRoot).sizeDelta = arg1_19
	end
end

function var0_0.SetLocalScale(arg0_20, arg1_20)
	if arg0_20:CheckInited() then
		arg0_20.modelRoot.transform.localScale = arg1_20
	end
end

function var0_0.SetLocalPos(arg0_21, arg1_21)
	if arg0_21:CheckInited() then
		arg0_21.modelRoot.transform.localPosition = arg1_21
	end
end

function var0_0.SetLayer(arg0_22, arg1_22)
	if arg0_22:CheckInited() then
		pg.ViewUtils.SetLayer(arg0_22.modelRoot.transform, arg1_22)
	end
end

function var0_0.TweenShining(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23, arg5_23, arg6_23, arg7_23, arg8_23, arg9_23, arg10_23)
	if arg0_23:CheckInited() then
		arg0_23:StopTweenShining()

		local var0_23 = arg0_23._modleGraphic.material
		local var1_23 = LeanTween.value(arg0_23.modelRoot, arg3_23, arg4_23, arg1_23):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_24)
			if arg7_23 then
				var0_23:SetColor("_Color", Color.Lerp(arg5_23, arg6_23, arg0_24))
			else
				arg0_23._modleGraphic.color = Color.Lerp(arg5_23, arg6_23, arg0_24)
			end

			existCall(arg9_23, arg0_24)
		end)):setOnComplete(System.Action(function()
			arg0_23._tweenShiningId = nil

			if arg8_23 then
				if arg7_23 then
					var0_23:SetColor("_Color", arg5_23)
				else
					arg0_23._modleGraphic.color = arg5_23
				end
			end

			existCall(arg10_23)
		end))

		if arg2_23 then
			var1_23:setLoopPingPong(arg2_23)
		end

		arg0_23._tweenShiningId = var1_23.uniqueId
	end
end

function var0_0.StopTweenShining(arg0_26)
	if arg0_26:CheckInited() and arg0_26._tweenShiningId then
		LeanTween.cancel(arg0_26._tweenShiningId, true)

		arg0_26._tweenShiningId = nil
	end
end

function var0_0.ChangeMaterial(arg0_27, arg1_27)
	if not arg0_27:CheckInited() then
		return
	end

	if not arg0_27._stageMaterial then
		arg0_27._stageMaterial = arg0_27._modleGraphic.material
	end

	arg0_27._modleGraphic.material = arg1_27
end

function var0_0.RevertMaterial(arg0_28)
	if not arg0_28:CheckInited() then
		return
	end

	if not arg0_28._stageMaterial then
		return
	end

	arg0_28._modleGraphic.material = arg0_28._stageMaterial
end

function var0_0.CreateInterface(arg0_29)
	arg0_29._mouseChild = GameObject("mouseChild")

	arg0_29._mouseChild.transform:SetParent(arg0_29.modelRoot.transform, false)

	arg0_29._mouseChild.transform.localPosition = Vector3.zero
	arg0_29._modelClick = GetOrAddComponent(arg0_29._mouseChild, "ModelDrag")
	arg0_29._modelPress = GetOrAddComponent(arg0_29._mouseChild, "UILongPressTrigger")
	arg0_29._dragDelegate = GetOrAddComponent(arg0_29._mouseChild, "EventTriggerListener")

	arg0_29._modelClick:Init()

	local var0_29 = GetOrAddComponent(arg0_29._mouseChild, typeof(RectTransform))

	var0_29.pivot = Vector2(0.5, 0)
	var0_29.anchoredPosition = Vector2(0, 0)
	var0_29.localScale = Vector2(100, 100)
	var0_29.sizeDelta = Vector2(3, 3)

	return arg0_29._modelClick, arg0_29._modelPress, arg0_29._dragDelegate
end

function var0_0.resumeRole(arg0_30)
	if arg0_30._modleAnim and arg0_30._modleAnim:GetAnimationState() then
		arg0_30._modleAnim:Resume()
	end
end

function var0_0.GetInterface(arg0_31)
	return arg0_31._modelClick, arg0_31._modelPress, arg0_31._dragDelegate
end

function var0_0.EnableInterface(arg0_32)
	arg0_32._mouseChild:GetComponent(typeof(Image)).enabled = true
end

function var0_0.DisableInterface(arg0_33)
	arg0_33._mouseChild:GetComponent(typeof(Image)).enabled = false
end

function var0_0.Dispose(arg0_34)
	if arg0_34.state == var0_0.STATE_INITED then
		arg0_34:StopTweenShining()
		arg0_34:RevertMaterial()
		PoolMgr.GetInstance():ReturnSpineChar(arg0_34.prefabName, arg0_34.model)
		arg0_34:SetVisible(true)
		arg0_34._modleGraphic.material:SetColor("_Color", Color.New(0, 0, 0, 0))

		arg0_34._modleGraphic.color = Color.New(1, 1, 1, 1)

		for iter0_34, iter1_34 in pairs(arg0_34._attachmentList) do
			Object.Destroy(iter0_34.gameObject)
		end

		arg0_34.model = nil
		arg0_34.prefabName = nil
		arg0_34.ship = nil
		arg0_34.attachmentData = nil
		arg0_34._modleGraphic = nil
		arg0_34._modleAnim = nil
		arg0_34._attachmentList = nil
	end

	arg0_34.state = var0_0.STATE_DISPOSE
end

return var0_0
