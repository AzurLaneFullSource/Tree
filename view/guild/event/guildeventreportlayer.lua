local var0 = class("GuildEventReportLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "GuildEventReportUI"
end

function var0.SetReports(arg0, arg1)
	arg0.reports = arg1
end

function var0.OnGetReportRankList(arg0, arg1)
	arg0.rankPage:ExecuteAction("Show", arg1)
end

function var0.init(arg0)
	arg0.scrollrect = arg0:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0.getAll = arg0:findTF("frame/get_all")
	arg0.gotAll = arg0:findTF("frame/get_all/gray")
	arg0.descTxt = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.cntTxt = arg0:findTF("frame/cnt"):GetComponent(typeof(Text))
	arg0.closeBtn = arg0:findTF("frame/close")

	setText(arg0.getAll:Find("Text"), i18n("guild_report_get_all"))

	arg0._parentTf = arg0._tf.parent

	setText(arg0:findTF("frame/desc"), i18n("guild_report_tooltip"))

	arg0.rankPage = GuildBossRankPage.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	pg.UIMgr:GetInstance():BlurPanel(arg0._tf)
	onButton(arg0, arg0.closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0.getAll, function()
		local var0 = {}

		for iter0, iter1 in pairs(arg0.reports) do
			if iter1:CanSubmit() then
				table.insert(var0, iter1.id)
			end
		end

		if #var0 == 0 then
			return
		end

		arg0:emit(GuildEventReportMediator.ON_SUBMIT_REPORTS, var0)
	end, SFX_PANEL)

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0:SetTotalCount()
	arg0:UpdateGetAllBtn()
end

function var0.preload(arg0, arg1)
	pg.m02:sendNotification(GAME.GET_GUILD_REPORT, {
		callback = function(arg0)
			arg0:SetReports(arg0)
			arg1()
		end
	})
end

function var0.UpdateReports(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		for iter2, iter3 in pairs(arg0.cards) do
			if iter3.report.id == iter1 then
				local var0 = arg0.reports[iter1]

				iter3:Update(var0)
			end
		end
	end

	arg0:UpdateGetAllBtn()
end

function var0.UpdateGetAllBtn(arg0)
	local var0 = #arg0.displays == 0 or _.all(arg0.displays, function(arg0)
		return not arg0:CanSubmit()
	end)

	setActive(arg0.gotAll, var0)
end

function var0.SetTotalCount(arg0)
	arg0.displays = {}

	for iter0, iter1 in pairs(arg0.reports) do
		table.insert(arg0.displays, iter1)
	end

	local function var0(arg0)
		if arg0.state == 0 then
			return 1
		elseif arg0.state == 1 then
			return 2
		elseif arg0.state == 2 then
			return 0
		end
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return var0(arg0) > var0(arg1)
	end)
	arg0.scrollrect:SetTotalCount(#arg0.displays)

	arg0.cntTxt.text = #arg0.displays .. "/" .. GuildConst.MAX_REPORT_CNT()
end

function var0.OnInitItem(arg0, arg1)
	local var0 = GuildReportCard.New(arg1, arg0)

	if not arg0.cards then
		arg0.cards = {}
	end

	onButton(arg0, var0.getBtn, function()
		if var0.report:IsLock() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_can_not_get_tip"))

			return
		end

		arg0:emit(GuildEventReportMediator.ON_SUBMIT_REPORTS, {
			var0.report.id
		})
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1)
end

function var0.ShowReportRank(arg0, arg1)
	arg0:emit(GuildEventReportMediator.GET_REPORT_RANK, arg1)
end

function var0.willExit(arg0)
	pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	if arg0.cards then
		for iter0, iter1 in pairs(arg0.cards) do
			iter1:Dispose()
		end

		arg0.cards = nil
	end

	if arg0.rankPage then
		arg0.rankPage:Destroy()

		arg0.rankPage = nil
	end
end

return var0
