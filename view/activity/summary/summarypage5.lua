local var0_0 = class("SummaryPage5", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = findTF(arg0_1._go, "share")

	onButton(arg0_1, var0_1, function()
		if arg0_1:inAnim() then
			return
		end

		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSummary)
	end, SFX_PANEL)

	local var1_1 = findTF(arg0_1._go, "frame/name")
	local var2_1 = findTF(var1_1, "Text")

	setText(var2_1, arg0_1.summaryInfoVO.name)

	local var3_1 = findTF(arg0_1._go, "frame/texts")

	arg0_1.textTFs = {}

	for iter0_1 = 1, var3_1.childCount do
		local var4_1 = var3_1:GetChild(iter0_1 - 1)
		local var5_1 = go(var4_1).name

		if var5_1 == "list" or var5_1 == "list1" then
			for iter1_1 = 1, var4_1.childCount do
				local var6_1 = var4_1:GetChild(iter1_1 - 1)
				local var7_1 = go(var6_1).name

				setActive(var6_1, (var7_1 ~= "guildName" or not not arg0_1.summaryInfoVO:hasGuild()) and (var7_1 ~= "medalCount" or not not arg0_1.summaryInfoVO:hasMedal()))

				if go(var6_1).name ~= "label" then
					if var7_1 == "guildName" or var7_1 == "chapterName" then
						setText(var6_1:Find("image/Text"), "「" .. string.gsub(arg0_1.summaryInfoVO[go(var6_1).name] .. "」", "–", "-"))
					else
						setText(var6_1:Find("image/Text"), arg0_1.summaryInfoVO[go(var6_1).name])
					end
				end
			end
		elseif var5_1 ~= "label" then
			setText(var4_1:Find("Text"), arg0_1.summaryInfoVO[var5_1])
		end

		table.insert(arg0_1.textTFs, var4_1)
	end

	setActive(arg0_1._go, false)
end

function var0_0.Clear(arg0_3)
	return
end

return var0_0
