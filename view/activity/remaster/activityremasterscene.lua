local var0_0 = class("ActivityRemasterScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ActivityRemasterUI"
end

function var0_0.init(arg0_2)
	arg0_2.scrollRect = arg0_2._tf:Find("list"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	setText(arg0_2._tf:Find("top/title/Text"), i18n("act_remaster_title"))
	changeToScrollText(arg0_2._tf:Find("prints/tip/Text"), i18n("act_remaster_tip_1"))
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("top/closeBtn"), function()
		arg0_5:emit(BaseUI.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/homeBtn"), function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)

	arg0_5.cards = {}
	arg0_5.activityRemasterDataList = getProxy(ActivityRemasterProxy):GetRemasterActList()

	arg0_5:InitList()
	arg0_5:UpdateActTime()
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = ActivityRemasterCard.New(arg1_8)

	onButton(arg0_8, var0_8._go, function()
		if var0_8.remasterData:IsFinish() then
			return
		end

		local var0_9 = var0_8.remasterData:GetName()
		local var1_9, var2_9 = getProxy(ActivityRemasterProxy):InActTime()

		if not var1_9 or not var2_9 then
			return
		end

		local var3_9 = pg.activity_re_timer[var2_9]

		if not var3_9 or not var3_9.timer or not var3_9.timer[3] then
			return
		end

		local var4_9 = var3_9.timer[3]
		local var5_9 = var4_9[1][1]
		local var6_9 = var4_9[1][2]
		local var7_9 = var4_9[1][3]
		local var8_9 = pg.TimeMgr.GetInstance():GetServerTime()
		local var9_9 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var5_9,
			month = var6_9,
			day = var7_9,
			hour = var4_9[2][1],
			min = var4_9[2][2],
			sec = var4_9[2][3]
		}) - var8_9 < 172800 and COLOR_RED or "#393a3c"
		local var10_9 = setColorStr(i18n("act_remaster_open_tip", var0_9, var5_9 .. "/" .. var6_9 .. "/" .. var7_9), var9_9)

		local function var11_9()
			arg0_8:emit(ActivityRemasterMediator.ACTIVE_ACT, var0_8.remasterData.id)
		end

		arg0_8.infoDisplayPage = arg0_8.infoDisplayPage or ActivityRemasterInfoDisplayPage.New(arg0_8._tf, arg0_8.event)

		arg0_8.infoDisplayPage:ExecuteAction("Show", var0_8.remasterData.id, var10_9, var11_9)
	end, SFX_PANEL)

	arg0_8.cards[arg1_8] = var0_8
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	if not arg0_11.cards[arg2_11] then
		arg0_11:OnInitItem(arg2_11)
	end

	local var0_11 = arg0_11.cards[arg2_11]
	local var1_11 = arg0_11.displays[arg1_11 + 1]

	var0_11:Update(var1_11)
end

function var0_0.UpdateActTime(arg0_12)
	local var0_12, var1_12 = getProxy(ActivityRemasterProxy):InActTime()
	local var2_12 = ""

	if var1_12 then
		local var3_12 = pg.activity_re_timer[var1_12]
		local var4_12 = var3_12.timer[2][1][2] .. "/" .. var3_12.timer[2][1][3]
		local var5_12 = var3_12.timer[3][1][2] .. "/" .. var3_12.timer[3][1][3]

		var2_12 = i18n("act_remaster_tip_2", var4_12 .. "-" .. var5_12)
	end

	setText(arg0_12._tf:Find("prints/time/Text"), var2_12)
end

function var0_0.InitList(arg0_13)
	arg0_13.displays = {}

	local var0_13 = {}
	local var1_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.activityRemasterDataList) do
		if iter1_13:IsSpecial() then
			table.insert(var0_13, iter1_13)
		else
			table.insert(var1_13, iter1_13)
		end
	end

	for iter2_13, iter3_13 in ipairs(var1_13) do
		table.insert(arg0_13.displays, iter3_13)
	end

	table.sort(arg0_13.displays, function(arg0_14, arg1_14)
		local var0_14 = arg0_14:IsFinish() and 1 or 0
		local var1_14 = arg1_14:IsFinish() and 1 or 0

		if var0_14 == var1_14 then
			return arg0_14.id > arg1_14.id
		else
			return var0_14 < var1_14
		end
	end)

	if _.all(var1_13, function(arg0_15)
		return arg0_15:IsFinish()
	end) then
		for iter4_13, iter5_13 in ipairs(var0_13) do
			table.insert(arg0_13.displays, 1, iter5_13)
		end
	end

	arg0_13.scrollRect:SetTotalCount(#arg0_13.displays)
end

function var0_0.willExit(arg0_16)
	if arg0_16.infoDisplayPage and arg0_16.infoDisplayPage:GetLoaded() then
		arg0_16.infoDisplayPage:Destroy()
	end

	arg0_16.infoDisplayPage = nil

	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		iter1_16:Dispose()
	end

	arg0_16.cards = nil
end

function var0_0.onBackPressed(arg0_17)
	if arg0_17.infoDisplayPage and arg0_17.infoDisplayPage:GetLoaded() and arg0_17.infoDisplayPage:isShowing() then
		arg0_17.infoDisplayPage:onBackPressed()

		return
	end

	arg0_17:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
