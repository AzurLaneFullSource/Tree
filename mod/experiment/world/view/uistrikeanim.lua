local var0_0 = class("UIStrikeAnim", import(".UIAnim"))

var0_0.Fields = {
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
var0_0.EventLoaded = "UIStrikeAnim.EventLoaded"

function var0_0.Setup(arg0_1, arg1_1, arg2_1)
	arg0_1.prefab = arg1_1
	arg0_1.shipVO = arg2_1
end

function var0_0.LoadBack(arg0_2)
	if arg0_2.transform and arg0_2.painting and arg0_2.char then
		arg0_2:Init()
		arg0_2:DispatchEvent(var0_0.EventLoaded)
	end
end

function var0_0.Load(arg0_3)
	local var0_3 = arg0_3.prefab
	local var1_3 = PoolMgr.GetInstance()

	var1_3:GetUI(var0_3, true, function(arg0_4)
		if var0_3 == arg0_3.prefab then
			arg0_3.transform = arg0_4.transform

			arg0_3:LoadBack()
		else
			var1_3:ReturnUI(var0_3, arg0_4)
		end
	end)
	arg0_3:ReloadShip(arg0_3.shipVO)
end

function var0_0.ReloadShip(arg0_5, arg1_5)
	arg0_5.shipVO = arg1_5
	arg0_5.aniEvent = nil
	arg0_5.painting = nil
	arg0_5.char = nil

	local var0_5 = PoolMgr.GetInstance()

	var0_5.GetInstance():GetPainting(arg1_5:getPainting(), true, function(arg0_6)
		arg0_5.painting = arg0_6

		ShipExpressionHelper.SetExpression(arg0_5.painting, arg1_5:getPainting())
		arg0_5:LoadBack()
	end)
	var0_5.GetInstance():GetSpineChar(arg1_5:getPrefab(), true, function(arg0_7)
		arg0_5.char = arg0_7
		arg0_5.char.transform.localScale = Vector3.one

		arg0_5:LoadBack()
	end)
end

function var0_0.UnloadShipVO(arg0_8)
	local var0_8 = arg0_8.shipVO

	retPaintingPrefab(arg0_8.transform:Find("mask/painting"), var0_8:getPainting())
	PoolMgr.GetInstance():ReturnSpineChar(var0_8:getPrefab(), arg0_8.char)

	arg0_8.shipVO = nil
	arg0_8.painting = nil
	arg0_8.char = nil
end

function var0_0.Play(arg0_9, arg1_9)
	arg0_9.playing = true

	function arg0_9.onStart(arg0_10)
		arg0_9.spineAnim:SetAction("attack", 0)

		arg0_9.skelegraph.freeze = true
	end

	function arg0_9.onTrigger(arg0_11)
		arg0_9.skelegraph.freeze = false

		arg0_9.spineAnim:SetActionCallBack(function(arg0_12)
			if arg0_12 == "action" then
				-- block empty
			elseif arg0_12 == "finish" then
				arg0_9.skelegraph.freeze = true
			end
		end)
	end

	arg0_9.onEnd = arg1_9

	arg0_9:Update()
end

function var0_0.Stop(arg0_13)
	arg0_13.playing = false

	arg0_13:Update()

	if arg0_13.skelegraph then
		arg0_13.skelegraph.freeze = false
	end

	arg0_13:UnloadShipVO()
end

function var0_0.Init(arg0_14)
	setActive(arg0_14.transform, false)

	local var0_14 = arg0_14.transform:Find("torpedo")
	local var1_14 = arg0_14.transform:Find("mask/painting")
	local var2_14 = arg0_14.transform:Find("ship")

	setParent(arg0_14.painting, var1_14:Find("fitter"), false)
	setParent(arg0_14.char, var2_14, false)
	setActive(var2_14, false)
	setActive(var0_14, false)

	arg0_14.spineAnim = arg0_14.char:GetComponent("SpineAnimUI")
	arg0_14.skelegraph = arg0_14.spineAnim:GetComponent("SkeletonGraphic")
	arg0_14.aniEvent = arg0_14.transform:GetComponent("DftAniEvent")

	arg0_14:Update()
end

return var0_0
