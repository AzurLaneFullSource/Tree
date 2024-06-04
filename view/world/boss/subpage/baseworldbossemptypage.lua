local var0 = class("BaseWorldBossEmptyPage", import("view.base.BaseSubView"))

var0.Listeners = {
	onPtUpdated = "OnPtUpdated",
	onBossProgressUpdate = "OnBossProgressUpdate"
}

function var0.Setup(arg0, arg1)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.proxy = arg1

	arg0:AddListeners(arg0.proxy)
end

function var0.AddListeners(arg0, arg1)
	arg1:AddListener(WorldBossProxy.EventUnlockProgressUpdated, arg0.onBossProgressUpdate)
	arg1:AddListener(WorldBossProxy.EventPtUpdated, arg0.onPtUpdated)
end

function var0.RemoveListeners(arg0, arg1)
	arg1:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, arg0.onBossProgressUpdate)
	arg1:RemoveListener(WorldBossProxy.EventPtUpdated, arg0.onPtUpdated)
end

function var0.OnPtUpdated(arg0)
	if arg0:isShowing() then
		arg0:OnUpdatePt()
	end
end

function var0.OnBossProgressUpdate(arg0)
	if arg0:isShowing() then
		arg0:OnUpdateRes()
	end
end

function var0.OnLoaded(arg0)
	arg0.helpBtn = arg0:findTF("help")
	arg0.compass = arg0:findTF("compass")
	arg0.latitude = arg0:findTF("info/latitude", arg0.compass)
	arg0.altitude = arg0:findTF("info/altitude", arg0.compass)
	arg0.longitude = arg0:findTF("info/longitude", arg0.compass)
	arg0.speed = arg0:findTF("info/speed", arg0.compass)
	arg0.rader = arg0:findTF("rader/rader")
	arg0.progressTr = arg0:findTF("progress")
	arg0.progressTxt = arg0.progressTr:Find("value"):GetComponent(typeof(Text))
	arg0.activeBtn = arg0:findTF("useItem/list/tpl")
	arg0.useItem = arg0:findTF("useItem")
	arg0.noItem = arg0:findTF("noitem")
end

function var0.OnInit(arg0)
	setText(arg0.latitude, "000")
	setText(arg0.altitude, "000")
	setText(arg0.longitude, "000")
	setText(arg0.speed, "000")
	rotateAni(arg0.rader, 1, 3)

	if arg0:findTF("title") then
		GetComponent(arg0:findTF("title"), typeof(Image)):SetNativeSize()
	end
end

function var0.UpdateUseItemStyle(arg0, arg1)
	arg0:findTF("useItem/list/tpl"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg1, "useitem")

	arg0:findTF("useItem/list/tpl"):GetComponent(typeof(Image)):SetNativeSize()
end

function var0.Update(arg0)
	arg0:OnUpdate()
	arg0:OnUpdateRes()
	arg0:OnUpdatePt()
	arg0:Show()
end

function var0.OnUpdate(arg0)
	return
end

function var0.OnUpdateRes(arg0)
	return
end

function var0.OnUpdatePt(arg0)
	return
end

function var0.OnDestroy(arg0)
	arg0:RemoveListeners(arg0.proxy)
end

return var0
