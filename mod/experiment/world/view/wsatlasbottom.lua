local var0 = class("WSAtlasBottom", import("...BaseEntity"))

var0.Fields = {
	rtBg = "userdata",
	transform = "userdata",
	btnBoss = "userdata",
	btnOverview = "userdata",
	btnCollection = "userdata",
	rtButton = "userdata",
	wsTimer = "table",
	comSilder = "userdata",
	twId = "number",
	btnShop = "userdata",
	btnDailyTask = "userdata"
}
var0.EventUpdateScale = "WSAtlasBottom.EventUpdateScale"

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtBg = var0:Find("bg")
	arg0.rtButton = var0:Find("button")
	arg0.btnBoss = arg0.rtButton:Find("btn_boss")
	arg0.btnShop = arg0.rtButton:Find("btn_shop")
	arg0.btnOverview = arg0.rtButton:Find("btn_overview")
	arg0.btnCollection = arg0.rtButton:Find("btn_collection")
	arg0.btnDailyTask = arg0.rtButton:Find("btn_daily")
	arg0.comSilder = var0:Find("scale/Slider"):GetComponent("Slider")
	arg0.comSilder.interactable = CAMERA_MOVE_OPEN

	if CAMERA_MOVE_OPEN then
		arg0.comSilder.onValueChanged:AddListener(function(arg0)
			arg0:DispatchEvent(var0.EventUpdateScale, arg0)
		end)
	end
end

function var0.UpdateScale(arg0, arg1, arg2, arg3)
	if arg2 then
		local var0 = arg0.comSilder.value

		setImageAlpha(arg0.btnOverview, var0)
		setActive(arg0.btnOverview, true)

		arg0.twId = LeanTween.value(go(arg0.comSilder), var0, arg1, WSAtlasWorld.baseDuration):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0)
			arg0.comSilder.value = arg0

			setImageAlpha(arg0.btnOverview, arg0)
		end)):setOnComplete(System.Action(function()
			setActive(arg0.btnOverview, arg1 == 1)

			return existCall(arg3)
		end)).uniqueId

		arg0.wsTimer:AddTween(arg0.twId)
	else
		setImageAlpha(arg0.btnOverview, arg1)
		setActive(arg0.btnOverview, arg1 == 1)

		arg0.comSilder.value = arg1

		return existCall(arg3)
	end
end

function var0.CheckIsTweening(arg0)
	return arg0.twId and LeanTween.isTweening(arg0.twId)
end

function var0.SetOverSize(arg0, arg1)
	arg0.rtBg.offsetMin = Vector2(arg1, arg0.rtBg.offsetMin.y)
	arg0.rtBg.offsetMax = Vector2(-arg1, arg0.rtBg.offsetMax.y)
end

return var0
