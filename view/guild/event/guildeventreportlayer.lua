local var0_0 = class("GuildEventReportLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GuildEventReportUI"
end

function var0_0.SetReports(arg0_2, arg1_2)
	arg0_2.reports = arg1_2
end

function var0_0.OnGetReportRankList(arg0_3, arg1_3)
	arg0_3.rankPage:ExecuteAction("Show", arg1_3)
end

function var0_0.init(arg0_4)
	arg0_4.scrollrect = arg0_4._tf:Find("frame/scrollrect"):GetComponent("LScrollRect")
	arg0_4.getAll = arg0_4._tf:Find("frame/get_all")
	arg0_4.gotAll = arg0_4._tf:Find("frame/get_all/gray")
	arg0_4.descTxt = arg0_4._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0_4.cntTxt = arg0_4._tf:Find("frame/cnt"):GetComponent(typeof(Text))
	arg0_4.closeBtn = arg0_4._tf:Find("frame/close")

	setText(arg0_4.getAll:Find("Text"), i18n("guild_report_get_all"))

	arg0_4._parentTf = arg0_4._tf.parent

	setText(arg0_4._tf:Find("frame/desc"), i18n("guild_report_tooltip"))

	arg0_4.rankPage = GuildBossRankPage.New(arg0_4._tf, arg0_4.event)
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.getAll, function()
		local var0_8 = {}

		for iter0_8, iter1_8 in pairs(arg0_5.reports) do
			if iter1_8:CanSubmit() then
				table.insert(var0_8, iter1_8.id)
			end
		end

		if #var0_8 == 0 then
			return
		end

		arg0_5:emit(GuildEventReportMediator.ON_SUBMIT_REPORTS, var0_8)
	end, SFX_PANEL)

	function arg0_5.scrollrect.onInitItem(arg0_9)
		arg0_5:OnInitItem(arg0_9)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_10, arg1_10)
		arg0_5:OnUpdateItem(arg0_10, arg1_10)
	end

	arg0_5:SetTotalCount()
	arg0_5:UpdateGetAllBtn()
end

function var0_0.preload(arg0_11, arg1_11)
	pg.m02:sendNotification(GAME.GET_GUILD_REPORT, {
		callback = function(arg0_12)
			arg0_11:SetReports(arg0_12)
			arg1_11()
		end
	})
end

function var0_0.getResource(arg0_13)
	local var0_13 = var0_0.super.getResource(arg0_13)
	local var1_13 = {
		"ui/GuildEventReportUI_atlas",
		"ui/GuildBossRankPage"
	}

	for iter0_13, iter1_13 in ipairs(var1_13) do
		if noEmptyStr(iter1_13) and not table.contains(var0_13, iter1_13) then
			table.insert(var0_13, iter1_13)
		end
	end

	return var0_13
end

function var0_0.UpdateReports(arg0_14, arg1_14)
	for iter0_14, iter1_14 in ipairs(arg1_14) do
		for iter2_14, iter3_14 in pairs(arg0_14.cards) do
			if iter3_14.report.id == iter1_14 then
				local var0_14 = arg0_14.reports[iter1_14]

				iter3_14:Update(var0_14)
			end
		end
	end

	arg0_14:UpdateGetAllBtn()
end

function var0_0.UpdateGetAllBtn(arg0_15)
	local var0_15 = #arg0_15.displays == 0 or _.all(arg0_15.displays, function(arg0_16)
		return not arg0_16:CanSubmit()
	end)

	setActive(arg0_15.gotAll, var0_15)
end

function var0_0.SetTotalCount(arg0_17)
	arg0_17.displays = {}

	for iter0_17, iter1_17 in pairs(arg0_17.reports) do
		table.insert(arg0_17.displays, iter1_17)
	end

	local function var0_17(arg0_18)
		if arg0_18.state == 0 then
			return 1
		elseif arg0_18.state == 1 then
			return 2
		elseif arg0_18.state == 2 then
			return 0
		end
	end

	table.sort(arg0_17.displays, function(arg0_19, arg1_19)
		return var0_17(arg0_19) > var0_17(arg1_19)
	end)
	arg0_17.scrollrect:SetTotalCount(#arg0_17.displays)

	arg0_17.cntTxt.text = #arg0_17.displays .. "/" .. GuildConst.MAX_REPORT_CNT()
end

function var0_0.OnInitItem(arg0_20, arg1_20)
	local var0_20 = GuildReportCard.New(arg1_20, arg0_20)

	if not arg0_20.cards then
		arg0_20.cards = {}
	end

	onButton(arg0_20, var0_20.getBtn, function()
		if var0_20.report:IsLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_can_not_get_tip"))

			return
		end

		arg0_20:emit(GuildEventReportMediator.ON_SUBMIT_REPORTS, {
			var0_20.report.id
		})
	end, SFX_PANEL)

	arg0_20.cards[arg1_20] = var0_20
end

function var0_0.OnUpdateItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cards[arg2_22]
	end

	local var1_22 = arg0_22.displays[arg1_22 + 1]

	var0_22:Update(var1_22)
end

function var0_0.ShowReportRank(arg0_23, arg1_23)
	arg0_23:emit(GuildEventReportMediator.GET_REPORT_RANK, arg1_23)
end

function var0_0.willExit(arg0_24)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_24._tf, arg0_24._parentTf)

	if arg0_24.cards then
		for iter0_24, iter1_24 in pairs(arg0_24.cards) do
			iter1_24:Dispose()
		end

		arg0_24.cards = nil
	end

	if arg0_24.rankPage then
		arg0_24.rankPage:Destroy()

		arg0_24.rankPage = nil
	end
end

return var0_0
