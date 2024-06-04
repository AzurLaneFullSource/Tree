local var0 = class("GuildReportCard")

function var0.Ctor(arg0, arg1, arg2)
	arg0.viewComponent = arg2
	arg0._go = arg1
	arg0._tf = tf(arg1)

	pg.DelegateInfo.New(arg0)

	arg0.bg = arg0._tf:GetComponent(typeof(Image))
	arg0.label = arg0._tf:Find("label"):GetComponent(typeof(Image))
	arg0.titleTxt = arg0._tf:Find("title/name"):GetComponent(typeof(Text))
	arg0.descTxt = arg0._tf:Find("desc"):GetComponent(typeof(Text))
	arg0.awardList = UIItemList.New(arg0._tf:Find("awards/content"), arg0._tf:Find("awards/content/item"))
	arg0.getBtn = arg0._tf:Find("get")
	arg0.gotBtn = arg0._tf:Find("got")
	arg0.rankBtn = arg0._tf:Find("rank")

	onButton(arg0, arg0.rankBtn, function()
		arg0.viewComponent:ShowReportRank(arg0.report.id)
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1)
	arg0.report = arg1

	local var0 = arg1:GetType()

	arg0.bg.sprite = GetSpriteFromAtlas("ui/GuildEventReportUI_atlas", "bg_" .. var0)
	arg0.label.sprite = GetSpriteFromAtlas("ui/GuildEventReportUI_atlas", "text_" .. var0)

	local var1 = arg1:IsSubmited()

	setActive(arg0.getBtn, not var1)
	setActive(arg0.gotBtn, var1)

	if not var1 then
		setGray(arg0.getBtn, arg1:IsLock(), true)
	end

	arg0:UpdateAwards()

	arg0.titleTxt.text = arg1:getConfig("name")
	arg0.descTxt.text = arg1:GetReportDesc()

	local var2 = arg1:IsBoss()

	setActive(arg0.rankBtn, var2)
end

function var0.UpdateAwards(arg0)
	local var0, var1 = arg0.report:GetDrop()

	arg0.awardList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0.viewComponent:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
			setActive(arg2:Find("icon_bg/bouns"), arg1 + 1 <= var1)
		end
	end)
	arg0.awardList:align(#var0)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
