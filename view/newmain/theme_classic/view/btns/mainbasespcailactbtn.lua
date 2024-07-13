local var0_0 = class("MainBaseSpcailActBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.root = arg1_1
	arg0_1.event = arg2_1
	arg0_1.isloading = false
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.isScale = arg1_2

	if arg0_2.isloading then
		return
	end

	if not arg0_2._tf then
		arg0_2.isloading = true

		ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_2:GetUIName(), "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
			arg0_2.isloading = false

			if arg0_2.exited then
				return
			end

			arg0_2._tf = Object.Instantiate(arg0_3, arg0_2:GetContainer()).transform

			arg0_2:OnRegister()
			arg0_2:OnInit()
			onButton(arg0_2, arg0_2._tf, function()
				arg0_2:OnClick()
			end, SFX_MAIN)

			if arg0_2.shouldHide then
				setActive(arg0_2._tf, false)
			end
		end), true, true)
	else
		arg0_2:OnInit()
	end

	arg0_2:CheckHide()
end

function var0_0.Clear(arg0_5)
	if not IsNil(arg0_5._tf) then
		Destroy(arg0_5._tf.gameObject)

		arg0_5._tf = nil

		arg0_5:OnClear()
	end
end

function var0_0.Dispose(arg0_6)
	arg0_6.exited = true

	pg.DelegateInfo.Dispose(arg0_6)
	arg0_6:Clear()
end

function var0_0.Refresh(arg0_7)
	arg0_7:CheckHide()
end

function var0_0.CheckHide(arg0_8)
	if arg0_8.shouldHide and not IsNil(arg0_8._tf) then
		setActive(arg0_8._tf, true)
	end

	arg0_8.shouldHide = false
end

function var0_0.Disable(arg0_9)
	arg0_9.shouldHide = true

	arg0_9:OnDisable()
end

function var0_0.GetContainer(arg0_10)
	assert(false, "overview me !!!")
end

function var0_0.InShowTime(arg0_11)
	assert(false, "overview me !!!")
end

function var0_0.GetUIName(arg0_12)
	return
end

function var0_0.OnClick(arg0_13)
	return
end

function var0_0.OnRegister(arg0_14)
	return
end

function var0_0.OnInit(arg0_15)
	return
end

function var0_0.OnClear(arg0_16)
	return
end

function var0_0.OnDisable(arg0_17)
	return
end

return var0_0
