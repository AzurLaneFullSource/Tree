local var0 = class("StoryPerformPlayer", import(".BasePerformPlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.bgTF = arg0:findTF("bg", arg0._tf)
	arg0.nameTF = arg0:findTF("name", arg0.bgTF)
	arg0.imageCom = arg0:findTF("picture", arg0.bgTF):GetComponent(typeof(Image))
end

function var0.Play(arg0, arg1, arg2, arg3)
	arg0:Show()

	if arg0._anim then
		arg0._anim:Play()
	end

	if arg3 then
		setText(arg0.nameTF, arg3)
	end

	local var0 = arg1.param[1] or ""
	local var1 = arg1.param[2] or 3

	setActive(arg0.bgTF, false)
	ResourceMgr.Inst:getAssetAsync("educatepicture/" .. var0, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg0.imageCom.sprite = arg0

		setActive(arg0.bgTF, true)

		arg0.timer = Timer.New(function()
			if arg2 then
				arg2()
			end
		end, var1)

		arg0.timer:Start()
	end), true, true)
end

function var0.Clear(arg0)
	arg0.imageCom.sprite = nil

	if arg0.timer ~= nil then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	setText(arg0.nameTF, "")
	arg0:Hide()
end

return var0
