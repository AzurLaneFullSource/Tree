local var0_0 = class("MainBannerView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scrollSnap = BannerScrollRect.New(findTF(arg1_1, "mask/content"), findTF(arg1_1, "dots"))
end

function var0_0.Init(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getBannerDisplays()

	arg0_2:UpdateItems(var0_2)

	arg0_2.banners = var0_2
end

function var0_0.Refresh(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getBannerDisplays()

	if #arg0_3.banners ~= #var0_3 then
		arg0_3:Clear()
		arg0_3:Init()
	else
		arg0_3.scrollSnap:Resume()
	end
end

function var0_0.UpdateItems(arg0_4, arg1_4)
	for iter0_4 = 0, #arg1_4 - 1 do
		local var0_4 = arg1_4[iter0_4 + 1]
		local var1_4 = arg0_4.scrollSnap:AddChild()

		LoadImageSpriteAsync("activitybanner/" .. var0_4.pic, var1_4)

		local var2_4 = var0_4.type == 3 and tonumber(var0_4.param) == nil and getProxy(ActivityProxy):readyToAchieveByType(ActivityConst.ACTIVITY_TYPE_LEVELAWARD)

		setActive(findTF(var1_4, "red"), var2_4)
		onButton(arg0_4, var1_4, function()
			arg0_4:Tracking(var0_4.id)
			MainBaseActivityBtn.Skip(arg0_4, var0_4)
		end, SFX_MAIN)
	end

	arg0_4.scrollSnap:SetUp()
end

function var0_0.Tracking(arg0_6, arg1_6)
	TrackConst.TrackingTouchBanner(arg1_6)
end

function var0_0.GetDirection(arg0_7)
	return Vector2(1, 0)
end

function var0_0.Disable(arg0_8)
	arg0_8.scrollSnap:Puase()
end

function var0_0.Clear(arg0_9)
	arg0_9.scrollSnap:Reset()
end

function var0_0.Dispose(arg0_10)
	var0_0.super.Dispose(arg0_10)
	arg0_10:Clear()
	arg0_10.scrollSnap:Dispose()

	arg0_10.scrollSnap = nil
end

return var0_0
