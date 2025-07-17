local var0_0 = class("DailyLevelPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.goBtn = arg0_1:findTF("bg/goBtn")
	arg0_1.levelContant = arg0_1:findTF("bg/titleText/itemList")
	arg0_1.itemGO = arg0_1:findTF("levelItem", arg0_1.levelContant)

	setText(arg0_1:findTF("bg/titleText"), i18n("open_today"))
	setText(arg0_1:findTF("bg/goBtn/Text"), i18n("daily_level_go"))

	arg0_1.itemList = UIItemList.New(arg0_1.levelContant, arg0_1.itemGO)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.goBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
	end)
	arg0_2.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.activeList[arg1_4 + 1]

			setText(arg0_2:findTF("Text", arg2_4), pg.expedition_daily_template[var0_4].title)
		end
	end)
	arg0_2.activity:SetLoginRedPoint()
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = pg.expedition_daily_template.all
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(var0_5) do
		local var2_5 = pg.expedition_daily_template[iter1_5]
		local var3_5 = var2_5.limit_period

		if var2_5.limit_type == 1 and table.contains(var2_5.weekday, tonumber(pg.TimeMgr.GetInstance():GetServerWeek())) and (not var3_5 or type(var3_5) ~= "table") then
			table.insert(var1_5, iter1_5)
		end
	end

	arg0_5.activeList = var1_5

	arg0_5.itemList:align(#var1_5)
end

return var0_0
