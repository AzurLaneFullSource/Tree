local var0 = class("EducateNewsLayer", import(".base.EducateBaseUI"))
local var1 = {
	[EducateSpecialEvent.TAG_ING] = "5ACEFE",
	[EducateSpecialEvent.TAG_COMING] = "CB99FF",
	[EducateSpecialEvent.TAG_END] = "7C7E81"
}
local var2 = {
	[EducateSpecialEvent.TAG_ING] = "393A3C",
	[EducateSpecialEvent.TAG_COMING] = "393A3C",
	[EducateSpecialEvent.TAG_END] = "7C7E81"
}

function var0.getUIName(arg0)
	return "EducateNewsUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.curTime = getProxy(EducateProxy):GetCurTime()
	arg0.finishEvents = getProxy(EducateProxy):GetEventProxy():GetFinishSpecEventIds()
	arg0.importEvents = {}
	arg0.otherEvents = {}

	local var0 = getProxy(EducateProxy):GetPersonalityId()

	for iter0, iter1 in ipairs(pg.child_event_special.all) do
		local var1 = EducateSpecialEvent.New(iter1)

		if var1:IsShow() and var1:InMonth(arg0.curTime.month) and var1:IsUnlockSite() and var1:IsMatch(var0) then
			if var1:IsImport() then
				table.insert(arg0.importEvents, var1)
			elseif var1:IsOther() then
				table.insert(arg0.otherEvents, var1)
			end
		end
	end
end

function var0.findUI(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.tplTF = arg0:findTF("tpl", arg0.windowTF)

	setActive(arg0.tplTF, false)

	arg0.importTF = arg0:findTF("scrollview/view/content/import_news", arg0.windowTF)
	arg0.importUIList = UIItemList.New(arg0:findTF("list", arg0.importTF), arg0.tplTF)

	setText(arg0:findTF("title/Text", arg0.importTF), i18n("child_news_import_title"))
	setText(arg0:findTF("empty/Text", arg0.importTF), i18n("child_news_import_empty"))

	arg0.otherTF = arg0:findTF("scrollview/view/content/other_news", arg0.windowTF)
	arg0.otherUIList = UIItemList.New(arg0:findTF("list", arg0.otherTF), arg0.tplTF)

	setText(arg0:findTF("title/Text", arg0.otherTF), i18n("child_news_other_title"))
	setText(arg0:findTF("empty/Text", arg0.otherTF), i18n("child_news_other_empty"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("anim_root/bg"), function()
		arg0:_close()
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
	arg0:initNewsList()
	arg0:updateNewsList()
end

function var0.initNewsList(arg0)
	arg0.importUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateEventItem(arg1, arg2, true)
		end
	end)
	arg0.otherUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateEventItem(arg1, arg2, false)
		end
	end)
end

function var0.updateEventItem(arg0, arg1, arg2, arg3)
	local var0 = arg3 and arg0.importEvents[arg1 + 1] or arg0.otherEvents[arg1 + 1]
	local var1 = var0:GetTag(arg0.finishEvents, arg0.curTime.week)
	local var2 = EducateSpecialEvent.TAG2NAME[var1]

	setImageColor(arg0:findTF("block", arg2), Color.NewHex(var1[var1]))
	setText(arg0:findTF("name", arg2), var0:getConfig("main_desc"))
	setTextColor(arg0:findTF("name", arg2), Color.NewHex(var2[var1]))
	eachChild(arg0:findTF("name/tags", arg2), function(arg0)
		setActive(arg0, arg0.name == var2)
	end)
	setText(arg0:findTF("time/Text", arg2), var0:GetTimeDesc())
end

function var0.updateNewsList(arg0)
	local var0 = CompareFuncs({
		function(arg0)
			return arg0:GetTag(arg0.finishEvents, arg0.curTime.week)
		end,
		function(arg0)
			return arg0.id
		end
	})

	table.sort(arg0.importEvents, var0)
	table.sort(arg0.otherEvents, var0)
	setActive(arg0:findTF("empty", arg0.importTF), #arg0.importEvents <= 0)
	setActive(arg0:findTF("empty", arg0.otherTF), #arg0.otherEvents <= 0)
	arg0.importUIList:align(#arg0.importEvents)
	arg0.otherUIList:align(#arg0.otherEvents)
end

function var0._close(arg0)
	arg0.anim:Play("anim_educate_newsUI_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
