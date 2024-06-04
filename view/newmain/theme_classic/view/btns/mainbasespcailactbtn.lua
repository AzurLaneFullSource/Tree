local var0 = class("MainBaseSpcailActBtn")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.root = arg1
	arg0.event = arg2
	arg0.isloading = false
end

function var0.Init(arg0, arg1)
	arg0.isScale = arg1

	if arg0.isloading then
		return
	end

	if not arg0._tf then
		arg0.isloading = true

		ResourceMgr.Inst:getAssetAsync("ui/" .. arg0:GetUIName(), "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			arg0.isloading = false

			if arg0.exited then
				return
			end

			arg0._tf = Object.Instantiate(arg0, arg0:GetContainer()).transform

			arg0:OnRegister()
			arg0:OnInit()
			onButton(arg0, arg0._tf, function()
				arg0:OnClick()
			end, SFX_MAIN)

			if arg0.shouldHide then
				setActive(arg0._tf, false)
			end
		end), true, true)
	else
		arg0:OnInit()
	end

	arg0:CheckHide()
end

function var0.Clear(arg0)
	if not IsNil(arg0._tf) then
		Destroy(arg0._tf.gameObject)

		arg0._tf = nil

		arg0:OnClear()
	end
end

function var0.Dispose(arg0)
	arg0.exited = true

	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Refresh(arg0)
	arg0:CheckHide()
end

function var0.CheckHide(arg0)
	if arg0.shouldHide and not IsNil(arg0._tf) then
		setActive(arg0._tf, true)
	end

	arg0.shouldHide = false
end

function var0.Disable(arg0)
	arg0.shouldHide = true

	arg0:OnDisable()
end

function var0.GetContainer(arg0)
	assert(false, "overview me !!!")
end

function var0.InShowTime(arg0)
	assert(false, "overview me !!!")
end

function var0.GetUIName(arg0)
	return
end

function var0.OnClick(arg0)
	return
end

function var0.OnRegister(arg0)
	return
end

function var0.OnInit(arg0)
	return
end

function var0.OnClear(arg0)
	return
end

function var0.OnDisable(arg0)
	return
end

return var0
