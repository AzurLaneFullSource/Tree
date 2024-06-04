local var0 = class("WorldAchAwardSubview", import("view.base.BaseSubView"))

var0.ShowDrop = "WorldAchAwardSubview.ShowDrop"

function var0.getUIName(arg0)
	return "WorldAchAwardSubview"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.textTitle = arg0._tf:Find("title/Text")
	arg0.btnBG = arg0._tf:Find("bg")
	arg0.itemContent = arg0._tf:Find("award_list/content")
	arg0.itemList = UIItemList.New(arg0.itemContent, arg0.itemContent:Find("item"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.awards[arg1]
			local var1 = not arg0.nextStar or var0.star < arg0.nextStar
			local var2 = arg0.nextStar and var0.star == arg0.nextStar
			local var3 = arg0.nextStar and var0.star > arg0.nextStar
			local var4 = arg2:Find("award")

			setActive(var4, true)
			setActive(arg2:Find("lock_award"), false)
			updateDrop(var4, var0.drop)
			setGray(var4:Find("icon_bg"), var1 or var3)
			onButton(arg0, var4, function()
				arg0:emit(var0.ShowDrop, var0.drop)
			end, SFX_PANEL)
			setText(arg2:Find("star/count"), var0.star)
			setActive(arg2:Find("star/bg_on"), var2)
			setActive(arg2:Find("star/bg_off"), not var2)
			setActive(arg2:Find("star/lock"), var3)
			setActive(arg2:Find("ready_mark"), var2 and not var1 and not arg0.hasAward)
			setActive(arg2:Find("get_mark"), var2 and arg0.hasAward)
			setActive(arg2:Find("got_mark"), var1)
			setActive(arg2:Find("lock_mark"), var3)
			setActive(arg2:Find("mark/on"), var1)
			setActive(arg2:Find("mark/off"), not var1)
		end
	end)
	onButton(arg0, arg0.btnBG, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.isShowing(arg0)
	return arg0._tf and isActive(arg0._tf)
end

function var0.Setup(arg0, arg1)
	arg0.awards = arg1:GetAchievementAwards()

	local var0, var1 = nowWorld():AnyUnachievedAchievement(arg1)

	arg0.hasAward = var0
	arg0.nextStar = var1 and var1.star or nil

	arg0.itemList:align(#arg0.awards)
	setText(arg0._tf:Find("title/Text"), arg1:GetBaseMap():GetName())
end

return var0
