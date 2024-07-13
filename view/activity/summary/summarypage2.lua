local var0_0 = class("SummaryPage2", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = findTF(arg0_1._go, "name/Text")

	setText(var0_1, arg0_1.summaryInfoVO.firstProposeName)

	local var1_1 = findTF(arg0_1._go, "texts")

	arg0_1.textTFs = {}

	for iter0_1 = 1, var1_1.childCount do
		local var2_1 = var1_1:GetChild(iter0_1 - 1)
		local var3_1 = go(var2_1).name

		if var3_1 ~= "label" then
			setText(var2_1:Find("Text"), arg0_1.summaryInfoVO[var3_1])
		end

		table.insert(arg0_1.textTFs, var2_1)
	end

	local var4_1 = findTF(arg0_1._go, "name/date")

	setText(var4_1, arg0_1.summaryInfoVO.firstLadyTime)

	local var5_1 = findTF(arg0_1._go, "painting"):Find("mask/painting")
	local var6_1 = Ship.New({
		configId = arg0_1.summaryInfoVO.firstLadyId
	}):getPainting()

	setPaintingPrefabAsync(var5_1, var6_1, "chuanwu")
	setActive(arg0_1._go, false)
end

function var0_0.Clear(arg0_2)
	return
end

return var0_0
