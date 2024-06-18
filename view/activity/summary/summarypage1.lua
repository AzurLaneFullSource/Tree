local var0_0 = class("SummaryPage1", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = findTF(arg0_1._go, "name")
	local var1_1 = findTF(var0_1, "Text")
	local var2_1 = findTF(arg0_1._go, "painting")
	local var3_1 = findTF(var2_1, "mask/painting")

	setText(var1_1, arg0_1.summaryInfoVO.name)

	local var4_1 = findTF(arg0_1._go, "time_line")
	local var5_1 = {}

	for iter0_1 = 1, var4_1.childCount do
		local var6_1 = var4_1:GetChild(iter0_1 - 1)
		local var7_1 = var6_1:Find("texts")

		for iter1_1 = 1, var7_1.childCount do
			local var8_1 = var7_1:GetChild(iter1_1 - 1)
			local var9_1 = go(var8_1).name

			if var9_1 == "guildName" then
				local var10_1 = arg0_1.summaryInfoVO.guildName
				local var11_1 = not var10_1 or var10_1 == ""

				if not var11_1 then
					setText(var8_1:Find("text/Text"), "「" .. var10_1 .. "」")
				end

				setActive(var8_1:Find("image"), var11_1)
				setActive(var8_1:Find("text"), not var11_1)
			elseif var9_1 == "days" or var9_1 == "furnitureCount" or var9_1 == "furnitureWorth" then
				setText(var8_1:Find("Text"), arg0_1.summaryInfoVO[var9_1])
			elseif var9_1 ~= "label" then
				setText(var8_1:Find("Text"), "「" .. string.gsub(arg0_1.summaryInfoVO[var9_1], "–", "-") .. "」")
			end
		end

		table.insert(var5_1, var6_1)
	end

	local var12_1 = Ship.New({
		configId = arg0_1.summaryInfoVO.flagShipId
	}):getPainting()

	setPaintingPrefabAsync(var3_1, var12_1, "chuanwu")
	setActive(arg0_1._go, false)
end

return var0_0
