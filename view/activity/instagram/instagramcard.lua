local var0 = class("InstagramCard")

function var0.Ctor(arg0, arg1, arg2)
	arg0.view = arg2
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.iconTF = arg0._tf:Find("head/icon")
	arg0.nameTxt = arg0._tf:Find("name")
	arg0.txt = arg0._tf:Find("Text")
	arg0.like = arg0._tf:Find("like/Text")
	arg0.tip = arg0._tf:Find("head/tip")
	arg0.image = arg0._tf:Find("image"):GetComponent(typeof(RawImage))
	arg0.loading = false
	arg0.needRefresh = false
end

function var0.Update(arg0, arg1, arg2)
	arg0.instagram = arg1
	arg2 = defaultValue(arg2, true)

	setImageSprite(arg0.iconTF, LoadSprite("qicon/" .. arg1:GetIcon()), false)
	setText(arg0.nameTxt, arg1:GetName())
	arg0:LoadImage()
	setText(arg0.txt, arg1:GetContent())
	setText(arg0.like, arg1:GetLikeCnt())
	arg0:RemoveTimer()

	if arg2 then
		arg0:AddCommentTimer(arg1)
	end

	setActive(arg0.tip, arg1:ShouldShowTip())
end

function var0.LoadImage(arg0)
	if arg0.loading then
		arg0.needRefresh = true

		return
	end

	arg0.loading = true

	arg0.view:SetImageByUrl(arg0.instagram:GetImage(), arg0.image, function()
		arg0.loading = false

		if arg0.needRefresh then
			arg0.needRefresh = false

			arg0:LoadImage()
		end
	end)
end

function var0.AddCommentTimer(arg0, arg1)
	local var0 = arg1:GetFastestRefreshTime()

	if var0 then
		local var1 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		if var1 <= 0 then
			arg0.view:emit(InstagramMediator.ON_COMMENT_LIST_UPDATE, arg1.id)
		else
			arg0.timer = Timer.New(function()
				arg0.view:emit(InstagramMediator.ON_COMMENT_LIST_UPDATE, arg1.id)
			end, var1, 1)

			arg0.timer:Start()
		end
	end
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveTimer()

	arg0.loading = false
	arg0.needRefresh = false
end

return var0
