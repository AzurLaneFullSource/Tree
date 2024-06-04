local var0 = class("BackYardFormationCard", import("view.ship.FormationCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.propsTr1 = arg0.detailTF:Find("info1")
	arg0.nameTr = arg0.detailTF:Find("name_mask")
	arg0.startTr = arg0.content:Find("front/stars")
end

function var0.updateProps(arg0, arg1)
	for iter0 = 0, 4 do
		local var0 = arg0.propsTr:GetChild(iter0)

		if iter0 < #arg1 then
			var0.gameObject:SetActive(true)

			var0:GetChild(0):GetComponent("Text").text = arg1[iter0 + 1][1]
			var0:GetChild(1):GetComponent("Text").text = arg1[iter0 + 1][2]
		else
			var0.gameObject:SetActive(false)
		end
	end

	setAnchoredPosition(arg0.nameTr, {
		y = 270
	})
	setAnchoredPosition(arg0.shipState, {
		y = 32
	})
	setAnchoredPosition(arg0.startTr, {
		y = -14
	})
	setAnchoredPosition(arg0.proposeMark, {
		y = 3.2
	})
end

function var0.updateProps1(arg0, arg1)
	for iter0 = 0, 2 do
		local var0 = arg0.propsTr1:GetChild(iter0)

		if iter0 < #arg1 then
			var0.gameObject:SetActive(true)

			var0:GetChild(0):GetComponent("Text").text = arg1[iter0 + 1][1]
			var0:GetChild(1):GetComponent("Text").text = arg1[iter0 + 1][2]
		else
			var0.gameObject:SetActive(false)
		end
	end

	setAnchoredPosition(arg0.nameTr, {
		y = 174
	})
	setAnchoredPosition(arg0.shipState, {
		y = -64
	})
	setAnchoredPosition(arg0.startTr, {
		y = -110
	})
	setAnchoredPosition(arg0.proposeMark, {
		y = -92.8
	})
end

return var0
