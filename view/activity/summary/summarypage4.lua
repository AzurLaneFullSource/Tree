local var0_0 = class("SummaryPage4", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = findTF(arg0_1._go, "content")
	local var1_1 = arg0_1.summaryInfoVO.furnitures
	local var2_1 = {}

	for iter0_1 = 1, var0_1.childCount do
		local var3_1 = var0_1:GetChild(iter0_1 - 1)
		local var4_1 = findTF(var3_1, "info")
		local var5_1 = tonumber(go(var3_1).name)
		local var6_1 = var1_1[var5_1]

		triggerToggle(var4_1, var6_1)

		if var6_1 then
			setText(var4_1:Find("from/Text"), var6_1:getConfig("gain_by"))
		else
			local var7_1 = pg.furniture_data_template[var5_1]

			setText(var4_1:Find("from/Text"), var7_1 and var7_1.gain_by or "--：--:--")
		end

		setText(var4_1:Find("date/Text"), var6_1 and var6_1:getDate() or i18n("summary_page_un_rearch"))
		table.insert(var2_1, var4_1)
	end

	setActive(arg0_1._go, false)
end

function var0_0.Clear(arg0_2)
	return
end

return var0_0
