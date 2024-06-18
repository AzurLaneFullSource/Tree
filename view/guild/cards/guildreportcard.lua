local var0_0 = class("GuildReportCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.viewComponent = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)

	pg.DelegateInfo.New(arg0_1)

	arg0_1.bg = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.label = arg0_1._tf:Find("label"):GetComponent(typeof(Image))
	arg0_1.titleTxt = arg0_1._tf:Find("title/name"):GetComponent(typeof(Text))
	arg0_1.descTxt = arg0_1._tf:Find("desc"):GetComponent(typeof(Text))
	arg0_1.awardList = UIItemList.New(arg0_1._tf:Find("awards/content"), arg0_1._tf:Find("awards/content/item"))
	arg0_1.getBtn = arg0_1._tf:Find("get")
	arg0_1.gotBtn = arg0_1._tf:Find("got")
	arg0_1.rankBtn = arg0_1._tf:Find("rank")

	onButton(arg0_1, arg0_1.rankBtn, function()
		arg0_1.viewComponent:ShowReportRank(arg0_1.report.id)
	end, SFX_PANEL)
end

function var0_0.Update(arg0_3, arg1_3)
	arg0_3.report = arg1_3

	local var0_3 = arg1_3:GetType()

	arg0_3.bg.sprite = GetSpriteFromAtlas("ui/GuildEventReportUI_atlas", "bg_" .. var0_3)
	arg0_3.label.sprite = GetSpriteFromAtlas("ui/GuildEventReportUI_atlas", "text_" .. var0_3)

	local var1_3 = arg1_3:IsSubmited()

	setActive(arg0_3.getBtn, not var1_3)
	setActive(arg0_3.gotBtn, var1_3)

	if not var1_3 then
		setGray(arg0_3.getBtn, arg1_3:IsLock(), true)
	end

	arg0_3:UpdateAwards()

	arg0_3.titleTxt.text = arg1_3:getConfig("name")
	arg0_3.descTxt.text = arg1_3:GetReportDesc()

	local var2_3 = arg1_3:IsBoss()

	setActive(arg0_3.rankBtn, var2_3)
end

function var0_0.UpdateAwards(arg0_4)
	local var0_4, var1_4 = arg0_4.report:GetDrop()

	arg0_4.awardList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = var0_4[arg1_5 + 1]
			local var1_5 = {
				type = var0_5[1],
				id = var0_5[2],
				count = var0_5[3]
			}

			updateDrop(arg2_5, var1_5)
			onButton(arg0_4, arg2_5, function()
				arg0_4.viewComponent:emit(BaseUI.ON_DROP, var1_5)
			end, SFX_PANEL)
			setActive(arg2_5:Find("icon_bg/bouns"), arg1_5 + 1 <= var1_4)
		end
	end)
	arg0_4.awardList:align(#var0_4)
end

function var0_0.Dispose(arg0_7)
	pg.DelegateInfo.Dispose(arg0_7)
end

return var0_0
