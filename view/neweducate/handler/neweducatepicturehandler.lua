local var0_0 = class("NewEducatePictureHandler")
local var1_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._anim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.bgTF = arg0_1._tf:Find("bg")
	arg0_1.nameTF = arg0_1.bgTF:Find("name")
	arg0_1.imageCom = arg0_1.bgTF:Find("picture"):GetComponent(typeof(Image))
end

function var0_0.Play(arg0_2, arg1_2, arg2_2, arg3_2)
	setActive(arg0_2._go, true)

	if arg0_2._anim then
		arg0_2._anim:Play()
	end

	setText(arg0_2.nameTF, arg3_2 or "")
	ResourceMgr.Inst:getAssetAsync("neweducateicon/" .. arg1_2, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
		arg0_2.imageCom.sprite = arg0_3
		arg0_2.timer = Timer.New(function()
			existCall(arg2_2)
		end, var1_0)

		arg0_2.timer:Start()
	end), true, true)
end

function var0_0.Reset(arg0_5)
	setActive(arg0_5._go, false)

	arg0_5.imageCom.sprite = nil

	if arg0_5.timer ~= nil then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.Destroy(arg0_6)
	return
end

return var0_0
