local var0_0 = class("StoryPerformPlayer", import(".BasePerformPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bgTF = arg0_1:findTF("bg", arg0_1._tf)
	arg0_1.nameTF = arg0_1:findTF("name", arg0_1.bgTF)
	arg0_1.imageCom = arg0_1:findTF("picture", arg0_1.bgTF):GetComponent(typeof(Image))
end

function var0_0.Play(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2:Show()

	if arg0_2._anim then
		arg0_2._anim:Play()
	end

	if arg3_2 then
		setText(arg0_2.nameTF, arg3_2)
	end

	local var0_2 = arg1_2.param[1] or ""
	local var1_2 = arg1_2.param[2] or 3

	setActive(arg0_2.bgTF, false)
	ResourceMgr.Inst:getAssetAsync("educatepicture/" .. var0_2, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
		arg0_2.imageCom.sprite = arg0_3

		setActive(arg0_2.bgTF, true)

		arg0_2.timer = Timer.New(function()
			if arg2_2 then
				arg2_2()
			end
		end, var1_2)

		arg0_2.timer:Start()
	end), true, true)
end

function var0_0.Clear(arg0_5)
	arg0_5.imageCom.sprite = nil

	if arg0_5.timer ~= nil then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end

	setText(arg0_5.nameTF, "")
	arg0_5:Hide()
end

return var0_0
