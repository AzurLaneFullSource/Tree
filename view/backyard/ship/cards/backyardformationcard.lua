local var0_0 = class("BackYardFormationCard", import("view.ship.FormationCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.propsTr1 = arg0_1.detailTF:Find("info1")
	arg0_1.nameTr = arg0_1.detailTF:Find("name_mask")
	arg0_1.startTr = arg0_1.content:Find("front/stars")
end

function var0_0.updateProps(arg0_2, arg1_2)
	for iter0_2 = 0, 4 do
		local var0_2 = arg0_2.propsTr:GetChild(iter0_2)

		if iter0_2 < #arg1_2 then
			var0_2.gameObject:SetActive(true)

			var0_2:GetChild(0):GetComponent("Text").text = arg1_2[iter0_2 + 1][1]
			var0_2:GetChild(1):GetComponent("Text").text = arg1_2[iter0_2 + 1][2]
		else
			var0_2.gameObject:SetActive(false)
		end
	end

	setAnchoredPosition(arg0_2.nameTr, {
		y = 270
	})
	setAnchoredPosition(arg0_2.shipState, {
		y = 32
	})
	setAnchoredPosition(arg0_2.startTr, {
		y = -14
	})
	setAnchoredPosition(arg0_2.proposeMark, {
		y = 3.2
	})
end

function var0_0.updateProps1(arg0_3, arg1_3)
	for iter0_3 = 0, 2 do
		local var0_3 = arg0_3.propsTr1:GetChild(iter0_3)

		if iter0_3 < #arg1_3 then
			var0_3.gameObject:SetActive(true)

			var0_3:GetChild(0):GetComponent("Text").text = arg1_3[iter0_3 + 1][1]
			var0_3:GetChild(1):GetComponent("Text").text = arg1_3[iter0_3 + 1][2]
		else
			var0_3.gameObject:SetActive(false)
		end
	end

	setAnchoredPosition(arg0_3.nameTr, {
		y = 174
	})
	setAnchoredPosition(arg0_3.shipState, {
		y = -64
	})
	setAnchoredPosition(arg0_3.startTr, {
		y = -110
	})
	setAnchoredPosition(arg0_3.proposeMark, {
		y = -92.8
	})
end

return var0_0
