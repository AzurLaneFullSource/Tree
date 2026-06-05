local var0_0 = class("MainBannerView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scrollSnap = BannerScrollRect.New(findTF(arg1_1, "mask/content"), findTF(arg1_1, "dots"))
	arg0_1.downloadmgr = BulletinBoardMgr.Inst
	arg0_1.rawImages = {}
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

		arg0_4:UpdateItemImage(var0_4, var1_4)

		local var2_4 = var0_4.type == 3 and tonumber(var0_4.param) == nil and getProxy(ActivityProxy):readyToAchieveByType(ActivityConst.ACTIVITY_TYPE_LEVELAWARD)

		setActive(findTF(var1_4, "red"), var2_4)
		onButton(arg0_4, var1_4, function()
			arg0_4:Tracking(var0_4.id)
			MainBaseActivityBtn.Skip(arg0_4, var0_4)
		end, SFX_MAIN)
	end

	arg0_4.scrollSnap:SetUp()
end

function var0_0.GetItemPicPath(arg0_6, arg1_6)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		local var0_6 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var1_6 = arg1_6.pic_hx or {}

		if #var1_6 <= 0 then
			return arg1_6.pic
		end

		local var2_6 = _.detect(var1_6, function(arg0_7)
			return arg0_7[1] == var0_6
		end)

		if not var2_6 then
			return arg1_6.pic
		end

		do return var2_6[2] or arg1_6.pic end
		return
	end

	return arg1_6.pic
end

function var0_0.UpdateItemImage(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg2_8:Find("texture")
	local var1_8 = arg2_8:Find("image")
	local var2_8 = arg0_8:GetItemPicPath(arg1_8)
	local var3_8 = StringStartsWith(var2_8, "https://") or StringStartsWith(var2_8, "http://")

	setActive(var0_8, var3_8)
	setActive(var1_8, not var3_8)

	if var3_8 then
		arg0_8.downloadmgr:GetTexture("main_banner", "1", var2_8, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0_9)
			if arg0_8.exited or IsNil(var0_8) then
				return
			end

			local var0_9 = var0_8:GetComponent(typeof(RawImage))

			var0_9.texture = arg0_9

			table.insert(arg0_8.rawImages, var0_9)
		end))
	else
		LoadImageSpriteAsync("activitybanner/" .. var2_8, var1_8)
	end
end

function var0_0.Tracking(arg0_10, arg1_10)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildTouchBanner(arg1_10))
end

function var0_0.GetDirection(arg0_11)
	return Vector2(1, 0)
end

function var0_0.Disable(arg0_12)
	arg0_12.scrollSnap:Pause()
end

function var0_0.Clear(arg0_13)
	arg0_13.scrollSnap:Reset()
end

function var0_0.Dispose(arg0_14)
	var0_0.super.Dispose(arg0_14)

	for iter0_14, iter1_14 in ipairs(arg0_14.rawImages) do
		iter1_14.texture = nil
	end

	arg0_14.rawImages = nil

	arg0_14:Clear()
	arg0_14.scrollSnap:Dispose()

	arg0_14.scrollSnap = nil
	arg0_14.exited = true
	arg0_14.downloadmgr = nil
end

return var0_0
