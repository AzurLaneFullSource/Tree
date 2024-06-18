local var0_0 = class("WSAtlasBottom", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.EventUpdateScale = "WSAtlasBottom.EventUpdateScale"

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.transform

	arg0_3.rtBg = var0_3:Find("bg")
	arg0_3.rtButton = var0_3:Find("button")
	arg0_3.btnBoss = arg0_3.rtButton:Find("btn_boss")
	arg0_3.btnShop = arg0_3.rtButton:Find("btn_shop")
	arg0_3.btnOverview = arg0_3.rtButton:Find("btn_overview")
	arg0_3.btnCollection = arg0_3.rtButton:Find("btn_collection")
	arg0_3.btnDailyTask = arg0_3.rtButton:Find("btn_daily")
	arg0_3.comSilder = var0_3:Find("scale/Slider"):GetComponent("Slider")
	arg0_3.comSilder.interactable = CAMERA_MOVE_OPEN

	if CAMERA_MOVE_OPEN then
		arg0_3.comSilder.onValueChanged:AddListener(function(arg0_4)
			arg0_3:DispatchEvent(var0_0.EventUpdateScale, arg0_4)
		end)
	end
end

function var0_0.UpdateScale(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg2_5 then
		local var0_5 = arg0_5.comSilder.value

		setImageAlpha(arg0_5.btnOverview, var0_5)
		setActive(arg0_5.btnOverview, true)

		arg0_5.twId = LeanTween.value(go(arg0_5.comSilder), var0_5, arg1_5, WSAtlasWorld.baseDuration):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_6)
			arg0_5.comSilder.value = arg0_6

			setImageAlpha(arg0_5.btnOverview, arg0_6)
		end)):setOnComplete(System.Action(function()
			setActive(arg0_5.btnOverview, arg1_5 == 1)

			return existCall(arg3_5)
		end)).uniqueId

		arg0_5.wsTimer:AddTween(arg0_5.twId)
	else
		setImageAlpha(arg0_5.btnOverview, arg1_5)
		setActive(arg0_5.btnOverview, arg1_5 == 1)

		arg0_5.comSilder.value = arg1_5

		return existCall(arg3_5)
	end
end

function var0_0.CheckIsTweening(arg0_8)
	return arg0_8.twId and LeanTween.isTweening(arg0_8.twId)
end

function var0_0.SetOverSize(arg0_9, arg1_9)
	arg0_9.rtBg.offsetMin = Vector2(arg1_9, arg0_9.rtBg.offsetMin.y)
	arg0_9.rtBg.offsetMax = Vector2(-arg1_9, arg0_9.rtBg.offsetMax.y)
end

return var0_0
