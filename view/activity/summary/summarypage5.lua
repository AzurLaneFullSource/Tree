local var0 = class("SummaryPage5", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	local var0 = findTF(arg0._go, "share")

	onButton(arg0, var0, function()
		if arg0:inAnim() then
			return
		end

		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSummary)
	end, SFX_PANEL)

	local var1 = findTF(arg0._go, "frame/name")
	local var2 = findTF(var1, "Text")

	setText(var2, arg0.summaryInfoVO.name)

	local var3 = findTF(arg0._go, "frame/texts")

	arg0.textTFs = {}

	for iter0 = 1, var3.childCount do
		local var4 = var3:GetChild(iter0 - 1)
		local var5 = go(var4).name

		if var5 == "list" or var5 == "list1" then
			for iter1 = 1, var4.childCount do
				local var6 = var4:GetChild(iter1 - 1)
				local var7 = go(var6).name

				setActive(var6, (var7 ~= "guildName" or not not arg0.summaryInfoVO:hasGuild()) and (var7 ~= "medalCount" or not not arg0.summaryInfoVO:hasMedal()))

				if go(var6).name ~= "label" then
					if var7 == "guildName" or var7 == "chapterName" then
						setText(var6:Find("image/Text"), "「" .. string.gsub(arg0.summaryInfoVO[go(var6).name] .. "」", "–", "-"))
					else
						setText(var6:Find("image/Text"), arg0.summaryInfoVO[go(var6).name])
					end
				end
			end
		elseif var5 ~= "label" then
			setText(var4:Find("Text"), arg0.summaryInfoVO[var5])
		end

		table.insert(arg0.textTFs, var4)
	end

	setActive(arg0._go, false)
end

function var0.Clear(arg0)
	return
end

return var0
