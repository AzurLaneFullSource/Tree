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
	arg0_4.scrollrect = arg0_4:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0_4.getAll = arg0_4:findTF("frame/get_all")
	arg0_4.gotAll = arg0_4:findTF("frame/get_all/gray")
	arg0_4.descTxt = arg0_4:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_4.cntTxt = arg0_4:findTF("frame/cnt"):GetComponent(typeof(Text))
	arg0_4.closeBtn = arg0_4:findTF("frame/close")

	setText(arg0_4.getAll:Find("Text"), i18n("guild_report_get_all"))

	arg0_4._parentTf = arg0_4._tf.parent

	setText(arg0_4:findTF("frame/desc"), i18n("guild_report_tooltip"))

	arg0_4.rankPage = GuildBossRankPage.New(arg0_4._tf, arg0_4.event)
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr:GetInstance():BlurPanel(arg0_5._tf)
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

function var0_0.UpdateReports(arg0_13, arg1_13)
	for iter0_13, iter1_13 in ipairs(arg1_13) do
		for iter2_13, iter3_13 in pairs(arg0_13.cards) do
			if iter3_13.report.id == iter1_13 then
				local var0_13 = arg0_13.reports[iter1_13]

				iter3_13:Update(var0_13)
			end
		end
	end

	arg0_13:UpdateGetAllBtn()
end

function var0_0.UpdateGetAllBtn(arg0_14)
	local var0_14 = #arg0_14.displays == 0 or _.all(arg0_14.displays, function(arg0_15)
		return not arg0_15:CanSubmit()
	end)

	setActive(arg0_14.gotAll, var0_14)
end

function var0_0.SetTotalCount(arg0_16)
	arg0_16.displays = {}

	for iter0_16, iter1_16 in pairs(arg0_16.reports) do
		table.insert(arg0_16.displays, iter1_16)
	end

	local function var0_16(arg0_17)
		if arg0_17.state == 0 then
			return 1
		elseif arg0_17.state == 1 then
			return 2
		elseif arg0_17.state == 2 then
			return 0
		end
	end

	table.sort(arg0_16.displays, function(arg0_18, arg1_18)
		return var0_16(arg0_18) > var0_16(arg1_18)
	end)
	arg0_16.scrollrect:SetTotalCount(#arg0_16.displays)

	arg0_16.cntTxt.text = #arg0_16.displays .. "/" .. GuildConst.MAX_REPORT_CNT()
end

function var0_0.OnInitItem(arg0_19, arg1_19)
	local var0_19 = GuildReportCard.New(arg1_19, arg0_19)

	if not arg0_19.cards then
		arg0_19.cards = {}
	end

	onButton(arg0_19, var0_19.getBtn, function()
		if var0_19.report:IsLock() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_can_not_get_tip"))

			return
		end

		arg0_19:emit(GuildEventReportMediator.ON_SUBMIT_REPORTS, {
			var0_19.report.id
		})
	end, SFX_PANEL)

	arg0_19.cards[arg1_19] = var0_19
end

function var0_0.OnUpdateItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.cards[arg2_21]

	if not var0_21 then
		arg0_21:OnInitItem(arg2_21)

		var0_21 = arg0_21.cards[arg2_21]
	end

	local var1_21 = arg0_21.displays[arg1_21 + 1]

	var0_21:Update(var1_21)
end

function var0_0.ShowReportRank(arg0_22, arg1_22)
	arg0_22:emit(GuildEventReportMediator.GET_REPORT_RANK, arg1_22)
end

function var0_0.willExit(arg0_23)
	pg.UIMgr:GetInstance():UnblurPanel(arg0_23._tf, arg0_23._parentTf)

	if arg0_23.cards then
		for iter0_23, iter1_23 in pairs(arg0_23.cards) do
			iter1_23:Dispose()
		end

		arg0_23.cards = nil
	end

	if arg0_23.rankPage then
		arg0_23.rankPage:Destroy()

		arg0_23.rankPage = nil
	end
end

return var0_0
