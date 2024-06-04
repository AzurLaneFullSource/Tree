local var0 = class("CourtyardFurnitureState")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._tf = arg1.transform
	arg0.rectTF = arg2
	arg0.rootTF = arg0._tf.parent
	arg0.furnitureStateImg = arg0._tf:GetComponent(typeof(Image))
	arg0.furnitureStateAnim = arg0._tf:GetComponent(typeof(Animation))
	arg0.selectedMat = arg3
	arg0.canPlaceMat = arg4
	arg0.cantPlaceMat = arg5
end

function var0.Init(arg0, arg1, arg2)
	pg.UIMgr.GetInstance():LoadingOn(false)
	setActive(arg0._tf, false)
	ResourceMgr.Inst:getAssetAsync("furnitrues/" .. arg2:GetPicture(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0.exited then
			return
		end

		setActive(arg0._tf, true)

		arg0.furnitureStateImg.sprite = arg0:GetComponent(typeof(Image)).sprite
		arg0._tf.sizeDelta = arg0.transform.sizeDelta
		arg0._tf.localPosition = arg1:GetCenterPoint()

		arg0:OnUpdateScale(arg1)
		arg0:OnReset()
	end), true, true)
end

function var0.OnInit(arg0, arg1, arg2)
	arg0:Init(arg1, arg2)
	setParent(arg0._tf, arg0.rectTF)
end

function var0.OnUpdateScale(arg0, arg1)
	local var0 = CourtYardCalcUtil.GetSign(arg1._tf.localScale.x)

	arg0._tf.localScale = Vector3(var0, 1, 1)
end

function var0.OnUpdate(arg0, arg1)
	arg0._tf.localPosition = arg1:GetCenterPoint()
end

function var0.OnCantPlace(arg0)
	if arg0.furnitureStateImg.material ~= arg0.cantPlaceMat then
		arg0.furnitureStateImg.material = arg0.cantPlaceMat

		arg0.furnitureStateAnim:Play("anim_courtyard_iconred")
	end
end

function var0.OnCanPlace(arg0)
	if arg0.furnitureStateImg.material ~= arg0.canPlaceMat then
		arg0.furnitureStateImg.material = arg0.canPlaceMat

		arg0.furnitureStateAnim:Play("anim_courtyard_icongreen")
	end
end

function var0.OnReset(arg0)
	if arg0.furnitureStateImg.material ~= arg0.selectedMat then
		arg0.furnitureStateImg.material = arg0.selectedMat

		arg0.furnitureStateAnim:Play("anim_courtyard_iconwhite")
	end
end

function var0.OnClear(arg0)
	arg0.furnitureStateAnim:Stop()

	arg0.furnitureStateImg.sprite = nil
	arg0.furnitureStateImg.material = nil

	setParent(arg0._tf, arg0.rootTF)
end

return var0
