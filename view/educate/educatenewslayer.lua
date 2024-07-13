local var0_0 = class("EducateNewsLayer", import(".base.EducateBaseUI"))
local var1_0 = {
	[EducateSpecialEvent.TAG_ING] = "5ACEFE",
	[EducateSpecialEvent.TAG_COMING] = "CB99FF",
	[EducateSpecialEvent.TAG_END] = "7C7E81"
}
local var2_0 = {
	[EducateSpecialEvent.TAG_ING] = "393A3C",
	[EducateSpecialEvent.TAG_COMING] = "393A3C",
	[EducateSpecialEvent.TAG_END] = "7C7E81"
}

function var0_0.getUIName(arg0_1)
	return "EducateNewsUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.curTime = getProxy(EducateProxy):GetCurTime()
	arg0_3.finishEvents = getProxy(EducateProxy):GetEventProxy():GetFinishSpecEventIds()
	arg0_3.importEvents = {}
	arg0_3.otherEvents = {}

	local var0_3 = getProxy(EducateProxy):GetPersonalityId()

	for iter0_3, iter1_3 in ipairs(pg.child_event_special.all) do
		local var1_3 = EducateSpecialEvent.New(iter1_3)

		if var1_3:IsShow() and var1_3:InMonth(arg0_3.curTime.month) and var1_3:IsUnlockSite() and var1_3:IsMatch(var0_3) then
			if var1_3:IsImport() then
				table.insert(arg0_3.importEvents, var1_3)
			elseif var1_3:IsOther() then
				table.insert(arg0_3.otherEvents, var1_3)
			end
		end
	end
end

function var0_0.findUI(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.windowTF = arg0_4:findTF("anim_root/window")
	arg0_4.tplTF = arg0_4:findTF("tpl", arg0_4.windowTF)

	setActive(arg0_4.tplTF, false)

	arg0_4.importTF = arg0_4:findTF("scrollview/view/content/import_news", arg0_4.windowTF)
	arg0_4.importUIList = UIItemList.New(arg0_4:findTF("list", arg0_4.importTF), arg0_4.tplTF)

	setText(arg0_4:findTF("title/Text", arg0_4.importTF), i18n("child_news_import_title"))
	setText(arg0_4:findTF("empty/Text", arg0_4.importTF), i18n("child_news_import_empty"))

	arg0_4.otherTF = arg0_4:findTF("scrollview/view/content/other_news", arg0_4.windowTF)
	arg0_4.otherUIList = UIItemList.New(arg0_4:findTF("list", arg0_4.otherTF), arg0_4.tplTF)

	setText(arg0_4:findTF("title/Text", arg0_4.otherTF), i18n("child_news_other_title"))
	setText(arg0_4:findTF("empty/Text", arg0_4.otherTF), i18n("child_news_other_empty"))
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6:findTF("anim_root/bg"), function()
		arg0_6:_close()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_8)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf, {
		groupName = arg0_8:getGroupNameFromData(),
		weight = arg0_8:getWeightFromData() + 1
	})
	arg0_8:initNewsList()
	arg0_8:updateNewsList()
end

function var0_0.initNewsList(arg0_9)
	arg0_9.importUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_9:updateEventItem(arg1_10, arg2_10, true)
		end
	end)
	arg0_9.otherUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_9:updateEventItem(arg1_11, arg2_11, false)
		end
	end)
end

function var0_0.updateEventItem(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg3_12 and arg0_12.importEvents[arg1_12 + 1] or arg0_12.otherEvents[arg1_12 + 1]
	local var1_12 = var0_12:GetTag(arg0_12.finishEvents, arg0_12.curTime.week)
	local var2_12 = EducateSpecialEvent.TAG2NAME[var1_12]

	setImageColor(arg0_12:findTF("block", arg2_12), Color.NewHex(var1_0[var1_12]))
	setText(arg0_12:findTF("name", arg2_12), var0_12:getConfig("main_desc"))
	setTextColor(arg0_12:findTF("name", arg2_12), Color.NewHex(var2_0[var1_12]))
	eachChild(arg0_12:findTF("name/tags", arg2_12), function(arg0_13)
		setActive(arg0_13, arg0_13.name == var2_12)
	end)
	setText(arg0_12:findTF("time/Text", arg2_12), var0_12:GetTimeDesc())
end

function var0_0.updateNewsList(arg0_14)
	local var0_14 = CompareFuncs({
		function(arg0_15)
			return arg0_15:GetTag(arg0_14.finishEvents, arg0_14.curTime.week)
		end,
		function(arg0_16)
			return arg0_16.id
		end
	})

	table.sort(arg0_14.importEvents, var0_14)
	table.sort(arg0_14.otherEvents, var0_14)
	setActive(arg0_14:findTF("empty", arg0_14.importTF), #arg0_14.importEvents <= 0)
	setActive(arg0_14:findTF("empty", arg0_14.otherTF), #arg0_14.otherEvents <= 0)
	arg0_14.importUIList:align(#arg0_14.importEvents)
	arg0_14.otherUIList:align(#arg0_14.otherEvents)
end

function var0_0._close(arg0_17)
	arg0_17.anim:Play("anim_educate_newsUI_out")
end

function var0_0.onBackPressed(arg0_18)
	arg0_18:_close()
end

function var0_0.willExit(arg0_19)
	arg0_19.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf)
end

return var0_0
