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
			arg0_5.model = arg0_6
			arg0_5.model.transform.localScale = Vector3.one
			arg0_5.model.transform.localPosition = Vector3.zero

			arg0_5:Init()

			if arg1_5 then
				arg1_5()
			end
		end
	end)
end

function var0_0.Init(arg0_7)
	arg0_7.state = var0_0.STATE_INITED
	arg0_7._modleGraphic = arg0_7.model:GetComponent("SkeletonGraphic")
	arg0_7._modleAnim = arg0_7.model:GetComponent("SpineAnimUI")
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
			local var5_8 = ys.Battle.BattleResourceManager.GetOrbitPath(var4_8)

			ResourceMgr.Inst:getAssetAsync(var5_8, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
				if arg0_8.state == var0_0.STATE_DISPOSE then
					-- block empty
				else
					local var0_9 = var0_8 .. "_bound"
					local var1_9 = var2_8[var0_9][1]
					local var2_9 = var2_8[var0_9][2]
					local var3_9 = Object.Instantiate(arg0_9)
					local var4_9 = var3_9:GetComponentsInChildren(typeof(Spine.Unity.SkeletonGraphic)):ToTable()

					for iter0_9, iter1_9 in ipairs(var4_9) do
						iter1_9.raycastTarget = false
					end

					var3_9.transform.localPosition = Vector2(var2_9[1], var2_9[2])

					local var5_9 = SpineAnimUI.AddFollower(var1_9, arg0_8.model.transform, var3_9.transform)

					var3_9.transform.localScale = Vector3.one
					arg0_8._attachmentList[var5_9] = {
						p = var4_8,
						hiddenActionList = var2_8.orbit_hidden_action,
						index = var3_8,
						back = var2_8.orbit_ui_back
					}

					local var6_9 = var5_9:GetComponent("Spine.Unity.BoneFollowerGraphic")

					if var2_8.orbit_rotate then
						var6_9.followBoneRotation = true

						local var7_9 = var3_9.transform.localEulerAngles

						var3_9.transform.localEulerAngles = Vector3(var7_9.x, var7_9.y, var7_9.z - 90)
					else
						var6_9.followBoneRotation = false
					end

					if var2_8.orbit_ui_back == 1 then
						var5_9:SetParent(arg0_8.modelRoot.transform, false)
						var5_9:SetAsFirstSibling()
					else
						var5_9:SetParent(arg0_8.modelRoot.transform, false)
						var5_9:SetAsLastSibling()
					end

					SetActive(var5_9, arg0_8._visible)
					arg0_8:sortAttachmentGO()
				end
			end), true, true)
		end
	end
end

function var0_0.sortAttachmentGO(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10._attachmentList) do
		table.insert(var0_10, {
			tf = iter0_10,
			index = iter1_10.index,
			back = iter1_10.back,
			p = iter1_10.p
		})
	end

	table.sort(var0_10, function(arg0_11, arg1_11)
		return arg0_11.index < arg1_11.index
	end)

	for iter2_10, iter3_10 in ipairs(var0_10) do
		if iter3_10.back ~= 1 then
			iter3_10.tf:SetAsLastSibling()

			break
		end
	end
end

function var0_0.GetAttachmentList(arg0_12)
	if arg0_12.ship then
		return arg0_12.ship:getAttachmentPrefab()
	else
		return arg0_12.attachmentData or {}
	end
end

function var0_0.CheckInited(arg0_13)
	return arg0_13.state == var0_0.STATE_INITED
end

function var0_0.GetName(arg0_14)
	return arg0_14.modelRoot.name
end

function var0_0.SetParent(arg0_15, arg1_15)
	if arg0_15:CheckInited() then
		SetParent(arg0_15.modelRoot, arg1_15, false)
	end
end

function var0_0.SetRaycastTarget(arg0_16, arg1_16)
	if arg0_16:CheckInited() then
		arg0_16._modleGraphic.raycastTarget = arg1_16
	end
end

function var0_0.ModifyName(arg0_17, arg1_17)
	if arg0_17:CheckInited() then
		arg0_17.modelRoot.name = arg1_17
	end
end

function var0_0.SetVisible(arg0_18, arg1_18)
	if arg0_18:CheckInited() then
		arg0_18._visible = arg1_18
		arg0_18._modleGraphic.color = Color.New(1, 1, 1, arg1_18 and 1 or 0)

		for iter0_18, iter1_18 in pairs(arg0_18._attachmentList) do
			SetActive(iter0_18, arg1_18)
		end
	end
end

function var0_0.SetAction(arg0_19, arg1_19)
	if not arg0_19:CheckInited() then
		return
	end

	arg0_19._modleAnim:SetAction(arg1_19, 0)
	arg0_19:HiddenAttachmentByAction(arg1_19)
end

function var0_0.SetActionOnce(arg0_20, arg1_20)
	if not arg0_20:CheckInited() then
		return
	end

	arg0_20._modleGraphic.AnimationState:SetAnimation(0, arg1_20, false)
	arg0_20:HiddenAttachmentByAction(arg1_20)
end

function var0_0.SetActionCallBack(arg0_21, arg1_21)
	if not arg0_21:CheckInited() then
		return
	end

	arg0_21._modleAnim:SetActionCallBack(arg1_21)
end

function var0_0.HiddenAttachmentByAction(arg0_22, arg1_22)
	for iter0_22, iter1_22 in pairs(arg0_22._attachmentList) do
		SetActive(iter0_22, not table.contains(iter1_22.hiddenActionList, arg1_22))
	end
