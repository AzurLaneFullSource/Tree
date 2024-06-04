local var0 = class("UIStrikeAnim", import(".UIAnim"))

var0.Fields = {
	spineAnim = "userdata",
	prefab = "string",
	aniEvent = "userdata",
	char = "userdata",
	transform = "userdata",
	playing = "boolean",
	onTrigger = "function",
	onStart = "function",
	onEnd = "function",
	skelegraph = "userdata",
	painting = "userdata",
	shipVO = "table"
}
var0.EventLoaded = "UIStrikeAnim.EventLoaded"

function var0.Setup(arg0, arg1, arg2)
	arg0.prefab = arg1
	arg0.shipVO = arg2
end

function var0.LoadBack(arg0)
	if arg0.transform and arg0.painting and arg0.char then
		arg0:Init()
		arg0:DispatchEvent(var0.EventLoaded)
	end
end

function var0.Load(arg0)
	local var0 = arg0.prefab
	local var1 = PoolMgr.GetInstance()

	var1:GetUI(var0, true, function(arg0)
		if var0 == arg0.prefab then
			arg0.transform = arg0.transform

			arg0:LoadBack()
		else
			var1:ReturnUI(var0, arg0)
		end
	end)
	arg0:ReloadShip(arg0.shipVO)
end

function var0.ReloadShip(arg0, arg1)
	arg0.shipVO = arg1
	arg0.aniEvent = nil
	arg0.painting = nil
	arg0.char = nil

	local var0 = PoolMgr.GetInstance()

	var0.GetInstance():GetPainting(arg1:getPainting(), true, function(arg0)
		arg0.painting = arg0

		ShipExpressionHelper.SetExpression(arg0.painting, arg1:getPainting())
		arg0:LoadBack()
	end)
	var0.GetInstance():GetSpineChar(arg1:getPrefab(), true, function(arg0)
		arg0.char = arg0
		arg0.char.transform.localScale = Vector3.one

		arg0:LoadBack()
	end)
end

function var0.UnloadShipVO(arg0)
	local var0 = arg0.shipVO

	retPaintingPrefab(arg0.transform:Find("mask/painting"), var0:getPainting())
	PoolMgr.GetInstance():ReturnSpineChar(var0:getPrefab(), arg0.char)

	arg0.shipVO = nil
	arg0.painting = nil
	arg0.char = nil
end

function var0.Play(arg0, arg1)
	arg0.playing = true

	function arg0.onStart(arg0)
		arg0.spineAnim:SetAction("attack", 0)

		arg0.skelegraph.freeze = true
	end

	function arg0.onTrigger(arg0)
		arg0.skelegraph.freeze = false

		arg0.spineAnim:SetActionCallBack(function(arg0)
			if arg0 == "action" then
				-- block empty
			elseif arg0 == "finish" then
				arg0.skelegraph.freeze = true
			end
		end)
	end

	arg0.onEnd = arg1

	arg0:Update()
end

function var0.Stop(arg0)
	arg0.playing = false

	arg0:Update()

	if arg0.skelegraph then
		arg0.skelegraph.freeze = false
	end

	arg0:UnloadShipVO()
end

function var0.Init(arg0)
	setActive(arg0.transform, false)

	local var0 = arg0.transform:Find("torpedo")
	local var1 = arg0.transform:Find("mask/painting")
	local var2 = arg0.transform:Find("ship")

	setParent(arg0.painting, var1:Find("fitter"), false)
	setParent(arg0.char, var2, false)
	setActive(var2, false)
	setActive(var0, false)

	arg0.spineAnim = arg0.char:GetComponent("SpineAnimUI")
	arg0.skelegraph = arg0.spineAnim:GetComponent("SkeletonGraphic")
	arg0.aniEvent = arg0.transform:GetComponent("DftAniEvent")

	arg0:Update()
end

return var0
