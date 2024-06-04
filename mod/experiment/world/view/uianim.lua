local var0 = class("UIAnim", import("...BaseEntity"))

var0.Fields = {
	transform = "userdata",
	aniEvent = "userdata",
	onEnd = "function",
	playing = "boolean",
	prefab = "string",
	onTrigger = "function",
	onStart = "function"
}
var0.EventLoaded = "UIAnim.EventLoaded"

function var0.Setup(arg0, arg1)
	arg0.prefab = arg1
end

function var0.Dispose(arg0)
	arg0:Unload()
	arg0:Clear()
end

function var0.Load(arg0)
	local var0 = arg0.prefab
	local var1 = PoolMgr.GetInstance()

	var1:GetUI(var0, true, function(arg0)
		if var0 == arg0.prefab then
			arg0.transform = arg0.transform

			arg0:Init()
			arg0:DispatchEvent(var0.EventLoaded)
		else
			var1:ReturnUI(var0, arg0)
		end
	end)
end

function var0.Unload(arg0)
	if arg0.prefab and arg0.transform then
		PoolMgr.GetInstance():ReturnUI(arg0.prefab, arg0.transform.gameObject)
	end

	arg0.prefab = nil
	arg0.transform = nil
end

function var0.Play(arg0, arg1)
	arg0.playing = true
	arg0.onStart = nil
	arg0.onTrigger = nil
	arg0.onEnd = arg1

	arg0:Update()
end

function var0.Stop(arg0)
	arg0.playing = false

	arg0:Update()
end

function var0.Init(arg0)
	setActive(arg0.transform, false)

	arg0.aniEvent = arg0.transform:GetComponent("DftAniEvent")

	arg0:Update()
end

function var0.Update(arg0)
	if arg0.aniEvent then
		setActive(arg0.transform, arg0.playing)

		if arg0.playing then
			arg0.aniEvent:SetStartEvent(function()
				if arg0.onStart then
					arg0.onStart()
				end
			end)
			arg0.aniEvent:SetTriggerEvent(function()
				if arg0.onTrigger then
					arg0.onTrigger()
				end
			end)
			arg0.aniEvent:SetEndEvent(function(arg0)
				arg0:Stop()

				if arg0.onEnd then
					arg0.onEnd()
				end
			end)
		end
	end
end

return var0