end

function var0_0.SetSizeDelta(arg0_23, arg1_23)
	if arg0_23:CheckInited() then
		rtf(arg0_23.modelRoot).sizeDelta = arg1_23
	end
end

function var0_0.SetLocalScale(arg0_24, arg1_24)
	if arg0_24:CheckInited() then
		arg0_24.modelRoot.transform.localScale = arg1_24
	end
end

function var0_0.SetLocalPos(arg0_25, arg1_25)
	if arg0_25:CheckInited() then
		arg0_25.modelRoot.transform.localPosition = arg1_25
	end
end

function var0_0.SetLayer(arg0_26, arg1_26)
	if arg0_26:CheckInited() then
		pg.ViewUtils.SetLayer(arg0_26.modelRoot.transform, arg1_26)
	end
end

function var0_0.TweenShining(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27, arg6_27, arg7_27, arg8_27, arg9_27, arg10_27)
	if arg0_27:CheckInited() then
		arg0_27:StopTweenShining()

		local var0_27 = arg0_27._modleGraphic.material
		local var1_27 = LeanTween.value(arg0_27.modelRoot, arg3_27, arg4_27, arg1_27):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_28)
			if arg7_27 then
				var0_27:SetColor("_Color", Color.Lerp(arg5_27, arg6_27, arg0_28))
			else
				arg0_27._modleGraphic.color = Color.Lerp(arg5_27, arg6_27, arg0_28)
			end

			existCall(arg9_27, arg0_28)
		end)):setOnComplete(System.Action(function()
			arg0_27._tweenShiningId = nil

			if arg8_27 then
				if arg7_27 then
					var0_27:SetColor("_Color", arg5_27)
				else
					arg0_27._modleGraphic.color = arg5_27
				end
			end

			existCall(arg10_27)
		end))

		if arg2_27 then
			var1_27:setLoopPingPong(arg2_27)
		end

		arg0_27._tweenShiningId = var1_27.uniqueId
	end
end

function var0_0.StopTweenShining(arg0_30)
	if arg0_30:CheckInited() and arg0_30._tweenShiningId then
		LeanTween.cancel(arg0_30._tweenShiningId, true)

		arg0_30._tweenShiningId = nil
	end
end

function var0_0.ChangeMaterial(arg0_31, arg1_31)
	if not arg0_31:CheckInited() then
		return
	end

	if not arg0_31._stageMaterial then
		arg0_31._stageMaterial = arg0_31._modleGraphic.material
	end

	arg0_31._modleGraphic.material = arg1_31
end

function var0_0.RevertMaterial(arg0_32)
	if not arg0_32:CheckInited() then
		return
	end

	if not arg0_32._stageMaterial then
		return
	end

	arg0_32._modleGraphic.material = arg0_32._stageMaterial
end

function var0_0.CreateInterface(arg0_33)
	arg0_33._mouseChild = GameObject("mouseChild")

	arg0_33._mouseChild.transform:SetParent(arg0_33.modelRoot.transform, false)

	arg0_33._mouseChild.transform.localPosition = Vector3.zero
	arg0_33._modelClick = GetOrAddComponent(arg0_33._mouseChild, "ModelDrag")
	arg0_33._modelPress = GetOrAddComponent(arg0_33._mouseChild, "UILongPressTrigger")
	arg0_33._dragDelegate = GetOrAddComponent(arg0_33._mouseChild, "EventTriggerListener")

	arg0_33._modelClick:Init()

	local var0_33 = GetOrAddComponent(arg0_33._mouseChild, typeof(RectTransform))

	var0_33.pivot = Vector2(0.5, 0)
	var0_33.anchoredPosition = Vector2(0, 0)
	var0_33.localScale = Vector2(100, 100)
	var0_33.sizeDelta = Vector2(3, 3)

	return arg0_33._modelClick, arg0_33._modelPress, arg0_33._dragDelegate
end

function var0_0.resumeRole(arg0_34)
	if arg0_34._modleAnim and arg0_34._modleAnim:GetAnimationState() then
		arg0_34._modleAnim:Resume()
	end
end

function var0_0.GetInterface(arg0_35)
	return arg0_35._modelClick, arg0_35._modelPress, arg0_35._dragDelegate
end

function var0_0.EnableInterface(arg0_36)
	arg0_36._mouseChild:GetComponent(typeof(Image)).enabled = true
end

function var0_0.DisableInterface(arg0_37)
	arg0_37._mouseChild:GetComponent(typeof(Image)).enabled = false
end

function var0_0.Dispose(arg0_38)
	if arg0_38.state == var0_0.STATE_INITED then
		arg0_38:StopTweenShining()
		arg0_38:RevertMaterial()
		PoolMgr.GetInstance():ReturnSpineChar(arg0_38.prefabName, arg0_38.model)
		arg0_38:SetVisible(true)
		arg0_38._modleGraphic.material:SetColor("_Color", Color.New(0, 0, 0, 0))

		arg0_38._modleGraphic.color = Color.New(1, 1, 1, 1)

		for iter0_38, iter1_38 in pairs(arg0_38._attachmentList) do
			Object.Destroy(iter0_38.gameObject)
		end

		arg0_38.model = nil
		arg0_38.prefabName = nil
		arg0_38.ship = nil
		arg0_38.attachmentData = nil
		arg0_38._modleGraphic = nil
		arg0_38._modleAnim = nil
		arg0_38._attachmentList = nil
	end

	arg0_38.state = var0_0.STATE_DISPOSE
end

return var0_0
