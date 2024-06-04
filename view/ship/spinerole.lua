local var0 = class("SpineRole")

var0.STATE_EMPTY = 0
var0.STATE_LOADING = 1
var0.STATE_INITED = 2
var0.STATE_DISPOSE = 3

function var0.Ctor(arg0, arg1)
	arg0.state = var0.STATE_EMPTY

	if arg1 then
		arg0.ship = arg1
		arg0.prefabName = arg0.ship:getPrefab()
	end
end

function var0.SetData(arg0, arg1, arg2)
	arg0.prefabName = arg1
	arg0.attachmentData = arg2
end

var0.ORBIT_KEY_UI = "orbit_ui"
var0.ORBIT_KEY_SLG = "orbit_slg"

function var0.Load(arg0, arg1, arg2, arg3)
	if arg2 == nil then
		arg2 = true
	end

	PoolMgr.GetInstance():GetSpineChar(arg0.prefabName, arg2, function(arg0)
		assert(arg0, "没有这个角色的模型  " .. arg0.prefabName)

		if arg0.state == var0.STATE_DISPOSE then
			PoolMgr.GetInstance():ReturnSpineChar(arg0.prefabName, arg0)
		else
			arg0.modelRoot = GameObject.New(arg0.prefabName .. "_root")

			arg0.modelRoot:AddComponent(typeof(RectTransform))

			arg0.model = arg0
			arg0.model.transform.localScale = Vector3.one

			arg0.model.transform:SetParent(arg0.modelRoot.transform, false)

			arg0.model.transform.localPosition = Vector3.zero

			arg0:Init()

			if arg1 then
				arg1()
			end

			arg0:AttachOrbit(arg3)
		end
	end)
end

function var0.Init(arg0)
	arg0.state = var0.STATE_INITED
	arg0._modleGraphic = arg0.model:GetComponent("SkeletonGraphic")
	arg0._modleAnim = arg0.model:GetComponent("SpineAnimUI")
	arg0._attachmentList = {}
	arg0._visible = true
end

function var0.AttachOrbit(arg0, arg1)
	local var0 = arg1 or var0.ORBIT_KEY_UI
	local var1 = arg0:GetAttachmentList()

	for iter0, iter1 in pairs(var1) do
		local var2 = iter1[var0]

		if var0 ~= var0.ORBIT_KEY_UI and var2 == "" then
			var2 = iter1.orbit_ui
			var0 = var0.ORBIT_KEY_UI
		end

		if var2 ~= "" then
			local var3 = ys.Battle.BattleResourceManager.GetOrbitPath(var2)

			ResourceMgr.Inst:getAssetAsync(var3, var2, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0.state == var0.STATE_DISPOSE then
					-- block empty
				else
					local var0 = var0 .. "_bound"
					local var1 = iter1[var0][1]
					local var2 = iter1[var0][2]
					local var3 = Object.Instantiate(arg0)

					var3.transform.localPosition = Vector2(var2[1], var2[2])

					local var4 = SpineAnimUI.AddFollower(var1, arg0.model.transform, var3.transform)

					var3.transform.localScale = Vector3.one
					arg0._attachmentList[var4] = iter1.orbit_hidden_action
					var4:GetComponent("Spine.Unity.BoneFollowerGraphic").followBoneRotation = false

					if iter1.orbit_ui_back == 1 then
						var4:SetParent(arg0.modelRoot.transform, false)
						var4:SetAsFirstSibling()
					else
						var4:SetParent(arg0.modelRoot.transform, false)
						var4:SetAsLastSibling()
					end

					SetActive(var3, arg0._visible)
				end
			end), true, true)
		end
	end
end

function var0.GetAttachmentList(arg0)
	if arg0.ship then
		return arg0.ship:getAttachmentPrefab()
	else
		return arg0.attachmentData or {}
	end
end

function var0.CheckInited(arg0)
	return arg0.state == var0.STATE_INITED
end

function var0.GetName(arg0)
	return arg0.modelRoot.name
end

function var0.SetParent(arg0, arg1)
	if arg0:CheckInited() then
		SetParent(arg0.modelRoot, arg1, false)
	end
end

function var0.SetRaycastTarget(arg0, arg1)
	if arg0:CheckInited() then
		arg0._modleGraphic.raycastTarget = arg1
	end
end

function var0.ModifyName(arg0, arg1)
	if arg0:CheckInited() then
		arg0.modelRoot.name = arg1
	end
end

function var0.SetVisible(arg0, arg1)
	if arg0:CheckInited() then
		arg0._visible = arg1
		arg0._modleGraphic.color = Color.New(1, 1, 1, arg1 and 1 or 0)

		for iter0, iter1 in pairs(arg0._attachmentList) do
			SetActive(iter0, arg1)
		end
	end
end

function var0.SetAction(arg0, arg1)
	if not arg0:CheckInited() then
		return
	end

	arg0._modleAnim:SetAction(arg1, 0)
	arg0:HiddenAttachmentByAction(arg1)
end

function var0.SetActionOnce(arg0, arg1)
	if not arg0:CheckInited() then
		return
	end

	arg0._modleGraphic.AnimationState:SetAnimation(0, arg1, false)
	arg0:HiddenAttachmentByAction(arg1)
