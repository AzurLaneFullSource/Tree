local var0 = class("SummaryPage1", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	local var0 = findTF(arg0._go, "name")
	local var1 = findTF(var0, "Text")
	local var2 = findTF(arg0._go, "painting")
	local var3 = findTF(var2, "mask/painting")

	setText(var1, arg0.summaryInfoVO.name)

	local var4 = findTF(arg0._go, "time_line")
	local var5 = {}

	for iter0 = 1, var4.childCount do
		local var6 = var4:GetChild(iter0 - 1)
		local var7 = var6:Find("texts")

		for iter1 = 1, var7.childCount do
			local var8 = var7:GetChild(iter1 - 1)
			local var9 = go(var8).name

			if var9 == "guildName" then
				local var10 = arg0.summaryInfoVO.guildName
				local var11 = not var10 or var10 == ""

				if not var11 then
					setText(var8:Find("text/Text"), "「" .. var10 .. "」")
				end

				setActive(var8:Find("image"), var11)
				setActive(var8:Find("text"), not var11)
			elseif var9 == "days" or var9 == "furnitureCount" or var9 == "furnitureWorth" then
				setText(var8:Find("Text"), arg0.summaryInfoVO[var9])
			elseif var9 ~= "label" then
				setText(var8:Find("Text"), "「" .. string.gsub(arg0.summaryInfoVO[var9], "–", "-") .. "」")
			end
		end

		table.insert(var5, var6)
	end

	local var12 = Ship.New({
		configId = arg0.summaryInfoVO.flagShipId
	}):getPainting()

	setPaintingPrefabAsync(var3, var12, "chuanwu")
	setActive(arg0._go, false)
end

return var0
