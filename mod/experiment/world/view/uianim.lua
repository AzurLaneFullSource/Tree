local var0_0 = class("UIAnim", import("...BaseEntity"))

var0_0.Fields = {
	transform = "userdata",
	aniEvent = "userdata",
	onEnd = "function",
	playing = "boolean",
	prefab = "string",
	onTrigger = "function",
	onStart = "function"
}
var0_0.EventLoaded = "UIAnim.EventLoaded"

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.prefab = arg1_1
end

function var0_0.Dispose(arg0_2)
	arg0_2:Unload()
	arg0_2:Clear()
end

function var0_0.Load(arg0_3)
	local var0_3 = arg0_3.prefab
	local var1_3 = PoolMgr.GetInstance()

	var1_3:GetUI(var0_3, true, function(arg0_4)
		if var0_3 == arg0_3.prefab then
			arg0_3.transform = arg0_4.transform

			arg0_3:Init()
			arg0_3:DispatchEvent(var0_0.EventLoaded)
		else
			var1_3:ReturnUI(var0_3, arg0_4)
		end
	end)
end

function var0_0.Unload(arg0_5)
	if arg0_5.prefab and arg0_5.transform then
		PoolMgr.GetInstance():ReturnUI(arg0_5.prefab, arg0_5.transform.gameObject)
	end

	arg0_5.prefab = nil
	arg0_5.transform = nil
end

function var0_0.Play(arg0_6, arg1_6)
	arg0_6.playing = true
	arg0_6.onStart = nil
	arg0_6.onTrigger = nil
	arg0_6.onEnd = arg1_6

	arg0_6:Update()
end

function var0_0.Stop(arg0_7)
	arg0_7.playing = false

	arg0_7:Update()
end

function var0_0.Init(arg0_8)
	setActive(arg0_8.transform, false)

	arg0_8.aniEvent = arg0_8.transform:GetComponent("DftAniEvent")

	arg0_8:Update()
end

function var0_0.Update(arg0_9)
	if arg0_9.aniEvent then
		setActive(arg0_9.transform, arg0_9.playing)

		if arg0_9.playing then
			arg0_9.aniEvent:SetStartEvent(function()
				if arg0_9.onStart then
					arg0_9.onStart()
				end
			end)
			arg0_9.aniEvent:SetTriggerEvent(function()
				if arg0_9.onTrigger then
					arg0_9.onTrigger()
				end
			end)
			arg0_9.aniEvent:SetEndEvent(function(arg0_12)
				arg0_9:Stop()

				if arg0_9.onEnd then
					arg0_9.onEnd()
				end
			end)
		end
	end
end

return var0_0
