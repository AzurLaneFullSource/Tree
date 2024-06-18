local var0_0 = class("InstagramCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.iconTF = arg0_1._tf:Find("head/icon")
	arg0_1.nameTxt = arg0_1._tf:Find("name")
	arg0_1.txt = arg0_1._tf:Find("Text")
	arg0_1.like = arg0_1._tf:Find("like/Text")
	arg0_1.tip = arg0_1._tf:Find("head/tip")
	arg0_1.image = arg0_1._tf:Find("image"):GetComponent(typeof(RawImage))
	arg0_1.loading = false
	arg0_1.needRefresh = false
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.instagram = arg1_2
	arg2_2 = defaultValue(arg2_2, true)

	setImageSprite(arg0_2.iconTF, LoadSprite("qicon/" .. arg1_2:GetIcon()), false)
	setText(arg0_2.nameTxt, arg1_2:GetName())
	arg0_2:LoadImage()
	setText(arg0_2.txt, arg1_2:GetContent())
	setText(arg0_2.like, arg1_2:GetLikeCnt())
	arg0_2:RemoveTimer()

	if arg2_2 then
		arg0_2:AddCommentTimer(arg1_2)
	end

	setActive(arg0_2.tip, arg1_2:ShouldShowTip())
end

function var0_0.LoadImage(arg0_3)
	if arg0_3.loading then
		arg0_3.needRefresh = true

		return
	end

	arg0_3.loading = true

	arg0_3.view:SetImageByUrl(arg0_3.instagram:GetImage(), arg0_3.image, function()
		arg0_3.loading = false

		if arg0_3.needRefresh then
			arg0_3.needRefresh = false

			arg0_3:LoadImage()
		end
	end)
end

function var0_0.AddCommentTimer(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetFastestRefreshTime()

	if var0_5 then
		local var1_5 = var0_5 - pg.TimeMgr.GetInstance():GetServerTime()

		if var1_5 <= 0 then
			arg0_5.view:emit(InstagramMediator.ON_COMMENT_LIST_UPDATE, arg1_5.id)
		else
			arg0_5.timer = Timer.New(function()
				arg0_5.view:emit(InstagramMediator.ON_COMMENT_LIST_UPDATE, arg1_5.id)
			end, var1_5, 1)

			arg0_5.timer:Start()
		end
	end
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8:RemoveTimer()

	arg0_8.loading = false
	arg0_8.needRefresh = false
end

return var0_0
