local var0_0 = class("WorldAchAwardSubview", import("view.base.BaseSubView"))

var0_0.ShowDrop = "WorldAchAwardSubview.ShowDrop"

function var0_0.getUIName(arg0_1)
	return "WorldAchAwardSubview"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.textTitle = arg0_3._tf:Find("title/Text")
	arg0_3.btnBG = arg0_3._tf:Find("bg")
	arg0_3.itemContent = arg0_3._tf:Find("award_list/content")
	arg0_3.itemList = UIItemList.New(arg0_3.itemContent, arg0_3.itemContent:Find("item"))

	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.awards[arg1_4]
			local var1_4 = not arg0_3.nextStar or var0_4.star < arg0_3.nextStar
			local var2_4 = arg0_3.nextStar and var0_4.star == arg0_3.nextStar
			local var3_4 = arg0_3.nextStar and var0_4.star > arg0_3.nextStar
			local var4_4 = arg2_4:Find("award")

			setActive(var4_4, true)
			setActive(arg2_4:Find("lock_award"), false)
			updateDrop(var4_4, var0_4.drop)
			setGray(var4_4:Find("icon_bg"), var1_4 or var3_4)
			onButton(arg0_3, var4_4, function()
				arg0_3:emit(var0_0.ShowDrop, var0_4.drop)
			end, SFX_PANEL)
			setText(arg2_4:Find("star/count"), var0_4.star)
			setActive(arg2_4:Find("star/bg_on"), var2_4)
			setActive(arg2_4:Find("star/bg_off"), not var2_4)
			setActive(arg2_4:Find("star/lock"), var3_4)
			setActive(arg2_4:Find("ready_mark"), var2_4 and not var1_4 and not arg0_3.hasAward)
			setActive(arg2_4:Find("get_mark"), var2_4 and arg0_3.hasAward)
			setActive(arg2_4:Find("got_mark"), var1_4)
			setActive(arg2_4:Find("lock_mark"), var3_4)
			setActive(arg2_4:Find("mark/on"), var1_4)
			setActive(arg2_4:Find("mark/off"), not var1_4)
		end
	end)
	onButton(arg0_3, arg0_3.btnBG, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_7)
	return
end

function var0_0.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
	setActive(arg0_8._tf, true)
end

function var0_0.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
	setActive(arg0_9._tf, false)
end

function var0_0.isShowing(arg0_10)
	return arg0_10._tf and isActive(arg0_10._tf)
end

function var0_0.Setup(arg0_11, arg1_11)
	arg0_11.awards = arg1_11:GetAchievementAwards()

	local var0_11, var1_11 = nowWorld():AnyUnachievedAchievement(arg1_11)

	arg0_11.hasAward = var0_11
	arg0_11.nextStar = var1_11 and var1_11.star or nil

	arg0_11.itemList:align(#arg0_11.awards)
	setText(arg0_11._tf:Find("title/Text"), arg1_11:GetBaseMap():GetName())
end

return var0_0
