local var0 = class("SummaryPage4", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	local var0 = findTF(arg0._go, "content")
	local var1 = arg0.summaryInfoVO.furnitures
	local var2 = {}

	for iter0 = 1, var0.childCount do
		local var3 = var0:GetChild(iter0 - 1)
		local var4 = findTF(var3, "info")
		local var5 = tonumber(go(var3).name)
		local var6 = var1[var5]

		triggerToggle(var4, var6)

		if var6 then
			setText(var4:Find("from/Text"), var6:getConfig("gain_by"))
		else
			local var7 = pg.furniture_data_template[var5]

			setText(var4:Find("from/Text"), var7 and var7.gain_by or "--：--:--")
		end

		setText(var4:Find("date/Text"), var6 and var6:getDate() or i18n("summary_page_un_rearch"))
		table.insert(var2, var4)
	end

	setActive(arg0._go, false)
end

function var0.Clear(arg0)
	return
end

return var0
