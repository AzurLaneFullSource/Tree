local var0_0 = class("BaseWorldBossEmptyPage", import("view.base.BaseSubView"))

var0_0.Listeners = {
	onPtUpdated = "OnPtUpdated",
	onBossProgressUpdate = "OnBossProgressUpdate"
}

function var0_0.Setup(arg0_1, arg1_1)
	for iter0_1, iter1_1 in pairs(var0_0.Listeners) do
		arg0_1[iter0_1] = function(...)
			var0_0[iter1_1](arg0_1, ...)
		end
	end

	arg0_1.proxy = arg1_1

	arg0_1:AddListeners(arg0_1.proxy)
end

function var0_0.AddListeners(arg0_3, arg1_3)
	arg1_3:AddListener(WorldBossProxy.EventUnlockProgressUpdated, arg0_3.onBossProgressUpdate)
	arg1_3:AddListener(WorldBossProxy.EventPtUpdated, arg0_3.onPtUpdated)
end

function var0_0.RemoveListeners(arg0_4, arg1_4)
	arg1_4:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, arg0_4.onBossProgressUpdate)
	arg1_4:RemoveListener(WorldBossProxy.EventPtUpdated, arg0_4.onPtUpdated)
end

function var0_0.OnPtUpdated(arg0_5)
	if arg0_5:isShowing() then
		arg0_5:OnUpdatePt()
	end
end

function var0_0.OnBossProgressUpdate(arg0_6)
	if arg0_6:isShowing() then
		arg0_6:OnUpdateRes()
	end
end

function var0_0.OnLoaded(arg0_7)
	arg0_7.helpBtn = arg0_7._tf:Find("help")
	arg0_7.compass = arg0_7._tf:Find("compass")
	arg0_7.latitude = arg0_7.compass:Find("info/latitude")
	arg0_7.altitude = arg0_7.compass:Find("info/altitude")
	arg0_7.longitude = arg0_7.compass:Find("info/longitude")
	arg0_7.speed = arg0_7.compass:Find("info/speed")
	arg0_7.rader = arg0_7._tf:Find("rader/rader")
	arg0_7.progressTr = arg0_7._tf:Find("progress")
	arg0_7.progressTxt = arg0_7.progressTr:Find("value"):GetComponent(typeof(Text))
	arg0_7.activeBtn = arg0_7._tf:Find("useItem/list/tpl")
	arg0_7.useItem = arg0_7._tf:Find("useItem")
	arg0_7.noItem = arg0_7._tf:Find("noitem")
end

function var0_0.OnInit(arg0_8)
	setText(arg0_8.latitude, "000")
	setText(arg0_8.altitude, "000")
	setText(arg0_8.longitude, "000")
	setText(arg0_8.speed, "000")
	rotateAni(arg0_8.rader, 1, 3)

	if arg0_8._tf:Find("title") then
		GetComponent(arg0_8._tf:Find("title"), typeof(Image)):SetNativeSize()
	end
end

function var0_0.UpdateUseItemStyle(arg0_9, arg1_9)
	arg0_9._tf:Find("useItem/list/tpl"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg1_9, "useitem")

	arg0_9._tf:Find("useItem/list/tpl"):GetComponent(typeof(Image)):SetNativeSize()
end

function var0_0.Update(arg0_10)
	arg0_10:OnUpdate()
	arg0_10:OnUpdateRes()
	arg0_10:OnUpdatePt()
	arg0_10:Show()
end

function var0_0.OnUpdate(arg0_11)
	return
end

function var0_0.OnUpdateRes(arg0_12)
	return
end

function var0_0.OnUpdatePt(arg0_13)
	return
end

function var0_0.OnDestroy(arg0_14)
	arg0_14:RemoveListeners(arg0_14.proxy)
end

return var0_0