end

function var0.SetActionCallBack(arg0, arg1)
	if not arg0:CheckInited() then
		return
	end

	arg0._modleAnim:SetActionCallBack(arg1)
end

function var0.HiddenAttachmentByAction(arg0, arg1)
	for iter0, iter1 in pairs(arg0._attachmentList) do
		SetActive(iter0, not table.contains(iter1, arg1))
	end
end

function var0.SetSizeDelta(arg0, arg1)
	if arg0:CheckInited() then
		rtf(arg0.modelRoot).sizeDelta = arg1
	end
end

function var0.SetLocalScale(arg0, arg1)
	if arg0:CheckInited() then
		arg0.modelRoot.transform.localScale = arg1
	end
end

function var0.SetLocalPos(arg0, arg1)
	if arg0:CheckInited() then
		arg0.modelRoot.transform.localPosition = arg1
	end
end

function var0.SetLayer(arg0, arg1)
	if arg0:CheckInited() then
		pg.ViewUtils.SetLayer(arg0.modelRoot.transform, arg1)
	end
end

function var0.TweenShining(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
	if arg0:CheckInited() then
		arg0:StopTweenShining()

		local var0 = arg0._modleGraphic.material
		local var1 = LeanTween.value(arg0.modelRoot, arg3, arg4, arg1):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0)
			if arg7 then
				var0:SetColor("_Color", Color.Lerp(arg5, arg6, arg0))
			else
				arg0._modleGraphic.color = Color.Lerp(arg5, arg6, arg0)
			end

			existCall(arg9, arg0)
		end)):setOnComplete(System.Action(function()
			arg0._tweenShiningId = nil

			if arg8 then
				if arg7 then
					var0:SetColor("_Color", arg5)
				else
					arg0._modleGraphic.color = arg5
				end
			end

			existCall(arg10)
		end))

		if arg2 then
			var1:setLoopPingPong(arg2)
		end

		arg0._tweenShiningId = var1.uniqueId
	end
end

function var0.StopTweenShining(arg0)
	if arg0:CheckInited() and arg0._tweenShiningId then
		LeanTween.cancel(arg0._tweenShiningId, true)

		arg0._tweenShiningId = nil
	end
end

function var0.ChangeMaterial(arg0, arg1)
	if not arg0:CheckInited() then
		return
	end

	if not arg0._stageMaterial then
		arg0._stageMaterial = arg0._modleGraphic.material
	end

	arg0._modleGraphic.material = arg1
end

function var0.RevertMaterial(arg0)
	if not arg0:CheckInited() then
		return
	end

	if not arg0._stageMaterial then
		return
	end

	arg0._modleGraphic.material = arg0._stageMaterial
end

function var0.CreateInterface(arg0)
	arg0._mouseChild = GameObject("mouseChild")

	arg0._mouseChild.transform:SetParent(arg0.modelRoot.transform, false)

	arg0._mouseChild.transform.localPosition = Vector3.zero
	arg0._modelClick = GetOrAddComponent(arg0._mouseChild, "ModelDrag")
	arg0._modelPress = GetOrAddComponent(arg0._mouseChild, "UILongPressTrigger")
	arg0._dragDelegate = GetOrAddComponent(arg0._mouseChild, "EventTriggerListener")

	arg0._modelClick:Init()

	local var0 = GetOrAddComponent(arg0._mouseChild, typeof(RectTransform))

	var0.pivot = Vector2(0.5, 0)
	var0.anchoredPosition = Vector2(0, 0)
	var0.localScale = Vector2(100, 100)
	var0.sizeDelta = Vector2(3, 3)

	return arg0._modelClick, arg0._modelPress, arg0._dragDelegate
end

function var0.resumeRole(arg0)
	if arg0._modleAnim and arg0._modleAnim:GetAnimationState() then
		arg0._modleAnim:Resume()
	end
end

function var0.GetInterface(arg0)
	return arg0._modelClick, arg0._modelPress, arg0._dragDelegate
end

function var0.EnableInterface(arg0)
	arg0._mouseChild:GetComponent(typeof(Image)).enabled = true
end

function var0.DisableInterface(arg0)
	arg0._mouseChild:GetComponent(typeof(Image)).enabled = false
end

function var0.Dispose(arg0)
	if arg0.state == var0.STATE_INITED then
		arg0:StopTweenShining()
		arg0:RevertMaterial()
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefabName, arg0.model)
		arg0:SetVisible(true)
		arg0._modleGraphic.material:SetColor("_Color", Color.New(0, 0, 0, 0))

		arg0._modleGraphic.color = Color.New(1, 1, 1, 1)

		for iter0, iter1 in pairs(arg0._attachmentList) do
			Object.Destroy(iter0.gameObject)
		end

		arg0.model = nil
		arg0.prefabName = nil
		arg0.ship = nil
		arg0.attachmentData = nil
		arg0._modleGraphic = nil
		arg0._modleAnim = nil
		arg0._attachmentList = nil
	end

	arg0.state = var0.STATE_DISPOSE
end

return var0
