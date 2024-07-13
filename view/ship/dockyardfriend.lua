local var0_0 = class("DockyardFriend")

var0_0.DetailType0 = 0
var0_0.DetailType1 = 1
var0_0.DetailType2 = 2

local var1_0 = 0.5

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.nameTF = arg0_1.tf:Find("content/request_info/name"):GetComponent(typeof(Text))
	arg0_1.levelTF = arg0_1.tf:Find("content/request_info/lv_bg/lv/Text"):GetComponent(typeof(Text))
	arg0_1.iconTF = arg0_1.tf:Find("content/icon_contaon/icon"):GetComponent(typeof(Image))
	arg0_1.starsTF = arg0_1.tf:Find("content/icon_contaon/stars")
	arg0_1.starTF = arg0_1.tf:Find("content/icon_contaon/stars/star")
	arg0_1.date = arg0_1.tf:Find("content/date"):GetComponent(typeof(Text))
	arg0_1.manifestoTF = arg0_1.tf:Find("content/request_content/bg/Text"):GetComponent(typeof(Text))
	arg0_1.powerTF = arg0_1.tf:Find("content/item/value")
	arg0_1.propose = arg0_1.tf:Find("content/icon_contaon/propose")
	arg0_1.content = arg0_1.tf:Find("content")
	arg0_1.detail = arg0_1.tf:Find("detail")
	arg0_1.detailLayoutTr = findTF(arg0_1.detail, "layout")
	arg0_1.quit = arg0_1.tf:Find("quit_button")
	arg0_1.selectedGo = findTF(arg0_1.tf, "selected").gameObject

	arg0_1.selectedGo:SetActive(false)
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	if arg0_2.shipVO ~= arg1_2 then
		arg0_2.shipVO = arg1_2

		local var0_2 = tobool(arg1_2)

		if var0_2 then
			arg0_2.friendVO = arg2_2[arg1_2.playerId]

			arg0_2:flush()
			arg0_2:flushDetail()
		end

		setActive(arg0_2.content, var0_2)
		setActive(arg0_2.quit, not var0_2)
	end
end

function var0_0.updateSelected(arg0_3, arg1_3)
	arg0_3.selected = arg1_3

	arg0_3.selectedGo:SetActive(arg0_3.selected)

	if arg0_3.selected then
		if not arg0_3.selectedTwId then
			arg0_3.selectedTwId = LeanTween.alpha(arg0_3.selectedGo.transform, 1, var1_0):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId
		end
	elseif arg0_3.selectedTwId then
		LeanTween.cancel(arg0_3.selectedTwId)

		arg0_3.selectedTwId = nil
	end
end

function var0_0.flush(arg0_4)
	if arg0_4.shipVO then
		local var0_4 = pg.ship_data_statistics[arg0_4.shipVO.configId]

		LoadSpriteAsync("qicon/" .. arg0_4.shipVO:getPainting(), function(arg0_5)
			arg0_4.iconTF.sprite = arg0_5
		end)
		setActive(arg0_4.propose, arg0_4.shipVO:ShowPropose())

		local var1_4 = arg0_4.starsTF.childCount

		for iter0_4 = var1_4, var0_4.star - 1 do
			cloneTplTo(arg0_4.starTF, arg0_4.starsTF)
		end

		for iter1_4 = 1, var1_4 do
			local var2_4 = arg0_4.starsTF:GetChild(iter1_4 - 1)

			setActive(var2_4, iter1_4 <= var0_4.star)
		end
	end

	if arg0_4.friendVO then
		arg0_4.nameTF.text = arg0_4.friendVO.name
		arg0_4.levelTF.text = arg0_4.friendVO.level
		arg0_4.manifestoTF.text = arg0_4.friendVO.manifesto or ""

		if arg0_4.friendVO.online == Friend.ONLINE then
			arg0_4.date.text = i18n("word_online")
		else
			arg0_4.date.text = getOfflineTimeStamp(arg0_4.friendVO.preOnLineTime)
		end
	end
end

function var0_0.updateDetail(arg0_6, arg1_6)
	arg0_6.detailType = arg1_6

	arg0_6:flushDetail()
end

function var0_0.flushDetail(arg0_7)
	local var0_7 = arg0_7.shipVO
	local var1_7 = tobool(var0_7)

	if var1_7 and arg0_7.detailType > var0_0.DetailType0 then
		local var2_7 = var0_7:getShipProperties()
		local var3_7 = {
			"name",
			AttributeType.Durability,
			AttributeType.Cannon,
			AttributeType.Torpedo,
			AttributeType.Air,
			AttributeType.AntiAircraft,
			AttributeType.ArmorType,
			AttributeType.Reload,
			AttributeType.Dodge
		}
		local var4_7 = var0_7:getShipCombatPower()

		for iter0_7 = 1, 6 do
			local var5_7 = arg0_7.detailLayoutTr:GetChild(iter0_7 - 1)
			local var6_7 = var5_7:GetChild(0):GetComponent("Text")
			local var7_7 = var5_7:GetChild(1):GetComponent("Text")

			if arg0_7.detailType == var0_0.DetailType1 then
				if iter0_7 == 1 then
					var6_7.alignment = TextAnchor.MiddleCenter
					var6_7.text = arg0_7.shipVO:getName()
					var7_7.text = ""
				else
					local var8_7 = var3_7[iter0_7]

					var6_7.text = AttributeType.Type2Name(var8_7)
					var7_7.text = tostring(math.floor(var2_7[var8_7]))
				end
			elseif arg0_7.detailType == var0_0.DetailType2 then
				if iter0_7 == 6 then
					var6_7.text = "<color=#A9F548FF>" .. i18n("word_synthesize_power") .. "</color>"
					var7_7.text = tostring(var4_7)
				elseif iter0_7 == 5 then
					var6_7.text = "<color=#A9F548FF>" .. i18n("word_level") .. "</color>"
					var7_7.text = "Lv." .. arg0_7.shipVO.level
				elseif iter0_7 == 1 then
					var6_7.alignment = TextAnchor.MiddleCenter
					var6_7.text = var0_7:getShipArmorName()
					var7_7.text = ""
				elseif iter0_7 == 4 then
					var6_7.text = AttributeType.Type2Name(AttributeType.Expend)

					local var9_7 = var0_7:getBattleTotalExpend()

					var7_7.text = tostring(math.floor(var9_7))
				else
					local var10_7 = var3_7[iter0_7 + 6]

					var6_7.text = AttributeType.Type2Name(var10_7)
					var7_7.text = tostring(math.floor(var2_7[var10_7]))
				end
			end
		end
	end

	setActive(arg0_7.detail, var1_7 and arg0_7.detailType > var0_0.DetailType0)
end

function var0_0.clear(arg0_8)
	if arg0_8.selectedTwId then
		LeanTween.cancel(arg0_8.selectedTwId)

		arg0_8.selectedTwId = nil
	end
end

return var0_0
