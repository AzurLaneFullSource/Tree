local var0_0 = class("VedioStoryPlayer", import(".StoryPlayer"))

function var0_0.OnReset(arg0_1, arg1_1, arg2_1, arg3_1)
	arg3_1()
end

local function var1_0(arg0_2)
	return PathMgr.getAssetBundle("originsource/cpk/" .. arg0_2 .. ".cpk")
end

function var0_0.RegisetEvent(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:GetVedioPath()

	arg0_3:CheckAndPlay(arg1_3, var0_3, arg2_3)
end

function var0_0.CheckAndPlay(arg0_4, arg1_4, arg2_4, arg3_4)
	if not IsUnityEditor and not PathMgr.FileExists(var1_0(arg2_4)) then
		arg3_4()

		return
	end

	arg0_4:PlayVedio(arg1_4, arg2_4, arg3_4)
end

function var0_0.PlayVedio(arg0_5, arg1_5, arg2_5, arg3_5)
	ResourceMgr.Inst:getAssetAsync("Story/" .. arg2_5, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_6)
		if arg0_5.stop then
			return
		end

		local var0_6 = Object.Instantiate(arg0_6, arg0_5.frontTr)
		local var1_6 = var0_6.transform:Find("cpk"):GetComponent(typeof(CriManaCpkUI))
		local var2_6 = var0_6.transform:Find("skip_button")

		onButton(arg0_5, var2_6, function()
			arg0_5:ClearVedio()
			arg3_5()
		end, SFX_PANEL)
		var1_6:SetPlayEndHandler(System.Action(function()
			triggerButton(var2_6)
		end))
		setActive(var2_6, arg1_5:GetSkipFlag())

		arg0_5._vedioGo = var0_6
	end), true, true)
end

function var0_0.ClearVedio(arg0_9)
	if arg0_9._vedioGo then
		Object.Destroy(arg0_9._vedioGo)

		arg0_9._vedioGo = nil
	end
end

function var0_0.OnClear(arg0_10)
	arg0_10:ClearVedio()
end

function var0_0.OnEnd(arg0_11)
	arg0_11:ClearVedio()
end

return var0_0
