local var0 = class("MainBannerView", import("...base.MainBaseView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.scrollSnap = BannerScrollRect.New(findTF(arg1, "mask/content"), findTF(arg1, "dots"))
end

function var0.Init(arg0)
	local var0 = getProxy(ActivityProxy):getBannerDisplays()

	arg0:UpdateItems(var0)

	arg0.banners = var0
end

function var0.Refresh(arg0)
	local var0 = getProxy(ActivityProxy):getBannerDisplays()

	if #arg0.banners ~= #var0 then
		arg0:Clear()
		arg0:Init()
	else
		arg0.scrollSnap:Resume()
	end
end

function var0.UpdateItems(arg0, arg1)
	for iter0 = 0, #arg1 - 1 do
		local var0 = arg1[iter0 + 1]
		local var1 = arg0.scrollSnap:AddChild()

		LoadImageSpriteAsync("activitybanner/" .. var0.pic, var1)

		local var2 = var0.type == 3 and tonumber(var0.param) == nil and getProxy(ActivityProxy):readyToAchieveByType(ActivityConst.ACTIVITY_TYPE_LEVELAWARD)

		setActive(findTF(var1, "red"), var2)
		onButton(arg0, var1, function()
			arg0:Tracking(var0.id)
			MainBaseActivityBtn.Skip(arg0, var0)
		end, SFX_MAIN)
	end

	arg0.scrollSnap:SetUp()
end

function var0.Tracking(arg0, arg1)
	TrackConst.TrackingTouchBanner(arg1)
end

function var0.GetDirection(arg0)
	return Vector2(1, 0)
end

function var0.Disable(arg0)
	arg0.scrollSnap:Puase()
end

function var0.Clear(arg0)
	arg0.scrollSnap:Reset()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:Clear()
	arg0.scrollSnap:Dispose()

	arg0.scrollSnap = nil
end

return var0
