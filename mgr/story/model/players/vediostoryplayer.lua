local var0 = class("VedioStoryPlayer", import(".StoryPlayer"))

function var0.OnReset(arg0, arg1, arg2, arg3)
	arg3()
end

local function var1(arg0)
	return PathMgr.getAssetBundle("originsource/cpk/" .. arg0 .. ".cpk")
end

function var0.RegisterTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetVedioPath()

	arg0:CheckAndPlay(arg2, var0, arg3)
end

function var0.CheckAndPlay(arg0, arg1, arg2, arg3)
	if not PathMgr.FileExists(var1(arg2)) then
		arg3()

		return
	end

	arg0:PlayVedio(arg1, arg2, arg3)
end

function var0.PlayVedio(arg0, arg1, arg2, arg3)
	ResourceMgr.Inst:getAssetAsync("Story/" .. arg2, arg2, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.stop then
			return
		end

		local var0 = Object.Instantiate(arg0, arg0.frontTr)
		local var1 = var0.transform:Find("cpk"):GetComponent(typeof(CriManaCpkUI))
		local var2 = var0.transform:Find("skip_button")

		onButton(arg0, var2, function()
			arg0:ClearVedio()
			arg3()
		end, SFX_PANEL)
		var1:SetPlayEndHandler(System.Action(function()
			triggerButton(var2)
		end))
		setActive(var2, arg1:GetSkipFlag())

		arg0._vedioGo = var0
	end), true, true)
end

function var0.ClearVedio(arg0)
	if arg0._vedioGo then
		Object.Destroy(arg0._vedioGo)

		arg0._vedioGo = nil
	end
end

function var0.OnClear(arg0)
	arg0:ClearVedio()
end

function var0.OnEnd(arg0)
	arg0:ClearVedio()
end

return var0
